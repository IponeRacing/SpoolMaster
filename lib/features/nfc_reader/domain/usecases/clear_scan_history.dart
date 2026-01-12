import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/domain/repositories/scan_history_repository.dart';

@injectable
class ClearScanHistory {
  final ScanHistoryRepository repository;

  ClearScanHistory(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.clearAllScans();
  }
}
