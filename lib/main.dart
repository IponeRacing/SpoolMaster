import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/services/shopping_list_service.dart';
import 'package:nfc_filament/core/services/sync_service.dart';
import 'package:nfc_filament/core/services/analytics_service.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/services/subscription_service.dart';
import 'package:nfc_filament/core/services/auth_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/core/widgets/ad_banner_widget.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/core/services/brands_materials_service.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/direct_scan_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_reader_page_simple.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_writer_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/pages/nfc_stock_update_page.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/widgets/color_picker_widget.dart';
import 'package:nfc_filament/features/profile/presentation/pages/profile_page.dart';
import 'package:nfc_filament/features/auth/presentation/pages/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all locales for date formatting
  await initializeDateFormatting('fr_FR', null);
  await initializeDateFormatting('en_US', null);
  await initializeDateFormatting('de_DE', null);
  await initializeDateFormatting('it_IT', null);
  await initializeDateFormatting('es_ES', null);
  await initializeDateFormatting('nl_NL', null);
  await initializeDateFormatting('pl_PL', null);
  await initializeDateFormatting('cs_CZ', null);
  await initializeDateFormatting('pt_PT', null);
  await initializeDateFormatting('ru_RU', null);
  await initializeDateFormatting('ja_JP', null);
  await initializeDateFormatting('ko_KR', null);
  await initializeDateFormatting('zh_CN', null);
  await initializeDateFormatting('sv_SE', null);
  await initializeDateFormatting('tr_TR', null);
  await initializeDateFormatting('ro_RO', null);
  await initializeDateFormatting('hu_HU', null);
  await initializeDateFormatting('el_GR', null);
  await initializeDateFormatting('bg_BG', null);
  await initializeDateFormatting('hr_HR', null);
  await initializeDateFormatting('sk_SK', null);
  await initializeDateFormatting('sl_SI', null);
  await initializeDateFormatting('sr_RS', null);
  await initializeDateFormatting('uk_UA', null);
  await initializeDateFormatting('da_DK', null);
  await initializeDateFormatting('nb_NO', null);
  await initializeDateFormatting('fi_FI', null);
  await initializeDateFormatting('th_TH', null);
  await initializeDateFormatting('vi_VN', null);
  await initializeDateFormatting('id_ID', null);
  await initializeDateFormatting('ms_MY', null);
  await initializeDateFormatting('hi_IN', null);

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

  // Setup Dependency Injection
  await configureDependencies();

  // Initialize AdMob
  await AdMobService().initialize();

  // Initialize Subscription Service and sync premium status
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
      _locale = Locale(languageCode);
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
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
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Stack(
            children: [
              const NfcReaderPage(),
              // Pré-charger la page d'écriture invisible
              Offstage(
                child: Navigator(
                  onGenerateRoute: (settings) => MaterialPageRoute(
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
    );
  }
}

// Storage Service for managing spools
class SpoolStorageService {
  static const String _keyPrefix = 'spools_inventory';

  // Notifier pour les changements de stock
  static final ValueNotifier<int> stockChangedNotifier = ValueNotifier<int>(0);

  /// Get storage key scoped by user_id
  static Future<String> _getStorageKey() async {
    final authService = AuthService();
    final userId = await authService.getCurrentUserId();
    if (userId == null) {
      // Fallback to non-scoped key for local mode
      return _keyPrefix;
    }
    return '${_keyPrefix}_$userId';
  }

  static Future<List<SpoolInventoryItem>> loadSpools() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getStorageKey();
    final String? data = prefs.getString(key);

    // Si pas de données avec la clé scopée, essayer la clé non-scopée (migration)
    if (data == null && key != _keyPrefix) {
      final String? legacyData = prefs.getString(_keyPrefix);
      if (legacyData != null) {
        debugPrint('📦 Migrating spools from legacy key to user-scoped key');
        // Migrer les données vers la nouvelle clé
        await prefs.setString(key, legacyData);
        // Supprimer l'ancienne clé
        await prefs.remove(_keyPrefix);
        final List<dynamic> jsonList = jsonDecode(legacyData) as List<dynamic>;
        return jsonList
            .map(
              (json) => SpoolInventoryItem.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }
    }

    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
    return jsonList
        .map(
          (json) => SpoolInventoryItem.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Charger les spools depuis toutes les clés possibles (pour la migration)
  static Future<List<SpoolInventoryItem>> loadAllSpools() async {
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    final spoolKeys = allKeys.where((k) => k.startsWith(_keyPrefix));

    final List<SpoolInventoryItem> allSpools = [];
    final Set<String> seenIds = {};

    for (final key in spoolKeys) {
      final String? data = prefs.getString(key);
      if (data != null) {
        try {
          final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
          for (final json in jsonList) {
            final spool = SpoolInventoryItem.fromJson(json as Map<String, dynamic>);
            // Éviter les doublons par ID
            if (!seenIds.contains(spool.id)) {
              seenIds.add(spool.id);
              allSpools.add(spool);
            }
          }
        } catch (e) {
          debugPrint('⚠️ Error parsing spools from key $key: $e');
        }
      }
    }

    return allSpools;
  }

  static Future<void> saveSpools(List<SpoolInventoryItem> spools) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getStorageKey();
    final String data = jsonEncode(spools.map((s) => s.toJson()).toList());
    await prefs.setString(key, data);
    // Notifier les changements
    stockChangedNotifier.value++;
  }

  static Future<void> addSpool(SpoolInventoryItem spool) async {
    final spools = await loadSpools();
    spools.add(spool);
    await saveSpools(spools);
    // Sync to backend
    SyncService.syncSpool(spool);
    // Log to analytics
    AnalyticsService.logNfcScan(
      scanType: 'scan_add_spool',
      brand: spool.brand,
      material: spool.material,
      color: spool.colorName,
      success: true,
    );
  }

  static Future<void> updateSpool(String id, SpoolInventoryItem spool) async {
    final spools = await loadSpools();
    final index = spools.indexWhere((s) => s.id == id);
    if (index != -1) {
      spools[index] = spool;
      await saveSpools(spools);
      // Sync to backend
      SyncService.syncSpool(spool);
    }
  }

  static Future<void> deleteSpool(String id) async {
    final spools = await loadSpools();
    spools.removeWhere((s) => s.id == id);
    await saveSpools(spools);
    // Sync deletion to backend
    SyncService.deleteSpool(id);
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

// Model for inventory items
class SpoolInventoryItem {
  final String id;
  final String brand;
  final String material;
  final String colorName;
  final int colorRgb;
  final double price;
  final double weight;
  final double remainingWeight;
  final DateTime addedDate;
  final int? extruderTempMin;
  final int? extruderTempMax;
  final int? bedTempMin;
  final int? bedTempMax;
  final double? diameter;
  final int? spoolLength;
  final DateTime? manufactureDate;
  final String? batchNumber;

  SpoolInventoryItem({
    required this.id,
    required this.brand,
    required this.material,
    required this.colorName,
    required this.colorRgb,
    required this.price,
    required this.weight,
    required this.remainingWeight,
    required this.addedDate,
    this.extruderTempMin,
    this.extruderTempMax,
    this.bedTempMin,
    this.bedTempMax,
    this.diameter,
    this.spoolLength,
    this.manufactureDate,
    this.batchNumber,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'material': material,
    'colorName': colorName,
    'colorRgb': colorRgb,
    'price': price,
    'weight': weight,
    'remainingWeight': remainingWeight,
    'addedDate': addedDate.toIso8601String(),
    'extruderTempMin': extruderTempMin,
    'extruderTempMax': extruderTempMax,
    'bedTempMin': bedTempMin,
    'bedTempMax': bedTempMax,
    'diameter': diameter,
    'spoolLength': spoolLength,
    'manufactureDate': manufactureDate?.toIso8601String(),
    'batchNumber': batchNumber,
  };

  factory SpoolInventoryItem.fromJson(Map<String, dynamic> json) =>
      SpoolInventoryItem(
        id: json['id'] as String,
        brand: json['brand'] as String,
        material: json['material'] as String,
        colorName: json['colorName'] as String,
        colorRgb: json['colorRgb'] as int,
        price: (json['price'] as num).toDouble(),
        weight: (json['weight'] as num).toDouble(),
        remainingWeight: (json['remainingWeight'] as num).toDouble(),
        addedDate: DateTime.parse(json['addedDate'] as String),
        extruderTempMin: json['extruderTempMin'] as int?,
        extruderTempMax: json['extruderTempMax'] as int?,
        bedTempMin: json['bedTempMin'] as int?,
        bedTempMax: json['bedTempMax'] as int?,
        diameter: json['diameter'] != null
            ? (json['diameter'] as num).toDouble()
            : null,
        spoolLength: json['spoolLength'] as int?,
        manufactureDate: json['manufactureDate'] != null
            ? DateTime.parse(json['manufactureDate'] as String)
            : null,
        batchNumber: json['batchNumber'] as String?,
      );

  SpoolInventoryItem copyWith({
    String? id,
    String? brand,
    String? material,
    String? colorName,
    int? colorRgb,
    double? price,
    double? weight,
    double? remainingWeight,
    DateTime? addedDate,
    int? extruderTempMin,
    int? extruderTempMax,
    int? bedTempMin,
    int? bedTempMax,
    double? diameter,
    int? spoolLength,
    DateTime? manufactureDate,
    String? batchNumber,
  }) {
    return SpoolInventoryItem(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      colorName: colorName ?? this.colorName,
      colorRgb: colorRgb ?? this.colorRgb,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      remainingWeight: remainingWeight ?? this.remainingWeight,
      addedDate: addedDate ?? this.addedDate,
      extruderTempMin: extruderTempMin ?? this.extruderTempMin,
      extruderTempMax: extruderTempMax ?? this.extruderTempMax,
      bedTempMin: bedTempMin ?? this.bedTempMin,
      bedTempMax: bedTempMax ?? this.bedTempMax,
      diameter: diameter ?? this.diameter,
      spoolLength: spoolLength ?? this.spoolLength,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      batchNumber: batchNumber ?? this.batchNumber,
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
              ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
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
                    MaterialPageRoute(
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
                      spool.colorName,
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
    showDialog(
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
      MaterialPageRoute(builder: (context) => const DirectScanPage()),
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

    showDialog(
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

// Manual Add/Edit Form Page
class ManualAddSpoolPage extends StatefulWidget {
  const ManualAddSpoolPage({required this.onSave, this.editSpool, super.key});

  final void Function(SpoolInventoryItem) onSave;
  final SpoolInventoryItem? editSpool;

  @override
  State<ManualAddSpoolPage> createState() => _ManualAddSpoolPageState();
}

class _ManualAddSpoolPageState extends State<ManualAddSpoolPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _materialController;
  late TextEditingController _colorNameController;
  late TextEditingController _priceController;
  late TextEditingController _weightController;
  late TextEditingController _remainingWeightController;
  late TextEditingController _extruderTempMinController;
  late TextEditingController _extruderTempMaxController;
  late TextEditingController _bedTempMinController;
  late TextEditingController _bedTempMaxController;
  late TextEditingController _diameterController;
  late TextEditingController _spoolLengthController;

  Color _selectedColor = Colors.blue;
  String? _selectedBrand;
  String? _selectedMaterial;
  bool _isCustomBrand = false;
  bool _isCustomMaterial = false;

  // Listes dynamiques chargées depuis le service
  List<String> _knownBrands = [];
  List<String> _knownMaterials = [];

  @override
  void initState() {
    super.initState();
    _loadBrandsAndMaterials();
    final spool = widget.editSpool;
    _brandController = TextEditingController(text: spool?.brand ?? '');
    _materialController = TextEditingController(text: spool?.material ?? '');
    _colorNameController = TextEditingController(text: spool?.colorName ?? '');
    _priceController = TextEditingController(
      text: spool?.price.toStringAsFixed(2) ?? '',
    );
    _weightController = TextEditingController(
      text: spool?.weight.toStringAsFixed(0) ?? '',
    );
    _remainingWeightController = TextEditingController(
      text: spool?.remainingWeight.toStringAsFixed(0) ?? '',
    );
    _extruderTempMinController = TextEditingController(
      text: spool?.extruderTempMin?.toString() ?? '',
    );
    _extruderTempMaxController = TextEditingController(
      text: spool?.extruderTempMax?.toString() ?? '',
    );
    _bedTempMinController = TextEditingController(
      text: spool?.bedTempMin?.toString() ?? '',
    );
    _bedTempMaxController = TextEditingController(
      text: spool?.bedTempMax?.toString() ?? '',
    );
    _diameterController = TextEditingController(
      text: spool?.diameter?.toString() ?? '',
    );
    _spoolLengthController = TextEditingController(
      text: spool?.spoolLength?.toString() ?? '',
    );
    if (spool != null) {
      _selectedColor = Color(spool.colorRgb);
    }
  }

  Future<void> _loadBrandsAndMaterials() async {
    final brands = await BrandsMaterialsService.getAllBrands();
    final materials = await BrandsMaterialsService.getAllMaterials();

    setState(() {
      _knownBrands = [...brands, AppLocalizations.of(context)!.addBrand];
      _knownMaterials = [
        ...materials,
        AppLocalizations.of(context)!.addMaterial,
      ];

      // Initialiser les sélections si on édite une bobine
      final spool = widget.editSpool;
      if (spool != null) {
        // Si la marque est connue, sélectionner dans dropdown
        if (brands.contains(spool.brand)) {
          _selectedBrand = spool.brand;
        } else {
          _isCustomBrand = true;
        }
        // Si le matériau est connu, sélectionner dans dropdown
        if (materials.contains(spool.material)) {
          _selectedMaterial = spool.material;
        } else {
          _isCustomMaterial = true;
        }
      }
    });
  }

  @override
  void dispose() {
    _brandController.dispose();
    _materialController.dispose();
    _colorNameController.dispose();
    _priceController.dispose();
    _weightController.dispose();
    _remainingWeightController.dispose();
    _extruderTempMinController.dispose();
    _extruderTempMaxController.dispose();
    _bedTempMinController.dispose();
    _bedTempMaxController.dispose();
    _diameterController.dispose();
    _spoolLengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editSpool != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit
              ? AppLocalizations.of(context)!.editSpool
              : AppLocalizations.of(context)!.addSpool,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Dropdown Marque
            if (!_isCustomBrand)
              DropdownButtonFormField<String>(
                value: _selectedBrand,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.brand,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.label),
                ),
                items: _knownBrands.map((brand) {
                  return DropdownMenuItem(value: brand, child: Text(brand));
                }).toList(),
                onChanged: (value) {
                  if (value == AppLocalizations.of(context)!.addBrand) {
                    setState(() {
                      _isCustomBrand = true;
                      _selectedBrand = null;
                    });
                  } else {
                    setState(() {
                      _selectedBrand = value;
                      _brandController.text = value ?? '';
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.selectOrEnterBrand;
                  }
                  return null;
                },
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _brandController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.customBrand,
                        hintText: AppLocalizations.of(context)!.customBrandHint,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.label),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterBrand;
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.list),
                    tooltip: AppLocalizations.of(context)!.chooseFromList,
                    onPressed: () {
                      setState(() {
                        _isCustomBrand = false;
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // Dropdown Matériau
            if (!_isCustomMaterial)
              DropdownButtonFormField<String>(
                value: _selectedMaterial,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.materialType,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _knownMaterials.map((material) {
                  return DropdownMenuItem(
                    value: material,
                    child: Text(material),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == AppLocalizations.of(context)!.addMaterial) {
                    setState(() {
                      _isCustomMaterial = true;
                      _selectedMaterial = null;
                    });
                  } else {
                    setState(() {
                      _selectedMaterial = value;
                      _materialController.text = value ?? '';
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.selectOrEnterMaterial;
                  }
                  return null;
                },
              )
            else
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _materialController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.customMaterial,
                        hintText: AppLocalizations.of(
                          context,
                        )!.customMaterialHint,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.category),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.enterMaterial;
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.list),
                    tooltip: AppLocalizations.of(context)!.chooseFromList,
                    onPressed: () {
                      setState(() {
                        _isCustomMaterial = false;
                      });
                    },
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _colorNameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.color,
                      hintText: AppLocalizations.of(context)!.colorHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.palette),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterColor;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _showColorPicker,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<String>(
              future: getCurrencySymbol(),
              builder: (context, snapshot) {
                final currencySymbol = snapshot.data ?? 'CHF';
                return TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.price} ($currencySymbol)',
                    hintText: AppLocalizations.of(context)!.priceHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enterPrice;
                    }
                    if (double.tryParse(value) == null) {
                      return AppLocalizations.of(context)!.enterValidPrice;
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<String>(
              future: UserPreferencesService.getUnits(),
              builder: (context, snapshot) {
                final units =
                    snapshot.data ?? UserPreferencesService.unitsMetric;
                final weightUnit = UserPreferencesService.getWeightUnit(units);
                return TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.initialWeightG} ($weightUnit)',
                    hintText: AppLocalizations.of(context)!.initialWeightHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.scale),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enterWeight;
                    }
                    if (double.tryParse(value) == null) {
                      return AppLocalizations.of(context)!.enterValidWeight;
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<String>(
              future: UserPreferencesService.getUnits(),
              builder: (context, snapshot) {
                final units =
                    snapshot.data ?? UserPreferencesService.unitsMetric;
                final weightUnit = UserPreferencesService.getWeightUnit(units);
                return TextFormField(
                  controller: _remainingWeightController,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.remainingWeightG} ($weightUnit)',
                    hintText: AppLocalizations.of(context)!.initialWeightHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.balance),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enterWeight;
                    }
                    final remaining = double.tryParse(value);
                    final initial = double.tryParse(_weightController.text);
                    if (remaining == null) {
                      return AppLocalizations.of(context)!.enterValidWeight;
                    }
                    if (initial != null && remaining > initial) {
                      return AppLocalizations.of(
                        context,
                      )!.remainingCannotExceedTotal;
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            // Température extrudeur Min
            FutureBuilder<String>(
              future: UserPreferencesService.getUnits(),
              builder: (context, snapshot) {
                final units =
                    snapshot.data ?? UserPreferencesService.unitsMetric;
                final tempUnit = UserPreferencesService.getTemperatureUnit(
                  units,
                );
                return TextFormField(
                  controller: _extruderTempMinController,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.extruderTempMin} ($tempUnit)',
                    hintText: AppLocalizations.of(context)!.extruderTempMinHint,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.thermostat),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                );
              },
            ),
            const SizedBox(height: 16),
            // Température extrudeur Max
            FutureBuilder<String>(
              future: UserPreferencesService.getUnits(),
              builder: (context, snapshot) {
                final units =
                    snapshot.data ?? UserPreferencesService.unitsMetric;
                final tempUnit = UserPreferencesService.getTemperatureUnit(
                  units,
                );
                return TextFormField(
                  controller: _extruderTempMaxController,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.extruderTempMax} ($tempUnit)',
                    hintText: AppLocalizations.of(context)!.extruderTempMaxHint,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.thermostat),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                );
              },
            ),
            const SizedBox(height: 16),
            // Température plateau Min
            FutureBuilder<String>(
              future: UserPreferencesService.getUnits(),
              builder: (context, snapshot) {
                final units =
                    snapshot.data ?? UserPreferencesService.unitsMetric;
                final tempUnit = UserPreferencesService.getTemperatureUnit(
                  units,
                );
                return TextFormField(
                  controller: _bedTempMinController,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.bedTempMin} ($tempUnit)',
                    hintText: AppLocalizations.of(context)!.bedTempMinHint,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.bed),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                );
              },
            ),
            const SizedBox(height: 16),
            // Température plateau Max
            FutureBuilder<String>(
              future: UserPreferencesService.getUnits(),
              builder: (context, snapshot) {
                final units =
                    snapshot.data ?? UserPreferencesService.unitsMetric;
                final tempUnit = UserPreferencesService.getTemperatureUnit(
                  units,
                );
                return TextFormField(
                  controller: _bedTempMaxController,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.bedTempMax} ($tempUnit)',
                    hintText: AppLocalizations.of(context)!.bedTempMaxHint,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.bed),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                );
              },
            ),
            const SizedBox(height: 16),
            // Diamètre du filament
            FutureBuilder<String>(
              future: UserPreferencesService.getUnits(),
              builder: (context, snapshot) {
                final units =
                    snapshot.data ?? UserPreferencesService.unitsMetric;
                final lengthUnit = UserPreferencesService.getLengthUnit(units);
                return TextFormField(
                  controller: _diameterController,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.diameter} ($lengthUnit)',
                    hintText: AppLocalizations.of(context)!.diameterHint,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.straighten),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            // Longueur de la bobine
            FutureBuilder<String>(
              future: UserPreferencesService.getUnits(),
              builder: (context, snapshot) {
                final units =
                    snapshot.data ?? UserPreferencesService.unitsMetric;
                // Pour la longueur de bobine, on affiche en mètres pour métrique, en feet pour impérial
                final lengthUnit = units == UserPreferencesService.unitsMetric
                    ? 'm'
                    : 'ft';
                return TextFormField(
                  controller: _spoolLengthController,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.spoolLength} ($lengthUnit)',
                    hintText: AppLocalizations.of(context)!.spoolLengthHint,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.animation),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveSpool,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isEdit
                    ? AppLocalizations.of(context)!.spoolUpdated
                    : AppLocalizations.of(context)!.addSpool,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.chooseColor,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: ColorPickerWidget(
            initialColor: _selectedColor,
            onColorChanged: (color) {
              setState(() {
                _selectedColor = color;
              });
            },
            showOpacitySlider: true,
          ),
        ),
      ),
    );
  }

  void _saveSpool() async {
    if (_formKey.currentState!.validate()) {
      final brand = _brandController.text.trim();
      final material = _materialController.text.trim();

      // Sauvegarder les marques et matériaux personnalisés
      if (_isCustomBrand && brand.isNotEmpty) {
        await BrandsMaterialsService.addCustomBrand(brand);
      }
      if (_isCustomMaterial && material.isNotEmpty) {
        await BrandsMaterialsService.addCustomMaterial(material);
      }

      final spool = SpoolInventoryItem(
        id:
            widget.editSpool?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        brand: brand,
        material: material,
        colorName: _colorNameController.text.trim(),
        colorRgb: _selectedColor.value,
        price: double.parse(_priceController.text),
        weight: double.parse(_weightController.text),
        remainingWeight: double.parse(_remainingWeightController.text),
        addedDate: widget.editSpool?.addedDate ?? DateTime.now(),
        extruderTempMin: _extruderTempMinController.text.isNotEmpty
            ? int.parse(_extruderTempMinController.text)
            : null,
        extruderTempMax: _extruderTempMaxController.text.isNotEmpty
            ? int.parse(_extruderTempMaxController.text)
            : null,
        bedTempMin: _bedTempMinController.text.isNotEmpty
            ? int.parse(_bedTempMinController.text)
            : null,
        bedTempMax: _bedTempMaxController.text.isNotEmpty
            ? int.parse(_bedTempMaxController.text)
            : null,
        diameter: _diameterController.text.isNotEmpty
            ? double.parse(_diameterController.text)
            : null,
        spoolLength: _spoolLengthController.text.isNotEmpty
            ? int.parse(_spoolLengthController.text)
            : null,
      );

      widget.onSave(spool);
      Navigator.pop(context);
    }
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
  int _lowStockThreshold = 20;
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
    final shoppingList = await ShoppingListService.loadShoppingList();
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
      _lowStockThreshold = threshold;
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

  Future<void> _removeFromShoppingList(String spoolId) async {
    await ShoppingListService.removeFromShoppingList(spoolId);
    await _loadData();
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
              ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
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
    showDialog(
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
    showDialog(
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
                  MaterialPageRoute(builder: (_) => const DirectScanPage()),
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
                      price: 0.0, // Prix par défaut
                      weight: (bobbinData.weightGrams as num?)?.toDouble() ?? 1000.0,
                      remainingWeight:
                          (bobbinData.weightGrams as num?)?.toDouble() ?? 1000.0,
                      addedDate: DateTime.now(),
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
            spool.colorName,
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
