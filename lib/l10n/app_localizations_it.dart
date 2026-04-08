// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Magazzino';

  @override
  String get statistics => 'Analitiche';

  @override
  String get profile => 'Profilo';

  @override
  String get readNfcChip => 'Leggi chip NFC';

  @override
  String get scanHistory => 'Cronologia';

  @override
  String get writeNfcChip => 'Scrivi chip NFC';

  @override
  String get nfcNotAvailable => 'NFC non disponibile';

  @override
  String get nfcNotAvailableDesc =>
      'Il tuo dispositivo non supporta NFC o è disattivato.';

  @override
  String get nfcNotSupported => 'NFC non supportato su questo dispositivo';

  @override
  String get approachNfcChip => 'Avvicina un chip NFC...';

  @override
  String get scanningNfc => 'Scansione...';

  @override
  String get nfcDataRead => 'Dati NFC letti con successo!';

  @override
  String get errorReadingNfc => 'Errore nella lettura NFC';

  @override
  String get scanHistoryTitle => 'Cronologia scansioni';

  @override
  String get noScansRecorded => 'Nessuna scansione registrata';

  @override
  String get scansWillAppearHere =>
      'Le scansioni NFC appariranno qui automaticamente';

  @override
  String get clearAll => 'Cancella tutto';

  @override
  String get deleteThisScan => 'Eliminare questa scansione?';

  @override
  String get actionIrreversible => 'Questa azione è irreversibile.';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get clearAllHistory => 'Cancellare tutta la cronologia?';

  @override
  String get allScansWillBeDeleted =>
      'Tutte le scansioni saranno eliminate. Questa azione è irreversibile.';

  @override
  String get scanDeleted => 'Scansione eliminata';

  @override
  String get scanDetails => 'Dettagli scansione';

  @override
  String scannedOn(Object date) {
    return 'Scansionato il $date';
  }

  @override
  String get bobbinInformation => 'Informazioni bobina';

  @override
  String get filamentType => 'Tipo di filamento';

  @override
  String get color => 'Colore';

  @override
  String get weight => 'Peso';

  @override
  String get manufacturingDate => 'Data di produzione';

  @override
  String get batchNumber => 'Numero di lotto';

  @override
  String get printerSettings => 'Impostazioni stampante';

  @override
  String get scanMetadata => 'Metadati scansione';

  @override
  String get scanId => 'ID scansione';

  @override
  String get dateAndTime => 'Data e ora';

  @override
  String get reuseThisData => 'Riutilizza questi dati';

  @override
  String get writeToNfc => 'Scrivi su NFC';

  @override
  String get writeDataToChip => 'Scrivi dati sul chip';

  @override
  String get writeSuccess => 'Scrittura riuscita!';

  @override
  String get writeError => 'Errore di scrittura';

  @override
  String get brand => 'Marca';

  @override
  String get selectBrand => 'Seleziona marca';

  @override
  String get materialType => 'Tipo di materiale';

  @override
  String get selectMaterial => 'Seleziona materiale';

  @override
  String get serialNumber => 'Numero di serie';

  @override
  String get serialNumberHint => 'es.: 001';

  @override
  String get initialWeight => 'Peso iniziale';

  @override
  String get initialWeightHint => 'es.: 1000';

  @override
  String get extruderTempMin => 'Temp Estrusore Min';

  @override
  String get extruderTempMax => 'Temp Estrusore Max';

  @override
  String get bedTempMin => 'Temp Piatto Min';

  @override
  String get bedTempMax => 'Temp Piatto Max';

  @override
  String get diameter => 'Diametro Filamento';

  @override
  String get spoolLength => 'Lunghezza Bobina';

  @override
  String get generatedSku => 'SKU Generato';

  @override
  String get approachChipToWrite => 'Avvicina il chip per scrivere...';

  @override
  String get writing => 'Scrittura...';

  @override
  String get chooseColor => 'Scegli colore';

  @override
  String get required => 'Obbligatorio';

  @override
  String get invalid => 'Non valido';

  @override
  String get advancedSettings => 'Impostazioni avanzate';

  @override
  String get opacity => 'Opacità';

  @override
  String get validate => 'Convalida';

  @override
  String get nfcTagInfo =>
      'Utilizzare un tag NFC vuoto ISO14443A (NTAG213) per creare i propri tag Anycubic.';

  @override
  String get stockInventory => 'Bobine in magazzino';

  @override
  String get addSpool => 'Aggiungi bobina';

  @override
  String get scanSpool => 'Scansiona bobina';

  @override
  String get addManually => 'Aggiungi manualmente';

  @override
  String get spoolAdded => 'Bobina aggiunta';

  @override
  String get spoolUpdated => 'Bobina aggiornata';

  @override
  String get noSpoolsInStock => 'Nessuna bobina in magazzino';

  @override
  String get addFirstSpool =>
      'Aggiungi la tua prima bobina per iniziare a tracciare il tuo inventario';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count bobina/e a scorta bassa (< $threshold%)';
  }

  @override
  String get edit => 'Modifica';

  @override
  String get bobbinPrice => 'Prezzo bobina';

  @override
  String get price => 'Prezzo';

  @override
  String get priceHint => 'es.: 25.00';

  @override
  String get save => 'Salva';

  @override
  String get spoolDetails => 'Dettagli bobina';

  @override
  String get deleteThisSpool => 'Eliminare questa bobina?';

  @override
  String get cannotBeUndone => 'Questa azione non può essere annullata.';

  @override
  String get addSpoolManually => 'Aggiungi bobina manualmente';

  @override
  String get editSpool => 'Modifica bobina';

  @override
  String get customBrand => 'Marca personalizzata';

  @override
  String get customBrandHint => 'es.: La mia marca';

  @override
  String get chooseFromList => 'Scegli dalla lista';

  @override
  String get addBrand => '+ Aggiungi marca';

  @override
  String get customMaterial => 'Materiale personalizzato';

  @override
  String get customMaterialHint => 'es.: Il mio materiale';

  @override
  String get addMaterial => '+ Aggiungi materiale';

  @override
  String get colorHint => 'es.: Blu, Rosso...';

  @override
  String get enterColor => 'Inserisci un colore';

  @override
  String get initialWeightG => 'Peso iniziale';

  @override
  String get remainingWeightG => 'Peso rimanente';

  @override
  String get enterBrand => 'Inserisci una marca';

  @override
  String get selectOrEnterBrand => 'Seleziona o inserisci una marca';

  @override
  String get enterMaterial => 'Inserisci un materiale';

  @override
  String get selectOrEnterMaterial => 'Seleziona o inserisci un materiale';

  @override
  String get enterPrice => 'Inserisci un prezzo';

  @override
  String get enterValidPrice => 'Inserisci un prezzo valido';

  @override
  String get enterWeight => 'Inserisci un peso';

  @override
  String get enterValidWeight => 'Inserisci un peso valido';

  @override
  String get remainingCannotExceedTotal =>
      'Il peso rimanente non può superare il peso totale';

  @override
  String get overview => 'Panoramica';

  @override
  String get spoolsInStock => 'Bobine in magazzino';

  @override
  String get totalValue => 'Valore totale';

  @override
  String get lowStockSpools => 'Scorta bassa';

  @override
  String get materialDistribution => 'Distribuzione per materiale';

  @override
  String get brandDistribution => 'Distribuzione per marca';

  @override
  String get noData => 'Nessun dato';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get profileSettings => 'Impostazioni profilo';

  @override
  String get preferences => 'Preferenze';

  @override
  String get language => 'Lingua';

  @override
  String get selectLanguage => 'Seleziona lingua';

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
  String get selectCurrency => 'Seleziona valuta';

  @override
  String get units => 'Unità';

  @override
  String get selectUnits => 'Seleziona unità';

  @override
  String get metric => 'Metrico (mm, g, °C)';

  @override
  String get imperial => 'Imperiale (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Soglia di allerta scorta bassa';

  @override
  String get lowStockThresholdDesc =>
      'Una bobina sarà considerata a scorta bassa se il peso rimanente è inferiore a questa percentuale';

  @override
  String get authentication => 'Autenticazione';

  @override
  String get signInWithGoogle => 'Accedi con Google';

  @override
  String get signInWithApple => 'Accedi con Apple';

  @override
  String get continueWithApple => 'Continua con Apple';

  @override
  String get continueWithGoogle => 'Continua con Google';

  @override
  String get comingSoon => 'Prossimamente';

  @override
  String get about => 'Informazioni';

  @override
  String get version => 'Versione';

  @override
  String get madeWith => 'Fatto con ❤️ per stampanti 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Scansiona bobina';

  @override
  String get nfcEncoder => 'Encoder NFC';

  @override
  String get length => 'Lunghezza';

  @override
  String get tempExtruder => 'Temp. Estrusore';

  @override
  String get tempBed => 'Temp. Piatto';

  @override
  String get termsOfService => 'Condizioni di servizio';

  @override
  String get privacyPolicy => 'Politica sulla privacy';

  @override
  String get legal => 'Legale';

  @override
  String get back => 'Indietro';

  @override
  String get retry => 'Riprova';

  @override
  String get signOut => 'Esci';

  @override
  String get extruderTempMinHint => 'Es: 200';

  @override
  String get extruderTempMaxHint => 'Es: 220';

  @override
  String get bedTempMinHint => 'Es: 50';

  @override
  String get bedTempMaxHint => 'Es: 60';

  @override
  String get diameterHint => 'Es: 1.75';

  @override
  String get spoolLengthHint => 'Es: 330';

  @override
  String get tabGrid => 'Griglia';

  @override
  String get tabSpectrum => 'Spettro';

  @override
  String get tabSliders => 'Cursori';

  @override
  String get hexCode => 'Codice Esadecimale';

  @override
  String get red => 'Rosso';

  @override
  String get green => 'Verde';

  @override
  String get blue => 'Blu';

  @override
  String get black => 'Nero';

  @override
  String get white => 'Bianco';

  @override
  String get yellow => 'Giallo';

  @override
  String get orange => 'Arancione';

  @override
  String get pink => 'Rosa';

  @override
  String get purple => 'Viola';

  @override
  String get gray => 'Grigio';

  @override
  String get brown => 'Marrone';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get metricUnits => 'Metrico (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperiale (in, oz, °F)';

  @override
  String get chf => 'Franco svizzero (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Dollaro USA (\$)';

  @override
  String get gbp => 'Sterlina (£)';

  @override
  String get cad => 'Dollaro canadese (CAD)';

  @override
  String get aud => 'Dollaro australiano (A\$)';

  @override
  String get jpy => 'Yen giapponese (¥)';

  @override
  String get cny => 'Yuan cinese (¥)';

  @override
  String get inr => 'Rupia indiana (₹)';

  @override
  String get brl => 'Real brasiliano (R\$)';

  @override
  String get mxn => 'Peso messicano (MX\$)';

  @override
  String get sek => 'Corona svedese (kr)';

  @override
  String get nok => 'Corona norvegese (kr)';

  @override
  String get dkk => 'Corona danese (kr)';

  @override
  String get pln => 'Zloty polacco (zł)';

  @override
  String get czk => 'Corona ceca (Kč)';

  @override
  String get nzd => 'Dollaro neozelandese (NZ\$)';

  @override
  String get filamentsToOrder => 'Filamenti da ordinare';

  @override
  String get shoppingList => 'Lista della spesa';

  @override
  String get addToShoppingList => 'Aggiungi alla lista';

  @override
  String get noLowStockFilaments => 'Nessun filamento con scorte basse';

  @override
  String get vipSubscriptionDescription =>
      'Questo abbonamento serve solo a disattivare la pubblicità in-app e a sostenere il progetto. Nessuna altra funzionalità.';

  @override
  String get monthlySubscription => 'Abbonamento Mensile';

  @override
  String get yearlySubscription => 'Abbonamento Annuale';

  @override
  String get perMonth => '/ mese';

  @override
  String get perYear => '/ anno';

  @override
  String onlyPerMonth(String price) {
    return 'Solo $price / mese';
  }

  @override
  String get subscribe => 'Abbonati';

  @override
  String get bestOffer => '✨ MIGLIORE OFFERTA ✨';

  @override
  String get forAnycubicAce => 'per Anycubic Ace';

  @override
  String get forBambuLabAms => 'per Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Scansiona un chip NFC';

  @override
  String get fillForm => 'Compila il modulo';

  @override
  String get emptyShoppingList => 'Nessun filamento nella lista';

  @override
  String percentRemaining(String percent) {
    return '$percent% rimanente';
  }

  @override
  String get markAsOrdered => 'Segna come ordinato';

  @override
  String get markAsNotOrdered => 'Segna come non ordinato';

  @override
  String get notSignedIn => 'Non connesso';

  @override
  String get signIn => 'Accedi';

  @override
  String get connection => 'Accesso';

  @override
  String get signInToSync => 'Accedi per sincronizzare i tuoi dati';

  @override
  String get continueWithoutAccount =>
      'Continua senza account (modalità locale)';

  @override
  String get privacyNotice =>
      'Effettuando l\'accesso, accetti i nostri\nTermini di servizio e Informativa sulla privacy';

  @override
  String get updateStock => 'Aggiorna stock';

  @override
  String get scanToUpdateStock => 'Scansiona per aggiornare';

  @override
  String get weightUsed => 'Peso utilizzato';

  @override
  String get lengthUsed => 'Lunghezza utilizzata';

  @override
  String get enterWeightOrLength => 'Inserisci peso o lunghezza utilizzata';

  @override
  String get weightUsedG => 'Peso utilizzato (g)';

  @override
  String get lengthUsedM => 'Lunghezza utilizzata (m)';

  @override
  String get stockUpdated => 'Stock aggiornato';

  @override
  String get scanSpoolToUpdate =>
      'Scansiona una bobina per aggiornare il suo stock';

  @override
  String get spoolNotFound => 'Bobina non trovata nello stock';

  @override
  String get addSpoolFirstMessage =>
      'Questa bobina non è ancora nel tuo stock. Aggiungila prima utilizzando il pulsante \'Aggiungi Bobina\' prima di aggiornare il suo stock.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Sola lettura';

  @override
  String get bambuLabReadOnlyDesc =>
      'I tag Bambu Lab utilizzano la crittografia RSA e non possono essere modificati. Sola lettura.';

  @override
  String get forPrusaMk4 => 'per Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Lettura e Scrittura';

  @override
  String get prusaReadWriteDesc =>
      'I tag Prusa usano ISO 15693 (NFC-V) con formato OpenPrintTag. Lettura e scrittura supportate.';

  @override
  String get bambuCloneLibrary => 'Libreria cloni Bambu Lab';

  @override
  String get noBambuClones => 'Nessun clone Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Scansiona i tag originali Bambu Lab per creare la tua libreria di cloni';

  @override
  String get scanTag => 'Scansiona un tag';

  @override
  String get syncWithCloud => 'Sincronizza con il cloud';

  @override
  String get syncCompleted => 'Sincronizzazione completata';

  @override
  String get deleteClone => 'Elimina clone';

  @override
  String get renameClone => 'Rinomina clone';

  @override
  String get rename => 'Rinomina';

  @override
  String get customName => 'Nome personalizzato';

  @override
  String get clonedOn => 'Clonato il';

  @override
  String get writeThisClone => 'Scrivi questo clone';

  @override
  String get writeClone => 'Scrivi clone';

  @override
  String get writeOnCUID => 'Scrivi su scheda CUID';

  @override
  String get cloneWrittenSuccess => 'Clone scritto con successo!';

  @override
  String get requiredTagFormat => 'Formato tag richiesto';

  @override
  String get type => 'Tipo';

  @override
  String get frequency => 'Frequenza';

  @override
  String get protocol => 'Protocollo';

  @override
  String get capacity => 'Capacità';

  @override
  String get feature => 'Funzionalità';

  @override
  String get uidModifiable => 'Blocco 0 (UID) modificabile';

  @override
  String get whereToBuy =>
      'Cerca \"CUID MiFare Classic 1K\" su AliExpress, Amazon o eBay (~0.50\$/pezzo)';

  @override
  String get magicGen2Required =>
      'Carta Magic Gen2 - MiFare Classic 1K con Block 0 (UID) scrivibile';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Cerca \"Magic Gen2 MiFare Classic 1K\" o \"UID writable\" su AliExpress, Amazon o eBay (~\$0.50/pezzo)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Attenzione: La scrittura con NFC di iPhone potrebbe non funzionare su tutte le carte Magic Gen2. Si consiglia Si consiglia un dispositivo Proxmark3 per la massima affidabilità.';

  @override
  String get step1GetMagicGen2 =>
      'Procurati una carta Magic Gen2 vuota (MiFare Classic 1K con UID scrivibile)';

  @override
  String get instructions => 'Istruzioni';

  @override
  String get step1GetCUID =>
      'Procurati una scheda CUID vuota (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Premi il pulsante \"Scrivi\" qui sotto';

  @override
  String get step3HoldPhone => 'Tieni il tuo iPhone vicino alla scheda CUID';

  @override
  String get step4WaitConfirm => 'Attendi la conferma di scrittura';

  @override
  String get step5TestClone =>
      'Testa il tag clonato sulla tua stampante Bambu Lab!';

  @override
  String get rsaIncluded =>
      'Il clone include la firma RSA originale, sarà accettato dalla stampante!';

  @override
  String get cloneDeleted => 'Clone eliminato';

  @override
  String get deleteAccount => 'Elimina il mio account';

  @override
  String get deleteAccountConfirmation =>
      'Questa azione è irreversibile. Il tuo account e tutti i dati verranno eliminati entro 30 giorni.';

  @override
  String get accountDeletionRequested => 'Richiesta di eliminazione registrata';

  @override
  String get clearShoppingList => 'Svuota lista';

  @override
  String get clearShoppingListConfirmation =>
      'Sei sicuro di voler svuotare l\'intera lista della spesa? Questa azione non può essere annullata.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Cronologia';

  @override
  String get retryButton => 'Riprova';

  @override
  String get readSuccessMessage => 'Lettura riuscita!';

  @override
  String get filamentTypeLabel => 'Tipo di filamento';

  @override
  String get scanNfcChipButton => 'Scansiona chip NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Eliminare clone \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clone \"$name\" eliminato';
  }

  @override
  String get extruderLabel => 'Estrusore';

  @override
  String get writeThisCloneButton => 'Scrivi questo clone';

  @override
  String get customNameHint => 'Nome personalizzato';

  @override
  String get cloneWriteSuccessMessage => 'Clone scritto con successo!';

  @override
  String errorPrefix(String error) {
    return 'Errore: $error';
  }

  @override
  String get writingInProgress => 'Scrittura...';

  @override
  String get writeOnCUIDButton => 'Scrivi su carta CUID';

  @override
  String get diameterLabel => 'Diametro';

  @override
  String get extruderTempLabel => 'Temperatura estrusore';

  @override
  String get bedTempLabel => 'Temperatura piatto';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K byte (1024 byte)';

  @override
  String get rsaSignatureNote =>
      'Il clone include la firma RSA originale, sarà accettato dalla stampante!';

  @override
  String get writeBambuLabTagTitle => 'Scrivi tag Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'Tag Bambu Lab scritto con successo!';

  @override
  String get approachNfcTagMessage => 'Avvicina il tag NFC...';

  @override
  String get bambuLabFormatMiFare => 'Formato Bambu Lab (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Formato Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Questo formato usa i codici materiali Bambu Lab e memorizza i dati in formato compatibile AMS.';

  @override
  String get brandLabel => 'Marca';

  @override
  String get materialTypeLabel => 'Tipo di materiale';

  @override
  String get serialNumber3Digits => 'Numero di serie (3 cifre)';

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
  String get writeBambuLabTagButton => 'Scrivi tag Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Nota: I tag Bambu Lab originali usano crittografia RSA. Questa modalità scrive dati in formato semplificato compatibile.';

  @override
  String signInError(String error) {
    return 'Errore di accesso: $error';
  }

  @override
  String get subscriptionActivatedMessage =>
      'Abbonamento attivato con successo!';

  @override
  String get subscriptionFailedMessage => 'Abbonamento fallito';

  @override
  String errorMessage(String error) {
    return 'Errore: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      'Abbonamento ripristinato con successo!';

  @override
  String get noSubscriptionFoundMessage => 'Nessun abbonamento trovato';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ATTIVO';

  @override
  String get noAdsExperienceMessage =>
      'Stai godendo dell\'esperienza senza pubblicità!';

  @override
  String get subscribedLabel => 'Abbonato';

  @override
  String get restorePurchasesButton => 'Ripristina acquisti';

  @override
  String get cannotExceedRemainingWeight =>
      'Non può superare il peso rimanente';

  @override
  String get pleaseEnterLength => 'Inserisci la lunghezza';

  @override
  String get pleaseEnterValidLength => 'Inserisci una lunghezza valida';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Lunghezza bobina non impostata - impossibile convertire';

  @override
  String get exceedsRemainingWeight => 'Supera il peso rimanente';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Aiutaci a identificare questo filamento';

  @override
  String get helpUsImprove => 'Aiutaci a migliorare!';

  @override
  String get helpIdentifyDescription =>
      'Abbiamo letto il chip ma non siamo riusciti a identificarlo. Dicci quale filamento è per migliorare l\'app.';

  @override
  String get otherBrand => 'Altro';

  @override
  String get thankYouFeedback => 'Grazie per il tuo feedback!';

  @override
  String get send => 'Invia';

  @override
  String get optionalDetails => 'Dettagli opzionali';

  @override
  String get weightGrams => 'Peso (g)';

  @override
  String get diameterMm => 'Diametro (mm)';

  @override
  String get spoolLengthM => 'Lunghezza bobina (m)';

  @override
  String get batchNumberLabel => 'Lotto / SKU';

  @override
  String get contactUs => 'Contattaci';

  @override
  String get contactUsSubtitle => 'Domande, suggerimenti o problemi';

  @override
  String get nfcTagNotDetected => 'Nessun tag NFC rilevato';

  @override
  String get nfcTagNotDetectedDesc =>
      'Nessun tag trovato. Il tag potrebbe essere difettoso, danneggiato o troppo lontano dal telefono. Posiziona la parte superiore del tuo iPhone direttamente sul tag NFC.';

  @override
  String get nfcTagIncompatible => 'Tag NFC incompatibile rilevato';

  @override
  String get nfcTagInfoPrusa =>
      'Utilizza un tag vuoto NXP ICODE SLIX2 (ISO 15693) per creare tag OpenPrintTag compatibili con Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Scrivi OpenPrintTag Prusa';

  @override
  String get signInAppleNotAvailable =>
      'L\'accesso con Apple non è disponibile su questo dispositivo.';

  @override
  String get signInAppleFailed => 'Accesso con Apple fallito. Riprova.';

  @override
  String get signInFailed => 'Accesso fallito. Riprova.';

  @override
  String get mustContain3Digits => 'Deve contenere 3 cifre';

  @override
  String get mustBeNumber => 'Deve essere un numero';

  @override
  String generatedUidLabel(String uid) {
    return 'UID generato: $uid';
  }

  @override
  String get experimentalBadge => 'SPERIMENTALE';

  @override
  String get newBadge => 'NUOVO';

  @override
  String get forCrealityCfs => 'per Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Lettura e scrittura';

  @override
  String get crealityReadWriteDesc =>
      'I tag Creality CFS utilizzano MiFare Classic 1K con crittografia AES-128-ECB. Lettura e scrittura supportate solo su Android.';

  @override
  String get platformLimitationTitle => 'Limitazione piattaforma';

  @override
  String get mifareClassicNotSupportedIos =>
      'I tag MiFare Classic (Bambu Lab, Creality) non sono supportati su iOS a causa di una limitazione di Apple CoreNFC. Questa funzionalità è disponibile solo su Android.';

  @override
  String get nfcTagInfoCreality =>
      'Usa un tag MiFare Classic 1K per scrivere dati compatibili Creality CFS per il Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Rosso, Blu, Nero...';

  @override
  String get dryingTemp => 'Température de séchage';

  @override
  String get dryingTempHint => 'ex. 55';

  @override
  String get dryingTime => 'Temps de séchage (heures)';

  @override
  String get dryingTimeHint => 'ex. 8';
}
