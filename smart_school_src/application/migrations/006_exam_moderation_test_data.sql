-- ============================================================
-- Migration 006: Test Data for Exam Moderation Workflow
-- Creates: Moderator user, Teacher user, Test exams
-- Password for all test users: test123
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- STEP 1: Apply the exam moderation permissions (from migration 005)
-- ============================================================

-- Permission category for exam_moderation
INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT 5030, 1, 'Exam Moderation', 'exam_moderation', 1, 0, 1, 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'exam_moderation');

-- Grant to Super Admin (role_id = 7)
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 7, 5030, 1, 0, 1, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 7 AND `perm_cat_id` = 5030);

-- Grant to Admin (role_id = 1)
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 1, 5030, 1, 0, 1, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 1 AND `perm_cat_id` = 5030);

-- Sidebar menu entry
DELIMITER //
DROP PROCEDURE IF EXISTS add_exam_moderation_sidebar//
CREATE PROCEDURE add_exam_moderation_sidebar()
BEGIN
    DECLARE v_sidebar_menu_id INT;
    SELECT sidebar_menu_id INTO v_sidebar_menu_id
    FROM `sidebar_sub_menus`
    WHERE activate_controller = 'onlineexam'
    AND menu = 'online_examination'
    LIMIT 1;

    IF v_sidebar_menu_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/onlineexam/moderation') THEN
            INSERT INTO `sidebar_sub_menus` (
                `sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`,
                `level`, `access_permissions`, `permission_group_id`,
                `activate_controller`, `activate_methods`, `addon_permission`,
                `is_active`, `created_at`
            ) VALUES (
                v_sidebar_menu_id, 'exam_moderation', NULL, 'exam_moderation', 'admin/onlineexam/moderation',
                15, '(''exam_moderation'', ''can_view'')', NULL,
                'onlineexam', 'moderation,moderation_review', '',
                1, NOW()
            );
        END IF;
    END IF;
END//
DELIMITER ;
CALL add_exam_moderation_sidebar();
DROP PROCEDURE IF EXISTS add_exam_moderation_sidebar;

-- ============================================================
-- STEP 2: Create Moderator Role (if not exists)
-- ============================================================
INSERT INTO `roles` (`id`, `name`, `slug`, `is_active`, `is_system`, `is_superadmin`, `created_at`)
SELECT 10, 'Exam Moderator', NULL, 'yes', 0, 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `roles` WHERE `id` = 10);

-- Grant exam_moderation permission to Moderator role
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 10, 5030, 1, 0, 1, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 10 AND `perm_cat_id` = 5030);

-- Grant online_examination view permission to Moderator
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 10, pc.id, 1, 0, 0, 0, NOW() FROM `permission_category` pc
WHERE pc.short_code = 'online_examination'
AND NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 10 AND `perm_cat_id` = pc.id);

-- ============================================================
-- STEP 3: Create Test Staff Members
-- Password: test123 (hashed)
-- ============================================================

-- Get current session
SET @current_session = (SELECT id FROM `sessions` WHERE is_active = 'yes' LIMIT 1);

-- Create Moderator Staff (simplified - only essential columns)
INSERT INTO `staff` (`employee_id`, `lang_id`, `department`, `designation`, `qualification`, `work_exp`, `name`, `surname`, `father_name`, `mother_name`, `contact_no`, `emergency_contact_no`, `email`, `dob`, `marital_status`, `date_of_joining`, `local_address`, `permanent_address`, `note`, `image`, `password`, `gender`, `account_title`, `bank_account_no`, `bank_name`, `ifsc_code`, `bank_branch`, `payscale`, `basic_salary`, `epf_no`, `contract_type`, `shift`, `location`, `facebook`, `twitter`, `linkedin`, `instagram`, `resume`, `joining_letter`, `resignation_letter`, `other_document_name`, `other_document_file`, `user_id`, `is_active`, `verification_code`)
SELECT 'MOD001', 1, 1, 1, 'Masters', '5 years', 'Michael', 'Moderator', 'John Moderator', 'Jane Moderator', '1234567890', '0987654321', 'moderator@test.com', '1985-01-15', 'Married', '2020-01-01', 'Test Address', 'Test Permanent Address', 'Test Moderator Account', '', '$2y$12$z4BvbvbLkTaz0jeSlADHBeObx61iaTBOlsww6ZhUcdEiELLVlG0oG', 'Male', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '', '', '', '', '', '', 1, ''
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `staff` WHERE `employee_id` = 'MOD001');

-- Get the moderator staff ID
SET @moderator_id = (SELECT id FROM `staff` WHERE `employee_id` = 'MOD001' LIMIT 1);

