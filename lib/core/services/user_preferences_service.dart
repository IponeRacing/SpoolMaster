import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/services/auth_service.dart';

class UserPreferencesService {
  static const String _keyLanguage = 'user_language';
  static const String _keyCurrency = 'user_currency';
  static const String _keyUnits = 'user_units';
  static const String _keyIsSignedIn = 'user_is_signed_in';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyLowStockThreshold = 'low_stock_threshold';
  static const String _keyNfcMode = 'nfc_mode'; // 'anycubic' ou 'bambu'
  static const String _keyIsPremium = 'is_premium'; // Statut abonnement premium

  // Langues supportées
  static const List<String> supportedLanguages = [
    'fr', 'en', 'de', 'it', 'es', 'nl', 'pl', 'cs', 'pt', 'ru', 'ja', 'ko', 'zh', 'sv', 'tr',
    'ro', 'hu', 'el', 'bg', 'hr', 'sk', 'sl', 'sr', 'uk', 'da', 'no', 'fi', 'th', 'vi', 'id', 'ms', 'hi',
    'ar', 'ca', 'he', 'en_AU', 'en_CA', 'en_GB', 'fr_CA', 'zh_TW'
  ];
  static const Map<String, String> languageNames = {
    'fr': 'Français',
    'en': 'English',
    'de': 'Deutsch',
    'it': 'Italiano',
    'es': 'Español',
    'nl': 'Nederlands',
    'pl': 'Polski',
    'cs': 'Čeština',
    'pt': 'Português',
    'ru': 'Русский',
    'ja': '日本語',
    'ko': '한국어',
    'zh': '中文',
    'sv': 'Svenska',
    'tr': 'Türkçe',
    'ro': 'Română',
    'hu': 'Magyar',
    'el': 'Ελληνικά',
    'bg': 'Български',
    'hr': 'Hrvatski',
    'sk': 'Slovenčina',
    'sl': 'Slovenščina',
    'sr': 'Српски',
    'uk': 'Українська',
    'da': 'Dansk',
    'no': 'Norsk',
    'fi': 'Suomi',
    'th': 'ไทย',
    'vi': 'Tiếng Việt',
    'id': 'Bahasa Indonesia',
    'ms': 'Bahasa Melayu',
    'hi': 'हिन्दी',
    'ar': 'العربية',
    'ca': 'Català',
    'he': 'עברית',
    'en_AU': 'English (Australia)',
    'en_CA': 'English (Canada)',
    'en_GB': 'English (UK)',
    'fr_CA': 'Français (Canada)',
    'zh_TW': '繁體中文',
  };

  // Devises supportées
  static const List<String> supportedCurrencies = ['CHF', 'EUR', 'USD', 'GBP', 'CAD'];
  static const Map<String, String> currencyNames = {
    'CHF': 'Franc suisse (CHF)',
    'EUR': 'Euro (€)',
    'USD': 'Dollar américain (\$)',
    'GBP': 'Livre sterling (£)',
    'CAD': 'Dollar canadien (CAD)',
  };

  // Systèmes d'unités
  static const String unitsMetric = 'metric';
  static const String unitsImperial = 'imperial';
  static const Map<String, String> unitsNames = {
    'metric': 'Métrique (mm, g, °C)',
    'imperial': 'Américain (in, oz, °F)',
  };

