<?php
/**
 * CRON Job: Vérifier et marquer les abonnements expirés
 *
 * À exécuter toutes les heures pour mettre à jour automatiquement
 * le statut des abonnements expirés
 *
 * Configuration CRON :
 * 0 * * * * /usr/bin/php /var/www/nfc-backend/cron/check_expired_subscriptions.php
 */

require_once __DIR__ . '/../vendor/autoload.php';

use NfcAnycubic\Database;

try {
    error_log("🕐 [CRON] Starting subscription expiration check...");

    $db = Database::getInstance()->getConnection();

    // 1. Mettre à jour les abonnements expirés (status = active et expires_date < NOW)
    $stmt = $db->prepare("
        UPDATE subscriptions
        SET status = 'expired',
            updated_at = CURRENT_TIMESTAMP
        WHERE status = 'active'
          AND expires_date IS NOT NULL
          AND expires_date < NOW()
    ");

    $stmt->execute();
    $expiredCount = $stmt->rowCount();

    if ($expiredCount > 0) {
        error_log("⏰ [CRON] Marked $expiredCount subscription(s) as expired");
    } else {
        error_log("✅ [CRON] No subscriptions to expire");
    }

    // 2. Désactiver le premium pour les utilisateurs dont tous les abonnements sont expirés
    $stmt = $db->prepare("
        UPDATE user_preferences up
        SET is_vip = 0,
            vip_expires_at = NULL
        WHERE up.is_vip = 1
          AND NOT EXISTS (
              SELECT 1
              FROM subscriptions s
              WHERE s.user_id = up.user_id
                AND s.status = 'active'
                AND (s.expires_date IS NULL OR s.expires_date > NOW())
          )
    ");

    $stmt->execute();
    $deactivatedCount = $stmt->rowCount();

    if ($deactivatedCount > 0) {
        error_log("📱 [CRON] Deactivated premium for $deactivatedCount user(s)");
    } else {
        error_log("✅ [CRON] No users to deactivate");
    }

    error_log("✅ [CRON] Subscription expiration check completed");

} catch (\Exception $e) {
    error_log("❌ [CRON] Error: " . $e->getMessage());
    exit(1);
}
