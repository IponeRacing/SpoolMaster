// NFC côté Dart :
//  - écriture Anycubic : pages envoyées au natif en List<int> (jamais en
//    Uint8List, que le natif ignorait), page 3 (CC, OTP) jamais réécrite ;
//  - bloc : l'annulation arrête la session native ; un 2e scan pendant un
//    scan en cours est ignoré ;
//  - bibliothèque de clones : une relecture du même tag ne crée pas de
//    doublon.

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nfc_filament/core/errors/failures.dart';
import 'package:nfc_filament/core/services/cloned_tags_storage_service.dart';
import 'package:nfc_filament/features/nfc_reader/data/datasources/nfc_datasource_impl.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/bobbin_data_model.dart';
import 'package:nfc_filament/features/nfc_reader/data/models/cloned_tag_model.dart';
import 'package:nfc_filament/features/nfc_reader/domain/entities/bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/check_nfc_availability.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_bobbin_data_auto_detect.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/read_nfc_tag.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/save_scan_to_history.dart';
import 'package:nfc_filament/features/nfc_reader/domain/usecases/write_bobbin_data.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_bloc.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _channel = MethodChannel('com.anycubic.nfc/native');

class _MockCheck extends Mock implements CheckNfcAvailability {}

class _MockReadTag extends Mock implements ReadNfcTag {}

class _MockRead extends Mock implements ReadBobbinData {}

class _MockWrite extends Mock implements WriteBobbinData {}

class _MockSave extends Mock implements SaveScanToHistory {}

class _MockAuto extends Mock implements ReadBobbinDataAutoDetect {}

