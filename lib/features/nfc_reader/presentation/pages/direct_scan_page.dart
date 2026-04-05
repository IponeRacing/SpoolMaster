import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_bloc.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/manual_add_spool_page.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:nfc_filament/native_nfc/native_nfc.dart';

/// Page qui lance directement le scan NFC sans afficher de menu
class DirectScanPage extends StatelessWidget {
  const DirectScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<NfcReaderBloc>()
            ..add(const CheckNfcAvailabilityEvent())
            ..add(const ReadBobbinDataEvent()), // Lance automatiquement le scan
      child: const _DirectScanView(),
    );
  }
}

class _DirectScanView extends StatelessWidget {
  const _DirectScanView();

  void _navigateToManualAdd(BuildContext context) {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (ctx) => ManualAddSpoolPage(
          onSave: (spool) async {
            await SpoolStorageService.addSpool(spool);
            if (ctx.mounted) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(ctx)!.spoolAdded),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _showFeedbackDialog(BuildContext context, NfcReaderFailure state) async {
    final localizations = AppLocalizations.of(context)!;
    var selectedBrand = 'Anycubic';
    var customBrand = '';
    var selectedMaterial = 'PLA';
    var colorText = '';
    final nfcMode = await UserPreferencesService.getNfcMode();

    final materials = [
      'PLA', 'PLA+', 'PLA Silk', 'PLA Matte', 'PLA Glow',
      'PETG', 'ABS', 'ASA', 'TPU',
      'Nylon', 'PC', 'HIPS', 'PVA',
    ];

    if (!context.mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(localizations.helpUsImprove),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.helpIdentifyDescription,
                    style: Theme.of(dialogContext).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.brandLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  RadioListTile<String>(
                    title: const Text('Anycubic'),
                    value: 'Anycubic',
                    groupValue: selectedBrand,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setDialogState(() => selectedBrand = v!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Bambu Lab'),
                    value: 'Bambu Lab',
                    groupValue: selectedBrand,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setDialogState(() => selectedBrand = v!),
                  ),
                  RadioListTile<String>(
                    title: const Text('Prusa'),
                    value: 'Prusa',
                    groupValue: selectedBrand,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setDialogState(() => selectedBrand = v!),
                  ),
                  RadioListTile<String>(
                    title: Row(
                      children: [
                        Text('${localizations.otherBrand}: '),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                            ),
                            onChanged: (v) {
                              customBrand = v;
                              setDialogState(() => selectedBrand = 'other');
                            },
                            onTap: () => setDialogState(() => selectedBrand = 'other'),
                          ),
                        ),
                      ],
                    ),
                    value: 'other',
                    groupValue: selectedBrand,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setDialogState(() => selectedBrand = v!),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.selectMaterial,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedMaterial,
                    isExpanded: true,
                    items: materials.map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(m),
                    )).toList(),
                    onChanged: (v) => setDialogState(() => selectedMaterial = v!),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.color,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Red, Blue, Black...',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (v) => colorText = v,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final brand = selectedBrand == 'other' ? customBrand : selectedBrand;
                AnalyticsService.logScanFeedback(
                  brand: brand,
                  material: selectedMaterial,
                  color: colorText,
                  rawTagData: state.rawTagData,
                  rawBytesCount: state.rawBytesCount,
                  errorMessage: state.message,
                  nfcMode: nfcMode,
                );
                Navigator.pop(dialogContext, true);
              },
              child: Text(localizations.send),
            ),
          ],
        ),
      ),
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.thankYouFeedback),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.scanBobbinDirectly,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocListener<NfcReaderBloc, NfcReaderState>(
        listener: (context, state) {
          // Quand le scan réussit, retourner les données
          if (state is BobbinDataReadSuccess) {
            Navigator.pop(context, {
              'bobbinData': state.bobbinData,
            });
          }
        },
        child: BlocBuilder<NfcReaderBloc, NfcReaderState>(
          builder: (context, state) {
            if (state is NfcReaderLoading || state is NfcReaderInitial) {
              return _NfcScanningView(
                onCancel: () {
                  NativeNfc.stopSession();
                  Navigator.pop(context);
                },
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
                        child: Text(AppLocalizations.of(context)!.back),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is NfcReaderFailure) {
              return Center(
                child: SingleChildScrollView(
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
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<NfcReaderBloc>().add(
                                const ReadBobbinDataEvent(),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.retry),
                          ),
                        ],
                      ),
                      if (state.hasTagData) ...[
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: () => _showFeedbackDialog(context, state),
                          icon: const Icon(Icons.help_outline),
                          label: Text(
                            AppLocalizations.of(context)!.helpIdentifyFilament,
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => _navigateToManualAdd(context),
                        icon: const Icon(Icons.edit),
                        label: Text(
                          AppLocalizations.of(context)!.addManually,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // État de scan en cours
            return _NfcScanningView(
              onCancel: () {
                NativeNfc.stopSession();
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}

/// Widget d'animation NFC pour Android (remplace le simple spinner)
class _NfcScanningView extends StatefulWidget {
  final VoidCallback onCancel;

  const _NfcScanningView({required this.onCancel});

  @override
  State<_NfcScanningView> createState() => _NfcScanningViewState();
}

class _NfcScanningViewState extends State<_NfcScanningView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cercles pulsants + icone NFC
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Cercle externe pulsant
                    Container(
                      width: 160 * _pulseAnimation.value,
                      height: 160 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4CAF50).withValues(alpha: 0.1),
                      ),
                    ),
                    // Cercle moyen
                    Container(
                      width: 120 * _pulseAnimation.value,
                      height: 120 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4CAF50).withValues(alpha: 0.2),
                      ),
                    ),
                    // Icone NFC
                    const Icon(
                      Icons.nfc_rounded,
                      size: 64,
                      color: Color(0xFF4CAF50),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              l10n.approachNfcChip,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'NFC actif - approchez le tag',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Petit indicateur de progression
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey,
                color: Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              onPressed: widget.onCancel,
              icon: const Icon(Icons.close),
              label: Text(l10n.cancel),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
