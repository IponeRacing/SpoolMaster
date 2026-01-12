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
  final String message;

  const NfcNotAvailable(this.message);

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
  final NfcTag tag;

  const NfcTagReadSuccess(this.tag);

  @override
  List<Object?> get props => [tag];
}

class BobbinDataReadSuccess extends NfcReaderState {
  final BobbinData bobbinData;

  const BobbinDataReadSuccess(this.bobbinData);

  @override
  List<Object?> get props => [bobbinData];
}

class BobbinDataWriteSuccess extends NfcReaderState {
  const BobbinDataWriteSuccess();
}

class NfcReaderFailure extends NfcReaderState {
  final String message;

  const NfcReaderFailure(this.message);

  @override
  List<Object?> get props => [message];
}
