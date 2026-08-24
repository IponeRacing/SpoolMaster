import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/nfc_tag.dart';
import 'package:nfc_filament/features/nfc_reader/domain/repositories/nfc_repository.dart';

@lazySingleton
class ReadNfcTag {

  ReadNfcTag(this.repository);
  final NfcRepository repository;

  Future<Either<Failure, NfcTag>> call() async {
    return repository.readNfcTag();
  }
}
