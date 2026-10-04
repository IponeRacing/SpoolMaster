// Export Excel / import CSV-Excel des bobines :
//  - aller-retour export → import (emplacement, notes, poids, prix, couleur)
//  - CSV de tableur européen (point-virgule, virgule décimale, BOM, guillemets)
//  - reconnaissance des en-têtes en plusieurs langues
//  - doublons ignorés, lignes sans matériau/poids ignorées, nouveaux ids
//  - liste de courses en texte

import 'dart:convert';

import 'package:excel/excel.dart' as xl;
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/models/spool_inventory_item.dart';
import 'package:nfc_filament/core/models/spool_usage_event.dart';
import 'package:nfc_filament/core/services/spool_export_service.dart';
import 'package:nfc_filament/core/services/spool_import_service.dart';

SpoolInventoryItem spool(
  String id, {
  String brand = 'Anycubic',
  String material = 'PLA',
  String color = 'White',
  int rgb = 0xFFFFFFFF,
  double weight = 1000,
  double remaining = 1000,
  double price = 20,
  String? location,
  String? notes,
}) =>
    SpoolInventoryItem(
      id: id,
      brand: brand,
      material: material,
      colorName: color,
      colorRgb: rgb,
      price: price,
      weight: weight,
      remainingWeight: remaining,
      addedDate: DateTime(2026, 9),
      location: location,
      notes: notes,
      extruderTempMin: 190,
      extruderTempMax: 230,
    );

const labels = SpoolExportLabels(
  stockSheet: 'Stock',
  shoppingSheet: 'Liste de courses',
  consumptionSheet: 'Consommation',
  columns: {
    StockColumn.brand: 'Marque',
    StockColumn.material: 'Matériau',
    StockColumn.color: 'Couleur',
    StockColumn.colorHex: 'Code couleur',
    StockColumn.initialWeight: 'Poids initial',
    StockColumn.remainingWeight: 'Poids restant',
    StockColumn.remainingPercent: 'Restant (%)',
    StockColumn.price: 'Prix',
    StockColumn.pricePerKg: 'Prix / kg',
    StockColumn.location: 'Emplacement',
    StockColumn.notes: 'Notes',
    StockColumn.addedDate: "Date d'ajout",
    StockColumn.extruderTempMin: 'Extrudeur min (°C)',
    StockColumn.extruderTempMax: 'Extrudeur max (°C)',
    StockColumn.bedTempMin: 'Plateau min (°C)',
    StockColumn.bedTempMax: 'Plateau max (°C)',
    StockColumn.diameter: 'Diamètre (mm)',
    StockColumn.batchNumber: 'Lot / SKU',
  },
  ordered: 'Commandé',
  date: 'Date',
  grams: 'Grammes',
  cost: 'Coût',
  shoppingListTitle: 'Liste de courses',
);

