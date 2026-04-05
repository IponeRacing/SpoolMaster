// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Запас';

  @override
  String get statistics => 'Аналітика';

  @override
  String get profile => 'Профіль';

  @override
  String get readNfcChip => 'Читати NFC чіп';

  @override
  String get scanHistory => 'Історія';

  @override
  String get writeNfcChip => 'Записати NFC чіп';

  @override
  String get nfcNotAvailable => 'NFC недоступний';

  @override
  String get nfcNotAvailableDesc =>
      'Ваш пристрій не підтримує NFC або він вимкнений.';

  @override
  String get nfcNotSupported => 'NFC не підтримується на цьому пристрої';

  @override
  String get approachNfcChip => 'Наблизьте NFC чіп...';

  @override
  String get scanningNfc => 'Сканування...';

  @override
  String get nfcDataRead => 'NFC дані успішно прочитані!';

  @override
  String get errorReadingNfc => 'Помилка читання NFC';

  @override
  String get scanHistoryTitle => 'Історія сканувань';

  @override
  String get noScansRecorded => 'Немає записаних сканувань';

  @override
  String get scansWillAppearHere =>
      'NFC сканування з\'являться тут автоматично';

  @override
  String get clearAll => 'Очистити все';

  @override
  String get deleteThisScan => 'Видалити це сканування?';

  @override
  String get actionIrreversible => 'Ця дія незворотна.';

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get clearAllHistory => 'Очистити всю історію?';

  @override
  String get allScansWillBeDeleted =>
      'Всі сканування будуть видалені. Ця дія незворотна.';

  @override
  String get scanDeleted => 'Сканування видалено';

  @override
  String get scanDetails => 'Деталі сканування';

  @override
  String scannedOn(Object date) {
    return 'Відсканowano $date';
  }

  @override
  String get bobbinInformation => 'Інформація про котушку';

  @override
  String get filamentType => 'Тип філаменту';

  @override
  String get color => 'Колір';

  @override
  String get weight => 'Вага';

  @override
  String get manufacturingDate => 'Дата виробництва';

  @override
  String get batchNumber => 'Номер партії';

  @override
  String get printerSettings => 'Налаштування принтера';

  @override
  String get scanMetadata => 'Метадані сканування';

  @override
  String get scanId => 'ID сканування';

  @override
  String get dateAndTime => 'Дата і час';

  @override
  String get reuseThisData => 'Повторно використати ці дані';

  @override
  String get writeToNfc => 'Записати в NFC';

  @override
  String get writeDataToChip => 'Записати дані в чіп';

  @override
  String get writeSuccess => 'Успішний запис!';

  @override
  String get writeError => 'Помилка запису';

  @override
  String get brand => 'Бренд';

  @override
  String get selectBrand => 'Виберіть бренд';

  @override
  String get materialType => 'Тип матеріалу';

  @override
  String get selectMaterial => 'Виберіть матеріал';

  @override
  String get serialNumber => 'Серійний номер';

  @override
  String get serialNumberHint => 'напр.: 001';

  @override
  String get initialWeight => 'Початкова вага';

  @override
  String get initialWeightHint => 'напр.: 1000';

  @override
  String get extruderTempMin => 'Мін. темп. екструдера';

  @override
  String get extruderTempMax => 'Макс. темп. екструдера';

  @override
  String get bedTempMin => 'Мін. темп. столу';

  @override
  String get bedTempMax => 'Макс. темп. столу';

  @override
  String get diameter => 'Діаметр філаменту';

  @override
  String get spoolLength => 'Довжина котушки';

  @override
  String get generatedSku => 'Згенерований SKU';

  @override
  String get approachChipToWrite => 'Наблизьте чіп для запису...';

  @override
  String get writing => 'Запис...';

  @override
  String get chooseColor => 'Виберіть колір';

  @override
  String get required => 'Обов\'язково';

  @override
  String get invalid => 'Недійсно';

  @override
  String get advancedSettings => 'Розширені налаштування';

  @override
  String get opacity => 'Прозорість';

  @override
  String get validate => 'Підтвердити';

  @override
  String get nfcTagInfo =>
      'Використовуйте порожню ISO14443A NFC мітку (NTAG213) для створення власних міток Anycubic.';

  @override
  String get stockInventory => 'Котушки в наявності';

  @override
  String get addSpool => 'Додати котушку';

  @override
  String get scanSpool => 'Сканувати котушку';

  @override
  String get addManually => 'Додати вручну';

  @override
  String get spoolAdded => 'Котушку додано';

  @override
  String get spoolUpdated => 'Котушку оновлено';

  @override
  String get noSpoolsInStock => 'Немає котушок на складі';

  @override
  String get addFirstSpool =>
      'Додайте свою першу котушку, щоб почати відстежувати інвентар';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count котушок з низьким запасом (< $threshold%)';
  }

  @override
  String get edit => 'Редагувати';

  @override
  String get bobbinPrice => 'Ціна котушки';

  @override
  String get price => 'Ціна';

  @override
  String get priceHint => 'напр.: 25.00';

  @override
  String get save => 'Зберегти';

  @override
  String get spoolDetails => 'Деталі котушки';

  @override
  String get deleteThisSpool => 'Видалити цю котушку?';

  @override
  String get cannotBeUndone => 'Цю дію неможливо скасувати.';

  @override
  String get addSpoolManually => 'Ручне додавання котушки';

  @override
  String get editSpool => 'Редагувати котушку';

  @override
  String get customBrand => 'Власний бренд';

  @override
  String get customBrandHint => 'напр.: Мій бренд';

  @override
  String get chooseFromList => 'Вибрати зі списку';

  @override
  String get addBrand => '+ Додати бренд';

  @override
  String get customMaterial => 'Власний матеріал';

  @override
  String get customMaterialHint => 'напр.: Мій матеріал';

  @override
  String get addMaterial => '+ Додати матеріал';

  @override
  String get colorHint => 'напр.: Синій, Червоний...';

  @override
  String get enterColor => 'Будь ласка, введіть колір';

  @override
  String get initialWeightG => 'Початкова вага';

  @override
  String get remainingWeightG => 'Залишкова вага';

  @override
  String get enterBrand => 'Будь ласка, введіть бренд';

  @override
  String get selectOrEnterBrand => 'Будь ласка, виберіть або введіть бренд';

  @override
  String get enterMaterial => 'Будь ласка, введіть матеріал';

  @override
  String get selectOrEnterMaterial =>
      'Будь ласка, виберіть або введіть матеріал';

  @override
  String get enterPrice => 'Будь ласка, введіть ціну';

  @override
  String get enterValidPrice => 'Будь ласка, введіть дійсну ціну';

  @override
  String get enterWeight => 'Будь ласка, введіть вагу';

  @override
  String get enterValidWeight => 'Будь ласка, введіть дійсну вагу';

  @override
  String get remainingCannotExceedTotal =>
      'Залишкова вага не може перевищувати загальну вагу';

  @override
  String get overview => 'Огляд';

  @override
  String get spoolsInStock => 'Котушки на складі';

  @override
  String get totalValue => 'Загальна вартість';

  @override
  String get lowStockSpools => 'Низький запас';

  @override
  String get materialDistribution => 'Розподіл за матеріалом';

  @override
  String get brandDistribution => 'Розподіл за брендом';

  @override
  String get noData => 'Немає даних';

  @override
  String get refresh => 'Оновити';

  @override
  String get profileSettings => 'Налаштування профілю';

  @override
  String get preferences => 'Вподобання';

  @override
  String get language => 'Мова';

  @override
  String get selectLanguage => 'Виберіть мову';

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
  String get currency => 'Валюта';

  @override
  String get selectCurrency => 'Виберіть валюту';

  @override
  String get units => 'Одиниці';

  @override
  String get selectUnits => 'Виберіть одиниці';

  @override
  String get metric => 'Метричні (мм, г, °C)';

  @override
  String get imperial => 'Імперські (дюйм, унція, °F)';

  @override
  String get lowStockThreshold => 'Поріг попередження про низький запас';

  @override
  String get lowStockThresholdDesc =>
      'Котушка вважатиметься низьким запасом, якщо залишкова вага менша за цей відсоток';

  @override
  String get authentication => 'Автентифікація';

  @override
  String get signInWithGoogle => 'Увійти через Google';

  @override
  String get signInWithApple => 'Увійти через Apple';

  @override
  String get continueWithApple => 'Продовжити з Apple';

  @override
  String get continueWithGoogle => 'Продовжити з Google';

  @override
  String get comingSoon => 'Незабаром';

  @override
  String get about => 'Про додаток';

  @override
  String get version => 'Версія';

  @override
  String get madeWith => 'Зроблено з ❤️ для 3D принтерів Anycubic';

  @override
  String get scanBobbinDirectly => 'Сканувати котушку';

  @override
  String get nfcEncoder => 'NFC кодувальник';

  @override
  String get length => 'Довжина';

  @override
  String get tempExtruder => 'Темп. екструдера';

  @override
  String get tempBed => 'Темп. столу';

  @override
  String get termsOfService => 'Умови використання';

  @override
  String get privacyPolicy => 'Політика конфіденційності';

  @override
  String get legal => 'Юридична інформація';

  @override
  String get back => 'Назад';

  @override
  String get retry => 'Спробувати знову';

  @override
  String get signOut => 'Вийти';

  @override
  String get extruderTempMinHint => 'Напр.: 200';

  @override
  String get extruderTempMaxHint => 'Напр.: 220';

  @override
  String get bedTempMinHint => 'Напр.: 50';

  @override
  String get bedTempMaxHint => 'Напр.: 60';

  @override
  String get diameterHint => 'Напр.: 1.75';

  @override
  String get spoolLengthHint => 'Напр.: 330';

  @override
  String get tabGrid => 'Сітка';

  @override
  String get tabSpectrum => 'Спектр';

  @override
  String get tabSliders => 'Повзунки';

  @override
  String get hexCode => 'Hex код';

  @override
  String get red => 'Червоний';

  @override
  String get green => 'Зелений';

  @override
  String get blue => 'Синій';

  @override
  String get black => 'Чорний';

  @override
  String get white => 'Білий';

  @override
  String get yellow => 'Жовтий';

  @override
  String get orange => 'Помаранчевий';

  @override
  String get pink => 'Рожевий';

  @override
  String get purple => 'Фіолетовий';

  @override
  String get gray => 'Сірий';

  @override
  String get brown => 'Коричневий';

  @override
  String get unknown => 'Невідомо';

  @override
  String get metricUnits => 'Метричні (мм, г, °C)';

  @override
  String get imperialUnits => 'Імперські (дюйм, унція, °F)';

  @override
  String get chf => 'Швейцарський франк (CHF)';

  @override
  String get eur => 'Євро (€)';

  @override
  String get usd => 'Долар США (\$)';

  @override
  String get gbp => 'Фунт стерлінгів (£)';

  @override
  String get cad => 'Канадський долар (CAD)';

  @override
  String get aud => 'Австралійський долар (A\$)';

  @override
  String get jpy => 'Японська єна (¥)';

  @override
  String get cny => 'Китайський юань (¥)';

  @override
  String get inr => 'Індійська рупія (₹)';

  @override
  String get brl => 'Бразильський реал (R\$)';

  @override
  String get mxn => 'Мексиканське песо (MX\$)';

  @override
  String get sek => 'Шведська крона (kr)';

  @override
  String get nok => 'Норвезька крона (kr)';

  @override
  String get dkk => 'Данська крона (kr)';

  @override
  String get pln => 'Польський злотий (zł)';

  @override
  String get czk => 'Чеська крона (Kč)';

  @override
  String get nzd => 'Новозеландський долар (NZ\$)';

  @override
  String get filamentsToOrder => 'Філаменти для замовлення';

  @override
  String get shoppingList => 'Список покупок';

  @override
  String get addToShoppingList => 'Додати до списку';

  @override
  String get noLowStockFilaments => 'Немає філаментів з низьким запасом';

  @override
  String get vipSubscriptionDescription =>
      'Ця підписка використовується тільки для вимкнення реклами в додатку та підтримки проекту. Немає інших функцій.';

  @override
  String get monthlySubscription => 'Місячна підписка';

  @override
  String get yearlySubscription => 'Річна підписка';

  @override
  String get perMonth => '/ місяць';

  @override
  String get perYear => '/ рік';

  @override
  String onlyPerMonth(String price) {
    return 'Тільки $price / місяць';
  }

  @override
  String get subscribe => 'Підписатися';

  @override
  String get bestOffer => '✨ НАЙКРАЩА ПРОПОЗИЦІЯ ✨';

  @override
  String get forAnycubicAce => 'для Anycubic Ace';

  @override
  String get forBambuLabAms => 'для Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Сканувати NFC чіп';

  @override
  String get fillForm => 'Заповнити форму';

  @override
  String get emptyShoppingList => 'Немає філаментів у списку';

  @override
  String percentRemaining(String percent) {
    return '$percent% залишилось';
  }

  @override
  String get markAsOrdered => 'Позначити як замовлено';

  @override
  String get markAsNotOrdered => 'Позначити як незамовлено';

  @override
  String get notSignedIn => 'Не ввійшли';

  @override
  String get signIn => 'Увійти';

  @override
  String get connection => 'З\'єднання';

  @override
  String get signInToSync => 'Увійдіть, щоб синхронізувати дані';

  @override
  String get continueWithoutAccount =>
      'Продовжити без облікового запису (локальний режим)';

  @override
  String get privacyNotice =>
      'Входячи, ви приймаєте наші\nУмови використання та Політику конфіденційності';

  @override
  String get updateStock => 'Оновити запаси';

  @override
  String get scanToUpdateStock => 'Скануйте для оновлення';

  @override
  String get weightUsed => 'Використана вага';

  @override
  String get lengthUsed => 'Використана довжина';

  @override
  String get enterWeightOrLength => 'Введіть використану вагу або довжину';

  @override
  String get weightUsedG => 'Використана вага (g)';

  @override
  String get lengthUsedM => 'Використана довжина (m)';

  @override
  String get stockUpdated => 'Запаси оновлено';

  @override
  String get scanSpoolToUpdate => 'Скануйте котушку, щоб оновити запаси';

  @override
  String get spoolNotFound => 'Котушку не знайдено в запасах';

  @override
  String get addSpoolFirstMessage =>
      'Цієї котушки ще немає у ваших запасах. Будь ласка, спочатку додайте її за допомогою кнопки \'Додати котушку\', перш ніж оновлювати запаси.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Тільки для читання';

  @override
  String get bambuLabReadOnlyDesc =>
      'Мітки Bambu Lab використовують шифрування RSA і не можуть бути змінені. Тільки для читання.';

  @override
  String get forPrusaMk4 => 'для Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Читання та запис';

  @override
  String get prusaReadWriteDesc =>
      'Теги Prusa використовують ISO 15693 (NFC-V) з форматом OpenPrintTag. Підтримка читання та запису.';

  @override
  String get bambuCloneLibrary => 'Бібліотека клонів Bambu Lab';

  @override
  String get noBambuClones => 'Немає клонів Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Скануйте оригінальні мітки Bambu Lab, щоб створити бібліотеку клонів';

  @override
  String get scanTag => 'Сканувати мітку';

  @override
  String get syncWithCloud => 'Синхронізувати з хмарою';

  @override
  String get syncCompleted => 'Синхронізацію завершено';

  @override
  String get deleteClone => 'Видалити клон';

  @override
  String get renameClone => 'Перейменувати клон';

  @override
  String get rename => 'Перейменувати';

  @override
  String get customName => 'Власна назва';

  @override
  String get clonedOn => 'Клоновано';

  @override
  String get writeThisClone => 'Записати цей клон';

  @override
  String get writeClone => 'Записати клон';

  @override
  String get writeOnCUID => 'Записати на картку CUID';

  @override
  String get cloneWrittenSuccess => 'Клон успішно записано!';

  @override
  String get requiredTagFormat => 'Необхідний формат мітки';

  @override
  String get type => 'Тип';

  @override
  String get frequency => 'Частота';

  @override
  String get protocol => 'Протокол';

  @override
  String get capacity => 'Ємність';

  @override
  String get feature => 'Функція';

  @override
  String get uidModifiable => 'Блок 0 (UID) змінюваний';

  @override
  String get whereToBuy =>
      'Шукайте \"CUID MiFare Classic 1K\" на AliExpress, Amazon або eBay (~\$0.50/шт)';

  @override
  String get magicGen2Required =>
      'Картка Magic Gen2 - MiFare Classic 1K з записуваним Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Шукайте \"Magic Gen2 MiFare Classic 1K\" або \"UID writable\" на AliExpress, Amazon або eBay (~\$0.50/штука)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Попередження: Запис за допомогою iPhone NFC може не працювати на всіх картках Magic Gen2. Рекомендується пристрій Proxmark3 для максимальної надійності.';

  @override
  String get step1GetMagicGen2 =>
      'Отримайте порожню картку Magic Gen2 (MiFare Classic 1K із записуваним UID)';

  @override
  String get instructions => 'Інструкції';

  @override
  String get step1GetCUID =>
      'Отримайте порожню картку CUID (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Натисніть кнопку \"Записати\" нижче';

  @override
  String get step3HoldPhone => 'Тримайте iPhone біля картки CUID';

  @override
  String get step4WaitConfirm => 'Зачекайте підтвердження запису';

  @override
  String get step5TestClone =>
      'Протестуйте клоновану мітку на принтері Bambu Lab!';

  @override
  String get rsaIncluded =>
      'Клон містить оригінальний підпис RSA, він буде прийнятий принтером!';

  @override
  String get cloneDeleted => 'Клон видалено';

  @override
  String get deleteAccount => 'Видалити мій акаунт';

  @override
  String get deleteAccountConfirmation =>
      'Ця дія незворотна. Ваш акаунт і всі дані будуть видалені протягом 30 днів.';

  @override
  String get accountDeletionRequested => 'Запит на видалення зареєстровано';

  @override
  String get clearShoppingList => 'Очистити список';

  @override
  String get clearShoppingListConfirmation =>
      'Ви впевнені, що хочете очистити весь список покупок? Цю дію неможливо скасувати.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Історія';

  @override
  String get retryButton => 'Повторити';

  @override
  String get readSuccessMessage => 'Зчитування успішне!';

  @override
  String get filamentTypeLabel => 'Тип філаменту';

  @override
  String get scanNfcChipButton => 'Сканувати NFC-чіп';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Видалити клон \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Клон \"$name\" видалено';
  }

  @override
  String get extruderLabel => 'Екструдер';

  @override
  String get writeThisCloneButton => 'Записати цей клон';

  @override
  String get customNameHint => 'Власна назва';

  @override
  String get cloneWriteSuccessMessage => 'Клон успішно записано!';

  @override
  String errorPrefix(String error) {
    return 'Помилка: $error';
  }

  @override
  String get writingInProgress => 'Запис...';

  @override
  String get writeOnCUIDButton => 'Записати на картку CUID';

  @override
  String get diameterLabel => 'Діаметр';

  @override
  String get extruderTempLabel => 'Температура екструдера';

  @override
  String get bedTempLabel => 'Температура столу';

  @override
  String get nfcFrequency => '13,56 МГц';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K байт (1024 байти)';

  @override
  String get rsaSignatureNote =>
      'Клон містить оригінальний підпис RSA, принтер прийме його!';

  @override
  String get writeBambuLabTagTitle => 'Записати тег Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'Тег Bambu Lab успішно записано!';

  @override
  String get approachNfcTagMessage => 'Піднесіть NFC-тег...';

  @override
  String get bambuLabFormatMiFare => 'Формат Bambu Lab (MiFare 13,56 МГц)';

  @override
  String get bambuLabFormat => 'Формат Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Цей формат використовує коди матеріалів Bambu Lab та зберігає дані у форматі, сумісному з AMS.';

  @override
  String get brandLabel => 'Бренд';

  @override
  String get materialTypeLabel => 'Тип матеріалу';

  @override
  String get serialNumber3Digits => 'Серійний номер (3 цифри)';

  @override
  String get weight250g => '250г';

  @override
  String get weight500g => '500г';

  @override
  String get weight1000g => '1000г';

  @override
  String get weight1000gStandard => '1000г (стандарт)';

  @override
  String get weight2000g => '2000г';

  @override
  String get weight3000g => '3000г';

  @override
  String get writeBambuLabTagButton => 'Записати тег Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Примітка: Оригінальні теги Bambu Lab використовують шифрування RSA. Цей режим записує дані у спрощеному сумісному форматі.';

  @override
  String signInError(String error) {
    return 'Помилка входу: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Підписку успішно активовано!';

  @override
  String get subscriptionFailedMessage => 'Не вдалося оформити підписку';

  @override
  String errorMessage(String error) {
    return 'Помилка: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Підписку успішно відновлено!';

  @override
  String get noSubscriptionFoundMessage => 'Підписку не знайдено';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'АКТИВНО';

  @override
  String get noAdsExperienceMessage => 'Насолоджуйтесь версією без реклами!';

  @override
  String get subscribedLabel => 'Підписник';

  @override
  String get restorePurchasesButton => 'Відновити покупки';

  @override
  String get cannotExceedRemainingWeight =>
      'Не можна перевищити залишкову вагу';

  @override
  String get pleaseEnterLength => 'Введіть довжину';

  @override
  String get pleaseEnterValidLength => 'Введіть коректну довжину';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Довжина котушки не задана - неможливо перетворити';

  @override
  String get exceedsRemainingWeight => 'Перевищує залишкову вагу';

  @override
  String get skuLabel => 'Артикул';

  @override
  String get helpIdentifyFilament => 'Допоможіть нам визначити цей філамент';

  @override
  String get helpUsImprove => 'Допоможіть нам покращитися!';

  @override
  String get helpIdentifyDescription =>
      'Ми прочитали чіп, але не змогли його розпізнати. Розкажіть нам, який це філамент, щоб ми могли покращити додаток.';

  @override
  String get otherBrand => 'Інший';

  @override
  String get thankYouFeedback => 'Дякуємо за ваш відгук!';

  @override
  String get send => 'Надіслати';

  @override
  String get optionalDetails => 'Додаткові дані';

  @override
  String get weightGrams => 'Вага (г)';

  @override
  String get diameterMm => 'Діаметр (мм)';

  @override
  String get spoolLengthM => 'Довжина котушки (м)';

  @override
  String get batchNumberLabel => 'Партія / SKU';

  @override
  String get contactUs => 'Зв\'яжіться з нами';

  @override
  String get contactUsSubtitle => 'Питання, пропозиції або проблеми';

  @override
  String get nfcTagNotDetected => 'NFC мітку не виявлено';

  @override
  String get nfcTagNotDetectedDesc =>
      'Мітку не знайдено. Мітка може бути несправною, пошкодженою або занадто далеко від телефону. Переконайтеся, що верхня частина телефону розміщена безпосередньо на NFC мітці.';

  @override
  String get nfcTagIncompatible => 'Виявлено несумісну NFC мітку';

  @override
  String get nfcTagInfoPrusa =>
      'Використовуйте пусту карту NXP ICODE SLIX2 (ISO 15693) для створення тегів, сумісних з OpenPrintTag, для Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Записати тег Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Вхід через Apple недоступний на цьому пристрої.';

  @override
  String get signInAppleFailed =>
      'Не вдалося увійти через Apple. Будь ласка, спробуйте ще раз.';

  @override
  String get signInFailed => 'Не вдалося увійти. Будь ласка, спробуйте ще раз.';

  @override
  String get mustContain3Digits => 'Має містити 3 цифри';

  @override
  String get mustBeNumber => 'Має бути числом';

  @override
  String generatedUidLabel(String uid) {
    return 'Згенерований UID: $uid';
  }

  @override
  String get experimentalBadge => 'ЕКСПЕРИМЕНТАЛЬНЕ';

  @override
  String get newBadge => 'НОВЕ';

  @override
  String get colorHintExamples => 'Червоний, Синій, Чорний...';
}
