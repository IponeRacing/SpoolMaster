import 'package:flutter/services.dart';
import 'package:nfc_filament/core/constants/creality_database.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/native_nfc/native_nfc.dart';

/// Service pour écrire les tags NFC Creality CFS
/// Encode les données BobbinData → payload 48 chars → envoi au natif pour chiffrement AES + écriture
class CrealityWriterService {
  static const MethodChannel _channel = MethodChannel('com.anycubic.nfc/native');

  /// Écrire des données sur un tag Creality CFS
  static Future<void> writeCrealityTag(BobbinData data) async {
    final payload = buildPayloadMap(data);
    await NativeNfc.endStaleSession();
    await _channel.invokeMethod('writeCrealityTag', payload);
  }

  /// Construire la map de données pour le plugin natif
  static Map<String, dynamic> buildPayloadMap(BobbinData data) {
    // Code matériau : nom détaillé (« Hyper PLA ») d'abord, puis type (« PETG »
    // → matériau générique Creality), sinon CR-PLA.
    final materialId = CrealityDatabase.getMaterialId(data.detailedType ?? '') ??
        CrealityDatabase.getMaterialId(data.filamentType) ??
        '04001';

    // Color RGB
    final colorRgb = data.colorRgb ?? 0xFFFFFF;

    // Weight code
    final lengthCode = CrealityDatabase.getWeightCode(data.weightGrams);

    return {
      'materialId': materialId,
      'colorRgb': colorRgb,
      'lengthCode': lengthCode,
      'vendor': '0276',
      'batch': data.batchNumber ?? '000',
    };
  }
}
