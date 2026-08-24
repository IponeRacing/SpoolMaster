import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/domain/repositories/nfc_repository.dart';

@injectable
class WriteBobbinData {

  WriteBobbinData(this.repository);
  final NfcRepository repository;

  Future<Either<Failure, void>> call(BobbinData bobbinData, {String tagFormat = 'anycubic'}) async {
    return repository.writeBobbinData(bobbinData, tagFormat: tagFormat);
  }
}
