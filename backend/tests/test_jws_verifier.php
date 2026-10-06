<?php
// Vérification des signatures App Store (AppleJWSVerifier) : chaîne x5c,
// racine épinglée, extensions Apple, algorithme. Lancer par tests/run.sh.
// Vraies transactions (facultatif, jamais versionnées) : APPLE_REAL_JWS_TSV.
require __DIR__ . '/bootstrap.php';

use Firebase\JWT\JWT;
use NfcAnycubic\Services\AppleJWSVerifier as V;

$der = fn(string $f) => base64_encode(base64_decode(preg_replace('/-----[^-]+-----|\s/', '', file_get_contents("$JWS/$f"))));
$leafKey = file_get_contents("$JWS/leaf.key.pem");
$fullChain = [$der('leaf.pem'), $der('inter.pem'), $der('root.pem')];
$testRoot = hash('sha256', base64_decode($der('root.pem')));

echo "== Vraies transactions App Store ==\n";
$tsv = (string)getenv('APPLE_REAL_JWS_TSV');
if ($tsv !== '' && is_file($tsv)) {
    $real = array_map(fn($l) => explode("\t", trim($l))[1], array_filter(file($tsv)));
    foreach ($real as $i => $jws) {
        $p = V::verify($jws);
        check('vraie transaction #' . ($i + 1) . ' acceptée', $p !== null && $p->bundleId === 'com.engageengine.nfcfilament', V::$lastError);
    }
    [$h, $pl, $s] = explode('.', $real[0]);
    $d = json_decode(base64_decode(strtr($pl, '-_', '+/')), true);
    $d['expiresDate'] = 4102444800000;
    check('payload modifié (expiration 2100) refusé', V::verify("$h." . rtrim(strtr(base64_encode(json_encode($d)), '+/', '-_'), '=') . ".$s") === null);
} else {
    echo "  (sautées : APPLE_REAL_JWS_TSV non fourni)\n";
}

echo "\n== Chaînes forgées ==\n";
$fake = JWT::encode(['bundleId' => 'com.engageengine.nfcfilament', 'productId' => 'spool_master_yearly', 'expiresDate' => 4102444800000, 'signedDate' => time() * 1000],
    $leafKey, 'ES256', null, ['x5c' => $fullChain]);
check('chaîne « Apple Inc. » non épinglée refusée', V::verify($fake) === null, V::$lastError);
$one = JWT::encode(['bundleId' => 'com.engageengine.nfcfilament'], $leafKey, 'ES256', null, ['x5c' => [$der('leaf.pem')]]);
check('x5c à 1 certificat refusé', V::verify($one) === null);
check('chaîne de test complète acceptée avec la racine de test épinglée', V::verify($fake, $testRoot) !== null, V::$lastError);
$noOid = JWT::encode(['bundleId' => 'x', 'signedDate' => time() * 1000], $leafKey, 'ES256', null, ['x5c' => [$der('leafnooid.pem'), $der('inter.pem'), $der('root.pem')]]);
check('feuille sans extension Apple refusée', V::verify($noOid, $testRoot) === null);
$swap = JWT::encode(['bundleId' => 'x', 'signedDate' => time() * 1000], $leafKey, 'ES256', null, ['x5c' => [$der('leaf.pem'), $der('root.pem'), $der('root.pem')]]);
check("feuille non signée par l'intermédiaire refusée", V::verify($swap, $testRoot) === null);
$hs = JWT::encode(['bundleId' => 'x'], str_repeat('s', 64), 'HS256', null, ['x5c' => $fullChain]);
check('algorithme HS256 refusé', V::verify($hs) === null);
finish();
