<?php
/**
 * Contrôleur de gestion des bobines (spools)
 * CRUD complet avec soft delete
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Middleware\AuthMiddleware;

class SpoolController {

    /**
     * Récupère toutes les bobines de l'utilisateur
     * GET /spools
     */
    public function getAll() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "SELECT * FROM spools
             WHERE user_id = :user_id AND deleted_at IS NULL
             ORDER BY created_at DESC"
        );
        $stmt->execute(['user_id' => $userId]);
        $spools = $stmt->fetchAll();

        return [
            'success' => true,
            'data' => $spools,
            'count' => count($spools)
        ];
    }

    /**
     * Récupère une bobine spécifique
     * GET /spools/:id
     */
    public function getOne(array $params) {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $spoolId = $params['id'] ?? null;
        if (!$spoolId) {
            return $this->error('Missing spool ID', 400);
        }

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "SELECT * FROM spools
             WHERE spool_id = :spool_id AND user_id = :user_id AND deleted_at IS NULL
             LIMIT 1"
        );
        $stmt->execute([
            'spool_id' => $spoolId,
            'user_id' => $userId
        ]);
        $spool = $stmt->fetch();

        if (!$spool) {
            return $this->error('Spool not found', 404);
        }

        return [
            'success' => true,
            'data' => $spool
        ];
    }

    /**
     * Crée une nouvelle bobine
     * POST /spools
     */
    public function create() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $input = json_decode(file_get_contents('php://input'), true);

        // Normaliser les noms de champs (accepter camelCase et snake_case)
        $input = $this->normalizeFieldNames($input);

        // Validation
        if (!isset($input['material']) || !isset($input['color_name']) || !isset($input['initial_weight'])) {
            return $this->error('Missing required fields', 400);
        }

        $db = Database::getInstance()->getConnection();

        $spoolId = $input['spool_id'] ?? $this->generateUUID();

        $stmt = $db->prepare(
            "INSERT INTO spools (
                user_id, spool_id, brand, material, color_name, color_rgb,
                initial_weight, remaining_weight, price, diameter, spool_length,
                extruder_temp_min, extruder_temp_max, bed_temp_min, bed_temp_max,
                manufacture_date, batch_number, purchase_date, notes, last_synced_at
            ) VALUES (
                :user_id, :spool_id, :brand, :material, :color_name, :color_rgb,
                :initial_weight, :remaining_weight, :price, :diameter, :spool_length,
                :extruder_temp_min, :extruder_temp_max, :bed_temp_min, :bed_temp_max,
                :manufacture_date, :batch_number, :purchase_date, :notes, NOW()
            )"
        );

        $stmt->execute([
            'user_id' => $userId,
            'spool_id' => $spoolId,
            'brand' => $input['brand'] ?? null,
            'material' => $input['material'],
            'color_name' => $input['color_name'],
            'color_rgb' => $input['color_rgb'] ?? null,
            'initial_weight' => $input['initial_weight'],
            'remaining_weight' => $input['remaining_weight'] ?? $input['initial_weight'],
            'price' => $input['price'] ?? null,
            'diameter' => $input['diameter'] ?? null,
            'spool_length' => $input['spool_length'] ?? null,
            'extruder_temp_min' => $input['extruder_temp_min'] ?? null,
            'extruder_temp_max' => $input['extruder_temp_max'] ?? null,
            'bed_temp_min' => $input['bed_temp_min'] ?? null,
            'bed_temp_max' => $input['bed_temp_max'] ?? null,
            'manufacture_date' => $input['manufacture_date'] ?? null,
            'batch_number' => $input['batch_number'] ?? null,
            'purchase_date' => $input['purchase_date'] ?? null,
            'notes' => $input['notes'] ?? null
        ]);

        return [
            'success' => true,
            'data' => [
                'spool_id' => $spoolId,
                'message' => 'Spool created successfully'
            ]
        ];
    }

    /**
     * Met à jour une bobine
     * PUT /spools/:id
     */
    public function update(array $params) {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $spoolId = $params['id'] ?? null;
        if (!$spoolId) {
            return $this->error('Missing spool ID', 400);
        }

        $input = json_decode(file_get_contents('php://input'), true);

        // Normaliser les noms de champs (accepter camelCase et snake_case)
        $input = $this->normalizeFieldNames($input);

        $db = Database::getInstance()->getConnection();

        // Vérifier que la bobine appartient à l'utilisateur
        $stmt = $db->prepare(
            "SELECT id FROM spools WHERE spool_id = :spool_id AND user_id = :user_id LIMIT 1"
        );
        $stmt->execute(['spool_id' => $spoolId, 'user_id' => $userId]);

        if (!$stmt->fetch()) {
            return $this->error('Spool not found', 404);
        }

        // Construire la requête de mise à jour dynamiquement
        $fields = [];
        $values = ['spool_id' => $spoolId, 'user_id' => $userId];

        $allowedFields = [
            'brand', 'material', 'color_name', 'color_rgb', 'initial_weight',
            'remaining_weight', 'price', 'diameter', 'spool_length',
            'extruder_temp_min', 'extruder_temp_max', 'bed_temp_min', 'bed_temp_max',
            'manufacture_date', 'batch_number', 'purchase_date', 'notes'
        ];

        foreach ($allowedFields as $field) {
            if (isset($input[$field])) {
                $fields[] = "$field = :$field";
                $values[$field] = $input[$field];
            }
        }

        if (empty($fields)) {
            return $this->error('No fields to update', 400);
        }

        $sql = "UPDATE spools SET " . implode(', ', $fields) . ", sync_version = sync_version + 1, last_synced_at = NOW()
                WHERE spool_id = :spool_id AND user_id = :user_id";

        $stmt = $db->prepare($sql);
        $stmt->execute($values);

        return [
            'success' => true,
            'data' => [
                'spool_id' => $spoolId,
                'message' => 'Spool updated successfully'
            ]
        ];
    }

    /**
     * Supprime une bobine (soft delete)
     * DELETE /spools/:id
     */
    public function delete(array $params) {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $spoolId = $params['id'] ?? null;
        if (!$spoolId) {
            return $this->error('Missing spool ID', 400);
        }

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "UPDATE spools SET deleted_at = NOW(), last_synced_at = NOW()
             WHERE spool_id = :spool_id AND user_id = :user_id"
        );

        $stmt->execute([
            'spool_id' => $spoolId,
            'user_id' => $userId
        ]);

        if ($stmt->rowCount() === 0) {
            return $this->error('Spool not found', 404);
        }

        return [
            'success' => true,
            'data' => [
                'spool_id' => $spoolId,
                'message' => 'Spool deleted successfully'
            ]
        ];
    }

    private function generateUUID(): string {
        return sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
            mt_rand(0, 0xffff), mt_rand(0, 0xffff),
            mt_rand(0, 0xffff),
            mt_rand(0, 0x0fff) | 0x4000,
            mt_rand(0, 0x3fff) | 0x8000,
            mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
        );
    }

    private function error(string $message, int $code = 400): array {
        http_response_code($code);
        return [
            'success' => false,
            'error' => $message
        ];
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
