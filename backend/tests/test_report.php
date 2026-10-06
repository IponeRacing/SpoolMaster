<?php
// Rapport journalier : génération complète sur la base de test (sans e-mail),
// dont la section « Langues des appareils ». Lancer par tests/run.sh.
require __DIR__ . '/bootstrap.php';

use NfcAnycubic\Controllers\ReportController;
use NfcAnycubic\Database;

$db = Database::getInstance()->getConnection();
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$db->exec("DELETE FROM analytics WHERE event_type = 'scan_report_test'");
$ins = $db->prepare("INSERT INTO analytics (user_id, event_type, event_data, device_platform, app_version) VALUES (NULL, 'scan_report_test', ?, 'ios', 'test')");
foreach ([
    ['install_id' => 'i-de-1', 'device_locale' => 'de-CH', 'app_language' => 'de', 'success' => true],
    ['install_id' => 'i-de-1', 'device_locale' => 'de-CH', 'app_language' => 'de', 'success' => true], // même appareil
    ['install_id' => 'i-de-2', 'device_locale' => 'de-DE', 'app_language' => 'de', 'success' => true],
    ['install_id' => 'i-lt-1', 'device_locale' => 'lt-LT', 'app_language' => 'en', 'success' => true], // non traduit
    ['install_id' => 'i-nb-1', 'device_locale' => 'nb-NO', 'app_language' => 'no', 'success' => true], // nb = no
    ['install_id' => 'i-tw-1', 'device_locale' => 'zh-TW', 'app_language' => 'zh_TW', 'success' => true],
    ['install_id' => 'i-old-1', 'success' => true], // version sans langue : ignorée
] as $data) {
    $ins->execute([json_encode($data)]);
}

echo "== Rapport journalier ==\n";
$gen = new ReflectionMethod(ReportController::class, 'generateReport');
$report = $gen->invoke(new ReportController(), $db);
check('rapport généré (toutes les requêtes passent)', isset($report['scans_24h'], $report['device_languages']));
$langs = [];
foreach ($report['device_languages'] as $row) $langs[$row['lang']] = [(int)$row['appareils'], (int)$row['autre_langue']];
check('allemand : 2 appareils distincts, app en allemand', ($langs['de'] ?? null) === [2, 0], $langs);
check('lituanien : 1 appareil, app dans une autre langue', ($langs['lt'] ?? null) === [1, 1], $langs);
check('norvégien nb-NO rangé sous « no », pas compté comme non traduit', ($langs['no'] ?? null) === [1, 0], $langs);
check('chinois traditionnel zh_TW : pas compté comme non traduit', ($langs['zh'] ?? null) === [1, 0], $langs);
$render = new ReflectionMethod(ReportController::class, 'renderHtml');
$html = $render->invoke(new ReportController(), $report);
check('section affichée dans l\'e-mail', str_contains($html, 'Langues des appareils (30 j)'));

$db->exec("DELETE FROM analytics WHERE event_type = 'scan_report_test'");
finish();
