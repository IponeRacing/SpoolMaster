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
  final NfcDataSource dataSource;

  NfcRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, bool>> isNfcAvailable() async {
    try {
      final isAvailable = await dataSource.isNfcAvailable();
      return Right(isAvailable);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
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
      return const Left(NfcTagReadFailure());
    }
  }

  @override
  Future<Either<Failure, BobbinData>> readBobbinData() async {
    try {
      final bobbinModel = await dataSource.readBobbinData();
      return Right(bobbinModel.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } on PlatformException catch (e) {
      // Gérer l'annulation par l'utilisateur
      if (e.code == 'USER_CANCELLED') {
        return const Left(NfcSessionCancelledFailure());
      }
      // Tag non détecté (timeout)
      if (e.code == 'TAG_NOT_DETECTED') {
        return Left(NfcTagNotDetectedFailure(e.message ?? 'Aucun tag NFC détecté'));
      }
      // Tag incompatible détecté (ISO 15693, FeliCa, etc.)
      if (e.code == 'INCOMPATIBLE_TAG') {
        return Left(NfcTagIncompatibleFailure(
          e.message ?? 'Tag NFC incompatible',
          e.details as String?,
        ));
      }
      // Session interrompue par iOS (code 202) - retryable
      if (e.code == 'SESSION_TERMINATED') {
        return Left(NfcTagReadFailure(e.message ?? 'Session NFC interrompue. Réessayez.'));
      }
      // Système NFC occupé (code 203) - retryable
      if (e.code == 'SYSTEM_BUSY') {
        return Left(NfcTagReadFailure(e.message ?? 'Lecteur NFC occupé. Réessayez.'));
      }
      return Left(NfcTagReadFailure(e.message ?? 'Erreur NFC'));
    } catch (e) {
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
      if (e.code == 'USER_CANCELLED') {
        return const Left(NfcSessionCancelledFailure());
      }
      if (e.code == 'TAG_NOT_DETECTED') {
        return Left(NfcTagNotDetectedFailure(e.message ?? 'Aucun tag NFC détecté'));
      }
      if (e.code == 'INCOMPATIBLE_TAG') {
        return Left(NfcTagIncompatibleFailure(
          e.message ?? 'Tag NFC incompatible',
          e.details as String?,
        ));
      }
      if (e.code == 'SESSION_TERMINATED') {
        return Left(NfcTagReadFailure(e.message ?? 'Session NFC interrompue. Réessayez.'));
      }
      if (e.code == 'SYSTEM_BUSY') {
        return Left(NfcTagReadFailure(e.message ?? 'Lecteur NFC occupé. Réessayez.'));
      }
      return Left(NfcTagReadFailure(e.message ?? 'Erreur NFC'));
    } catch (e) {
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
      return const Left(
        NfcTagReadFailure('Erreur lors de l\'écriture du tag NFC'),
      );
    }
  }
}
