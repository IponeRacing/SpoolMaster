// Lectures suspectes vues en prod (09-10.2026) : tags NDEF non reconnus
// décodés comme des tags Anycubic, températures absurdes. Pipeline Dart
// complet : channel natif mocké → datasource → dépôt (contrôle de plausibilité).

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/core/services/nfc_scan_diagnostics.dart';
import 'package:nfc_filament/core/utils/color_naming.dart';
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

/// Tag Anycubic dont TOUS les champs sont un octet plus tôt que la normale
/// (cas de prod : matériau « LA », buse 58880 = 230 << 8, plateau 16640).
/// [sku] null = tag ACE sans SKU (magic 0x7B), sinon SKU ASCII en page 8.
List<int> _shiftedAnycubicDump({String? sku = 'AHPLBW-107'}) {
  const s = -1;
  final d = List<int>.filled(160, 0)
    ..setRange(12, 16, [0xE1, 0x10, 0x12, 0x00])
    ..setRange(16, 20, [0x7B, 0x00, 0x65, 0x00]);
  if (sku != null) d.setRange(32, 32 + sku.length, sku.codeUnits);
  void put(int at, List<int> bytes) => d.setRange(at + s, at + s + bytes.length, bytes);
  put(40, 'AC'.codeUnits);
  put(60, 'PLA Matte'.codeUnits);
  put(80, [0xFF, 0xFF, 0xFF, 0xFF]); // blanc (ABGR)
  put(96, [190, 0, 230, 0]); // buse 190-230
  put(116, [55, 0, 65, 0]); // plateau 55-65
  put(120, [0xAF, 0x00, 0x4A, 0x01]); // 1,75 mm, 330 m
  put(124, [0xE8, 0x03]); // 1000 g
  return d;
}

/// TigerTag (magic reconnu) sans matériau ni marque du registre : non programmé.
List<int> _tigerTagInitDump() {
  final d = List<int>.filled(160, 0)
    ..setRange(12, 16, [0xE1, 0x10, 0x12, 0x00])
    ..setRange(16, 20, [0x5B, 0xF5, 0x92, 0x64]) // 1542820452
    ..setRange(40, 44, 'ROSA'.codeUnits); // texte, lu avant comme une buse à 21071
  return d;
}

/// Tag Anycubic avec SKU (page 8) et champ matériau dédié (octets 60-76).
List<int> _skuDumpWithField(String sku, String field) {
  final d = List<int>.filled(160, 0)
    ..setRange(12, 16, [0xE1, 0x10, 0x12, 0x00])
    ..setRange(16, 20, [0x7B, 0x00, 0x65, 0x00])
    ..setRange(32, 32 + sku.length, sku.codeUnits)
    ..setRange(60, 60 + field.length, field.codeUnits)
    ..setRange(96, 100, [190, 0, 230, 0])
    ..setRange(120, 124, [0xAF, 0x00, 0x4A, 0x01]);
  return d;
}

/// Tag Anycubic avec SKU et couleur ABGR aux octets 80-83 ([rgb] = 0xRRGGBB).
List<int> _skuDumpWithRgb(String sku, int rgb) => _skuDumpWithField(sku, 'PLA')
  ..setRange(80, 84, [0xFF, rgb & 0xFF, (rgb >> 8) & 0xFF, rgb >> 16]);

