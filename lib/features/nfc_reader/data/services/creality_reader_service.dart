import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nfc_filament/core/constants/creality_database.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

/// Service pour lire les tags NFC Creality CFS
/// Basé sur le reverse-engineering communautaire (K2-RFID, cfs-programmer)
/// Tags MiFare Classic 1K, AES-128-ECB, clé dérivée du UID par XOR
class CrealityReaderService {
  static const MethodChannel _channel = MethodChannel('com.anycubic.nfc/native');

  /// Lire les données d'une bobine Creality CFS depuis un tag NFC
  static Future<BobbinData> readCrealityTag() async {
    try {
      final result = await _channel.invokeMethod('readCrealityTag');

      if (result == null) {
        throw const NfcTagReadFailure(message: 'Aucune donnée reçue du tag Creality CFS');
      }

      final data = Map<String, dynamic>.from(result as Map);
      return _parseNativeData(data);
    } on PlatformException {
      rethrow;
    } on NfcTagReadFailure {
      rethrow;
    } catch (e) {
      throw NfcTagReadFailure(message: 'Erreur parsing tag Creality CFS: $e');
    }
  }

  /// Parser des données natives Creality déjà lues (pour auto-detect)
  static BobbinData parseFromNativeData(Map<String, dynamic> data) {
    return _parseNativeData(data);
  }

  /// Parser les données brutes reçues du plugin natif
  static BobbinData _parseNativeData(Map<String, dynamic> data) {
    // Material name from native (already looked up) or from materialId
    final materialId = data['materialId'] as String? ?? '';
    final materialName = data['materialName'] as String? ??
        CrealityDatabase.materials[materialId] ??
        'Unknown';

    // Extraire le type de filament simplifié (PLA, PETG, ABS, etc.)
    final filamentType = _simplifyMaterialName(materialName);

    // Color RGB
    final colorRgb = data['colorRgb'] as int? ?? 0xFFFFFF;
    final colorName = _findClosestColorName(colorRgb);

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

    debugPrint('Creality parsed: $filamentType / $colorName / ${weightGrams}g / batch=$batch');

    return BobbinData(
      filamentType: filamentType,
      color: colorName,
      colorRgb: colorRgb,
      weightGrams: weightGrams,
      manufactureDate: manufactureDate,
      batchNumber: batch.isNotEmpty ? batch : null,
      brand: 'Creality',
      remainingWeight: weightGrams,
    );
  }

  /// Simplifier le nom du matériau en type de base
  static String _simplifyMaterialName(String name) {
    final upper = name.toUpperCase();
    if (upper.contains('PLA')) return 'PLA';
    if (upper.contains('PETG')) return 'PETG';
    if (upper.contains('ABS')) return 'ABS';
    if (upper.contains('TPU')) return 'TPU';
    if (upper.contains('ASA')) return 'ASA';
    if (upper.contains('PA') || upper.contains('NYLON')) return 'PA';
    if (upper.contains('PVA')) return 'PVA';
    if (upper.contains('HIPS')) return 'HIPS';
    if (upper.contains('PC')) return 'PC';
    if (upper.contains('PET')) return 'PET';
    if (upper.contains('BVOH')) return 'BVOH';
    return name;
  }

  /// Trouver le nom de couleur le plus proche d'un RGB
  static String _findClosestColorName(int rgb) {
    final r = (rgb >> 16) & 0xFF;
    final g = (rgb >> 8) & 0xFF;
    final b = rgb & 0xFF;

    const colors = {
      'White': 0xFFFFFF,
      'Black': 0x000000,
      'Red': 0xFF0000,
      'Blue': 0x0000FF,
      'Green': 0x00FF00,
      'Yellow': 0xFFFF00,
      'Orange': 0xFF8000,
      'Pink': 0xFF69B4,
      'Gray': 0x808080,
      'Purple': 0x800080,
      'Brown': 0x8B4513,
      'Cyan': 0x00FFFF,
    };

    String closest = 'White';
    int minDist = 999999;

    for (final entry in colors.entries) {
      final cr = (entry.value >> 16) & 0xFF;
      final cg = (entry.value >> 8) & 0xFF;
      final cb = entry.value & 0xFF;
      final dist = (r - cr) * (r - cr) + (g - cg) * (g - cg) + (b - cb) * (b - cb);
      if (dist < minDist) {
        minDist = dist;
        closest = entry.key;
      }
    }

    return closest;
  }
}
