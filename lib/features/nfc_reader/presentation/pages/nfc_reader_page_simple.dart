import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/core/widgets/ad_banner_widget.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_bloc.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/bambu_clone_library_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/manual_add_spool_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_writer_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/scan_history_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/widgets/nfc_logo.dart';
import 'package:nfc_filament/features/profile/presentation/pages/profile_page.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

class NfcReaderPage extends StatelessWidget {

  const NfcReaderPage({super.key, this.returnDataAfterScan = false});
  final bool returnDataAfterScan;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<NfcReaderBloc>()..add(const CheckNfcAvailabilityEvent()),
      child: _NfcReaderView(returnDataAfterScan: returnDataAfterScan),
    );
  }
}

class _NfcReaderView extends StatefulWidget {

  const _NfcReaderView({this.returnDataAfterScan = false});
  final bool returnDataAfterScan;

  @override
  State<_NfcReaderView> createState() => _NfcReaderViewState();
}

class _NfcReaderViewState extends State<_NfcReaderView> {
  String _nfcMode = 'anycubic'; // 'anycubic', 'bambu', 'prusa', ou 'creality'

  @override
  void initState() {
    super.initState();
    _loadNfcMode();
  }

  Future<void> _loadNfcMode() async {
    var mode = await UserPreferencesService.getNfcMode();
    // MiFare Classic (bambu/creality) non supporté sur iOS - fallback
    if (Platform.isIOS && (mode == 'bambu' || mode == 'creality')) {
      mode = 'anycubic';
    }
    setState(() {
      _nfcMode = mode;
    });
  }

  Future<void> _setNfcMode(String mode) async {
    await UserPreferencesService.setNfcMode(mode);
    setState(() {
      _nfcMode = mode;
    });
  }

