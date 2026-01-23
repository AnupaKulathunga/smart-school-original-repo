-- ============================================================
-- TVET Extension Layer - Database Migration
-- Smart School v7.1.0 → TVET Customization
-- Run this SQL to add TVET tables to existing Smart School DB
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Programme (e.g., NATED, NC(V), Occupational)
CREATE TABLE IF NOT EXISTS `tvet_programme` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(50) NOT NULL,
    `name` VARCHAR(200) NOT NULL,
    `description` TEXT NULL DEFAULT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_programme_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 2. Qualification (e.g., Business Management, Engineering Studies)
CREATE TABLE IF NOT EXISTS `tvet_qualification` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `programme_id` INT(11) UNSIGNED NOT NULL,
    `code` VARCHAR(50) NOT NULL,
    `name` VARCHAR(200) NOT NULL,
    `description` TEXT NULL DEFAULT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_qualification_programme` (`programme_id`),
    CONSTRAINT `fk_qualification_programme` FOREIGN KEY (`programme_id`) REFERENCES `tvet_programme` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 3. Level (e.g., N4, N5, N6 or NCV Level 2, 3, 4)
CREATE TABLE IF NOT EXISTS `tvet_level` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `qualification_id` INT(11) UNSIGNED NOT NULL,
    `code` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `sequence` INT(3) NOT NULL DEFAULT 1,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_level_qualification` (`qualification_id`),
    CONSTRAINT `fk_level_qualification` FOREIGN KEY (`qualification_id`) REFERENCES `tvet_qualification` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 4. Level Module Mapping (Maps Smart School Subjects to TVET Modules)
CREATE TABLE IF NOT EXISTS `tvet_level_module` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `level_id` INT(11) UNSIGNED NOT NULL,
    `subject_id` INT(11) NOT NULL COMMENT 'FK to subjects table',
    `module_code` VARCHAR(50) NOT NULL,
    `module_name` VARCHAR(200) NOT NULL,
    `credits` INT(3) NOT NULL DEFAULT 0,
    `semester` ENUM('1','2','Year') NOT NULL DEFAULT 'Year',
    `is_core` TINYINT(1) NOT NULL DEFAULT 1,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_module_level` (`level_id`),
    KEY `idx_module_subject` (`subject_id`),
    UNIQUE KEY `uk_level_subject` (`level_id`, `subject_id`),
    CONSTRAINT `fk_module_level` FOREIGN KEY (`level_id`) REFERENCES `tvet_level` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 5. Cohort (e.g., BM N4 Group A, Evening, Distance)
CREATE TABLE IF NOT EXISTS `tvet_cohort` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `level_id` INT(11) UNSIGNED NOT NULL,
    `code` VARCHAR(50) NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `intake_year` YEAR NOT NULL,
    `delivery_mode` ENUM('Full-time','Part-time','Evening','Weekend','Distance') NOT NULL DEFAULT 'Full-time',
    `start_date` DATE NOT NULL,
    `end_date` DATE NULL DEFAULT NULL,
    `max_students` INT(3) NOT NULL DEFAULT 40,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_cohort_level` (`level_id`),
    CONSTRAINT `fk_cohort_level` FOREIGN KEY (`level_id`) REFERENCES `tvet_level` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 6. Student Enrolment
CREATE TABLE IF NOT EXISTS `tvet_student_enrolment` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `student_id` INT(11) NOT NULL COMMENT 'FK to students table',
    `level_id` INT(11) UNSIGNED NOT NULL,
    `cohort_id` INT(11) UNSIGNED NULL DEFAULT NULL,
    `enrolment_date` DATE NOT NULL,
    `status` ENUM('Active','Completed','Dropped','Suspended','Transferred') NOT NULL DEFAULT 'Active',
    `completion_date` DATE NULL DEFAULT NULL,
    `student_number` VARCHAR(50) NULL DEFAULT NULL,
    `notes` TEXT NULL DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_enrolment_student` (`student_id`),
    KEY `idx_enrolment_level` (`level_id`),
    KEY `idx_enrolment_cohort` (`cohort_id`),
    UNIQUE KEY `uk_student_level` (`student_id`, `level_id`),
    CONSTRAINT `fk_enrolment_level` FOREIGN KEY (`level_id`) REFERENCES `tvet_level` (`id`),
    CONSTRAINT `fk_enrolment_cohort` FOREIGN KEY (`cohort_id`) REFERENCES `tvet_cohort` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 7. Lecturer Allocation
CREATE TABLE IF NOT EXISTS `tvet_lecturer_allocation` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `staff_id` INT(11) NOT NULL COMMENT 'FK to staff table',
    `cohort_id` INT(11) UNSIGNED NOT NULL,
    `level_module_id` INT(11) UNSIGNED NOT NULL,
    `academic_year` YEAR NOT NULL,
    `semester` ENUM('1','2','Year') NOT NULL DEFAULT 'Year',
    `is_primary` TINYINT(1) NOT NULL DEFAULT 1,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_allocation_staff` (`staff_id`),
    KEY `idx_allocation_cohort` (`cohort_id`),
    KEY `idx_allocation_module` (`level_module_id`),
    CONSTRAINT `fk_allocation_cohort` FOREIGN KEY (`cohort_id`) REFERENCES `tvet_cohort` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_allocation_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 8. Assessment
