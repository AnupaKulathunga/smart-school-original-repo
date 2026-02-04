-- Migration 016: Create feecategory table
-- Fixes exam schedule and marks entry page errors
-- Date: 2026-02-04
-- Issue: Table 'smart_school.feecategory' doesn't exist

-- Create feecategory table
CREATE TABLE IF NOT EXISTS `feecategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `feecategory` varchar(200) NOT NULL,
  `description` text,
  `is_active` varchar(10) NOT NULL DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default fee categories
INSERT INTO `feecategory` (`feecategory`, `description`, `is_active`) VALUES
('Tuition Fee', 'Regular tuition fees for academic programs', 'yes'),
('Exam Fee', 'Examination and assessment fees', 'yes'),
('Registration Fee', 'Student registration and enrollment fees', 'yes'),
('Library Fee', 'Library membership and resource access fees', 'yes'),
('Transport Fee', 'Transportation and bus service fees', 'yes'),
('Hostel Fee', 'Accommodation and hostel facility fees', 'yes'),
('Sports Fee', 'Sports and recreation facility fees', 'yes'),
('Laboratory Fee', 'Laboratory and practical session fees', 'yes'),
('Technology Fee', 'Computer lab and technology access fees', 'yes'),
('Activity Fee', 'Extra-curricular activities and events fees', 'yes');

-- Verify creation
SELECT COUNT(*) as total_categories FROM feecategory;

-- Show success message
SELECT 'feecategory table created successfully' as status;
