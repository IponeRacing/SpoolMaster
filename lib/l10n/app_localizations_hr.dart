// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Zaliha';

  @override
  String get statistics => 'Analitika';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Čitaj NFC čip';

  @override
  String get scanHistory => 'Povijest';

  @override
  String get writeNfcChip => 'Zapiši NFC čip';

  @override
  String get nfcNotAvailable => 'NFC nije dostupan';

  @override
  String get nfcNotAvailableDesc =>
      'Vaš uređaj ne podržava NFC ili je onemogućen.';

  @override
  String get nfcNotSupported => 'NFC nije podržan na ovom uređaju';

  @override
  String get approachNfcChip => 'Približite NFC čip...';

  @override
  String get scanningNfc => 'Skeniranje...';

  @override
  String get nfcDataRead => 'NFC podaci uspješno pročitani!';

  @override
  String get errorReadingNfc => 'Greška pri čitanju NFC-a';

  @override
  String get scanHistoryTitle => 'Povijest skeniranja';

  @override
  String get noScansRecorded => 'Nema zabilježenih skeniranja';

  @override
  String get scansWillAppearHere =>
      'NFC skeniranja će se automatski pojaviti ovdje';

  @override
  String get clearAll => 'Obriši sve';

  @override
  String get deleteThisScan => 'Izbrisati ovo skeniranje?';

  @override
  String get actionIrreversible => 'Ova radnja je nepovratna.';

  @override
  String get cancel => 'Odustani';

  @override
  String get delete => 'Izbriši';

  @override
  String get clearAllHistory => 'Obrisati svu povijest?';

  @override
  String get allScansWillBeDeleted =>
      'Sva skeniranja će biti izbrisana. Ova radnja je nepovratna.';

  @override
  String get scanDeleted => 'Skeniranje izbrisano';

  @override
  String get scanDetails => 'Detalji skeniranja';

  @override
  String scannedOn(Object date) {
    return 'Skenirano $date';
  }

  @override
  String get bobbinInformation => 'Informacije o kalem';

  @override
  String get filamentType => 'Vrsta filamenta';

  @override
  String get color => 'Boja';

  @override
  String get weight => 'Težina';

  @override
  String get manufacturingDate => 'Datum proizvodnje';

  @override
  String get batchNumber => 'Broj serije';

  @override
  String get printerSettings => 'Postavke pisača';

  @override
  String get scanMetadata => 'Metapodaci skeniranja';

  @override
  String get scanId => 'ID skeniranja';

  @override
  String get dateAndTime => 'Datum i vrijeme';

  @override
  String get reuseThisData => 'Ponovo koristi ove podatke';

  @override
  String get writeToNfc => 'Zapiši u NFC';

  @override
  String get writeDataToChip => 'Zapiši podatke u čip';

  @override
  String get writeSuccess => 'Uspješan zapis!';

  @override
  String get writeError => 'Greška pri zapisu';

  @override
  String get brand => 'Marka';

  @override
  String get selectBrand => 'Odaberi marku';

  @override
  String get materialType => 'Vrsta materijala';

  @override
  String get selectMaterial => 'Odaberi materijal';

  @override
  String get serialNumber => 'Serijski broj';

  @override
  String get serialNumberHint => 'npr.: 001';

  @override
  String get initialWeight => 'Početna težina';

  @override
  String get initialWeightHint => 'npr.: 1000';

  @override
  String get extruderTempMin => 'Min. temp. ekstrudera';

  @override
  String get extruderTempMax => 'Maks. temp. ekstrudera';

  @override
  String get bedTempMin => 'Min. temp. podloge';

  @override
  String get bedTempMax => 'Maks. temp. podloge';

  @override
  String get diameter => 'Promjer filamenta';

  @override
  String get spoolLength => 'Duljina kalema';

  @override
  String get generatedSku => 'Generirani SKU';

  @override
  String get approachChipToWrite => 'Približite čip za zapis...';

  @override
  String get writing => 'Zapisivanje...';

  @override
  String get chooseColor => 'Odaberi boju';

  @override
  String get required => 'Obavezno';

  @override
  String get invalid => 'Nevažeće';

  @override
  String get advancedSettings => 'Napredne postavke';

  @override
  String get opacity => 'Prozirnost';

  @override
  String get validate => 'Potvrdi';

  @override
  String get nfcTagInfo =>
      'Koristite praznu ISO14443A NFC oznaku (NTAG213) za stvaranje vlastitih Anycubic oznaka.';

  @override
  String get stockInventory => 'Rolne na zalihi';

  @override
  String get addSpool => 'Dodaj kalem';

  @override
  String get scanSpool => 'Skeniraj kalem';

  @override
  String get addManually => 'Dodaj ručno';

  @override
  String get spoolAdded => 'Kalem dodan';

  @override
  String get spoolUpdated => 'Kalem ažuriran';

  @override
  String get noSpoolsInStock => 'Nema kalema na zalihi';

  @override
  String get addFirstSpool =>
      'Dodajte svoj prvi kalem za početak praćenja inventara';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count kalem(a) s niskom zalihom (< $threshold%)';
  }

  @override
  String get edit => 'Uredi';

  @override
  String get bobbinPrice => 'Cijena kalema';

  @override
  String get price => 'Cijena';

  @override
  String get priceHint => 'npr.: 25.00';

  @override
  String get save => 'Spremi';

  @override
  String get spoolDetails => 'Detalji kalema';

  @override
  String get deleteThisSpool => 'Izbrisati ovaj kalem?';

  @override
  String get cannotBeUndone => 'Ova radnja se ne može poništiti.';

  @override
  String get addSpoolManually => 'Ručno dodavanje kalema';

  @override
  String get editSpool => 'Uredi kalem';

  @override
  String get customBrand => 'Prilagođena marka';

  @override
  String get customBrandHint => 'npr.: Moja marka';

  @override
  String get chooseFromList => 'Odaberi s popisa';

  @override
  String get addBrand => '+ Dodaj marku';

  @override
  String get customMaterial => 'Prilagođeni materijal';

  @override
  String get customMaterialHint => 'npr.: Moj materijal';

  @override
  String get addMaterial => '+ Dodaj materijal';

  @override
  String get colorHint => 'npr.: Plava, Crvena...';

  @override
  String get enterColor => 'Molimo unesite boju';

  @override
  String get initialWeightG => 'Početna težina';

  @override
  String get remainingWeightG => 'Preostala težina';

  @override
  String get enterBrand => 'Molimo unesite marku';

  @override
  String get selectOrEnterBrand => 'Molimo odaberite ili unesite marku';

  @override
  String get quantity => 'Količina';

  @override
  String get quantityHelper => 'Dodajte nekoliko istih koluta odjednom';

  @override
  String get quantityInvalid => 'Unesite broj između 1 i 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count na zalihi';
  }

  @override
  String get enterMaterial => 'Molimo unesite materijal';

  @override
  String get selectOrEnterMaterial => 'Molimo odaberite ili unesite materijal';

  @override
  String get enterPrice => 'Molimo unesite cijenu';

  @override
  String get enterValidPrice => 'Molimo unesite važeću cijenu';

  @override
  String get enterWeight => 'Molimo unesite težinu';

  @override
  String get enterValidWeight => 'Molimo unesite važeću težinu';

  @override
  String get remainingCannotExceedTotal =>
      'Preostala težina ne može premašiti ukupnu težinu';

  @override
  String get overview => 'Pregled';

  @override
  String get spoolsInStock => 'Kalemi na zalihi';

  @override
  String get totalValue => 'Ukupna vrijednost';

  @override
  String get lowStockSpools => 'Niska zaliha';

  @override
  String get materialDistribution => 'Distribucija po materijalu';

  @override
  String get brandDistribution => 'Distribucija po marki';

  @override
  String get noData => 'Nema podataka';

  @override
  String get refresh => 'Osvježi';

  @override
  String get profileSettings => 'Postavke profila';

  @override
  String get preferences => 'Preferencije';

  @override
  String get language => 'Jezik';

  @override
  String get selectLanguage => 'Odaberi jezik';

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
  String get selectCurrency => 'Odaberi valutu';

  @override
  String get units => 'Jedinice';

  @override
  String get selectUnits => 'Odaberi jedinice';

  @override
  String get metric => 'Metrički (mm, g, °C)';

  @override
  String get imperial => 'Imperijalni (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Prag upozorenja za nisku zalihu';

  @override
  String get lowStockThresholdDesc =>
      'Kalem će se smatrati niskom zalihom ako je preostala težina manja od ovog postotka';

  @override
  String get authentication => 'Autentifikacija';

  @override
  String get signInWithGoogle => 'Prijavi se s Googleom';

  @override
  String get signInWithApple => 'Prijavi se s Appleom';

  @override
  String get continueWithApple => 'Nastavi s Appleom';

  @override
  String get continueWithGoogle => 'Nastavi s Googleom';

  @override
  String get comingSoon => 'Uskoro';

  @override
  String get about => 'O aplikaciji';

  @override
  String get version => 'Verzija';

  @override
  String get madeWith => 'Napravljeno s ❤️ za Anycubic 3D pisače';

  @override
  String get scanBobbinDirectly => 'Skeniraj kalem';

  @override
  String get nfcEncoder => 'NFC koder';

  @override
  String get length => 'Duljina';

  @override
  String get tempExtruder => 'Temp. ekstrudera';

  @override
  String get tempBed => 'Temp. podloge';

  @override
  String get termsOfService => 'Uvjeti korištenja';

  @override
  String get privacyPolicy => 'Politika privatnosti';

  @override
  String get legal => 'Pravno';

  @override
  String get back => 'Natrag';

  @override
  String get retry => 'Pokušaj ponovno';

  @override
  String get signOut => 'Odjavi se';

  @override
  String get extruderTempMinHint => 'Npr.: 200';

  @override
  String get extruderTempMaxHint => 'Npr.: 220';

  @override
  String get bedTempMinHint => 'Npr.: 50';

  @override
  String get bedTempMaxHint => 'Npr.: 60';

  @override
  String get diameterHint => 'Npr.: 1.75';

  @override
  String get spoolLengthHint => 'Npr.: 330';

  @override
  String get tabGrid => 'Mreža';

  @override
  String get tabSpectrum => 'Spektar';

  @override
  String get tabSliders => 'Klizači';

  @override
  String get hexCode => 'Hex kod';

  @override
  String get red => 'Crvena';

  @override
  String get green => 'Zelena';

  @override
  String get blue => 'Plava';

  @override
  String get black => 'Crna';

  @override
  String get white => 'Bijela';

  @override
  String get yellow => 'Žuta';

  @override
  String get orange => 'Narančasta';

  @override
  String get pink => 'Ružičasta';

  @override
  String get purple => 'Ljubičasta';

  @override
  String get gray => 'Siva';

  @override
  String get brown => 'Smeđa';

  @override
  String get unknown => 'Nepoznato';

  @override
  String get metricUnits => 'Metrički (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperijalni (in, oz, °F)';

  @override
  String get chf => 'Švicarski franak (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Američki dolar (\$)';

  @override
  String get gbp => 'Funta sterlinga (£)';

  @override
  String get cad => 'Kanadski dolar (CAD)';

  @override
  String get aud => 'Australski dolar (A\$)';

  @override
  String get jpy => 'Japanski jen (¥)';

  @override
  String get cny => 'Kineski juan (¥)';

  @override
  String get inr => 'Indijska rupija (₹)';

  @override
  String get brl => 'Brazilski real (R\$)';

  @override
  String get mxn => 'Meksički peso (MX\$)';

  @override
  String get sek => 'Švedska kruna (kr)';

  @override
  String get nok => 'Norveška kruna (kr)';

  @override
  String get dkk => 'Danska kruna (kr)';

  @override
  String get pln => 'Poljski zlot (zł)';

  @override
  String get czk => 'Češka kruna (Kč)';

  @override
  String get nzd => 'Novozelandski dolar (NZ\$)';

  @override
  String get filamentsToOrder => 'Filamenti za narudžbu';

  @override
  String get shoppingList => 'Popis za kupnju';

  @override
  String get addToShoppingList => 'Dodaj na popis';

  @override
  String get noLowStockFilaments => 'Nema filamenata s niskom zalihom';

  @override
  String get vipSubscriptionDescription =>
      'Ova pretplata se koristi samo za onemogućavanje oglasa u aplikaciji i podršku projektu. Nema drugih funkcija.';

  @override
  String get monthlySubscription => 'Mjesečna pretplata';

  @override
  String get yearlySubscription => 'Godišnja pretplata';

  @override
  String get perMonth => '/ mjesec';

  @override
  String get perYear => '/ godina';

  @override
  String onlyPerMonth(String price) {
    return 'Samo $price / mjesec';
  }

  @override
  String get subscribe => 'Pretplati se';

  @override
  String get bestOffer => '✨ NAJBOLJA PONUDA ✨';

  @override
  String get forAnycubicAce => 'za Anycubic Ace';

  @override
  String get forBambuLabAms => 'za Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Skeniraj NFC čip';

  @override
  String get fillForm => 'Ispuni obrazac';

  @override
  String get emptyShoppingList => 'Nema filamenata na popisu';

  @override
  String percentRemaining(String percent) {
    return '$percent% preostalo';
  }

  @override
  String get markAsOrdered => 'Označi kao naručeno';

  @override
  String get markAsNotOrdered => 'Označi kao nenaručeno';

  @override
  String get notSignedIn => 'Niste prijavljeni';

  @override
  String get signIn => 'Prijava';

  @override
  String get connection => 'Povezivanje';

  @override
  String get signInToSync => 'Prijavite se za sinkronizaciju podataka';

  @override
  String get continueWithoutAccount => 'Nastavi bez računa (lokalni način)';

  @override
  String get privacyNotice =>
      'Prijavom prihvaćate naše\nUvjete korištenja i Politiku privatnosti';

  @override
  String get updateStock => 'Ažuriraj zalihu';

  @override
  String get scanToUpdateStock => 'Skeniraj za ažuriranje';

  @override
  String get weightUsed => 'Korištena težina';

  @override
  String get lengthUsed => 'Korištena duljina';

  @override
  String get enterWeightOrLength => 'Unesite korištenu težinu ili duljinu';

  @override
  String get weightUsedG => 'Korištena težina (g)';

  @override
  String get lengthUsedM => 'Korištena duljina (m)';

  @override
  String get stockUpdated => 'Zaliha ažurirana';

  @override
  String get scanSpoolToUpdate => 'Skenirajte kalup za ažuriranje zalihe';

  @override
  String get spoolNotFound => 'Kalup nije pronađen na zalihi';

  @override
  String get addSpoolFirstMessage =>
      'Ovaj kalup još nije u vašoj zalihi. Molimo prvo ga dodajte pomoću gumba \'Dodaj kalup\' prije ažuriranja zalihe.';

  @override
  String get ok => 'U redu';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Samo za čitanje';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab oznake koriste RSA enkripciju i ne mogu se mijenjati. Samo za čitanje.';

  @override
  String get forPrusaMk4 => 'za Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Čitanje i pisanje';

  @override
  String get prusaReadWriteDesc =>
      'Prusa tagovi koriste ISO 15693 (NFC-V) s OpenPrintTag formatom. Čitanje i pisanje su podržani.';

  @override
  String get bambuCloneLibrary => 'Biblioteka klonova Bambu Lab';

  @override
  String get noBambuClones => 'Nema Bambu Lab klonova';

  @override
  String get scanBambuToClone =>
      'Skenirajte originalne Bambu Lab oznake da biste stvorili svoju biblioteku klonova';

  @override
  String get scanTag => 'Skeniraj oznaku';

  @override
  String get syncWithCloud => 'Sinkroniziraj s oblakom';

  @override
  String get syncCompleted => 'Sinkronizacija dovršena';

  @override
  String get deleteClone => 'Izbriši klon';

  @override
  String get renameClone => 'Preimenuj klon';

  @override
  String get rename => 'Preimenuj';

  @override
  String get customName => 'Prilagođeno ime';

  @override
  String get clonedOn => 'Klonirano';

  @override
  String get writeThisClone => 'Zapiši ovaj klon';

  @override
  String get writeClone => 'Zapiši klon';

  @override
  String get writeOnCUID => 'Zapiši na CUID karticu';

  @override
  String get cloneWrittenSuccess => 'Klon uspješno zapisan!';

  @override
  String get requiredTagFormat => 'Potreban format oznake';

  @override
  String get type => 'Tip';

  @override
  String get frequency => 'Frekvencija';

  @override
  String get protocol => 'Protokol';

  @override
  String get capacity => 'Kapacitet';

  @override
  String get feature => 'Značajka';

  @override
  String get uidModifiable => 'Blok 0 (UID) promjenjiv';

  @override
  String get whereToBuy =>
      'Potražite \"CUID MiFare Classic 1K\" na AliExpress, Amazon ili eBay (~\$0.50/komad)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 kartica - MiFare Classic 1K s upisivim Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Potražite \"Magic Gen2 MiFare Classic 1K\" ili \"UID writable\" na AliExpress, Amazon ili eBay (~\$0.50/komad)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Upozorenje: Pisanje s iPhone NFC možda neće raditi na svim Magic Gen2 karticama. Preporučuje se Proxmark3 uređaj za maksimalnu pouzdanost.';

  @override
  String get step1GetMagicGen2 =>
      'Nabavite praznu Magic Gen2 karticu (MiFare Classic 1K s upisivim UID)';

  @override
  String get instructions => 'Upute';

  @override
  String get step1GetCUID => 'Nabavite praznu CUID karticu (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Pritisnite gumb \"Zapiši\" ispod';

  @override
  String get step3HoldPhone => 'Držite telefon blizu CUID kartice';

  @override
  String get step4WaitConfirm => 'Pričekajte potvrdu zapisa';

  @override
  String get step5TestClone =>
      'Testirajte kloniranu oznaku na svom Bambu Lab printeru!';

  @override
  String get rsaIncluded =>
      'Klon uključuje izvorni RSA potpis, bit će prihvaćen od printera!';

  @override
  String get cloneDeleted => 'Klon izbrisan';

  @override
  String get deleteAccount => 'Izbriši moj račun';

  @override
  String get deleteAccountConfirmation =>
      'Ova radnja je nepovratna. Vaš račun i svi podaci bit će izbrisani u roku od 30 dana.';

  @override
  String get accountDeletionRequested => 'Zahtjev za brisanje registriran';

  @override
  String get clearShoppingList => 'Isprazni popis';

  @override
  String get clearShoppingListConfirmation =>
      'Jeste li sigurni da želite isprazniti cijeli popis za kupovinu? Ova radnja se ne može poništiti.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Povijest';

  @override
  String get retryButton => 'Pokušaj ponovo';

  @override
  String get readSuccessMessage => 'Čitanje uspješno!';

  @override
  String get filamentTypeLabel => 'Vrsta filamenta';

  @override
  String get scanNfcChipButton => 'Skeniraj NFC čip';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Obrisati klon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klon \"$name\" obrisan';
  }

  @override
  String get extruderLabel => 'Ekstruder';

  @override
  String get writeThisCloneButton => 'Zapiši ovaj klon';

  @override
  String get customNameHint => 'Prilagođeno ime';

  @override
  String get cloneWriteSuccessMessage => 'Klon uspješno zapisan!';

  @override
  String errorPrefix(String error) {
    return 'Greška: $error';
  }

  @override
  String get writingInProgress => 'Pisanje...';

  @override
  String get writeOnCUIDButton => 'Zapiši na CUID karticu';

  @override
  String get diameterLabel => 'Promjer';

  @override
  String get extruderTempLabel => 'Temperatura ekstrudera';

  @override
  String get bedTempLabel => 'Temperatura stola';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bajta (1024 bajta)';

  @override
  String get rsaSignatureNote =>
      'Klon uključuje izvorni RSA potpis, bit će prihvaćen od strane pisača!';

  @override
  String get writeBambuLabTagTitle => 'Zapiši Bambu Lab oznaku';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab oznaka uspješno zapisana!';

  @override
  String get approachNfcTagMessage => 'Približite NFC oznaku...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab format (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab format';

  @override
  String get bambuLabFormatInfo =>
      'Ovaj format koristi Bambu Lab materijalne kodove i sprema podatke u AMS kompatibilnom formatu.';

  @override
  String get brandLabel => 'Marka';

  @override
  String get materialTypeLabel => 'Vrsta materijala';

  @override
  String get serialNumber3Digits => 'Serijski broj (3 znamenke)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (standardno)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Zapiši Bambu Lab oznaku';

  @override
  String get bambuLabRsaNote =>
      'Napomena: Originalne Bambu Lab oznake koriste RSA enkripciju. Ovaj način zapisuje podatke u pojednostavljenom kompatibilnom formatu.';

  @override
  String signInError(String error) {
    return 'Greška prijave: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Pretplata uspješno aktivirana!';

  @override
  String get subscriptionFailedMessage => 'Pretplata nije uspjela';

  @override
  String errorMessage(String error) {
    return 'Greška: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Pretplata uspješno obnovljena!';

  @override
  String get noSubscriptionFoundMessage => 'Pretplata nije pronađena';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTIVNO';

  @override
  String get noAdsExperienceMessage => 'Uživajte u iskustvu bez reklama!';

  @override
  String get subscribedLabel => 'Pretplatnik';

  @override
  String get restorePurchasesButton => 'Obnovi kupnje';

  @override
  String get cannotExceedRemainingWeight =>
      'Ne može premašiti preostalu težinu';

  @override
  String get pleaseEnterLength => 'Unesite duljinu';

  @override
  String get pleaseEnterValidLength => 'Unesite valjanu duljinu';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Duljina namotaja nije postavljena - nije moguće pretvoriti';

  @override
  String get exceedsRemainingWeight => 'Premašuje preostalu težinu';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament =>
      'Pomozite nam identificirati ovaj filament';

  @override
  String get helpUsImprove => 'Pomozite nam da se poboljšamo!';

  @override
  String get helpIdentifyDescription =>
      'Pročitali smo čip, ali ga nismo mogli identificirati. Recite nam koji je to filament kako bismo poboljšali aplikaciju.';

  @override
  String get otherBrand => 'Drugi';

  @override
  String get thankYouFeedback => 'Hvala na povratnim informacijama!';

  @override
  String get send => 'Pošalji';

  @override
  String get optionalDetails => 'Neobavezni detalji';

  @override
  String get weightGrams => 'Težina (g)';

  @override
  String get diameterMm => 'Promjer (mm)';

  @override
  String get spoolLengthM => 'Duljina kalema (m)';

  @override
  String get batchNumberLabel => 'Serija / SKU';

  @override
  String get contactUs => 'Kontaktirajte nas';

  @override
  String get contactUsSubtitle => 'Pitanja, prijedlozi ili problemi';

  @override
  String get nfcTagNotDetected => 'NFC oznaka nije otkrivena';

  @override
  String get nfcTagNotDetectedDesc =>
      'Oznaka nije pronađena. Oznaka je možda mrtva, oštećena ili predaleko od telefona.';

  @override
  String get nfcTagIncompatible => 'Otkrivena nekompatibilna NFC oznaka';

  @override
  String get nfcAuthError => 'Autentifikacija NFC oznake nije uspjela';

  @override
  String get nfcAuthErrorDesc =>
      'Oznaka je otkrivena, ali autentifikacija nije uspjela nakon više pokušaja. Držite oznaku čvrsto prislonjen uz stražnju stranu telefona i pokušajte ponovo.';

  @override
  String get nfcTagInfoPrusa =>
      'Koristite praznu NXP ICODE SLIX2 oznaku (ISO 15693) za stvaranje OpenPrintTag kompatibilnih oznaka za Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Zapiši Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Prijava putem Applea nije dostupna na ovom uređaju.';

  @override
  String get signInAppleFailed =>
      'Prijava putem Applea nije uspjela. Pokušajte ponovo.';

  @override
  String get signInFailed => 'Prijava nije uspjela. Pokušajte ponovo.';

  @override
  String get mustContain3Digits => 'Mora sadržavati 3 znamenke';

  @override
  String get mustBeNumber => 'Mora biti broj';

  @override
  String generatedUidLabel(String uid) {
    return 'Generirani UID: $uid';
  }

  @override
  String get experimentalBadge => 'EKSPERIMENTALNO';

  @override
  String get newBadge => 'NOVO';

  @override
  String get forCrealityCfs => 'za Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Čitanje i pisanje';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS oznake koriste MiFare Classic 1K s AES-128-ECB enkripcijom. Čitanje i pisanje podržano samo na Androidu.';

  @override
  String get platformLimitationTitle => 'Ograničenje platforme';

  @override
  String get mifareClassicNotSupportedIos =>
      'MiFare Classic oznake (Bambu Lab, Creality) nisu podržane na iOS-u zbog ograničenja Apple CoreNFC-a. Ova značajka dostupna je samo na Androidu.';

  @override
  String get nfcTagInfoCreality =>
      'Koristite MiFare Classic 1K oznaku za pisanje podataka kompatibilnih s Creality CFS za Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Crvena, Plava, Crna...';

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
    return 'Tag otkriven kao $mode — promijenite karticu za sljedeća skeniranja';
  }

  @override
  String get fallbackChooseMode => 'Odaberite način ručno';

  @override
  String get fallbackChooseModeSubtitle =>
      'Automatska detekcija nije mogla identificirati ovaj tag. Odaberite protokol:';

  @override
  String get tryAutoDetect => 'Pokušaj automatsko prepoznavanje';

  @override
  String get autoDetectAllBrands => 'Automatsko prepoznavanje — sve marke';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D i više';

  @override
  String get nfcTipIos =>
      'NFC čitač se nalazi na vrhu vašeg iPhonea. Postavite ga izravno na NFC oznaku kalema.';

  @override
  String get nfcTipAndroid =>
      'NFC čitač se obično nalazi na sredini stražnje strane telefona. Postavite stražnju stranu telefona na NFC oznaku kalema.';

  @override
  String get stockSortBy => 'Razvrstaj';

  @override
  String get stockFilter => 'Filtar';

  @override
  String get stockSortRecent => 'Najnovije';

  @override
  String get stockSortBrand => 'Marka';

  @override
  String get stockSortMaterial => 'Materijal';

  @override
  String get stockSortRemaining => 'Preostala težina';

  @override
  String get stockSortColor => 'Boja';

  @override
  String get stockFilterAll => 'Sve';

  @override
  String get stockResetFilters => 'Poništi';

  @override
  String get stockNoMatch => 'Nijedna špula ne odgovara filtrima';

  @override
  String get nfcDisabledTitle => 'NFC isključen';

  @override
  String get nfcDisabledMessage =>
      'NFC je isključen. Uključite ga u postavkama telefona da biste skenirali špule.';
}
