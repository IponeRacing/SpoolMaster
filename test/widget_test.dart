// Smoke test minimal : vérifie que le boilerplate de test compile.
// Le test compteur par défaut de Flutter a été retiré (l'app n'est pas
// un compteur ; MyApp nécessite l'init des services natifs/DI).
// Les vrais tests sont dans test/features/ et test/core/.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MaterialApp smoke test', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Spool Master'))),
    );
    expect(find.text('Spool Master'), findsOneWidget);
  });
}
