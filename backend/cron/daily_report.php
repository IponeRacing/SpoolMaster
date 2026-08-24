<?php
/**
 * CRON Job: Rapport journalier Spool Master
 *
 * Génère et envoie un rapport quotidien avec les métriques NFC,
 * utilisateurs et abonnements des dernières 24h.
 *
 * Configuration CRON (Infomaniak) :
 * 0 8 * * * /usr/bin/php /var/www/nfc-backend/cron/daily_report.php
 */

require_once __DIR__ . '/../vendor/autoload.php';

use NfcAnycubic\Controllers\ReportController;

try {
    error_log("📊 [CRON] Starting daily report generation...");

    // Simuler les params de route avec le secret
    $envFile = __DIR__ . '/../.env';
    if (file_exists($envFile)) {
        $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos($line, '#') === 0) continue;
            if (strpos($line, '=') !== false) {
                putenv(trim($line));
            }
        }
    }

    $config = require __DIR__ . '/../config/app.php';
    $secret = $config['cron_secret'] ?? '';

    if (empty($secret)) {
        error_log("❌ [CRON] CRON_SECRET not configured");
        exit(1);
    }

    $controller = new ReportController();
    $result = $controller->dailyReport(['secret' => $secret]);

    if ($result['success'] ?? false) {
        error_log("✅ [CRON] Daily report sent successfully");
    } else {
        error_log("❌ [CRON] Daily report failed: " . ($result['error'] ?? 'unknown'));
        exit(1);
    }

} catch (\Exception $e) {
    error_log("❌ [CRON] Fatal error: " . $e->getMessage());
    exit(1);
}
