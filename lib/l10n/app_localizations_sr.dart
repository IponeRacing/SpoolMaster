// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Serbian (`sr`).
class AppLocalizationsSr extends AppLocalizations {
  AppLocalizationsSr([String locale = 'sr']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => 'Залихе';

  @override
  String get statistics => 'Аналитика';

  @override
  String get profile => 'Профил';

  @override
  String get readNfcChip => 'Читај NFC чип';

  @override
  String get scanHistory => 'Историја';

  @override
  String get writeNfcChip => 'Упиши NFC чип';

  @override
  String get nfcNotAvailable => 'NFC није доступан';

  @override
  String get nfcNotAvailableDesc =>
      'Ваш уређај не подржава NFC или је онемогућен.';

  @override
  String get nfcNotSupported => 'NFC није подржан на овом уређају';

  @override
  String get approachNfcChip => 'Приближите NFC чип...';

  @override
  String get scanningNfc => 'Скенирање...';

  @override
  String get nfcDataRead => 'NFC подаци успешно прочитани!';

  @override
  String get errorReadingNfc => 'Грешка при читању NFC-а';

  @override
  String get scanHistoryTitle => 'Историја скенирања';

  @override
  String get noScansRecorded => 'Нема забележених скенирања';

  @override
  String get scansWillAppearHere =>
      'NFC скенирања ће се аутоматски појавити овде';

  @override
  String get clearAll => 'Обриши све';

  @override
  String get deleteThisScan => 'Избрисати ово скенирање?';

  @override
  String get actionIrreversible => 'Ова радња је неповратна.';

  @override
  String get cancel => 'Откажи';

  @override
  String get delete => 'Избриши';

  @override
  String get clearAllHistory => 'Обрисати целу историју?';

  @override
  String get allScansWillBeDeleted =>
      'Сва скенирања ће бити избрисана. Ова радња је неповратна.';

  @override
  String get scanDeleted => 'Скенирање избрисано';

  @override
  String get scanDetails => 'Детаљи скенирања';

  @override
  String scannedOn(Object date) {
    return 'Скенирано $date';
  }

  @override
  String get bobbinInformation => 'Информације о калему';

  @override
  String get filamentType => 'Тип филамента';

  @override
  String get color => 'Боја';

  @override
  String get weight => 'Тежина';

  @override
  String get manufacturingDate => 'Датум производње';

  @override
  String get batchNumber => 'Број серије';

  @override
  String get printerSettings => 'Подешавања штампача';

  @override
  String get scanMetadata => 'Метаподаци скенирања';

  @override
  String get scanId => 'ID скенирања';

  @override
  String get dateAndTime => 'Датум и време';

  @override
  String get reuseThisData => 'Поново користи ове податке';

  @override
  String get writeToNfc => 'Упиши у NFC';

  @override
  String get writeDataToChip => 'Упиши податке у чип';

  @override
  String get writeSuccess => 'Успешан упис!';

  @override
  String get writeError => 'Грешка при упису';

  @override
  String get brand => 'Бренд';

  @override
  String get selectBrand => 'Изаберите бренд';

  @override
  String get materialType => 'Тип материјала';

  @override
  String get selectMaterial => 'Изаберите материјал';

  @override
  String get serialNumber => 'Серијски број';

  @override
  String get serialNumberHint => 'нпр.: 001';

  @override
  String get initialWeight => 'Почетна тежина';

  @override
  String get initialWeightHint => 'нпр.: 1000';

  @override
  String get extruderTempMin => 'Мин. темп. екструдера';

  @override
  String get extruderTempMax => 'Макс. темп. екструдера';

  @override
  String get bedTempMin => 'Мин. темп. подлоге';

  @override
  String get bedTempMax => 'Макс. темп. подлоге';

  @override
  String get diameter => 'Пречник филамента';

  @override
  String get spoolLength => 'Дужина калема';

  @override
  String get generatedSku => 'Генерисани SKU';

  @override
  String get approachChipToWrite => 'Приближите чип за упис...';

  @override
  String get writing => 'Уписивање...';

  @override
  String get chooseColor => 'Изаберите боју';

  @override
  String get required => 'Обавезно';

  @override
  String get invalid => 'Неважеће';

  @override
  String get advancedSettings => 'Напредна подешавања';

  @override
  String get opacity => 'Провидност';

  @override
  String get validate => 'Потврди';

  @override
  String get nfcTagInfo =>
      'Користите празну ISO14443A NFC ознаку (NTAG213) за креирање сопствених Anycubic ознака.';

  @override
  String get stockInventory => 'Калемови на залихама';

  @override
  String get addSpool => 'Додај калем';

  @override
  String get scanSpool => 'Скенирај калем';

  @override
  String get addManually => 'Додај ручно';

  @override
  String get spoolAdded => 'Калем додат';

  @override
  String get spoolUpdated => 'Калем ажуриран';

  @override
  String get noSpoolsInStock => 'Нема калемова на залихи';

  @override
  String get addFirstSpool =>
      'Додајте свој први калем да бисте почели да пратите инвентар';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count калем(а) са ниским залихама (< $threshold%)';
  }

