<?php
// /dashboard/owner/vehicles.php

// --- Configuration, Authentication, and Header ---
require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../utils/security.php'; // Includes authentication functions.

// Ensure the user is authenticated and is a car owner.
require_auth();
require_role('car_owner');

include_once INCLUDES_DIR . '/header.php';
?>

<div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-4">My Vehicles</h1>

    <!-- Add Vehicle Button -->
    <div class="mb-4">
        <a href="<?php echo BASE_URL; ?>dashboard/owner/add-vehicle.php" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
            Add New Vehicle
        </a>
    </div>

    <!-- Vehicle List -->
    <div id="vehicle-list" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <!-- Vehicles will be loaded here dynamically -->
    </div>
</div>

<?php
include_once INCLUDES_DIR . '/footer.php';
?>
