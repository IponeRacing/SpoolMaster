import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/subscription_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/features/auth/presentation/pages/login_page.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:nfc_filament/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSignedIn = false;
  String? _userName;
  String? _userEmail;
  String _selectedLanguage = 'fr';
  String _selectedCurrency = 'CHF';
  String _selectedUnits = 'metric';
  int _lowStockThreshold = 20;
  bool _isLoading = true;
  bool _isPremium = false;
  bool _isLoadingSubscription = false;
  SubscriptionDetails? _subscriptionDetails;
  List<ProductDetails> _products = [];
  String _appVersion = '';

  /// Ouvre la gestion des abonnements du store de la plateforme (résiliation,
  /// changement de formule).
  Future<void> _openManageSubscription() async {
    final uri = Platform.isIOS
        ? Uri.parse('https://apps.apple.com/account/subscriptions')
        : Uri.parse(
            'https://play.google.com/store/account/subscriptions?package=com.engagengine.nfc_anycubic',
          );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Retourne le prix formaté depuis le store pour un produit donné
  String _getProductPrice(String productId) {
    final product = _products.cast<ProductDetails?>().firstWhere(
      (p) => p?.id == productId,
      orElse: () => null,
    );
    return product?.price ?? '...';
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    final subscriptions = SubscriptionService();
    subscriptions.premiumStatusNotifier.addListener(_onSubscriptionChanged);
    subscriptions.detailsNotifier.addListener(_onSubscriptionChanged);
    subscriptions.productsNotifier.addListener(_onSubscriptionChanged);
    // Détail à jour (renouvellement coupé, échéance) à l'ouverture du profil
    SubscriptionService().syncSubscriptionStatusWithServer();
  }

  @override
  void dispose() {
    final subscriptions = SubscriptionService();
    subscriptions.premiumStatusNotifier.removeListener(_onSubscriptionChanged);
    subscriptions.detailsNotifier.removeListener(_onSubscriptionChanged);
    subscriptions.productsNotifier.removeListener(_onSubscriptionChanged);
    super.dispose();
  }

  /// Statut, détail et prix suivent le service (achat vérifié en arrière-plan,
  /// synchro serveur, produits chargés après l'ouverture de la page).
  void _onSubscriptionChanged() {
    if (!mounted) return;
    setState(() {
      _isPremium = SubscriptionService().isPremium;
      _subscriptionDetails = SubscriptionService().detailsNotifier.value;
      _products = SubscriptionService().products;
    });
  }

  Future<void> _loadPreferences() async {
    setState(() => _isLoading = true);
    _isSignedIn = await UserPreferencesService.isSignedIn();
    _userName = await UserPreferencesService.getUserName();
    _userEmail = await UserPreferencesService.getUserEmail();
    // Fallback: récupérer l'email depuis le BACKEND (source de vérité) si absent
    // en local. Cas réinstallation : le local est vide et Apple ne redonne pas
    // l'email → on interroge le serveur (getCurrentUser lit seulement le cache
    // local, vide après réinstall, d'où l'ancien « aucun user »).
    if (_isSignedIn && (_userEmail == null || _userEmail!.isEmpty)) {
      final user = await AuthService().refreshUserFromBackend()
          ?? await AuthService().getCurrentUser();
      if (user != null && user.email.isNotEmpty) {
        _userName ??= user.name;
        _userEmail = user.email;
      }
    }
    _selectedLanguage = await UserPreferencesService.getLanguage();
    _selectedCurrency = await UserPreferencesService.getCurrency();
    _selectedUnits = await UserPreferencesService.getUnits();
    _lowStockThreshold = await UserPreferencesService.getLowStockThreshold();
    _isPremium = SubscriptionService().isPremium;
    _subscriptionDetails = SubscriptionService().detailsNotifier.value;
    // Charger les produits depuis le store pour afficher les prix dynamiques
    _products = SubscriptionService().products;
    final packageInfo = await PackageInfo.fromPlatform();
    _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
    setState(() => _isLoading = false);
  }

  /// Achat et restauration exigent un compte : l'abonnement y est rattaché.
  Future<bool> _ensureSignedIn() async {
    if (await AuthService().getAccessToken() != null) return true;
    if (!mounted) return false;
    final shouldLogin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.authentication),
        content: Text(AppLocalizations.of(ctx)!.signInToSync),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(ctx)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(ctx)!.signIn),
          ),
        ],
      ),
    );
    if (shouldLogin == true && mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      );
      await _loadPreferences();
    }
    return false;
  }

  void _showSubscriptionSnack(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Future<void> _purchaseSubscription(String productId) async {
    if (!await _ensureSignedIn()) return;

    setState(() => _isLoadingSubscription = true);
    try {
      // Issue réelle de l'achat (avant : fermer la feuille de paiement
      // affichait « Abonnement activé »)
      final outcome = await SubscriptionService().purchaseSubscription(productId);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      switch (outcome) {
        case PurchaseOutcome.success:
          setState(() => _isPremium = true);
          _showSubscriptionSnack(l10n.subscriptionActivatedMessage, Colors.green);
        case PurchaseOutcome.cancelled:
          break;
        case PurchaseOutcome.pending:
          _showSubscriptionSnack(l10n.subscriptionPendingMessage, Colors.orange);
        case PurchaseOutcome.failed:
          _showSubscriptionSnack(l10n.subscriptionFailedMessage, Colors.red);
      }
    } catch (e) {
      debugPrint('Subscription purchase error: $e');
      if (mounted) {
        _showSubscriptionSnack(AppLocalizations.of(context)!.subscriptionFailedMessage, Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingSubscription = false);
      }
    }
  }

  Future<void> _restorePurchases() async {
    if (!await _ensureSignedIn()) return;

    setState(() => _isLoadingSubscription = true);
    try {
      // Statut final après vérification serveur de chaque achat restauré
      final isPremium = await SubscriptionService().restorePurchases();
      if (mounted) {
        setState(() => _isPremium = isPremium);
        final l10n = AppLocalizations.of(context)!;
        _showSubscriptionSnack(
          isPremium ? l10n.subscriptionRestoredMessage : l10n.noSubscriptionFoundMessage,
          isPremium ? Colors.green : Colors.orange,
        );
      }
    } catch (e) {
      if (mounted) {
        _showSubscriptionSnack(AppLocalizations.of(context)!.errorMessage(e.toString()), Colors.red);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingSubscription = false);
      }
    }
  }

  Future<void> _saveLanguage(String language) async {
    await UserPreferencesService.setLanguage(language);
    setState(() => _selectedLanguage = language);

    // Mettre à jour la locale de l'app via la GlobalKey
    // Parser les codes de langue avec pays (ex: en_AU, fr_CA, zh_TW)
    Locale locale;
    if (language.contains('_')) {
      final parts = language.split('_');
      locale = Locale(parts[0], parts[1]);
    } else {
      locale = Locale(language);
    }
    myAppKey.currentState?.setLocale(locale);
  }

  Future<void> _saveCurrency(String currency) async {
    await UserPreferencesService.setCurrency(currency);
    setState(() => _selectedCurrency = currency);

    // Forcer le rebuild pour appliquer les changements
    mainNavigationKey.currentState?.refreshPages();
  }

  Future<void> _saveUnits(String units) async {
    await UserPreferencesService.setUnits(units);
    setState(() => _selectedUnits = units);

    // Forcer le rebuild pour appliquer les changements
    mainNavigationKey.currentState?.refreshPages();
  }

  Future<void> _showDeleteAccountDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteAccount),
        content: Text(AppLocalizations.of(context)!.deleteAccountConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await _deleteAccount();
    }
  }

  Future<void> _deleteAccount() async {
    try {
      final authService = AuthService();
      final accessToken = await authService.getAccessToken();

      if (accessToken == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.deleteAccount}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Déconnecter l'utilisateur localement
        await UserPreferencesService.signOut();
        await _loadPreferences();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.accountDeletionRequested),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Failed to delete account');
      }
    } catch (e) {
      debugPrint('Delete account error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.deleteAccountFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getCurrencyName(BuildContext context, String currency) {
    final l10n = AppLocalizations.of(context)!;
    switch (currency) {
      case 'CHF':
        return l10n.chf;
      case 'EUR':
        return l10n.eur;
      case 'USD':
        return l10n.usd;
      case 'GBP':
        return l10n.gbp;
      case 'CAD':
        return l10n.cad;
      case 'AUD':
        return l10n.aud;
      case 'JPY':
        return l10n.jpy;
      case 'CNY':
        return l10n.cny;
      case 'INR':
        return l10n.inr;
      case 'BRL':
        return l10n.brl;
      case 'MXN':
        return l10n.mxn;
      case 'SEK':
        return l10n.sek;
      case 'NOK':
        return l10n.nok;
      case 'DKK':
        return l10n.dkk;
      case 'PLN':
        return l10n.pln;
      case 'CZK':
        return l10n.czk;
      case 'NZD':
        return l10n.nzd;
      default:
        return currency;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.profile,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Section Authentification
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.authentication,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isSignedIn && _userName != null) ...[
                    ListTile(
                      leading: CircleAvatar(
                        child: Text(_userName![0].toUpperCase()),
                      ),
                      title: Text(_userName!),
                      subtitle: _userEmail != null ? Text(_userEmail!) : null,
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await UserPreferencesService.signOut();
                        await _loadPreferences();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.signOut,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout),
                      label: Text(AppLocalizations.of(context)!.signOut),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _showDeleteAccountDialog,
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      label: Text(
                        AppLocalizations.of(context)!.deleteAccount,
                        style: const TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ] else ...[
                    Text(AppLocalizations.of(context)!.notSignedIn),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const LoginPage()),
                        );
                        // Recharger les préférences après retour de la page de login
                        await _loadPreferences();
                      },
                      icon: const Icon(Icons.login),
                      label: Text(AppLocalizations.of(context)!.signIn),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section Préférences
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.preferences,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Langue
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(AppLocalizations.of(context)!.language),
                    subtitle: Text(
                      UserPreferencesService.languageNames[_selectedLanguage] ??
                          '',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!.selectLanguage,
                          ),
                          content: SingleChildScrollView(
                            child: RadioGroup<String>(
                              groupValue: _selectedLanguage,
                              onChanged: (value) {
                                if (value != null) {
                                  _saveLanguage(value);
                                  Navigator.pop(context);
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: UserPreferencesService.supportedLanguages
                                    .map((lang) {
                                      return RadioListTile<String>(
                                        title: Text(
                                          UserPreferencesService
                                              .languageNames[lang]!,
                                        ),
                                        value: lang,
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(),

                  // Devise
                  ListTile(
                    leading: const Icon(Icons.monetization_on),
                    title: Text(AppLocalizations.of(context)!.currency),
                    subtitle: Text(
                      _getCurrencyName(context, _selectedCurrency),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!.selectCurrency,
                          ),
                          content: SingleChildScrollView(
                            child: RadioGroup<String>(
                              groupValue: _selectedCurrency,
                              onChanged: (value) {
                                if (value != null) {
                                  _saveCurrency(value);
                                  Navigator.pop(context);
                                }
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: UserPreferencesService
                                    .supportedCurrencies
                                    .map((currency) {
                                      return RadioListTile<String>(
                                        title: Text(
                                          _getCurrencyName(context, currency),
                                        ),
                                        value: currency,
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(),

                  // Système d'unités
                  ListTile(
                    leading: const Icon(Icons.straighten),
                    title: Text(AppLocalizations.of(context)!.units),
                    subtitle: Text(
                      _selectedUnits == UserPreferencesService.unitsMetric
                          ? AppLocalizations.of(context)!.metricUnits
                          : AppLocalizations.of(context)!.imperialUnits,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!.selectUnits,
                          ),
                          content: RadioGroup<String>(
                            groupValue: _selectedUnits,
                            onChanged: (value) {
                              if (value != null) {
                                _saveUnits(value);
                                Navigator.pop(context);
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile<String>(
                                  title: Text(
                                    AppLocalizations.of(context)!.metricUnits,
                                  ),
                                  value: UserPreferencesService.unitsMetric,
                                ),
                                RadioListTile<String>(
                                  title: Text(
                                    AppLocalizations.of(context)!.imperialUnits,
                                  ),
                                  value: UserPreferencesService.unitsImperial,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(),

                  // Seuil d'alerte stock bas
                  ListTile(
                    leading: const Icon(Icons.warning_amber),
                    title: Text(
                      AppLocalizations.of(context)!.lowStockThreshold,
                    ),
                    subtitle: Text('$_lowStockThreshold%'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          // Clamp threshold between slider min/max to prevent crash
                          var tempThreshold = _lowStockThreshold.clamp(5, 50);
                          return StatefulBuilder(
                            builder: (context, setDialogState) {
                              return AlertDialog(
                                title: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.lowStockThreshold,
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.lowStockThresholdDesc,
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.lowStockThreshold,
                                        ),
                                        Text(
                                          '$tempThreshold%',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Slider(
                                      value: tempThreshold.toDouble(),
                                      min: 5,
                                      max: 50,
                                      divisions: 9,
                                      label: '$tempThreshold%',
                                      onChanged: (value) {
                                        setDialogState(() {
                                          tempThreshold = value.round();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      AppLocalizations.of(context)!.cancel,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await UserPreferencesService.setLowStockThreshold(
                                        tempThreshold,
                                      );
                                      setState(
                                        () =>
                                            _lowStockThreshold = tempThreshold,
                                      );

                                      // Forcer le rebuild pour appliquer les changements dans la page de stock
                                      mainNavigationKey.currentState
                                          ?.refreshPages();

                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.lowStockThreshold,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.save,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section VIP / Abonnement
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.vipLabel,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade700,
                        ),
                      ),
                      if (_isPremium) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.activeLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_isPremium)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.noAdsExperienceMessage,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.green.shade900,
                                    height: 1.4,
                                  ),
                                ),
                                // Renouvellement coupé : l'accès s'arrête à l'échéance
                                if (_subscriptionDetails?.endsAtExpiry ?? false) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    AppLocalizations.of(context)!.subscriptionEndsOn(
                                      MaterialLocalizations.of(context)
                                          .formatMediumDate(_subscriptionDetails!.expiresAt!.toLocal()),
                                    ),
                                    key: const Key('subscriptionEndsOn'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange.shade900,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.vipSubscriptionDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade900,
                          height: 1.4,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Option Mensuelle
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.amber.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.amber.shade50,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.amber.shade700,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.monthlySubscription,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.amber.shade900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_getProductPrice(SubscriptionService.monthlySubscriptionId)} ${AppLocalizations.of(context)!.perMonth}',
                                    style: TextStyle(
                                      color: Colors.amber.shade800,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isPremium || _isLoadingSubscription
                                ? null
                                : () => _purchaseSubscription(SubscriptionService.monthlySubscriptionId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                            child: _isLoadingSubscription
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    _isPremium ? AppLocalizations.of(context)!.subscribedLabel : AppLocalizations.of(context)!.subscribe,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Option Annuelle
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.green.shade50,
                    ),
                    child: Column(
                      children: [
                        // Badge "Meilleure offre"
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '✨ ',
                                style: TextStyle(fontSize: 12),
                              ),
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!.bestOffer.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Text(
                                ' ✨',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.green.shade700,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.yearlySubscription,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.green.shade900,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${_getProductPrice(SubscriptionService.yearlySubscriptionId)} ${AppLocalizations.of(context)!.perYear}',
                                          style: TextStyle(
                                            color: Colors.green.shade800,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isPremium || _isLoadingSubscription
                                      ? null
                                      : () => _purchaseSubscription(SubscriptionService.yearlySubscriptionId),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    disabledBackgroundColor: Colors.grey.shade300,
                                  ),
                                  child: _isLoadingSubscription
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Text(
                                          _isPremium ? AppLocalizations.of(context)!.subscribedLabel : AppLocalizations.of(context)!.subscribe,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Conditions de l'abonnement à renouvellement automatique
                  // (Guideline 3.1.2) + accès à la gestion / résiliation.
                  Text(
                    AppLocalizations.of(context)!.subscriptionAutoRenewDisclosure,
                    key: const Key('subscriptionAutoRenewDisclosure'),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.35),
                  ),
                  Center(
                    child: TextButton.icon(
                      key: const Key('manageSubscriptionButton'),
                      onPressed: _openManageSubscription,
                      icon: const Icon(Icons.manage_accounts_outlined, size: 18),
                      label: Text(AppLocalizations.of(context)!.manageSubscription),
                    ),
                  ),

                  // Bouton Restaurer les achats
                  if (!_isPremium)
                    Center(
                      child: TextButton.icon(
                        onPressed: _isLoadingSubscription ? null : _restorePurchases,
                        icon: const Icon(Icons.restore, size: 18),
                        label: Text(AppLocalizations.of(context)!.restorePurchasesButton),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  // Liens légaux pour abonnements (Apple requirement)
                  const SizedBox(height: 12),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final uri = Uri.parse('https://api.engageengine.ch/terms-of-service.php');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.termsOfService,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final uri = Uri.parse('https://api.engageengine.ch/privacy-policy.php');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.privacyPolicy,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Section Légal
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.legal,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.mail_outline),
                    title: Text(AppLocalizations.of(context)!.contactUs),
                    subtitle: Text(AppLocalizations.of(context)!.contactUsSubtitle),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () async {
                      final uri = Uri.parse('mailto:info@engageengine.ch?subject=Spool Master Feedback');
                      await launchUrl(uri);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: Text(AppLocalizations.of(context)!.privacyPolicy),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () async {
                      // Use PHP script for automatic language detection
                      final uri = Uri.parse('https://api.engageengine.ch/privacy-policy.php');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(AppLocalizations.of(context)!.termsOfService),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () async {
                      // Use PHP script for automatic language detection
                      final uri = Uri.parse('https://api.engageengine.ch/terms-of-service.php');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(AppLocalizations.of(context)!.version),
                    subtitle: Text(_appVersion),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
      ),
    );
  }
}
