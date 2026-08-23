import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service pour tracker les événements analytics
class AnalyticsService {
  static final AuthService _authService = AuthService();

  static String? _cachedAppVersion;
  static String? _cachedDeviceModel;
  static String? _cachedOsVersion;

  /// Initialize device and app info (call once at startup)
  static Future<void> initialize() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _cachedAppVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (_) {
      _cachedAppVersion = 'unknown';
    }

    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final ios = await deviceInfo.iosInfo;
        _cachedDeviceModel = ios.utsname.machine;
        _cachedOsVersion = 'iOS ${ios.systemVersion}';
      } else if (Platform.isAndroid) {
        final android = await deviceInfo.androidInfo;
        _cachedDeviceModel = '${android.manufacturer} ${android.model}';
        _cachedOsVersion = 'Android ${android.version.release} (SDK ${android.version.sdkInt})';
      }
    } catch (_) {
      _cachedDeviceModel = 'unknown';
      _cachedOsVersion = 'unknown';
    }
  }

  /// Log un événement analytics sur le backend
  static Future<void> logEvent(
    String eventType, {
    Map<String, dynamic>? eventData,
  }) async {
    try {
      final devicePlatform = Platform.isIOS ? 'ios' : 'android';
      final appVersion = _cachedAppVersion ?? 'unknown';

      final response = await _authService.authenticatedRequest((token) =>
        http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logEvent}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'event_type': eventType,
            'event_data': eventData,
            'device_platform': devicePlatform,
            'app_version': appVersion,
          }),
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ [Analytics] Event logged: $eventType');
      } else {
        debugPrint('❌ [Analytics] Failed to log event: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ [Analytics] Error logging event: $e');
      // Ne pas bloquer l'app si analytics échoue
    }
  }

  /// Log un scan NFC
  static Future<void> logNfcScan({
    required String scanType,
    String? brand,
    String? material,
    String? color,
    bool? success,
    String? errorMessage,
    String? rawTagData,
    int? rawBytesCount,
    String? nfcMode,
    String? entryPoint,
    int? sessionDurationMs,
    bool? tagWasDetected,
    double? weight,
    String? batchNumber,
    String? tagFormat,
    int? extruderTempMin,
    int? extruderTempMax,
    int? bedTempMin,
    int? bedTempMax,
  }) async {
    await logEvent(
      scanType,
      eventData: {
        'brand': brand,
        'material': material,
        'color': color,
        'success': success,
        'timestamp': DateTime.now().toIso8601String(),
        'nfc_mode': nfcMode ?? '',
        // Écran d'où le scan a été lancé (home / add_spool / stock_update /
        // wishlist) — clé pour attribuer un échec à un parcours UI précis.
        if (entryPoint != null) 'entry_point': entryPoint,
        'error_message': errorMessage ?? '',
        if (rawTagData != null) 'raw_tag_data': rawTagData,
        if (rawBytesCount != null) 'raw_bytes_count': rawBytesCount,
        if (sessionDurationMs != null) 'session_duration_ms': sessionDurationMs,
        if (tagWasDetected != null) 'tag_was_detected': tagWasDetected,
        if (weight != null) 'weight': weight,
        if (batchNumber != null && batchNumber.isNotEmpty) 'batch_number': batchNumber,
        if (tagFormat != null) 'tag_format': tagFormat,
        if (extruderTempMin != null) 'extruder_temp_min': extruderTempMin,
        if (extruderTempMax != null) 'extruder_temp_max': extruderTempMax,
        if (bedTempMin != null) 'bed_temp_min': bedTempMin,
        if (bedTempMax != null) 'bed_temp_max': bedTempMax,
        'device_model': _cachedDeviceModel ?? '',
        'os_version': _cachedOsVersion ?? '',
      },
    );
  }

  /// Log un feedback utilisateur après un scan échoué
  static Future<void> logScanFeedback({
    required String brand,
    required String material,
    required String color,
    String? rawTagData,
    int? rawBytesCount,
    String? errorMessage,
    String? nfcMode,
    String? weight,
    String? extruderTempMin,
    String? extruderTempMax,
    String? bedTempMin,
    String? bedTempMax,
    String? diameter,
    String? spoolLength,
    String? batchNumber,
  }) async {
    await logEvent(
      'scan_feedback',
      eventData: {
        'brand': brand,
        'material': material,
        'color': color,
        'raw_tag_data': rawTagData,
        'raw_bytes_count': rawBytesCount,
        'error_message': errorMessage,
        'nfc_mode': nfcMode,
        'timestamp': DateTime.now().toIso8601String(),
        if (weight != null && weight.isNotEmpty) 'weight': weight,
        if (extruderTempMin != null && extruderTempMin.isNotEmpty) 'extruder_temp_min': extruderTempMin,
        if (extruderTempMax != null && extruderTempMax.isNotEmpty) 'extruder_temp_max': extruderTempMax,
        if (bedTempMin != null && bedTempMin.isNotEmpty) 'bed_temp_min': bedTempMin,
        if (bedTempMax != null && bedTempMax.isNotEmpty) 'bed_temp_max': bedTempMax,
        if (diameter != null && diameter.isNotEmpty) 'diameter': diameter,
        if (spoolLength != null && spoolLength.isNotEmpty) 'spool_length': spoolLength,
        if (batchNumber != null && batchNumber.isNotEmpty) 'batch_number': batchNumber,
      },
    );
  }

  /// Récupérer l'historique des scans depuis le backend
  static Future<List<Map<String, dynamic>>> getScans({int limit = 50, int offset = 0}) async {
    try {
      final response = await _authService.authenticatedRequest((token) =>
        http.get(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getScans}?limit=$limit&offset=$offset'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final dataList = (data['data'] as List<dynamic>?) ?? [];
        return dataList.map((e) => e as Map<String, dynamic>).toList();
      } else {
        debugPrint('❌ [Analytics] Failed to get scans: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ [Analytics] Error getting scans: $e');
      return [];
    }
  }

  /// Récupérer les statistiques des scans depuis le backend
  static Future<Map<String, dynamic>?> getStats() async {
    try {
      final response = await _authService.authenticatedRequest((token) =>
        http.get(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getStats}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ).timeout(ApiConfig.connectTimeout),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data['data'] as Map<String, dynamic>?;
      } else {
        debugPrint('❌ [Analytics] Failed to get stats: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ [Analytics] Error getting stats: $e');
      return null;
    }
  }
}
