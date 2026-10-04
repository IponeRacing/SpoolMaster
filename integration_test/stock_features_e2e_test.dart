// Test E2E des fonctionnalités Stock 1.4.10 sur appareil réel / simulateur.
//
// Lancement (captures d'écran dans build/e2e_screenshots/) :
//   fvm flutter drive --driver=test_driver/integration_test.dart \
//     --target=integration_test/stock_features_e2e_test.dart \
//     --dart-define=E2E_MODE=true --dart-define=E2E_DEVICE=<nom> -d <device>
//
// Non destructif : les bobines de test portent la marque « E2ETest » et sont
// supprimées à la fin. Si un compte est connecté sur l'appareil, le test
// passe en mode lecture seule (aucune écriture → rien n'est synchronisé
// vers le compte réel en production).
//
// L'app est montée sans le SplashPage (ATT / consentement UMP = alertes
// système impossibles à piloter en test).

import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nfc_filament/core/platform/orientation_policy.dart';
import 'package:nfc_filament/core/services/shopping_list_service.dart';
import 'package:nfc_filament/core/services/spool_export_service.dart';
import 'package:nfc_filament/core/services/spool_import_service.dart';
import 'package:nfc_filament/core/services/usage_history_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/inventory/presentation/stock_transfer_actions.dart';
import 'package:nfc_filament/firebase_options.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:nfc_filament/main.dart';

const device = String.fromEnvironment('E2E_DEVICE', defaultValue: 'device');
const brand = 'E2ETest';

SpoolInventoryItem e2eSpool(
  String id, {
  required String material,
  required String color,
  required int rgb,
  double remaining = 1000,
}) =>
    SpoolInventoryItem(
      id: 'e2e_$id',
      brand: brand,
      material: material,
      colorName: color,
      colorRgb: rgb,
      price: 25,
      weight: 1000,
      remainingWeight: remaining,
      addedDate: DateTime.now(),
    );

