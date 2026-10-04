import 'dart:io';

import 'package:excel/excel.dart' as xl;
import 'package:intl/intl.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/models/spool_usage_event.dart';
import 'package:path_provider/path_provider.dart';

/// Colonnes de la feuille Stock. L'ordre est aussi le format attendu par
/// l'import (SpoolImportService) : ne pas réordonner sans adapter l'import.
enum StockColumn {
  brand,
  material,
  color,
  colorHex,
  initialWeight,
  remainingWeight,
  remainingPercent,
  price,
  pricePerKg,
  location,
  notes,
  addedDate,
  extruderTempMin,
  extruderTempMax,
  bedTempMin,
  bedTempMax,
  diameter,
  batchNumber,
}

/// Libellés localisés de l'export (construits depuis AppLocalizations par
/// l'appelant : le service reste pur et testable sans BuildContext).
class SpoolExportLabels {
  const SpoolExportLabels({
    required this.stockSheet,
    required this.shoppingSheet,
    required this.consumptionSheet,
    required this.columns,
    required this.ordered,
    required this.date,
    required this.grams,
    required this.cost,
    required this.shoppingListTitle,
  });

  final String stockSheet;
  final String shoppingSheet;
  final String consumptionSheet;
  final Map<StockColumn, String> columns;
  final String ordered;
  final String date;
  final String grams;
  final String cost;
  final String shoppingListTitle;
}

class SpoolExportService {
  /// Classeur Excel : feuille Stock (une ligne par bobine), Liste de courses,
  /// Consommation (si historique non vide).
  static List<int> buildWorkbook({
    required List<SpoolInventoryItem> stock,
    required List<SpoolInventoryItem> shoppingList,
    required Set<String> orderedIds,
    required List<SpoolUsageEvent> usage,
    required SpoolExportLabels labels,
    required String currency,
  }) {
    final excel = xl.Excel.createExcel();
    final defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    final stockName = _sheetName(labels.stockSheet, 'Stock');
    excel.rename(defaultSheet, stockName);

    // --- Stock ---
    final stockSheet = excel[stockName];
    _header(stockSheet, [
      for (final c in StockColumn.values) _columnTitle(labels, c, currency),
    ]);
    for (final s in stock) {
      stockSheet.appendRow(_stockRow(s));
    }
    _widths(stockSheet, [16, 12, 16, 10, 12, 12, 10, 10, 10, 18, 28, 12, 10, 10, 10, 10, 10, 16]);

    // --- Liste de courses ---
    final shopName = _sheetName(labels.shoppingSheet, 'Shopping');
    final shopSheet = excel[shopName];
    _header(shopSheet, [
      labels.columns[StockColumn.brand]!,
      labels.columns[StockColumn.material]!,
      labels.columns[StockColumn.color]!,
      labels.columns[StockColumn.colorHex]!,
      labels.columns[StockColumn.remainingPercent]!,
      labels.ordered,
    ]);
    for (final s in shoppingList) {
      shopSheet.appendRow([
        xl.TextCellValue(s.brand),
        xl.TextCellValue(s.material),
        xl.TextCellValue(s.colorName),
        xl.TextCellValue(colorHex(s.colorRgb)),
        xl.IntCellValue(remainingPercent(s)),
        xl.TextCellValue(orderedIds.contains(s.id) ? '✓' : ''),
      ]);
    }
    _widths(shopSheet, [16, 12, 16, 10, 10, 10]);

    // --- Consommation ---
    if (usage.isNotEmpty) {
      final usageName = _sheetName(labels.consumptionSheet, 'Usage');
      final usageSheet = excel[usageName];
      _header(usageSheet, [
        labels.date,
        labels.columns[StockColumn.brand]!,
        labels.columns[StockColumn.material]!,
        labels.columns[StockColumn.color]!,
        labels.grams,
        '${labels.cost} ($currency)',
      ]);
      final sorted = [...usage]..sort((a, b) => b.date.compareTo(a.date));
      for (final e in sorted) {
        usageSheet.appendRow([
          xl.DateCellValue(year: e.date.year, month: e.date.month, day: e.date.day),
          xl.TextCellValue(e.brand),
          xl.TextCellValue(e.material),
          xl.TextCellValue(e.colorName),
          xl.DoubleCellValue(_round(e.grams, 1)),
          xl.DoubleCellValue(_round(e.cost, 2)),
        ]);
      }
      _widths(usageSheet, [12, 16, 12, 16, 10, 10]);
    }

    excel.setDefaultSheet(stockName);
    return excel.save() ?? <int>[];
  }

