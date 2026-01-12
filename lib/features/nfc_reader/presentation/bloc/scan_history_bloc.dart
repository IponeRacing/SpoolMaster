import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/clear_scan_history.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/delete_scan.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/get_scan_history.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/save_scan_to_history.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/scan_history_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/scan_history_state.dart';

@injectable
class ScanHistoryBloc extends Bloc<ScanHistoryEvent, ScanHistoryState> {
  final GetScanHistory getScanHistory;
  final SaveScanToHistory saveScanToHistory;
  final DeleteScan deleteScan;
  final ClearScanHistory clearScanHistory;

  ScanHistoryBloc({
    required this.getScanHistory,
    required this.saveScanToHistory,
    required this.deleteScan,
    required this.clearScanHistory,
  }) : super(const ScanHistoryInitial()) {
    on<LoadScanHistoryEvent>(_onLoadScanHistory);
    on<SaveScanEvent>(_onSaveScan);
    on<DeleteScanEvent>(_onDeleteScan);
    on<ClearAllScansEvent>(_onClearAllScans);
  }

  Future<void> _onLoadScanHistory(
    LoadScanHistoryEvent event,
    Emitter<ScanHistoryState> emit,
  ) async {
    developer.log('📖 [SCAN_HISTORY_BLOC] Loading scan history');
    emit(const ScanHistoryLoading());

    final result = await getScanHistory();

    result.fold(
      (failure) {
        developer.log(
          '❌ [SCAN_HISTORY_BLOC] Error loading history: ${failure.message}',
        );
        emit(ScanHistoryError(failure.message));
      },
      (scans) {
        developer.log('✅ [SCAN_HISTORY_BLOC] Loaded ${scans.length} scans');
        if (scans.isEmpty) {
          emit(const ScanHistoryEmpty());
        } else {
          emit(ScanHistoryLoaded(scans));
        }
      },
    );
  }

  Future<void> _onSaveScan(
    SaveScanEvent event,
    Emitter<ScanHistoryState> emit,
  ) async {
    developer.log('💾 [SCAN_HISTORY_BLOC] Saving scan');

    final result = await saveScanToHistory(event.scan);

    result.fold(
      (failure) {
        developer.log(
          '❌ [SCAN_HISTORY_BLOC] Error saving scan: ${failure.message}',
        );
        emit(ScanHistoryError(failure.message));
      },
      (_) {
        developer.log('✅ [SCAN_HISTORY_BLOC] Scan saved successfully');
        emit(const ScanSaved());
        // Reload history after saving
        add(const LoadScanHistoryEvent());
      },
    );
  }

  Future<void> _onDeleteScan(
    DeleteScanEvent event,
    Emitter<ScanHistoryState> emit,
  ) async {
    developer.log('🗑️ [SCAN_HISTORY_BLOC] Deleting scan: ${event.id}');

    final result = await deleteScan(event.id);

    result.fold(
      (failure) {
        developer.log(
          '❌ [SCAN_HISTORY_BLOC] Error deleting scan: ${failure.message}',
        );
        emit(ScanHistoryError(failure.message));
      },
      (_) {
        developer.log('✅ [SCAN_HISTORY_BLOC] Scan deleted successfully');
        emit(const ScanDeleted());
        // Reload history after deleting
        add(const LoadScanHistoryEvent());
      },
    );
  }

  Future<void> _onClearAllScans(
    ClearAllScansEvent event,
    Emitter<ScanHistoryState> emit,
  ) async {
    developer.log('🧹 [SCAN_HISTORY_BLOC] Clearing all scans');

    final result = await clearScanHistory();

    result.fold(
      (failure) {
        developer.log(
          '❌ [SCAN_HISTORY_BLOC] Error clearing scans: ${failure.message}',
        );
        emit(ScanHistoryError(failure.message));
      },
      (_) {
        developer.log('✅ [SCAN_HISTORY_BLOC] All scans cleared successfully');
        emit(const ScanHistoryEmpty());
      },
    );
  }
}
