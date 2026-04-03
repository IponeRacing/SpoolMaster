import 'dart:developer' as developer;

import 'package:flutter/services.dart';
import 'package:nfc_filament/core/errors/failures.dart';
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
        throw NfcTagReadFailure('Aucune donnée reçue du tag Prusa');
      }

      rawBytes = (result['rawBytes'] as List<dynamic>?)?.cast<int>() ?? [];

      developer.log('📄 OpenPrintTag: ${rawBytes.length} bytes lus');
      developer.log('🔍 Hex: ${rawBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');

      // Parse NDEF from ISO 15693 memory
      final payload = _extractOpenPrintTagPayload(rawBytes);

      if (payload == null || payload.isEmpty) {
        developer.log('⚠️ Pas de payload OpenPrintTag trouvé');
        final hexDump = rawBytes.take(128).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
        throw NfcTagReadFailure(
          'Tag Prusa lu mais format non identifié (pas de payload OpenPrintTag)',
          'hex:$hexDump',
          rawBytes.length,
        );
      }

      developer.log('📦 Payload OpenPrintTag: ${payload.length} bytes');
      return _parseOpenPrintTagPayload(payload);
    } on PlatformException {
      // Laisser les PlatformException remonter (USER_CANCELLED, TAG_NOT_DETECTED, etc.)
      rethrow;
    } on NfcTagReadFailure {
      rethrow;
    } catch (e) {
      final hexDump = rawBytes.isNotEmpty
          ? rawBytes.take(128).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')
          : null;
      throw NfcTagReadFailure(
        'Erreur parsing tag Prusa: $e',
        hexDump != null ? 'hex:$hexDump' : null,
        rawBytes.length,
      );
    }
  }

  /// Parser des rawBytes Prusa déjà lus (pour auto-detect)
  static BobbinData parseFromRawBytes(List<int> rawBytes) {
    final payload = _extractOpenPrintTagPayload(rawBytes);
    if (payload == null || payload.isEmpty) {
      throw NfcTagReadFailure('Tag Prusa: pas de payload OpenPrintTag');
    }
    return _parseOpenPrintTagPayload(payload);
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

        case 0x3B: // Material name (UTF-8)
          materialName = String.fromCharCodes(fieldData).trim();
          developer.log('🧵 Material name: $materialName');

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
