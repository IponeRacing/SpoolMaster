import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/sync_queue_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';

/// Service de synchronisation des données avec le backend
class SyncService {
  static final AuthService _authService = AuthService();
  static bool _flushing = false;

  /// Construit le payload JSON d'une bobine pour le backend (upsert).
  static Map<String, dynamic> _spoolPayload(SpoolInventoryItem spool) => {
        'spool_id': spool.id,
        'brand': spool.brand,
        'material': spool.material,
        'color_name': spool.colorName,
        'color_rgb': spool.colorRgb,
        'price': spool.price,
        'initial_weight': spool.weight,
        'remaining_weight': spool.remainingWeight,
        'added_date': spool.addedDate.toIso8601String(),
        'extruder_temp_min': spool.extruderTempMin,
        'extruder_temp_max': spool.extruderTempMax,
        'bed_temp_min': spool.bedTempMin,
        'bed_temp_max': spool.bedTempMax,
        'diameter': spool.diameter,
        'spool_length': spool.spoolLength,
        'manufacture_date': spool.manufactureDate?.toIso8601String(),
        'batch_number': spool.batchNumber,
        'detailed_type': spool.detailedType,
        'drying_temp': spool.dryingTemp,
        'drying_time': spool.dryingTime,
        'material_variant_id': spool.materialVariantId,
        'material_id': spool.materialId,
      };

  /// Synchroniser tout le stock vers le backend
  static Future<void> pushSpoolsToBackend() async {
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) return;

      final spools = await SpoolStorageService.loadSpools();

