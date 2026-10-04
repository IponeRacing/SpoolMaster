// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'المخزون';

  @override
  String get statistics => 'التحليلات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get readNfcChip => 'قراءة شريحة NFC';

  @override
  String get scanHistory => 'السجل';

  @override
  String get writeNfcChip => 'كتابة شريحة NFC';

  @override
  String get nfcNotAvailable => 'NFC غير متوفر';

  @override
  String get nfcNotAvailableDesc => 'جهازك لا يدعم NFC أو أنه معطل.';

  @override
  String get nfcNotSupported => 'NFC غير مدعوم على هذا الجهاز';

  @override
  String get approachNfcChip => 'اقترب من شريحة NFC...';

  @override
  String get scanningNfc => 'المسح الضوئي...';

  @override
  String get nfcDataRead => 'تمت قراءة بيانات NFC بنجاح!';

  @override
  String get errorReadingNfc => 'خطأ في قراءة NFC';

  @override
  String get scanHistoryTitle => 'سجل المسح الضوئي';

  @override
  String get noScansRecorded => 'لا توجد عمليات مسح مسجلة';

  @override
  String get scansWillAppearHere => 'ستظهر عمليات مسح NFC هنا تلقائيًا';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get deleteThisScan => 'حذف هذا المسح؟';

  @override
  String get actionIrreversible => 'هذا الإجراء لا رجعة فيه.';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get clearAllHistory => 'مسح كل السجل؟';

  @override
  String get allScansWillBeDeleted =>
      'سيتم حذف جميع عمليات المسح. هذا الإجراء لا رجعة فيه.';

  @override
  String get scanDeleted => 'تم حذف المسح';

  @override
  String get scanDetails => 'تفاصيل المسح';

  @override
  String scannedOn(Object date) {
    return 'تم المسح في $date';
  }

  @override
  String get bobbinInformation => 'معلومات البكرة';

  @override
  String get filamentType => 'نوع الخيط';

  @override
  String get color => 'اللون';

  @override
  String get weight => 'الوزن';

  @override
  String get manufacturingDate => 'تاريخ التصنيع';

  @override
  String get batchNumber => 'رقم الدفعة';

  @override
  String get printerSettings => 'إعدادات الطابعة';

  @override
  String get scanMetadata => 'بيانات المسح الوصفية';

  @override
  String get scanId => 'معرف المسح';

  @override
  String get dateAndTime => 'التاريخ والوقت';

  @override
  String get reuseThisData => 'إعادة استخدام هذه البيانات';

  @override
  String get writeToNfc => 'كتابة إلى NFC';

  @override
  String get writeDataToChip => 'كتابة البيانات إلى الشريحة';

  @override
  String get writeSuccess => 'نجحت الكتابة!';

  @override
  String get writeError => 'خطأ في الكتابة';

  @override
  String get brand => 'العلامة التجارية';

  @override
  String get selectBrand => 'اختر العلامة التجارية';

  @override
  String get materialType => 'نوع المادة';

  @override
  String get selectMaterial => 'اختر المادة';

  @override
  String get serialNumber => 'الرقم التسلسلي';

  @override
  String get serialNumberHint => 'مثال: 001';

  @override
  String get initialWeight => 'الوزن الأولي';

  @override
  String get initialWeightHint => 'مثال: 1000';

  @override
  String get extruderTempMin => 'درجة حرارة الطارد الدنيا';

  @override
  String get extruderTempMax => 'درجة حرارة الطارد القصوى';

  @override
  String get bedTempMin => 'درجة حرارة السرير الدنيا';

  @override
  String get bedTempMax => 'درجة حرارة السرير القصوى';

  @override
  String get diameter => 'قطر الخيط';

  @override
  String get spoolLength => 'طول البكرة';

  @override
  String get generatedSku => 'SKU المولد';

  @override
  String get approachChipToWrite => 'اقترب من الشريحة للكتابة...';

  @override
  String get writing => 'الكتابة...';

  @override
  String get chooseColor => 'اختر اللون';

  @override
  String get required => 'مطلوب';

  @override
  String get invalid => 'غير صالح';

  @override
  String get advancedSettings => 'إعدادات متقدمة';

  @override
  String get opacity => 'الشفافية';

  @override
  String get validate => 'تأكيد';

  @override
  String get nfcTagInfo =>
      'استخدم علامة NFC فارغة ISO14443A (NTAG213) لإنشاء علامات Anycubic الخاصة بك.';

  @override
  String get stockInventory => 'البكرات في المخزون';

  @override
  String get addSpool => 'إضافة بكرة';

  @override
  String get scanSpool => 'مسح بكرة';

  @override
  String get addManually => 'إضافة يدويًا';

  @override
  String get spoolAdded => 'تمت إضافة البكرة';

  @override
  String get spoolUpdated => 'تم تحديث البكرة';

  @override
  String get noSpoolsInStock => 'لا توجد بكرات في المخزون';

  @override
  String get addFirstSpool => 'أضف بكرتك الأولى لبدء تتبع مخزونك';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count بكرة منخفضة في المخزون (< $threshold%)';
  }

  @override
  String get edit => 'تعديل';

  @override
  String get bobbinPrice => 'سعر البكرة';

  @override
  String get price => 'السعر';

  @override
  String get priceHint => 'مثال: 25.00';

  @override
  String get save => 'حفظ';

  @override
  String get spoolDetails => 'تفاصيل البكرة';

  @override
  String get deleteThisSpool => 'حذف هذه البكرة؟';

  @override
  String get cannotBeUndone => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get addSpoolManually => 'إضافة بكرة يدويًا';

  @override
  String get editSpool => 'تعديل البكرة';

  @override
  String get customBrand => 'علامة تجارية مخصصة';

  @override
  String get customBrandHint => 'مثال: علامتي التجارية';

  @override
  String get chooseFromList => 'اختر من القائمة';

  @override
  String get addBrand => '+ إضافة علامة تجارية';

  @override
  String get customMaterial => 'مادة مخصصة';

  @override
  String get customMaterialHint => 'مثال: مادتي';

  @override
  String get addMaterial => '+ إضافة مادة';

  @override
  String get colorHint => 'مثال: أزرق، أحمر...';

  @override
  String get enterColor => 'الرجاء إدخال اللون';

  @override
  String get initialWeightG => 'الوزن الأولي';

  @override
  String get remainingWeightG => 'الوزن المتبقي';

  @override
  String get enterBrand => 'الرجاء إدخال العلامة التجارية';

  @override
  String get selectOrEnterBrand => 'الرجاء اختيار أو إدخال علامة تجارية';

  @override
  String get quantity => 'الكمية';

  @override
  String get quantityHelper => 'أضف عدة بكرات متطابقة دفعة واحدة';

  @override
  String get quantityInvalid => 'أدخل رقمًا بين 1 و99';

  @override
  String spoolsInStockCount(int count) {
    return '$count في المخزون';
  }

  @override
  String get enterMaterial => 'الرجاء إدخال المادة';

  @override
  String get selectOrEnterMaterial => 'الرجاء اختيار أو إدخال مادة';

  @override
  String get enterPrice => 'الرجاء إدخال السعر';

  @override
  String get enterValidPrice => 'الرجاء إدخال سعر صالح';

  @override
  String get enterWeight => 'الرجاء إدخال الوزن';

  @override
  String get enterValidWeight => 'الرجاء إدخال وزن صالح';

  @override
  String get remainingCannotExceedTotal =>
      'الوزن المتبقي لا يمكن أن يتجاوز الوزن الإجمالي';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get spoolsInStock => 'البكرات في المخزون';

  @override
  String get totalValue => 'القيمة الإجمالية';

  @override
  String get lowStockSpools => 'مخزون منخفض';

  @override
  String get materialDistribution => 'التوزيع حسب المادة';

  @override
  String get brandDistribution => 'التوزيع حسب العلامة التجارية';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get refresh => 'تحديث';

  @override
  String get profileSettings => 'إعدادات الملف الشخصي';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get language => 'اللغة';

  @override
  String get selectLanguage => 'اختر اللغة';

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
  String get currency => 'العملة';

  @override
  String get selectCurrency => 'اختر العملة';

  @override
  String get units => 'الوحدات';

  @override
  String get selectUnits => 'اختر الوحدات';

  @override
  String get metric => 'متري (مم، جم، °م)';

  @override
  String get imperial => 'إمبراطوري (بوصة، أونصة، °ف)';

  @override
  String get lowStockThreshold => 'حد تنبيه المخزون المنخفض';

  @override
  String get lowStockThresholdDesc =>
      'ستعتبر البكرة منخفضة في المخزون إذا كان الوزن المتبقي أقل من هذه النسبة المئوية';

  @override
  String get authentication => 'المصادقة';

  @override
  String get signInWithGoogle => 'تسجيل الدخول بواسطة Google';

  @override
  String get signInWithApple => 'تسجيل الدخول بواسطة Apple';

  @override
  String get continueWithApple => 'المتابعة مع Apple';

  @override
  String get continueWithGoogle => 'المتابعة مع Google';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get madeWith => 'صنع بـ ❤️ لطابعات Anycubic 3D';

  @override
  String get scanBobbinDirectly => 'مسح البكرة';

  @override
  String get nfcEncoder => 'مشفر NFC';

  @override
  String get length => 'الطول';

  @override
  String get tempExtruder => 'درجة حرارة الطارد';

  @override
  String get tempBed => 'درجة حرارة السرير';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get legal => 'قانوني';

  @override
  String get back => 'رجوع';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get extruderTempMinHint => 'مثال: 200';

  @override
  String get extruderTempMaxHint => 'مثال: 220';

  @override
  String get bedTempMinHint => 'مثال: 50';

  @override
  String get bedTempMaxHint => 'مثال: 60';

  @override
  String get diameterHint => 'مثال: 1.75';

  @override
  String get spoolLengthHint => 'مثال: 330';

  @override
  String get tabGrid => 'شبكة';

  @override
  String get tabSpectrum => 'طيف';

  @override
  String get tabSliders => 'منزلقات';

  @override
  String get hexCode => 'كود Hex';

  @override
  String get red => 'أحمر';

  @override
  String get green => 'أخضر';

  @override
  String get blue => 'أزرق';

  @override
  String get black => 'أسود';

  @override
  String get white => 'أبيض';

  @override
  String get yellow => 'أصفر';

  @override
  String get orange => 'برتقالي';

  @override
  String get pink => 'وردي';

  @override
  String get purple => 'بنفسجي';

  @override
  String get gray => 'رمادي';

  @override
  String get brown => 'بني';

  @override
  String get unknown => 'غير معروف';

  @override
  String get metricUnits => 'متري (مم، جم، °م)';

  @override
  String get imperialUnits => 'إمبراطوري (بوصة، أونصة، °ف)';

  @override
  String get chf => 'فرنك سويسري (CHF)';

  @override
  String get eur => 'يورو (€)';

  @override
  String get usd => 'دولار أمريكي (\$)';

  @override
  String get gbp => 'جنيه إسترليني (£)';

  @override
  String get cad => 'دولار كندي (CAD)';

  @override
  String get aud => 'دولار أسترالي (A\$)';

  @override
  String get jpy => 'ين ياباني (¥)';

  @override
  String get cny => 'يوان صيني (¥)';

  @override
  String get inr => 'روبية هندية (₹)';

  @override
  String get brl => 'ريال برازيلي (R\$)';

  @override
  String get mxn => 'بيزو مكسيكي (MX\$)';

  @override
  String get sek => 'كرونة سويدية (kr)';

  @override
  String get nok => 'كرونة نرويجية (kr)';

  @override
  String get dkk => 'كرونة دنماركية (kr)';

  @override
  String get pln => 'زلوتي بولندي (zł)';

  @override
  String get czk => 'كرونة تشيكية (Kč)';

  @override
  String get nzd => 'دولار نيوزيلندي (NZ\$)';

  @override
  String get filamentsToOrder => 'خيوط للطلب';

  @override
  String get shoppingList => 'قائمة التسوق';

  @override
  String get addToShoppingList => 'إضافة إلى القائمة';

  @override
  String get noLowStockFilaments => 'لا توجد خيوط منخفضة المخزون';

  @override
  String get vipSubscriptionDescription =>
      'هذا الاشتراك يُستخدم فقط لتعطيل الإعلانات داخل التطبيق ودعم المشروع. لا توجد ميزات أخرى.';

  @override
  String get monthlySubscription => 'اشتراك شهري';

  @override
  String get yearlySubscription => 'اشتراك سنوي';

  @override
  String get perMonth => '/ شهر';

  @override
  String get perYear => '/ سنة';

  @override
  String onlyPerMonth(String price) {
    return 'فقط $price / شهر';
  }

  @override
  String get subscribe => 'اشترك';

  @override
  String get bestOffer => '✨ أفضل عرض ✨';

  @override
  String get forAnycubicAce => 'لـ Anycubic Ace';

  @override
  String get forBambuLabAms => 'لـ Bambu Lab AMS';

  @override
  String get scanNfcChip => 'مسح شريحة NFC';

  @override
  String get fillForm => 'ملء النموذج';

  @override
  String get emptyShoppingList => 'لا توجد خيوط في القائمة';

  @override
  String percentRemaining(String percent) {
    return '$percent% متبقي';
  }

  @override
  String get markAsOrdered => 'وضع علامة كمطلوب';

  @override
  String get markAsNotOrdered => 'وضع علامة كغير مطلوب';

  @override
  String get notSignedIn => 'غير مسجل الدخول';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get connection => 'تسجيل الدخول';

  @override
  String get signInToSync => 'سجل الدخول لمزامنة بياناتك';

  @override
  String get continueWithoutAccount => 'المتابعة بدون حساب (الوضع المحلي)';

  @override
  String get privacyNotice =>
      'بتسجيل الدخول، أنت توافق على\nشروط الخدمة وسياسة الخصوصية الخاصة بنا';

  @override
  String get updateStock => 'تحديث المخزون';

  @override
  String get scanToUpdateStock => 'مسح للتحديث';

  @override
  String get weightUsed => 'الوزن المستخدم';

  @override
  String get lengthUsed => 'الطول المستخدم';

  @override
  String get enterWeightOrLength => 'أدخل الوزن أو الطول المستخدم';

  @override
  String get weightUsedG => 'الوزن المستخدم (جم)';

  @override
  String get lengthUsedM => 'الطول المستخدم (م)';

  @override
  String get stockUpdated => 'تم تحديث المخزون';

  @override
  String get scanSpoolToUpdate => 'امسح بكرة لتحديث مخزونها';

  @override
  String get spoolNotFound => 'البكرة غير موجودة في المخزون';

  @override
  String get addSpoolFirstMessage =>
      'هذه البكرة ليست في مخزونك بعد. يرجى إضافتها أولاً باستخدام زر \'إضافة بكرة\' قبل تحديث مخزونها.';

  @override
  String get ok => 'موافق';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: للقراءة فقط';

  @override
  String get bambuLabReadOnlyDesc =>
      'علامات Bambu Lab تستخدم تشفير RSA ولا يمكن تعديلها. القراءة فقط.';

  @override
  String get forPrusaMk4 => 'لـ Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: قراءة وكتابة';

  @override
  String get prusaReadWriteDesc =>
      'تستخدم علامات Prusa معيار ISO 15693 (NFC-V) بتنسيق OpenPrintTag. القراءة والكتابة مدعومة.';

  @override
  String get bambuCloneLibrary => 'مكتبة نسخ Bambu Lab';

  @override
  String get noBambuClones => 'لا توجد نسخ Bambu Lab';

  @override
  String get scanBambuToClone =>
      'امسح علامات Bambu Lab الأصلية لإنشاء مكتبة النسخ الخاصة بك';

  @override
  String get scanTag => 'مسح علامة';

  @override
  String get syncWithCloud => 'المزامنة مع السحابة';

  @override
  String get syncCompleted => 'اكتملت المزامنة';

  @override
  String get deleteClone => 'حذف النسخة';

  @override
  String get renameClone => 'إعادة تسمية النسخة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get customName => 'اسم مخصص';

  @override
  String get clonedOn => 'تم النسخ في';

  @override
  String get writeThisClone => 'كتابة هذه النسخة';

  @override
  String get writeClone => 'كتابة النسخة';

  @override
  String get writeOnCUID => 'الكتابة على بطاقة CUID';

  @override
  String get cloneWrittenSuccess => 'تمت كتابة النسخة بنجاح!';

  @override
  String get requiredTagFormat => 'تنسيق العلامة المطلوب';

  @override
  String get type => 'النوع';

  @override
  String get frequency => 'التردد';

  @override
  String get protocol => 'البروتوكول';

  @override
  String get capacity => 'السعة';

  @override
  String get feature => 'الميزة';

  @override
  String get uidModifiable => 'الكتلة 0 (UID) قابلة للتعديل';

  @override
  String get whereToBuy =>
      'ابحث عن \"CUID MiFare Classic 1K\" على AliExpress أو Amazon أو eBay (~\$0.50/قطعة)';

  @override
  String get magicGen2Required =>
      'بطاقة Magic Gen2 - MiFare Classic 1K مع Block 0 قابل للكتابة (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'ابحث عن \"Magic Gen2 MiFare Classic 1K\" أو \"UID writable\" على AliExpress أو Amazon أو eBay (~\$0.50/قطعة)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ تحذير: الكتابة بواسطة iPhone NFC قد لا تعمل على جميع بطاقات Magic Gen2. يُنصح بجهاز Proxmark3 لأقصى موثوقية.';

  @override
  String get step1GetMagicGen2 =>
      'احصل على بطاقة Magic Gen2 فارغة (MiFare Classic 1K مع UID قابل للكتابة)';

  @override
  String get instructions => 'التعليمات';

  @override
  String get step1GetCUID => 'احصل على بطاقة CUID فارغة (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'اضغط على زر \"كتابة\" أدناه';

  @override
  String get step3HoldPhone => 'امسك هاتفك بالقرب من البطاقة';

  @override
  String get step4WaitConfirm => 'انتظر تأكيد الكتابة';

  @override
  String get step5TestClone =>
      'اختبر العلامة المنسوخة على طابعة Bambu Lab الخاصة بك!';

  @override
  String get rsaIncluded => 'تتضمن النسخة توقيع RSA الأصلي، وستقبلها الطابعة!';

  @override
  String get cloneDeleted => 'تم حذف النسخة';

  @override
  String get deleteAccount => 'حذف حسابي';

  @override
  String get deleteAccountConfirmation =>
      'هذا الإجراء لا رجعة فيه. سيتم حذف حسابك وجميع البيانات خلال 30 يومًا.';

  @override
  String get accountDeletionRequested => 'تم تسجيل طلب الحذف';

  @override
  String get clearShoppingList => 'مسح القائمة';

  @override
  String get clearShoppingListConfirmation =>
      'هل أنت متأكد أنك تريد مسح قائمة التسوق بالكامل؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'السجل';

  @override
  String get retryButton => 'إعادة المحاولة';

  @override
  String get readSuccessMessage => 'تمت القراءة بنجاح!';

  @override
  String get filamentTypeLabel => 'نوع الفيلامنت';

  @override
  String get scanNfcChipButton => 'مسح شريحة NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'حذف النسخة \"$name\"؟';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'تم حذف النسخة \"$name\"';
  }

  @override
  String get extruderLabel => 'الطارد';

  @override
  String get writeThisCloneButton => 'كتابة هذه النسخة';

  @override
  String get customNameHint => 'اسم مخصص';

  @override
  String get cloneWriteSuccessMessage => 'تم كتابة النسخة بنجاح!';

  @override
  String errorPrefix(String error) {
    return 'خطأ: $error';
  }

  @override
  String get writingInProgress => 'جاري الكتابة...';

  @override
  String get writeOnCUIDButton => 'الكتابة على بطاقة CUID';

  @override
  String get diameterLabel => 'القطر';

  @override
  String get extruderTempLabel => 'درجة حرارة الطارد';

  @override
  String get bedTempLabel => 'درجة حرارة السرير';

  @override
  String get nfcFrequency => '13.56 ميجاهرتز';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1 كيلوبايت (1024 بايت)';

  @override
  String get rsaSignatureNote =>
      'تتضمن النسخة توقيع RSA الأصلي، وستقبلها الطابعة!';

  @override
  String get writeBambuLabTagTitle => 'كتابة علامة Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'تم كتابة علامة Bambu Lab بنجاح!';

  @override
  String get approachNfcTagMessage => 'قرّب علامة NFC...';

  @override
  String get bambuLabFormatMiFare => 'تنسيق Bambu Lab (MiFare 13.56 ميجاهرتز)';

  @override
  String get bambuLabFormat => 'تنسيق Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'يستخدم هذا التنسيق رموز مواد Bambu Lab ويخزن البيانات بتنسيق متوافق مع AMS.';

  @override
  String get brandLabel => 'العلامة التجارية';

  @override
  String get materialTypeLabel => 'نوع المادة';

  @override
  String get serialNumber3Digits => 'الرقم التسلسلي (3 أرقام)';

  @override
  String get weight250g => '250 جرام';

  @override
  String get weight500g => '500 جرام';

  @override
  String get weight1000g => '1000 جرام';

  @override
  String get weight1000gStandard => '1000 جرام (قياسي)';

  @override
  String get weight2000g => '2000 جرام';

  @override
  String get weight3000g => '3000 جرام';

  @override
  String get writeBambuLabTagButton => 'كتابة علامة Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'ملاحظة: تستخدم علامات Bambu Lab الأصلية تشفير RSA. يكتب هذا الوضع البيانات بتنسيق مبسط متوافق.';

  @override
  String signInError(String error) {
    return 'خطأ في تسجيل الدخول: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'تم تفعيل الاشتراك بنجاح!';

  @override
  String get subscriptionFailedMessage => 'فشل الاشتراك';

  @override
  String errorMessage(String error) {
    return 'خطأ: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'تم استعادة الاشتراك بنجاح!';

  @override
  String get noSubscriptionFoundMessage => 'لم يتم العثور على اشتراك';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'نشط';

  @override
  String get noAdsExperienceMessage => 'استمتع بتجربة خالية من الإعلانات!';

  @override
  String get subscribedLabel => 'مشترك';

  @override
  String get restorePurchasesButton => 'استعادة المشتريات';

  @override
  String get cannotExceedRemainingWeight => 'لا يمكن تجاوز الوزن المتبقي';

  @override
  String get pleaseEnterLength => 'يرجى إدخال الطول';

  @override
  String get pleaseEnterValidLength => 'يرجى إدخال طول صالح';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'لم يتم تعيين طول البكرة - لا يمكن التحويل';

  @override
  String get exceedsRemainingWeight => 'يتجاوز الوزن المتبقي';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'ساعدنا في التعرف على هذا الفيلامنت';

  @override
  String get helpUsImprove => 'ساعدنا على التحسين!';

  @override
  String get helpIdentifyDescription =>
      'قرأنا الشريحة لكن لم نتمكن من التعرف عليها. أخبرنا ما هو هذا الفيلامنت لتحسين التطبيق.';

  @override
  String get otherBrand => 'أخرى';

  @override
  String get thankYouFeedback => 'شكراً لملاحظاتك!';

  @override
  String get send => 'إرسال';

  @override
  String get optionalDetails => 'تفاصيل اختيارية';

  @override
  String get weightGrams => 'الوزن (غ)';

  @override
  String get diameterMm => 'القطر (مم)';

  @override
  String get spoolLengthM => 'طول البكرة (م)';

  @override
  String get batchNumberLabel => 'رقم الدفعة / SKU';

  @override
  String get contactUs => 'اتصل بنا';

  @override
  String get contactUsSubtitle => 'أسئلة أو اقتراحات أو مشاكل';

  @override
  String get nfcTagNotDetected => 'لم يتم اكتشاف أي علامة NFC';

  @override
  String get nfcTagNotDetectedDesc =>
      'لم يتم العثور على أي علامة. قد تكون العلامة تالفة أو بعيدة جداً عن الهاتف.';

  @override
  String get nfcTagIncompatible => 'تم اكتشاف علامة NFC غير متوافقة';

  @override
  String get nfcAuthError => 'فشل مصادقة علامة NFC';

  @override
  String get nfcAuthErrorDesc =>
      'تم اكتشاف العلامة ولكن فشلت المصادقة بعد عدة محاولات. اضغط العلامة بإحكام على الجزء الخلفي من الهاتف وحاول مرة أخرى.';

  @override
  String get nfcTagInfoPrusa =>
      'استخدم بطاقة NXP ICODE SLIX2 فارغة (ISO 15693) لإنشاء علامات متوافقة مع OpenPrintTag لـ Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'كتابة Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'تسجيل الدخول باستخدام Apple غير متاح على هذا الجهاز.';

  @override
  String get signInAppleFailed =>
      'فشل تسجيل الدخول باستخدام Apple. يرجى المحاولة مرة أخرى.';

  @override
  String get signInFailed => 'فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.';

  @override
  String get mustContain3Digits => 'يجب أن يحتوي على 3 أرقام';

  @override
  String get mustBeNumber => 'يجب أن يكون رقماً';

  @override
  String generatedUidLabel(String uid) {
    return 'UID المُنشأ: $uid';
  }

  @override
  String get experimentalBadge => 'تجريبي';

  @override
  String get newBadge => 'جديد';

  @override
  String get forCrealityCfs => 'لـ Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: قراءة وكتابة';

  @override
  String get crealityReadWriteDesc =>
      'تستخدم علامات Creality CFS تقنية MiFare Classic 1K مع تشفير AES-128-ECB. القراءة والكتابة مدعومة على Android فقط.';

  @override
  String get platformLimitationTitle => 'قيود المنصة';

  @override
  String get mifareClassicNotSupportedIos =>
      'علامات MiFare Classic (Bambu Lab، Creality) غير مدعومة على iOS بسبب قيود Apple CoreNFC. هذه الميزة متاحة على Android فقط.';

  @override
  String get nfcTagInfoCreality =>
      'استخدم علامة MiFare Classic 1K لكتابة بيانات متوافقة مع Creality CFS لـ Creality K2 Plus.';

  @override
  String get colorHintExamples => 'أحمر، أزرق، أسود...';

  @override
  String get dryingTemp => 'درجة حرارة التجفيف';

  @override
  String get dryingTempHint => 'مثال 55';

  @override
  String get dryingTime => 'وقت التجفيف (ساعات)';

  @override
  String get dryingTimeHint => 'مثال 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'تم اكتشاف العلامة كـ $mode — قم بتبديل التبويب للمسح التالي';
  }

  @override
  String get fallbackChooseMode => 'اختر الوضع يدوياً';

  @override
  String get fallbackChooseModeSubtitle =>
      'لم يتمكن الكشف التلقائي من التعرف على هذه العلامة. اختر البروتوكول:';

  @override
  String get tryAutoDetect => 'محاولة الكشف التلقائي';

  @override
  String get autoDetectAllBrands => 'الكشف التلقائي — جميع العلامات التجارية';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic وElegoo وOpenSpool وOpenTag3D والمزيد';

  @override
  String get nfcTipIos =>
      'قارئ NFC في أعلى iPhone. ضعه مباشرة على علامة NFC الخاصة بالبكرة.';

  @override
  String get nfcTipAndroid =>
      'قارئ NFC عادة في وسط الجهة الخلفية من هاتفك. ضع الجهة الخلفية من الهاتف على علامة NFC الخاصة بالبكرة.';

  @override
  String get stockSortBy => 'فرز';

  @override
  String get stockFilter => 'تصفية';

  @override
  String get stockSortRecent => 'الأحدث';

  @override
  String get stockSortBrand => 'العلامة التجارية';

  @override
  String get stockSortMaterial => 'المادة';

  @override
  String get stockSortRemaining => 'الوزن المتبقي';

  @override
  String get stockSortColor => 'اللون';

  @override
  String get stockFilterAll => 'الكل';

  @override
  String get stockResetFilters => 'إعادة تعيين';

  @override
  String get stockNoMatch => 'لا توجد بكرة تطابق عوامل التصفية';

  @override
  String get nfcDisabledTitle => '‏NFC معطّل';

  @override
  String get nfcDisabledMessage =>
      '‏NFC معطّل. فعّله من إعدادات الهاتف لمسح البكرات.';

  @override
  String get updateAvailableTitle => 'تحديث متوفر';

  @override
  String get updateAvailableMessage => 'يتوفر إصدار جديد من Spool Master.';

  @override
  String get updateForcedMessage =>
      'لم يعد هذا الإصدار مدعومًا. يرجى التحديث للمتابعة.';

  @override
  String get updateNow => 'تحديث';

  @override
  String get updateLater => 'لاحقًا';

  @override
  String get nfcScanGuidance => 'أمسك البطاقة ثابتة عند أعلى الهاتف أو ظهره.';

  @override
  String get tagMovedTitle => 'تحرّكت البطاقة';

  @override
  String get tagMovedMessage =>
      'تحرّكت البطاقة أثناء القراءة. أعد وضعها وأبقِ الهاتف ثابتًا.';

  @override
  String get lightBlue => 'أزرق فاتح';

  @override
  String get transparent => 'شفاف';

  @override
  String get nfcActiveApproachTag => 'NFC نشط — قرّب البطاقة';

  @override
  String addedToShoppingList(String item) {
    return 'تمت إضافة $item إلى قائمة التسوق';
  }

  @override
  String get deleteAccountFailed => 'فشل حذف الحساب. حاول مرة أخرى.';

  @override
  String get scanHistoryError => 'خطأ في الوصول إلى سجل المسح';

  @override
  String get genericBrand => 'عام';

  @override
  String get stockSearchHint => 'البحث (العلامة التجارية، اللون، الموقع…)';

  @override
  String get stockMoreActions => 'المزيد من الإجراءات';

  @override
  String get exportExcel => 'تصدير إلى Excel';

  @override
  String get exportFailed => 'فشل التصدير';

  @override
  String get exportShareSubject => 'مخزون الفيلامنت لديّ (Spool Master)';

  @override
  String get exportColorHex => 'رمز اللون';

  @override
  String get exportRemainingPercent => 'المتبقي (%)';

  @override
  String get exportPricePerKg => 'السعر / كغ';

  @override
  String get exportAddedDate => 'تاريخ الإضافة';

  @override
  String get exportOrdered => 'تم الطلب';

  @override
  String get exportDate => 'التاريخ';

  @override
  String get exportGrams => 'غرام';

  @override
  String get exportCost => 'التكلفة';

  @override
  String get importSpools => 'استيراد (CSV / Excel)';

  @override
  String get importConfirmTitle => 'استيراد البكرات';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return 'البكرات المراد إضافتها: $count\nموجودة في المخزون (تم تخطيها): $duplicates\nصفوف غير مقروءة (تم تخطيها): $skipped';
  }

  @override
  String get importAction => 'استيراد';

  @override
  String get importNothingFound =>
      'لم يتم التعرف على أي بكرة. يجب أن يحتوي الملف على عمودي المادة والوزن على الأقل (مثل تصدير Excel من التطبيق).';

  @override
  String importDone(int count) {
    return 'البكرات المستوردة: $count';
  }

  @override
  String get importFailed => 'ملف غير مقروء';

  @override
  String get location => 'الموقع';

  @override
  String get locationHint => 'مثال: الرف A، صندوق التجفيف 2';

  @override
  String get notes => 'ملاحظات';

  @override
  String get notesHint => 'مثال: يجب تجفيفها قبل الاستخدام';

  @override
  String get printCostTitle => 'تكلفة الطباعة';

  @override
  String get printCostGrams => 'الفيلامنت المستخدم (غ)';

  @override
  String printCostResult(String cost) {
    return 'تكلفة المادة: $cost';
  }

  @override
  String printCostPerKg(String price) {
    return 'السعر لكل كغ: $price';
  }

  @override
  String get printCostNoPrice => 'أضف سعر البكرة لحساب التكلفة.';

  @override
  String get printCostDeduct => 'الخصم من المخزون';

  @override
  String printCostDeducted(String grams) {
    return 'تم خصم $grams غ من المخزون';
  }

  @override
  String get consumptionTitle => 'الاستهلاك';

  @override
  String get consumptionLast30Days => 'آخر 30 يومًا';

  @override
  String get consumptionThisMonth => 'هذا الشهر';

  @override
  String get consumptionByMaterial => 'حسب المادة (30 يومًا)';

  @override
  String get consumptionMonthly => 'آخر 6 أشهر';

  @override
  String get consumptionEmpty =>
      'لم يتم تسجيل أي استهلاك بعد. يظهر فور تحديث الوزن المتبقي لبكرة أو استخدام حاسبة التكلفة.';

  @override
  String get shareShoppingList => 'مشاركة القائمة';

  @override
  String get nfcBlankTagTitle => 'علامة فارغة';

  @override
  String get nfcBlankTagDesc =>
      'لا تحتوي هذه العلامة على بيانات البكرة. أضف البكرة يدويًا أو اكتب العلامة من التطبيق.';
}
