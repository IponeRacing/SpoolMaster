<?php
/**
 * Point d'entrée principal de l'API
 * NFC Anycubic Backend
 * Compatible avec Apple & Google OAuth 2025-2026
 * StoreKit 2 Server-to-Server compliant
 */

// Autoloader (needed for EnvLoader)
require_once __DIR__ . '/../vendor/autoload.php';

use NfcAnycubic\EnvLoader;
use NfcAnycubic\Logger;
use NfcAnycubic\Middleware\RateLimiter;

// Load environment variables first
EnvLoader::load();

// ===========================================
// Error handling & logging (avant tout le reste : CORS, rate limit, config)
// ===========================================
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);

// Journal dans api/logs/php_errors.log : emplacement connu et lisible en SSH
// (sinon error_log() part dans le log par défaut de l'hébergement).
$logDir = __DIR__ . '/../logs';
if (is_dir($logDir) && is_writable($logDir)) {
    $logFile = $logDir . '/php_errors.log';
    // Rotation simple : au-delà de 10 Mo, on archive (une génération).
    if (is_file($logFile) && filesize($logFile) > 10 * 1024 * 1024) {
        rename($logFile, $logFile . '.1');
    }
    ini_set('error_log', $logFile);
}

Logger::init();

set_error_handler(function($errno, $errstr, $errfile, $errline) {
    // Respecter @ et error_reporting (avant : un @mail() levait quand même).
    if (!(error_reporting() & $errno)) {
        return false;
    }
    // Dépréciations : journalisées mais non bloquantes (une montée de version
    // PHP ou d'une dépendance ne doit pas mettre l'API en 500).
    if ($errno === E_DEPRECATED || $errno === E_USER_DEPRECATED) {
        Logger::warningOnce('deprecated', $errstr . ' @ ' . basename($errfile) . ':' . $errline);
        return true;
    }
    throw new ErrorException($errstr, 0, $errno, $errfile, $errline);
});

set_exception_handler(function(\Throwable $exception) {
    // Avant : aucune trace côté serveur → les 500 étaient invisibles.
    Logger::exception('uncaught', $exception);
    if (!headers_sent()) {
        http_response_code(500);
        header('Content-Type: application/json; charset=utf-8');
    }
    $debug = EnvLoader::isDebug();
    echo json_encode([
        'success' => false,
        'error' => 'Internal server error',
        'request_id' => Logger::requestId(),
        // Détails seulement en debug : un message PDO expose le schéma SQL.
        'message' => $debug ? $exception->getMessage() : null,
        'trace' => $debug ? $exception->getTraceAsString() : null
    ]);
});

// Erreurs fatales (mémoire, timeout, parse) : non attrapables par le handler
// d'exceptions → on les journalise avec le contexte de la requête.
register_shutdown_function(function() {
    $error = error_get_last();
    $fatal = [E_ERROR, E_PARSE, E_CORE_ERROR, E_COMPILE_ERROR, E_USER_ERROR];
    if ($error === null || !in_array($error['type'], $fatal, true)) {
        return;
    }
    Logger::error('fatal', $error['message'] . ' @ ' . basename($error['file']) . ':' . $error['line']);
    if (!headers_sent()) {
        http_response_code(500);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode([
            'success' => false,
            'error' => 'Internal server error',
            'request_id' => Logger::requestId()
        ]);
    }
});

// Load configuration
$config = require __DIR__ . '/../config/app.php';

// ===========================================
// CORS Configuration (Secure)
// ===========================================
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';
$allowedOrigins = $config['cors']['allowed_origins'] ?? ['*'];
$allowAllOrigins = in_array('*', $allowedOrigins);

// Determine if origin is allowed
$originAllowed = false;

if ($allowAllOrigins) {
    // Development mode - allow all
    $originAllowed = true;
    header('Access-Control-Allow-Origin: *');
} elseif (!empty($origin) && in_array($origin, $allowedOrigins)) {
    // Origin is in whitelist
    $originAllowed = true;
    header('Access-Control-Allow-Origin: ' . $origin);
    header('Vary: Origin');
} elseif (empty($origin)) {
    // No Origin header - likely a mobile app or server-to-server call
    // Allow these requests (mobile apps don't send Origin)
    $originAllowed = true;
    header('Access-Control-Allow-Origin: *');
} else {
    // Origin not in whitelist - log and reject for browser requests
    error_log("CORS: Rejected origin: $origin. Allowed: " . implode(', ', $allowedOrigins));
    // Still set header but will return 403 for non-preflight requests with bad origin
}

header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
// Pas d'Access-Control-Allow-Credentials : l'API n'utilise aucun cookie
// (jeton Bearer), et « * » + credentials est refusé par les navigateurs.
header('Access-Control-Max-Age: 86400');
header('Content-Type: application/json; charset=utf-8');

// Handle preflight OPTIONS requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Reject browser requests from unauthorized origins
if (!empty($origin) && !$originAllowed) {
    http_response_code(403);
    echo json_encode([
        'success' => false,
        'error' => 'CORS origin not allowed'
    ]);
    exit();
}

