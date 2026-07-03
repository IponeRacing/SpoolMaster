import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/cbor_lite.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/native_nfc/native_nfc.dart';

/// Service pour lire les tags NFC Prusa OpenPrintTag (ISO 15693 / NFC-V)
/// Basé sur la spécification OpenPrintTag: https://github.com/prusa3d/OpenPrintTag
class PrusaReaderService {
  /// Table des types de matériaux OpenPrintTag
  static const List<String> _materialTypes = [
    'Unknown',       // 0x00
    'PLA',           // 0x01
    'PETG',          // 0x02
    'ABS',           // 0x03
    'ASA',           // 0x04
    'PC',            // 0x05
    'PA',            // 0x06
    'PA6',           // 0x07
    'PA66',          // 0x08
    'PA6-CF',        // 0x09
    'PA6-GF',        // 0x0A
    'PA12',          // 0x0B
    'PA12-CF',       // 0x0C
    'PA612',         // 0x0D
    'PAHT-CF',       // 0x0E
    'PPA-CF',        // 0x0F
    'PPA-GF',        // 0x10
    'PP',            // 0x11
    'POM',           // 0x12
    'PVDF',          // 0x13
    'PPS',           // 0x14
    'PPS-CF',        // 0x15
    'PEI',           // 0x16
    'PEEK',          // 0x17
    'PEKK',          // 0x18
    'TPU',           // 0x19
    'TPE',           // 0x1A
    'TPC',           // 0x1B
    'HIPS',          // 0x1C
    'PVA',           // 0x1D
    'PVB',           // 0x1E
    'BVOH',          // 0x1F
    'CPE',           // 0x20
    'Metal Fill',    // 0x21
    'Wood Fill',     // 0x22
    'Carbon Fiber',  // 0x23
    'Glass Fiber',   // 0x24
    'Ceramic',       // 0x25
    'Silicone',      // 0x26
    'Wax',           // 0x27
    'Flexible',      // 0x28
    'Composite',     // 0x29
  ];

  /// Lire les données d'une bobine Prusa depuis un tag NFC ISO 15693
  static Future<BobbinData> readPrusaTag() async {
    var rawBytes = <int>[];
    try {
      final result = await NativeNfc.readOpenPrintTag();

      if (result.isEmpty) {
        throw const NfcTagReadFailure(message: 'Aucune donnée reçue du tag Prusa');
      }

      rawBytes = (result['rawBytes'] as List<dynamic>?)?.cast<int>() ?? [];

      developer.log('📄 OpenPrintTag: ${rawBytes.length} bytes lus');
      developer.log('🔍 Hex: ${rawBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');

      // Formats : OpenPrintTag officiel CBOR (oct. 2025+) puis legacy TLV
      try {
        return parseFromRawBytes(rawBytes);
      } on NfcTagReadFailure {
        developer.log('⚠️ Pas de payload OpenPrintTag trouvé');
        final hexDump = rawBytes.take(128).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
        throw NfcTagReadFailure(
          message: 'Tag Prusa lu mais format non identifié (pas de payload OpenPrintTag)',
          rawTagData: 'hex:$hexDump',
          rawBytesCount: rawBytes.length,
        );
      }
    } on PlatformException {
      // Laisser les PlatformException remonter (USER_CANCELLED, TAG_NOT_DETECTED, etc.)
      rethrow;
    } on NfcTagReadFailure {
      rethrow;
    } catch (e) {
      developer.log('❌ Erreur parsing tag Prusa: $e\n${e is Error ? e.stackTrace : ""}');
      final hexDump = rawBytes.isNotEmpty
          ? rawBytes.take(128).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')
          : null;
      throw NfcTagReadFailure(
        message: 'Erreur parsing tag Prusa: $e',
        rawTagData: hexDump != null ? 'hex:$hexDump' : null,
        rawBytesCount: rawBytes.length,
      );
    }
  }

