<?php
// /api/auth/request-password-reset.php

// --- Configuration and CORS ---
header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';

// --- Input Handling ---
$input = json_decode(file_get_contents('php://input'), true);

// --- Basic Validation ---
if (empty($input['phone'])) {
    echo json_encode(['success' => false, 'message' => 'Please enter your phone number.']);
    exit;
}

$phone = filter_var($input['phone'], FILTER_SANITIZE_STRING);

// --- Check if User Exists ---
try {
    $stmt = $pdo->prepare("SELECT id FROM users WHERE phone = ?");
    $stmt->execute([$phone]);
    $user = $stmt->fetch();

    if (!$user) {
        // We send a generic success message to prevent user enumeration.
        echo json_encode(['success' => true, 'message' => 'If a user with that phone number exists, a reset code has been sent.']);
        exit;
    }

    // --- Generate and Store Reset Code ---
    $reset_code = rand(100000, 999999);
    $reset_expires = date('Y-m-d H:i:s', strtotime('+30 minutes'));

    $update_stmt = $pdo->prepare("UPDATE users SET phone_verification_code = ?, phone_verification_expires = ? WHERE id = ?");
    $update_stmt->execute([$reset_code, $reset_expires, $user['id']]);

    // --- Send Reset Code (Simulation) ---
    // In a real application, you would integrate with an SMS gateway to send the code.
    // For now, we assume the code is sent.

    echo json_encode([
        'success' => true,
        'message' => 'A password reset code has been sent to your phone.',
        'redirect' => BASE_URL . 'auth/reset-password.php?user_id=' . $user['id']
    ]);

} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
