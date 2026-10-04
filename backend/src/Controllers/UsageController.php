<?php
/**
 * Historique de consommation des bobines (app 1.4.10+).
 *
 * Journal additif : l'app envoie chaque baisse de poids restant avec un
 * event_id qu'elle génère ; l'insertion est idempotente (INSERT IGNORE sur
 * user_id + event_id), donc un renvoi après coupure réseau ne double rien.
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Middleware\AuthMiddleware;

class UsageController {

    /** Nombre max d'événements acceptés par requête. */
    private const MAX_BATCH = 500;

    /**
     * POST /usage  { "events": [ {event_id, spool_id, used_at, grams, cost,
     *                brand, material, color_name, color_rgb, source}, ... ] }
     */
    public function push() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $input = json_decode(file_get_contents('php://input'), true);
        $events = $input['events'] ?? null;
        if (!is_array($events)) {
            return $this->error('events array required');
        }
        if (count($events) > self::MAX_BATCH) {
            return $this->error('Too many events (max ' . self::MAX_BATCH . ')');
        }

        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare(
            "INSERT IGNORE INTO spool_usage (
                user_id, event_id, spool_id, used_at, grams, cost,
                brand, material, color_name, color_rgb, source
             ) VALUES (
                :user_id, :event_id, :spool_id, :used_at, :grams, :cost,
                :brand, :material, :color_name, :color_rgb, :source
             )"
        );

        $accepted = [];
        $rejected = 0;
        foreach ($events as $e) {
            $eventId = isset($e['event_id']) ? substr((string)$e['event_id'], 0, 255) : '';
            $spoolId = isset($e['spool_id']) ? substr((string)$e['spool_id'], 0, 255) : '';
            $grams = isset($e['grams']) && is_numeric($e['grams']) ? (float)$e['grams'] : 0;
            $usedAt = isset($e['used_at']) ? strtotime((string)$e['used_at']) : false;
            $source = in_array($e['source'] ?? '', ['update', 'print', 'correction'], true)
                ? $e['source'] : 'update';
            // Consommation > 0 ; correction d'une saisie erronée < 0 (journal
            // additif : une erreur se corrige par un événement négatif).
            $gramsValid = $source === 'correction' ? $grams < 0 : $grams > 0;
            if ($eventId === '' || $spoolId === '' || !$gramsValid || $usedAt === false) {
                $rejected++;
                continue;
            }
            $stmt->execute([
                'user_id' => $userId,
                'event_id' => $eventId,
                'spool_id' => $spoolId,
                'used_at' => date('Y-m-d H:i:s', $usedAt),
                'grams' => round($grams, 2),
                'cost' => isset($e['cost']) && is_numeric($e['cost']) ? round((float)$e['cost'], 2) : 0,
                'brand' => isset($e['brand']) ? substr((string)$e['brand'], 0, 255) : null,
                'material' => isset($e['material']) ? substr((string)$e['material'], 0, 255) : null,
                'color_name' => isset($e['color_name']) ? substr((string)$e['color_name'], 0, 255) : null,
                'color_rgb' => isset($e['color_rgb']) && is_numeric($e['color_rgb']) ? (int)$e['color_rgb'] : null,
                'source' => $source,
            ]);
            // Accepté même si déjà présent (INSERT IGNORE) : l'app peut le marquer synchronisé.
            $accepted[] = $eventId;
        }

        return [
            'success' => true,
            'data' => [
                'accepted_ids' => $accepted,
                'rejected' => $rejected,
            ],
        ];
    }

    /**
     * GET /usage?since=YYYY-MM-DD  (défaut : 400 derniers jours)
     */
    public function pull() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $since = isset($_GET['since']) ? strtotime((string)$_GET['since']) : false;
        if ($since === false) {
            $since = strtotime('-400 days');
        }

        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare(
            "SELECT event_id, spool_id, used_at, grams, cost, brand, material,
                    color_name, color_rgb, source
               FROM spool_usage
              WHERE user_id = :user_id AND used_at >= :since
              ORDER BY used_at ASC
              LIMIT 5000"
        );
        $stmt->execute([
            'user_id' => $userId,
            'since' => date('Y-m-d H:i:s', $since),
        ]);

        $events = array_map(function ($row) {
            return [
                'event_id' => $row['event_id'],
                'spool_id' => $row['spool_id'],
                'used_at' => date('c', strtotime($row['used_at'])),
                'grams' => (float)$row['grams'],
                'cost' => (float)$row['cost'],
                'brand' => $row['brand'],
                'material' => $row['material'],
                'color_name' => $row['color_name'],
                'color_rgb' => $row['color_rgb'] !== null ? (int)$row['color_rgb'] : null,
                'source' => $row['source'],
            ];
        }, $stmt->fetchAll());

        return [
            'success' => true,
            'data' => ['events' => $events],
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
