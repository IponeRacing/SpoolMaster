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
  String get legal => 'Legal';

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
      '⚠️ 警告：使用iPhone NFC写入可能无法在所有Magic Gen2卡上工作。建议使用带有NFC Tools Pro应用的Android或Proxmark3设备以确保可靠性。';

  @override
  String get step1GetMagicGen2 => '获取空白Magic Gen2卡（具有可写UID的MiFare Classic 1K）';

  @override
  String get instructions => '说明';

  @override
  String get step1GetCUID => '获取空白CUID卡（MiFare Classic 1K）';

  @override
  String get step2PressWrite => '按下面的\"写入\"按钮';

  @override
  String get step3HoldPhone => '将iPhone靠近CUID卡';

  @override
  String get step4WaitConfirm => '等待写入确认';

  @override
  String get step5TestClone => '在Bambu Lab打印机上测试克隆标签！';

  @override
  String get rsaIncluded => '克隆包含原始RSA签名，将被打印机接受！';

  @override
  String get cloneDeleted => '克隆已删除';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

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
  String get legal => 'Legal';

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
      '⚠️ 警告：使用iPhone NFC写入可能无法在所有Magic Gen2卡上工作。建议使用带有NFC Tools Pro应用的Android或Proxmark3设备以确保可靠性。';

  @override
  String get step1GetMagicGen2 => '获取空白Magic Gen2卡（具有可写UID的MiFare Classic 1K）';

  @override
  String get instructions => '说明';

  @override
  String get step1GetCUID => '获取空白CUID卡（MiFare Classic 1K）';

  @override
  String get step2PressWrite => '按下面的\"写入\"按钮';

  @override
  String get step3HoldPhone => '将iPhone靠近CUID卡';

  @override
  String get step4WaitConfirm => '等待写入确认';

  @override
  String get step5TestClone => '在Bambu Lab打印机上测试克隆标签！';

  @override
  String get rsaIncluded => '克隆包含原始RSA签名，将被打印机接受！';

  @override
  String get cloneDeleted => '克隆已删除';
}
