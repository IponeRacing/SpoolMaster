// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => '재고';

  @override
  String get statistics => '통계';

  @override
  String get profile => '프로필';

  @override
  String get readNfcChip => 'NFC 칩 읽기';

  @override
  String get scanHistory => '기록';

  @override
  String get writeNfcChip => 'NFC 칩 쓰기';

  @override
  String get nfcNotAvailable => 'NFC를 사용할 수 없습니다';

  @override
  String get nfcNotAvailableDesc => '기기가 NFC를 지원하지 않거나 비활성화되어 있습니다.';

  @override
  String get nfcNotSupported => '이 기기에서 NFC가 지원되지 않습니다';

  @override
  String get approachNfcChip => 'NFC 칩을 가까이 대세요...';

  @override
  String get scanningNfc => '스캔 중...';

  @override
  String get nfcDataRead => 'NFC 데이터를 성공적으로 읽었습니다!';

  @override
  String get errorReadingNfc => 'NFC 읽기 오류';

  @override
  String get scanHistoryTitle => '스캔 기록';

  @override
  String get noScansRecorded => '기록된 스캔이 없습니다';

  @override
  String get scansWillAppearHere => 'NFC 스캔이 여기에 자동으로 표시됩니다';

  @override
  String get clearAll => '모두 지우기';

  @override
  String get deleteThisScan => '이 스캔을 삭제하시겠습니까?';

  @override
  String get actionIrreversible => '이 작업은 되돌릴 수 없습니다.';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get clearAllHistory => '모든 기록을 지우시겠습니까?';

  @override
  String get allScansWillBeDeleted => '모든 스캔이 삭제됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get scanDeleted => '스캔이 삭제되었습니다';

  @override
  String get scanDetails => '스캔 세부정보';

  @override
  String scannedOn(Object date) {
    return '$date에 스캔됨';
  }

  @override
  String get bobbinInformation => '보빈 정보';

  @override
  String get filamentType => '필라멘트 유형';

  @override
  String get color => '색상';

  @override
  String get weight => '무게';

  @override
  String get manufacturingDate => '제조 날짜';

  @override
  String get batchNumber => '배치 번호';

  @override
  String get printerSettings => '프린터 설정';

  @override
  String get scanMetadata => '스캔 메타데이터';

  @override
  String get scanId => '스캔 ID';

  @override
  String get dateAndTime => '날짜 및 시간';

  @override
  String get reuseThisData => '이 데이터 재사용';

  @override
  String get writeToNfc => 'NFC에 쓰기';

  @override
  String get writeDataToChip => '칩에 데이터 쓰기';

  @override
  String get writeSuccess => '쓰기 성공!';

  @override
  String get writeError => '쓰기 오류';

  @override
  String get brand => '브랜드';

  @override
  String get selectBrand => '브랜드 선택';

  @override
  String get materialType => '재료 유형';

  @override
  String get selectMaterial => '재료 선택';

  @override
  String get serialNumber => '일련번호';

  @override
  String get serialNumberHint => '예: 001';

  @override
  String get initialWeight => '초기 무게';

  @override
  String get initialWeightHint => '예: 1000';

  @override
  String get extruderTempMin => '압출기 온도 최소';

  @override
  String get extruderTempMax => '압출기 온도 최대';

  @override
  String get bedTempMin => '베드 온도 최소';

  @override
  String get bedTempMax => '베드 온도 최대';

  @override
  String get diameter => '직경';

  @override
  String get spoolLength => '길이 (m)';

  @override
  String get generatedSku => '생성된 SKU';

  @override
  String get approachChipToWrite => '쓰기를 위해 칩을 가까이 대세요...';

  @override
  String get writing => '쓰는 중...';

  @override
  String get chooseColor => '색상 선택';

  @override
  String get required => '필수';

  @override
  String get invalid => '유효하지 않음';

  @override
  String get advancedSettings => '고급 설정';

  @override
  String get opacity => '불투명도';

  @override
  String get validate => '확인';

  @override
  String get nfcTagInfo =>
      '빈 ISO14443A NFC 태그(NTAG213)를 사용하여 자체 Anycubic 태그를 만드세요.';

  @override
  String get stockInventory => '재고 스풀';

  @override
  String get addSpool => '스풀 추가';

  @override
  String get scanSpool => '스풀 스캔';

  @override
  String get addManually => '수동으로 추가';

  @override
  String get spoolAdded => '스풀이 추가되었습니다';

  @override
  String get spoolUpdated => '스풀이 업데이트되었습니다';

  @override
  String get noSpoolsInStock => '재고에 스풀이 없습니다';

  @override
  String get addFirstSpool => '첫 번째 스풀을 추가하여 재고 추적을 시작하세요';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count개의 스풀이 재고 부족 상태입니다 (< $threshold%)';
  }

  @override
  String get edit => '편집';

  @override
  String get bobbinPrice => '보빈 가격';

  @override
  String get price => '가격';

  @override
  String get priceHint => '예: 25.00';

  @override
  String get save => '저장';

  @override
  String get spoolDetails => '스풀 세부정보';

  @override
  String get deleteThisSpool => '이 스풀을 삭제하시겠습니까?';

  @override
  String get cannotBeUndone => '이 작업은 취소할 수 없습니다.';

  @override
  String get addSpoolManually => '수동으로 스풀 추가';

  @override
  String get editSpool => '스풀 편집';

  @override
  String get customBrand => '사용자 정의 브랜드';

  @override
  String get customBrandHint => '예: 내 브랜드';

  @override
  String get chooseFromList => '목록에서 선택';

  @override
  String get addBrand => '+ 브랜드 추가';

  @override
  String get customMaterial => '사용자 정의 재료';

  @override
  String get customMaterialHint => '예: 내 재료';

  @override
  String get addMaterial => '+ 재료 추가';

  @override
  String get colorHint => '예: 파란색, 빨간색...';

  @override
  String get enterColor => '색상을 입력하세요';

  @override
  String get initialWeightG => '초기 무게';

  @override
  String get remainingWeightG => '남은 무게';

  @override
  String get enterBrand => '브랜드를 입력하세요';

  @override
  String get selectOrEnterBrand => '브랜드를 선택하거나 입력하세요';

  @override
  String get enterMaterial => '재료를 입력하세요';

  @override
  String get selectOrEnterMaterial => '재료를 선택하거나 입력하세요';

  @override
  String get enterPrice => '가격을 입력하세요';

  @override
  String get enterValidPrice => '유효한 가격을 입력하세요';

  @override
  String get enterWeight => '무게를 입력하세요';

  @override
  String get enterValidWeight => '유효한 무게를 입력하세요';

  @override
  String get remainingCannotExceedTotal => '남은 무게가 총 무게를 초과할 수 없습니다';

  @override
  String get overview => '개요';

  @override
  String get spoolsInStock => '재고 스풀';

  @override
  String get totalValue => '총 가치';

  @override
  String get lowStockSpools => '재고 부족';

  @override
  String get materialDistribution => '재료별 분포';

  @override
  String get brandDistribution => '브랜드별 분포';

  @override
  String get noData => '데이터 없음';

  @override
  String get refresh => '새로 고침';

  @override
  String get profileSettings => '프로필 설정';

  @override
  String get preferences => '환경설정';

  @override
  String get language => '언어';

  @override
  String get selectLanguage => '언어 선택';

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
  String get currency => '통화';

  @override
  String get selectCurrency => '통화 선택';

  @override
  String get units => '단위';

  @override
  String get selectUnits => '단위 선택';

  @override
  String get metric => '미터법 (mm, g, °C)';

  @override
  String get imperial => '야드파운드법 (in, oz, °F)';

  @override
  String get lowStockThreshold => '재고 부족 경고 임계값';

  @override
  String get lowStockThresholdDesc => '남은 무게가 이 백분율보다 적으면 스풀이 재고 부족으로 간주됩니다';

  @override
  String get authentication => '인증';

  @override
  String get signInWithGoogle => 'Google로 로그인';

  @override
  String get signInWithApple => 'Apple로 로그인';

  @override
  String get comingSoon => '곧 출시';

  @override
  String get about => '정보';

  @override
  String get version => '버전';

  @override
  String get madeWith => 'Anycubic 3D 프린터를 위해 ❤️로 제작';

  @override
  String get scanBobbinDirectly => '보빈 스캔';

  @override
  String get nfcEncoder => 'NFC 인코더';

  @override
  String get length => '길이';

  @override
  String get tempExtruder => '압출기 온도';

  @override
  String get tempBed => '베드 온도';

  @override
  String get termsOfService => '서비스 약관';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get legal => 'Legal';

  @override
  String get back => '뒤로';

  @override
  String get retry => '다시 시도';

  @override
  String get signOut => '로그아웃';

  @override
  String get extruderTempMinHint => '예: 200';

  @override
  String get extruderTempMaxHint => '예: 220';

  @override
  String get bedTempMinHint => '예: 50';

  @override
  String get bedTempMaxHint => '예: 60';

  @override
  String get diameterHint => '예: 1.75';

  @override
  String get spoolLengthHint => '예: 330';

  @override
  String get tabGrid => '그리드';

  @override
  String get tabSpectrum => '스펙트럼';

  @override
  String get tabSliders => '슬라이더';

  @override
  String get hexCode => '16진수 코드';

  @override
  String get red => '빨강';

  @override
  String get green => '초록';

  @override
  String get blue => '파랑';

  @override
  String get metricUnits => '미터법 (mm, g, °C)';

  @override
  String get imperialUnits => '야드파운드법 (in, oz, °F)';

  @override
  String get chf => '스위스 프랑 (CHF)';

  @override
  String get eur => '유로 (€)';

  @override
  String get usd => '미국 달러 (\$)';

  @override
  String get gbp => '영국 파운드 (£)';

  @override
  String get cad => '캐나다 달러 (CAD)';

  @override
  String get filamentsToOrder => '주문할 필라멘트';

  @override
  String get shoppingList => '쇼핑 목록';

  @override
  String get addToShoppingList => '목록에 추가';

  @override
  String get noLowStockFilaments => '재고 부족 필라멘트 없음';

  @override
  String get vipSubscriptionDescription =>
      '이 구독은 앱 내 광고를 비활성화하고 프로젝트를 지원하는 용도로만 사용됩니다. 다른 기능은 없습니다.';

  @override
  String get monthlySubscription => '월간 구독';

  @override
  String get yearlySubscription => '연간 구독';

  @override
  String get perMonth => '/ 월';

  @override
  String get perYear => '/ 년';

  @override
  String onlyPerMonth(String price) {
    return '단 $price / 월';
  }

  @override
  String get subscribe => '구독';

  @override
  String get bestOffer => '✨ 최고의 제안 ✨';

  @override
  String get forAnycubicAce => 'Anycubic Ace용';

  @override
  String get forBambuLabAms => 'Bambu Lab AMS용';

  @override
  String get scanNfcChip => 'NFC 칩 스캔';

  @override
  String get fillForm => '양식 작성';

  @override
  String get emptyShoppingList => '목록에 필라멘트 없음';

  @override
  String percentRemaining(String percent) {
    return '$percent% 남음';
  }

  @override
  String get markAsOrdered => '주문됨으로 표시';

  @override
  String get markAsNotOrdered => '주문 안됨으로 표시';

  @override
  String get notSignedIn => '로그인하지 않음';

  @override
  String get signIn => '로그인';

  @override
  String get connection => '로그인';

  @override
  String get signInToSync => '데이터를 동기화하려면 로그인하세요';

  @override
  String get continueWithoutAccount => '계정 없이 계속 (로컬 모드)';

  @override
  String get privacyNotice => '로그인하면 당사의\n이용 약관 및 개인정보 보호정책에 동의하는 것입니다';

  @override
  String get updateStock => '재고 업데이트';

  @override
  String get scanToUpdateStock => '업데이트를 위해 스캔';

  @override
  String get weightUsed => '사용한 무게';

  @override
  String get lengthUsed => '사용한 길이';

  @override
  String get enterWeightOrLength => '사용한 무게 또는 길이 입력';

  @override
  String get weightUsedG => '사용한 무게 (g)';

  @override
  String get lengthUsedM => '사용한 길이 (m)';

  @override
  String get stockUpdated => '재고가 업데이트됨';

  @override
  String get scanSpoolToUpdate => '재고를 업데이트하려면 스풀을 스캔하세요';

  @override
  String get spoolNotFound => '재고에서 스풀을 찾을 수 없습니다';

  @override
  String get addSpoolFirstMessage =>
      '이 스풀은 아직 재고에 없습니다. 재고를 업데이트하기 전에 \'스풀 추가\' 버튼을 사용하여 먼저 추가하세요.';

  @override
  String get ok => '확인';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: 읽기 전용';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu Lab 태그는 RSA 암호화를 사용하며 수정할 수 없습니다. 읽기 전용입니다.';

  @override
  String get bambuCloneLibrary => 'Bambu Lab 클론 라이브러리';

  @override
  String get noBambuClones => 'Bambu Lab 클론 없음';

  @override
  String get scanBambuToClone => 'Bambu Lab 정품 태그를 스캔하여 클론 라이브러리 생성';

  @override
  String get scanTag => '태그 스캔';

  @override
  String get syncWithCloud => '클라우드와 동기화';

  @override
  String get syncCompleted => '동기화 완료';

  @override
  String get deleteClone => '클론 삭제';

  @override
  String get renameClone => '클론 이름 변경';

  @override
  String get rename => '이름 변경';

  @override
  String get customName => '사용자 정의 이름';

  @override
  String get clonedOn => '클론 생성일';

  @override
  String get writeThisClone => '이 클론 쓰기';

  @override
  String get writeClone => '클론 쓰기';

  @override
  String get writeOnCUID => 'CUID 카드에 쓰기';

  @override
  String get cloneWrittenSuccess => '클론이 성공적으로 작성되었습니다!';

  @override
  String get requiredTagFormat => '필요한 태그 형식';

  @override
  String get type => '유형';

  @override
  String get frequency => '주파수';

  @override
  String get protocol => '프로토콜';

  @override
  String get capacity => '용량';

  @override
  String get feature => '기능';

  @override
  String get uidModifiable => '블록 0 (UID) 수정 가능';

  @override
  String get whereToBuy =>
      'AliExpress, Amazon 또는 eBay에서 \"CUID MiFare Classic 1K\" 검색 (~\$0.50/개)';

  @override
  String get magicGen2Required =>
      'Magic Gen2 카드 - 쓰기 가능한 Block 0 (UID)이 있는 MiFare Classic 1K';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'AliExpress, Amazon 또는 eBay에서 \"Magic Gen2 MiFare Classic 1K\" 또는 \"UID writable\" 검색 (~\$0.50/개)';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ 경고: iPhone NFC로 쓰기는 모든 Magic Gen2 카드에서 작동하지 않을 수 있습니다. 안정성을 위해 NFC Tools Pro 앱이 있는 Android 또는 Proxmark3 장치를 권장합니다.';

  @override
  String get step1GetMagicGen2 =>
      '빈 Magic Gen2 카드 (쓰기 가능한 UID가 있는 MiFare Classic 1K) 구입';

  @override
  String get instructions => '지침';

  @override
  String get step1GetCUID => '빈 CUID 카드 구하기 (MiFare Classic 1K)';

  @override
  String get step2PressWrite => '아래 \"쓰기\" 버튼 누르기';

  @override
  String get step3HoldPhone => 'iPhone을 CUID 카드 가까이 대기';

  @override
  String get step4WaitConfirm => '쓰기 확인 대기';

  @override
  String get step5TestClone => 'Bambu Lab 프린터에서 복제된 태그 테스트!';

  @override
  String get rsaIncluded => '클론에는 원래 RSA 서명이 포함되어 있어 프린터에서 수락됩니다!';

  @override
  String get cloneDeleted => '클론이 삭제되었습니다';
}
