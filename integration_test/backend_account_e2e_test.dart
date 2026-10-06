// Test E2E connecté contre l'API de PRODUCTION, dans l'app, avec un compte de
// test JETABLE créé côté serveur (jetons passés en --dart-define) :
// profil, préférences, statut d'abonnement, bobine (ajout, modification,
// consommation), liste de courses, analytics connecté, renouvellement du
// jeton, puis suppression du compte PAR L'ÉCRAN PROFIL (purge serveur).
//
// Simulateur / émulateur uniquement, toujours avec --keep-app-running
// (`flutter drive` désinstalle l'app sinon). Refusé si une session est déjà
// ouverte sur l'appareil : jamais de mélange avec un vrai compte.
//
//   flutter drive --driver=test_driver/integration_test.dart \
//     --target=integration_test/backend_account_e2e_test.dart --keep-app-running \
//     --dart-define=E2E_ACCESS_TOKEN=… --dart-define=E2E_REFRESH_TOKEN=… \
//     --dart-define=E2E_USER_ID=… --dart-define=E2E_EMAIL=… -d <simulateur>

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/shopping_list_service.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/subscription_service.dart';
import 'package:nfc_filament/core/services/sync_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/profile/presentation/pages/profile_page.dart';
import 'package:nfc_filament/firebase_options.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

const accessToken = String.fromEnvironment('E2E_ACCESS_TOKEN');
const refreshToken = String.fromEnvironment('E2E_REFRESH_TOKEN');
const userId = String.fromEnvironment('E2E_USER_ID');
const email = String.fromEnvironment('E2E_EMAIL');
const brand = 'E2EBackend';

