<?php

namespace NfcAnycubic;

/**
 * Helper class to convert Apple JWK to PEM format
 * Required for verifying Apple's JWS signatures
 */
class AppleJWKHelper
{
    /**
     * Convert JWK (JSON Web Key) to PEM format
     * Apple uses EC (Elliptic Curve) keys with P-256 curve
     *
     * @param array $jwk The JWK from Apple's JWKS endpoint
     * @return string PEM formatted public key
     */
    public static function jwkToPem(array $jwk): string
    {
        if (!isset($jwk['kty'])) {
            throw new \InvalidArgumentException('Missing kty in JWK');
        }

        // Les identity tokens Sign in with Apple sont signés RS256 (clés RSA)
        if ($jwk['kty'] === 'RSA') {
            return self::rsaJwkToPem($jwk);
        }

        if ($jwk['kty'] !== 'EC') {
            throw new \InvalidArgumentException('Only EC and RSA keys are supported');
        }

        if (!isset($jwk['crv']) || $jwk['crv'] !== 'P-256') {
            throw new \InvalidArgumentException('Only P-256 curve is supported');
        }

        if (!isset($jwk['x']) || !isset($jwk['y'])) {
            throw new \InvalidArgumentException('Missing x or y coordinates');
        }

        // Decode base64url encoded coordinates
        $x = self::base64UrlDecode($jwk['x']);
        $y = self::base64UrlDecode($jwk['y']);

        // EC public key format:
        // 0x04 (uncompressed point) + x (32 bytes) + y (32 bytes)
        $publicKeyPoint = "\x04" . $x . $y;

        // DER encode the public key
        $der = self::createDerEncodedKey($publicKeyPoint);

        // Convert to PEM
        $pem = "-----BEGIN PUBLIC KEY-----\n";
        $pem .= chunk_split(base64_encode($der), 64, "\n");
        $pem .= "-----END PUBLIC KEY-----\n";

        return $pem;
    }

    /**
     * Convert RSA JWK (n, e) to PEM SubjectPublicKeyInfo
     */
    private static function rsaJwkToPem(array $jwk): string
    {
        if (!isset($jwk['n']) || !isset($jwk['e'])) {
            throw new \InvalidArgumentException('Missing n or e in RSA JWK');
        }

        $n = self::base64UrlDecode($jwk['n']);
        $e = self::base64UrlDecode($jwk['e']);

        // INTEGER : préfixer 0x00 si le bit de poids fort est à 1 (nombre positif)
        $nInt = self::derInteger($n);
        $eInt = self::derInteger($e);

        // RSAPublicKey ::= SEQUENCE { modulus INTEGER, publicExponent INTEGER }
        $rsaPublicKey = self::derSequence($nInt . $eInt);

        // OID rsaEncryption 1.2.840.113549.1.1.1 + NULL
        $algorithmIdentifier = self::derSequence(
            "\x06\x09\x2a\x86\x48\x86\xf7\x0d\x01\x01\x01" . "\x05\x00"
        );

        // SubjectPublicKeyInfo ::= SEQUENCE { algorithm, subjectPublicKey BIT STRING }
        $der = self::derSequence($algorithmIdentifier . self::derBitString($rsaPublicKey));

        $pem = "-----BEGIN PUBLIC KEY-----\n";
        $pem .= chunk_split(base64_encode($der), 64, "\n");
        $pem .= "-----END PUBLIC KEY-----\n";

        return $pem;
    }

    /**
     * Create DER INTEGER (unsigned big-endian input)
     */
    private static function derInteger(string $bytes): string
    {
        $bytes = ltrim($bytes, "\x00");
        if ($bytes === '') {
            $bytes = "\x00";
        }
        if (ord($bytes[0]) & 0x80) {
            $bytes = "\x00" . $bytes;
        }
        return "\x02" . self::derLength(strlen($bytes)) . $bytes;
    }

    /**
     * Base64 URL decode (RFC 4648)
     */
    private static function base64UrlDecode(string $input): string
    {
        $remainder = strlen($input) % 4;
        if ($remainder) {
            $padlen = 4 - $remainder;
            $input .= str_repeat('=', $padlen);
        }
        return base64_decode(strtr($input, '-_', '+/'));
    }

