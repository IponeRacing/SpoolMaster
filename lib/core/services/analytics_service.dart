import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service pour tracker les événements analytics
class AnalyticsService {
  static final AuthService _authService = AuthService();

  static String? _cachedAppVersion;
  static String? _cachedDeviceModel;
  static String? _cachedOsVersion;

  /// Identifiant d'installation anonyme (UUID v4 aléatoire, persistant, non-PII,
  /// réinitialisé à la réinstallation / effacement des données → GDPR-friendly).
  /// Permet de distinguer les invités (user_id null) et corréler leurs événements.
  static String? _installId;
  static String? get installId => _installId;

  static String _generateInstallId() {
    final r = Random.secure();
    final b = List<int>.generate(16, (_) => r.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40; // version 4
    b[8] = (b[8] & 0x3f) | 0x80; // variant
    final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }

  static Future<void> _loadInstallId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var id = prefs.getString('install_id');
      if (id == null || id.isEmpty) {
        id = _generateInstallId();
        await prefs.setString('install_id', id);
      }
      _installId = id;
    } catch (_) {
      _installId = null;
    }
  }

  /// Attache le contexte du scan en cours aux futurs crashes (custom keys
  /// Crashlytics). À appeler au démarrage d'un scan.
  static void setScanContext({required String nfcMode, String? entryPoint}) {
    try {
      FirebaseCrashlytics.instance.setCustomKey('nfc_mode', nfcMode);
      if (entryPoint != null) {
        FirebaseCrashlytics.instance.setCustomKey('entry_point', entryPoint);
      }
      FirebaseCrashlytics.instance.log('scan start: mode=$nfcMode entry=${entryPoint ?? "-"}');
    } catch (_) {}
  }

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

    await _loadInstallId();

    // Corrélation crash ↔ contexte : attache l'ID d'install + méta à Crashlytics.
    try {
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setUserIdentifier(_installId ?? 'unknown');
      await crashlytics.setCustomKey('install_id', _installId ?? 'unknown');
      await crashlytics.setCustomKey('platform', Platform.isIOS ? 'ios' : 'android');
      await crashlytics.setCustomKey('app_version', _cachedAppVersion ?? 'unknown');
      await crashlytics.setCustomKey('device_model', _cachedDeviceModel ?? 'unknown');
    } catch (_) {}
  }

  /// Log un événement analytics sur le backend
  static Future<void> logEvent(
    String eventType, {
    Map<String, dynamic>? eventData,
  }) async {
    try {
      final devicePlatform = Platform.isIOS ? 'ios' : 'android';
      final appVersion = _cachedAppVersion ?? 'unknown';

      // Envoie l'event même si l'utilisateur n'est pas connecté (invité) :
      // le backend accepte l'anonyme (user_id null). Ajoute le token si dispo.
      // Injecte l'ID d'install anonyme dans event_data (queryable via JSON,
      // pas de changement de schéma) → distingue les invités + corrélation.
      final enrichedData = <String, dynamic>{
        ...?eventData,
        'install_id': _installId,
      };

      final token = await _authService.getAccessToken();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logEvent}'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'event_type': eventType,
          'event_data': enrichedData,
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
    required String scanType,
    String? brand,
    String? material,
    String? color,
    bool? success,
    String? errorMessage,
    String? errorCode,
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
        // Code d'erreur normalisé (taxonomie) → agrégation propre, sans parser
        // le message libre. Ex: TAG_NOT_DETECTED, NFC_DISABLED, TAG_MOVED…
        if (errorCode != null) 'error_code': errorCode,
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
