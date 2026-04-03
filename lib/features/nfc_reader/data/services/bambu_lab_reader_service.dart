import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nfc_filament/core/constants/bambu_lab_database.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/core/services/cloned_tags_storage_service.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/cloned_tag_model.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

/// Service pour lire les tags NFC Bambu Lab
/// Basé sur les spécifications de https://github.com/Bambu-Research-Group/RFID-Tag-Guide
class BambuLabReaderService {
  static const MethodChannel _channel = MethodChannel('com.anycubic.nfc/native');

  /// Lire les données d'une bobine Bambu Lab depuis un tag NFC
  /// Utilise l'implémentation native iOS pour lire les tags MiFare Classic
  /// Sauvegarde automatiquement le clone dans la bibliothèque
  /// Auto-détecte le type de tag (Ultralight/Anycubic vs Classic/Bambu Lab)
  static Future<BobbinData> readBambuLabTag({bool saveClone = true}) async {
    String? rawHexDump;
    var rawBytesCount = 0;
    try {
      // Appeler le plugin natif pour lire le tag Bambu Lab
      final result = await _channel.invokeMethod('readBambuLabTag');

      if (result == null) {
        throw const NfcTagReadFailure('Aucune donnée reçue du tag Bambu Lab');
      }

      final data = Map<String, dynamic>.from(result as Map);

      // Capturer les raw bytes pour diagnostic en cas d'erreur
      final rawBytes = (data['rawBytes'] as List<dynamic>?)?.cast<int>() ?? [];
      if (rawBytes.isNotEmpty) {
        rawHexDump = 'hex:${rawBytes.take(128).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}';
        rawBytesCount = rawBytes.length;
      }

      // Vérifier si c'est un tag Ultralight (Anycubic) détecté par auto-détection
      final tagType = data['tagType'] as String?;
      if (tagType == 'ultralight') {
        debugPrint('🔄 Tag Ultralight détecté, parsing en mode Anycubic');
        return _parseAnycubicData(data);
      }

      // Parse the data from native plugin (mode Bambu Lab)
      final bobbinData = _parseNativeData(data);

      // Sauvegarder le clone automatiquement si demandé (seulement pour Bambu Lab)
      if (saveClone) {
        final rawBlocks = data['rawBlocks'] as Map<String, dynamic>?;
        if (rawBlocks != null) {
          final clone = ClonedTagModel.fromNativeData(
            bobbinData: bobbinData,
            rawBlocks: rawBlocks,
          );
          await ClonedTagsStorageService.saveClonedTag(clone);
          debugPrint('✅ Clone Bambu Lab sauvegardé: ${clone.displayName}');
        }
      }

      return bobbinData;
    } on PlatformException {
      // Laisser les PlatformException remonter (USER_CANCELLED, TAG_NOT_DETECTED, etc.)
      rethrow;
    } on NfcTagReadFailure {
      rethrow;
    } catch (e) {
      throw NfcTagReadFailure(
        'Erreur parsing tag Bambu Lab: $e',
        rawHexDump,
        rawBytesCount,
      );
    }
  }

  /// Parser les données d'un tag Anycubic/Ultralight
  static BobbinData _parseAnycubicData(Map<String, dynamic> data) {
    final rawBytes = (data['rawBytes'] as List<dynamic>?)?.cast<int>() ?? [];
    final dataString = String.fromCharCodes(
      rawBytes.where((b) => b >= 32 && b < 127),
    );

    debugPrint('📄 Données ASCII Anycubic: $dataString');

    // Chercher le SKU Anycubic (format AHPLBW-107)
    final skuMatch = RegExp(r'A[A-Z]{3,5}[A-Z]{2}-\d{3}').firstMatch(dataString);
    final sku = skuMatch?.group(0) ?? '';

    String filamentType = 'PLA';
    String color = 'Unknown';
    int? colorRgb;

    if (sku.isNotEmpty) {
      final parts = sku.split('-');
      if (parts.length == 2) {
        final code = parts[0].substring(1); // Enlever le 'A'

        // Material type mapping
        final materialMap = {
          'HPL': 'PLA',
          'PLA': 'PLA',
          'HPETG': 'PETG',
          'PETG': 'PETG',
          'HABS': 'ABS',
          'ABS': 'ABS',
          'TPU': 'TPU',
        };

        // Color code mapping
        final colorMap = {
          'BW': 'White',
          'BK': 'Black',
          'RD': 'Red',
          'BL': 'Blue',
          'GR': 'Green',
          'YL': 'Yellow',
          'OR': 'Orange',
          'VO': 'Orange',
          'PK': 'Pink',
          'GY': 'Gray',
          'PR': 'Purple',
          'BR': 'Brown',
        };

        // Try longest material codes first
        final sortedMaterials = materialMap.entries.toList()
          ..sort((a, b) => b.key.length.compareTo(a.key.length));

        for (final entry in sortedMaterials) {
          if (code.startsWith(entry.key)) {
            filamentType = entry.value;
            final remaining = code.substring(entry.key.length);
            if (colorMap.containsKey(remaining)) {
              color = colorMap[remaining]!;
            }
            break;
          }
        }
      }
    }

    // Parse RGB color from pages 20-23 (bytes 80-83)
    if (rawBytes.length >= 84) {
      final b = rawBytes[81];
      final g = rawBytes[82];
      final r = rawBytes[83];
      colorRgb = (r << 16) | (g << 8) | b;
    }

    // Parse temperatures and advanced settings
    int? extruderMin, extruderMax, bedMin, bedMax, spoolLength;
    double weight = 1000.0;
    double? diameter;

    if (rawBytes.length >= 128) {
      extruderMin = rawBytes[96] | (rawBytes[97] << 8);
      extruderMax = rawBytes[98] | (rawBytes[99] << 8);
      bedMin = rawBytes[116] | (rawBytes[117] << 8);
      bedMax = rawBytes[118] | (rawBytes[119] << 8);
      final diameterRaw = rawBytes[120] | (rawBytes[121] << 8);
      diameter = diameterRaw / 100.0;
      spoolLength = rawBytes[122] | (rawBytes[123] << 8);
      weight = ((rawBytes[124] | (rawBytes[125] << 8))).toDouble();
    }

    return BobbinData(
      filamentType: filamentType,
      color: color,
      weightGrams: weight,
      manufactureDate: DateTime.now(),
      batchNumber: sku,
      colorRgb: colorRgb,
      extruderTempMin: extruderMin,
      extruderTempMax: extruderMax,
      bedTempMin: bedMin,
      bedTempMax: bedMax,
      diameter: diameter,
      spoolLength: spoolLength,
      brand: 'Anycubic',
    );
  }