  @override
  String get edit => 'Измени';

  @override
  String get bobbinPrice => 'Цена калема';

  @override
  String get price => 'Цена';

  @override
  String get priceHint => 'нпр.: 25.00';

  @override
  String get save => 'Сачувај';

  @override
  String get spoolDetails => 'Детаљи калема';

  @override
  String get deleteThisSpool => 'Избрисати овај калем?';

  @override
  String get cannotBeUndone => 'Ова радња се не може поништити.';

  @override
  String get addSpoolManually => 'Ручно додавање калема';

  @override
  String get editSpool => 'Измени калем';

  @override
  String get customBrand => 'Прилагођени бренд';

  @override
  String get customBrandHint => 'нпр.: Мој бренд';

  @override
  String get chooseFromList => 'Изаберите са листе';

  @override
  String get addBrand => '+ Додај бренд';

  @override
  String get customMaterial => 'Прилагођени материјал';

  @override
  String get customMaterialHint => 'нпр.: Мој материјал';

  @override
  String get addMaterial => '+ Додај материјал';

  @override
  String get colorHint => 'нпр.: Плава, Црвена...';

  @override
  String get enterColor => 'Молимо унесите боју';

  @override
  String get initialWeightG => 'Почетна тежина';

  @override
  String get remainingWeightG => 'Преостала тежина';

  @override
  String get enterBrand => 'Молимо унесите бренд';

  @override
  String get selectOrEnterBrand => 'Молимо изаберите или унесите бренд';

  @override
  String get quantity => 'Количина';

  @override
  String get quantityHelper => 'Додајте више истих котура одједном';

  @override
  String get quantityInvalid => 'Унесите број између 1 и 99';

  @override
  String spoolsInStockCount(int count) {
    return '$count на залихи';
  }

  @override
  String get enterMaterial => 'Молимо унесите материјал';

  @override
  String get selectOrEnterMaterial => 'Молимо изаберите или унесите материјал';

  @override
  String get enterPrice => 'Молимо унесите цену';

  @override
  String get enterValidPrice => 'Молимо унесите важећу цену';

  @override
  String get enterWeight => 'Молимо унесите тежину';

  @override
  String get enterValidWeight => 'Молимо унесите важећу тежину';

  @override
  String get remainingCannotExceedTotal =>
      'Преостала тежина не може премашити укупну тежину';

  @override
  String get overview => 'Преглед';

  @override
  String get spoolsInStock => 'Калемови на залихи';

  @override
  String get totalValue => 'Укупна вредност';

  @override
  String get lowStockSpools => 'Ниске залихе';

  @override
  String get materialDistribution => 'Дистрибуција по материјалу';

  @override
  String get brandDistribution => 'Дистрибуција по бренду';

  @override
  String get noData => 'Нема података';

  @override
  String get refresh => 'Освежи';

  @override
  String get profileSettings => 'Подешавања профила';

  @override
  String get preferences => 'Преференције';

  @override
  String get language => 'Језик';

  @override
  String get selectLanguage => 'Изаберите језик';

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
  String get selectCurrency => 'Изаберите валуту';

  @override
  String get units => 'Јединице';

