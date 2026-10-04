import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/models/spool_usage_event.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Historique de consommation (baisse du poids restant des bobines).
///
/// Stockage local scopé par user (même schéma que SpoolStorageService), plus
/// une liste des ids pas encore envoyés au backend. La synchro est faite par
/// SyncService (push des non-synchronisés puis pull, fusion par id).
class UsageHistoryService {
  static const String _keyPrefix = 'spool_usage';
  static const String _keyUnsyncedPrefix = 'spool_usage_unsynced';

  /// Taille max conservée en local (les plus anciens sont élagués).
  static const int maxEvents = 5000;

  /// Notifié à chaque nouvel événement (rafraîchit la page Statistiques).
  static final ValueNotifier<int> usageChangedNotifier = ValueNotifier<int>(0);

  static Future<String> _scopedKey(String prefix) async {
    final userId = await AuthService().getCurrentUserId();
    return userId == null ? prefix : '${prefix}_$userId';
  }

  static List<SpoolUsageEvent> _decode(String? data) {
    if (data == null || data.isEmpty) return [];
    try {
      final list = jsonDecode(data) as List<dynamic>;
      return list
          .map((j) => SpoolUsageEvent.fromJson(j as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('⚠️ Historique de consommation illisible: $e');
      return [];
    }
  }

  /// Avec un compte : reprend une seule fois l'historique saisi en invité
  /// (clé non scopée). Les événements invité sont fusionnés par id dans la
  /// clé du compte (jamais dupliqués), marqués « à synchroniser » (ils n'ont
  /// jamais été envoyés), puis retirés de la clé invité pour ne pas être
  /// repris une seconde fois (ni par un autre compte). Avant, ils restaient
  /// invisibles une fois connecté et n'étaient jamais synchronisés.
  static Future<void> _adoptGuestHistory(
    SharedPreferences prefs,
    String eventsKey,
  ) async {
    if (eventsKey == _keyPrefix) return; // invité : rien à reprendre
    final guestData = prefs.getString(_keyPrefix);
    if (guestData == null || guestData.isEmpty) return;

    final guest = _decode(guestData);
    if (guest.isNotEmpty) {
      final account = _decode(prefs.getString(eventsKey));
      final merged = mergeGuestEvents(account: account, guest: guest);
      if (merged.added.isNotEmpty) {
        final events = merged.events..sort((a, b) => a.date.compareTo(b.date));
        final trimmed = events.length > maxEvents
            ? events.sublist(events.length - maxEvents)
            : events;
        await prefs.setString(
          eventsKey,
          jsonEncode(trimmed.map((e) => e.toJson()).toList()),
        );
        final unsyncedKey =
            '$_keyUnsyncedPrefix${eventsKey.substring(_keyPrefix.length)}';
        final unsynced = (prefs.getStringList(unsyncedKey) ?? []).toSet()
          ..addAll(merged.added);
        await prefs.setStringList(unsyncedKey, unsynced.toList());
        debugPrint('📦 ${merged.added.length} événement(s) de consommation '
            'invité repris dans le compte');
      }
    }
    await prefs.remove(_keyPrefix);
    await prefs.remove(_keyUnsyncedPrefix);
  }

  /// Union par id de l'historique du compte et de celui de l'invité.
  /// `added` = ids invité absents du compte (à synchroniser). Pur.
  @visibleForTesting
  static ({List<SpoolUsageEvent> events, Set<String> added}) mergeGuestEvents({
    required List<SpoolUsageEvent> account,
    required List<SpoolUsageEvent> guest,
  }) {
    final known = account.map((e) => e.id).toSet();
    final added = <String>{};
    final events = [...account];
    for (final e in guest) {
      if (known.add(e.id)) {
        added.add(e.id);
        events.add(e);
      }
    }
    return (events: events, added: added);
  }

  static Future<List<SpoolUsageEvent>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _scopedKey(_keyPrefix);
    await _adoptGuestHistory(prefs, key);
    return _decode(prefs.getString(key));
  }

  static Future<void> _saveEvents(List<SpoolUsageEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    events.sort((a, b) => a.date.compareTo(b.date));
    final trimmed = events.length > maxEvents
        ? events.sublist(events.length - maxEvents)
        : events;
    await prefs.setString(
      await _scopedKey(_keyPrefix),
      jsonEncode(trimmed.map((e) => e.toJson()).toList()),
    );
    usageChangedNotifier.value++;
  }

  static Future<Set<String>> loadUnsyncedIds() async {
    final prefs = await SharedPreferences.getInstance();
    await _adoptGuestHistory(prefs, await _scopedKey(_keyPrefix));
    return (prefs.getStringList(await _scopedKey(_keyUnsyncedPrefix)) ?? [])
        .toSet();
  }

  static Future<void> _saveUnsyncedIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(await _scopedKey(_keyUnsyncedPrefix), ids.toList());
  }

