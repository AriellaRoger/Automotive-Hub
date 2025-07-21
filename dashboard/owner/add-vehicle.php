<?php
// /dashboard/owner/add-vehicle.php

require_once __DIR__ . '/../../config/config.php';
require_once __DIR__ . '/../../utils/security.php';

require_auth();
require_role('car_owner');

include_once INCLUDES_DIR . '/header.php';
?>

<div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-4">Add a New Vehicle</h1>

    <form id="add-vehicle-form" class="max-w-lg mx-auto bg-white p-8 rounded shadow-md">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <!-- Make -->
            <div>
                <label for="make" class="block text-sm font-medium text-gray-700">Make</label>
                <select id="make" name="make" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"></select>
            </div>
            <!-- Model -->
            <div>
                <label for="model" class="block text-sm font-medium text-gray-700">Model</label>
                <select id="model" name="model" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm" disabled></select>
            </div>
            <!-- Year -->
            <div>
                <label for="year" class="block text-sm font-medium text-gray-700">Year</label>
                <input type="number" id="year" name="year" class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
            </div>
            <!-- Body Style -->
            <div>
                <label for="body-style" class="block text-sm font-medium text-gray-700">Body Style</label>
                <select id="body-style" name="body_style" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"></select>
            </div>
            <!-- Fuel Type -->
            <div>
                <label for="fuel-type" class="block text-sm font-medium text-gray-700">Fuel Type</label>
                <select id="fuel-type" name="fuel_type" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"></select>
            </div>
            <!-- Transmission -->
            <div>
                <label for="transmission" class="block text-sm font-medium text-gray-700">Transmission</label>
                <select id="transmission" name="transmission" class="mt-1 block w-full py-2 px-3 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"></select>
            </div>
            <!-- Registration Number -->
            <div class="md:col-span-2">
                <label for="registration-number" class="block text-sm font-medium text-gray-700">Registration Number</label>
                <input type="text" id="registration-number" name="registration_number" class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md">
            </div>
        </div>
        <div class="mt-6">
            <button type="submit" class="w-full bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Add Vehicle</button>
        </div>
    </form>
</div>

<?php
include_once INCLUDES_DIR . '/footer.php';
?>
