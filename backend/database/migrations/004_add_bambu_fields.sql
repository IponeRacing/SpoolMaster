-- ============================================
-- Migration: Add Bambu Lab specific fields to spools
-- ============================================
-- Adds drying info, detailed type, and Bambu material IDs
-- These fields are populated from NFC tag data (Bambu Lab MiFare Classic)
-- ============================================

ALTER TABLE spools
    ADD COLUMN IF NOT EXISTS detailed_type VARCHAR(100) NULL AFTER batch_number,
    ADD COLUMN IF NOT EXISTS drying_temp INT NULL AFTER detailed_type,
    ADD COLUMN IF NOT EXISTS drying_time INT NULL AFTER drying_temp,
    ADD COLUMN IF NOT EXISTS material_variant_id VARCHAR(50) NULL AFTER drying_time,
    ADD COLUMN IF NOT EXISTS material_id VARCHAR(50) NULL AFTER material_variant_id;
