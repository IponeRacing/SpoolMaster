<?php
/**
 * Sign in with Apple — API REST (échange du code d'autorisation, révocation).
 *
 * Apple exige (Guideline 5.1.1(v)) que la suppression de compte révoque les
 * jetons Sign in with Apple. Pour pouvoir révoquer, il faut le refresh_token
 * Apple, obtenu en échangeant l'authorizationCode envoyé par l'app au login.
 *
 * client_id = BUNDLE ID de l'app (jetons natifs iOS : aud = bundle id), pas
 * l'identifiant de service web. client_secret = JWT ES256 signé avec la clé
 * Sign in with Apple (keys/AuthKey_<APPLE_KEY_ID>.p8).
 */

namespace NfcAnycubic\Services;

use Firebase\JWT\JWT;
use NfcAnycubic\Logger;

class AppleSignInService {

    private const APPLE_AUDIENCE = 'https://appleid.apple.com';
    private const TOKEN_URL = 'https://appleid.apple.com/auth/token';
    private const REVOKE_URL = 'https://appleid.apple.com/auth/revoke';

    private string $teamId;
    private string $keyId;
    private string $clientId;
    private string $keyPath;

    public function __construct(?array $appleConfig = null) {
        if ($appleConfig === null) {
            $config = require __DIR__ . '/../../config/app.php';
            $appleConfig = $config['oauth']['apple'];
        }
        $this->teamId = (string)$appleConfig['team_id'];
        $this->keyId = (string)$appleConfig['key_id'];
        // Jetons natifs iOS : aud = bundle id
        $this->clientId = (string)$appleConfig['bundle_id'];
        $this->keyPath = (string)$appleConfig['private_key_path'];
    }

    /** JWT client_secret (valable 5 min, ES256). */
    public function clientSecret(): ?string {
        if (!is_readable($this->keyPath)) {
            Logger::warning('apple.siwa', 'Clé Sign in with Apple introuvable', ['key_id' => $this->keyId]);
            return null;
        }
        $now = time();
        return JWT::encode([
            'iss' => $this->teamId,
            'iat' => $now,
            'exp' => $now + 300,
            'aud' => self::APPLE_AUDIENCE,
            'sub' => $this->clientId,
        ], file_get_contents($this->keyPath), 'ES256', $this->keyId);
    }

    /**
     * Échange l'authorizationCode (usage unique, 5 min) contre un refresh_token.
     * Retourne null en cas d'échec (le login ne doit jamais en dépendre).
     */
    public function exchangeCode(string $authorizationCode): ?string {
        $secret = $this->clientSecret();
        if ($secret === null) return null;
        $res = $this->post(self::TOKEN_URL, [
            'client_id' => $this->clientId,
            'client_secret' => $secret,
            'code' => $authorizationCode,
            'grant_type' => 'authorization_code',
        ]);
        if ($res['status'] === 200 && !empty($res['json']['refresh_token'])) {
            return (string)$res['json']['refresh_token'];
        }
        Logger::warning('apple.siwa', 'Échange du code Apple refusé', [
            'http_status' => $res['status'],
            'error' => $res['json']['error'] ?? $res['error'],
        ]);
        return null;
    }

    /** Révoque un refresh_token Apple. true si Apple confirme (HTTP 200). */
    public function revoke(string $refreshToken): bool {
        $secret = $this->clientSecret();
        if ($secret === null) return false;
        $res = $this->post(self::REVOKE_URL, [
            'client_id' => $this->clientId,
            'client_secret' => $secret,
            'token' => $refreshToken,
            'token_type_hint' => 'refresh_token',
        ]);
        if ($res['status'] !== 200) {
            Logger::warning('apple.siwa', 'Révocation Apple refusée', [
                'http_status' => $res['status'],
                'error' => $res['json']['error'] ?? $res['error'],
            ]);
        }
        return $res['status'] === 200;
    }

    /** @return array{status:int, json:?array, error:?string} */
    private function post(string $url, array $fields): array {
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => http_build_query($fields),
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 8,
            CURLOPT_HTTPHEADER => ['Content-Type: application/x-www-form-urlencoded'],
        ]);
        $body = curl_exec($ch);
        $status = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = $body === false ? curl_error($ch) : null;
        $json = is_string($body) ? json_decode($body, true) : null;
        return ['status' => $status, 'json' => is_array($json) ? $json : null, 'error' => $error];
    }
}
