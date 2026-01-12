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
  String get legal => 'Legal';

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
      '⚠️ Ostrzeżenie: Zapisywanie za pomocą NFC iPhone może nie działać na wszystkich kartach Magic Gen2. Zalecany Android z aplikacją NFC Tools Pro lub urządzenie Proxmark3 dla niezawodności.';

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
  String get step3HoldPhone => 'Przytrzymaj iPhone blisko karty CUID';

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
}
