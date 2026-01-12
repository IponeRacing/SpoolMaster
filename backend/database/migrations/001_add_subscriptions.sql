-- Migration: Add Apple In-App Purchase subscriptions support
-- Best practices 2025: StoreKit 2 + App Store Server API + Server Notifications V2

-- Table des abonnements Apple (StoreKit 2)
CREATE TABLE IF NOT EXISTS subscriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,

    -- Apple StoreKit 2 identifiers
    original_transaction_id VARCHAR(255) UNIQUE NOT NULL COMMENT 'ID unique de l\'abonnement (ne change jamais)',
    transaction_id VARCHAR(255) NOT NULL COMMENT 'ID de la dernière transaction',
    product_id VARCHAR(100) NOT NULL COMMENT 'spool_master_monthly ou spool_master_yearly',

    -- Subscription status (from App Store Server Notifications V2)
    status ENUM(
        'active',           -- Abonnement actif
        'expired',          -- Expiré
        'grace_period',     -- Période de grâce (paiement échoué mais accès maintenu)
        'billing_retry',    -- Tentative de renouvellement
        'revoked',          -- Révoqué par Apple (remboursement)
        'cancelled'         -- Annulé par l'utilisateur
    ) NOT NULL DEFAULT 'active',

    -- Dates importantes
    purchase_date TIMESTAMP NOT NULL COMMENT 'Date d\'achat initiale',
    expires_date TIMESTAMP NOT NULL COMMENT 'Date d\'expiration',
    renewal_date TIMESTAMP NULL COMMENT 'Date de prochain renouvellement',
    cancellation_date TIMESTAMP NULL COMMENT 'Date d\'annulation',
    revocation_date TIMESTAMP NULL COMMENT 'Date de révocation (refund)',
    grace_period_expires_date TIMESTAMP NULL,

    -- Auto-renewal status
    auto_renew_enabled BOOLEAN DEFAULT TRUE,
    auto_renew_product_id VARCHAR(100) COMMENT 'Produit après upgrade/downgrade',

    -- Price and offer
    price_currency VARCHAR(3) COMMENT 'CHF, EUR, USD',
    price_amount DECIMAL(10,2) COMMENT 'Montant payé',
    offer_type ENUM('introductory', 'promotional', 'subscription_offer', 'none') DEFAULT 'none',
    offer_id VARCHAR(255) NULL,

    -- StoreKit 2 signed data (pour vérification)
    jws_transaction TEXT COMMENT 'Signed transaction JWS from Apple',
    jws_renewal_info TEXT COMMENT 'Signed renewal info JWS from Apple',

    -- Environment
    environment ENUM('Sandbox', 'Production') NOT NULL DEFAULT 'Production',

    -- Server Notifications tracking
    last_notification_type VARCHAR(50) COMMENT 'Type du dernier événement reçu',
    last_notification_subtype VARCHAR(50),
    last_notification_date TIMESTAMP NULL,

    -- Sync and audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_original_transaction_id (original_transaction_id),
    INDEX idx_status (status),
    INDEX idx_expires_date (expires_date),
    INDEX idx_environment (environment),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table pour l'historique des notifications Apple (audit trail)
CREATE TABLE IF NOT EXISTS apple_notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255),
    original_transaction_id VARCHAR(255),

    -- Notification V2 data
    notification_type VARCHAR(50) NOT NULL COMMENT 'SUBSCRIBED, DID_RENEW, EXPIRED, etc.',
    notification_subtype VARCHAR(50) COMMENT 'INITIAL_BUY, RESUBSCRIBE, UPGRADE, etc.',
    notification_uuid VARCHAR(255) UNIQUE NOT NULL COMMENT 'UUID unique de la notification',

    -- Full JWS payload (for audit and replay)
    signed_payload TEXT NOT NULL COMMENT 'Full signedPayload from Apple',

    -- Processing status
    processed BOOLEAN DEFAULT FALSE,
    processed_at TIMESTAMP NULL,
    processing_error TEXT NULL,

    received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_transaction_id (original_transaction_id),
    INDEX idx_notification_type (notification_type),
    INDEX idx_notification_uuid (notification_uuid),
    INDEX idx_processed (processed),
    INDEX idx_received_at (received_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table pour les échecs de validation (sécurité)
CREATE TABLE IF NOT EXISTS subscription_validation_failures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255),
    transaction_id VARCHAR(255),

    failure_reason ENUM(
        'invalid_signature',
        'expired_transaction',
        'invalid_bundle_id',
        'invalid_product_id',
        'replay_attack',
        'server_error',
        'other'
    ) NOT NULL,

    error_details TEXT,
    jws_payload TEXT COMMENT 'Payload qui a échoué la validation',
    ip_address VARCHAR(45),
    user_agent TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_failure_reason (failure_reason),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Mise à jour de la table user_preferences pour sync premium status
-- (les colonnes existent déjà, on ajoute juste un index)
ALTER TABLE user_preferences
    ADD INDEX idx_is_vip (is_vip),
    ADD INDEX idx_vip_expires (vip_expires_at);
