// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Lager';

  @override
  String get statistics => 'Statistik';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Läs NFC-chip';

  @override
  String get scanHistory => 'Historik';

  @override
  String get writeNfcChip => 'Skriv NFC-chip';

  @override
  String get nfcNotAvailable => 'NFC inte tillgänglig';

  @override
  String get nfcNotAvailableDesc =>
      'Din enhet stöder inte NFC eller så är det inaktiverat.';

  @override
  String get nfcNotSupported => 'NFC stöds inte på denna enhet';

  @override
  String get approachNfcChip => 'Närma dig ett NFC-chip...';

  @override
  String get scanningNfc => 'Skannar...';

  @override
  String get nfcDataRead => 'NFC-data läst framgångsrikt!';

  @override
  String get errorReadingNfc => 'Fel vid läsning av NFC';

  @override
  String get scanHistoryTitle => 'Skannhistorik';

  @override
  String get noScansRecorded => 'Inga skanningar registrerade';

  @override
  String get scansWillAppearHere =>
      'NFC-skanningar kommer att visas här automatiskt';

  @override
  String get clearAll => 'Rensa allt';

  @override
  String get deleteThisScan => 'Ta bort denna skanning?';

  @override
  String get actionIrreversible => 'Denna åtgärd är oåterkallelig.';

  @override
  String get cancel => 'Avbryt';

  @override
  String get delete => 'Ta bort';

  @override
  String get clearAllHistory => 'Rensa all historik?';

  @override
  String get allScansWillBeDeleted =>
      'Alla skanningar kommer att tas bort. Denna åtgärd är oåterkallelig.';

  @override
  String get scanDeleted => 'Skanning borttagen';

  @override
  String get scanDetails => 'Skanndetaljer';

  @override
  String scannedOn(Object date) {
    return 'Skannad den $date';
  }

  @override
  String get bobbinInformation => 'Bobininformation';

  @override
  String get filamentType => 'Filamenttyp';

  @override
  String get color => 'Färg';

  @override
  String get weight => 'Vikt';

  @override
  String get manufacturingDate => 'Tillverkningsdatum';

  @override
  String get batchNumber => 'Batchnummer';

  @override
  String get printerSettings => 'Skrivarinställningar';

  @override
  String get scanMetadata => 'Skannmetadata';

  @override
  String get scanId => 'Skann-ID';

  @override
  String get dateAndTime => 'Datum och tid';

  @override
  String get reuseThisData => 'Återanvänd denna data';

  @override
  String get writeToNfc => 'Skriv till NFC';

  @override
  String get writeDataToChip => 'Skriv data till chip';

  @override
  String get writeSuccess => 'Skrivning lyckades!';

  @override
  String get writeError => 'Skrivfel';

  @override
  String get brand => 'Märke';

  @override
  String get selectBrand => 'Välj märke';

  @override
  String get materialType => 'Materialtyp';

  @override
  String get selectMaterial => 'Välj material';

  @override
  String get serialNumber => 'Serienummer';

  @override
  String get serialNumberHint => 't.ex.: 001';

  @override
  String get initialWeight => 'Ursprunglig vikt';

  @override
  String get initialWeightHint => 't.ex.: 1000';

  @override
  String get extruderTempMin => 'Extruder temp. min';

  @override
  String get extruderTempMax => 'Extruder temp. max';

  @override
  String get bedTempMin => 'Bäddtemp. min';

  @override
  String get bedTempMax => 'Bäddtemp. max';

  @override
  String get diameter => 'Diameter';

  @override
  String get spoolLength => 'Längd (m)';

  @override
  String get generatedSku => 'Genererad SKU';

  @override
  String get approachChipToWrite => 'Närma chip för att skriva...';

  @override
  String get writing => 'Skriver...';

  @override
  String get chooseColor => 'Välj färg';

  @override
  String get required => 'Obligatorisk';

  @override
  String get invalid => 'Ogiltig';

  @override
  String get advancedSettings => 'Avancerade inställningar';

  @override
  String get opacity => 'Opacitet';

  @override
  String get validate => 'Validera';

  @override
  String get nfcTagInfo =>
      'Använd en tom ISO14443A NFC-tagg (NTAG213) för att skapa dina egna Anycubic-taggar.';

  @override
  String get stockInventory => 'Rullar i lager';

  @override
  String get addSpool => 'Lägg till spole';

  @override
  String get scanSpool => 'Skanna spole';

  @override
  String get addManually => 'Lägg till manuellt';

  @override
  String get spoolAdded => 'Spole tillagd';

  @override
  String get spoolUpdated => 'Spole uppdaterad';

  @override
  String get noSpoolsInStock => 'Inga spolar i lager';

  @override
  String get addFirstSpool =>
      'Lägg till din första spole för att börja spåra ditt lager';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count spole/spolar med lågt lager (< $threshold%)';
  }

  @override
  String get edit => 'Redigera';

  @override
  String get bobbinPrice => 'Bobinpris';

  @override
  String get price => 'Pris';

  @override
  String get priceHint => 't.ex.: 25.00';

  @override
  String get save => 'Spara';

  @override
  String get spoolDetails => 'Spoldetaljer';

  @override
  String get deleteThisSpool => 'Ta bort denna spole?';

  @override
  String get cannotBeUndone => 'Denna åtgärd kan inte ångras.';

  @override
  String get addSpoolManually => 'Lägg till spole manuellt';

  @override
  String get editSpool => 'Redigera spole';

  @override
  String get customBrand => 'Anpassat märke';

  @override
  String get customBrandHint => 't.ex.: Mitt märke';

  @override
  String get chooseFromList => 'Välj från lista';

  @override
  String get addBrand => '+ Lägg till märke';

  @override
  String get customMaterial => 'Anpassat material';

  @override
  String get customMaterialHint => 't.ex.: Mitt material';

  @override
  String get addMaterial => '+ Lägg till material';

  @override
  String get colorHint => 't.ex.: Blå, Röd...';

  @override
  String get enterColor => 'Vänligen ange en färg';

  @override
  String get initialWeightG => 'Ursprunglig vikt';

  @override
  String get remainingWeightG => 'Återstående vikt';

  @override
  String get enterBrand => 'Vänligen ange ett märke';

  @override
  String get selectOrEnterBrand => 'Vänligen välj eller ange ett märke';

  @override
  String get quantity => 'Antal';

  @override
  String get quantityHelper => 'Lägg till flera identiska spolar samtidigt';

  @override
  String get quantityInvalid => 'Ange ett tal mellan 1 och 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count i lager';
  }

  @override
  String get enterMaterial => 'Vänligen ange ett material';

  @override
  String get selectOrEnterMaterial => 'Vänligen välj eller ange ett material';

  @override
  String get enterPrice => 'Vänligen ange ett pris';

  @override
  String get enterValidPrice => 'Vänligen ange ett giltigt pris';

  @override
  String get enterWeight => 'Vänligen ange en vikt';

  @override
  String get enterValidWeight => 'Vänligen ange en giltig vikt';

  @override
  String get remainingCannotExceedTotal =>
      'Återstående vikt kan inte överstiga total vikt';

  @override
  String get overview => 'Översikt';

  @override
  String get spoolsInStock => 'Spolar i lager';

  @override
  String get totalValue => 'Totalt värde';

  @override
  String get lowStockSpools => 'Lågt lager';

  @override
  String get materialDistribution => 'Fördelning per material';

  @override
  String get brandDistribution => 'Fördelning per märke';

  @override
  String get noData => 'Ingen data';

  @override
  String get refresh => 'Uppdatera';

  @override
  String get profileSettings => 'Profilinställningar';

  @override
  String get preferences => 'Preferenser';

  @override
  String get language => 'Språk';

  @override
  String get selectLanguage => 'Välj språk';

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
  String get selectCurrency => 'Välj valuta';

  @override
  String get units => 'Enheter';

  @override
  String get selectUnits => 'Välj enheter';

  @override
  String get metric => 'Metrisk (mm, g, °C)';

  @override
  String get imperial => 'Imperial (tum, oz, °F)';

  @override
  String get lowStockThreshold => 'Tröskel för låg lagerstatus';

  @override
  String get lowStockThresholdDesc =>
      'En spole kommer att anses ha lågt lager om den återstående vikten är mindre än denna procentsats';

  @override
  String get authentication => 'Autentisering';

  @override
  String get signInWithGoogle => 'Logga in med Google';

  @override
  String get signInWithApple => 'Logga in med Apple';

  @override
  String get continueWithApple => 'Fortsätt med Apple';

  @override
  String get continueWithGoogle => 'Fortsätt med Google';

  @override
  String get comingSoon => 'Kommer snart';

  @override
  String get about => 'Om';

  @override
  String get version => 'Version';

  @override
  String get madeWith => 'Gjord med ❤️ för Anycubic 3D-skrivare';

  @override
  String get scanBobbinDirectly => 'Skanna bobin';

  @override
  String get nfcEncoder => 'NFC-kodare';

  @override
  String get length => 'Längd';

  @override
  String get tempExtruder => 'Extruder temp.';

  @override
  String get tempBed => 'Bäddtemp.';

  @override
  String get termsOfService => 'Användarvillkor';

  @override
  String get privacyPolicy => 'Sekretesspolicy';

  @override
  String get legal => 'Juridiskt';

  @override
  String get back => 'Tillbaka';

  @override
  String get retry => 'Försök igen';

  @override
  String get signOut => 'Logga ut';

  @override
  String get extruderTempMinHint => 't.ex.: 200';

  @override
  String get extruderTempMaxHint => 't.ex.: 220';

  @override
  String get bedTempMinHint => 't.ex.: 50';

  @override
  String get bedTempMaxHint => 't.ex.: 60';

  @override
  String get diameterHint => 't.ex.: 1.75';

  @override
  String get spoolLengthHint => 't.ex.: 330';

  @override
  String get tabGrid => 'Rutnät';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Reglage';

  @override
  String get hexCode => 'Hexadecimal kod';

  @override
  String get red => 'Röd';

  @override
  String get green => 'Grön';

  @override
  String get blue => 'Blå';

  @override
  String get black => 'Svart';

  @override
  String get white => 'Vit';

  @override
  String get yellow => 'Gul';

  @override
  String get orange => 'Orange';

  @override
  String get pink => 'Rosa';

  @override
  String get purple => 'Lila';

  @override
  String get gray => 'Grå';

  @override
  String get brown => 'Brun';

  @override
  String get unknown => 'Okänd';

  @override
  String get metricUnits => 'Metrisk (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (tum, oz, °F)';

  @override
  String get chf => 'Schweizisk franc (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Amerikansk dollar (\$)';

  @override
  String get gbp => 'Pund sterling (£)';

  @override
  String get cad => 'Kanadensisk dollar (CAD)';

  @override
  String get aud => 'Australisk dollar (A\$)';

  @override
  String get jpy => 'Japansk yen (¥)';

  @override
  String get cny => 'Kinesisk yuan (¥)';

  @override
  String get inr => 'Indisk rupie (₹)';

  @override
  String get brl => 'Brasiliansk real (R\$)';

  @override
  String get mxn => 'Mexikansk peso (MX\$)';

  @override
  String get sek => 'Svensk krona (kr)';

  @override
  String get nok => 'Norsk krone (kr)';

  @override
  String get dkk => 'Dansk krone (kr)';

  @override
  String get pln => 'Polsk zloty (zł)';

  @override
  String get czk => 'Tjeckisk koruna (Kč)';

  @override
  String get nzd => 'Nyzeeländsk dollar (NZ\$)';

  @override
  String get filamentsToOrder => 'Filament att beställa';

  @override
  String get shoppingList => 'Inköpslista';

  @override
  String get addToShoppingList => 'Lägg till i listan';

  @override
  String get noLowStockFilaments => 'Inga filament med lågt lager';

  @override
  String get vipSubscriptionDescription =>
      'Denna prenumeration tjänar endast till att inaktivera annonser i appen och stödja projektet. Ingen annan funktionalitet.';

  @override
  String get monthlySubscription => 'Månadsprenumeration';

  @override
  String get yearlySubscription => 'Årsprenumeration';

  @override
  String get perMonth => '/ månad';

  @override
  String get perYear => '/ år';

  @override
  String onlyPerMonth(String price) {
    return 'Endast $price / månad';
  }

  @override
  String get subscribe => 'Prenumerera';

  @override
  String get bestOffer => '✨ BÄSTA ERBJUDANDET ✨';

  @override
  String get forAnycubicAce => 'för Anycubic Ace';

  @override
  String get forBambuLabAms => 'för Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Skanna NFC-chip';

  @override
  String get fillForm => 'Fyll i formulär';

  @override
  String get emptyShoppingList => 'Inga filament i listan';

  @override
  String percentRemaining(String percent) {
    return '$percent% kvar';
  }

  @override
  String get markAsOrdered => 'Markera som beställd';

  @override
  String get markAsNotOrdered => 'Markera som ej beställd';

  @override
  String get notSignedIn => 'Inte inloggad';

  @override
  String get signIn => 'Logga in';

  @override
  String get connection => 'Inloggning';

  @override
  String get signInToSync => 'Logga in för att synkronisera dina data';

  @override
  String get continueWithoutAccount => 'Fortsätt utan konto (lokalt läge)';

  @override
  String get privacyNotice =>
      'Genom att logga in accepterar du våra\nAnvändarvillkor och Sekretesspolicy';

  @override
  String get updateStock => 'Uppdatera lager';

  @override
  String get scanToUpdateStock => 'Skanna för att uppdatera';

  @override
  String get weightUsed => 'Använd vikt';

  @override
  String get lengthUsed => 'Använd längd';

  @override
  String get enterWeightOrLength => 'Ange använd vikt eller längd';

  @override
  String get weightUsedG => 'Använd vikt (g)';

  @override
  String get lengthUsedM => 'Använd längd (m)';

  @override
  String get stockUpdated => 'Lager uppdaterat';

  @override
  String get scanSpoolToUpdate => 'Skanna en spole för att uppdatera lagret';

  @override
  String get spoolNotFound => 'Spole hittades inte i lagret';

  @override
  String get addSpoolFirstMessage =>
      'Denna spole finns ännu inte i ditt lager. Lägg först till den med knappen \'Lägg till spole\' innan du uppdaterar lagret.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Skrivskyddad';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab-taggar använder RSA-kryptering och kan inte modifieras. Skrivskyddad.';

  @override
  String get forPrusaMk4 => 'för Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Läs och skriv';

  @override
  String get prusaReadWriteDesc =>
      'Prusa-taggar använder ISO 15693 (NFC-V) med OpenPrintTag-format. Läsning och skrivning stöds.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab klonbibliotek';

  @override
  String get noBambuClones => 'Inga Bambu Lab kloner';

  @override
  String get scanBambuToClone =>
      'Skanna original Bambu Lab-taggar för att skapa ditt klonbibliotek';

  @override
  String get scanTag => 'Skanna en tagg';

  @override
  String get syncWithCloud => 'Synkronisera med molnet';

  @override
  String get syncCompleted => 'Synkronisering slutförd';

  @override
  String get deleteClone => 'Ta bort klon';

  @override
  String get renameClone => 'Byt namn på klon';

  @override
  String get rename => 'Byt namn';

  @override
  String get customName => 'Anpassat namn';

  @override
  String get clonedOn => 'Klonad';

  @override
  String get writeThisClone => 'Skriv denna klon';

  @override
  String get writeClone => 'Skriv klon';

  @override
  String get writeOnCUID => 'Skriv på CUID-kort';

  @override
  String get cloneWrittenSuccess => 'Klon skriven framgångsrikt!';

  @override
  String get requiredTagFormat => 'Nödvändigt taggformat';

  @override
  String get type => 'Typ';

  @override
  String get frequency => 'Frekvens';

  @override
  String get protocol => 'Protokoll';

  @override
  String get capacity => 'Kapacitet';

  @override
  String get feature => 'Funktion';

  @override
  String get uidModifiable => 'Block 0 (UID) modifierbart';

  @override
  String get whereToBuy =>
      'Sök efter \"CUID MiFare Classic 1K\" på AliExpress, Amazon eller eBay (~\$0.50/styck)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 kort - MiFare Classic 1K med skrivbar Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Sök efter \"Magic Gen2 MiFare Classic 1K\" eller \"UID writable\" på AliExpress, Amazon eller eBay (~\$0.50/st)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Varning: Skrivning med iPhone NFC kanske inte fungerar på alla Magic Gen2 kort. En Proxmark3 enhet rekommenderas för maximal tillförlitlighet.';

  @override
  String get step1GetMagicGen2 =>
      'Skaffa ett tomt Magic Gen2 kort (MiFare Classic 1K med skrivbar UID)';

  @override
  String get instructions => 'Instruktioner';

  @override
  String get step1GetCUID => 'Skaffa ett tomt CUID-kort (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Tryck på knappen \"Skriv\" nedan';

  @override
  String get step3HoldPhone => 'Håll din telefon nära CUID-kortet';

  @override
  String get step4WaitConfirm => 'Vänta på skrivbekräftelse';

  @override
  String get step5TestClone =>
      'Testa den klonade taggen på din Bambu Lab skrivare!';

  @override
  String get rsaIncluded =>
      'Klonen inkluderar den ursprungliga RSA-signaturen, den kommer att accepteras av skrivaren!';

  @override
  String get cloneDeleted => 'Klon borttagen';

  @override
  String get deleteAccount => 'Radera mitt konto';

  @override
  String get deleteAccountConfirmation =>
      'Denna åtgärd är oåterkallelig. Ditt konto och all data raderas inom 30 dagar.';

  @override
  String get accountDeletionRequested => 'Begäran om radering registrerad';

  @override
  String get clearShoppingList => 'Rensa listan';

  @override
  String get clearShoppingListConfirmation =>
      'Är du säker på att du vill rensa hela inköpslistan? Denna åtgärd kan inte ångras.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Historik';

  @override
  String get retryButton => 'Försök igen';

  @override
  String get readSuccessMessage => 'Läsning lyckades!';

  @override
  String get filamentTypeLabel => 'Filamenttyp';

  @override
  String get scanNfcChipButton => 'Skanna NFC-chip';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Ta bort klon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klon \"$name\" borttagen';
  }

  @override
  String get extruderLabel => 'Extruder';

  @override
  String get writeThisCloneButton => 'Skriv denna klon';

  @override
  String get customNameHint => 'Anpassat namn';

  @override
  String get cloneWriteSuccessMessage => 'Klon skriven!';

  @override
  String errorPrefix(String error) {
    return 'Fel: $error';
  }

  @override
  String get writingInProgress => 'Skriver...';

  @override
  String get writeOnCUIDButton => 'Skriv på CUID-kort';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get extruderTempLabel => 'Extrudertemperatur';

  @override
  String get bedTempLabel => 'Bäddtemperatur';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K byte (1024 byte)';

  @override
  String get rsaSignatureNote =>
      'Klonen innehåller den ursprungliga RSA-signaturen, den accepteras av skrivaren!';

  @override
  String get writeBambuLabTagTitle => 'Skriv Bambu Lab-tagg';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab-tagg skriven!';

  @override
  String get approachNfcTagMessage => 'Närma NFC-tagg...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab-format (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab-format';

  @override
  String get bambuLabFormatInfo =>
      'Detta format använder Bambu Lab-materialkoder och lagrar data i ett AMS-kompatibelt format.';

  @override
  String get brandLabel => 'Märke';

  @override
  String get materialTypeLabel => 'Materialtyp';

  @override
  String get serialNumber3Digits => 'Serienummer (3 siffror)';

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
      'Obs: Originala Bambu Lab-taggar använder RSA-kryptering. Detta läge skriver data i ett förenklat kompatibelt format.';

  @override
  String signInError(String error) {
    return 'Inloggningsfel: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Prenumeration aktiverad!';

  @override
  String get subscriptionFailedMessage => 'Prenumeration misslyckades';

  @override
  String errorMessage(String error) {
    return 'Fel: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Prenumeration återställd!';

  @override
  String get noSubscriptionFoundMessage => 'Ingen prenumeration hittades';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTIV';

  @override
  String get noAdsExperienceMessage => 'Njut av reklamfri upplevelse!';

  @override
  String get subscribedLabel => 'Prenumerant';

  @override
  String get restorePurchasesButton => 'Återställ köp';

  @override
  String get cannotExceedRemainingWeight =>
      'Kan inte överskrida kvarvarande vikt';

  @override
  String get pleaseEnterLength => 'Ange längd';

  @override
  String get pleaseEnterValidLength => 'Ange giltig längd';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Spollängd ej angiven - kan inte konvertera';

  @override
  String get exceedsRemainingWeight => 'Överskrider kvarvarande vikt';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Hjälp oss att identifiera detta filament';

  @override
  String get helpUsImprove => 'Hjälp oss att förbättra!';

  @override
  String get helpIdentifyDescription =>
      'Vi läste chippet men kunde inte identifiera det. Berätta för oss vilket filament det är så att vi kan förbättra appen.';

  @override
  String get otherBrand => 'Annat';

  @override
  String get thankYouFeedback => 'Tack för din feedback!';

  @override
  String get send => 'Skicka';

  @override
  String get optionalDetails => 'Valfria detaljer';

  @override
  String get weightGrams => 'Vikt (g)';

  @override
  String get diameterMm => 'Diameter (mm)';

  @override
  String get spoolLengthM => 'Spole längd (m)';

  @override
  String get batchNumberLabel => 'Batch / SKU';

  @override
  String get contactUs => 'Kontakta oss';

  @override
  String get contactUsSubtitle => 'Frågor, förslag eller problem';

  @override
  String get nfcTagNotDetected => 'Ingen NFC-tagg hittades';

  @override
  String get nfcTagNotDetectedDesc =>
      'Ingen tagg hittades. Taggen kan vara död, skadad eller för långt från telefonen.';

  @override
  String get nfcTagIncompatible => 'Inkompatibel NFC-tagg hittades';

  @override
  String get nfcAuthError => 'NFC-tagg autentisering misslyckades';

  @override
  String get nfcAuthErrorDesc =>
      'Taggen upptäcktes men autentiseringen misslyckades efter flera försök. Håll taggen stadigt mot baksidan av telefonen och försök igen.';

  @override
  String get nfcTagInfoPrusa =>
      'Använd en tom NXP ICODE SLIX2-tagg (ISO 15693) för att skapa OpenPrintTag-kompatibla taggar för Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Skriv Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Inloggning med Apple är inte tillgänglig på denna enhet.';

  @override
  String get signInAppleFailed =>
      'Inloggning med Apple misslyckades. Försök igen.';

  @override
  String get signInFailed => 'Inloggning misslyckades. Försök igen.';

  @override
  String get mustContain3Digits => 'Måste innehålla 3 siffror';

  @override
  String get mustBeNumber => 'Måste vara ett nummer';

  @override
  String generatedUidLabel(String uid) {
    return 'Genererat UID: $uid';
  }

  @override
  String get experimentalBadge => 'EXPERIMENTELL';

  @override
  String get newBadge => 'NY';

  @override
  String get forCrealityCfs => 'för Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Läs & skriv';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS-taggar använder MiFare Classic 1K med AES-128-ECB-kryptering.';

  @override
  String get platformLimitationTitle => 'Plattformsbegränsning';

  @override
  String get mifareClassicNotSupportedIos =>
      'MiFare Classic-taggar (Bambu Lab, Creality) stöds inte på iOS på grund av en Apple CoreNFC-begränsning.';

  @override
  String get nfcTagInfoCreality =>
      'Använd en MiFare Classic 1K-tagg för att skriva Creality CFS-kompatibla data för Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Röd, Blå, Svart...';

  @override
  String get dryingTemp => 'Torktemperatur';

  @override
  String get dryingTempHint => 't.ex. 55';

  @override
  String get dryingTime => 'Torktid (timmar)';

  @override
  String get dryingTimeHint => 't.ex. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tagg identifierad som $mode — byt flik för nästa skanningar';
  }

  @override
  String get fallbackChooseMode => 'Välj läge manuellt';

  @override
  String get fallbackChooseModeSubtitle =>
      'Automatisk identifiering kunde inte identifiera denna tagg. Välj protokollet:';

  @override
  String get tryAutoDetect => 'Prova automatisk identifiering';

  @override
  String get autoDetectAllBrands => 'Automatisk identifiering — alla märken';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D med flera';

  @override
  String get nfcTipIos =>
      'NFC-läsaren sitter högst upp på din iPhone. Placera den direkt på spolens NFC-tagg.';

  @override
  String get nfcTipAndroid =>
      'NFC-läsaren sitter vanligtvis mitt på baksidan av din telefon. Placera baksidan av telefonen på spolens NFC-tagg.';

  @override
  String get stockSortBy => 'Sortera';

  @override
  String get stockFilter => 'Filtrera';

  @override
  String get stockSortRecent => 'Senaste';

  @override
  String get stockSortBrand => 'Märke';

  @override
  String get stockSortMaterial => 'Material';

  @override
  String get stockSortRemaining => 'Återstående vikt';

  @override
  String get stockSortColor => 'Färg';

  @override
  String get stockFilterAll => 'Alla';

  @override
  String get stockResetFilters => 'Återställ';

  @override
  String get stockNoMatch => 'Ingen spole matchar filtren';

  @override
  String get nfcDisabledTitle => 'NFC avstängt';

  @override
  String get nfcDisabledMessage =>
      'NFC är avstängt. Slå på det i telefonens inställningar för att skanna dina spolar.';

  @override
  String get updateAvailableTitle => 'Uppdatering tillgänglig';

  @override
  String get updateAvailableMessage =>
      'En ny version av Spool Master är tillgänglig.';

  @override
  String get updateForcedMessage =>
      'Den här versionen stöds inte längre. Uppdatera för att fortsätta.';

  @override
  String get updateNow => 'Uppdatera';

  @override
  String get updateLater => 'Senare';

  @override
  String get nfcScanGuidance =>
      'Håll taggen stilla mot telefonens ovansida eller baksida.';

  @override
  String get tagMovedTitle => 'Taggen rörde sig';

  @override
  String get tagMovedMessage =>
      'Taggen rörde sig under avläsningen. Placera tillbaka den och håll telefonen stilla.';

  @override
  String get lightBlue => 'Ljusblå';

  @override
  String get transparent => 'Transparent';

  @override
  String get nfcActiveApproachTag => 'NFC aktiv — håll taggen nära';

  @override
  String addedToShoppingList(String item) {
    return '$item tillagd i inköpslistan';
  }

  @override
  String get deleteAccountFailed =>
      'Det gick inte att radera kontot. Försök igen.';

  @override
  String get scanHistoryError => 'Fel vid åtkomst till skanningshistorik';

  @override
  String get genericBrand => 'Generisk';

  @override
  String get stockSearchHint => 'Sök (märke, färg, plats…)';

  @override
  String get stockMoreActions => 'Fler åtgärder';

  @override
  String get exportExcel => 'Exportera till Excel';

  @override
  String get exportFailed => 'Exporten misslyckades';

  @override
  String get exportShareSubject => 'Mitt filamentlager (Spool Master)';

  @override
  String get exportColorHex => 'Färgkod';

  @override
  String get exportRemainingPercent => 'Kvar (%)';

  @override
  String get exportPricePerKg => 'Pris / kg';

  @override
  String get exportAddedDate => 'Tillagd den';

  @override
  String get exportOrdered => 'Beställd';

  @override
  String get exportDate => 'Datum';

  @override
  String get exportGrams => 'Gram';

  @override
  String get exportCost => 'Kostnad';

  @override
  String get importSpools => 'Importera (CSV / Excel)';

  @override
  String get importConfirmTitle => 'Importera spolar';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return 'Spolar att lägga till: $count\nRedan i lager (hoppas över): $duplicates\nOläsliga rader (hoppas över): $skipped';
  }

  @override
  String get importAction => 'Importera';

  @override
  String get importNothingFound =>
      'Inga spolar hittades. Filen måste innehålla minst kolumnerna Material och Vikt (som appens Excel-export).';

  @override
  String importDone(int count) {
    return 'Importerade spolar: $count';
  }

  @override
  String get importFailed => 'Filen kan inte läsas';

  @override
  String get location => 'Plats';

  @override
  String get locationHint => 'T.ex. Hylla A, torrbox 2';

  @override
  String get notes => 'Anteckningar';

  @override
  String get notesHint => 'T.ex. torka före användning';

  @override
  String get printCostTitle => 'Utskriftskostnad';

  @override
  String get printCostGrams => 'Använt filament (g)';

  @override
  String printCostResult(String cost) {
    return 'Materialkostnad: $cost';
  }

  @override
  String printCostPerKg(String price) {
    return 'Pris per kg: $price';
  }

  @override
  String get printCostNoPrice =>
      'Lägg till spolens pris för att beräkna kostnaden.';

  @override
  String get printCostDeduct => 'Dra av från lagret';

  @override
  String printCostDeducted(String grams) {
    return '$grams g avdraget från lagret';
  }

  @override
  String get consumptionTitle => 'Förbrukning';

  @override
  String get consumptionLast30Days => 'Senaste 30 dagarna';

  @override
  String get consumptionThisMonth => 'Den här månaden';

  @override
  String get consumptionByMaterial => 'Per material (30 dagar)';

  @override
  String get consumptionMonthly => 'Senaste 6 månaderna';

  @override
  String get consumptionEmpty =>
      'Ingen förbrukning registrerad ännu. Den visas så fort du uppdaterar en spoles återstående vikt eller använder kostnadskalkylatorn.';

  @override
  String get shareShoppingList => 'Dela listan';

  @override
  String get nfcBlankTagTitle => 'Tom tagg';

  @override
  String get nfcBlankTagDesc =>
      'Den här taggen innehåller inga spoldata. Lägg till spolen manuellt eller skriv taggen i appen.';

  @override
  String get subscriptionAutoRenewDisclosure =>
      'Betalningen debiteras ditt butikskonto när köpet bekräftas. Prenumerationen förnyas automatiskt om den inte sägs upp minst 24 timmar före slutet av den aktuella perioden; förnyelsen debiteras inom 24 timmar före periodens slut. Du kan hantera eller säga upp din prenumeration i inställningarna för ditt butikskonto.';

  @override
  String get manageSubscription => 'Hantera prenumeration';
}
