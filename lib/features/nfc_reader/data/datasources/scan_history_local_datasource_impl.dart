import 'dart:convert';
import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/features/nfc_reader/data/datasources/scan_history_local_datasource.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/scan_history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: ScanHistoryLocalDataSource)
class ScanHistoryLocalDataSourceImpl implements ScanHistoryLocalDataSource {

  ScanHistoryLocalDataSourceImpl(this.sharedPreferences);
  static const String _storageKeyPrefix = 'scan_history';

  final SharedPreferences sharedPreferences;

  /// Get storage key scoped by user_id
  Future<String> _getStorageKey() async {
    final authService = AuthService();
    final userId = await authService.getCurrentUserId();
    if (userId == null) {
      // Fallback to non-scoped key for local mode
      return _storageKeyPrefix;
    }
    return '${_storageKeyPrefix}_$userId';
  }

  @override
  Future<void> saveScan(ScanHistoryModel scan) async {
    try {
      developer.log('💾 [DATASOURCE] Saving scan with ID: ${scan.id}');

      final scans = await getAllScans();
      scans.insert(0, scan); // Add to beginning for chronological order

      // Keep only last 100 scans
      if (scans.length > 100) {
        scans.removeRange(100, scans.length);
      }

      final jsonList = scans.map((s) => s.toJson()).toList();
      final jsonString = json.encode(jsonList);

      final storageKey = await _getStorageKey();
      await sharedPreferences.setString(storageKey, jsonString);
      developer.log('✅ [DATASOURCE] Scan saved successfully');
    } catch (e) {
      developer.log('❌ [DATASOURCE] Error saving scan: $e');
      rethrow;
    }
  }

  @override
  Future<List<ScanHistoryModel>> getAllScans() async {
    try {
      developer.log('📖 [DATASOURCE] Loading all scans');

      final storageKey = await _getStorageKey();
      final jsonString = sharedPreferences.getString(storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        developer.log('📭 [DATASOURCE] No scans found');
        return [];
      }

      final jsonList = json.decode(jsonString) as List<dynamic>;
      final scans = jsonList
          .map(
            (json) => ScanHistoryModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      developer.log('✅ [DATASOURCE] Loaded ${scans.length} scans');
      return scans;
    } catch (e) {
      developer.log('❌ [DATASOURCE] Error loading scans: $e');
      return [];
    }
  }

  @override
  Future<void> deleteScan(String id) async {
    try {
      developer.log('🗑️ [DATASOURCE] Deleting scan with ID: $id');

      final scans = await getAllScans();
      scans.removeWhere((scan) => scan.id == id);

      final jsonList = scans.map((s) => s.toJson()).toList();
      final jsonString = json.encode(jsonList);

      final storageKey = await _getStorageKey();
      await sharedPreferences.setString(storageKey, jsonString);
      developer.log('✅ [DATASOURCE] Scan deleted successfully');
    } catch (e) {
      developer.log('❌ [DATASOURCE] Error deleting scan: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearAllScans() async {
    try {
      developer.log('🧹 [DATASOURCE] Clearing all scans');
      final storageKey = await _getStorageKey();
      await sharedPreferences.remove(storageKey);
      developer.log('✅ [DATASOURCE] All scans cleared');
    } catch (e) {
      developer.log('❌ [DATASOURCE] Error clearing scans: $e');
      rethrow;
    }
  }
}
