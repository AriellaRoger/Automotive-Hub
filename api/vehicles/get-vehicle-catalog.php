<?php
// /api/vehicles/get-vehicle-catalog.php

header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';

try {
    // Fetch all active vehicle makes
    $makes_stmt = $pdo->query("SELECT id, name FROM vehicle_makes WHERE status = 'active' ORDER BY name ASC");
    $makes = $makes_stmt->fetchAll(PDO::FETCH_ASSOC);

    // Fetch all active vehicle models, grouped by make
    $models_stmt = $pdo->query("SELECT id, name, make_id FROM vehicle_models WHERE status = 'active' ORDER BY name ASC");
    $all_models = $models_stmt->fetchAll(PDO::FETCH_ASSOC);
    $models_by_make = [];
    foreach ($all_models as $model) {
        $models_by_make[$model['make_id']][] = ['id' => $model['id'], 'name' => $model['name']];
    }

    // Fetch all active body styles
    $body_styles_stmt = $pdo->query("SELECT id, name FROM vehicle_body_styles WHERE status = 'active' ORDER BY name ASC");
    $body_styles = $body_styles_stmt->fetchAll(PDO::FETCH_ASSOC);

    // Fetch all active fuel types
    $fuel_types_stmt = $pdo->query("SELECT id, name FROM vehicle_fuel_types WHERE status = 'active' ORDER BY name ASC");
    $fuel_types = $fuel_types_stmt->fetchAll(PDO::FETCH_ASSOC);

    // Fetch all active transmissions
    $transmissions_stmt = $pdo->query("SELECT id, name FROM vehicle_transmissions WHERE status = 'active' ORDER BY name ASC");
    $transmissions = $transmissions_stmt->fetchAll(PDO::FETCH_ASSOC);

    // Return all catalog data in a single JSON response
    echo json_encode([
        'success' => true,
        'makes' => $makes,
        'models' => $models_by_make,
        'body_styles' => $body_styles,
        'fuel_types' => $fuel_types,
        'transmissions' => $transmissions,
    ]);

} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
