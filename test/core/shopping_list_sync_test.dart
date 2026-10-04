// Synchro de la liste de courses :
//  - mergePulled : le pull FUSIONNE au lieu de remplacer (articles refusés
//    ou ajoutés pendant la synchro conservés, suppressions en attente
//    respectées, champs non renvoyés par le serveur repris du local) ;
//  - fullSync : pas de pull si le push échoue ;
//  - push : uniquement compte courant + invité, suppressions en attente
//    envoyées dans deleted_ids puis oubliées ;
//  - suppression : DELETE /shopping-list/:id, mémorisée si échec.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/shopping_list_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_session.dart';

SpoolInventoryItem item(
  String id, {
  String brand = 'Anycubic',
  String material = 'PLA',
  double remaining = 120,
  String? detailedType,
  String? batchNumber,
  DateTime? manufactureDate,
  int? dryingTemp,
  String? materialId,
}) =>
    SpoolInventoryItem(
      id: id,
      brand: brand,
      material: material,
      colorName: 'Black $id',
      colorRgb: 0,
      price: 20,
      weight: 1000,
      remainingWeight: remaining,
      addedDate: DateTime(2026, 9),
      detailedType: detailedType,
      batchNumber: batchNumber,
      manufactureDate: manufactureDate,
      dryingTemp: dryingTemp,
      materialId: materialId,
    );

/// Article tel que renvoyé par GET /shopping-list/pull (format actuel du
/// serveur : pas de detailed_type, batch_number, drying_temp…).
Map<String, dynamic> serverItem(String id, {String brand = 'Anycubic', Map<String, dynamic> extra = const {}}) => {
      'id': id,
      'brand': brand,
      'material': 'PLA',
      'color_name': 'Black $id',
      'color_rgb': 0,
      'price': 20.0,
      'weight': 1000.0,
      'extruder_temp_min': null,
      'is_ordered': false,
      'added_date': '2026-09-20 10:00:00',
      ...extra,
    };

