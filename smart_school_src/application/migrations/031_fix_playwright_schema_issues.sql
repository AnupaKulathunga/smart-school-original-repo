-- Migration 031: Fix schema issues found by Playwright E2E tests
-- Fixes 3 root causes of all test failures:
-- 1. academic_level.sequence → sequence_order (column rename)
-- 2. academic_class_enrolment missing student_session_id bridge column
-- 3. student_attendences missing enrolment_id column

-- ============================================================================
-- FIX 1: Rename academic_level.sequence to sequence_order
-- Models reference sequence_order but column is named sequence
-- ============================================================================
ALTER TABLE `academic_level` CHANGE COLUMN `sequence` `sequence_order` INT DEFAULT 1;

-- ============================================================================
-- FIX 2: Add student_session_id bridge column to academic_class_enrolment
-- Student_model JOINs: academic_class_enrolment e ON e.student_session_id = ss.id
-- This creates the bridge between legacy student_session and TVET enrolment
-- ============================================================================
ALTER TABLE `academic_class_enrolment`
  ADD COLUMN `student_session_id` INT(11) NULL AFTER `student_id`,
  ADD INDEX `idx_student_session` (`student_session_id`);

-- Populate student_session_id from matching student_id + session data
-- Each enrolment links to the student_session for the same student in the same session
UPDATE `academic_class_enrolment` e
  INNER JOIN `academic_class` ac ON ac.id = e.class_id
  INNER JOIN `student_session` ss ON ss.student_id = e.student_id AND ss.session_id = ac.session_id
SET e.student_session_id = ss.id
WHERE e.student_session_id IS NULL;

-- ============================================================================
-- FIX 3: Add enrolment_id column to student_attendences
-- Stuattendence_model references student_attendences.enrolment_id for TVET attendance
-- ============================================================================
ALTER TABLE `student_attendences`
  ADD COLUMN `enrolment_id` INT(11) NULL AFTER `id`,
  ADD INDEX `idx_enrolment` (`enrolment_id`);
