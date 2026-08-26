// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Наличност';

  @override
  String get statistics => 'Аналитика';

  @override
  String get profile => 'Профил';

  @override
  String get readNfcChip => 'Четене на NFC чип';

  @override
  String get scanHistory => 'История';

  @override
  String get writeNfcChip => 'Записване на NFC чип';

  @override
  String get nfcNotAvailable => 'NFC не е налично';

  @override
  String get nfcNotAvailableDesc =>
      'Вашето устройство не поддържа NFC или е деактивирано.';

  @override
  String get nfcNotSupported => 'NFC не се поддържа на това устройство';

  @override
  String get approachNfcChip => 'Приближете NFC чип...';

  @override
  String get scanningNfc => 'Сканиране...';

  @override
  String get nfcDataRead => 'NFC данните са прочетени успешно!';

  @override
  String get errorReadingNfc => 'Грешка при четене на NFC';

  @override
  String get scanHistoryTitle => 'История на сканирания';

  @override
  String get noScansRecorded => 'Няма записани сканирания';

  @override
  String get scansWillAppearHere =>
      'NFC сканиранията ще се появят тук автоматично';

  @override
  String get clearAll => 'Изчисти всички';

  @override
  String get deleteThisScan => 'Изтриване на това сканиране?';

  @override
  String get actionIrreversible => 'Това действие е необратимо.';

  @override
  String get cancel => 'Отказ';

  @override
  String get delete => 'Изтрий';

  @override
  String get clearAllHistory => 'Изчистване на цялата история?';

  @override
  String get allScansWillBeDeleted =>
      'Всички сканирания ще бъдат изтрити. Това действие е необратимо.';

  @override
  String get scanDeleted => 'Сканирането е изтрито';

  @override
  String get scanDetails => 'Детайли на сканирането';

  @override
  String scannedOn(Object date) {
    return 'Сканирано на $date';
  }

  @override
  String get bobbinInformation => 'Информация за макарата';

  @override
  String get filamentType => 'Тип филамент';

  @override
  String get color => 'Цвят';

  @override
  String get weight => 'Тегло';

  @override
  String get manufacturingDate => 'Дата на производство';

  @override
  String get batchNumber => 'Номер на партида';

  @override
  String get printerSettings => 'Настройки на принтера';

  @override
  String get scanMetadata => 'Метаданни на сканирането';

  @override
  String get scanId => 'ID на сканирането';

  @override
  String get dateAndTime => 'Дата и час';

  @override
  String get reuseThisData => 'Повторно използване на тези данни';

  @override
  String get writeToNfc => 'Запис в NFC';

  @override
  String get writeDataToChip => 'Запис на данни в чипа';

  @override
  String get writeSuccess => 'Успешен запис!';

  @override
  String get writeError => 'Грешка при запис';

  @override
  String get brand => 'Марка';

  @override
  String get selectBrand => 'Изберете марка';

  @override
  String get materialType => 'Тип материал';

  @override
  String get selectMaterial => 'Изберете материал';

  @override
  String get serialNumber => 'Сериен номер';

  @override
  String get serialNumberHint => 'напр.: 001';

  @override
  String get initialWeight => 'Начално тегло';

  @override
  String get initialWeightHint => 'напр.: 1000';

  @override
  String get extruderTempMin => 'Мин. темп. екструдер';

  @override
  String get extruderTempMax => 'Макс. темп. екструдер';

  @override
  String get bedTempMin => 'Мин. темп. легло';

  @override
  String get bedTempMax => 'Макс. темп. легло';

  @override
  String get diameter => 'Диаметър на филамента';

  @override
  String get spoolLength => 'Дължина на макарата';

  @override
  String get generatedSku => 'Генериран SKU';

  @override
  String get approachChipToWrite => 'Приближете чип за запис...';

  @override
  String get writing => 'Записване...';

  @override
  String get chooseColor => 'Изберете цвят';

  @override
  String get required => 'Задължително';

  @override
  String get invalid => 'Невалидно';

  @override
  String get advancedSettings => 'Разширени настройки';

  @override
  String get opacity => 'Прозрачност';

  @override
  String get validate => 'Потвърди';

  @override
  String get nfcTagInfo =>
      'Използвайте празен ISO14443A NFC таг (NTAG213) за създаване на собствени Anycubic тагове.';

  @override
  String get stockInventory => 'Ролки в наличност';

  @override
  String get addSpool => 'Добави макара';

  @override
  String get scanSpool => 'Сканирай макара';

  @override
  String get addManually => 'Добави ръчно';

  @override
  String get spoolAdded => 'Макарата е добавена';

  @override
  String get spoolUpdated => 'Макарата е актуализирана';

  @override
  String get noSpoolsInStock => 'Няма макари на склад';

  @override
  String get addFirstSpool =>
      'Добавете първата си макара, за да започнете да следите инвентара си';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count макара/и с нисък запас (< $threshold%)';
  }

  @override
  String get edit => 'Редактирай';

  @override
  String get bobbinPrice => 'Цена на макарата';

  @override
  String get price => 'Цена';

  @override
  String get priceHint => 'напр.: 25.00';

  @override
  String get save => 'Запази';

  @override
  String get spoolDetails => 'Детайли на макарата';

  @override
  String get deleteThisSpool => 'Изтриване на тази макара?';

  @override
  String get cannotBeUndone => 'Това действие не може да бъде отменено.';

  @override
  String get addSpoolManually => 'Ръчно добавяне на макара';

  @override
  String get editSpool => 'Редактиране на макара';

  @override
  String get customBrand => 'Персонализирана марка';

  @override
  String get customBrandHint => 'напр.: Моята марка';

  @override
  String get chooseFromList => 'Избери от списък';

  @override
  String get addBrand => '+ Добави марка';

  @override
  String get customMaterial => 'Персонализиран материал';

  @override
  String get customMaterialHint => 'напр.: Моят материал';

  @override
  String get addMaterial => '+ Добави материал';

  @override
  String get colorHint => 'напр.: Син, Червен...';

  @override
  String get enterColor => 'Моля, въведете цвят';

  @override
  String get initialWeightG => 'Начално тегло';

  @override
  String get remainingWeightG => 'Оставащо тегло';

  @override
  String get enterBrand => 'Моля, въведете марка';

  @override
  String get selectOrEnterBrand => 'Моля, изберете или въведете марка';

  @override
  String get quantity => 'Количество';

  @override
  String get quantityHelper => 'Добавете няколко еднакви ролки наведнъж';

  @override
  String get quantityInvalid => 'Въведете число между 1 и 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count в наличност';
  }

  @override
  String get enterMaterial => 'Моля, въведете материал';

  @override
  String get selectOrEnterMaterial => 'Моля, изберете или въведете материал';

  @override
  String get enterPrice => 'Моля, въведете цена';

  @override
  String get enterValidPrice => 'Моля, въведете валидна цена';

  @override
  String get enterWeight => 'Моля, въведете тегло';

  @override
  String get enterValidWeight => 'Моля, въведете валидно тегло';

  @override
  String get remainingCannotExceedTotal =>
      'Оставащото тегло не може да надвишава общото тегло';

  @override
  String get overview => 'Общ преглед';

  @override
  String get spoolsInStock => 'Макари на склад';

  @override
  String get totalValue => 'Обща стойност';

  @override
  String get lowStockSpools => 'Нисък запас';

  @override
  String get materialDistribution => 'Разпределение по материал';

  @override
  String get brandDistribution => 'Разпределение по марка';

  @override
  String get noData => 'Няма данни';

  @override
  String get refresh => 'Опресни';

  @override
  String get profileSettings => 'Настройки на профила';

  @override
  String get preferences => 'Предпочитания';

  @override
  String get language => 'Език';

  @override
  String get selectLanguage => 'Изберете език';

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
  String get currency => 'Валута';

  @override
  String get selectCurrency => 'Изберете валута';

  @override
  String get units => 'Единици';

  @override
  String get selectUnits => 'Изберете единици';

  @override
  String get metric => 'Метрични (мм, г, °C)';

  @override
  String get imperial => 'Имперски (инч, унция, °F)';

  @override
  String get lowStockThreshold => 'Праг за сигнал при нисък запас';

  @override
  String get lowStockThresholdDesc =>
      'Една макара ще се счита за ниска на запас, ако оставащото тегло е по-малко от този процент';

  @override
  String get authentication => 'Удостоверяване';

  @override
  String get signInWithGoogle => 'Влез с Google';

  @override
  String get signInWithApple => 'Влез с Apple';

  @override
  String get continueWithApple => 'Продължи с Apple';

  @override
  String get continueWithGoogle => 'Продължи с Google';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get about => 'За приложението';

  @override
  String get version => 'Версия';

  @override
  String get madeWith => 'Направено с ❤️ за 3D принтери Anycubic';

  @override
  String get scanBobbinDirectly => 'Сканирай макара';

  @override
  String get nfcEncoder => 'NFC енкодер';

  @override
  String get length => 'Дължина';

  @override
  String get tempExtruder => 'Темп. екструдер';

  @override
  String get tempBed => 'Темп. легло';

  @override
  String get termsOfService => 'Условия за ползване';

  @override
  String get privacyPolicy => 'Политика за поверителност';

  @override
  String get legal => 'Правно';

  @override
  String get back => 'Назад';

  @override
  String get retry => 'Опитай отново';

  @override
  String get signOut => 'Изход';

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
  String get tabGrid => 'Мрежа';

  @override
  String get tabSpectrum => 'Спектър';

  @override
  String get tabSliders => 'Плъзгачи';

  @override
  String get hexCode => 'Hex код';

  @override
  String get red => 'Червено';

  @override
  String get green => 'Зелено';

  @override
  String get blue => 'Синьо';

  @override
  String get black => 'Черно';

  @override
  String get white => 'Бяло';

  @override
  String get yellow => 'Жълто';

  @override
  String get orange => 'Оранжево';

  @override
  String get pink => 'Розово';

  @override
  String get purple => 'Лилаво';

  @override
  String get gray => 'Сиво';

  @override
  String get brown => 'Кафяво';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get metricUnits => 'Метрични (мм, г, °C)';

  @override
  String get imperialUnits => 'Имперски (инч, унция, °F)';

  @override
  String get chf => 'Швейцарски франк (CHF)';

  @override
  String get eur => 'Евро (€)';

  @override
  String get usd => 'Американски долар (\$)';

  @override
  String get gbp => 'Британска лира (£)';

  @override
  String get cad => 'Канадски долар (CAD)';

  @override
  String get aud => 'Австралийски долар (A\$)';

  @override
  String get jpy => 'Японска йена (¥)';

  @override
  String get cny => 'Китайски юан (¥)';

  @override
  String get inr => 'Индийска рупия (₹)';

  @override
  String get brl => 'Бразилски реал (R\$)';

  @override
  String get mxn => 'Мексиканско песо (MX\$)';

  @override
  String get sek => 'Шведска крона (kr)';

  @override
  String get nok => 'Норвежка крона (kr)';

  @override
  String get dkk => 'Датска крона (kr)';

  @override
  String get pln => 'Полска злота (zł)';

  @override
  String get czk => 'Чешка крона (Kč)';

  @override
  String get nzd => 'Новозеландски долар (NZ\$)';

  @override
  String get filamentsToOrder => 'Филаменти за поръчка';

  @override
  String get shoppingList => 'Списък за пазаруване';

  @override
  String get addToShoppingList => 'Добави в списъка';

  @override
  String get noLowStockFilaments => 'Няма филаменти с нисък запас';

  @override
  String get vipSubscriptionDescription =>
      'Този абонамент се използва само за деактивиране на рекламите в приложението и подкрепа на проекта. Няма други функции.';

  @override
  String get monthlySubscription => 'Месечен абонамент';

  @override
  String get yearlySubscription => 'Годишен абонамент';

  @override
  String get perMonth => '/ месец';

  @override
  String get perYear => '/ година';

  @override
  String onlyPerMonth(String price) {
    return 'Само $price / месец';
  }

  @override
  String get subscribe => 'Абонирай се';

  @override
  String get bestOffer => '✨ НАЙ-ДОБРА ОФЕРТА ✨';

  @override
  String get forAnycubicAce => 'за Anycubic Ace';

  @override
  String get forBambuLabAms => 'за Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Сканирай NFC чип';

  @override
  String get fillForm => 'Попълни формуляра';

  @override
  String get emptyShoppingList => 'Няма филаменти в списъка';

  @override
  String percentRemaining(String percent) {
    return '$percent% остават';
  }

  @override
  String get markAsOrdered => 'Маркирай като поръчано';

  @override
  String get markAsNotOrdered => 'Маркирай като непоръчано';

  @override
  String get notSignedIn => 'Не сте влезли';

  @override
  String get signIn => 'Влизане';

  @override
  String get connection => 'Свързване';

  @override
  String get signInToSync => 'Влезте, за да синхронизирате данните си';

  @override
  String get continueWithoutAccount => 'Продължете без акаунт (локален режим)';

  @override
  String get privacyNotice =>
      'С влизането приемате нашите\nУсловия за ползване и Политика за поверителност';

  @override
  String get updateStock => 'Актуализиране на наличност';

  @override
  String get scanToUpdateStock => 'Сканирайте за актуализация';

  @override
  String get weightUsed => 'Използвано тегло';

  @override
  String get lengthUsed => 'Използвана дължина';

  @override
  String get enterWeightOrLength => 'Въведете използвано тегло или дължина';

  @override
  String get weightUsedG => 'Използвано тегло (g)';

  @override
  String get lengthUsedM => 'Използвана дължина (m)';

  @override
  String get stockUpdated => 'Наличността е актуализирана';

  @override
  String get scanSpoolToUpdate =>
      'Сканирайте ролка, за да актуализирате наличността ѝ';

  @override
  String get spoolNotFound => 'Ролката не е намерена в наличностите';

  @override
  String get addSpoolFirstMessage =>
      'Тази ролка все още не е във вашите наличности. Моля, първо я добавете с бутона \'Добави ролка\', преди да актуализирате наличността.';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Само за четене';

  @override
  String get bambuLabReadOnlyDesc =>
      'Etiketite Bambu Lab използват RSA криптиране и не могат да бъдат променяни. Само за четене.';

  @override
  String get forPrusaMk4 => 'за Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Четене и запис';

  @override
  String get prusaReadWriteDesc =>
      'Prusa таговете използват ISO 15693 (NFC-V) с формат OpenPrintTag. Поддържа се четене и запис.';

  @override
  String get bambuCloneLibrary => 'Библиотека клонове Bambu Lab';

  @override
  String get noBambuClones => 'Няма клонове Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Сканирайте оригинални етикети Bambu Lab, за да създадете библиотека с клонове';

  @override
  String get scanTag => 'Сканирай етикет';

  @override
  String get syncWithCloud => 'Синхронизация с облака';

  @override
  String get syncCompleted => 'Синхронизацията завършена';

  @override
  String get deleteClone => 'Изтрий клон';

  @override
  String get renameClone => 'Преименувай клон';

  @override
  String get rename => 'Преименувай';

  @override
  String get customName => 'Персонализирано име';

  @override
  String get clonedOn => 'Клониран на';

  @override
  String get writeThisClone => 'Запиши този клон';

  @override
  String get writeClone => 'Запиши клон';

  @override
  String get writeOnCUID => 'Запиши на CUID карта';

  @override
  String get cloneWrittenSuccess => 'Клонът е записан успешно!';

  @override
  String get requiredTagFormat => 'Изискван формат на етикет';

  @override
  String get type => 'Тип';

  @override
  String get frequency => 'Честота';

  @override
  String get protocol => 'Протокол';

  @override
  String get capacity => 'Капацитет';

  @override
  String get feature => 'Функция';

  @override
  String get uidModifiable => 'Блок 0 (UID) променяем';

  @override
  String get whereToBuy =>
      'Потърсете \"CUID MiFare Classic 1K\" в AliExpress, Amazon или eBay (~\$0.50/бр)';

  @override
  String get magicGen2Required =>
      'Карта Magic Gen2 - MiFare Classic 1K с записваем Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Търсете \"Magic Gen2 MiFare Classic 1K\" или \"UID writable\" в AliExpress, Amazon или eBay (~\$0.50/бр)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Предупреждение: Записването с iPhone NFC може да не работи на всички карти Magic Gen2. Препоръчва се устройство Proxmark3 за максимална надеждност.';

  @override
  String get step1GetMagicGen2 =>
      'Вземете празна карта Magic Gen2 (MiFare Classic 1K със записваем UID)';

  @override
  String get instructions => 'Инструкции';

  @override
  String get step1GetCUID => 'Вземете празна CUID карта (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Натиснете бутона \"Запиши\" по-долу';

  @override
  String get step3HoldPhone => 'Дръжте телефона до CUID картата';

  @override
  String get step4WaitConfirm => 'Изчакайте потвърждение на записването';

  @override
  String get step5TestClone =>
      'Тествайте клонирания етикет на вашия принтер Bambu Lab!';

  @override
  String get rsaIncluded =>
      'Клонът включва оригиналния RSA подпис, ще бъде приет от принтера!';

  @override
  String get cloneDeleted => 'Клонът е изтрит';

  @override
  String get deleteAccount => 'Изтрий акаунта ми';

  @override
  String get deleteAccountConfirmation =>
      'Това действие е необратимо. Вашият акаунт и всички данни ще бъдат изтрити в рамките на 30 дни.';

  @override
  String get accountDeletionRequested => 'Заявката за изтриване е регистрирана';

  @override
  String get clearShoppingList => 'Изчисти списъка';

  @override
  String get clearShoppingListConfirmation =>
      'Сигурни ли сте, че искате да изчистите целия списък за пазаруване? Това действие не може да бъде отменено.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'История';

  @override
  String get retryButton => 'Опитай отново';

  @override
  String get readSuccessMessage => 'Успешно прочетено!';

  @override
  String get filamentTypeLabel => 'Тип филамент';

  @override
  String get scanNfcChipButton => 'Сканирай NFC чип';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Изтриване на клонинг \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Клонинг \"$name\" изтрит';
  }

  @override
  String get extruderLabel => 'Екструдер';

  @override
  String get writeThisCloneButton => 'Запиши този клонинг';

  @override
  String get customNameHint => 'Персонализирано име';

  @override
  String get cloneWriteSuccessMessage => 'Клонингът е записан успешно!';

  @override
  String errorPrefix(String error) {
    return 'Грешка: $error';
  }

  @override
  String get writingInProgress => 'Записване...';

  @override
  String get writeOnCUIDButton => 'Запиши на CUID карта';

  @override
  String get diameterLabel => 'Диаметър';

  @override
  String get extruderTempLabel => 'Температура на екструдера';

  @override
  String get bedTempLabel => 'Температура на легло';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K байта (1024 байта)';

  @override
  String get rsaSignatureNote =>
      'Клонингът включва оригиналния RSA подпис, принтерът ще го приеме!';

  @override
  String get writeBambuLabTagTitle => 'Запиши Bambu Lab етикет';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab етикетът е записан успешно!';

  @override
  String get approachNfcTagMessage => 'Доближете NFC етикет...';

  @override
  String get bambuLabFormatMiFare => 'Формат Bambu Lab (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Формат Bambu Lab';

  @override
  String get bambuLabFormatInfo =>
      'Този формат използва кодове за материали на Bambu Lab и съхранява данни в AMS-съвместим формат.';

  @override
  String get brandLabel => 'Марка';

  @override
  String get materialTypeLabel => 'Тип материал';

  @override
  String get serialNumber3Digits => 'Сериен номер (3 цифри)';

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
  String get writeBambuLabTagButton => 'Запиши Bambu Lab етикет';

  @override
  String get bambuLabRsaNote =>
      'Забележка: Оригиналните етикети на Bambu Lab използват RSA криптиране. Този режим записва данни в опростен съвместим формат.';

  @override
  String signInError(String error) {
    return 'Грешка при влизане: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Абонаментът е активиран успешно!';

  @override
  String get subscriptionFailedMessage => 'Абонаментът е неуспешен';

  @override
  String errorMessage(String error) {
    return 'Грешка: $error';
  }

  @override
  String get subscriptionRestoredMessage =>
      'Абонаментът е възстановен успешно!';

  @override
  String get noSubscriptionFoundMessage => 'Не е намерен абонамент';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'АКТИВЕН';

  @override
  String get noAdsExperienceMessage =>
      'Насладете се на изживяване без реклами!';

  @override
  String get subscribedLabel => 'Абонат';

  @override
  String get restorePurchasesButton => 'Възстанови покупки';

  @override
  String get cannotExceedRemainingWeight =>
      'Не може да надвиши оставащото тегло';

  @override
  String get pleaseEnterLength => 'Моля, въведете дължина';

  @override
  String get pleaseEnterValidLength => 'Моля, въведете валидна дължина';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Дължината на макарата не е зададена - не може да се преобразува';

  @override
  String get exceedsRemainingWeight => 'Надвишава оставащото тегло';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament => 'Помогнете ни да разпознаем този филамент';

  @override
  String get helpUsImprove => 'Помогнете ни да се подобрим!';

  @override
  String get helpIdentifyDescription =>
      'Прочетохме чипа, но не успяхме да го разпознаем. Кажете ни какъв е този филамент, за да подобрим приложението.';

  @override
  String get otherBrand => 'Друга';

  @override
  String get thankYouFeedback => 'Благодарим за обратната връзка!';

  @override
  String get send => 'Изпрати';

  @override
  String get optionalDetails => 'Допълнителни детайли';

  @override
  String get weightGrams => 'Тегло (г)';

  @override
  String get diameterMm => 'Диаметър (мм)';

  @override
  String get spoolLengthM => 'Дължина на макарата (м)';

  @override
  String get batchNumberLabel => 'Партида / SKU';

  @override
  String get contactUs => 'Свържете се с нас';

  @override
  String get contactUsSubtitle => 'Въпроси, предложения или проблеми';

  @override
  String get nfcTagNotDetected => 'Не е открит NFC таг';

  @override
  String get nfcTagNotDetectedDesc =>
      'Не е намерен таг. Тагът може да е повреден или твърде далеч от телефона.';

  @override
  String get nfcTagIncompatible => 'Открит е несъвместим NFC таг';

  @override
  String get nfcAuthError => 'Неуспешна автентикация на NFC таг';

  @override
  String get nfcAuthErrorDesc =>
      'Тагът беше открит, но автентикацията е неуспешна след няколко опита. Дръжте тага плътно притиснат към гърба на телефона и опитайте отново.';

  @override
  String get nfcTagInfoPrusa =>
      'Използвайте празна етикета NXP ICODE SLIX2 (ISO 15693) за създаване на OpenPrintTag съвместими етикети за Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Запиши Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Влизането с Apple не е налично на това устройство.';

  @override
  String get signInAppleFailed =>
      'Влизането с Apple не успя. Моля, опитайте отново.';

  @override
  String get signInFailed => 'Влизането не успя. Моля, опитайте отново.';

  @override
  String get mustContain3Digits => 'Трябва да съдържа 3 цифри';

  @override
  String get mustBeNumber => 'Трябва да е число';

  @override
  String generatedUidLabel(String uid) {
    return 'Генериран UID: $uid';
  }

  @override
  String get experimentalBadge => 'ЕКСПЕРИМЕНТАЛНО';

  @override
  String get newBadge => 'НОВО';

  @override
  String get forCrealityCfs => 'за Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Четене и запис';

  @override
  String get crealityReadWriteDesc =>
      'Таговете Creality CFS използват MiFare Classic 1K с AES-128-ECB криптиране. Четенето и записът се поддържат само на Android.';

  @override
  String get platformLimitationTitle => 'Ограничение на платформата';

  @override
  String get mifareClassicNotSupportedIos =>
      'Таговете MiFare Classic (Bambu Lab, Creality) не се поддържат на iOS поради ограничение на Apple CoreNFC. Тази функция е достъпна само на Android.';

  @override
  String get nfcTagInfoCreality =>
      'Използвайте таг MiFare Classic 1K, за да запишете данни, съвместими с Creality CFS, за Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Червено, Синьо, Черно...';

  @override
  String get dryingTemp => 'Température de séchage';

  @override
  String get dryingTempHint => 'ex. 55';

  @override
  String get dryingTime => 'Temps de séchage (heures)';

  @override
  String get dryingTimeHint => 'ex. 8';

  @override
  String fallbackDetectedAs(String mode) {
    return 'Тагът е открит като $mode — сменете раздела за следващите сканирания';
  }

  @override
  String get fallbackChooseMode => 'Изберете режим ръчно';

  @override
  String get fallbackChooseModeSubtitle =>
      'Автоматичното разпознаване не успя да идентифицира този таг. Изберете протокола:';

  @override
  String get tryAutoDetect => 'Опитайте автоматично разпознаване';

  @override
  String get autoDetectAllBrands => 'Автоматично разпознаване — всички марки';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D и други';

  @override
  String get nfcTipIos =>
      'NFC четецът е в горната част на вашия iPhone. Поставете го директно върху NFC маркера на макарата.';

  @override
  String get nfcTipAndroid =>
      'NFC четецът обикновено е в средата на задната част на телефона. Поставете задната страна на телефона върху NFC маркера на макарата.';

  @override
  String get stockSortBy => 'Сортиране';

  @override
  String get stockFilter => 'Филтър';

  @override
  String get stockSortRecent => 'Най-нови';

  @override
  String get stockSortBrand => 'Марка';

  @override
  String get stockSortMaterial => 'Материал';

  @override
  String get stockSortRemaining => 'Оставащо тегло';

  @override
  String get stockSortColor => 'Цвят';

  @override
  String get stockFilterAll => 'Всички';

  @override
  String get stockResetFilters => 'Нулиране';

  @override
  String get stockNoMatch => 'Няма ролка, отговаряща на филтрите';

  @override
  String get nfcDisabledTitle => 'NFC е изключено';

  @override
  String get nfcDisabledMessage =>
      'NFC е изключено. Включете го в настройките на телефона, за да сканирате ролките.';

  @override
  String get updateAvailableTitle => 'Налична актуализация';

  @override
  String get updateAvailableMessage => 'Налична е нова версия на Spool Master.';

  @override
  String get updateForcedMessage =>
      'Тази версия вече не се поддържа. Моля, актуализирайте, за да продължите.';

  @override
  String get updateNow => 'Актуализиране';

  @override
  String get updateLater => 'По-късно';

  @override
  String get nfcScanGuidance =>
      'Дръжте тага неподвижно към горната или задната част на телефона.';

  @override
  String get tagMovedTitle => 'Тагът се премести';

  @override
  String get tagMovedMessage =>
      'Тагът се премести по време на четенето. Поставете го отново и дръжте телефона неподвижно.';
}
