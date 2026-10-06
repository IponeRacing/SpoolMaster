<?php
// Amorce commune des tests backend. Lancer par tests/run.sh, qui fournit la
// base jetable (SM_TEST_ENV), la chaîne de certificats de test (SM_TEST_PKI)
// et le journal PHP (SM_TEST_LOG).
declare(strict_types=1);
ob_start(); // les contrôleurs envoient des en-têtes : aucune sortie avant la fin

$BK = dirname(__DIR__);
$JWS = (string)getenv('SM_TEST_PKI');
if (!getenv('SM_TEST_ENV') || $JWS === '') {
    fwrite(STDERR, "Lancer via backend/tests/run.sh\n");
    exit(2);
}
require $BK . '/vendor/autoload.php';
\NfcAnycubic\EnvLoader::load((string)getenv('SM_TEST_ENV'));
ini_set('error_log', getenv('SM_TEST_LOG') ?: sys_get_temp_dir() . '/spoolmaster_php_test.log');
set_error_handler(function ($no, $str, $file, $line) {
    if ($no === E_DEPRECATED || $no === E_USER_DEPRECATED) return true;
    throw new ErrorException($str, 0, $no, $file, $line);
});

// ---------- php://input simulé ----------
class FakeInput {
    public static string $body = '';
    private int $pos = 0;
    public $context;
    public function stream_open($path, $mode, $options, &$opened) { $this->pos = 0; return $path === 'php://input'; }
    public function stream_read($count) { $r = substr(self::$body, $this->pos, $count); $this->pos += strlen($r); return $r; }
    public function stream_eof() { return $this->pos >= strlen(self::$body); }
    public function stream_stat() { return ['size' => strlen(self::$body)]; }
}
function withInput(string $body, callable $fn) {
    FakeInput::$body = $body;
    stream_wrapper_unregister('php');
    stream_wrapper_register('php', FakeInput::class);
    try { return $fn(); } finally { stream_wrapper_restore('php'); }
}

// ---------- résultats ----------
$ok = 0; $ko = 0;
function check(string $name, bool $cond, $detail = null): void {
    global $ok, $ko;
    if ($cond) { $ok++; echo "  OK  $name\n"; }
    else { $ko++; echo "  KO  $name" . ($detail !== null ? '  → ' . json_encode($detail) : '') . "\n"; }
}
function finish(): never {
    global $ok, $ko;
    echo "\n== Bilan : $ok OK / $ko KO ==\n";
    exit($ko > 0 ? 1 : 0);
}
