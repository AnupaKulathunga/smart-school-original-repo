-- ============================================================================
-- Migration 012 Verification Script
-- Validates data integrity after migration
-- ============================================================================

SELECT '========================================' as '';
SELECT 'TVET MIGRATION VERIFICATION REPORT' as '';
SELECT '========================================' as '';

-- 1. Compare student counts
SELECT '' as '';
SELECT '1. STUDENT COUNT VERIFICATION' as '';
SELECT '----------------------------' as '';

SELECT 'Legacy student_session records' as metric,
  COUNT(DISTINCT student_id) as count
FROM student_session
WHERE session_id = (SELECT id FROM sessions WHERE is_active = 'yes');

SELECT 'New student_programme records' as metric,
  COUNT(DISTINCT student_id) as count
FROM student_programme
WHERE session_id = (SELECT id FROM sessions WHERE is_active = 'yes');

SELECT 'New enrolment records' as metric,
  COUNT(DISTINCT student_id) as count
FROM enrolment
WHERE session_id = (SELECT id FROM sessions WHERE is_active = 'yes');

-- 2. Verify all students have at least one enrolment
SELECT '' as '';
SELECT '2. ORPHANED STUDENTS CHECK' as '';
SELECT '----------------------------' as '';

SELECT 'Students without enrolments' as status,
  COUNT(*) as count
FROM students s
WHERE s.is_active = 'yes'
AND NOT EXISTS (
  SELECT 1 FROM enrolment e
  WHERE e.student_id = s.id
  AND e.session_id = (SELECT id FROM sessions WHERE is_active = 'yes')
);

-- 3. Verify attendance migration
SELECT '' as '';
SELECT '3. ATTENDANCE MIGRATION CHECK' as '';
SELECT '--------------------------------' as '';

SELECT 'Total attendance records' as metric,
  COUNT(*) as count
FROM student_attendences;

SELECT 'Attendance with enrolment_id' as metric,
  COUNT(*) as count
FROM student_attendences
WHERE enrolment_id IS NOT NULL;

SELECT 'Attendance without enrolment_id (orphaned)' as metric,
  COUNT(*) as count
FROM student_attendences
WHERE enrolment_id IS NULL
AND student_session_id IS NOT NULL;

-- 4. Verify classes created
SELECT '' as '';
SELECT '4. CLASS CREATION VERIFICATION' as '';
SELECT '---------------------------------' as '';

SELECT 'Legacy classes' as metric,
  COUNT(*) as count
FROM classes
WHERE is_active = 'yes';

SELECT 'Legacy sections' as metric,
  COUNT(*) as count
FROM sections
WHERE is_active = 'yes';

SELECT 'New TVET classes' as metric,
  COUNT(*) as count
FROM class
WHERE is_active = 1;

-- 5. Sample class data
SELECT '' as '';
SELECT '5. SAMPLE CLASS DATA' as '';
SELECT '----------------------' as '';

SELECT
  c.id,
  c.class_code,
  sub.name as subject,
  lev.name as level,
  c.cohort_name,
  c.academic_year,
  st.name as lecturer,
  (SELECT COUNT(*) FROM enrolment e WHERE e.class_id = c.id) as student_count
FROM class c
INNER JOIN subject_level sl ON c.subject_level_id = sl.id
INNER JOIN subjects sub ON sl.subject_id = sub.id
INNER JOIN level lev ON sl.level_id = lev.id
LEFT JOIN staff st ON c.primary_lecturer_id = st.id
WHERE c.session_id = (SELECT id FROM sessions WHERE is_active = 'yes')
LIMIT 10;

-- 6. Sample enrolment data
SELECT '' as '';
SELECT '6. SAMPLE ENROLMENT DATA' as '';
SELECT '--------------------------' as '';

SELECT
  e.id as enrolment_id,
  s.admission_no,
  CONCAT(s.firstname, ' ', s.lastname) as student_name,
  c.class_code,
  e.enrolment_type,
  e.status
FROM enrolment e
INNER JOIN students s ON e.student_id = s.id
INNER JOIN class c ON e.class_id = c.id
WHERE e.session_id = (SELECT id FROM sessions WHERE is_active = 'yes')
LIMIT 10;

-- 7. Migration log summary
SELECT '' as '';
SELECT '7. MIGRATION LOG SUMMARY' as '';
SELECT '--------------------------' as '';

SELECT
  migration_type,
  COUNT(*) as count
FROM migration_log
GROUP BY migration_type
ORDER BY migration_type;

-- 8. Data integrity checks
SELECT '' as '';
SELECT '8. DATA INTEGRITY CHECKS' as '';
SELECT '--------------------------' as '';

SELECT 'Classes without subject_level' as issue,
  COUNT(*) as count
FROM class c
WHERE c.subject_level_id NOT IN (SELECT id FROM subject_level);

SELECT 'Enrolments without valid class' as issue,
  COUNT(*) as count
FROM enrolment e
WHERE e.class_id NOT IN (SELECT id FROM class);

SELECT 'Enrolments without valid student' as issue,
  COUNT(*) as count
FROM enrolment e
WHERE e.student_id NOT IN (SELECT id FROM students);

-- 9. Summary
SELECT '' as '';
SELECT '========================================' as '';
SELECT 'VERIFICATION COMPLETE' as '';
SELECT 'Review any issues above before proceeding' as '';
SELECT '========================================' as '';
