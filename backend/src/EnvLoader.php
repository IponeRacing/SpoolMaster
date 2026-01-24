<?php
/**
 * Environment Variable Loader
 * Loads variables from .env file into environment
 *
 * @package NfcAnycubic
 */

namespace NfcAnycubic;

class EnvLoader
{
    private static bool $loaded = false;

    /**
     * Load environment variables from .env file
     *
     * @param string|null $path Path to .env file (defaults to backend/.env)
     * @return void
     */
    public static function load(?string $path = null): void
    {
        if (self::$loaded) {
            return;
        }

        $envFile = $path ?? __DIR__ . '/../.env';

        if (!file_exists($envFile)) {
            // In production, env vars should be set by the server
            // Only log if in development
            if (getenv('APP_ENV') !== 'production') {
                error_log("Warning: .env file not found at $envFile");
            }
            self::$loaded = true;
            return;
        }

        $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

        foreach ($lines as $line) {
            // Skip comments
            $line = trim($line);
            if (empty($line) || strpos($line, '#') === 0) {
                continue;
            }

            // Parse key=value
            $pos = strpos($line, '=');
            if ($pos === false) {
                continue;
            }

            $key = trim(substr($line, 0, $pos));
            $value = trim(substr($line, $pos + 1));

            // Remove quotes if present
            if (preg_match('/^(["\'])(.*)\\1$/', $value, $matches)) {
                $value = $matches[2];
            }

            // Don't override existing environment variables
            if (getenv($key) === false) {
                putenv("$key=$value");
                $_ENV[$key] = $value;
            }
        }

        self::$loaded = true;
    }

    /**
     * Get an environment variable with optional default
     *
     * @param string $key Variable name
     * @param mixed $default Default value if not set
     * @return mixed
     */
    public static function get(string $key, $default = null)
    {
        self::load();

        $value = getenv($key);

        if ($value === false) {
            return $default;
        }

        // Type conversion for common values
        switch (strtolower($value)) {
            case 'true':
            case '(true)':
                return true;
            case 'false':
            case '(false)':
                return false;
            case 'null':
            case '(null)':
                return null;
            case 'empty':
            case '(empty)':
                return '';
        }

        return $value;
    }

    /**
     * Get a required environment variable (throws if not set)
     *
     * @param string $key Variable name
     * @return string
     * @throws \RuntimeException if variable is not set
     */
    public static function getRequired(string $key): string
    {
        $value = self::get($key);

        if ($value === null || $value === '') {
            throw new \RuntimeException(
                "Required environment variable '$key' is not set. " .
                "Please check your .env file or server configuration."
            );
        }

        return $value;
    }

    /**
     * Check if environment is production
     */
    public static function isProduction(): bool
    {
        return self::get('APP_ENV', 'production') === 'production';
    }

    /**
     * Check if debug mode is enabled
     */
    public static function isDebug(): bool
    {
        return self::get('APP_DEBUG', false) === true ||
               self::get('APP_DEBUG', 'false') === 'true';
    }
}
