<?php
/**
 * Contrôleur Rapport Journalier
 * Génère et envoie un rapport quotidien par email avec les métriques clés
 */

namespace NfcAnycubic\Controllers;

use NfcAnycubic\Database;
use NfcAnycubic\Logger;

class ReportController {

    /**
     * GET /cron/daily-report/:secret
     * Génère un rapport des dernières 24h et l'envoie par email
     */
    public function dailyReport($params) {
        $secret = $params['secret'] ?? null;
        $config = require __DIR__ . '/../../config/app.php';
        $validSecret = $config['cron_secret'] ?? '';

        if (empty($validSecret)) {
            http_response_code(503);
            return ['success' => false, 'error' => 'CRON not configured'];
        }

        if (!hash_equals($validSecret, $secret ?? '')) {
            error_log("❌ Invalid CRON secret for daily-report from IP: " . ($_SERVER['REMOTE_ADDR'] ?? 'unknown'));
            http_response_code(403);
            return ['success' => false, 'error' => 'Invalid secret'];
        }

        try {
            $db = Database::getInstance()->getConnection();

            // Purge des comptes dont la suppression a été demandée (RGPD) :
            // profite du cron quotidien déjà planifié chez Infomaniak.
            try {
                \NfcAnycubic\Services\AccountPurgeService::purgePending($db);
            } catch (\Throwable $e) {
                \error_log("⚠️ [DAILY-REPORT] Account purge failed: " . $e->getMessage());
            }
            // Durées de conservation de la politique de confidentialité
            try {
                \NfcAnycubic\Services\RetentionService::apply($db);
            } catch (\Throwable $e) {
                Logger::exception('retention', $e);
            }

            $report = $this->generateReport($db);
            $html = $this->renderHtml($report);

            $emailSent = false;
            try {
                $emailSent = $this->sendEmail($html, $report);
            } catch (\Throwable $e) {
                \error_log("⚠️ [DAILY-REPORT] Email failed: " . $e->getMessage());
            }

            // Le rapport part par e-mail : l'appelant (planificateur, dont
            // l'URL contient le secret) n'a pas à recevoir les données.
            return ['success' => true, 'email_sent' => $emailSent];
        } catch (\Exception $e) {
            // Détail dans le log seulement (pas de message SQL renvoyé).
            Logger::exception('report', $e);
            \http_response_code(500);
            return ['success' => false, 'error' => 'Internal error', 'request_id' => Logger::requestId()];
        }
    }

