-- Migration 018: Create stub tables needed by dashboard
-- These are minimal tables to prevent 500 errors on dashboard
-- For TVET-only system, these features may not be used but tables must exist

-- Enrolment table (simplified alias view for dashboard queries)
CREATE TABLE IF NOT EXISTS `enrolment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `session_id` int(11) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_session_status` (`session_id`, `status`),
  KEY `idx_student` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Student fee master
CREATE TABLE IF NOT EXISTS `student_fee_master` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `fee_groups_feetype_id` int(11) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT 0.00,
  `amount_detail` text,
  `date` date DEFAULT NULL,
  `is_system` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Student transport fee
CREATE TABLE IF NOT EXISTS `student_transport_fee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `fees` decimal(15,2) DEFAULT 0.00,
  `amount_detail` text,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Expenses
CREATE TABLE IF NOT EXISTS `expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exp_head_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT 0.00,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Expense head
CREATE TABLE IF NOT EXISTS `expense_head` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `exp_category` varchar(100) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'yes',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Student fees
CREATE TABLE IF NOT EXISTS `student_fees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) DEFAULT NULL,
  `fee_amount` decimal(15,2) DEFAULT 0.00,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Income
CREATE TABLE IF NOT EXISTS `income` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inc_head_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT 0.00,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Income head
CREATE TABLE IF NOT EXISTS `income_head` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `income_category` varchar(100) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'yes',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Enquiry
CREATE TABLE IF NOT EXISTS `enquiry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `description` text,
  `status` varchar(20) DEFAULT 'active',
  `date` date DEFAULT NULL,
  `follow_up_date` date DEFAULT NULL,
  `assigned` varchar(100) DEFAULT NULL,
  `source` varchar(50) DEFAULT NULL,
  `reference` varchar(100) DEFAULT NULL,
  `note` text,
  `class` int(11) DEFAULT NULL,
  `no_of_child` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Books (library)
CREATE TABLE IF NOT EXISTS `books` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_title` varchar(255) DEFAULT NULL,
  `book_no` varchar(100) DEFAULT NULL,
  `qty` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Book issues
CREATE TABLE IF NOT EXISTS `book_issues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `book_id` int(11) DEFAULT NULL,
  `member_id` int(11) DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `due_return_date` date DEFAULT NULL,
  `is_returned` int(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Student apply leave
CREATE TABLE IF NOT EXISTS `student_apply_leave` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `apply_date` date DEFAULT NULL,
  `status` int(1) DEFAULT 0,
  `approve_by` int(11) DEFAULT NULL,
  `request_type` int(1) DEFAULT 1,
  `reason` text,
  `docs` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Staff attendance
CREATE TABLE IF NOT EXISTS `staff_attendance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `staff_attendance_type_id` int(11) DEFAULT 1,
  `remark` text,
  `is_active` int(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Staff leave
CREATE TABLE IF NOT EXISTS `staff_leave_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staff_id` int(11) DEFAULT NULL,
  `leave_type_id` int(11) DEFAULT NULL,
  `leave_from` date DEFAULT NULL,
  `leave_to` date DEFAULT NULL,
  `leave_days` decimal(5,1) DEFAULT NULL,
  `apply_date` date DEFAULT NULL,
  `status` int(1) DEFAULT 0,
  `admin_remark` text,
  `employee_remark` text,
  `document_file` varchar(255) DEFAULT NULL,
  `request_type` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Fee groups feetype (needed by student_fee_master)
CREATE TABLE IF NOT EXISTS `fee_groups_feetype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fee_groups_id` int(11) DEFAULT NULL,
  `feetype_id` int(11) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT 0.00,
  `due_date` date DEFAULT NULL,
  `fine_type` varchar(50) DEFAULT NULL,
  `fine_percentage` decimal(5,2) DEFAULT 0.00,
  `fine_amount` decimal(15,2) DEFAULT 0.00,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Fee groups
CREATE TABLE IF NOT EXISTS `fee_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `is_system` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Fee types
CREATE TABLE IF NOT EXISTS `feetype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `is_system` tinyint(1) DEFAULT 0,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Print header footer
CREATE TABLE IF NOT EXISTS `print_headerfooter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `print_type` varchar(100) DEFAULT NULL,
  `header_image` varchar(255) DEFAULT NULL,
  `footer_content` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert default print header footer records
INSERT IGNORE INTO `print_headerfooter` (`id`, `print_type`, `header_image`, `footer_content`) VALUES
(1, 'student_receipt', NULL, NULL),
(2, 'staff_payslip', NULL, NULL),
(3, 'online_admission_receipt', NULL, NULL),
(4, 'online_exam', NULL, NULL),
(5, 'general_purpose', NULL, NULL);

-- Student attendences (needed by attendance model)
CREATE TABLE IF NOT EXISTS `student_attendences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_session_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `attendence_type_id` int(11) DEFAULT NULL,
  `remark` text,
  `is_active` varchar(10) DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Record this migration
INSERT IGNORE INTO `migrations` (`version`) VALUES (18);
