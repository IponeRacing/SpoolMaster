import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nfc_filament/core/api/api_config.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/models/spool_usage_event.dart';
import 'package:nfc_filament/core/platform/orientation_policy.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/services/shopping_list_service.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/subscription_service.dart';
import 'package:nfc_filament/core/services/sync_service.dart';
import 'package:nfc_filament/core/services/update_service.dart';
import 'package:nfc_filament/core/services/usage_history_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/core/utils/color_translator.dart';
import 'package:nfc_filament/core/utils/filament_swatch.dart';
import 'package:nfc_filament/core/widgets/ad_banner_widget.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/core/widgets/responsive.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/auth/presentation/pages/splash_page.dart';
import 'package:nfc_filament/features/inventory/presentation/consumption_section.dart';
import 'package:nfc_filament/features/inventory/presentation/print_cost_dialog.dart';
import 'package:nfc_filament/features/inventory/presentation/stock_search.dart';
import 'package:nfc_filament/features/inventory/presentation/stock_transfer_actions.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/direct_scan_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/manual_add_spool_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_reader_page_simple.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_stock_update_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_writer_page.dart';
import 'package:nfc_filament/features/profile/presentation/pages/profile_page.dart';
import 'package:nfc_filament/firebase_options.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Re-export extracted classes for backward compatibility
export 'package:nfc_filament/core/models/spool_inventory_item.dart';
export 'package:nfc_filament/core/services/spool_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise les symboles de date pour toutes les locales supportées
  // (intl récent : un seul appel charge toutes les locales)
  await initializeDateFormatting();

  // Enable edge-to-edge display
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  // Portrait sur téléphone, libre sur grand écran (pliable ouvert,
  // tablette) : l'iPhone Duo et Android 16 ignorent le verrouillage sur
  // grand écran, l'UI s'adapte. Réévalué au pliage / dépliage.
  await OrientationPolicy.instance.start();

  // Firebase + Crashlytics
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  WidgetsBinding.instance.platformDispatcher.onError =
      (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Version de l'app pour l'en-tête X-App-Version (tracing serveur/support)
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    ApiConfig.initAppVersion(packageInfo.version, packageInfo.buildNumber);
  } catch (e) {
    debugPrint("⚠️ Impossible de lire la version de l'app: $e");
  }

  // DI + Analytics en parallèle (indépendants)
  await Future.wait([
    configureDependencies(),
    AnalyticsService.initialize(),
  ]);

  // AdMob en arrière-plan : son initialisation a pris 11 s sur un A55
  // (« Unable to obtain a JavascriptEngine ») et bloquait le premier
  // affichage, écran figé au démarrage. Les bannières se chargent sans
  // l'attendre ; l'interstitiel est préchargé une fois AdMob prêt.
  unawaited(_initAds());

  // Session : SharedPreferences (isSignedIn) et jetons du stockage sécurisé
  // peuvent diverger (sauvegarde Android, trousseau iOS conservé après
  // réinstallation). Local uniquement, avant le SplashPage qui lit isSignedIn.
  await AuthService().reconcileSessionAtStartup();

  // Statut premium local (pubs masquées dès le 1er affichage si premium)
  final isPremium = await UserPreferencesService.isPremium();
  AdMobService().setUserPremiumStatus(isPremium: isPremium);

  runApp(MyApp(key: myAppKey));

  // Abonnements APRÈS runApp, sans attendre : l'initialisation interroge le
  // store et le serveur, et bloquait l'affichage sans réseau.
  unawaited(_initSubscriptions());
}

Future<void> _initAds() async {
  try {
    await AdMobService().initialize();
    AdMobService().preloadInterstitial();
  } catch (e, stack) {
    debugPrint('⚠️ Initialisation AdMob impossible: $e');
    try {
      unawaited(FirebaseCrashlytics.instance.recordError(e, stack, reason: 'admob:init'));
    } catch (_) {}
  }
}

Future<void> _initSubscriptions() async {
  try {
    await SubscriptionService().initialize();
  } catch (e, stack) {
    debugPrint('⚠️ Initialisation des abonnements impossible: $e');
    try {
      unawaited(FirebaseCrashlytics.instance
          .recordError(e, stack, reason: 'subscription:init'));
    } catch (_) {}
  }
}

