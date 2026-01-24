<?php
/**
 * Contrôleur de gestion de la shopping list
 * CRUD complet avec soft delete et sync
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Middleware\AuthMiddleware;

class ShoppingListController {

    /**
     * Récupère toute la shopping list de l'utilisateur
     * GET /shopping-list
     */
    public function getAll() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "SELECT * FROM shopping_list
             WHERE user_id = :user_id AND deleted_at IS NULL
             ORDER BY created_at DESC"
        );
        $stmt->execute(['user_id' => $userId]);
        $items = $stmt->fetchAll();

        // Mapper les noms de champs pour le client
        $mappedItems = array_map(function($item) {
            return $this->mapItemForClient($item);
        }, $items);

        return [
            'success' => true,
            'data' => $mappedItems,
            'count' => count($mappedItems)
        ];
    }

    /**
     * Push les items de la shopping list vers le serveur
     * POST /shopping-list/push
     */
    public function push() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $input = json_decode(file_get_contents('php://input'), true);
        $db = Database::getInstance()->getConnection();

        $itemsSynced = 0;

        if (isset($input['items']) && is_array($input['items'])) {
            foreach ($input['items'] as $item) {
                $item = $this->normalizeFieldNames($item);
                $this->syncItem($userId, $item, $db);
                $itemsSynced++;
            }
        }

        // Sync ordered IDs
        if (isset($input['ordered_ids']) && is_array($input['ordered_ids'])) {
            foreach ($input['ordered_ids'] as $itemId) {
                $stmt = $db->prepare(
                    "UPDATE shopping_list SET is_ordered = TRUE, ordered_at = NOW()
                     WHERE item_id = :item_id AND user_id = :user_id"
                );
                $stmt->execute(['item_id' => $itemId, 'user_id' => $userId]);
            }
        }

        return [
            'success' => true,
            'data' => [
                'items_synced' => $itemsSynced
            ]
        ];
    }

    /**
     * Pull la shopping list depuis le serveur
     * GET /shopping-list/pull
     */
    public function pull() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "SELECT * FROM shopping_list
             WHERE user_id = :user_id AND deleted_at IS NULL
             ORDER BY created_at DESC"
        );
        $stmt->execute(['user_id' => $userId]);
        $items = $stmt->fetchAll();

        // Mapper et récupérer les ordered IDs
        $mappedItems = [];
        $orderedIds = [];

        foreach ($items as $item) {
            $mappedItems[] = $this->mapItemForClient($item);
            if ($item['is_ordered']) {
                $orderedIds[] = $item['item_id'];
            }
        }

        return [
            'success' => true,
            'data' => [
                'items' => $mappedItems,
                'ordered_ids' => $orderedIds,
                'server_time' => date('Y-m-d H:i:s')
            ]
        ];
    }

    /**
     * Ajoute un item à la shopping list
     * POST /shopping-list
     */
    public function create() {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $input = json_decode(file_get_contents('php://input'), true);
        $input = $this->normalizeFieldNames($input);

        if (!isset($input['material']) || !isset($input['color_name'])) {
            return $this->error('Missing required fields', 400);
        }

        $db = Database::getInstance()->getConnection();

        $itemId = $input['item_id'] ?? $this->generateUUID();

        $stmt = $db->prepare(
            "INSERT INTO shopping_list (
                user_id, item_id, brand, material, color_name, color_rgb,
                weight, price, diameter,
                extruder_temp_min, extruder_temp_max, bed_temp_min, bed_temp_max,
                is_ordered
            ) VALUES (
                :user_id, :item_id, :brand, :material, :color_name, :color_rgb,
                :weight, :price, :diameter,
                :extruder_temp_min, :extruder_temp_max, :bed_temp_min, :bed_temp_max,
                :is_ordered
            )"
        );

        $stmt->execute([
            'user_id' => $userId,
            'item_id' => $itemId,
            'brand' => $input['brand'] ?? null,
            'material' => $input['material'],
            'color_name' => $input['color_name'],
            'color_rgb' => $input['color_rgb'] ?? null,
            'weight' => $input['weight'] ?? $input['initial_weight'] ?? null,
            'price' => $input['price'] ?? null,
            'diameter' => $input['diameter'] ?? null,
            'extruder_temp_min' => $input['extruder_temp_min'] ?? null,
            'extruder_temp_max' => $input['extruder_temp_max'] ?? null,
            'bed_temp_min' => $input['bed_temp_min'] ?? null,
            'bed_temp_max' => $input['bed_temp_max'] ?? null,
            'is_ordered' => $input['is_ordered'] ?? false
        ]);

        return [
            'success' => true,
            'data' => [
                'item_id' => $itemId,
                'message' => 'Item added to shopping list'
            ]
        ];
    }

    /**
     * Supprime un item de la shopping list (soft delete)
     * DELETE /shopping-list/:id
     */
    public function delete(array $params) {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $itemId = $params['id'] ?? null;
        if (!$itemId) {
            return $this->error('Missing item ID', 400);
        }

        $db = Database::getInstance()->getConnection();

        $stmt = $db->prepare(
            "UPDATE shopping_list SET deleted_at = NOW()
             WHERE item_id = :item_id AND user_id = :user_id"
        );

        $stmt->execute([
            'item_id' => $itemId,
            'user_id' => $userId
        ]);

        if ($stmt->rowCount() === 0) {
            return $this->error('Item not found', 404);
        }

        return [
            'success' => true,
            'data' => [
                'item_id' => $itemId,
                'message' => 'Item removed from shopping list'
            ]
        ];
    }

    /**
     * Toggle le statut "commandé" d'un item
     * PUT /shopping-list/:id/toggle-ordered
     */
    public function toggleOrdered(array $params) {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return;

        $itemId = $params['id'] ?? null;
        if (!$itemId) {
            return $this->error('Missing item ID', 400);
        }

        $db = Database::getInstance()->getConnection();

        // Toggle is_ordered
        $stmt = $db->prepare(
            "UPDATE shopping_list
             SET is_ordered = NOT is_ordered,
                 ordered_at = CASE WHEN is_ordered = FALSE THEN NOW() ELSE NULL END
             WHERE item_id = :item_id AND user_id = :user_id"
        );

        $stmt->execute([
            'item_id' => $itemId,
            'user_id' => $userId
        ]);

        if ($stmt->rowCount() === 0) {
            return $this->error('Item not found', 404);
        }

        return [
            'success' => true,
            'data' => [
                'item_id' => $itemId,
                'message' => 'Item ordered status toggled'
            ]
        ];
    }

    /**
     * Sync un item individuel
     */
    private function syncItem(string $userId, array $item, $db) {
        $itemId = $item['item_id'] ?? $item['id'] ?? null;
        if (!$itemId) return;

        // Vérifier si l'item existe
        $stmt = $db->prepare(
            "SELECT id FROM shopping_list WHERE item_id = :item_id AND user_id = :user_id LIMIT 1"
        );
        $stmt->execute(['item_id' => $itemId, 'user_id' => $userId]);
        $existing = $stmt->fetch();

        if ($existing) {
            // Update
            $stmt = $db->prepare(
                "UPDATE shopping_list SET
                    brand = :brand, material = :material, color_name = :color_name,
                    color_rgb = :color_rgb, weight = :weight, price = :price,
                    diameter = :diameter,
                    extruder_temp_min = :extruder_temp_min, extruder_temp_max = :extruder_temp_max,
                    bed_temp_min = :bed_temp_min, bed_temp_max = :bed_temp_max,
                    is_ordered = :is_ordered, sync_version = sync_version + 1
                 WHERE item_id = :item_id AND user_id = :user_id"
            );
        } else {
            // Insert
            $stmt = $db->prepare(
                "INSERT INTO shopping_list (
                    user_id, item_id, brand, material, color_name, color_rgb,
                    weight, price, diameter,
                    extruder_temp_min, extruder_temp_max, bed_temp_min, bed_temp_max,
                    is_ordered
                ) VALUES (
                    :user_id, :item_id, :brand, :material, :color_name, :color_rgb,
                    :weight, :price, :diameter,
                    :extruder_temp_min, :extruder_temp_max, :bed_temp_min, :bed_temp_max,
                    :is_ordered
                )"
            );
        }

        $stmt->execute([
            'user_id' => $userId,
            'item_id' => $itemId,
            'brand' => $item['brand'] ?? null,
            'material' => $item['material'] ?? '',
            'color_name' => $item['color_name'] ?? '',
            'color_rgb' => $item['color_rgb'] ?? null,
            'weight' => $item['weight'] ?? $item['initial_weight'] ?? null,
            'price' => $item['price'] ?? null,
            'diameter' => $item['diameter'] ?? null,
            'extruder_temp_min' => $item['extruder_temp_min'] ?? null,
            'extruder_temp_max' => $item['extruder_temp_max'] ?? null,
            'bed_temp_min' => $item['bed_temp_min'] ?? null,
            'bed_temp_max' => $item['bed_temp_max'] ?? null,
            'is_ordered' => $item['is_ordered'] ?? false
        ]);
    }

    /**
     * Mappe un item DB vers le format client
     */
    private function mapItemForClient(array $item): array {
        return [
            'id' => $item['item_id'],
            'brand' => $item['brand'],
            'material' => $item['material'],
            'color_name' => $item['color_name'],
            'color_rgb' => (int)$item['color_rgb'],
            'price' => $item['price'] ? (float)$item['price'] : 0.0,
            'weight' => $item['weight'] ? (float)$item['weight'] : 0.0,
            'remaining_weight' => $item['weight'] ? (float)$item['weight'] : 0.0,
            'diameter' => $item['diameter'] ? (float)$item['diameter'] : null,
            'extruder_temp_min' => $item['extruder_temp_min'] ? (int)$item['extruder_temp_min'] : null,
            'extruder_temp_max' => $item['extruder_temp_max'] ? (int)$item['extruder_temp_max'] : null,
            'bed_temp_min' => $item['bed_temp_min'] ? (int)$item['bed_temp_min'] : null,
            'bed_temp_max' => $item['bed_temp_max'] ? (int)$item['bed_temp_max'] : null,
            'is_ordered' => (bool)$item['is_ordered'],
            'added_date' => $item['created_at'],
            'created_at' => $item['created_at'],
        ];
    }

    /**
     * Normalise les noms de champs
     */
    private function normalizeFieldNames(?array $input): array {
        if (!$input) return [];

        $mapping = [
            'colorName' => 'color_name',
            'colorRgb' => 'color_rgb',
            'initialWeight' => 'initial_weight',
            'remainingWeight' => 'remaining_weight',
            'extruderTempMin' => 'extruder_temp_min',
            'extruderTempMax' => 'extruder_temp_max',
            'bedTempMin' => 'bed_temp_min',
            'bedTempMax' => 'bed_temp_max',
            'isOrdered' => 'is_ordered',
            'addedDate' => 'added_date',
        ];

        $normalized = [];
        foreach ($input as $key => $value) {
            $newKey = $mapping[$key] ?? $key;
            if (!isset($normalized[$newKey])) {
                $normalized[$newKey] = $value;
            }
        }

        return $normalized;
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
}
