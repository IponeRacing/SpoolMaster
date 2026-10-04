// Décodage des tags RFID Bambu Lab (format RFID-Tag-Guide). Les blocs sont
// construits champ par champ selon le format officiel ; le décodeur a aussi
// été validé sur 262 dumps réels (un par couleur) le 04.10.2026.

import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/core/utils/color_naming.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/cloned_tag_model.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/bambu_lab_reader_service.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/bambu_tag_parser.dart';

List<int> _ascii(String s) => [...s.codeUnits, ...List.filled(16 - s.length, 0)];

List<int> _u16(int v) => [v & 0xFF, (v >> 8) & 0xFF];

List<int> _f32(double v) =>
    (ByteData(4)..setFloat32(0, v, Endian.little)).buffer.asUint8List().toList();

/// Blocs d'un tag Bambu, champ par champ.
Map<int, List<int>> bambuBlocks({
  String variant = 'A00-W1',
  String materialId = 'GFA00',
  String type = 'PLA',
  String detailed = 'PLA Basic',
  int rgba = 0xFFFFFFFF,
  int weight = 1000,
  double diameter = 1.75,
  int dryTemp = 55,
  int dryHours = 8,
  int bedTemp = 35,
  int hotendMax = 230,
  int hotendMin = 190,
  double nozzle = 0.2,
  String date = '2024_11_05_15_07',
  int length = 330,
}) {
  return {
    1: [..._ascii(variant).sublist(0, 8), ..._ascii(materialId).sublist(0, 8)],
    2: _ascii(type),
    4: _ascii(detailed),
    5: [
      (rgba >> 24) & 0xFF, (rgba >> 16) & 0xFF, (rgba >> 8) & 0xFF, rgba & 0xFF,
      ..._u16(weight), 0, 0, ..._f32(diameter), 0, 0, 0, 0,
    ],
    6: [
      ..._u16(dryTemp), ..._u16(dryHours), ..._u16(1), ..._u16(bedTemp),
      ..._u16(hotendMax), ..._u16(hotendMin), 0, 0, 0, 0,
    ],
    8: [...List.filled(12, 0), ..._f32(nozzle)],
    12: _ascii(date),
    14: [0, 0, 0, 0, ..._u16(length), ...List.filled(10, 0)],
  };
}

