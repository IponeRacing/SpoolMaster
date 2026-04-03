import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service pour demander un avis App Store/Play Store
/// Tentative 1 : apres 10 scans reussis, si taux >= 80%
/// Tentative 2 : apres 40 scans reussis, si taux >= 70%
class ReviewService {
  factory ReviewService() => _instance;
  ReviewService._internal();
  static final ReviewService _instance = ReviewService._internal();

  static const String _successCountKey = 'review_success_count';
  static const String _failCountKey = 'review_fail_count';
  static const String _reviewRequestedKey = 'review_already_requested';

  /// Appele apres chaque scan NFC reussi
  Future<void> onSuccessfulScan() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_reviewRequestedKey) ?? false) return;

    final successCount = (prefs.getInt(_successCountKey) ?? 0) + 1;
    await prefs.setInt(_successCountKey, successCount);

    final failCount = prefs.getInt(_failCountKey) ?? 0;
    final total = successCount + failCount;
    final successRate = successCount / total;

    // Tentative 1 : 10 scans reussis + 80% de succes
    if (successCount >= 10 && successRate >= 0.8) {
      await _requestReview(prefs);
      return;
    }

    // Tentative 2 : 40 scans reussis + 70% de succes
    if (successCount >= 40 && successRate >= 0.7) {
      await _requestReview(prefs);
    }
  }

  /// Appele apres chaque scan NFC echoue
  Future<void> onFailedScan() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_reviewRequestedKey) ?? false) return;

    final failCount = (prefs.getInt(_failCountKey) ?? 0) + 1;
    await prefs.setInt(_failCountKey, failCount);
  }

  Future<void> _requestReview(SharedPreferences prefs) async {
    final inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      debugPrint('Requesting in-app review');
      await inAppReview.requestReview();
      await prefs.setBool(_reviewRequestedKey, true);
    }
  }
}
