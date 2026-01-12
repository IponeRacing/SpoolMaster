<?php
/**
 * Point d'entrée principal de l'API
 * NFC Anycubic Backend
 * Compatible avec Apple & Google OAuth 2025-2026
 */

// CORS Headers
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
header('Content-Type: application/json; charset=utf-8');

// Gestion des requêtes OPTIONS (preflight)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Autoloader
require_once __DIR__ . '/../vendor/autoload.php';

use NfcAnycubic\Router;
use NfcAnycubic\Controllers\AuthController;
use NfcAnycubic\Controllers\SpoolController;
use NfcAnycubic\Controllers\SyncController;
use NfcAnycubic\Controllers\UserController;
use NfcAnycubic\Controllers\AnalyticsController;
use NfcAnycubic\Controllers\SubscriptionController;

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

// OAuth endpoints
$router->post('/auth/apple', [AuthController::class, 'loginWithApple']);
$router->post('/auth/google', [AuthController::class, 'loginWithGoogle']);
$router->post('/auth/refresh', [AuthController::class, 'refreshToken']);

// Apple In-App Purchase webhook (public - Apple calls this)
$router->post('/subscriptions/webhook', [SubscriptionController::class, 'handleAppleWebhook']);

// CRON endpoint (public but with secret key)
$router->get('/cron/check-expired/:secret', [SubscriptionController::class, 'cronCheckExpired']);

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
$router->post('/sync/pull', [SyncController::class, 'pull']);
$router->get('/sync/history', [SyncController::class, 'getHistory']);

// Analytics endpoints
$router->post('/analytics/event', [AnalyticsController::class, 'logEvent']);
$router->get('/analytics/scans', [AnalyticsController::class, 'getScans']);
$router->get('/analytics/stats', [AnalyticsController::class, 'getStats']);

// Subscription endpoints (auth required)
$router->post('/subscriptions/verify', [SubscriptionController::class, 'verifyPurchase']);
$router->get('/subscriptions/status', [SubscriptionController::class, 'getSubscriptionStatus']);
$router->post('/subscriptions/check-expired', [SubscriptionController::class, 'checkExpiredSubscriptions']);

// Execute router
$router->execute();
