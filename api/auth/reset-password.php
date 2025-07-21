<?php
// /api/auth/reset-password.php

// --- Configuration and CORS ---
header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';

// --- Input Handling ---
$input = json_decode(file_get_contents('php://input'), true);

// --- Basic Validation ---
if (empty($input['user_id']) || empty($input['verification_code']) || empty($input['new_password']) || empty($input['confirm_password'])) {
    echo json_encode(['success' => false, 'message' => 'Please fill in all fields.']);
    exit;
}

// --- Data Sanitization and Validation ---
$user_id = filter_var($input['user_id'], FILTER_VALIDATE_INT);
$verification_code = filter_var($input['verification_code'], FILTER_SANITIZE_STRING);
$new_password = $input['new_password'];
$confirm_password = $input['confirm_password'];

if (!$user_id) {
    echo json_encode(['success' => false, 'message' => 'Invalid user ID.']);
    exit;
}
if ($new_password !== $confirm_password) {
    echo json_encode(['success' => false, 'message' => 'Passwords do not match.']);
    exit;
}
if (strlen($new_password) < 8) {
    echo json_encode(['success' => false, 'message' => 'Password must be at least 8 characters long.']);
    exit;
}

// --- Verify Reset Code and Update Password ---
try {
    // Check if the user and code are valid.
    $stmt = $pdo->prepare("SELECT phone_verification_code, phone_verification_expires FROM users WHERE id = ?");
    $stmt->execute([$user_id]);
    $user = $stmt->fetch();

    if (!$user || $user['phone_verification_code'] !== $verification_code) {
        echo json_encode(['success' => false, 'message' => 'Invalid verification code.']);
        exit;
    }

    if (strtotime($user['phone_verification_expires']) < time()) {
        echo json_encode(['success' => false, 'message' => 'The reset code has expired.']);
        exit;
    }

    // --- Update Password ---
    $password_hash = password_hash($new_password, PASSWORD_BCRYPT);
    $update_stmt = $pdo->prepare(
        "UPDATE users SET password_hash = ?, phone_verification_code = NULL, phone_verification_expires = NULL WHERE id = ?"
    );
    $update_stmt->execute([$password_hash, $user_id]);

    echo json_encode([
        'success' => true,
        'message' => 'Your password has been reset successfully.',
        'redirect' => BASE_URL . 'auth/login.php'
    ]);

} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
