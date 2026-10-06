<?php
/**
 * Durées de conservation promises par la politique de confidentialité (§7) :
 * « Logs système : 90 jours maximum » ; « Transactions d'abonnement :
 * conservées sans lien avec votre compte ». Rien ne les appliquait avant le
 * 06.10.2026 (journaux depuis janvier, IP de comptes supprimés conservées).
 *
 * Lancé chaque jour par le cron du rapport quotidien.
 */

namespace NfcAnycubic\Services;

use PDO;

class RetentionService {
    public const LOG_DAYS = 90;

    /** @return array<string,int> lignes touchées par table */
    public static function apply(PDO $db, ?string $logDir = null): array {
        $days = self::LOG_DAYS;
        $done = [];

        // Journaux système : supprimés après 90 jours. Les preuves de
        // suppression de compte restent (id pseudonyme seul, sans IP).
        $done['audit_logs'] = $db->exec(
            "DELETE FROM audit_logs WHERE created_at < NOW() - INTERVAL $days DAY
               AND action NOT IN ('account_deleted', 'account_deletion_cancelled')"
        );
        $done['subscription_validation_failures'] = $db->exec(
            "DELETE FROM subscription_validation_failures WHERE created_at < NOW() - INTERVAL $days DAY"
        );
        $done['sync_history'] = $db->exec(
            "DELETE FROM sync_history WHERE created_at < NOW() - INTERVAL $days DAY"
        );
        // Notifications App Store brutes une fois traitées (règle prévue par
        // la procédure cleanup_old_data de la migration 003, dont l'événement
        // planifié n'a jamais tourné sur l'hébergement mutualisé). L'état qui
        // en découle reste dans subscriptions / subscription_events.
        $done['apple_notifications'] = $db->exec(
            "DELETE FROM apple_notifications WHERE processed = 1 AND received_at < NOW() - INTERVAL $days DAY"
        );

        // Transactions gardées pour la comptabilité, sans IP ni user agent
        // au-delà de 90 jours.
        $done['subscription_events'] = $db->exec(
            "UPDATE subscription_events SET ip_address = NULL, user_agent = NULL
              WHERE created_at < NOW() - INTERVAL $days DAY
                AND (ip_address IS NOT NULL OR user_agent IS NOT NULL)"
        );

        // Comptes supprimés avant que la purge ne détache leurs données.
        $orphans = $db->query(
            "SELECT DISTINCT user_id FROM (
                SELECT user_id FROM audit_logs WHERE user_id IS NOT NULL AND (ip_address IS NOT NULL OR user_agent IS NOT NULL)
                UNION SELECT user_id FROM subscription_events WHERE user_id IS NOT NULL
                UNION SELECT user_id FROM apple_notifications WHERE user_id IS NOT NULL
                UNION SELECT user_id FROM subscription_validation_failures WHERE user_id IS NOT NULL
             ) t
             WHERE NOT EXISTS (SELECT 1 FROM users u WHERE u.user_id = t.user_id)"
        )->fetchAll(PDO::FETCH_COLUMN);
        foreach ($orphans as $userId) {
            AccountPurgeService::detachUser($db, (string)$userId);
        }
        $done['detached_accounts'] = \count($orphans);

        // Ancien journal PHP (rotation à 10 Mo) : effacé après 90 jours
        $old = ($logDir ?? __DIR__ . '/../../logs') . '/php_errors.log.1';
        $done['old_php_log'] = (\is_file($old) && \filemtime($old) < \time() - $days * 86400 && @\unlink($old)) ? 1 : 0;

        return $done;
    }
}
