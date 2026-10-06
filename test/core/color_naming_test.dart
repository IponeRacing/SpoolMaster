// Nom générique d'une couleur RGB, partagé par tous les lecteurs de tags.

import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/utils/color_naming.dart';

void main() {
  test('blancs et gris clairs : White (avant : « Pink » sur les tags Prusa)', () {
    expect(colorNameFromRgb(255, 255, 255), 'White');
    expect(colorNameFromRgb(230, 230, 230), 'White');
    expect(colorNameFromRgb(250, 250, 255), 'White'); // blanc froid (bug PETG White → Lila)
  });

  test('achromatiques', () {
    expect(colorNameFromRgb(0, 0, 0), 'Black');
    expect(colorNameFromRgb(40, 40, 45), 'Black');
    expect(colorNameFromRgb(128, 128, 128), 'Gray');
  });

  test('teintes (avant : « Unknown » sur les standards ouverts)', () {
    expect(colorNameFromRgb(0xC1, 0x2E, 0x1F), 'Red');
    expect(colorNameFromRgb(0xFF, 0x6A, 0x13), 'Orange');
    expect(colorNameFromRgb(0x7D, 0x4A, 0x20), 'Brown');
    expect(colorNameFromRgb(0xFE, 0xC6, 0x00), 'Yellow');
    expect(colorNameFromRgb(0x00, 0xAE, 0x42), 'Green');
    expect(colorNameFromRgb(0x21, 0x96, 0xF3), 'Blue');
    expect(colorNameFromRgb(0x80, 0x30, 0xC0), 'Purple');
    expect(colorNameFromRgb(0xFF, 0x69, 0xB4), 'Pink');
  });

  // Vrais tags Anycubic (corpus du 04.10.2026) : nommés « Orange » / « Red »
  // avant le 06.10.2026.
  test('vrais tags Anycubic : beige, marron foncé, roses', () {
    expect(colorNameFromRgb(0xD4, 0xB9, 0x96), 'Beige');
    expect(colorNameFromRgb(0x96, 0x5D, 0x3E), 'Brown'); // Dark Brown
    expect(colorNameFromRgb(0xF7, 0x80, 0x92), 'Pink'); // Strawberry Pink
    expect(colorNameFromRgb(0xFF, 0x8D, 0xA1), 'Pink');
    // inchangés : rouges vifs, orange, jaune or, pêche
    expect(colorNameFromRgb(0xE1, 0x06, 0x00), 'Red');
    expect(colorNameFromRgb(0xC8, 0x10, 0x2E), 'Red');
    expect(colorNameFromRgb(0xFE, 0x72, 0x37), 'Orange');
    expect(colorNameFromRgb(0xFE, 0xC1, 0x96), 'Orange'); // Peach Fuzz
  });

  test('codes couleur des SKU Anycubic', () {
    expect(anycubicSkuColorName('LB'), 'Beige');
    expect(anycubicSkuColorName('KB'), 'Brown');
    expect(anycubicSkuColorName('PO'), 'Purple');
    expect(anycubicSkuColorName('SP'), 'Pink');
    expect(anycubicSkuColorName('GD'), 'Gold');
    expect(anycubicSkuColorName('CL'), 'Transparent');
    // PLA+ : « PBR » = Bright Red (vrai tag), pas « BR » ; inconnu → sans le P
    expect(anycubicSkuColorName('PBR'), 'Red');
    expect(anycubicSkuColorName('PVO'), 'Orange');
    // « BR » ambigu → null : le nom vient du RGB du tag
    expect(anycubicSkuColorName('BR'), isNull);
    expect(anycubicSkuColorName('XX'), isNull);
  });
}
