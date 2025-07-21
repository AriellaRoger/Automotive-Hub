<?php
// /auth/reset-password.php

// --- Configuration and Header ---
require_once __DIR__ . '/../config/config.php';
include_once INCLUDES_DIR . '/header.php';

// --- User ID Check ---
if (!isset($_GET['user_id'])) {
    header('Location: ' . BASE_URL . 'auth/forgot-password.php');
    exit;
}
$user_id = $_GET['user_id'];
?>

<div class="flex items-center justify-center min-h-screen bg-gray-100">
    <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">

        <!-- Page Title -->
        <h1 class="text-2xl font-bold text-center text-gray-900">Reset Your Password</h1>

        <!-- Reset Password Form -->
        <form id="reset-password-form" class="space-y-6">

            <!-- Hidden User ID -->
            <input type="hidden" name="user_id" value="<?php echo htmlspecialchars($user_id); ?>">

            <!-- Verification Code Input -->
            <div class="relative">
                <label for="verification-code" class="sr-only">Verification Code</label>
                <input type="text" id="verification-code" name="verification_code" required
                       class="w-full px-4 py-3 text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                       placeholder="Enter the 6-digit code">
            </div>

            <!-- New Password Input -->
            <div class="relative">
                <label for="new-password" class="sr-only">New Password</label>
                <input type="password" id="new-password" name="new_password" required
                       class="w-full px-4 py-3 text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                       placeholder="Enter your new password">
            </div>

            <!-- Confirm Password Input -->
            <div class="relative">
                <label for="confirm-password" class="sr-only">Confirm Password</label>
                <input type="password" id="confirm-password" name="confirm_password" required
                       class="w-full px-4 py-3 text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                       placeholder="Confirm your new password">
            </div>

            <!-- Error Message Placeholder -->
            <div id="reset-error" class="text-red-500 text-sm mt-1"></div>

            <!-- Submit Button -->
            <div>
                <button type="submit"
                        class="w-full px-4 py-3 font-semibold text-white bg-slate-800 rounded-lg hover:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500">
                    Reset Password
                </button>
            </div>
        </form>
    </div>
</div>

<?php
// --- Footer ---
include_once INCLUDES_DIR . '/footer.php';
?>
