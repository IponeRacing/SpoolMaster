import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_filament/core/services/usage_history_service.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

/// Section « Consommation » de la page Statistiques : 30 jours, mois en
/// cours, répartition par matériau et barres des 6 derniers mois.
class ConsumptionSection extends StatelessWidget {
  const ConsumptionSection({
    required this.summary,
    required this.currency,
    super.key,
  });

  final UsageSummary summary;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey.shade900 : Colors.white;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    final muted = isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    if (summary.isEmpty) {
      return Container(
        key: const Key('consumptionEmpty'),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Icon(Icons.show_chart, color: Colors.grey.shade500, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l.consumptionEmpty,
                style: TextStyle(color: muted, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    Widget kpi(String label, double grams, double cost, Color accent) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: muted)),
              const SizedBox(height: 6),
              FormattedWeight(
                weightInGrams: grams,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
              if (cost > 0)
                Text(
                  formatPriceWithCurrency(cost, currency),
                  style: TextStyle(fontSize: 13, color: muted),
                ),
            ],
          ),
        ),
      );
    }

    final maxMonthly = summary.monthly
        .map((e) => e.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final locale = Localizations.localeOf(context).toString();
    final totalMaterial30 =
        summary.gramsByMaterial.fold<double>(0, (a, e) => a + e.value);

    return Column(
      key: const Key('consumptionSection'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            kpi(l.consumptionLast30Days, summary.gramsLast30Days,
                summary.costLast30Days, Colors.teal.shade300),
            const SizedBox(width: 12),
            kpi(l.consumptionThisMonth, summary.gramsThisMonth,
                summary.costThisMonth, Colors.indigo.shade200),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.consumptionMonthly,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final m in summary.monthly)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: FractionallySizedBox(
                                  heightFactor: maxMonthly > 0
                                      ? (m.value / maxMonthly).clamp(0.02, 1.0)
                                      : 0.02,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade300,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                DateFormat.MMM(locale).format(m.key),
                                style: TextStyle(fontSize: 11, color: muted),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (summary.gramsByMaterial.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  l.consumptionByMaterial,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (final e in summary.gramsByMaterial.take(5))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 72,
                          child: Text(
                            e.key,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: totalMaterial30 > 0
                                  ? e.value / totalMaterial30
                                  : 0,
                              minHeight: 8,
                              backgroundColor: borderColor,
                              color: Colors.teal.shade300,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FormattedWeight(
                          weightInGrams: e.value,
                          style: TextStyle(fontSize: 12, color: muted),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
