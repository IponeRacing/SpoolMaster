import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// Interface de plateforme (dépendance transitive de in_app_purchase) : seul
// moyen de brancher un store simulé.
// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/subscription_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Store simulé : on décide quels événements arrivent sur purchaseStream.
class FakeStore extends InAppPurchasePlatform {
  final StreamController<List<PurchaseDetails>> controller = StreamController.broadcast();
  final List<String> completed = [];
  List<PurchaseDetails> Function(PurchaseParam param)? onBuy;
  List<PurchaseDetails> restorable = [];

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => controller.stream;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> identifiers) async => ProductDetailsResponse(
        productDetails: identifiers
            .map((id) => ProductDetails(
                  id: id,
                  title: id,
                  description: '',
                  price: 'CHF 1.00',
                  rawPrice: 1,
                  currencyCode: 'CHF',
                ))
            .toList(),
        notFoundIDs: const [],
      );

  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    final events = onBuy?.call(purchaseParam) ?? const <PurchaseDetails>[];
    scheduleMicrotask(() => controller.add(events));
    return true;
  }

  @override
  Future<void> completePurchase(PurchaseDetails purchase) async {
    completed.add(purchase.purchaseID ?? '');
    purchase.pendingCompletePurchase = false;
  }

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {
    controller.add(List.of(restorable));
  }
}

PurchaseDetails purchase(String id, PurchaseStatus status, {String product = SubscriptionService.monthlySubscriptionId}) =>
    PurchaseDetails(
      purchaseID: id,
      productID: product,
      verificationData: PurchaseVerificationData(
        localVerificationData: '',
        serverVerificationData: 'jws-$id',
        source: 'test',
      ),
      transactionDate: '0',
      status: status,
    )..pendingCompletePurchase = status != PurchaseStatus.pending;

/// Serveur simulé
String verifyMode = 'premium'; // premium | expired | reject | down
bool serverPremium = false;
bool? serverAutoRenew = true;
final List<String> verifiedIds = [];

http.Client mockServer() => MockClient((request) async {
      if (request.url.path.endsWith('/subscriptions/verify')) {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        verifiedIds.add(body['signedTransaction'] as String);
        switch (verifyMode) {
          case 'down':
            throw http.ClientException('network down');
          case 'reject':
            return http.Response(jsonEncode({'success': false, 'error': 'Invalid transaction'}), 400);
          case 'expired':
            return http.Response(jsonEncode({'success': true, 'subscription': {'is_premium': false}}), 200);
          default:
            serverPremium = true;
            return http.Response(jsonEncode({'success': true, 'subscription': {'is_premium': true}}), 200);
        }
      }
      if (request.url.path.endsWith('/subscriptions/status')) {
        return http.Response(
          jsonEncode({
            'success': true,
            'is_premium': serverPremium,
            'subscription': serverPremium
                ? {
                    'type': 'subscription',
                    'product_id': 'spool_master_monthly',
                    'status': 'active',
                    'expires_date': '2026-11-04 10:00:00',
                    'auto_renew_enabled': serverAutoRenew,
                  }
                : null,
          }),
          200,
        );
      }
      return http.Response('{}', 404);
    });

