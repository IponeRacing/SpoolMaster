# NFC Anycubic Backend API

API REST pour l'authentification et la synchronisation de l'application NFC Anycubic.

## 🚀 Installation sur Infomaniak

### 1. Upload des fichiers

Uploader tous les fichiers dans le dossier `/api/` de votre hébergement :

```
engageengine.ch/
└── api/
    ├── config/
    ├── database/
    ├── public/
    ├── src/
    ├── composer.json
    └── README.md
```

### 2. Configuration de la base de données

✅ **Déjà fait** : Le schéma SQL a été exécuté dans phpMyAdmin

### 3. Installer les dépendances PHP

Via SSH ou le terminal Infomaniak :

```bash
cd /home/clients/ad4b552196d8fbd055d5f05a33f4a625/api
composer install --no-dev --optimize-autoloader
```

**Si composer n'est pas disponible**, téléchargez `composer.phar` :

```bash
curl -sS https://getcomposer.org/installer | php
php composer.phar install --no-dev
```

### 4. Générer le JWT Secret

Éditer `config/app.php` ligne 11 et remplacer par :

```php
'jwt_secret' => 'VOTRE_CLE_SECRETE_64_CARACTERES_ALEATOIRES',
```

**Générer une clé sécurisée** :
```bash
php -r "echo bin2hex(random_bytes(32)) . PHP_EOL;"
```

Ou utiliser : `a7f8e9d4b2c1f6a8e3d5b9c2f1a4e7d8b3c6f2a9e1d4b7c3f6a2e8d5b1c9f4a7e3`

### 5. Configurer le DocumentRoot Apache

Dans le panneau Infomaniak, configurer le DocumentRoot du site vers :

```
/home/clients/ad4b552196d8fbd055d5f05a33f4a625/api/public
```

Ou créer un sous-domaine :
- `api.engageengine.ch` → `/home/.../api/public`

### 6. Tester l'API

```bash
curl https://engageengine.ch/api/health
```

Réponse attendue :
```json
{
  "success": true,
  "status": "API is running",
  "version": "1.0.0",
  "timestamp": 1704067200
}
```

## 🔐 Configuration OAuth

### Apple Sign In

1. Aller sur [Apple Developer](https://developer.apple.com/)
2. Créer un **Service ID** pour votre app
3. Télécharger la clé privée `.p8`
4. Compléter dans `config/app.php` :

```php
'apple' => [
    'client_id' => 'com.engageengine.nfcanycubic',
    'team_id' => 'VOTRE_TEAM_ID',
    'key_id' => 'VOTRE_KEY_ID',
    'private_key_path' => __DIR__ . '/../keys/AuthKey_XXXXX.p8',
],
```

### Google Sign In

1. Aller sur [Google Cloud Console](https://console.cloud.google.com/)
2. Créer un projet
3. Activer **Google Sign-In API**
4. Créer des **OAuth 2.0 credentials**
5. Ajouter `https://engageengine.ch/api/auth/google/callback` comme redirect URI
6. Compléter dans `config/app.php` :

```php
'google' => [
    'client_id' => 'VOTRE_CLIENT_ID.apps.googleusercontent.com',
    'client_secret' => 'VOTRE_CLIENT_SECRET',
    'redirect_uri' => 'https://engageengine.ch/api/auth/google/callback',
],
```

## 📡 Endpoints API

### Authentification

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/health` | Health check |
| `POST` | `/auth/apple` | Login avec Apple |
| `POST` | `/auth/google` | Login avec Google |
| `POST` | `/auth/refresh` | Refresh access token |

### Utilisateur (Auth requis)

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/user/profile` | Récupérer profil |
| `PUT` | `/user/profile` | Mettre à jour profil |
| `POST` | `/user/logout` | Déconnexion |
| `DELETE` | `/user/account` | Supprimer compte |

### Bobines (Auth requis)

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `GET` | `/spools` | Liste des bobines |
| `GET` | `/spools/:id` | Détail d'une bobine |
| `POST` | `/spools` | Créer bobine |
| `PUT` | `/spools/:id` | Modifier bobine |
| `DELETE` | `/spools/:id` | Supprimer bobine |

### Synchronisation (Auth requis)

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `POST` | `/sync/push` | Envoyer données locales |
| `POST` | `/sync/pull` | Récupérer données cloud |
| `GET` | `/sync/history` | Historique sync |

### Analytics (Auth requis)

| Méthode | Endpoint | Description |
|---------|----------|-------------|
| `POST` | `/analytics/track` | Enregistrer événement |

## 🔒 Sécurité

- ✅ JWT tokens avec expiration
- ✅ Révocation de tokens
- ✅ HTTPS obligatoire en production
- ✅ Protection CORS
- ✅ SQL injection protection (PDO prepared statements)
- ✅ Audit logs
- ✅ GDPR compliance (data deletion)

## 📝 Logs

Les logs sont stockés dans `logs/` (créer le dossier avec permissions 755)

## 🐛 Debugging

Pour activer le mode debug, éditer `public/index.php` :

```php
$_ENV['APP_DEBUG'] = true;
```

**⚠️ IMPORTANT :** Désactiver en production !

## 📞 Support

En cas de problème :
1. Vérifier les logs Apache
2. Vérifier les permissions (755 pour dossiers, 644 pour fichiers)
3. Vérifier que `mod_rewrite` est activé
4. Tester avec `curl -v https://engageengine.ch/api/health`