CREATE TABLE IF NOT EXISTS `tvet_assessment` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `level_module_id` INT(11) UNSIGNED NOT NULL,
    `cohort_id` INT(11) UNSIGNED NOT NULL,
    `assessment_type` ENUM('Assignment','Test','Practical','Exam','POE','Project') NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `description` TEXT NULL DEFAULT NULL,
    `total_marks` INT(5) NOT NULL,
    `weight_percentage` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    `due_date` DATE NULL DEFAULT NULL,
    `academic_year` YEAR NOT NULL,
    `semester` ENUM('1','2','Year') NOT NULL DEFAULT 'Year',
    `created_by` INT(11) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_assessment_module` (`level_module_id`),
    KEY `idx_assessment_cohort` (`cohort_id`),
    CONSTRAINT `fk_assessment_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`),
    CONSTRAINT `fk_assessment_cohort` FOREIGN KEY (`cohort_id`) REFERENCES `tvet_cohort` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 9. Assessment Schedule
CREATE TABLE IF NOT EXISTS `tvet_assessment_schedule` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `assessment_id` INT(11) UNSIGNED NOT NULL,
    `scheduled_date` DATE NOT NULL,
    `start_time` TIME NOT NULL,
    `duration_minutes` INT(4) NOT NULL,
    `venue` VARCHAR(200) NULL DEFAULT NULL,
    `invigilator_id` INT(11) NULL DEFAULT NULL COMMENT 'FK to staff table',
    `instructions` TEXT NULL DEFAULT NULL,
    `status` ENUM('Scheduled','In Progress','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_schedule_assessment` (`assessment_id`),
    CONSTRAINT `fk_schedule_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `tvet_assessment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 10. Add institution_type to sch_settings
ALTER TABLE `sch_settings` ADD COLUMN `institution_type` ENUM('SCHOOL','TVET') NOT NULL DEFAULT 'SCHOOL' AFTER `session_id`;

-- 11. Add TVET timetable table
CREATE TABLE IF NOT EXISTS `tvet_timetable` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `cohort_id` INT(11) UNSIGNED NOT NULL,
    `level_module_id` INT(11) UNSIGNED NOT NULL,
    `staff_id` INT(11) NOT NULL COMMENT 'Lecturer',
    `day_of_week` ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
    `start_time` TIME NOT NULL,
    `end_time` TIME NOT NULL,
    `venue` VARCHAR(200) NULL DEFAULT NULL,
    `academic_year` YEAR NOT NULL,
    `semester` ENUM('1','2','Year') NOT NULL DEFAULT 'Year',
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_timetable_cohort` (`cohort_id`),
    KEY `idx_timetable_module` (`level_module_id`),
    KEY `idx_timetable_staff` (`staff_id`),
    CONSTRAINT `fk_timetable_cohort` FOREIGN KEY (`cohort_id`) REFERENCES `tvet_cohort` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_timetable_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 12. Assessment Marks table
CREATE TABLE IF NOT EXISTS `tvet_assessment_marks` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `assessment_id` INT(11) UNSIGNED NOT NULL,
    `student_id` INT(11) NOT NULL,
    `marks_obtained` DECIMAL(5,2) NULL DEFAULT NULL,
    `feedback` TEXT NULL DEFAULT NULL,
    `graded_by` INT(11) NULL DEFAULT NULL,
    `graded_at` TIMESTAMP NULL DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_marks_assessment` (`assessment_id`),
    KEY `idx_marks_student` (`student_id`),
    UNIQUE KEY `uk_assessment_student` (`assessment_id`, `student_id`),
    CONSTRAINT `fk_marks_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `tvet_assessment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- SEED TEST DATA
-- ============================================================

-- Programme: NATED
INSERT INTO `tvet_programme` (`code`, `name`, `description`, `active`) VALUES
('NATED', 'National Accredited Technical Education Diploma', 'Technical and vocational qualifications', 1),
('NCV', 'National Certificate Vocational', 'Vocational training programmes', 1);

-- Qualification: Business Management under NATED
INSERT INTO `tvet_qualification` (`programme_id`, `code`, `name`, `description`, `active`) VALUES
((SELECT id FROM tvet_programme WHERE code='NATED'), 'BM', 'Business Management', 'Business Management qualification', 1),
((SELECT id FROM tvet_programme WHERE code='NATED'), 'ES', 'Engineering Studies', 'Engineering Studies qualification', 1),
((SELECT id FROM tvet_programme WHERE code='NCV'), 'IT', 'Information Technology', 'Information Technology and Computer Science', 1);

