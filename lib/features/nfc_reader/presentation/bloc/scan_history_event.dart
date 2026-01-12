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
  final ScanHistory scan;

  const SaveScanEvent(this.scan);

  @override
  List<Object?> get props => [scan];
}

class DeleteScanEvent extends ScanHistoryEvent {
  final String id;

  const DeleteScanEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearAllScansEvent extends ScanHistoryEvent {
  const ClearAllScansEvent();
}
