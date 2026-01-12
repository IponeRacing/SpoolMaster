// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Stok';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'NFC Çipini Oku';

  @override
  String get scanHistory => 'Geçmiş';

  @override
  String get writeNfcChip => 'NFC Çipine Yaz';

  @override
  String get nfcNotAvailable => 'NFC kullanılamıyor';

  @override
  String get nfcNotAvailableDesc =>
      'Cihazınız NFC\'yi desteklemiyor veya devre dışı.';

  @override
  String get nfcNotSupported => 'Bu cihazda NFC desteklenmiyor';

  @override
  String get approachNfcChip => 'Bir NFC çipine yaklaşın...';

  @override
  String get scanningNfc => 'Taranıyor...';

  @override
  String get nfcDataRead => 'NFC verileri başarıyla okundu!';

  @override
  String get errorReadingNfc => 'NFC okuma hatası';

  @override
  String get scanHistoryTitle => 'Tarama Geçmişi';

  @override
  String get noScansRecorded => 'Kayıtlı tarama yok';

  @override
  String get scansWillAppearHere =>
      'NFC taramaları burada otomatik olarak görünecek';

  @override
  String get clearAll => 'Tümünü temizle';

  @override
  String get deleteThisScan => 'Bu taramayı sil?';

  @override
  String get actionIrreversible => 'Bu işlem geri alınamaz.';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get clearAllHistory => 'Tüm geçmişi temizle?';

  @override
  String get allScansWillBeDeleted =>
      'Tüm taramalar silinecek. Bu işlem geri alınamaz.';

  @override
  String get scanDeleted => 'Tarama silindi';

  @override
  String get scanDetails => 'Tarama Detayları';

  @override
  String scannedOn(Object date) {
    return '$date tarihinde tarandı';
  }

  @override
  String get bobbinInformation => 'Makara Bilgileri';

  @override
  String get filamentType => 'Filament Türü';

  @override
  String get color => 'Renk';

  @override
  String get weight => 'Ağırlık';

  @override
  String get manufacturingDate => 'Üretim Tarihi';

  @override
  String get batchNumber => 'Parti Numarası';

  @override
  String get printerSettings => 'Yazıcı ayarları';

  @override
  String get scanMetadata => 'Tarama Meta Verileri';

  @override
  String get scanId => 'Tarama ID';

  @override
  String get dateAndTime => 'Tarih ve Saat';

  @override
  String get reuseThisData => 'Bu verileri yeniden kullan';

  @override
  String get writeToNfc => 'NFC\'ye Yaz';

  @override
  String get writeDataToChip => 'Çipe veri yaz';

  @override
  String get writeSuccess => 'Yazma başarılı!';

  @override
  String get writeError => 'Yazma hatası';

  @override
  String get brand => 'Marka';

  @override
  String get selectBrand => 'Marka seç';

  @override
  String get materialType => 'Malzeme Türü';

  @override
  String get selectMaterial => 'Malzeme seç';

  @override
  String get serialNumber => 'Seri Numarası';

  @override
  String get serialNumberHint => 'örn.: 001';

  @override
  String get initialWeight => 'Başlangıç Ağırlığı';

  @override
  String get initialWeightHint => 'örn.: 1000';

  @override
  String get extruderTempMin => 'Ekstruder Sıcaklığı Min';

  @override
  String get extruderTempMax => 'Ekstruder Sıcaklığı Maks';

  @override
  String get bedTempMin => 'Tabla Sıcaklığı Min';

  @override
  String get bedTempMax => 'Tabla Sıcaklığı Maks';

  @override
  String get diameter => 'Çap';

  @override
  String get spoolLength => 'Uzunluk (m)';

  @override
  String get generatedSku => 'Oluşturulan SKU';

  @override
  String get approachChipToWrite => 'Yazmak için çipi yaklaştırın...';

  @override
  String get writing => 'Yazılıyor...';

  @override
  String get chooseColor => 'Renk seç';

  @override
  String get required => 'Gerekli';

  @override
  String get invalid => 'Geçersiz';

  @override
  String get advancedSettings => 'Gelişmiş Ayarlar';

  @override
  String get opacity => 'Opaklık';

  @override
  String get validate => 'Doğrula';

  @override
  String get nfcTagInfo =>
      'Kendi Anycubic etiketlerinizi oluşturmak için boş bir ISO14443A NFC etiketi (NTAG213) kullanın.';

  @override
  String get stockInventory => 'Stokdaki makaralar';

  @override
  String get addSpool => 'Makara Ekle';

  @override
  String get scanSpool => 'Makara Tara';

  @override
  String get addManually => 'Elle Ekle';

  @override
  String get spoolAdded => 'Makara eklendi';

  @override
  String get spoolUpdated => 'Makara güncellendi';

  @override
  String get noSpoolsInStock => 'Stokta makara yok';

  @override
  String get addFirstSpool =>
      'Envanterinizi takip etmeye başlamak için ilk makaranızı ekleyin';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count makara düşük stokta (< $threshold%)';
  }

  @override
  String get edit => 'Düzenle';

  @override
  String get bobbinPrice => 'Makara Fiyatı';

  @override
  String get price => 'Fiyat';

  @override
  String get priceHint => 'örn.: 25.00';

  @override
  String get save => 'Kaydet';

  @override
  String get spoolDetails => 'Makara Detayları';

  @override
  String get deleteThisSpool => 'Bu makarayı sil?';

  @override
  String get cannotBeUndone => 'Bu işlem geri alınamaz.';

  @override
  String get addSpoolManually => 'Elle Makara Ekle';

  @override
  String get editSpool => 'Makara Düzenle';

  @override
  String get customBrand => 'Özel Marka';

  @override
  String get customBrandHint => 'örn.: Benim Markam';

  @override
  String get chooseFromList => 'Listeden seç';

  @override
  String get addBrand => '+ Marka Ekle';

  @override
  String get customMaterial => 'Özel Malzeme';

  @override
  String get customMaterialHint => 'örn.: Benim Malzemem';

  @override
  String get addMaterial => '+ Malzeme Ekle';

  @override
  String get colorHint => 'örn.: Mavi, Kırmızı...';

  @override
  String get enterColor => 'Lütfen bir renk girin';

  @override
  String get initialWeightG => 'Başlangıç Ağırlığı';

  @override
  String get remainingWeightG => 'Kalan Ağırlık';

  @override
  String get enterBrand => 'Lütfen bir marka girin';

  @override
  String get selectOrEnterBrand => 'Lütfen bir marka seçin veya girin';

  @override
  String get enterMaterial => 'Lütfen bir malzeme girin';

  @override
  String get selectOrEnterMaterial => 'Lütfen bir malzeme seçin veya girin';

  @override
  String get enterPrice => 'Lütfen bir fiyat girin';

  @override
  String get enterValidPrice => 'Lütfen geçerli bir fiyat girin';

  @override
  String get enterWeight => 'Lütfen bir ağırlık girin';

  @override
  String get enterValidWeight => 'Lütfen geçerli bir ağırlık girin';

  @override
  String get remainingCannotExceedTotal =>
      'Kalan ağırlık toplam ağırlığı aşamaz';

  @override
  String get overview => 'Genel Bakış';

  @override
  String get spoolsInStock => 'Stokta Makara';

  @override
  String get totalValue => 'Toplam Değer';

  @override
  String get lowStockSpools => 'Düşük Stok';

  @override
  String get materialDistribution => 'Malzemeye Göre Dağılım';

  @override
  String get brandDistribution => 'Markaya Göre Dağılım';

  @override
  String get noData => 'Veri yok';

  @override
  String get refresh => 'Yenile';

  @override
  String get profileSettings => 'Profil Ayarları';

  @override
  String get preferences => 'Tercihler';

  @override
  String get language => 'Dil';

  @override
  String get selectLanguage => 'Dil seç';

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
  String get currency => 'Para Birimi';

  @override
  String get selectCurrency => 'Para birimi seç';

  @override
  String get units => 'Birimler';

  @override
  String get selectUnits => 'Birim seç';

  @override
  String get metric => 'Metrik (mm, g, °C)';

  @override
  String get imperial => 'İmparatorluk (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Düşük Stok Uyarı Eşiği';

  @override
  String get lowStockThresholdDesc =>
      'Kalan ağırlık bu yüzdeden azsa, makara düşük stokta kabul edilir';

  @override
  String get authentication => 'Kimlik Doğrulama';

  @override
  String get signInWithGoogle => 'Google ile oturum aç';

  @override
  String get signInWithApple => 'Apple ile oturum aç';

  @override
  String get comingSoon => 'Yakında';

  @override
  String get about => 'Hakkında';

  @override
  String get version => 'Sürüm';

  @override
  String get madeWith => 'Anycubic 3D Yazıcılar için ❤️ ile yapıldı';

  @override
  String get scanBobbinDirectly => 'Makara Tara';

  @override
  String get nfcEncoder => 'NFC Kodlayıcı';

  @override
  String get length => 'Uzunluk';

  @override
  String get tempExtruder => 'Ekstruder Sıcaklığı';

  @override
  String get tempBed => 'Tabla Sıcaklığı';

  @override
  String get termsOfService => 'Hizmet Şartları';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Geri';

  @override
  String get retry => 'Yeniden Dene';

  @override
  String get signOut => 'Oturumu Kapat';

  @override
  String get extruderTempMinHint => 'örn.: 200';

  @override
  String get extruderTempMaxHint => 'örn.: 220';

  @override
  String get bedTempMinHint => 'örn.: 50';

  @override
  String get bedTempMaxHint => 'örn.: 60';

  @override
  String get diameterHint => 'örn.: 1.75';

  @override
  String get spoolLengthHint => 'örn.: 330';

  @override
  String get tabGrid => 'Izgara';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Kaydırıcılar';

  @override
  String get hexCode => 'Onaltılık Kod';

  @override
  String get red => 'Kırmızı';

  @override
  String get green => 'Yeşil';

  @override
  String get blue => 'Mavi';

  @override
  String get metricUnits => 'Metrik (mm, g, °C)';

  @override
  String get imperialUnits => 'İmparatorluk (in, oz, °F)';

  @override
  String get chf => 'İsviçre Frangı (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'ABD Doları (\$)';

  @override
  String get gbp => 'İngiliz Sterlini (£)';

  @override
  String get cad => 'Kanada Doları (CAD)';

  @override
  String get filamentsToOrder => 'Sipariş edilecek filamentler';

  @override
  String get shoppingList => 'Alışveriş listesi';

  @override
  String get addToShoppingList => 'Listeye ekle';

  @override
  String get noLowStockFilaments => 'Düşük stokta filament yok';

  @override
  String get vipSubscriptionDescription =>
      'Bu abonelik sadece uygulama içi reklamları devre dışı bırakmak ve projeyi desteklemek içindir. Başka bir işlevsellik yok.';

  @override
  String get monthlySubscription => 'Aylık Abonelik';

  @override
  String get yearlySubscription => 'Yıllık Abonelik';

  @override
  String get perMonth => '/ ay';

  @override
  String get perYear => '/ yıl';

  @override
  String onlyPerMonth(String price) {
    return 'Sadece $price / ay';
  }

  @override
  String get subscribe => 'Abone ol';

  @override
  String get bestOffer => '✨ EN İYİ TEKLİF ✨';

  @override
  String get forAnycubicAce => 'Anycubic Ace için';

  @override
  String get forBambuLabAms => 'Bambu Lab AMS için';

  @override
  String get scanNfcChip => 'NFC çipini tara';

  @override
  String get fillForm => 'Formu doldur';

  @override
  String get emptyShoppingList => 'Listede filament yok';

  @override
  String percentRemaining(String percent) {
    return '$percent% kaldı';
  }

  @override
  String get markAsOrdered => 'Sipariş edildi olarak işaretle';

  @override
  String get markAsNotOrdered => 'Sipariş edilmedi olarak işaretle';

  @override
  String get notSignedIn => 'Giriş yapılmadı';

  @override
  String get signIn => 'Giriş yap';

  @override
  String get connection => 'Giriş';

  @override
  String get signInToSync => 'Verilerinizi senkronize etmek için giriş yapın';

  @override
  String get continueWithoutAccount => 'Hesapsız devam et (yerel mod)';

  @override
  String get privacyNotice =>
      'Giriş yaparak\nKullanım Koşullarımızı ve Gizlilik Politikamızı kabul etmiş olursunuz';

  @override
  String get updateStock => 'Stok güncelle';

  @override
  String get scanToUpdateStock => 'Güncellemek için tara';

  @override
  String get weightUsed => 'Kullanılan ağırlık';

  @override
  String get lengthUsed => 'Kullanılan uzunluk';

  @override
  String get enterWeightOrLength => 'Kullanılan ağırlık veya uzunluğu girin';

  @override
  String get weightUsedG => 'Kullanılan ağırlık (g)';

  @override
  String get lengthUsedM => 'Kullanılan uzunluk (m)';

  @override
  String get stockUpdated => 'Stok güncellendi';

  @override
  String get scanSpoolToUpdate => 'Stokunu güncellemek için bir makara tarayın';

  @override
  String get spoolNotFound => 'Stokta makara bulunamadı';

  @override
  String get addSpoolFirstMessage =>
      'Bu makara henüz stoğunuzda değil. Lütfen stokunu güncellemeden önce \'Makara Ekle\' düğmesini kullanarak önce ekleyin.';

  @override
  String get ok => 'Tamam';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Salt okunur';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab etiketleri RSA şifrelemesi kullanır ve değiştirilemez. Salt okunur.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab Klon Kütüphanesi';

  @override
  String get noBambuClones => 'Bambu Lab klonu yok';

  @override
  String get scanBambuToClone =>
      'Klon kütüphanenizi oluşturmak için orijinal Bambu Lab etiketlerini tarayın';

  @override
  String get scanTag => 'Bir etiket tarayın';

  @override
  String get syncWithCloud => 'Bulutla senkronize et';

  @override
  String get syncCompleted => 'Senkronizasyon tamamlandı';

  @override
  String get deleteClone => 'Klonu sil';

  @override
  String get renameClone => 'Klonu yeniden adlandır';

  @override
  String get rename => 'Yeniden adlandır';

  @override
  String get customName => 'Özel ad';

  @override
  String get clonedOn => 'Klonlandı';

  @override
  String get writeThisClone => 'Bu klonu yaz';

  @override
  String get writeClone => 'Klon yaz';

  @override
  String get writeOnCUID => 'CUID kartına yaz';

  @override
  String get cloneWrittenSuccess => 'Klon başarıyla yazıldı!';

  @override
  String get requiredTagFormat => 'Gerekli etiket formatı';

  @override
  String get type => 'Tür';

  @override
  String get frequency => 'Frekans';

  @override
  String get protocol => 'Protokol';

  @override
  String get capacity => 'Kapasite';

  @override
  String get feature => 'Özellik';

  @override
  String get uidModifiable => 'Blok 0 (UID) değiştirilebilir';

  @override
  String get whereToBuy =>
      'AliExpress, Amazon veya eBay\'de \"CUID MiFare Classic 1K\" arayın (~\$0.50/adet)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 Kart - Yazılabilir Block 0 (UID) ile MiFare Classic 1K';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'AliExpress, Amazon veya eBay\'de \"Magic Gen2 MiFare Classic 1K\" veya \"UID writable\" arayın (~\$0.50/adet)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Uyarı: iPhone NFC ile yazma tüm Magic Gen2 kartlarda çalışmayabilir. Güvenilirlik için NFC Tools Pro uygulaması ile Android veya Proxmark3 cihazı önerilir.';

  @override
  String get step1GetMagicGen2 =>
      'Boş bir Magic Gen2 kart edinin (Yazılabilir UID ile MiFare Classic 1K)';

  @override
  String get instructions => 'Talimatlar';

  @override
  String get step1GetCUID => 'Boş bir CUID kartı edinin (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Aşağıdaki \"Yaz\" düğmesine basın';

  @override
  String get step3HoldPhone => 'iPhone\'unuzu CUID kartına yakın tutun';

  @override
  String get step4WaitConfirm => 'Yazma onayını bekleyin';

  @override
  String get step5TestClone =>
      'Klonlanan etiketi Bambu Lab yazıcınızda test edin!';

  @override
  String get rsaIncluded =>
      'Klon orijinal RSA imzasını içerir, yazıcı tarafından kabul edilecektir!';

  @override
  String get cloneDeleted => 'Klon silindi';
}
