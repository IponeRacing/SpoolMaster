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
  String get legal => 'Legal';

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
      '⚠️ Upozorenje: Pisanje s iPhone NFC možda neće raditi na svim Magic Gen2 karticama. Preporučuje se Android s aplikacijom NFC Tools Pro ili Proxmark3 uređaj za pouzdanost.';

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
  String get step3HoldPhone => 'Držite iPhone blizu CUID kartice';

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
}
