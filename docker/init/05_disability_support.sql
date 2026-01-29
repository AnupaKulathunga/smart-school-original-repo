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
ALTER TABLE `students`
ADD COLUMN IF NOT EXISTS `is_disabled` ENUM('yes','no') DEFAULT 'no' AFTER `is_active`,
ADD COLUMN IF NOT EXISTS `disability_type_id` INT(11) DEFAULT NULL AFTER `is_disabled`,
ADD COLUMN IF NOT EXISTS `disability_details` TEXT DEFAULT NULL AFTER `disability_type_id`;

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
ALTER TABLE `onlineexam`
ADD COLUMN IF NOT EXISTS `accommodate_disabled` ENUM('yes','no') DEFAULT 'no' AFTER `is_random_question`,
ADD COLUMN IF NOT EXISTS `disabled_extra_time_percent` INT(11) DEFAULT 25 AFTER `accommodate_disabled`;

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
-- 5. Index for performance
-- ============================================================
CREATE INDEX IF NOT EXISTS `idx_students_disabled` ON `students` (`is_disabled`);
CREATE INDEX IF NOT EXISTS `idx_students_disability_type` ON `students` (`disability_type_id`);
