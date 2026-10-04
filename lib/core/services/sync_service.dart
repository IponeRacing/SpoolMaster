import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/sync_queue_service.dart';
import 'package:nfc_filament/core/services/usage_sync_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';

/// Service de synchronisation des données avec le backend
class SyncService {
  static final AuthService _authService = AuthService();
  static bool _flushing = false;

  /// En-têtes des requêtes de sync (X-App-Version → version visible dans les
  /// logs serveur).
  static Map<String, String> _headers(String token) => {
        ...ApiConfig.commonHeaders,
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

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
        // Toujours envoyés (null = vidé) : le backend ne les écrase que
        // s'ils sont présents, pour ne pas perdre ceux saisis sur 1.4.10+
        // quand une ancienne version de l'app pousse.
        'location': spool.location,
        'notes': spool.notes,
        'nozzle_size': spool.nozzleSize,
        'vendor_code': spool.vendorCode,
        'product_code': spool.productCode,
      };

  static String? _nonEmpty(Object? v) {
    final s = v?.toString().trim();
    return (s == null || s.isEmpty) ? null : s;
  }

  static String _truncate(String s, [int max = 300]) =>
      s.length <= max ? s : '${s.substring(0, max)}…';

  /// Coupure réseau / timeout : attendu (hors ligne), pas un bug.
  static bool _isNetworkError(Object? error) =>
      error is SocketException ||
      error is TimeoutException ||
      error is http.ClientException;

  /// Remonte un échec de sync. Avant, tout finissait en debugPrint → aucune
  /// trace en production. Désormais :
  /// - événement `sync_error` sur le backend (agrégé dans le rapport
  ///   journalier), avec le X-Request-Id pour retrouver la ligne du log serveur ;
  /// - non-fatal Crashlytics (avec stack) pour les exceptions inattendues
  ///   (parsing, typage…), simple breadcrumb pour les coupures réseau.
  /// Non bloquant : ne jamais faire attendre la sync sur le reporting.
  static void _reportSyncError(
    String op, {
    http.Response? response,
    Object? error,
    StackTrace? stack,
    String? spoolId,
    int? spoolCount,
    Map<String, dynamic>? extra,
  }) {
    final status = response?.statusCode;
    debugPrint('⚠️ [Sync] $op échec: ${status ?? error}');

    try {
      if (error != null && !_isNetworkError(error)) {
        unawaited(FirebaseCrashlytics.instance
            .recordError(error, stack, reason: 'sync:$op'));
      } else {
        unawaited(FirebaseCrashlytics.instance
            .log('sync:$op failed ${status ?? error.runtimeType}'));
      }
    } catch (_) {}

    unawaited(AnalyticsService.logEvent(
      'sync_error',
      eventData: {
        'op': op,
        'http_status': ?status,
        'error_type': error?.runtimeType.toString() ?? 'http',
        if (error != null) 'error': _truncate(error.toString()),
        if (response != null && status != null && status >= 400)
          'response': _truncate(response.body),
        'request_id': ?response?.headers['x-request-id'],
        'spool_id': ?spoolId,
        'spool_count': ?spoolCount,
        ...?extra,
      },
    ));
  }

  /// Synchroniser tout le stock vers le backend
  static Future<void> pushSpoolsToBackend() async {
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) return;

      final spools = await SpoolStorageService.loadSpools();

