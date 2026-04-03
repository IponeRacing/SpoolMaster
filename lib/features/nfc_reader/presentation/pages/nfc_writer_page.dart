import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_filament/core/services/admob_service.dart';
import 'package:nfc_filament/core/widgets/ad_banner_widget.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';
import 'package:nfc_filament/core/services/brands_materials_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/theme/app_theme.dart';
import 'package:nfc_filament/dependency_injection.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_bloc.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/widgets/color_picker_widget.dart';

class NfcWriterPage extends StatefulWidget {
  final BobbinData? prefilledData;
  final String initialFormat; // 'anycubic' or 'prusa'

  const NfcWriterPage({super.key, this.prefilledData, this.initialFormat = 'anycubic'});

  @override
  State<NfcWriterPage> createState() => _NfcWriterPageState();
}

class _NfcWriterPageState extends State<NfcWriterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _colorPickerPreloaded = false;

  // Listes dynamiques chargées depuis le service
  List<String> _brands = [];
  List<String> _materialKeys = [];

  // Liste des 25 matériaux avec paramètres de température
  final _materials = {
    'ABS': {'code': 'ABS', 'extruderMin': 220, 'extruderMax': 250, 'bedMin': 90, 'bedMax': 100},
    'ASA': {'code': 'ASA', 'extruderMin': 240, 'extruderMax': 280, 'bedMin': 90, 'bedMax': 100},
    'HIPS': {'code': 'HIPS', 'extruderMin': 230, 'extruderMax': 245, 'bedMin': 80, 'bedMax': 100},
    'Nylon': {'code': 'NYL', 'extruderMin': 220, 'extruderMax': 250, 'bedMin': 70, 'bedMax': 90},
    'PC': {'code': 'PC', 'extruderMin': 260, 'extruderMax': 300, 'bedMin': 100, 'bedMax': 110},
    'PETG': {'code': 'PETG', 'extruderMin': 230, 'extruderMax': 250, 'bedMin': 70, 'bedMax': 90},
    'PETG Carbon Fiber': {'code': 'PETGCF', 'extruderMin': 240, 'extruderMax': 260, 'bedMin': 70, 'bedMax': 90},
    'PLA': {'code': 'PLA', 'extruderMin': 190, 'extruderMax': 230, 'bedMin': 50, 'bedMax': 60},
    'PLA+': {'code': 'PLAP', 'extruderMin': 210, 'extruderMax': 230, 'bedMin': 45, 'bedMax': 60},
    'PLA High Speed': {'code': 'HPL', 'extruderMin': 190, 'extruderMax': 230, 'bedMin': 50, 'bedMax': 60},
    'PLA Tough': {'code': 'PLAT', 'extruderMin': 210, 'extruderMax': 230, 'bedMin': 50, 'bedMax': 60},
    'PLA SE': {'code': 'PLASE', 'extruderMin': 190, 'extruderMax': 230, 'bedMin': 55, 'bedMax': 65},
    'PLA Carbon Fiber': {'code': 'PLACF', 'extruderMin': 210, 'extruderMax': 240, 'bedMin': 45, 'bedMax': 65},
    'PLA Wood': {'code': 'PLAWD', 'extruderMin': 190, 'extruderMax': 220, 'bedMin': 50, 'bedMax': 60},
    'PLA Metal': {'code': 'PLAMT', 'extruderMin': 195, 'extruderMax': 230, 'bedMin': 50, 'bedMax': 60},
    'PLA Marble': {'code': 'PLAMB', 'extruderMin': 200, 'extruderMax': 230, 'bedMin': 50, 'bedMax': 60},
    'PLA Bamboo': {'code': 'PLABM', 'extruderMin': 190, 'extruderMax': 220, 'bedMin': 50, 'bedMax': 60},
    'PLA Silk': {'code': 'PLASK', 'extruderMin': 200, 'extruderMax': 230, 'bedMin': 55, 'bedMax': 65},
    'PLA Matte': {'code': 'PLAMA', 'extruderMin': 190, 'extruderMax': 230, 'bedMin': 55, 'bedMax': 65},
    'PLA Glow': {'code': 'PLAGL', 'extruderMin': 190, 'extruderMax': 230, 'bedMin': 50, 'bedMax': 60},
    'PLA Translucent': {'code': 'PLATR', 'extruderMin': 200, 'extruderMax': 230, 'bedMin': 50, 'bedMax': 60},
    'PLA Color Change': {'code': 'PLACC', 'extruderMin': 200, 'extruderMax': 230, 'bedMin': 50, 'bedMax': 60},
    'TPU': {'code': 'TPU', 'extruderMin': 210, 'extruderMax': 230, 'bedMin': 25, 'bedMax': 60},
    'TPU 95A': {'code': 'TPU95', 'extruderMin': 210, 'extruderMax': 230, 'bedMin': 25, 'bedMax': 60},
    'PVA': {'code': 'PVA', 'extruderMin': 215, 'extruderMax': 225, 'bedMin': 45, 'bedMax': 60},
  };

  late String _tagFormat; // 'anycubic' or 'prusa'

  bool get _isPrusa => _tagFormat == 'prusa';

  late String _selectedBrand;
  late String _selectedMaterial;
  late Color _selectedColor;
  late String _serialNumber;
  late double _weight;
  late int _extruderTempMin;
  late int _extruderTempMax;
  late int _bedTempMin;
  late int _bedTempMax;
  late double _diameter;
  late int _spoolLength;
  String _units = UserPreferencesService.unitsMetric;

  @override
  void initState() {
    super.initState();
    _tagFormat = widget.initialFormat;
    _loadBrandsAndMaterials();
    _loadUnits();

    // Pré-charger le color picker en arrière-plan après 100ms
    Future<void>.delayed(const Duration(milliseconds: 100), () {
      if (mounted && !_colorPickerPreloaded) {
        setState(() {
          _colorPickerPreloaded = true;
        });
      }
    });

    // Initialize with prefilled data if available
    if (widget.prefilledData != null) {
      _selectedBrand = widget.prefilledData!.brand ?? (_isPrusa ? 'Prusa' : 'Anycubic');
      _selectedMaterial = _getMaterialFromType(widget.prefilledData!.filamentType);
      _selectedColor = _getColorFromRgb(widget.prefilledData!.colorRgb);
      _serialNumber = _extractSerialNumber(widget.prefilledData!.batchNumber);
      _weight = widget.prefilledData!.weightGrams;
      _extruderTempMin = widget.prefilledData!.extruderTempMin ?? 190;
      _extruderTempMax = widget.prefilledData!.extruderTempMax ?? 230;
      _bedTempMin = widget.prefilledData!.bedTempMin ?? 50;
      _bedTempMax = widget.prefilledData!.bedTempMax ?? 60;
      _diameter = widget.prefilledData!.diameter ?? 1.75;
      _spoolLength = widget.prefilledData!.spoolLength ?? 330;
    } else {
      _selectedBrand = _isPrusa ? 'Prusa' : 'Anycubic';
      _selectedMaterial = 'PLA High Speed';
      _selectedColor = const Color(0xFFFF8000); // Orange
      _serialNumber = '001';
      _weight = 1000;
      _extruderTempMin = 190;
      _extruderTempMax = 230;
      _bedTempMin = 50;
      _bedTempMax = 60;
      _diameter = 1.75;
      _spoolLength = 330;
    }
  }

  String _getMaterialFromType(String filamentType) {
    // Try to match the filament type to a material in the list
    for (var material in _materials.keys) {
      if (material.toLowerCase().contains(filamentType.toLowerCase())) {
        return material;
      }
    }
    return 'PLA High Speed'; // Default
  }

  Color _getColorFromRgb(int? colorRgb) {
    if (colorRgb == null) return const Color(0xFFFF8000); // Default orange
    return Color(0xFF000000 | colorRgb);
  }

  Future<void> _loadUnits() async {
    final units = await UserPreferencesService.getUnits();
    if (mounted) setState(() => _units = units);
  }

  Future<void> _loadBrandsAndMaterials() async {
    final brands = await BrandsMaterialsService.getAllBrands();
    final materials = await BrandsMaterialsService.getAllMaterials();

    setState(() {
      _brands = brands;
      _materialKeys = materials.where((m) => _materials.containsKey(m)).toList();
    });
  }

  String _extractSerialNumber(String? batchNumber) {
    if (batchNumber == null) return '001';
    // Extract last 3 digits from batch number (e.g., AHPLOR-001 -> 001)
    final match = RegExp(r'\d{3}$').firstMatch(batchNumber);
    return match?.group(0) ?? '001';
  }

  String _generateSKU() {
    final materialData = _materials[_selectedMaterial]!;
    final materialCode = materialData['code'] as String;
    final colorCode = _getColorCodeFromRgb(_selectedColor);
    return 'A$materialCode$colorCode-${_serialNumber.padLeft(3, '0')}';
  }

  String _getColorCodeFromRgb(Color color) {
    // Find closest color code based on RGB values
    String closestCode = 'OR'; // Default Orange
    double minDistance = double.infinity;

    final predefinedColors = {
      'BW': const Color(0xFFFFFFFF),
      'BK': const Color(0xFF000000),
      'RD': const Color(0xFFFF0000),
      'BL': const Color(0xFF0000FF),
      'GR': const Color(0xFF00FF00),
      'YL': const Color(0xFFFFFF00),
      'OR': const Color(0xFFFF8000),
      'PK': const Color(0xFFFF69B4),
      'GY': const Color(0xFF808080),
      'PR': const Color(0xFF8000FF),
      'BR': const Color(0xFF8B4513),
    };

    for (var entry in predefinedColors.entries) {
      final targetColor = entry.value;
      final distance = _colorDistance(color, targetColor);
      if (distance < minDistance) {
        minDistance = distance;
        closestCode = entry.key;
      }
    }

    return closestCode;
  }

  double _colorDistance(Color c1, Color c2) {
    // Euclidean distance in RGB space
    final dr = c1.red - c2.red;
    final dg = c1.green - c2.green;
    final db = c1.blue - c2.blue;
    return (dr * dr + dg * dg + db * db).toDouble();
  }

  String _getMaterialType() {
    // Return the base material type (e.g., "PLA" from "PLA High Speed")
    if (_selectedMaterial.contains('PLA')) return 'PLA';
    if (_selectedMaterial.contains('PETG')) return 'PETG';
    if (_selectedMaterial.contains('ABS')) return 'ABS';
    if (_selectedMaterial.contains('TPU')) return 'TPU';
    if (_selectedMaterial.contains('Nylon')) return 'Nylon';
    if (_selectedMaterial.contains('ASA')) return 'ASA';
    if (_selectedMaterial.contains('PC')) return 'PC';
    if (_selectedMaterial.contains('HIPS')) return 'HIPS';
    if (_selectedMaterial.contains('PVA')) return 'PVA';
    return _selectedMaterial;
  }

  void _onMaterialChanged(String? material) {
    if (material == null) return;
    setState(() {
      _selectedMaterial = material;
      final materialData = _materials[material]!;
      _extruderTempMin = materialData['extruderMin'] as int;
      _extruderTempMax = materialData['extruderMax'] as int;
      _bedTempMin = materialData['bedMin'] as int;
      _bedTempMax = materialData['bedMax'] as int;
    });
  }

  Future<void> _showColorPickerDialog(BuildContext context) async {
    final selectedColor = await Navigator.push<Color>(
      context,
      MaterialPageRoute<Color>(
        fullscreenDialog: true,
        builder: (context) => _ColorPickerDialog(initialColor: _selectedColor),
      ),
    );

    if (selectedColor != null) {
      setState(() {
        _selectedColor = selectedColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NfcReaderBloc>(),
      child: Stack(
        children: [
          // Widget principal
          Scaffold(
            appBar: AppBar(title: Text(_isPrusa
                ? AppLocalizations.of(context)!.writePrusaTagTitle
                : AppLocalizations.of(context)!.writeNfcChip)),
            body: BlocConsumer<NfcReaderBloc, NfcReaderState>(
          listener: (context, state) {
            if (state is BobbinDataWriteSuccess) {
              // Fermer TOUS les SnackBars et naviguer SANS afficher de nouveau SnackBar
              // pour éviter le conflit Hero pendant la navigation
              ScaffoldMessenger.of(context).clearSnackBars();

              // Pop d'abord, puis afficher le SnackBar sur la page précédente
              Navigator.of(context).pop(true); // true = succès
            } else if (state is NfcReaderFailure) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is NfcReaderLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.approachChipToWrite,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Show prefilled data banner
                    if (widget.prefilledData != null) ...[
                      Builder(builder: (context) {
                        final accentColor = _isPrusa ? const Color(0xFFFA6831) : AppTheme.anycubicRed;
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: accentColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: accentColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!.reuseThisData,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: accentColor.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                    ],

                    // SKU Card (Anycubic only)
                    if (!_isPrusa) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.generatedSku,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _generateSKU(),
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: AppTheme.anycubicRed,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Tag format selector
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'anycubic',
                          label: Text('Anycubic'),
                          icon: Icon(Icons.nfc),
                        ),
                        ButtonSegment(
                          value: 'prusa',
                          label: Text('Prusa'),
                          icon: Icon(Icons.nfc),
                        ),
                      ],
                      selected: {_tagFormat},
                      onSelectionChanged: (Set<String> selection) {
                        setState(() {
                          _tagFormat = selection.first;
                          if (_isPrusa && _selectedBrand == 'Anycubic') {
                            _selectedBrand = 'Prusa';
                          } else if (!_isPrusa && _selectedBrand == 'Prusa') {
                            _selectedBrand = 'Anycubic';
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Info message
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _tagFormat == 'prusa'
                                  ? AppLocalizations.of(context)!.nfcTagInfoPrusa
                                  : AppLocalizations.of(context)!.nfcTagInfo,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Brand dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedBrand,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.brand,
                        border: const OutlineInputBorder(),
                      ),
                      items: _brands.map((String brand) {
                        return DropdownMenuItem<String>(
                          value: brand,
                          child: Text(brand),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBrand = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Material dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedMaterial,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.materialType,
                        border: const OutlineInputBorder(),
                      ),
                      items: _materialKeys.map((String material) {
                        return DropdownMenuItem<String>(
                          value: material,
                          child: Text(material),
                        );
                      }).toList(),
                      onChanged: _onMaterialChanged,
                    ),
                    const SizedBox(height: 16),

                    // Color Picker
                    Text(
                      AppLocalizations.of(context)!.color,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showColorPickerDialog(context),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.colorize,
                            color: _selectedColor.computeLuminance() > 0.5
                                ? Colors.black54
                                : Colors.white70,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Serial number (Anycubic only)
                    if (!_isPrusa) ...[
                      TextFormField(
                        initialValue: _serialNumber,
                        decoration: InputDecoration(
                          labelText: '${AppLocalizations.of(context)!.serialNumber} (3 ${AppLocalizations.of(context)!.required.toLowerCase()})',
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.required;
                          }
                          if (value.length != 3) {
                            return AppLocalizations.of(context)!.invalid;
                          }
                          if (int.tryParse(value) == null) {
                            return AppLocalizations.of(context)!.invalid;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _serialNumber = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Weight
                    DropdownButtonFormField<double>(
                      value: _weight,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.weight,
                        border: const OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 250, child: Text('250g')),
                        DropdownMenuItem(value: 500, child: Text('500g')),
                        DropdownMenuItem(value: 1000, child: Text('1000g')),
                      ],
                      onChanged: (double? newValue) {
                        setState(() {
                          _weight = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Advanced Settings Section
                    Text(
                      AppLocalizations.of(context)!.advancedSettings,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Extruder temperatures
                    Row(
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final tempUnit = _units == UserPreferencesService.unitsMetric ? '°C' : '°F';
                              return TextFormField(
                                initialValue: _extruderTempMin.toString(),
                                decoration: InputDecoration(
                                  labelText: '${AppLocalizations.of(context)!.extruderTempMin} ($tempUnit)',
                                  border: const OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                                  final temp = int.tryParse(value);
                                  if (temp == null || temp <= 0) return AppLocalizations.of(context)!.invalid;
                                  return null;
                                },
                                onChanged: (value) {
                                  final temp = int.tryParse(value);
                                  if (temp != null) {
                                    setState(() {
                                      _extruderTempMin = temp;
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final tempUnit = _units == UserPreferencesService.unitsMetric ? '°C' : '°F';
                              return TextFormField(
                                initialValue: _extruderTempMax.toString(),
                                decoration: InputDecoration(
                                  labelText: '${AppLocalizations.of(context)!.extruderTempMax} ($tempUnit)',
                                  border: const OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                                  final temp = int.tryParse(value);
                                  if (temp == null || temp <= 0) return AppLocalizations.of(context)!.invalid;
                                  return null;
                                },
                                onChanged: (value) {
                                  final temp = int.tryParse(value);
                                  if (temp != null) {
                                    setState(() {
                                      _extruderTempMax = temp;
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Bed temperatures
                    Row(
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final tempUnit = _units == UserPreferencesService.unitsMetric ? '°C' : '°F';
                              return TextFormField(
                                initialValue: _bedTempMin.toString(),
                                decoration: InputDecoration(
                                  labelText: '${AppLocalizations.of(context)!.bedTempMin} ($tempUnit)',
                                  border: const OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                                  final temp = int.tryParse(value);
                                  if (temp == null || temp < 0) return AppLocalizations.of(context)!.invalid;
                                  return null;
                                },
                                onChanged: (value) {
                                  final temp = int.tryParse(value);
                                  if (temp != null) {
                                    setState(() {
                                      _bedTempMin = temp;
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final tempUnit = _units == UserPreferencesService.unitsMetric ? '°C' : '°F';
                              return TextFormField(
                                initialValue: _bedTempMax.toString(),
                                decoration: InputDecoration(
                                  labelText: '${AppLocalizations.of(context)!.bedTempMax} ($tempUnit)',
                                  border: const OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                                  final temp = int.tryParse(value);
                                  if (temp == null || temp < 0) return AppLocalizations.of(context)!.invalid;
                                  return null;
                                },
                                onChanged: (value) {
                                  final temp = int.tryParse(value);
                                  if (temp != null) {
                                    setState(() {
                                      _bedTempMax = temp;
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Diameter and Length
                    Row(
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              final lengthUnit = _units == UserPreferencesService.unitsMetric ? 'mm' : 'in';
                              return TextFormField(
                                initialValue: _diameter.toString(),
                                decoration: InputDecoration(
                                  labelText: '${AppLocalizations.of(context)!.diameter} ($lengthUnit)',
                                  border: const OutlineInputBorder(),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                validator: (value) {
                                  if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                                  final diameter = double.tryParse(value);
                                  if (diameter == null || diameter <= 0) return AppLocalizations.of(context)!.invalid;
                                  return null;
                                },
                                onChanged: (value) {
                                  final diameter = double.tryParse(value);
                                  if (diameter != null) {
                                    setState(() {
                                      _diameter = diameter;
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: _spoolLength.toString(),
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.spoolLength,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) return AppLocalizations.of(context)!.required;
                              final length = int.tryParse(value);
                              if (length == null || length <= 0) return AppLocalizations.of(context)!.invalid;
                              return null;
                            },
                            onChanged: (value) {
                              final length = int.tryParse(value);
                              if (length != null) {
                                setState(() {
                                  _spoolLength = length;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final colorCode = _getColorCodeFromRgb(_selectedColor);
                          // Flutter Color.r/g/b returns double 0.0-1.0, we need int 0-255
                          final r = (_selectedColor.r * 255).round();
                          final g = (_selectedColor.g * 255).round();
                          final b = (_selectedColor.b * 255).round();
                          final colorRgb = (r << 16) | (g << 8) | b;
                          developer.log(
                            '📝 Écriture NFC - Couleur sélectionnée: $_selectedColor, '
                            'Code: $colorCode, RGB: 0x${colorRgb.toRadixString(16).padLeft(6, '0').toUpperCase()}',
                          );

                          final bobbinData = BobbinData(
                            filamentType: _getMaterialType(),
                            color: colorCode,
                            weightGrams: _weight,
                            manufactureDate: DateTime.now(),
                            batchNumber: _generateSKU(),
                            colorRgb: colorRgb,
                            extruderTempMin: _extruderTempMin,
                            extruderTempMax: _extruderTempMax,
                            bedTempMin: _bedTempMin,
                            bedTempMax: _bedTempMax,
                            diameter: _diameter,
                            spoolLength: _spoolLength,
                            brand: _selectedBrand,
                          );

                          context.read<NfcReaderBloc>().add(
                                WriteBobbinDataEvent(bobbinData, tagFormat: _tagFormat),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.nfc),
                      label: Text(
                        AppLocalizations.of(context)!.writeDataToChip,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Bannière publicitaire en bas du formulaire
                    AdBannerWidget(
                      adUnitId: AdMobService().nfcWriterBannerId,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
            ),
          ),
          // Pré-charger le color picker invisible
          if (_colorPickerPreloaded)
            Offstage(
              child: _ColorPickerDialog(initialColor: _selectedColor),
            ),
        ],
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const _ColorPickerDialog({required this.initialColor});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _tempColor;

  @override
  void initState() {
    super.initState();
    _tempColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.chooseColor),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ColorPickerWidget(
              initialColor: _tempColor,
              onColorChanged: (color) {
                setState(() {
                  _tempColor = color;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(AppLocalizations.of(context)!.opacity, style: const TextStyle(fontSize: 13)),
                ),
                Expanded(
                  child: Slider(
                    value: _tempColor.alpha.toDouble(),
                    min: 0,
                    max: 255,
                    divisions: 255,
                    activeColor: Colors.grey,
                    onChanged: (value) {
                      setState(() {
                        _tempColor = _tempColor.withAlpha(value.toInt());
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    _tempColor.alpha.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _tempColor);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  AppLocalizations.of(context)!.validate,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
