import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Résultat d'un push de la liste de courses.
/// - `ok` : le serveur a traité le lot (sinon le pull est sauté) ;
/// - `failedIds` : articles refusés individuellement (gardés en local) ;
/// - `pushedIds` : articles envoyés (les autres, ajoutés pendant le push,
///   sont « en attente » et gardés en local au pull).
typedef ShoppingPushResult = ({
  bool ok,
  Set<String> failedIds,
  Set<String> pushedIds,
});

class ShoppingListService {
  static const String _keyShoppingList = 'shopping_list';
  static const String _keyOrderedIds = 'ordered_spool_ids';

  /// Suppressions pas encore confirmées par le serveur (DELETE échoué ou
  /// hors ligne), envoyées au push suivant dans `deleted_ids`.
  static const String _keyDeletedIds = 'shopping_deleted_ids';

  static final AuthService _authService = AuthService();

  /// Sérialise les lectures-écritures de la liste des suppressions en
  /// attente (sinon un ajout concurrent pouvait être perdu).
  static Future<void> _pendingLock = Future<void>.value();

  /// Clé scopée par user_id (même schéma que SpoolStorageService) ; la clé
  /// sans suffixe est celle du mode invité.
  static Future<String> _scopedKey(String prefix) async {
    final userId = await _authService.getCurrentUserId();
    return userId == null ? prefix : '${prefix}_$userId';
  }

  static Future<String> _getShoppingListKey() => _scopedKey(_keyShoppingList);

  static Future<String> _getOrderedIdsKey() => _scopedKey(_keyOrderedIds);

  static Future<String> _getDeletedIdsKey() => _scopedKey(_keyDeletedIds);

  static List<SpoolInventoryItem> _decodeList(String data) {
    final jsonList = json.decode(data) as List<dynamic>;
    return jsonList
        .map((j) => SpoolInventoryItem.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// Charger la liste de courses
  static Future<List<SpoolInventoryItem>> loadShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getShoppingListKey();
    final jsonString = prefs.getString(key);

    // Migration: si pas de données avec la clé scopée, essayer la clé legacy
    if ((jsonString == null || jsonString.isEmpty) && key != _keyShoppingList) {
      final legacyData = prefs.getString(_keyShoppingList);
      if (legacyData != null && legacyData.isNotEmpty) {
        debugPrint('📦 Migrating shopping list from legacy key to user-scoped key');
        await prefs.setString(key, legacyData);
        await prefs.remove(_keyShoppingList);
        return _decodeList(legacyData);
      }
    }

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    return _decodeList(jsonString);
  }

  /// Articles à pousser vers le compte connecté : ceux du compte courant +
  /// ceux ajoutés en invité (clé non scopée). Les clés des AUTRES comptes
  /// connectés un jour sur cet appareil sont exclues (avant, leurs articles
  /// étaient rattachés au compte courant). Le compte courant est lu en
  /// premier → sa version gagne en cas de doublon d'id.
  static Future<List<SpoolInventoryItem>> loadAllShoppingLists() async {
    final prefs = await SharedPreferences.getInstance();
    final shoppingKeys = {await _getShoppingListKey(), _keyShoppingList};

    final allItems = <SpoolInventoryItem>[];
    final seenIds = <String>{};

    for (final key in shoppingKeys) {
      final data = prefs.getString(key);
      if (data != null && data.isNotEmpty) {
        try {
          for (final item in _decodeList(data)) {
            if (seenIds.add(item.id)) allItems.add(item);
          }
        } catch (e) {
          debugPrint('⚠️ Error parsing shopping list from key $key: $e');
        }
      }
    }

    return allItems;
  }

  /// Sauvegarder la liste de courses
  static Future<void> saveShoppingList(List<SpoolInventoryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getShoppingListKey();
    final jsonString = json.encode(items.map((item) => item.toJson()).toList());
    await prefs.setString(key, jsonString);
  }

  /// Ajouter un item à la liste de courses
  static Future<void> addToShoppingList(SpoolInventoryItem item) async {
    final items = await loadShoppingList();

    // Vérifier si l'item existe déjà (par brand + material + color)
    final exists = items.any((existing) =>
        existing.brand == item.brand &&
        existing.material == item.material &&
        existing.colorName == item.colorName);

    if (!exists) {
      items.add(item);
      await saveShoppingList(items);
      // Ré-ajout d'un article supprimé hors ligne : la suppression en
      // attente n'a plus lieu d'être.
      await _removePendingDeletions({item.id});
    }
  }

  /// Supprimer un item de la liste de courses (local + serveur si connecté)
  static Future<void> removeFromShoppingList(String itemId) async {
    final items = await loadShoppingList();
    items.removeWhere((item) => item.id == itemId);
    await saveShoppingList(items);
    await _deleteEverywhere({itemId});
  }

  /// Charger les IDs des items commandés
  static Future<Set<String>> loadOrderedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getOrderedIdsKey();
    final orderedIds = prefs.getStringList(key) ?? [];
    return orderedIds.toSet();
  }

