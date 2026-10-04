// Historique de consommation saisi en invité puis connexion :
// à la première lecture avec un compte, les événements invité sont repris
// dans la clé du compte, marqués à synchroniser, sans doublon.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/models/spool_usage_event.dart';
import 'package:nfc_filament/core/services/usage_history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_session.dart';

SpoolUsageEvent event(String id, {int day = 1, double grams = 10}) => SpoolUsageEvent(
      id: id,
      spoolId: 's',
      date: DateTime(2026, 9, day),
      grams: grams,
      brand: 'Anycubic',
      material: 'PLA',
      colorName: 'Black',
      colorRgb: 0,
      cost: 0,
    );

String encode(List<SpoolUsageEvent> events) =>
    jsonEncode(events.map((e) => e.toJson()).toList());

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(installFakeSecureStorage);

  group('mergeGuestEvents (pur)', () {
    test('union par id, ids ajoutés = ceux absents du compte', () {
      final merged = UsageHistoryService.mergeGuestEvents(
        account: [event('a'), event('shared')],
        guest: [event('shared'), event('g1'), event('g2'), event('g1')],
      );
      expect(merged.events.map((e) => e.id), ['a', 'shared', 'g1', 'g2']);
      expect(merged.added, {'g1', 'g2'});
    });
  });

  group('reprise à la connexion', () {
    test('événements invité repris, à synchroniser, une seule fois', () async {
      await signIn(extraPrefs: {
        'spool_usage': encode([event('g1', day: 2), event('shared', day: 3)]),
        'spool_usage_unsynced': ['g1', 'shared'],
        'spool_usage_u1': encode([event('a'), event('shared', day: 3)]),
        'spool_usage_unsynced_u1': ['a'],
      });

      final events = await UsageHistoryService.loadEvents();
      expect(events.map((e) => e.id), ['a', 'g1', 'shared']);
      expect(await UsageHistoryService.loadUnsyncedIds(), {'a', 'g1'});
      expect(
        (await UsageHistoryService.pendingEvents()).map((e) => e.id).toSet(),
        {'a', 'g1'},
      );

      // Clé invité vidée : pas de seconde reprise ni de doublon
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('spool_usage'), isNull);
      expect(prefs.getStringList('spool_usage_unsynced'), isNull);
      final again = await UsageHistoryService.loadEvents();
      expect(again.map((e) => e.id), ['a', 'g1', 'shared']);
    });

    test('compte sans historique : tout l’historique invité est repris', () async {
      await signIn(extraPrefs: {
        'spool_usage': encode([event('g1'), event('g2', day: 2)]),
      });
      // 1re lecture via les ids non synchronisés (ex : synchro au lancement)
      expect(await UsageHistoryService.loadUnsyncedIds(), {'g1', 'g2'});
      expect(
        (await UsageHistoryService.loadEvents()).map((e) => e.id),
        ['g1', 'g2'],
      );
    });

    test('invité : rien ne bouge', () async {
      signOutLocally(prefs: {
        'spool_usage': encode([event('g1')]),
        'spool_usage_unsynced': ['g1'],
      });
      expect((await UsageHistoryService.loadEvents()).map((e) => e.id), ['g1']);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('spool_usage'), isNotNull);
    });
  });
}
