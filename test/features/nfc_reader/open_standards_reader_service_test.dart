import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/cbor_lite.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/open_standards_reader_service.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/prusa_reader_service.dart';

// ==================== Helpers encodage CBOR (tests uniquement) ====================

List<int> cUint(int v) => v < 24
    ? [v]
    : v < 256
        ? [0x18, v]
        : [0x19, (v >> 8) & 0xFF, v & 0xFF];
List<int> cText(String s) => [0x60 | s.length, ...utf8.encode(s)];
List<int> cBytes(List<int> b) => [0x40 | b.length, ...b];
List<int> cMap(Map<int, List<int>> entries) => [
      0xA0 | entries.length,
      for (final e in entries.entries) ...[...cUint(e.key), ...e.value],
    ];

/// Construit un dump NTAG21x (pages 0..N) contenant un message NDEF
/// avec un enregistrement unique de type donné.
List<int> buildType2Dump({
  required String recordType,
  required List<int> payload,
  bool asMime = false,
}) {
  // Pages 0-3 : UID + verrous + Capability Container (16 bytes)
  final dump = <int>[
    0x04, 0xA1, 0xB2, 0x17, // UID partie 1
    0xC3, 0xD4, 0xE5, 0xF6, // UID partie 2
    0x00, 0x00, 0x00, 0x00, // verrous
    0xE1, 0x10, 0x3E, 0x00, // CC : magic, version, taille, accès
  ];

  // Enregistrement NDEF court : MB|ME|SR + TNF (0x01 well-known / 0x02 MIME)
  final tnf = asMime ? 0x02 : 0x01;
  final typeBytes = recordType.codeUnits;
  final record = <int>[
    0xC0 | 0x10 | tnf, // MB + ME + SR + TNF
    typeBytes.length,
    payload.length,
    ...typeBytes,
    ...payload,
  ];

  // TLV : 0x03 (NDEF Message) + longueur + message + terminator
  dump.addAll([0x03, record.length, ...record, 0xFE]);

  // Padding jusqu'à 160 bytes (40 pages)
  while (dump.length < 160) {
    dump.add(0x00);
  }
  return dump;
}

