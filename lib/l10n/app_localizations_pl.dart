// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Magazyn';

  @override
  String get statistics => 'Statystyki';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Odczytaj chip NFC';

  @override
  String get scanHistory => 'Historia';

  @override
  String get writeNfcChip => 'Zapisz chip NFC';

  @override
  String get nfcNotAvailable => 'NFC niedostępne';

  @override
  String get nfcNotAvailableDesc =>
      'Twoje urządzenie nie obsługuje NFC lub jest wyłączone.';

  @override
  String get nfcNotSupported => 'NFC nie jest obsługiwane na tym urządzeniu';

  @override
  String get approachNfcChip => 'Zbliż chip NFC...';

  @override
  String get scanningNfc => 'Skanowanie...';

  @override
  String get nfcDataRead => 'Dane NFC odczytane pomyślnie!';

  @override
  String get errorReadingNfc => 'Błąd odczytu NFC';

  @override
  String get scanHistoryTitle => 'Historia skanowania';

  @override
  String get noScansRecorded => 'Brak zapisanych skanów';

  @override
  String get scansWillAppearHere => 'Skany NFC pojawią się tutaj automatycznie';

  @override
  String get clearAll => 'Wyczyść wszystko';

  @override
  String get deleteThisScan => 'Usunąć ten skan?';

  @override
  String get actionIrreversible => 'Ta akcja jest nieodwracalna.';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get clearAllHistory => 'Wyczyścić całą historię?';

  @override
  String get allScansWillBeDeleted =>
      'Wszystkie skany zostaną usunięte. Ta akcja jest nieodwracalna.';

  @override
  String get scanDeleted => 'Skan usunięty';

  @override
  String get scanDetails => 'Szczegóły skanu';

  @override
  String scannedOn(Object date) {
    return 'Zeskanowano $date';
  }

  @override
  String get bobbinInformation => 'Informacje o szpuli';

  @override
  String get filamentType => 'Typ filamentu';

  @override
  String get color => 'Kolor';

  @override
  String get weight => 'Waga';

  @override
  String get manufacturingDate => 'Data produkcji';

  @override
  String get batchNumber => 'Numer partii';

  @override
  String get printerSettings => 'Ustawienia drukarki';

  @override
  String get scanMetadata => 'Metadane skanu';

  @override
  String get scanId => 'ID skanu';

  @override
  String get dateAndTime => 'Data i godzina';

  @override
  String get reuseThisData => 'Użyj ponownie tych danych';

  @override
  String get writeToNfc => 'Zapisz do NFC';

  @override
  String get writeDataToChip => 'Zapisz dane na chip';

  @override
  String get writeSuccess => 'Zapis zakończony sukcesem!';

  @override
  String get writeError => 'Błąd zapisu';

  @override
  String get brand => 'Marka';

  @override
  String get selectBrand => 'Wybierz markę';

  @override
  String get materialType => 'Typ materiału';

  @override
  String get selectMaterial => 'Wybierz materiał';

  @override
  String get serialNumber => 'Numer seryjny';

  @override
  String get serialNumberHint => 'np.: 001';

  @override
  String get initialWeight => 'Waga początkowa';

  @override
  String get initialWeightHint => 'np.: 1000';

  @override
  String get extruderTempMin => 'Temp. ekstrudera min';

  @override
  String get extruderTempMax => 'Temp. ekstrudera maks';

  @override
  String get bedTempMin => 'Temp. stołu min';

  @override
  String get bedTempMax => 'Temp. stołu maks';

  @override
  String get diameter => 'Średnica';

  @override
  String get spoolLength => 'Długość (m)';

  @override
  String get generatedSku => 'Wygenerowane SKU';

  @override
  String get approachChipToWrite => 'Zbliż chip do zapisu...';

  @override
  String get writing => 'Zapisywanie...';

  @override
  String get chooseColor => 'Wybierz kolor';

  @override
  String get required => 'Wymagane';

  @override
  String get invalid => 'Nieprawidłowe';

  @override
  String get advancedSettings => 'Ustawienia zaawansowane';

  @override
  String get opacity => 'Krycie';

  @override
  String get validate => 'Zatwierdź';

  @override
  String get nfcTagInfo =>
      'Użyj pustego tagu NFC ISO14443A (NTAG213), aby utworzyć własne tagi Anycubic.';

  @override
  String get stockInventory => 'Szpule w magazynie';

  @override
  String get addSpool => 'Dodaj szpulę';

  @override
  String get scanSpool => 'Skanuj szpulę';

  @override
  String get addManually => 'Dodaj ręcznie';

  @override
  String get spoolAdded => 'Szpula dodana';

  @override
  String get spoolUpdated => 'Szpula zaktualizowana';

  @override
  String get noSpoolsInStock => 'Brak szpul w magazynie';

  @override
  String get addFirstSpool =>
      'Dodaj pierwszą szpulę, aby rozpocząć śledzenie zapasów';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count szpula/szpul o niskim stanie (< $threshold%)';
  }

  @override
  String get edit => 'Edytuj';

  @override
  String get bobbinPrice => 'Cena szpuli';

  @override
  String get price => 'Cena';

  @override
  String get priceHint => 'np.: 25.00';

  @override
  String get save => 'Zapisz';

  @override
  String get spoolDetails => 'Szczegóły szpuli';

  @override
  String get deleteThisSpool => 'Usunąć tę szpulę?';

  @override
  String get cannotBeUndone => 'Tej akcji nie można cofnąć.';

  @override
  String get addSpoolManually => 'Dodaj szpulę ręcznie';

  @override
  String get editSpool => 'Edytuj szpulę';

  @override
  String get customBrand => 'Własna marka';

  @override
  String get customBrandHint => 'np.: Moja marka';

  @override
  String get chooseFromList => 'Wybierz z listy';

  @override
  String get addBrand => '+ Dodaj markę';

  @override
  String get customMaterial => 'Własny materiał';

  @override
  String get customMaterialHint => 'np.: Mój materiał';

  @override
  String get addMaterial => '+ Dodaj materiał';

  @override
  String get colorHint => 'np.: Niebieski, Czerwony...';

  @override
  String get enterColor => 'Wprowadź kolor';

  @override
  String get initialWeightG => 'Waga początkowa';

  @override
  String get remainingWeightG => 'Pozostała waga';

  @override
  String get enterBrand => 'Wprowadź markę';

  @override
  String get selectOrEnterBrand => 'Wybierz lub wprowadź markę';

  @override
  String get quantity => 'Ilość';

  @override
  String get quantityHelper => 'Dodaj kilka identycznych szpul naraz';

  @override
  String get quantityInvalid => 'Wprowadź liczbę od 1 do 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count w magazynie';
  }

  @override
  String get enterMaterial => 'Wprowadź materiał';

  @override
  String get selectOrEnterMaterial => 'Wybierz lub wprowadź materiał';

  @override
  String get enterPrice => 'Wprowadź cenę';

  @override
  String get enterValidPrice => 'Wprowadź prawidłową cenę';

  @override
  String get enterWeight => 'Wprowadź wagę';

  @override
  String get enterValidWeight => 'Wprowadź prawidłową wagę';

  @override
  String get remainingCannotExceedTotal =>
      'Pozostała waga nie może przekroczyć wagi całkowitej';

  @override
  String get overview => 'Przegląd';

  @override
  String get spoolsInStock => 'Szpule w magazynie';

  @override
  String get totalValue => 'Całkowita wartość';

  @override
  String get lowStockSpools => 'Niski stan';

  @override
  String get materialDistribution => 'Rozkład według materiału';

  @override
  String get brandDistribution => 'Rozkład według marki';

  @override
  String get noData => 'Brak danych';

  @override
  String get refresh => 'Odśwież';

  @override
  String get profileSettings => 'Ustawienia profilu';

  @override
  String get preferences => 'Preferencje';

  @override
  String get language => 'Język';

  @override
  String get selectLanguage => 'Wybierz język';

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
  String get currency => 'Waluta';

  @override
  String get selectCurrency => 'Wybierz walutę';

  @override
  String get units => 'Jednostki';

  @override
  String get selectUnits => 'Wybierz jednostki';

  @override
  String get metric => 'Metryczne (mm, g, °C)';

  @override
  String get imperial => 'Imperialne (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Próg alertu niskiego stanu';

  @override
  String get lowStockThresholdDesc =>
      'Szpula będzie uznana za niski stan, jeśli pozostała waga jest mniejsza niż ten procent';

  @override
  String get authentication => 'Uwierzytelnianie';

  @override
  String get signInWithGoogle => 'Zaloguj się przez Google';

  @override
  String get signInWithApple => 'Zaloguj się przez Apple';

  @override
  String get continueWithApple => 'Kontynuuj z Apple';

  @override
  String get continueWithGoogle => 'Kontynuuj z Google';

  @override
  String get comingSoon => 'Wkrótce';

  @override
  String get about => 'O aplikacji';

  @override
  String get version => 'Wersja';

  @override
  String get madeWith => 'Stworzone z ❤️ dla drukarek 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Skanuj szpulę';

  @override
  String get nfcEncoder => 'Enkoder NFC';

  @override
  String get length => 'Długość';

  @override
  String get tempExtruder => 'Temp. ekstrudera';

  @override
  String get tempBed => 'Temp. stołu';

  @override
  String get termsOfService => 'Warunki usługi';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get legal => 'Prawne';

  @override
  String get back => 'Wstecz';

  @override
  String get retry => 'Ponów';

  @override
  String get signOut => 'Wyloguj';

  @override
  String get extruderTempMinHint => 'np.: 200';

  @override
  String get extruderTempMaxHint => 'np.: 220';

  @override
  String get bedTempMinHint => 'np.: 50';

  @override
  String get bedTempMaxHint => 'np.: 60';

  @override
  String get diameterHint => 'np.: 1.75';

  @override
  String get spoolLengthHint => 'np.: 330';

  @override
  String get tabGrid => 'Siatka';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Suwaki';

  @override
  String get hexCode => 'Kod szesnastkowy';

  @override
  String get red => 'Czerwony';

  @override
  String get green => 'Zielony';

  @override
  String get blue => 'Niebieski';

  @override
  String get black => 'Czarny';

  @override
  String get white => 'Biały';

  @override
  String get yellow => 'Żółty';

  @override
  String get orange => 'Pomarańczowy';

  @override
  String get pink => 'Różowy';

  @override
  String get purple => 'Fioletowy';

  @override
  String get gray => 'Szary';

  @override
  String get brown => 'Brązowy';

  @override
  String get unknown => 'Nieznany';

  @override
  String get metricUnits => 'Metryczne (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperialne (in, oz, °F)';

  @override
  String get chf => 'Frank szwajcarski (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Dolar amerykański (\$)';

  @override
  String get gbp => 'Funt szterling (£)';

  @override
  String get cad => 'Dolar kanadyjski (CAD)';

  @override
  String get aud => 'Dolar australijski (A\$)';

  @override
  String get jpy => 'Jen japoński (¥)';

  @override
  String get cny => 'Juan chiński (¥)';

  @override
  String get inr => 'Rupia indyjska (₹)';

  @override
  String get brl => 'Real brazylijski (R\$)';

  @override
  String get mxn => 'Peso meksykańskie (MX\$)';

  @override
  String get sek => 'Korona szwedzka (kr)';

  @override
  String get nok => 'Korona norweska (kr)';

  @override
  String get dkk => 'Korona duńska (kr)';

  @override
  String get pln => 'Złoty polski (zł)';

  @override
  String get czk => 'Korona czeska (Kč)';

  @override
  String get nzd => 'Dolar nowozelandzki (NZ\$)';

  @override
  String get filamentsToOrder => 'Filamenty do zamówienia';

  @override
  String get shoppingList => 'Lista zakupów';

  @override
  String get addToShoppingList => 'Dodaj do listy';

  @override
  String get noLowStockFilaments => 'Brak filamentów o niskim stanie';

  @override
  String get vipSubscriptionDescription =>
      'Ta subskrypcja służy tylko do wyłączenia reklam w aplikacji i wsparcia projektu. Brak innych funkcji.';

  @override
  String get monthlySubscription => 'Subskrypcja miesięczna';

  @override
  String get yearlySubscription => 'Subskrypcja roczna';

  @override
  String get perMonth => '/ miesiąc';

  @override
  String get perYear => '/ rok';

  @override
  String onlyPerMonth(String price) {
    return 'Tylko $price / miesiąc';
  }

  @override
  String get subscribe => 'Subskrybuj';

  @override
  String get bestOffer => '✨ NAJLEPSZA OFERTA ✨';

  @override
  String get forAnycubicAce => 'dla Anycubic Ace';

  @override
  String get forBambuLabAms => 'dla Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Skanuj chip NFC';

  @override
  String get fillForm => 'Wypełnij formularz';

  @override
  String get emptyShoppingList => 'Brak filamentów na liście';

  @override
  String percentRemaining(String percent) {
    return '$percent% pozostało';
  }

  @override
  String get markAsOrdered => 'Oznacz jako zamówione';

  @override
  String get markAsNotOrdered => 'Oznacz jako niezamówione';

  @override
  String get notSignedIn => 'Nie zalogowano';

  @override
  String get signIn => 'Zaloguj się';

  @override
  String get connection => 'Logowanie';

  @override
  String get signInToSync => 'Zaloguj się, aby zsynchronizować swoje dane';

  @override
  String get continueWithoutAccount => 'Kontynuuj bez konta (tryb lokalny)';

  @override
  String get privacyNotice =>
      'Logując się, akceptujesz nasze\nWarunki użytkowania i Politykę prywatności';

  @override
  String get updateStock => 'Zaktualizuj stan';

  @override
  String get scanToUpdateStock => 'Skanuj, aby zaktualizować';

  @override
  String get weightUsed => 'Użyta waga';

  @override
  String get lengthUsed => 'Użyta długość';

  @override
  String get enterWeightOrLength => 'Wprowadź użytą wagę lub długość';

  @override
  String get weightUsedG => 'Użyta waga (g)';

  @override
  String get lengthUsedM => 'Użyta długość (m)';

  @override
  String get stockUpdated => 'Stan zaktualizowany';

  @override
  String get scanSpoolToUpdate => 'Zeskanuj szpulę, aby zaktualizować jej stan';

  @override
  String get spoolNotFound => 'Szpula nie została znaleziona w magazynie';

  @override
  String get addSpoolFirstMessage =>
      'Ta szpula nie jest jeszcze w Twoim magazynie. Dodaj ją najpierw za pomocą przycisku \'Dodaj szpulę\' przed aktualizacją jej stanu.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Tylko do odczytu';

  @override
  String get bambuLabReadOnlyDesc =>
      'Tagi Bambu Lab używają szyfrowania RSA i nie mogą być modyfikowane. Tylko do odczytu.';

  @override
  String get forPrusaMk4 => 'dla Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Odczyt i Zapis';

  @override
  String get prusaReadWriteDesc =>
      'Tagi Prusa używają ISO 15693 (NFC-V) z formatem OpenPrintTag. Odczyt i zapis obsługiwane.';

  @override
  String get bambuCloneLibrary => 'Biblioteka klonów Bambu Lab';

  @override
  String get noBambuClones => 'Brak klonów Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Zeskanuj oryginalne tagi Bambu Lab, aby stworzyć bibliotekę klonów';

  @override
  String get scanTag => 'Zeskanuj tag';

  @override
  String get syncWithCloud => 'Synchronizuj z chmurą';

  @override
  String get syncCompleted => 'Synchronizacja zakończona';

  @override
  String get deleteClone => 'Usuń klon';

  @override
  String get renameClone => 'Zmień nazwę klonu';

  @override
  String get rename => 'Zmień nazwę';

  @override
  String get customName => 'Nazwa niestandardowa';

  @override
  String get clonedOn => 'Sklonowano';

  @override
  String get writeThisClone => 'Zapisz ten klon';

  @override
  String get writeClone => 'Zapisz klon';

  @override
  String get writeOnCUID => 'Zapisz na kartę CUID';

  @override
  String get cloneWrittenSuccess => 'Klon zapisany pomyślnie!';

  @override
  String get requiredTagFormat => 'Wymagany format tagu';

  @override
  String get type => 'Typ';

  @override
  String get frequency => 'Częstotliwość';

  @override
  String get protocol => 'Protokół';

  @override
  String get capacity => 'Pojemność';

  @override
  String get feature => 'Funkcja';

  @override
  String get uidModifiable => 'Blok 0 (UID) modyfikowalny';

  @override
  String get whereToBuy =>
      'Wyszukaj \"CUID MiFare Classic 1K\" na AliExpress, Amazon lub eBay (~\$0.50/szt.)';

  @override
  String get magicGen2Required =>
      'Karta Magic Gen2 - MiFare Classic 1K z zapisywalnym Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Szukaj \"Magic Gen2 MiFare Classic 1K\" lub \"UID writable\" na AliExpress, Amazon lub eBay (~\$0.50/szt.)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Ostrzeżenie: Zapisywanie za pomocą NFC iPhone może nie działać na wszystkich kartach Magic Gen2. Zalecane urządzenie Proxmark3 dla maksymalnej niezawodności.';

  @override
  String get step1GetMagicGen2 =>
      'Zdobądź pustą kartę Magic Gen2 (MiFare Classic 1K z zapisywalnym UID)';

  @override
  String get instructions => 'Instrukcje';

  @override
  String get step1GetCUID => 'Zdobądź pustą kartę CUID (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Naciśnij przycisk \"Zapisz\" poniżej';

  @override
  String get step3HoldPhone => 'Przytrzymaj telefon blisko karty CUID';

  @override
  String get step4WaitConfirm => 'Poczekaj na potwierdzenie zapisu';

  @override
  String get step5TestClone =>
      'Przetestuj sklonowany tag na drukarce Bambu Lab!';

  @override
  String get rsaIncluded =>
      'Klon zawiera oryginalny podpis RSA, zostanie zaakceptowany przez drukarkę!';

  @override
  String get cloneDeleted => 'Klon usunięty';

  @override
  String get deleteAccount => 'Usuń moje konto';

  @override
  String get deleteAccountConfirmation =>
      'Ta akcja jest nieodwracalna. Twoje konto i wszystkie dane zostaną usunięte w ciągu 30 dni.';

  @override
  String get accountDeletionRequested => 'Prośba o usunięcie zarejestrowana';

  @override
  String get clearShoppingList => 'Wyczyść listę';

  @override
  String get clearShoppingListConfirmation =>
      'Czy na pewno chcesz wyczyścić całą listę zakupów? Tej akcji nie można cofnąć.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Historia';

  @override
  String get retryButton => 'Ponów';

  @override
  String get readSuccessMessage => 'Odczyt udany!';

  @override
  String get filamentTypeLabel => 'Typ filamentu';

  @override
  String get scanNfcChipButton => 'Skanuj chip NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Usunąć klon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klon \"$name\" usunięty';
  }

  @override
  String get extruderLabel => 'Ekstruder';

  @override
  String get writeThisCloneButton => 'Zapisz ten klon';

  @override
  String get customNameHint => 'Nazwa własna';

  @override
  String get cloneWriteSuccessMessage => 'Klon zapisany pomyślnie!';

  @override
  String errorPrefix(String error) {
    return 'Błąd: $error';
  }

  @override
  String get writingInProgress => 'Zapisywanie...';

  @override
  String get writeOnCUIDButton => 'Zapisz na karcie CUID';

  @override
  String get diameterLabel => 'Średnica';

  @override
  String get extruderTempLabel => 'Temperatura ekstrudera';

  @override
  String get bedTempLabel => 'Temperatura stołu';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bajtów (1024 bajty)';

  @override
  String get rsaSignatureNote =>
      'Klon zawiera oryginalny podpis RSA, zostanie zaakceptowany przez drukarkę!';

  @override
  String get writeBambuLabTagTitle => 'Zapisz tag Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'Tag Bambu Lab zapisany pomyślnie!';

  @override
  String get approachNfcTagMessage => 'Zbliż tag NFC...';

  @override
  String get bambuLabFormatMiFare => 'Format Bambu Lab (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Format Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Ten format używa kodów materiałów Bambu Lab i przechowuje dane w formacie kompatybilnym z AMS.';

  @override
  String get brandLabel => 'Marka';

  @override
  String get materialTypeLabel => 'Typ materiału';

  @override
  String get serialNumber3Digits => 'Numer seryjny (3 cyfry)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (standardowy)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Zapisz tag Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Uwaga: Oryginalne tagi Bambu Lab używają szyfrowania RSA. Ten tryb zapisuje dane w uproszczonym kompatybilnym formacie.';

  @override
  String signInError(String error) {
    return 'Błąd logowania: $error';
  }

  @override
  String get subscriptionActivatedMessage =>
      'Subskrypcja aktywowana pomyślnie!';

  @override
  String get subscriptionFailedMessage => 'Subskrypcja nie powiodła się';

  @override
  String errorMessage(String error) {
    return 'Błąd: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      'Subskrypcja przywrócona pomyślnie!';

  @override
  String get noSubscriptionFoundMessage => 'Nie znaleziono subskrypcji';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTYWNY';

  @override
  String get noAdsExperienceMessage => 'Korzystasz z wersji bez reklam!';

  @override
  String get subscribedLabel => 'Subskrybent';

  @override
  String get restorePurchasesButton => 'Przywróć zakupy';

  @override
  String get cannotExceedRemainingWeight =>
      'Nie można przekroczyć pozostałej wagi';

  @override
  String get pleaseEnterLength => 'Wprowadź długość';

  @override
  String get pleaseEnterValidLength => 'Wprowadź prawidłową długość';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Długość szpuli nie ustawiona - nie można przeliczyć';

  @override
  String get exceedsRemainingWeight => 'Przekracza pozostałą wagę';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Pomóż nam zidentyfikować ten filament';

  @override
  String get helpUsImprove => 'Pomóż nam się poprawić!';

  @override
  String get helpIdentifyDescription =>
      'Odczytaliśmy chip, ale nie mogliśmy go zidentyfikować. Powiedz nam, jaki to filament, abyśmy mogli ulepszyć aplikację.';

  @override
  String get otherBrand => 'Inna';

  @override
  String get thankYouFeedback => 'Dziękujemy za opinię!';

  @override
  String get send => 'Wyślij';

  @override
  String get optionalDetails => 'Opcjonalne szczegóły';

  @override
  String get weightGrams => 'Waga (g)';

  @override
  String get diameterMm => 'Średnica (mm)';

  @override
  String get spoolLengthM => 'Długość szpuli (m)';

  @override
  String get batchNumberLabel => 'Partia / SKU';

  @override
  String get contactUs => 'Skontaktuj się';

  @override
  String get contactUsSubtitle => 'Pytania, sugestie lub problemy';

  @override
  String get nfcTagNotDetected => 'Nie wykryto tagu NFC';

  @override
  String get nfcTagNotDetectedDesc =>
      'Nie znaleziono tagu. Tag może być uszkodzony, zniszczony lub zbyt daleko od telefonu.';

  @override
  String get nfcTagIncompatible => 'Wykryto niezgodny tag NFC';

  @override
  String get nfcAuthError => 'Uwierzytelnianie tagu NFC nie powiodło się';

  @override
  String get nfcAuthErrorDesc =>
      'Tag został wykryty, ale uwierzytelnianie nie powiodło się po kilku próbach. Przytrzymaj tag mocno przy tylnej części telefonu i spróbuj ponownie.';

  @override
  String get nfcTagInfoPrusa =>
      'Użyj pustego tagu NXP ICODE SLIX2 (ISO 15693), aby utworzyć tagi kompatybilne z OpenPrintTag dla Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Zapisz Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Logowanie przez Apple nie jest dostępne na tym urządzeniu.';

  @override
  String get signInAppleFailed =>
      'Logowanie przez Apple nie powiodło się. Spróbuj ponownie.';

  @override
  String get signInFailed => 'Logowanie nie powiodło się. Spróbuj ponownie.';

  @override
  String get mustContain3Digits => 'Musi zawierać 3 cyfry';

  @override
  String get mustBeNumber => 'Musi być liczbą';

  @override
  String generatedUidLabel(String uid) {
    return 'Wygenerowany UID: $uid';
  }

  @override
  String get experimentalBadge => 'EKSPERYMENTALNE';

  @override
  String get newBadge => 'NOWE';

  @override
  String get forCrealityCfs => 'dla Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Odczyt i zapis';

  @override
  String get crealityReadWriteDesc =>
      'Tagi Creality CFS używają MiFare Classic 1K z szyfrowaniem AES-128-ECB. Odczyt i zapis obsługiwany tylko na Androidzie.';

  @override
  String get platformLimitationTitle => 'Ograniczenie platformy';

  @override
  String get mifareClassicNotSupportedIos =>
      'Tagi MiFare Classic (Bambu Lab, Creality) nie są obsługiwane na iOS z powodu ograniczenia Apple CoreNFC. Ta funkcja jest dostępna tylko na Androidzie.';

  @override
  String get nfcTagInfoCreality =>
      'Użyj tagu MiFare Classic 1K, aby zapisać dane kompatybilne z Creality CFS dla Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Czerwony, Niebieski, Czarny...';

  @override
  String get dryingTemp => 'Temperatura suszenia';

  @override
  String get dryingTempHint => 'np. 55';

  @override
  String get dryingTime => 'Czas suszenia (godziny)';

  @override
  String get dryingTimeHint => 'np. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tag wykryty jako $mode — zmień zakładkę na kolejne skany';
  }

  @override
  String get fallbackChooseMode => 'Wybierz tryb ręcznie';

  @override
  String get fallbackChooseModeSubtitle =>
      'Automatyczne wykrywanie nie mogło zidentyfikować tego tagu. Wybierz protokół:';

  @override
  String get tryAutoDetect => 'Wypróbuj automatyczne wykrywanie';

  @override
  String get autoDetectAllBrands => 'Automatyczne wykrywanie — wszystkie marki';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D i więcej';

  @override
  String get nfcTipIos =>
      'Czytnik NFC znajduje się na górze iPhone\'a. Przyłóż go bezpośrednio do znacznika NFC szpuli.';

  @override
  String get nfcTipAndroid =>
      'Czytnik NFC znajduje się zazwyczaj w środku tylnej części telefonu. Przyłóż tył telefonu do znacznika NFC szpuli.';

  @override
  String get stockSortBy => 'Sortuj';

  @override
  String get stockFilter => 'Filtruj';

  @override
  String get stockSortRecent => 'Najnowsze';

  @override
  String get stockSortBrand => 'Marka';

  @override
  String get stockSortMaterial => 'Materiał';

  @override
  String get stockSortRemaining => 'Pozostała waga';

  @override
  String get stockSortColor => 'Kolor';

  @override
  String get stockFilterAll => 'Wszystkie';

  @override
  String get stockResetFilters => 'Resetuj';

  @override
  String get stockNoMatch => 'Żadna szpula nie pasuje do filtrów';

  @override
  String get nfcDisabledTitle => 'NFC wyłączone';

  @override
  String get nfcDisabledMessage =>
      'NFC jest wyłączone. Włącz je w ustawieniach telefonu, aby skanować szpule.';

  @override
  String get updateAvailableTitle => 'Dostępna aktualizacja';

  @override
  String get updateAvailableMessage =>
      'Dostępna jest nowa wersja Spool Master.';

  @override
  String get updateForcedMessage =>
      'Ta wersja nie jest już obsługiwana. Zaktualizuj, aby kontynuować.';

  @override
  String get updateNow => 'Aktualizuj';

  @override
  String get updateLater => 'Później';

  @override
  String get nfcScanGuidance =>
      'Trzymaj tag nieruchomo przy górnej lub tylnej części telefonu.';

  @override
  String get tagMovedTitle => 'Tag się poruszył';

  @override
  String get tagMovedMessage =>
      'Tag poruszył się podczas odczytu. Przyłóż go ponownie i trzymaj telefon nieruchomo.';

  @override
  String get lightBlue => 'Jasnoniebieski';

  @override
  String get transparent => 'Przezroczysty';

  @override
  String get nfcActiveApproachTag => 'NFC aktywne — zbliż tag';

  @override
  String addedToShoppingList(String item) {
    return '$item dodano do listy zakupów';
  }

  @override
  String get deleteAccountFailed =>
      'Usunięcie konta nie powiodło się. Spróbuj ponownie.';

  @override
  String get scanHistoryError => 'Błąd dostępu do historii skanów';

  @override
  String get genericBrand => 'Ogólny';
}
