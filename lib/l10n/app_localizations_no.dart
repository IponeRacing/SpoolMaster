// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian (`no`).
class AppLocalizationsNo extends AppLocalizations {
  AppLocalizationsNo([String locale = 'no']) : super(locale);

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
  String get readNfcChip => 'Les NFC-brikke';

  @override
  String get scanHistory => 'Historikk';

  @override
  String get writeNfcChip => 'Skriv NFC-brikke';

  @override
  String get nfcNotAvailable => 'NFC er ikke tilgjengelig';

  @override
  String get nfcNotAvailableDesc =>
      'Enheten din støtter ikke NFC eller den er deaktivert.';

  @override
  String get nfcNotSupported => 'NFC støttes ikke på denne enheten';

  @override
  String get approachNfcChip => 'Nærm deg en NFC-brikke...';

  @override
  String get scanningNfc => 'Skanner...';

  @override
  String get nfcDataRead => 'NFC-data lest vellykket!';

  @override
  String get errorReadingNfc => 'Feil ved lesing av NFC';

  @override
  String get scanHistoryTitle => 'Skanningshistorikk';

  @override
  String get noScansRecorded => 'Ingen skanninger registrert';

  @override
  String get scansWillAppearHere => 'NFC-skanninger vil vises her automatisk';

  @override
  String get clearAll => 'Slett alle';

  @override
  String get deleteThisScan => 'Slette denne skanningen?';

  @override
  String get actionIrreversible => 'Denne handlingen er irreversibel.';

  @override
  String get cancel => 'Avbryt';

  @override
  String get delete => 'Slett';

  @override
  String get clearAllHistory => 'Slette hele historikken?';

  @override
  String get allScansWillBeDeleted =>
      'Alle skanninger vil bli slettet. Denne handlingen er irreversibel.';

  @override
  String get scanDeleted => 'Skanning slettet';

  @override
  String get scanDetails => 'Skanningsdetaljer';

  @override
  String scannedOn(Object date) {
    return 'Skannet $date';
  }

  @override
  String get bobbinInformation => 'Spoleinformasjon';

  @override
  String get filamentType => 'Filamenttype';

  @override
  String get color => 'Farge';

  @override
  String get weight => 'Vekt';

  @override
  String get manufacturingDate => 'Produksjonsdato';

  @override
  String get batchNumber => 'Batchnummer';

  @override
  String get printerSettings => 'Skriverinnstillinger';

  @override
  String get scanMetadata => 'Skanningsmetadata';

  @override
  String get scanId => 'Skannings-ID';

  @override
  String get dateAndTime => 'Dato og tid';

  @override
  String get reuseThisData => 'Gjenbruk disse dataene';

  @override
  String get writeToNfc => 'Skriv til NFC';

  @override
  String get writeDataToChip => 'Skriv data til brikke';

  @override
  String get writeSuccess => 'Skriving vellykket!';

  @override
  String get writeError => 'Skrivefeil';

  @override
  String get brand => 'Merke';

  @override
  String get selectBrand => 'Velg merke';

  @override
  String get materialType => 'Materialetype';

  @override
  String get selectMaterial => 'Velg materiale';

  @override
  String get serialNumber => 'Serienummer';

  @override
  String get serialNumberHint => 'f.eks.: 001';

  @override
  String get initialWeight => 'Startvekt';

  @override
  String get initialWeightHint => 'f.eks.: 1000';

  @override
  String get extruderTempMin => 'Min. ekstrudertemp.';

  @override
  String get extruderTempMax => 'Maks. ekstrudertemp.';

  @override
  String get bedTempMin => 'Min. plattetemp.';

  @override
  String get bedTempMax => 'Maks. plattetemp.';

  @override
  String get diameter => 'Filamentdiameter';

  @override
  String get spoolLength => 'Spolelengde';

  @override
  String get generatedSku => 'Generert SKU';

  @override
  String get approachChipToWrite => 'Nærm deg brikke for å skrive...';

  @override
  String get writing => 'Skriver...';

  @override
  String get chooseColor => 'Velg farge';

  @override
  String get required => 'Påkrevd';

  @override
  String get invalid => 'Ugyldig';

  @override
  String get advancedSettings => 'Avanserte innstillinger';

  @override
  String get opacity => 'Gjennomsiktighet';

  @override
  String get validate => 'Bekreft';

  @override
  String get nfcTagInfo =>
      'Bruk en tom ISO14443A NFC-tag (NTAG213) for å lage dine egne Anycubic-tagger.';

  @override
  String get stockInventory => 'Spoler på lager';

  @override
  String get addSpool => 'Legg til spole';

  @override
  String get scanSpool => 'Skann spole';

  @override
  String get addManually => 'Legg til manuelt';

