<?php
/**
 * Contrôleur Analytics
 * Gère l'enregistrement des événements (scans NFC, actions utilisateur)
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Middleware\AuthMiddleware;

class AnalyticsController {

    /**
     * Enregistre un événement analytics
     * POST /analytics/event
     * Body: { "event_type": "scan_nfc", "event_data": {...}, "device_platform": "ios", "app_version": "1.0.0" }
     */
    public function logEvent() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $input = json_decode(file_get_contents('php://input'), true);

        if (!isset($input['event_type'])) {
            http_response_code(400);
            return ['success' => false, 'error' => 'event_type is required'];
        }

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "INSERT INTO analytics (user_id, event_type, event_data, device_platform, app_version)
             VALUES (:user_id, :event_type, :event_data, :device_platform, :app_version)"
        );

        $stmt->execute([
            'user_id' => $userId,
            'event_type' => $input['event_type'],
            'event_data' => isset($input['event_data']) ? json_encode($input['event_data']) : null,
            'device_platform' => $input['device_platform'] ?? 'ios',
            'app_version' => $input['app_version'] ?? null
        ]);

        return [
            'success' => true,
            'data' => ['event_id' => $db->lastInsertId()]
        ];
    }

    /**
     * Récupère l'historique des scans NFC
     * GET /analytics/scans?limit=50
     */
    public function getScans() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $limit = isset($_GET['limit']) ? min((int)$_GET['limit'], 100) : 50;

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "SELECT * FROM analytics
             WHERE user_id = :user_id AND event_type IN ('scan_nfc', 'scan_add_spool', 'scan_update_stock')
             ORDER BY created_at DESC
             LIMIT :limit"
        );
        $stmt->bindValue(':user_id', $userId);
        $stmt->bindValue(':limit', $limit, \PDO::PARAM_INT);
        $stmt->execute();

        $scans = $stmt->fetchAll();

        // Décoder les JSON event_data
        foreach ($scans as &$scan) {
            if (isset($scan['event_data'])) {
                $scan['event_data'] = json_decode($scan['event_data'], true);
            }
        }

        return [
            'success' => true,
            'data' => $scans
        ];
    }

    /**
     * Récupère les statistiques des scans
     * GET /analytics/stats
     */
    public function getStats() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $db = Database::getInstance()->getConnection();

        // Total scans
        $stmt = $db->prepare(
            "SELECT COUNT(*) as total_scans,
                    COUNT(DISTINCT DATE(created_at)) as days_with_scans,
                    MIN(created_at) as first_scan,
                    MAX(created_at) as last_scan
             FROM analytics
             WHERE user_id = :user_id AND event_type IN ('scan_nfc', 'scan_add_spool', 'scan_update_stock')"
        );
        $stmt->execute(['user_id' => $userId]);
        $stats = $stmt->fetch();

        // Scans par type
        $stmt = $db->prepare(
            "SELECT event_type, COUNT(*) as count
             FROM analytics
             WHERE user_id = :user_id AND event_type IN ('scan_nfc', 'scan_add_spool', 'scan_update_stock')
             GROUP BY event_type"
        );
        $stmt->execute(['user_id' => $userId]);
        $scansByType = $stmt->fetchAll();

        // Scans par jour (7 derniers jours)
        $stmt = $db->prepare(
            "SELECT DATE(created_at) as date, COUNT(*) as count
             FROM analytics
             WHERE user_id = :user_id
                   AND event_type IN ('scan_nfc', 'scan_add_spool', 'scan_update_stock')
                   AND created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
             GROUP BY DATE(created_at)
             ORDER BY date DESC"
        );
        $stmt->execute(['user_id' => $userId]);
        $scansByDay = $stmt->fetchAll();

        return [
            'success' => true,
            'data' => [
                'total_scans' => (int)$stats['total_scans'],
                'days_with_scans' => (int)$stats['days_with_scans'],
                'first_scan' => $stats['first_scan'],
                'last_scan' => $stats['last_scan'],
                'scans_by_type' => $scansByType,
                'scans_by_day' => $scansByDay
            ]
        ];
    }
}