  @override
  String get selectUnits => 'Изаберите јединице';

  @override
  String get metric => 'Метричке (мм, г, °C)';

  @override
  String get imperial => 'Империјалне (ин, унца, °F)';

  @override
  String get lowStockThreshold => 'Праг упозорења за ниске залихе';

  @override
  String get lowStockThresholdDesc =>
      'Калем ће се сматрати ниским залихама ако је преостала тежина мања од овог процента';

  @override
  String get authentication => 'Аутентификација';

  @override
  String get signInWithGoogle => 'Пријави се помоћу Google-а';

  @override
  String get signInWithApple => 'Пријави се помоћу Apple-а';

  @override
  String get continueWithApple => 'Настави са Apple';

  @override
  String get continueWithGoogle => 'Настави са Google';

  @override
  String get comingSoon => 'Ускоро';

  @override
  String get about => 'О апликацији';

  @override
  String get version => 'Верзија';

  @override
  String get madeWith => 'Направљено са ❤️ за Anycubic 3D штампаче';

  @override
  String get scanBobbinDirectly => 'Скенирај калем';

  @override
  String get nfcEncoder => 'NFC енкодер';

  @override
  String get length => 'Дужина';

  @override
  String get tempExtruder => 'Темп. екструдера';

  @override
  String get tempBed => 'Темп. подлоге';

  @override
  String get termsOfService => 'Услови коришћења';

  @override
  String get privacyPolicy => 'Политика приватности';

  @override
  String get legal => 'Правно';

  @override
  String get back => 'Назад';

  @override
  String get retry => 'Покушај поново';

  @override
  String get signOut => 'Одјави се';

  @override
  String get extruderTempMinHint => 'Нпр.: 200';

  @override
  String get extruderTempMaxHint => 'Нпр.: 220';

  @override
  String get bedTempMinHint => 'Нпр.: 50';

  @override
  String get bedTempMaxHint => 'Нпр.: 60';

  @override
  String get diameterHint => 'Нпр.: 1.75';

  @override
  String get spoolLengthHint => 'Нпр.: 330';

  @override
  String get tabGrid => 'Мрежа';

  @override
  String get tabSpectrum => 'Спектар';

  @override
  String get tabSliders => 'Клизачи';

  @override
  String get hexCode => 'Hex код';

  @override
  String get red => 'Црвена';

  @override
  String get green => 'Зелена';

  @override
  String get blue => 'Плава';

  @override
  String get black => 'Црна';

  @override
  String get white => 'Бела';

  @override
  String get yellow => 'Жута';

  @override
  String get orange => 'Наранџаста';

  @override
  String get pink => 'Розе';

  @override
  String get purple => 'Љубичаста';

  @override
  String get gray => 'Сива';

  @override
  String get brown => 'Браон';

  @override
  String get unknown => 'Непознато';

  @override
  String get metricUnits => 'Метричке (мм, г, °C)';

  @override
  String get imperialUnits => 'Империјалне (ин, унца, °F)';

  @override
  String get chf => 'Швајцарски франак (CHF)';

  @override
  String get eur => 'Евро (€)';

  @override
  String get usd => 'Амерички долар (\$)';

  @override
  String get gbp => 'Фунта стерлинга (£)';

  @override
  String get cad => 'Канадски долар (CAD)';

  @override
  String get aud => 'Аустралијски долар (A\$)';

  @override
  String get jpy => 'Јапански јен (¥)';

  @override
  String get cny => 'Кинески јуан (¥)';

  @override
  String get inr => 'Индијска рупија (₹)';

  @override
  String get brl => 'Бразилски реал (R\$)';

  @override
  String get mxn => 'Мексички пезос (MX\$)';

  @override
  String get sek => 'Шведска круна (kr)';

  @override
  String get nok => 'Норвешка круна (kr)';

  @override
  String get dkk => 'Данска круна (kr)';

  @override
  String get pln => 'Пољски злот (zł)';

  @override
  String get czk => 'Чешка круна (Kč)';

  @override
  String get nzd => 'Новозеландски долар (NZ\$)';

  @override
  String get filamentsToOrder => 'Филаменти за наручивање';

  @override
  String get shoppingList => 'Листа за куповину';

