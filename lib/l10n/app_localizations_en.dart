// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Stock';

  @override
  String get statistics => 'Analytics';

  @override
  String get profile => 'Profile';

  @override
  String get readNfcChip => 'Read NFC Chip';

  @override
  String get scanHistory => 'History';

  @override
  String get writeNfcChip => 'Write NFC Chip';

  @override
  String get nfcNotAvailable => 'NFC not available';

  @override
  String get nfcNotAvailableDesc =>
      'Your device does not support NFC or it is disabled.';

  @override
  String get nfcNotSupported => 'NFC not supported on this device';

  @override
  String get approachNfcChip => 'Approach an NFC chip...';

  @override
  String get scanningNfc => 'Scanning...';

  @override
  String get nfcDataRead => 'NFC data read successfully!';

  @override
  String get errorReadingNfc => 'Error reading NFC';

  @override
  String get scanHistoryTitle => 'Scan History';

  @override
  String get noScansRecorded => 'No scans recorded';

  @override
  String get scansWillAppearHere => 'NFC scans will appear here automatically';

  @override
  String get clearAll => 'Clear all';

  @override
  String get deleteThisScan => 'Delete this scan?';

  @override
  String get actionIrreversible => 'This action is irreversible.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get clearAllHistory => 'Clear all history?';

  @override
  String get allScansWillBeDeleted =>
      'All scans will be deleted. This action is irreversible.';

  @override
  String get scanDeleted => 'Scan deleted';

  @override
  String get scanDetails => 'Scan Details';

  @override
  String scannedOn(Object date) {
    return 'Scanned on $date';
  }

  @override
  String get bobbinInformation => 'Bobbin Information';

  @override
  String get filamentType => 'Filament Type';

  @override
  String get color => 'Color';

  @override
  String get weight => 'Weight';

  @override
  String get manufacturingDate => 'Manufacturing Date';

  @override
  String get batchNumber => 'Batch Number';

  @override
  String get printerSettings => 'Printer Settings';

  @override
  String get scanMetadata => 'Scan Metadata';

  @override
  String get scanId => 'Scan ID';

  @override
  String get dateAndTime => 'Date and Time';

  @override
  String get reuseThisData => 'Reuse this data';

  @override
  String get writeToNfc => 'Write to NFC';

  @override
  String get writeDataToChip => 'Write data to chip';

  @override
  String get writeSuccess => 'Write successful!';

  @override
  String get writeError => 'Write error';

  @override
  String get brand => 'Brand';

  @override
  String get selectBrand => 'Select brand';

  @override
  String get materialType => 'Material Type';

  @override
  String get selectMaterial => 'Select material';

  @override
  String get serialNumber => 'Serial Number';

  @override
  String get serialNumberHint => 'e.g.: 001';

  @override
  String get initialWeight => 'Initial Weight';

  @override
  String get initialWeightHint => 'e.g.: 1000';

  @override
  String get extruderTempMin => 'Extruder Temp Min';

  @override
  String get extruderTempMax => 'Extruder Temp Max';

  @override
  String get bedTempMin => 'Bed Temp Min';

  @override
  String get bedTempMax => 'Bed Temp Max';

  @override
  String get diameter => 'Filament Diameter';

  @override
  String get spoolLength => 'Spool Length';

  @override
  String get generatedSku => 'Generated SKU';

  @override
  String get approachChipToWrite => 'Approach chip to write...';

  @override
  String get writing => 'Writing...';

  @override
  String get chooseColor => 'Choose color';

  @override
  String get required => 'Required';

  @override
  String get invalid => 'Invalid';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get opacity => 'Opacity';

  @override
  String get validate => 'Validate';

  @override
  String get nfcTagInfo =>
      'Use a blank ISO14443A NFC tag (NTAG213) to create your own Anycubic tags.';

  @override
  String get stockInventory => 'Spools in stock';

  @override
  String get addSpool => 'Add Spool';

  @override
  String get scanSpool => 'Scan Spool';

  @override
  String get addManually => 'Add manually';

  @override
  String get spoolAdded => 'Spool added';

  @override
  String get spoolUpdated => 'Spool updated';

  @override
  String get noSpoolsInStock => 'No spools in stock';

  @override
  String get addFirstSpool =>
      'Add your first spool to start tracking your inventory';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count spool(s) low in stock (< $threshold%)';
  }

  @override
  String get edit => 'Edit';

  @override
  String get bobbinPrice => 'Bobbin Price';

  @override
  String get price => 'Price';

  @override
  String get priceHint => 'e.g.: 25.00';

  @override
  String get save => 'Save';

  @override
  String get spoolDetails => 'Spool Details';

  @override
  String get deleteThisSpool => 'Delete this spool?';

  @override
  String get cannotBeUndone => 'This action cannot be undone.';

  @override
  String get addSpoolManually => 'Add Spool Manually';

  @override
  String get editSpool => 'Edit Spool';

  @override
  String get customBrand => 'Custom Brand';

  @override
  String get customBrandHint => 'e.g.: My Brand';

  @override
  String get chooseFromList => 'Choose from list';

  @override
  String get addBrand => '+ Add Brand';

  @override
  String get customMaterial => 'Custom Material';

  @override
  String get customMaterialHint => 'e.g.: My Material';

  @override
  String get addMaterial => '+ Add Material';

  @override
  String get colorHint => 'e.g.: Blue, Red...';

  @override
  String get enterColor => 'Please enter a color';

  @override
  String get initialWeightG => 'Initial Weight';

  @override
  String get remainingWeightG => 'Remaining Weight';

  @override
  String get enterBrand => 'Please enter a brand';

  @override
  String get selectOrEnterBrand => 'Please select or enter a brand';

  @override
  String get enterMaterial => 'Please enter a material';

  @override
  String get selectOrEnterMaterial => 'Please select or enter a material';

  @override
  String get enterPrice => 'Please enter a price';

  @override
  String get enterValidPrice => 'Please enter a valid price';

  @override
  String get enterWeight => 'Please enter a weight';

  @override
  String get enterValidWeight => 'Please enter a valid weight';

  @override
  String get remainingCannotExceedTotal =>
      'Remaining weight cannot exceed total weight';

  @override
  String get overview => 'Overview';

  @override
  String get spoolsInStock => 'Spools in Stock';

  @override
  String get totalValue => 'Total Value';

  @override
  String get lowStockSpools => 'Low Stock';

  @override
  String get materialDistribution => 'Distribution by Material';

  @override
  String get brandDistribution => 'Distribution by Brand';

  @override
  String get noData => 'No data';

  @override
  String get refresh => 'Refresh';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select language';

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
  String get currency => 'Currency';

  @override
  String get selectCurrency => 'Select currency';

  @override
  String get units => 'Units';

  @override
  String get selectUnits => 'Select units';

  @override
  String get metric => 'Metric (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Low Stock Alert Threshold';

  @override
  String get lowStockThresholdDesc =>
      'A spool will be considered low in stock if the remaining weight is less than this percentage';

  @override
  String get authentication => 'Authentication';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get madeWith => 'Made with ❤️ for Anycubic 3D Printers';

  @override
  String get scanBobbinDirectly => 'Scan Bobbin';

  @override
  String get nfcEncoder => 'NFC Encoder';

  @override
  String get length => 'Length';

  @override
  String get tempExtruder => 'Extruder Temp.';

  @override
  String get tempBed => 'Bed Temp.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Retry';

  @override
  String get signOut => 'Sign Out';

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
  String get tabGrid => 'Grid';

  @override
  String get tabSpectrum => 'Spectrum';

  @override
  String get tabSliders => 'Sliders';

  @override
  String get hexCode => 'Hex Code';

  @override
  String get red => 'Red';

  @override
  String get green => 'Green';

  @override
  String get blue => 'Blue';

  @override
  String get metricUnits => 'Metric (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Swiss franc (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'US Dollar (\$)';

  @override
  String get gbp => 'Pound Sterling (£)';

  @override
  String get cad => 'Canadian Dollar (CAD)';

  @override
  String get filamentsToOrder => 'Filaments to Order';

  @override
  String get shoppingList => 'Shopping List';

  @override
  String get addToShoppingList => 'Add to List';

  @override
  String get noLowStockFilaments => 'No low stock filaments';

  @override
  String get vipSubscriptionDescription =>
      'This subscription is only used to disable in-app ads and support the project. No other features.';

  @override
  String get monthlySubscription => 'Monthly Subscription';

  @override
  String get yearlySubscription => 'Yearly Subscription';

  @override
  String get perMonth => '/ month';

  @override
  String get perYear => '/ year';

  @override
  String onlyPerMonth(String price) {
    return 'Only $price / month';
  }

  @override
  String get subscribe => 'Subscribe';

  @override
  String get bestOffer => '✨ BEST OFFER ✨';

  @override
  String get forAnycubicAce => 'for Anycubic Ace';

  @override
  String get forBambuLabAms => 'for Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Scan an NFC chip';

  @override
  String get fillForm => 'Fill the form';

  @override
  String get emptyShoppingList => 'No filaments in the list';

  @override
  String percentRemaining(String percent) {
    return '$percent% remaining';
  }

  @override
  String get markAsOrdered => 'Mark as ordered';

  @override
  String get markAsNotOrdered => 'Mark as not ordered';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get signIn => 'Sign in';

  @override
  String get connection => 'Sign In';

  @override
  String get signInToSync => 'Sign in to sync your data';

  @override
  String get continueWithoutAccount => 'Continue without account (local mode)';

  @override
  String get privacyNotice =>
      'By signing in, you accept our\nTerms of Service and Privacy Policy';

  @override
  String get updateStock => 'Update Stock';

  @override
  String get scanToUpdateStock => 'Scan to update';

  @override
  String get weightUsed => 'Weight used';

  @override
  String get lengthUsed => 'Length used';

  @override
  String get enterWeightOrLength => 'Enter weight or length used';

  @override
  String get weightUsedG => 'Weight used (g)';

  @override
  String get lengthUsedM => 'Length used (m)';

  @override
  String get stockUpdated => 'Stock updated';

  @override
  String get scanSpoolToUpdate => 'Scan a spool to update its stock';

  @override
  String get spoolNotFound => 'Spool not found in stock';

  @override
  String get addSpoolFirstMessage =>
      'This spool is not yet in your stock. Please add it first using the \'Add Spool\' button before updating its stock.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Read only';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab tags use RSA encryption and cannot be modified. Reading only.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab Clone Library';

  @override
  String get noBambuClones => 'No Bambu Lab clones';

  @override
  String get scanBambuToClone =>
      'Scan Bambu Lab original tags to create your clone library';

  @override
  String get scanTag => 'Scan a tag';

  @override
  String get syncWithCloud => 'Sync with cloud';

  @override
  String get syncCompleted => 'Sync completed';

  @override
  String get deleteClone => 'Delete clone';

  @override
  String get renameClone => 'Rename clone';

  @override
  String get rename => 'Rename';

  @override
  String get customName => 'Custom name';

  @override
  String get clonedOn => 'Cloned on';

  @override
  String get writeThisClone => 'Write this clone';

  @override
  String get writeClone => 'Write clone';

  @override
  String get writeOnCUID => 'Write on CUID card';

  @override
  String get cloneWrittenSuccess => 'Clone written successfully!';

  @override
  String get requiredTagFormat => 'Required tag format';

  @override
  String get type => 'Type';

  @override
  String get frequency => 'Frequency';

  @override
  String get protocol => 'Protocol';

  @override
  String get capacity => 'Capacity';

  @override
  String get feature => 'Feature';

  @override
  String get uidModifiable => 'Block 0 (UID) modifiable';

  @override
  String get whereToBuy =>
      'Search for \"CUID MiFare Classic 1K\" on AliExpress, Amazon or eBay (~\$0.50/piece)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 Card - MiFare Classic 1K with writable Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Search for \"Magic Gen2 MiFare Classic 1K\" or \"UID writable\" on AliExpress, Amazon or eBay (~\$0.50/piece)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Warning: Writing with iPhone NFC may not work on all Magic Gen2 cards. Android with NFC Tools Pro app or Proxmark3 device recommended for reliability.';

  @override
  String get step1GetMagicGen2 =>
      'Get a blank Magic Gen2 card (MiFare Classic 1K with writable UID)';

  @override
  String get instructions => 'Instructions';

  @override
  String get step1GetCUID => 'Get a blank CUID card (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Press the \"Write\" button below';

  @override
  String get step3HoldPhone => 'Hold your iPhone near the card';

  @override
  String get step4WaitConfirm => 'Wait for write confirmation';

  @override
  String get step5TestClone => 'Test the cloned tag on your Bambu Lab printer!';

  @override
  String get rsaIncluded =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get cloneDeleted => 'Clone deleted';
}

