// Historique de consommation :
//  - seule une BAISSE du poids restant est une consommation
//  - coût = prix / poids initial × grammes
//  - agrégats (30 jours, mois, par matériau, 6 mois)
//  - persistance, file de synchro (pending / markSynced), fusion serveur
//  - updateSpool journalise automatiquement (source update / print)
//  - emplacement / notes conservés quand le backend ne les renvoie pas

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/models/spool_usage_event.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/sync_service.dart';
import 'package:nfc_filament/core/services/usage_history_service.dart';
import 'package:nfc_filament/core/services/usage_sync_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

SpoolInventoryItem spool({
  String id = 's1',
  double remaining = 1000,
  double price = 25,
  double weight = 1000,
  String material = 'PLA',
  String? location,
  String? notes,
}) =>
    SpoolInventoryItem(
      id: id,
      brand: 'Anycubic',
      material: material,
      colorName: 'Black',
      colorRgb: 0xFF000000,
      price: price,
      weight: weight,
      remainingWeight: remaining,
      addedDate: DateTime(2026),
      location: location,
      notes: notes,
    );

SpoolUsageEvent event(String id, DateTime date, double grams,
        {String material = 'PLA', double cost = 0}) =>
    SpoolUsageEvent(
      id: id,
      spoolId: 's',
      date: date,
      grams: grams,
      brand: 'X',
      material: material,
      colorName: 'Black',
      colorRgb: 0,
      cost: cost,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Non connecté : les synchros réseau sont sautées.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (call) async => null,
    );
  });

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('buildEvent', () {
    test('baisse du poids = consommation avec coût', () {
      final e = UsageHistoryService.buildEvent(
        spool(remaining: 800),
        650,
        now: DateTime(2026, 10, 4),
      )!;
      expect(e.grams, 150);
      expect(e.cost, closeTo(3.75, 1e-9)); // 25 / 1000 × 150
      expect(e.spoolId, 's1');
      expect(e.source, SpoolUsageEvent.sourceUpdate);
    });

    test('hausse ou égalité = pas un événement', () {
      expect(UsageHistoryService.buildEvent(spool(remaining: 500), 700), isNull);
      expect(UsageHistoryService.buildEvent(spool(remaining: 500), 500), isNull);
      expect(UsageHistoryService.buildEvent(spool(remaining: 500), 499.8), isNull);
    });

    test('bobine sans prix = coût 0', () {
      final e = UsageHistoryService.buildEvent(spool(price: 0), 900)!;
      expect(e.cost, 0);
    });
  });

  group('Correction de saisie erronée', () {
    test('remontée peu après une baisse = correction négative plafonnée', () {
      final c = UsageHistoryService.buildEvent(
        spool(remaining: 100),
        900,
        recentNet: 900,
        now: DateTime(2026, 10, 4),
      )!;
      expect(c.grams, -800);
      expect(c.cost, closeTo(-20, 1e-9)); // 25 / 1000 × 800
      expect(c.source, SpoolUsageEvent.sourceCorrection);

      // Jamais plus que ce qui a été consommé récemment
      final capped = UsageHistoryService.buildEvent(
        spool(remaining: 800),
        1000,
        recentNet: 50,
      )!;
      expect(capped.grams, -50);
    });

    test('remontée sans consommation récente = rien', () {
      expect(
        UsageHistoryService.buildEvent(spool(remaining: 100), 900),
        isNull,
      );
    });

    test('recentNetFor : fenêtre de 48 h, corrections déduites', () {
      final now = DateTime(2026, 10, 4, 12);
      final events = [
        SpoolUsageEvent(id: '1', spoolId: 's1', date: now.subtract(const Duration(hours: 1)), grams: 300, brand: '', material: '', colorName: '', colorRgb: 0, cost: 0),
        SpoolUsageEvent(id: '2', spoolId: 's1', date: now.subtract(const Duration(hours: 2)), grams: -100, brand: '', material: '', colorName: '', colorRgb: 0, cost: 0, source: SpoolUsageEvent.sourceCorrection),
        SpoolUsageEvent(id: '3', spoolId: 's1', date: now.subtract(const Duration(days: 3)), grams: 500, brand: '', material: '', colorName: '', colorRgb: 0, cost: 0),
        SpoolUsageEvent(id: '4', spoolId: 'autre', date: now, grams: 999, brand: '', material: '', colorName: '', colorRgb: 0, cost: 0),
      ];
      expect(UsageHistoryService.recentNetFor(events, 's1', now), 200);
    });

    test('scénario réel : 1000 → 100 (faute de frappe) → 900 = 100 g consommés', () async {
      final s = spool();
      await SpoolStorageService.addSpool(s);
      await SpoolStorageService.updateSpool(s.id, s.copyWith(remainingWeight: 100));
      await SpoolStorageService.updateSpool(
        s.id,
        s.copyWith(remainingWeight: 900),
      );
      final events = await UsageHistoryService.loadEvents();
      expect(events, hasLength(2));
      expect(events.fold<double>(0, (a, e) => a + e.grams), 100);
      final summary = UsageSummary.from(events);
      expect(summary.gramsLast30Days, 100);
      expect(summary.costLast30Days, closeTo(2.5, 1e-9));
      // La correction part aussi au serveur
      expect(await UsageHistoryService.pendingEvents(), hasLength(2));
    });

    test("le résumé n'affiche jamais de négatif (correction sur un autre mois)", () {
      final s = UsageSummary.from([
        event('a', DateTime(2026, 9, 30, 23), 200),
        SpoolUsageEvent(id: 'b', spoolId: 's', date: DateTime(2026, 10, 1, 1), grams: -200, brand: 'X', material: 'PLA', colorName: '', colorRgb: 0, cost: -5, source: SpoolUsageEvent.sourceCorrection),
      ], now: DateTime(2026, 10, 2));
      expect(s.gramsThisMonth, 0);
      expect(s.monthly.last.value, 0);
      expect(s.gramsLast30Days, 0);
      expect(s.gramsByMaterial, isEmpty);
    });
  });

  group('UsageSummary', () {
    test('agrège 30 jours, mois en cours, matériaux et 6 mois', () {
      final now = DateTime(2026, 10, 15);
      final s = UsageSummary.from([
        event('a', DateTime(2026, 10, 14), 100, cost: 2),
        event('b', DateTime(2026, 10, 2), 50, material: 'PETG', cost: 1),
        event('c', DateTime(2026, 9, 20), 200, cost: 4), // 30 j mais mois précédent
        event('d', DateTime(2026, 6), 300), // hors 30 j
        event('e', DateTime(2025), 999), // hors 6 mois
      ], now: now);

      expect(s.gramsLast30Days, 350);
      expect(s.costLast30Days, 7);
      expect(s.gramsThisMonth, 150);
      expect(s.costThisMonth, 3);
      expect(s.gramsTotal, 1649);
      expect(s.gramsByMaterial.first.key, 'PLA');
      expect(s.gramsByMaterial.first.value, 300);
      expect(s.monthly, hasLength(6));
      expect(s.monthly.last.key, DateTime(2026, 10));
      expect(s.monthly.last.value, 150);
      expect(s.monthly.first.key, DateTime(2026, 5));
      expect(s.monthly[1].value, 300); // juin
    });

    test('vide', () {
      expect(UsageSummary.from(const []).isEmpty, isTrue);
    });
  });

  group('Persistance + synchro', () {
    test('recordChange stocke et marque à synchroniser', () async {
      await UsageHistoryService.recordChange(spool(), 900);
      final events = await UsageHistoryService.loadEvents();
      expect(events, hasLength(1));
      final pending = await UsageHistoryService.pendingEvents();
      expect(pending.single.id, events.single.id);

      await UsageHistoryService.markSynced([events.single.id]);
      expect(await UsageHistoryService.pendingEvents(), isEmpty);
      expect(await UsageHistoryService.loadEvents(), hasLength(1));
    });

    test('mergeRemote = union par id, jamais de suppression', () async {
      await UsageHistoryService.recordChange(spool(), 900);
      final local = (await UsageHistoryService.loadEvents()).single;
      final added = await UsageHistoryService.mergeRemote([
        local,
        event('remote-1', DateTime(2026, 9), 42),
      ]);
      expect(added, 1);
      expect(await UsageHistoryService.loadEvents(), hasLength(2));
      expect(await UsageHistoryService.mergeRemote(const []), 0);
    });

    test('payload serveur : aller-retour', () {
      final e = event('x', DateTime.utc(2026, 9, 1, 12), 12.5, cost: 0.31);
      final back = UsageSyncService.fromPayload(UsageSyncService.toPayload(e))!;
      expect(back.id, 'x');
      expect(back.grams, 12.5);
      expect(back.cost, 0.31);
      expect(back.date.toUtc(), DateTime.utc(2026, 9, 1, 12));
      expect(UsageSyncService.fromPayload({'event_id': 1}), isNull);
    });
  });

  group('SpoolStorageService.updateSpool', () {
    test('journalise la baisse avec la source fournie', () async {
      final s = spool();
      await SpoolStorageService.addSpool(s);
      await SpoolStorageService.updateSpool(
        s.id,
        s.copyWith(remainingWeight: 880),
        usageSource: SpoolUsageEvent.sourcePrint,
      );
      final events = await UsageHistoryService.loadEvents();
      expect(events.single.grams, 120);
      expect(events.single.source, SpoolUsageEvent.sourcePrint);
      expect((await SpoolStorageService.loadSpools()).single.remainingWeight, 880);
    });

    test("modifier l'emplacement sans toucher au poids = pas d'événement", () async {
      final s = spool(remaining: 600);
      await SpoolStorageService.addSpool(s);
      await SpoolStorageService.updateSpool(s.id, s.copyWith(location: 'Étagère C'));
      expect(await UsageHistoryService.loadEvents(), isEmpty);
      expect((await SpoolStorageService.loadSpools()).single.location, 'Étagère C');
    });
  });

  group('Pull : backend sans location/notes (avant migration 005)', () {
    test('carryOverFreeText garde les valeurs locales', () {
      final server = [spool(id: 'a'), spool(id: 'b'), spool(id: 'c')];
      final local = [
        spool(id: 'a', location: 'Boîte 1', notes: 'humide'),
        spool(id: 'b'),
      ];
      final merged = SyncService.carryOverFreeText(server, local);
      expect(merged[0].location, 'Boîte 1');
      expect(merged[0].notes, 'humide');
      expect(merged[1].location, isNull);
      expect(merged[2].location, isNull);
    });

    test('carryOverFreeText garde aussi buse et codes NFC', () {
      final server = [spool(id: 'a')];
      final local = [
        spool(id: 'a').copyWith(nozzleSize: 0.4, vendorCode: '0276', productCode: 'GFA00'),
      ];
      final merged = SyncService.carryOverFreeText(server, local).single;
      expect(merged.nozzleSize, 0.4);
      expect(merged.vendorCode, '0276');
      expect(merged.productCode, 'GFA00');
    });
  });

  group('Modèle', () {
    test('JSON : location / notes et compatibilité avec les anciennes données', () {
      final s = spool(location: 'A', notes: 'B');
      final back = SpoolInventoryItem.fromJson(s.toJson());
      expect(back.location, 'A');
      expect(back.notes, 'B');

      final legacy = s.toJson()..remove('location')..remove('notes');
      final old = SpoolInventoryItem.fromJson(legacy);
      expect(old.location, isNull);
      expect(old.notes, isNull);
    });
  });
}