// Global key pour accéder au MyAppState
final GlobalKey<MyAppState> myAppKey = GlobalKey<MyAppState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final languageCode = await UserPreferencesService.getLanguage();
    setState(() {
      // Parser les codes de langue avec pays (ex: en_AU, fr_CA, zh_TW)
      if (languageCode.contains('_')) {
        final parts = languageCode.split('_');
        _locale = Locale(parts[0], parts[1]);
      } else {
        _locale = Locale(languageCode);
      }
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spool Master',
      debugShowCheckedModeBanner: false,
      // Bord à bord (Android 15+ / SystemUiMode.edgeToEdge) : réserve la place
      // de la barre de navigation système sous TOUS les écrans (pages, sheets,
      // dialogues). Avant, les boutons du bas passaient sous les touches
      // Android (ex. « Ajouter une bobine » inaccessible). SafeArea retire ce
      // padding du MediaQuery : pas de double marge dans les NavigationBar.
      builder: (context, child) => ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
        Locale('de'),
        Locale('it'),
        Locale('es'),
        Locale('nl'),
        Locale('pl'),
        Locale('cs'),
        Locale('pt'),
        Locale('ru'),
        Locale('ja'),
        Locale('ko'),
        Locale('zh'),
        Locale('sv'),
        Locale('tr'),
        Locale('ro'),
        Locale('hu'),
        Locale('el'),
        Locale('bg'),
        Locale('hr'),
        Locale('sk'),
        Locale('sl'),
        Locale('sr'),
        Locale('uk'),
        Locale('da'),
        Locale('no'),
        Locale('fi'),
        Locale('th'),
        Locale('vi'),
        Locale('id'),
        Locale('ms'),
        Locale('hi'),
        Locale('ar'),
        Locale('ca'),
        Locale('he'),
        Locale.fromSubtags(languageCode: 'en', countryCode: 'AU'),
        Locale.fromSubtags(languageCode: 'en', countryCode: 'CA'),
        Locale.fromSubtags(languageCode: 'en', countryCode: 'GB'),
        Locale.fromSubtags(languageCode: 'fr', countryCode: 'CA'),
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
      ],
      home: const SplashPage(),
    );
  }
}

// Global key pour accéder au MainNavigationPageState
final GlobalKey<MainNavigationPageState> mainNavigationKey =
    GlobalKey<MainNavigationPageState>();

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => MainNavigationPageState();
}

class MainNavigationPageState extends State<MainNavigationPage>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final _statisticsKey = GlobalKey<_StatisticsPageState>();
  final _stockKey = GlobalKey<_StockListPageState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Prompt de mise à jour après l'affichage de l'UI. Non-bloquant, fail-open.
    // Petit délai pour ne pas empiler avec les dialogues de démarrage
    // (ATT / consentement UMP gérés dans le SplashPage).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) unawaited(UpdateService.maybePrompt(context));
      });
      unawaited(_syncOnLaunch());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Au retour au premier plan : rejouer les opérations de sync en attente
    // (bobines ajoutées/supprimées hors ligne). Filet de sécurité anti-perte.
    if (state == AppLifecycleState.resumed) {
      unawaited(_flushQueueOnResume());
    }
  }

  Future<void> _flushQueueOnResume() async {
    try {
      if (!await UserPreferencesService.isSignedIn()) return;
      await SyncService.flushPendingQueue();
    } catch (e, stack) {
      // fail-open : ne jamais bloquer sur une erreur de sync, mais la tracer
      unawaited(FirebaseCrashlytics.instance
          .recordError(e, stack, reason: 'sync:flush_on_resume'));
    }
  }

  /// Sync au lancement (si connecté). Le login seul rafraîchissait le stock ;
  /// un changement serveur survenu hors login (ex: restauration de bobines)
  /// n'apparaissait jamais tant qu'on ne se reconnectait pas. fullSync =
  /// push (préserve les ajouts locaux non synchronisés) PUIS pull (fusion) →
  /// sûr, pas de perte. Rafraîchit ensuite la liste Stock. Fail-open.
  Future<void> _syncOnLaunch() async {
    try {
      if (!await UserPreferencesService.isSignedIn()) return;
      await SyncService.fullSync();
      if (mounted) await _stockKey.currentState?._loadData();
      // Liste de courses : envoie les suppressions en attente (hors ligne)
      // et récupère les changements faits sur un autre appareil. Avant, elle
      // ne se synchronisait qu'à la connexion.
      await ShoppingListService.fullSync();
      if (mounted) await _statisticsKey.currentState?._loadData();
    } catch (e, stack) {
      // ne jamais bloquer l'app sur une erreur de sync, mais la tracer
      unawaited(FirebaseCrashlytics.instance
          .recordError(e, stack, reason: 'sync:launch'));
    }
  }

  // Méthode pour forcer le rebuild de toutes les pages
  void refreshPages() {
    setState(() {});
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Reload statistics when switching to it
    if (index == 2) {
      _statisticsKey.currentState?._loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final tabs = [
      (icon: Icons.nfc, label: l.nfc),
      (icon: Icons.inventory_2, label: l.stock),
      (icon: Icons.analytics, label: l.statistics),
    ];
    // Grand écran (pliable ouvert, tablette, paysage) : rail latéral au lieu
    // de la barre du bas, qui gaspille la hauteur en paysage.
    final wide = context.isWideLayout;

    final pages = IndexedStack(
      index: _selectedIndex,
      children: [
        Stack(
          children: [
            const NfcReaderPage(),
            // Pré-charger la page d'écriture invisible
            Offstage(
              child: Navigator(
                onGenerateRoute: (settings) => MaterialPageRoute<void>(
                  builder: (context) => const NfcWriterPage(),
                ),
              ),
            ),
          ],
        ),
        StockListPage(key: _stockKey),
        StatisticsPage(key: _statisticsKey),
      ],
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
      body: wide
          ? Row(
              children: [
                SafeArea(
                  right: false,
                  child: NavigationRail(
                    key: const Key('mainNavigationRail'),
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: _selectTab,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      for (final t in tabs)
                        NavigationRailDestination(
                          icon: Icon(t.icon),
                          label: Text(t.label),
                        ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: pages),
              ],
            )
          : pages,
      bottomNavigationBar: wide
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _selectTab,
              items: [
                for (final t in tabs)
                  BottomNavigationBarItem(icon: Icon(t.icon), label: t.label),
              ],
            ),
    ),
    );
  }
}

