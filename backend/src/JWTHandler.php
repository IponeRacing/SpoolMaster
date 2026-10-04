<?php
/**
 * Gestionnaire JWT pour authentification
 * Compatible Apple & Google OAuth 2025
 */

namespace NfcAnycubic;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class JWTHandler {
    private $secret;
    private $algorithm;
    private $expiration;

    public function __construct() {
        $config = require __DIR__ . '/../config/app.php';
        $this->secret = $config['jwt_secret'];
        $this->algorithm = $config['jwt_algorithm'];
        $this->expiration = $config['jwt_expiration'];
    }

    /**
     * Génère un JWT token pour un utilisateur
     */
    public function generateToken(array $userData): string {
        $now = time();
        $payload = [
            'iss' => 'nfc-anycubic-api', // Issuer
            'aud' => 'nfc-anycubic-app', // Audience
            'iat' => $now, // Issued at
            'nbf' => $now, // Not before
            'exp' => $now + $this->expiration, // Expiration
            'jti' => $this->generateJTI(), // JWT ID (unique)
            'data' => [
                'user_id' => $userData['user_id'],
                'email' => $userData['email'],
                'provider' => $userData['provider'],
            ]
        ];

        return JWT::encode($payload, $this->secret, $this->algorithm);
    }

    /**
     * Génère un refresh token
     */
    public function generateRefreshToken(string $userId): string {
        $config = require __DIR__ . '/../config/app.php';
        $now = time();

        $payload = [
            'iss' => 'nfc-anycubic-api',
            'aud' => 'nfc-anycubic-app',
            'iat' => $now,
            'exp' => $now + $config['jwt_refresh_expiration'],
            'jti' => $this->generateJTI(),
            'type' => 'refresh',
            'data' => [
                'user_id' => $userId,
            ]
        ];

        return JWT::encode($payload, $this->secret, $this->algorithm);
    }

    /**
     * Vérifie et décode un JWT token
     */
    public function verifyToken(string $token): ?object {
        try {
            return JWT::decode($token, new Key($this->secret, $this->algorithm));
        } catch (\Exception $e) {
            error_log("JWT verification error: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Extrait le token du header Authorization
     */
    public function getBearerToken(): ?string {
        $headers = $this->getAuthorizationHeader();

        if (!empty($headers)) {
            if (preg_match('/Bearer\s+(.*)$/i', $headers, $matches)) {
                return $matches[1];
            }
        }

        return null;
    }

    /**
     * Récupère le header Authorization
     */
    private function getAuthorizationHeader(): ?string {
        $headers = null;

        if (isset($_SERVER['Authorization'])) {
            $headers = trim($_SERVER['Authorization']);
        } elseif (isset($_SERVER['HTTP_AUTHORIZATION'])) {
            $headers = trim($_SERVER['HTTP_AUTHORIZATION']);
        } elseif (function_exists('apache_request_headers')) {
            $requestHeaders = apache_request_headers();
            $requestHeaders = array_combine(
                array_map('ucwords', array_keys($requestHeaders)),
                array_values($requestHeaders)
            );

            if (isset($requestHeaders['Authorization'])) {
                $headers = trim($requestHeaders['Authorization']);
            }
        }

        return $headers;
    }

    /**
     * Génère un JWT ID unique
     */
    private function generateJTI(): string {
        return bin2hex(random_bytes(16));
    }

    /**
     * Vérifie si un token est révoqué
     */
    public function isTokenRevoked(string $jti): bool {
        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "SELECT id FROM token_revocations WHERE token_identifier = :jti LIMIT 1"
        );
        $stmt->execute(['jti' => $jti]);

        return $stmt->fetch() !== false;
    }

    /**
     * Révoque un token
     */
    public function revokeToken(string $jti, string $userId, string $reason = 'user_logout'): bool {
        $db = Database::getInstance()->getConnection();

        // Fournisseur réel du compte (avant : 'apple' en dur, y compris pour
        // les comptes Google). Le compte existe forcément (clé étrangère) ;
        // le COALESCE ne sert que de garde-fou.
        $stmt = $db->prepare(
            "INSERT INTO token_revocations (user_id, provider, token_identifier, reason)
             VALUES (:user_id,
                     COALESCE((SELECT u.provider FROM users u WHERE u.user_id = :user_id_lookup), 'apple'),
                     :jti, :reason)"
        );

        return $stmt->execute([
            'user_id' => $userId,
            'user_id_lookup' => $userId,
            'jti' => $jti,
            'reason' => $reason
        ]);
    }
}
