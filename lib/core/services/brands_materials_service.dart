import 'package:shared_preferences/shared_preferences.dart';

/// Service pour gérer les marques et matériaux (par défaut + personnalisés)
class BrandsMaterialsService {
  static const String _keyCustomBrands = 'custom_brands';
  static const String _keyCustomMaterials = 'custom_materials';

  // Liste des marques par défaut (21 marques)
  static const List<String> _defaultBrands = [
    'Amazon Basics',
    'Anycubic',
    'ColorFabb',
    'Creality',
    'Elegoo',
    'eSun',
    'Filamentum',
    'FormFutura',
    'Generic',
    'Hatchbox',
    'Inland',
    'MatterHackers',
    'Micro Swiss',
    'Monoprice',
    'NylonX',
    'Overture',
    'Polymaker',
    'Proto-Pasta',
    'Prusa',
    'SainSmart',
    'Sunlu',
  ];

  // Liste des matériaux par défaut (25 matériaux)
  static const List<String> _defaultMaterials = [
    'ABS',
    'ASA',
    'HIPS',
    'Nylon',
    'PC',
    'PETG',
    'PETG Carbon Fiber',
    'PLA',
    'PLA+',
    'PLA High Speed',
    'PLA Tough',
    'PLA SE',
    'PLA Carbon Fiber',
    'PLA Wood',
    'PLA Metal',
    'PLA Marble',
    'PLA Bamboo',
    'PLA Silk',
    'PLA Matte',
    'PLA Glow',
    'PLA Translucent',
    'PLA Color Change',
    'TPU',
    'TPU 95A',
    'PVA',
  ];

  /// Récupère la liste complète des marques (par défaut + personnalisées)
  static Future<List<String>> getAllBrands() async {
    final prefs = await SharedPreferences.getInstance();
    final customBrands = prefs.getStringList(_keyCustomBrands) ?? [];

    // Combine default + custom, remove duplicates, and sort
    final allBrands = <String>{
      ..._defaultBrands,
      ...customBrands,
    }.toList()..sort();

    return allBrands;
  }

  /// Récupère la liste complète des matériaux (par défaut + personnalisés)
  static Future<List<String>> getAllMaterials() async {
    final prefs = await SharedPreferences.getInstance();
    final customMaterials = prefs.getStringList(_keyCustomMaterials) ?? [];

    // Combine default + custom, remove duplicates, and sort
    final allMaterials = <String>{
      ..._defaultMaterials,
      ...customMaterials,
    }.toList()..sort();

    return allMaterials;
  }

  /// Ajoute une marque personnalisée
  static Future<void> addCustomBrand(String brand) async {
    if (brand.isEmpty || _defaultBrands.contains(brand)) {
      return; // Ne pas ajouter si vide ou déjà dans les marques par défaut
    }

    final prefs = await SharedPreferences.getInstance();
    final customBrands = prefs.getStringList(_keyCustomBrands) ?? [];

    if (!customBrands.contains(brand)) {
      customBrands.add(brand);
      await prefs.setStringList(_keyCustomBrands, customBrands);
    }
  }

  /// Ajoute un matériau personnalisé
  static Future<void> addCustomMaterial(String material) async {
    if (material.isEmpty || _defaultMaterials.contains(material)) {
      return; // Ne pas ajouter si vide ou déjà dans les matériaux par défaut
    }

    final prefs = await SharedPreferences.getInstance();
    final customMaterials = prefs.getStringList(_keyCustomMaterials) ?? [];

    if (!customMaterials.contains(material)) {
      customMaterials.add(material);
      await prefs.setStringList(_keyCustomMaterials, customMaterials);
    }
  }

  /// Vérifie si une marque est personnalisée (non par défaut)
  static bool isCustomBrand(String brand) {
    return !_defaultBrands.contains(brand);
  }

  /// Vérifie si un matériau est personnalisé (non par défaut)
  static bool isCustomMaterial(String material) {
    return !_defaultMaterials.contains(material);
  }

  /// Supprime une marque personnalisée
  static Future<void> removeCustomBrand(String brand) async {
    final prefs = await SharedPreferences.getInstance();
    final customBrands = prefs.getStringList(_keyCustomBrands) ?? []
      ..remove(brand);
    await prefs.setStringList(_keyCustomBrands, customBrands);
  }

  /// Supprime un matériau personnalisé
  static Future<void> removeCustomMaterial(String material) async {
    final prefs = await SharedPreferences.getInstance();
    final customMaterials = prefs.getStringList(_keyCustomMaterials) ?? []
      ..remove(material);
    await prefs.setStringList(_keyCustomMaterials, customMaterials);
  }

  /// Récupère uniquement les marques par défaut
  static List<String> getDefaultBrands() {
    return List.from(_defaultBrands);
  }

  /// Récupère uniquement les matériaux par défaut
  static List<String> getDefaultMaterials() {
    return List.from(_defaultMaterials);
  }
}
