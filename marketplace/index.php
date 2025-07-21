<?php
// /marketplace/index.php

require_once __DIR__ . '/../config/config.php';
include_once INCLUDES_DIR . '/header.php';
?>

<div class="container mx-auto p-4">
    <h1 class="text-3xl font-bold mb-6">Vehicle Marketplace</h1>

    <!-- Search and Filters -->
    <div class="mb-6 bg-white p-4 rounded-lg shadow">
        <!-- Search and filter options will be added here later -->
        <p class="text-gray-600">Search and filter options will be available soon.</p>
    </div>

    <!-- Vehicle Listings -->
    <div id="vehicle-listings" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        <!-- Vehicle listings will be loaded here dynamically -->
    </div>
</div>

<?php
include_once INCLUDES_DIR . '/footer.php';
?>
