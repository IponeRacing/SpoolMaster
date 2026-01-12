#!/usr/bin/env python3
from openpyxl import Workbook
from openpyxl.styles import Font, Alignment, PatternFill
from openpyxl.utils import get_column_letter

# Créer un nouveau workbook
wb = Workbook()
ws = wb.active
ws.title = "Apple Store Listings"

# En-têtes
headers = ["Langue", "Nom (18)", "Sous titre (30)", "Texte promotionnel (170)", "Description (4000)", "Mots-clés (100)"]
ws.append(headers)

# Style des en-têtes
header_fill = PatternFill(start_color="4472C4", end_color="4472C4", fill_type="solid")
header_font = Font(bold=True, color="FFFFFF")
for cell in ws[1]:
    cell.fill = header_fill
    cell.font = header_font
    cell.alignment = Alignment(horizontal="center", vertical="center")

# Template de description en français
desc_template = """Spool Master - L'application complète pour gérer votre stock de filaments d'impression 3D

🎯 FONCTIONNALITÉS PRINCIPALES

📱 Lecture et écriture NFC
• Lisez les puces NFC des bobines Anycubic et Bambu Lab
• Écrivez vos propres tags NFC personnalisés
• Clonez des tags NFC pour réutilisation
• Compatible avec tous les formats de tags NFC

📊 Gestion d'inventaire complète
• Ajoutez vos bobines par scan NFC ou manuellement
• Suivez le poids restant de chaque bobine
• Gérez vos prix et calculez la valeur totale
• Organisez par marque, matériau et couleur
• Alertes automatiques de stock bas

📈 Statistiques détaillées
• Vue d'ensemble de votre inventaire
• Valeur totale de votre stock
• Nombre de matériaux, couleurs et marques
• Liste de courses automatique

🛒 Liste de courses intelligente
• Ajout automatique des bobines en stock bas
• Marquez les filaments commandés
• Ajoutez manuellement ou par scan NFC

🎨 Sélecteur de couleurs avancé
• Palette complète avec curseurs RGB
• Support de l'opacité
• Aperçu en temps réel

🌡️ Paramètres d'impression
• Températures d'extrudeuse (min/max)
• Températures de plateau (min/max)
• Diamètre du filament
• Longueur de la bobine

🔧 COMPATIBILITÉ
• Anycubic : Lecture et écriture complètes
• Bambu Lab : Lecture et écriture des tags RFID
• Tags NFC génériques : Écriture personnalisée
• Support de 21 marques de filament
• Support de 25 types de matériaux (PLA, PETG, ABS, TPU, etc.)

🌍 MULTILINGUE
Application disponible en 31 langues

☁️ SYNCHRONISATION
• Synchronisation multi-appareils
• Mode hors ligne disponible

💰 UNITÉS ET DEVISES
• Support de multiples devises
• Unités métriques ou impériales
• Conversion automatique

📱 INTERFACE MODERNE
• Mode sombre et clair
• Design Material 3
• Navigation intuitive
• Statistiques visuelles

🔒 SÉCURITÉ ET CONFIDENTIALITÉ
• Vos données restent privées
• Stockage local sécurisé

⭐ VERSION PREMIUM DISPONIBLE
• Synchronisation cloud
• Sans publicité
• Support prioritaire

Que vous soyez un maker amateur ou un professionnel de l'impression 3D, Spool Master vous aide à optimiser la gestion de vos filaments, réduire le gaspillage et maîtriser vos dépenses.

Téléchargez maintenant et prenez le contrôle de votre inventaire de filaments !"""

# Données pour toutes les langues
languages = [
    ["Français", "Spool Master", "Inventaire filament 3D + NFC",
     "Gérez votre stock de filaments 3D facilement. Scannez vos tags NFC, suivez vos bobines, prix et statistiques. Compatible Anycubic et Bambu Lab.",
     desc_template,
     "NFC,filament,3D,impression,bobine,Anycubic,Bambu Lab,stock,inventaire,imprimante"],
]

# Ajouter les données
for lang_data in languages:
    ws.append(lang_data)

# Ajuster la largeur des colonnes
ws.column_dimensions['A'].width = 25  # Langue
ws.column_dimensions['B'].width = 20  # Nom
ws.column_dimensions['C'].width = 35  # Sous-titre
ws.column_dimensions['D'].width = 50  # Texte promo
ws.column_dimensions['E'].width = 80  # Description
ws.column_dimensions['F'].width = 60  # Mots-clés

# Activer le wrap text pour toutes les cellules
for row in ws.iter_rows(min_row=2, max_row=ws.max_row, min_col=1, max_col=6):
    for cell in row:
        cell.alignment = Alignment(wrap_text=True, vertical="top")

# Fixer la hauteur des lignes pour la description
for row in range(2, ws.max_row + 1):
    ws.row_dimensions[row].height = 400  # Hauteur suffisante pour la description

# Sauvegarder
wb.save('applestorelang.xlsx')
print("✅ Fichier Excel créé : applestorelang.xlsx")
print(f"📊 {len(languages)} langue(s) ajoutée(s)")
