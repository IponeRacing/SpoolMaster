<?php

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Logger;
use NfcAnycubic\Services\GooglePlayApiClient;
use NfcAnycubic\Services\PremiumService;

/**
 * Google Play Real-time Developer Notifications (RTDN), via Cloud Pub/Sub.
 *
 * Une notification n'est qu'un signal « cet abonnement a changé » : l'état
 * (échéance, renouvellement automatique) est relu dans l'API Google Play.
 * Avant :
 *  - le contenu de la notification était cru tel quel alors que l'URL n'est
 *    pas authentifiée (n'importe qui pouvait activer ou couper un premium) ;
 *  - un renouvellement ne prolongeait pas expires_date → premium perdu au
 *    bout d'un mois malgré le paiement ;
 *  - les statuts 'on_hold' / 'paused' n'existent pas dans l'ENUM de la table.
 *
 * Seuls les jetons déjà rattachés à un compte (POST /subscriptions/verify)
 * sont traités : un jeton inconnu est ignoré, ce qui borne les appels à
 * l'API Google même en cas de notifications forgées.
 *
 * @see https://developer.android.com/google/play/billing/rtdn-reference
 */
class GooglePlayWebhookController
{
    private const TYPE_REVOKED = 12;

    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * POST /webhooks/google-play
     */
    public function handleNotification()
    {
        $data = json_decode((string)file_get_contents('php://input'), true);
        if (!is_array($data) || !isset($data['message']['data'])) {
            return ['success' => false, 'error' => 'Invalid format'];
        }

        $message = json_decode((string)base64_decode($data['message']['data'], true), true);
        if (!is_array($message)) {
            return ['success' => false, 'error' => 'Invalid message data'];
        }

        if (isset($message['packageName']) && $message['packageName'] !== GooglePlayApiClient::PACKAGE_NAME) {
            return ['success' => true, 'message' => 'Other package ignored'];
        }

        if (isset($message['subscriptionNotification'])) {
            $n = $message['subscriptionNotification'];
            return $this->refreshFromGoogle(
                (string)($n['purchaseToken'] ?? ''),
                (string)($n['subscriptionId'] ?? ''),
                (int)($n['notificationType'] ?? 0) === self::TYPE_REVOKED
            );
        }

        if (isset($message['voidedPurchaseNotification'])) {
            $n = $message['voidedPurchaseNotification'];
            // productType 1 = abonnement (remboursement / rétrofacturation)
            if ((int)($n['productType'] ?? 0) === 1) {
                return $this->refreshFromGoogle((string)($n['purchaseToken'] ?? ''), '', true);
            }
            return ['success' => true, 'message' => 'One-time product voided (ignored)'];
        }

        if (isset($message['testNotification'])) {
            error_log("🧪 Google Play test notification received");
            return ['success' => true, 'message' => 'Test notification received'];
        }

        return ['success' => true, 'message' => 'Notification ignored'];
    }

    /**
     * Relit l'abonnement dans l'API Google Play et met à jour la base.
     * $revoked : remboursé / révoqué (le jeton ne redevient jamais actif).
     */
    private function refreshFromGoogle(string $purchaseToken, string $productId, bool $revoked): array
    {
        if ($purchaseToken === '') {
            return ['success' => false, 'error' => 'Missing purchase token'];
        }

        $originalId = SubscriptionController::googleOriginalId($purchaseToken);
        $stmt = $this->db->prepare("
            SELECT id, user_id, product_id, status FROM subscriptions
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([$originalId]);
        $row = $stmt->fetch(\PDO::FETCH_ASSOC);
        if (!$row) {
            // Pas encore rattaché à un compte : l'app le fera via /subscriptions/verify
            return ['success' => true, 'message' => 'Unknown purchase token'];
        }

        $productId = $productId !== '' ? $productId : (string)$row['product_id'];
        $api = GooglePlayApiClient::create();
        $res = $api->getSubscription($productId, $purchaseToken);

        if ($res['status'] === 0 || $res['status'] >= 500) {
            // Erreur passagère : code non-2xx → Pub/Sub renverra la notification
            http_response_code(503);
            return ['success' => false, 'error' => 'Google Play API unavailable'];
        }
        if ($res['status'] === 410) {
            // Achat trop ancien (expiré depuis longtemps) : plus rien à accorder
            $this->db->prepare("UPDATE subscriptions SET status = 'expired', updated_at = CURRENT_TIMESTAMP WHERE id = ? AND status <> 'revoked'")
                ->execute([$row['id']]);
            $this->refreshPremium($row['user_id']);
            return ['success' => true, 'message' => 'Purchase gone'];
        }
        if ($res['status'] !== 200 || empty($res['data']['expiryTimeMillis'])) {
            Logger::warning('google.rtdn', 'Abonnement introuvable dans l\'API Google Play', ['http_status' => $res['status']]);
            return ['success' => true, 'message' => 'Subscription not found'];
        }

        $data = $res['data'];
        $tx = SubscriptionController::googleTransaction($productId, $purchaseToken, $data);
        $expiresTs = intdiv($tx->expiresDate, 1000);

        if ($revoked || $row['status'] === 'revoked') {
            $status = 'revoked';
        } else {
            // Google prolonge l'échéance pendant la période de grâce ; en
            // suspension (account hold) ou en pause, elle est passée.
            $status = $expiresTs > time() ? 'active' : 'expired';
        }

        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET status = ?,
                expires_date = FROM_UNIXTIME(?),
                transaction_id = COALESCE(?, transaction_id),
                auto_renew_enabled = COALESCE(?, auto_renew_enabled),
                environment = ?,
                revocation_date = CASE WHEN ? = 'revoked' THEN COALESCE(revocation_date, CURRENT_TIMESTAMP) ELSE revocation_date END,
                updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        ");
        $stmt->execute([
            $status,
            $expiresTs,
            $tx->transactionId,
            $tx->autoRenew === null ? null : (int)$tx->autoRenew,
            $tx->environment,
            $status,
            $row['id'],
        ]);

        // Acquittement serveur si l'app ne l'a pas fait (sinon remboursement auto à 3 jours)
        if ($status === 'active' && (int)($data['acknowledgementState'] ?? 1) === 0) {
            $api->acknowledge($productId, $purchaseToken);
        }

        $premium = $this->refreshPremium($row['user_id']);
        error_log("🔔 RTDN appliquée : $originalId -> $status");

        return ['success' => true, 'status' => $status, 'is_premium' => $premium];
    }

    private function refreshPremium(?string $userId): ?bool
    {
        return $userId ? PremiumService::refresh($this->db, $userId) : null;
    }
}