  @override
  String get addToShoppingList => 'Додај на листу';

  @override
  String get noLowStockFilaments => 'Нема филамената са ниским залихама';

  @override
  String get vipSubscriptionDescription =>
      'Ова претплата се користи само за онемогућавање огласа у апликацији и подршку пројекту. Нема других функција.';

  @override
  String get monthlySubscription => 'Месечна претплата';

  @override
  String get yearlySubscription => 'Годишња претплата';

  @override
  String get perMonth => '/ месец';

  @override
  String get perYear => '/ година';

  @override
  String onlyPerMonth(String price) {
    return 'Само $price / месец';
  }

  @override
  String get subscribe => 'Претплати се';

  @override
  String get bestOffer => '✨ НАЈБОЉА ПОНУДА ✨';

  @override
  String get forAnycubicAce => 'за Anycubic Ace';

  @override
  String get forBambuLabAms => 'за Bambu Lab AMS';

  @override
  String get scanNfcChip => 'Скенирај NFC чип';

  @override
  String get fillForm => 'Попуни формулар';

  @override
  String get emptyShoppingList => 'Нема филамената на листи';

  @override
  String percentRemaining(String percent) {
    return '$percent% преостало';
  }

  @override
  String get markAsOrdered => 'Означи као наручено';

  @override
  String get markAsNotOrdered => 'Означи као ненаручено';

  @override
  String get notSignedIn => 'Нисте пријављени';

  @override
  String get signIn => 'Пријава';

  @override
  String get connection => 'Веза';

  @override
  String get signInToSync => 'Пријавите се да синхронизујете податке';

  @override
  String get continueWithoutAccount => 'Наставите без налога (локални режим)';

  @override
  String get privacyNotice =>
      'Пријављивањем прихватате наше\nУслове коришћења и Политику приватности';

  @override
  String get updateStock => 'Ажурирај залихе';

  @override
  String get scanToUpdateStock => 'Скенирај за ажурирање';

  @override
  String get weightUsed => 'Коришћена тежина';

  @override
  String get lengthUsed => 'Коришћена дужина';

  @override
  String get enterWeightOrLength => 'Унесите коришћену тежину или дужину';

  @override
  String get weightUsedG => 'Коришћена тежина (g)';

  @override
  String get lengthUsedM => 'Коришћена дужина (m)';

  @override
  String get stockUpdated => 'Залихе ажуриране';

  @override
  String get scanSpoolToUpdate => 'Скенирајте калем да ажурирате залихе';

  @override
  String get spoolNotFound => 'Калем није пронађен у залихама';

  @override
  String get addSpoolFirstMessage =>
      'Овај калем још није у вашим залихама. Молимо вас да га прво додате користећи дугме \'Додај калем\' пре ажурирања залиха.';

  @override
  String get ok => 'У реду';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: Само за читање';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab ознаке користе RSA енкрипцију и не могу се мењати. Само за читање.';

  @override
  String get forPrusaMk4 => 'за Prusa MK4/XL (OpenPrintTag)';

  @override
  String get prusaReadWrite => 'Prusa: Читање и писање';

  @override
  String get prusaReadWriteDesc =>
      'Prusa ознаке користе ISO 15693 (NFC-V) са OpenPrintTag форматом. Подршка за читање и писање.';

  @override
  String get bambuCloneLibrary => 'Библиотека клонова Bambu Lab';

  @override
  String get noBambuClones => 'Нема клонова Bambu Lab';

  @override
  String get scanBambuToClone =>
      'Скенирајте оригиналне ознаке Bambu Lab да бисте креирали библиотеку клонова';

  @override
  String get scanTag => 'Скенирај ознаку';

  @override
  String get syncWithCloud => 'Синхронизуј са облаком';

  @override
  String get syncCompleted => 'Синхронизација завршена';

  @override
  String get deleteClone => 'Обриши клон';

  @override
  String get renameClone => 'Преименуј клон';

  @override
  String get rename => 'Преименуј';

  @override
  String get customName => 'Прилагођено име';

  @override
  String get clonedOn => 'Клониран';

  @override
  String get writeThisClone => 'Упиши овај клон';

