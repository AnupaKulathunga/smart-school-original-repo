-- ============================================================================
-- TVET Unified Database Architecture - Migration 1: Core Structure
-- Replaces prefixed tables (tvet_*, academic_*) with clean unified structure
-- CLASS is the CENTRAL UNIT: Subject + Level + Cohort + Year + Lecturer
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. PROGRAMME TABLE
-- Top-level: NATED, NCV, Occupational
-- ============================================================================

CREATE TABLE IF NOT EXISTS `programme` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(20) NOT NULL COMMENT 'e.g., NATED, NCV',
  `name` VARCHAR(200) NOT NULL,
  `description` TEXT NULL,
  `programme_type` ENUM('NATED', 'NCV', 'Occupational', 'Other') NOT NULL DEFAULT 'NATED',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_programme_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ============================================================================
-- 2. QUALIFICATION TABLE
-- Groups under programme: Business Management, Engineering Studies
-- ============================================================================

CREATE TABLE IF NOT EXISTS `qualification` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `programme_id` INT(11) NOT NULL,
  `code` VARCHAR(50) NOT NULL COMMENT 'e.g., BM, ES, IT',
  `name` VARCHAR(200) NOT NULL COMMENT 'e.g., Business Management',
  `description` TEXT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_qualification_code_programme` (`code`, `programme_id`),
  KEY `idx_programme` (`programme_id`),
  CONSTRAINT `fk_qualification_programme` FOREIGN KEY (`programme_id`)
    REFERENCES `programme`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ============================================================================
-- 3. LEVEL TABLE
-- N1-N6, NCV L2-L4 - Independent from qualification
-- ============================================================================

CREATE TABLE IF NOT EXISTS `level` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(20) NOT NULL COMMENT 'e.g., N1, N2, N3, N4, N5, N6, NCV2, NCV3, NCV4',
  `name` VARCHAR(100) NOT NULL COMMENT 'e.g., N4 (NQF Level 5)',
  `level_type` ENUM('NATED', 'NCV', 'Other') NOT NULL DEFAULT 'NATED',
  `nqf_level` INT(2) NULL COMMENT 'NQF Level 2-6',
  `sequence` INT(2) NOT NULL DEFAULT 1 COMMENT 'For ordering',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_level_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ============================================================================
-- 4. SUBJECT TABLE (Repurposed)
-- Subjects under programmes: Mathematics, Engineering Science
-- Note: We extend the existing subjects table with additional TVET fields
-- ============================================================================

-- First, add TVET-specific columns to the existing subjects table
ALTER TABLE `subjects`
  ADD COLUMN `programme_id` INT(11) NULL AFTER `id`,
  ADD COLUMN `qualification_id` INT(11) NULL AFTER `programme_id`,
  ADD COLUMN `credits` INT(3) NOT NULL DEFAULT 0 AFTER `code`,
  ADD COLUMN `notional_hours` INT(5) NOT NULL DEFAULT 0 COMMENT 'Total learning hours' AFTER `credits`,
  ADD COLUMN `is_core` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=Core, 0=Elective' AFTER `notional_hours`,
  ADD COLUMN `updated_at` TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP AFTER `created_at`,
  ADD KEY `idx_subject_programme` (`programme_id`),
  ADD KEY `idx_subject_qualification` (`qualification_id`);

-- ============================================================================
-- 5. SUBJECT_LEVEL TABLE
-- Which subjects are offered at which levels
-- ============================================================================

CREATE TABLE IF NOT EXISTS `subject_level` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `subject_id` INT(11) NOT NULL,
  `level_id` INT(11) NOT NULL,
  `syllabus_code` VARCHAR(50) NULL COMMENT 'DHET syllabus reference',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_subject_level` (`subject_id`, `level_id`),
  KEY `idx_subject` (`subject_id`),
  KEY `idx_level` (`level_id`),
  CONSTRAINT `fk_sl_subject` FOREIGN KEY (`subject_id`)
    REFERENCES `subjects`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sl_level` FOREIGN KEY (`level_id`)
    REFERENCES `level`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ============================================================================
-- 6. CLASS TABLE - THE CENTRAL UNIT
-- CLASS = Subject + Level + Cohort + Year + Lecturer
-- This is the heart of the TVET-centric model
-- ============================================================================

CREATE TABLE IF NOT EXISTS `class` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `class_code` VARCHAR(50) NOT NULL COMMENT 'e.g., MATH-N4-A-2026',
  `subject_level_id` INT(11) NOT NULL,
  `cohort_name` VARCHAR(50) NOT NULL COMMENT 'e.g., A, B, C, Group 1, Evening',
  `academic_year` INT(4) NOT NULL,
  `session_id` INT(11) NOT NULL,
  `intake_period` VARCHAR(20) NULL COMMENT 'Jan, Jul, etc.',
  `delivery_mode` ENUM('Full-time', 'Part-time', 'Evening', 'Weekend', 'Distance') NOT NULL DEFAULT 'Full-time',
  `primary_lecturer_id` INT(11) NULL,
  `venue` VARCHAR(100) NULL COMMENT 'Room/Lab assignment',
  `max_students` INT(3) NOT NULL DEFAULT 50,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `status` ENUM('Scheduled', 'Active', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Scheduled',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_code_session` (`class_code`, `session_id`),
  KEY `idx_subject_level` (`subject_level_id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_lecturer` (`primary_lecturer_id`),
  KEY `idx_academic_year` (`academic_year`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_class_subject_level` FOREIGN KEY (`subject_level_id`)
    REFERENCES `subject_level`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_class_session` FOREIGN KEY (`session_id`)
    REFERENCES `sessions`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_class_lecturer` FOREIGN KEY (`primary_lecturer_id`)
    REFERENCES `staff`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ============================================================================
-- 7. STUDENT_PROGRAMME TABLE
-- Tracks student's MAIN programme registration
-- Students have ONE main programme but can take electives from others
-- ============================================================================

CREATE TABLE IF NOT EXISTS `student_programme` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `student_id` INT(11) NOT NULL,
  `programme_id` INT(11) NOT NULL COMMENT 'Main programme',
  `qualification_id` INT(11) NULL COMMENT 'e.g., Business Management',
  `current_level_id` INT(11) NULL COMMENT 'e.g., N4',
  `session_id` INT(11) NOT NULL,
  `registration_date` DATE NOT NULL,
  `status` ENUM('Active', 'Completed', 'Suspended', 'Transferred', 'Withdrawn') NOT NULL DEFAULT 'Active',
  `completion_date` DATE NULL,
  `student_number` VARCHAR(50) NULL COMMENT 'Official student number',
  `notes` TEXT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_programme_session` (`student_id`, `programme_id`, `session_id`),
  KEY `idx_student` (`student_id`),
  KEY `idx_programme` (`programme_id`),
  KEY `idx_qualification` (`qualification_id`),
  KEY `idx_level` (`current_level_id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_sp_student` FOREIGN KEY (`student_id`)
    REFERENCES `students`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sp_programme` FOREIGN KEY (`programme_id`)
    REFERENCES `programme`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_sp_qualification` FOREIGN KEY (`qualification_id`)
    REFERENCES `qualification`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_sp_level` FOREIGN KEY (`current_level_id`)
    REFERENCES `level`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_sp_session` FOREIGN KEY (`session_id`)
    REFERENCES `sessions`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ============================================================================
-- 8. ENROLMENT TABLE
-- Replaces student_session for TVET
-- Links students to classes with enrolment_type (Core/Elective)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `enrolment` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `student_id` INT(11) NOT NULL,
  `class_id` INT(11) NOT NULL,
  `session_id` INT(11) NOT NULL,
  `enrolment_date` DATE NOT NULL,
  `enrolment_type` ENUM('Core', 'Elective') NOT NULL DEFAULT 'Core' COMMENT 'Core=main programme, Elective=from other programme',
  `status` ENUM('Active', 'Completed', 'Dropped', 'Suspended', 'Transferred', 'Withdrawn') NOT NULL DEFAULT 'Active',
  `completion_date` DATE NULL,
  `final_mark` DECIMAL(5,2) NULL,
  `final_result` ENUM('Pass', 'Fail', 'Incomplete', 'Pending') DEFAULT 'Pending',
  `student_number` VARCHAR(50) NULL COMMENT 'Optional student ref',
  `notes` TEXT NULL,
  -- Optional links from student_session functionality
  `hostel_room_id` INT(11) NULL,
  `vehroute_id` INT(11) NULL,
  `route_pickup_point_id` INT(11) NULL,
  `transport_fees` DECIMAL(10,2) NULL,
  `fees_discount` DECIMAL(5,2) NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_class` (`student_id`, `class_id`),
  KEY `idx_student` (`student_id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_status` (`status`),
  KEY `idx_enrolment_type` (`enrolment_type`),
  KEY `idx_hostel` (`hostel_room_id`),
  KEY `idx_route` (`vehroute_id`),
  CONSTRAINT `fk_enrol_student` FOREIGN KEY (`student_id`)
    REFERENCES `students`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_enrol_class` FOREIGN KEY (`class_id`)
    REFERENCES `class`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_enrol_session` FOREIGN KEY (`session_id`)
    REFERENCES `sessions`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_enrol_hostel` FOREIGN KEY (`hostel_room_id`)
    REFERENCES `hostel_rooms`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_enrol_route` FOREIGN KEY (`vehroute_id`)
    REFERENCES `vehicle_routes`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ============================================================================
-- 9. CLASS_LECTURER TABLE
-- Additional lecturers per class (Primary is in class table)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `class_lecturer` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `class_id` INT(11) NOT NULL,
  `staff_id` INT(11) NOT NULL,
  `role` ENUM('Primary', 'Assistant', 'Tutor', 'Assessor', 'Moderator') NOT NULL DEFAULT 'Assistant',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_lecturer` (`class_id`, `staff_id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_staff` (`staff_id`),
  KEY `idx_role` (`role`),
  CONSTRAINT `fk_cl_class` FOREIGN KEY (`class_id`)
    REFERENCES `class`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cl_staff` FOREIGN KEY (`staff_id`)
    REFERENCES `staff`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ============================================================================
-- SEED DATA: Programmes, Qualifications, and Levels
-- ============================================================================

-- Insert default programmes
INSERT INTO `programme` (`code`, `name`, `description`, `programme_type`, `is_active`) VALUES
('NATED', 'National Accredited Technical Education Diploma', 'N1-N6 qualifications offered at TVET colleges', 'NATED', 1),
('NCV', 'National Certificate Vocational', 'NCV Level 2-4 vocational qualifications', 'NCV', 1),
('OCC', 'Occupational Programmes', 'Skills programmes and learnerships', 'Occupational', 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Insert default qualifications under NATED
INSERT INTO `qualification` (`programme_id`, `code`, `name`, `description`, `is_active`)
SELECT p.id, 'BM', 'Business Management', 'Business Management qualification stream', 1
FROM `programme` p WHERE p.code = 'NATED'
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `qualification` (`programme_id`, `code`, `name`, `description`, `is_active`)
SELECT p.id, 'ES', 'Engineering Studies', 'Engineering Studies qualification stream', 1
FROM `programme` p WHERE p.code = 'NATED'
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `qualification` (`programme_id`, `code`, `name`, `description`, `is_active`)
SELECT p.id, 'HR', 'Human Resource Management', 'Human Resource Management qualification stream', 1
FROM `programme` p WHERE p.code = 'NATED'
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `qualification` (`programme_id`, `code`, `name`, `description`, `is_active`)
SELECT p.id, 'PA', 'Public Administration', 'Public Administration qualification stream', 1
FROM `programme` p WHERE p.code = 'NATED'
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `qualification` (`programme_id`, `code`, `name`, `description`, `is_active`)
SELECT p.id, 'MA', 'Marketing', 'Marketing qualification stream', 1
FROM `programme` p WHERE p.code = 'NATED'
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `qualification` (`programme_id`, `code`, `name`, `description`, `is_active`)
SELECT p.id, 'FM', 'Financial Management', 'Financial Management qualification stream', 1
FROM `programme` p WHERE p.code = 'NATED'
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Insert NCV qualifications
INSERT INTO `qualification` (`programme_id`, `code`, `name`, `description`, `is_active`)
SELECT p.id, 'IT', 'Information Technology', 'Information Technology and Computer Science', 1
FROM `programme` p WHERE p.code = 'NCV'
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `qualification` (`programme_id`, `code`, `name`, `description`, `is_active`)
SELECT p.id, 'OMS', 'Office Administration', 'Office Management and Secretarial', 1
FROM `programme` p WHERE p.code = 'NCV'
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT INTO `qualification` (`programme_id`, `code`, `name`, `description`, `is_active`)
SELECT p.id, 'HOSP', 'Hospitality', 'Hospitality and Tourism', 1
FROM `programme` p WHERE p.code = 'NCV'
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Insert default levels
INSERT INTO `level` (`code`, `name`, `level_type`, `nqf_level`, `sequence`, `is_active`) VALUES
('N1', 'N1 (NQF Level 2)', 'NATED', 2, 1, 1),
('N2', 'N2 (NQF Level 3)', 'NATED', 3, 2, 1),
('N3', 'N3 (NQF Level 4)', 'NATED', 4, 3, 1),
('N4', 'N4 (NQF Level 5)', 'NATED', 5, 4, 1),
('N5', 'N5 (NQF Level 5)', 'NATED', 5, 5, 1),
('N6', 'N6 (NQF Level 6)', 'NATED', 6, 6, 1),
('NCV2', 'NCV Level 2', 'NCV', 2, 7, 1),
('NCV3', 'NCV Level 3', 'NCV', 3, 8, 1),
('NCV4', 'NCV Level 4', 'NCV', 4, 9, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- ============================================================================
-- PERMISSIONS
-- ============================================================================

-- Get System Admin permission group ID
SET @perm_group_id = (SELECT id FROM permission_group WHERE short_code = 'system_settings' LIMIT 1);
SET @perm_group_id = IFNULL(@perm_group_id, 1);

-- Programmes permission
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Programmes', 'programmes', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'programmes');

-- Qualifications permission
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Qualifications', 'qualifications', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'qualifications');

-- Levels permission
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Levels', 'levels', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'levels');

-- Subject Levels permission
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Subject Levels', 'subject_levels', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'subject_levels');

-- Classes permission
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Classes', 'classes', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'classes');

-- Student Programme permission
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Student Programme', 'student_programme', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'student_programme');

-- Enrolment permission
INSERT INTO `permission_category` (`perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT @perm_group_id, 'Enrolment', 'enrolment', 1, 1, 1, 1, NOW()
WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'enrolment');

-- Grant permissions to Admin role (id=1)
INSERT INTO roles_permissions (role_id, perm_cat_id, can_view, can_add, can_edit, can_delete)
SELECT 1, pc.id, pc.enable_view, pc.enable_add, pc.enable_edit, pc.enable_delete
FROM permission_category pc
WHERE pc.short_code IN ('programmes', 'qualifications', 'levels', 'subject_levels', 'classes', 'student_programme', 'enrolment')
AND NOT EXISTS (SELECT 1 FROM roles_permissions rp WHERE rp.role_id = 1 AND rp.perm_cat_id = pc.id);

-- Grant permissions to Super Admin role (id=7)
INSERT INTO roles_permissions (role_id, perm_cat_id, can_view, can_add, can_edit, can_delete)
SELECT 7, pc.id, pc.enable_view, pc.enable_add, pc.enable_edit, pc.enable_delete
FROM permission_category pc
WHERE pc.short_code IN ('programmes', 'qualifications', 'levels', 'subject_levels', 'classes', 'student_programme', 'enrolment')
AND NOT EXISTS (SELECT 1 FROM roles_permissions rp WHERE rp.role_id = 7 AND rp.perm_cat_id = pc.id);

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- END OF MIGRATION 1: Core Structure
-- ============================================================================
