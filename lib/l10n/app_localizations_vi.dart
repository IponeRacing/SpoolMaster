// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Kho';

  @override
  String get statistics => 'Phân tích';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get readNfcChip => 'Đọc chip NFC';

  @override
  String get scanHistory => 'Lịch sử';

  @override
  String get writeNfcChip => 'Ghi chip NFC';

  @override
  String get nfcNotAvailable => 'NFC không khả dụng';

  @override
  String get nfcNotAvailableDesc =>
      'Thiết bị của bạn không hỗ trợ NFC hoặc đã bị tắt.';

  @override
  String get nfcNotSupported => 'NFC không được hỗ trợ trên thiết bị này';

  @override
  String get approachNfcChip => 'Đưa chip NFC lại gần...';

  @override
  String get scanningNfc => 'Đang quét...';

  @override
  String get nfcDataRead => 'Đã đọc dữ liệu NFC thành công!';

  @override
  String get errorReadingNfc => 'Lỗi đọc NFC';

  @override
  String get scanHistoryTitle => 'Lịch sử quét';

  @override
  String get noScansRecorded => 'Không có lượt quét nào được ghi lại';

  @override
  String get scansWillAppearHere =>
      'Các lượt quét NFC sẽ tự động xuất hiện ở đây';

  @override
  String get clearAll => 'Xóa tất cả';

  @override
  String get deleteThisScan => 'Xóa lượt quét này?';

  @override
  String get actionIrreversible => 'Hành động này không thể hoàn tác.';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get clearAllHistory => 'Xóa toàn bộ lịch sử?';

  @override
  String get allScansWillBeDeleted =>
      'Tất cả lượt quét sẽ bị xóa. Hành động này không thể hoàn tác.';

  @override
  String get scanDeleted => 'Đã xóa lượt quét';

  @override
  String get scanDetails => 'Chi tiết quét';

  @override
  String scannedOn(Object date) {
    return 'Đã quét vào $date';
  }

  @override
  String get bobbinInformation => 'Thông tin cuộn';

  @override
  String get filamentType => 'Loại filament';

  @override
  String get color => 'Màu sắc';

  @override
  String get weight => 'Trọng lượng';

  @override
  String get manufacturingDate => 'Ngày sản xuất';

  @override
  String get batchNumber => 'Số lô';

  @override
  String get printerSettings => 'Cài đặt máy in';

  @override
  String get scanMetadata => 'Siêu dữ liệu quét';

  @override
  String get scanId => 'ID quét';

  @override
  String get dateAndTime => 'Ngày và giờ';

  @override
  String get reuseThisData => 'Sử dụng lại dữ liệu này';

  @override
  String get writeToNfc => 'Ghi vào NFC';

  @override
  String get writeDataToChip => 'Ghi dữ liệu vào chip';

  @override
  String get writeSuccess => 'Ghi thành công!';

  @override
  String get writeError => 'Lỗi ghi';

  @override
  String get brand => 'Thương hiệu';

  @override
  String get selectBrand => 'Chọn thương hiệu';

  @override
  String get materialType => 'Loại vật liệu';

  @override
  String get selectMaterial => 'Chọn vật liệu';

  @override
  String get serialNumber => 'Số seri';

  @override
  String get serialNumberHint => 'vd: 001';

  @override
  String get initialWeight => 'Trọng lượng ban đầu';

  @override
  String get initialWeightHint => 'vd: 1000';

  @override
  String get extruderTempMin => 'Nhiệt độ đầu phun tối thiểu';

  @override
  String get extruderTempMax => 'Nhiệt độ đầu phun tối đa';

  @override
  String get bedTempMin => 'Nhiệt độ bàn in tối thiểu';

  @override
  String get bedTempMax => 'Nhiệt độ bàn in tối đa';

  @override
  String get diameter => 'Đường kính filament';

  @override
  String get spoolLength => 'Chiều dài cuộn';

  @override
  String get generatedSku => 'SKU đã tạo';

  @override
  String get approachChipToWrite => 'Đưa chip lại gần để ghi...';

  @override
  String get writing => 'Đang ghi...';

  @override
  String get chooseColor => 'Chọn màu';

  @override
  String get required => 'Bắt buộc';

  @override
  String get invalid => 'Không hợp lệ';

  @override
  String get advancedSettings => 'Cài đặt nâng cao';

  @override
  String get opacity => 'Độ mờ';

  @override
  String get validate => 'Xác nhận';

  @override
  String get nfcTagInfo =>
      'Sử dụng thẻ NFC trống ISO14443A (NTAG213) để tạo thẻ Anycubic của riêng bạn.';

  @override
  String get stockInventory => 'Cuộn dây trong kho';

  @override
  String get addSpool => 'Thêm cuộn';

  @override
  String get scanSpool => 'Quét cuộn';

  @override
  String get addManually => 'Thêm thủ công';

  @override
  String get spoolAdded => 'Đã thêm cuộn';

  @override
  String get spoolUpdated => 'Đã cập nhật cuộn';

  @override
  String get noSpoolsInStock => 'Không có cuộn trong kho';

  @override
  String get addFirstSpool =>
      'Thêm cuộn đầu tiên của bạn để bắt đầu theo dõi hàng tồn kho';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count cuộn sắp hết (< $threshold%)';
  }

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get bobbinPrice => 'Giá cuộn';

  @override
  String get price => 'Giá';

  @override
  String get priceHint => 'vd: 25.00';

  @override
  String get save => 'Lưu';

  @override
  String get spoolDetails => 'Chi tiết cuộn';

  @override
  String get deleteThisSpool => 'Xóa cuộn này?';

  @override
  String get cannotBeUndone => 'Hành động này không thể hoàn tác.';

  @override
  String get addSpoolManually => 'Thêm cuộn thủ công';

  @override
  String get editSpool => 'Chỉnh sửa cuộn';

  @override
  String get customBrand => 'Thương hiệu tùy chỉnh';

  @override
  String get customBrandHint => 'vd: Thương hiệu của tôi';

  @override
  String get chooseFromList => 'Chọn từ danh sách';

  @override
  String get addBrand => '+ Thêm thương hiệu';

  @override
  String get customMaterial => 'Vật liệu tùy chỉnh';

  @override
  String get customMaterialHint => 'vd: Vật liệu của tôi';

  @override
  String get addMaterial => '+ Thêm vật liệu';

  @override
  String get colorHint => 'vd: Xanh, Đỏ...';

  @override
  String get enterColor => 'Vui lòng nhập màu';

  @override
  String get initialWeightG => 'Trọng lượng ban đầu';

  @override
  String get remainingWeightG => 'Trọng lượng còn lại';

  @override
  String get enterBrand => 'Vui lòng nhập thương hiệu';

  @override
  String get selectOrEnterBrand => 'Vui lòng chọn hoặc nhập thương hiệu';

  @override
  String get quantity => 'Số lượng';

  @override
  String get quantityHelper => 'Thêm nhiều cuộn giống nhau cùng lúc';

  @override
  String get quantityInvalid => 'Nhập một số từ 1 đến 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count trong kho';
  }

  @override
  String get enterMaterial => 'Vui lòng nhập vật liệu';

  @override
  String get selectOrEnterMaterial => 'Vui lòng chọn hoặc nhập vật liệu';

  @override
  String get enterPrice => 'Vui lòng nhập giá';

  @override
  String get enterValidPrice => 'Vui lòng nhập giá hợp lệ';

  @override
  String get enterWeight => 'Vui lòng nhập trọng lượng';

  @override
  String get enterValidWeight => 'Vui lòng nhập trọng lượng hợp lệ';

  @override
  String get remainingCannotExceedTotal =>
      'Trọng lượng còn lại không thể vượt quá tổng trọng lượng';

  @override
  String get overview => 'Tổng quan';

  @override
  String get spoolsInStock => 'Cuộn trong kho';

  @override
  String get totalValue => 'Tổng giá trị';

  @override
  String get lowStockSpools => 'Sắp hết';

  @override
  String get materialDistribution => 'Phân bổ theo vật liệu';

  @override
  String get brandDistribution => 'Phân bổ theo thương hiệu';

  @override
  String get noData => 'Không có dữ liệu';

  @override
  String get refresh => 'Làm mới';

  @override
  String get profileSettings => 'Cài đặt hồ sơ';

  @override
  String get preferences => 'Tùy chọn';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

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
  String get currency => 'Tiền tệ';

  @override
  String get selectCurrency => 'Chọn tiền tệ';

  @override
  String get units => 'Đơn vị';

  @override
  String get selectUnits => 'Chọn đơn vị';

  @override
  String get metric => 'Hệ mét (mm, g, °C)';

  @override
  String get imperial => 'Hệ Anh (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Ngưỡng cảnh báo sắp hết';

  @override
  String get lowStockThresholdDesc =>
      'Một cuộn sẽ được coi là sắp hết nếu trọng lượng còn lại nhỏ hơn phần trăm này';

  @override
  String get authentication => 'Xác thực';

  @override
  String get signInWithGoogle => 'Đăng nhập bằng Google';

  @override
  String get signInWithApple => 'Đăng nhập bằng Apple';

  @override
  String get continueWithApple => 'Tiếp tục với Apple';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get comingSoon => 'Sắp ra mắt';

  @override
  String get about => 'Giới thiệu';

  @override
  String get version => 'Phiên bản';

  @override
  String get madeWith => 'Được tạo với ❤️ cho máy in 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Quét cuộn';

  @override
  String get nfcEncoder => 'Bộ mã hóa NFC';

  @override
  String get length => 'Chiều dài';

  @override
  String get tempExtruder => 'Nhiệt độ đầu phun';

  @override
  String get tempBed => 'Nhiệt độ bàn in';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get legal => 'Pháp lý';

  @override
  String get back => 'Quay lại';

  @override
  String get retry => 'Thử lại';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get extruderTempMinHint => 'VD: 200';

  @override
  String get extruderTempMaxHint => 'VD: 220';

  @override
  String get bedTempMinHint => 'VD: 50';

  @override
  String get bedTempMaxHint => 'VD: 60';

  @override
  String get diameterHint => 'VD: 1.75';

  @override
  String get spoolLengthHint => 'VD: 330';

  @override
  String get tabGrid => 'Lưới';

  @override
  String get tabSpectrum => 'Quang phổ';

  @override
  String get tabSliders => 'Thanh trượt';

  @override
  String get hexCode => 'Mã Hex';

  @override
  String get red => 'Đỏ';

  @override
  String get green => 'Xanh lá';

  @override
  String get blue => 'Xanh dương';

  @override
  String get black => 'Đen';

  @override
  String get white => 'Trắng';

  @override
  String get yellow => 'Vàng';

  @override
  String get orange => 'Cam';

  @override
  String get pink => 'Hồng';

  @override
  String get purple => 'Tím';

  @override
  String get gray => 'Xám';

  @override
  String get brown => 'Nâu';

  @override
  String get unknown => 'Không xác định';

  @override
  String get metricUnits => 'Hệ mét (mm, g, °C)';

  @override
  String get imperialUnits => 'Hệ Anh (in, oz, °F)';

  @override
  String get chf => 'Franc Thụy Sĩ (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Đô la Mỹ (\$)';

  @override
  String get gbp => 'Bảng Anh (£)';

  @override
  String get cad => 'Đô la Canada (CAD)';

  @override
  String get aud => 'Đô la Úc (A\$)';

  @override
  String get jpy => 'Yên Nhật (¥)';

  @override
  String get cny => 'Nhân dân tệ (¥)';

  @override
  String get inr => 'Rupee Ấn Độ (₹)';

  @override
  String get brl => 'Real Brazil (R\$)';

  @override
  String get mxn => 'Peso Mexico (MX\$)';

  @override
  String get sek => 'Krona Thụy Điển (kr)';

  @override
  String get nok => 'Krone Na Uy (kr)';

  @override
  String get dkk => 'Krone Đan Mạch (kr)';

  @override
  String get pln => 'Zloty Ba Lan (zł)';

  @override
  String get czk => 'Koruna Séc (Kč)';

  @override
  String get nzd => 'Đô la New Zealand (NZ\$)';

  @override
  String get filamentsToOrder => 'Filament cần đặt';

  @override
  String get shoppingList => 'Danh sách mua sắm';

  @override
  String get addToShoppingList => 'Thêm vào danh sách';

  @override
  String get noLowStockFilaments => 'Không có filament sắp hết';

  @override
  String get vipSubscriptionDescription =>
      'Gói đăng ký này chỉ được sử dụng để tắt quảng cáo trong ứng dụng và hỗ trợ dự án. Không có tính năng khác.';

  @override
  String get monthlySubscription => 'Gói đăng ký hàng tháng';

  @override
  String get yearlySubscription => 'Gói đăng ký hàng năm';

  @override
  String get perMonth => '/ tháng';

  @override
  String get perYear => '/ năm';

  @override
  String onlyPerMonth(String price) {
    return 'Chỉ $price / tháng';
  }

  @override
  String get subscribe => 'Đăng ký';

  @override
  String get bestOffer => '✨ ƯU ĐÃI TỐT NHẤT ✨';

  @override
  String get forAnycubicAce => 'cho Anycubic Ace';

  @override
  String get forBambuLabAms => 'cho Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Quét chip NFC';

  @override
  String get fillForm => 'Điền biểu mẫu';

  @override
  String get emptyShoppingList => 'Không có filament trong danh sách';

  @override
  String percentRemaining(String percent) {
    return 'Còn lại $percent%';
  }

  @override
  String get markAsOrdered => 'Đánh dấu đã đặt';

  @override
  String get markAsNotOrdered => 'Đánh dấu chưa đặt';

  @override
  String get notSignedIn => 'Chưa đăng nhập';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get connection => 'Kết nối';

  @override
  String get signInToSync => 'Đăng nhập để đồng bộ dữ liệu của bạn';

  @override
  String get continueWithoutAccount =>
      'Tiếp tục mà không cần tài khoản (chế độ cục bộ)';

  @override
  String get privacyNotice =>
      'Bằng cách đăng nhập, bạn chấp nhận\nĐiều khoản dịch vụ và Chính sách bảo mật của chúng tôi';

  @override
  String get updateStock => 'Cập nhật kho';

  @override
  String get scanToUpdateStock => 'Quét để cập nhật';

  @override
  String get weightUsed => 'Trọng lượng đã sử dụng';

  @override
  String get lengthUsed => 'Chiều dài đã sử dụng';

  @override
  String get enterWeightOrLength =>
      'Nhập trọng lượng hoặc chiều dài đã sử dụng';

  @override
  String get weightUsedG => 'Trọng lượng đã sử dụng (g)';

  @override
  String get lengthUsedM => 'Chiều dài đã sử dụng (m)';

  @override
  String get stockUpdated => 'Đã cập nhật kho';

  @override
  String get scanSpoolToUpdate => 'Quét cuộn để cập nhật kho';

  @override
  String get spoolNotFound => 'Không tìm thấy cuộn trong kho';

  @override
  String get addSpoolFirstMessage =>
      'Cuộn này chưa có trong kho của bạn. Vui lòng thêm nó trước bằng nút \'Thêm cuộn\' trước khi cập nhật kho.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Chỉ đọc';

  @override
  String get bambuLabReadOnlyDesc =>
      'Thẻ Bambu Lab sử dụng mã hóa RSA và không thể sửa đổi. Chỉ đọc.';

  @override
  String get forPrusaMk4 => 'cho Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Đọc và ghi';

  @override
  String get prusaReadWriteDesc =>
      'Thẻ Prusa sử dụng ISO 15693 (NFC-V) với định dạng OpenPrintTag. Hỗ trợ đọc và ghi.';

  @override
  String get bambuCloneLibrary => 'Thư viện bản sao Bambu Lab';

  @override
  String get noBambuClones => 'Không có bản sao Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Quét thẻ Bambu Lab gốc để tạo thư viện bản sao của bạn';

  @override
  String get scanTag => 'Quét thẻ';

  @override
  String get syncWithCloud => 'Đồng bộ với đám mây';

  @override
  String get syncCompleted => 'Đồng bộ hoàn tất';

  @override
  String get deleteClone => 'Xóa bản sao';

  @override
  String get renameClone => 'Đổi tên bản sao';

  @override
  String get rename => 'Đổi tên';

  @override
  String get customName => 'Tên tùy chỉnh';

  @override
  String get clonedOn => 'Đã sao chép vào';

  @override
  String get writeThisClone => 'Ghi bản sao này';

  @override
  String get writeClone => 'Ghi bản sao';

  @override
  String get writeOnCUID => 'Ghi lên thẻ CUID';

  @override
  String get cloneWrittenSuccess => 'Ghi bản sao thành công!';

  @override
  String get requiredTagFormat => 'Định dạng thẻ cần thiết';

  @override
  String get type => 'Loại';

  @override
  String get frequency => 'Tần số';

  @override
  String get protocol => 'Giao thức';

  @override
  String get capacity => 'Dung lượng';

  @override
  String get feature => 'Tính năng';

  @override
  String get uidModifiable => 'Khối 0 (UID) có thể sửa đổi';

  @override
  String get whereToBuy =>
      'Tìm kiếm \"CUID MiFare Classic 1K\" trên AliExpress, Amazon hoặc eBay (~\$0.50/cái)';

  @override
  String get magicGen2Required =>
      'Thẻ Magic Gen2 - MiFare Classic 1K với Block 0 (UID) có thể ghi';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Tìm kiếm \"Magic Gen2 MiFare Classic 1K\" hoặc \"UID writable\" trên AliExpress, Amazon hoặc eBay (~\$0.50/cái)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Cảnh báo: Ghi bằng iPhone NFC có thể không hoạt động trên tất cả thẻ Magic Gen2. Khuyến nghị dùng thiết bị Proxmark3 để đảm bảo độ tin cậy tối đa.';

  @override
  String get step1GetMagicGen2 =>
      'Lấy thẻ Magic Gen2 trống (MiFare Classic 1K với UID có thể ghi)';

  @override
  String get instructions => 'Hướng dẫn';

  @override
  String get step1GetCUID => 'Lấy thẻ CUID trống (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Nhấn nút \"Ghi\" bên dưới';

  @override
  String get step3HoldPhone => 'Giữ điện thoại của bạn gần thẻ CUID';

  @override
  String get step4WaitConfirm => 'Chờ xác nhận ghi';

  @override
  String get step5TestClone =>
      'Kiểm tra thẻ đã sao chép trên máy in Bambu Lab của bạn!';

  @override
  String get rsaIncluded =>
      'Bản sao bao gồm chữ ký RSA gốc, nó sẽ được máy in chấp nhận!';

  @override
  String get cloneDeleted => 'Đã xóa bản sao';

  @override
  String get deleteAccount => 'Xóa tài khoản của tôi';

  @override
  String get deleteAccountConfirmation =>
      'Hành động này không thể hoàn tác. Tài khoản và tất cả dữ liệu sẽ bị xóa trong vòng 30 ngày.';

  @override
  String get accountDeletionRequested => 'Yêu cầu xóa đã được ghi nhận';

  @override
  String get clearShoppingList => 'Xóa danh sách';

  @override
  String get clearShoppingListConfirmation =>
      'Bạn có chắc chắn muốn xóa toàn bộ danh sách mua sắm không? Hành động này không thể hoàn tác.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Lịch sử';

  @override
  String get retryButton => 'Thử lại';

  @override
  String get readSuccessMessage => 'Đọc thành công!';

  @override
  String get filamentTypeLabel => 'Loại sợi in';

  @override
  String get scanNfcChipButton => 'Quét chip NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Xóa bản sao \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Đã xóa bản sao \"$name\"';
  }

  @override
  String get extruderLabel => 'Đầu đùn';

  @override
  String get writeThisCloneButton => 'Ghi bản sao này';

  @override
  String get customNameHint => 'Tên tùy chỉnh';

  @override
  String get cloneWriteSuccessMessage => 'Ghi bản sao thành công!';

  @override
  String errorPrefix(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get writingInProgress => 'Đang ghi...';

  @override
  String get writeOnCUIDButton => 'Ghi lên thẻ CUID';

  @override
  String get diameterLabel => 'Đường kính';

  @override
  String get extruderTempLabel => 'Nhiệt độ đầu đùn';

  @override
  String get bedTempLabel => 'Nhiệt độ bàn in';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K byte (1024 byte)';

  @override
  String get rsaSignatureNote =>
      'Bản sao bao gồm chữ ký RSA gốc, máy in sẽ chấp nhận!';

  @override
  String get writeBambuLabTagTitle => 'Ghi thẻ Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'Ghi thẻ Bambu Lab thành công!';

  @override
  String get approachNfcTagMessage => 'Đưa thẻ NFC lại gần...';

  @override
  String get bambuLabFormatMiFare => 'Định dạng Bambu Lab (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Định dạng Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Định dạng này sử dụng mã vật liệu Bambu Lab và lưu trữ dữ liệu ở định dạng tương thích AMS.';

  @override
  String get brandLabel => 'Thương hiệu';

  @override
  String get materialTypeLabel => 'Loại vật liệu';

  @override
  String get serialNumber3Digits => 'Số sê-ri (3 chữ số)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (tiêu chuẩn)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Ghi thẻ Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Lưu ý: Thẻ Bambu Lab gốc sử dụng mã hóa RSA. Chế độ này ghi dữ liệu ở định dạng đơn giản tương thích.';

  @override
  String signInError(String error) {
    return 'Lỗi đăng nhập: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Đăng ký đã được kích hoạt!';

  @override
  String get subscriptionFailedMessage => 'Đăng ký thất bại';

  @override
  String errorMessage(String error) {
    return 'Lỗi: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Đăng ký đã được khôi phục!';

  @override
  String get noSubscriptionFoundMessage => 'Không tìm thấy đăng ký';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'HOẠT ĐỘNG';

  @override
  String get noAdsExperienceMessage => 'Tận hưởng trải nghiệm không quảng cáo!';

  @override
  String get subscribedLabel => 'Đã đăng ký';

  @override
  String get restorePurchasesButton => 'Khôi phục giao dịch';

  @override
  String get cannotExceedRemainingWeight =>
      'Không thể vượt quá trọng lượng còn lại';

  @override
  String get pleaseEnterLength => 'Vui lòng nhập chiều dài';

  @override
  String get pleaseEnterValidLength => 'Vui lòng nhập chiều dài hợp lệ';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Chưa đặt chiều dài cuộn - không thể chuyển đổi';

  @override
  String get exceedsRemainingWeight => 'Vượt quá trọng lượng còn lại';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Giúp chúng tôi nhận diện sợi nhựa này';

  @override
  String get helpUsImprove => 'Giúp chúng tôi cải thiện!';

  @override
  String get helpIdentifyDescription =>
      'Chúng tôi đã đọc chip nhưng không thể nhận diện. Hãy cho chúng tôi biết đây là sợi nhựa gì để cải thiện ứng dụng.';

  @override
  String get otherBrand => 'Khác';

  @override
  String get thankYouFeedback => 'Cảm ơn phản hồi của bạn!';

  @override
  String get send => 'Gửi';

  @override
  String get optionalDetails => 'Chi tiết tùy chọn';

  @override
  String get weightGrams => 'Trọng lượng (g)';

  @override
  String get diameterMm => 'Đường kính (mm)';

  @override
  String get spoolLengthM => 'Chiều dài cuộn (m)';

  @override
  String get batchNumberLabel => 'Lô / SKU';

  @override
  String get contactUs => 'Liên hệ với chúng tôi';

  @override
  String get contactUsSubtitle => 'Câu hỏi, đề xuất hoặc vấn đề';

  @override
  String get nfcTagNotDetected => 'Không phát hiện thẻ NFC';

  @override
  String get nfcTagNotDetectedDesc =>
      'Không tìm thấy thẻ. Thẻ có thể đã hỏng, bị hư hoặc quá xa điện thoại.';

  @override
  String get nfcTagIncompatible => 'Phát hiện thẻ NFC không tương thích';

  @override
  String get nfcAuthError => 'Xác thực thẻ NFC thất bại';

  @override
  String get nfcAuthErrorDesc =>
      'Thẻ đã được phát hiện nhưng xác thực thất bại sau nhiều lần thử. Giữ thẻ áp chặt vào mặt sau điện thoại và thử lại.';

  @override
  String get nfcTagInfoPrusa =>
      'Sử dụng thẻ NXP ICODE SLIX2 trống (ISO 15693) để tạo thẻ tương thích OpenPrintTag cho Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Ghi thẻ Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Đăng nhập bằng Apple không khả dụng trên thiết bị này.';

  @override
  String get signInAppleFailed =>
      'Đăng nhập bằng Apple thất bại. Vui lòng thử lại.';

  @override
  String get signInFailed => 'Đăng nhập thất bại. Vui lòng thử lại.';

  @override
  String get mustContain3Digits => 'Phải chứa 3 chữ số';

  @override
  String get mustBeNumber => 'Phải là một số';

  @override
  String generatedUidLabel(String uid) {
    return 'UID đã tạo: $uid';
  }

  @override
  String get experimentalBadge => 'THỬ NGHIỆM';

  @override
  String get newBadge => 'MỚI';

  @override
  String get forCrealityCfs => 'cho Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Đọc & ghi';

  @override
  String get crealityReadWriteDesc =>
      'Thẻ Creality CFS sử dụng MiFare Classic 1K với mã hóa AES-128-ECB.';

  @override
  String get platformLimitationTitle => 'Giới hạn nền tảng';

  @override
  String get mifareClassicNotSupportedIos =>
      'Thẻ MiFare Classic (Bambu Lab, Creality) không được hỗ trợ trên iOS do giới hạn của Apple CoreNFC.';

  @override
  String get nfcTagInfoCreality =>
      'Sử dụng thẻ MiFare Classic 1K để ghi dữ liệu tương thích Creality CFS cho Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Đỏ, Xanh dương, Đen...';

  @override
  String get dryingTemp => 'Nhiệt độ sấy';

  @override
  String get dryingTempHint => 'vd. 55';

  @override
  String get dryingTime => 'Thời gian sấy (giờ)';

  @override
  String get dryingTimeHint => 'vd. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Thẻ được phát hiện là $mode — chuyển tab cho các lần quét tiếp theo';
  }

  @override
  String get fallbackChooseMode => 'Chọn chế độ thủ công';

  @override
  String get fallbackChooseModeSubtitle =>
      'Tự động phát hiện không thể nhận dạng thẻ này. Chọn giao thức:';

  @override
  String get tryAutoDetect => 'Thử nhận dạng tự động';

  @override
  String get autoDetectAllBrands => 'Nhận dạng tự động — tất cả thương hiệu';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D và nhiều hơn nữa';

  @override
  String get nfcTipIos =>
      'Đầu đọc NFC nằm ở đỉnh iPhone. Đặt trực tiếp lên thẻ NFC của cuộn.';

  @override
  String get nfcTipAndroid =>
      'Đầu đọc NFC thường nằm ở giữa mặt sau điện thoại. Đặt mặt sau điện thoại lên thẻ NFC của cuộn.';

  @override
  String get stockSortBy => 'Sắp xếp';

  @override
  String get stockFilter => 'Bộ lọc';

  @override
  String get stockSortRecent => 'Mới nhất';

  @override
  String get stockSortBrand => 'Thương hiệu';

  @override
  String get stockSortMaterial => 'Vật liệu';

  @override
  String get stockSortRemaining => 'Khối lượng còn lại';

  @override
  String get stockSortColor => 'Màu sắc';

  @override
  String get stockFilterAll => 'Tất cả';

  @override
  String get stockResetFilters => 'Đặt lại';

  @override
  String get stockNoMatch => 'Không có cuộn nào khớp với bộ lọc';

  @override
  String get nfcDisabledTitle => 'NFC đã tắt';

  @override
  String get nfcDisabledMessage =>
      'NFC đã tắt. Bật trong cài đặt điện thoại để quét cuộn của bạn.';

  @override
  String get updateAvailableTitle => 'Đã có bản cập nhật';

  @override
  String get updateAvailableMessage => 'Đã có phiên bản mới của Spool Master.';

  @override
  String get updateForcedMessage =>
      'Phiên bản này không còn được hỗ trợ. Vui lòng cập nhật để tiếp tục.';

  @override
  String get updateNow => 'Cập nhật';

  @override
  String get updateLater => 'Để sau';

  @override
  String get nfcScanGuidance =>
      'Giữ thẻ cố định ở phía trên hoặc mặt sau điện thoại.';

  @override
  String get tagMovedTitle => 'Thẻ bị di chuyển';

  @override
  String get tagMovedMessage =>
      'Thẻ đã di chuyển khi đang đọc. Đặt lại và giữ điện thoại cố định.';

  @override
  String get lightBlue => 'Xanh nhạt';

  @override
  String get transparent => 'Trong suốt';

  @override
  String get nfcActiveApproachTag => 'NFC đang hoạt động — đưa thẻ lại gần';

  @override
  String addedToShoppingList(String item) {
    return 'Đã thêm $item vào danh sách mua sắm';
  }

  @override
  String get deleteAccountFailed => 'Xóa tài khoản thất bại. Vui lòng thử lại.';

  @override
  String get scanHistoryError => 'Lỗi truy cập lịch sử quét';

  @override
  String get genericBrand => 'Chung';

  @override
  String get stockSearchHint => 'Tìm kiếm (thương hiệu, màu sắc, vị trí…)';

  @override
  String get stockMoreActions => 'Thêm thao tác';

  @override
  String get exportExcel => 'Xuất ra Excel';

  @override
  String get exportFailed => 'Xuất thất bại';

  @override
  String get exportShareSubject => 'Kho sợi nhựa của tôi (Spool Master)';

  @override
  String get exportColorHex => 'Mã màu';

  @override
  String get exportRemainingPercent => 'Còn lại (%)';

  @override
  String get exportPricePerKg => 'Giá / kg';

  @override
  String get exportAddedDate => 'Ngày thêm';

  @override
  String get exportOrdered => 'Đã đặt hàng';

  @override
  String get exportDate => 'Ngày';

  @override
  String get exportGrams => 'Gram';

  @override
  String get exportCost => 'Chi phí';

  @override
  String get importSpools => 'Nhập (CSV / Excel)';

  @override
  String get importConfirmTitle => 'Nhập cuộn';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return 'Cuộn sẽ thêm: $count\nĐã có trong kho (bỏ qua): $duplicates\nDòng không đọc được (bỏ qua): $skipped';
  }

  @override
  String get importAction => 'Nhập';

  @override
  String get importNothingFound =>
      'Không nhận dạng được cuộn nào. Tệp phải có ít nhất các cột Vật liệu và Trọng lượng (như tệp xuất Excel của ứng dụng).';

  @override
  String importDone(int count) {
    return 'Đã nhập cuộn: $count';
  }

  @override
  String get importFailed => 'Không đọc được tệp';

  @override
  String get location => 'Vị trí';

  @override
  String get locationHint => 'VD: Kệ A, hộp hút ẩm 2';

  @override
  String get notes => 'Ghi chú';

  @override
  String get notesHint => 'VD: cần sấy trước khi dùng';

  @override
  String get printCostTitle => 'Chi phí in';

  @override
  String get printCostGrams => 'Sợi nhựa đã dùng (g)';

  @override
  String printCostResult(String cost) {
    return 'Chi phí vật liệu: $cost';
  }

  @override
  String printCostPerKg(String price) {
    return 'Giá mỗi kg: $price';
  }

  @override
  String get printCostNoPrice => 'Thêm giá cuộn để tính chi phí.';

  @override
  String get printCostDeduct => 'Trừ khỏi kho';

  @override
  String printCostDeducted(String grams) {
    return 'Đã trừ $grams g khỏi kho';
  }

  @override
  String get consumptionTitle => 'Mức tiêu thụ';

  @override
  String get consumptionLast30Days => '30 ngày qua';

  @override
  String get consumptionThisMonth => 'Tháng này';

  @override
  String get consumptionByMaterial => 'Theo vật liệu (30 ngày)';

  @override
  String get consumptionMonthly => '6 tháng qua';

  @override
  String get consumptionEmpty =>
      'Chưa ghi nhận mức tiêu thụ nào. Dữ liệu sẽ hiện ngay khi bạn cập nhật trọng lượng còn lại của cuộn hoặc dùng công cụ tính chi phí.';

  @override
  String get shareShoppingList => 'Chia sẻ danh sách';

  @override
  String get nfcBlankTagTitle => 'Thẻ trống';

  @override
  String get nfcBlankTagDesc =>
      'Thẻ này không chứa dữ liệu cuộn nhựa. Hãy thêm cuộn thủ công hoặc ghi thẻ này từ ứng dụng.';

  @override
  String get subscriptionAutoRenewDisclosure =>
      'Khoản thanh toán được tính vào tài khoản cửa hàng của bạn khi xác nhận mua. Gói đăng ký tự động gia hạn trừ khi bị hủy ít nhất 24 giờ trước khi kết thúc chu kỳ hiện tại; phí gia hạn được tính trong vòng 24 giờ trước khi kết thúc chu kỳ. Bạn có thể quản lý hoặc hủy gói đăng ký trong phần cài đặt tài khoản cửa hàng của mình.';

  @override
  String get manageSubscription => 'Quản lý gói đăng ký';

  @override
  String get subscriptionPendingMessage =>
      'Thanh toán đang chờ xác nhận: gói đăng ký sẽ được kích hoạt ngay khi được xác nhận.';

  @override
  String subscriptionEndsOn(String date) {
    return 'Đã tắt tự động gia hạn: truy cập đến $date';
  }
}
