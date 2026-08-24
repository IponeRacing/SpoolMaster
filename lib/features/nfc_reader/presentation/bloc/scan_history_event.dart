import 'package:equatable/equatable.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/scan_history.dart';

abstract class ScanHistoryEvent extends Equatable {
  const ScanHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadScanHistoryEvent extends ScanHistoryEvent {
  const LoadScanHistoryEvent();
}

class SaveScanEvent extends ScanHistoryEvent {

  const SaveScanEvent(this.scan);
  final ScanHistory scan;

  @override
  List<Object?> get props => [scan];
}

class DeleteScanEvent extends ScanHistoryEvent {

  const DeleteScanEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class ClearAllScansEvent extends ScanHistoryEvent {
  const ClearAllScansEvent();
}
