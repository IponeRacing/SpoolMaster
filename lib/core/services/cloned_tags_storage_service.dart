import 'package:flutter/foundation.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/cloned_tag_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bibliothèque locale des tags Bambu Lab clonés.
///
/// Stockage local uniquement (SharedPreferences), scopé par compte comme les
/// bobines. Le backend n'expose aucune route de clones : l'ancienne
/// « synchro cloud » appelait des URL inexistantes et affichait pourtant
/// « Synchronisation terminée » — elle a été retirée.
class ClonedTagsStorageService {
  static const String _keyClonedTags = 'cloned_tags';
  static const int _maxLocalClones = 50; // Limite LRU (Least Recently Used)

  /// Clé scopée par user_id ; sans compte, clé invité (= clé historique).
  static Future<String> _storageKey() async {
    final userId = await AuthService().getCurrentUserId();
    return userId == null ? _keyClonedTags : '${_keyClonedTags}_$userId';
  }

  static Future<void> _save(String key, List<ClonedTagModel> clones) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, clones.map((c) => c.toJsonString()).toList());
  }

  /// Sauvegarder un tag cloné. Une relecture du même tag (même UID, ou même
  /// contenu si l'UID est inconnu) met à jour le clone existant au lieu d'en
  /// créer un nouveau : son id, son nom personnalisé et sa date de clonage
  /// sont conservés, et il repasse en tête (le plus récent).
  static Future<void> saveClonedTag(ClonedTagModel clone) async {
    final key = await _storageKey();
    final clones = await getClonedTags();
    final updated = upsertClone(clones, clone);
    await _save(key, updated);
  }

  /// Insère [clone] en tête de [clones] en remplaçant un éventuel doublon
  /// (même [ClonedTagModel.dedupKey]) puis applique la limite LRU. Pur.
  @visibleForTesting
  static List<ClonedTagModel> upsertClone(
    List<ClonedTagModel> clones,
    ClonedTagModel clone, {
    int maxClones = _maxLocalClones,
  }) {
    final key = clone.dedupKey;
    final existing = clones.where((c) => c.dedupKey == key).firstOrNull;
    final toInsert = existing == null
        ? clone
        : ClonedTagModel(
            id: existing.id,
            clonedAt: existing.clonedAt,
            bobbinData: clone.bobbinData,
            rawBlocks: clone.rawBlocks,
            customName: existing.customName ?? clone.customName,
          );
    final result = [
      toInsert,
      ...clones.where((c) => c.dedupKey != key),
    ];
    if (result.length > maxClones) {
      debugPrint('📦 Cache LRU: ${result.length - maxClones} anciens clones '
          'supprimés (garde les $maxClones plus récents)');
      result.removeRange(maxClones, result.length);
    }
    return result;
  }

  /// Récupérer les tags clonés du compte courant (ou de l'invité).
  /// Avec un compte et sans bibliothèque propre, la bibliothèque invité /
  /// historique (clé non scopée) est reprise une fois, comme les bobines.
  /// Les doublons hérités des anciennes versions sont fusionnés.
  static Future<List<ClonedTagModel>> getClonedTags() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _storageKey();
    var jsonList = prefs.getStringList(key);

    if (jsonList == null && key != _keyClonedTags) {
      final legacy = prefs.getStringList(_keyClonedTags);
      if (legacy != null) {
        debugPrint('📦 Migration des clones vers la clé du compte');
        await prefs.setStringList(key, legacy);
        await prefs.remove(_keyClonedTags);
        jsonList = legacy;
      }
    }

    final clones = <ClonedTagModel>[];
    final seen = <String>{};
    for (final json in jsonList ?? const <String>[]) {
      try {
        final clone = ClonedTagModel.fromJsonString(json);
        if (seen.add(clone.dedupKey)) clones.add(clone);
      } catch (e) {
        debugPrint('⚠️ Clone illisible ignoré: $e');
      }
    }
    return clones;
  }

  /// Supprimer un tag cloné
  static Future<void> deleteClonedTag(String id) async {
    final key = await _storageKey();
    final clones = await getClonedTags()
      ..removeWhere((c) => c.id == id);
    await _save(key, clones);
  }

  /// Mettre à jour le nom personnalisé d'un clone
  static Future<void> updateCloneName(String id, String customName) async {
    final key = await _storageKey();
    final clones = await getClonedTags();

    final index = clones.indexWhere((c) => c.id == id);
    if (index != -1) {
      clones[index] = ClonedTagModel(
        id: clones[index].id,
        clonedAt: clones[index].clonedAt,
        bobbinData: clones[index].bobbinData,
        rawBlocks: clones[index].rawBlocks,
        customName: customName,
      );
      await _save(key, clones);
    }
  }

  /// Obtenir un clone par ID
  static Future<ClonedTagModel?> getClonedTagById(String id) async {
    final clones = await getClonedTags();
    return clones.where((c) => c.id == id).firstOrNull;
  }

  /// Supprimer tous les clones locaux du compte courant
  static Future<void> clearAllClones() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(await _storageKey());
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
}
