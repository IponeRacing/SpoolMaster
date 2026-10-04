// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Απόθεμα';

  @override
  String get statistics => 'Στατιστικά';

  @override
  String get profile => 'Προφίλ';

  @override
  String get readNfcChip => 'Ανάγνωση Chip NFC';

  @override
  String get scanHistory => 'Ιστορικό';

  @override
  String get writeNfcChip => 'Εγγραφή Chip NFC';

  @override
  String get nfcNotAvailable => 'Το NFC δεν είναι διαθέσιμο';

  @override
  String get nfcNotAvailableDesc =>
      'Η συσκευή σας δεν υποστηρίζει NFC ή είναι απενεργοποιημένο.';

  @override
  String get nfcNotSupported => 'Το NFC δεν υποστηρίζεται σε αυτήν τη συσκευή';

  @override
  String get approachNfcChip => 'Πλησιάστε ένα chip NFC...';

  @override
  String get scanningNfc => 'Σάρωση...';

  @override
  String get nfcDataRead => 'Τα δεδομένα NFC διαβάστηκαν επιτυχώς!';

  @override
  String get errorReadingNfc => 'Σφάλμα ανάγνωσης NFC';

  @override
  String get scanHistoryTitle => 'Ιστορικό Σαρώσεων';

  @override
  String get noScansRecorded => 'Δεν υπάρχουν καταγεγραμμένες σαρώσεις';

  @override
  String get scansWillAppearHere =>
      'Οι σαρώσεις NFC θα εμφανίζονται εδώ αυτόματα';

  @override
  String get clearAll => 'Διαγραφή όλων';

  @override
  String get deleteThisScan => 'Διαγραφή αυτής της σάρωσης;';

  @override
  String get actionIrreversible => 'Αυτή η ενέργεια είναι μη αναστρέψιμη.';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get clearAllHistory => 'Διαγραφή όλου του ιστορικού;';

  @override
  String get allScansWillBeDeleted =>
      'Όλες οι σαρώσεις θα διαγραφούν. Αυτή η ενέργεια είναι μη αναστρέψιμη.';

  @override
  String get scanDeleted => 'Η σάρωση διαγράφηκε';

  @override
  String get scanDetails => 'Λεπτομέρειες Σάρωσης';

  @override
  String scannedOn(Object date) {
    return 'Σαρώθηκε στις $date';
  }

  @override
  String get bobbinInformation => 'Πληροφορίες Καρουλιού';

  @override
  String get filamentType => 'Τύπος Νήματος';

  @override
  String get color => 'Χρώμα';

  @override
  String get weight => 'Βάρος';

  @override
  String get manufacturingDate => 'Ημερομηνία Κατασκευής';

  @override
  String get batchNumber => 'Αριθμός Παρτίδας';

  @override
  String get printerSettings => 'Ρυθμίσεις εκτυπωτή';

  @override
  String get scanMetadata => 'Μεταδεδομένα Σάρωσης';

  @override
  String get scanId => 'ID Σάρωσης';

  @override
  String get dateAndTime => 'Ημερομηνία και Ώρα';

  @override
  String get reuseThisData => 'Επαναχρησιμοποίηση δεδομένων';

  @override
  String get writeToNfc => 'Εγγραφή σε NFC';

  @override
  String get writeDataToChip => 'Εγγραφή δεδομένων στο chip';

  @override
  String get writeSuccess => 'Επιτυχής εγγραφή!';

  @override
  String get writeError => 'Σφάλμα εγγραφής';

  @override
  String get brand => 'Μάρκα';

  @override
  String get selectBrand => 'Επιλογή μάρκας';

  @override
  String get materialType => 'Τύπος Υλικού';

  @override
  String get selectMaterial => 'Επιλογή υλικού';

  @override
  String get serialNumber => 'Σειριακός Αριθμός';

  @override
  String get serialNumberHint => 'π.χ.: 001';

  @override
  String get initialWeight => 'Αρχικό Βάρος';

  @override
  String get initialWeightHint => 'π.χ.: 1000';

  @override
  String get extruderTempMin => 'Θερμ. Εξωθητήρα Ελάχ';

  @override
  String get extruderTempMax => 'Θερμ. Εξωθητήρα Μέγ';

  @override
  String get bedTempMin => 'Θερμ. Πλατφόρμας Ελάχ';

  @override
  String get bedTempMax => 'Θερμ. Πλατφόρμας Μέγ';

  @override
  String get diameter => 'Διάμετρος';

  @override
  String get spoolLength => 'Μήκος (m)';

  @override
  String get generatedSku => 'Παραγόμενο SKU';

  @override
  String get approachChipToWrite => 'Πλησιάστε το chip για εγγραφή...';

  @override
  String get writing => 'Εγγραφή...';

  @override
  String get chooseColor => 'Επιλογή χρώματος';

  @override
  String get required => 'Απαιτείται';

  @override
  String get invalid => 'Μη έγκυρο';

  @override
  String get advancedSettings => 'Προηγμένες Ρυθμίσεις';

  @override
  String get opacity => 'Αδιαφάνεια';

  @override
  String get validate => 'Επικύρωση';

  @override
  String get nfcTagInfo =>
      'Χρησιμοποιήστε μια κενή ετικέτα NFC ISO14443A (NTAG213) για να δημιουργήσετε τις δικές σας ετικέτες Anycubic.';

  @override
  String get stockInventory => 'Καρούλια σε απόθεμα';

  @override
  String get addSpool => 'Προσθήκη Καρουλιού';

  @override
  String get scanSpool => 'Σάρωση Καρουλιού';

  @override
  String get addManually => 'Χειροκίνητη Προσθήκη';

  @override
  String get spoolAdded => 'Το καρούλι προστέθηκε';

  @override
  String get spoolUpdated => 'Το καρούλι ενημερώθηκε';

  @override
  String get noSpoolsInStock => 'Δεν υπάρχουν καρούλια σε απόθεμα';

  @override
  String get addFirstSpool =>
      'Προσθέστε το πρώτο σας καρούλι για να ξεκινήσετε την παρακολούθηση του αποθέματος';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count καρούλι/α με χαμηλό απόθεμα (< $threshold%)';
  }

  @override
  String get edit => 'Επεξεργασία';

  @override
  String get bobbinPrice => 'Τιμή Καρουλιού';

  @override
  String get price => 'Τιμή';

  @override
  String get priceHint => 'π.χ.: 25.00';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get spoolDetails => 'Λεπτομέρειες Καρουλιού';

  @override
  String get deleteThisSpool => 'Διαγραφή αυτού του καρουλιού;';

  @override
  String get cannotBeUndone => 'Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get addSpoolManually => 'Χειροκίνητη Προσθήκη Καρουλιού';

  @override
  String get editSpool => 'Επεξεργασία Καρουλιού';

  @override
  String get customBrand => 'Προσαρμοσμένη Μάρκα';

  @override
  String get customBrandHint => 'π.χ.: Η Μάρκα Μου';

  @override
  String get chooseFromList => 'Επιλογή από λίστα';

  @override
  String get addBrand => '+ Προσθήκη Μάρκας';

  @override
  String get customMaterial => 'Προσαρμοσμένο Υλικό';

  @override
  String get customMaterialHint => 'π.χ.: Το Υλικό Μου';

  @override
  String get addMaterial => '+ Προσθήκη Υλικού';

  @override
  String get colorHint => 'π.χ.: Μπλε, Κόκκινο...';

  @override
  String get enterColor => 'Παρακαλώ εισάγετε ένα χρώμα';

  @override
  String get initialWeightG => 'Αρχικό Βάρος';

  @override
  String get remainingWeightG => 'Υπολειπόμενο Βάρος';

  @override
  String get enterBrand => 'Παρακαλώ εισάγετε μια μάρκα';

  @override
  String get selectOrEnterBrand => 'Παρακαλώ επιλέξτε ή εισάγετε μια μάρκα';

  @override
  String get quantity => 'Ποσότητα';

  @override
  String get quantityHelper =>
      'Προσθέστε πολλές πανομοιότυπες μπομπίνες ταυτόχρονα';

  @override
  String get quantityInvalid => 'Εισαγάγετε έναν αριθμό μεταξύ 1 και 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count σε απόθεμα';
  }

  @override
  String get enterMaterial => 'Παρακαλώ εισάγετε ένα υλικό';

  @override
  String get selectOrEnterMaterial => 'Παρακαλώ επιλέξτε ή εισάγετε ένα υλικό';

  @override
  String get enterPrice => 'Παρακαλώ εισάγετε μια τιμή';

  @override
  String get enterValidPrice => 'Παρακαλώ εισάγετε μια έγκυρη τιμή';

  @override
  String get enterWeight => 'Παρακαλώ εισάγετε ένα βάρος';

  @override
  String get enterValidWeight => 'Παρακαλώ εισάγετε ένα έγκυρο βάρος';

  @override
  String get remainingCannotExceedTotal =>
      'Το υπολειπόμενο βάρος δεν μπορεί να υπερβαίνει το συνολικό βάρος';

  @override
  String get overview => 'Επισκόπηση';

  @override
  String get spoolsInStock => 'Καρούλια σε Απόθεμα';

  @override
  String get totalValue => 'Συνολική Αξία';

  @override
  String get lowStockSpools => 'Χαμηλό Απόθεμα';

  @override
  String get materialDistribution => 'Κατανομή ανά Υλικό';

  @override
  String get brandDistribution => 'Κατανομή ανά Μάρκα';

  @override
  String get noData => 'Δεν υπάρχουν δεδομένα';

  @override
  String get refresh => 'Ανανέωση';

  @override
  String get profileSettings => 'Ρυθμίσεις Προφίλ';

  @override
  String get preferences => 'Προτιμήσεις';

  @override
  String get language => 'Γλώσσα';

  @override
  String get selectLanguage => 'Επιλογή γλώσσας';

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
  String get currency => 'Νόμισμα';

  @override
  String get selectCurrency => 'Επιλογή νομίσματος';

  @override
  String get units => 'Μονάδες';

  @override
  String get selectUnits => 'Επιλογή μονάδων';

  @override
  String get metric => 'Μετρικό (mm, g, °C)';

  @override
  String get imperial => 'Αγγλοσαξονικό (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Όριο Ειδοποίησης Χαμηλού Αποθέματος';

  @override
  String get lowStockThresholdDesc =>
      'Ένα καρούλι θα θεωρείται με χαμηλό απόθεμα αν το υπολειπόμενο βάρος είναι μικρότερο από αυτό το ποσοστό';

  @override
  String get authentication => 'Πιστοποίηση';

  @override
  String get signInWithGoogle => 'Σύνδεση με Google';

  @override
  String get signInWithApple => 'Σύνδεση με Apple';

  @override
  String get continueWithApple => 'Συνέχεια με Apple';

  @override
  String get continueWithGoogle => 'Συνέχεια με Google';

  @override
  String get comingSoon => 'Έρχεται Σύντομα';

  @override
  String get about => 'Σχετικά';

  @override
  String get version => 'Έκδοση';

  @override
  String get madeWith => 'Δημιουργήθηκε με ❤️ για Εκτυπωτές 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Σάρωση Καρουλιού';

  @override
  String get nfcEncoder => 'Κωδικοποιητής NFC';

  @override
  String get length => 'Μήκος';

  @override
  String get tempExtruder => 'Θερμ. Εξωθητήρα';

  @override
  String get tempBed => 'Θερμ. Πλατφόρμας';

  @override
  String get termsOfService => 'Όροι Υπηρεσίας';

  @override
  String get privacyPolicy => 'Πολιτική Απορρήτου';

  @override
  String get legal => 'Νομικά';

  @override
  String get back => 'Πίσω';

  @override
  String get retry => 'Επανάληψη';

  @override
  String get signOut => 'Αποσύνδεση';

  @override
  String get extruderTempMinHint => 'π.χ.: 200';

  @override
  String get extruderTempMaxHint => 'π.χ.: 220';

  @override
  String get bedTempMinHint => 'π.χ.: 50';

  @override
  String get bedTempMaxHint => 'π.χ.: 60';

  @override
  String get diameterHint => 'π.χ.: 1.75';

  @override
  String get spoolLengthHint => 'π.χ.: 330';

  @override
  String get tabGrid => 'Πλέγμα';

  @override
  String get tabSpectrum => 'Φάσμα';

  @override
  String get tabSliders => 'Ρυθμιστικά';

  @override
  String get hexCode => 'Δεκαεξαδικός Κώδικας';

  @override
  String get red => 'Κόκκινο';

  @override
  String get green => 'Πράσινο';

  @override
  String get blue => 'Μπλε';

  @override
  String get black => 'Μαύρο';

  @override
  String get white => 'Λευκό';

  @override
  String get yellow => 'Κίτρινο';

  @override
  String get orange => 'Πορτοκαλί';

  @override
  String get pink => 'Ροζ';

  @override
  String get purple => 'Μωβ';

  @override
  String get gray => 'Γκρι';

  @override
  String get brown => 'Καφέ';

  @override
  String get unknown => 'Άγνωστο';

  @override
  String get metricUnits => 'Μετρικό (mm, g, °C)';

  @override
  String get imperialUnits => 'Αγγλοσαξονικό (in, oz, °F)';

  @override
  String get chf => 'Ελβετικό Φράγκο (CHF)';

  @override
  String get eur => 'Ευρώ (€)';

  @override
  String get usd => 'Δολάριο ΗΠΑ (\$)';

  @override
  String get gbp => 'Λίρα Στερλίνα (£)';

  @override
  String get cad => 'Καναδικό Δολάριο (CAD)';

  @override
  String get aud => 'AUD';

  @override
  String get jpy => 'JPY';

  @override
  String get cny => 'CNY';

  @override
  String get inr => 'INR';

  @override
  String get brl => 'BRL';

  @override
  String get mxn => 'MXN';

  @override
  String get sek => 'SEK';

  @override
  String get nok => 'NOK';

  @override
  String get dkk => 'DKK';

  @override
  String get pln => 'PLN';

  @override
  String get czk => 'CZK';

  @override
  String get nzd => 'NZD';

  @override
  String get filamentsToOrder => 'Φιλαμέντ προς παραγγελία';

  @override
  String get shoppingList => 'Λίστα αγορών';

  @override
  String get addToShoppingList => 'Προσθήκη στη λίστα';

  @override
  String get noLowStockFilaments => 'Δεν υπάρχουν φιλαμέντ με χαμηλό απόθεμα';

  @override
  String get vipSubscriptionDescription =>
      'Αυτή η συνδρομή χρησιμεύει μόνο για την απενεργοποίηση διαφημίσεων εντός εφαρμογής και την υποστήριξη του έργου. Καμία άλλη λειτουργία.';

  @override
  String get monthlySubscription => 'Μηνιαία Συνδρομή';

  @override
  String get yearlySubscription => 'Ετήσια Συνδρομή';

  @override
  String get perMonth => '/ μήνα';

  @override
  String get perYear => '/ έτος';

  @override
  String onlyPerMonth(String price) {
    return 'Μόνο $price / μήνα';
  }

  @override
  String get subscribe => 'Εγγραφή';

  @override
  String get bestOffer => '✨ ΚΑΛΥΤΕΡΗ ΠΡΟΣΦΟΡΑ ✨';

  @override
  String get forAnycubicAce => 'για Anycubic Ace';

  @override
  String get forBambuLabAms => 'για Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Σάρωση chip NFC';

  @override
  String get fillForm => 'Συμπλήρωση φόρμας';

  @override
  String get emptyShoppingList => 'Δεν υπάρχουν φιλαμέντ στη λίστα';

  @override
  String percentRemaining(String percent) {
    return '$percent% απομένει';
  }

  @override
  String get markAsOrdered => 'Σήμανση ως παραγγελμένο';

  @override
  String get markAsNotOrdered => 'Σήμανση ως μη παραγγελμένο';

  @override
  String get notSignedIn => 'Δεν έχετε συνδεθεί';

  @override
  String get signIn => 'Σύνδεση';

  @override
  String get connection => 'Σύνδεση';

  @override
  String get signInToSync => 'Συνδεθείτε για συγχρονισμό των δεδομένων σας';

  @override
  String get continueWithoutAccount =>
      'Συνέχεια χωρίς λογαριασμό (τοπική λειτουργία)';

  @override
  String get privacyNotice =>
      'Συνδεόμενοι, αποδέχεστε τους\nΌρους Χρήσης και την Πολιτική Απορρήτου μας';

  @override
  String get updateStock => 'Ενημέρωση αποθέματος';

  @override
  String get scanToUpdateStock => 'Σάρωση για ενημέρωση';

  @override
  String get weightUsed => 'Βάρος που χρησιμοποιήθηκε';

  @override
  String get lengthUsed => 'Μήκος που χρησιμοποιήθηκε';

  @override
  String get enterWeightOrLength =>
      'Εισάγετε το βάρος ή το μήκος που χρησιμοποιήθηκε';

  @override
  String get weightUsedG => 'Βάρος που χρησιμοποιήθηκε (g)';

  @override
  String get lengthUsedM => 'Μήκος που χρησιμοποιήθηκε (m)';

  @override
  String get stockUpdated => 'Το απόθεμα ενημερώθηκε';

  @override
  String get scanSpoolToUpdate =>
      'Σαρώστε ένα καρούλι για να ενημερώσετε το απόθεμά του';

  @override
  String get spoolNotFound => 'Το καρούλι δεν βρέθηκε στο απόθεμα';

  @override
  String get addSpoolFirstMessage =>
      'Αυτό το καρούλι δεν υπάρχει ακόμη στο απόθεμά σας. Παρακαλώ προσθέστε το πρώτα χρησιμοποιώντας το κουμπί \'Προσθήκη καρουλιού\' πριν ενημερώσετε το απόθεμά του.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Μόνο για ανάγνωση';

  @override
  String get bambuLabReadOnlyDesc =>
      'Οι ετικέτες Bambu Lab χρησιμοποιούν κρυπτογράφηση RSA και δεν μπορούν να τροποποιηθούν. Μόνο για ανάγνωση.';

  @override
  String get forPrusaMk4 => 'για Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Ανάγνωση και εγγραφή';

  @override
  String get prusaReadWriteDesc =>
      'Οι ετικέτες Prusa χρησιμοποιούν ISO 15693 (NFC-V) με μορφή OpenPrintTag. Υποστηρίζονται ανάγνωση και εγγραφή.';

  @override
  String get bambuCloneLibrary => 'Βιβλιοθήκη κλώνων Bambu Lab';

  @override
  String get noBambuClones => 'Δεν υπάρχουν κλώνοι Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Σαρώστε αυθεντικές ετικέτες Bambu Lab για να δημιουργήσετε τη βιβλιοθήκη κλώνων σας';

  @override
  String get scanTag => 'Σάρωση ετικέτας';

  @override
  String get syncWithCloud => 'Συγχρονισμός με το cloud';

  @override
  String get syncCompleted => 'Ο συγχρονισμός ολοκληρώθηκε';

  @override
  String get deleteClone => 'Διαγραφή κλώνου';

  @override
  String get renameClone => 'Μετονομασία κλώνου';

  @override
  String get rename => 'Μετονομασία';

  @override
  String get customName => 'Προσαρμοσμένο όνομα';

  @override
  String get clonedOn => 'Κλωνοποιήθηκε στις';

  @override
  String get writeThisClone => 'Εγγραφή αυτού του κλώνου';

  @override
  String get writeClone => 'Εγγραφή κλώνου';

  @override
  String get writeOnCUID => 'Εγγραφή σε κάρτα CUID';

  @override
  String get cloneWrittenSuccess => 'Ο κλώνος εγγράφηκε επιτυχώς!';

  @override
  String get requiredTagFormat => 'Απαιτούμενη μορφή ετικέτας';

  @override
  String get type => 'Τύπος';

  @override
  String get frequency => 'Συχνότητα';

  @override
  String get protocol => 'Πρωτόκολλο';

  @override
  String get capacity => 'Χωρητικότητα';

  @override
  String get feature => 'Χαρακτηριστικό';

  @override
  String get uidModifiable => 'Μπλοκ 0 (UID) τροποποιήσιμο';

  @override
  String get whereToBuy =>
      'Αναζητήστε \"CUID MiFare Classic 1K\" στο AliExpress, Amazon ή eBay (~\$0.50/τεμάχιο)';

  @override
  String get magicGen2Required =>
      'Κάρτα Magic Gen2 - MiFare Classic 1K με εγγράψιμο Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Αναζητήστε \"Magic Gen2 MiFare Classic 1K\" ή \"UID writable\" στο AliExpress, Amazon ή eBay (~\$0.50/τεμάχιο)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Προειδοποίηση: Η εγγραφή με iPhone NFC μπορεί να μην λειτουργεί σε όλες τις κάρτες Magic Gen2. Συνιστάται συσκευή Proxmark3 για μέγιστη αξιοπιστία.';

  @override
  String get step1GetMagicGen2 =>
      'Αποκτήστε μια κενή κάρτα Magic Gen2 (MiFare Classic 1K με εγγράψιμο UID)';

  @override
  String get instructions => 'Οδηγίες';

  @override
  String get step1GetCUID =>
      'Αποκτήστε μια κενή κάρτα CUID (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Πατήστε το κουμπί \"Εγγραφή\" παρακάτω';

  @override
  String get step3HoldPhone => 'Κρατήστε το τηλέφωνό σας κοντά στην κάρτα CUID';

  @override
  String get step4WaitConfirm => 'Περιμένετε την επιβεβαίωση εγγραφής';

  @override
  String get step5TestClone =>
      'Δοκιμάστε την κλωνοποιημένη ετικέτα στον εκτυπωτή Bambu Lab σας!';

  @override
  String get rsaIncluded =>
      'Ο κλώνος περιλαμβάνει την αρχική υπογραφή RSA, θα γίνει αποδεκτός από τον εκτυπωτή!';

  @override
  String get cloneDeleted => 'Ο κλώνος διαγράφηκε';

  @override
  String get deleteAccount => 'Διαγραφή του λογαριασμού μου';

  @override
  String get deleteAccountConfirmation =>
      'Αυτή η ενέργεια είναι μη αναστρέψιμη. Ο λογαριασμός και όλα τα δεδομένα θα διαγραφούν εντός 30 ημερών.';

  @override
  String get accountDeletionRequested => 'Αίτημα διαγραφής καταχωρήθηκε';

  @override
  String get clearShoppingList => 'Εκκαθάριση λίστας';

  @override
  String get clearShoppingListConfirmation =>
      'Είστε βέβαιοι ότι θέλετε να εκκαθαρίσετε ολόκληρη τη λίστα αγορών; Αυτή η ενέργεια δεν μπορεί να αναιρεθεί.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Ιστορικό';

  @override
  String get retryButton => 'Επανάληψη';

  @override
  String get readSuccessMessage => 'Ανάγνωση επιτυχής!';

  @override
  String get filamentTypeLabel => 'Τύπος νήματος';

  @override
  String get scanNfcChipButton => 'Σάρωση NFC chip';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Διαγραφή κλώνου \"$name\";';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Ο κλώνος \"$name\" διαγράφηκε';
  }

  @override
  String get extruderLabel => 'Εξωθητής';

  @override
  String get writeThisCloneButton => 'Γράψε αυτόν τον κλώνο';

  @override
  String get customNameHint => 'Προσαρμοσμένο όνομα';

  @override
  String get cloneWriteSuccessMessage => 'Ο κλώνος γράφτηκε επιτυχώς!';

  @override
  String errorPrefix(String error) {
    return 'Σφάλμα: $error';
  }

  @override
  String get writingInProgress => 'Εγγραφή...';

  @override
  String get writeOnCUIDButton => 'Γράψε σε κάρτα CUID';

  @override
  String get diameterLabel => 'Διάμετρος';

  @override
  String get extruderTempLabel => 'Θερμοκρασία εξωθητή';

  @override
  String get bedTempLabel => 'Θερμοκρασία βάσης';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K byte (1024 byte)';

  @override
  String get rsaSignatureNote =>
      'Ο κλώνος περιλαμβάνει την αρχική υπογραφή RSA, θα γίνει αποδεκτός από τον εκτυπωτή!';

  @override
  String get writeBambuLabTagTitle => 'Γράψε ετικέτα Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess =>
      'Η ετικέτα Bambu Lab γράφτηκε επιτυχώς!';

  @override
  String get approachNfcTagMessage => 'Πλησιάστε την ετικέτα NFC...';

  @override
  String get bambuLabFormatMiFare => 'Μορφή Bambu Lab (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Μορφή Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Αυτή η μορφή χρησιμοποιεί κωδικούς υλικών Bambu Lab και αποθηκεύει δεδομένα σε μορφή συμβατή με AMS.';

  @override
  String get brandLabel => 'Μάρκα';

  @override
  String get materialTypeLabel => 'Τύπος υλικού';

  @override
  String get serialNumber3Digits => 'Σειριακός αριθμός (3 ψηφία)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (τυπικό)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Γράψε ετικέτα Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Σημείωση: Οι αρχικές ετικέτες Bambu Lab χρησιμοποιούν κρυπτογράφηση RSA. Αυτή η λειτουργία γράφει δεδομένα σε απλοποιημένη συμβατή μορφή.';

  @override
  String signInError(String error) {
    return 'Σφάλμα σύνδεσης: $error';
  }

  @override
  String get subscriptionActivatedMessage =>
      'Η συνδρομή ενεργοποιήθηκε επιτυχώς!';

  @override
  String get subscriptionFailedMessage => 'Η συνδρομή απέτυχε';

  @override
  String errorMessage(String error) {
    return 'Σφάλμα: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Η συνδρομή επαναφέρθηκε επιτυχώς!';

  @override
  String get noSubscriptionFoundMessage => 'Δεν βρέθηκε συνδρομή';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ΕΝΕΡΓΟ';

  @override
  String get noAdsExperienceMessage =>
      'Απολαύστε την εμπειρία χωρίς διαφημίσεις!';

  @override
  String get subscribedLabel => 'Συνδρομητής';

  @override
  String get restorePurchasesButton => 'Επαναφορά αγορών';

  @override
  String get cannotExceedRemainingWeight =>
      'Δεν μπορεί να υπερβεί το υπόλοιπο βάρος';

  @override
  String get pleaseEnterLength => 'Εισάγετε μήκος';

  @override
  String get pleaseEnterValidLength => 'Εισάγετε έγκυρο μήκος';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Το μήκος καρουλιού δεν έχει οριστεί - δεν είναι δυνατή η μετατροπή';

  @override
  String get exceedsRemainingWeight => 'Υπερβαίνει το υπόλοιπο βάρος';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament =>
      'Βοηθήστε μας να αναγνωρίσουμε αυτό το νήμα';

  @override
  String get helpUsImprove => 'Βοηθήστε μας να βελτιωθούμε!';

  @override
  String get helpIdentifyDescription =>
      'Διαβάσαμε το τσιπ αλλά δεν μπορέσαμε να το αναγνωρίσουμε. Πείτε μας ποιο νήμα είναι για να βελτιώσουμε την εφαρμογή.';

  @override
  String get otherBrand => 'Άλλη';

  @override
  String get thankYouFeedback => 'Ευχαριστούμε για τα σχόλιά σας!';

  @override
  String get send => 'Αποστολή';

  @override
  String get optionalDetails => 'Προαιρετικές λεπτομέρειες';

  @override
  String get weightGrams => 'Βάρος (g)';

  @override
  String get diameterMm => 'Διάμετρος (mm)';

  @override
  String get spoolLengthM => 'Μήκος καρουλιού (m)';

  @override
  String get batchNumberLabel => 'Παρτίδα / SKU';

  @override
  String get contactUs => 'Επικοινωνήστε μαζί μας';

  @override
  String get contactUsSubtitle => 'Ερωτήσεις, προτάσεις ή προβλήματα';

  @override
  String get nfcTagNotDetected => 'Δεν εντοπίστηκε ετικέτα NFC';

  @override
  String get nfcTagNotDetectedDesc =>
      'Δεν βρέθηκε ετικέτα. Η ετικέτα μπορεί να είναι νεκρή, κατεστραμμένη ή πολύ μακριά από το τηλέφωνο.';

  @override
  String get nfcTagIncompatible => 'Εντοπίστηκε μη συμβατή ετικέτα NFC';

  @override
  String get nfcAuthError => 'Αποτυχία ελέγχου ταυτότητας NFC tag';

  @override
  String get nfcAuthErrorDesc =>
      'Το tag εντοπίστηκε αλλά ο έλεγχος ταυτότητας απέτυχε μετά από πολλές προσπάθειες. Κρατήστε το tag σταθερά πατημένο στο πίσω μέρος του τηλεφώνου και δοκιμάστε ξανά.';

  @override
  String get nfcTagInfoPrusa =>
      'Χρησιμοποιήστε κενή ετικέτα NXP ICODE SLIX2 (ISO 15693) για να δημιουργήσετε ετικέτες συμβατές με OpenPrintTag για Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Εγγραφή OpenPrintTag Prusa';

  @override
  String get signInAppleNotAvailable =>
      'Η σύνδεση με Apple δεν είναι διαθέσιμη σε αυτή τη συσκευή.';

  @override
  String get signInAppleFailed =>
      'Η σύνδεση με Apple απέτυχε. Παρακαλώ δοκιμάστε ξανά.';

  @override
  String get signInFailed => 'Η σύνδεση απέτυχε. Παρακαλώ δοκιμάστε ξανά.';

  @override
  String get mustContain3Digits => 'Πρέπει να περιέχει 3 ψηφία';

  @override
  String get mustBeNumber => 'Πρέπει να είναι αριθμός';

  @override
  String generatedUidLabel(String uid) {
    return 'Δημιουργημένο UID: $uid';
  }

  @override
  String get experimentalBadge => 'ΠΕΙΡΑΜΑΤΙΚΟ';

  @override
  String get newBadge => 'ΝΕΟ';

  @override
  String get forCrealityCfs => 'για Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Ανάγνωση & εγγραφή';

  @override
  String get crealityReadWriteDesc =>
      'Οι ετικέτες Creality CFS χρησιμοποιούν MiFare Classic 1K με κρυπτογράφηση AES-128-ECB.';

  @override
  String get platformLimitationTitle => 'Περιορισμός πλατφόρμας';

  @override
  String get mifareClassicNotSupportedIos =>
      'Οι ετικέτες MiFare Classic (Bambu Lab, Creality) δεν υποστηρίζονται σε iOS λόγω περιορισμού του Apple CoreNFC.';

  @override
  String get nfcTagInfoCreality =>
      'Χρησιμοποιήστε μια ετικέτα MiFare Classic 1K για εγγραφή δεδομένων συμβατών με Creality CFS για το Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Κόκκινο, Μπλε, Μαύρο...';

  @override
  String get dryingTemp => 'Θερμοκρασία στεγνώματος';

  @override
  String get dryingTempHint => 'π.χ. 55';

  @override
  String get dryingTime => 'Χρόνος στεγνώματος (ώρες)';

  @override
  String get dryingTimeHint => 'π.χ. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Η ετικέτα ανιχνεύτηκε ως $mode — αλλάξτε καρτέλα για τις επόμενες σαρώσεις';
  }

  @override
  String get fallbackChooseMode => 'Επιλογή λειτουργίας χειροκίνητα';

  @override
  String get fallbackChooseModeSubtitle =>
      'Η αυτόματη ανίχνευση δεν μπόρεσε να αναγνωρίσει αυτήν την ετικέτα. Επιλέξτε το πρωτόκολλο:';

  @override
  String get tryAutoDetect => 'Δοκιμάστε αυτόματη ανίχνευση';

  @override
  String get autoDetectAllBrands => 'Αυτόματη ανίχνευση — όλες οι μάρκες';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D και άλλα';

  @override
  String get nfcTipIos =>
      'Ο αναγνώστης NFC βρίσκεται στο πάνω μέρος του iPhone σας. Τοποθετήστε τον απευθείας πάνω στην ετικέτα NFC του ρολού.';

  @override
  String get nfcTipAndroid =>
      'Ο αναγνώστης NFC βρίσκεται συνήθως στο κέντρο του πίσω μέρους του τηλεφώνου. Τοποθετήστε το πίσω μέρος του τηλεφώνου πάνω στην ετικέτα NFC του ρολού.';

  @override
  String get stockSortBy => 'Ταξινόμηση';

  @override
  String get stockFilter => 'Φίλτρο';

  @override
  String get stockSortRecent => 'Πιο πρόσφατα';

  @override
  String get stockSortBrand => 'Μάρκα';

  @override
  String get stockSortMaterial => 'Υλικό';

  @override
  String get stockSortRemaining => 'Υπόλοιπο βάρος';

  @override
  String get stockSortColor => 'Χρώμα';

  @override
  String get stockFilterAll => 'Όλα';

  @override
  String get stockResetFilters => 'Επαναφορά';

  @override
  String get stockNoMatch => 'Καμία μπομπίνα δεν ταιριάζει με τα φίλτρα';

  @override
  String get nfcDisabledTitle => 'Το NFC είναι απενεργοποιημένο';

  @override
  String get nfcDisabledMessage =>
      'Το NFC είναι απενεργοποιημένο. Ενεργοποιήστε το στις ρυθμίσεις του τηλεφώνου για να σαρώσετε τις μπομπίνες.';

  @override
  String get updateAvailableTitle => 'Διαθέσιμη ενημέρωση';

  @override
  String get updateAvailableMessage =>
      'Είναι διαθέσιμη μια νέα έκδοση του Spool Master.';

  @override
  String get updateForcedMessage =>
      'Αυτή η έκδοση δεν υποστηρίζεται πλέον. Ενημερώστε για να συνεχίσετε.';

  @override
  String get updateNow => 'Ενημέρωση';

  @override
  String get updateLater => 'Αργότερα';

  @override
  String get nfcScanGuidance =>
      'Κρατήστε το tag ακίνητο στο πάνω ή πίσω μέρος του τηλεφώνου.';

  @override
  String get tagMovedTitle => 'Το tag μετακινήθηκε';

  @override
  String get tagMovedMessage =>
      'Το tag μετακινήθηκε κατά την ανάγνωση. Τοποθετήστε το ξανά και κρατήστε το τηλέφωνο ακίνητο.';

  @override
  String get lightBlue => 'Γαλάζιο';

  @override
  String get transparent => 'Διαφανές';

  @override
  String get nfcActiveApproachTag => 'NFC ενεργό — πλησιάστε την ετικέτα';

  @override
  String addedToShoppingList(String item) {
    return 'Το $item προστέθηκε στη λίστα αγορών';
  }

  @override
  String get deleteAccountFailed =>
      'Η διαγραφή του λογαριασμού απέτυχε. Δοκιμάστε ξανά.';

  @override
  String get scanHistoryError => 'Σφάλμα πρόσβασης στο ιστορικό σαρώσεων';

  @override
  String get genericBrand => 'Γενικό';

  @override
  String get stockSearchHint => 'Αναζήτηση (μάρκα, χρώμα, θέση…)';

  @override
  String get stockMoreActions => 'Περισσότερες ενέργειες';

  @override
  String get exportExcel => 'Εξαγωγή σε Excel';

  @override
  String get exportFailed => 'Η εξαγωγή απέτυχε';

  @override
  String get exportShareSubject => 'Το απόθεμα νήματός μου (Spool Master)';

  @override
  String get exportColorHex => 'Κωδικός χρώματος';

  @override
  String get exportRemainingPercent => 'Υπόλοιπο (%)';

  @override
  String get exportPricePerKg => 'Τιμή / kg';

  @override
  String get exportAddedDate => 'Ημερομηνία προσθήκης';

  @override
  String get exportOrdered => 'Παραγγέλθηκε';

  @override
  String get exportDate => 'Ημερομηνία';

  @override
  String get exportGrams => 'Γραμμάρια';

  @override
  String get exportCost => 'Κόστος';

  @override
  String get importSpools => 'Εισαγωγή (CSV / Excel)';

  @override
  String get importConfirmTitle => 'Εισαγωγή καρουλιών';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return 'Καρούλια προς προσθήκη: $count\nΉδη σε απόθεμα (παραλείφθηκαν): $duplicates\nΜη αναγνώσιμες γραμμές (παραλείφθηκαν): $skipped';
  }

  @override
  String get importAction => 'Εισαγωγή';

  @override
  String get importNothingFound =>
      'Δεν αναγνωρίστηκε κανένα καρούλι. Το αρχείο πρέπει να περιέχει τουλάχιστον τις στήλες Υλικό και Βάρος (όπως η εξαγωγή Excel της εφαρμογής).';

  @override
  String importDone(int count) {
    return 'Καρούλια που εισήχθησαν: $count';
  }

  @override
  String get importFailed => 'Μη αναγνώσιμο αρχείο';

  @override
  String get location => 'Θέση';

  @override
  String get locationHint => 'Π.χ. Ράφι Α, στεγνό κουτί 2';

  @override
  String get notes => 'Σημειώσεις';

  @override
  String get notesHint => 'Π.χ. να στεγνώσει πριν τη χρήση';

  @override
  String get printCostTitle => 'Κόστος εκτύπωσης';

  @override
  String get printCostGrams => 'Νήμα που χρησιμοποιήθηκε (g)';

  @override
  String printCostResult(String cost) {
    return 'Κόστος υλικού: $cost';
  }

  @override
  String printCostPerKg(String price) {
    return 'Τιμή ανά kg: $price';
  }

  @override
  String get printCostNoPrice =>
      'Προσθέστε την τιμή του καρουλιού για να υπολογιστεί το κόστος.';

  @override
  String get printCostDeduct => 'Αφαίρεση από το απόθεμα';

  @override
  String printCostDeducted(String grams) {
    return '$grams g αφαιρέθηκαν από το απόθεμα';
  }

  @override
  String get consumptionTitle => 'Κατανάλωση';

  @override
  String get consumptionLast30Days => 'Τελευταίες 30 ημέρες';

  @override
  String get consumptionThisMonth => 'Αυτόν τον μήνα';

  @override
  String get consumptionByMaterial => 'Ανά υλικό (30 ημέρες)';

  @override
  String get consumptionMonthly => 'Τελευταίοι 6 μήνες';

  @override
  String get consumptionEmpty =>
      'Δεν έχει καταγραφεί ακόμη κατανάλωση. Εμφανίζεται μόλις ενημερώσετε το υπολειπόμενο βάρος ενός καρουλιού ή χρησιμοποιήσετε τον υπολογιστή κόστους.';

  @override
  String get shareShoppingList => 'Κοινοποίηση λίστας';

  @override
  String get nfcBlankTagTitle => 'Κενή ετικέτα';

  @override
  String get nfcBlankTagDesc =>
      'Αυτή η ετικέτα δεν περιέχει δεδομένα καρουλιού. Προσθέστε το καρούλι χειροκίνητα ή γράψτε την ετικέτα από την εφαρμογή.';

  @override
  String get subscriptionAutoRenewDisclosure =>
      'Η πληρωμή χρεώνεται στον λογαριασμό σας στο κατάστημα κατά την επιβεβαίωση της αγοράς. Η συνδρομή ανανεώνεται αυτόματα, εκτός αν ακυρωθεί τουλάχιστον 24 ώρες πριν από τη λήξη της τρέχουσας περιόδου· η ανανέωση χρεώνεται εντός 24 ωρών πριν από τη λήξη της περιόδου. Μπορείτε να διαχειριστείτε ή να ακυρώσετε τη συνδρομή σας στις ρυθμίσεις του λογαριασμού σας στο κατάστημα.';

  @override
  String get manageSubscription => 'Διαχείριση συνδρομής';
}
