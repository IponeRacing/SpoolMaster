import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/subscription_service.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/features/auth/presentation/pages/login_page.dart';
import 'package:nfc_filament/main.dart';
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

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() => _isLoading = true);
    _isSignedIn = await UserPreferencesService.isSignedIn();
    _userName = await UserPreferencesService.getUserName();
    _userEmail = await UserPreferencesService.getUserEmail();
    _selectedLanguage = await UserPreferencesService.getLanguage();
    _selectedCurrency = await UserPreferencesService.getCurrency();
    _selectedUnits = await UserPreferencesService.getUnits();
    _lowStockThreshold = await UserPreferencesService.getLowStockThreshold();
    _isPremium = await UserPreferencesService.isPremium();
    setState(() => _isLoading = false);
  }

  Future<void> _purchaseSubscription(String productId) async {
    setState(() => _isLoadingSubscription = true);

    try {
      final success = await SubscriptionService().purchaseSubscription(productId);

      if (success && mounted) {
        setState(() => _isPremium = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Abonnement activé avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Échec de l\'abonnement'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingSubscription = false);
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isLoadingSubscription = true);

    try {
      await SubscriptionService().restorePurchases();
      final isPremium = await UserPreferencesService.isPremium();

      if (mounted) {
        setState(() => _isPremium = isPremium);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPremium
                ? 'Abonnement restauré avec succès !'
                : 'Aucun abonnement trouvé'
            ),
            backgroundColor: isPremium ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
    myAppKey.currentState?.setLocale(Locale(language));
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

    if (confirmed == true) {
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getCurrencyName(BuildContext context, String currency) {
    switch (currency) {
      case 'CHF':
        return AppLocalizations.of(context)!.chf;
      case 'EUR':
        return AppLocalizations.of(context)!.eur;
      case 'USD':
        return AppLocalizations.of(context)!.usd;
      case 'GBP':
        return AppLocalizations.of(context)!.gbp;
      case 'CAD':
        return AppLocalizations.of(context)!.cad;
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
      body: ListView(
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
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.signOut,
                              ),
                            ),
                          );
                        }
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
                          MaterialPageRoute(builder: (_) => const LoginPage()),
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
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!.selectLanguage,
                          ),
                          content: SingleChildScrollView(
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
                                      groupValue: _selectedLanguage,
                                      onChanged: (value) {
                                        if (value != null) {
                                          _saveLanguage(value);
                                          Navigator.pop(context);
                                        }
                                      },
                                    );
                                  })
                                  .toList(),
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
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!.selectCurrency,
                          ),
                          content: SingleChildScrollView(
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
                                      groupValue: _selectedCurrency,
                                      onChanged: (value) {
                                        if (value != null) {
                                          _saveCurrency(value);
                                          Navigator.pop(context);
                                        }
                                      },
                                    );
                                  })
                                  .toList(),
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
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            AppLocalizations.of(context)!.selectUnits,
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile<String>(
                                title: Text(
                                  AppLocalizations.of(context)!.metricUnits,
                                ),
                                value: UserPreferencesService.unitsMetric,
                                groupValue: _selectedUnits,
                                onChanged: (value) {
                                  if (value != null) {
                                    _saveUnits(value);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                              RadioListTile<String>(
                                title: Text(
                                  AppLocalizations.of(context)!.imperialUnits,
                                ),
                                value: UserPreferencesService.unitsImperial,
                                groupValue: _selectedUnits,
                                onChanged: (value) {
                                  if (value != null) {
                                    _saveUnits(value);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          // Clamp threshold between slider min/max to prevent crash
                          int tempThreshold = _lowStockThreshold.clamp(5, 50);
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
                        'VIP',
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
                          child: const Text(
                            'ACTIF',
                            style: TextStyle(
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
                            child: Text(
                              'Vous profitez de l\'expérience sans publicité !',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.green.shade900,
                                height: 1.4,
                              ),
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
                                    '2 CHF ${AppLocalizations.of(context)!.perMonth}',
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
                                    _isPremium ? 'Abonné' : AppLocalizations.of(context)!.subscribe,
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
                                          '8 CHF ${AppLocalizations.of(context)!.perYear}',
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
                                          _isPremium ? 'Abonné' : AppLocalizations.of(context)!.subscribe,
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
                  const SizedBox(height: 16),

                  // Bouton Restaurer les achats
                  if (!_isPremium)
                    Center(
                      child: TextButton.icon(
                        onPressed: _isLoadingSubscription ? null : _restorePurchases,
                        icon: const Icon(Icons.restore, size: 18),
                        label: const Text('Restaurer les achats'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue.shade700,
                        ),
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
                    subtitle: const Text('1.0.0'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