/// Ancien tag ACE (page 4 = 7B 00 64 00, SKU « HPL17-102 » sans « AH »,
/// page 0x0A vide) : aucune marque écrite.
List<int> _oldAceDumpWithoutBrand() {
  final d = List<int>.filled(160, 0)
    ..setRange(12, 16, [0xE1, 0x10, 0x12, 0x00])
    ..setRange(16, 20, [0x7B, 0x00, 0x64, 0x00])
    ..setRange(20, 29, 'HPL17-102'.codeUnits)
    ..setRange(60, 63, 'PLA'.codeUnits)
    ..setRange(96, 100, [190, 0, 230, 0])
    ..setRange(120, 124, [0xAF, 0x00, 0x4A, 0x01]);
  return d;
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

  group('décodage corrigé (Anycubic décalé, TigerTag Init)', () {
    test('tag Anycubic SKU décalé d’un octet : températures, diamètre et poids justes', () async {
      _mockNative({'rawBytes': _shiftedAnycubicDump()});
      final m = await NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic');
      expect(m.extruderTempMin, 190);
      expect(m.extruderTempMax, 230);
      expect(m.bedTempMin, 55);
      expect(m.bedTempMax, 65);
      expect(m.diameter, 1.75);
      expect(m.spoolLength, 330);
      expect(m.weightGrams, 1000);
    });

    test('tag ACE (sans SKU) décalé : matériau « PLA Matte » et non « LA Matte »', () async {
      _mockNative({'rawBytes': _shiftedAnycubicDump(sku: null)});
      final m = await NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic');
      expect(m.filamentType, startsWith('PLA'));
      expect(m.extruderTempMax, 230);
      expect(m.diameter, 1.75);
    });

    test('tag ACE normal : aucun décalage appliqué', () async {
      _mockNative({'rawBytes': _aceDump()});
      final m = await NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic');
      expect(m.extruderTempMin, 205);
      expect(m.diameter, 1.75);
    });

    test('TigerTag sans matériau ni marque connus : tag vierge, pas une bobine', () async {
      _mockNative({'rawBytes': _tigerTagInitDump()});
      await expectLater(
        NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic'),
        throwsA(isA<NfcTagReadFailure>()),
      );
      expect(NfcScanDiagnostics.errorDetail, 'BLANK_TAG');
    });
  });

  group('Anycubic : marque et matériau (corpus de tags réels, 04.10.2026)', () {
    test('ancien tag ACE sans marque écrite → marque « Anycubic »', () async {
      _mockNative({'rawBytes': _oldAceDumpWithoutBrand()});
      final m = await NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic');
      expect(m.brand, 'Anycubic');
      expect(m.batchNumber, 'Anycubic - PLA');
      expect(m.filamentType, 'PLA');
    });

    test('SKU AHPL… avec champ « PLA+ » → « PLA+ » (plus précis que le SKU)', () async {
      _mockNative({'rawBytes': _skuDumpWithField('AHPLBW-107', 'PLA+')});
      final m = await NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic');
      expect(m.filamentType, 'PLA+');
    });

    test('SKU AHPL… avec champ « PLA » seul → nom du SKU conservé', () async {
      _mockNative({'rawBytes': _skuDumpWithField('AHPLBW-107', 'PLA')});
      final m = await NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic');
      expect(m.filamentType, 'PLA High Speed');
    });
  });

  // Prod 05.10.2026 (iPhone, 1.4.10+95) : PETG transparent « AHPECL-101 »,
  // RGB du tag à 0 → couleur « Unknown » et pastille noire.
  group('Anycubic PETG : codes SKU HPE / CL', () {
    test('AHPECL (RGB 0) → PETG « Transparent », pastille hachurée', () async {
      _mockNative({'rawBytes': _skuDumpWithField('AHPECL-101', 'PETG')});
      final m = await NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic');
      expect(m.filamentType, 'PETG');
      expect(m.color, 'Transparent');
      expect(m.colorRgb, kClearFilamentRgb);
    });

    test('auto-détection : même résultat', () async {
      _mockNative({'tagType': 'ultralight', 'rawBytes': _skuDumpWithField('AHPECL-101', 'PETG')});
      final m = await NfcDataSourceImpl().readBobbinDataAutoDetect();
      expect(m.color, 'Transparent');
      expect(m.colorRgb, kClearFilamentRgb);
    });

    test('AHPEBK (RGB 0) → PETG « Black » (avant : « Unknown »)', () async {
      _mockNative({'rawBytes': _skuDumpWithField('AHPEBK-102', 'PETG')});
      final m = await NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic');
      expect(m.filamentType, 'PETG');
      expect(m.color, 'Black');
    });
  });

  // Corpus du 04.10.2026 (SKU et RGB de vrais tags) : la moitié des noms
  // étaient faux (Beige → « Orange », Purple → « Blue », Pink → « Red »).
  group('Anycubic : noms de couleur des vrais tags', () {
    const cases = {
      'AHPLLB-107': (0xD4B996, 'Beige'),
      'AHPLKB-103': (0x965D3E, 'Brown'),
      'AHPLPO-103': (0x695FA1, 'Purple'),
      'AHPLSP-103': (0xF78092, 'Pink'),
      'AHPLGD-107': (0xFFB81C, 'Gold'),
      'AHPLSL-107': (0x8A8D8F, 'Silver'),
      'AHPLCY-107': (0x23A3C7, 'Cyan'),
      'AHPLPBR-102': (0xE10600, 'Red'),
      'AHPLPDB-102': (0x3D54AA, 'Blue'),
      'AHPLVY-103': (0xFDDB26, 'Yellow'),
    };
    for (final e in cases.entries) {
      test('${e.key} → ${e.value.$2}, RGB du tag conservé', () async {
        _mockNative({'rawBytes': _skuDumpWithRgb(e.key, e.value.$1)});
        final m = await NfcDataSourceImpl().readBobbinData(nfcMode: 'anycubic');
        expect(m.color, e.value.$2);
        expect(m.colorRgb, e.value.$1);
      });
    }
  });
}
