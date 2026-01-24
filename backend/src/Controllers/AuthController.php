<?php
/**
 * Contrôleur d'authentification
 * Gère Apple Sign In et Google Sign In
 * Conforme aux standards 2025-2026
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\JWTHandler;
use NfcAnycubic\Middleware\RateLimiter;

class AuthController {

    /**
     * Login avec Apple Sign In
     * POST /auth/apple
     * Body: { "identityToken": "...", "authorizationCode": "...", "user": {...} }
     */
    public function loginWithApple() {
        // Rate limiting for authentication attempts
        if (!RateLimiter::checkSensitive()) {
            return $this->error('Too many login attempts. Please wait before retrying.', 429);
        }

        $input = json_decode(file_get_contents('php://input'), true);

        if (!isset($input['identityToken'])) {
            return $this->error('Missing identityToken', 400);
        }

        try {
            // Décoder et vérifier le token Apple
            $appleData = $this->verifyAppleToken($input['identityToken']);

            if (!$appleData) {
                return $this->error('Invalid Apple token', 401);
            }

            // Extraire les données utilisateur
            $providerId = $appleData['sub']; // Apple User ID
            $email = $appleData['email'] ?? $input['user']['email'] ?? null;
            $name = $input['user']['name'] ?? null;

            // Créer ou mettre à jour l'utilisateur
            $user = $this->createOrUpdateUser([
                'provider' => 'apple',
                'provider_id' => $providerId,
                'email' => $email,
                'name' => $name,
                'email_verified' => $appleData['email_verified'] ?? true,
            ]);

            // Générer les tokens JWT
            $jwt = new JWTHandler();
            $accessToken = $jwt->generateToken($user);
            $refreshToken = $jwt->generateRefreshToken($user['user_id']);

            // Logger la connexion
            $this->logAudit($user['user_id'], 'login', 'apple');

            return [
                'success' => true,
                'data' => [
                    'user' => $user,
                    'access_token' => $accessToken,
                    'refresh_token' => $refreshToken,
                    'expires_in' => 2592000 // 30 jours
                ]
            ];

        } catch (\Exception $e) {
            error_log("Apple login error: " . $e->getMessage());
            return $this->error('Authentication failed: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Login avec Google Sign In
     * POST /auth/google
     * Body: { "idToken": "..." }
     */
    public function loginWithGoogle() {
        // Rate limiting for authentication attempts
        if (!RateLimiter::checkSensitive()) {
            return $this->error('Too many login attempts. Please wait before retrying.', 429);
        }

        $input = json_decode(file_get_contents('php://input'), true);

        if (!isset($input['idToken'])) {
            return $this->error('Missing idToken', 400);
        }

        try {
            // Vérifier le token Google
            $googleData = $this->verifyGoogleToken($input['idToken']);

            if (!$googleData) {
                return $this->error('Invalid Google token', 401);
            }

            // Créer ou mettre à jour l'utilisateur
            $user = $this->createOrUpdateUser([
                'provider' => 'google',
                'provider_id' => $googleData['sub'],
                'email' => $googleData['email'],
                'name' => $googleData['name'] ?? null,
                'avatar_url' => $googleData['picture'] ?? null,
                'email_verified' => $googleData['email_verified'] ?? false,
            ]);

            // Générer les tokens JWT
            $jwt = new JWTHandler();
            $accessToken = $jwt->generateToken($user);
            $refreshToken = $jwt->generateRefreshToken($user['user_id']);

            // Logger la connexion
            $this->logAudit($user['user_id'], 'login', 'google');

            return [
                'success' => true,
                'data' => [
                    'user' => $user,
                    'access_token' => $accessToken,
                    'refresh_token' => $refreshToken,
                    'expires_in' => 2592000
                ]
            ];

        } catch (\Exception $e) {
            error_log("Google login error: " . $e->getMessage());
            return $this->error('Authentication failed: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Refresh access token
     * POST /auth/refresh
     * Body: { "refresh_token": "..." }
     */
    public function refreshToken() {
        $input = json_decode(file_get_contents('php://input'), true);

        if (!isset($input['refresh_token'])) {
            return $this->error('Missing refresh_token', 400);
        }

        try {
            $jwt = new JWTHandler();
            $decoded = $jwt->verifyToken($input['refresh_token']);

            if (!$decoded || $decoded->type !== 'refresh') {
                return $this->error('Invalid refresh token', 401);
            }

            // Récupérer l'utilisateur
            $db = Database::getInstance()->getConnection();
            $stmt = $db->prepare("SELECT * FROM users WHERE user_id = :user_id LIMIT 1");
            $stmt->execute(['user_id' => $decoded->data->user_id]);
            $user = $stmt->fetch();

            if (!$user) {
                return $this->error('User not found', 404);
            }

            // Générer de nouveaux tokens
            $newAccessToken = $jwt->generateToken($user);
            $newRefreshToken = $jwt->generateRefreshToken($user['user_id']);

            return [
                'success' => true,
                'data' => [
                    'access_token' => $newAccessToken,
                    'refresh_token' => $newRefreshToken,
                    'expires_in' => 2592000
                ]
            ];

        } catch (\Exception $e) {
            return $this->error('Token refresh failed', 401);
        }
    }

    /**
     * Verify an Apple Identity Token (JWT)
     * Compliant with Apple Sign In requirements 2025-2026
     *
     * @see https://developer.apple.com/documentation/sign_in_with_apple/sign_in_with_apple_rest_api/verifying_a_user
     */
    private function verifyAppleToken(string $identityToken): ?array {
        try {
            $parts = explode('.', $identityToken);
            if (count($parts) !== 3) {
                error_log("Apple token: Invalid JWT format (not 3 parts)");
                return null;
            }

            // Decode header to get key ID (kid)
            $header = json_decode(base64_decode(strtr($parts[0], '-_', '+/')), true);
            if (!$header || !isset($header['kid'])) {
                error_log("Apple token: No kid in header");
                return null;
            }

            // Decode payload first for claim validation
            $payload = json_decode(base64_decode(strtr($parts[1], '-_', '+/')), true);
            if (!$payload) {
                error_log("Apple token: Failed to decode payload");
                return null;
            }

            // Get config for validation
            $config = require __DIR__ . '/../../config/app.php';
            $expectedClientId = $config['oauth']['apple']['client_id'];
            $expectedBundleId = $config['oauth']['apple']['bundle_id'];

            // Validate issuer
            if (!isset($payload['iss']) || $payload['iss'] !== 'https://appleid.apple.com') {
                error_log("Apple token: Invalid issuer: " . ($payload['iss'] ?? 'not set'));
                return null;
            }

            // Validate audience (must match our client_id or bundle_id)
            if (!isset($payload['aud'])) {
                error_log("Apple token: Missing audience");
                return null;
            }

            // Log for debugging
            error_log("Apple token: aud=" . $payload['aud'] . ", expected client_id=$expectedClientId, bundle_id=$expectedBundleId");

            // Accept both client_id and bundle_id as valid audience
            $validAudiences = [$expectedClientId, $expectedBundleId];
            if (!in_array($payload['aud'], $validAudiences)) {
                error_log("Apple token: Audience mismatch. Got: " . $payload['aud'] .
                         ", Expected one of: " . implode(', ', $validAudiences));
                return null;
            }

            // Validate expiration
            if (!isset($payload['exp']) || $payload['exp'] < time()) {
                error_log("Apple token: Token expired");
                return null;
            }

            // Validate issued at (not in the future)
            if (isset($payload['iat']) && $payload['iat'] > time() + 60) {
                error_log("Apple token: Token issued in the future");
                return null;
            }

            // Fetch Apple's public key and verify signature
            $cacheDir = __DIR__ . '/../../cache';
            if (!is_dir($cacheDir)) {
                mkdir($cacheDir, 0755, true);
            }
            $cacheFile = $cacheDir . '/apple_identity_jwks.json';

            $publicKeyPem = \NfcAnycubic\AppleJWKHelper::getApplePublicKeyPem($header['kid'], $cacheFile);
            if (!$publicKeyPem) {
                error_log("Apple token: Could not fetch public key for kid: " . $header['kid']);
                return null;
            }

            // Verify the signature
            $dataToVerify = $parts[0] . '.' . $parts[1];
            $signature = base64_decode(strtr($parts[2], '-_', '+/'));

            // Apple uses ES256 (ECDSA with P-256 and SHA-256)
            $publicKey = openssl_pkey_get_public($publicKeyPem);
            if (!$publicKey) {
                error_log("Apple token: Failed to parse public key");
                return null;
            }

            // For ES256, we need to convert the signature from JWS format to DER format
            $derSignature = $this->convertEs256SignatureToDer($signature);
            if (!$derSignature) {
                error_log("Apple token: Failed to convert signature format");
                return null;
            }

            $verified = openssl_verify($dataToVerify, $derSignature, $publicKey, OPENSSL_ALGO_SHA256);

            if ($verified !== 1) {
                error_log("Apple token: Signature verification failed. OpenSSL error: " . openssl_error_string());
                return null;
            }

            error_log("Apple token: Successfully verified for sub: " . ($payload['sub'] ?? 'unknown'));
            return $payload;

        } catch (\Exception $e) {
            error_log("Apple token verification exception: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Convert ES256 signature from JWS format (r||s) to DER format
     * JWS uses raw concatenation of r and s (32 bytes each)
     * OpenSSL expects DER-encoded signature
     */
    private function convertEs256SignatureToDer(string $signature): ?string {
        if (strlen($signature) !== 64) {
            error_log("ES256 signature: Invalid length " . strlen($signature) . ", expected 64");
            return null;
        }

        $r = substr($signature, 0, 32);
        $s = substr($signature, 32, 32);

        // Remove leading zeros but keep at least one byte
        $r = ltrim($r, "\x00");
        $s = ltrim($s, "\x00");

        // Handle empty case (all zeros - very rare)
        if (strlen($r) === 0) $r = "\x00";
        if (strlen($s) === 0) $s = "\x00";

        // Add leading zero if high bit is set (to make it positive)
        if (ord($r[0]) & 0x80) {
            $r = "\x00" . $r;
        }
        if (ord($s[0]) & 0x80) {
            $s = "\x00" . $s;
        }

        // DER encode: SEQUENCE { INTEGER r, INTEGER s }
        $derR = "\x02" . chr(strlen($r)) . $r;
        $derS = "\x02" . chr(strlen($s)) . $s;
        $der = "\x30" . chr(strlen($derR) + strlen($derS)) . $derR . $derS;

        return $der;
    }

    /**
     * Verify a Google Identity Token
     * Uses Google's tokeninfo endpoint for secure verification
     *
     * @see https://developers.google.com/identity/sign-in/web/backend-auth
     */
    private function verifyGoogleToken(string $idToken): ?array {
        try {
            $config = require __DIR__ . '/../../config/app.php';
            $acceptedClientIds = $config['oauth']['google']['accepted_client_ids'] ?? [];

            // Add main client_id to accepted list if not empty
            if (!empty($config['oauth']['google']['client_id'])) {
                $acceptedClientIds[] = $config['oauth']['google']['client_id'];
            }
            $acceptedClientIds = array_unique($acceptedClientIds);

            // Basic format validation
            $parts = explode('.', $idToken);
            if (count($parts) !== 3) {
                error_log('Google token: Invalid JWT format (not 3 parts)');
                return null;
            }

            // Verify token using Google's tokeninfo endpoint
            // This is the recommended approach as it handles key rotation automatically
            $tokenInfoUrl = 'https://oauth2.googleapis.com/tokeninfo?id_token=' . urlencode($idToken);

            $ch = curl_init($tokenInfoUrl);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_TIMEOUT => 10,
                CURLOPT_SSL_VERIFYPEER => true,
                CURLOPT_SSL_VERIFYHOST => 2,
            ]);

            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $curlError = curl_error($ch);
            curl_close($ch);

            if ($curlError) {
                error_log("Google token: cURL error - $curlError");
                return null;
            }

            if ($httpCode !== 200) {
                error_log("Google token: Verification failed with HTTP $httpCode");
                return null;
            }

            $payload = json_decode($response, true);
            if (!$payload) {
                error_log("Google token: Failed to decode response");
                return null;
            }

            // Check for error in response
            if (isset($payload['error'])) {
                error_log("Google token: Error - " . ($payload['error_description'] ?? $payload['error']));
                return null;
            }

            // Validate audience
            if (!isset($payload['aud'])) {
                error_log("Google token: Missing audience");
                return null;
            }

            if (!in_array($payload['aud'], $acceptedClientIds)) {
                error_log("Google token: Audience mismatch. Got: " . $payload['aud'] .
                         ", Accepted: " . implode(', ', $acceptedClientIds));
                return null;
            }

            // Validate issuer
            $validIssuers = ['accounts.google.com', 'https://accounts.google.com'];
            if (!isset($payload['iss']) || !in_array($payload['iss'], $validIssuers)) {
                error_log("Google token: Invalid issuer: " . ($payload['iss'] ?? 'not set'));
                return null;
            }

            // Validate expiration (tokeninfo already validates this, but double-check)
            if (isset($payload['exp']) && (int)$payload['exp'] < time()) {
                error_log("Google token: Token expired");
                return null;
            }

            // Ensure we have required fields
            if (!isset($payload['sub'])) {
                error_log("Google token: Missing subject (sub)");
                return null;
            }

            error_log("Google token: Successfully verified for sub: " . $payload['sub']);
            return $payload;

        } catch (\Exception $e) {
            error_log("Google token verification exception: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Crée ou met à jour un utilisateur
     */
    private function createOrUpdateUser(array $data): array {
        $db = Database::getInstance()->getConnection();

        // Vérifier si l'utilisateur existe
        $stmt = $db->prepare(
            "SELECT * FROM users WHERE provider = :provider AND provider_id = :provider_id LIMIT 1"
        );
        $stmt->execute([
            'provider' => $data['provider'],
            'provider_id' => $data['provider_id']
        ]);
        $existing = $stmt->fetch();

        if ($existing) {
            // Mettre à jour last_login
            $stmt = $db->prepare(
                "UPDATE users SET last_login = NOW(), email_verified = :email_verified
                 WHERE user_id = :user_id"
            );
            $stmt->execute([
                'email_verified' => $data['email_verified'] ? 1 : 0,
                'user_id' => $existing['user_id']
            ]);

            return $existing;
        }

        // Créer un nouvel utilisateur
        $userId = $this->generateUUID();

        $stmt = $db->prepare(
            "INSERT INTO users (user_id, provider, provider_id, email, name, avatar_url, email_verified, last_login)
             VALUES (:user_id, :provider, :provider_id, :email, :name, :avatar_url, :email_verified, NOW())"
        );

        $stmt->execute([
            'user_id' => $userId,
            'provider' => $data['provider'],
            'provider_id' => $data['provider_id'],
            'email' => $data['email'],
            'name' => $data['name'],
            'avatar_url' => $data['avatar_url'] ?? null,
            'email_verified' => $data['email_verified'] ? 1 : 0
        ]);

        // Créer les préférences par défaut
        $stmt = $db->prepare(
            "INSERT INTO user_preferences (user_id) VALUES (:user_id)"
        );
        $stmt->execute(['user_id' => $userId]);

        return [
            'user_id' => $userId,
            'email' => $data['email'],
            'name' => $data['name'],
            'provider' => $data['provider'],
            'avatar_url' => $data['avatar_url'] ?? null
        ];
    }

    /**
     * Logger un événement d'audit
     */
    private function logAudit(string $userId, string $action, string $provider) {
        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "INSERT INTO audit_logs (user_id, action, resource_type, ip_address, user_agent)
             VALUES (:user_id, :action, :resource_type, :ip_address, :user_agent)"
        );

        $stmt->execute([
            'user_id' => $userId,
            'action' => $action,
            'resource_type' => $provider,
            'ip_address' => $_SERVER['REMOTE_ADDR'] ?? null,
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? null
        ]);
    }

    /**
     * Génère un UUID v4
     */
    private function generateUUID(): string {
        return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
            mt_rand(0, 0xffff), mt_rand(0, 0xffff),
            mt_rand(0, 0xffff),
            mt_rand(0, 0x0fff) | 0x4000,
            mt_rand(0, 0x3fff) | 0x8000,
            mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
        );
    }

    /**
     * Retourne une erreur JSON
     */
    private function error(string $message, int $code = 400): array {
        http_response_code($code);
        return [
            'success' => false,
            'error' => $message
        ];
    }
}
