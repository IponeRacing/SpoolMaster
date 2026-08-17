import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpoolStorageService {
  static const String _keyPrefix = 'spools_inventory';

  // Notifier pour les changements de stock
  static final ValueNotifier<int> stockChangedNotifier = ValueNotifier<int>(0);

  /// Get storage key scoped by user_id
  static Future<String> _getStorageKey() async {
    final authService = AuthService();
    final userId = await authService.getCurrentUserId();
    if (userId == null) {
      // Fallback to non-scoped key for local mode
      return _keyPrefix;
    }
    return '${_keyPrefix}_$userId';
  }

  static Future<List<SpoolInventoryItem>> loadSpools() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getStorageKey();
    final data = prefs.getString(key);

    // Si pas de données avec la clé scopée, essayer la clé non-scopée (migration)
    if (data == null && key != _keyPrefix) {
      final legacyData = prefs.getString(_keyPrefix);
      if (legacyData != null) {
        debugPrint('Migrating spools from legacy key to user-scoped key');
        // Migrer les données vers la nouvelle clé
        await prefs.setString(key, legacyData);
        // Supprimer l'ancienne clé
        await prefs.remove(_keyPrefix);
        final jsonList = jsonDecode(legacyData) as List<dynamic>;
        return jsonList
            .map(
              (json) => SpoolInventoryItem.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }
    }

    if (data == null) return [];

    final jsonList = jsonDecode(data) as List<dynamic>;
    return jsonList
        .map(
          (json) => SpoolInventoryItem.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Charger les spools depuis toutes les clés possibles (pour la migration)
  static Future<List<SpoolInventoryItem>> loadAllSpools() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final spoolKeys = allKeys.where((k) => k.startsWith(_keyPrefix));

    final allSpools = <SpoolInventoryItem>[];
    final seenIds = <String>{};

    for (final key in spoolKeys) {
      final data = prefs.getString(key);
      if (data != null) {
        try {
          final jsonList = jsonDecode(data) as List<dynamic>;
          for (final json in jsonList) {
            final spool = SpoolInventoryItem.fromJson(json as Map<String, dynamic>);
            // Éviter les doublons par ID
            if (!seenIds.contains(spool.id)) {
              seenIds.add(spool.id);
              allSpools.add(spool);
            }
          }
        } catch (e) {
          debugPrint('Error parsing spools from key $key: $e');
        }
      }
    }

    return allSpools;
  }

  static Future<void> saveSpools(List<SpoolInventoryItem> spools) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getStorageKey();
    final data = jsonEncode(spools.map((s) => s.toJson()).toList());
    await prefs.setString(key, data);
    // Notifier les changements
    stockChangedNotifier.value++;
  }

  static Future<void> addSpool(SpoolInventoryItem spool) async {
    final spools = await loadSpools();
    spools.add(spool);
    await saveSpools(spools);
    // Sync to backend
    unawaited(SyncService.syncSpool(spool));
    // Log to analytics
    unawaited(AnalyticsService.logNfcScan(
      scanType: 'scan_add_spool',
      brand: spool.brand,
      material: spool.material,
      color: spool.colorName,
      success: true,
    ));
  }

  /// Regroupe les bobines identiques (marque + matériau + couleur RGB),
  /// en préservant l'ordre d'apparition. Chaque bobine reste distincte.
  /// Fonction pure (testable) utilisée par l'affichage de l'inventaire.
  static List<List<SpoolInventoryItem>> groupIdentical(
    List<SpoolInventoryItem> spools,
  ) {
    final groups = <String, List<SpoolInventoryItem>>{};
    final order = <String>[];
    for (final spool in spools) {
      final key = '${spool.brand.toLowerCase().trim()}|'
          '${spool.material.toLowerCase().trim()}|${spool.colorRgb}';
      if (!groups.containsKey(key)) {
        groups[key] = [];
        order.add(key);
      }
      groups[key]!.add(spool);
    }
    return [for (final k in order) groups[k]!];
  }

  /// Ajoute plusieurs bobines identiques d'un coup (champ quantité).
  /// Chaque bobine reste une entrée distincte avec son propre poids restant.
  static Future<void> addSpools(List<SpoolInventoryItem> newSpools) async {
    if (newSpools.isEmpty) return;
    final spools = await loadSpools();
    spools.addAll(newSpools);
    await saveSpools(spools);
    for (final spool in newSpools) {
      unawaited(SyncService.syncSpool(spool));
    }
    unawaited(AnalyticsService.logNfcScan(
      scanType: 'scan_add_spool',
      brand: newSpools.first.brand,
      material: newSpools.first.material,
      color: newSpools.first.colorName,
      success: true,
    ));
  }

  static Future<void> updateSpool(String id, SpoolInventoryItem spool) async {
    final spools = await loadSpools();
    final index = spools.indexWhere((s) => s.id == id);
    if (index != -1) {
      spools[index] = spool;
      await saveSpools(spools);
      // Sync to backend
      unawaited(SyncService.syncSpool(spool));
    }
  }

  static Future<void> deleteSpool(String id) async {
    final spools = await loadSpools();
    spools.removeWhere((s) => s.id == id);
    await saveSpools(spools);
    // Sync deletion to backend
    unawaited(SyncService.deleteSpool(id));
  }
}
