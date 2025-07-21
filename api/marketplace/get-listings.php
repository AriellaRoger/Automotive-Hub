<?php
// /api/marketplace/get-listings.php

header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';

try {
    $stmt = $pdo->query(
        "SELECT
            vl.id,
            vl.price,
            vl.mileage,
            vl.images,
            vm.name as make,
            vmo.name as model,
            vl.year,
            c.name as city
         FROM vehicle_listings vl
         JOIN vehicle_makes vm ON vl.make_id = vm.id
         JOIN vehicle_models vmo ON vl.model_id = vmo.id
         JOIN cities c ON vl.location_city_id = c.id
         WHERE vl.status = 'active'
         ORDER BY vl.created_at DESC"
    );
    $listings = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Decode the JSON images string into an array
    foreach ($listings as &$listing) {
        $listing['images'] = json_decode($listing['images'], true);
    }

    echo json_encode(['success' => true, 'listings' => $listings]);

} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
