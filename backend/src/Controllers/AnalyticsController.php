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

        $eventDataJson = isset($input['event_data']) ? json_encode($input['event_data']) : null;

        $stmt->execute([
            'user_id' => $userId,
            'event_type' => $input['event_type'],
            'event_data' => $eventDataJson,
            'device_platform' => $input['device_platform'] ?? 'ios',
            'app_version' => $input['app_version'] ?? null
        ]);

        $eventId = $db->lastInsertId();

        // Envoyer un mail quand un scan echoue ou qu'un user soumet un feedback
        $eventData = $input['event_data'] ?? [];
        $platform = $input['device_platform'] ?? 'ios';
        $appVersion = $input['app_version'] ?? '?';

        if (
            (in_array($input['event_type'], ['scan_nfc', 'scan_nfc_auto_detect']) && isset($eventData['success']) && $eventData['success'] === false)
            || $input['event_type'] === 'scan_feedback'
        ) {
            $this->notifyUnmatchedScan($userId, $eventData, $platform, $appVersion, $input['event_type']);
        }

        return [
            'success' => true,
            'data' => ['event_id' => $eventId]
        ];
    }

    /**
     * Envoie un mail unique contenant les raw data ET le feedback utilisateur
     */
    private function notifyUnmatchedScan(int $userId, array $eventData, string $platform, string $appVersion, string $eventType): void {
        $to = 'info@engageengine.ch';
        $isFeedback = $eventType === 'scan_feedback';
        $subject = $isFeedback
            ? '[Spool Master] Scan NFC non reconnu + feedback utilisateur'
            : '[Spool Master] Scan NFC non reconnu';

        $nfcMode = $eventData['nfc_mode'] ?? 'unknown';
        $error = $eventData['error_message'] ?? 'N/A';
        $rawData = $eventData['raw_tag_data'] ?? 'N/A';
        $bytesCount = $eventData['raw_bytes_count'] ?? 'N/A';
        $timestamp = $eventData['timestamp'] ?? date('c');

        $deviceModel = $eventData['device_model'] ?? 'N/A';
        $osVersion = $eventData['os_version'] ?? 'N/A';
        $sessionDurationMs = $eventData['session_duration_ms'] ?? 'N/A';
        $tagWasDetected = isset($eventData['tag_was_detected']) ? ($eventData['tag_was_detected'] ? 'Yes' : 'No') : 'N/A';

        $body = "Un utilisateur a scanne un tag NFC non reconnu.\n\n";
        $body .= "User ID: $userId\n";
        $body .= "Platform: $platform\n";
        $body .= "App version: $appVersion\n";
        $body .= "Device: $deviceModel\n";
        $body .= "OS: $osVersion\n";
        $body .= "NFC mode: $nfcMode\n";
        $body .= "Timestamp: $timestamp\n";
        $body .= "Error: $error\n";
        $body .= "Session duration: {$sessionDurationMs}ms\n";
        $body .= "Tag was detected: $tagWasDetected\n";
        $body .= "Raw bytes count: $bytesCount\n\n";
        $body .= "--- RAW TAG DATA ---\n$rawData\n\n";

        if ($isFeedback) {
            $body .= "--- INFOS SAISIES PAR L'UTILISATEUR ---\n";
            $body .= "Marque: " . ($eventData['brand'] ?? 'N/A') . "\n";
            $body .= "Materiau: " . ($eventData['material'] ?? 'N/A') . "\n";
            $body .= "Couleur: " . ($eventData['color'] ?? 'N/A') . "\n";
            if (!empty($eventData['weight'])) $body .= "Poids: {$eventData['weight']}g\n";
            if (!empty($eventData['diameter'])) $body .= "Diametre: {$eventData['diameter']}mm\n";
            if (!empty($eventData['extruder_temp_min']) || !empty($eventData['extruder_temp_max'])) {
                $body .= "Temp extrudeur: " . ($eventData['extruder_temp_min'] ?? '?') . "-" . ($eventData['extruder_temp_max'] ?? '?') . "°C\n";
            }
            if (!empty($eventData['bed_temp_min']) || !empty($eventData['bed_temp_max'])) {
                $body .= "Temp plateau: " . ($eventData['bed_temp_min'] ?? '?') . "-" . ($eventData['bed_temp_max'] ?? '?') . "°C\n";
            }
            if (!empty($eventData['spool_length'])) $body .= "Longueur bobine: {$eventData['spool_length']}m\n";
            if (!empty($eventData['batch_number'])) $body .= "Numero de lot: {$eventData['batch_number']}\n";
        }

        $headers = "From: noreply@engageengine.ch\r\n";
        $headers .= "Content-Type: text/plain; charset=UTF-8\r\n";

        @mail($to, $subject, $body, $headers);
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
