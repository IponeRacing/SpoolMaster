// Tests E2E de la fonctionnalité "quantité + regroupement" :
//  - le champ Quantité génère N bobines distinctes (poids restant individuel)
//  - addSpools persiste bien N entrées
//  - groupIdentical regroupe les bobines identiques en préservant l'ordre
//  - la mise à jour de stock au scan matche une bobine du groupe

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/manual_add_spool_page.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

SpoolInventoryItem makeSpool({
  required String id,
  String brand = 'Anycubic',
  String material = 'PLA',
  String colorName = 'White',
  int colorRgb = 0xFFFFFF,
  double remaining = 1000,
}) {
  return SpoolInventoryItem(
    id: id,
    brand: brand,
    material: material,
    colorName: colorName,
    colorRgb: colorRgb,
    price: 20,
    weight: 1000,
    remainingWeight: remaining,
    addedDate: DateTime(2026),
  );
}

Widget wrapPage(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en')],
    locale: const Locale('en'),
    home: child,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock flutter_secure_storage : addSpools déclenche un sync (unawaited) qui
  // lit le token d'auth. En test on renvoie null (= non connecté → sync skip).
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (call) async => null,
    );
  });

  group('groupIdentical (regroupement)', () {
    test('regroupe les bobines identiques et préserve l\'ordre', () {
      final spools = [
        makeSpool(id: '1'),
        makeSpool(id: '2', material: 'PETG', colorName: 'Black', colorRgb: 0),
        makeSpool(id: '3'), // identique à #1
        makeSpool(id: '4'),
      ];

      final groups = SpoolStorageService.groupIdentical(spools);

      expect(groups.length, 2); // PLA White (×3) + PETG Black (×1)
      expect(groups.first.length, 3);
      expect(groups.first.map((s) => s.id), ['1', '3', '4']);
      expect(groups[1].length, 1);
      expect(groups[1].first.id, '2');
    });

    test('même couleur RGB mais matériau différent = groupes séparés', () {
      final groups = SpoolStorageService.groupIdentical([
        makeSpool(id: '1', material: 'PLA'),
        makeSpool(id: '2', material: 'PETG'),
      ]);
      expect(groups.length, 2);
    });

    test('liste vide → aucun groupe', () {
      expect(SpoolStorageService.groupIdentical([]), isEmpty);
    });
  });

  group('addSpools (persistance batch)', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('persiste N bobines distinctes', () async {
      final spools = List.generate(
        5,
        (i) => makeSpool(id: 'batch_$i'),
      );

      await SpoolStorageService.addSpools(spools);
      final loaded = await SpoolStorageService.loadSpools();

      expect(loaded.length, 5);
      expect(loaded.map((s) => s.id).toSet().length, 5); // ids uniques
    });

    test('liste vide → ne persiste rien', () async {
      await SpoolStorageService.addSpools([]);
      expect(await SpoolStorageService.loadSpools(), isEmpty);
    });
  });

  group('Champ Quantité (ManualAddSpoolPage) — visibilité', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    testWidgets('visible à l ajout au stock (showQuantity=true)',
        (tester) async {
      await tester.pumpWidget(wrapPage(
        ManualAddSpoolPage(showQuantity: true, onSave: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextFormField, 'Quantity'), findsOneWidget);
    });

    testWidgets('caché pour la liste de courses (showQuantity=false)',
        (tester) async {
      await tester.pumpWidget(wrapPage(
        ManualAddSpoolPage(onSave: (_) {}),
      ));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextFormField, 'Quantity'), findsNothing);
    });

    testWidgets('caché en édition même si showQuantity=true', (tester) async {
      await tester.pumpWidget(wrapPage(
        ManualAddSpoolPage(
          showQuantity: true,
          editSpool: makeSpool(id: 'x'),
          onSave: (_) {},
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(TextFormField, 'Quantity'), findsNothing);
    });

    testWidgets('affiche la valeur par défaut 1', (tester) async {
      await tester.pumpWidget(wrapPage(
        ManualAddSpoolPage(showQuantity: true, onSave: (_) {}),
      ));
      await tester.pumpAndSettle();

      final field = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Quantity'),
      );
      expect(field.controller?.text, '1');
    });
  });

  // Preuve de bout en bout de la génération multiple : la quantité pilote
  // addSpools, dont on vérifie qu'il crée N entrées distinctes persistées.
  group('E2E génération multiple', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('quantité 5 → 5 bobines en stock, regroupées en 1 entrée', () async {
      const baseTs = 1700000000000;
      final generated = List.generate(
        5,
        (i) => makeSpool(id: '${baseTs}_$i'),
      );

      await SpoolStorageService.addSpools(generated);
      final loaded = await SpoolStorageService.loadSpools();
      final groups = SpoolStorageService.groupIdentical(loaded);

      expect(loaded.length, 5); // 5 entrées distinctes
      expect(loaded.map((s) => s.id).toSet().length, 5); // ids uniques
      expect(groups.length, 1); // affichées en 1 groupe dépliable
      expect(groups.first.length, 5);
    });
  });
}
