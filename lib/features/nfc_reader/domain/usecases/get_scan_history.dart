import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/scan_history.dart';
import 'package:nfc_filament/features/nfc_reader/domain/repositories/scan_history_repository.dart';

@injectable
class GetScanHistory {
  final ScanHistoryRepository repository;

  GetScanHistory(this.repository);

  Future<Either<Failure, List<ScanHistory>>> call() async {
    return await repository.getAllScans();
  }
}
