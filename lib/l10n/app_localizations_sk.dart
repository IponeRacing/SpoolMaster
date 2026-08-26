// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Sklad';

  @override
  String get statistics => 'Analytika';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Čítať NFC čip';

  @override
  String get scanHistory => 'História';

  @override
  String get writeNfcChip => 'Zapísať NFC čip';

  @override
  String get nfcNotAvailable => 'NFC nie je k dispozícii';

  @override
  String get nfcNotAvailableDesc =>
      'Vaše zariadenie nepodporuje NFC alebo je deaktivované.';

  @override
  String get nfcNotSupported => 'NFC nie je podporované na tomto zariadení';

  @override
  String get approachNfcChip => 'Priblížte NFC čip...';

  @override
  String get scanningNfc => 'Skenovanie...';

  @override
  String get nfcDataRead => 'NFC údaje úspešne prečítané!';

  @override
  String get errorReadingNfc => 'Chyba pri čítaní NFC';

  @override
  String get scanHistoryTitle => 'História skenovania';

  @override
  String get noScansRecorded => 'Žiadne zaznamenané skenovania';

  @override
  String get scansWillAppearHere => 'NFC skenovania sa objavia tu automaticky';

  @override
  String get clearAll => 'Vymazať všetko';

  @override
  String get deleteThisScan => 'Vymazať toto skenovanie?';

  @override
  String get actionIrreversible => 'Táto akcia je nevratná.';

  @override
  String get cancel => 'Zrušiť';

  @override
  String get delete => 'Vymazať';

  @override
  String get clearAllHistory => 'Vymazať celú históriu?';

  @override
  String get allScansWillBeDeleted =>
      'Všetky skenovania budú vymazané. Táto akcia je nevratná.';

  @override
  String get scanDeleted => 'Skenovanie vymazané';

  @override
  String get scanDetails => 'Podrobnosti skenovania';

  @override
  String scannedOn(Object date) {
    return 'Naskenované $date';
  }

  @override
  String get bobbinInformation => 'Informácie o cievke';

  @override
  String get filamentType => 'Typ filamentu';

  @override
  String get color => 'Farba';

  @override
  String get weight => 'Hmotnosť';

  @override
  String get manufacturingDate => 'Dátum výroby';

  @override
  String get batchNumber => 'Číslo šarže';

  @override
  String get printerSettings => 'Nastavenia tlačiarne';

  @override
  String get scanMetadata => 'Metadáta skenovania';

  @override
  String get scanId => 'ID skenovania';

  @override
  String get dateAndTime => 'Dátum a čas';

  @override
  String get reuseThisData => 'Znovu použiť tieto údaje';

  @override
  String get writeToNfc => 'Zapísať do NFC';

  @override
  String get writeDataToChip => 'Zapísať údaje do čipu';

  @override
  String get writeSuccess => 'Úspešný zápis!';

  @override
  String get writeError => 'Chyba zápisu';

  @override
  String get brand => 'Značka';

  @override
  String get selectBrand => 'Vyberte značku';

  @override
  String get materialType => 'Typ materiálu';

  @override
  String get selectMaterial => 'Vyberte materiál';

  @override
  String get serialNumber => 'Sériové číslo';

  @override
  String get serialNumberHint => 'napr.: 001';

  @override
  String get initialWeight => 'Počiatočná hmotnosť';

  @override
  String get initialWeightHint => 'napr.: 1000';

  @override
  String get extruderTempMin => 'Min. teplota extrudéra';

  @override
  String get extruderTempMax => 'Max. teplota extrudéra';

  @override
  String get bedTempMin => 'Min. teplota podložky';

  @override
  String get bedTempMax => 'Max. teplota podložky';

  @override
  String get diameter => 'Priemer filamentu';

  @override
  String get spoolLength => 'Dĺžka cievky';

  @override
  String get generatedSku => 'Vygenerované SKU';

  @override
  String get approachChipToWrite => 'Priblížte čip na zápis...';

  @override
  String get writing => 'Zapisovanie...';

  @override
  String get chooseColor => 'Vyberte farbu';

  @override
  String get required => 'Povinné';

  @override
  String get invalid => 'Neplatné';

  @override
  String get advancedSettings => 'Pokročilé nastavenia';

  @override
  String get opacity => 'Priehľadnosť';

  @override
  String get validate => 'Potvrdiť';

  @override
  String get nfcTagInfo =>
      'Použite prázdnu ISO14443A NFC značku (NTAG213) na vytvorenie vlastných Anycubic značiek.';

  @override
  String get stockInventory => 'Cievky na sklade';

  @override
  String get addSpool => 'Pridať cievku';

  @override
  String get scanSpool => 'Skenovať cievku';

  @override
  String get addManually => 'Pridať manuálne';

  @override
  String get spoolAdded => 'Cievka pridaná';

  @override
  String get spoolUpdated => 'Cievka aktualizovaná';

  @override
  String get noSpoolsInStock => 'Žiadne cievky na sklade';

  @override
  String get addFirstSpool =>
      'Pridajte svoju prvú cievku, aby ste mohli sledovať svoj inventár';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count cievka/cievky s nízkym stavom (< $threshold%)';
  }

  @override
  String get edit => 'Upraviť';

  @override
  String get bobbinPrice => 'Cena cievky';

  @override
  String get price => 'Cena';

  @override
  String get priceHint => 'napr.: 25.00';

  @override
  String get save => 'Uložiť';

  @override
  String get spoolDetails => 'Podrobnosti cievky';

  @override
  String get deleteThisSpool => 'Vymazať túto cievku?';

  @override
  String get cannotBeUndone => 'Túto akciu nie je možné vrátiť späť.';

  @override
  String get addSpoolManually => 'Manuálne pridanie cievky';

  @override
  String get editSpool => 'Upraviť cievku';

  @override
  String get customBrand => 'Vlastná značka';

  @override
  String get customBrandHint => 'napr.: Moja značka';

  @override
  String get chooseFromList => 'Vybrať zo zoznamu';

  @override
  String get addBrand => '+ Pridať značku';

  @override
  String get customMaterial => 'Vlastný materiál';

  @override
  String get customMaterialHint => 'napr.: Môj materiál';

  @override
  String get addMaterial => '+ Pridať materiál';

  @override
  String get colorHint => 'napr.: Modrá, Červená...';

  @override
  String get enterColor => 'Prosím, zadajte farbu';

  @override
  String get initialWeightG => 'Počiatočná hmotnosť';

  @override
  String get remainingWeightG => 'Zostávajúca hmotnosť';

  @override
  String get enterBrand => 'Prosím, zadajte značku';

  @override
  String get selectOrEnterBrand => 'Prosím, vyberte alebo zadajte značku';

  @override
  String get quantity => 'Množstvo';

  @override
  String get quantityHelper => 'Pridajte viac rovnakých cievok naraz';

  @override
  String get quantityInvalid => 'Zadajte číslo od 1 do 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count na sklade';
  }

  @override
  String get enterMaterial => 'Prosím, zadajte materiál';

  @override
  String get selectOrEnterMaterial => 'Prosím, vyberte alebo zadajte materiál';

  @override
  String get enterPrice => 'Prosím, zadajte cenu';

  @override
  String get enterValidPrice => 'Prosím, zadajte platnú cenu';

  @override
  String get enterWeight => 'Prosím, zadajte hmotnosť';

  @override
  String get enterValidWeight => 'Prosím, zadajte platnú hmotnosť';

  @override
  String get remainingCannotExceedTotal =>
      'Zostávajúca hmotnosť nemôže presiahnuť celkovú hmotnosť';

  @override
  String get overview => 'Prehľad';

  @override
  String get spoolsInStock => 'Cievky na sklade';

  @override
  String get totalValue => 'Celková hodnota';

  @override
  String get lowStockSpools => 'Nízky stav';

  @override
  String get materialDistribution => 'Rozdelenie podľa materiálu';

  @override
  String get brandDistribution => 'Rozdelenie podľa značky';

  @override
  String get noData => 'Žiadne údaje';

  @override
  String get refresh => 'Obnoviť';

  @override
  String get profileSettings => 'Nastavenia profilu';

  @override
  String get preferences => 'Preferencie';

  @override
  String get language => 'Jazyk';

  @override
  String get selectLanguage => 'Vyberte jazyk';

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
  String get currency => 'Mena';

  @override
  String get selectCurrency => 'Vyberte menu';

  @override
  String get units => 'Jednotky';

  @override
  String get selectUnits => 'Vyberte jednotky';

  @override
  String get metric => 'Metrické (mm, g, °C)';

  @override
  String get imperial => 'Imperiálne (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Prah upozornenia na nízky stav';

  @override
  String get lowStockThresholdDesc =>
      'Cievka sa bude považovať za nízky stav, ak je zostávajúca hmotnosť menšia ako toto percento';

  @override
  String get authentication => 'Autentifikácia';

  @override
  String get signInWithGoogle => 'Prihlásiť sa cez Google';

  @override
  String get signInWithApple => 'Prihlásiť sa cez Apple';

  @override
  String get continueWithApple => 'Pokračovať s Apple';

  @override
  String get continueWithGoogle => 'Pokračovať s Google';

  @override
  String get comingSoon => 'Čoskoro';

  @override
  String get about => 'O aplikácii';

  @override
  String get version => 'Verzia';

  @override
  String get madeWith => 'Vytvorené s ❤️ pre 3D tlačiarne Anycubic';

  @override
  String get scanBobbinDirectly => 'Skenovať cievku';

  @override
  String get nfcEncoder => 'NFC enkodér';

  @override
  String get length => 'Dĺžka';

  @override
  String get tempExtruder => 'Teplota extrudéra';

  @override
  String get tempBed => 'Teplota podložky';

  @override
  String get termsOfService => 'Podmienky používania';

  @override
  String get privacyPolicy => 'Zásady ochrany osobných údajov';

  @override
  String get legal => 'Právne';

  @override
  String get back => 'Späť';

  @override
  String get retry => 'Skúsiť znova';

  @override
  String get signOut => 'Odhlásiť sa';

  @override
  String get extruderTempMinHint => 'Napr.: 200';

  @override
  String get extruderTempMaxHint => 'Napr.: 220';

  @override
  String get bedTempMinHint => 'Napr.: 50';

  @override
  String get bedTempMaxHint => 'Napr.: 60';

  @override
  String get diameterHint => 'Napr.: 1.75';

  @override
  String get spoolLengthHint => 'Napr.: 330';

  @override
  String get tabGrid => 'Mriežka';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Posúvače';

  @override
  String get hexCode => 'Hex kód';

  @override
  String get red => 'Červená';

  @override
  String get green => 'Zelená';

  @override
  String get blue => 'Modrá';

  @override
  String get black => 'Čierna';

  @override
  String get white => 'Biela';

  @override
  String get yellow => 'Žltá';

  @override
  String get orange => 'Oranžová';

  @override
  String get pink => 'Ružová';

  @override
  String get purple => 'Fialová';

  @override
  String get gray => 'Sivá';

  @override
  String get brown => 'Hnedá';

  @override
  String get unknown => 'Neznáma';

  @override
  String get metricUnits => 'Metrické (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperiálne (in, oz, °F)';

  @override
  String get chf => 'Švajčiarsky frank (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Americký dolár (\$)';

  @override
  String get gbp => 'Libra šterlingov (£)';

  @override
  String get cad => 'Kanadský dolár (CAD)';

  @override
  String get aud => 'Austrálsky dolár (A\$)';

  @override
  String get jpy => 'Japonský jen (¥)';

  @override
  String get cny => 'Čínsky jüan (¥)';

  @override
  String get inr => 'Indická rupia (₹)';

  @override
  String get brl => 'Brazílsky real (R\$)';

  @override
  String get mxn => 'Mexické peso (MX\$)';

  @override
  String get sek => 'Švédska koruna (kr)';

  @override
  String get nok => 'Nórska koruna (kr)';

  @override
  String get dkk => 'Dánska koruna (kr)';

  @override
  String get pln => 'Poľský zlotý (zł)';

  @override
  String get czk => 'Česká koruna (Kč)';

  @override
  String get nzd => 'Novozélandský dolár (NZ\$)';

  @override
  String get filamentsToOrder => 'Filamenty na objednanie';

  @override
  String get shoppingList => 'Nákupný zoznam';

  @override
  String get addToShoppingList => 'Pridať do zoznamu';

  @override
  String get noLowStockFilaments => 'Žiadne filamenty s nízkym stavom';

  @override
  String get vipSubscriptionDescription =>
      'Toto predplatné sa používa len na deaktiváciu reklám v aplikácii a podporu projektu. Žiadne ďalšie funkcie.';

  @override
  String get monthlySubscription => 'Mesačné predplatné';

  @override
  String get yearlySubscription => 'Ročné predplatné';

  @override
  String get perMonth => '/ mesiac';

  @override
  String get perYear => '/ rok';

  @override
  String onlyPerMonth(String price) {
    return 'Len $price / mesiac';
  }

  @override
  String get subscribe => 'Prihlásiť sa na odber';

  @override
  String get bestOffer => '✨ NAJLEPŠIA PONUKA ✨';

  @override
  String get forAnycubicAce => 'pre Anycubic Ace';

  @override
  String get forBambuLabAms => 'pre Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Skenovať NFC čip';

  @override
  String get fillForm => 'Vyplniť formulár';

  @override
  String get emptyShoppingList => 'Žiadne filamenty v zozname';

  @override
  String percentRemaining(String percent) {
    return '$percent% zostáva';
  }

  @override
  String get markAsOrdered => 'Označiť ako objednané';

  @override
  String get markAsNotOrdered => 'Označiť ako neobjednané';

  @override
  String get notSignedIn => 'Nie ste prihlásení';

  @override
  String get signIn => 'Prihlásiť sa';

  @override
  String get connection => 'Pripojenie';

  @override
  String get signInToSync => 'Prihláste sa na synchronizáciu údajov';

  @override
  String get continueWithoutAccount => 'Pokračovať bez účtu (lokálny režim)';

  @override
  String get privacyNotice =>
      'Prihlásením súhlasíte s našimi\nPodmienkami používania a Zásadami ochrany osobných údajov';

  @override
  String get updateStock => 'Aktualizovať zásobu';

  @override
  String get scanToUpdateStock => 'Skenovať na aktualizáciu';

  @override
  String get weightUsed => 'Použitá hmotnosť';

  @override
  String get lengthUsed => 'Použitá dĺžka';

  @override
  String get enterWeightOrLength => 'Zadajte použitú hmotnosť alebo dĺžku';

  @override
  String get weightUsedG => 'Použitá hmotnosť (g)';

  @override
  String get lengthUsedM => 'Použitá dĺžka (m)';

  @override
  String get stockUpdated => 'Zásoba aktualizovaná';

  @override
  String get scanSpoolToUpdate => 'Skenujte cievku na aktualizáciu jej zásoby';

  @override
  String get spoolNotFound => 'Cievka sa nenašla v zásobe';

  @override
  String get addSpoolFirstMessage =>
      'Táto cievka zatiaľ nie je vo vašej zásobe. Najprv ju pridajte pomocou tlačidla \'Pridať cievku\' pred aktualizáciou zásoby.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Iba na čítanie';

  @override
  String get bambuLabReadOnlyDesc =>
      'Značky Bambu Lab používajú šifrovanie RSA a nemôžu sa upravovať. Iba na čítanie.';

  @override
  String get forPrusaMk4 => 'pre Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Čítanie a zápis';

  @override
  String get prusaReadWriteDesc =>
      'Prusa tagy používajú ISO 15693 (NFC-V) s formátom OpenPrintTag. Čítanie a zápis sú podporované.';

  @override
  String get bambuCloneLibrary => 'Knižnica klonov Bambu Lab';

  @override
  String get noBambuClones => 'Žiadne klony Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Naskenujte originálne značky Bambu Lab na vytvorenie knižnice klonov';

  @override
  String get scanTag => 'Skenovať značku';

  @override
  String get syncWithCloud => 'Synchronizovať s cloudom';

  @override
  String get syncCompleted => 'Synchronizácia dokončená';

  @override
  String get deleteClone => 'Vymazať klon';

  @override
  String get renameClone => 'Premenovať klon';

  @override
  String get rename => 'Premenovať';

  @override
  String get customName => 'Vlastný názov';

  @override
  String get clonedOn => 'Klonované';

  @override
  String get writeThisClone => 'Zapísať tento klon';

  @override
  String get writeClone => 'Zapísať klon';

  @override
  String get writeOnCUID => 'Zapísať na kartu CUID';

  @override
  String get cloneWrittenSuccess => 'Klon úspešne zapísaný!';

  @override
  String get requiredTagFormat => 'Požadovaný formát značky';

  @override
  String get type => 'Typ';

  @override
  String get frequency => 'Frekvencia';

  @override
  String get protocol => 'Protokol';

  @override
  String get capacity => 'Kapacita';

  @override
  String get feature => 'Funkcia';

  @override
  String get uidModifiable => 'Blok 0 (UID) upraviteľný';

  @override
  String get whereToBuy =>
      'Vyhľadajte \"CUID MiFare Classic 1K\" na AliExpress, Amazon alebo eBay (~\$0.50/kus)';

  @override
  String get magicGen2Required =>
      'Karta Magic Gen2 - MiFare Classic 1K so zapisovateľným Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Hľadajte \"Magic Gen2 MiFare Classic 1K\" alebo \"UID writable\" na AliExpress, Amazon alebo eBay (~\$0.50/kus)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Upozornenie: Zápis pomocou iPhone NFC nemusí fungovať na všetkých kartách Magic Gen2. Pre maximálnu spoľahlivosť odporúčame zariadenie Proxmark3.';

  @override
  String get step1GetMagicGen2 =>
      'Získajte prázdnu kartu Magic Gen2 (MiFare Classic 1K so zapisovateľným UID)';

  @override
  String get instructions => 'Pokyny';

  @override
  String get step1GetCUID => 'Získajte prázdnu kartu CUID (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Stlačte tlačidlo \"Zapísať\" nižšie';

  @override
  String get step3HoldPhone => 'Pridržte telefón pri karte CUID';

  @override
  String get step4WaitConfirm => 'Počkajte na potvrdenie zápisu';

  @override
  String get step5TestClone =>
      'Otestujte naklonovanú značku na tlačiarni Bambu Lab!';

  @override
  String get rsaIncluded =>
      'Klon obsahuje originálny RSA podpis, bude akceptovaný tlačiarňou!';

  @override
  String get cloneDeleted => 'Klon vymazaný';

  @override
  String get deleteAccount => 'Vymazať môj účet';

  @override
  String get deleteAccountConfirmation =>
      'Táto akcia je nezvratná. Váš účet a všetky údaje budú vymazané do 30 dní.';

  @override
  String get accountDeletionRequested => 'Žiadosť o vymazanie zaregistrovaná';

  @override
  String get clearShoppingList => 'Vymazať zoznam';

  @override
  String get clearShoppingListConfirmation =>
      'Naozaj chcete vymazať celý nákupný zoznam? Túto akciu nie je možné vrátiť späť.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'História';

  @override
  String get retryButton => 'Skúsiť znova';

  @override
  String get readSuccessMessage => 'Čítanie úspešné!';

  @override
  String get filamentTypeLabel => 'Typ filamentu';

  @override
  String get scanNfcChipButton => 'Skenovať NFC čip';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Vymazať klon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klon \"$name\" vymazaný';
  }

  @override
  String get extruderLabel => 'Extrudér';

  @override
  String get writeThisCloneButton => 'Zapísať tento klon';

  @override
  String get customNameHint => 'Vlastný názov';

  @override
  String get cloneWriteSuccessMessage => 'Klon úspešne zapísaný!';

  @override
  String errorPrefix(String error) {
    return 'Chyba: $error';
  }

  @override
  String get writingInProgress => 'Zapisovanie...';

  @override
  String get writeOnCUIDButton => 'Zapísať na CUID kartu';

  @override
  String get diameterLabel => 'Priemer';

  @override
  String get extruderTempLabel => 'Teplota extrudéra';

  @override
  String get bedTempLabel => 'Teplota podložky';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bajtov (1024 bajtov)';

  @override
  String get rsaSignatureNote =>
      'Klon obsahuje pôvodný RSA podpis, bude prijatý tlačiarňou!';

  @override
  String get writeBambuLabTagTitle => 'Zapísať Bambu Lab štítok';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab štítok úspešne zapísaný!';

  @override
  String get approachNfcTagMessage => 'Priložte NFC štítok...';

  @override
  String get bambuLabFormatMiFare => 'Formát Bambu Lab (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Formát Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Tento formát používa materiálové kódy Bambu Lab a ukladá dáta v AMS kompatibilnom formáte.';

  @override
  String get brandLabel => 'Značka';

  @override
  String get materialTypeLabel => 'Typ materiálu';

  @override
  String get serialNumber3Digits => 'Sériové číslo (3 číslice)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (štandardný)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Zapísať Bambu Lab štítok';

  @override
  String get bambuLabRsaNote =>
      'Poznámka: Originálne Bambu Lab štítky používajú RSA šifrovanie. Tento režim zapisuje dáta v zjednodušenom kompatibilnom formáte.';

  @override
  String signInError(String error) {
    return 'Chyba prihlásenia: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Predplatné úspešne aktivované!';

  @override
  String get subscriptionFailedMessage => 'Predplatné zlyhalo';

  @override
  String errorMessage(String error) {
    return 'Chyba: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Predplatné úspešne obnovené!';

  @override
  String get noSubscriptionFoundMessage => 'Predplatné nenájdené';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTÍVNE';

  @override
  String get noAdsExperienceMessage => 'Užite si zážitok bez reklám!';

  @override
  String get subscribedLabel => 'Predplatiteľ';

  @override
  String get restorePurchasesButton => 'Obnoviť nákupy';

  @override
  String get cannotExceedRemainingWeight =>
      'Nemôže prekročiť zostávajúcu hmotnosť';

  @override
  String get pleaseEnterLength => 'Zadajte dĺžku';

  @override
  String get pleaseEnterValidLength => 'Zadajte platnú dĺžku';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Dĺžka cievky nie je nastavená - nie je možné previesť';

  @override
  String get exceedsRemainingWeight => 'Prekračuje zostávajúcu hmotnosť';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Pomôžte nám identifikovať tento filament';

  @override
  String get helpUsImprove => 'Pomôžte nám zlepšiť sa!';

  @override
  String get helpIdentifyDescription =>
      'Prečítali sme čip, ale nedokázali sme ho identifikovať. Povedzte nám, aký je to filament, aby sme mohli vylepšiť aplikáciu.';

  @override
  String get otherBrand => 'Iná';

  @override
  String get thankYouFeedback => 'Ďakujeme za vašu spätnú väzbu!';

  @override
  String get send => 'Odoslať';

  @override
  String get optionalDetails => 'Voliteľné detaily';

  @override
  String get weightGrams => 'Hmotnosť (g)';

  @override
  String get diameterMm => 'Priemer (mm)';

  @override
  String get spoolLengthM => 'Dĺžka cievky (m)';

  @override
  String get batchNumberLabel => 'Šarža / SKU';

  @override
  String get contactUs => 'Kontaktujte nás';

  @override
  String get contactUsSubtitle => 'Otázky, návrhy alebo problémy';

  @override
  String get nfcTagNotDetected => 'Nebol zistený žiadny NFC tag';

  @override
  String get nfcTagNotDetectedDesc =>
      'Nebol nájdený žiadny tag. Tag môže byť mŕtvy, poškodený alebo príliš ďaleko od telefónu.';

  @override
  String get nfcTagIncompatible => 'Zistený nekompatibilný NFC tag';

  @override
  String get nfcAuthError => 'Overenie NFC tagu zlyhalo';

  @override
  String get nfcAuthErrorDesc =>
      'Tag bol detekovaný, ale overenie zlyhalo po niekoľkých pokusoch. Držte tag pevne pritlačený k zadnej strane telefónu a skúste to znova.';

  @override
  String get nfcTagInfoPrusa =>
      'Použite prázdnu NXP ICODE SLIX2 značku (ISO 15693) na vytvorenie značiek kompatibilných s OpenPrintTag pre Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Zapísať Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Prihlásenie cez Apple nie je na tomto zariadení k dispozícii.';

  @override
  String get signInAppleFailed =>
      'Prihlásenie cez Apple zlyhalo. Skúste to prosím znova.';

  @override
  String get signInFailed => 'Prihlásenie zlyhalo. Skúste to prosím znova.';

  @override
  String get mustContain3Digits => 'Musí obsahovať 3 číslice';

  @override
  String get mustBeNumber => 'Musí byť číslo';

  @override
  String generatedUidLabel(String uid) {
    return 'Vygenerované UID: $uid';
  }

  @override
  String get experimentalBadge => 'EXPERIMENTÁLNE';

  @override
  String get newBadge => 'NOVÉ';

  @override
  String get forCrealityCfs => 'pre Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Čítanie a zápis';

  @override
  String get crealityReadWriteDesc =>
      'Tagy Creality CFS používajú MiFare Classic 1K so šifrovaním AES-128-ECB. Čítanie a zápis podporovaný iba na Androide.';

  @override
  String get platformLimitationTitle => 'Obmedzenie platformy';

  @override
  String get mifareClassicNotSupportedIos =>
      'Tagy MiFare Classic (Bambu Lab, Creality) nie sú na iOS podporované kvôli obmedzeniu Apple CoreNFC. Táto funkcia je dostupná iba na Androide.';

  @override
  String get nfcTagInfoCreality =>
      'Použite tag MiFare Classic 1K na zápis údajov kompatibilných s Creality CFS pre Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Červená, Modrá, Čierna...';

  @override
  String get dryingTemp => 'Température de séchage';

  @override
  String get dryingTempHint => 'ex. 55';

  @override
  String get dryingTime => 'Temps de séchage (heures)';

  @override
  String get dryingTimeHint => 'ex. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tag detegovaný ako $mode — prepnite záložku pre ďalšie skeny';
  }

  @override
  String get fallbackChooseMode => 'Vybrať režim ručne';

  @override
  String get fallbackChooseModeSubtitle =>
      'Automatická detekcia nemohla identifikovať tento tag. Vyberte protokol:';

  @override
  String get tryAutoDetect => 'Skúsiť automatickú detekciu';

  @override
  String get autoDetectAllBrands => 'Automatická detekcia — všetky značky';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D a ďalšie';

  @override
  String get nfcTipIos =>
      'NFC čítačka je hore na vašom iPhone. Priložte ho priamo na NFC tag cievky.';

  @override
  String get nfcTipAndroid =>
      'NFC čítačka je zvyčajne v strede zadnej strany telefónu. Priložte zadnú stranu telefónu na NFC tag cievky.';

  @override
  String get stockSortBy => 'Zoradiť';

  @override
  String get stockFilter => 'Filter';

  @override
  String get stockSortRecent => 'Najnovšie';

  @override
  String get stockSortBrand => 'Značka';

  @override
  String get stockSortMaterial => 'Materiál';

  @override
  String get stockSortRemaining => 'Zostávajúca hmotnosť';

  @override
  String get stockSortColor => 'Farba';

  @override
  String get stockFilterAll => 'Všetko';

  @override
  String get stockResetFilters => 'Obnoviť';

  @override
  String get stockNoMatch => 'Žiadna cievka nezodpovedá filtrom';

  @override
  String get nfcDisabledTitle => 'NFC vypnuté';

  @override
  String get nfcDisabledMessage =>
      'NFC je vypnuté. Zapnite ho v nastaveniach telefónu, aby ste mohli skenovať cievky.';

  @override
  String get updateAvailableTitle => 'Dostupná aktualizácia';

  @override
  String get updateAvailableMessage => 'Je dostupná nová verzia Spool Master.';

  @override
  String get updateForcedMessage =>
      'Táto verzia už nie je podporovaná. Aktualizujte, prosím, aby ste mohli pokračovať.';

  @override
  String get updateNow => 'Aktualizovať';

  @override
  String get updateLater => 'Neskôr';

  @override
  String get nfcScanGuidance =>
      'Držte tag nehybne pri hornej alebo zadnej časti telefónu.';

  @override
  String get tagMovedTitle => 'Tag sa pohol';

  @override
  String get tagMovedMessage =>
      'Tag sa počas čítania pohol. Priložte ho znova a držte telefón nehybne.';
}