    /**
     * Create DER encoded public key for P-256 EC
     * Based on ASN.1 structure for EC public keys
     */
    private static function createDerEncodedKey(string $publicKeyPoint): string
    {
        // OID for EC Public Key: 1.2.840.10045.2.1
        $oidEcPublicKey = "\x06\x07\x2a\x86\x48\xce\x3d\x02\x01";

        // OID for P-256 curve (secp256r1): 1.2.840.10045.3.1.7
        $oidP256 = "\x06\x08\x2a\x86\x48\xce\x3d\x03\x01\x07";

        // Algorithm identifier SEQUENCE
        $algorithmIdentifier = self::derSequence($oidEcPublicKey . $oidP256);

        // Public key BIT STRING
        $publicKeyBitString = self::derBitString($publicKeyPoint);

        // Final SEQUENCE
        return self::derSequence($algorithmIdentifier . $publicKeyBitString);
    }

    /**
     * Create DER SEQUENCE
     */
    private static function derSequence(string $content): string
    {
        return "\x30" . self::derLength(strlen($content)) . $content;
    }

    /**
     * Create DER BIT STRING
     */
    private static function derBitString(string $content): string
    {
        // 0x00 indicates no unused bits
        $bitString = "\x00" . $content;
        return "\x03" . self::derLength(strlen($bitString)) . $bitString;
    }

    /**
     * Encode length in DER format
     */
    private static function derLength(int $length): string
    {
        if ($length < 128) {
            return chr($length);
        }

        $lengthBytes = '';
        while ($length > 0) {
            $lengthBytes = chr($length & 0xff) . $lengthBytes;
            $length >>= 8;
        }

        return chr(0x80 | strlen($lengthBytes)) . $lengthBytes;
    }

    /**
     * Fetch and cache Apple's public keys
     *
     * @param string|null $cacheFile Path to cache file (optional)
     * @param int $cacheTtl Cache TTL in seconds (default 1 hour)
     * @return array Array of JWKs
     */
    public static function fetchApplePublicKeys(?string $cacheFile = null, int $cacheTtl = 3600): array
    {
        // Try to load from cache
        if ($cacheFile && file_exists($cacheFile)) {
            $cacheData = json_decode(file_get_contents($cacheFile), true);
            if ($cacheData && isset($cacheData['expires']) && $cacheData['expires'] > time()) {
                return $cacheData['keys'];
            }
        }

        // Fetch from Apple
        $jwksUrl = 'https://appleid.apple.com/auth/keys';

        $ch = curl_init($jwksUrl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 10);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, true);
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);

        if ($httpCode !== 200) {
            throw new \RuntimeException("Failed to fetch Apple JWKS: HTTP $httpCode - $error");
        }

        $jwks = json_decode($response, true);
        if (!isset($jwks['keys'])) {
            throw new \RuntimeException("Invalid JWKS response from Apple");
        }

        // Save to cache
        if ($cacheFile) {
            $cacheData = [
                'keys' => $jwks['keys'],
                'expires' => time() + $cacheTtl,
                'fetched_at' => time()
            ];
            file_put_contents($cacheFile, json_encode($cacheData, JSON_PRETTY_PRINT));
        }

        return $jwks['keys'];
    }

    /**
     * Get PEM public key by kid (key ID)
     *
     * @param string $kid Key ID from JWS header
     * @param string|null $cacheFile Cache file path
     * @return string|null PEM formatted public key, or null if not found
     */
    public static function getApplePublicKeyPem(string $kid, ?string $cacheFile = null): ?string
    {
        try {
            $keys = self::fetchApplePublicKeys($cacheFile);

            foreach ($keys as $jwk) {
                if (isset($jwk['kid']) && $jwk['kid'] === $kid) {
                    return self::jwkToPem($jwk);
                }
            }

            return null;
        } catch (\Exception $e) {
            error_log("Failed to get Apple public key: " . $e->getMessage());
            return null;
        }
    }
}
