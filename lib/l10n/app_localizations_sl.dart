// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Zaloga';

  @override
  String get statistics => 'Analitika';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Preberi NFC čip';

  @override
  String get scanHistory => 'Zgodovina';

  @override
  String get writeNfcChip => 'Zapiši NFC čip';

  @override
  String get nfcNotAvailable => 'NFC ni na voljo';

  @override
  String get nfcNotAvailableDesc =>
      'Vaša naprava ne podpira NFC ali je onemogočena.';

  @override
  String get nfcNotSupported => 'NFC ni podprt na tej napravi';

  @override
  String get approachNfcChip => 'Približajte NFC čip...';

  @override
  String get scanningNfc => 'Skeniranje...';

  @override
  String get nfcDataRead => 'NFC podatki uspešno prebrani!';

  @override
  String get errorReadingNfc => 'Napaka pri branju NFC';

  @override
  String get scanHistoryTitle => 'Zgodovina skeniranja';

  @override
  String get noScansRecorded => 'Ni zapisanih skeniranj';

  @override
  String get scansWillAppearHere =>
      'NFC skeniranja se bodo samodejno pojavila tukaj';

  @override
  String get clearAll => 'Počisti vse';

  @override
  String get deleteThisScan => 'Izbriši to skeniranje?';

  @override
  String get actionIrreversible => 'To dejanje je nepovratno.';

  @override
  String get cancel => 'Prekliči';

  @override
  String get delete => 'Izbriši';

  @override
  String get clearAllHistory => 'Počistiti vso zgodovino?';

  @override
  String get allScansWillBeDeleted =>
      'Vsa skeniranja bodo izbrisana. To dejanje je nepovratno.';

  @override
  String get scanDeleted => 'Skeniranje izbrisano';

  @override
  String get scanDetails => 'Podrobnosti skeniranja';

  @override
  String scannedOn(Object date) {
    return 'Skenirano $date';
  }

  @override
  String get bobbinInformation => 'Informacije o kolut';

  @override
  String get filamentType => 'Vrsta filamenta';

  @override
  String get color => 'Barva';

  @override
  String get weight => 'Teža';

  @override
  String get manufacturingDate => 'Datum proizvodnje';

  @override
  String get batchNumber => 'Številka serije';

  @override
  String get printerSettings => 'Nastavitve tiskalnika';

  @override
  String get scanMetadata => 'Metapodatki skeniranja';

  @override
  String get scanId => 'ID skeniranja';

  @override
  String get dateAndTime => 'Datum in čas';

  @override
  String get reuseThisData => 'Ponovno uporabi te podatke';

  @override
  String get writeToNfc => 'Zapiši v NFC';

  @override
  String get writeDataToChip => 'Zapiši podatke v čip';

  @override
  String get writeSuccess => 'Uspešen zapis!';

  @override
  String get writeError => 'Napaka pri zapisu';

  @override
  String get brand => 'Znamka';

  @override
  String get selectBrand => 'Izberite znamko';

  @override
  String get materialType => 'Vrsta materiala';

  @override
  String get selectMaterial => 'Izberite material';

  @override
  String get serialNumber => 'Serijska številka';

  @override
  String get serialNumberHint => 'npr.: 001';

  @override
  String get initialWeight => 'Začetna teža';

  @override
  String get initialWeightHint => 'npr.: 1000';

  @override
  String get extruderTempMin => 'Min. temp. ekstruderja';

  @override
  String get extruderTempMax => 'Maks. temp. ekstruderja';

  @override
  String get bedTempMin => 'Min. temp. podloge';

  @override
  String get bedTempMax => 'Maks. temp. podloge';

  @override
  String get diameter => 'Premer filamenta';

  @override
  String get spoolLength => 'Dolžina koluta';

  @override
  String get generatedSku => 'Generirani SKU';

  @override
  String get approachChipToWrite => 'Približajte čip za zapis...';

  @override
  String get writing => 'Zapisovanje...';

  @override
  String get chooseColor => 'Izberite barvo';

  @override
  String get required => 'Obvezno';

  @override
  String get invalid => 'Neveljavno';

  @override
  String get advancedSettings => 'Napredne nastavitve';

  @override
  String get opacity => 'Prosojnost';

  @override
  String get validate => 'Potrdi';

  @override
  String get nfcTagInfo =>
      'Uporabite prazno ISO14443A NFC oznako (NTAG213) za ustvarjanje lastnih Anycubic oznak.';

  @override
  String get stockInventory => 'Koluti na zalogi';

  @override
  String get addSpool => 'Dodaj kolut';

  @override
  String get scanSpool => 'Skeniraj kolut';

  @override
  String get addManually => 'Dodaj ročno';

  @override
  String get spoolAdded => 'Kolut dodan';

  @override
  String get spoolUpdated => 'Kolut posodobljen';

  @override
  String get noSpoolsInStock => 'Ni kolut na zalogi';

  @override
  String get addFirstSpool =>
      'Dodajte svoj prvi kolut za začetek sledenja inventarja';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count kolut(i) z nizko zalogo (< $threshold%)';
  }

  @override
  String get edit => 'Uredi';

  @override
  String get bobbinPrice => 'Cena koluta';

  @override
  String get price => 'Cena';

  @override
  String get priceHint => 'npr.: 25.00';

  @override
  String get save => 'Shrani';

  @override
  String get spoolDetails => 'Podrobnosti koluta';

  @override
  String get deleteThisSpool => 'Izbriši ta kolut?';

  @override
  String get cannotBeUndone => 'Tega dejanja ni mogoče razveljaviti.';

  @override
  String get addSpoolManually => 'Ročno dodajanje koluta';

  @override
  String get editSpool => 'Uredi kolut';

  @override
  String get customBrand => 'Znamka po meri';

  @override
  String get customBrandHint => 'npr.: Moja znamka';

  @override
  String get chooseFromList => 'Izberi s seznama';

  @override
  String get addBrand => '+ Dodaj znamko';

  @override
  String get customMaterial => 'Material po meri';

  @override
  String get customMaterialHint => 'npr.: Moj material';

  @override
  String get addMaterial => '+ Dodaj material';

  @override
  String get colorHint => 'npr.: Modra, Rdeča...';

  @override
  String get enterColor => 'Prosimo, vnesite barvo';

  @override
  String get initialWeightG => 'Začetna teža';

  @override
  String get remainingWeightG => 'Preostala teža';

  @override
  String get enterBrand => 'Prosimo, vnesite znamko';

  @override
  String get selectOrEnterBrand => 'Prosimo, izberite ali vnesite znamko';

  @override
  String get quantity => 'Količina';

  @override
  String get quantityHelper => 'Dodajte več enakih tuljav hkrati';

  @override
  String get quantityInvalid => 'Vnesite število med 1 in 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count na zalogi';
  }

  @override
  String get enterMaterial => 'Prosimo, vnesite material';

  @override
  String get selectOrEnterMaterial => 'Prosimo, izberite ali vnesite material';

  @override
  String get enterPrice => 'Prosimo, vnesite ceno';

  @override
  String get enterValidPrice => 'Prosimo, vnesite veljavno ceno';

  @override
  String get enterWeight => 'Prosimo, vnesite težo';

  @override
  String get enterValidWeight => 'Prosimo, vnesite veljavno težo';

  @override
  String get remainingCannotExceedTotal =>
      'Preostala teža ne more presegati skupne teže';

  @override
  String get overview => 'Pregled';

  @override
  String get spoolsInStock => 'Koluti na zalogi';

  @override
  String get totalValue => 'Skupna vrednost';

  @override
  String get lowStockSpools => 'Nizka zaloga';

  @override
  String get materialDistribution => 'Porazdelitev po materialu';

  @override
  String get brandDistribution => 'Porazdelitev po znamki';

  @override
  String get noData => 'Ni podatkov';

  @override
  String get refresh => 'Osveži';

  @override
  String get profileSettings => 'Nastavitve profila';

  @override
  String get preferences => 'Prednostne nastavitve';

  @override
  String get language => 'Jezik';

  @override
  String get selectLanguage => 'Izberite jezik';

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
  String get selectCurrency => 'Izberite valuto';

  @override
  String get units => 'Enote';

  @override
  String get selectUnits => 'Izberite enote';

  @override
  String get metric => 'Metrične (mm, g, °C)';

  @override
  String get imperial => 'Imperialne (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Prag opozorila za nizko zalogo';

  @override
  String get lowStockThresholdDesc =>
      'Kolut bo obravnavan kot nizka zaloga, če je preostala teža manjša od tega odstotka';

  @override
  String get authentication => 'Preverjanje pristnosti';

  @override
  String get signInWithGoogle => 'Prijavi se z Google';

  @override
  String get signInWithApple => 'Prijavi se z Apple';

  @override
  String get continueWithApple => 'Nadaljuj z Apple';

  @override
  String get continueWithGoogle => 'Nadaljuj z Google';

  @override
  String get comingSoon => 'Kmalu';

  @override
  String get about => 'O aplikaciji';

  @override
  String get version => 'Različica';

  @override
  String get madeWith => 'Narejeno z ❤️ za Anycubic 3D tiskalnike';

  @override
  String get scanBobbinDirectly => 'Skeniraj kolut';

  @override
  String get nfcEncoder => 'NFC kodirnik';

  @override
  String get length => 'Dolžina';

  @override
  String get tempExtruder => 'Temp. ekstruderja';

  @override
  String get tempBed => 'Temp. podloge';

  @override
  String get termsOfService => 'Pogoji uporabe';

  @override
  String get privacyPolicy => 'Politika zasebnosti';

  @override
  String get legal => 'Pravno';

  @override
  String get back => 'Nazaj';

  @override
  String get retry => 'Poskusi znova';

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
  String get tabSpectrum => 'Spekter';

  @override
  String get tabSliders => 'Drsniki';

  @override
  String get hexCode => 'Hex koda';

  @override
  String get red => 'Rdeča';

  @override
  String get green => 'Zelena';

  @override
  String get blue => 'Modra';

  @override
  String get black => 'Črna';

  @override
  String get white => 'Bela';

  @override
  String get yellow => 'Rumena';

  @override
  String get orange => 'Oranžna';

  @override
  String get pink => 'Roza';

  @override
  String get purple => 'Vijolična';

  @override
  String get gray => 'Siva';

  @override
  String get brown => 'Rjava';

  @override
  String get unknown => 'Neznano';

  @override
  String get metricUnits => 'Metrične (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperialne (in, oz, °F)';

  @override
  String get chf => 'Švicarski frank (CHF)';

  @override
  String get eur => 'Evro (€)';

  @override
  String get usd => 'Ameriški dolar (\$)';

  @override
  String get gbp => 'Britanski funt (£)';

  @override
  String get cad => 'Kanadski dolar (CAD)';

  @override
  String get aud => 'Avstralski dolar (A\$)';

  @override
  String get jpy => 'Japonski jen (¥)';

  @override
  String get cny => 'Kitajski juan (¥)';

  @override
  String get inr => 'Indijska rupija (₹)';

  @override
  String get brl => 'Brazilski real (R\$)';

  @override
  String get mxn => 'Mehiški peso (MX\$)';

  @override
  String get sek => 'Švedska krona (kr)';

  @override
  String get nok => 'Norveška krona (kr)';

  @override
  String get dkk => 'Danska krona (kr)';

  @override
  String get pln => 'Poljski zlot (zł)';

  @override
  String get czk => 'Češka krona (Kč)';

  @override
  String get nzd => 'Novozelandski dolar (NZ\$)';

  @override
  String get filamentsToOrder => 'Filamenti za naročilo';

  @override
  String get shoppingList => 'Seznam nakupov';

  @override
  String get addToShoppingList => 'Dodaj na seznam';

  @override
  String get noLowStockFilaments => 'Ni filamentov z nizko zalogo';

  @override
  String get vipSubscriptionDescription =>
      'Ta naročnina se uporablja samo za onemogočanje oglasov v aplikaciji in podporo projektu. Brez drugih funkcij.';

  @override
  String get monthlySubscription => 'Mesečna naročnina';

  @override
  String get yearlySubscription => 'Letna naročnina';

  @override
  String get perMonth => '/ mesec';

  @override
  String get perYear => '/ leto';

  @override
  String onlyPerMonth(String price) {
    return 'Samo $price / mesec';
  }

  @override
  String get subscribe => 'Naroči se';

  @override
  String get bestOffer => '✨ NAJBOLJŠA PONUDBA ✨';

  @override
  String get forAnycubicAce => 'za Anycubic Ace';

  @override
  String get forBambuLabAms => 'za Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Skeniraj NFC čip';

  @override
  String get fillForm => 'Izpolni obrazec';

  @override
  String get emptyShoppingList => 'Ni filamentov na seznamu';

  @override
  String percentRemaining(String percent) {
    return '$percent% ostalo';
  }

  @override
  String get markAsOrdered => 'Označi kot naročeno';

  @override
  String get markAsNotOrdered => 'Označi kot nenaročeno';

  @override
  String get notSignedIn => 'Niste prijavljeni';

  @override
  String get signIn => 'Prijava';

  @override
  String get connection => 'Povezava';

  @override
  String get signInToSync => 'Prijavite se za sinhronizacijo podatkov';

  @override
  String get continueWithoutAccount => 'Nadaljuj brez računa (lokalni način)';

  @override
  String get privacyNotice =>
      'S prijavo se strinjate z našimi\nPogoji uporabe in Politiko zasebnosti';

  @override
  String get updateStock => 'Posodobi zalogo';

  @override
  String get scanToUpdateStock => 'Skeniraj za posodobitev';

  @override
  String get weightUsed => 'Uporabljena teža';

  @override
  String get lengthUsed => 'Uporabljena dolžina';

  @override
  String get enterWeightOrLength => 'Vnesite uporabljeno težo ali dolžino';

  @override
  String get weightUsedG => 'Uporabljena teža (g)';

  @override
  String get lengthUsedM => 'Uporabljena dolžina (m)';

  @override
  String get stockUpdated => 'Zaloga posodobljena';

  @override
  String get scanSpoolToUpdate => 'Skenirajte tuljavo za posodobitev zaloge';

  @override
  String get spoolNotFound => 'Tuljava ni bila najdena v zalogi';

  @override
  String get addSpoolFirstMessage =>
      'Ta tuljava še ni v vaši zalogi. Najprej jo dodajte z gumbom \'Dodaj tuljavo\', preden posodobite zalogo.';

  @override
  String get ok => 'V redu';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Samo za branje';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab oznake uporabljajo RSA šifriranje in jih ni mogoče spremeniti. Samo za branje.';

  @override
  String get forPrusaMk4 => 'za Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Branje in pisanje';

  @override
  String get prusaReadWriteDesc =>
      'Prusa oznake uporabljajo ISO 15693 (NFC-V) z obliko OpenPrintTag. Podpora za branje in pisanje.';

  @override
  String get bambuCloneLibrary => 'Knjižnica klonov Bambu Lab';

  @override
  String get noBambuClones => 'Ni klonov Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Skenirajte originalne oznake Bambu Lab za ustvarjanje knjižnice klonov';

  @override
  String get scanTag => 'Skeniraj oznako';

  @override
  String get syncWithCloud => 'Sinhroniziraj z oblakom';

  @override
  String get syncCompleted => 'Sinhronizacija dokončana';

  @override
  String get deleteClone => 'Izbriši klon';

  @override
  String get renameClone => 'Preimenuj klon';

  @override
  String get rename => 'Preimenuj';

  @override
  String get customName => 'Ime po meri';

  @override
  String get clonedOn => 'Klonirano';

  @override
  String get writeThisClone => 'Zapiši ta klon';

  @override
  String get writeClone => 'Zapiši klon';

  @override
  String get writeOnCUID => 'Zapiši na kartico CUID';

  @override
  String get cloneWrittenSuccess => 'Klon uspešno zapisan!';

  @override
  String get requiredTagFormat => 'Zahtevan format oznake';

  @override
  String get type => 'Tip';

  @override
  String get frequency => 'Frekvenca';

  @override
  String get protocol => 'Protokol';

  @override
  String get capacity => 'Kapaciteta';

  @override
  String get feature => 'Funkcija';

  @override
  String get uidModifiable => 'Blok 0 (UID) spremenljiv';

  @override
  String get whereToBuy =>
      'Poiščite \"CUID MiFare Classic 1K\" na AliExpress, Amazon ali eBay (~\$0.50/kos)';

  @override
  String get magicGen2Required =>
      'Kartica Magic Gen2 - MiFare Classic 1K z zapisljivim Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Poiščite \"Magic Gen2 MiFare Classic 1K\" ali \"UID writable\" na AliExpress, Amazon ali eBay (~\$0.50/kos)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Opozorilo: Pisanje z iPhone NFC morda ne bo delovalo na vseh karticah Magic Gen2. Priporočamo napravo Proxmark3 za maksimalno zanesljivost.';

  @override
  String get step1GetMagicGen2 =>
      'Pridobite prazno kartico Magic Gen2 (MiFare Classic 1K z zapisljivim UID)';

  @override
  String get instructions => 'Navodila';

  @override
  String get step1GetCUID =>
      'Pridobite prazno kartico CUID (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Pritisnite gumb \"Zapiši\" spodaj';

  @override
  String get step3HoldPhone => 'Držite telefon blizu kartice CUID';

  @override
  String get step4WaitConfirm => 'Počakajte na potrditev zapisa';

  @override
  String get step5TestClone =>
      'Preizkusite klonirano oznako na tiskalnik Bambu Lab!';

  @override
  String get rsaIncluded =>
      'Klon vključuje izvirni RSA podpis, sprejel ga bo tiskalnik!';

  @override
  String get cloneDeleted => 'Klon izbrisan';

  @override
  String get deleteAccount => 'Izbriši moj račun';

  @override
  String get deleteAccountConfirmation =>
      'To dejanje je nepovratno. Vaš račun in vsi podatki bodo izbrisani v 30 dneh.';

  @override
  String get accountDeletionRequested => 'Zahteva za izbris registrirana';

  @override
  String get clearShoppingList => 'Izprazni seznam';

  @override
  String get clearShoppingListConfirmation =>
      'Ali ste prepričani, da želite izprazniti celoten nakupovalni seznam? Tega dejanja ni mogoče razveljaviti.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Zgodovina';

  @override
  String get retryButton => 'Poskusi znova';

  @override
  String get readSuccessMessage => 'Branje uspešno!';

  @override
  String get filamentTypeLabel => 'Tip filamenta';

  @override
  String get scanNfcChipButton => 'Skeniraj NFC čip';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Izbriši klon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klon \"$name\" izbrisan';
  }

  @override
  String get extruderLabel => 'Ekstruder';

  @override
  String get writeThisCloneButton => 'Zapiši ta klon';

  @override
  String get customNameHint => 'Ime po meri';

  @override
  String get cloneWriteSuccessMessage => 'Klon uspešno zapisan!';

  @override
  String errorPrefix(String error) {
    return 'Napaka: $error';
  }

  @override
  String get writingInProgress => 'Pisanje...';

  @override
  String get writeOnCUIDButton => 'Zapiši na CUID kartico';

  @override
  String get diameterLabel => 'Premer';

  @override
  String get extruderTempLabel => 'Temperatura ekstruderja';

  @override
  String get bedTempLabel => 'Temperatura podlage';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bajtov (1024 bajtov)';

  @override
  String get rsaSignatureNote =>
      'Klon vsebuje izvirni RSA podpis, tiskalnik ga bo sprejel!';

  @override
  String get writeBambuLabTagTitle => 'Zapiši Bambu Lab oznako';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab oznaka uspešno zapisana!';

  @override
  String get approachNfcTagMessage => 'Približaj NFC oznako...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab format (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab format';

  @override
  String get bambuLabFormatInfo =>
      'Ta format uporablja kode materialov Bambu Lab in shranjuje podatke v AMS združljivem formatu.';

  @override
  String get brandLabel => 'Blagovna znamka';

  @override
  String get materialTypeLabel => 'Tip materiala';

  @override
  String get serialNumber3Digits => 'Serijska številka (3 številke)';

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
  String get writeBambuLabTagButton => 'Zapiši Bambu Lab oznako';

  @override
  String get bambuLabRsaNote =>
      'Opomba: Originalne Bambu Lab oznake uporabljajo RSA šifriranje. Ta način zapisuje podatke v poenostavljenem združljivem formatu.';

  @override
  String signInError(String error) {
    return 'Napaka prijave: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Naročnina uspešno aktivirana!';

  @override
  String get subscriptionFailedMessage => 'Naročnina ni uspela';

  @override
  String errorMessage(String error) {
    return 'Napaka: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Naročnina uspešno obnovljena!';

  @override
  String get noSubscriptionFoundMessage => 'Naročnina ni najdena';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTIVNO';

  @override
  String get noAdsExperienceMessage => 'Uživaj v izkušnji brez oglasov!';

  @override
  String get subscribedLabel => 'Naročnik';

  @override
  String get restorePurchasesButton => 'Obnovi nakupe';

  @override
  String get cannotExceedRemainingWeight => 'Ne more preseči preostale teže';

  @override
  String get pleaseEnterLength => 'Vnesite dolžino';

  @override
  String get pleaseEnterValidLength => 'Vnesite veljavno dolžino';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Dolžina koluta ni nastavljena - ni mogoče pretvoriti';

  @override
  String get exceedsRemainingWeight => 'Presega preostalo težo';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Pomagajte nam identificirati ta filament';

  @override
  String get helpUsImprove => 'Pomagajte nam izboljšati!';

  @override
  String get helpIdentifyDescription =>
      'Prebrali smo čip, vendar ga nismo mogli identificirati. Povejte nam, kateri filament je to, da lahko izboljšamo aplikacijo.';

  @override
  String get otherBrand => 'Drugo';

  @override
  String get thankYouFeedback => 'Hvala za vaše mnenje!';

  @override
  String get send => 'Pošlji';

  @override
  String get optionalDetails => 'Neobvezne podrobnosti';

  @override
  String get weightGrams => 'Teža (g)';

  @override
  String get diameterMm => 'Premer (mm)';

  @override
  String get spoolLengthM => 'Dolžina koluta (m)';

  @override
  String get batchNumberLabel => 'Serija / SKU';

  @override
  String get contactUs => 'Kontaktirajte nas';

  @override
  String get contactUsSubtitle => 'Vprašanja, predlogi ali težave';

  @override
  String get nfcTagNotDetected => 'NFC oznaka ni zaznana';

  @override
  String get nfcTagNotDetectedDesc =>
      'Oznaka ni bila najdena. Oznaka je morda mrtva, poškodovana ali predaleč od telefona.';

  @override
  String get nfcTagIncompatible => 'Zaznana nezdružljiva NFC oznaka';

  @override
  String get nfcAuthError => 'Preverjanje pristnosti NFC oznake ni uspelo';

  @override
  String get nfcAuthErrorDesc =>
      'Oznaka je bila zaznana, vendar preverjanje pristnosti po več poskusih ni uspelo. Držite oznako trdno ob zadnji strani telefona in poskusite znova.';

  @override
  String get nfcTagInfoPrusa =>
      'Uporabite prazno kartico NXP ICODE SLIX2 (ISO 15693) za ustvarjanje oznak, združljivih s tehnologijo OpenPrintTag, za Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Zapiši Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Prijava z Apple ni na voljo na tej napravi.';

  @override
  String get signInAppleFailed => 'Prijava z Apple ni uspela. Poskusite znova.';

  @override
  String get signInFailed => 'Prijava ni uspela. Poskusite znova.';

  @override
  String get mustContain3Digits => 'Mora vsebovati 3 številke';

  @override
  String get mustBeNumber => 'Mora biti število';

  @override
  String generatedUidLabel(String uid) {
    return 'Ustvarjen UID: $uid';
  }

  @override
  String get experimentalBadge => 'EKSPERIMENTALNO';

  @override
  String get newBadge => 'NOVO';

  @override
  String get forCrealityCfs => 'za Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Branje in pisanje';

  @override
  String get crealityReadWriteDesc =>
      'Oznake Creality CFS uporabljajo MiFare Classic 1K s šifriranjem AES-128-ECB.';

  @override
  String get platformLimitationTitle => 'Omejitev platforme';

  @override
  String get mifareClassicNotSupportedIos =>
      'Oznake MiFare Classic (Bambu Lab, Creality) niso podprte na iOS-u zaradi omejitve Apple CoreNFC.';

  @override
  String get nfcTagInfoCreality =>
      'Uporabite oznako MiFare Classic 1K za pisanje podatkov, združljivih s Creality CFS, za Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Rdeča, Modra, Črna...';

  @override
  String get dryingTemp => 'Temperatura sušenja';

  @override
  String get dryingTempHint => 'npr. 55';

  @override
  String get dryingTime => 'Čas sušenja (ure)';

  @override
  String get dryingTimeHint => 'npr. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Oznaka zaznana kot $mode — zamenjajte zavihek za naslednja skeniranja';
  }

  @override
  String get fallbackChooseMode => 'Izberite način ročno';

  @override
  String get fallbackChooseModeSubtitle =>
      'Samodejna zaznava ni mogla identificirati te oznake. Izberite protokol:';

  @override
  String get tryAutoDetect => 'Poskusi samodejno zaznavanje';

  @override
  String get autoDetectAllBrands => 'Samodejno zaznavanje — vse znamke';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D in več';

  @override
  String get nfcTipIos =>
      'Bralnik NFC je na vrhu vašega iPhona. Postavite ga neposredno na NFC oznako koluta.';

  @override
  String get nfcTipAndroid =>
      'Bralnik NFC je običajno na sredini zadnje strani telefona. Postavite zadnjo stran telefona na NFC oznako koluta.';

  @override
  String get stockSortBy => 'Razvrsti';

  @override
  String get stockFilter => 'Filter';

  @override
  String get stockSortRecent => 'Najnovejše';

  @override
  String get stockSortBrand => 'Znamka';

  @override
  String get stockSortMaterial => 'Material';

  @override
  String get stockSortRemaining => 'Preostala teža';

  @override
  String get stockSortColor => 'Barva';

  @override
  String get stockFilterAll => 'Vse';

  @override
  String get stockResetFilters => 'Ponastavi';

  @override
  String get stockNoMatch => 'Nobena tuljava ne ustreza filtrom';

  @override
  String get nfcDisabledTitle => 'NFC izklopljen';

  @override
  String get nfcDisabledMessage =>
      'NFC je izklopljen. Vklopite ga v nastavitvah telefona za skeniranje tuljav.';

  @override
  String get updateAvailableTitle => 'Na voljo je posodobitev';

  @override
  String get updateAvailableMessage =>
      'Na voljo je nova različica aplikacije Spool Master.';

  @override
  String get updateForcedMessage =>
      'Ta različica ni več podprta. Za nadaljevanje posodobite.';

  @override
  String get updateNow => 'Posodobi';

  @override
  String get updateLater => 'Pozneje';

  @override
  String get nfcScanGuidance =>
      'Oznako držite pri miru ob vrhu ali zadnji strani telefona.';

  @override
  String get tagMovedTitle => 'Oznaka se je premaknila';

  @override
  String get tagMovedMessage =>
      'Oznaka se je med branjem premaknila. Znova jo prislonite in držite telefon pri miru.';

  @override
  String get lightBlue => 'Svetlo modra';

  @override
  String get transparent => 'Prozorna';

  @override
  String get nfcActiveApproachTag => 'NFC aktiven — približajte značko';

  @override
  String addedToShoppingList(String item) {
    return '$item dodano na nakupovalni seznam';
  }

  @override
  String get deleteAccountFailed =>
      'Brisanje računa ni uspelo. Poskusite znova.';

  @override
  String get scanHistoryError => 'Napaka pri dostopu do zgodovine skeniranj';

  @override
  String get genericBrand => 'Generično';

  @override
  String get stockSearchHint => 'Iskanje (znamka, barva, lokacija…)';

  @override
  String get stockMoreActions => 'Več dejanj';

  @override
  String get exportExcel => 'Izvozi v Excel';

  @override
  String get exportFailed => 'Izvoz ni uspel';

  @override
  String get exportShareSubject => 'Moja zaloga filamenta (Spool Master)';

  @override
  String get exportColorHex => 'Koda barve';

  @override
  String get exportRemainingPercent => 'Preostalo (%)';

  @override
  String get exportPricePerKg => 'Cena / kg';

  @override
  String get exportAddedDate => 'Datum dodajanja';

  @override
  String get exportOrdered => 'Naročeno';

  @override
  String get exportDate => 'Datum';

  @override
  String get exportGrams => 'Grami';

  @override
  String get exportCost => 'Strošek';

  @override
  String get importSpools => 'Uvozi (CSV / Excel)';

  @override
  String get importConfirmTitle => 'Uvoz tuljav';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return 'Tuljave za dodajanje: $count\nŽe na zalogi (preskočene): $duplicates\nNeberljive vrstice (preskočene): $skipped';
  }

  @override
  String get importAction => 'Uvozi';

  @override
  String get importNothingFound =>
      'Nobena tuljava ni bila prepoznana. Datoteka mora vsebovati vsaj stolpca Material in Teža (kot izvoz v Excel iz aplikacije).';

  @override
  String importDone(int count) {
    return 'Uvožene tuljave: $count';
  }

  @override
  String get importFailed => 'Neberljiva datoteka';

  @override
  String get location => 'Lokacija';

  @override
  String get locationHint => 'Npr.: polica A, suha škatla 2';

  @override
  String get notes => 'Opombe';

  @override
  String get notesHint => 'Npr.: posušiti pred uporabo';

  @override
  String get printCostTitle => 'Strošek tiskanja';

  @override
  String get printCostGrams => 'Porabljen filament (g)';

  @override
  String printCostResult(String cost) {
    return 'Strošek materiala: $cost';
  }

  @override
  String printCostPerKg(String price) {
    return 'Cena na kg: $price';
  }

  @override
  String get printCostNoPrice => 'Dodajte ceno tuljave za izračun stroška.';

  @override
  String get printCostDeduct => 'Odštej iz zaloge';

  @override
  String printCostDeducted(String grams) {
    return '$grams g odšteto iz zaloge';
  }

  @override
  String get consumptionTitle => 'Poraba';

  @override
  String get consumptionLast30Days => 'Zadnjih 30 dni';

  @override
  String get consumptionThisMonth => 'Ta mesec';

  @override
  String get consumptionByMaterial => 'Po materialu (30 dni)';

  @override
  String get consumptionMonthly => 'Zadnjih 6 mesecev';

  @override
  String get consumptionEmpty =>
      'Poraba še ni zabeležena. Prikaže se, takoj ko posodobite preostalo težo tuljave ali uporabite kalkulator stroškov.';

  @override
  String get shareShoppingList => 'Deli seznam';

  @override
  String get nfcBlankTagTitle => 'Prazna oznaka';

  @override
  String get nfcBlankTagDesc =>
      'Ta oznaka ne vsebuje podatkov o tuljavi. Tuljavo dodajte ročno ali oznako zapišite v aplikaciji.';

  @override
  String get subscriptionAutoRenewDisclosure =>
      'Plačilo se obremeni na vaš račun v trgovini ob potrditvi nakupa. Naročnina se samodejno obnovi, razen če jo prekličete vsaj 24 ur pred koncem trenutnega obdobja; obnova se zaračuna v 24 urah pred koncem obdobja. Naročnino lahko upravljate ali prekličete v nastavitvah svojega računa v trgovini.';

  @override
  String get manageSubscription => 'Upravljaj naročnino';
}
