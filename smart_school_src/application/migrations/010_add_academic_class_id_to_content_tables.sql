-- ============================================================================
-- Migration 010: Add academic_class_id to Content Tables
-- Enables content management to work with TVET academic model
-- Phase 3: Content & Lessons Migration
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. CONTENTS TABLE
-- Add academic_class_id alongside existing cls_sec_id (dual-column approach)
-- ============================================================================

ALTER TABLE `contents`
  ADD COLUMN `academic_class_id` INT(11) NULL AFTER `cls_sec_id`,
  ADD KEY `idx_academic_class` (`academic_class_id`),
  ADD CONSTRAINT `fk_contents_academic_class`
    FOREIGN KEY (`academic_class_id`)
    REFERENCES `academic_class`(`id`)
    ON DELETE CASCADE;

-- ============================================================================
-- 2. HOMEWORK TABLE
-- Add academic_class_id alongside existing class_id + section_id
-- ============================================================================

ALTER TABLE `homework`
  ADD COLUMN `academic_class_id` INT(11) NULL AFTER `section_id`,
  ADD KEY `idx_homework_academic_class` (`academic_class_id`),
  ADD CONSTRAINT `fk_homework_academic_class`
    FOREIGN KEY (`academic_class_id`)
    REFERENCES `academic_class`(`id`)
    ON DELETE CASCADE;

-- ============================================================================
-- 3. LESSON TABLE (Lesson Plans)
-- Add academic_class_id alongside existing subject_group_class_sections_id
-- ============================================================================

ALTER TABLE `lesson`
  ADD COLUMN `academic_class_id` INT(11) NULL AFTER `subject_group_class_sections_id`,
  ADD KEY `idx_lesson_academic_class` (`academic_class_id`),
  ADD CONSTRAINT `fk_lesson_academic_class`
    FOREIGN KEY (`academic_class_id`)
    REFERENCES `academic_class`(`id`)
    ON DELETE CASCADE;

-- ============================================================================
-- 4. DAILY ASSIGNMENT TABLE
-- Add academic_enrolment_id to link to student's class enrolment
-- Keep student_session_id for backward compatibility during migration
-- ============================================================================

ALTER TABLE `daily_assignment`
  ADD COLUMN `academic_enrolment_id` INT(11) NULL AFTER `student_session_id`,
  ADD KEY `idx_daily_assignment_enrolment` (`academic_enrolment_id`),
  ADD CONSTRAINT `fk_daily_assignment_enrolment`
    FOREIGN KEY (`academic_enrolment_id`)
    REFERENCES `academic_class_enrolment`(`id`)
    ON DELETE CASCADE;

-- ============================================================================
-- 5. UPDATE MIGRATION VERSION
-- ============================================================================

INSERT INTO `migrations` (`version`)
VALUES (10)
ON DUPLICATE KEY UPDATE `version` = 10;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- NOTES FOR FUTURE MIGRATION (Phase 7):
-- ============================================================================
-- Once all code is migrated to use academic_class_id:
-- 1. Drop old foreign keys and columns:
--    ALTER TABLE contents DROP COLUMN cls_sec_id;
--    ALTER TABLE homework DROP COLUMN class_id, DROP COLUMN section_id;
--    ALTER TABLE lesson DROP COLUMN subject_group_class_sections_id;
--    ALTER TABLE daily_assignment DROP COLUMN student_session_id;
-- 2. Make academic_class_id NOT NULL:
--    ALTER TABLE contents MODIFY academic_class_id INT(11) NOT NULL;
--    ALTER TABLE homework MODIFY academic_class_id INT(11) NOT NULL;
--    ALTER TABLE lesson MODIFY academic_class_id INT(11) NOT NULL;
--    ALTER TABLE daily_assignment MODIFY academic_enrolment_id INT(11) NOT NULL;
-- ============================================================================
