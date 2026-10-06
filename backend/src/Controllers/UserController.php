<?php
/**
 * Contrôleur de gestion des utilisateurs
 * Profil, préférences, suppression de compte
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Middleware\AuthMiddleware;
use NfcAnycubic\Logger;
use NfcAnycubic\Services\AccountPurgeService;
use NfcAnycubic\JWTHandler;

class UserController {

    /**
     * Récupère le profil utilisateur
     * GET /user/profile
     */
    public function getProfile() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $db = Database::getInstance()->getConnection();

        // Colonnes explicites. Avant, « u.*, p.* » : le user_id NULL de p (pas de
        // ligne de préférences) écrasait celui de u, et des colonnes sensibles
        // (apple_refresh_token…) partaient au client.
        $stmt = $db->prepare(
            "SELECT u.user_id, u.email, u.name, u.avatar_url, u.provider, u.created_at, u.last_login,
                    p.language, p.currency, p.units, p.low_stock_threshold,
                    p.analytics_enabled, p.crash_reports_enabled, p.auto_sync_enabled, p.sync_on_wifi_only,
                    p.is_vip, p.vip_expires_at, p.subscription_type, p.prefs_explicit
             FROM users u
             LEFT JOIN user_preferences p ON u.user_id = p.user_id
             WHERE u.user_id = :user_id LIMIT 1"
        );
        $stmt->execute(['user_id' => $userId]);
        $user = $stmt->fetch();

        if (!$user) {
            return $this->error('User not found', 404);
        }

        // Préférences renvoyées seulement si l'app les a déjà envoyées. Les
        // valeurs par défaut de la table (fr / CHF / seuil 100) écrasaient les
        // réglages du téléphone à la connexion : 188 comptes en fr/CHF.
        if (empty($user['prefs_explicit'])) {
            foreach (['language', 'currency', 'units', 'low_stock_threshold'] as $k) {
                $user[$k] = null;
            }
        }
        unset($user['prefs_explicit']);

        return [
            'success' => true,
            'data' => $user
        ];
    }

    /**
     * Met à jour le profil utilisateur
     * PUT /user/profile
     */
    public function updateProfile() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $input = json_decode(file_get_contents('php://input'), true);
        $db = Database::getInstance()->getConnection();

        // Mettre à jour les préférences
        $allowedPrefs = [
            'language', 'currency', 'units', 'low_stock_threshold',
            'analytics_enabled', 'crash_reports_enabled',
            'auto_sync_enabled', 'sync_on_wifi_only'
        ];

        $fields = [];
        $values = ['user_id' => $userId];

        foreach ($allowedPrefs as $field) {
            if (isset($input[$field])) {
                $fields[] = "$field = :$field";
                $values[$field] = $input[$field];
            }
        }

        if (!empty($fields)) {
            // Valeurs choisies par l'utilisateur : désormais renvoyées par GET /user/profile.
            $sql = "UPDATE user_preferences SET " . implode(', ', $fields) . ", prefs_explicit = 1
                    WHERE user_id = :user_id";

            $stmt = $db->prepare($sql);
            $stmt->execute($values);
        }

        // Mettre à jour le nom si fourni
        if (isset($input['name'])) {
            $stmt = $db->prepare("UPDATE users SET name = :name WHERE user_id = :user_id");
            $stmt->execute(['name' => $input['name'], 'user_id' => $userId]);
        }

        return [
            'success' => true,
            'data' => [
                'message' => 'Profile updated successfully'
            ]
        ];
    }

    /**
     * Demande de suppression de compte (GDPR)
     * DELETE /user/account
     */
    public function deleteAccount() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $db = Database::getInstance()->getConnection();

        // Marquer le compte pour suppression
        $stmt = $db->prepare(
            "UPDATE users SET data_deletion_requested = 1, data_deletion_requested_at = NOW()
             WHERE user_id = :user_id"
        );
        $stmt->execute(['user_id' => $userId]);

        // Logger l'audit
        $stmt = $db->prepare(
            "INSERT INTO audit_logs (user_id, action, success)
             VALUES (:user_id, 'account_deletion_requested', 1)"
        );
        $stmt->execute(['user_id' => $userId]);

        // Suppression définitive immédiate (révocation Sign in with Apple +
        // cascade sur toutes les données). Si elle échoue, le drapeau posé
        // ci-dessus garantit la reprise par la purge quotidienne.
        $deleted = false;
        try {
            $deleted = AccountPurgeService::purge($db, $userId, 'user_request');
        } catch (\Throwable $e) {
            Logger::exception('account.delete', $e);
        }

        // Échec de la purge immédiate : erreur (l'app affiche « échec,
        // réessayez » et non « Compte supprimé », annoncé depuis la 1.4.11).
        // Le drapeau posé plus haut laisse la purge quotidienne finir le travail.
        if (!$deleted) {
            http_response_code(500);
            return [
                'success' => false,
                'error' => 'Account deletion failed, please retry. It will also be completed automatically.',
                'request_id' => Logger::requestId(),
            ];
        }

        return [
            'success' => true,
            'data' => [
                'deleted' => true,
                'message' => 'Account and data deleted.'
            ]
        ];
    }

    /**
     * Déconnexion (révocation du token)
     * POST /user/logout
     */
    public function logout() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $jwt = new JWTHandler();
        $token = $jwt->getBearerToken();

        if ($token) {
            $decoded = $jwt->verifyToken($token);
            if ($decoded && isset($decoded->jti)) {
                $jwt->revokeToken($decoded->jti, $userId, 'user_logout');
            }
        }

        // Révoquer aussi le refresh token (sinon il restait valable 90 jours
        // après la déconnexion). Seulement s'il appartient bien à ce compte.
        $input = json_decode(file_get_contents('php://input'), true);
        if (is_array($input) && !empty($input['refresh_token'])) {
            $refresh = $jwt->verifyToken((string)$input['refresh_token']);
            if ($refresh && ($refresh->type ?? null) === 'refresh'
                && ($refresh->data->user_id ?? null) === $userId && isset($refresh->jti)) {
                $jwt->revokeToken($refresh->jti, $userId, 'user_logout');
            }
        }

        // Logger l'audit
        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare(
            "INSERT INTO audit_logs (user_id, action, success)
             VALUES (:user_id, 'logout', 1)"
        );
        $stmt->execute(['user_id' => $userId]);

        return [
            'success' => true,
            'data' => [
                'message' => 'Logged out successfully'
            ]
        ];
    }

    /**
     * Enregistre un événement analytics
     * POST /analytics/track
     */
    public function trackEvent() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $input = json_decode(file_get_contents('php://input'), true);

        if (!isset($input['event_type'])) {
            return $this->error('Missing event_type', 400);
        }

        $db = Database::getInstance()->getConnection();

        // Vérifier que l'utilisateur a activé les analytics
        $stmt = $db->prepare(
            "SELECT analytics_enabled FROM user_preferences WHERE user_id = :user_id LIMIT 1"
        );
        $stmt->execute(['user_id' => $userId]);
        $prefs = $stmt->fetch();

        if (!$prefs || !$prefs['analytics_enabled']) {
            return [
                'success' => true,
                'data' => ['message' => 'Analytics disabled']
            ];
        }

        // Enregistrer l'événement
        $stmt = $db->prepare(
            "INSERT INTO analytics (user_id, event_type, event_data, device_platform, app_version)
             VALUES (:user_id, :event_type, :event_data, :device_platform, :app_version)"
        );

        $stmt->execute([
            'user_id' => $userId,
            'event_type' => $input['event_type'],
            'event_data' => json_encode($input['data'] ?? []),
            'device_platform' => $input['platform'] ?? 'ios',
            'app_version' => $input['app_version'] ?? '1.0.0'
        ]);

        return [
            'success' => true,
            'data' => ['message' => 'Event tracked']
        ];
    }

    private function error(string $message, int $code = 400): array {
        http_response_code($code);
        return [
            'success' => false,
            'error' => $message
        ];
    }
}
