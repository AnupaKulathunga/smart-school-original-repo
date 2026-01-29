-- ============================================================
-- QA Test Data for Docker Development Environment
-- Creates: Teacher, Student, Class, Section, Student Session
-- ============================================================

-- ============================================================
-- 1. School Settings - Enable student/parent panel login
-- ============================================================
UPDATE `sch_settings` SET
    `student_panel_login` = 1,
    `parent_panel_login` = 1
WHERE `id` = 1;

-- ============================================================
-- 2. Create Classes
-- ============================================================
INSERT INTO `classes` (`id`, `class`, `is_active`, `created_at`)
SELECT 1, 'N4 Business Management', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `classes` WHERE `id` = 1);

INSERT INTO `classes` (`id`, `class`, `is_active`, `created_at`)
SELECT 2, 'N5 Business Management', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `classes` WHERE `id` = 2);

INSERT INTO `classes` (`id`, `class`, `is_active`, `created_at`)
SELECT 3, 'NCV Engineering L2', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `classes` WHERE `id` = 3);

-- ============================================================
-- 3. Create Sections (Groups)
-- ============================================================
INSERT INTO `sections` (`id`, `section`, `is_active`, `created_at`)
SELECT 1, 'Group A', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `sections` WHERE `id` = 1);

INSERT INTO `sections` (`id`, `section`, `is_active`, `created_at`)
SELECT 2, 'Group B', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `sections` WHERE `id` = 2);

INSERT INTO `sections` (`id`, `section`, `is_active`, `created_at`)
SELECT 3, 'Evening', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `sections` WHERE `id` = 3);

-- ============================================================
-- 4. Link Classes to Sections
-- ============================================================
INSERT INTO `class_sections` (`id`, `class_id`, `section_id`, `created_at`)
SELECT 1, 1, 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `class_sections` WHERE `id` = 1);

INSERT INTO `class_sections` (`id`, `class_id`, `section_id`, `created_at`)
SELECT 2, 1, 2, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `class_sections` WHERE `id` = 2);

INSERT INTO `class_sections` (`id`, `class_id`, `section_id`, `created_at`)
SELECT 3, 2, 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `class_sections` WHERE `id` = 3);

INSERT INTO `class_sections` (`id`, `class_id`, `section_id`, `created_at`)
SELECT 4, 3, 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `class_sections` WHERE `id` = 4);

-- ============================================================
-- 5. Create Subjects
-- ============================================================
INSERT INTO `subjects` (`id`, `name`, `code`, `type`, `is_active`, `created_at`)
SELECT 1, 'Business Management N4', 'BMN4', 'theory', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `subjects` WHERE `id` = 1);

INSERT INTO `subjects` (`id`, `name`, `code`, `type`, `is_active`, `created_at`)
SELECT 2, 'Financial Management N4', 'FMN4', 'theory', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `subjects` WHERE `id` = 2);

INSERT INTO `subjects` (`id`, `name`, `code`, `type`, `is_active`, `created_at`)
SELECT 3, 'Marketing & Communication N4', 'MCN4', 'theory', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `subjects` WHERE `id` = 3);

INSERT INTO `subjects` (`id`, `name`, `code`, `type`, `is_active`, `created_at`)
SELECT 4, 'Entrepreneurship N4', 'EBMN4', 'theory', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `subjects` WHERE `id` = 4);

-- ============================================================
-- 6. Create Subject Groups and assign subjects to class
-- ============================================================
INSERT INTO `subject_groups` (`id`, `name`, `session_id`, `description`, `created_at`)
SELECT 1, 'N4 Core Modules', (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 'N4 Business Management Core', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `subject_groups` WHERE `id` = 1);

INSERT INTO `subject_group_subjects` (`id`, `subject_id`, `subject_group_id`, `created_at`)
SELECT 1, 1, 1, NOW() FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `subject_group_subjects` WHERE `id` = 1);
INSERT INTO `subject_group_subjects` (`id`, `subject_id`, `subject_group_id`, `created_at`)
SELECT 2, 2, 1, NOW() FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `subject_group_subjects` WHERE `id` = 2);
INSERT INTO `subject_group_subjects` (`id`, `subject_id`, `subject_group_id`, `created_at`)
SELECT 3, 3, 1, NOW() FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `subject_group_subjects` WHERE `id` = 3);
INSERT INTO `subject_group_subjects` (`id`, `subject_id`, `subject_group_id`, `created_at`)
SELECT 4, 4, 1, NOW() FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `subject_group_subjects` WHERE `id` = 4);

-- ============================================================
-- 7. Create Teacher Staff Account
--    Login: teacher@school.com / Teacher@123
-- ============================================================
INSERT INTO `staff` (`id`, `employee_id`, `name`, `surname`, `dob`, `gender`, `email`, `password`, `is_active`, `created_at`)
SELECT 2, '8001', 'John', 'Lecturer', '1985-03-15', 'Male', 'teacher@school.com',
    '$2y$12$OmGFfKmPbWcJ44WmDlISzeeDJSBem2pFpndZF4y295at6D2dDj7py', 1, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `staff` WHERE `id` = 2);

