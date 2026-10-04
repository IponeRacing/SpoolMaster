import 'dart:convert';

import 'package:excel/excel.dart' as xl;
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/services/spool_export_service.dart';

/// Résultat d'analyse d'un fichier d'import (avant confirmation).
class SpoolImportResult {
  const SpoolImportResult({
    required this.spools,
    required this.duplicates,
    required this.skippedRows,
  });

  /// Bobines prêtes à ajouter (nouveaux ids).
  final List<SpoolInventoryItem> spools;

  /// Lignes identiques à une bobine déjà en stock (ignorées).
  final int duplicates;

  /// Lignes inexploitables (matériau ou poids manquant).
  final int skippedRows;
}

/// Import de bobines depuis un CSV (export d'un tableur, d'une autre app)
/// ou depuis le classeur produit par SpoolExportService.
///
/// Les colonnes sont reconnues par leur en-tête (libellés de l'app dans la
/// langue courante + synonymes courants en plusieurs langues), insensible
/// à la casse, aux accents et aux unités entre parenthèses.
///
/// Les bobines importées reçoivent TOUJOURS un nouvel id : réutiliser un id
/// exporté pourrait heurter une bobine supprimée côté serveur (tombstone) et
/// faire disparaître la bobine importée au pull suivant.
class SpoolImportService {
  static const _synonyms = <StockColumn, List<String>>{
    StockColumn.brand: [
      'brand', 'marque', 'marke', 'marca', 'merk', 'marka', 'vendor',
      'manufacturer', 'hersteller', 'fabricant', 'produttore',
    ],
    StockColumn.material: [
      'material', 'materiau', 'materiaux', 'type de materiau', 'materiale',
      'materiaal', 'type', 'filament', 'filament type', 'werkstoff',
    ],
    StockColumn.color: [
      'color', 'colour', 'couleur', 'farbe', 'colore', 'kleur', 'kolor',
      'color name', 'colour name',
    ],
    StockColumn.colorHex: [
      'hex', 'color hex', 'colour hex', 'couleur hex', 'rgb', 'color code',
      'farbcode', 'code couleur',
    ],
    StockColumn.initialWeight: [
      'weight', 'poids', 'poids initial', 'initial weight', 'gewicht',
      'peso', 'net weight', 'poids net', 'nettogewicht', 'total weight',
    ],
    StockColumn.remainingWeight: [
      'remaining', 'remaining weight', 'poids restant', 'restant', 'rest',
      'restgewicht', 'peso residuo', 'peso restante', 'resterend',
    ],
    StockColumn.price: [
      'price', 'prix', 'preis', 'prezzo', 'precio', 'prijs', 'cena', 'cost',
      'cout', 'kosten',
    ],
    StockColumn.location: [
      'location', 'emplacement', 'lieu', 'ort', 'lagerort', 'standort',
      'posizione', 'ubicacion', 'locatie', 'storage', 'rangement',
    ],
    StockColumn.notes: [
      'notes', 'note', 'notizen', 'notiz', 'notas', 'comment', 'comments',
      'commentaire', 'remarques', 'bemerkung',
    ],
    StockColumn.addedDate: [
      'added', 'date added', 'added date', 'date d ajout', 'purchase date',
      'date d achat', 'kaufdatum', 'datum',
    ],
    StockColumn.extruderTempMin: [
      'extruder min', 'nozzle min', 'extrudeur min', 'buse min', 'duse min',
    ],
    StockColumn.extruderTempMax: [
      'extruder max', 'nozzle max', 'extrudeur max', 'buse max', 'duse max',
    ],
    StockColumn.bedTempMin: ['bed min', 'plateau min', 'bett min'],
    StockColumn.bedTempMax: ['bed max', 'plateau max', 'bett max'],
    StockColumn.diameter: ['diameter', 'diametre', 'durchmesser', 'diametro'],
    StockColumn.batchNumber: ['batch', 'lot', 'sku', 'numero de lot', 'charge'],
  };

