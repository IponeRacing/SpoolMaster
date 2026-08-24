<?php
/**
 * Middleware d'authentification JWT
 * Vérifie la validité du token pour les routes protégées
 */

namespace NfcAnycubic\Middleware;

use NfcAnycubic\JWTHandler;

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

        // Vérifier si le token est révoqué
        if (isset($decoded->jti) && $jwt->isTokenRevoked($decoded->jti)) {
            self::unauthorizedResponse('Token has been revoked');
            return null;
        }

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
        if (isset($decoded->jti) && $jwt->isTokenRevoked($decoded->jti)) return null;
        return $decoded->data->user_id ?? null;
    }
}