Future<T> withServer<T>(Future<T> Function() body) => http.runWithClient(body, mockServer);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeStore store;
  late SubscriptionService service;

  setUpAll(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({'access_token': 'token-user-a'});
    InAppPurchase.instance; // aucune plateforme réelle enregistrée (fuchsia)
    store = FakeStore();
    InAppPurchasePlatform.instance = store;
    service = SubscriptionService();
    // Le reste du code (stockage sécurisé, reprise des achats) en mode Android
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await withServer(service.initialize);
    await withServer(service.syncSubscriptionStatusWithServer);
  });

  tearDownAll(() {
    service.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  test('fermer la feuille de paiement : annulé, pas de premium (avant : « Abonnement activé »)', () async {
    store.onBuy = (p) => [purchase('c1', PurchaseStatus.canceled)];
    final outcome = await withServer(() => service.purchaseSubscription(SubscriptionService.monthlySubscriptionId));
    expect(outcome, PurchaseOutcome.cancelled);
    expect(service.isPremium, isFalse);
  });

  test('erreur réseau à la vérification : en attente, achat NON finalisé, premium inchangé', () async {
    verifyMode = 'down';
    store.onBuy = (p) => [purchase('p1', PurchaseStatus.purchased)];
    final outcome = await withServer(() => service.purchaseSubscription(SubscriptionService.monthlySubscriptionId));
    expect(outcome, PurchaseOutcome.pending);
    expect(store.completed, isNot(contains('p1')));
    expect(service.isPremium, isFalse);
  });

  test("serveur revenu : Restaurer revérifie l'achat en attente, le finalise, premium", () async {
    verifyMode = 'premium';
    store.restorable = [];
    final premium = await withServer(service.restorePurchases);
    expect(premium, isTrue);
    expect(store.completed, contains('p1'));
    expect(await UserPreferencesService.isPremium(), isTrue);
    expect(service.detailsNotifier.value?.autoRenew, isTrue);
  });

  test("renouvellement coupé côté store : le détail l'indique (accès jusqu'à l'échéance)", () async {
    serverAutoRenew = false;
    await withServer(service.syncSubscriptionStatusWithServer);
    expect(service.detailsNotifier.value?.endsAtExpiry, isTrue);
    expect(service.isPremium, isTrue);
  });

  test('achat refusé par le serveur : échec, non finalisé', () async {
    verifyMode = 'reject';
    store.onBuy = (p) => [purchase('r1', PurchaseStatus.purchased, product: SubscriptionService.yearlySubscriptionId)];
    final outcome = await withServer(() => service.purchaseSubscription(SubscriptionService.yearlySubscriptionId));
    expect(outcome, PurchaseOutcome.failed);
    expect(store.completed, isNot(contains('r1')));
  });

  test("restauration d'un ancien achat expiré : finalisé, statut final = serveur (pas d'écrasement)", () async {
    verifyMode = 'expired';
    serverPremium = false;
    store.restorable = [purchase('old1', PurchaseStatus.restored)];
    final premium = await withServer(service.restorePurchases);
    expect(store.completed, contains('old1'));
    expect(premium, isFalse);
    expect(service.isPremium, isFalse);
    expect(service.detailsNotifier.value, isNull);
  });

  test('achat payé et vérifié : succès, finalisé, premium', () async {
    verifyMode = 'premium';
    serverAutoRenew = true;
    store.onBuy = (p) => [purchase('ok1', PurchaseStatus.purchased)];
    final outcome = await withServer(() => service.purchaseSubscription(SubscriptionService.monthlySubscriptionId));
    expect(outcome, PurchaseOutcome.success);
    expect(store.completed, contains('ok1'));
    expect(service.isPremium, isTrue);
    expect(service.premiumStatusNotifier.value, isTrue);
  });

  test('paiement différé (pending) : en attente, rien de finalisé', () async {
    store.onBuy = (p) => [purchase('d1', PurchaseStatus.pending)];
    final outcome = await withServer(() => service.purchaseSubscription(SubscriptionService.monthlySubscriptionId));
    expect(outcome, PurchaseOutcome.pending);
    expect(store.completed, isNot(contains('d1')));
  });

  test("(11) le premium suit le compte : B ne profite pas du premium de A, ni l'invité", () async {
    const storage = FlutterSecureStorage();
    Future<void> signIn(String id) async {
      await storage.write(key: 'access_token', value: 'token-$id');
      await storage.write(key: 'refresh_token', value: 'refresh-$id');
      await storage.write(
        key: 'user_data',
        value: jsonEncode({'user_id': id, 'email': '$id@test.local', 'provider': 'apple'}),
      );
      await UserPreferencesService.setUserInfo(isSignedIn: true);
    }

    await withServer(() async {
      // Compte A premium (confirmé par le serveur)
      await signIn('user-a');
      serverPremium = true;
      await service.onAccountChanged();
      await service.syncSubscriptionStatusWithServer();
      expect(service.isPremium, isTrue);

      // Compte B sur le même appareil : pas de premium hérité
      await signIn('user-b');
      serverPremium = false;
      await service.onAccountChanged();
      expect(service.isPremium, isFalse);
      await service.syncSubscriptionStatusWithServer();
      expect(service.isPremium, isFalse);

      // Déconnexion : invité sans premium
      await AuthService().clearLocalSession();
      expect(await UserPreferencesService.isPremium(), isFalse);
      expect(service.isPremium, isFalse);

      // Retour sur A : son cache revient immédiatement (avant la synchro)
      await signIn('user-a');
      serverPremium = true;
      await service.onAccountChanged();
      expect(service.isPremium, isTrue);
      await service.syncSubscriptionStatusWithServer();
    });
  });

  test('Android sans RTDN : abonnement Google actif, échu côté serveur → revérifié une fois, premium', () async {
    service.debugQueryPastPurchases =
        () async => [purchase('gplay1', PurchaseStatus.purchased)..pendingCompletePurchase = false];
    serverPremium = false;
    verifyMode = 'premium';
    verifiedIds.clear();
    await withServer(service.syncSubscriptionStatusWithServer);
    expect(verifiedIds, ['jws-gplay1']);
    expect(service.isPremium, isTrue);

    // Une seule revérification par lancement (pas de renvoi à chaque synchro)
    serverPremium = false;
    verifyMode = 'expired';
    await withServer(service.syncSubscriptionStatusWithServer);
    expect(verifiedIds, ['jws-gplay1']);
    expect(service.isPremium, isFalse);
    service.debugQueryPastPurchases = null;
  });
}