  @override
  String get spoolAdded => 'Spole lagt til';

  @override
  String get spoolUpdated => 'Spole oppdatert';

  @override
  String get noSpoolsInStock => 'Ingen spoler på lager';

  @override
  String get addFirstSpool =>
      'Legg til din første spole for å begynne å spore lageret ditt';

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
  String get save => 'Lagre';

  @override
  String get spoolDetails => 'Spoledetaljer';

  @override
  String get deleteThisSpool => 'Slette denne spolen?';

  @override
  String get cannotBeUndone => 'Denne handlingen kan ikke angres.';

  @override
  String get addSpoolManually => 'Legg til spole manuelt';

  @override
  String get editSpool => 'Rediger spole';

  @override
  String get customBrand => 'Egendefinert merke';

  @override
  String get customBrandHint => 'f.eks.: Mitt merke';

  @override
  String get chooseFromList => 'Velg fra liste';

  @override
  String get addBrand => '+ Legg til merke';

  @override
  String get customMaterial => 'Egendefinert materiale';

  @override
  String get customMaterialHint => 'f.eks.: Mitt materiale';

  @override
  String get addMaterial => '+ Legg til materiale';

  @override
  String get colorHint => 'f.eks.: Blå, Rød...';

  @override
  String get enterColor => 'Vennligst oppgi en farge';

  @override
  String get initialWeightG => 'Startvekt';

  @override
  String get remainingWeightG => 'Gjenværende vekt';

  @override
  String get enterBrand => 'Vennligst oppgi et merke';

  @override
  String get selectOrEnterBrand => 'Vennligst velg eller oppgi et merke';

  @override
  String get enterMaterial => 'Vennligst oppgi et materiale';

  @override
  String get selectOrEnterMaterial => 'Vennligst velg eller oppgi et materiale';

  @override
  String get enterPrice => 'Vennligst oppgi en pris';

  @override
  String get enterValidPrice => 'Vennligst oppgi en gyldig pris';

  @override
  String get enterWeight => 'Vennligst oppgi en vekt';

  @override
  String get enterValidWeight => 'Vennligst oppgi en gyldig vekt';

  @override
  String get remainingCannotExceedTotal =>
      'Gjenværende vekt kan ikke overstige total vekt';

  @override
  String get overview => 'Oversikt';

  @override
  String get spoolsInStock => 'Spoler på lager';

  @override
  String get totalValue => 'Total verdi';

  @override
  String get lowStockSpools => 'Lavt lager';

  @override
  String get materialDistribution => 'Fordeling etter materiale';

  @override
  String get brandDistribution => 'Fordeling etter merke';

  @override
  String get noData => 'Ingen data';

  @override
  String get refresh => 'Oppdater';

  @override
  String get profileSettings => 'Profilinnstillinger';

  @override
  String get preferences => 'Preferanser';

  @override
  String get language => 'Språk';

  @override
  String get selectLanguage => 'Velg språk';

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
  String get selectCurrency => 'Velg valuta';

  @override
  String get units => 'Enheter';

  @override
  String get selectUnits => 'Velg enheter';

  @override
  String get metric => 'Metrisk (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Lavt lager varselsgrense';

  @override
  String get lowStockThresholdDesc =>
      'En spole vil bli ansett som lavt lager hvis gjenværende vekt er mindre enn denne prosentandelen';

  @override
  String get authentication => 'Autentisering';

  @override
  String get signInWithGoogle => 'Logg inn med Google';

  @override
  String get signInWithApple => 'Logg inn med Apple';

  @override
  String get continueWithApple => 'Fortsett med Apple';

  @override
  String get continueWithGoogle => 'Fortsett med Google';

  @override
  String get comingSoon => 'Kommer snart';

  @override
  String get about => 'Om';

  @override
  String get version => 'Versjon';

  @override
  String get madeWith => 'Laget med ❤️ for Anycubic 3D-skrivere';

  @override
  String get scanBobbinDirectly => 'Skann spole';

  @override
  String get nfcEncoder => 'NFC-koder';

  @override
  String get length => 'Lengde';

  @override
  String get tempExtruder => 'Ekstrudertemp.';

  @override
  String get tempBed => 'Plattetemp.';

  @override
  String get termsOfService => 'Tjenestevilkår';

  @override
  String get privacyPolicy => 'Personvernpolicy';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Tilbake';

  @override
  String get retry => 'Prøv igjen';

  @override
  String get signOut => 'Logg ut';

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
  String get tabGrid => 'Rutenett';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Glidebrytere';

  @override
  String get hexCode => 'Hex-kode';

  @override
  String get red => 'Rød';

  @override
  String get green => 'Grønn';

  @override
  String get blue => 'Blå';

  @override
  String get metricUnits => 'Metrisk (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Sveitsisk franc (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Amerikanske dollar (\$)';

