-- Cariella - Complete Database Schema
-- For XAMPP/MySQL Environment

-- Create database
CREATE DATABASE IF NOT EXISTS cariella;
USE cariella;

-- ===================================
-- GEOGRAPHIC & REFERENCE TABLES
-- ===================================

-- Countries table with phone codes
CREATE TABLE countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(3) NOT NULL UNIQUE,
    phone_code VARCHAR(10) NOT NULL,
    currency VARCHAR(5) DEFAULT 'USD',
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Cities/Towns table
CREATE TABLE cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE,
    INDEX idx_country_city (country_id, name)
);

-- ===================================
-- VEHICLE CATALOG TABLES
-- ===================================

-- Vehicle makes
CREATE TABLE vehicle_makes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    logo_url VARCHAR(255),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Vehicle models
CREATE TABLE vehicle_models (
    id INT AUTO_INCREMENT PRIMARY KEY,
    make_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (make_id) REFERENCES vehicle_makes(id) ON DELETE CASCADE,
    INDEX idx_make_model (make_id, name)
);

-- Vehicle body styles
CREATE TABLE vehicle_body_styles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vehicle fuel types
CREATE TABLE vehicle_fuel_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vehicle transmissions
CREATE TABLE vehicle_transmissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===================================
-- USER MANAGEMENT TABLES
-- ===================================

-- Main users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    phone VARCHAR(20) NOT NULL UNIQUE,
    country_id INT NOT NULL,
    city_id INT NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_type ENUM('car_owner', 'mechanic', 'garage', 'parts_dealer', 'wholesaler', 'car_dealer', 'insurance_agent', 'admin') NOT NULL,
    status ENUM('active', 'inactive', 'pending', 'suspended') DEFAULT 'active',
    email VARCHAR(100),
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    phone_verification_code VARCHAR(6),
    phone_verification_expires TIMESTAMP NULL,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES countries(id),
    FOREIGN KEY (city_id) REFERENCES cities(id),
    INDEX idx_phone (phone),
    INDEX idx_user_type (user_type),
    INDEX idx_status (status)
);

-- User profiles
CREATE TABLE user_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    profile_image VARCHAR(255),
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other'),
    address TEXT,
    bio TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Service provider applications
CREATE TABLE service_provider_applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    business_name VARCHAR(100),
    business_registration VARCHAR(50),
    license_number VARCHAR(50),
    experience_years INT,
    specializations JSON,
    documents JSON, -- Store document URLs
    portfolio JSON, -- Store portfolio URLs
    status ENUM('pending', 'approved', 'rejected', 'under_review') DEFAULT 'pending',
    admin_notes TEXT,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP NULL,
    reviewed_by INT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(id),
    INDEX idx_status (status)
);

-- ===================================
-- VEHICLE OWNERSHIP TABLES
-- ===================================

-- Registered vehicles
CREATE TABLE vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    make_id INT NOT NULL,
    model_id INT NOT NULL,
    year INT NOT NULL,
    body_style_id INT NOT NULL,
    fuel_type_id INT NOT NULL,
    transmission_id INT NOT NULL,
    registration_number VARCHAR(20) NOT NULL,
    chassis_number VARCHAR(50),
    engine_number VARCHAR(50),
    color VARCHAR(30),
    mileage INT DEFAULT 0,
    images JSON, -- Store image URLs
    status ENUM('active', 'inactive', 'sold') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (make_id) REFERENCES vehicle_makes(id),
    FOREIGN KEY (model_id) REFERENCES vehicle_models(id),
    FOREIGN KEY (body_style_id) REFERENCES vehicle_body_styles(id),
    FOREIGN KEY (fuel_type_id) REFERENCES vehicle_fuel_types(id),
    FOREIGN KEY (transmission_id) REFERENCES vehicle_transmissions(id),
    INDEX idx_owner (owner_id),
    INDEX idx_registration (registration_number)
);

-- ===================================
-- PARTS CATALOG TABLES
-- ===================================

-- Parts categories
CREATE TABLE parts_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INT NULL,
    description TEXT,
    image_url VARCHAR(255),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES parts_categories(id) ON DELETE SET NULL,
    INDEX idx_parent (parent_id)
);

-- Parts catalog
CREATE TABLE parts_catalog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    part_number VARCHAR(100) NOT NULL,
    oem_number VARCHAR(100),
    description TEXT,
    specifications JSON,
    images JSON,
    compatible_vehicles JSON, -- Store compatible vehicle IDs
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES parts_categories(id),
    INDEX idx_part_number (part_number),
    INDEX idx_oem_number (oem_number),
    INDEX idx_category (category_id)
);

-- Parts inventory
CREATE TABLE parts_inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dealer_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    price DECIMAL(10,2) NOT NULL,
    wholesale_price DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    min_stock_level INT DEFAULT 0,
    location VARCHAR(100),
    condition_type ENUM('new', 'used', 'refurbished') DEFAULT 'new',
    warranty_period INT, -- in months
    status ENUM('active', 'inactive', 'out_of_stock') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (dealer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (part_id) REFERENCES parts_catalog(id),
    INDEX idx_dealer_part (dealer_id, part_id),
    INDEX idx_price (price)
);

-- ===================================
-- SERVICE MANAGEMENT TABLES
-- ===================================

-- Service categories
CREATE TABLE service_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Service providers (mechanics/garages)
CREATE TABLE service_providers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    business_name VARCHAR(100),
    business_type ENUM('individual', 'garage', 'chain') DEFAULT 'individual',
    license_number VARCHAR(50),
    specializations JSON,
    service_areas JSON, -- City IDs they serve
    rating DECIMAL(3,2) DEFAULT 0.00,
    total_jobs INT DEFAULT 0,
    hourly_rate DECIMAL(8,2),
    available_days JSON, -- Days of week
    available_hours JSON, -- Time slots
    status ENUM('active', 'inactive', 'busy') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_rating (rating),
    INDEX idx_business_type (business_type)
);

