-- NFC Anycubic Backend Database Schema
-- Compatible with MariaDB 10.4.25
-- Conformité Apple & Google OAuth 2025-2026

-- Table des utilisateurs avec support révocation OAuth
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) UNIQUE NOT NULL COMMENT 'UUID unique pour l\'utilisateur',
    email VARCHAR(255) UNIQUE NOT NULL,
    email_verified BOOLEAN DEFAULT FALSE,
    name VARCHAR(255),
    provider ENUM('apple', 'google') NOT NULL,
    provider_id VARCHAR(255) NOT NULL COMMENT 'ID unique du provider (sub claim)',
    avatar_url TEXT,

    -- Apple specific: support relay email
    apple_relay_email VARCHAR(255) COMMENT 'Email relay Apple si utilisé',

    -- OAuth 2.0 tokens
    access_token TEXT COMMENT 'Token stocké uniquement si nécessaire',
    refresh_token TEXT COMMENT 'Refresh token pour renouvellement',
    token_expires_at TIMESTAMP NULL,

    -- Révocation et sécurité (requis 2025)
    is_revoked BOOLEAN DEFAULT FALSE COMMENT 'Token révoqué par user',
    revoked_at TIMESTAMP NULL,

    -- GDPR compliance
    data_deletion_requested BOOLEAN DEFAULT FALSE,
    data_deletion_requested_at TIMESTAMP NULL,

    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,

    -- Indexes
    INDEX idx_user_id (user_id),
    INDEX idx_email (email),
    INDEX idx_provider_id (provider, provider_id),
    UNIQUE KEY unique_provider (provider, provider_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des sessions OAuth (pour PKCE et sécurité)
CREATE TABLE IF NOT EXISTS oauth_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    device_id VARCHAR(255) COMMENT 'ID unique du device',
    device_name VARCHAR(255) COMMENT 'iPhone 15 Pro, etc.',
    ip_address VARCHAR(45),
    user_agent TEXT,

    -- PKCE (Proof Key for Code Exchange)
    code_verifier VARCHAR(128) COMMENT 'PKCE code verifier',
    code_challenge VARCHAR(128) COMMENT 'PKCE code challenge',

    -- Session management
    expires_at TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_session_token (session_token),
    INDEX idx_expires_at (expires_at),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des bobines (spools)
CREATE TABLE IF NOT EXISTS spools (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    spool_id VARCHAR(255) UNIQUE NOT NULL COMMENT 'UUID unique de la bobine',

    -- Informations bobine
    brand VARCHAR(255),
    material VARCHAR(255) NOT NULL,
    color_name VARCHAR(255) NOT NULL,
    color_rgb INT,

    -- Poids
    initial_weight DECIMAL(10,2) NOT NULL COMMENT 'Poids initial en grammes',
    remaining_weight DECIMAL(10,2) NOT NULL COMMENT 'Poids restant en grammes',

    -- Prix et dimensions
    price DECIMAL(10,2),
    diameter DECIMAL(5,2) COMMENT 'Diamètre en mm',
    spool_length INT COMMENT 'Longueur en mètres',

    -- Paramètres d\'impression
    extruder_temp_min INT COMMENT 'Température extrudeur min (°C)',
    extruder_temp_max INT COMMENT 'Température extrudeur max (°C)',
    bed_temp_min INT COMMENT 'Température plateau min (°C)',
    bed_temp_max INT COMMENT 'Température plateau max (°C)',

    -- Traçabilité
    manufacture_date DATE,
    batch_number VARCHAR(255),
    purchase_date DATE,
    notes TEXT,

    -- Synchronisation
    last_synced_at TIMESTAMP NULL COMMENT 'Dernière sync avec le serveur',
    sync_version INT DEFAULT 1 COMMENT 'Version pour résolution conflits',

    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL COMMENT 'Soft delete pour sync',

    INDEX idx_user_id (user_id),
    INDEX idx_spool_id (spool_id),
    INDEX idx_deleted_at (deleted_at),
    INDEX idx_last_synced (last_synced_at),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table d'historique de synchronisation
CREATE TABLE IF NOT EXISTS sync_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    sync_type ENUM('full', 'partial', 'push', 'pull') NOT NULL,
    items_synced INT DEFAULT 0,
    items_conflicts INT DEFAULT 0 COMMENT 'Nombre de conflits résolus',
    status ENUM('success', 'partial', 'failed') NOT NULL,
    error_message TEXT,
    device_id VARCHAR(255),
    duration_ms INT COMMENT 'Durée de la sync en millisecondes',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des analytics (conformité GDPR)
CREATE TABLE IF NOT EXISTS analytics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NULL COMMENT 'NULL = scan anonyme (invité non connecté)',
    event_type VARCHAR(100) NOT NULL COMMENT 'scan_nfc, add_spool, etc.',
    event_data JSON COMMENT 'Données anonymisées',

    -- Métadonnées
    device_platform ENUM('ios', 'android') NOT NULL,
    app_version VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_event_type (event_type),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table des préférences utilisateur (pour sync cloud)
CREATE TABLE IF NOT EXISTS user_preferences (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) UNIQUE NOT NULL,

    -- Préférences app
    language VARCHAR(5) DEFAULT 'fr' COMMENT 'fr, en, de, it',
    currency VARCHAR(3) DEFAULT 'CHF' COMMENT 'CHF, EUR, USD',
    units ENUM('metric', 'imperial') DEFAULT 'metric',
    low_stock_threshold INT DEFAULT 100 COMMENT 'Seuil stock bas en grammes',

    -- Préférences privacy
    analytics_enabled BOOLEAN DEFAULT TRUE,
    crash_reports_enabled BOOLEAN DEFAULT TRUE,

    -- Sync settings
    auto_sync_enabled BOOLEAN DEFAULT TRUE,
    sync_on_wifi_only BOOLEAN DEFAULT FALSE,

    -- VIP/Subscription
    is_vip BOOLEAN DEFAULT FALSE,
    vip_expires_at TIMESTAMP NULL,
    subscription_type ENUM('monthly', 'yearly') NULL,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table de révocation des tokens (Apple & Google compliance 2025)
CREATE TABLE IF NOT EXISTS token_revocations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    provider ENUM('apple', 'google') NOT NULL,
    token_identifier VARCHAR(255) NOT NULL COMMENT 'JTI du token JWT',
    reason ENUM('user_logout', 'user_request', 'security', 'expired') NOT NULL,
    revoked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_token_identifier (token_identifier),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table de logs audit (sécurité et conformité)
CREATE TABLE IF NOT EXISTS audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255),
    action VARCHAR(100) NOT NULL COMMENT 'login, logout, data_access, data_delete, etc.',
    resource_type VARCHAR(50) COMMENT 'user, spool, session, etc.',
    resource_id VARCHAR(255),
    ip_address VARCHAR(45),
    user_agent TEXT,
    success BOOLEAN DEFAULT TRUE,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
