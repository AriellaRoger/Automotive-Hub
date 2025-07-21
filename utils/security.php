<?php
// /utils/security.php

// --- Authentication Check ---
// Checks if a user is logged in by verifying the presence of session variables.
// If the user is not logged in, it redirects them to the login page.
function require_auth() {
    if (!isset($_SESSION['logged_in']) || !$_SESSION['logged_in']) {
        header('Location: ' . BASE_URL . 'auth/login.php');
        exit;
    }
}

// --- Role-Based Access Control ---
// Verifies that the logged-in user has the required role to access a page.
// If the user's role does not match, it redirects them to a generic access-denied page or their dashboard.
function require_role($role) {
    if (!isset($_SESSION['user_type']) || $_SESSION['user_type'] !== $role) {
        // Redirect to a generic dashboard or an error page.
        header('Location: ' . BASE_URL . 'dashboard/owner/index.php'); // Default redirect
        exit;
    }
}

// --- CSRF Token Generation ---
// Generates a Cross-Site Request Forgery (CSRF) token to protect against attacks.
// The token is stored in the session to be validated upon form submission.
function generate_csrf_token() {
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

// --- CSRF Token Validation ---
// Validates the submitted CSRF token against the one stored in the session.
// If the tokens do not match, the script will exit to prevent the request from being processed.
function validate_csrf_token($token) {
    if (!isset($_SESSION['csrf_token']) || !hash_equals($_SESSION['csrf_token'], $token)) {
        // Handle CSRF token mismatch, e.g., by displaying an error.
        die('CSRF token validation failed.');
    }
}
?>
