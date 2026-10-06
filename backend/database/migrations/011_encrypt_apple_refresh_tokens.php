<?php
// 011 : chiffre les jetons Sign in with Apple déjà stockés en clair
// (APP_ENCRYPTION_KEY doit être dans le .env). Idempotente.
// Usage, depuis api/ : php database/migrations/011_encrypt_apple_refresh_tokens.php
require __DIR__ . '/../../vendor/autoload.php';

\NfcAnycubic\EnvLoader::load();
$db = \NfcAnycubic\Database::getInstance()->getConnection();
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

if (!\NfcAnycubic\Services\TokenCipher::isConfigured()) {
    fwrite(STDERR, "APP_ENCRYPTION_KEY absente ou invalide : rien n'est fait.\n");
    exit(1);
}
$n = \NfcAnycubic\Services\TokenCipher::encryptStoredAppleTokens($db);
echo "Jetons Apple chiffrés : $n\n";