  void _showPlatformLimitationDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                localizations.platformLimitationTitle,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(localizations.mifareClassicNotSupportedIos),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(localizations.ok),
          ),
        ],
      ),
    );
  }

  void _showModeInfoDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final String title;
    final String description;

    if (_nfcMode == 'bambu') {
      title = localizations.bambuLabReadOnly;
      description = localizations.bambuLabReadOnlyDesc;
    } else if (_nfcMode == 'creality') {
      title = localizations.crealityReadWrite;
      description = localizations.crealityReadWriteDesc;
    } else {
      title = localizations.prusaReadWrite;
      description = localizations.prusaReadWriteDesc;
    }

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          ],
        ),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _showFeedbackDialog(BuildContext context, NfcReaderFailure state) async {
    final localizations = AppLocalizations.of(context)!;
    var selectedBrand = 'Anycubic';
    var customBrand = '';
    var selectedMaterial = 'PLA';
    var colorText = '';
    var showOptional = false;
    var weightText = '';
    var extruderMinText = '';
    var extruderMaxText = '';
    var bedMinText = '';
    var bedMaxText = '';
    var diameterText = '';
    var spoolLengthText = '';
    var batchNumberText = '';

    final materials = [
      'PLA', 'PLA+', 'PLA Silk', 'PLA Matte', 'PLA Glow',
      'PETG', 'ABS', 'ASA', 'TPU',
      'Nylon', 'PC', 'HIPS', 'PVA',
    ];

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
                  // Brand
                  Text(
                    localizations.brandLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  RadioGroup<String>(
                    groupValue: selectedBrand,
                    onChanged: (v) => setDialogState(() => selectedBrand = v ?? selectedBrand),
                    child: Column(
                      children: [
                        const RadioListTile<String>(
                          title: Text('Anycubic'),
                          value: 'Anycubic',
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const RadioListTile<String>(
                          title: Text('Bambu Lab'),
                          value: 'Bambu Lab',
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const RadioListTile<String>(
                          title: Text('Prusa'),
                          value: 'Prusa',
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const RadioListTile<String>(
                          title: Text('Creality'),
                          value: 'Creality',
                          dense: true,
                          contentPadding: EdgeInsets.zero,
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
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Material
                  Text(
                    localizations.selectMaterial,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: selectedMaterial,
                    isExpanded: true,
                    items: materials.map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(m),
                    )).toList(),
                    onChanged: (v) => setDialogState(() => selectedMaterial = v!),
                  ),
                  const SizedBox(height: 16),
                  // Color
                  Text(
                    localizations.color,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.colorHintExamples,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (v) => colorText = v,
                  ),
                  const SizedBox(height: 16),
                  // Section optionnelle dépliable
                  InkWell(
                    onTap: () => setDialogState(() => showOptional = !showOptional),
                    child: Row(
                      children: [
                        Icon(
                          showOptional ? Icons.expand_less : Icons.expand_more,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          localizations.optionalDetails,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showOptional) ...[
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        labelText: localizations.weightGrams,
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => weightText = v,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: localizations.extruderTempMin,
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => extruderMinText = v,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: localizations.extruderTempMax,
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => extruderMaxText = v,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: localizations.bedTempMin,
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => bedMinText = v,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: localizations.bedTempMax,
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => bedMaxText = v,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: localizations.diameterMm,
                              isDense: true,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => diameterText = v,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: localizations.spoolLengthM,
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => spoolLengthText = v,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        labelText: localizations.batchNumberLabel,
                        isDense: true,
                      ),
                      onChanged: (v) => batchNumberText = v,
                    ),
                  ],
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
                  nfcMode: _nfcMode,
                  weight: weightText,
                  extruderTempMin: extruderMinText,
                  extruderTempMax: extruderMaxText,
                  bedTempMin: bedMinText,
                  bedTempMax: bedMaxText,
                  diameter: diameterText,
                  spoolLength: spoolLengthText,
                  batchNumber: batchNumberText,
                );
                Navigator.pop(dialogContext, true);
              },
              child: Text(localizations.send),
            ),
          ],
        ),
      ),
    );

    if ((result ?? false) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.thankYouFeedback),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _navigateToManualAdd(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ManualAddSpoolPage(
          onSave: (spool) async {
            await SpoolStorageService.addSpool(spool);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.spoolAdded),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.history),
          tooltip: AppLocalizations.of(context)!.scanHistory,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const ScanHistoryPage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: AppLocalizations.of(context)!.profile,
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: (_) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Bannière publicitaire en haut, sous l'app bar
          AdBannerWidget(
            adUnitId: AdMobService().nfcReaderBannerId,
          ),
          Expanded(
            child: BlocConsumer<NfcReaderBloc, NfcReaderState>(
              listener: (context, state) {
                if (state is BobbinDataReadSuccessWithFallback) {
                  final modeName = state.detectedMode == 'bambu' ? 'Bambu Lab' : state.detectedMode[0].toUpperCase() + state.detectedMode.substring(1);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.fallbackDetectedAs(modeName)),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                }
              },
              builder: (context, state) {
          if (state is NfcReaderLoading) {
            return _NfcScanningAnimation(
              onCancel: () {
                context.read<NfcReaderBloc>().add(const StopNfcScanEvent());
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
                  ],
                ),
              ),
            );
          }

          if (state is NfcReaderFailure) {
            // Icône et messages selon le type d'erreur
            final IconData failureIcon;
            final Color failureColor;
            final String failureTitle;
            final String? failureDetail;

            switch (state.failureType) {
              case NfcFailureType.tagNotDetected:
                failureIcon = Icons.nfc_outlined;
                failureColor = Colors.orange;
                failureTitle = AppLocalizations.of(context)!.nfcTagNotDetected;
                failureDetail = AppLocalizations.of(context)!.nfcTagNotDetectedDesc;
              case NfcFailureType.incompatibleTag:
                failureIcon = Icons.warning_amber_rounded;
                failureColor = Colors.amber;
                failureTitle = AppLocalizations.of(context)!.nfcTagIncompatible;
                failureDetail = state.message;
              case NfcFailureType.authError:
                failureIcon = Icons.lock_outline;
                failureColor = Colors.orange;
                failureTitle = AppLocalizations.of(context)!.nfcAuthError;
                failureDetail = AppLocalizations.of(context)!.nfcAuthErrorDesc;
              case NfcFailureType.readError:
                failureIcon = Icons.error_outline;
                failureColor = AppTheme.anycubicRed;
                failureTitle = AppLocalizations.of(context)!.errorReadingNfc;
                failureDetail = null;
              case NfcFailureType.nfcDisabled:
                failureIcon = Icons.nfc_outlined;
                failureColor = Colors.orange;
                failureTitle = AppLocalizations.of(context)!.nfcDisabledTitle;
                failureDetail = AppLocalizations.of(context)!.nfcDisabledMessage;
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      failureIcon,
                      size: 64,
                      color: failureColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      failureTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (failureDetail != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        failureDetail,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    // Conseil de positionnement NFC adapté à la plateforme
                    if (state.failureType == NfcFailureType.tagNotDetected) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, size: 20, color: Colors.blue.shade700),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                Platform.isIOS
                                    ? AppLocalizations.of(context)!.nfcTipIos
                                    : AppLocalizations.of(context)!.nfcTipAndroid,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            context.read<NfcReaderBloc>().add(
                              const StopNfcScanEvent(),
                            );
                          },
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<NfcReaderBloc>().add(
                              const ReadBobbinDataEvent(entryPoint: 'home'),
                            );
                          },
                          child: Text(AppLocalizations.of(context)!.refresh),
                        ),
                      ],
                    ),
                    // Bouton auto-detect pour les timeouts
                    if (state.failureType == NfcFailureType.tagNotDetected) ...[
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.read<NfcReaderBloc>().add(
                            const ReadBobbinDataAutoDetectEvent(entryPoint: 'home'),
                          );
                        },
                        icon: const Icon(Icons.search),
                        label: Text(AppLocalizations.of(context)!.tryAutoDetect),
                      ),
                    ],
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => _showFeedbackDialog(context, state),
                      icon: const Icon(Icons.feedback_outlined),
                      label: Text(
                        AppLocalizations.of(context)!.helpIdentifyFilament,
                      ),
                    ),
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

          if (state is BobbinDataReadSuccessWithFallback || state is BobbinDataReadSuccess) {
            final bobbinData = state is BobbinDataReadSuccessWithFallback
                ? state.bobbinData
                : (state as BobbinDataReadSuccess).bobbinData;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                    const Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.nfcDataRead,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (bobbinData.batchNumber != null) ...[
                              // Tags Anycubic ont un SKU (ex: AHPLOR-001)
                              if (bobbinData.batchNumber!.contains(
                                RegExp(r'[A-Z]{4,}-\d{3}'),
                              ))
                                _InfoRow(
                                  label: AppLocalizations.of(context)!.skuLabel,
                                  value: bobbinData.batchNumber!,
                                )
                              // Tags Spool NFC Tag Writer ont "Brand - Material"
                              else if (bobbinData.batchNumber!.contains(
                                ' - ',
                              )) ...[
                                _InfoRow(
                                  label: AppLocalizations.of(context)!.brand,
                                  value: bobbinData.batchNumber!
                                      .split(' - ')
                                      .first,
                                ),
                              ] else
                                _InfoRow(
                                  label: AppLocalizations.of(context)!.batchNumber,
                                  value: bobbinData.batchNumber!,
                                ),
                              const Divider(height: 24),
                            ],
                            // Pour les tags Anycubic (SKU), afficher "Anycubic" comme fabricant
                            if (bobbinData.batchNumber?.contains(
                                  RegExp(r'[A-Z]{4,}-\d{3}'),
                                ) ?? false) ...[
                              _InfoRow(label: AppLocalizations.of(context)!.brand, value: 'Anycubic'),
                              const SizedBox(height: 8),
                            ],
                            _InfoRow(
                              label: AppLocalizations.of(context)!.filamentType,
                              value: bobbinData.filamentType,
                            ),
                            const SizedBox(height: 8),
                            if (bobbinData.colorRgb != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.color,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Color(
                                        0xFF000000 | bobbinData.colorRgb!,
                                      ),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            if (bobbinData.colorRgb != null)
                              const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.weight,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w500),
                                ),
                                FormattedWeight(
                                  weightInGrams: bobbinData.weightGrams,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            if (bobbinData.diameter != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.diameter,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  FormattedLength(
                                    lengthInMm: bobbinData.diameter!,
                                    decimals: 2,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ],
                            if (bobbinData.spoolLength != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.length,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  FormattedLength(
                                    lengthInMm: bobbinData.spoolLength! * 1000,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    decimals: 0,
                                    showMetersForMetric: true,
                                  ),
                                ],
                              ),
                            ],
                            if (bobbinData.extruderTempMin != null &&
                                bobbinData.extruderTempMax != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.tempExtruder,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  FormattedTemperatureRange(
                                    minTempCelsius: bobbinData.extruderTempMin!.toDouble(),
                                    maxTempCelsius: bobbinData.extruderTempMax!.toDouble(),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ],
                            if (bobbinData.bedTempMin != null &&
                                bobbinData.bedTempMax != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.tempBed,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  FormattedTemperatureRange(
                                    minTempCelsius: bobbinData.bedTempMin!.toDouble(),
                                    maxTempCelsius: bobbinData.bedTempMax!.toDouble(),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (widget.returnDataAfterScan)
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context, {
                            'bobbinData': bobbinData,
                          });
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: Text(AppLocalizations.of(context)!.addSpool),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              context.read<NfcReaderBloc>().add(
                                const StopNfcScanEvent(),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<NfcReaderBloc>().add(
                                const ReadBobbinDataEvent(entryPoint: 'home'),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.readNfcChip),
                          ),
                        ],
                      ),
                  ],
                ),
            );
          }

          // NfcAvailable OU NfcReaderInitial - Menu principal
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Center(
                  child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NfcLogo(),
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!.nfcEncoder,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _nfcMode == 'prusa'
                            ? AppLocalizations.of(context)!.forPrusaMk4
                            : _nfcMode == 'creality'
                                ? AppLocalizations.of(context)!.forCrealityCfs
                                : _nfcMode == 'anycubic'
                                    ? AppLocalizations.of(context)!.forAnycubicAce
                                    : AppLocalizations.of(context)!.forBambuLabAms,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (_nfcMode == 'bambu' || _nfcMode == 'prusa' || _nfcMode == 'creality') ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _showModeInfoDialog(context),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withValues(alpha: 0.15),
                            ),
                            child: Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Détection auto toutes marques (standards ouverts inclus :
                  // Elegoo, OpenSpool, OpenTag3D...)
                  SizedBox(
                    width: 340,
                    child: ElevatedButton(
                      onPressed: () => context.read<NfcReaderBloc>().add(
                            const ReadBobbinDataAutoDetectEvent(entryPoint: 'home'),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.anycubicRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.auto_awesome, size: 18),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!.autoDetectAllBrands,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppLocalizations.of(context)!.autoDetectAllBrandsDesc,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Slider pour choisir entre Anycubic, Bambu Lab, Prusa et Creality
                  Container(
                    width: 340,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // Anycubic tab
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _setNfcMode('anycubic'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _nfcMode == 'anycubic'
                                    ? AppTheme.anycubicRed
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Anycubic',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: _nfcMode == 'anycubic'
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        // Bambu Lab tab (grisé sur iOS)
                        Expanded(
                          child: Opacity(
                            opacity: Platform.isIOS ? 0.4 : 1.0,
                            child: GestureDetector(
                              onTap: Platform.isIOS
                                  ? () => _showPlatformLimitationDialog(context)
                                  : () => _setNfcMode('bambu'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: _nfcMode == 'bambu'
                                      ? AppTheme.anycubicRed
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Bambu Lab',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: _nfcMode == 'bambu'
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Platform.isIOS
                                            ? Colors.grey.shade500
                                            : Colors.orange.shade600,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        Platform.isIOS
                                            ? 'ANDROID'
                                            : AppLocalizations.of(context)!.experimentalBadge,
                                        style: const TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        // Prusa tab
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _setNfcMode('prusa'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _nfcMode == 'prusa'
                                    ? AppTheme.anycubicRed
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Prusa',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: _nfcMode == 'prusa'
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade600,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.newBadge,
                                      style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        // Creality tab (grisé sur iOS)
                        Expanded(
                          child: Opacity(
                            opacity: Platform.isIOS ? 0.4 : 1.0,
                            child: GestureDetector(
                              onTap: Platform.isIOS
                                  ? () => _showPlatformLimitationDialog(context)
                                  : () => _setNfcMode('creality'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: _nfcMode == 'creality'
                                      ? AppTheme.anycubicRed
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Creality',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                        color: _nfcMode == 'creality'
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Platform.isIOS
                                            ? Colors.grey.shade500
                                            : Colors.orange.shade600,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        Platform.isIOS
                                            ? 'ANDROID'
                                            : AppLocalizations.of(context)!.experimentalBadge,
                                        style: const TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 280,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<NfcReaderBloc>().add(
                          const ReadBobbinDataEvent(entryPoint: 'home'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      icon: const Icon(Icons.nfc),
                      label: Text(
                        AppLocalizations.of(context)!.readNfcChip,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  // Bouton d'écriture NFC (Anycubic, Prusa et Creality)
                  if (_nfcMode == 'anycubic' || _nfcMode == 'prusa' || _nfcMode == 'creality') ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 280,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => NfcWriterPage(initialFormat: _nfcMode),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(Icons.edit),
                        label: Text(
                          AppLocalizations.of(context)!.writeNfcChip,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                  // Bouton Bibliothèque pour Bambu Lab
                  if (_nfcMode == 'bambu') ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 280,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => const BambuCloneLibraryPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.anycubicRed,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(Icons.library_books),
                        label: Text(
                          AppLocalizations.of(context)!.bambuCloneLibrary,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                    ],
                  ),
                  ),
                  ),
                ),
              ),
            ),
          );
        },
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _NfcScanningAnimation extends StatefulWidget {

  const _NfcScanningAnimation({required this.onCancel});
  final VoidCallback onCancel;

  @override
  State<_NfcScanningAnimation> createState() => _NfcScanningAnimationState();
}

class _NfcScanningAnimationState extends State<_NfcScanningAnimation>
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
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 160 * _pulseAnimation.value,
                      height: 160 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      ),
                    ),
                    Container(
                      width: 120 * _pulseAnimation.value,
                      height: 120 * _pulseAnimation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                      ),
                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}
