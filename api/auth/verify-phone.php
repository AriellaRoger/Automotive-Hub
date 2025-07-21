<?php
// /api/auth/verify-phone.php

// --- Configuration and CORS ---
header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';

// --- Input Handling ---
$input = json_decode(file_get_contents('php://input'), true);

// --- Basic Validation ---
if (empty($input['user_id']) || empty($input['verification_code'])) {
    echo json_encode(['success' => false, 'message' => 'Missing user ID or verification code.']);
    exit;
}

// --- Data Sanitization ---
$user_id = filter_var($input['user_id'], FILTER_VALIDATE_INT);
$verification_code = filter_var($input['verification_code'], FILTER_SANITIZE_STRING);

if (!$user_id) {
    echo json_encode(['success' => false, 'message' => 'Invalid user ID.']);
    exit;
}

// --- Code Verification Logic ---
try {
    // Retrieve the user's stored code and its expiration time.
    $stmt = $pdo->prepare("SELECT phone_verification_code, phone_verification_expires FROM users WHERE id = ? AND status = 'pending'");
    $stmt->execute([$user_id]);
    $user = $stmt->fetch();

    if (!$user) {
        echo json_encode(['success' => false, 'message' => 'Invalid user or account already verified.']);
        exit;
    }

    // Check if the code has expired.
    if (strtotime($user['phone_verification_expires']) < time()) {
        echo json_encode(['success' => false, 'message' => 'Verification code has expired. Please request a new one.']);
        exit;
    }

    // Check if the submitted code matches the stored code.
    if ($user['phone_verification_code'] !== $verification_code) {
        echo json_encode(['success' => false, 'message' => 'Invalid verification code.']);
        exit;
    }

    // --- Update User Status ---
    // If the code is valid, update the user's status to 'active' and mark the phone as verified.
    $update_stmt = $pdo->prepare(
        "UPDATE users SET status = 'active', phone_verified = TRUE, phone_verification_code = NULL, phone_verification_expires = NULL WHERE id = ?"
    );
    $update_stmt->execute([$user_id]);

    // --- Success Response ---
    // Redirect the user to the login page upon successful verification.
    echo json_encode([
        'success' => true,
        'message' => 'Phone number verified successfully.',
        'redirect' => BASE_URL . 'auth/login.php'
    ]);

} catch (PDOException $e) {
    // --- Error Handling ---
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
