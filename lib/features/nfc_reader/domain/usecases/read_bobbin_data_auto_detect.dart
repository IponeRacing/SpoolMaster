import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/domain/repositories/nfc_repository.dart';

@lazySingleton
class ReadBobbinDataAutoDetect {
  final NfcRepository repository;

  ReadBobbinDataAutoDetect(this.repository);

  Future<Either<Failure, BobbinData>> call() async {
    return repository.readBobbinDataAutoDetect();
  }
}
