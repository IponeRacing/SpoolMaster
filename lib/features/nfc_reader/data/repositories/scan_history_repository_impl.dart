import 'dart:developer' as developer;

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/data/datasources/scan_history_local_datasource.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/scan_history_model.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/scan_history.dart';
import 'package:nfc_filament/features/nfc_reader/domain/repositories/scan_history_repository.dart';

@LazySingleton(as: ScanHistoryRepository)
class ScanHistoryRepositoryImpl implements ScanHistoryRepository {
  final ScanHistoryLocalDataSource localDataSource;

  ScanHistoryRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> saveScan(ScanHistory scan) async {
    try {
      developer.log('💾 [REPOSITORY] Saving scan');

      final model = scan is ScanHistoryModel
          ? scan
          : ScanHistoryModel(
              id: scan.id,
              timestamp: scan.timestamp,
              bobbinData: scan.bobbinData,
            );

      await localDataSource.saveScan(model);
      return const Right(null);
    } catch (e) {
      developer.log('❌ [REPOSITORY] Error saving scan: $e');
      return const Left(CacheFailure('Erreur lors de la sauvegarde du scan'));
    }
  }

  @override
  Future<Either<Failure, List<ScanHistory>>> getAllScans() async {
    try {
      developer.log('📖 [REPOSITORY] Getting all scans');
      final scans = await localDataSource.getAllScans();
      return Right(scans);
    } catch (e) {
      developer.log('❌ [REPOSITORY] Error getting scans: $e');
      return const Left(
        CacheFailure('Erreur lors de la récupération des scans'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteScan(String id) async {
    try {
      developer.log('🗑️ [REPOSITORY] Deleting scan: $id');
      await localDataSource.deleteScan(id);
      return const Right(null);
    } catch (e) {
      developer.log('❌ [REPOSITORY] Error deleting scan: $e');
      return const Left(CacheFailure('Erreur lors de la suppression du scan'));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllScans() async {
    try {
      developer.log('🧹 [REPOSITORY] Clearing all scans');
      await localDataSource.clearAllScans();
      return const Right(null);
    } catch (e) {
      developer.log('❌ [REPOSITORY] Error clearing scans: $e');
      return const Left(
        CacheFailure('Erreur lors de la suppression des scans'),
      );
    }
  }
}
