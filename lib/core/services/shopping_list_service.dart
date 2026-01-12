import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_filament/main.dart';

class ShoppingListService {
  static const String _keyShoppingList = 'shopping_list';
  static const String _keyOrderedIds = 'ordered_spool_ids';

  /// Charger la liste de courses
  static Future<List<SpoolInventoryItem>> loadShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyShoppingList);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList.map((json) => SpoolInventoryItem.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Sauvegarder la liste de courses
  static Future<void> saveShoppingList(List<SpoolInventoryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(items.map((item) => item.toJson()).toList());
    await prefs.setString(_keyShoppingList, jsonString);
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
    final orderedIds = prefs.getStringList(_keyOrderedIds) ?? [];
    return orderedIds.toSet();
  }

  /// Marquer un item comme commandé/non commandé
  static Future<void> toggleOrdered(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final orderedIds = await loadOrderedIds();

    if (orderedIds.contains(itemId)) {
      orderedIds.remove(itemId);
    } else {
      orderedIds.add(itemId);
    }

    await prefs.setStringList(_keyOrderedIds, orderedIds.toList());
  }

  /// Vérifier si un item est commandé
  static Future<bool> isOrdered(String itemId) async {
    final orderedIds = await loadOrderedIds();
    return orderedIds.contains(itemId);
  }

  /// Effacer toute la liste de courses
  static Future<void> clearShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyShoppingList);
    await prefs.remove(_keyOrderedIds);
  }
}