/// Critères de tri de la liste Stock.
enum StockSort { recent, brand, material, remaining, color }

class StockListPage extends StatefulWidget {
  const StockListPage({super.key});

  @override
  State<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
  List<SpoolInventoryItem> _spools = [];
  bool _isLoading = true;
  int _lowStockThreshold = 20;

  // Tri + filtres de la liste Stock (demande client : filtrer/trier ses bobines)
  StockSort _sort = StockSort.recent;
  String? _filterBrand;
  String? _filterMaterial;

  // Recherche texte (marque, couleur, emplacement, notes…)
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StockListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadSpools();
    final threshold = await UserPreferencesService.getLowStockThreshold();
    setState(() {
      _lowStockThreshold = threshold;
    });
  }

  Future<void> _loadSpools() async {
    setState(() => _isLoading = true);
    final spools = await SpoolStorageService.loadSpools();
    setState(() {
      _spools = spools;
      _isLoading = false;
    });
  }

  List<SpoolInventoryItem> get _lowStockSpools {
    return _spools.where((spool) {
      final percentage = (spool.remainingWeight / spool.weight) * 100;
      return percentage < _lowStockThreshold;
    }).toList();
  }

  /// Marques distinctes présentes en stock (pour le filtre).
  List<String> get _availableBrands => _spools
      .map((s) => s.brand)
      .where((b) => b.isNotEmpty)
      .toSet()
      .toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

  /// Matériaux distincts présents en stock (pour le filtre).
  List<String> get _availableMaterials => _spools
      .map((s) => s.material)
      .where((m) => m.isNotEmpty)
      .toSet()
      .toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

  bool get _hasActiveFilter => _filterBrand != null || _filterMaterial != null;

  /// Applique filtres puis tri sur les bobines.
  List<SpoolInventoryItem> get _filteredSortedSpools {
    final list = _spools.where((s) {
      if (_filterBrand != null && s.brand != _filterBrand) return false;
      if (_filterMaterial != null && s.material != _filterMaterial) return false;
      if (_searchQuery.isNotEmpty &&
          !matchesStockSearch(
            s,
            _searchQuery,
            translatedColor: translateColorName(context, s.colorName),
          )) {
        return false;
      }
      return true;
    }).toList();

    switch (_sort) {
      case StockSort.recent:
        list.sort((a, b) => b.addedDate.compareTo(a.addedDate));
      case StockSort.brand:
        list.sort((a, b) => a.brand.toLowerCase().compareTo(b.brand.toLowerCase()));
      case StockSort.material:
        list.sort((a, b) => a.material.toLowerCase().compareTo(b.material.toLowerCase()));
      case StockSort.remaining:
        list.sort((a, b) => a.remainingWeight.compareTo(b.remainingWeight));
      case StockSort.color:
        list.sort((a, b) => a.colorName.toLowerCase().compareTo(b.colorName.toLowerCase()));
    }
    return list;
  }

  /// Regroupe les bobines identiques (marque + matériau + couleur RGB), après
  /// filtrage + tri. Chaque bobine reste distincte (poids restant individuel)
  /// mais elles s'affichent sous une entrée maître dépliable.
  List<List<SpoolInventoryItem>> get _groupedSpools =>
      SpoolStorageService.groupIdentical(_filteredSortedSpools);

  String _sortLabel(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return switch (_sort) {
      StockSort.recent => l.stockSortRecent,
      StockSort.brand => l.stockSortBrand,
      StockSort.material => l.stockSortMaterial,
      StockSort.remaining => l.stockSortRemaining,
      StockSort.color => l.stockSortColor,
    };
  }

  Future<void> _onMenuAction(String action, Rect origin) async {
    switch (action) {
      case 'export':
        await exportStockToExcel(context, origin: origin);
      case 'import':
        final imported = await importSpoolsFromFile(context);
        if (imported > 0) await _loadSpools();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Clavier ouvert (recherche) : en paysage (tablette, pliable ouvert) la
    // hauteur restante est faible → on masque l'alerte et les boutons du bas
    // pour laisser la place à la liste.
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Export Excel / import CSV
          Builder(
            builder: (buttonContext) => PopupMenuButton<String>(
              key: const Key('stockMoreMenu'),
              icon: const Icon(Icons.more_vert),
              tooltip: AppLocalizations.of(context)!.stockMoreActions,
              onSelected: (action) =>
                  _onMenuAction(action, shareOriginOf(buttonContext)),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'export',
                  key: const Key('stockMenuExport'),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.table_view_outlined),
                    title: Text(AppLocalizations.of(context)!.exportExcel),
                  ),
                ),
                PopupMenuItem(
                  value: 'import',
                  key: const Key('stockMenuImport'),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.upload_file_outlined),
                    title: Text(AppLocalizations.of(context)!.importSpools),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: AppLocalizations.of(context)!.profile,
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: (_) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _spools.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noSpoolsInStock,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.addFirstSpool,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Section alertes stock bas
                if (_lowStockSpools.isNotEmpty && !keyboardOpen)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      border: Border.all(color: Colors.orange.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: Colors.orange.shade700,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.lowStockAlert(
                              _lowStockSpools.length,
                              _lowStockThreshold,
                            ),
                            style: TextStyle(
                              color: Colors.orange.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Bannière publicitaire en haut
                AdBannerWidget(
                  adUnitId: AdMobService().stockBannerId,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                // Recherche
                _buildSearchField(context),
                // Barre tri + filtre
                _buildSortFilterBar(context),
                // Liste des bobines, regroupées par type
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final groups = _groupedSpools;
                      if (groups.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              AppLocalizations.of(context)!.stockNoMatch,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ),
                        );
                      }
                      final rows = _buildStockRows(
                        groups,
                        columns: context.screenWidth >= Breakpoints.expanded ? 2 : 1,
                      );
                      return ListView.builder(
                        key: const Key('stockList'),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: rows.length,
                        itemBuilder: (context, index) => rows[index],
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: keyboardOpen ? null : Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute<bool>(
                      builder: (context) => const NfcStockUpdatePage(),
                    ),
                  );
                  if (result ?? false) {
                    await _loadSpools();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.edit, size: 20),
                label: Text(
                  AppLocalizations.of(context)!.updateStock,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAddBobbinDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.add, size: 20),
                label: Text(
                  AppLocalizations.of(context)!.addSpool,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Lignes de la liste Stock : une pub après chaque bloc de 5 groupes ;
  /// sur grand écran (pliable ouvert, tablette) les groupes sont posés deux
  /// par ligne, les pubs restent pleine largeur.
  List<Widget> _buildStockRows(
    List<List<SpoolInventoryItem>> groups, {
    required int columns,
  }) {
    final rows = <Widget>[];
    final pending = <Widget>[];
    void flush() {
      if (pending.isEmpty) return;
      rows.add(
        columns == 1
            ? pending.first
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: pending.first),
                  const SizedBox(width: 12),
                  Expanded(
                    child: pending.length > 1
                        ? pending[1]
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
      );
      pending.clear();
    }

    for (var i = 0; i < groups.length; i++) {
      if (i > 0 && i % 5 == 0) {
        flush();
        rows.add(AdBannerWidget(
          adUnitId: AdMobService().stockListBannerId,
          margin: const EdgeInsets.symmetric(vertical: 12),
        ));
      }
      pending.add(_buildGroupTile(groups[i]));
      if (pending.length == columns) flush();
    }
    flush();
    return rows;
  }

  Widget _buildSearchField(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: TextField(
        key: const Key('stockSearchField'),
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onChanged: (v) => setState(() => _searchQuery = v.trim()),
        decoration: InputDecoration(
          isDense: true,
          hintText: l.stockSearchHint,
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  /// Barre compacte : bouton de tri (menu) + bouton de filtre (bottom sheet).
  Widget _buildSortFilterBar(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: PopupMenuButton<StockSort>(
              initialValue: _sort,
              onSelected: (v) => setState(() => _sort = v),
              itemBuilder: (context) => [
                CheckedPopupMenuItem(value: StockSort.recent, checked: _sort == StockSort.recent, child: Text(l.stockSortRecent)),
                CheckedPopupMenuItem(value: StockSort.brand, checked: _sort == StockSort.brand, child: Text(l.stockSortBrand)),
                CheckedPopupMenuItem(value: StockSort.material, checked: _sort == StockSort.material, child: Text(l.stockSortMaterial)),
                CheckedPopupMenuItem(value: StockSort.color, checked: _sort == StockSort.color, child: Text(l.stockSortColor)),
                CheckedPopupMenuItem(value: StockSort.remaining, checked: _sort == StockSort.remaining, child: Text(l.stockSortRemaining)),
              ],
              child: InputDecorator(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.sort, size: 20),
                ),
                child: Text('${l.stockSortBy} : ${_sortLabel(context)}', overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _showFilterSheet(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              foregroundColor: _hasActiveFilter ? AppTheme.anycubicRed : null,
              side: _hasActiveFilter ? const BorderSide(color: AppTheme.anycubicRed) : null,
            ),
            icon: Icon(_hasActiveFilter ? Icons.filter_alt : Icons.filter_alt_outlined, size: 20),
            label: Text(l.stockFilter),
          ),
        ],
      ),
    );
  }

  /// Bottom sheet de filtre : marque + matériau (choix unique par catégorie).
  void _showFilterSheet(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          Widget chips(String title, List<String> values, String? selected, void Function(String?) onPick) {
            if (values.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
                  child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    ChoiceChip(
                      label: Text(l.stockFilterAll),
                      selected: selected == null,
                      onSelected: (_) => onPick(null),
                    ),
                    ...values.map((v) => ChoiceChip(
                          label: Text(v),
                          selected: selected == v,
                          onSelected: (_) => onPick(v),
                        )),
                  ],
                ),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chips(l.stockSortBrand, _availableBrands, _filterBrand, (v) {
                  setSheetState(() {});
                  setState(() => _filterBrand = v);
                }),
                chips(l.stockSortMaterial, _availableMaterials, _filterMaterial, (v) {
                  setSheetState(() {});
                  setState(() => _filterMaterial = v);
                }),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (_hasActiveFilter)
                      TextButton.icon(
                        onPressed: () {
                          setSheetState(() {});
                          setState(() {
                            _filterBrand = null;
                            _filterMaterial = null;
                          });
                        },
                        icon: const Icon(Icons.clear, size: 18),
                        label: Text(l.stockResetFilters),
                      ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: Text(MaterialLocalizations.of(context).okButtonLabel),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Affiche un groupe de bobines identiques : si une seule, carte simple ;
  /// sinon une entrée maître dépliable ("×N en stock") révélant chaque bobine
  /// avec son propre poids restant.
  Widget _buildGroupTile(List<SpoolInventoryItem> group) {
    if (group.length == 1) {
      return _buildDismissibleSpool(group.first);
    }

    final master = group.first;
    final color = filamentSwatchColor(master.colorRgb);
    final swatchGradient = filamentSwatchGradient(
      master.colorRgb,
      materialId: master.materialId,
      variantId: master.materialVariantId,
    );
    final totalRemaining = group.fold<double>(
      0,
      (sum, s) => sum + s.remainingWeight,
    );
    final totalWeight = group.fold<double>(0, (sum, s) => sum + s.weight);
    final pct = totalWeight > 0 ? (totalRemaining / totalWeight * 100).clamp(0, 100) : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        // Retire les séparateurs par défaut de l'ExpansionTile
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              gradient: swatchGradient,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          title: Text(
            '${master.brand} - ${master.material}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(translateColorName(context, master.colorName)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.anycubicRed.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.spoolsInStockCount(group.length),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.anycubicRed,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FormattedWeight(
                    weightInGrams: totalRemaining,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    ' (${pct.toStringAsFixed(0)}%)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
          children: [
            for (final spool in group) _buildDismissibleSpool(spool),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissibleSpool(SpoolInventoryItem spool) {
    return Dismissible(
      key: Key(spool.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.deleteThisSpool),
            content: Text(AppLocalizations.of(context)!.cannotBeUndone),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        await SpoolStorageService.deleteSpool(spool.id);
        await _loadSpools();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.scanDeleted),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: _buildSpoolCard(spool),
    );
  }

  Widget _buildSpoolCard(SpoolInventoryItem spool) {
    final percentage = (spool.remainingWeight / spool.weight * 100).clamp(
      0,
      100,
    );
    final color = filamentSwatchColor(spool.colorRgb);
    final swatchGradient = filamentSwatchGradient(
      spool.colorRgb,
      materialId: spool.materialId,
      variantId: spool.materialVariantId,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showEditDialog(spool),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  gradient: swatchGradient,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${spool.brand} - ${spool.material}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      translateColorName(context, spool.colorName),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.scale,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        FormattedWeight(
                          weightInGrams: spool.remainingWeight,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          ' / ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        FormattedWeight(
                          weightInGrams: spool.weight,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${percentage.toStringAsFixed(0)}%)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: percentage < 20
                                ? Colors.red
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    if (spool.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.place_outlined, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              spool.location!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (spool.notes != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        spool.notes!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FormattedPrice(
                    price: spool.price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    key: Key('printCost_${spool.id}'),
                    icon: const Icon(Icons.calculate_outlined),
                    tooltip: AppLocalizations.of(context)!.printCostTitle,
                    visualDensity: VisualDensity.compact,
                    onPressed: () async {
                      if (await showPrintCostDialog(context, spool)) {
                        await _loadSpools();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddBobbinDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addSpool),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.nfc),
              title: Text(AppLocalizations.of(context)!.scanBobbinDirectly),
              subtitle: Text(AppLocalizations.of(context)!.readNfcChip),
              onTap: () {
                Navigator.pop(context);
                _navigateToNfcScan();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(AppLocalizations.of(context)!.addManually),
              subtitle: Text(AppLocalizations.of(context)!.spoolDetails),
              onTap: () {
                Navigator.pop(context);
                _showManualAddForm();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToNfcScan() async {
    // Naviguer vers la page de scan direct
    final result = await Navigator.push(
      context,
      MaterialPageRoute<dynamic>(builder: (context) => const DirectScanPage()),
    );

    // Si des données ont été scannées
    if (result != null && result is Map<String, dynamic> && mounted) {
      // Extraire les données de la bobine depuis le résultat du scan
      final bobbinData = result['bobbinData'] as BobbinData?;
      if (bobbinData != null) {
        // Demander le prix à l'utilisateur
        unawaited(_showPriceDialog(bobbinData));
      }
    }
  }

  Future<void> _showPriceDialog(BobbinData bobbinData) async {
    final priceController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final currency = await UserPreferencesService.getCurrency();
    final currencySymbol = await getCurrencySymbol();

    if (!mounted) return;

    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.bobbinPrice),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${AppLocalizations.of(context)!.scanBobbinDirectly}: ${bobbinData.filamentType}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText:
                      '${AppLocalizations.of(context)!.price} ($currency)',
                  border: const OutlineInputBorder(),
                  prefixText: '$currencySymbol ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterPrice;
                  }
                  if (double.tryParse(value) == null) {
                    return AppLocalizations.of(context)!.enterValidPrice;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final price = double.tryParse(priceController.text) ?? 0.0;

                // Créer l'objet SpoolInventoryItem depuis les données NFC
                final spool = SpoolInventoryItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  brand:
                      bobbinData.brand ??
                      _extractBrandFromBatchNumber(context, bobbinData.batchNumber),
                  material: bobbinData.filamentType,
                  colorName: bobbinData.color,
                  colorRgb: bobbinData.colorRgb ?? 0xFFFF8000,
                  price: price,
                  weight: bobbinData.weightGrams,
                  remainingWeight:
                      bobbinData.remainingWeight ?? bobbinData.weightGrams,
                  addedDate: DateTime.now(),
                  extruderTempMin: bobbinData.extruderTempMin,
                  extruderTempMax: bobbinData.extruderTempMax,
                  bedTempMin: bobbinData.bedTempMin,
                  bedTempMax: bobbinData.bedTempMax,
                  diameter: bobbinData.diameter,
                  spoolLength: bobbinData.spoolLength,
                  manufactureDate: bobbinData.manufactureDate,
                  batchNumber: bobbinData.batchNumber,
                  detailedType: bobbinData.detailedType,
                  dryingTemp: bobbinData.dryingTemp,
                  dryingTime: bobbinData.dryingTime,
                  materialVariantId: bobbinData.materialVariantId,
                  materialId: bobbinData.materialId,
                );

                // Sauvegarder
                await SpoolStorageService.addSpool(spool);
                await _loadSpools();

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.spoolAdded),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.addSpool),
          ),
        ],
      ),
    ));
  }

  String _extractBrandFromBatchNumber(BuildContext context, String? batchNumber) {
    final genericBrand = AppLocalizations.of(context)!.genericBrand;
    if (batchNumber == null) return genericBrand;

    // Si c'est un SKU Anycubic (ex: AHPLOR-001)
    if (batchNumber.contains(RegExp(r'[A-Z]{4,}-\d{3}'))) {
      return 'Anycubic';
    }

    // Si c'est au format "Brand - Material"
    if (batchNumber.contains(' - ')) {
      return batchNumber.split(' - ').first;
    }

    return genericBrand;
  }

  void _showManualAddForm() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ManualAddSpoolPage(
          showQuantity: true,
          onSave: (spool) async {
            await SpoolStorageService.addSpool(spool);
            await _loadSpools();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.spoolAdded),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          onSaveBatch: (spools) async {
            await SpoolStorageService.addSpools(spools);
            await _loadSpools();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.spoolAdded),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _showEditDialog(SpoolInventoryItem spool) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ManualAddSpoolPage(
          editSpool: spool,
          onSave: (updatedSpool) async {
            await SpoolStorageService.updateSpool(spool.id, updatedSpool);
            await _loadSpools();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.spoolUpdated),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<SpoolInventoryItem> _spools = [];
  List<SpoolInventoryItem> _shoppingList = [];
  bool _isLoading = true;
  Set<String> _orderedSpoolIds = {};
  List<SpoolUsageEvent> _usage = [];
  String _currency = 'CHF';

  @override
  void initState() {
    super.initState();
    _loadData();
    // Écouter les changements de stock et de consommation
    SpoolStorageService.stockChangedNotifier.addListener(_onStockChanged);
    UsageHistoryService.usageChangedNotifier.addListener(_onStockChanged);
  }

  @override
  void dispose() {
    // Retirer les listeners
    SpoolStorageService.stockChangedNotifier.removeListener(_onStockChanged);
    UsageHistoryService.usageChangedNotifier.removeListener(_onStockChanged);
    super.dispose();
  }

  void _onStockChanged() {
    // Recharger les données quand le stock change
    _loadData();
  }

  @override
  void didUpdateWidget(StatisticsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final spools = await SpoolStorageService.loadSpools();
    final threshold = await UserPreferencesService.getLowStockThreshold();
    final orderedIds = await ShoppingListService.loadOrderedIds();

    // Ajouter automatiquement les filaments en stock bas à la liste de courses
    final lowStockSpools = spools.where((spool) {
      final percentage = (spool.remainingWeight / spool.weight) * 100;
      return percentage < threshold;
    }).toList();

    for (final spool in lowStockSpools) {
      await ShoppingListService.addToShoppingList(spool);
    }

    // Recharger la liste après ajout automatique
    final updatedShoppingList = await ShoppingListService.loadShoppingList();
    final usage = await UsageHistoryService.loadEvents();
    final currency = await UserPreferencesService.getCurrency();

    if (!mounted) return;
    setState(() {
      _spools = spools;
      _shoppingList = updatedShoppingList;
      _orderedSpoolIds = orderedIds;
      _usage = usage;
      _currency = currency;
      _isLoading = false;
    });
  }

  Future<void> _loadSpools() async {
    await _loadData();
  }

  Future<void> _toggleOrdered(String spoolId) async {
    await ShoppingListService.toggleOrdered(spoolId);
    final orderedIds = await ShoppingListService.loadOrderedIds();
    setState(() {
      _orderedSpoolIds = orderedIds;
    });
  }

  Future<void> _clearShoppingList() async {
    await ShoppingListService.clearShoppingList();
    await _loadData();
  }

  // Calculate statistics
  int get totalSpools => _spools.length;

  double get totalValue => _spools.fold(0, (sum, spool) => sum + spool.price);

  int get totalMaterials => _spools.map((s) => s.material).toSet().length;

  int get totalColors => _spools.map((s) => s.colorName).toSet().length;

  int get totalBrands => _spools.map((s) => s.brand).toSet().length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadSpools,
          tooltip: AppLocalizations.of(context)!.refresh,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: AppLocalizations.of(context)!.profile,
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: (_) => const ProfilePage()));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ResponsiveCenter(
                maxWidth: 1000,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section VUE D'ENSEMBLE
                  Text(
                    AppLocalizations.of(context)!.overview.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bannière publicitaire
                  AdBannerWidget(
                    adUnitId: AdMobService().analyticsBannerId,
                    margin: const EdgeInsets.only(bottom: 16),
                  ),

                  // Total Spools card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [Colors.blue.shade900, Colors.blue.shade800]
                            : [Colors.blue.shade50, Colors.blue.shade100],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                          child: Center(
                            child: Text(
                              '$totalSpools',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.blue.shade200
                                    : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.stockInventory,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: context.isWideLayout ? 4 : 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      FutureBuilder<String>(
                        future: UserPreferencesService.getCurrency(),
                        builder: (context, snapshot) {
                          final currency = snapshot.data ?? 'CHF';
                          return _buildStatCard(
                            context: context,
                            icon: Icons.attach_money,
                            label: AppLocalizations.of(context)!.totalValue,
                            value: '$currency ${totalValue.toStringAsFixed(2)}',
                            lightColor: Colors.cyan.shade50,
                            darkColor: Colors.cyan.shade900,
                            iconColor: isDark
                                ? Colors.cyan.shade300
                                : Colors.cyan,
                          );
                        },
                      ),
                      _buildStatCard(
                        context: context,
                        icon: Icons.category,
                        label: AppLocalizations.of(context)!.materialType,
                        value: '$totalMaterials',
                        lightColor: Colors.green.shade50,
                        darkColor: Colors.green.shade900,
                        iconColor: isDark
                            ? Colors.green.shade300
                            : Colors.green,
                      ),
                      _buildStatCard(
                        context: context,
                        icon: Icons.palette,
                        label: AppLocalizations.of(context)!.color,
                        value: '$totalColors',
                        lightColor: Colors.purple.shade50,
                        darkColor: Colors.purple.shade900,
                        iconColor: isDark
                            ? Colors.purple.shade300
                            : Colors.purple,
                      ),
                      _buildStatCard(
                        context: context,
                        icon: Icons.label,
                        label: AppLocalizations.of(context)!.brand,
                        value: '$totalBrands',
                        lightColor: Colors.orange.shade50,
                        darkColor: Colors.orange.shade900,
                        iconColor: isDark
                            ? Colors.orange.shade300
                            : Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Section CONSOMMATION (historique des baisses de poids)
                  Text(
                    AppLocalizations.of(context)!.consumptionTitle.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConsumptionSection(
                    summary: UsageSummary.from(_usage),
                    currency: _currency,
                  ),
                  const SizedBox(height: 32),

                  // Section LISTE DE COURSES
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.filamentsToOrder.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Liste de courses
                  _buildShoppingList(context, isDark),
                ],
              ),
              ),
            ),
    );
  }

  void _showClearShoppingListDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearShoppingList),
        content: Text(AppLocalizations.of(context)!.clearShoppingListConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _clearShoppingList();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.clearAll),
          ),
        ],
      ),
    );
  }

  void _showAddToShoppingListDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addToShoppingList),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Option 1 : Lire NFC
            ListTile(
              leading: Icon(Icons.nfc, color: Colors.blue.shade700, size: 32),
              title: Text(
                AppLocalizations.of(context)!.readNfcChip,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(AppLocalizations.of(context)!.scanNfcChip),
              onTap: () async {
                final unknownBrandLabel = AppLocalizations.of(context)!.unknown;
                Navigator.pop(context);
                // Lancer le scan direct
                final result = await Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(builder: (_) => const DirectScanPage()),
                );

                // Si on a scanné des données, les ajouter à la liste
                if (result != null && result is Map<String, dynamic>) {
                  final bobbinData = result['bobbinData'];
                  if (bobbinData != null && bobbinData is BobbinData) {
                    // Créer une bobine à partir des données NFC
                    final spool = SpoolInventoryItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      brand: bobbinData.brand ?? unknownBrandLabel,
                      material: bobbinData.filamentType,
                      colorName: bobbinData.color,
                      colorRgb: bobbinData.colorRgb ?? 0xFFFFFFFF,
                      price: 0,
                      weight: bobbinData.weightGrams,
                      remainingWeight:
                          bobbinData.weightGrams,
                      addedDate: DateTime.now(),
                      detailedType: bobbinData.detailedType,
                      dryingTemp: bobbinData.dryingTemp,
                      dryingTime: bobbinData.dryingTime,
                      materialVariantId: bobbinData.materialVariantId,
                      materialId: bobbinData.materialId,
                    );

                    // Ajouter à la liste de courses
                    await ShoppingListService.addToShoppingList(spool);
                    await _loadData();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.addedToShoppingList('${spool.brand} ${spool.material}'),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                }
              },
            ),
            const Divider(),
            // Option 2 : Ajouter manuellement
            ListTile(
              leading: Icon(Icons.edit, color: Colors.green.shade700, size: 32),
              title: Text(
                AppLocalizations.of(context)!.addManually,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(AppLocalizations.of(context)!.fillForm),
              onTap: () {
                Navigator.pop(context);
                // Ouvrir le formulaire d'ajout
                _showAddSpoolDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSpoolDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<SpoolInventoryItem>(
        builder: (_) => ManualAddSpoolPage(
          onSave: (spool) async {
            // Ajouter UNIQUEMENT à la liste de courses, PAS au stock
            await ShoppingListService.addToShoppingList(spool);

            // Recharger les données
            await _loadData();

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.addedToShoppingList('${spool.brand} ${spool.material}'),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildShoppingList(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.shoppingList,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_shoppingList.isNotEmpty)
                  Builder(
                    builder: (buttonContext) => IconButton(
                      key: const Key('shareShoppingListButton'),
                      icon: Icon(Icons.ios_share, color: Colors.blue.shade700),
                      tooltip: AppLocalizations.of(context)!.shareShoppingList,
                      onPressed: () => shareShoppingListText(
                        context,
                        shoppingList: _shoppingList,
                        orderedIds: _orderedSpoolIds,
                        origin: shareOriginOf(buttonContext),
                      ),
                    ),
                  ),
                if (_shoppingList.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.delete_sweep, color: Colors.red.shade400),
                    onPressed: () => _showClearShoppingListDialog(context),
                    tooltip: AppLocalizations.of(context)!.clearShoppingList,
                  ),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.blue.shade700),
                  onPressed: () => _showAddToShoppingListDialog(context),
                ),
              ],
            ),
          ),
          // Liste des items
          if (_shoppingList.isEmpty) Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.emptyShoppingList,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ) else ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      _shoppingList.length +
                      (_shoppingList.length ~/ 5), // Ajouter slots pour pubs
                  separatorBuilder: (context, index) {
                    // Pas de séparateur pour les pubs
                    if (index > 0 && (index + 1) % 6 == 0) {
                      return const SizedBox.shrink();
                    }
                    return Divider(
                      height: 1,
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                    );
                  },
                  itemBuilder: (context, index) {
                    // Afficher une pub toutes les 5 items
                    if (index > 0 && (index + 1) % 6 == 0) {
                      return AdBannerWidget(
                        adUnitId: AdMobService().commissionsListBannerId,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                      );
                    }

                    // Calculer l'index réel en tenant compte des pubs
                    final spoolIndex = index - (index ~/ 6);
                    if (spoolIndex >= _shoppingList.length) {
                      return const SizedBox.shrink();
                    }

                    final spool = _shoppingList[spoolIndex];
                    return _buildShoppingListItem(
                      context: context,
                      spool: spool,
                      isDark: isDark,
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildShoppingListItem({
    required BuildContext context,
    required SpoolInventoryItem spool,
    required bool isDark,
  }) {
    final percentage = (spool.remainingWeight / spool.weight * 100).clamp(
      0,
      100,
    );
    final color = filamentSwatchColor(spool.colorRgb);
    final swatchGradient = filamentSwatchGradient(
      spool.colorRgb,
      materialId: spool.materialId,
      variantId: spool.materialVariantId,
    );
    final isOrdered = _orderedSpoolIds.contains(spool.id);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          gradient: swatchGradient,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
      title: Text(
        '${spool.brand} - ${spool.material}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          decoration: isOrdered ? TextDecoration.lineThrough : null,
          color: isOrdered ? Colors.grey : null,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translateColorName(context, spool.colorName),
            style: TextStyle(
              fontSize: 12,
              decoration: isOrdered ? TextDecoration.lineThrough : null,
              color: isOrdered ? Colors.grey : null,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                size: 14,
                color: isOrdered ? Colors.grey : Colors.orange.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(
                  context,
                )!.percentRemaining(percentage.toStringAsFixed(0)),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  decoration: isOrdered ? TextDecoration.lineThrough : null,
                  color: isOrdered ? Colors.grey : Colors.orange.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(
          isOrdered ? Icons.shopping_bag : Icons.shopping_bag_outlined,
          color: isOrdered ? Colors.green.shade600 : Colors.blue.shade400,
          size: 28,
        ),
        onPressed: () => _toggleOrdered(spool.id),
        tooltip: isOrdered
            ? AppLocalizations.of(context)!.markAsNotOrdered
            : AppLocalizations.of(context)!.markAsOrdered,
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color lightColor,
    required Color darkColor,
    required Color iconColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? darkColor : lightColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const Spacer(),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
