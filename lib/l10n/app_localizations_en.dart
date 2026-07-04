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
  String get extruderTempMin => 'Extruder min (°C)';

  @override
  String get extruderTempMax => 'Extruder max (°C)';

  @override
  String get bedTempMin => 'Bed min (°C)';

  @override
  String get bedTempMax => 'Bed max (°C)';

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
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

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
  String get black => 'Black';

  @override
  String get white => 'White';

  @override
  String get yellow => 'Yellow';

  @override
  String get orange => 'Orange';

  @override
  String get pink => 'Pink';

  @override
  String get purple => 'Purple';

  @override
  String get gray => 'Gray';

  @override
  String get brown => 'Brown';

  @override
  String get unknown => 'Unknown';

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
  String get aud => 'Australian Dollar (A\$)';

  @override
  String get jpy => 'Japanese Yen (¥)';

  @override
  String get cny => 'Chinese Yuan (¥)';

  @override
  String get inr => 'Indian Rupee (₹)';

  @override
  String get brl => 'Brazilian Real (R\$)';

  @override
  String get mxn => 'Mexican Peso (MX\$)';

  @override
  String get sek => 'Swedish Krona (kr)';

  @override
  String get nok => 'Norwegian Krone (kr)';

  @override
  String get dkk => 'Danish Krone (kr)';

  @override
  String get pln => 'Polish Zloty (zł)';

  @override
  String get czk => 'Czech Koruna (Kč)';

  @override
  String get nzd => 'New Zealand Dollar (NZ\$)';

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
  String get forPrusaMk4 => 'for Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Read & Write';

  @override
  String get prusaReadWriteDesc =>
      'Prusa tags use ISO 15693 (NFC-V) with OpenPrintTag format. Read and write supported.';

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
      '⚠️ Warning: Writing with iPhone NFC may not work on all Magic Gen2 cards. A Proxmark3 device is recommended for maximum reliability.';

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
  String get step3HoldPhone => 'Hold your phone near the card';

  @override
  String get step4WaitConfirm => 'Wait for write confirmation';

  @override
  String get step5TestClone => 'Test the cloned tag on your Bambu Lab printer!';

  @override
  String get rsaIncluded =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get cloneDeleted => 'Clone deleted';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteAccountConfirmation =>
      'This action is irreversible. Your account and all data will be deleted within 30 days.';

  @override
  String get accountDeletionRequested => 'Account deletion requested';

  @override
  String get clearShoppingList => 'Clear list';

  @override
  String get clearShoppingListConfirmation =>
      'Are you sure you want to clear the entire shopping list? This action cannot be undone.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'History';

  @override
  String get retryButton => 'Retry';

  @override
  String get readSuccessMessage => 'Read successful!';

  @override
  String get filamentTypeLabel => 'Filament type';

  @override
  String get scanNfcChipButton => 'Scan NFC chip';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Delete clone \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clone \"$name\" deleted';
  }

  @override
  String get extruderLabel => 'Extruder';

  @override
  String get writeThisCloneButton => 'Write this clone';

  @override
  String get customNameHint => 'Custom name';

  @override
  String get cloneWriteSuccessMessage => 'Clone written successfully!';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get writingInProgress => 'Writing...';

  @override
  String get writeOnCUIDButton => 'Write on CUID card';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get extruderTempLabel => 'Extruder temperature';

  @override
  String get bedTempLabel => 'Bed temperature';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bytes (1024 bytes)';

  @override
  String get rsaSignatureNote =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get writeBambuLabTagTitle => 'Write Bambu Lab tag';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab tag written successfully!';

  @override
  String get approachNfcTagMessage => 'Approach NFC tag...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab format (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab format';

  @override
  String get bambuLabFormatInfo =>
      'This format uses Bambu Lab material codes and stores data in an AMS-compatible format.';

  @override
  String get brandLabel => 'Brand';

  @override
  String get materialTypeLabel => 'Material type';

  @override
  String get serialNumber3Digits => 'Serial number (3 digits)';

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
  String get writeBambuLabTagButton => 'Write Bambu Lab tag';

  @override
  String get bambuLabRsaNote =>
      'Note: Original Bambu Lab tags use RSA encryption. This mode writes data in a simplified compatible format.';

  @override
  String signInError(String error) {
    return 'Sign in error: $error';
  }

  @override
  String get subscriptionActivatedMessage =>
      'Subscription activated successfully!';

  @override
  String get subscriptionFailedMessage => 'Subscription failed';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      'Subscription restored successfully!';

  @override
  String get noSubscriptionFoundMessage => 'No subscription found';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ACTIVE';

  @override
  String get noAdsExperienceMessage =>
      'You\'re enjoying the ad-free experience!';

  @override
  String get subscribedLabel => 'Subscribed';

  @override
  String get restorePurchasesButton => 'Restore purchases';

  @override
  String get cannotExceedRemainingWeight => 'Cannot exceed remaining weight';

  @override
  String get pleaseEnterLength => 'Please enter length';

  @override
  String get pleaseEnterValidLength => 'Please enter valid length';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Spool length not set - cannot convert';

  @override
  String get exceedsRemainingWeight => 'Exceeds remaining weight';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Help us identify this filament';

  @override
  String get helpUsImprove => 'Help us improve!';

  @override
  String get helpIdentifyDescription =>
      'We read the tag but couldn\'t identify it. Tell us what filament this is so we can improve the app.';

  @override
  String get otherBrand => 'Other';

  @override
  String get thankYouFeedback => 'Thank you for your feedback!';

  @override
  String get send => 'Send';

  @override
  String get optionalDetails => 'Optional details';

  @override
  String get weightGrams => 'Weight (g)';

  @override
  String get diameterMm => 'Diameter (mm)';

  @override
  String get spoolLengthM => 'Spool length (m)';

  @override
  String get batchNumberLabel => 'Batch / SKU';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactUsSubtitle => 'Questions, suggestions or issues';

  @override
  String get nfcTagNotDetected => 'No NFC tag detected';

  @override
  String get nfcTagNotDetectedDesc =>
      'No tag was found. The tag may be dead, damaged, or too far from the phone.';

  @override
  String get nfcTagIncompatible => 'Incompatible NFC tag detected';

  @override
  String get nfcAuthError => 'NFC tag authentication failed';

  @override
  String get nfcAuthErrorDesc =>
      'The tag was detected but authentication failed after multiple attempts. Keep the tag pressed firmly against the back of your phone and try again.';

  @override
  String get nfcTagInfoPrusa =>
      'Use a blank NXP ICODE SLIX2 tag (ISO 15693) to create OpenPrintTag compatible tags for Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Write Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Sign in with Apple is not available on this device.';

  @override
  String get signInAppleFailed =>
      'Sign in with Apple failed. Please try again.';

  @override
  String get signInFailed => 'Sign in failed. Please try again.';

  @override
  String get mustContain3Digits => 'Must contain 3 digits';

  @override
  String get mustBeNumber => 'Must be a number';

  @override
  String generatedUidLabel(String uid) {
    return 'Generated UID: $uid';
  }

  @override
  String get experimentalBadge => 'EXPERIMENTAL';

  @override
  String get newBadge => 'NEW';

  @override
  String get forCrealityCfs => 'for Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Read & Write';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS tags use MiFare Classic 1K with AES-128-ECB encryption. Read and write supported on Android only.';

  @override
  String get platformLimitationTitle => 'Platform Limitation';

  @override
  String get mifareClassicNotSupportedIos =>
      'MiFare Classic tags (Bambu Lab, Creality) are not supported on iOS due to an Apple CoreNFC limitation. This feature is available on Android only.';

  @override
  String get nfcTagInfoCreality =>
      'Use a MiFare Classic 1K tag to write Creality CFS compatible data for Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Red, Blue, Black...';

  @override
  String get dryingTemp => 'Drying temperature';

  @override
  String get dryingTempHint => 'e.g. 55';

  @override
  String get dryingTime => 'Drying time (hours)';

  @override
  String get dryingTimeHint => 'e.g. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tag detected as $mode — switch tab for next scans';
  }

  @override
  String get fallbackChooseMode => 'Choose mode manually';

  @override
  String get fallbackChooseModeSubtitle =>
      'Auto-detection could not identify this tag. Select the protocol:';

  @override
  String get tryAutoDetect => 'Try auto-detect';

  @override
  String get autoDetectAllBrands => 'Auto-detect — all brands';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D and more';

  @override
  String get nfcTipIos =>
      'The NFC reader is at the top of your iPhone. Place it directly on the spool\'s NFC tag.';

  @override
  String get nfcTipAndroid =>
      'The NFC reader is usually at the center back of your phone. Place the back of your phone on the spool\'s NFC tag.';
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
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

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
  String get black => 'Black';

  @override
  String get white => 'White';

  @override
  String get yellow => 'Yellow';

  @override
  String get orange => 'Orange';

  @override
  String get pink => 'Pink';

  @override
  String get purple => 'Purple';

  @override
  String get gray => 'Grey';

  @override
  String get brown => 'Brown';

  @override
  String get unknown => 'Unknown';

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
  String get aud => 'Australian Dollar (A\$)';

  @override
  String get jpy => 'Japanese Yen (¥)';

  @override
  String get cny => 'Chinese Yuan (¥)';

  @override
  String get inr => 'Indian Rupee (₹)';

  @override
  String get brl => 'Brazilian Real (R\$)';

  @override
  String get mxn => 'Mexican Peso (MX\$)';

  @override
  String get sek => 'Swedish Krona (kr)';

  @override
  String get nok => 'Norwegian Krone (kr)';

  @override
  String get dkk => 'Danish Krone (kr)';

  @override
  String get pln => 'Polish Zloty (zł)';

  @override
  String get czk => 'Czech Koruna (Kč)';

  @override
  String get nzd => 'New Zealand Dollar (NZ\$)';

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
  String get forPrusaMk4 => 'for Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Read & Write';

  @override
  String get prusaReadWriteDesc =>
      'Prusa tags use ISO 15693 (NFC-V) with OpenPrintTag format. Read and write supported.';

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
      '⚠️ Warning: Writing with iPhone NFC may not work on all Magic Gen2 cards. A Proxmark3 device is recommended for maximum reliability.';

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
  String get step3HoldPhone => 'Hold your phone near the card';

  @override
  String get step4WaitConfirm => 'Wait for write confirmation';

  @override
  String get step5TestClone => 'Test the cloned tag on your Bambu Lab printer!';

  @override
  String get rsaIncluded =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get cloneDeleted => 'Clone deleted';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteAccountConfirmation =>
      'This action is irreversible. Your account and all data will be deleted within 30 days.';

  @override
  String get accountDeletionRequested => 'Account deletion requested';

  @override
  String get clearShoppingList => 'Clear list';

  @override
  String get clearShoppingListConfirmation =>
      'Are you sure you want to clear the entire shopping list? This action cannot be undone.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'History';

  @override
  String get retryButton => 'Retry';

  @override
  String get readSuccessMessage => 'Read successful!';

  @override
  String get filamentTypeLabel => 'Filament type';

  @override
  String get scanNfcChipButton => 'Scan NFC chip';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Delete clone \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clone \"$name\" deleted';
  }

  @override
  String get extruderLabel => 'Extruder';

  @override
  String get writeThisCloneButton => 'Write this clone';

  @override
  String get customNameHint => 'Custom name';

  @override
  String get cloneWriteSuccessMessage => 'Clone written successfully!';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get writingInProgress => 'Writing...';

  @override
  String get writeOnCUIDButton => 'Write on CUID card';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get extruderTempLabel => 'Extruder temperature';

  @override
  String get bedTempLabel => 'Bed temperature';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bytes (1024 bytes)';

  @override
  String get rsaSignatureNote =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get writeBambuLabTagTitle => 'Write Bambu Lab tag';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab tag written successfully!';

  @override
  String get approachNfcTagMessage => 'Approach NFC tag...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab format (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab format';

  @override
  String get bambuLabFormatInfo =>
      'This format uses Bambu Lab material codes and stores data in an AMS-compatible format.';

  @override
  String get brandLabel => 'Brand';

  @override
  String get materialTypeLabel => 'Material type';

  @override
  String get serialNumber3Digits => 'Serial number (3 digits)';

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
  String get writeBambuLabTagButton => 'Write Bambu Lab tag';

  @override
  String get bambuLabRsaNote =>
      'Note: Original Bambu Lab tags use RSA encryption. This mode writes data in a simplified compatible format.';

  @override
  String signInError(String error) {
    return 'Sign in error: $error';
  }

  @override
  String get subscriptionActivatedMessage =>
      'Subscription activated successfully!';

  @override
  String get subscriptionFailedMessage => 'Subscription failed';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      'Subscription restored successfully!';

  @override
  String get noSubscriptionFoundMessage => 'No subscription found';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ACTIVE';

  @override
  String get noAdsExperienceMessage =>
      'You\'re enjoying the ad-free experience!';

  @override
  String get subscribedLabel => 'Subscribed';

  @override
  String get restorePurchasesButton => 'Restore purchases';

  @override
  String get cannotExceedRemainingWeight => 'Cannot exceed remaining weight';

  @override
  String get pleaseEnterLength => 'Please enter length';

  @override
  String get pleaseEnterValidLength => 'Please enter valid length';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Spool length not set - cannot convert';

  @override
  String get exceedsRemainingWeight => 'Exceeds remaining weight';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Help us identify this filament';

  @override
  String get helpUsImprove => 'Help us improve!';

  @override
  String get helpIdentifyDescription =>
      'We read the tag but couldn\'t identify it. Tell us what filament this is so we can improve the app.';

  @override
  String get otherBrand => 'Other';

  @override
  String get thankYouFeedback => 'Thank you for your feedback!';

  @override
  String get send => 'Send';

  @override
  String get optionalDetails => 'Optional details';

  @override
  String get weightGrams => 'Weight (g)';

  @override
  String get diameterMm => 'Diameter (mm)';

  @override
  String get spoolLengthM => 'Spool length (m)';

  @override
  String get batchNumberLabel => 'Batch / SKU';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactUsSubtitle => 'Questions, suggestions or issues';

  @override
  String get nfcTagNotDetected => 'No NFC tag detected';

  @override
  String get nfcTagNotDetectedDesc =>
      'No tag was found. The tag may be dead, damaged, or too far from the phone.';

  @override
  String get nfcTagIncompatible => 'Incompatible NFC tag detected';

  @override
  String get nfcAuthError => 'NFC tag authentication failed';

  @override
  String get nfcAuthErrorDesc =>
      'The tag was detected but authentication failed after multiple attempts. Keep the tag pressed firmly against the back of your phone and try again.';

  @override
  String get nfcTagInfoPrusa =>
      'Use a blank NXP ICODE SLIX2 tag (ISO 15693) to create OpenPrintTag compatible tags for Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Write Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Sign in with Apple is not available on this device.';

  @override
  String get signInAppleFailed =>
      'Sign in with Apple failed. Please try again.';

  @override
  String get signInFailed => 'Sign in failed. Please try again.';

  @override
  String get mustContain3Digits => 'Must contain 3 digits';

  @override
  String get mustBeNumber => 'Must be a number';

  @override
  String generatedUidLabel(String uid) {
    return 'Generated UID: $uid';
  }

  @override
  String get experimentalBadge => 'EXPERIMENTAL';

  @override
  String get newBadge => 'NEW';

  @override
  String get forCrealityCfs => 'for Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Read & Write';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS tags use MiFare Classic 1K with AES-128-ECB encryption. Read and write supported on Android only.';

  @override
  String get platformLimitationTitle => 'Platform Limitation';

  @override
  String get mifareClassicNotSupportedIos =>
      'MiFare Classic tags (Bambu Lab, Creality) are not supported on iOS due to an Apple CoreNFC limitation. This feature is available on Android only.';

  @override
  String get nfcTagInfoCreality =>
      'Use a MiFare Classic 1K tag to write Creality CFS compatible data for Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Red, Blue, Black...';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tag detected as $mode — switch tab for next scans';
  }

  @override
  String get fallbackChooseMode => 'Choose mode manually';

  @override
  String get fallbackChooseModeSubtitle =>
      'Auto-detection could not identify this tag. Select the protocol:';

  @override
  String get tryAutoDetect => 'Try auto-detect';

  @override
  String get autoDetectAllBrands => 'Auto-detect — all brands';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D and more';

  @override
  String get nfcTipIos =>
      'The NFC reader is at the top of your iPhone. Place it directly on the spool\'s NFC tag.';

  @override
  String get nfcTipAndroid =>
      'The NFC reader is usually at the centre back of your phone. Place the back of your phone on the spool\'s NFC tag.';
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
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

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
  String get black => 'Black';

  @override
  String get white => 'White';

  @override
  String get yellow => 'Yellow';

  @override
  String get orange => 'Orange';

  @override
  String get pink => 'Pink';

  @override
  String get purple => 'Purple';

  @override
  String get gray => 'Gray';

  @override
  String get brown => 'Brown';

  @override
  String get unknown => 'Unknown';

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
  String get aud => 'Australian Dollar (A\$)';

  @override
  String get jpy => 'Japanese Yen (¥)';

  @override
  String get cny => 'Chinese Yuan (¥)';

  @override
  String get inr => 'Indian Rupee (₹)';

  @override
  String get brl => 'Brazilian Real (R\$)';

  @override
  String get mxn => 'Mexican Peso (MX\$)';

  @override
  String get sek => 'Swedish Krona (kr)';

  @override
  String get nok => 'Norwegian Krone (kr)';

  @override
  String get dkk => 'Danish Krone (kr)';

  @override
  String get pln => 'Polish Zloty (zł)';

  @override
  String get czk => 'Czech Koruna (Kč)';

  @override
  String get nzd => 'New Zealand Dollar (NZ\$)';

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
  String get forPrusaMk4 => 'for Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Read & Write';

  @override
  String get prusaReadWriteDesc =>
      'Prusa tags use ISO 15693 (NFC-V) with OpenPrintTag format. Read and write supported.';

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
      '⚠️ Warning: Writing with iPhone NFC may not work on all Magic Gen2 cards. A Proxmark3 device is recommended for maximum reliability.';

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
  String get step3HoldPhone => 'Hold your phone near the card';

  @override
  String get step4WaitConfirm => 'Wait for write confirmation';

  @override
  String get step5TestClone => 'Test the cloned tag on your Bambu Lab printer!';

  @override
  String get rsaIncluded =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get cloneDeleted => 'Clone deleted';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteAccountConfirmation =>
      'This action is irreversible. Your account and all data will be deleted within 30 days.';

  @override
  String get accountDeletionRequested => 'Account deletion requested';

  @override
  String get clearShoppingList => 'Clear list';

  @override
  String get clearShoppingListConfirmation =>
      'Are you sure you want to clear the entire shopping list? This action cannot be undone.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'History';

  @override
  String get retryButton => 'Retry';

  @override
  String get readSuccessMessage => 'Read successful!';

  @override
  String get filamentTypeLabel => 'Filament type';

  @override
  String get scanNfcChipButton => 'Scan NFC chip';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Delete clone \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clone \"$name\" deleted';
  }

  @override
  String get extruderLabel => 'Extruder';

  @override
  String get writeThisCloneButton => 'Write this clone';

  @override
  String get customNameHint => 'Custom name';

  @override
  String get cloneWriteSuccessMessage => 'Clone written successfully!';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get writingInProgress => 'Writing...';

  @override
  String get writeOnCUIDButton => 'Write on CUID card';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get extruderTempLabel => 'Extruder temperature';

  @override
  String get bedTempLabel => 'Bed temperature';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bytes (1024 bytes)';

  @override
  String get rsaSignatureNote =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get writeBambuLabTagTitle => 'Write Bambu Lab tag';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab tag written successfully!';

  @override
  String get approachNfcTagMessage => 'Approach NFC tag...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab format (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab format';

  @override
  String get bambuLabFormatInfo =>
      'This format uses Bambu Lab material codes and stores data in an AMS-compatible format.';

  @override
  String get brandLabel => 'Brand';

  @override
  String get materialTypeLabel => 'Material type';

  @override
  String get serialNumber3Digits => 'Serial number (3 digits)';

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
  String get writeBambuLabTagButton => 'Write Bambu Lab tag';

  @override
  String get bambuLabRsaNote =>
      'Note: Original Bambu Lab tags use RSA encryption. This mode writes data in a simplified compatible format.';

  @override
  String signInError(String error) {
    return 'Sign in error: $error';
  }

  @override
  String get subscriptionActivatedMessage =>
      'Subscription activated successfully!';

  @override
  String get subscriptionFailedMessage => 'Subscription failed';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      'Subscription restored successfully!';

  @override
  String get noSubscriptionFoundMessage => 'No subscription found';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ACTIVE';

  @override
  String get noAdsExperienceMessage =>
      'You\'re enjoying the ad-free experience!';

  @override
  String get subscribedLabel => 'Subscribed';

  @override
  String get restorePurchasesButton => 'Restore purchases';

  @override
  String get cannotExceedRemainingWeight => 'Cannot exceed remaining weight';

  @override
  String get pleaseEnterLength => 'Please enter length';

  @override
  String get pleaseEnterValidLength => 'Please enter valid length';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Spool length not set - cannot convert';

  @override
  String get exceedsRemainingWeight => 'Exceeds remaining weight';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Help us identify this filament';

  @override
  String get helpUsImprove => 'Help us improve!';

  @override
  String get helpIdentifyDescription =>
      'We read the tag but couldn\'t identify it. Tell us what filament this is so we can improve the app.';

  @override
  String get otherBrand => 'Other';

  @override
  String get thankYouFeedback => 'Thank you for your feedback!';

  @override
  String get send => 'Send';

  @override
  String get optionalDetails => 'Optional details';

  @override
  String get weightGrams => 'Weight (g)';

  @override
  String get diameterMm => 'Diameter (mm)';

  @override
  String get spoolLengthM => 'Spool length (m)';

  @override
  String get batchNumberLabel => 'Batch / SKU';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactUsSubtitle => 'Questions, suggestions or issues';

  @override
  String get nfcTagNotDetected => 'No NFC tag detected';

  @override
  String get nfcTagNotDetectedDesc =>
      'No tag was found. The tag may be dead, damaged, or too far from the phone.';

  @override
  String get nfcTagIncompatible => 'Incompatible NFC tag detected';

  @override
  String get nfcAuthError => 'NFC tag authentication failed';

  @override
  String get nfcAuthErrorDesc =>
      'The tag was detected but authentication failed after multiple attempts. Keep the tag pressed firmly against the back of your phone and try again.';

  @override
  String get nfcTagInfoPrusa =>
      'Use a blank NXP ICODE SLIX2 tag (ISO 15693) to create OpenPrintTag compatible tags for Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Write Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Sign in with Apple is not available on this device.';

  @override
  String get signInAppleFailed =>
      'Sign in with Apple failed. Please try again.';

  @override
  String get signInFailed => 'Sign in failed. Please try again.';

  @override
  String get mustContain3Digits => 'Must contain 3 digits';

  @override
  String get mustBeNumber => 'Must be a number';

  @override
  String generatedUidLabel(String uid) {
    return 'Generated UID: $uid';
  }

  @override
  String get experimentalBadge => 'EXPERIMENTAL';

  @override
  String get newBadge => 'NEW';

  @override
  String get forCrealityCfs => 'for Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Read & Write';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS tags use MiFare Classic 1K with AES-128-ECB encryption. Read and write supported on Android only.';

  @override
  String get platformLimitationTitle => 'Platform Limitation';

  @override
  String get mifareClassicNotSupportedIos =>
      'MiFare Classic tags (Bambu Lab, Creality) are not supported on iOS due to an Apple CoreNFC limitation. This feature is available on Android only.';

  @override
  String get nfcTagInfoCreality =>
      'Use a MiFare Classic 1K tag to write Creality CFS compatible data for Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Red, Blue, Black...';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tag detected as $mode — switch tab for next scans';
  }

  @override
  String get fallbackChooseMode => 'Choose mode manually';

  @override
  String get fallbackChooseModeSubtitle =>
      'Auto-detection could not identify this tag. Select the protocol:';

  @override
  String get tryAutoDetect => 'Try auto-detect';

  @override
  String get autoDetectAllBrands => 'Auto-detect — all brands';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D and more';

  @override
  String get nfcTipIos =>
      'The NFC reader is at the top of your iPhone. Place it directly on the spool\'s NFC tag.';

  @override
  String get nfcTipAndroid =>
      'The NFC reader is usually at the center back of your phone. Place the back of your phone on the spool\'s NFC tag.';
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
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

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
  String get black => 'Black';

  @override
  String get white => 'White';

  @override
  String get yellow => 'Yellow';

  @override
  String get orange => 'Orange';

  @override
  String get pink => 'Pink';

  @override
  String get purple => 'Purple';

  @override
  String get gray => 'Grey';

  @override
  String get brown => 'Brown';

  @override
  String get unknown => 'Unknown';

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
  String get aud => 'Australian Dollar (A\$)';

  @override
  String get jpy => 'Japanese Yen (¥)';

  @override
  String get cny => 'Chinese Yuan (¥)';

  @override
  String get inr => 'Indian Rupee (₹)';

  @override
  String get brl => 'Brazilian Real (R\$)';

  @override
  String get mxn => 'Mexican Peso (MX\$)';

  @override
  String get sek => 'Swedish Krona (kr)';

  @override
  String get nok => 'Norwegian Krone (kr)';

  @override
  String get dkk => 'Danish Krone (kr)';

  @override
  String get pln => 'Polish Zloty (zł)';

  @override
  String get czk => 'Czech Koruna (Kč)';

  @override
  String get nzd => 'New Zealand Dollar (NZ\$)';

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
  String get forPrusaMk4 => 'for Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Read & Write';

  @override
  String get prusaReadWriteDesc =>
      'Prusa tags use ISO 15693 (NFC-V) with OpenPrintTag format. Read and write supported.';

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
      '⚠️ Warning: Writing with iPhone NFC may not work on all Magic Gen2 cards. A Proxmark3 device is recommended for maximum reliability.';

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
  String get step3HoldPhone => 'Hold your phone near the card';

  @override
  String get step4WaitConfirm => 'Wait for write confirmation';

  @override
  String get step5TestClone => 'Test the cloned tag on your Bambu Lab printer!';

  @override
  String get rsaIncluded =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get cloneDeleted => 'Clone deleted';

  @override
  String get deleteAccount => 'Delete my account';

  @override
  String get deleteAccountConfirmation =>
      'This action is irreversible. Your account and all data will be deleted within 30 days.';

  @override
  String get accountDeletionRequested => 'Account deletion requested';

  @override
  String get clearShoppingList => 'Clear list';

  @override
  String get clearShoppingListConfirmation =>
      'Are you sure you want to clear the entire shopping list? This action cannot be undone.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'History';

  @override
  String get retryButton => 'Retry';

  @override
  String get readSuccessMessage => 'Read successful!';

  @override
  String get filamentTypeLabel => 'Filament type';

  @override
  String get scanNfcChipButton => 'Scan NFC chip';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Delete clone \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Clone \"$name\" deleted';
  }

  @override
  String get extruderLabel => 'Extruder';

  @override
  String get writeThisCloneButton => 'Write this clone';

  @override
  String get customNameHint => 'Custom name';

  @override
  String get cloneWriteSuccessMessage => 'Clone written successfully!';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get writingInProgress => 'Writing...';

  @override
  String get writeOnCUIDButton => 'Write on CUID card';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get extruderTempLabel => 'Extruder temperature';

  @override
  String get bedTempLabel => 'Bed temperature';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bytes (1024 bytes)';

  @override
  String get rsaSignatureNote =>
      'The clone includes the original RSA signature, it will be accepted by the printer!';

  @override
  String get writeBambuLabTagTitle => 'Write Bambu Lab tag';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab tag written successfully!';

  @override
  String get approachNfcTagMessage => 'Approach NFC tag...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab format (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab format';

  @override
  String get bambuLabFormatInfo =>
      'This format uses Bambu Lab material codes and stores data in an AMS-compatible format.';

  @override
  String get brandLabel => 'Brand';

  @override
  String get materialTypeLabel => 'Material type';

  @override
  String get serialNumber3Digits => 'Serial number (3 digits)';

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
  String get writeBambuLabTagButton => 'Write Bambu Lab tag';

  @override
  String get bambuLabRsaNote =>
      'Note: Original Bambu Lab tags use RSA encryption. This mode writes data in a simplified compatible format.';

  @override
  String signInError(String error) {
    return 'Sign in error: $error';
  }

  @override
  String get subscriptionActivatedMessage =>
      'Subscription activated successfully!';

  @override
  String get subscriptionFailedMessage => 'Subscription failed';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      'Subscription restored successfully!';

  @override
  String get noSubscriptionFoundMessage => 'No subscription found';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'ACTIVE';

  @override
  String get noAdsExperienceMessage =>
      'You\'re enjoying the ad-free experience!';

  @override
  String get subscribedLabel => 'Subscribed';

  @override
  String get restorePurchasesButton => 'Restore purchases';

  @override
  String get cannotExceedRemainingWeight => 'Cannot exceed remaining weight';

  @override
  String get pleaseEnterLength => 'Please enter length';

  @override
  String get pleaseEnterValidLength => 'Please enter valid length';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Spool length not set - cannot convert';

  @override
  String get exceedsRemainingWeight => 'Exceeds remaining weight';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Help us identify this filament';

  @override
  String get helpUsImprove => 'Help us improve!';

  @override
  String get helpIdentifyDescription =>
      'We read the tag but couldn\'t identify it. Tell us what filament this is so we can improve the app.';

  @override
  String get otherBrand => 'Other';

  @override
  String get thankYouFeedback => 'Thank you for your feedback!';

  @override
  String get send => 'Send';

  @override
  String get optionalDetails => 'Optional details';

  @override
  String get weightGrams => 'Weight (g)';

  @override
  String get diameterMm => 'Diameter (mm)';

  @override
  String get spoolLengthM => 'Spool length (m)';

  @override
  String get batchNumberLabel => 'Batch / SKU';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactUsSubtitle => 'Questions, suggestions or issues';

  @override
  String get nfcTagNotDetected => 'No NFC tag detected';

  @override
  String get nfcTagNotDetectedDesc =>
      'No tag was found. The tag may be dead, damaged, or too far from the phone.';

  @override
  String get nfcTagIncompatible => 'Incompatible NFC tag detected';

  @override
  String get nfcAuthError => 'NFC tag authentication failed';

  @override
  String get nfcAuthErrorDesc =>
      'The tag was detected but authentication failed after multiple attempts. Keep the tag pressed firmly against the back of your phone and try again.';

  @override
  String get nfcTagInfoPrusa =>
      'Use a blank NXP ICODE SLIX2 tag (ISO 15693) to create OpenPrintTag compatible tags for Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Write Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Sign in with Apple is not available on this device.';

  @override
  String get signInAppleFailed =>
      'Sign in with Apple failed. Please try again.';

  @override
  String get signInFailed => 'Sign in failed. Please try again.';

  @override
  String get mustContain3Digits => 'Must contain 3 digits';

  @override
  String get mustBeNumber => 'Must be a number';

  @override
  String generatedUidLabel(String uid) {
    return 'Generated UID: $uid';
  }

  @override
  String get experimentalBadge => 'EXPERIMENTAL';

  @override
  String get newBadge => 'NEW';

  @override
  String get forCrealityCfs => 'for Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Read & Write';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS tags use MiFare Classic 1K with AES-128-ECB encryption. Read and write supported on Android only.';

  @override
  String get platformLimitationTitle => 'Platform Limitation';

  @override
  String get mifareClassicNotSupportedIos =>
      'MiFare Classic tags (Bambu Lab, Creality) are not supported on iOS due to an Apple CoreNFC limitation. This feature is available on Android only.';

  @override
  String get nfcTagInfoCreality =>
      'Use a MiFare Classic 1K tag to write Creality CFS compatible data for Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Red, Blue, Black...';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tag detected as $mode — switch tab for next scans';
  }

  @override
  String get fallbackChooseMode => 'Choose mode manually';

  @override
  String get fallbackChooseModeSubtitle =>
      'Auto-detection could not identify this tag. Select the protocol:';

  @override
  String get tryAutoDetect => 'Try auto-detect';

  @override
  String get autoDetectAllBrands => 'Auto-detect — all brands';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D and more';

  @override
  String get nfcTipIos =>
      'The NFC reader is at the top of your iPhone. Place it directly on the spool\'s NFC tag.';

  @override
  String get nfcTipAndroid =>
      'The NFC reader is usually at the centre back of your phone. Place the back of your phone on the spool\'s NFC tag.';
}
