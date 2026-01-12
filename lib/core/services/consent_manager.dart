import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

/// Gestionnaire de consentements pour ATT (iOS) et UMP (GDPR)
class ConsentManager {
  static final ConsentManager _instance = ConsentManager._internal();
  factory ConsentManager() => _instance;
  ConsentManager._internal();

  bool _hasRequestedATT = false;
  bool _hasRequestedUMP = false;

  /// Demande le consentement ATT (App Tracking Transparency) sur iOS
  /// Doit être appelé AVANT d'initialiser AdMob
  Future<bool> requestATTConsent() async {
    if (!Platform.isIOS || _hasRequestedATT) {
      return true;
    }

    try {
      debugPrint('🔐 [ATT] Requesting tracking authorization...');

      // Vérifier le statut actuel
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      debugPrint('🔐 [ATT] Current status: $status');

      // Si déjà déterminé, pas besoin de redemander
      if (status == TrackingStatus.authorized ||
          status == TrackingStatus.denied ||
          status == TrackingStatus.restricted) {
        _hasRequestedATT = true;
        debugPrint('🔐 [ATT] Status already determined: $status');
        return status == TrackingStatus.authorized;
      }

      // Demander la permission
      final newStatus = await AppTrackingTransparency.requestTrackingAuthorization();
      _hasRequestedATT = true;

      debugPrint('🔐 [ATT] User response: $newStatus');

      return newStatus == TrackingStatus.authorized;
    } catch (e) {
      debugPrint('❌ [ATT] Error requesting consent: $e');
      _hasRequestedATT = true;
      return false;
    }
  }

  /// Demande le consentement UMP (User Messaging Platform) pour GDPR
  /// Doit être appelé AVANT de charger les publicités
  Future<bool> requestUMPConsent() async {
    if (_hasRequestedUMP) {
      return true;
    }

    try {
      debugPrint('🔐 [UMP] Requesting GDPR consent...');

      // Créer un Completer pour transformer le callback en Future
      final completer = Completer<bool>();

      final params = ConsentRequestParameters();

      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          // Succès - informations mises à jour
          debugPrint('🔐 [UMP] Consent info updated successfully');

          // Charger et afficher le formulaire si nécessaire
          ConsentForm.loadAndShowConsentFormIfRequired((loadAndShowError) {
            if (loadAndShowError != null) {
              debugPrint('❌ [UMP] Form error: ${loadAndShowError.message}');
              completer.complete(false);
            } else {
              debugPrint('✅ [UMP] Consent form completed');
              completer.complete(true);
            }
          });
        },
        (FormError error) {
          // Erreur lors de la mise à jour
          debugPrint('❌ [UMP] Error updating consent info: ${error.message}');
          completer.complete(false);
        },
      );

      _hasRequestedUMP = true;
      return await completer.future;
    } catch (e) {
      debugPrint('❌ [UMP] Exception requesting consent: $e');
      _hasRequestedUMP = true;
      // En cas d'erreur, on continue (mieux que de bloquer l'app)
      return true;
    }
  }

  /// Réinitialise le consentement (pour les tests)
  Future<void> resetConsent() async {
    try {
      await ConsentInformation.instance.reset();
      _hasRequestedUMP = false;
      debugPrint('🔐 [UMP] Consent reset');
    } catch (e) {
      debugPrint('❌ [UMP] Error resetting consent: $e');
    }
  }

  /// Demande tous les consentements dans le bon ordre
  /// 1. ATT (iOS uniquement)
  /// 2. UMP (GDPR)
  Future<void> requestAllConsents() async {
    debugPrint('🔐 [CONSENT] Starting consent flow...');

    // 1. ATT d'abord (iOS uniquement)
    if (Platform.isIOS) {
      final attGranted = await requestATTConsent();
      debugPrint('🔐 [CONSENT] ATT granted: $attGranted');
    }

    // 2. UMP pour GDPR
    final umpGranted = await requestUMPConsent();
    debugPrint('🔐 [CONSENT] UMP granted: $umpGranted');

    debugPrint('✅ [CONSENT] Consent flow completed');
  }

  /// Vérifie si on peut afficher des publicités personnalisées
  Future<bool> canShowPersonalizedAds() async {
    try {
      final status = await ConsentInformation.instance.getConsentStatus();
      return status == ConsentStatus.obtained;
    } catch (e) {
      debugPrint('❌ [CONSENT] Error checking personalized ads: $e');
      return false;
    }
  }
}
