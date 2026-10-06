<?php
// Achats et abonnements : vérification App Store / Google Play, webhooks,
// VIP manuels, cron d'expiration. Lancer par tests/run.sh.
require __DIR__ . '/bootstrap.php';

use Firebase\JWT\JWT;
use NfcAnycubic\Controllers\AppleServerNotificationController;
use NfcAnycubic\Controllers\GooglePlayWebhookController;
use NfcAnycubic\Controllers\SubscriptionController;
use NfcAnycubic\Database;
use NfcAnycubic\JWTHandler;
use NfcAnycubic\Services\AppleJWSVerifier;
use NfcAnycubic\Services\GooglePlayApiClient;
use NfcAnycubic\Services\PremiumService;

$db = Database::getInstance()->getConnection();
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// ---------- chaîne de test Apple ----------
$pemBody = fn($f) => preg_replace('/-----[^-]+-----|\s+/', '', file_get_contents("$JWS/$f"));
$x5c = [$pemBody('leaf.pem'), $pemBody('inter.pem'), $pemBody('root.pem')];
$leafKey = file_get_contents("$JWS/leaf.key.pem");
AppleJWSVerifier::$trustedRoot = hash('sha256', base64_decode($x5c[2]));
// Chaîne « pirate » : clé auto-signée
$evil = openssl_pkey_new(['private_key_type' => OPENSSL_KEYTYPE_EC, 'curve_name' => 'prime256v1']);
openssl_pkey_export($evil, $evilPem);
$csr = openssl_csr_new(['CN' => 'Apple Inc.', 'O' => 'Apple Inc.'], $evil, ['digest_alg' => 'sha256']);
$evilCert = openssl_csr_sign($csr, null, $evil, 30, ['digest_alg' => 'sha256']);
openssl_x509_export($evilCert, $evilCertPem);
$evilX5c = [preg_replace('/-----[^-]+-----|\s+/', '', $evilCertPem), $x5c[1], preg_replace('/-----[^-]+-----|\s+/', '', $evilCertPem)];

function signApple(array $payload, bool $evil = false): string {
    global $x5c, $leafKey, $evilX5c, $evilPem;
    return JWT::encode($payload, $evil ? $evilPem : $leafKey, 'ES256', null, ['x5c' => $evil ? $evilX5c : $x5c]);
}
$BUNDLE = 'com.engageengine.nfcfilament';
$ms = fn(int $deltaSec) => (time() + $deltaSec) * 1000;
function appleTx(string $otid, string $tid, int $purchaseMs, int $expiresMs, array $extra = []): array {
    global $BUNDLE;
    return array_merge([
        'transactionId' => $tid, 'originalTransactionId' => $otid, 'bundleId' => $BUNDLE,
        'productId' => 'spool_master_monthly', 'purchaseDate' => $purchaseMs, 'expiresDate' => $expiresMs,
        'environment' => 'Sandbox', 'signedDate' => time() * 1000, 'type' => 'Auto-Renewable Subscription',
    ], $extra);
}

// ---------- utilisateurs ----------
$users = ['t-sub-1', 't-sub-2', 't-sub-3', 't-vip-4', 't-cache-5', 't-mig-a', 't-mig-b', 't-mig-c', 't-and-6', 't-grace-7'];
$in = "'" . implode("','", $users) . "'";
$db->exec("DELETE FROM subscription_events WHERE user_id IN ($in)");
$db->exec("DELETE FROM subscriptions WHERE user_id IN ($in) OR original_transaction_id LIKE 'T-%' OR original_transaction_id LIKE 'gp_%'");
$db->exec("DELETE FROM apple_notifications WHERE notification_uuid LIKE 'test-%'");
$db->exec("DELETE FROM user_preferences WHERE user_id IN ($in)");
$db->exec("DELETE FROM users WHERE user_id IN ($in)");
$ins = $db->prepare("INSERT INTO users (user_id, email, provider, provider_id, name) VALUES (?, ?, 'apple', ?, 'Test')");
foreach ($users as $u) $ins->execute([$u, "$u@test.local", "p-$u"]);

