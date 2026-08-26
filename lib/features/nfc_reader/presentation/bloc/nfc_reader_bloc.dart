import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';
import 'package:nfc_filament/core/services/review_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/scan_history_model.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/check_nfc_availability.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_bobbin_data_auto_detect.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_nfc_tag.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/save_scan_to_history.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/write_bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';

@injectable
class NfcReaderBloc extends Bloc<NfcReaderEvent, NfcReaderState> {

  NfcReaderBloc({
    required this.checkNfcAvailability,
    required this.readNfcTag,
    required this.readBobbinData,
    required this.writeBobbinData,
    required this.saveScanToHistory,
    required this.readBobbinDataAutoDetect,
  }) : super(const NfcReaderInitial()) {
    on<CheckNfcAvailabilityEvent>(_onCheckNfcAvailability);
    on<ReadNfcTagEvent>(_onReadNfcTag);
    on<ReadBobbinDataEvent>(_onReadBobbinData);
    on<ReadBobbinDataAutoDetectEvent>(_onReadBobbinDataAutoDetect);
    on<WriteBobbinDataEvent>(_onWriteBobbinData);
    on<StopNfcScanEvent>(_onStopNfcScan);
  }
  final CheckNfcAvailability checkNfcAvailability;
  final ReadNfcTag readNfcTag;
  final ReadBobbinData readBobbinData;
  final WriteBobbinData writeBobbinData;
  final SaveScanToHistory saveScanToHistory;
  final ReadBobbinDataAutoDetect readBobbinDataAutoDetect;

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

  /// Déduit la marque à partir du mode NFC (pour analytics)
  String _brandFromMode(String mode) {
    switch (mode) {
      case 'bambu':
        return 'Bambu Lab';
      case 'prusa':
        return 'Prusa';
      case 'creality':
        return 'Creality';
      default:
        return 'Anycubic';
    }
  }

  /// Vrai si l'échec vient d'un NFC désactivé sur l'appareil. Le natif renvoie
  /// le code "NFC_DISABLED" / message "NFC is disabled" (stable, contrôlé par
  /// nous), éventuellement enveloppé dans un message de brand.
  bool _isNfcDisabledFailure(Failure failure) {
    final m = failure.message.toLowerCase();
    return m.contains('nfc_disabled') || m.contains('nfc is disabled');
  }

  /// Vrai si le tag a été perdu/bougé pendant la lecture (Android : "Tag is out
  /// of date" / TagLostException). Best practice : inviter à re-taper sans bouger.
  bool _isTagMovedFailure(Failure failure) {
    final m = failure.message.toLowerCase();
    return m.contains('out of date') || m.contains('tag was lost') || m.contains('taglost');
  }

  /// Déduit le mode NFC à partir de la marque détectée
  String _detectModeFromBrand(String? brand) {
    switch (brand?.toLowerCase()) {
      case 'bambu lab':
        return 'bambu';
      case 'prusa':
        return 'prusa';
      case 'creality':
        return 'creality';
      default:
        return 'anycubic';
    }
  }

