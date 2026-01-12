import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/widgets/ad_banner_widget.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_bloc.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/bambu_clone_library_page.dart';
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
  String _nfcMode = 'anycubic'; // 'anycubic' ou 'bambu'

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
              MaterialPageRoute(
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
              ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
                      AppLocalizations.of(context)!.errorReadingNfc,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
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
                                  label: 'SKU',
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
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
                  Text(
                    _nfcMode == 'anycubic'
                        ? AppLocalizations.of(context)!.forAnycubicAce
                        : AppLocalizations.of(context)!.forBambuLabAms,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Slider pour choisir entre Anycubic et Bambu Lab
                  Container(
                    width: 280,
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
                                    child: const Text(
                                      'EXPERIMENTAL',
                                      style: TextStyle(
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
                  // Bouton d'écriture NFC (seulement pour Anycubic)
                  if (_nfcMode == 'anycubic') ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 280,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NfcWriterPage(),
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
                            MaterialPageRoute(
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
                        label: const Text(
                          'Bibliothèque de clones',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                  // Message d'info pour Bambu Lab (lecture seule)
                  if (_nfcMode == 'bambu') ...[
                    const SizedBox(height: 16),
                    Container(
                      width: 280,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.bambuLabReadOnly,
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLocalizations.of(context)!.bambuLabReadOnlyDesc,
                                  style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
            ),
          ),
          // Bannière publicitaire en bas
          AdBannerWidget(
            adUnitId: AdMobService().nfcReaderBannerId,
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
