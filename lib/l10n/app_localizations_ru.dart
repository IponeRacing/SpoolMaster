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
  String get legal => 'Legal';

  @override
  String get back => 'Назад';

  @override
  String get retry => 'Повторить';

  @override
  String get signOut => 'Выйти';

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
      '⚠️ Предупреждение: Запись с помощью NFC iPhone может не работать на всех картах Magic Gen2. Рекомендуется Android с приложением NFC Tools Pro или устройство Proxmark3 для надежности.';

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
  String get step3HoldPhone => 'Поднесите iPhone к карте CUID';

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
}
