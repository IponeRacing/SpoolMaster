<?php
/**
 * Apple App Store Server Notifications V2 Handler
 * Compliant with Apple's 2025-2026 requirements
 *
 * Handles real-time subscription lifecycle events from Apple
 *
 * @see https://developer.apple.com/documentation/appstoreservernotifications
 * @package NfcAnycubic\Controllers
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\EnvLoader;
use NfcAnycubic\Logger;
use NfcAnycubic\Services\AppleJWSVerifier;
use NfcAnycubic\Services\PremiumService;

class AppleServerNotificationController
{
    private $db;
    private $bundleId;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
        $this->bundleId = EnvLoader::get('APPLE_BUNDLE_ID', 'com.engageengine.nfcfilament');
    }

    /**
     * POST /subscriptions/webhook
     * Receives App Store Server Notifications V2
     *
     * Apple sends a JWS (JSON Web Signature) signed payload containing:
     * - notificationType: The type of event
     * - subtype: Additional context for some notification types
     * - data: Contains signedTransactionInfo and signedRenewalInfo
     */
    public function handleNotification()
    {
        $input = file_get_contents('php://input');
        error_log("========================================");
        error_log("🍎 Apple Server Notification V2 received");
        error_log("========================================");

        $data = json_decode($input, true);

        if (!isset($data['signedPayload'])) {
            error_log("❌ No signedPayload in notification");
            return $this->error('Invalid notification format', 400);
        }

        try {
            // Step 1: Verify and decode the signed payload (JWS)
            $payload = $this->verifyAndDecodeNotification($data['signedPayload']);

            if (!$payload) {
                error_log("❌ Failed to verify notification signature");
                return $this->error('Invalid signature', 401);
            }

            // Step 2: Check for replay attack
            $notificationUUID = $payload->notificationUUID ?? null;
            if ($notificationUUID && $this->isReplayAttack($notificationUUID)) {
                error_log("⚠️ Replay attack detected: " . $notificationUUID);
                // Return success to prevent Apple from retrying
                return ['success' => true, 'message' => 'Already processed'];
            }

            // Step 3: JWS internes (transaction, renouvellement), signés eux aussi
            // par Apple : vérifiés comme l'enveloppe (avant : simplement décodés).
            $transactionInfo = isset($payload->data->signedTransactionInfo)
                ? $this->decodeSignedData($payload->data->signedTransactionInfo) : null;
            $renewalInfo = isset($payload->data->signedRenewalInfo)
                ? $this->decodeSignedData($payload->data->signedRenewalInfo) : null;

            // Step 4: Store notification for audit trail
            $this->storeNotification($payload, $data['signedPayload'], $transactionInfo);

            // Step 5: Process the notification (ignorée si plus ancienne que la
            // dernière traitée pour cet abonnement : Apple ne garantit pas l'ordre)
            $signedDateMs = (int)($payload->signedDate ?? 0);
            if ($transactionInfo && $this->isOutOfOrder($transactionInfo->originalTransactionId, $signedDateMs)) {
                $result = 'out_of_order_ignored';
            } else {
                $result = $this->processNotification($payload, $transactionInfo, $renewalInfo);
                if ($transactionInfo) {
                    $this->recordNotification($transactionInfo->originalTransactionId, $payload, $signedDateMs);
                    PremiumService::refreshForTransaction($this->db, $transactionInfo->originalTransactionId);
                }
            }

            // Step 5: Mark as processed
            if ($notificationUUID) {
                $this->markNotificationProcessed($notificationUUID);
            }

            error_log("✅ Notification processed successfully: $result");

            return ['success' => true, 'processed' => $result];

        } catch (\Throwable $e) {
            Logger::exception('apple.notification', $e);
            return $this->error('Processing failed', 500);
        }
    }

    /**
     * Vérifie la signature de la notification : chaîne x5c complète jusqu'à
     * Apple Root CA - G3 (avant : seul « l'émetteur contient Apple » était
     * contrôlé, n'importe quel certificat auto-signé passait).
     */
    private function verifyAndDecodeNotification(string $signedPayload): ?object
    {
        $decoded = AppleJWSVerifier::verify($signedPayload);
        if (!$decoded) {
            Logger::warning('apple.notification', 'Notification App Store refusée', ['reason' => AppleJWSVerifier::$lastError]);
            return null;
        }

        if (isset($decoded->data->bundleId) && $decoded->data->bundleId !== $this->bundleId) {
            Logger::warning('apple.notification', 'Bundle ID inattendu', ['bundle_id' => $decoded->data->bundleId]);
            return null;
        }

        error_log("✅ Notification signature verified");
        error_log("📋 Type: " . ($decoded->notificationType ?? 'unknown'));
        error_log("📋 Subtype: " . ($decoded->subtype ?? 'none'));

        return $decoded;
    }

    /**
     * Notification plus ancienne que la dernière appliquée à cet abonnement ?
     */
    private function isOutOfOrder(?string $originalTransactionId, int $signedDateMs): bool
    {
        if (!$originalTransactionId || $signedDateMs <= 0) return false;
        $stmt = $this->db->prepare(
            "SELECT UNIX_TIMESTAMP(last_notification_date) FROM subscriptions WHERE original_transaction_id = ?"
        );
        $stmt->execute([$originalTransactionId]);
        $last = $stmt->fetchColumn();
        if ($last === false || $last === null) return false;
        if (intdiv($signedDateMs, 1000) < (int)$last) {
            error_log("⏭️ Notification hors ordre ignorée pour $originalTransactionId");
            return true;
        }
        return false;
    }

    /** Date de signature (pas de traitement) de la dernière notification appliquée. */
    private function recordNotification(string $originalTransactionId, object $payload, int $signedDateMs): void
    {
        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET last_notification_type = ?,
                last_notification_subtype = ?,
                last_notification_date = FROM_UNIXTIME(?)
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([
            $payload->notificationType ?? 'UNKNOWN',
            $payload->subtype ?? null,
            $signedDateMs > 0 ? intdiv($signedDateMs, 1000) : time(),
            $originalTransactionId,
        ]);
    }

    /**
     * Check if notification was already processed (replay attack prevention)
     */
    private function isReplayAttack(string $notificationUUID): bool
    {
        $stmt = $this->db->prepare(
            "SELECT id FROM apple_notifications WHERE notification_uuid = ? AND processed = 1"
        );
        $stmt->execute([$notificationUUID]);
        return $stmt->fetch() !== false;
    }

    /**
     * Store notification for audit trail
     */
    private function storeNotification(object $payload, string $signedPayload, ?object $txInfo): void
    {
        // Extract transaction ID for linking
        $originalTransactionId = $txInfo->originalTransactionId ?? null;

        // Find user by transaction
        $userId = null;
        if ($originalTransactionId) {
            $stmt = $this->db->prepare(
                "SELECT user_id FROM subscriptions WHERE original_transaction_id = ?"
            );
            $stmt->execute([$originalTransactionId]);
            $row = $stmt->fetch();
            $userId = $row['user_id'] ?? null;
        }

        $stmt = $this->db->prepare("
            INSERT INTO apple_notifications
            (user_id, original_transaction_id, notification_type, notification_subtype,
             notification_uuid, signed_payload, processed)
            VALUES (?, ?, ?, ?, ?, ?, 0)
            ON DUPLICATE KEY UPDATE received_at = CURRENT_TIMESTAMP
        ");

        $stmt->execute([
            $userId,
            $originalTransactionId,
            $payload->notificationType ?? 'UNKNOWN',
            $payload->subtype ?? null,
            $payload->notificationUUID ?? ('gen_' . uniqid()),
            $signedPayload
        ]);

        error_log("💾 Notification stored for audit (user: " . ($userId ?? 'unknown') . ")");
    }

    /**
     * Process notification based on type
     * @see https://developer.apple.com/documentation/appstoreservernotifications/notificationtype
     */
    private function processNotification(object $payload, ?object $transactionInfo, ?object $renewalInfo): string
    {
        $type = $payload->notificationType ?? 'UNKNOWN';
        $subtype = $payload->subtype ?? null;

        error_log("🔔 Processing notification: $type" . ($subtype ? " ($subtype)" : ""));
        if ($transactionInfo) {
            error_log("📦 Original Transaction ID: " . ($transactionInfo->originalTransactionId ?? 'N/A')
                . " | Product ID: " . ($transactionInfo->productId ?? 'N/A'));
        }

        switch ($type) {
            case 'SUBSCRIBED':
                return $this->handleSubscribed($transactionInfo, $renewalInfo, $subtype);

            case 'DID_RENEW':
                return $this->handleDidRenew($transactionInfo, $renewalInfo);

            case 'DID_CHANGE_RENEWAL_STATUS':
                return $this->handleRenewalStatusChange($transactionInfo, $renewalInfo, $subtype);

            case 'DID_CHANGE_RENEWAL_PREF':
                return $this->handleRenewalPrefChange($transactionInfo, $renewalInfo);

            case 'EXPIRED':
                return $this->handleExpired($transactionInfo, $renewalInfo, $subtype);

            case 'GRACE_PERIOD_EXPIRED':
                return $this->handleGracePeriodExpired($transactionInfo);

            case 'DID_FAIL_TO_RENEW':
                return $this->handleFailedToRenew($transactionInfo, $renewalInfo, $subtype);

            case 'OFFER_REDEEMED':
                return $this->handleOfferRedeemed($transactionInfo, $renewalInfo, $subtype);

            case 'REFUND':
                return $this->handleRefund($transactionInfo);

            case 'REVOKE':
                return $this->handleRevoke($transactionInfo);

            case 'CONSUMPTION_REQUEST':
                error_log("📝 Consumption request received - requires response within 12 hours");
                return 'consumption_request_received';

            case 'RENEWAL_EXTENDED':
                return $this->handleRenewalExtended($transactionInfo, $renewalInfo);

            case 'PRICE_INCREASE':
                return $this->handlePriceIncrease($transactionInfo, $renewalInfo, $subtype);

            case 'TEST':
                error_log("🧪 Test notification received");
                return 'test_acknowledged';

            default:
                error_log("⚠️ Unknown notification type: $type");
                return 'unknown_type';
        }
    }

    /**
     * SUBSCRIBED - New subscription or resubscription
     * Subtypes: INITIAL_BUY, RESUBSCRIBE
     */
    private function handleSubscribed($txInfo, $renewalInfo, $subtype): string
    {
        if (!$txInfo) return 'no_transaction_info';

        error_log("✅ New subscription: " . $txInfo->productId . " (subtype: $subtype)");

        $this->updateSubscriptionFromTransaction($txInfo, 'active');
        $this->updateRenewalInfo($txInfo->originalTransactionId, $renewalInfo);

        return "subscribed_" . strtolower($subtype ?? 'unknown');
    }

    /**
     * DID_RENEW - Successful renewal
     */
    private function handleDidRenew($txInfo, $renewalInfo): string
    {
        if (!$txInfo) return 'no_transaction_info';

        error_log("🔄 Subscription renewed: " . $txInfo->productId);

        $this->updateSubscriptionFromTransaction($txInfo, 'active');
        $this->updateRenewalInfo($txInfo->originalTransactionId, $renewalInfo);

        return 'renewed';
    }

    /**
     * DID_CHANGE_RENEWAL_STATUS - Auto-renewal toggled
     * Subtypes: AUTO_RENEW_ENABLED, AUTO_RENEW_DISABLED
     */
    private function handleRenewalStatusChange($txInfo, $renewalInfo, $subtype): string
    {
        if (!$txInfo) return 'no_transaction_info';

        $autoRenew = ($subtype === 'AUTO_RENEW_ENABLED') ? 1 : 0;

        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET auto_renew_enabled = ?,
                updated_at = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([$autoRenew, $txInfo->originalTransactionId]);

        error_log("🔀 Auto-renew changed: " . ($autoRenew ? 'enabled' : 'disabled'));

        return "renewal_status_" . strtolower($subtype ?? 'unknown');
    }

    /**
     * DID_CHANGE_RENEWAL_PREF - User changed subscription product
     */
    private function handleRenewalPrefChange($txInfo, $renewalInfo): string
    {
        if (!$txInfo || !$renewalInfo) return 'no_info';

        $newProductId = $renewalInfo->autoRenewProductId ?? null;
        error_log("📝 Renewal preference changed to: " . ($newProductId ?? 'unknown'));

        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET auto_renew_product_id = ?,
                updated_at = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([$newProductId, $txInfo->originalTransactionId]);

        return 'renewal_pref_changed';
    }

    /**
     * EXPIRED - Subscription expired
     * Subtypes: VOLUNTARY, BILLING_RETRY, PRICE_INCREASE, PRODUCT_NOT_FOR_SALE
     */
    private function handleExpired($txInfo, $renewalInfo, $subtype): string
    {
        if (!$txInfo) return 'no_transaction_info';

        error_log("⏰ Subscription expired: " . $txInfo->originalTransactionId . " (reason: $subtype)");

        $this->updateSubscriptionStatus($txInfo->originalTransactionId, 'expired');

        return "expired_" . strtolower($subtype ?? 'unknown');
    }

    /**
     * GRACE_PERIOD_EXPIRED - Grace period ended without successful payment
     */
    private function handleGracePeriodExpired($txInfo): string
    {
        if (!$txInfo) return 'no_transaction_info';

        error_log("⏳ Grace period expired: " . $txInfo->originalTransactionId);

        $this->updateSubscriptionStatus($txInfo->originalTransactionId, 'expired');

        return 'grace_period_expired';
    }

    /**
     * DID_FAIL_TO_RENEW - Payment failed
     * Subtypes: GRACE_PERIOD (billing grace period started), null (billing retry)
     */
    private function handleFailedToRenew($txInfo, $renewalInfo, $subtype): string
    {
        if (!$txInfo) return 'no_transaction_info';

        if ($subtype === 'GRACE_PERIOD') {
            error_log("⏳ Entering grace period: " . $txInfo->originalTransactionId);
            $this->updateSubscriptionStatus($txInfo->originalTransactionId, 'grace_period');

            // Set grace period expiration
            if ($renewalInfo && isset($renewalInfo->gracePeriodExpiresDate)) {
                $stmt = $this->db->prepare("
                    UPDATE subscriptions
                    SET grace_period_expires_date = FROM_UNIXTIME(? / 1000)
                    WHERE original_transaction_id = ?
                ");
                $stmt->execute([$renewalInfo->gracePeriodExpiresDate, $txInfo->originalTransactionId]);
            }

            // Keep premium active during grace period
            return 'grace_period_started';
        } else {
            error_log("💳 Billing retry: " . $txInfo->originalTransactionId);
            // Relance de paiement sans période de grâce : pas d'accès (Apple)
            $this->updateSubscriptionStatus($txInfo->originalTransactionId, 'billing_retry');
            return 'billing_retry_started';
        }
    }

    /**
     * OFFER_REDEEMED - User redeemed a promotional offer
     */
    private function handleOfferRedeemed($txInfo, $renewalInfo, $subtype): string
    {
        if (!$txInfo) return 'no_transaction_info';

        $offerType = $subtype ?? 'unknown';
        error_log("🎁 Offer redeemed: $offerType for " . $txInfo->productId);

        $this->updateSubscriptionFromTransaction($txInfo, 'active');

        return "offer_redeemed_$offerType";
    }

    /**
     * REFUND - User was refunded
     */
    private function handleRefund($txInfo): string
    {
        if (!$txInfo) return 'no_transaction_info';

        error_log("💰 Refund processed: " . $txInfo->originalTransactionId);

        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET status = 'revoked',
                revocation_date = FROM_UNIXTIME(?),
                updated_at = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");
        $revokedAt = !empty($txInfo->revocationDate) ? intdiv((int)$txInfo->revocationDate, 1000) : time();
        $stmt->execute([$revokedAt, $txInfo->originalTransactionId]);


        return 'refunded';
    }

    /**
     * REVOKE - Family sharing revoked or app transferred
     */
    private function handleRevoke($txInfo): string
    {
        if (!$txInfo) return 'no_transaction_info';

        error_log("🚫 Subscription revoked: " . $txInfo->originalTransactionId);

        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET status = 'revoked',
                revocation_date = FROM_UNIXTIME(?),
                updated_at = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");
        $revokedAt = !empty($txInfo->revocationDate) ? intdiv((int)$txInfo->revocationDate, 1000) : time();
        $stmt->execute([$revokedAt, $txInfo->originalTransactionId]);

        return 'revoked';
    }

    /**
     * RENEWAL_EXTENDED - Subscription was extended (promotional or support)
     */
    private function handleRenewalExtended($txInfo, $renewalInfo): string
    {
        if (!$txInfo) return 'no_transaction_info';

        error_log("📅 Subscription extended: " . $txInfo->originalTransactionId);

        $this->updateSubscriptionFromTransaction($txInfo, 'active');

        return 'renewal_extended';
    }

    /**
     * PRICE_INCREASE - Price increase notification
     * Subtypes: PENDING, ACCEPTED
     */
    private function handlePriceIncrease($txInfo, $renewalInfo, $subtype): string
    {
        if (!$txInfo) return 'no_transaction_info';

        error_log("💵 Price increase: $subtype for " . $txInfo->originalTransactionId);

        return "price_increase_" . strtolower($subtype ?? 'unknown');
    }

    // =========================================
    // Helper Methods
    // =========================================

    /**
     * JWS interne (signedTransactionInfo / signedRenewalInfo) : vérifié avec la
     * même chaîne Apple que l'enveloppe.
     */
    private function decodeSignedData(string $signedData): ?object
    {
        $decoded = AppleJWSVerifier::verify($signedData);
        if (!$decoded) {
            Logger::warning('apple.notification', 'JWS interne refusé', ['reason' => AppleJWSVerifier::$lastError]);
            return null;
        }
        if (isset($decoded->bundleId) && $decoded->bundleId !== $this->bundleId) {
            Logger::warning('apple.notification', 'Bundle ID inattendu (JWS interne)', ['bundle_id' => $decoded->bundleId]);
            return null;
        }
        return $decoded;
    }

    private function updateSubscriptionFromTransaction($txInfo, string $status): void
    {
        // Transaction signée après un remboursement : elle porte revocationDate
        $revokedAt = !empty($txInfo->revocationDate) ? intdiv((int)$txInfo->revocationDate, 1000) : null;
        if ($revokedAt !== null) {
            $status = 'revoked';
        }
        $expiresAt = !empty($txInfo->expiresDate) ? intdiv((int)$txInfo->expiresDate, 1000) : null;

        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET transaction_id = ?,
                product_id = ?,
                status = ?,
                purchase_date = FROM_UNIXTIME(?),
                expires_date = CASE
                    WHEN ? IS NULL THEN expires_date
                    WHEN expires_date IS NULL OR FROM_UNIXTIME(?) > expires_date THEN FROM_UNIXTIME(?)
                    ELSE expires_date END,
                revocation_date = FROM_UNIXTIME(?),
                grace_period_expires_date = CASE WHEN ? = 'active' THEN NULL ELSE grace_period_expires_date END,
                environment = ?,
                updated_at = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");

        $stmt->execute([
            $txInfo->transactionId ?? null,
            $txInfo->productId ?? null,
            $status,
            intdiv((int)($txInfo->purchaseDate ?? (time() * 1000)), 1000),
            $expiresAt, $expiresAt, $expiresAt,
            $revokedAt,
            $status,
            $txInfo->environment ?? 'Production',
            $txInfo->originalTransactionId
        ]);

        error_log("📝 Updated subscription: " . $txInfo->originalTransactionId . " -> $status");
    }

    private function updateSubscriptionStatus(string $originalTransactionId, string $status): void
    {
        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET status = ?, updated_at = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([$status, $originalTransactionId]);
    }

    private function updateRenewalInfo(string $originalTransactionId, ?object $renewalInfo): void
    {
        if (!$renewalInfo) return;

        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET auto_renew_enabled = ?,
                auto_renew_product_id = ?
            WHERE original_transaction_id = ?
        ");

        $stmt->execute([
            ($renewalInfo->autoRenewStatus ?? 1) ? 1 : 0,
            $renewalInfo->autoRenewProductId ?? null,
            $originalTransactionId
        ]);
    }

    private function markNotificationProcessed(string $notificationUUID): void
    {
        $stmt = $this->db->prepare("
            UPDATE apple_notifications
            SET processed = 1, processed_at = CURRENT_TIMESTAMP
            WHERE notification_uuid = ?
        ");
        $stmt->execute([$notificationUUID]);
    }

    private function error(string $message, int $code): array
    {
        http_response_code($code);
        return ['success' => false, 'error' => $message];
    }
}
