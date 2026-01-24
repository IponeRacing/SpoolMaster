import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nfc_filament/core/services/admob_service.dart';

/// Widget de bannière publicitaire réutilisable
/// Gère le chargement, l'affichage et le dispose automatique
class AdBannerWidget extends StatefulWidget {
  final String adUnitId;
  final AdSize adSize;
  final EdgeInsets margin;

  const AdBannerWidget({
    super.key,
    required this.adUnitId,
    this.adSize = AdSize.banner,
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
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    // Ne charge pas si l'utilisateur est premium
    debugPrint('📺 AdBannerWidget: shouldShowAds = ${_adMobService.shouldShowAds}');
    if (!_adMobService.shouldShowAds) {
      debugPrint('📺 AdBannerWidget: Skipping ad load (premium user)');
      return;
    }

    _bannerAd = _adMobService.createBannerAd(
      adUnitId: widget.adUnitId,
      adSize: widget.adSize,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
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
      debugPrint('📺 AdBannerWidget build: Hidden (premium user)');
      return const SizedBox.shrink();
    }
    debugPrint('📺 AdBannerWidget build: isLoaded=$_isLoaded, bannerAd=${_bannerAd != null}');

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
