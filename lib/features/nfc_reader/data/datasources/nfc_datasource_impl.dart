import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/features/nfc_reader/data/datasources/nfc_datasource.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/bobbin_data_model.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/nfc_tag_model.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/bambu_lab_reader_service.dart';
import 'package:nfc_filament/native_nfc/native_nfc.dart';
import 'package:nfc_manager/nfc_manager.dart';

@LazySingleton(as: NfcDataSource)
class NfcDataSourceImpl implements NfcDataSource {
  /// Parse les données Anycubic depuis une chaîne brute et raw bytes
  BobbinDataModel _parseAnycubicData(String data, List<int> rawBytes) {
    // Chercher le SKU (format AHPLBW-107)
    final skuMatch = RegExp(r'A[A-Z]{3,5}[A-Z]{2}-\d{3}').firstMatch(data);
    final sku = skuMatch?.group(0) ?? '';

    developer.log('🔍 SKU trouvé: $sku');

    // Si pas de SKU trouvé, la puce est vide ou non-Anycubic
    if (sku.isEmpty) {
      developer.log('❌ Puce vide ou non-Anycubic détectée');
      throw const NfcTagReadFailure('Tag NFC vide ou non compatible Anycubic');
    }

    String filamentType = 'PLA';
    String color = 'Unknown';
    int? colorRgb;

    if (sku.isNotEmpty) {
      // Parser le SKU
      final parts = sku.split('-');
      if (parts.length == 2) {
        final code = parts[0].substring(1); // Enlever le 'A'

        // Material type mapping (EXACTEMENT comme dans mmu_ace.py ligne 479-488)
        final materialMap = {
          'HPL': 'PLA', // Highspeed
          'PLA': 'PLA', // Basic
          'HPETG': 'PETG', // Highspeed
          'PETG': 'PETG', // Basic
          'HABS': 'ABS', // Highspeed
          'ABS': 'ABS', // Basic
          'TPU': 'TPU', // Basic
        };

        // Color code mapping (EXACTEMENT comme dans mmu_ace.py ligne 490-503)
        final colorMap = {
          'BW': 'White',
          'BK': 'Black',
          'RD': 'Red',
          'BL': 'Blue',
          'GR': 'Green',
          'YL': 'Yellow',
          'OR': 'Orange',
          'VO': 'Orange', // Code non documenté trouvé sur tags Anycubic réels
          'PK': 'Pink',
          'GY': 'Gray',
          'PR': 'Purple',
          'BR': 'Brown',
        };

        // Try longest material codes first (ligne 512)
        final sortedMaterials = materialMap.entries.toList()
          ..sort((a, b) => b.key.length.compareTo(a.key.length));

        for (final entry in sortedMaterials) {
          if (code.startsWith(entry.key)) {
            filamentType = entry.value;
            final remaining = code.substring(entry.key.length);

            developer.log(
              '🔍 Material: ${entry.key} → $filamentType, Remaining: "$remaining"',
            );

            // Check if remaining part is a color code (ligne 518-521)
            if (colorMap.containsKey(remaining)) {
              color = colorMap[remaining]!;
              developer.log('✅ Couleur trouvée: $remaining → $color');
            } else {
              developer.log(
                '⚠️ Code couleur "$remaining" non reconnu (codes valides: ${colorMap.keys.join(", ")})',
              );
            }
            break;
          }
        }
      }
    }

    // Parse RGB color from pages 20-23 (bytes 80-83)
    if (rawBytes.length >= 84) {
      final a = rawBytes[80];
      final b = rawBytes[81];
      final g = rawBytes[82];
      final r = rawBytes[83];
      colorRgb = (r << 16) | (g << 8) | b;
      developer.log('🎨 RGB détecté: ($r, $g, $b) [Alpha: $a]');
    }

    // Si le colorRgb est null, 0 (noir mais pas de données), ou semble invalide,
    // utiliser le mapping basé sur le nom de couleur extrait du SKU
    // Ceci corrige les cas où la page 20 contient des données résiduelles
    final colorNameToRgb = {
      'White': 0xFFFFFF,
      'Black': 0x000000,
      'Red': 0xFF0000,
      'Blue': 0x0000FF,
      'Green': 0x00FF00,
      'Yellow': 0xFFFF00,
      'Orange': 0xFF8000,
      'Pink': 0xFF69B4,
      'Gray': 0x808080,
      'Purple': 0x8000FF,
      'Brown': 0x8B4513,
    };

    // Si on a un nom de couleur connu, utiliser son RGB
    // Ceci garantit que le colorRgb correspond toujours au nom de couleur du SKU
    if (colorNameToRgb.containsKey(color)) {
      final expectedRgb = colorNameToRgb[color]!;
      if (colorRgb != expectedRgb) {
        developer.log(
          '🔄 Correction RGB: $colorRgb → $expectedRgb (basé sur couleur "$color")',
        );
        colorRgb = expectedRgb;
      }
    }

    // Parse temperatures and advanced settings
    int? extruderMin, extruderMax, bedMin, bedMax, spoolLength;
    double weight = 1000.0;
    double? diameter;

    if (rawBytes.length >= 128) {
      // Pages 24-27 (bytes 96-99): Températures extrudeur
      extruderMin = rawBytes[96] | (rawBytes[97] << 8);
      extruderMax = rawBytes[98] | (rawBytes[99] << 8);

      // Pages 28-31 (bytes 116-127): Bed + paramètres
      bedMin = rawBytes[116] | (rawBytes[117] << 8);
      bedMax = rawBytes[118] | (rawBytes[119] << 8);
      final diameterRaw = rawBytes[120] | (rawBytes[121] << 8);
      diameter = diameterRaw / 100.0;
      spoolLength = rawBytes[122] | (rawBytes[123] << 8);
      weight = ((rawBytes[124] | (rawBytes[125] << 8))).toDouble();

      developer.log('🌡️ Extrudeur: $extruderMin-$extruderMax°C');
      developer.log('🌡️ Plateau: $bedMin-$bedMax°C');
      developer.log('📏 Diamètre: ${diameter}mm');
      developer.log('📏 Longueur: ${spoolLength}m');
      developer.log('⚖️ Poids: ${weight}g');
    }

    return BobbinDataModel(
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
    );
  }

