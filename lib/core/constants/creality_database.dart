/// Base de données des matériaux et codes Creality CFS
class CrealityDatabase {
  CrealityDatabase._();

  /// Material ID → nom du matériau
  static const Map<String, String> materials = {
    '00001': 'Generic PLA',
    '01001': 'Hyper PLA',
    '02001': 'PLA Matte',
    '03001': 'PLA Silk',
    '04001': 'CR-PLA',
    '05001': 'PLA HS',
    '06001': 'CR-PETG',
    '07001': 'Hyper PETG',
    '08001': 'Generic PETG',
    '09001': 'PETG-CF',
    '10001': 'CR-ABS',
    '11001': 'Hyper ABS',
    '12001': 'Generic ABS',
    '13001': 'ABS-GF',
    '14001': 'TPU',
    '15001': 'PA',
    '16001': 'CR-TPU',
    '17001': 'ASA',
    '18001': 'PVA',
    '19001': 'HIPS',
    '20001': 'PC',
    '21001': 'BVOH',
    '22001': 'PET',
  };

  /// Weight code → poids en grammes
  static const Map<String, double> weightCodes = {
    '0330': 1000.0,
    '0165': 500.0,
    '0082': 250.0,
    '0198': 600.0,
    '0247': 750.0,
  };

  /// Nom du matériau → material ID (reverse lookup pour l'écriture)
  static String? getMaterialId(String materialName) {
    for (final entry in materials.entries) {
      if (entry.value == materialName) return entry.key;
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
