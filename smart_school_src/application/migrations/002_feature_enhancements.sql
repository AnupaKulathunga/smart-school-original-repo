-- ============================================================
-- Feature Enhancements - Database Migration
-- Smart School v7.1.0 → Feature Enhancements
-- Covers: Zip Upload Fix, Content Views, Exam Moderation, Accommodations, Teams
-- Compatible with MySQL 5.5+
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- Item 8: Fix Zip Upload - Update filetypes to include all zip MIME types
-- ============================================================
UPDATE `filetypes` SET
    `file_extension` = CASE
        WHEN `file_extension` NOT LIKE '%zip%'
        THEN CONCAT(`file_extension`, ', zip')
        ELSE `file_extension`
    END,
    `file_mime` = CASE
        WHEN `file_mime` NOT LIKE '%application/x-zip,%' AND `file_mime` NOT LIKE '%application/x-zip %'
        THEN CONCAT(`file_mime`, ', application/x-zip, multipart/x-zip, application/s-compressed')
        ELSE `file_mime`
    END
WHERE `id` = 1;

-- ============================================================
-- Item 2: Content Views tracking table
-- ============================================================
CREATE TABLE IF NOT EXISTS `content_views` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `upload_content_id` INT(11) NOT NULL,
    `share_content_id` INT(11) DEFAULT NULL,
    `student_session_id` INT(11) NOT NULL,
    `viewed_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_content_student` (`upload_content_id`, `student_session_id`),
    KEY `idx_student_session` (`student_session_id`),
    KEY `idx_upload_content` (`upload_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================
-- Item 4: Exam Moderation Workflow
-- ============================================================

-- Add moderation_status column to onlineexam table (MySQL 5.5+ compatible)
DELIMITER //
DROP PROCEDURE IF EXISTS add_moderation_status_column//
CREATE PROCEDURE add_moderation_status_column()
BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'onlineexam'
        AND COLUMN_NAME = 'moderation_status'
    ) THEN
        ALTER TABLE `onlineexam`
            ADD COLUMN `moderation_status` ENUM('draft','pending_moderation','approved','rejected') NOT NULL DEFAULT 'draft';
    END IF;
END//
DELIMITER ;
CALL add_moderation_status_column();
DROP PROCEDURE IF EXISTS add_moderation_status_column;

-- Exam moderation comments table
CREATE TABLE IF NOT EXISTS `exam_moderation_comments` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `exam_id` INT(11) NOT NULL,
    `moderator_staff_id` INT(11) NOT NULL,
    `question_id` INT(11) DEFAULT NULL,
    `comment` TEXT NOT NULL,
    `action` ENUM('approve','reject','comment') NOT NULL DEFAULT 'comment',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_exam_id` (`exam_id`),
    KEY `idx_moderator` (`moderator_staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================
-- Item 5: Student Disability/Accessibility Accommodations
-- ============================================================
CREATE TABLE IF NOT EXISTS `student_accommodations` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `student_session_id` INT(11) NOT NULL,
    `accommodation_type` VARCHAR(100) NOT NULL DEFAULT 'extra_time',
    `extra_time_percent` INT(11) NOT NULL DEFAULT 25,
    `notes` TEXT DEFAULT NULL,
    `approved_by_staff_id` INT(11) DEFAULT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_student_session` (`student_session_id`),
    KEY `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================
-- Item 7: Microsoft Teams Integration
-- Requires: Zoom Live Class addon tables (conferences, zoom_settings, etc.)
-- These are created IF NOT EXISTS for fresh installs (e.g., Docker)
-- ============================================================

-- Ensure Zoom Live Class addon base tables exist (safe for existing installs)
CREATE TABLE IF NOT EXISTS `conferences` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `purpose` VARCHAR(20) NOT NULL DEFAULT 'class',
    `staff_id` INT(11) DEFAULT NULL,
    `created_id` INT(10) NOT NULL,
    `title` TEXT,
    `date` DATETIME DEFAULT NULL,
    `duration` INT(11) DEFAULT NULL,
    `password` VARCHAR(50) DEFAULT NULL,
    `subject` VARCHAR(50) DEFAULT NULL,
    `class_id` INT(10) DEFAULT NULL,
    `section_id` INT(10) DEFAULT NULL,
    `session_id` INT(10) NOT NULL,
    `host_video` INT(1) NOT NULL DEFAULT 1,
    `client_video` INT(1) NOT NULL DEFAULT 1,
    `description` TEXT,
    `timezone` VARCHAR(100) DEFAULT NULL,
    `return_response` TEXT,
    `api_type` VARCHAR(30) NOT NULL,
    `status` INT(1) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `conference_staff` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `conference_id` INT(11) NOT NULL,
    `staff_id` INT(11) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `conferences_history` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `conference_id` INT(11) NOT NULL,
    `staff_id` INT(11) DEFAULT NULL,
    `student_id` INT(11) DEFAULT NULL,
    `total_hit` INT(10) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `zoom_settings` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `zoom_api_key` VARCHAR(200) DEFAULT NULL,
    `zoom_api_secret` VARCHAR(200) DEFAULT NULL,
    `use_teacher_api` INT(1) DEFAULT 0,
    `use_zoom_app` INT(1) DEFAULT 1,
    `use_zoom_app_user` INT(1) DEFAULT 1,
    `parent_live_class` INT(11) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `conference_sections` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `conference_id` INT(11) DEFAULT NULL,
    `cls_section_id` INT(11) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Ensure zoom_settings has at least one row for Teams settings to update
INSERT INTO `zoom_settings` (`id`, `zoom_api_key`, `zoom_api_secret`)
SELECT 1, NULL, NULL FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `zoom_settings` LIMIT 1);

-- Add platform column to conferences
DELIMITER //
DROP PROCEDURE IF EXISTS add_conference_platform_column//
CREATE PROCEDURE add_conference_platform_column()
BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'conferences'
        AND COLUMN_NAME = 'platform'
    ) THEN
        ALTER TABLE `conferences`
            ADD COLUMN `platform` VARCHAR(20) NOT NULL DEFAULT 'zoom';
    END IF;
END//
DELIMITER ;
CALL add_conference_platform_column();
DROP PROCEDURE IF EXISTS add_conference_platform_column;

-- Add purpose column to conferences (used by Teams meetings)
DELIMITER //
DROP PROCEDURE IF EXISTS add_conference_purpose_column//
CREATE PROCEDURE add_conference_purpose_column()
BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'conferences'
        AND COLUMN_NAME = 'purpose'
    ) THEN
        ALTER TABLE `conferences`
            ADD COLUMN `purpose` VARCHAR(20) NOT NULL DEFAULT 'class';
    END IF;
END//
DELIMITER ;
CALL add_conference_purpose_column();
DROP PROCEDURE IF EXISTS add_conference_purpose_column;

-- Add Teams settings columns to zoom_settings
DELIMITER //
DROP PROCEDURE IF EXISTS add_teams_settings_columns//
CREATE PROCEDURE add_teams_settings_columns()
BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'zoom_settings'
        AND COLUMN_NAME = 'teams_tenant_id'
    ) THEN
        ALTER TABLE `zoom_settings`
            ADD COLUMN `teams_tenant_id` VARCHAR(255) DEFAULT NULL,
            ADD COLUMN `teams_client_id` VARCHAR(255) DEFAULT NULL,
            ADD COLUMN `teams_client_secret` VARCHAR(255) DEFAULT NULL,
            ADD COLUMN `teams_organizer_id` VARCHAR(255) DEFAULT NULL;
    END IF;
END//
DELIMITER ;
CALL add_teams_settings_columns();
DROP PROCEDURE IF EXISTS add_teams_settings_columns;

-- Teams Live Classes Permission Group & Sidebar Menus
INSERT INTO `permission_group` (`id`, `name`, `short_code`, `is_active`, `system`, `created_at`)
SELECT 501, 'Teams Live Classes', 'teams_live_classes', 1, 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `permission_group` WHERE `id` = 501);

INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT 5011, 501, 'Setting', 'setting', 1, 0, 1, 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `id` = 5011);

INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT 5012, 501, 'Live Classes', 'live_classes', 1, 1, 0, 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `id` = 5012);

INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT 5013, 501, 'Live Meeting', 'live_meeting', 1, 1, 0, 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `id` = 5013);

INSERT INTO `sidebar_menus` (`id`, `product_name`, `permission_group_id`, `icon`, `menu`, `activate_menu`, `lang_key`, `system_level`, `level`, `sidebar_display`, `access_permissions`, `is_active`, `created_at`)
SELECT 31, '', 501, 'fa fa-windows ftlayer', 'Teams Live Classes', 'teams_live_classes', 'teams_live_classes', 1, 7, 1, '(\'setting\', \'can_view\') || (\'live_classes\', \'can_view\') || (\'live_meeting\', \'can_view\')', 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `sidebar_menus` WHERE `id` = 31);

INSERT INTO `sidebar_sub_menus` (`id`, `sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `addon_permission`, `is_active`, `created_at`)
SELECT 180, 31, 'live_class', NULL, 'live_class', 'admin/conference/teams_classes', 1, '(\'live_classes\', \'can_view\')', NULL, 'conference', 'teams_classes', '', 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `id` = 180);