  /// Parser des rawBytes Prusa déjà lus (pour auto-detect)
  static BobbinData parseFromRawBytes(List<int> rawBytes) {
    // 1. Format officiel OpenPrintTag (oct. 2025+) : record NDEF MIME
    //    application/vnd.openprinttag, payload CBOR (Prusament récents).
    //    ATTENTION : nos anciens tags écrits par l'app utilisent le MÊME
    //    type MIME avec un payload TLV → fallback legacy si le CBOR échoue.
    final officialPayload = _extractMimeRecordPayload(
      rawBytes,
      'application/vnd.openprinttag',
    );
    if (officialPayload != null && officialPayload.isNotEmpty) {
      try {
        final parsed = _parseOpenPrintTagCbor(officialPayload);
        developer.log('📦 OpenPrintTag officiel (CBOR) détecté');
        return parsed;
      } catch (e) {
        developer.log('⚠️ Payload non-CBOR, tentative format legacy TLV: $e');
      }
    }

    // 2. Format legacy TLV (tags écrits par les anciennes versions de l'app)
    final payload = _extractOpenPrintTagPayload(rawBytes);
    if (payload == null || payload.isEmpty) {
      throw const NfcTagReadFailure(message: 'Tag Prusa: pas de payload OpenPrintTag');
    }
    return _parseOpenPrintTagPayload(payload);
  }

  // ==================== OpenPrintTag officiel (CBOR, oct. 2025+) ====================

  /// Enum material_type de la spec OpenPrintTag (clé 9 du main map).
  /// Valeurs confirmées depuis prusa3d/OpenPrintTag data/*_fields.yaml.
  static const Map<int, String> _openPrintTagMaterials = {
    0: 'PLA',
    1: 'PETG',
    2: 'TPU',
    3: 'ABS',
    4: 'ASA',
    5: 'PC',
    6: 'PCTG',
    42: 'PA612',
  };

