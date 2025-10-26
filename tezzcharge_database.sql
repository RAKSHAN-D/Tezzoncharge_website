-- =====================================================
-- Tezzon Charge EV Charging Platform Database Schema
-- =====================================================

-- Create Database
CREATE DATABASE IF NOT EXISTS tezzoncharge_db;
USE tezzoncharge_db;

-- =====================================================
-- 1. USERS TABLE
-- =====================================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_type ENUM('customer', 'admin', 'partner') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_user_type (user_type)
);

-- =====================================================
-- 2. USER ADDRESSES TABLE
-- =====================================================
CREATE TABLE user_addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    address_type ENUM('home', 'work', 'other') DEFAULT 'home',
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_city (city),
    INDEX idx_pincode (pincode)
);

-- =====================================================
-- 3. PRODUCTS TABLE
-- =====================================================
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category ENUM('charger', 'accessory', 'service') DEFAULT 'charger',
    product_type ENUM('solarx', 'ultra', 'compact', 'scootypro', 'stationhub', 'solarxpro') NOT NULL,
    image_url VARCHAR(255),
    specifications JSON,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_product_type (product_type),
    INDEX idx_price (price),
    INDEX idx_is_available (is_available)
);

-- =====================================================
-- 4. ORDERS TABLE
-- =====================================================
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    gst_amount DECIMAL(10,2) NOT NULL,
    shipping_amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    shipping_address_id INT NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    payment_method VARCHAR(50),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (shipping_address_id) REFERENCES user_addresses(id),
    INDEX idx_order_number (order_number),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_payment_status (payment_status),
    INDEX idx_order_date (order_date)
);

-- =====================================================
-- 5. ORDER ITEMS TABLE
-- =====================================================
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    INDEX idx_order_id (order_id),
    INDEX idx_product_id (product_id)
);

-- =====================================================
-- 6. CHARGING STATIONS TABLE
-- =====================================================
CREATE TABLE charging_stations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    status ENUM('available', 'in_use', 'maintenance', 'offline') DEFAULT 'available',
    charging_type ENUM('fast', 'standard') DEFAULT 'standard',
    fast_charging BOOLEAN DEFAULT FALSE,
    rating DECIMAL(3,2) DEFAULT 0.00,
    total_reviews INT DEFAULT 0,
    phone VARCHAR(15),
    operating_hours VARCHAR(100),
    amenities JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_location (location),
    INDEX idx_status (status),
    INDEX idx_charging_type (charging_type),
    INDEX idx_fast_charging (fast_charging),
    INDEX idx_rating (rating)
);

-- =====================================================
-- 7. STATION REVIEWS TABLE
-- =====================================================
CREATE TABLE station_reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    station_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (station_id) REFERENCES charging_stations(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_station_id (station_id),
    INDEX idx_user_id (user_id),
    INDEX idx_rating (rating),
    INDEX idx_created_at (created_at)
);

-- =====================================================
-- 8. PARTNERS TABLE
-- =====================================================
CREATE TABLE partners (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    company_name VARCHAR(100),
    partner_type ENUM('franchise', 'land_leasing', 'co_branding') NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL,
    status ENUM('pending', 'approved', 'rejected', 'active') DEFAULT 'pending',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_user_id (user_id),
    INDEX idx_partner_type (partner_type),
    INDEX idx_status (status),
    INDEX idx_email (email)
);

-- =====================================================
-- 9. CONTACT INQUIRIES TABLE
-- =====================================================
CREATE TABLE contact_inquiries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    subject VARCHAR(200),
    message TEXT NOT NULL,
    inquiry_type ENUM('general', 'support', 'sales', 'partnership') DEFAULT 'general',
    status ENUM('new', 'in_progress', 'resolved', 'closed') DEFAULT 'new',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_inquiry_type (inquiry_type),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- =====================================================
-- 10. SERVICES TABLE
-- =====================================================
CREATE TABLE services (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_is_active (is_active)
);