/// The translations for English, as used in Australia (`en_AU`).
class AppLocalizationsEnAu extends AppLocalizationsEn {
  AppLocalizationsEnAu() : super('en_AU');

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Stock';

  @override
  String get statistics => 'Analytics';

  @override
  String get profile => 'Profile';

  @override
  String get readNfcChip => 'Read NFC Chip';

  @override
  String get scanHistory => 'History';

  @override
  String get writeNfcChip => 'Write NFC Chip';

  @override
  String get nfcNotAvailable => 'NFC not available';

  @override
  String get nfcNotAvailableDesc =>
      'Your device does not support NFC or it is disabled.';

  @override
  String get nfcNotSupported => 'NFC not supported on this device';

  @override
  String get approachNfcChip => 'Approach an NFC chip...';

  @override
  String get scanningNfc => 'Scanning...';

  @override
  String get nfcDataRead => 'NFC data read successfully!';

  @override
  String get errorReadingNfc => 'Error reading NFC';

  @override
  String get scanHistoryTitle => 'Scan History';

  @override
  String get noScansRecorded => 'No scans recorded';

  @override
  String get scansWillAppearHere => 'NFC scans will appear here automatically';

  @override
  String get clearAll => 'Clear all';

  @override
  String get deleteThisScan => 'Delete this scan?';

