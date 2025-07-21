<?php
// /api/vehicles/add.php

header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../utils/security.php';

require_auth();
require_role('car_owner');

$input = json_decode(file_get_contents('php://input'), true);

// Basic validation
if (empty($input['make']) || empty($input['model']) || empty($input['year']) || empty($input['body_style']) || empty($input['fuel_type']) || empty($input['transmission']) || empty($input['registration_number'])) {
    echo json_encode(['success' => false, 'message' => 'Please fill in all required fields.']);
    exit;
}

$owner_id = $_SESSION['user_id'];
$make_id = filter_var($input['make'], FILTER_VALIDATE_INT);
$model_id = filter_var($input['model'], FILTER_VALIDATE_INT);
$year = filter_var($input['year'], FILTER_VALIDATE_INT);
$body_style_id = filter_var($input['body_style'], FILTER_VALIDATE_INT);
$fuel_type_id = filter_var($input['fuel_type'], FILTER_VALIDATE_INT);
$transmission_id = filter_var($input['transmission'], FILTER_VALIDATE_INT);
$registration_number = filter_var($input['registration_number'], FILTER_SANITIZE_STRING);

try {
    $stmt = $pdo->prepare(
        "INSERT INTO vehicles (owner_id, make_id, model_id, year, body_style_id, fuel_type_id, transmission_id, registration_number)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    );
    $stmt->execute([$owner_id, $make_id, $model_id, $year, $body_style_id, $fuel_type_id, $transmission_id, $registration_number]);

    echo json_encode([
        'success' => true,
        'message' => 'Vehicle added successfully.',
        'redirect' => BASE_URL . 'dashboard/owner/vehicles.php'
    ]);

} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
