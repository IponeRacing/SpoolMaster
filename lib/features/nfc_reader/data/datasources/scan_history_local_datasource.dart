import 'package:nfc_filament/features/nfc_reader/data/models/scan_history_model.dart';

abstract class ScanHistoryLocalDataSource {
  /// Save a scan to local storage
  Future<void> saveScan(ScanHistoryModel scan);

  /// Get all scans from local storage
  Future<List<ScanHistoryModel>> getAllScans();

  /// Delete a scan by ID
  Future<void> deleteScan(String id);

  /// Clear all scans
  Future<void> clearAllScans();
}
