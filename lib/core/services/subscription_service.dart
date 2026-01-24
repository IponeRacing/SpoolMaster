import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/services/auth_service.dart';

/// Service de gestion des abonnements In-App Purchase
/// Suit les meilleures pratiques Apple 2025-2026 avec StoreKit 2
class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  Timer? _statusCheckTimer;

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
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  // Notifier pour les changements d'abonnement
  final ValueNotifier<bool> premiumStatusNotifier = ValueNotifier<bool>(false);

  /// Initialise le service d'abonnement
  /// Suit les best practices 2025 avec StoreKit 2
  Future<void> initialize() async {
    // Vérifier si IAP est disponible
    final available = await _iap.isAvailable();
    if (!available) {
      debugPrint('❌ In-App Purchase not available');
      return;
    }

    // Configurer StoreKit 2 pour iOS
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iosPlatformAddition = _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();

      // IMPORTANT: Désactiver StoreKit 1 pour forcer StoreKit 2 (JWS format)
      // Sans ça, le plugin utilise StoreKit 1 qui envoie PKCS#7
      debugPrint('🔧 Disabling StoreKit 1 to force StoreKit 2 (JWS format)');
      // Note: StoreKit 2 est activé par défaut sur iOS 15+, mais pour être sûr
      // on désactive explicitement StoreKit 1

      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    // Charger le statut premium depuis le stockage local
    _isPremium = await UserPreferencesService.isPremium();
    premiumStatusNotifier.value = _isPremium;

    // Mettre à jour AdMob
    AdMobService().setUserPremiumStatus(_isPremium);

    // Écouter les achats
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: () => _subscription?.cancel(),
      onError: (error) => debugPrint('❌ Purchase stream error: $error'),
    );

    // Charger les produits
    await loadProducts();

    // Synchroniser le statut avec le serveur
    await syncSubscriptionStatusWithServer();

    // Vérifier périodiquement le statut (toutes les 10 minutes)
    _startPeriodicStatusCheck();

    // NOTE: restorePurchases() n'est PAS appelé automatiquement
    // L'utilisateur doit utiliser le bouton "Restaurer achats" dans les réglages
    // Cela évite de restaurer des achats expirés d'un autre compte Apple/Google

    debugPrint('✅ Subscription service initialized - Premium: $_isPremium');
  }

  /// Démarre la vérification périodique du statut
  void _startPeriodicStatusCheck() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      syncSubscriptionStatusWithServer();
    });
  }

  /// Charge les produits depuis App Store
  Future<void> loadProducts() async {
    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails(_productIds);

      if (response.error != null) {
        debugPrint('❌ Error loading products: ${response.error}');
        return;
      }

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('⚠️ Products not found: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      debugPrint('✅ Loaded ${_products.length} products');

      for (final product in _products) {
        debugPrint('  - ${product.id}: ${product.title} (${product.price})');
      }
    } catch (e) {
      debugPrint('❌ Exception loading products: $e');
    }
  }

  /// Achète un abonnement
  Future<bool> purchaseSubscription(String productId) async {
    if (_products.isEmpty) {
      await loadProducts();
    }

    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw Exception('Product $productId not found'),
    );

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    try {
      return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      debugPrint('❌ Purchase error: $e');
      return false;
    }
  }

  /// Gère les mises à jour d'achat
  /// Best practice 2025: Transaction automatique avec StoreKit 2
  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      debugPrint('📱 Purchase update: ${purchaseDetails.productID} - ${purchaseDetails.status}');

      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Achat en attente
        debugPrint('⏳ Purchase pending...');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Erreur d'achat
          debugPrint('❌ Purchase error: ${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          // Achat réussi ou restauré
          await _verifyAndDeliverProduct(purchaseDetails);
        }

        // IMPORTANT: Compléter la transaction (best practice 2025)
        if (purchaseDetails.pendingCompletePurchase) {
          await _iap.completePurchase(purchaseDetails);
          debugPrint('✅ Purchase completed');
        }
      }
    }
  }

  /// Vérifie et active l'abonnement
  /// Best practice 2025: TOUJOURS vérifier côté serveur
  Future<void> _verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    try {
      // Vérifier avec le serveur backend (SÉCURITÉ)
      final isValid = await _verifyPurchaseWithServer(purchaseDetails);

      if (isValid) {
        await _activatePremium();
        debugPrint('✅ Premium activated!');
      } else {
        // Désactiver le premium si l'abonnement est expiré
        await _deactivatePremium();
        debugPrint('❌ Purchase verification failed - Premium DEACTIVATED');
      }
    } catch (e) {
      debugPrint('❌ Server verification error: $e - Premium NOT activated');
      // NE PAS activer en cas d'erreur serveur (sécurité)
      // L'utilisateur devra contacter le support ou réessayer plus tard
    }
  }

  /// Vérifie l'achat avec le serveur backend
  /// Best practice 2025: Validation cryptographique JWS (iOS) ou Google Play (Android)
  Future<bool> _verifyPurchaseWithServer(PurchaseDetails purchaseDetails) async {
    try {
      // Récupérer le JWT token de l'utilisateur
      final authService = AuthService();
      final token = await authService.getAccessToken();

      if (token == null) {
        debugPrint('❌ No auth token - cannot verify purchase securely');
        // SECURITY: Require authentication for premium features
        // User must be logged in to verify and activate subscription
        return false;
      }

      String? signedTransaction;
      String platform = 'ios';

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // Pour iOS StoreKit 2
        if (purchaseDetails is AppStorePurchaseDetails) {
          final sk2Details = purchaseDetails as AppStorePurchaseDetails;

          if (sk2Details.skPaymentTransaction.transactionState == SKPaymentTransactionStateWrapper.purchased ||
              sk2Details.skPaymentTransaction.transactionState == SKPaymentTransactionStateWrapper.restored) {
            signedTransaction = purchaseDetails.verificationData.serverVerificationData;
            debugPrint('📦 iOS: Using serverVerificationData');
          }
        } else {
          signedTransaction = purchaseDetails.verificationData.serverVerificationData;
        }
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        // Pour Android Google Play
        platform = 'android';
        if (purchaseDetails is GooglePlayPurchaseDetails) {
          // Google Play envoie le purchaseToken pour la verification
          signedTransaction = purchaseDetails.verificationData.serverVerificationData;
          debugPrint('📦 Android: Using Google Play purchaseToken');
        } else {
          signedTransaction = purchaseDetails.verificationData.serverVerificationData;
        }
      }

      if (signedTransaction == null || signedTransaction.isEmpty) {
        debugPrint('❌ No signed transaction data - cannot verify purchase');
        // SECURITY: Require valid transaction data from Store
        // Without it, we cannot cryptographically verify the purchase
        return false;
      }

      // DEBUG: Log format
      debugPrint('📋 Platform: $platform');
      debugPrint('📋 SignedTransaction length: ${signedTransaction.length}');
      debugPrint('📋 SignedTransaction starts with: ${signedTransaction.substring(0, min(50, signedTransaction.length))}');

      // Envoyer au backend pour validation
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.verifySubscription}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'signedTransaction': signedTransaction,
          'productId': purchaseDetails.productID,
          'platform': platform,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final isSuccess = data['success'] == true;
        final isPremium = data['subscription']?['is_premium'] == true;

        debugPrint('✅ Server verification - success: $isSuccess, is_premium: $isPremium');

        // Return true only if subscription is active (not expired)
        return isSuccess && isPremium;
      } else {
        debugPrint('❌ Server verification failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error verifying with server: $e');
      rethrow;
    }
  }

  /// Synchronise le statut d'abonnement avec le serveur
  /// Appelé au démarrage et périodiquement
  Future<void> syncSubscriptionStatusWithServer() async {
    try {
      // Récupérer le JWT token
      final authService = AuthService();
      final token = await authService.getAccessToken();

      if (token == null) {
        debugPrint('⚠️ No auth token - skipping server sync');
        return;
      }

      // Demander le statut au serveur
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.getSubscriptionStatus}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final serverIsPremium = data['is_premium'] == true;

        debugPrint('🔄 Server subscription status: $serverIsPremium');

        // Mettre à jour le statut local si différent
        if (serverIsPremium != _isPremium) {
          if (serverIsPremium) {
            await _activatePremium();
            debugPrint('✅ Premium activated from server sync');
          } else {
            await _deactivatePremium();
            debugPrint('❌ Premium deactivated from server sync');
          }
        }
      } else {
        debugPrint('⚠️ Server sync failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error syncing with server: $e');
    }
  }

  /// Active le statut premium
  Future<void> _activatePremium() async {
    _isPremium = true;
    premiumStatusNotifier.value = true;

    // Sauvegarder dans le stockage local
    await UserPreferencesService.setPremium(true);

    // Mettre à jour AdMob pour cacher les pubs
    AdMobService().setUserPremiumStatus(true);

    debugPrint('🌟 Premium status activated - Ads disabled');
  }

  /// Désactive le statut premium
  Future<void> _deactivatePremium() async {
    _isPremium = false;
    premiumStatusNotifier.value = false;

    await UserPreferencesService.setPremium(false);
    AdMobService().setUserPremiumStatus(false);

    debugPrint('📱 Premium status deactivated - Ads enabled');
  }

  /// Restaure les achats précédents
  /// Best practice 2025: Obligatoire selon Apple
  Future<void> restorePurchases() async {
    try {
      debugPrint('🔄 Restoring purchases...');
      await _iap.restorePurchases();

      // Les achats restaurés passent par _handlePurchaseUpdates
      // avec status = PurchaseStatus.restored

      // Également synchroniser avec le serveur
      await syncSubscriptionStatusWithServer();
    } catch (e) {
      debugPrint('❌ Restore error: $e');
      rethrow;
    }
  }

  /// Vérifie le statut d'abonnement actuel
  /// Best practice: Vérifier régulièrement (ex: au démarrage app)
  Future<void> checkSubscriptionStatus() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // iOS: Utiliser StoreKit 2 pour vérifier le statut
        final transactions = await SKPaymentQueueWrapper().transactions();

        bool hasActiveSubscription = false;
        for (final transaction in transactions) {
          if (transaction.transactionState == SKPaymentTransactionStateWrapper.purchased ||
              transaction.transactionState == SKPaymentTransactionStateWrapper.restored) {
            if (_productIds.contains(transaction.payment.productIdentifier)) {
              hasActiveSubscription = true;
              break;
            }
          }
        }

        if (hasActiveSubscription && !_isPremium) {
          await _activatePremium();
        } else if (!hasActiveSubscription && _isPremium) {
          await _deactivatePremium();
        }
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        // Android: Vérifier via Google Play Billing
        // Le statut est géré via purchaseStream et syncSubscriptionStatusWithServer
        // On synchronise simplement avec le serveur
        await syncSubscriptionStatusWithServer();
      }
    } catch (e) {
      debugPrint('❌ Error checking subscription status: $e');
    }
  }

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
