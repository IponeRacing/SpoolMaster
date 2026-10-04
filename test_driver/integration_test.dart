// Driver des tests E2E (flutter drive) : enregistre les captures d'écran
// prises par binding.takeScreenshot() dans $E2E_SHOTS (défaut
// build/e2e_screenshots) pour vérifier les mises en page par appareil.
import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      final dir = Platform.environment['E2E_SHOTS'] ?? 'build/e2e_screenshots';
      final file = File('$dir/$name.png');
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      return true;
    },
  );
}
