// Pastille de couleur des bobines : dégradé des filaments Bambu multicolores,
// hachures des transparents, couleur unie sinon.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/utils/bambu_color_lookup.dart';
import 'package:nfc_filament/core/utils/color_naming.dart';
import 'package:nfc_filament/core/utils/filament_swatch.dart';

void main() {
  group('bambuCatalogColor', () {
    test('code exact, puis sans zéros de tête', () {
      expect(bambuCatalogColor('GFA00', 'A00-W1')!.name, 'Jade White');
      expect(bambuCatalogColor('GFA00', 'A00-B01')!.name, 'Blue Gray');
      expect(bambuCatalogColor('GFG00', 'G00-B0')!.name, 'Blue');
      expect(bambuCatalogColor('GFG00', 'G00-B00')!.name, 'Reflex Blue');
    });

    test('inconnu ou incomplet → null', () {
      expect(bambuCatalogColor('GFZ99', 'Z99-K0'), isNull);
      expect(bambuCatalogColor('GFA00', 'A00'), isNull);
      expect(bambuCatalogColor(null, 'A00-W1'), isNull);
      expect(bambuCatalogColor('GFA00', null), isNull);
    });
  });

  group('filamentSwatchGradient', () {
    test('Bambu multicolore : toutes les couleurs officielles', () {
      // Dawn Radiance : le tag n'en porte que deux, le catalogue en a quatre.
      final g = filamentSwatchGradient(0xEC984C, materialId: 'GFA05', variantId: 'A05-M8');
      expect(g, isA<LinearGradient>());
      expect(g!.colors, hasLength(4));
      expect(g.colors.first, const Color(0xFFEC984C));
    });

    test('couleur changée à la main : pastille unie', () {
      expect(
        filamentSwatchGradient(0x123456, materialId: 'GFA05', variantId: 'A05-M8'),
        isNull,
      );
    });

    test('transparent : hachures', () {
      expect(filamentSwatchGradient(kClearFilamentRgb), isNotNull);
    });

    test('couleur unie (Bambu ou autre marque) : pas de dégradé', () {
      expect(filamentSwatchGradient(0xFFFFFF, materialId: 'GFA00', variantId: 'A00-W1'), isNull);
      expect(filamentSwatchGradient(0xFF0000), isNull);
    });

    test('couleur de fond opaque', () {
      expect(filamentSwatchColor(0x0047BB), const Color(0xFF0047BB));
    });
  });
}
