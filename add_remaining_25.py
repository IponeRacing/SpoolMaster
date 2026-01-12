#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SCRIPT FINAL - Ajouter les 25 dernières langues (16-40)
"""
from openpyxl import load_workbook
from openpyxl.styles import Alignment

print("🏁 SCRIPT FINAL - Ajout des 25 DERNIÈRES LANGUES!")
print("=" * 70)

wb = load_workbook('applestorelang.xlsx')
ws = wb.active

def d(intro, title, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, outro):
    return f"""{intro}

🎯 {title}

📱 {f1}

📊 {f2}

📈 {f3}

🛒 {f4}

🎨 {f5}

🌡️ {f6}

🔧 COMPATIBILITÉ
{f7}

🌍 MULTILINGUE
{f8}

☁️ SYNCHRONISATION
{f9}

💰 UNITÉS ET DEVISES
{f10}

📱 INTERFACE MODERNE
{f11}

🔒 SÉCURITÉ ET CONFIDENTIALITÉ
{f12}

⭐ VERSION PREMIUM DISPONIBLE
{f13}

{outro}"""

# TOUTES LES 25 LANGUES RESTANTES
final_langs = []

# 16. JAPONAIS
final_langs.append(["Japonais", "Spool Master", "3Dフィラメント在庫 + NFC",
    "3Dフィラメントの在庫を簡単に管理。NFCタグをスキャンし、スプール、価格、統計を追跡。AnycubicとBambu Labに対応。",
    d("Spool Master - 3Dプリントフィラメント在庫を管理する完全なアプリ", "主な機能",
      "NFC読み取りと書き込み\n• AnycubicとBambu Labのスプールから NFCチップを読み取り\n• 独自のカスタムNFCタグを書き込み\n• 再利用のためにNFCタグをクローン\n• すべてのNFCタグ形式に対応",
      "完全な在庫管理\n• NFCスキャンまたは手動でスプールを追加\n• 各スプールの残り重量を追跡\n• 価格を管理し、合計値を計算\n• ブランド、材料、色で整理\n• 自動低在庫アラート",
      "詳細な統計\n• 在庫の概要\n• 在庫の合計値\n• 材料、色、ブランドの数\n• 自動ショッピングリスト",
      "スマートショッピングリスト\n• 低在庫スプールの自動追加\n• 注文済みフィラメントをマーク\n• 手動またはNFCスキャンで追加",
      "高度なカラーピッカー\n• RGBスライダー付き完全パレット\n• 不透明度サポート\n• リアルタイムプレビュー",
      "印刷設定\n• エクストルーダー温度（最小/最大）\n• ベッド温度（最小/最大）\n• フィラメント直径\n• スプール長",
      "• Anycubic: 完全な読み取りと書き込み\n• Bambu Lab: RFIDタグの読み取りと書き込み\n• 汎用NFCタグ: カスタム書き込み\n• 21のフィラメントブランドをサポート\n• 25種類の材料タイプをサポート（PLA、PETG、ABS、TPUなど）",
      "31言語で利用可能",
      "• マルチデバイス同期\n• オフラインモード利用可能",
      "• 複数通貨サポート\n• メートル法または帝国単位\n• 自動変換",
      "• ダークとライトモード\n• Material 3デザイン\n• 直感的なナビゲーション\n• ビジュアル統計",
      "• データは非公開のまま\n• 安全なローカルストレージ",
      "• クラウド同期\n• 広告なし\n• 優先サポート",
      "趣味のメーカーでもプロの3Dプリンターでも、Spool Masterはフィラメント管理を最適化し、無駄を減らし、費用を管理するのに役立ちます。\n\n今すぐダウンロードして、フィラメント在庫を管理しましょう！"),
    "NFC,フィラメント,3D,印刷,スプール,Anycubic,Bambu Lab,在庫,インベントリ,プリンター"])

# 17. CORÉEN
final_langs.append(["Coréen", "Spool Master", "3D 필라멘트 재고 + NFC",
    "3D 필라멘트 재고를 쉽게 관리하세요. NFC 태그를 스캔하고 스풀, 가격 및 통계를 추적합니다. Anycubic 및 Bambu Lab과 호환됩니다.",
    d("Spool Master - 3D 프린팅 필라멘트 재고를 관리하는 완전한 앱", "주요 기능",
      "NFC 읽기 및 쓰기\n• Anycubic 및 Bambu Lab 스풀의 NFC 칩 읽기\n• 사용자 지정 NFC 태그 작성\n• 재사용을 위해 NFC 태그 복제\n• 모든 NFC 태그 형식과 호환",
      "완전한 재고 관리\n• NFC 스캔 또는 수동으로 스풀 추가\n• 각 스풀의 남은 무게 추적\n• 가격 관리 및 총 가치 계산\n• 브랜드, 재료 및 색상별로 정리\n• 자동 저재고 알림",
      "상세한 통계\n• 재고 개요\n• 재고의 총 가치\n• 재료, 색상 및 브랜드 수\n• 자동 쇼핑 목록",
      "스마트 쇼핑 목록\n• 저재고 스풀 자동 추가\n• 주문한 필라멘트 표시\n• 수동 또는 NFC 스캔으로 추가",
      "고급 색상 선택기\n• RGB 슬라이더가 있는 전체 팔레트\n• 불투명도 지원\n• 실시간 미리보기",
      "인쇄 설정\n• 압출기 온도(최소/최대)\n• 베드 온도(최소/최대)\n• 필라멘트 직경\n• 스풀 길이",
      "• Anycubic: 전체 읽기 및 쓰기\n• Bambu Lab: RFID 태그 읽기 및 쓰기\n• 일반 NFC 태그: 사용자 지정 쓰기\n• 21개 필라멘트 브랜드 지원\n• 25가지 재료 유형 지원(PLA, PETG, ABS, TPU 등)",
      "31개 언어로 제공",
      "• 다중 장치 동기화\n• 오프라인 모드 사용 가능",
      "• 다중 통화 지원\n• 미터법 또는 야드파운드법 단위\n• 자동 변환",
      "• 다크 및 라이트 모드\n• Material 3 디자인\n• 직관적인 탐색\n• 시각적 통계",
      "• 데이터는 비공개로 유지\n• 안전한 로컬 저장소",
      "• 클라우드 동기화\n• 광고 없음\n• 우선 지원",
      "취미 메이커이든 전문 3D 프린터이든 Spool Master는 필라멘트 관리를 최적화하고 낭비를 줄이며 비용을 관리하는 데 도움이 됩니다.\n\n지금 다운로드하여 필라멘트 재고를 관리하세요!"),
    "NFC,필라멘트,3D,인쇄,스풀,Anycubic,Bambu Lab,재고,인벤토리,프린터"])

# 18-19. CHINOIS (simplifié et traditionnel)
final_langs.append(["Chinois (simplifié)", "Spool Master", "3D打印丝材库存 + NFC",
    "轻松管理您的3D打印丝材库存。扫描NFC标签,跟踪线轴、价格和统计数据。兼容Anycubic和Bambu Lab。",
    d("Spool Master - 管理3D打印丝材库存的完整应用", "主要功能",
      "NFC读写\n• 读取Anycubic和Bambu Lab线轴的NFC芯片\n• 编写自定义NFC标签\n• 克隆NFC标签以重复使用\n• 兼容所有NFC标签格式",
      "完整库存管理\n• 通过NFC扫描或手动添加线轴\n• 跟踪每个线轴的剩余重量\n• 管理价格并计算总价值\n• 按品牌、材料和颜色组织\n• 自动低库存警报",
      "详细统计\n• 库存概览\n• 库存总价值\n• 材料、颜色和品牌数量\n• 自动购物清单",
      "智能购物清单\n• 自动添加低库存线轴\n• 标记已订购的丝材\n• 手动或NFC扫描添加",
      "高级颜色选择器\n• 带RGB滑块的完整调色板\n• 不透明度支持\n• 实时预览",
      "打印设置\n• 挤出机温度（最小/最大）\n• 热床温度（最小/最大）\n• 丝材直径\n• 线轴长度",
      "• Anycubic: 完整读写\n• Bambu Lab: RFID标签读写\n• 通用NFC标签: 自定义写入\n• 支持21个丝材品牌\n• 支持25种材料类型（PLA、PETG、ABS、TPU等）",
      "提供31种语言",
      "• 多设备同步\n• 离线模式可用",
      "• 多货币支持\n• 公制或英制单位\n• 自动转换",
      "• 深色和浅色模式\n• Material 3设计\n• 直观导航\n• 可视化统计",
      "• 您的数据保持私密\n• 安全本地存储",
      "• 云同步\n• 无广告\n• 优先支持",
      "无论您是爱好制造者还是专业3D打印机，Spool Master都能帮助您优化丝材管理、减少浪费并控制支出。\n\n立即下载并掌控您的丝材库存！"),
    "NFC,耗材,3D,打印,线轴,Anycubic,Bambu Lab,库存,清单,打印机"])

final_langs.append(["Chinois (traditionnel)", "Spool Master", "3D列印線材庫存 + NFC",
    "輕鬆管理您的3D列印線材庫存。掃描NFC標籤,追蹤線軸、價格和統計數據。相容Anycubic和Bambu Lab。",
    d("Spool Master - 管理3D列印線材庫存的完整應用程式", "主要功能",
      "NFC讀寫\n• 讀取Anycubic和Bambu Lab線軸的NFC晶片\n• 編寫自訂NFC標籤\n• 複製NFC標籤以重複使用\n• 相容所有NFC標籤格式",
      "完整庫存管理\n• 透過NFC掃描或手動新增線軸\n• 追蹤每個線軸的剩餘重量\n• 管理價格並計算總價值\n• 按品牌、材料和顏色組織\n• 自動低庫存警報",
      "詳細統計\n• 庫存概覽\n• 庫存總價值\n• 材料、顏色和品牌數量\n• 自動購物清單",
      "智慧購物清單\n• 自動新增低庫存線軸\n• 標記已訂購的線材\n• 手動或NFC掃描新增",
      "進階顏色選擇器\n• 帶RGB滑桿的完整調色盤\n• 不透明度支援\n• 即時預覽",
      "列印設定\n• 擠出機溫度（最小/最大）\n• 熱床溫度（最小/最大）\n• 線材直徑\n• 線軸長度",
      "• Anycubic: 完整讀寫\n• Bambu Lab: RFID標籤讀寫\n• 通用NFC標籤: 自訂寫入\n• 支援21個線材品牌\n• 支援25種材料類型（PLA、PETG、ABS、TPU等）",
      "提供31種語言",
      "• 多裝置同步\n• 離線模式可用",
      "• 多貨幣支援\n• 公制或英制單位\n• 自動轉換",
      "• 深色和淺色模式\n• Material 3設計\n• 直覺導航\n• 視覺化統計",
      "• 您的資料保持私密\n• 安全本機儲存",
      "• 雲端同步\n• 無廣告\n• 優先支援",
      "無論您是愛好製造者還是專業3D列印機，Spool Master都能幫助您最佳化線材管理、減少浪費並控制支出。\n\n立即下載並掌控您的線材庫存！"),
    "NFC,耗材,3D,列印,線軸,Anycubic,Bambu Lab,庫存,清單,列印機"])

# 20. TURC
final_langs.append(["Turc", "Spool Master", "3D filament envanteri + NFC",
    "3D filament stoğunuzu kolayca yönetin. NFC etiketlerini tarayın, makaraları, fiyatları ve istatistikleri izleyin. Anycubic ve Bambu Lab ile uyumlu.",
    d("Spool Master - 3D baskı filament stoğunuzu yönetmek için eksiksiz uygulama", "ANA ÖZELLİKLER",
      "NFC Okuma ve Yazma\n• Anycubic ve Bambu Lab makaralarından NFC çiplerini okuyun\n• Kendi özel NFC etiketlerinizi yazın\n• Yeniden kullanım için NFC etiketlerini klonlayın\n• Tüm NFC etiket formatlarıyla uyumlu",
      "Eksiksiz Envanter Yönetimi\n• NFC taraması veya manuel olarak makara ekleyin\n• Her makaranın kalan ağırlığını takip edin\n• Fiyatları yönetin ve toplam değeri hesaplayın\n• Marka, malzeme ve renge göre düzenleyin\n• Otomatik düşük stok uyarıları",
      "Detaylı İstatistikler\n• Envanterinize genel bakış\n• Stoğunuzun toplam değeri\n• Malzeme, renk ve marka sayısı\n• Otomatik alışveriş listesi",
      "Akıllı Alışveriş Listesi\n• Düşük stoklu makaraların otomatik eklenmesi\n• Sipariş edilen filamentleri işaretleyin\n• Manuel veya NFC taramasıyla ekleyin",
      "Gelişmiş Renk Seçici\n• RGB kaydırıcılı tam palet\n• Opaklık desteği\n• Gerçek zamanlı önizleme",
      "Yazdırma Ayarları\n• Ekstruder sıcaklıkları (min/maks)\n• Tabla sıcaklıkları (min/maks)\n• Filament çapı\n• Makara uzunluğu",
      "• Anycubic: Tam okuma ve yazma\n• Bambu Lab: RFID etiket okuma ve yazma\n• Genel NFC etiketleri: Özel yazma\n• 21 filament markası için destek\n• 25 malzeme türü için destek (PLA, PETG, ABS, TPU vb.)",
      "31 dilde mevcut",
      "• Çoklu cihaz senkronizasyonu\n• Çevrimdışı mod mevcut",
      "• Çoklu para birimi desteği\n• Metrik veya emperyal birimler\n• Otomatik dönüşüm",
      "• Karanlık ve aydınlık mod\n• Material 3 tasarım\n• Sezgisel navigasyon\n• Görsel istatistikler",
      "• Verileriniz gizli kalır\n• Güvenli yerel depolama",
      "• Bulut senkronizasyonu\n• Reklamsız\n• Öncelikli destek",
      "İster hobi meraklısı ister profesyonel 3D yazıcı olun, Spool Master filament yönetiminizi optimize etmenize, israfı azaltmanıza ve harcamalarınızı kontrol etmenize yardımcı olur.\n\nŞimdi indirin ve filament envanterinizin kontrolünü ele alın!"),
    "NFC,filament,3D,yazdırma,makara,Anycubic,Bambu Lab,stok,envanter,yazıcı"])

print(f"Préparation de {len(final_langs)} langues (16-20)...")

# Continuer avec les autres langues...
# J'ajoute maintenant toutes les autres en une fois

counter = 16
for lang in final_langs:
    ws.append(lang)
    print(f"{counter}. ✅ {lang[0]}")
    for cell in ws[ws.max_row]:
        cell.alignment = Alignment(wrap_text=True, vertical="top")
    ws.row_dimensions[ws.max_row].height = 500
    counter += 1

wb.save('applestorelang.xlsx')
print(f"\n✅ Total actuel: {ws.max_row - 1} langues")
print("🔄 20 langues restantes à ajouter...")
