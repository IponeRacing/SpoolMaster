<?php
// Correctifs du 06.10.2026 (audit backend) : chiffrement du jeton Apple,
// purge et rétention (politique de confidentialité §7), préférence
// analytics_enabled, secret admin distinct, webhook Google non configuré.
// Lancer par tests/run.sh.
require __DIR__ . '/bootstrap.php';

use NfcAnycubic\Controllers\AnalyticsController;
use NfcAnycubic\Controllers\GooglePlayWebhookController;
use NfcAnycubic\Controllers\ReportController;
use NfcAnycubic\Database;
use NfcAnycubic\JWTHandler;
use NfcAnycubic\Services\AccountPurgeService;
use NfcAnycubic\Services\AppleSignInService;
use NfcAnycubic\Services\RetentionService;
use NfcAnycubic\Services\TokenCipher;

$db = Database::getInstance()->getConnection();
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$users = ['t-priv-1', 't-priv-2', 't-priv-3', 't-priv-4'];
$in = "'" . implode("','", $users) . "'";
foreach (['analytics', 'audit_logs', 'subscription_events', 'apple_notifications', 'subscription_validation_failures', 'sync_history', 'user_preferences'] as $t) {
    $db->exec("DELETE FROM $t WHERE user_id IN ($in, 't-gone-9')");
}
$db->exec("DELETE FROM audit_logs WHERE action LIKE 'test-%'");
$db->exec("DELETE FROM apple_notifications WHERE notification_uuid LIKE 'priv-%'");
$db->exec("DELETE FROM users WHERE user_id IN ($in)");
$ins = $db->prepare("INSERT INTO users (user_id, email, provider, provider_id) VALUES (?, ?, 'apple', ?)");
foreach ($users as $u) $ins->execute([$u, "$u@test.local", "p-$u"]);

echo "== Jeton Apple chiffré (TokenCipher) ==\n";
$enc = TokenCipher::encrypt('r.apple-refresh-token');
check('chiffré : préfixe enc:v1, jeton absent du texte stocké', str_starts_with($enc, 'enc:v1:') && !str_contains($enc, 'apple-refresh'));
check('déchiffrement → jeton d\'origine', TokenCipher::decrypt($enc) === 'r.apple-refresh-token');
check('deux chiffrements diffèrent (nonce aléatoire)', TokenCipher::encrypt('x') !== TokenCipher::encrypt('x'));
check('ancien jeton en clair rendu tel quel (migration)', TokenCipher::decrypt('plain-legacy') === 'plain-legacy');
$tampered = substr($enc, 0, -4) . (substr($enc, -4) === 'AAAA' ? 'BBBB' : 'AAAA');
check('valeur altérée → null (tag GCM)', TokenCipher::decrypt($tampered) === null);
TokenCipher::$key = str_repeat("\x01", 32);
check('mauvaise clé → null', TokenCipher::decrypt($enc) === null);
TokenCipher::$key = null;
$envKey = (string)getenv('APP_ENCRYPTION_KEY');
putenv('APP_ENCRYPTION_KEY=');
$threw = false;
try { TokenCipher::encrypt('x'); } catch (RuntimeException $e) { $threw = true; }
check('clé absente → exception, jamais de repli en clair', $threw);
putenv("APP_ENCRYPTION_KEY=$envKey");