ClonedTagModel clone(Map<int, List<int>> blocks, {String id = '1', String? name}) =>
    ClonedTagModel(
      id: id,
      clonedAt: DateTime(2026, 10, int.parse(id)),
      bobbinData: const BobbinData(filamentType: 'PLA', color: 'Black', weightGrams: 1000),
      rawBlocks: blocks,
      customName: name,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
      calls.add(call);
      return true;
    });
  });

  group('writeBobbinData (Anycubic)', () {
    Future<List<Map<Object?, Object?>>> writtenPages(String sku) async {
      await NfcDataSourceImpl().writeBobbinData(
        BobbinDataModel(
          filamentType: 'PLA High Speed',
          color: 'White',
          weightGrams: 1000,
          batchNumber: sku,
          colorRgb: 0xFFFFFF,
        ),
      );
      final call = calls.singleWhere((c) => c.method == 'startWriteSession');
      final args = call.arguments as Map<Object?, Object?>;
      return (args['pages']! as List<Object?>).cast<Map<Object?, Object?>>();
    }

    for (final sku in ['AHPLBW-107', 'SKU-LONGER-THAN-16-CHARS']) {
      test('SKU "$sku" : toutes les pages en List<int> de 4 octets', () async {
        final pages = await writtenPages(sku);
        for (final page in pages) {
          // Le codec du canal garde le type : un Uint8List arrive en byte[]
          // côté natif (ignoré), une liste ordinaire en liste de nombres.
          final data = page['data'];
          expect(data, isNot(isA<Uint8List>()), reason: 'page ${page['page']}');
          expect(data, isA<List<Object?>>());
          expect((data! as List<Object?>).whereType<int>(), hasLength(4));
        }
        // SKU (pages 5-8) bien présent
        expect(pages.map((p) => p['page']), containsAll(<int>[5, 6, 7, 8]));
      });
    }

    test('page 3 (CC, OTP) jamais réécrite', () async {
      final pages = await writtenPages('AHPLBW-107');
      expect(pages.map((p) => p['page']), isNot(contains(3)));
    });
  });

  group('NfcReaderBloc', () {
    late _MockRead read;
    late NfcReaderBloc bloc;

    setUp(() {
      read = _MockRead();
      bloc = NfcReaderBloc(
        checkNfcAvailability: _MockCheck(),
        readNfcTag: _MockReadTag(),
        readBobbinData: read,
        writeBobbinData: _MockWrite(),
        saveScanToHistory: _MockSave(),
        readBobbinDataAutoDetect: _MockAuto(),
      );
    });

    tearDown(() => bloc.close());

    test('annulation → stopSession natif appelé', () async {
      bloc.add(const StopNfcScanEvent());
      await pumpEventQueue();
      expect(calls.map((c) => c.method), contains('stopSession'));
    });

    test('double tap pendant un scan → un seul scan natif', () async {
      final pending = Completer<Either<Failure, BobbinData>>();
      when(() => read(nfcMode: any(named: 'nfcMode')))
          .thenAnswer((_) => pending.future);

      bloc
        ..add(const ReadBobbinDataEvent(entryPoint: 'home'))
        ..add(const ReadBobbinDataEvent(entryPoint: 'home'));
      await pumpEventQueue();
      expect(bloc.isSessionActive, isTrue);
      verify(() => read(nfcMode: any(named: 'nfcMode'))).called(1);

      // Fin du scan (annulé) → un nouveau scan est de nouveau accepté
      pending.complete(const Left(NfcSessionCancelledFailure()));
      await pumpEventQueue();
      expect(bloc.isSessionActive, isFalse);

      when(() => read(nfcMode: any(named: 'nfcMode')))
          .thenAnswer((_) async => const Left(NfcSessionCancelledFailure()));
      bloc.add(const ReadBobbinDataEvent(entryPoint: 'home'));
      await pumpEventQueue();
      verify(() => read(nfcMode: any(named: 'nfcMode'))).called(1);
    });
  });

  group('Clones Bambu : dédoublonnage', () {
    final uidA = {0: [0xA1, 0xB2, 0xC3, 0xD4, 0x99], 4: [1, 2, 3]};
    final uidB = {0: [0x11, 0x22, 0x33, 0x44, 0x55], 4: [1, 2, 3]};

    test('même UID → mis à jour, id / nom / date conservés, en tête', () {
      final first = clone(uidA, name: 'Mon PLA');
      final other = clone(uidB, id: '2');
      final reread = clone({...uidA, 4: [9, 9, 9]}, id: '3');

      final list = ClonedTagsStorageService.upsertClone([other, first], reread);
      expect(list.map((c) => c.id), ['1', '2']);
      expect(list.first.customName, 'Mon PLA');
      expect(list.first.clonedAt, first.clonedAt);
      expect(list.first.rawBlocks[4], [9, 9, 9]);
    });

    test('UID inconnu : dédoublonnage par contenu', () {
      final a = clone({4: [1, 2], 5: [3, 4]});
      final same = clone({5: [3, 4], 4: [1, 2]}, id: '2');
      final different = clone({4: [1, 2], 5: [3, 5]}, id: '3');
      expect(a.dedupKey, same.dedupKey);
      expect(a.dedupKey, isNot(different.dedupKey));
      expect(ClonedTagsStorageService.upsertClone([a], same), hasLength(1));
      expect(ClonedTagsStorageService.upsertClone([a], different), hasLength(2));
    });

    test('limite LRU respectée', () {
      final clones = [
        for (var i = 1; i <= 3; i++) clone({4: [i]}, id: '$i'),
      ];
      final list = ClonedTagsStorageService.upsertClone(
        clones,
        clone({4: [42]}, id: '4'),
        maxClones: 3,
      );
      expect(list.map((c) => c.id), ['4', '1', '2']);
    });

    test('sauvegarde : relecture du même tag = un seul clone', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
        (call) async => null,
      );
      await ClonedTagsStorageService.saveClonedTag(clone(uidA));
      await ClonedTagsStorageService.saveClonedTag(clone(uidA, id: '2'));
      expect(await ClonedTagsStorageService.getClonedTags(), hasLength(1));
    });
  });
}