  @override
  String get actionIrreversible => 'This action is irreversible.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get clearAllHistory => 'Clear all history?';

  @override
  String get allScansWillBeDeleted =>
      'All scans will be deleted. This action is irreversible.';

  @override
  String get scanDeleted => 'Scan deleted';

  @override
  String get scanDetails => 'Scan Details';

  @override
  String scannedOn(Object date) {
    return 'Scanned on $date';
  }

  @override
  String get bobbinInformation => 'Bobbin Information';

  @override
  String get filamentType => 'Filament Type';

  @override
  String get color => 'Color';

  @override
  String get weight => 'Weight';

  @override
  String get manufacturingDate => 'Manufacturing Date';

  @override
  String get batchNumber => 'Batch Number';

  @override
  String get printerSettings => 'Printer Settings';

  @override
  String get scanMetadata => 'Scan Metadata';

  @override
  String get scanId => 'Scan ID';

  @override
  String get dateAndTime => 'Date and Time';

  @override
  String get reuseThisData => 'Reuse this data';

  @override
  String get writeToNfc => 'Write to NFC';

  @override
  String get writeDataToChip => 'Write data to chip';

  @override
  String get writeSuccess => 'Write successful!';

  @override
  String get writeError => 'Write error';

  @override
  String get brand => 'Brand';

  @override
  String get selectBrand => 'Select brand';

  @override
  String get materialType => 'Material Type';

  @override
  String get selectMaterial => 'Select material';

  @override
  String get serialNumber => 'Serial Number';

  @override
  String get serialNumberHint => 'e.g.: 001';

  @override
  String get initialWeight => 'Initial Weight';

  @override
  String get initialWeightHint => 'e.g.: 1000';

  @override
  String get extruderTempMin => 'Extruder Temp Min';

  @override
  String get extruderTempMax => 'Extruder Temp Max';

  @override
  String get bedTempMin => 'Bed Temp Min';

  @override
  String get bedTempMax => 'Bed Temp Max';

  @override
  String get diameter => 'Filament Diameter';

  @override
  String get spoolLength => 'Spool Length';

  @override
  String get generatedSku => 'Generated SKU';

  @override
  String get approachChipToWrite => 'Approach chip to write...';

  @override
  String get writing => 'Writing...';

  @override
  String get chooseColor => 'Choose color';

  @override
  String get required => 'Required';

  @override
  String get invalid => 'Invalid';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get opacity => 'Opacity';

  @override
  String get validate => 'Validate';

  @override
  String get nfcTagInfo =>
      'Use a blank ISO14443A NFC tag (NTAG213) to create your own Anycubic tags.';

  @override
  String get stockInventory => 'Spools in stock';

  @override
  String get addSpool => 'Add Spool';

  @override
  String get scanSpool => 'Scan Spool';

  @override
  String get addManually => 'Add manually';

  @override
  String get spoolAdded => 'Spool added';

  @override
  String get spoolUpdated => 'Spool updated';

  @override
  String get noSpoolsInStock => 'No spools in stock';

