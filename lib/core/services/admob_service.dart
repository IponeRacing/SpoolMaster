import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nfc_filament/core/services/consent_manager.dart';

/// Service de gestion des publicités AdMob
/// Gère plusieurs unités publicitaires pour différentes sections de l'app
class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  bool _isInitialized = false;
  bool _isPremiumUser = false;
  final _consentManager = ConsentManager();

  /// Initialise le SDK AdMob
  /// IMPORTANT: Demande les consentements (ATT + UMP) AVANT d'initialiser AdMob
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Demander les consentements AVANT d'initialiser AdMob
    debugPrint('🔐 Requesting user consents before AdMob initialization...');
    await _consentManager.requestAllConsents();

    // 2. Initialiser AdMob après les consentements
    await MobileAds.instance.initialize();
    _isInitialized = true;
    debugPrint('✅ AdMob initialized');
  }

  /// Met à jour le statut premium de l'utilisateur
  void setUserPremiumStatus(bool isPremium) {
    _isPremiumUser = isPremium;
    debugPrint('🎯 AdMob: User premium status = $isPremium');
  }

  /// Vérifie si les pubs doivent être affichées
  bool get shouldShowAds => !_isPremiumUser;

  // ==================== AD UNIT IDs ====================

  /// ID TEST pour développement (bannière)
  static const String _testBannerId = 'ca-app-pub-3940256099942544/6300978111';

  // IMPORTANT: Remplacer ces IDs par vos vrais IDs AdMob en production

  /// Banner ID pour page NFC Reader
  String get nfcReaderBannerId {
    if (kDebugMode) return _testBannerId;
    return 'ca-app-pub-1694665328356929/7028710600';
  }

  /// Banner ID pour page NFC Writer
  String get nfcWriterBannerId {
    if (kDebugMode) return _testBannerId;
    return 'ca-app-pub-1694665328356929/7687186157';
  }

  /// Banner ID pour page Stock
  String get stockBannerId {
    if (kDebugMode) return _testBannerId;
    return 'ca-app-pub-1694665328356929/9654873940';
  }

  /// Banner ID pour page Analytics
  String get analyticsBannerId {
    if (kDebugMode) return _testBannerId;
    return 'ca-app-pub-1694665328356929/3747941147';
  }

  /// Banner ID pour liste Stock (in-list ads)
  String get stockListBannerId {
    if (kDebugMode) return _testBannerId;
    return 'ca-app-pub-1694665328356929/8808696135';
  }

  /// Banner ID pour liste Commissions (in-list ads)
  String get commissionsListBannerId {
    if (kDebugMode) return _testBannerId;
    return 'ca-app-pub-1694665328356929/4869451128';
  }

  /// Banner ID pour historique NFC
  String get nfcHistoryBannerId {
    if (kDebugMode) return _testBannerId;
    return 'ca-app-pub-1694665328356929/1233458449';
  }

  // ==================== AD LOADING ====================

  /// Crée un BannerAd avec l'ID spécifié
  BannerAd createBannerAd({
    required String adUnitId,
    AdSize adSize = AdSize.banner,
    BannerAdListener? listener,
  }) {
    return BannerAd(
      adUnitId: adUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: listener ?? _defaultBannerAdListener,
    );
  }

  /// Listener par défaut pour les bannières
  BannerAdListener get _defaultBannerAdListener => BannerAdListener(
    onAdLoaded: (ad) => debugPrint('✅ Ad loaded: ${ad.adUnitId}'),
    onAdFailedToLoad: (ad, error) {
      debugPrint('❌ Ad failed to load: ${ad.adUnitId} - $error');
      ad.dispose();
    },
    onAdOpened: (ad) => debugPrint('📱 Ad opened: ${ad.adUnitId}'),
    onAdClosed: (ad) => debugPrint('🔒 Ad closed: ${ad.adUnitId}'),
  );

  /// Dispose toutes les ressources
  void dispose() {
    // Cleanup si nécessaire
  }
}
