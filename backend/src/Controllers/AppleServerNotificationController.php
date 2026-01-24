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
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

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

            // Step 3: Store notification for audit trail
            $this->storeNotification($payload, $data['signedPayload']);

            // Step 4: Process the notification
            $result = $this->processNotification($payload);

            // Step 5: Mark as processed
            if ($notificationUUID) {
                $this->markNotificationProcessed($notificationUUID);
            }

            error_log("✅ Notification processed successfully: $result");

            return ['success' => true, 'processed' => $result];

        } catch (\Exception $e) {
            error_log("❌ Apple notification error: " . $e->getMessage());
            error_log("Stack trace: " . $e->getTraceAsString());
            return $this->error('Processing failed', 500);
        }
    }

    /**
     * Verify JWS signature and decode notification payload
     * Uses certificate chain from x5c header
     */
    private function verifyAndDecodeNotification(string $signedPayload): ?object
    {
        $parts = explode('.', $signedPayload);
        if (count($parts) !== 3) {
            error_log("❌ Invalid JWS format");
            return null;
        }

        // Decode header
        $header = json_decode(base64_decode(strtr($parts[0], '-_', '+/')));
        if (!$header) {
            error_log("❌ Failed to decode JWS header");
            return null;
        }

        if (!isset($header->x5c) || !is_array($header->x5c) || count($header->x5c) === 0) {
            error_log("❌ No x5c certificate chain in header");
            return null;
        }

        // Verify certificate chain
        if (!$this->verifyCertificateChain($header->x5c)) {
            error_log("❌ Certificate chain verification failed");
            return null;
        }

        // Extract public key from first certificate (leaf cert)
        $certPem = "-----BEGIN CERTIFICATE-----\n" .
                   chunk_split($header->x5c[0], 64, "\n") .
                   "-----END CERTIFICATE-----";

        $publicKey = openssl_pkey_get_public($certPem);
        if (!$publicKey) {
            error_log("❌ Failed to extract public key from certificate");
            return null;
        }

        try {
            // Verify and decode using Firebase JWT
            $algorithm = $header->alg ?? 'ES256';
            $decoded = JWT::decode($signedPayload, new Key($publicKey, $algorithm));

            // Verify bundle ID if present
            if (isset($decoded->data->bundleId) && $decoded->data->bundleId !== $this->bundleId) {
                error_log("❌ Bundle ID mismatch: " . $decoded->data->bundleId . " vs " . $this->bundleId);
                return null;
            }

            error_log("✅ Notification signature verified");
            error_log("📋 Type: " . ($decoded->notificationType ?? 'unknown'));
            error_log("📋 Subtype: " . ($decoded->subtype ?? 'none'));

            return $decoded;

        } catch (\Exception $e) {
            error_log("❌ JWT decode failed: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Verify the x5c certificate chain against Apple's root CA
     */
    private function verifyCertificateChain(array $x5cChain): bool
    {
        if (count($x5cChain) < 2) {
            error_log("❌ Certificate chain too short");
            return false;
        }

        // Verify the leaf certificate is from Apple
        $leafCert = "-----BEGIN CERTIFICATE-----\n" .
                    chunk_split($x5cChain[0], 64, "\n") .
                    "-----END CERTIFICATE-----";

        $certInfo = openssl_x509_parse($leafCert);
        if (!$certInfo) {
            error_log("❌ Could not parse leaf certificate");
            return false;
        }

        // Check issuer contains Apple
        $issuer = $certInfo['issuer'] ?? [];
        if (!isset($issuer['O']) || strpos($issuer['O'], 'Apple') === false) {
            error_log("❌ Certificate not issued by Apple. Issuer: " . json_encode($issuer));
            return false;
        }

        // Check certificate is not expired
        $validTo = $certInfo['validTo_time_t'] ?? 0;
        if ($validTo < time()) {
            error_log("❌ Certificate expired at " . date('Y-m-d H:i:s', $validTo));
            return false;
        }

        error_log("✅ Certificate chain verified (issued by Apple, valid until " . date('Y-m-d', $validTo) . ")");
        return true;
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
    private function storeNotification(object $payload, string $signedPayload): void
    {
        // Extract transaction ID for linking
        $originalTransactionId = null;
        if (isset($payload->data->signedTransactionInfo)) {
            $txInfo = $this->decodeSignedData($payload->data->signedTransactionInfo);
            $originalTransactionId = $txInfo->originalTransactionId ?? null;
        }

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
    private function processNotification(object $payload): string
    {
        $type = $payload->notificationType ?? 'UNKNOWN';
        $subtype = $payload->subtype ?? null;

        error_log("🔔 Processing notification: $type" . ($subtype ? " ($subtype)" : ""));

        // Decode transaction info and renewal info
        $transactionInfo = null;
        $renewalInfo = null;

        if (isset($payload->data->signedTransactionInfo)) {
            $transactionInfo = $this->decodeSignedData($payload->data->signedTransactionInfo);
            error_log("📦 Transaction ID: " . ($transactionInfo->transactionId ?? 'N/A'));
            error_log("📦 Original Transaction ID: " . ($transactionInfo->originalTransactionId ?? 'N/A'));
            error_log("📦 Product ID: " . ($transactionInfo->productId ?? 'N/A'));
        }

        if (isset($payload->data->signedRenewalInfo)) {
            $renewalInfo = $this->decodeSignedData($payload->data->signedRenewalInfo);
            error_log("🔄 Auto-renew status: " . ($renewalInfo->autoRenewStatus ?? 'N/A'));
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
        $this->activatePremiumForTransaction($txInfo->originalTransactionId);

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
        $this->activatePremiumForTransaction($txInfo->originalTransactionId);

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
                last_notification_type = 'DID_CHANGE_RENEWAL_STATUS',
                last_notification_subtype = ?,
                last_notification_date = CURRENT_TIMESTAMP,
                updated_at = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([$autoRenew, $subtype, $txInfo->originalTransactionId]);

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
                last_notification_type = 'DID_CHANGE_RENEWAL_PREF',
                last_notification_date = CURRENT_TIMESTAMP,
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
        $this->deactivatePremiumForTransaction($txInfo->originalTransactionId);

        // Store expiration reason
        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET last_notification_type = 'EXPIRED',
                last_notification_subtype = ?,
                last_notification_date = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([$subtype, $txInfo->originalTransactionId]);

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
        $this->deactivatePremiumForTransaction($txInfo->originalTransactionId);

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
            $this->updateSubscriptionStatus($txInfo->originalTransactionId, 'billing_retry');
            // Keep premium during billing retry
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
        $this->activatePremiumForTransaction($txInfo->originalTransactionId);

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
                revocation_date = CURRENT_TIMESTAMP,
                last_notification_type = 'REFUND',
                last_notification_date = CURRENT_TIMESTAMP,
                updated_at = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([$txInfo->originalTransactionId]);

        $this->deactivatePremiumForTransaction($txInfo->originalTransactionId);

        return 'refunded';
    }

    /**
     * REVOKE - Family sharing revoked or app transferred
     */
    private function handleRevoke($txInfo): string
    {
        if (!$txInfo) return 'no_transaction_info';

        error_log("🚫 Subscription revoked: " . $txInfo->originalTransactionId);

        $this->updateSubscriptionStatus($txInfo->originalTransactionId, 'revoked');
        $this->deactivatePremiumForTransaction($txInfo->originalTransactionId);

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
        $this->activatePremiumForTransaction($txInfo->originalTransactionId);

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

        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET last_notification_type = 'PRICE_INCREASE',
                last_notification_subtype = ?,
                last_notification_date = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([$subtype, $txInfo->originalTransactionId]);

        return "price_increase_" . strtolower($subtype ?? 'unknown');
    }

    // =========================================
    // Helper Methods
    // =========================================

    /**
     * Decode signed data (transaction or renewal info)
     * For notification data, we trust the outer signature verification
     */
    private function decodeSignedData(string $signedData): ?object
    {
        $parts = explode('.', $signedData);
        if (count($parts) !== 3) return null;

        return json_decode(base64_decode(strtr($parts[1], '-_', '+/')));
    }

    private function updateSubscriptionFromTransaction($txInfo, string $status): void
    {
        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET transaction_id = ?,
                product_id = ?,
                status = ?,
                purchase_date = FROM_UNIXTIME(? / 1000),
                expires_date = FROM_UNIXTIME(? / 1000),
                environment = ?,
                updated_at = CURRENT_TIMESTAMP
            WHERE original_transaction_id = ?
        ");

        $stmt->execute([
            $txInfo->transactionId ?? null,
            $txInfo->productId ?? null,
            $status,
            $txInfo->purchaseDate ?? (time() * 1000),
            $txInfo->expiresDate ?? null,
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

    private function activatePremiumForTransaction(string $originalTransactionId): void
    {
        // Get user and expiration from subscription
        $stmt = $this->db->prepare("
            SELECT user_id, expires_date FROM subscriptions
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([$originalTransactionId]);
        $sub = $stmt->fetch();

        if (!$sub || !$sub['user_id']) {
            error_log("⚠️ No user found for transaction: $originalTransactionId");
            return;
        }

        $stmt = $this->db->prepare("
            INSERT INTO user_preferences (user_id, is_vip, vip_expires_at)
            VALUES (?, 1, ?)
            ON DUPLICATE KEY UPDATE
                is_vip = 1,
                vip_expires_at = VALUES(vip_expires_at)
        ");
        $stmt->execute([$sub['user_id'], $sub['expires_date']]);

        error_log("✅ Premium activated for user: " . $sub['user_id']);
    }

    private function deactivatePremiumForTransaction(string $originalTransactionId): void
    {
        $stmt = $this->db->prepare("
            SELECT user_id FROM subscriptions WHERE original_transaction_id = ?
        ");
        $stmt->execute([$originalTransactionId]);
        $sub = $stmt->fetch();

        if (!$sub || !$sub['user_id']) return;

        // Check if user has any other active subscriptions
        $stmt = $this->db->prepare("
            SELECT COUNT(*) as count FROM subscriptions
            WHERE user_id = ?
              AND status IN ('active', 'grace_period')
              AND (expires_date > NOW() OR expires_date IS NULL)
              AND original_transaction_id != ?
        ");
        $stmt->execute([$sub['user_id'], $originalTransactionId]);
        $other = $stmt->fetch();

        if (($other['count'] ?? 0) > 0) {
            error_log("ℹ️ User has other active subscriptions, keeping premium");
            return;
        }

        $stmt = $this->db->prepare("
            UPDATE user_preferences
            SET is_vip = 0, vip_expires_at = NULL
            WHERE user_id = ?
        ");
        $stmt->execute([$sub['user_id']]);

        error_log("❌ Premium deactivated for user: " . $sub['user_id']);
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
