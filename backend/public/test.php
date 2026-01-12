<?php
/**
 * Script de test de l'environnement
 * Accès : https://engageengine.ch/api/test.php
 * ⚠️ SUPPRIMER CE FICHIER EN PRODUCTION !
 */

header('Content-Type: application/json');

$tests = [];

// Test 1: PHP Version
$tests['php_version'] = [
    'required' => '7.4',
    'current' => PHP_VERSION,
    'status' => version_compare(PHP_VERSION, '7.4', '>=') ? 'OK' : 'FAIL'
];

// Test 2: PDO Extension
$tests['pdo_extension'] = [
    'status' => extension_loaded('pdo') ? 'OK' : 'FAIL'
];

// Test 3: JSON Extension
$tests['json_extension'] = [
    'status' => extension_loaded('json') ? 'OK' : 'FAIL'
];

// Test 4: Database Connection
try {
    $config = require __DIR__ . '/../config/database.php';
    $dsn = sprintf(
        "mysql:host=%s;dbname=%s;charset=%s",
        $config['host'],
        $config['database'],
        $config['charset']
    );
    $pdo = new PDO($dsn, $config['username'], $config['password'], $config['options']);
    $tests['database_connection'] = [
        'status' => 'OK',
        'host' => $config['host'],
        'database' => $config['database']
    ];
} catch (PDOException $e) {
    $tests['database_connection'] = [
        'status' => 'FAIL',
        'error' => $e->getMessage()
    ];
}

// Test 5: Config Files
$tests['config_files'] = [
    'database.php' => file_exists(__DIR__ . '/../config/database.php') ? 'OK' : 'MISSING',
    'app.php' => file_exists(__DIR__ . '/../config/app.php') ? 'OK' : 'MISSING'
];

// Test 6: Vendor Autoload
$tests['composer_autoload'] = [
    'status' => file_exists(__DIR__ . '/../vendor/autoload.php') ? 'OK' : 'FAIL - Run composer install'
];

// Test 7: JWT Secret
$appConfig = require __DIR__ . '/../config/app.php';
$tests['jwt_secret'] = [
    'status' => strlen($appConfig['jwt_secret']) >= 32 ? 'OK' : 'FAIL - Generate JWT secret',
    'length' => strlen($appConfig['jwt_secret'])
];

// Test 8: Write Permissions
$tests['write_permissions'] = [
    'logs' => is_writable(__DIR__ . '/../logs') || mkdir(__DIR__ . '/../logs', 0755, true) ? 'OK' : 'FAIL'
];

// Test 9: mod_rewrite
$tests['mod_rewrite'] = [
    'status' => function_exists('apache_get_modules') && in_array('mod_rewrite', apache_get_modules()) ? 'OK' : 'UNKNOWN'
];

// Global Status
$allOk = true;
foreach ($tests as $test) {
    if (isset($test['status']) && $test['status'] === 'FAIL') {
        $allOk = false;
        break;
    }
}

echo json_encode([
    'success' => $allOk,
    'message' => $allOk ? 'All tests passed! API is ready.' : 'Some tests failed. Check details.',
    'tests' => $tests,
    'server_info' => [
        'software' => $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown',
        'php_sapi' => php_sapi_name(),
        'document_root' => $_SERVER['DOCUMENT_ROOT'] ?? 'Unknown'
    ]
], JSON_PRETTY_PRINT);
