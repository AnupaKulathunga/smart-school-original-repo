-- Migration 020: Fee and transport related stub tables

-- Student transport fees
CREATE TABLE IF NOT EXISTS `student_transport_fees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `transport_feemaster_id` int(11) DEFAULT NULL,
  `fees` decimal(15,2) DEFAULT 0.00,
  `amount_detail` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Transport fee master
CREATE TABLE IF NOT EXISTS `transport_feemaster` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` int(11) DEFAULT NULL,
  `month` varchar(20) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT 0.00,
  `due_date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Add student_transport_fee_id to student_fees_deposite
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'student_fees_deposite' AND COLUMN_NAME = 'student_transport_fee_id');
SET @query = IF(@col_exists = 0, 'ALTER TABLE student_fees_deposite ADD COLUMN student_transport_fee_id int(11) DEFAULT NULL', 'SELECT 1');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Class model table (for TVET classes dropdown)
CREATE TABLE IF NOT EXISTS `classmodel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'yes',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Record migration
INSERT IGNORE INTO `migrations` (`version`) VALUES (20);