  @override
  String get addFirstSpool =>
      'Add your first spool to start tracking your inventory';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count spool(s) low in stock (< $threshold%)';
  }

  @override
  String get edit => 'Edit';

  @override
  String get bobbinPrice => 'Bobbin Price';

  @override
  String get price => 'Price';

  @override
  String get priceHint => 'e.g.: 25.00';

  @override
  String get save => 'Save';

  @override
  String get spoolDetails => 'Spool Details';

  @override
  String get deleteThisSpool => 'Delete this spool?';

  @override
  String get cannotBeUndone => 'This action cannot be undone.';

  @override
  String get addSpoolManually => 'Add Spool Manually';

  @override
  String get editSpool => 'Edit Spool';

  @override
  String get customBrand => 'Custom Brand';

  @override
  String get customBrandHint => 'e.g.: My Brand';

  @override
  String get chooseFromList => 'Choose from list';

  @override
  String get addBrand => '+ Add Brand';

  @override
  String get customMaterial => 'Custom Material';

  @override
  String get customMaterialHint => 'e.g.: My Material';

  @override
  String get addMaterial => '+ Add Material';

  @override
  String get colorHint => 'e.g.: Blue, Red...';

  @override
  String get enterColor => 'Please enter a color';

  @override
  String get initialWeightG => 'Initial Weight';

  @override
  String get remainingWeightG => 'Remaining Weight';

  @override
  String get enterBrand => 'Please enter a brand';

  @override
  String get selectOrEnterBrand => 'Please select or enter a brand';

  @override
  String get enterMaterial => 'Please enter a material';

  @override
  String get selectOrEnterMaterial => 'Please select or enter a material';

  @override
  String get enterPrice => 'Please enter a price';

  @override
  String get enterValidPrice => 'Please enter a valid price';

  @override
  String get enterWeight => 'Please enter a weight';

  @override
  String get enterValidWeight => 'Please enter a valid weight';

  @override
  String get remainingCannotExceedTotal =>
      'Remaining weight cannot exceed total weight';

  @override
  String get overview => 'Overview';

  @override
  String get spoolsInStock => 'Spools in Stock';

  @override
  String get totalValue => 'Total Value';

  @override
  String get lowStockSpools => 'Low Stock';

  @override
  String get materialDistribution => 'Distribution by Material';

  @override
  String get brandDistribution => 'Distribution by Brand';

  @override
  String get noData => 'No data';

  @override
  String get refresh => 'Refresh';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select language';

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
  String get currency => 'Currency';

  @override
  String get selectCurrency => 'Select currency';

  @override
  String get units => 'Units';

  @override
  String get selectUnits => 'Select units';

  @override
  String get metric => 'Metric (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Low Stock Alert Threshold';

  @override
  String get lowStockThresholdDesc =>
      'A spool will be considered low in stock if the remaining weight is less than this percentage';

  @override
  String get authentication => 'Authentication';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get madeWith => 'Made with ❤️ for Anycubic 3D Printers';

  @override
  String get scanBobbinDirectly => 'Scan Bobbin';

  @override
  String get nfcEncoder => 'NFC Encoder';

  @override
  String get length => 'Length';

  @override
  String get tempExtruder => 'Extruder Temp.';

  @override
  String get tempBed => 'Bed Temp.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Retry';

  @override
  String get signOut => 'Sign Out';

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
  String get tabGrid => 'Grid';

  @override
  String get tabSpectrum => 'Spectrum';

  @override
  String get tabSliders => 'Sliders';

  @override
  String get hexCode => 'Hex Code';

  @override
  String get red => 'Red';

  @override
  String get green => 'Green';

  @override
  String get blue => 'Blue';

  @override
  String get metricUnits => 'Metric (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Swiss franc (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'US Dollar (\$)';

  @override
  String get gbp => 'Pound Sterling (£)';

  @override
  String get cad => 'Canadian Dollar (CAD)';

  @override
  String get filamentsToOrder => 'Filaments to Order';

  @override
  String get shoppingList => 'Shopping List';

  @override
  String get addToShoppingList => 'Add to List';

  @override
  String get noLowStockFilaments => 'No low stock filaments';

  @override
  String get vipSubscriptionDescription =>
      'This subscription is only used to disable in-app ads and support the project. No other features.';

  @override
  String get monthlySubscription => 'Monthly Subscription';

  @override
  String get yearlySubscription => 'Yearly Subscription';

  @override
  String get perMonth => '/ month';

  @override
  String get perYear => '/ year';

  @override
  String onlyPerMonth(String price) {
    return 'Only $price / month';
  }

  @override
  String get subscribe => 'Subscribe';

  @override
  String get bestOffer => '✨ BEST OFFER ✨';

  @override
  String get forAnycubicAce => 'for Anycubic Ace';

  @override
  String get forBambuLabAms => 'for Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Scan an NFC chip';

  @override
  String get fillForm => 'Fill the form';

  @override
  String get emptyShoppingList => 'No filaments in the list';

  @override
  String percentRemaining(String percent) {
    return '$percent% remaining';
  }

  @override
  String get markAsOrdered => 'Mark as ordered';

  @override
  String get markAsNotOrdered => 'Mark as not ordered';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get signIn => 'Sign in';

  @override
  String get connection => 'Sign In';

  @override
  String get signInToSync => 'Sign in to sync your data';

  @override
  String get continueWithoutAccount => 'Continue without account (local mode)';

  @override
  String get privacyNotice =>
      'By signing in, you accept our\nTerms of Service and Privacy Policy';

  @override
  String get updateStock => 'Update Stock';

  @override
  String get scanToUpdateStock => 'Scan to update';

  @override
  String get weightUsed => 'Weight used';

  @override
  String get lengthUsed => 'Length used';

  @override
  String get enterWeightOrLength => 'Enter weight or length used';

  @override
  String get weightUsedG => 'Weight used (g)';

  @override
  String get lengthUsedM => 'Length used (m)';

  @override
  String get stockUpdated => 'Stock updated';

  @override
  String get scanSpoolToUpdate => 'Scan a spool to update its stock';

  @override
  String get spoolNotFound => 'Spool not found in stock';

  @override
  String get addSpoolFirstMessage =>
      'This spool is not yet in your stock. Please add it first using the \'Add Spool\' button before updating its stock.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Read only';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab tags use RSA encryption and cannot be modified. Reading only.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab Clone Library';

  @override
  String get noBambuClones => 'No Bambu Lab clones';

  @override
  String get scanBambuToClone =>
      'Scan Bambu Lab original tags to create your clone library';

  @override
  String get scanTag => 'Scan a tag';

  @override
  String get syncWithCloud => 'Sync with cloud';

  @override
  String get syncCompleted => 'Sync completed';

  @override
  String get deleteClone => 'Delete clone';

  @override
  String get renameClone => 'Rename clone';

  @override
  String get rename => 'Rename';

  @override
  String get customName => 'Custom name';

  @override
  String get clonedOn => 'Cloned on';

  @override
  String get writeThisClone => 'Write this clone';

  @override
  String get writeClone => 'Write clone';

  @override
  String get writeOnCUID => 'Write on CUID card';

  @override
  String get cloneWrittenSuccess => 'Clone written successfully!';

  @override
  String get requiredTagFormat => 'Required tag format';

  @override
  String get type => 'Type';

  @override
  String get frequency => 'Frequency';

  @override
  String get protocol => 'Protocol';

  @override
  String get capacity => 'Capacity';

  @override
  String get feature => 'Feature';

  @override
  String get uidModifiable => 'Block 0 (UID) modifiable';

  @override
  String get whereToBuy =>
      'Search for \"CUID MiFare Classic 1K\" on AliExpress, Amazon or eBay (~\$0.50/piece)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 Card - MiFare Classic 1K with writable Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Search for \"Magic Gen2 MiFare Classic 1K\" or \"UID writable\" on AliExpress, Amazon or eBay (~\$0.50/piece)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Warning: Writing with iPhone NFC may not work on all Magic Gen2 cards. Android with NFC Tools Pro app or Proxmark3 device recommended for reliability.';

  @override
  String get step1GetMagicGen2 =>
      'Get a blank Magic Gen2 card (MiFare Classic 1K with writable UID)';

  @override
  String get instructions => 'Instructions';

  @override
  String get step1GetCUID => 'Get a blank CUID card (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Press the \"Write\" button below';

  @override
  String get step3HoldPhone => 'Hold your iPhone near the card';

  @override
  String get step4WaitConfirm => 'Wait for write confirmation';

  @override
  String get step5TestClone => 'Test the cloned tag on your Bambu Lab printer!';

  @override
  String get rsaIncluded =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get cloneDeleted => 'Clone deleted';
}

/// The translations for English, as used in Canada (`en_CA`).
class AppLocalizationsEnCa extends AppLocalizationsEn {
  AppLocalizationsEnCa() : super('en_CA');

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Stock';

