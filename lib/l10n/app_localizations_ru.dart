// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Склад';

  @override
  String get statistics => 'Статистика';

  @override
  String get profile => 'Профиль';

  @override
  String get readNfcChip => 'Считать NFC-чип';

  @override
  String get scanHistory => 'История';

  @override
  String get writeNfcChip => 'Записать NFC-чип';

  @override
  String get nfcNotAvailable => 'NFC недоступен';

  @override
  String get nfcNotAvailableDesc =>
      'Ваше устройство не поддерживает NFC или он отключен.';

  @override
  String get nfcNotSupported => 'NFC не поддерживается на этом устройстве';

  @override
  String get approachNfcChip => 'Поднесите NFC-чип...';

  @override
  String get scanningNfc => 'Сканирование...';

  @override
  String get nfcDataRead => 'Данные NFC успешно прочитаны!';

  @override
  String get errorReadingNfc => 'Ошибка чтения NFC';

  @override
  String get scanHistoryTitle => 'История сканирования';

  @override
  String get noScansRecorded => 'Нет записанных сканирований';

  @override
  String get scansWillAppearHere =>
      'Сканирования NFC будут отображаться здесь автоматически';

  @override
  String get clearAll => 'Очистить все';

  @override
  String get deleteThisScan => 'Удалить это сканирование?';

  @override
  String get actionIrreversible => 'Это действие необратимо.';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get clearAllHistory => 'Очистить всю историю?';

  @override
  String get allScansWillBeDeleted =>
      'Все сканирования будут удалены. Это действие необратимо.';

  @override
  String get scanDeleted => 'Сканирование удалено';

  @override
  String get scanDetails => 'Детали сканирования';

  @override
  String scannedOn(Object date) {
    return 'Отсканировано $date';
  }

  @override
  String get bobbinInformation => 'Информация о катушке';

  @override
  String get filamentType => 'Тип филамента';

  @override
  String get color => 'Цвет';

  @override
  String get weight => 'Вес';

  @override
  String get manufacturingDate => 'Дата производства';

  @override
  String get batchNumber => 'Номер партии';

  @override
  String get printerSettings => 'Настройки принтера';

  @override
  String get scanMetadata => 'Метаданные сканирования';

  @override
  String get scanId => 'ID сканирования';

  @override
  String get dateAndTime => 'Дата и время';

  @override
  String get reuseThisData => 'Переиспользовать эти данные';

  @override
  String get writeToNfc => 'Записать в NFC';

  @override
  String get writeDataToChip => 'Записать данные на чип';

  @override
  String get writeSuccess => 'Запись успешна!';

  @override
  String get writeError => 'Ошибка записи';

  @override
  String get brand => 'Бренд';

  @override
  String get selectBrand => 'Выбрать бренд';

  @override
  String get materialType => 'Тип материала';

  @override
  String get selectMaterial => 'Выбрать материал';

  @override
  String get serialNumber => 'Серийный номер';

  @override
  String get serialNumberHint => 'напр.: 001';

  @override
  String get initialWeight => 'Начальный вес';

  @override
  String get initialWeightHint => 'напр.: 1000';

  @override
  String get extruderTempMin => 'Темп. экструдера мин';

  @override
  String get extruderTempMax => 'Темп. экструдера макс';

  @override
  String get bedTempMin => 'Темп. стола мин';

  @override
  String get bedTempMax => 'Темп. стола макс';

  @override
  String get diameter => 'Диаметр';

  @override
  String get spoolLength => 'Длина (м)';

  @override
  String get generatedSku => 'Сгенерированный SKU';

  @override
  String get approachChipToWrite => 'Поднесите чип для записи...';

  @override
  String get writing => 'Запись...';

  @override
  String get chooseColor => 'Выбрать цвет';

  @override
  String get required => 'Обязательно';

  @override
  String get invalid => 'Недействительно';

  @override
  String get advancedSettings => 'Расширенные настройки';

  @override
  String get opacity => 'Непрозрачность';

  @override
  String get validate => 'Подтвердить';

  @override
  String get nfcTagInfo =>
      'Используйте пустую NFC-метку ISO14443A (NTAG213) для создания собственных меток Anycubic.';

  @override
  String get stockInventory => 'Катушки на складе';

  @override
  String get addSpool => 'Добавить катушку';

  @override
  String get scanSpool => 'Сканировать катушку';

  @override
  String get addManually => 'Добавить вручную';

  @override
  String get spoolAdded => 'Катушка добавлена';

  @override
  String get spoolUpdated => 'Катушка обновлена';

  @override
  String get noSpoolsInStock => 'Нет катушек на складе';

  @override
  String get addFirstSpool =>
      'Добавьте первую катушку, чтобы начать отслеживать инвентарь';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count катушка/катушек с низким запасом (< $threshold%)';
  }

  @override
  String get edit => 'Редактировать';

  @override
  String get bobbinPrice => 'Цена катушки';

  @override
  String get price => 'Цена';

  @override
  String get priceHint => 'напр.: 25.00';

  @override
  String get save => 'Сохранить';

  @override
  String get spoolDetails => 'Детали катушки';

  @override
  String get deleteThisSpool => 'Удалить эту катушку?';

  @override
  String get cannotBeUndone => 'Это действие нельзя отменить.';

  @override
  String get addSpoolManually => 'Добавить катушку вручную';

  @override
  String get editSpool => 'Редактировать катушку';

  @override
  String get customBrand => 'Пользовательский бренд';

  @override
  String get customBrandHint => 'напр.: Мой бренд';

  @override
  String get chooseFromList => 'Выбрать из списка';

  @override
  String get addBrand => '+ Добавить бренд';

  @override
  String get customMaterial => 'Пользовательский материал';

  @override
  String get customMaterialHint => 'напр.: Мой материал';

  @override
  String get addMaterial => '+ Добавить материал';

  @override
  String get colorHint => 'напр.: Синий, Красный...';

  @override
  String get enterColor => 'Пожалуйста, введите цвет';

  @override
  String get initialWeightG => 'Начальный вес';

  @override
  String get remainingWeightG => 'Оставшийся вес';

  @override
  String get enterBrand => 'Пожалуйста, введите бренд';

  @override
  String get selectOrEnterBrand => 'Пожалуйста, выберите или введите бренд';

  @override
  String get quantity => 'Количество';

  @override
  String get quantityHelper => 'Добавьте несколько одинаковых катушек сразу';

  @override
  String get quantityInvalid => 'Введите число от 1 до 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count в наличии';
  }

  @override
  String get enterMaterial => 'Пожалуйста, введите материал';

  @override
  String get selectOrEnterMaterial =>
      'Пожалуйста, выберите или введите материал';

  @override
  String get enterPrice => 'Пожалуйста, введите цену';

  @override
  String get enterValidPrice => 'Пожалуйста, введите действительную цену';

  @override
  String get enterWeight => 'Пожалуйста, введите вес';

  @override
  String get enterValidWeight => 'Пожалуйста, введите действительный вес';

  @override
  String get remainingCannotExceedTotal =>
      'Оставшийся вес не может превышать общий вес';

  @override
  String get overview => 'Обзор';

  @override
  String get spoolsInStock => 'Катушек на складе';

  @override
  String get totalValue => 'Общая стоимость';

  @override
  String get lowStockSpools => 'Низкий запас';

  @override
  String get materialDistribution => 'Распределение по материалам';

  @override
  String get brandDistribution => 'Распределение по брендам';

  @override
  String get noData => 'Нет данных';

  @override
  String get refresh => 'Обновить';

  @override
  String get profileSettings => 'Настройки профиля';

  @override
  String get preferences => 'Предпочтения';

  @override
  String get language => 'Язык';

  @override
  String get selectLanguage => 'Выбрать язык';

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
  String get selectCurrency => 'Выбрать валюту';

  @override
  String get units => 'Единицы измерения';

  @override
  String get selectUnits => 'Выбрать единицы';

  @override
  String get metric => 'Метрическая (мм, г, °C)';

  @override
  String get imperial => 'Имперская (дюймы, унции, °F)';

  @override
  String get lowStockThreshold => 'Порог оповещения о низком запасе';

  @override
  String get lowStockThresholdDesc =>
      'Катушка будет считаться с низким запасом, если оставшийся вес меньше этого процента';

  @override
  String get authentication => 'Аутентификация';

  @override
  String get signInWithGoogle => 'Войти через Google';

  @override
  String get signInWithApple => 'Войти через Apple';

  @override
  String get continueWithApple => 'Продолжить с Apple';

  @override
  String get continueWithGoogle => 'Продолжить с Google';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get about => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get madeWith => 'Создано с ❤️ для 3D-принтеров Anycubic';

  @override
  String get scanBobbinDirectly => 'Сканировать катушку';

  @override
  String get nfcEncoder => 'NFC-кодировщик';

  @override
  String get length => 'Длина';

  @override
  String get tempExtruder => 'Темп. экструдера';

  @override
  String get tempBed => 'Темп. стола';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get legal => 'Правовая информация';

  @override
  String get back => 'Назад';

  @override
  String get retry => 'Повторить';

  @override
  String get signOut => 'Выйти';

  @override
  String get signedOutMessage => 'Вы вышли из аккаунта';

  @override
  String get extruderTempMinHint => 'напр.: 200';

  @override
  String get extruderTempMaxHint => 'напр.: 220';

  @override
  String get bedTempMinHint => 'напр.: 50';

  @override
  String get bedTempMaxHint => 'напр.: 60';

  @override
  String get diameterHint => 'напр.: 1.75';

  @override
  String get spoolLengthHint => 'напр.: 330';

  @override
  String get tabGrid => 'Сетка';

  @override
  String get tabSpectrum => 'Спектр';

  @override
  String get tabSliders => 'Ползунки';

  @override
  String get hexCode => 'Шестнадцатеричный код';

  @override
  String get red => 'Красный';

  @override
  String get green => 'Зелёный';

  @override
  String get blue => 'Синий';

  @override
  String get black => 'Чёрный';

  @override
  String get white => 'Белый';

  @override
  String get yellow => 'Жёлтый';

  @override
  String get orange => 'Оранжевый';

  @override
  String get pink => 'Розовый';

  @override
  String get purple => 'Фиолетовый';

  @override
  String get gray => 'Серый';

  @override
  String get brown => 'Коричневый';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get metricUnits => 'Метрическая (мм, г, °C)';

  @override
  String get imperialUnits => 'Имперская (дюймы, унции, °F)';

  @override
  String get chf => 'Швейцарский франк (CHF)';

  @override
  String get eur => 'Евро (€)';

  @override
  String get usd => 'Доллар США (\$)';

  @override
  String get gbp => 'Фунт стерлингов (£)';

  @override
  String get cad => 'Канадский доллар (CAD)';

  @override
  String get aud => 'Австралийский доллар (A\$)';

  @override
  String get jpy => 'Японская иена (¥)';

  @override
  String get cny => 'Китайский юань (¥)';

  @override
  String get inr => 'Индийская рупия (₹)';

  @override
  String get brl => 'Бразильский реал (R\$)';

  @override
  String get mxn => 'Мексиканское песо (MX\$)';

  @override
  String get sek => 'Шведская крона (kr)';

  @override
  String get nok => 'Норвежская крона (kr)';

  @override
  String get dkk => 'Датская крона (kr)';

  @override
  String get pln => 'Польский злотый (zł)';

  @override
  String get czk => 'Чешская крона (Kč)';

  @override
  String get nzd => 'Новозеландский доллар (NZ\$)';

  @override
  String get filamentsToOrder => 'Филаменты для заказа';

  @override
  String get shoppingList => 'Список покупок';

  @override
  String get addToShoppingList => 'Добавить в список';

  @override
  String get noLowStockFilaments => 'Нет филаментов с низким запасом';

  @override
  String get vipSubscriptionDescription =>
      'Эта подписка служит только для отключения рекламы в приложении и поддержки проекта. Никаких других функций.';

  @override
  String get monthlySubscription => 'Месячная подписка';

  @override
  String get yearlySubscription => 'Годовая подписка';

  @override
  String get perMonth => '/ месяц';

  @override
  String get perYear => '/ год';

  @override
  String onlyPerMonth(String price) {
    return 'Всего $price / месяц';
  }

  @override
  String get subscribe => 'Подписаться';

  @override
  String get bestOffer => '✨ ЛУЧШЕЕ ПРЕДЛОЖЕНИЕ ✨';

  @override
  String get forAnycubicAce => 'для Anycubic Ace';

  @override
  String get forBambuLabAms => 'для Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Сканировать NFC-чип';

  @override
  String get fillForm => 'Заполнить форму';

  @override
  String get emptyShoppingList => 'Нет филаментов в списке';

  @override
  String percentRemaining(String percent) {
    return '$percent% осталось';
  }

  @override
  String get markAsOrdered => 'Отметить как заказано';

  @override
  String get markAsNotOrdered => 'Отметить как не заказано';

  @override
  String get notSignedIn => 'Не вошли';

  @override
  String get signIn => 'Войти';

  @override
  String get connection => 'Вход';

  @override
  String get signInToSync => 'Войдите, чтобы синхронизировать данные';

  @override
  String get continueWithoutAccount =>
      'Продолжить без учетной записи (локальный режим)';

  @override
  String get privacyNotice =>
      'Входя в систему, вы принимаете наши\nУсловия использования и Политику конфиденциальности';

  @override
  String get updateStock => 'Обновить запасы';

  @override
  String get scanToUpdateStock => 'Сканировать для обновления';

  @override
  String get weightUsed => 'Использованный вес';

  @override
  String get lengthUsed => 'Использованная длина';

  @override
  String get enterWeightOrLength => 'Введите использованный вес или длину';

  @override
  String get weightUsedG => 'Использованный вес (г)';

  @override
  String get lengthUsedM => 'Использованная длина (м)';

  @override
  String get stockUpdated => 'Запасы обновлены';

  @override
  String get scanSpoolToUpdate => 'Отсканируйте катушку для обновления запасов';

  @override
  String get spoolNotFound => 'Катушка не найдена на складе';

  @override
  String get addSpoolFirstMessage =>
      'Этой катушки еще нет на складе. Пожалуйста, сначала добавьте ее с помощью кнопки \'Добавить катушку\', прежде чем обновлять запасы.';

  @override
  String get ok => 'ОК';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Только чтение';

  @override
  String get bambuLabReadOnlyDesc =>
      'Метки Bambu Lab используют шифрование RSA и не могут быть изменены. Только чтение.';

  @override
  String get forPrusaMk4 => 'для Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Чтение и Запись';

  @override
  String get prusaReadWriteDesc =>
      'Теги Prusa используют ISO 15693 (NFC-V) с форматом OpenPrintTag. Чтение и запись поддерживаются.';

  @override
  String get bambuCloneLibrary => 'Библиотека клонов Bambu Lab';

  @override
  String get noBambuClones => 'Нет клонов Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Отсканируйте оригинальные метки Bambu Lab, чтобы создать библиотеку клонов';

  @override
  String get scanTag => 'Сканировать метку';

  @override
  String get syncWithCloud => 'Синхронизировать с облаком';

  @override
  String get syncCompleted => 'Синхронизация завершена';

  @override
  String get deleteClone => 'Удалить клон';

  @override
  String get renameClone => 'Переименовать клон';

  @override
  String get rename => 'Переименовать';

  @override
  String get customName => 'Пользовательское имя';

  @override
  String get clonedOn => 'Клонировано';

  @override
  String get writeThisClone => 'Записать этот клон';

  @override
  String get writeClone => 'Записать клон';

  @override
  String get writeOnCUID => 'Записать на карту CUID';

  @override
  String get cloneWrittenSuccess => 'Клон успешно записан!';

  @override
  String get requiredTagFormat => 'Требуемый формат метки';

  @override
  String get type => 'Тип';

  @override
  String get frequency => 'Частота';

  @override
  String get protocol => 'Протокол';

  @override
  String get capacity => 'Емкость';

  @override
  String get feature => 'Функция';

  @override
  String get uidModifiable => 'Блок 0 (UID) изменяемый';

  @override
  String get whereToBuy =>
      'Ищите \"CUID MiFare Classic 1K\" на AliExpress, Amazon или eBay (~0.50\$/шт)';

  @override
  String get magicGen2Required =>
      'Карта Magic Gen2 - MiFare Classic 1K с записываемым Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Ищите \"Magic Gen2 MiFare Classic 1K\" или \"UID writable\" на AliExpress, Amazon или eBay (~\$0.50/штука)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Предупреждение: Запись с помощью NFC iPhone может не работать на всех картах Magic Gen2. Рекомендуется устройство Proxmark3 для максимальной надежности.';

  @override
  String get step1GetMagicGen2 =>
      'Получите пустую карту Magic Gen2 (MiFare Classic 1K с записываемым UID)';

  @override
  String get instructions => 'Инструкции';

  @override
  String get step1GetCUID => 'Получите пустую карту CUID (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Нажмите кнопку \"Записать\" ниже';

  @override
  String get step3HoldPhone => 'Поднесите телефон к карте CUID';

  @override
  String get step4WaitConfirm => 'Дождитесь подтверждения записи';

  @override
  String get step5TestClone =>
      'Протестируйте клонированную метку на принтере Bambu Lab!';

  @override
  String get rsaIncluded =>
      'Клон включает оригинальную подпись RSA, он будет принят принтером!';

  @override
  String get cloneDeleted => 'Клон удален';

  @override
  String get deleteAccount => 'Удалить мой аккаунт';

  @override
  String get deleteAccountConfirmation =>
      'Это действие необратимо. Ваш аккаунт и все данные будут удалены в течение 30 дней.';

  @override
  String get accountDeletionRequested => 'Запрос на удаление зарегистрирован';

  @override
  String get clearShoppingList => 'Очистить список';

  @override
  String get clearShoppingListConfirmation =>
      'Вы уверены, что хотите очистить весь список покупок? Это действие нельзя отменить.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'История';

  @override
  String get retryButton => 'Повторить';

  @override
  String get readSuccessMessage => 'Чтение успешно!';

  @override
  String get filamentTypeLabel => 'Тип филамента';

  @override
  String get scanNfcChipButton => 'Сканировать NFC-чип';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Удалить клон \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Клон \"$name\" удалён';
  }

  @override
  String get extruderLabel => 'Экструдер';

  @override
  String get writeThisCloneButton => 'Записать этот клон';

  @override
  String get customNameHint => 'Пользовательское имя';

  @override
  String get cloneWriteSuccessMessage => 'Клон успешно записан!';

  @override
  String errorPrefix(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get writingInProgress => 'Запись...';

  @override
  String get writeOnCUIDButton => 'Записать на карту CUID';

  @override
  String get diameterLabel => 'Диаметр';

  @override
  String get extruderTempLabel => 'Температура экструдера';

  @override
  String get bedTempLabel => 'Температура стола';

  @override
  String get nfcFrequency => '13,56 МГц';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K байт (1024 байта)';

  @override
  String get rsaSignatureNote =>
      'Клон включает оригинальную подпись RSA, он будет принят принтером!';

  @override
  String get writeBambuLabTagTitle => 'Записать тег Bambu Lab';

  @override
  String get bambuLabTagWriteSuccess => 'Тег Bambu Lab успешно записан!';

  @override
  String get approachNfcTagMessage => 'Поднесите NFC-тег...';

  @override
  String get bambuLabFormatMiFare => 'Формат Bambu Lab (MiFare 13,56 МГц)';

  @override
  String get bambuLabFormat => 'Формат Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Этот формат использует коды материалов Bambu Lab и хранит данные в формате, совместимом с AMS.';

  @override
  String get brandLabel => 'Марка';

  @override
  String get materialTypeLabel => 'Тип материала';

  @override
  String get serialNumber3Digits => 'Серийный номер (3 цифры)';

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
  String get writeBambuLabTagButton => 'Записать тег Bambu Lab';

  @override
  String get bambuLabRsaNote =>
      'Примечание: Оригинальные теги Bambu Lab используют шифрование RSA. Этот режим записывает данные в упрощённом совместимом формате.';

  @override
  String signInError(String error) {
    return 'Ошибка входа: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Подписка успешно активирована!';

  @override
  String get subscriptionFailedMessage => 'Не удалось оформить подписку';

  @override
  String errorMessage(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Подписка успешно восстановлена!';

  @override
  String get noSubscriptionFoundMessage => 'Подписка не найдена';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'АКТИВНО';

  @override
  String get noAdsExperienceMessage => 'Вы наслаждаетесь версией без рекламы!';

  @override
  String get subscribedLabel => 'Подписчик';

  @override
  String get restorePurchasesButton => 'Восстановить покупки';

  @override
  String get cannotExceedRemainingWeight => 'Нельзя превысить оставшийся вес';

  @override
  String get pleaseEnterLength => 'Введите длину';

  @override
  String get pleaseEnterValidLength => 'Введите корректную длину';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Длина катушки не задана - невозможно преобразовать';

  @override
  String get exceedsRemainingWeight => 'Превышает оставшийся вес';

  @override
  String get skuLabel => 'Артикул';

  @override
  String get helpIdentifyFilament => 'Помогите нам определить этот филамент';

  @override
  String get helpUsImprove => 'Помогите нам стать лучше!';

  @override
  String get helpIdentifyDescription =>
      'Мы прочитали чип, но не смогли его распознать. Расскажите нам, какой это филамент, чтобы мы могли улучшить приложение.';

  @override
  String get otherBrand => 'Другой';

  @override
  String get thankYouFeedback => 'Спасибо за ваш отзыв!';

  @override
  String get send => 'Отправить';

  @override
  String get optionalDetails => 'Дополнительные данные';

  @override
  String get weightGrams => 'Вес (г)';

  @override
  String get diameterMm => 'Диаметр (мм)';

  @override
  String get spoolLengthM => 'Длина катушки (м)';

  @override
  String get batchNumberLabel => 'Партия / SKU';

  @override
  String get contactUs => 'Связаться с нами';

  @override
  String get contactUsSubtitle => 'Вопросы, предложения или проблемы';

  @override
  String get nfcTagNotDetected => 'Тег NFC не обнаружен';

  @override
  String get nfcTagNotDetectedDesc =>
      'Тег не найден. Тег может быть неисправен, повреждён или слишком далеко от телефона.';

  @override
  String get nfcTagIncompatible => 'Обнаружен несовместимый NFC-тег';

  @override
  String get nfcAuthError => 'Ошибка аутентификации NFC-метки';

  @override
  String get nfcAuthErrorDesc =>
      'Метка была обнаружена, но аутентификация не удалась после нескольких попыток. Плотно прижмите метку к задней панели телефона и попробуйте снова.';

  @override
  String get nfcTagInfoPrusa =>
      'Используйте пустой тег NXP ICODE SLIX2 (ISO 15693) для создания тегов, совместимых с OpenPrintTag, для Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Записать Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Вход через Apple недоступен на этом устройстве.';

  @override
  String get signInAppleFailed =>
      'Не удалось войти через Apple. Пожалуйста, попробуйте снова.';

  @override
  String get signInFailed => 'Не удалось войти. Пожалуйста, попробуйте снова.';

  @override
  String get mustContain3Digits => 'Должно содержать 3 цифры';

  @override
  String get mustBeNumber => 'Должно быть числом';

  @override
  String generatedUidLabel(String uid) {
    return 'Сгенерированный UID: $uid';
  }

  @override
  String get experimentalBadge => 'ЭКСПЕРИМЕНТАЛЬНОЕ';

  @override
  String get newBadge => 'НОВОЕ';

  @override
  String get forCrealityCfs => 'для Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Чтение и запись';

  @override
  String get crealityReadWriteDesc =>
      'Метки Creality CFS используют MiFare Classic 1K с шифрованием AES-128-ECB.';

  @override
  String get platformLimitationTitle => 'Ограничение платформы';

  @override
  String get mifareClassicNotSupportedIos =>
      'Метки MiFare Classic (Bambu Lab, Creality) не поддерживаются на iOS из-за ограничения Apple CoreNFC.';

  @override
  String get nfcTagInfoCreality =>
      'Используйте метку MiFare Classic 1K для записи данных, совместимых с Creality CFS, для Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Красный, Синий, Чёрный...';

  @override
  String get dryingTemp => 'Температура сушки';

  @override
  String get dryingTempHint => 'напр. 55';

  @override
  String get dryingTime => 'Время сушки (часы)';

  @override
  String get dryingTimeHint => 'напр. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Тег обнаружен как $mode — переключите вкладку для следующих сканирований';
  }

  @override
  String get fallbackChooseMode => 'Выбрать режим вручную';

  @override
  String get fallbackChooseModeSubtitle =>
      'Автоопределение не смогло идентифицировать этот тег. Выберите протокол:';

  @override
  String get tryAutoDetect => 'Попробовать авто-определение';

  @override
  String get autoDetectAllBrands => 'Авто-определение — все бренды';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D и другие';

  @override
  String get nfcTipIos =>
      'NFC-считыватель расположен в верхней части вашего iPhone. Поместите его прямо на NFC-метку катушки.';

  @override
  String get nfcTipAndroid =>
      'NFC-считыватель обычно расположен в центре задней панели телефона. Поместите заднюю панель телефона на NFC-метку катушки.';

  @override
  String get stockSortBy => 'Сортировка';

  @override
  String get stockFilter => 'Фильтр';

  @override
  String get stockSortRecent => 'Новейшие';

  @override
  String get stockSortBrand => 'Бренд';

  @override
  String get stockSortMaterial => 'Материал';

  @override
  String get stockSortRemaining => 'Остаток веса';

  @override
  String get stockSortColor => 'Цвет';

  @override
  String get stockFilterAll => 'Все';

  @override
  String get stockResetFilters => 'Сбросить';

  @override
  String get stockNoMatch => 'Нет катушек, соответствующих фильтрам';

  @override
  String get nfcDisabledTitle => 'NFC отключён';

  @override
  String get nfcDisabledMessage =>
      'NFC отключён. Включите его в настройках телефона, чтобы сканировать катушки.';

  @override
  String get updateAvailableTitle => 'Доступно обновление';

  @override
  String get updateAvailableMessage => 'Доступна новая версия Spool Master.';

  @override
  String get updateForcedMessage =>
      'Эта версия больше не поддерживается. Обновите приложение, чтобы продолжить.';

  @override
  String get updateNow => 'Обновить';

  @override
  String get updateLater => 'Позже';

  @override
  String get nfcScanGuidance =>
      'Держите метку неподвижно у верхней или задней части телефона.';

  @override
  String get tagMovedTitle => 'Метка сдвинулась';

  @override
  String get tagMovedMessage =>
      'Метка сдвинулась во время чтения. Приложите её снова и держите телефон неподвижно.';

  @override
  String get lightBlue => 'Голубой';

  @override
  String get transparent => 'Прозрачный';

  @override
  String get nfcActiveApproachTag => 'NFC активен — поднесите метку';

  @override
  String addedToShoppingList(String item) {
    return '$item добавлен в список покупок';
  }

  @override
  String get deleteAccountFailed =>
      'Не удалось удалить аккаунт. Повторите попытку.';

  @override
  String get scanHistoryError => 'Ошибка доступа к истории сканирований';

  @override
  String get genericBrand => 'Универсальный';

  @override
  String get stockSearchHint => 'Поиск (бренд, цвет, место…)';

  @override
  String get stockMoreActions => 'Ещё действия';

  @override
  String get exportExcel => 'Экспорт в Excel';

  @override
  String get exportFailed => 'Не удалось экспортировать';

  @override
  String get exportShareSubject => 'Мои запасы филамента (Spool Master)';

  @override
  String get exportColorHex => 'Код цвета';

  @override
  String get exportRemainingPercent => 'Осталось (%)';

  @override
  String get exportPricePerKg => 'Цена / кг';

  @override
  String get exportAddedDate => 'Дата добавления';

  @override
  String get exportOrdered => 'Заказано';

  @override
  String get exportDate => 'Дата';

  @override
  String get exportGrams => 'Граммы';

  @override
  String get exportCost => 'Стоимость';

  @override
  String get importSpools => 'Импорт (CSV / Excel)';

  @override
  String get importConfirmTitle => 'Импорт катушек';

  @override
  String importConfirmMessage(int count, int duplicates, int skipped) {
    return 'Катушек к добавлению: $count\nУже на складе (пропущены): $duplicates\nНечитаемые строки (пропущены): $skipped';
  }

  @override
  String get importAction => 'Импортировать';

  @override
  String get importNothingFound =>
      'Катушки не распознаны. Файл должен содержать как минимум столбцы «Материал» и «Вес» (как в Excel-экспорте приложения).';

  @override
  String importDone(int count) {
    return 'Импортировано катушек: $count';
  }

  @override
  String get importFailed => 'Файл нечитаем';

  @override
  String get location => 'Место хранения';

  @override
  String get locationHint => 'Напр.: полка A, сухой бокс 2';

  @override
  String get notes => 'Заметки';

  @override
  String get notesHint => 'Напр.: просушить перед использованием';

  @override
  String get printCostTitle => 'Стоимость печати';

  @override
  String get printCostGrams => 'Использовано филамента (г)';

  @override
  String printCostResult(String cost) {
    return 'Стоимость материала: $cost';
  }

  @override
  String printCostPerKg(String price) {
    return 'Цена за кг: $price';
  }

  @override
  String get printCostNoPrice =>
      'Добавьте цену катушки, чтобы рассчитать стоимость.';

  @override
  String get printCostDeduct => 'Списать со склада';

  @override
  String printCostDeducted(String grams) {
    return 'Списано со склада: $grams г';
  }

  @override
  String get consumptionTitle => 'Расход';

  @override
  String get consumptionLast30Days => 'Последние 30 дней';

  @override
  String get consumptionThisMonth => 'В этом месяце';

  @override
  String get consumptionByMaterial => 'По материалам (30 дней)';

  @override
  String get consumptionMonthly => 'Последние 6 месяцев';

  @override
  String get consumptionEmpty =>
      'Расход пока не записан. Он появится, как только вы обновите оставшийся вес катушки или воспользуетесь калькулятором стоимости.';

  @override
  String get shareShoppingList => 'Поделиться списком';

  @override
  String get nfcBlankTagTitle => 'Пустой тег';

  @override
  String get nfcBlankTagDesc =>
      'Этот тег не содержит данных о катушке. Добавьте катушку вручную или запишите тег в приложении.';

  @override
  String get subscriptionAutoRenewDisclosure =>
      'Оплата списывается с вашего аккаунта в магазине при подтверждении покупки. Подписка продлевается автоматически, если не отменить её не менее чем за 24 часа до окончания текущего периода; плата за продление списывается в течение 24 часов до окончания периода. Управлять подпиской или отменить её можно в настройках аккаунта в магазине.';

  @override
  String get manageSubscription => 'Управление подпиской';

  @override
  String get subscriptionPendingMessage =>
      'Платёж ожидает подтверждения: подписка будет активирована сразу после подтверждения.';

  @override
  String subscriptionEndsOn(String date) {
    return 'Автопродление отключено: доступ до $date';
  }
}
