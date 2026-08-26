<?php
/**
 * Contrôleur App
 * Endpoints généraux liés à l'application (version-check pour le prompt de maj).
 */

namespace NfcAnycubic\Controllers;

class AppController {

    /**
     * Vérifie si une mise à jour est disponible / requise.
     * GET /app/version-check?platform=ios|android&version=1.4.6
     *
     * Réponse :
     *  {
     *    success: true,
     *    update_available: bool,   // version installée < latest
     *    force: bool,              // version installée < min (maj bloquante)
     *    latest: "1.4.7",
     *    min: "1.0.0",
     *    store_url: "https://..."
     *  }
     *
     * Fail-open : en cas de config manquante/illisible, renvoie update_available=false
     * (ne jamais bloquer l'app à cause d'une erreur serveur).
     */
    public function versionCheck() {
        $platform = isset($_GET['platform']) ? strtolower((string)$_GET['platform']) : '';
        $current  = isset($_GET['version']) ? (string)$_GET['version'] : '';

        // Normaliser la version (retirer un éventuel build "+80")
        $current = preg_replace('/\+.*$/', '', $current);

        if (!in_array($platform, ['ios', 'android'], true) || $current === '') {
            http_response_code(400);
            return ['success' => false, 'error' => 'platform (ios|android) and version are required'];
        }

        $configPath = __DIR__ . '/../../config/app_version.json';
        $cfg = @\file_get_contents($configPath);
        $data = $cfg !== false ? \json_decode($cfg, true) : null;

        // Fail-open si config absente/invalide
        if (!\is_array($data) || !isset($data[$platform])) {
            return [
                'success' => true,
                'update_available' => false,
                'force' => false,
            ];
        }

        $latest = (string)($data[$platform]['latest'] ?? $current);
        $min    = (string)($data[$platform]['min'] ?? '0.0.0');
        $storeUrl = (string)($data['store_url_' . $platform] ?? '');

        $updateAvailable = \version_compare($current, $latest, '<');
        $force = \version_compare($current, $min, '<');

        return [
            'success' => true,
            'update_available' => $updateAvailable,
            'force' => $force,
            'latest' => $latest,
            'min' => $min,
            'store_url' => $storeUrl,
        ];
    }
}
