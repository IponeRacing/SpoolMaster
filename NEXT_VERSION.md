# Prochaine version — évolutions prévues

_Dernière mise à jour : 2026-10-04_

Évolutions décidées pour la version qui suivra la 1.4.10, avec ce qu'il faut savoir pour les implémenter. Une section par sujet. Quand un sujet est livré, noter le commit et la version dans son statut.

---

## 1. Lecture des bobines Qidi (Qidi Box)

**Statut** : à faire (décidé le 04.10.2026 de ne pas l'intégrer à la 1.4.10). Rien n'est commencé.

### Pourquoi

Les possesseurs d'une Qidi Box (Qidi Q1/Q2/Plus4) ont des bobines munies d'un tag. Aujourd'hui, l'app refuse ces tags avec le message « pas une bobine Bambu Lab (ni Creality) ». Avant le commit e026b69, elle créait même une fausse bobine « Bambu Lab ».

### Format du tag (vérifié sur 3 vrais dumps)

- Puce : MIFARE Classic 1K. **Android seulement** : l'iPhone ne lit pas le MIFARE Classic.
- Clés : clé A par défaut `FFFFFFFFFFFF`. Sur les 3 dumps, la clé B est aussi `FFFFFFFFFFFF`, avec les bits d'accès `FF078069`. Le projet BoxRFID (TinkerBarn) évoque une seconde clé pour certains tags : non confirmée, aucun dump.
- Données : secteur 1, bloc 4 uniquement. Le reste du bloc et les blocs 5 et 6 sont à zéro.

| Octet du bloc 4 | Champ | Valeurs |
|---|---|---|
| 0 | Code matériau | 1 à 50 (ex. 0x29 = 41 = PETG) |
| 1 | Code couleur | 1 à 24 (ex. 0x0B = #1714B0, bleu) |
| 2 | Code fabricant | 0 = générique, 1 = QIDI |
| 3 à 15 | — | zéros |

- Tables :
  - **Matériaux** : `officiall_filas_list.cfg` du firmware Qidi Q2 (QIDITECH/QIDI_Q2, dossier `config/`), reprise dans le README de DnG-Crafts/QIDI-RFID et dans `src/tag/qidi/constants.py` d'OpenRFID.
  - **Couleurs** : 24 codes avec leur RVB, dans les mêmes sources.
  - Ne reprendre que les faits (code, nom, RVB), pas de code GPL.
- **Aucune température sur le tag.** Il faut une table par matériau, à tirer des profils officiels Qidi. Sinon les champs restent vides, comme le fait OpenRFID.

### Ce que l'app fait déjà

En détection automatique, le natif Android essaie d'abord Creality (clé dérivée : échec), puis le lecteur Bambu. Ce dernier ouvre les secteurs avec `FFFFFFFFFFFF` et renvoie tous les blocs à Dart (`rawBlocks`, tagType « bambu »). Le refus se fait ensuite dans `BambuLabReaderService._parseNativeData`, parce que `BambuTagParser.isBambuTag` est faux.

### Implémentation proposée

1. **Dart** (`lib/features/nfc_reader/data/services/`) : un `QidiTagParser`, appelé dans `_parseNativeData` avant le refus « pas Bambu ».
   - Signature stricte : bloc 4 avec matériau ≠ 0, couleur ≠ 0, fabricant ≠ 0, codes présents dans les tables, octets 3 à 15 nuls, blocs 5 et 6 nuls. Le but est d'éviter de prendre une carte MIFARE vierge ou d'une autre marque pour un tag Qidi.
   - Résultat : marque « QIDI » (ou « Generic » si le code fabricant vaut 0), matériau et couleur depuis les tables, poids 1000 g par défaut, diamètre 1,75.
2. **Natif** (une ligne, proposée par la session nfcanycubic-7a) : renvoyer tagType « qidi » plutôt que « bambu », pour l'analytics.
3. Mettre à jour le message de refus de `_parseNativeData`, qui dit aujourd'hui que Qidi n'est pas pris en charge.
4. Pas de carte « Qidi » dans l'écran de choix du mode : la détection automatique suffit.

### Validation

- 3 vrais dumps : OpenRFID, `test/tags/Qidi/` (PETG bleu, gris clair, rouge), avec les valeurs attendues en `.yml`. Couverture faible : un seul matériau. Signature vérifiée le 04.10.2026 sur les 3 : bloc 4 = `29 0B 01`, `29 14 01` et `29 12 01`, reste du bloc 4 et blocs 5-6 entièrement nuls.
- Rejouer avec le banc décrit en section 3. Tester aussi une carte MIFARE vierge (clés par défaut, blocs à zéro) : elle doit être refusée.

**Effort estimé** : 1 à 2 h, plus la table des températures.

---

## 2. Lecture des bobines Snapmaker U1

**Statut** : à faire (décidé le 04.10.2026 de ne pas l'intégrer à la 1.4.10). Rien n'est commencé.

### Pourquoi

Les bobines SnapSpeed du Snapmaker U1 portent un tag complet : couleurs, températures, poids, séchage. Aujourd'hui, l'app échoue à l'authentification et affiche « Ce tag n'est pas une bobine Bambu Lab lisible ».

### Format du tag (vérifié sur 4 vrais dumps)

- Puce : MIFARE Classic 1K. **Android seulement.**
- **Clés propres à chaque tag**, dérivées de l'UID. La méthode est proche de Bambu, avec une variante :
  - PRK = HMAC-SHA256(clé = secret Snapmaker, message = UID[0:4]). Pour la clé A, on prend les 25 premiers octets du secret ; pour la clé B, le secret entier, sans `\0` final.
  - Pour chaque secteur i (0 à 15) : clé = HMAC-SHA256(PRK, « key_a_i » ou « key_b_i » + octet 0x01), tronquée à 6 octets.
  - Le secret est public : `test/test_tags.py` d'OpenRFID (`_build_snapmaker_processor`), et SnapmakerResearchGroup/RFID, qui renvoie à `common/generator.c` de Proxmark3. L'app contient déjà dans le même esprit le sel Bambu et les clés Creality.
- Données **en clair**, signées RSA (une clé parmi 10). La signature empêche de forger un tag, pas de le lire : on peut l'ignorer, comme pour TigerTag.
- Entiers en little-endian ; le RVB est stocké dans l'ordre R, G, B.

| Position (octet absolu) | Taille | Champ |
|---|---|---|
| 0 (bloc 0) | 4 | UID |
| 16 (bloc 1) | 16 | Vendeur (ASCII, ex. « Snapmaker ») |
| 32 (bloc 2) | 16 | Fabricant (ASCII) |
| 64 (bloc 4) | 2 | Version |
| 66 | 2 | Type : 1 PLA, 2 PETG, 3 ABS, 4 TPU, 5 PVA |
| 68 | 2 | Sous-type : 1 Basic, 2 Matte, 3 SnapSpeed, 4 Silk, 5 Support, 6 HF, 7 95A, 8 95A HF |
| 70 | 2 | Emplacement (tray) |
| 72 | 1 | Nombre de couleurs (5 au plus) |
| 73 | 1 | Alpha = 0xFF − valeur |
| 80 (bloc 5) | 5 × 3 | Couleurs 1 à 5 (RVB) |
| 96 (bloc 6) | 4 | SKU |
| 128 (bloc 8) | 2 / 2 / 2 | Diamètre (÷ 100 mm) / poids (g) / longueur (m) |
| 144 (bloc 9) | 2 × 8 | Séchage °C, séchage h, buse max, buse min, type de plateau, plateau °C, 1re couche, couches suivantes |
| 160 (bloc 10) | 8 | Date de fabrication |
| 168 | 2 | Version de la clé RSA |

Valeurs attendues pour le tag SnapSpeed PLA noir (référence pour les tests) : Snapmaker / PLA SnapSpeed / #080A0D / 1,75 mm / 500 g / buse 190-230 / plateau 60 / séchage 55 °C 6 h / 2026-01-01.

### Implémentation proposée

1. **Natif Android** (session nfcanycubic-7a) :
   - dérivation des clés Snapmaker ;
   - lecture des 16 secteurs ;
   - réponse avec `rawBlocks` et tagType « snapmaker ».
   - En détection automatique, essai **après** Creality et Bambu. Chaque échec d'authentification impose une reconnexion, d'où environ 100 à 200 ms de plus, mais seulement pour les tags qui ne sont ni Creality ni Bambu.
2. **Dart** : un `SnapmakerTagParser` (tables de type et sous-type), branché sur le tagType « snapmaker » dans `readBobbinDataAutoDetect`. Plusieurs couleurs : pastille en dégradé (`filamentSwatchGradient`, à étendre à une liste de couleurs).
3. Lecture seule : pas d'écriture ni de clonage, la signature RSA les rendrait inutiles pour l'imprimante.

### Validation

- 4 vrais dumps : OpenRFID, `test/tags/Snapmaker/` (SnapSpeed PLA 500 g noir, rouge, blanc, jaune). Les clés sont dans les trailers des secteurs, ce qui permet de vérifier la dérivation, et les valeurs attendues sont en `.yml`. Couverture limitée au PLA SnapSpeed.
- Dérivation des clés déjà vérifiée le 04.10.2026 sur les 4 dumps : clés A 64/64 ; clés B 63/64. L'écart est un bit isolé sur la clé B du secteur 15 du tag jaune (`…17a0` dans le dump, `…17a2` attendu) : défaut du dump, pas de la formule, et sans effet si l'on lit avec la clé A. Type 1 (PLA), sous-type 3 (SnapSpeed), poids 500 g et buse 190-230 lus aux positions du tableau sur les 4 tags.

**Effort estimé** : une demi-journée (Kotlin, Dart et tests).

---

## 3. Rejouer des dumps réels (banc de test)

Les deux évolutions ci-dessus se valident comme les correctifs de la 1.4.10 : en rejouant de vrais dumps dans le vrai pipeline de l'app.

- `tool/nfc_corpus_replay_test.dart` : rejoue des réponses natives émulées dans `NfcDataSourceImpl` puis `NfcRepositoryImpl`. Entrée et sortie en JSONL, via `NFC_CORPUS_IN` et `NFC_CORPUS_OUT`.
- `tool/bambu_corpus_check.py` : corpus Bambu complet (5959 dumps).
- `tool/corpus/` : émulateur natif multi-marques (`native_emul.py`), constructeur de corpus (`brands_build.py`, OpenRFID comme référence), comparaison (`brands_compare.py`), et les 103 dumps collectés le 04.10.2026 (`dumps/`, avec `manifest.json`). Mode d'emploi dans `tool/corpus/README.md`. **Local seulement** : `tool/` est exclu de git (`.gitignore`), donc absent d'un clone neuf. L'émulateur reflète le natif de la 1.4.10+93 : le mettre à jour à chaque changement de `NativeNfcPlugin.kt`.
- **Les dumps ne vont jamais dans le dépôt** : ils sont sous GPL ou sans licence.

| Source | Commit (04.10.2026) | Licence | Contenu utile |
|---|---|---|---|
| github.com/suchmememanyskill/OpenRFID (`test/tags/`) | a13bc9e | GPL-3.0 | Qidi ×3, Snapmaker ×4, valeurs attendues `.yml` |
| github.com/DnG-Crafts/QIDI-RFID | 6e5739c | aucune | Format Qidi, tables matériaux et couleurs |
| github.com/SnapmakerResearchGroup/RFID | af736ff | MIT | Format Snapmaker, `parser.py` sans RSA |
| github.com/DnG-Crafts/U1-RFID | 273e2d4 | aucune | Programmation de tags U1 (pas de dump) |
| github.com/TinkerBarn/BoxRFID-Touch | 0c41659 | aucune | Mention d'une seconde clé Qidi |

---

## 4. Autres pistes relevées par le test des dumps réels (basse priorité)

- **Noms de couleur génériques approximatifs** (`colorNameFromRgb`), surtout visibles sur Anycubic, dont les tags ne portent pas de nom de couleur : Beige, Dark Brown et Gold deviennent « Orange » ; Purple et Interstellar Violet deviennent « Blue » ; Strawberry Pink devient « Red ». Même chose pour TigerTag : Roasted Chestnut devient « Gray ». Deux voies possibles : affiner les seuils (ajouter Beige, Brown, Purple impose de nouvelles clés l10n dans 40 langues), ou ajouter une table des couleurs officielles Anycubic, comme celle de Bambu.
- **Casse non normalisée** : matériau « pla » sur un tag OpenSpool écrit en minuscules ; marque « ELEGOO » (registre TigerTag) à côté de « Elegoo » (décodeur Elegoo). Résultat : deux groupes distincts dans le stock pour la même marque.
- **Message de refus Snapmaker** : tant que la section 2 n'est pas faite, le refus en détection automatique parle de « bobine Bambu Lab ». Un message « marque non prise en charge » serait plus juste.

## 5. À confirmer sur de vrais tags et à surveiller en prod (nfcanycubic-7a)

Rien n'a pu être testé sur un vrai tag de ces marques (le user n'a que des tags Anycubic). Code et tests en place depuis la 1.4.10+93 :

- **Creality, lecture** (0cbd0f9, 54a25c7) : vraie bobine reconnue en mode Creality ET en auto-détection (clé dérivée = clé A), matériau / type / températures depuis la table officielle. Vérifié seulement sur le texte clair du tag OpenRFID « Hyper PLA Very Peri » et les 4 textes de K2-RFID#53.
- **Creality, écriture** (0cbd0f9) : disposition réelle + clés A et B du secteur 1 = clé dérivée sur un tag vierge (bits d'accès conservés, comme K2-RFID). À valider : tag écrit par l'app → lu par une imprimante K2 / CFS. Si l'imprimante le refuse, comparer le bloc 7 avec un tag écrit par K2-RFID.
- **OpenSpool long** (37fb3d2) : message NDEF > 160 octets lu en entier (Android et iOS). À valider sur un NTAG215/216 avec un JSON OpenSpool long.
- **Télémétrie des lectures suspectes** : chercher les événements `scan_nfc*` avec `out_of_range` ou `error_detail = UNRECOGNIZED_FORMAT`. Ils embarquent `raw_tag_data` (octets bruts du tag). Cas connu sans explication : buse 1205 sur un Anycubic PLA Translucent (1.4.6). Un dump permettra de corriger le décodeur concerné.
- **Recalage Anycubic d'un octet** (46c5a86) : déduit de 3 scans de prod (« LA », 58880, 16640), pas d'un dump. Confirmer avec un dump si un tag concerné repasse.
