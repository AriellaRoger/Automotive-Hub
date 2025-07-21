<?php
// /config/config.php

// --- Error Reporting ---
// Determines the level of error reporting.
// In a development environment, it's useful to see all errors to catch potential issues early.
// In production, this should be set to E_ALL & ~E_NOTICE to avoid showing non-critical errors to users.
error_reporting(E_ALL);
ini_set('display_errors', 1); // Display errors on screen. Should be 0 in production.

// --- Timezone ---
// Sets the default timezone for all date/time functions in the script.
// This ensures consistency in how timestamps are handled across the application.
date_default_timezone_set('UTC');

// --- Session Management ---
// Starts a new or resumes an existing session.
// This is necessary for maintaining user login status and other session-based data.
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

// --- Base URL ---
// Defines the root URL of the application.
// This is crucial for creating absolute URLs, which prevents issues with broken links and assets.
// It dynamically determines whether the server is using HTTP or HTTPS.
$protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
$host = $_SERVER['HTTP_HOST'];
define('BASE_URL', $protocol . $host . '/'); // The trailing slash is important.

// --- Directory Paths ---
// Defines absolute paths to key directories in the application structure.
// Using absolute paths (via __DIR__) makes file includes and requires more reliable,
// as it avoids issues with relative paths that can change depending on the script's location.
define('DIR', __DIR__ . '/../'); // The root directory of the project.
define('CONFIG_DIR', DIR . 'config');
define('INCLUDES_DIR', DIR . 'includes');
define('AUTH_DIR', DIR . 'auth');
define('DASHBOARD_DIR', DIR . 'dashboard');
define('API_DIR', DIR . 'api');
define('ASSETS_DIR', DIR . 'assets');
define('UPLOADS_DIR', DIR . 'uploads');
define('UTILS_DIR', DIR . 'utils');

// --- Database Connection ---
// Includes the database configuration and connection file.
// This makes the $pdo object available globally in any script that includes this config file.
require_once CONFIG_DIR . '/database.php';

?>
