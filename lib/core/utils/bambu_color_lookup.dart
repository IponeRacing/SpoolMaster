import 'package:nfc_filament/core/constants/bambu_colors.g.dart';

/// Couleur officielle d'un filament Bambu Lab d'après son identifiant
/// (« GFA05 », bloc 1 du tag) et sa variante (« A05-T3 ») ; null si inconnue.
///
/// Code exact d'abord, puis code sans zéros de tête (« B01 » = « B1 ») :
/// en normalisant d'emblée, la variante « G00-B0 » (Blue) tombait sur
/// « B00 » (Reflex Blue).
BambuColor? bambuCatalogColor(String? materialId, String? variantId) {
  if (materialId == null || materialId.isEmpty || variantId == null) return null;
  final dash = variantId.indexOf('-');
  if (dash < 0) return null;
  final code = variantId.substring(dash + 1).trim().toUpperCase();
  if (code.isEmpty) return null;

  final sameFilament = bambuColors.where((c) => c.filaId == materialId).toList();
  for (final c in sameFilament) {
    if (c.code == code) return c;
  }
  final normalized = _withoutLeadingZeros(code);
  for (final c in sameFilament) {
    if (_withoutLeadingZeros(c.code) == normalized) return c;
  }
  return null;
}

String _withoutLeadingZeros(String code) =>
    code.replaceAllMapped(RegExp(r'0+(\d)'), (m) => m.group(1)!).toUpperCase();