-- Service requests/bookings
CREATE TABLE service_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_number VARCHAR(20) NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    service_category_id INT NOT NULL,
    provider_id INT NULL,
    service_description TEXT NOT NULL,
    location_type ENUM('home', 'garage', 'roadside') DEFAULT 'home',
    customer_location TEXT,
    preferred_date DATE,
    preferred_time TIME,
    urgency ENUM('low', 'medium', 'high', 'emergency') DEFAULT 'medium',
    estimated_cost DECIMAL(10,2),
    actual_cost DECIMAL(10,2),
    status ENUM('pending', 'accepted', 'in_progress', 'completed', 'cancelled', 'disputed') DEFAULT 'pending',
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (service_category_id) REFERENCES service_categories(id),
    FOREIGN KEY (provider_id) REFERENCES service_providers(id),
    INDEX idx_customer (customer_id),
    INDEX idx_provider (provider_id),
    INDEX idx_status (status),
    INDEX idx_request_number (request_number)
);

-- Service job cards
CREATE TABLE service_job_cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    service_request_id INT NOT NULL UNIQUE,
    job_card_number VARCHAR(20) NOT NULL UNIQUE,
    diagnosis TEXT,
    work_performed TEXT,
    parts_used JSON,
    labor_hours DECIMAL(4,2),
    labor_cost DECIMAL(10,2),
    parts_cost DECIMAL(10,2),
    total_cost DECIMAL(10,2),
    mechanic_notes TEXT,
    customer_signature VARCHAR(255), -- Image URL
    mechanic_signature VARCHAR(255), -- Image URL
    before_images JSON,
    after_images JSON,
    completed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (service_request_id) REFERENCES service_requests(id) ON DELETE CASCADE,
    INDEX idx_job_card_number (job_card_number)
);

-- ===================================
-- MARKETPLACE TABLES
-- ===================================

-- Vehicle listings for sale
CREATE TABLE vehicle_listings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    listing_number VARCHAR(20) NOT NULL UNIQUE,
    dealer_id INT NOT NULL,
    make_id INT NOT NULL,
    model_id INT NOT NULL,
    year INT NOT NULL,
    body_style_id INT NOT NULL,
    fuel_type_id INT NOT NULL,
    transmission_id INT NOT NULL,
    mileage INT,
    condition_type ENUM('new', 'used', 'certified_pre_owned') DEFAULT 'used',
    price DECIMAL(12,2) NOT NULL,
    negotiable BOOLEAN DEFAULT TRUE,
    description TEXT,
    features JSON,
    images JSON,
    location_city_id INT NOT NULL,
    views INT DEFAULT 0,
    inquiries INT DEFAULT 0,
    status ENUM('active', 'sold', 'reserved', 'inactive') DEFAULT 'active',
    featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (dealer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (make_id) REFERENCES vehicle_makes(id),
    FOREIGN KEY (model_id) REFERENCES vehicle_models(id),
    FOREIGN KEY (body_style_id) REFERENCES vehicle_body_styles(id),
    FOREIGN KEY (fuel_type_id) REFERENCES vehicle_fuel_types(id),
    FOREIGN KEY (transmission_id) REFERENCES vehicle_transmissions(id),
    FOREIGN KEY (location_city_id) REFERENCES cities(id),
    INDEX idx_dealer (dealer_id),
    INDEX idx_price (price),
    INDEX idx_location (location_city_id),
    INDEX idx_status (status),
    INDEX idx_listing_number (listing_number)
);

-- Vehicle listing inquiries
CREATE TABLE listing_inquiries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    listing_id INT NOT NULL,
    customer_id INT NOT NULL,
    dealer_id INT NOT NULL,
    inquiry_type ENUM('price', 'availability', 'inspection', 'financing', 'general') DEFAULT 'general',
    message TEXT NOT NULL,
    customer_phone VARCHAR(20),
    customer_email VARCHAR(100),
    status ENUM('new', 'responded', 'closed') DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (listing_id) REFERENCES vehicle_listings(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES users(id),
    FOREIGN KEY (dealer_id) REFERENCES users(id),
    INDEX idx_listing (listing_id),
    INDEX idx_customer (customer_id),
    INDEX idx_dealer (dealer_id)
);

-- ===================================
-- INSURANCE MANAGEMENT TABLES
-- ===================================

-- Insurance providers
CREATE TABLE insurance_providers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    website VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    countries JSON, -- Countries they operate in
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insurance policies
CREATE TABLE insurance_policies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    policy_number VARCHAR(50) NOT NULL UNIQUE,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    provider_id INT NOT NULL,
    agent_id INT NULL,
    policy_type ENUM('comprehensive', 'third_party', 'collision', 'theft') DEFAULT 'comprehensive',
    coverage_amount DECIMAL(12,2),
    premium_amount DECIMAL(10,2),
    deductible DECIMAL(10,2),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('active', 'expired', 'cancelled', 'suspended') DEFAULT 'active',
    payment_frequency ENUM('monthly', 'quarterly', 'semi_annual', 'annual') DEFAULT 'annual',
    auto_renewal BOOLEAN DEFAULT FALSE,
    documents JSON, -- Policy documents
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (provider_id) REFERENCES insurance_providers(id),
    FOREIGN KEY (agent_id) REFERENCES users(id),
    INDEX idx_policy_number (policy_number),
    INDEX idx_customer (customer_id),
    INDEX idx_vehicle (vehicle_id)
);

-- Insurance claims
CREATE TABLE insurance_claims (
    id INT AUTO_INCREMENT PRIMARY KEY,
    claim_number VARCHAR(50) NOT NULL UNIQUE,
    policy_id INT NOT NULL,
    claim_type ENUM('accident', 'theft', 'vandalism', 'natural_disaster', 'other') DEFAULT 'accident',
    incident_date DATE NOT NULL,
    incident_location TEXT,
    description TEXT NOT NULL,
    claim_amount DECIMAL(12,2),
    approved_amount DECIMAL(12,2),
    status ENUM('submitted', 'under_review', 'approved', 'denied', 'paid') DEFAULT 'submitted',
    documents JSON, -- Claim documents
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP NULL,
    settled_at TIMESTAMP NULL,
    FOREIGN KEY (policy_id) REFERENCES insurance_policies(id) ON DELETE CASCADE,
    INDEX idx_claim_number (claim_number),
    INDEX idx_policy (policy_id),
    INDEX idx_status (status)
);

