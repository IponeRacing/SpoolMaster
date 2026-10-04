<?php
/**
 * Suppression définitive d'un compte (RGPD, Apple 5.1.1(v), Google Play).
 *
 * Avant : DELETE /user/account ne faisait que poser data_deletion_requested=1
 * (« supprimé sous 30 jours ») et aucune purge n'existait → données jamais
 * effacées, jetons Sign in with Apple jamais révoqués.
 *
 * Purge = révocation du jeton Apple (si connu) puis DELETE de la ligne users :
 * toutes les tables liées sont en ON DELETE CASCADE (bobines, conso, liste de
 * courses, préférences, abonnements, analytics, historique de synchro,
 * sessions, révocations). apple_notifications / subscription_events passent
 * en user_id NULL (pièces comptables). Une trace minimale reste dans
 * audit_logs (id pseudonyme, sans email ni nom).
 */

namespace NfcAnycubic\Services;

use NfcAnycubic\Logger;
use PDO;

class AccountPurgeService {

    /** Supprime définitivement un compte. true si la ligne users a été supprimée. */
    public static function purge(PDO $db, string $userId, string $reason, ?AppleSignInService $apple = null): bool {
        $stmt = $db->prepare("SELECT * FROM users WHERE user_id = :user_id LIMIT 1");
        $stmt->execute(['user_id' => $userId]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$user) {
            return false;
        }

        // 1. Révocation Sign in with Apple (best effort : ne bloque pas la purge)
        $appleRevoked = null;
        if (($user['provider'] ?? '') === 'apple' && !empty($user['apple_refresh_token'])) {
            try {
                $appleRevoked = ($apple ?? new AppleSignInService())->revoke($user['apple_refresh_token']);
            } catch (\Throwable $e) {
                $appleRevoked = false;
                Logger::exception('account.purge', $e, ['step' => 'apple_revoke']);
            }
        }

        // 2. Suppression (cascade sur toutes les données liées)
        $stmt = $db->prepare("DELETE FROM users WHERE user_id = :user_id");
        $stmt->execute(['user_id' => $userId]);
        $deleted = $stmt->rowCount() > 0;

        // 3. Trace d'audit minimale (pas de donnée personnelle)
        $stmt = $db->prepare(
            "INSERT INTO audit_logs (user_id, action, resource_type, success, error_message)
             VALUES (:user_id, 'account_deleted', 'user', :success, :detail)"
        );
        $stmt->execute([
            'user_id' => $userId,
            'success' => $deleted ? 1 : 0,
            'detail' => json_encode([
                'reason' => $reason,
                'provider' => $user['provider'] ?? null,
                'apple_revoked' => $appleRevoked,
            ]),
        ]);

        if ($appleRevoked === false) {
            Logger::warning('account.purge', 'Compte supprimé mais jeton Apple non révoqué', ['reason' => $reason]);
        }
        return $deleted;
    }

    /**
     * Purge les comptes dont la suppression a été demandée (demandes
     * antérieures à la suppression immédiate, ou purge immédiate échouée).
     * Un compte reconnecté APRÈS sa demande n'est pas supprimé : il est
     * signalé dans les logs pour vérification manuelle.
     *
     * @return array{purged:int, skipped_relogged:int}
     */
    public static function purgePending(PDO $db): array {
        $stmt = $db->query(
            "SELECT user_id, data_deletion_requested_at, last_login
               FROM users
              WHERE data_deletion_requested = 1"
        );
        $purged = 0;
        $skipped = 0;
        foreach ($stmt->fetchAll(PDO::FETCH_ASSOC) as $row) {
            $requested = $row['data_deletion_requested_at'] ? strtotime($row['data_deletion_requested_at']) : null;
            $lastLogin = $row['last_login'] ? strtotime($row['last_login']) : null;
            if ($requested !== null && $lastLogin !== null && $lastLogin > $requested + 60) {
                $skipped++;
                Logger::warning('account.purge', 'Compte reconnecté après sa demande de suppression : non purgé', [
                    'user_id' => $row['user_id'],
                ]);
                continue;
            }
            try {
                if (self::purge($db, $row['user_id'], 'pending_request')) {
                    $purged++;
                }
            } catch (\Throwable $e) {
                Logger::exception('account.purge', $e, ['user_id' => $row['user_id']]);
            }
        }
        return ['purged' => $purged, 'skipped_relogged' => $skipped];
    }
}