  @override
  String get writeClone => 'Упиши клон';

  @override
  String get writeOnCUID => 'Упиши на CUID картицу';

  @override
  String get cloneWrittenSuccess => 'Клон успешно уписан!';

  @override
  String get requiredTagFormat => 'Потребан формат ознаке';

  @override
  String get type => 'Тип';

  @override
  String get frequency => 'Фреквенција';

  @override
  String get protocol => 'Протокол';

  @override
  String get capacity => 'Капацитет';

  @override
  String get feature => 'Карактеристика';

  @override
  String get uidModifiable => 'Блок 0 (UID) променљив';

  @override
  String get whereToBuy =>
      'Потражите \"CUID MiFare Classic 1K\" на AliExpress, Amazon или eBay (~\$0.50/комад)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 картица - MiFare Classic 1K са уписивим Block 0 (UID)';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'Потражите \"Magic Gen2 MiFare Classic 1K\" или \"UID writable\" на AliExpress, Amazon или eBay (~\$0.50/комад)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ Упозорење: Писање са iPhone NFC можда неће радити на свим Magic Gen2 картицама. Препоручује се Proxmark3 уређај за максималну поузданост.';

  @override
  String get step1GetMagicGen2 =>
      'Набавите празну Magic Gen2 картицу (MiFare Classic 1K са уписивим UID)';

  @override
  String get instructions => 'Упутства';

  @override
  String get step1GetCUID => 'Набавите празну CUID картицу (MiFare Classic 1K)';

  @override
  String get step2PressWrite => 'Притисните дугме \"Упиши\" испод';

  @override
  String get step3HoldPhone => 'Држите телефон близу CUID картице';

  @override
  String get step4WaitConfirm => 'Сачекајте потврду уписа';

  @override
  String get step5TestClone =>
      'Тестирајте клонирану ознаку на штампачу Bambu Lab!';

  @override
  String get rsaIncluded =>
      'Клон укључује оригинални RSA потпис, биће прихваћен од стране штампача!';

  @override
  String get cloneDeleted => 'Клон обрисан';

  @override
  String get deleteAccount => 'Обриши мој налог';

  @override
  String get deleteAccountConfirmation =>
      'Ова радња је неповратна. Ваш налог и сви подаци биће обрисани у року од 30 дана.';

  @override
  String get accountDeletionRequested => 'Захтев за брисање регистрован';

  @override
  String get clearShoppingList => 'Испразни листу';

  @override
  String get clearShoppingListConfirmation =>
      'Да ли сте сигурни да желите да испразните целу листу за куповину? Ова радња се не може поништити.';

  @override
  String get nfcReaderTitle => 'NFC Reader Anycubic';

  @override
  String get historyTooltip => 'Историја';

  @override
  String get retryButton => 'Покушај поново';

  @override
  String get readSuccessMessage => 'Читање успешно!';

  @override
  String get filamentTypeLabel => 'Тип филамента';

  @override
  String get scanNfcChipButton => 'Скенирај NFC чип';

  @override
  String deleteCloneConfirmation(String name) {
    return 'Обрисати клон \"$name\"?';
  }

  @override
  String cloneDeletedMessage(String name) {
    return 'Клон \"$name\" обрисан';
  }

  @override
  String get extruderLabel => 'Екструдер';

  @override
  String get writeThisCloneButton => 'Запиши овај клон';

  @override
  String get customNameHint => 'Прилагођено име';

  @override
  String get cloneWriteSuccessMessage => 'Клон успешно записан!';

  @override
  String errorPrefix(String error) {
    return 'Грешка: $error';
  }

  @override
  String get writingInProgress => 'Писање...';

  @override
  String get writeOnCUIDButton => 'Запиши на CUID картицу';

  @override
  String get diameterLabel => 'Пречник';

  @override
  String get extruderTempLabel => 'Температура екструдера';

  @override
  String get bedTempLabel => 'Температура постоља';

  @override
  String get nfcFrequency => '13,56 MHz';

  @override
  String get nfcProtocol => 'ISO14443A';

  @override
  String get nfcCapacity => '1K бајта (1024 бајта)';