-- ===================================
-- COMMUNICATION TABLES
-- ===================================

-- Messages/conversations
CREATE TABLE conversations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    participant_1 INT NOT NULL,
    participant_2 INT NOT NULL,
    last_message_id INT NULL,
    last_message_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (participant_1) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (participant_2) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_conversation (participant_1, participant_2),
    INDEX idx_participant_1 (participant_1),
    INDEX idx_participant_2 (participant_2)
);

-- Individual messages
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conversation_id INT NOT NULL,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    message_type ENUM('text', 'image', 'document', 'location') DEFAULT 'text',
    content TEXT NOT NULL,
    attachments JSON,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_conversation (conversation_id),
    INDEX idx_sender (sender_id),
    INDEX idx_receiver (receiver_id)
);

-- ===================================
-- NOTIFICATION TABLES
-- ===================================

-- Notifications
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('service_request', 'payment', 'message', 'system', 'promotion') DEFAULT 'system',
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    data JSON, -- Additional data
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_type (type),
    INDEX idx_read_at (read_at)
);

-- ===================================
-- FINANCIAL TABLES
-- ===================================

-- Transactions
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(50) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    transaction_type ENUM('service_payment', 'parts_purchase', 'insurance_payment', 'vehicle_purchase', 'subscription') NOT NULL,
    related_id INT, -- ID of related record (service_request, parts_order, etc.)
    amount DECIMAL(12,2) NOT NULL,
    currency VARCHAR(5) DEFAULT 'USD',
    payment_method ENUM('cash', 'card', 'mobile_money', 'bank_transfer') DEFAULT 'card',
    payment_gateway VARCHAR(50),
    gateway_transaction_id VARCHAR(100),
    status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    description TEXT,
    metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_transaction_id (transaction_id),
    INDEX idx_user_id (user_id),
    INDEX idx_type (transaction_type),
    INDEX idx_status (status)
);

-- ===================================
-- REVIEW & RATING TABLES
-- ===================================

-- Reviews
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reviewer_id INT NOT NULL,
    reviewed_id INT NOT NULL,
    review_type ENUM('service_provider', 'parts_dealer', 'car_dealer', 'insurance_agent') NOT NULL,
    related_id INT, -- ID of related service/transaction
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    comment TEXT,
    images JSON,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    admin_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_reviewer (reviewer_id),
    INDEX idx_reviewed (reviewed_id),
    INDEX idx_rating (rating),
    INDEX idx_type (review_type)
);

-- ===================================
-- SYSTEM TABLES
-- ===================================

-- System settings
CREATE TABLE system_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT NOT NULL,
    setting_type ENUM('string', 'integer', 'boolean', 'json') DEFAULT 'string',
    description TEXT,
    updated_by INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (updated_by) REFERENCES users(id)
);

-- Activity logs
CREATE TABLE activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50),
    resource_id INT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    data JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_resource (resource_type, resource_id)
);

-- ===================================
-- INDEXES FOR PERFORMANCE
-- ===================================

-- Additional composite indexes for common queries
CREATE INDEX idx_vehicles_owner_status ON vehicles(owner_id, status);
CREATE INDEX idx_service_requests_customer_status ON service_requests(customer_id, status);
CREATE INDEX idx_listings_dealer_status ON vehicle_listings(dealer_id, status);
CREATE INDEX idx_parts_inventory_dealer_status ON parts_inventory(dealer_id, status);
CREATE INDEX idx_messages_conversation_created ON messages(conversation_id, created_at);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, read_at);
CREATE INDEX idx_transactions_user_type ON transactions(user_id, transaction_type);
CREATE INDEX idx_reviews_reviewed_status ON reviews(reviewed_id, status);

-- ===================================
-- TRIGGERS FOR AUTOMATION
-- ===================================

-- Update conversation last message
DELIMITER //
CREATE TRIGGER update_conversation_last_message
AFTER INSERT ON messages
FOR EACH ROW
BEGIN
    UPDATE conversations 
    SET last_message_id = NEW.id, 
        last_message_at = NEW.created_at,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.conversation_id;
END//
DELIMITER ;

-- Update service provider rating
DELIMITER //
CREATE TRIGGER update_provider_rating
AFTER INSERT ON reviews
FOR EACH ROW
BEGIN
    IF NEW.review_type = 'service_provider' AND NEW.status = 'approved' THEN
        UPDATE service_providers 
        SET rating = (
            SELECT AVG(rating) 
            FROM reviews 
            WHERE reviewed_id = NEW.reviewed_id 
            AND review_type = 'service_provider' 
            AND status = 'approved'
        )
        WHERE user_id = NEW.reviewed_id;
    END IF;
END//
DELIMITER ;

-- Update parts inventory on order
DELIMITER //
CREATE TRIGGER update_parts_stock
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.transaction_type = 'parts_purchase' AND NEW.status = 'completed' THEN
        -- This would need additional logic based on order details
        -- Placeholder for inventory management
        INSERT INTO activity_logs (action, resource_type, resource_id, data, created_at)
        VALUES ('parts_stock_update', 'transaction', NEW.id, 
                JSON_OBJECT('transaction_id', NEW.id, 'amount', NEW.amount), 
                NOW());
    END IF;
END//
DELIMITER ;

-- ===================================
-- VIEWS FOR COMMON QUERIES
-- ===================================

-- Active service providers with ratings
CREATE VIEW active_service_providers AS
SELECT 
    sp.id,
    sp.user_id,
    up.first_name,
    up.last_name,
    sp.business_name,
    sp.business_type,
    sp.specializations,
    sp.rating,
    sp.total_jobs,
    sp.hourly_rate,
    c.name as city_name,
    co.name as country_name
FROM service_providers sp
JOIN users u ON sp.user_id = u.id
JOIN user_profiles up ON u.id = up.user_id
JOIN cities c ON u.city_id = c.id
JOIN countries co ON u.country_id = co.id
WHERE sp.status = 'active' AND u.status = 'active';

