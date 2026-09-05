<?php
/**
 * Contrôleur de synchronisation
 * Gère la sync bidirectionnelle des données local ↔ cloud
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
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

        $input = json_decode(file_get_contents('php://input'), true);
        $db = Database::getInstance()->getConnection();

        $syncStart = microtime(true);
        $itemsSynced = 0;
        $conflicts = 0;

        // Sync des bobines
        if (isset($input['spools']) && is_array($input['spools'])) {
            foreach ($input['spools'] as $spool) {
                // Normaliser les noms de champs
                $spool = $this->normalizeFieldNames($spool);
                $result = $this->syncSpool($userId, $spool);
                if ($result['synced']) $itemsSynced++;
                if ($result['conflict']) $conflicts++;
            }
        }

        // Sync des préférences
        if (isset($input['preferences'])) {
            $this->syncPreferences($userId, $input['preferences']);
        }

        $duration = round((microtime(true) - $syncStart) * 1000);

        // Logger la sync
        $this->logSync($userId, 'push', $itemsSynced, $conflicts, $duration, 'success');

        return [
            'success' => true,
            'data' => [
                'items_synced' => $itemsSynced,
                'conflicts' => $conflicts,
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

        // Récupérer les bobines modifiées depuis last_sync
        if ($lastSync) {
            $stmt = $db->prepare(
                "SELECT * FROM spools
                 WHERE user_id = :user_id AND updated_at > :last_sync
                 ORDER BY updated_at ASC"
            );
            $stmt->execute(['user_id' => $userId, 'last_sync' => $lastSync]);
        } else {
            // Première sync : tout récupérer
            $stmt = $db->prepare(
                "SELECT * FROM spools
                 WHERE user_id = :user_id
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
     * Synchronise une bobine (résolution de conflits)
     */
    private function syncSpool(string $userId, array $spool): array {
        $db = Database::getInstance()->getConnection();

        // Vérifier si la bobine existe
        $stmt = $db->prepare(
            "SELECT sync_version, updated_at, deleted_at FROM spools
             WHERE spool_id = :spool_id AND user_id = :user_id
             LIMIT 1"
        );
        $stmt->execute([
            'spool_id' => $spool['spool_id'],
            'user_id' => $userId
        ]);
        $existing = $stmt->fetch();

        // GARDE-FOU TOMBSTONE : un push en masse ne doit JAMAIS ressusciter une
        // bobine déjà supprimée côté serveur. Sans ça, une app dont le local
        // contient encore d'anciennes bobines (supprimées ailleurs) les
        // ré-activait à chaque sync (boucle de résurrection). L'app n'a pas de
        // fonction « restaurer » → ne jamais dé-supprimer via push est sûr.
        $incomingDeletedAt = $spool['deleted_at'] ?? null;
        $effectiveDeletedAt = $incomingDeletedAt;
        if ($existing && $existing['deleted_at'] !== null && $incomingDeletedAt === null) {
            $effectiveDeletedAt = $existing['deleted_at'];
        }

        $conflict = false;

        if ($existing) {
            // Résolution de conflit : last-write-wins avec version
            $localVersion = $spool['sync_version'] ?? 1;
            $serverVersion = $existing['sync_version'];

            if ($localVersion < $serverVersion) {
                // Conflit : le serveur est plus récent
                $conflict = true;
                return ['synced' => false, 'conflict' => true];
            }

            // Mettre à jour
            $stmt = $db->prepare(
                "UPDATE spools SET
                    brand = :brand, material = :material, color_name = :color_name,
                    color_rgb = :color_rgb, initial_weight = :initial_weight,
                    remaining_weight = :remaining_weight, price = :price,
                    diameter = :diameter, spool_length = :spool_length,
                    extruder_temp_min = :extruder_temp_min, extruder_temp_max = :extruder_temp_max,
                    bed_temp_min = :bed_temp_min, bed_temp_max = :bed_temp_max,
                    manufacture_date = :manufacture_date, batch_number = :batch_number,
                    detailed_type = :detailed_type, drying_temp = :drying_temp, drying_time = :drying_time,
                    material_variant_id = :material_variant_id, material_id = :material_id,
                    purchase_date = :purchase_date, notes = :notes,
                    deleted_at = :deleted_at, sync_version = :sync_version, last_synced_at = NOW()
                 WHERE spool_id = :spool_id AND user_id = :user_id"
            );
        } else {
            // Créer
            $stmt = $db->prepare(
                "INSERT INTO spools (
                    user_id, spool_id, brand, material, color_name, color_rgb,
                    initial_weight, remaining_weight, price, diameter, spool_length,
                    extruder_temp_min, extruder_temp_max, bed_temp_min, bed_temp_max,
                    manufacture_date, batch_number, detailed_type, drying_temp, drying_time,
                    material_variant_id, material_id, purchase_date, notes,
                    deleted_at, sync_version, last_synced_at
                ) VALUES (
                    :user_id, :spool_id, :brand, :material, :color_name, :color_rgb,
                    :initial_weight, :remaining_weight, :price, :diameter, :spool_length,
                    :extruder_temp_min, :extruder_temp_max, :bed_temp_min, :bed_temp_max,
                    :manufacture_date, :batch_number, :detailed_type, :drying_temp, :drying_time,
                    :material_variant_id, :material_id, :purchase_date, :notes,
                    :deleted_at, :sync_version, NOW()
                )"
            );
        }

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
            'notes' => $spool['notes'] ?? null,
            'deleted_at' => $effectiveDeletedAt,
            'sync_version' => ($spool['sync_version'] ?? 1) + 1
        ]);

        return ['synced' => true, 'conflict' => $conflict];
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
            $sql = "INSERT INTO user_preferences (user_id, " . implode(', ', array_keys($prefs)) . ")
                    VALUES (:user_id, " . implode(', ', array_map(fn($k) => ":$k", array_keys($prefs))) . ")
                    ON DUPLICATE KEY UPDATE " . implode(', ', $fields);

            $stmt = $db->prepare($sql);
            $stmt->execute($values);
        }
    }

    /**
     * Logger une sync
     */
    private function logSync(string $userId, string $type, int $items, int $conflicts, int $duration, string $status) {
        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "INSERT INTO sync_history (user_id, sync_type, items_synced, items_conflicts, duration_ms, status)
             VALUES (:user_id, :sync_type, :items_synced, :items_conflicts, :duration_ms, :status)"
        );

        $stmt->execute([
            'user_id' => $userId,
            'sync_type' => $type,
            'items_synced' => $items,
            'items_conflicts' => $conflicts,
            'duration_ms' => $duration,
            'status' => $status
        ]);
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