  /// Parser des données natives Bambu Lab déjà lues (pour auto-detect)
  static BobbinData parseFromNativeData(Map<String, dynamic> data) {
    return _parseNativeData(data);
  }

  /// Parser les données brutes reçues du plugin natif
  static BobbinData _parseNativeData(Map<String, dynamic> data) {
    // Extract material index and get material name from database
    final materialIndex = data['materialIndex'] as int? ?? 0;
    String filamentType = 'PLA';
    if (materialIndex >= 0 && materialIndex < BambuLabDatabase.materials.length) {
      filamentType = BambuLabDatabase.materials[materialIndex];
    }

    // Extract temperatures
    final extruderTempMin = data['extruderTempMin'] as int?;
    final extruderTempMax = data['extruderTempMax'] as int?;
    final bedTempMin = data['bedTempMin'] as int?;
    final bedTempMax = data['bedTempMax'] as int?;

    // Extract color
    final colorRgb = data['colorRgb'] as int? ?? 0xFFFFFFFF;

    // Find closest color name from database
    String colorName = 'White';
    int closestColorDiff = 999999999;

    final colors = BambuLabDatabase.getColorsForMaterial(filamentType);
    for (final entry in colors.entries) {
      final dbColorRgb = entry.value;
      // Simple RGB distance calculation
      final rDiff = ((colorRgb >> 16) & 0xFF) - ((dbColorRgb >> 16) & 0xFF);
      final gDiff = ((colorRgb >> 8) & 0xFF) - ((dbColorRgb >> 8) & 0xFF);
      final bDiff = (colorRgb & 0xFF) - (dbColorRgb & 0xFF);
      final diff = (rDiff * rDiff) + (gDiff * gDiff) + (bDiff * bDiff);

      if (diff < closestColorDiff) {
        closestColorDiff = diff;
        colorName = entry.key;
      }
    }

    // Extract weight and length
    final weightGrams = (data['weightGrams'] as int?)?.toDouble() ?? 1000.0;
    final spoolLength = data['spoolLength'] as int?;
    final diameter = data['diameter'] as double? ?? 1.75;

    // Extract production date
    DateTime? manufactureDate;
    final timestamp = data['productionTimestamp'] as int?;
    if (timestamp != null && timestamp > 0) {
      try {
        // Depending on Bambu Lab's format, this might be Unix timestamp or custom format
        // If it's a reasonable Unix timestamp (> year 2000 in seconds)
        if (timestamp > 946684800) {
          manufactureDate = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        }
      } catch (e) {
        // Invalid date, leave as null
      }
    }

    return BobbinData(
      filamentType: filamentType,
      color: colorName,
      colorRgb: colorRgb,
      weightGrams: weightGrams,
      diameter: diameter,
      extruderTempMin: extruderTempMin,
      extruderTempMax: extruderTempMax,
      bedTempMin: bedTempMin,
      bedTempMax: bedTempMax,
      spoolLength: spoolLength,
      manufactureDate: manufactureDate,
      brand: 'Bambu Lab',
      batchNumber: null, // Non disponible dans les tags Bambu Lab
      remainingWeight: weightGrams, // Poids initial = poids restant pour nouveau tag
    );
  }

}
