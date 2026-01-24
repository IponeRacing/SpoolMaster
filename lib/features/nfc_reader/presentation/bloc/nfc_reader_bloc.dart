import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/scan_history_model.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/check_nfc_availability.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_nfc_tag.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/save_scan_to_history.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/write_bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';

@injectable
class NfcReaderBloc extends Bloc<NfcReaderEvent, NfcReaderState> {
  final CheckNfcAvailability checkNfcAvailability;
  final ReadNfcTag readNfcTag;
  final ReadBobbinData readBobbinData;
  final WriteBobbinData writeBobbinData;
  final SaveScanToHistory saveScanToHistory;

  NfcReaderBloc({
    required this.checkNfcAvailability,
    required this.readNfcTag,
    required this.readBobbinData,
    required this.writeBobbinData,
    required this.saveScanToHistory,
  }) : super(const NfcReaderInitial()) {
    on<CheckNfcAvailabilityEvent>(_onCheckNfcAvailability);
    on<ReadNfcTagEvent>(_onReadNfcTag);
    on<ReadBobbinDataEvent>(_onReadBobbinData);
    on<WriteBobbinDataEvent>(_onWriteBobbinData);
    on<StopNfcScanEvent>(_onStopNfcScan);
  }

  Future<void> _onCheckNfcAvailability(
    CheckNfcAvailabilityEvent event,
    Emitter<NfcReaderState> emit,
  ) async {
    developer.log('🔍 [BLOC] Événement CheckNfcAvailability reçu');
    emit(const NfcReaderLoading());

    developer.log('📞 [BLOC] Appel du usecase checkNfcAvailability...');
    final result = await checkNfcAvailability();

    result.fold(
      (failure) {
        developer.log('❌ [BLOC] Échec: ${failure.message}');
        emit(NfcNotAvailable(failure.message));
      },
      (isAvailable) {
        developer.log('✅ [BLOC] Résultat: isAvailable=$isAvailable');
        if (isAvailable) {
          emit(const NfcAvailable());
        } else {
          emit(const NfcNotAvailable('NFC non disponible sur cet appareil'));
        }
      },
    );
  }

  Future<void> _onReadNfcTag(
    ReadNfcTagEvent event,
    Emitter<NfcReaderState> emit,
  ) async {
    emit(const NfcReaderLoading());

    final result = await readNfcTag();

    result.fold(
      (failure) => emit(NfcReaderFailure(failure.message)),
      (tag) => emit(NfcTagReadSuccess(tag)),
    );
  }

  Future<void> _onReadBobbinData(
    ReadBobbinDataEvent event,
    Emitter<NfcReaderState> emit,
  ) async {
    emit(const NfcReaderLoading());

    final result = await readBobbinData();

    await result.fold(
      (failure) async {
        // Si l'utilisateur a annulé, revenir à l'état disponible sans erreur
        if (failure is NfcSessionCancelledFailure) {
          developer.log("ℹ️ [BLOC] Scan annulé par l'utilisateur");
          emit(const NfcAvailable());
          return;
        }

        // Log failed scan to backend
        AnalyticsService.logNfcScan(
          scanType: 'scan_nfc',
          success: false,
        );
        emit(NfcReaderFailure(failure.message));
      },
      (bobbinData) async {
        // Auto-save scan to history
        developer.log('💾 [BLOC] Auto-saving scan to history');
        final scanHistory = ScanHistoryModel.fromBobbinData(bobbinData);
        await saveScanToHistory(scanHistory);
        developer.log('✅ [BLOC] Scan auto-saved');

        // Log successful scan to backend
        AnalyticsService.logNfcScan(
          scanType: 'scan_nfc',
          brand: bobbinData.brand,
          material: bobbinData.filamentType,
          color: bobbinData.color,
          success: true,
        );

        emit(BobbinDataReadSuccess(bobbinData));
      },
    );
  }

  Future<void> _onWriteBobbinData(
    WriteBobbinDataEvent event,
    Emitter<NfcReaderState> emit,
  ) async {
    developer.log('✍️ [BLOC] Événement WriteBobbinData reçu');
    emit(const NfcReaderLoading());

    final result = await writeBobbinData(event.bobbinData);

    result.fold(
      (failure) {
        developer.log('❌ [BLOC] Échec écriture: ${failure.message}');
        emit(NfcReaderFailure(failure.message));
      },
      (_) {
        developer.log('✅ [BLOC] Écriture réussie');
        emit(const BobbinDataWriteSuccess());
      },
    );
  }

  void _onStopNfcScan(StopNfcScanEvent event, Emitter<NfcReaderState> emit) {
    emit(const NfcReaderInitial());
  }
}
