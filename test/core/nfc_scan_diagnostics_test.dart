// Détection des NTAG vierges (error_detail = BLANK_TAG), sur des dumps réels
// remontés en production (scans « Tag NFC vide ou non compatible », 09.2026).

import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_filament/core/services/nfc_scan_diagnostics.dart';

List<int> hex(String s) =>
    s.split(' ').where((x) => x.isNotEmpty).map((x) => int.parse(x, radix: 16)).toList();

// Pages 0-3 : UID + Capability Container NTAG213 (e1 10 12 00).
const header = '53 96 93 de 4b 03 00 01 49 48 00 00 e1 10 12 00';

void main() {
  group('looksBlank', () {
    test('Lock Control TLV puis NDEF vide → vierge', () {
      expect(NfcScanDiagnostics.looksBlank(hex('$header 01 03 a0 0c 34 03 00 fe 00 00 00 00')), isTrue);
    });

    test('NDEF vide seul → vierge', () {
      expect(NfcScanDiagnostics.looksBlank(hex('$header 03 00 fe 00 00 00 00 00')), isTrue);
    });

    test('zone utilisateur à zéro → vierge', () {
      expect(NfcScanDiagnostics.looksBlank(hex('$header 00 00 00 00 00 00 00 00')), isTrue);
    });

    test('NDEF avec contenu → pas vierge', () {
      expect(NfcScanDiagnostics.looksBlank(hex('$header 03 0b d1 01 07 55 04 61 62 63 2e 63 68 fe')), isFalse);
    });

    test('magic ACE (0x7B) en page 4 → pas vierge', () {
      expect(NfcScanDiagnostics.looksBlank(hex('$header 7b 00 65 00 34 03 00 fe 00 00 00 00')), isFalse);
    });

    test('lecture trop courte → indéterminé (faux)', () {
      expect(NfcScanDiagnostics.looksBlank(hex(header)), isFalse);
    });
  });

  test('updateFromNativeError garde le code natif et lit les diagnostics', () {
    NfcScanDiagnostics.reset();
    NfcScanDiagnostics.updateFromNativeError('EMPTY_READ', {
      'read_attempts': 3,
      'tag_tech': 'NfcA,MifareUltralight',
      'tag_detect_delay_ms': 420,
    });
    expect(NfcScanDiagnostics.nativeErrorCode, 'EMPTY_READ');
    expect(NfcScanDiagnostics.readAttempts, 3);
    expect(NfcScanDiagnostics.tagTech, 'NfcA,MifareUltralight');
    expect(NfcScanDiagnostics.detectDelayMs, 420);
    NfcScanDiagnostics.reset();
    expect(NfcScanDiagnostics.nativeErrorCode, isNull);
  });

  // Prod 05.10.2026 : « Tag is not connected » (lecture) journalisé avec
  // SESSION_TERMINATED, le code de l'auto-détection de secours.
  test('snapshot / restore : le secours raté ne remplace plus le premier échec', () {
    NfcScanDiagnostics.reset();
    NfcScanDiagnostics.updateFromNativeError('READ_ERROR', {'tag_tech': 'MiFareUnknown'});
    final first = NfcScanDiagnostics.snapshot();
    NfcScanDiagnostics.nativeErrorCode = null;
    NfcScanDiagnostics.updateFromNativeError('SESSION_TERMINATED', {'tag_tech': 'ISO15693'});

    final fallbackCode = NfcScanDiagnostics.nativeErrorCode;
    NfcScanDiagnostics.restore(first);
    NfcScanDiagnostics.fallbackNativeErrorCode = fallbackCode;

    expect(NfcScanDiagnostics.nativeErrorCode, 'READ_ERROR');
    expect(NfcScanDiagnostics.tagTech, 'MiFareUnknown');
    expect(NfcScanDiagnostics.fallbackNativeErrorCode, 'SESSION_TERMINATED');
    NfcScanDiagnostics.reset();
    expect(NfcScanDiagnostics.fallbackNativeErrorCode, isNull);
  });
}
