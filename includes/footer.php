<?php
// /includes/footer.php

// This file serves as the common footer for all pages. It closes the main
// application container and the HTML body, and includes the primary JavaScript
// file for site-wide functionality.
?>

    </div> <!-- Close the #app container -->

    <!-- Main JavaScript File -->
    <script src="<?php echo BASE_URL; ?>assets/js/main.js"></script>

    <script>
        // Initialize Lucide Icons
        // This function finds all elements with the `data-lucide` attribute
        // and replaces them with the corresponding SVG icon.
        lucide.createIcons();
    </script>
</body>
</html>
