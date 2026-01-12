# Spool NFC Tag Writer - Format et Matériaux

Ce document contient toutes les informations récupérées de l'application "Spool NFC Tag Writer" à partir des screenshots.

## Format NFC utilisé

### Structure des pages (MiFare Ultralight NTAG213)

```
Pages 0-3:  1d e2 ab dc d2 08 10 80 4a c0 00 00 e1 10 12 00
            [UID du tag] + [NDEF CC: e1 10 12 00]

Pages 4-7:  7b 00 65 00 (header) + padding
            Header propriétaire (probablement identifiant du format)

Pages 8-11: Brand name (ex: "Anycubic")
            Nom de la marque en ASCII

Pages 12-15: Material type (ex: "ASA")
             Type de matériau en ASCII
```

### Exemple de lecture d'un tag encodé avec Spool NFC Tag Writer

```
Pages 4-7:   7b 00 65 00 00 00 00 00 00 00 00 00 00 00 00 00
Pages 8-11:  00 00 00 00 00 00 00 00 41 6e 79 63 75 62 69 63  → "Anycubic"
Pages 12-15: 00 00 00 00 00 00 00 00 00 00 00 00 41 53 41 00  → "ASA"
```

**Différences avec le format Anycubic natif:**
- Anycubic utilise un SKU (ex: AHPLGY-106)
- Spool NFC Tag Writer utilise Brand + Material séparés
- Header différent: `7b 00 65 00` au lieu de `7b 00 65 00` + données SKU

## Liste des 21 Marques supportées

1. Amazon Basics (13 chars)
2. Anycubic (8 chars)
3. ColorFabb (9 chars)
4. Creality (8 chars)
5. Elegoo (6 chars)
6. eSun (4 chars)
7. Filamentum (10 chars)
8. FormFutura (10 chars)
9. Generic (7 chars)
10. Hatchbox (8 chars)
11. Inland (6 chars)
12. MatterHackers (13 chars)
13. Micro Swiss (11 chars)
14. Monoprice (9 chars)
15. NylonX (6 chars)
16. Overture (8 chars)
17. Polymaker (9 chars)
18. Proto-Pasta (11 chars)
19. Prusa (5 chars)
20. SainSmart (9 chars)
21. Sunlu (5 chars)

## Liste des 25 Matériaux avec paramètres

### 1. ABS
- **Brand**: AC (Anycubic)
- **SKU**: SHABBK-102
- **Extrudeuse**: 220-250°C
- **Lit**: 90-100°C

### 2. ASA
- **Extrudeuse**: 240-280°C
- **Lit**: 90-100°C

### 3. HIPS
- **Extrudeuse**: 230-245°C
- **Lit**: 80-100°C

### 4. Nylon
- **Extrudeuse**: 220-250°C
- **Lit**: 70-90°C

### 5. PC (Polycarbonate)
- **Extrudeuse**: 260-300°C
- **Lit**: 100-110°C

### 6. PETG
- **Extrudeuse**: 230-250°C
- **Lit**: 70-90°C

### 7. PETG Carbon Fiber
- **Extrudeuse**: 240-260°C
- **Lit**: 70-90°C

### 8. PLA
- **Brand**: AC (Anycubic)
- **SKU**: AHPLBK-101
- **Extrudeuse**: 190-230°C
- **Lit**: 50-60°C

### 9. PLA+
- **Brand**: AC (Anycubic)
- **SKU**: AHPLPBK-102
- **Extrudeuse**: 210-230°C
- **Lit**: 45-60°C

### 10. PLA High Speed
- **Brand**: AC (Anycubic)
- **SKU**: AHHSBK-103
- **Extrudeuse**: 190-230°C
- **Lit**: 50-60°C

### 11. PLA Tough
- **Extrudeuse**: 210-230°C
- **Lit**: 50-60°C

### 12. PLA SE
- **Extrudeuse**: 190-230°C
- **Lit**: 55-65°C

### 13. PLA Carbon Fiber
- **Extrudeuse**: 210-240°C
- **Lit**: 45-65°C