  /// Cherche un record NDEF d'un type MIME donné dans un dump ISO 15693
  /// (CC 4 bytes + TLV) et retourne son payload.
  static List<int>? _extractMimeRecordPayload(
    List<int> rawBytes,
    String mimeType,
  ) {
    if (rawBytes.length < 8) return null;

    var offset = 4; // Skip Capability Container

    while (offset < rawBytes.length - 2) {
      final tlvType = rawBytes[offset];
      if (tlvType == 0xFE) break;
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
        return _findMimeRecord(rawBytes.sublist(dataOffset, end), mimeType);
      }

      offset = dataOffset + tlvLength;
    }
    return null;
  }

  /// Parcourt les enregistrements d'un message NDEF et retourne le payload
  /// du premier record dont le type correspond à [mimeType].
  static List<int>? _findMimeRecord(List<int> message, String mimeType) {
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

      final recordType = String.fromCharCodes(
        message.sublist(typeStart, typeStart + typeLength),
      );

      if (recordType == mimeType) {
        return message.sublist(payloadStart, payloadStart + payloadLength);
      }

      final isLastRecord = (flags & 0x40) != 0;
      if (isLastRecord) break;
      offset = payloadStart + payloadLength;
    }
    return null;
  }

  /// Parse le payload CBOR OpenPrintTag officiel :
  /// [meta map][main region][aux region] — maps CBOR à clés entières.
  /// Spec : prusa3d/OpenPrintTag docs_src/nfc_data_format.md
  static BobbinData _parseOpenPrintTagCbor(List<int> payload) {
    // Meta map (offset 0) : 0=main_offset, 1=main_size, 2=aux_offset, 3=aux_size
    final (metaRaw, _) = CborLite.decode(payload);
    if (metaRaw is! Map) {
      throw const NfcTagReadFailure(message: 'OpenPrintTag: meta map CBOR invalide');
    }
    final meta = metaRaw;

    final mainOffset = (meta[0] as num?)?.toInt();
    if (mainOffset == null || mainOffset < 0 || mainOffset >= payload.length) {
      throw const NfcTagReadFailure(message: 'OpenPrintTag: offset main region invalide');
    }

    final (mainRaw, _) = CborLite.decode(payload, mainOffset);
    if (mainRaw is! Map) {
      throw const NfcTagReadFailure(message: 'OpenPrintTag: main map CBOR invalide');
    }
    final main = mainRaw;

    // Aux region optionnelle (poids consommé, etc.)
    Map<dynamic, dynamic>? aux;
    final auxOffset = (meta[2] as num?)?.toInt();
    if (auxOffset != null && auxOffset >= 0 && auxOffset < payload.length) {
      try {
        final (auxRaw, _) = CborLite.decode(payload, auxOffset);
        if (auxRaw is Map) aux = auxRaw;
      } catch (e) {
        developer.log('⚠️ Aux region illisible: $e');
      }
    }

    int? asInt(dynamic v) => v is num ? v.toInt() : null;
    double? asDouble(dynamic v) => v is num ? v.toDouble() : null;

    // Champs main map (clés entières, cf. spec)
    final materialTypeEnum = asInt(main[9]);
    final materialName = main[10] as String?;
    final materialAbbrev = main[52] as String?;
    final brandName = main[11] as String?;
    final nominalWeight = asInt(main[16]);
    final actualWeight = asInt(main[17]);
    final diameter = asDouble(main[30]) ?? 1.75;
    final minPrintTemp = asInt(main[34]);
    final maxPrintTemp = asInt(main[35]);
    final minBedTemp = asInt(main[37]);
    final maxBedTemp = asInt(main[38]);
    final dryingTemp = asInt(main[57]);
    final dryingTime = asInt(main[58]);

    // primary_color (clé 19) : byte string RGB(A)
    int? colorRgb;
    var colorName = 'Unknown';
    final primaryColor = main[19];
    if (primaryColor is List && primaryColor.length >= 3) {
      final r = (primaryColor[0] as num).toInt();
      final g = (primaryColor[1] as num).toInt();
      final b = (primaryColor[2] as num).toInt();
      colorRgb = (r << 16) | (g << 8) | b;
      colorName = _rgbToColorName(r, g, b);
    }

    // Matériau : nom explicite > abréviation > enum
    var filamentType = materialName?.trim() ?? '';
    if (filamentType.isEmpty) filamentType = materialAbbrev?.trim() ?? '';
    if (filamentType.isEmpty && materialTypeEnum != null) {
      filamentType = _openPrintTagMaterials[materialTypeEnum] ?? 'Unknown';
    }
    if (filamentType.isEmpty) filamentType = 'Unknown';

    // Poids restant = actual_netto_full_weight - consumed_weight (aux clé 0)
    final fullWeight = actualWeight ?? nominalWeight;
    double? remainingWeight;
    final consumed = aux != null ? asInt(aux[0]) : null;
    if (fullWeight != null && consumed != null) {
      remainingWeight = (fullWeight - consumed).toDouble().clamp(0, double.infinity);
    }

    developer.log(
      '✅ OpenPrintTag CBOR: ${brandName ?? "?"} $filamentType $colorName '
      '${fullWeight ?? "?"}g',
    );

    return BobbinData(
      filamentType: filamentType,
      color: colorName,
      weightGrams: (fullWeight ?? 1000).toDouble(),
      colorRgb: colorRgb,
      extruderTempMin: minPrintTemp,
      extruderTempMax: maxPrintTemp,
      bedTempMin: minBedTemp,
      bedTempMax: maxBedTemp,
      diameter: diameter,
      remainingWeight: remainingWeight,
      brand: brandName ?? 'Prusa',
      dryingTemp: dryingTemp,
      dryingTime: dryingTime,
    );
  }

  /// Extraire le payload OpenPrintTag depuis les données brutes ISO 15693
  /// Structure: CC (4 bytes) + NDEF TLV (type 0x03) + NDEF message + Terminator (0xFE)
  static List<int>? _extractOpenPrintTagPayload(List<int> rawBytes) {
    if (rawBytes.length < 8) return null;

    // Skip Capability Container (first 4 bytes on ISO 15693)
    var offset = 4;

    // Search for NDEF Message TLV (type = 0x03)
    while (offset < rawBytes.length - 2) {
      final tlvType = rawBytes[offset];

      if (tlvType == 0xFE) {
        // Terminator TLV
        break;
      }

      if (tlvType == 0x00) {
        // Null TLV, skip
        offset++;
        continue;
      }

      // Get TLV length
      int tlvLength;
      int dataOffset;
      if (rawBytes[offset + 1] == 0xFF) {
        // 3-byte length format
        if (offset + 3 >= rawBytes.length) break;
        tlvLength = (rawBytes[offset + 2] << 8) | rawBytes[offset + 3];
        dataOffset = offset + 4;
      } else {
        tlvLength = rawBytes[offset + 1];
        dataOffset = offset + 2;
      }

      if (tlvType == 0x03) {
        // NDEF Message TLV found
        developer.log('📦 NDEF Message TLV trouvé: offset=$dataOffset, length=$tlvLength');

        if (dataOffset + tlvLength > rawBytes.length) {
          tlvLength = rawBytes.length - dataOffset;
        }

        final ndefMessage = rawBytes.sublist(dataOffset, dataOffset + tlvLength);

        // Parse NDEF record to extract payload
        return _extractNdefRecordPayload(ndefMessage);
      }

      // Skip to next TLV
      offset = dataOffset + tlvLength;
    }

    developer.log('⚠️ Aucun NDEF Message TLV trouvé');
    return null;
  }

  /// Extraire le payload du premier enregistrement NDEF
  /// Format NDEF record: flags(1) + typeLength(1) + payloadLength(1-4) + type + payload
  static List<int>? _extractNdefRecordPayload(List<int> ndefMessage) {
    if (ndefMessage.length < 3) return null;

    var offset = 0;

    while (offset < ndefMessage.length - 3) {
      final flags = ndefMessage[offset];
      final typeLength = ndefMessage[offset + 1];

      // SR (Short Record) flag - bit 4
      final isShortRecord = (flags & 0x10) != 0;

      int payloadLength;
      int headerSize;

      if (isShortRecord) {
        payloadLength = ndefMessage[offset + 2];
        headerSize = 3 + typeLength;
      } else {
        if (offset + 5 >= ndefMessage.length) break;
        payloadLength = (ndefMessage[offset + 2] << 24) |
            (ndefMessage[offset + 3] << 16) |
            (ndefMessage[offset + 4] << 8) |
            ndefMessage[offset + 5];
        headerSize = 6 + typeLength;
      }

      if (offset + headerSize + payloadLength > ndefMessage.length) {
        payloadLength = ndefMessage.length - offset - headerSize;
        if (payloadLength < 0) break;
      }

      // TNF (Type Name Format) - bits 0-2
      final tnf = flags & 0x07;

      // Extract type string
      final typeStart = isShortRecord ? offset + 3 : offset + 6;
      final typeString = String.fromCharCodes(
        ndefMessage.sublist(typeStart, typeStart + typeLength),
      );

      developer.log('📋 NDEF Record: TNF=$tnf, type="$typeString", payloadLength=$payloadLength');

      // TNF 0x02 = MIME media type
      if (tnf == 0x02 && typeString == 'application/vnd.openprinttag') {
        final payloadStart = offset + headerSize;
        return ndefMessage.sublist(payloadStart, payloadStart + payloadLength);
      }

      // MB (Message Begin) and ME (Message End) flags
      final isLastRecord = (flags & 0x40) != 0;
      if (isLastRecord) break;

      offset += headerSize + payloadLength;
    }

    // If no OpenPrintTag MIME found, return the first record's payload as fallback
    if (ndefMessage.length > 3) {
      final flags = ndefMessage[0];
      final typeLength = ndefMessage[1];
      final isShortRecord = (flags & 0x10) != 0;

      int payloadLength;
      int headerSize;

      if (isShortRecord) {
        payloadLength = ndefMessage[2];
        headerSize = 3 + typeLength;
      } else {
        payloadLength = (ndefMessage[2] << 24) |
            (ndefMessage[3] << 16) |
            (ndefMessage[4] << 8) |
            ndefMessage[5];
        headerSize = 6 + typeLength;
      }

      if (headerSize + payloadLength <= ndefMessage.length) {
        developer.log('📋 Utilisation du premier enregistrement NDEF comme fallback');
        return ndefMessage.sublist(headerSize, headerSize + payloadLength);
      }
    }

    return null;
  }

  /// Parser le payload binaire OpenPrintTag (format TLV)
  static BobbinData _parseOpenPrintTagPayload(List<int> payload) {
    var filamentType = 'Unknown';
    var color = 'Unknown';
    int? colorRgb;
    var weightGrams = 1000.0;
    double? remainingWeight;
    int? extruderTempMin;
    int? extruderTempMax;
    int? bedTempMin;
    int? bedTempMax;
    int? spoolLength;
    double? diameter;
    var brand = 'Prusa';
    String? materialName;
    int? dryingTemp;
    int? dryingTime;
    double? nozzleSize;
    String? vendorCode;
    String? productCode;

    var offset = 0;

    while (offset < payload.length - 1) {
      final fieldTag = payload[offset];
      offset++;

      if (offset >= payload.length) break;
      final fieldLength = payload[offset];
      offset++;

      if (offset + fieldLength > payload.length) break;

      final fieldData = payload.sublist(offset, offset + fieldLength);

      switch (fieldTag) {
        case 0x01: // Material type
          if (fieldLength >= 1) {
            final materialIndex = fieldData[0];
            if (materialIndex < _materialTypes.length) {
              filamentType = _materialTypes[materialIndex];
            }
            developer.log('🧵 Material type: $filamentType (index: $materialIndex)');
          }

        case 0x02: // Color RGBA
          if (fieldLength >= 3) {
            final r = fieldData[0];
            final g = fieldData[1];
            final b = fieldData[2];
            colorRgb = (r << 16) | (g << 8) | b;
            color = _rgbToColorName(r, g, b);
            developer.log('🎨 Color: $color (RGB: $r, $g, $b)');
          }

        case 0x03: // Nozzle temp min
          if (fieldLength >= 2) {
            extruderTempMin = fieldData[0] | (fieldData[1] << 8);
            developer.log('🌡️ Nozzle temp min: $extruderTempMin°C');
          }

        case 0x04: // Nozzle temp max
          if (fieldLength >= 2) {
            extruderTempMax = fieldData[0] | (fieldData[1] << 8);
            developer.log('🌡️ Nozzle temp max: $extruderTempMax°C');
          }

        case 0x05: // Bed temp min
          if (fieldLength >= 2) {
            bedTempMin = fieldData[0] | (fieldData[1] << 8);
            developer.log('🌡️ Bed temp min: $bedTempMin°C');
          }

        case 0x06: // Bed temp max
          if (fieldLength >= 2) {
            bedTempMax = fieldData[0] | (fieldData[1] << 8);
            developer.log('🌡️ Bed temp max: $bedTempMax°C');
          }

        case 0x08: // Total weight (grams)
          if (fieldLength >= 2) {
            weightGrams = (fieldData[0] | (fieldData[1] << 8)).toDouble();
            developer.log('⚖️ Total weight: ${weightGrams}g');
          }

        case 0x09: // Remaining weight (grams)
          if (fieldLength >= 2) {
            remainingWeight = (fieldData[0] | (fieldData[1] << 8)).toDouble();
            developer.log('⚖️ Remaining weight: ${remainingWeight}g');
          }

        case 0x0A: // Spool length (meters)
          if (fieldLength >= 2) {
            spoolLength = fieldData[0] | (fieldData[1] << 8);
            developer.log('📏 Spool length: ${spoolLength}m');
          }

        case 0x0B: // Diameter (0.01mm units)
          if (fieldLength >= 2) {
            final raw = fieldData[0] | (fieldData[1] << 8);
            diameter = raw / 100.0;
            developer.log('📏 Diameter: ${diameter}mm');
          }

        case 0x3A: // Brand name (UTF-8)
          brand = String.fromCharCodes(fieldData).trim();
          if (brand.isEmpty) brand = 'Prusa';
          developer.log('🏷️ Brand: $brand');

        case 0x07: // Drying temperature (°C)
          if (fieldLength >= 2) {
            dryingTemp = fieldData[0] | (fieldData[1] << 8);
            developer.log('🌡️ Drying temp: $dryingTemp°C');
          }

        case 0x0C: // Drying time (minutes)
          if (fieldLength >= 2) {
            dryingTime = fieldData[0] | (fieldData[1] << 8);
            developer.log('⏱️ Drying time: ${dryingTime}min');
          }

        case 0x3B: // Material name (UTF-8)
          materialName = String.fromCharCodes(fieldData).trim();
          developer.log('🧵 Material name: $materialName');

        case 0x3C: // Nozzle size (0.01mm units)
          if (fieldLength >= 1) {
            final raw = fieldData[0];
            nozzleSize = raw / 100.0;
            developer.log('🔧 Nozzle size: ${nozzleSize}mm');
          }

        case 0x3D: // Vendor code (uint16 BE)
          if (fieldLength >= 2) {
            final code = (fieldData[0] << 8) | fieldData[1];
            vendorCode = code.toRadixString(16).padLeft(4, '0');
            developer.log('🏭 Vendor code: $vendorCode');
          }

        case 0x3E: // Product code (uint32 BE)
          if (fieldLength >= 4) {
            final code = (fieldData[0] << 24) | (fieldData[1] << 16) | (fieldData[2] << 8) | fieldData[3];
            productCode = code.toRadixString(16).padLeft(8, '0');
            developer.log('📦 Product code: $productCode');
          }

        default:
          developer.log('📋 Field 0x${fieldTag.toRadixString(16)}: ${fieldData.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
      }

      offset += fieldLength;
    }

    // Use material name from tag if available and more specific
    if (materialName != null && materialName.isNotEmpty) {
      filamentType = materialName;
    }

    return BobbinData(
      filamentType: filamentType,
      color: color,
      weightGrams: weightGrams,
      colorRgb: colorRgb,
      extruderTempMin: extruderTempMin,
      extruderTempMax: extruderTempMax,
      bedTempMin: bedTempMin,
      bedTempMax: bedTempMax,
      diameter: diameter,
      spoolLength: spoolLength,
      remainingWeight: remainingWeight,
      brand: brand,
      dryingTemp: dryingTemp,
      dryingTime: dryingTime,
      nozzleSize: nozzleSize,
      vendorCode: vendorCode,
      productCode: productCode,
    );
  }

  /// Convert RGB values to human-readable color name
  static String _rgbToColorName(int r, int g, int b) {
    if (r > 100 && r > g * 3 && r > b * 3) return 'Red';
    if (b > 100 && b > r && b > g) {
      if (r > 80) return 'Purple';
      return 'Blue';
    }
    if (r > 200 && g > 100 && g < r && b < 100) return 'Orange';
    if (g > 100 && g > r && g > b) return 'Green';
    if (r > 200 && g > 200 && b < 100) return 'Yellow';
    if (r > 200 && g > 150 && b > 150) return 'Pink';

    final brightness = (r + g + b) / 3;
    if (brightness < 50) return 'Black';
    if (brightness > 200) return 'White';
    if ((r - g).abs() < 30 && (g - b).abs() < 30) return 'Gray';
    if (r > 80 && g > 20 && g < r && b < 50 && brightness < 120) return 'Brown';

    return 'Unknown';
  }
}
