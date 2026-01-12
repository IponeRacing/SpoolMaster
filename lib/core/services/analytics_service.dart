import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:package_info_plus/package_info_plus.dart';

/// Service pour tracker les événements analytics
class AnalyticsService {
  static final AuthService _authService = AuthService();

  /// Log un événement analytics sur le backend
  static Future<void> logEvent(
    String eventType, {
    Map<String, dynamic>? eventData,
  }) async {
    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        debugPrint('❌ [Analytics] No access token, skipping event: $eventType');
        return;
      }

      // Récupérer les infos du device
      final devicePlatform = Platform.isIOS ? 'ios' : 'android';
      // final packageInfo = await PackageInfo.fromPlatform();
      final appVersion = '1.0.0'; // packageInfo.version;

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logEvent}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'event_type': eventType,
          'event_data': eventData,
          'device_platform': devicePlatform,
          'app_version': appVersion,
        }),
      ).timeout(ApiConfig.connectTimeout);

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
    required String scanType, // 'scan_nfc', 'scan_add_spool', 'scan_update_stock'
    String? brand,
    String? material,
    String? color,
    bool? success,
  }) async {
    await logEvent(
      scanType,
      eventData: {
        'brand': brand,
        'material': material,
        'color': color,
        'success': success,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Récupérer l'historique des scans depuis le backend
  static Future<List<Map<String, dynamic>>> getScans({int limit = 50}) async {
    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        debugPrint('❌ [Analytics] No access token');
        return [];
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getScans}?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(ApiConfig.connectTimeout);

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
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        debugPrint('❌ [Analytics] No access token');
        return null;
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getStats}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
