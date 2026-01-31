-- ============================================================================
-- TVET Missing Tables Migration
-- Adds ICASS Config, Moderation Log, and Qualification Requirements
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. ICASS Configuration Table
-- ============================================================================

CREATE TABLE IF NOT EXISTS `tvet_icass_config` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `level_module_id` INT UNSIGNED NOT NULL COMMENT 'Which module this config applies to',
  `component_name` VARCHAR(100) NOT NULL COMMENT 'e.g., Tests, Assignments, Practical',
  `component_type` ENUM('Test', 'Assignment', 'Project', 'Practical', 'Exam', 'POE', 'Other') NOT NULL,
  `weight_percentage` DECIMAL(5,2) NOT NULL DEFAULT 0 COMMENT 'Weight in ICASS calculation',
  `min_assessments` TINYINT(2) DEFAULT 1 COMMENT 'Minimum number of this type required',
  `pass_percentage` DECIMAL(5,2) DEFAULT 40.00 COMMENT 'Minimum pass percentage',
  `is_compulsory` TINYINT(1) DEFAULT 1,
  `sequence_order` TINYINT(2) DEFAULT 1,
  `active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_level_module` (`level_module_id`),
  CONSTRAINT `fk_icass_level_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 2. Moderation Log Table
-- ============================================================================

CREATE TABLE IF NOT EXISTS `tvet_moderation_log` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `assessment_id` INT UNSIGNED NOT NULL,
  `moderator_id` INT NOT NULL COMMENT 'Staff ID of moderator',
  `action` ENUM('Submitted', 'Under Review', 'Approved', 'Rejected', 'Revised') NOT NULL,
  `comments` TEXT NULL DEFAULT NULL,
  `previous_status` VARCHAR(50) NULL DEFAULT NULL,
  `new_status` VARCHAR(50) NULL DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_assessment` (`assessment_id`),
  KEY `idx_moderator` (`moderator_id`),
  CONSTRAINT `fk_moderation_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `tvet_assessment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 3. Qualification Requirements Table (which modules needed for qualification)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `tvet_qualification_requirement` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `qualification_id` INT UNSIGNED NOT NULL,
  `level_module_id` INT UNSIGNED NOT NULL COMMENT 'Which module is required',
  `is_compulsory` TINYINT(1) DEFAULT 1 COMMENT '1 = Core/Compulsory, 0 = Elective',
  `elective_group` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Group name for elective modules',
  `min_electives_from_group` TINYINT(2) NULL DEFAULT NULL COMMENT 'How many electives needed from this group',
  `credit_value` TINYINT(3) UNSIGNED DEFAULT 0,
  `prerequisite_module_id` INT UNSIGNED NULL DEFAULT NULL COMMENT 'Must pass this module first',
  `notes` TEXT NULL DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_qual_module` (`qualification_id`, `level_module_id`),
  KEY `idx_qualification` (`qualification_id`),
  KEY `idx_module` (`level_module_id`),
  CONSTRAINT `fk_qualreq_qualification` FOREIGN KEY (`qualification_id`) REFERENCES `tvet_qualification` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_qualreq_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 4. POE Items Table (Portfolio of Evidence)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `tvet_poe_item` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `student_enrolment_id` INT UNSIGNED NOT NULL,
  `level_module_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `item_type` ENUM('Assignment', 'Project', 'Practical', 'Test', 'Reflection', 'Other') NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `file_path` VARCHAR(500) NULL DEFAULT NULL,
  `submitted_date` DATE NOT NULL,
  `verification_status` ENUM('Pending', 'Verified', 'Rejected') DEFAULT 'Pending',
  `verified_by` INT NULL DEFAULT NULL,
  `verification_date` DATE NULL DEFAULT NULL,
  `verification_comment` TEXT NULL DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_enrolment` (`student_enrolment_id`),
  KEY `idx_module` (`level_module_id`),
  KEY `idx_status` (`verification_status`),
  CONSTRAINT `fk_poe_enrolment` FOREIGN KEY (`student_enrolment_id`) REFERENCES `tvet_student_enrolment` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_poe_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 5. Add permission categories for new features
-- ============================================================================

SET @perm_group_id = (SELECT id FROM permission_group WHERE name = 'System Admin' LIMIT 1);
SET @perm_group_id = IFNULL(@perm_group_id, 1);

-- ICASS Configuration permission
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'ICASS Configuration', 'tvet_icass_config', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'tvet_icass_config');

-- Qualification Requirements permission
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Qualification Requirements', 'tvet_qualification_requirements', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'tvet_qualification_requirements');

-- POE Management permission
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'POE Management', 'tvet_poe', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'tvet_poe');

-- ============================================================================
-- 6. Add ICASS Configuration submenu
-- ============================================================================

SET @academic_menu_id = (SELECT id FROM `sidebar_menus` WHERE `menu` = 'Academic Management' LIMIT 1);

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'icass_config', NULL, 'icass_configuration', 'admin/tvet/icass_config', 11, '(\'tvet_icass_config\', \'can_view\')', NULL, 'tvet', 'icass_config', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/tvet/icass_config');

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- END OF MIGRATION
-- ============================================================================
