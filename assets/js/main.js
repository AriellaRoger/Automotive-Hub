// /assets/js/main.js

// --- DOMContentLoaded Event Listener ---
// This ensures that the script runs only after the entire HTML document has been loaded and parsed.
// It's a best practice to prevent errors from trying to access DOM elements that haven't been created yet.
document.addEventListener('DOMContentLoaded', function() {

    // --- Element Selections ---
    // Caching DOM elements that will be used, improving performance by reducing redundant queries.
    const countrySelect = document.getElementById('country');
    const citySelect = document.getElementById('city');

    // --- Check if Country and City Selects Exist ---
    // This script should only run on pages where the country and city dropdowns are present,
    // such as the registration page.
    if (countrySelect && citySelect) {
        let allCities = {}; // Variable to store the city data from the API.

        // --- Fetch Location Data ---
        // An asynchronous function to get country and city data from the API.
        async function fetchLocations() {
            try {
                const response = await fetch('/api/auth/get-locations.php');
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                const data = await response.json();

                if (data.success) {
                    // Populate the country dropdown with the fetched data.
                    populateCountries(data.countries);
                    // Store the city data for later use.
                    allCities = data.cities;
                } else {
                    console.error('Failed to load locations:', data.message);
                }
            } catch (error) {
                console.error('Error fetching locations:', error);
            }
        }

        // --- Populate Countries Dropdown ---
        // Fills the country select element with options from the API data.
        function populateCountries(countries) {
            countrySelect.innerHTML = '<option value="">Select Country</option>'; // Default option.
            countries.forEach(country => {
                const option = document.createElement('option');
                option.value = country.id;
                option.textContent = country.name;
                countrySelect.appendChild(option);
            });
        }

        // --- Populate Cities Dropdown ---
        // Fills the city select element based on the selected country.
        function populateCities(countryId) {
            citySelect.innerHTML = '<option value="">Select City</option>'; // Default option.
            const cities = allCities[countryId] || [];
            cities.forEach(city => {
                const option = document.createElement('option');
                option.value = city.id;
                option.textContent = city.name;
                citySelect.appendChild(option);
            });
            citySelect.disabled = false; // Enable the city dropdown.
        }

        // --- Event Listener for Country Selection ---
        // When the user selects a country, this triggers the population of the city dropdown.
        countrySelect.addEventListener('change', function() {
            const selectedCountryId = this.value;
            if (selectedCountryId) {
                populateCities(selectedCountryId);
            } else {
                citySelect.innerHTML = '<option value="">Select City</option>';
                citySelect.disabled = true; // Disable city dropdown if no country is selected.
            }
        });

        // --- Initial Fetch ---
        // Call the function to fetch locations when the page loads.
        fetchLocations();
    }

    // --- Registration Form Submission ---
    const registerForm = document.getElementById('register-form');
    if (registerForm) {
        registerForm.addEventListener('submit', async function(e) {
            e.preventDefault(); // Prevent default form submission

            const formData = new FormData(this);
            const data = Object.fromEntries(formData.entries());

            try {
                const response = await fetch('/api/auth/register.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                });

                const result = await response.json();

                if (result.success) {
                    // Redirect to the verification page
                    window.location.href = result.redirect;
                } else {
                    // Display error messages
                    alert(result.message);
                }
            } catch (error) {
                console.error('Error during registration:', error);
                alert('An unexpected error occurred. Please try again.');
            }
        });
    }

    // --- Phone Verification Form Submission ---
    const verifyForm = document.getElementById('verify-form');
    if (verifyForm) {
        verifyForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            const data = Object.fromEntries(formData.entries());

            try {
                const response = await fetch('/api/auth/verify-phone.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                });

                const result = await response.json();

                if (result.success) {
                    alert(result.message);
                    window.location.href = result.redirect;
                } else {
                    document.getElementById('code-error').textContent = result.message;
                }
            } catch (error) {
                console.error('Error during verification:', error);
                alert('An unexpected error occurred. Please try again.');
            }
        });
    }

    // --- Login Form Submission ---
    const loginForm = document.getElementById('login-form');
    if (loginForm) {
        loginForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            const data = Object.fromEntries(formData.entries());

            try {
                const response = await fetch('/api/auth/login.php', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                });

                const result = await response.json();

                if (result.success) {
                    window.location.href = result.redirect;
                } else {
                    alert(result.message);
                }
            } catch (error) {
                console.error('Error during login:', error);
                alert('An unexpected error occurred. Please try again.');
            }
        });
    }

    // --- Forgot Password Form Submission ---
    const forgotPasswordForm = document.getElementById('forgot-password-form');
    if (forgotPasswordForm) {
        forgotPasswordForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const data = Object.fromEntries(formData.entries());

            try {
                const response = await fetch('/api/auth/request-password-reset.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
                const result = await response.json();
                alert(result.message);
                if (result.success && result.redirect) {
                    window.location.href = result.redirect;
                }
            } catch (error) {
                console.error('Error requesting password reset:', error);
                alert('An unexpected error occurred.');
            }
        });
    }

    // --- Reset Password Form Submission ---
    const resetPasswordForm = document.getElementById('reset-password-form');
    if (resetPasswordForm) {
        resetPasswordForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const data = Object.fromEntries(formData.entries());

            try {
                const response = await fetch('/api/auth/reset-password.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
                const result = await response.json();
                if (result.success) {
                    alert(result.message);
                    window.location.href = result.redirect;
                } else {
                    document.getElementById('reset-error').textContent = result.message;
                }
            } catch (error) {
                console.error('Error resetting password:', error);
                alert('An unexpected error occurred.');
            }
        });
    }

    // --- Add Vehicle Form ---
    const addVehicleForm = document.getElementById('add-vehicle-form');
    if (addVehicleForm) {
        const makeSelect = document.getElementById('make');
        const modelSelect = document.getElementById('model');
        let allModels = {};

        async function fetchVehicleCatalog() {
            try {
                const response = await fetch('/api/vehicles/get-vehicle-catalog.php');
                const data = await response.json();
                if (data.success) {
                    populateSelect(document.getElementById('make'), data.makes, 'Select Make');
                    populateSelect(document.getElementById('body-style'), data.body_styles, 'Select Body Style');
                    populateSelect(document.getElementById('fuel-type'), data.fuel_types, 'Select Fuel Type');
                    populateSelect(document.getElementById('transmission'), data.transmissions, 'Select Transmission');
                    allModels = data.models;
                }
            } catch (error) {
                console.error('Error fetching vehicle catalog:', error);
            }
        }

        function populateSelect(selectElement, items, defaultOptionText) {
            selectElement.innerHTML = `<option value="">${defaultOptionText}</option>`;
            items.forEach(item => {
                const option = document.createElement('option');
                option.value = item.id;
                option.textContent = item.name;
                selectElement.appendChild(option);
            });
        }

        makeSelect.addEventListener('change', function() {
            const makeId = this.value;
            if (makeId) {
                populateSelect(modelSelect, allModels[makeId] || [], 'Select Model');
                modelSelect.disabled = false;
            } else {
                modelSelect.innerHTML = '<option value="">Select Model</option>';
                modelSelect.disabled = true;
            }
        });

        addVehicleForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            const data = Object.fromEntries(formData.entries());

            try {
                const response = await fetch('/api/vehicles/add.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
                const result = await response.json();
                if (result.success) {
                    alert(result.message);
                    window.location.href = result.redirect;
                } else {
                    alert(result.message);
                }
            } catch (error) {
                console.error('Error adding vehicle:', error);
                alert('An unexpected error occurred.');
            }
        });

        fetchVehicleCatalog();
    }

    // --- Vehicle List ---
    const vehicleList = document.getElementById('vehicle-list');
    if (vehicleList) {
        async function fetchVehicles() {
            try {
                const response = await fetch('/api/vehicles/get.php');
                const data = await response.json();
                if (data.success) {
                    displayVehicles(data.vehicles);
                }
            } catch (error) {
                console.error('Error fetching vehicles:', error);
            }
        }

        function displayVehicles(vehicles) {
            vehicleList.innerHTML = '';
            if (vehicles.length === 0) {
                vehicleList.innerHTML = '<p>You have not added any vehicles yet.</p>';
                return;
            }
            vehicles.forEach(vehicle => {
                const vehicleCard = `
                    <div class="bg-white p-4 rounded-lg shadow">
                        <h3 class="text-lg font-bold">${vehicle.make} ${vehicle.model}</h3>
                        <p class="text-gray-600">${vehicle.year}</p>
                        <p class="text-gray-800">${vehicle.registration_number}</p>
                    </div>
                `;
                vehicleList.innerHTML += vehicleCard;
            });
        }

        fetchVehicles();
    }

    // --- Service History Page ---
    const vehicleSelect = document.getElementById('vehicle-select');
    if (vehicleSelect) {
        async function fetchUserVehicles() {
            try {
                const response = await fetch('/api/vehicles/get.php');
                const data = await response.json();
                if (data.success) {
                    populateVehicleSelect(data.vehicles);
                }
            } catch (error) {
                console.error('Error fetching user vehicles:', error);
            }
        }

        function populateVehicleSelect(vehicles) {
            vehicleSelect.innerHTML = '<option value="">Select a vehicle</option>';
            vehicles.forEach(vehicle => {
                const option = document.createElement('option');
                option.value = vehicle.id;
                option.textContent = `${vehicle.make} ${vehicle.model} (${vehicle.registration_number})`;
                vehicleSelect.appendChild(option);
            });
        }

        vehicleSelect.addEventListener('change', async function() {
            const vehicleId = this.value;
            const historyContainer = document.getElementById('service-history-container');
            const historyBody = document.getElementById('service-history-body');

            if (vehicleId) {
                try {
                    const response = await fetch(`/api/services/get-history.php?vehicle_id=${vehicleId}`);
                    const data = await response.json();
                    if (data.success) {
                        document.getElementById('selected-vehicle-name').textContent = this.options[this.selectedIndex].text;
                        historyContainer.classList.remove('hidden');
                        displayServiceHistory(data.history);
                    }
                } catch (error) {
                    console.error('Error fetching service history:', error);
                }
            } else {
                historyContainer.classList.add('hidden');
            }
        });

        function displayServiceHistory(history) {
            const historyBody = document.getElementById('service-history-body');
            historyBody.innerHTML = '';
            if (history.length === 0) {
                historyBody.innerHTML = '<tr><td colspan="4" class="text-center py-4">No service history found for this vehicle.</td></tr>';
                return;
            }
            history.forEach(record => {
                const row = `
                    <tr>
                        <td class="border-t px-4 py-2">${record.preferred_date}</td>
                        <td class="border-t px-4 py-2">${record.service_category}</td>
                        <td class="border-t px-4 py-2">${record.service_description}</td>
                        <td class="border-t px-4 py-2">${record.actual_cost}</td>
                    </tr>
                `;
                historyBody.innerHTML += row;
            });
        }

        fetchUserVehicles();
    }

    // --- Marketplace Listings ---
    const vehicleListings = document.getElementById('vehicle-listings');
    if (vehicleListings) {
        async function fetchListings() {
            try {
                const response = await fetch('/api/marketplace/get-listings.php');
                const data = await response.json();
                if (data.success) {
                    displayListings(data.listings);
                }
            } catch (error) {
                console.error('Error fetching listings:', error);
            }
        }

        function displayListings(listings) {
            vehicleListings.innerHTML = '';
            if (listings.length === 0) {
                vehicleListings.innerHTML = '<p>No vehicles are currently listed for sale.</p>';
                return;
            }
            listings.forEach(listing => {
                const imageUrl = (listing.images && listing.images.length > 0) ? listing.images[0] : 'https://placehold.co/300x200/e2e8f0/334155?text=No+Image';
                const listingCard = `
                    <div class="bg-white rounded-lg shadow-md overflow-hidden transform hover:scale-105 transition-transform duration-300">
                        <a href="vehicle-details.php?id=${listing.id}">
                            <img src="${imageUrl}" alt="${listing.make} ${listing.model}" class="w-full h-48 object-cover">
                            <div class="p-4">
                                <h3 class="text-lg font-bold text-gray-800">${listing.year} ${listing.make} ${listing.model}</h3>
                                <p class="text-xl font-semibold text-blue-600 mt-2">$${parseInt(listing.price).toLocaleString()}</p>
                                <p class="text-sm text-gray-600 mt-1">${parseInt(listing.mileage).toLocaleString()} km</p>
                                <p class="text-sm text-gray-500 mt-2"><i class="lucide-map-pin"></i> ${listing.city}</p>
                            </div>
                        </a>
                    </div>
                `;
                vehicleListings.innerHTML += listingCard;
            });
            lucide.createIcons();
        }

        fetchListings();
    }
});
