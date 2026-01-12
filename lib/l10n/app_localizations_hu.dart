// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Raktár';

  @override
  String get statistics => 'Statisztikák';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'NFC Chip Olvasása';

  @override
  String get scanHistory => 'Előzmények';

  @override
  String get writeNfcChip => 'NFC Chip Írása';

  @override
  String get nfcNotAvailable => 'NFC nem elérhető';

  @override
  String get nfcNotAvailableDesc =>
      'Az eszközöd nem támogatja az NFC-t vagy le van tiltva.';

  @override
  String get nfcNotSupported => 'Az NFC nem támogatott ezen az eszközön';

  @override
  String get approachNfcChip => 'Közelítsd az NFC chipet...';

  @override
  String get scanningNfc => 'Beolvasás...';

  @override
  String get nfcDataRead => 'NFC adatok sikeresen beolvasva!';

  @override
  String get errorReadingNfc => 'NFC olvasási hiba';

  @override
  String get scanHistoryTitle => 'Beolvasási Előzmények';

  @override
  String get noScansRecorded => 'Nincs rögzített beolvasás';

  @override
  String get scansWillAppearHere =>
      'Az NFC beolvasások automatikusan itt jelennek meg';

  @override
  String get clearAll => 'Összes törlése';

  @override
  String get deleteThisScan => 'Törlöd ezt a beolvasást?';

  @override
  String get actionIrreversible => 'Ez a művelet visszafordíthatatlan.';

  @override
  String get cancel => 'Mégse';

  @override
  String get delete => 'Törlés';

  @override
  String get clearAllHistory => 'Törlöd az összes előzményt?';

  @override
  String get allScansWillBeDeleted =>
      'Minden beolvasás törlődik. Ez a művelet visszafordíthatatlan.';

  @override
  String get scanDeleted => 'Beolvasás törölve';

  @override
  String get scanDetails => 'Beolvasás Részletei';

  @override
  String scannedOn(Object date) {
    return 'Beolvasva: $date';
  }

  @override
  String get bobbinInformation => 'Orsó Információk';

  @override
  String get filamentType => 'Filament Típus';

  @override
  String get color => 'Szín';

  @override
  String get weight => 'Súly';

  @override
  String get manufacturingDate => 'Gyártási Dátum';

  @override
  String get batchNumber => 'Tételszám';

  @override
  String get printerSettings => 'Nyomtató beállítások';

  @override
  String get scanMetadata => 'Beolvasás Metaadatok';

  @override
  String get scanId => 'Beolvasás ID';

  @override
  String get dateAndTime => 'Dátum és Idő';

  @override
  String get reuseThisData => 'Adatok újrafelhasználása';

  @override
  String get writeToNfc => 'Írás NFC-re';

  @override
  String get writeDataToChip => 'Adatok írása a chipre';

  @override
  String get writeSuccess => 'Írás sikeres!';

  @override
  String get writeError => 'Írási hiba';

  @override
  String get brand => 'Márka';

  @override
  String get selectBrand => 'Márka kiválasztása';

  @override
  String get materialType => 'Anyag Típus';

  @override
  String get selectMaterial => 'Anyag kiválasztása';

  @override
  String get serialNumber => 'Sorozatszám';

  @override
  String get serialNumberHint => 'pl.: 001';

  @override
  String get initialWeight => 'Kezdeti Súly';

  @override
  String get initialWeightHint => 'pl.: 1000';

  @override
  String get extruderTempMin => 'Extruder Hőm. Min';

  @override
  String get extruderTempMax => 'Extruder Hőm. Max';

  @override
  String get bedTempMin => 'Tárgyasztal Hőm. Min';

  @override
  String get bedTempMax => 'Tárgyasztal Hőm. Max';

  @override
  String get diameter => 'Átmérő';

  @override
  String get spoolLength => 'Hossz (m)';

  @override
  String get generatedSku => 'Generált SKU';

  @override
  String get approachChipToWrite => 'Közelítsd a chipet az íráshoz...';

  @override
  String get writing => 'Írás...';

  @override
  String get chooseColor => 'Szín választása';

  @override
  String get required => 'Kötelező';

  @override
  String get invalid => 'Érvénytelen';

  @override
  String get advancedSettings => 'Speciális Beállítások';

  @override
  String get opacity => 'Átlátszatlanság';

  @override
  String get validate => 'Érvényesít';

  @override
  String get nfcTagInfo =>
      'Használj üres ISO14443A NFC címkét (NTAG213) saját Anycubic címkék létrehozásához.';

  @override
  String get stockInventory => 'Készleten lévő orsók';

  @override
  String get addSpool => 'Orsó Hozzáadása';

  @override
  String get scanSpool => 'Orsó Beolvasása';

  @override
  String get addManually => 'Kézi Hozzáadás';

  @override
  String get spoolAdded => 'Orsó hozzáadva';

  @override
  String get spoolUpdated => 'Orsó frissítve';

  @override
  String get noSpoolsInStock => 'Nincs orsó a raktárban';

  @override
  String get addFirstSpool =>
      'Add hozzá az első orsót a készlet nyomon követésének megkezdéséhez';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count orsó alacsony készlettel (< $threshold%)';
  }

  @override
  String get edit => 'Szerkesztés';

  @override
  String get bobbinPrice => 'Orsó Ár';

  @override
  String get price => 'Ár';

  @override
  String get priceHint => 'pl.: 25.00';

  @override
  String get save => 'Mentés';

  @override
  String get spoolDetails => 'Orsó Részletei';

  @override
  String get deleteThisSpool => 'Törlöd ezt az orsót?';

  @override
  String get cannotBeUndone => 'Ez a művelet nem vonható vissza.';

  @override
  String get addSpoolManually => 'Orsó Kézi Hozzáadása';

  @override
  String get editSpool => 'Orsó Szerkesztése';

  @override
  String get customBrand => 'Egyedi Márka';

  @override
  String get customBrandHint => 'pl.: Saját Márka';

  @override
  String get chooseFromList => 'Választás listából';

  @override
  String get addBrand => '+ Márka Hozzáadása';

  @override
  String get customMaterial => 'Egyedi Anyag';

  @override
  String get customMaterialHint => 'pl.: Saját Anyag';

  @override
  String get addMaterial => '+ Anyag Hozzáadása';

  @override
  String get colorHint => 'pl.: Kék, Piros...';

  @override
  String get enterColor => 'Kérlek adj meg egy színt';

  @override
  String get initialWeightG => 'Kezdeti Súly';

  @override
  String get remainingWeightG => 'Fennmaradó Súly';

  @override
  String get enterBrand => 'Kérlek adj meg egy márkát';

  @override
  String get selectOrEnterBrand => 'Kérlek válassz vagy adj meg egy márkát';

  @override
  String get enterMaterial => 'Kérlek adj meg egy anyagot';

  @override
  String get selectOrEnterMaterial => 'Kérlek válassz vagy adj meg egy anyagot';

  @override
  String get enterPrice => 'Kérlek adj meg egy árat';

  @override
  String get enterValidPrice => 'Kérlek adj meg érvényes árat';

  @override
  String get enterWeight => 'Kérlek adj meg egy súlyt';

  @override
  String get enterValidWeight => 'Kérlek adj meg érvényes súlyt';

  @override
  String get remainingCannotExceedTotal =>
      'A fennmaradó súly nem haladhatja meg a teljes súlyt';

  @override
  String get overview => 'Áttekintés';

  @override
  String get spoolsInStock => 'Orsók Raktáron';

  @override
  String get totalValue => 'Teljes Érték';

  @override
  String get lowStockSpools => 'Alacsony Készlet';

  @override
  String get materialDistribution => 'Eloszlás Anyag Szerint';

  @override
  String get brandDistribution => 'Eloszlás Márka Szerint';

  @override
  String get noData => 'Nincs adat';

  @override
  String get refresh => 'Frissítés';

  @override
  String get profileSettings => 'Profil Beállítások';

  @override
  String get preferences => 'Beállítások';

  @override
  String get language => 'Nyelv';

  @override
  String get selectLanguage => 'Nyelv kiválasztása';

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
  String get currency => 'Pénznem';

  @override
  String get selectCurrency => 'Pénznem kiválasztása';

  @override
  String get units => 'Mértékegységek';

  @override
  String get selectUnits => 'Mértékegységek kiválasztása';

  @override
  String get metric => 'Metrikus (mm, g, °C)';

  @override
  String get imperial => 'Angolszász (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Alacsony Készlet Riasztási Küszöb';

  @override
  String get lowStockThresholdDesc =>
      'Egy orsó alacsony készletűnek számít, ha a fennmaradó súly kevesebb, mint ez a százalék';

  @override
  String get authentication => 'Hitelesítés';

  @override
  String get signInWithGoogle => 'Bejelentkezés Google-lal';

  @override
  String get signInWithApple => 'Bejelentkezés Apple-lel';

  @override
  String get comingSoon => 'Hamarosan';

  @override
  String get about => 'Névjegy';

  @override
  String get version => 'Verzió';

  @override
  String get madeWith => 'Készült ❤️-tel Anycubic 3D Nyomtatókhoz';

  @override
  String get scanBobbinDirectly => 'Orsó Beolvasása';

  @override
  String get nfcEncoder => 'NFC Kódoló';

  @override
  String get length => 'Hossz';

  @override
  String get tempExtruder => 'Extruder Hőm.';

  @override
  String get tempBed => 'Tárgyasztal Hőm.';

  @override
  String get termsOfService => 'Szolgáltatási Feltételek';

  @override
  String get privacyPolicy => 'Adatvédelmi Szabályzat';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Vissza';

  @override
  String get retry => 'Újra';

  @override
  String get signOut => 'Kijelentkezés';

  @override
  String get extruderTempMinHint => 'pl.: 200';

  @override
  String get extruderTempMaxHint => 'pl.: 220';

  @override
  String get bedTempMinHint => 'pl.: 50';

  @override
  String get bedTempMaxHint => 'pl.: 60';

  @override
  String get diameterHint => 'pl.: 1.75';

  @override
  String get spoolLengthHint => 'pl.: 330';

  @override
  String get tabGrid => 'Rács';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Csúszkák';

  @override
  String get hexCode => 'Hexadecimális kód';

  @override
  String get red => 'Piros';

  @override
  String get green => 'Zöld';

  @override
  String get blue => 'Kék';

  @override
  String get metricUnits => 'Metrikus (mm, g, °C)';

  @override
  String get imperialUnits => 'Angolszász (in, oz, °F)';

  @override
  String get chf => 'Svájci frank (CHF)';

  @override
  String get eur => 'Euró (€)';

  @override
  String get usd => 'Amerikai dollár (\$)';

  @override
  String get gbp => 'Font sterling (£)';

  @override
  String get cad => 'Kanadai dollár (CAD)';

  @override
  String get filamentsToOrder => 'Rendelendő filamentek';

  @override
  String get shoppingList => 'Bevásárlólista';

  @override
  String get addToShoppingList => 'Hozzáadás a listához';

  @override
  String get noLowStockFilaments => 'Nincsenek alacsony készletű filamentek';

  @override
  String get vipSubscriptionDescription =>
      'Ez az előfizetés csak az alkalmazáson belüli hirdetések letiltására és a projekt támogatására szolgál. Nincs más funkció.';

  @override
  String get monthlySubscription => 'Havi előfizetés';

  @override
  String get yearlySubscription => 'Éves előfizetés';

  @override
  String get perMonth => '/ hó';

  @override
  String get perYear => '/ év';

  @override
  String onlyPerMonth(String price) {
    return 'Csak $price / hó';
  }

  @override
  String get subscribe => 'Feliratkozás';

  @override
  String get bestOffer => '✨ LEGJOBB AJÁNLAT ✨';

  @override
  String get forAnycubicAce => 'Anycubic Ace-hez';

  @override
  String get forBambuLabAms => 'Bambu Lab AMS-hez';

  @override
  String get scanNfcChip => 'NFC chip beolvasása';

  @override
  String get fillForm => 'Űrlap kitöltése';

  @override
  String get emptyShoppingList => 'Nincsenek filamentek a listán';

  @override
  String percentRemaining(String percent) {
    return '$percent% maradt';
  }

  @override
  String get markAsOrdered => 'Megjelölés rendelve';

  @override
  String get markAsNotOrdered => 'Megjelölés nem rendelve';

  @override
  String get notSignedIn => 'Nincs bejelentkezve';

  @override
  String get signIn => 'Bejelentkezés';

  @override
  String get connection => 'Bejelentkezés';

  @override
  String get signInToSync => 'Jelentkezzen be az adatok szinkronizálásához';

  @override
  String get continueWithoutAccount => 'Folytatás fiók nélkül (helyi mód)';

  @override
  String get privacyNotice =>
      'A bejelentkezéssel elfogadja\nFelhasználási feltételeinket és Adatvédelmi szabályzatunkat';

  @override
  String get updateStock => 'Készlet frissítése';

  @override
  String get scanToUpdateStock => 'Beolvasás a frissítéshez';

  @override
  String get weightUsed => 'Felhasznált súly';

  @override
  String get lengthUsed => 'Felhasznált hossz';

  @override
  String get enterWeightOrLength => 'Adja meg a felhasznált súlyt vagy hosszt';

  @override
  String get weightUsedG => 'Felhasznált súly (g)';

  @override
  String get lengthUsedM => 'Felhasznált hossz (m)';

  @override
  String get stockUpdated => 'Készlet frissítve';

  @override
  String get scanSpoolToUpdate => 'Olvassa be az orsót a készlet frissítéséhez';

  @override
  String get spoolNotFound => 'Az orsó nem található a készletben';

  @override
  String get addSpoolFirstMessage =>
      'Ez az orsó még nincs a készletében. Kérjük, először adja hozzá az \'Orsó hozzáadása\' gomb használatával, mielőtt frissítené a készletet.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Csak olvasható';

  @override
  String get bambuLabReadOnlyDesc =>
      'A Bambu Lab címkék RSA titkosítást használnak és nem módosíthatók. Csak olvasható.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab klón könyvtár';

  @override
  String get noBambuClones => 'Nincsenek Bambu Lab klónok';

  @override
  String get scanBambuToClone =>
      'Olvassa be az eredeti Bambu Lab címkéket a klón könyvtár létrehozásához';

  @override
  String get scanTag => 'Címke beolvasása';

  @override
  String get syncWithCloud => 'Szinkronizálás a felhővel';

  @override
  String get syncCompleted => 'Szinkronizálás befejezve';

  @override
  String get deleteClone => 'Klón törlése';

  @override
  String get renameClone => 'Klón átnevezése';

  @override
  String get rename => 'Átnevezés';

  @override
  String get customName => 'Egyéni név';

  @override
  String get clonedOn => 'Klónozva';

  @override
  String get writeThisClone => 'Klón írása';

  @override
  String get writeClone => 'Klón írása';

  @override
  String get writeOnCUID => 'Írás CUID kártyára';

  @override
  String get cloneWrittenSuccess => 'Klón sikeresen írva!';

  @override
  String get requiredTagFormat => 'Szükséges címke formátum';

  @override
  String get type => 'Típus';

  @override
  String get frequency => 'Frekvencia';

  @override
  String get protocol => 'Protokoll';

  @override
  String get capacity => 'Kapacitás';

  @override
  String get feature => 'Funkció';

  @override
  String get uidModifiable => '0. blokk (UID) módosítható';

  @override
  String get whereToBuy =>
      'Keressen \"CUID MiFare Classic 1K\" kártyát az AliExpressen, Amazonon vagy eBay-en (~\$0.50/darab)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 kártya - MiFare Classic 1K írható Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Keresse a \"Magic Gen2 MiFare Classic 1K\" vagy \"UID writable\" kifejezést az AliExpressen, Amazonon vagy eBay-en (~\$0.50/darab)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Figyelmeztetés: Az írás iPhone NFC-vel nem biztos, hogy minden Magic Gen2 kártyán működik. A megbízhatóság érdekében Android NFC Tools Pro alkalmazással vagy Proxmark3 eszköz javasolt.';

  @override
  String get step1GetMagicGen2 =>
      'Szerezzen be egy üres Magic Gen2 kártyát (MiFare Classic 1K írható UID-del)';

  @override
  String get instructions => 'Utasítások';

  @override
  String get step1GetCUID =>
      'Szerezzen be egy üres CUID kártyát (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Nyomja meg az alábbi \"Írás\" gombot';

  @override
  String get step3HoldPhone => 'Tartsa iPhone-ját a CUID kártya közelében';

  @override
  String get step4WaitConfirm => 'Várja meg az írás megerősítését';

  @override
  String get step5TestClone =>
      'Tesztelje a klónozott címkét Bambu Lab nyomtatóján!';

  @override
  String get rsaIncluded =>
      'A klón tartalmazza az eredeti RSA aláírást, a nyomtató elfogadja!';

  @override
  String get cloneDeleted => 'Klón törölve';
}
