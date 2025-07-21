<?php
// /auth/login.php

// --- Configuration and Header ---
require_once __DIR__ . '/../config/config.php';
include_once INCLUDES_DIR . '/header.php';
?>

<div class="flex items-center justify-center min-h-screen bg-gray-100">
    <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">

        <!-- Page Title -->
        <h1 class="text-2xl font-bold text-center text-gray-900">Log in to your Account</h1>

        <!-- Login Form -->
        <form id="login-form" class="space-y-6">

            <!-- Phone Number Input -->
            <div class="relative">
                <label for="phone" class="sr-only">Phone Number</label>
                <input type="tel" id="phone" name="phone" required
                       class="w-full px-4 py-3 text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                       placeholder="Enter your phone number">
                <div id="phone-error" class="text-red-500 text-sm mt-1"></div>
            </div>

            <!-- Password Input -->
            <div class="relative">
                <label for="password" class="sr-only">Password</label>
                <input type="password" id="password" name="password" required
                       class="w-full px-4 py-3 text-gray-700 bg-gray-50 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500"
                       placeholder="Enter your password">
                <div id="password-error" class="text-red-500 text-sm mt-1"></div>
            </div>

            <!-- Remember Me & Forgot Password -->
            <div class="flex items-center justify-between">
                <div class="flex items-center">
                    <input id="remember-me" name="remember-me" type="checkbox" class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                    <label for="remember-me" class="ml-2 block text-sm text-gray-900">Remember me</label>
                </div>
                <div class="text-sm">
                    <a href="<?php echo BASE_URL; ?>auth/forgot-password.php" class="font-medium text-blue-600 hover:underline">
                        Forgot your password?
                    </a>
                </div>
            </div>

            <!-- Submit Button -->
            <div>
                <button type="submit"
                        class="w-full px-4 py-3 font-semibold text-white bg-slate-800 rounded-lg hover:bg-slate-900 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500">
                    Log in
                </button>
            </div>
        </form>

        <!-- Registration Link -->
        <p class="text-sm text-center text-gray-600">
            Don't have an account? <a href="<?php echo BASE_URL; ?>auth/register.php" class="font-medium text-blue-600 hover:underline">Sign up</a>
        </p>
    </div>
</div>

<?php
// --- Footer ---
include_once INCLUDES_DIR . '/footer.php';
?>
