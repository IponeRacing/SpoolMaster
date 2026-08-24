import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/features/auth/presentation/pages/login_page.dart';
import 'package:nfc_filament/main.dart';

/// Page de chargement qui vérifie si l'utilisateur est connecté
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Petite pause pour afficher le logo ET s'assurer que l'UI est visible
      await Future<void>.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      // Demander ATT + UMP maintenant que l'UI est visible
      if (Platform.isIOS) {
        debugPrint('🔐 [SplashPage] Requesting ATT consent (UI is visible)...');
        await AdMobService().requestConsents();
        debugPrint('🔐 [SplashPage] ATT consent flow completed');
      }

      if (!mounted) return;

      // Vérifier si l'utilisateur est connecté
      final isLoggedIn = await _authService.isLoggedIn();
      debugPrint('SplashPage: isLoggedIn = $isLoggedIn');

      if (!mounted) return;

      if (isLoggedIn) {
        // Utilisateur connecté → aller à la page principale
        debugPrint('SplashPage: Navigating to MainNavigationPage');
        unawaited(Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => MainNavigationPage(key: mainNavigationKey)),
        ));
      } else {
        // Pas connecté → aller à la page de login
        debugPrint('SplashPage: Navigating to LoginPage');
        unawaited(Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const LoginPage()),
        ));
      }
    } catch (e, stackTrace) {
      debugPrint('SplashPage: Error during auth check: $e');
      debugPrint('StackTrace: $stackTrace');
      if (mounted) {
        // En cas d'erreur, aller à la page de login
        unawaited(Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const LoginPage()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 48),

            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? Colors.white : AppTheme.anycubicRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
