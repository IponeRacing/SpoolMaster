import 'package:flutter/material.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import 'login_page.dart';

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
      // Petite pause pour afficher le logo
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Vérifier si l'utilisateur est connecté
      final isLoggedIn = await _authService.isLoggedIn();
      debugPrint('SplashPage: isLoggedIn = $isLoggedIn');

      if (!mounted) return;

      if (isLoggedIn) {
        // Utilisateur connecté → aller à la page principale
        debugPrint('SplashPage: Navigating to MainNavigationPage');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainNavigationPage(key: mainNavigationKey)),
        );
      } else {
        // Pas connecté → aller à la page de login
        debugPrint('SplashPage: Navigating to LoginPage');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('SplashPage: Error during auth check: $e');
      debugPrint('StackTrace: $stackTrace');
      if (mounted) {
        // En cas d'erreur, aller à la page de login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
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
