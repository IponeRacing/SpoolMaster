// Tests de la logique anti-perte de la sync :
//  - mergeUnconfirmed : le pull (qui REMPLACE le stock local) ne doit pas
//    effacer les bobines dont la sauvegarde serveur n'est pas confirmée
//  - reconcileQueue : le flush ne doit pas écraser les opérations ajoutées
//    pendant qu'il tournait

import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/sync_service.dart';

SpoolInventoryItem spool(String id, {double remaining = 1000}) => SpoolInventoryItem(
      id: id,
      brand: 'Anycubic',
      material: 'PLA',
      colorName: 'Black',
      colorRgb: 0,
      price: 0,
      weight: 1000,
      remainingWeight: remaining,
      addedDate: DateTime(2026, 10),
    );

Map<String, dynamic> upsert(String id, {int attempts = 0}) =>
    {'type': 'upsert', 'spoolId': id, 'payload': {'spool_id': id}, 'attempts': attempts};

Map<String, dynamic> delete(String id, {int attempts = 0}) =>
    {'type': 'delete', 'spoolId': id, 'attempts': attempts};

void main() {
  group('mergeUnconfirmed', () {
    test('sans file ni refus : la liste serveur fait foi', () {
      final server = [spool('a'), spool('b')];
      final merged = SyncService.mergeUnconfirmed(
        serverSpools: server,
        localSpools: [spool('a'), spool('local-only')],
        pendingOps: const [],
      );
      expect(merged.map((s) => s.id), ['a', 'b']);
    });

    test('upsert en file absent du serveur : bobine locale conservée', () {
      final merged = SyncService.mergeUnconfirmed(
        serverSpools: [spool('a')],
        localSpools: [spool('a'), spool('new')],
        pendingOps: [upsert('new')],
      );
      expect(merged.map((s) => s.id), ['a', 'new']);
    });

    test('upsert en file présent sur le serveur : version locale prioritaire', () {
      final merged = SyncService.mergeUnconfirmed(
        serverSpools: [spool('a')],
        localSpools: [spool('a', remaining: 250)],
        pendingOps: [upsert('a')],
      );
      expect(merged.single.remainingWeight, 250);
    });

    test('bobine refusée au push : conservée', () {
      final merged = SyncService.mergeUnconfirmed(
        serverSpools: [spool('a')],
        localSpools: [spool('a'), spool('rejected')],
        pendingOps: const [],
        keepLocalIds: {'rejected'},
      );
      expect(merged.map((s) => s.id), ['a', 'rejected']);
    });

    test("suppression en file : bobine retirée même si le serveur l'a encore", () {
      final merged = SyncService.mergeUnconfirmed(
        serverSpools: [spool('a'), spool('gone')],
        localSpools: [spool('a')],
        pendingOps: [delete('gone')],
      );
      expect(merged.map((s) => s.id), ['a']);
    });

    test('id refusé mais absent du stock local (autre compte) : non copié', () {
      final merged = SyncService.mergeUnconfirmed(
        serverSpools: [spool('a')],
        localSpools: [spool('a')],
        pendingOps: const [],
        keepLocalIds: {'other-account-spool'},
      );
      expect(merged.map((s) => s.id), ['a']);
    });
  });

  group('reconcileQueue', () {
    test('ops réussies retirées, ops en échec conservées avec essais +1', () {
      final flushed = [upsert('ok'), upsert('ko')];
      final next = SyncService.reconcileQueue(
        flushed: flushed,
        current: flushed,
        failedById: {'ko': upsert('ko', attempts: 1)},
      );
      expect(next, [upsert('ko', attempts: 1)]);
    });

    test('op ajoutée pendant le flush : conservée', () {
      final flushed = [upsert('a')];
      final next = SyncService.reconcileQueue(
        flushed: flushed,
        current: [upsert('a'), upsert('added-during-flush')],
        failedById: const {},
      );
      expect(next, [upsert('added-during-flush')]);
    });

    test('op remplacée pendant le flush (upsert → delete) : la nouvelle gagne', () {
      final next = SyncService.reconcileQueue(
        flushed: [upsert('a')],
        current: [delete('a')],
        failedById: {'a': upsert('a', attempts: 1)},
      );
      expect(next, [delete('a')]);
    });

    test('op retirée pendant le flush (sync directe réussie) : reste retirée', () {
      final next = SyncService.reconcileQueue(
        flushed: [upsert('a')],
        current: const [],
        failedById: {'a': upsert('a', attempts: 1)},
      );
      expect(next, isEmpty);
    });
  });
}
