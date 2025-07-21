<?php
// /dashboard/owner/service-history.php

require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../utils/security.php';

require_auth();
require_role('car_owner');

include_once INCLUDES_DIR . '/header.php';
?>

<div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-4">Service History</h1>

    <!-- Vehicle Selector -->
    <div class="mb-4 max-w-sm">
        <label for="vehicle-select" class="block text-sm font-medium text-gray-700">Select a Vehicle</label>
        <select id="vehicle-select" name="vehicle_id" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            <!-- Options will be loaded dynamically -->
        </select>
    </div>

    <!-- Service History Table -->
    <div id="service-history-container" class="hidden">
        <h2 class="text-xl font-bold mb-2">History for <span id="selected-vehicle-name"></span></h2>
        <table class="min-w-full bg-white">
            <thead class="bg-gray-800 text-white">
                <tr>
                    <th class="w-1/4 py-3 px-4 uppercase font-semibold text-sm">Date</th>
                    <th class="w-1/4 py-3 px-4 uppercase font-semibold text-sm">Service</th>
                    <th class="w-1/2 py-3 px-4 uppercase font-semibold text-sm">Description</th>
                    <th class="py-3 px-4 uppercase font-semibold text-sm">Cost</th>
                </tr>
            </thead>
            <tbody id="service-history-body" class="text-gray-700">
                <!-- Service records will be loaded here -->
            </tbody>
        </table>
    </div>
</div>

<?php
include_once INCLUDES_DIR . '/footer.php';
?>
