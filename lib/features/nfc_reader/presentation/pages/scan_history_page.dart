import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/core/widgets/ad_banner_widget.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/scan_history.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/scan_history_bloc.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/scan_history_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/scan_history_state.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/scan_detail_page.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

class ScanHistoryPage extends StatelessWidget {
  const ScanHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ScanHistoryBloc>()..add(const LoadScanHistoryEvent()),
      child: const _ScanHistoryView(),
    );
  }
}

class _ScanHistoryView extends StatelessWidget {
  const _ScanHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.scanHistoryTitle),
        actions: [
          BlocBuilder<ScanHistoryBloc, ScanHistoryState>(
            buildWhen: (previous, current) =>
                (previous is ScanHistoryLoaded) != (current is ScanHistoryLoaded),
            builder: (context, state) {
              if (state is ScanHistoryLoaded && state.scans.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () => _showClearConfirmationDialog(context),
                  tooltip: AppLocalizations.of(context)!.clearAll,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ScanHistoryBloc, ScanHistoryState>(
        listener: (context, state) {
          if (state is ScanHistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ScanDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.scanDeleted),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ScanHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ScanHistoryEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noScansRecorded,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.scansWillAppearHere,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ScanHistoryLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ScanHistoryBloc>().add(
                  const LoadScanHistoryEvent(),
                );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.scans.length,
                itemBuilder: (context, index) {
                  final scan = state.scans[index];
                  return _ScanHistoryCard(
                    scan: scan,
                    onTap: () => _navigateToDetail(context, scan),
                    onDelete: () =>
                        _showDeleteConfirmationDialog(context, scan.id),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
            ),
          ),
          // Bannière publicitaire en bas
          AdBannerWidget(
            adUnitId: AdMobService().nfcHistoryBannerId,
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, ScanHistory scan) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => ScanDetailPage(scan: scan)),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String scanId) {
    final localizations = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.deleteThisScan),
        content: Text(localizations.actionIrreversible),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ScanHistoryBloc>().add(DeleteScanEvent(scanId));
            },
            child: Text(
              localizations.delete,
              style: const TextStyle(color: AppTheme.anycubicRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmationDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.clearAll),
        content: Text(localizations.allScansWillBeDeleted),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ScanHistoryBloc>().add(const ClearAllScansEvent());
            },
            child: Text(
              localizations.clearAll,
              style: const TextStyle(color: AppTheme.anycubicRed),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanHistoryCard extends StatelessWidget {
  final ScanHistory scan;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ScanHistoryCard({
    required this.scan,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.anycubicRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.nfc,
                  color: AppTheme.anycubicRed,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${scan.bobbinData.filamentType} - ${scan.bobbinData.color}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FormattedWeight(
                      weightInGrams: scan.bobbinData.weightGrams,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateFormat.format(scan.timestamp),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
