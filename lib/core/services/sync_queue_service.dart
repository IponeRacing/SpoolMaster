import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// File d'attente persistante des opérations de synchronisation qui ont échoué
/// (typiquement : ajout/suppression de bobine sans réseau). Les opérations sont
/// rejouées au prochain lancement / retour au premier plan de l'app.
///
/// Chaque opération est identifiée par `spoolId` : la dernière opération pour un
/// même id remplace la précédente (un delete après un upsert → delete gagne),
/// ce qui garde la file compacte et cohérente. Un compteur `attempts` évite de
/// retenter indéfiniment une opération « poison » (payload définitivement
/// rejeté) : elle est abandonnée au-delà de [maxAttempts].
class SyncQueueService {
  static const String _key = 'sync_pending_ops_v1';
  static const int maxAttempts = 20;

  /// Ajoute (ou remplace) une opération d'upsert pour cette bobine.
  static Future<void> enqueueUpsert(
      String spoolId, Map<String, dynamic> payload) async {
    await _upsertOp({
      'type': 'upsert',
      'spoolId': spoolId,
      'payload': payload,
      'attempts': 0,
    });
  }

  /// Ajoute (ou remplace) une opération de suppression pour cette bobine.
  static Future<void> enqueueDelete(String spoolId) async {
    await _upsertOp({
      'type': 'delete',
      'spoolId': spoolId,
      'attempts': 0,
    });
  }

  /// Retire l'opération en attente pour cette bobine (appelé quand un push
  /// direct a réussi → plus besoin de la rejouer).
  static Future<void> remove(String spoolId) async {
    final ops = await loadAll();
    final before = ops.length;
    ops.removeWhere((op) => op['spoolId'] == spoolId);
    if (ops.length != before) await _save(ops);
  }

  /// Charge toutes les opérations en attente.
  static Future<List<Map<String, dynamic>>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      debugPrint('⚠️ File de sync corrompue, reset: $e');
      await prefs.remove(_key);
      return [];
    }
  }

  static Future<int> pendingCount() async => (await loadAll()).length;

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<void> _save(List<Map<String, dynamic>> ops) async {
    final prefs = await SharedPreferences.getInstance();
    if (ops.isEmpty) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, jsonEncode(ops));
    }
  }

  static Future<void> _upsertOp(Map<String, dynamic> op) async {
    final ops = await loadAll();
    ops
      ..removeWhere((o) => o['spoolId'] == op['spoolId'])
      ..add(op);
    await _save(ops);
    debugPrint('📌 Opération sync mise en file (${op['type']} ${op['spoolId']})'
        ' — ${ops.length} en attente');
  }

  /// Remplace toute la file (utilisé par le flush pour réécrire les opérations
  /// restantes avec leur compteur d'essais incrémenté).
  static Future<void> replaceAll(List<Map<String, dynamic>> ops) => _save(ops);
}
