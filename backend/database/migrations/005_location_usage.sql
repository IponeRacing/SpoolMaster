-- ============================================
-- Migration: Emplacement des bobines + historique de consommation
-- ============================================
-- 1. spools.location : emplacement physique libre (« Étagère A »…).
--    (spools.notes existe déjà depuis le schéma initial.)
--    + nozzle_size / vendor_code / product_code / added_date (champs app
--    jamais stockés jusqu'ici).
-- 2. spool_usage : journal des baisses de poids restant (app 1.4.10+).
--    Additif uniquement, idempotent : les apps <= 1.4.9 ne sont pas impactées.
-- À exécuter AVANT de déployer SpoolController/SyncController/UsageController.
-- ============================================

ALTER TABLE spools
    ADD COLUMN IF NOT EXISTS location VARCHAR(255) NULL AFTER notes,
    -- Champs du modèle app jamais stockés jusqu'ici (perdus à chaque pull)
    ADD COLUMN IF NOT EXISTS nozzle_size DECIMAL(4,2) NULL AFTER material_id,
    ADD COLUMN IF NOT EXISTS vendor_code VARCHAR(50) NULL AFTER nozzle_size,
    ADD COLUMN IF NOT EXISTS product_code VARCHAR(100) NULL AFTER vendor_code,
    -- Date d'ajout réelle (envoyée par l'app mais jamais stockée : le pull
    -- renvoyait created_at). NULL pour les lignes existantes → repli sur created_at.
    ADD COLUMN IF NOT EXISTS added_date DATETIME NULL AFTER product_code;

CREATE TABLE IF NOT EXISTS spool_usage (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    event_id VARCHAR(255) NOT NULL COMMENT 'Id généré par l''app (idempotence)',
    spool_id VARCHAR(255) NOT NULL,
    used_at DATETIME NOT NULL,
    grams DECIMAL(10,2) NOT NULL,
    cost DECIMAL(10,2) NOT NULL DEFAULT 0,
    brand VARCHAR(255) NULL,
    material VARCHAR(255) NULL,
    color_name VARCHAR(255) NULL,
    color_rgb INT NULL,
    source VARCHAR(20) NOT NULL DEFAULT 'update',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uniq_user_event (user_id, event_id),
    INDEX idx_user_used_at (user_id, used_at),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
