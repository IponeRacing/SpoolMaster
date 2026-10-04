import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';

/// Issue d'un achat lancé depuis l'app.
enum PurchaseOutcome {
  /// Payé et enregistré par le serveur : premium actif.
  success,

  /// Feuille de paiement fermée sans payer.
  cancelled,

  /// Paiement en attente (approbation parentale, paiement différé) ou
  /// vérification serveur impossible pour l'instant : réessayée plus tard.
  pending,

  /// Échec (store ou serveur).
  failed,
}

/// Abonnement actif tel que renvoyé par le serveur (GET /subscriptions/status).
class SubscriptionDetails {
  const SubscriptionDetails({
    required this.type,
    this.productId,
    this.expiresAt,
    this.autoRenew,
  });

  factory SubscriptionDetails.fromJson(Map<String, dynamic> json) {
    final rawRenew = json['auto_renew_enabled'];
    return SubscriptionDetails(
      type: json['type'] as String? ?? 'subscription',
      productId: json['product_id'] as String?,
      expiresAt: DateTime.tryParse('${json['expires_date'] ?? ''}'.replaceFirst(' ', 'T')),
      autoRenew: rawRenew == null ? null : (rawRenew == true || rawRenew == 1 || rawRenew == '1'),
    );
  }

  /// 'subscription' (store) ou 'vip' (accordé par le support).
  final String type;
  final String? productId;
  final DateTime? expiresAt;
  final bool? autoRenew;

  /// Renouvellement automatique coupé : l'accès s'arrête à [expiresAt].
  bool get endsAtExpiry => type != 'vip' && autoRenew == false && expiresAt != null;
}

/// Résultat de la vérification serveur d'un achat.
enum _Verification {
  /// Enregistré, l'utilisateur est premium.
  premium,

  /// Enregistré (transaction valide), mais pas ou plus active.
  recorded,

  /// Refusé par le serveur.
  rejected,

  /// Réseau, compte non connecté, serveur indisponible : réessayer plus tard.
  retryLater,
}

/// Service de gestion des abonnements In-App Purchase (StoreKit 2 / Play Billing).
///
/// Règles :
/// - un achat n'est finalisé (completePurchase) qu'une fois ENREGISTRÉ par le
///   serveur. Avant, une erreur passagère le finalisait quand même et coupait
///   le premium : l'utilisateur payait sans rien obtenir ;
/// - le statut affiché vient du serveur (source de vérité), synchronisé APRÈS
///   le traitement des achats. Les traitements sont faits un par un : avant,
///   une restauration et une synchro concurrentes s'écrasaient ;
/// - le cache local du premium est propre à chaque compte
///   ([onAccountChanged] à la connexion / déconnexion).
class SubscriptionService {
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();
  static final SubscriptionService _instance = SubscriptionService._internal();

  // Résolu à l'usage : créer le service ne touche pas au plugin du store.
  InAppPurchase get _iap => InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Timer? _statusCheckTimer;
  bool _initialized = false;

  // Product IDs - À CONFIGURER dans App Store Connect
  static const String monthlySubscriptionId = 'spool_master_monthly';
  static const String yearlySubscriptionId = 'spool_master_yearly';

  static const Set<String> _productIds = {
    monthlySubscriptionId,
    yearlySubscriptionId,
  };

  // État de l'abonnement
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  // Produits disponibles
  List<ProductDetails> get products => productsNotifier.value;
  final ValueNotifier<List<ProductDetails>> productsNotifier = ValueNotifier<List<ProductDetails>>(const []);

  // Notifier pour les changements d'abonnement
  final ValueNotifier<bool> premiumStatusNotifier = ValueNotifier<bool>(false);

  /// Détail de l'abonnement actif (null : aucun, ou pas encore synchronisé).
  final ValueNotifier<SubscriptionDetails?> detailsNotifier = ValueNotifier<SubscriptionDetails?>(null);

  /// File : achats, restaurations et synchros sont traités un par un.
  Future<void> _queue = Future<void>.value();

  /// Achat lancé depuis l'app, en attente de son issue sur purchaseStream.
  Completer<PurchaseOutcome>? _purchaseCompleter;
  String? _purchasingProductId;

  /// Achats payés mais pas encore enregistrés par le serveur : non finalisés,
  /// réessayés (synchro périodique, connexion, Restaurer).
  final Map<String, PurchaseDetails> _awaitingVerification = {};