// ===========================================
// Rate Limiting
// ===========================================
if ($config['rate_limit']['enabled'] ?? true) {
    $rateLimitResult = RateLimiter::checkByIp(
        $config['rate_limit']['max_requests'] ?? 100,
        ($config['rate_limit']['per_minutes'] ?? 1) * 60
    );

    if (!$rateLimitResult) {
        RateLimiter::tooManyRequests();
    }
}

use NfcAnycubic\Router;
use NfcAnycubic\Controllers\AuthController;
use NfcAnycubic\Controllers\SpoolController;
use NfcAnycubic\Controllers\SyncController;
use NfcAnycubic\Controllers\UserController;
use NfcAnycubic\Controllers\AnalyticsController;
use NfcAnycubic\Controllers\SubscriptionController;
use NfcAnycubic\Controllers\AppleServerNotificationController;
use NfcAnycubic\Controllers\GooglePlayWebhookController;
use NfcAnycubic\Controllers\ShoppingListController;
use NfcAnycubic\Controllers\ReportController;
use NfcAnycubic\Controllers\AppController;
use NfcAnycubic\Controllers\UsageController;

// Router simple
$router = new Router();

// ============================================
// Routes publiques (pas d'auth requise)
// ============================================

// Health check
$router->get('/health', function() {
    return [
        'success' => true,
        'status' => 'API is running',
        'version' => '1.0.0',
        'timestamp' => time()
    ];
});

// Version check (prompt de mise à jour in-app) — public, appelé au lancement
$router->get('/app/version-check', [AppController::class, 'versionCheck']);

// OAuth endpoints
$router->post('/auth/apple', [AuthController::class, 'loginWithApple']);
$router->post('/auth/google', [AuthController::class, 'loginWithGoogle']);
$router->post('/auth/refresh', [AuthController::class, 'refreshToken']);

// Apple App Store Server Notifications V2 webhook (public - Apple calls this)
$router->post('/subscriptions/webhook', [AppleServerNotificationController::class, 'handleNotification']);

// Google Play RTDN webhook (public - Google calls this via Pub/Sub)
$router->post('/webhooks/google-play', [GooglePlayWebhookController::class, 'handleNotification']);

// CRON endpoint (public but with secret key)
$router->get('/cron/check-expired/:secret', [SubscriptionController::class, 'cronCheckExpired']);
$router->get('/cron/daily-report/:secret', [ReportController::class, 'dailyReport']);
// Outils de support : secret dans l'en-tête X-Admin-Secret, pas dans l'URL.
$router->get('/admin/scan-analysis', [ReportController::class, 'scanAnalysis']);
$router->get('/admin/user-search', [ReportController::class, 'userSearch']);

// ============================================
// Routes protégées (auth requise)
// ============================================

// User endpoints
$router->get('/user/profile', [UserController::class, 'getProfile']);
$router->put('/user/profile', [UserController::class, 'updateProfile']);
$router->delete('/user/account', [UserController::class, 'deleteAccount']);
$router->post('/user/logout', [UserController::class, 'logout']);

// Spool endpoints (CRUD)
$router->get('/spools', [SpoolController::class, 'getAll']);
$router->get('/spools/:id', [SpoolController::class, 'getOne']);
$router->post('/spools', [SpoolController::class, 'create']);
$router->put('/spools/:id', [SpoolController::class, 'update']);
$router->delete('/spools/:id', [SpoolController::class, 'delete']);

// Sync endpoints
$router->post('/sync/push', [SyncController::class, 'push']);
$router->get('/sync/pull', [SyncController::class, 'pull']);  // GET pour récupérer les données
$router->post('/sync/pull', [SyncController::class, 'pull']); // POST aussi supporté
$router->get('/sync/history', [SyncController::class, 'getHistory']);

// Historique de consommation (app 1.4.10+)
$router->get('/usage', [UsageController::class, 'pull']);
$router->post('/usage', [UsageController::class, 'push']);

// Shopping list endpoints
$router->get('/shopping-list', [ShoppingListController::class, 'getAll']);
$router->post('/shopping-list', [ShoppingListController::class, 'create']);
$router->post('/shopping-list/push', [ShoppingListController::class, 'push']);
$router->get('/shopping-list/pull', [ShoppingListController::class, 'pull']);
$router->delete('/shopping-list/:id', [ShoppingListController::class, 'delete']);
$router->put('/shopping-list/:id/toggle-ordered', [ShoppingListController::class, 'toggleOrdered']);

// Analytics endpoints
$router->post('/analytics/event', [AnalyticsController::class, 'logEvent']);
$router->get('/analytics/scans', [AnalyticsController::class, 'getScans']);
$router->get('/analytics/stats', [AnalyticsController::class, 'getStats']);

// Subscription endpoints (auth required)
$router->post('/subscriptions/verify', [SubscriptionController::class, 'verifyPurchase']);
$router->get('/subscriptions/status', [SubscriptionController::class, 'getSubscriptionStatus']);

// Execute router
$router->execute();
