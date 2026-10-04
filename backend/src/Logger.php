<?php
/**
 * Journal applicatif de l'API
 *
 * Une ligne par événement, préfixée d'un identifiant de requête, de la route,
 * de l'utilisateur et de la version de l'app. Le request id est aussi renvoyé
 * au client (en-tête X-Request-Id + corps des réponses 500) → une erreur vue
 * dans l'app peut être retrouvée dans le log serveur.
 */

namespace NfcAnycubic;

class Logger {
    private static ?string $requestId = null;
    private static ?string $userId = null;
    private static array $seen = [];

    /**
     * Génère le request id et l'envoie dans l'en-tête X-Request-Id.
     * À appeler une seule fois, en tout début de requête.
     */
    public static function init(): string {
        self::$requestId = bin2hex(random_bytes(6));
        if (!headers_sent()) {
            header('X-Request-Id: ' . self::$requestId);
        }
        return self::$requestId;
    }

    public static function requestId(): ?string {
        return self::$requestId;
    }

    /**
     * Renseigné par AuthMiddleware dès qu'un token est validé.
     */
    public static function setUserId(?string $userId): void {
        self::$userId = $userId;
    }

    public static function error(string $context, string $message, array $extra = []): void {
        self::write('ERROR', $context, $message, $extra);
    }

    public static function warning(string $context, string $message, array $extra = []): void {
        self::write('WARN', $context, $message, $extra);
    }

    /**
     * Comme warning(), mais une seule fois par requête pour un même message
     * (évite qu'une dépréciation répétée dans une boucle noie le log).
     */
    public static function warningOnce(string $context, string $message): void {
        $key = $context . '|' . $message;
        if (isset(self::$seen[$key])) return;
        self::$seen[$key] = true;
        self::write('WARN', $context, $message, []);
    }

    public static function exception(string $context, \Throwable $e, array $extra = []): void {
        $extra['exception'] = get_class($e);
        if ($e->getCode()) {
            $extra['code'] = $e->getCode();
        }
        $extra['at'] = basename($e->getFile()) . ':' . $e->getLine();
        // Trace compacte (5 frames, sans chemins ni arguments → pas de données
        // utilisateur dans le log) : assez pour localiser.
        $frames = [];
        foreach (array_slice($e->getTrace(), 0, 5) as $f) {
            $where = isset($f['file']) ? basename($f['file']) . ':' . ($f['line'] ?? '?') . ' ' : '';
            $function = $f['function'] ?? '?';
            // PHP 8.4+ nomme les closures « {closure:/chemin/complet:ligne} ».
            if (strpos($function, '{closure') === 0) $function = '{closure}';
            $frames[] = $where . ($f['class'] ?? '') . ($f['type'] ?? '') . $function;
        }
        $extra['trace'] = implode(' | ', $frames);
        self::write('ERROR', $context, $e->getMessage(), $extra);
    }

    private static function write(string $level, string $context, string $message, array $extra): void {
        $method = $_SERVER['REQUEST_METHOD'] ?? 'CLI';
        $path = parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH) ?: '-';
        // Ne jamais écrire les secrets CRON (dernier segment de /cron/...) dans le log.
        $path = preg_replace('#^((?:/api)?/cron/[^/]+/).+$#', '$1***', $path);

        $line = sprintf(
            '[%s] %s %s %s %s user=%s app=%s — %s',
            self::$requestId ?? '-',
            $level,
            $context,
            $method,
            $path,
            self::$userId ?? '-',
            $_SERVER['HTTP_X_APP_VERSION'] ?? '-',
            str_replace(["\r", "\n"], ' ', $message)
        );

        if (!empty($extra)) {
            $json = json_encode($extra, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PARTIAL_OUTPUT_ON_ERROR);
            if ($json !== false) {
                $line .= ' ' . $json;
            }
        }

        \error_log($line);
    }
}
