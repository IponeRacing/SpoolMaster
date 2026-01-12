<?php
/**
 * Contrôleur d'authentification
 * Gère Apple Sign In et Google Sign In
 * Conforme aux standards 2025-2026
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\JWTHandler;

class AuthController {

    /**
     * Login avec Apple Sign In
     * POST /auth/apple
     * Body: { "identityToken": "...", "authorizationCode": "...", "user": {...} }
     */
    public function loginWithApple() {
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
     * Vérifie un token Apple (JWT)
     */
    private function verifyAppleToken(string $identityToken): ?array {
        // Décoder le JWT sans vérification (pour dev/test)
        // EN PRODUCTION: vérifier la signature avec les clés publiques Apple
        $parts = explode('.', $identityToken);
        if (count($parts) !== 3) {
            return null;
        }

        $payload = json_decode(base64_decode(strtr($parts[1], '-_', '+/')), true);

        // TODO EN PRODUCTION: Vérifier la signature avec les clés Apple
        // https://appleid.apple.com/auth/keys

        return $payload;
    }

    /**
     * Vérifie un token Google
     */
    private function verifyGoogleToken(string $idToken): ?array {
        // Utiliser Google API Client pour vérifier
        $config = require __DIR__ . '/../../config/app.php';
        $acceptedClientIds = $config['oauth']['google']['accepted_client_ids'] ?? [$config['oauth']['google']['client_id']];

        // Décoder le JWT
        $parts = explode('.', $idToken);
        if (count($parts) !== 3) {
            error_log('Google token: Invalid JWT format (not 3 parts)');
            return null;
        }

        $payload = json_decode(base64_decode(strtr($parts[1], '-_', '+/')), true);

        error_log('Google token payload: ' . json_encode($payload));
        error_log('Accepted client_ids: ' . json_encode($acceptedClientIds));
        error_log('Token aud: ' . ($payload['aud'] ?? 'NOT SET'));

        // Vérifier l'audience - doit correspondre à un des client IDs acceptés
        if (isset($payload['aud']) && !in_array($payload['aud'], $acceptedClientIds)) {
            error_log('Google token: Audience mismatch! Token aud not in accepted list');
            return null;
        }

        // TODO EN PRODUCTION: Vérifier la signature avec Google
        // https://www.googleapis.com/oauth2/v3/certs

        return $payload;
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
