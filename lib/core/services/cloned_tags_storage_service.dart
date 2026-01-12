import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/cloned_tag_model.dart';

/// Service pour gérer la bibliothèque de tags clonés
/// Architecture hybride : Cache local (SharedPreferences) + Cloud backup
class ClonedTagsStorageService {
  static const String _keyClonedTags = 'cloned_tags';
  static const String _keyLastSync = 'cloned_tags_last_sync';
  static const int _maxLocalClones = 50; // Limite LRU (Least Recently Used)
  static final AuthService _authService = AuthService();

  /// Sauvegarder un nouveau tag cloné
  /// 1. Sauvegarder localement (avec LRU eviction)
  /// 2. Sync vers le cloud (async)
  static Future<void> saveClonedTag(ClonedTagModel clone) async {
    final prefs = await SharedPreferences.getInstance();
    final clones = await getClonedTags();

    // Ajouter le nouveau clone au début (plus récent)
    clones.insert(0, clone);

    // Appliquer la limite LRU : supprimer les plus anciens
    if (clones.length > _maxLocalClones) {
      final removed = clones.length - _maxLocalClones;
      clones.removeRange(_maxLocalClones, clones.length);
      debugPrint('📦 Cache LRU: $removed anciens clones supprimés localement (garde les $_maxLocalClones plus récents)');
    }

    // Sauvegarder localement
    final jsonList = clones.map((c) => c.toJsonString()).toList();
    await prefs.setStringList(_keyClonedTags, jsonList);

    // Sync vers le cloud (async, ne bloque pas l'UI)
    _syncCloneToCloud(clone);
  }

  /// Récupérer tous les tags clonés (local + cloud)
  static Future<List<ClonedTagModel>> getClonedTags() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_keyClonedTags) ?? [];

    return jsonList
        .map((jsonStr) => ClonedTagModel.fromJsonString(jsonStr))
        .toList();
  }

  /// Supprimer un tag cloné (local + cloud)
  static Future<void> deleteClonedTag(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final clones = await getClonedTags();

    // Retirer le clone avec cet ID
    clones.removeWhere((c) => c.id == id);

    // Sauvegarder localement
    final jsonList = clones.map((c) => c.toJsonString()).toList();
    await prefs.setStringList(_keyClonedTags, jsonList);

    // Supprimer du cloud
    _deleteCloneFromCloud(id);
  }

  /// Mettre à jour le nom personnalisé d'un clone
  static Future<void> updateCloneName(String id, String customName) async {
    final prefs = await SharedPreferences.getInstance();
    final clones = await getClonedTags();

    // Trouver et mettre à jour
    final index = clones.indexWhere((c) => c.id == id);
    if (index != -1) {
      final updatedClone = ClonedTagModel(
        id: clones[index].id,
        clonedAt: clones[index].clonedAt,
        bobbinData: clones[index].bobbinData,
        rawBlocks: clones[index].rawBlocks,
        customName: customName,
      );
      clones[index] = updatedClone;

      // Sauvegarder localement
      final jsonList = clones.map((c) => c.toJsonString()).toList();
      await prefs.setStringList(_keyClonedTags, jsonList);

      // Sync vers le cloud
      _syncCloneToCloud(updatedClone);
    }
  }

  /// Obtenir un clone par ID
  static Future<ClonedTagModel?> getClonedTagById(String id) async {
    final clones = await getClonedTags();
    try {
      return clones.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Supprimer tous les clones locaux
  static Future<void> clearAllClones() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyClonedTags);
  }

  /// Vérifier si un clone similaire existe déjà
  static Future<bool> cloneExists({
    required String material,
    required String color,
  }) async {
    final clones = await getClonedTags();
    return clones.any((c) =>
        c.bobbinData.filamentType == material &&
        c.bobbinData.color == color);
  }

  // ==================== CLOUD SYNC ====================

  /// Synchroniser un clone vers le cloud (async)
  static Future<void> _syncCloneToCloud(ClonedTagModel clone) async {
    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        debugPrint('⚠️ Pas de token, clone non synchronisé au cloud');
        return;
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/cloned-tags'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(clone.toJson()),
      ).timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('☁️ Clone synchronisé au cloud: ${clone.displayName}');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyLastSync, DateTime.now().toIso8601String());
      } else {
        debugPrint('⚠️ Échec sync cloud (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('❌ Erreur sync cloud: $e');
      // Ne pas bloquer si le cloud est indisponible
    }
  }

  /// Supprimer un clone du cloud
  static Future<void> _deleteCloneFromCloud(String id) async {
    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) return;

      await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/api/cloned-tags/$id'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(ApiConfig.connectTimeout);

      debugPrint('☁️ Clone supprimé du cloud: $id');
    } catch (e) {
      debugPrint('❌ Erreur suppression cloud: $e');
    }
  }

  /// Récupérer tous les clones depuis le cloud
  static Future<List<ClonedTagModel>> fetchClonesFromCloud() async {
    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        debugPrint('⚠️ Pas de token, impossible de récupérer les clones cloud');
        return [];
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/cloned-tags'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List;
        final cloudClones = data
            .map((json) => ClonedTagModel.fromJson(json as Map<String, dynamic>))
            .toList();

        debugPrint('☁️ ${cloudClones.length} clones récupérés du cloud');
        return cloudClones;
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération cloud: $e');
    }
    return [];
  }

  /// Synchroniser : fusionner cloud + local
  static Future<void> syncWithCloud() async {
    try {
      final cloudClones = await fetchClonesFromCloud();
      final localClones = await getClonedTags();

      // Fusionner : utiliser un Set pour éviter les doublons (par ID)
      final Map<String, ClonedTagModel> mergedMap = {};

      // Ajouter les clones locaux
      for (final clone in localClones) {
        mergedMap[clone.id] = clone;
      }

      // Fusionner avec les clones cloud (prioriser le plus récent)
      for (final clone in cloudClones) {
        if (!mergedMap.containsKey(clone.id) ||
            clone.clonedAt.isAfter(mergedMap[clone.id]!.clonedAt)) {
          mergedMap[clone.id] = clone;
        }
      }

      // Trier par date (plus récent en premier)
      final merged = mergedMap.values.toList()
        ..sort((a, b) => b.clonedAt.compareTo(a.clonedAt));

      // Sauvegarder localement (avec limite LRU)
      final toSave = merged.take(_maxLocalClones).toList();
      final prefs = await SharedPreferences.getInstance();
      final jsonList = toSave.map((c) => c.toJsonString()).toList();
      await prefs.setStringList(_keyClonedTags, jsonList);
      await prefs.setString(_keyLastSync, DateTime.now().toIso8601String());

      debugPrint('🔄 Sync terminée: ${merged.length} clones totaux, ${toSave.length} en cache local');
    } catch (e) {
      debugPrint('❌ Erreur sync: $e');
    }
  }

  /// Obtenir la date de dernière synchronisation
  static Future<DateTime?> getLastSyncDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_keyLastSync);
    if (dateStr != null) {
      return DateTime.parse(dateStr);
    }
    return null;
  }
}
