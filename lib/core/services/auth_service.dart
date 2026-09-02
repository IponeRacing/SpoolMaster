import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/models/user_model.dart';
import 'package:nfc_filament/core/services/shopping_list_service.dart';
import 'package:nfc_filament/core/services/sync_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Service d'authentification Apple & Google
class AuthService {
  factory AuthService() => _instance;
  AuthService._internal();
  // Singleton
  static final AuthService _instance = AuthService._internal();

  static const String _googleServerClientId =
      '1091367332850-6hgb6firnj5miot7uvqggtcng6uc7qog.apps.googleusercontent.com';
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleInitialized = false;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUser = 'user_data';

  /// Login avec Apple Sign In
  Future<void> signInWithApple() async {
    try {
      // 1. Demander l'authentification Apple
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final name = credential.givenName != null && credential.familyName != null
          ? '${credential.givenName} ${credential.familyName}'
          : null;
      final email = credential.email;

      // 2. Essayer d'envoyer au backend
      try {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginWithApple}'),
          headers: {'Content-Type': 'application/json', ...ApiConfig.commonHeaders},
          body: jsonEncode({
            'identityToken': credential.identityToken,
            'authorizationCode': credential.authorizationCode,
            'user': {
              'email': email,
              'name': name,
            },
          }),
        ).timeout(ApiConfig.connectTimeout);

        debugPrint('Apple backend response: ${response.statusCode}');

        if (response.statusCode == 200) {
          final responseBody =
              jsonDecode(response.body) as Map<String, dynamic>?;

          if (responseBody == null) {
            throw Exception('Backend returned null response');
          }

          // Check if backend returned success
          if (responseBody['success'] == false) {
            throw Exception('Backend error: ${responseBody['error'] ?? 'Unknown error'}');
          }

          final authResponse = AuthResponse.fromJson(responseBody);

          await _saveTokens(authResponse);
          await UserPreferencesService.loadPreferencesFromBackend();
          await SyncService.fullSync();
          await ShoppingListService.fullSync();

          debugPrint('✅ Apple Sign In successful (backend mode)');
          return;
        } else {
          debugPrint('❌ Backend error: ${response.statusCode}');
        }
      } catch (e, stackTrace) {
        debugPrint('Backend unavailable, using local mode: $e');
        debugPrint('Stack trace: $stackTrace');
      }

      // 3. Fallback mode local si backend échoue
      // Apple ne donne l'email qu'au PREMIER sign-in.
      // Si email est null ici, on affiche un placeholder plus utile.
      await UserPreferencesService.setUserInfo(
        isSignedIn: true,
        userName: name ?? 'Apple User',
        userEmail: email ?? credential.userIdentifier ?? 'Apple Sign-In',
      );

