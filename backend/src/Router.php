<?php
/**
 * Routeur simple pour l'API REST
 */

namespace NfcAnycubic;

class Router {
    private $routes = [];
    private $middlewares = [];

    public function get(string $path, $handler) {
        $this->addRoute('GET', $path, $handler);
    }

    public function post(string $path, $handler) {
        $this->addRoute('POST', $path, $handler);
    }

    public function put(string $path, $handler) {
        $this->addRoute('PUT', $path, $handler);
    }

    public function delete(string $path, $handler) {
        $this->addRoute('DELETE', $path, $handler);
    }

    private function addRoute(string $method, string $path, $handler) {
        $this->routes[] = [
            'method' => $method,
            'path' => $path,
            'handler' => $handler
        ];
    }

    public function execute() {
        $method = $_SERVER['REQUEST_METHOD'];
        $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

        // HEAD = GET sans corps (curl -I, sondes de surveillance). Avant :
        // aucune route HEAD → 404 partout, l'API paraissait en panne.
        $isHead = $method === 'HEAD';
        $routeMethod = $isHead ? 'GET' : $method;

        // Remove /api prefix if present
        $uri = preg_replace('#^/api#', '', $uri);

        foreach ($this->routes as $route) {
            $pattern = preg_replace('#:(\w+)#', '(?P<$1>[^/]+)', $route['path']);
            $pattern = "#^{$pattern}$#";

            if ($route['method'] === $routeMethod && preg_match($pattern, $uri, $matches)) {
                // Extract route parameters
                $params = array_filter($matches, 'is_string', ARRAY_FILTER_USE_KEY);

                // Execute handler
                $result = $this->executeHandler($route['handler'], $params);

                // Ne pas forcer 200 : garder le code posé par le contrôleur
                // (404, 400, 500…). Avant, toutes les erreurs métier sortaient
                // en 200 + success:false → l'app prenait un PUT refusé pour un
                // succès, et les webhooks Apple ne réessayaient jamais.
                if ($result !== null && !$isHead) {
                    echo json_encode($result);
                }
                return;
            }
        }

        // 404 Not Found
        http_response_code(404);
        if ($isHead) {
            return;
        }
        echo json_encode([
            'success' => false,
            'error' => 'Route not found',
            'path' => $uri,
            'method' => $method
        ]);
    }

    private function executeHandler($handler, array $params) {
        if (is_callable($handler)) {
            return call_user_func_array($handler, [$params]);
        }

        if (is_array($handler)) {
            [$class, $method] = $handler;
            $controller = new $class();
            return call_user_func_array([$controller, $method], [$params]);
        }

        throw new \Exception("Invalid handler");
    }
}