  @override
  String get statistics => 'Analytics';

  @override
  String get profile => 'Profile';

  @override
  String get readNfcChip => 'Read NFC Chip';

  @override
  String get scanHistory => 'History';

  @override
  String get writeNfcChip => 'Write NFC Chip';

  @override
  String get nfcNotAvailable => 'NFC not available';

  @override
  String get nfcNotAvailableDesc =>
      'Your device does not support NFC or it is disabled.';

  @override
  String get nfcNotSupported => 'NFC not supported on this device';

  @override
  String get approachNfcChip => 'Approach an NFC chip...';

  @override
  String get scanningNfc => 'Scanning...';

  @override
  String get nfcDataRead => 'NFC data read successfully!';

  @override
  String get errorReadingNfc => 'Error reading NFC';

  @override
  String get scanHistoryTitle => 'Scan History';

  @override
  String get noScansRecorded => 'No scans recorded';

  @override
  String get scansWillAppearHere => 'NFC scans will appear here automatically';

  @override
  String get clearAll => 'Clear all';

  @override
  String get deleteThisScan => 'Delete this scan?';

  @override
  String get actionIrreversible => 'This action is irreversible.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get clearAllHistory => 'Clear all history?';

  @override
  String get allScansWillBeDeleted =>
      'All scans will be deleted. This action is irreversible.';

  @override
  String get scanDeleted => 'Scan deleted';

  @override
  String get scanDetails => 'Scan Details';

  @override
  String scannedOn(Object date) {
    return 'Scanned on $date';
  }

  @override
  String get bobbinInformation => 'Bobbin Information';

  @override
  String get filamentType => 'Filament Type';

  @override
  String get color => 'Color';

  @override
  String get weight => 'Weight';

  @override
  String get manufacturingDate => 'Manufacturing Date';

  @override
  String get batchNumber => 'Batch Number';

  @override
  String get printerSettings => 'Printer Settings';

  @override
  String get scanMetadata => 'Scan Metadata';

  @override
  String get scanId => 'Scan ID';

  @override
  String get dateAndTime => 'Date and Time';

  @override
  String get reuseThisData => 'Reuse this data';

  @override
  String get writeToNfc => 'Write to NFC';

  @override
  String get writeDataToChip => 'Write data to chip';

  @override
  String get writeSuccess => 'Write successful!';

  @override
  String get writeError => 'Write error';

  @override
  String get brand => 'Brand';

  @override
  String get selectBrand => 'Select brand';

  @override
  String get materialType => 'Material Type';

  @override
  String get selectMaterial => 'Select material';

  @override
  String get serialNumber => 'Serial Number';

  @override
  String get serialNumberHint => 'e.g.: 001';

  @override
  String get initialWeight => 'Initial Weight';

  @override
  String get initialWeightHint => 'e.g.: 1000';

  @override
  String get extruderTempMin => 'Extruder Temp Min';

  @override
  String get extruderTempMax => 'Extruder Temp Max';

  @override
  String get bedTempMin => 'Bed Temp Min';

  @override
  String get bedTempMax => 'Bed Temp Max';

  @override
  String get diameter => 'Filament Diameter';

  @override
  String get spoolLength => 'Spool Length';

  @override
  String get generatedSku => 'Generated SKU';

  @override
  String get approachChipToWrite => 'Approach chip to write...';

  @override
  String get writing => 'Writing...';

  @override
  String get chooseColor => 'Choose color';

  @override
  String get required => 'Required';

  @override
  String get invalid => 'Invalid';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get opacity => 'Opacity';

  @override
  String get validate => 'Validate';

  @override
  String get nfcTagInfo =>
      'Use a blank ISO14443A NFC tag (NTAG213) to create your own Anycubic tags.';

  @override
  String get stockInventory => 'Spools in stock';

  @override
  String get addSpool => 'Add Spool';

  @override
  String get scanSpool => 'Scan Spool';

  @override
  String get addManually => 'Add manually';

  @override
  String get spoolAdded => 'Spool added';

  @override
  String get spoolUpdated => 'Spool updated';

  @override
  String get noSpoolsInStock => 'No spools in stock';