$jwtH = new JWTHandler();
function asUser(string $u): void {
    global $jwtH;
    $_SERVER['HTTP_AUTHORIZATION'] = 'Bearer ' . $jwtH->generateToken(['user_id' => $u, 'email' => "$u@test.local", 'provider' => 'apple']);
    $_SERVER['REMOTE_ADDR'] = '10.' . random_int(0, 255) . '.' . random_int(0, 255) . '.' . random_int(1, 254);
}
function verify(string $u, array $body): array {
    asUser($u);
    http_response_code(200);
    $r = withInput(json_encode($body), fn() => (new SubscriptionController())->verifyPurchase([]));
    $r['_http'] = http_response_code();
    return $r;
}
function status(string $u): array {
    asUser($u);
    return (new SubscriptionController())->getSubscriptionStatus([]);
}
function row(string $otid): ?array {
    global $db;
    $s = $db->prepare("SELECT *, UNIX_TIMESTAMP(expires_date) e_ts FROM subscriptions WHERE original_transaction_id = ?");
    $s->execute([$otid]);
    return $s->fetch(PDO::FETCH_ASSOC) ?: null;
}

echo "\n== iOS : /subscriptions/verify ==\n";
$jws1 = signApple(appleTx('T-100', 'T-100-a', $ms(-3600), $ms(30 * 86400)));
$r = verify('t-sub-1', ['signedTransaction' => $jws1, 'productId' => 'spool_master_monthly', 'platform' => 'ios']);
check('JWS Apple valide → premium', ($r['success'] ?? false) && ($r['subscription']['is_premium'] ?? false), $r);
$row = row('T-100');
check('ligne créée, platform ios, active', $row && $row['platform'] === 'ios' && $row['status'] === 'active' && $row['user_id'] === 't-sub-1', $row);
$st = status('t-sub-1');
check('status : premium, type subscription', $st['is_premium'] === true && $st['subscription']['type'] === 'subscription', $st);
$exp = $st['subscription']['expires_date'];
check('échéance en ISO 8601 UTC, même instant qu\'en base', (bool)preg_match('/^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\dZ$/', $exp) && strtotime($exp) === (int)row('T-100')['e_ts'], [$exp, row('T-100')['e_ts']]);

$r = verify('t-sub-3', ['signedTransaction' => signApple(appleTx('T-300', 'T-300-a', $ms(-60), $ms(86400 * 365)), true), 'platform' => 'ios']);
check('C1 : JWS auto-signé (« Apple Inc. ») refusé 400', $r['_http'] === 400 && !($r['success'] ?? true), $r);
check('C1 : aucun premium ni ligne', status('t-sub-3')['is_premium'] === false && row('T-300') === null);

$r = verify('t-sub-3', ['signedTransaction' => signApple(appleTx('T-301', 'T-301-a', $ms(-60), $ms(86400), ['bundleId' => 'com.other.app'])), 'platform' => 'ios']);
check('bundle ID étranger refusé', $r['_http'] === 400, $r);
$r = verify('t-sub-3', ['signedTransaction' => signApple(appleTx('T-302', 'T-302-a', $ms(-60), $ms(86400), ['productId' => 'other.product'])), 'productId' => 'spool_master_yearly', 'platform' => 'ios']);
check('Sandbox : le productId de la requête ne remplace plus celui signé', $r['_http'] === 400, $r);

echo "\n== M1 : Restaurer depuis un 2e compte ==\n";
$r = verify('t-sub-2', ['signedTransaction' => $jws1, 'platform' => 'ios']);
check('pas de 500, succès + premium sur le compte 2', ($r['success'] ?? false) && $r['subscription']['is_premium'] === true, $r);
check('abonnement transféré au compte 2', row('T-100')['user_id'] === 't-sub-2');
check('compte 1 n\'est plus premium', status('t-sub-1')['is_premium'] === false);
$ev = $db->query("SELECT COUNT(*) FROM subscription_events WHERE user_id='t-sub-2' AND event_type='subscription_transferred'")->fetchColumn();
check('événement subscription_transferred journalisé', (int)$ev === 1);