-- Available vehicle listings with details
CREATE VIEW available_vehicles AS
SELECT 
    vl.id,
    vl.listing_number,
    vm.name as make_name,
    vmo.name as model_name,
    vl.year,
    vbs.name as body_style,
    vft.name as fuel_type,
    vt.name as transmission,
    vl.mileage,
    vl.condition_type,
    vl.price,
    vl.negotiable,
    vl.images,
    c.name as city_name,
    co.name as country_name,
    up.first_name as dealer_first_name,
    up.last_name as dealer_last_name,
    vl.created_at
FROM vehicle_listings vl
JOIN vehicle_makes vm ON vl.make_id = vm.id
JOIN vehicle_models vmo ON vl.model_id = vmo.id
JOIN vehicle_body_styles vbs ON vl.body_style_id = vbs.id
JOIN vehicle_fuel_types vft ON vl.fuel_type_id = vft.id
JOIN vehicle_transmissions vt ON vl.transmission_id = vt.id
JOIN cities c ON vl.location_city_id = c.id
JOIN countries co ON c.country_id = co.id
JOIN users u ON vl.dealer_id = u.id
JOIN user_profiles up ON u.id = up.user_id
WHERE vl.status = 'active';

-- Active parts inventory with details
CREATE VIEW active_parts_inventory AS
SELECT 
    pi.id,
    pi.dealer_id,
    pc.name as part_name,
    pc.part_number,
    pc.oem_number,
    pcat.name as category_name,
    pi.quantity,
    pi.price,
    pi.condition_type,
    pi.warranty_period,
    up.first_name as dealer_first_name,
    up.last_name as dealer_last_name,
    c.name as city_name,
    co.name as country_name
FROM parts_inventory pi
JOIN parts_catalog pc ON pi.part_id = pc.id
JOIN parts_categories pcat ON pc.category_id = pcat.id
JOIN users u ON pi.dealer_id = u.id
JOIN user_profiles up ON u.id = up.user_id
JOIN cities c ON u.city_id = c.id
JOIN countries co ON c.country_id = co.id
WHERE pi.status = 'active' AND pi.quantity > 0;

-- ===================================
-- STORED PROCEDURES
-- ===================================

-- Get user dashboard stats
DELIMITER //
CREATE PROCEDURE GetUserDashboardStats(IN user_id INT, IN user_type VARCHAR(50))
BEGIN
    CASE user_type
        WHEN 'car_owner' THEN
            SELECT 
                (SELECT COUNT(*) FROM vehicles WHERE owner_id = user_id AND status = 'active') as total_vehicles,
                (SELECT COUNT(*) FROM service_requests WHERE customer_id = user_id AND status IN ('pending', 'accepted', 'in_progress')) as active_services,
                (SELECT COUNT(*) FROM insurance_policies WHERE customer_id = user_id AND status = 'active') as active_policies,
                (SELECT COUNT(*) FROM notifications WHERE user_id = user_id AND read_at IS NULL) as unread_notifications;
                
        WHEN 'mechanic' THEN
            SELECT 
                (SELECT COUNT(*) FROM service_requests WHERE provider_id = (SELECT id FROM service_providers WHERE user_id = user_id) AND status IN ('pending', 'accepted', 'in_progress')) as active_jobs,
                (SELECT COUNT(*) FROM service_requests WHERE provider_id = (SELECT id FROM service_providers WHERE user_id = user_id) AND status = 'completed' AND MONTH(updated_at) = MONTH(CURRENT_DATE)) as jobs_this_month,
                (SELECT COALESCE(SUM(actual_cost), 0) FROM service_requests WHERE provider_id = (SELECT id FROM service_providers WHERE user_id = user_id) AND status = 'completed' AND MONTH(updated_at) = MONTH(CURRENT_DATE)) as earnings_this_month,
                (SELECT rating FROM service_providers WHERE user_id = user_id) as current_rating,
                (SELECT COUNT(*) FROM notifications WHERE user_id = user_id AND read_at IS NULL) as unread_notifications;
                
        WHEN 'garage' THEN
            SELECT 
                (SELECT COUNT(*) FROM service_requests WHERE provider_id = (SELECT id FROM service_providers WHERE user_id = user_id) AND status IN ('pending', 'accepted', 'in_progress')) as active_jobs,
                (SELECT COUNT(*) FROM service_requests WHERE provider_id = (SELECT id FROM service_providers WHERE user_id = user_id) AND status = 'completed' AND MONTH(updated_at) = MONTH(CURRENT_DATE)) as jobs_this_month,
                (SELECT COALESCE(SUM(actual_cost), 0) FROM service_requests WHERE provider_id = (SELECT id FROM service_providers WHERE user_id = user_id) AND status = 'completed' AND MONTH(updated_at) = MONTH(CURRENT_DATE)) as revenue_this_month,
                (SELECT COUNT(*) FROM parts_inventory WHERE dealer_id = user_id AND status = 'active') as active_parts,
                (SELECT COUNT(*) FROM notifications WHERE user_id = user_id AND read_at IS NULL) as unread_notifications;
                
        WHEN 'parts_dealer' THEN
            SELECT 
                (SELECT COUNT(*) FROM parts_inventory WHERE dealer_id = user_id AND status = 'active') as active_parts,
                (SELECT COUNT(*) FROM parts_inventory WHERE dealer_id = user_id AND quantity <= min_stock_level) as low_stock_parts,
                (SELECT COUNT(*) FROM transactions WHERE user_id = user_id AND transaction_type = 'parts_purchase' AND status = 'completed' AND MONTH(created_at) = MONTH(CURRENT_DATE)) as sales_this_month,
                (SELECT COALESCE(SUM(amount), 0) FROM transactions WHERE user_id = user_id AND transaction_type = 'parts_purchase' AND status = 'completed' AND MONTH(created_at) = MONTH(CURRENT_DATE)) as revenue_this_month,
                (SELECT COUNT(*) FROM notifications WHERE user_id = user_id AND read_at IS NULL) as unread_notifications;
                
        WHEN 'car_dealer' THEN
            SELECT 
                (SELECT COUNT(*) FROM vehicle_listings WHERE dealer_id = user_id AND status = 'active') as active_listings,
                (SELECT COUNT(*) FROM listing_inquiries WHERE dealer_id = user_id AND status = 'new') as new_inquiries,
                (SELECT COUNT(*) FROM vehicle_listings WHERE dealer_id = user_id AND status = 'sold' AND MONTH(updated_at) = MONTH(CURRENT_DATE)) as sales_this_month,
                (SELECT COALESCE(SUM(price), 0) FROM vehicle_listings WHERE dealer_id = user_id AND status = 'sold' AND MONTH(updated_at) = MONTH(CURRENT_DATE)) as revenue_this_month,
                (SELECT COUNT(*) FROM notifications WHERE user_id = user_id AND read_at IS NULL) as unread_notifications;
                
        WHEN 'insurance_agent' THEN
            SELECT 
                (SELECT COUNT(*) FROM insurance_policies WHERE agent_id = user_id AND status = 'active') as active_policies,
                (SELECT COUNT(*) FROM insurance_policies WHERE agent_id = user_id AND end_date <= DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)) as expiring_policies,
                (SELECT COUNT(*) FROM insurance_claims WHERE policy_id IN (SELECT id FROM insurance_policies WHERE agent_id = user_id) AND status IN ('submitted', 'under_review')) as pending_claims,
                (SELECT COUNT(*) FROM insurance_policies WHERE agent_id = user_id AND MONTH(created_at) = MONTH(CURRENT_DATE)) as new_policies_this_month,
                (SELECT COUNT(*) FROM notifications WHERE user_id = user_id AND read_at IS NULL) as unread_notifications;
                
        ELSE
            SELECT 'Invalid user type' as error;
    END CASE;