  // Getters
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_keyLanguage);

    // Si une langue est sauvegardée, l'utiliser
    if (savedLanguage != null) {
      return savedLanguage;
    }

    // Sinon, détecter la langue du système
    final systemLocale = PlatformDispatcher.instance.locale;
    final languageCode = systemLocale.languageCode;

    // Vérifier si la langue système est supportée, sinon fallback à 'en'
    return supportedLanguages.contains(languageCode) ? languageCode : 'en';
  }

  static Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrency) ?? 'CHF';
  }

  static Future<String> getUnits() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUnits) ?? unitsMetric;
  }

  static Future<bool> isSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsSignedIn) ?? false;
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<int> getLowStockThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyLowStockThreshold) ?? 20; // 20% par défaut
  }

  static Future<String> getNfcMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNfcMode) ?? 'anycubic'; // 'anycubic' par défaut
  }

  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsPremium) ?? false;
  }

  // Setters
  static Future<void> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, language);
    // Sync to backend if user is signed in
    await _syncPreferencesToBackend();
  }

  static Future<void> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrency, currency);
    // Sync to backend if user is signed in
    await _syncPreferencesToBackend();
  }

  static Future<void> setUnits(String units) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUnits, units);
    // Sync to backend if user is signed in
    await _syncPreferencesToBackend();
  }

  static Future<void> setLowStockThreshold(int threshold) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLowStockThreshold, threshold);
    // Sync to backend if user is signed in
    await _syncPreferencesToBackend();
  }

  static Future<void> setNfcMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNfcMode, mode);
    // No need to sync to backend - this is a local UI preference
  }

  static Future<void> setPremium(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsPremium, isPremium);
    debugPrint('💎 Premium status saved: $isPremium');
  }

  // Sync preferences to backend
  static Future<void> _syncPreferencesToBackend() async {
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) return;

      final authService = AuthService();
      final accessToken = await authService.getAccessToken();
      if (accessToken == null) {
        debugPrint('⚠️ No access token available for sync');
        return;
      }

      final language = await getLanguage();
      final currency = await getCurrency();
      final units = await getUnits();
      final threshold = await getLowStockThreshold();

      // Try to sync with backend (backend expects snake_case directly, not in preferences object)
      final http.Response response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateUserProfile}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'language': language,
          'currency': currency,
          'units': units,
          'low_stock_threshold': threshold,
        }),
      ).timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 200) {
        debugPrint('✅ Preferences synced to backend');
      } else {
        debugPrint('⚠️ Failed to sync preferences: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Silently fail - preferences are already saved locally
      debugPrint('⚠️ Could not sync preferences to backend: $e');
    }
  }

  // Load preferences from backend
  static Future<void> loadPreferencesFromBackend() async {
    try {
      final isSignedIn = await UserPreferencesService.isSignedIn();
      if (!isSignedIn) {
        debugPrint('⚠️ Not signed in, skipping preferences load');
        return;
      }

      final authService = AuthService();
      final accessToken = await authService.getAccessToken();
      if (accessToken == null) {
        debugPrint('⚠️ No access token available to load preferences');
        return;
      }

      debugPrint('📥 Loading preferences from backend...');
      final http.Response response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getUserProfile}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(ApiConfig.connectTimeout);

      debugPrint('Load preferences response: ${response.statusCode}');
      debugPrint('Load preferences body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        debugPrint('Decoded preferences data: $responseBody');

        final prefs = await SharedPreferences.getInstance();

        // Check if backend returned success
        if (responseBody['success'] == true && responseBody['data'] != null) {
          final data = responseBody['data'] as Map<String, dynamic>;
          debugPrint('Processing user data: $data');

          // Preferences are directly in the data object, not in a nested 'preferences' object
          if (data['language'] != null) {
            await prefs.setString(_keyLanguage, data['language'] as String);
          }
          if (data['currency'] != null) {
            await prefs.setString(_keyCurrency, data['currency'] as String);
          }
          if (data['units'] != null) {
            await prefs.setString(_keyUnits, data['units'] as String);
          }
          if (data['low_stock_threshold'] != null) {
            await prefs.setInt(_keyLowStockThreshold, data['low_stock_threshold'] as int);
          }
          debugPrint('✅ Preferences loaded from backend');
        } else {
          debugPrint('No data in backend response');
        }
      } else {
        debugPrint('⚠️ Failed to load preferences: ${response.statusCode} - ${response.body}');
      }
    } catch (e, stackTrace) {
      debugPrint('⚠️ Could not load preferences from backend: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  static Future<void> setUserInfo({
    required bool isSignedIn,
    String? userName,
    String? userEmail,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsSignedIn, isSignedIn);
    if (userName != null) {
      await prefs.setString(_keyUserName, userName);
    }
    if (userEmail != null) {
      await prefs.setString(_keyUserEmail, userEmail);
    }
  }

  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsSignedIn, false);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
  }

  // Conversion helpers
  static double convertWeight(double grams, String targetUnits) {
    if (targetUnits == unitsImperial) {
      // Convert grams to ounces (1 oz = 28.3495 g)
      return grams / 28.3495;
    }
    return grams;
  }

  static double convertLength(double millimeters, String targetUnits) {
    if (targetUnits == unitsImperial) {
      // Convert millimeters to inches (1 in = 25.4 mm)
      return millimeters / 25.4;
    }
    return millimeters;
  }

  static double convertTemperature(double celsius, String targetUnits) {
    if (targetUnits == unitsImperial) {
      // Convert Celsius to Fahrenheit
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  static String getWeightUnit(String units) {
    return units == unitsImperial ? 'oz' : 'g';
  }

  static String getLengthUnit(String units) {
    return units == unitsImperial ? 'in' : 'mm';
  }

  static String getTemperatureUnit(String units) {
    return units == unitsImperial ? '°F' : '°C';
  }
}