-- =====================================================
-- 11. ORDER TRACKING TABLE
-- =====================================================
CREATE TABLE order_tracking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    status ENUM('order_placed', 'processing', 'shipped', 'delivered') NOT NULL,
    location VARCHAR(255),
    description TEXT,
    tracking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_status (status),
    INDEX idx_tracking_date (tracking_date)
);

-- =====================================================
-- 12. PAYMENT TRANSACTIONS TABLE
-- =====================================================
CREATE TABLE payment_transactions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    gateway_response JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    INDEX idx_order_id (order_id),
    INDEX idx_transaction_id (transaction_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- =====================================================
-- SAMPLE DATA INSERTION
-- =====================================================

-- Insert Sample Users
INSERT INTO users (full_name, email, phone, password_hash, user_type) VALUES
('John Doe', 'john@example.com', '+91 98765 43210', '$2y$10$hashedpassword123', 'customer'),
('Admin User', 'admin@tezzoncharge.com', '+91 98765 43211', '$2y$10$hashedpassword456', 'admin'),
('Sarah Wilson', 'sarah@example.com', '+91 98765 43212', '$2y$10$hashedpassword789', 'customer'),
('Mike Johnson', 'mike@example.com', '+91 98765 43213', '$2y$10$hashedpassword101', 'customer');

-- Insert Sample User Addresses
INSERT INTO user_addresses (user_id, address_type, address_line1, address_line2, city, state, pincode, is_default) VALUES
(1, 'home', '123 Main Street', 'Apartment 4B', 'Mumbai', 'Maharashtra', '400001', TRUE),
(1, 'work', '456 Business Park', 'Floor 2', 'Mumbai', 'Maharashtra', '400002', FALSE),
(2, 'home', '789 Oak Avenue', 'Villa 12', 'Delhi', 'Delhi', '110001', TRUE),
(3, 'home', '321 Pine Road', 'House 7', 'Bangalore', 'Karnataka', '560001', TRUE);

-- Insert Sample Products
INSERT INTO products (name, description, price, category, product_type, image_url, specifications) VALUES
('Tezzon Charge SolarX', 'Eco-friendly solar-powered charger. Zero electricity cost.', 74999.00, 'charger', 'solarx', 'assets/Level 1 Lite.png', '{"power": "3kW", "solar_powered": true, "warranty": "2 years"}'),
('Tezzon Charge Ultra', 'Ultra-fast dual port charger. Ideal for high-traffic stations.', 64999.00, 'charger', 'ultra', 'assets/Level 1 Pro.jpg', '{"power": "6kW", "dual_port": true, "warranty": "3 years"}'),
('Tezzon Charge Compact', 'Wall-mounted compact EV charger. Perfect for homes & PGs.', 39999.00, 'charger', 'compact', 'assets/Fast-charger 3kw.jpg', '{"power": "3kW", "wall_mounted": true, "warranty": "2 years"}'),
('Tezzon Charge ScootyPro', 'Exclusive charger for Ather & Ola scooters. Light & fast.', 29499.00, 'charger', 'scootypro', 'assets/Fast_charger 6kw.jpg', '{"power": "2kW", "scooter_compatible": true, "warranty": "1 year"}'),
('Tezzon Charge Station Hub', 'Smart charging hub for commercial EV stations with analytics.', 125000.00, 'charger', 'stationhub', 'assets/Charge_Hub.jpg', '{"power": "10kW", "analytics": true, "warranty": "5 years"}'),
('Tezzon Charge SolarX Pro', 'Advanced solar-powered charger with smart grid integration.', 89999.00, 'charger', 'solarxpro', 'assets/Level3 Chargers.png', '{"power": "5kW", "smart_grid": true, "warranty": "3 years"}');

-- Insert Sample Charging Stations
INSERT INTO charging_stations (name, location, address, latitude, longitude, status, charging_type, fast_charging, rating, total_reviews, phone, operating_hours, amenities) VALUES
('Tezzon Charge - Indiranagar Hub', 'Indiranagar, Bangalore', '100 Feet Road, Near Metro Station', 12.9716, 77.5946, 'available', 'fast', TRUE, 4.8, 156, '+91 80 1234 5678', '24/7', '["WiFi", "Cafe", "Rest Area", "Security"]'),
('Tezzon Charge - Koramangala Central', 'Koramangala, Bangalore', '8th Block, Near Forum Mall', 12.9352, 77.6245, 'in_use', 'fast', TRUE, 4.6, 89, '+91 80 1234 5679', '24/7', '["WiFi", "Shopping", "Food Court", "Parking"]'),
('Tezzon Charge - MG Road Premium', 'MG Road, Bangalore', 'Near Trinity Metro Station', 12.9716, 77.5946, 'maintenance', 'standard', FALSE, 4.4, 234, '+91 80 1234 5680', '6 AM - 10 PM', '["WiFi", "Premium Lounge", "Coffee Shop"]'),
('Tezzon Charge - Whitefield Tech Park', 'Whitefield, Bangalore', 'ITPL Road, Near Tech Park', 12.9716, 77.5946, 'available', 'fast', TRUE, 4.9, 67, '+91 80 1234 5681', '24/7', '["WiFi", "Tech Lounge", "Meeting Rooms", "EV Service"]'),
('Tezzon Charge - Electronic City', 'Electronic City, Bangalore', 'Phase 1, Near Infosys Campus', 12.9716, 77.5946, 'available', 'fast', TRUE, 4.7, 123, '+91 80 1234 5682', '24/7', '["WiFi", "Food Court", "Rest Area", "Security"]'),
('Tezzon Charge - Marathahalli', 'Marathahalli, Bangalore', 'Outer Ring Road, Near Mall', 12.9716, 77.5946, 'in_use', 'standard', FALSE, 4.3, 45, '+91 80 1234 5683', '6 AM - 11 PM', '["WiFi", "Shopping", "Food", "Parking"]');

-- Insert Sample Services
INSERT INTO services (title, description) VALUES
('Ultra-fast EV Charging', 'Charge your two-wheeler in just 10–15 minutes.'),
('Mobile App Support', 'Manage charging, subscriptions and energy reports.'),
('24/7 Support', 'On-site & remote assistance anytime.');

-- Insert Sample Contact Inquiries
INSERT INTO contact_inquiries (name, email, phone, subject, message, inquiry_type) VALUES
('Rahul Kumar', 'rahul@example.com', '+91 98765 43214', 'Product Inquiry', 'I would like to know more about the SolarX charger.', 'sales'),
('Priya Sharma', 'priya@example.com', '+91 98765 43215', 'Technical Support', 'Having issues with my charger installation.', 'support'),
('Amit Patel', 'amit@example.com', '+91 98765 43216', 'Partnership Interest', 'Interested in becoming a franchise partner.', 'partnership');

-- Insert Sample Partners
INSERT INTO partners (user_id, company_name, partner_type, contact_person, phone, email, status, description) VALUES
(4, 'Green Energy Solutions', 'franchise', 'Mike Johnson', '+91 98765 43213', 'mike@example.com', 'pending', 'Interested in setting up multiple charging stations in Delhi NCR region.');

-- =====================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- =====================================================

-- Trigger to update station rating when review is added
DELIMITER //
CREATE TRIGGER update_station_rating_after_review
AFTER INSERT ON station_reviews
FOR EACH ROW
BEGIN
    UPDATE charging_stations 
    SET rating = (
        SELECT AVG(rating) 
        FROM station_reviews 
        WHERE station_id = NEW.station_id
    ),
    total_reviews = (
        SELECT COUNT(*) 
        FROM station_reviews 
        WHERE station_id = NEW.station_id
    )
    WHERE id = NEW.station_id;
END//
DELIMITER ;

-- Trigger to generate order number
DELIMITER //
CREATE TRIGGER generate_order_number
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.order_number IS NULL THEN
        SET NEW.order_number = CONCAT('TC-', YEAR(NOW()), '-', LPAD((SELECT COUNT(*) + 1 FROM orders WHERE YEAR(created_at) = YEAR(NOW())), 3, '0'));
    END IF;
END//
DELIMITER ;

-- =====================================================
-- VIEWS FOR COMMON QUERIES
-- =====================================================

-- View for order details with user and product information
CREATE VIEW order_details_view AS
SELECT 
    o.id,
    o.order_number,
    o.total_amount,
    o.status,
    o.payment_status,
    o.order_date,
    u.full_name,
    u.email,
    u.phone,
    CONCAT(ua.address_line1, ', ', ua.city, ' - ', ua.pincode) as shipping_address
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN user_addresses ua ON o.shipping_address_id = ua.id;

-- View for station details with average rating
CREATE VIEW station_details_view AS
SELECT 
    cs.*,
    COALESCE(AVG(sr.rating), 0) as average_rating,
    COUNT(sr.id) as review_count
FROM charging_stations cs
LEFT JOIN station_reviews sr ON cs.id = sr.station_id
GROUP BY cs.id;

-- View for product sales summary
CREATE VIEW product_sales_summary AS
SELECT 
    p.id,
    p.name,
    p.price,
    COUNT(oi.id) as total_orders,
    SUM(oi.quantity) as total_quantity_sold,
    SUM(oi.total_price) as total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Procedure to get user order history
DELIMITER //
CREATE PROCEDURE GetUserOrderHistory(IN user_email VARCHAR(100))
BEGIN
    SELECT 
        o.order_number,
        o.total_amount,
        o.status,
        o.order_date,
        GROUP_CONCAT(CONCAT(oi.quantity, 'x ', p.name) SEPARATOR ', ') as items
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON oi.product_id = p.id
    JOIN users u ON o.user_id = u.id
    WHERE u.email = user_email
    GROUP BY o.id
    ORDER BY o.order_date DESC;
END//
DELIMITER ;

-- Procedure to get nearby charging stations
DELIMITER //
CREATE PROCEDURE GetNearbyStations(
    IN user_lat DECIMAL(10,8),
    IN user_lng DECIMAL(11,8),
    IN radius_km DECIMAL(5,2)
)
BEGIN
    SELECT 
        *,
        (6371 * acos(cos(radians(user_lat)) * cos(radians(latitude)) * 
        cos(radians(longitude) - radians(user_lng)) + 
        sin(radians(user_lat)) * sin(radians(latitude)))) AS distance_km
    FROM charging_stations
    HAVING distance_km <= radius_km
    ORDER BY distance_km;
END//
DELIMITER ;

-- =====================================================
-- COMMENTS AND DOCUMENTATION
-- =====================================================

/*
Tezzon Charge Database Schema Documentation

This database supports the following main functionalities:
1. User Management - Registration, profiles, addresses
2. Product Catalog - EV chargers and accessories
3. Order Management - Shopping cart, orders, tracking
4. Charging Stations - Location management, reviews, status
5. Partner Management - Franchise, leasing, co-branding
6. Customer Support - Contact forms, inquiries
7. Payment Processing - Transaction tracking
8. Analytics - Sales reports, station usage

Key Features:
- Comprehensive user management with multiple address support
- Flexible product catalog with JSON specifications
- Complete order lifecycle tracking
- Real-time charging station status and reviews
- Partner registration and management
- Payment transaction logging
- Automated triggers for data consistency
- Optimized indexes for performance
- Views for common reporting queries
- Stored procedures for complex operations

Maintenance Notes:
- Regular backup of all tables
- Monitor index performance
- Update station ratings after review changes
- Clean up old tracking records periodically
- Archive completed orders after 2 years
*/

-- =====================================================
-- END OF DATABASE SCHEMA
-- =====================================================



