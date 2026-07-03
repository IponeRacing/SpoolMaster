// Tests E2E du pipeline NFC complet côté Dart :
// channel natif mocké → NfcDataSourceImpl → parseurs → BobbinDataModel.
// Les dumps de tags reproduisent les layouts confirmés des specs/dumps réels.

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/data/datasources/nfc_datasource_impl.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/prusa_writer_service.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

const _channel = MethodChannel('com.anycubic.nfc/native');

/// Mocke le channel natif pour renvoyer [response] à toutes les méthodes.
void mockNativeChannel(Map<String, dynamic> response) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_channel, (call) async => response);
}

// ==================== Fixtures de dumps ====================

/// Dump d'un tag ACE Pro OFFICIEL (NTAG213), valeurs du dump réel
/// documenté dans DnG-Crafts/ACE-RFID (docs/AnycubicScans) :
/// magic 0x7B v0x65, brand "AC", material "PLA+", ABGR blanc,
/// buse 205-215°C, bed 50-60°C, 1.75mm, 330m, 1000g.
List<int> buildGenuineAceDump() {
  final d = List<int>.filled(160, 0)
    // Pages 0-3 : UID + CC NTAG213
    ..setRange(12, 16, [0xE1, 0x10, 0x12, 0x00])
    // Page 4 : magic + version
    ..setRange(16, 20, [0x7B, 0x00, 0x65, 0x00])
    // Pages 10-13 (bytes 40+) : brand
    ..setRange(40, 42, 'AC'.codeUnits)
    // Pages 15-18 (bytes 60+) : material
    ..setRange(60, 64, 'PLA+'.codeUnits)
    // Page 20 (bytes 80-83) : couleur ABGR (blanc F0F0ED)
    ..setRange(80, 84, [0xFF, 0xED, 0xF0, 0xF0])
    // Page 24 (bytes 96-99) : buse min/max LE (205/215)
    ..setRange(96, 100, [0xCD, 0x00, 0xD7, 0x00])
    // Page 29 (bytes 116-119) : bed min/max LE (50/60)
    ..setRange(116, 120, [0x32, 0x00, 0x3C, 0x00])
    // Page 30 (bytes 120-123) : diamètre 175 / longueur 330 LE
    ..setRange(120, 124, [0xAF, 0x00, 0x4A, 0x01])
    // Page 31 (bytes 124-127) : poids 1000 LE
    ..setRange(124, 128, [0xE8, 0x03, 0x00, 0x00]);
  return d;
}

/// Tag Anycubic classique avec SKU ASCII (AHPLBW-107 = PLA High Speed blanc)
List<int> buildAnycubicSkuDump() {
  final d = List<int>.filled(160, 0);
  final sku = 'AHPLBW-107'.codeUnits;
  d.setRange(32, 32 + sku.length, sku);
  return d;
}

/// Tag OpenSpool (JSON NDEF) sur NTAG21x
List<int> buildOpenSpoolDump() {
  final json = utf8.encode(jsonEncode({
    'protocol': 'openspool',
    'version': '1.0',
    'type': 'PETG',
    'color_hex': '00FF00',
    'brand': 'eSun',
    'min_temp': '230',
    'max_temp': '250',
  }));
  const mime = 'application/json';
  final record = [0xC0 | 0x10 | 0x02, mime.length, json.length, ...mime.codeUnits, ...json];
  final d = <int>[
    ...List<int>.filled(12, 0), 0xE1, 0x10, 0x3E, 0x00, // pages 0-3
    0x03, record.length, ...record, 0xFE,
  ];
  while (d.length < 160) {
    d.add(0);
  }
  return d;
}

