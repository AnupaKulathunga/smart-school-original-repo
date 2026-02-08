-- Online Course Plugin v4.0 — TVET Integration
-- Migration 032
-- Creates 27 tables (replacing online_course_class_sections with online_course_academic_class)
-- Adds permissions, menus, seed data, notification settings

-- ============================================================
-- 1. CORE TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS `aws_s3_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `api_key` varchar(250) DEFAULT NULL,
  `api_secret` varchar(250) DEFAULT NULL,
  `bucket_name` varchar(250) DEFAULT NULL,
  `region` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `course_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `is_active` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `captcha` (`id`, `name`, `status`, `created_at`) VALUES
(6, 'guest_login_signup', 0, '2022-12-07 07:11:31')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

CREATE TABLE IF NOT EXISTS `course_lesson_quiz_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) DEFAULT NULL,
  `course_section_id` int(11) DEFAULT NULL,
  `lesson_quiz_id` int(11) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `section_id` (`course_section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `course_progress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `guest_id` int(1) DEFAULT NULL,
  `course_id` int(11) DEFAULT NULL,
  `course_section_id` int(11) DEFAULT NULL,
  `lesson_quiz_id` int(11) DEFAULT NULL,
  `lesson_quiz_type` int(11) DEFAULT NULL COMMENT '1 lesson, 2 quiz, 3 assignment, 4 exam',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `student_id` (`student_id`),
  KEY `course_section_id` (`course_section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `course_quiz_answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `guest_id` int(11) DEFAULT NULL,
  `course_quiz_id` int(11) DEFAULT NULL,
  `course_quiz_question_id` int(11) DEFAULT NULL,
  `answer` varchar(255) DEFAULT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `quiz_id` (`course_quiz_id`),
  KEY `question_id` (`course_quiz_question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `course_quiz_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_quiz_id` int(11) DEFAULT NULL,
  `question` text,
  `option_1` varchar(255) DEFAULT NULL,
  `option_2` varchar(255) DEFAULT NULL,
  `option_3` varchar(255) DEFAULT NULL,
  `option_4` varchar(255) DEFAULT NULL,
  `option_5` varchar(255) DEFAULT NULL,
  `correct_answer` varchar(255) DEFAULT NULL,
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `course_quiz_id` (`course_quiz_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `course_rating` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `guest_id` int(11) DEFAULT NULL,
  `course_id` int(11) NOT NULL,
  `rating` varchar(200) NOT NULL,
  `review` text NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `guest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guest_name` varchar(200) NOT NULL,
  `guest_unique_id` varchar(200) NOT NULL,
  `lang_id` int(11) NOT NULL,
  `currency_id` int(11) NOT NULL,
  `email` varchar(200) NOT NULL,
  `mobileno` varchar(100) NOT NULL,
  `password` varchar(200) NOT NULL,
  `dob` varchar(200) NOT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `note` text NOT NULL,
  `address` varchar(200) NOT NULL,
  `guest_image` varchar(200) NOT NULL,
  `verification_code` varchar(200) NOT NULL,
  `created_at` date NOT NULL,
  `is_active` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `idx_lang_id` (`lang_id`),
  KEY `idx_currency_id` (`currency_id`),
  KEY `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================
-- 2. MAIN COURSE TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS `online_courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `slug` varchar(200) NOT NULL,
  `url` varchar(200) NOT NULL,
  `description` text,
  `teacher_id` int(11) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `outcomes` text,
  `course_thumbnail` varchar(100) DEFAULT NULL,
  `course_provider` varchar(100) DEFAULT NULL,
  `course_url` varchar(255) DEFAULT NULL,
  `video_id` text,
  `price` float(10,2) NOT NULL DEFAULT '0.00',
  `discount` float(10,2) NOT NULL DEFAULT '0.00',
  `free_course` tinyint(1) DEFAULT NULL COMMENT '0=paid,1=free',
  `view_count` int(11) DEFAULT NULL,
  `front_side_visibility` varchar(10) NOT NULL DEFAULT 'yes',
  `status` tinyint(1) DEFAULT '0',
  `created_by` int(11) DEFAULT NULL,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`),
  KEY `created_by` (`created_by`),
  KEY `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- TVET REPLACEMENT: online_course_academic_class replaces online_course_class_sections
-- Links courses to academic_class (subject+level+cohort+year) instead of class_sections
CREATE TABLE IF NOT EXISTS `online_course_academic_class` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) DEFAULT NULL,
  `academic_class_id` int(11) DEFAULT NULL,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `academic_class_id` (`academic_class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_section` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `online_course_id` int(11) DEFAULT NULL,
  `section_title` varchar(255) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `online_course_id` (`online_course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_lesson` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_section_id` int(11) DEFAULT NULL,
  `lesson_title` varchar(255) DEFAULT NULL,
  `lesson_type` varchar(20) DEFAULT NULL,
  `thumbnail` varchar(100) DEFAULT NULL,
  `summary` text,
  `attachment` varchar(200) DEFAULT NULL,
  `video_provider` varchar(20) DEFAULT NULL,
  `video_url` text,
  `video_id` varchar(50) DEFAULT NULL,
  `duration` time DEFAULT NULL,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `course_section_id` (`course_section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_lesson_attachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lesson_id` int(11) NOT NULL,
  `attachment` text NOT NULL,
  `attachment_name` text NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `online_course_lesson_attachment_ibfk_1` (`lesson_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_quiz` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_section_id` int(11) DEFAULT NULL,
  `quiz_title` varchar(255) DEFAULT NULL,
  `quiz_instruction` text,
  `created_by` int(10) DEFAULT NULL,
  `created_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `course_section_id` (`course_section_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `student_quiz_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `guest_id` int(1) DEFAULT NULL,
  `course_quiz_id` int(11) DEFAULT NULL,
  `total_question` int(11) DEFAULT NULL,
  `correct_answer` int(11) DEFAULT NULL,
  `wrong_answer` int(11) DEFAULT NULL,
  `not_answer` int(11) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL COMMENT '1-completed,0-incomplete',
  `created_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `course_quiz_id` (`course_quiz_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================
-- 3. PAYMENT TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS `online_course_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `guest_id` int(11) DEFAULT NULL,
  `online_courses_id` int(11) DEFAULT NULL,
  `course_name` varchar(255) DEFAULT NULL,
  `actual_price` float(10,2) NOT NULL DEFAULT '0.00',
  `paid_amount` float(10,2) NOT NULL DEFAULT '0.00',
  `payment_mode` varchar(50) DEFAULT NULL,
  `payment_type` varchar(100) DEFAULT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `note` text,
  `date` datetime DEFAULT NULL,
  `processing_charge_type` varchar(255) DEFAULT NULL,
  `processing_charge_amount` float(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `idx_online_courses_id` (`online_courses_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_processing_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `guest_id` int(11) DEFAULT NULL,
  `online_courses_id` int(11) DEFAULT NULL,
  `course_name` varchar(255) DEFAULT NULL,
  `actual_price` float(10,2) NOT NULL DEFAULT '0.00',
  `paid_amount` float(10,2) NOT NULL DEFAULT '0.00',
  `payment_mode` varchar(50) DEFAULT NULL,
  `payment_type` varchar(100) DEFAULT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `note` text,
  `date` datetime DEFAULT NULL,
  `gateway_ins_id` int(11) DEFAULT NULL,
  `processing_charge_type` varchar(255) DEFAULT NULL,
  `processing_charge_amount` float(10,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `online_courses_id` (`online_courses_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================
-- 4. SETTINGS TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS `online_course_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guest_prefix` varchar(50) NOT NULL,
  `guest_id_start_from` int(11) NOT NULL,
  `guest_login` int(11) DEFAULT '0',
  `course_curriculum_settings` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `online_course_settings` (`id`, `guest_prefix`, `guest_id_start_from`, `guest_login`, `course_curriculum_settings`) VALUES
(1, 'Guest', 1, 0, '[\"online_course_quiz\",\"online_course_exam\",\"online_course_assignment\"]')
ON DUPLICATE KEY UPDATE `id`=`id`;

-- ============================================================
-- 5. ASSIGNMENT TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS `online_course_assignment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_section_id` int(11) NOT NULL,
  `assignment_title` varchar(255) DEFAULT NULL,
  `assignment_date` date DEFAULT NULL,
  `submit_date` date DEFAULT NULL,
  `evaluation_date` date DEFAULT NULL,
  `marks` float(10,2) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `document` varchar(255) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `evaluated_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_assignment_evaluation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assignment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `guest_id` int(11) NOT NULL,
  `marks` float(10,2) DEFAULT NULL,
  `note` varchar(255) NOT NULL,
  `date` date NOT NULL COMMENT 'evaluation date',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `online_course_assignment_evaluation_ibfk_1` (`assignment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_assignment_submit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assignment_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `guest_id` int(11) NOT NULL,
  `message` text DEFAULT NULL,
  `docs` varchar(225) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `online_course_assignment_submit_ibfk_1` (`assignment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================
-- 6. EXAM TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS `online_course_exam` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) DEFAULT NULL,
  `course_section_id` int(11) DEFAULT NULL,
  `exam` text DEFAULT NULL,
  `attempt` int(11) NOT NULL,
  `exam_from` datetime DEFAULT NULL,
  `exam_to` datetime DEFAULT NULL,
  `is_quiz` int(11) NOT NULL DEFAULT 0,
  `auto_publish_date` datetime DEFAULT NULL,
  `time_from` time DEFAULT NULL,
  `time_to` time DEFAULT NULL,
  `duration` time NOT NULL,
  `passing_percentage` float NOT NULL DEFAULT 0,
  `description` text DEFAULT NULL,
  `publish_result` int(11) NOT NULL DEFAULT 0,
  `answer_word_count` int(11) NOT NULL DEFAULT -1,
  `is_active` varchar(1) DEFAULT '0',
  `is_marks_display` int(11) NOT NULL DEFAULT 0,
  `is_neg_marking` int(11) NOT NULL DEFAULT 0,
  `is_random_question` int(11) NOT NULL DEFAULT 0,
  `is_rank_generated` int(11) NOT NULL DEFAULT 0,
  `publish_exam_notification` int(11) NOT NULL,
  `publish_result_notification` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `online_course_exam_ibfk_1` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_exam_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `guest_id` int(11) NOT NULL,
  `exam_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `online_course_exam_attempts_ibfk_1` (`exam_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_exam_marks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) DEFAULT NULL,
  `online_course_exam_id` int(11) DEFAULT NULL,
  `marks` float(10,2) NOT NULL DEFAULT 0.00,
  `neg_marks` float(10,2) NOT NULL DEFAULT 0.00,
  `is_active` varchar(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `online_course_exam_marks_ibfk_1` (`online_course_exam_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_exam_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) NOT NULL,
  `question_type` varchar(100) NOT NULL,
  `level` varchar(10) NOT NULL,
  `question` text NOT NULL,
  `opt_a` text NOT NULL,
  `opt_b` text NOT NULL,
  `opt_c` text NOT NULL,
  `opt_d` text NOT NULL,
  `opt_e` text NOT NULL,
  `correct` text NOT NULL,
  `descriptive_word_limit` int(11) NOT NULL,
  `question_tag` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `online_course_exam_question_ibfk_1` (`question_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_exam_result` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `guest_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `select_option` longtext DEFAULT NULL,
  `marks` float(10,2) NOT NULL,
  `remark` text DEFAULT NULL,
  `attachment_name` text DEFAULT NULL,
  `attachment_upload_name` varchar(250) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `online_course_exam_result_ibfk_1` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `online_course_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ============================================================
-- 7. FOREIGN KEY CONSTRAINTS
-- ============================================================

-- course_lesson_quiz_order -> online_course_section
ALTER TABLE `course_lesson_quiz_order`
  ADD CONSTRAINT `course_lesson_quiz_order_ibfk_1` FOREIGN KEY (`course_section_id`) REFERENCES `online_course_section` (`id`);

-- course_progress constraints
ALTER TABLE `course_progress`
  ADD CONSTRAINT `course_progress_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `online_courses` (`id`) ON DELETE CASCADE;
ALTER TABLE `course_progress`
  ADD CONSTRAINT `course_progress_ibfk_3` FOREIGN KEY (`course_section_id`) REFERENCES `online_course_section` (`id`) ON DELETE CASCADE;

-- course_quiz_answer constraints
ALTER TABLE `course_quiz_answer`
  ADD CONSTRAINT `course_quiz_answer_ibfk_2` FOREIGN KEY (`course_quiz_id`) REFERENCES `online_course_quiz` (`id`) ON DELETE CASCADE;
ALTER TABLE `course_quiz_answer`
  ADD CONSTRAINT `course_quiz_answer_ibfk_3` FOREIGN KEY (`course_quiz_question_id`) REFERENCES `course_quiz_question` (`id`) ON DELETE CASCADE;

-- course_quiz_question -> online_course_quiz
ALTER TABLE `course_quiz_question`
  ADD CONSTRAINT `course_quiz_question_ibfk_1` FOREIGN KEY (`course_quiz_id`) REFERENCES `online_course_quiz` (`id`);

-- online_course_academic_class constraints (TVET replacement)
ALTER TABLE `online_course_academic_class`
  ADD CONSTRAINT `online_course_academic_class_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `online_courses` (`id`) ON DELETE CASCADE;
ALTER TABLE `online_course_academic_class`
  ADD CONSTRAINT `online_course_academic_class_ibfk_2` FOREIGN KEY (`academic_class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE;

-- online_course_lesson -> online_course_section
ALTER TABLE `online_course_lesson`
  ADD CONSTRAINT `online_course_lesson_ibfk_1` FOREIGN KEY (`course_section_id`) REFERENCES `online_course_section` (`id`);

-- online_course_lesson_attachment -> online_course_lesson
ALTER TABLE `online_course_lesson_attachment`
  ADD CONSTRAINT `online_course_lesson_attachment_ibfk_1` FOREIGN KEY (`lesson_id`) REFERENCES `online_course_lesson` (`id`) ON DELETE CASCADE;

-- online_course_quiz constraints
ALTER TABLE `online_course_quiz`
  ADD CONSTRAINT `online_course_quiz_ibfk_1` FOREIGN KEY (`course_section_id`) REFERENCES `online_course_section` (`id`);

-- online_course_section -> online_courses
ALTER TABLE `online_course_section`
  ADD CONSTRAINT `online_course_section_ibfk_1` FOREIGN KEY (`online_course_id`) REFERENCES `online_courses` (`id`);

-- online_course_exam -> online_courses
ALTER TABLE `online_course_exam`
  ADD CONSTRAINT `online_course_exam_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `online_courses` (`id`) ON DELETE CASCADE;

-- exam related constraints
ALTER TABLE `online_course_exam_attempts`
  ADD CONSTRAINT `online_course_exam_attempts_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `online_course_exam` (`id`) ON DELETE CASCADE;

ALTER TABLE `online_course_exam_marks`
  ADD CONSTRAINT `online_course_exam_marks_ibfk_1` FOREIGN KEY (`online_course_exam_id`) REFERENCES `online_course_exam` (`id`) ON DELETE CASCADE;

ALTER TABLE `online_course_exam_question`
  ADD CONSTRAINT `online_course_exam_question_ibfk_1` FOREIGN KEY (`question_tag`) REFERENCES `online_course_tag` (`id`) ON DELETE CASCADE;

-- assignment constraints
ALTER TABLE `online_course_assignment_evaluation`
  ADD CONSTRAINT `online_course_assignment_evaluation_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `online_course_assignment` (`id`) ON DELETE CASCADE;

ALTER TABLE `online_course_assignment_submit`
  ADD CONSTRAINT `online_course_assignment_submit_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `online_course_assignment` (`id`) ON DELETE CASCADE;

-- student_quiz_status constraints
ALTER TABLE `student_quiz_status`
  ADD CONSTRAINT `student_quiz_status_ibfk_2` FOREIGN KEY (`course_quiz_id`) REFERENCES `online_course_quiz` (`id`) ON DELETE CASCADE;

-- ============================================================
-- 8. PERMISSIONS
-- ============================================================

INSERT INTO `permission_group` (`id`, `name`, `short_code`, `is_active`, `system`, `created_at`) VALUES
(700, 'Online Course', 'online_course', 1, 0, '2021-05-15 11:35:53')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

INSERT INTO `permission_student` (`id`, `name`, `short_code`, `system`, `student`, `parent`, `group_id`, `created_at`) VALUES
(700, 'Online Course', 'online_course', 0, 1, 1, 700, '2021-05-15 11:35:53')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`) VALUES
(7001, 700, 'Online Course', 'online_course', 1, 1, 1, 1, '2019-11-23 18:25:18'),
(7002, 700, 'Course Publish', 'course_publish', 1, 0, 0, 0, '2019-11-23 18:25:18'),
(7003, 700, 'Course Section', 'online_course_section', 1, 1, 1, 1, '2021-05-17 05:26:33'),
(7004, 700, 'Course Lesson', 'online_course_lesson', 1, 1, 1, 1, '2021-05-17 05:26:24'),
(7005, 700, 'Course Quiz', 'online_course_quiz', 1, 1, 1, 1, '2021-05-17 05:26:20'),
(7006, 700, 'Offline Payment', 'online_course_offline_payment', 1, 1, 0, 0, '2021-05-17 05:26:17'),
(7007, 700, 'Student Course Purchase Report', 'student_course_purchase_report', 1, 0, 0, 0, '2021-05-17 05:25:56'),
(7008, 700, 'Course Sell Count Report', 'course_sell_count_report', 1, 0, 0, 0, '2021-05-17 05:25:52'),
(7009, 700, 'Course Trending Report', 'course_trending_report', 1, 0, 0, 0, '2021-05-17 05:25:49'),
(7010, 700, 'Course Complete Report', 'course_complete_report', 1, 0, 0, 0, '2021-05-17 05:25:42'),
(7011, 700, 'Setting', 'online_course_setting', 1, 0, 0, 0, '2021-05-17 05:25:37'),
(7012, 700, 'Course Rating Report', 'course_rating_report', 1, 0, 0, 1, '2022-06-14 11:24:57'),
(7013, 700, 'Guest Report', 'guest_report', 1, 0, 1, 1, '2022-06-14 11:33:09'),
(7014, 700, 'Course Category', 'course_category', 1, 1, 1, 1, '2019-11-23 18:25:18'),
(7015, 700, 'Question Bank', 'online_course_question_bank', 1, 1, 1, 1, '2024-12-24 06:47:52'),
(7016, 700, 'Question Tag', 'online_course_question_tag', 1, 1, 1, 1, '2024-12-24 06:47:59'),
(7017, 700, 'Course Exam', 'online_course_exam', 1, 1, 1, 1, '2021-05-17 05:26:24'),
(7018, 700, 'Course Assignment', 'online_course_assignment', 1, 1, 1, 1, '2021-05-17 05:26:33'),
(7019, 700, 'Course Add Questions in Exam', 'online_course_add_questions_in_exam', 1, 0, 1, 1, '2024-12-25 11:48:07'),
(7020, 700, 'Course Evaluate Assignment', 'online_course_evalute_assignment', 1, 1, 0, 0, '2024-12-25 10:16:20'),
(7021, 700, 'Course Assignment Report', 'course_assignment_report', 1, 0, 0, 0, '2025-01-06 11:16:36'),
(7022, 700, 'Course Exam Result Report', 'course_exam_result_report', 1, 0, 0, 0, '2025-01-06 11:16:33'),
(7023, 700, 'Course Exam Report', 'course_exam_report', 1, 0, 0, 0, '2025-01-06 11:16:27'),
(7024, 700, 'Course Exam Attempt Report', 'course_exam_attempt_report', 1, 0, 0, 0, '2025-01-06 11:16:24')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- Roles permissions for super admin (role_id=1)
INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`) VALUES
(null, 1, 7001, 1, 1, 1, 1, '2021-05-11 07:21:33'),
(null, 1, 7002, 1, 0, 0, 0, '2021-05-17 05:28:47'),
(null, 1, 7003, 1, 1, 1, 1, '2021-05-11 08:29:37'),
(null, 1, 7004, 1, 1, 1, 1, '2021-05-11 10:00:50'),
(null, 1, 7005, 1, 1, 1, 1, '2021-05-17 05:28:47'),
(null, 1, 7006, 1, 1, 0, 0, '2021-05-17 05:28:47'),
(null, 1, 7007, 1, 0, 0, 0, '2021-05-11 10:00:50'),
(null, 1, 7008, 1, 0, 0, 0, '2021-05-11 10:00:50'),
(null, 1, 7009, 1, 0, 0, 0, '2021-05-11 10:00:50'),
(null, 1, 7010, 1, 0, 0, 0, '2021-05-11 10:00:50'),
(null, 1, 7011, 1, 0, 0, 0, '2021-05-17 05:28:47'),
(null, 1, 7012, 1, 0, 0, 1, '2022-06-20 04:20:01'),
(null, 1, 7013, 1, 0, 1, 1, '2022-06-18 09:52:16'),
(null, 1, 7014, 1, 1, 1, 1, '2021-05-15 10:28:38'),
(null, 1, 7015, 1, 1, 1, 1, '2021-05-11 07:21:33'),
(null, 1, 7016, 1, 1, 1, 1, '2021-05-11 07:21:33'),
(null, 1, 7017, 1, 1, 1, 1, '2021-05-11 07:21:33'),
(null, 1, 7018, 1, 1, 1, 1, '2021-05-11 07:21:33'),
(null, 1, 7019, 1, 0, 0, 0, '2021-05-11 07:21:33'),
(null, 1, 7020, 1, 0, 0, 0, '2021-05-11 07:21:33'),
(null, 1, 7021, 1, 0, 0, 0, '2021-05-11 07:21:33'),
(null, 1, 7022, 1, 0, 0, 0, '2021-05-11 07:21:33'),
(null, 1, 7023, 1, 0, 0, 0, '2021-05-11 07:21:33'),
(null, 1, 7024, 1, 0, 0, 0, '2021-05-11 07:21:33')
ON DUPLICATE KEY UPDATE `can_view`=VALUES(`can_view`);

-- Teacher (role_id=2) permissions
INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`) VALUES
(null, 2, 7001, 1, 1, 1, 1, '2021-05-15 11:07:28'),
(null, 2, 7002, 1, 0, 0, 0, '2021-05-17 10:51:44'),
(null, 2, 7003, 1, 1, 1, 1, '2021-05-15 10:28:38'),
(null, 2, 7004, 1, 1, 1, 1, '2021-05-15 10:28:38'),
(null, 2, 7005, 1, 1, 1, 1, '2021-05-17 10:51:44'),
(null, 2, 7010, 1, 0, 0, 0, '2021-05-17 10:51:44'),
(null, 2, 7012, 1, 0, 0, 1, '2022-07-15 05:01:12'),
(null, 2, 7013, 1, 0, 0, 1, '2022-07-15 05:01:12'),
(null, 2, 7014, 1, 0, 0, 1, '2022-07-15 05:01:12')
ON DUPLICATE KEY UPDATE `can_view`=VALUES(`can_view`);

-- Accountant (role_id=3) permissions
INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`) VALUES
(null, 3, 7006, 1, 1, 0, 0, '2021-05-17 10:52:19'),
(null, 3, 7007, 1, 0, 0, 0, '2021-05-17 04:32:06'),
(null, 3, 7012, 1, 0, 0, 0, '2022-07-15 05:31:18'),
(null, 3, 7013, 1, 0, 0, 0, '2022-07-15 05:31:18'),
(null, 3, 7014, 1, 0, 0, 0, '2022-07-15 05:31:18')
ON DUPLICATE KEY UPDATE `can_view`=VALUES(`can_view`);

-- Librarian (role_id=4) permissions
INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`) VALUES
(null, 4, 7012, 1, 0, 0, 0, '2022-07-15 04:22:20'),
(null, 4, 7013, 1, 0, 1, 1, '2022-07-15 04:26:29'),
(null, 4, 7014, 1, 1, 1, 1, '2022-07-15 04:24:48')
ON DUPLICATE KEY UPDATE `can_view`=VALUES(`can_view`);

-- Receptionist (role_id=6) permissions
INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`) VALUES
(null, 6, 7014, 1, 1, 1, 1, '2022-06-18 09:09:15'),
(null, 6, 7013, 1, 0, 0, 0, '2022-06-18 09:13:07')
ON DUPLICATE KEY UPDATE `can_view`=VALUES(`can_view`);

-- ============================================================
-- 9. SIDEBAR MENUS
-- ============================================================

INSERT INTO `sidebar_menus` (`id`, `product_name`, `permission_group_id`, `icon`, `menu`, `activate_menu`, `lang_key`, `system_level`, `level`, `sidebar_display`, `access_permissions`, `is_active`, `created_at`) VALUES
(28, '', 700, 'fa fa-file-video-o ftlayer', 'Online Course', 'online_course', 'online_course', 0, 4, 1, '(''online_course'', ''can_view'') || (''online_course_offline_payment'', ''can_view'') || (''student_course_purchase_report'', ''can_view'') || (''course_sell_count_report'', ''can_view'') || (''online_course_setting'', ''can_view'') || (''course_category'', ''can_view'') || (''guest_report'', ''can_view'') || (''course_rating_report'', ''can_view'') || (''course_assignment_report'', ''can_view'') || (''course_exam_result_report'', ''can_view'') || (''course_exam_report'', ''can_view'') || (''course_exam_attempt_report'', ''can_view'') || (''online_course_question_bank'', ''can_view'')', 1, '2023-01-10 12:49:51')
ON DUPLICATE KEY UPDATE `menu`=VALUES(`menu`), `access_permissions`=VALUES(`access_permissions`), `is_active`=1;

INSERT INTO `sidebar_sub_menus` (`id`, `sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `addon_permission`, `is_active`, `created_at`) VALUES
(167, 28, 'online_course', NULL, 'online_course', 'onlinecourse/course/index', 1, '(''online_course'', ''can_view'')', NULL, 'course', 'index', NULL, 1, '2022-05-18 07:50:11'),
(168, 28, 'offline_payment', NULL, 'offline_payment', 'onlinecourse/offlinepayment/payment', 2, '(''online_course_offline_payment'', ''can_view'')', NULL, 'offlinepayment', 'payment', NULL, 1, '2022-12-04 10:26:40'),
(169, 28, 'course_category', NULL, 'course_category', 'onlinecourse/coursecategory/categoryadd', 3, '(''course_category'', ''can_view'') || (''course_category'', ''can_add'') || (''course_category'', ''can_edit'') || (''course_category'', ''can_delete'')', NULL, 'coursecategory', 'categoryadd,categoryedit', NULL, 1, '2023-01-02 09:23:54'),
(180, 28, 'online_course_report', NULL, 'online_course_report', 'onlinecourse/coursereport/report', 4, '(''student_course_purchase_report'', ''can_view'') || (''course_sell_count_report'', ''can_view'') || (''course_trending_report'', ''can_view'') || (''course_complete_report'', ''can_view'') || (''course_rating_report'', ''can_view'') || (''guest_report'', ''can_view'')', NULL, 'coursereport', 'report,coursepurchase,coursesellreport,trendingreport,completereport,courseratingreport,guestlist,quizperformance', NULL, 1, '2022-12-09 05:00:31'),
(197, 28, 'setting', NULL, 'setting', 'onlinecourse/course/setting', 5, '(''online_course_setting'', ''can_view'')', NULL, 'course', 'setting', '', 1, '2022-07-22 01:13:30'),
(222, 28, 'online_course_question_bank', NULL, 'online_course_question_bank', 'onlinecourse/courseexamquestion/index', 3, '(''online_course_question_bank'', ''can_view'') || (''online_course_question_bank'', ''can_add'') || (''online_course_question_bank'', ''can_edit'') || (''online_course_question_bank'', ''can_delete'')', NULL, 'courseexamquestion', 'index', NULL, 1, '2024-12-24 07:02:50')
ON DUPLICATE KEY UPDATE `menu`=VALUES(`menu`), `is_active`=VALUES(`is_active`), `addon_permission`=VALUES(`addon_permission`);

-- ============================================================
-- 10. NOTIFICATION SETTINGS (TVET: removed {{section}} references)
-- ============================================================

INSERT INTO `notification_setting` (`id`, `type`, `is_mail`, `is_sms`, `is_notification`, `display_notification`, `display_sms`, `is_student_recipient`, `is_guardian_recipient`, `is_staff_recipient`, `display_student_recipient`, `display_guardian_recipient`, `display_staff_recipient`, `subject`, `template_id`, `template`, `variables`, `created_at`) VALUES
(NULL, 'online_course_publish', '1', '1', 0, 1, 1, 1, NULL, NULL, 1, 1, NULL, 'Online Course Publish', '', 'Dear student, a new online course {{title}} and price {{price}} with discount {{discount}}% for {{class}} is {{paid_free}} now available and assign to {{assign_teacher}}.', '{{title}} {{class}} {{price}} {{discount}} {{paid_free}} {{assign_teacher}}', '2022-11-15 06:09:13'),
(NULL, 'online_course_purchase', '1', '1', 0, 1, 1, 1, NULL, NULL, 1, 1, NULL, 'Online Course Purchase', '', 'Thanks for purchasing course {{title}} amount {{price}} purchase date {{purchase_date}} class {{class}} and assign for {{assign_teacher}} discount {{discount}}%', '{{title}} {{class}} {{price}} {{discount}} {{purchase_date}}', '2022-11-19 10:09:29'),
(NULL, 'online_course_purchase_for_guest_user', '1', '1', 0, 0, 1, 1, NULL, NULL, 1, NULL, NULL, 'Online Course Purchase For Guest', '', 'Thanks for purchasing course {{title}} discount {{discount}} amount {{price}} purchase date {{purchase_date}}', '{{title}} {{price}} {{discount}} {{purchase_date}}', '2022-07-15 05:53:52'),
(NULL, 'online_course_guest_user_sign_up', '1', '0', 0, 0, 0, 1, NULL, NULL, 1, NULL, NULL, 'Online Course Guest User Sign Up', '', 'Dear {{guest_user_name}} you have successfully sign up with Email: {{email}} Url {{url}}', '{{guest_user_name}} {{email}} {{url}}', '2022-07-15 05:56:31')
ON DUPLICATE KEY UPDATE `template`=VALUES(`template`), `variables`=VALUES(`variables`);

-- ============================================================
-- 11. ADDON REGISTRATION (bypass license check)
-- ============================================================

INSERT INTO `addons` (`id`, `name`, `short_code`, `checksum`, `purchase_code`, `is_active`, `created_at`)
VALUES (NULL, 'Online Course', 'ssoclc', '', 'BYPASS-TVET', 1, NOW())
ON DUPLICATE KEY UPDATE `is_active`=1;
