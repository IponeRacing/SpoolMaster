// Fonctionnalités Stock 1.4.10 (widgets) :
//  - formulaire : emplacement / notes enregistrés ; l'édition conserve les
//    données NFC (lot, type détaillé, ids matériau) au lieu de les perdre
//  - calculateur de coût d'impression + « Déduire du stock »
//  - recherche texte
//  - politique d'orientation (portrait téléphone, libre grand écran)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/models/spool_usage_event.dart';
import 'package:nfc_filament/core/platform/orientation_policy.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/usage_history_service.dart';
import 'package:nfc_filament/features/inventory/presentation/print_cost_dialog.dart';
import 'package:nfc_filament/features/inventory/presentation/stock_search.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/manual_add_spool_page.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

SpoolInventoryItem nfcSpool() => SpoolInventoryItem(
      id: 'nfc-1',
      brand: 'Bambu Lab',
      material: 'PLA',
      colorName: 'Jade White',
      colorRgb: 0xFFF5F5F0,
      price: 25,
      weight: 1000,
      remainingWeight: 800,
      addedDate: DateTime(2026, 9),
      batchNumber: 'A00-W1',
      detailedType: 'PLA Basic',
      materialVariantId: 'A00-W1',
      materialId: 'GFA00',
      manufactureDate: DateTime(2026, 5, 2),
    );

Widget wrap(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      locale: const Locale('en'),
      home: child,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (call) async => null,
    );
  });

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('Formulaire bobine', () {
    testWidgets("l'édition conserve les données NFC et enregistre emplacement + notes",
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      SpoolInventoryItem? saved;
      await tester.pumpWidget(wrap(ManualAddSpoolPage(
        editSpool: nfcSpool(),
        onSave: (s) => saved = s,
      )));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const Key('spoolLocationField')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.byKey(const Key('spoolLocationField')), 'Dry box 2');
      await tester.enterText(find.byKey(const Key('spoolNotesField')), 'Dry 4h before use');
      await tester.scrollUntilVisible(
        find.byType(ElevatedButton),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(saved, isNotNull);
      expect(saved!.id, 'nfc-1');
      expect(saved!.location, 'Dry box 2');
      expect(saved!.notes, 'Dry 4h before use');
      // Données NFC : perdues avant la 1.4.10
      expect(saved!.batchNumber, 'A00-W1');
      expect(saved!.detailedType, 'PLA Basic');
      expect(saved!.materialVariantId, 'A00-W1');
      expect(saved!.materialId, 'GFA00');
      expect(saved!.manufactureDate, DateTime(2026, 5, 2));
    });

    testWidgets('emplacement vidé = null', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      SpoolInventoryItem? saved;
      await tester.pumpWidget(wrap(ManualAddSpoolPage(
        editSpool: nfcSpool().copyWith(location: 'Old shelf'),
        onSave: (s) => saved = s,
      )));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.byKey(const Key('spoolLocationField')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(find.byKey(const Key('spoolLocationField')), '   ');
      await tester.scrollUntilVisible(
        find.byType(ElevatedButton),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(saved!.location, isNull);
    });
  });

  group('Calculateur de coût', () {
    testWidgets('calcule le coût et déduit du stock (source print)', (tester) async {
      final spool = nfcSpool();
      await SpoolStorageService.addSpool(spool);

      var deducted = false;
      await tester.pumpWidget(wrap(Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async =>
                  deducted = await showPrintCostDialog(context, spool),
              child: const Text('open'),
            ),
          ),
        ),
      )));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('printCostGramsField')), '120');
      await tester.pumpAndSettle();
      // 25 CHF / 1000 g × 120 g = 3.00
      expect(find.textContaining('3.00'), findsOneWidget);

      await tester.tap(find.byKey(const Key('printCostDeductButton')));
      await tester.pumpAndSettle();

      expect(deducted, isTrue);
      final stored = (await SpoolStorageService.loadSpools()).single;
      expect(stored.remainingWeight, 680);
      final events = await UsageHistoryService.loadEvents();
      expect(events.single.grams, 120);
      expect(events.single.source, SpoolUsageEvent.sourcePrint);
      expect(events.single.cost, closeTo(3, 1e-9));
    });

    testWidgets('refuse plus que le poids restant', (tester) async {
      final spool = nfcSpool().copyWith(remainingWeight: 50);
      await tester.pumpWidget(wrap(Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showPrintCostDialog(context, spool),
            child: const Text('open'),
          ),
        ),
      )));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('printCostGramsField')), '80');
      await tester.pumpAndSettle();
      final button = tester.widget<FilledButton>(
        find.byKey(const Key('printCostDeductButton')),
      );
      expect(button.onPressed, isNull);
    });
  });

  group('Recherche', () {
    final s = nfcSpool().copyWith(location: 'Étagère A', notes: 'Pour pièces techniques');

    test('marque, matériau, emplacement, notes, sans accents ni casse', () {
      expect(matchesStockSearch(s, ''), isTrue);
      expect(matchesStockSearch(s, 'bambu'), isTrue);
      expect(matchesStockSearch(s, 'pla jade'), isTrue);
      expect(matchesStockSearch(s, 'etagere'), isTrue);
      expect(matchesStockSearch(s, 'PIÈCES'), isTrue);
      expect(matchesStockSearch(s, 'petg'), isFalse);
      expect(matchesStockSearch(s, 'bambu petg'), isFalse);
    });

    test('nom de couleur traduit', () {
      expect(matchesStockSearch(s, 'blanc', translatedColor: 'Blanc jade'), isTrue);
    });
  });

  group('Orientation', () {
    test('portrait sur téléphone, libre sur grand écran', () {
      const portraitOnly = [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
      // iPhone 17 Pro
      expect(OrientationPolicy.orientationsFor(const Size(402, 874)), portraitOnly);
      // Écran extérieur iPhone Duo (~466 pt)
      expect(OrientationPolicy.orientationsFor(const Size(466, 678)), portraitOnly);
      // Écran intérieur iPhone Duo (~626 × 890 pt), Pixel Fold ouvert, tablette
      expect(OrientationPolicy.orientationsFor(const Size(626, 890)), isEmpty);
      expect(OrientationPolicy.orientationsFor(const Size(841, 701)), isEmpty);
      expect(OrientationPolicy.orientationsFor(const Size(1280, 800)), isEmpty);
      // Taille inconnue (avant 1re frame) = comportement historique
      expect(OrientationPolicy.orientationsFor(Size.zero), portraitOnly);
    });
  });
}