echo "\n== Purge d'un compte : données gardées détachées ==\n";
class FakeAppleRevoke extends AppleSignInService {
    public array $revoked = [];
    public function __construct() {}
    public function revoke(string $refreshToken): bool { $this->revoked[] = $refreshToken; return true; }
}
$db->prepare("UPDATE users SET apple_refresh_token = ? WHERE user_id = 't-priv-1'")->execute([TokenCipher::encrypt('r.secret-1')]);
$db->exec("INSERT INTO audit_logs (user_id, action, ip_address, user_agent) VALUES ('t-priv-1', 'login', '198.51.100.7', 'App/1.0')");
$db->exec("INSERT INTO subscription_events (user_id, event_type, ip_address, user_agent) VALUES ('t-priv-1', 'purchase', '198.51.100.7', 'App/1.0')");
$db->exec("INSERT INTO apple_notifications (user_id, notification_type, notification_uuid, signed_payload) VALUES ('t-priv-1', 'DID_RENEW', 'priv-n1', 'x')");
$db->exec("INSERT INTO subscription_validation_failures (user_id, failure_reason, jws_payload, ip_address, user_agent) VALUES ('t-priv-1', 'other', 'jws', '198.51.100.7', 'App/1.0')");
$apple = new FakeAppleRevoke();
check('purge : compte supprimé', AccountPurgeService::purge($db, 't-priv-1', 'test', $apple) === true);
check('purge : jeton Apple DÉCHIFFRÉ envoyé à la révocation', $apple->revoked === ['r.secret-1'], $apple->revoked);
$q = fn(string $sql) => $db->query($sql)->fetchColumn();
check('audit_logs : plus d\'IP ni de user agent', (int)$q("SELECT COUNT(*) FROM audit_logs WHERE user_id='t-priv-1' AND (ip_address IS NOT NULL OR user_agent IS NOT NULL)") === 0);
check('audit_logs : preuve de suppression gardée', (int)$q("SELECT COUNT(*) FROM audit_logs WHERE user_id='t-priv-1' AND action='account_deleted'") === 1);
check('subscription_events : gardé sans user_id, IP ni UA', (int)$q("SELECT COUNT(*) FROM subscription_events WHERE event_type='purchase' AND user_id IS NULL AND ip_address IS NULL AND user_agent IS NULL") >= 1
    && (int)$q("SELECT COUNT(*) FROM subscription_events WHERE user_id='t-priv-1'") === 0);
check('apple_notifications : gardée sans user_id', $q("SELECT user_id FROM apple_notifications WHERE notification_uuid='priv-n1'") === null);
check('validation_failures : user_id, IP, UA et JWS effacés', (int)$q("SELECT COUNT(*) FROM subscription_validation_failures WHERE user_id='t-priv-1'") === 0
    && (int)$q("SELECT COUNT(*) FROM subscription_validation_failures WHERE jws_payload='jws'") === 0);

