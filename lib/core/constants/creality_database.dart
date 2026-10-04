import 'package:nfc_filament/core/constants/creality_materials.g.dart';

/// Base de données des matériaux et codes Creality CFS
class CrealityDatabase {
  CrealityDatabase._();

  /// Matériau officiel Creality d'un code de tag (table générée par
  /// tool/build_creality_materials.py), ou null si inconnu.
  static CrealityMaterial? material(String code) {
    for (final m in crealityMaterials) {
      if (m.code == code) return m;
    }
    return null;
  }

  /// Material ID → nom du matériau. Avant (jusqu'à la 1.4.10+92) : table
  /// écrite à la main, fausse pour la plupart des codes (03001 « PLA Silk »
  /// au lieu de « Hyper ABS »…).
  static final Map<String, String> materials = {
    for (final m in crealityMaterials) m.code: m.name,
  };

  /// Weight code → poids en grammes
  static const Map<String, double> weightCodes = {
    '0330': 1000.0,
    '0165': 500.0,
    '0082': 250.0,
    '0198': 600.0,
    '0247': 750.0,
  };

  /// Code à écrire sur le tag pour un nom (« Hyper PLA ») ou un type
  /// (« PETG ») : nom exact d'abord, puis matériau générique du même type.
  static String? getMaterialId(String nameOrType) {
    final q = nameOrType.trim().toLowerCase();
    if (q.isEmpty) return null;
    for (final m in crealityMaterials) {
      if (m.name.toLowerCase() == q) return m.code;
    }
    for (final m in crealityMaterials) {
      if (m.brand == 'Generic' && m.type.toLowerCase() == q) return m.code;
    }
    return null;
  }

  /// Poids en grammes → weight code (reverse lookup pour l'écriture)
  static String getWeightCode(double weightGrams) {
    for (final entry in weightCodes.entries) {
      if ((entry.value - weightGrams).abs() < 50) return entry.key;
    }
    return '0330'; // 1kg par défaut
  }
}