  @override
  String get addFirstSpool =>
      'Add your first spool to start tracking your inventory';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count spool(s) low in stock (< $threshold%)';
  }

  @override
  String get edit => 'Edit';

  @override
  String get bobbinPrice => 'Bobbin Price';

  @override
  String get price => 'Price';

  @override
  String get priceHint => 'e.g.: 25.00';

  @override
  String get save => 'Save';

  @override
  String get spoolDetails => 'Spool Details';

  @override
  String get deleteThisSpool => 'Delete this spool?';

  @override
  String get cannotBeUndone => 'This action cannot be undone.';

  @override
  String get addSpoolManually => 'Add Spool Manually';

  @override
  String get editSpool => 'Edit Spool';

  @override
  String get customBrand => 'Custom Brand';

  @override
  String get customBrandHint => 'e.g.: My Brand';

  @override
  String get chooseFromList => 'Choose from list';

  @override
  String get addBrand => '+ Add Brand';

  @override
  String get customMaterial => 'Custom Material';

  @override
  String get customMaterialHint => 'e.g.: My Material';

  @override
  String get addMaterial => '+ Add Material';

  @override
  String get colorHint => 'e.g.: Blue, Red...';

  @override
  String get enterColor => 'Please enter a color';

  @override
  String get initialWeightG => 'Initial Weight';

  @override
  String get remainingWeightG => 'Remaining Weight';

  @override
  String get enterBrand => 'Please enter a brand';

  @override
  String get selectOrEnterBrand => 'Please select or enter a brand';

  @override
  String get enterMaterial => 'Please enter a material';

  @override
  String get selectOrEnterMaterial => 'Please select or enter a material';

  @override
  String get enterPrice => 'Please enter a price';

  @override
  String get enterValidPrice => 'Please enter a valid price';

  @override
  String get enterWeight => 'Please enter a weight';

  @override
  String get enterValidWeight => 'Please enter a valid weight';

  @override
  String get remainingCannotExceedTotal =>
      'Remaining weight cannot exceed total weight';

  @override
  String get overview => 'Overview';

  @override
  String get spoolsInStock => 'Spools in Stock';

  @override
  String get totalValue => 'Total Value';

  @override
  String get lowStockSpools => 'Low Stock';

  @override
  String get materialDistribution => 'Distribution by Material';

  @override
  String get brandDistribution => 'Distribution by Brand';

  @override
  String get noData => 'No data';

  @override
  String get refresh => 'Refresh';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select language';

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
  String get currency => 'Currency';

  @override
  String get selectCurrency => 'Select currency';

  @override
  String get units => 'Units';

  @override
  String get selectUnits => 'Select units';

  @override
  String get metric => 'Metric (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Low Stock Alert Threshold';

  @override
  String get lowStockThresholdDesc =>
      'A spool will be considered low in stock if the remaining weight is less than this percentage';

  @override
  String get authentication => 'Authentication';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get madeWith => 'Made with ❤️ for Anycubic 3D Printers';

  @override
  String get scanBobbinDirectly => 'Scan Bobbin';

  @override
  String get nfcEncoder => 'NFC Encoder';

  @override
  String get length => 'Length';

  @override
  String get tempExtruder => 'Extruder Temp.';

  @override
  String get tempBed => 'Bed Temp.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Retry';

  @override
  String get signOut => 'Sign Out';

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
  String get tabGrid => 'Grid';

  @override
  String get tabSpectrum => 'Spectrum';

  @override
  String get tabSliders => 'Sliders';

  @override
  String get hexCode => 'Hex Code';

  @override
  String get red => 'Red';

  @override
  String get green => 'Green';

  @override
  String get blue => 'Blue';

  @override
  String get metricUnits => 'Metric (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Swiss franc (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'US Dollar (\$)';

  @override
  String get gbp => 'Pound Sterling (£)';

  @override
  String get cad => 'Canadian Dollar (CAD)';

  @override
  String get filamentsToOrder => 'Filaments to Order';

  @override
  String get shoppingList => 'Shopping List';

  @override
  String get addToShoppingList => 'Add to List';

  @override
  String get noLowStockFilaments => 'No low stock filaments';

  @override
  String get vipSubscriptionDescription =>
      'This subscription is only used to disable in-app ads and support the project. No other features.';

  @override
  String get monthlySubscription => 'Monthly Subscription';

  @override
  String get yearlySubscription => 'Yearly Subscription';

  @override
  String get perMonth => '/ month';

  @override
  String get perYear => '/ year';

  @override
  String onlyPerMonth(String price) {
    return 'Only $price / month';
  }

  @override
  String get subscribe => 'Subscribe';

  @override
  String get bestOffer => '✨ BEST OFFER ✨';

  @override
  String get forAnycubicAce => 'for Anycubic Ace';

  @override
  String get forBambuLabAms => 'for Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Scan an NFC chip';

  @override
  String get fillForm => 'Fill the form';

  @override
  String get emptyShoppingList => 'No filaments in the list';

  @override
  String percentRemaining(String percent) {
    return '$percent% remaining';
  }

  @override
  String get markAsOrdered => 'Mark as ordered';

  @override
  String get markAsNotOrdered => 'Mark as not ordered';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get signIn => 'Sign in';

  @override
  String get connection => 'Sign In';

  @override
  String get signInToSync => 'Sign in to sync your data';

  @override
  String get continueWithoutAccount => 'Continue without account (local mode)';

  @override
  String get privacyNotice =>
      'By signing in, you accept our\nTerms of Service and Privacy Policy';

  @override
  String get updateStock => 'Update Stock';

  @override
  String get scanToUpdateStock => 'Scan to update';

  @override
  String get weightUsed => 'Weight used';

  @override
  String get lengthUsed => 'Length used';

  @override
  String get enterWeightOrLength => 'Enter weight or length used';

  @override
  String get weightUsedG => 'Weight used (g)';

  @override
  String get lengthUsedM => 'Length used (m)';

  @override
  String get stockUpdated => 'Stock updated';

  @override
  String get scanSpoolToUpdate => 'Scan a spool to update its stock';

  @override
  String get spoolNotFound => 'Spool not found in stock';

  @override
  String get addSpoolFirstMessage =>
      'This spool is not yet in your stock. Please add it first using the \'Add Spool\' button before updating its stock.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Read only';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab tags use RSA encryption and cannot be modified. Reading only.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab Clone Library';

  @override
  String get noBambuClones => 'No Bambu Lab clones';

  @override
  String get scanBambuToClone =>
      'Scan Bambu Lab original tags to create your clone library';

  @override
  String get scanTag => 'Scan a tag';

  @override
  String get syncWithCloud => 'Sync with cloud';

  @override
  String get syncCompleted => 'Sync completed';

  @override
  String get deleteClone => 'Delete clone';

  @override
  String get renameClone => 'Rename clone';

  @override
  String get rename => 'Rename';

  @override
  String get customName => 'Custom name';

  @override
  String get clonedOn => 'Cloned on';

  @override
  String get writeThisClone => 'Write this clone';

  @override
  String get writeClone => 'Write clone';

  @override
  String get writeOnCUID => 'Write on CUID card';

  @override
  String get cloneWrittenSuccess => 'Clone written successfully!';

  @override
  String get requiredTagFormat => 'Required tag format';

  @override
  String get type => 'Type';

  @override
  String get frequency => 'Frequency';

  @override
  String get protocol => 'Protocol';

  @override
  String get capacity => 'Capacity';

  @override
  String get feature => 'Feature';

  @override
  String get uidModifiable => 'Block 0 (UID) modifiable';

  @override
  String get whereToBuy =>
      'Search for \"CUID MiFare Classic 1K\" on AliExpress, Amazon or eBay (~\$0.50/piece)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 Card - MiFare Classic 1K with writable Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Search for \"Magic Gen2 MiFare Classic 1K\" or \"UID writable\" on AliExpress, Amazon or eBay (~\$0.50/piece)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Warning: Writing with iPhone NFC may not work on all Magic Gen2 cards. Android with NFC Tools Pro app or Proxmark3 device recommended for reliability.';

  @override
  String get step1GetMagicGen2 =>
      'Get a blank Magic Gen2 card (MiFare Classic 1K with writable UID)';

  @override
  String get instructions => 'Instructions';

  @override
  String get step1GetCUID => 'Get a blank CUID card (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Press the \"Write\" button below';

  @override
  String get step3HoldPhone => 'Hold your iPhone near the card';

  @override
  String get step4WaitConfirm => 'Wait for write confirmation';

  @override
  String get step5TestClone => 'Test the cloned tag on your Bambu Lab printer!';

  @override
  String get rsaIncluded =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get cloneDeleted => 'Clone deleted';
}

