<?php
// /includes/header.php

// This file serves as the common header for all pages in the application.
// It includes the necessary HTML boilerplate, links to CSS stylesheets,
// and initializes the Lucide icon library.
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cariella - Your Automotive Partner</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Google Fonts: Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script>

    <!-- Custom Styles -->
    <link rel="stylesheet" href="<?php echo BASE_URL; ?>assets/css/custom.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>
<body class="bg-slate-50">

    <!-- The main content of each page will be included after this point -->
    <div id="app">
