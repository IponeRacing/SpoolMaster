// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Sklad';

  @override
  String get statistics => 'Statistiky';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Číst NFC čip';

  @override
  String get scanHistory => 'Historie';

  @override
  String get writeNfcChip => 'Zapsat NFC čip';

  @override
  String get nfcNotAvailable => 'NFC není k dispozici';

  @override
  String get nfcNotAvailableDesc =>
      'Vaše zařízení nepodporuje NFC nebo je vypnuté.';

  @override
  String get nfcNotSupported => 'NFC není podporováno na tomto zařízení';

  @override
  String get approachNfcChip => 'Přibližte NFC čip...';

  @override
  String get scanningNfc => 'Skenování...';

  @override
  String get nfcDataRead => 'NFC data úspěšně přečtena!';

  @override
  String get errorReadingNfc => 'Chyba čtení NFC';

  @override
  String get scanHistoryTitle => 'Historie skenování';

  @override
  String get noScansRecorded => 'Žádné záznamy skenů';

  @override
  String get scansWillAppearHere => 'NFC skeny se zde zobrazí automaticky';

  @override
  String get clearAll => 'Vymazat vše';

  @override
  String get deleteThisScan => 'Smazat tento sken?';

  @override
  String get actionIrreversible => 'Tato akce je nevratná.';

  @override
  String get cancel => 'Zrušit';

  @override
  String get delete => 'Smazat';

  @override
  String get clearAllHistory => 'Vymazat celou historii?';

  @override
  String get allScansWillBeDeleted =>
      'Všechny skeny budou smazány. Tato akce je nevratná.';

  @override
  String get scanDeleted => 'Sken smazán';

  @override
  String get scanDetails => 'Detaily skenu';

  @override
  String scannedOn(Object date) {
    return 'Naskenováno $date';
  }

  @override
  String get bobbinInformation => 'Informace o cívce';

  @override
  String get filamentType => 'Typ filamentu';

  @override
  String get color => 'Barva';

  @override
  String get weight => 'Hmotnost';

  @override
  String get manufacturingDate => 'Datum výroby';

  @override
  String get batchNumber => 'Číslo šarže';

  @override
  String get printerSettings => 'Nastavení tiskárny';

  @override
  String get scanMetadata => 'Metadata skenu';

  @override
  String get scanId => 'ID skenu';

  @override
  String get dateAndTime => 'Datum a čas';

  @override
  String get reuseThisData => 'Znovu použít tato data';

  @override
  String get writeToNfc => 'Zapsat do NFC';

  @override
  String get writeDataToChip => 'Zapsat data na čip';

  @override
  String get writeSuccess => 'Zápis úspěšný!';

  @override
  String get writeError => 'Chyba zápisu';

  @override
  String get brand => 'Značka';

  @override
  String get selectBrand => 'Vybrat značku';

  @override
  String get materialType => 'Typ materiálu';

  @override
  String get selectMaterial => 'Vybrat materiál';

  @override
  String get serialNumber => 'Sériové číslo';

  @override
  String get serialNumberHint => 'např.: 001';

  @override
  String get initialWeight => 'Počáteční hmotnost';

  @override
  String get initialWeightHint => 'např.: 1000';

  @override
  String get extruderTempMin => 'Teplota extruderu min';

  @override
  String get extruderTempMax => 'Teplota extruderu max';

  @override
  String get bedTempMin => 'Teplota podložky min';

  @override
  String get bedTempMax => 'Teplota podložky max';

  @override
  String get diameter => 'Průměr';

  @override
  String get spoolLength => 'Délka (m)';

  @override
  String get generatedSku => 'Vygenerované SKU';

  @override
  String get approachChipToWrite => 'Přibližte čip pro zápis...';

  @override
  String get writing => 'Zapisování...';

  @override
  String get chooseColor => 'Vybrat barvu';

  @override
  String get required => 'Povinné';

  @override
  String get invalid => 'Neplatné';

  @override
  String get advancedSettings => 'Pokročilé nastavení';

  @override
  String get opacity => 'Průhlednost';

  @override
  String get validate => 'Potvrdit';

  @override
  String get nfcTagInfo =>
      'Použijte prázdnou NFC značku ISO14443A (NTAG213) pro vytvoření vlastních Anycubic značek.';

  @override
  String get stockInventory => 'Cívky na skladě';

  @override
  String get addSpool => 'Přidat cívku';

  @override
  String get scanSpool => 'Skenovat cívku';

  @override
  String get addManually => 'Přidat ručně';

  @override
  String get spoolAdded => 'Cívka přidána';

  @override
  String get spoolUpdated => 'Cívka aktualizována';

  @override
  String get noSpoolsInStock => 'Žádné cívky na skladě';

  @override
  String get addFirstSpool => 'Přidejte první cívku pro sledování zásob';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count cívka/cívek s nízkými zásobami (< $threshold%)';
  }

  @override
  String get edit => 'Upravit';

  @override
  String get bobbinPrice => 'Cena cívky';

  @override
  String get price => 'Cena';

  @override
  String get priceHint => 'např.: 25.00';

  @override
  String get save => 'Uložit';

  @override
  String get spoolDetails => 'Detaily cívky';

  @override
  String get deleteThisSpool => 'Smazat tuto cívku?';

  @override
  String get cannotBeUndone => 'Tuto akci nelze vrátit zpět.';

  @override
  String get addSpoolManually => 'Přidat cívku ručně';

  @override
  String get editSpool => 'Upravit cívku';

  @override
  String get customBrand => 'Vlastní značka';

  @override
  String get customBrandHint => 'např.: Moje značka';

  @override
  String get chooseFromList => 'Vybrat ze seznamu';

  @override
  String get addBrand => '+ Přidat značku';

  @override
  String get customMaterial => 'Vlastní materiál';

  @override
  String get customMaterialHint => 'např.: Můj materiál';

  @override
  String get addMaterial => '+ Přidat materiál';

  @override
  String get colorHint => 'např.: Modrá, Červená...';

  @override
  String get enterColor => 'Zadejte barvu';

  @override
  String get initialWeightG => 'Počáteční hmotnost';

  @override
  String get remainingWeightG => 'Zbývající hmotnost';

  @override
  String get enterBrand => 'Zadejte značku';

  @override
  String get selectOrEnterBrand => 'Vyberte nebo zadejte značku';

  @override
  String get enterMaterial => 'Zadejte materiál';

  @override
  String get selectOrEnterMaterial => 'Vyberte nebo zadejte materiál';

  @override
  String get enterPrice => 'Zadejte cenu';

  @override
  String get enterValidPrice => 'Zadejte platnou cenu';

  @override
  String get enterWeight => 'Zadejte hmotnost';

  @override
  String get enterValidWeight => 'Zadejte platnou hmotnost';

  @override
  String get remainingCannotExceedTotal =>
      'Zbývající hmotnost nemůže překročit celkovou hmotnost';

  @override
  String get overview => 'Přehled';

  @override
  String get spoolsInStock => 'Cívky na skladě';

  @override
  String get totalValue => 'Celková hodnota';

  @override
  String get lowStockSpools => 'Nízké zásoby';

  @override
  String get materialDistribution => 'Rozdělení podle materiálu';

  @override
  String get brandDistribution => 'Rozdělení podle značky';

  @override
  String get noData => 'Žádná data';

  @override
  String get refresh => 'Obnovit';

  @override
  String get profileSettings => 'Nastavení profilu';

  @override
  String get preferences => 'Předvolby';

  @override
  String get language => 'Jazyk';

  @override
  String get selectLanguage => 'Vybrat jazyk';

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
  String get currency => 'Měna';

  @override
  String get selectCurrency => 'Vybrat měnu';

  @override
  String get units => 'Jednotky';

  @override
  String get selectUnits => 'Vybrat jednotky';

  @override
  String get metric => 'Metrické (mm, g, °C)';

  @override
  String get imperial => 'Imperiální (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Práh upozornění na nízké zásoby';

  @override
  String get lowStockThresholdDesc =>
      'Cívka bude považována za nízké zásoby, pokud zbývající hmotnost je menší než toto procento';

  @override
  String get authentication => 'Ověření';

  @override
  String get signInWithGoogle => 'Přihlásit se přes Google';

  @override
  String get signInWithApple => 'Přihlásit se přes Apple';

  @override
  String get comingSoon => 'Již brzy';

  @override
  String get about => 'O aplikaci';

  @override
  String get version => 'Verze';

  @override
  String get madeWith => 'Vytvořeno s ❤️ pro 3D tiskárny Anycubic';

  @override
  String get scanBobbinDirectly => 'Skenovat cívku';

  @override
  String get nfcEncoder => 'NFC kodér';

  @override
  String get length => 'Délka';

  @override
  String get tempExtruder => 'Teplota extruderu';

  @override
  String get tempBed => 'Teplota podložky';

  @override
  String get termsOfService => 'Podmínky služby';

  @override
  String get privacyPolicy => 'Zásady ochrany osobních údajů';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Zpět';

  @override
  String get retry => 'Zkusit znovu';

  @override
  String get signOut => 'Odhlásit se';

  @override
  String get extruderTempMinHint => 'např.: 200';

  @override
  String get extruderTempMaxHint => 'např.: 220';

  @override
  String get bedTempMinHint => 'např.: 50';

  @override
  String get bedTempMaxHint => 'např.: 60';

  @override
  String get diameterHint => 'např.: 1.75';

  @override
  String get spoolLengthHint => 'např.: 330';

  @override
  String get tabGrid => 'Mřížka';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Posuvníky';

  @override
  String get hexCode => 'Hexadecimální kód';

  @override
  String get red => 'Červená';

  @override
  String get green => 'Zelená';

  @override
  String get blue => 'Modrá';

  @override
  String get metricUnits => 'Metrické (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperiální (in, oz, °F)';

  @override
  String get chf => 'Švýcarský frank (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Americký dolar (\$)';

  @override
  String get gbp => 'Britská libra (£)';

  @override
  String get cad => 'Kanadský dolar (CAD)';

  @override
  String get filamentsToOrder => 'Filamenty k objednání';

  @override
  String get shoppingList => 'Nákupní seznam';

  @override
  String get addToShoppingList => 'Přidat do seznamu';

  @override
  String get noLowStockFilaments => 'Žádné filamenty s nízkými zásobami';

  @override
  String get vipSubscriptionDescription =>
      'Toto předplatné slouží pouze k deaktivaci reklam v aplikaci a k podpoře projektu. Žádné další funkce.';

  @override
  String get monthlySubscription => 'Měsíční předplatné';

  @override
  String get yearlySubscription => 'Roční předplatné';

  @override
  String get perMonth => '/ měsíc';

  @override
  String get perYear => '/ rok';

  @override
  String onlyPerMonth(String price) {
    return 'Pouze $price / měsíc';
  }

  @override
  String get subscribe => 'Předplatit';

  @override
  String get bestOffer => '✨ NEJLEPŠÍ NABÍDKA ✨';

  @override
  String get forAnycubicAce => 'pro Anycubic Ace';

  @override
  String get forBambuLabAms => 'pro Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Skenovat NFC čip';

  @override
  String get fillForm => 'Vyplnit formulář';

  @override
  String get emptyShoppingList => 'Žádné filamenty v seznamu';

  @override
  String percentRemaining(String percent) {
    return '$percent% zbývá';
  }

  @override
  String get markAsOrdered => 'Označit jako objednáno';

  @override
  String get markAsNotOrdered => 'Označit jako neobjednáno';

  @override
  String get notSignedIn => 'Nepřihlášen';

  @override
  String get signIn => 'Přihlásit se';

  @override
  String get connection => 'Přihlášení';

  @override
  String get signInToSync => 'Přihlaste se pro synchronizaci dat';

  @override
  String get continueWithoutAccount => 'Pokračovat bez účtu (místní režim)';

  @override
  String get privacyNotice =>
      'Přihlášením souhlasíte s našimi\nPodmínkami používání a Zásadami ochrany osobních údajů';

  @override
  String get updateStock => 'Aktualizovat zásoby';

  @override
  String get scanToUpdateStock => 'Skenovat pro aktualizaci';

  @override
  String get weightUsed => 'Použitá hmotnost';

  @override
  String get lengthUsed => 'Použitá délka';

  @override
  String get enterWeightOrLength => 'Zadejte použitou hmotnost nebo délku';

  @override
  String get weightUsedG => 'Použitá hmotnost (g)';

  @override
  String get lengthUsedM => 'Použitá délka (m)';

  @override
  String get stockUpdated => 'Zásoby aktualizovány';

  @override
  String get scanSpoolToUpdate => 'Naskenujte cívku pro aktualizaci zásob';

  @override
  String get spoolNotFound => 'Cívka nebyla nalezena v zásobách';

  @override
  String get addSpoolFirstMessage =>
      'Tato cívka ještě není ve vašich zásobách. Nejprve ji přidejte pomocí tlačítka \'Přidat cívku\' před aktualizací jejích zásob.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Pouze čtení';

  @override
  String get bambuLabReadOnlyDesc =>
      'Značky Bambu Lab používají šifrování RSA a nelze je upravovat. Pouze čtení.';

  @override
  String get bambuCloneLibrary => 'Knihovna klonů Bambu Lab';

  @override
  String get noBambuClones => 'Žádné klony Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Naskenujte originální značky Bambu Lab pro vytvoření knihovny klonů';

  @override
  String get scanTag => 'Naskenovat značku';

  @override
  String get syncWithCloud => 'Synchronizovat s cloudem';

  @override
  String get syncCompleted => 'Synchronizace dokončena';

  @override
  String get deleteClone => 'Smazat klon';

  @override
  String get renameClone => 'Přejmenovat klon';

  @override
  String get rename => 'Přejmenovat';

  @override
  String get customName => 'Vlastní název';

  @override
  String get clonedOn => 'Klonováno';

  @override
  String get writeThisClone => 'Zapsat tento klon';

  @override
  String get writeClone => 'Zapsat klon';

  @override
  String get writeOnCUID => 'Zapsat na kartu CUID';

  @override
  String get cloneWrittenSuccess => 'Klon úspěšně zapsán!';

  @override
  String get requiredTagFormat => 'Požadovaný formát značky';

  @override
  String get type => 'Typ';

  @override
  String get frequency => 'Frekvence';

  @override
  String get protocol => 'Protokol';

  @override
  String get capacity => 'Kapacita';

  @override
  String get feature => 'Funkce';

  @override
  String get uidModifiable => 'Blok 0 (UID) upravitelný';

  @override
  String get whereToBuy =>
      'Vyhledejte \"CUID MiFare Classic 1K\" na AliExpress, Amazon nebo eBay (~\$0.50/kus)';

  @override
  String get magicGen2Required =>
      'Karta Magic Gen2 - MiFare Classic 1K s zapisovatelným Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Hledejte \"Magic Gen2 MiFare Classic 1K\" nebo \"UID writable\" na AliExpress, Amazon nebo eBay (~\$0.50/kus)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Varování: Zápis pomocí NFC iPhone nemusí fungovat na všech kartách Magic Gen2. Pro spolehlivost doporučujeme Android s aplikací NFC Tools Pro nebo zařízení Proxmark3.';

  @override
  String get step1GetMagicGen2 =>
      'Získejte prázdnou kartu Magic Gen2 (MiFare Classic 1K s zapisovatelným UID)';

  @override
  String get instructions => 'Instrukce';

  @override
  String get step1GetCUID => 'Získejte prázdnou kartu CUID (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Stiskněte tlačítko \"Zapsat\" níže';

  @override
  String get step3HoldPhone => 'Přidržte iPhone u karty CUID';

  @override
  String get step4WaitConfirm => 'Počkejte na potvrzení zápisu';

  @override
  String get step5TestClone =>
      'Otestujte naklonovanou značku na tiskárně Bambu Lab!';

  @override
  String get rsaIncluded =>
      'Klon obsahuje originální RSA podpis, bude akceptován tiskárnou!';

  @override
  String get cloneDeleted => 'Klon smazán';
}
