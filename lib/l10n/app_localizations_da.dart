// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Lager';

  @override
  String get statistics => 'Analyse';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Læs NFC chip';

  @override
  String get scanHistory => 'Historik';

  @override
  String get writeNfcChip => 'Skriv NFC chip';

  @override
  String get nfcNotAvailable => 'NFC er ikke tilgængelig';

  @override
  String get nfcNotAvailableDesc =>
      'Din enhed understøtter ikke NFC, eller den er deaktiveret.';

  @override
  String get nfcNotSupported => 'NFC understøttes ikke på denne enhed';

  @override
  String get approachNfcChip => 'Tilnærm en NFC chip...';

  @override
  String get scanningNfc => 'Scanner...';

  @override
  String get nfcDataRead => 'NFC data læst korrekt!';

  @override
  String get errorReadingNfc => 'Fejl ved læsning af NFC';

  @override
  String get scanHistoryTitle => 'Scanningshistorik';

  @override
  String get noScansRecorded => 'Ingen scanninger registreret';

  @override
  String get scansWillAppearHere => 'NFC scanninger vil vises her automatisk';

  @override
  String get clearAll => 'Ryd alle';

  @override
  String get deleteThisScan => 'Slet denne scanning?';

  @override
  String get actionIrreversible => 'Denne handling kan ikke fortrydes.';

  @override
  String get cancel => 'Annuller';

  @override
  String get delete => 'Slet';

  @override
  String get clearAllHistory => 'Ryd hele historikken?';

  @override
  String get allScansWillBeDeleted =>
      'Alle scanninger vil blive slettet. Denne handling kan ikke fortrydes.';

  @override
  String get scanDeleted => 'Scanning slettet';

  @override
  String get scanDetails => 'Scanningsdetaljer';

  @override
  String scannedOn(Object date) {
    return 'Scannet den $date';
  }

  @override
  String get bobbinInformation => 'Spoleinformation';

  @override
  String get filamentType => 'Filamenttype';

  @override
  String get color => 'Farve';

  @override
  String get weight => 'Vægt';

  @override
  String get manufacturingDate => 'Produktionsdato';

  @override
  String get batchNumber => 'Batchnummer';

  @override
  String get printerSettings => 'Printerindstillinger';

  @override
  String get scanMetadata => 'Scanningsmetadata';

  @override
  String get scanId => 'Scannings-ID';

  @override
  String get dateAndTime => 'Dato og tid';

  @override
  String get reuseThisData => 'Genbrug disse data';

  @override
  String get writeToNfc => 'Skriv til NFC';

  @override
  String get writeDataToChip => 'Skriv data til chip';

  @override
  String get writeSuccess => 'Skrivning lykkedes!';

  @override
  String get writeError => 'Skrivefejl';

  @override
  String get brand => 'Mærke';

  @override
  String get selectBrand => 'Vælg mærke';

  @override
  String get materialType => 'Materialetype';

  @override
  String get selectMaterial => 'Vælg materiale';

  @override
  String get serialNumber => 'Serienummer';

  @override
  String get serialNumberHint => 'f.eks.: 001';

  @override
  String get initialWeight => 'Begyndelsesvægt';

  @override
  String get initialWeightHint => 'f.eks.: 1000';

  @override
  String get extruderTempMin => 'Min. ekstrudértemp.';

  @override
  String get extruderTempMax => 'Maks. ekstrudértemp.';

  @override
  String get bedTempMin => 'Min. pladetemp.';

  @override
  String get bedTempMax => 'Maks. pladetemp.';

  @override
  String get diameter => 'Filamentdiameter';

  @override
  String get spoolLength => 'Spolelængde';

  @override
  String get generatedSku => 'Genereret SKU';

  @override
  String get approachChipToWrite => 'Tilnærm chip for at skrive...';

  @override
  String get writing => 'Skriver...';

  @override
  String get chooseColor => 'Vælg farve';

  @override
  String get required => 'Påkrævet';

  @override
  String get invalid => 'Ugyldig';

  @override
  String get advancedSettings => 'Avancerede indstillinger';

  @override
  String get opacity => 'Gennemsigtighed';

  @override
  String get validate => 'Bekræft';

  @override
  String get nfcTagInfo =>
      'Brug et tomt ISO14443A NFC tag (NTAG213) til at oprette dine egne Anycubic tags.';

  @override
  String get stockInventory => 'Spoler på lager';

  @override
  String get addSpool => 'Tilføj spole';

  @override
  String get scanSpool => 'Scan spole';

  @override
  String get addManually => 'Tilføj manuelt';

  @override
  String get spoolAdded => 'Spole tilføjet';

  @override
  String get spoolUpdated => 'Spole opdateret';

  @override
  String get noSpoolsInStock => 'Ingen spoler på lager';

  @override
  String get addFirstSpool =>
      'Tilføj din første spole for at begynde at spore dit lager';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count spole(r) med lavt lager (< $threshold%)';
  }

  @override
  String get edit => 'Rediger';

  @override
  String get bobbinPrice => 'Spolepris';

  @override
  String get price => 'Pris';

  @override
  String get priceHint => 'f.eks.: 25.00';

  @override
  String get save => 'Gem';

  @override
  String get spoolDetails => 'Spoledetaljer';

  @override
  String get deleteThisSpool => 'Slet denne spole?';

  @override
  String get cannotBeUndone => 'Denne handling kan ikke fortrydes.';

  @override
  String get addSpoolManually => 'Tilføj spole manuelt';

  @override
  String get editSpool => 'Rediger spole';

  @override
  String get customBrand => 'Brugerdefineret mærke';

  @override
  String get customBrandHint => 'f.eks.: Mit mærke';

  @override
  String get chooseFromList => 'Vælg fra liste';

  @override
  String get addBrand => '+ Tilføj mærke';

  @override
  String get customMaterial => 'Brugerdefineret materiale';

  @override
  String get customMaterialHint => 'f.eks.: Mit materiale';

  @override
  String get addMaterial => '+ Tilføj materiale';

  @override
  String get colorHint => 'f.eks.: Blå, Rød...';

  @override
  String get enterColor => 'Indtast venligst en farve';

  @override
  String get initialWeightG => 'Begyndelsesvægt';

  @override
  String get remainingWeightG => 'Resterende vægt';

  @override
  String get enterBrand => 'Indtast venligst et mærke';

  @override
  String get selectOrEnterBrand => 'Vælg eller indtast venligst et mærke';

  @override
  String get enterMaterial => 'Indtast venligst et materiale';

  @override
  String get selectOrEnterMaterial =>
      'Vælg eller indtast venligst et materiale';

  @override
  String get enterPrice => 'Indtast venligst en pris';

  @override
  String get enterValidPrice => 'Indtast venligst en gyldig pris';

  @override
  String get enterWeight => 'Indtast venligst en vægt';

  @override
  String get enterValidWeight => 'Indtast venligst en gyldig vægt';

  @override
  String get remainingCannotExceedTotal =>
      'Resterende vægt kan ikke overstige den samlede vægt';

  @override
  String get overview => 'Oversigt';

  @override
  String get spoolsInStock => 'Spoler på lager';

  @override
  String get totalValue => 'Samlet værdi';

  @override
  String get lowStockSpools => 'Lavt lager';

  @override
  String get materialDistribution => 'Fordeling efter materiale';

  @override
  String get brandDistribution => 'Fordeling efter mærke';

  @override
  String get noData => 'Ingen data';

  @override
  String get refresh => 'Opdater';

  @override
  String get profileSettings => 'Profilindstillinger';

  @override
  String get preferences => 'Præferencer';

  @override
  String get language => 'Sprog';

  @override
  String get selectLanguage => 'Vælg sprog';

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
  String get currency => 'Valuta';

  @override
  String get selectCurrency => 'Vælg valuta';

  @override
  String get units => 'Enheder';

  @override
  String get selectUnits => 'Vælg enheder';

  @override
  String get metric => 'Metrisk (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Lavt lager advarselsgrænse';

  @override
  String get lowStockThresholdDesc =>
      'En spole vil blive betragtet som lavt lager, hvis den resterende vægt er mindre end denne procentdel';

  @override
  String get authentication => 'Godkendelse';

  @override
  String get signInWithGoogle => 'Log ind med Google';

  @override
  String get signInWithApple => 'Log ind med Apple';

  @override
  String get continueWithApple => 'Fortsæt med Apple';

  @override
  String get continueWithGoogle => 'Fortsæt med Google';

  @override
  String get comingSoon => 'Kommer snart';

  @override
  String get about => 'Om';

  @override
  String get version => 'Version';

  @override
  String get madeWith => 'Lavet med ❤️ til Anycubic 3D printere';

  @override
  String get scanBobbinDirectly => 'Scan spole';

  @override
  String get nfcEncoder => 'NFC koder';

  @override
  String get length => 'Længde';

  @override
  String get tempExtruder => 'Ekstrudértemp.';

  @override
  String get tempBed => 'Pladetemp.';

  @override
  String get termsOfService => 'Servicevilkår';

  @override
  String get privacyPolicy => 'Privatlivspolitik';

  @override
  String get legal => 'Juridisk';

  @override
  String get back => 'Tilbage';

  @override
  String get retry => 'Prøv igen';

  @override
  String get signOut => 'Log ud';

  @override
  String get extruderTempMinHint => 'F.eks.: 200';

  @override
  String get extruderTempMaxHint => 'F.eks.: 220';

  @override
  String get bedTempMinHint => 'F.eks.: 50';

  @override
  String get bedTempMaxHint => 'F.eks.: 60';

  @override
  String get diameterHint => 'F.eks.: 1.75';

  @override
  String get spoolLengthHint => 'F.eks.: 330';

  @override
  String get tabGrid => 'Gitter';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Glidere';

  @override
  String get hexCode => 'Hex kode';

  @override
  String get red => 'Rød';

  @override
  String get green => 'Grøn';

  @override
  String get blue => 'Blå';

  @override
  String get black => 'Sort';

  @override
  String get white => 'Hvid';

  @override
  String get yellow => 'Gul';

  @override
  String get orange => 'Orange';

  @override
  String get pink => 'Lyserød';

  @override
  String get purple => 'Lilla';

  @override
  String get gray => 'Grå';

  @override
  String get brown => 'Brun';

  @override
  String get unknown => 'Ukendt';

  @override
  String get metricUnits => 'Metrisk (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Schweizisk franc (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'US Dollar (\$)';

  @override
  String get gbp => 'Pund Sterling (£)';

  @override
  String get cad => 'Canadisk Dollar (CAD)';

  @override
  String get aud => 'AUD';

  @override
  String get jpy => 'JPY';

  @override
  String get cny => 'CNY';

  @override
  String get inr => 'INR';

  @override
  String get brl => 'BRL';

  @override
  String get mxn => 'MXN';

  @override
  String get sek => 'SEK';

  @override
  String get nok => 'NOK';

  @override
  String get dkk => 'DKK';

  @override
  String get pln => 'PLN';

  @override
  String get czk => 'CZK';

  @override
  String get nzd => 'NZD';

  @override
  String get filamentsToOrder => 'Filamenter at bestille';

  @override
  String get shoppingList => 'Indkøbsliste';

  @override
  String get addToShoppingList => 'Tilføj til liste';

  @override
  String get noLowStockFilaments => 'Ingen filamenter med lavt lager';

  @override
  String get vipSubscriptionDescription =>
      'Dette abonnement bruges kun til at deaktivere annoncer i appen og støtte projektet. Ingen andre funktioner.';

  @override
  String get monthlySubscription => 'Månedligt abonnement';

  @override
  String get yearlySubscription => 'Årligt abonnement';

  @override
  String get perMonth => '/ måned';

  @override
  String get perYear => '/ år';

  @override
  String onlyPerMonth(String price) {
    return 'Kun $price / måned';
  }

  @override
  String get subscribe => 'Abonner';

  @override
  String get bestOffer => '✨ BEDSTE TILBUD ✨';

  @override
  String get forAnycubicAce => 'til Anycubic Ace';

  @override
  String get forBambuLabAms => 'til Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Scan en NFC chip';

  @override
  String get fillForm => 'Udfyld formularen';

  @override
  String get emptyShoppingList => 'Ingen filamenter på listen';

  @override
  String percentRemaining(String percent) {
    return '$percent% tilbage';
  }

  @override
  String get markAsOrdered => 'Marker som bestilt';

  @override
  String get markAsNotOrdered => 'Marker som ikke bestilt';

  @override
  String get notSignedIn => 'Ikke logget ind';

  @override
  String get signIn => 'Log ind';

  @override
  String get connection => 'Forbindelse';

  @override
  String get signInToSync => 'Log ind for at synkronisere dine data';

  @override
  String get continueWithoutAccount => 'Fortsæt uden konto (lokal tilstand)';

  @override
  String get privacyNotice =>
      'Ved at logge ind accepterer du vores\nServicevilkår og Fortrolighedspolitik';

  @override
  String get updateStock => 'Opdater lager';

  @override
  String get scanToUpdateStock => 'Scan for at opdatere';

  @override
  String get weightUsed => 'Brugt vægt';

  @override
  String get lengthUsed => 'Brugt længde';

  @override
  String get enterWeightOrLength => 'Indtast brugt vægt eller længde';

  @override
  String get weightUsedG => 'Brugt vægt (g)';

  @override
  String get lengthUsedM => 'Brugt længde (m)';

  @override
  String get stockUpdated => 'Lager opdateret';

  @override
  String get scanSpoolToUpdate => 'Scan spole for at opdatere dens lager';

  @override
  String get spoolNotFound => 'Spole ikke fundet på lageret';

  @override
  String get addSpoolFirstMessage =>
      'Denne spole er endnu ikke på dit lager. Tilføj den først ved hjælp af knappen \'Tilføj spole\', før du opdaterer lageret.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Skrivebeskyttet';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab tags bruger RSA-kryptering og kan ikke ændres. Skrivebeskyttet.';

  @override
  String get forPrusaMk4 => 'til Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Læsning og skrivning';

  @override
  String get prusaReadWriteDesc =>
      'Prusa-tags bruger ISO 15693 (NFC-V) med OpenPrintTag-format. Læsning og skrivning understøttet.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab klonbibliotek';

  @override
  String get noBambuClones => 'Ingen Bambu Lab kloner';

  @override
  String get scanBambuToClone =>
      'Scan originale Bambu Lab tags for at oprette dit klonbibliotek';

  @override
  String get scanTag => 'Scan et tag';

  @override
  String get syncWithCloud => 'Synkroniser med sky';

  @override
  String get syncCompleted => 'Synkronisering fuldført';

  @override
  String get deleteClone => 'Slet klon';

  @override
  String get renameClone => 'Omdøb klon';

  @override
  String get rename => 'Omdøb';

  @override
  String get customName => 'Brugerdefineret navn';

  @override
  String get clonedOn => 'Klonet';

  @override
  String get writeThisClone => 'Skriv denne klon';

  @override
  String get writeClone => 'Skriv klon';

  @override
  String get writeOnCUID => 'Skriv på CUID-kort';

  @override
  String get cloneWrittenSuccess => 'Klon skrevet med succes!';

  @override
  String get requiredTagFormat => 'Påkrævet tagformat';

  @override
  String get type => 'Type';

  @override
  String get frequency => 'Frekvens';

  @override
  String get protocol => 'Protokol';

  @override
  String get capacity => 'Kapacitet';

  @override
  String get feature => 'Funktion';

  @override
  String get uidModifiable => 'Blok 0 (UID) modificerbar';

  @override
  String get whereToBuy =>
      'Søg efter \"CUID MiFare Classic 1K\" på AliExpress, Amazon eller eBay (~\$0.50/stk)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 kort - MiFare Classic 1K med skrivbar Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Søg efter \"Magic Gen2 MiFare Classic 1K\" eller \"UID writable\" på AliExpress, Amazon eller eBay (~\$0.50/stk)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Advarsel: Skrivning med iPhone NFC virker muligvis ikke på alle Magic Gen2 kort. En Proxmark3 enhed anbefales for maksimal pålidelighed.';

  @override
  String get step1GetMagicGen2 =>
      'Få et tomt Magic Gen2 kort (MiFare Classic 1K med skrivbar UID)';

  @override
  String get instructions => 'Instruktioner';

  @override
  String get step1GetCUID => 'Få et tomt CUID-kort (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Tryk på \"Skriv\"-knappen nedenfor';

  @override
  String get step3HoldPhone => 'Hold din iPhone tæt på CUID-kortet';

  @override
  String get step4WaitConfirm => 'Vent på skrivebekræftelse';

  @override
  String get step5TestClone => 'Test det klonede tag på din Bambu Lab printer!';

  @override
  String get rsaIncluded =>
      'Klonen inkluderer den originale RSA-signatur, den vil blive accepteret af printeren!';

  @override
  String get cloneDeleted => 'Klon slettet';

  @override
  String get deleteAccount => 'Slet min konto';

  @override
  String get deleteAccountConfirmation =>
      'Denne handling er uigenkaldelig. Din konto og alle data slettes inden for 30 dage.';

  @override
  String get accountDeletionRequested => 'Anmodning om sletning registreret';

  @override
  String get clearShoppingList => 'Ryd listen';

  @override
  String get clearShoppingListConfirmation =>
      'Er du sikker på, at du vil rydde hele indkøbslisten? Denne handling kan ikke fortrydes.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Historik';

  @override
  String get retryButton => 'Prøv igen';

  @override
  String get readSuccessMessage => 'Læsning lykkedes!';

  @override
  String get filamentTypeLabel => 'Filamenttype';

  @override
  String get scanNfcChipButton => 'Scan NFC-chip';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Slet klon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klon \"$name\" slettet';
  }

  @override
  String get extruderLabel => 'Ekstruder';

  @override
  String get writeThisCloneButton => 'Skriv denne klon';

  @override
  String get customNameHint => 'Brugerdefineret navn';

  @override
  String get cloneWriteSuccessMessage => 'Klon skrevet!';

  @override
  String errorPrefix(String error) {
    return 'Fejl: $error';
  }

  @override
  String get writingInProgress => 'Skriver...';

  @override
  String get writeOnCUIDButton => 'Skriv på CUID-kort';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get extruderTempLabel => 'Ekstrudertemperatur';

  @override
  String get bedTempLabel => 'Bordtemperatur';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bytes (1024 bytes)';

  @override
  String get rsaSignatureNote =>
      'Klonen indeholder den originale RSA-signatur, den accepteres af printeren!';

  @override
  String get writeBambuLabTagTitle => 'Skriv Bambu Lab-tag';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab-tag skrevet!';

  @override
  String get approachNfcTagMessage => 'Bring NFC-tag tæt på...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab-format (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab-format';

  @override
  String get bambuLabFormatInfo =>
      'Dette format bruger Bambu Lab-materialekoder og gemmer data i et AMS-kompatibelt format.';

  @override
  String get brandLabel => 'Mærke';

  @override
  String get materialTypeLabel => 'Materialetype';

  @override
  String get serialNumber3Digits => 'Serienummer (3 cifre)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (standard)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Skriv Bambu Lab-tag';

  @override
  String get bambuLabRsaNote =>
      'Bemærk: Originale Bambu Lab-tags bruger RSA-kryptering. Denne tilstand skriver data i et forenklet kompatibelt format.';

  @override
  String signInError(String error) {
    return 'Loginfejl: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Abonnement aktiveret!';

  @override
  String get subscriptionFailedMessage => 'Abonnement mislykkedes';

  @override
  String errorMessage(String error) {
    return 'Fejl: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Abonnement gendannet!';

  @override
  String get noSubscriptionFoundMessage => 'Intet abonnement fundet';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTIV';

  @override
  String get noAdsExperienceMessage => 'Nyd reklamefri oplevelse!';

  @override
  String get subscribedLabel => 'Abonnent';

  @override
  String get restorePurchasesButton => 'Gendan køb';

  @override
  String get cannotExceedRemainingWeight =>
      'Kan ikke overstige resterende vægt';

  @override
  String get pleaseEnterLength => 'Indtast længde';

  @override
  String get pleaseEnterValidLength => 'Indtast gyldig længde';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Spollængde ikke angivet - kan ikke konvertere';

  @override
  String get exceedsRemainingWeight => 'Overstiger resterende vægt';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament =>
      'Hjælp os med at identificere dette filament';

  @override
  String get helpUsImprove => 'Hjælp os med at forbedre!';

  @override
  String get helpIdentifyDescription =>
      'Vi læste chippen, men kunne ikke identificere den. Fortæl os hvilket filament det er, så vi kan forbedre appen.';

  @override
  String get otherBrand => 'Andet';

  @override
  String get thankYouFeedback => 'Tak for din feedback!';

  @override
  String get send => 'Send';

  @override
  String get optionalDetails => 'Valgfrie detaljer';

  @override
  String get weightGrams => 'Vægt (g)';

  @override
  String get diameterMm => 'Diameter (mm)';

  @override
  String get spoolLengthM => 'Spole længde (m)';

  @override
  String get batchNumberLabel => 'Batch / SKU';

  @override
  String get contactUs => 'Kontakt os';

  @override
  String get contactUsSubtitle => 'Spørgsmål, forslag eller problemer';

  @override
  String get nfcTagNotDetected => 'Ingen NFC-tag fundet';

  @override
  String get nfcTagNotDetectedDesc =>
      'Ingen tag blev fundet. Taggen kan være død, beskadiget eller for langt fra telefonen. Sørg for at toppen af din telefon placeres direkte på NFC-taggen.';

  @override
  String get nfcTagIncompatible => 'Inkompatibel NFC-tag fundet';

  @override
  String get nfcTagInfoPrusa =>
      'Brug et tomt NXP ICODE SLIX2-kort (ISO 15693) til at oprette OpenPrintTag-kompatible tags til Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Skriv Prusa OpenPrintTag';
}
