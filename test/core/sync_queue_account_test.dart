// La file de retry de la sync est commune à l'appareil : après un changement
// de compte, les opérations du compte précédent ne doivent PAS partir vers le
// nouveau (elles attendent le retour de leur compte).

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/services/sync_queue_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_session.dart';

void switchAccountKeepingPrefs(String userId) {
  fakeSecureStorage['user_data'] = jsonEncode({
    'user_id': userId,
    'email': '$userId@example.com',
    'name': 'Test',
    'provider': 'apple',
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(installFakeSecureStorage);

  test('les opérations du compte A ne sont pas rejouées pour le compte B', () async {
    await signIn(userId: 'A');
    await SyncQueueService.enqueueUpsert('spool-a', {'spool_id': 'spool-a'});
    expect((await SyncQueueService.loadForCurrentUser()).map((o) => o['spoolId']), ['spool-a']);

    switchAccountKeepingPrefs('B');
    await SyncQueueService.enqueueDelete('spool-b');
    expect((await SyncQueueService.loadForCurrentUser()).map((o) => o['spoolId']), ['spool-b']);
    // La file garde les deux : l'op de A attend le retour de A.
    expect(await SyncQueueService.pendingCount(), 2);

    switchAccountKeepingPrefs('A');
    expect((await SyncQueueService.loadForCurrentUser()).map((o) => o['spoolId']), ['spool-a']);
  });

  test('une op ancienne sans userId compte pour le compte courant', () async {
    await signIn(userId: 'A');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sync_pending_ops_v1', jsonEncode([
      {'type': 'upsert', 'spoolId': 'legacy', 'payload': <String, dynamic>{}, 'attempts': 0},
    ]));
    expect((await SyncQueueService.loadForCurrentUser()).map((o) => o['spoolId']), ['legacy']);
  });
}
