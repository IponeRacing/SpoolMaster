// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'NFC Anycubic';

  @override
  String get nfc => 'NFC';

  @override
  String get stock => '在庫';

  @override
  String get statistics => '統計';

  @override
  String get profile => 'プロフィール';

  @override
  String get readNfcChip => 'NFCチップを読む';

  @override
  String get scanHistory => '履歴';

  @override
  String get writeNfcChip => 'NFCチップに書き込む';

  @override
  String get nfcNotAvailable => 'NFCが利用できません';

  @override
  String get nfcNotAvailableDesc => 'お使いのデバイスはNFCをサポートしていないか、無効になっています。';

  @override
  String get nfcNotSupported => 'このデバイスではNFCがサポートされていません';

  @override
  String get approachNfcChip => 'NFCチップを近づけてください...';

  @override
  String get scanningNfc => 'スキャン中...';

  @override
  String get nfcDataRead => 'NFCデータの読み取りに成功しました！';

  @override
  String get errorReadingNfc => 'NFC読み取りエラー';

  @override
  String get scanHistoryTitle => 'スキャン履歴';

  @override
  String get noScansRecorded => 'スキャン記録がありません';

  @override
  String get scansWillAppearHere => 'NFCスキャンがここに自動的に表示されます';

  @override
  String get clearAll => 'すべてクリア';

  @override
  String get deleteThisScan => 'このスキャンを削除しますか？';

  @override
  String get actionIrreversible => 'この操作は元に戻せません。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get clearAllHistory => 'すべての履歴をクリアしますか？';

  @override
  String get allScansWillBeDeleted => 'すべてのスキャンが削除されます。この操作は元に戻せません。';

  @override
  String get scanDeleted => 'スキャンを削除しました';

  @override
  String get scanDetails => 'スキャン詳細';

  @override
  String scannedOn(Object date) {
    return '$dateにスキャン';
  }

  @override
  String get bobbinInformation => 'ボビン情報';

  @override
  String get filamentType => 'フィラメントタイプ';

  @override
  String get color => '色';

  @override
  String get weight => '重量';

  @override
  String get manufacturingDate => '製造日';

  @override
  String get batchNumber => 'バッチ番号';

  @override
  String get printerSettings => 'プリンター設定';

  @override
  String get scanMetadata => 'スキャンメタデータ';

  @override
  String get scanId => 'スキャンID';

  @override
  String get dateAndTime => '日時';

  @override
  String get reuseThisData => 'このデータを再利用';

  @override
  String get writeToNfc => 'NFCに書き込む';

  @override
  String get writeDataToChip => 'チップにデータを書き込む';

  @override
  String get writeSuccess => '書き込みに成功しました！';

  @override
  String get writeError => '書き込みエラー';

  @override
  String get brand => 'ブランド';

  @override
  String get selectBrand => 'ブランドを選択';

  @override
  String get materialType => '材質タイプ';

  @override
  String get selectMaterial => '材質を選択';

  @override
  String get serialNumber => 'シリアル番号';

  @override
  String get serialNumberHint => '例: 001';

  @override
  String get initialWeight => '初期重量';

  @override
  String get initialWeightHint => '例: 1000';

  @override
  String get extruderTempMin => 'エクストルーダー温度 最小';

  @override
  String get extruderTempMax => 'エクストルーダー温度 最大';

  @override
  String get bedTempMin => 'ベッド温度 最小';

  @override
  String get bedTempMax => 'ベッド温度 最大';

  @override
  String get diameter => '直径';

  @override
  String get spoolLength => '長さ (m)';

  @override
  String get generatedSku => '生成されたSKU';

  @override
  String get approachChipToWrite => '書き込むためにチップを近づけてください...';

  @override
  String get writing => '書き込み中...';

  @override
  String get chooseColor => '色を選択';

  @override
  String get required => '必須';

  @override
  String get invalid => '無効';

  @override
  String get advancedSettings => '詳細設定';

  @override
  String get opacity => '不透明度';

  @override
  String get validate => '確認';

  @override
  String get nfcTagInfo =>
      '空白のISO14443A NFCタグ（NTAG213）を使用して、独自のAnycubicタグを作成します。';

  @override
  String get stockInventory => '在庫スプール';

  @override
  String get addSpool => 'スプールを追加';

  @override
  String get scanSpool => 'スプールをスキャン';

  @override
  String get addManually => '手動で追加';

  @override
  String get spoolAdded => 'スプールを追加しました';

  @override
  String get spoolUpdated => 'スプールを更新しました';

  @override
  String get noSpoolsInStock => '在庫にスプールがありません';

  @override
  String get addFirstSpool => '最初のスプールを追加して在庫の追跡を開始します';

  @override
  String lowStockAlert(Object count, Object threshold) {
    return '$count個のスプールの在庫が少なくなっています（< $threshold%）';
  }

  @override
  String get edit => '編集';

  @override
  String get bobbinPrice => 'ボビン価格';

  @override
  String get price => '価格';

  @override
  String get priceHint => '例: 25.00';

  @override
  String get save => '保存';

  @override
  String get spoolDetails => 'スプール詳細';

  @override
  String get deleteThisSpool => 'このスプールを削除しますか？';

  @override
  String get cannotBeUndone => 'この操作は取り消せません。';

  @override
  String get addSpoolManually => '手動でスプールを追加';

  @override
  String get editSpool => 'スプールを編集';

  @override
  String get customBrand => 'カスタムブランド';

  @override
  String get customBrandHint => '例: マイブランド';

  @override
  String get chooseFromList => 'リストから選択';

  @override
  String get addBrand => '+ ブランドを追加';

  @override
  String get customMaterial => 'カスタム材質';

  @override
  String get customMaterialHint => '例: マイ材質';

  @override
  String get addMaterial => '+ 材質を追加';

  @override
  String get colorHint => '例: 青、赤...';

  @override
  String get enterColor => '色を入力してください';

  @override
  String get initialWeightG => '初期重量';

  @override
  String get remainingWeightG => '残り重量';

  @override
  String get enterBrand => 'ブランドを入力してください';

  @override
  String get selectOrEnterBrand => 'ブランドを選択または入力してください';

  @override
  String get enterMaterial => '材質を入力してください';

  @override
  String get selectOrEnterMaterial => '材質を選択または入力してください';

  @override
  String get enterPrice => '価格を入力してください';

  @override
  String get enterValidPrice => '有効な価格を入力してください';

  @override
  String get enterWeight => '重量を入力してください';

  @override
  String get enterValidWeight => '有効な重量を入力してください';

  @override
  String get remainingCannotExceedTotal => '残り重量が総重量を超えることはできません';

  @override
  String get overview => '概要';

  @override
  String get spoolsInStock => '在庫スプール';

  @override
  String get totalValue => '総額';

  @override
  String get lowStockSpools => '低在庫';

  @override
  String get materialDistribution => '材質別分布';

  @override
  String get brandDistribution => 'ブランド別分布';

  @override
  String get noData => 'データなし';

  @override
  String get refresh => '更新';

  @override
  String get profileSettings => 'プロフィール設定';

  @override
  String get preferences => '設定';

  @override
  String get language => '言語';

  @override
  String get selectLanguage => '言語を選択';

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
  String get currency => '通貨';

  @override
  String get selectCurrency => '通貨を選択';

  @override
  String get units => '単位';

  @override
  String get selectUnits => '単位を選択';

  @override
  String get metric => 'メートル法 (mm, g, °C)';

  @override
  String get imperial => 'ヤード・ポンド法 (in, oz, °F)';

  @override
  String get lowStockThreshold => '低在庫アラートしきい値';

  @override
  String get lowStockThresholdDesc => '残り重量がこの割合未満の場合、スプールは低在庫と見なされます';

  @override
  String get authentication => '認証';

  @override
  String get signInWithGoogle => 'Googleでサインイン';

  @override
  String get signInWithApple => 'Appleでサインイン';

  @override
  String get comingSoon => '近日公開';

  @override
  String get about => 'について';

  @override
  String get version => 'バージョン';

  @override
  String get madeWith => 'Anycubic 3Dプリンター用に❤️で作成';

  @override
  String get scanBobbinDirectly => 'ボビンをスキャン';

  @override
  String get nfcEncoder => 'NFCエンコーダー';

  @override
  String get length => '長さ';

  @override
  String get tempExtruder => 'エクストルーダー温度';

  @override
  String get tempBed => 'ベッド温度';

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get legal => 'Legal';

  @override
  String get back => '戻る';

  @override
  String get retry => '再試行';

  @override
  String get signOut => 'サインアウト';

  @override
  String get extruderTempMinHint => '例: 200';

  @override
  String get extruderTempMaxHint => '例: 220';

  @override
  String get bedTempMinHint => '例: 50';

  @override
  String get bedTempMaxHint => '例: 60';

  @override
  String get diameterHint => '例: 1.75';

  @override
  String get spoolLengthHint => '例: 330';

  @override
  String get tabGrid => 'グリッド';

  @override
  String get tabSpectrum => 'スペクトル';

  @override
  String get tabSliders => 'スライダー';

  @override
  String get hexCode => '16進コード';

  @override
  String get red => '赤';

  @override
  String get green => '緑';

  @override
  String get blue => '青';

  @override
  String get metricUnits => 'メートル法 (mm, g, °C)';

  @override
  String get imperialUnits => 'ヤード・ポンド法 (in, oz, °F)';

  @override
  String get chf => 'スイスフラン (CHF)';

  @override
  String get eur => 'ユーロ (€)';

  @override
  String get usd => '米ドル (\$)';

  @override
  String get gbp => '英ポンド (£)';

  @override
  String get cad => 'カナダドル (CAD)';

  @override
  String get filamentsToOrder => '注文するフィラメント';

  @override
  String get shoppingList => 'ショッピングリスト';

  @override
  String get addToShoppingList => 'リストに追加';

  @override
  String get noLowStockFilaments => '在庫不足のフィラメントはありません';

  @override
  String get vipSubscriptionDescription =>
      'このサブスクリプションは、アプリ内広告を無効にし、プロジェクトをサポートするためのものです。他の機能はありません。';

  @override
  String get monthlySubscription => '月間サブスクリプション';

  @override
  String get yearlySubscription => '年間サブスクリプション';

  @override
  String get perMonth => '/ 月';

  @override
  String get perYear => '/ 年';

  @override
  String onlyPerMonth(String price) {
    return 'わずか$price / 月';
  }

  @override
  String get subscribe => 'サブスクライブ';

  @override
  String get bestOffer => '✨ ベストオファー ✨';

  @override
  String get forAnycubicAce => 'Anycubic Ace用';

  @override
  String get forBambuLabAms => 'Bambu Lab AMS用';

  @override
  String get scanNfcChip => 'NFCチップをスキャン';

  @override
  String get fillForm => 'フォームに記入';

  @override
  String get emptyShoppingList => 'リストにフィラメントがありません';

  @override
  String percentRemaining(String percent) {
    return '残り$percent%';
  }

  @override
  String get markAsOrdered => '注文済みとしてマーク';

  @override
  String get markAsNotOrdered => '未注文としてマーク';

  @override
  String get notSignedIn => 'サインインしていません';

  @override
  String get signIn => 'サインイン';

  @override
  String get connection => 'ログイン';

  @override
  String get signInToSync => 'データを同期するにはサインインしてください';

  @override
  String get continueWithoutAccount => 'アカウントなしで続行（ローカルモード）';

  @override
  String get privacyNotice => 'サインインすることで、当社の\n利用規約とプライバシーポリシーに同意したことになります';

  @override
  String get updateStock => '在庫を更新';

  @override
  String get scanToUpdateStock => 'スキャンして更新';

  @override
  String get weightUsed => '使用した重量';

  @override
  String get lengthUsed => '使用した長さ';

  @override
  String get enterWeightOrLength => '使用した重量または長さを入力';

  @override
  String get weightUsedG => '使用した重量 (g)';

  @override
  String get lengthUsedM => '使用した長さ (m)';

  @override
  String get stockUpdated => '在庫が更新されました';

  @override
  String get scanSpoolToUpdate => 'スプールをスキャンして在庫を更新';

  @override
  String get spoolNotFound => '在庫にスプールが見つかりません';

  @override
  String get addSpoolFirstMessage =>
      'このスプールはまだ在庫にありません。在庫を更新する前に、「スプールを追加」ボタンを使用して最初に追加してください。';

  @override
  String get ok => 'OK';

  @override
  String get bambuLabReadOnly => 'Bambu Lab: 読み取り専用';

  @override
  String get bambuLabReadOnlyDesc =>
      'Bambu LabタグはRSA暗号化を使用しており、変更できません。読み取り専用です。';

  @override
  String get bambuCloneLibrary => 'Bambu Labクローンライブラリ';

  @override
  String get noBambuClones => 'Bambu Labクローンがありません';

  @override
  String get scanBambuToClone => 'Bambu Lab純正タグをスキャンしてクローンライブラリを作成';

  @override
  String get scanTag => 'タグをスキャン';

  @override
  String get syncWithCloud => 'クラウドと同期';

  @override
  String get syncCompleted => '同期が完了しました';

  @override
  String get deleteClone => 'クローンを削除';

  @override
  String get renameClone => 'クローンの名前を変更';

  @override
  String get rename => '名前を変更';

  @override
  String get customName => 'カスタム名';

  @override
  String get clonedOn => 'クローン作成日';

  @override
  String get writeThisClone => 'このクローンを書き込む';

  @override
  String get writeClone => 'クローンを書き込む';

  @override
  String get writeOnCUID => 'CUIDカードに書き込む';

  @override
  String get cloneWrittenSuccess => 'クローンの書き込みに成功しました！';

  @override
  String get requiredTagFormat => '必要なタグ形式';

  @override
  String get type => 'タイプ';

  @override
  String get frequency => '周波数';

  @override
  String get protocol => 'プロトコル';

  @override
  String get capacity => '容量';

  @override
  String get feature => '機能';

  @override
  String get uidModifiable => 'ブロック0（UID）変更可能';

  @override
  String get whereToBuy =>
      'AliExpress、Amazon、eBayで「CUID MiFare Classic 1K」を検索（約0.50ドル/枚）';

  @override
  String get magicGen2Required =>
      'Magic Gen2カード - 書き込み可能なBlock 0 (UID)を持つMiFare Classic 1K';

  @override
  String get magicGen2CardType => 'Magic Gen2 (MiFare Classic 1K)';

  @override
  String get magicGen2Where =>
      'AliExpress、Amazon、eBayで「Magic Gen2 MiFare Classic 1K」または「UID writable」を検索してください（約\$0.50/枚）';

  @override
  String get iphoneWriteDisclaimer =>
      '⚠️ 警告：iPhone NFCでの書き込みは、すべてのMagic Gen2カードで機能しない可能性があります。信頼性のため、NFC Tools Proアプリを使用したAndroidまたはProxmark3デバイスを推奨します。';

  @override
  String get step1GetMagicGen2 =>
      '空白のMagic Gen2カード（書き込み可能なUIDを持つMiFare Classic 1K）を入手してください';

  @override
  String get instructions => '手順';

  @override
  String get step1GetCUID => '空白のCUIDカード（MiFare Classic 1K）を入手';

  @override
  String get step2PressWrite => '下の「書き込む」ボタンを押す';

  @override
  String get step3HoldPhone => 'iPhoneをCUIDカードの近くに置く';

  @override
  String get step4WaitConfirm => '書き込み確認を待つ';

  @override
  String get step5TestClone => 'Bambu Labプリンターでクローンタグをテスト！';

  @override
  String get rsaIncluded => 'クローンには元のRSA署名が含まれているため、プリンターに受け入れられます！';

  @override
  String get cloneDeleted => 'クローンが削除されました';
}
