import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/data/datasources/nfc_datasource.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/bobbin_data_model.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/nfc_tag.dart';
import 'package:nfc_filament/features/nfc_reader/domain/repositories/nfc_repository.dart';

@LazySingleton(as: NfcRepository)
class NfcRepositoryImpl implements NfcRepository {

  NfcRepositoryImpl(this.dataSource);
  final NfcDataSource dataSource;

  @override
  Future<Either<Failure, bool>> isNfcAvailable() async {
    try {
      final isAvailable = await dataSource.isNfcAvailable();
      return Right(isAvailable);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      developer.log('❌ isNfcAvailable error: $e\n${e is Error ? e.stackTrace : ""}');
      return const Left(NfcNotAvailableFailure());
    }
  }

  @override
  Future<Either<Failure, NfcTag>> readNfcTag() async {
    try {
      final tagModel = await dataSource.readNfcTag();
      return Right(tagModel.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      developer.log('❌ readNfcTag unexpected error: $e\n${e is Error ? e.stackTrace : ""}');
      return const Left(NfcTagReadFailure());
    }
  }

  @override
  Future<Either<Failure, BobbinData>> readBobbinData({String? nfcMode}) async {
    try {
      final bobbinModel = await dataSource.readBobbinData(nfcMode: nfcMode);
      return Right(bobbinModel.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } on PlatformException catch (e) {
      final diag = _extractDiagnostics(e.details);
      // Gérer l'annulation par l'utilisateur
      if (e.code == 'USER_CANCELLED') {
        return const Left(NfcSessionCancelledFailure());
      }
      // Tag non détecté (timeout)
      if (e.code == 'TAG_NOT_DETECTED') {
        return Left(NfcTagNotDetectedFailure(
          message: e.message ?? 'Aucun tag NFC détecté',
          sessionDurationMs: diag.sessionDurationMs,
          tagWasDetected: diag.tagWasDetected,
        ));
      }
      // Tag incompatible détecté (ISO 15693, FeliCa, etc.)
      if (e.code == 'INCOMPATIBLE_TAG') {
        return Left(NfcTagIncompatibleFailure(
          message: e.message ?? 'Tag NFC incompatible',
          tagType: diag.tagType,
          sessionDurationMs: diag.sessionDurationMs,
          tagWasDetected: diag.tagWasDetected,
        ));
      }
      // MiFare Classic non supporté sur iOS (Bambu Lab, Creality)
      if (e.code == 'PLATFORM_NOT_SUPPORTED') {
        return Left(NfcTagIncompatibleFailure(
          message: e.message ?? 'Non supporté sur cette plateforme',
        ));
      }
      // Authentification MiFare Classic échouée (Creality/Bambu Lab)
      if (e.code == 'AUTH_ERROR') {
        return Left(NfcAuthFailure(
          message: e.message ?? 'Authentification tag NFC échouée',
          sessionDurationMs: diag.sessionDurationMs,
          tagWasDetected: diag.tagWasDetected,
        ));
      }
      // Session interrompue par iOS (code 202) - retryable
      if (e.code == 'SESSION_TERMINATED') {
        return Left(NfcTagReadFailure(
          message: e.message ?? 'Session NFC interrompue. Réessayez.',
          sessionDurationMs: diag.sessionDurationMs,
          tagWasDetected: diag.tagWasDetected,
        ));
      }
      // Système NFC occupé (code 203) - retryable
      if (e.code == 'SYSTEM_BUSY') {
        return Left(NfcTagReadFailure(
          message: e.message ?? 'Lecteur NFC occupé. Réessayez.',
          sessionDurationMs: diag.sessionDurationMs,
          tagWasDetected: diag.tagWasDetected,
        ));
      }
      return Left(NfcTagReadFailure(
        message: e.message ?? 'Erreur NFC',
        sessionDurationMs: diag.sessionDurationMs,
        tagWasDetected: diag.tagWasDetected,
      ));
    } catch (e) {
      developer.log('❌ readBobbinData unexpected error: $e\n${e is Error ? e.stackTrace : ""}');
      return const Left(NfcTagReadFailure());
    }
  }

  @override
  Future<Either<Failure, BobbinData>> readBobbinDataAutoDetect() async {
    try {
      final bobbinModel = await dataSource.readBobbinDataAutoDetect();
      return Right(bobbinModel.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } on PlatformException catch (e) {
      final diag = _extractDiagnostics(e.details);
      if (e.code == 'USER_CANCELLED') {
        return const Left(NfcSessionCancelledFailure());
      }
      if (e.code == 'TAG_NOT_DETECTED') {
        return Left(NfcTagNotDetectedFailure(
          message: e.message ?? 'Aucun tag NFC détecté',
          sessionDurationMs: diag.sessionDurationMs,
          tagWasDetected: diag.tagWasDetected,
        ));
      }
      if (e.code == 'INCOMPATIBLE_TAG') {
        return Left(NfcTagIncompatibleFailure(
          message: e.message ?? 'Tag NFC incompatible',
          tagType: diag.tagType,
          sessionDurationMs: diag.sessionDurationMs,
          tagWasDetected: diag.tagWasDetected,
        ));
      }
      if (e.code == 'PLATFORM_NOT_SUPPORTED') {
        return Left(NfcTagIncompatibleFailure(
          message: e.message ?? 'Non supporté sur cette plateforme',
        ));
      }
      if (e.code == 'AUTH_ERROR') {
        return Left(NfcAuthFailure(
          message: e.message ?? 'Authentification tag NFC échouée',
          sessionDurationMs: diag.sessionDurationMs,
          tagWasDetected: diag.tagWasDetected,
        ));
      }
      if (e.code == 'SESSION_TERMINATED') {
        return Left(NfcTagReadFailure(
          message: e.message ?? 'Session NFC interrompue. Réessayez.',
          sessionDurationMs: diag.sessionDurationMs,
          tagWasDetected: diag.tagWasDetected,
        ));
      }
      if (e.code == 'SYSTEM_BUSY') {
        return Left(NfcTagReadFailure(
          message: e.message ?? 'Lecteur NFC occupé. Réessayez.',
          sessionDurationMs: diag.sessionDurationMs,
          tagWasDetected: diag.tagWasDetected,
        ));
      }
      return Left(NfcTagReadFailure(
        message: e.message ?? 'Erreur NFC',
        sessionDurationMs: diag.sessionDurationMs,
        tagWasDetected: diag.tagWasDetected,
      ));
    } catch (e) {
      developer.log('❌ readBobbinDataAutoDetect unexpected error: $e\n${e is Error ? e.stackTrace : ""}');
      return const Left(NfcTagReadFailure());
    }
  }

  @override
  Future<Either<Failure, void>> writeBobbinData(BobbinData data, {String tagFormat = 'anycubic'}) async {
    try {
      // Utiliser fromEntity pour copier TOUS les champs (colorRgb, températures, etc.)
      final bobbinModel = BobbinDataModel.fromEntity(data);
      await dataSource.writeBobbinData(bobbinModel, tagFormat: tagFormat);
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      developer.log('❌ writeBobbinData unexpected error: $e\n${e is Error ? e.stackTrace : ""}');
      return const Left(
        NfcTagReadFailure(message: "Erreur lors de l'écriture du tag NFC"),
      );
    }
  }

  /// Extraire les données de diagnostic depuis e.details (Map ou String)
  _NfcDiagnostics _extractDiagnostics(dynamic details) {
    if (details is Map) {
      return _NfcDiagnostics(
        tagType: details['tag_type'] as String?,
        sessionDurationMs: details['session_duration_ms'] as int?,
        tagWasDetected: details['tag_was_detected'] as bool?,
      );
    }
    // Legacy: details was a plain String (e.g. tag type for INCOMPATIBLE_TAG)
    if (details is String) {
      return _NfcDiagnostics(tagType: details);
    }
    return const _NfcDiagnostics();
  }
}

class _NfcDiagnostics {
  const _NfcDiagnostics({
    this.tagType,
    this.sessionDurationMs,
    this.tagWasDetected,
  });

  final String? tagType;
  final int? sessionDurationMs;
  final bool? tagWasDetected;
}