-- Levels: N4, N5, N6 for Business Management
INSERT INTO `tvet_level` (`qualification_id`, `code`, `name`, `sequence`, `active`) VALUES
((SELECT id FROM tvet_qualification WHERE code='BM'), 'N4', 'N4', 1, 1),
((SELECT id FROM tvet_qualification WHERE code='BM'), 'N5', 'N5', 2, 1),
((SELECT id FROM tvet_qualification WHERE code='BM'), 'N6', 'N6', 3, 1);

-- Cohort: BM N4 Group A
INSERT INTO `tvet_cohort` (`level_id`, `code`, `name`, `intake_year`, `delivery_mode`, `start_date`, `end_date`, `max_students`, `active`) VALUES
((SELECT id FROM tvet_level WHERE code='N4' LIMIT 1), 'BM-N4-A-2026', 'Business Management N4 Group A', 2026, 'Full-time', '2026-02-01', '2026-11-30', 40, 1),
((SELECT id FROM tvet_level WHERE code='N4' LIMIT 1), 'BM-N4-B-2026', 'Business Management N4 Group B', 2026, 'Evening', '2026-02-01', '2026-11-30', 35, 1);

-- ============================================================
-- PERMISSION GROUP & CATEGORIES
-- ============================================================

INSERT INTO `permission_group` (`id`, `name`, `short_code`, `is_active`, `system`, `created_at`) VALUES
(32, 'TVET Management', 'tvet_management', 1, 0, NOW());

INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`) VALUES
(283, 32, 'TVET Programme', 'tvet_programme', 1, 1, 1, 1, NOW()),
(284, 32, 'TVET Qualification', 'tvet_qualification', 1, 1, 1, 1, NOW()),
(285, 32, 'TVET Level', 'tvet_level', 1, 1, 1, 1, NOW()),
(286, 32, 'TVET Cohort', 'tvet_cohort', 1, 1, 1, 1, NOW()),
(287, 32, 'TVET Module Mapping', 'tvet_module_mapping', 1, 1, 0, 1, NOW()),
(288, 32, 'TVET Lecturer Allocation', 'tvet_lecturer_allocation', 1, 1, 0, 1, NOW()),
(289, 32, 'TVET Reports', 'tvet_reports', 1, 0, 0, 0, NOW());

-- ============================================================
-- SIDEBAR MENU
-- ============================================================

INSERT INTO `sidebar_menus` (`id`, `product_name`, `permission_group_id`, `icon`, `menu`, `activate_menu`, `lang_key`, `system_level`, `level`, `sidebar_display`, `access_permissions`, `is_active`, `created_at`) VALUES
(38, '', 32, 'fa fa-graduation-cap ftlayer', 'TVET Management', 'tvet_management', 'tvet_management', 105, 12, 1, '(\'tvet_programme\', \'can_view\') || (\'tvet_qualification\', \'can_view\') || (\'tvet_level\', \'can_view\') || (\'tvet_cohort\', \'can_view\') || (\'tvet_module_mapping\', \'can_view\') || (\'tvet_lecturer_allocation\', \'can_view\')', 1, NOW());

INSERT INTO `sidebar_sub_menus` (`id`, `sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `addon_permission`, `is_active`, `created_at`) VALUES
(220, 38, 'tvet_dashboard', NULL, 'tvet_dashboard', 'admin/tvet', 1, '(\'tvet_programme\', \'can_view\')', NULL, 'tvet', 'index', '', 1, NOW()),
(221, 38, 'tvet_programmes', NULL, 'tvet_programmes', 'admin/tvet/programme', 2, '(\'tvet_programme\', \'can_view\')', NULL, 'tvet', 'programme,programme_add,programme_edit', '', 1, NOW()),
(222, 38, 'tvet_qualifications', NULL, 'tvet_qualifications', 'admin/tvet/qualification', 3, '(\'tvet_qualification\', \'can_view\')', NULL, 'tvet', 'qualification,qualification_add,qualification_edit', '', 1, NOW()),
(223, 38, 'tvet_levels', NULL, 'tvet_levels', 'admin/tvet/level', 4, '(\'tvet_level\', \'can_view\')', NULL, 'tvet', 'level,level_add,level_edit', '', 1, NOW()),
(224, 38, 'tvet_cohorts', NULL, 'tvet_cohorts', 'admin/tvet/cohort', 5, '(\'tvet_cohort\', \'can_view\')', NULL, 'tvet', 'cohort,cohort_add,cohort_edit,cohort_roster', '', 1, NOW()),
(225, 38, 'tvet_module_mapping', NULL, 'tvet_module_mapping', 'admin/tvet/module_mapping', 6, '(\'tvet_module_mapping\', \'can_view\')', NULL, 'tvet', 'module_mapping', '', 1, NOW()),
(226, 38, 'tvet_lecturer_allocation', NULL, 'tvet_lecturer_allocation', 'admin/tvet/lecturer_allocation', 7, '(\'tvet_lecturer_allocation\', \'can_view\')', NULL, 'tvet', 'lecturer_allocation', '', 1, NOW());