void main() {
  group('BambuTagParser.parse', () {
    test('PLA Basic Jade White : tous les champs aux bons octets', () {
      final d = BambuTagParser.parse(bambuBlocks())!;
      expect(d.brand, 'Bambu Lab');
      expect(d.filamentType, 'PLA Basic');
      expect(d.detailedType, 'PLA Basic');
      expect(d.color, 'Jade White');
      expect(d.colorRgb, 0xFFFFFF);
      expect(d.weightGrams, 1000);
      expect(d.remainingWeight, 1000);
      expect(d.diameter, 1.75);
      expect(d.extruderTempMin, 190);
      expect(d.extruderTempMax, 230);
      expect(d.bedTempMin, 35);
      expect(d.bedTempMax, 35);
      expect(d.dryingTemp, 55);
      expect(d.dryingTime, 8);
      expect(d.nozzleSize, 0.2);
      expect(d.spoolLength, 330);
      expect(d.manufactureDate, DateTime(2024, 11, 5, 15, 7));
      expect(d.materialId, 'GFA00');
      expect(d.materialVariantId, 'A00-W1');
    });

    test('régression : poids et diamètre ne sont plus lus comme températures', () {
      // Avant : extruderTempMin = 1000 (le poids), bedTempMax = 16352 (le float 1.75).
      final d = BambuTagParser.parse(bambuBlocks(weight: 500))!;
      expect(d.weightGrams, 500);
      expect(d.extruderTempMin, 190);
      expect(d.bedTempMax, 35);
    });

    test('code couleur de la variante : nom officiel, même sans couleur exacte', () {
      final d = BambuTagParser.parse(
        bambuBlocks(variant: 'A00-B8', rgba: 0x0090DDFF), // teinte de lot ≠ catalogue
      )!;
      expect(d.color, 'Cyan');
    });

    test('code « B01 » d’un tag = « B1 » du catalogue', () {
      final d = BambuTagParser.parse(bambuBlocks(variant: 'A00-B01', rgba: 0x5B6579FF))!;
      expect(d.color, 'Blue Gray');
    });

    test('autres matériaux : PETG HF noir, type détaillé', () {
      final d = BambuTagParser.parse(bambuBlocks(
        variant: 'G02-K0',
        materialId: 'GFG02',
        type: 'PETG',
        detailed: 'PETG HF',
        rgba: 0x000000FF,
        hotendMin: 230,
        hotendMax: 260,
        bedTemp: 70,
      ))!;
      expect(d.filamentType, 'PETG HF');
      expect(d.color, 'Black');
      expect(d.extruderTempMin, 230);
      expect(d.bedTempMin, 70);
    });

    test('sans bloc 4 : type du bloc 2', () {
      final blocks = bambuBlocks()..remove(4);
      expect(BambuTagParser.parse(blocks)!.filamentType, 'PLA');
    });

    test('valeurs hors plage → null (pas de température absurde)', () {
      final d = BambuTagParser.parse(bambuBlocks(hotendMin: 0, bedTemp: 0, dryTemp: 0, dryHours: 0))!;
      expect(d.extruderTempMin, isNull);
      expect(d.bedTempMin, isNull);
      expect(d.dryingTemp, isNull);
      expect(d.dryingTime, isNull);
    });

    test('poids 0 → 1000 g par défaut, diamètre aberrant → 1.75', () {
      final d = BambuTagParser.parse(bambuBlocks(weight: 0, diameter: 0))!;
      expect(d.weightGrams, 1000);
      expect(d.diameter, 1.75);
    });

    test('sans bloc 5 → null', () {
      expect(BambuTagParser.parse(bambuBlocks()..remove(5)), isNull);
    });

    // Cas relevés sur les 5959 dumps de Bambu-Lab-RFID-Library (04.10.2026).
    test('ABS-GF : « ABS-GF » au bloc 2, « ABS » au bloc 4 → ABS-GF', () {
      final d = BambuTagParser.parse(bambuBlocks(
        variant: 'B50-A0',
        materialId: 'GFB50',
        type: 'ABS-GF',
        detailed: 'ABS',
        rgba: 0xF48438FF,
      ))!;
      expect(d.filamentType, 'ABS-GF');
      expect(d.detailedType, 'ABS-GF');
      expect(d.color, 'Orange');
    });

    test('bloc 2 moins précis que le bloc 4 : bloc 4 gardé', () {
      final d = BambuTagParser.parse(bambuBlocks(type: 'TPU-AMS', detailed: 'TPU for AMS'))!;
      expect(d.filamentType, 'TPU for AMS');
    });

    test('transparent (alpha 0) au code inconnu : « Transparent », pastille claire', () {
      // Avant : RGB 000000 → « Black » et pastille noire.
      final d = BambuTagParser.parse(bambuBlocks(
        variant: 'G00-C1',
        materialId: 'GFG00',
        type: 'PETG',
        detailed: 'PETG Basic',
        rgba: 0x00000000,
      ))!;
      expect(d.color, 'Transparent');
      expect(d.colorRgb, kClearFilamentRgb);
    });

    test('transparent au code connu : nom officiel', () {
      final d = BambuTagParser.parse(bambuBlocks(
        variant: 'G01-C0',
        materialId: 'GFG01',
        detailed: 'PETG Translucent',
        rgba: 0x00000000,
      ))!;
      expect(d.color, 'Clear');
      expect(d.colorRgb, kClearFilamentRgb);
    });

    test('translucide (alpha 0x80) : RGB du tag conservé', () {
      final d = BambuTagParser.parse(bambuBlocks(
        variant: 'G01-B0',
        materialId: 'GFG01',
        detailed: 'PETG Translucent',
        rgba: 0x61B0FF80,
      ))!;
      expect(d.color, 'Translucent Light Blue');
      expect(d.colorRgb, 0x61B0FF);
    });

    test('code exact avant le code normalisé : « B0 » ≠ « B00 »', () {
      String colorOf(String variant, int rgba) => BambuTagParser.parse(bambuBlocks(
            variant: variant,
            materialId: 'GFG00',
            detailed: 'PETG Basic',
            rgba: rgba,
          ))!.color;
      expect(colorOf('G00-B0', 0x0069B1FF), 'Blue');
      expect(colorOf('G00-B00', 0x001489FF), 'Reflex Blue');
    });

    test('MIFARE Classic d’une autre marque (Qidi) : pas une bobine Bambu', () {
      // Tag Qidi lu avec les clés par défaut : bloc 1 vide, bloc 5 rempli.
      final blocks = bambuBlocks()..[1] = List.filled(16, 0);
      expect(BambuTagParser.isBambuTag(blocks), isFalse);
      expect(BambuTagParser.parse(blocks), isNull);
      expect(
        () => BambuLabReaderService.parseFromNativeData({
          'rawBlocks': blocks.map((k, v) => MapEntry('block_$k', v)),
        }),
        throwsA(isA<NfcTagIncompatibleFailure>()),
      );
    });

    test('variante absente du catalogue BambuStudio : complément du générateur', () {
      final d = BambuTagParser.parse(bambuBlocks(
        variant: 'G00-G8',
        materialId: 'GFG00',
        detailed: 'PETG Basic',
        rgba: 0x7CD82BFF,
      ))!;
      expect(d.color, 'Lime Green'); // avant : « Bright Green » (la plus proche)
    });
  });

  group('BambuTagParser.colorName (sans code couleur)', () {
    test('couleur exacte du catalogue : couleur unie avant dégradé', () {
      // FFFFFF existe aussi dans des dégradés PLA Basic (Arctic Whisper…).
      expect(
        BambuTagParser.colorName(rgb: 0xFFFFFF, materialId: 'GFA00', filamentType: 'PLA Basic'),
        'Jade White',
      );
    });

    test('couleur proche (ΔE ≤ 15) : nom officiel le plus proche', () {
      expect(
        BambuTagParser.colorName(rgb: 0xFDC402, materialId: 'GFA00', filamentType: 'PLA Basic'),
        'Sunflower Yellow',
      );
    });

    test('filament inconnu du catalogue : recherche par type', () {
      expect(
        BambuTagParser.colorName(rgb: 0x000000, materialId: 'GFZ99', filamentType: 'PLA Basic'),
        'Black',
      );
    });

    test('aucune couleur officielle proche (ΔE > 15) : nom générique', () {
      // Vert printemps : la couleur du catalogue la plus proche est à ΔE 16,6.
      expect(BambuTagParser.colorName(rgb: 0x00FF7F), colorNameFromRgb(0x00, 0xFF, 0x7F));
      expect(BambuTagParser.colorName(rgb: 0x00FF7F), 'Green');
    });
  });

  test('blocksFromNative : clés « block_N » et listes du MethodChannel', () {
    final raw = <Object?, Object?>{
      'block_5': <Object?>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16],
      'block_x': <Object?>[1],
      'block_6': 'pas une liste',
    };
    final blocks = BambuTagParser.blocksFromNative(raw);
    expect(blocks.keys, [5]);
    expect(blocks[5]!.first, 1);
    expect(BambuTagParser.blocksFromNative(null), isEmpty);
  });

  test('clone enregistré avant la 89 : relu depuis ses blocs bruts', () {
    final blocks = bambuBlocks(variant: 'A00-B3', rgba: 0x0056B8FF);
    final json = {
      'id': '1',
      'clonedAt': '2026-09-01T10:00:00.000',
      // Ce que l'ancien décodage avait enregistré.
      'bobbinData': {
        'filamentType': 'PLA Basic',
        'color': 'Black',
        'weightGrams': 0.0,
        'extruderTempMin': 1000,
        'bedTempMax': 16352,
        'brand': 'Bambu Lab',
      },
      'rawBlocks': blocks.map((k, v) => MapEntry(k.toString(), v)),
    };
    final clone = ClonedTagModel.fromJson(json);
    expect(clone.bobbinData.color, 'Cobalt Blue');
    expect(clone.bobbinData.weightGrams, 1000);
    expect(clone.bobbinData.extruderTempMin, 190);
    expect(clone.bobbinData.bedTempMax, 35);
  });
}