/// The translations for English, as used in the United Kingdom (`en_GB`).
class AppLocalizationsEnGb extends AppLocalizationsEn {
  AppLocalizationsEnGb() : super('en_GB');

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Stock';

  @override
  String get statistics => 'Analytics';

  @override
  String get profile => 'Profile';

  @override
  String get readNfcChip => 'Read NFC Chip';

  @override
  String get scanHistory => 'History';

  @override
  String get writeNfcChip => 'Write NFC Chip';

  @override
  String get nfcNotAvailable => 'NFC not available';

  @override
  String get nfcNotAvailableDesc =>
      'Your device does not support NFC or it is disabled.';

  @override
  String get nfcNotSupported => 'NFC not supported on this device';

  @override
  String get approachNfcChip => 'Approach an NFC chip...';

  @override
  String get scanningNfc => 'Scanning...';

  @override
  String get nfcDataRead => 'NFC data read successfully!';

  @override
  String get errorReadingNfc => 'Error reading NFC';

  @override
  String get scanHistoryTitle => 'Scan History';

  @override
  String get noScansRecorded => 'No scans recorded';

  @override
  String get scansWillAppearHere => 'NFC scans will appear here automatically';

  @override
  String get clearAll => 'Clear all';

  @override
  String get deleteThisScan => 'Delete this scan?';

  @override
  String get actionIrreversible => 'This action is irreversible.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get clearAllHistory => 'Clear all history?';

  @override
  String get allScansWillBeDeleted =>
      'All scans will be deleted. This action is irreversible.';

  @override
  String get scanDeleted => 'Scan deleted';

  @override
  String get scanDetails => 'Scan Details';

  @override
  String scannedOn(Object date) {
    return 'Scanned on $date';
  }

  @override
  String get bobbinInformation => 'Bobbin Information';

  @override
  String get filamentType => 'Filament Type';

  @override
  String get color => 'Color';

  @override
  String get weight => 'Weight';

  @override
  String get manufacturingDate => 'Manufacturing Date';

  @override
  String get batchNumber => 'Batch Number';

  @override
  String get printerSettings => 'Printer Settings';

  @override
  String get scanMetadata => 'Scan Metadata';

  @override
  String get scanId => 'Scan ID';

  @override
  String get dateAndTime => 'Date and Time';

  @override
  String get reuseThisData => 'Reuse this data';

  @override
  String get writeToNfc => 'Write to NFC';

  @override
  String get writeDataToChip => 'Write data to chip';

  @override
  String get writeSuccess => 'Write successful!';

  @override
  String get writeError => 'Write error';

  @override
  String get brand => 'Brand';

  @override
  String get selectBrand => 'Select brand';

  @override
  String get materialType => 'Material Type';

  @override
  String get selectMaterial => 'Select material';

  @override
  String get serialNumber => 'Serial Number';

  @override
  String get serialNumberHint => 'e.g.: 001';

  @override
  String get initialWeight => 'Initial Weight';

  @override
  String get initialWeightHint => 'e.g.: 1000';

  @override
  String get extruderTempMin => 'Extruder Temp Min';

  @override
  String get extruderTempMax => 'Extruder Temp Max';

  @override
  String get bedTempMin => 'Bed Temp Min';

  @override
  String get bedTempMax => 'Bed Temp Max';

  @override
  String get diameter => 'Filament Diameter';

  @override
  String get spoolLength => 'Spool Length';

  @override
  String get generatedSku => 'Generated SKU';

  @override
  String get approachChipToWrite => 'Approach chip to write...';

  @override
  String get writing => 'Writing...';

  @override
  String get chooseColor => 'Choose color';

  @override
  String get required => 'Required';

  @override
  String get invalid => 'Invalid';

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get opacity => 'Opacity';

  @override
  String get validate => 'Validate';

  @override
  String get nfcTagInfo =>
      'Use a blank ISO14443A NFC tag (NTAG213) to create your own Anycubic tags.';

  @override
  String get stockInventory => 'Spools in stock';

  @override
  String get addSpool => 'Add Spool';

  @override
  String get scanSpool => 'Scan Spool';

  @override
  String get addManually => 'Add manually';

  @override
  String get spoolAdded => 'Spool added';

  @override
  String get spoolUpdated => 'Spool updated';

  @override
  String get noSpoolsInStock => 'No spools in stock';