      final response = await _authService.authenticatedRequest((token) =>
        http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.syncPush}'),
          headers: _headers(token),
          body: jsonEncode({
            'spools': spools.map(_spoolPayload).toList(),
          }),
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ ${spools.length} spools synced to backend');
      } else {
        _reportSyncError('push', response: response, spoolCount: spools.length);
      }
    } catch (e, stack) {
      _reportSyncError('push', error: e, stack: stack);
    }
  }

  /// Récupérer le stock depuis le backend et remplacer le stock local.
  ///
  /// Les bobines locales dont la sauvegarde serveur n'est pas confirmée
  /// (opération en file, ou refusées par le dernier push : [keepLocalIds])
  /// sont conservées : les écraser par la liste serveur les effacerait
  /// définitivement. Une suppression en file masque la bobine côté serveur.
  static Future<void> pullSpoolsFromBackend({Set<String> keepLocalIds = const {}}) async {
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
          headers: _headers(token),
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

          final serverSpools = spoolsJson.map((jsonItem) {
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
              location: _nonEmpty(json['location']),
              notes: _nonEmpty(json['notes']),
              nozzleSize: (json['nozzle_size'] as num?)?.toDouble(),
              vendorCode: _nonEmpty(json['vendor_code']),
              productCode: _nonEmpty(json['product_code']),
            );
          }).toList();

          // Backend antérieur à la migration 005 : il ne renvoie ni location,
          // ni notes, ni les champs NFC (buse, codes) → on garde les valeurs
          // locales au lieu de les effacer.
          final serverSendsFreeText = spoolsJson.isEmpty ||
              (spoolsJson.first as Map<String, dynamic>).containsKey('location');
          final withFreeText = serverSendsFreeText
              ? serverSpools
              : carryOverFreeText(
                  serverSpools,
                  await SpoolStorageService.loadSpools(),
                );

          final spools = await _mergeUnconfirmedLocal(withFreeText, keepLocalIds);

          debugPrint('Saving ${spools.length} spools to local storage...');
          await SpoolStorageService.saveSpools(spools);
          debugPrint('✅ ${spools.length} spools pulled from backend');
        } else {
          debugPrint('No spools in backend response');
        }
      } else {
        _reportSyncError('pull', response: response);
      }
    } catch (e, stack) {
      _reportSyncError('pull', error: e, stack: stack);
    }
  }

  /// Recopie les champs ajoutés par la migration 005 (emplacement, notes,
  /// buse, codes vendeur/produit) des bobines locales sur la liste serveur
  /// (même id) quand le serveur ne les gère pas encore. Pur.
  @visibleForTesting
  static List<SpoolInventoryItem> carryOverFreeText(
    List<SpoolInventoryItem> server,
    List<SpoolInventoryItem> local,
  ) {
    final byId = {for (final s in local) s.id: s};
    return [
      for (final s in server)
        if (byId[s.id] case final l?)
          s.copyWith(
            location: l.location,
            notes: l.notes,
            nozzleSize: l.nozzleSize,
            vendorCode: l.vendorCode,
            productCode: l.productCode,
          )
        else
          s,
    ];
  }

  /// Charge la file et le stock local, puis applique [mergeUnconfirmed].
  static Future<List<SpoolInventoryItem>> _mergeUnconfirmedLocal(
    List<SpoolInventoryItem> serverSpools,
    Set<String> keepLocalIds,
  ) async {
    final ops = await SyncQueueService.loadAll();
    if (ops.isEmpty && keepLocalIds.isEmpty) return serverSpools;
    final merged = mergeUnconfirmed(
      serverSpools: serverSpools,
      localSpools: await SpoolStorageService.loadSpools(),
      pendingOps: ops,
      keepLocalIds: keepLocalIds,
    );
    if (merged.length != serverSpools.length) {
      debugPrint('🛟 Pull : ${serverSpools.length} serveur → ${merged.length} après fusion'
          ' avec les bobines locales non confirmées');
    }
    return merged;
  }

  /// Fusionne la liste serveur avec les bobines locales non confirmées :
  /// - upsert en file ou refusée au push → version locale conservée ;
  /// - suppression en file → bobine retirée même si le serveur l'a encore.
  @visibleForTesting
  static List<SpoolInventoryItem> mergeUnconfirmed({
    required List<SpoolInventoryItem> serverSpools,
    required List<SpoolInventoryItem> localSpools,
    required List<Map<String, dynamic>> pendingOps,
    Set<String> keepLocalIds = const {},
  }) {
    final keepIds = {
      ...keepLocalIds,
      for (final op in pendingOps)
        if (op['type'] == 'upsert') op['spoolId'] as String,
    };
    final deletedIds = {
      for (final op in pendingOps)
        if (op['type'] == 'delete') op['spoolId'] as String,
    };
    if (keepIds.isEmpty && deletedIds.isEmpty) return serverSpools;

    final local = {for (final s in localSpools) s.id: s};
    final serverIds = serverSpools.map((s) => s.id).toSet();
    return [
      for (final s in serverSpools)
        if (!deletedIds.contains(s.id))
          keepIds.contains(s.id) && local[s.id] != null ? local[s.id]! : s,
      for (final id in keepIds)
        if (!serverIds.contains(id) && local[id] != null) local[id]!,
    ];
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
          headers: _headers(token),
          body: jsonEncode(payload),
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await SyncQueueService.remove(spool.id);
        debugPrint('✅ Spool ${spool.id} synced to backend');
      } else {
        await SyncQueueService.enqueueUpsert(spool.id, payload);
        _reportSyncError('put', response: response, spoolId: spool.id);
      }
    } catch (e, stack) {
      await SyncQueueService.enqueueUpsert(spool.id, payload);
      _reportSyncError('put', error: e, stack: stack, spoolId: spool.id);
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
          headers: _headers(token),
        ).timeout(ApiConfig.connectTimeout),
      );

      // 404 = déjà absent côté serveur → considéré comme réussi (idempotent).
      if ((response.statusCode >= 200 && response.statusCode < 300) ||
          response.statusCode == 404) {
        await SyncQueueService.remove(spoolId);
        debugPrint('✅ Spool $spoolId deleted from backend');
      } else {
        await SyncQueueService.enqueueDelete(spoolId);
        _reportSyncError('delete', response: response, spoolId: spoolId);
      }
    } catch (e, stack) {
      await SyncQueueService.enqueueDelete(spoolId);
      _reportSyncError('delete', error: e, stack: stack, spoolId: spoolId);
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
    final failedById = <String, Map<String, dynamic>>{};
    try {
      for (final op in ops) {
        final spoolId = op['spoolId'] as String;
        final type = op['type'] as String;
        var ok = false;
        String? lastError;
        try {
          final http.Response r;
          if (type == 'delete') {
            r = await _authService.authenticatedRequest((token) =>
              http.delete(
                Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteSpool(spoolId)}'),
                headers: _headers(token),
              ).timeout(ApiConfig.connectTimeout));
            ok = (r.statusCode >= 200 && r.statusCode < 300) ||
                r.statusCode == 404;
          } else {
            final payload = Map<String, dynamic>.from(op['payload'] as Map);
            r = await _authService.authenticatedRequest((token) =>
              http.put(
                Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateSpool(spoolId)}'),
                headers: _headers(token),
                body: jsonEncode(payload),
              ).timeout(ApiConfig.connectTimeout));
            ok = r.statusCode >= 200 && r.statusCode < 300;
          }
          if (!ok) lastError = 'HTTP ${r.statusCode}: ${_truncate(r.body, 150)}';
        } catch (e) {
          ok = false;
          lastError = '${e.runtimeType}: ${_truncate(e.toString(), 150)}';
          debugPrint('⚠️ Flush op $type $spoolId échec: $e');
        }

        if (!ok) {
          final attempts = (op['attempts'] as int? ?? 0) + 1;
          if (attempts < SyncQueueService.maxAttempts) {
            failedById[spoolId] = {...op, 'attempts': attempts, 'lastError': lastError};
          } else {
            // Abandon = la bobine ne sera jamais sauvegardée (ou jamais
            // supprimée) côté serveur → perte de données, à remonter.
            debugPrint('🗑️ Op $type $spoolId abandonnée après $attempts essais');
            unawaited(AnalyticsService.logEvent('sync_op_abandoned', eventData: {
              'op': type,
              'spool_id': spoolId,
              'attempts': attempts,
              'error': lastError,
            }));
            try {
              unawaited(FirebaseCrashlytics.instance.recordError(
                  'Sync op abandoned: $type ($lastError)', StackTrace.current,
                  reason: 'sync:abandoned'));
            } catch (_) {}
          }
        }
      }

      final next = reconcileQueue(
        flushed: ops,
        current: await SyncQueueService.loadAll(),
        failedById: failedById,
      );
      await SyncQueueService.replaceAll(next);
      debugPrint('✅ Flush terminé : ${next.length} restante(s)');
    } finally {
      _flushing = false;
    }
  }

  /// Nouvelle file après un flush. Tient compte des opérations ajoutées ou
  /// remplacées PENDANT le flush (ex : bobine ajoutée hors ligne au retour au
  /// premier plan) : avant, la file était réécrite depuis l'instantané du
  /// début et ces opérations étaient perdues → bobine jamais synchronisée.
  /// - op inchangée depuis le début du flush → résultat du flush (retirée si
  ///   réussie, [failedById] sinon) ;
  /// - op nouvelle ou remplacée pendant le flush → conservée telle quelle ;
  /// - op retirée pendant le flush (sync directe réussie) → reste retirée.
  @visibleForTesting
  static List<Map<String, dynamic>> reconcileQueue({
    required List<Map<String, dynamic>> flushed,
    required List<Map<String, dynamic>> current,
    required Map<String, Map<String, dynamic>> failedById,
  }) {
    final snapshot = {for (final op in flushed) op['spoolId'] as String: jsonEncode(op)};
    return [
      for (final op in current)
        if (snapshot[op['spoolId']] != jsonEncode(op))
          op
        else if (failedById[op['spoolId']] != null)
          failedById[op['spoolId']]!,
    ];
  }

  /// Synchronisation complète (bidirectionnelle)
  static Future<void> fullSync() async {
    debugPrint('🔄 Starting full sync...');

    // Rejouer d'abord les opérations en attente (échecs réseau précédents)
    await flushPendingQueue();

    // Push ALL local spools (from all keys) to ensure nothing is lost
    final push = await pushAllLocalSpoolsToBackend();

    // Le pull REMPLACE le stock local. Si le push a échoué, le serveur n'a
    // peut-être pas les ajouts locaux → les remplacer les effacerait.
    if (!push.ok) {
      debugPrint('⚠️ Push échoué → pull annulé pour ne pas écraser le stock local');
      // L'historique de consommation est additif (fusion par id) : sa synchro
      // reste sûre même quand celle du stock est interrompue.
      await UsageSyncService.sync();
      return;
    }

    // Then pull server changes (this will merge/replace local data)
    await pullSpoolsFromBackend(keepLocalIds: push.failedIds);
    await UsageSyncService.sync();

    debugPrint('✅ Full sync completed');
  }

  /// Push tous les spools locaux (de toutes les clés) vers le backend
  /// Utilisé lors de la reconnexion pour ne pas perdre de données.
  /// `ok` = le serveur a traité le lot ; `failedIds` = bobines qu'il a
  /// refusées (à conserver en local au pull).
  static Future<({bool ok, Set<String> failedIds})> pushAllLocalSpoolsToBackend() async {
    try {
      // Charger TOUS les spools de toutes les clés locales
      final spools = await SpoolStorageService.loadAllSpools();

      if (spools.isEmpty) {
        debugPrint('📭 No local spools to push');
        return (ok: true, failedIds: <String>{});
      }

      debugPrint('📤 Pushing ${spools.length} spools from all local keys...');

      final response = await _authService.authenticatedRequest((token) =>
        http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.syncPush}'),
          headers: _headers(token),
          body: jsonEncode({
            'spools': spools.map(_spoolPayload).toList(),
          }),
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode != 200) {
        _reportSyncError('push', response: response, spoolCount: spools.length);
        return (ok: false, failedIds: <String>{});
      }

      // Bobines refusées individuellement par le serveur (journalisées côté
      // serveur avec le même request id).
      final failedIds = <String>{};
      try {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>?;
        final ids = data?['failed_spool_ids'] as List<dynamic>?;
        if (ids != null) failedIds.addAll(ids.map((e) => e.toString()));
      } catch (_) {}

      if (failedIds.isNotEmpty) {
        _reportSyncError('push_partial',
            response: response,
            spoolCount: spools.length,
            extra: {
              'failed': failedIds.length,
              'failed_spool_ids': failedIds.take(20).toList(),
            });
      } else {
        debugPrint('✅ ${spools.length} spools pushed to backend (full sync)');
      }
      return (ok: true, failedIds: failedIds);
    } catch (e, stack) {
      _reportSyncError('push', error: e, stack: stack);
      return (ok: false, failedIds: <String>{});
    }
  }
}