    private function generateReport(\PDO $db): array {
        $report = [];
        $report['date'] = date('Y-m-d');
        $report['generated_at'] = date('Y-m-d H:i:s');

        // ── 1. Scans dernières 24h : succès / échecs / taux ──
        $stmt = $db->query("
            SELECT
                COUNT(*) AS total,
                SUM(JSON_EXTRACT(event_data, '$.success') = true) AS success,
                SUM(JSON_EXTRACT(event_data, '$.success') = false) AS failed
            FROM analytics
            WHERE event_type LIKE 'scan_%'
              AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
        ");
        $row = $stmt->fetch();
        $report['scans_24h'] = [
            'total' => (int)$row['total'],
            'success' => (int)$row['success'],
            'failed' => (int)$row['failed'],
            'success_rate' => $row['total'] > 0 ? round((int)$row['success'] / (int)$row['total'] * 100, 1) : 0,
        ];

        // ── 2. Scans veille (J-2 à J-1) pour comparaison ──
        $stmt = $db->query("
            SELECT
                COUNT(*) AS total,
                SUM(JSON_EXTRACT(event_data, '$.success') = true) AS success,
                SUM(JSON_EXTRACT(event_data, '$.success') = false) AS failed
            FROM analytics
            WHERE event_type LIKE 'scan_%'
              AND created_at >= DATE_SUB(NOW(), INTERVAL 48 HOUR)
              AND created_at < DATE_SUB(NOW(), INTERVAL 24 HOUR)
        ");
        $row = $stmt->fetch();
        $report['scans_previous'] = [
            'total' => (int)$row['total'],
            'success' => (int)$row['success'],
            'failed' => (int)$row['failed'],
        ];

        // ── 3. Scans par type ──
        $stmt = $db->query("
            SELECT event_type, COUNT(*) AS nb,
                SUM(JSON_EXTRACT(event_data, '$.success') = true) AS ok,
                SUM(JSON_EXTRACT(event_data, '$.success') = false) AS ko
            FROM analytics
            WHERE event_type LIKE 'scan_%'
              AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
            GROUP BY event_type
            ORDER BY nb DESC
        ");
        $report['scans_by_type'] = $stmt->fetchAll();

        // ── 4. Scans par plateforme ──
        $stmt = $db->query("
            SELECT device_platform, COUNT(*) AS nb,
                SUM(JSON_EXTRACT(event_data, '$.success') = true) AS ok,
                SUM(JSON_EXTRACT(event_data, '$.success') = false) AS ko
            FROM analytics
            WHERE event_type LIKE 'scan_%'
              AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
            GROUP BY device_platform
        ");
        $report['scans_by_platform'] = $stmt->fetchAll();

        // ── 5. Top erreurs (avec diagnostics tag_was_detected et devices) ──
        $stmt = $db->query("
            SELECT
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.error_message')) AS error_msg,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.nfc_mode')) AS nfc_mode,
                COUNT(*) AS nb,
                SUM(JSON_EXTRACT(event_data, '$.tag_was_detected') = true) AS tag_detected,
                SUM(IFNULL(JSON_EXTRACT(event_data, '$.tag_was_detected'), false) = false) AS tag_not_detected,
                GROUP_CONCAT(DISTINCT JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.device_model')) SEPARATOR ', ') AS devices,
                GROUP_CONCAT(DISTINCT device_platform SEPARATOR ', ') AS platforms
            FROM analytics
            WHERE JSON_EXTRACT(event_data, '$.success') = false
              AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
            GROUP BY error_msg, nfc_mode
            ORDER BY nb DESC
            LIMIT 10
        ");
        $report['top_errors'] = $stmt->fetchAll();

        // ── 6. Scans par version d'app ──
        $stmt = $db->query("
            SELECT app_version, COUNT(*) AS nb
            FROM analytics
            WHERE event_type LIKE 'scan_%'
              AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
            GROUP BY app_version
            ORDER BY nb DESC
        ");
        $report['scans_by_version'] = $stmt->fetchAll();

        // ── 7. Scans par device model ──
        $stmt = $db->query("
            SELECT
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.device_model')) AS device,
                device_platform,
                COUNT(*) AS nb
            FROM analytics
            WHERE event_type LIKE 'scan_%'
              AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
            GROUP BY device, device_platform
            ORDER BY nb DESC
            LIMIT 10
        ");
        $report['top_devices'] = $stmt->fetchAll();

        // ── 8. Utilisateurs actifs (ayant scanné dans les 24h) ──
        $stmt = $db->query("
            SELECT COUNT(DISTINCT user_id) AS active_users
            FROM analytics
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
        ");
        $report['active_users_24h'] = (int)$stmt->fetch()['active_users'];

        // ── 9. Nouveaux utilisateurs (inscrits dans les 24h) ──
        $stmt = $db->query("
            SELECT COUNT(*) AS new_users
            FROM users
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
        ");
        $report['new_users_24h'] = (int)$stmt->fetch()['new_users'];

        // ── 10. Total utilisateurs ──
        $stmt = $db->query("SELECT COUNT(*) AS total FROM users");
        $report['total_users'] = (int)$stmt->fetch()['total'];

        // ── 11. Abonnements ──
        $stmt = $db->query("
            SELECT
                SUM(status = 'active') AS active,
                SUM(status = 'expired') AS expired,
                SUM(status = 'cancelled') AS cancelled,
                COUNT(*) AS total
            FROM subscriptions
        ");
        $report['subscriptions'] = $stmt->fetch();

        $stmt = $db->query("
            SELECT COUNT(*) AS new_subs
            FROM subscriptions
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
        ");
        $report['new_subscriptions_24h'] = (int)$stmt->fetch()['new_subs'];

        // ── 12. Total bobines en stock (all users) ──
        $stmt = $db->query("
            SELECT COUNT(*) AS total_spools
            FROM spools
            WHERE deleted_at IS NULL
        ");
        $report['total_spools'] = (int)$stmt->fetch()['total_spools'];

        // ── 13. Derniers scans réussis avec détails ──
        $stmt = $db->query("
            SELECT
                created_at,
                event_type,
                device_platform,
                app_version,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.nfc_mode')) AS nfc_mode,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.brand')) AS brand,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.material')) AS material,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.color')) AS color,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.weight')) AS weight,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.batch_number')) AS batch_number,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.tag_format')) AS tag_format,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.extruder_temp_min')) AS extruder_min,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.extruder_temp_max')) AS extruder_max,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.bed_temp_min')) AS bed_min,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.bed_temp_max')) AS bed_max,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.device_model')) AS device_model
            FROM analytics
            WHERE event_type LIKE 'scan_%'
              AND JSON_EXTRACT(event_data, '$.success') = true
              AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
            ORDER BY created_at DESC
            LIMIT 20
        ");
        $report['recent_scans'] = $stmt->fetchAll();

        // ── 14. Syncs dernières 24h ──
        $stmt = $db->query("
            SELECT COUNT(*) AS total,
                SUM(status = 'success') AS ok,
                SUM(status != 'success') AS ko
            FROM sync_history
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
        ");
        $report['syncs_24h'] = $stmt->fetch();

        // ── 15. Erreurs de sync remontées par l'app (24h) ──
        // sync_error = push/pull/PUT/DELETE en échec ; sync_op_abandoned =
        // opération abandonnée après N essais (= bobine non sauvegardée).
        $stmt = $db->query("
            SELECT
                event_type,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.op')) AS op,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.http_status')) AS http_status,
                JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.error_type')) AS error_type,
                COUNT(*) AS nb,
                COUNT(DISTINCT COALESCE(user_id, JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.install_id')))) AS users,
                MAX(app_version) AS app_version
            FROM analytics
            WHERE event_type IN ('sync_error', 'sync_op_abandoned')
              AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
            GROUP BY event_type, op, http_status, error_type
            ORDER BY nb DESC
            LIMIT 10
        ");
        $report['sync_errors'] = $stmt->fetchAll();

        // ── 16. Push serveur en échec / partiels (24h) ──
        $stmt = $db->query("
            SELECT created_at, user_id, sync_type, status, items_synced, error_message
            FROM sync_history
            WHERE status != 'success'
              AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
            ORDER BY created_at DESC
            LIMIT 10
        ");
        $report['sync_failures'] = $stmt->fetchAll();

        // ── 17. Langues des appareils (30 j, depuis la 1.4.12) ──
        // Appareils distincts par langue du système ; « app dans une autre
        // langue » = langue non traduite (repli sur l'anglais). Sert à
        // décider quelles langues ajouter. « nb » (norvégien) = « no » dans l'app.
        $stmt = $db->query("
            SELECT lang,
                   COUNT(DISTINCT who) AS appareils,
                   COUNT(DISTINCT CASE WHEN app_lang <> lang THEN who END) AS autre_langue
            FROM (
                SELECT COALESCE(user_id, JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.install_id'))) AS who,
                       CASE SUBSTRING_INDEX(JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.device_locale')), '-', 1)
                            WHEN 'nb' THEN 'no' WHEN 'nn' THEN 'no'
                            ELSE SUBSTRING_INDEX(JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.device_locale')), '-', 1) END AS lang,
                       SUBSTRING_INDEX(JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.app_language')), '_', 1) AS app_lang
                FROM analytics
                WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
                  AND JSON_EXTRACT(event_data, '$.device_locale') IS NOT NULL
            ) t
            GROUP BY lang
            ORDER BY appareils DESC
            LIMIT 20
        ");
        $report['device_languages'] = $stmt->fetchAll();

        return $report;
    }

    /** Échappe récursivement toutes les chaînes (données issues des events). */
    private function escapeAll($value) {
        if (\is_array($value)) {
            return \array_map(fn($v) => $this->escapeAll($v), $value);
        }
        return \is_string($value) ? \htmlspecialchars($value, ENT_QUOTES, 'UTF-8') : $value;
    }

    /**
     * Outils de support : secret dans l'en-tête X-Admin-Secret, jamais dans
     * l'URL. ADMIN_SECRET est distinct de CRON_SECRET : ce dernier figure
     * dans les URL planifiées, donc dans les logs d'accès, et ne doit pas
     * ouvrir la recherche d'utilisateurs (e-mails).
     */
    private function adminAuthorized(): bool {
        $config = require __DIR__ . '/../../config/app.php';
        $validSecret = (string)($config['admin_secret'] ?? '');
        $given = (string)($_SERVER['HTTP_X_ADMIN_SECRET'] ?? '');
        return $validSecret !== '' && \hash_equals($validSecret, $given);
    }

    private function renderHtml(array $r): string {
        // Toutes les valeurs (marques, erreurs, appareils… venant d'événements
        // envoyés sans compte) sont échappées : pas d'injection HTML dans l'e-mail.
        $r = $this->escapeAll($r);
        $today = $r['scans_24h'];
        $yesterday = $r['scans_previous'];
        $trend = $today['total'] - $yesterday['total'];
        $trendIcon = $trend > 0 ? '↑' : ($trend < 0 ? '↓' : '→');
        $trendColor = $trend > 0 ? '#27ae60' : ($trend < 0 ? '#e74c3c' : '#95a5a6');

        $html = "<!DOCTYPE html><html><head><meta charset='utf-8'></head><body style='font-family: -apple-system, sans-serif; max-width: 700px; margin: 0 auto; padding: 20px; background: #f5f5f5;'>";

        // Header
        $html .= "<div style='background: #2c3e50; color: white; padding: 20px; border-radius: 8px 8px 0 0; text-align: center;'>";
        $html .= "<h1 style='margin: 0; font-size: 24px;'>Spool Master - Rapport Journalier</h1>";
        $html .= "<p style='margin: 5px 0 0; opacity: 0.8;'>{$r['date']}</p>";
        $html .= "</div>";

        // KPIs
        $html .= "<div style='background: white; padding: 20px; border-bottom: 1px solid #eee;'>";
        $html .= "<h2 style='margin-top:0; color: #2c3e50;'>Vue d'ensemble (24h)</h2>";
        $html .= "<table style='width:100%; border-collapse: collapse;'><tr>";
        $html .= $this->kpiCell('Scans', $today['total'], "<span style='color:$trendColor'>$trendIcon " . abs($trend) . " vs veille</span>");
        $html .= $this->kpiCell('Taux succes', $today['success_rate'] . '%', $today['success'] . ' OK / ' . $today['failed'] . ' KO');
        $html .= $this->kpiCell('Users actifs', $r['active_users_24h'], '');
        $html .= $this->kpiCell('Nouveaux users', $r['new_users_24h'], 'Total: ' . $r['total_users']);
        $html .= "</tr></table></div>";

        // Scans par type
        if (!empty($r['scans_by_type'])) {
            $html .= $this->tableSection('Scans par type', ['Type', 'Total', 'OK', 'KO'], array_map(function($row) {
                return [$row['event_type'], $row['nb'], $row['ok'] ?? 0, $row['ko'] ?? 0];
            }, $r['scans_by_type']));
        }

        // Scans par plateforme
        if (!empty($r['scans_by_platform'])) {
            $html .= $this->tableSection('Scans par plateforme', ['Plateforme', 'Total', 'OK', 'KO'], array_map(function($row) {
                return [strtoupper($row['device_platform']), $row['nb'], $row['ok'] ?? 0, $row['ko'] ?? 0];
            }, $r['scans_by_platform']));
        }

        // Top erreurs
        if (!empty($r['top_errors'])) {
            $html .= "<div style='background: white; padding: 20px; border-bottom: 1px solid #eee;'>";
            $html .= "<h2 style='margin-top:0; color: #e74c3c;'>Top erreurs</h2>";
            $html .= "<table style='width:100%; border-collapse: collapse; font-size: 13px;'>";
            $html .= "<tr style='background:#ffeaea;'><th style='padding:8px; text-align:left;'>Erreur</th><th style='padding:8px;'>Mode</th><th style='padding:8px;'>Nb</th><th style='padding:8px;'>Tag vu?</th><th style='padding:8px;'>Devices</th></tr>";
            foreach ($r['top_errors'] as $err) {
                $msg = \mb_substr($err['error_msg'] ?? 'N/A', 0, 80);
                $tagInfo = ((int)($err['tag_detected'] ?? 0)) . '/' . ((int)($err['tag_not_detected'] ?? 0));
                $devices = \mb_substr($err['devices'] ?? '-', 0, 50);
                $html .= "<tr style='border-bottom:1px solid #f0f0f0;'>";
                $html .= "<td style='padding:8px;'>$msg</td>";
                $html .= "<td style='padding:8px; text-align:center;'>{$err['nfc_mode']}</td>";
                $html .= "<td style='padding:8px; text-align:center; font-weight:bold;'>{$err['nb']}</td>";
                $html .= "<td style='padding:8px; text-align:center; font-size:11px;' title='vu/pas vu'>$tagInfo</td>";
                $html .= "<td style='padding:8px; text-align:center; font-size:10px;'>$devices</td>";
                $html .= "</tr>";
            }
            $html .= "</table></div>";
        }

        // Scans par version
        if (!empty($r['scans_by_version'])) {
            $html .= $this->tableSection('Versions actives', ['Version', 'Scans'], array_map(function($row) {
                return [$row['app_version'] ?? 'N/A', $row['nb']];
            }, $r['scans_by_version']));
        }

        // Top devices
        if (!empty($r['top_devices'])) {
            $html .= $this->tableSection('Top appareils', ['Device', 'Plateforme', 'Scans'], array_map(function($row) {
                return [$row['device'] ?? 'N/A', strtoupper($row['device_platform'] ?? ''), $row['nb']];
            }, $r['top_devices']));
        }

        if (!empty($r['device_languages'])) {
            $html .= $this->tableSection('Langues des appareils (30 j)', ['Langue', 'Appareils', 'App dans une autre langue'], array_map(function($row) {
                return [$row['lang'] ?? '?', $row['appareils'], $row['autre_langue']];
            }, $r['device_languages']));
        }

        // Derniers scans réussis (détails)
        if (!empty($r['recent_scans'])) {
            $html .= "<div style='background: white; padding: 20px; border-bottom: 1px solid #eee;'>";
            $html .= "<h2 style='margin-top:0; color: #27ae60;'>Derniers scans reussis</h2>";
            $html .= "<table style='width:100%; border-collapse: collapse; font-size: 11px;'>";
            $html .= "<tr style='background:#e8f5e9;'><th style='padding:5px; text-align:left;'>Heure</th><th style='padding:5px;'>Format</th><th style='padding:5px;'>Marque</th><th style='padding:5px;'>Materiau</th><th style='padding:5px;'>Couleur</th><th style='padding:5px;'>Poids</th><th style='padding:5px;'>Temps</th><th style='padding:5px;'>SKU/Batch</th></tr>";
            foreach ($r['recent_scans'] as $scan) {
                $time = \substr($scan['created_at'] ?? '', 11, 5);
                $format = $scan['tag_format'] ?? ($scan['nfc_mode'] ?? '-');
                $brand = $scan['brand'] ?? '-';
                $material = $scan['material'] ?? '-';
                $color = $scan['color'] ?? '-';
                $weight = ($scan['weight'] && $scan['weight'] !== 'null') ? \round((float)$scan['weight']) . 'g' : '-';
                $temps = '';
                if (!empty($scan['extruder_min']) && $scan['extruder_min'] !== 'null') {
                    $temps = $scan['extruder_min'] . '-' . ($scan['extruder_max'] ?? '?') . '°C';
                }
                $batch = $scan['batch_number'] ?? '-';
                if ($batch === 'null') $batch = '-';
                $html .= "<tr style='border-bottom:1px solid #f0f0f0;'>";
                $html .= "<td style='padding:5px;'>$time</td>";
                $html .= "<td style='padding:5px; text-align:center; font-size:10px;'>$format</td>";
                $html .= "<td style='padding:5px; text-align:center;'>$brand</td>";
                $html .= "<td style='padding:5px; text-align:center;'>$material</td>";
                $html .= "<td style='padding:5px; text-align:center;'>$color</td>";
                $html .= "<td style='padding:5px; text-align:center;'>$weight</td>";
                $html .= "<td style='padding:5px; text-align:center; font-size:10px;'>$temps</td>";
                $html .= "<td style='padding:5px; text-align:center; font-size:10px;'>$batch</td>";
                $html .= "</tr>";
            }
            $html .= "</table></div>";
        }

        // Santé de la sync (erreurs app + push serveur en échec)
        if (!empty($r['sync_errors'])) {
            $html .= $this->tableSection('Erreurs de sync (app)', ['Événement / op', 'HTTP', 'Type', 'Nb', 'Users', 'Version'], array_map(function($row) {
                $e = fn($v) => (string)($v ?? '-'); // déjà échappé par escapeAll()
                return [
                    $e($row['event_type']) . ' / ' . $e($row['op']),
                    $e($row['http_status']),
                    $e($row['error_type']),
                    (int)$row['nb'],
                    (int)$row['users'],
                    $e($row['app_version']),
                ];
            }, $r['sync_errors']));
        }
        if (!empty($r['sync_failures'])) {
            $html .= $this->tableSection('Syncs serveur en échec', ['Heure', 'User', 'Statut', 'OK', 'Erreur'], array_map(function($row) {
                $e = fn($v) => (string)($v ?? '-'); // déjà échappé par escapeAll()
                return [
                    \substr($row['created_at'] ?? '', 11, 5),
                    $e(\substr($row['user_id'] ?? '', 0, 8)),
                    $e($row['sync_type'] . ' ' . $row['status']),
                    (int)$row['items_synced'],
                    $e(\mb_substr($row['error_message'] ?? '', 0, 120)),
                ];
            }, $r['sync_failures']));
        }

        // Abonnements
        $subs = $r['subscriptions'];
        $html .= "<div style='background: white; padding: 20px; border-bottom: 1px solid #eee;'>";
        $html .= "<h2 style='margin-top:0; color: #2c3e50;'>Abonnements</h2>";
        $html .= "<table style='width:100%; border-collapse: collapse;'><tr>";
        $html .= $this->kpiCell('Actifs', (int)($subs['active'] ?? 0), '');
        $html .= $this->kpiCell('Expires', (int)($subs['expired'] ?? 0), '');
        $html .= $this->kpiCell('Annules', (int)($subs['cancelled'] ?? 0), '');
        $html .= $this->kpiCell('Nouveaux (24h)', $r['new_subscriptions_24h'], '');
        $html .= "</tr></table></div>";

        // Footer
        $html .= "<div style='background: white; padding: 20px; border-radius: 0 0 8px 8px;'>";
        $html .= "<table style='width:100%; border-collapse: collapse;'><tr>";
        $html .= $this->kpiCell('Bobines totales', $r['total_spools'], '');
        $syncs = $r['syncs_24h'];
        $html .= $this->kpiCell('Syncs (24h)', (int)($syncs['total'] ?? 0), ((int)($syncs['ok'] ?? 0)) . ' OK / ' . ((int)($syncs['ko'] ?? 0)) . ' KO');
        $html .= "</tr></table>";
        $html .= "<p style='color:#95a5a6; font-size:12px; margin-top:15px; text-align:center;'>Genere le {$r['generated_at']} UTC</p>";
        $html .= "</div></body></html>";

        return $html;
    }

    private function kpiCell(string $label, $value, string $sub): string {
        return "<td style='text-align:center; padding:10px;'>"
            . "<div style='font-size:28px; font-weight:bold; color:#2c3e50;'>$value</div>"
            . "<div style='font-size:13px; color:#7f8c8d;'>$label</div>"
            . ($sub ? "<div style='font-size:11px; color:#95a5a6; margin-top:3px;'>$sub</div>" : "")
            . "</td>";
    }

    private function tableSection(string $title, array $headers, array $rows): string {
        $html = "<div style='background: white; padding: 20px; border-bottom: 1px solid #eee;'>";
        $html .= "<h2 style='margin-top:0; color: #2c3e50;'>$title</h2>";
        $html .= "<table style='width:100%; border-collapse: collapse; font-size: 13px;'>";
        $html .= "<tr style='background:#ecf0f1;'>";
        foreach ($headers as $h) {
            $align = $h === $headers[0] ? 'left' : 'center';
            $html .= "<th style='padding:8px; text-align:$align;'>$h</th>";
        }
        $html .= "</tr>";
        foreach ($rows as $row) {
            $html .= "<tr style='border-bottom:1px solid #f0f0f0;'>";
            foreach ($row as $i => $cell) {
                $align = $i === 0 ? 'left' : 'center';
                $bold = $i > 0 ? 'font-weight:bold;' : '';
                $html .= "<td style='padding:8px; text-align:$align; $bold'>$cell</td>";
            }
            $html .= "</tr>";
        }
        $html .= "</table></div>";
        return $html;
    }

    private function sendEmail(string $html, array $report): bool {
        $to = \getenv('SMTP_FROM') ?: 'info@engageengine.ch';
        $from = $to;
        $host = \getenv('SMTP_HOST') ?: 'mail.infomaniak.com';
        $port = (int)(\getenv('SMTP_PORT') ?: 587);
        $user = \getenv('SMTP_USER') ?: '';
        $pass = \getenv('SMTP_PASS') ?: '';

        if (empty($user) || empty($pass)) {
            \error_log("⚠️ [DAILY-REPORT] SMTP credentials not configured");
            return false;
        }

        $today = $report['scans_24h'];
        $subject = "[Spool Master] Rapport {$report['date']} - {$today['total']} scans, {$today['success_rate']}% succes";

        return $this->smtpSend($host, $port, $user, $pass, $from, $to, $subject, $html);
    }

    /**
     * Envoie une alerte ponctuelle à info@ via le même SMTP que le rapport
     * journalier (mail() est désactivé chez Infomaniak).
     */
    public function sendAlert(string $subject, string $html): bool {
        $to = \getenv('SMTP_FROM') ?: 'info@engageengine.ch';
        $user = \getenv('SMTP_USER') ?: '';
        $pass = \getenv('SMTP_PASS') ?: '';
        if (empty($user) || empty($pass)) {
            \error_log("⚠️ [ALERT] SMTP credentials not configured");
            return false;
        }
        $host = \getenv('SMTP_HOST') ?: 'mail.infomaniak.com';
        $port = (int)(\getenv('SMTP_PORT') ?: 587);
        return $this->smtpSend($host, $port, $user, $pass, $to, $to, $subject, $html);
    }

    /**
     * GET /cron/scan-analysis/:secret
     * Analyse approfondie des scans echoues et feedback utilisateur
     */
    public function scanAnalysis($params) {
        if (!$this->adminAuthorized()) {
            http_response_code(403);
            return ['success' => false, 'error' => 'Invalid secret'];
        }

        try {
            $db = \NfcAnycubic\Database::getInstance()->getConnection();
            $report = [];

            // 1. Vue d'ensemble globale (tout l'historique)
            $stmt = $db->query("
                SELECT
                    COUNT(*) as total_scans,
                    SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = false THEN 1 ELSE 0 END) as failed_scans,
                    SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = true THEN 1 ELSE 0 END) as successful_scans,
                    SUM(CASE WHEN event_type = 'scan_feedback' THEN 1 ELSE 0 END) as feedback_events,
                    MIN(created_at) as first_scan,
                    MAX(created_at) as last_scan
                FROM analytics
                WHERE event_type LIKE 'scan_%'
            ");
            $report['overview'] = $stmt->fetch();

            // 2. Tous les scans echoues avec details
            $stmt = $db->query("
                SELECT
                    a.id, a.user_id, a.event_type, a.event_data,
                    a.device_platform, a.app_version, a.created_at,
                    u.name as user_name, u.email as user_email, u.provider as auth_provider
                FROM analytics a
                LEFT JOIN users u ON a.user_id = u.user_id
                WHERE a.event_type LIKE 'scan_%'
                AND JSON_EXTRACT(a.event_data, '$.success') = false
                ORDER BY a.created_at DESC
            ");
            $failedScans = $stmt->fetchAll();
            foreach ($failedScans as &$s) {
                $s['event_data'] = json_decode($s['event_data'], true);
            }
            $report['failed_scans'] = $failedScans;

            // 3. Tous les feedbacks utilisateur
            $stmt = $db->query("
                SELECT
                    a.id, a.user_id, a.event_type, a.event_data,
                    a.device_platform, a.app_version, a.created_at,
                    u.name as user_name, u.email as user_email
                FROM analytics a
                LEFT JOIN users u ON a.user_id = u.user_id
                WHERE a.event_type = 'scan_feedback'
                ORDER BY a.created_at DESC
            ");
            $feedbacks = $stmt->fetchAll();
            foreach ($feedbacks as &$f) {
                $f['event_data'] = json_decode($f['event_data'], true);
            }
            $report['feedback_events'] = $feedbacks;

            // 4. Echecs par utilisateur
            $stmt = $db->query("
                SELECT
                    a.user_id,
                    u.name as user_name, u.email as user_email,
                    u.provider as auth_provider, u.created_at as user_created_at,
                    COUNT(*) as total_scans,
                    SUM(CASE WHEN JSON_EXTRACT(a.event_data, '$.success') = false THEN 1 ELSE 0 END) as failed_scans,
                    SUM(CASE WHEN JSON_EXTRACT(a.event_data, '$.success') = true THEN 1 ELSE 0 END) as successful_scans,
                    ROUND(SUM(CASE WHEN JSON_EXTRACT(a.event_data, '$.success') = false THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as failure_rate,
                    GROUP_CONCAT(DISTINCT a.device_platform) as platforms,
                    GROUP_CONCAT(DISTINCT a.app_version) as app_versions,
                    GROUP_CONCAT(DISTINCT JSON_UNQUOTE(JSON_EXTRACT(a.event_data, '$.nfc_mode'))) as nfc_modes,
                    GROUP_CONCAT(DISTINCT JSON_UNQUOTE(JSON_EXTRACT(a.event_data, '$.device_model'))) as devices
                FROM analytics a
                LEFT JOIN users u ON a.user_id = u.user_id
                WHERE a.event_type LIKE 'scan_%' AND a.event_type != 'scan_feedback'
                GROUP BY a.user_id
                HAVING failed_scans > 0
                ORDER BY failed_scans DESC
            ");
            $report['failures_by_user'] = $stmt->fetchAll();

            // 5. Erreurs par type
            $stmt = $db->query("
                SELECT
                    JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.error_message')) as error_message,
                    JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.nfc_mode')) as nfc_mode,
                    COUNT(*) as occurrences,
                    GROUP_CONCAT(DISTINCT device_platform) as platforms,
                    GROUP_CONCAT(DISTINCT JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.device_model'))) as devices,
                    GROUP_CONCAT(DISTINCT JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.os_version'))) as os_versions,
                    MIN(created_at) as first_seen, MAX(created_at) as last_seen
                FROM analytics
                WHERE event_type LIKE 'scan_%'
                AND JSON_EXTRACT(event_data, '$.success') = false
                GROUP BY error_message, nfc_mode
                ORDER BY occurrences DESC
            ");
            $report['errors_by_type'] = $stmt->fetchAll();

            // 6. Echecs par mode NFC
            $stmt = $db->query("
                SELECT
                    JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.nfc_mode')) as nfc_mode,
                    COUNT(*) as total,
                    SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = false THEN 1 ELSE 0 END) as failed,
                    SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = true THEN 1 ELSE 0 END) as success,
                    ROUND(SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = false THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as failure_rate
                FROM analytics
                WHERE event_type LIKE 'scan_%' AND event_type != 'scan_feedback'
                GROUP BY nfc_mode ORDER BY failure_rate DESC
            ");
            $report['by_nfc_mode'] = $stmt->fetchAll();

            // 7. Echecs par plateforme
            $stmt = $db->query("
                SELECT device_platform,
                    COUNT(*) as total,
                    SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = false THEN 1 ELSE 0 END) as failed,
                    SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = true THEN 1 ELSE 0 END) as success,
                    ROUND(SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = false THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as failure_rate
                FROM analytics
                WHERE event_type LIKE 'scan_%' AND event_type != 'scan_feedback'
                GROUP BY device_platform
            ");
            $report['by_platform'] = $stmt->fetchAll();

            // 8. Echecs par version
            $stmt = $db->query("
                SELECT app_version,
                    COUNT(*) as total,
                    SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = false THEN 1 ELSE 0 END) as failed,
                    ROUND(SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = false THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) as failure_rate
                FROM analytics
                WHERE event_type LIKE 'scan_%' AND event_type != 'scan_feedback'
                GROUP BY app_version ORDER BY app_version DESC
            ");
            $report['by_version'] = $stmt->fetchAll();

            // 9. Users qui n'ont JAMAIS reussi un scan
            $stmt = $db->query("
                SELECT a.user_id, u.name as user_name, u.email as user_email,
                    u.provider, u.created_at as user_since,
                    COUNT(*) as attempts,
                    GROUP_CONCAT(DISTINCT a.device_platform) as platforms,
                    GROUP_CONCAT(DISTINCT JSON_UNQUOTE(JSON_EXTRACT(a.event_data, '$.device_model'))) as devices,
                    GROUP_CONCAT(DISTINCT JSON_UNQUOTE(JSON_EXTRACT(a.event_data, '$.nfc_mode'))) as nfc_modes,
                    GROUP_CONCAT(DISTINCT JSON_UNQUOTE(JSON_EXTRACT(a.event_data, '$.error_message')) SEPARATOR ' | ') as errors
                FROM analytics a
                LEFT JOIN users u ON a.user_id = u.user_id
                WHERE a.event_type LIKE 'scan_%' AND a.event_type != 'scan_feedback'
                GROUP BY a.user_id
                HAVING SUM(CASE WHEN JSON_EXTRACT(a.event_data, '$.success') = true THEN 1 ELSE 0 END) = 0
                ORDER BY attempts DESC
            ");
            $report['users_never_succeeded'] = $stmt->fetchAll();

            // 10. Timeline jour par jour (30 derniers jours)
            $stmt = $db->query("
                SELECT DATE(created_at) as day,
                    COUNT(*) as total,
                    SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = false THEN 1 ELSE 0 END) as failed,
                    SUM(CASE WHEN JSON_EXTRACT(event_data, '$.success') = true THEN 1 ELSE 0 END) as success
                FROM analytics
                WHERE event_type LIKE 'scan_%' AND event_type != 'scan_feedback'
                GROUP BY day ORDER BY day DESC LIMIT 30
            ");
            $report['timeline'] = $stmt->fetchAll();

            // 11. Analyse tag detection (tag vu mais parsing echoue)
            $stmt = $db->query("
                SELECT
                    JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.tag_was_detected')) as tag_detected,
                    JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.nfc_mode')) as nfc_mode,
                    JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.error_message')) as error,
                    COUNT(*) as nb,
                    GROUP_CONCAT(DISTINCT JSON_UNQUOTE(JSON_EXTRACT(event_data, '$.raw_bytes_count'))) as raw_bytes
                FROM analytics
                WHERE event_type LIKE 'scan_%' AND JSON_EXTRACT(event_data, '$.success') = false
                GROUP BY tag_detected, nfc_mode, error ORDER BY nb DESC
            ");
            $report['tag_detection'] = $stmt->fetchAll();

            // 12. Contexte global
            $stmt = $db->query("SELECT COUNT(*) as n FROM users");
            $report['total_users'] = (int)$stmt->fetch()['n'];
            $stmt = $db->query("SELECT COUNT(DISTINCT user_id) as n FROM analytics WHERE event_type LIKE 'scan_%'");
            $report['users_who_scanned'] = (int)$stmt->fetch()['n'];

            return ['success' => true, 'data' => $report];
        } catch (\Exception $e) {
            // Détail dans le log seulement (pas de message SQL renvoyé).
            Logger::exception('report', $e);
            \http_response_code(500);
            return ['success' => false, 'error' => 'Internal error', 'request_id' => Logger::requestId()];
        }
    }

    /**
     * GET /admin/user-search?email=xxx  (en-tête X-Admin-Secret)
     */
    public function userSearch($params) {
        if (!$this->adminAuthorized()) {
            http_response_code(403);
            return ['success' => false, 'error' => 'Invalid secret'];
        }

        $email = $_GET['email'] ?? '';
        if (empty($email)) {
            return ['success' => false, 'error' => 'email parameter required'];
        }

        try {
            $db = \NfcAnycubic\Database::getInstance()->getConnection();

            // Recherche exacte par défaut. Partielle seulement avec partial=1 et
            // 4 caractères minimum, jokers échappés (avant : « % » renvoyait
            // toute la table users, apple_refresh_token compris).
            $columns = "user_id, email, name, provider, email_verified, created_at, last_login,
                        data_deletion_requested, data_deletion_requested_at";
            if (($_GET['partial'] ?? '') === '1') {
                if (\mb_strlen($email) < 4) {
                    http_response_code(400);
                    return ['success' => false, 'error' => 'partial search needs at least 4 characters'];
                }
                $like = '%' . \addcslashes($email, '%_\\') . '%';
                $stmt = $db->prepare("SELECT $columns FROM users WHERE email LIKE :email LIMIT 20");
                $stmt->execute(['email' => $like]);
            } else {
                $stmt = $db->prepare("SELECT $columns FROM users WHERE email = :email LIMIT 1");
                $stmt->execute(['email' => $email]);
            }
            $users = $stmt->fetchAll();

            $subscriptions = [];
            $preferences = [];
            $scans = [];
            foreach ($users as $u) {
                $uid = $u['user_id'];

                $stmt = $db->prepare("SELECT * FROM subscriptions WHERE user_id = :uid ORDER BY created_at DESC");
                $stmt->execute(['uid' => $uid]);
                $subscriptions[$uid] = $stmt->fetchAll();

                $stmt = $db->prepare("SELECT * FROM user_preferences WHERE user_id = :uid");
                $stmt->execute(['uid' => $uid]);
                $preferences[$uid] = $stmt->fetch() ?: null;

                $stmt = $db->prepare("SELECT id, event_type, event_data, device_platform, app_version, created_at FROM analytics WHERE user_id = :uid ORDER BY created_at DESC LIMIT 10");
                $stmt->execute(['uid' => $uid]);
                $rows = $stmt->fetchAll();
                foreach ($rows as &$r) {
                    $r['event_data'] = json_decode($r['event_data'], true);
                }
                $scans[$uid] = $rows;
            }

            return ['success' => true, 'data' => [
                'users' => $users,
                'subscriptions' => $subscriptions,
                'preferences' => $preferences,
                'recent_activity' => $scans,
            ]];
        } catch (\Exception $e) {
            // Détail dans le log seulement (pas de message SQL renvoyé).
            Logger::exception('report', $e);
            \http_response_code(500);
            return ['success' => false, 'error' => 'Internal error', 'request_id' => Logger::requestId()];
        }
    }

    private function smtpSend(string $host, int $port, string $user, string $pass, string $from, string $to, string $subject, string $htmlBody): bool {
        $smtp = @\fsockopen($host, $port, $errno, $errstr, 10);
        if (!$smtp) {
            \error_log("❌ [SMTP] Connection failed: $errstr ($errno)");
            return false;
        }

        $this->smtpRead($smtp);
        $this->smtpCmd($smtp, "EHLO " . \gethostname());
        $this->smtpCmd($smtp, "STARTTLS");

        \stream_socket_enable_crypto($smtp, true, STREAM_CRYPTO_METHOD_TLSv1_2_CLIENT);

        $this->smtpCmd($smtp, "EHLO " . \gethostname());
        $this->smtpCmd($smtp, "AUTH LOGIN");
        $this->smtpCmd($smtp, \base64_encode($user));
        $response = $this->smtpCmd($smtp, \base64_encode($pass));

        if (\strpos($response, '235') === false) {
            \error_log("❌ [SMTP] Auth failed: $response");
            \fclose($smtp);
            return false;
        }

        $this->smtpCmd($smtp, "MAIL FROM:<$from>");
        $this->smtpCmd($smtp, "RCPT TO:<$to>");
        $this->smtpCmd($smtp, "DATA");

        // Corps en base64 : aucune ligne du contenu (issu en partie de données
        // anonymes, ex. /analytics/event) ne peut plus être lue comme une
        // commande SMTP (« \r\n.\r\n » + MAIL FROM… = envoi arbitraire depuis
        // info@). Sujet nettoyé de tout retour ligne et encodé en MIME.
        $cleanSubject = \str_replace(["\r", "\n"], ' ', $subject);
        $message = "From: $from\r\n";
        $message .= "To: $to\r\n";
        $message .= "Subject: =?UTF-8?B?" . \base64_encode($cleanSubject) . "?=\r\n";
        $message .= "MIME-Version: 1.0\r\n";
        $message .= "Content-Type: text/html; charset=UTF-8\r\n";
        $message .= "Content-Transfer-Encoding: base64\r\n";
        $message .= "Date: " . \date('r') . "\r\n";
        $message .= "\r\n";
        $message .= \rtrim(\chunk_split(\base64_encode($htmlBody), 76, "\r\n"));
        $message .= "\r\n.\r\n";

        \fwrite($smtp, $message);
        $result = $this->smtpRead($smtp);

        $this->smtpCmd($smtp, "QUIT");
        \fclose($smtp);

        $success = \strpos($result, '250') !== false;
        \error_log($success ? "✅ [SMTP] Email sent to $to" : "❌ [SMTP] Send failed: $result");
        return $success;
    }

    private function smtpCmd($smtp, string $cmd): string {
        \fwrite($smtp, $cmd . "\r\n");
        return $this->smtpRead($smtp);
    }

    private function smtpRead($smtp): string {
        $response = '';
        \stream_set_timeout($smtp, 10);
        while ($line = \fgets($smtp, 515)) {
            $response .= $line;
            if (isset($line[3]) && $line[3] === ' ') break;
        }
        return $response;
    }
}