  @override
  String get addFirstSpool =>
      'Add your first spool to start tracking your inventory';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count spool(s) low in stock (< $threshold%)';
  }

  @override
  String get edit => 'Edit';

  @override
  String get bobbinPrice => 'Bobbin Price';

  @override
  String get price => 'Price';

  @override
  String get priceHint => 'e.g.: 25.00';

  @override
  String get save => 'Save';

  @override
  String get spoolDetails => 'Spool Details';

  @override
  String get deleteThisSpool => 'Delete this spool?';

  @override
  String get cannotBeUndone => 'This action cannot be undone.';

  @override
  String get addSpoolManually => 'Add Spool Manually';

  @override
  String get editSpool => 'Edit Spool';

  @override
  String get customBrand => 'Custom Brand';

  @override
  String get customBrandHint => 'e.g.: My Brand';

  @override
  String get chooseFromList => 'Choose from list';

  @override
  String get addBrand => '+ Add Brand';

  @override
  String get customMaterial => 'Custom Material';

  @override
  String get customMaterialHint => 'e.g.: My Material';

  @override
  String get addMaterial => '+ Add Material';

  @override
  String get colorHint => 'e.g.: Blue, Red...';

  @override
  String get enterColor => 'Please enter a color';

  @override
  String get initialWeightG => 'Initial Weight';

  @override
  String get remainingWeightG => 'Remaining Weight';

  @override
  String get enterBrand => 'Please enter a brand';

  @override
  String get selectOrEnterBrand => 'Please select or enter a brand';

  @override
  String get enterMaterial => 'Please enter a material';

  @override
  String get selectOrEnterMaterial => 'Please select or enter a material';

  @override
  String get enterPrice => 'Please enter a price';

  @override
  String get enterValidPrice => 'Please enter a valid price';

  @override
  String get enterWeight => 'Please enter a weight';

  @override
  String get enterValidWeight => 'Please enter a valid weight';

  @override
  String get remainingCannotExceedTotal =>
      'Remaining weight cannot exceed total weight';

  @override
  String get overview => 'Overview';

  @override
  String get spoolsInStock => 'Spools in Stock';

  @override
  String get totalValue => 'Total Value';

  @override
  String get lowStockSpools => 'Low Stock';

  @override
  String get materialDistribution => 'Distribution by Material';

  @override
  String get brandDistribution => 'Distribution by Brand';

  @override
  String get noData => 'No data';

  @override
  String get refresh => 'Refresh';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select language';

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
  String get currency => 'Currency';

  @override
  String get selectCurrency => 'Select currency';

  @override
  String get units => 'Units';

  @override
  String get selectUnits => 'Select units';

  @override
  String get metric => 'Metric (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Low Stock Alert Threshold';

  @override
  String get lowStockThresholdDesc =>
      'A spool will be considered low in stock if the remaining weight is less than this percentage';

  @override
  String get authentication => 'Authentication';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get madeWith => 'Made with ❤️ for Anycubic 3D Printers';

  @override
  String get scanBobbinDirectly => 'Scan Bobbin';

  @override
  String get nfcEncoder => 'NFC Encoder';

  @override
  String get length => 'Length';

  @override
  String get tempExtruder => 'Extruder Temp.';

  @override
  String get tempBed => 'Bed Temp.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Retry';

  @override
  String get signOut => 'Sign Out';

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
  String get tabGrid => 'Grid';

  @override
  String get tabSpectrum => 'Spectrum';

  @override
  String get tabSliders => 'Sliders';

  @override
  String get hexCode => 'Hex Code';

  @override
  String get red => 'Red';

  @override
  String get green => 'Green';

  @override
  String get blue => 'Blue';

  @override
  String get metricUnits => 'Metric (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Swiss franc (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'US Dollar (\$)';

  @override
  String get gbp => 'Pound Sterling (£)';

  @override
  String get cad => 'Canadian Dollar (CAD)';

  @override
  String get filamentsToOrder => 'Filaments to Order';

  @override
  String get shoppingList => 'Shopping List';

  @override
  String get addToShoppingList => 'Add to List';

  @override
  String get noLowStockFilaments => 'No low stock filaments';

  @override
  String get vipSubscriptionDescription =>
      'This subscription is only used to disable in-app ads and support the project. No other features.';

  @override
  String get monthlySubscription => 'Monthly Subscription';

  @override
  String get yearlySubscription => 'Yearly Subscription';

  @override
  String get perMonth => '/ month';

  @override
  String get perYear => '/ year';

  @override
  String onlyPerMonth(String price) {
    return 'Only $price / month';
  }

  @override
  String get subscribe => 'Subscribe';

  @override
  String get bestOffer => '✨ BEST OFFER ✨';

  @override
  String get forAnycubicAce => 'for Anycubic Ace';

  @override
  String get forBambuLabAms => 'for Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Scan an NFC chip';

  @override
  String get fillForm => 'Fill the form';

  @override
  String get emptyShoppingList => 'No filaments in the list';

  @override
  String percentRemaining(String percent) {
    return '$percent% remaining';
  }

  @override
  String get markAsOrdered => 'Mark as ordered';

  @override
  String get markAsNotOrdered => 'Mark as not ordered';

  @override
  String get notSignedIn => 'Not signed in';

  @override
  String get signIn => 'Sign in';

  @override
  String get connection => 'Sign In';

  @override
  String get signInToSync => 'Sign in to sync your data';

  @override
  String get continueWithoutAccount => 'Continue without account (local mode)';

  @override
  String get privacyNotice =>
      'By signing in, you accept our\nTerms of Service and Privacy Policy';

  @override
  String get updateStock => 'Update Stock';

  @override
  String get scanToUpdateStock => 'Scan to update';

  @override
  String get weightUsed => 'Weight used';

  @override
  String get lengthUsed => 'Length used';

  @override
  String get enterWeightOrLength => 'Enter weight or length used';

  @override
  String get weightUsedG => 'Weight used (g)';

  @override
  String get lengthUsedM => 'Length used (m)';

  @override
  String get stockUpdated => 'Stock updated';

  @override
  String get scanSpoolToUpdate => 'Scan a spool to update its stock';

  @override
  String get spoolNotFound => 'Spool not found in stock';

  @override
  String get addSpoolFirstMessage =>
      'This spool is not yet in your stock. Please add it first using the \'Add Spool\' button before updating its stock.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Read only';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab tags use RSA encryption and cannot be modified. Reading only.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab Clone Library';

  @override
  String get noBambuClones => 'No Bambu Lab clones';

  @override
  String get scanBambuToClone =>
      'Scan Bambu Lab original tags to create your clone library';

  @override
  String get scanTag => 'Scan a tag';

  @override
  String get syncWithCloud => 'Sync with cloud';

  @override
  String get syncCompleted => 'Sync completed';

  @override
  String get deleteClone => 'Delete clone';

  @override
  String get renameClone => 'Rename clone';

  @override
  String get rename => 'Rename';

  @override
  String get customName => 'Custom name';

  @override
  String get clonedOn => 'Cloned on';

  @override
  String get writeThisClone => 'Write this clone';

  @override
  String get writeClone => 'Write clone';

  @override
  String get writeOnCUID => 'Write on CUID card';

  @override
  String get cloneWrittenSuccess => 'Clone written successfully!';

  @override
  String get requiredTagFormat => 'Required tag format';

  @override
  String get type => 'Type';

  @override
  String get frequency => 'Frequency';

  @override
  String get protocol => 'Protocol';

  @override
  String get capacity => 'Capacity';

  @override
  String get feature => 'Feature';

  @override
  String get uidModifiable => 'Block 0 (UID) modifiable';

  @override
  String get whereToBuy =>
      'Search for \"CUID MiFare Classic 1K\" on AliExpress, Amazon or eBay (~\$0.50/piece)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 Card - MiFare Classic 1K with writable Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Search for \"Magic Gen2 MiFare Classic 1K\" or \"UID writable\" on AliExpress, Amazon or eBay (~\$0.50/piece)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Warning: Writing with iPhone NFC may not work on all Magic Gen2 cards. Android with NFC Tools Pro app or Proxmark3 device recommended for reliability.';

  @override
  String get step1GetMagicGen2 =>
      'Get a blank Magic Gen2 card (MiFare Classic 1K with writable UID)';

  @override
  String get instructions => 'Instructions';

  @override
  String get step1GetCUID => 'Get a blank CUID card (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Press the \"Write\" button below';

  @override
  String get step3HoldPhone => 'Hold your iPhone near the card';

  @override
  String get step4WaitConfirm => 'Wait for write confirmation';

  @override
  String get step5TestClone => 'Test the cloned tag on your Bambu Lab printer!';

  @override
  String get rsaIncluded =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get cloneDeleted => 'Clone deleted';
}
