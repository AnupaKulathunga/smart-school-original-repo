-- ============================================================================
-- Academic Subject-Centric Model Migration
-- Transforms Smart School to South African TVET College Model
-- CLASS = Subject + Level + Cohort + Year + Lecturer
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. PROGRAMME TABLE (Top-level: NATED, NCV)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_programme` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(20) NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `description` TEXT NULL,
  `qualification_type` ENUM('NATED', 'NCV', 'Occupational', 'Other') DEFAULT 'NATED',
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_programme_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 2. SUBJECT TABLE (Subjects under programmes: Mathematics, Engineering Science)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_subject` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `programme_id` INT(11) NOT NULL,
  `code` VARCHAR(20) NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `description` TEXT NULL,
  `credits` INT(3) DEFAULT 0,
  `notional_hours` INT(5) DEFAULT 0 COMMENT 'Total learning hours',
  `is_core` TINYINT(1) DEFAULT 1 COMMENT '1=Core, 0=Elective',
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_subject_code_programme` (`code`, `programme_id`),
  KEY `idx_programme` (`programme_id`),
  CONSTRAINT `fk_subject_programme` FOREIGN KEY (`programme_id`)
    REFERENCES `academic_programme`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 3. LEVEL TABLE (N1-N6, NCV L2-L4 - Independent levels)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_level` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(20) NOT NULL COMMENT 'e.g., N1, N2, NCV2',
  `name` VARCHAR(100) NOT NULL COMMENT 'e.g., NATED Level 1',
  `level_type` ENUM('NATED', 'NCV', 'Other') DEFAULT 'NATED',
  `nqf_level` INT(2) NULL COMMENT 'NQF Level 2-6',
  `sequence` INT(2) DEFAULT 1 COMMENT 'For ordering',
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_level_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 4. SUBJECT-LEVEL MAPPING (Which subjects at which levels)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_subject_level` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `subject_id` INT(11) NOT NULL,
  `level_id` INT(11) NOT NULL,
  `syllabus_code` VARCHAR(50) NULL COMMENT 'DHET syllabus reference',
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_subject_level` (`subject_id`, `level_id`),
  KEY `idx_subject` (`subject_id`),
  KEY `idx_level` (`level_id`),
  CONSTRAINT `fk_sl_subject` FOREIGN KEY (`subject_id`)
    REFERENCES `academic_subject`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sl_level` FOREIGN KEY (`level_id`)
    REFERENCES `academic_level`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 5. CLASS TABLE - THE CENTRAL ACADEMIC UNIT
-- CLASS = Subject + Level + Cohort + Year + Lecturer
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_class` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `class_code` VARCHAR(50) NOT NULL COMMENT 'e.g., MATH-N4-A-2026',
  `subject_level_id` INT(11) NOT NULL,
  `cohort_name` VARCHAR(50) NOT NULL COMMENT 'e.g., A, B, C, D or Group 1',
  `academic_year` INT(4) NOT NULL,
  `session_id` INT(11) NOT NULL,
  `intake_period` VARCHAR(20) NULL COMMENT 'Jan, Jul, etc.',
  `delivery_mode` ENUM('Full-time', 'Part-time', 'Evening', 'Weekend', 'Distance') DEFAULT 'Full-time',
  `primary_lecturer_id` INT(11) NULL,
  `venue` VARCHAR(100) NULL COMMENT 'Room/Lab assignment',
  `max_students` INT(3) DEFAULT 50,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `status` ENUM('Scheduled', 'Active', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_code_session` (`class_code`, `session_id`),
  KEY `idx_subject_level` (`subject_level_id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_lecturer` (`primary_lecturer_id`),
  CONSTRAINT `fk_class_subject_level` FOREIGN KEY (`subject_level_id`)
    REFERENCES `academic_subject_level`(`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_class_session` FOREIGN KEY (`session_id`)
    REFERENCES `sessions`(`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_class_lecturer` FOREIGN KEY (`primary_lecturer_id`)
    REFERENCES `staff`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 6. CLASS ENROLMENT (Students enrolled in classes)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_class_enrolment` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `student_id` INT(11) NOT NULL,
  `class_id` INT(11) NOT NULL,
  `enrolment_date` DATE NOT NULL,
  `status` ENUM('Active', 'Completed', 'Dropped', 'Suspended', 'Transferred') DEFAULT 'Active',
  `completion_date` DATE NULL,
  `final_mark` DECIMAL(5,2) NULL,
  `final_result` ENUM('Pass', 'Fail', 'Incomplete', 'Pending') DEFAULT 'Pending',
  `notes` TEXT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_class` (`student_id`, `class_id`),
  KEY `idx_student` (`student_id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_enrol_student` FOREIGN KEY (`student_id`)
    REFERENCES `students`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_enrol_class` FOREIGN KEY (`class_id`)
    REFERENCES `academic_class`(`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 7. CLASS LECTURER (Additional lecturers per class)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_class_lecturer` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `class_id` INT(11) NOT NULL,
  `staff_id` INT(11) NOT NULL,
  `role` ENUM('Primary', 'Assistant', 'Tutor', 'Assessor', 'Moderator') DEFAULT 'Assistant',
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_lecturer` (`class_id`, `staff_id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_staff` (`staff_id`),
  CONSTRAINT `fk_cl_class` FOREIGN KEY (`class_id`)
    REFERENCES `academic_class`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cl_staff` FOREIGN KEY (`staff_id`)
    REFERENCES `staff`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 8. ATTENDANCE (Daily attendance per class)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_attendance` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `class_id` INT(11) NOT NULL,
  `enrolment_id` INT(11) NOT NULL,
  `date` DATE NOT NULL,
  `status` ENUM('Present', 'Absent', 'Late', 'Excused') NOT NULL,
  `notes` VARCHAR(255) NULL,
  `marked_by` INT(11) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_attendance` (`enrolment_id`, `date`),
  KEY `idx_class` (`class_id`),
  KEY `idx_enrolment` (`enrolment_id`),
  KEY `idx_date` (`date`),
  CONSTRAINT `fk_att_class` FOREIGN KEY (`class_id`)
    REFERENCES `academic_class`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_att_enrol` FOREIGN KEY (`enrolment_id`)
    REFERENCES `academic_class_enrolment`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 9. TIMETABLE (Class schedule)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_timetable` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `class_id` INT(11) NOT NULL,
  `day_of_week` ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  `venue` VARCHAR(100) NULL,
  `lecturer_id` INT(11) NULL COMMENT 'Override lecturer for this slot',
  `is_active` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_day` (`day_of_week`),
  CONSTRAINT `fk_tt_class` FOREIGN KEY (`class_id`)
    REFERENCES `academic_class`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 10. ASSESSMENT (Assessments belong to CLASS)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_assessment` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `class_id` INT(11) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `assessment_type` ENUM('Test', 'ICASS', 'Practical', 'Assignment', 'Project', 'POE', 'Exam') NOT NULL,
  `icass_component` ENUM('Task 1', 'Task 2', 'Task 3', 'Task 4', 'Task 5', 'Task 6', 'Task 7', 'Final') NULL,
  `total_marks` DECIMAL(6,2) NOT NULL DEFAULT 100,
  `weight_percentage` DECIMAL(5,2) NULL COMMENT 'Weight in final mark',
  `due_date` DATETIME NULL,
  `instructions` TEXT NULL,
  `attachments` TEXT NULL,
  `moderation_status` ENUM('Draft', 'Pending Moderation', 'Approved', 'Rejected') DEFAULT 'Draft',
  `moderator_id` INT(11) NULL,
  `moderation_date` DATETIME NULL,
  `moderation_comments` TEXT NULL,
  `is_published` TINYINT(1) DEFAULT 0,
  `created_by` INT(11) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_type` (`assessment_type`),
  KEY `idx_status` (`moderation_status`),
  CONSTRAINT `fk_assess_class` FOREIGN KEY (`class_id`)
    REFERENCES `academic_class`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_assess_moderator` FOREIGN KEY (`moderator_id`)
    REFERENCES `staff`(`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_assess_creator` FOREIGN KEY (`created_by`)
    REFERENCES `staff`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 11. ASSESSMENT MARKS (Student marks for assessments)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_assessment_marks` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `assessment_id` INT(11) NOT NULL,
  `enrolment_id` INT(11) NOT NULL,
  `marks_obtained` DECIMAL(6,2) NULL,
  `percentage` DECIMAL(5,2) NULL,
  `grade` VARCHAR(10) NULL,
  `feedback` TEXT NULL,
  `submission_date` DATETIME NULL,
  `submission_file` VARCHAR(255) NULL,
  `marked_by` INT(11) NULL,
  `marked_at` DATETIME NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_assess_enrol` (`assessment_id`, `enrolment_id`),
  KEY `idx_assessment` (`assessment_id`),
  KEY `idx_enrolment` (`enrolment_id`),
  CONSTRAINT `fk_marks_assessment` FOREIGN KEY (`assessment_id`)
    REFERENCES `academic_assessment`(`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_marks_enrolment` FOREIGN KEY (`enrolment_id`)
    REFERENCES `academic_class_enrolment`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 12. MODERATION LOG (Audit trail for moderation)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_moderation_log` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `assessment_id` INT(11) NOT NULL,
  `moderator_id` INT(11) NOT NULL,
  `action` ENUM('Submitted', 'Approved', 'Rejected', 'Comment', 'Revised') NOT NULL,
  `comments` TEXT NULL,
  `previous_status` VARCHAR(50) NULL,
  `new_status` VARCHAR(50) NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_assessment` (`assessment_id`),
  KEY `idx_moderator` (`moderator_id`),
  CONSTRAINT `fk_mod_assessment` FOREIGN KEY (`assessment_id`)
    REFERENCES `academic_assessment`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 13. POE ITEM (Portfolio of Evidence)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_poe_item` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `enrolment_id` INT(11) NOT NULL,
  `item_name` VARCHAR(200) NOT NULL,
  `item_type` ENUM('Assignment', 'Project', 'Practical', 'Test', 'Reflection', 'Other') NOT NULL,
  `description` TEXT NULL,
  `file_path` VARCHAR(500) NULL,
  `submitted_date` DATE NOT NULL,
  `status` ENUM('Pending', 'Submitted', 'Accepted', 'Rejected') DEFAULT 'Pending',
  `assessor_id` INT(11) NULL,
  `assessor_comments` TEXT NULL,
  `assessed_at` DATETIME NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_enrolment` (`enrolment_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_poe_enrolment` FOREIGN KEY (`enrolment_id`)
    REFERENCES `academic_class_enrolment`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 14. ICASS CONFIG (ICASS component configuration)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `academic_icass_config` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `class_id` INT(11) NOT NULL,
  `component` ENUM('Task 1', 'Task 2', 'Task 3', 'Task 4', 'Task 5', 'Task 6', 'Task 7', 'Final') NOT NULL,
  `component_type` ENUM('Test', 'Assignment', 'Project', 'Practical', 'Exam', 'Other') NOT NULL,
  `weight_percentage` DECIMAL(5,2) NOT NULL,
  `pass_percentage` DECIMAL(5,2) DEFAULT 40.00,
  `description` VARCHAR(255) NULL,
  `is_compulsory` TINYINT(1) DEFAULT 1,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_icass_config` (`class_id`, `component`),
  KEY `idx_class` (`class_id`),
  CONSTRAINT `fk_icass_class` FOREIGN KEY (`class_id`)
    REFERENCES `academic_class`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 15. PERMISSIONS
-- ============================================================================

-- Get System Admin permission group ID
SET @perm_group_id = (SELECT id FROM permission_group WHERE name = 'System Admin' LIMIT 1);
SET @perm_group_id = IFNULL(@perm_group_id, 1);

-- Academic Dashboard
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Academic Dashboard', 'academic_dashboard', 1, 0, 0, 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_dashboard');

-- Programmes
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Academic Programmes', 'academic_programmes', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_programmes');

-- Subjects
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Academic Subjects', 'academic_subjects', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_subjects');

-- Levels
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Academic Levels', 'academic_levels', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_levels');

-- Classes
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Academic Classes', 'academic_classes', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_classes');

-- Student Enrolment
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Student Enrolment', 'academic_enrolment', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_enrolment');

-- Class Attendance
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Class Attendance', 'academic_attendance', 1, 1, 1, 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_attendance');

-- Assessments
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Academic Assessments', 'academic_assessments', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_assessments');

-- Moderation
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Assessment Moderation', 'academic_moderation', 1, 1, 1, 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_moderation');

-- ICASS
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'ICASS Management', 'academic_icass', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_icass');

-- POE
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'POE Management', 'academic_poe', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_poe');

-- Reports
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Academic Reports', 'academic_reports', 1, 0, 0, 0, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'academic_reports');

-- ============================================================================
-- 16. SIDEBAR MENU
-- ============================================================================

-- Insert main Academic Management menu
INSERT INTO `sidebar_menus` (`menu`, `key`, `lang_key`, `url`, `icon`, `is_active`, `display_order`, `level`, `system_level`, `sidebar_display`)
SELECT 'Academic Management', NULL, 'academic_management', '#', 'fa fa-graduation-cap', 1, 5, 'admin', 0, 1
WHERE NOT EXISTS (SELECT 1 FROM `sidebar_menus` WHERE `lang_key` = 'academic_management');

-- Get Academic Management menu ID
SET @academic_menu_id = (SELECT id FROM `sidebar_menus` WHERE `lang_key` = 'academic_management' LIMIT 1);

-- Insert submenus
INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Dashboard', NULL, 'dashboard', 'admin/academic', 1, '(\'academic_dashboard\', \'can_view\')', NULL, 'academic', 'index', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic' AND `sidebar_menu_id` = @academic_menu_id);

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Programmes', NULL, 'programmes', 'admin/academic/programmes', 2, '(\'academic_programmes\', \'can_view\')', NULL, 'academic', 'programmes,programme_add,programme_edit', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/programmes');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Subjects', NULL, 'subjects', 'admin/academic/subjects', 3, '(\'academic_subjects\', \'can_view\')', NULL, 'academic', 'subjects,subject_add,subject_edit', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/subjects');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Levels', NULL, 'levels', 'admin/academic/levels', 4, '(\'academic_levels\', \'can_view\')', NULL, 'academic', 'levels,level_add,level_edit', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/levels');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Subject-Level Mapping', NULL, 'subject_level_mapping', 'admin/academic/subject_levels', 5, '(\'academic_subjects\', \'can_view\')', NULL, 'academic', 'subject_levels,subject_level_add', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/subject_levels');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Classes', NULL, 'classes', 'admin/academic/classes', 6, '(\'academic_classes\', \'can_view\')', NULL, 'academic', 'classes,class_add,class_edit,class_roster', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/classes');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Student Enrolment', NULL, 'student_enrolment', 'admin/academic/enrolment', 7, '(\'academic_enrolment\', \'can_view\')', NULL, 'academic', 'enrolment,enrol_student,bulk_enrolment', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/enrolment');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Attendance', NULL, 'attendance', 'admin/academic/attendance', 8, '(\'academic_attendance\', \'can_view\')', NULL, 'academic', 'attendance,mark_attendance', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/attendance');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Timetable', NULL, 'timetable', 'admin/academic/timetable', 9, '(\'academic_classes\', \'can_view\')', NULL, 'academic', 'timetable', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/timetable');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Assessments', NULL, 'assessments', 'admin/academic/assessments', 10, '(\'academic_assessments\', \'can_view\')', NULL, 'academic', 'assessments,assessment_add,assessment_edit,marks_entry', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/assessments');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Moderation', NULL, 'moderation', 'admin/academic/moderation', 11, '(\'academic_moderation\', \'can_view\')', NULL, 'academic', 'moderation', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/moderation');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'ICASS', NULL, 'icass', 'admin/academic/icass', 12, '(\'academic_icass\', \'can_view\')', NULL, 'academic', 'icass,icass_config', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/icass');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'POE', NULL, 'poe', 'admin/academic/poe', 13, '(\'academic_poe\', \'can_view\')', NULL, 'academic', 'poe', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/poe');

INSERT INTO `sidebar_sub_menus` (`sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `is_active`, `created_at`)
SELECT @academic_menu_id, 'Reports', NULL, 'reports', 'admin/academic/reports', 14, '(\'academic_reports\', \'can_view\')', NULL, 'academic', 'reports', 1, NOW()
WHERE @academic_menu_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/academic/reports');

-- ============================================================================
-- 17. GRANT PERMISSIONS TO ADMIN ROLES
-- ============================================================================

-- Grant permissions to Admin role (id=1)
INSERT INTO roles_permissions (role_id, perm_cat_id, can_view, can_add, can_edit, can_delete)
SELECT 1, pc.id, pc.enable_view, pc.enable_add, pc.enable_edit, pc.enable_delete
FROM permission_category pc
WHERE pc.short_code LIKE 'academic_%'
AND NOT EXISTS (SELECT 1 FROM roles_permissions rp WHERE rp.role_id = 1 AND rp.perm_cat_id = pc.id);

-- Grant permissions to Super Admin role (id=7)
INSERT INTO roles_permissions (role_id, perm_cat_id, can_view, can_add, can_edit, can_delete)
SELECT 7, pc.id, pc.enable_view, pc.enable_add, pc.enable_edit, pc.enable_delete
FROM permission_category pc
WHERE pc.short_code LIKE 'academic_%'
AND NOT EXISTS (SELECT 1 FROM roles_permissions rp WHERE rp.role_id = 7 AND rp.perm_cat_id = pc.id);

-- ============================================================================
-- 18. DEACTIVATE OLD MENUS
-- ============================================================================

-- Deactivate old Academics menu (traditional high school)
UPDATE `sidebar_menus` SET `is_active` = 0 WHERE `lang_key` = 'academics' AND `lang_key` != 'academic_management';

-- Deactivate old TVET Management menu (replaced by Academic Management)
UPDATE `sidebar_menus` SET `is_active` = 0 WHERE `lang_key` = 'tvet_management';

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- END OF MIGRATION
-- ============================================================================
