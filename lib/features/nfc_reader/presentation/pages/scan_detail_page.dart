import 'package:flutter/material.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/scan_history.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_writer_page.dart';

class ScanDetailPage extends StatelessWidget {
  final ScanHistory scan;

  const ScanDetailPage({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR');

    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.scanDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToWriter(context),
            tooltip: localizations.reuseThisData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header card with icon
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.anycubicRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.nfc,
                        color: AppTheme.anycubicRed,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.scannedOn(dateFormat.format(scan.timestamp)),
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Bobbin data card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.bobbinInformation,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    if (scan.bobbinData.brand != null) ...[
                      _DetailRow(
                        icon: Icons.business,
                        label: localizations.brand,
                        value: scan.bobbinData.brand!,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _DetailRow(
                      icon: Icons.category,
                      label: localizations.filamentType,
                      value: scan.bobbinData.filamentType,
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(
                      icon: Icons.palette,
                      label: localizations.color,
                      value: scan.bobbinData.color,
                    ),
                    const SizedBox(height: 16),
                    _DetailRowWidget(
                      icon: Icons.scale,
                      label: localizations.weight,
                      valueWidget: FormattedWeight(
                        weightInGrams: scan.bobbinData.weightGrams,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (scan.bobbinData.remainingWeight != null) ...[
                      const SizedBox(height: 16),
                      _DetailRowWidget(
                        icon: Icons.balance,
                        label: localizations.remainingWeightG,
                        valueWidget: FormattedWeight(
                          weightInGrams: scan.bobbinData.remainingWeight!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    if (scan.bobbinData.price != null) ...[
                      const SizedBox(height: 16),
                      _DetailRowWidget(
                        icon: Icons.attach_money,
                        label: localizations.price,
                        valueWidget: FormattedPrice(
                          price: scan.bobbinData.price!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    if (scan.bobbinData.diameter != null) ...[
                      const SizedBox(height: 16),
                      _DetailRowWidget(
                        icon: Icons.straighten,
                        label: localizations.diameter,
                        valueWidget: FormattedLength(
                          lengthInMm: scan.bobbinData.diameter!,
                          decimals: 2,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    if (scan.bobbinData.spoolLength != null) ...[
                      const SizedBox(height: 16),
                      _DetailRow(
                        icon: Icons.animation,
                        label: localizations.spoolLength,
                        value: '${scan.bobbinData.spoolLength} m',
                      ),
                    ],
                    if (scan.bobbinData.manufactureDate != null) ...[
                      const SizedBox(height: 16),
                      _DetailRow(
                        icon: Icons.calendar_today,
                        label: localizations.manufacturingDate,
                        value: DateFormat(
                          'dd/MM/yyyy',
                        ).format(scan.bobbinData.manufactureDate!),
                      ),
                    ],
                    if (scan.bobbinData.batchNumber != null) ...[
                      const SizedBox(height: 16),
                      _DetailRow(
                        icon: Icons.qr_code,
                        label: localizations.batchNumber,
                        value: scan.bobbinData.batchNumber!,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Printer settings card
            if (scan.bobbinData.extruderTempMin != null ||
                scan.bobbinData.extruderTempMax != null ||
                scan.bobbinData.bedTempMin != null ||
                scan.bobbinData.bedTempMax != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.printerSettings,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      if (scan.bobbinData.extruderTempMin != null) ...[
                        _DetailRowWidget(
                          icon: Icons.thermostat,
                          label: localizations.extruderTempMin,
                          valueWidget: FormattedTemperature(
                            temperatureInCelsius: scan.bobbinData.extruderTempMin!.toDouble(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (scan.bobbinData.extruderTempMax != null) ...[
                        _DetailRowWidget(
                          icon: Icons.thermostat,
                          label: localizations.extruderTempMax,
                          valueWidget: FormattedTemperature(
                            temperatureInCelsius: scan.bobbinData.extruderTempMax!.toDouble(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (scan.bobbinData.bedTempMin != null) ...[
                        _DetailRowWidget(
                          icon: Icons.bed,
                          label: localizations.bedTempMin,
                          valueWidget: FormattedTemperature(
                            temperatureInCelsius: scan.bobbinData.bedTempMin!.toDouble(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (scan.bobbinData.bedTempMax != null) ...[
                        _DetailRowWidget(
                          icon: Icons.bed,
                          label: localizations.bedTempMax,
                          valueWidget: FormattedTemperature(
                            temperatureInCelsius: scan.bobbinData.bedTempMax!.toDouble(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Scan metadata card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.scanMetadata,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    _DetailRow(
                      icon: Icons.fingerprint,
                      label: localizations.scanId,
                      value: scan.id,
                    ),
                    const SizedBox(height: 16),
                    _DetailRow(
                      icon: Icons.access_time,
                      label: localizations.dateAndTime,
                      value: DateFormat(
                        'dd/MM/yyyy HH:mm:ss',
                      ).format(scan.timestamp),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action button
            ElevatedButton.icon(
              onPressed: () => _navigateToWriter(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.anycubicRed,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.edit),
              label: Text(
                localizations.reuseThisData,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToWriter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NfcWriterPage(prefilledData: scan.bobbinData),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.anycubicRed),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRowWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget valueWidget;

  const _DetailRowWidget({
    required this.icon,
    required this.label,
    required this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.anycubicRed),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              valueWidget,
            ],
          ),
        ),
      ],
    );
  }
}
