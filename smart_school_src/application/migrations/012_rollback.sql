-- ============================================================================
-- Migration 012 Rollback Script
-- EMERGENCY USE ONLY - Restores database to pre-migration state
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

SELECT 'WARNING: This will DELETE all TVET data and restore legacy structure' as '';
SELECT 'Press Ctrl+C within 5 seconds to abort...' as '';
SELECT SLEEP(5);

-- ============================================================================
-- 1. REMOVE ENROLMENT_ID FROM ATTENDANCE
-- ============================================================================

ALTER TABLE student_attendences DROP COLUMN IF EXISTS enrolment_id;

-- ============================================================================
-- 2. REMOVE ENROLMENT_ID FROM MARKS (if added)
-- ============================================================================

-- academic_assessment_marks already has enrolment_id natively, don't drop it

-- ============================================================================
-- 3. DROP NEW TVET TABLES
-- ============================================================================

DROP TABLE IF EXISTS `migration_log`;
DROP TABLE IF EXISTS `class_lecturer`;
DROP TABLE IF EXISTS `enrolment`;
DROP TABLE IF EXISTS `student_programme`;
DROP TABLE IF EXISTS `class`;
DROP TABLE IF EXISTS `subject_level`;
DROP TABLE IF EXISTS `level`;
DROP TABLE IF EXISTS `qualification`;
DROP TABLE IF EXISTS `programme`;

-- ============================================================================
-- 4. REMOVE TVET COLUMNS FROM SUBJECTS
-- ============================================================================

ALTER TABLE subjects
DROP COLUMN IF EXISTS programme_id,
DROP COLUMN IF EXISTS qualification_id,
DROP COLUMN IF EXISTS credits,
DROP COLUMN IF EXISTS notional_hours,
DROP COLUMN IF EXISTS is_core;

-- ============================================================================
-- 5. CLEANUP PERMISSIONS
-- ============================================================================

DELETE FROM roles_permissions
WHERE perm_cat_id IN (
  SELECT id FROM permission_category
  WHERE short_code IN ('programmes', 'qualifications', 'levels', 'subject_levels', 'classes', 'student_programme', 'enrolment')
);

DELETE FROM permission_category
WHERE short_code IN ('programmes', 'qualifications', 'levels', 'subject_levels', 'classes', 'student_programme', 'enrolment');

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- ROLLBACK COMPLETE
-- ============================================================================

SELECT '========================================' as '';
SELECT 'ROLLBACK COMPLETE' as '';
SELECT 'All TVET tables and data removed' as '';
SELECT 'Legacy class/section structure restored' as '';
SELECT 'Restore from backup if needed:' as '';
SELECT 'docker-compose exec db mysql -usmartschool -psmartschool123 smart_school < backups/backup_pre_tvet_YYYYMMDD.sql' as '';
SELECT '========================================' as '';
