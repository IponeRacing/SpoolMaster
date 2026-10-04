// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Stoc';

  @override
  String get statistics => 'Statistici';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Citește Chip NFC';

  @override
  String get scanHistory => 'Istoric';

  @override
  String get writeNfcChip => 'Scrie Chip NFC';

  @override
  String get nfcNotAvailable => 'NFC indisponibil';

  @override
  String get nfcNotAvailableDesc =>
      'Dispozitivul tău nu suportă NFC sau este dezactivat.';

  @override
  String get nfcNotSupported => 'NFC nu este suportat pe acest dispozitiv';

  @override
  String get approachNfcChip => 'Apropie un chip NFC...';

  @override
  String get scanningNfc => 'Scanare...';

  @override
  String get nfcDataRead => 'Datele NFC au fost citite cu succes!';

  @override
  String get errorReadingNfc => 'Eroare la citirea NFC';

  @override
  String get scanHistoryTitle => 'Istoric Scanări';

  @override
  String get noScansRecorded => 'Nicio scanare înregistrată';

  @override
  String get scansWillAppearHere => 'Scanările NFC vor apărea aici automat';

  @override
  String get clearAll => 'Șterge tot';

  @override
  String get deleteThisScan => 'Ștergi această scanare?';

  @override
  String get actionIrreversible => 'Această acțiune este ireversibilă.';

  @override
  String get cancel => 'Anulează';

  @override
  String get delete => 'Șterge';

  @override
  String get clearAllHistory => 'Ștergi tot istoricul?';

  @override
  String get allScansWillBeDeleted =>
      'Toate scanările vor fi șterse. Această acțiune este ireversibilă.';

  @override
  String get scanDeleted => 'Scanare ștearsă';

  @override
  String get scanDetails => 'Detalii Scanare';

  @override
  String scannedOn(Object date) {
    return 'Scanat pe $date';
  }

  @override
  String get bobbinInformation => 'Informații Bobină';

  @override
  String get filamentType => 'Tip Filament';

  @override
  String get color => 'Culoare';

  @override
  String get weight => 'Greutate';

  @override
  String get manufacturingDate => 'Data Fabricației';

  @override
  String get batchNumber => 'Număr Lot';

  @override
  String get printerSettings => 'Setări imprimantă';

  @override
  String get scanMetadata => 'Metadate Scanare';

  @override
  String get scanId => 'ID Scanare';

  @override
  String get dateAndTime => 'Data și Ora';

  @override
  String get reuseThisData => 'Refolosește aceste date';

  @override
  String get writeToNfc => 'Scrie în NFC';

  @override
  String get writeDataToChip => 'Scrie date pe chip';

  @override
  String get writeSuccess => 'Scriere reușită!';

  @override
  String get writeError => 'Eroare la scriere';

  @override
  String get brand => 'Marcă';

  @override
  String get selectBrand => 'Selectează marca';

  @override
  String get materialType => 'Tip Material';

  @override
  String get selectMaterial => 'Selectează materialul';

  @override
  String get serialNumber => 'Număr Serie';

  @override
  String get serialNumberHint => 'ex.: 001';

  @override
  String get initialWeight => 'Greutate Inițială';

  @override
  String get initialWeightHint => 'ex.: 1000';

  @override
  String get extruderTempMin => 'Temp. Extruder Min';

  @override
  String get extruderTempMax => 'Temp. Extruder Max';

  @override
  String get bedTempMin => 'Temp. Pat Min';

  @override
  String get bedTempMax => 'Temp. Pat Max';

  @override
  String get diameter => 'Diametru';

  @override
  String get spoolLength => 'Lungime (m)';

  @override
  String get generatedSku => 'SKU Generat';

  @override
  String get approachChipToWrite => 'Apropie chip-ul pentru scriere...';

  @override
  String get writing => 'Se scrie...';

  @override
  String get chooseColor => 'Alege culoarea';

  @override
  String get required => 'Obligatoriu';

  @override
  String get invalid => 'Invalid';

  @override
  String get advancedSettings => 'Setări Avansate';

  @override
  String get opacity => 'Opacitate';

  @override
  String get validate => 'Validează';

  @override
  String get nfcTagInfo =>
      'Folosește o etichetă NFC ISO14443A goală (NTAG213) pentru a crea propriile etichete Anycubic.';

  @override
  String get stockInventory => 'Bobine în stoc';

  @override
  String get addSpool => 'Adaugă Bobină';

  @override
  String get scanSpool => 'Scanează Bobină';

  @override
  String get addManually => 'Adaugă Manual';

  @override
  String get spoolAdded => 'Bobină adăugată';

  @override
  String get spoolUpdated => 'Bobină actualizată';

  @override
  String get noSpoolsInStock => 'Nicio bobină în stoc';

  @override
  String get addFirstSpool =>
      'Adaugă prima bobină pentru a începe urmărirea inventarului';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count bobină/bobine cu stoc redus (< $threshold%)';
  }

  @override
  String get edit => 'Editează';

  @override
  String get bobbinPrice => 'Preț Bobină';

  @override
  String get price => 'Preț';

  @override
  String get priceHint => 'ex.: 25.00';

  @override
  String get save => 'Salvează';

  @override
  String get spoolDetails => 'Detalii Bobină';

  @override
  String get deleteThisSpool => 'Ștergi această bobină?';

  @override
  String get cannotBeUndone => 'Această acțiune nu poate fi anulată.';

  @override
  String get addSpoolManually => 'Adaugă Bobină Manual';

  @override
  String get editSpool => 'Editează Bobină';

  @override
  String get customBrand => 'Marcă Personalizată';

  @override
  String get customBrandHint => 'ex.: Marca Mea';

  @override
  String get chooseFromList => 'Alege din listă';

  @override
  String get addBrand => '+ Adaugă Marcă';

  @override
  String get customMaterial => 'Material Personalizat';

  @override
  String get customMaterialHint => 'ex.: Materialul Meu';

  @override
  String get addMaterial => '+ Adaugă Material';

  @override
  String get colorHint => 'ex.: Albastru, Roșu...';

  @override
  String get enterColor => 'Te rog introdu o culoare';

  @override
  String get initialWeightG => 'Greutate Inițială';

  @override
  String get remainingWeightG => 'Greutate Rămasă';

  @override
  String get enterBrand => 'Te rog introdu o marcă';

  @override
  String get selectOrEnterBrand => 'Te rog selectează sau introdu o marcă';

  @override
  String get quantity => 'Cantitate';

  @override
  String get quantityHelper => 'Adăugați mai multe bobine identice deodată';

  @override
  String get quantityInvalid => 'Introduceți un număr între 1 și 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count în stoc';
  }

  @override
  String get enterMaterial => 'Te rog introdu un material';

  @override
  String get selectOrEnterMaterial =>
      'Te rog selectează sau introdu un material';

  @override
  String get enterPrice => 'Te rog introdu un preț';

  @override
  String get enterValidPrice => 'Te rog introdu un preț valid';

  @override
  String get enterWeight => 'Te rog introdu o greutate';

  @override
  String get enterValidWeight => 'Te rog introdu o greutate validă';

  @override
  String get remainingCannotExceedTotal =>
      'Greutatea rămasă nu poate depăși greutatea totală';

  @override
  String get overview => 'Prezentare Generală';

  @override
  String get spoolsInStock => 'Bobine în Stoc';

  @override
  String get totalValue => 'Valoare Totală';

  @override
  String get lowStockSpools => 'Stoc Redus';

  @override
  String get materialDistribution => 'Distribuție pe Material';

  @override
  String get brandDistribution => 'Distribuție pe Marcă';

  @override
  String get noData => 'Fără date';

  @override
  String get refresh => 'Reîmprospătează';

  @override
  String get profileSettings => 'Setări Profil';

  @override
  String get preferences => 'Preferințe';

  @override
  String get language => 'Limba';

  @override
  String get selectLanguage => 'Selectează limba';

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
  String get currency => 'Monedă';

  @override
  String get selectCurrency => 'Selectează moneda';

  @override
  String get units => 'Unități';

  @override
  String get selectUnits => 'Selectează unitățile';

  @override
  String get metric => 'Metric (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Prag Alertă Stoc Redus';

  @override
  String get lowStockThresholdDesc =>
      'O bobină va fi considerată cu stoc redus dacă greutatea rămasă este mai mică decât acest procent';

  @override
  String get authentication => 'Autentificare';

  @override
  String get signInWithGoogle => 'Autentifică-te cu Google';

  @override
  String get signInWithApple => 'Autentifică-te cu Apple';

  @override
  String get continueWithApple => 'Continuă cu Apple';

  @override
  String get continueWithGoogle => 'Continuă cu Google';

  @override
  String get comingSoon => 'În curând';

  @override
  String get about => 'Despre';

  @override
  String get version => 'Versiune';

  @override
  String get madeWith => 'Făcut cu ❤️ pentru Imprimante 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Scanează Bobină';

  @override
  String get nfcEncoder => 'Encoder NFC';

  @override
  String get length => 'Lungime';

  @override
  String get tempExtruder => 'Temp. Extruder';

  @override
  String get tempBed => 'Temp. Pat';

  @override
  String get termsOfService => 'Termeni și Condiții';

  @override
  String get privacyPolicy => 'Politica de Confidențialitate';

  @override
  String get legal => 'Juridic';

  @override
  String get back => 'Înapoi';

  @override
  String get retry => 'Reîncearcă';

  @override
  String get signOut => 'Deconectează-te';

  @override
  String get extruderTempMinHint => 'ex.: 200';

  @override
  String get extruderTempMaxHint => 'ex.: 220';

  @override
  String get bedTempMinHint => 'ex.: 50';

  @override
  String get bedTempMaxHint => 'ex.: 60';

  @override
  String get diameterHint => 'ex.: 1.75';

  @override
  String get spoolLengthHint => 'ex.: 330';

  @override
  String get tabGrid => 'Grilă';

  @override
  String get tabSpectrum => 'Spectru';

  @override
  String get tabSliders => 'Glisoare';

  @override
  String get hexCode => 'Cod hexazecimal';

  @override
  String get red => 'Roșu';

  @override
  String get green => 'Verde';

  @override
  String get blue => 'Albastru';

  @override
  String get black => 'Negru';

  @override
  String get white => 'Alb';

  @override
  String get yellow => 'Galben';

  @override
  String get orange => 'Portocaliu';

  @override
  String get pink => 'Roz';

  @override
  String get purple => 'Violet';

  @override
  String get gray => 'Gri';

  @override
  String get brown => 'Maro';

  @override
  String get unknown => 'Necunoscut';

  @override
  String get metricUnits => 'Metric (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Franc elvețian (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Dolar american (\$)';

  @override
  String get gbp => 'Liră sterlină (£)';

  @override
  String get cad => 'Dolar canadian (CAD)';

  @override
  String get aud => 'Dolar australian (A\$)';

  @override
  String get jpy => 'Yen japonez (¥)';

  @override
  String get cny => 'Yuan chinezesc (¥)';

  @override
  String get inr => 'Rupie indiană (₹)';

  @override
  String get brl => 'Real brazilian (R\$)';

  @override
  String get mxn => 'Peso mexican (MX\$)';

  @override
  String get sek => 'Coroană suedeză (kr)';

  @override
  String get nok => 'Coroană norvegiană (kr)';

  @override
  String get dkk => 'Coroană daneză (kr)';

  @override
  String get pln => 'Zlot polonez (zł)';

  @override
  String get czk => 'Coroană cehă (Kč)';

  @override
  String get nzd => 'Dolar neozeelandez (NZ\$)';

  @override
  String get filamentsToOrder => 'Filamente de comandat';

  @override
  String get shoppingList => 'Listă de cumpărături';

  @override
  String get addToShoppingList => 'Adaugă în listă';

  @override
  String get noLowStockFilaments => 'Niciun filament cu stoc redus';

  @override
  String get vipSubscriptionDescription =>
      'Acest abonament servește doar pentru a dezactiva reclamele din aplicație și a sprijini proiectul. Nicio altă funcționalitate.';

  @override
  String get monthlySubscription => 'Abonament Lunar';

  @override
  String get yearlySubscription => 'Abonament Anual';

  @override
  String get perMonth => '/ lună';

  @override
  String get perYear => '/ an';

  @override
  String onlyPerMonth(String price) {
    return 'Doar $price / lună';
  }

  @override
  String get subscribe => 'Abonează-te';

  @override
  String get bestOffer => '✨ CEA MAI BUNĂ OFERTĂ ✨';

  @override
  String get forAnycubicAce => 'pentru Anycubic Ace';

  @override
  String get forBambuLabAms => 'pentru Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Scanează chip NFC';

  @override
  String get fillForm => 'Completează formular';

  @override
  String get emptyShoppingList => 'Niciun filament în listă';

  @override
  String percentRemaining(String percent) {
    return '$percent% rămas';
  }

  @override
  String get markAsOrdered => 'Marchează ca comandat';

  @override
  String get markAsNotOrdered => 'Marchează ca necomandat';

  @override
  String get notSignedIn => 'Neconectat';

  @override
  String get signIn => 'Conectare';

  @override
  String get connection => 'Conectare';

  @override
  String get signInToSync => 'Conectați-vă pentru a sincroniza datele';

  @override
  String get continueWithoutAccount => 'Continuați fără cont (mod local)';

  @override
  String get privacyNotice =>
      'Conectându-vă, acceptați\nTermenii de utilizare și Politica de confidențialitate';

  @override
  String get updateStock => 'Actualizare stoc';

  @override
  String get scanToUpdateStock => 'Scanează pentru actualizare';

  @override
  String get weightUsed => 'Greutate folosită';

  @override
  String get lengthUsed => 'Lungime folosită';

  @override
  String get enterWeightOrLength =>
      'Introduceți greutatea sau lungimea folosită';

  @override
  String get weightUsedG => 'Greutate folosită (g)';

  @override
  String get lengthUsedM => 'Lungime folosită (m)';

  @override
  String get stockUpdated => 'Stoc actualizat';

  @override
  String get scanSpoolToUpdate => 'Scanează o bobină pentru a actualiza stocul';

  @override
  String get spoolNotFound => 'Bobina nu a fost găsită în stoc';

  @override
  String get addSpoolFirstMessage =>
      'Această bobină nu este încă în stocul dvs. Vă rugăm să o adăugați mai întâi folosind butonul \'Adaugă bobină\' înainte de a actualiza stocul.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Doar citire';

  @override
  String get bambuLabReadOnlyDesc =>
      'Etichetele Bambu Lab folosesc criptare RSA și nu pot fi modificate. Doar citire.';

  @override
  String get forPrusaMk4 => 'pentru Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Citire și scriere';

  @override
  String get prusaReadWriteDesc =>
      'Tag-urile Prusa folosesc ISO 15693 (NFC-V) cu format OpenPrintTag. Citire și scriere sunt suportate.';

  @override
  String get bambuCloneLibrary => 'Biblioteca de clonă Bambu Lab';

  @override
  String get noBambuClones => 'Fără clone Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Scanați etichetele originale Bambu Lab pentru a crea biblioteca dvs. de clone';

  @override
  String get scanTag => 'Scanați o etichetă';

  @override
  String get syncWithCloud => 'Sincronizare cu cloud-ul';

  @override
  String get syncCompleted => 'Sincronizare finalizată';

  @override
  String get deleteClone => 'Șterge clona';

  @override
  String get renameClone => 'Redenumește clona';

  @override
  String get rename => 'Redenumește';

  @override
  String get customName => 'Nume personalizat';

  @override
  String get clonedOn => 'Clonat pe';

  @override
  String get writeThisClone => 'Scrie această clonă';

  @override
  String get writeClone => 'Scrie clona';

  @override
  String get writeOnCUID => 'Scrie pe card CUID';

  @override
  String get cloneWrittenSuccess => 'Clonă scrisă cu succes!';

  @override
  String get requiredTagFormat => 'Format etichetă necesar';

  @override
  String get type => 'Tip';

  @override
  String get frequency => 'Frecvență';

  @override
  String get protocol => 'Protocol';

  @override
  String get capacity => 'Capacitate';

  @override
  String get feature => 'Caracteristică';

  @override
  String get uidModifiable => 'Bloc 0 (UID) modificabil';

  @override
  String get whereToBuy =>
      'Căutați \"CUID MiFare Classic 1K\" pe AliExpress, Amazon sau eBay (~\$0.50/bucată)';

  @override
  String get magicGen2Required =>
      'Card Magic Gen2 - MiFare Classic 1K cu Block 0 (UID) inscriptibil';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Căutați \"Magic Gen2 MiFare Classic 1K\" sau \"UID writable\" pe AliExpress, Amazon sau eBay (~\$0.50/bucată)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Avertisment: Scrierea cu NFC iPhone poate să nu funcționeze pe toate cardurile Magic Gen2. Se recomandă un dispozitiv Proxmark3 pentru fiabilitate maximă.';

  @override
  String get step1GetMagicGen2 =>
      'Obțineți un card Magic Gen2 gol (MiFare Classic 1K cu UID inscriptibil)';

  @override
  String get instructions => 'Instrucțiuni';

  @override
  String get step1GetCUID => 'Procurați un card CUID gol (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Apăsați butonul \"Scrie\" de mai jos';

  @override
  String get step3HoldPhone => 'Țineți telefonul aproape de cardul CUID';

  @override
  String get step4WaitConfirm => 'Așteptați confirmarea scrierii';

  @override
  String get step5TestClone =>
      'Testați eticheta clonată pe imprimanta Bambu Lab!';

  @override
  String get rsaIncluded =>
      'Clona include semnătura RSA originală, va fi acceptată de imprimantă!';

  @override
  String get cloneDeleted => 'Clonă ștearsă';

  @override
  String get deleteAccount => 'Șterge contul meu';

  @override
  String get deleteAccountConfirmation =>
      'Această acțiune este ireversibilă. Contul și toate datele vor fi șterse în 30 de zile.';

  @override
  String get accountDeletionRequested => 'Cerere de ștergere înregistrată';

  @override
  String get clearShoppingList => 'Golește lista';

  @override
  String get clearShoppingListConfirmation =>
      'Sigur doriți să goliți întreaga listă de cumpărături? Această acțiune nu poate fi anulată.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Istoric';

  @override
  String get retryButton => 'Reîncearcă';

  @override
  String get readSuccessMessage => 'Citire reușită!';

  @override
  String get filamentTypeLabel => 'Tip filament';

  @override
  String get scanNfcChipButton => 'Scanează cip NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Șterge clona \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clona \"$name\" ștearsă';
  }

  @override
  String get extruderLabel => 'Extruder';

  @override
  String get writeThisCloneButton => 'Scrie această clonă';

  @override
  String get customNameHint => 'Nume personalizat';

  @override
  String get cloneWriteSuccessMessage => 'Clonă scrisă cu succes!';

  @override
  String errorPrefix(String error) {
    return 'Eroare: $error';
  }

  @override
  String get writingInProgress => 'Se scrie...';

  @override
  String get writeOnCUIDButton => 'Scrie pe card CUID';

  @override
  String get diameterLabel => 'Diametru';

  @override
  String get extruderTempLabel => 'Temperatură extruder';

  @override
  String get bedTempLabel => 'Temperatură pat';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K octeți (1024 octeți)';

  @override
  String get rsaSignatureNote =>
      'Clona include semnătura RSA originală, va fi acceptată de imprimantă!';

  @override
  String get writeBambuLabTagTitle => 'Scrie etichetă Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'Etichetă Bambu Lab scrisă cu succes!';

  @override
  String get approachNfcTagMessage => 'Apropie eticheta NFC...';

  @override
  String get bambuLabFormatMiFare => 'Format Bambu Lab (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Format Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Acest format folosește coduri de materiale Bambu Lab și stochează date în format compatibil AMS.';

  @override
  String get brandLabel => 'Marcă';

  @override
  String get materialTypeLabel => 'Tip material';

  @override
  String get serialNumber3Digits => 'Număr de serie (3 cifre)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (standard)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Scrie etichetă Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Notă: Etichetele Bambu Lab originale folosesc criptare RSA. Acest mod scrie date în format simplificat compatibil.';

  @override
  String signInError(String error) {
    return 'Eroare de conectare: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Abonament activat cu succes!';

  @override
  String get subscriptionFailedMessage => 'Abonament eșuat';

  @override
  String errorMessage(String error) {
    return 'Eroare: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Abonament restaurat cu succes!';

  @override
  String get noSubscriptionFoundMessage => 'Niciun abonament găsit';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ACTIV';

  @override
  String get noAdsExperienceMessage => 'Bucură-te de experiența fără reclame!';

  @override
  String get subscribedLabel => 'Abonat';

  @override
  String get restorePurchasesButton => 'Restaurează achizițiile';

  @override
  String get cannotExceedRemainingWeight => 'Nu poate depăși greutatea rămasă';

  @override
  String get pleaseEnterLength => 'Introduceți lungimea';

  @override
  String get pleaseEnterValidLength => 'Introduceți o lungime validă';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Lungimea bobinei nu este setată - nu se poate converti';

  @override
  String get exceedsRemainingWeight => 'Depășește greutatea rămasă';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Ajutați-ne să identificăm acest filament';

  @override
  String get helpUsImprove => 'Ajutați-ne să ne îmbunătățim!';

  @override
  String get helpIdentifyDescription =>
      'Am citit cipul dar nu am putut să-l identificăm. Spuneți-ne ce filament este pentru a îmbunătăți aplicația.';

  @override
  String get otherBrand => 'Alt brand';

  @override
  String get thankYouFeedback => 'Mulțumim pentru feedback!';

  @override
  String get send => 'Trimite';

  @override
  String get optionalDetails => 'Detalii opționale';

  @override
  String get weightGrams => 'Greutate (g)';

  @override
  String get diameterMm => 'Diametru (mm)';

  @override
  String get spoolLengthM => 'Lungime bobină (m)';

  @override
  String get batchNumberLabel => 'Lot / SKU';

  @override
  String get contactUs => 'Contactați-ne';

  @override
  String get contactUsSubtitle => 'Întrebări, sugestii sau probleme';

  @override
  String get nfcTagNotDetected => 'Niciun tag NFC detectat';

  @override
  String get nfcTagNotDetectedDesc =>
      'Nu a fost găsit niciun tag. Tagul poate fi mort, deteriorat sau prea departe de telefon.';

  @override
  String get nfcTagIncompatible => 'Tag NFC incompatibil detectat';

  @override
  String get nfcAuthError => 'Autentificarea tag-ului NFC a eșuat';

  @override
  String get nfcAuthErrorDesc =>
      'Tag-ul a fost detectat, dar autentificarea a eșuat după mai multe încercări. Țineți tag-ul apăsat ferm pe spatele telefonului și încercați din nou.';

  @override
  String get nfcTagInfoPrusa =>
      'Utilizați o etichetă goală NXP ICODE SLIX2 (ISO 15693) pentru a crea etichete compatibile cu OpenPrintTag pentru Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Scrie OpenPrintTag Prusa';

  @override
  String get signInAppleNotAvailable =>
      'Conectarea cu Apple nu este disponibilă pe acest dispozitiv.';

  @override
  String get signInAppleFailed =>
      'Conectarea cu Apple a eșuat. Vă rugăm să încercați din nou.';

  @override
  String get signInFailed =>
      'Conectarea a eșuat. Vă rugăm să încercați din nou.';

  @override
  String get mustContain3Digits => 'Trebuie să conțină 3 cifre';

  @override
  String get mustBeNumber => 'Trebuie să fie un număr';

  @override
  String generatedUidLabel(String uid) {
    return 'UID generat: $uid';
  }

  @override
  String get experimentalBadge => 'EXPERIMENTAL';

  @override
  String get newBadge => 'NOU';

  @override
  String get forCrealityCfs => 'pentru Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Citire & scriere';

  @override
  String get crealityReadWriteDesc =>
      'Etichetele Creality CFS folosesc MiFare Classic 1K cu criptare AES-128-ECB.';

  @override
  String get platformLimitationTitle => 'Limitare platformă';

  @override
  String get mifareClassicNotSupportedIos =>
      'Etichetele MiFare Classic (Bambu Lab, Creality) nu sunt acceptate pe iOS din cauza unei limitări Apple CoreNFC.';

  @override
  String get nfcTagInfoCreality =>
      'Folosiți o etichetă MiFare Classic 1K pentru a scrie date compatibile Creality CFS pentru Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Roșu, Albastru, Negru...';

  @override
  String get dryingTemp => 'Temperatură de uscare';

  @override
  String get dryingTempHint => 'ex. 55';

  @override
  String get dryingTime => 'Timp de uscare (ore)';

  @override
  String get dryingTimeHint => 'ex. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tag detectat ca $mode — schimbați fila pentru scanările următoare';
  }

  @override
  String get fallbackChooseMode => 'Alegeți modul manual';

  @override
  String get fallbackChooseModeSubtitle =>
      'Detectarea automată nu a putut identifica acest tag. Selectați protocolul:';

  @override
  String get tryAutoDetect => 'Încearcă detectarea automată';

  @override
  String get autoDetectAllBrands => 'Detectare automată — toate mărcile';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D și altele';

  @override
  String get nfcTipIos =>
      'Cititorul NFC se află în partea de sus a iPhone-ului. Plasați-l direct pe eticheta NFC a bobinei.';

  @override
  String get nfcTipAndroid =>
      'Cititorul NFC se află de obicei în centrul părții din spate a telefonului. Plasați spatele telefonului pe eticheta NFC a bobinei.';

  @override
  String get stockSortBy => 'Sortează';

  @override
  String get stockFilter => 'Filtrează';

  @override
  String get stockSortRecent => 'Cele mai recente';

  @override
  String get stockSortBrand => 'Marcă';

  @override
  String get stockSortMaterial => 'Material';

  @override
  String get stockSortRemaining => 'Greutate rămasă';

  @override
  String get stockSortColor => 'Culoare';

  @override
  String get stockFilterAll => 'Toate';

  @override
  String get stockResetFilters => 'Resetează';

  @override
  String get stockNoMatch => 'Nicio bobină nu corespunde filtrelor';

  @override
  String get nfcDisabledTitle => 'NFC dezactivat';

  @override
  String get nfcDisabledMessage =>
      'NFC este dezactivat. Activează-l din setările telefonului pentru a scana bobinele.';

  @override
  String get updateAvailableTitle => 'Actualizare disponibilă';

  @override
  String get updateAvailableMessage =>
      'O nouă versiune de Spool Master este disponibilă.';

  @override
  String get updateForcedMessage =>
      'Această versiune nu mai este acceptată. Actualizează pentru a continua.';

  @override
  String get updateNow => 'Actualizează';

  @override
  String get updateLater => 'Mai târziu';

  @override
  String get nfcScanGuidance =>
      'Ține tag-ul nemișcat lângă partea de sus sau spatele telefonului.';

  @override
  String get tagMovedTitle => 'Tag mișcat';

  @override
  String get tagMovedMessage =>
      'Tag-ul s-a mișcat în timpul citirii. Pune-l la loc și ține telefonul nemișcat.';

  @override
  String get lightBlue => 'Albastru deschis';

  @override
  String get transparent => 'Transparent';

  @override
  String get nfcActiveApproachTag => 'NFC activ — apropiați tagul';

  @override
  String addedToShoppingList(String item) {
    return '$item adăugat în lista de cumpărături';
  }

  @override
  String get deleteAccountFailed =>
      'Ștergerea contului a eșuat. Încercați din nou.';

  @override
  String get scanHistoryError => 'Eroare la accesarea istoricului de scanări';

  @override
  String get genericBrand => 'Generic';

  @override
  String get stockSearchHint => 'Caută (marcă, culoare, locație…)';

  @override
  String get stockMoreActions => 'Mai multe acțiuni';

  @override
  String get exportExcel => 'Exportă în Excel';

  @override
  String get exportFailed => 'Exportul a eșuat';

  @override
  String get exportShareSubject => 'Stocul meu de filament (Spool Master)';

  @override
  String get exportColorHex => 'Cod culoare';

  @override
  String get exportRemainingPercent => 'Rămas (%)';

  @override
  String get exportPricePerKg => 'Preț / kg';

  @override
  String get exportAddedDate => 'Data adăugării';

  @override
  String get exportOrdered => 'Comandat';

  @override
  String get exportDate => 'Data';

  @override
  String get exportGrams => 'Grame';

  @override
  String get exportCost => 'Cost';

  @override
  String get importSpools => 'Importă (CSV / Excel)';

  @override
  String get importConfirmTitle => 'Importă bobine';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return 'Bobine de adăugat: $count\nDeja în stoc (ignorate): $duplicates\nRânduri ilizibile (ignorate): $skipped';
  }

  @override
  String get importAction => 'Importă';

  @override
  String get importNothingFound =>
      'Nicio bobină recunoscută. Fișierul trebuie să conțină cel puțin coloanele Material și Greutate (ca exportul Excel al aplicației).';

  @override
  String importDone(int count) {
    return 'Bobine importate: $count';
  }

  @override
  String get importFailed => 'Fișier ilizibil';

  @override
  String get location => 'Locație';

  @override
  String get locationHint => 'Ex.: Raftul A, cutie uscată 2';

  @override
  String get notes => 'Note';

  @override
  String get notesHint => 'Ex.: de uscat înainte de utilizare';

  @override
  String get printCostTitle => 'Costul unei printări';

  @override
  String get printCostGrams => 'Filament folosit (g)';

  @override
  String printCostResult(String cost) {
    return 'Cost material: $cost';
  }

  @override
  String printCostPerKg(String price) {
    return 'Preț pe kg: $price';
  }

  @override
  String get printCostNoPrice =>
      'Adaugă prețul bobinei pentru a calcula costul.';

  @override
  String get printCostDeduct => 'Scade din stoc';

  @override
  String printCostDeducted(String grams) {
    return '$grams g scăzute din stoc';
  }

  @override
  String get consumptionTitle => 'Consum';

  @override
  String get consumptionLast30Days => 'Ultimele 30 de zile';

  @override
  String get consumptionThisMonth => 'Luna aceasta';

  @override
  String get consumptionByMaterial => 'După material (30 de zile)';

  @override
  String get consumptionMonthly => 'Ultimele 6 luni';

  @override
  String get consumptionEmpty =>
      'Niciun consum înregistrat deocamdată. Apare imediat ce actualizezi greutatea rămasă a unei bobine sau folosești calculatorul de cost.';

  @override
  String get shareShoppingList => 'Distribuie lista';

  @override
  String get nfcBlankTagTitle => 'Tag gol';

  @override
  String get nfcBlankTagDesc =>
      'Acest tag nu conține date despre bobină. Adăugați bobina manual sau scrieți tagul din aplicație.';
}