echo "\n== Transaction plus ancienne / révocation (H4) ==\n";
$jwsNew = signApple(appleTx('T-100', 'T-100-b', $ms(-60), $ms(60 * 86400)));
verify('t-sub-2', ['signedTransaction' => $jwsNew, 'platform' => 'ios']);
$e1 = (int)row('T-100')['e_ts'];
verify('t-sub-2', ['signedTransaction' => $jws1, 'platform' => 'ios']);
check('ancienne transaction ne fait pas reculer l\'échéance', (int)row('T-100')['e_ts'] === $e1 && row('T-100')['transaction_id'] === 'T-100-b', row('T-100'));
// Remboursement (comme le webhook REFUND)
$db->exec("UPDATE subscriptions SET status='revoked', revocation_date=NOW() WHERE original_transaction_id='T-100'");
PremiumService::refresh($db, 't-sub-2');
$r = verify('t-sub-2', ['signedTransaction' => $jwsNew, 'platform' => 'ios']);
check('H4 : JWS rejoué après remboursement → pas de premium', $r['subscription']['is_premium'] === false && row('T-100')['status'] === 'revoked', [$r, row('T-100')['status']]);
$fail = $db->query("SELECT COUNT(*) FROM subscription_validation_failures WHERE user_id='t-sub-2' AND failure_reason='replay_attack'")->fetchColumn();
check('H4 : tentative journalisée (replay_attack)', (int)$fail >= 1);
sleep(1);
$jwsResub = signApple(appleTx('T-100', 'T-100-c', $ms(1), $ms(30 * 86400 + 5)));
$r = verify('t-sub-2', ['signedTransaction' => $jwsResub, 'platform' => 'ios']);
check('réabonnement postérieur à la révocation → actif', $r['subscription']['is_premium'] === true && row('T-100')['status'] === 'active' && row('T-100')['revocation_date'] === null, row('T-100'));
$r = verify('t-sub-2', ['signedTransaction' => signApple(appleTx('T-100', 'T-100-c', $ms(1), $ms(30 * 86400 + 5), ['revocationDate' => $ms(0)])), 'platform' => 'ios']);
check('transaction signée avec revocationDate → revoked', row('T-100')['status'] === 'revoked' && $r['subscription']['is_premium'] === false, row('T-100'));