void main() {
  group('OpenStandardsReaderService - OpenSpool JSON', () {
    test('parse un tag OpenSpool officiel (MIME application/json)', () {
      final json = jsonEncode({
        'protocol': 'openspool',
        'version': '1.0',
        'type': 'PLA',
        'color_hex': 'FF0000',
        'brand': 'Polymaker',
        'min_temp': 210,
        'max_temp': 230,
      });

      final dump = buildType2Dump(
        recordType: 'application/json',
        payload: utf8.encode(json),
        asMime: true,
      );

      final result = OpenStandardsReaderService.tryParse(dump);

      expect(result, isNotNull);
      expect(result!.filamentType, 'PLA');
      expect(result.brand, 'Polymaker');
      expect(result.color, 'Red');
      expect(result.colorRgb, 0xFF0000);
      expect(result.extruderTempMin, 210);
      expect(result.extruderTempMax, 230);
    });

    test('parse un tag JSON générique type Elegoo (record texte)', () {
      final json = jsonEncode({
        'type': 'PETG',
        'color_hex': '#0000FF',
        'brand': 'Elegoo',
        'min_temp': 230,
        'max_temp': 250,
        'weight': 1000,
      });

      // Record texte NDEF : status byte (longueur langue = 2) + 'en' + JSON
      final payload = [0x02, ...'en'.codeUnits, ...utf8.encode(json)];
      final dump = buildType2Dump(recordType: 'T', payload: payload);

      final result = OpenStandardsReaderService.tryParse(dump);

      expect(result, isNotNull);
      expect(result!.filamentType, 'PETG');
      expect(result.brand, 'Elegoo');
      expect(result.color, 'Blue');
      expect(result.weightGrams, 1000);
    });

    test('retourne null pour un tag Anycubic (pas de NDEF)', () {
      // Dump avec du texte SKU Anycubic mais sans structure NDEF
      final dump = List<int>.filled(160, 0);
      final sku = 'AHPLBW-107'.codeUnits;
      for (var i = 0; i < sku.length; i++) {
        dump[32 + i] = sku[i];
      }

      expect(OpenStandardsReaderService.tryParse(dump), isNull);
    });

    test('retourne null pour un dump vide', () {
      expect(OpenStandardsReaderService.tryParse([]), isNull);
      expect(OpenStandardsReaderService.tryParse(List.filled(160, 0)), isNull);
    });

    test('retourne null pour un JSON NDEF sans rapport avec le filament', () {
      final json = jsonEncode({'hello': 'world', 'foo': 42});
      final dump = buildType2Dump(
        recordType: 'application/json',
        payload: utf8.encode(json),
        asMime: true,
      );

      expect(OpenStandardsReaderService.tryParse(dump), isNull);
    });
  });

  group('OpenStandardsReaderService - OpenTag3D v1.000', () {
    List<int> buildOpenTag3DPayload() {
      final p = List<int>.filled(0x64, 0);
      p[0x00] = 0x03; // version 1000 BE
      p[0x01] = 0xE8;
      'PLA'.codeUnits.asMap().forEach((i, c) => p[0x02 + i] = c);
      'Silk'.codeUnits.asMap().forEach((i, c) => p[0x07 + i] = c);
      'Polymaker'.codeUnits.asMap().forEach((i, c) => p[0x1B + i] = c);
      'Fire Red'.codeUnits.asMap().forEach((i, c) => p[0x2B + i] = c);
      p[0x4B] = 0xFF; // color_1 RGBA
      p[0x4C] = 0x00;
      p[0x4D] = 0x00;
      p[0x4E] = 0xFF;
      p[0x5C] = 0x06; // diameter 1750 µm BE
      p[0x5D] = 0xD6;
      p[0x5E] = 0x03; // weight 1000 g BE
      p[0x5F] = 0xE8;
      p[0x60] = 42; // print temp 210°C (÷5)
      p[0x61] = 12; // bed temp 60°C (÷5)
      return p;
    }

    test('parse un tag OpenTag3D complet', () {
      final dump = buildType2Dump(
        recordType: 'application/opentag3d',
        payload: buildOpenTag3DPayload(),
        asMime: true,
      );

      final result = OpenStandardsReaderService.tryParse(dump);

      expect(result, isNotNull);
      expect(result!.filamentType, 'PLA Silk');
      expect(result.brand, 'Polymaker');
      expect(result.color, 'Fire Red');
      expect(result.colorRgb, 0xFF0000);
      expect(result.weightGrams, 1000);
      expect(result.diameter, closeTo(1.75, 0.001));
      expect(result.extruderTempMin, 210);
      expect(result.bedTempMin, 60);
    });

    // v2 (spec.json de GooborgStudios/OpenTag3D 2.003) : toutes les adresses
    // changent. Valeurs d'une vraie bobine Polar Filament PLA Pure Light Blue.
    test('OpenTag3D v2.000 : nouvelle disposition', () {
      final p = List<int>.filled(0xB0, 0);
      void put(int off, List<int> bytes) => p.setRange(off, off + bytes.length, bytes);
      put(0x00, [0x07, 0xD0]); // 2000
      put(0x02, 'PLA'.codeUnits);
      put(0x07, 'Pure'.codeUnits);
      put(0x0C, 'Polar Filament'.codeUnits);
      put(0x1C, 'Light Blue'.codeUnits);
      put(0x3C, [20, 173, 219, 255]);
      put(0x4C, '50017-FYG5'.codeUnits);
      put(0x84, [0x07, 0xEA, 4, 3]); // 2026-04-03
      put(0x8C, [0x06, 0xD6]); // 1750 µm
      p[0x8F] = 4; // buse 0.4
      put(0x90, [43, 41, 49, 0, 12, 10, 13]); // 215, 205-245, chambre 0, plateau 60, 50-65
      put(0x9A, [13, 0]); // séchage max 65 °C
      put(0x9E, [0x03, 0xE8]); // 1000 g
      put(0xA2, [0x00, 0x24]); // 36 m mesurés
      final dump = buildType2Dump(
        recordType: 'application/opentag3d',
        payload: p,
        asMime: true,
      );

      final result = OpenStandardsReaderService.tryParse(dump)!;

      expect(result.brand, 'Polar Filament');
      expect(result.filamentType, 'PLA Pure');
      expect(result.color, 'Light Blue');
      expect(result.colorRgb, 0x14ADDB);
      expect(result.extruderTempMin, 205);
      expect(result.extruderTempMax, 245);
      expect(result.bedTempMin, 50);
      expect(result.bedTempMax, 65);
      expect(result.diameter, closeTo(1.75, 0.001));
      expect(result.weightGrams, 1000);
      expect(result.nozzleSize, closeTo(0.4, 0.001));
      expect(result.dryingTemp, 65);
      expect(result.manufactureDate, DateTime(2026, 4, 3));
      expect(result.batchNumber, '50017-FYG5');
    });

    test('version non supportée → erreur explicite (pas de fallthrough ACE)', () {
      final payload = buildOpenTag3DPayload();
      payload[0x00] = 0x30; // version 12345 → hors plage v1.x / v2.x
      payload[0x01] = 0x39;
      final dump = buildType2Dump(
        recordType: 'application/opentag3d',
        payload: payload,
        asMime: true,
      );

      expect(
        () => OpenStandardsReaderService.tryParse(dump),
        throwsA(isA<NfcTagReadFailure>()),
      );
    });
  });

  group('OpenStandardsReaderService - Elegoo Canvas', () {
    List<int> buildElegooDump() {
      final dump = List<int>.filled(160, 0);
      dump[0x40] = 0x36; // header
      for (var i = 0x41; i <= 0x44; i++) {
        dump[i] = 0xEE; // manufacturer ELEGOO
      }
      // Material PLA : ASCII décimal en nibbles (P=80→0x80, L=76→0x76, A=65→0x65)
      dump[0x48] = 0x00;
      dump[0x49] = 0x80;
      dump[0x4A] = 0x76;
      dump[0x4B] = 0x65;
      dump[0x50] = 0x00; // couleur RGB : bleu
      dump[0x51] = 0x00;
      dump[0x52] = 0xFF;
      dump[0x53] = 0xFF; // color modifier
      dump[0x54] = 0x00; // nozzle min 190 BE
      dump[0x55] = 0xBE;
      dump[0x56] = 0x00; // nozzle max 230 BE
      dump[0x57] = 0xE6;
      dump[0x5C] = 0x00; // diamètre 175 (×100) BE
      dump[0x5D] = 0xAF;
      dump[0x5E] = 0x03; // poids 1000 BE
      dump[0x5F] = 0xE8;
      return dump;
    }

    test('parse un tag Elegoo PLA bleu', () {
      final result = OpenStandardsReaderService.tryParse(buildElegooDump());

      expect(result, isNotNull);
      expect(result!.filamentType, 'PLA');
      expect(result.brand, 'Elegoo');
      expect(result.color, 'Blue');
      expect(result.colorRgb, 0x0000FF);
      expect(result.weightGrams, 1000);
      expect(result.diameter, closeTo(1.75, 0.001));
      expect(result.extruderTempMin, 190);
      expect(result.extruderTempMax, 230);
    });

    test('rejette sans le magic manufacturer', () {
      final dump = buildElegooDump();
      dump[0x43] = 0x00; // casse le magic EE EE EE EE
      expect(OpenStandardsReaderService.tryParse(dump), isNull);
    });
  });

  group('PrusaReaderService - OpenPrintTag officiel (CBOR)', () {
    /// Construit un dump ISO 15693 : CC(4) + TLV NDEF avec un record MIME
    /// application/vnd.openprinttag contenant [meta CBOR][main CBOR][aux CBOR]
    List<int> buildOpenPrintTagDump() {
      // Main map : PLA, Prusament, 970g réels, rouge, temps 215-225/40-60
      final mainMap = cMap({
        9: cUint(0), // material_type = PLA
        10: cText('Prusament PLA'),
        11: cText('Prusa'),
        17: cUint(970), // actual_netto_full_weight
        19: cBytes([0xFF, 0x00, 0x00]), // primary_color RGB
        34: cUint(215),
        35: cUint(225),
        37: cUint(40),
        38: cUint(60),
      });

      // Aux map : consumed_weight = 120g
      final auxMap = cMap({0: cUint(120)});

      // Meta map : offsets calculés après coup (encodage stable car < 24...
      // offsets peuvent dépasser 24 → cUint gère)
      // On encode d'abord avec des placeholders pour connaître la taille.
      List<int> buildMeta(int mainOff, int auxOff) => cMap({
            0: cUint(mainOff),
            1: cUint(mainMap.length),
            2: cUint(auxOff),
            3: cUint(auxMap.length),
          });

      // Itérer jusqu'à stabilité de la taille du meta
      var metaSize = buildMeta(0, 0).length;
      for (var i = 0; i < 3; i++) {
        final meta = buildMeta(metaSize, metaSize + mainMap.length);
        if (meta.length == metaSize) break;
        metaSize = meta.length;
      }
      final meta = buildMeta(metaSize, metaSize + mainMap.length);

      final payload = [...meta, ...mainMap, ...auxMap];

      // Record NDEF MIME court
      const mimeType = 'application/vnd.openprinttag';
      final record = [
        0xC0 | 0x10 | 0x02, // MB+ME+SR+MIME
        mimeType.length,
        payload.length,
        ...mimeType.codeUnits,
        ...payload,
      ];

      return [
        0xE1, 0x40, 0x40, 0x01, // CC ISO 15693
        0x03, record.length, ...record, 0xFE,
      ];
    }

    test('parse un Prusament OpenPrintTag CBOR', () {
      final result = PrusaReaderService.parseFromRawBytes(buildOpenPrintTagDump());

      // Matériau = type (enum), nom commercial en type détaillé ; le nom ne
      // commence pas par le type → couleur générique tirée du RGB.
      expect(result.filamentType, 'PLA');
      expect(result.detailedType, 'Prusament PLA');
      expect(result.brand, 'Prusa');
      expect(result.weightGrams, 970);
      expect(result.colorRgb, 0xFF0000);
      expect(result.color, 'Red');
      expect(result.extruderTempMin, 215);
      expect(result.extruderTempMax, 225);
      expect(result.bedTempMin, 40);
      expect(result.bedTempMax, 60);
      // remaining = 970 - 120 consommés
      expect(result.remainingWeight, 850);
    });

    // Disposition des vrais tags Prusament (dumps réels du 04.10.2026) : record
    // URI avant le record OpenPrintTag, meta sans main_offset (la main region
    // suit le meta), main map de longueur INDÉFINIE (0xBF … 0xFF). Avant :
    // CborLite refusait l'indéfini → ancien format → « Unknown » partout.
    test('vrai tag Prusament : map indéfinie, meta sans main_offset, record URI devant', () {
      final mainMap = [
        0xBF, // map indéfinie
        ...cUint(9), ...cUint(0), // PLA
        ...cUint(10), ...cText('PLA Galaxy Red'),
        ...cUint(11), ...cText('Prusament'),
        ...cUint(17), ...cUint(1065),
        ...cUint(19), ...cBytes([0xBF, 0x1D, 0x2D]),
        ...cUint(34), ...cUint(205),
        ...cUint(35), ...cUint(225),
        ...cUint(37), ...cUint(40),
        ...cUint(38), ...cUint(60),
        ...cUint(57), ...cUint(45), // séchage 45 °C
        ...cUint(58), ...cUint(240), // 240 min = 4 h
        0xFF, // fin de la map
      ];
      final auxMap = [0xBF, 0xFF];
      final meta = cMap({2: cUint(4 + mainMap.length)}); // aux_offset seul
      expect(meta.length, 4); // A1 02 18 xx : la main region commence à 4
      final payload = [...meta, ...mainMap, ...auxMap];

      const uri = '3dtag.org/s/c20204c985';
      final uriRecord = [0x91, 0x01, uri.length + 1, 0x55, 0x04, ...uri.codeUnits];
      const mime = 'application/vnd.openprinttag';
      final optRecord = [0x52, mime.length, payload.length, ...mime.codeUnits, ...payload];
      final message = [...uriRecord, ...optRecord];
      final dump = [
        0xE1, 0x40, 0x27, 0x01, // CC
        0x03, 0xFF, message.length >> 8, message.length & 0xFF, ...message, 0xFE,
      ];

      final result = PrusaReaderService.parseFromRawBytes(dump);

      expect(result.brand, 'Prusament');
      expect(result.filamentType, 'PLA');
      expect(result.detailedType, 'PLA Galaxy Red');
      expect(result.color, 'Galaxy Red');
      expect(result.colorRgb, 0xBF1D2D);
      expect(result.weightGrams, 1065);
      expect(result.extruderTempMin, 205);
      expect(result.extruderTempMax, 225);
      expect(result.bedTempMin, 40);
      expect(result.bedTempMax, 60);
      expect(result.dryingTemp, 45);
      expect(result.dryingTime, 4);
    });
  });

  group('CborLite - longueurs indéfinies', () {
    test('map, array et chaîne découpée indéfinis', () {
      final (map, end) = CborLite.decode([
        0xBF, 0x01, 0x9F, 0x01, 0x02, 0xFF, // 1: [1, 2]
        0x02, 0x7F, 0x62, 0x61, 0x62, 0x61, 0x63, 0xFF, // 2: "ab" + "c"
        0xFF,
      ]);
      expect(map, {1: [1, 2], 2: 'abc'});
      expect(end, 15);
    });

    test('0xFF hors conteneur ou map non terminée → FormatException', () {
      expect(() => CborLite.decode([0xFF]), throwsFormatException);
      expect(() => CborLite.decode([0xBF, 0x01, 0x02]), throwsFormatException);
    });
  });

  group('OpenStandardsReaderService - TigerTag', () {
    /// Dump NTAG21x : zone TigerTag à partir de la page 4 (offset 16),
    /// big-endian. Valeurs : magic Maker, PLA (38219), Sunlu (51857),
    /// Ø1.75 (56), rouge, 1000 g (unité 21=g), buse 210-230, plateau 60,
    /// restant 750 g.
    List<int> buildTigerTagDump() {
      final d = List<int>.filled(144, 0);
      void put(int off, List<int> bytes) {
        for (var i = 0; i < bytes.length; i++) {
          d[16 + off + i] = bytes[i];
        }
      }

      put(0, [0x5B, 0xF5, 0x92, 0x64]); // magic 1542820452 (TigerTag Maker)
      put(4, [0xFF, 0xFF, 0xFF, 0xFF]); // ID Product = Maker
      put(8, [0x95, 0x4B]); // ID Material 38219 = PLA
      d[16 + 13] = 56; // ID Diameter = 1.75
      put(14, [0xCA, 0x91]); // ID Brand 51857 = Sunlu
      put(16, [0xFF, 0x00, 0x00, 0xFF]); // Color1 RGBA = rouge opaque
      put(20, [0x00, 0x03, 0xE8]); // Measure = 1000
      d[16 + 23] = 21; // ID Unit = g
      put(24, [0x00, 0xD2]); // Nozzle min 210
      put(26, [0x00, 0xE6]); // Nozzle max 230
      d[16 + 30] = 60; // Bed min
      d[16 + 31] = 60; // Bed max
      put(76, [0x00, 0x02, 0xEE]); // Measure Available = 750
      return d;
    }

    test('parse un tag TigerTag Sunlu PLA', () {
      final result = OpenStandardsReaderService.tryParse(buildTigerTagDump());

      expect(result, isNotNull);
      expect(result!.filamentType, 'PLA');
      expect(result.brand, 'Sunlu');
      expect(result.color, 'Red');
      expect(result.colorRgb, 0xFF0000);
      expect(result.weightGrams, 1000);
      expect(result.remainingWeight, 750);
      expect(result.diameter, closeTo(1.75, 0.001));
      expect(result.extruderTempMin, 210);
      expect(result.extruderTempMax, 230);
      expect(result.bedTempMin, 60);
      expect(result.bedTempMax, 60);
    });

    test('reconnaît les 3 variantes de magic (Maker/Init/TigerTag+)', () {
      for (final magic in [
        [0x5B, 0xF5, 0x92, 0x64], // Maker
        [0x6C, 0x41, 0xA2, 0xE1], // Init
        [0xBC, 0x0F, 0xCB, 0x97], // TigerTag+
      ]) {
        final d = buildTigerTagDump();
        for (var i = 0; i < 4; i++) {
          d[16 + i] = magic[i];
        }
        expect(OpenStandardsReaderService.tryParse(d), isNotNull);
      }
    });

    test('marque/matériau inconnus → fallback sans crash', () {
      final d = buildTigerTagDump();
      d[16 + 8] = 0x9C; // ID Material 40000 = absent du registre
      d[16 + 9] = 0x40;
      d[16 + 14] = 0x9C; // ID Brand 40000 = absent du registre
      d[16 + 15] = 0x40;
      final result = OpenStandardsReaderService.tryParse(d);
      expect(result, isNotNull);
      expect(result!.filamentType, 'Unknown');
      expect(result.brand, 'TigerTag');
    });

    test('magic invalide → null (pas un TigerTag)', () {
      final d = buildTigerTagDump();
      d[16] = 0x00; // casse le magic
      expect(OpenStandardsReaderService.tryParse(d), isNull);
    });
  });
}
