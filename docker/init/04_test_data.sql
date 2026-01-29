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

-- NOTE: Exam questions require proper question bank setup
-- The onlineexam_questions table links to question_id from question_bank table

-- ============================================================
-- 13. Grant Teacher permissions for Teams Live Classes
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
