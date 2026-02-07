-- Migration 023: Transport and route stub tables

-- Route pickup point
CREATE TABLE IF NOT EXISTS `route_pickup_point` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_id` int(11) DEFAULT NULL,
  `pickup_point` varchar(100) DEFAULT NULL,
  `pickup_time` time DEFAULT NULL,
  `fees` decimal(15,2) DEFAULT 0.00,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Routes
CREATE TABLE IF NOT EXISTS `routes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_title` varchar(100) DEFAULT NULL,
  `note` text,
  `is_active` varchar(10) DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle_no` varchar(50) DEFAULT NULL,
  `vehicle_model` varchar(100) DEFAULT NULL,
  `driver_name` varchar(100) DEFAULT NULL,
  `driver_licence` varchar(50) DEFAULT NULL,
  `driver_contact` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Add missing columns to student_transport_fees
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'student_transport_fees' AND COLUMN_NAME = 'student_session_id');
SET @query = IF(@col_exists = 0, 'ALTER TABLE student_transport_fees ADD COLUMN student_session_id int(11) DEFAULT NULL', 'SELECT 1');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'student_transport_fees' AND COLUMN_NAME = 'route_pickup_point_id');
SET @query = IF(@col_exists = 0, 'ALTER TABLE student_transport_fees ADD COLUMN route_pickup_point_id int(11) DEFAULT NULL', 'SELECT 1');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add missing columns to transport_feemaster
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'transport_feemaster' AND COLUMN_NAME = 'fine_amount');
SET @query = IF(@col_exists = 0, 'ALTER TABLE transport_feemaster ADD COLUMN fine_amount decimal(15,2) DEFAULT 0.00', 'SELECT 1');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'transport_feemaster' AND COLUMN_NAME = 'fine_type');
SET @query = IF(@col_exists = 0, 'ALTER TABLE transport_feemaster ADD COLUMN fine_type varchar(50) DEFAULT NULL', 'SELECT 1');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'transport_feemaster' AND COLUMN_NAME = 'fine_percentage');
SET @query = IF(@col_exists = 0, 'ALTER TABLE transport_feemaster ADD COLUMN fine_percentage decimal(5,2) DEFAULT 0.00', 'SELECT 1');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Record migration
INSERT IGNORE INTO `migrations` (`version`) VALUES (23);
