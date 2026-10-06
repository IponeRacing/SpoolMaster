# 🚀 Guide de Déploiement Rapide

## ⚠️ CRITIQUE — Fichiers secrets à NE JAMAIS oublier

Ces fichiers sont **`.gitignore`** (absents du repo) mais **indispensables** au fonctionnement.
Ils doivent être présents sur le serveur après CHAQUE déploiement/migration, sinon des
fonctionnalités cassent silencieusement (déjà arrivé : vérif achats Android HS 3 semaines).

| Fichier serveur (`api/`) | Rôle | Source locale |
|---|---|---|
| `config/google-play-service-account.json` | **Vérif achats Google Play (Android)** — sans lui, tout achat Android est rejeté en 503 | `~/.private_keys/google-play-service-account.json` |
| `keys/AuthKey_*.p8` | Apple Sign In + App Store Server API | `ios/` (clés Apple) |
| `config/app.php` | Secrets JWT, CRON_SECRET, APPLE_SHARED_SECRET, etc. | à recréer/copier |
| `.env` | Config OAuth (APPLE_CLIENT_ID, GOOGLE_*, CRON_SECRET) | à recréer/copier |

**Après tout déploiement, VÉRIFIER leur présence :**
```bash
ssh ly9x5_fable@ly9x5.ftp.infomaniak.com
ls -la sites/engageengine.ch/api/config/google-play-service-account.json  # doit exister, chmod 600
ls -la sites/engageengine.ch/api/keys/*.p8
```
Si le service account manque : `scp ~/.private_keys/google-play-service-account.json ly9x5_fable@ly9x5.ftp.infomaniak.com:sites/engageengine.ch/api/config/` puis `chmod 600`.

Rappel : DNS géré chez **Cloudflare** (pas Infomaniak), IP serveur actuel = 185.176.225.13.

---

## Étape 1 : Générer la clé JWT

Sur ton ordinateur :

```bash
cd backend
php generate_secret.php
```

Copie la clé générée et colle-la dans `config/app.php` ligne 11.

## Étape 2 : Upload sur Infomaniak

### Via FTP (FileZilla / Cyberduck)

Connecte-toi avec :
- **Host** : ly9x5.ftp.infomaniak.com
- **User** : ton login Infomaniak
- **Password** : ton mot de passe

Upload tous les fichiers dans `~/sites/engageengine.ch/api/` :

```
/home/clients/ad4b552196d8fbd055d50f5a33f4a625/sites/engageengine.ch/
└── api/
    ├── config/
    ├── database/
    ├── keys/
    ├── logs/
    ├── public/
    ├── src/
    ├── vendor/ (après composer install)
    ├── composer.json
    └── .htaccess
```

## Étape 3 : Installer Composer (via SSH)

Connecte-toi en SSH à ton serveur Infomaniak :

```bash
ssh ton_user@ly9x5.ftp.infomaniak.com
cd ~/sites/engageengine.ch/api
```

Télécharge Composer :

```bash
curl -sS https://getcomposer.org/installer | php
```

Installe les dépendances :

```bash
php composer.phar install --no-dev --optimize-autoloader
```

## Étape 4 : Configurer le Document Root

Dans le panneau Infomaniak :

1. Va dans **Hébergement Web** → **Sites web**
2. Sélectionne `engageengine.ch`
3. Clique sur **Modifier**
4. Change le **Document Root** vers :

```
/home/clients/ad4b552196d8fbd055d50f5a33f4a625/sites/engageengine.ch/api/public
```

**OU** crée un sous-domaine `api.engageengine.ch` pointant vers ce dossier.

## Étape 5 : Tester l'API

Ouvre dans ton navigateur :

```
https://engageengine.ch/api/test.php
```

Tu dois voir :

```json
{
  "success": true,
  "message": "All tests passed! API is ready.",
  ...
}
```

Teste le health endpoint :

```
https://engageengine.ch/api/health
```

Réponse attendue :

```json
{
  "success": true,
  "status": "API is running",
  "version": "1.0.0"
}
```

## Étape 6 : Configurer OAuth (après déploiement)

### Apple Sign In

1. Va sur [developer.apple.com](https://developer.apple.com/)
2. Crée un **App ID** et un **Service ID**
3. Télécharge la clé privée `.p8`
4. Upload dans `/api/keys/`
5. Complète `config/app.php` :

```php
'apple' => [
    'client_id' => 'com.engageengine.nfcanycubic',
    'team_id' => 'TON_TEAM_ID',
    'key_id' => 'TON_KEY_ID',
    'private_key_path' => __DIR__ . '/../keys/AuthKey_XXXXX.p8',
],
```

### Google Sign In

1. Va sur [console.cloud.google.com](https://console.cloud.google.com/)
2. Crée un projet
3. Active **Google Sign-In API**
4. Crée des **OAuth 2.0 credentials**
5. Ajoute l'URL de callback :

```
https://engageengine.ch/api/auth/google/callback
```

6. Complète `config/app.php` :

```php
'google' => [
    'client_id' => 'XXXXX.apps.googleusercontent.com',
    'client_secret' => 'TON_CLIENT_SECRET',
    'redirect_uri' => 'https://engageengine.ch/api/auth/google/callback',
],
```

## Étape 7 : Sécurité Production

1. **Supprime** le fichier `public/test.php`
2. Force HTTPS : décommente dans `public/.htaccess` :

```apache
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

3. Limite les origines CORS dans `config/app.php` :

```php
'allowed_origins' => ['https://ton-app-flutter.com'],
```

## 🎉 C'est prêt !

Ton API est maintenant en ligne sur :

```
https://engageengine.ch/api/
```

**Endpoints disponibles :**
- `GET /health` - Health check
- `POST /auth/apple` - Login Apple
- `POST /auth/google` - Login Google
- Et tous les autres endpoints...

## ❓ En cas de problème

1. Vérifie les logs : `/api/logs/`
2. Vérifie les permissions : `755` pour dossiers, `644` pour fichiers
3. Vérifie que `mod_rewrite` est activé
4. Teste avec `curl -v https://engageengine.ch/api/health`

---

**Prochaine étape :** Intégrer l'API dans l'app Flutter !
