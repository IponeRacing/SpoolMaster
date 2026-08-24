import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingListService {
  static const String _keyShoppingList = 'shopping_list';
  static const String _keyOrderedIds = 'ordered_spool_ids';

  /// Get storage key scoped by user_id (same pattern as SpoolStorageService)
  static Future<String> _getShoppingListKey() async {
    final authService = AuthService();
    final userId = await authService.getCurrentUserId();
    if (userId == null) {
      // Fallback to non-scoped key for local mode (no account)
      return _keyShoppingList;
    }
    return '${_keyShoppingList}_$userId';
  }

  static Future<String> _getOrderedIdsKey() async {
    final authService = AuthService();
    final userId = await authService.getCurrentUserId();
    if (userId == null) {
      return _keyOrderedIds;
    }
    return '${_keyOrderedIds}_$userId';
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
        final jsonList = json.decode(legacyData) as List<dynamic>;
        return jsonList.map((j) => SpoolInventoryItem.fromJson(j as Map<String, dynamic>)).toList();
      }
    }

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList.map((j) => SpoolInventoryItem.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// Charger toutes les shopping lists (pour sync/migration)
  static Future<List<SpoolInventoryItem>> loadAllShoppingLists() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final shoppingKeys = allKeys.where((k) => k.startsWith(_keyShoppingList));

    final allItems = <SpoolInventoryItem>[];
    final seenIds = <String>{};

    for (final key in shoppingKeys) {
      final data = prefs.getString(key);
      if (data != null && data.isNotEmpty) {
        try {
          final jsonList = json.decode(data) as List<dynamic>;
          for (final j in jsonList) {
            final item = SpoolInventoryItem.fromJson(j as Map<String, dynamic>);
            if (!seenIds.contains(item.id)) {
              seenIds.add(item.id);
              allItems.add(item);
            }
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
    }
  }

  /// Supprimer un item de la liste de courses
  static Future<void> removeFromShoppingList(String itemId) async {
    final items = await loadShoppingList();
    items.removeWhere((item) => item.id == itemId);
    await saveShoppingList(items);
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

  /// Effacer toute la liste de courses
  static Future<void> clearShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final shoppingKey = await _getShoppingListKey();
    final orderedKey = await _getOrderedIdsKey();
    await prefs.remove(shoppingKey);
    await prefs.remove(orderedKey);
  }

  // ============================================
  // Sync avec le backend
  // ============================================

  static final AuthService _authService = AuthService();

  /// Push la shopping list vers le backend
  static Future<void> pushToBackend() async {
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) return;

      final items = await loadAllShoppingLists();
      final orderedIds = await loadOrderedIds();

      if (items.isEmpty) {
        debugPrint('📭 No shopping list items to push');
        return;
      }

      debugPrint('📤 Pushing ${items.length} shopping list items...');

      final response = await _authService.authenticatedRequest((token) =>
        http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.shoppingListPush}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'items': items.map((item) => item.toJson()).toList(),
            'ordered_ids': orderedIds.toList(),
          }),
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Shopping list pushed to backend');
      } else {
        debugPrint('⚠️ Failed to push shopping list: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Could not push shopping list: $e');
    }
  }

  /// Pull la shopping list depuis le backend
  static Future<void> pullFromBackend() async {
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
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final data = responseData['data'] as Map<String, dynamic>?;

        if (data != null && data['items'] != null) {
          final itemsJson = data['items'] as List<dynamic>;
          final items = itemsJson.map((j) {
            final map = j as Map<String, dynamic>;
            // Convertir le format backend vers SpoolInventoryItem
            return SpoolInventoryItem(
              id: (map['id'] ?? map['item_id']) as String,
              brand: (map['brand'] ?? '') as String,
              material: (map['material'] ?? '') as String,
              colorName: (map['color_name'] ?? map['colorName'] ?? '') as String,
              colorRgb: (map['color_rgb'] ?? map['colorRgb'] ?? 0) as int,
              price: map['price'] != null ? (map['price'] as num).toDouble() : 0.0,
              weight: map['weight'] != null ? (map['weight'] as num).toDouble() : 0.0,
              remainingWeight: map['remaining_weight'] != null ? (map['remaining_weight'] as num).toDouble() : 0.0,
              addedDate: map['added_date'] != null ? DateTime.parse(map['added_date'] as String) : (map['created_at'] != null ? DateTime.parse(map['created_at'] as String) : DateTime.now()),
              extruderTempMin: (map['extruder_temp_min'] ?? map['extruderTempMin']) as int?,
              extruderTempMax: (map['extruder_temp_max'] ?? map['extruderTempMax']) as int?,
              bedTempMin: (map['bed_temp_min'] ?? map['bedTempMin']) as int?,
              bedTempMax: (map['bed_temp_max'] ?? map['bedTempMax']) as int?,
              diameter: map['diameter'] != null ? (map['diameter'] as num).toDouble() : null,
              spoolLength: (map['spool_length'] ?? map['spoolLength']) as int?,
              manufactureDate: (map['manufacture_date'] ?? map['manufactureDate']) != null ? DateTime.parse((map['manufacture_date'] ?? map['manufactureDate']) as String) : null,
              batchNumber: (map['batch_number'] ?? map['batchNumber']) as String?,
              detailedType: (map['detailed_type'] ?? map['detailedType']) as String?,
              dryingTemp: (map['drying_temp'] ?? map['dryingTemp']) as int?,
              dryingTime: (map['drying_time'] ?? map['dryingTime']) as int?,
              materialVariantId: (map['material_variant_id'] ?? map['materialVariantId']) as String?,
              materialId: (map['material_id'] ?? map['materialId']) as String?,
            );
          }).toList();

          await saveShoppingList(items);

          // Sync ordered IDs
          if (data['ordered_ids'] != null) {
            final orderedIds = (data['ordered_ids'] as List<dynamic>).map((e) => e as String).toSet();
            final prefs = await SharedPreferences.getInstance();
            final key = await _getOrderedIdsKey();
            await prefs.setStringList(key, orderedIds.toList());
          }

          debugPrint('✅ ${items.length} shopping list items pulled from backend');
        }
      } else {
        debugPrint('⚠️ Failed to pull shopping list: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ Could not pull shopping list: $e');
    }
  }

  /// Full sync (push puis pull)
  static Future<void> fullSync() async {
    debugPrint('🔄 Starting shopping list full sync...');
    await pushToBackend();
    await pullFromBackend();
    debugPrint('✅ Shopping list full sync completed');
  }
}
