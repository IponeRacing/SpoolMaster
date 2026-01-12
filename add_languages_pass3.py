#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from openpyxl import load_workbook
from openpyxl.styles import Alignment

def d(intro, title, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, outro):
    return f"""{intro}

🎯 {title}

📱 {f1}

📊 {f2}

🔧 {f3}

💰 {f4}

📈 {f5}

🛒 {f6}

🎨 {f7}

⚡ {f8}

🔒 {f9}

📱 {f10}

🌍 {f11}

💎 {f12}

⭐ {f13}

{outro}"""

# Langues 31-40
descriptions = {
    31: d(  # Hongrois
        "Forradalmasítsa 3D nyomtatási munkafolyamatát a Spool Master segítségével - a végső NFC-alapú orsókezelő alkalmazás professzionális alkotók és hobbisták számára.",
        "Főbb Funkciók",
        "NFC Technológia: Olvassa és írja az Anycubic és Bambu Lab orsók NFC címkéit pillanatokon belül",
        "Okos Leltár: Kövesse nyomon az összes orsóját anyag, szín, mennyiség és árral",
        "Anyagadatbázis: 25+ előre konfigurált anyag (PLA, PETG, ABS, TPU...) pontos hőmérséklet-beállításokkal",
        "Költségkövetés: Kezelje az árakat, számítsa ki a fennmaradó értéket és optimalizálja költségvetését",
        "Élő Statisztikák: Vizualizálja felhasználását típus, gyártó és időszak szerint",
        "Bevásárlólista: Soha ne fogyjon ki az anyagból - intelligens újrarendelési emlékeztetők",
        "Testreszabás: Egyedi márkák, anyagok és speciális konfiguráció minden orsóhoz",
        "Azonnali Szinkronizálás: Valós idejű adatfrissítés szkenneléskor",
        "Biztonság: Helyi és titkosított felhőtárolás (Prémium)",
        "Többplatformos: Működik iOS és Android készülékeken",
        "31 Nyelv: Teljes lokalizáció a világ minden táján",
        "Prémium Funkciók: Felhőszinkronizálás, hirdetésmentes, elsőbbségi támogatás",
        "Ingyenes Mód: Teljes alapvető funkciók korlátozás nélkül",
        "Csatlakozzon több ezer 3D nyomtató felhasználóhoz, akik már optimalizálták orsókezelésüket. Töltse le most!"
    ),
    32: d(  # Indonésien
        "Revolusikan alur kerja pencetakan 3D Anda dengan Spool Master - aplikasi manajemen spool berbasis NFC terbaik untuk kreator profesional dan penggemar.",
        "Fitur Utama",
        "Teknologi NFC: Baca dan tulis tag NFC spool Anycubic dan Bambu Lab dalam hitungan detik",
        "Inventaris Cerdas: Lacak semua spool Anda dengan bahan, warna, kuantitas, dan harga",
        "Database Material: 25+ material yang telah dikonfigurasi (PLA, PETG, ABS, TPU...) dengan pengaturan suhu yang tepat",
        "Pelacakan Biaya: Kelola harga, hitung nilai sisa, dan optimalkan anggaran Anda",
        "Statistik Langsung: Visualisasikan penggunaan Anda berdasarkan jenis, merek, dan periode",
        "Daftar Belanja: Jangan pernah kehabisan material - pengingat pemesanan ulang cerdas",
        "Kustomisasi: Merek kustom, material, dan konfigurasi khusus untuk setiap spool",
        "Sinkronisasi Instan: Pembaruan data real-time saat memindai",
        "Keamanan: Penyimpanan lokal dan cloud terenkripsi (Premium)",
        "Multi-platform: Berfungsi di perangkat iOS dan Android",
        "31 Bahasa: Lokalisasi lengkap di seluruh dunia",
        "Fitur Premium: Sinkronisasi cloud, bebas iklan, dukungan prioritas",
        "Mode Gratis: Fungsionalitas dasar lengkap tanpa batasan",
        "Bergabunglah dengan ribuan pengguna printer 3D yang telah mengoptimalkan manajemen spool mereka. Unduh sekarang!"
    ),
    33: d(  # Malais
        "Revolusikan aliran kerja pencetakan 3D anda dengan Spool Master - aplikasi pengurusan spool berasaskan NFC terbaik untuk pencipta profesional dan penggemar.",
        "Ciri-ciri Utama",
        "Teknologi NFC: Baca dan tulis tag NFC spool Anycubic dan Bambu Lab dalam beberapa saat",
        "Inventori Pintar: Jejaki semua spool anda dengan bahan, warna, kuantiti dan harga",
        "Pangkalan Data Bahan: 25+ bahan pra-konfigurasi (PLA, PETG, ABS, TPU...) dengan tetapan suhu yang tepat",
        "Penjejakan Kos: Urus harga, kira nilai baki dan optimumkan belanjawan anda",
        "Statistik Langsung: Visualkan penggunaan anda mengikut jenis, jenama dan tempoh",
        "Senarai Beli-belah: Jangan kehabisan bahan - peringatan pesanan semula pintar",
        "Penyesuaian: Jenama tersuai, bahan dan konfigurasi khusus untuk setiap spool",
        "Penyegerakan Segera: Kemas kini data masa nyata semasa mengimbas",
        "Keselamatan: Penyimpanan tempatan dan awan yang disulitkan (Premium)",
        "Berbilang Platform: Berfungsi pada peranti iOS dan Android",
        "31 Bahasa: Penyetempatan lengkap di seluruh dunia",
        "Ciri Premium: Penyegerakan awan, tanpa iklan, sokongan keutamaan",
        "Mod Percuma: Fungsi asas lengkap tanpa batasan",
        "Sertai beribu-ribu pengguna pencetak 3D yang telah mengoptimumkan pengurusan spool mereka. Muat turun sekarang!"
    ),
    34: d(  # Norvégien
        "Revolusjoniser din 3D-utskriftarbeidsflyt med Spool Master - den ultimate NFC-baserte spoleadministrasjonsappen for profesjonelle skapere og entusiaster.",
        "Hovedfunksjoner",
        "NFC-teknologi: Les og skriv Anycubic og Bambu Lab spole-NFC-tagger på sekunder",
        "Smart inventar: Spor alle spolene dine med materiale, farge, mengde og pris",
        "Materialdatabase: 25+ forhåndskonfigurerte materialer (PLA, PETG, ABS, TPU...) med presise temperaturinnstillinger",
        "Kostnadssporing: Administrer priser, beregn gjenværende verdi og optimaliser budsjettet ditt",
        "Live statistikk: Visualiser bruken din etter type, merke og periode",
        "Handleliste: Gå aldri tom for materiale - smarte påminnelser om gjenbestilling",
        "Tilpasning: Egendefinerte merker, materialer og spesialkonfigurasjon for hver spole",
        "Umiddelbar synkronisering: Sanntids dataoppdatering ved skanning",
        "Sikkerhet: Lokal og kryptert skylagring (Premium)",
        "Multiplattform: Fungerer på iOS- og Android-enheter",
        "31 språk: Fullstendig lokalisering over hele verden",
        "Premium-funksjoner: Skysynkronisering, annonseringsfritt, prioritert støtte",
        "Gratis modus: Fullt grunnleggende funksjonalitet uten begrensninger",
        "Bli med tusenvis av 3D-printerbrukere som allerede har optimalisert spolehåndteringen sin. Last ned nå!"
    ),
    35: d(  # Roumain
        "Revoluționează fluxul tău de lucru în imprimarea 3D cu Spool Master - aplicația supremă de gestionare a bobinelor bazată pe NFC pentru creatori profesioniști și pasionați.",
        "Caracteristici Principale",
        "Tehnologie NFC: Citește și scrie tag-uri NFC pentru bobine Anycubic și Bambu Lab în câteva secunde",
        "Inventar Inteligent: Urmărește toate bobinele tale cu material, culoare, cantitate și preț",
        "Bază de Date Materiale: 25+ materiale pre-configurate (PLA, PETG, ABS, TPU...) cu setări precise de temperatură",
        "Urmărire Costuri: Gestionează prețurile, calculează valoarea rămasă și optimizează bugetul",
        "Statistici Live: Vizualizează utilizarea ta pe tip, marcă și perioadă",
        "Listă de Cumpărături: Nu mai rămâi niciodată fără material - memento-uri inteligente de recomandare",
        "Personalizare: Mărci personalizate, materiale și configurare specială pentru fiecare bobină",
        "Sincronizare Instantanee: Actualizări de date în timp real la scanare",
        "Securitate: Stocare locală și cloud criptată (Premium)",
        "Multi-platformă: Funcționează pe dispozitive iOS și Android",
        "31 de Limbi: Localizare completă în întreaga lume",
        "Funcții Premium: Sincronizare cloud, fără reclame, asistență prioritară",
        "Mod Gratuit: Funcționalitate de bază completă fără limitări",
        "Alătură-te miilor de utilizatori de imprimante 3D care și-au optimizat deja gestionarea bobinelor. Descarcă acum!"
    ),
    36: d(  # Slovaque
        "Revolucionalizujte svoj pracovný postup 3D tlače s aplikáciou Spool Master - najlepšia aplikácia na správu cievok založená na NFC pre profesionálnych tvorcov a nadšencov.",
        "Hlavné Funkcie",
        "Technológia NFC: Čítajte a zapisujte NFC značky cievok Anycubic a Bambu Lab v priebehu sekúnd",
        "Inteligentný inventár: Sledujte všetky svoje cievky s materiálom, farbou, množstvom a cenou",
        "Databáza materiálov: 25+ prednakonfigurovaných materiálov (PLA, PETG, ABS, TPU...) s presnými teplotnými nastaveniami",
        "Sledovanie nákladov: Spravujte ceny, vypočítajte zostatkovú hodnotu a optimalizujte svoj rozpočet",
        "Živé štatistiky: Vizualizujte svoje používanie podľa typu, značky a obdobia",
        "Nákupný zoznam: Nikdy nedôjde materiál - inteligentné pripomienky preobjednania",
        "Prispôsobenie: Vlastné značky, materiály a špeciálna konfigurácia pre každú cievku",
        "Okamžitá synchronizácia: Aktualizácia údajov v reálnom čase pri skenovaní",
        "Bezpečnosť: Lokálne a šifrované cloudové úložisko (Premium)",
        "Multiplatformové: Funguje na zariadeniach iOS a Android",
        "31 jazykov: Kompletná lokalizácia po celom svete",
        "Prémiové funkcie: Cloudová synchronizácia, bez reklám, prioritná podpora",
        "Bezplatný režim: Plná základná funkčnosť bez obmedzení",
        "Pripojte sa k tisíckam používateľov 3D tlačiarní, ktorí už optimalizovali svoju správu cievok. Stiahnite si teraz!"
    ),
    37: d(  # Thaï
        "ปฏิวัติเวิร์กโฟลว์การพิมพ์ 3D ของคุณด้วย Spool Master - แอปจัดการสปูลที่ใช้ NFC ที่ดีที่สุดสำหรับผู้สร้างมืออาชีพและผู้ที่หลงใหล",
        "ฟีเจอร์หลัก",
        "เทคโนโลยี NFC: อ่านและเขียนแท็ก NFC สปูล Anycubic และ Bambu Lab ในไม่กี่วินาที",
        "การจัดการคลังอัจฉริยะ: ติดตามสปูลทั้งหมดของคุณด้วยวัสดุ สี ปริมาณ และราคา",
        "ฐานข้อมูลวัสดุ: วัสดุที่กำหนดค่าไว้ล่วงหน้ากว่า 25 ชนิด (PLA, PETG, ABS, TPU...) พร้อมการตั้งค่าอุณหภูมิที่แม่นยำ",
        "การติดตามต้นทุน: จัดการราคา คำนวณมูลค่าคงเหลือ และเพิ่มประสิทธิภาพงบประมาณของคุณ",
        "สถิติแบบสด: แสดงภาพการใช้งานของคุณตามประเภท แบรนด์ และช่วงเวลา",
        "รายการช็อปปิ้ง: ไม่มีวันขาดวัสดุ - การแจ้งเตือนการสั่งซื้อใหม่อัจฉริยะ",
        "การปรับแต่ง: แบรนด์ที่กำหนดเอง วัสดุ และการกำหนดค่าพิเศษสำหรับแต่ละสปูล",
        "การซิงค์ทันที: การอัปเดตข้อมูลแบบเรียลไทม์เมื่อสแกน",
        "ความปลอดภัย: การจัดเก็บในเครื่องและคลาวด์ที่เข้ารหัส (Premium)",
        "หลายแพลตฟอร์ม: ใช้งานได้บนอุปกรณ์ iOS และ Android",
        "31 ภาษา: การแปลเป็นภาษาท้องถิ่นอย่างสมบูรณ์ทั่วโลก",
        "ฟีเจอร์พรีเมียม: การซิงค์คลาวด์ ไม่มีโฆษณา การสนับสนุนลำดับความสำคัญ",
        "โหมดฟรี: ฟังก์ชันพื้นฐานเต็มรูปแบบโดยไม่มีข้อจำกัด",
        "เข้าร่วมกับผู้ใช้เครื่องพิมพ์ 3D หลายพันคนที่ได้เพิ่มประสิทธิภาพการจัดการสปูลของพวกเขาแล้ว ดาวน์โหลดเดี๋ยวนี้!"
    ),
    38: d(  # Ukrainien
        "Революціонізуйте свій робочий процес 3D-друку з Spool Master - найкраща програма керування котушками на основі NFC для професійних творців та ентузіастів.",
        "Основні Функції",
        "Технологія NFC: Читайте та записуйте NFC-мітки котушок Anycubic та Bambu Lab за лічені секунди",
        "Розумна інвентаризація: Відстежуйте всі свої котушки з матеріалом, кольором, кількістю та ціною",
        "База даних матеріалів: 25+ попередньо налаштованих матеріалів (PLA, PETG, ABS, TPU...) з точними налаштуваннями температури",
        "Відстеження витрат: Керуйте цінами, розраховуйте залишкову вартість та оптимізуйте свій бюджет",
        "Жива статистика: Візуалізуйте своє використання за типом, брендом та періодом",
        "Список покупок: Ніколи не залишайтеся без матеріалу - розумні нагадування про повторне замовлення",
        "Налаштування: Власні бренди, матеріали та спеціальна конфігурація для кожної котушки",
        "Миттєва синхронізація: Оновлення даних у реальному часі під час сканування",
        "Безпека: Локальне та зашифроване хмарне сховище (Преміум)",
        "Мультиплатформність: Працює на пристроях iOS та Android",
        "31 мова: Повна локалізація по всьому світу",
        "Преміум-функції: Хмарна синхронізація, без реклами, пріоритетна підтримка",
        "Безкоштовний режим: Повна базова функціональність без обмежень",
        "Приєднуйтесь до тисяч користувачів 3D-принтерів, які вже оптимізували своє керування котушками. Завантажте зараз!"
    ),
    39: d(  # Vietnamien
        "Cách mạng hóa quy trình in 3D của bạn với Spool Master - ứng dụng quản lý cuộn dây dựa trên NFC tối ưu cho người sáng tạo chuyên nghiệp và người đam mê.",
        "Tính Năng Chính",
        "Công nghệ NFC: Đọc và ghi thẻ NFC cuộn Anycubic và Bambu Lab trong vài giây",
        "Kho hàng thông minh: Theo dõi tất cả cuộn dây của bạn với vật liệu, màu sắc, số lượng và giá",
        "Cơ sở dữ liệu vật liệu: Hơn 25 vật liệu được cấu hình sẵn (PLA, PETG, ABS, TPU...) với cài đặt nhiệt độ chính xác",
        "Theo dõi chi phí: Quản lý giá, tính giá trị còn lại và tối ưu hóa ngân sách của bạn",
        "Thống kê trực tiếp: Trực quan hóa mức sử dụng của bạn theo loại, thương hiệu và thời kỳ",
        "Danh sách mua sắm: Không bao giờ hết vật liệu - nhắc nhở đặt hàng lại thông minh",
        "Tùy chỉnh: Thương hiệu tùy chỉnh, vật liệu và cấu hình đặc biệt cho từng cuộn",
        "Đồng bộ tức thì: Cập nhật dữ liệu thời gian thực khi quét",
        "Bảo mật: Lưu trữ cục bộ và đám mây được mã hóa (Premium)",
        "Đa nền tảng: Hoạt động trên thiết bị iOS và Android",
        "31 ngôn ngữ: Bản địa hóa hoàn chỉnh trên toàn thế giới",
        "Tính năng Premium: Đồng bộ đám mây, không có quảng cáo, hỗ trợ ưu tiên",
        "Chế độ miễn phí: Đầy đủ chức năng cơ bản không giới hạn",
        "Tham gia cùng hàng nghìn người dùng máy in 3D đã tối ưu hóa quản lý cuộn dây của họ. Tải xuống ngay!"
    ),
    40: d(  # Slovène
        "Revolucionirajte svoj potek dela 3D tiskanja s Spool Master - vrhunska aplikacija za upravljanje tuljav, ki temelji na NFC, za profesionalne ustvarjalce in navdušence.",
        "Glavne Funkcije",
        "Tehnologija NFC: Preberite in zapišite NFC oznake tuljav Anycubic in Bambu Lab v nekaj sekundah",
        "Pametna inventura: Spremljajte vse svoje tuljave z materialom, barvo, količino in ceno",
        "Baza podatkov materialov: 25+ vnaprej konfiguriranih materialov (PLA, PETG, ABS, TPU...) s preciznimi nastavitvami temperature",
        "Sledenje stroškov: Upravljajte cene, izračunajte preostalo vrednost in optimizirajte svoj proračun",
        "Statistika v živo: Vizualizirajte svojo uporabo po vrsti, blagovni znamki in obdobju",
        "Nakupovalni seznam: Nikoli ne zmanjka materiala - pametni opomniki za ponovno naročilo",
        "Prilagoditev: Blagovne znamke po meri, materiali in posebna konfiguracija za vsako tuljavo",
        "Takojšnja sinhronizacija: Posodobitev podatkov v realnem času pri skeniranju",
        "Varnost: Lokalno in šifrirano shranjevanje v oblaku (Premium)",
        "Več platform: Deluje na napravah iOS in Android",
        "31 jezikov: Popolna lokalizacija po vsem svetu",
        "Premium funkcije: Sinhronizacija v oblaku, brez oglasov, prednostna podpora",
        "Brezplačni način: Popolna osnovna funkcionalnost brez omejitev",
        "Pridružite se tisočem uporabnikov 3D tiskalnikov, ki so že optimizirali svoje upravljanje tuljav. Prenesite zdaj!"
    )
}

# Charger le fichier Excel
wb = load_workbook('applestorelang.xlsx')
ws = wb.active

# Mettre à jour les descriptions des langues 31-40
for row_num, desc in descriptions.items():
    ws.cell(row=row_num + 1, column=5).value = desc
    ws.cell(row=row_num + 1, column=5).alignment = Alignment(wrap_text=True, vertical="top")
    ws.row_dimensions[row_num + 1].height = 500

# Sauvegarder
wb.save('applestorelang.xlsx')

print("✅ 10 dernières langues mises à jour (31-40)")
print("🎉 TOUTES les 40 langues sont maintenant complètes!")
print("\nLangues finalisées:")
print("31. Hongrois")
print("32. Indonésien")
print("33. Malais")
print("34. Norvégien")
print("35. Roumain")
print("36. Slovaque")
print("37. Thaï")
print("38. Ukrainien")
print("39. Vietnamien")
print("40. Slovène")