  /// Marquer un item comme commandé/non commandé
  static Future<void> toggleOrdered(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getOrderedIdsKey();
    final orderedIds = await loadOrderedIds();

    if (orderedIds.contains(itemId)) {
      orderedIds.remove(itemId);
    } else {
      orderedIds.add(itemId);
    }

    await prefs.setStringList(key, orderedIds.toList());
  }

  /// Vérifier si un item est commandé
  static Future<bool> isOrdered(String itemId) async {
    final orderedIds = await loadOrderedIds();
    return orderedIds.contains(itemId);
  }

  /// Effacer toute la liste de courses (local + serveur si connecté). Les
  /// articles invité pas encore fusionnés au compte sont vidés aussi, sinon
  /// ils réapparaîtraient à la synchro suivante.
  static Future<void> clearShoppingList() async {
    final ids = (await loadAllShoppingLists()).map((i) => i.id).toSet();
    final prefs = await SharedPreferences.getInstance();
    final shoppingKey = await _getShoppingListKey();
    final orderedKey = await _getOrderedIdsKey();
    if (shoppingKey == _keyShoppingList) {
      await prefs.remove(shoppingKey);
    } else {
      // Liste vide plutôt que clé absente : sinon loadShoppingList
      // ré-importerait la liste invité (migration).
      await saveShoppingList(const []);
    }
    await prefs.remove(orderedKey);
    await _deleteEverywhere(ids);
  }

  // ============================================
  // Suppressions côté serveur
  // ============================================

  /// Propage des suppressions locales. Connecté : retire aussi ces articles
  /// de la clé invité (sinon ils seraient repoussés au prochain push),
  /// mémorise les ids comme « suppression en attente » PUIS envoie les
  /// DELETE en arrière-plan ; un id n'est oublié qu'une fois la suppression
  /// confirmée (DELETE ou push suivant). Invité : rien à envoyer.
  static Future<void> _deleteEverywhere(Set<String> ids) async {
    if (ids.isEmpty) return;
    if (!await UserPreferencesService.isSignedIn()) return;

    await _removeFromGuestKey(ids);
    await _addPendingDeletions(ids);
    unawaited(_sendDeletions(ids));
  }

