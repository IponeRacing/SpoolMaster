import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/core/utils/color_translator.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_bloc.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

/// Page for updating stock by scanning existing NFC spools
class NfcStockUpdatePage extends StatelessWidget {
  const NfcStockUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<NfcReaderBloc>()
            ..add(const CheckNfcAvailabilityEvent()),
      child: const _NfcStockUpdateView(),
    );
  }
}

class _NfcStockUpdateView extends StatelessWidget {
  const _NfcStockUpdateView();

  void _startScanWithMode(BuildContext context, String mode) {
    context.read<NfcReaderBloc>().add(
      ReadBobbinDataEvent(overrideMode: mode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isIOS = Platform.isIOS;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.updateStock,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<NfcReaderBloc, NfcReaderState>(
        listener: (context, state) {
          if (state is BobbinDataReadSuccess) {
            _showUpdateDialog(context, state.bobbinData);
          } else if (state is BobbinDataReadSuccessWithFallback) {
            _showUpdateDialog(context, state.bobbinData);
          }
        },
        child: BlocBuilder<NfcReaderBloc, NfcReaderState>(
          builder: (context, state) {
            if (state is NfcReaderLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      l10n.approachNfcChip,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.scanSpoolToUpdate,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is NfcNotAvailable) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.nfc_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.back),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is NfcReaderFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.anycubicRed,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(l10n.cancel),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () => _showModeSelectionDialog(context),
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            // Success state - show loading while dialog is displayed
            if (state is BobbinDataReadSuccess) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.scanningNfc,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            // État initial : sélecteur de protocole
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.nfc_rounded,
                      size: 64,
                      color: AppTheme.anycubicRed,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.fallbackChooseMode,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.scanSpoolToUpdate,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _autoDetectCard(context, l10n),
                    const SizedBox(height: 20),
                    _protocolCard(context, 'Anycubic', 'anycubic', enabled: true),
                    const SizedBox(height: 12),
                    _protocolCard(context, 'Bambu Lab', 'bambu', enabled: !isIOS),
                    const SizedBox(height: 12),
                    _protocolCard(context, 'Prusa', 'prusa', enabled: true),
                    const SizedBox(height: 12),
                    _protocolCard(context, 'Creality', 'creality', enabled: !isIOS),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Carte "Détection auto — toutes marques" : couvre aussi les standards
  /// ouverts (Elegoo, OpenSpool, OpenTag3D) sans choisir de protocole.
  Widget _autoDetectCard(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => context
            .read<NfcReaderBloc>()
            .add(const ReadBobbinDataAutoDetectEvent()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.anycubicRed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, size: 24),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    l10n.autoDetectAllBrands,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.autoDetectAllBrandsDesc,
              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _protocolCard(BuildContext context, String label, String mode, {required bool enabled}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? () => _startScanWithMode(context, mode) : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.nfc_rounded, size: 24),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
            if (!enabled) ...[
              const SizedBox(width: 8),
              Text(
                '(Android)',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showModeSelectionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isIOS = Platform.isIOS;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.nfc_rounded, size: 40, color: AppTheme.anycubicRed),
        title: Text(l10n.fallbackChooseMode),
        content: Text(
          l10n.fallbackChooseModeSubtitle,
          style: Theme.of(dialogContext).textTheme.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          _modeButton(context, dialogContext, 'Anycubic', 'anycubic', enabled: true),
          _modeButton(context, dialogContext, 'Bambu Lab', 'bambu', enabled: !isIOS),
          _modeButton(context, dialogContext, 'Prusa', 'prusa', enabled: true),
          _modeButton(context, dialogContext, 'Creality', 'creality', enabled: !isIOS),
        ],
      ),
    );
  }

  Widget _modeButton(BuildContext pageContext, BuildContext dialogContext, String label, String mode, {required bool enabled}) {
    return TextButton(
      onPressed: enabled
          ? () {
              Navigator.pop(dialogContext);
              pageContext.read<NfcReaderBloc>().add(
                ReadBobbinDataEvent(overrideMode: mode),
              );
            }
          : null,
      child: Text(
        label,
        style: TextStyle(
          color: enabled ? null : Colors.grey,
        ),
      ),
    );
  }

  Future<void> _showUpdateDialog(BuildContext context, BobbinData bobbinData) async {
    debugPrint('🔍 [DIALOG] Loading spools from storage...');
    debugPrint('🔍 [DIALOG] Looking for: ${bobbinData.brand} - ${bobbinData.filamentType} - ${bobbinData.color}');

    // Find the matching spool in inventory
    final spools = await SpoolStorageService.loadSpools();
    debugPrint('🔍 [DIALOG] Found ${spools.length} spools in storage');

    // Try to match by brand+material+color
    SpoolInventoryItem? matchingSpool;

    // Normalize strings for comparison
    final scannedBrand = (bobbinData.brand ?? 'Generic').toLowerCase().trim();
    final scannedMaterial = bobbinData.filamentType.toLowerCase().trim();
    final scannedColor = bobbinData.color.toLowerCase().trim();

    debugPrint('🔍 [DIALOG] Normalized scan: "$scannedBrand" - "$scannedMaterial" - "$scannedColor"');

    for (final spool in spools) {
      final spoolBrand = spool.brand.toLowerCase().trim();
      final spoolMaterial = spool.material.toLowerCase().trim();
      final spoolColor = spool.colorName.toLowerCase().trim();

      debugPrint('🔍 [DIALOG] Comparing with: "$spoolBrand" - "$spoolMaterial" - "$spoolColor"');

      // Match by brand, material and color (case-insensitive, trimmed)
      if (spoolBrand == scannedBrand &&
          spoolMaterial == scannedMaterial &&
          spoolColor == scannedColor) {
        matchingSpool = spool;
        debugPrint('✅ [DIALOG] Match found!');
        break;
      }
    }

    if (!context.mounted) {
      debugPrint('❌ [DIALOG] Context not mounted, aborting');
      return;
    }

    if (matchingSpool == null) {
      debugPrint('❌ [DIALOG] No matching spool found, showing error dialog');
      // No matching spool found - show dialog to add it first
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.spoolNotFound),
          content: Text(AppLocalizations.of(context)!.addSpoolFirstMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        ),
      );
      if (context.mounted) {
        Navigator.pop(context);
      }
      return;
    }

    debugPrint('✅ [DIALOG] Showing usage dialog for spool: ${matchingSpool.brand}');
    // Show dialog to enter weight or length used
    await _showUsageDialog(context, matchingSpool);
  }

  Future<void> _showUsageDialog(
    BuildContext context,
    SpoolInventoryItem spool,
  ) async {
    final weightController = TextEditingController();
    final lengthController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var useWeight = true;

    if (!context.mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.updateStock),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${spool.brand} - ${spool.material}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translateColorName(context, spool.colorName),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.enterWeightOrLength,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  RadioGroup<bool>(
                    groupValue: useWeight,
                    onChanged: (value) {
                      setState(() {
                        useWeight = value ?? true;
                        if (useWeight) {
                          lengthController.clear();
                        } else {
                          weightController.clear();
                        }
                      });
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                title: Text(AppLocalizations.of(context)!.weightUsed),
                                value: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        if (useWeight)
                          TextFormField(
                            controller: weightController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.weightUsedG,
                              border: const OutlineInputBorder(),
                              suffixText: 'g',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}'),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.enterWeight;
                              }
                              final weight = double.tryParse(value);
                              if (weight == null) {
                                return AppLocalizations.of(context)!.enterValidWeight;
                              }
                              if (weight > spool.remainingWeight) {
                                return 'Cannot exceed remaining weight';
                              }
                              return null;
                            },
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                title: Text(AppLocalizations.of(context)!.lengthUsed),
                                value: false,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!useWeight)
                    TextFormField(
                      controller: lengthController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.lengthUsedM,
                        border: const OutlineInputBorder(),
                        suffixText: 'm',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter length';
                        }
                        final length = double.tryParse(value);
                        if (length == null) {
                          return 'Please enter valid length';
                        }
                        // Check if spool length is available for ratio calculation
                        if (spool.spoolLength == null) {
                          return 'Spool length not set - cannot convert';
                        }
                        // Convert to weight using spool's specific ratio (g/m)
                        final ratio = spool.weight / spool.spoolLength!;
                        final weight = length * ratio;
                        if (weight > spool.remainingWeight) {
                          return 'Exceeds remaining weight';
                        }
                        return null;
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, true);
                }
              },
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );

    if ((result ?? false) && context.mounted) {
      // Calculate new remaining weight
      double weightUsed = 0;

      if (useWeight) {
        weightUsed = double.tryParse(weightController.text) ?? 0.0;
      } else {
        final lengthUsed = double.tryParse(lengthController.text) ?? 0.0;
        // Use spool's specific ratio: weight/length (g/m)
        final ratio = spool.weight / spool.spoolLength!;
        weightUsed = lengthUsed * ratio;
      }

      final newRemainingWeight = (spool.remainingWeight - weightUsed).clamp(0.0, spool.weight);

      // Update the spool
      final updatedSpool = spool.copyWith(
        remainingWeight: newRemainingWeight,
      );

      await SpoolStorageService.updateSpool(spool.id, updatedSpool);

      // Log stock update to backend
      unawaited(AnalyticsService.logNfcScan(
        scanType: 'scan_update_stock',
        brand: spool.brand,
        material: spool.material,
        color: spool.colorName,
        success: true,
      ));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.stockUpdated),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    }

    // Dispose controllers to prevent memory leak
    weightController.dispose();
    lengthController.dispose();
  }

}
