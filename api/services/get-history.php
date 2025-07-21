<?php
// /api/services/get-history.php

header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../utils/security.php';

require_auth();
require_role('car_owner');

$vehicle_id = isset($_GET['vehicle_id']) ? filter_var($_GET['vehicle_id'], FILTER_VALIDATE_INT) : null;

if (!$vehicle_id) {
    echo json_encode(['success' => false, 'message' => 'Vehicle ID is required.']);
    exit;
}

try {
    $stmt = $pdo->prepare(
        "SELECT sr.preferred_date, sc.name as service_category, sr.service_description, sr.actual_cost
         FROM service_requests sr
         JOIN service_categories sc ON sr.service_category_id = sc.id
         WHERE sr.vehicle_id = ? AND sr.status = 'completed'
         ORDER BY sr.preferred_date DESC"
    );
    $stmt->execute([$vehicle_id]);
    $history = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode(['success' => true, 'history' => $history]);

} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
