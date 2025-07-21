<?php
// /auth/verify-phone.php

// --- Configuration and Header ---
require_once __DIR__ . '/../config/config.php';
include_once INCLUDES_DIR . '/header.php';

// --- User ID Check ---
// Ensure the user_id is present in the URL, as it's required to identify the user.
if (!isset($_GET['user_id'])) {
    // If no user_id is provided, redirect to the registration page.
    header('Location: ' . BASE_URL . 'auth/register.php');
    exit;
}
$user_id = $_GET['user_id'];
?>

<div class="flex items-center justify-center min-h-screen bg-gray-100">
    <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">

        <!-- Page Title and Instructions -->
        <h1 class="text-2xl font-bold text-center text-gray-900">Verify Your Phone Number</h1>
        <p class="text-center text-gray-600">
            A 6-digit code has been sent to your phone. Please enter it below.
        </p>

        <!-- Verification Form -->
        <form id="verify-form" class="space-y-6">

            <!-- Hidden User ID -->
            <input type="hidden" name="user_id" value="<?php echo htmlspecialchars($user_id); ?>">

            <!-- Verification Code Input -->
            <div class="relative">
                <label for="verification-code" class="sr-only">Verification Code</label>
                <input type="text" id="verification-code" name="verification_code" required
                       class="w-full px-4 py-3 text-center text-lg tracking-[0.5em] font-semibold text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                       placeholder="______"
                       maxlength="6">
                <div id="code-error" class="text-red-500 text-sm mt-1 text-center"></div>
            </div>

            <!-- Submit Button -->
            <div>
                <button type="submit"
                        class="w-full px-4 py-3 font-semibold text-white bg-slate-800 rounded-lg hover:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500">
                    Verify
                </button>
            </div>
        </form>

        <!-- Resend Code Link -->
        <div class="text-center">
            <a href="#" id="resend-code" class="text-sm text-blue-600 hover:underline">Resend Code</a>
        </div>
    </div>
</div>

<?php
// --- Footer ---
include_once INCLUDES_DIR . '/footer.php';
?>
