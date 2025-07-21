<?php
// /api/auth/login.php

// --- Configuration and CORS ---
header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';

// --- Input Handling ---
$input = json_decode(file_get_contents('php://input'), true);

// --- Basic Validation ---
if (empty($input['phone']) || empty($input['password'])) {
    echo json_encode(['success' => false, 'message' => 'Please enter your phone number and password.']);
    exit;
}

// --- Data Sanitization ---
$phone = filter_var($input['phone'], FILTER_SANITIZE_STRING);
$password = $input['password'];

// --- User Authentication ---
try {
    // Retrieve user data based on the provided phone number.
    $stmt = $pdo->prepare("SELECT id, password_hash, user_type, status FROM users WHERE phone = ?");
    $stmt->execute([$phone]);
    $user = $stmt->fetch();

    // --- Verification Checks ---
    // 1. Check if a user with that phone number exists.
    // 2. Verify that the provided password matches the stored hash.
    if (!$user || !password_verify($password, $user['password_hash'])) {
        echo json_encode(['success' => false, 'message' => 'Invalid phone number or password.']);
        exit;
    }

    // 3. Check if the user's account is active.
    if ($user['status'] !== 'active') {
        $message = 'Your account is not active. Please contact support.';
        if ($user['status'] === 'pending') {
            $message = 'Please verify your phone number before logging in.';
        } elseif ($user['status'] === 'suspended') {
            $message = 'Your account has been suspended.';
        }
        echo json_encode(['success' => false, 'message' => $message]);
        exit;
    }

    // --- Session Management ---
    // Upon successful authentication, store user details in the session.
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['user_type'] = $user['user_type'];
    $_SESSION['logged_in'] = true;

    // --- Update Last Login Timestamp ---
    $update_stmt = $pdo->prepare("UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?");
    $update_stmt->execute([$user['id']]);

    // --- Success Response ---
    // Redirect the user to their respective dashboard based on their user type.
    echo json_encode([
        'success' => true,
        'message' => 'Login successful.',
        'redirect' => BASE_URL . 'dashboard/' . $user['user_type'] . '/index.php'
    ]);

} catch (PDOException $e) {
    // --- Error Handling ---
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
