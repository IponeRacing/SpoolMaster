// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => '库存';

  @override
  String get statistics => '统计';

  @override
  String get profile => '个人资料';

  @override
  String get readNfcChip => '读取NFC芯片';

  @override
  String get scanHistory => '历史记录';

  @override
  String get writeNfcChip => '写入NFC芯片';

  @override
  String get nfcNotAvailable => 'NFC不可用';

  @override
  String get nfcNotAvailableDesc => '您的设备不支持NFC或已禁用。';

  @override
  String get nfcNotSupported => '此设备不支持NFC';

  @override
  String get approachNfcChip => '靠近NFC芯片...';

  @override
  String get scanningNfc => '扫描中...';

  @override
  String get nfcDataRead => 'NFC数据读取成功！';

  @override
  String get errorReadingNfc => 'NFC读取错误';

  @override
  String get scanHistoryTitle => '扫描历史';

  @override
  String get noScansRecorded => '无扫描记录';

  @override
  String get scansWillAppearHere => 'NFC扫描将自动显示在此处';

  @override
  String get clearAll => '全部清除';

  @override
  String get deleteThisScan => '删除此扫描？';

  @override
  String get actionIrreversible => '此操作不可逆。';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get clearAllHistory => '清除所有历史记录？';

  @override
  String get allScansWillBeDeleted => '所有扫描将被删除。此操作不可逆。';

  @override
  String get scanDeleted => '扫描已删除';

  @override
  String get scanDetails => '扫描详情';

  @override
  String scannedOn(Object date) {
    return '扫描于$date';
  }

  @override
  String get bobbinInformation => '线轴信息';

  @override
  String get filamentType => '耗材类型';

  @override
  String get color => '颜色';

  @override
  String get weight => '重量';

  @override
  String get manufacturingDate => '生产日期';

  @override
  String get batchNumber => '批次号';

  @override
  String get printerSettings => '打印机设置';

  @override
  String get scanMetadata => '扫描元数据';

  @override
  String get scanId => '扫描ID';

  @override
  String get dateAndTime => '日期和时间';

  @override
  String get reuseThisData => '重用此数据';

  @override
  String get writeToNfc => '写入NFC';

  @override
  String get writeDataToChip => '将数据写入芯片';

  @override
  String get writeSuccess => '写入成功！';

  @override
  String get writeError => '写入错误';

  @override
  String get brand => '品牌';

  @override
  String get selectBrand => '选择品牌';

  @override
  String get materialType => '材料类型';

  @override
  String get selectMaterial => '选择材料';

  @override
  String get serialNumber => '序列号';

  @override
  String get serialNumberHint => '例如：001';

  @override
  String get initialWeight => '初始重量';

  @override
  String get initialWeightHint => '例如：1000';

  @override
  String get extruderTempMin => '挤出机温度最小';

  @override
  String get extruderTempMax => '挤出机温度最大';

  @override
  String get bedTempMin => '热床温度最小';

  @override
  String get bedTempMax => '热床温度最大';

  @override
  String get diameter => '直径';

  @override
  String get spoolLength => '长度 (m)';

  @override
  String get generatedSku => '生成的SKU';

  @override
  String get approachChipToWrite => '靠近芯片进行写入...';

  @override
  String get writing => '写入中...';

  @override
  String get chooseColor => '选择颜色';

  @override
  String get required => '必填';

  @override
  String get invalid => '无效';

  @override
  String get advancedSettings => '高级设置';

  @override
  String get opacity => '不透明度';

  @override
  String get validate => '验证';

  @override
  String get nfcTagInfo => '使用空白ISO14443A NFC标签（NTAG213）创建您自己的Anycubic标签。';

  @override
  String get stockInventory => '库存线轴';

  @override
  String get addSpool => '添加线轴';

  @override
  String get scanSpool => '扫描线轴';

  @override
  String get addManually => '手动添加';

  @override
  String get spoolAdded => '线轴已添加';

  @override
  String get spoolUpdated => '线轴已更新';

  @override
  String get noSpoolsInStock => '库存中无线轴';

  @override
  String get addFirstSpool => '添加您的第一个线轴以开始跟踪库存';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count个线轴库存不足（< $threshold%）';
  }

  @override
  String get edit => '编辑';

  @override
  String get bobbinPrice => '线轴价格';

  @override
  String get price => '价格';

  @override
  String get priceHint => '例如：25.00';

  @override
  String get save => '保存';

  @override
  String get spoolDetails => '线轴详情';

  @override
  String get deleteThisSpool => '删除此线轴？';

  @override
  String get cannotBeUndone => '此操作无法撤消。';

  @override
  String get addSpoolManually => '手动添加线轴';

  @override
  String get editSpool => '编辑线轴';

  @override
  String get customBrand => '自定义品牌';

  @override
  String get customBrandHint => '例如：我的品牌';

  @override
  String get chooseFromList => '从列表中选择';

  @override
  String get addBrand => '+ 添加品牌';

  @override
  String get customMaterial => '自定义材料';

  @override
  String get customMaterialHint => '例如：我的材料';

  @override
  String get addMaterial => '+ 添加材料';

  @override
  String get colorHint => '例如：蓝色、红色...';

  @override
  String get enterColor => '请输入颜色';

  @override
  String get initialWeightG => '初始重量';

  @override
  String get remainingWeightG => '剩余重量';

  @override
  String get enterBrand => '请输入品牌';

  @override
  String get selectOrEnterBrand => '请选择或输入品牌';

  @override
  String get quantity => '数量';

  @override
  String get quantityHelper => '一次添加多个相同的线轴';

  @override
  String get quantityInvalid => '输入 1 到 99 之间的数字';

  @override
  String spoolsInStockCount(int count) {
    return '库存 $count 个';
  }

  @override
  String get enterMaterial => '请输入材料';

  @override
  String get selectOrEnterMaterial => '请选择或输入材料';

  @override
  String get enterPrice => '请输入价格';

  @override
  String get enterValidPrice => '请输入有效价格';

  @override
  String get enterWeight => '请输入重量';

  @override
  String get enterValidWeight => '请输入有效重量';

  @override
  String get remainingCannotExceedTotal => '剩余重量不能超过总重量';

  @override
  String get overview => '概览';

  @override
  String get spoolsInStock => '库存线轴';

  @override
  String get totalValue => '总价值';

  @override
  String get lowStockSpools => '低库存';

  @override
  String get materialDistribution => '按材料分布';

  @override
  String get brandDistribution => '按品牌分布';

  @override
  String get noData => '无数据';

  @override
  String get refresh => '刷新';

  @override
  String get profileSettings => '个人资料设置';

  @override
  String get preferences => '偏好设置';

  @override
  String get language => '语言';

  @override
  String get selectLanguage => '选择语言';

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
  String get currency => '货币';

  @override
  String get selectCurrency => '选择货币';

  @override
  String get units => '单位';

  @override
  String get selectUnits => '选择单位';

  @override
  String get metric => '公制 (mm, g, °C)';

  @override
  String get imperial => '英制 (in, oz, °F)';

  @override
  String get lowStockThreshold => '低库存警报阈值';

  @override
  String get lowStockThresholdDesc => '如果剩余重量小于此百分比，线轴将被视为低库存';

  @override
  String get authentication => '认证';

  @override
  String get signInWithGoogle => '使用Google登录';

  @override
  String get signInWithApple => '使用Apple登录';

  @override
  String get continueWithApple => '使用Apple继续';

  @override
  String get continueWithGoogle => '使用Google继续';

  @override
  String get comingSoon => '即将推出';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get madeWith => '为Anycubic 3D打印机用❤️制作';

  @override
  String get scanBobbinDirectly => '扫描线轴';

  @override
  String get nfcEncoder => 'NFC编码器';

  @override
  String get length => '长度';

  @override
  String get tempExtruder => '挤出机温度';

  @override
  String get tempBed => '热床温度';

  @override
  String get termsOfService => '服务条款';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get legal => '法律信息';

  @override
  String get back => '返回';

  @override
  String get retry => '重试';

  @override
  String get signOut => '退出登录';

  @override
  String get extruderTempMinHint => '例如：200';

  @override
  String get extruderTempMaxHint => '例如：220';

  @override
  String get bedTempMinHint => '例如：50';

  @override
  String get bedTempMaxHint => '例如：60';

  @override
  String get diameterHint => '例如：1.75';

  @override
  String get spoolLengthHint => '例如：330';

  @override
  String get tabGrid => '网格';

  @override
  String get tabSpectrum => '光谱';

  @override
  String get tabSliders => '滑块';

  @override
  String get hexCode => '十六进制代码';

  @override
  String get red => '红色';

  @override
  String get green => '绿色';

  @override
  String get blue => '蓝色';

  @override
  String get black => '黑色';

  @override
  String get white => '白色';

  @override
  String get yellow => '黄色';

  @override
  String get orange => '橙色';

  @override
  String get pink => '粉色';

  @override
  String get purple => '紫色';

  @override
  String get gray => '灰色';

  @override
  String get brown => '棕色';

  @override
  String get unknown => '未知';

  @override
  String get metricUnits => '公制 (mm, g, °C)';

  @override
  String get imperialUnits => '英制 (in, oz, °F)';

  @override
  String get chf => '瑞士法郎 (CHF)';

  @override
  String get eur => '欧元 (€)';

  @override
  String get usd => '美元 (\$)';

  @override
  String get gbp => '英镑 (£)';

  @override
  String get cad => '加元 (CAD)';

  @override
  String get aud => '澳元 (A\$)';

  @override
  String get jpy => '日元 (¥)';

  @override
  String get cny => '人民币 (¥)';

  @override
  String get inr => '印度卢比 (₹)';

  @override
  String get brl => '巴西雷亚尔 (R\$)';

  @override
  String get mxn => '墨西哥比索 (MX\$)';

  @override
  String get sek => '瑞典克朗 (kr)';

  @override
  String get nok => '挪威克朗 (kr)';

  @override
  String get dkk => '丹麦克朗 (kr)';

  @override
  String get pln => '波兰兹罗提 (zł)';

  @override
  String get czk => '捷克克朗 (Kč)';

  @override
  String get nzd => '新西兰元 (NZ\$)';

  @override
  String get filamentsToOrder => '待订购耗材';

  @override
  String get shoppingList => '购物清单';

  @override
  String get addToShoppingList => '添加到清单';

  @override
  String get noLowStockFilaments => '没有低库存耗材';

  @override
  String get vipSubscriptionDescription => '此订阅仅用于禁用应用内广告和支持项目。无其他功能。';

  @override
  String get monthlySubscription => '月度订阅';

  @override
  String get yearlySubscription => '年度订阅';

  @override
  String get perMonth => '/ 月';

  @override
  String get perYear => '/ 年';

  @override
  String onlyPerMonth(String price) {
    return '仅$price / 月';
  }

  @override
  String get subscribe => '订阅';

  @override
  String get bestOffer => '✨ 最佳优惠 ✨';

  @override
  String get forAnycubicAce => '适用于Anycubic Ace';

  @override
  String get forBambuLabAms => '适用于 Bambu Lab AMS';

  @override
  String get scanNfcChip => '扫描NFC芯片';

  @override
  String get fillForm => '填写表单';

  @override
  String get emptyShoppingList => '清单中无耗材';

  @override
  String percentRemaining(String percent) {
    return '剩余$percent%';
  }

  @override
  String get markAsOrdered => '标记为已订购';

  @override
  String get markAsNotOrdered => '标记为未订购';

  @override
  String get notSignedIn => '未登录';

  @override
  String get signIn => '登录';

  @override
  String get connection => '登录';

  @override
  String get signInToSync => '登录以同步您的数据';

  @override
  String get continueWithoutAccount => '不使用账户继续（本地模式）';

  @override
  String get privacyNotice => '登录即表示您接受我们的\n使用条款和隐私政策';

  @override
  String get updateStock => '更新库存';

  @override
  String get scanToUpdateStock => '扫描以更新';

  @override
  String get weightUsed => '使用的重量';

  @override
  String get lengthUsed => '使用的长度';

  @override
  String get enterWeightOrLength => '输入使用的重量或长度';

  @override
  String get weightUsedG => '使用的重量 (g)';

  @override
  String get lengthUsedM => '使用的长度 (m)';

  @override
  String get stockUpdated => '库存已更新';

  @override
  String get scanSpoolToUpdate => '扫描线轴以更新其库存';

  @override
  String get spoolNotFound => '在库存中未找到线轴';

  @override
  String get addSpoolFirstMessage => '此线轴尚未在您的库存中。在更新其库存之前，请先使用\"添加线轴\"按钮添加它。';

  @override
  String get ok => '确定';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: 只读';

  @override
  String get bambuLabReadOnlyDesc => 'Bambu Lab标签使用RSA加密，无法修改。只读。';

  @override
  String get forPrusaMk4 => '适用于 Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: 读取和写入';

  @override
  String get prusaReadWriteDesc =>
      'Prusa标签使用ISO 15693 (NFC-V) OpenPrintTag格式。支持读取和写入。';

  @override
  String get bambuCloneLibrary => 'Bambu Lab克隆库';

  @override
  String get noBambuClones => '无Bambu Lab克隆';

  @override
  String get scanBambuToClone => '扫描Bambu Lab原装标签以创建克隆库';

  @override
  String get scanTag => '扫描标签';

  @override
  String get syncWithCloud => '与云同步';

  @override
  String get syncCompleted => '同步完成';

  @override
  String get deleteClone => '删除克隆';

  @override
  String get renameClone => '重命名克隆';

  @override
  String get rename => '重命名';

  @override
  String get customName => '自定义名称';

  @override
  String get clonedOn => '克隆于';

  @override
  String get writeThisClone => '写入此克隆';

  @override
  String get writeClone => '写入克隆';

  @override
  String get writeOnCUID => '写入CUID卡';

  @override
  String get cloneWrittenSuccess => '克隆写入成功！';

  @override
  String get requiredTagFormat => '所需标签格式';

  @override
  String get type => '类型';

  @override
  String get frequency => '频率';

  @override
  String get protocol => '协议';

  @override
  String get capacity => '容量';

  @override
  String get feature => '功能';

  @override
  String get uidModifiable => '块0（UID）可修改';

  @override
  String get whereToBuy =>
      '在AliExpress、Amazon或eBay上搜索\"CUID MiFare Classic 1K\"（约0.50美元/张）';

  @override
  String get magicGen2Required =>
      'Magic Gen2卡 - 具有可写Block 0 (UID)的MiFare Classic 1K';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      '在AliExpress、Amazon或eBay上搜索\"Magic Gen2 MiFare Classic 1K\"或\"UID writable\"（约\$0.50/张）';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ 警告：使用iPhone NFC写入可能无法在所有Magic Gen2卡上工作。建议使用Proxmark3设备以获得最大可靠性。';

  @override
  String get step1GetMagicGen2 => '获取空白Magic Gen2卡（具有可写UID的MiFare Classic 1K）';

  @override
  String get instructions => '说明';

  @override
  String get step1GetCUID => '获取空白CUID卡（MiFare Classic 1K）';

  @override
  String get step2PressWrite => '按下面的\"写入\"按钮';

  @override
  String get step3HoldPhone => '将手机靠近CUID卡';

  @override
  String get step4WaitConfirm => '等待写入确认';

  @override
  String get step5TestClone => '在Bambu Lab打印机上测试克隆标签！';

  @override
  String get rsaIncluded => '克隆包含原始RSA签名，将被打印机接受！';

  @override
  String get cloneDeleted => '克隆已删除';

  @override
  String get deleteAccount => '删除我的账户';

  @override
  String get deleteAccountConfirmation => '此操作不可撤销。您的账户和所有数据将在30天内删除。';

  @override
  String get accountDeletionRequested => '删除请求已登记';

  @override
  String get clearShoppingList => '清空列表';

  @override
  String get clearShoppingListConfirmation => '确定要清空整个购物清单吗？此操作无法撤消。';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => '历史';

  @override
  String get retryButton => '重试';

  @override
  String get readSuccessMessage => '读取成功！';

  @override
  String get filamentTypeLabel => '耗材类型';

  @override
  String get scanNfcChipButton => '扫描NFC芯片';

  @override
  String deleteCloneConfirmation(String name) {
    return '删除克隆「$name」？';
  }

  @override
  String cloneDeletedMessage(String name) {
    return '克隆「$name」已删除';
  }

  @override
  String get extruderLabel => '挤出机';

  @override
  String get writeThisCloneButton => '写入此克隆';

  @override
  String get customNameHint => '自定义名称';

  @override
  String get cloneWriteSuccessMessage => '克隆写入成功！';

  @override
  String errorPrefix(String error) {
    return '错误: $error';
  }

  @override
  String get writingInProgress => '写入中...';

  @override
  String get writeOnCUIDButton => '写入CUID卡';

  @override
  String get diameterLabel => '直径';

  @override
  String get extruderTempLabel => '挤出机温度';

  @override
  String get bedTempLabel => '热床温度';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K字节 (1024字节)';

  @override
  String get rsaSignatureNote => '克隆包含原始RSA签名，打印机将接受它！';

  @override
  String get writeBambuLabTagTitle => '写入Bambu Lab标签';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab标签写入成功！';

  @override
  String get approachNfcTagMessage => '请靠近NFC标签...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab格式 (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab格式';

  @override
  String get bambuLabFormatInfo => '此格式使用Bambu Lab材料代码，并以AMS兼容格式存储数据。';

  @override
  String get brandLabel => '品牌';

  @override
  String get materialTypeLabel => '材料类型';

  @override
  String get serialNumber3Digits => '序列号 (3位)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (标准)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => '写入Bambu Lab标签';

  @override
  String get bambuLabRsaNote => '注意：原装Bambu Lab标签使用RSA加密。此模式以简化的兼容格式写入数据。';

  @override
  String signInError(String error) {
    return '登录错误: $error';
  }

  @override
  String get subscriptionActivatedMessage => '订阅已激活！';

  @override
  String get subscriptionFailedMessage => '订阅失败';

  @override
  String errorMessage(String error) {
    return '错误: $error';
  }

  @override
  String get subscriptionRestoredMessage => '订阅已恢复！';

  @override
  String get noSubscriptionFoundMessage => '未找到订阅';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => '活跃';

  @override
  String get noAdsExperienceMessage => '享受无广告体验！';

  @override
  String get subscribedLabel => '已订阅';

  @override
  String get restorePurchasesButton => '恢复购买';

  @override
  String get cannotExceedRemainingWeight => '不能超过剩余重量';

  @override
  String get pleaseEnterLength => '请输入长度';

  @override
  String get pleaseEnterValidLength => '请输入有效长度';

  @override
  String get spoolLengthNotSetCannotConvert => '未设置线轴长度 - 无法转换';

  @override
  String get exceedsRemainingWeight => '超过剩余重量';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => '帮助我们识别这种耗材';

  @override
  String get helpUsImprove => '帮助我们改进！';

  @override
  String get helpIdentifyDescription => '我们读取了芯片但无法识别。请告诉我们这是什么耗材，以便我们改进应用。';

  @override
  String get otherBrand => '其他';

  @override
  String get thankYouFeedback => '感谢您的反馈！';

  @override
  String get send => '发送';

  @override
  String get optionalDetails => '可选详情';

  @override
  String get weightGrams => '重量 (g)';

  @override
  String get diameterMm => '直径 (mm)';

  @override
  String get spoolLengthM => '线轴长度 (m)';

  @override
  String get batchNumberLabel => '批次 / SKU';

  @override
  String get contactUs => '联系我们';

  @override
  String get contactUsSubtitle => '问题、建议或反馈';

  @override
  String get nfcTagNotDetected => '未检测到NFC标签';

  @override
  String get nfcTagNotDetectedDesc => '未找到标签。标签可能已损坏或距离手机太远。';

  @override
  String get nfcTagIncompatible => '检测到不兼容的NFC标签';

  @override
  String get nfcAuthError => 'NFC标签认证失败';

  @override
  String get nfcAuthErrorDesc => '已检测到标签，但多次尝试后认证失败。请将标签紧贴手机背面并重试。';

  @override
  String get nfcTagInfoPrusa =>
      '使用空白NXP ICODE SLIX2标签(ISO 15693)为Prusa MK4/XL创建OpenPrintTag兼容标签。';

  @override
  String get writePrusaTagTitle => '写入Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable => '此设备不支持通过Apple登录。';

  @override
  String get signInAppleFailed => '通过Apple登录失败。请重试。';

  @override
  String get signInFailed => '登录失败。请重试。';

  @override
  String get mustContain3Digits => '必须包含3位数字';

  @override
  String get mustBeNumber => '必须是数字';

  @override
  String generatedUidLabel(String uid) {
    return '生成的UID：$uid';
  }

  @override
  String get experimentalBadge => '实验性';

  @override
  String get newBadge => '新';

  @override
  String get forCrealityCfs => '适用于Creality CFS';

  @override
  String get crealityReadWrite => 'Creality：读取和写入';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS标签使用AES-128-ECB加密的MiFare Classic 1K。';

  @override
  String get platformLimitationTitle => '平台限制';

  @override
  String get mifareClassicNotSupportedIos =>
      '由于Apple CoreNFC限制，iOS不支持MiFare Classic标签（Bambu Lab、Creality）。';

  @override
  String get nfcTagInfoCreality =>
      '使用MiFare Classic 1K标签写入Creality CFS兼容数据（适用于Creality K2 Plus）。';

  @override
  String get colorHintExamples => '红色、蓝色、黑色...';

  @override
  String get dryingTemp => '干燥温度';

  @override
  String get dryingTempHint => '例如 55';

  @override
  String get dryingTime => '干燥时间（小时）';

  @override
  String get dryingTimeHint => '例如 8';

  @override
  String fallbackDetectedAs(String mode) {
    return '标签检测为$mode — 下次扫描请切换标签页';
  }

  @override
  String get fallbackChooseMode => '手动选择模式';

  @override
  String get fallbackChooseModeSubtitle => '自动检测无法识别此标签。请选择协议：';

  @override
  String get tryAutoDetect => '尝试自动检测';

  @override
  String get autoDetectAllBrands => '自动检测 — 所有品牌';

  @override
  String get autoDetectAllBrandsDesc => 'Anycubic、Elegoo、OpenSpool、OpenTag3D 等';

  @override
  String get nfcTipIos => 'NFC读卡器位于iPhone顶部。请将其直接放在线轴的NFC标签上。';

  @override
  String get nfcTipAndroid => 'NFC读卡器通常位于手机背面中央。请将手机背面放在线轴的NFC标签上。';

  @override
  String get stockSortBy => '排序';

  @override
  String get stockFilter => '筛选';

  @override
  String get stockSortRecent => '最新';

  @override
  String get stockSortBrand => '品牌';

  @override
  String get stockSortMaterial => '材料';

  @override
  String get stockSortRemaining => '剩余重量';

  @override
  String get stockSortColor => '颜色';

  @override
  String get stockFilterAll => '全部';

  @override
  String get stockResetFilters => '重置';

  @override
  String get stockNoMatch => '没有符合筛选条件的线卷';

  @override
  String get nfcDisabledTitle => 'NFC 已关闭';

  @override
  String get nfcDisabledMessage => 'NFC 已关闭。请在手机设置中开启，以扫描线卷。';

  @override
  String get updateAvailableTitle => '有可用更新';

  @override
  String get updateAvailableMessage => 'Spool Master 有新版本可用。';

  @override
  String get updateForcedMessage => '此版本已不再受支持。请更新以继续。';

  @override
  String get updateNow => '更新';

  @override
  String get updateLater => '稍后';

  @override
  String get nfcScanGuidance => '将标签靠在手机顶部或背面并保持不动。';

  @override
  String get tagMovedTitle => '标签移动了';

  @override
  String get tagMovedMessage => '读取时标签移动了。请重新贴合并保持手机不动。';

  @override
  String get lightBlue => '浅蓝色';

  @override
  String get transparent => '透明';

  @override
  String get nfcActiveApproachTag => 'NFC已激活 — 请靠近标签';

  @override
  String addedToShoppingList(String item) {
    return '$item 已添加到购物清单';
  }

  @override
  String get deleteAccountFailed => '删除账户失败,请重试。';

  @override
  String get scanHistoryError => '访问扫描历史时出错';

  @override
  String get genericBrand => '通用';

  @override
  String get stockSearchHint => '搜索（品牌、颜色、位置…）';

  @override
  String get stockMoreActions => '更多操作';

  @override
  String get exportExcel => '导出为 Excel';

  @override
  String get exportFailed => '导出失败';

  @override
  String get exportShareSubject => '我的耗材库存（Spool Master）';

  @override
  String get exportColorHex => '颜色代码';

  @override
  String get exportRemainingPercent => '剩余（%）';

  @override
  String get exportPricePerKg => '价格 / kg';

  @override
  String get exportAddedDate => '添加日期';

  @override
  String get exportOrdered => '已订购';

  @override
  String get exportDate => '日期';

  @override
  String get exportGrams => '克数';

  @override
  String get exportCost => '成本';

  @override
  String get importSpools => '导入（CSV / Excel）';

  @override
  String get importConfirmTitle => '导入线轴';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return '待添加线轴：$count\n库存中已有（已跳过）：$duplicates\n无法读取的行（已跳过）：$skipped';
  }

  @override
  String get importAction => '导入';

  @override
  String get importNothingFound =>
      '未识别到任何线轴。文件至少须包含“材料”和“重量”列（与应用的 Excel 导出一致）。';

  @override
  String importDone(int count) {
    return '已导入线轴：$count';
  }

  @override
  String get importFailed => '文件无法读取';

  @override
  String get location => '位置';

  @override
  String get locationHint => '例如：A 层架，干燥盒 2';

  @override
  String get notes => '备注';

  @override
  String get notesHint => '例如：使用前需烘干';

  @override
  String get printCostTitle => '打印成本';

  @override
  String get printCostGrams => '已用耗材（g）';

  @override
  String printCostResult(String cost) {
    return '材料成本：$cost';
  }

  @override
  String printCostPerKg(String price) {
    return '每 kg 价格：$price';
  }

  @override
  String get printCostNoPrice => '请添加线轴价格以计算成本。';

  @override
  String get printCostDeduct => '从库存中扣除';

  @override
  String printCostDeducted(String grams) {
    return '已从库存中扣除 $grams g';
  }

  @override
  String get consumptionTitle => '消耗';

  @override
  String get consumptionLast30Days => '最近 30 天';

  @override
  String get consumptionThisMonth => '本月';

  @override
  String get consumptionByMaterial => '按材料（30 天）';

  @override
  String get consumptionMonthly => '最近 6 个月';

  @override
  String get consumptionEmpty => '暂无消耗记录。更新线轴剩余重量或使用成本计算器后即会显示。';

  @override
  String get shareShoppingList => '分享清单';

  @override
  String get nfcBlankTagTitle => '空白标签';

  @override
  String get nfcBlankTagDesc => '此标签不包含耗材盘数据。请手动添加耗材盘，或在应用中写入此标签。';

  @override
  String get subscriptionAutoRenewDisclosure =>
      '购买确认时，款项将从您的商店账户中扣除。除非在当前订阅周期结束前至少24小时取消，否则订阅将自动续订；续订费用将在周期结束前24小时内扣除。您可以在商店账户设置中管理或取消订阅。';

  @override
  String get manageSubscription => '管理订阅';

  @override
  String get subscriptionPendingMessage => '付款等待确认：确认后订阅将立即激活。';

  @override
  String subscriptionEndsOn(String date) {
    return '已关闭自动续订：可使用至 $date';
  }
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => '庫存';

  @override
  String get statistics => '統計';

  @override
  String get profile => '個人資料';

  @override
  String get readNfcChip => '讀取NFC晶片';

  @override
  String get scanHistory => '歷史記錄';

  @override
  String get writeNfcChip => '寫入NFC晶片';

  @override
  String get nfcNotAvailable => 'NFC不可用';

  @override
  String get nfcNotAvailableDesc => '您的裝置不支援NFC或已停用。';

  @override
  String get nfcNotSupported => '此裝置不支援NFC';

  @override
  String get approachNfcChip => '靠近NFC芯片...';

  @override
  String get scanningNfc => '掃描中...';

  @override
  String get nfcDataRead => 'NFC資料讀取成功！';

  @override
  String get errorReadingNfc => 'NFC讀取錯誤';

  @override
  String get scanHistoryTitle => '掃描歷史';

  @override
  String get noScansRecorded => '無掃描記錄';

  @override
  String get scansWillAppearHere => 'NFC掃描將自動顯示在此處';

  @override
  String get clearAll => '全部清除';

  @override
  String get deleteThisScan => '刪除此掃描？';

  @override
  String get actionIrreversible => '此操作不可逆。';

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get clearAllHistory => '清除所有歷史記錄？';

  @override
  String get allScansWillBeDeleted => '所有掃描將被刪除。此操作不可逆。';

  @override
  String get scanDeleted => '掃描已刪除';

  @override
  String get scanDetails => '掃描詳情';

  @override
  String scannedOn(Object date) {
    return '掃描於$date';
  }

  @override
  String get bobbinInformation => '線軸資訊';

  @override
  String get filamentType => '耗材類型';

  @override
  String get color => '顏色';

  @override
  String get weight => '重量';

  @override
  String get manufacturingDate => '生產日期';

  @override
  String get batchNumber => '批次號';

  @override
  String get printerSettings => '印表機設定';

  @override
  String get scanMetadata => '掃描後設資料';

  @override
  String get scanId => '掃描ID';

  @override
  String get dateAndTime => '日期和時間';

  @override
  String get reuseThisData => '重用此資料';

  @override
  String get writeToNfc => '寫入NFC';

  @override
  String get writeDataToChip => '將資料寫入晶片';

  @override
  String get writeSuccess => '寫入成功！';

  @override
  String get writeError => '寫入錯誤';

  @override
  String get brand => '品牌';

  @override
  String get selectBrand => '選擇品牌';

  @override
  String get materialType => '材料類型';

  @override
  String get selectMaterial => '選擇材料';

  @override
  String get serialNumber => '序列號';

  @override
  String get serialNumberHint => '例如：001';

  @override
  String get initialWeight => '初始重量';

  @override
  String get initialWeightHint => '例如：1000';

  @override
  String get extruderTempMin => '擠出機溫度最小';

  @override
  String get extruderTempMax => '擠出機溫度最大';

  @override
  String get bedTempMin => '熱床溫度最小';

  @override
  String get bedTempMax => '熱床溫度最大';

  @override
  String get diameter => '直徑';

  @override
  String get spoolLength => '長度 (m)';

  @override
  String get generatedSku => '生成的SKU';

  @override
  String get approachChipToWrite => '靠近晶片進行寫入...';

  @override
  String get writing => '寫入中...';

  @override
  String get chooseColor => '選擇顏色';

  @override
  String get required => '必填';

  @override
  String get invalid => '無效';

  @override
  String get advancedSettings => '高階設定';

  @override
  String get opacity => '不透明度';

  @override
  String get validate => '驗證';

  @override
  String get nfcTagInfo => '使用空白ISO14443A NFC標籤（NTAG213）建立您自己的Anycubic標籤。';

  @override
  String get stockInventory => '庫存線軸';

  @override
  String get addSpool => '新增線軸';

  @override
  String get scanSpool => '掃描線軸';

  @override
  String get addManually => '手動新增';

  @override
  String get spoolAdded => '線軸已新增';

  @override
  String get spoolUpdated => '線軸已更新';

  @override
  String get noSpoolsInStock => '庫存中無線軸';

  @override
  String get addFirstSpool => '新增您的第一個線軸以開始追蹤庫存';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count個線軸庫存不足（< $threshold%）';
  }

  @override
  String get edit => '編輯';

  @override
  String get bobbinPrice => '線軸價格';

  @override
  String get price => '價格';

  @override
  String get priceHint => '例如：25.00';

  @override
  String get save => '保存';

  @override
  String get spoolDetails => '線軸詳情';

  @override
  String get deleteThisSpool => '刪除此線軸？';

  @override
  String get cannotBeUndone => '此操作無法撤消。';

  @override
  String get addSpoolManually => '手動新增線軸';

  @override
  String get editSpool => '編輯線軸';

  @override
  String get customBrand => '自定義品牌';

  @override
  String get customBrandHint => '例如：我的品牌';

  @override
  String get chooseFromList => '從列表中選擇';

  @override
  String get addBrand => '+ 添加品牌';

  @override
  String get customMaterial => '自定義材料';

  @override
  String get customMaterialHint => '例如：我的材料';

  @override
  String get addMaterial => '+ 添加材料';

  @override
  String get colorHint => '例如：藍色、紅色...';

  @override
  String get enterColor => '請輸入顏色';

  @override
  String get initialWeightG => '初始重量';

  @override
  String get remainingWeightG => '剩餘重量';

  @override
  String get enterBrand => '請輸入品牌';

  @override
  String get selectOrEnterBrand => '請選擇或輸入品牌';

  @override
  String get quantity => '數量';

  @override
  String get quantityHelper => '一次新增多個相同的線軸';

  @override
  String get quantityInvalid => '輸入 1 到 99 之間的數字';

  @override
  String spoolsInStockCount(int count) {
    return '庫存 $count 個';
  }

  @override
  String get enterMaterial => '請輸入材料';

  @override
  String get selectOrEnterMaterial => '請選擇或輸入材料';

  @override
  String get enterPrice => '請輸入價格';

  @override
  String get enterValidPrice => '請輸入有效價格';

  @override
  String get enterWeight => '請輸入重量';

  @override
  String get enterValidWeight => '請輸入有效重量';

  @override
  String get remainingCannotExceedTotal => '剩餘重量不能超過總重量';

  @override
  String get overview => '概覽';

  @override
  String get spoolsInStock => '庫存線軸';

  @override
  String get totalValue => '總價值';

  @override
  String get lowStockSpools => '低庫存';

  @override
  String get materialDistribution => '按材料分佈';

  @override
  String get brandDistribution => '按品牌分佈';

  @override
  String get noData => '無資料';

  @override
  String get refresh => '刷新';

  @override
  String get profileSettings => '個人資料設定';

  @override
  String get preferences => '偏好設定';

  @override
  String get language => '語言';

  @override
  String get selectLanguage => '選擇語言';

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
  String get currency => '貨幣';

  @override
  String get selectCurrency => '選擇貨幣';

  @override
  String get units => '單位';

  @override
  String get selectUnits => '選擇單位';

  @override
  String get metric => '公制 (mm, g, °C)';

  @override
  String get imperial => '英制 (in, oz, °F)';

  @override
  String get lowStockThreshold => '低庫存警報閾值';

  @override
  String get lowStockThresholdDesc => '如果剩餘重量小於此百分比，線軸將被視為低庫存';

  @override
  String get authentication => '認證';

  @override
  String get signInWithGoogle => '使用Google登入';

  @override
  String get signInWithApple => '使用Apple登入';

  @override
  String get continueWithApple => '使用Apple繼續';

  @override
  String get continueWithGoogle => '使用Google繼續';

  @override
  String get comingSoon => '即將推出';

  @override
  String get about => '關於';

  @override
  String get version => '版本';

  @override
  String get madeWith => '為Anycubic 3D印表機用❤️製作';

  @override
  String get scanBobbinDirectly => '掃描線軸';

  @override
  String get nfcEncoder => 'NFC編碼器';

  @override
  String get length => '長度';

  @override
  String get tempExtruder => '擠出機溫度';

  @override
  String get tempBed => '熱床溫度';

  @override
  String get termsOfService => '服務條款';

  @override
  String get privacyPolicy => '隱私政策';

  @override
  String get legal => '法律資訊';

  @override
  String get back => '返回';

  @override
  String get retry => '重試';

  @override
  String get signOut => '登出';

  @override
  String get extruderTempMinHint => '例如：200';

  @override
  String get extruderTempMaxHint => '例如：220';

  @override
  String get bedTempMinHint => '例如：50';

  @override
  String get bedTempMaxHint => '例如：60';

  @override
  String get diameterHint => '例如：1.75';

  @override
  String get spoolLengthHint => '例如：330';

  @override
  String get tabGrid => '網格';

  @override
  String get tabSpectrum => '光譜';

  @override
  String get tabSliders => '滑塊';

  @override
  String get hexCode => '十六進位代碼';

  @override
  String get red => '紅色';

  @override
  String get green => '綠色';

  @override
  String get blue => '藍色';

  @override
  String get black => '黑色';

  @override
  String get white => '白色';

  @override
  String get yellow => '黃色';

  @override
  String get orange => '橙色';

  @override
  String get pink => '粉色';

  @override
  String get purple => '紫色';

  @override
  String get gray => '灰色';

  @override
  String get brown => '棕色';

  @override
  String get unknown => '未知';

  @override
  String get metricUnits => '公制 (mm, g, °C)';

  @override
  String get imperialUnits => '英制 (in, oz, °F)';

  @override
  String get chf => '瑞士法郎 (CHF)';

  @override
  String get eur => '歐元 (€)';

  @override
  String get usd => '美元 (\$)';

  @override
  String get gbp => '英鎊 (£)';

  @override
  String get cad => '加元 (CAD)';

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
  String get filamentsToOrder => '待訂購耗材';

  @override
  String get shoppingList => '購物清單';

  @override
  String get addToShoppingList => '新增到清單';

  @override
  String get noLowStockFilaments => '沒有低庫存耗材';

  @override
  String get vipSubscriptionDescription => '此訂閱僅用於停用應用內廣告和支持專案。無其他功能。';

  @override
  String get monthlySubscription => '月度訂閱';

  @override
  String get yearlySubscription => '年度訂閱';

  @override
  String get perMonth => '/ 月';

  @override
  String get perYear => '/ 年';

  @override
  String onlyPerMonth(String price) {
    return '僅$price / 月';
  }

  @override
  String get subscribe => '訂閱';

  @override
  String get bestOffer => '✨ 最佳優惠 ✨';

  @override
  String get forAnycubicAce => '適用於Anycubic Ace';

  @override
  String get forBambuLabAms => '適用於 Bambu Lab AMS';

  @override
  String get scanNfcChip => '掃描NFC晶片';

  @override
  String get fillForm => '填寫表單';

  @override
  String get emptyShoppingList => '清單中無耗材';

  @override
  String percentRemaining(String percent) {
    return '剩餘$percent%';
  }

  @override
  String get markAsOrdered => '標記為已訂購';

  @override
  String get markAsNotOrdered => '標記為未訂購';

  @override
  String get notSignedIn => '未登入';

  @override
  String get signIn => '登入';

  @override
  String get connection => '登入';

  @override
  String get signInToSync => '登入以同步您的資料';

  @override
  String get continueWithoutAccount => '不使用賬戶繼續（本地模式）';

  @override
  String get privacyNotice => '登入即表示您接受我們的\n使用條款和隱私政策';

  @override
  String get updateStock => '更新庫存';

  @override
  String get scanToUpdateStock => '掃描以更新';

  @override
  String get weightUsed => '使用的重量';

  @override
  String get lengthUsed => '使用的長度';

  @override
  String get enterWeightOrLength => '輸入使用的重量或長度';

  @override
  String get weightUsedG => '使用的重量 (g)';

  @override
  String get lengthUsedM => '使用的長度 (m)';

  @override
  String get stockUpdated => '庫存已更新';

  @override
  String get scanSpoolToUpdate => '掃描線軸以更新其庫存';

  @override
  String get spoolNotFound => '在庫存中未找到線軸';

  @override
  String get addSpoolFirstMessage => '此線軸尚未在您的庫存中。在更新其庫存之前，請先使用\"新增線軸\"按鈕新增它。';

  @override
  String get ok => '確定';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: 只讀';

  @override
  String get bambuLabReadOnlyDesc => 'Bambu Lab標籤使用RSA加密，無法修改。只讀。';

  @override
  String get forPrusaMk4 => '適用於 Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: 讀取和寫入';

  @override
  String get prusaReadWriteDesc =>
      'Prusa標籤使用ISO 15693 (NFC-V) OpenPrintTag格式。支持讀取和寫入。';

  @override
  String get bambuCloneLibrary => 'Bambu Lab克隆庫';

  @override
  String get noBambuClones => '無Bambu Lab克隆';

  @override
  String get scanBambuToClone => '掃描Bambu Lab原裝標籤以建立克隆庫';

  @override
  String get scanTag => '掃描標籤';

  @override
  String get syncWithCloud => '與雲同步';

  @override
  String get syncCompleted => '同步完成';

  @override
  String get deleteClone => '刪除克隆';

  @override
  String get renameClone => '重命名克隆';

  @override
  String get rename => '重命名';

  @override
  String get customName => '自定義名稱';

  @override
  String get clonedOn => '克隆於';

  @override
  String get writeThisClone => '寫入此克隆';

  @override
  String get writeClone => '寫入克隆';

  @override
  String get writeOnCUID => '寫入CUID卡';

  @override
  String get cloneWrittenSuccess => '克隆寫入成功！';

  @override
  String get requiredTagFormat => '所需標籤格式';

  @override
  String get type => '類型';

  @override
  String get frequency => '頻率';

  @override
  String get protocol => '協議';

  @override
  String get capacity => '容量';

  @override
  String get feature => '功能';

  @override
  String get uidModifiable => '塊0（UID）可修改';

  @override
  String get whereToBuy =>
      '在AliExpress、Amazon或eBay上搜尋\"CUID MiFare Classic 1K\"（約0.50美元/張）';

  @override
  String get magicGen2Required =>
      'Magic Gen2卡 - 具有可寫Block 0 (UID)的MiFare Classic 1K';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      '在AliExpress、Amazon或eBay上搜尋\"Magic Gen2 MiFare Classic 1K\"或\"UID writable\"（約\$0.50/張）';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ 警告：使用iPhone NFC寫入可能無法在所有Magic Gen2卡上工作。建議使用Proxmark3裝置以獲得最大可靠性。';

  @override
  String get step1GetMagicGen2 => '獲取空白Magic Gen2卡（具有可寫UID的MiFare Classic 1K）';

  @override
  String get instructions => '說明';

  @override
  String get step1GetCUID => '獲取空白CUID卡（MiFare Classic 1K）';

  @override
  String get step2PressWrite => '按下面的\"寫入\"按鈕';

  @override
  String get step3HoldPhone => '將手機靠近CUID卡';

  @override
  String get step4WaitConfirm => '等待寫入確認';

  @override
  String get step5TestClone => '在Bambu Lab印表機上測試克隆標籤！';

  @override
  String get rsaIncluded => '克隆包含原始RSA簽名，將被印表機接受！';

  @override
  String get cloneDeleted => '克隆已刪除';

  @override
  String get deleteAccount => '刪除我的帳戶';

  @override
  String get deleteAccountConfirmation => '此操作不可撤銷。您的帳戶和所有資料將在30天內刪除。';

  @override
  String get accountDeletionRequested => '刪除請求已登記';

  @override
  String get clearShoppingList => '清空清單';

  @override
  String get clearShoppingListConfirmation => '確定要清空整個購物清單嗎？此操作無法撤消。';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => '歷史';

  @override
  String get retryButton => '重試';

  @override
  String get readSuccessMessage => '讀取成功！';

  @override
  String get filamentTypeLabel => '耗材類型';

  @override
  String get scanNfcChipButton => '掃描NFC晶片';

  @override
  String deleteCloneConfirmation(String name) {
    return '刪除複製「$name」？';
  }

  @override
  String cloneDeletedMessage(String name) {
    return '複製「$name」已刪除';
  }

  @override
  String get extruderLabel => '擠出機';

  @override
  String get writeThisCloneButton => '寫入此複製';

  @override
  String get customNameHint => '自訂名稱';

  @override
  String get cloneWriteSuccessMessage => '複製寫入成功！';

  @override
  String errorPrefix(String error) {
    return '錯誤: $error';
  }

  @override
  String get writingInProgress => '寫入中...';

  @override
  String get writeOnCUIDButton => '寫入CUID卡';

  @override
  String get diameterLabel => '直徑';

  @override
  String get extruderTempLabel => '擠出機溫度';

  @override
  String get bedTempLabel => '熱床溫度';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K位元組 (1024位元組)';

  @override
  String get rsaSignatureNote => '複製包含原始RSA簽名，印表機將接受它！';

  @override
  String get writeBambuLabTagTitle => '寫入Bambu Lab標籤';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab標籤寫入成功！';

  @override
  String get approachNfcTagMessage => '請靠近NFC標籤...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab格式 (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab格式';

  @override
  String get bambuLabFormatInfo => '此格式使用Bambu Lab材料代碼，並以AMS相容格式儲存資料。';

  @override
  String get brandLabel => '品牌';

  @override
  String get materialTypeLabel => '材料類型';

  @override
  String get serialNumber3Digits => '序號 (3位)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (標準)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => '寫入Bambu Lab標籤';

  @override
  String get bambuLabRsaNote => '注意：原裝Bambu Lab標籤使用RSA加密。此模式以簡化的相容格式寫入資料。';

  @override
  String signInError(String error) {
    return '登入錯誤: $error';
  }

  @override
  String get subscriptionActivatedMessage => '訂閱已啟用！';

  @override
  String get subscriptionFailedMessage => '訂閱失敗';

  @override
  String errorMessage(String error) {
    return '錯誤: $error';
  }

  @override
  String get subscriptionRestoredMessage => '訂閱已恢復！';

  @override
  String get noSubscriptionFoundMessage => '未找到訂閱';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => '啟用';

  @override
  String get noAdsExperienceMessage => '享受無廣告體驗！';

  @override
  String get subscribedLabel => '已訂閱';

  @override
  String get restorePurchasesButton => '恢復購買';

  @override
  String get cannotExceedRemainingWeight => '不能超過剩餘重量';

  @override
  String get pleaseEnterLength => '請輸入長度';

  @override
  String get pleaseEnterValidLength => '請輸入有效長度';

  @override
  String get spoolLengthNotSetCannotConvert => '未設定線軸長度 - 無法轉換';

  @override
  String get exceedsRemainingWeight => '超過剩餘重量';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => '幫助我們辨識這種耗材';

  @override
  String get helpUsImprove => '幫助我們改進！';

  @override
  String get helpIdentifyDescription => '我們讀取了晶片但無法辨識。請告訴我們這是什麼耗材，以便我們改進應用程式。';

  @override
  String get otherBrand => '其他';

  @override
  String get thankYouFeedback => '感謝您的回饋！';

  @override
  String get send => '傳送';

  @override
  String get optionalDetails => '選填詳情';

  @override
  String get weightGrams => '重量 (g)';

  @override
  String get diameterMm => '直徑 (mm)';

  @override
  String get spoolLengthM => '線軸長度 (m)';

  @override
  String get batchNumberLabel => '批次 / SKU';

  @override
  String get contactUs => '聯絡我們';

  @override
  String get contactUsSubtitle => '問題、建議或回饋';

  @override
  String get nfcTagNotDetected => '未偵測到NFC標籤';

  @override
  String get nfcTagNotDetectedDesc => '未找到標籤。標籤可能已損壞或距離手機太遠。';

  @override
  String get nfcTagIncompatible => '偵測到不相容的NFC標籤';

  @override
  String get nfcAuthError => 'NFC標籤認證失敗';

  @override
  String get nfcAuthErrorDesc => '已偵測到標籤，但多次嘗試後認證失敗。請將標籤緊貼手機背面並重試。';

  @override
  String get nfcTagInfoPrusa =>
      '使用空白NXP ICODE SLIX2標籤(ISO 15693)為Prusa MK4/XL創建OpenPrintTag兼容標籤。';

  @override
  String get writePrusaTagTitle => '寫入Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable => '此裝置不支援透過Apple登入。';

  @override
  String get signInAppleFailed => '透過Apple登入失敗。請重試。';

  @override
  String get signInFailed => '登入失敗。請重試。';

  @override
  String get mustContain3Digits => '必須包含3位數字';

  @override
  String get mustBeNumber => '必須是數字';

  @override
  String generatedUidLabel(String uid) {
    return '產生的UID：$uid';
  }

  @override
  String get experimentalBadge => '實驗性';

  @override
  String get newBadge => '新';

  @override
  String get forCrealityCfs => '適用於Creality CFS';

  @override
  String get crealityReadWrite => 'Creality：讀取和寫入';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS標籤使用AES-128-ECB加密的MiFare Classic 1K。';

  @override
  String get platformLimitationTitle => '平臺限制';

  @override
  String get mifareClassicNotSupportedIos =>
      '由於Apple CoreNFC限制，iOS不支援MiFare Classic標籤（Bambu Lab、Creality）。';

  @override
  String get nfcTagInfoCreality =>
      '使用MiFare Classic 1K標籤寫入Creality CFS相容資料（適用於Creality K2 Plus）。';

  @override
  String get colorHintExamples => '紅色、藍色、黑色...';

  @override
  String get dryingTemp => '乾燥溫度';

  @override
  String get dryingTempHint => '例如 55';

  @override
  String get dryingTime => '乾燥時間（小時）';

  @override
  String get dryingTimeHint => '例如 8';

  @override
  String fallbackDetectedAs(String mode) {
    return '標籤偵測為$mode — 下次掃描請切換標籤頁';
  }

  @override
  String get fallbackChooseMode => '手動選擇模式';

  @override
  String get fallbackChooseModeSubtitle => '自動偵測無法識別此標籤。請選擇協議：';

  @override
  String get tryAutoDetect => '嘗試自動檢測';

  @override
  String get autoDetectAllBrands => '自動檢測 — 所有品牌';

  @override
  String get autoDetectAllBrandsDesc => 'Anycubic、Elegoo、OpenSpool、OpenTag3D 等';

  @override
  String get nfcTipIos => 'NFC讀卡器位於iPhone頂部。請將其直接放在線軸的NFC標籤上。';

  @override
  String get nfcTipAndroid => 'NFC讀卡器通常位於手機背面中央。請將手機背面放在線軸的NFC標籤上。';

  @override
  String get stockSortBy => '排序';

  @override
  String get stockFilter => '篩選';

  @override
  String get stockSortRecent => '最新';

  @override
  String get stockSortBrand => '品牌';

  @override
  String get stockSortMaterial => '材料';

  @override
  String get stockSortRemaining => '剩餘重量';

  @override
  String get stockSortColor => '顏色';

  @override
  String get stockFilterAll => '全部';

  @override
  String get stockResetFilters => '重設';

  @override
  String get stockNoMatch => '沒有符合篩選條件的線軸';

  @override
  String get nfcDisabledTitle => 'NFC 已關閉';

  @override
  String get nfcDisabledMessage => 'NFC 已關閉。請在手機設定中開啟，以掃描線軸。';

  @override
  String get updateAvailableTitle => '有可用更新';

  @override
  String get updateAvailableMessage => 'Spool Master 有新版本可用。';

  @override
  String get updateForcedMessage => '此版本已不再支援。請更新以繼續。';

  @override
  String get updateNow => '更新';

  @override
  String get updateLater => '稍後';

  @override
  String get nfcScanGuidance => '將標籤靠在手機頂部或背面並保持不動。';

  @override
  String get tagMovedTitle => '標籤移動了';

  @override
  String get tagMovedMessage => '讀取時標籤移動了。請重新貼合並保持手機不動。';

  @override
  String get lightBlue => '淺藍色';

  @override
  String get transparent => '透明';

  @override
  String get nfcActiveApproachTag => 'NFC已啟用 — 請靠近標籤';

  @override
  String addedToShoppingList(String item) {
    return '$item 已加入購物清單';
  }

  @override
  String get deleteAccountFailed => '刪除帳戶失敗,請重試。';

  @override
  String get scanHistoryError => '存取掃描歷史時發生錯誤';

  @override
  String get genericBrand => '通用';

  @override
  String get stockSearchHint => '搜尋（品牌、顏色、位置…）';

  @override
  String get stockMoreActions => '更多操作';

  @override
  String get exportExcel => '匯出為 Excel';

  @override
  String get exportFailed => '匯出失敗';

  @override
  String get exportShareSubject => '我的耗材庫存（Spool Master）';

  @override
  String get exportColorHex => '顏色代碼';

  @override
  String get exportRemainingPercent => '剩餘（%）';

  @override
  String get exportPricePerKg => '價格 / kg';

  @override
  String get exportAddedDate => '新增日期';

  @override
  String get exportOrdered => '已訂購';

  @override
  String get exportDate => '日期';

  @override
  String get exportGrams => '公克';

  @override
  String get exportCost => '成本';

  @override
  String get importSpools => '匯入（CSV / Excel）';

  @override
  String get importConfirmTitle => '匯入線軸';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return '待新增線軸：$count\n庫存中已有（已略過）：$duplicates\n無法讀取的列（已略過）：$skipped';
  }

  @override
  String get importAction => '匯入';

  @override
  String get importNothingFound =>
      '未辨識到任何線軸。檔案至少須包含「材料」和「重量」欄（與應用程式的 Excel 匯出一致）。';

  @override
  String importDone(int count) {
    return '已匯入線軸：$count';
  }

  @override
  String get importFailed => '檔案無法讀取';

  @override
  String get location => '位置';

  @override
  String get locationHint => '例如：A 層架，防潮盒 2';

  @override
  String get notes => '備註';

  @override
  String get notesHint => '例如：使用前需烘乾';

  @override
  String get printCostTitle => '列印成本';

  @override
  String get printCostGrams => '已用耗材（g）';

  @override
  String printCostResult(String cost) {
    return '材料成本：$cost';
  }

  @override
  String printCostPerKg(String price) {
    return '每 kg 價格：$price';
  }

  @override
  String get printCostNoPrice => '請新增線軸價格以計算成本。';

  @override
  String get printCostDeduct => '從庫存中扣除';

  @override
  String printCostDeducted(String grams) {
    return '已從庫存中扣除 $grams g';
  }

  @override
  String get consumptionTitle => '消耗量';

  @override
  String get consumptionLast30Days => '最近 30 天';

  @override
  String get consumptionThisMonth => '本月';

  @override
  String get consumptionByMaterial => '依材料（30 天）';

  @override
  String get consumptionMonthly => '最近 6 個月';

  @override
  String get consumptionEmpty => '尚無消耗記錄。更新線軸剩餘重量或使用成本計算機後即會顯示。';

  @override
  String get shareShoppingList => '分享清單';

  @override
  String get nfcBlankTagTitle => '空白標籤';

  @override
  String get nfcBlankTagDesc => '此標籤不含耗材捲資料。請手動新增耗材捲，或在 App 中寫入此標籤。';

  @override
  String get subscriptionAutoRenewDisclosure =>
      '確認購買時，款項將從您的商店帳戶扣款。除非在目前訂閱期間結束前至少24小時取消，否則訂閱將自動續訂；續訂費用將於期間結束前24小時內扣款。您可以在商店帳戶設定中管理或取消訂閱。';

  @override
  String get manageSubscription => '管理訂閱';

  @override
  String get subscriptionPendingMessage => '付款等待確認：確認後訂閱將立即啟用。';

  @override
  String subscriptionEndsOn(String date) {
    return '已關閉自動續訂：可使用至 $date';
  }
}
