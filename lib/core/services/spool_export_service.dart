import 'dart:io';
import 'dart:math' as math;

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
    final stockRows = [for (final s in stock) _stockRow(s)]
      ..forEach(stockSheet.appendRow);
    _formatDates(stockSheet, StockColumn.addedDate.index, stockRows.length);
    _fitWidths(stockSheet, stockRows);

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
    final shopRows = [
      for (final s in shoppingList)
        <xl.CellValue?>[
          xl.TextCellValue(s.brand),
          xl.TextCellValue(s.material),
          xl.TextCellValue(s.colorName),
          xl.TextCellValue(colorHex(s.colorRgb)),
          xl.IntCellValue(remainingPercent(s)),
          // Cellule vide (null), pas une chaîne vide : certains outils la
          // ré-écrivent en <c t="inlineStr"></c>, illisible par le package excel.
          if (orderedIds.contains(s.id)) xl.TextCellValue('✓') else null,
        ],
    ]..forEach(shopSheet.appendRow);
    _fitWidths(shopSheet, shopRows);

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
      final usageRows = [
        for (final e in sorted)
          <xl.CellValue?>[
            xl.DateCellValue(year: e.date.year, month: e.date.month, day: e.date.day),
            xl.TextCellValue(e.brand),
            xl.TextCellValue(e.material),
            xl.TextCellValue(e.colorName),
            xl.DoubleCellValue(_round(e.grams, 1)),
            xl.DoubleCellValue(_round(e.cost, 2)),
          ],
      ]..forEach(usageSheet.appendRow);
      _formatDates(usageSheet, 0, usageRows.length);
      _fitWidths(usageSheet, usageRows);
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

  /// Dates au format ISO explicite. Le format date « système » par défaut
  /// (numFmtId 14) s'affiche en m/d/yy dans Numbers quelle que soit la région
  /// (« 9/15/26 » pour le 15 septembre sur un Mac fr_CH) ; yyyy-mm-dd est
  /// lisible sans ambiguïté dans les 40 langues et se ré-importe tel quel.
  static final _dateStyle = xl.CellStyle(
    numberFormat: xl.NumFormat.custom(formatCode: 'yyyy-mm-dd'),
  );

  static void _formatDates(xl.Sheet sheet, int column, int dataRows) {
    for (var row = 1; row <= dataRows; row++) {
      sheet
          .cell(xl.CellIndex.indexByColumnRow(columnIndex: column, rowIndex: row))
          .cellStyle = _dateStyle;
    }
  }

  /// Largeur de chaque colonne d'après le texte le plus long (en-tête traduit
  /// compris), bornée à 8..50. Avant : largeurs fixes calibrées sur le
  /// français → en-têtes coupés (« Poids initial (g », « Code couleu »),
  /// pire dans les langues aux libellés longs.
  static void _fitWidths(xl.Sheet sheet, List<List<xl.CellValue?>> rows) {
    final header = sheet.row(0);
    for (var c = 0; c < header.length; c++) {
      // +1 : l'en-tête est en gras, donc plus large à nombre égal de caractères.
      var longest = displayWidth(header[c]?.value?.toString() ?? '') + 1;
      for (final row in rows) {
        if (c < row.length && row[c] != null) {
          longest = math.max(longest, displayWidth(_displayText(row[c]!)));
        }
      }
      sheet.setColumnWidth(c, (longest + 2).clamp(8, 50).toDouble());
    }
  }

  static String _displayText(xl.CellValue v) => switch (v) {
        xl.DateCellValue() => 'yyyy-mm-dd',
        xl.DoubleCellValue(:final value) => value.toStringAsFixed(2),
        _ => v.toString(),
      };

  /// Largeur visuelle d'un texte, en caractères latins : les idéogrammes
  /// CJK, les kana et le hangul occupent environ deux colonnes.
  static int displayWidth(String text) {
    var width = 0;
    for (final r in text.runes) {
      final wide = (r >= 0x1100 && r <= 0x115F) ||
          (r >= 0x2E80 && r <= 0xA4CF) ||
          (r >= 0xAC00 && r <= 0xD7A3) ||
          (r >= 0xF900 && r <= 0xFAFF) ||
          (r >= 0xFE30 && r <= 0xFE4F) ||
          (r >= 0xFF00 && r <= 0xFF60) ||
          (r >= 0xFFE0 && r <= 0xFFE6);
      width += wide ? 2 : 1;
    }
    return width;
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
