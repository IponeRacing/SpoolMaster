// Lectures suspectes vues en prod (09-10.2026) : tags NDEF non reconnus
// décodés comme des tags Anycubic, températures absurdes. Pipeline Dart
// complet : channel natif mocké → datasource → dépôt (contrôle de plausibilité).

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/core/services/nfc_scan_diagnostics.dart';
import 'package:nfc_filament/features/nfc_reader/data/datasources/nfc_datasource_impl.dart';
import 'package:nfc_filament/features/nfc_reader/data/repositories/nfc_repository_impl.dart';
import 'package:nfc_filament/features/nfc_reader/domain/bobbin_data_sanity.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

const _channel = MethodChannel('com.anycubic.nfc/native');

void _mockNative(Map<String, dynamic> response) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_channel, (call) async => response);
}

/// Tag ACE (magic 0x7B) : brand, material, buse, plateau aux offsets ACE.
List<int> _aceDump({
  String material = 'PLA+',
  int extruderMin = 205,
  int extruderMax = 215,
}) {
  final d = List<int>.filled(160, 0)
    ..setRange(12, 16, [0xE1, 0x10, 0x12, 0x00])
    ..setRange(16, 20, [0x7B, 0x00, 0x65, 0x00])
    ..setRange(40, 42, 'AC'.codeUnits)
    ..setRange(80, 84, [0xFF, 0xED, 0xF0, 0xF0])
    ..setRange(96, 100, [extruderMin & 0xFF, extruderMin >> 8, extruderMax & 0xFF, extruderMax >> 8])
    ..setRange(116, 120, [0x32, 0x00, 0x3C, 0x00])
    ..setRange(120, 124, [0xAF, 0x00, 0x4A, 0x01])
    ..setRange(124, 128, [0xE8, 0x03, 0x00, 0x00]);
  final m = material.codeUnits.take(16).toList();
  d.setRange(60, 60 + m.length, m);
  return d;
}

