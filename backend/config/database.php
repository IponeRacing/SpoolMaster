<?php
/**
 * Configuration de la base de données
 * NFC Anycubic Backend API
 *
 * SECURITY: Credentials loaded from environment variables
 * See .env.example for configuration
 */

use NfcAnycubic\EnvLoader;

// Load environment variables
EnvLoader::load();

return [
    'host' => EnvLoader::get('DB_HOST', 'localhost'),
    'database' => EnvLoader::get('DB_DATABASE', 'nfcscan'),
    'username' => EnvLoader::get('DB_USERNAME', 'nfcuser'),
    'password' => EnvLoader::getRequired('DB_PASSWORD'),
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
    'options' => [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]
];
