import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_config.dart';
import '../models/user_model.dart';
import 'user_preferences_service.dart';
import 'sync_service.dart';
import 'shopping_list_service.dart';

/// Service d'authentification Apple & Google
class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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
          headers: {'Content-Type': 'application/json'},
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
        debugPrint('Apple backend body: ${response.body}');

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          debugPrint('Decoded response: $responseBody');

          if (responseBody == null) {
            throw Exception('Backend returned null response');
          }

          // Check if backend returned success
          if (responseBody['success'] == false) {
            throw Exception('Backend error: ${responseBody['error'] ?? 'Unknown error'}');
          }

          final authResponse = AuthResponse.fromJson(
            responseBody as Map<String, dynamic>,
          );

          debugPrint('Saving tokens...');
          await _saveTokens(authResponse);

          debugPrint('Loading preferences from backend...');
          await UserPreferencesService.loadPreferencesFromBackend();

          debugPrint('Syncing spools with backend (full sync)...');
          // Full sync: push local changes first, then pull server changes
          await SyncService.fullSync();

          debugPrint('Syncing shopping list with backend...');
          await ShoppingListService.fullSync();

          debugPrint('Apple Sign In successful (backend mode)');
          return;
        } else {
          debugPrint('Backend error: ${response.statusCode} - ${response.body}');
        }
      } catch (e, stackTrace) {
        debugPrint('Backend unavailable, using local mode: $e');
        debugPrint('Stack trace: $stackTrace');
      }

      // 3. Fallback mode local si backend échoue
      await UserPreferencesService.setUserInfo(
        isSignedIn: true,
        userName: name ?? 'Apple User',
        userEmail: email ?? 'apple-user@local',
      );

      debugPrint('Apple Sign In successful (local mode)');
    } catch (e) {
      debugPrint('Apple Sign In error: $e');
      rethrow;
    }
  }

  /// Login avec Google Sign In
  Future<void> signInWithGoogle() async {
    try {
      // 1. Demander l'authentification Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign In cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 2. Essayer d'envoyer au backend
      try {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginWithGoogle}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'idToken': googleAuth.idToken,
          }),
        ).timeout(ApiConfig.connectTimeout);

        debugPrint('Google backend response: ${response.statusCode}');
        debugPrint('Google backend body: ${response.body}');

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          debugPrint('Decoded response: $responseBody');

          if (responseBody == null) {
            throw Exception('Backend returned null response');
          }

          // Check if backend returned success
          if (responseBody['success'] == false) {
            throw Exception('Backend error: ${responseBody['error'] ?? 'Unknown error'}');
          }

          final authResponse = AuthResponse.fromJson(
            responseBody as Map<String, dynamic>,
          );
          await _saveTokens(authResponse);
          // Load user preferences from backend after successful login
          await UserPreferencesService.loadPreferencesFromBackend();
          // Full sync: push local changes first, then pull server changes
          await SyncService.fullSync();
          // Sync shopping list
          await ShoppingListService.fullSync();
          debugPrint('Google Sign In successful (backend mode)');
          return;
        } else {
          debugPrint('Backend error: ${response.statusCode} - ${response.body}');
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
    return await _secureStorage.read(key: _keyAccessToken);
  }

  /// Récupérer le refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _keyRefreshToken);
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

  /// Récupérer l'ID utilisateur actuel
  Future<String?> getCurrentUserId() async {
    final user = await getCurrentUser();
    return user?.userId;
  }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    return await UserPreferencesService.isSignedIn();
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
    );

    if (response.statusCode != 200) {
      throw Exception('Token refresh failed');
    }

    final data = jsonDecode(response.body)['data'];
    await _secureStorage.write(
      key: _keyAccessToken,
      value: data['access_token'] as String,
    );
    await _secureStorage.write(
      key: _keyRefreshToken,
      value: data['refresh_token'] as String,
    );
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
