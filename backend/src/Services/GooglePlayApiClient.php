<?php
/**
 * Google Play Developer API — abonnements (purchases.subscriptions).
 *
 * Partagé par POST /subscriptions/verify et le webhook RTDN : l'état d'un
 * abonnement vient TOUJOURS de cette API, jamais du contenu d'une
 * notification (le webhook n'est pas authentifié).
 *
 * Le purchaseToken et le productId sont encodés dans l'URL (avant : insérés
 * tels quels).
 */

namespace NfcAnycubic\Services;

use Firebase\JWT\JWT;
use NfcAnycubic\Logger;

class GooglePlayApiClient {

    public const PACKAGE_NAME = 'com.engagengine.nfc_anycubic';
    private const API_BASE = 'https://androidpublisher.googleapis.com/androidpublisher/v3/applications/';
    private const TOKEN_URL = 'https://oauth2.googleapis.com/token';

    /** Fabrique remplaçable par les tests (jamais modifiée en production). */
    public static ?\Closure $factory = null;

    private ?array $serviceAccount;
    private ?string $accessToken = null;

    public static function create(): self {
        return self::$factory ? (self::$factory)() : new self();
    }

    public function __construct(?string $serviceAccountPath = null) {
        $path = $serviceAccountPath ?? __DIR__ . '/../../config/google-play-service-account.json';
        $sa = is_readable($path) ? json_decode((string)file_get_contents($path), true) : null;
        $this->serviceAccount = (is_array($sa) && isset($sa['client_email'], $sa['private_key'])) ? $sa : null;
    }

    public function isConfigured(): bool {
        return $this->serviceAccount !== null;
    }

    /**
     * purchases.subscriptions.get
     * status : code HTTP, 0 = réseau ou configuration (erreur passagère).
     *
     * @return array{status:int, data:?array}
     */
    public function getSubscription(string $productId, string $purchaseToken): array {
        return $this->request('GET', $this->subscriptionUrl($productId, $purchaseToken));
    }

    /** purchases.subscriptions.acknowledge (sans effet si déjà acquitté). */
    public function acknowledge(string $productId, string $purchaseToken): bool {
        $res = $this->request('POST', $this->subscriptionUrl($productId, $purchaseToken) . ':acknowledge', []);
        return $res['status'] >= 200 && $res['status'] < 300;
    }

    private function subscriptionUrl(string $productId, string $purchaseToken): string {
        return self::API_BASE . rawurlencode(self::PACKAGE_NAME)
            . '/purchases/subscriptions/' . rawurlencode($productId)
            . '/tokens/' . rawurlencode($purchaseToken);
    }

    /** @return array{status:int, data:?array} */
    protected function request(string $method, string $url, ?array $body = null): array {
        $token = $this->accessToken();
        if ($token === null) {
            return ['status' => 0, 'data' => null];
        }
        $ch = curl_init($url);
        $opts = [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => 20,
            CURLOPT_HTTPHEADER => ['Authorization: Bearer ' . $token, 'Content-Type: application/json'],
        ];
        if ($method === 'POST') {
            $opts[CURLOPT_POST] = true;
            $opts[CURLOPT_POSTFIELDS] = json_encode($body ?? new \stdClass());
        }
        curl_setopt_array($ch, $opts);
        $response = curl_exec($ch);
        $status = $response === false ? 0 : (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        if ($response === false) {
            Logger::warning('google.play', 'Appel API Google Play impossible', ['error' => curl_error($ch)]);
        } elseif ($status >= 300) {
            Logger::warning('google.play', 'API Google Play en erreur', [
                'http_status' => $status,
                'body' => substr((string)$response, 0, 300),
            ]);
        }
        $data = is_string($response) ? json_decode($response, true) : null;
        return ['status' => $status, 'data' => is_array($data) ? $data : null];
    }

    private function accessToken(): ?string {
        if ($this->accessToken !== null) return $this->accessToken;
        if ($this->serviceAccount === null) {
            Logger::warning('google.play', 'Compte de service Google Play absent (config/google-play-service-account.json)');
            return null;
        }
        $now = time();
        $assertion = JWT::encode([
            'iss' => $this->serviceAccount['client_email'],
            'scope' => 'https://www.googleapis.com/auth/androidpublisher',
            'aud' => self::TOKEN_URL,
            'iat' => $now,
            'exp' => $now + 3600,
        ], $this->serviceAccount['private_key'], 'RS256');

        $ch = curl_init(self::TOKEN_URL);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => http_build_query([
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $assertion,
            ]),
            CURLOPT_TIMEOUT => 20,
        ]);
        $response = curl_exec($ch);
        $status = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $data = is_string($response) ? json_decode($response, true) : null;
        if ($status !== 200 || empty($data['access_token'])) {
            Logger::warning('google.play', 'Jeton OAuth Google refusé', ['http_status' => $status]);
            return null;
        }
        return $this->accessToken = (string)$data['access_token'];
    }
}
