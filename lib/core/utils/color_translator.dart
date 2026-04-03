import 'package:flutter/material.dart';
import 'package:nfc_filament/l10n/app_localizations.dart';

/// Traduit un nom de couleur anglais vers la langue courante
String translateColorName(BuildContext context, String englishColorName) {
  final l10n = AppLocalizations.of(context)!;
  final colorKey = englishColorName.toLowerCase().trim();
  
  switch (colorKey) {
    case 'red':
      return l10n.red;
    case 'green':
      return l10n.green;
    case 'blue':
      return l10n.blue;
    case 'black':
      return l10n.black;
    case 'white':
      return l10n.white;
    case 'yellow':
      return l10n.yellow;
    case 'orange':
      return l10n.orange;
    case 'pink':
      return l10n.pink;
    case 'purple':
      return l10n.purple;
    case 'gray':
    case 'grey':
      return l10n.gray;
    case 'brown':
      return l10n.brown;
    case 'unknown':
      return l10n.unknown;
    default:
      // Si la couleur n'est pas reconnue, retourner telle quelle
      return englishColorName;
  }
}
