import 'package:equatable/equatable.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

abstract class NfcReaderEvent extends Equatable {
  const NfcReaderEvent();

  @override
  List<Object?> get props => [];
}

class CheckNfcAvailabilityEvent extends NfcReaderEvent {
  const CheckNfcAvailabilityEvent();
}

class ReadNfcTagEvent extends NfcReaderEvent {
  const ReadNfcTagEvent();
}

class ReadBobbinDataEvent extends NfcReaderEvent {
  const ReadBobbinDataEvent();
}

class WriteBobbinDataEvent extends NfcReaderEvent {
  final BobbinData bobbinData;
  final String tagFormat;

  const WriteBobbinDataEvent(this.bobbinData, {this.tagFormat = 'anycubic'});

  @override
  List<Object?> get props => [bobbinData, tagFormat];
}

class ReadBobbinDataAutoDetectEvent extends NfcReaderEvent {
  const ReadBobbinDataAutoDetectEvent();
}

class StopNfcScanEvent extends NfcReaderEvent {
  const StopNfcScanEvent();
}
