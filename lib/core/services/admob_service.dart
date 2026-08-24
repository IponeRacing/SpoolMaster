import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nfc_filament/core/services/consent_manager.dart';

/// Service de gestion des publicités AdMob
/// Gère plusieurs unités publicitaires pour différentes sections de l'app
class AdMobService {
  factory AdMobService() => _instance;
  AdMobService._internal();
  static final AdMobService _instance = AdMobService._internal();

  bool _isInitialized = false;
  bool _isPremiumUser = false;
  final _consentManager = ConsentManager();

  // ==================== INTERSTITIAL ====================

  InterstitialAd? _interstitialAd;
  int _scansSinceLastAd = 0;
  static const int _scansBeforeAd = 4;

  /// Initialise le SDK AdMob (sans ATT - celui-ci doit être demandé après que l'UI soit visible)
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialiser AdMob (ATT est demandé séparément depuis SplashPage)
    await MobileAds.instance.initialize();
    _isInitialized = true;
    debugPrint('✅ AdMob initialized');
  }

  /// Demande les consentements ATT + UMP
  /// Doit être appelé APRÈS que l'UI soit visible (ex: depuis SplashPage)
  Future<void> requestConsents() async {
    await _consentManager.requestAllConsents();
  }

  /// Met à jour le statut premium de l'utilisateur
  void setUserPremiumStatus({required bool isPremium}) {
    _isPremiumUser = isPremium;
    debugPrint('🎯 AdMob: User premium status = $isPremium');
  }

  /// Vérifie si les pubs doivent être affichées
  bool get shouldShowAds => !_isPremiumUser;

  // ==================== AD UNIT IDs ====================

  /// ID TEST pour développement (bannière)
  static const String _testBannerId = 'ca-app-pub-3940256099942544/6300978111';

  /// ID TEST pour développement (interstitiel)
  static const String _testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';

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

  /// Interstitial ID pour après les scans NFC
  String get _interstitialAdUnitId {
    if (kDebugMode) return _testInterstitialId;
    return Platform.isIOS
        ? 'ca-app-pub-1694665328356929/4229381082'
        : 'ca-app-pub-1694665328356929/7435068272';
  }

  // ==================== INTERSTITIAL LOADING ====================

  /// Précharge un interstitiel pour affichage instantané
  void preloadInterstitial() {
    if (!shouldShowAds) return;

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('✅ Interstitial preloaded');
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              preloadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('❌ Interstitial failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('❌ Interstitial failed to preload: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Appelé après chaque scan NFC réussi
  void onScanCompleted() {
    if (!shouldShowAds) return;

    _scansSinceLastAd++;
    debugPrint('📊 Scans since last ad: $_scansSinceLastAd/$_scansBeforeAd');

    if (_scansSinceLastAd >= _scansBeforeAd) {
      _scansSinceLastAd = 0;
      _showInterstitial();
    }
  }

  void _showInterstitial() {
    if (_interstitialAd != null) {
      debugPrint('📺 Showing interstitial ad');
      _interstitialAd!.show();
    } else {
      debugPrint('⚠️ Interstitial not ready, preloading...');
      preloadInterstitial();
    }
  }

  // ==================== BANNER LOADING ====================

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
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
