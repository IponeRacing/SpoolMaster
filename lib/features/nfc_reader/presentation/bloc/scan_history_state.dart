import 'package:equatable/equatable.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/scan_history.dart';

abstract class ScanHistoryState extends Equatable {
  const ScanHistoryState();

  @override
  List<Object?> get props => [];
}

class ScanHistoryInitial extends ScanHistoryState {
  const ScanHistoryInitial();
}

class ScanHistoryLoading extends ScanHistoryState {
  const ScanHistoryLoading();
}

class ScanHistoryLoaded extends ScanHistoryState {
  final List<ScanHistory> scans;

  const ScanHistoryLoaded(this.scans);

  @override
  List<Object?> get props => [scans];
}

class ScanHistoryEmpty extends ScanHistoryState {
  const ScanHistoryEmpty();
}

class ScanHistoryError extends ScanHistoryState {
  final String message;

  const ScanHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class ScanSaved extends ScanHistoryState {
  const ScanSaved();
}

class ScanDeleted extends ScanHistoryState {
  const ScanDeleted();
}
