import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/subscription_service.dart';

/// Widget de bannière publicitaire réutilisable
/// Gère le chargement, l'affichage et le dispose automatique
/// Utilise des adaptive banners pour un meilleur fill rate
class AdBannerWidget extends StatefulWidget {

  const AdBannerWidget({
    required this.adUnitId, super.key,
    this.margin = EdgeInsets.zero,
  });
  final String adUnitId;
  final EdgeInsets margin;

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final AdMobService _adMobService = AdMobService();

  @override
  void initState() {
    super.initState();
    // Réagir aux changements de statut premium : cacher immédiatement la
    // bannière quand le premium s'active (sync serveur, restauration d'achat)
    // sans attendre un redémarrage de l'app.
    SubscriptionService().premiumStatusNotifier.addListener(_onPremiumChanged);
  }

  void _onPremiumChanged() {
    if (!mounted) return;
    if (SubscriptionService().isPremium) {
      _bannerAd?.dispose();
      _bannerAd = null;
      setState(() => _isLoaded = false);
    } else if (_bannerAd == null) {
      // Premium expiré → recharger une bannière
      _loadAd();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerAd == null) {
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    // Ne charge pas si l'utilisateur est premium
    debugPrint('📺 AdBannerWidget: shouldShowAds = ${_adMobService.shouldShowAds}');
    if (!_adMobService.shouldShowAds) {
      debugPrint('📺 AdBannerWidget: Skipping ad load (premium user)');
      return;
    }

    // Anchored adaptive banner STANDARD (hauteur calée sur la largeur, ~50-60px).
    // On évite volontairement la variante "Large" : elle réserve un slot jusqu'à
    // ~100px de haut et laisse AdMob letterboxer les créas 50px → bandes sombres
    // au-dessus/dessous de la pub. Le standard remplit pleinement le slot.
    final width = MediaQuery.of(context).size.width.truncate();
    // Le remplaçant suggéré (getLargeAnchoredAdaptiveBannerAdSize) est justement
    // celui qui cause les bandes sombres → on garde le standard sciemment.
    // ignore: deprecated_member_use
    final adaptiveSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    final adSize = adaptiveSize ?? AdSize.banner;

    _bannerAd = _adMobService.createBannerAd(
      adUnitId: widget.adUnitId,
      adSize: adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    await _bannerAd?.load();
  }

  @override
  void dispose() {
    SubscriptionService().premiumStatusNotifier.removeListener(_onPremiumChanged);
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // N'affiche rien si premium
    if (!_adMobService.shouldShowAds) {
      return const SizedBox.shrink();
    }

    // N'affiche rien si pas chargé
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: widget.margin,
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