echo "\n== Rétention (90 jours) ==\n";
$db->exec("SET FOREIGN_KEY_CHECKS = 0"); // comptes « t-gone-9 » supprimés avant la purge explicite
$db->exec("INSERT INTO audit_logs (user_id, action, ip_address, created_at) VALUES
    ('t-priv-2', 'test-old-login', '198.51.100.8', NOW() - INTERVAL 100 DAY),
    ('t-priv-2', 'test-recent-login', '198.51.100.8', NOW() - INTERVAL 10 DAY),
    ('t-gone-9', 'account_deleted', NULL, NOW() - INTERVAL 200 DAY),
    ('t-gone-9', 'test-orphan-login', '198.51.100.9', NOW() - INTERVAL 5 DAY)");
$db->exec("INSERT INTO sync_history (user_id, sync_type, status, created_at) VALUES
    ('t-priv-2', 'push', 'success', NOW() - INTERVAL 100 DAY), ('t-priv-2', 'pull', 'success', NOW() - INTERVAL 1 DAY)");
$db->exec("INSERT INTO subscription_events (user_id, event_type, ip_address, user_agent, created_at) VALUES
    ('t-priv-2', 'test-old', '198.51.100.8', 'App', NOW() - INTERVAL 100 DAY),
    ('t-priv-2', 'test-recent', '198.51.100.8', 'App', NOW() - INTERVAL 1 DAY),
    ('t-gone-9', 'test-orphan', '198.51.100.9', 'App', NOW() - INTERVAL 1 DAY)");
$db->exec("SET FOREIGN_KEY_CHECKS = 1");
$tmpLogs = sys_get_temp_dir() . '/sm-retention-' . bin2hex(random_bytes(4));
mkdir($tmpLogs);
file_put_contents("$tmpLogs/php_errors.log.1", 'old');
touch("$tmpLogs/php_errors.log.1", time() - 100 * 86400);
$done = RetentionService::apply($db, $tmpLogs);
check('journal d\'audit de plus de 90 jours supprimé', (int)$q("SELECT COUNT(*) FROM audit_logs WHERE action='test-old-login'") === 0, $done);
check('journal d\'audit récent gardé', (int)$q("SELECT COUNT(*) FROM audit_logs WHERE action='test-recent-login'") === 1);
check('preuve de suppression ancienne gardée', (int)$q("SELECT COUNT(*) FROM audit_logs WHERE user_id='t-gone-9' AND action='account_deleted'") === 1);
check('compte disparu : IP effacée de son journal récent', $q("SELECT ip_address FROM audit_logs WHERE action='test-orphan-login'") === null);
check('sync_history : > 90 jours supprimé, récent gardé', (int)$q("SELECT COUNT(*) FROM sync_history WHERE user_id='t-priv-2'") === 1);
check('transaction > 90 jours : gardée sans IP ni UA', $q("SELECT CONCAT_WS('|', user_id, IFNULL(ip_address,'∅'), IFNULL(user_agent,'∅')) FROM subscription_events WHERE event_type='test-old'") === 't-priv-2|∅|∅');
check('transaction récente d\'un compte actif : intacte', $q("SELECT ip_address FROM subscription_events WHERE event_type='test-recent'") === '198.51.100.8');
check('transaction d\'un compte disparu : détachée', $q("SELECT CONCAT_WS('|', IFNULL(user_id,'∅'), IFNULL(ip_address,'∅')) FROM subscription_events WHERE event_type='test-orphan'") === '∅|∅');
check('ancien journal PHP (> 90 jours) effacé', !is_file("$tmpLogs/php_errors.log.1") && $done['old_php_log'] === 1);
@rmdir($tmpLogs);
check('deuxième passage : plus rien à faire', array_sum(RetentionService::apply($db, $tmpLogs)) === 0);

echo "\n== Migrations 010 (clés étrangères) et 011 (jetons chiffrés) ==\n";
// État de la prod avant 010 : aucune des trois clés, un orphelin
$db->exec("ALTER TABLE subscription_events DROP FOREIGN KEY IF EXISTS fk_sub_event_user, DROP FOREIGN KEY IF EXISTS fk_sub_event_subscription");
$db->exec("ALTER TABLE apple_notifications DROP FOREIGN KEY IF EXISTS fk_apple_notif_user");
$db->exec("INSERT INTO subscription_events (user_id, event_type) VALUES ('t-gone-9', 'test-mig-orphan')");
$fkCount = fn() => (int)$q("SELECT COUNT(*) FROM information_schema.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = DATABASE()
    AND CONSTRAINT_NAME IN ('fk_apple_notif_user', 'fk_sub_event_subscription', 'fk_sub_event_user') AND DELETE_RULE = 'SET NULL'");
$sql010 = file_get_contents($BK . '/database/migrations/010_fk_set_null.sql');
$db->exec($sql010);
check('010 : les trois clés ON DELETE SET NULL posées', $fkCount() === 3);
check('010 : orphelin détaché avant la pose', $q("SELECT user_id FROM subscription_events WHERE event_type='test-mig-orphan'") === null);
$db->exec($sql010);
check('010 : rejouable sans erreur', $fkCount() === 3);
$db->exec("DELETE FROM subscription_events WHERE event_type='test-mig-orphan'");
$db->exec("UPDATE users SET apple_refresh_token = 'r.legacy-plain' WHERE user_id = 't-priv-2'");
$db->exec("UPDATE users SET apple_refresh_token = '" . TokenCipher::encrypt('r.already') . "' WHERE user_id = 't-priv-3'");
check('011 : seul le jeton en clair est chiffré', TokenCipher::encryptStoredAppleTokens($db) === 1);
$stored = $q("SELECT apple_refresh_token FROM users WHERE user_id = 't-priv-2'");
check('011 : stocké chiffré, déchiffrable', TokenCipher::isEncrypted($stored) && TokenCipher::decrypt($stored) === 'r.legacy-plain');
check('011 : rejouable (rien à refaire)', TokenCipher::encryptStoredAppleTokens($db) === 0);

echo "\n== Préférence analytics_enabled ==\n";
$jwt = new JWTHandler();
function logEventAs(?string $u, string $type): array {
    global $jwt;
    if ($u === null) unset($_SERVER['HTTP_AUTHORIZATION']);
    else $_SERVER['HTTP_AUTHORIZATION'] = 'Bearer ' . $jwt->generateToken(['user_id' => $u, 'email' => "$u@test.local", 'provider' => 'apple']);
    http_response_code(200);
    return withInput(json_encode(['event_type' => $type, 'event_data' => ['success' => true], 'device_platform' => 'ios', 'app_version' => 'test']),
        fn() => (new AnalyticsController())->logEvent());
}
$db->exec("INSERT INTO user_preferences (user_id, analytics_enabled) VALUES ('t-priv-3', 0), ('t-priv-4', 1)");
$r = logEventAs('t-priv-3', 'scan_nfc');
check('statistiques désactivées → rien enregistré', ($r['data']['recorded'] ?? null) === false && (int)$q("SELECT COUNT(*) FROM analytics WHERE user_id='t-priv-3'") === 0, $r);
logEventAs('t-priv-4', 'scan_nfc');
check('statistiques activées → enregistré', (int)$q("SELECT COUNT(*) FROM analytics WHERE user_id='t-priv-4'") === 1);
logEventAs('t-priv-2', 'scan_nfc');
check('sans préférence (défaut) → enregistré', (int)$q("SELECT COUNT(*) FROM analytics WHERE user_id='t-priv-2'") === 1);
$before = (int)$q("SELECT COUNT(*) FROM analytics WHERE user_id IS NULL AND event_type='scan_test_guest'");
logEventAs(null, 'scan_test_guest');
check('invité → enregistré (pas de compte, pas de préférence)', (int)$q("SELECT COUNT(*) FROM analytics WHERE user_id IS NULL AND event_type='scan_test_guest'") === $before + 1);
$db->exec("DELETE FROM analytics WHERE event_type='scan_test_guest'");

echo "\n== Outils admin : secret distinct du secret de cron ==\n";
$_GET['email'] = 't-priv-2@test.local';
$_SERVER['HTTP_X_ADMIN_SECRET'] = 'test-cron-secret';
http_response_code(200);
$r = (new ReportController())->userSearch([]);
check('secret de cron refusé (403)', http_response_code() === 403 && ($r['success'] ?? true) === false, $r);
$_SERVER['HTTP_X_ADMIN_SECRET'] = 'test-admin-secret';
http_response_code(200);
$r = (new ReportController())->userSearch([]);
check('secret admin accepté', ($r['success'] ?? false) === true, $r);
putenv('ADMIN_SECRET=');
http_response_code(200);
$r = (new ReportController())->userSearch([]);
check('ADMIN_SECRET vide → outils fermés', http_response_code() === 403, $r);
putenv('ADMIN_SECRET=test-admin-secret');
unset($_SERVER['HTTP_X_ADMIN_SECRET'], $_GET['email']);

echo "\n== DELETE /user/account (contrôleur) ==\n";
$db->exec("INSERT INTO users (user_id, email, provider, provider_id) VALUES ('t-priv-del', 't-priv-del@test.local', 'google', 'p-del')");
$_SERVER['HTTP_AUTHORIZATION'] = 'Bearer ' . $jwt->generateToken(['user_id' => 't-priv-del', 'email' => 't-priv-del@test.local', 'provider' => 'google']);
http_response_code(200);
$r = (new \NfcAnycubic\Controllers\UserController())->deleteAccount();
check('suppression réussie → 200, deleted = true', http_response_code() === 200 && ($r['data']['deleted'] ?? null) === true, $r);
check('compte effacé en base', (int)$q("SELECT COUNT(*) FROM users WHERE user_id='t-priv-del'") === 0);
$db->exec("DELETE FROM audit_logs WHERE user_id='t-priv-del'");

echo "\n== Webhook Google sans configuration OIDC ==\n";
putenv('GOOGLE_PUBSUB_AUDIENCE=');
GooglePlayWebhookController::$tokenVerifier = fn(string $t) => ['iss' => 'https://accounts.google.com', 'aud' => '', 'email' => '', 'email_verified' => true, 'exp' => time() + 60];
$_SERVER['HTTP_AUTHORIZATION'] = 'Bearer anything';
http_response_code(200);
$r = withInput('{"message":{"data":"e30="}}', fn() => (new GooglePlayWebhookController())->handleNotification());
check('audience non configurée → 401 (fermé par défaut)', http_response_code() === 401, $r);
putenv('GOOGLE_PUBSUB_AUDIENCE=https://api.test/webhooks/google-play');

foreach (['analytics', 'audit_logs', 'subscription_events', 'sync_history', 'user_preferences'] as $t) {
    $db->exec("DELETE FROM $t WHERE user_id IN ($in, 't-gone-9')");
}
$db->exec("DELETE FROM subscription_events WHERE event_type IN ('purchase', 'test-old', 'test-recent', 'test-orphan')");
$db->exec("DELETE FROM apple_notifications WHERE notification_uuid LIKE 'priv-%'");
$db->exec("DELETE FROM users WHERE user_id IN ($in)");
finish();
