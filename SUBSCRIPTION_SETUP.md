# 🔐 Configuration Système d'Abonnement Apple In-App Purchase

## ✅ Ce qui est FAIT

### 1. Backend PHP (Complet ✅)
- ✅ Table `subscriptions` avec support StoreKit 2
- ✅ Table `apple_notifications` pour audit trail
- ✅ Table `subscription_validation_failures` pour sécurité
- ✅ `SubscriptionController.php` avec validation JWS
- ✅ `AppleJWKHelper.php` pour conversion JWK→PEM
- ✅ Routes ajoutées dans `Router`
- ✅ Endpoint POST `/subscriptions/verify` - Valide les achats
- ✅ Endpoint GET `/subscriptions/status` - Récupère le statut
- ✅ Endpoint POST `/subscriptions/webhook` - Webhook Apple Server Notifications V2

### 2. Flutter App (Complet ✅)
- ✅ `SubscriptionService` avec StoreKit 2
- ✅ Interface d'abonnement dans `profile_page.dart`
- ✅ Intégration AdMob (masquage pubs si premium)
- ✅ Product IDs: `spool_master_monthly` et `spool_master_yearly`
- ✅ Bouton "Restaurer les achats"

### 3. Sécurité (Best Practices 2025 ✅)
- ✅ Vérification cryptographique JWS (pas besoin d'appeler Apple à chaque fois)
- ✅ Protection anti-replay attacks
- ✅ Protection anti-fraude (bundle ID, product ID validation)
- ✅ Audit logging complet
- ✅ Support tous les événements: SUBSCRIBED, DID_RENEW, EXPIRED, REFUND, REVOKE

---

## 🚧 Ce qu'il reste à FAIRE

### Étape 1: Base de données (5 min)

Exécute la migration SQL dans phpMyAdmin ou via SSH:

```bash
cd /path/to/backend
mysql -u username -p database_name < database/migrations/001_add_subscriptions.sql
```

**OU** via phpMyAdmin:
1. Se connecter à phpMyAdmin
2. Sélectionner la base de données
3. Onglet "SQL"
4. Copier le contenu de `backend/database/migrations/001_add_subscriptions.sql`
5. Exécuter

### Étape 2: Créer le dossier cache (1 min)

Le backend utilise un cache pour les clés publiques Apple:

```bash
cd /path/to/backend
mkdir -p cache
chmod 755 cache
```

### Étape 3: App Store Connect - Créer les abonnements (10 min)

1. Aller sur [App Store Connect](https://appstoreconnect.apple.com/)
2. Sélectionner ton app "Spool Master"
3. Aller dans **"Monetization" → "Subscriptions"**
4. Créer un nouveau groupe d'abonnement:
   - **Nom**: "Spool Master Premium"
   - **Référence**: "spool_master_group"

5. **Créer l'abonnement mensuel**:
   - **Product ID**: `spool_master_monthly` ⚠️ EXACT!
   - **Référence**: "Monthly Subscription"
   - **Prix**: 2 CHF/mois
   - **Durée**: 1 mois
   - **Essai gratuit**: Non (ou 7 jours si tu veux)
   - **Localizations**: Utilise les noms/descriptions que je t'ai fournis (32 langues)

6. **Créer l'abonnement annuel**:
   - **Product ID**: `spool_master_yearly` ⚠️ EXACT!
   - **Référence**: "Yearly Subscription"
   - **Prix**: 8 CHF/an
   - **Durée**: 1 an
   - **Essai gratuit**: Non (ou 1 mois si tu veux)
   - **Localizations**: Utilise les noms/descriptions que je t'ai fournis (32 langues)

7. **Soumettre pour review** (optionnel pour le sandbox)

### Étape 4: Configurer le Webhook Apple (10 min)

1. Dans App Store Connect → **"App Information"**
2. Aller dans **"App Store Server Notifications"**
3. Ajouter l'URL du webhook:
   ```
   https://api.engageengine.ch/subscriptions/webhook
   ```
4. Version: **Version 2** ⚠️ IMPORTANT
5. Environnement: **Production** ET **Sandbox** (2 webhooks séparés si nécessaire)

### Étape 5: Tester en Sandbox (30 min)

#### A. Créer un compte testeur Sandbox

1. App Store Connect → **"Users and Access" → "Sandbox Testers"**
2. Créer un nouveau testeur:
   - Email: `test1@exemple.com` (n'importe quel email fictif)
   - Mot de passe: xxxxxxx
   - Pays: Suisse

#### B. Tester sur un appareil iOS RÉEL

⚠️ **IMPORTANT**: Les In-App Purchases ne fonctionnent PAS sur le simulateur pour les abonnements!

1. **Déconnecte-toi** de ton vrai compte Apple:
   - Réglages → App Store → Se déconnecter

2. **Build l'app en debug**:
   ```bash
   flutter build ios --debug
   ```

3. **Lance l'app** et va dans Profile → VIP

4. **Clique sur "Spool Master Mensuel"**:
   - iOS va demander de se connecter
   - Utilise le compte **Sandbox** créé à l'étape A
   - Confirmation d'achat (gratuit en Sandbox!)

5. **Vérifie**:
   - Le statut passe à "ACTIF" dans l'app
   - Les publicités disparaissent
   - Dans les logs Xcode, tu dois voir:
     ```
     ✅ Premium activated!
     🌟 Premium status activated - Ads disabled
     ```

6. **Teste "Restaurer les achats"**:
   - Désinstalle l'app
   - Réinstalle
   - Va dans Profile → VIP → "Restaurer les achats"
   - Le statut premium doit revenir

#### C. Vérifier le Backend (Debug)

1. Vérifie les logs PHP (Apache ou Nginx)
2. Vérifie les tables:
   ```sql
   SELECT * FROM subscriptions WHERE user_id = 'TON_USER_ID';
   SELECT * FROM apple_notifications ORDER BY received_at DESC LIMIT 10;
   ```

---

## 📝 Notes Importantes

### StoreKit 2 vs StoreKit 1
- ✅ On utilise **StoreKit 2** (best practice 2025)
- ✅ Transactions automatiques (pas besoin de `finishTransaction`)
- ✅ JWS signed data (sécurité cryptographique)

### Webhook Apple Server Notifications V2
- Apple envoie automatiquement des notifications pour:
  - ✅ Nouveau abonnement (`SUBSCRIBED`)
  - ✅ Renouvellement (`DID_RENEW`)
  - ✅ Expiration (`EXPIRED`)
  - ✅ Remboursement (`REFUND`)
  - ✅ Échec de paiement (`DID_FAIL_TO_RENEW`)
  - ✅ Période de grâce (`GRACE_PERIOD_EXPIRED`)

### Sandbox vs Production
- **Sandbox**: Pour tester, achats gratuits, renouvellements accélérés (1 mois = 5 minutes!)
- **Production**: Vrais achats, vrais utilisateurs

### Renouvellements automatiques
- Apple gère automatiquement les renouvellements
- Le webhook reçoit les notifications
- Le statut premium est mis à jour automatiquement

---

## 🐛 Troubleshooting

### "Product not found"
- ✅ Vérifie que le Product ID est **EXACT**: `spool_master_monthly` ou `spool_master_yearly`
- ✅ Vérifie que l'abonnement est actif dans App Store Connect
- ✅ Attends 2-3 heures après création (propagation Apple)
- ✅ Teste en Sandbox d'abord

### "Invalid signature"
- ✅ Vérifie que le dossier `backend/cache` existe et est writable
- ✅ Vérifie les logs PHP pour voir l'erreur exacte
- ✅ Vérifie que `curl` est activé dans PHP

### "Webhook not received"
- ✅ Vérifie que l'URL webhook est accessible publiquement
- ✅ Teste avec `curl -X POST https://api.engageengine.ch/subscriptions/webhook`
- ✅ Vérifie les logs Apache/Nginx
- ✅ Vérifie que le firewall ne bloque pas Apple (IPs: https://developer.apple.com/support/server-notifications/)

### "Premium status not syncing"
- ✅ Vérifie la table `user_preferences.is_vip`
- ✅ Vérifie que l'utilisateur est connecté (JWT token)
- ✅ Force un refresh de l'app

---

## 📞 Support

Si un problème persiste:
1. ✅ Vérifie les logs iOS (Xcode console)
2. ✅ Vérifie les logs backend (`backend/logs/`)
3. ✅ Vérifie la table `subscription_validation_failures` pour voir les erreurs
4. ✅ Vérifie la table `apple_notifications` pour voir si Apple envoie des notifs

---

## 🎉 Une fois que tout fonctionne

Félicitations ! Tu as maintenant un système d'abonnement Apple **production-ready** avec:
- ✅ Validation serveur sécurisée (best practice 2025)
- ✅ Protection anti-fraude
- ✅ Webhooks Apple Server Notifications V2
- ✅ Audit trail complet
- ✅ Support du restore automatique
- ✅ Synchronisation premium status
- ✅ Masquage automatique des publicités

**Prochaine étape**: Soumettre l'app à Apple pour review! 🚀