      final response = await _authService.authenticatedRequest((token) =>
        http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.syncPush}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'spools': spools.map((spool) => {
              'spool_id': spool.id,
              'brand': spool.brand,
              'material': spool.material,
              'color_name': spool.colorName,
              'color_rgb': spool.colorRgb,
              'price': spool.price,
              'initial_weight': spool.weight,
              'remaining_weight': spool.remainingWeight,
              'added_date': spool.addedDate.toIso8601String(),
              'extruder_temp_min': spool.extruderTempMin,
              'extruder_temp_max': spool.extruderTempMax,
              'bed_temp_min': spool.bedTempMin,
              'bed_temp_max': spool.bedTempMax,
              'diameter': spool.diameter,
              'spool_length': spool.spoolLength,
              'manufacture_date': spool.manufactureDate?.toIso8601String(),
              'batch_number': spool.batchNumber,
              'detailed_type': spool.detailedType,
              'drying_temp': spool.dryingTemp,
              'drying_time': spool.dryingTime,
              'material_variant_id': spool.materialVariantId,
              'material_id': spool.materialId,
            }).toList(),
          }),
        ).timeout(ApiConfig.connectTimeout),
      );

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

      debugPrint('📥 Pulling spools from backend...');
      final response = await _authService.authenticatedRequest((token) =>
        http.get(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.syncPull}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(ApiConfig.connectTimeout),
      );

      debugPrint('Pull spools response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;

        // Le backend retourne { success: true, data: { spools: [...] } }
        final data = (responseData['data'] as Map<String, dynamic>?) ?? responseData;
        if (data['spools'] != null) {
          final spoolsJson = data['spools'] as List<dynamic>;
          debugPrint('Found ${spoolsJson.length} spools in backend response');

          // Clear local spools and replace with backend data
          final spools = spoolsJson.map((jsonItem) {
            final json = jsonItem as Map<String, dynamic>;
            return SpoolInventoryItem(
              id: (json['spool_id'] ?? json['id']) as String,
              brand: (json['brand'] ?? '') as String,
              material: (json['material'] ?? '') as String,
              colorName: (json['color_name'] ?? json['colorName'] ?? '') as String,
              colorRgb: (json['color_rgb'] ?? json['colorRgb'] ?? 0) as int,
              price: json['price'] != null ? (json['price'] as num).toDouble() : 0.0,
              weight: json['initial_weight'] != null ? (json['initial_weight'] as num).toDouble() : (json['weight'] != null ? (json['weight'] as num).toDouble() : 0.0),
              remainingWeight: json['remaining_weight'] != null ? (json['remaining_weight'] as num).toDouble() : (json['remainingWeight'] != null ? (json['remainingWeight'] as num).toDouble() : 0.0),
              addedDate: json['added_date'] != null ? DateTime.parse(json['added_date'] as String) : (json['addedDate'] != null ? DateTime.parse(json['addedDate'] as String) : (json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now())),
              extruderTempMin: (json['extruder_temp_min'] ?? json['extruderTempMin']) as int?,
              extruderTempMax: (json['extruder_temp_max'] ?? json['extruderTempMax']) as int?,
              bedTempMin: (json['bed_temp_min'] ?? json['bedTempMin']) as int?,
              bedTempMax: (json['bed_temp_max'] ?? json['bedTempMax']) as int?,
              diameter: (json['diameter'] != null) ? (json['diameter'] as num).toDouble() : null,
              spoolLength: (json['spool_length'] ?? json['spoolLength']) as int?,
              manufactureDate: (json['manufacture_date'] ?? json['manufactureDate']) != null ? DateTime.parse((json['manufacture_date'] ?? json['manufactureDate']) as String) : null,
              batchNumber: (json['batch_number'] ?? json['batchNumber']) as String?,
              detailedType: (json['detailed_type'] ?? json['detailedType']) as String?,
              dryingTemp: (json['drying_temp'] ?? json['dryingTemp']) as int?,
              dryingTime: (json['drying_time'] ?? json['dryingTime']) as int?,
              materialVariantId: (json['material_variant_id'] ?? json['materialVariantId']) as String?,
              materialId: (json['material_id'] ?? json['materialId']) as String?,
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

  /// Synchroniser un spool spécifique (ajout/modification).
  /// En cas d'échec (hors ligne, erreur serveur…), l'opération est mise en file
  /// et rejouée au prochain lancement / retour au premier plan (voir
  /// [flushPendingQueue]) → plus aucune bobine perdue faute de réseau.
  static Future<void> syncSpool(SpoolInventoryItem spool) async {
    final isSignedIn = await UserPreferencesService.isSignedIn();
    if (!isSignedIn) return;

    final payload = _spoolPayload(spool);
    try {
      final response = await _authService.authenticatedRequest((token) =>
        http.put(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateSpool(spool.id)}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(payload),
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await SyncQueueService.remove(spool.id);
        debugPrint('✅ Spool ${spool.id} synced to backend');
      } else {
        await SyncQueueService.enqueueUpsert(spool.id, payload);
        debugPrint('⚠️ Sync spool HTTP ${response.statusCode} → mis en file');
      }
    } catch (e) {
      await SyncQueueService.enqueueUpsert(spool.id, payload);
      debugPrint('⚠️ Could not sync spool (mis en file): $e');
    }
  }

  /// Supprimer un spool du backend. En cas d'échec, mis en file et rejoué.
  static Future<void> deleteSpool(String spoolId) async {
    final isSignedIn = await UserPreferencesService.isSignedIn();
    if (!isSignedIn) return;

    try {
      final response = await _authService.authenticatedRequest((token) =>
        http.delete(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteSpool(spoolId)}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(ApiConfig.connectTimeout),
      );

      // 404 = déjà absent côté serveur → considéré comme réussi (idempotent).
      if ((response.statusCode >= 200 && response.statusCode < 300) ||
          response.statusCode == 404) {
        await SyncQueueService.remove(spoolId);
        debugPrint('✅ Spool $spoolId deleted from backend');
      } else {
        await SyncQueueService.enqueueDelete(spoolId);
        debugPrint('⚠️ Delete spool HTTP ${response.statusCode} → mis en file');
      }
    } catch (e) {
      await SyncQueueService.enqueueDelete(spoolId);
      debugPrint('⚠️ Could not delete spool (mis en file): $e');
    }
  }

  /// Rejoue les opérations de synchronisation en attente (échecs réseau
  /// précédents). Appelé au lancement et au retour au premier plan de l'app.
  /// Idempotent et fail-open : une opération qui réussit est retirée ; une qui
  /// échoue voit son compteur d'essais augmenter et est abandonnée au-delà de
  /// [SyncQueueService.maxAttempts] (payload définitivement rejeté).
  static Future<void> flushPendingQueue() async {
    if (_flushing) return;
    if (!await UserPreferencesService.isSignedIn()) return;

    final ops = await SyncQueueService.loadAll();
    if (ops.isEmpty) return;

    _flushing = true;
    debugPrint('🔁 Flush file de sync : ${ops.length} opération(s)');
    final remaining = <Map<String, dynamic>>[];
    try {
      for (final op in ops) {
        final spoolId = op['spoolId'] as String;
        final type = op['type'] as String;
        var ok = false;
        try {
          if (type == 'delete') {
            final r = await _authService.authenticatedRequest((token) =>
              http.delete(
                Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteSpool(spoolId)}'),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
              ).timeout(ApiConfig.connectTimeout));
            ok = (r.statusCode >= 200 && r.statusCode < 300) ||
                r.statusCode == 404;
          } else {
            final payload = Map<String, dynamic>.from(op['payload'] as Map);
            final r = await _authService.authenticatedRequest((token) =>
              http.put(
                Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateSpool(spoolId)}'),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode(payload),
              ).timeout(ApiConfig.connectTimeout));
            ok = r.statusCode >= 200 && r.statusCode < 300;
          }
        } catch (e) {
          ok = false;
          debugPrint('⚠️ Flush op $type $spoolId échec: $e');
        }

        if (!ok) {
          final attempts = (op['attempts'] as int? ?? 0) + 1;
          if (attempts < SyncQueueService.maxAttempts) {
            remaining.add({...op, 'attempts': attempts});
          } else {
            debugPrint('🗑️ Op $type $spoolId abandonnée après $attempts essais');
          }
        }
      }
      await SyncQueueService.replaceAll(remaining);
      debugPrint('✅ Flush terminé : ${remaining.length} restante(s)');
    } finally {
      _flushing = false;
    }
  }

  /// Synchronisation complète (bidirectionnelle)
  static Future<void> fullSync() async {
    debugPrint('🔄 Starting full sync...');

    // Rejouer d'abord les opérations en attente (échecs réseau précédents)
    await flushPendingQueue();

    // Push ALL local spools (from all keys) to ensure nothing is lost
    await pushAllLocalSpoolsToBackend();

    // Then pull server changes (this will merge/replace local data)
    await pullSpoolsFromBackend();

    debugPrint('✅ Full sync completed');
  }

  /// Push tous les spools locaux (de toutes les clés) vers le backend
  /// Utilisé lors de la reconnexion pour ne pas perdre de données
  static Future<void> pushAllLocalSpoolsToBackend() async {
    try {
      // Charger TOUS les spools de toutes les clés locales
      final spools = await SpoolStorageService.loadAllSpools();

      if (spools.isEmpty) {
        debugPrint('📭 No local spools to push');
        return;
      }

      debugPrint('📤 Pushing ${spools.length} spools from all local keys...');

      final response = await _authService.authenticatedRequest((token) =>
        http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.syncPush}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'spools': spools.map((spool) => {
              'spool_id': spool.id,
              'brand': spool.brand,
              'material': spool.material,
              'color_name': spool.colorName,
              'color_rgb': spool.colorRgb,
              'price': spool.price,
              'initial_weight': spool.weight,
              'remaining_weight': spool.remainingWeight,
              'added_date': spool.addedDate.toIso8601String(),
              'extruder_temp_min': spool.extruderTempMin,
              'extruder_temp_max': spool.extruderTempMax,
              'bed_temp_min': spool.bedTempMin,
              'bed_temp_max': spool.bedTempMax,
              'diameter': spool.diameter,
              'spool_length': spool.spoolLength,
              'manufacture_date': spool.manufactureDate?.toIso8601String(),
              'batch_number': spool.batchNumber,
              'detailed_type': spool.detailedType,
              'drying_temp': spool.dryingTemp,
              'drying_time': spool.dryingTime,
              'material_variant_id': spool.materialVariantId,
              'material_id': spool.materialId,
            }).toList(),
          }),
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ ${spools.length} spools pushed to backend (full sync)');
      } else {
        debugPrint('⚠️ Failed to push spools: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Could not push all spools to backend: $e');
    }
  }
}