END//
DELIMITER ;

-- Search vehicles with filters
DELIMITER //
CREATE PROCEDURE SearchVehicles(
    IN p_make_id INT,
    IN p_model_id INT,
    IN p_year_min INT,
    IN p_year_max INT,
    IN p_price_min DECIMAL(12,2),
    IN p_price_max DECIMAL(12,2),
    IN p_fuel_type_id INT,
    IN p_transmission_id INT,
    IN p_city_id INT,
    IN p_condition_type VARCHAR(50),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT 
        vl.id,
        vl.listing_number,
        vm.name as make_name,
        vmo.name as model_name,
        vl.year,
        vbs.name as body_style,
        vft.name as fuel_type,
        vt.name as transmission,
        vl.mileage,
        vl.condition_type,
        vl.price,
        vl.negotiable,
        vl.images,
        c.name as city_name,
        co.name as country_name,
        up.first_name as dealer_first_name,
        up.last_name as dealer_last_name,
        u.phone as dealer_phone,
        vl.views,
        vl.created_at
    FROM vehicle_listings vl
    JOIN vehicle_makes vm ON vl.make_id = vm.id
    JOIN vehicle_models vmo ON vl.model_id = vmo.id
    JOIN vehicle_body_styles vbs ON vl.body_style_id = vbs.id
    JOIN vehicle_fuel_types vft ON vl.fuel_type_id = vft.id
    JOIN vehicle_transmissions vt ON vl.transmission_id = vt.id
    JOIN cities c ON vl.location_city_id = c.id
    JOIN countries co ON c.country_id = co.id
    JOIN users u ON vl.dealer_id = u.id
    JOIN user_profiles up ON u.id = up.user_id
    WHERE vl.status = 'active'
    AND (p_make_id IS NULL OR vl.make_id = p_make_id)
    AND (p_model_id IS NULL OR vl.model_id = p_model_id)
    AND (p_year_min IS NULL OR vl.year >= p_year_min)
    AND (p_year_max IS NULL OR vl.year <= p_year_max)
    AND (p_price_min IS NULL OR vl.price >= p_price_min)
    AND (p_price_max IS NULL OR vl.price <= p_price_max)
    AND (p_fuel_type_id IS NULL OR vl.fuel_type_id = p_fuel_type_id)
    AND (p_transmission_id IS NULL OR vl.transmission_id = p_transmission_id)
    AND (p_city_id IS NULL OR vl.location_city_id = p_city_id)
    AND (p_condition_type IS NULL OR vl.condition_type = p_condition_type)
    ORDER BY vl.featured DESC, vl.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;

-- Search parts with filters
DELIMITER //
CREATE PROCEDURE SearchParts(
    IN p_search_term VARCHAR(200),
    IN p_category_id INT,
    IN p_make_id INT,
    IN p_model_id INT,
    IN p_year INT,
    IN p_price_min DECIMAL(10,2),
    IN p_price_max DECIMAL(10,2),
    IN p_city_id INT,
    IN p_condition_type VARCHAR(50),
    IN p_limit INT,
    IN p_offset INT
)
BEGIN
    SELECT 
        pi.id,
        pc.name as part_name,
        pc.part_number,
        pc.oem_number,
        pcat.name as category_name,
        pi.quantity,
        pi.price,
        pi.condition_type,
        pi.warranty_period,
        pi.location,
        up.first_name as dealer_first_name,
        up.last_name as dealer_last_name,
        u.phone as dealer_phone,
        c.name as city_name,
        co.name as country_name,
        pc.images,
        pc.description
    FROM parts_inventory pi
    JOIN parts_catalog pc ON pi.part_id = pc.id
    JOIN parts_categories pcat ON pc.category_id = pcat.id
    JOIN users u ON pi.dealer_id = u.id
    JOIN user_profiles up ON u.id = up.user_id
    JOIN cities c ON u.city_id = c.id
    JOIN countries co ON c.country_id = co.id
    WHERE pi.status = 'active' 
    AND pi.quantity > 0
    AND (p_search_term IS NULL OR pc.name LIKE CONCAT('%', p_search_term, '%') OR pc.part_number LIKE CONCAT('%', p_search_term, '%'))
    AND (p_category_id IS NULL OR pc.category_id = p_category_id)
    AND (p_price_min IS NULL OR pi.price >= p_price_min)
    AND (p_price_max IS NULL OR pi.price <= p_price_max)
    AND (p_city_id IS NULL OR u.city_id = p_city_id)
    AND (p_condition_type IS NULL OR pi.condition_type = p_condition_type)
    ORDER BY pi.price ASC
    LIMIT p_limit OFFSET p_offset;
END//
DELIMITER ;

-- Get service provider availability
DELIMITER //
CREATE PROCEDURE GetProviderAvailability(
    IN p_provider_id INT,
    IN p_date DATE
)
BEGIN
    SELECT 
        sp.available_days,
        sp.available_hours,
        sp.status,
        COUNT(sr.id) as booked_slots
    FROM service_providers sp
    LEFT JOIN service_requests sr ON sp.id = sr.provider_id 
        AND DATE(sr.preferred_date) = p_date 
        AND sr.status IN ('accepted', 'in_progress')
    WHERE sp.id = p_provider_id
    GROUP BY sp.id;
END//
DELIMITER ;

-- ===================================
-- FUNCTIONS
-- ===================================

-- Generate unique service request number
DELIMITER //
CREATE FUNCTION GenerateServiceRequestNumber() RETURNS VARCHAR(20)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE new_number VARCHAR(20);
    DECLARE counter INT DEFAULT 1;
    
    SET new_number = CONCAT('SR', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(counter, 4, '0'));
    
    WHILE EXISTS (SELECT 1 FROM service_requests WHERE request_number = new_number) DO
        SET counter = counter + 1;
        SET new_number = CONCAT('SR', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(counter, 4, '0'));
    END WHILE;
    
    RETURN new_number;
END//
DELIMITER ;

-- Generate unique listing number
DELIMITER //
CREATE FUNCTION GenerateListingNumber() RETURNS VARCHAR(20)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE new_number VARCHAR(20);
    DECLARE counter INT DEFAULT 1;
    
    SET new_number = CONCAT('VL', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(counter, 4, '0'));
    
    WHILE EXISTS (SELECT 1 FROM vehicle_listings WHERE listing_number = new_number) DO
        SET counter = counter + 1;
        SET new_number = CONCAT('VL', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(counter, 4, '0'));
    END WHILE;
    
    RETURN new_number;
END//
DELIMITER ;

-- Generate unique transaction ID
DELIMITER //
CREATE FUNCTION GenerateTransactionId() RETURNS VARCHAR(50)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE new_id VARCHAR(50);
    DECLARE counter INT DEFAULT 1;
    
    SET new_id = CONCAT('TXN', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(counter, 6, '0'));
    
    WHILE EXISTS (SELECT 1 FROM transactions WHERE transaction_id = new_id) DO
        SET counter = counter + 1;
        SET new_id = CONCAT('TXN', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(counter, 6, '0'));
    END WHILE;
    
    RETURN new_id;
END//
DELIMITER ;

-- Calculate distance between two points (simplified)
DELIMITER //
CREATE FUNCTION CalculateDistance(
    lat1 DECIMAL(10,8), 
    lon1 DECIMAL(11,8), 
    lat2 DECIMAL(10,8), 
    lon2 DECIMAL(11,8)
) RETURNS DECIMAL(10,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE distance DECIMAL(10,2);
    
    -- Simple Haversine formula approximation
    SET distance = (
        6371 * ACOS(
            COS(RADIANS(lat1)) * COS(RADIANS(lat2)) * 
            COS(RADIANS(lon2) - RADIANS(lon1)) + 
            SIN(RADIANS(lat1)) * SIN(RADIANS(lat2))
        )
    );
    
    RETURN distance;
END//
DELIMITER ;

-- ===================================
-- INITIAL SYSTEM SETTINGS
-- ===================================

INSERT INTO system_settings (setting_key, setting_value, setting_type, description) VALUES
('app_name', 'Cariella', 'string', 'Application name'),
('app_version', '1.0.0', 'string', 'Application version'),
('default_currency', 'USD', 'string', 'Default currency code'),
('max_file_upload_size', '10485760', 'integer', 'Maximum file upload size in bytes (10MB)'),
('allow_registration', 'true', 'boolean', 'Allow new user registration'),
('maintenance_mode', 'false', 'boolean', 'Enable maintenance mode'),
('default_language', 'en', 'string', 'Default language code'),
('session_timeout', '7200', 'integer', 'Session timeout in seconds (2 hours)'),
('max_vehicles_per_user', '10', 'integer', 'Maximum vehicles per user'),
('service_request_auto_expire', '168', 'integer', 'Auto expire service requests after hours'),
('notification_retention_days', '30', 'integer', 'Keep notifications for days'),
('review_auto_approve', 'false', 'boolean', 'Auto approve reviews'),
('commission_rate', '0.05', 'string', 'Platform commission rate (5%)'),
('min_service_amount', '10.00', 'string', 'Minimum service amount'),
('max_service_amount', '10000.00', 'string', 'Maximum service amount'),
('sms_gateway', 'twilio', 'string', 'SMS gateway provider'),
('email_gateway', 'smtp', 'string', 'Email gateway type'),
('payment_gateway', 'stripe', 'string', 'Payment gateway provider'),
('google_maps_api_key', '', 'string', 'Google Maps API key'),
('push_notification_key', '', 'string', 'Push notification service key'),
('backup_retention_days', '30', 'integer', 'Database backup retention days');

-- ===================================
-- SAMPLE DATA INSERTION
-- ===================================

-- Insert sample countries
INSERT INTO countries (name, code, phone_code, currency) VALUES
('United States', 'US', '+1', 'USD'),
('United Kingdom', 'GB', '+44', 'GBP'),
('Canada', 'CA', '+1', 'CAD'),
('Australia', 'AU', '+61', 'AUD'),
('Germany', 'DE', '+49', 'EUR'),
('France', 'FR', '+33', 'EUR'),
('Kenya', 'KE', '+254', 'KES'),
('Nigeria', 'NG', '+234', 'NGN'),
('South Africa', 'ZA', '+27', 'ZAR'),
('Ghana', 'GH', '+233', 'GHS'),
('Tanzania', 'TZ', '+255', 'TZS'),
('Uganda', 'UG', '+256', 'UGX'),
('Rwanda', 'RW', '+250', 'RWF'),
('Ethiopia', 'ET', '+251', 'ETB'),
('Morocco', 'MA', '+212', 'MAD'),
('Egypt', 'EG', '+20', 'EGP');

-- Insert sample cities for Tanzania (since user is in Dar es Salaam)
INSERT INTO cities (country_id, name, state_province) VALUES
((SELECT id FROM countries WHERE code = 'TZ'), 'Dar es Salaam', 'Dar es Salaam'),
((SELECT id FROM countries WHERE code = 'TZ'), 'Arusha', 'Arusha'),
((SELECT id FROM countries WHERE code = 'TZ'), 'Mwanza', 'Mwanza'),
((SELECT id FROM countries WHERE code = 'TZ'), 'Dodoma', 'Dodoma'),
((SELECT id FROM countries WHERE code = 'TZ'), 'Mbeya', 'Mbeya'),
((SELECT id FROM countries WHERE code = 'TZ'), 'Morogoro', 'Morogoro'),
((SELECT id FROM countries WHERE code = 'TZ'), 'Tanga', 'Tanga'),
((SELECT id FROM countries WHERE code = 'TZ'), 'Tabora', 'Tabora'),
((SELECT id FROM countries WHERE code = 'TZ'), 'Kigoma', 'Kigoma'),
((SELECT id FROM countries WHERE code = 'TZ'), 'Iringa', 'Iringa');

-- Insert sample cities for other major countries
INSERT INTO cities (country_id, name, state_province) VALUES
((SELECT id FROM countries WHERE code = 'KE'), 'Nairobi', 'Nairobi'),
((SELECT id FROM countries WHERE code = 'KE'), 'Mombasa', 'Mombasa'),
((SELECT id FROM countries WHERE code = 'KE'), 'Kisumu', 'Kisumu'),
((SELECT id FROM countries WHERE code = 'NG'), 'Lagos', 'Lagos'),
((SELECT id FROM countries WHERE code = 'NG'), 'Abuja', 'FCT'),
((SELECT id FROM countries WHERE code = 'NG'), 'Kano', 'Kano'),
((SELECT id FROM countries WHERE code = 'ZA'), 'Johannesburg', 'Gauteng'),
((SELECT id FROM countries WHERE code = 'ZA'), 'Cape Town', 'Western Cape'),
((SELECT id FROM countries WHERE code = 'ZA'), 'Durban', 'KwaZulu-Natal'),
((SELECT id FROM countries WHERE code = 'GH'), 'Accra', 'Greater Accra'),
((SELECT id FROM countries WHERE code = 'GH'), 'Kumasi', 'Ashanti');

-- Insert vehicle makes
INSERT INTO vehicle_makes (name, logo_url) VALUES
('Toyota', '/assets/images/makes/toyota.png'),
('Honda', '/assets/images/makes/honda.png'),
('Ford', '/assets/images/makes/ford.png'),
('BMW', '/assets/images/makes/bmw.png'),
('Mercedes-Benz', '/assets/images/makes/mercedes.png'),
('Audi', '/assets/images/makes/audi.png'),
('Volkswagen', '/assets/images/makes/volkswagen.png'),
('Nissan', '/assets/images/makes/nissan.png'),
('Hyundai', '/assets/images/makes/hyundai.png'),
('Kia', '/assets/images/makes/kia.png'),
('Chevrolet', '/assets/images/makes/chevrolet.png'),
('Mazda', '/assets/images/makes/mazda.png'),
('Subaru', '/assets/images/makes/subaru.png'),
('Mitsubishi', '/assets/images/makes/mitsubishi.png'),
('Suzuki', '/assets/images/makes/suzuki.png'),
('Isuzu', '/assets/images/makes/isuzu.png'),
('Peugeot', '/assets/images/makes/peugeot.png'),
('Renault', '/assets/images/makes/renault.png');

-- Insert vehicle models for Toyota
INSERT INTO vehicle_models (make_id, name) VALUES
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Camry'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Corolla'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Prius'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'RAV4'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Highlander'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Prado'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Land Cruiser'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Hilux'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Yaris'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Vitz'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Harrier'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Noah'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Voxy'),
((SELECT id FROM vehicle_makes WHERE name = 'Toyota'), 'Alphard');

-- Insert vehicle models for Honda
INSERT INTO vehicle_models (make_id, name) VALUES
((SELECT id FROM vehicle_makes WHERE name = 'Honda'), 'Civic'),
((SELECT id FROM vehicle_makes WHERE name = 'Honda'), 'Accord'),
((SELECT id FROM vehicle_makes WHERE name = 'Honda'), 'CR-V'),
((SELECT id FROM vehicle_makes WHERE name = 'Honda'), 'Pilot'),
((SELECT id FROM vehicle_makes WHERE name = 'Honda'), 'Fit'),
((SELECT id FROM vehicle_makes WHERE name = 'Honda'), 'HR-V'),
((SELECT id FROM vehicle_makes WHERE name = 'Honda'), 'Odyssey'),
((SELECT id FROM vehicle_makes WHERE name = 'Honda'), 'Ridgeline'),
((SELECT id FROM vehicle_makes WHERE name = 'Honda'), 'Passport'),
((SELECT id FROM vehicle_makes WHERE name = 'Honda'), 'Insight');

-- Insert body styles
INSERT INTO vehicle_body_styles (name, description) VALUES
('Sedan', '4-door passenger car'),
('SUV', 'Sport Utility Vehicle'),
('Hatchback', 'Compact car with rear access door'),
('Coupe', '2-door sports car'),
('Convertible', 'Car with retractable roof'),
('Wagon', 'Extended passenger/cargo vehicle'),
('Pickup', 'Truck with open cargo bed'),
('Van', 'Large passenger or cargo vehicle'),
('Crossover', 'Car-based SUV'),
('Minivan', 'Large family vehicle');

-- Insert fuel types
INSERT INTO vehicle_fuel_types (name, description) VALUES
('Gasoline', 'Regular unleaded gasoline'),
('Diesel', 'Diesel fuel'),
('Hybrid', 'Gasoline-electric hybrid'),
('Electric', 'Battery electric vehicle'),
('Plug-in Hybrid', 'Rechargeable hybrid'),
('Flex Fuel', 'Gasoline and ethanol blend'),
('CNG', 'Compressed Natural Gas'),
('LPG', 'Liquefied Petroleum Gas');

-- Insert transmissions
INSERT INTO vehicle_transmissions (name, description) VALUES
('Manual', 'Manual transmission'),
('Automatic', 'Automatic transmission'),
('CVT', 'Continuously Variable Transmission'),
('Semi-Automatic', 'Semi-automatic transmission'),
('Dual-Clutch', 'Dual-clutch automatic');

-- Insert service categories
INSERT INTO service_categories (name, description, icon) VALUES
('Oil Change', 'Engine oil and filter replacement', 'oil-drop'),
('Brake Service', 'Brake pads, rotors, and system maintenance', 'disc-brake'),
('Tire Service', 'Tire rotation, alignment, and replacement', 'tire'),
('Engine Repair', 'Engine diagnostics and repair', 'engine'),
('Transmission Service', 'Transmission fluid and repair', 'gears'),
('Air Conditioning', 'AC system service and repair', 'snowflake'),
('Battery Service', 'Battery testing and replacement', 'battery'),
('Electrical Repair', 'Electrical system diagnostics', 'zap'),
('Suspension', 'Suspension system service', 'spring'),
('Body Work', 'Dent repair and painting', 'paint-roller'),
('Windshield Repair', 'Glass repair and replacement', 'glass'),
('Diagnostic', 'Computer diagnostics', 'scanner'),
('Tune-up', 'General maintenance service', 'wrench'),
('Exhaust System', 'Exhaust pipe and muffler service', 'exhaust'),
('Cooling System', 'Radiator and cooling system service', 'thermometer');

-- Insert parts categories
INSERT INTO parts_categories (name, description, image_url) VALUES
('Engine Parts', 'Engine components and accessories', '/assets/images/categories/engine.png'),
('Brake System', 'Brake pads, rotors, and components', '/assets/images/categories/brakes.png'),
('Suspension', 'Shocks, struts, and suspension parts', '/assets/images/categories/suspension.png'),
('Transmission', 'Transmission parts and fluids', '/assets/images/categories/transmission.png'),
('Electrical', 'Electrical components and accessories', '/assets/images/categories/electrical.png'),
('Body Parts', 'Exterior and interior body parts', '/assets/images/categories/body.png'),
('Filters', 'Air, oil, and fuel filters', '/assets/images/categories/filters.png'),
('Tires & Wheels', 'Tires, rims, and wheel accessories', '/assets/images/categories/tires.png'),
('Lights', 'Headlights, taillights, and bulbs', '/assets/images/categories/lights.png'),
('Fluids', 'Motor oil, coolant, and other fluids', '/assets/images/categories/fluids.png'),
('Exhaust', 'Exhaust pipes, mufflers, and catalytic converters', '/assets/images/categories/exhaust.png'),
('Cooling System', 'Radiators, thermostats, and cooling parts', '/assets/images/categories/cooling.png'),
('Fuel System', 'Fuel pumps, injectors, and fuel system parts', '/assets/images/categories/fuel.png'),
('Interior', 'Seats, dashboard, and interior accessories', '/assets/images/categories/interior.png'),
('Exterior', 'Bumpers, mirrors, and exterior accessories', '/assets/images/categories/exterior.png');

-- Insert sample insurance providers
INSERT INTO insurance_providers (name, description, logo_url, website, phone, email, countries) VALUES
('AAR Insurance', 'Leading insurance provider in East Africa', '/assets/images/insurance/aar.png', 'https://aar-insurance.com', '+254-20-2714000', 'info@aar-insurance.com', '["KE", "TZ", "UG"]'),
('Jubilee Insurance', 'Comprehensive insurance solutions', '/assets/images/insurance/jubilee.png', 'https://jubileekenya.com', '+254-20-3946000', 'info@jubileekenya.com', '["KE", "TZ", "UG"]'),
('CIC Insurance', 'Trusted insurance partner', '/assets/images/insurance/cic.png', 'https://cic.co.ke', '+254-20-2828000', 'info@cic.co.ke', '["KE", "TZ"]'),
('BRITAM', 'Pan-African insurance company', '/assets/images/insurance/britam.png', 'https://britam.com', '+254-20-2633000', 'info@britam.com', '["KE", "TZ", "UG", "RW"]'),
('Madison Insurance', 'Innovative insurance solutions', '/assets/images/insurance/madison.png', 'https://madison.co.ke', '+254-20-2806000', 'info@madison.co.ke', '["KE", "TZ"]');

-- Create admin user
INSERT INTO users (phone, country_id, city_id, password_hash, user_type, status, email, email_verified, phone_verified) VALUES
('+255123456789', 
 (SELECT id FROM countries WHERE code = 'TZ'), 
 (SELECT id FROM cities WHERE name = 'Dar es Salaam'), 
 '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: password
 'admin', 
 'active', 
 'admin@cariella.com', 
 TRUE, 
 TRUE);

-- Create admin profile
INSERT INTO user_profiles (user_id, first_name, last_name, bio) VALUES
((SELECT id FROM users WHERE phone = '+255123456789'), 'System', 'Administrator', 'System Administrator Account');

-- ===================================
-- CLEANUP AND OPTIMIZATION
-- ===================================

-- Optimize tables
OPTIMIZE TABLE users;
OPTIMIZE TABLE vehicles;
OPTIMIZE TABLE service_requests;
OPTIMIZE TABLE vehicle_listings;
OPTIMIZE TABLE parts_inventory;
OPTIMIZE TABLE messages;
OPTIMIZE TABLE transactions;
OPTIMIZE TABLE reviews;

-- Analyze tables for better query performance
ANALYZE TABLE users;
ANALYZE TABLE vehicles;
ANALYZE TABLE service_requests;
ANALYZE TABLE vehicle_listings;
ANALYZE TABLE parts_inventory;