  static Future<void> _removeFromGuestKey(Set<String> ids) async {
    if (await _getShoppingListKey() == _keyShoppingList) return;
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyShoppingList);
    if (data == null || data.isEmpty) return;
    try {
      final items = _decodeList(data);
      final kept = items.where((i) => !ids.contains(i.id)).toList();
      if (kept.length != items.length) {
        await prefs.setString(
          _keyShoppingList,
          json.encode(kept.map((i) => i.toJson()).toList()),
        );
      }
    } catch (e) {
      debugPrint('⚠️ Shopping list invité illisible: $e');
    }
  }

  /// DELETE /shopping-list/:id pour chaque id. 2xx ou 404 (déjà absent) =
  /// confirmé. Coupure réseau → on s'arrête, le reste partira au push.
  static Future<void> _sendDeletions(Set<String> ids) async {
    final confirmed = <String>{};
    for (final id in ids) {
      try {
        final response = await _authService.authenticatedRequest((token) =>
          http.delete(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteShoppingListItem(id)}'),
            headers: {
              ...ApiConfig.commonHeaders,
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ).timeout(ApiConfig.connectTimeout),
        );
        final status = response.statusCode;
        if ((status >= 200 && status < 300) || status == 404) {
          confirmed.add(id);
        } else {
          debugPrint('⚠️ Shopping DELETE $id: HTTP $status (réessai au push)');
        }
      } catch (e) {
        debugPrint('⚠️ Shopping DELETE $id impossible (réessai au push): $e');
        break;
      }
    }
    await _removePendingDeletions(confirmed);
  }

  static Future<T> _withPendingLock<T>(Future<T> Function() action) {
    final result = _pendingLock.then((_) => action());
    _pendingLock = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  /// Suppressions en attente de confirmation serveur (compte courant).
  static Future<Set<String>> loadPendingDeletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(await _getDeletedIdsKey()) ?? []).toSet();
  }

  static Future<void> _addPendingDeletions(Set<String> ids) =>
      _withPendingLock(() async {
        final prefs = await SharedPreferences.getInstance();
        final key = await _getDeletedIdsKey();
        final pending = (prefs.getStringList(key) ?? []).toSet()..addAll(ids);
        await prefs.setStringList(key, pending.toList());
      });

  static Future<void> _removePendingDeletions(Set<String> ids) {
    if (ids.isEmpty) return Future<void>.value();
    return _withPendingLock(() async {
      final prefs = await SharedPreferences.getInstance();
      final key = await _getDeletedIdsKey();
      final pending = prefs.getStringList(key);
      if (pending == null || pending.isEmpty) return;
      final next = pending.where((id) => !ids.contains(id)).toList();
      if (next.length == pending.length) return;
      if (next.isEmpty) {
        await prefs.remove(key);
      } else {
        await prefs.setStringList(key, next);
      }
    });
  }

  // ============================================
  // Sync avec le backend
  // ============================================

  /// Push la shopping list (compte courant + invité) et les suppressions en
  /// attente vers le backend.
  static Future<ShoppingPushResult> pushToBackend() async {
    const failed = (ok: false, failedIds: <String>{}, pushedIds: <String>{});
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) return failed;

      final deletedIds = await loadPendingDeletedIds();
      final items = (await loadAllShoppingLists())
          .where((i) => !deletedIds.contains(i.id))
          .toList();
      final orderedIds = await loadOrderedIds();

      if (items.isEmpty && deletedIds.isEmpty) {
        debugPrint('📭 No shopping list items to push');
        return (ok: true, failedIds: <String>{}, pushedIds: <String>{});
      }

      debugPrint('📤 Pushing ${items.length} shopping list items '
          '(+${deletedIds.length} deletions)...');

      final response = await _authService.authenticatedRequest((token) =>
        http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.shoppingListPush}'),
          headers: {
            ...ApiConfig.commonHeaders,
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'items': items.map((item) => item.toJson()).toList(),
            'ordered_ids': orderedIds.toList(),
            'deleted_ids': deletedIds.toList(),
          }),
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode != 200) {
        debugPrint('⚠️ Failed to push shopping list: ${response.statusCode}');
        return failed;
      }

      // Suppressions traitées par le serveur → plus en attente
      await _removePendingDeletions(deletedIds);

      final failedIds = <String>{};
      try {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>?;
        final ids = data?['failed_item_ids'] as List<dynamic>?;
        if (ids != null) failedIds.addAll(ids.map((e) => e.toString()));
      } catch (_) {}

      if (failedIds.isNotEmpty) {
        debugPrint('⚠️ ${failedIds.length} shopping list items refused by backend');
      } else {
        debugPrint('✅ Shopping list pushed to backend');
      }
      return (
        ok: true,
        failedIds: failedIds,
        pushedIds: items.map((i) => i.id).toSet(),
      );
    } catch (e) {
      debugPrint('⚠️ Could not push shopping list: $e');
      return failed;
    }
  }

  /// Pull la shopping list depuis le backend et la FUSIONNE avec la liste
  /// locale (voir [mergePulled]) au lieu de la remplacer.
  /// [keepLocalIds] : articles refusés au dernier push ; [confirmedIds] :
  /// articles acceptés au dernier push (null = pas de push préalable, la
  /// liste serveur fait foi hors [keepLocalIds]).
  static Future<void> pullFromBackend({
    Set<String> keepLocalIds = const {},
    Set<String>? confirmedIds,
  }) async {
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) {
        debugPrint('⚠️ Not signed in, skipping shopping list pull');
        return;
      }

      debugPrint('📥 Pulling shopping list from backend...');
      final response = await _authService.authenticatedRequest((token) =>
        http.get(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.shoppingListPull}'),
          headers: {
            ...ApiConfig.commonHeaders,
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode != 200) {
        debugPrint('⚠️ Failed to pull shopping list: ${response.statusCode}');
        return;
      }

      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>?;
      if (data == null || data['items'] == null) return;

      final serverItems = (data['items'] as List<dynamic>)
          .map((j) => Map<String, dynamic>.from(j as Map))
          .toList();
      final local = await loadShoppingList();
      final merged = mergePulled(
        serverItems: serverItems,
        localItems: local,
        keepLocalIds: keepLocalIds,
        confirmedIds: confirmedIds,
        pendingDeletedIds: await loadPendingDeletedIds(),
      );
      await saveShoppingList(merged);

      // Commandés : ceux du serveur + ceux des articles gardés en local
      // (pas encore connus du serveur).
      if (data['ordered_ids'] != null) {
        final serverIds = serverItems.map(_serverId).whereType<String>().toSet();
        final localOrdered = await loadOrderedIds();
        final orderedIds = {
          ...(data['ordered_ids'] as List<dynamic>).map((e) => e.toString()),
          ...localOrdered.where(
            (id) => !serverIds.contains(id) && merged.any((i) => i.id == id),
          ),
        };
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(await _getOrderedIdsKey(), orderedIds.toList());
      }

      debugPrint('✅ ${merged.length} shopping list items after pull '
          '(${serverItems.length} from backend)');
    } catch (e) {
      debugPrint('⚠️ Could not pull shopping list: $e');
    }
  }

  /// Full sync (push puis pull). Le pull est sauté si le push a échoué : le
  /// serveur n'a peut-être pas les ajouts locaux.
  static Future<void> fullSync() async {
    if (!await UserPreferencesService.isSignedIn()) return;
    debugPrint('🔄 Starting shopping list full sync...');
    final push = await pushToBackend();
    if (!push.ok) {
      debugPrint('⚠️ Shopping list push échoué → pull annulé');
      return;
    }
    await pullFromBackend(
      keepLocalIds: push.failedIds,
      confirmedIds: push.pushedIds.difference(push.failedIds),
    );
    debugPrint('✅ Shopping list full sync completed');
  }

  // ============================================
  // Fusion du pull (pure, testable)
  // ============================================

  static String? _serverId(Map<String, dynamic> map) =>
      (map['id'] ?? map['item_id'])?.toString();

  /// Fusionne la liste serveur avec la liste locale :
  /// - suppression locale en attente → article absent, même si le serveur
  ///   l'a encore ;
  /// - article refusé au push ([keepLocalIds]) → version locale ;
  /// - article local absent du serveur : gardé s'il a été refusé ou s'il
  ///   n'a pas été poussé (ajouté pendant la synchro : absent de
  ///   [confirmedIds]) ; sinon le serveur l'a supprimé → retiré ;
  /// - champ non renvoyé par le serveur (absent ou null) → valeur locale du
  ///   même id (detailedType, lot, date de fabrication, séchage, materialId,
  ///   poids restant… n'étaient pas stockés côté serveur et étaient perdus).
  @visibleForTesting
  static List<SpoolInventoryItem> mergePulled({
    required List<Map<String, dynamic>> serverItems,
    required List<SpoolInventoryItem> localItems,
    Set<String> keepLocalIds = const {},
    Set<String>? confirmedIds,
    Set<String> pendingDeletedIds = const {},
  }) {
    final localById = {for (final i in localItems) i.id: i};
    final result = <SpoolInventoryItem>[];
    final seen = <String>{};

    for (final map in serverItems) {
      final id = _serverId(map);
      if (id == null || pendingDeletedIds.contains(id) || !seen.add(id)) {
        continue;
      }
      final local = localById[id];
      if (local != null && keepLocalIds.contains(id)) {
        result.add(local);
      } else {
        result.add(itemFromServer(map, local: local));
      }
    }

    for (final item in localItems) {
      if (seen.contains(item.id) || pendingDeletedIds.contains(item.id)) {
        continue;
      }
      final pending = confirmedIds != null && !confirmedIds.contains(item.id);
      if (keepLocalIds.contains(item.id) || pending) {
        seen.add(item.id);
        result.add(item);
      }
    }
    return result;
  }

  /// Convertit un article serveur ; tout champ absent ou null reprend la
  /// valeur de [local] (même id). Pur.
  @visibleForTesting
  static SpoolInventoryItem itemFromServer(
    Map<String, dynamic> map, {
    SpoolInventoryItem? local,
  }) {
    Object? field(String snake, [String? camel]) =>
        map[snake] ?? (camel != null ? map[camel] : null);

    return SpoolInventoryItem(
      id: _serverId(map)!,
      brand: _str(field('brand')) ?? local?.brand ?? '',
      material: _str(field('material')) ?? local?.material ?? '',
      colorName: _str(field('color_name', 'colorName')) ?? local?.colorName ?? '',
      colorRgb: _int(field('color_rgb', 'colorRgb')) ?? local?.colorRgb ?? 0,
      price: _double(field('price')) ?? local?.price ?? 0.0,
      weight: _double(field('weight', 'initial_weight')) ?? local?.weight ?? 0.0,
      // Le serveur ne stocke pas le poids restant (il renvoie le poids total,
      // gardé pour les anciennes versions) : la valeur locale prime.
      remainingWeight: local?.remainingWeight ??
          _double(field('remaining_weight', 'remainingWeight')) ??
          0.0,
      // Le serveur ne conserve pas la date d'ajout locale (il renvoie sa
      // date de création) : la valeur locale prime.
      addedDate: local?.addedDate ??
          _date(field('added_date', 'addedDate')) ??
          _date(field('created_at')) ??
          DateTime.now(),
      extruderTempMin: _int(field('extruder_temp_min', 'extruderTempMin')) ??
          local?.extruderTempMin,
      extruderTempMax: _int(field('extruder_temp_max', 'extruderTempMax')) ??
          local?.extruderTempMax,
      bedTempMin: _int(field('bed_temp_min', 'bedTempMin')) ?? local?.bedTempMin,
      bedTempMax: _int(field('bed_temp_max', 'bedTempMax')) ?? local?.bedTempMax,
      diameter: _double(field('diameter')) ?? local?.diameter,
      spoolLength: _int(field('spool_length', 'spoolLength')) ?? local?.spoolLength,
      manufactureDate: _date(field('manufacture_date', 'manufactureDate')) ??
          local?.manufactureDate,
      batchNumber: _str(field('batch_number', 'batchNumber')) ?? local?.batchNumber,
      detailedType:
          _str(field('detailed_type', 'detailedType')) ?? local?.detailedType,
      dryingTemp: _int(field('drying_temp', 'dryingTemp')) ?? local?.dryingTemp,
      dryingTime: _int(field('drying_time', 'dryingTime')) ?? local?.dryingTime,
      materialVariantId: _str(field('material_variant_id', 'materialVariantId')) ??
          local?.materialVariantId,
      materialId: _str(field('material_id', 'materialId')) ?? local?.materialId,
      nozzleSize: _double(field('nozzle_size', 'nozzleSize')) ?? local?.nozzleSize,
      vendorCode: _str(field('vendor_code', 'vendorCode')) ?? local?.vendorCode,
      productCode: _str(field('product_code', 'productCode')) ?? local?.productCode,
      location: _str(field('location')) ?? local?.location,
      notes: _str(field('notes')) ?? local?.notes,
    );
  }

  static String? _str(Object? v) {
    final s = v?.toString().trim();
    return (s == null || s.isEmpty) ? null : s;
  }

  static int? _int(Object? v) => switch (v) {
        final int i => i,
        final num n => n.round(),
        final String s => int.tryParse(s.trim()) ?? double.tryParse(s.trim())?.round(),
        _ => null,
      };

  static double? _double(Object? v) => switch (v) {
        final num n => n.toDouble(),
        final String s => double.tryParse(s.trim()),
        _ => null,
      };

  static DateTime? _date(Object? v) =>
      v is String ? DateTime.tryParse(v.trim()) : null;
}
