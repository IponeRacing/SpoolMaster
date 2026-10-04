import 'package:flutter/material.dart';
import 'package:nfc_filament/core/utils/bambu_color_lookup.dart';
import 'package:nfc_filament/core/utils/color_naming.dart';

/// Couleur de fond de la pastille d'une bobine (RGB 24 bits, opaque).
Color filamentSwatchColor(int colorRgb) => Color(0xFF000000 | colorRgb);

/// Dégradé à poser sur la pastille, ou null pour une couleur unie.
///
/// - Filament Bambu multicolore (dégradé, bicolore Silk) : toutes ses
///   couleurs officielles. Le tag n'en porte que deux (quatre pour Dawn
///   Radiance), le catalogue les a toutes ; on les retrouve par l'identifiant
///   et la variante déjà enregistrés sur la bobine (rien de plus à
///   synchroniser). Seulement si la couleur enregistrée est l'une d'elles :
///   une couleur changée à la main reste unie.
/// - Filament transparent ([kClearFilamentRgb]) : hachures, au lieu d'une
///   pastille noire ou blanche.
Gradient? filamentSwatchGradient(
  int colorRgb, {
  String? materialId,
  String? variantId,
}) {
  final rgb = colorRgb & 0xFFFFFF;
  if (rgb == kClearFilamentRgb) return _clearHatching;
  final official = bambuCatalogColor(materialId, variantId);
  if (official != null && official.rgb.length > 1 && official.rgb.contains(rgb)) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [for (final c in official.rgb) filamentSwatchColor(c)],
    );
  }
  return null;
}

const Gradient _clearHatching = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment(-0.75, -0.75),
  colors: [Color(0xFFF7F9FA), Color(0xFFF7F9FA), Color(0xFFD3DAE0), Color(0xFFD3DAE0)],
  stops: [0, 0.5, 0.5, 1],
  tileMode: TileMode.repeated,
);
