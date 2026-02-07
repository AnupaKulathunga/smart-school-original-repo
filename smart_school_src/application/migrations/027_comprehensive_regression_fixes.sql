-- ================================================================
-- Migration 027: Comprehensive Regression Fixes
--
-- Adds all missing tables and columns discovered during comprehensive
-- UI regression testing of 156 pages
-- ================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ================================================================
-- SECTION 1: VISITOR & FRONT OFFICE TABLES
-- ================================================================

CREATE TABLE IF NOT EXISTS `visitors_book` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source` varchar(100) DEFAULT NULL,
  `purpose` varchar(200) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `id_proof` varchar(100) DEFAULT NULL,
  `no_of_people` int(11) DEFAULT 1,
  `date` date DEFAULT NULL,
  `in_time` varchar(20) DEFAULT NULL,
  `out_time` varchar(20) DEFAULT NULL,
  `note` text,
  `image` varchar(200) DEFAULT NULL,
  `meeting_with` varchar(100) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL,
  `section_id` int(11) DEFAULT NULL,
  `student_session_id` int(11) DEFAULT NULL,
  `staff_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `complaint` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `complaint_type` varchar(100) DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` text,
  `action_taken` text,
  `assigned` varchar(100) DEFAULT NULL,
  `note` text,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ================================================================
-- SECTION 2: STAFF & HR TABLES
-- ================================================================

CREATE TABLE IF NOT EXISTS `staff_attendence_schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `day` varchar(20) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `staff_id_card` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `background_image` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `sign_image` varchar(255) DEFAULT NULL,
  `header_color` varchar(50) DEFAULT '#333333',
  `enable_horizontal` varchar(10) DEFAULT 'no',
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ================================================================
-- SECTION 3: EXAMINATION TABLES
-- ================================================================

CREATE TABLE IF NOT EXISTS `feecategory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(100) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `template_marksheets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template` varchar(100) DEFAULT NULL,
  `template_name` varchar(200) DEFAULT NULL,
  `enable_horizontal` varchar(10) DEFAULT 'no',
  `left_logo` varchar(255) DEFAULT NULL,
  `right_logo` varchar(255) DEFAULT NULL,
  `background_image` varchar(255) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `template_admitcards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `template` varchar(100) DEFAULT NULL,
  `heading` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `left_logo` varchar(255) DEFAULT NULL,
  `right_logo` varchar(255) DEFAULT NULL,
  `exam_name` varchar(255) DEFAULT NULL,
  `school_name` varchar(255) DEFAULT NULL,
  `sign` varchar(255) DEFAULT NULL,
  `background_img` varchar(255) DEFAULT NULL,
  `is_name` int(1) DEFAULT 1,
  `is_father_name` int(1) DEFAULT 1,
  `is_mother_name` int(1) DEFAULT 1,
  `is_dob` int(1) DEFAULT 1,
  `is_admission_no` int(1) DEFAULT 1,
  `is_roll_no` int(1) DEFAULT 1,
  `is_address` int(1) DEFAULT 1,
  `is_gender` int(1) DEFAULT 1,
  `is_photo` int(1) DEFAULT 1,
  `is_class` int(1) DEFAULT 1,
  `content` text,
  `enable_horizontal` varchar(10) DEFAULT 'no',
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `mark_divisions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `percentage_from` decimal(5,2) DEFAULT 0.00,
  `percentage_to` decimal(5,2) DEFAULT 0.00,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ================================================================
-- SECTION 4: ACADEMIC TABLES
-- ================================================================

CREATE TABLE IF NOT EXISTS `subject_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ================================================================
-- SECTION 5: HOSTEL TABLES
-- ================================================================

