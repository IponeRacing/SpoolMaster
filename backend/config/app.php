<?php
/**
 * Configuration de l'application
 * NFC Anycubic Backend API
 */

return [
    'app_name' => 'NFC Anycubic API',
    'api_version' => '1.0.0',
    'base_url' => 'https://api.engageengine.ch',

    // JWT Configuration
    'jwt_secret' => 'a7f8e9d4b2c1f6a8e3d5b9c2f1a4e7d8b3c6f2a9e1d4b7c3f6a2e8d5b1c9f4a7e3', // À changer !
    'jwt_algorithm' => 'HS256',
    'jwt_expiration' => 3600 * 24 * 30, // 30 jours
    'jwt_refresh_expiration' => 3600 * 24 * 90, // 90 jours

    // OAuth Configuration
    'oauth' => [
        'apple' => [
            'client_id' => 'com.engageengine.nfcfilament.service',
            'team_id' => 'Z9M8YMPUDS',
            'key_id' => 'Z9M8YMPUDS',
            'private_key_path' => __DIR__ . '/../keys/AuthKey_Z9M8YMPUDS.p8',
        ],
        'google' => [
            'client_id' => '1091367332850-0gifhmdht0b35kdg9fif0v3608mhqaju.apps.googleusercontent.com',
            'client_secret' => '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',
            'redirect_uri' => 'https://api.engageengine.ch/auth/google/callback',
            // Liste des client IDs acceptés (iOS, Android, Web, etc.)
            'accepted_client_ids' => [
                '1091367332850-0gifhmdht0b35kdg9fif0v3608mhqaju.apps.googleusercontent.com', // iOS
                '434702406042-kqcf1cjc69u1d5c5lbn8j0vdg3djkvb3.apps.googleusercontent.com', // Other client (if any)
            ],
        ],
    ],

    // CORS Configuration
    'cors' => [
        'allowed_origins' => ['*'], // En production, spécifier les domaines autorisés
        'allowed_methods' => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
        'allowed_headers' => ['Content-Type', 'Authorization', 'X-Requested-With'],
        'max_age' => 86400,
    ],

    // Rate Limiting
    'rate_limit' => [
        'enabled' => true,
        'max_requests' => 100, // 100 requêtes
        'per_minutes' => 1, // par minute
    ],

    // Logging
    'logging' => [
        'enabled' => true,
        'path' => __DIR__ . '/../logs/',
        'level' => 'INFO', // DEBUG, INFO, WARNING, ERROR
    ],
];
