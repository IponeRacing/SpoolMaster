<?php
/**
 * Vérification des JWS signés par l'App Store (StoreKit 2 : transactions,
 * renewal info, App Store Server Notifications V2).
 *
 * Avant : la clé publique était prise dans x5c[0] fourni PAR LE CLIENT, sans
 * vérifier la chaîne → un JWS auto-signé donnait le premium gratuitement ; le
 * webhook se contentait de vérifier que l'émetteur « contient Apple ».
 *
 * Vérification complète, comme la bibliothèque officielle d'Apple :
 *  1. x5c = [feuille, intermédiaire, racine] ;
 *  2. racine = Apple Root CA - G3, épinglée (empreinte SHA-256 du DER) ;
 *  3. intermédiaire signé par la racine, feuille signée par l'intermédiaire ;
 *  4. extensions Apple : intermédiaire 1.2.840.113635.100.6.2.1,
 *     feuille 1.2.840.113635.100.6.11.1 ;
 *  5. signature ES256 du JWS avec la clé de la feuille ;
 *  6. certificats valides à la date de signature (signedDate), ce qui permet
 *     de revérifier une ancienne transaction après expiration du certificat.
 */

namespace NfcAnycubic\Services;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class AppleJWSVerifier {

    /** Empreinte SHA-256 publiée par Apple pour « Apple Root CA - G3 ». */
    public const ROOT_G3_SHA256 = '63343abfb89a6a03ebb57e9b3f5fa7be7c4f5c756f3017b3a8c488c3653e9179';

    private const OID_INTERMEDIATE = '1.2.840.113635.100.6.2.1';
    private const OID_LEAF = '1.2.840.113635.100.6.11.1';

    /** Racine de confiance. Modifiée uniquement par les tests (chaîne de test). */
    public static string $trustedRoot = self::ROOT_G3_SHA256;

    /** Dernière raison d'échec (journalisation / tests). */
    public static ?string $lastError = null;

    /** Vérifie un JWS App Store et retourne son contenu décodé, ou null. */
    public static function verify(string $jws, ?string $rootFingerprint = null): ?object {
        self::$lastError = null;
        $rootFingerprint ??= self::$trustedRoot;
        try {
            $parts = explode('.', $jws);
            if (count($parts) !== 3) return self::fail('format JWS invalide');

            $header = json_decode(self::b64url($parts[0]));
            if (!$header || ($header->alg ?? '') !== 'ES256') return self::fail('alg doit être ES256');
            if (!isset($header->x5c) || !is_array($header->x5c) || count($header->x5c) !== 3) {
                return self::fail('chaîne x5c attendue : 3 certificats');
            }

            [$leafB64, $interB64, $rootB64] = $header->x5c;
            $rootDer = base64_decode($rootB64, true);
            if ($rootDer === false || !hash_equals($rootFingerprint, hash('sha256', $rootDer))) {
                return self::fail('racine différente de Apple Root CA - G3');
            }

            $leaf = self::pem($leafB64);
            $inter = self::pem($interB64);
            $root = self::pem($rootB64);

            if (openssl_x509_verify($inter, $root) !== 1) return self::fail('intermédiaire non signé par la racine');
            if (openssl_x509_verify($leaf, $inter) !== 1) return self::fail('feuille non signée par l\'intermédiaire');

            $leafInfo = openssl_x509_parse($leaf);
            $interInfo = openssl_x509_parse($inter);
            if (!$leafInfo || !$interInfo) return self::fail('certificat illisible');
            if (!array_key_exists(self::OID_INTERMEDIATE, $interInfo['extensions'] ?? [])) {
                return self::fail('extension Apple absente de l\'intermédiaire');
            }
            if (!array_key_exists(self::OID_LEAF, $leafInfo['extensions'] ?? [])) {
                return self::fail('extension Apple absente de la feuille');
            }

            $leafKey = openssl_pkey_get_public($leaf);
            if (!$leafKey) return self::fail('clé publique de la feuille illisible');
            $details = openssl_pkey_get_details($leafKey);

            // Signature du JWS (lève une exception si invalide)
            $payload = JWT::decode($jws, new Key($details['key'], 'ES256'));

            // Validité des certificats à la date de signature
            $signedAt = isset($payload->signedDate) ? intdiv((int)$payload->signedDate, 1000) : time();
            foreach (['feuille' => $leafInfo, 'intermédiaire' => $interInfo] as $name => $info) {
                if ($signedAt < ($info['validFrom_time_t'] ?? PHP_INT_MAX)
                    || $signedAt > ($info['validTo_time_t'] ?? 0)) {
                    return self::fail("certificat $name non valide à la date de signature");
                }
            }

            return $payload;
        } catch (\Throwable $e) {
            return self::fail('signature invalide : ' . $e->getMessage());
        }
    }

    private static function fail(string $reason): ?object {
        self::$lastError = $reason;
        return null;
    }

    private static function b64url(string $s): string {
        return base64_decode(strtr($s, '-_', '+/') . str_repeat('=', (4 - strlen($s) % 4) % 4));
    }

    private static function pem(string $b64Der): string {
        return "-----BEGIN CERTIFICATE-----\n" . chunk_split($b64Der, 64, "\n") . "-----END CERTIFICATE-----\n";
    }
}
