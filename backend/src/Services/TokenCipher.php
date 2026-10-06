<?php
/**
 * Chiffrement des jetons stockés en base (AES-256-GCM, clé APP_ENCRYPTION_KEY).
 *
 * La politique de confidentialité annonce des « tokens chiffrés » : le jeton
 * de rafraîchissement Sign in with Apple était pourtant stocké en clair.
 *
 * Format : « enc:v1: » + base64(nonce 12 octets | tag 16 octets | chiffré).
 * Une valeur sans ce préfixe est un ancien jeton en clair : decrypt() la
 * renvoie telle quelle (migration : database/migrations/010_encrypt_apple_refresh_tokens.php).
 */

namespace NfcAnycubic\Services;

class TokenCipher {
    private const PREFIX = 'enc:v1:';

    /** Clé injectée par les tests ; sinon lue dans la configuration. */
    public static ?string $key = null;

    private static function key(): ?string {
        if (self::$key !== null) {
            return self::$key;
        }
        $config = require __DIR__ . '/../../config/app.php';
        $raw = \base64_decode((string)($config['encryption_key'] ?? ''), true);
        return ($raw !== false && \strlen($raw) === 32) ? $raw : null;
    }

    public static function isConfigured(): bool {
        return self::key() !== null;
    }

    public static function isEncrypted(?string $value): bool {
        return $value !== null && \str_starts_with($value, self::PREFIX);
    }

    /** Chiffre $plain ; lève une exception si la clé manque (jamais de repli en clair). */
    public static function encrypt(string $plain): string {
        $key = self::key();
        if ($key === null) {
            throw new \RuntimeException('APP_ENCRYPTION_KEY absente ou invalide (32 octets en base64)');
        }
        $nonce = \random_bytes(12);
        $tag = '';
        $cipher = \openssl_encrypt($plain, 'aes-256-gcm', $key, OPENSSL_RAW_DATA, $nonce, $tag);
        if ($cipher === false) {
            throw new \RuntimeException('Chiffrement impossible');
        }
        return self::PREFIX . \base64_encode($nonce . $tag . $cipher);
    }

    /**
     * Chiffre les jetons Apple encore en clair (migration 011). Idempotent :
     * les valeurs déjà chiffrées sont ignorées. Retourne le nombre chiffré.
     */
    public static function encryptStoredAppleTokens(\PDO $db): int {
        $rows = $db->query(
            "SELECT user_id, apple_refresh_token FROM users
              WHERE apple_refresh_token IS NOT NULL AND apple_refresh_token <> ''
                AND apple_refresh_token NOT LIKE 'enc:%'"
        )->fetchAll(\PDO::FETCH_ASSOC);
        $update = $db->prepare("UPDATE users SET apple_refresh_token = ? WHERE user_id = ? AND apple_refresh_token = ?");
        $done = 0;
        foreach ($rows as $row) {
            $update->execute([self::encrypt($row['apple_refresh_token']), $row['user_id'], $row['apple_refresh_token']]);
            $done += $update->rowCount();
        }
        return $done;
    }

    /** Déchiffre ; null si la valeur est corrompue ou la clé fausse. */
    public static function decrypt(?string $value): ?string {
        if ($value === null || $value === '') {
            return null;
        }
        if (!self::isEncrypted($value)) {
            return $value; // ancien jeton en clair
        }
        $key = self::key();
        $raw = \base64_decode(\substr($value, \strlen(self::PREFIX)), true);
        if ($key === null || $raw === false || \strlen($raw) < 29) {
            return null;
        }
        $plain = \openssl_decrypt(\substr($raw, 28), 'aes-256-gcm', $key, OPENSSL_RAW_DATA,
            \substr($raw, 0, 12), \substr($raw, 12, 16));
        return $plain === false ? null : $plain;
    }
}
