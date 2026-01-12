#!/usr/bin/env python3
# Script to generate remaining translations for Apple Store listing

translations = {
    "Espagnol (Espagne)": {
        "nom": "Spool Master",
        "sous_titre": "Inventario filamento 3D + NFC",
        "texte_promo": "Gestione su stock de filamentos 3D fácilmente. Escanee etiquetas NFC, siga bobinas, precios y estadísticas. Compatible con Anycubic y Bambu Lab.",
        "mots_cles": "NFC,filamento,3D,impresión,bobina,Anycubic,Bambu Lab,stock,inventario,impresora"
    },
    "Espagnol (Mexique)": {
        "nom": "Spool Master",
        "sous_titre": "Inventario filamento 3D + NFC",
        "texte_promo": "Gestione su stock de filamentos 3D fácilmente. Escanee etiquetas NFC, siga bobinas, precios y estadísticas. Compatible con Anycubic y Bambu Lab.",
        "mots_cles": "NFC,filamento,3D,impresión,bobina,Anycubic,Bambu Lab,stock,inventario,impresora"
    },
    "Italien": {
        "nom": "Spool Master",
        "sous_titre": "Inventario filamenti 3D + NFC",
        "texte_promo": "Gestisci il tuo stock di filamenti 3D facilmente. Scansiona tag NFC, traccia bobine, prezzi e statistiche. Compatibile con Anycubic e Bambu Lab.",
        "mots_cles": "NFC,filamento,3D,stampa,bobina,Anycubic,Bambu Lab,stock,inventario,stampante"
    },
    "Portugais (Brésil)": {
        "nom": "Spool Master",
        "sous_titre": "Inventário filamento 3D + NFC",
        "texte_promo": "Gerencie seu estoque de filamentos 3D facilmente. Escaneie tags NFC, rastreie bobinas, preços e estatísticas. Compatível com Anycubic e Bambu Lab.",
        "mots_cles": "NFC,filamento,3D,impressão,bobina,Anycubic,Bambu Lab,estoque,inventário,impressora"
    },
    "Portugais (Portugal)": {
        "nom": "Spool Master",
        "sous_titre": "Inventário filamento 3D + NFC",
        "texte_promo": "Faça a gestão do seu stock de filamentos 3D facilmente. Digitalize tags NFC, acompanhe bobinas, preços e estatísticas. Compatível com Anycubic e Bambu Lab.",
        "mots_cles": "NFC,filamento,3D,impressão,bobina,Anycubic,Bambu Lab,stock,inventário,impressora"
    },
    "Néerlandais": {
        "nom": "Spool Master",
        "sous_titre": "3D-filament inventaris + NFC",
        "texte_promo": "Beheer uw 3D-filamentvoorraad eenvoudig. Scan NFC-tags, volg spoelen, prijzen en statistieken. Compatibel met Anycubic en Bambu Lab.",
        "mots_cles": "NFC,filament,3D,printen,spoel,Anycubic,Bambu Lab,voorraad,inventaris,printer"
    },
    "Polonais": {
        "nom": "Spool Master",
        "sous_titre": "Inwentarz filamentu 3D + NFC",
        "texte_promo": "Zarządzaj zasobami filamentów 3D łatwo. Skanuj tagi NFC, śledź szpule, ceny i statystyki. Kompatybilny z Anycubic i Bambu Lab.",
        "mots_cles": "NFC,filament,3D,druk,szpula,Anycubic,Bambu Lab,zapas,inwentarz,drukarka"
    },
    "Russe": {
        "nom": "Spool Master",
        "sous_titre": "Инвентарь филамента 3D + NFC",
        "texte_promo": "Управляйте запасами филамента для 3D-печати легко. Сканируйте NFC-метки, отслеживайте катушки, цены и статистику. Совместимо с Anycubic и Bambu Lab.",
        "mots_cles": "NFC,филамент,3D,печать,катушка,Anycubic,Bambu Lab,запас,инвентарь,принтер"
    },
    "Japonais": {
        "nom": "Spool Master",
        "sous_titre": "3Dフィラメント在庫 + NFC",
        "texte_promo": "3Dフィラメントの在庫を簡単に管理。NFCタグをスキャンし、スプール、価格、統計を追跡。AnycubicとBambu Labに対応。",
        "mots_cles": "NFC,フィラメント,3D,印刷,スプール,Anycubic,Bambu Lab,在庫,インベントリ,プリンター"
    },
    "Coréen": {
        "nom": "Spool Master",
        "sous_titre": "3D 필라멘트 재고 + NFC",
        "texte_promo": "3D 필라멘트 재고를 쉽게 관리하세요. NFC 태그를 스캔하고 스풀, 가격 및 통계를 추적합니다. Anycubic 및 Bambu Lab과 호환됩니다.",
        "mots_cles": "NFC,필라멘트,3D,인쇄,스풀,Anycubic,Bambu Lab,재고,인벤토리,프린터"
    },
    "Chinois (simplifié)": {
        "nom": "Spool Master",
        "sous_titre": "3D打印丝材库存 + NFC",
        "texte_promo": "轻松管理您的3D打印丝材库存。扫描NFC标签,跟踪线轴、价格和统计数据。兼容Anycubic和Bambu Lab。",
        "mots_cles": "NFC,耗材,3D,打印,线轴,Anycubic,Bambu Lab,库存,清单,打印机"
    },
    "Chinois (traditionnel)": {
        "nom": "Spool Master",
        "sous_titre": "3D列印線材庫存 + NFC",
        "texte_promo": "輕鬆管理您的3D列印線材庫存。掃描NFC標籤,追蹤線軸、價格和統計數據。相容Anycubic和Bambu Lab。",
        "mots_cles": "NFC,耗材,3D,列印,線軸,Anycubic,Bambu Lab,庫存,清單,列印機"
    },
    "Turc": {
        "nom": "Spool Master",
        "sous_titre": "3D filament envanteri + NFC",
        "texte_promo": "3D filament stoğunuzu kolayca yönetin. NFC etiketlerini tarayın, makaraları, fiyatları ve istatistikleri izleyin. Anycubic ve Bambu Lab ile uyumlu.",
        "mots_cles": "NFC,filament,3D,yazdırma,makara,Anycubic,Bambu Lab,stok,envanter,yazıcı"
    },
    "Tchèque": {
        "nom": "Spool Master",
        "sous_titre": "Inventář filamentu 3D + NFC",
        "texte_promo": "Snadno spravujte zásoby 3D filamentů. Skenujte NFC štítky, sledujte cívky, ceny a statistiky. Kompatibilní s Anycubic a Bambu Lab.",
        "mots_cles": "NFC,filament,3D,tisk,cívka,Anycubic,Bambu Lab,zásoba,inventář,tiskárna"
    },
    "Suédois": {
        "nom": "Spool Master",
        "sous_titre": "3D-filament lager + NFC",
        "texte_promo": "Hantera ditt 3D-filamentlager enkelt. Skanna NFC-taggar, spåra rullar, priser och statistik. Kompatibel med Anycubic och Bambu Lab.",
        "mots_cles": "NFC,filament,3D,utskrift,rulle,Anycubic,Bambu Lab,lager,inventarie,skrivare"
    },
    "Français (Canada)": {
        "nom": "Spool Master",
        "sous_titre": "Inventaire filament 3D + NFC",
        "texte_promo": "Gérez votre stock de filaments 3D facilement. Scannez vos tags NFC, suivez vos bobines, prix et statistiques. Compatible Anycubic et Bambu Lab.",
        "mots_cles": "NFC,filament,3D,impression,bobine,Anycubic,Bambu Lab,stock,inventaire,imprimante"
    }
}

print("Traductions générées avec succès!")
print(f"Nombre de langues: {len(translations)}")