  /// Fenêtre dans laquelle une remontée du poids est considérée comme la
  /// correction d'une saisie erronée (ex. 100 g tapé au lieu de 900 g).
  static const Duration correctionWindow = Duration(hours: 48);

  /// Construit l'événement correspondant au passage de [before] à
  /// [newRemaining] :
  /// - baisse → consommation ;
  /// - hausse alors que [recentNet] g ont été consommés sur cette bobine
  ///   dans [correctionWindow] → correction négative (au plus [recentNet]) ;
  /// - sinon null (pas une consommation).
  /// Fonction pure (testable).
  static SpoolUsageEvent? buildEvent(
    SpoolInventoryItem before,
    double newRemaining, {
    String source = SpoolUsageEvent.sourceUpdate,
    DateTime? now,
    double recentNet = 0,
  }) {
    final delta = before.remainingWeight - newRemaining;
    final date = now ?? DateTime.now();
    if (delta < -0.5 && recentNet > 0.5) {
      final corrected = (-delta).clamp(0, recentNet).toDouble();
      return SpoolUsageEvent(
        id: '${before.id}_${date.microsecondsSinceEpoch}',
        spoolId: before.id,
        date: date,
        grams: -corrected,
        brand: before.brand,
        material: before.material,
        colorName: before.colorName,
        colorRgb: before.colorRgb,
        cost: -costForGrams(before, corrected),
        source: SpoolUsageEvent.sourceCorrection,
      );
    }
    final grams = delta;
    if (grams <= 0.5) return null;
    return SpoolUsageEvent(
      id: '${before.id}_${date.microsecondsSinceEpoch}',
      spoolId: before.id,
      date: date,
      grams: grams,
      brand: before.brand,
      material: before.material,
      colorName: before.colorName,
      colorRgb: before.colorRgb,
      cost: costForGrams(before, grams),
      source: source,
    );
  }

  /// Coût matière de [grams] g prélevés sur [spool] (prix / poids initial).
  static double costForGrams(SpoolInventoryItem spool, double grams) {
    if (spool.weight <= 0 || spool.price <= 0) return 0;
    return spool.price / spool.weight * grams;
  }

  /// Consommation nette récente d'une bobine (consommations − corrections
  /// dans [correctionWindow]). Pur.
  static double recentNetFor(
    List<SpoolUsageEvent> events,
    String spoolId,
    DateTime now,
  ) {
    final since = now.subtract(correctionWindow);
    final net = events
        .where((e) => e.spoolId == spoolId && e.date.isAfter(since))
        .fold<double>(0, (sum, e) => sum + e.grams);
    return net > 0 ? net : 0;
  }

  /// Journalise la consommation si le poids restant a baissé, ou une
  /// correction s'il remonte peu après une baisse (saisie erronée).
  static Future<SpoolUsageEvent?> recordChange(
    SpoolInventoryItem before,
    double newRemaining, {
    String source = SpoolUsageEvent.sourceUpdate,
  }) async {
    final now = DateTime.now();
    final existing = await loadEvents();
    final event = buildEvent(
      before,
      newRemaining,
      source: source,
      now: now,
      recentNet: newRemaining > before.remainingWeight
          ? recentNetFor(existing, before.id, now)
          : 0,
    );
    if (event == null) return null;
    final events = existing..add(event);
    await _saveEvents(events);
    final unsynced = await loadUnsyncedIds()..add(event.id);
    await _saveUnsyncedIds(unsynced);
    return event;
  }

  /// Événements pas encore envoyés au backend.
  static Future<List<SpoolUsageEvent>> pendingEvents() async {
    final unsynced = await loadUnsyncedIds();
    if (unsynced.isEmpty) return [];
    final events = await loadEvents();
    return events.where((e) => unsynced.contains(e.id)).toList();
  }

  static Future<void> markSynced(Iterable<String> ids) async {
    final unsynced = await loadUnsyncedIds()..removeAll(ids);
    await _saveUnsyncedIds(unsynced);
  }

