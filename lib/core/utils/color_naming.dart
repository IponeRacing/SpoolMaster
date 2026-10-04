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
  if (hue < 15 || hue >= 345) return 'Red';
  if (hue < 45) return value < 150 ? 'Brown' : 'Orange';
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
