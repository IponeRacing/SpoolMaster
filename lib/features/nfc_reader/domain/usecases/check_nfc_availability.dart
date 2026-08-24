import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/domain/repositories/nfc_repository.dart';

@lazySingleton
class CheckNfcAvailability {

  CheckNfcAvailability(this.repository);
  final NfcRepository repository;

  Future<Either<Failure, bool>> call() async {
    return repository.isNfcAvailable();
  }
}