-- Assign Moderator role to staff
INSERT INTO `staff_roles` (`staff_id`, `role_id`, `is_active`, `created_at`)
SELECT @moderator_id, 10, 1, NOW() FROM DUAL
WHERE @moderator_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `staff_roles` WHERE `staff_id` = @moderator_id AND `role_id` = 10);

-- Create Teacher Staff (simplified - only essential columns)
INSERT INTO `staff` (`employee_id`, `lang_id`, `department`, `designation`, `qualification`, `work_exp`, `name`, `surname`, `father_name`, `mother_name`, `contact_no`, `emergency_contact_no`, `email`, `dob`, `marital_status`, `date_of_joining`, `local_address`, `permanent_address`, `note`, `image`, `password`, `gender`, `account_title`, `bank_account_no`, `bank_name`, `ifsc_code`, `bank_branch`, `payscale`, `basic_salary`, `epf_no`, `contract_type`, `shift`, `location`, `facebook`, `twitter`, `linkedin`, `instagram`, `resume`, `joining_letter`, `resignation_letter`, `other_document_name`, `other_document_file`, `user_id`, `is_active`, `verification_code`)
SELECT 'TCH001', 1, 1, 2, 'Bachelors', '3 years', 'Sarah', 'Teacher', 'Bob Teacher', 'Alice Teacher', '1234567891', '0987654322', 'teacher@test.com', '1990-05-20', 'Single', '2021-06-01', 'Teacher Address', 'Teacher Permanent Address', 'Test Teacher Account', '', '$2y$12$z4BvbvbLkTaz0jeSlADHBeObx61iaTBOlsww6ZhUcdEiELLVlG0oG', 'Female', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '', '', '', '', '', '', 1, ''
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `staff` WHERE `employee_id` = 'TCH001');

-- Get the teacher staff ID
SET @teacher_id = (SELECT id FROM `staff` WHERE `employee_id` = 'TCH001' LIMIT 1);

-- Assign Teacher role (role_id = 2) to staff
INSERT INTO `staff_roles` (`staff_id`, `role_id`, `is_active`, `created_at`)
SELECT @teacher_id, 2, 1, NOW() FROM DUAL
WHERE @teacher_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `staff_roles` WHERE `staff_id` = @teacher_id AND `role_id` = 2);

-- Grant Teacher permissions for online examination
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 2, pc.id, 1, 1, 1, 0, NOW() FROM `permission_category` pc
WHERE pc.short_code = 'online_examination'
AND NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 2 AND `perm_cat_id` = pc.id);

INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 2, pc.id, 1, 1, 1, 0, NOW() FROM `permission_category` pc
WHERE pc.short_code = 'add_questions_in_exam'
AND NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 2 AND `perm_cat_id` = pc.id);

-- ============================================================
-- STEP 4: Create Test Exams with Different Moderation Statuses
-- ============================================================

-- Get current session ID
SET @session_id = (SELECT `id` FROM `sessions` WHERE `is_active` = 'yes' LIMIT 1);
SET @session_id = IFNULL(@session_id, 1);

-- Exam 1: Draft status (needs to be submitted for moderation)
INSERT INTO `onlineexam` (`id`, `exam`, `description`, `attempt`, `exam_from`, `exam_to`, `duration`, `passing_percentage`, `publish_result`, `is_active`, `is_marks_display`, `is_neg_marking`, `is_random_question`, `is_quiz`, `session_id`, `auto_publish_date`, `publish_exam_notification`, `publish_result_notification`, `answer_word_count`, `moderation_status`, `accommodate_disabled`, `disabled_extra_time_percent`, `created_at`)
SELECT 9001, 'Mathematics Mid-Term Test (DRAFT)', 'This is a draft exam waiting to be submitted for moderation. Contains algebra and geometry questions.', 2, DATE_ADD(NOW(), INTERVAL 7 DAY), DATE_ADD(NOW(), INTERVAL 14 DAY), '01:00:00', 40, 0, 0, 1, 0, 0, 0, @session_id, NULL, 0, 0, -1, 'draft', 'no', 25, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam` WHERE `id` = 9001);

-- Exam 2: Pending moderation status (waiting for moderator review)
INSERT INTO `onlineexam` (`id`, `exam`, `description`, `attempt`, `exam_from`, `exam_to`, `duration`, `passing_percentage`, `publish_result`, `is_active`, `is_marks_display`, `is_neg_marking`, `is_random_question`, `is_quiz`, `session_id`, `auto_publish_date`, `publish_exam_notification`, `publish_result_notification`, `answer_word_count`, `moderation_status`, `accommodate_disabled`, `disabled_extra_time_percent`, `created_at`)
SELECT 9002, 'Science Quiz (PENDING MODERATION)', 'This exam is pending moderation review. Contains physics and chemistry questions.', 1, DATE_ADD(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 12 DAY), '00:45:00', 50, 0, 0, 1, 1, 1, 1, @session_id, NULL, 0, 0, -1, 'pending_moderation', 'no', 25, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam` WHERE `id` = 9002);

