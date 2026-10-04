<?php
/**
 * Statut premium d'un utilisateur — source de vérité unique.
 *
 * Premium = VIP manuel actif (geste commercial, support : vip_manual = 1)
 *           OU abonnement actif dans `subscriptions`.
 *
 * Avant : is_vip servait à la fois de drapeau manuel et de cache des
 * abonnements ; le cron et les webhooks le remettaient à 0 dès qu'aucun
 * abonnement n'était actif → les VIP accordés à la main étaient effacés.
 * Chaque endroit avait en plus sa propre définition d'« actif » (période de
 * grâce ignorée ici, comptée là).
 *
 * Désormais :
 *  - un VIP manuel actif n'est JAMAIS modifié par le code automatique ;
 *  - is_vip / vip_expires_at des comptes non manuels ne sont qu'un cache,
 *    recalculé ici depuis les abonnements (refresh) ;
 *  - « actif » = status 'active' et expires_date future, ou 'grace_period' et
 *    fin de grâce future (Apple : l'échéance est passée mais l'accès continue).
 */

namespace NfcAnycubic\Services;

use PDO;

class PremiumService {

    /** Échéance effective d'un abonnement (alias de table : s). */
    public const EFFECTIVE_EXPIRY_SQL =
        "CASE WHEN s.status = 'grace_period' THEN COALESCE(s.grace_period_expires_date, s.expires_date) ELSE s.expires_date END";

    /** Condition « abonnement donnant accès » (alias de table : s). */
    public const ACTIVE_SQL =
        "((s.status = 'active' AND s.expires_date > NOW())
          OR (s.status = 'grace_period' AND COALESCE(s.grace_period_expires_date, s.expires_date) > NOW()))";

    /** VIP manuel actif ? (ligne user_preferences) */
    public static function isManualVipActive(?array $prefs): bool {
        // vip_current calculé par MySQL (même fuseau que la colonne)
        return $prefs && !empty($prefs['is_vip']) && !empty($prefs['vip_manual']) && !empty($prefs['vip_current']);
    }

    /** Meilleur abonnement actif (échéance effective la plus lointaine), ou null. */
    public static function activeSubscription(PDO $db, string $userId): ?array {
        $stmt = $db->prepare(
            "SELECT s.product_id, s.status, " . self::EFFECTIVE_EXPIRY_SQL . " AS expires_date,
                    s.auto_renew_enabled, s.environment, s.platform
               FROM subscriptions s
              WHERE s.user_id = ? AND " . self::ACTIVE_SQL . "
              ORDER BY expires_date DESC
              LIMIT 1"
        );
        $stmt->execute([$userId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    }

    /** Réponse de GET /subscriptions/status. */
    public static function status(PDO $db, string $userId): array {
        $prefs = self::prefs($db, $userId);
        if (self::isManualVipActive($prefs)) {
            return [
                'is_premium' => true,
                'subscription' => [
                    'product_id' => $prefs['subscription_type'] ?? 'lifetime',
                    'status' => 'active',
                    'expires_date' => $prefs['vip_expires_at'],
                    'auto_renew_enabled' => null,
                    'type' => 'vip',
                ],
            ];
        }
        $sub = self::activeSubscription($db, $userId);
        if ($sub) {
            $sub['auto_renew_enabled'] = $sub['auto_renew_enabled'] === null ? null : (bool)$sub['auto_renew_enabled'];
            $sub['type'] = 'subscription';
        }
        return ['is_premium' => $sub !== null, 'subscription' => $sub];
    }

    /**
     * Recalcule le cache is_vip / vip_expires_at depuis les abonnements.
     * Ne touche pas un VIP manuel actif. Retourne le statut premium.
     */
    public static function refresh(PDO $db, string $userId): bool {
        $prefs = self::prefs($db, $userId);
        if (self::isManualVipActive($prefs)) {
            return true;
        }

        $sub = self::activeSubscription($db, $userId);
        if ($sub) {
            // Un VIP manuel expiré cède la place à l'abonnement.
            $stmt = $db->prepare(
                "INSERT INTO user_preferences (user_id, is_vip, vip_expires_at, vip_manual)
                 VALUES (?, 1, ?, 0)
                 ON DUPLICATE KEY UPDATE is_vip = 1, vip_expires_at = VALUES(vip_expires_at), vip_manual = 0"
            );
            $stmt->execute([$userId, $sub['expires_date']]);
            return true;
        }

        if ($prefs && !empty($prefs['is_vip'])) {
            $stmt = $db->prepare(
                "UPDATE user_preferences SET is_vip = 0, vip_expires_at = NULL, vip_manual = 0 WHERE user_id = ?"
            );
            $stmt->execute([$userId]);
        }
        return false;
    }

    /** Recalcule le cache du propriétaire d'un abonnement (webhooks). */
    public static function refreshForTransaction(PDO $db, string $originalTransactionId): ?bool {
        $stmt = $db->prepare("SELECT user_id FROM subscriptions WHERE original_transaction_id = ?");
        $stmt->execute([$originalTransactionId]);
        $userId = $stmt->fetchColumn();
        return $userId ? self::refresh($db, (string)$userId) : null;
    }

    private static function prefs(PDO $db, string $userId): ?array {
        $stmt = $db->prepare(
            "SELECT is_vip, vip_expires_at, vip_manual, subscription_type,
                    (vip_expires_at IS NULL OR vip_expires_at > NOW()) AS vip_current
               FROM user_preferences WHERE user_id = ?"
        );
        $stmt->execute([$userId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    }
}
