<?php
/**
 * Contrôleur de synchronisation
 * Gère la sync bidirectionnelle des données local ↔ cloud
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Logger;
use NfcAnycubic\Middleware\AuthMiddleware;

class SyncController {

    /**
     * Push les données locales vers le cloud
     * POST /sync/push
     * Body: { "spools": [...], "preferences": {...} }
     */
    public function push() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $rawBody = file_get_contents('php://input');
        $input = json_decode($rawBody, true);
        if (!is_array($input)) {
            // Corps tronqué/illisible : avant, on répondait « success, 0 bobine »
            // et le client croyait son stock sauvegardé.
            Logger::error('sync.push', 'Corps JSON invalide: ' . json_last_error_msg(), ['bytes' => strlen((string)$rawBody)]);
            $this->logSync($userId, 'push', 0, 0, 0, 'failed', 'Invalid JSON body');
            http_response_code(400);
            return ['success' => false, 'error' => 'Invalid JSON body', 'request_id' => Logger::requestId()];
        }

        $syncStart = microtime(true);
        $itemsSynced = 0;
        $skipped = 0;
        $failedIds = [];

        // Sync des bobines — une bobine en erreur ne doit pas faire échouer le lot
        // (avant : 500 global non journalisé, et les bobines suivantes ignorées).
        if (isset($input['spools']) && is_array($input['spools'])) {
            foreach ($input['spools'] as $spool) {
                $spoolId = is_array($spool) ? ($spool['spool_id'] ?? $spool['id'] ?? null) : null;
                try {
                    $spool = $this->normalizeFieldNames(is_array($spool) ? $spool : null);
                    $result = $this->syncSpool($userId, $spool);
                } catch (\Throwable $e) {
                    $failedIds[] = $spoolId ?? '?';
                    Logger::exception('sync.push', $e, ['spool_id' => $spoolId]);
                    continue;
                }
                if ($result['synced']) $itemsSynced++;
                if ($result['skipped']) $skipped++;
            }
        }

        // Sync des préférences
        if (isset($input['preferences']) && is_array($input['preferences'])) {
            try {
                $this->syncPreferences($userId, $input['preferences']);
            } catch (\Throwable $e) {
                Logger::exception('sync.push.preferences', $e);
            }
        }

        $duration = round((microtime(true) - $syncStart) * 1000);

        $status = 'success';
        $errorMessage = null;
        if (!empty($failedIds)) {
            $status = ($itemsSynced > 0 || $skipped > 0) ? 'partial' : 'failed';
            $errorMessage = count($failedIds) . ' bobine(s) en échec: ' . implode(', ', array_slice($failedIds, 0, 20));
        }

        // items_conflicts reste à 0 : il n'y a plus de résolution de conflit.
        $this->logSync($userId, 'push', $itemsSynced, 0, (int)$duration, $status, $errorMessage);

        return [
            'success' => true,
            'data' => [
                'items_synced' => $itemsSynced,
                // Déjà présentes côté serveur → non modifiées (voir syncSpool).
                'skipped_existing' => $skipped,
                'failed' => count($failedIds),
                // Le client garde ces bobines en local lors du pull qui suit
                // (elles ne sont pas sur le serveur → ne pas les effacer).
                'failed_spool_ids' => $failedIds,
                'duration_ms' => $duration
            ]
        ];
    }

    /**
     * Pull les données cloud vers le local
     * GET/POST /sync/pull
     * Query/Body: { "last_sync": "2025-01-01 00:00:00" }
     */
    public function pull() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        // Support GET (query params) et POST (body)
        if ($_SERVER['REQUEST_METHOD'] === 'GET') {
            $lastSync = $_GET['last_sync'] ?? null;
        } else {
            $input = json_decode(file_get_contents('php://input'), true);
            $lastSync = $input['last_sync'] ?? null;
        }

        $db = Database::getInstance()->getConnection();

        // Récupérer les bobines modifiées depuis last_sync.
        // IMPORTANT : ne JAMAIS renvoyer les bobines supprimées (deleted_at).
        // Le client fait un remplacement complet du stock local avec ce que
        // renvoie le pull ; s'il recevait les tombstones, il les afficherait
        // comme actives (bug « 147 bobines » : 50 actives + 97 supprimées).
        if ($lastSync) {
            $stmt = $db->prepare(
                "SELECT * FROM spools
                 WHERE user_id = :user_id AND updated_at > :last_sync
                   AND deleted_at IS NULL
                 ORDER BY updated_at ASC"
            );
            $stmt->execute(['user_id' => $userId, 'last_sync' => $lastSync]);
        } else {
            // Première sync : tout récupérer (actif uniquement)
            $stmt = $db->prepare(
                "SELECT * FROM spools
                 WHERE user_id = :user_id
                   AND deleted_at IS NULL
                 ORDER BY updated_at ASC"
            );
            $stmt->execute(['user_id' => $userId]);
        }

        $spoolsRaw = $stmt->fetchAll();

        // Mapper les noms de champs pour le client (snake_case)
        $spools = array_map(function($spool) {
            return [
                'spool_id' => $spool['spool_id'],
                'brand' => $spool['brand'],
                'material' => $spool['material'],
                'color_name' => $spool['color_name'],
                'color_rgb' => (int)$spool['color_rgb'],
                'price' => (float)$spool['price'],
                'initial_weight' => (float)$spool['initial_weight'],
                'remaining_weight' => (float)$spool['remaining_weight'],
                'diameter' => $spool['diameter'] ? (float)$spool['diameter'] : null,
                'spool_length' => $spool['spool_length'] ? (int)$spool['spool_length'] : null,
                'extruder_temp_min' => $spool['extruder_temp_min'] ? (int)$spool['extruder_temp_min'] : null,
                'extruder_temp_max' => $spool['extruder_temp_max'] ? (int)$spool['extruder_temp_max'] : null,
                'bed_temp_min' => $spool['bed_temp_min'] ? (int)$spool['bed_temp_min'] : null,
                'bed_temp_max' => $spool['bed_temp_max'] ? (int)$spool['bed_temp_max'] : null,
                'manufacture_date' => $spool['manufacture_date'],
                'batch_number' => $spool['batch_number'],
                'detailed_type' => $spool['detailed_type'] ?? null,
                'drying_temp' => $spool['drying_temp'] ? (int)$spool['drying_temp'] : null,
                'drying_time' => $spool['drying_time'] ? (int)$spool['drying_time'] : null,
                'material_variant_id' => $spool['material_variant_id'] ?? null,
                'material_id' => $spool['material_id'] ?? null,
                'notes' => ($spool['notes'] ?? null) !== '' ? ($spool['notes'] ?? null) : null,
                'location' => ($spool['location'] ?? null) !== '' ? ($spool['location'] ?? null) : null,
                'nozzle_size' => isset($spool['nozzle_size']) ? (float)$spool['nozzle_size'] : null,
                'vendor_code' => $spool['vendor_code'] ?? null,
                'product_code' => $spool['product_code'] ?? null,
                // Date d'ajout réelle (colonne 1.4.10) ; à défaut, date de création
                'added_date' => date('Y-m-d\TH:i:s', strtotime($spool['added_date'] ?? $spool['created_at'])),
                'created_at' => $spool['created_at'],
                'updated_at' => $spool['updated_at'],
            ];
        }, $spoolsRaw);

        // Récupérer les préférences
        $stmt = $db->prepare(
            "SELECT * FROM user_preferences WHERE user_id = :user_id LIMIT 1"
        );
        $stmt->execute(['user_id' => $userId]);
        $preferences = $stmt->fetch();

        // Logger la sync
        $this->logSync($userId, 'pull', count($spools), 0, 0, 'success');

        return [
            'success' => true,
            'data' => [
                'spools' => $spools,
                'preferences' => $preferences,
                'server_time' => date('Y-m-d H:i:s')
            ]
        ];
    }

    /**
     * Récupère l'historique de sync
     * GET /sync/history
     */
    public function getHistory() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "SELECT * FROM sync_history
             WHERE user_id = :user_id
             ORDER BY created_at DESC
             LIMIT 50"
        );
        $stmt->execute(['user_id' => $userId]);
        $history = $stmt->fetchAll();

        return [
            'success' => true,
            'data' => $history
        ];
    }

    /**
     * Synchronise une bobine : CRÉATION SEULEMENT.
     *
     * Une bobine déjà connue du serveur (active ou supprimée) n'est jamais
     * modifiée par le push. Le client n'envoie ni version ni horodatage de
     * modification : le serveur ne peut pas savoir quelle copie est la plus
     * récente. Les modifications passent par PUT /spools/:id (avec la file de
     * retry côté app). Avant : comparaison sur un sync_version jamais envoyé →
     * 2 475 « conflits » pour 192 écritures en 30 jours, et une ligne créée par
     * PUT était écrasée au premier push suivant (appareil potentiellement
     * périmé). Ne jamais toucher une ligne existante garantit aussi qu'un push
     * ne ressuscite pas une bobine supprimée (boucle de résurrection, 09.2026).
     */
    private function syncSpool(string $userId, array $spool): array {
        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "SELECT 1 FROM spools
             WHERE spool_id = :spool_id AND user_id = :user_id
             LIMIT 1"
        );
        $stmt->execute([
            'spool_id' => $spool['spool_id'],
            'user_id' => $userId
        ]);
        if ($stmt->fetch()) {
            return ['synced' => false, 'skipped' => true];
        }

        $stmt = $db->prepare(
            "INSERT INTO spools (
                user_id, spool_id, brand, material, color_name, color_rgb,
                initial_weight, remaining_weight, price, diameter, spool_length,
                extruder_temp_min, extruder_temp_max, bed_temp_min, bed_temp_max,
                manufacture_date, batch_number, detailed_type, drying_temp, drying_time,
                material_variant_id, material_id, purchase_date, notes, location,
                nozzle_size, vendor_code, product_code, added_date,
                deleted_at, sync_version, last_synced_at
            ) VALUES (
                :user_id, :spool_id, :brand, :material, :color_name, :color_rgb,
                :initial_weight, :remaining_weight, :price, :diameter, :spool_length,
                :extruder_temp_min, :extruder_temp_max, :bed_temp_min, :bed_temp_max,
                :manufacture_date, :batch_number, :detailed_type, :drying_temp, :drying_time,
                :material_variant_id, :material_id, :purchase_date, :notes, :location,
                :nozzle_size, :vendor_code, :product_code, :added_date,
                :deleted_at, 1, NOW()
            )"
        );

        $stmt->execute([
            'user_id' => $userId,
            'spool_id' => $spool['spool_id'],
            'brand' => $spool['brand'] ?? null,
            'material' => $spool['material'],
            'color_name' => $spool['color_name'],
            'color_rgb' => $spool['color_rgb'] ?? null,
            'initial_weight' => $spool['initial_weight'],
            'remaining_weight' => $spool['remaining_weight'],
            'price' => $spool['price'] ?? null,
            'diameter' => $spool['diameter'] ?? null,
            'spool_length' => $spool['spool_length'] ?? null,
            'extruder_temp_min' => $spool['extruder_temp_min'] ?? null,
            'extruder_temp_max' => $spool['extruder_temp_max'] ?? null,
            'bed_temp_min' => $spool['bed_temp_min'] ?? null,
            'bed_temp_max' => $spool['bed_temp_max'] ?? null,
            'manufacture_date' => $spool['manufacture_date'] ?? null,
            'batch_number' => $spool['batch_number'] ?? null,
            'detailed_type' => $spool['detailed_type'] ?? null,
            'drying_temp' => $spool['drying_temp'] ?? null,
            'drying_time' => $spool['drying_time'] ?? null,
            'material_variant_id' => $spool['material_variant_id'] ?? null,
            'material_id' => $spool['material_id'] ?? null,
            'purchase_date' => $spool['purchase_date'] ?? null,
            // Chaîne vide = champ vidé par l'utilisateur → NULL
            'notes' => ($spool['notes'] ?? '') !== '' ? $spool['notes'] : null,
            'location' => ($spool['location'] ?? '') !== '' ? $spool['location'] : null,
            'nozzle_size' => $spool['nozzle_size'] ?? null,
            'vendor_code' => $spool['vendor_code'] ?? null,
            'product_code' => $spool['product_code'] ?? null,
            'added_date' => $this->toDateTime($spool['added_date'] ?? null),
            'deleted_at' => $spool['deleted_at'] ?? null,
        ]);

        return ['synced' => true, 'skipped' => false];
    }

    /**
     * Date ISO de l'app (« 2026-09-01T10:20:30.123 ») → DATETIME MariaDB.
     * null si absente ou illisible.
     */
    private function toDateTime($value): ?string {
        if ($value === null || $value === '') return null;
        $ts = strtotime((string)$value);
        return $ts === false ? null : date('Y-m-d H:i:s', $ts);
    }

    /**
     * Synchronise les préférences
     */
    private function syncPreferences(string $userId, array $prefs) {
        $db = Database::getInstance()->getConnection();

        $fields = [];
        $values = ['user_id' => $userId];

        $allowedFields = [
            'language', 'currency', 'units', 'low_stock_threshold',
            'analytics_enabled', 'crash_reports_enabled',
            'auto_sync_enabled', 'sync_on_wifi_only'
        ];

        foreach ($allowedFields as $field) {
            if (isset($prefs[$field])) {
                $fields[] = "$field = :$field";
                $values[$field] = $prefs[$field];
            }
        }

        if (!empty($fields)) {
            // Colonnes = champs autorisés uniquement. Avant : les clés brutes du
            // JSON étaient concaténées dans le SQL (injection possible) et toute
            // clé inconnue faisait planter la requête (paramètres manquants).
            $columns = array_values(array_diff(array_keys($values), ['user_id']));
            $sql = "INSERT INTO user_preferences (user_id, prefs_explicit, " . implode(', ', $columns) . ")
                    VALUES (:user_id, 1, " . implode(', ', array_map(fn($k) => ":$k", $columns)) . ")
                    ON DUPLICATE KEY UPDATE " . implode(', ', $fields) . ", prefs_explicit = 1";

            $stmt = $db->prepare($sql);
            $stmt->execute($values);
        }
    }

    /**
     * Logger une sync
     */
    private function logSync(string $userId, string $type, int $items, int $conflicts, int $duration, string $status, ?string $errorMessage = null) {
        // L'historique est de l'observabilité : son échec ne doit pas transformer
        // une sync réussie en 500 (le client effacerait alors son local au pull).
        try {
            $db = Database::getInstance()->getConnection();

            $stmt = $db->prepare(
                "INSERT INTO sync_history (user_id, sync_type, items_synced, items_conflicts, duration_ms, status, error_message)
                 VALUES (:user_id, :sync_type, :items_synced, :items_conflicts, :duration_ms, :status, :error_message)"
            );

            $stmt->execute([
                'user_id' => $userId,
                'sync_type' => $type,
                'items_synced' => $items,
                'items_conflicts' => $conflicts,
                'duration_ms' => $duration,
                'status' => $status,
                'error_message' => $errorMessage
            ]);
        } catch (\Throwable $e) {
            Logger::exception('sync.history', $e, ['sync_type' => $type, 'status' => $status]);
        }
    }

    /**
     * Normalise les noms de champs pour accepter camelCase et snake_case
     */
    private function normalizeFieldNames(?array $input): array {
        if (!$input) return [];

        $mapping = [
            'colorName' => 'color_name',
            'colorRgb' => 'color_rgb',
            'weight' => 'initial_weight',
            'remainingWeight' => 'remaining_weight',
            'spoolLength' => 'spool_length',
            'extruderTempMin' => 'extruder_temp_min',
            'extruderTempMax' => 'extruder_temp_max',
            'bedTempMin' => 'bed_temp_min',
            'bedTempMax' => 'bed_temp_max',
            'manufactureDate' => 'manufacture_date',
            'batchNumber' => 'batch_number',
            'detailedType' => 'detailed_type',
            'dryingTemp' => 'drying_temp',
            'dryingTime' => 'drying_time',
            'materialVariantId' => 'material_variant_id',
            'materialId' => 'material_id',
            'purchaseDate' => 'purchase_date',
            'addedDate' => 'added_date',
            'id' => 'spool_id',
        ];

        $normalized = [];
        foreach ($input as $key => $value) {
            $newKey = $mapping[$key] ?? $key;
            // Ne pas écraser si la version snake_case existe déjà
            if (!isset($normalized[$newKey])) {
                $normalized[$newKey] = $value;
            }
        }

        return $normalized;
    }
}
