// GÉNÉRÉ par tool/build_creality_materials.py : ne pas modifier à la main.
// Source : material_database.json de Creality, DnG-Crafts/K2-RFID@8db645afe070 docs/material_database.json
// 56 matériaux (code du tag, marque, nom, type, buse min/max, plateau).

/// Matériau Creality identifié par le code à 5 chiffres du tag CFS.
class CrealityMaterial {
  const CrealityMaterial(this.code, this.brand, this.name, this.type,
      this.nozzleMin, this.nozzleMax, this.bedTemp);

  final String code;
  final String brand;

  /// Nom commercial (ex. « Hyper PLA »).
  final String name;

  /// Type de base (ex. « PLA », « PETG », « PA-CF »).
  final String type;

  /// Températures recommandées par Creality (°C, 0 = inconnue).
  final int nozzleMin;
  final int nozzleMax;
  final int bedTemp;
}

const List<CrealityMaterial> crealityMaterials = [
  CrealityMaterial('00001', 'Generic', 'Generic PLA', 'PLA', 190, 240, 50),
  CrealityMaterial('00002', 'Generic', 'Generic PLA-Silk', 'PLA', 190, 240, 50),
  CrealityMaterial('00003', 'Generic', 'Generic PETG', 'PETG', 220, 270, 70),
  CrealityMaterial('00004', 'Generic', 'Generic ABS', 'ABS', 240, 280, 100),
  CrealityMaterial('00005', 'Generic', 'Generic TPU', 'TPU', 200, 250, 40),
  CrealityMaterial('00006', 'Generic', 'Generic PLA-CF', 'PLA-CF', 190, 240, 50),
  CrealityMaterial('00007', 'Generic', 'Generic ASA', 'ASA', 240, 280, 90),
  CrealityMaterial('00008', 'Generic', 'Generic PA', 'PA', 240, 280, 50),
  CrealityMaterial('00009', 'Generic', 'Generic PA-CF', 'PA-CF', 260, 300, 60),
  CrealityMaterial('00010', 'Generic', 'Generic BVOH', 'BVOH', 200, 220, 50),
  CrealityMaterial('00011', 'Generic', 'Generic PVA', 'PVA', 215, 225, 50),
  CrealityMaterial('00012', 'Generic', 'Generic HIPS', 'HIPS', 220, 250, 100),
  CrealityMaterial('00013', 'Generic', 'Generic PET-CF', 'PET-CF', 280, 320, 90),
  CrealityMaterial('00014', 'Generic', 'Generic PETG-CF', 'PETG-CF', 240, 260, 80),
  CrealityMaterial('00015', 'Generic', 'Generic PA6-CF', 'PA6-CF', 280, 300, 60),
  CrealityMaterial('00016', 'Generic', 'Generic PAHT-CF', 'PAHT-CF', 300, 320, 90),
  CrealityMaterial('00017', 'Generic', 'Generic PPS', 'PPS', 300, 350, 90),
  CrealityMaterial('00018', 'Generic', 'Generic PPS-CF', 'PPS-CF', 300, 350, 105),
  CrealityMaterial('00019', 'Generic', 'Generic PP', 'PP', 220, 250, 40),
  CrealityMaterial('00020', 'Generic', 'Generic PET', 'PET', 250, 270, 90),
  CrealityMaterial('00021', 'Generic', 'Generic PC', 'PC', 250, 270, 110),
  CrealityMaterial('00022', 'Generic', 'Generic PA612-CF', 'PA-CF', 260, 300, 60),
  CrealityMaterial('00023', 'Generic', 'Generic Support for PA', 'PA', 260, 300, 80),
  CrealityMaterial('00024', 'Generic', 'Generic Support for PLA', 'PLA', 190, 240, 50),
  CrealityMaterial('00025', 'Generic', 'Generic PA12-CF', 'PA-CF', 260, 300, 60),
  CrealityMaterial('00026', 'Generic', 'Generic TPU 64D', 'TPU', 215, 240, 40),
  CrealityMaterial('00027', 'Generic', 'Generic PETG-GF', 'PETG-GF', 240, 270, 70),
  CrealityMaterial('00031', 'Generic', 'Generic PP-CF', 'PP-CF', 220, 270, 80),
  CrealityMaterial('00032', 'Generic', 'Generic PCTG', 'PCTG', 250, 270, 70),
  CrealityMaterial('00033', 'Generic', 'Generic ASA-CF', 'ASA-CF', 250, 280, 90),
  CrealityMaterial('00034', 'Generic', 'Generic PA6-GF', 'PA-GF', 250, 290, 100),
  CrealityMaterial('00035', 'eSUN', 'PLA-LW', 'PLA', 190, 270, 50),
  CrealityMaterial('01001', 'Creality', 'Hyper PLA', 'PLA', 190, 240, 50),
  CrealityMaterial('01601', 'Creality', 'Soleyin Ultra PLA', 'PLA', 190, 240, 50),
  CrealityMaterial('02001', 'Creality', 'Hyper PLA-CF', 'PLA-CF', 190, 240, 50),
  CrealityMaterial('03001', 'Creality', 'Hyper ABS', 'ABS', 240, 280, 80),
  CrealityMaterial('04001', 'Creality', 'CR-PLA', 'PLA', 190, 240, 50),
  CrealityMaterial('05001', 'Creality', 'CR-Silk', 'PLA', 190, 240, 50),
  CrealityMaterial('06001', 'Creality', 'CR-PETG', 'PETG', 220, 270, 70),
  CrealityMaterial('06002', 'Creality', 'Hyper PETG', 'PETG', 220, 270, 70),
  CrealityMaterial('07001', 'Creality', 'CR-ABS', 'ABS', 240, 280, 100),
  CrealityMaterial('07002', 'Creality', 'Hyper PC', 'PC', 250, 270, 110),
  CrealityMaterial('08001', 'Creality', 'Ender-PLA', 'PLA', 190, 240, 50),
  CrealityMaterial('09001', 'Creality', 'EN-PLA+', 'PLA', 190, 240, 50),
  CrealityMaterial('09002', 'Creality', 'ENDER FAST PLA', 'PLA', 190, 240, 50),
  CrealityMaterial('10001', 'Creality', 'HP-TPU', 'TPU', 190, 240, 40),
  CrealityMaterial('11001', 'Creality', 'CR-Nylon', 'PA', 250, 270, 50),
  CrealityMaterial('12002', 'Creality', 'Hyper PPA-CF', 'PA-CF', 280, 320, 100),
  CrealityMaterial('12003', 'Creality', 'Hyper PAHT-CF', 'PA-CF', 280, 320, 90),
  CrealityMaterial('13001', 'Creality', 'CR-PLA Carbon', 'PLA', 190, 240, 50),
  CrealityMaterial('14001', 'Creality', 'CR-PLA Matte', 'PLA', 190, 240, 50),
  CrealityMaterial('15001', 'Creality', 'CR-PLA Fluo', 'PLA', 190, 240, 50),
  CrealityMaterial('16001', 'Creality', 'CR-TPU', 'TPU', 210, 240, 40),
  CrealityMaterial('17001', 'Creality', 'CR-Wood', 'PLA', 190, 240, 50),
  CrealityMaterial('18001', 'Creality', 'HP Ultra PLA', 'PLA', 190, 240, 50),
  CrealityMaterial('19001', 'Creality', 'HP-ASA', 'ASA', 240, 280, 90),
];
