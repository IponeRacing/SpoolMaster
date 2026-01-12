<?php
/**
 * Configuration de la base de données
 * NFC Anycubic Backend API
 */

return [
    'host' => 'ly9x5.myd.infomaniak.com',
    'database' => 'ly9x5_nfcscan',
    'username' => 'ly9x5_nfcuser',
    'password' => 'Levent5na@',
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
    'options' => [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]
];
