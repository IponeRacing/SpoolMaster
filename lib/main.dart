import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/brands_materials_service.dart';
import 'package:nfc_filament/core/services/shopping_list_service.dart';
import 'package:nfc_filament/core/services/spool_storage_service.dart';
import 'package:nfc_filament/core/services/subscription_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/core/utils/color_translator.dart';
import 'package:nfc_filament/core/widgets/ad_banner_widget.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/auth/presentation/pages/splash_page.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/direct_scan_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_reader_page_simple.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/manual_add_spool_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_stock_update_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_writer_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/widgets/color_picker_widget.dart';
import 'package:nfc_filament/features/profile/presentation/pages/profile_page.dart';
import 'package:nfc_filament/firebase_options.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

// Re-export extracted classes for backward compatibility
export 'package:nfc_filament/core/models/spool_inventory_item.dart';
export 'package:nfc_filament/core/services/spool_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all locales for date formatting (parallelized)
  await Future.wait([
    initializeDateFormatting('fr_FR', null),
    initializeDateFormatting('en_US', null),
    initializeDateFormatting('de_DE', null),
    initializeDateFormatting('it_IT', null),
    initializeDateFormatting('es_ES', null),
    initializeDateFormatting('nl_NL', null),
    initializeDateFormatting('pl_PL', null),
    initializeDateFormatting('cs_CZ', null),
    initializeDateFormatting('pt_PT', null),
    initializeDateFormatting('ru_RU', null),
    initializeDateFormatting('ja_JP', null),
    initializeDateFormatting('ko_KR', null),
    initializeDateFormatting('zh_CN', null),
    initializeDateFormatting('sv_SE', null),
    initializeDateFormatting('tr_TR', null),
    initializeDateFormatting('ro_RO', null),
    initializeDateFormatting('hu_HU', null),
    initializeDateFormatting('el_GR', null),
    initializeDateFormatting('bg_BG', null),
    initializeDateFormatting('hr_HR', null),
    initializeDateFormatting('sk_SK', null),
    initializeDateFormatting('sl_SI', null),
    initializeDateFormatting('sr_RS', null),
    initializeDateFormatting('uk_UA', null),
    initializeDateFormatting('da_DK', null),
    initializeDateFormatting('nb_NO', null),
    initializeDateFormatting('fi_FI', null),
    initializeDateFormatting('th_TH', null),
    initializeDateFormatting('vi_VN', null),
    initializeDateFormatting('id_ID', null),
    initializeDateFormatting('ms_MY', null),
    initializeDateFormatting('hi_IN', null),
  ]);

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

  // Lock orientation to portrait mode on phones (tablets can rotate)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Firebase + Crashlytics
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  WidgetsBinding.instance.platformDispatcher.onError =
      (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // DI + AdMob en parallele (independants)
  await Future.wait([
    configureDependencies(),
    AdMobService().initialize(),
  ]);

  AdMobService().preloadInterstitial();

  // Subscription + premium status (depend de DI)
  await SubscriptionService().initialize();
  final isPremium = await UserPreferencesService.isPremium();
  AdMobService().setUserPremiumStatus(isPremium);

  runApp(MyApp(key: myAppKey));
}

// Global key pour accéder au MyAppState
final GlobalKey<_MyAppState> myAppKey = GlobalKey<_MyAppState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
final GlobalKey<_MainNavigationPageState> mainNavigationKey =
    GlobalKey<_MainNavigationPageState>();

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  final _statisticsKey = GlobalKey<_StatisticsPageState>();

  // Méthode pour forcer le rebuild de toutes les pages
  void refreshPages() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
      body: IndexedStack(
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
          const StockListPage(),
          StatisticsPage(key: _statisticsKey),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // Reload statistics when switching to it
          if (index == 2) {
            _statisticsKey.currentState?._loadData();
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.nfc),
            label: AppLocalizations.of(context)!.nfc,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory_2),
            label: AppLocalizations.of(context)!.stock,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: AppLocalizations.of(context)!.statistics,
          ),
        ],
      ),
    ),
    );
  }
}

// Model for shopping list items
class ShoppingListItem {
  final String id;
  final String brand;
  final String material;
  final String colorName;
  final int colorRgb;
  final bool isOrdered;
  final DateTime addedDate;

  ShoppingListItem({
    required this.id,
    required this.brand,
    required this.material,
    required this.colorName,
    required this.colorRgb,
    this.isOrdered = false,
    required this.addedDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'material': material,
    'colorName': colorName,
    'colorRgb': colorRgb,
    'isOrdered': isOrdered,
    'addedDate': addedDate.toIso8601String(),
  };

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      ShoppingListItem(
        id: json['id'] as String,
        brand: json['brand'] as String,
        material: json['material'] as String,
        colorName: json['colorName'] as String,
        colorRgb: json['colorRgb'] as int,
        isOrdered: json['isOrdered'] as bool? ?? false,
        addedDate: DateTime.parse(json['addedDate'] as String),
      );

  ShoppingListItem copyWith({
    String? id,
    String? brand,
    String? material,
    String? colorName,
    int? colorRgb,
    bool? isOrdered,
    DateTime? addedDate,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      colorName: colorName ?? this.colorName,
      colorRgb: colorRgb ?? this.colorRgb,
      isOrdered: isOrdered ?? this.isOrdered,
      addedDate: addedDate ?? this.addedDate,
    );
  }
}

class StockListPage extends StatefulWidget {
  const StockListPage({super.key});