### 14. PLA Wood
- **Extrudeuse**: 190-220°C
- **Lit**: 50-60°C

### 15. PLA Metal
- **Extrudeuse**: 195-230°C
- **Lit**: 50-60°C

### 16. PLA Marble
- **Extrudeuse**: 200-230°C
- **Lit**: 50-60°C

### 17. PLA Bamboo
- **Extrudeuse**: 190-220°C
- **Lit**: 50-60°C

### 18. PLA Silk
- **Brand**: AC (Anycubic)
- **SKU**: AHSCWH-102
- **Extrudeuse**: 200-230°C
- **Lit**: 55-65°C

### 19. PLA Matte
- **Brand**: AC (Anycubic)
- **SKU**: HYGBK-102
- **Extrudeuse**: 190-230°C
- **Lit**: 55-65°C

### 20. PLA Glow
- **Extrudeuse**: 190-230°C
- **Lit**: 50-60°C

### 21. PLA Translucent
- **Extrudeuse**: 200-230°C
- **Lit**: 50-60°C

### 22. PLA Color Change
- **Extrudeuse**: 200-230°C
- **Lit**: 50-60°C

### 23. TPU
- **Brand**: AC (Anycubic)
- **SKU**: STPBK-101
- **Extrudeuse**: 210-230°C
- **Lit**: 25-60°C

### 24. TPU 95A
- **Extrudeuse**: 210-230°C
- **Lit**: 25-60°C

### 25. PVA
- **Extrudeuse**: 215-225°C
- **Lit**: 45-60°C

## Paramètres avancés (Advanced Settings)

L'application permet de configurer:
- **Hotend Temperature**: Min-Max (ex: 220-250°C)
- **Bed Temperature**: Min-Max (ex: 70-90°C)
- **Spool Length Total**: en mètres (ex: 330m)
- **Diameter**: en 0.01mm units (ex: 1750 = 1.75mm)

### Exemple de paramètres affichés
```
Ext: 220-250  Bed: 70-90  Dia: 17.5mm  Len: 330m
```

## Fonctionnalités de l'app Spool NFC Tag Writer

1. **Saved Tags**: Sauvegarde et chargement de configurations
2. **Load Saved Tag**: Charger une configuration précédente
3. **Save Current Configuration**: Sauvegarder la config actuelle
4. **Color Picker**: Palette complète avec grille/spectre/curseurs + opacité
5. **Manage Brands**: Ajouter/modifier/supprimer des marques (max 20 chars)
6. **Materials**: Liste complète avec recherche
7. **Show Advanced Options**: Toggle pour afficher/masquer les réglages avancés

## Communication avec AMS (Automatic Material System)

L'application mentionne l'envoi des informations à l'AMS. Le format exact de communication n'est pas visible dans les screenshots mais probablement:
- Utilisation du protocole Bambu Lab pour l'AMS
- Envoi des données via WiFi/réseau local
- Format JSON ou protocole propriétaire

## TODO pour notre app

### Parsing amélioré
- [ ] Détecter le header `7b 00 65 00` (Spool NFC Tag Writer)
- [ ] Lire Brand (pages 8-11) et Material (pages 12-15)
- [ ] Parser les températures si stockées
- [ ] Fallback sur format Anycubic si SKU détecté

### Ajout des matériaux
- [ ] Créer une base de données des 25 matériaux
- [ ] Ajouter les températures min/max pour chaque
- [ ] Ajouter les paramètres avancés (diamètre, longueur)
- [ ] Interface de sélection comme Spool NFC Tag Writer

### Interface utilisateur
- [ ] Dropdown matériaux avec températures affichées
- [ ] Gestion des marques personnalisées
- [ ] Color picker complet
- [ ] Section Advanced Settings
- [ ] Affichage des paramètres: "Ext: 220-250 Bed: 70-90 Dia: 17.5mm Len: 330m"

### Compatibilité
- [ ] Support lecture tags Spool NFC Tag Writer
- [ ] Support lecture tags Anycubic natifs
- [ ] Option d'écriture dans les deux formats
- [ ] Conversion entre formats si possible
