import 'package:nfc_filament/core/models/spool_inventory_item.dart';

/// Normalise pour la recherche : minuscules, sans accents.
String foldForSearch(String input) {
  var s = input.toLowerCase();
  const map = {
    'à': 'a', 'á': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
    'ç': 'c', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
    'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ñ': 'n',
    'ò': 'o', 'ó': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', 'ø': 'o',
    'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', 'ý': 'y', 'ÿ': 'y', 'ß': 'ss',
  };
  for (final e in map.entries) {
    s = s.replaceAll(e.key, e.value);
  }
  return s;
}

/// Vrai si chaque mot de [query] apparaît dans la marque, le matériau, la
/// couleur (nom stocké ET nom traduit affiché), l'emplacement, les notes,
/// le type détaillé ou le lot. Requête vide = tout correspond.
bool matchesStockSearch(
  SpoolInventoryItem spool,
  String query, {
  String? translatedColor,
}) {
  final terms = foldForSearch(query)
      .split(RegExp(r'\s+'))
      .where((t) => t.isNotEmpty)
      .toList();
  if (terms.isEmpty) return true;
  final haystack = foldForSearch([
    spool.brand,
    spool.material,
    spool.colorName,
    translatedColor ?? '',
    spool.location ?? '',
    spool.notes ?? '',
    spool.detailedType ?? '',
    spool.batchNumber ?? '',
  ].join(' '));
  return terms.every(haystack.contains);
}
