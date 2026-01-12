import 'package:dartz/dartz.dart';
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
    } catch (e) {
      return const Left(NfcTagReadFailure());
    }
  }

  @override
  Future<Either<Failure, void>> writeBobbinData(BobbinData data) async {
    try {
      final bobbinModel = BobbinDataModel(
        filamentType: data.filamentType,
        color: data.color,
        weightGrams: data.weightGrams,
        manufactureDate: data.manufactureDate,
        batchNumber: data.batchNumber,
      );
      await dataSource.writeBobbinData(bobbinModel);
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
