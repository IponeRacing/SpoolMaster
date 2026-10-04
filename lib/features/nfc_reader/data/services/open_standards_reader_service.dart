import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/core/services/nfc_scan_diagnostics.dart';
import 'package:nfc_filament/core/utils/color_naming.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/tigertag_registry.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

/// Parseur des standards ouverts de tags filament sur NTAG21x (NFC Type 2) :
/// - OpenSpool : JSON dans un enregistrement NDEF (openspool.io)
/// - OpenTag3D v1.0 : format binaire à offsets fixes (opentag3d.info)
/// - Elegoo Canvas : NDEF non chiffré sur NTAG
///
/// Tous lisibles sur iOS et Android (pas de MiFare Classic).
class OpenStandardsReaderService {
  /// Tente de parser les rawBytes (dump pages 0..N d'un tag Type 2).
  /// Retourne null si aucun format ouvert reconnu.
  static BobbinData? tryParse(List<int> rawBytes) {
    // 1. TigerTag : magic u32 en page 4 (Sunlu, eSUN, Rosa3D... plain NTAG21x)
    final tigerTag = _tryParseTigerTag(rawBytes);
    if (tigerTag != null) return tigerTag;

    // 2. Elegoo Canvas : données RAW pages 16+, APRÈS le terminator NDEF
    //    (détection par magic bytes, la plus spécifique → en premier)
    final elegoo = _tryParseElegoo(rawBytes);
    if (elegoo != null) return elegoo;

    // 3. NDEF : OpenSpool (application/json), OpenTag3D (application/opentag3d)
    final ndefRecords = _extractNdefPayloads(rawBytes);
    for (final record in ndefRecords) {
      if (record.type == 'application/opentag3d') {
        final parsed = _parseOpenTag3DPayload(record.payload);
        if (parsed != null) return parsed;
        // Record OpenTag3D reconnu mais version/contenu non supporté :
        // erreur explicite plutôt qu'un fallthrough vers le parseur ACE
        // qui produirait une bobine fantôme depuis les bytes NDEF.
        throw const NfcTagReadFailure(
          message:
              "Tag OpenTag3D détecté mais version non supportée. Mettez à jour l'application.",
        );
      }
      final parsed = _tryParseJsonRecord(record);
      if (parsed != null) return parsed;
    }

    return null;
  }

  // ==================== NDEF (NFC Forum Type 2) ====================

  /// Extrait les payloads des enregistrements NDEF d'un dump Type 2.
  /// La zone donnée commence page 4 (offset 16) : TLV 0x03 = NDEF Message.
  static List<_NdefRecord> _extractNdefPayloads(List<int> rawBytes) {
    final records = <_NdefRecord>[];
    if (rawBytes.length < 20) return records;

    var offset = 16; // Page 4 : début de la zone utilisateur NTAG

    while (offset < rawBytes.length - 2) {
      final tlvType = rawBytes[offset];

      if (tlvType == 0xFE) break; // Terminator
      if (tlvType == 0x00) {
        offset++;
        continue;
      }

      int tlvLength;
      int dataOffset;
      if (rawBytes[offset + 1] == 0xFF) {
        if (offset + 3 >= rawBytes.length) break;
        tlvLength = (rawBytes[offset + 2] << 8) | rawBytes[offset + 3];
        dataOffset = offset + 4;
      } else {
        tlvLength = rawBytes[offset + 1];
        dataOffset = offset + 2;
      }

      if (tlvType == 0x03) {
        var end = dataOffset + tlvLength;
        if (end > rawBytes.length) end = rawBytes.length;
        records.addAll(_parseNdefMessage(rawBytes.sublist(dataOffset, end)));
        break;
      }

      offset = dataOffset + tlvLength;
    }

    return records;
  }

