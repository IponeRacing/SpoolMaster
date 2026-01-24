-- Migration: Add shopping list table
-- Date: 2026-01-21

CREATE TABLE IF NOT EXISTS shopping_list (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    item_id VARCHAR(255) UNIQUE NOT NULL COMMENT 'UUID unique de l\'item',

    -- Informations item (copie du spool souhaité)
    brand VARCHAR(255),
    material VARCHAR(255) NOT NULL,
    color_name VARCHAR(255) NOT NULL,
    color_rgb INT,

    -- Prix et dimensions souhaités
    price DECIMAL(10,2),
    weight DECIMAL(10,2) COMMENT 'Poids souhaité en grammes',
    diameter DECIMAL(5,2) COMMENT 'Diamètre souhaité en mm',

    -- Paramètres d'impression souhaités
    extruder_temp_min INT,
    extruder_temp_max INT,
    bed_temp_min INT,
    bed_temp_max INT,

    -- Statut
    is_ordered BOOLEAN DEFAULT FALSE COMMENT 'Item commandé ou non',
    ordered_at TIMESTAMP NULL COMMENT 'Date de commande',

    -- Synchronisation
    sync_version INT DEFAULT 1,

    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL COMMENT 'Soft delete pour sync',

    INDEX idx_user_id (user_id),
    INDEX idx_item_id (item_id),
    INDEX idx_deleted_at (deleted_at),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
