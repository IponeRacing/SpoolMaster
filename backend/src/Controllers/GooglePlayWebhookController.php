<?php

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;

/**
 * Google Play Real-time Developer Notifications (RTDN) Handler
 * Best practices 2025-2026: RTDN is recommended for subscription lifecycle management
 *
 * @see https://developer.android.com/google/play/billing/rtdn-reference
 */
class GooglePlayWebhookController
{
    private $db;

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * POST /webhooks/google-play
     * Receives RTDN notifications from Google Play via Cloud Pub/Sub
     */
    public function handleNotification()
    {
        $input = file_get_contents('php://input');
        error_log("📬 Google Play RTDN received: " . substr($input, 0, 500));

        $data = json_decode($input, true);

        if (!$data) {
            error_log("❌ Invalid JSON in RTDN request");
            return ['success' => false, 'error' => 'Invalid JSON'];
        }

        // Pub/Sub message format
        if (!isset($data['message']['data'])) {
            error_log("❌ No message.data in RTDN request");
            return ['success' => false, 'error' => 'Invalid format'];
        }

        // Decode base64 message data
        $messageData = json_decode(base64_decode($data['message']['data']), true);

        if (!$messageData) {
            error_log("❌ Failed to decode RTDN message data");
            return ['success' => false, 'error' => 'Invalid message data'];
        }

        error_log("📦 RTDN decoded: " . json_encode($messageData));

        // Handle different notification types
        if (isset($messageData['subscriptionNotification'])) {
            return $this->handleSubscriptionNotification($messageData['subscriptionNotification'], $messageData['packageName'] ?? '');
        }

        if (isset($messageData['oneTimeProductNotification'])) {
            error_log("ℹ️ One-time product notification (not handled): " . json_encode($messageData['oneTimeProductNotification']));
            return ['success' => true, 'message' => 'One-time product notification acknowledged'];
        }

        if (isset($messageData['voidedPurchaseNotification'])) {
            return $this->handleVoidedPurchaseNotification($messageData['voidedPurchaseNotification']);
        }

        if (isset($messageData['testNotification'])) {
            error_log("🧪 Test notification received - version: " . ($messageData['testNotification']['version'] ?? 'unknown'));
            return ['success' => true, 'message' => 'Test notification received'];
        }

        error_log("⚠️ Unknown RTDN type: " . json_encode(array_keys($messageData)));
        return ['success' => true, 'message' => 'Unknown notification type'];
    }

    /**
     * Handle subscription lifecycle notifications
     *
     * Notification types:
     * 1 = SUBSCRIPTION_RECOVERED - Subscription was recovered from account hold
     * 2 = SUBSCRIPTION_RENEWED - Active subscription was renewed
     * 3 = SUBSCRIPTION_CANCELED - Subscription was canceled by user
     * 4 = SUBSCRIPTION_PURCHASED - New subscription purchased
     * 5 = SUBSCRIPTION_ON_HOLD - Subscription has entered account hold
     * 6 = SUBSCRIPTION_IN_GRACE_PERIOD - Subscription entered grace period
     * 7 = SUBSCRIPTION_RESTARTED - User restarted subscription
     * 8 = SUBSCRIPTION_PRICE_CHANGE_CONFIRMED - User confirmed price change
     * 9 = SUBSCRIPTION_DEFERRED - Subscription purchase deferred
     * 10 = SUBSCRIPTION_PAUSED - Subscription was paused
     * 11 = SUBSCRIPTION_PAUSE_SCHEDULE_CHANGED - Pause schedule changed
     * 12 = SUBSCRIPTION_REVOKED - Subscription was revoked (refunded)
     * 13 = SUBSCRIPTION_EXPIRED - Subscription has expired
     * 20 = SUBSCRIPTION_PENDING_PURCHASE_CANCELED - Pending purchase canceled
     */
    private function handleSubscriptionNotification($notification, $packageName)
    {
        $notificationType = $notification['notificationType'] ?? 0;
        $purchaseToken = $notification['purchaseToken'] ?? '';
        $subscriptionId = $notification['subscriptionId'] ?? '';

        error_log("🔔 Subscription notification:");
        error_log("   Type: $notificationType (" . $this->getNotificationTypeName($notificationType) . ")");
        error_log("   Product: $subscriptionId");
        error_log("   Package: $packageName");
        error_log("   Token (first 20 chars): " . substr($purchaseToken, 0, 20) . "...");

        switch ($notificationType) {
            case 1: // SUBSCRIPTION_RECOVERED
            case 2: // SUBSCRIPTION_RENEWED
            case 4: // SUBSCRIPTION_PURCHASED
            case 7: // SUBSCRIPTION_RESTARTED
                $this->activateSubscription($purchaseToken, $subscriptionId);
                break;

            case 3: // SUBSCRIPTION_CANCELED
                // User canceled but subscription is still active until expiry
                $this->markSubscriptionCanceled($purchaseToken);
                break;

            case 5: // SUBSCRIPTION_ON_HOLD
                $this->setSubscriptionOnHold($purchaseToken);
                break;

            case 6: // SUBSCRIPTION_IN_GRACE_PERIOD
                $this->setSubscriptionGracePeriod($purchaseToken);
                break;

            case 10: // SUBSCRIPTION_PAUSED
                $this->setSubscriptionPaused($purchaseToken);
                break;

            case 12: // SUBSCRIPTION_REVOKED
            case 13: // SUBSCRIPTION_EXPIRED
                $this->deactivateSubscription($purchaseToken);
                break;

            default:
                error_log("ℹ️ Unhandled subscription notification type: $notificationType");
        }

        return [
            'success' => true,
            'notification_type' => $notificationType,
            'product_id' => $subscriptionId
        ];
    }