String encodeList(List<SpoolInventoryItem> items) =>
    jsonEncode(items.map((i) => i.toJson()).toList());

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(installFakeSecureStorage);

  group('mergePulled', () {
    test('sans push préalable : la liste serveur fait foi', () {
      final merged = ShoppingListService.mergePulled(
        serverItems: [serverItem('a'), serverItem('b')],
        localItems: [item('a'), item('local-only')],
      );
      expect(merged.map((i) => i.id), ['a', 'b']);
    });

    test('article refusé au push : version locale conservée', () {
      final merged = ShoppingListService.mergePulled(
        serverItems: [serverItem('a', brand: 'Serveur')],
        localItems: [item('a', brand: 'Local'), item('refused')],
        keepLocalIds: {'a', 'refused'},
        confirmedIds: const {},
      );
      expect(merged.map((i) => i.id), ['a', 'refused']);
      expect(merged.first.brand, 'Local');
    });

    test('ajouté pendant la synchro (non poussé) : conservé', () {
      final merged = ShoppingListService.mergePulled(
        serverItems: [serverItem('a')],
        localItems: [item('a'), item('new')],
        confirmedIds: {'a'},
      );
      expect(merged.map((i) => i.id), ['a', 'new']);
    });

    test('poussé, accepté puis absent du serveur : supprimé ailleurs → retiré', () {
      final merged = ShoppingListService.mergePulled(
        serverItems: [serverItem('a')],
        localItems: [item('a'), item('gone')],
        confirmedIds: {'a', 'gone'},
      );
      expect(merged.map((i) => i.id), ['a']);
    });

    test('suppression locale en attente : jamais ressuscitée par le pull', () {
      final merged = ShoppingListService.mergePulled(
        serverItems: [serverItem('a'), serverItem('deleted')],
        localItems: [item('a')],
        confirmedIds: {'a'},
        pendingDeletedIds: {'deleted'},
      );
      expect(merged.map((i) => i.id), ['a']);
    });

    test('champs non renvoyés par le serveur : valeur locale du même id', () {
      final local = item(
        'a',
        remaining: 85,
        detailedType: 'PLA+',
        batchNumber: 'AHPLBK-101',
        manufactureDate: DateTime(2026, 3, 2),
        dryingTemp: 55,
        materialId: 'GFL99',
      );
      final merged = ShoppingListService.mergePulled(
        serverItems: [serverItem('a')],
        localItems: [local],
        confirmedIds: {'a'},
      );
      final a = merged.single;
      expect(a.detailedType, 'PLA+');
      expect(a.batchNumber, 'AHPLBK-101');
      expect(a.manufactureDate, DateTime(2026, 3, 2));
      expect(a.dryingTemp, 55);
      expect(a.materialId, 'GFL99');
      expect(a.remainingWeight, 85);
      expect(a.addedDate, DateTime(2026, 9));
    });

    test('champs renvoyés par le serveur : valeur serveur', () {
      final merged = ShoppingListService.mergePulled(
        serverItems: [
          serverItem('a', extra: {
            'remaining_weight': 40,
            'detailed_type': 'PLA Matte',
            'batch_number': 'LOT-2',
            'manufacture_date': '2026-05-01T00:00:00.000',
            'drying_temp': 50,
            'material_id': 'M2',
          }),
        ],
        localItems: [
          item('a', remaining: 85, detailedType: 'PLA+', dryingTemp: 55, materialId: 'GFL99'),
        ],
        confirmedIds: {'a'},
      );
      final a = merged.single;
      // Exception voulue : le poids restant local prime (le serveur renvoie le
      // poids total à la place, gardé pour les anciennes versions).
      expect(a.remainingWeight, 85);
      expect(a.detailedType, 'PLA Matte');
      expect(a.batchNumber, 'LOT-2');
      expect(a.manufactureDate, DateTime(2026, 5));
      expect(a.dryingTemp, 50);
      expect(a.materialId, 'M2');
    });

    test('article uniquement serveur : valeurs par défaut sans planter', () {
      final a = ShoppingListService.mergePulled(
        serverItems: [
          {'item_id': 'x', 'brand': null, 'color_rgb': '255', 'price': '12.5'},
        ],
        localItems: const [],
      ).single;
      expect(a.id, 'x');
      expect(a.brand, '');
      expect(a.colorRgb, 255);
      expect(a.price, 12.5);
      expect(a.remainingWeight, 0);
    });
  });

  group('fullSync (connecté)', () {
    late List<http.Request> requests;

    Future<void> runSync(
      Future<http.Response> Function(http.Request request) handler,
    ) =>
        http.runWithClient(ShoppingListService.fullSync, () => MockClient((r) async {
              requests.add(r);
              return handler(r);
            }));

    setUp(() async {
      requests = [];
      await signIn(extraPrefs: {
        'shopping_list_u1': encodeList([item('mine'), item('refused')]),
        'shopping_list': encodeList([item('guest')]),
        'shopping_list_other': encodeList([item('other-account')]),
        'shopping_deleted_ids_u1': ['old-deleted'],
      });
    });

    test('push en échec → pas de pull, liste locale intacte', () async {
      await runSync((_) async => http.Response('down', 500));
      expect(requests.map((r) => r.method), ['POST']);
      final local = await ShoppingListService.loadShoppingList();
      expect(local.map((i) => i.id), ['mine', 'refused']);
      // Suppression toujours en attente
      expect(await ShoppingListService.loadPendingDeletedIds(), {'old-deleted'});
    });

    test("push : compte courant + invité, jamais l'autre compte ; puis fusion", () async {
      await runSync((r) async {
        if (r.method == 'POST') {
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'items_synced': 2,
                'failed': 1,
                'failed_item_ids': ['refused'],
                'deleted': 1,
              },
            }),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {
              'items': [serverItem('mine'), serverItem('guest'), serverItem('from-other-device')],
              'ordered_ids': ['from-other-device'],
            },
          }),
          200,
        );
      });

      expect(requests.map((r) => r.method), ['POST', 'GET']);
      final pushed = jsonDecode(requests.first.body) as Map<String, dynamic>;
      final pushedIds = (pushed['items'] as List)
          .map((j) => (j as Map<String, dynamic>)['id'])
          .toSet();
      expect(pushedIds, {'mine', 'refused', 'guest'});
      expect(pushed['deleted_ids'], ['old-deleted']);

      final local = await ShoppingListService.loadShoppingList();
      expect(
        local.map((i) => i.id).toSet(),
        {'mine', 'guest', 'from-other-device', 'refused'},
      );
      expect(await ShoppingListService.loadPendingDeletedIds(), isEmpty);
      expect(await ShoppingListService.loadOrderedIds(), {'from-other-device'});
    });
  });

  group('suppressions (connecté)', () {
    setUp(() async {
      await signIn(extraPrefs: {
        'shopping_list_u1': encodeList([item('a'), item('b')]),
        'shopping_list': encodeList([item('b')]),
      });
    });

    test('DELETE réussi → rien en attente', () async {
      final calls = <String>[];
      await http.runWithClient(() async {
        await ShoppingListService.removeFromShoppingList('a');
        await pumpEventQueue();
      }, () => MockClient((r) async {
            calls.add('${r.method} ${r.url.path}');
            return http.Response('{}', 200);
          }));
      expect(calls, ['DELETE /shopping-list/a']);
      expect((await ShoppingListService.loadShoppingList()).map((i) => i.id), ['b']);
      expect(await ShoppingListService.loadPendingDeletedIds(), isEmpty);
    });

    test('DELETE en échec → mémorisé, envoyé au push suivant puis oublié', () async {
      await http.runWithClient(() async {
        await ShoppingListService.clearShoppingList();
        await pumpEventQueue();
      }, () => MockClient((_) async => throw http.ClientException('offline')));

      expect(await ShoppingListService.loadShoppingList(), isEmpty);
      expect(await ShoppingListService.loadPendingDeletedIds(), {'a', 'b'});
      // Ni le compte ni la clé invité ne repousseront « a » ou « b »
      expect(await ShoppingListService.loadAllShoppingLists(), isEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(jsonDecode(prefs.getString('shopping_list')!), isEmpty);

      Map<String, dynamic>? pushBody;
      await http.runWithClient(ShoppingListService.pushToBackend, () => MockClient((r) async {
            pushBody = jsonDecode(r.body) as Map<String, dynamic>;
            return http.Response(jsonEncode({'success': true, 'data': {'deleted': 2}}), 200);
          }));
      expect((pushBody!['deleted_ids'] as List).toSet(), {'a', 'b'});
      expect(pushBody!['items'], isEmpty);
      expect(await ShoppingListService.loadPendingDeletedIds(), isEmpty);
    });

    test('ré-ajout après suppression hors ligne → suppression annulée', () async {
      await http.runWithClient(() async {
        await ShoppingListService.removeFromShoppingList('a');
        await pumpEventQueue();
      }, () => MockClient((_) async => http.Response('down', 503)));
      expect(await ShoppingListService.loadPendingDeletedIds(), {'a'});

      await ShoppingListService.addToShoppingList(item('a'));
      expect(await ShoppingListService.loadPendingDeletedIds(), isEmpty);
    });
  });

  test('invité : suppression locale seulement, aucun appel réseau', () async {
    signOutLocally(prefs: {'shopping_list': encodeList([item('a')])});
    var calls = 0;
    await http.runWithClient(() async {
      await ShoppingListService.removeFromShoppingList('a');
      await pumpEventQueue();
    }, () => MockClient((_) async {
          calls++;
          return http.Response('{}', 200);
        }));
    expect(calls, 0);
    expect(await ShoppingListService.loadShoppingList(), isEmpty);
    expect(await ShoppingListService.loadPendingDeletedIds(), isEmpty);
  });
}