CREATE TABLE IF NOT EXISTS `room_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `room_type` varchar(100) DEFAULT NULL,
  `description` text,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `hostel_rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hostel_id` int(11) DEFAULT NULL,
  `room_type_id` int(11) DEFAULT NULL,
  `room_no` varchar(50) DEFAULT NULL,
  `no_of_bed` int(11) DEFAULT 0,
  `cost_per_bed` decimal(15,2) DEFAULT 0.00,
  `description` text,
  `title` varchar(200) DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ================================================================
-- SECTION 6: ONLINE EXAM TABLES
-- ================================================================

CREATE TABLE IF NOT EXISTS `onlineexam` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exam` varchar(200) DEFAULT NULL,
  `attempt` int(11) DEFAULT 1,
  `exam_from` datetime DEFAULT NULL,
  `exam_to` datetime DEFAULT NULL,
  `duration` varchar(20) DEFAULT NULL,
  `passing_percentage` decimal(5,2) DEFAULT 0.00,
  `description` text,
  `is_active` varchar(10) DEFAULT 'no',
  `is_publish` int(1) DEFAULT 0,
  `is_marks_display` int(1) DEFAULT 0,
  `is_neg_marking` int(1) DEFAULT 0,
  `is_random_question` int(1) DEFAULT 0,
  `publish_result` int(1) DEFAULT 0,
  `session_id` int(11) DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `onlineexam_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `onlineexam_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `question` text,
  `opt_a` text,
  `opt_b` text,
  `opt_c` text,
  `opt_d` text,
  `opt_e` text,
  `correct` varchar(10) DEFAULT NULL,
  `question_type` varchar(50) DEFAULT 'single',
  `marks` decimal(5,2) DEFAULT 1.00,
  `negative_marks` decimal(5,2) DEFAULT 0.00,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) DEFAULT NULL,
  `subject_id` int(11) DEFAULT NULL,
  `question_type` varchar(50) DEFAULT 'single',
  `level` varchar(50) DEFAULT 'medium',
  `question` text,
  `opt_a` text,
  `opt_b` text,
  `opt_c` text,
  `opt_d` text,
  `opt_e` text,
  `correct` varchar(10) DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ================================================================
-- SECTION 7: CERTIFICATE TABLES
-- ================================================================

CREATE TABLE IF NOT EXISTS `certificates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `certificate_name` varchar(200) DEFAULT NULL,
  `background_image` varchar(255) DEFAULT NULL,
  `header_left_text` text,
  `header_center_text` text,
  `header_right_text` text,
  `body_text` text,
  `footer_left_text` text,
  `footer_center_text` text,
  `footer_right_text` text,
  `student_photo` varchar(10) DEFAULT 'no',
  `enable_horizontal` varchar(10) DEFAULT 'no',
  `page_layout` varchar(50) DEFAULT 'standard',
  `created_for` varchar(50) DEFAULT 'student',
  `status` int(1) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ================================================================
-- SECTION 8: INVENTORY TABLES
-- ================================================================

CREATE TABLE IF NOT EXISTS `item_store` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_store_name` varchar(200) DEFAULT NULL,
  `item_store` varchar(200) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `description` text,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `item_supplier` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_supplier` varchar(200) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text,
  `contact_person_name` varchar(100) DEFAULT NULL,
  `contact_person_phone` varchar(20) DEFAULT NULL,
  `contact_person_email` varchar(100) DEFAULT NULL,
  `description` text,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_category_id` int(11) DEFAULT NULL,
  `item_supplier_id` int(11) DEFAULT NULL,
  `item_store_id` int(11) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `description` text,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `item_stock` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) DEFAULT NULL,
  `item_supplier_id` int(11) DEFAULT NULL,
  `item_store_id` int(11) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `quantity` decimal(10,2) DEFAULT 0.00,
  `purchase_price` decimal(15,2) DEFAULT 0.00,
  `date` date DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `description` text,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `item_issue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `issue_type` varchar(50) DEFAULT NULL,
  `issue_to` int(11) DEFAULT NULL,
  `issue_by` int(11) DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `item_category_id` int(11) DEFAULT NULL,
  `quantity` decimal(10,2) DEFAULT 0.00,
  `note` text,
  `status` int(1) DEFAULT 0,
  `is_returned` int(1) DEFAULT 0,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

SET FOREIGN_KEY_CHECKS = 1;

-- ================================================================
-- Record migration
-- ================================================================
INSERT INTO `migrations` (`migration`) VALUES ('027_comprehensive_regression_fixes')
ON DUPLICATE KEY UPDATE `migration` = '027_comprehensive_regression_fixes';
