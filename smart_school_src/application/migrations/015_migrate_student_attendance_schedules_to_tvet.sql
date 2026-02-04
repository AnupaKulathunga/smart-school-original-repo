-- Migration 015: Migrate student_attendence_schedules to TVET structure
-- Adds class_id column and migrates data from class_section_id
-- Date: 2026-02-04
-- Phase: Bug Fix - Student Attendance Schedules

-- Add class_id column to student_attendence_schedules
ALTER TABLE student_attendence_schedules
ADD COLUMN class_id INT(11) NULL AFTER id,
ADD INDEX idx_class_id (class_id);

-- Migrate data from class_section_id to class_id using migration_log
-- The migration_log table maps old class_section IDs to new class IDs
UPDATE student_attendence_schedules sas
INNER JOIN migration_log ml ON ml.old_id = sas.class_section_id
  AND ml.migration_type = 'class_section_to_class'
SET sas.class_id = ml.new_id
WHERE sas.class_section_id IS NOT NULL;

-- Verify migration
SELECT
  (SELECT COUNT(*) FROM student_attendence_schedules WHERE class_section_id IS NOT NULL) as total_records,
  (SELECT COUNT(*) FROM student_attendence_schedules WHERE class_id IS NOT NULL) as migrated_records,
  (SELECT COUNT(*) FROM student_attendence_schedules WHERE class_section_id IS NOT NULL AND class_id IS NULL) as unmigrated_records;

-- Show results
SELECT 'Student attendance schedules migrated to TVET structure' as status;
