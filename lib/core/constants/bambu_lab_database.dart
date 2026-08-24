/// Base de données des matériaux et couleurs Bambu Lab
/// Sources: PDF officiels Bambu Lab + FilamentColors.xyz
class BambuLabDatabase {
  /// Matériaux disponibles
  static const List<String> materials = [
    'PLA Basic',
    'PLA Matte',
    'PLA Silk',
    'PLA Translucent',
    'PETG Basic',
    'PETG HF',
    'ABS',
    'ASA',
    'TPU',
    'Nylon',
    'PC',
    'PLA-CF',
    'PETG-CF',
    'PA-CF',
    'PPA-CF',
  ];

  /// Couleurs PLA Basic avec codes RGB
  static const Map<String, int> plaBasicColors = {
    'Jade White': 0xFFFFFFFF,
    'Black': 0xFF000000,
    'Red': 0xFFE30039,
    'Orange': 0xFFF37021,
    'Yellow': 0xFFFFC845,
    'Green': 0xFF00A550,
    'Blue': 0xFF0047BB,
    'Magenta': 0xFFEC008C,
    'Purple': 0xFF5E43B7,
    'Grey': 0xFF8B9398,
    'Teal': 0xFF009FA1,
    'Sakura Pink': 0xFFF5B8D0,
    'Mint': 0xFF8DD3C7,
    'Lavender': 0xFFB399D7,
    'Light Orange': 0xFFFDB462,
    'Light Green': 0xFFB3DE69,
    'Light Blue': 0xFF80B1D3,
    'Mistletoe Green': 0xFF3F8E43,
    'Christmas Red': 0xFFBB3F40,
  };

  /// Couleurs PLA Matte avec codes RGB
  static const Map<String, int> plaMatteColors = {
    'Ivory White': 0xFFFFFFFF,
    'Bone White': 0xFFCBC6B8,
    'Black': 0xFF000000,
    'Charcoal': 0xFF464646,
    'Grey': 0xFF8B9398,
    'Desert Tan': 0xFFE8DBB7,
    'Caramel': 0xFFAE835B,
    'Red': 0xFFE30039,
    'Orange': 0xFFF37021,
    'Lemon Yellow': 0xFFFDDB27,
    'Green': 0xFF00A550,
    'Blue': 0xFF0047BB,
    'Purple': 0xFF5E43B7,
    'Sakura Pink': 0xFFF5B8D0,
    'Coral': 0xFFFF8989,
    'Lilac': 0xFFD4BED8,
  };

  /// Couleurs PLA Translucent avec codes RGB
  static const Map<String, int> plaTranslucentColors = {
    'Clear': 0xFFFFFFFF,
    'Teal': 0xFF009FA1,
    'Light Jade': 0xFF96D8AF,
    'Blue': 0xFF0047BB,
    'Purple': 0xFF8344B0,
    'Orange': 0xFFF37021,
    'Red': 0xFFE30039,
    'Yellow': 0xFFFFC845,
  };

  /// Couleurs PETG Basic avec codes RGB
  static const Map<String, int> petgBasicColors = {
    'White': 0xFFFFFFFF,
    'Black': 0xFF000000,
    'Red': 0xFFE30039,
    'Orange': 0xFFF37021,
    'Yellow': 0xFFFFC845,
    'Green': 0xFF00A550,
    'Blue': 0xFF0047BB,
    'Purple': 0xFF5E43B7,
    'Grey': 0xFF8B9398,
    'Teal': 0xFF009FA1,
    'Transparent': 0xFFFFFFFF,
    'Pink': 0xFFF5B8D0,
    'Lime': 0xFFB3DE69,
    'Sky Blue': 0xFF80B1D3,
    'Lavender': 0xFFB399D7,
  };

  /// Couleurs ABS avec codes RGB
  static const Map<String, int> absColors = {
    'White': 0xFFFFFFFF,
    'Black': 0xFF000000,
    'Red': 0xFFE30039,
    'Orange': 0xFFF37021,
    'Yellow': 0xFFFFC845,
    'Green': 0xFF00A550,
    'Blue': 0xFF0047BB,
    'Purple': 0xFF5E43B7,
    'Grey': 0xFF8B9398,
    'Teal': 0xFF009FA1,
    'Pink': 0xFFF5B8D0,
    'Lime': 0xFFB3DE69,
    'Sky Blue': 0xFF80B1D3,
    'Lavender': 0xFFB399D7,
    'Coral': 0xFFFF8989,
    'Beige': 0xFFE8DBB7,
  };

