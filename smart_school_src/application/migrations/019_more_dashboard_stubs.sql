-- Migration 019: More stub tables needed by dashboard
-- Additional tables for fee tracking

-- Student fees deposite (payment records)
CREATE TABLE IF NOT EXISTS `student_fees_deposite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_fees_master_id` int(11) DEFAULT NULL,
  `fee_groups_feetype_id` int(11) DEFAULT NULL,
  `amount_detail` text,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Add session_id to fee_groups_feetype if not exists
-- Using a procedure to handle "column already exists" gracefully
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'fee_groups_feetype' AND COLUMN_NAME = 'session_id');
SET @query = IF(@col_exists = 0, 'ALTER TABLE fee_groups_feetype ADD COLUMN session_id int(11) DEFAULT NULL', 'SELECT 1');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Record this migration
INSERT IGNORE INTO `migrations` (`version`) VALUES (19);
