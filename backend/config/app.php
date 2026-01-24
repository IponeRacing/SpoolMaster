<?php
/**
 * Configuration de l'application
 * NFC Anycubic Backend API
 *
 * SECURITY: Sensitive values loaded from environment variables
 * See .env.example for configuration
 */

use NfcAnycubic\EnvLoader;

// Load environment variables
EnvLoader::load();

// Helper function to parse comma-separated env values
$parseList = function(string $key, array $default = []): array {
    $value = EnvLoader::get($key, '');
    if (empty($value)) {
        return $default;
    }
    return array_filter(array_map('trim', explode(',', $value)));
};

return [
    'app_name' => 'NFC Anycubic API',
    'api_version' => '1.0.0',
    'base_url' => EnvLoader::get('APP_BASE_URL', 'https://api.engageengine.ch'),
    'debug' => EnvLoader::isDebug(),

    // JWT Configuration - SECRET MUST BE FROM ENVIRONMENT
    'jwt_secret' => EnvLoader::getRequired('JWT_SECRET'),
    'jwt_algorithm' => 'HS256',
    'jwt_expiration' => 3600 * 24 * 30, // 30 days
    'jwt_refresh_expiration' => 3600 * 24 * 90, // 90 days

    // OAuth Configuration
    'oauth' => [
        'apple' => [
            'client_id' => EnvLoader::get('APPLE_CLIENT_ID', 'com.engageengine.nfcfilament.service'),
            'team_id' => EnvLoader::get('APPLE_TEAM_ID', 'Z9M8YMPUDS'),
            'key_id' => EnvLoader::get('APPLE_KEY_ID', 'Z9M8YMPUDS'),
            'bundle_id' => EnvLoader::get('APPLE_BUNDLE_ID', 'com.engageengine.nfcfilament'),
            'private_key_path' => __DIR__ . '/../keys/AuthKey_' . EnvLoader::get('APPLE_KEY_ID', 'Z9M8YMPUDS') . '.p8',
        ],
        'google' => [
            'client_id' => EnvLoader::get('GOOGLE_CLIENT_ID', ''),
            'client_secret' => EnvLoader::get('GOOGLE_CLIENT_SECRET', ''),
            'redirect_uri' => EnvLoader::get('APP_BASE_URL', 'https://api.engageengine.ch') . '/auth/google/callback',
            // List of accepted client IDs (iOS, Android, Web, etc.)
            'accepted_client_ids' => $parseList('GOOGLE_ACCEPTED_CLIENT_IDS', [
                '1091367332850-0gifhmdht0b35kdg9fif0v3608mhqaju.apps.googleusercontent.com',
                '434702406042-kqcf1cjc69u1d5c5lbn8j0vdg3djkvb3.apps.googleusercontent.com',
            ]),
        ],
    ],

    // Apple App Store Server API (StoreKit 2)
    'apple_appstore' => [
        'issuer_id' => EnvLoader::get('APPLE_ISSUER_ID', ''),
        'key_id' => EnvLoader::get('APPLE_KEY_ID_APPSTORE', ''),
        'bundle_id' => EnvLoader::get('APPLE_BUNDLE_ID', 'com.engageengine.nfcfilament'),
        'private_key_path' => __DIR__ . '/../keys/AuthKey_AppStoreConnect_' . EnvLoader::get('APPLE_KEY_ID_APPSTORE', '') . '.p8',
    ],

    // CORS Configuration
    'cors' => [
        'allowed_origins' => $parseList('CORS_ALLOWED_ORIGINS', ['*']),
        'allowed_methods' => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
        'allowed_headers' => ['Content-Type', 'Authorization', 'X-Requested-With'],
        'max_age' => 86400,
    ],

    // CRON Security
    'cron_secret' => EnvLoader::get('CRON_SECRET', ''),

    // Rate Limiting
    'rate_limit' => [
        'enabled' => EnvLoader::get('RATE_LIMIT_ENABLED', true),
        'max_requests' => (int) EnvLoader::get('RATE_LIMIT_MAX_REQUESTS', 100),
        'per_minutes' => (int) EnvLoader::get('RATE_LIMIT_PER_MINUTES', 1),
    ],

    // Logging
    'logging' => [
        'enabled' => true,
        'path' => __DIR__ . '/../logs/',
        'level' => EnvLoader::isDebug() ? 'DEBUG' : 'INFO',
    ],
];
