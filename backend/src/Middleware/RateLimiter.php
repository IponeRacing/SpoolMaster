<?php
/**
 * Rate Limiter Middleware
 * Protects API endpoints from abuse and DoS attacks
 *
 * Uses file-based storage for simplicity (can be upgraded to Redis)
 *
 * @package NfcAnycubic\Middleware
 */

namespace NfcAnycubic\Middleware;

class RateLimiter
{
    private static string $cacheDir = __DIR__ . '/../../cache/rate_limit/';

    /**
     * Check if request should be rate limited
     *
     * @param string $key Unique identifier (IP, user_id, etc.)
     * @param int $maxRequests Maximum requests allowed in window
     * @param int $windowSeconds Time window in seconds
     * @return bool True if allowed, false if rate limited
     */
    public static function check(string $key, int $maxRequests = 100, int $windowSeconds = 60): bool
    {
        // Ensure cache directory exists
        if (!is_dir(self::$cacheDir)) {
            @mkdir(self::$cacheDir, 0755, true);
        }

        // Sanitize key for filename
        $cacheFile = self::$cacheDir . md5($key) . '.json';
        $now = time();

        // Load existing data
        $data = ['requests' => [], 'blocked_until' => 0];
        if (file_exists($cacheFile)) {
            $content = @file_get_contents($cacheFile);
            if ($content) {
                $data = json_decode($content, true) ?? $data;
            }
        }

        // Check if currently blocked
        if (isset($data['blocked_until']) && $data['blocked_until'] > $now) {
            self::setRateLimitHeaders($maxRequests, 0, $data['blocked_until'] - $now);
            return false;
        }

        // Remove old requests outside window
        $windowStart = $now - $windowSeconds;
        $data['requests'] = array_filter(
            $data['requests'] ?? [],
            fn($ts) => $ts > $windowStart
        );

        // Count requests in window
        $requestCount = count($data['requests']);
        $remaining = max(0, $maxRequests - $requestCount);

        if ($requestCount >= $maxRequests) {
            // Block for the window duration
            $data['blocked_until'] = $now + $windowSeconds;
            @file_put_contents($cacheFile, json_encode($data), LOCK_EX);
            self::setRateLimitHeaders($maxRequests, 0, $windowSeconds);
            return false;
        }

        // Add current request
        $data['requests'][] = $now;
        $data['blocked_until'] = 0;
        @file_put_contents($cacheFile, json_encode($data), LOCK_EX);

        self::setRateLimitHeaders($maxRequests, $remaining - 1, $windowSeconds);
        return true;
    }

    /**
     * Rate limit by IP address
     *
     * @param int $maxRequests Maximum requests per window
     * @param int $windowSeconds Time window in seconds
     * @return bool True if allowed
     */
    public static function checkByIp(int $maxRequests = 100, int $windowSeconds = 60): bool
    {
        $ip = self::getClientIp();
        return self::check('ip:' . $ip, $maxRequests, $windowSeconds);
    }

    /**
     * Rate limit by user ID (for authenticated requests)
     *
     * @param string $userId User identifier
     * @param int $maxRequests Maximum requests per window
     * @param int $windowSeconds Time window in seconds
     * @return bool True if allowed
     */
    public static function checkByUser(string $userId, int $maxRequests = 1000, int $windowSeconds = 60): bool
    {
        return self::check('user:' . $userId, $maxRequests, $windowSeconds);
    }

    /**
     * Stricter rate limit for sensitive endpoints
     * (login, purchase verification, password reset)
     *
     * @param string|null $additionalKey Additional identifier (e.g., email, transaction_id)
     * @return bool True if allowed
     */
    public static function checkSensitive(?string $additionalKey = null): bool
    {
        $ip = self::getClientIp();
        $key = 'sensitive:' . $ip;
        if ($additionalKey) {
            $key .= ':' . md5($additionalKey);
        }
        return self::check($key, 10, 60); // 10 requests per minute
    }

    /**
     * Very strict limit for failed authentication attempts
     *
     * @param string $identifier Email or username being attempted
     * @return bool True if allowed
     */
    public static function checkAuthAttempt(string $identifier): bool
    {
        // Per-IP limit
        $ip = self::getClientIp();
        if (!self::check('auth_ip:' . $ip, 20, 300)) { // 20 attempts per 5 min per IP
            return false;
        }

        // Per-identifier limit
        return self::check('auth_id:' . md5($identifier), 5, 300); // 5 attempts per 5 min per account
    }

    /**
     * Get the real client IP address
     */
    private static function getClientIp(): string
    {
        // Check for proxy headers (in order of trust)
        $headers = [
            'HTTP_CF_CONNECTING_IP',     // Cloudflare
            'HTTP_X_REAL_IP',            // Nginx proxy
            'HTTP_X_FORWARDED_FOR',      // Standard proxy header
            'REMOTE_ADDR'                // Direct connection
        ];

        foreach ($headers as $header) {
            if (!empty($_SERVER[$header])) {
                // X-Forwarded-For can contain multiple IPs, take the first
                $ip = explode(',', $_SERVER[$header])[0];
                $ip = trim($ip);

                // Validate IP format
                if (filter_var($ip, FILTER_VALIDATE_IP)) {
                    return $ip;
                }
            }
        }

        return 'unknown';
    }

    /**
     * Set rate limit headers for response
     */
    private static function setRateLimitHeaders(int $limit, int $remaining, int $reset): void
    {
        header('X-RateLimit-Limit: ' . $limit);
        header('X-RateLimit-Remaining: ' . max(0, $remaining));
        header('X-RateLimit-Reset: ' . $reset);
    }

    /**
     * Return 429 Too Many Requests response and exit
     */
    public static function tooManyRequests(): void
    {
        http_response_code(429);
        header('Retry-After: 60');
        echo json_encode([
            'success' => false,
            'error' => 'Too Many Requests',
            'message' => 'Rate limit exceeded. Please wait before retrying.',
            'retry_after' => 60
        ]);
        exit;
    }

    /**
     * Clean up old rate limit cache files
     * Should be called periodically (e.g., via cron)
     */
    public static function cleanup(): int
    {
        if (!is_dir(self::$cacheDir)) {
            return 0;
        }

        $deleted = 0;
        $now = time();
        $maxAge = 3600; // Files older than 1 hour

        foreach (glob(self::$cacheDir . '*.json') as $file) {
            if (filemtime($file) < ($now - $maxAge)) {
                if (@unlink($file)) {
                    $deleted++;
                }
            }
        }

        return $deleted;
    }
}
