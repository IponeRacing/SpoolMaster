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
use NfcAnycubic\Middleware\RateLimiter;

// Load environment variables first
EnvLoader::load();

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
header('Access-Control-Allow-Credentials: true');
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

// Error handling
error_reporting(E_ALL);
ini_set('display_errors', 0);
set_error_handler(function($errno, $errstr, $errfile, $errline) {
    throw new ErrorException($errstr, 0, $errno, $errfile, $errline);
});

set_exception_handler(function($exception) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Internal server error',
        'message' => $exception->getMessage(),
        'trace' => $_ENV['APP_DEBUG'] ?? false ? $exception->getTraceAsString() : null
    ]);
});

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
$router->get('/cron/scan-analysis/:secret', [ReportController::class, 'scanAnalysis']);
$router->get('/cron/user-search/:secret', [ReportController::class, 'userSearch']);

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
$router->post('/subscriptions/debug', [SubscriptionController::class, 'debugVerify']); // TEMP DEBUG - REMOVE
$router->get('/subscriptions/status', [SubscriptionController::class, 'getSubscriptionStatus']);
$router->post('/subscriptions/check-expired', [SubscriptionController::class, 'checkExpiredSubscriptions']);

// Execute router
$router->execute();
