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

**Ordre correct de la suite** : (1) FVM + Flutter 3.47 (monte compileSdk) → (2) refaire secure_storage 11 / package_info 10 / device_info 13 → (3) google_mobile_ads 9 quand le plugin corrige le header. Tester login/token, pubs, analytics à chaque fois.

**Deadlines calendrier (rappel)**
- Août 2027 : targetSdk 36 (Android 16) requis par Google Play → un upgrade Flutter le règlera.
- ~avril chaque année : dernier SDK Apple (garder Xcode à jour).

## ✅ Fait récemment (contexte)

- 1.3.4 (build 72) déployée le 17/08 : iOS en review Apple, Android promu en production Google.
- Contenu 1.3.4 : fix bannière pub (activation premium), vérif achats Google Play réparée (service account déployé), fix stock/centrage/quantité (Fricke), carte « Auto-détection toutes marques », header `X-App-Version`, 40 langues.
- targetSdk 35 (Android 15) : déjà conforme. iOS deployment 15.0.
