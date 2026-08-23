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
  const ReadBobbinDataEvent({this.overrideMode, this.entryPoint});

  final String? overrideMode;

  /// Écran d'où le scan est lancé (home / add_spool / stock_update / wishlist),
  /// enregistré dans l'analytics pour attribuer un échec à un parcours précis.
  final String? entryPoint;

  @override
  List<Object?> get props => [overrideMode, entryPoint];
}

class WriteBobbinDataEvent extends NfcReaderEvent {

  const WriteBobbinDataEvent(this.bobbinData, {this.tagFormat = 'anycubic'});
  final BobbinData bobbinData;
  final String tagFormat;

  @override
  List<Object?> get props => [bobbinData, tagFormat];
}

class ReadBobbinDataAutoDetectEvent extends NfcReaderEvent {
  const ReadBobbinDataAutoDetectEvent({this.entryPoint});

  /// Écran d'où le scan auto-detect est lancé (home / add_spool / stock_update).
  final String? entryPoint;

  @override
  List<Object?> get props => [entryPoint];
}

class StopNfcScanEvent extends NfcReaderEvent {
  const StopNfcScanEvent();
}
