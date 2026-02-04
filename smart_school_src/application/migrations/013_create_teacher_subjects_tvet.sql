-- ============================================================================
-- Migration 013: Create teacher_subjects Table for TVET
-- ============================================================================
-- Purpose: Create teacher_subjects table that uses class_id (TVET) instead of
--          class_section_id (legacy), enabling exam scheduling to work
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing teacher_subjects if it exists (legacy)
DROP TABLE IF EXISTS `teacher_subjects`;

-- Create teacher_subjects table (TVET structure)
CREATE TABLE `teacher_subjects` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `class_id` INT(11) NOT NULL COMMENT 'TVET class ID (replaces class_section_id)',
  `subject_id` INT(11) NOT NULL COMMENT 'Subject ID from subjects table',
  `teacher_id` INT(11) NOT NULL COMMENT 'Staff ID (lecturer)',
  `session_id` INT(11) NOT NULL COMMENT 'Academic session',
  `role` ENUM('Primary', 'Assistant', 'Tutor', 'Assessor', 'Moderator') NOT NULL DEFAULT 'Primary',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_class_subject` (`class_id`, `subject_id`),
  KEY `idx_teacher` (`teacher_id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_active` (`is_active`),
  CONSTRAINT `fk_teacher_subjects_class` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_teacher_subjects_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_teacher_subjects_staff` FOREIGN KEY (`teacher_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_teacher_subjects_session` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- Populate teacher_subjects from TVET class table
-- ============================================================================

-- Insert Primary Lecturers from class table
INSERT INTO `teacher_subjects` (
  `class_id`,
  `subject_id`,
  `teacher_id`,
  `session_id`,
  `role`,
  `is_active`,
  `created_at`
)
SELECT
  c.id AS class_id,
  sl.subject_id,
  c.primary_lecturer_id AS teacher_id,
  c.session_id,
  'Primary' AS role,
  1 AS is_active,
  NOW() AS created_at
FROM `class` c
INNER JOIN `subject_level` sl ON c.subject_level_id = sl.id
WHERE c.primary_lecturer_id IS NOT NULL
  AND c.is_active = 1;

-- Insert Additional Lecturers from class_lecturer table
INSERT INTO `teacher_subjects` (
  `class_id`,
  `subject_id`,
  `teacher_id`,
  `session_id`,
  `role`,
  `is_active`,
  `created_at`
)
SELECT
  cl.class_id,
  sl.subject_id,
  cl.staff_id AS teacher_id,
  c.session_id,
  cl.role,
  cl.is_active,
  cl.created_at
FROM `class_lecturer` cl
INNER JOIN `class` c ON cl.class_id = c.id
INNER JOIN `subject_level` sl ON c.subject_level_id = sl.id
WHERE cl.is_active = 1
  AND c.is_active = 1
  -- Don't duplicate primary lecturer
  AND NOT EXISTS (
    SELECT 1 FROM `teacher_subjects` ts
    WHERE ts.class_id = cl.class_id
      AND ts.teacher_id = cl.staff_id
  );

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- Verification Queries
-- ============================================================================

-- Check teacher_subjects count
SELECT
  COUNT(*) AS total_teacher_subjects,
  COUNT(DISTINCT class_id) AS classes_with_teachers,
  COUNT(DISTINCT teacher_id) AS unique_teachers
FROM teacher_subjects;

-- Sample data
SELECT
  ts.id,
  c.class_code,
  s.name AS subject_name,
  st.name AS teacher_name,
  ts.role,
  ses.session
FROM teacher_subjects ts
INNER JOIN class c ON ts.class_id = c.id
INNER JOIN subjects s ON ts.subject_id = s.id
INNER JOIN staff st ON ts.teacher_id = st.id
INNER JOIN sessions ses ON ts.session_id = ses.id
LIMIT 10;

-- ============================================================================
-- Migration Complete
-- ============================================================================