-- Exam 3: Approved status (can be published)
INSERT INTO `onlineexam` (`id`, `exam`, `description`, `attempt`, `exam_from`, `exam_to`, `duration`, `passing_percentage`, `publish_result`, `is_active`, `is_marks_display`, `is_neg_marking`, `is_random_question`, `is_quiz`, `session_id`, `auto_publish_date`, `publish_exam_notification`, `publish_result_notification`, `answer_word_count`, `moderation_status`, `accommodate_disabled`, `disabled_extra_time_percent`, `created_at`)
SELECT 9003, 'English Literature Final (APPROVED)', 'This exam has been approved by the moderator. It can now be published to students.', 3, DATE_ADD(NOW(), INTERVAL 3 DAY), DATE_ADD(NOW(), INTERVAL 10 DAY), '02:00:00', 35, 0, 0, 1, 0, 1, 0, @session_id, NULL, 0, 0, 500, 'approved', 'yes', 25, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam` WHERE `id` = 9003);

-- Exam 4: Rejected status (needs revision)
INSERT INTO `onlineexam` (`id`, `exam`, `description`, `attempt`, `exam_from`, `exam_to`, `duration`, `passing_percentage`, `publish_result`, `is_active`, `is_marks_display`, `is_neg_marking`, `is_random_question`, `is_quiz`, `session_id`, `auto_publish_date`, `publish_exam_notification`, `publish_result_notification`, `answer_word_count`, `moderation_status`, `accommodate_disabled`, `disabled_extra_time_percent`, `created_at`)
SELECT 9004, 'History Assessment (REJECTED)', 'This exam was rejected by the moderator. Teacher needs to review feedback and resubmit.', 2, DATE_ADD(NOW(), INTERVAL 8 DAY), DATE_ADD(NOW(), INTERVAL 15 DAY), '01:30:00', 45, 0, 0, 1, 0, 0, 0, @session_id, NULL, 0, 0, -1, 'rejected', 'no', 25, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam` WHERE `id` = 9004);

-- ============================================================
-- STEP 5: Add Sample Questions to Test Exams
-- ============================================================

-- Get a subject ID (or create one if needed)
SET @subject_id = (SELECT `id` FROM `subjects` LIMIT 1);
SET @subject_id = IFNULL(@subject_id, 1);

-- Get a class ID
SET @class_id = (SELECT `id` FROM `classes` LIMIT 1);
SET @class_id = IFNULL(@class_id, 1);

-- Get a section ID
SET @section_id = (SELECT `section_id` FROM `class_sections` WHERE `class_id` = @class_id LIMIT 1);
SET @section_id = IFNULL(@section_id, 1);

-- Sample Questions for test exams
INSERT INTO `questions` (`id`, `staff_id`, `class_id`, `section_id`, `subject_id`, `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `question_type`, `level`, `created_at`)
SELECT 9001, @teacher_id, @class_id, @section_id, @subject_id, 'What is 2 + 2?', '3', '4', '5', '6', NULL, 'opt_b', NULL, 'singlechoice', 'low', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 9001);

INSERT INTO `questions` (`id`, `staff_id`, `class_id`, `section_id`, `subject_id`, `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `question_type`, `level`, `created_at`)
SELECT 9002, @teacher_id, @class_id, @section_id, @subject_id, 'What is the capital of France?', 'London', 'Berlin', 'Paris', 'Madrid', NULL, 'opt_c', NULL, 'singlechoice', 'low', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 9002);