      debugPrint('Apple Sign In successful (local mode) - email: $email');
    } catch (e) {
      debugPrint('Apple Sign In error: $e');
      rethrow;
    }
  }

  /// Login avec Google Sign In
  Future<void> signInWithGoogle() async {
    try {
      // 1. Demander l'authentification Google
      if (!_googleInitialized) {
        await _googleSignIn.initialize(
          serverClientId: _googleServerClientId,
        );
        _googleInitialized = true;
      }
      final googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      final googleAuth =
          googleUser.authentication;

      // 2. Essayer d'envoyer au backend
      try {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginWithGoogle}'),
          headers: {'Content-Type': 'application/json', ...ApiConfig.commonHeaders},
          body: jsonEncode({
            'idToken': googleAuth.idToken,
          }),
        ).timeout(ApiConfig.connectTimeout);

        debugPrint('Google backend response: ${response.statusCode}');

        if (response.statusCode == 200) {
          final responseBody =
              jsonDecode(response.body) as Map<String, dynamic>?;

          if (responseBody == null) {
            throw Exception('Backend returned null response');
          }

          if (responseBody['success'] == false) {
            throw Exception('Backend error: ${responseBody['error'] ?? 'Unknown error'}');
          }

          final authResponse = AuthResponse.fromJson(responseBody);
          await _saveTokens(authResponse);
          await UserPreferencesService.loadPreferencesFromBackend();
          await SyncService.fullSync();
          await ShoppingListService.fullSync();
          debugPrint('✅ Google Sign In successful (backend mode)');
          return;
        } else {
          debugPrint('❌ Backend error: ${response.statusCode}');
        }
      } catch (e, stackTrace) {
        debugPrint('Backend unavailable, using local mode: $e');
        debugPrint('Stack trace: $stackTrace');
      }

      // 3. Fallback mode local si backend échoue
      await UserPreferencesService.setUserInfo(
        isSignedIn: true,
        userName: googleUser.displayName ?? 'Google User',
        userEmail: googleUser.email,
      );

      debugPrint('Google Sign In successful (local mode)');
    } catch (e) {
      debugPrint('Google Sign In error: $e');
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      // Essayer d'appeler le backend pour révoquer le token
      try {
        final accessToken = await getAccessToken();
        if (accessToken != null) {
          await http.post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logout}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $accessToken',
            },
          ).timeout(ApiConfig.connectTimeout);
        }
      } catch (e) {
        debugPrint('Logout backend error (ignored): $e');
      }

      // Supprimer les données locales
      await _clearTokens();

      // Déconnecter Google
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint('Google sign out error: $e');
      }

      debugPrint('Logout successful');
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  /// Récupérer l'access token
  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _keyAccessToken);
  }

  /// Récupérer le refresh token
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _keyRefreshToken);
  }

  /// Récupérer les données utilisateur
  Future<UserModel?> getCurrentUser() async {
    final userJson = await _secureStorage.read(key: _keyUser);
    if (userJson == null) return null;

    try {
      return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Parse user error: $e');
      return null;
    }
  }

  /// Récupère le profil depuis le BACKEND (source de vérité) et le met en cache
  /// local. Indispensable après une réinstallation : Apple ne renvoie l'email
  /// qu'à la 1re connexion, donc l'identité doit venir du serveur (qui la stocke
  /// depuis la première fois). Best practice 2026. Retourne null en cas d'échec
  /// (fail-open : on ne casse jamais la session).
  Future<UserModel?> refreshUserFromBackend() async {
    try {
      final response = await authenticatedRequest((token) => http.get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getUserProfile}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ).timeout(ApiConfig.connectTimeout));
      if (response.statusCode != 200) return null;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (body['data'] as Map<String, dynamic>?) ?? body;
      final user = UserModel.fromJson(data);
      if (user.email.isNotEmpty) {
        await _secureStorage.write(key: _keyUser, value: jsonEncode(user.toJson()));
        await UserPreferencesService.setUserInfo(
          isSignedIn: true,
          userName: user.name,
          userEmail: user.email,
        );
        debugPrint('✅ Profil rechargé depuis le backend: ${user.email}');
      }
      return user;
    } catch (e) {
      debugPrint('⚠️ refreshUserFromBackend échec (ignoré): $e');
      return null;
    }
  }

  /// Récupérer l'ID utilisateur actuel
  Future<String?> getCurrentUserId() async {
    final user = await getCurrentUser();
    return user?.userId;
  }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    return UserPreferencesService.isSignedIn();
  }

  /// Refresh le token d'accès
  Future<void> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.refreshToken}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    ).timeout(ApiConfig.connectTimeout);

    if (response.statusCode != 200) {
      // Refresh token expired or invalid - force logout
      await _clearTokens();
      throw Exception('Token refresh failed - logged out');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    await _secureStorage.write(
      key: _keyAccessToken,
      value: data['access_token'] as String,
    );
    await _secureStorage.write(
      key: _keyRefreshToken,
      value: data['refresh_token'] as String,
    );
  }

  /// Execute an authenticated HTTP request with automatic 401 retry
  Future<http.Response> authenticatedRequest(
    Future<http.Response> Function(String token) request,
  ) async {
    var token = await getAccessToken();
    if (token == null) throw Exception('Not authenticated');

    var response = await request(token);

    if (response.statusCode == 401) {
      // Token expired, try refresh
      try {
        await refreshAccessToken();
        token = await getAccessToken();
        if (token == null) throw Exception('Token refresh returned null');
        response = await request(token);
      } catch (e) {
        debugPrint('❌ Token refresh failed: $e');
        rethrow;
      }
    }

    return response;
  }

  /// Sauvegarder les tokens
  Future<void> _saveTokens(AuthResponse authResponse) async {
    await _secureStorage.write(
      key: _keyAccessToken,
      value: authResponse.accessToken,
    );
    await _secureStorage.write(
      key: _keyRefreshToken,
      value: authResponse.refreshToken,
    );
    await _secureStorage.write(
      key: _keyUser,
      value: jsonEncode(authResponse.user.toJson()),
    );

    // Synchroniser avec UserPreferencesService
    await UserPreferencesService.setUserInfo(
      isSignedIn: true,
      userName: authResponse.user.name,
      userEmail: authResponse.user.email,
    );
  }

  /// Supprimer tous les tokens
  Future<void> _clearTokens() async {
    await _secureStorage.delete(key: _keyAccessToken);
    await _secureStorage.delete(key: _keyRefreshToken);
    await _secureStorage.delete(key: _keyUser);

    // Synchroniser avec UserPreferencesService
    await UserPreferencesService.signOut();
  }
}
