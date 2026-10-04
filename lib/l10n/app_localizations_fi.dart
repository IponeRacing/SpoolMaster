// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Varasto';

  @override
  String get statistics => 'Analytiikka';

  @override
  String get profile => 'Profiili';

  @override
  String get readNfcChip => 'Lue NFC-siru';

  @override
  String get scanHistory => 'Historia';

  @override
  String get writeNfcChip => 'Kirjoita NFC-siru';

  @override
  String get nfcNotAvailable => 'NFC ei ole käytettävissä';

  @override
  String get nfcNotAvailableDesc =>
      'Laitteesi ei tue NFC:tä tai se on poistettu käytöstä.';

  @override
  String get nfcNotSupported => 'NFC ei ole tuettu tässä laitteessa';

  @override
  String get approachNfcChip => 'Lähestytä NFC-sirua...';

  @override
  String get scanningNfc => 'Skannaa...';

  @override
  String get nfcDataRead => 'NFC-tiedot luettu onnistuneesti!';

  @override
  String get errorReadingNfc => 'Virhe NFC:n lukemisessa';

  @override
  String get scanHistoryTitle => 'Skannaushistoria';

  @override
  String get noScansRecorded => 'Ei tallennettuja skannauksia';

  @override
  String get scansWillAppearHere =>
      'NFC-skannaukset näkyvät täällä automaattisesti';

  @override
  String get clearAll => 'Tyhjennä kaikki';

  @override
  String get deleteThisScan => 'Poista tämä skannaus?';

  @override
  String get actionIrreversible => 'Tämä toiminto on peruuttamaton.';

  @override
  String get cancel => 'Peruuta';

  @override
  String get delete => 'Poista';

  @override
  String get clearAllHistory => 'Tyhjennä koko historia?';

  @override
  String get allScansWillBeDeleted =>
      'Kaikki skannaukset poistetaan. Tämä toiminto on peruuttamaton.';

  @override
  String get scanDeleted => 'Skannaus poistettu';

  @override
  String get scanDetails => 'Skannauksen tiedot';

  @override
  String scannedOn(Object date) {
    return 'Skannattu $date';
  }

  @override
  String get bobbinInformation => 'Kelan tiedot';

  @override
  String get filamentType => 'Filamentin tyyppi';

  @override
  String get color => 'Väri';

  @override
  String get weight => 'Paino';

  @override
  String get manufacturingDate => 'Valmistuspäivä';

  @override
  String get batchNumber => 'Eränumero';

  @override
  String get printerSettings => 'Tulostimen asetukset';

  @override
  String get scanMetadata => 'Skannauksen metatiedot';

  @override
  String get scanId => 'Skannauksen tunnus';

  @override
  String get dateAndTime => 'Päivämäärä ja aika';

  @override
  String get reuseThisData => 'Käytä näitä tietoja uudelleen';

  @override
  String get writeToNfc => 'Kirjoita NFC:lle';

  @override
  String get writeDataToChip => 'Kirjoita tiedot siruun';

  @override
  String get writeSuccess => 'Kirjoitus onnistui!';

  @override
  String get writeError => 'Kirjoitusvirhe';

  @override
  String get brand => 'Merkki';

  @override
  String get selectBrand => 'Valitse merkki';

  @override
  String get materialType => 'Materiaalityyppi';

  @override
  String get selectMaterial => 'Valitse materiaali';

  @override
  String get serialNumber => 'Sarjanumero';

  @override
  String get serialNumberHint => 'esim.: 001';

  @override
  String get initialWeight => 'Alkupaino';

  @override
  String get initialWeightHint => 'esim.: 1000';

  @override
  String get extruderTempMin => 'Min. suulakkeen lämpö';

  @override
  String get extruderTempMax => 'Maks. suulakkeen lämpö';

  @override
  String get bedTempMin => 'Min. alustan lämpö';

  @override
  String get bedTempMax => 'Maks. alustan lämpö';

  @override
  String get diameter => 'Filamentin halkaisija';

  @override
  String get spoolLength => 'Kelan pituus';

  @override
  String get generatedSku => 'Luotu SKU';

  @override
  String get approachChipToWrite => 'Lähestytä sirua kirjoittaaksesi...';

  @override
  String get writing => 'Kirjoitetaan...';

  @override
  String get chooseColor => 'Valitse väri';

  @override
  String get required => 'Pakollinen';

  @override
  String get invalid => 'Virheellinen';

  @override
  String get advancedSettings => 'Lisäasetukset';

  @override
  String get opacity => 'Läpinäkyvyys';

  @override
  String get validate => 'Vahvista';

  @override
  String get nfcTagInfo =>
      'Käytä tyhjää ISO14443A NFC-tagia (NTAG213) luodaksesi omat Anycubic-tagit.';

  @override
  String get stockInventory => 'Kelat varastossa';

  @override
  String get addSpool => 'Lisää kela';

  @override
  String get scanSpool => 'Skannaa kela';

  @override
  String get addManually => 'Lisää manuaalisesti';

  @override
  String get spoolAdded => 'Kela lisätty';

  @override
  String get spoolUpdated => 'Kela päivitetty';

  @override
  String get noSpoolsInStock => 'Ei keloja varastossa';

  @override
  String get addFirstSpool =>
      'Lisää ensimmäinen kelasi aloittaaksesi varastosi seurannan';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count kela(a) vähissä (< $threshold%)';
  }

  @override
  String get edit => 'Muokkaa';

  @override
  String get bobbinPrice => 'Kelan hinta';

  @override
  String get price => 'Hinta';

  @override
  String get priceHint => 'esim.: 25.00';

  @override
  String get save => 'Tallenna';

  @override
  String get spoolDetails => 'Kelan tiedot';

  @override
  String get deleteThisSpool => 'Poista tämä kela?';

  @override
  String get cannotBeUndone => 'Tätä toimintoa ei voi perua.';

  @override
  String get addSpoolManually => 'Lisää kela manuaalisesti';

  @override
  String get editSpool => 'Muokkaa kelaa';

  @override
  String get customBrand => 'Mukautettu merkki';

  @override
  String get customBrandHint => 'esim.: Oma merkkini';

  @override
  String get chooseFromList => 'Valitse listalta';

  @override
  String get addBrand => '+ Lisää merkki';

  @override
  String get customMaterial => 'Mukautettu materiaali';

  @override
  String get customMaterialHint => 'esim.: Oma materiaalini';

  @override
  String get addMaterial => '+ Lisää materiaali';

  @override
  String get colorHint => 'esim.: Sininen, Punainen...';

  @override
  String get enterColor => 'Anna väri';

  @override
  String get initialWeightG => 'Alkupaino';

  @override
  String get remainingWeightG => 'Jäljellä oleva paino';

  @override
  String get enterBrand => 'Anna merkki';

  @override
  String get selectOrEnterBrand => 'Valitse tai anna merkki';

  @override
  String get quantity => 'Määrä';

  @override
  String get quantityHelper => 'Lisää useita samanlaisia keloja kerralla';

  @override
  String get quantityInvalid => 'Anna luku väliltä 1–99';

  @override
  String spoolsInStockCount(int count) {
    return '$count varastossa';
  }

  @override
  String get enterMaterial => 'Anna materiaali';

  @override
  String get selectOrEnterMaterial => 'Valitse tai anna materiaali';

  @override
  String get enterPrice => 'Anna hinta';

  @override
  String get enterValidPrice => 'Anna kelvollinen hinta';

  @override
  String get enterWeight => 'Anna paino';

  @override
  String get enterValidWeight => 'Anna kelvollinen paino';

  @override
  String get remainingCannotExceedTotal =>
      'Jäljellä oleva paino ei voi ylittää kokonaispainoa';

  @override
  String get overview => 'Yleiskatsaus';

  @override
  String get spoolsInStock => 'Kelat varastossa';

  @override
  String get totalValue => 'Kokonaisarvo';

  @override
  String get lowStockSpools => 'Vähissä';

  @override
  String get materialDistribution => 'Jakautuminen materiaalin mukaan';

  @override
  String get brandDistribution => 'Jakautuminen merkin mukaan';

  @override
  String get noData => 'Ei tietoja';

  @override
  String get refresh => 'Päivitä';

  @override
  String get profileSettings => 'Profiiliasetukset';

  @override
  String get preferences => 'Asetukset';

  @override
  String get language => 'Kieli';

  @override
  String get selectLanguage => 'Valitse kieli';

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
  String get currency => 'Valuutta';

  @override
  String get selectCurrency => 'Valitse valuutta';

  @override
  String get units => 'Yksiköt';

  @override
  String get selectUnits => 'Valitse yksiköt';

  @override
  String get metric => 'Metrinen (mm, g, °C)';

  @override
  String get imperial => 'Brittiläinen (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Vähäisen varaston hälytysraja';

  @override
  String get lowStockThresholdDesc =>
      'Kela katsotaan vähissä olevaksi, jos jäljellä oleva paino on alle tämän prosentin';

  @override
  String get authentication => 'Todennus';

  @override
  String get signInWithGoogle => 'Kirjaudu Googlella';

  @override
  String get signInWithApple => 'Kirjaudu Applella';

  @override
  String get continueWithApple => 'Jatka Applella';

  @override
  String get continueWithGoogle => 'Jatka Googlella';

  @override
  String get comingSoon => 'Tulossa pian';

  @override
  String get about => 'Tietoja';

  @override
  String get version => 'Versio';

  @override
  String get madeWith => 'Tehty ❤️ Anycubic 3D-tulostimille';

  @override
  String get scanBobbinDirectly => 'Skannaa kela';

  @override
  String get nfcEncoder => 'NFC-kooderi';

  @override
  String get length => 'Pituus';

  @override
  String get tempExtruder => 'Suulakkeen lämpö';

  @override
  String get tempBed => 'Alustan lämpö';

  @override
  String get termsOfService => 'Käyttöehdot';

  @override
  String get privacyPolicy => 'Tietosuojakäytäntö';

  @override
  String get legal => 'Lakisääteinen';

  @override
  String get back => 'Takaisin';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get signOut => 'Kirjaudu ulos';

  @override
  String get extruderTempMinHint => 'Esim.: 200';

  @override
  String get extruderTempMaxHint => 'Esim.: 220';

  @override
  String get bedTempMinHint => 'Esim.: 50';

  @override
  String get bedTempMaxHint => 'Esim.: 60';

  @override
  String get diameterHint => 'Esim.: 1.75';

  @override
  String get spoolLengthHint => 'Esim.: 330';

  @override
  String get tabGrid => 'Ruudukko';

  @override
  String get tabSpectrum => 'Spektri';

  @override
  String get tabSliders => 'Liukusäätimet';

  @override
  String get hexCode => 'Hex-koodi';

  @override
  String get red => 'Punainen';

  @override
  String get green => 'Vihreä';

  @override
  String get blue => 'Sininen';

  @override
  String get black => 'Musta';

  @override
  String get white => 'Valkoinen';

  @override
  String get yellow => 'Keltainen';

  @override
  String get orange => 'Oranssi';

  @override
  String get pink => 'Vaaleanpunainen';

  @override
  String get purple => 'Violetti';

  @override
  String get gray => 'Harmaa';

  @override
  String get brown => 'Ruskea';

  @override
  String get unknown => 'Tuntematon';

  @override
  String get metricUnits => 'Metrinen (mm, g, °C)';

  @override
  String get imperialUnits => 'Brittiläinen (in, oz, °F)';

  @override
  String get chf => 'Sveitsin frangi (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Yhdysvaltain dollari (\$)';

  @override
  String get gbp => 'Englannin punta (£)';

  @override
  String get cad => 'Kanadan dollari (CAD)';

  @override
  String get aud => 'Australian dollari (A\$)';

  @override
  String get jpy => 'Japanin jeni (¥)';

  @override
  String get cny => 'Kiinan yuan (¥)';

  @override
  String get inr => 'Intian rupia (₹)';

  @override
  String get brl => 'Brasilian real (R\$)';

  @override
  String get mxn => 'Meksikon peso (MX\$)';

  @override
  String get sek => 'Ruotsin kruunu (kr)';

  @override
  String get nok => 'Norjan kruunu (kr)';

  @override
  String get dkk => 'Tanskan kruunu (kr)';

  @override
  String get pln => 'Puolan zloty (zł)';

  @override
  String get czk => 'Tšekin koruna (Kč)';

  @override
  String get nzd => 'Uuden-Seelannin dollari (NZ\$)';

  @override
  String get filamentsToOrder => 'Tilattavat filamentit';

  @override
  String get shoppingList => 'Ostoslista';

  @override
  String get addToShoppingList => 'Lisää listalle';

  @override
  String get noLowStockFilaments => 'Ei vähissä olevia filamentteja';

  @override
  String get vipSubscriptionDescription =>
      'Tätä tilausta käytetään vain mainosten poistamiseen sovelluksessa ja projektin tukemiseen. Ei muita ominaisuuksia.';

  @override
  String get monthlySubscription => 'Kuukausitilaus';

  @override
  String get yearlySubscription => 'Vuositilaus';

  @override
  String get perMonth => '/ kuukausi';

  @override
  String get perYear => '/ vuosi';

  @override
  String onlyPerMonth(String price) {
    return 'Vain $price / kuukausi';
  }

  @override
  String get subscribe => 'Tilaa';

  @override
  String get bestOffer => '✨ PARAS TARJOUS ✨';

  @override
  String get forAnycubicAce => 'Anycubic Acelle';

  @override
  String get forBambuLabAms => 'Bambu Lab AMS:lle';

  @override
  String get scanNfcChip => 'Skannaa NFC-siru';

  @override
  String get fillForm => 'Täytä lomake';

  @override
  String get emptyShoppingList => 'Ei filamentteja listalla';

  @override
  String percentRemaining(String percent) {
    return '$percent% jäljellä';
  }

  @override
  String get markAsOrdered => 'Merkitse tilatuksi';

  @override
  String get markAsNotOrdered => 'Merkitse tilaamattomaksi';

  @override
  String get notSignedIn => 'Et ole kirjautunut sisään';

  @override
  String get signIn => 'Kirjaudu sisään';

  @override
  String get connection => 'Yhteys';

  @override
  String get signInToSync => 'Kirjaudu sisään synkronoidaksesi tietosi';

  @override
  String get continueWithoutAccount => 'Jatka ilman tiliä (paikallinen tila)';

  @override
  String get privacyNotice =>
      'Kirjautumalla hyväksyt\nKäyttöehdot ja Tietosuojakäytännön';

  @override
  String get updateStock => 'Päivitä varasto';

  @override
  String get scanToUpdateStock => 'Skannaa päivittääksesi';

  @override
  String get weightUsed => 'Käytetty paino';

  @override
  String get lengthUsed => 'Käytetty pituus';

  @override
  String get enterWeightOrLength => 'Syötä käytetty paino tai pituus';

  @override
  String get weightUsedG => 'Käytetty paino (g)';

  @override
  String get lengthUsedM => 'Käytetty pituus (m)';

  @override
  String get stockUpdated => 'Varasto päivitetty';

  @override
  String get scanSpoolToUpdate => 'Skannaa kela päivittääksesi sen varaston';

  @override
  String get spoolNotFound => 'Kelaa ei löytynyt varastosta';

  @override
  String get addSpoolFirstMessage =>
      'Tätä kelaa ei vielä ole varastossasi. Lisää se ensin \'Lisää kela\' -painikkeella ennen varaston päivittämistä.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Vain luku';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab -tagit käyttävät RSA-salausta, eikä niitä voi muokata. Vain luku.';

  @override
  String get forPrusaMk4 => 'Prusa MK4/XL:lle (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Luku ja kirjoitus';

  @override
  String get prusaReadWriteDesc =>
      'Prusa-tunnisteet käyttävät ISO 15693 (NFC-V) -standardia OpenPrintTag-muodossa. Luku ja kirjoitus tuettu.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab kloonkirjasto';

  @override
  String get noBambuClones => 'Ei Bambu Lab klooneja';

  @override
  String get scanBambuToClone =>
      'Skannaa alkuperäisiä Bambu Lab -tageja luodaksesi kloonkirjastosi';

  @override
  String get scanTag => 'Skannaa tagi';

  @override
  String get syncWithCloud => 'Synkronoi pilven kanssa';

  @override
  String get syncCompleted => 'Synkronointi valmis';

  @override
  String get deleteClone => 'Poista klooni';

  @override
  String get renameClone => 'Nimeä klooni uudelleen';

  @override
  String get rename => 'Nimeä uudelleen';

  @override
  String get customName => 'Mukautettu nimi';

  @override
  String get clonedOn => 'Kloonattu';

  @override
  String get writeThisClone => 'Kirjoita tämä klooni';

  @override
  String get writeClone => 'Kirjoita klooni';

  @override
  String get writeOnCUID => 'Kirjoita CUID-kortille';

  @override
  String get cloneWrittenSuccess => 'Klooni kirjoitettu onnistuneesti!';

  @override
  String get requiredTagFormat => 'Vaadittu tagin muoto';

  @override
  String get type => 'Tyyppi';

  @override
  String get frequency => 'Taajuus';

  @override
  String get protocol => 'Protokolla';

  @override
  String get capacity => 'Kapasiteetti';

  @override
  String get feature => 'Ominaisuus';

  @override
  String get uidModifiable => 'Lohko 0 (UID) muokattavissa';

  @override
  String get whereToBuy =>
      'Etsi \"CUID MiFare Classic 1K\" AliExpressistä, Amazonista tai eBaysta (~\$0.50/kpl)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 kortti - MiFare Classic 1K kirjoitettavalla Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Etsi \"Magic Gen2 MiFare Classic 1K\" tai \"UID writable\" AliExpressistä, Amazonista tai eBaysta (~\$0.50/kpl)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Varoitus: Kirjoittaminen iPhone NFC:llä ei välttämättä toimi kaikilla Magic Gen2 korteilla. Proxmark3 laite suositellaan maksimaalisen luotettavuuden vuoksi.';

  @override
  String get step1GetMagicGen2 =>
      'Hanki tyhjä Magic Gen2 kortti (MiFare Classic 1K kirjoitettavalla UID)';

  @override
  String get instructions => 'Ohjeet';

  @override
  String get step1GetCUID => 'Hanki tyhjä CUID-kortti (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Paina alla olevaa \"Kirjoita\"-painiketta';

  @override
  String get step3HoldPhone => 'Pidä puhelimesi CUID-kortin lähellä';

  @override
  String get step4WaitConfirm => 'Odota kirjoitusvahvistusta';

  @override
  String get step5TestClone =>
      'Testaa kloonattu tagi Bambu Lab -tulostimellasi!';

  @override
  String get rsaIncluded =>
      'Klooni sisältää alkuperäisen RSA-allekirjoituksen, tulostin hyväksyy sen!';

  @override
  String get cloneDeleted => 'Klooni poistettu';

  @override
  String get deleteAccount => 'Poista tilini';

  @override
  String get deleteAccountConfirmation =>
      'Tämä toiminto on peruuttamaton. Tilisi ja kaikki tiedot poistetaan 30 päivän kuluessa.';

  @override
  String get accountDeletionRequested => 'Poistopyyntö rekisteröity';

  @override
  String get clearShoppingList => 'Tyhjennä lista';

  @override
  String get clearShoppingListConfirmation =>
      'Haluatko varmasti tyhjentää koko ostoslistan? Tätä toimintoa ei voi kumota.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Historia';

  @override
  String get retryButton => 'Yritä uudelleen';

  @override
  String get readSuccessMessage => 'Luku onnistui!';

  @override
  String get filamentTypeLabel => 'Filamenttityyppi';

  @override
  String get scanNfcChipButton => 'Skannaa NFC-siru';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Poista klooni \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klooni \"$name\" poistettu';
  }

  @override
  String get extruderLabel => 'Suulake';

  @override
  String get writeThisCloneButton => 'Kirjoita tämä klooni';

  @override
  String get customNameHint => 'Mukautettu nimi';

  @override
  String get cloneWriteSuccessMessage => 'Klooni kirjoitettu!';

  @override
  String errorPrefix(String error) {
    return 'Virhe: $error';
  }

  @override
  String get writingInProgress => 'Kirjoitetaan...';

  @override
  String get writeOnCUIDButton => 'Kirjoita CUID-kortille';

  @override
  String get diameterLabel => 'Halkaisija';

  @override
  String get extruderTempLabel => 'Suulakelämpötila';

  @override
  String get bedTempLabel => 'Pedin lämpötila';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K tavua (1024 tavua)';

  @override
  String get rsaSignatureNote =>
      'Klooni sisältää alkuperäisen RSA-allekirjoituksen, tulostin hyväksyy sen!';

  @override
  String get writeBambuLabTagTitle => 'Kirjoita Bambu Lab -tunniste';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab -tunniste kirjoitettu!';

  @override
  String get approachNfcTagMessage => 'Tuo NFC-tunniste lähelle...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab -muoto (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab -muoto';

  @override
  String get bambuLabFormatInfo =>
      'Tämä muoto käyttää Bambu Lab -materiaalikoodeja ja tallentaa tiedot AMS-yhteensopivassa muodossa.';

  @override
  String get brandLabel => 'Merkki';

  @override
  String get materialTypeLabel => 'Materiaalityyppi';

  @override
  String get serialNumber3Digits => 'Sarjanumero (3 numeroa)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (vakio)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Kirjoita Bambu Lab -tunniste';

  @override
  String get bambuLabRsaNote =>
      'Huom: Alkuperäiset Bambu Lab -tunnisteet käyttävät RSA-salausta. Tämä tila kirjoittaa tiedot yksinkertaistetussa yhteensopivassa muodossa.';

  @override
  String signInError(String error) {
    return 'Kirjautumisvirhe: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Tilaus aktivoitu!';

  @override
  String get subscriptionFailedMessage => 'Tilaus epäonnistui';

  @override
  String errorMessage(String error) {
    return 'Virhe: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Tilaus palautettu!';

  @override
  String get noSubscriptionFoundMessage => 'Tilausta ei löytynyt';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTIIVINEN';

  @override
  String get noAdsExperienceMessage => 'Nauti mainoksettomasta kokemuksesta!';

  @override
  String get subscribedLabel => 'Tilaaja';

  @override
  String get restorePurchasesButton => 'Palauta ostot';

  @override
  String get cannotExceedRemainingWeight =>
      'Ei voi ylittää jäljellä olevaa painoa';

  @override
  String get pleaseEnterLength => 'Anna pituus';

  @override
  String get pleaseEnterValidLength => 'Anna kelvollinen pituus';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Kelan pituutta ei asetettu - ei voi muuntaa';

  @override
  String get exceedsRemainingWeight => 'Ylittää jäljellä olevan painon';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Auta meitä tunnistamaan tämä filamentti';

  @override
  String get helpUsImprove => 'Auta meitä parantamaan!';

  @override
  String get helpIdentifyDescription =>
      'Luimme sirun, mutta emme pystyneet tunnistamaan sitä. Kerro meille mikä filamentti tämä on, jotta voimme parantaa sovellusta.';

  @override
  String get otherBrand => 'Muu';

  @override
  String get thankYouFeedback => 'Kiitos palautteestasi!';

  @override
  String get send => 'Lähetä';

  @override
  String get optionalDetails => 'Valinnaiset tiedot';

  @override
  String get weightGrams => 'Paino (g)';

  @override
  String get diameterMm => 'Halkaisija (mm)';

  @override
  String get spoolLengthM => 'Kelan pituus (m)';

  @override
  String get batchNumberLabel => 'Erä / SKU';

  @override
  String get contactUs => 'Ota yhteyttä';

  @override
  String get contactUsSubtitle => 'Kysymyksiä, ehdotuksia tai ongelmia';

  @override
  String get nfcTagNotDetected => 'NFC-tagia ei havaittu';

  @override
  String get nfcTagNotDetectedDesc =>
      'Tagia ei löytynyt. Tagi voi olla kuollut, vaurioitunut tai liian kaukana puhelimesta.';

  @override
  String get nfcTagIncompatible => 'Yhteensopimaton NFC-tagi havaittu';

  @override
  String get nfcAuthError => 'NFC-tunnisteen todennus epäonnistui';

  @override
  String get nfcAuthErrorDesc =>
      'Tunniste havaittiin, mutta todennus epäonnistui useiden yritysten jälkeen. Pidä tunniste tukevasti puhelimen takaosaa vasten ja yritä uudelleen.';

  @override
  String get nfcTagInfoPrusa =>
      'Käytä tyhjää NXP ICODE SLIX2 -korttia (ISO 15693) OpenPrintTag-yhteensopivien tunnisteiden luomiseen Prusa MK4/XL:lle.';

  @override
  String get writePrusaTagTitle => 'Kirjoita Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Apple-kirjautuminen ei ole käytettävissä tällä laitteella.';

  @override
  String get signInAppleFailed =>
      'Apple-kirjautuminen epäonnistui. Yritä uudelleen.';

  @override
  String get signInFailed => 'Kirjautuminen epäonnistui. Yritä uudelleen.';

  @override
  String get mustContain3Digits => 'Täytyy sisältää 3 numeroa';

  @override
  String get mustBeNumber => 'Täytyy olla numero';

  @override
  String generatedUidLabel(String uid) {
    return 'Luotu UID: $uid';
  }

  @override
  String get experimentalBadge => 'KOKEELLINEN';

  @override
  String get newBadge => 'UUSI';

  @override
  String get forCrealityCfs => 'Creality CFS:lle';

  @override
  String get crealityReadWrite => 'Creality: Luku & kirjoitus';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS -tagit käyttävät MiFare Classic 1K:ta AES-128-ECB-salauksella.';

  @override
  String get platformLimitationTitle => 'Alustarajoitus';

  @override
  String get mifareClassicNotSupportedIos =>
      'MiFare Classic -tageja (Bambu Lab, Creality) ei tueta iOS:llä Apple CoreNFC -rajoituksen vuoksi.';

  @override
  String get nfcTagInfoCreality =>
      'Käytä MiFare Classic 1K -tagia kirjoittaaksesi Creality CFS -yhteensopivia tietoja Creality K2 Plus -tulostimelle.';

  @override
  String get colorHintExamples => 'Punainen, Sininen, Musta...';

  @override
  String get dryingTemp => 'Kuivauslämpötila';

  @override
  String get dryingTempHint => 'esim. 55';

  @override
  String get dryingTime => 'Kuivausaika (tunnit)';

  @override
  String get dryingTimeHint => 'esim. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tunniste havaittu muodossa $mode — vaihda välilehteä seuraavia skannauksia varten';
  }

  @override
  String get fallbackChooseMode => 'Valitse tila manuaalisesti';

  @override
  String get fallbackChooseModeSubtitle =>
      'Automaattinen tunnistus ei tunnistanut tätä tunnistetta. Valitse protokolla:';

  @override
  String get tryAutoDetect => 'Kokeile automaattista tunnistusta';

  @override
  String get autoDetectAllBrands => 'Automaattinen tunnistus — kaikki merkit';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D ja muut';

  @override
  String get nfcTipIos =>
      'NFC-lukija on iPhonesi yläosassa. Aseta se suoraan kelan NFC-tagin päälle.';

  @override
  String get nfcTipAndroid =>
      'NFC-lukija on yleensä puhelimen takaosan keskellä. Aseta puhelimen takaosa kelan NFC-tagin päälle.';

  @override
  String get stockSortBy => 'Lajittele';

  @override
  String get stockFilter => 'Suodata';

  @override
  String get stockSortRecent => 'Uusimmat';

  @override
  String get stockSortBrand => 'Merkki';

  @override
  String get stockSortMaterial => 'Materiaali';

  @override
  String get stockSortRemaining => 'Jäljellä oleva paino';

  @override
  String get stockSortColor => 'Väri';

  @override
  String get stockFilterAll => 'Kaikki';

  @override
  String get stockResetFilters => 'Nollaa';

  @override
  String get stockNoMatch => 'Mikään rulla ei vastaa suodattimia';

  @override
  String get nfcDisabledTitle => 'NFC pois käytöstä';

  @override
  String get nfcDisabledMessage =>
      'NFC on pois käytöstä. Ota se käyttöön puhelimen asetuksista skannataksesi rullat.';

  @override
  String get updateAvailableTitle => 'Päivitys saatavilla';

  @override
  String get updateAvailableMessage =>
      'Spool Masterista on saatavilla uusi versio.';

  @override
  String get updateForcedMessage =>
      'Tätä versiota ei enää tueta. Päivitä jatkaaksesi.';

  @override
  String get updateNow => 'Päivitä';

  @override
  String get updateLater => 'Myöhemmin';

  @override
  String get nfcScanGuidance =>
      'Pidä tagia paikallaan puhelimen ylä- tai takaosaa vasten.';

  @override
  String get tagMovedTitle => 'Tagi liikkui';

  @override
  String get tagMovedMessage =>
      'Tagi liikkui lukemisen aikana. Aseta se takaisin ja pidä puhelin paikallaan.';

  @override
  String get lightBlue => 'Vaaleansininen';

  @override
  String get transparent => 'Läpinäkyvä';

  @override
  String get nfcActiveApproachTag => 'NFC aktiivinen — vie tagi lähelle';

  @override
  String addedToShoppingList(String item) {
    return '$item lisätty ostoslistalle';
  }

  @override
  String get deleteAccountFailed =>
      'Tilin poistaminen epäonnistui. Yritä uudelleen.';

  @override
  String get scanHistoryError => 'Virhe skannaushistorian käytössä';

  @override
  String get genericBrand => 'Yleinen';

  @override
  String get stockSearchHint => 'Hae (merkki, väri, sijainti…)';

  @override
  String get stockMoreActions => 'Lisää toimintoja';

  @override
  String get exportExcel => 'Vie Exceliin';

  @override
  String get exportFailed => 'Vienti epäonnistui';

  @override
  String get exportShareSubject => 'Filamenttivarastoni (Spool Master)';

  @override
  String get exportColorHex => 'Värikoodi';

  @override
  String get exportRemainingPercent => 'Jäljellä (%)';

  @override
  String get exportPricePerKg => 'Hinta / kg';

  @override
  String get exportAddedDate => 'Lisäyspäivä';

  @override
  String get exportOrdered => 'Tilattu';

  @override
  String get exportDate => 'Päivämäärä';

  @override
  String get exportGrams => 'Grammat';

  @override
  String get exportCost => 'Kustannus';

  @override
  String get importSpools => 'Tuo (CSV / Excel)';

  @override
  String get importConfirmTitle => 'Tuo keloja';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return 'Lisättävät kelat: $count\nJo varastossa (ohitetaan): $duplicates\nLuettamattomat rivit (ohitetaan): $skipped';
  }

  @override
  String get importAction => 'Tuo';

  @override
  String get importNothingFound =>
      'Keloja ei tunnistettu. Tiedostossa on oltava vähintään sarakkeet Materiaali ja Paino (kuten sovelluksen Excel-vienti).';

  @override
  String importDone(int count) {
    return 'Tuodut kelat: $count';
  }

  @override
  String get importFailed => 'Tiedostoa ei voi lukea';

  @override
  String get location => 'Sijainti';

  @override
  String get locationHint => 'Esim. hylly A, kuivalaatikko 2';

  @override
  String get notes => 'Muistiinpanot';

  @override
  String get notesHint => 'Esim. kuivaa ennen käyttöä';

  @override
  String get printCostTitle => 'Tulostuksen kustannus';

  @override
  String get printCostGrams => 'Käytetty filamentti (g)';

  @override
  String printCostResult(String cost) {
    return 'Materiaalikustannus: $cost';
  }

  @override
  String printCostPerKg(String price) {
    return 'Hinta per kg: $price';
  }

  @override
  String get printCostNoPrice => 'Lisää kelan hinta kustannuksen laskemiseksi.';

  @override
  String get printCostDeduct => 'Vähennä varastosta';

  @override
  String printCostDeducted(String grams) {
    return '$grams g vähennetty varastosta';
  }

  @override
  String get consumptionTitle => 'Kulutus';

  @override
  String get consumptionLast30Days => 'Viimeiset 30 päivää';

  @override
  String get consumptionThisMonth => 'Tässä kuussa';

  @override
  String get consumptionByMaterial => 'Materiaalin mukaan (30 päivää)';

  @override
  String get consumptionMonthly => 'Viimeiset 6 kuukautta';

  @override
  String get consumptionEmpty =>
      'Kulutusta ei ole vielä kirjattu. Se näkyy, kun päivität kelan jäljellä olevan painon tai käytät kustannuslaskuria.';

  @override
  String get shareShoppingList => 'Jaa lista';

  @override
  String get nfcBlankTagTitle => 'Tyhjä tagi';

  @override
  String get nfcBlankTagDesc =>
      'Tämä tagi ei sisällä kelan tietoja. Lisää kela käsin tai kirjoita tagi sovelluksessa.';

  @override
  String get subscriptionAutoRenewDisclosure =>
      'Maksu veloitetaan kauppatililtäsi oston vahvistuksen yhteydessä. Tilaus uusiutuu automaattisesti, ellei sitä peruuteta vähintään 24 tuntia ennen kuluvan jakson päättymistä; uusiminen veloitetaan 24 tunnin sisällä ennen jakson päättymistä. Voit hallita tai peruuttaa tilauksesi kauppatilisi asetuksista.';

  @override
  String get manageSubscription => 'Hallitse tilausta';
}
