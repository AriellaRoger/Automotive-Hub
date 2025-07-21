<?php
// /auth/register.php

// --- Configuration and Header ---
// Initializes the application's configuration and includes the common header.
// The config file sets up constants for paths and the database connection.
require_once __DIR__ . '/../config/config.php';
include_once INCLUDES_DIR . '/header.php';
?>

<div class="flex items-center justify-center min-h-screen bg-gray-100">
    <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">

        <!-- Page Title -->
        <h1 class="text-2xl font-bold text-center text-gray-900">Create your Cariella Account</h1>

        <!-- Registration Form -->
        <form id="register-form" class="space-y-6">

            <!-- Phone Number Input -->
            <div class="relative">
                <label for="phone" class="sr-only">Phone Number</label>
                <input type="tel" id="phone" name="phone" required
                       class="w-full px-4 py-3 text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                       placeholder="Enter your phone number">
                <div id="phone-error" class="text-red-500 text-sm mt-1"></div>
            </div>

            <!-- Country Select -->
            <div class="relative">
                <label for="country" class="sr-only">Country</label>
                <select id="country" name="country" required
                        class="w-full px-4 py-3 text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500">
                    <!-- Options will be loaded dynamically -->
                </select>
                <div id="country-error" class="text-red-500 text-sm mt-1"></div>
            </div>

            <!-- City Select -->
            <div class="relative">
                <label for="city" class="sr-only">City</label>
                <select id="city" name="city" required
                        class="w-full px-4 py-3 text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500">
                    <!-- Options will be loaded based on country selection -->
                </select>
                <div id="city-error" class="text-red-500 text-sm mt-1"></div>
            </div>

            <!-- Password Input -->
            <div class="relative">
                <label for="password" class="sr-only">Password</label>
                <input type="password" id="password" name="password" required
                       class="w-full px-4 py-3 text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                       placeholder="Create a password">
                <div id="password-error" class="text-red-500 text-sm mt-1"></div>
            </div>

            <!-- Submit Button -->
            <div>
                <button type="submit"
                        class="w-full px-4 py-3 font-semibold text-white bg-slate-800 rounded-lg hover:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500">
                    Register
                </button>
            </div>
        </form>

        <!-- Login Link -->
        <p class="text-sm text-center text-gray-600">
            Already have an account? <a href="<?php echo BASE_URL; ?>auth/login.php" class="font-medium text-blue-600 hover:underline">Log in</a>
        </p>
    </div>
</div>

<?php
// --- Footer ---
// Includes the common footer for the page.
include_once INCLUDES_DIR . '/footer.php';
?>