  /// Obtenir toutes les couleurs pour un matériau donné
  static Map<String, int> getColorsForMaterial(String material) {
    final normalizedMaterial = material.toUpperCase().trim();

    if (normalizedMaterial.contains('PLA BASIC')) {
      return plaBasicColors;
    } else if (normalizedMaterial.contains('PLA MATTE')) {
      return plaMatteColors;
    } else if (normalizedMaterial.contains('PLA TRANSLUCENT') ||
               normalizedMaterial.contains('PLA SILK')) {
      return plaTranslucentColors;
    } else if (normalizedMaterial.contains('PETG')) {
      return petgBasicColors;
    } else if (normalizedMaterial.contains('ABS') ||
               normalizedMaterial.contains('ASA')) {
      return absColors;
    }

    // Couleurs par défaut si le matériau n'est pas reconnu
    return plaBasicColors;
  }

  /// Obtenir le code RGB d'une couleur pour un matériau donné
  static int? getColorRgb(String material, String colorName) {
    final colors = getColorsForMaterial(material);

    // Recherche exacte
    if (colors.containsKey(colorName)) {
      return colors[colorName];
    }

    // Recherche approximative (case-insensitive)
    final normalizedColorName = colorName.toLowerCase().trim();
    for (final entry in colors.entries) {
      if (entry.key.toLowerCase() == normalizedColorName) {
        return entry.value;
      }
    }

    // Couleur par défaut (blanc)
    return 0xFFFFFFFF;
  }

  /// Températures recommandées par matériau
  static Map<String, dynamic> getTemperatures(String material) {
    final normalizedMaterial = material.toUpperCase().trim();

    if (normalizedMaterial.contains('PLA')) {
      return {
        'extruderMin': 190,
        'extruderMax': 230,
        'bedMin': 45,
        'bedMax': 65,
      };
    } else if (normalizedMaterial.contains('PETG')) {
      return {
        'extruderMin': 220,
        'extruderMax': 260,
        'bedMin': 70,
        'bedMax': 85,
      };
    } else if (normalizedMaterial.contains('ABS') ||
               normalizedMaterial.contains('ASA')) {
      return {
        'extruderMin': 240,
        'extruderMax': 270,
        'bedMin': 90,
        'bedMax': 110,
      };
    } else if (normalizedMaterial.contains('TPU')) {
      return {
        'extruderMin': 210,
        'extruderMax': 240,
        'bedMin': 35,
        'bedMax': 60,
      };
    } else if (normalizedMaterial.contains('NYLON') ||
               normalizedMaterial.contains('PA')) {
      return {
        'extruderMin': 250,
        'extruderMax': 280,
        'bedMin': 80,
        'bedMax': 100,
      };
    } else if (normalizedMaterial.contains('PC')) {
      return {
        'extruderMin': 260,
        'extruderMax': 290,
        'bedMin': 90,
        'bedMax': 110,
      };
    }

    // Valeurs par défaut (PLA)
    return {
      'extruderMin': 190,
      'extruderMax': 230,
      'bedMin': 45,
      'bedMax': 65,
    };
  }

  /// Ratio poids/longueur par matériau (mètres par kilogramme)
  static double getRatio(String material) {
    final normalizedMaterial = material.toUpperCase().trim();

    if (normalizedMaterial.contains('PLA')) {
      return 330; // 1000g = 330m
    } else if (normalizedMaterial.contains('PETG')) {
      return 285; // Plus dense
    } else if (normalizedMaterial.contains('ABS') ||
               normalizedMaterial.contains('ASA')) {
      return 360; // Moins dense
    } else if (normalizedMaterial.contains('TPU')) {
      return 240; // Très flexible, plus dense
    } else if (normalizedMaterial.contains('NYLON') ||
               normalizedMaterial.contains('PA')) {
      return 320;
    } else if (normalizedMaterial.contains('PC')) {
      return 270; // Polycarbonate, dense
    }

    // Ratio par défaut (PLA)
    return 330;
  }
}
