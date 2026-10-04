<?php

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Logger;
use NfcAnycubic\Middleware\AuthMiddleware;
use NfcAnycubic\Middleware\RateLimiter;
use NfcAnycubic\Services\AppleJWSVerifier;
use NfcAnycubic\Services\GooglePlayApiClient;
use NfcAnycubic\Services\PremiumService;

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

        } catch (\Throwable $e) {
            Logger::exception('subscription.verify', $e, ['platform' => $platform]);
            $this->logValidationFailure($userId, null, $platform, 'unknown', $e->getMessage());
            return $this->error('Verification failed', 500);
        }
    }

    private const VALID_PRODUCTS = ['spool_master_monthly', 'spool_master_yearly'];

    /**
     * Verify Apple (iOS) purchase
     */
    private function verifyApplePurchase($userId, $signedTransaction, $requestedProductId)
    {
        $transaction = $this->verifyAppleJWS($signedTransaction);

        if (!$transaction) {
            $this->logValidationFailure($userId, null, 'ios', 'invalid_signature', AppleJWSVerifier::$lastError);
            return $this->error('Invalid transaction', 400);
        }

        if (($transaction->bundleId ?? null) !== $this->bundleId) {
            $this->logValidationFailure($userId, $transaction->transactionId ?? null, 'ios', 'invalid_bundle_id', (string)($transaction->bundleId ?? ''));
            return $this->error('Invalid bundle ID', 400);
        }

        // Le produit vient de la transaction signée, jamais de la requête
        // (avant : en Sandbox, le productId envoyé par l'app la remplaçait).
        if (!in_array($transaction->productId ?? null, self::VALID_PRODUCTS, true)) {
            $this->logValidationFailure($userId, $transaction->transactionId ?? null, 'ios', 'invalid_product', (string)($transaction->productId ?? ''));
            return $this->error('Invalid product', 400);
        }

        if (empty($transaction->expiresDate) || empty($transaction->originalTransactionId)) {
            Logger::warning('subscription.apple', 'Transaction sans échéance ni identifiant d\'origine', [
                'product_id' => $transaction->productId,
            ]);
            return $this->error('Subscription verification incomplete. Please contact support.', 503);
        }

        $saved = $this->saveSubscription($userId, $transaction, $signedTransaction, 'ios');
        $isPremium = PremiumService::refresh($this->db, $userId);

        return [
            'success' => true,
            'subscription' => [
                'product_id' => $transaction->productId,
                'expires_at' => $transaction->expiresDate,
                'status' => $saved['status'],
                'transaction_active' => $saved['status'] === 'active',
                'is_premium' => $isPremium,
            ]
        ];
    }

    /**
     * Verify Google Play (Android) purchase using Google Play Developer API
     */
    private function verifyGooglePlayPurchase($userId, $purchaseToken, $productId)
    {
        if (!in_array($productId, self::VALID_PRODUCTS, true)) {
            $this->logValidationFailure($userId, null, 'android', 'invalid_product', (string)$productId);
            return $this->error('Invalid product', 400);
        }

        $api = GooglePlayApiClient::create();
        if (!$api->isConfigured()) {
            return $this->verifyGooglePlayPurchaseFallback($userId, $purchaseToken, $productId);
        }

        $res = $api->getSubscription($productId, $purchaseToken);
        if ($res['status'] === 0 || $res['status'] >= 500) {
            // Erreur passagère : l'app réessaiera (achat non finalisé côté app)
            $this->logValidationFailure($userId, null, 'android', 'network_error', 'Google Play API HTTP ' . $res['status']);
            return $this->error('Google Play verification temporarily unavailable', 503);
        }
        if ($res['status'] !== 200 || empty($res['data']['expiryTimeMillis'])) {
            $this->logValidationFailure($userId, null, 'android', 'invalid_signature', 'Google Play API HTTP ' . $res['status']);
            return $this->error('Purchase verification failed', 400);
        }

        $data = $res['data'];
        $transaction = self::googleTransaction($productId, $purchaseToken, $data);
        $saved = $this->saveSubscription($userId, $transaction, $purchaseToken, 'android');

        // Acquittement côté serveur : si l'app est tuée avant completePurchase(),
        // Google rembourse automatiquement au bout de 3 jours.
        if ((int)($data['acknowledgementState'] ?? 1) === 0 && $saved['status'] === 'active') {
            if (!$api->acknowledge($productId, $purchaseToken)) {
                Logger::warning('subscription.google', 'Acquittement Google Play échoué (l\'app réessaiera)');
            }
        }

        $isPremium = PremiumService::refresh($this->db, $userId);

        return [
            'success' => true,
            'subscription' => [
                'product_id' => $productId,
                'expires_at' => $transaction->expiresDate,
                'status' => $saved['status'],
                'transaction_active' => $saved['status'] === 'active',
                'is_premium' => $isPremium,
            ]
        ];
    }

    /** Identifiant stable d'un abonnement Google Play (un par purchaseToken). */
    public static function googleOriginalId(string $purchaseToken): string
    {
        return 'gp_' . substr(md5($purchaseToken), 0, 16);
    }

    /** Réponse purchases.subscriptions.get → transaction au format interne. */
    public static function googleTransaction(string $productId, string $purchaseToken, array $data): object
    {
        return (object)[
            'productId' => $productId,
            'originalTransactionId' => self::googleOriginalId($purchaseToken),
            'transactionId' => $data['orderId'] ?? null,
            'purchaseDate' => (int)($data['startTimeMillis'] ?? (time() * 1000)),
            'expiresDate' => (int)$data['expiryTimeMillis'],
            // purchaseType 0 = achat de test (testeurs de licence)
            'environment' => (isset($data['purchaseType']) && (int)$data['purchaseType'] === 0) ? 'Sandbox' : 'Production',
            'autoRenew' => isset($data['autoRenewing']) ? (bool)$data['autoRenewing'] : null,
            'bundleId' => GooglePlayApiClient::PACKAGE_NAME,
        ];
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
            // VIP manuel actif, sinon abonnement actif (période de grâce comprise)
            $status = PremiumService::status($this->db, $userId);
            return ['success' => true] + $status;
        } catch (\Throwable $e) {
            Logger::exception('subscription.status', $e);
            return $this->error('Server error', 500);
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
            // 1. Abonnements échus (fin de période, ou fin de période de grâce)
            $stmt = $this->db->prepare("
                UPDATE subscriptions
                SET status = 'expired',
                    updated_at = CURRENT_TIMESTAMP
                WHERE (status = 'active' AND expires_date IS NOT NULL AND expires_date < NOW())
                   OR (status = 'grace_period' AND COALESCE(grace_period_expires_date, expires_date) < NOW())
            ");
            $stmt->execute();
            $expiredCount = $stmt->rowCount();

            // 2. Un VIP manuel échu redevient un compte normal
            $this->db->exec("
                UPDATE user_preferences
                SET vip_manual = 0
                WHERE vip_manual = 1 AND vip_expires_at IS NOT NULL AND vip_expires_at < NOW()
            ");

            // 3. Cache premium sans abonnement actif. Les VIP manuels actifs ne
            //    sont jamais touchés (avant : effacés à chaque passage du cron).
            $stmt = $this->db->prepare("
                UPDATE user_preferences up
                SET is_vip = 0,
                    vip_expires_at = NULL
                WHERE up.is_vip = 1
                  AND up.vip_manual = 0
                  AND NOT EXISTS (
                      SELECT 1 FROM subscriptions s
                      WHERE s.user_id = up.user_id AND " . PremiumService::ACTIVE_SQL . "
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

        } catch (\Throwable $e) {
            Logger::exception('subscription.cron', $e);
            return $this->error('Failed to check expired subscriptions', 500);
        }
    }

    /**
     * Vérifie une transaction App Store.
     * - JWS StoreKit 2 : chaîne x5c vérifiée jusqu'à Apple Root CA - G3
     *   (avant : clé prise dans x5c[0] sans aucune vérification → un JWS
     *   auto-signé donnait le premium) ;
     * - reçu PKCS#7 StoreKit 1 : validé par Apple (verifyReceipt).
     */
    private function verifyAppleJWS(string $jws): ?object
    {
        if (substr($jws, 0, 2) === 'MI' && strlen($jws) > 5000) {
            return $this->verifyApplePKCS7Receipt($jws);
        }

        $decoded = AppleJWSVerifier::verify($jws);
        if (!$decoded) {
            Logger::warning('subscription.apple', 'Transaction App Store refusée', ['reason' => AppleJWSVerifier::$lastError]);
            return null;
        }
        return $decoded;
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
                    'revocationDate' => isset($latest->cancellation_date_ms) ? (int)$latest->cancellation_date_ms : null,
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
                    'revocationDate' => isset($latest->cancellation_date_ms) ? (int)$latest->cancellation_date_ms : null,
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

    /**
     * Enregistre une transaction vérifiée (Apple ou Google).
     *
     * - Un abonnement appartient au dernier compte qui présente une transaction
     *   valide : « Restaurer » depuis un autre compte le transfère (avant :
     *   INSERT en double sur original_transaction_id UNIQUE → erreur 500).
     * - Un abonnement remboursé/révoqué ne repasse pas actif avec une
     *   transaction antérieure à la révocation (avant : rejouer l'ancien JWS
     *   après remboursement réactivait le premium).
     * - Une transaction plus ancienne que celle enregistrée ne fait pas
     *   reculer l'échéance ni le statut.
     *
     * @return array{status:string, transferred_from:?string}
     */
    private function saveSubscription(string $userId, object $tx, string $signedData, string $platform): array
    {
        $stmt = $this->db->prepare("
            SELECT id, user_id, status,
                   UNIX_TIMESTAMP(expires_date) AS expires_ts,
                   UNIX_TIMESTAMP(COALESCE(revocation_date, updated_at)) AS revoked_ts
            FROM subscriptions
            WHERE original_transaction_id = ?
        ");
        $stmt->execute([$tx->originalTransactionId]);
        $existing = $stmt->fetch(\PDO::FETCH_ASSOC) ?: null;

        $purchaseTs = intdiv((int)($tx->purchaseDate ?? (time() * 1000)), 1000);
        $expiresTs = intdiv((int)$tx->expiresDate, 1000);
        $revocationTs = !empty($tx->revocationDate) ? intdiv((int)$tx->revocationDate, 1000) : null;
        $environment = $tx->environment ?? 'Production';
        $autoRenew = isset($tx->autoRenew) ? (int)$tx->autoRenew : null;

        $status = $revocationTs !== null ? 'revoked' : ($expiresTs > time() ? 'active' : 'expired');

        if (!$existing) {
            $stmt = $this->db->prepare("
                INSERT INTO subscriptions (
                    user_id, original_transaction_id, transaction_id, product_id, platform,
                    status, purchase_date, expires_date, revocation_date, environment,
                    jws_transaction, auto_renew_enabled
                ) VALUES (?, ?, ?, ?, ?, ?, FROM_UNIXTIME(?), FROM_UNIXTIME(?), FROM_UNIXTIME(?), ?, ?, COALESCE(?, 1))
            ");
            $stmt->execute([
                $userId, $tx->originalTransactionId, $tx->transactionId ?? null, $tx->productId, $platform,
                $status, $purchaseTs, $expiresTs, $revocationTs, $environment,
                $signedData, $autoRenew,
            ]);
            $this->logSubscriptionEvent($userId, $tx->originalTransactionId, 'subscription_created', ['status' => $status]);
            return ['status' => $status, 'transferred_from' => null];
        }

        // Transfert de propriété (Restaurer depuis un autre compte)
        $previousUser = null;
        if ($existing['user_id'] !== $userId) {
            $previousUser = $existing['user_id'] ?: null;
            $this->db->prepare("UPDATE subscriptions SET user_id = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?")
                ->execute([$userId, $existing['id']]);
            $this->logSubscriptionEvent($userId, $tx->originalTransactionId, 'subscription_transferred', [
                'from_user_id' => $previousUser,
                'platform' => $platform,
            ]);
            if ($previousUser !== null) {
                PremiumService::refresh($this->db, $previousUser);
            }
        }

        $storedExpiresTs = $existing['expires_ts'] !== null ? (int)$existing['expires_ts'] : null;

        // Remboursé / révoqué : seule une transaction postérieure à la
        // révocation (réabonnement) peut le réactiver.
        if ($existing['status'] === 'revoked' && $status !== 'revoked'
            && $purchaseTs <= (int)$existing['revoked_ts']) {
            $this->logValidationFailure($userId, $tx->transactionId ?? null, $platform, 'replay_attack',
                'Transaction antérieure à la révocation');
            return ['status' => 'revoked', 'transferred_from' => $previousUser];
        }

        // Après un remboursement, le réabonnement a souvent une échéance
        // antérieure à celle de la période remboursée : il prime quand même.
        $resubscribed = $existing['status'] === 'revoked' && $status !== 'revoked';
        $isNewer = $resubscribed || $storedExpiresTs === null || $expiresTs > $storedExpiresTs;
        if (!$isNewer && $status !== 'revoked') {
            // Même transaction ou plus ancienne : rien à mettre à jour (garde
            // par ex. une période de grâce signalée par Apple).
            if ($autoRenew !== null) {
                $this->db->prepare("UPDATE subscriptions SET auto_renew_enabled = ? WHERE id = ?")
                    ->execute([$autoRenew, $existing['id']]);
            }
            return ['status' => $existing['status'], 'transferred_from' => $previousUser];
        }

        $stmt = $this->db->prepare("
            UPDATE subscriptions
            SET transaction_id = ?,
                product_id = ?,
                platform = ?,
                status = ?,
                purchase_date = FROM_UNIXTIME(?),
                expires_date = FROM_UNIXTIME(?),
                revocation_date = FROM_UNIXTIME(?),
                grace_period_expires_date = NULL,
                environment = ?,
                jws_transaction = ?,
                auto_renew_enabled = COALESCE(?, auto_renew_enabled),
                updated_at = CURRENT_TIMESTAMP
            WHERE id = ?
        ");
        $stmt->execute([
            $tx->transactionId ?? null, $tx->productId, $platform, $status,
            $purchaseTs, $isNewer ? $expiresTs : $storedExpiresTs, $revocationTs,
            $environment, $signedData, $autoRenew, $existing['id'],
        ]);
        return ['status' => $status, 'transferred_from' => $previousUser];
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
            // Valeurs de l'ENUM failure_reason (avant : colonnes platform /
            // error_message inexistantes → l'INSERT échouait toujours, en silence)
            $map = [
                'invalid_signature' => 'invalid_signature',
                'certificate_error' => 'invalid_signature',
                'expired_transaction' => 'expired_transaction',
                'invalid_bundle_id' => 'invalid_bundle_id',
                'invalid_product' => 'invalid_product_id',
                'replay_attack' => 'replay_attack',
                'network_error' => 'server_error',
            ];
            $dbReason = $map[$reason] ?? 'other';

            $stmt = $this->db->prepare("
                INSERT INTO subscription_validation_failures
                (user_id, transaction_id, failure_reason, error_details, jws_payload, ip_address, user_agent)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ");

            $stmt->execute([
                $userId,
                $transactionId,
                $dbReason,
                json_encode(['platform' => $platform, 'reason' => $reason, 'message' => $errorMessage]),
                $jwsPayload ? substr($jwsPayload, 0, 10000) : null, // Limit size
                $_SERVER['REMOTE_ADDR'] ?? null,
                substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 500)
            ]);
        } catch (\Throwable $e) {
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
