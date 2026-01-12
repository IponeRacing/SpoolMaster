<?php

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\AppleJWKHelper;
use NfcAnycubic\Middleware\AuthMiddleware;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

/**
 * Apple In-App Purchase Subscription Controller
 * Compatible avec le Router existant
 */
class SubscriptionController
{
    private $db;
    private $bundleId = 'com.engageengine.nfcfilament';

    public function __construct()
    {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * POST /subscriptions/verify
     */
    public function verifyPurchase()
    {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return $this->error('Unauthorized', 401);

        $data = json_decode(file_get_contents('php://input'), true);

        if (!isset($data['signedTransaction'])) {
            return $this->error('Missing signedTransaction', 400);
        }

        $signedTransaction = $data['signedTransaction'];
        $requestedProductId = $data['productId'] ?? null;

        // Debug logging
        error_log("=== VERIFY PURCHASE DEBUG ===");
        error_log("User ID: " . $userId);
        error_log("Received data: " . json_encode($data));
        error_log("SignedTransaction length: " . strlen($signedTransaction));
        error_log("SignedTransaction preview: " . substr($signedTransaction, 0, 100));

        try {
            $transaction = $this->verifyAppleJWS($signedTransaction);

            if (!$transaction) {
                error_log("Transaction verification returned null");
                return $this->error('Invalid signature', 400);
            }

            if ($transaction->bundleId !== $this->bundleId) {
                error_log("Invalid bundle ID: " . $transaction->bundleId);
                return $this->error('Invalid bundle ID', 400);
            }

            // For Sandbox old receipt format, use the productId from the request
            if ($transaction->environment === 'Sandbox' && $requestedProductId) {
                $transaction->productId = $requestedProductId;
            }

            $validProducts = ['spool_master_monthly', 'spool_master_yearly'];
            if (!in_array($transaction->productId, $validProducts)) {
                error_log("Invalid product: " . $transaction->productId);
                return $this->error('Invalid product', 400);
            }

            $subscriptionId = $this->saveSubscription($userId, $transaction, $signedTransaction);

            // Check if subscription is currently active
            if ($transaction->expiresDate === null) {
                // PKCS#7 format - check database for actual status
                error_log("⚠️ No expiration date available (PKCS#7 format) - checking database for status");

                $stmt = $this->db->prepare("
                    SELECT status, expires_date
                    FROM subscriptions
                    WHERE original_transaction_id = ?
                    ORDER BY purchase_date DESC
                    LIMIT 1
                ");
                $stmt->execute([$transaction->originalTransactionId]);
                $dbSub = $stmt->fetch(\PDO::FETCH_ASSOC);

                if ($dbSub) {
                    $isActive = ($dbSub['status'] === 'active' &&
                                (!$dbSub['expires_date'] || strtotime($dbSub['expires_date']) > time()));
                    error_log("📊 Database status: " . $dbSub['status'] . ", expires: " . ($dbSub['expires_date'] ?? 'NULL') . ", active: " . ($isActive ? 'yes' : 'no'));
                } else {
                    // New subscription, no database record yet - accept as active for Sandbox
                    $isActive = true;
                    error_log("📊 New subscription - accepting as active for Sandbox");
                }
                $expiresTimestamp = null;
            } else {
                $expiresTimestamp = $transaction->expiresDate / 1000;
                $isActive = $expiresTimestamp > time();
            }

            // Update user premium status based on expiration
            $this->updateUserPremiumStatus($userId, $isActive, $transaction->expiresDate);

            error_log("✅ Subscription verified successfully - Product: " . $transaction->productId . ", Environment: " . ($transaction->environment ?? 'Production'));

            if ($expiresTimestamp) {
                error_log("📊 Status: " . ($isActive ? 'Active' : 'Expired') . ", Expires: " . date('Y-m-d H:i:s', $expiresTimestamp));
            } else {
                error_log("📊 Status: Active (Sandbox PKCS#7 - no expiration info)");
            }

            return [
                'success' => true,
                'subscription' => [
                    'product_id' => $transaction->productId,
                    'expires_at' => $transaction->expiresDate,
                    'is_premium' => $isActive
                ]
            ];

        } catch (\Exception $e) {
            error_log("Subscription verification error: " . $e->getMessage());
            return $this->error('Verification failed: ' . $e->getMessage(), 500);
        }
    }

    /**
     * GET /subscriptions/status
     */
    public function getSubscriptionStatus()
    {
        $userId = AuthMiddleware::getUserId();
        if (!$userId) return $this->error('Unauthorized', 401);

        try {
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
        // Extraire le secret des paramètres
        $secret = $params['secret'] ?? null;

        // Vérifier le secret (généré avec: openssl rand -hex 32)
        $validSecret = 'nfc_cron_secret_2026_b7e9f3a1c8d4e2f5'; // Change ce secret !

        if ($secret !== $validSecret) {
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
            error_log("🕐 [MANUAL] Starting subscription expiration check...");

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

            error_log("✅ [MANUAL] Expiration check completed - Expired: $expiredCount, Deactivated: $deactivatedCount");

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
            // Detect old receipt format (Sandbox - starts with "MI" and is very long)
            if (substr($jws, 0, 2) === 'MI' && strlen($jws) > 5000) {
                error_log("⚠️ Old PKCS#7 receipt format detected (Apple Sandbox legacy format)");
                error_log("⚠️ This format cannot provide reliable expiration dates");

                // For Sandbox, we'll accept it but return null for expiresDate
                // The expiration will need to be managed manually or via webhooks
                return (object)[
                    'bundleId' => $this->bundleId,
                    'productId' => 'SANDBOX_UNKNOWN', // Will be overridden with request productId
                    'originalTransactionId' => 'sandbox_pkcs7_' . substr(md5($jws), 0, 16),
                    'transactionId' => 'sandbox_pkcs7_' . substr(md5($jws), 0, 16),
                    'purchaseDate' => time() * 1000,
                    'expiresDate' => null, // Cannot extract from PKCS#7 easily
                    'environment' => 'Sandbox'
                ];
            }

            // Standard StoreKit 2 JWS verification (like Motoro)
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

    private function saveSubscription($userId, $transaction, $signedTransaction)
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

        error_log("💾 Saving subscription - Status: $status, Expires: " . ($expiresDate ? date('Y-m-d H:i:s', $expiresDate) : 'N/A (Sandbox PKCS#7)'));

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
        $expiresTimestamp = $expiresDate ? date('Y-m-d H:i:s', $expiresDate / 1000) : null;

        $stmt = $this->db->prepare("
            INSERT INTO user_preferences (user_id, is_vip, vip_expires_at)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE
                is_vip = VALUES(is_vip),
                vip_expires_at = VALUES(vip_expires_at)
        ");

        $stmt->execute([$userId, $isPremium ? 1 : 0, $expiresTimestamp]);
    }

    private function error($message, $code = 400)
    {
        http_response_code($code);
        return ['success' => false, 'error' => $message];
    }
}