  /// Fusionne des événements venus du serveur (union par id, jamais de
  /// suppression locale : l'historique n'est qu'additif).
  static Future<int> mergeRemote(List<SpoolUsageEvent> remote) async {
    if (remote.isEmpty) return 0;
    final events = await loadEvents();
    final known = events.map((e) => e.id).toSet();
    final added = remote.where((e) => !known.contains(e.id)).toList();
    if (added.isEmpty) return 0;
    await _saveEvents(events..addAll(added));
    return added.length;
  }

  /// Supprime des événements locaux (nettoyage des tests E2E uniquement :
  /// l'historique n'est jamais purgé par l'app).
  @visibleForTesting
  static Future<void> removeEventsWhere(
    bool Function(SpoolUsageEvent) test,
  ) async {
    final events = await loadEvents();
    final removed = events.where(test).map((e) => e.id).toSet();
    if (removed.isEmpty) return;
    await _saveEvents(events..removeWhere((e) => removed.contains(e.id)));
    final unsynced = await loadUnsyncedIds()..removeAll(removed);
    await _saveUnsyncedIds(unsynced);
  }

  /// Ajoute des événements locaux (import), marqués à synchroniser.
  static Future<void> addEvents(List<SpoolUsageEvent> newEvents) async {
    if (newEvents.isEmpty) return;
    final events = await loadEvents();
    final known = events.map((e) => e.id).toSet();
    final added = newEvents.where((e) => !known.contains(e.id)).toList();
    await _saveEvents(events..addAll(added));
    final unsynced = await loadUnsyncedIds()..addAll(added.map((e) => e.id));
    await _saveUnsyncedIds(unsynced);
  }
}

/// Agrégats de consommation pour la page Statistiques. Pur (testable).
class UsageSummary {
  UsageSummary._({
    required this.gramsLast30Days,
    required this.costLast30Days,
    required this.gramsThisMonth,
    required this.costThisMonth,
    required this.gramsTotal,
    required this.costTotal,
    required this.gramsByMaterial,
    required this.monthly,
  });

  factory UsageSummary.from(List<SpoolUsageEvent> events, {DateTime? now}) {
    final n = now ?? DateTime.now();
    final since30 = n.subtract(const Duration(days: 30));
    final monthStart = DateTime(n.year, n.month);
    var g30 = 0.0;
    var c30 = 0.0;
    var gMonth = 0.0;
    var cMonth = 0.0;
    var gAll = 0.0;
    var cAll = 0.0;
    final byMaterial = <String, double>{};
    // 6 derniers mois, du plus ancien au plus récent
    final months = [
      for (var i = 5; i >= 0; i--) DateTime(n.year, n.month - i),
    ];
    final monthly = {for (final m in months) m: 0.0};

    for (final e in events) {
      gAll += e.grams;
      cAll += e.cost;
      if (e.date.isAfter(since30)) {
        g30 += e.grams;
        c30 += e.cost;
        final mat = e.material.isEmpty ? '?' : e.material;
        byMaterial[mat] = (byMaterial[mat] ?? 0) + e.grams;
      }
      if (!e.date.isBefore(monthStart)) {
        gMonth += e.grams;
        cMonth += e.cost;
      }
      final key = DateTime(e.date.year, e.date.month);
      if (monthly.containsKey(key)) monthly[key] = monthly[key]! + e.grams;
    }

    // Une correction peut tomber dans une autre période que la consommation
    // qu'elle annule (ex. minuit) : on n'affiche jamais de valeur négative.
    double pos(double v) => v > 0 ? v : 0;
    final sortedMaterials = byMaterial.entries
        .where((e) => e.value > 0.5)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return UsageSummary._(
      gramsLast30Days: pos(g30),
      costLast30Days: pos(c30),
      gramsThisMonth: pos(gMonth),
      costThisMonth: pos(cMonth),
      gramsTotal: pos(gAll),
      costTotal: pos(cAll),
      gramsByMaterial: sortedMaterials,
      monthly: [
        for (final e in monthly.entries) MapEntry(e.key, pos(e.value)),
      ],
    );
  }

  final double gramsLast30Days;
  final double costLast30Days;
  final double gramsThisMonth;
  final double costThisMonth;
  final double gramsTotal;
  final double costTotal;

  /// Grammes consommés par matériau sur 30 jours, du plus au moins consommé.
  final List<MapEntry<String, double>> gramsByMaterial;

  /// Grammes consommés par mois (6 derniers mois, ordre chronologique).
  final List<MapEntry<DateTime, double>> monthly;

  bool get isEmpty => gramsTotal <= 0;
}