  static List<xl.CellValue?> _stockRow(SpoolInventoryItem s) {
    xl.CellValue? intOrNull(int? v) => v == null ? null : xl.IntCellValue(v);
    xl.CellValue? textOrNull(String? v) =>
        (v == null || v.trim().isEmpty) ? null : xl.TextCellValue(v);
    final values = <StockColumn, xl.CellValue?>{
      StockColumn.brand: xl.TextCellValue(s.brand),
      StockColumn.material: xl.TextCellValue(s.material),
      StockColumn.color: xl.TextCellValue(s.colorName),
      StockColumn.colorHex: xl.TextCellValue(colorHex(s.colorRgb)),
      StockColumn.initialWeight: xl.DoubleCellValue(_round(s.weight, 1)),
      StockColumn.remainingWeight: xl.DoubleCellValue(_round(s.remainingWeight, 1)),
      StockColumn.remainingPercent: xl.IntCellValue(remainingPercent(s)),
      StockColumn.price: xl.DoubleCellValue(_round(s.price, 2)),
      StockColumn.pricePerKg: s.weight > 0 && s.price > 0
          ? xl.DoubleCellValue(_round(s.price / s.weight * 1000, 2))
          : null,
      StockColumn.location: textOrNull(s.location),
      StockColumn.notes: textOrNull(s.notes),
      StockColumn.addedDate: xl.DateCellValue(
        year: s.addedDate.year,
        month: s.addedDate.month,
        day: s.addedDate.day,
      ),
      StockColumn.extruderTempMin: intOrNull(s.extruderTempMin),
      StockColumn.extruderTempMax: intOrNull(s.extruderTempMax),
      StockColumn.bedTempMin: intOrNull(s.bedTempMin),
      StockColumn.bedTempMax: intOrNull(s.bedTempMax),
      StockColumn.diameter: s.diameter == null ? null : xl.DoubleCellValue(s.diameter!),
      StockColumn.batchNumber: textOrNull(s.batchNumber),
    };
    return [for (final c in StockColumn.values) values[c]];
  }

  static String _columnTitle(
    SpoolExportLabels labels,
    StockColumn c,
    String currency,
  ) {
    final base = labels.columns[c]!;
    return switch (c) {
      StockColumn.initialWeight || StockColumn.remainingWeight => '$base (g)',
      StockColumn.price || StockColumn.pricePerKg => '$base ($currency)',
      _ => base,
    };
  }

  static void _header(xl.Sheet sheet, List<String> titles) {
    sheet.appendRow([for (final t in titles) xl.TextCellValue(t)]);
    final style = xl.CellStyle(
      bold: true,
      backgroundColorHex: xl.ExcelColor.fromHexString('#FFE0E0E0'),
    );
    for (var i = 0; i < titles.length; i++) {
      sheet
          .cell(xl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          .cellStyle = style;
    }
  }

  static void _widths(xl.Sheet sheet, List<double> widths) {
    for (var i = 0; i < widths.length; i++) {
      sheet.setColumnWidth(i, widths[i]);
    }
  }

  /// Nom de feuille valide Excel (31 car. max, sans []:*?/\).
  static String _sheetName(String name, String fallback) {
    final cleaned = name.replaceAll(RegExp(r'[\[\]:*?/\\]'), ' ').trim();
    if (cleaned.isEmpty) return fallback;
    return cleaned.length > 31 ? cleaned.substring(0, 31) : cleaned;
  }

  static double _round(double v, int decimals) =>
      double.parse(v.toStringAsFixed(decimals));

  static String colorHex(int rgb) =>
      '#${(rgb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  static int remainingPercent(SpoolInventoryItem s) => s.weight > 0
      ? (s.remainingWeight / s.weight * 100).clamp(0, 100).round()
      : 0;

  /// Liste de courses en texte simple (WhatsApp, Messages, notes…).
  /// Les bobines identiques (marque + matériau + couleur) sont regroupées
  /// en « 2× … ». Les articles déjà commandés sont exclus.
  static String buildShoppingListText({
    required List<SpoolInventoryItem> shoppingList,
    required Set<String> orderedIds,
    required String title,
    String Function(String colorName)? translateColor,
  }) {
    final counts = <String, int>{};
    final order = <String>[];
    for (final s in shoppingList) {
      if (orderedIds.contains(s.id)) continue;
      final color = translateColor?.call(s.colorName) ?? s.colorName;
      final line = [s.brand, s.material, color]
          .where((p) => p.trim().isNotEmpty)
          .join(' · ');
      if (!counts.containsKey(line)) order.add(line);
      counts[line] = (counts[line] ?? 0) + 1;
    }
    final buffer = StringBuffer('$title\n');
    for (final line in order) {
      final n = counts[line]!;
      buffer.writeln(n > 1 ? '☐ $n× $line' : '☐ $line');
    }
    return buffer.toString().trimRight();
  }

  /// Écrit le classeur dans le dossier temporaire et retourne le fichier
  /// (partagé ensuite via la feuille de partage système).
  static Future<File> writeTempFile(List<int> bytes, {DateTime? now}) async {
    final dir = await getTemporaryDirectory();
    final stamp = DateFormat('yyyy-MM-dd').format(now ?? DateTime.now());
    final file = File('${dir.path}/SpoolMaster_$stamp.xlsx');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
