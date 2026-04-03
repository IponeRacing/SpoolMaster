import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nfc_filament/core/services/admob_service.dart';

/// Widget de bannière publicitaire réutilisable
/// Gère le chargement, l'affichage et le dispose automatique
/// Utilise des adaptive banners pour un meilleur fill rate
class AdBannerWidget extends StatefulWidget {
  final String adUnitId;
  final EdgeInsets margin;

  const AdBannerWidget({
    super.key,
    required this.adUnitId,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final AdMobService _adMobService = AdMobService();

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

    // Adaptive banner basé sur la largeur de l'écran
    final width = MediaQuery.of(context).size.width.truncate();
    final adaptiveSize = await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      width,
    );
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