echo "\n== Période de grâce (M7) ==\n";
$db->exec("INSERT INTO subscriptions (user_id, original_transaction_id, transaction_id, product_id, platform, status, purchase_date, expires_date, grace_period_expires_date, environment)
           VALUES ('t-grace-7', 'T-700', 'T-700-a', 'spool_master_monthly', 'ios', 'grace_period', NOW() - INTERVAL 31 DAY, NOW() - INTERVAL 1 DAY, NOW() + INTERVAL 5 DAY, 'Sandbox')");
check('grâce en cours → premium (avant : échéance passée = refusé)', status('t-grace-7')['is_premium'] === true);
$r = verify('t-grace-7', ['signedTransaction' => signApple(appleTx('T-700', 'T-700-a', $ms(-31 * 86400), $ms(-86400))), 'platform' => 'ios']);
check('Restaurer pendant la grâce ne casse pas la grâce', row('T-700')['status'] === 'grace_period' && $r['subscription']['is_premium'] === true, [$r, row('T-700')['status']]);

echo "\n== VIP manuel (H2) et cron ==\n";
$db->exec("INSERT INTO user_preferences (user_id, is_vip, vip_expires_at, vip_manual, subscription_type) VALUES ('t-vip-4', 1, '2028-07-02 23:59:59', 1, 'yearly')");
$db->exec("INSERT INTO subscriptions (user_id, original_transaction_id, transaction_id, product_id, platform, status, purchase_date, expires_date, environment)
           VALUES ('t-vip-4', 'T-400', 'T-400-a', 'spool_master_yearly', 'ios', 'active', NOW() - INTERVAL 400 DAY, NOW() - INTERVAL 2 DAY, 'Production')");
$db->exec("INSERT INTO user_preferences (user_id, is_vip, vip_expires_at, vip_manual) VALUES ('t-cache-5', 1, NOW() + INTERVAL 10 DAY, 0)");
$db->exec("UPDATE subscriptions SET status='grace_period', expires_date = NOW() - INTERVAL 40 DAY, grace_period_expires_date = NOW() - INTERVAL 1 DAY WHERE original_transaction_id='T-999'");
$db->exec("INSERT INTO subscriptions (user_id, original_transaction_id, transaction_id, product_id, platform, status, purchase_date, expires_date, grace_period_expires_date, environment)
           VALUES ('t-sub-3', 'T-301g', 'x', 'spool_master_monthly', 'ios', 'grace_period', NOW() - INTERVAL 40 DAY, NOW() - INTERVAL 10 DAY, NOW() - INTERVAL 1 DAY, 'Sandbox')");
$cron = (new SubscriptionController())->checkExpiredSubscriptions();
check('cron : succès', $cron['success'] === true, $cron);
$vip = $db->query("SELECT is_vip, vip_manual, vip_expires_at FROM user_preferences WHERE user_id='t-vip-4'")->fetch(PDO::FETCH_ASSOC);
check('cron : VIP manuel 2028 intact (abonnement échu)', (int)$vip['is_vip'] === 1 && (int)$vip['vip_manual'] === 1 && $vip['vip_expires_at'] === '2028-07-02 23:59:59', $vip);
check('cron : abonnement échu du VIP passé expired', row('T-400')['status'] === 'expired');
check('VIP manuel : status premium type vip', status('t-vip-4')['subscription']['type'] === 'vip');
$vexp = status('t-vip-4')['subscription']['expires_date'];
check('VIP manuel : échéance en UTC', strtotime($vexp) === (int)$db->query("SELECT UNIX_TIMESTAMP('2028-07-02 23:59:59')")->fetchColumn(), $vexp);
$c5 = $db->query("SELECT is_vip FROM user_preferences WHERE user_id='t-cache-5'")->fetchColumn();
check('cron : cache premium sans abonnement remis à 0', (int)$c5 === 0);
check('cron : grâce terminée → expired', row('T-301g')['status'] === 'expired');
check('cron : grâce en cours conservée', row('T-700')['status'] === 'grace_period' && status('t-grace-7')['is_premium'] === true);

// VIP manuel échu + abonnement actif → l'abonnement prend le relais
$db->exec("UPDATE user_preferences SET vip_expires_at = NOW() - INTERVAL 1 DAY WHERE user_id='t-vip-4'");
$db->exec("UPDATE subscriptions SET status='active', expires_date = NOW() + INTERVAL 20 DAY WHERE original_transaction_id='T-400'");
check('VIP manuel échu + abonnement actif → premium', PremiumService::refresh($db, 't-vip-4') === true);
$vip = $db->query("SELECT is_vip, vip_manual FROM user_preferences WHERE user_id='t-vip-4'")->fetch(PDO::FETCH_ASSOC);
check('… et le cache passe en non manuel', (int)$vip['vip_manual'] === 0 && (int)$vip['is_vip'] === 1, $vip);
$db->exec("UPDATE user_preferences SET vip_manual=1, vip_expires_at='2028-07-02 23:59:59', is_vip=1 WHERE user_id='t-vip-4'");

echo "\n== Migration 008 : reprise des VIP existants ==\n";
$db->exec("INSERT INTO user_preferences (user_id, is_vip, vip_expires_at, vip_manual) VALUES
           ('t-mig-a', 1, '2028-07-02 23:59:59', 0), ('t-mig-b', 1, '2027-03-01 10:00:00', 0), ('t-mig-c', 1, NULL, 0)");
$db->exec("INSERT INTO subscriptions (user_id, original_transaction_id, transaction_id, product_id, platform, status, purchase_date, expires_date, environment) VALUES
           ('t-mig-a', 'T-MA', 'x', 'spool_master_yearly', 'ios', 'active', NOW(), '2027-07-02 10:00:00', 'Production'),
           ('t-mig-b', 'T-MB', 'x', 'spool_master_yearly', 'ios', 'active', NOW(), '2027-03-01 08:00:00', 'Production')");
$mig = file_get_contents($BK . '/database/migrations/008_manual_vip.sql');
preg_match('/UPDATE user_preferences up.*?;\s*$/ms', $mig, $m);
$db->exec($m[0]);
$flags = $db->query("SELECT user_id, vip_manual FROM user_preferences WHERE user_id LIKE 't-mig-%' ORDER BY user_id")->fetchAll(PDO::FETCH_KEY_PAIR);
check('VIP 2028 avec abonnement 2027 → manuel', (int)$flags['t-mig-a'] === 1, $flags);
check('cache = échéance de l\'abonnement (±2 h) → non manuel', (int)$flags['t-mig-b'] === 0, $flags);
check('VIP à vie sans abonnement → manuel', (int)$flags['t-mig-c'] === 1, $flags);

echo "\n== Webhook App Store (C2, M6, H4) ==\n";
function notify(array $payload, bool $evilOuter = false): array {
    http_response_code(200);
    $body = json_encode(['signedPayload' => signApple($payload, $evilOuter)]);
    $r = withInput($body, fn() => (new AppleServerNotificationController())->handleNotification([]));
    $r['_http'] = http_response_code();
    return $r;
}
$db->exec("UPDATE subscriptions SET status='active', expires_date = NOW() + INTERVAL 3 DAY, revocation_date=NULL, last_notification_date=NULL WHERE original_transaction_id='T-100'");
PremiumService::refresh($db, 't-sub-2');
$renewTx = signApple(appleTx('T-100', 'T-100-d', $ms(-10), $ms(33 * 86400)));
$t0 = time() * 1000;
$r = notify(['notificationType' => 'DID_RENEW', 'notificationUUID' => 'test-n1', 'signedDate' => $t0,
             'data' => ['bundleId' => $BUNDLE, 'signedTransactionInfo' => $renewTx]]);
check('DID_RENEW signé → échéance prolongée', ($r['processed'] ?? '') === 'renewed' && (int)row('T-100')['e_ts'] > time() + 32 * 86400, [$r, row('T-100')]);
$r = notify(['notificationType' => 'DID_RENEW', 'notificationUUID' => 'test-n1', 'signedDate' => $t0,
             'data' => ['bundleId' => $BUNDLE, 'signedTransactionInfo' => $renewTx]]);
check('même notification rejouée → déjà traitée', ($r['message'] ?? '') === 'Already processed', $r);
$r = notify(['notificationType' => 'REFUND', 'notificationUUID' => 'test-n2', 'signedDate' => $t0,
             'data' => ['bundleId' => $BUNDLE, 'signedTransactionInfo' => signApple(appleTx('T-100', 'T-100-d', $ms(-10), $ms(33 * 86400)))]], true);
check('C2 : notification forgée (chaîne non Apple) → 401', $r['_http'] === 401 && row('T-100')['status'] === 'active', $r);
$r = notify(['notificationType' => 'REFUND', 'notificationUUID' => 'test-n3', 'signedDate' => $t0 + 1000,
             'data' => ['bundleId' => $BUNDLE, 'signedTransactionInfo' => signApple(appleTx('T-100', 'T-100-d', $ms(-10), $ms(33 * 86400)), true)]]);
check('C2 : enveloppe valide mais transaction interne forgée → ignorée', ($r['processed'] ?? '') === 'no_transaction_info' && row('T-100')['status'] === 'active', [$r, row('T-100')['status']]);
$r = notify(['notificationType' => 'EXPIRED', 'subtype' => 'VOLUNTARY', 'notificationUUID' => 'test-n4', 'signedDate' => $t0 - 30 * 1000,
             'data' => ['bundleId' => $BUNDLE, 'signedTransactionInfo' => signApple(appleTx('T-100', 'T-100-a', $ms(-40 * 86400), $ms(-3600)))]]);
check('M6 : notification plus ancienne que la dernière → ignorée', ($r['processed'] ?? '') === 'out_of_order_ignored' && row('T-100')['status'] === 'active', [$r, row('T-100')['status']]);
$refundAt = $ms(-5);
$r = notify(['notificationType' => 'REFUND', 'notificationUUID' => 'test-n5', 'signedDate' => $t0 + 2000,
             'data' => ['bundleId' => $BUNDLE, 'signedTransactionInfo' => signApple(appleTx('T-100', 'T-100-d', $ms(-10), $ms(33 * 86400), ['revocationDate' => $refundAt]))]]);
$revTs = (int)$db->query("SELECT UNIX_TIMESTAMP(revocation_date) FROM subscriptions WHERE original_transaction_id='T-100'")->fetchColumn();
check('REFUND → revoked, date de révocation d\'Apple', row('T-100')['status'] === 'revoked' && $revTs === intdiv($refundAt, 1000), [$revTs, intdiv($refundAt, 1000)]);
check('REFUND → plus premium', status('t-sub-2')['is_premium'] === false);
$r = verify('t-sub-2', ['signedTransaction' => $renewTx, 'platform' => 'ios']);
check('H4 : JWS de renouvellement rejoué après REFUND → refusé', $r['subscription']['is_premium'] === false && row('T-100')['status'] === 'revoked', [$r, row('T-100')['status']]);
// Grâce Apple
$db->exec("UPDATE subscriptions SET status='active', revocation_date=NULL, expires_date = NOW() - INTERVAL 1 HOUR WHERE original_transaction_id='T-100'");
$renewal = signApple(['originalTransactionId' => 'T-100', 'autoRenewStatus' => 1, 'gracePeriodExpiresDate' => $ms(6 * 86400), 'signedDate' => $t0]);
$r = notify(['notificationType' => 'DID_FAIL_TO_RENEW', 'subtype' => 'GRACE_PERIOD', 'notificationUUID' => 'test-n6', 'signedDate' => $t0 + 3000,
             'data' => ['bundleId' => $BUNDLE, 'signedTransactionInfo' => signApple(appleTx('T-100', 'T-100-d', $ms(-30 * 86400), $ms(-3600))), 'signedRenewalInfo' => $renewal]]);
check('DID_FAIL_TO_RENEW (grâce) → premium conservé', row('T-100')['status'] === 'grace_period' && status('t-sub-2')['is_premium'] === true, [$r, row('T-100')]);
// VIP manuel + EXPIRED webhook
$r = notify(['notificationType' => 'EXPIRED', 'subtype' => 'VOLUNTARY', 'notificationUUID' => 'test-n7', 'signedDate' => $t0 + 4000,
             'data' => ['bundleId' => $BUNDLE, 'signedTransactionInfo' => signApple(appleTx('T-400', 'T-400-a', $ms(-400 * 86400), $ms(-86400)))]]);
$vip = $db->query("SELECT is_vip, vip_manual, vip_expires_at FROM user_preferences WHERE user_id='t-vip-4'")->fetch(PDO::FETCH_ASSOC);
check('H2 : webhook EXPIRED ne touche pas le VIP manuel', (int)$vip['is_vip'] === 1 && $vip['vip_expires_at'] === '2028-07-02 23:59:59' && status('t-vip-4')['is_premium'] === true, $vip);

echo "\n== Google Play (H1, H3, B5, acquittement) ==\n";
class FakeGoogle extends GooglePlayApiClient {
    public array $responses = [];
    public array $calls = [];
    public array $acks = [];
    public function __construct() {}
    public function isConfigured(): bool { return true; }
    public function getSubscription(string $productId, string $purchaseToken): array {
        $this->calls[] = [$productId, $purchaseToken];
        return $this->responses[$purchaseToken] ?? ['status' => 404, 'data' => null];
    }
    public function acknowledge(string $productId, string $purchaseToken): bool { $this->acks[] = $purchaseToken; return true; }
}
$fake = new FakeGoogle();
GooglePlayApiClient::$factory = fn() => $fake;
$tok = 'tok/with?odd&chars=' . bin2hex(random_bytes(6));
$gp = SubscriptionController::googleOriginalId($tok);
$fake->responses[$tok] = ['status' => 200, 'data' => ['expiryTimeMillis' => (string)$ms(30 * 86400), 'startTimeMillis' => (string)$ms(-60),
    'orderId' => 'GPA.1', 'autoRenewing' => true, 'acknowledgementState' => 0, 'paymentState' => 1, 'purchaseType' => 0]];
$r = verify('t-and-6', ['signedTransaction' => $tok, 'productId' => 'spool_master_monthly', 'platform' => 'android']);
check('achat Android vérifié → premium', $r['subscription']['is_premium'] === true, $r);
check('ligne android, Sandbox (achat test)', row($gp)['platform'] === 'android' && row($gp)['environment'] === 'Sandbox', row($gp));
check('(1) acquittement serveur si l\'app n\'a pas acquitté', in_array($tok, $fake->acks, true));
$fake->responses['tok-down'] = ['status' => 503, 'data' => null];
$r = verify('t-and-6', ['signedTransaction' => 'tok-down', 'productId' => 'spool_master_monthly', 'platform' => 'android']);
check('API Google indisponible → 503 (passager, l\'app réessaie)', $r['_http'] === 503, $r);
$r = verify('t-and-6', ['signedTransaction' => 'tok-bad', 'productId' => 'spool_master_monthly', 'platform' => 'android']);
check('jeton inconnu de Google → 400', $r['_http'] === 400, $r);

// Push Pub/Sub authentifié (jeton OIDC simulé : la vérification réelle
// passe par Google)
$OIDC_OK = ['iss' => 'https://accounts.google.com', 'aud' => 'https://api.test/webhooks/google-play',
            'email' => 'rtdn@test.iam.gserviceaccount.com', 'email_verified' => 'true', 'exp' => (string)(time() + 600)];
GooglePlayWebhookController::$tokenVerifier = fn(string $t) => $t === 'valid-oidc' ? $OIDC_OK : null;
function rtdn(array $msg, ?string $bearer = 'valid-oidc'): array {
    if ($bearer === null) unset($_SERVER['HTTP_AUTHORIZATION']); else $_SERVER['HTTP_AUTHORIZATION'] = "Bearer $bearer";
    http_response_code(200);
    $body = json_encode(['message' => ['data' => base64_encode(json_encode($msg)), 'messageId' => '1'], 'subscription' => 'x']);
    $r = withInput($body, fn() => (new GooglePlayWebhookController())->handleNotification([]));
    $r['_http'] = http_response_code();
    return $r;
}
$PKG = 'com.engagengine.nfc_anycubic';
$fake->responses[$tok]['data']['expiryTimeMillis'] = (string)$ms(60 * 86400);
$fake->responses[$tok]['data']['acknowledgementState'] = 1;
$r = rtdn(['packageName' => $PKG, 'subscriptionNotification' => ['notificationType' => 2, 'purchaseToken' => $tok, 'subscriptionId' => 'spool_master_monthly']]);
check('H1 : RENEWED → échéance relue chez Google (+60 j)', (int)row($gp)['e_ts'] > time() + 59 * 86400 && $r['status'] === 'active', [$r, row($gp)]);
$before = count($fake->calls);
$r = rtdn(['packageName' => $PKG, 'subscriptionNotification' => ['notificationType' => 4, 'purchaseToken' => 'forged-token', 'subscriptionId' => 'spool_master_yearly']]);
check('H3 : jeton inconnu → ignoré sans appel API', count($fake->calls) === $before && ($r['message'] ?? '') === 'Unknown purchase token', $r);
$fake->responses[$tok]['data']['autoRenewing'] = false;
$r = rtdn(['packageName' => $PKG, 'subscriptionNotification' => ['notificationType' => 3, 'purchaseToken' => $tok, 'subscriptionId' => 'spool_master_monthly']]);
check('CANCELED → renouvellement coupé, accès jusqu\'à l\'échéance', (int)row($gp)['auto_renew_enabled'] === 0 && row($gp)['status'] === 'active' && status('t-and-6')['is_premium'] === true, row($gp));
check('status : auto_renew_enabled = false exposé', status('t-and-6')['subscription']['auto_renew_enabled'] === false);
$fake->responses[$tok] = ['status' => 503, 'data' => null];
$r = rtdn(['packageName' => $PKG, 'subscriptionNotification' => ['notificationType' => 13, 'purchaseToken' => $tok, 'subscriptionId' => 'spool_master_monthly']]);
check('API Google en panne → 503 (Pub/Sub renverra) et rien ne change', $r['_http'] === 503 && row($gp)['status'] === 'active', $r);
$fake->responses[$tok] = ['status' => 200, 'data' => ['expiryTimeMillis' => (string)$ms(-60), 'autoRenewing' => false, 'acknowledgementState' => 1]];
$r = rtdn(['packageName' => $PKG, 'subscriptionNotification' => ['notificationType' => 5, 'purchaseToken' => $tok, 'subscriptionId' => 'spool_master_monthly']]);
check('ON_HOLD (échéance passée) → expired, plus premium', row($gp)['status'] === 'expired' && status('t-and-6')['is_premium'] === false, [$r, row($gp)]);
$fake->responses[$tok] = ['status' => 200, 'data' => ['expiryTimeMillis' => (string)$ms(20 * 86400), 'autoRenewing' => true, 'acknowledgementState' => 1]];
rtdn(['packageName' => $PKG, 'subscriptionNotification' => ['notificationType' => 1, 'purchaseToken' => $tok, 'subscriptionId' => 'spool_master_monthly']]);
check('RECOVERED → actif de nouveau', row($gp)['status'] === 'active' && status('t-and-6')['is_premium'] === true);
// Le type de notification ne décide plus : seul l'état relu chez Google compte
// (avant : un message forgé « révoqué » coupait l'abonnement pour toujours).
$r = rtdn(['packageName' => $PKG, 'subscriptionNotification' => ['notificationType' => 12, 'purchaseToken' => $tok, 'subscriptionId' => 'spool_master_monthly']]);
check('REVOKED forgé, Google dit actif → reste actif et premium', row($gp)['status'] === 'active' && status('t-and-6')['is_premium'] === true, [$r, row($gp)]);
$r = rtdn(['packageName' => $PKG, 'voidedPurchaseNotification' => ['purchaseToken' => $tok, 'orderId' => 'GPA.1', 'productType' => 1]]);
check('remboursement forgé, Google dit actif → reste actif', row($gp)['status'] === 'active', [$r, row($gp)]);
$fake->responses[$tok] = ['status' => 200, 'data' => ['expiryTimeMillis' => (string)$ms(-5), 'autoRenewing' => false, 'acknowledgementState' => 1]];
$r = rtdn(['packageName' => $PKG, 'voidedPurchaseNotification' => ['purchaseToken' => $tok, 'orderId' => 'GPA.1', 'productType' => 1]]);
check('vrai remboursement (échéance passée chez Google) → plus premium', row($gp)['status'] === 'expired' && status('t-and-6')['is_premium'] === false, [$r, row($gp)]);

echo "\n== Webhook Google : authentification du push (OIDC) ==\n";
$before = count($fake->calls);
$msg = ['packageName' => $PKG, 'subscriptionNotification' => ['notificationType' => 2, 'purchaseToken' => $tok, 'subscriptionId' => 'spool_master_monthly']];
$r = rtdn($msg, null);
check('sans jeton → 401, aucun appel à Google', $r['_http'] === 401 && count($fake->calls) === $before, $r);
$r = rtdn($msg, 'forged');
check('jeton invalide → 401', $r['_http'] === 401 && count($fake->calls) === $before, $r);
foreach (['aud' => 'https://evil.example', 'email' => 'evil@attacker.iam.gserviceaccount.com', 'email_verified' => 'false', 'exp' => (string)(time() - 5), 'iss' => 'https://evil.example'] as $k => $v) {
    GooglePlayWebhookController::$tokenVerifier = fn(string $t) => array_merge($OIDC_OK, [$k => $v]);
    $r = rtdn($msg);
    check("revendication $k fausse → 401", $r['_http'] === 401, $r);
}
GooglePlayWebhookController::$tokenVerifier = fn(string $t) => $t === 'valid-oidc' ? $OIDC_OK : null;
$r = rtdn(['packageName' => 'com.evil', 'subscriptionNotification' => ['notificationType' => 12, 'purchaseToken' => $tok]]);
check('autre package ignoré', ($r['message'] ?? '') === 'Other package ignored');

$url = (new ReflectionMethod(GooglePlayApiClient::class, 'subscriptionUrl'));
$url->setAccessible(true);
$u = $url->invoke(new GooglePlayApiClient('/nonexistent'), 'spool_master_monthly', 'a/b?c&d=e');
check('B5 : jeton encodé dans l\'URL', str_ends_with($u, '/tokens/a%2Fb%3Fc%26d%3De'), $u);

finish();