  /// Parse un message NDEF complet en liste d'enregistrements (type + payload)
  static List<_NdefRecord> _parseNdefMessage(List<int> message) {
    final records = <_NdefRecord>[];
    var offset = 0;

    while (offset < message.length - 2) {
      final flags = message[offset];
      final typeLength = message[offset + 1];
      final isShortRecord = (flags & 0x10) != 0;
      final hasIdLength = (flags & 0x08) != 0;

      int payloadLength;
      var headerSize = 2;

      if (isShortRecord) {
        payloadLength = message[offset + 2];
        headerSize += 1;
      } else {
        if (offset + 5 >= message.length) break;
        payloadLength = (message[offset + 2] << 24) |
            (message[offset + 3] << 16) |
            (message[offset + 4] << 8) |
            message[offset + 5];
        headerSize += 4;
      }

      var idLength = 0;
      if (hasIdLength) {
        if (offset + headerSize >= message.length) break;
        idLength = message[offset + headerSize];
        headerSize += 1;
      }

      final typeStart = offset + headerSize;
      final payloadStart = typeStart + typeLength + idLength;
      if (payloadStart + payloadLength > message.length) break;

      records.add(_NdefRecord(
        type: String.fromCharCodes(
          message.sublist(typeStart, typeStart + typeLength),
        ),
        payload: message.sublist(payloadStart, payloadStart + payloadLength),
      ));

      final isLastRecord = (flags & 0x40) != 0;
      if (isLastRecord) break;
      offset = payloadStart + payloadLength;
    }

    return records;
  }

  // ==================== OpenSpool / Elegoo (JSON NDEF) ====================

  /// OpenSpool : MIME application/json
  /// { "protocol": "openspool", "version": "1.0", "type": "PLA",
  ///   "color_hex": "FFAABB", "brand": "Generic", "min_temp": 220, "max_temp": 240 }
  /// Elegoo Canvas utilise aussi un NDEF JSON (clés similaires).
  static BobbinData? _tryParseJsonRecord(_NdefRecord record) {
    // Payload texte NDEF (type 'T') : skip status byte + code langue
    var bytes = record.payload;
    if (record.type == 'T' && bytes.length > 3) {
      final langLength = bytes[0] & 0x3F;
      if (1 + langLength >= bytes.length) return null; // payload tronqué
      bytes = bytes.sublist(1 + langLength);
    }

    final String text;
    try {
      text = utf8.decode(bytes, allowMalformed: true).trim();
    } catch (_) {
      return null;
    }
    if (!text.startsWith('{')) return null;

    try {
      final json = jsonDecode(text) as Map<String, dynamic>;

      final protocol =
          (json['protocol'] ?? json['proto'] ?? '').toString().toLowerCase();
      final isOpenSpool = protocol == 'openspool';
      final looksLikeSpool = json.containsKey('type') &&
          (json.containsKey('color_hex') || json.containsKey('brand'));

      if (!isOpenSpool && !looksLikeSpool) return null;

      final materialType = (json['type'] ?? 'Unknown').toString();
      final brand = (json['brand'] ?? (isOpenSpool ? 'OpenSpool' : 'Generic'))
          .toString();

      int? colorRgb;
      var colorName = 'Unknown';
      final colorHex = json['color_hex']?.toString().replaceAll('#', '');
      if (colorHex != null && colorHex.length >= 6) {
        colorRgb = int.tryParse(colorHex.substring(0, 6), radix: 16);
        if (colorRgb != null) {
          colorName = colorNameFromRgb(
            (colorRgb >> 16) & 0xFF,
            (colorRgb >> 8) & 0xFF,
            colorRgb & 0xFF,
          );
        }
      }

      final minTemp = _asInt(json['min_temp']);
      final maxTemp = _asInt(json['max_temp']);
      final bedMinTemp = _asInt(json['bed_min_temp'] ?? json['bed_temp']);
      final bedMaxTemp = _asInt(json['bed_max_temp']);
      final weight = _asInt(json['weight'] ?? json['weight_grams']);
      final diameter = _asDouble(json['diameter']);

      developer.log(
        '✅ Tag ${isOpenSpool ? "OpenSpool" : "JSON générique"} détecté: '
        '$brand $materialType $colorName',
      );

      return BobbinData(
        filamentType: materialType,
        color: colorName,
        weightGrams: (weight ?? 1000).toDouble(),
        manufactureDate: DateTime.now(),
        batchNumber: '$brand - $materialType',
        colorRgb: colorRgb,
        extruderTempMin: minTemp,
        extruderTempMax: maxTemp,
        bedTempMin: bedMinTemp,
        bedTempMax: bedMaxTemp,
        diameter: diameter,
        brand: brand,
      );
    } catch (e) {
      developer.log('⚠️ JSON NDEF invalide: $e');
      return null;
    }
  }

