<?php

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\AppleJWKHelper;
use NfcAnycubic\Middleware\AuthMiddleware;
use NfcAnycubic\Middleware\RateLimiter;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

/**
 * In-App Purchase Subscription Controller
 * Supports both Apple (iOS) and Google Play (Android)
 * StoreKit 2 compliant (2026 requirements)
 */
class SubscriptionController
{
    private $db;
    private $bundleId = 'com.engageengine.nfcfilament';
    private $androidPackageName = 'com.engagengine.nfc_anycubic';

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * POST /subscriptions/verify
     * Supports both iOS (JWS) and Android (purchaseToken)
     */
    public function verifyPurchase()
    {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return $this->error('Unauthorized', 401);

        // Rate limiting for purchase verification (sensitive endpoint)
        if (!RateLimiter::checkSensitive($userId)) {
            $this->logValidationFailure($userId, null, 'ios', 'rate_limited', 'Too many verification attempts');
            return $this->error('Too many requests. Please wait before retrying.', 429);
        }

        $data = json_decode(file_get_contents('php://input'), true);

        if (!isset($data['signedTransaction'])) {
            return $this->error('Missing signedTransaction', 400);
        }

        $signedTransaction = $data['signedTransaction'];
        $requestedProductId = $data['productId'] ?? null;
        $platform = $data['platform'] ?? 'ios';

        // Audit logging
        $this->logSubscriptionEvent($userId, null, 'verify_started', [
            'platform' => $platform,
            'product_id' => $requestedProductId
        ]);

        error_log("=== VERIFY PURCHASE ===");
        error_log("User: $userId | Platform: $platform | Product: $requestedProductId");

        try {
            if ($platform === 'android') {
                $result = $this->verifyGooglePlayPurchase($userId, $signedTransaction, $requestedProductId);
            } else {
                $result = $this->verifyApplePurchase($userId, $signedTransaction, $requestedProductId);
            }

            // Log success or failure
            if ($result['success'] ?? false) {
                $this->logSubscriptionEvent($userId, null, 'verify_success', [
                    'platform' => $platform,
                    'product_id' => $result['subscription']['product_id'] ?? $requestedProductId,
                    'is_premium' => $result['subscription']['is_premium'] ?? false
                ]);
            }

            return $result;

        } catch (\Exception $e) {
            error_log("Subscription verification error: " . $e->getMessage());
            $this->logValidationFailure($userId, null, $platform, 'unknown', $e->getMessage());
            return $this->error('Verification failed: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Verify Apple (iOS) purchase
     */
    private function verifyApplePurchase($userId, $signedTransaction, $requestedProductId)
    {
        $transaction = $this->verifyAppleJWS($signedTransaction);

        if (!$transaction) {
            error_log("❌ Transaction verification returned null");
            // DEBUG: Return more details about why verification failed
            return $this->error('Invalid transaction or Apple verification failed. Check server logs for details.', 400);
        }

        if ($transaction->bundleId !== $this->bundleId) {
            error_log("❌ Invalid bundle ID: " . $transaction->bundleId);
            return $this->error('Invalid bundle ID', 400);
        }

        // For Sandbox old receipt format, use the productId from the request
        if ($transaction->environment === 'Sandbox' && $requestedProductId) {
            $transaction->productId = $requestedProductId;
        }

        $validProducts = ['spool_master_monthly', 'spool_master_yearly'];
        if (!in_array($transaction->productId, $validProducts)) {
            error_log("❌ Invalid product: " . $transaction->productId);
            return $this->error('Invalid product', 400);
        }

        // IMPORTANT: Check if we have expiration date BEFORE saving
        // Without expires_date, we cannot determine subscription validity
        if ($transaction->expiresDate === null) {
            error_log("❌ No expiration date in Apple response - APPLE_SHARED_SECRET may be missing");
            error_log("❌ Configure APPLE_SHARED_SECRET in .env to get subscription details");
            return $this->error('Subscription verification incomplete. Please contact support.', 503);
        }

        // Check if subscription is currently active
        $expiresTimestamp = $transaction->expiresDate / 1000;
        $isActive = $expiresTimestamp > time();

        error_log("📅 Subscription expires: " . date('Y-m-d H:i:s', $expiresTimestamp));
        error_log("✅ Is active: " . ($isActive ? 'YES' : 'NO'));

        // Only save valid subscriptions with complete data
        $subscriptionId = $this->saveSubscription($userId, $transaction, $signedTransaction, 'ios');

        // Update user premium status based on expiration
        $this->updateUserPremiumStatus($userId, $isActive, $transaction->expiresDate);

        error_log("✅ iOS Subscription verified - Product: " . $transaction->productId . " - Active: " . ($isActive ? 'yes' : 'no'));

        return [
            'success' => true,
            'subscription' => [
                'product_id' => $transaction->productId,
                'expires_at' => $transaction->expiresDate,
                'is_premium' => $isActive
            ]
        ];
    }

    /**
     * Verify Google Play (Android) purchase using Google Play Developer API
     * Best practices 2025-2026: Server-side verification is REQUIRED
     */
    private function verifyGooglePlayPurchase($userId, $purchaseToken, $productId)
    {
        error_log("🤖 Verifying Google Play purchase with API...");
        error_log("📦 Product ID: " . $productId);
        error_log("🎫 Purchase Token length: " . strlen($purchaseToken));

        $validProducts = ['spool_master_monthly', 'spool_master_yearly'];
        if (!in_array($productId, $validProducts)) {
            error_log("Invalid product: " . $productId);
            return $this->error('Invalid product', 400);
        }

        // Check if service account is configured
        $serviceAccountPath = __DIR__ . '/../../config/google-play-service-account.json';

        if (!file_exists($serviceAccountPath)) {
            error_log("⚠️ Service account not configured - using fallback verification");
            return $this->verifyGooglePlayPurchaseFallback($userId, $purchaseToken, $productId);
        }

        try {
            $serviceAccount = json_decode(file_get_contents($serviceAccountPath), true);
            if (!$serviceAccount || !isset($serviceAccount['client_email']) || !isset($serviceAccount['private_key'])) {
                error_log("❌ Invalid service account file format");
                return $this->verifyGooglePlayPurchaseFallback($userId, $purchaseToken, $productId);
            }

            // Get OAuth2 access token
            $accessToken = $this->getGoogleAccessToken($serviceAccount);
            if (!$accessToken) {
                error_log("❌ Failed to get Google access token");
                return $this->verifyGooglePlayPurchaseFallback($userId, $purchaseToken, $productId);
            }

            // Call Google Play Developer API to verify subscription
            $url = "https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{$this->androidPackageName}/purchases/subscriptions/{$productId}/tokens/{$purchaseToken}";

            $ch = curl_init($url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Authorization: Bearer ' . $accessToken,
                'Content-Type: application/json'
            ]);
            curl_setopt($ch, CURLOPT_TIMEOUT, 30);

            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $curlError = curl_error($ch);

            if ($curlError) {
                error_log("❌ cURL error: " . $curlError);
                return $this->verifyGooglePlayPurchaseFallback($userId, $purchaseToken, $productId);
            }

            error_log("📡 Google Play API response code: " . $httpCode);

            if ($httpCode !== 200) {
                error_log("❌ Google Play API error: $httpCode - $response");
                // Don't accept invalid purchases
                return $this->error('Purchase verification failed', 400);
            }

            $purchaseData = json_decode($response);
            error_log("📦 Google Play response: " . json_encode($purchaseData));

            // Verify the subscription data
            if (!isset($purchaseData->expiryTimeMillis)) {
                error_log("❌ No expiry time in Google Play response");
                return $this->error('Invalid subscription data', 400);
            }

            $expiresDate = (int)$purchaseData->expiryTimeMillis;
            $isActive = $expiresDate > (time() * 1000);

            // Log subscription details
            error_log("📅 Expiry: " . date('Y-m-d H:i:s', $expiresDate / 1000));
            error_log("💳 Payment state: " . ($purchaseData->paymentState ?? 'N/A'));
            error_log("✅ Is active: " . ($isActive ? 'YES' : 'NO'));

            $transaction = (object)[
                'productId' => $productId,
                'originalTransactionId' => 'gp_' . substr(md5($purchaseToken), 0, 16),
                'transactionId' => $purchaseData->orderId ?? ('gp_' . time()),
                'purchaseDate' => $purchaseData->startTimeMillis ?? (time() * 1000),
                'expiresDate' => $expiresDate,
                'environment' => 'Production',
                'bundleId' => $this->androidPackageName
            ];

            $this->saveSubscription($userId, $transaction, $purchaseToken, 'android');
            $this->updateUserPremiumStatus($userId, $isActive, $expiresDate);

            error_log("✅ Google Play subscription verified via API - Active: " . ($isActive ? 'yes' : 'no'));

            return [
                'success' => true,
                'subscription' => [
                    'product_id' => $productId,
                    'expires_at' => $expiresDate,
                    'is_premium' => $isActive
                ]
            ];

        } catch (\Exception $e) {
            error_log("❌ Google Play verification exception: " . $e->getMessage());
            return $this->error('Verification failed: ' . $e->getMessage(), 500);
        }
    }

    /**
     * Handle missing Google Play service account configuration
     * SECURITY: No longer accepts purchases without proper verification
     */
    private function verifyGooglePlayPurchaseFallback($userId, $purchaseToken, $productId)
    {
        error_log("❌ REJECTED: Google Play service account not configured");
        error_log("❌ Configure backend/config/google-play-service-account.json to enable verification");
        error_log("❌ See: https://developers.google.com/android-publisher/getting_started");

        // SECURITY: Do NOT accept unverified purchases
        // This prevents fraud when service account is not configured
        return $this->error(
            'Google Play verification unavailable. Please contact support or try again later.',
            503 // Service Unavailable
        );
    }

    /**
     * Get OAuth2 access token for Google Play Developer API
     */
    private function getGoogleAccessToken($serviceAccount)
    {
        try {
            $now = time();
            $jwt = [
                'iss' => $serviceAccount['client_email'],
                'scope' => 'https://www.googleapis.com/auth/androidpublisher',
                'aud' => 'https://oauth2.googleapis.com/token',
                'iat' => $now,
                'exp' => $now + 3600
            ];

            $privateKey = $serviceAccount['private_key'];
            $token = JWT::encode($jwt, $privateKey, 'RS256');

            $ch = curl_init('https://oauth2.googleapis.com/token');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $token
            ]));
            curl_setopt($ch, CURLOPT_TIMEOUT, 30);

            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

            if ($httpCode !== 200) {
                error_log("❌ Google OAuth token request failed: $httpCode - $response");
                return null;
            }

            $data = json_decode($response, true);

            if (isset($data['access_token'])) {
                error_log("✅ Got Google access token (expires in " . ($data['expires_in'] ?? '?') . "s)");
                return $data['access_token'];
            }

            error_log("❌ No access_token in Google OAuth response");
            return null;

        } catch (\Exception $e) {
            error_log("❌ Google OAuth exception: " . $e->getMessage());
            return null;
        }
    }

    /**
     * GET /subscriptions/status
     */
    public function getSubscriptionStatus()
    {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return $this->error('Unauthorized', 401);

        // Version de l'app envoyée par le client (en-tête X-App-Version),
        // tracée dans les logs pour le support même sans event analytics.
        $appVer = $_SERVER['HTTP_X_APP_VERSION'] ?? '?';
        \error_log("📱 [v$appVer] getSubscriptionStatus user $userId");

        try {
            // First check user_preferences for VIP/lifetime status
            $stmt = $this->db->prepare("
                SELECT is_vip, vip_expires_at, subscription_type
                FROM user_preferences
                WHERE user_id = ?
            ");
            $stmt->execute([$userId]);
            $prefs = $stmt->fetch(\PDO::FETCH_ASSOC);

            // Check if user has active VIP (lifetime or not expired)
            if ($prefs && $prefs['is_vip']) {
                $isVipActive = true;
                if ($prefs['vip_expires_at']) {
                    $isVipActive = strtotime($prefs['vip_expires_at']) > time();
                }

                if ($isVipActive) {
                    error_log("📊 getSubscriptionStatus for user $userId: VIP active (type: " . ($prefs['subscription_type'] ?? 'unknown') . ")");
                    return [
                        'success' => true,
                        'is_premium' => true,
                        'subscription' => [
                            'product_id' => $prefs['subscription_type'] ?? 'lifetime',
                            'status' => 'active',
                            'expires_date' => $prefs['vip_expires_at'],
                            'type' => 'vip'
                        ]
                    ];
                }
            }

            // Check for active subscriptions with valid expiration date
            // SECURITY: Do NOT accept expires_date IS NULL as valid premium
            // (This would allow unverified PKCS#7 receipts to grant premium indefinitely)
            $stmt = $this->db->prepare("
                SELECT product_id, status, expires_date, auto_renew_enabled, environment
                FROM subscriptions
                WHERE user_id = ?
                    AND status IN ('active', 'grace_period')
                    AND expires_date > NOW()
                ORDER BY expires_date DESC
                LIMIT 1
            ");
            $stmt->execute([$userId]);
            $subscription = $stmt->fetch(\PDO::FETCH_ASSOC);

            $isPremium = $subscription !== false;

            error_log("📊 getSubscriptionStatus for user $userId: isPremium=$isPremium");

            return [
                'success' => true,
                'is_premium' => $isPremium,
                'subscription' => $subscription ?: null
            ];

        } catch (\Exception $e) {
            error_log("Error fetching subscription status: " . $e->getMessage());
            return $this->error('Server error: ' . $e->getMessage(), 500);
        }
    }

    /**
     * POST /subscriptions/webhook
     */
    public function handleAppleWebhook()
    {
        return ['success' => true, 'message' => 'Webhook received'];
    }

    /**
     * GET /cron/check-expired/:secret
     * Endpoint public CRON avec secret pour vérifier les expirations
     */
    public function cronCheckExpired($params)
    {
        // Extract secret from route parameters
        $secret = $params['secret'] ?? null;

        // Load secret from environment (not hardcoded)
        $config = require __DIR__ . '/../../config/app.php';
        $validSecret = $config['cron_secret'] ?? '';

        if (empty($validSecret)) {
            error_log("❌ CRON_SECRET not configured in environment");
            http_response_code(503);
            return ['success' => false, 'error' => 'CRON not configured'];
        }

        // Use timing-safe comparison to prevent timing attacks
        if (!hash_equals($validSecret, $secret ?? '')) {
            error_log("❌ Invalid CRON secret attempt from IP: " . ($_SERVER['REMOTE_ADDR'] ?? 'unknown'));
            http_response_code(403);
            return ['success' => false, 'error' => 'Invalid secret'];
        }

        return $this->checkExpiredSubscriptions();
    }

    /**
     * POST /subscriptions/check-expired
     * Vérifie et marque les abonnements expirés (peut être appelé manuellement)
     */
    public function checkExpiredSubscriptions()
    {
        try {
            // 1. Mettre à jour les abonnements expirés
            $stmt = $this->db->prepare("
                UPDATE subscriptions
                SET status = 'expired',
                    updated_at = CURRENT_TIMESTAMP
                WHERE status = 'active'
                  AND expires_date IS NOT NULL
                  AND expires_date < NOW()
            ");

            $stmt->execute();
            $expiredCount = $stmt->rowCount();

            // 2. Désactiver le premium pour les utilisateurs
            $stmt = $this->db->prepare("
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

            // Journalisé seulement s'il s'est passé quelque chose (cron horaire :
            // avant, 2 lignes par heure noyaient les vraies erreurs).
            if ($expiredCount > 0 || $deactivatedCount > 0) {
                error_log("✅ [CRON] Expiration check - Expired: $expiredCount, Deactivated: $deactivatedCount");
            }

            return [
                'success' => true,
                'expired_count' => $expiredCount,
                'deactivated_count' => $deactivatedCount,
                'message' => "Checked subscriptions: $expiredCount expired, $deactivatedCount users deactivated"
            ];

        } catch (\Exception $e) {
            error_log("❌ [MANUAL] Error: " . $e->getMessage());
            return $this->error('Failed to check expired subscriptions: ' . $e->getMessage(), 500);
        }
    }

    private function verifyAppleJWS($jws)
    {
        try {
            // Check if this is PKCS#7 format (StoreKit 1 receipt)
            // PKCS#7 format starts with "MI" (base64 for ASN.1 SEQUENCE)
            if (substr($jws, 0, 2) === 'MI' && strlen($jws) > 5000) {
                error_log("📦 Detected PKCS#7 receipt format (StoreKit 1)");
                error_log("⚠️ Note: StoreKit 2 (JWS) is recommended for 2026");

                // Verify via Apple's receipt validation endpoint
                return $this->verifyApplePKCS7Receipt($jws);
            }

            // Standard StoreKit 2 JWS verification
            error_log("🔐 Validating StoreKit 2 JWS token...");

            $parts = explode('.', $jws);
            if (count($parts) !== 3) {
                error_log("❌ Invalid JWS format - expected 3 parts, got " . count($parts));
                return null;
            }

            // Decode header to get certificate chain (x5c)
            $header = json_decode(base64_decode(strtr($parts[0], '-_', '+/')));
            if (!$header) {
                error_log("❌ Failed to decode JWS header");
                return null;
            }

            error_log("📋 JWS Header algorithm: " . ($header->alg ?? 'unknown'));

            // Extract public key from x5c certificates (like Motoro does)
            if (!isset($header->x5c) || !is_array($header->x5c) || count($header->x5c) === 0) {
                error_log("❌ No x5c certificates found in JWS header");
                return null;
            }

            // The first certificate in x5c is the one used to sign the JWS
            $cert = $header->x5c[0];
            $certPem = "-----BEGIN CERTIFICATE-----\n" . $cert . "\n-----END CERTIFICATE-----";

            // Extract public key from certificate
            $publicKeyResource = openssl_pkey_get_public($certPem);
            if (!$publicKeyResource) {
                error_log("❌ Failed to extract public key from certificate");
                return null;
            }

            $publicKeyDetails = openssl_pkey_get_details($publicKeyResource);
            $publicKey = $publicKeyDetails['key'];

            // Verify signature using the public key
            $decoded = JWT::decode($jws, new Key($publicKey, 'ES256'));

            if (!$decoded) {
                error_log("❌ JWT decode failed");
                return null;
            }

            error_log("✅ JWS signature valid");

            // Log payload information for debugging
            error_log("📦 Transaction ID: " . ($decoded->transactionId ?? 'N/A'));
            error_log("📦 Product ID: " . ($decoded->productId ?? 'N/A'));
            error_log("📦 Bundle ID: " . ($decoded->bundleId ?? 'N/A'));
            error_log("📦 Environment: " . ($decoded->environment ?? 'N/A'));

            if (isset($decoded->purchaseDate)) {
                error_log("📅 Purchase Date: " . date('Y-m-d H:i:s', $decoded->purchaseDate / 1000));
            }

            if (isset($decoded->expiresDate)) {
                error_log("📅 Expires Date: " . date('Y-m-d H:i:s', $decoded->expiresDate / 1000));
            } else {
                error_log("⚠️ No expiresDate in payload");
            }

            return $decoded;

        } catch (\Exception $e) {
            error_log("❌ JWS verification failed: " . $e->getMessage());
            error_log("Stack trace: " . $e->getTraceAsString());
            return null;
        }
    }

    private function getApplePublicKey($kid)
    {
        $cacheFile = __DIR__ . '/../../cache/apple_jwks.json';
        $cacheDir = dirname($cacheFile);

        if (!is_dir($cacheDir)) {
            mkdir($cacheDir, 0755, true);
        }

        return AppleJWKHelper::getApplePublicKeyPem($kid, $cacheFile);
    }

    /**
     * Verify PKCS#7 receipt via Apple's verifyReceipt endpoint
     * Used for StoreKit 1 receipts (legacy support)
     */
    private function verifyApplePKCS7Receipt(string $receiptData): ?object
    {
        error_log("🍎 Verifying PKCS#7 receipt via Apple endpoint...");

        // Load shared secret from config (REQUIRED for auto-renewable subscriptions)
        $config = require __DIR__ . '/../../config/app.php';
        $sharedSecret = \NfcAnycubic\EnvLoader::get('APPLE_SHARED_SECRET', '');

        if (empty($sharedSecret) || $sharedSecret === 'YOUR_SHARED_SECRET_HERE') {
            error_log("⚠️ APPLE_SHARED_SECRET not configured - subscription info may be incomplete");
        }

        // Try production first, then sandbox
        $endpoints = [
            'https://buy.itunes.apple.com/verifyReceipt',
            'https://sandbox.itunes.apple.com/verifyReceipt'
        ];

        $payload = json_encode([
            'receipt-data' => $receiptData,
            'password' => $sharedSecret, // Shared secret REQUIRED for auto-renewable subscriptions
            'exclude-old-transactions' => true
        ]);

        foreach ($endpoints as $endpoint) {
            $ch = curl_init($endpoint);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_POST => true,
                CURLOPT_POSTFIELDS => $payload,
                CURLOPT_HTTPHEADER => ['Content-Type: application/json'],
                CURLOPT_TIMEOUT => 30,
                CURLOPT_SSL_VERIFYPEER => true,
            ]);

            $response = curl_exec($ch);
            $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $curlError = curl_error($ch);

            if ($curlError) {
                error_log("❌ cURL error: $curlError");
                continue;
            }

            if ($httpCode !== 200) {
                error_log("❌ Apple API HTTP $httpCode");
                continue;
            }

            $result = json_decode($response);

            // Status 21007 means use sandbox
            if (isset($result->status) && $result->status === 21007) {
                error_log("📦 Receipt is sandbox, switching to sandbox endpoint...");
                continue;
            }

            // Status 0 = success
            if (!isset($result->status) || $result->status !== 0) {
                error_log("❌ Apple verification failed with status: " . ($result->status ?? 'unknown'));
                // Log common status codes
                $statusMessages = [
                    21000 => 'App Store could not read JSON',
                    21002 => 'Receipt data malformed',
                    21003 => 'Receipt not authenticated',
                    21004 => 'Shared secret mismatch',
                    21005 => 'Receipt server unavailable',
                    21006 => 'Receipt valid but subscription expired',
                    21007 => 'Sandbox receipt sent to production',
                    21008 => 'Production receipt sent to sandbox',
                    21010 => 'Could not be authorized',
                ];
                $statusCode = $result->status ?? 'unknown';
                if (isset($statusMessages[$statusCode])) {
                    error_log("📋 Status meaning: " . $statusMessages[$statusCode]);
                }
                return null;
            }

            error_log("✅ PKCS#7 receipt verified by Apple");
            error_log("📋 Environment: " . ($result->environment ?? 'unknown'));

            // Extract latest subscription info
            $latestReceipt = $result->latest_receipt_info ?? [];

            // Log what we received
            error_log("📦 latest_receipt_info count: " . (is_array($latestReceipt) ? count($latestReceipt) : 'not array'));

            // Also check pending_renewal_info for subscription status
            $pendingRenewal = $result->pending_renewal_info ?? [];
            error_log("📦 pending_renewal_info count: " . (is_array($pendingRenewal) ? count($pendingRenewal) : 'not array'));

            if (is_array($latestReceipt) && count($latestReceipt) > 0) {
                // Get the most recent transaction
                usort($latestReceipt, function($a, $b) {
                    return ($b->expires_date_ms ?? 0) - ($a->expires_date_ms ?? 0);
                });
                $latest = $latestReceipt[0];

                error_log("📋 Latest transaction: " . json_encode($latest));

                // Convert to our standard format
                $transaction = (object)[
                    'transactionId' => $latest->transaction_id ?? null,
                    'originalTransactionId' => $latest->original_transaction_id ?? null,
                    'productId' => $latest->product_id ?? null,
                    'bundleId' => $result->receipt->bundle_id ?? $this->bundleId,
                    'purchaseDate' => isset($latest->purchase_date_ms) ? (int)$latest->purchase_date_ms : null,
                    'expiresDate' => isset($latest->expires_date_ms) ? (int)$latest->expires_date_ms : null,
                    'environment' => $result->environment ?? 'Production',
                ];

                error_log("📦 Product ID: " . $transaction->productId);
                error_log("📦 Bundle ID: " . $transaction->bundleId);
                error_log("📅 Expires: " . ($transaction->expiresDate ? date('Y-m-d H:i:s', $transaction->expiresDate / 1000) : 'N/A'));

                // Check if subscription is expired
                if ($transaction->expiresDate) {
                    $isExpired = ($transaction->expiresDate / 1000) < time();
                    error_log("⏰ Is expired: " . ($isExpired ? 'YES' : 'NO'));
                }

                return $transaction;
            }

            // Fallback: try to extract from receipt.in_app array
            $inApp = $result->receipt->in_app ?? [];
            error_log("📦 Fallback: receipt.in_app count: " . (is_array($inApp) ? count($inApp) : 'not array'));

            if (is_array($inApp) && count($inApp) > 0) {
                // Sort by purchase date descending
                usort($inApp, function($a, $b) {
                    return ($b->purchase_date_ms ?? 0) - ($a->purchase_date_ms ?? 0);
                });
                $latest = $inApp[0];

                error_log("📋 Using in_app fallback: " . json_encode($latest));

                $transaction = (object)[
                    'transactionId' => $latest->transaction_id ?? null,
                    'originalTransactionId' => $latest->original_transaction_id ?? null,
                    'productId' => $latest->product_id ?? null,
                    'bundleId' => $result->receipt->bundle_id ?? $this->bundleId,
                    'purchaseDate' => isset($latest->purchase_date_ms) ? (int)$latest->purchase_date_ms : null,
                    'expiresDate' => isset($latest->expires_date_ms) ? (int)$latest->expires_date_ms : null,
                    'environment' => $result->environment ?? 'Production',
                ];

                return $transaction;
            }

            error_log("⚠️ No subscription info in receipt - full response: " . json_encode($result));
            return null;
        }

        error_log("❌ All Apple endpoints failed");
        return null;
    }

    private function saveSubscription($userId, $transaction, $signedTransaction, $platform = 'ios')
    {
        // Check if subscription already exists
        $checkStmt = $this->db->prepare("
            SELECT id, expires_date, status
            FROM subscriptions
            WHERE user_id = ? AND original_transaction_id = ?
        ");
        $checkStmt->execute([$userId, $transaction->originalTransactionId]);
        $existing = $checkStmt->fetch(\PDO::FETCH_ASSOC);

        $purchaseDate = $transaction->purchaseDate / 1000;
        $expiresDate = $transaction->expiresDate ? ($transaction->expiresDate / 1000) : null;
        $environment = $transaction->environment ?? 'Production';

        // Determine status based on expiration date
        $now = time();
        if ($expiresDate === null) {
            // PKCS#7 Sandbox - cannot determine expiration, assume active
            $status = 'active';
        } else {
            $status = ($expiresDate > $now) ? 'active' : 'expired';
        }

        error_log("💾 Saving subscription - Platform: $platform, Status: $status, Expires: " . ($expiresDate ? date('Y-m-d H:i:s', $expiresDate) : 'N/A'));

        if ($existing) {
            // Update existing subscription with Apple's data
            error_log("🔄 Updating existing subscription ID: " . $existing['id']);

            if ($expiresDate !== null) {
                $stmt = $this->db->prepare("
                    UPDATE subscriptions
                    SET transaction_id = ?,
                        status = ?,
                        purchase_date = FROM_UNIXTIME(?),
                        expires_date = FROM_UNIXTIME(?),
                        environment = ?,
                        jws_transaction = ?,
                        updated_at = CURRENT_TIMESTAMP
                    WHERE id = ?
                ");

                $stmt->execute([
                    $transaction->transactionId,
                    $status,
                    $purchaseDate,
                    $expiresDate,
                    $environment,
                    $signedTransaction,
                    $existing['id']
                ]);
            } else {
                // No expires date (PKCS#7) - skip updating it
                $stmt = $this->db->prepare("
                    UPDATE subscriptions
                    SET transaction_id = ?,
                        status = ?,
                        purchase_date = FROM_UNIXTIME(?),
                        environment = ?,
                        jws_transaction = ?,
                        updated_at = CURRENT_TIMESTAMP
                    WHERE id = ?
                ");

                $stmt->execute([
                    $transaction->transactionId,
                    $status,
                    $purchaseDate,
                    $environment,
                    $signedTransaction,
                    $existing['id']
                ]);
            }

            return $existing['id'];
        } else {
            // Insert new subscription
            error_log("➕ Creating new subscription");

            if ($expiresDate !== null) {
                $stmt = $this->db->prepare("
                    INSERT INTO subscriptions (
                        user_id, original_transaction_id, transaction_id, product_id,
                        status, purchase_date, expires_date, environment, jws_transaction
                    ) VALUES (?, ?, ?, ?, ?, FROM_UNIXTIME(?), FROM_UNIXTIME(?), ?, ?)
                ");

                $stmt->execute([
                    $userId,
                    $transaction->originalTransactionId,
                    $transaction->transactionId,
                    $transaction->productId,
                    $status,
                    $purchaseDate,
                    $expiresDate,
                    $environment,
                    $signedTransaction
                ]);
            } else {
                // No expires date (PKCS#7) - set to NULL
                $stmt = $this->db->prepare("
                    INSERT INTO subscriptions (
                        user_id, original_transaction_id, transaction_id, product_id,
                        status, purchase_date, expires_date, environment, jws_transaction
                    ) VALUES (?, ?, ?, ?, ?, FROM_UNIXTIME(?), NULL, ?, ?)
                ");

                $stmt->execute([
                    $userId,
                    $transaction->originalTransactionId,
                    $transaction->transactionId,
                    $transaction->productId,
                    $status,
                    $purchaseDate,
                    $environment,
                    $signedTransaction
                ]);
            }

            return $this->db->lastInsertId();
        }
    }

    private function updateUserPremiumStatus($userId, $isPremium, $expiresDate = null)
    {
        // First check if user already has a VIP status that shouldn't be overwritten
        $stmt = $this->db->prepare("
            SELECT is_vip, vip_expires_at, subscription_type
            FROM user_preferences
            WHERE user_id = ?
        ");
        $stmt->execute([$userId]);
        $existing = $stmt->fetch(\PDO::FETCH_ASSOC);

        // If user has lifetime VIP, don't overwrite
        if ($existing && $existing['is_vip'] && $existing['subscription_type'] === 'lifetime') {
            error_log("⚠️ User $userId has lifetime VIP - not overwriting");
            return;
        }

        // If user has VIP with later expiration, don't overwrite with earlier date
        $newExpiresTimestamp = $expiresDate ? ($expiresDate / 1000) : null;
        if ($existing && $existing['is_vip'] && $existing['vip_expires_at']) {
            $existingExpires = strtotime($existing['vip_expires_at']);
            if ($newExpiresTimestamp && $existingExpires > $newExpiresTimestamp) {
                error_log("⚠️ User $userId has VIP expiring later (" . $existing['vip_expires_at'] . ") - not overwriting");
                return;
            }
        }

        $expiresTimestampStr = $newExpiresTimestamp ? date('Y-m-d H:i:s', $newExpiresTimestamp) : null;

        $stmt = $this->db->prepare("
            INSERT INTO user_preferences (user_id, is_vip, vip_expires_at)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE
                is_vip = VALUES(is_vip),
                vip_expires_at = VALUES(vip_expires_at)
        ");

        $stmt->execute([$userId, $isPremium ? 1 : 0, $expiresTimestampStr]);
    }

    private function error($message, $code = 400)
    {
        http_response_code($code);
        return ['success' => false, 'error' => $message];
    }

    /**
     * Log subscription event for audit trail
     */
    private function logSubscriptionEvent(
        ?string $userId,
        ?string $originalTransactionId,
        string $eventType,
        array $eventData = [],
        string $source = 'api'
    ): void {
        try {
            // Get subscription ID if we have transaction ID
            $subscriptionId = null;
            if ($originalTransactionId) {
                $stmt = $this->db->prepare(
                    "SELECT id FROM subscriptions WHERE original_transaction_id = ?"
                );
                $stmt->execute([$originalTransactionId]);
                $row = $stmt->fetch();
                $subscriptionId = $row['id'] ?? null;
            }

            $stmt = $this->db->prepare("
                INSERT INTO subscription_events
                (subscription_id, user_id, original_transaction_id, event_type, event_data, source, ip_address, user_agent)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ");

            $stmt->execute([
                $subscriptionId,
                $userId,
                $originalTransactionId,
                $eventType,
                json_encode($eventData),
                $source,
                $_SERVER['REMOTE_ADDR'] ?? null,
                substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 500)
            ]);
        } catch (\Exception $e) {
            // Don't fail the main operation if logging fails
            error_log("Failed to log subscription event: " . $e->getMessage());
        }
    }

    /**
     * Log validation failure for security monitoring
     */
    private function logValidationFailure(
        ?string $userId,
        ?string $transactionId,
        string $platform,
        string $reason,
        ?string $errorMessage = null,
        ?string $jwsPayload = null
    ): void {
        try {
            // Map reason to enum value
            $validReasons = [
                'invalid_signature', 'expired_transaction', 'invalid_bundle_id',
                'replay_attack', 'invalid_product', 'certificate_error',
                'network_error', 'rate_limited', 'unknown'
            ];
            $reason = in_array($reason, $validReasons) ? $reason : 'unknown';

            $stmt = $this->db->prepare("
                INSERT INTO subscription_validation_failures
                (user_id, transaction_id, platform, failure_reason, error_message, jws_payload, ip_address, user_agent)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ");

            $stmt->execute([
                $userId,
                $transactionId,
                $platform,
                $reason,
                $errorMessage,
                $jwsPayload ? substr($jwsPayload, 0, 10000) : null, // Limit size
                $_SERVER['REMOTE_ADDR'] ?? null,
                substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 500)
            ]);

            error_log("Validation failure logged: $reason for user $userId");
        } catch (\Exception $e) {
            error_log("Failed to log validation failure: " . $e->getMessage());
        }
    }

    /**
     * Check for replay attack (duplicate transaction)
     */
    private function checkReplayAttack(string $transactionId, string $userId): bool
    {
        // Check if this transaction was processed in the last hour
        $stmt = $this->db->prepare("
            SELECT id FROM subscriptions
            WHERE transaction_id = ?
            AND user_id = ?
            AND created_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)
        ");
        $stmt->execute([$transactionId, $userId]);

        if ($stmt->fetch()) {
            $this->logValidationFailure($userId, $transactionId, 'ios', 'replay_attack', 'Duplicate transaction in 1 hour');
            return true;
        }

        return false;
    }
}