void main() {
  group('Export Excel', () {
    test('produit 3 feuilles avec en-têtes et une ligne par bobine', () {
      final bytes = SpoolExportService.buildWorkbook(
        stock: [
          spool('1', location: 'Étagère A', notes: 'Sécher 4h', remaining: 250),
          spool('2', material: 'PETG', color: 'Black', rgb: 0xFF000000),
        ],
        shoppingList: [spool('1', remaining: 250)],
        orderedIds: {'1'},
        usage: [
          SpoolUsageEvent(
            id: 'e1',
            spoolId: '1',
            date: DateTime(2026, 9, 10),
            grams: 750,
            brand: 'Anycubic',
            material: 'PLA',
            colorName: 'White',
            colorRgb: 0xFFFFFFFF,
            cost: 15,
          ),
        ],
        labels: labels,
        currency: 'CHF',
      );
      expect(bytes, isNotEmpty);

      final book = xl.Excel.decodeBytes(bytes);
      expect(book.tables.keys, containsAll(['Stock', 'Liste de courses', 'Consommation']));
      final stock = book.tables['Stock']!;
      expect(stock.maxRows, 3); // en-tête + 2 bobines
      final header = stock.rows.first.map((c) => c?.value.toString()).toList();
      expect(header.first, 'Marque');
      expect(header, contains('Prix (CHF)'));
      expect(header, contains('Poids restant (g)'));

      final shop = book.tables['Liste de courses']!;
      expect(shop.rows[1].last?.value.toString(), '✓');
    });

    test('pas de feuille Consommation sans historique', () {
      final bytes = SpoolExportService.buildWorkbook(
        stock: [spool('1')],
        shoppingList: const [],
        orderedIds: const {},
        usage: const [],
        labels: labels,
        currency: 'EUR',
      );
      final book = xl.Excel.decodeBytes(bytes);
      expect(book.tables.keys, isNot(contains('Consommation')));
    });

    test('noms de feuille invalides nettoyés (caractères interdits, 31 car.)', () {
      final bytes = SpoolExportService.buildWorkbook(
        stock: [spool('1')],
        shoppingList: const [],
        orderedIds: const {},
        usage: const [],
        labels: SpoolExportLabels(
          stockSheet: 'Stock/Inventaire: [très long nom de feuille ici]',
          shoppingSheet: 'Achats?',
          consumptionSheet: 'Conso',
          columns: {
            for (final c in StockColumn.values) c: c.name,
          },
          ordered: 'o',
          date: 'd',
          grams: 'g',
          cost: 'c',
          shoppingListTitle: 't',
        ),
        currency: 'EUR',
      );
      final book = xl.Excel.decodeBytes(bytes);
      for (final name in book.tables.keys) {
        expect(name.length, lessThanOrEqualTo(31));
        expect(name, isNot(contains(RegExp(r'[\[\]:*?/\\]'))));
      }
    });
  });

  group('Aller-retour export → import', () {
    test("le classeur exporté se ré-importe à l'identique, avec nouveaux ids", () {
      final original = [
        spool('a', location: 'Boîte sèche 2', notes: 'Pour pièces techniques', remaining: 420, price: 24.9),
        spool('b', brand: 'Bambu Lab', material: 'PETG', color: 'Red', rgb: 0xFFE53935),
      ];
      final bytes = SpoolExportService.buildWorkbook(
        stock: original,
        shoppingList: const [],
        orderedIds: const {},
        usage: const [],
        labels: labels,
        currency: 'CHF',
      );
      final rows = SpoolImportService.parseFile(bytes);
      final result = SpoolImportService.buildSpools(
        rows,
        existing: const [],
        appLabels: labels.columns,
        now: DateTime(2026, 10, 4),
      );

      expect(result.spools, hasLength(2));
      expect(result.duplicates, 0);
      final a = result.spools.first;
      expect(a.id, isNot('a'));
      expect(a.brand, 'Anycubic');
      expect(a.material, 'PLA');
      expect(a.remainingWeight, 420);
      expect(a.weight, 1000);
      expect(a.price, 24.9);
      expect(a.location, 'Boîte sèche 2');
      expect(a.notes, 'Pour pièces techniques');
      expect(a.extruderTempMin, 190);
      expect(a.addedDate, DateTime(2026, 9));
      final b = result.spools[1];
      expect(b.colorRgb & 0xFFFFFF, 0xE53935);
      expect(b.location, isNull);
    });

    test('ré-importer son propre export dans le même stock = tout en doublon', () {
      final stock = [spool('a'), spool('b', material: 'PETG')];
      final bytes = SpoolExportService.buildWorkbook(
        stock: stock,
        shoppingList: const [],
        orderedIds: const {},
        usage: const [],
        labels: labels,
        currency: 'CHF',
      );
      final result = SpoolImportService.buildSpools(
        SpoolImportService.parseFile(bytes),
        existing: stock,
        appLabels: labels.columns,
      );
      expect(result.spools, isEmpty);
      expect(result.duplicates, 2);
    });
  });

  group('Import CSV', () {
    test('CSV Excel européen : ; + virgule décimale + BOM + guillemets', () {
      const csv = '﻿Marque;Matériau;Couleur;Poids (g);Restant;Prix (€);Emplacement;Notes\r\n'
          'Prusament;PETG;Galaxy Black;1000;"812,5";29,90;Étagère B;"Imprimer à 240°C; ventilation 30%"\r\n'
          'Sunlu;PLA+;White;1 000;;19,99;;\r\n';
      final result = SpoolImportService.buildSpools(
        SpoolImportService.parseFile(utf8.encode(csv)),
        existing: const [],
      );
      expect(result.spools, hasLength(2));
      final p = result.spools.first;
      expect(p.brand, 'Prusament');
      expect(p.remainingWeight, 812.5);
      expect(p.price, 29.90);
      expect(p.location, 'Étagère B');
      expect(p.notes, 'Imprimer à 240°C; ventilation 30%');
      final s = result.spools[1];
      expect(s.weight, 1000);
      expect(s.remainingWeight, 1000, reason: 'restant vide = bobine pleine');
      expect(s.location, isNull);
    });

    test('en-têtes allemands / anglais reconnus, colonnes dans le désordre', () {
      const csv = 'Gewicht,Farbe,Hersteller,Werkstoff,Lagerort\n'
          '750,Blau,Elegoo,PLA,Regal 1\n';
      final result = SpoolImportService.buildSpools(
        SpoolImportService.parseCsv(csv),
        existing: const [],
      );
      expect(result.spools.single.brand, 'Elegoo');
      expect(result.spools.single.material, 'PLA');
      expect(result.spools.single.colorName, 'Blau');
      expect(result.spools.single.weight, 750);
      expect(result.spools.single.location, 'Regal 1');
    });

    test('« Restant » (poids) ne se confond pas avec « Restant (%) »', () {
      const csv = 'Marque;Matériau;Poids (g);Restant;Restant (%)\n'
          'A;ASA;1000;750;75\n';
      final result = SpoolImportService.buildSpools(
        SpoolImportService.parseCsv(csv),
        existing: const [],
        appLabels: labels.columns,
      );
      expect(result.spools.single.remainingWeight, 750);
      expect(
        SpoolImportService.normalizeHeader('Restant (%)'),
        isNot(SpoolImportService.normalizeHeader('Restant')),
      );
    });

    test('lignes sans matériau ou sans poids ignorées et comptées', () {
      const csv = 'brand,material,weight\n'
          'A,PLA,1000\n'
          'B,,1000\n'
          'C,PETG,\n'
          'D,ABS,abc\n';
      final result = SpoolImportService.buildSpools(
        SpoolImportService.parseCsv(csv),
        existing: const [],
      );
      expect(result.spools, hasLength(1));
      expect(result.skippedRows, 3);
    });

    test('fichier sans colonne matériau = rien importé', () {
      final result = SpoolImportService.buildSpools(
        SpoolImportService.parseCsv('foo,bar\n1,2\n'),
        existing: const [],
      );
      expect(result.spools, isEmpty);
      expect(result.skippedRows, 1);
    });

    test('deux lignes identiques dans le fichier = deux bobines', () {
      const csv = 'brand;material;color;weight\nA;PLA;Red;1000\nA;PLA;Red;1000\n';
      final result = SpoolImportService.buildSpools(
        SpoolImportService.parseCsv(csv),
        existing: const [],
      );
      expect(result.spools, hasLength(2));
      expect(result.spools[0].id, isNot(result.spools[1].id));
    });

    test('parseNumber tolère les formats courants', () {
      expect(SpoolImportService.parseNumber('1 000,50'), 1000.5);
      expect(SpoolImportService.parseNumber('1,000.50'), 1000.5);
      expect(SpoolImportService.parseNumber('25 €'), 25);
      expect(SpoolImportService.parseNumber('1000g'), 1000);
      expect(SpoolImportService.parseNumber('1,000'), 1000);
      expect(SpoolImportService.parseNumber('0,75'), 0.75);
      expect(SpoolImportService.parseNumber(''), isNull);
    });
  });

  group('Liste de courses en texte', () {
    test('regroupe les identiques, exclut les commandés', () {
      final text = SpoolExportService.buildShoppingListText(
        shoppingList: [
          spool('1'),
          spool('2'),
          spool('3', material: 'PETG', color: 'Black'),
          spool('4', brand: 'Sunlu'),
        ],
        orderedIds: {'4'},
        title: 'Liste de courses',
      );
      expect(text, 'Liste de courses\n☐ 2× Anycubic · PLA · White\n☐ Anycubic · PETG · Black');
    });
  });
}