  @override
  Future<bool> isNfcAvailable() async {
    try {
      developer.log('🔍 Vérification de la disponibilité NFC...');
      final availability = await NfcManager.instance.checkAvailability();
      final isAvailable = availability == NfcAvailability.enabled;
      developer.log('✅ NFC disponible: $isAvailable');
      return isAvailable;
    } catch (e) {
      developer.log('❌ Erreur vérification NFC: $e');
      return Future.error(const NfcNotAvailableFailure());
    }
  }

  @override
  Future<NfcTagModel> readNfcTag() async {
    developer.log('📱 Démarrage lecture tag NFC avec plugin natif...');

    try {
      final result = await NativeNfc.startReadSession();

      final data = <String, dynamic>{
        'data': result['data'] as String? ?? '',
        'rawBytes': result['rawBytes'] as List<int>? ?? [],
      };

      return NfcTagModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'MiFare',
        data: data,
      );
    } catch (e) {
      developer.log('❌ Erreur lecture NFC: $e');
      return Future.error(NfcTagReadFailure(e.toString()));
    }
  }

  @override
  Future<BobbinDataModel> readBobbinData() async {
    developer.log('📱 Démarrage scan bobine avec plugin natif...');

    // Vérifier le mode NFC (Anycubic ou Bambu Lab)
    final nfcMode = await UserPreferencesService.getNfcMode();
    developer.log('🔧 Mode NFC: $nfcMode');

    // Si mode Bambu Lab explicitement sélectionné, utiliser le lecteur spécifique
    if (nfcMode == 'bambu') {
      developer.log('🏷️ Mode Bambu Lab détecté, utilisation du lecteur Bambu Lab');
      try {
        return await _readBambuLabTag();
      } catch (e) {
        developer.log('⚠️ Échec lecture Bambu Lab, tentative en mode Anycubic: $e');
        // Si la lecture Bambu Lab échoue, essayer en mode Anycubic
        // (le tag pourrait être un Anycubic/NTAG même si le mode est sur Bambu)
      }
    }

    try {
      // Utiliser le plugin natif qui gère correctement la connexion (Anycubic)
      final result = await NativeNfc.startReadSession();

      // Récupérer les bytes bruts (pas la string UTF8 qui échoue)
      final rawBytes =
          (result['rawBytes'] as List<dynamic>?)?.cast<int>() ?? [];

      developer.log('📄 Bytes bruts lus: ${rawBytes.length} bytes');
      developer.log('🔍 Lecture RFID complète (hex): ${rawBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
      developer.log('🔍 Lecture RFID complète (dec): $rawBytes');

      // Convertir les bytes en string (en ignorant les bytes non-ASCII)
      final dataString = String.fromCharCodes(
        rawBytes.where(
          (b) => b >= 32 && b < 127,
        ), // Garder seulement ASCII imprimable
      );

      developer.log('📄 Données ASCII: $dataString');

      // Détecter le format: Spool NFC Tag Writer (Brand + Material) ou Anycubic (SKU)
      final hasSku = RegExp(r'A[A-Z]{3,5}[A-Z]{2}-\d{3}').hasMatch(dataString);

      if (!hasSku && rawBytes.length >= 64) {
        // Format "Spool NFC Tag Writer": Brand at pages 8-11, Material at pages 12-15
        developer.log('🔍 Format détecté: Spool NFC Tag Writer (Brand + Material)');

        // Pages 8-11 = bytes 40-55 (16 bytes pour brand, commence au milieu de page 8)
        // Pages 12-15 = bytes 60-75 (16 bytes pour material, commence au milieu de page 12)
        final brandBytes = rawBytes.length > 55 ? rawBytes.sublist(40, 56) : rawBytes.sublist(40);
        final materialBytes = rawBytes.length > 75 ? rawBytes.sublist(60, 76) : rawBytes.sublist(60, rawBytes.length.clamp(60, 160));

        final brand = String.fromCharCodes(brandBytes.where((b) => b >= 32 && b < 127)).trim();
        final material = String.fromCharCodes(materialBytes.where((b) => b >= 32 && b < 127)).trim();

        developer.log('🏷️ Brand: "$brand", Material: "$material"');

        // Parse color from pages 20-23 (bytes 80-83) - ABGR format (little-endian)
        String colorName = 'Unknown';
        int? colorRgb;
        if (rawBytes.length >= 84) {
          // Format ABGR: Alpha, Blue, Green, Red
          final a = rawBytes[80];
          final b = rawBytes[81];
          final g = rawBytes[82];
          final r = rawBytes[83];
          developer.log('🎨 RGB détecté: ($r, $g, $b) [Alpha: $a]');
          developer.log('🎨 Hex sRGB: ${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}');

          // Store RGB as integer (0xRRGGBB)
          colorRgb = (r << 16) | (g << 8) | b;

          // Convert RGB to color name
          colorName = _rgbToColorName(r, g, b);
          developer.log('🎨 Couleur: $colorName');
        }

        // Parse temperatures and advanced settings
        int? extruderMin, extruderMax, bedMin, bedMax, spoolLength;
        double weight = 1000.0;
        double? diameter;

        if (rawBytes.length >= 128) {
          // Pages 24-27 (bytes 96-99): Températures extrudeur
          extruderMin = rawBytes[96] | (rawBytes[97] << 8);
          extruderMax = rawBytes[98] | (rawBytes[99] << 8);
          developer.log('🌡️ Extrudeur: $extruderMin-$extruderMax°C');

          // Pages 28-31 (bytes 116-127): Bed + paramètres
          bedMin = rawBytes[116] | (rawBytes[117] << 8);
          bedMax = rawBytes[118] | (rawBytes[119] << 8);
          final diameterRaw = rawBytes[120] | (rawBytes[121] << 8);
          diameter = diameterRaw / 100.0; // Converti de 0.01mm en mm
          spoolLength = rawBytes[122] | (rawBytes[123] << 8);
          weight = ((rawBytes[124] | (rawBytes[125] << 8))).toDouble();

          developer.log('🌡️ Plateau: $bedMin-$bedMax°C');
          developer.log('📏 Diamètre: ${diameter}mm');
          developer.log('📏 Longueur: ${spoolLength}m');
          developer.log('⚖️ Poids: ${weight}g');
        }

        return BobbinDataModel(
          filamentType: material.trim(),
          color: colorName,
          weightGrams: weight,
          manufactureDate: DateTime.now(),
          batchNumber: '$brand - $material',
          colorRgb: colorRgb,
          extruderTempMin: extruderMin,
          extruderTempMax: extruderMax,
          bedTempMin: bedMin,
          bedTempMax: bedMax,
          diameter: diameter,
          spoolLength: spoolLength,
        );
      }

      // Parser les données Anycubic (format SKU)
      final bobbinModel = _parseAnycubicData(dataString, rawBytes);
      return bobbinModel;
    } catch (e) {
      developer.log('❌ Erreur lecture NFC native: $e');
      return Future.error(NfcTagReadFailure(e.toString()));
    }
  }

  @override
  Future<void> writeBobbinData(BobbinDataModel data) async {
    developer.log('✍️ Démarrage écriture bobine Anycubic avec plugin natif...');

    try {
      final sku = data.batchNumber ?? '';
      final type = data.filamentType;

      // Préparer toutes les données
      final skuBytes = _padBytes(utf8.encode(sku), 16);
      final brandBytes = _padBytes(utf8.encode('AC'), 16);
      final typeBytes = _padBytes(utf8.encode(type), 16);

      // RGB Color (pages 20-23, bytes 80-83)
      final colorRgb = data.colorRgb ?? 0xFF8000; // Default orange
      final r = (colorRgb >> 16) & 0xFF;
      final g = (colorRgb >> 8) & 0xFF;
      final b = colorRgb & 0xFF;
      final a = 0xFF; // Full opacity

      // Temperatures and advanced settings
      final extruderMin = data.extruderTempMin ?? 190;
      final extruderMax = data.extruderTempMax ?? 230;
      final bedMin = data.bedTempMin ?? 50;
      final bedMax = data.bedTempMax ?? 60;
      final diameter = ((data.diameter ?? 1.75) * 100).toInt(); // Convert to 0.01mm units
      final spoolLength = data.spoolLength ?? 330;
      final weight = data.weightGrams.toInt();

      developer.log('🎨 Écriture RGB: ($r, $g, $b)');
      developer.log('🌡️ Extrudeur: $extruderMin-$extruderMax°C');
      developer.log('🌡️ Plateau: $bedMin-$bedMax°C');
      developer.log('📏 Diamètre: ${data.diameter}mm → $diameter (0.01mm units)');
      developer.log('📏 Longueur: ${spoolLength}m');
      developer.log('⚖️ Poids: ${weight}g');

      // Préparer les pages à écrire
      final pages = <Map<String, dynamic>>[
        {'page': 3, 'data': [0xE1, 0x10, 0x06, 0x00]}, // NDEF CC
        {'page': 4, 'data': [0x7b, 0x00, 0x65, 0x00]}, // Anycubic header
        // SKU (pages 5-8)
        {'page': 5, 'data': skuBytes.sublist(0, 4)},
        {'page': 6, 'data': skuBytes.sublist(4, 8)},
        {'page': 7, 'data': skuBytes.sublist(8, 12)},
        {'page': 8, 'data': skuBytes.sublist(12, 16)},
        // Brand (pages 10-13 = bytes 40-55)
        {'page': 10, 'data': brandBytes.sublist(0, 4)},
        {'page': 11, 'data': brandBytes.sublist(4, 8)},
        {'page': 12, 'data': brandBytes.sublist(8, 12)},
        {'page': 13, 'data': brandBytes.sublist(12, 16)},
        // Type (pages 15-18 = bytes 60-75)
        {'page': 15, 'data': typeBytes.sublist(0, 4)},
        {'page': 16, 'data': typeBytes.sublist(4, 8)},
        {'page': 17, 'data': typeBytes.sublist(8, 12)},
        {'page': 18, 'data': typeBytes.sublist(12, 16)},
        // Color RGB (pages 20-23, bytes 80-83 - ABGR format)
        {'page': 20, 'data': [a, b, g, r]},
        // Extruder temperatures (pages 24-25, bytes 96-99)
        {
          'page': 24,
          'data': [
            extruderMin & 0xFF,
            (extruderMin >> 8) & 0xFF,
            extruderMax & 0xFF,
            (extruderMax >> 8) & 0xFF,
          ]
        },
        // Bed temperatures + diameter + length + weight (pages 29-31, bytes 116-127)
        {
          'page': 29,
          'data': [
            bedMin & 0xFF,
            (bedMin >> 8) & 0xFF,
            bedMax & 0xFF,
            (bedMax >> 8) & 0xFF,
          ]
        },
        {
          'page': 30,
          'data': [
            diameter & 0xFF,
            (diameter >> 8) & 0xFF,
            spoolLength & 0xFF,
            (spoolLength >> 8) & 0xFF,
          ]
        },
        {
          'page': 31,
          'data': [
            weight & 0xFF,
            (weight >> 8) & 0xFF,
            0x00,
            0x00,
          ]
        },
      ];

      await NativeNfc.startWriteSession(pages);
      developer.log('✅ Écriture terminée avec succès');
    } catch (e) {
      developer.log('❌ Erreur écriture NFC native: $e');
      return Future.error(
        NfcTagReadFailure('Erreur écriture: ${e.toString()}'),
      );
    }
  }

  /// Pad bytes to desired length with zeros
  List<int> _padBytes(List<int> bytes, int length) {
    if (bytes.length >= length) return bytes.sublist(0, length);
    return [...bytes, ...List.filled(length - bytes.length, 0)];
  }

  /// Convert RGB values to human-readable color name
  String _rgbToColorName(int r, int g, int b) {
    // Détecter les couleurs en utilisant HSV pour une meilleure précision
    // Si c'est majoritairement rouge (R >> G et R >> B), c'est rouge
    if (r > 100 && r > g * 3 && r > b * 3) {
      return 'Red';
    }

    // Si c'est majoritairement bleu (B >> R et B >> G), c'est bleu/purple
    if (b > 100 && b > r && b > g) {
      if (r > 80) {
        return 'Purple'; // Violet si un peu de rouge
      }
      return 'Blue';
    }

    // Orange : beaucoup de rouge, un peu de vert, peu de bleu
    if (r > 200 && g > 100 && g < r && b < 100) {
      return 'Orange';
    }

    // Vert
    if (g > 100 && g > r && g > b) {
      return 'Green';
    }

    // Jaune
    if (r > 200 && g > 200 && b < 100) {
      return 'Yellow';
    }

    // Rose
    if (r > 200 && g > 150 && b > 150) {
      return 'Pink';
    }

    // Noir/Gris/Blanc (basé sur la luminosité)
    final brightness = (r + g + b) / 3;
    if (brightness < 50) {
      return 'Black';
    } else if (brightness > 200) {
      return 'White';
    } else if ((r - g).abs() < 30 && (g - b).abs() < 30) {
      return 'Gray';
    }

    // Marron (rouge foncé avec un peu de vert)
    if (r > 80 && g > 20 && g < r && b < 50 && brightness < 120) {
      return 'Brown';
    }

    return 'Unknown';
  }

  /// Lire un tag Bambu Lab en utilisant le plugin natif iOS
  Future<BobbinDataModel> _readBambuLabTag() async {
    developer.log('🏷️ Démarrage lecture tag Bambu Lab...');

    try {
      // Utiliser le service Bambu Lab avec le plugin natif
      final bobbinData = await BambuLabReaderService.readBambuLabTag();

      // Convertir en modèle
      final model = BobbinDataModel(
        filamentType: bobbinData.filamentType,
        color: bobbinData.color,
        weightGrams: bobbinData.weightGrams,
        manufactureDate: bobbinData.manufactureDate,
        batchNumber: bobbinData.batchNumber,
        colorRgb: bobbinData.colorRgb,
        extruderTempMin: bobbinData.extruderTempMin,
        extruderTempMax: bobbinData.extruderTempMax,
        bedTempMin: bobbinData.bedTempMin,
        bedTempMax: bobbinData.bedTempMax,
        diameter: bobbinData.diameter,
        spoolLength: bobbinData.spoolLength,
        remainingWeight: bobbinData.remainingWeight,
        brand: bobbinData.brand,
      );

      developer.log('✅ Tag Bambu Lab lu avec succès');
      return model;
    } catch (e) {
      developer.log('❌ Erreur lecture tag Bambu Lab: $e');
      throw NfcTagReadFailure('Erreur lecture Bambu Lab: $e');
    }
  }
}
