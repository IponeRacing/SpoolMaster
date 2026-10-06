<?php
/**
 * CRON (ligne de commande) : abonnements expirés et cache premium.
 *
 * En prod, le planificateur Infomaniak appelle l'URL /cron/check-expired/:secret
 * chaque heure ; ce script sert si on passe un jour à une tâche en ligne de
 * commande : php cron/check_expired_subscriptions.php
 *
 * Il délègue à SubscriptionController::checkExpiredSubscriptions(). Avant le
 * 06.10.2026, il gardait sa propre copie de l'ancienne logique (VIP manuels et
 * période de grâce ignorés : VIP et abonnés en grâce auraient été rétrogradés).
 */

require_once __DIR__ . '/../vendor/autoload.php';

use NfcAnycubic\Controllers\SubscriptionController;

try {
    $result = (new SubscriptionController())->checkExpiredSubscriptions();
    if (!($result['success'] ?? false)) {
        error_log("❌ [CRON] Expiration check failed: " . ($result['error'] ?? 'unknown'));
        exit(1);
    }
} catch (\Throwable $e) {
    error_log("❌ [CRON] Error: " . $e->getMessage());
    exit(1);
}