Future<void> pumpFor(WidgetTester tester, [int ms = 1500]) async {
  for (var t = 0; t < ms; t += 100) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Requête authentifiée telle que l'app la fait (renouvellement compris).
Future<http.Response> apiGet(String path) => AuthService().authenticatedRequest(
      (token) => http.get(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: {'Authorization': 'Bearer $token', ...ApiConfig.commonHeaders},
      ),
    );

Future<void> removeLocalTestData() async {
  for (final s in await SpoolStorageService.loadAllSpools()) {
    if (s.brand == brand) await SpoolStorageService.deleteSpool(s.id);
  }
  for (final s in await ShoppingListService.loadShoppingList()) {
    if (s.brand == brand) await ShoppingListService.removeFromShoppingList(s.id);
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Compte connecté contre la prod : de la connexion à la suppression', (tester) async {
    expect(accessToken.isNotEmpty && refreshToken.isNotEmpty && userId.isNotEmpty && email.isNotEmpty, isTrue,
        reason: 'jetons du compte de test absents (--dart-define)');
    await initializeDateFormatting();
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } catch (_) {}
    await configureDependencies();

    if (await UserPreferencesService.isSignedIn()) {
      fail('Une session est déjà ouverte sur cet appareil : test refusé (compte réel possible).');
    }

    // Session du compte de test, écrite comme après une vraie connexion
    const storage = FlutterSecureStorage();
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
    await storage.write(
      key: 'user_data',
      value: jsonEncode({'user_id': userId, 'email': email, 'name': 'E2E', 'provider': 'google', 'avatar_url': null}),
    );
    await UserPreferencesService.setUserInfo(isSignedIn: true, userName: 'E2E', userEmail: email);
    addTearDown(() async {
      await removeLocalTestData();
      await AuthService().clearLocalSession();
    });

    // 1. Profil et préférences
    final user = await AuthService().refreshUserFromBackend();
    expect(user?.userId, userId, reason: 'GET /user/profile');
    expect(user?.email, email);
    await UserPreferencesService.loadPreferencesFromBackend();

    // 2. Statut d'abonnement (compte neuf : pas premium)
    final status = await apiGet(ApiConfig.getSubscriptionStatus);
    expect(status.statusCode, 200, reason: 'GET /subscriptions/status');
    expect((jsonDecode(status.body) as Map)['is_premium'], isFalse);
    await SubscriptionService().syncSubscriptionStatusWithServer();
    expect(SubscriptionService().isPremium, isFalse);

    // 3. Bobine : ajout puis synchro complète ; présence vérifiée CHEZ LE SERVEUR
    final id = 'e2e_backend_${DateTime.now().millisecondsSinceEpoch}';
    final spool = SpoolInventoryItem(
      id: id,
      brand: brand,
      material: 'PETG',
      colorName: 'Transparent',
      colorRgb: 0xFFE6EAEE,
      price: 21.5,
      weight: 1000,
      remainingWeight: 1000,
      addedDate: DateTime.now(),
    );
    await SpoolStorageService.addSpool(spool);
    await SyncService.fullSync();
    var pull = await apiGet(ApiConfig.syncPull);
    expect(pull.statusCode, 200, reason: 'GET /sync/pull');
    expect(pull.body.contains(id), isTrue, reason: 'bobine absente du serveur après la synchro');
    expect((await SpoolStorageService.loadSpools()).any((s) => s.id == id), isTrue,
        reason: 'bobine perdue en local après le pull');

    // 4. Modification + consommation (PUT /spools, POST /usage)
    await SpoolStorageService.updateSpool(id, spool.copyWith(remainingWeight: 640));
    await SyncService.fullSync();
    pull = await apiGet(ApiConfig.syncPull);
    final serverSpool = (((jsonDecode(pull.body) as Map)['data'] as Map)['spools'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((s) => s['spool_id'] == id || s['id'] == id);
    expect(double.parse('${serverSpool['remaining_weight'] ?? serverSpool['remainingWeight']}'), 640,
        reason: 'poids restant non synchronisé');
    final usage = await apiGet(ApiConfig.usage);
    expect(usage.statusCode, 200, reason: 'GET /usage');
    expect(usage.body.contains(id), isTrue, reason: 'consommation absente du serveur');

    // 5. Liste de courses
    await ShoppingListService.addToShoppingList(spool.copyWith(id: '${id}_list'));
    await ShoppingListService.fullSync();
    final list = await apiGet(ApiConfig.shoppingListPull);
    expect(list.statusCode, 200, reason: 'GET /shopping-list/pull');
    expect(list.body.contains('${id}_list'), isTrue, reason: 'article absent du serveur');

    // 6. Analytics connecté (l'événement est rattaché au compte)
    final event = await AuthService().authenticatedRequest(
      (token) => http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logEvent}'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token', ...ApiConfig.commonHeaders},
        body: jsonEncode({'event_type': 'e2e_backend_test', 'event_data': {'ok': true}, 'device_platform': 'ios', 'app_version': 'e2e'}),
      ),
    );
    expect(event.statusCode, 200, reason: 'POST /analytics/event');
    expect(((jsonDecode(event.body) as Map)['data'] as Map?)?['event_id'], isNotNull, reason: 'événement non enregistré');

    // 7. Renouvellement du jeton (POST /auth/refresh)
    final before = await AuthService().getAccessToken();
    await AuthService().refreshAccessToken();
    final after = await AuthService().getAccessToken();
    expect(after, isNotNull);
    expect(after, isNot(before), reason: 'jeton non renouvelé');

    // 8. Suppression du compte par l'écran Profil
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.darkTheme,
      locale: const Locale('fr'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ProfilePage(),
    ));
    await pumpFor(tester, 4000);
    final l = AppLocalizations.of(tester.element(find.byType(ProfilePage)))!;
    await tester.scrollUntilVisible(find.text(l.deleteAccount), 300, scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text(l.deleteAccount));
    await pumpFor(tester);
    await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.text(l.delete)));
    // Le message ne reste que 4 s : on le guette au lieu d'attendre un délai fixe
    var deleted = false;
    var failed = false;
    for (var i = 0; i < 150 && !deleted && !failed; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      deleted = find.text(l.accountDeletionRequested).evaluate().isNotEmpty;
      failed = find.text(l.deleteAccountFailed).evaluate().isNotEmpty;
    }
    expect(deleted, isTrue, reason: failed ? 'DELETE /user/account refusé' : 'aucune réponse en 15 s');
    expect(await UserPreferencesService.isSignedIn(), isFalse, reason: 'session locale non effacée');

    // 9. Le compte n'existe plus : l'ancien jeton est refusé
    final gone = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getUserProfile}'),
      headers: {'Authorization': 'Bearer $after', ...ApiConfig.commonHeaders},
    );
    expect(gone.statusCode, anyOf(401, 404), reason: 'compte encore accessible après suppression');
  });
}
