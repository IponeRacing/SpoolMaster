# Spool Master — TODO

_Dernière mise à jour : 2026-08-17_

## 🔴 Urgent — deadline

- [ ] **Sortir la 1.3.5 avec Google Play Billing 8.0 avant le 31 août 2026**
  - Code déjà prêt et committé (`afc1e2b`) : `in_app_purchase 3.3.0` / `in_app_purchase_android 0.5.2` (Billing 8) / `in_app_purchase_storekit 0.4.11+1`. Aucun changement de code, iOS+Android buildent, tests verts.
  - Attendre que la review de la 1.3.4 (build 72) soit validée avant de packager la 1.3.5.
  - **Avant de soumettre** : idéalement 1 test d'achat sandbox sur un vrai Android (ça touche le paiement).
  - Rappel : la 1.3.4 utilise encore Billing 7 — acceptée car soumise avant la deadline, mais c'est la dernière qui peut passer sans Billing 8.

## 🟡 À faire (sans deadline)

- [ ] **Persister le service account Google Play dans le process de déploiement backend**
  - Fichier `config/google-play-service-account.json` : déposé à la main sur le serveur le 30/07, mais `gitignore` (absent du repo). Serait reperdu à la prochaine migration serveur ou redéploiement FTP → la vérif d'achats Android recasserait pour tout le monde.
  - Service account = `fastlane-play@motsmagiquesplaystorelive.iam.gserviceaccount.com` (toutes les autorisations confirmées côté Play Console le 17/08).
  - Adapter `backend/DEPLOIEMENT.md` pour inclure cette étape.

- [ ] **Répondre au client Fricke** (mail DE)
  - iOS (iPhone18,2, iOS 26.6). VIP jusqu'au 2028-07-02.
  - Ses 3 retours d'août tous corrigés en 1.3.4 : fix mise à jour stock, fix centrage home, feature quantité multiple + regroupement.

- [ ] **Répondre au client Jostein** (yorasm@gmail.com, mail EN)
  - Android. Bug pubs/achat corrigé (service account Google Play déployé). VIP jusqu'au 2027-07-29 (+1 an offert).

## 🔵 Flow achats Android — modernisation recommandée (pas de deadline)

_Revue faite le 17/08/2026. Le flow est sain et à jour sur l'axe critique (Billing 8, RTDN, vérif serveur, acquittement, gate login). Écarts recommandés uniquement :_

- [ ] **Serveur : passer de l'API v3 `purchases.subscriptions.get` à `purchases.subscriptionsv2.get`**
  - Fichier : `backend/src/Controllers/SubscriptionController.php` (~ligne 253). Actuellement lit `expiryTimeMillis`/`paymentState` (ancien modèle).
  - v2 = modèle base plans/offers (défaut Play Console), renvoie `subscriptionState`, `lineItems[].expiryTime`, `acknowledgementState`.
  - **La v3 n'est pas dépréciée, fonctionne aujourd'hui.** À faire proprement AVEC un test d'achat Android réel (touche le paiement) — ne pas migrer à l'aveugle.

- [ ] **Client : passer `applicationUserName` (obfuscatedAccountId) au `PurchaseParam`**
  - Fichier : `subscription_service.dart` `purchaseSubscription()` (~ligne 142). Aujourd'hui `PurchaseParam(productDetails: product)` sans user id.
  - Améliore la détection de fraude Google + corrélation RTDN. Nécessite de plomber le userId hashé jusqu'à l'achat. Faible valeur/effort, optionnel.

## 🔵 Observabilité scans — angle mort connu (23/08/2026)

