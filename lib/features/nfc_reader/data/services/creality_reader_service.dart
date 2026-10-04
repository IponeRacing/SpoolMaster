import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nfc_filament/core/constants/creality_database.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/core/utils/color_naming.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/native_nfc/native_nfc.dart';

/// Service pour lire les tags NFC Creality CFS
/// Basé sur le reverse-engineering communautaire (K2-RFID, cfs-programmer)
/// Tags MiFare Classic 1K, AES-128-ECB, clé dérivée du UID par XOR
class CrealityReaderService {
  static const MethodChannel _channel = MethodChannel('com.anycubic.nfc/native');

  /// Lire les données d'une bobine Creality CFS depuis un tag NFC
  static Future<BobbinData> readCrealityTag() async {
    try {
      await NativeNfc.endStaleSession();
      final result = await _channel.invokeMethod('readCrealityTag');

      if (result == null) {
        throw const NfcTagReadFailure(message: 'Aucune donnée reçue du tag Creality CFS');
      }

      final data = Map<String, dynamic>.from(result is Map ? result : {});
      return _parseNativeData(data);
    } on PlatformException {
      rethrow;
    } on NfcTagReadFailure {
      rethrow;
    } catch (e) {
      debugPrint('❌ Erreur parsing Creality CFS: $e\n${e is Error ? e.stackTrace : ""}');
      throw NfcTagReadFailure(message: 'Erreur parsing tag Creality CFS: $e');
    }
  }

  /// Parser des données natives Creality déjà lues (pour auto-detect)
  static BobbinData parseFromNativeData(Map<String, dynamic> data) {
    return _parseNativeData(data);
  }

  /// Parser les données brutes reçues du plugin natif. Matériau, type et
  /// températures viennent de la table officielle Creality (code du tag) ;
  /// avant : table fausse pour la plupart des codes, « Hyper » perdu, aucune
  /// température, et une palette à part (rouge C12E1F → « Brown »).
  static BobbinData _parseNativeData(Map<String, dynamic> data) {
    final materialId = data['materialId'] as String? ?? '';
    final material = CrealityDatabase.material(materialId);

    // Color RGB
    final colorRgb = data['colorRgb'] as int? ?? 0xFFFFFF;
    final colorName = colorNameFromRgb((colorRgb >> 16) & 0xFF, (colorRgb >> 8) & 0xFF, colorRgb & 0xFF);

    // Weight
    final weightGrams = (data['weightGrams'] as int?)?.toDouble() ?? 1000.0;

    // Production date
    DateTime? manufactureDate;
    final timestamp = data['productionTimestamp'] as int?;
    if (timestamp != null && timestamp > 0) {
      try {
        manufactureDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      } catch (_) {}
    }

    final batch = data['batch'] as String? ?? '';
    int? temp(int v) => v > 0 ? v : null;

    debugPrint('Creality parsed: ${material?.name ?? 'code $materialId inconnu'} / $colorName / ${weightGrams}g / batch=$batch');

    return BobbinData(
      filamentType: material?.type ?? 'Unknown',
      detailedType: material?.name,
      materialId: materialId.isEmpty ? null : materialId,
      color: colorName,
      colorRgb: colorRgb,
      weightGrams: weightGrams,
      manufactureDate: manufactureDate,
      batchNumber: batch.isNotEmpty ? batch : null,
      brand: 'Creality',
      remainingWeight: weightGrams,
      extruderTempMin: material == null ? null : temp(material.nozzleMin),
      extruderTempMax: material == null ? null : temp(material.nozzleMax),
      bedTempMin: material == null ? null : temp(material.bedTemp),
      bedTempMax: material == null ? null : temp(material.bedTemp),
    );
  }
}
