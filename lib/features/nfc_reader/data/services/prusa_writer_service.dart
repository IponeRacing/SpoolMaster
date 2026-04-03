import 'dart:convert';
import 'dart:developer' as developer;

import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

/// Service pour écrire les tags NFC Prusa OpenPrintTag (ISO 15693 / NFC-V)
/// Basé sur la spécification OpenPrintTag: https://github.com/prusa3d/OpenPrintTag
class PrusaWriterService {
  /// Mapping inverse: nom de matériau → index OpenPrintTag
  static int _materialNameToIndex(String materialName) {
    // Accéder à la table des matériaux du reader
    const materialTypes = [
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

    final upper = materialName.toUpperCase();

    // Chercher correspondance exacte
    for (var i = 0; i < materialTypes.length; i++) {
      if (materialTypes[i].toUpperCase() == upper) return i;
    }

    // Chercher correspondance partielle (ex: "PLA+" → PLA, "PLA High Speed" → PLA)
    for (var i = 0; i < materialTypes.length; i++) {
      if (upper.startsWith(materialTypes[i].toUpperCase())) return i;
    }

    // Chercher les variantes spéciales
    if (upper.contains('NYLON')) return 0x06; // PA
    if (upper.contains('PLA')) return 0x01;
    if (upper.contains('PETG')) return 0x02;
    if (upper.contains('ABS')) return 0x03;
    if (upper.contains('TPU')) return 0x19;

    return 0x00; // Unknown
  }

  /// Construit le payload TLV OpenPrintTag depuis un BobbinData
  static List<int> buildOpenPrintTagPayload(BobbinData data) {
    final payload = <int>[];

    // 0x01: Material type (1 byte)
    final materialIndex = _materialNameToIndex(data.filamentType);
    payload.addAll([0x01, 0x01, materialIndex]);
    developer.log('🧵 Write material: ${data.filamentType} → index $materialIndex');

    // 0x02: Color RGB (3 bytes)
    if (data.colorRgb != null) {
      final r = (data.colorRgb! >> 16) & 0xFF;
      final g = (data.colorRgb! >> 8) & 0xFF;
      final b = data.colorRgb! & 0xFF;
      payload.addAll([0x02, 0x03, r, g, b]);
      developer.log('🎨 Write color RGB: ($r, $g, $b)');
    }

    // 0x03: Nozzle temp min (2 bytes LE)
    if (data.extruderTempMin != null) {
      payload.addAll([
        0x03, 0x02,
        data.extruderTempMin! & 0xFF,
        (data.extruderTempMin! >> 8) & 0xFF,
      ]);
    }

    // 0x04: Nozzle temp max (2 bytes LE)
    if (data.extruderTempMax != null) {
      payload.addAll([
        0x04, 0x02,
        data.extruderTempMax! & 0xFF,
        (data.extruderTempMax! >> 8) & 0xFF,
      ]);
    }

    // 0x05: Bed temp min (2 bytes LE)
    if (data.bedTempMin != null) {
      payload.addAll([
        0x05, 0x02,
        data.bedTempMin! & 0xFF,
        (data.bedTempMin! >> 8) & 0xFF,
      ]);
    }

    // 0x06: Bed temp max (2 bytes LE)
    if (data.bedTempMax != null) {
      payload.addAll([
        0x06, 0x02,
        data.bedTempMax! & 0xFF,
        (data.bedTempMax! >> 8) & 0xFF,
      ]);
    }

    // 0x08: Total weight in grams (2 bytes LE)
    final weight = data.weightGrams.toInt();
    payload.addAll([
      0x08, 0x02,
      weight & 0xFF,
      (weight >> 8) & 0xFF,
    ]);

    // 0x0B: Diameter in 0.01mm units (2 bytes LE)
    if (data.diameter != null) {
      final diamRaw = (data.diameter! * 100).toInt();
      payload.addAll([
        0x0B, 0x02,
        diamRaw & 0xFF,
        (diamRaw >> 8) & 0xFF,
      ]);
    }

    // 0x3A: Brand name (UTF-8 string)
    if (data.brand != null && data.brand!.isNotEmpty) {
      final brandBytes = utf8.encode(data.brand!);
      if (brandBytes.length <= 31) {
        payload.addAll([0x3A, brandBytes.length, ...brandBytes]);
      }
    }

    // 0x3B: Material name (UTF-8 string)
    final materialBytes = utf8.encode(data.filamentType);
    if (materialBytes.length <= 31) {
      payload.addAll([0x3B, materialBytes.length, ...materialBytes]);
    }

    developer.log('📦 OpenPrintTag payload: ${payload.length} bytes');
    return payload;
  }

  /// Construit les données NDEF complètes à écrire sur un tag ISO 15693
  /// Retourne les bytes bruts incluant CC + TLV NDEF + Terminator
  static List<int> buildNdefMessage(List<int> tlvPayload) {
    // NDEF Record header
    const mimeType = 'application/vnd.openprinttag';
    final mimeTypeBytes = utf8.encode(mimeType);

    // Flags: MB=1, ME=1, CF=0, SR=1, IL=0, TNF=0x02 (MIME)
    const flags = 0xD2;
    final typeLength = mimeTypeBytes.length; // 27
    final payloadLength = tlvPayload.length;

    // Build NDEF record
    final ndefRecord = <int>[
      flags,
      typeLength,
      payloadLength,
      ...mimeTypeBytes,
      ...tlvPayload,
    ];

    // Build TLV: type=0x03 (NDEF Message), length, data
    final ndefTlv = <int>[];
    ndefTlv.add(0x03); // NDEF Message TLV type
    if (ndefRecord.length < 0xFF) {
      ndefTlv.add(ndefRecord.length);
    } else {
      ndefTlv.addAll([0xFF, (ndefRecord.length >> 8) & 0xFF, ndefRecord.length & 0xFF]);
    }
    ndefTlv.addAll(ndefRecord);

    // Terminator TLV
    ndefTlv.add(0xFE);

    // Capability Container (4 bytes)
    // E1 = NDEF magic, 40 = version 1.0 + read/write access
    // size = total data area / 8, 00 = no special features
    final dataAreaSize = ndefTlv.length;
    final ccSize = ((dataAreaSize + 7) ~/ 8).clamp(1, 255);

    final fullMessage = <int>[
      0xE1, 0x40, ccSize, 0x00, // CC
      ...ndefTlv,
    ];

    developer.log('📝 NDEF message total: ${fullMessage.length} bytes (CC=4, NDEF TLV=${ndefTlv.length})');
    return fullMessage;
  }
}
