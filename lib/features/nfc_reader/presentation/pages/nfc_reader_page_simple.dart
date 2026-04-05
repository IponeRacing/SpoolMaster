import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/widgets/ad_banner_widget.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_bloc.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/bambu_clone_library_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/manual_add_spool_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_writer_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/scan_history_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/widgets/nfc_logo.dart';
import 'package:nfc_filament/features/profile/presentation/pages/profile_page.dart';

class NfcReaderPage extends StatelessWidget {
  final bool returnDataAfterScan;

  const NfcReaderPage({super.key, this.returnDataAfterScan = false});

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
  final bool returnDataAfterScan;

  const _NfcReaderView({this.returnDataAfterScan = false});

  @override
  State<_NfcReaderView> createState() => _NfcReaderViewState();
}

class _NfcReaderViewState extends State<_NfcReaderView> {
  String _nfcMode = 'anycubic'; // 'anycubic', 'bambu', ou 'prusa'

  @override
  void initState() {
    super.initState();
    _loadNfcMode();
  }

  Future<void> _loadNfcMode() async {
    final mode = await UserPreferencesService.getNfcMode();
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

  void _showModeInfoDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final String title;
    final String description;

    if (_nfcMode == 'bambu') {
      title = localizations.bambuLabReadOnly;
      description = localizations.bambuLabReadOnlyDesc;
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
                  // Material
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
                      contentPadding: EdgeInsets.symmetric(
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

    if (result == true && context.mounted) {
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
        title: Text(
          AppLocalizations.of(context)!.nfcEncoder,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
            child: BlocBuilder<NfcReaderBloc, NfcReaderState>(
              builder: (context, state) {
          if (state is NfcReaderLoading) {
            return const Center(child: CircularProgressIndicator());
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
              case NfcFailureType.readError:
                failureIcon = Icons.error_outline;
                failureColor = AppTheme.anycubicRed;
                failureTitle = AppLocalizations.of(context)!.errorReadingNfc;
                failureDetail = null;
            }

            return Center(
              child: Padding(
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
                              const ReadBobbinDataEvent(),
                            );
                          },
                          child: Text(AppLocalizations.of(context)!.refresh),
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

          if (state is BobbinDataReadSuccess) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                            if (state.bobbinData.batchNumber != null) ...[
                              // Tags Anycubic ont un SKU (ex: AHPLOR-001)
                              if (state.bobbinData.batchNumber!.contains(
                                RegExp(r'[A-Z]{4,}-\d{3}'),
                              ))
                                _InfoRow(
                                  label: AppLocalizations.of(context)!.skuLabel,
                                  value: state.bobbinData.batchNumber!,
                                )
                              // Tags Spool NFC Tag Writer ont "Brand - Material"
                              else if (state.bobbinData.batchNumber!.contains(
                                ' - ',
                              )) ...[
                                _InfoRow(
                                  label: AppLocalizations.of(context)!.brand,
                                  value: state.bobbinData.batchNumber!
                                      .split(' - ')
                                      .first,
                                ),
                              ] else
                                _InfoRow(
                                  label: AppLocalizations.of(context)!.batchNumber,
                                  value: state.bobbinData.batchNumber!,
                                ),
                              const Divider(height: 24),
                            ],
                            // Pour les tags Anycubic (SKU), afficher "Anycubic" comme fabricant
                            if (state.bobbinData.batchNumber?.contains(
                                  RegExp(r'[A-Z]{4,}-\d{3}'),
                                ) ==
                                true) ...[
                              _InfoRow(label: AppLocalizations.of(context)!.brand, value: 'Anycubic'),
                              const SizedBox(height: 8),
                            ],
                            _InfoRow(
                              label: AppLocalizations.of(context)!.filamentType,
                              value: state.bobbinData.filamentType,
                            ),
                            const SizedBox(height: 8),
                            if (state.bobbinData.colorRgb != null)
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
                                        0xFF000000 | state.bobbinData.colorRgb!,
                                      ),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            if (state.bobbinData.colorRgb != null)
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
                                  weightInGrams: state.bobbinData.weightGrams,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            if (state.bobbinData.diameter != null) ...[
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
                                    lengthInMm: state.bobbinData.diameter!,
                                    decimals: 2,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ],
                            if (state.bobbinData.spoolLength != null) ...[
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
                                    lengthInMm: state.bobbinData.spoolLength! * 1000,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    decimals: 0,
                                    showMetersForMetric: true,
                                  ),
                                ],
                              ),
                            ],
                            if (state.bobbinData.extruderTempMin != null &&
                                state.bobbinData.extruderTempMax != null) ...[
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
                                    minTempCelsius: state.bobbinData.extruderTempMin!.toDouble(),
                                    maxTempCelsius: state.bobbinData.extruderTempMax!.toDouble(),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ],
                            if (state.bobbinData.bedTempMin != null &&
                                state.bobbinData.bedTempMax != null) ...[
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
                                    minTempCelsius: state.bobbinData.bedTempMin!.toDouble(),
                                    maxTempCelsius: state.bobbinData.bedTempMax!.toDouble(),
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
                            'bobbinData': state.bobbinData,
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
                                const ReadBobbinDataEvent(),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.readNfcChip),
                          ),
                        ],
                      ),
                  ],
                ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const NfcLogo(size: 120),
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
                            : _nfcMode == 'anycubic'
                                ? AppLocalizations.of(context)!.forAnycubicAce
                                : AppLocalizations.of(context)!.forBambuLabAms,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (_nfcMode == 'bambu' || _nfcMode == 'prusa') ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _showModeInfoDialog(context),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.withOpacity(0.15),
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
                  // Slider pour choisir entre Anycubic, Bambu Lab et Prusa
                  Container(
                    width: 320,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
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
                                  fontSize: 13,
                                  color: _nfcMode == 'anycubic'
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _setNfcMode('bambu'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                                      fontSize: 13,
                                      color: _nfcMode == 'bambu'
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade600,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.experimentalBadge,
                                      style: const TextStyle(
                                        fontSize: 9,
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
                        const SizedBox(width: 4),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _setNfcMode('prusa'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                                      fontSize: 13,
                                      color: _nfcMode == 'prusa'
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade600,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.newBadge,
                                      style: const TextStyle(
                                        fontSize: 9,
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 280,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<NfcReaderBloc>().add(
                          const ReadBobbinDataEvent(),
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
                  // Bouton d'écriture NFC (Anycubic et Prusa)
                  if (_nfcMode == 'anycubic' || _nfcMode == 'prusa') ...[
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