  // ==================== OpenTag3D v1.000 (binaire) ====================

  /// OpenTag3D v1.000 : payload binaire d'un record NDEF MIME
  /// `application/opentag3d`. Entiers big-endian, températures = °C ÷ 5.
  /// Spec : opentag3d.info/spec.html (section Core, offsets relatifs au
  /// payload).
  static BobbinData? _parseOpenTag3DPayload(List<int> p) {
    if (p.length >= 2) {
      final version = (p[0] << 8) | p[1];
      // v2.x : nouvelle disposition (toutes les adresses ont changé). Une
      // version mineure plus récente reste lisible (spec, « Reader
      // Implementation Guidelines ») ; une majeure inconnue est refusée.
      if (version >= 2000 && version <= 2999) return _parseOpenTag3DV2(p, version);
    }
    if (p.length < 0x64) return null; // Section Core minimale

    int u16(int off) => (p[off] << 8) | p[off + 1];
    String str(int off, int len) => String.fromCharCodes(
          p.sublist(off, off + len).where((b) => b >= 32 && b < 127),
        ).trim();

    final version = u16(0x00); // ×0.001 → 1000 = v1.000
    if (version < 1000 || version > 1999) {
      developer.log('⚠️ OpenTag3D version inattendue: $version');
      return null;
    }

    final materialBase = str(0x02, 5);
    final materialMod = str(0x07, 5);
    final manufacturer = str(0x1B, 16);
    final colorName = str(0x2B, 32);

    // color_1 RGBA à 0x4B
    final r = p[0x4B];
    final g = p[0x4C];
    final b = p[0x4D];
    final colorRgb = (r << 16) | (g << 8) | b;

    final diameterUm = u16(0x5C); // µm (1750 = 1.75mm)
    final weight = u16(0x5E); // g
    final printTemp = p[0x60] * 5; // °C
    final bedTemp = p[0x61] * 5; // °C

    // Section étendue si présente : min/max précis
    int? minPrint;
    int? maxPrint;
    int? minBed;
    int? maxBed;
    if (p.length > 0xB7) {
      minPrint = p[0xB4] > 0 ? p[0xB4] * 5 : null;
      maxPrint = p[0xB5] > 0 ? p[0xB5] * 5 : null;
      minBed = p[0xB6] > 0 ? p[0xB6] * 5 : null;
      maxBed = p[0xB7] > 0 ? p[0xB7] * 5 : null;
    }

    final materialType = materialMod.isNotEmpty
        ? '$materialBase $materialMod'
        : materialBase;

    developer.log(
      '✅ Tag OpenTag3D v${version / 1000} détecté: '
      '$manufacturer $materialType',
    );

    return BobbinData(
      filamentType: materialType.isEmpty ? 'Unknown' : materialType,
      color: colorName.isNotEmpty
          ? colorName
          : colorNameFromRgb(r, g, b),
      weightGrams: (weight > 0 ? weight : 1000).toDouble(),
      manufactureDate: DateTime.now(),
      batchNumber:
          '${manufacturer.isEmpty ? "OpenTag3D" : manufacturer} - $materialType',
      colorRgb: colorRgb,
      extruderTempMin: minPrint ?? (printTemp > 0 ? printTemp : null),
      extruderTempMax: maxPrint ?? (printTemp > 0 ? printTemp : null),
      bedTempMin: minBed ?? (bedTemp > 0 ? bedTemp : null),
      bedTempMax: maxBed ?? (bedTemp > 0 ? bedTemp : null),
      diameter: diameterUm > 0 ? diameterUm / 1000.0 : null,
      brand: manufacturer.isEmpty ? 'OpenTag3D' : manufacturer,
    );
  }

