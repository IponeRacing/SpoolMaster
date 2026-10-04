<?php
/**
 * Middleware d'authentification JWT
 * Vérifie la validité du token pour les routes protégées
 */

namespace NfcAnycubic\Middleware;

use NfcAnycubic\Database;
use NfcAnycubic\JWTHandler;
use NfcAnycubic\Logger;

class AuthMiddleware {

    /**
     * Vérifie l'authentification et retourne les données utilisateur
     */
    public static function authenticate(): ?object {
        $jwt = new JWTHandler();
        $token = $jwt->getBearerToken();

        if (!$token) {
            self::unauthorizedResponse('No token provided');
            return null;
        }

        $decoded = $jwt->verifyToken($token);

        if (!$decoded) {
            self::unauthorizedResponse('Invalid or expired token');
            return null;
        }

        // Un refresh token (90 jours) ne doit jamais servir de jeton d'accès.
        if (($decoded->type ?? null) === 'refresh') {
            self::unauthorizedResponse('Refresh token cannot be used as access token');
            return null;
        }

        // Vérifier si le token est révoqué
        if (isset($decoded->jti) && $jwt->isTokenRevoked($decoded->jti)) {
            self::unauthorizedResponse('Token has been revoked');
            return null;
        }

        // Compte supprimé : son JWT reste signé et non expiré, mais ne doit
        // plus rien ouvrir (sinon écritures orphelines refusées par les FK).
        if (!self::userExists($decoded->data->user_id ?? null)) {
            self::unauthorizedResponse('Account no longer exists');
            return null;
        }

        // Contexte de log : chaque erreur de cette requête porte l'user_id.
        Logger::setUserId($decoded->data->user_id ?? null);

        return $decoded;
    }

    /**
     * Envoie une réponse 401 Unauthorized
     */
    private static function unauthorizedResponse(string $message) {
        http_response_code(401);
        echo json_encode([
            'success' => false,
            'error' => 'Unauthorized',
            'message' => $message
        ]);
        exit;
    }

    /**
     * Récupère l'user_id depuis le token
     */
    public static function getUserId(): ?string {
        $decoded = self::authenticate();
        return $decoded->data->user_id ?? null;
    }

    /**
     * Récupère l'user_id SANS rejeter (401) si absent/invalide.
     * Pour les endpoints qui acceptent l'anonyme (ex: analytics des scans
     * effectués sans être connecté). Retourne null si pas de token valide.
     */
    public static function getUserIdOptional(): ?string {
        $jwt = new JWTHandler();
        $token = $jwt->getBearerToken();
        if (!$token) return null;
        $decoded = $jwt->verifyToken($token);
        if (!$decoded) return null;
        if (($decoded->type ?? null) === 'refresh') return null;
        if (isset($decoded->jti) && $jwt->isTokenRevoked($decoded->jti)) return null;
        // Compte supprimé → traité comme anonyme
        if (!self::userExists($decoded->data->user_id ?? null)) return null;
        Logger::setUserId($decoded->data->user_id ?? null);
        return $decoded->data->user_id ?? null;
    }

    /** true si le compte existe encore (requête indexée sur users.user_id). */
    private static function userExists(?string $userId): bool {
        if ($userId === null || $userId === '') return false;
        $stmt = Database::getInstance()->getConnection()->prepare(
            "SELECT 1 FROM users WHERE user_id = :user_id LIMIT 1"
        );
        $stmt->execute(['user_id' => $userId]);
        return $stmt->fetchColumn() !== false;
    }
}
