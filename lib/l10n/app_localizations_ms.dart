// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Stok';

  @override
  String get statistics => 'Analitik';

  @override
  String get profile => 'Profil';

  @override
  String get readNfcChip => 'Baca Cip NFC';

  @override
  String get scanHistory => 'Sejarah';

  @override
  String get writeNfcChip => 'Tulis Cip NFC';

  @override
  String get nfcNotAvailable => 'NFC tidak tersedia';

  @override
  String get nfcNotAvailableDesc =>
      'Peranti anda tidak menyokong NFC atau ia dilumpuhkan.';

  @override
  String get nfcNotSupported => 'NFC tidak disokong pada peranti ini';

  @override
  String get approachNfcChip => 'Dekatkan cip NFC...';

  @override
  String get scanningNfc => 'Mengimbas...';

  @override
  String get nfcDataRead => 'Data NFC berjaya dibaca!';

  @override
  String get errorReadingNfc => 'Ralat membaca NFC';

  @override
  String get scanHistoryTitle => 'Sejarah Imbasan';

  @override
  String get noScansRecorded => 'Tiada imbasan direkodkan';

  @override
  String get scansWillAppearHere =>
      'Imbasan NFC akan muncul di sini secara automatik';

  @override
  String get clearAll => 'Kosongkan semua';

  @override
  String get deleteThisScan => 'Padam imbasan ini?';

  @override
  String get actionIrreversible => 'Tindakan ini tidak boleh dibatalkan.';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Padam';

  @override
  String get clearAllHistory => 'Kosongkan semua sejarah?';

  @override
  String get allScansWillBeDeleted =>
      'Semua imbasan akan dipadamkan. Tindakan ini tidak boleh dibatalkan.';

  @override
  String get scanDeleted => 'Imbasan dipadamkan';

  @override
  String get scanDetails => 'Butiran Imbasan';

  @override
  String scannedOn(Object date) {
    return 'Diimbas pada $date';
  }

  @override
  String get bobbinInformation => 'Maklumat Gelendong';

  @override
  String get filamentType => 'Jenis Filamen';

  @override
  String get color => 'Warna';

  @override
  String get weight => 'Berat';

  @override
  String get manufacturingDate => 'Tarikh Pembuatan';

  @override
  String get batchNumber => 'Nombor Kumpulan';

  @override
  String get printerSettings => 'Tetapan Pencetak';

  @override
  String get scanMetadata => 'Metadata Imbasan';

  @override
  String get scanId => 'ID Imbasan';

  @override
  String get dateAndTime => 'Tarikh dan Masa';

  @override
  String get reuseThisData => 'Guna semula data ini';

  @override
  String get writeToNfc => 'Tulis ke NFC';

  @override
  String get writeDataToChip => 'Tulis data ke cip';

  @override
  String get writeSuccess => 'Penulisan berjaya!';

  @override
  String get writeError => 'Ralat penulisan';

  @override
  String get brand => 'Jenama';

  @override
  String get selectBrand => 'Pilih jenama';

  @override
  String get materialType => 'Jenis Bahan';

  @override
  String get selectMaterial => 'Pilih bahan';

  @override
  String get serialNumber => 'Nombor Siri';

  @override
  String get serialNumberHint => 'cth.: 001';

  @override
  String get initialWeight => 'Berat Awal';

  @override
  String get initialWeightHint => 'cth.: 1000';

  @override
  String get extruderTempMin => 'Suhu Penyemperit Min';

  @override
  String get extruderTempMax => 'Suhu Penyemperit Maks';

  @override
  String get bedTempMin => 'Suhu Bed Min';

  @override
  String get bedTempMax => 'Suhu Bed Maks';

  @override
  String get diameter => 'Diameter Filamen';

  @override
  String get spoolLength => 'Panjang Gelendong';

  @override
  String get generatedSku => 'SKU yang Dihasilkan';

  @override
  String get approachChipToWrite => 'Dekatkan cip untuk menulis...';

  @override
  String get writing => 'Menulis...';

  @override
  String get chooseColor => 'Pilih warna';

  @override
  String get required => 'Diperlukan';

  @override
  String get invalid => 'Tidak sah';

  @override
  String get advancedSettings => 'Tetapan Lanjutan';

  @override
  String get opacity => 'Kelegapan';

  @override
  String get validate => 'Sahkan';

  @override
  String get nfcTagInfo =>
      'Gunakan tag NFC kosong ISO14443A (NTAG213) untuk mencipta tag Anycubic anda sendiri.';

  @override
  String get stockInventory => 'Spool dalam stok';

  @override
  String get addSpool => 'Tambah Gelendong';

  @override
  String get scanSpool => 'Imbas Gelendong';

  @override
  String get addManually => 'Tambah secara manual';

  @override
  String get spoolAdded => 'Gelendong ditambah';

  @override
  String get spoolUpdated => 'Gelendong dikemas kini';

  @override
  String get noSpoolsInStock => 'Tiada gelendong dalam stok';

  @override
  String get addFirstSpool =>
      'Tambah gelendong pertama anda untuk mula menjejak inventori';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count gelendong stok rendah (< $threshold%)';
  }

  @override
  String get edit => 'Edit';

  @override
  String get bobbinPrice => 'Harga Gelendong';

  @override
  String get price => 'Harga';

  @override
  String get priceHint => 'cth.: 25.00';

  @override
  String get save => 'Simpan';

  @override
  String get spoolDetails => 'Butiran Gelendong';

  @override
  String get deleteThisSpool => 'Padam gelendong ini?';

  @override
  String get cannotBeUndone => 'Tindakan ini tidak boleh dibatalkan.';

  @override
  String get addSpoolManually => 'Tambah Gelendong Secara Manual';

  @override
  String get editSpool => 'Edit Gelendong';

  @override
  String get customBrand => 'Jenama Tersuai';

  @override
  String get customBrandHint => 'cth.: Jenama Saya';

  @override
  String get chooseFromList => 'Pilih dari senarai';

  @override
  String get addBrand => '+ Tambah Jenama';

  @override
  String get customMaterial => 'Bahan Tersuai';

  @override
  String get customMaterialHint => 'cth.: Bahan Saya';

  @override
  String get addMaterial => '+ Tambah Bahan';

  @override
  String get colorHint => 'cth.: Biru, Merah...';

  @override
  String get enterColor => 'Sila masukkan warna';

  @override
  String get initialWeightG => 'Berat Awal';

  @override
  String get remainingWeightG => 'Berat Baki';

  @override
  String get enterBrand => 'Sila masukkan jenama';

  @override
  String get selectOrEnterBrand => 'Sila pilih atau masukkan jenama';

  @override
  String get enterMaterial => 'Sila masukkan bahan';

  @override
  String get selectOrEnterMaterial => 'Sila pilih atau masukkan bahan';

  @override
  String get enterPrice => 'Sila masukkan harga';

  @override
  String get enterValidPrice => 'Sila masukkan harga yang sah';

  @override
  String get enterWeight => 'Sila masukkan berat';

  @override
  String get enterValidWeight => 'Sila masukkan berat yang sah';

  @override
  String get remainingCannotExceedTotal =>
      'Berat baki tidak boleh melebihi jumlah berat';

  @override
  String get overview => 'Gambaran Keseluruhan';

  @override
  String get spoolsInStock => 'Gelendong dalam Stok';

  @override
  String get totalValue => 'Jumlah Nilai';

  @override
  String get lowStockSpools => 'Stok Rendah';

  @override
  String get materialDistribution => 'Taburan mengikut Bahan';

  @override
  String get brandDistribution => 'Taburan mengikut Jenama';

  @override
  String get noData => 'Tiada data';

  @override
  String get refresh => 'Segar Semula';

  @override
  String get profileSettings => 'Tetapan Profil';

  @override
  String get preferences => 'Keutamaan';

  @override
  String get language => 'Bahasa';

  @override
  String get selectLanguage => 'Pilih bahasa';

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
  String get currency => 'Mata Wang';

  @override
  String get selectCurrency => 'Pilih mata wang';

  @override
  String get units => 'Unit';

  @override
  String get selectUnits => 'Pilih unit';

  @override
  String get metric => 'Metrik (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Ambang Amaran Stok Rendah';

  @override
  String get lowStockThresholdDesc =>
      'Gelendong akan dianggap stok rendah jika berat baki kurang daripada peratusan ini';

  @override
  String get authentication => 'Pengesahan';

  @override
  String get signInWithGoogle => 'Log masuk dengan Google';

  @override
  String get signInWithApple => 'Log masuk dengan Apple';

  @override
  String get continueWithApple => 'Teruskan dengan Apple';

  @override
  String get continueWithGoogle => 'Teruskan dengan Google';

  @override
  String get comingSoon => 'Akan datang';

  @override
  String get about => 'Perihal';

  @override
  String get version => 'Versi';

  @override
  String get madeWith => 'Dibuat dengan ❤️ untuk Pencetak 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Imbas Gelendong';

  @override
  String get nfcEncoder => 'Pengekod NFC';

  @override
  String get length => 'Panjang';

  @override
  String get tempExtruder => 'Suhu Penyemperit';

  @override
  String get tempBed => 'Suhu Bed';

  @override
  String get termsOfService => 'Terma Perkhidmatan';

  @override
  String get privacyPolicy => 'Dasar Privasi';

  @override
  String get legal => 'Legal';

  @override
  String get back => 'Kembali';

  @override
  String get retry => 'Cuba lagi';

  @override
  String get signOut => 'Log keluar';

  @override
  String get extruderTempMinHint => 'Cth.: 200';

  @override
  String get extruderTempMaxHint => 'Cth.: 220';

  @override
  String get bedTempMinHint => 'Cth.: 50';

  @override
  String get bedTempMaxHint => 'Cth.: 60';

  @override
  String get diameterHint => 'Cth.: 1.75';

  @override
  String get spoolLengthHint => 'Cth.: 330';

  @override
  String get tabGrid => 'Grid';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Penggelongsor';

  @override
  String get hexCode => 'Kod Hex';

  @override
  String get red => 'Merah';

  @override
  String get green => 'Hijau';

  @override
  String get blue => 'Biru';

  @override
  String get metricUnits => 'Metrik (mm, g, °C)';

  @override
  String get imperialUnits => 'Imperial (in, oz, °F)';

  @override
  String get chf => 'Franc Swiss (CHF)';

  @override
  String get eur => 'Euro (€)';

  @override
  String get usd => 'Dolar AS (\$)';

  @override
  String get gbp => 'Paun Sterling (£)';

  @override
  String get cad => 'Dolar Kanada (CAD)';

  @override
  String get filamentsToOrder => 'Filamen untuk Dipesan';

  @override
  String get shoppingList => 'Senarai Beli-belah';

  @override
  String get addToShoppingList => 'Tambah ke Senarai';

  @override
  String get noLowStockFilaments => 'Tiada filamen stok rendah';

  @override
  String get vipSubscriptionDescription =>
      'Langganan ini hanya digunakan untuk melumpuhkan iklan dalam aplikasi dan menyokong projek. Tiada ciri lain.';

  @override
  String get monthlySubscription => 'Langganan Bulanan';

  @override
  String get yearlySubscription => 'Langganan Tahunan';

  @override
  String get perMonth => '/ bulan';

  @override
  String get perYear => '/ tahun';

  @override
  String onlyPerMonth(String price) {
    return 'Hanya $price / bulan';
  }

  @override
  String get subscribe => 'Langgan';

  @override
  String get bestOffer => '✨ TAWARAN TERBAIK ✨';

  @override
  String get forAnycubicAce => 'untuk Anycubic Ace';

  @override
  String get forBambuLabAms => 'untuk Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Imbas cip NFC';

  @override
  String get fillForm => 'Isi borang';

  @override
  String get emptyShoppingList => 'Tiada filamen dalam senarai';

  @override
  String percentRemaining(String percent) {
    return '$percent% baki';
  }

  @override
  String get markAsOrdered => 'Tandakan sebagai dipesan';

  @override
  String get markAsNotOrdered => 'Tandakan sebagai belum dipesan';

  @override
  String get notSignedIn => 'Tidak log masuk';

  @override
  String get signIn => 'Log masuk';

  @override
  String get connection => 'Sambungan';

  @override
  String get signInToSync => 'Log masuk untuk menyegerakkan data anda';

  @override
  String get continueWithoutAccount => 'Teruskan tanpa akaun (mod tempatan)';

  @override
  String get privacyNotice =>
      'Dengan log masuk, anda menerima\nTerma Perkhidmatan dan Dasar Privasi kami';

  @override
  String get updateStock => 'Kemas kini stok';

  @override
  String get scanToUpdateStock => 'Imbas untuk kemas kini';

  @override
  String get weightUsed => 'Berat digunakan';

  @override
  String get lengthUsed => 'Panjang digunakan';

  @override
  String get enterWeightOrLength =>
      'Masukkan berat atau panjang yang digunakan';

  @override
  String get weightUsedG => 'Berat digunakan (g)';

  @override
  String get lengthUsedM => 'Panjang digunakan (m)';

  @override
  String get stockUpdated => 'Stok dikemas kini';

  @override
  String get scanSpoolToUpdate => 'Imbas gelendong untuk kemas kini stoknya';

  @override
  String get spoolNotFound => 'Gelendong tidak dijumpai dalam stok';

  @override
  String get addSpoolFirstMessage =>
      'Gelendong ini belum ada dalam stok anda. Sila tambahkannya terlebih dahulu menggunakan butang \'Tambah Gelendong\' sebelum mengemas kini stoknya.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Hanya baca';

  @override
  String get bambuLabReadOnlyDesc =>
      'Tag Bambu Lab menggunakan penyulitan RSA dan tidak boleh diubah suai. Hanya baca.';

  @override
  String get bambuCloneLibrary => 'Perpustakaan Klon Bambu Lab';

  @override
  String get noBambuClones => 'Tiada klon Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Imbas tag Bambu Lab asal untuk mencipta perpustakaan klon anda';

  @override
  String get scanTag => 'Imbas tag';

  @override
  String get syncWithCloud => 'Segerakkan dengan awan';

  @override
  String get syncCompleted => 'Penyegerakan selesai';

  @override
  String get deleteClone => 'Padam klon';

  @override
  String get renameClone => 'Namakan semula klon';

  @override
  String get rename => 'Namakan semula';

  @override
  String get customName => 'Nama tersuai';

  @override
  String get clonedOn => 'Diklon pada';

  @override
  String get writeThisClone => 'Tulis klon ini';

  @override
  String get writeClone => 'Tulis klon';

  @override
  String get writeOnCUID => 'Tulis pada kad CUID';

  @override
  String get cloneWrittenSuccess => 'Klon berjaya ditulis!';

  @override
  String get requiredTagFormat => 'Format tag yang diperlukan';

  @override
  String get type => 'Jenis';

  @override
  String get frequency => 'Frekuensi';

  @override
  String get protocol => 'Protokol';

  @override
  String get capacity => 'Kapasiti';

  @override
  String get feature => 'Ciri';

  @override
  String get uidModifiable => 'Blok 0 (UID) boleh diubah suai';

  @override
  String get whereToBuy =>
      'Cari \"CUID MiFare Classic 1K\" di AliExpress, Amazon atau eBay (~\$0.50/keping)';

  @override
  String get magicGen2Required =>
      'Kad Magic Gen2 - MiFare Classic 1K dengan Block 0 (UID) boleh ditulis';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Cari \"Magic Gen2 MiFare Classic 1K\" atau \"UID writable\" di AliExpress, Amazon atau eBay (~\$0.50/keping)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Amaran: Menulis dengan iPhone NFC mungkin tidak berfungsi pada semua kad Magic Gen2. Peranti Proxmark3 disyorkan untuk kebolehpercayaan maksimum.';

  @override
  String get step1GetMagicGen2 =>
      'Dapatkan kad Magic Gen2 kosong (MiFare Classic 1K dengan UID boleh ditulis)';

  @override
  String get instructions => 'Arahan';

  @override
  String get step1GetCUID => 'Dapatkan kad CUID kosong (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Tekan butang \"Tulis\" di bawah';

  @override
  String get step3HoldPhone => 'Pegang iPhone anda berhampiran kad CUID';

  @override
  String get step4WaitConfirm => 'Tunggu pengesahan penulisan';

  @override
  String get step5TestClone =>
      'Uji tag yang diklon pada pencetak Bambu Lab anda!';

  @override
  String get rsaIncluded =>
      'Klon termasuk tandatangan RSA asal, ia akan diterima oleh pencetak!';

  @override
  String get cloneDeleted => 'Klon dipadam';

  @override
  String get deleteAccount => 'Padam akaun saya';

  @override
  String get deleteAccountConfirmation =>
      'Tindakan ini tidak boleh dibatalkan. Akaun dan semua data anda akan dipadamkan dalam 30 hari.';

  @override
  String get accountDeletionRequested => 'Permintaan pemadaman didaftarkan';

  @override
  String get clearShoppingList => 'Kosongkan senarai';

  @override
  String get clearShoppingListConfirmation =>
      'Adakah anda pasti mahu mengosongkan seluruh senarai beli-belah? Tindakan ini tidak boleh dibatalkan.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Sejarah';

  @override
  String get retryButton => 'Cuba lagi';

  @override
  String get readSuccessMessage => 'Berjaya membaca!';

  @override
  String get filamentTypeLabel => 'Jenis filamen';

  @override
  String get scanNfcChipButton => 'Imbas cip NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Padam klon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klon \"$name\" dipadam';
  }

  @override
  String get extruderLabel => 'Ekstruder';

  @override
  String get writeThisCloneButton => 'Tulis klon ini';

  @override
  String get customNameHint => 'Nama tersuai';

  @override
  String get cloneWriteSuccessMessage => 'Klon berjaya ditulis!';

  @override
  String errorPrefix(String error) {
    return 'Ralat: $error';
  }

  @override
  String get writingInProgress => 'Menulis...';

  @override
  String get writeOnCUIDButton => 'Tulis pada kad CUID';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get extruderTempLabel => 'Suhu ekstruder';

  @override
  String get bedTempLabel => 'Suhu katil';

  @override
  String get nfcFrequency => '13.56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K bait (1024 bait)';

  @override
  String get rsaSignatureNote =>
      'Klon mengandungi tandatangan RSA asal, ia akan diterima oleh pencetak!';

  @override
  String get writeBambuLabTagTitle => 'Tulis tag Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'Tag Bambu Lab berjaya ditulis!';

  @override
  String get approachNfcTagMessage => 'Dekatkan tag NFC...';

  @override
  String get bambuLabFormatMiFare => 'Format Bambu Lab (MiFare 13.56 MHz)';

  @override
  String get bambuLabFormat => 'Format Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Format ini menggunakan kod bahan Bambu Lab dan menyimpan data dalam format yang serasi dengan AMS.';

  @override
  String get brandLabel => 'Jenama';

  @override
  String get materialTypeLabel => 'Jenis bahan';

  @override
  String get serialNumber3Digits => 'Nombor siri (3 digit)';

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
  String get writeBambuLabTagButton => 'Tulis tag Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Nota: Tag Bambu Lab asal menggunakan penyulitan RSA. Mod ini menulis data dalam format mudah yang serasi.';

  @override
  String signInError(String error) {
    return 'Ralat log masuk: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Langganan berjaya diaktifkan!';

  @override
  String get subscriptionFailedMessage => 'Langganan gagal';

  @override
  String errorMessage(String error) {
    return 'Ralat: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Langganan berjaya dipulihkan!';

  @override
  String get noSubscriptionFoundMessage => 'Langganan tidak dijumpai';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTIF';

  @override
  String get noAdsExperienceMessage => 'Nikmati pengalaman tanpa iklan!';

  @override
  String get subscribedLabel => 'Dilanggan';

  @override
  String get restorePurchasesButton => 'Pulihkan pembelian';

  @override
  String get cannotExceedRemainingWeight =>
      'Tidak boleh melebihi berat yang tinggal';

  @override
  String get pleaseEnterLength => 'Sila masukkan panjang';

  @override
  String get pleaseEnterValidLength => 'Sila masukkan panjang yang sah';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Panjang gelendong tidak ditetapkan - tidak dapat menukar';

  @override
  String get exceedsRemainingWeight => 'Melebihi berat yang tinggal';

  @override
  String get skuLabel => 'SKU';
}
