// Rafraîchissement du jeton (AuthService) :
//  - seuls 401 et 403 effacent la session ;
//  - 429, 5xx, coupure réseau, réponse illisible = échec passager, session
//    conservée ;
//  - un seul POST /auth/refresh à la fois (rotation des refresh tokens) ;
//  - déconnexion : jetons effacés, clé de stockage invité ;
//  - réconciliation au démarrage SharedPreferences ↔ stockage sécurisé.

import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_session.dart';

http.Response refreshOk(String access, String refresh) => http.Response(
      jsonEncode({
        'success': true,
        'data': {'access_token': access, 'refresh_token': refresh},
      }),
      200,
    );

Future<T> withServer<T>(
  Future<T> Function() body,
  Future<http.Response> Function(http.Request request) handler,
) =>
    http.runWithClient(body, () => MockClient(handler));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(installFakeSecureStorage);
  setUp(signIn);

  final auth = AuthService();

  group('isSessionRejectedStatus', () {
    test('401 et 403 seulement', () {
      expect(AuthService.isSessionRejectedStatus(401), isTrue);
      expect(AuthService.isSessionRejectedStatus(403), isTrue);
      for (final code in [200, 400, 404, 408, 429, 500, 502, 503]) {
        expect(AuthService.isSessionRejectedStatus(code), isFalse, reason: '$code');
      }
    });
  });

  group('refreshAccessToken', () {
    for (final status in [401, 403]) {
      test('$status → session effacée', () async {
        await expectLater(
          withServer(auth.refreshAccessToken, (_) async => http.Response('{}', status)),
          throwsA(isA<AuthSessionExpiredException>()),
        );
        expect(fakeSecureStorage, isEmpty);
        expect(await UserPreferencesService.isSignedIn(), isFalse);
        expect(await auth.getCurrentUserId(), isNull);
      });
    }

    for (final status in [429, 500, 502, 503]) {
      test('$status → échec passager, session conservée', () async {
        await expectLater(
          withServer(auth.refreshAccessToken, (_) async => http.Response('oops', status)),
          throwsA(isA<AuthTransientException>()
              .having((e) => e.statusCode, 'statusCode', status)),
        );
        expect(await auth.getAccessToken(), 'a1');
        expect(await auth.getRefreshToken(), 'r1');
        expect(await auth.getCurrentUserId(), 'u1');
        expect(await UserPreferencesService.isSignedIn(), isTrue);
      });
    }

    test('coupure réseau → échec passager, session conservée', () async {
      await expectLater(
        withServer(
          auth.refreshAccessToken,
          (_) async => throw http.ClientException('offline'),
        ),
        throwsA(isA<AuthTransientException>()),
      );
      expect(await auth.getAccessToken(), 'a1');
      expect(await UserPreferencesService.isSignedIn(), isTrue);
    });

    test('200 illisible → échec passager, session conservée', () async {
      await expectLater(
        withServer(auth.refreshAccessToken, (_) async => http.Response('<html>', 200)),
        throwsA(isA<AuthTransientException>()),
      );
      expect(await auth.getRefreshToken(), 'r1');
      expect(await UserPreferencesService.isSignedIn(), isTrue);
    });

    test('200 → nouveaux jetons enregistrés', () async {
      await withServer(auth.refreshAccessToken, (_) async => refreshOk('a2', 'r2'));
      expect(await auth.getAccessToken(), 'a2');
      expect(await auth.getRefreshToken(), 'r2');
    });

    test('appels simultanés → un seul POST /auth/refresh', () async {
      var calls = 0;
      final gate = Completer<void>();
      await withServer(() async {
        final first = auth.refreshAccessToken();
        final second = auth.refreshAccessToken();
        gate.complete();
        await Future.wait([first, second]);
      }, (request) async {
        calls++;
        await gate.future;
        return refreshOk('a2', 'r2');
      });
      expect(calls, 1);
      expect(await auth.getAccessToken(), 'a2');
    });
  });

  group('authenticatedRequest', () {
    test('401 simultanés → un seul refresh, requêtes rejouées', () async {
      var refreshCalls = 0;
      final results = await withServer(() {
        Future<http.Response> call() => auth.authenticatedRequest(
              (token) => http.get(
                Uri.parse('https://api.test/data'),
                headers: {'Authorization': 'Bearer $token'},
              ),
            );
        return Future.wait([call(), call(), call()]);
      }, (request) async {
        if (request.url.path.endsWith('/auth/refresh')) {
          refreshCalls++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return refreshOk('a2', 'r2');
        }
        final ok = request.headers['Authorization'] == 'Bearer a2';
        return http.Response(ok ? 'ok' : 'expired', ok ? 200 : 401);
      });
      expect(refreshCalls, 1);
      expect(results.map((r) => r.statusCode), [200, 200, 200]);
    });

    test('refresh en 500 → erreur remontée, session conservée', () async {
      await expectLater(
        withServer(
          () => auth.authenticatedRequest(
            (token) => http.get(Uri.parse('https://api.test/data')),
          ),
          (request) async => request.url.path.endsWith('/auth/refresh')
              ? http.Response('down', 500)
              : http.Response('expired', 401),
        ),
        throwsA(isA<AuthTransientException>()),
      );
      expect(await auth.getAccessToken(), 'a1');
      expect(await UserPreferencesService.isSignedIn(), isTrue);
    });
  });

  group('logout', () {
    test('efface jetons + profil, révoque le refresh token', () async {
      final revoked = Completer<http.Request>();
      await withServer(() async {
        await auth.logout();
        await revoked.future.timeout(const Duration(seconds: 2));
      }, (request) async {
        if (request.url.path.endsWith('/user/logout')) revoked.complete(request);
        return http.Response('{}', 200);
      });
      expect(fakeSecureStorage, isEmpty);
      expect(await UserPreferencesService.isSignedIn(), isFalse);
      expect(await auth.getCurrentUserId(), isNull);
      final request = await revoked.future;
      expect(request.headers['Authorization'], 'Bearer a1');
      expect(jsonDecode(request.body), {'refresh_token': 'r1'});
    });

    test('après déconnexion, le stock affiché est celui de la clé invité', () async {
      String spools(String id) => jsonEncode([
            SpoolInventoryItem(
              id: id,
              brand: 'Anycubic',
              material: 'PLA',
              colorName: 'Black',
              colorRgb: 0,
              price: 0,
              weight: 1000,
              remainingWeight: 1000,
              addedDate: DateTime(2026),
            ).toJson(),
          ]);
      await signIn(extraPrefs: {
        'spools_inventory_u1': spools('account'),
        'spools_inventory': spools('guest'),
      });
      expect((await SpoolStorageService.loadSpools()).single.id, 'account');

      await withServer(auth.logout, (_) async => http.Response('{}', 200));
      expect((await SpoolStorageService.loadSpools()).single.id, 'guest');
      // Les bobines du compte restent dans leur clé (retrouvées à la reconnexion)
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('spools_inventory_u1'), contains('account'));
    });

    test('hors ligne → déconnexion locale quand même', () async {
      await withServer(
        auth.logout,
        (_) async => throw http.ClientException('offline'),
      );
      await pumpEventQueue();
      expect(fakeSecureStorage, isEmpty);
      expect(await UserPreferencesService.isSignedIn(), isFalse);
    });
  });

  group('reconcileSessionAtStartup', () {
    test('connecté sans jeton → déconnexion locale, bobines conservées', () async {
      signOutLocally(prefs: {
        'user_is_signed_in': true,
        'user_email': 'x@example.com',
        'spools_inventory_u1': '[]',
      });
      await auth.reconcileSessionAtStartup();
      expect(await UserPreferencesService.isSignedIn(), isFalse);
      expect(await UserPreferencesService.getUserEmail(), isNull);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('spools_inventory_u1'), '[]');
    });

    test('jetons orphelins (non connecté) → effacés', () async {
      // Trousseau iOS conservé après réinstallation, préférences vides
      SharedPreferences.setMockInitialValues({});
      await auth.reconcileSessionAtStartup();
      expect(fakeSecureStorage, isEmpty);
      expect(await auth.getCurrentUserId(), isNull);
    });

    test('session cohérente → inchangée', () async {
      await auth.reconcileSessionAtStartup();
      expect(await auth.getAccessToken(), 'a1');
      expect(await UserPreferencesService.isSignedIn(), isTrue);
    });
  });
}
