// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'สต็อก';

  @override
  String get statistics => 'การวิเคราะห์';

  @override
  String get profile => 'โปรไฟล์';

  @override
  String get readNfcChip => 'อ่านชิป NFC';

  @override
  String get scanHistory => 'ประวัติ';

  @override
  String get writeNfcChip => 'เขียนชิป NFC';

  @override
  String get nfcNotAvailable => 'NFC ไม่พร้อมใช้งาน';

  @override
  String get nfcNotAvailableDesc =>
      'อุปกรณ์ของคุณไม่รองรับ NFC หรือถูกปิดใช้งาน';

  @override
  String get nfcNotSupported => 'อุปกรณ์นี้ไม่รองรับ NFC';

  @override
  String get approachNfcChip => 'เข้าใกล้ชิป NFC...';

  @override
  String get scanningNfc => 'กำลังสแกน...';

  @override
  String get nfcDataRead => 'อ่านข้อมูล NFC สำเร็จ!';

  @override
  String get errorReadingNfc => 'ข้อผิดพลาดในการอ่าน NFC';

  @override
  String get scanHistoryTitle => 'ประวัติการสแกน';

  @override
  String get noScansRecorded => 'ไม่มีการบันทึกการสแกน';

  @override
  String get scansWillAppearHere => 'การสแกน NFC จะปรากฏที่นี่โดยอัตโนมัติ';

  @override
  String get clearAll => 'ล้างทั้งหมด';

  @override
  String get deleteThisScan => 'ลบการสแกนนี้?';

  @override
  String get actionIrreversible => 'การดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get delete => 'ลบ';

  @override
  String get clearAllHistory => 'ล้างประวัติทั้งหมด?';

  @override
  String get allScansWillBeDeleted =>
      'การสแกนทั้งหมดจะถูกลบ การดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String get scanDeleted => 'ลบการสแกนแล้ว';

  @override
  String get scanDetails => 'รายละเอียดการสแกน';

  @override
  String scannedOn(Object date) {
    return 'สแกนเมื่อ $date';
  }

  @override
  String get bobbinInformation => 'ข้อมูลม้วนใยพิมพ์';

  @override
  String get filamentType => 'ประเภทฟิลาเมนต์';

  @override
  String get color => 'สี';

  @override
  String get weight => 'น้ำหนัก';

  @override
  String get manufacturingDate => 'วันที่ผลิต';

  @override
  String get batchNumber => 'หมายเลขแบทช์';

  @override
  String get printerSettings => 'การตั้งค่าเครื่องพิมพ์';

  @override
  String get scanMetadata => 'ข้อมูลเมตาของการสแกน';

  @override
  String get scanId => 'รหัสการสแกน';

  @override
  String get dateAndTime => 'วันที่และเวลา';

  @override
  String get reuseThisData => 'ใช้ข้อมูลนี้อีกครั้ง';

  @override
  String get writeToNfc => 'เขียนลง NFC';

  @override
  String get writeDataToChip => 'เขียนข้อมูลลงชิป';

  @override
  String get writeSuccess => 'เขียนสำเร็จ!';

  @override
  String get writeError => 'ข้อผิดพลาดในการเขียน';

  @override
  String get brand => 'ยี่ห้อ';

  @override
  String get selectBrand => 'เลือกยี่ห้อ';

  @override
  String get materialType => 'ประเภทวัสดุ';

  @override
  String get selectMaterial => 'เลือกวัสดุ';

  @override
  String get serialNumber => 'หมายเลขซีเรียล';

  @override
  String get serialNumberHint => 'เช่น: 001';

  @override
  String get initialWeight => 'น้ำหนักเริ่มต้น';

  @override
  String get initialWeightHint => 'เช่น: 1000';

  @override
  String get extruderTempMin => 'อุณหภูมิหัวพิมพ์ต่ำสุด';

  @override
  String get extruderTempMax => 'อุณหภูมิหัวพิมพ์สูงสุด';

  @override
  String get bedTempMin => 'อุณหภูมิแท่นพิมพ์ต่ำสุด';

  @override
  String get bedTempMax => 'อุณหภูมิแท่นพิมพ์สูงสุด';

  @override
  String get diameter => 'เส้นผ่านศูนย์กลางฟิลาเมนต์';

  @override
  String get spoolLength => 'ความยาวม้วนใย';

  @override
  String get generatedSku => 'SKU ที่สร้าง';

  @override
  String get approachChipToWrite => 'เข้าใกล้ชิปเพื่อเขียน...';

  @override
  String get writing => 'กำลังเขียน...';

  @override
  String get chooseColor => 'เลือกสี';

  @override
  String get required => 'จำเป็น';

  @override
  String get invalid => 'ไม่ถูกต้อง';

  @override
  String get advancedSettings => 'การตั้งค่าขั้นสูง';

  @override
  String get opacity => 'ความโปร่งแสง';

  @override
  String get validate => 'ยืนยัน';

  @override
  String get nfcTagInfo =>
      'ใช้แท็ก NFC ว่าง ISO14443A (NTAG213) เพื่อสร้างแท็ก Anycubic ของคุณเอง';

  @override
  String get stockInventory => 'ม้วนในสต็อก';

  @override
  String get addSpool => 'เพิ่มม้วนใย';

  @override
  String get scanSpool => 'สแกนม้วนใย';

  @override
  String get addManually => 'เพิ่มด้วยตนเอง';

  @override
  String get spoolAdded => 'เพิ่มม้วนใยแล้ว';

  @override
  String get spoolUpdated => 'อัปเดตม้วนใยแล้ว';

  @override
  String get noSpoolsInStock => 'ไม่มีม้วนใยในสต็อก';

  @override
  String get addFirstSpool =>
      'เพิ่มม้วนใยแรกของคุณเพื่อเริ่มติดตามสินค้าคงคลัง';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count ม้วนมีสต็อกต่ำ (< $threshold%)';
  }

  @override
  String get edit => 'แก้ไข';

  @override
  String get bobbinPrice => 'ราคาม้วนใย';

  @override
  String get price => 'ราคา';

  @override
  String get priceHint => 'เช่น: 25.00';

  @override
  String get save => 'บันทึก';

  @override
  String get spoolDetails => 'รายละเอียดม้วนใย';

  @override
  String get deleteThisSpool => 'ลบม้วนใยนี้?';

  @override
  String get cannotBeUndone => 'การดำเนินการนี้ไม่สามารถย้อนกลับได้';

  @override
  String get addSpoolManually => 'เพิ่มม้วนใยด้วยตนเอง';

  @override
  String get editSpool => 'แก้ไขม้วนใย';

  @override
  String get customBrand => 'ยี่ห้อกำหนดเอง';

  @override
  String get customBrandHint => 'เช่น: ยี่ห้อของฉัน';

  @override
  String get chooseFromList => 'เลือกจากรายการ';

  @override
  String get addBrand => '+ เพิ่มยี่ห้อ';

  @override
  String get customMaterial => 'วัสดุกำหนดเอง';

  @override
  String get customMaterialHint => 'เช่น: วัสดุของฉัน';

  @override
  String get addMaterial => '+ เพิ่มวัสดุ';

  @override
  String get colorHint => 'เช่น: น้ำเงิน, แดง...';

  @override
  String get enterColor => 'กรุณาระบุสี';

  @override
  String get initialWeightG => 'น้ำหนักเริ่มต้น';

  @override
  String get remainingWeightG => 'น้ำหนักที่เหลือ';

  @override
  String get enterBrand => 'กรุณาระบุยี่ห้อ';

  @override
  String get selectOrEnterBrand => 'กรุณาเลือกหรือระบุยี่ห้อ';

  @override
  String get enterMaterial => 'กรุณาระบุวัสดุ';

  @override
  String get selectOrEnterMaterial => 'กรุณาเลือกหรือระบุวัสดุ';

  @override
  String get enterPrice => 'กรุณาระบุราคา';

  @override
  String get enterValidPrice => 'กรุณาระบุราคาที่ถูกต้อง';

  @override
  String get enterWeight => 'กรุณาระบุน้ำหนัก';

  @override
  String get enterValidWeight => 'กรุณาระบุน้ำหนักที่ถูกต้อง';

  @override
  String get remainingCannotExceedTotal =>
      'น้ำหนักที่เหลือต้องไม่เกินน้ำหนักทั้งหมด';

  @override
  String get overview => 'ภาพรวม';

  @override
  String get spoolsInStock => 'ม้วนใยในสต็อก';

  @override
  String get totalValue => 'มูลค่ารวม';

  @override
  String get lowStockSpools => 'สต็อกต่ำ';

  @override
  String get materialDistribution => 'การกระจายตามวัสดุ';

  @override
  String get brandDistribution => 'การกระจายตามยี่ห้อ';

  @override
  String get noData => 'ไม่มีข้อมูล';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get profileSettings => 'การตั้งค่าโปรไฟล์';

  @override
  String get preferences => 'การตั้งค่า';

  @override
  String get language => 'ภาษา';

  @override
  String get selectLanguage => 'เลือกภาษา';

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
  String get currency => 'สกุลเงิน';

  @override
  String get selectCurrency => 'เลือกสกุลเงิน';

  @override
  String get units => 'หน่วย';

  @override
  String get selectUnits => 'เลือกหน่วย';

  @override
  String get metric => 'เมตริก (มม., ก., °C)';

  @override
  String get imperial => 'อิมพีเรียล (นิ้ว, ออนซ์, °F)';

  @override
  String get lowStockThreshold => 'เกณฑ์การแจ้งเตือนสต็อกต่ำ';

  @override
  String get lowStockThresholdDesc =>
      'ม้วนใยจะถือว่ามีสต็อกต่ำหากน้ำหนักที่เหลือน้อยกว่าเปอร์เซ็นต์นี้';

  @override
  String get authentication => 'การรับรองตัวตน';

  @override
  String get signInWithGoogle => 'เข้าสู่ระบบด้วย Google';

  @override
  String get signInWithApple => 'เข้าสู่ระบบด้วย Apple';

  @override
  String get comingSoon => 'เร็วๆ นี้';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get madeWith => 'สร้างด้วย ❤️ สำหรับเครื่องพิมพ์ 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'สแกนม้วนใย';

  @override
  String get nfcEncoder => 'เครื่องเข้ารหัส NFC';

  @override
  String get length => 'ความยาว';

  @override
  String get tempExtruder => 'อุณหภูมิหัวพิมพ์';

  @override
  String get tempBed => 'อุณหภูมิแท่นพิมพ์';

  @override
  String get termsOfService => 'ข้อกำหนดการให้บริการ';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'ย้อนกลับ';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get signOut => 'ออกจากระบบ';

  @override
  String get extruderTempMinHint => 'เช่น: 200';

  @override
  String get extruderTempMaxHint => 'เช่น: 220';

  @override
  String get bedTempMinHint => 'เช่น: 50';

  @override
  String get bedTempMaxHint => 'เช่น: 60';

  @override
  String get diameterHint => 'เช่น: 1.75';

  @override
  String get spoolLengthHint => 'เช่น: 330';

  @override
  String get tabGrid => 'ตาราง';

  @override
  String get tabSpectrum => 'สเปกตรัม';

  @override
  String get tabSliders => 'แถบเลื่อน';

  @override
  String get hexCode => 'รหัส Hex';

  @override
  String get red => 'แดง';

  @override
  String get green => 'เขียว';

  @override
  String get blue => 'น้ำเงิน';

  @override
  String get metricUnits => 'เมตริก (มม., ก., °C)';

  @override
  String get imperialUnits => 'อิมพีเรียล (นิ้ว, ออนซ์, °F)';

  @override
  String get chf => 'ฟรังก์สวิส (CHF)';

  @override
  String get eur => 'ยูโร (€)';

  @override
  String get usd => 'ดอลลาร์สหรัฐ (\$)';

  @override
  String get gbp => 'ปอนด์สเตอร์ลิง (£)';

  @override
  String get cad => 'ดอลลาร์แคนาดา (CAD)';

  @override
  String get filamentsToOrder => 'ฟิลาเมนต์ที่ต้องสั่ง';

  @override
  String get shoppingList => 'รายการช็อปปิ้ง';

  @override
  String get addToShoppingList => 'เพิ่มในรายการ';

  @override
  String get noLowStockFilaments => 'ไม่มีฟิลาเมนต์ที่มีสต็อกต่ำ';

  @override
  String get vipSubscriptionDescription =>
      'การสมัครสมาชิกนี้ใช้เพื่อปิดการแสดงโฆษณาในแอปและสนับสนุนโปรเจ็กต์เท่านั้น ไม่มีคุณสมบัติอื่น';

  @override
  String get monthlySubscription => 'การสมัครรายเดือน';

  @override
  String get yearlySubscription => 'การสมัครรายปี';

  @override
  String get perMonth => '/ เดือน';

  @override
  String get perYear => '/ ปี';

  @override
  String onlyPerMonth(String price) {
    return 'เพียง $price / เดือน';
  }

  @override
  String get subscribe => 'สมัครสมาชิก';

  @override
  String get bestOffer => '✨ ข้อเสนอที่ดีที่สุด ✨';

  @override
  String get forAnycubicAce => 'สำหรับ Anycubic Ace';

  @override
  String get forBambuLabAms => 'สำหรับ Bambu Lab AMS';

  @override
  String get scanNfcChip => 'สแกนชิป NFC';

  @override
  String get fillForm => 'กรอกแบบฟอร์ม';

  @override
  String get emptyShoppingList => 'ไม่มีฟิลาเมนต์ในรายการ';

  @override
  String percentRemaining(String percent) {
    return 'เหลือ $percent%';
  }

  @override
  String get markAsOrdered => 'ทำเครื่องหมายว่าสั่งแล้ว';

  @override
  String get markAsNotOrdered => 'ทำเครื่องหมายว่ายังไม่ได้สั่ง';

  @override
  String get notSignedIn => 'ยังไม่ได้เข้าสู่ระบบ';

  @override
  String get signIn => 'เข้าสู่ระบบ';

  @override
  String get connection => 'การเชื่อมต่อ';

  @override
  String get signInToSync => 'เข้าสู่ระบบเพื่อซิงค์ข้อมูลของคุณ';

  @override
  String get continueWithoutAccount =>
      'ดำเนินการต่อโดยไม่มีบัญชี (โหมดท้องถิ่น)';

  @override
  String get privacyNotice =>
      'การเข้าสู่ระบบแสดงว่าคุณยอมรับ\nข้อกำหนดการให้บริการและนโยบายความเป็นส่วนตัวของเรา';

  @override
  String get updateStock => 'อัปเดตสต็อก';

  @override
  String get scanToUpdateStock => 'สแกนเพื่ออัปเดต';

  @override
  String get weightUsed => 'น้ำหนักที่ใช้';

  @override
  String get lengthUsed => 'ความยาวที่ใช้';

  @override
  String get enterWeightOrLength => 'ใส่น้ำหนักหรือความยาวที่ใช้';

  @override
  String get weightUsedG => 'น้ำหนักที่ใช้ (g)';

  @override
  String get lengthUsedM => 'ความยาวที่ใช้ (m)';

  @override
  String get stockUpdated => 'อัปเดตสต็อกแล้ว';

  @override
  String get scanSpoolToUpdate => 'สแกนม้วนเพื่ออัปเดตสต็อก';

  @override
  String get spoolNotFound => 'ไม่พบม้วนในสต็อก';

  @override
  String get addSpoolFirstMessage =>
      'ม้วนนี้ยังไม่อยู่ในสต็อกของคุณ โปรดเพิ่มก่อนโดยใช้ปุ่ม \'เพิ่มม้วน\' ก่อนที่จะอัปเดตสต็อก';

  @override
  String get ok => 'ตกลง';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: อ่านอย่างเดียว';

  @override
  String get bambuLabReadOnlyDesc =>
      'แท็ก Bambu Lab ใช้การเข้ารหัส RSA และไม่สามารถแก้ไขได้ อ่านอย่างเดียว';

  @override
  String get bambuCloneLibrary => 'คลัง Clone Bambu Lab';

  @override
  String get noBambuClones => 'ไม่มี Clone Bambu Lab';

  @override
  String get scanBambuToClone =>
      'สแกนแท็กต้นฉบับ Bambu Lab เพื่อสร้างคลัง Clone ของคุณ';

  @override
  String get scanTag => 'สแกนแท็ก';

  @override
  String get syncWithCloud => 'ซิงค์กับคลาวด์';

  @override
  String get syncCompleted => 'ซิงค์เสร็จสมบูรณ์';

  @override
  String get deleteClone => 'ลบ Clone';

  @override
  String get renameClone => 'เปลี่ยนชื่อ Clone';

  @override
  String get rename => 'เปลี่ยนชื่อ';

  @override
  String get customName => 'ชื่อที่กำหนดเอง';

  @override
  String get clonedOn => 'โคลนเมื่อ';

  @override
  String get writeThisClone => 'เขียน Clone นี้';

  @override
  String get writeClone => 'เขียน Clone';

  @override
  String get writeOnCUID => 'เขียนลงการ์ด CUID';

  @override
  String get cloneWrittenSuccess => 'เขียน Clone สำเร็จ!';

  @override
  String get requiredTagFormat => 'รูปแบบแท็กที่ต้องการ';

  @override
  String get type => 'ประเภท';

  @override
  String get frequency => 'ความถี่';

  @override
  String get protocol => 'โปรโตคอล';

  @override
  String get capacity => 'ความจุ';

  @override
  String get feature => 'คุณสมบัติ';

  @override
  String get uidModifiable => 'บล็อก 0 (UID) สามารถแก้ไขได้';

  @override
  String get whereToBuy =>
      'ค้นหา \"CUID MiFare Classic 1K\" บน AliExpress, Amazon หรือ eBay (~\$0.50/ชิ้น)';

  @override
  String get magicGen2Required =>
      'การ์ด Magic Gen2 - MiFare Classic 1K พร้อม Block 0 (UID) ที่เขียนได้';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'ค้นหา \"Magic Gen2 MiFare Classic 1K\" หรือ \"UID writable\" บน AliExpress, Amazon หรือ eBay (~\$0.50/ชิ้น)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ คำเตือน: การเขียนด้วย iPhone NFC อาจไม่ทำงานกับการ์ด Magic Gen2 ทั้งหมด แนะนำให้ใช้ Android กับแอป NFC Tools Pro หรืออุปกรณ์ Proxmark3 เพื่อความน่าเชื่อถือ';

  @override
  String get step1GetMagicGen2 =>
      'รับการ์ด Magic Gen2 เปล่า (MiFare Classic 1K พร้อม UID ที่เขียนได้)';

  @override
  String get instructions => 'คำแนะนำ';

  @override
  String get step1GetCUID => 'หาการ์ด CUID เปล่า (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'กดปุ่ม \"เขียน\" ด้านล่าง';

  @override
  String get step3HoldPhone => 'ถือ iPhone ของคุณใกล้กับการ์ด CUID';

  @override
  String get step4WaitConfirm => 'รอการยืนยันการเขียน';

  @override
  String get step5TestClone =>
      'ทดสอบแท็กที่โคลนบนเครื่องพิมพ์ Bambu Lab ของคุณ!';

  @override
  String get rsaIncluded =>
      'Clone รวมลายเซ็น RSA ต้นฉบับ จะได้รับการยอมรับจากเครื่องพิมพ์!';

  @override
  String get cloneDeleted => 'ลบ Clone แล้ว';
}
