import 'package:dartz/dartz.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/scan_history.dart';

abstract class ScanHistoryRepository {
  /// Save a scan to history
  Future<Either<Failure, void>> saveScan(ScanHistory scan);

  /// Get all scans from history
  Future<Either<Failure, List<ScanHistory>>> getAllScans();

  /// Delete a scan by ID
  Future<Either<Failure, void>> deleteScan(String id);

  /// Clear all scans
  Future<Either<Failure, void>> clearAllScans();
}
