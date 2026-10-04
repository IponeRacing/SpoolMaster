// Préférences :
//  - seuil de stock bas toujours borné entre 5 et 50 % (l'ancien défaut
//    serveur, 100, passait tout le stock en « bas ») ;
//  - une valeur serveur null (jamais envoyée) ou hors bornes n'écrase pas la
//    valeur locale (langue, devise, seuil).

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nfc_filament/core/services/user_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(installFakeSecureStorage);

  group('getLowStockThreshold (lecture locale)', () {
    Future<int> readWith(Object? stored) async {
      SharedPreferences.setMockInitialValues({
        'low_stock_threshold': ?stored,
      });
      return UserPreferencesService.getLowStockThreshold();
    }

    test('défaut 20 %', () async => expect(await readWith(null), 20));
    test('valeur valide inchangée', () async => expect(await readWith(35), 35));
    test('100 (ancien défaut serveur) → 50', () async => expect(await readWith(100), 50));
    test('trop bas → 5', () async => expect(await readWith(0), 5));

    test('setLowStockThreshold borne aussi à l’écriture', () async {
      SharedPreferences.setMockInitialValues({});
      await UserPreferencesService.setLowStockThreshold(80);
      expect(await UserPreferencesService.getLowStockThreshold(), 50);
    });
  });

  group('lowStockThresholdFromServer', () {
    test('null / absent / illisible → garder le local', () {
      expect(UserPreferencesService.lowStockThresholdFromServer(null), isNull);
      expect(UserPreferencesService.lowStockThresholdFromServer('abc'), isNull);
      expect(UserPreferencesService.lowStockThresholdFromServer(true), isNull);
    });

    test('hors bornes (défaut serveur 100) → garder le local', () {
      expect(UserPreferencesService.lowStockThresholdFromServer(100), isNull);
      expect(UserPreferencesService.lowStockThresholdFromServer(4), isNull);
      expect(UserPreferencesService.lowStockThresholdFromServer(51), isNull);
    });

    test('valeur valide (int, double, texte)', () {
      expect(UserPreferencesService.lowStockThresholdFromServer(5), 5);
      expect(UserPreferencesService.lowStockThresholdFromServer(30), 30);
      expect(UserPreferencesService.lowStockThresholdFromServer(25.0), 25);
      expect(UserPreferencesService.lowStockThresholdFromServer('45'), 45);
      expect(UserPreferencesService.lowStockThresholdFromServer(50), 50);
    });
  });

  group('loadPreferencesFromBackend', () {
    Future<void> load(Map<String, Object?> data) => http.runWithClient(
          UserPreferencesService.loadPreferencesFromBackend,
          () => MockClient(
            (_) async => http.Response(jsonEncode({'success': true, 'data': data}), 200),
          ),
        );

    setUp(() => signIn(extraPrefs: {
          'user_language': 'de',
          'user_currency': 'EUR',
          'user_units': 'metric',
          'low_stock_threshold': 15,
        }));

    test('null partout → rien n’est écrasé', () async {
      await load({
        'language': null,
        'currency': null,
        'units': null,
        'low_stock_threshold': null,
      });
      expect(await UserPreferencesService.getLanguage(), 'de');
      expect(await UserPreferencesService.getCurrency(), 'EUR');
      expect(await UserPreferencesService.getUnits(), 'metric');
      expect(await UserPreferencesService.getLowStockThreshold(), 15);
    });

    test('seuil serveur 100 ignoré, autres valeurs appliquées', () async {
      await load({
        'language': 'it',
        'currency': 'CHF',
        'units': 'imperial',
        'low_stock_threshold': 100,
      });
      expect(await UserPreferencesService.getLanguage(), 'it');
      expect(await UserPreferencesService.getCurrency(), 'CHF');
      expect(await UserPreferencesService.getUnits(), 'imperial');
      expect(await UserPreferencesService.getLowStockThreshold(), 15);
    });

    test('seuil serveur valide appliqué', () async {
      await load({'low_stock_threshold': 40});
      expect(await UserPreferencesService.getLowStockThreshold(), 40);
      expect(await UserPreferencesService.getLanguage(), 'de');
    });
  });
}
