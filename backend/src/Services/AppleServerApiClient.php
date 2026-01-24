<?php
/**
 * Apple App Store Server API v2 Client
 * For proactive subscription status checking and transaction management
 *
 * @see https://developer.apple.com/documentation/appstoreserverapi
 * @package NfcAnycubic\Services
 */

namespace NfcAnycubic\Services;

use NfcAnycubic\EnvLoader;
use Firebase\JWT\JWT;

class AppleServerApiClient
{
    private $issuerId;
    private $keyId;
    private $privateKey;
    private $bundleId;
    private $environment;

    private const PRODUCTION_URL = 'https://api.storekit.itunes.apple.com';
    private const SANDBOX_URL = 'https://api.storekit-sandbox.itunes.apple.com';

    public function __construct()
    {
        $config = require __DIR__ . '/../../config/app.php';

        $this->issuerId = $config['apple_appstore']['issuer_id'] ?? '';
        $this->keyId = $config['apple_appstore']['key_id'] ?? '';
        $this->bundleId = $config['apple_appstore']['bundle_id'] ?? 'com.engageengine.nfcfilament';
        $this->environment = EnvLoader::get('APP_ENV') === 'production' ? 'production' : 'sandbox';

        // Load private key if configured
        $keyPath = $config['apple_appstore']['private_key_path'] ?? '';
        if (!empty($keyPath) && file_exists($keyPath)) {
            $this->privateKey = file_get_contents($keyPath);
        }
    }

    /**
     * Check if the client is properly configured
     */
    public function isConfigured(): bool
    {
        return !empty($this->privateKey) &&
               !empty($this->issuerId) &&
               !empty($this->keyId);
    }

    /**
     * Generate JWT for App Store Server API authentication
     */
    private function generateToken(): string
    {
        if (!$this->isConfigured()) {
            throw new \RuntimeException(
                'App Store Server API not configured. ' .
                'Set APPLE_ISSUER_ID, APPLE_KEY_ID_APPSTORE and provide the private key.'
            );
        }

        $now = time();

        $payload = [
            'iss' => $this->issuerId,
            'iat' => $now,
            'exp' => $now + 3600, // 1 hour
            'aud' => 'appstoreconnect-v1',
            'bid' => $this->bundleId,
        ];

        return JWT::encode($payload, $this->privateKey, 'ES256', $this->keyId);
    }

    /**
     * Get the base URL based on environment
     */
    private function getBaseUrl(): string
    {
        return $this->environment === 'production' ? self::PRODUCTION_URL : self::SANDBOX_URL;
    }

