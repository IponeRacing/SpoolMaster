<?php
// Révocation de jeton de session : fournisseur réel du compte (97a824c).
// Lancer par tests/run.sh.
require __DIR__ . '/bootstrap.php';

$db = \NfcAnycubic\Database::getInstance()->getConnection();
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$db->exec("DELETE FROM token_revocations WHERE token_identifier LIKE 'test-jti-%'");
$db->exec("DELETE FROM users WHERE user_id IN ('t-rev-g','t-rev-a')");
$db->exec("INSERT INTO users (user_id, email, provider, provider_id) VALUES ('t-rev-g','g@t.local','google','pg'),('t-rev-a','a@t.local','apple','pa')");
$jwt = new \NfcAnycubic\JWTHandler();

echo "== Révocation de jeton ==\n";
foreach ([['t-rev-g', 'google'], ['t-rev-a', 'apple']] as [$u, $expected]) {
    $jti = "test-jti-$u";
    $revokedOk = $jwt->revokeToken($jti, $u, 'user_logout');
    $provider = $db->query("SELECT provider FROM token_revocations WHERE token_identifier='$jti'")->fetchColumn();
    check("$u : révoqué avec provider « $expected »", $revokedOk && $provider === $expected && $jwt->isTokenRevoked($jti), $provider);
}
$db->exec("DELETE FROM token_revocations WHERE token_identifier LIKE 'test-jti-%'");
$db->exec("DELETE FROM users WHERE user_id IN ('t-rev-g','t-rev-a')");
finish();
