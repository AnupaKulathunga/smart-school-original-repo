-- ================================================================
-- Migration 026: Regression Test Fixes
--
-- Adds missing tables and columns discovered during UI regression testing
-- These are legacy tables referenced by existing code that need stub implementations
-- ================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ================================================================
-- SECTION 1: MISSING TABLES
-- ================================================================

-- School Houses table
CREATE TABLE IF NOT EXISTS `school_houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `house_name` varchar(100) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exam Groups table
CREATE TABLE IF NOT EXISTS `exam_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `exam_type` varchar(100) DEFAULT NULL,
  `description` text,
  `session_id` int(11) DEFAULT NULL,
  `is_publish` int(11) DEFAULT 0,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exams table
CREATE TABLE IF NOT EXISTS `exams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `note` text,
  `is_active` varchar(10) DEFAULT 'no',
  `is_publish` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Exam Group Class Batch Exams table
CREATE TABLE IF NOT EXISTS `exam_group_class_batch_exams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exam_group_id` int(11) DEFAULT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Upload Contents table
CREATE TABLE IF NOT EXISTS `upload_contents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_title` varchar(200) NOT NULL,
  `content_type` varchar(100) DEFAULT NULL,
  `file_name` varchar(200) DEFAULT NULL,
  `file_type` varchar(100) DEFAULT NULL,
  `file_size` varchar(50) DEFAULT NULL,
  `upload_date` date DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Transport Route table
CREATE TABLE IF NOT EXISTS `transport_route` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_title` varchar(200) NOT NULL,
  `fare` decimal(10,2) DEFAULT 0.00,
  `note` text,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Hostel table
CREATE TABLE IF NOT EXISTS `hostel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostel_name` varchar(100) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `address` text,
  `intake` int(11) DEFAULT 0,
  `description` text,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Fees Discounts table
CREATE TABLE IF NOT EXISTS `fees_discounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT 0.00,
  `is_active` varchar(10) DEFAULT 'yes',
  `description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Disability Types table
CREATE TABLE IF NOT EXISTS `disability_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ================================================================
-- SECTION 2: MISSING COLUMNS (using stored procedures for safety)
-- ================================================================

-- Add income.documents column if not exists
DROP PROCEDURE IF EXISTS add_income_documents;
DELIMITER //
CREATE PROCEDURE add_income_documents()
BEGIN
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS
                 WHERE TABLE_SCHEMA = DATABASE()
                 AND TABLE_NAME = 'income'
                 AND COLUMN_NAME = 'documents') THEN
    ALTER TABLE `income` ADD COLUMN `documents` varchar(500) DEFAULT NULL;
  END IF;
END //
DELIMITER ;
CALL add_income_documents();
DROP PROCEDURE IF EXISTS add_income_documents;

-- Add income.note column if not exists
DROP PROCEDURE IF EXISTS add_income_note;
DELIMITER //
CREATE PROCEDURE add_income_note()
BEGIN
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS
                 WHERE TABLE_SCHEMA = DATABASE()
                 AND TABLE_NAME = 'income'
                 AND COLUMN_NAME = 'note') THEN
    ALTER TABLE `income` ADD COLUMN `note` text DEFAULT NULL;
  END IF;
END //
DELIMITER ;
CALL add_income_note();
DROP PROCEDURE IF EXISTS add_income_note;

-- Add expenses.invoice_no column if not exists
DROP PROCEDURE IF EXISTS add_expenses_invoice_no;
DELIMITER //
CREATE PROCEDURE add_expenses_invoice_no()
BEGIN
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS
                 WHERE TABLE_SCHEMA = DATABASE()
                 AND TABLE_NAME = 'expenses'
                 AND COLUMN_NAME = 'invoice_no') THEN
    ALTER TABLE `expenses` ADD COLUMN `invoice_no` varchar(100) DEFAULT NULL;
  END IF;
END //
DELIMITER ;
CALL add_expenses_invoice_no();
DROP PROCEDURE IF EXISTS add_expenses_invoice_no;

-- Add expenses.documents column if not exists
DROP PROCEDURE IF EXISTS add_expenses_documents;
DELIMITER //
CREATE PROCEDURE add_expenses_documents()
BEGIN
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS
                 WHERE TABLE_SCHEMA = DATABASE()
                 AND TABLE_NAME = 'expenses'
                 AND COLUMN_NAME = 'documents') THEN
    ALTER TABLE `expenses` ADD COLUMN `documents` varchar(500) DEFAULT NULL;
  END IF;
END //
DELIMITER ;
CALL add_expenses_documents();
DROP PROCEDURE IF EXISTS add_expenses_documents;

-- Add expenses.note column if not exists
DROP PROCEDURE IF EXISTS add_expenses_note;
DELIMITER //
CREATE PROCEDURE add_expenses_note()
BEGIN
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS
                 WHERE TABLE_SCHEMA = DATABASE()
                 AND TABLE_NAME = 'expenses'
                 AND COLUMN_NAME = 'note') THEN
    ALTER TABLE `expenses` ADD COLUMN `note` text DEFAULT NULL;
  END IF;
END //
DELIMITER ;
CALL add_expenses_note();
DROP PROCEDURE IF EXISTS add_expenses_note;

-- Add enquiry.class_id column if not exists
DROP PROCEDURE IF EXISTS add_enquiry_class_id;
DELIMITER //
CREATE PROCEDURE add_enquiry_class_id()
BEGIN
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS
                 WHERE TABLE_SCHEMA = DATABASE()
                 AND TABLE_NAME = 'enquiry'
                 AND COLUMN_NAME = 'class_id') THEN
    ALTER TABLE `enquiry` ADD COLUMN `class_id` int(11) DEFAULT NULL;
  END IF;
END //
DELIMITER ;
CALL add_enquiry_class_id();
DROP PROCEDURE IF EXISTS add_enquiry_class_id;

-- Add feetype.nature column if not exists
DROP PROCEDURE IF EXISTS add_feetype_nature;
DELIMITER //
CREATE PROCEDURE add_feetype_nature()
BEGIN
  IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS
                 WHERE TABLE_SCHEMA = DATABASE()
                 AND TABLE_NAME = 'feetype'
                 AND COLUMN_NAME = 'nature') THEN
    ALTER TABLE `feetype` ADD COLUMN `nature` varchar(50) DEFAULT 'custom';
  END IF;
END //
DELIMITER ;
CALL add_feetype_nature();
DROP PROCEDURE IF EXISTS add_feetype_nature;

SET FOREIGN_KEY_CHECKS = 1;

-- ================================================================
-- Record migration
-- ================================================================
INSERT INTO `migrations` (`migration`) VALUES ('026_regression_test_fixes')
ON DUPLICATE KEY UPDATE `migration` = '026_regression_test_fixes';
