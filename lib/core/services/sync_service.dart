import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/main.dart';

/// Service de synchronisation des données avec le backend
class SyncService {
  static final AuthService _authService = AuthService();

  /// Synchroniser tout le stock vers le backend
  static Future<void> pushSpoolsToBackend() async {
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) return;

      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        debugPrint('⚠️ No access token for spools sync');
        return;
      }

      final spools = await SpoolStorageService.loadSpools();

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.syncPush}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'spools': spools.map((spool) => {
            'id': spool.id,
            'brand': spool.brand,
            'material': spool.material,
            'colorName': spool.colorName,
            'colorRgb': spool.colorRgb,
            'price': spool.price,
            'weight': spool.weight,
            'remainingWeight': spool.remainingWeight,
            'addedDate': spool.addedDate.toIso8601String(),
            'extruderTempMin': spool.extruderTempMin,
            'extruderTempMax': spool.extruderTempMax,
            'bedTempMin': spool.bedTempMin,
            'bedTempMax': spool.bedTempMax,
            'diameter': spool.diameter,
            'spoolLength': spool.spoolLength,
          }).toList(),
        }),
      ).timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 200) {
        debugPrint('✅ ${spools.length} spools synced to backend');
      } else {
        debugPrint('⚠️ Failed to sync spools: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Could not sync spools to backend: $e');
    }
  }

  /// Récupérer le stock depuis le backend
  static Future<void> pullSpoolsFromBackend() async {
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) {
        debugPrint('⚠️ Not signed in, skipping pull');
        return;
      }

      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        debugPrint('⚠️ No access token to pull spools');
        return;
      }

      debugPrint('📥 Pulling spools from backend...');
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.syncPull}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(ApiConfig.connectTimeout);

      debugPrint('Pull spools response: ${response.statusCode}');
      debugPrint('Pull spools body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Decoded pull data: $data');

        if (data['spools'] != null) {
          final spoolsJson = data['spools'] as List<dynamic>;
          debugPrint('Found ${spoolsJson.length} spools in backend response');

          // Clear local spools and replace with backend data
          final spools = spoolsJson.map((json) {
            debugPrint('Processing spool: $json');
            return SpoolInventoryItem(
              id: json['id'] as String,
              brand: json['brand'] as String,
              material: json['material'] as String,
              colorName: json['colorName'] as String,
              colorRgb: json['colorRgb'] as int,
              price: (json['price'] as num).toDouble(),
              weight: (json['weight'] as num).toDouble(),
              remainingWeight: (json['remainingWeight'] as num).toDouble(),
              addedDate: DateTime.parse(json['addedDate'] as String),
              extruderTempMin: json['extruderTempMin'] as int?,
              extruderTempMax: json['extruderTempMax'] as int?,
              bedTempMin: json['bedTempMin'] as int?,
              bedTempMax: json['bedTempMax'] as int?,
              diameter: json['diameter'] != null ? (json['diameter'] as num).toDouble() : null,
              spoolLength: json['spoolLength'] as int?,
              manufactureDate: json['manufactureDate'] != null ? DateTime.parse(json['manufactureDate'] as String) : null,
              batchNumber: json['batchNumber'] as String?,
            );
          }).toList();

          debugPrint('Saving ${spools.length} spools to local storage...');
          await SpoolStorageService.saveSpools(spools);
          debugPrint('✅ ${spools.length} spools pulled from backend');
        } else {
          debugPrint('No spools in backend response');
        }
      } else {
        debugPrint('⚠️ Failed to pull spools: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('⚠️ Could not pull spools from backend: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Synchroniser un spool spécifique (ajout/modification)
  static Future<void> syncSpool(SpoolInventoryItem spool) async {
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) return;

      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) return;

      await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateSpool(spool.id)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'id': spool.id,
          'brand': spool.brand,
          'material': spool.material,
          'colorName': spool.colorName,
          'colorRgb': spool.colorRgb,
          'price': spool.price,
          'weight': spool.weight,
          'remainingWeight': spool.remainingWeight,
          'addedDate': spool.addedDate.toIso8601String(),
          'extruderTempMin': spool.extruderTempMin,
          'extruderTempMax': spool.extruderTempMax,
          'bedTempMin': spool.bedTempMin,
          'bedTempMax': spool.bedTempMax,
          'diameter': spool.diameter,
          'spoolLength': spool.spoolLength,
        }),
      ).timeout(ApiConfig.connectTimeout);

      debugPrint('✅ Spool ${spool.id} synced to backend');
    } catch (e) {
      debugPrint('⚠️ Could not sync spool: $e');
    }
  }

  /// Supprimer un spool du backend
  static Future<void> deleteSpool(String spoolId) async {
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) return;

      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) return;

      await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteSpool(spoolId)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(ApiConfig.connectTimeout);

      debugPrint('✅ Spool $spoolId deleted from backend');
    } catch (e) {
      debugPrint('⚠️ Could not delete spool from backend: $e');
    }
  }

  /// Synchronisation complète (bidirectionnelle)
  static Future<void> fullSync() async {
    debugPrint('🔄 Starting full sync...');

    // Push local changes first
    await pushSpoolsToBackend();

    // Then pull server changes
    await pullSpoolsFromBackend();

    debugPrint('✅ Full sync completed');
  }
}
