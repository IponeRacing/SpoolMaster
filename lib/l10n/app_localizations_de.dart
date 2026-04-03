// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Lager';

  @override
  String get statistics => 'Analytik';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'NFC-Chip lesen';

  @override
  String get scanHistory => 'Verlauf';

  @override
  String get writeNfcChip => 'NFC-Chip schreiben';

  @override
  String get nfcNotAvailable => 'NFC nicht verfügbar';

  @override
  String get nfcNotAvailableDesc =>
      'Ihr Gerät unterstützt kein NFC oder es ist deaktiviert.';

  @override
  String get nfcNotSupported => 'NFC auf diesem Gerät nicht unterstützt';

  @override
  String get approachNfcChip => 'Nähern Sie sich einem NFC-Chip...';

  @override
  String get scanningNfc => 'Scannen...';

  @override
  String get nfcDataRead => 'NFC-Daten erfolgreich gelesen!';

  @override
  String get errorReadingNfc => 'Fehler beim Lesen des NFC';

  @override
  String get scanHistoryTitle => 'Scan-Verlauf';

  @override
  String get noScansRecorded => 'Keine Scans aufgezeichnet';

  @override
  String get scansWillAppearHere =>
      'NFC-Scans werden hier automatisch angezeigt';

  @override
  String get clearAll => 'Alles löschen';

  @override
  String get deleteThisScan => 'Diesen Scan löschen?';

  @override
  String get actionIrreversible => 'Diese Aktion ist unwiderruflich.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get clearAllHistory => 'Gesamten Verlauf löschen?';

  @override
  String get allScansWillBeDeleted =>
      'Alle Scans werden gelöscht. Diese Aktion ist unwiderruflich.';

  @override
  String get scanDeleted => 'Scan gelöscht';

  @override
  String get scanDetails => 'Scan-Details';

  @override
  String scannedOn(Object date) {
    return 'Gescannt am $date';
  }

  @override
  String get bobbinInformation => 'Spulen-Informationen';

  @override
  String get filamentType => 'Filamenttyp';

  @override
  String get color => 'Farbe';

  @override
  String get weight => 'Gewicht';

  @override
  String get manufacturingDate => 'Herstellungsdatum';

  @override
  String get batchNumber => 'Chargennummer';

  @override
  String get printerSettings => 'Druckereinstellungen';

  @override
  String get scanMetadata => 'Scan-Metadaten';

  @override
  String get scanId => 'Scan-ID';

  @override
  String get dateAndTime => 'Datum und Uhrzeit';

  @override
  String get reuseThisData => 'Diese Daten wiederverwenden';

  @override
  String get writeToNfc => 'Auf NFC schreiben';

  @override
  String get writeDataToChip => 'Daten auf Chip schreiben';

  @override
  String get writeSuccess => 'Erfolgreich geschrieben!';

  @override
  String get writeError => 'Schreibfehler';

  @override
  String get brand => 'Marke';

  @override
  String get selectBrand => 'Marke auswählen';

  @override
  String get materialType => 'Materialtyp';

  @override
  String get selectMaterial => 'Material auswählen';

  @override
  String get serialNumber => 'Seriennummer';

  @override
  String get serialNumberHint => 'z.B.: 001';

  @override
  String get initialWeight => 'Anfangsgewicht';

  @override
  String get initialWeightHint => 'z.B.: 1000';

  @override
  String get extruderTempMin => 'Extruder Temp Min';

  @override
  String get extruderTempMax => 'Extruder Temp Max';

  @override
  String get bedTempMin => 'Bett Temp Min';

  @override
  String get bedTempMax => 'Bett Temp Max';

  @override
  String get diameter => 'Filament Durchmesser';

  @override
  String get spoolLength => 'Spulenlänge';

  @override
  String get generatedSku => 'Generierte SKU';

  @override
  String get approachChipToWrite => 'Chip zum Schreiben annähern...';

  @override
  String get writing => 'Schreiben...';

  @override
  String get chooseColor => 'Farbe wählen';

  @override
  String get required => 'Erforderlich';

  @override
  String get invalid => 'Ungültig';

  @override
  String get advancedSettings => 'Erweiterte Einstellungen';

  @override
  String get opacity => 'Deckkraft';

  @override
  String get validate => 'Bestätigen';

  @override
  String get nfcTagInfo =>
      'Verwenden Sie einen leeren ISO14443A-NFC-Tag (NTAG213), um Ihre eigenen Anycubic-Tags zu erstellen.';

  @override
  String get stockInventory => 'Spulen auf Lager';

  @override
  String get addSpool => 'Spule hinzufügen';

  @override
  String get scanSpool => 'Spule scannen';

  @override
  String get addManually => 'Manuell hinzufügen';

  @override
  String get spoolAdded => 'Spule hinzugefügt';

  @override
  String get spoolUpdated => 'Spule aktualisiert';

  @override
  String get noSpoolsInStock => 'Keine Spulen auf Lager';

  @override
  String get addFirstSpool =>
      'Fügen Sie Ihre erste Spule hinzu, um Ihr Inventar zu verfolgen';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count Spule(n) mit niedrigem Bestand (< $threshold%)';
  }

  @override
  String get edit => 'Bearbeiten';

  @override
  String get bobbinPrice => 'Spulenpreis';

  @override
  String get price => 'Preis';

  @override
  String get priceHint => 'z.B.: 25.00';

  @override
  String get save => 'Speichern';

  @override
  String get spoolDetails => 'Spulendetails';

  @override
  String get deleteThisSpool => 'Diese Spule löschen?';

  @override
  String get cannotBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get addSpoolManually => 'Spule manuell hinzufügen';

  @override
  String get editSpool => 'Spule bearbeiten';

  @override
  String get customBrand => 'Benutzerdefinierte Marke';

  @override
  String get customBrandHint => 'z.B.: Meine Marke';

  @override
  String get chooseFromList => 'Aus Liste wählen';

  @override
  String get addBrand => '+ Marke hinzufügen';

  @override
  String get customMaterial => 'Benutzerdefiniertes Material';

  @override
  String get customMaterialHint => 'z.B.: Mein Material';

  @override
  String get addMaterial => '+ Material hinzufügen';

  @override
  String get colorHint => 'z.B.: Blau, Rot...';

  @override
  String get enterColor => 'Bitte geben Sie eine Farbe ein';

  @override
  String get initialWeightG => 'Anfangsgewicht';

  @override
  String get remainingWeightG => 'Restgewicht';

  @override
  String get enterBrand => 'Bitte geben Sie eine Marke ein';

  @override
  String get selectOrEnterBrand => 'Bitte wählen oder geben Sie eine Marke ein';

  @override
  String get enterMaterial => 'Bitte geben Sie ein Material ein';

  @override
  String get selectOrEnterMaterial =>
      'Bitte wählen oder geben Sie ein Material ein';

  @override
  String get enterPrice => 'Bitte geben Sie einen Preis ein';

  @override
  String get enterValidPrice => 'Bitte geben Sie einen gültigen Preis ein';

  @override
  String get enterWeight => 'Bitte geben Sie ein Gewicht ein';

  @override
  String get enterValidWeight => 'Bitte geben Sie ein gültiges Gewicht ein';

  @override
  String get remainingCannotExceedTotal =>
      'Das Restgewicht kann das Gesamtgewicht nicht überschreiten';

  @override
  String get overview => 'Übersicht';

  @override
  String get spoolsInStock => 'Spulen auf Lager';

  @override
  String get totalValue => 'Gesamtwert';

  @override
  String get lowStockSpools => 'Niedriger Bestand';

  @override
  String get materialDistribution => 'Verteilung nach Material';

  @override
  String get brandDistribution => 'Verteilung nach Marke';

  @override
  String get noData => 'Keine Daten';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get profileSettings => 'Profileinstellungen';

  @override
  String get preferences => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get french => 'Français';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get italian => 'Italiano';

  @override
  String get romanian => 'Română';

  @override
  String get hungarian => 'Magyar';

  @override
  String get greek => 'Ελληνικά';

  @override
  String get bulgarian => 'Български';

  @override
  String get croatian => 'Hrvatski';

  @override
  String get slovak => 'Slovenčina';

  @override
  String get slovenian => 'Slovenščina';

  @override
  String get serbian => 'Српски';

  @override
  String get ukrainian => 'Українська';

  @override
  String get danish => 'Dansk';

  @override
  String get norwegian => 'Norsk';

  @override
  String get finnish => 'Suomi';

  @override
  String get thai => 'ไทย';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get malay => 'Bahasa Melayu';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get currency => 'Währung';

  @override
  String get selectCurrency => 'Währung auswählen';

  @override
  String get units => 'Einheiten';

  @override
  String get selectUnits => 'Einheiten auswählen';

  @override
  String get metric => 'Metrisch (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Schwellenwert für niedrigen Bestand';

  @override
  String get lowStockThresholdDesc =>
      'Eine Spule wird als niedrig im Bestand betrachtet, wenn das Restgewicht unter diesem Prozentsatz liegt';

  @override
  String get authentication => 'Authentifizierung';

  @override
  String get signInWithGoogle => 'Mit Google anmelden';

  @override
  String get signInWithApple => 'Mit Apple anmelden';

  @override
  String get continueWithApple => 'Weiter mit Apple';

  @override
  String get continueWithGoogle => 'Weiter mit Google';

  @override
  String get comingSoon => 'Demnächst verfügbar';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get madeWith => 'Mit ❤️ für Anycubic 3D-Drucker gemacht';

  @override
  String get scanBobbinDirectly => 'Spule scannen';

  @override
  String get nfcEncoder => 'NFC-Encoder';

  @override
  String get length => 'Länge';

  @override
  String get tempExtruder => 'Extruder Temp.';

  @override
  String get tempBed => 'Bett Temp.';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get legal => 'Rechtliches';

  @override
  String get back => 'Zurück';

  @override
  String get retry => 'Wiederholen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get extruderTempMinHint => 'z.B.: 200';

  @override
  String get extruderTempMaxHint => 'z.B.: 220';

  @override
  String get bedTempMinHint => 'z.B.: 50';

  @override
  String get bedTempMaxHint => 'z.B.: 60';

  @override
  String get diameterHint => 'z.B.: 1.75';

  @override
  String get spoolLengthHint => 'z.B.: 330';

  @override
  String get tabGrid => 'Raster';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Schieberegler';

  @override
  String get hexCode => 'Hex-Code';

  @override
  String get red => 'Rot';

  @override
  String get green => 'Grün';

  @override
  String get blue => 'Blau';

  @override
  String get black => 'Schwarz';

  @override
  String get white => 'Weiß';

  @override
  String get yellow => 'Gelb';

  @override
  String get orange => 'Orange';

  @override
  String get pink => 'Rosa';

  @override
  String get purple => 'Lila';

  @override
  String get gray => 'Grau';

  @override
  String get brown => 'Braun';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get metricUnits => 'Metrisch (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Schweizer Franken (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'US-Dollar (\$)';

  @override
  String get gbp => 'Pfund Sterling (£)';

  @override
  String get cad => 'Kanadischer Dollar (CAD)';

  @override
  String get aud => 'Australischer Dollar (A\$)';

  @override
  String get jpy => 'Japanischer Yen (¥)';

  @override
  String get cny => 'Chinesischer Yuan (¥)';

  @override
  String get inr => 'Indische Rupie (₹)';

  @override
  String get brl => 'Brasilianischer Real (R\$)';

  @override
  String get mxn => 'Mexikanischer Peso (MX\$)';

  @override
  String get sek => 'Schwedische Krone (kr)';

  @override
  String get nok => 'Norwegische Krone (kr)';

  @override
  String get dkk => 'Dänische Krone (kr)';

  @override
  String get pln => 'Polnischer Zloty (zł)';

  @override
  String get czk => 'Tschechische Krone (Kč)';

  @override
  String get nzd => 'Neuseeland-Dollar (NZ\$)';

  @override
  String get filamentsToOrder => 'Zu bestellende Filamente';

  @override
  String get shoppingList => 'Einkaufsliste';

  @override
  String get addToShoppingList => 'Zur Liste hinzufügen';

  @override
  String get noLowStockFilaments => 'Keine Filamente mit niedrigem Bestand';

  @override
  String get vipSubscriptionDescription =>
      'Dieses Abonnement dient nur dazu, In-App-Werbung zu deaktivieren und das Projekt zu unterstützen. Keine weiteren Funktionen.';

  @override
  String get monthlySubscription => 'Monatsabonnement';

  @override
  String get yearlySubscription => 'Jahresabonnement';

  @override
  String get perMonth => '/ Monat';

  @override
  String get perYear => '/ Jahr';

  @override
  String onlyPerMonth(String price) {
    return 'Nur $price / Monat';
  }

  @override
  String get subscribe => 'Abonnieren';

  @override
  String get bestOffer => '✨ BESTES ANGEBOT ✨';

  @override
  String get forAnycubicAce => 'für Anycubic Ace';

  @override
  String get forBambuLabAms => 'für Bambu Lab AMS';

  @override
  String get scanNfcChip => 'NFC-Chip scannen';

  @override
  String get fillForm => 'Formular ausfüllen';

  @override
  String get emptyShoppingList => 'Keine Filamente in der Liste';

  @override
  String percentRemaining(String percent) {
    return '$percent% verbleibend';
  }

  @override
  String get markAsOrdered => 'Als bestellt markieren';

  @override
  String get markAsNotOrdered => 'Als nicht bestellt markieren';

  @override
  String get notSignedIn => 'Nicht angemeldet';

  @override
  String get signIn => 'Anmelden';

  @override
  String get connection => 'Anmeldung';

  @override
  String get signInToSync =>
      'Melden Sie sich an, um Ihre Daten zu synchronisieren';

  @override
  String get continueWithoutAccount => 'Ohne Konto fortfahren (lokaler Modus)';

  @override
  String get privacyNotice =>
      'Mit der Anmeldung akzeptieren Sie unsere\nNutzungsbedingungen und Datenschutzrichtlinie';

  @override
  String get updateStock => 'Bestand aktualisieren';

  @override
  String get scanToUpdateStock => 'Scannen zum Aktualisieren';

  @override
  String get weightUsed => 'Verbrauchtes Gewicht';

  @override
  String get lengthUsed => 'Verbrauchte Länge';

  @override
  String get enterWeightOrLength =>
      'Geben Sie das verbrauchte Gewicht oder die Länge ein';

  @override
  String get weightUsedG => 'Verbrauchtes Gewicht (g)';

  @override
  String get lengthUsedM => 'Verbrauchte Länge (m)';

  @override
  String get stockUpdated => 'Bestand aktualisiert';

  @override
  String get scanSpoolToUpdate =>
      'Scannen Sie eine Spule, um ihren Bestand zu aktualisieren';

  @override
  String get spoolNotFound => 'Spule nicht im Lager gefunden';

  @override
  String get addSpoolFirstMessage =>
      'Diese Spule ist noch nicht in Ihrem Lager. Bitte fügen Sie sie zuerst über die Schaltfläche \'Spule hinzufügen\' hinzu, bevor Sie ihren Bestand aktualisieren.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Nur Lesezugriff';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab Tags verwenden RSA-Verschlüsselung und können nicht geändert werden. Nur Lesezugriff.';

  @override
  String get forPrusaMk4 => 'für Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Lesen & Schreiben';

  @override
  String get prusaReadWriteDesc =>
      'Prusa Tags verwenden ISO 15693 (NFC-V) mit OpenPrintTag-Format. Lesen und Schreiben werden unterstützt.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab Klon-Bibliothek';

  @override
  String get noBambuClones => 'Keine Bambu Lab Klone';

  @override
  String get scanBambuToClone =>
      'Scannen Sie originale Bambu Lab Tags, um Ihre Klon-Bibliothek zu erstellen';

  @override
  String get scanTag => 'Tag scannen';

  @override
  String get syncWithCloud => 'Mit Cloud synchronisieren';

  @override
  String get syncCompleted => 'Synchronisierung abgeschlossen';

  @override
  String get deleteClone => 'Klon löschen';

  @override
  String get renameClone => 'Klon umbenennen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get customName => 'Benutzerdefinierter Name';

  @override
  String get clonedOn => 'Geklont am';

  @override
  String get writeThisClone => 'Diesen Klon schreiben';

  @override
  String get writeClone => 'Klon schreiben';

  @override
  String get writeOnCUID => 'Auf CUID-Karte schreiben';

  @override
  String get cloneWrittenSuccess => 'Klon erfolgreich geschrieben!';

  @override
  String get requiredTagFormat => 'Erforderliches Tag-Format';

  @override
  String get type => 'Typ';

  @override
  String get frequency => 'Frequenz';

  @override
  String get protocol => 'Protokoll';

  @override
  String get capacity => 'Kapazität';

  @override
  String get feature => 'Funktion';

  @override
  String get uidModifiable => 'Block 0 (UID) modifizierbar';

  @override
  String get whereToBuy =>
      'Suchen Sie nach \"CUID MiFare Classic 1K\" auf AliExpress, Amazon oder eBay (~0,50\$/Stück)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 Karte - MiFare Classic 1K mit beschreibbarem Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Suchen Sie nach \"Magic Gen2 MiFare Classic 1K\" oder \"UID writable\" auf AliExpress, Amazon oder eBay (~\$0.50/Stück)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Warnung: Das Schreiben mit iPhone NFC funktioniert möglicherweise nicht bei allen Magic Gen2 Karten. Ein Proxmark3-Gerät wird für maximale Zuverlässigkeit empfohlen.';

  @override
  String get step1GetMagicGen2 =>
      'Besorgen Sie eine leere Magic Gen2 Karte (MiFare Classic 1K mit beschreibbarer UID)';

  @override
  String get instructions => 'Anleitung';

  @override
  String get step1GetCUID =>
      'Besorgen Sie eine leere CUID-Karte (MiFare Classic 1K)';

  @override
  String get step2PressWrite =>
      'Drücken Sie die Schaltfläche \"Schreiben\" unten';

  @override
  String get step3HoldPhone =>
      'Halten Sie Ihr iPhone in die Nähe der CUID-Karte';

  @override
  String get step4WaitConfirm => 'Warten Sie auf die Schreibbestätigung';

  @override
  String get step5TestClone =>
      'Testen Sie den geklonten Tag auf Ihrem Bambu Lab Drucker!';

  @override
  String get rsaIncluded =>
      'Der Klon enthält die Original-RSA-Signatur, er wird vom Drucker akzeptiert!';

  @override
  String get cloneDeleted => 'Klon gelöscht';

  @override
  String get deleteAccount => 'Mein Konto löschen';

  @override
  String get deleteAccountConfirmation =>
      'Diese Aktion ist unwiderruflich. Ihr Konto und alle Daten werden innerhalb von 30 Tagen gelöscht.';

  @override
  String get accountDeletionRequested => 'Löschanfrage registriert';

  @override
  String get clearShoppingList => 'Liste leeren';

  @override
  String get clearShoppingListConfirmation =>
      'Möchten Sie die gesamte Einkaufsliste wirklich leeren? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Verlauf';

  @override
  String get retryButton => 'Erneut versuchen';

  @override
  String get readSuccessMessage => 'Erfolgreich gelesen!';

  @override
  String get filamentTypeLabel => 'Filamenttyp';

  @override
  String get scanNfcChipButton => 'NFC-Chip scannen';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Klon \"$name\" löschen?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klon \"$name\" gelöscht';
  }

  @override
  String get extruderLabel => 'Extruder';

  @override
  String get writeThisCloneButton => 'Diesen Klon schreiben';

  @override
  String get customNameHint => 'Benutzerdefinierter Name';

  @override
  String get cloneWriteSuccessMessage => 'Klon erfolgreich geschrieben!';

  @override
  String errorPrefix(String error) {
    return 'Fehler: $error';
  }

  @override
  String get writingInProgress => 'Schreiben...';

  @override
  String get writeOnCUIDButton => 'Auf CUID-Karte schreiben';

  @override
  String get diameterLabel => 'Durchmesser';

  @override
  String get extruderTempLabel => 'Extruder-Temperatur';

  @override
  String get bedTempLabel => 'Bett-Temperatur';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K Bytes (1024 Bytes)';

  @override
  String get rsaSignatureNote =>
      'Der Klon enthält die Original-RSA-Signatur, er wird vom Drucker akzeptiert!';

  @override
  String get writeBambuLabTagTitle => 'Bambu Lab Tag schreiben';

  @override
  String get bambuLabTagWriteSuccess =>
      'Bambu Lab Tag erfolgreich geschrieben!';

  @override
  String get approachNfcTagMessage => 'NFC-Tag annähern...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab Format (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab Format';

  @override
  String get bambuLabFormatInfo =>
      'Dieses Format verwendet Bambu Lab Materialcodes und speichert Daten in einem AMS-kompatiblen Format.';

  @override
  String get brandLabel => 'Marke';

  @override
  String get materialTypeLabel => 'Materialtyp';

  @override
  String get serialNumber3Digits => 'Seriennummer (3 Ziffern)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (Standard)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Bambu Lab Tag schreiben';

  @override
  String get bambuLabRsaNote =>
      'Hinweis: Original Bambu Lab Tags verwenden RSA-Verschlüsselung. Dieser Modus schreibt Daten in einem vereinfachten kompatiblen Format.';

  @override
  String signInError(String error) {
    return 'Anmeldefehler: $error';
  }

  @override
  String get subscriptionActivatedMessage =>
      'Abonnement erfolgreich aktiviert!';

  @override
  String get subscriptionFailedMessage => 'Abonnement fehlgeschlagen';

  @override
  String errorMessage(String error) {
    return 'Fehler: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      'Abonnement erfolgreich wiederhergestellt!';

  @override
  String get noSubscriptionFoundMessage => 'Kein Abonnement gefunden';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTIV';

  @override
  String get noAdsExperienceMessage => 'Sie genießen das werbefreie Erlebnis!';

  @override
  String get subscribedLabel => 'Abonniert';

  @override
  String get restorePurchasesButton => 'Käufe wiederherstellen';

  @override
  String get cannotExceedRemainingWeight =>
      'Kann das Restgewicht nicht überschreiten';

  @override
  String get pleaseEnterLength => 'Bitte Länge eingeben';

  @override
  String get pleaseEnterValidLength => 'Bitte gültige Länge eingeben';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Spulenlänge nicht festgelegt - Umrechnung nicht möglich';

  @override
  String get exceedsRemainingWeight => 'Überschreitet Restgewicht';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament =>
      'Helfen Sie uns, dieses Filament zu identifizieren';

  @override
  String get helpUsImprove => 'Helfen Sie uns, uns zu verbessern!';

  @override
  String get helpIdentifyDescription =>
      'Wir haben den Chip gelesen, konnten ihn aber nicht identifizieren. Sagen Sie uns, welches Filament es ist, damit wir die App verbessern können.';

  @override
  String get otherBrand => 'Andere';

  @override
  String get thankYouFeedback => 'Vielen Dank für Ihr Feedback!';

  @override
  String get send => 'Senden';

  @override
  String get optionalDetails => 'Optionale Details';

  @override
  String get weightGrams => 'Gewicht (g)';

  @override
  String get diameterMm => 'Durchmesser (mm)';

  @override
  String get spoolLengthM => 'Spulenlänge (m)';

  @override
  String get batchNumberLabel => 'Charge / SKU';

  @override
  String get contactUs => 'Kontaktieren Sie uns';

  @override
  String get contactUsSubtitle => 'Fragen, Vorschläge oder Probleme';

  @override
  String get nfcTagNotDetected => 'Kein NFC-Tag erkannt';

  @override
  String get nfcTagNotDetectedDesc =>
      'Es wurde kein Tag gefunden. Der Tag ist möglicherweise defekt, beschädigt oder zu weit vom Telefon entfernt. Legen Sie die Oberseite Ihres iPhones direkt auf den NFC-Tag.';

  @override
  String get nfcTagIncompatible => 'Inkompatibles NFC-Tag erkannt';

  @override
  String get nfcTagInfoPrusa =>
      'Verwenden Sie einen leeren NXP ICODE SLIX2-Tag (ISO 15693), um OpenPrintTag-kompatible Tags für Prusa MK4/XL zu erstellen.';

  @override
  String get writePrusaTagTitle => 'Prusa OpenPrintTag schreiben';
}