  @override
  String get rsaSignatureNote =>
      'Клон укључује оригинални RSA потпис, штампач ће га прихватити!';

  @override
  String get writeBambuLabTagTitle => 'Запиши Bambu Lab ознаку';

  @override
  String get bambuLabTagWriteSuccess => 'Bambu Lab ознака успешно записана!';

  @override
  String get approachNfcTagMessage => 'Приближите NFC ознаку...';

  @override
  String get bambuLabFormatMiFare => 'Bambu Lab формат (MiFare 13,56 MHz)';

  @override
  String get bambuLabFormat => 'Bambu Lab формат';

  @override
  String get bambuLabFormatInfo =>
      'Овај формат користи Bambu Lab кодове материјала и чува податке у AMS компатибилном формату.';

  @override
  String get brandLabel => 'Марка';

  @override
  String get materialTypeLabel => 'Тип материјала';

  @override
  String get serialNumber3Digits => 'Серијски број (3 цифре)';

  @override
  String get weight250g => '250г';

  @override
  String get weight500g => '500г';

  @override
  String get weight1000g => '1000г';

  @override
  String get weight1000gStandard => '1000г (стандард)';

  @override
  String get weight2000g => '2000г';

  @override
  String get weight3000g => '3000г';

  @override
  String get writeBambuLabTagButton => 'Запиши Bambu Lab ознаку';

  @override
  String get bambuLabRsaNote =>
      'Напомена: Оригиналне Bambu Lab ознаке користе RSA енкрипцију. Овај режим записује податке у поједностављеном компатибилном формату.';

  @override
  String signInError(String error) {
    return 'Грешка при пријави: $error';
  }

  @override
  String get subscriptionActivatedMessage => 'Претплата успешно активирана!';

  @override
  String get subscriptionFailedMessage => 'Претплата није успела';

  @override
  String errorMessage(String error) {
    return 'Грешка: $error';
  }

  @override
  String get subscriptionRestoredMessage => 'Претплата успешно обновљена!';

  @override
  String get noSubscriptionFoundMessage => 'Претплата није пронађена';

  @override
  String get vipLabel => 'VIP';

  @override
  String get activeLabel => 'АКТИВНО';

  @override
  String get noAdsExperienceMessage => 'Уживајте у искуству без реклама!';

  @override
  String get subscribedLabel => 'Претплатник';

  @override
  String get restorePurchasesButton => 'Обнови куповине';

  @override
  String get cannotExceedRemainingWeight =>
      'Не може премашити преосталу тежину';

  @override
  String get pleaseEnterLength => 'Унесите дужину';

  @override
  String get pleaseEnterValidLength => 'Унесите важећу дужину';

  @override
  String get spoolLengthNotSetCannotConvert =>
      'Дужина калема није постављена - није могуће конвертовати';

  @override
  String get exceedsRemainingWeight => 'Премашује преосталу тежину';

  @override
  String get skuLabel => 'SKU';

  @override
  String get helpIdentifyFilament =>
      'Помозите нам да идентификујемо овај филамент';

  @override
  String get helpUsImprove => 'Помозите нам да се побољшамо!';

  @override
  String get helpIdentifyDescription =>
      'Прочитали смо чип, али нисмо успели да га идентификујемо. Реците нам који је то филамент да бисмо побољшали апликацију.';

  @override
  String get otherBrand => 'Друго';

  @override
  String get thankYouFeedback => 'Хвала на повратним информацијама!';

  @override
  String get send => 'Пошаљи';

  @override
  String get optionalDetails => 'Опциони детаљи';

  @override
  String get weightGrams => 'Тежина (г)';

  @override
  String get diameterMm => 'Пречник (мм)';

  @override
  String get spoolLengthM => 'Дужина калема (м)';

  @override
  String get batchNumberLabel => 'Серија / SKU';

  @override
  String get contactUs => 'Контактирајте нас';

  @override
  String get contactUsSubtitle => 'Питања, предлози или проблеми';

  @override
  String get nfcTagNotDetected => 'NFC ознака није откривена';

  @override
  String get nfcTagNotDetectedDesc =>
      'Ознака није пронађена. Ознака је можда мртва, оштећена или предалеко од телефона.';

