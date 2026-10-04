import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/models/spool_usage_event.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/usage_history_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';

/// Synchro de l'historique de consommation avec le backend (/usage).
///
/// Journal additif : push des événements non synchronisés (insertion
/// idempotente côté serveur), puis pull et fusion par id. Aucun
/// remplacement ni suppression locale → pas de risque de perte.
/// Fail-open : une erreur (hors ligne, backend pas encore migré) laisse
/// simplement les événements en attente pour la prochaine synchro.
class UsageSyncService {
  static final AuthService _authService = AuthService();
  static bool _running = false;

  static Map<String, String> _headers(String token) => {
        ...ApiConfig.commonHeaders,
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static Map<String, dynamic> toPayload(SpoolUsageEvent e) => {
        'event_id': e.id,
        'spool_id': e.spoolId,
        'used_at': e.date.toUtc().toIso8601String(),
        'grams': e.grams,
        'cost': e.cost,
        'brand': e.brand,
        'material': e.material,
        'color_name': e.colorName,
        'color_rgb': e.colorRgb,
        'source': e.source,
      };

  static SpoolUsageEvent? fromPayload(Map<String, dynamic> j) {
    try {
      return SpoolUsageEvent(
        id: j['event_id'] as String,
        spoolId: j['spool_id'] as String,
        date: DateTime.parse(j['used_at'] as String).toLocal(),
        grams: (j['grams'] as num).toDouble(),
        brand: j['brand'] as String? ?? '',
        material: j['material'] as String? ?? '',
        colorName: j['color_name'] as String? ?? '',
        colorRgb: (j['color_rgb'] as num?)?.toInt() ?? 0,
        cost: (j['cost'] as num?)?.toDouble() ?? 0,
        source: j['source'] as String? ?? SpoolUsageEvent.sourceUpdate,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> sync() async {
    if (_running) return;
    _running = true;
    try {
      if (!await UserPreferencesService.isSignedIn()) return;
      await _push();
      await _pull();
    } catch (e) {
      debugPrint('⚠️ [UsageSync] $e');
    } finally {
      _running = false;
    }
  }

  static Future<void> _push() async {
    final pending = await UsageHistoryService.pendingEvents();
    for (var i = 0; i < pending.length; i += 200) {
      final batch = pending.sublist(i, (i + 200).clamp(0, pending.length));
      final response = await _authService.authenticatedRequest((token) =>
          http
              .post(
                Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usage}'),
                headers: _headers(token),
                body: jsonEncode({'events': batch.map(toPayload).toList()}),
              )
              .timeout(ApiConfig.connectTimeout));
      if (response.statusCode != 200) {
        debugPrint('⚠️ [UsageSync] push ${response.statusCode}');
        return;
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>? ?? const {};
      final accepted = (data['accepted_ids'] as List<dynamic>? ?? const [])
          .map((e) => e.toString());
      await UsageHistoryService.markSynced(accepted);
    }
  }

  static Future<void> _pull() async {
    final response = await _authService.authenticatedRequest((token) => http
        .get(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usage}'),
          headers: _headers(token),
        )
        .timeout(ApiConfig.connectTimeout));
    if (response.statusCode != 200) {
      debugPrint('⚠️ [UsageSync] pull ${response.statusCode}');
      return;
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>? ?? const {};
    final remote = (data['events'] as List<dynamic>? ?? const [])
        .map((e) => fromPayload(e as Map<String, dynamic>))
        .whereType<SpoolUsageEvent>()
        .toList();
    final added = await UsageHistoryService.mergeRemote(remote);
    if (added > 0) debugPrint('📈 [UsageSync] $added événement(s) récupéré(s)');
  }
}