INSERT INTO `questions` (`id`, `staff_id`, `class_id`, `section_id`, `subject_id`, `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `question_type`, `level`, `created_at`)
SELECT 9003, @teacher_id, @class_id, @section_id, @subject_id, 'Is water H2O?', NULL, NULL, NULL, NULL, NULL, 'true', NULL, 'true_false', 'low', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 9003);

INSERT INTO `questions` (`id`, `staff_id`, `class_id`, `section_id`, `subject_id`, `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`, `question_type`, `level`, `created_at`)
SELECT 9004, @teacher_id, @class_id, @section_id, @subject_id, 'Explain the causes of World War I.', NULL, NULL, NULL, NULL, NULL, NULL, 500, 'descriptive', 'medium', NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `questions` WHERE `id` = 9004);

-- Link questions to exams
INSERT INTO `onlineexam_questions` (`onlineexam_id`, `question_id`, `marks`, `neg_marks`)
SELECT 9001, 9001, 5, 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `onlineexam_id` = 9001 AND `question_id` = 9001);
INSERT INTO `onlineexam_questions` (`onlineexam_id`, `question_id`, `marks`, `neg_marks`)
SELECT 9001, 9002, 5, 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `onlineexam_id` = 9001 AND `question_id` = 9002);

INSERT INTO `onlineexam_questions` (`onlineexam_id`, `question_id`, `marks`, `neg_marks`)
SELECT 9002, 9001, 10, 2 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `onlineexam_id` = 9002 AND `question_id` = 9001);
INSERT INTO `onlineexam_questions` (`onlineexam_id`, `question_id`, `marks`, `neg_marks`)
SELECT 9002, 9003, 10, 2 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `onlineexam_id` = 9002 AND `question_id` = 9003);

INSERT INTO `onlineexam_questions` (`onlineexam_id`, `question_id`, `marks`, `neg_marks`)
SELECT 9003, 9002, 10, 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `onlineexam_id` = 9003 AND `question_id` = 9002);
INSERT INTO `onlineexam_questions` (`onlineexam_id`, `question_id`, `marks`, `neg_marks`)
SELECT 9003, 9004, 20, 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `onlineexam_id` = 9003 AND `question_id` = 9004);

INSERT INTO `onlineexam_questions` (`onlineexam_id`, `question_id`, `marks`, `neg_marks`)
SELECT 9004, 9001, 5, 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `onlineexam_id` = 9004 AND `question_id` = 9001);
INSERT INTO `onlineexam_questions` (`onlineexam_id`, `question_id`, `marks`, `neg_marks`)
SELECT 9004, 9004, 15, 0 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `onlineexam_questions` WHERE `onlineexam_id` = 9004 AND `question_id` = 9004);

-- ============================================================
-- STEP 6: Add Sample Moderation Comments (for rejected exam)
-- ============================================================

INSERT INTO `exam_moderation_comments` (`exam_id`, `moderator_staff_id`, `question_id`, `comment`, `action`, `created_at`)
SELECT 9004, @moderator_id, NULL, 'The exam needs more clarity in the instructions. Please revise the description to include specific guidelines for students.', 'reject', DATE_SUB(NOW(), INTERVAL 2 DAY)
FROM DUAL WHERE @moderator_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `exam_moderation_comments` WHERE `exam_id` = 9004 AND `action` = 'reject');

INSERT INTO `exam_moderation_comments` (`exam_id`, `moderator_staff_id`, `question_id`, `comment`, `action`, `created_at`)
SELECT 9004, @moderator_id, 9001, 'This question is too easy for the assessment level. Consider replacing it with a more challenging question.', 'comment', DATE_SUB(NOW(), INTERVAL 2 DAY)
FROM DUAL WHERE @moderator_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `exam_moderation_comments` WHERE `exam_id` = 9004 AND `question_id` = 9001);

INSERT INTO `exam_moderation_comments` (`exam_id`, `moderator_staff_id`, `question_id`, `comment`, `action`, `created_at`)
SELECT 9004, @moderator_id, 9004, 'Good descriptive question! However, please increase the word limit to allow for more comprehensive answers.', 'comment', DATE_SUB(NOW(), INTERVAL 2 DAY)
FROM DUAL WHERE @moderator_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `exam_moderation_comments` WHERE `exam_id` = 9004 AND `question_id` = 9004);

-- Add approval comment for approved exam
INSERT INTO `exam_moderation_comments` (`exam_id`, `moderator_staff_id`, `question_id`, `comment`, `action`, `created_at`)
SELECT 9003, @moderator_id, NULL, 'Excellent exam structure! Questions are well-balanced and appropriate for the level. Approved for publication.', 'approve', DATE_SUB(NOW(), INTERVAL 1 DAY)
FROM DUAL WHERE @moderator_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM `exam_moderation_comments` WHERE `exam_id` = 9003 AND `action` = 'approve');

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- TEST CREDENTIALS SUMMARY:
-- ============================================================
--
-- MODERATOR:
--   Username: moderator@test.com (or employee ID: MOD001)
--   Password: test123
--   Role: Exam Moderator
--   Can: View moderation queue, approve/reject exams, add comments
--
-- TEACHER:
--   Username: teacher@test.com (or employee ID: TCH001)
--   Password: test123
--   Role: Teacher
--   Can: Create exams, submit for moderation, view feedback
--
-- ADMIN:
--   Use existing admin credentials
--   Has full access to exam moderation
--
-- TEST EXAMS:
--   1. Mathematics Mid-Term Test - DRAFT (needs submission)
--   2. Science Quiz - PENDING MODERATION (waiting for review)
--   3. English Literature Final - APPROVED (can be published)
--   4. History Assessment - REJECTED (has feedback, needs revision)
-- ============================================================
