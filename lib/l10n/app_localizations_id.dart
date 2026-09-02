// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

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
  String get readNfcChip => 'Baca Chip NFC';

  @override
  String get scanHistory => 'Riwayat';

  @override
  String get writeNfcChip => 'Tulis Chip NFC';

  @override
  String get nfcNotAvailable => 'NFC tidak tersedia';

  @override
  String get nfcNotAvailableDesc =>
      'Perangkat Anda tidak mendukung NFC atau dinonaktifkan.';

  @override
  String get nfcNotSupported => 'NFC tidak didukung pada perangkat ini';

  @override
  String get approachNfcChip => 'Dekatkan chip NFC...';

  @override
  String get scanningNfc => 'Memindai...';

  @override
  String get nfcDataRead => 'Data NFC berhasil dibaca!';

  @override
  String get errorReadingNfc => 'Kesalahan membaca NFC';

  @override
  String get scanHistoryTitle => 'Riwayat Pemindaian';

  @override
  String get noScansRecorded => 'Tidak ada pemindaian yang tercatat';

  @override
  String get scansWillAppearHere =>
      'Pemindaian NFC akan muncul di sini secara otomatis';

  @override
  String get clearAll => 'Hapus semua';

  @override
  String get deleteThisScan => 'Hapus pemindaian ini?';

  @override
  String get actionIrreversible => 'Tindakan ini tidak dapat dibatalkan.';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get clearAllHistory => 'Hapus semua riwayat?';

  @override
  String get allScansWillBeDeleted =>
      'Semua pemindaian akan dihapus. Tindakan ini tidak dapat dibatalkan.';

  @override
  String get scanDeleted => 'Pemindaian dihapus';

  @override
  String get scanDetails => 'Detail Pemindaian';

  @override
  String scannedOn(Object date) {
    return 'Dipindai pada $date';
  }

  @override
  String get bobbinInformation => 'Informasi Gulungan';

  @override
  String get filamentType => 'Jenis Filamen';

  @override
  String get color => 'Warna';

  @override
  String get weight => 'Berat';

  @override
  String get manufacturingDate => 'Tanggal Produksi';

  @override
  String get batchNumber => 'Nomor Batch';

  @override
  String get printerSettings => 'Pengaturan Printer';

  @override
  String get scanMetadata => 'Metadata Pemindaian';

  @override
  String get scanId => 'ID Pemindaian';

  @override
  String get dateAndTime => 'Tanggal dan Waktu';

  @override
  String get reuseThisData => 'Gunakan kembali data ini';

  @override
  String get writeToNfc => 'Tulis ke NFC';

  @override
  String get writeDataToChip => 'Tulis data ke chip';

  @override
  String get writeSuccess => 'Penulisan berhasil!';

  @override
  String get writeError => 'Kesalahan penulisan';

  @override
  String get brand => 'Merek';

  @override
  String get selectBrand => 'Pilih merek';

  @override
  String get materialType => 'Jenis Material';

  @override
  String get selectMaterial => 'Pilih material';

  @override
  String get serialNumber => 'Nomor Seri';

  @override
  String get serialNumberHint => 'mis.: 001';

  @override
  String get initialWeight => 'Berat Awal';

  @override
  String get initialWeightHint => 'mis.: 1000';

  @override
  String get extruderTempMin => 'Suhu Ekstruder Min';

  @override
  String get extruderTempMax => 'Suhu Ekstruder Maks';

  @override
  String get bedTempMin => 'Suhu Bed Min';

  @override
  String get bedTempMax => 'Suhu Bed Maks';

  @override
  String get diameter => 'Diameter Filamen';

  @override
  String get spoolLength => 'Panjang Gulungan';

  @override
  String get generatedSku => 'SKU yang Dihasilkan';

  @override
  String get approachChipToWrite => 'Dekatkan chip untuk menulis...';

  @override
  String get writing => 'Menulis...';

  @override
  String get chooseColor => 'Pilih warna';

  @override
  String get required => 'Wajib';

  @override
  String get invalid => 'Tidak valid';

  @override
  String get advancedSettings => 'Pengaturan Lanjutan';

  @override
  String get opacity => 'Opasitas';

  @override
  String get validate => 'Validasi';

  @override
  String get nfcTagInfo =>
      'Gunakan tag NFC kosong ISO14443A (NTAG213) untuk membuat tag Anycubic Anda sendiri.';

  @override
  String get stockInventory => 'Spool dalam stok';

  @override
  String get addSpool => 'Tambah Gulungan';

  @override
  String get scanSpool => 'Pindai Gulungan';

  @override
  String get addManually => 'Tambah manual';

  @override
  String get spoolAdded => 'Gulungan ditambahkan';

  @override
  String get spoolUpdated => 'Gulungan diperbarui';

  @override
  String get noSpoolsInStock => 'Tidak ada gulungan dalam stok';

  @override
  String get addFirstSpool =>
      'Tambahkan gulungan pertama Anda untuk mulai melacak inventaris';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count gulungan stok rendah (< $threshold%)';
  }

  @override
  String get edit => 'Edit';

  @override
  String get bobbinPrice => 'Harga Gulungan';

  @override
  String get price => 'Harga';

  @override
  String get priceHint => 'mis.: 25.00';

  @override
  String get save => 'Simpan';

  @override
  String get spoolDetails => 'Detail Gulungan';

  @override
  String get deleteThisSpool => 'Hapus gulungan ini?';

  @override
  String get cannotBeUndone => 'Tindakan ini tidak dapat dibatalkan.';

  @override
  String get addSpoolManually => 'Tambah Gulungan Manual';

  @override
  String get editSpool => 'Edit Gulungan';

  @override
  String get customBrand => 'Merek Kustom';

  @override
  String get customBrandHint => 'mis.: Merek Saya';

  @override
  String get chooseFromList => 'Pilih dari daftar';

  @override
  String get addBrand => '+ Tambah Merek';

  @override
  String get customMaterial => 'Material Kustom';

  @override
  String get customMaterialHint => 'mis.: Material Saya';

  @override
  String get addMaterial => '+ Tambah Material';

  @override
  String get colorHint => 'mis.: Biru, Merah...';

  @override
  String get enterColor => 'Silakan masukkan warna';

  @override
  String get initialWeightG => 'Berat Awal';

  @override
  String get remainingWeightG => 'Berat Tersisa';

  @override
  String get enterBrand => 'Silakan masukkan merek';

  @override
  String get selectOrEnterBrand => 'Silakan pilih atau masukkan merek';

  @override
  String get quantity => 'Jumlah';

  @override
  String get quantityHelper => 'Tambahkan beberapa gulungan identik sekaligus';

  @override
  String get quantityInvalid => 'Masukkan angka antara 1 dan 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count tersedia';
  }

  @override
  String get enterMaterial => 'Silakan masukkan material';

  @override
  String get selectOrEnterMaterial => 'Silakan pilih atau masukkan material';

  @override
  String get enterPrice => 'Silakan masukkan harga';

  @override
  String get enterValidPrice => 'Silakan masukkan harga yang valid';

  @override
  String get enterWeight => 'Silakan masukkan berat';

  @override
  String get enterValidWeight => 'Silakan masukkan berat yang valid';

  @override
  String get remainingCannotExceedTotal =>
      'Berat tersisa tidak boleh melebihi berat total';

  @override
  String get overview => 'Ringkasan';

  @override
  String get spoolsInStock => 'Gulungan dalam Stok';

  @override
  String get totalValue => 'Nilai Total';

  @override
  String get lowStockSpools => 'Stok Rendah';

  @override
  String get materialDistribution => 'Distribusi berdasarkan Material';

  @override
  String get brandDistribution => 'Distribusi berdasarkan Merek';

  @override
  String get noData => 'Tidak ada data';

  @override
  String get refresh => 'Segarkan';

  @override
  String get profileSettings => 'Pengaturan Profil';

  @override
  String get preferences => 'Preferensi';

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
  String get currency => 'Mata Uang';

  @override
  String get selectCurrency => 'Pilih mata uang';

  @override
  String get units => 'Unit';

  @override
  String get selectUnits => 'Pilih unit';

  @override
  String get metric => 'Metrik (mm, g, °C)';

  @override
  String get imperial => 'Imperial (in, oz, °F)';

  @override
  String get lowStockThreshold => 'Ambang Batas Peringatan Stok Rendah';

  @override
  String get lowStockThresholdDesc =>
      'Sebuah gulungan akan dianggap stok rendah jika berat tersisa kurang dari persentase ini';

  @override
  String get authentication => 'Autentikasi';

  @override
  String get signInWithGoogle => 'Masuk dengan Google';

  @override
  String get signInWithApple => 'Masuk dengan Apple';

  @override
  String get continueWithApple => 'Lanjutkan dengan Apple';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get comingSoon => 'Segera hadir';

  @override
  String get about => 'Tentang';

  @override
  String get version => 'Versi';

  @override
  String get madeWith => 'Dibuat dengan ❤️ untuk Printer 3D Anycubic';

  @override
  String get scanBobbinDirectly => 'Pindai Gulungan';

  @override
  String get nfcEncoder => 'Encoder NFC';

  @override
  String get length => 'Panjang';

  @override
  String get tempExtruder => 'Suhu Ekstruder';

  @override
  String get tempBed => 'Suhu Bed';

  @override
  String get termsOfService => 'Ketentuan Layanan';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get legal => 'Hukum';

  @override
  String get back => 'Kembali';

  @override
  String get retry => 'Coba lagi';

  @override
  String get signOut => 'Keluar';

  @override
  String get extruderTempMinHint => 'Mis.: 200';

  @override
  String get extruderTempMaxHint => 'Mis.: 220';

  @override
  String get bedTempMinHint => 'Mis.: 50';

  @override
  String get bedTempMaxHint => 'Mis.: 60';

  @override
  String get diameterHint => 'Mis.: 1.75';

  @override
  String get spoolLengthHint => 'Mis.: 330';

  @override
  String get tabGrid => 'Grid';

  @override
  String get tabSpectrum => 'Spektrum';

  @override
  String get tabSliders => 'Penggeser';

  @override
  String get hexCode => 'Kode Hex';

  @override
  String get red => 'Merah';

  @override
  String get green => 'Hijau';

  @override
  String get blue => 'Biru';

  @override
  String get black => 'Hitam';

  @override
  String get white => 'Putih';

  @override
  String get yellow => 'Kuning';

  @override
  String get orange => 'Oranye';

  @override
  String get pink => 'Merah Muda';

  @override
  String get purple => 'Ungu';

  @override
  String get gray => 'Abu-abu';

  @override
  String get brown => 'Cokelat';

  @override
  String get unknown => 'Tidak Diketahui';

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
  String get gbp => 'Pound Sterling (£)';

  @override
  String get cad => 'Dolar Kanada (CAD)';

  @override
  String get aud => 'Dolar Australia (A\$)';

  @override
  String get jpy => 'Yen Jepang (¥)';

  @override
  String get cny => 'Yuan Tiongkok (¥)';

  @override
  String get inr => 'Rupee India (₹)';

  @override
  String get brl => 'Real Brasil (R\$)';

  @override
  String get mxn => 'Peso Meksiko (MX\$)';

  @override
  String get sek => 'Krona Swedia (kr)';

  @override
  String get nok => 'Krone Norwegia (kr)';

  @override
  String get dkk => 'Krone Denmark (kr)';

  @override
  String get pln => 'Zloty Polandia (zł)';

  @override
  String get czk => 'Koruna Ceko (Kč)';

  @override
  String get nzd => 'Dolar Selandia Baru (NZ\$)';

  @override
  String get filamentsToOrder => 'Filamen untuk Dipesan';

  @override
  String get shoppingList => 'Daftar Belanja';

  @override
  String get addToShoppingList => 'Tambah ke Daftar';

  @override
  String get noLowStockFilaments => 'Tidak ada filamen stok rendah';

  @override
  String get vipSubscriptionDescription =>
      'Langganan ini hanya digunakan untuk menonaktifkan iklan dalam aplikasi dan mendukung proyek. Tidak ada fitur lainnya.';

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
  String get subscribe => 'Berlangganan';

  @override
  String get bestOffer => '✨ PENAWARAN TERBAIK ✨';

  @override
  String get forAnycubicAce => 'untuk Anycubic Ace';

  @override
  String get forBambuLabAms => 'untuk Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Pindai chip NFC';

  @override
  String get fillForm => 'Isi formulir';

  @override
  String get emptyShoppingList => 'Tidak ada filamen dalam daftar';

  @override
  String percentRemaining(String percent) {
    return '$percent% tersisa';
  }

  @override
  String get markAsOrdered => 'Tandai sebagai dipesan';

  @override
  String get markAsNotOrdered => 'Tandai sebagai belum dipesan';

  @override
  String get notSignedIn => 'Belum masuk';

  @override
  String get signIn => 'Masuk';

  @override
  String get connection => 'Koneksi';

  @override
  String get signInToSync => 'Masuk untuk menyinkronkan data Anda';

  @override
  String get continueWithoutAccount => 'Lanjutkan tanpa akun (mode lokal)';

  @override
  String get privacyNotice =>
      'Dengan masuk, Anda menerima\nKetentuan Layanan dan Kebijakan Privasi kami';

  @override
  String get updateStock => 'Perbarui stok';

  @override
  String get scanToUpdateStock => 'Pindai untuk memperbarui';

  @override
  String get weightUsed => 'Berat yang digunakan';

  @override
  String get lengthUsed => 'Panjang yang digunakan';

  @override
  String get enterWeightOrLength =>
      'Masukkan berat atau panjang yang digunakan';

  @override
  String get weightUsedG => 'Berat yang digunakan (g)';

  @override
  String get lengthUsedM => 'Panjang yang digunakan (m)';

  @override
  String get stockUpdated => 'Stok diperbarui';

  @override
  String get scanSpoolToUpdate => 'Pindai gulungan untuk memperbarui stoknya';

  @override
  String get spoolNotFound => 'Gulungan tidak ditemukan di stok';

  @override
  String get addSpoolFirstMessage =>
      'Gulungan ini belum ada di stok Anda. Silakan tambahkan terlebih dahulu menggunakan tombol \'Tambah Gulungan\' sebelum memperbarui stoknya.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Hanya baca';

  @override
  String get bambuLabReadOnlyDesc =>
      'Tag Bambu Lab menggunakan enkripsi RSA dan tidak dapat dimodifikasi. Hanya baca.';

  @override
  String get forPrusaMk4 => 'untuk Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Baca dan Tulis';

  @override
  String get prusaReadWriteDesc =>
      'Tag Prusa menggunakan ISO 15693 (NFC-V) dengan format OpenPrintTag. Baca dan tulis didukung.';

  @override
  String get bambuCloneLibrary => 'Perpustakaan Klon Bambu Lab';

  @override
  String get noBambuClones => 'Tidak ada klon Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Pindai tag Bambu Lab asli untuk membuat perpustakaan klon Anda';

  @override
  String get scanTag => 'Pindai tag';

  @override
  String get syncWithCloud => 'Sinkronkan dengan cloud';

  @override
  String get syncCompleted => 'Sinkronisasi selesai';

  @override
  String get deleteClone => 'Hapus klon';

  @override
  String get renameClone => 'Ubah nama klon';

  @override
  String get rename => 'Ubah nama';

  @override
  String get customName => 'Nama kustom';

  @override
  String get clonedOn => 'Diklon pada';

  @override
  String get writeThisClone => 'Tulis klon ini';

  @override
  String get writeClone => 'Tulis klon';

  @override
  String get writeOnCUID => 'Tulis di kartu CUID';

  @override
  String get cloneWrittenSuccess => 'Klon berhasil ditulis!';

  @override
  String get requiredTagFormat => 'Format tag yang diperlukan';

  @override
  String get type => 'Tipe';

  @override
  String get frequency => 'Frekuensi';

  @override
  String get protocol => 'Protokol';

  @override
  String get capacity => 'Kapasitas';

  @override
  String get feature => 'Fitur';

  @override
  String get uidModifiable => 'Blok 0 (UID) dapat dimodifikasi';

  @override
  String get whereToBuy =>
      'Cari \"CUID MiFare Classic 1K\" di AliExpress, Amazon atau eBay (~\$0.50/buah)';

  @override
  String get magicGen2Required =>
      'Kartu Magic Gen2 - MiFare Classic 1K dengan Block 0 (UID) yang dapat ditulis';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Cari \"Magic Gen2 MiFare Classic 1K\" atau \"UID writable\" di AliExpress, Amazon atau eBay (~\$0.50/buah)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Peringatan: Menulis dengan iPhone NFC mungkin tidak berfungsi pada semua kartu Magic Gen2. Perangkat Proxmark3 disarankan untuk keandalan maksimum.';

  @override
  String get step1GetMagicGen2 =>
      'Dapatkan kartu Magic Gen2 kosong (MiFare Classic 1K dengan UID yang dapat ditulis)';

  @override
  String get instructions => 'Instruksi';

  @override
  String get step1GetCUID => 'Dapatkan kartu CUID kosong (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Tekan tombol \"Tulis\" di bawah';

  @override
  String get step3HoldPhone => 'Tahan ponsel Anda di dekat kartu CUID';

  @override
  String get step4WaitConfirm => 'Tunggu konfirmasi penulisan';

  @override
  String get step5TestClone => 'Uji tag yang diklon di printer Bambu Lab Anda!';

  @override
  String get rsaIncluded =>
      'Klon mencakup tanda tangan RSA asli, akan diterima oleh printer!';

  @override
  String get cloneDeleted => 'Klon dihapus';

  @override
  String get deleteAccount => 'Hapus akun saya';

  @override
  String get deleteAccountConfirmation =>
      'Tindakan ini tidak dapat dibatalkan. Akun dan semua data Anda akan dihapus dalam 30 hari.';

  @override
  String get accountDeletionRequested => 'Permintaan penghapusan terdaftar';

  @override
  String get clearShoppingList => 'Hapus daftar';

  @override
  String get clearShoppingListConfirmation =>
      'Apakah Anda yakin ingin menghapus seluruh daftar belanja? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Riwayat';

  @override
  String get retryButton => 'Coba lagi';

  @override
  String get readSuccessMessage => 'Berhasil membaca!';

  @override
  String get filamentTypeLabel => 'Jenis filamen';

  @override
  String get scanNfcChipButton => 'Pindai chip NFC';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Hapus klon \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Klon \"$name\" dihapus';
  }

  @override
  String get extruderLabel => 'Ekstruder';

  @override
  String get writeThisCloneButton => 'Tulis klon ini';

  @override
  String get customNameHint => 'Nama kustom';

  @override
  String get cloneWriteSuccessMessage => 'Klon berhasil ditulis!';

  @override
  String errorPrefix(String error) {
    return 'Kesalahan: $error';
  }

  @override
  String get writingInProgress => 'Menulis...';

  @override
  String get writeOnCUIDButton => 'Tulis ke kartu CUID';

  @override
  String get diameterLabel => 'Diameter';

  @override
  String get extruderTempLabel => 'Suhu ekstruder';

  @override
  String get bedTempLabel => 'Suhu bed';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K byte (1024 byte)';

  @override
  String get rsaSignatureNote =>
      'Klon menyertakan tanda tangan RSA asli, akan diterima oleh printer!';

  @override
  String get writeBambuLabTagTitle => 'Tulis tag Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'Tag Bambu Lab berhasil ditulis!';

  @override
  String get approachNfcTagMessage => 'Dekatkan tag NFC...';

  @override
  String get bambuLabFormatMiFare => 'Format Bambu Lab (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Format Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Format ini menggunakan kode material Bambu Lab dan menyimpan data dalam format yang kompatibel dengan AMS.';

  @override
  String get brandLabel => 'Merek';

  @override
  String get materialTypeLabel => 'Jenis material';

  @override
  String get serialNumber3Digits => 'Nomor seri (3 digit)';

  @override
  String get weight250g => '250g';

  @override
  String get weight500g => '500g';

  @override
  String get weight1000g => '1000g';

  @override
  String get weight1000gStandard => '1000g (standar)';

  @override
  String get weight2000g => '2000g';

  @override
  String get weight3000g => '3000g';

  @override
  String get writeBambuLabTagButton => 'Tulis tag Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Catatan: Tag Bambu Lab asli menggunakan enkripsi RSA. Mode ini menulis data dalam format sederhana yang kompatibel.';

  @override
  String signInError(String error) {
    return 'Kesalahan masuk: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Langganan berhasil diaktifkan!';

  @override
  String get subscriptionFailedMessage => 'Langganan gagal';

  @override
  String errorMessage(String error) {
    return 'Kesalahan: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Langganan berhasil dipulihkan!';

  @override
  String get noSubscriptionFoundMessage => 'Langganan tidak ditemukan';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'AKTIF';

  @override
  String get noAdsExperienceMessage => 'Nikmati pengalaman bebas iklan!';

  @override
  String get subscribedLabel => 'Berlangganan';

  @override
  String get restorePurchasesButton => 'Pulihkan pembelian';

  @override
  String get cannotExceedRemainingWeight =>
      'Tidak dapat melebihi berat tersisa';

  @override
  String get pleaseEnterLength => 'Silakan masukkan panjang';

  @override
  String get pleaseEnterValidLength => 'Silakan masukkan panjang yang valid';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Panjang gulungan tidak diatur - tidak dapat mengonversi';

  @override
  String get exceedsRemainingWeight => 'Melebihi berat tersisa';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Bantu kami mengidentifikasi filamen ini';

  @override
  String get helpUsImprove => 'Bantu kami meningkatkan!';

  @override
  String get helpIdentifyDescription =>
      'Kami membaca chip tetapi tidak dapat mengidentifikasinya. Beri tahu kami filamen apa ini agar kami dapat meningkatkan aplikasi.';

  @override
  String get otherBrand => 'Lainnya';

  @override
  String get thankYouFeedback => 'Terima kasih atas masukan Anda!';

  @override
  String get send => 'Kirim';

  @override
  String get optionalDetails => 'Detail opsional';

  @override
  String get weightGrams => 'Berat (g)';

  @override
  String get diameterMm => 'Diameter (mm)';

  @override
  String get spoolLengthM => 'Panjang gulungan (m)';

  @override
  String get batchNumberLabel => 'Batch / SKU';

  @override
  String get contactUs => 'Hubungi Kami';

  @override
  String get contactUsSubtitle => 'Pertanyaan, saran, atau masalah';

  @override
  String get nfcTagNotDetected => 'Tag NFC tidak terdeteksi';

  @override
  String get nfcTagNotDetectedDesc =>
      'Tag tidak ditemukan. Tag mungkin mati, rusak, atau terlalu jauh dari ponsel.';

  @override
  String get nfcTagIncompatible => 'Tag NFC tidak kompatibel terdeteksi';

  @override
  String get nfcAuthError => 'Autentikasi tag NFC gagal';

  @override
  String get nfcAuthErrorDesc =>
      'Tag terdeteksi tetapi autentikasi gagal setelah beberapa percobaan. Tekan tag dengan kuat ke bagian belakang ponsel dan coba lagi.';

  @override
  String get nfcTagInfoPrusa =>
      'Gunakan kartu NXP ICODE SLIX2 kosong (ISO 15693) untuk membuat tag yang kompatibel dengan OpenPrintTag untuk Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Tulis Tag Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Masuk dengan Apple tidak tersedia di perangkat ini.';

  @override
  String get signInAppleFailed =>
      'Masuk dengan Apple gagal. Silakan coba lagi.';

  @override
  String get signInFailed => 'Masuk gagal. Silakan coba lagi.';

  @override
  String get mustContain3Digits => 'Harus berisi 3 digit';

  @override
  String get mustBeNumber => 'Harus berupa angka';

  @override
  String generatedUidLabel(String uid) {
    return 'UID yang dihasilkan: $uid';
  }

  @override
  String get experimentalBadge => 'EKSPERIMENTAL';

  @override
  String get newBadge => 'BARU';

  @override
  String get forCrealityCfs => 'untuk Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Baca & tulis';

  @override
  String get crealityReadWriteDesc =>
      'Tag Creality CFS menggunakan MiFare Classic 1K dengan enkripsi AES-128-ECB. Baca dan tulis hanya didukung di Android.';

  @override
  String get platformLimitationTitle => 'Batasan platform';

  @override
  String get mifareClassicNotSupportedIos =>
      'Tag MiFare Classic (Bambu Lab, Creality) tidak didukung di iOS karena batasan Apple CoreNFC. Fitur ini hanya tersedia di Android.';

  @override
  String get nfcTagInfoCreality =>
      'Gunakan tag MiFare Classic 1K untuk menulis data yang kompatibel dengan Creality CFS untuk Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Merah, Biru, Hitam...';

  @override
  String get dryingTemp => 'Suhu pengeringan';

  @override
  String get dryingTempHint => 'mis. 55';

  @override
  String get dryingTime => 'Waktu pengeringan (jam)';

  @override
  String get dryingTimeHint => 'mis. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Tag terdeteksi sebagai $mode — ganti tab untuk pemindaian berikutnya';
  }

  @override
  String get fallbackChooseMode => 'Pilih mode secara manual';

  @override
  String get fallbackChooseModeSubtitle =>
      'Deteksi otomatis tidak dapat mengidentifikasi tag ini. Pilih protokol:';

  @override
  String get tryAutoDetect => 'Coba deteksi otomatis';

  @override
  String get autoDetectAllBrands => 'Deteksi otomatis — semua merek';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D dan lainnya';

  @override
  String get nfcTipIos =>
      'Pembaca NFC ada di bagian atas iPhone Anda. Letakkan langsung di tag NFC gulungan.';

  @override
  String get nfcTipAndroid =>
      'Pembaca NFC biasanya ada di tengah bagian belakang ponsel. Letakkan bagian belakang ponsel di tag NFC gulungan.';

  @override
  String get stockSortBy => 'Urutkan';

  @override
  String get stockFilter => 'Filter';

  @override
  String get stockSortRecent => 'Terbaru';

  @override
  String get stockSortBrand => 'Merek';

  @override
  String get stockSortMaterial => 'Material';

  @override
  String get stockSortRemaining => 'Sisa berat';

  @override
  String get stockSortColor => 'Warna';

  @override
  String get stockFilterAll => 'Semua';

  @override
  String get stockResetFilters => 'Atur ulang';

  @override
  String get stockNoMatch => 'Tidak ada gulungan yang cocok dengan filter';

  @override
  String get nfcDisabledTitle => 'NFC nonaktif';

  @override
  String get nfcDisabledMessage =>
      'NFC nonaktif. Aktifkan di pengaturan ponsel untuk memindai gulungan Anda.';

  @override
  String get updateAvailableTitle => 'Pembaruan tersedia';

  @override
  String get updateAvailableMessage => 'Versi baru Spool Master tersedia.';

  @override
  String get updateForcedMessage =>
      'Versi ini tidak lagi didukung. Perbarui untuk melanjutkan.';

  @override
  String get updateNow => 'Perbarui';

  @override
  String get updateLater => 'Nanti';

  @override
  String get nfcScanGuidance =>
      'Tahan tag diam di bagian atas atau belakang ponsel.';

  @override
  String get tagMovedTitle => 'Tag bergerak';

  @override
  String get tagMovedMessage =>
      'Tag bergerak saat membaca. Tempelkan lagi dan tahan ponsel tetap diam.';

  @override
  String get lightBlue => 'Biru muda';

  @override
  String get transparent => 'Transparan';

  @override
  String get nfcActiveApproachTag => 'NFC aktif — dekatkan tag';

  @override
  String addedToShoppingList(String item) {
    return '$item ditambahkan ke daftar belanja';
  }

  @override
  String get deleteAccountFailed =>
      'Penghapusan akun gagal. Silakan coba lagi.';

  @override
  String get scanHistoryError => 'Kesalahan mengakses riwayat pemindaian';

  @override
  String get genericBrand => 'Generik';
}
