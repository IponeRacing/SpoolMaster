// Outils de test : stockage sécurisé en mémoire (canal de
// flutter_secure_storage simulé) et session connectée / invitée.

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contenu du stockage sécurisé simulé (clé → valeur).
final Map<String, String> fakeSecureStorage = {};

const _secureChannel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

/// Branche le stockage sécurisé en mémoire. À appeler dans setUpAll.
void installFakeSecureStorage() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_secureChannel, (call) async {
    final args = (call.arguments as Map?)?.cast<String, Object?>() ?? {};
    final key = args['key'] as String?;
    switch (call.method) {
      case 'read':
        return fakeSecureStorage[key];
      case 'write':
        fakeSecureStorage[key!] = args['value']! as String;
        return null;
      case 'delete':
        fakeSecureStorage.remove(key);
        return null;
      case 'deleteAll':
        fakeSecureStorage.clear();
        return null;
      case 'readAll':
        return Map<String, String>.from(fakeSecureStorage);
      case 'containsKey':
        return fakeSecureStorage.containsKey(key);
      default:
        return null;
    }
  });
}

/// Session connectée cohérente : jetons + profil + isSignedIn.
Future<void> signIn({
  String userId = 'u1',
  String accessToken = 'a1',
  String refreshToken = 'r1',
  Map<String, Object> extraPrefs = const {},
}) async {
  fakeSecureStorage
    ..clear()
    ..['access_token'] = accessToken
    ..['refresh_token'] = refreshToken
    ..['user_data'] = jsonEncode({
      'user_id': userId,
      'email': '$userId@example.com',
      'name': 'Test',
      'provider': 'apple',
    });
  SharedPreferences.setMockInitialValues({
    'user_is_signed_in': true,
    ...extraPrefs,
  });
}

/// Mode invité : aucun jeton, non connecté.
void signOutLocally({Map<String, Object> prefs = const {}}) {
  fakeSecureStorage.clear();
  SharedPreferences.setMockInitialValues(prefs);
}
