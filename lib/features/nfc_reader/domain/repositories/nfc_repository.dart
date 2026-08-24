import 'package:dartz/dartz.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/nfc_tag.dart';

abstract class NfcRepository {
  /// Check if NFC is available on the device
  Future<Either<Failure, bool>> isNfcAvailable();

  /// Read an NFC tag and return its raw data
  Future<Either<Failure, NfcTag>> readNfcTag();

  /// Read an NFC tag and parse bobbin data
  /// [nfcMode] overrides the saved user preference if provided
  Future<Either<Failure, BobbinData>> readBobbinData({String? nfcMode});

  /// Read an NFC tag with auto-detection of tag type
  Future<Either<Failure, BobbinData>> readBobbinDataAutoDetect();

  /// Write bobbin data to an NFC tag
  Future<Either<Failure, void>> writeBobbinData(BobbinData data, {String tagFormat = 'anycubic'});
}