  /// OpenTag3D v2.x (mêmes conventions que la v1 : big-endian, températures
  /// ÷ 5, octets absents = 0x00). Adresses : spec.json de
  /// GooborgStudios/OpenTag3D (2.003). Validé sur une vraie bobine Polar
  /// Filament PLA Pure Light Blue (OpenRFID test/tags).
  static BobbinData? _parseOpenTag3DV2(List<int> payload, int version) {
    // « Missing bytes … treat them as 0x00 » (spec 2.001).
    final p = [...payload, ...List<int>.filled(math.max(0, 0xE0 - payload.length), 0)];
    int u16(int off) => (p[off] << 8) | p[off + 1];
    String str(int off, int len) => utf8
        .decode(p.sublist(off, off + len).takeWhile((b) => b != 0).toList(), allowMalformed: true)
        .trim();
    int? temp(int off) => p[off] > 0 ? p[off] * 5 : null;

    final materialBase = str(0x02, 5);
    final materialMod = str(0x07, 5);
    final manufacturer = str(0x0C, 16);
    final colorName = str(0x1C, 32);
    final r = p[0x3C];
    final g = p[0x3D];
    final b = p[0x3E];
    final serial = str(0x4C, 32);
    final year = u16(0x84);
    final month = p[0x86];
    final day = p[0x87];
    final diameterUm = u16(0x8C);
    final nozzle = p[0x8F] / 10;
    final printTemp = temp(0x90);
    final bedTemp = temp(0x94);
    final maxDryTemp = temp(0x9A);
    final dryHours = p[0x9B];
    final weight = u16(0x9E);
    final lengthM = u16(0xA2);

    if (materialBase.isEmpty && manufacturer.isEmpty) return null;
    final materialType =
        materialMod.isNotEmpty ? '$materialBase $materialMod' : materialBase;

    developer.log('✅ Tag OpenTag3D v${version / 1000} détecté: $manufacturer $materialType');

    return BobbinData(
      filamentType: materialType.isEmpty ? 'Unknown' : materialType,
      color: colorName.isNotEmpty ? colorName : colorNameFromRgb(r, g, b),
      weightGrams: (weight > 0 ? weight : 1000).toDouble(),
      manufactureDate: year >= 2015 && month >= 1 && month <= 12 && day >= 1 && day <= 31
          ? DateTime(year, month, day)
          : null,
      batchNumber: serial.isNotEmpty ? serial : null,
      colorRgb: (r << 16) | (g << 8) | b,
      extruderTempMin: temp(0x91) ?? printTemp,
      extruderTempMax: temp(0x92) ?? printTemp,
      bedTempMin: temp(0x95) ?? bedTemp,
      bedTempMax: temp(0x96) ?? bedTemp,
      diameter: diameterUm > 0 ? diameterUm / 1000.0 : null,
      spoolLength: lengthM > 0 ? lengthM : null,
      brand: manufacturer.isEmpty ? 'OpenTag3D' : manufacturer,
      detailedType: materialMod.isNotEmpty ? materialType : null,
      dryingTemp: maxDryTemp,
      dryingTime: dryHours > 0 ? dryHours : null,
      nozzleSize: nozzle > 0 ? nozzle : null,
    );
  }

  // ==================== TigerTag (raw NTAG21x, big-endian) ====================