INSERT INTO `staff_roles` (`staff_id`, `role_id`, `is_active`)
SELECT 2, 2, 1
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `staff_roles` WHERE `staff_id` = 2 AND `role_id` = 2);

-- ============================================================
-- 8. Create Student Account
--    Login (student portal): std1 / Student@123
-- ============================================================
INSERT INTO `students` (`id`, `parent_id`, `admission_no`, `firstname`, `lastname`, `dob`, `gender`,
    `email`, `mobileno`, `guardian_is`, `guardian_name`, `guardian_phone`, `is_active`, `created_at`)
SELECT 1, 0, '2026001', 'Test', 'Student', '2000-05-20', 'Male',
    'student@school.com', '0821234567', 'father', 'Parent Name', '0829876543', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `students` WHERE `id` = 1);

-- Create user login for student (plain text password in users table)
INSERT INTO `users` (`id`, `user_id`, `username`, `password`, `childs`, `role`, `lang_id`, `is_active`, `created_at`)
SELECT 1, 1, 'std1', 'Student@123', '', 'student', 0, 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `users` WHERE `id` = 1);

-- ============================================================
-- 9. Create Student Session (links student to class/section for current year)
-- ============================================================
INSERT INTO `student_session` (`id`, `session_id`, `student_id`, `class_id`, `section_id`, `is_alumni`, `created_at`)
SELECT 1,
    (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1),
    1, 1, 1, 'no', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `student_session` WHERE `id` = 1);

-- ============================================================
-- 10. Create Second Student (for accommodation testing)
--     Login (student portal): std2 / Student@123
-- ============================================================
INSERT INTO `students` (`id`, `parent_id`, `admission_no`, `firstname`, `lastname`, `dob`, `gender`,
    `email`, `mobileno`, `guardian_is`, `guardian_name`, `guardian_phone`, `is_active`, `created_at`)
SELECT 2, 0, '2026002', 'Jane', 'Disability', '2001-08-10', 'Female',
    'student2@school.com', '0821234568', 'mother', 'Parent Two', '0829876544', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `students` WHERE `id` = 2);

INSERT INTO `users` (`id`, `user_id`, `username`, `password`, `childs`, `role`, `lang_id`, `is_active`, `created_at`)
SELECT 2, 2, 'std2', 'Student@123', '', 'student', 0, 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `users` WHERE `id` = 2);

INSERT INTO `student_session` (`id`, `session_id`, `student_id`, `class_id`, `section_id`, `is_alumni`, `created_at`)
SELECT 2,
    (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1),
    2, 1, 1, 'no', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `student_session` WHERE `id` = 2);

-- ============================================================
-- 11. Content Types (for filter testing)
-- ============================================================
INSERT INTO `content_types` (`id`, `name`, `is_active`, `created_at`)
SELECT 1, 'Study Material', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `content_types` WHERE `id` = 1);

INSERT INTO `content_types` (`id`, `name`, `is_active`, `created_at`)
SELECT 2, 'Past Paper', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `content_types` WHERE `id` = 2);

INSERT INTO `content_types` (`id`, `name`, `is_active`, `created_at`)
SELECT 3, 'Assignment', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `content_types` WHERE `id` = 3);

INSERT INTO `content_types` (`id`, `name`, `is_active`, `created_at`)
SELECT 4, 'Syllabus', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `content_types` WHERE `id` = 4);

INSERT INTO `content_types` (`id`, `name`, `is_active`, `created_at`)
SELECT 5, 'Other', 'yes', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `content_types` WHERE `id` = 5);

-- ============================================================
-- 12. Sample Online Exam (for preview/moderation/assign testing)
-- ============================================================
INSERT INTO `onlineexam` (`id`, `exam`, `description`, `attempt`, `passing_percentage`,
    `publish_result`, `is_active`, `duration`, `session_id`, `created_at`)
SELECT 1, 'BMN4 Mid-Year Test', 'Business Management N4 mid-year examination', 1, 50,
    0, 'no', '01:00:00',
    (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam` WHERE `id` = 1);

-- ============================================================
-- 13. Question Bank - Sample Questions for Exams
-- ============================================================

-- Multiple Choice Questions (MCQ) - question_type = 'singlechoice'
INSERT INTO `questions` (`id`, `staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `created_at`)
SELECT 1, 1, 1, 'singlechoice', 'low', 1, 1,
    'What is the primary function of management?',
    'Planning and organizing resources',
    'Selling products to customers',
    'Manufacturing goods',
    'Accounting for finances',
    '',
    'opt_a', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 1);

INSERT INTO `questions` (`id`, `staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `created_at`)
SELECT 2, 1, 1, 'singlechoice', 'medium', 1, 1,
    'Which of the following is NOT a management function?',
    'Planning',
    'Organizing',
    'Coding',
    'Controlling',
    '',
    'opt_c', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 2);

INSERT INTO `questions` (`id`, `staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `created_at`)
SELECT 3, 1, 1, 'singlechoice', 'medium', 1, 1,
    'A SWOT analysis examines:',
    'Sales, Workers, Output, Training',
    'Strengths, Weaknesses, Opportunities, Threats',
    'Staff, Wages, Operations, Technology',
    'Systems, Workflows, Objectives, Tasks',
    '',
    'opt_b', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 3);

