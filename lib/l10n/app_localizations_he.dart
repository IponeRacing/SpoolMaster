// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'מלאי';

  @override
  String get statistics => 'ניתוח נתונים';

  @override
  String get profile => 'פרופיל';

  @override
  String get readNfcChip => 'קריאת שבב NFC';

  @override
  String get scanHistory => 'היסטוריה';

  @override
  String get writeNfcChip => 'כתיבת שבב NFC';

  @override
  String get nfcNotAvailable => 'NFC לא זמין';

  @override
  String get nfcNotAvailableDesc => 'המכשיר שלך אינו תומך ב-NFC או שהוא מושבת.';

  @override
  String get nfcNotSupported => 'NFC אינו נתמך במכשיר זה';

  @override
  String get approachNfcChip => 'קרב שבב NFC...';

  @override
  String get scanningNfc => 'סורק...';

  @override
  String get nfcDataRead => 'נתוני NFC נקראו בהצלחה!';

  @override
  String get errorReadingNfc => 'שגיאה בקריאת NFC';

  @override
  String get scanHistoryTitle => 'היסטוריית סריקה';

  @override
  String get noScansRecorded => 'אין סריקות מתועדות';

  @override
  String get scansWillAppearHere => 'סריקות NFC יופיעו כאן באופן אוטומטי';

  @override
  String get clearAll => 'נקה הכל';

  @override
  String get deleteThisScan => 'למחוק סריקה זו?';

  @override
  String get actionIrreversible => 'פעולה זו בלתי הפיכה.';

  @override
  String get cancel => 'ביטול';

  @override
  String get delete => 'מחק';

  @override
  String get clearAllHistory => 'למחוק את כל ההיסטוריה?';

  @override
  String get allScansWillBeDeleted => 'כל הסריקות יימחקו. פעולה זו בלתי הפיכה.';

  @override
  String get scanDeleted => 'הסריקה נמחקה';

  @override
  String get scanDetails => 'פרטי סריקה';

  @override
  String scannedOn(Object date) {
    return 'נסרק ב-$date';
  }

  @override
  String get bobbinInformation => 'מידע על סליל';

  @override
  String get filamentType => 'סוג חוט';

  @override
  String get color => 'צבע';

  @override
  String get weight => 'משקל';

  @override
  String get manufacturingDate => 'תאריך ייצור';

  @override
  String get batchNumber => 'מספר אצווה';

  @override
  String get printerSettings => 'הגדרות מדפסת';

  @override
  String get scanMetadata => 'מטא-נתוני סריקה';

  @override
  String get scanId => 'מזהה סריקה';

  @override
  String get dateAndTime => 'תאריך ושעה';

  @override
  String get reuseThisData => 'השתמש מחדש בנתונים אלה';

  @override
  String get writeToNfc => 'כתוב ל-NFC';

  @override
  String get writeDataToChip => 'כתוב נתונים לשבב';

  @override
  String get writeSuccess => 'הכתיבה הצליחה!';

  @override
  String get writeError => 'שגיאת כתיבה';

  @override
  String get brand => 'מותג';

  @override
  String get selectBrand => 'בחר מותג';

  @override
  String get materialType => 'סוג חומר';

  @override
  String get selectMaterial => 'בחר חומר';

  @override
  String get serialNumber => 'מספר סידורי';

  @override
  String get serialNumberHint => 'לדוגמה: 001';

  @override
  String get initialWeight => 'משקל התחלתי';

  @override
  String get initialWeightHint => 'לדוגמה: 1000';

  @override
  String get extruderTempMin => 'טמפ\' מינימלית מכבש';

  @override
  String get extruderTempMax => 'טמפ\' מקסימלית מכבש';

  @override
  String get bedTempMin => 'טמפ\' מינימלית משטח';

  @override
  String get bedTempMax => 'טמפ\' מקסימלית משטח';

  @override
  String get diameter => 'קוטר חוט';

  @override
  String get spoolLength => 'אורך סליל';

  @override
  String get generatedSku => 'SKU שנוצר';

  @override
  String get approachChipToWrite => 'קרב שבב לכתיבה...';

  @override
  String get writing => 'כותב...';

  @override
  String get chooseColor => 'בחר צבע';

  @override
  String get required => 'נדרש';

  @override
  String get invalid => 'לא חוקי';

  @override
  String get advancedSettings => 'הגדרות מתקדמות';

  @override
  String get opacity => 'אטימות';

  @override
  String get validate => 'אמת';

  @override
  String get nfcTagInfo =>
      'השתמש בתג NFC ריק ISO14443A (NTAG213) כדי ליצור תגי Anycubic משלך.';

  @override
  String get stockInventory => 'סלילים במלאי';

  @override
  String get addSpool => 'הוסף סליל';

  @override
  String get scanSpool => 'סרוק סליל';

  @override
  String get addManually => 'הוסף ידנית';

  @override
  String get spoolAdded => 'הסליל נוסף';

  @override
  String get spoolUpdated => 'הסליל עודכן';

  @override
  String get noSpoolsInStock => 'אין סלילים במלאי';

  @override
  String get addFirstSpool =>
      'הוסף את הסליל הראשון שלך כדי להתחיל לעקוב אחר המלאי שלך';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count סליל(ים) במלאי נמוך (< $threshold%)';
  }

  @override
  String get edit => 'ערוך';

  @override
  String get bobbinPrice => 'מחיר סליל';

  @override
  String get price => 'מחיר';

  @override
  String get priceHint => 'לדוגמה: 25.00';

  @override
  String get save => 'שמור';

  @override
  String get spoolDetails => 'פרטי סליל';

  @override
  String get deleteThisSpool => 'למחוק סליל זה?';

  @override
  String get cannotBeUndone => 'לא ניתן לבטל פעולה זו.';

  @override
  String get addSpoolManually => 'הוסף סליל ידנית';

  @override
  String get editSpool => 'ערוך סליל';

  @override
  String get customBrand => 'מותג מותאם אישית';

  @override
  String get customBrandHint => 'לדוגמה: המותג שלי';

  @override
  String get chooseFromList => 'בחר מהרשימה';

  @override
  String get addBrand => '+ הוסף מותג';

  @override
  String get customMaterial => 'חומר מותאם אישית';

  @override
  String get customMaterialHint => 'לדוגמה: החומר שלי';

  @override
  String get addMaterial => '+ הוסף חומר';

  @override
  String get colorHint => 'לדוגמה: כחול, אדום...';

  @override
  String get enterColor => 'אנא הזן צבע';

  @override
  String get initialWeightG => 'משקל התחלתי';

  @override
  String get remainingWeightG => 'משקל נותר';

  @override
  String get enterBrand => 'אנא הזן מותג';

  @override
  String get selectOrEnterBrand => 'אנא בחר או הזן מותג';

  @override
  String get enterMaterial => 'אנא הזן חומר';

  @override
  String get selectOrEnterMaterial => 'אנא בחר או הזן חומר';

  @override
  String get enterPrice => 'אנא הזן מחיר';

  @override
  String get enterValidPrice => 'אנא הזן מחיר חוקי';

  @override
  String get enterWeight => 'אנא הזן משקל';

  @override
  String get enterValidWeight => 'אנא הזן משקל חוקי';

  @override
  String get remainingCannotExceedTotal =>
      'המשקל הנותר לא יכול לעלות על המשקל הכולל';

  @override
  String get overview => 'סקירה כללית';

  @override
  String get spoolsInStock => 'סלילים במלאי';

  @override
  String get totalValue => 'ערך כולל';

  @override
  String get lowStockSpools => 'מלאי נמוך';

  @override
  String get materialDistribution => 'התפלגות לפי חומר';

  @override
  String get brandDistribution => 'התפלגות לפי מותג';

  @override
  String get noData => 'אין נתונים';

  @override
  String get refresh => 'רענן';

  @override
  String get profileSettings => 'הגדרות פרופיל';

  @override
  String get preferences => 'העדפות';

  @override
  String get language => 'שפה';

  @override
  String get selectLanguage => 'בחר שפה';

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
  String get currency => 'מטבע';

  @override
  String get selectCurrency => 'בחר מטבע';

  @override
  String get units => 'יחידות';

  @override
  String get selectUnits => 'בחר יחידות';

  @override
  String get metric => 'מטרי (מ\"מ, גרם, °C)';

  @override
  String get imperial => 'אימפריאלי (אינץ\', אונקיה, °F)';

  @override
  String get lowStockThreshold => 'סף התראת מלאי נמוך';

  @override
  String get lowStockThresholdDesc =>
      'סליל ייחשב במלאי נמוך אם המשקל הנותר נמוך מאחוז זה';

  @override
  String get authentication => 'אימות';

  @override
  String get signInWithGoogle => 'התחבר עם Google';

  @override
  String get signInWithApple => 'התחבר עם Apple';

  @override
  String get comingSoon => 'בקרוב';

  @override
  String get about => 'אודות';

  @override
  String get version => 'גרסה';

  @override
  String get madeWith => 'נוצר עם ❤️ למדפסות Anycubic 3D';

  @override
  String get scanBobbinDirectly => 'סרוק סליל';

  @override
  String get nfcEncoder => 'מקודד NFC';

  @override
  String get length => 'אורך';

  @override
  String get tempExtruder => 'טמפ\' מכבש';

  @override
  String get tempBed => 'טמפ\' משטח';

  @override
  String get termsOfService => 'תנאי שירות';

  @override
  String get privacyPolicy => 'מדיניות פרטיות';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'חזרה';

  @override
  String get retry => 'נסה שוב';

  @override
  String get signOut => 'התנתק';

  @override
  String get extruderTempMinHint => 'דוגמה: 200';

  @override
  String get extruderTempMaxHint => 'דוגמה: 220';

  @override
  String get bedTempMinHint => 'דוגמה: 50';

  @override
  String get bedTempMaxHint => 'דוגמה: 60';

  @override
  String get diameterHint => 'דוגמה: 1.75';

  @override
  String get spoolLengthHint => 'דוגמה: 330';

  @override
  String get tabGrid => 'רשת';

  @override
  String get tabSpectrum => 'ספקטרום';

  @override
  String get tabSliders => 'מחוונים';

  @override
  String get hexCode => 'קוד Hex';

  @override
  String get red => 'אדום';

  @override
  String get green => 'ירוק';

  @override
  String get blue => 'כחול';

  @override
  String get metricUnits => 'מטרי (מ\"מ, גרם, °C)';

  @override
  String get imperialUnits => 'אימפריאלי (אינץ\', אונקיה, °F)';

  @override
  String get chf => 'פרנק שוויצרי (CHF)';

  @override
  String get eur => 'יורו (€)';

  @override
  String get usd => 'דולר אמריקאי (\$)';

  @override
  String get gbp => 'לירה שטרלינג (£)';

  @override
  String get cad => 'דולר קנדי (CAD)';

  @override
  String get filamentsToOrder => 'חוטים להזמנה';

  @override
  String get shoppingList => 'רשימת קניות';

  @override
  String get addToShoppingList => 'הוסף לרשימה';

  @override
  String get noLowStockFilaments => 'אין חוטים במלאי נמוך';

  @override
  String get vipSubscriptionDescription =>
      'מינוי זה משמש רק להשבתת פרסומות באפליקציה ולתמיכה בפרויקט. אין תכונות אחרות.';

  @override
  String get monthlySubscription => 'מינוי חודשי';

  @override
  String get yearlySubscription => 'מינוי שנתי';

  @override
  String get perMonth => '/ חודש';

  @override
  String get perYear => '/ שנה';

  @override
  String onlyPerMonth(String price) {
    return 'רק $price / חודש';
  }

  @override
  String get subscribe => 'הירשם';

  @override
  String get bestOffer => '✨ ההצעה הטובה ביותר ✨';

  @override
  String get forAnycubicAce => 'עבור Anycubic Ace';

  @override
  String get forBambuLabAms => 'עבור Bambu Lab AMS';

  @override
  String get scanNfcChip => 'סרוק שבב NFC';

  @override
  String get fillForm => 'מלא את הטופס';

  @override
  String get emptyShoppingList => 'אין חוטים ברשימה';

  @override
  String percentRemaining(String percent) {
    return '$percent% נותר';
  }

  @override
  String get markAsOrdered => 'סמן כהוזמן';

  @override
  String get markAsNotOrdered => 'סמן כלא הוזמן';

  @override
  String get notSignedIn => 'לא מחובר';

  @override
  String get signIn => 'התחבר';

  @override
  String get connection => 'התחברות';

  @override
  String get signInToSync => 'התחבר כדי לסנכרן את הנתונים שלך';

  @override
  String get continueWithoutAccount => 'המשך ללא חשבון (מצב מקומי)';

  @override
  String get privacyNotice =>
      'על ידי התחברות, אתה מקבל את\nתנאי השירות ומדיניות הפרטיות שלנו';

  @override
  String get updateStock => 'עדכן מלאי';

  @override
  String get scanToUpdateStock => 'סרוק לעדכון';

  @override
  String get weightUsed => 'משקל בשימוש';

  @override
  String get lengthUsed => 'אורך בשימוש';

  @override
  String get enterWeightOrLength => 'הזן משקל או אורך בשימוש';

  @override
  String get weightUsedG => 'משקל בשימוש (גרם)';

  @override
  String get lengthUsedM => 'אורך בשימוש (מ\')';

  @override
  String get stockUpdated => 'המלאי עודכן';

  @override
  String get scanSpoolToUpdate => 'סרוק סליל לעדכון המלאי שלו';

  @override
  String get spoolNotFound => 'הסליל לא נמצא במלאי';

  @override
  String get addSpoolFirstMessage =>
      'סליל זה עדיין לא במלאי שלך. אנא הוסף אותו תחילה באמצעות כפתור \'הוסף סליל\' לפני עדכון המלאי שלו.';

  @override
  String get ok => 'אישור';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: קריאה בלבד';

  @override
  String get bambuLabReadOnlyDesc =>
      'תגי Bambu Lab משתמשים בהצפנת RSA ולא ניתן לשנותם. קריאה בלבד.';

  @override
  String get bambuCloneLibrary => 'ספריית שכפולי Bambu Lab';

  @override
  String get noBambuClones => 'אין שכפולי Bambu Lab';

  @override
  String get scanBambuToClone =>
      'סרוק תגי Bambu Lab מקוריים כדי ליצור את ספריית השכפולים שלך';

  @override
  String get scanTag => 'סרוק תג';

  @override
  String get syncWithCloud => 'סנכרן עם ענן';

  @override
  String get syncCompleted => 'הסנכרון הושלם';

  @override
  String get deleteClone => 'מחק שכפול';

  @override
  String get renameClone => 'שנה שם שכפול';

  @override
  String get rename => 'שנה שם';

  @override
  String get customName => 'שם מותאם אישית';

  @override
  String get clonedOn => 'שוכפל ב';

  @override
  String get writeThisClone => 'כתוב שכפול זה';

  @override
  String get writeClone => 'כתוב שכפול';

  @override
  String get writeOnCUID => 'כתוב על כרטיס CUID';

  @override
  String get cloneWrittenSuccess => 'השכפול נכתב בהצלחה!';

  @override
  String get requiredTagFormat => 'פורמט תג נדרש';

  @override
  String get type => 'סוג';

  @override
  String get frequency => 'תדר';

  @override
  String get protocol => 'פרוטוקול';

  @override
  String get capacity => 'קיבולת';

  @override
  String get feature => 'תכונה';

  @override
  String get uidModifiable => 'בלוק 0 (UID) ניתן לשינוי';

  @override
  String get whereToBuy =>
      'חפש \"CUID MiFare Classic 1K\" ב-AliExpress, Amazon או eBay (~\$0.50/יחידה)';

  @override
  String get magicGen2Required =>
      'כרטיס Magic Gen2 - MiFare Classic 1K עם Block 0 (UID) ניתן לכתיבה';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'חפש \"Magic Gen2 MiFare Classic 1K\" או \"UID writable\" ב-AliExpress, Amazon או eBay (~\$0.50/יחידה)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ אזהרה: כתיבה עם iPhone NFC עשויה לא לעבוד על כל כרטיסי Magic Gen2. מומלץ Android עם אפליקציית NFC Tools Pro או מכשיר Proxmark3 לאמינות.';

  @override
  String get step1GetMagicGen2 =>
      'השג כרטיס Magic Gen2 ריק (MiFare Classic 1K עם UID ניתן לכתיבה)';

  @override
  String get instructions => 'הוראות';

  @override
  String get step1GetCUID => 'השג כרטיס CUID ריק (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'לחץ על כפתור \"כתוב\" למטה';

  @override
  String get step3HoldPhone => 'החזק את ה-iPhone שלך ליד הכרטיס';

  @override
  String get step4WaitConfirm => 'המתן לאישור כתיבה';

  @override
  String get step5TestClone => 'בדוק את התג המשוכפל במדפסת Bambu Lab שלך!';

  @override
  String get rsaIncluded =>
      'השכפול כולל את חתימת RSA המקורית, המדפסת תקבל אותו!';

  @override
  String get cloneDeleted => 'השכפול נמחק';
}
