import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/models/user_model.dart';
import 'package:nfc_filament/core/services/shopping_list_service.dart';
import 'package:nfc_filament/core/services/subscription_service.dart';
import 'package:nfc_filament/core/services/sync_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Le backend a refusé ou n'a pas pu traiter la connexion. Aucune session
/// locale n'est créée : l'écran de connexion affiche un échec.
class AuthBackendException implements Exception {
  const AuthBackendException(this.message);
  final String message;

  @override
  String toString() => 'AuthBackendException: $message';
}

/// Le serveur a refusé le refresh token (401/403) : la session locale a été
/// effacée, l'utilisateur doit se reconnecter.
class AuthSessionExpiredException implements Exception {
  const AuthSessionExpiredException(this.message);
  final String message;

  @override
  String toString() => 'AuthSessionExpiredException: $message';
}

/// Échec passager du rafraîchissement (429, 5xx, timeout, réseau, réponse
/// illisible) : la session est CONSERVÉE, l'appel pourra être retenté.
class AuthTransientException implements Exception {
  const AuthTransientException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => 'AuthTransientException($statusCode): $message';
}

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

  /// Rafraîchissement en cours, partagé par tous les appelants : un seul
  /// POST /auth/refresh à la fois. Avec la rotation des refresh tokens, deux
  /// refresh simultanés avec le même jeton faisaient échouer le second (401)
  /// → déconnexion intempestive.
  Completer<void>? _refreshCompleter;

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUser = 'user_data';

  /// Login avec Apple Sign In.
  /// Lève une exception si le backend échoue : plus de « session locale »
  /// sans jeton (l'app se croyait connectée alors que rien n'était
  /// synchronisé).
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

      // 2. Authentification backend (obligatoire)
      final http.Response response;
      try {
        response = await http.post(
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
      } catch (e) {
        throw AuthBackendException('Apple: backend injoignable ($e)');
      }

      debugPrint('Apple backend response: ${response.statusCode}');
      final authResponse = _parseAuthResponse(response, provider: 'Apple');

      await _saveTokens(authResponse);
      await _afterLogin();
      debugPrint('✅ Apple Sign In successful (backend mode)');
    } catch (e) {
      debugPrint('Apple Sign In error: $e');
      rethrow;
    }
  }

  /// Login avec Google Sign In.
  /// Lève une exception si le backend échoue (voir [signInWithApple]).
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

      // 2. Authentification backend (obligatoire)
      final AuthResponse authResponse;
      try {
        final http.Response response;
        try {
          response = await http.post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginWithGoogle}'),
            headers: {'Content-Type': 'application/json', ...ApiConfig.commonHeaders},
            body: jsonEncode({
              'idToken': googleAuth.idToken,
            }),
          ).timeout(ApiConfig.connectTimeout);
        } catch (e) {
          throw AuthBackendException('Google: backend injoignable ($e)');
        }
        debugPrint('Google backend response: ${response.statusCode}');
        authResponse = _parseAuthResponse(response, provider: 'Google');
      } on AuthBackendException {
        // Le compte Google reste sélectionné sinon : on le libère pour que
        // le prochain essai repropose le choix du compte.
        try {
          await _googleSignIn.signOut();
        } catch (_) {}
        rethrow;
      }

      await _saveTokens(authResponse);
      await _afterLogin();
      debugPrint('✅ Google Sign In successful (backend mode)');
    } catch (e) {
      debugPrint('Google Sign In error: $e');
      rethrow;
    }
  }

  /// Valide la réponse du backend de login. Lève [AuthBackendException] si
  /// le statut n'est pas 200, si `success` vaut false ou si le corps est
  /// illisible.
  AuthResponse _parseAuthResponse(
    http.Response response, {
    required String provider,
  }) {
    if (response.statusCode != 200) {
      throw AuthBackendException('$provider: HTTP ${response.statusCode}');
    }
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>?;
      if (body == null) {
        throw const AuthBackendException('Backend returned null response');
      }
      if (body['success'] == false) {
        throw AuthBackendException(
          'Backend error: ${body['error'] ?? 'Unknown error'}',
        );
      }
      return AuthResponse.fromJson(body);
    } on AuthBackendException {
      rethrow;
    } catch (e) {
      throw AuthBackendException('$provider: réponse illisible ($e)');
    }
  }

  /// Après un login réussi (jetons enregistrés) : préférences + synchros.
  /// Fail-open : l'utilisateur EST connecté, une synchro ratée sera
  /// rejouée plus tard (lancement, retour au premier plan).
  Future<void> _afterLogin() async {
    try {
      await UserPreferencesService.loadPreferencesFromBackend();
      await SyncService.fullSync();
      await ShoppingListService.fullSync();
    } catch (e) {
      debugPrint('⚠️ Synchro après connexion incomplète (ignorée): $e');
    }
  }

  /// Logout : efface la session locale (jetons du stockage sécurisé +
  /// isSignedIn) puis révoque les jetons côté serveur en arrière-plan.
  /// La déconnexion locale ne dépend jamais du réseau (hors ligne, la requête
  /// pouvait bloquer jusqu'à 30 s).
  Future<void> logout() async {
    try {
      String? accessToken;
      String? refreshToken;
      try {
        accessToken = await getAccessToken();
        refreshToken = await getRefreshToken();
      } catch (e) {
        debugPrint('Logout: lecture des jetons impossible (ignorée): $e');
      }

      // Supprimer les données locales
      await _clearTokens();

      // Déconnecter Google
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint('Google sign out error: $e');
      }

      // Révoquer access + refresh token côté serveur (best effort)
      if (accessToken != null) {
        unawaited(_revokeOnServer(accessToken, refreshToken));
      }

      debugPrint('Logout successful');
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  Future<void> _revokeOnServer(String accessToken, String? refreshToken) async {
    try {
      await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logout}'),
        headers: {
          ...ApiConfig.commonHeaders,
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'refresh_token': ?refreshToken}),
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('Logout backend error (ignored): $e');
    }
  }

  /// Efface la session locale sans appel réseau (ex : après suppression du
  /// compte, dont les jetons ne sont plus valides).
  Future<void> clearLocalSession() async {
    await _clearTokens();
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google sign out error: $e');
    }
  }

  /// Au démarrage : réconcilie SharedPreferences (isSignedIn) et le stockage
  /// sécurisé (jetons). Les deux peuvent diverger :
  /// - Android : la sauvegarde auto restaure les SharedPreferences mais pas
  ///   les jetons (Keystore), et flutter_secure_storage efface tout en cas
  ///   d'erreur de déchiffrement → « connecté » sans jeton, stock vide car la
  ///   clé de stockage retombait sur la clé invité ;
  /// - iOS : le trousseau survit à une réinstallation, pas les préférences →
  ///   jetons orphelins d'une session terminée.
  /// Aucune bobine n'est effacée : elles restent dans leur clé de stockage et
  /// réapparaissent à la reconnexion. Local uniquement, fail-open.
  Future<void> reconcileSessionAtStartup() async {
    try {
      final signedIn = await UserPreferencesService.isSignedIn();
      final String? accessToken;
      final String? refreshToken;
      final String? userJson;
      try {
        accessToken = await getAccessToken();
        refreshToken = await getRefreshToken();
        userJson = await _secureStorage.read(key: _keyUser);
      } catch (e) {
        // Lecture en ERREUR (ex : trousseau iOS verrouillé) ≠ jetons absents :
        // on ne sait rien, donc on ne touche à rien.
        debugPrint('⚠️ Stockage sécurisé illisible, réconciliation sautée: $e');
        return;
      }
      final hasTokens = (accessToken?.isNotEmpty ?? false) &&
          (refreshToken?.isNotEmpty ?? false);

      if (signedIn && !hasTokens) {
        debugPrint('🔧 Session incohérente (connecté sans jeton) → déconnexion locale');
        await _clearTokens();
      } else if (!signedIn &&
          (accessToken != null || refreshToken != null || userJson != null)) {
        debugPrint('🔧 Jetons orphelins (non connecté) → effacés');
        await _deleteSecureSession();
      } else if (signedIn && userJson == null) {
        // Jetons présents mais profil local absent : la clé de stockage
        // retomberait sur la clé invité. On recharge le profil (non bloquant).
        unawaited(refreshUserFromBackend());
      }
    } catch (e) {
      debugPrint('⚠️ Réconciliation de session impossible (ignorée): $e');
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

  /// Refresh le token d'accès. Un seul rafraîchissement à la fois : les
  /// appels concurrents attendent le même résultat.
  /// - 401/403 → session effacée, [AuthSessionExpiredException] ;
  /// - 429, 5xx, timeout, réseau → [AuthTransientException], rien n'est
  ///   effacé (avant, toute réponse ≠ 200 déconnectait l'utilisateur).
  Future<void> refreshAccessToken() {
    final inFlight = _refreshCompleter;
    if (inFlight != null) return inFlight.future;

    final completer = Completer<void>();
    _refreshCompleter = completer;
    unawaited(
      _performRefresh().then(
        (_) => completer.complete(),
        onError: completer.completeError,
      ).whenComplete(() {
        if (identical(_refreshCompleter, completer)) _refreshCompleter = null;
      }),
    );
    return completer.future;
  }

  Future<void> _performRefresh() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      // Session inutilisable : impossible de la prolonger.
      await _clearTokens();
      throw const AuthSessionExpiredException('No refresh token available');
    }

    final http.Response response;
    try {
      response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.refreshToken}'),
        headers: {...ApiConfig.commonHeaders, 'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      ).timeout(ApiConfig.connectTimeout);
    } catch (e) {
      throw AuthTransientException('Token refresh unreachable: $e');
    }

    if (isSessionRejectedStatus(response.statusCode)) {
      // Refresh token révoqué/expiré ou compte supprimé → déconnexion
      await _clearTokens();
      throw AuthSessionExpiredException(
        'Token refresh rejected (${response.statusCode}) - logged out',
      );
    }
    if (response.statusCode != 200) {
      throw AuthTransientException(
        'Token refresh failed',
        statusCode: response.statusCode,
      );
    }

    final String accessToken;
    final String newRefreshToken;
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      accessToken = data['access_token'] as String;
      newRefreshToken = data['refresh_token'] as String;
    } catch (e) {
      throw AuthTransientException('Token refresh: réponse illisible ($e)');
    }
    await _secureStorage.write(key: _keyAccessToken, value: accessToken);
    await _secureStorage.write(key: _keyRefreshToken, value: newRefreshToken);
  }

  /// Seuls 401 et 403 signifient « session refusée » : tout autre échec
  /// (429, 5xx…) est passager et ne doit pas déconnecter.
  @visibleForTesting
  static bool isSessionRejectedStatus(int statusCode) =>
      statusCode == 401 || statusCode == 403;

  /// Execute an authenticated HTTP request with automatic 401 retry
  Future<http.Response> authenticatedRequest(
    Future<http.Response> Function(String token) request,
  ) async {
    final token = await getAccessToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await request(token);
    if (response.statusCode != 401) return response;

    // Un autre appel a peut-être déjà rafraîchi le jeton pendant cette
    // requête : réessayer directement avec le nouveau, sans nouveau refresh.
    final current = await getAccessToken();
    if (current != null && current != token) {
      return request(current);
    }

    // Token expiré : refresh (partagé si déjà en cours), puis nouvel essai
    try {
      await refreshAccessToken();
    } catch (e) {
      debugPrint('❌ Token refresh failed: $e');
      rethrow;
    }
    final refreshed = await getAccessToken();
    if (refreshed == null) throw Exception('Token refresh returned null');
    return request(refreshed);
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

    // Le premium suit le compte connecté
    await SubscriptionService().onAccountChanged();
  }

  /// Efface jetons + profil du stockage sécurisé (sans toucher aux
  /// préférences).
  Future<void> _deleteSecureSession() async {
    await _secureStorage.delete(key: _keyAccessToken);
    await _secureStorage.delete(key: _keyRefreshToken);
    await _secureStorage.delete(key: _keyUser);
  }

  /// Supprimer tous les tokens
  Future<void> _clearTokens() async {
    try {
      await _deleteSecureSession();
    } finally {
      // Toujours repasser en « non connecté », même si le stockage sécurisé
      // a échoué (la réconciliation au démarrage effacera les restes).
      await UserPreferencesService.signOut();
      // Fin de session (déconnexion, refresh refusé, compte supprimé) : le
      // premium du compte ne reste pas actif pour l'invité.
      await SubscriptionService().onAccountChanged();
    }
  }
}
