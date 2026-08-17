// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Voorraad';

  @override
  String get statistics => 'Statistieken';

  @override
  String get profile => 'Profiel';

  @override
  String get readNfcChip => 'NFC-chip lezen';

  @override
  String get scanHistory => 'Geschiedenis';

  @override
  String get writeNfcChip => 'NFC-chip schrijven';

  @override
  String get nfcNotAvailable => 'NFC niet beschikbaar';

  @override
  String get nfcNotAvailableDesc =>
      'Uw apparaat ondersteunt geen NFC of het is uitgeschakeld.';

  @override
  String get nfcNotSupported => 'NFC wordt niet ondersteund op dit apparaat';

  @override
  String get approachNfcChip => 'Benader een NFC-chip...';

  @override
  String get scanningNfc => 'Scannen...';

  @override
  String get nfcDataRead => 'NFC-gegevens succesvol gelezen!';

  @override
  String get errorReadingNfc => 'Fout bij het lezen van NFC';

  @override
  String get scanHistoryTitle => 'Scangeschiedenis';

  @override
  String get noScansRecorded => 'Geen scans opgenomen';

  @override
  String get scansWillAppearHere => 'NFC-scans verschijnen hier automatisch';

  @override
  String get clearAll => 'Alles wissen';

  @override
  String get deleteThisScan => 'Deze scan verwijderen?';

  @override
  String get actionIrreversible => 'Deze actie is onomkeerbaar.';

  @override
  String get cancel => 'Annuleren';

  @override
  String get delete => 'Verwijderen';

  @override
  String get clearAllHistory => 'Alle geschiedenis wissen?';

  @override
  String get allScansWillBeDeleted =>
      'Alle scans worden verwijderd. Deze actie is onomkeerbaar.';

  @override
  String get scanDeleted => 'Scan verwijderd';

  @override
  String get scanDetails => 'Scandetails';

  @override
  String scannedOn(Object date) {
    return 'Gescand op $date';
  }

  @override
  String get bobbinInformation => 'Spoelinformatie';

  @override
  String get filamentType => 'Filamenttype';

  @override
  String get color => 'Kleur';

  @override
  String get weight => 'Gewicht';

  @override
  String get manufacturingDate => 'Productiedatum';

  @override
  String get batchNumber => 'Batchnummer';

  @override
  String get printerSettings => 'Printerinstellingen';

  @override
  String get scanMetadata => 'Scanmetadata';

  @override
  String get scanId => 'Scan-ID';

  @override
  String get dateAndTime => 'Datum en tijd';

  @override
  String get reuseThisData => 'Deze gegevens hergebruiken';

  @override
  String get writeToNfc => 'Naar NFC schrijven';

  @override
  String get writeDataToChip => 'Gegevens naar chip schrijven';

  @override
  String get writeSuccess => 'Schrijven geslaagd!';

  @override
  String get writeError => 'Schrijffout';

  @override
  String get brand => 'Merk';

  @override
  String get selectBrand => 'Selecteer merk';

  @override
  String get materialType => 'Materiaaltype';

  @override
  String get selectMaterial => 'Selecteer materiaal';

  @override
  String get serialNumber => 'Serienummer';

  @override
  String get serialNumberHint => 'bijv.: 001';

  @override
  String get initialWeight => 'Begingewicht';

  @override
  String get initialWeightHint => 'bijv.: 1000';

  @override
  String get extruderTempMin => 'Extruder Temp. Min';

  @override
  String get extruderTempMax => 'Extruder Temp. Max';

  @override
  String get bedTempMin => 'Bed Temp. Min';

  @override
  String get bedTempMax => 'Bed Temp. Max';

  @override
  String get diameter => 'Diameter';

  @override
  String get spoolLength => 'Lengte (m)';

  @override
  String get generatedSku => 'Gegenereerde SKU';

  @override
  String get approachChipToWrite => 'Benader chip om te schrijven...';

  @override
  String get writing => 'Aan het schrijven...';

  @override
  String get chooseColor => 'Kies kleur';

  @override
  String get required => 'Verplicht';

  @override
  String get invalid => 'Ongeldig';

  @override
  String get advancedSettings => 'Geavanceerde instellingen';

  @override
  String get opacity => 'Dekking';

  @override
  String get validate => 'Valideren';

  @override
  String get nfcTagInfo =>
      'Gebruik een blanco ISO14443A NFC-tag (NTAG213) om uw eigen Anycubic-tags te maken.';

  @override
  String get stockInventory => 'Spoelen op voorraad';

  @override
  String get addSpool => 'Spoel toevoegen';

  @override
  String get scanSpool => 'Spoel scannen';

  @override
  String get addManually => 'Handmatig toevoegen';

  @override
  String get spoolAdded => 'Spoel toegevoegd';

  @override
  String get spoolUpdated => 'Spoel bijgewerkt';

  @override
  String get noSpoolsInStock => 'Geen spoelen op voorraad';

  @override
  String get addFirstSpool =>
      'Voeg uw eerste spoel toe om uw inventaris bij te houden';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count spoel/spoelen met lage voorraad (< $threshold%)';
  }

  @override
  String get edit => 'Bewerken';

  @override
  String get bobbinPrice => 'Spoelprijs';

  @override
  String get price => 'Prijs';

  @override
  String get priceHint => 'bijv.: 25.00';

  @override
  String get save => 'Opslaan';

  @override
  String get spoolDetails => 'Spoeldetails';

  @override
  String get deleteThisSpool => 'Deze spoel verwijderen?';

  @override
  String get cannotBeUndone => 'Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get addSpoolManually => 'Spoel handmatig toevoegen';

  @override
  String get editSpool => 'Spoel bewerken';

  @override
  String get customBrand => 'Aangepast merk';

  @override
  String get customBrandHint => 'bijv.: Mijn merk';

  @override
  String get chooseFromList => 'Kies uit lijst';

  @override
  String get addBrand => '+ Merk toevoegen';

  @override
  String get customMaterial => 'Aangepast materiaal';

  @override
  String get customMaterialHint => 'bijv.: Mijn materiaal';

  @override
  String get addMaterial => '+ Materiaal toevoegen';

  @override
  String get colorHint => 'bijv.: Blauw, Rood...';

  @override
  String get enterColor => 'Voer een kleur in';

  @override
  String get initialWeightG => 'Begingewicht';

  @override
  String get remainingWeightG => 'Resterend gewicht';

  @override
  String get enterBrand => 'Voer een merk in';

  @override
  String get selectOrEnterBrand => 'Selecteer of voer een merk in';

  @override
  String get quantity => 'Quantité';

  @override
  String get quantityHelper =>
      'Ajouter plusieurs bobines identiques d\'un coup';

  @override
  String get quantityInvalid => 'Entrez un nombre entre 1 et 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count en stock';
  }

  @override
  String get enterMaterial => 'Voer een materiaal in';

  @override
  String get selectOrEnterMaterial => 'Selecteer of voer een materiaal in';

  @override
  String get enterPrice => 'Voer een prijs in';

  @override
  String get enterValidPrice => 'Voer een geldige prijs in';

  @override
  String get enterWeight => 'Voer een gewicht in';

  @override
  String get enterValidWeight => 'Voer een geldig gewicht in';

  @override
  String get remainingCannotExceedTotal =>
      'Resterend gewicht kan totaalgewicht niet overschrijden';

  @override
  String get overview => 'Overzicht';

  @override
  String get spoolsInStock => 'Spoelen op voorraad';

  @override
  String get totalValue => 'Totale waarde';

  @override
  String get lowStockSpools => 'Lage voorraad';

  @override
  String get materialDistribution => 'Verdeling per materiaal';

  @override
  String get brandDistribution => 'Verdeling per merk';

  @override
  String get noData => 'Geen gegevens';

  @override
  String get refresh => 'Vernieuwen';

  @override
  String get profileSettings => 'Profielinstellingen';

  @override
  String get preferences => 'Voorkeuren';

  @override
  String get language => 'Taal';

  @override
  String get selectLanguage => 'Selecteer taal';

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
  String get selectCurrency => 'Selecteer valuta';

  @override
  String get units => 'Eenheden';

  @override
  String get selectUnits => 'Selecteer eenheden';

  @override
  String get metric => 'Metrisch (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Drempel voor lage voorraad';

  @override
  String get lowStockThresholdDesc =>
      'Een spoel wordt als laag op voorraad beschouwd als het resterende gewicht minder is dan dit percentage';

  @override
  String get authentication => 'Authenticatie';

  @override
  String get signInWithGoogle => 'Aanmelden met Google';

  @override
  String get signInWithApple => 'Aanmelden met Apple';

  @override
  String get continueWithApple => 'Doorgaan met Apple';

  @override
  String get continueWithGoogle => 'Doorgaan met Google';

  @override
  String get comingSoon => 'Binnenkort beschikbaar';

  @override
  String get about => 'Over';

  @override
  String get version => 'Versie';

  @override
  String get madeWith => 'Gemaakt met ❤️ voor Anycubic 3D-printers';

  @override
  String get scanBobbinDirectly => 'Spoel scannen';

  @override
  String get nfcEncoder => 'NFC-encoder';

  @override
  String get length => 'Lengte';

  @override
  String get tempExtruder => 'Extruder temp.';

  @override
  String get tempBed => 'Bed temp.';

  @override
  String get termsOfService => 'Servicevoorwaarden';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get legal => 'Juridisch';

  @override
  String get back => 'Terug';

  @override
  String get retry => 'Opnieuw proberen';

  @override
  String get signOut => 'Uitloggen';

  @override
  String get extruderTempMinHint => 'bijv.: 200';

  @override
  String get extruderTempMaxHint => 'bijv.: 220';

  @override
  String get bedTempMinHint => 'bijv.: 50';

  @override
  String get bedTempMaxHint => 'bijv.: 60';

  @override
  String get diameterHint => 'bijv.: 1.75';

  @override
  String get spoolLengthHint => 'bijv.: 330';

  @override
  String get tabGrid => 'Raster';

  @override
  String get tabSpectrum => 'Spectrum';

  @override
  String get tabSliders => 'Schuifregelaars';

  @override
  String get hexCode => 'Hexadecimale code';

  @override
  String get red => 'Rood';

  @override
  String get green => 'Groen';

  @override
  String get blue => 'Blauw';

  @override
  String get black => 'Zwart';

  @override
  String get white => 'Wit';

  @override
  String get yellow => 'Geel';

  @override
  String get orange => 'Oranje';

  @override
  String get pink => 'Roze';

  @override
  String get purple => 'Paars';

  @override
  String get gray => 'Grijs';

  @override
  String get brown => 'Bruin';

  @override
  String get unknown => 'Onbekend';

  @override
  String get metricUnits => 'Metrisch (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Zwitserse frank (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Amerikaanse dollar (\$)';

  @override
  String get gbp => 'Pond sterling (£)';

  @override
  String get cad => 'Canadese dollar (CAD)';

  @override
  String get aud => 'Australische dollar (A\$)';

  @override
  String get jpy => 'Japanse yen (¥)';

  @override
  String get cny => 'Chinese yuan (¥)';

  @override
  String get inr => 'Indiase roepie (₹)';

  @override
  String get brl => 'Braziliaanse real (R\$)';

  @override
  String get mxn => 'Mexicaanse peso (MX\$)';

  @override
  String get sek => 'Zweedse kroon (kr)';

  @override
  String get nok => 'Noorse kroon (kr)';

  @override
  String get dkk => 'Deense kroon (kr)';

  @override
  String get pln => 'Poolse zloty (zł)';

  @override
  String get czk => 'Tsjechische kroon (Kč)';

  @override
  String get nzd => 'Nieuw-Zeelandse dollar (NZ\$)';

  @override
  String get filamentsToOrder => 'Filamenten om te bestellen';

  @override
  String get shoppingList => 'Boodschappenlijst';

  @override
  String get addToShoppingList => 'Toevoegen aan lijst';

  @override
  String get noLowStockFilaments => 'Geen filamenten met lage voorraad';

  @override
  String get vipSubscriptionDescription =>
      'Dit abonnement dient alleen om advertenties in de app uit te schakelen en het project te ondersteunen. Geen andere functionaliteit.';

  @override
  String get monthlySubscription => 'Maandelijks Abonnement';

  @override
  String get yearlySubscription => 'Jaarlijks Abonnement';

  @override
  String get perMonth => '/ maand';

  @override
  String get perYear => '/ jaar';

  @override
  String onlyPerMonth(String price) {
    return 'Slechts $price / maand';
  }

  @override
  String get subscribe => 'Abonneren';

  @override
  String get bestOffer => '✨ BESTE AANBIEDING ✨';

  @override
  String get forAnycubicAce => 'voor Anycubic Ace';

  @override
  String get forBambuLabAms => 'voor Bambu Lab AMS';

  @override
  String get scanNfcChip => 'NFC-chip scannen';

  @override
  String get fillForm => 'Formulier invullen';

  @override
  String get emptyShoppingList => 'Geen filamenten in de lijst';

  @override
  String percentRemaining(String percent) {
    return '$percent% resterend';
  }

  @override
  String get markAsOrdered => 'Markeren als besteld';

  @override
  String get markAsNotOrdered => 'Markeren als niet besteld';

  @override
  String get notSignedIn => 'Niet aangemeld';

  @override
  String get signIn => 'Aanmelden';

  @override
  String get connection => 'Aanmelden';

  @override
  String get signInToSync => 'Meld u aan om uw gegevens te synchroniseren';

  @override
  String get continueWithoutAccount => 'Doorgaan zonder account (lokale modus)';

  @override
  String get privacyNotice =>
      'Door in te loggen, accepteert u onze\nGebruiksvoorwaarden en Privacybeleid';

  @override
  String get updateStock => 'Voorraad bijwerken';

  @override
  String get scanToUpdateStock => 'Scannen om bij te werken';

  @override
  String get weightUsed => 'Gebruikt gewicht';

  @override
  String get lengthUsed => 'Gebruikte lengte';

  @override
  String get enterWeightOrLength => 'Voer gebruikt gewicht of lengte in';

  @override
  String get weightUsedG => 'Gebruikt gewicht (g)';

  @override
  String get lengthUsedM => 'Gebruikte lengte (m)';

  @override
  String get stockUpdated => 'Voorraad bijgewerkt';

  @override
  String get scanSpoolToUpdate => 'Scan een spoel om de voorraad bij te werken';

  @override
  String get spoolNotFound => 'Spoel niet gevonden in voorraad';

  @override
  String get addSpoolFirstMessage =>
      'Deze spoel is nog niet in je voorraad. Voeg deze eerst toe met de knop \'Spoel toevoegen\' voordat je de voorraad bijwerkt.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Alleen-lezen';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab tags gebruiken RSA-codering en kunnen niet worden gewijzigd. Alleen-lezen.';

  @override
  String get forPrusaMk4 => 'voor Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Lezen & Schrijven';

  @override
  String get prusaReadWriteDesc =>
      'Prusa tags gebruiken ISO 15693 (NFC-V) met OpenPrintTag formaat. Lezen en schrijven ondersteund.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab kloonbibliotheek';

  @override
  String get noBambuClones => 'Geen Bambu Lab klonen';

  @override
  String get scanBambuToClone =>
      'Scan originele Bambu Lab tags om je kloonbibliotheek te maken';

  @override
  String get scanTag => 'Scan een tag';

  @override
  String get syncWithCloud => 'Synchroniseer met cloud';

  @override
  String get syncCompleted => 'Synchronisatie voltooid';

  @override
  String get deleteClone => 'Kloon verwijderen';

  @override
  String get renameClone => 'Kloon hernoemen';

  @override
  String get rename => 'Hernoemen';

  @override
  String get customName => 'Aangepaste naam';

  @override
  String get clonedOn => 'Gekloond op';

  @override
  String get writeThisClone => 'Deze kloon schrijven';

  @override
  String get writeClone => 'Kloon schrijven';

  @override
  String get writeOnCUID => 'Schrijven naar CUID-kaart';

  @override
  String get cloneWrittenSuccess => 'Kloon succesvol geschreven!';

  @override
  String get requiredTagFormat => 'Vereist tag-formaat';

  @override
  String get type => 'Type';

  @override
  String get frequency => 'Frequentie';

  @override
  String get protocol => 'Protocol';

  @override
  String get capacity => 'Capaciteit';

  @override
  String get feature => 'Functie';

  @override
  String get uidModifiable => 'Blok 0 (UID) aanpasbaar';

  @override
  String get whereToBuy =>
      'Zoek naar \"CUID MiFare Classic 1K\" op AliExpress, Amazon of eBay (~\$0.50/stuk)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 kaart - MiFare Classic 1K met beschrijfbaar Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Zoek naar \"Magic Gen2 MiFare Classic 1K\" of \"UID writable\" op AliExpress, Amazon of eBay (~\$0.50/stuk)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Waarschuwing: Schrijven met iPhone NFC werkt mogelijk niet op alle Magic Gen2 kaarten. Een Proxmark3 apparaat wordt aanbevolen voor maximale betrouwbaarheid.';

  @override
  String get step1GetMagicGen2 =>
      'Verkrijg een lege Magic Gen2 kaart (MiFare Classic 1K met beschrijfbare UID)';

  @override
  String get instructions => 'Instructies';

  @override
  String get step1GetCUID => 'Koop een lege CUID-kaart (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Druk op de knop \"Schrijven\" hieronder';

  @override
  String get step3HoldPhone => 'Houd je telefoon bij de CUID-kaart';

  @override
  String get step4WaitConfirm => 'Wacht op schrijfbevestiging';

  @override
  String get step5TestClone => 'Test de gekloonde tag op je Bambu Lab printer!';

  @override
  String get rsaIncluded =>
      'De kloon bevat de originele RSA-handtekening, deze wordt geaccepteerd door de printer!';

  @override
  String get cloneDeleted => 'Kloon verwijderd';

  @override
  String get deleteAccount => 'Mijn account verwijderen';

  @override
  String get deleteAccountConfirmation =>
      'Deze actie is onomkeerbaar. Je account en alle gegevens worden binnen 30 dagen verwijderd.';

  @override
  String get accountDeletionRequested => 'Verwijderingsverzoek geregistreerd';

  @override
  String get clearShoppingList => 'Lijst wissen';

  @override
  String get clearShoppingListConfirmation =>
      'Weet je zeker dat je de hele boodschappenlijst wilt wissen? Deze actie kan niet ongedaan worden gemaakt.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Geschiedenis';

  @override
  String get retryButton => 'Opnieuw proberen';

  @override
  String get readSuccessMessage => 'Succesvol gelezen!';

  @override
  String get filamentTypeLabel => 'Filamenttype';

  @override
  String get scanNfcChipButton => 'NFC-chip scannen';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Kloon \"$name\" verwijderen?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Kloon \"$name\" verwijderd';
  }

  @override
  String get extruderLabel => 'Extruder';

  @override
  String get writeThisCloneButton => 'Deze kloon schrijven';

  @override
  String get customNameHint => 'Aangepaste naam';

  @override
  String get cloneWriteSuccessMessage => 'Kloon succesvol geschreven!';

  @override
  String errorPrefix(String error) {
    return 'Fout: $error';
  }

  @override
  String get writingInProgress => 'Schrijven...';

  @override
  String get writeOnCUIDButton => 'Schrijven op CUID-kaart';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get extruderTempLabel => 'Extrudertemperatuur';

  @override
  String get bedTempLabel => 'Bedtemperatuur';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bytes (1024 bytes)';

  @override
  String get rsaSignatureNote =>
      'De kloon bevat de originele RSA-handtekening, deze wordt geaccepteerd door de printer!';

  @override
  String get writeBambuLabTagTitle => 'Bambu Lab tag schrijven';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab tag succesvol geschreven!';

  @override
  String get approachNfcTagMessage => 'Houd NFC-tag dichtbij...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab formaat (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab formaat';

  @override
  String get bambuLabFormatInfo =>
      'Dit formaat gebruikt Bambu Lab materiaalcodes en slaat gegevens op in een AMS-compatibel formaat.';

  @override
  String get brandLabel => 'Merk';

  @override
  String get materialTypeLabel => 'Materiaaltype';

  @override
  String get serialNumber3Digits => 'Serienummer (3 cijfers)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (standaard)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Bambu Lab tag schrijven';

  @override
  String get bambuLabRsaNote =>
      'Let op: Originele Bambu Lab tags gebruiken RSA-encryptie. Deze modus schrijft gegevens in een vereenvoudigd compatibel formaat.';

  @override
  String signInError(String error) {
    return 'Aanmeldfout: $error';
  }

  @override
  String get subscriptionActivatedMessage =>
      'Abonnement succesvol geactiveerd!';

  @override
  String get subscriptionFailedMessage => 'Abonnement mislukt';

  @override
  String errorMessage(String error) {
    return 'Fout: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Abonnement succesvol hersteld!';

  @override
  String get noSubscriptionFoundMessage => 'Geen abonnement gevonden';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ACTIEF';

  @override
  String get noAdsExperienceMessage =>
      'Je geniet van de advertentievrije ervaring!';

  @override
  String get subscribedLabel => 'Geabonneerd';

  @override
  String get restorePurchasesButton => 'Aankopen herstellen';

  @override
  String get cannotExceedRemainingWeight =>
      'Kan het resterende gewicht niet overschrijden';

  @override
  String get pleaseEnterLength => 'Voer de lengte in';

  @override
  String get pleaseEnterValidLength => 'Voer een geldige lengte in';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Spoellengte niet ingesteld - kan niet converteren';

  @override
  String get exceedsRemainingWeight => 'Overschrijdt resterend gewicht';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Help ons dit filament te identificeren';

  @override
  String get helpUsImprove => 'Help ons verbeteren!';

  @override
  String get helpIdentifyDescription =>
      'We hebben de chip gelezen maar konden het niet identificeren. Vertel ons welk filament dit is zodat we de app kunnen verbeteren.';

  @override
  String get otherBrand => 'Ander';

  @override
  String get thankYouFeedback => 'Bedankt voor je feedback!';

  @override
  String get send => 'Verzenden';

  @override
  String get optionalDetails => 'Optionele details';

  @override
  String get weightGrams => 'Gewicht (g)';

  @override
  String get diameterMm => 'Diameter (mm)';

  @override
  String get spoolLengthM => 'Spoel lengte (m)';

  @override
  String get batchNumberLabel => 'Batch / SKU';

  @override
  String get contactUs => 'Neem contact op';

  @override
  String get contactUsSubtitle => 'Vragen, suggesties of problemen';

  @override
  String get nfcTagNotDetected => 'Geen NFC-tag gedetecteerd';

  @override
  String get nfcTagNotDetectedDesc =>
      'Geen tag gevonden. De tag kan kapot, beschadigd of te ver van de telefoon verwijderd zijn.';

  @override
  String get nfcTagIncompatible => 'Oncompatibele NFC-tag gedetecteerd';

  @override
  String get nfcAuthError => 'NFC-tag authenticatie mislukt';

  @override
  String get nfcAuthErrorDesc =>
      'De tag werd gedetecteerd maar de authenticatie is mislukt na meerdere pogingen. Houd de tag stevig tegen de achterkant van uw telefoon gedrukt en probeer het opnieuw.';

  @override
  String get nfcTagInfoPrusa =>
      'Gebruik een lege NXP ICODE SLIX2-tag (ISO 15693) om OpenPrintTag-compatibele tags voor Prusa MK4/XL te maken.';

  @override
  String get writePrusaTagTitle => 'Prusa OpenPrintTag schrijven';

  @override
  String get signInAppleNotAvailable =>
      'Inloggen met Apple is niet beschikbaar op dit apparaat.';

  @override
  String get signInAppleFailed =>
      'Inloggen met Apple mislukt. Probeer het opnieuw.';

  @override
  String get signInFailed => 'Inloggen mislukt. Probeer het opnieuw.';

  @override
  String get mustContain3Digits => 'Moet 3 cijfers bevatten';

  @override
  String get mustBeNumber => 'Moet een getal zijn';

  @override
  String generatedUidLabel(String uid) {
    return 'Gegenereerde UID: $uid';
  }

  @override
  String get experimentalBadge => 'EXPERIMENTEEL';

  @override
  String get newBadge => 'NIEUW';

  @override
  String get forCrealityCfs => 'voor Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Lezen & schrijven';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS-tags gebruiken MiFare Classic 1K met AES-128-ECB-encryptie. Lezen en schrijven alleen ondersteund op Android.';

  @override
  String get platformLimitationTitle => 'Platformbeperking';

  @override
  String get mifareClassicNotSupportedIos =>
      'MiFare Classic-tags (Bambu Lab, Creality) worden niet ondersteund op iOS vanwege een Apple CoreNFC-beperking. Deze functie is alleen beschikbaar op Android.';

  @override
  String get nfcTagInfoCreality =>
      'Gebruik een MiFare Classic 1K-tag om Creality CFS-compatibele gegevens te schrijven voor de Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Rood, Blauw, Zwart...';

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
    return 'Tag gedetecteerd als $mode — wissel van tabblad voor volgende scans';
  }

  @override
  String get fallbackChooseMode => 'Modus handmatig kiezen';

  @override
  String get fallbackChooseModeSubtitle =>
      'Automatische detectie kon deze tag niet identificeren. Selecteer het protocol:';

  @override
  String get tryAutoDetect => 'Automatische detectie proberen';

  @override
  String get autoDetectAllBrands => 'Automatische detectie — alle merken';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D en meer';

  @override
  String get nfcTipIos =>
      'De NFC-lezer zit bovenaan je iPhone. Plaats hem direct op de NFC-tag van de spoel.';

  @override
  String get nfcTipAndroid =>
      'De NFC-lezer zit meestal in het midden van de achterkant van je telefoon. Plaats de achterkant van je telefoon op de NFC-tag van de spoel.';
}