    /**
     * Make authenticated request to App Store Server API
     */
    private function request(string $method, string $endpoint, ?array $data = null): array
    {
        $url = $this->getBaseUrl() . $endpoint;
        $token = $this->generateToken();

        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER => [
                'Authorization: Bearer ' . $token,
                'Content-Type: application/json',
            ],
            CURLOPT_TIMEOUT => 30,
            CURLOPT_SSL_VERIFYPEER => true,
            CURLOPT_SSL_VERIFYHOST => 2,
        ]);

        if ($method === 'POST' && $data) {
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        } elseif ($method === 'PUT' && $data) {
            curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        }

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);

        if ($error) {
            throw new \RuntimeException("cURL error: $error");
        }

        return [
            'code' => $httpCode,
            'body' => json_decode($response, true) ?? $response
        ];
    }

    /**
     * Get subscription status for a transaction
     * Useful for verifying current state
     *
     * @see https://developer.apple.com/documentation/appstoreserverapi/get_all_subscription_statuses
     */
    public function getSubscriptionStatuses(string $originalTransactionId): ?array
    {
        try {
            $response = $this->request(
                'GET',
                "/inApps/v1/subscriptions/$originalTransactionId"
            );

            if ($response['code'] === 200) {
                return $response['body'];
            }

            error_log("App Store API getSubscriptionStatuses error: " . json_encode($response));
            return null;

        } catch (\Exception $e) {
            error_log("App Store API exception: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Get transaction history for a user
     * Useful for restoring purchases server-side
     *
     * @see https://developer.apple.com/documentation/appstoreserverapi/get_transaction_history
     */
    public function getTransactionHistory(string $originalTransactionId, ?string $revision = null): ?array
    {
        try {
            $endpoint = "/inApps/v1/history/$originalTransactionId";
            if ($revision) {
                $endpoint .= "?revision=$revision";
            }

            $response = $this->request('GET', $endpoint);

            if ($response['code'] === 200) {
                return $response['body'];
            }

            error_log("App Store API getTransactionHistory error: " . json_encode($response));
            return null;

        } catch (\Exception $e) {
            error_log("Transaction history error: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Get refund history for a transaction
     *
     * @see https://developer.apple.com/documentation/appstoreserverapi/get_refund_history
     */
    public function getRefundHistory(string $originalTransactionId): ?array
    {
        try {
            $response = $this->request(
                'GET',
                "/inApps/v2/refund/lookup/$originalTransactionId"
            );

            return $response['code'] === 200 ? $response['body'] : null;

        } catch (\Exception $e) {
            error_log("Refund history error: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Extend a subscription's renewal date
     * Useful for customer service
     *
     * @param int $extendReasonCode 0=Undeclared, 1=CustomerSatisfaction, 2=Other, 3=ServiceIssue
     * @see https://developer.apple.com/documentation/appstoreserverapi/extend_a_subscription_renewal_date
     */
    public function extendSubscription(
        string $originalTransactionId,
        int $extendByDays,
        int $extendReasonCode = 1,
        ?string $requestIdentifier = null
    ): bool {
        try {
            $response = $this->request(
                'PUT',
                "/inApps/v1/subscriptions/extend/$originalTransactionId",
                [
                    'extendByDays' => $extendByDays,
                    'extendReasonCode' => $extendReasonCode,
                    'requestIdentifier' => $requestIdentifier ?? uniqid('ext_'),
                ]
            );

            if ($response['code'] === 200) {
                error_log("✅ Subscription extended by $extendByDays days: $originalTransactionId");
                return true;
            }

            error_log("Extend subscription failed: " . json_encode($response));
            return false;

        } catch (\Exception $e) {
            error_log("Extend subscription error: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Look up order by order ID (for customer support)
     *
     * @see https://developer.apple.com/documentation/appstoreserverapi/look_up_order_id
     */
    public function lookupOrder(string $orderId): ?array
    {
        try {
            $response = $this->request('GET', "/inApps/v1/lookup/$orderId");
            return $response['code'] === 200 ? $response['body'] : null;
        } catch (\Exception $e) {
            error_log("Lookup order error: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Request test notification (for testing webhook)
     *
     * @see https://developer.apple.com/documentation/appstoreserverapi/request_a_test_notification
     */
    public function requestTestNotification(): ?array
    {
        try {
            $response = $this->request('POST', '/inApps/v1/notifications/test');

            if ($response['code'] === 200) {
                error_log("✅ Test notification requested");
                return $response['body'];
            }

            error_log("Test notification request failed: " . json_encode($response));
            return null;

        } catch (\Exception $e) {
            error_log("Test notification error: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Get notification history (for debugging missed notifications)
     *
     * @see https://developer.apple.com/documentation/appstoreserverapi/get_notification_history
     */
    public function getNotificationHistory(
        int $startDate,
        int $endDate,
        ?string $paginationToken = null
    ): ?array {
        try {
            $body = [
                'startDate' => $startDate,
                'endDate' => $endDate,
            ];
            if ($paginationToken) {
                $body['paginationToken'] = $paginationToken;
            }

            $response = $this->request('POST', '/inApps/v1/notifications/history', $body);
            return $response['code'] === 200 ? $response['body'] : null;

        } catch (\Exception $e) {
            error_log("Notification history error: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Get test notification status
     *
     * @see https://developer.apple.com/documentation/appstoreserverapi/get_test_notification_status
     */
    public function getTestNotificationStatus(string $testNotificationToken): ?array
    {
        try {
            $response = $this->request(
                'GET',
                "/inApps/v1/notifications/test/$testNotificationToken"
            );
            return $response['code'] === 200 ? $response['body'] : null;
        } catch (\Exception $e) {
            error_log("Test notification status error: " . $e->getMessage());
            return null;
        }
    }

    /**
     * Send consumption information (for consumable products and refund decisions)
     *
     * @see https://developer.apple.com/documentation/appstoreserverapi/send_consumption_information
     */
    public function sendConsumptionInfo(
        string $originalTransactionId,
        array $consumptionData
    ): bool {
        try {
            $response = $this->request(
                'PUT',
                "/inApps/v1/transactions/consumption/$originalTransactionId",
                $consumptionData
            );

            return $response['code'] === 200 || $response['code'] === 202;

        } catch (\Exception $e) {
            error_log("Send consumption info error: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Verify and decode a signed transaction from App Store
     * Useful for validating transactions received from client
     */
    public function verifyTransaction(string $signedTransaction): ?object
    {
        $parts = explode('.', $signedTransaction);
        if (count($parts) !== 3) {
            return null;
        }

        // Decode header and payload
        $header = json_decode(base64_decode(strtr($parts[0], '-_', '+/')));
        $payload = json_decode(base64_decode(strtr($parts[1], '-_', '+/')));

        if (!$header || !$payload) {
            return null;
        }

        // Verify bundle ID
        if (isset($payload->bundleId) && $payload->bundleId !== $this->bundleId) {
            error_log("Bundle ID mismatch in transaction");
            return null;
        }

        return $payload;
    }
}