  @override
  String get nfcTagIncompatible => 'Откривена некомпатибилна NFC ознака';

  @override
  String get nfcAuthError => 'Аутентификација NFC ознаке није успела';

  @override
  String get nfcAuthErrorDesc =>
      'Ознака је детектована, али аутентификација није успела након неколико покушаја. Држите ознаку чврсто притиснуту на полеђину телефона и покушајте поново.';

  @override
  String get nfcTagInfoPrusa =>
      'Користите празну картицу NXP ICODE SLIX2 (ISO 15693) за прављење OpenPrintTag компатибилних ознака за Prusa MK4/XL.';

  @override
  String get writePrusaTagTitle => 'Упиши Prusa OpenPrintTag';

  @override
  String get signInAppleNotAvailable =>
      'Пријава преко Apple-а није доступна на овом уређају.';

  @override
  String get signInAppleFailed =>
      'Пријава преко Apple-а није успела. Покушајте поново.';

  @override
  String get signInFailed => 'Пријава није успела. Покушајте поново.';

  @override
  String get mustContain3Digits => 'Мора да садржи 3 цифре';

  @override
  String get mustBeNumber => 'Мора бити број';

  @override
  String generatedUidLabel(String uid) {
    return 'Генерисани UID: $uid';
  }

  @override
  String get experimentalBadge => 'ЕКСПЕРИМЕНТАЛНО';

  @override
  String get newBadge => 'НОВО';

  @override
  String get forCrealityCfs => 'за Creality CFS';

  @override
  String get crealityReadWrite => 'Creality: Читање и писање';

  @override
  String get crealityReadWriteDesc =>
      'Creality CFS ознаке користе MiFare Classic 1K са AES-128-ECB шифровањем. Читање и писање подржано само на Андроиду.';

  @override
  String get platformLimitationTitle => 'Ограничење платформе';

  @override
  String get mifareClassicNotSupportedIos =>
      'MiFare Classic ознаке (Bambu Lab, Creality) нису подржане на iOS-у због ограничења Apple CoreNFC-а. Ова функција је доступна само на Андроиду.';

  @override
  String get nfcTagInfoCreality =>
      'Користите MiFare Classic 1K ознаку за писање података компатибилних са Creality CFS за Creality K2 Plus.';

  @override
  String get colorHintExamples => 'Црвена, Плава, Црна...';

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
    return 'Тag откривен као $mode — промените картицу за следећа скенирања';
  }

  @override
  String get fallbackChooseMode => 'Изаберите режим ручно';

  @override
  String get fallbackChooseModeSubtitle =>
      'Аутоматска детекција није могла идентификовати овај таг. Изаберите протокол:';

  @override
  String get tryAutoDetect => 'Покушај аутоматско препознавање';

  @override
  String get autoDetectAllBrands => 'Аутоматско препознавање — све марке';

  @override
  String get autoDetectAllBrandsDesc =>
      'Anycubic, Elegoo, OpenSpool, OpenTag3D и више';

  @override
  String get nfcTipIos =>
      'NFC читач се налази на врху вашег iPhone-а. Поставите га директно на NFC ознаку калема.';

  @override
  String get nfcTipAndroid =>
      'NFC читач се обично налази у средини задње стране телефона. Поставите задњу страну телефона на NFC ознаку калема.';

  @override
  String get stockSortBy => 'Сортирај';

  @override
  String get stockFilter => 'Филтер';

  @override
  String get stockSortRecent => 'Најновије';

  @override
  String get stockSortBrand => 'Бренд';

  @override
  String get stockSortMaterial => 'Материјал';

  @override
  String get stockSortRemaining => 'Преостала тежина';

  @override
  String get stockSortColor => 'Боја';

  @override
  String get stockFilterAll => 'Све';

  @override
  String get stockResetFilters => 'Ресетуј';

  @override
  String get stockNoMatch => 'Ниједан калем не одговара филтерима';

  @override
  String get nfcDisabledTitle => 'NFC искључен';

  @override
  String get nfcDisabledMessage =>
      'NFC је искључен. Укључите га у подешавањима телефона да бисте скенирали калемове.';
}
