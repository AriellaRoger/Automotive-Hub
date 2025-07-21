<?php
// /api/vehicles/get.php

header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../utils/security.php';

require_auth();
require_role('car_owner');

$owner_id = $_SESSION['user_id'];

try {
    $stmt = $pdo->prepare(
        "SELECT v.id, vm.name as make, vmo.name as model, v.year, v.registration_number
         FROM vehicles v
         JOIN vehicle_makes vm ON v.make_id = vm.id
         JOIN vehicle_models vmo ON v.model_id = vmo.id
         WHERE v.owner_id = ?
         ORDER BY vm.name, vmo.name"
    );
    $stmt->execute([$owner_id]);
    $vehicles = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode(['success' => true, 'vehicles' => $vehicles]);

} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
