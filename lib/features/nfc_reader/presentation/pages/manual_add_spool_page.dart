import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/brands_materials_service.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:nfc_filament/core/widgets/filament_autocomplete_field.dart';
import 'package:nfc_filament/core/widgets/formatted_value_widgets.dart';
import 'package:nfc_filament/features/nfc_reader/data/services/filament_library.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/widgets/color_picker_widget.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

// Manual Add/Edit Form Page
class ManualAddSpoolPage extends StatefulWidget {
  const ManualAddSpoolPage({
    required this.onSave,
    this.editSpool,
    this.onSaveBatch,
    this.showQuantity = false,
    super.key,
  });

  final void Function(SpoolInventoryItem) onSave;

  /// Appelé à la place de [onSave] quand la quantité > 1 (ajout multiple).
  /// Si null, [onSave] est appelé pour chaque bobine générée.
  final void Function(List<SpoolInventoryItem>)? onSaveBatch;
  final SpoolInventoryItem? editSpool;

  /// Affiche le champ Quantité (ajout au stock uniquement, pas liste de courses)
  final bool showQuantity;

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
  late TextEditingController _dryingTempController;
  late TextEditingController _dryingTimeController;
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  final _quantityController = TextEditingController(text: '1');

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
    _dryingTempController = TextEditingController(
      text: spool?.dryingTemp?.toString() ?? '',
    );
    _dryingTimeController = TextEditingController(
      text: spool?.dryingTime?.toString() ?? '',
    );
    _locationController = TextEditingController(text: spool?.location ?? '');
    _notesController = TextEditingController(text: spool?.notes ?? '');
    if (spool != null) {
      // Les bobines scannées stockent un RGB 24 bits (alpha 0) : alpha forcé,
      // comme partout ailleurs, sinon la couleur s'affiche transparente.
      _selectedColor = Color(0xFF000000 | spool.colorRgb);
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
    _dryingTempController.dispose();
    _dryingTimeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _quantityController.dispose();
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
            // Quantité (ajout au stock uniquement, pas en édition/liste de courses)
            if (widget.showQuantity && widget.editSpool == null) ...[
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.quantity,
                  helperText: AppLocalizations.of(context)!.quantityHelper,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.numbers),
                ),
                validator: (value) {
                  final n = int.tryParse(value ?? '');
                  if (n == null || n < 1 || n > 99) {
                    return AppLocalizations.of(context)!.quantityInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
            // Dropdown Marque
            if (!_isCustomBrand)
              DropdownButtonFormField<String>(
                initialValue: _selectedBrand,
                // Pleine largeur + ellipsis : un nom de marque long ne doit
                // pas déborder (écran étroit, Split View sur pliable).
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.brand,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.label),
                ),
                items: _knownBrands.map((brand) {
                  return DropdownMenuItem(
                    value: brand,
                    child: Text(brand, overflow: TextOverflow.ellipsis),
                  );
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
                    child: FilamentAutocompleteField(
                      controller: _brandController,
                      options: kFilamentBrands,
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
                initialValue: _selectedMaterial,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.materialType,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _knownMaterials.map((material) {
                  return DropdownMenuItem(
                    value: material,
                    child: Text(material, overflow: TextOverflow.ellipsis),
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
                    child: FilamentAutocompleteField(
                      controller: _materialController,
                      options: kFilamentMaterials,
                      textCapitalization: TextCapitalization.characters,
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
                    // 0 refusé : une bobine à 0 g s'affiche vide dès l'ajout.
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
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
                        _withUnit(AppLocalizations.of(context)!.extruderTempMin, tempUnit),
                    hintText: AppLocalizations.of(context)!.extruderTempMinHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.thermostat),
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
                        _withUnit(AppLocalizations.of(context)!.extruderTempMax, tempUnit),
                    hintText: AppLocalizations.of(context)!.extruderTempMaxHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.thermostat),
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
                        _withUnit(AppLocalizations.of(context)!.bedTempMin, tempUnit),
                    hintText: AppLocalizations.of(context)!.bedTempMinHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.bed),
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
                        _withUnit(AppLocalizations.of(context)!.bedTempMax, tempUnit),
                    hintText: AppLocalizations.of(context)!.bedTempMaxHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.bed),
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
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.straighten),
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
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.animation),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                );
              },
            ),
            const SizedBox(height: 16),
            // Température de séchage
            FutureBuilder<String>(
              future: UserPreferencesService.getUnits(),
              builder: (context, snapshot) {
                final units =
                    snapshot.data ?? UserPreferencesService.unitsMetric;
                final tempUnit = UserPreferencesService.getTemperatureUnit(
                  units,
                );
                return TextFormField(
                  controller: _dryingTempController,
                  decoration: InputDecoration(
                    labelText:
                        '${AppLocalizations.of(context)!.dryingTemp} ($tempUnit)',
                    hintText: AppLocalizations.of(context)!.dryingTempHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.dry_cleaning),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                );
              },
            ),
            const SizedBox(height: 16),
            // Temps de séchage
            TextFormField(
              controller: _dryingTimeController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.dryingTime,
                hintText: AppLocalizations.of(context)!.dryingTimeHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.timer_outlined),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            // Emplacement (où est rangée la bobine)
            TextFormField(
              key: const Key('spoolLocationField'),
              controller: _locationController,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.location,
                hintText: AppLocalizations.of(context)!.locationHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.place_outlined),
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),
            // Notes libres
            TextFormField(
              key: const Key('spoolNotesField'),
              controller: _notesController,
              textCapitalization: TextCapitalization.sentences,
              minLines: 2,
              maxLines: 5,
              maxLength: 1000,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.notes,
                hintText: AppLocalizations.of(context)!.notesHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
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
        ),
      ),
    );
  }

  /// Libellé + unité de l'utilisateur. Certaines traductions contiennent
  /// déjà « (°C) » : on le retire pour éviter « (°C) (°C) » ou, en unités
  /// impériales, un faux « (°C) (°F) ».
  static String _withUnit(String label, String unit) =>
      '${label.replaceAll(RegExp(r'\s*\(°[CF]\)'), '')} ($unit)';

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
          ),
        ),
      ),
    );
  }

  Future<void> _saveSpool() async {
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

      // Quantité (uniquement à l'ajout) : génère N bobines distinctes,
      // chacune avec son propre id et son propre poids restant.
      final isEditing = widget.editSpool != null;
      final quantity = isEditing
          ? 1
          : (int.tryParse(_quantityController.text) ?? 1).clamp(1, 99);

      final baseTs = DateTime.now().millisecondsSinceEpoch;

      final location = _locationController.text.trim();
      final notes = _notesController.text.trim();
      // En édition, les champs non présents dans le formulaire (données lues
      // sur le tag NFC : lot, type détaillé, ids matériau…) sont conservés.
      // Avant, l'édition reconstruisait la bobine et les perdait.
      final original = widget.editSpool;

      SpoolInventoryItem buildSpool(String id) => SpoolInventoryItem(
            id: id,
            brand: brand,
            material: material,
            colorName: _colorNameController.text.trim(),
            colorRgb: _selectedColor.toARGB32(),
            price: double.tryParse(_priceController.text) ?? 0.0,
            weight: double.tryParse(_weightController.text) ?? 0.0,
            remainingWeight:
                double.tryParse(_remainingWeightController.text) ?? 0.0,
            addedDate: widget.editSpool?.addedDate ?? DateTime.now(),
            extruderTempMin: int.tryParse(_extruderTempMinController.text),
            extruderTempMax: int.tryParse(_extruderTempMaxController.text),
            bedTempMin: int.tryParse(_bedTempMinController.text),
            bedTempMax: int.tryParse(_bedTempMaxController.text),
            diameter: double.tryParse(_diameterController.text),
            spoolLength: int.tryParse(_spoolLengthController.text),
            dryingTemp: int.tryParse(_dryingTempController.text),
            dryingTime: int.tryParse(_dryingTimeController.text),
            manufactureDate: original?.manufactureDate,
            batchNumber: original?.batchNumber,
            detailedType: original?.detailedType,
            materialVariantId: original?.materialVariantId,
            materialId: original?.materialId,
            nozzleSize: original?.nozzleSize,
            vendorCode: original?.vendorCode,
            productCode: original?.productCode,
            location: location.isEmpty ? null : location,
            notes: notes.isEmpty ? null : notes,
          );

      if (isEditing || quantity == 1) {
        widget.onSave(buildSpool(
          widget.editSpool?.id ?? baseTs.toString(),
        ));
      } else {
        // Ids uniques : baseTs + index
        final spools = List.generate(
          quantity,
          (i) => buildSpool('${baseTs}_$i'),
        );
        if (widget.onSaveBatch != null) {
          widget.onSaveBatch!(spools);
        } else {
          spools.forEach(widget.onSave);
        }
      }

      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
