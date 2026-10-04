// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Estoc';

  @override
  String get statistics => 'Analítiques';

  @override
  String get profile => 'Perfil';

  @override
  String get readNfcChip => 'Llegir xip NFC';

  @override
  String get scanHistory => 'Historial';

  @override
  String get writeNfcChip => 'Escriure xip NFC';

  @override
  String get nfcNotAvailable => 'NFC no disponible';

  @override
  String get nfcNotAvailableDesc =>
      'El teu dispositiu no és compatible amb NFC o està desactivat.';

  @override
  String get nfcNotSupported => 'NFC no compatible amb aquest dispositiu';

  @override
  String get approachNfcChip => 'Acosta un xip NFC...';

  @override
  String get scanningNfc => 'Escanejant...';

  @override
  String get nfcDataRead => 'Dades NFC llegides correctament!';

  @override
  String get errorReadingNfc => 'Error en llegir NFC';

  @override
  String get scanHistoryTitle => 'Historial d\'escanejos';

  @override
  String get noScansRecorded => 'No hi ha escanejos enregistrats';

  @override
  String get scansWillAppearHere =>
      'Els escanejos NFC apareixeran aquí automàticament';

  @override
  String get clearAll => 'Esborrar tot';

  @override
  String get deleteThisScan => 'Eliminar aquest escaneig?';

  @override
  String get actionIrreversible => 'Aquesta acció és irreversible.';

  @override
  String get cancel => 'Cancel·lar';

  @override
  String get delete => 'Eliminar';

  @override
  String get clearAllHistory => 'Esborrar tot l\'historial?';

  @override
  String get allScansWillBeDeleted =>
      'S\'eliminaran tots els escanejos. Aquesta acció és irreversible.';

  @override
  String get scanDeleted => 'Escaneig eliminat';

  @override
  String get scanDetails => 'Detalls de l\'escaneig';

  @override
  String scannedOn(Object date) {
    return 'Escanejat el $date';
  }

  @override
  String get bobbinInformation => 'Informació de la bobina';

  @override
  String get filamentType => 'Tipus de filament';

  @override
  String get color => 'Color';

  @override
  String get weight => 'Pes';

  @override
  String get manufacturingDate => 'Data de fabricació';

  @override
  String get batchNumber => 'Número de lot';

  @override
  String get printerSettings => 'Configuració de la impressora';

  @override
  String get scanMetadata => 'Metadades de l\'escaneig';

  @override
  String get scanId => 'ID d\'escaneig';

  @override
  String get dateAndTime => 'Data i hora';

  @override
  String get reuseThisData => 'Reutilitzar aquestes dades';

  @override
  String get writeToNfc => 'Escriure a NFC';

  @override
  String get writeDataToChip => 'Escriure dades al xip';

  @override
  String get writeSuccess => 'Escriptura correcta!';

  @override
  String get writeError => 'Error d\'escriptura';

  @override
  String get brand => 'Marca';

  @override
  String get selectBrand => 'Selecciona marca';

  @override
  String get materialType => 'Tipus de material';

  @override
  String get selectMaterial => 'Selecciona material';

  @override
  String get serialNumber => 'Número de sèrie';

  @override
  String get serialNumberHint => 'p. ex.: 001';

  @override
  String get initialWeight => 'Pes inicial';

  @override
  String get initialWeightHint => 'p. ex.: 1000';

  @override
  String get extruderTempMin => 'Temp. extrusora mín.';

  @override
  String get extruderTempMax => 'Temp. extrusora màx.';

  @override
  String get bedTempMin => 'Temp. llit mín.';

  @override
  String get bedTempMax => 'Temp. llit màx.';

  @override
  String get diameter => 'Diàmetre del filament';

  @override
  String get spoolLength => 'Longitud de la bobina';

  @override
  String get generatedSku => 'SKU generat';

  @override
  String get approachChipToWrite => 'Acosta el xip per escriure...';

  @override
  String get writing => 'Escrivint...';

  @override
  String get chooseColor => 'Triar color';

  @override
  String get required => 'Obligatori';

  @override
  String get invalid => 'No vàlid';

  @override
  String get advancedSettings => 'Configuració avançada';

  @override
  String get opacity => 'Opacitat';

  @override
  String get validate => 'Validar';

  @override
  String get nfcTagInfo =>
      'Utilitza una etiqueta NFC ISO14443A buida (NTAG213) per crear les teves pròpies etiquetes Anycubic.';

  @override
  String get stockInventory => 'Bobines en estoc';

  @override
  String get addSpool => 'Afegir bobina';

  @override
  String get scanSpool => 'Escanejar bobina';

  @override
  String get addManually => 'Afegir manualment';

  @override
  String get spoolAdded => 'Bobina afegida';

  @override
  String get spoolUpdated => 'Bobina actualitzada';

  @override
  String get noSpoolsInStock => 'No hi ha bobines en estoc';

  @override
  String get addFirstSpool =>
      'Afegeix la teva primera bobina per començar a fer un seguiment del teu inventari';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count bobina(es) amb estoc baix (< $threshold%)';
  }

  @override
  String get edit => 'Editar';

  @override
  String get bobbinPrice => 'Preu de la bobina';

  @override
  String get price => 'Preu';

  @override
  String get priceHint => 'p. ex.: 25.00';

  @override
  String get save => 'Desar';

  @override
  String get spoolDetails => 'Detalls de la bobina';

  @override
  String get deleteThisSpool => 'Eliminar aquesta bobina?';

  @override
  String get cannotBeUndone => 'Aquesta acció no es pot desfer.';

  @override
  String get addSpoolManually => 'Afegir bobina manualment';

  @override
  String get editSpool => 'Editar bobina';

  @override
  String get customBrand => 'Marca personalitzada';

  @override
  String get customBrandHint => 'p. ex.: La meva marca';

  @override
  String get chooseFromList => 'Triar de la llista';

  @override
  String get addBrand => '+ Afegir marca';

  @override
  String get customMaterial => 'Material personalitzat';

  @override
  String get customMaterialHint => 'p. ex.: El meu material';

  @override
  String get addMaterial => '+ Afegir material';

  @override
  String get colorHint => 'p. ex.: Blau, Vermell...';

  @override
  String get enterColor => 'Si us plau, introdueix un color';

  @override
  String get initialWeightG => 'Pes inicial';

  @override
  String get remainingWeightG => 'Pes restant';

  @override
  String get enterBrand => 'Si us plau, introdueix una marca';

  @override
  String get selectOrEnterBrand =>
      'Si us plau, selecciona o introdueix una marca';

  @override
  String get quantity => 'Quantitat';

  @override
  String get quantityHelper => 'Afegeix diverses bobines idèntiques alhora';

  @override
  String get quantityInvalid => 'Introdueix un número entre 1 i 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count en estoc';
  }

  @override
  String get enterMaterial => 'Si us plau, introdueix un material';

  @override
  String get selectOrEnterMaterial =>
      'Si us plau, selecciona o introdueix un material';

  @override
  String get enterPrice => 'Si us plau, introdueix un preu';

  @override
  String get enterValidPrice => 'Si us plau, introdueix un preu vàlid';

  @override
  String get enterWeight => 'Si us plau, introdueix un pes';

  @override
  String get enterValidWeight => 'Si us plau, introdueix un pes vàlid';

  @override
  String get remainingCannotExceedTotal =>
      'El pes restant no pot superar el pes total';

  @override
  String get overview => 'Resum';

  @override
  String get spoolsInStock => 'Bobines en estoc';

  @override
  String get totalValue => 'Valor total';

  @override
  String get lowStockSpools => 'Estoc baix';

  @override
  String get materialDistribution => 'Distribució per material';

  @override
  String get brandDistribution => 'Distribució per marca';

  @override
  String get noData => 'Sense dades';

  @override
  String get refresh => 'Actualitzar';

  @override
  String get profileSettings => 'Configuració del perfil';

  @override
  String get preferences => 'Preferències';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Selecciona idioma';

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
  String get currency => 'Moneda';

  @override
  String get selectCurrency => 'Selecciona moneda';

  @override
  String get units => 'Unitats';

  @override
  String get selectUnits => 'Selecciona unitats';

  @override
  String get metric => 'Mètric (mm, g, °C)';

  @override
  String get imperial => 'Imperial (polzades, oz, °F)';

  @override
  String get lowStockThreshold => 'Llindar d\'alerta d\'estoc baix';

  @override
  String get lowStockThresholdDesc =>
      'Una bobina es considerarà amb estoc baix si el pes restant és inferior a aquest percentatge';

  @override
  String get authentication => 'Autenticació';

  @override
  String get signInWithGoogle => 'Iniciar sessió amb Google';

  @override
  String get signInWithApple => 'Iniciar sessió amb Apple';

  @override
  String get continueWithApple => 'Continuar amb Apple';

  @override
  String get continueWithGoogle => 'Continuar amb Google';

  @override
  String get comingSoon => 'Properament';

  @override
  String get about => 'Sobre';

  @override
  String get version => 'Versió';

  @override
  String get madeWith => 'Fet amb ❤️ per a impressores 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Escanejar bobina';

  @override
  String get nfcEncoder => 'Codificador NFC';

  @override
  String get length => 'Longitud';

  @override
  String get tempExtruder => 'Temp. extrusora';

  @override
  String get tempBed => 'Temp. llit';

  @override
  String get termsOfService => 'Condicions del servei';

  @override
  String get privacyPolicy => 'Política de privadesa';

  @override
  String get legal => 'Jurídic';

  @override
  String get back => 'Enrere';

  @override
  String get retry => 'Reintentar';

  @override
  String get signOut => 'Tancar sessió';

  @override
  String get extruderTempMinHint => 'Ex: 200';

  @override
  String get extruderTempMaxHint => 'Ex: 220';

  @override
  String get bedTempMinHint => 'Ex: 50';

  @override
  String get bedTempMaxHint => 'Ex: 60';

  @override
  String get diameterHint => 'Ex: 1.75';

  @override
  String get spoolLengthHint => 'Ex: 330';

  @override
  String get tabGrid => 'Graella';

  @override
  String get tabSpectrum => 'Espectre';

  @override
  String get tabSliders => 'Lliscadors';

  @override
  String get hexCode => 'Codi Hex';

  @override
  String get red => 'Vermell';

  @override
  String get green => 'Verd';

  @override
  String get blue => 'Blau';

  @override
  String get black => 'Negre';

  @override
  String get white => 'Blanc';

  @override
  String get yellow => 'Groc';

  @override
  String get orange => 'Taronja';

  @override
  String get pink => 'Rosa';

  @override
  String get purple => 'Lila';

  @override
  String get gray => 'Gris';

  @override
  String get brown => 'Marró';

  @override
  String get unknown => 'Desconegut';

  @override
  String get metricUnits => 'Mètric (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (polzades, oz, °F)';

  @override
  String get chf => 'Franc suís (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Dòlar americà (\$)';

  @override
  String get gbp => 'Lliura esterlina (£)';

  @override
  String get cad => 'Dòlar canadenc (CAD)';

  @override
  String get aud => 'Dòlar australià (A\$)';

  @override
  String get jpy => 'Ien japonès (¥)';

  @override
  String get cny => 'Iuan xinès (¥)';

  @override
  String get inr => 'Rupia índia (₹)';

  @override
  String get brl => 'Real brasiler (R\$)';

  @override
  String get mxn => 'Peso mexicà (MX\$)';

  @override
  String get sek => 'Corona sueca (kr)';

  @override
  String get nok => 'Corona noruega (kr)';

  @override
  String get dkk => 'Corona danesa (kr)';

  @override
  String get pln => 'Zloty polonès (zł)';

  @override
  String get czk => 'Corona txeca (Kč)';

  @override
  String get nzd => 'Dòlar neozelandès (NZ\$)';

  @override
  String get filamentsToOrder => 'Filaments per demanar';

  @override
  String get shoppingList => 'Llista de la compra';

  @override
  String get addToShoppingList => 'Afegir a la llista';

  @override
  String get noLowStockFilaments => 'No hi ha filaments amb estoc baix';

  @override
  String get vipSubscriptionDescription =>
      'Aquesta subscripció només s\'utilitza per desactivar els anuncis de l\'aplicació i donar suport al projecte. No hi ha altres funcions.';

  @override
  String get monthlySubscription => 'Subscripció mensual';

  @override
  String get yearlySubscription => 'Subscripció anual';

  @override
  String get perMonth => '/ mes';

  @override
  String get perYear => '/ any';

  @override
  String onlyPerMonth(String price) {
    return 'Només $price / mes';
  }

  @override
  String get subscribe => 'Subscriure\'s';

  @override
  String get bestOffer => '✨ MILLOR OFERTA ✨';

  @override
  String get forAnycubicAce => 'per Anycubic Ace';

  @override
  String get forBambuLabAms => 'per Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Escanejar un xip NFC';

  @override
  String get fillForm => 'Emplenar el formulari';

  @override
  String get emptyShoppingList => 'No hi ha filaments a la llista';

  @override
  String percentRemaining(String percent) {
    return '$percent% restant';
  }

  @override
  String get markAsOrdered => 'Marcar com a demanat';

  @override
  String get markAsNotOrdered => 'Marcar com a no demanat';

  @override
  String get notSignedIn => 'Sessió no iniciada';

  @override
  String get signIn => 'Iniciar sessió';

  @override
  String get connection => 'Iniciar sessió';

  @override
  String get signInToSync => 'Inicia sessió per sincronitzar les teves dades';

  @override
  String get continueWithoutAccount => 'Continuar sense compte (mode local)';

  @override
  String get privacyNotice =>
      'En iniciar sessió, acceptes les nostres\nCondicions del servei i Política de privadesa';

  @override
  String get updateStock => 'Actualitzar estoc';

  @override
  String get scanToUpdateStock => 'Escanejar per actualitzar';

  @override
  String get weightUsed => 'Pes utilitzat';

  @override
  String get lengthUsed => 'Longitud utilitzada';

  @override
  String get enterWeightOrLength =>
      'Introdueix el pes o la longitud utilitzats';

  @override
  String get weightUsedG => 'Pes utilitzat (g)';

  @override
  String get lengthUsedM => 'Longitud utilitzada (m)';

  @override
  String get stockUpdated => 'Estoc actualitzat';

  @override
  String get scanSpoolToUpdate =>
      'Escaneja una bobina per actualitzar el seu estoc';

  @override
  String get spoolNotFound => 'Bobina no trobada a l\'estoc';

  @override
  String get addSpoolFirstMessage =>
      'Aquesta bobina encara no està al teu estoc. Si us plau, afegeix-la primer utilitzant el botó \'Afegir bobina\' abans d\'actualitzar el seu estoc.';

  @override
  String get ok => 'D\'acord';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Només lectura';

  @override
  String get bambuLabReadOnlyDesc =>
      'Les etiquetes Bambu Lab utilitzen xifratge RSA i no es poden modificar. Només lectura.';

  @override
  String get forPrusaMk4 => 'per a Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Lectura i escriptura';

  @override
  String get prusaReadWriteDesc =>
      'Les etiquetes Prusa utilitzen ISO 15693 (NFC-V) amb format OpenPrintTag. Lectura i escriptura suportades.';

  @override
  String get bambuCloneLibrary => 'Biblioteca de clons Bambu Lab';

  @override
  String get noBambuClones => 'No hi ha clons de Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Escaneja etiquetes originals de Bambu Lab per crear la teva biblioteca de clons';

  @override
  String get scanTag => 'Escanejar una etiqueta';

  @override
  String get syncWithCloud => 'Sincronitzar amb el núvol';

  @override
  String get syncCompleted => 'Sincronització completada';

  @override
  String get deleteClone => 'Eliminar clon';

  @override
  String get renameClone => 'Reanomenar clon';

  @override
  String get rename => 'Reanomenar';

  @override
  String get customName => 'Nom personalitzat';

  @override
  String get clonedOn => 'Clonat el';

  @override
  String get writeThisClone => 'Escriure aquest clon';

  @override
  String get writeClone => 'Escriure clon';

  @override
  String get writeOnCUID => 'Escriure a la targeta CUID';

  @override
  String get cloneWrittenSuccess => 'Clon escrit correctament!';

  @override
  String get requiredTagFormat => 'Format d\'etiqueta requerit';

  @override
  String get type => 'Tipus';

  @override
  String get frequency => 'Freqüència';

  @override
  String get protocol => 'Protocol';

  @override
  String get capacity => 'Capacitat';

  @override
  String get feature => 'Característica';

  @override
  String get uidModifiable => 'Bloc 0 (UID) modificable';

  @override
  String get whereToBuy =>
      'Cerca \"CUID MiFare Classic 1K\" a AliExpress, Amazon o eBay (~\$0.50/unitat)';

  @override
  String get magicGen2Required =>
      'Targeta Magic Gen2 - MiFare Classic 1K amb Block 0 (UID) escrivible';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Cerca \"Magic Gen2 MiFare Classic 1K\" o \"UID writable\" a AliExpress, Amazon o eBay (~\$0.50/unitat)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Avís: L\'escriptura amb NFC d\'iPhone pot no funcionar en totes les targetes Magic Gen2. Es recomana un dispositiu Proxmark3 per a màxima fiabilitat.';

  @override
  String get step1GetMagicGen2 =>
      'Aconsegueix una targeta Magic Gen2 buida (MiFare Classic 1K amb UID escrivible)';

  @override
  String get instructions => 'Instruccions';

  @override
  String get step1GetCUID =>
      'Aconsegueix una targeta CUID buida (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Prem el botó \"Escriure\" a continuació';

  @override
  String get step3HoldPhone => 'Mantén el teu telèfon a prop de la targeta';

  @override
  String get step4WaitConfirm => 'Espera la confirmació d\'escriptura';

  @override
  String get step5TestClone =>
      'Prova l\'etiqueta clonada a la teva impressora Bambu Lab!';

  @override
  String get rsaIncluded =>
      'El clon inclou la signatura RSA original, la impressora l\'acceptarà!';

  @override
  String get cloneDeleted => 'Clon eliminat';

  @override
  String get deleteAccount => 'Eliminar el meu compte';

  @override
  String get deleteAccountConfirmation =>
      'Aquesta acció és irreversible. El teu compte i totes les dades s\'eliminaran en 30 dies.';

  @override
  String get accountDeletionRequested => 'Sol·licitud d\'eliminació registrada';

  @override
  String get clearShoppingList => 'Buidar llista';

  @override
  String get clearShoppingListConfirmation =>
      'Esteu segur que voleu buidar tota la llista de la compra? Aquesta acció no es pot desfer.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Historial';

  @override
  String get retryButton => 'Torna-ho a provar';

  @override
  String get readSuccessMessage => 'Lectura correcta!';

  @override
  String get filamentTypeLabel => 'Tipus de filament';

  @override
  String get scanNfcChipButton => 'Escanejar xip NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Eliminar clon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clon \"$name\" eliminat';
  }

  @override
  String get extruderLabel => 'Extrusor';

  @override
  String get writeThisCloneButton => 'Escriu aquest clon';

  @override
  String get customNameHint => 'Nom personalitzat';

  @override
  String get cloneWriteSuccessMessage => 'Clon escrit correctament!';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get writingInProgress => 'Escrivint...';

  @override
  String get writeOnCUIDButton => 'Escriu a la targeta CUID';

  @override
  String get diameterLabel => 'Diàmetre';

  @override
  String get extruderTempLabel => 'Temperatura extrusor';

  @override
  String get bedTempLabel => 'Temperatura llit';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bytes (1024 bytes)';

  @override
  String get rsaSignatureNote =>
      'El clon inclou la signatura RSA original, serà acceptat per la impressora!';

  @override
  String get writeBambuLabTagTitle => 'Escriu etiqueta Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess =>
      'Etiqueta Bambu Lab escrita correctament!';

  @override
  String get approachNfcTagMessage => 'Apropa l\'etiqueta NFC...';

  @override
  String get bambuLabFormatMiFare => 'Format Bambu Lab (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Format Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Aquest format utilitza codis de materials Bambu Lab i emmagatzema dades en format compatible amb AMS.';

  @override
  String get brandLabel => 'Marca';

  @override
  String get materialTypeLabel => 'Tipus de material';

  @override
  String get serialNumber3Digits => 'Número de sèrie (3 dígits)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (estàndard)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Escriu etiqueta Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Nota: Les etiquetes Bambu Lab originals utilitzen xifrat RSA. Aquest mode escriu dades en format simplificat compatible.';

  @override
  String signInError(String error) {
    return 'Error d\'inici de sessió: $error';
  }

  @override
  String get subscriptionActivatedMessage =>
      'Subscripció activada correctament!';

  @override
  String get subscriptionFailedMessage => 'Ha fallat la subscripció';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      'Subscripció restaurada correctament!';

  @override
  String get noSubscriptionFoundMessage => 'No s\'ha trobat subscripció';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ACTIU';

  @override
  String get noAdsExperienceMessage =>
      'Gaudeix de l\'experiència sense anuncis!';

  @override
  String get subscribedLabel => 'Subscrit';

  @override
  String get restorePurchasesButton => 'Restaurar compres';

  @override
  String get cannotExceedRemainingWeight => 'No pot superar el pes restant';

  @override
  String get pleaseEnterLength => 'Introduïu la longitud';

  @override
  String get pleaseEnterValidLength => 'Introduïu una longitud vàlida';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Longitud de bobina no establerta - no es pot convertir';

  @override
  String get exceedsRemainingWeight => 'Supera el pes restant';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Ajuda\'ns a identificar aquest filament';

  @override
  String get helpUsImprove => 'Ajuda\'ns a millorar!';

  @override
  String get helpIdentifyDescription =>
      'Hem llegit el xip però no l\'hem pogut identificar. Diga\'ns quin filament és per millorar l\'aplicació.';

  @override
  String get otherBrand => 'Altra';

  @override
  String get thankYouFeedback => 'Gràcies pel teu comentari!';

  @override
  String get send => 'Enviar';

  @override
  String get optionalDetails => 'Detalls opcionals';

  @override
  String get weightGrams => 'Pes (g)';

  @override
  String get diameterMm => 'Diàmetre (mm)';

  @override
  String get spoolLengthM => 'Longitud bobina (m)';

  @override
  String get batchNumberLabel => 'Lot / SKU';

  @override
  String get contactUs => 'Contacteu-nos';

  @override
  String get contactUsSubtitle => 'Preguntes, suggeriments o problemes';

  @override
  String get nfcTagNotDetected => 'No s\'ha detectat cap etiqueta NFC';

  @override
  String get nfcTagNotDetectedDesc =>
      'No s\'ha trobat cap etiqueta. L\'etiqueta pot estar morta, danyada o massa lluny del telèfon.';

  @override
  String get nfcTagIncompatible =>
      'S\'ha detectat una etiqueta NFC incompatible';

  @override
  String get nfcAuthError => 'Error d\'autenticació del tag NFC';

  @override
  String get nfcAuthErrorDesc =>
      'El tag s\'ha detectat però l\'autenticació ha fallat després de diversos intents. Mantingueu el tag ben premut contra la part posterior del telèfon i torneu-ho a provar.';

  @override
  String get nfcTagInfoPrusa =>
      'Utilitza una etiqueta NXP ICODE SLIX2 buida (ISO 15693) per crear etiquetes compatibles amb OpenPrintTag per a Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Escriure Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'L\'inici de sessió amb Apple no està disponible en aquest dispositiu.';

  @override
  String get signInAppleFailed =>
      'L\'inici de sessió amb Apple ha fallat. Si us plau, torneu-ho a provar.';

  @override
  String get signInFailed =>
      'L\'inici de sessió ha fallat. Si us plau, torneu-ho a provar.';

  @override
  String get mustContain3Digits => 'Ha de contenir 3 dígits';

  @override
  String get mustBeNumber => 'Ha de ser un número';

  @override
  String generatedUidLabel(String uid) {
    return 'UID generat: $uid';
  }

  @override
  String get experimentalBadge => 'EXPERIMENTAL';

  @override
  String get newBadge => 'NOU';

  @override
  String get forCrealityCfs => 'per a Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Lectura i escriptura';

  @override
  String get crealityReadWriteDesc =>
      'Les etiquetes Creality CFS utilitzen MiFare Classic 1K amb xifratge AES-128-ECB. Lectura i escriptura compatibles només a Android.';

  @override
  String get platformLimitationTitle => 'Limitació de plataforma';

  @override
  String get mifareClassicNotSupportedIos =>
      'Les etiquetes MiFare Classic (Bambu Lab, Creality) no són compatibles amb iOS a causa d\'una limitació d\'Apple CoreNFC. Aquesta funcionalitat només està disponible a Android.';

  @override
  String get nfcTagInfoCreality =>
      'Utilitzeu una etiqueta MiFare Classic 1K per escriure dades compatibles amb Creality CFS per al Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Vermell, Blau, Negre...';

  @override
  String get dryingTemp => 'Temperatura d\'assecatge';

  @override
  String get dryingTempHint => 'p. ex. 55';

  @override
  String get dryingTime => 'Temps d\'assecatge (hores)';

  @override
  String get dryingTimeHint => 'p. ex. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tag detectat com a $mode — canvieu de pestanya per als propers escaneigs';
  }

  @override
  String get fallbackChooseMode => 'Triar mode manualment';

  @override
  String get fallbackChooseModeSubtitle =>
      'La detecció automàtica no ha pogut identificar aquest tag. Seleccioneu el protocol:';

  @override
  String get tryAutoDetect => 'Prova la detecció automàtica';

  @override
  String get autoDetectAllBrands => 'Detecció automàtica — totes les marques';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D i més';

  @override
  String get nfcTipIos =>
      'El lector NFC es troba a la part superior del teu iPhone. Col·loca\'l directament sobre l\'etiqueta NFC de la bobina.';

  @override
  String get nfcTipAndroid =>
      'El lector NFC sol estar al centre de la part posterior del telèfon. Col·loca la part posterior del telèfon sobre l\'etiqueta NFC de la bobina.';

  @override
  String get stockSortBy => 'Ordena';

  @override
  String get stockFilter => 'Filtra';

  @override
  String get stockSortRecent => 'Més recents';

  @override
  String get stockSortBrand => 'Marca';

  @override
  String get stockSortMaterial => 'Material';

  @override
  String get stockSortRemaining => 'Pes restant';

  @override
  String get stockSortColor => 'Color';

  @override
  String get stockFilterAll => 'Tots';

  @override
  String get stockResetFilters => 'Restableix';

  @override
  String get stockNoMatch => 'Cap bobina coincideix amb els filtres';

  @override
  String get nfcDisabledTitle => 'NFC desactivat';

  @override
  String get nfcDisabledMessage =>
      'L\'NFC està desactivat. Activa\'l als ajustos del telèfon per escanejar les bobines.';

  @override
  String get updateAvailableTitle => 'Actualització disponible';

  @override
  String get updateAvailableMessage =>
      'Hi ha una nova versió de Spool Master disponible.';

  @override
  String get updateForcedMessage =>
      'Aquesta versió ja no és compatible. Actualitza per continuar.';

  @override
  String get updateNow => 'Actualitza';

  @override
  String get updateLater => 'Més tard';

  @override
  String get nfcScanGuidance =>
      'Mantén l\'etiqueta immòbil contra la part superior o posterior del telèfon.';

  @override
  String get tagMovedTitle => 'Etiqueta moguda';

  @override
  String get tagMovedMessage =>
      'L\'etiqueta s\'ha mogut durant la lectura. Torna a col·locar-la i mantén el telèfon immòbil.';

  @override
  String get lightBlue => 'Blau clar';

  @override
  String get transparent => 'Transparent';

  @override
  String get nfcActiveApproachTag => 'NFC actiu — apropeu l\'etiqueta';

  @override
  String addedToShoppingList(String item) {
    return '$item afegit a la llista de la compra';
  }

  @override
  String get deleteAccountFailed =>
      'No s\'ha pogut suprimir el compte. Torneu-ho a provar.';

  @override
  String get scanHistoryError => 'Error en accedir a l\'historial d\'escanejos';

  @override
  String get genericBrand => 'Genèric';

  @override
  String get stockSearchHint => 'Cerca (marca, color, ubicació…)';

  @override
  String get stockMoreActions => 'Més accions';

  @override
  String get exportExcel => 'Exporta a Excel';

  @override
  String get exportFailed => 'No s\'ha pogut exportar';

  @override
  String get exportShareSubject => 'El meu estoc de filament (Spool Master)';

  @override
  String get exportColorHex => 'Codi de color';

  @override
  String get exportRemainingPercent => 'Restant (%)';

  @override
  String get exportPricePerKg => 'Preu / kg';

  @override
  String get exportAddedDate => 'Data d\'addició';

  @override
  String get exportOrdered => 'Comanda feta';

  @override
  String get exportDate => 'Data';

  @override
  String get exportGrams => 'Grams';

  @override
  String get exportCost => 'Cost';

  @override
  String get importSpools => 'Importa (CSV / Excel)';

  @override
  String get importConfirmTitle => 'Importa bobines';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return 'Bobines per afegir: $count\nJa en estoc (ignorades): $duplicates\nFiles il·legibles (ignorades): $skipped';
  }

  @override
  String get importAction => 'Importa';

  @override
  String get importNothingFound =>
      'No s\'ha reconegut cap bobina. El fitxer ha de contenir almenys les columnes Material i Pes (com l\'exportació Excel de l\'aplicació).';

  @override
  String importDone(int count) {
    return 'Bobines importades: $count';
  }

  @override
  String get importFailed => 'Fitxer il·legible';

  @override
  String get location => 'Ubicació';

  @override
  String get locationHint => 'Ex.: Prestatge A, caixa seca 2';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Ex.: assecar abans d\'usar';

  @override
  String get printCostTitle => 'Cost d\'una impressió';

  @override
  String get printCostGrams => 'Filament utilitzat (g)';

  @override
  String printCostResult(String cost) {
    return 'Cost del material: $cost';
  }

  @override
  String printCostPerKg(String price) {
    return 'Preu per kg: $price';
  }

  @override
  String get printCostNoPrice =>
      'Afegeix el preu de la bobina per calcular el cost.';

  @override
  String get printCostDeduct => 'Descomptar de l\'estoc';

  @override
  String printCostDeducted(String grams) {
    return '$grams g descomptats de l\'estoc';
  }

  @override
  String get consumptionTitle => 'Consum';

  @override
  String get consumptionLast30Days => 'Últims 30 dies';

  @override
  String get consumptionThisMonth => 'Aquest mes';

  @override
  String get consumptionByMaterial => 'Per material (30 dies)';

  @override
  String get consumptionMonthly => 'Últims 6 mesos';

  @override
  String get consumptionEmpty =>
      'Encara no hi ha cap consum registrat. Apareix tan bon punt actualitzes el pes restant d\'una bobina o uses la calculadora de cost.';

  @override
  String get shareShoppingList => 'Comparteix la llista';

  @override
  String get nfcBlankTagTitle => 'Etiqueta buida';

  @override
  String get nfcBlankTagDesc =>
      'Aquesta etiqueta no conté dades de bobina. Afegiu la bobina manualment o escriviu aquesta etiqueta des de l\'app.';
}