  /// Initialise le service. Rapide : le réseau (produits, synchro, reprise des
  /// achats Android non acquittés) part en arrière-plan.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // Statut premium du compte courant depuis le cache local
    _isPremium = await UserPreferencesService.isPremium();
    premiumStatusNotifier.value = _isPremium;
    AdMobService().setUserPremiumStatus(isPremium: _isPremium);

    // Écouter les achats tout de suite : iOS relivre au lancement les
    // transactions non finalisées.
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (Object error) => debugPrint('❌ Purchase stream error: $error'),
    );

    unawaited(_startupTasks());
    _startPeriodicStatusCheck();
  }

  Future<void> _startupTasks() async {
    try {
      if (!await _iap.isAvailable()) {
        debugPrint('❌ In-App Purchase not available');
      } else {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          final iosPlatformAddition = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
          await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
        }
        await loadProducts();
        await _recoverUnacknowledgedAndroidPurchases();
      }
    } catch (e) {
      debugPrint('❌ Subscription startup error: $e');
    }
    await syncSubscriptionStatusWithServer();
    debugPrint('✅ Subscription service initialized - Premium: $_isPremium');
  }

  /// Démarre la vérification périodique du statut
  void _startPeriodicStatusCheck() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = Timer.periodic(const Duration(minutes: 10), (_) async {
      await _retryAwaitingVerification();
      await syncSubscriptionStatusWithServer();
    });
  }

  /// À appeler après une connexion ou une déconnexion : le premium suit le
  /// compte (avant : le premium d'un compte restait actif pour le suivant).
  Future<void> onAccountChanged() async {
    // Avant initialize() (réconciliation au démarrage, tests) : initialize()
    // lira de toute façon le cache du compte courant.
    if (!_initialized) return;
    _isPremium = await UserPreferencesService.isPremium();
    premiumStatusNotifier.value = _isPremium;
    AdMobService().setUserPremiumStatus(isPremium: _isPremium);
    detailsNotifier.value = null;
    unawaited(() async {
      await _retryAwaitingVerification();
      await _recoverUnacknowledgedAndroidPurchases();
      await syncSubscriptionStatusWithServer();
    }());
  }

  /// Charge les produits depuis le store
  Future<void> loadProducts() async {
    try {
      final response = await _iap.queryProductDetails(_productIds);

      if (response.error != null) {
        debugPrint('❌ Error loading products: ${response.error}');
        return;
      }

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('⚠️ Products not found: ${response.notFoundIDs}');
      }

      productsNotifier.value = response.productDetails;
      debugPrint('✅ Loaded ${response.productDetails.length} products');
    } catch (e) {
      debugPrint('❌ Exception loading products: $e');
    }
  }

  /// Achète un abonnement et attend son issue réelle. Avant, le simple
  /// lancement de la feuille de paiement valait succès : fermer la feuille
  /// affichait « Abonnement activé ».
  Future<PurchaseOutcome> purchaseSubscription(String productId) async {
    if (products.isEmpty) {
      await loadProducts();
    }
    final product = products.where((p) => p.id == productId).firstOrNull;
    if (product == null) {
      debugPrint('❌ Product $productId not found');
      return PurchaseOutcome.failed;
    }

    final completer = Completer<PurchaseOutcome>();
    _purchaseCompleter = completer;
    _purchasingProductId = productId;

    try {
      final launched = await _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
      if (!launched) _resolvePurchase(PurchaseOutcome.failed);
    } on PlatformException catch (e) {
      debugPrint('❌ Purchase error: ${e.code} ${e.message}');
      if (e.code == 'storekit_duplicate_product_object') {
        // Achat déjà payé mais pas encore enregistré : on le fait aboutir
        _resolvePurchase(await restorePurchases() ? PurchaseOutcome.success : PurchaseOutcome.pending);
      } else {
        _resolvePurchase(PurchaseOutcome.failed);
      }
    } catch (e) {
      debugPrint('❌ Purchase error: $e');
      _resolvePurchase(PurchaseOutcome.failed);
    }

    // Issue livrée par purchaseStream ; garde-fou si le store ne répond pas
    return completer.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () {
        if (identical(_purchaseCompleter, completer)) {
          _purchaseCompleter = null;
          _purchasingProductId = null;
        }
        return PurchaseOutcome.pending;
      },
    );
  }

  void _resolvePurchase(PurchaseOutcome outcome, {String? productId}) {
    final completer = _purchaseCompleter;
    if (completer == null || completer.isCompleted) return;
    if (productId != null && _purchasingProductId != null && productId != _purchasingProductId) return;
    _purchaseCompleter = null;
    _purchasingProductId = null;
    completer.complete(outcome);
  }

  Future<T> _serialized<T>(Future<T> Function() task) {
    final result = _queue.then((_) => task());
    _queue = result.then<void>(
      (_) {},
      onError: (Object e, StackTrace st) => debugPrint('❌ Subscription task error: $e'),
    );
    return result;
  }

  void _onPurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    unawaited(_serialized(() => _processPurchases(purchaseDetailsList)));
  }

  /// Traite les mises à jour d'achat. Toujours appelé via la file.
  Future<void> _processPurchases(List<PurchaseDetails> purchaseDetailsList) async {
    var needsSync = false;
    for (final purchase in purchaseDetailsList) {
      debugPrint('📱 Purchase update: ${purchase.productID} - ${purchase.status}');
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _resolvePurchase(PurchaseOutcome.pending, productId: purchase.productID);
        case PurchaseStatus.canceled:
          await _complete(purchase);
          _resolvePurchase(PurchaseOutcome.cancelled, productId: purchase.productID);
        case PurchaseStatus.error:
          debugPrint('❌ Purchase error: ${purchase.error}');
          await _complete(purchase);
          _resolvePurchase(PurchaseOutcome.failed, productId: purchase.productID);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final isNewPurchase = purchase.status == PurchaseStatus.purchased;
          switch (await _verifyPurchaseWithServer(purchase)) {
            case _Verification.premium:
              _awaitingVerification.remove(_key(purchase));
              await _complete(purchase);
              await _setPremium(true);
              needsSync = true;
              if (isNewPurchase) _resolvePurchase(PurchaseOutcome.success, productId: purchase.productID);
            case _Verification.recorded:
              // Transaction valide mais expirée (restauration d'un ancien achat)
              _awaitingVerification.remove(_key(purchase));
              await _complete(purchase);
              needsSync = true;
              if (isNewPurchase) _resolvePurchase(PurchaseOutcome.failed, productId: purchase.productID);
            case _Verification.rejected:
              // Ni premium ni finalisation : Google rembourse un achat non
              // acquitté, iOS le représentera après correction côté serveur.
              _awaitingVerification.remove(_key(purchase));
              if (isNewPurchase) _resolvePurchase(PurchaseOutcome.failed, productId: purchase.productID);
            case _Verification.retryLater:
              _awaitingVerification[_key(purchase)] = purchase;
              if (isNewPurchase) _resolvePurchase(PurchaseOutcome.pending, productId: purchase.productID);
          }
      }
    }
    // Statut final = celui du serveur (VIP, autre abonnement, transfert…)
    if (needsSync) await _syncStatus();
  }

  String _key(PurchaseDetails purchase) =>
      '${purchase.productID}|${purchase.purchaseID ?? purchase.verificationData.serverVerificationData.hashCode}';

  Future<void> _complete(PurchaseDetails purchase) async {
    if (!purchase.pendingCompletePurchase) return;
    try {
      await _iap.completePurchase(purchase);
    } catch (e) {
      debugPrint('⚠️ completePurchase error: $e');
    }
  }

  /// Vérifie l'achat avec le serveur (JWS App Store ou jeton Google Play).
  Future<_Verification> _verifyPurchaseWithServer(PurchaseDetails purchase) async {
    // Pas de compte : l'achat sera rattaché à la connexion
    if (await AuthService().getAccessToken() == null) {
      debugPrint('⏳ No auth token - purchase kept for verification after login');
      return _Verification.retryLater;
    }

    final signedTransaction = purchase.verificationData.serverVerificationData;
    if (signedTransaction.isEmpty) {
      debugPrint('❌ No signed transaction data - cannot verify purchase');
      return _Verification.rejected;
    }
    final platform = defaultTargetPlatform == TargetPlatform.android ? 'android' : 'ios';

    try {
      final response = await AuthService().authenticatedRequest((token) => http.post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.verifySubscription}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              ...ApiConfig.commonHeaders,
            },
            body: jsonEncode({
              'signedTransaction': signedTransaction,
              'productId': purchase.productID,
              'platform': platform,
            }),
          ).timeout(const Duration(seconds: 20)));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] != true) return _Verification.rejected;
        final subscription = data['subscription'] as Map<String, dynamic>?;
        return subscription?['is_premium'] == true ? _Verification.premium : _Verification.recorded;
      }
      debugPrint('❌ Server verification failed: ${response.statusCode}');
      if (response.statusCode == 401 || response.statusCode == 429 || response.statusCode >= 500) {
        return _Verification.retryLater;
      }
      return _Verification.rejected;
    } catch (e) {
      debugPrint('⏳ Verification unavailable, will retry: $e');
      return _Verification.retryLater;
    }
  }

  Future<void> _retryAwaitingVerification() async {
    if (_awaitingVerification.isEmpty) return;
    await _serialized(() => _processPurchases(_awaitingVerification.values.toList()));
  }

  /// Android : un achat payé mais jamais acquitté (app tuée avant la fin) est
  /// remboursé par Google au bout de 3 jours. On le reprend au démarrage.
  Future<void> _recoverUnacknowledgedAndroidPurchases() async {
    if (defaultTargetPlatform != TargetPlatform.android) return;
    if (await AuthService().getAccessToken() == null) return;
    try {
      final addition = _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final response = await addition.queryPastPurchases();
      final unacknowledged = response.pastPurchases
          .where((p) => p.status == PurchaseStatus.purchased && !p.billingClientPurchase.isAcknowledged)
          .toList();
      if (unacknowledged.isEmpty) return;
      debugPrint('🔁 ${unacknowledged.length} unacknowledged purchase(s) recovered');
      await _serialized(() => _processPurchases(unacknowledged));
    } catch (e) {
      debugPrint('⚠️ Past purchases query failed: $e');
    }
  }

  /// Synchronise le statut d'abonnement avec le serveur
  /// Appelé au démarrage et périodiquement
  Future<void> syncSubscriptionStatusWithServer() => _serialized(_syncStatus);

  Future<void> _syncStatus() async {
    // Invité (pas de token) : rien à synchroniser.
    if (await AuthService().getAccessToken() == null) return;
    try {
      final response = await AuthService().authenticatedRequest((token) => http.get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getSubscriptionStatus}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              ...ApiConfig.commonHeaders,
            },
          ).timeout(const Duration(seconds: 10)));

      if (response.statusCode != 200) {
        debugPrint('⚠️ Server sync failed: ${response.statusCode}');
        return;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final subscription = data['subscription'];
      detailsNotifier.value =
          subscription is Map<String, dynamic> ? SubscriptionDetails.fromJson(subscription) : null;
      await _setPremium(data['is_premium'] == true);
      debugPrint('🔄 Server subscription status: $_isPremium');
    } catch (e) {
      debugPrint('❌ Error syncing with server: $e');
    }
  }

  Future<void> _setPremium(bool value) async {
    await UserPreferencesService.setPremium(isPremium: value);
    if (_isPremium == value) return;
    _isPremium = value;
    premiumStatusNotifier.value = value;
    AdMobService().setUserPremiumStatus(isPremium: value);
    debugPrint(value ? '🌟 Premium activated - Ads disabled' : '📱 Premium deactivated - Ads enabled');
  }

  /// Restaure les achats du compte store et renvoie le statut premium final,
  /// une fois chaque achat restauré vérifié par le serveur.
  Future<bool> restorePurchases() async {
    debugPrint('🔄 Restoring purchases...');
    await _iap.restorePurchases();
    // Les achats restaurés arrivent sur purchaseStream : leur laisser le
    // temps d'arriver, puis attendre la fin de leur traitement.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    await _serialized(() async {});
    await _retryAwaitingVerification();
    await syncSubscriptionStatusWithServer();
    return _isPremium;
  }

  /// Vérifie le statut d'abonnement actuel via le serveur
  Future<void> checkSubscriptionStatus() => syncSubscriptionStatusWithServer();

  /// Nettoie les ressources
  void dispose() {
    _subscription?.cancel();
    _statusCheckTimer?.cancel();
  }
}

/// Delegate pour gérer les transactions StoreKit 2
/// Best practice 2025: Requis pour les nouvelles apps
class ExamplePaymentQueueDelegate extends SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    // Retourner true pour continuer la transaction
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    // Retourner false car on gère ça nous-mêmes
    return false;
  }
}
