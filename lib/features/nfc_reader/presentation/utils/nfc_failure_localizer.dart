import 'package:flutter/material.dart';
import 'package:nfc_filament/features/nfc_reader/presentation/bloc/nfc_reader_state.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

/// Retourne un message localisé pour un échec NFC.
/// Le message brut de [NfcReaderFailure.message] (souvent technique et non
/// traduit) est réservé aux logs/télémétrie.
String localizedNfcFailureMessage(
  BuildContext context,
  NfcReaderFailure state, {
  bool isWrite = false,
}) {
  final l10n = AppLocalizations.of(context)!;
  switch (state.failureType) {
    case NfcFailureType.tagNotDetected:
      return l10n.nfcTagNotDetected;
    case NfcFailureType.incompatibleTag:
      return l10n.nfcTagIncompatible;
    case NfcFailureType.authError:
      return l10n.nfcAuthError;
    case NfcFailureType.nfcDisabled:
      return l10n.nfcDisabledMessage;
    case NfcFailureType.tagMoved:
      return l10n.tagMovedMessage;
    case NfcFailureType.readError:
      return isWrite ? l10n.writeError : l10n.errorReadingNfc;
  }
}
