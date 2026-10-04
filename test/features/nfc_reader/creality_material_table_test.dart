// Tags Creality CFS : matériau, type et températures depuis la table officielle
// Creality (material_database.json) ; avant, table de l'app fausse pour la
// plupart des codes.

import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/constants/creality_database.dart';
import 'package:nfc_filament/core/utils/color_naming.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/creality_reader_service.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/creality_writer_service.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

Map<String, dynamic> _native(String materialId, int rgb) => {
      'tagType': 'creality',
      'materialId': materialId,
      'colorRgb': rgb,
      'weightGrams': 1000,
      'batch': 'A2',
      'productionTimestamp': 0,
    };

void main() {
  group('lecture', () {
    test('vrai tag Hyper PLA « Very Peri » : type, nom, températures, couleur', () {
      final d = CrealityReaderService.parseFromNativeData(_native('01001', 0x6667AB));
      expect(d.brand, 'Creality');
      expect(d.filamentType, 'PLA');
      expect(d.detailedType, 'Hyper PLA'); // avant : « Hyper » perdu
      expect(d.extruderTempMin, 190);
      expect(d.extruderTempMax, 240);
      expect(d.bedTempMin, 50);
      expect(d.color, colorNameFromRgb(0x66, 0x67, 0xAB)); // avant : palette à part → « Gray »
      expect(d.color, 'Blue');
    });

    test('code 03001 = Hyper ABS (avant : « PLA Silk »)', () {
      final d = CrealityReaderService.parseFromNativeData(_native('03001', 0x000000));
      expect(d.filamentType, 'ABS');
      expect(d.detailedType, 'Hyper ABS');
      expect(d.extruderTempMin, 240);
    });

    test('rouge C12E1F nommé « Red » (avant : « Brown »)', () {
      expect(CrealityReaderService.parseFromNativeData(_native('04001', 0xC12E1F)).color, 'Red');
    });

    test('code inconnu : type « Unknown », pas de température inventée', () {
      final d = CrealityReaderService.parseFromNativeData(_native('99999', 0xFFFFFF));
      expect(d.filamentType, 'Unknown');
      expect(d.extruderTempMin, isNull);
      expect(d.bedTempMin, isNull);
    });
  });

  group('écriture', () {
    BobbinData spool(String type, {String? detailed}) =>
        BobbinData(filamentType: type, detailedType: detailed, color: 'White', weightGrams: 1000);

    test('nom détaillé → son code', () {
      expect(CrealityWriterService.buildPayloadMap(spool('PLA', detailed: 'Hyper PLA'))['materialId'], '01001');
      expect(CrealityWriterService.buildPayloadMap(spool('ABS', detailed: 'Hyper ABS'))['materialId'], '03001');
    });

    test('type seul → matériau générique Creality du même type', () {
      expect(CrealityWriterService.buildPayloadMap(spool('PETG'))['materialId'], '00003');
      expect(CrealityDatabase.getMaterialId('pla'), '00001');
    });

    test('matériau inconnu → CR-PLA (04001)', () {
      expect(CrealityWriterService.buildPayloadMap(spool('Bois de rose'))['materialId'], '04001');
    });
  });
}