  /// Magic `ID TigerTag` (u32 BE en page 4 / offset 16) → variantes reconnues.
  /// 1542820452 = TigerTag (Maker), 1816240865 = Init, 3155151767 = TigerTag+.
  static const Set<int> _kTigerTagMagics = {1542820452, 1816240865, 3155151767};

  /// TigerTag v2.x : 80 octets de données à partir de la page 4 (offset 16),
  /// big-endian, non chiffré. Le tag ne stocke que des IDs entiers → noms
  /// résolus via [kTigerTagMaterials]/[kTigerTagBrands]. Spec : SDK officiel
  /// parse_tigertag.py (github.com/TigerTag-Project/TigerTag-RFID-Guide).
  static BobbinData? _tryParseTigerTag(List<int> p) {
    // Le dump commence page 0 : la zone TigerTag débute page 4 = offset 16.
    const base = 16;
    if (p.length < base + 80) return null;

    int u16(int off) => (p[base + off] << 8) | p[base + off + 1];
    int u24(int off) =>
        (p[base + off] << 16) | (p[base + off + 1] << 8) | p[base + off + 2];
    int u32(int off) =>
        (p[base + off] << 24) |
        (p[base + off + 1] << 16) |
        (p[base + off + 2] << 8) |
        p[base + off + 3];

    // Détection : ID TigerTag (u32 BE) à l'offset +0
    if (!_kTigerTagMagics.contains(u32(0))) return null;

    final materialId = u16(8);
    final diameterId = p[base + 13];
    final brandId = u16(14);

    // Color1 RGBA (+16)
    final r = p[base + 16];
    final g = p[base + 17];
    final b = p[base + 18];
    final colorRgb = (r << 16) | (g << 8) | b;

    // Measure (+20, u24) total + ID Unit (+23) → normaliser en grammes
    final measure = u24(20);
    final unitId = p[base + 23];
    final gramsPerUnit = kTigerTagUnitToGrams[unitId] ?? 1.0;
    final weightGrams = measure * gramsPerUnit;

    // Températures : nozzle min/max (u16), bed min/max (u8), séchage
    final nozzleMin = u16(24);
    final nozzleMax = u16(26);
    final dryTemp = p[base + 28];
    final dryTime = p[base + 29];
    final bedMin = p[base + 30];
    final bedMax = p[base + 31];

    // Measure Available (+76, u24) → poids restant
    final available = u24(76);
    final remainingGrams = available * gramsPerUnit;

    // Ni matériau ni marque connus du registre ET buse implausible : tag non
    // programmé (Init vide ou contenu libre). Avant, décodé comme une bobine
    // « TigerTag Unknown » avec une buse à 21071 (texte ASCII « ROSA » lu
    // comme température). Un vrai tag aux IDs trop récents pour le registre
    // a des températures valides : il reste lu.
    bool plausibleNozzle(int t) => t >= 150 && t <= 450;
    if (!kTigerTagMaterials.containsKey(materialId) &&
        !kTigerTagBrands.containsKey(brandId) &&
        !(plausibleNozzle(u16(24)) && plausibleNozzle(u16(26)))) {
      NfcScanDiagnostics.errorDetail = 'BLANK_TAG';
      throw NfcTagReadFailure(
        message: 'TigerTag sans données de bobine (matériau $materialId et marque $brandId inconnus)',
        rawBytesCount: p.length,
      );
    }

    final material = kTigerTagMaterials[materialId] ?? 'Unknown';
    final brand = kTigerTagBrands[brandId] ?? 'TigerTag';
    final diameter = kTigerTagDiameters[diameterId];

    developer.log(
      '✅ Tag TigerTag détecté: $brand $material '
      '${weightGrams.toStringAsFixed(0)}g',
    );

    return BobbinData(
      filamentType: material,
      color: colorNameFromRgb(r, g, b),
      weightGrams: weightGrams > 0 ? weightGrams : 1000,
      manufactureDate: DateTime.now(),
      batchNumber: '$brand - $material',
      colorRgb: colorRgb,
      extruderTempMin: nozzleMin > 0 ? nozzleMin : null,
      extruderTempMax: nozzleMax > 0 ? nozzleMax : null,
      bedTempMin: bedMin > 0 ? bedMin : null,
      bedTempMax: bedMax > 0 ? bedMax : null,
      diameter: diameter != null ? double.tryParse(diameter) : null,
      remainingWeight: available > 0 ? remainingGrams : null,
      brand: brand,
      dryingTemp: dryTemp > 0 ? dryTemp : null,
      dryingTime: dryTime > 0 ? dryTime : null,
    );
  }

