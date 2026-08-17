// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'स्टॉक';

  @override
  String get statistics => 'विश्लेषण';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get readNfcChip => 'NFC चिप पढ़ें';

  @override
  String get scanHistory => 'इतिहास';

  @override
  String get writeNfcChip => 'NFC चिप लिखें';

  @override
  String get nfcNotAvailable => 'NFC उपलब्ध नहीं है';

  @override
  String get nfcNotAvailableDesc =>
      'आपका डिवाइस NFC का समर्थन नहीं करता या यह अक्षम है।';

  @override
  String get nfcNotSupported => 'इस डिवाइस पर NFC समर्थित नहीं है';

  @override
  String get approachNfcChip => 'NFC चिप के पास लाएं...';

  @override
  String get scanningNfc => 'स्कैन कर रहे हैं...';

  @override
  String get nfcDataRead => 'NFC डेटा सफलतापूर्वक पढ़ा गया!';

  @override
  String get errorReadingNfc => 'NFC पढ़ने में त्रुटि';

  @override
  String get scanHistoryTitle => 'स्कैन इतिहास';

  @override
  String get noScansRecorded => 'कोई स्कैन रिकॉर्ड नहीं किया गया';

  @override
  String get scansWillAppearHere =>
      'NFC स्कैन स्वचालित रूप से यहां दिखाई देंगे';

  @override
  String get clearAll => 'सभी साफ़ करें';

  @override
  String get deleteThisScan => 'इस स्कैन को हटाएं?';

  @override
  String get actionIrreversible => 'यह क्रिया अपरिवर्तनीय है।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get clearAllHistory => 'सभी इतिहास साफ़ करें?';

  @override
  String get allScansWillBeDeleted =>
      'सभी स्कैन हटा दिए जाएंगे। यह क्रिया अपरिवर्तनीय है।';

  @override
  String get scanDeleted => 'स्कैन हटाया गया';

  @override
  String get scanDetails => 'स्कैन विवरण';

  @override
  String scannedOn(Object date) {
    return '$date को स्कैन किया गया';
  }

  @override
  String get bobbinInformation => 'बॉबिन जानकारी';

  @override
  String get filamentType => 'फिलामेंट प्रकार';

  @override
  String get color => 'रंग';

  @override
  String get weight => 'वजन';

  @override
  String get manufacturingDate => 'निर्माण तिथि';

  @override
  String get batchNumber => 'बैच नंबर';

  @override
  String get printerSettings => 'प्रिंटर सेटिंग्स';

  @override
  String get scanMetadata => 'स्कैन मेटाडेटा';

  @override
  String get scanId => 'स्कैन आईडी';

  @override
  String get dateAndTime => 'तिथि और समय';

  @override
  String get reuseThisData => 'इस डेटा का पुन: उपयोग करें';

  @override
  String get writeToNfc => 'NFC में लिखें';

  @override
  String get writeDataToChip => 'चिप में डेटा लिखें';

  @override
  String get writeSuccess => 'लेखन सफल!';

  @override
  String get writeError => 'लेखन त्रुटि';

  @override
  String get brand => 'ब्रांड';

  @override
  String get selectBrand => 'ब्रांड चुनें';

  @override
  String get materialType => 'सामग्री प्रकार';

  @override
  String get selectMaterial => 'सामग्री चुनें';

  @override
  String get serialNumber => 'सीरियल नंबर';

  @override
  String get serialNumberHint => 'उदा.: 001';

  @override
  String get initialWeight => 'प्रारंभिक वजन';

  @override
  String get initialWeightHint => 'उदा.: 1000';

  @override
  String get extruderTempMin => 'न्यूनतम एक्सट्रूडर तापमान';

  @override
  String get extruderTempMax => 'अधिकतम एक्सट्रूडर तापमान';

  @override
  String get bedTempMin => 'न्यूनतम बेड तापमान';

  @override
  String get bedTempMax => 'अधिकतम बेड तापमान';

  @override
  String get diameter => 'फिलामेंट व्यास';

  @override
  String get spoolLength => 'स्पूल लंबाई';

  @override
  String get generatedSku => 'उत्पन्न SKU';

  @override
  String get approachChipToWrite => 'लिखने के लिए चिप के पास लाएं...';

  @override
  String get writing => 'लिख रहे हैं...';

  @override
  String get chooseColor => 'रंग चुनें';

  @override
  String get required => 'आवश्यक';

  @override
  String get invalid => 'अमान्य';

  @override
  String get advancedSettings => 'उन्नत सेटिंग्स';

  @override
  String get opacity => 'अस्पष्टता';

  @override
  String get validate => 'मान्य करें';

  @override
  String get nfcTagInfo =>
      'अपने स्वयं के Anycubic टैग बनाने के लिए खाली ISO14443A NFC टैग (NTAG213) का उपयोग करें।';

  @override
  String get stockInventory => 'स्टॉक में स्पूल';

  @override
  String get addSpool => 'स्पूल जोड़ें';

  @override
  String get scanSpool => 'स्पूल स्कैन करें';

  @override
  String get addManually => 'मैन्युअल रूप से जोड़ें';

  @override
  String get spoolAdded => 'स्पूल जोड़ा गया';

  @override
  String get spoolUpdated => 'स्पूल अपडेट किया गया';

  @override
  String get noSpoolsInStock => 'स्टॉक में कोई स्पूल नहीं';

  @override
  String get addFirstSpool =>
      'अपनी सूची को ट्रैक करना शुरू करने के लिए अपना पहला स्पूल जोड़ें';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count स्पूल कम स्टॉक में (< $threshold%)';
  }

  @override
  String get edit => 'संपादित करें';

  @override
  String get bobbinPrice => 'बॉबिन कीमत';

  @override
  String get price => 'कीमत';

  @override
  String get priceHint => 'उदा.: 25.00';

  @override
  String get save => 'सहेजें';

  @override
  String get spoolDetails => 'स्पूल विवरण';

  @override
  String get deleteThisSpool => 'इस स्पूल को हटाएं?';

  @override
  String get cannotBeUndone => 'इस क्रिया को पूर्ववत नहीं किया जा सकता।';

  @override
  String get addSpoolManually => 'स्पूल मैन्युअल रूप से जोड़ें';

  @override
  String get editSpool => 'स्पूल संपादित करें';

  @override
  String get customBrand => 'कस्टम ब्रांड';

  @override
  String get customBrandHint => 'उदा.: मेरा ब्रांड';

  @override
  String get chooseFromList => 'सूची से चुनें';

  @override
  String get addBrand => '+ ब्रांड जोड़ें';

  @override
  String get customMaterial => 'कस्टम सामग्री';

  @override
  String get customMaterialHint => 'उदा.: मेरी सामग्री';

  @override
  String get addMaterial => '+ सामग्री जोड़ें';

  @override
  String get colorHint => 'उदा.: नीला, लाल...';

  @override
  String get enterColor => 'कृपया रंग दर्ज करें';

  @override
  String get initialWeightG => 'प्रारंभिक वजन';

  @override
  String get remainingWeightG => 'शेष वजन';

  @override
  String get enterBrand => 'कृपया ब्रांड दर्ज करें';

  @override
  String get selectOrEnterBrand => 'कृपया ब्रांड चुनें या दर्ज करें';

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
  String get enterMaterial => 'कृपया सामग्री दर्ज करें';

  @override
  String get selectOrEnterMaterial => 'कृपया सामग्री चुनें या दर्ज करें';

  @override
  String get enterPrice => 'कृपया कीमत दर्ज करें';

  @override
  String get enterValidPrice => 'कृपया मान्य कीमत दर्ज करें';

  @override
  String get enterWeight => 'कृपया वजन दर्ज करें';

  @override
  String get enterValidWeight => 'कृपया मान्य वजन दर्ज करें';

  @override
  String get remainingCannotExceedTotal =>
      'शेष वजन कुल वजन से अधिक नहीं हो सकता';

  @override
  String get overview => 'अवलोकन';

  @override
  String get spoolsInStock => 'स्टॉक में स्पूल';

  @override
  String get totalValue => 'कुल मूल्य';

  @override
  String get lowStockSpools => 'कम स्टॉक';

  @override
  String get materialDistribution => 'सामग्री के अनुसार वितरण';

  @override
  String get brandDistribution => 'ब्रांड के अनुसार वितरण';

  @override
  String get noData => 'कोई डेटा नहीं';

  @override
  String get refresh => 'ताज़ा करें';

  @override
  String get profileSettings => 'प्रोफाइल सेटिंग्स';

  @override
  String get preferences => 'वरीयताएँ';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

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
  String get currency => 'मुद्रा';

  @override
  String get selectCurrency => 'मुद्रा चुनें';

  @override
  String get units => 'इकाइयाँ';

  @override
  String get selectUnits => 'इकाइयाँ चुनें';

  @override
  String get metric => 'मीट्रिक (मिमी, ग्रा, °C)';

  @override
  String get imperial => 'इम्पीरियल (इंच, औंस, °F)';

  @override
  String get lowStockThreshold => 'कम स्टॉक चेतावनी सीमा';

  @override
  String get lowStockThresholdDesc =>
      'एक स्पूल को कम स्टॉक माना जाएगा यदि शेष वजन इस प्रतिशत से कम है';

  @override
  String get authentication => 'प्रमाणीकरण';

  @override
  String get signInWithGoogle => 'Google से साइन इन करें';

  @override
  String get signInWithApple => 'Apple से साइन इन करें';

  @override
  String get continueWithApple => 'Apple के साथ जारी रखें';

  @override
  String get continueWithGoogle => 'Google के साथ जारी रखें';

  @override
  String get comingSoon => 'जल्द आ रहा है';

  @override
  String get about => 'के बारे में';

  @override
  String get version => 'संस्करण';

  @override
  String get madeWith => 'Anycubic 3D प्रिंटर के लिए ❤️ से बनाया गया';

  @override
  String get scanBobbinDirectly => 'बॉबिन स्कैन करें';

  @override
  String get nfcEncoder => 'NFC एनकोडर';

  @override
  String get length => 'लंबाई';

  @override
  String get tempExtruder => 'एक्सट्रूडर तापमान';

  @override
  String get tempBed => 'बेड तापमान';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get legal => 'कानूनी';

  @override
  String get back => 'पीछे';

  @override
  String get retry => 'पुन: प्रयास करें';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get extruderTempMinHint => 'उदा.: 200';

  @override
  String get extruderTempMaxHint => 'उदा.: 220';

  @override
  String get bedTempMinHint => 'उदा.: 50';

  @override
  String get bedTempMaxHint => 'उदा.: 60';

  @override
  String get diameterHint => 'उदा.: 1.75';

  @override
  String get spoolLengthHint => 'उदा.: 330';

  @override
  String get tabGrid => 'ग्रिड';

  @override
  String get tabSpectrum => 'स्पेक्ट्रम';

  @override
  String get tabSliders => 'स्लाइडर';

  @override
  String get hexCode => 'हेक्स कोड';

  @override
  String get red => 'लाल';

  @override
  String get green => 'हरा';

  @override
  String get blue => 'नीला';

  @override
  String get black => 'काला';

  @override
  String get white => 'सफ़ेद';

  @override
  String get yellow => 'पीला';

  @override
  String get orange => 'नारंगी';

  @override
  String get pink => 'गुलाबी';

  @override
  String get purple => 'बैंगनी';

  @override
  String get gray => 'स्लेटी';

  @override
  String get brown => 'भूरा';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get metricUnits => 'मीट्रिक (मिमी, ग्रा, °C)';

  @override
  String get imperialUnits => 'इम्पीरियल (इंच, औंस, °F)';

  @override
  String get chf => 'स्विस फ्रैंक (CHF)';

  @override
  String get eur => 'यूरो (€)';

  @override
  String get usd => 'अमेरिकी डॉलर (\$)';

  @override
  String get gbp => 'पाउंड स्टर्लिंग (£)';

  @override
  String get cad => 'कैनेडियन डॉलर (CAD)';

  @override
  String get aud => 'ऑस्ट्रेलियाई डॉलर (A\$)';

  @override
  String get jpy => 'जापानी येन (¥)';

  @override
  String get cny => 'चीनी युआन (¥)';

  @override
  String get inr => 'भारतीय रुपया (₹)';

  @override
  String get brl => 'ब्राज़ीलियाई रियाल (R\$)';

  @override
  String get mxn => 'मैक्सिकन पेसो (MX\$)';

  @override
  String get sek => 'स्वीडिश क्रोना (kr)';

  @override
  String get nok => 'नॉर्वेजियन क्रोन (kr)';

  @override
  String get dkk => 'डेनिश क्रोन (kr)';

  @override
  String get pln => 'पोलिश ज़्लॉटी (zł)';

  @override
  String get czk => 'चेक कोरुना (Kč)';

  @override
  String get nzd => 'न्यूज़ीलैंड डॉलर (NZ\$)';

  @override
  String get filamentsToOrder => 'ऑर्डर करने के लिए फिलामेंट';

  @override
  String get shoppingList => 'शॉपिंग सूची';

  @override
  String get addToShoppingList => 'सूची में जोड़ें';

  @override
  String get noLowStockFilaments => 'कोई कम स्टॉक फिलामेंट नहीं';

  @override
  String get vipSubscriptionDescription =>
      'यह सदस्यता केवल ऐप में विज्ञापनों को अक्षम करने और परियोजना का समर्थन करने के लिए उपयोग की जाती है। कोई अन्य सुविधाएं नहीं।';

  @override
  String get monthlySubscription => 'मासिक सदस्यता';

  @override
  String get yearlySubscription => 'वार्षिक सदस्यता';

  @override
  String get perMonth => '/ महीना';

  @override
  String get perYear => '/ वर्ष';

  @override
  String onlyPerMonth(String price) {
    return 'केवल $price / महीना';
  }

  @override
  String get subscribe => 'सदस्यता लें';

  @override
  String get bestOffer => '✨ सर्वोत्तम ऑफर ✨';

  @override
  String get forAnycubicAce => 'Anycubic Ace के लिए';

  @override
  String get forBambuLabAms => 'Bambu Lab AMS के लिए';

  @override
  String get scanNfcChip => 'NFC चिप स्कैन करें';

  @override
  String get fillForm => 'फॉर्म भरें';

  @override
  String get emptyShoppingList => 'सूची में कोई फिलामेंट नहीं';

  @override
  String percentRemaining(String percent) {
    return '$percent% शेष';
  }

  @override
  String get markAsOrdered => 'ऑर्डर किए गए के रूप में चिह्नित करें';

  @override
  String get markAsNotOrdered => 'ऑर्डर नहीं किए गए के रूप में चिह्नित करें';

  @override
  String get notSignedIn => 'साइन इन नहीं किया गया';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get connection => 'कनेक्शन';

  @override
  String get signInToSync => 'अपने डेटा को सिंक करने के लिए साइन इन करें';

  @override
  String get continueWithoutAccount => 'खाते के बिना जारी रखें (स्थानीय मोड)';

  @override
  String get privacyNotice =>
      'साइन इन करके आप हमारी\nसेवा की शर्तें और गोपनीयता नीति स्वीकार करते हैं';

  @override
  String get updateStock => 'स्टॉक अपडेट करें';

  @override
  String get scanToUpdateStock => 'अपडेट करने के लिए स्कैन करें';

  @override
  String get weightUsed => 'उपयोग किया गया वजन';

  @override
  String get lengthUsed => 'उपयोग की गई लंबाई';

  @override
  String get enterWeightOrLength => 'उपयोग किया गया वजन या लंबाई दर्ज करें';

  @override
  String get weightUsedG => 'उपयोग किया गया वजन (g)';

  @override
  String get lengthUsedM => 'उपयोग की गई लंबाई (m)';

  @override
  String get stockUpdated => 'स्टॉक अपडेट किया गया';

  @override
  String get scanSpoolToUpdate => 'स्टॉक अपडेट करने के लिए स्पूल स्कैन करें';

  @override
  String get spoolNotFound => 'स्टॉक में स्पूल नहीं मिला';

  @override
  String get addSpoolFirstMessage =>
      'यह स्पूल अभी तक आपके स्टॉक में नहीं है। कृपया स्टॉक अपडेट करने से पहले \'स्पूल जोड़ें\' बटन का उपयोग करके इसे पहले जोड़ें।';

  @override
  String get ok => 'ठीक है';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: केवल पढ़ें';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab टैग RSA एन्क्रिप्शन का उपयोग करते हैं और संशोधित नहीं किए जा सकते। केवल पढ़ें।';

  @override
  String get forPrusaMk4 => 'Prusa MK4/XL के लिए (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: पढ़ें और लिखें';

  @override
  String get prusaReadWriteDesc =>
      'Prusa टैग ISO 15693 (NFC-V) OpenPrintTag प्रारूप का उपयोग करते हैं। पढ़ने और लिखने दोनों समर्थित।';

  @override
  String get bambuCloneLibrary => 'Bambu Lab क्लोन लाइब्रेरी';

  @override
  String get noBambuClones => 'कोई Bambu Lab क्लोन नहीं';

  @override
  String get scanBambuToClone =>
      'अपनी क्लोन लाइब्रेरी बनाने के लिए Bambu Lab मूल टैग स्कैन करें';

  @override
  String get scanTag => 'टैग स्कैन करें';

  @override
  String get syncWithCloud => 'क्लाउड के साथ सिंक करें';

  @override
  String get syncCompleted => 'सिंक पूर्ण';

  @override
  String get deleteClone => 'क्लोन हटाएं';

  @override
  String get renameClone => 'क्लोन का नाम बदलें';

  @override
  String get rename => 'नाम बदलें';

  @override
  String get customName => 'कस्टम नाम';

  @override
  String get clonedOn => 'क्लोन किया गया';

  @override
  String get writeThisClone => 'इस क्लोन को लिखें';

  @override
  String get writeClone => 'क्लोन लिखें';

  @override
  String get writeOnCUID => 'CUID कार्ड पर लिखें';

  @override
  String get cloneWrittenSuccess => 'क्लोन सफलतापूर्वक लिखा गया!';

  @override
  String get requiredTagFormat => 'आवश्यक टैग प्रारूप';

  @override
  String get type => 'प्रकार';

  @override
  String get frequency => 'आवृत्ति';

  @override
  String get protocol => 'प्रोटोकॉल';

  @override
  String get capacity => 'क्षमता';

  @override
  String get feature => 'सुविधा';

  @override
  String get uidModifiable => 'ब्लॉक 0 (UID) संशोधनीय';

  @override
  String get whereToBuy =>
      'AliExpress, Amazon या eBay पर \"CUID MiFare Classic 1K\" खोजें (~\$0.50/पीस)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 कार्ड - लिखने योग्य Block 0 (UID) के साथ MiFare Classic 1K';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'AliExpress, Amazon या eBay पर \"Magic Gen2 MiFare Classic 1K\" या \"UID writable\" खोजें (~\$0.50/प्रति)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ चेतावनी: iPhone NFC से लिखना सभी Magic Gen2 कार्ड पर काम नहीं कर सकता है। अधिकतम विश्वसनीयता के लिए Proxmark3 डिवाइस की सिफारिश की जाती है।';

  @override
  String get step1GetMagicGen2 =>
      'एक खाली Magic Gen2 कार्ड प्राप्त करें (लिखने योग्य UID के साथ MiFare Classic 1K)';

  @override
  String get instructions => 'निर्देश';

  @override
  String get step1GetCUID =>
      'एक खाली CUID कार्ड प्राप्त करें (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'नीचे \"लिखें\" बटन दबाएं';

  @override
  String get step3HoldPhone => 'अपने फोन को CUID कार्ड के पास रखें';

  @override
  String get step4WaitConfirm => 'लेखन पुष्टि की प्रतीक्षा करें';

  @override
  String get step5TestClone =>
      'अपने Bambu Lab प्रिंटर पर क्लोन किए गए टैग का परीक्षण करें!';

  @override
  String get rsaIncluded =>
      'क्लोन में मूल RSA हस्ताक्षर शामिल है, इसे प्रिंटर द्वारा स्वीकार किया जाएगा!';

  @override
  String get cloneDeleted => 'क्लोन हटा दिया गया';

  @override
  String get deleteAccount => 'मेरा खाता हटाएं';

  @override
  String get deleteAccountConfirmation =>
      'यह क्रिया अपरिवर्तनीय है। आपका खाता और सभी डेटा 30 दिनों के भीतर हटा दिया जाएगा।';

  @override
  String get accountDeletionRequested => 'हटाने का अनुरोध दर्ज किया गया';

  @override
  String get clearShoppingList => 'सूची साफ़ करें';

  @override
  String get clearShoppingListConfirmation =>
      'क्या आप वाकई पूरी खरीदारी सूची साफ़ करना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'इतिहास';

  @override
  String get retryButton => 'पुनः प्रयास करें';

  @override
  String get readSuccessMessage => 'पढ़ना सफल!';

  @override
  String get filamentTypeLabel => 'फिलामेंट प्रकार';

  @override
  String get scanNfcChipButton => 'NFC चिप स्कैन करें';

  @override
  String deleteCloneConfirmation(String name) {
    return 'क्लोन \"$name\" हटाएं?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'क्लोन \"$name\" हटाया गया';
  }

  @override
  String get extruderLabel => 'एक्सट्रूडर';

  @override
  String get writeThisCloneButton => 'यह क्लोन लिखें';

  @override
  String get customNameHint => 'कस्टम नाम';

  @override
  String get cloneWriteSuccessMessage => 'क्लोन सफलतापूर्वक लिखा गया!';

  @override
  String errorPrefix(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get writingInProgress => 'लिख रहा है...';

  @override
  String get writeOnCUIDButton => 'CUID कार्ड पर लिखें';

  @override
  String get diameterLabel => 'व्यास';

  @override
  String get extruderTempLabel => 'एक्सट्रूडर तापमान';

  @override
  String get bedTempLabel => 'बेड तापमान';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K बाइट्स (1024 बाइट्स)';

  @override
  String get rsaSignatureNote =>
      'क्लोन में मूल RSA हस्ताक्षर शामिल है, प्रिंटर इसे स्वीकार करेगा!';

  @override
  String get writeBambuLabTagTitle => 'Bambu Lab टैग लिखें';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab टैग सफलतापूर्वक लिखा गया!';

  @override
  String get approachNfcTagMessage => 'NFC टैग पास लाएं...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab प्रारूप (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab प्रारूप';

  @override
  String get bambuLabFormatInfo =>
      'यह प्रारूप Bambu Lab सामग्री कोड का उपयोग करता है और AMS-संगत प्रारूप में डेटा संग्रहीत करता है।';

  @override
  String get brandLabel => 'ब्रांड';

  @override
  String get materialTypeLabel => 'सामग्री प्रकार';

  @override
  String get serialNumber3Digits => 'सीरियल नंबर (3 अंक)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (मानक)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Bambu Lab टैग लिखें';

  @override
  String get bambuLabRsaNote =>
      'नोट: मूल Bambu Lab टैग RSA एन्क्रिप्शन का उपयोग करते हैं। यह मोड सरलीकृत संगत प्रारूप में डेटा लिखता है।';

  @override
  String signInError(String error) {
    return 'साइन इन त्रुटि: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'सदस्यता सफलतापूर्वक सक्रिय!';

  @override
  String get subscriptionFailedMessage => 'सदस्यता विफल';

  @override
  String errorMessage(String error) {
    return 'त्रुटि: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'सदस्यता सफलतापूर्वक पुनर्स्थापित!';

  @override
  String get noSubscriptionFoundMessage => 'कोई सदस्यता नहीं मिली';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'सक्रिय';

  @override
  String get noAdsExperienceMessage => 'विज्ञापन-मुक्त अनुभव का आनंद लें!';

  @override
  String get subscribedLabel => 'सदस्य';

  @override
  String get restorePurchasesButton => 'खरीदारी पुनर्स्थापित करें';

  @override
  String get cannotExceedRemainingWeight => 'शेष वजन से अधिक नहीं हो सकता';

  @override
  String get pleaseEnterLength => 'कृपया लंबाई दर्ज करें';

  @override
  String get pleaseEnterValidLength => 'कृपया वैध लंबाई दर्ज करें';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'स्पूल लंबाई सेट नहीं - परिवर्तित नहीं कर सकते';

  @override
  String get exceedsRemainingWeight => 'शेष वजन से अधिक';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament =>
      'इस फिलामेंट की पहचान करने में हमारी मदद करें';

  @override
  String get helpUsImprove => 'हमें बेहतर बनाने में मदद करें!';

  @override
  String get helpIdentifyDescription =>
      'हमने टैग पढ़ा लेकिन इसे पहचान नहीं पाए। हमें बताएं कि यह कौन सा फिलामेंट है ताकि हम ऐप को बेहतर बना सकें।';

  @override
  String get otherBrand => 'अन्य';

  @override
  String get thankYouFeedback => 'आपकी प्रतिक्रिया के लिए धन्यवाद!';

  @override
  String get send => 'भेजें';

  @override
  String get optionalDetails => 'वैकल्पिक विवरण';

  @override
  String get weightGrams => 'वज़न (ग्रा)';

  @override
  String get diameterMm => 'व्यास (मिमी)';

  @override
  String get spoolLengthM => 'स्पूल लंबाई (मी)';

  @override
  String get batchNumberLabel => 'बैच / SKU';

  @override
  String get contactUs => 'हमसे संपर्क करें';

  @override
  String get contactUsSubtitle => 'प्रश्न, सुझाव या समस्याएँ';

  @override
  String get nfcTagNotDetected => 'कोई NFC टैग नहीं मिला';

  @override
  String get nfcTagNotDetectedDesc =>
      'कोई टैग नहीं मिला। टैग खराब, क्षतिग्रस्त या फोन से बहुत दूर हो सकता है।';

  @override
  String get nfcTagIncompatible => 'असंगत NFC टैग मिला';

  @override
  String get nfcAuthError => 'NFC टैग प्रमाणीकरण विफल';

  @override
  String get nfcAuthErrorDesc =>
      'टैग का पता चला लेकिन कई प्रयासों के बाद प्रमाणीकरण विफल रहा। टैग को फ़ोन के पीछे मजबूती से दबाकर रखें और पुनः प्रयास करें।';

  @override
  String get nfcTagInfoPrusa =>
      'OpenPrintTag संगत टैग बनाने के लिए Prusa MK4/XL के लिए एक खाली NXP ICODE SLIX2 टैग (ISO 15693) का उपयोग करें।';

  @override
  String get writePrusaTagTitle => 'Prusa OpenPrintTag लिखें';

  @override
  String get signInAppleNotAvailable =>
      'इस डिवाइस पर Apple से साइन इन उपलब्ध नहीं है।';

  @override
  String get signInAppleFailed =>
      'Apple से साइन इन विफल रहा। कृपया पुनः प्रयास करें।';

  @override
  String get signInFailed => 'साइन इन विफल रहा। कृपया पुनः प्रयास करें।';

  @override
  String get mustContain3Digits => '3 अंक होने चाहिए';

  @override
  String get mustBeNumber => 'एक संख्या होनी चाहिए';

  @override
  String generatedUidLabel(String uid) {
    return 'जनरेट किया गया UID: $uid';
  }

  @override
  String get experimentalBadge => 'प्रायोगिक';

  @override
  String get newBadge => 'नया';

  @override
  String get forCrealityCfs => 'Creality CFS के लिए';

  @override
  String get crealityReadWrite => 'Creality: पढ़ें और लिखें';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS टैग AES-128-ECB एन्क्रिप्शन के साथ MiFare Classic 1K का उपयोग करते हैं। पढ़ना और लिखना केवल Android पर समर्थित है।';

  @override
  String get platformLimitationTitle => 'प्लेटफ़ॉर्म सीमा';

  @override
  String get mifareClassicNotSupportedIos =>
      'Apple CoreNFC की सीमा के कारण iOS पर MiFare Classic टैग (Bambu Lab, Creality) समर्थित नहीं हैं। यह सुविधा केवल Android पर उपलब्ध है।';

  @override
  String get nfcTagInfoCreality =>
      'Creality K2 Plus के लिए Creality CFS संगत डेटा लिखने के लिए MiFare Classic 1K टैग का उपयोग करें।';

  @override
  String get colorHintExamples => 'लाल, नीला, काला...';

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
    return 'टैग $mode के रूप में पहचाना गया — अगले स्कैन के लिए टैब बदलें';
  }

  @override
  String get fallbackChooseMode => 'मोड मैन्युअल रूप से चुनें';

  @override
  String get fallbackChooseModeSubtitle =>
      'स्वचालित पहचान इस टैग को पहचान नहीं सकी। प्रोटोकॉल चुनें:';

  @override
  String get tryAutoDetect => 'ऑटो-डिटेक्ट आज़माएं';

  @override
  String get autoDetectAllBrands => 'ऑटो-डिटेक्ट — सभी ब्रांड';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D और अधिक';

  @override
  String get nfcTipIos =>
      'NFC रीडर आपके iPhone के शीर्ष पर है। इसे सीधे स्पूल के NFC टैग पर रखें।';

  @override
  String get nfcTipAndroid =>
      'NFC रीडर आमतौर पर आपके फोन के पीछे केंद्र में होता है। फोन के पिछले हिस्से को स्पूल के NFC टैग पर रखें।';
}