INSERT INTO `sidebar_sub_menus` (`id`, `sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `addon_permission`, `is_active`, `created_at`)
SELECT 228, 31, 'live_meeting', NULL, 'live_meeting', 'admin/conference/teams_meeting', 2, '(\'live_meeting\', \'can_view\')', NULL, 'conference', 'teams_meeting', '', 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `id` = 228);

INSERT INTO `sidebar_sub_menus` (`id`, `sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `addon_permission`, `is_active`, `created_at`)
SELECT 229, 31, 'setting', NULL, 'setting', 'admin/conference/teams_settings', 3, '(\'setting\', \'can_view\')', NULL, 'conference', 'teams_settings', '', 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `id` = 229);

-- Role permissions for Teams (Super Admin, Admin, Teacher roles)
INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT NULL, 7, 5011, 1, 0, 1, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 7 AND `perm_cat_id` = 5011);

INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT NULL, 7, 5012, 1, 1, 0, 1, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 7 AND `perm_cat_id` = 5012);

INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT NULL, 7, 5013, 1, 1, 0, 1, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 7 AND `perm_cat_id` = 5013);

INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT NULL, 1, 5011, 1, 0, 1, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 1 AND `perm_cat_id` = 5011);

INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT NULL, 1, 5012, 1, 1, 0, 1, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 1 AND `perm_cat_id` = 5012);

INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT NULL, 1, 5013, 1, 1, 0, 1, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 1 AND `perm_cat_id` = 5013);

-- Conference-Cohort junction table for TVET integration
CREATE TABLE IF NOT EXISTS `conference_cohorts` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `conference_id` INT(11) NOT NULL,
    `cohort_id` INT(11) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_conference_id` (`conference_id`),
    KEY `idx_cohort_id` (`cohort_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Add cohort/module tracking to conferences for TVET
DELIMITER //
DROP PROCEDURE IF EXISTS add_conference_tvet_columns//
CREATE PROCEDURE add_conference_tvet_columns()
BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'conferences'
        AND COLUMN_NAME = 'tvet_module_id'
    ) THEN
        ALTER TABLE `conferences`
            ADD COLUMN `tvet_module_id` INT(11) DEFAULT NULL;
    END IF;
END//
DELIMITER ;
CALL add_conference_tvet_columns();
DROP PROCEDURE IF EXISTS add_conference_tvet_columns;

SET FOREIGN_KEY_CHECKS = 1;
