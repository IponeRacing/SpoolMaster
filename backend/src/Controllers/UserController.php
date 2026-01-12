<?php
/**
 * Contrôleur de gestion des utilisateurs
 * Profil, préférences, suppression de compte
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Middleware\AuthMiddleware;
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

        // Récupérer l'utilisateur
        $stmt = $db->prepare(
            "SELECT u.*, p.* FROM users u
             LEFT JOIN user_preferences p ON u.user_id = p.user_id
             WHERE u.user_id = :user_id LIMIT 1"
        );
        $stmt->execute(['user_id' => $userId]);
        $user = $stmt->fetch();

        if (!$user) {
            return $this->error('User not found', 404);
        }

        // Retirer les données sensibles
        unset($user['access_token'], $user['refresh_token']);

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
            $sql = "UPDATE user_preferences SET " . implode(', ', $fields) . "
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

        return [
            'success' => true,
            'data' => [
                'message' => 'Account deletion requested. Your data will be deleted within 30 days.'
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