  // ==================== Elegoo Canvas (raw pages NTAG213) ====================

  /// Elegoo : données RAW pages 16-24 (offsets 0x40+), APRÈS le NDEF
  /// décoratif. Détection : byte 0x40 == 0x36 et manufacturer 0xEEEEEEEE.
  /// Entiers big-endian. Sources : ELEGOO-3D/ELEGOO-RFID-Tag-Guide,
  /// DnG-Crafts/ELG-RFID, Savion/elegoo-rfid-editor.
  static BobbinData? _tryParseElegoo(List<int> p) {
    if (p.length < 0x60) return null;

    // Magic : header 0x36 + manufacturer EE EE EE EE
    if (p[0x40] != 0x36 ||
        p[0x41] != 0xEE ||
        p[0x42] != 0xEE ||
        p[0x43] != 0xEE ||
        p[0x44] != 0xEE) {
      return null;
    }

    int u16(int off) => (p[off] << 8) | p[off + 1];

    // Material code : chaque byte encode la valeur ASCII décimale en
    // "nibbles décimaux" (0x80 → 8*10+0 = 80 = 'P'). Fallback ASCII direct.
    String decodeMaterial(List<int> bytes) {
      final chars = <int>[];
      for (final byte in bytes) {
        if (byte == 0) continue;
        final hi = (byte >> 4) & 0xF;
        final lo = byte & 0xF;
        if (hi <= 9 && lo <= 9) {
          final ascii = hi * 10 + lo;
          if (ascii >= 32 && ascii < 127) {
            chars.add(ascii);
            continue;
          }
        }
        if (byte >= 32 && byte < 127) chars.add(byte); // ASCII direct
      }
      return String.fromCharCodes(chars).trim();
    }

    final material = decodeMaterial(p.sublist(0x48, 0x4C));

    final r = p[0x50];
    final g = p[0x51];
    final b = p[0x52];
    final colorRgb = (r << 16) | (g << 8) | b;

    final nozzleMin = u16(0x54);
    final nozzleMax = u16(0x56);
    final diameterRaw = u16(0x5C); // ×100 (0x00AF = 1.75mm)
    final weight = p.length >= 0x60 ? u16(0x5E) : 0;

    developer.log('✅ Tag Elegoo détecté: $material RGB($r,$g,$b)');

    return BobbinData(
      filamentType: material.isEmpty ? 'Unknown' : material,
      color: colorNameFromRgb(r, g, b),
      weightGrams: (weight > 0 ? weight : 1000).toDouble(),
      manufactureDate: DateTime.now(),
      batchNumber: 'Elegoo - $material',
      colorRgb: colorRgb,
      extruderTempMin: nozzleMin > 0 && nozzleMin < 500 ? nozzleMin : null,
      extruderTempMax: nozzleMax > 0 && nozzleMax < 500 ? nozzleMax : null,
      diameter: diameterRaw > 0 ? diameterRaw / 100.0 : null,
      brand: 'Elegoo',
    );
  }

  // ==================== Helpers ====================

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v.toString());
  }

  static double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }
}

class _NdefRecord {
  const _NdefRecord({required this.type, required this.payload});
  final String type;
  final List<int> payload;
}
