import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/core/services/cloned_tags_storage_service.dart';
import 'package:nfc_filament/core/utils/color_naming.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/cloned_tag_model.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/bambu_tag_parser.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/native_nfc/native_nfc.dart';

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
      await NativeNfc.endStaleSession();
      final result = await _channel.invokeMethod('readBambuLabTag');

      if (result == null) {
        throw const NfcTagReadFailure(message: 'Aucune donnée reçue du tag Bambu Lab');
      }

      final data = Map<String, dynamic>.from(result is Map ? result : {});

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
      if (saveClone) _saveCloneInBackground(data, bobbinData);

      return bobbinData;
    } on PlatformException {
      // Laisser les PlatformException remonter (USER_CANCELLED, TAG_NOT_DETECTED, etc.)
      rethrow;
    } on NfcTagReadFailure {
      rethrow;
    } on NfcTagIncompatibleFailure {
      rethrow; // tag d'une autre marque : message explicite, pas « erreur de parsing »
    } catch (e) {
      debugPrint('❌ Erreur parsing Bambu Lab: $e\n${e is Error ? e.stackTrace : ""}');
      throw NfcTagReadFailure(
        message: 'Erreur parsing tag Bambu Lab: $e',
        rawTagData: rawHexDump,
        rawBytesCount: rawBytesCount,
      );
    }
  }

  /// Sauvegarde du clone isolée de la lecture : sans attente bloquante et
  /// dans son propre try. Avant, une erreur de stockage (ou de conversion des
  /// blocs) faisait échouer une lecture Bambu pourtant réussie.
  static void _saveCloneInBackground(
    Map<String, dynamic> data,
    BobbinData bobbinData,
  ) {
    try {
      final raw = data['rawBlocks'];
      if (raw is! Map) return;
      final clone = ClonedTagModel.fromNativeData(
        bobbinData: bobbinData,
        rawBlocks: Map<String, dynamic>.from(raw),
      );
      unawaited(
        ClonedTagsStorageService.saveClonedTag(clone).then(
          (_) => debugPrint('✅ Clone Bambu Lab sauvegardé: ${clone.displayName}'),
          onError: (Object e) => debugPrint('⚠️ Sauvegarde du clone impossible (ignorée): $e'),
        ),
      );
    } catch (e) {
      debugPrint('⚠️ Clone Bambu Lab non créé (ignoré): $e');
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

    var filamentType = 'PLA';
    var color = 'Unknown';
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
          'HPE': 'PETG', // SKU réels « AHPEBK », « AHPECL »
          'HABS': 'ABS',
          'ABS': 'ABS',
          'TPU': 'TPU',
        };

        // Try longest material codes first
        final sortedMaterials = materialMap.entries.toList()
          ..sort((a, b) => b.key.length.compareTo(a.key.length));

        for (final entry in sortedMaterials) {
          if (code.startsWith(entry.key)) {
            filamentType = entry.value;
            final remaining = code.substring(entry.key.length);
            color = anycubicSkuColorName(remaining) ?? color;
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
    // Transparent : pastille hachurée au lieu d'un noir (RGB 0 sans sens)
    if (color == 'Transparent' && (colorRgb == null || colorRgb == 0)) {
      colorRgb = kClearFilamentRgb;
    }

    // Parse temperatures and advanced settings
    int? extruderMin;
    int? extruderMax;
    int? bedMin;
    int? bedMax;
    int? spoolLength;
    double weight = 1000;
    double? diameter;

    if (rawBytes.length >= 128) {
      extruderMin = rawBytes[96] | (rawBytes[97] << 8);
      extruderMax = rawBytes[98] | (rawBytes[99] << 8);
      bedMin = rawBytes[116] | (rawBytes[117] << 8);
      bedMax = rawBytes[118] | (rawBytes[119] << 8);
      final diameterRaw = rawBytes[120] | (rawBytes[121] << 8);
      diameter = diameterRaw / 100.0;
      spoolLength = rawBytes[122] | (rawBytes[123] << 8);
      weight = (rawBytes[124] | (rawBytes[125] << 8)).toDouble();
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

  /// Décode les blocs bruts du tag (format officiel : voir [BambuTagParser]).
  static BobbinData _parseNativeData(Map<String, dynamic> data) {
    final blocks = BambuTagParser.blocksFromNative(data['rawBlocks']);
    if (blocks.containsKey(5) && !BambuTagParser.isBambuTag(blocks)) {
      throw const NfcTagIncompatibleFailure(
        message: "Tag MIFARE Classic lu, mais ce n'est pas une bobine Bambu Lab "
            '(ni Creality). Les tags Qidi et Snapmaker ne sont pas pris en charge.',
        tagType: 'MifareClassic',
        tagWasDetected: true,
      );
    }
    final parsed = BambuTagParser.parse(blocks);
    if (parsed == null) {
      throw const NfcTagReadFailure(
        message: 'Données Bambu Lab incomplètes (bloc 5 illisible). Gardez le tag immobile et réessayez.',
      );
    }
    return parsed;
  }

}
