// Rejoue des lectures NFC émulées dans le VRAI pipeline Dart de l'app :
// canal natif simulé → NfcDataSourceImpl → NfcRepositoryImpl (contrôle de
// plausibilité compris). Sert aux corpus de dumps réels (tool/*_corpus_check.py).
//
// Entrée (NFC_CORPUS_IN) : JSONL, une lecture par ligne :
//   {"id": "...", "mode": "anycubic" | "prusa" | "creality" | "bambu" | "auto",
//    "response": {...réponse du natif...}}
//   ou {"id": "...", "mode": "...", "error": {"code": "...", "message": "..."}}
// Sortie (NFC_CORPUS_OUT) : JSONL {"id", "mode", "ok", "failure", "message", "data"}.
//
// Usage : NFC_CORPUS_IN=in.jsonl NFC_CORPUS_OUT=out.jsonl \
//         flutter test tool/nfc_corpus_replay_test.dart
// Sans NFC_CORPUS_IN, le test est sauté (n'alourdit pas la suite).

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/features/nfc_reader/data/datasources/nfc_datasource_impl.dart';
import 'package:nfc_filament/features/nfc_reader/data/repositories/nfc_repository_impl.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

const _channel = MethodChannel('com.anycubic.nfc/native');

/// Méthodes du natif qui lisent un tag (lib/native_nfc/native_nfc.dart et
/// lecteurs dédiés) : elles reçoivent la réponse émulée.
const _readMethods = {
  'startReadSession',
  'startAutoDetectReadSession',
  'readOpenPrintTag',
  'readCrealityTag',
  'readBambuLabTag',
};

Map<String, dynamic> _bobbinJson(BobbinData d) => {
      'filamentType': d.filamentType,
      'color': d.color,
      'colorRgb': d.colorRgb,
      'weightGrams': d.weightGrams,
      'remainingWeight': d.remainingWeight,
      'brand': d.brand,
      'detailedType': d.detailedType,
      'extruderTempMin': d.extruderTempMin,
      'extruderTempMax': d.extruderTempMax,
      'bedTempMin': d.bedTempMin,
      'bedTempMax': d.bedTempMax,
      'diameter': d.diameter,
      'spoolLength': d.spoolLength,
      'dryingTemp': d.dryingTemp,
      'dryingTime': d.dryingTime,
      'nozzleSize': d.nozzleSize,
      'manufactureDate': d.manufactureDate?.toIso8601String(),
      'batchNumber': d.batchNumber,
      'materialId': d.materialId,
      'materialVariantId': d.materialVariantId,
      'vendorCode': d.vendorCode,
      'productCode': d.productCode,
    };

void main() {
  final input = Platform.environment['NFC_CORPUS_IN'];
  final output = Platform.environment['NFC_CORPUS_OUT'];

  test('rejeu du corpus NFC', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    final repository = NfcRepositoryImpl(NfcDataSourceImpl());
    final out = File(output!).openWrite();

    for (final line in File(input!).readAsLinesSync()) {
      if (line.trim().isEmpty) continue;
      final rec = jsonDecode(line) as Map<String, dynamic>;
      final error = rec['error'] as Map<String, dynamic>?;
      final response = rec['response'] as Map<String, dynamic>?;
      messenger.setMockMethodCallHandler(_channel, (call) async {
        // Appels de service (stopSession, checkNfcAvailability) : sans effet.
        if (!_readMethods.contains(call.method)) return true;
        if (error != null) {
          throw PlatformException(
            code: error['code'] as String,
            message: error['message'] as String?,
            details: error['details'],
          );
        }
        return response;
      });

      final mode = rec['mode'] as String;
      final result = mode == 'auto'
          ? await repository.readBobbinDataAutoDetect()
          : await repository.readBobbinData(nfcMode: mode);
      out.writeln(jsonEncode(result.fold(
        (f) => {
          'id': rec['id'],
          'mode': mode,
          'ok': false,
          'failure': f.runtimeType.toString(),
          'message': f.message,
        },
        (d) => {'id': rec['id'], 'mode': mode, 'ok': true, 'data': _bobbinJson(d)},
      )));
    }
    await out.close();
    messenger.setMockMethodCallHandler(_channel, null);
  }, skip: input == null || output == null ? 'NFC_CORPUS_IN / NFC_CORPUS_OUT absents' : false);
}
