-- Migration 022: Complete fee system stub tables

-- Student fees master
CREATE TABLE IF NOT EXISTS `student_fees_master` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) DEFAULT NULL,
  `fee_session_group_id` int(11) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Fee session groups
CREATE TABLE IF NOT EXISTS `fee_session_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fee_groups_id` int(11) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Add fee_groups_id to fee_groups_feetype if not exists
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fee_groups_feetype' AND COLUMN_NAME = 'fee_groups_id');
SET @query = IF(@col_exists = 0, 'ALTER TABLE fee_groups_feetype ADD COLUMN fee_groups_id int(11) DEFAULT NULL', 'SELECT 1');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add student_fees_master_id to student_fees_deposite
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'student_fees_deposite' AND COLUMN_NAME = 'student_fees_master_id');
SET @query = IF(@col_exists = 0, 'ALTER TABLE student_fees_deposite ADD COLUMN student_fees_master_id int(11) DEFAULT NULL', 'SELECT 1');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add is_system column to fee_groups
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fee_groups' AND COLUMN_NAME = 'is_system');
SET @query = IF(@col_exists = 0, 'ALTER TABLE fee_groups ADD COLUMN is_system tinyint(1) DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Record migration
INSERT IGNORE INTO `migrations` (`version`) VALUES (22);
