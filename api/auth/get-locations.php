<?php
// /api/auth/get-locations.php

// --- Configuration and CORS ---
// Include the database configuration and set headers to allow cross-origin requests.
// This is important for APIs that might be accessed from different domains or subdomains.
header('Content-Type: application/json');
require_once __DIR__ . '/../../config/config.php';

// --- Fetch Countries ---
// Retrieve all active countries from the database, ordered by name.
// This query selects the ID and name for each country to populate the dropdown.
try {
    $country_stmt = $pdo->query("SELECT id, name FROM countries WHERE status = 'active' ORDER BY name ASC");
    $countries = $country_stmt->fetchAll(PDO::FETCH_ASSOC);

    // --- Fetch Cities ---
    // Retrieve all active cities, grouped by their country ID.
    // This allows for efficient mapping of cities to their respective countries.
    $city_stmt = $pdo->query("SELECT id, name, country_id FROM cities WHERE status = 'active' ORDER BY name ASC");
    $all_cities = $city_stmt->fetchAll(PDO::FETCH_ASSOC);

    // --- Group Cities by Country ---
    // Organize the flat list of cities into a structured array where keys are country IDs.
    $cities_by_country = [];
    foreach ($all_cities as $city) {
        $cities_by_country[$city['country_id']][] = [
            'id' => $city['id'],
            'name' => $city['name']
        ];
    }

    // --- Response ---
    // Return a JSON response containing the list of countries and the grouped cities.
    // This structure makes it easy for the frontend to populate and update the dropdowns.
    echo json_encode([
        'success' => true,
        'countries' => $countries,
        'cities' => $cities_by_country
    ]);

} catch (PDOException $e) {
    // --- Error Handling ---
    // If there's a database error, return a JSON response with an error message.
    // This ensures that the frontend can handle the failure gracefully.
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
