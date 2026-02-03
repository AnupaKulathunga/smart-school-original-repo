-- ============================================================================
-- Migration 012: Legacy to TVET Data Migration
-- Migrates data from classes/sections/student_session to new TVET structure
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- 1. MIGRATION LOG TABLE (for tracking and rollback)
-- ============================================================================

DROP TABLE IF EXISTS `migration_log`;

CREATE TABLE `migration_log` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `table_name` VARCHAR(100),
  `old_id` INT,
  `new_id` INT,
  `migration_type` VARCHAR(50),
  `metadata` JSON NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_old_id (old_id),
  INDEX idx_migration_type (migration_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================================
-- 2. GET ACTIVE SESSION
-- ============================================================================

SET @active_session_id = (SELECT id FROM sessions WHERE is_active = 'yes' LIMIT 1);
SET @current_year = YEAR(NOW());
SET @default_programme_id = (SELECT id FROM programme WHERE code = 'NATED' LIMIT 1);

-- ============================================================================
-- 3. ADD TVET COLUMNS TO SUBJECTS TABLE
-- ============================================================================

-- Check if programme_id column exists
SET @prog_col_exists = (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'smart_school'
  AND TABLE_NAME = 'subjects'
  AND COLUMN_NAME = 'programme_id'
);

-- Add TVET columns to subjects if they don't exist
SET @sql_subject_cols = IF(@prog_col_exists = 0,
  'ALTER TABLE subjects
   ADD COLUMN programme_id INT(11) NULL AFTER id,
   ADD COLUMN qualification_id INT(11) NULL AFTER programme_id,
   ADD COLUMN credits INT(3) NOT NULL DEFAULT 0 AFTER code,
   ADD COLUMN notional_hours INT(5) NOT NULL DEFAULT 0 AFTER credits,
   ADD COLUMN is_core TINYINT(1) NOT NULL DEFAULT 1 AFTER notional_hours,
   ADD KEY idx_subject_programme (programme_id),
   ADD KEY idx_subject_qualification (qualification_id);',
  'SELECT "TVET columns already exist in subjects table";'
);

PREPARE stmt FROM @sql_subject_cols;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ============================================================================
-- 4. MIGRATE SUBJECTS TO PROGRAMME
-- Link existing subjects to default NATED programme
-- ============================================================================

UPDATE subjects
SET programme_id = @default_programme_id,
    is_core = 1
WHERE is_active = 'yes'
AND (programme_id IS NULL OR programme_id = 0);

-- ============================================================================
-- 5. MIGRATE CLASSES → LEVEL
-- Convert legacy "classes" (e.g., "Class 1", "Grade 4") to TVET levels
-- ============================================================================

INSERT INTO level (code, name, level_type, sequence, is_active)
SELECT
  CONCAT('LEG', c.id),
  c.class,
  'Other',
  c.id,
  1
FROM classes c
WHERE c.is_active = 'yes'
AND NOT EXISTS (SELECT 1 FROM level l WHERE l.code = CONCAT('LEG', c.id));

-- Log migration
INSERT INTO migration_log (table_name, old_id, new_id, migration_type, metadata)
SELECT 'classes', c.id, l.id, 'class_to_level',
  JSON_OBJECT('class_name', c.class)
FROM classes c
INNER JOIN level l ON l.code = CONCAT('LEG', c.id)
WHERE c.is_active = 'yes';

-- ============================================================================
-- 6. CREATE SUBJECT_LEVEL MAPPINGS
-- Link all active subjects to all levels (cross product)
-- ============================================================================

INSERT INTO subject_level (subject_id, level_id, is_active)
SELECT DISTINCT s.id, l.id, 1
FROM subjects s
CROSS JOIN level l
WHERE s.is_active = 'yes'
AND l.is_active = 1
AND NOT EXISTS (
  SELECT 1 FROM subject_level sl
  WHERE sl.subject_id = s.id AND sl.level_id = l.id
);

-- ============================================================================
-- 7. MIGRATE CLASS_SECTIONS → CLASS
-- Convert class+section combinations to TVET classes
-- Each subject at each level with each section becomes a CLASS
-- ============================================================================

-- Create a class for each subject-level-section combination
INSERT INTO class (
  class_code,
  subject_level_id,
  cohort_name,
  academic_year,
  session_id,
  delivery_mode,
  primary_lecturer_id,
  status,
  is_active
)
SELECT DISTINCT
  CONCAT(
    COALESCE(sub.code, 'GEN'), '-',
    COALESCE(lev.code, 'LEG'), '-',
    sec.section, '-',
    @current_year
  ) as class_code,
  sl.id as subject_level_id,
  sec.section as cohort_name,
  @current_year as academic_year,
  @active_session_id as session_id,
  'Full-time' as delivery_mode,
  (SELECT ct.staff_id FROM class_teacher ct
   WHERE ct.class_id = cls.id
   AND ct.section_id = sec.id
   LIMIT 1) as primary_lecturer_id,
  'Active' as status,
  1 as is_active
FROM classes cls
INNER JOIN sections sec ON sec.is_active = 'yes'
LEFT JOIN level lev ON lev.code = CONCAT('LEG', cls.id)
CROSS JOIN subjects sub
LEFT JOIN subject_level sl ON sl.subject_id = sub.id AND sl.level_id = lev.id
WHERE cls.is_active = 'yes'
AND sub.is_active = 'yes'
AND sl.id IS NOT NULL
-- Prevent duplicates
AND NOT EXISTS (
  SELECT 1 FROM class c
  WHERE c.class_code = CONCAT(
    COALESCE(sub.code, 'GEN'), '-',
    COALESCE(lev.code, 'LEG'), '-',
    sec.section, '-',
    @current_year
  )
  AND c.session_id = @active_session_id
);

-- Log class migration
INSERT INTO migration_log (table_name, old_id, new_id, migration_type, metadata)
SELECT
  'class_sections',
  cls.id,
  c.id,
  'class_section_to_class',
  JSON_OBJECT(
    'class_name', cls.class,
    'section_name', sec.section,
    'subject_name', sub.name,
    'class_code', c.class_code
  )
FROM classes cls
CROSS JOIN sections sec
CROSS JOIN subjects sub
INNER JOIN level lev ON lev.code = CONCAT('LEG', cls.id)
INNER JOIN subject_level sl ON sl.subject_id = sub.id AND sl.level_id = lev.id
INNER JOIN class c ON c.subject_level_id = sl.id
  AND c.cohort_name = sec.section
  AND c.session_id = @active_session_id
WHERE cls.is_active = 'yes'
AND sec.is_active = 'yes'
AND sub.is_active = 'yes';

-- ============================================================================
-- 8. MIGRATE STUDENT_SESSION → STUDENT_PROGRAMME
-- Create one student_programme record per student
-- ============================================================================

INSERT INTO student_programme (
  student_id,
  programme_id,
  qualification_id,
  current_level_id,
  session_id,
  registration_date,
  status,
  is_active
)
SELECT DISTINCT
  ss.student_id,
  @default_programme_id,
  NULL as qualification_id,
  (SELECT l.id FROM level l
   INNER JOIN classes c ON l.code = CONCAT('LEG', c.id)
   WHERE c.id = ss.class_id LIMIT 1) as current_level_id,
  ss.session_id,
  COALESCE(s.admission_date, NOW()) as registration_date,
  'Active' as status,
  1 as is_active
FROM student_session ss
INNER JOIN students s ON ss.student_id = s.id
WHERE s.is_active = 'yes'
AND ss.session_id = @active_session_id
AND NOT EXISTS (
  SELECT 1 FROM student_programme sp
  WHERE sp.student_id = ss.student_id
  AND sp.session_id = ss.session_id
);

-- Log student_programme migration
INSERT INTO migration_log (table_name, old_id, new_id, migration_type, metadata)
SELECT
  'student_session',
  ss.id,
  sp.id,
  'student_session_to_programme',
  JSON_OBJECT('student_id', ss.student_id)
FROM student_session ss
INNER JOIN student_programme sp ON sp.student_id = ss.student_id
  AND sp.session_id = ss.session_id;

-- ============================================================================
-- 9. MIGRATE STUDENT_SESSION → ENROLMENT
-- Create enrolment records linking students to classes
-- ============================================================================

-- Enroll students in all classes for their level
INSERT INTO enrolment (
  student_id,
  class_id,
  session_id,
  enrolment_date,
  enrolment_type,
  status,
  hostel_room_id,
  vehroute_id,
  route_pickup_point_id,
  transport_fees,
  fees_discount,
  is_active
)
SELECT DISTINCT
  ss.student_id,
  c.id as class_id,
  ss.session_id,
  NOW() as enrolment_date,
  'Core' as enrolment_type,
  'Active' as status,
  ss.hostel_room_id,
  ss.vehroute_id,
  ss.route_pickup_point_id,
  ss.transport_fees,
  ss.fees_discount,
  1 as is_active
FROM student_session ss
INNER JOIN students s ON ss.student_id = s.id
INNER JOIN sections sec ON ss.section_id = sec.id
INNER JOIN classes cls ON ss.class_id = cls.id
INNER JOIN level lev ON lev.code = CONCAT('LEG', cls.id)
INNER JOIN class c ON c.cohort_name = sec.section
  AND c.session_id = ss.session_id
  AND c.subject_level_id IN (
    SELECT sl.id FROM subject_level sl WHERE sl.level_id = lev.id
  )
WHERE s.is_active = 'yes'
AND ss.session_id = @active_session_id
AND NOT EXISTS (
  SELECT 1 FROM enrolment e
  WHERE e.student_id = ss.student_id
  AND e.class_id = c.id
);

-- Log enrolment migration
INSERT INTO migration_log (table_name, old_id, new_id, migration_type, metadata)
SELECT
  'student_session',
  ss.id,
  e.id,
  'student_session_to_enrolment',
  JSON_OBJECT(
    'student_id', ss.student_id,
    'class_id', e.class_id,
    'enrolment_type', e.enrolment_type
  )
FROM student_session ss
INNER JOIN enrolment e ON e.student_id = ss.student_id
  AND e.session_id = ss.session_id;

-- ============================================================================
-- 10. UPDATE ATTENDANCE RECORDS
-- Add enrolment_id to student_attendences table
-- ============================================================================

-- Check if column exists, add if not
SET @col_exists = (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'smart_school'
  AND TABLE_NAME = 'student_attendences'
  AND COLUMN_NAME = 'enrolment_id'
);

SET @sql_add_col = IF(@col_exists = 0,
  'ALTER TABLE student_attendences ADD COLUMN enrolment_id INT(11) NULL AFTER id, ADD INDEX idx_enrolment (enrolment_id);',
  'SELECT "Column enrolment_id already exists";'
);

PREPARE stmt FROM @sql_add_col;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Update attendance records with enrolment_id
-- Map student_session_id to enrolment_id via migration_log
UPDATE student_attendences sa
INNER JOIN student_session ss ON sa.student_session_id = ss.id
INNER JOIN enrolment e ON e.student_id = ss.student_id
  AND e.session_id = ss.session_id
SET sa.enrolment_id = e.id
WHERE sa.enrolment_id IS NULL
AND sa.student_session_id IS NOT NULL;

-- ============================================================================
-- 11. UPDATE ACADEMIC MARKS
-- academic_assessment_marks already has enrolment_id - nothing to do here
-- The table structure is already TVET-ready
-- ============================================================================

SELECT 'Academic marks table already uses enrolment_id - no migration needed' as status;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- MIGRATION SUMMARY
-- ============================================================================

SELECT
  'MIGRATION COMPLETE' as status,
  (SELECT COUNT(*) FROM programme) as programmes,
  (SELECT COUNT(*) FROM qualification) as qualifications,
  (SELECT COUNT(*) FROM level) as levels,
  (SELECT COUNT(*) FROM subject_level) as subject_levels,
  (SELECT COUNT(*) FROM class) as classes,
  (SELECT COUNT(*) FROM student_programme) as student_programmes,
  (SELECT COUNT(*) FROM enrolment) as enrolments,
  (SELECT COUNT(*) FROM migration_log) as migration_log_entries;

-- ============================================================================
-- END OF MIGRATION 012
-- ============================================================================
