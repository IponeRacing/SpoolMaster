/// Nom de couleur générique (anglais) d'une couleur RGB, pour les tags qui
/// donnent une couleur sans nom (Anycubic, OpenSpool, OpenPrintTag…).
///
/// Une seule implémentation pour tous les lecteurs : avant, trois copies
/// divergeaient (Prusa nommait « Pink » un filament blanc, les standards
/// ouverts renvoyaient « Unknown » pour la plupart des couleurs).
String colorNameFromRgb(int r, int g, int b) {
  // Classification HSV. IMPORTANT : traiter d'abord les couleurs ACHROMATIQUES
  // (blanc/gris/noir) via la SATURATION, AVANT la teinte. Sinon un blanc froid
  // (ex. 250,250,255, canal bleu à peine dominant) tombait dans la branche
  // bleu/violet et était classé « Purple » (bug rapporté : PETG White → Lila).
  final maxC = r > g ? (r > b ? r : b) : (g > b ? g : b);
  final minC = r < g ? (r < b ? r : b) : (g < b ? g : b);
  final delta = maxC - minC;
  final value = maxC; // luminosité 0-255
  final sat = maxC == 0 ? 0.0 : delta / maxC; // saturation 0-1

  // Achromatique : peu saturé OU canaux très proches → blanc/gris/noir
  if (sat < 0.22 || delta < 32) {
    if (value >= 200) return 'White';
    if (value <= 60) return 'Black';
    return 'Gray';
  }
  // Ces seuils et ceux ci-dessous ont été recalés le 06.10.2026 sur de vrais
  // tags Anycubic : beige, marron foncé et roses étaient nommés « Orange » /
  // « Red ».

  // Teinte en degrés (0-360)
  double hue;
  if (maxC == r) {
    // Dart : le % sur un double renvoie un résultat non négatif → gère g<b.
    hue = 60 * (((g - b) / delta) % 6);
  } else if (maxC == g) {
    hue = 60 * (((b - r) / delta) + 2);
  } else {
    hue = 60 * (((r - g) / delta) + 4);
  }
  if (hue < 0) hue += 360;

  // Segmentation par teinte (cyan replié sur Blue, magenta sur Pink/Purple)
  // Rouge clair peu saturé = rose (Strawberry Pink F78092 ; un rouge vif est
  // saturé à plus de 0,8).
  if (hue < 15 || hue >= 345) return sat < 0.55 && value >= 200 ? 'Pink' : 'Red';
  // Orangé/jaune clair peu saturé = beige (D4B996), avant orange et jaune
  if (hue < 68 && sat < 0.35 && value >= 170) return 'Beige';
  // Marron foncé réel à 150 de luminosité (965D3E) : seuil 150 → 170
  if (hue < 45) return value < 170 ? 'Brown' : 'Orange';
  if (hue < 68) return 'Yellow';
  if (hue < 168) return 'Green';
  if (hue < 258) return 'Blue';
  if (hue < 292) return 'Purple';
  // 292-345 : magenta/rose → Pink si clair, sinon Purple
  return value >= 160 ? 'Pink' : 'Purple';
}

/// RGB enregistré pour un filament transparent. Le tag Bambu code la couleur
/// en RGBA : alpha 0 = transparent, avec un RGB noir sans signification
/// (avant, la pastille d'un PETG Clear était noire). La pastille l'affiche
/// hachurée (voir `filamentSwatchGradient`).
const int kClearFilamentRgb = 0xE6EAEE;

/// Codes couleur des SKU Anycubic (« AHPLLB-107 » → « LB »), relevés sur de
/// vrais tags (corpus du 04.10.2026 : Retrofall59, DnG-Crafts, OpenRFID ; prod).
/// Noms génériques traduits par `translateColorName`. « BR » n'y est plus :
/// Brown d'après mmu_ace.py, mais « PBR » est un rouge vif sur un vrai tag →
/// le nom vient alors du RGB du tag.
const Map<String, String> anycubicSkuColors = {
  'BW': 'White',
  'BK': 'Black',
  'RD': 'Red',
  'BL': 'Blue',
  'GR': 'Green',
  'YL': 'Yellow',
  'OR': 'Orange',
  'VO': 'Orange',
  'PK': 'Pink',
  'GY': 'Gray',
  'PR': 'Purple',
  'LB': 'Beige',
  'KB': 'Brown', // Dark Brown
  'GD': 'Gold',
  'PO': 'Purple', // Purple Opulence
  'SP': 'Pink', // Strawberry Pink
  'CY': 'Cyan',
  'SL': 'Silver', // Texture Silver
  'CG': 'Green', // Classic Green
  'DB': 'Blue',
  'RR': 'Red',
  'VY': 'Yellow', // Vibrant Yellow
  'CL': 'Transparent', // PETG transparent, RGB du tag à 0
  // PLA+ : code couleur préfixé d'un « P » (AHPLPBR = Bright Red)
  'PBR': 'Red',
  'PBW': 'White',
  'PBK': 'Black', // Pearl Black
  'PDB': 'Blue', // Dazzling Blue
  'PGY': 'Gray', // Texture Grey
};

/// Nom générique du code couleur d'un SKU Anycubic, ou null s'il est inconnu
/// (le nom vient alors du RGB du tag). Un code PLA+ inconnu (« PVO ») est
/// essayé sans son « P ».
String? anycubicSkuColorName(String code) {
  final name = anycubicSkuColors[code];
  if (name != null) return name;
  if (code.length == 3 && code.startsWith('P')) {
    return anycubicSkuColors[code.substring(1)];
  }
  return null;
}
