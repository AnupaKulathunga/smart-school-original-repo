-- ============================================================
-- Migration 003: Disability Support Feature
-- ============================================================
-- Features:
-- 1. Disability fields on students table
-- 2. Disability types lookup table
-- 3. Exam accommodation settings
-- 4. RBAC permissions for disability management
-- ============================================================

-- ============================================================
-- 1. Add disability fields to students table
-- ============================================================
-- Note: Using procedures to safely add columns if they don't exist

SET @dbname = DATABASE();

-- Add is_disabled column
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = 'students' AND COLUMN_NAME = 'is_disabled');
SET @sql = IF(@col_exists = 0, "ALTER TABLE `students` ADD COLUMN `is_disabled` ENUM('yes','no') DEFAULT 'no' AFTER `is_active`", 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add disability_type_id column
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = 'students' AND COLUMN_NAME = 'disability_type_id');
SET @sql = IF(@col_exists = 0, "ALTER TABLE `students` ADD COLUMN `disability_type_id` INT(11) DEFAULT NULL AFTER `is_disabled`", 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add disability_details column
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = 'students' AND COLUMN_NAME = 'disability_details');
SET @sql = IF(@col_exists = 0, "ALTER TABLE `students` ADD COLUMN `disability_details` TEXT DEFAULT NULL AFTER `disability_type_id`", 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ============================================================
-- 2. Create disability_types lookup table
-- ============================================================
CREATE TABLE IF NOT EXISTS `disability_types` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `description` TEXT DEFAULT NULL,
    `default_extra_time_percent` INT(11) NOT NULL DEFAULT 25,
    `is_active` ENUM('yes','no') DEFAULT 'yes',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert default disability types
INSERT INTO `disability_types` (`name`, `description`, `default_extra_time_percent`) VALUES
('Visual Impairment', 'Includes blindness, low vision, color blindness', 50),
('Hearing Impairment', 'Includes deafness, hard of hearing', 25),
('Physical Disability', 'Mobility impairments, motor disabilities', 25),
('Learning Disability', 'Dyslexia, dyscalculia, dysgraphia', 50),
('Cognitive Disability', 'Intellectual disabilities, memory impairments', 50),
('Speech Impairment', 'Speech and language disorders', 25),
('Other', 'Other disabilities not listed above', 25)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- ============================================================
-- 3. Add accommodation settings to onlineexam table
-- ============================================================
-- Add accommodate_disabled column
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = 'onlineexam' AND COLUMN_NAME = 'accommodate_disabled');
SET @sql = IF(@col_exists = 0, "ALTER TABLE `onlineexam` ADD COLUMN `accommodate_disabled` ENUM('yes','no') DEFAULT 'no' AFTER `is_random_question`", 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add disabled_extra_time_percent column
SET @col_exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = 'onlineexam' AND COLUMN_NAME = 'disabled_extra_time_percent');
SET @sql = IF(@col_exists = 0, "ALTER TABLE `onlineexam` ADD COLUMN `disabled_extra_time_percent` INT(11) DEFAULT 25 AFTER `accommodate_disabled`", 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ============================================================
-- 4. RBAC Permissions for Disability Management
-- ============================================================

-- Add permission category for Disability Types
INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT 5020, 1, 'Disability Types', 'disability_types', 1, 1, 1, 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `id` = 5020);

-- Add permission category for Disabled Students Report
INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT 5021, 1, 'Disabled Students Report', 'disabled_students_report', 1, 0, 0, 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `id` = 5021);

-- Grant permissions to Admin (role_id = 1) and Teacher (role_id = 2)
-- Disability Types - Admin
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 1, 5020, 1, 1, 1, 1, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 1 AND `perm_cat_id` = 5020);

-- Disability Types - Teacher/Lecturer
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 2, 5020, 1, 1, 1, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 2 AND `perm_cat_id` = 5020);

-- Disabled Students Report - Admin
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 1, 5021, 1, 0, 0, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 1 AND `perm_cat_id` = 5021);

-- Disabled Students Report - Teacher
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 2, 5021, 1, 0, 0, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 2 AND `perm_cat_id` = 5021);

-- ============================================================
-- 5. Sidebar Menu Entries
-- ============================================================

-- Add Disability Types submenu under Student Information (sidebar_menu_id = 2)
-- Following same pattern as Student Categories (url='category', controller='category')
INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `addon_permission`, `is_active`, `created_at`)
SELECT 2, 'disability_types', NULL, 'disability_types', 'disabilitytype', 8, '(\'disability_types\', \'can_view\')', NULL, 'disabilitytype', 'index,edit', '', 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'disabilitytype');

-- Add Students with Disabilities Report submenu under Student Information (sidebar_menu_id = 2)
-- Note: Uses 'students_with_disabilities' to distinguish from 'disabled_students' (deactivated students)
INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `addon_permission`, `is_active`, `created_at`)
SELECT 2, 'students_with_disabilities', NULL, 'students_with_disabilities', 'disabilitytype/students', 9, '(\'disabled_students_report\', \'can_view\')', NULL, 'disabilitytype', 'students', '', 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'disabilitytype/students');

-- ============================================================
-- 6. Index for performance (skip if already exists)
-- ============================================================
-- Indexes are optional and will be created on next schema update if needed
