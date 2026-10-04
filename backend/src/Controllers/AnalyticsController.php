<?php
/**
 * Contrôleur Analytics
 * Gère l'enregistrement des événements (scans NFC, actions utilisateur)
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Logger;
use NfcAnycubic\Middleware\AuthMiddleware;
use NfcAnycubic\Middleware\RateLimiter;

class AnalyticsController {

    /**
     * Enregistre un événement analytics
     * POST /analytics/event
     * Body: { "event_type": "scan_nfc", "event_data": {...}, "device_platform": "ios", "app_version": "1.0.0" }
     */
    public function logEvent() {
        // Accepte l'anonyme : les scans faits sans être connecté doivent
        // aussi être loggués (sinon angle mort de diagnostic). user_id = null.
        $userId = AuthMiddleware::getUserIdOptional();

        $input = json_decode(file_get_contents('php://input'), true);

        if (!is_array($input) || !isset($input['event_type'])) {
            http_response_code(400);
            return ['success' => false, 'error' => 'event_type is required'];
        }

        // Endpoint anonyme : garde-fous de forme et de taille. Avant, une
        // plateforme inconnue donnait un 500 (colonne ENUM), et event_data
        // n'avait aucune limite.
        $eventType = (string)$input['event_type'];
        if (!preg_match('/^[a-z0-9_]{1,100}$/', $eventType)) {
            http_response_code(400);
            return ['success' => false, 'error' => 'invalid event_type'];
        }
        $platform = $input['device_platform'] ?? 'ios';
        if (!in_array($platform, ['ios', 'android'], true)) {
            http_response_code(400);
            return ['success' => false, 'error' => 'invalid device_platform'];
        }
        $eventDataJson = isset($input['event_data']) ? json_encode($input['event_data']) : null;
        if ($eventDataJson !== null && strlen($eventDataJson) > 16384) {
            http_response_code(413);
            return ['success' => false, 'error' => 'event_data too large'];
        }
        $appVersion = isset($input['app_version']) ? mb_substr((string)$input['app_version'], 0, 50) : null;

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "INSERT INTO analytics (user_id, event_type, event_data, device_platform, app_version)
             VALUES (:user_id, :event_type, :event_data, :device_platform, :app_version)"
        );

        $stmt->execute([
            'user_id' => $userId,
            'event_type' => $eventType,
            'event_data' => $eventDataJson,
            'device_platform' => $platform,
            'app_version' => $appVersion
        ]);

        $eventId = $db->lastInsertId();

        // E-mail uniquement pour un feedback utilisateur (rare, saisi à la main).
        // Les scans ratés sont agrégés dans le rapport journalier : un e-mail
        // par échec (timeouts compris, ~5/jour) serait du bruit.
        // Au plus 5 e-mails de feedback par heure et par IP (l'événement est
        // enregistré dans tous les cas) : pas d'inondation de la boîte info@.
        if ($eventType === 'scan_feedback'
            && RateLimiter::check('feedback_mail:' . ($_SERVER['REMOTE_ADDR'] ?? 'unknown'), 5, 3600)) {
            $eventData = is_array($input['event_data'] ?? null) ? $input['event_data'] : [];
            $platform = $input['device_platform'] ?? 'ios';
            $appVersion = $input['app_version'] ?? '?';
            try {
                $this->notifyUnmatchedScan($userId, $eventData, $platform, $appVersion, $input['event_type']);
            } catch (\Throwable $e) {
                // L'événement est déjà enregistré : ne pas renvoyer 500 au client.
                Logger::exception('analytics.feedback_mail', $e);
            }
        }

        return [
            'success' => true,
            'data' => ['event_id' => $eventId]
        ];
    }

    /**
     * Envoie un mail unique contenant les raw data ET le feedback utilisateur
     */
    private function notifyUnmatchedScan(?string $userId, array $eventData, string $platform, string $appVersion, string $eventType): void {
        $isFeedback = $eventType === 'scan_feedback';
        $subject = $isFeedback
            ? '[Spool Master] Scan NFC non reconnu + feedback utilisateur'
            : '[Spool Master] Scan NFC non reconnu';

        $nfcMode = $eventData['nfc_mode'] ?? 'unknown';
        $entryPoint = $eventData['entry_point'] ?? 'N/A';
        $error = $eventData['error_message'] ?? 'N/A';
        $rawData = $eventData['raw_tag_data'] ?? 'N/A';
        $bytesCount = $eventData['raw_bytes_count'] ?? 'N/A';
        $timestamp = $eventData['timestamp'] ?? date('c');

        $deviceModel = $eventData['device_model'] ?? 'N/A';
        $osVersion = $eventData['os_version'] ?? 'N/A';
        $sessionDurationMs = $eventData['session_duration_ms'] ?? 'N/A';
        $tagWasDetected = isset($eventData['tag_was_detected']) ? ($eventData['tag_was_detected'] ? 'Yes' : 'No') : 'N/A';

        $body = "Un utilisateur a scanne un tag NFC non reconnu.\n\n";
        $body .= "User ID: " . ($userId ?? 'anonyme (invité)') . "\n";
        $body .= "Platform: $platform\n";
        $body .= "App version: $appVersion\n";
        $body .= "Device: $deviceModel\n";
        $body .= "OS: $osVersion\n";
        $body .= "NFC mode: $nfcMode\n";
        $body .= "Entry point: $entryPoint\n";
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

        // mail() est désactivé chez Infomaniak → SMTP du rapport journalier.
        $html = '<pre style="font-family: monospace; font-size: 13px;">'
            . \htmlspecialchars($body, ENT_QUOTES, 'UTF-8') . '</pre>';
        if (!(new ReportController())->sendAlert($subject, $html)) {
            // Envoi raté : garder le contenu dans le journal pour ne pas le perdre.
            Logger::error('analytics.feedback_mail', 'Envoi SMTP échoué', ['body' => $body]);
        }
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