/// Tag entièrement vide (échec attendu, sans crash)
List<int> buildEmptyDump() => List<int>.filled(160, 0);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final datasource = NfcDataSourceImpl();

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  });

  group('E2E mode Anycubic (readBobbinData)', () {
    test('tag ACE Pro officiel → champs explicites parsés', () async {
      mockNativeChannel({'data': '', 'rawBytes': buildGenuineAceDump()});

      final result = await datasource.readBobbinData(nfcMode: 'anycubic');

      expect(result.filamentType, 'PLA+');
      expect(result.batchNumber, contains('AC'));
      expect(result.extruderTempMin, 205);
      expect(result.extruderTempMax, 215);
      expect(result.bedTempMin, 50);
      expect(result.bedTempMax, 60);
      expect(result.diameter, closeTo(1.75, 0.001));
      expect(result.spoolLength, 330);
      expect(result.weightGrams, 1000);
      // ABGR FF,ED,F0,F0 → RGB (F0,F0,ED)
      expect(result.colorRgb, 0xF0F0ED);
    });

    test('tag Anycubic SKU → matériau et couleur du SKU', () async {
      mockNativeChannel({'data': '', 'rawBytes': buildAnycubicSkuDump()});

      final result = await datasource.readBobbinData(nfcMode: 'anycubic');

      expect(result.filamentType, 'PLA High Speed');
      expect(result.color, 'White');
    });

    test('tag OpenSpool scanné en mode Anycubic → reconnu (plus de "Tag vide")',
        () async {
      mockNativeChannel({'data': '', 'rawBytes': buildOpenSpoolDump()});

      final result = await datasource.readBobbinData(nfcMode: 'anycubic');

      expect(result.filamentType, 'PETG');
      expect(result.brand, 'eSun');
      expect(result.extruderTempMin, 230);
      expect(result.extruderTempMax, 250);
      expect(result.color, 'Green');
    });

    test('tag vide → NfcTagReadFailure explicite, pas de crash', () async {
      mockNativeChannel({'data': '', 'rawBytes': buildEmptyDump()});

      await expectLater(
        datasource.readBobbinData(nfcMode: 'anycubic'),
        throwsA(isA<NfcTagReadFailure>()),
      );
    });
  });

  group('E2E auto-detect (readBobbinDataAutoDetect)', () {
    test('ultralight + OpenSpool → parsé via standards ouverts', () async {
      mockNativeChannel({
        'tagType': 'ultralight',
        'data': '',
        'rawBytes': buildOpenSpoolDump(),
      });

      final result = await datasource.readBobbinDataAutoDetect();

      expect(result.filamentType, 'PETG');
      expect(result.brand, 'eSun');
    });

    test('ultralight + ACE officiel → champs explicites', () async {
      mockNativeChannel({
        'tagType': 'ultralight',
        'data': '',
        'rawBytes': buildGenuineAceDump(),
      });

      final result = await datasource.readBobbinDataAutoDetect();

      expect(result.filamentType, 'PLA+');
      expect(result.weightGrams, 1000);
    });
  });

  group('E2E entrées adversariales (findings revue de code)', () {
    test('dump ACE partiel (32 bytes, magic présent) → erreur propre, pas de RangeError',
        () async {
      final partial = buildGenuineAceDump().sublist(0, 32);
      mockNativeChannel({'data': '', 'rawBytes': partial});

      await expectLater(
        datasource.readBobbinData(nfcMode: 'anycubic'),
        throwsA(
          isA<NfcTagReadFailure>().having(
            (f) => f.message,
            'message',
            isNot(contains('RangeError')),
          ),
        ),
      );
    });

    test('NDEF tronqué avec flag IL en fin de message → pas de crash', () async {
      // TLV 03 03 + record [flags 0x59 = ME|SR|IL, typeLen 0, payloadLen 0]
      final d = <int>[
        ...List<int>.filled(12, 0), 0xE1, 0x10, 0x3E, 0x00,
        0x03, 0x03, 0x59, 0x00, 0x00, 0xFE,
      ];
      while (d.length < 160) {
        d.add(0);
      }
      mockNativeChannel({'data': '', 'rawBytes': d});

      // Doit échouer proprement (tag sans données), pas de RangeError
      await expectLater(
        datasource.readBobbinData(nfcMode: 'anycubic'),
        throwsA(
          isA<NfcTagReadFailure>().having(
            (f) => f.message,
            'message',
            isNot(contains('RangeError')),
          ),
        ),
      );
    });

    test('record texte avec code langue déclaré plus long que le payload → pas de crash',
        () async {
      // Payload [0x3F, 'e', 'n', '{'] : langLength 63 > payload 4 bytes
      final record = [0xC0 | 0x10 | 0x01, 1, 4, 'T'.codeUnits[0], 0x3F, 0x65, 0x6E, 0x7B];
      final d = <int>[
        ...List<int>.filled(12, 0), 0xE1, 0x10, 0x3E, 0x00,
        0x03, record.length, ...record, 0xFE,
      ];
      while (d.length < 160) {
        d.add(0);
      }
      mockNativeChannel({'data': '', 'rawBytes': d});

      await expectLater(
        datasource.readBobbinData(nfcMode: 'anycubic'),
        throwsA(
          isA<NfcTagReadFailure>().having(
            (f) => f.message,
            'message',
            isNot(contains('RangeError')),
          ),
        ),
      );
    });

    test('tag OpenTag3D version 2.000 → erreur explicite, pas de bobine fantôme',
        () async {
      final payload = List<int>.filled(0x64, 0);
      payload[0x00] = 0x07; // version 2000 BE
      payload[0x01] = 0xD0;
      const mime = 'application/opentag3d';
      final record = [0xC0 | 0x10 | 0x02, mime.length, payload.length, ...mime.codeUnits, ...payload];
      final d = <int>[
        ...List<int>.filled(12, 0), 0xE1, 0x10, 0x3E, 0x00,
        0x03, record.length, ...record, 0xFE,
      ];
      while (d.length < 160) {
        d.add(0);
      }
      mockNativeChannel({'data': '', 'rawBytes': d});

      await expectLater(
        datasource.readBobbinData(nfcMode: 'anycubic'),
        throwsA(
          isA<NfcTagReadFailure>().having(
            (f) => f.message,
            'message',
            contains('OpenTag3D'),
          ),
        ),
      );
    });
  });

  group('E2E mode Prusa (round-trip écriture → lecture)', () {
    test(
        'tag écrit par NOTRE writer (MIME openprinttag + payload TLV legacy) '
        'reste lisible — régression fallback CBOR→TLV', () async {
      // Écrire comme le fait l'app (nfc_writer_page → PrusaWriterService)
      const original = BobbinData(
        filamentType: 'PETG',
        color: 'Blue',
        weightGrams: 850,
        colorRgb: 0x0000FF,
        extruderTempMin: 230,
        extruderTempMax: 250,
        bedTempMin: 70,
        bedTempMax: 90,
        brand: 'Prusa',
      );
      final tlv = PrusaWriterService.buildOpenPrintTagPayload(original);
      final tagImage = PrusaWriterService.buildNdefMessage(tlv);

      mockNativeChannel({'data': '', 'rawBytes': tagImage});

      final result = await datasource.readBobbinData(nfcMode: 'prusa');

      expect(result.filamentType, 'PETG');
      expect(result.weightGrams, 850);
      expect(result.extruderTempMin, 230);
      expect(result.extruderTempMax, 250);
      expect(result.bedTempMin, 70);
      expect(result.bedTempMax, 90);
      expect(result.colorRgb, 0x0000FF);
    });
  });
}
