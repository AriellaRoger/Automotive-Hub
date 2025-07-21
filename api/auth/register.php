<?php
// /api/auth/register.php

// --- Configuration and CORS ---
header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';

// --- Input Handling ---
// Decode the JSON input from the request body into a PHP associative array.
$input = json_decode(file_get_contents('php://input'), true);

// --- Basic Validation ---
// Check for the presence of required fields. If any are missing, return an error.
if (empty($input['phone']) || empty($input['country']) || empty($input['city']) || empty($input['password'])) {
    echo json_encode(['success' => false, 'message' => 'Please fill in all required fields.']);
    exit;
}

// --- Data Sanitization ---
// Sanitize the input data to prevent security vulnerabilities like XSS.
$phone = filter_var($input['phone'], FILTER_SANITIZE_STRING);
$country_id = filter_var($input['country'], FILTER_VALIDATE_INT);
$city_id = filter_var($input['city'], FILTER_VALIDATE_INT);
$password = $input['password']; // Password will be hashed, not sanitized as a string.

// --- Server-Side Validation ---
// Validate the data more thoroughly.
if (!$country_id || !$city_id) {
    echo json_encode(['success' => false, 'message' => 'Invalid country or city selected.']);
    exit;
}
if (strlen($password) < 8) {
    echo json_encode(['success' => false, 'message' => 'Password must be at least 8 characters long.']);
    exit;
}

// --- Check for Existing User ---
// Prevents duplicate registrations with the same phone number.
try {
    $stmt = $pdo->prepare("SELECT id FROM users WHERE phone = ?");
    $stmt->execute([$phone]);
    if ($stmt->fetch()) {
        echo json_encode(['success' => false, 'message' => 'A user with this phone number already exists.']);
        exit;
    }
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    exit;
}

// --- Phone Verification Code ---
// Generate a temporary 6-digit code for phone verification.
$verification_code = rand(100000, 999999);
// Set the code to expire in 30 minutes.
$verification_expires = date('Y-m-d H:i:s', strtotime('+30 minutes'));

// --- Password Hashing ---
// Hash the password for secure storage.
$password_hash = password_hash($password, PASSWORD_BCRYPT);

// --- Database Insertion ---
// Insert the new user record into the database with a 'pending' status.
try {
    $stmt = $pdo->prepare(
        "INSERT INTO users (phone, country_id, city_id, password_hash, user_type, status, phone_verification_code, phone_verification_expires)
         VALUES (?, ?, ?, ?, 'car_owner', 'pending', ?, ?)"
    );
    $stmt->execute([$phone, $country_id, $city_id, $password_hash, $verification_code, $verification_expires]);

    $user_id = $pdo->lastInsertId();

    // --- Success Response ---
    // In a real application, this is where you would trigger an SMS to be sent with the verification code.
    // For now, we'll return a success message and redirect the user to the verification page.
    echo json_encode([
        'success' => true,
        'message' => 'Registration successful. Please verify your phone number.',
        'redirect' => BASE_URL . 'auth/verify-phone.php?user_id=' . $user_id
    ]);

} catch (PDOException $e) {
    // --- Error Handling ---
    echo json_encode(['success' => false, 'message' => 'Database error during registration: ' . $e->getMessage()]);
}
?>