/// pumpAndSettle ne se termine jamais avec une pub en chargement : on
/// avance l'horloge par pas fixes.
Future<void> pumpFor(WidgetTester tester, [int ms = 1500]) async {
  for (var t = 0; t < ms; t += 100) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> cleanup() async {
  for (final s in await SpoolStorageService.loadSpools()) {
    if (s.brand == brand) await SpoolStorageService.deleteSpool(s.id);
  }
  for (final s in await ShoppingListService.loadShoppingList()) {
    if (s.brand == brand) await ShoppingListService.removeFromShoppingList(s.id);
  }
  await UsageHistoryService.removeEventsWhere((e) => e.brand == brand);
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  var surfaceConverted = false;

  Future<void> shot(WidgetTester tester, String name) async {
    if (Platform.isAndroid && !surfaceConverted) {
      await binding.convertFlutterSurfaceToImage();
      surfaceConverted = true;
    }
    // Une frame après la conversion, sinon la capture attend indéfiniment.
    await tester.pump(const Duration(milliseconds: 100));
    await binding.takeScreenshot('${device}_$name');
  }

  testWidgets('Stock 1.4.10 : recherche, emplacement, coût, conso, import/export, écran large',
      (tester) async {
    await initializeDateFormatting();
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } catch (_) {}
    await configureDependencies();
    await OrientationPolicy.instance.start();

    final signedIn = await UserPreferencesService.isSignedIn();
    if (!signedIn) {
      await cleanup();
      await SpoolStorageService.addSpools([
        e2eSpool('pla1', material: 'PLA', color: 'White', rgb: 0xFFFFFFFF),
        e2eSpool('pla2', material: 'PLA', color: 'White', rgb: 0xFFFFFFFF, remaining: 640),
        e2eSpool('petg', material: 'PETG', color: 'Black', rgb: 0xFF000000, remaining: 900),
        e2eSpool('low', material: 'TPU', color: 'Red', rgb: 0xFFE53935, remaining: 80),
      ]);
    }

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: const Locale('fr'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: MainNavigationPage(key: mainNavigationKey),
    ));
    await pumpFor(tester, 2500);

    final l = await AppLocalizations.delegate.load(const Locale('fr'));
    final width = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    debugPrint('📐 [$device] largeur logique = $width');

    // --- Navigation adaptée à la largeur ---
    if (width >= 600) {
      expect(find.byKey(const Key('mainNavigationRail')), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsNothing);
    } else {
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byKey(const Key('mainNavigationRail')), findsNothing);
    }

    // Onglet NFC (page d'accueil) sur cet écran
    await shot(tester, '00_nfc');

    // --- Onglet Stock ---
    await tester.tap(find.byIcon(Icons.inventory_2));
    await pumpFor(tester);
    await shot(tester, '01_stock');

    // Menu export / import présent
    await tester.tap(find.byKey(const Key('stockMoreMenu')));
    await pumpFor(tester, 800);
    expect(find.text(l.exportExcel), findsOneWidget);
    expect(find.text(l.importSpools), findsOneWidget);
    await shot(tester, '02_menu');
    await tester.tapAt(const Offset(5, 300)); // ferme le menu
    await pumpFor(tester, 800);

    if (signedIn) {
      // Mode lecture seule : vérifie seulement la présence de l'UI.
      expect(find.byKey(const Key('stockSearchField')), findsWidgets);
      await tester.tap(find.byIcon(Icons.analytics));
      await pumpFor(tester);
      await shot(tester, '03_stats_readonly');
      debugPrint('ℹ️ [$device] compte connecté : test en lecture seule');
      return;
    }

    // --- Recherche ---
    await tester.enterText(find.byKey(const Key('stockSearchField')), 'e2etest petg');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await pumpFor(tester, 800);
    expect(find.text('$brand - PETG'), findsOneWidget);
    expect(find.text('$brand - PLA'), findsNothing);
    await shot(tester, '03_search');

    // --- Édition : emplacement + notes ---
    await tester.tap(find.text('$brand - PETG'));
    await pumpFor(tester);
    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(find.byKey(const Key('spoolLocationField')), 300,
        scrollable: scrollable);
    await tester.enterText(find.byKey(const Key('spoolLocationField')), 'Étagère E2E');
    await tester.enterText(find.byKey(const Key('spoolNotesField')), 'Sécher 4h avant usage');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await pumpFor(tester, 600);
    await shot(tester, '04_edit_form');
    await tester.scrollUntilVisible(find.text(l.spoolUpdated).last, 300, scrollable: scrollable);
    await tester.tap(find.widgetWithText(ElevatedButton, l.spoolUpdated));
    await pumpFor(tester);

    final petg = (await SpoolStorageService.loadSpools()).firstWhere((s) => s.id == 'e2e_petg');
    expect(petg.location, 'Étagère E2E');
    expect(petg.notes, 'Sécher 4h avant usage');

    // Recherche par emplacement (sans accent)
    await tester.enterText(find.byKey(const Key('stockSearchField')), 'etagere e2e');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await pumpFor(tester, 800);
    expect(find.text('Étagère E2E'), findsOneWidget);
    await shot(tester, '05_search_location');

    // --- Calculateur de coût + déduction ---
    await tester.tap(find.byKey(const Key('printCost_e2e_petg')));
    await pumpFor(tester, 800);
    await tester.enterText(find.byKey(const Key('printCostGramsField')), '100');
    await pumpFor(tester, 500);
    expect(find.byKey(const Key('printCostResult')), findsOneWidget);
    await shot(tester, '06_print_cost');
    await tester.tap(find.byKey(const Key('printCostDeductButton')));
    await pumpFor(tester);
    final afterPrint = (await SpoolStorageService.loadSpools()).firstWhere((s) => s.id == 'e2e_petg');
    expect(afterPrint.remainingWeight, 800);
    final events = await UsageHistoryService.loadEvents();
    expect(events.where((e) => e.brand == brand && e.grams == 100), hasLength(1));

    // Vide la recherche
    await tester.enterText(find.byKey(const Key('stockSearchField')), '');
    await pumpFor(tester, 800);

    // --- Import CSV (le sélecteur système n'est pas pilotable : on injecte
    //     les octets du fichier dans le même flux que le bouton Importer) ---
    final csv = utf8.encode(
      '﻿Marque;Matériau;Couleur;Poids (g);Restant;Prix;Emplacement\n'
      '$brand;ASA;Grey;1000;750;31,50;Boîte 3\n'
      '$brand;PA-CF;Black;500;;59,90;\n',
    );
    final stockContext = tester.element(find.byKey(const Key('stockList')));
    final importFuture = importSpoolsFromBytes(stockContext, csv);
    await pumpFor(tester, 800);
    expect(find.byKey(const Key('importConfirmButton')), findsOneWidget);
    await shot(tester, '07_import_confirm');
    await tester.tap(find.byKey(const Key('importConfirmButton')));
    await pumpFor(tester);
    expect(await importFuture, 2);
    final afterImport = await SpoolStorageService.loadSpools();
    final asa = afterImport.firstWhere((s) => s.brand == brand && s.material == 'ASA');
    expect(asa.remainingWeight, 750);
    expect(asa.price, 31.5);
    expect(asa.location, 'Boîte 3');

    // --- Export Excel : classeur généré et écrit sur l'appareil (la feuille
    //     de partage système n'est pas pilotable en test) ---
    final bytes = SpoolExportService.buildWorkbook(
      stock: afterImport,
      shoppingList: await ShoppingListService.loadShoppingList(),
      orderedIds: await ShoppingListService.loadOrderedIds(),
      usage: await UsageHistoryService.loadEvents(),
      labels: SpoolExportLabels(
        stockSheet: l.stock,
        shoppingSheet: l.shoppingList,
        consumptionSheet: l.consumptionTitle,
        columns: stockColumnLabels(l),
        ordered: l.exportOrdered,
        date: l.exportDate,
        grams: l.exportGrams,
        cost: l.exportCost,
        shoppingListTitle: l.shoppingList,
      ),
      currency: 'CHF',
    );
    final file = await SpoolExportService.writeTempFile(bytes);
    expect(file.existsSync(), isTrue);
    // Ré-import du fichier exporté : tout est en doublon (aller-retour fidèle)
    final roundTrip = SpoolImportService.buildSpools(
      SpoolImportService.parseFile(await file.readAsBytes()),
      existing: afterImport,
      appLabels: stockColumnLabels(l),
    );
    expect(roundTrip.spools, isEmpty);
    expect(roundTrip.duplicates, afterImport.length);

    // --- Statistiques : consommation + liste de courses (TPU à 8 %) ---
    await tester.tap(find.byIcon(Icons.analytics));
    await pumpFor(tester, 2000);
    expect(find.byKey(const Key('consumptionSection')), findsOneWidget);
    await shot(tester, '08_stats');
    await tester.scrollUntilVisible(
      find.byKey(const Key('shareShoppingListButton')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const Key('shareShoppingListButton')), findsOneWidget);
    await shot(tester, '09_shopping_list');

    // --- Nettoyage ---
    await cleanup();
    final remaining = await SpoolStorageService.loadSpools();
    expect(remaining.where((s) => s.brand == brand), isEmpty);
  });
}
