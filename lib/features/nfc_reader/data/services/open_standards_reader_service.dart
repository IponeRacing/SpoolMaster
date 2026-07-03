import 'dart:convert';
import 'dart:developer' as developer;

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
    // 1. Elegoo Canvas : données RAW pages 16+, APRÈS le terminator NDEF
    //    (détection par magic bytes, la plus spécifique → en premier)
    final elegoo = _tryParseElegoo(rawBytes);
    if (elegoo != null) return elegoo;

    // 2. NDEF : OpenSpool (application/json), OpenTag3D (application/opentag3d)
    final ndefRecords = _extractNdefPayloads(rawBytes);
    for (final record in ndefRecords) {
      if (record.type == 'application/opentag3d') {
        final parsed = _parseOpenTag3DPayload(record.payload);
        if (parsed != null) return parsed;
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
      bytes = bytes.sublist(1 + langLength);
    }

    final text = String.fromCharCodes(bytes).trim();
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
          colorName = _rgbToColorName(
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
          : _rgbToColorName(r, g, b),
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
      color: _rgbToColorName(r, g, b),
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

  static String _rgbToColorName(int r, int g, int b) {
    if (r > 200 && g > 200 && b > 200) return 'White';
    if (r < 50 && g < 50 && b < 50) return 'Black';
    if (r > 180 && g < 100 && b < 100) return 'Red';
    if (r < 100 && g < 100 && b > 180) return 'Blue';
    if (r < 100 && g > 150 && b < 100) return 'Green';
    if (r > 200 && g > 180 && b < 100) return 'Yellow';
    if (r > 200 && g > 100 && g < 180 && b < 80) return 'Orange';
    if (r > 150 && g < 100 && b > 150) return 'Purple';
    if (r > 200 && g < 150 && b > 150) return 'Pink';
    if (r > 100 && r < 180 && g > 60 && g < 120 && b < 80) return 'Brown';
    if ((r - g).abs() < 30 && (g - b).abs() < 30) return 'Gray';
    return 'Unknown';
  }
}

class _NdefRecord {
  const _NdefRecord({required this.type, required this.payload});
  final String type;
  final List<int> payload;
}
