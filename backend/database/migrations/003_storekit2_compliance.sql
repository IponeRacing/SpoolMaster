-- ============================================
-- Migration: StoreKit 2 2026 Compliance Updates
-- ============================================
-- This migration adds support for:
-- - App Store Server Notifications V2
-- - Enhanced subscription lifecycle tracking
-- - Rate limiting storage
-- - Audit logging improvements
-- ============================================

-- Add platform column to subscriptions
ALTER TABLE subscriptions
    ADD COLUMN IF NOT EXISTS platform ENUM('ios', 'android') DEFAULT 'ios' AFTER user_id;

-- Add billing retry tracking
ALTER TABLE subscriptions
    ADD COLUMN IF NOT EXISTS billing_retry_count INT DEFAULT 0 AFTER grace_period_expires_date,
    ADD COLUMN IF NOT EXISTS billing_retry_started_at TIMESTAMP NULL AFTER billing_retry_count;

-- Add last notification tracking
ALTER TABLE subscriptions
    ADD COLUMN IF NOT EXISTS last_notification_type VARCHAR(50) NULL,
    ADD COLUMN IF NOT EXISTS last_notification_subtype VARCHAR(50) NULL,
    ADD COLUMN IF NOT EXISTS last_notification_date TIMESTAMP NULL;

-- Add revocation date for refunds
ALTER TABLE subscriptions
    ADD COLUMN IF NOT EXISTS revocation_date TIMESTAMP NULL;

-- Extend status ENUM to include all StoreKit 2 states
-- Note: MySQL doesn't support IF NOT EXISTS for MODIFY, so we do it unconditionally
ALTER TABLE subscriptions
    MODIFY COLUMN status ENUM(
        'active',
        'expired',
        'grace_period',
        'billing_retry',
        'on_hold',
        'paused',
        'revoked',
        'cancelled'
    ) NOT NULL DEFAULT 'active';

-- ============================================
-- Apple Notifications Table
-- ============================================
-- Stores all received App Store Server Notifications for audit and replay prevention
CREATE TABLE IF NOT EXISTS apple_notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id CHAR(36) NULL,
    original_transaction_id VARCHAR(255) NULL,
    notification_type VARCHAR(50) NOT NULL,
    notification_subtype VARCHAR(50) NULL,
    notification_uuid VARCHAR(255) NOT NULL,
    signed_payload MEDIUMTEXT NOT NULL,
    processed BOOLEAN DEFAULT FALSE,
    processed_at TIMESTAMP NULL,
    received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE INDEX idx_notification_uuid (notification_uuid),
    INDEX idx_user_id (user_id),
    INDEX idx_original_transaction (original_transaction_id),
    INDEX idx_notification_type (notification_type),
    INDEX idx_processed (processed),
    INDEX idx_received_at (received_at),

    CONSTRAINT fk_apple_notif_user
        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Subscription Events Table (Audit Trail)
-- ============================================
-- Detailed event log for subscription lifecycle
CREATE TABLE IF NOT EXISTS subscription_events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subscription_id INT NULL,
    user_id CHAR(36) NULL,
    original_transaction_id VARCHAR(255) NULL,
    event_type VARCHAR(50) NOT NULL,
    event_subtype VARCHAR(50) NULL,
    event_data JSON NULL,
    source ENUM('webhook', 'api', 'cron', 'manual', 'client') NOT NULL DEFAULT 'api',
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_subscription_id (subscription_id),
    INDEX idx_user_id (user_id),
    INDEX idx_original_transaction (original_transaction_id),
    INDEX idx_event_type (event_type),
    INDEX idx_source (source),
    INDEX idx_created_at (created_at),

    CONSTRAINT fk_sub_event_subscription
        FOREIGN KEY (subscription_id) REFERENCES subscriptions(id) ON DELETE SET NULL,
    CONSTRAINT fk_sub_event_user
        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Rate Limits Table (for persistent rate limiting)
-- ============================================
-- Optional: Use this instead of file-based rate limiting
CREATE TABLE IF NOT EXISTS rate_limits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    key_hash VARCHAR(64) NOT NULL,
    request_count INT DEFAULT 1,
    window_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    blocked_until TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE INDEX idx_key_hash (key_hash),
    INDEX idx_blocked_until (blocked_until),
    INDEX idx_window_start (window_start)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Subscription Validation Failures (Security Audit)
-- ============================================
-- Track failed validation attempts for security monitoring
CREATE TABLE IF NOT EXISTS subscription_validation_failures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id CHAR(36) NULL,
    transaction_id VARCHAR(255) NULL,
    platform ENUM('ios', 'android') DEFAULT 'ios',
    failure_reason ENUM(
        'invalid_signature',
        'expired_transaction',
        'invalid_bundle_id',
        'replay_attack',
        'invalid_product',
        'certificate_error',
        'network_error',
        'unknown'
    ) NOT NULL,
    jws_payload TEXT NULL,
    error_message TEXT NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_transaction_id (transaction_id),
    INDEX idx_failure_reason (failure_reason),
    INDEX idx_created_at (created_at),
    INDEX idx_ip_address (ip_address)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Cleanup old data procedure
-- ============================================
-- Call periodically to clean up old records
DELIMITER //

CREATE PROCEDURE IF NOT EXISTS cleanup_old_data()
BEGIN
    -- Delete processed notifications older than 90 days
    DELETE FROM apple_notifications
    WHERE processed = 1 AND received_at < DATE_SUB(NOW(), INTERVAL 90 DAY);

    -- Delete old subscription events (keep 1 year)
    DELETE FROM subscription_events
    WHERE created_at < DATE_SUB(NOW(), INTERVAL 365 DAY);

    -- Delete old rate limit records
    DELETE FROM rate_limits
    WHERE window_start < DATE_SUB(NOW(), INTERVAL 1 DAY);

    -- Delete old validation failures (keep 30 days)
    DELETE FROM subscription_validation_failures
    WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
END //

DELIMITER ;

-- ============================================
-- Create event for automatic cleanup (if events are enabled)
-- ============================================
-- Note: MySQL events need to be enabled: SET GLOBAL event_scheduler = ON;
CREATE EVENT IF NOT EXISTS cleanup_old_data_daily
ON SCHEDULE EVERY 1 DAY
STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 3 HOUR)
DO CALL cleanup_old_data();