/// Tag OpenSpool dont le message NDEF dépasse 160 octets, lu tronqué à 160
/// (ce que faisait la lecture native avant la 1.4.10+91).
List<int> _truncatedLongOpenSpool() {
  final json = utf8.encode(jsonEncode({
    'protocol': 'openspool',
    'version': '1.0',
    'type': 'PETG',
    'color_hex': '00FF00',
    'brand': 'Generic',
    'min_temp': '230',
    'max_temp': '250',
    'bed_min_temp': '70',
    'bed_max_temp': '80',
    'subtype': 'High Flow Translucent',
  }));
  const mime = 'application/json';
  final record = [0xC0 | 0x10 | 0x02, mime.length, json.length, ...mime.codeUnits, ...json];
  final full = <int>[
    ...List<int>.filled(12, 0), 0xE1, 0x10, 0x3E, 0x00,
    0x03, record.length, ...record, 0xFE,
  ];
  expect(full.length, greaterThan(160), reason: 'le message doit dépasser 160 octets');
  return full.sublist(0, 160);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(NfcScanDiagnostics.reset);

  group('tag NDEF non reconnu → refusé (plus décodé comme un tag Anycubic)', () {
    test('mode Anycubic : OpenSpool tronqué → tag incompatible', () async {
      _mockNative({'rawBytes': _truncatedLongOpenSpool()});
      await expectLater(
        NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic'),
        throwsA(isA<NfcTagIncompatibleFailure>()),
      );
      expect(NfcScanDiagnostics.errorDetail, NfcScanDiagnostics.unrecognizedFormat);
    });

    test('auto-détection : idem', () async {
      _mockNative({'tagType': 'ultralight', 'rawBytes': _truncatedLongOpenSpool()});
      await expectLater(
        NfcDataSourceImpl().readBobbinDataAutoDetect(),
        throwsA(isA<NfcTagIncompatibleFailure>()),
      );
    });

    test('dépôt : le refus remonte comme tag incompatible', () async {
      _mockNative({'rawBytes': _truncatedLongOpenSpool()});
      final result = await NfcRepositoryImpl(NfcDataSourceImpl()).readBobbinData(nfcMode: 'anycubic');
      expect(result.fold((f) => f, (_) => null), isA<NfcTagIncompatibleFailure>());
    });
  });

  group('contrôle de plausibilité dans le dépôt (tous décodeurs)', () {
    test('tag ACE aux températures absurdes : valeurs écartées, dump demandé', () async {
      // 44800 = 0xAF00 : valeur vue en prod (bobine « PLA High Speed »).
      _mockNative({'rawBytes': _aceDump(extruderMin: 44800, extruderMax: 18944)});
      final result = await NfcRepositoryImpl(NfcDataSourceImpl()).readBobbinData(nfcMode: 'anycubic');
      final data = result.getOrElse(() => throw StateError('lecture refusée'));
      expect(data.extruderTempMin, isNull);
      expect(data.extruderTempMax, isNull);
      expect(data.bedTempMin, 50); // le reste est conservé
      expect(NfcScanDiagnostics.outOfRange, 'extruder_temp_min,extruder_temp_max');
      expect(NfcScanDiagnostics.wantsRawDump, isTrue);
      expect(NfcScanDiagnostics.lastRawHex, startsWith('000000000000000000000000e1101200'));
    });

    test('matériau fait de fragments JSON : format non reconnu', () async {
      _mockNative({'rawBytes': _aceDump(material: ',"max_temp":230,')});
      final result = await NfcRepositoryImpl(NfcDataSourceImpl()).readBobbinData(nfcMode: 'anycubic');
      expect(result.fold((f) => f, (_) => null), isA<NfcTagIncompatibleFailure>());
      expect(NfcScanDiagnostics.errorDetail, NfcScanDiagnostics.unrecognizedFormat);
    });

    test('tag ACE normal : rien d’écarté, pas de dump', () async {
      _mockNative({'rawBytes': _aceDump()});
      final result = await NfcRepositoryImpl(NfcDataSourceImpl()).readBobbinData(nfcMode: 'anycubic');
      final data = result.getOrElse(() => throw StateError('lecture refusée'));
      expect(data.extruderTempMin, 205);
      expect(data.extruderTempMax, 215);
      expect(NfcScanDiagnostics.outOfRange, isNull);
      expect(NfcScanDiagnostics.wantsRawDump, isFalse);
    });
  });

  group('checkBobbinData', () {
    BobbinData data({
      String type = 'PLA',
      int? eMin,
      int? eMax,
      int? bMin,
      int? bMax,
      double weight = 1000,
      double? diameter,
    }) =>
        BobbinData(
          filamentType: type,
          color: 'White',
          weightGrams: weight,
          extruderTempMin: eMin,
          extruderTempMax: eMax,
          bedTempMin: bMin,
          bedTempMax: bMax,
          diameter: diameter,
        );

    test('valeurs vues en prod (ancien décodage Bambu) : écartées', () {
      final r = checkBobbinData(data(eMin: 1000, eMax: 0, bMin: 0, bMax: 16352));
      expect(r.data.extruderTempMin, isNull);
      expect(r.data.extruderTempMax, isNull);
      expect(r.data.bedTempMin, isNull); // 0 = non renseigné
      expect(r.data.bedTempMax, isNull);
      expect(r.droppedFields, ['extruder_temp_min', 'extruder_temp_max', 'bed_temp_max']);
      expect(r.garbled, isFalse);
    });

    test('valeurs plausibles conservées, min/max inversés remis dans l’ordre', () {
      final r = checkBobbinData(data(eMin: 230, eMax: 190, bMin: 55, bMax: 65, diameter: 1.75));
      expect(r.data.extruderTempMin, 190);
      expect(r.data.extruderTempMax, 230);
      expect(r.data.bedTempMax, 65);
      expect(r.data.diameter, 1.75);
      expect(r.droppedFields, isEmpty);
    });

    test('poids aberrant → 1000 g, diamètre aberrant → vide', () {
      final r = checkBobbinData(data(weight: 65535, diameter: 3.15 * 10));
      expect(r.data.weightGrams, 1000);
      expect(r.data.diameter, isNull);
      expect(r.droppedFields, containsAll(['weight', 'diameter']));
    });

    test('texte illisible détecté, noms réels acceptés', () {
      for (final bad in [',"max_temp":230,', '| Bed: 80CSec:', 'GmC0X","brand":"', 'pool","version":']) {
        expect(isGarbledTagText(bad), isTrue, reason: bad);
      }
      for (final ok in ['PLA High Speed', 'PLA+', 'PETG-CF', 'PLA Matte', 'Silk PLA (Dual)']) {
        expect(isGarbledTagText(ok), isFalse, reason: ok);
      }
    });
  });
}