  Future<void> _onReadBobbinData(
    ReadBobbinDataEvent event,
    Emitter<NfcReaderState> emit,
  ) async {
    emit(const NfcReaderLoading());

    // Mode NFC : override (fallback B) ou préférence utilisateur
    final nfcMode = event.overrideMode ?? await UserPreferencesService.getNfcMode();

    final result = await readBobbinData(nfcMode: nfcMode);

    await result.fold(
      (failure) async {
        // Si l'utilisateur a annulé, revenir à l'état disponible sans erreur
        if (failure is NfcSessionCancelledFailure) {
          developer.log("ℹ️ [BLOC] Scan annulé par l'utilisateur");
          emit(const NfcAvailable());
          return;
        }

        // NFC désactivé : message dédié (pas d'erreur brute "NFC is disabled"),
        // et on ne tente pas le fallback auto-detect (inutile, échouera pareil).
        if (_isNfcDisabledFailure(failure)) {
          developer.log('📴 [BLOC] NFC désactivé sur appareil');
          unawaited(AnalyticsService.logNfcScan(
            scanType: 'scan_nfc', brand: _brandFromMode(nfcMode),
            success: false, errorMessage: 'NFC_DISABLED',
            nfcMode: nfcMode, entryPoint: event.entryPoint,
          ));
          emit(const NfcReaderFailure('', failureType: NfcFailureType.nfcDisabled));
          return;
        }

        // Tag bougé/perdu pendant la lecture : message dédié « retapez sans bouger »,
        // pas de fallback (le tag n'est plus dans le champ).
        if (_isTagMovedFailure(failure)) {
          developer.log('📴 [BLOC] Tag bougé pendant la lecture');
          unawaited(AnalyticsService.logNfcScan(
            scanType: 'scan_nfc', brand: _brandFromMode(nfcMode),
            success: false, errorMessage: 'TAG_MOVED',
            nfcMode: nfcMode, entryPoint: event.entryPoint,
          ));
          emit(const NfcReaderFailure('', failureType: NfcFailureType.tagMoved));
          return;
        }

        // Fallback A : si tag incompatible ou erreur de lecture, tenter auto-detect
        if (failure is NfcTagReadFailure || failure is NfcTagIncompatibleFailure) {
          developer.log('🔄 [BLOC] Échec mode $nfcMode, tentative auto-detect...');
          final fallbackResult = await readBobbinDataAutoDetect();
          final didFallback = fallbackResult.fold(
            (fallbackFailure) => false,
            (bobbinData) => true,
          );
          if (didFallback) {
            final bobbinData = fallbackResult.fold((_) => throw Exception(), (d) => d);
            final detectedMode = _detectModeFromBrand(bobbinData.brand);
            developer.log('✅ [BLOC] Fallback auto-detect réussi → mode $detectedMode');

            // Auto-save scan to history
            final scanHistory = ScanHistoryModel.fromBobbinData(bobbinData);
            await saveScanToHistory(scanHistory);

            // Analytics : tracker le fallback avec details complets
            unawaited(AnalyticsService.logNfcScan(
              scanType: 'scan_nfc_fallback',
              brand: bobbinData.brand,
              material: bobbinData.filamentType,
              color: bobbinData.color,
              success: true,
              nfcMode: detectedMode,
              entryPoint: event.entryPoint,
              weight: bobbinData.weightGrams,
              batchNumber: bobbinData.batchNumber,
              extruderTempMin: bobbinData.extruderTempMin,
              extruderTempMax: bobbinData.extruderTempMax,
              bedTempMin: bobbinData.bedTempMin,
              bedTempMax: bobbinData.bedTempMax,
            ));

            emit(BobbinDataReadSuccessWithFallback(
              bobbinData,
              detectedMode: detectedMode,
              originalMode: nfcMode,
            ));

            // Interstitiel + review
            AdMobService().onScanCompleted();
            unawaited(ReviewService().onSuccessfulScan());
            return;
          }
          developer.log('❌ [BLOC] Fallback auto-detect aussi échoué');
        }

        // Déterminer le type d'échec et extraire les diagnostics session
        var failureType = NfcFailureType.readError;
        int? sessionDurationMs;
        bool? tagWasDetected;

        if (failure is NfcTagNotDetectedFailure) {
          developer.log('⏱️ [BLOC] Tag non détecté (timeout)');
          failureType = NfcFailureType.tagNotDetected;
          sessionDurationMs = failure.sessionDurationMs;
          tagWasDetected = failure.tagWasDetected;
        } else if (failure is NfcTagIncompatibleFailure) {
          developer.log('📡 [BLOC] Tag incompatible détecté: ${failure.tagType}');
          failureType = NfcFailureType.incompatibleTag;
          sessionDurationMs = failure.sessionDurationMs;
          tagWasDetected = failure.tagWasDetected;
        } else if (failure is NfcAuthFailure) {
          developer.log('🔐 [BLOC] Échec authentification tag NFC');
          failureType = NfcFailureType.authError;
          sessionDurationMs = failure.sessionDurationMs;
          tagWasDetected = failure.tagWasDetected;
        } else if (failure is NfcTagReadFailure) {
          sessionDurationMs = failure.sessionDurationMs;
          tagWasDetected = failure.tagWasDetected;
        }

        // Log failed scan to backend with error details + session diagnostics
        unawaited(AnalyticsService.logNfcScan(
          scanType: 'scan_nfc',
          brand: _brandFromMode(nfcMode),
          success: false,
          errorMessage: failure.message,
          nfcMode: nfcMode,
          entryPoint: event.entryPoint,
          rawTagData: failure is NfcTagReadFailure ? failure.rawTagData : null,
          rawBytesCount: failure is NfcTagReadFailure ? failure.rawBytesCount : null,
          sessionDurationMs: sessionDurationMs,
          tagWasDetected: tagWasDetected,
        ));
        // Comptabiliser l'echec pour le garde-fou review
        unawaited(ReviewService().onFailedScan());

        emit(NfcReaderFailure(
          failure.message,
          rawTagData: failure is NfcTagReadFailure ? failure.rawTagData : null,
          rawBytesCount: failure is NfcTagReadFailure ? failure.rawBytesCount : 0,
          failureType: failureType,
        ));
      },
      (bobbinData) async {
        // Auto-save scan to history
        developer.log('💾 [BLOC] Auto-saving scan to history');
        final scanHistory = ScanHistoryModel.fromBobbinData(bobbinData);
        await saveScanToHistory(scanHistory);
        developer.log('✅ [BLOC] Scan auto-saved');

        // Log successful scan to backend with full details
        unawaited(AnalyticsService.logNfcScan(
          scanType: 'scan_nfc',
          brand: bobbinData.brand ?? _brandFromMode(nfcMode),
          material: bobbinData.filamentType,
          color: bobbinData.color,
          success: true,
          nfcMode: nfcMode,
          entryPoint: event.entryPoint,
          weight: bobbinData.weightGrams,
          batchNumber: bobbinData.batchNumber,
          tagFormat: bobbinData.batchNumber != null && RegExp(r'A[A-Z]{3,5}[A-Z]{2}-\d{3}').hasMatch(bobbinData.batchNumber!) ? 'anycubic_sku' : 'spool_nfc_writer',
          extruderTempMin: bobbinData.extruderTempMin,
          extruderTempMax: bobbinData.extruderTempMax,
          bedTempMin: bobbinData.bedTempMin,
          bedTempMax: bobbinData.bedTempMax,
        ));

        emit(BobbinDataReadSuccess(bobbinData));

        // Interstitiel tous les 4 scans
        AdMobService().onScanCompleted();

        // Demande d'avis apres 5 scans reussis
        unawaited(ReviewService().onSuccessfulScan());
      },
    );
  }

