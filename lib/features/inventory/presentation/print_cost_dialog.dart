import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/models/spool_usage_event.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/usage_history_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/utils/color_translator.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

/// Calculateur de coût d'une impression : grammes utilisés × prix au gramme
/// de la bobine, avec option « Déduire du stock » (journalisée dans
/// l'historique de consommation, source `print`).
///
/// Retourne true si du filament a été déduit.
Future<bool> showPrintCostDialog(
  BuildContext context,
  SpoolInventoryItem spool,
) async {
  final currency = await UserPreferencesService.getCurrency();
  if (!context.mounted) return false;
  final deducted = await showDialog<double>(
    context: context,
    builder: (_) => _PrintCostDialog(spool: spool, currency: currency),
  );
  if (deducted == null || !context.mounted) return false;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        AppLocalizations.of(context)!
            .printCostDeducted(deducted.toStringAsFixed(0)),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
  return true;
}

class _PrintCostDialog extends StatefulWidget {
  const _PrintCostDialog({required this.spool, required this.currency});

  final SpoolInventoryItem spool;
  final String currency;

  @override
  State<_PrintCostDialog> createState() => _PrintCostDialogState();
}

class _PrintCostDialogState extends State<_PrintCostDialog> {
  final _gramsController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _gramsController.dispose();
    super.dispose();
  }

  double? get _grams =>
      double.tryParse(_gramsController.text.replaceAll(',', '.'));

  Future<void> _deduct(double grams) async {
    setState(() => _saving = true);
    final spool = widget.spool;
    final updated = spool.copyWith(
      remainingWeight: (spool.remainingWeight - grams).clamp(0, spool.weight).toDouble(),
    );
    await SpoolStorageService.updateSpool(
      spool.id,
      updated,
      usageSource: SpoolUsageEvent.sourcePrint,
    );
    if (mounted) Navigator.pop(context, grams);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final spool = widget.spool;
    final grams = _grams;
    final hasPrice = spool.price > 0 && spool.weight > 0;
    final tooMuch = grams != null && grams > spool.remainingWeight;
    final canDeduct = grams != null && grams > 0 && !tooMuch && !_saving;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l.printCostTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Color(0xFF000000 | spool.colorRgb),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${spool.brand} - ${spool.material}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        translateColorName(context, spool.colorName),
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                FormattedWeight(
                  weightInGrams: spool.remainingWeight,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('printCostGramsField'),
              controller: _gramsController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,1}')),
              ],
              decoration: InputDecoration(
                labelText: l.printCostGrams,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.scale),
                errorText: tooMuch ? l.exceedsRemainingWeight : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (!hasPrice)
              Text(
                l.printCostNoPrice,
                style: TextStyle(color: Colors.grey.shade500),
              )
            else ...[
              Text(
                l.printCostResult(
                  formatPriceWithCurrency(
                    UsageHistoryService.costForGrams(spool, grams ?? 0),
                    widget.currency,
                  ),
                ),
                key: const Key('printCostResult'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l.printCostPerKg(
                  formatPriceWithCurrency(
                    spool.price / spool.weight * 1000,
                    widget.currency,
                  ),
                ),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(MaterialLocalizations.of(context).closeButtonLabel),
        ),
        FilledButton.icon(
          key: const Key('printCostDeductButton'),
          onPressed: canDeduct ? () => _deduct(grams) : null,
          icon: const Icon(Icons.remove_circle_outline, size: 18),
          label: Text(l.printCostDeduct),
        ),
      ],
    );
  }
}