- [ ] **Les scans des utilisateurs NON connectés ne sont pas loggués.**
  - Client (`analytics_service.dart` `logEvent`) passe par `authenticatedRequest` → throw « Not authenticated » sans token → event jamais envoyé. Backend (`AnalyticsController::logEvent`) : `if (!$userId) return;`.
  - Conséquence : les échecs de scan des non-connectés (nombreux, l'app scanne sans compte) sont invisibles en DB → diagnostic partiel.
  - Fix = autoriser l'analytics anonyme : backend accepter events sans user (user_id nullable + retirer la FK, ou device_id anonyme) + client envoyer sans auth si non connecté. **Changement de schéma sur DB live = à faire prudemment.**
  - Fait le 23/08 : ajout `entry_point` (home/add_spool/stock_update) aux events + au mail d'alerte d'échec (déployé). Capté automatiquement (event_data = JSON). Visible dès que les users passent en 1.3.6+.

## 🟣 Nouveaux formats NFC (recherche 23/08/2026 — rien de cassant)

- [x] **TigerTag AJOUTÉ** (commit) : parseur + registres 113 matériaux/132 marques + 6 tests. Reste optionnel : signature ECDSA (skip), refresh registres via API.
  - NTAG21x, 144 bytes, pages 0x04-0x27, big-endian, non chiffré (signature ECDSA-P256 optionnelle → parser les données sans vérifier). Lisible iOS+Android.
  - C'est ainsi que **Sunlu, eSUN, Rosa3D, Landu, JamgHE, Nanovia** taggent maintenant (2.5M+ puces).
  - **Prérequis : récupérer le layout byte exact** depuis github.com/TigerTag-Project/TigerTag-RFID-Guide (offsets material/color/temps/weight) AVANT d'implémenter — ne pas coder à l'aveugle. + tests.
- [ ] OpenPrintTag : ajouter champs `primary_color_lab/ral` + achat, tolérer ICODE SLIX 112B (mineur ; PA612 déjà géré).
- [ ] OpenTag3D : mettre à jour le lien repo → GooborgStudios/OpenTag3D (cosmétique ; parseur 1.001 déjà compatible).
- Rien à faire : Bambu, Creality, OpenSpool, Elegoo (déjà structuré), iOS/Android (inchangés).

## 🟢 Plan de maintenance dépendances/toolchain (audit 24/08/2026)

_Aucune urgence/deadline. Toolchain saine : Kotlin 2.2.20, AGP 8.12.1, Gradle 8.14, targetSdk 35 (OK jusqu'à août 2027), iOS 15.0. À faire par vagues, chacune suivie de la suite de tests + build 2 plateformes._

**Vague 1 — sûr, à faire en premier (patchs, faible risque)**
- [ ] Flutter 3.44 → 3.47.1 (SDK/Dart, correctifs sécu). Faire un `flutter test` + build complet après (peut changer le comportement de build).
- [ ] Firebase patchs : `firebase_core` 4.9→4.13, `firebase_crashlytics` 5.2.2→5.2.7.
- [ ] `sign_in_with_apple` 8.0→8.1, `equatable` 2.0.8→2.1.0, `path_provider`, `url_launcher_android`, `shared_preferences_android`, `google_sign_in_android` (patchs).
- [ ] Dev deps : `build_runner` 2.16, `json_serializable`, `injectable_generator`, `very_good_analysis` 10.3 (relancer `dart run build_runner build`).

**Vague 1 — FAITE le 24/08 (committée).** firebase 4.13, apple 8.1, equatable 2.1, patchs plateforme, dev deps, code régénéré.

**Vague 2 — TENTÉE le 24/08, toute BLOQUÉE (revert propre) :**
- [ ] `google_mobile_ads` 8 → 9 : **BLOQUÉ** — 9.1 casse le build iOS (Google-Mobile-Ads-SDK 13.7/13.8 header beta non-modulaire `GoogleMobileAds_Beta.h`). Attendre un patch du plugin. Resté en 8 (stable). Réglage `CLANG_ALLOW_NON_MODULAR_INCLUDES` déjà ajouté au Podfile pour le jour où.
- [ ] `flutter_secure_storage` 11 + `package_info_plus` 10 + `device_info_plus` 13 : **BLOQUÉS ENSEMBLE** — secure_storage 11 exige **compileSdk 37** (Android très récent, on est en 36) et les 3 sont liés par `win32 ^6`. Restés en 10/9/11.
  - → **Ces 3 se débloqueront avec l'upgrade Flutter/compileSdk (via FVM).** À refaire dans la même passe que le SDK, PAS avant.

**FAIT le 24/08 : projet pinné Flutter 3.47.1 via FVM** (`.fvmrc`, per-projet). Utiliser `fvm flutter ...` désormais. Build vert 2 plateformes + 37 tests.
⚠️ **AVANT de shipper une release sur 3.47 : smoke test sur vrai device (scan NFC + achat IAP)** — jamais testé en runtime sur 3.47.

**Le trio majeur reste BLOQUÉ même sur 3.47** :
- secure_storage 11 + package_info 10 : OK sur 3.47 (compileSdk 37) MAIS liés par win32 ^6 à device_info_plus qui doit alors être 13.
- **device_info_plus 13 casse le build iOS** (`isiOSAppOnVision`, sélecteur visionOS absent du SDK Xcode courant → il faudrait un Xcode plus récent OU bumper le deployment target iOS).
- → Trio en attente d'un fix iOS de device_info_plus (ou d'un Xcode plus récent). google_mobile_ads 9 idem (attendre patch header).

**Deadlines calendrier (rappel)**
- Août 2027 : targetSdk 36 (Android 16) requis par Google Play → un upgrade Flutter le règlera.
- ~avril chaque année : dernier SDK Apple (garder Xcode à jour).

## ✅ Fait récemment (contexte)

- 1.3.4 (build 72) déployée le 17/08 : iOS en review Apple, Android promu en production Google.
- Contenu 1.3.4 : fix bannière pub (activation premium), vérif achats Google Play réparée (service account déployé), fix stock/centrage/quantité (Fricke), carte « Auto-détection toutes marques », header `X-App-Version`, 40 langues.
- targetSdk 35 (Android 15) : déjà conforme. iOS deployment 15.0.

## 🟣 Reconnaissance des tags — roadmap (analyse 26/08/2026)

**Conclusion clé (recherche web + réalité des formats) :** un **lookup crowdsourcé raw→filament servi aux users = À ABANDONNER** (redondant/inefficace) :
- **Chiffré** (Bambu/Creality/Qidi, MiFare Classic) : raw non décodable sans clé, unique par tag → impossible à crowdsourcer.
- **Registry** (TigerTag) : le tag ne stocke que des IDs → refresh l'API, pas crowdsourcer.
- **Open** (OpenSpool/OpenTag3D/OpenPrintTag) : auto-descriptif → implémenter le parseur.
- **Métadonnée filament** : déjà couverte par la communauté (FilaMan : 24k filaments / 926 marques / API REST).

**Ce qui bouge vraiment l'aiguille (par impact) :**
- [x] **1. Parseur TigerTag** — FAIT (commit `a70b343`, part en 1.4.7). 2,5M puces (Sunlu/eSUN/Rosa3D/Landu…), NTAG21x plain, iOS+Android.
- [x] **2. Refresh registre TigerTag** — FAIT (`tool/refresh_tigertag_registry.py`, CC0). Relancer périodiquement.
- [x] **3. Intégrer FilaMan** — FAIT en **snapshot bundlé** (`tool/build_filament_library.py` → `filament_library.dart`, 377 marques + 143 matériaux, FilaMan+TigerTag+connus) + `FilamentAutocompleteField` câblé sur l'ajout manuel. PAS de dépendance runtime (API FilaMan undocumented = fragile). Follow-up optionnel : autocomplete aussi sur le formulaire de feedback ; API FilaMan officielle (sync 24k temps réel) si accès obtenu.
- [ ] **4. Corpus dev des tags inconnus** (PAS user-facing) : structurer les `scan_feedback` (raw + `tag_tech` + UID/SAK/ATQA + parseurs échoués) dans une table interrogeable au lieu des emails → repérer/reverse-engineerer un nouveau format propriétaire plain. Faible priorité (niche).

**Abandonné :** table `tag_library` crowdsourcée + auto-reconnaissance user (le plan initial) — voir conclusion ci-dessus.
