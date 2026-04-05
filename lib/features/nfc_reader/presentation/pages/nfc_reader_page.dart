import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_bloc.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/scan_history_page.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

class NfcReaderPage extends StatelessWidget {
  const NfcReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<NfcReaderBloc>()..add(const CheckNfcAvailabilityEvent()),
      child: const _NfcReaderView(),
    );
  }
}

class _NfcReaderView extends StatelessWidget {
  const _NfcReaderView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.nfcReaderTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const ScanHistoryPage(),
                ),
              );
            },
            tooltip: AppLocalizations.of(context)!.historyTooltip,
          ),
        ],
      ),
      body: BlocBuilder<NfcReaderBloc, NfcReaderState>(
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
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NfcReaderBloc>().add(
                          const CheckNfcAvailabilityEvent(),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.retryButton),
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
                      AppLocalizations.of(context)!.readSuccessMessage,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _InfoRow(
                              label: AppLocalizations.of(context)!.filamentTypeLabel,
                              value: state.bobbinData.filamentType,
                            ),
                            const SizedBox(height: 8),
                            _InfoRow(
                              label: AppLocalizations.of(context)!.color,
                              value: state.bobbinData.color,
                            ),
                            const SizedBox(height: 8),
                            _InfoRow(
                              label: AppLocalizations.of(context)!.weight,
                              value: '${state.bobbinData.weightGrams}g',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NfcReaderBloc>().add(
                          const ReadBobbinDataEvent(),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.scanNfcChipButton),
                    ),
                  ],
                ),
              ),
            );
          }

          // Default state: NfcAvailable or Initial
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.nfc, size: 120, color: AppTheme.anycubicRed),
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)!.approachNfcChip,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NfcReaderBloc>().add(
                        const ReadBobbinDataEvent(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.scanNfcChipButton,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