  /// Normalise un en-tête : minuscules, sans accents, sans unités entre
  /// parenthèses, ponctuation → espaces.
  static String normalizeHeader(String raw) {
    // « Restant (%) » ≠ « Restant » : le pourcentage est conservé comme mot
    // (« restant pct ») avant de retirer les autres unités entre parenthèses.
    var s = raw
        .toLowerCase()
        .replaceAll(RegExp(r'\(\s*%\s*\)|%'), ' pct ')
        .replaceAll(RegExp(r'\(.*?\)'), ' ');
    const accents = {
      'à': 'a', 'á': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
      'ç': 'c', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ñ': 'n',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', 'ø': 'o',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', 'ý': 'y', 'ÿ': 'y',
      'ß': 'ss', 'ł': 'l', 'ś': 's', 'ż': 'z', 'ź': 'z', 'ć': 'c', 'ń': 'n',
    };
    for (final e in accents.entries) {
      s = s.replaceAll(e.key, e.value);
    }
    s = s.replaceAll(RegExp('[^a-z0-9]+'), ' ').trim();
    return s.replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Associe chaque index de colonne à un champ. [appLabels] = libellés de
  /// l'export dans la langue courante (prioritaires sur les synonymes).
  static Map<int, StockColumn> mapHeaders(
    List<String> headers, {
    Map<StockColumn, String> appLabels = const {},
  }) {
    final lookup = <String, StockColumn>{};
    _synonyms.forEach((col, words) {
      for (final w in words) {
        lookup[normalizeHeader(w)] = col;
      }
    });
    appLabels.forEach((col, label) => lookup[normalizeHeader(label)] = col);

    final result = <int, StockColumn>{};
    final used = <StockColumn>{};
    for (var i = 0; i < headers.length; i++) {
      final h = normalizeHeader(headers[i]);
      if (h.isEmpty) continue;
      final col = lookup[h];
      if (col != null && !used.contains(col)) {
        result[i] = col;
        used.add(col);
      }
    }
    return result;
  }

  /// Lit un CSV : séparateur auto (; , ou tabulation), guillemets, BOM UTF-8.
  static List<List<String>> parseCsv(String content) {
    var text = content;
    if (text.startsWith('﻿')) text = text.substring(1);
    final firstLine = text.split(RegExp(r'\r?\n')).firstWhere(
          (l) => l.trim().isNotEmpty,
          orElse: () => '',
        );
    final delimiter = [';', ',', '\t'].reduce(
      (a, b) => firstLine.split(a).length >= firstLine.split(b).length ? a : b,
    );

    final rows = <List<String>>[];
    var row = <String>[];
    final field = StringBuffer();
    var inQuotes = false;
    for (var i = 0; i < text.length; i++) {
      final c = text[i];
      if (inQuotes) {
        if (c == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            field.write('"');
            i++;
          } else {
            inQuotes = false;
          }
        } else {
          field.write(c);
        }
      } else if (c == '"') {
        inQuotes = true;
      } else if (c == delimiter) {
        row.add(field.toString());
        field.clear();
      } else if (c == '\n' || c == '\r') {
        if (c == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
        row.add(field.toString());
        field.clear();
        if (row.any((f) => f.trim().isNotEmpty)) rows.add(row);
        row = <String>[];
      } else {
        field.write(c);
      }
    }
    row.add(field.toString());
    if (row.any((f) => f.trim().isNotEmpty)) rows.add(row);
    return rows;
  }

  /// Lit la première feuille d'un classeur .xlsx en lignes de texte.
  static List<List<String>> parseXlsx(List<int> bytes) {
    final excel = xl.Excel.decodeBytes(bytes);
    final sheetName = excel.getDefaultSheet() ?? excel.tables.keys.first;
    final sheet = excel.tables[sheetName] ?? excel.tables.values.first;
    return [
      for (final row in sheet.rows)
        [for (final cell in row) _cellText(cell?.value)],
    ].where((r) => r.any((f) => f.trim().isNotEmpty)).toList();
  }

  static String _cellText(xl.CellValue? v) => switch (v) {
        null => '',
        xl.TextCellValue() => v.value.toString(),
        xl.IntCellValue() => v.value.toString(),
        xl.DoubleCellValue() => v.value.toString(),
        xl.DateCellValue() =>
          '${v.year.toString().padLeft(4, '0')}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}',
        xl.DateTimeCellValue() =>
          '${v.year.toString().padLeft(4, '0')}-${v.month.toString().padLeft(2, '0')}-${v.day.toString().padLeft(2, '0')}',
        xl.BoolCellValue() => v.value.toString(),
        _ => v.toString(),
      };

  /// Décode un fichier (xlsx si signature ZIP, sinon CSV UTF-8 / Latin-1).
  static List<List<String>> parseFile(List<int> bytes) {
    final isZip = bytes.length > 4 && bytes[0] == 0x50 && bytes[1] == 0x4B;
    if (isZip) return parseXlsx(bytes);
    String text;
    try {
      text = utf8.decode(bytes);
    } on FormatException {
      text = latin1.decode(bytes);
    }
    return parseCsv(text);
  }

  /// Nombre tolérant : « 1 000,50 », « 1,000.50 », « 25 € », « 1000g ».
  static double? parseNumber(String raw) {
    var s = raw.trim().replaceAll(RegExp(r'[^0-9,.\-]'), '');
    if (s.isEmpty) return null;
    final lastComma = s.lastIndexOf(',');
    final lastDot = s.lastIndexOf('.');
    if (lastComma > lastDot) {
      // virgule décimale (ou séparateur de milliers si 3 chiffres après)
      final decimals = s.length - lastComma - 1;
      s = (decimals == 3 && lastDot == -1 && s.indexOf(',') == lastComma)
          ? s.replaceAll(',', '')
          : s.replaceAll('.', '').replaceAll(',', '.');
    } else {
      s = s.replaceAll(',', '');
    }
    return double.tryParse(s);
  }

  static int? _parseColor(String raw) {
    final hex = raw.trim().replaceAll('#', '').replaceAll('0x', '');
    if (!RegExp(r'^[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$').hasMatch(hex)) return null;
    final rgb = int.parse(hex.substring(0, 6), radix: 16);
    return 0xFF000000 | rgb;
  }

  static DateTime? _parseDate(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;
    // jj.mm.aaaa, jj/mm/aaaa, jj-mm-aaaa
    final m = RegExp(r'^(\d{1,2})[./-](\d{1,2})[./-](\d{4})$').firstMatch(s);
    if (m != null) {
      return DateTime(
        int.parse(m.group(3)!),
        int.parse(m.group(2)!),
        int.parse(m.group(1)!),
      );
    }
    // Numéro de série Excel (jours depuis 1899-12-30)
    final serial = double.tryParse(s);
    if (serial != null && serial > 20000 && serial < 80000) {
      return DateTime(1899, 12, 30).add(Duration(days: serial.floor()));
    }
    return null;
  }

  /// Signature de doublon : même marque, matériau, couleur et poids restant.
  static String _signature(SpoolInventoryItem s) => [
        s.brand.toLowerCase().trim(),
        s.material.toLowerCase().trim(),
        s.colorName.toLowerCase().trim(),
        s.remainingWeight.round(),
        s.weight.round(),
      ].join('|');

  /// Transforme les lignes en bobines. La 1re ligne doit être l'en-tête.
  static SpoolImportResult buildSpools(
    List<List<String>> rows, {
    required List<SpoolInventoryItem> existing,
    Map<StockColumn, String> appLabels = const {},
    DateTime? now,
  }) {
    if (rows.length < 2) {
      return const SpoolImportResult(spools: [], duplicates: 0, skippedRows: 0);
    }
    final columns = mapHeaders(rows.first, appLabels: appLabels);
    if (!columns.containsValue(StockColumn.material)) {
      return SpoolImportResult(
        spools: const [],
        duplicates: 0,
        skippedRows: rows.length - 1,
      );
    }

    // Les doublons sont comptés contre le stock existant ; deux lignes
    // identiques du fichier restent deux bobines (quantité réelle).
    final existingSignatures = <String, int>{};
    for (final s in existing) {
      existingSignatures.update(_signature(s), (n) => n + 1, ifAbsent: () => 1);
    }

    final baseTs = (now ?? DateTime.now()).millisecondsSinceEpoch;
    final spools = <SpoolInventoryItem>[];
    var duplicates = 0;
    var skipped = 0;

    for (var r = 1; r < rows.length; r++) {
      final row = rows[r];
      String cell(StockColumn col) {
        final idx = columns.entries
            .firstWhere(
              (e) => e.value == col,
              orElse: () => const MapEntry(-1, StockColumn.brand),
            )
            .key;
        return (idx >= 0 && idx < row.length) ? row[idx].trim() : '';
      }

      final material = cell(StockColumn.material);
      final weight = parseNumber(cell(StockColumn.initialWeight)) ??
          parseNumber(cell(StockColumn.remainingWeight));
      if (material.isEmpty || weight == null || weight <= 0) {
        skipped++;
        continue;
      }
      final remaining =
          (parseNumber(cell(StockColumn.remainingWeight)) ?? weight)
              .clamp(0, weight)
              .toDouble();
      String? optional(StockColumn col) {
        final v = cell(col);
        return v.isEmpty ? null : v;
      }

      int? optionalInt(StockColumn col) =>
          parseNumber(cell(col))?.round();

      final spool = SpoolInventoryItem(
        id: '${baseTs}_import_$r',
        brand: cell(StockColumn.brand),
        material: material,
        colorName: cell(StockColumn.color),
        colorRgb: _parseColor(cell(StockColumn.colorHex)) ?? 0xFF9E9E9E,
        price: parseNumber(cell(StockColumn.price)) ?? 0,
        weight: weight,
        remainingWeight: remaining,
        addedDate: _parseDate(cell(StockColumn.addedDate)) ??
            (now ?? DateTime.now()),
        extruderTempMin: optionalInt(StockColumn.extruderTempMin),
        extruderTempMax: optionalInt(StockColumn.extruderTempMax),
        bedTempMin: optionalInt(StockColumn.bedTempMin),
        bedTempMax: optionalInt(StockColumn.bedTempMax),
        diameter: parseNumber(cell(StockColumn.diameter)),
        batchNumber: optional(StockColumn.batchNumber),
        location: optional(StockColumn.location),
        notes: optional(StockColumn.notes),
      );

      final sig = _signature(spool);
      final remainingDupes = existingSignatures[sig] ?? 0;
      if (remainingDupes > 0) {
        existingSignatures[sig] = remainingDupes - 1;
        duplicates++;
        continue;
      }
      spools.add(spool);
    }

    return SpoolImportResult(
      spools: spools,
      duplicates: duplicates,
      skippedRows: skipped,
    );
  }
}