  @override
  String get gbp => 'Pund sterling (£)';

  @override
  String get cad => 'Kanadiske dollar (CAD)';

  @override
  String get filamentsToOrder => 'Filamenter å bestille';

  @override
  String get shoppingList => 'Handlekurv';

  @override
  String get addToShoppingList => 'Legg til i liste';

  @override
  String get noLowStockFilaments => 'Ingen filamenter med lavt lager';

  @override
  String get vipSubscriptionDescription =>
      'Dette abonnementet brukes kun til å deaktivere annonser i appen og støtte prosjektet. Ingen andre funksjoner.';

  @override
  String get monthlySubscription => 'Månedlig abonnement';

  @override
  String get yearlySubscription => 'Årlig abonnement';

  @override
  String get perMonth => '/ måned';

  @override
  String get perYear => '/ år';

  @override
  String onlyPerMonth(String price) {
    return 'Bare $price / måned';
  }

  @override
  String get subscribe => 'Abonner';

  @override
  String get bestOffer => '✨ BESTE TILBUD ✨';

  @override
  String get forAnycubicAce => 'for Anycubic Ace';

  @override
  String get forBambuLabAms => 'for Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Skann en NFC-brikke';

  @override
  String get fillForm => 'Fyll ut skjemaet';

  @override
  String get emptyShoppingList => 'Ingen filamenter i listen';

  @override
  String percentRemaining(String percent) {
    return '$percent% gjenstår';
  }

  @override
  String get markAsOrdered => 'Merk som bestilt';

  @override
  String get markAsNotOrdered => 'Merk som ikke bestilt';

  @override
  String get notSignedIn => 'Ikke logget inn';

  @override
  String get signIn => 'Logg inn';

  @override
  String get connection => 'Tilkobling';

  @override
  String get signInToSync => 'Logg inn for å synkronisere dataene dine';

  @override
  String get continueWithoutAccount => 'Fortsett uten konto (lokal modus)';

  @override
  String get privacyNotice =>
      'Ved å logge inn godtar du våre\nBruksvilkår og Personvernregler';

  @override
  String get updateStock => 'Oppdater lager';

  @override
  String get scanToUpdateStock => 'Skann for å oppdatere';

  @override
  String get weightUsed => 'Brukt vekt';

  @override
  String get lengthUsed => 'Brukt lengde';

  @override
  String get enterWeightOrLength => 'Skriv inn brukt vekt eller lengde';

  @override
  String get weightUsedG => 'Brukt vekt (g)';

  @override
  String get lengthUsedM => 'Brukt lengde (m)';

  @override
  String get stockUpdated => 'Lager oppdatert';

  @override
  String get scanSpoolToUpdate => 'Skann spole for å oppdatere lageret';

  @override
  String get spoolNotFound => 'Spole ikke funnet i lageret';

  @override
  String get addSpoolFirstMessage =>
      'Denne spolen er ikke i lageret ennå. Vennligst legg den til først ved å bruke \'Legg til spole\'-knappen før du oppdaterer lageret.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Skrivebeskyttet';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab tagger bruker RSA-kryptering og kan ikke endres. Skrivebeskyttet.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab klonbibliotek';

  @override
  String get noBambuClones => 'Ingen Bambu Lab kloner';

  @override
  String get scanBambuToClone =>
      'Skann originale Bambu Lab-tagger for å opprette klonbiblioteket ditt';

  @override
  String get scanTag => 'Skann en tagg';

  @override
  String get syncWithCloud => 'Synkroniser med sky';

  @override
  String get syncCompleted => 'Synkronisering fullført';

  @override
  String get deleteClone => 'Slett klon';

  @override
  String get renameClone => 'Gi nytt navn til klon';

  @override
  String get rename => 'Gi nytt navn';

  @override
  String get customName => 'Egendefinert navn';

  @override
  String get clonedOn => 'Klonet';

  @override
  String get writeThisClone => 'Skriv denne klonen';

  @override
  String get writeClone => 'Skriv klon';

  @override
  String get writeOnCUID => 'Skriv på CUID-kort';

  @override
  String get cloneWrittenSuccess => 'Klon skrevet vellykket!';

  @override
  String get requiredTagFormat => 'Nødvendig taggformat';

  @override
  String get type => 'Type';

  @override
  String get frequency => 'Frekvens';

  @override
  String get protocol => 'Protokoll';

  @override
  String get capacity => 'Kapasitet';

  @override
  String get feature => 'Funksjon';

  @override
  String get uidModifiable => 'Blokk 0 (UID) modifiserbar';