    /**
     * Handle voided purchase notifications (refunds, chargebacks)
     */
    private function handleVoidedPurchaseNotification($notification)
    {
        $purchaseToken = $notification['purchaseToken'] ?? '';
        $orderId = $notification['orderId'] ?? '';
        $productType = $notification['productType'] ?? 0; // 1 = subscription

        error_log("💔 Voided purchase notification:");
        error_log("   Order ID: $orderId");
        error_log("   Product type: " . ($productType == 1 ? 'subscription' : 'one-time'));

        if ($productType == 1) {
            $this->deactivateSubscription($purchaseToken);
        }

        return ['success' => true, 'message' => 'Voided purchase processed'];
    }

    /**
     * Activate or renew a subscription
     */
    private function activateSubscription($purchaseToken, $productId)
    {
        try {
            // Find subscription by purchase token and activate
            $stmt = $this->db->prepare("
                UPDATE subscriptions s
                LEFT JOIN user_preferences up ON s.user_id = up.user_id
                SET s.status = 'active',
                    s.auto_renew_enabled = 1,
                    s.updated_at = CURRENT_TIMESTAMP
                WHERE s.jws_transaction = ?
            ");
            $stmt->execute([$purchaseToken]);
            $affected = $stmt->rowCount();

            if ($affected > 0) {
                // Also update user premium status
                $stmt = $this->db->prepare("
                    UPDATE user_preferences up
                    INNER JOIN subscriptions s ON s.user_id = up.user_id
                    SET up.is_vip = 1
                    WHERE s.jws_transaction = ?
                ");
                $stmt->execute([$purchaseToken]);
                error_log("✅ Subscription activated via RTDN (affected: $affected)");
            } else {
                error_log("⚠️ No subscription found with token: " . substr($purchaseToken, 0, 20) . "...");
            }

        } catch (\Exception $e) {
            error_log("❌ Error activating subscription: " . $e->getMessage());
        }
    }

    /**
     * Mark subscription as canceled (still active until expiry)
     */
    private function markSubscriptionCanceled($purchaseToken)
    {
        try {
            $stmt = $this->db->prepare("
                UPDATE subscriptions
                SET auto_renew_enabled = 0,
                    updated_at = CURRENT_TIMESTAMP
                WHERE jws_transaction = ?
            ");
            $stmt->execute([$purchaseToken]);
            error_log("📋 Subscription marked as canceled (will expire at end of period)");

        } catch (\Exception $e) {
            error_log("❌ Error marking subscription canceled: " . $e->getMessage());
        }
    }

    /**
     * Set subscription on hold (payment failed)
     */
    private function setSubscriptionOnHold($purchaseToken)
    {
        try {
            $stmt = $this->db->prepare("
                UPDATE subscriptions s
                LEFT JOIN user_preferences up ON s.user_id = up.user_id
                SET s.status = 'on_hold',
                    s.updated_at = CURRENT_TIMESTAMP
                WHERE s.jws_transaction = ?
            ");
            $stmt->execute([$purchaseToken]);

            // Deactivate premium for on_hold
            $stmt = $this->db->prepare("
                UPDATE user_preferences up
                INNER JOIN subscriptions s ON s.user_id = up.user_id
                SET up.is_vip = 0
                WHERE s.jws_transaction = ?
            ");
            $stmt->execute([$purchaseToken]);

            error_log("⏸️ Subscription on hold - premium deactivated");

        } catch (\Exception $e) {
            error_log("❌ Error setting subscription on hold: " . $e->getMessage());
        }
    }

    /**
     * Set subscription in grace period (payment retry)
     */
    private function setSubscriptionGracePeriod($purchaseToken)
    {
        try {
            $stmt = $this->db->prepare("
                UPDATE subscriptions
                SET status = 'grace_period',
                    updated_at = CURRENT_TIMESTAMP
                WHERE jws_transaction = ?
            ");
            $stmt->execute([$purchaseToken]);
            error_log("⏳ Subscription in grace period - keeping premium active");

        } catch (\Exception $e) {
            error_log("❌ Error setting grace period: " . $e->getMessage());
        }
    }

    /**
     * Set subscription as paused
     */
    private function setSubscriptionPaused($purchaseToken)
    {
        try {
            $stmt = $this->db->prepare("
                UPDATE subscriptions s
                LEFT JOIN user_preferences up ON s.user_id = up.user_id
                SET s.status = 'paused',
                    s.updated_at = CURRENT_TIMESTAMP
                WHERE s.jws_transaction = ?
            ");
            $stmt->execute([$purchaseToken]);

            // Deactivate premium for paused subscriptions
            $stmt = $this->db->prepare("
                UPDATE user_preferences up
                INNER JOIN subscriptions s ON s.user_id = up.user_id
                SET up.is_vip = 0
                WHERE s.jws_transaction = ?
            ");
            $stmt->execute([$purchaseToken]);

            error_log("⏸️ Subscription paused - premium deactivated");

        } catch (\Exception $e) {
            error_log("❌ Error pausing subscription: " . $e->getMessage());
        }
    }

    /**
     * Deactivate subscription (expired or revoked)
     */
    private function deactivateSubscription($purchaseToken)
    {
        try {
            $stmt = $this->db->prepare("
                UPDATE subscriptions
                SET status = 'expired',
                    auto_renew_enabled = 0,
                    updated_at = CURRENT_TIMESTAMP
                WHERE jws_transaction = ?
            ");
            $stmt->execute([$purchaseToken]);

            // Deactivate premium
            $stmt = $this->db->prepare("
                UPDATE user_preferences up
                INNER JOIN subscriptions s ON s.user_id = up.user_id
                SET up.is_vip = 0,
                    up.vip_expires_at = NULL
                WHERE s.jws_transaction = ?
            ");
            $stmt->execute([$purchaseToken]);

            error_log("❌ Subscription deactivated via RTDN");

        } catch (\Exception $e) {
            error_log("❌ Error deactivating subscription: " . $e->getMessage());
        }
    }

    /**
     * Get human-readable notification type name
     */
    private function getNotificationTypeName($type)
    {
        $names = [
            1 => 'SUBSCRIPTION_RECOVERED',
            2 => 'SUBSCRIPTION_RENEWED',
            3 => 'SUBSCRIPTION_CANCELED',
            4 => 'SUBSCRIPTION_PURCHASED',
            5 => 'SUBSCRIPTION_ON_HOLD',
            6 => 'SUBSCRIPTION_IN_GRACE_PERIOD',
            7 => 'SUBSCRIPTION_RESTARTED',
            8 => 'SUBSCRIPTION_PRICE_CHANGE_CONFIRMED',
            9 => 'SUBSCRIPTION_DEFERRED',
            10 => 'SUBSCRIPTION_PAUSED',
            11 => 'SUBSCRIPTION_PAUSE_SCHEDULE_CHANGED',
            12 => 'SUBSCRIPTION_REVOKED',
            13 => 'SUBSCRIPTION_EXPIRED',
            20 => 'SUBSCRIPTION_PENDING_PURCHASE_CANCELED',
        ];
        return $names[$type] ?? 'UNKNOWN';
    }
}
