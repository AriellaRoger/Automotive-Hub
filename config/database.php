<?php
// /config/database.php

// --- Database Configuration ---
// Specifies the connection details for the application's database.
define('DB_HOST', 'localhost'); // The hostname of the database server.
define('DB_USER', 'root');      // The username for database access.
define('DB_PASS', '');          // The password for the database user.
define('DB_NAME', 'cariella');  // The name of the database.

// --- PDO DSN (Data Source Name) ---
// This combines the database type, host, and name into a single connection string.
$dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4";

// --- PDO Options ---
// An array of options to configure the PDO connection.
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,      // Throw exceptions on errors.
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,            // Fetch results as associative arrays.
    PDO::ATTR_EMULATE_PREPARES   => false,                     // Disable emulation of prepared statements for security.
];

// --- PDO Connection ---
// This block attempts to create a new PDO instance to establish the database connection.
// If the connection fails, it catches the PDOException and displays an error message.
try {
    $pdo = new PDO($dsn, DB_USER, DB_PASS, $options);
} catch (\PDOException $e) {
    // It is crucial to handle connection errors gracefully.
    // In a production environment, you would log this error and show a generic message.
    throw new \PDOException($e->getMessage(), (int)$e->getCode());
}
?>
