import 'package:equatable/equatable.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/nfc_tag.dart';

abstract class NfcReaderState extends Equatable {
  const NfcReaderState();

  @override
  List<Object?> get props => [];
}

class NfcReaderInitial extends NfcReaderState {
  const NfcReaderInitial();
}

class NfcNotAvailable extends NfcReaderState {

  const NfcNotAvailable(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class NfcAvailable extends NfcReaderState {
  const NfcAvailable();
}

class NfcReaderLoading extends NfcReaderState {
  const NfcReaderLoading();
}

class NfcTagReadSuccess extends NfcReaderState {

  const NfcTagReadSuccess(this.tag);
  final NfcTag tag;

  @override
  List<Object?> get props => [tag];
}

class BobbinDataReadSuccess extends NfcReaderState {

  const BobbinDataReadSuccess(this.bobbinData);
  final BobbinData bobbinData;

  @override
  List<Object?> get props => [bobbinData];
}

class BobbinDataReadSuccessWithFallback extends NfcReaderState {
  const BobbinDataReadSuccessWithFallback(this.bobbinData, {required this.detectedMode, required this.originalMode});

  final BobbinData bobbinData;
  final String detectedMode;
  final String originalMode;

  @override
  List<Object?> get props => [bobbinData, detectedMode, originalMode];
}

class BobbinDataWriteSuccess extends NfcReaderState {
  const BobbinDataWriteSuccess();
}

class NfcReaderFailure extends NfcReaderState {
  const NfcReaderFailure(this.message, {this.rawTagData, this.rawBytesCount = 0, this.failureType = NfcFailureType.readError});

  final String message;
  final String? rawTagData;
  final int rawBytesCount;
  final NfcFailureType failureType;

  bool get hasTagData => rawTagData != null && rawBytesCount > 0;

  @override
  List<Object?> get props => [message, rawTagData, rawBytesCount, failureType];
}

enum NfcFailureType {
  readError,
  tagNotDetected,
  incompatibleTag,
  authError,
}