  @override
  State<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
  List<SpoolInventoryItem> _spools = [];
  bool _isLoading = true;
  int _lowStockThreshold = 20;

  @override
  void initState() {
    super.initState();
    _loadData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.stock,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                if (_lowStockSpools.isNotEmpty)
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
                // Liste des bobines
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount:
                        _spools.length +
                        (_spools.length ~/ 5), // Ajouter des slots pour pubs
                    itemBuilder: (context, index) {
                      // Afficher une pub toutes les 5 items
                      if (index > 0 && (index + 1) % 6 == 0) {
                        return AdBannerWidget(
                          adUnitId: AdMobService().stockListBannerId,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                        );
                      }

                      // Calculer l'index réel en tenant compte des pubs
                      final spoolIndex = index - (index ~/ 6);
                      if (spoolIndex >= _spools.length)
                        return const SizedBox.shrink();

                      final spool = _spools[spoolIndex];
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
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                AppLocalizations.of(context)!.deleteThisSpool,
                              ),
                              content: Text(
                                AppLocalizations.of(context)!.cannotBeUndone,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
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
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!.scanDeleted,
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: _buildSpoolCard(spool),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: null,
      bottomNavigationBar: Padding(
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
                  if (result == true) {
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

  Widget _buildSpoolCard(SpoolInventoryItem spool) {
    final percentage = (spool.remainingWeight / spool.weight * 100).clamp(
      0,
      100,
    );
    final color = Color(0xFF000000 | spool.colorRgb);

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
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
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

  void _navigateToNfcScan() async {
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
        _showPriceDialog(bobbinData);
      }
    }
  }

  void _showPriceDialog(BobbinData bobbinData) async {
    final priceController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final currency = await UserPreferencesService.getCurrency();
    final currencySymbol = await getCurrencySymbol();

    if (!mounted) return;

    showDialog<void>(
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
                final price = double.parse(priceController.text);

                // Créer l'objet SpoolInventoryItem depuis les données NFC
                final spool = SpoolInventoryItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  brand:
                      bobbinData.brand ??
                      _extractBrandFromBatchNumber(bobbinData.batchNumber),
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
    );
  }

  String _extractBrandFromBatchNumber(String? batchNumber) {
    if (batchNumber == null) return 'Generic';

    // Si c'est un SKU Anycubic (ex: AHPLOR-001)
    if (batchNumber.contains(RegExp(r'[A-Z]{4,}-\d{3}'))) {
      return 'Anycubic';
    }

    // Si c'est au format "Brand - Material"
    if (batchNumber.contains(' - ')) {
      return batchNumber.split(' - ').first;
    }

    return 'Generic';
  }

  void _showManualAddForm() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ManualAddSpoolPage(
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

  @override
  void initState() {
    super.initState();
    _loadData();
    // Écouter les changements de stock
    SpoolStorageService.stockChangedNotifier.addListener(_onStockChanged);
  }

  @override
  void dispose() {
    // Retirer le listener
    SpoolStorageService.stockChangedNotifier.removeListener(_onStockChanged);
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

    setState(() {
      _spools = spools;
      _shoppingList = updatedShoppingList;
      _orderedSpoolIds = orderedIds;
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

  double get totalValue => _spools.fold(0.0, (sum, spool) => sum + spool.price);

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
        title: Text(
          AppLocalizations.of(context)!.statistics,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
                                ? Colors.white.withOpacity(0.1)
                                : Colors.white.withOpacity(0.5),
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
                    crossAxisCount: 2,
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
                Navigator.pop(context);
                // Lancer le scan direct
                final result = await Navigator.of(context).push(
                  MaterialPageRoute<dynamic>(builder: (_) => const DirectScanPage()),
                );

                // Si on a scanné des données, les ajouter à la liste
                if (result != null && result is Map<String, dynamic>) {
                  final bobbinData = result['bobbinData'];
                  if (bobbinData != null) {
                    // Créer une bobine à partir des données NFC
                    final spool = SpoolInventoryItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      brand: (bobbinData.brand as String?) ?? 'Inconnu',
                      material: (bobbinData.filamentType as String?) ?? 'Inconnu',
                      colorName: (bobbinData.color as String?) ?? 'Inconnu',
                      colorRgb: (bobbinData.colorRgb as int?) ?? 0xFFFFFFFF,
                      price: 0.0,
                      weight: (bobbinData.weightGrams as num?)?.toDouble() ?? 1000.0,
                      remainingWeight:
                          (bobbinData.weightGrams as num?)?.toDouble() ?? 1000.0,
                      addedDate: DateTime.now(),
                      detailedType: bobbinData.detailedType as String?,
                      dryingTemp: bobbinData.dryingTemp as int?,
                      dryingTime: bobbinData.dryingTime as int?,
                      materialVariantId: bobbinData.materialVariantId as String?,
                      materialId: bobbinData.materialId as String?,
                    );

                    // Ajouter à la liste de courses
                    await ShoppingListService.addToShoppingList(spool);
                    await _loadData();

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${spool.brand} ${spool.material} ajouté à la liste',
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
                    '${spool.brand} ${spool.material} ajouté à la liste de courses',
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
          _shoppingList.isEmpty
              ? Padding(
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
                )
              : ListView.separated(
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
                    if (spoolIndex >= _shoppingList.length)
                      return const SizedBox.shrink();

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
    final color = Color(0xFF000000 | spool.colorRgb);
    final isOrdered = _orderedSpoolIds.contains(spool.id);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
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
