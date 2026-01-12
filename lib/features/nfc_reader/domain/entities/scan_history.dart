import 'package:equatable/equatable.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';

class ScanHistory extends Equatable {
  const ScanHistory({
    required this.id,
    required this.timestamp,
    required this.bobbinData,
  });

  final String id;
  final DateTime timestamp;
  final BobbinData bobbinData;

  @override
  List<Object?> get props => [id, timestamp, bobbinData];
}