INSERT INTO `questions` (`id`, `staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `created_at`)
SELECT 4, 1, 1, 'singlechoice', 'high', 1, 1,
    'What type of organizational structure has employees reporting to multiple managers?',
    'Functional structure',
    'Divisional structure',
    'Matrix structure',
    'Flat structure',
    '',
    'opt_c', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 4);

INSERT INTO `questions` (`id`, `staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `created_at`)
SELECT 5, 1, 1, 'singlechoice', 'low', 1, 1,
    'Leadership is best defined as:',
    'Forcing employees to work harder',
    'Influencing others to achieve organizational goals',
    'Monitoring employee attendance',
    'Calculating company profits',
    '',
    'opt_b', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 5);

-- Multiple Answer Questions - question_type = 'multichoice'
INSERT INTO `questions` (`id`, `staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `created_at`)
SELECT 6, 1, 1, 'multichoice', 'medium', 1, 1,
    'Select ALL that are considered external factors in a PESTLE analysis:',
    'Political factors',
    'Employee motivation',
    'Economic conditions',
    'Technological changes',
    'Internal policies',
    'opt_a,opt_c,opt_d', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 6);

INSERT INTO `questions` (`id`, `staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `created_at`)
SELECT 7, 1, 1, 'multichoice', 'high', 1, 1,
    'Which of the following are characteristics of a good business objective? (Select all that apply)',
    'Specific',
    'Measurable',
    'Vague',
    'Time-bound',
    '',
    'opt_a,opt_b,opt_d', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 7);

-- True/False Questions - question_type = 'true_false'
INSERT INTO `questions` (`id`, `staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `created_at`)
SELECT 8, 1, 1, 'true_false', 'low', 1, 1,
    'Delegation means assigning tasks to subordinates while retaining overall responsibility.',
    'True',
    'False',
    '',
    '',
    '',
    'opt_a', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 8);

INSERT INTO `questions` (`id`, `staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `created_at`)
SELECT 9, 1, 1, 'true_false', 'low', 1, 1,
    'Managers at all levels require the same balance of technical and conceptual skills.',
    'True',
    'False',
    '',
    '',
    '',
    'opt_b', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 9);

INSERT INTO `questions` (`id`, `staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `created_at`)
SELECT 10, 1, 1, 'true_false', 'medium', 1, 1,
    'A mission statement describes what the organization wants to become in the future.',
    'True',
    'False',
    '',
    '',
    '',
    'opt_b', 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 10);

-- ============================================================
-- 14. Link Questions to Exams (onlineexam_questions)
-- ============================================================

-- Add questions to the sample exam (exam ID = 1)
INSERT INTO `onlineexam_questions` (`id`, `question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`, `created_at`)
SELECT 1, 1, 1, (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 10.00, 0.00, '1', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `id` = 1);

INSERT INTO `onlineexam_questions` (`id`, `question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`, `created_at`)
SELECT 2, 2, 1, (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 10.00, 0.00, '1', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `id` = 2);

INSERT INTO `onlineexam_questions` (`id`, `question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`, `created_at`)
SELECT 3, 3, 1, (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 10.00, 0.00, '1', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `id` = 3);

INSERT INTO `onlineexam_questions` (`id`, `question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`, `created_at`)
SELECT 4, 4, 1, (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 15.00, 0.00, '1', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `id` = 4);

INSERT INTO `onlineexam_questions` (`id`, `question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`, `created_at`)
SELECT 5, 5, 1, (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 10.00, 0.00, '1', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `id` = 5);

INSERT INTO `onlineexam_questions` (`id`, `question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`, `created_at`)
SELECT 6, 6, 1, (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 15.00, 0.00, '1', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `id` = 6);

INSERT INTO `onlineexam_questions` (`id`, `question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`, `created_at`)
SELECT 7, 7, 1, (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 15.00, 0.00, '1', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `id` = 7);

INSERT INTO `onlineexam_questions` (`id`, `question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`, `created_at`)
SELECT 8, 8, 1, (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 5.00, 0.00, '1', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `id` = 8);

INSERT INTO `onlineexam_questions` (`id`, `question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`, `created_at`)
SELECT 9, 9, 1, (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 5.00, 0.00, '1', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `id` = 9);

INSERT INTO `onlineexam_questions` (`id`, `question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`, `created_at`)
SELECT 10, 10, 1, (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1), 5.00, 0.00, '1', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `id` = 10);

-- ============================================================
-- 15. Grant Teacher permissions for Teams Live Classes
-- ============================================================
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 2, 5011, 1, 0, 1, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 2 AND `perm_cat_id` = 5011);

INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 2, 5012, 1, 1, 0, 1, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 2 AND `perm_cat_id` = 5012);

INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 2, 5013, 1, 1, 0, 1, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 2 AND `perm_cat_id` = 5013);
