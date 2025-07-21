<?php
// /auth/forgot-password.php

// --- Configuration and Header ---
require_once __DIR__ . '/../config/config.php';
include_once INCLUDES_DIR . '/header.php';
?>

<div class="flex items-center justify-center min-h-screen bg-gray-100">
    <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">

        <!-- Page Title and Instructions -->
        <h1 class="text-2xl font-bold text-center text-gray-900">Forgot Your Password?</h1>
        <p class="text-center text-gray-600">
            Enter your phone number below, and we'll send you a code to reset your password.
        </p>

        <!-- Forgot Password Form -->
        <form id="forgot-password-form" class="space-y-6">

            <!-- Phone Number Input -->
            <div class="relative">
                <label for="phone" class="sr-only">Phone Number</label>
                <input type="tel" id="phone" name="phone" required
                       class="w-full px-4 py-3 text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                       placeholder="Enter your phone number">
                <div id="phone-error" class="text-red-500 text-sm mt-1"></div>
            </div>

            <!-- Submit Button -->
            <div>
                <button type="submit"
                        class="w-full px-4 py-3 font-semibold text-white bg-slate-800 rounded-lg hover:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500">
                    Send Reset Code
                </button>
            </div>
        </form>

        <!-- Login Link -->
        <p class="text-sm text-center text-gray-600">
            Remember your password? <a href="<?php echo BASE_URL; ?>auth/login.php" class="font-medium text-blue-600 hover:underline">Log in</a>
        </p>
    </div>
</div>

<?php
// --- Footer ---
include_once INCLUDES_DIR . '/footer.php';
?>