  @override
  String get whereToBuy =>
      'Søk etter \"CUID MiFare Classic 1K\" på AliExpress, Amazon eller eBay (~\$0.50/stk)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 kort - MiFare Classic 1K med skrivbar Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Søk etter \"Magic Gen2 MiFare Classic 1K\" eller \"UID writable\" på AliExpress, Amazon eller eBay (~\$0.50/stk)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Advarsel: Skriving med iPhone NFC fungerer kanskje ikke på alle Magic Gen2 kort. En Proxmark3 enhet anbefales for maksimal pålitelighet.';

  @override
  String get step1GetMagicGen2 =>
      'Skaff et tomt Magic Gen2 kort (MiFare Classic 1K med skrivbar UID)';

  @override
  String get instructions => 'Instruksjoner';

  @override
  String get step1GetCUID => 'Få tak i et tomt CUID-kort (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Trykk på \"Skriv\"-knappen nedenfor';

  @override
  String get step3HoldPhone => 'Hold iPhone-en nær CUID-kortet';

  @override
  String get step4WaitConfirm => 'Vent på skrivebekreftelse';

  @override
  String get step5TestClone =>
      'Test den klonede taggen på Bambu Lab-skriveren din!';

  @override
  String get rsaIncluded =>
      'Klonen inkluderer den originale RSA-signaturen, den vil bli akseptert av skriveren!';

  @override
  String get cloneDeleted => 'Klon slettet';

  @override
  String get deleteAccount => 'Slett min konto';

  @override
  String get deleteAccountConfirmation =>
      'Denne handlingen er irreversibel. Kontoen din og alle data slettes innen 30 dager.';

  @override
  String get accountDeletionRequested => 'Forespørsel om sletting registrert';

  @override
  String get clearShoppingList => 'Tøm listen';

  @override
  String get clearShoppingListConfirmation =>
      'Er du sikker på at du vil tømme hele handlelisten? Denne handlingen kan ikke angres.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Historikk';

  @override
  String get retryButton => 'Prøv igjen';

  @override
  String get readSuccessMessage => 'Lesing vellykket!';

  @override
  String get filamentTypeLabel => 'Filamenttype';

  @override
  String get scanNfcChipButton => 'Skann NFC-brikke';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Slett klon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klon \"$name\" slettet';
  }

  @override
  String get extruderLabel => 'Ekstruder';

  @override
  String get writeThisCloneButton => 'Skriv denne klonen';

  @override
  String get customNameHint => 'Egendefinert navn';

  @override
  String get cloneWriteSuccessMessage => 'Klone skrevet!';

  @override
  String errorPrefix(String error) {
    return 'Feil: $error';
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
  String get bedTempLabel => 'Sengtemperatur';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K byte (1024 byte)';

  @override
  String get rsaSignatureNote =>
      'Klonen inkluderer den originale RSA-signaturen, den vil bli akseptert av skriveren!';

  @override
  String get writeBambuLabTagTitle => 'Skriv Bambu Lab-tagg';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab-tagg skrevet!';

  @override
  String get approachNfcTagMessage => 'Hold NFC-tagg nær...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab-format (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab-format';

  @override
  String get bambuLabFormatInfo =>
      'Dette formatet bruker Bambu Lab-materialkoder og lagrer data i et AMS-kompatibelt format.';

  @override
  String get brandLabel => 'Merke';

  @override
  String get materialTypeLabel => 'Materialtype';

  @override
  String get serialNumber3Digits => 'Serienummer (3 siffer)';

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
  String get writeBambuLabTagButton => 'Skriv Bambu Lab-tagg';

  @override
  String get bambuLabRsaNote =>
      'Merk: Originale Bambu Lab-tagger bruker RSA-kryptering. Denne modusen skriver data i et forenklet kompatibelt format.';

  @override
  String signInError(String error) {
    return 'Påloggingsfeil: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Abonnement aktivert!';

  @override
  String get subscriptionFailedMessage => 'Abonnement mislyktes';

  @override
  String errorMessage(String error) {
    return 'Feil: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Abonnement gjenopprettet!';

  @override
  String get noSubscriptionFoundMessage => 'Ingen abonnement funnet';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTIV';

  @override
  String get noAdsExperienceMessage => 'Nyt reklamefri opplevelse!';

  @override
  String get subscribedLabel => 'Abonnent';

  @override
  String get restorePurchasesButton => 'Gjenopprett kjøp';

  @override
  String get cannotExceedRemainingWeight =>
      'Kan ikke overskride gjenværende vekt';

  @override
  String get pleaseEnterLength => 'Angi lengde';

  @override
  String get pleaseEnterValidLength => 'Angi gyldig lengde';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Spolllengde ikke angitt - kan ikke konvertere';

  @override
  String get exceedsRemainingWeight => 'Overskrider gjenværende vekt';

  @override
  String get skuLabel => 'SKU';
}
