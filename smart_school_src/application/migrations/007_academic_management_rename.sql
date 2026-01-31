-- ============================================================================
-- Academic Management Migration
-- Renames TVET Management to Academic Management and deprecates old Academics
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. RENAME TVET MANAGEMENT TO ACADEMIC MANAGEMENT
-- ============================================================================

-- Update main menu
UPDATE `sidebar_menus`
SET `menu` = 'Academic Management',
    `lang_key` = 'academic_management',
    `activate_menu` = 'academic_management'
WHERE `menu` = 'TVET Management';

-- Update submenus lang_keys for better consistency
UPDATE `sidebar_sub_menus` ssm
JOIN `sidebar_menus` sm ON ssm.sidebar_menu_id = sm.id
SET ssm.lang_key = REPLACE(ssm.lang_key, 'tvet_', 'academic_')
WHERE sm.menu = 'Academic Management';

-- ============================================================================
-- 2. DEPRECATE OLD ACADEMICS MENU (hide it but don't delete)
-- ============================================================================

-- Deactivate the old Academics menu
UPDATE `sidebar_menus`
SET `is_active` = 0
WHERE `menu` = 'Academics' AND `lang_key` = 'academics';

-- ============================================================================
-- 3. ADD MISSING SUBMENUS FOR ACADEMIC MANAGEMENT
-- ============================================================================

-- Get the Academic Management menu ID
SET @academic_menu_id = (SELECT id FROM `sidebar_menus` WHERE `menu` = 'Academic Management' LIMIT 1);

-- Add Attendance submenu if not exists
INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'attendance', NULL, 'attendance', 'admin/tvet/attendance', 8, '(\'tvet_attendance\', \'can_view\')', NULL, 'tvet', 'attendance,mark_attendance', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/tvet/attendance');

-- Add Assessments submenu if not exists
INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'assessments', NULL, 'assessments', 'admin/tvet/assessments', 9, '(\'tvet_assessment\', \'can_view\')', NULL, 'tvet', 'assessments,assessment_add,assessment_edit,marks_entry', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/tvet/assessments');

-- Add Reports submenu if not exists
INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'reports', NULL, 'reports', 'admin/tvet/reports', 10, '(\'tvet_reports\', \'can_view\')', NULL, 'tvet', 'reports', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/tvet/reports');

-- ============================================================================
-- 4. ADD MISSING PERMISSIONS
-- ============================================================================

-- Get permission group ID
SET @perm_group_id = (SELECT id FROM permission_group WHERE name = 'System Admin' LIMIT 1);
SET @perm_group_id = IFNULL(@perm_group_id, 1);

-- Add attendance permission if not exists
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'TVET Attendance', 'tvet_attendance', 1, 1, 1, 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'tvet_attendance');

-- Add assessment permission if not exists (might already exist)
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'TVET Assessments', 'tvet_assessment', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'tvet_assessment');

-- Add reports permission if not exists
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'TVET Reports', 'tvet_reports', 1, 0, 0, 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'tvet_reports');

-- ============================================================================
-- 5. ADD TVET ATTENDANCE TABLE IF NOT EXISTS
-- ============================================================================

CREATE TABLE IF NOT EXISTS `tvet_attendance` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_enrolment_id` INT UNSIGNED NOT NULL,
  `level_module_id` INT UNSIGNED NOT NULL,
  `cohort_id` INT UNSIGNED NOT NULL,
  `attendance_date` DATE NOT NULL,
  `status` ENUM('Present', 'Absent', 'Late', 'Excused') NOT NULL DEFAULT 'Present',
  `remarks` VARCHAR(255) NULL DEFAULT NULL,
  `marked_by` INT NULL DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_attendance` (`student_enrolment_id`, `level_module_id`, `attendance_date`),
  KEY `idx_date` (`attendance_date`),
  KEY `idx_cohort` (`cohort_id`),
  KEY `idx_module` (`level_module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 6. ADD MISSING COLUMNS TO EXISTING TVET TABLES (using procedure for MySQL 8.0)
-- ============================================================================

DELIMITER //

DROP PROCEDURE IF EXISTS add_column_if_not_exists//
CREATE PROCEDURE add_column_if_not_exists(
    IN p_table VARCHAR(64),
    IN p_column VARCHAR(64),
    IN p_definition VARCHAR(500)
)
BEGIN
    SET @col_exists = (
        SELECT COUNT(*) FROM information_schema.columns
        WHERE table_schema = DATABASE()
        AND table_name = p_table
        AND column_name = p_column
    );

    IF @col_exists = 0 THEN
        SET @sql = CONCAT('ALTER TABLE `', p_table, '` ADD COLUMN `', p_column, '` ', p_definition);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END//

DELIMITER ;

-- Add status column to tvet_assessment if not exists
CALL add_column_if_not_exists('tvet_assessment', 'status', "ENUM('Draft', 'Published', 'Active', 'Closed', 'Archived') DEFAULT 'Draft'");

-- Add is_online column to tvet_assessment if not exists
CALL add_column_if_not_exists('tvet_assessment', 'is_online', 'TINYINT(1) DEFAULT 0');

-- Add instructions column to tvet_assessment if not exists
CALL add_column_if_not_exists('tvet_assessment', 'instructions', 'TEXT NULL DEFAULT NULL');

-- Add grade column to tvet_assessment_marks if not exists
CALL add_column_if_not_exists('tvet_assessment_marks', 'grade', 'VARCHAR(5) NULL DEFAULT NULL');

-- Add percentage column to tvet_assessment_marks if not exists
CALL add_column_if_not_exists('tvet_assessment_marks', 'percentage', 'DECIMAL(5,2) NULL DEFAULT NULL');

-- Add is_absent column to tvet_assessment_marks if not exists
CALL add_column_if_not_exists('tvet_assessment_marks', 'is_absent', 'TINYINT(1) DEFAULT 0');

-- Cleanup
DROP PROCEDURE IF EXISTS add_column_if_not_exists;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- END OF MIGRATION
-- ============================================================================
