import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';
import 'package:nfc_filament/core/services/shopping_list_service.dart';
import 'package:nfc_filament/core/services/spool_export_service.dart';
import 'package:nfc_filament/core/services/spool_import_service.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/usage_history_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/utils/color_translator.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// Libellés de colonnes dans la langue courante (export ET reconnaissance
/// des en-têtes à l'import).
Map<StockColumn, String> stockColumnLabels(AppLocalizations l) => {
      StockColumn.brand: l.brand,
      StockColumn.material: l.stockSortMaterial,
      StockColumn.color: l.color,
      StockColumn.colorHex: l.exportColorHex,
      StockColumn.initialWeight: l.initialWeightG,
      StockColumn.remainingWeight: l.remainingWeightG,
      StockColumn.remainingPercent: l.exportRemainingPercent,
      StockColumn.price: l.price,
      StockColumn.pricePerKg: l.exportPricePerKg,
      StockColumn.location: l.location,
      StockColumn.notes: l.notes,
      StockColumn.addedDate: l.exportAddedDate,
      StockColumn.extruderTempMin: l.extruderTempMin,
      StockColumn.extruderTempMax: l.extruderTempMax,
      StockColumn.bedTempMin: l.bedTempMin,
      StockColumn.bedTempMax: l.bedTempMax,
      StockColumn.diameter: l.diameterMm,
      StockColumn.batchNumber: l.batchNumberLabel,
    };

/// Origine de la feuille de partage. Obligatoire quand elle s'affiche en
/// popover (iPad, écran intérieur d'un pliable en largeur « regular ») :
/// sans elle, iOS lève une exception au partage.
Rect shareOriginOf(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null || !box.hasSize) {
    final size = MediaQuery.sizeOf(context);
    return Rect.fromLTWH(size.width / 2, size.height / 2, 1, 1);
  }
  return box.localToGlobal(Offset.zero) & box.size;
}

void _snack(BuildContext context, String message, {bool error = false}) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red.shade700 : null,
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Exporte stock + liste de courses + consommation en .xlsx et ouvre la
/// feuille de partage (mail, Fichiers, Drive, WhatsApp…).
Future<void> exportStockToExcel(BuildContext context, {Rect? origin}) async {
  final l = AppLocalizations.of(context)!;
  final shareOrigin = origin ?? shareOriginOf(context);
  try {
    final stock = await SpoolStorageService.loadSpools();
    final shoppingList = await ShoppingListService.loadShoppingList();
    final orderedIds = await ShoppingListService.loadOrderedIds();
    final usage = await UsageHistoryService.loadEvents();
    final currency = await UserPreferencesService.getCurrency();
    final bytes = SpoolExportService.buildWorkbook(
      stock: stock,
      shoppingList: shoppingList,
      orderedIds: orderedIds,
      usage: usage,
      currency: currency,
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
    final file = await SpoolExportService.writeTempFile(bytes);
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(
            file.path,
            mimeType:
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          ),
        ],
        subject: l.exportShareSubject,
        sharePositionOrigin: shareOrigin,
      ),
    );
    unawaited(AnalyticsService.logEvent('stock_export', eventData: {
      'spools': stock.length,
      'format': 'xlsx',
    }));
  } catch (e, stack) {
    debugPrint('⚠️ Export Excel: $e\n$stack');
    if (context.mounted) _snack(context, l.exportFailed, error: true);
  }
}

/// Partage la liste de courses en texte simple (articles non commandés).
Future<void> shareShoppingListText(
  BuildContext context, {
  required List<SpoolInventoryItem> shoppingList,
  required Set<String> orderedIds,
  Rect? origin,
}) async {
  final l = AppLocalizations.of(context)!;
  final shareOrigin = origin ?? shareOriginOf(context);
  final text = SpoolExportService.buildShoppingListText(
    shoppingList: shoppingList,
    orderedIds: orderedIds,
    title: l.shoppingList,
    translateColor: (c) => translateColorName(context, c),
  );
  try {
    await SharePlus.instance.share(
      ShareParams(text: text, sharePositionOrigin: shareOrigin),
    );
    unawaited(AnalyticsService.logEvent('shopping_list_share', eventData: {
      'items': shoppingList.length,
    }));
  } catch (e) {
    debugPrint('⚠️ Partage liste: $e');
    if (context.mounted) _snack(context, l.exportFailed, error: true);
  }
}

/// Sélectionne un fichier CSV / Excel, montre un récapitulatif puis ajoute
/// les bobines au stock. Retourne le nombre de bobines importées.
Future<int> importSpoolsFromFile(BuildContext context) async {
  final l = AppLocalizations.of(context)!;
  const typeGroup = XTypeGroup(
    label: 'CSV / Excel',
    extensions: ['csv', 'xlsx', 'txt'],
    mimeTypes: [
      'text/csv',
      'text/comma-separated-values',
      'text/plain',
      'application/csv',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    ],
    uniformTypeIdentifiers: [
      'public.comma-separated-values-text',
      'public.plain-text',
      'org.openxmlformats.spreadsheetml.sheet',
    ],
  );

  final XFile? picked;
  try {
    picked = await openFile(acceptedTypeGroups: const [typeGroup]);
  } catch (e) {
    debugPrint('⚠️ Sélecteur de fichier: $e');
    if (context.mounted) _snack(context, l.importFailed, error: true);
    return 0;
  }
  if (picked == null) return 0;
  final bytes = await picked.readAsBytes();
  if (!context.mounted) return 0;
  return importSpoolsFromBytes(context, bytes);
}

/// Analyse puis importe (séparé du sélecteur pour les tests E2E).
Future<int> importSpoolsFromBytes(BuildContext context, List<int> bytes) async {
  final l = AppLocalizations.of(context)!;
  SpoolImportResult result;
  try {
    final rows = SpoolImportService.parseFile(bytes);
    result = SpoolImportService.buildSpools(
      rows,
      existing: await SpoolStorageService.loadSpools(),
      appLabels: stockColumnLabels(l),
    );
  } catch (e) {
    debugPrint('⚠️ Import: $e');
    if (context.mounted) _snack(context, l.importFailed, error: true);
    return 0;
  }
  if (!context.mounted) return 0;

  if (result.spools.isEmpty) {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.importConfirmTitle),
        content: Text(
          result.duplicates > 0
              ? l.importConfirmMessage(0, result.duplicates, result.skippedRows)
              : l.importNothingFound,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
          ),
        ],
      ),
    );
    return 0;
  }

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.importConfirmTitle),
      content: Text(
        l.importConfirmMessage(
          result.spools.length,
          result.duplicates,
          result.skippedRows,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const Key('importConfirmButton'),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.importAction),
        ),
      ],
    ),
  );
  if (confirmed != true) return 0;

  await SpoolStorageService.addSpools(result.spools);
  unawaited(AnalyticsService.logEvent('stock_import', eventData: {
    'spools': result.spools.length,
    'duplicates': result.duplicates,
    'skipped': result.skippedRows,
  }));
  if (context.mounted) _snack(context, l.importDone(result.spools.length));
  return result.spools.length;
}
