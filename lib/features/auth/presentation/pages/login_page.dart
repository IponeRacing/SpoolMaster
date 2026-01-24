import 'package:flutter/material.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../main.dart' show MainNavigationPage, mainNavigationKey;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.fromProfile = false});

  /// Si true, après login on fait pop() pour retourner à la page précédente
  /// Si false (défaut), on remplace par MainNavigationPage
  final bool fromProfile;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _navigateAfterLogin() {
    if (!mounted) return;

    if (widget.fromProfile && Navigator.of(context).canPop()) {
      // Vient de ProfilePage, retourner en arrière
      Navigator.of(context).pop(true); // true = login successful
    } else {
      // Vient de SplashPage ou autre, aller à MainNavigationPage
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => MainNavigationPage(key: mainNavigationKey)),
        (route) => false, // Supprimer toutes les routes précédentes
      );
    }
  }

  Future<void> _signInWithApple() async {
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithApple();
      _navigateAfterLogin();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de connexion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithGoogle();
      _navigateAfterLogin();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de connexion: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),

                // Login Card
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        localizations.connection,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.signInToSync,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Apple Sign In Button
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else ...[
                        _AppleSignInButton(
                          onPressed: _signInWithApple,
                          label: localizations.continueWithApple,
                        ),
                        const SizedBox(height: 16),
                        _GoogleSignInButton(
                          onPressed: _signInWithGoogle,
                          label: localizations.continueWithGoogle,
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Skip login (mode local only)
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(builder: (_) => MainNavigationPage(key: mainNavigationKey)),
                          );
                        },
                        child: Text(
                          localizations.continueWithoutAccount,
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Privacy Note
                Text(
                  localizations.privacyNotice,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bouton Apple Sign In personnalisé
class _AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const _AppleSignInButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.apple, size: 24),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Bouton Google Sign In personnalisé
class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const _GoogleSignInButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.grey[800],
          side: BorderSide(color: Colors.grey[300]!, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
        icon: Image.network(
          'https://www.google.com/favicon.ico',
          width: 24,
          height: 24,
          errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 24),
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