  Future<void> _onWriteBobbinData(
    WriteBobbinDataEvent event,
    Emitter<NfcReaderState> emit,
  ) async {
    developer.log('✍️ [BLOC] Événement WriteBobbinData reçu');
    emit(const NfcReaderLoading());

    final result = await writeBobbinData(event.bobbinData, tagFormat: event.tagFormat);

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

  Future<void> _onReadBobbinDataAutoDetect(
    ReadBobbinDataAutoDetectEvent event,
    Emitter<NfcReaderState> emit,
  ) async {
    emit(const NfcReaderLoading());

    final result = await readBobbinDataAutoDetect();

    await result.fold(
      (failure) async {
        if (failure is NfcSessionCancelledFailure) {
          emit(const NfcAvailable());
          return;
        }

        // NFC désactivé : message dédié localisé (pas d'erreur brute).
        if (_isNfcDisabledFailure(failure)) {
          developer.log('📴 [BLOC] NFC désactivé sur appareil (auto-detect)');
          unawaited(AnalyticsService.logNfcScan(
            scanType: 'scan_nfc_auto_detect', success: false,
            errorMessage: 'NFC_DISABLED', nfcMode: 'auto',
            entryPoint: event.entryPoint,
          ));
          emit(const NfcReaderFailure('', failureType: NfcFailureType.nfcDisabled));
          return;
        }

        if (_isTagMovedFailure(failure)) {
          developer.log('📴 [BLOC] Tag bougé pendant la lecture (auto-detect)');
          unawaited(AnalyticsService.logNfcScan(
            scanType: 'scan_nfc_auto_detect', success: false,
            errorMessage: 'TAG_MOVED', nfcMode: 'auto',
            entryPoint: event.entryPoint,
          ));
          emit(const NfcReaderFailure('', failureType: NfcFailureType.tagMoved));
          return;
        }

        var failureType = NfcFailureType.readError;
        int? sessionDurationMs;
        bool? tagWasDetected;

        if (failure is NfcTagNotDetectedFailure) {
          failureType = NfcFailureType.tagNotDetected;
          sessionDurationMs = failure.sessionDurationMs;
          tagWasDetected = failure.tagWasDetected;
        } else if (failure is NfcTagIncompatibleFailure) {
          failureType = NfcFailureType.incompatibleTag;
          sessionDurationMs = failure.sessionDurationMs;
          tagWasDetected = failure.tagWasDetected;
        } else if (failure is NfcAuthFailure) {
          failureType = NfcFailureType.authError;
          sessionDurationMs = failure.sessionDurationMs;
          tagWasDetected = failure.tagWasDetected;
        } else if (failure is NfcTagReadFailure) {
          sessionDurationMs = failure.sessionDurationMs;
          tagWasDetected = failure.tagWasDetected;
        }

        unawaited(AnalyticsService.logNfcScan(
          scanType: 'scan_nfc_auto_detect',
          success: false,
          errorMessage: failure.message,
          nfcMode: 'auto',
          entryPoint: event.entryPoint,
          sessionDurationMs: sessionDurationMs,
          tagWasDetected: tagWasDetected,
        ));

        emit(NfcReaderFailure(
          failure.message,
          failureType: failureType,
        ));
      },
      (bobbinData) async {
        developer.log('💾 [BLOC] Auto-detect scan success, saving to history');
        final scanHistory = ScanHistoryModel.fromBobbinData(bobbinData);
        await saveScanToHistory(scanHistory);

        unawaited(AnalyticsService.logNfcScan(
          scanType: 'scan_nfc_auto_detect',
          brand: bobbinData.brand,
          material: bobbinData.filamentType,
          color: bobbinData.color,
          success: true,
          nfcMode: 'auto',
          entryPoint: event.entryPoint,
          weight: bobbinData.weightGrams,
          batchNumber: bobbinData.batchNumber,
          extruderTempMin: bobbinData.extruderTempMin,
          extruderTempMax: bobbinData.extruderTempMax,
          bedTempMin: bobbinData.bedTempMin,
          bedTempMax: bobbinData.bedTempMax,
        ));

        emit(BobbinDataReadSuccess(bobbinData));
      },
    );
  }

  void _onStopNfcScan(StopNfcScanEvent event, Emitter<NfcReaderState> emit) {
    emit(const NfcReaderInitial());
  }
}
