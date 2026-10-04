// Export Excel → import dans les 40 langues de l'app :
//  - un classeur exporté dans une langue se ré-importe dans la même langue
//    (toutes les colonnes reconnues, valeurs identiques) — avant, les
//    en-têtes en cyrillique, grec, arabe, hébreu, hindi, thaï et CJK étaient
//    vidés par la normalisation → aucune colonne reconnue, import impossible
//  - dates au format explicite yyyy-mm-dd (le format date système s'affichait
//    en m/d/yy dans Numbers, quelle que soit la région)
//  - colonnes assez larges pour l'en-tête traduit (CJK/hangul comptés double)

import 'dart:ui';

import 'package:excel/excel.dart' as xl;
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/spool_export_service.dart';
import 'package:nfc_filament/core/services/spool_import_service.dart';
import 'package:nfc_filament/features/inventory/presentation/stock_transfer_actions.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

final original = SpoolInventoryItem(
  id: 'orig-1',
  brand: 'Anycubic',
  material: 'PLA High Speed',
  colorName: 'Noir',
  colorRgb: 0xFF1A2B3C,
  price: 18.9,
  weight: 1000,
  remainingWeight: 640,
  addedDate: DateTime(2026, 9, 15),
  location: 'Étagère A',
  notes: 'Ouverte — séchée 6h',
  extruderTempMin: 190,
  extruderTempMax: 230,
  bedTempMin: 50,
  bedTempMax: 60,
  diameter: 1.75,
  batchNumber: 'AHPLBK-107',
);

List<int> exportIn(AppLocalizations l, List<SpoolInventoryItem> stock) =>
    SpoolExportService.buildWorkbook(
      stock: stock,
      shoppingList: const [],
      orderedIds: const {},
      usage: const [],
      currency: 'CHF',
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
    );

void main() {
  group('Aller-retour export → import, par langue', () {
    for (final locale in AppLocalizations.supportedLocales) {
      test(locale.toString(), () {
        final l = lookupAppLocalizations(locale);
        final labels = stockColumnLabels(l);
        final rows = SpoolImportService.parseFile(exportIn(l, [original]));

        final mapped = SpoolImportService.mapHeaders(rows.first, appLabels: labels);
        expect(mapped.values.toSet(), StockColumn.values.toSet(),
            reason: 'en-têtes non reconnus : ${rows.first}');

        final result = SpoolImportService.buildSpools(
          rows,
          existing: const [],
          appLabels: labels,
        );
        expect(result.spools, hasLength(1));
        final s = result.spools.single;
        expect(s.id, isNot(original.id));
        expect(s.brand, original.brand);
        expect(s.material, original.material);
        expect(s.colorName, original.colorName);
        expect(s.colorRgb, original.colorRgb);
        expect(s.weight, original.weight);
        expect(s.remainingWeight, original.remainingWeight);
        expect(s.price, original.price);
        expect(s.location, original.location);
        expect(s.notes, original.notes);
        expect(s.addedDate, original.addedDate);
        expect(s.extruderTempMax, original.extruderTempMax);
        expect(s.bedTempMin, original.bedTempMin);
        expect(s.diameter, original.diameter);
        expect(s.batchNumber, original.batchNumber);
      });
    }
  });

  test('normalizeHeader garde les lettres de toutes les écritures', () {
    expect(SpoolImportService.normalizeHeader('Начальный вес (г)'), 'начальный вес');
    expect(SpoolImportService.normalizeHeader('初期重量 (g)'), '初期重量');
    expect(SpoolImportService.normalizeHeader('Matériau'), 'materiau');
    expect(SpoolImportService.normalizeHeader('Restant (%)'), 'restant pct');
  });

  test('dates exportées au format yyyy-mm-dd', () {
    final l = lookupAppLocalizations(const Locale('fr'));
    final book = xl.Excel.decodeBytes(exportIn(l, [original]));
    final cell = book.tables[l.stock]!.cell(xl.CellIndex.indexByColumnRow(
      columnIndex: StockColumn.addedDate.index,
      rowIndex: 1,
    ));
    expect(cell.cellStyle?.numberFormat.formatCode, 'yyyy-mm-dd');
  });

  test("colonnes au moins aussi larges que l'en-tête traduit", () {
    expect(SpoolExportService.displayWidth('abc'), 3);
    expect(SpoolExportService.displayWidth('初期重量'), 8);
    expect(SpoolExportService.displayWidth('재고'), 4);
    for (final code in ['fr', 'de', 'ja', 'ko', 'ru']) {
      final l = lookupAppLocalizations(Locale(code));
      final sheet = xl.Excel.decodeBytes(exportIn(l, [original])).tables[l.stock]!;
      final header = sheet.row(0);
      for (var c = 0; c < header.length; c++) {
        final title = header[c]!.value.toString();
        expect(sheet.getColumnWidth(c),
            greaterThanOrEqualTo(SpoolExportService.displayWidth(title).clamp(0, 48)),
            reason: '$code : colonne « $title » trop étroite');
      }
    }
  });
}
