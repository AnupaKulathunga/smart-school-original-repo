-- Smart School DB
-- Version 7.1.0
-- https://smart-school.in
-- https://qdocs.net
-- New tables added: 15

SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE `student_applied_discounts` (
    `id` int primary key AUTO_INCREMENT,
  `student_fees_deposite_id` int DEFAULT NULL,
  `student_fees_discount_id` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `invoice_id` int DEFAULT NULL,
  `sub_invoice_id` int DEFAULT NULL,
   `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `student_work_experience` (
    `id` int primary key AUTO_INCREMENT,
  `institute` text NOT NULL,
  `designation` text NOT NULL,
  `year` varchar(255) NOT NULL,
  `location` text NOT NULL,
  `detail` text NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `staff_attendence_schedules` (
   `id` int primary key AUTO_INCREMENT,
  `staff_attendence_type_id` int DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `entry_time_from` time DEFAULT NULL,
  `entry_time_to` time DEFAULT NULL,
  `total_institute_hour` time DEFAULT '00:00:00',
  `is_active` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `student_attendence_schedules` (
     `id` int primary key AUTO_INCREMENT,
  `attendence_type_id` int DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `entry_time_from` time DEFAULT NULL,
  `entry_time_to` time DEFAULT NULL,
  `total_institute_hour` time DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `student_educational_details` (
 `id` int primary key AUTO_INCREMENT,
  `course` varchar(255) NOT NULL,
  `university` varchar(255) NOT NULL,
  `education_year` varchar(255) NOT NULL,
  `education_detail` varchar(255) NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `annual_calendar` (
  `id` int primary key AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `holiday_type` int NOT NULL,
  `from_date` datetime DEFAULT NULL,
  `to_date` datetime DEFAULT NULL,
  `description` text NOT NULL,
  `is_active` int NOT NULL DEFAULT '1',
  `holiday_color` varchar(200) NOT NULL,
  `front_site` int NOT NULL DEFAULT '0',
  `created_by` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `addons` (
  `id` int primary key AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `image` text NOT NULL,
  `name` varchar(500) DEFAULT NULL,
  `config_name` varchar(200) NOT NULL DEFAULT '',
  `short_name` varchar(100) NOT NULL,
  `directory` varchar(500) NOT NULL,
  `description` text,
  `price` float(10,2) NOT NULL DEFAULT '0.00',
  `current_version` varchar(50) DEFAULT NULL,
  `article_link` text NOT NULL,
  `installation_by` int DEFAULT NULL,
  `uninstall_version` varchar(50) DEFAULT NULL,
  `unistall_by` int DEFAULT NULL,
  `addon_prod` text,
  `addon_ver` text,
  `last_update` datetime DEFAULT NULL,
  `current_stage` int NOT NULL DEFAULT '0' COMMENT '0 for buy addon,1 for folder available ready to install,2 for folder addon installed',
  `product_order` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `addons` (`id`, `product_id`, `image`, `name`, `config_name`, `short_name`, `directory`, `description`, `price`, `current_version`, `article_link`, `installation_by`, `uninstall_version`, `unistall_by`, `addon_prod`, `addon_ver`, `last_update`, `current_stage`, `product_order`, `created_at`, `updated_at`) VALUES
(1, 47443722, 'uploads/addon_images/sscbse_images.jpg', 'Smart School CBSE Examination', 'cbse-config', 'sscbse', 'cbse_examination', 'CBSE Examination addon adds CBSE Examination module in Smart School. Using this module teacher/staff can create and print marksheets with advance features.', 0.00, NULL, 'https://go.smart-school.in/cbse-exam', NULL, NULL, NULL, NULL, NULL, '2024-09-03 16:04:58', 0, 4, '2024-09-03 16:04:58', '2025-03-03 05:32:37'),
(2, 44278049, 'uploads/addon_images/sstfa_images.jpg', 'Smart School Two Factor Authentication', 'google-authenticate-config', 'sstfa', 'two_factor_authentication', 'Two Factor Authentication addon adds Two Factor Authentication module in Smart School. Using this module you can enhance login security of your Smart School users.', 0.00, NULL, 'https://go.smart-school.in/2fa', NULL, NULL, NULL, NULL, NULL, '2025-01-29 11:16:14', 0, 5, '2024-09-07 10:45:18', '2025-03-03 05:32:28'),
(3, 44277916, 'uploads/addon_images/ssmb_images.jpg', 'Smart School Multi Branch', 'multibranch-config', 'ssmb', 'multi_branch', 'Multi Branch addon adds Multi Branch module in Smart School. Using this module Superadmin user can add other any number of schools/branches.', 0.00, NULL, 'https://go.smart-school.in/multi-branch', NULL, NULL, NULL, NULL, NULL, '2025-01-29 11:16:15', 0, 6, '2024-09-07 10:45:18', '2025-03-03 05:32:20'),
(4, 44247532, 'uploads/addon_images/ssbr_images.jpg', 'Smart School Behaviour Records', 'behaviour-report-config', 'ssbr', 'behavior_records', 'Behaviour Records addon adds Behaviour Records module in Smart School. Using this module teacher/staff can create different incidents with positive/negative marks and then assign these incidents on students.', 0.00, NULL, 'https://go.smart-school.in/behaviour-records', NULL, NULL, NULL, NULL, NULL, '2025-01-29 11:16:19', 0, 7, '2024-09-07 10:45:42', '2025-03-03 05:32:11'),
(5, 33101540, 'uploads/addon_images/ssoclc_images.jpg', 'Smart School Online Course', 'onlinecourse-config', 'ssoclc', 'online_course', 'Online Course addon adds Online Course module in Smart School. Using this module teacher/staff can create free or paid online course with their study material based on video, audio or in document content format.', 0.00, NULL, 'https://go.smart-school.in/online-course', NULL, NULL, NULL, NULL, NULL, '2025-01-29 11:16:19', 0, 8, '2024-09-07 10:45:42', '2025-03-03 05:32:02'),
(6, 27492043, 'uploads/addon_images/sszlc_images.jpg', 'Smart School Zoom Live Classes', 'zoom-config', 'sszlc', 'zoom_live_class', 'Zoom Live Class addon adds Zoom Live Class module in Smart School. Using this module teacher/staff can create live online classes using Zoom.us service. Further students can join these classes.', 0.00, NULL, 'https://go.smart-school.in/zoom', NULL, NULL, NULL, NULL, NULL, '2025-01-29 11:16:17', 0, 10, '2024-09-07 10:46:10', '2025-03-03 05:31:49'),
(7, 28941973, 'uploads/addon_images/ssglc_images.jpg', 'Smart School Gmeet Live Class', 'gmeet-config', 'ssglc', 'gmeet_live_class', 'Gmeet Live Class addon adds Gmeet Live Class module in Smart School. Using this module teacher/staff can create live online classes using http://meet.google.com service. Further students can join these classes.', 0.00, NULL, 'https://go.smart-school.in/gmeet', NULL, NULL, NULL, NULL, NULL, '2025-01-29 11:16:24', 0, 9, '2024-09-07 10:46:10', '2025-03-03 05:31:33'),
(8, 50336584, 'uploads/addon_images/ssqra_images.jpg', 'Smart School QR Code Attendance', 'qrattendance-config', 'ssqra', 'qr_code_attendance', 'QR Code Attendance addon adds automated Student/Staff attendance using QR/Barcode module in Smart School. Using this module Student/Staff can submit their attendance by just scanning their ID Card.', 0.00, NULL, 'https://go.smart-school.in/qr-attendance', NULL, NULL, NULL, NULL, NULL, '2025-01-28 22:28:58', 0, 3, '2025-01-13 13:10:06', '2025-03-03 05:32:47'),
(9, 57220011, 'uploads/addon_images/ssqfc_images.jpg', 'Smart School Quick Fees Create', 'quickfees-config', 'ssqfc', 'quick_fees_create', 'Quick Fees Create addon adds one click fees create feature in Smart School Fees Collection module. Using this you can create and assign fees on students in just few seconds and all Fees Category, Fees Groups, Fees Masters will be create automatically in your Smart School.', 0.00, NULL, 'https://go.smart-school.in/quick-fees', NULL, NULL, NULL, NULL, NULL, '2025-01-28 22:28:58', 0, 2, '2025-01-13 13:10:06', '2025-03-03 05:33:00'),
(10, 57219905, 'uploads/addon_images/sstpa_images.jpg', 'Smart School Thermal Print', 'thermalprint-config', 'sstpa', 'thermal_print', 'Thermal Print addon adds Thermal Printer compatible small size fees receipt print capability in Smart School. Using this module you can utilize modern cost effective fees receipt printing in Smart School.', 0.00, NULL, 'https://go.smart-school.in/thermal-print', NULL, NULL, NULL, NULL, NULL, '2025-01-30 10:28:42', 0, 1, '2025-01-13 13:10:06', '2025-03-03 05:33:06');

CREATE TABLE `addon_versions` (
   `id` int primary key AUTO_INCREMENT,
  `addon_id` int DEFAULT NULL,
  `version` varchar(10) DEFAULT NULL,
  `version_order` int DEFAULT NULL,
  `folder_path` text,
  `sort_description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

ALTER TABLE alumni_events
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
  ALTER TABLE `alumni_students`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
   
  ALTER TABLE attendence_type
    ADD COLUMN `for_schedule` int NOT NULL DEFAULT '0' after `for_qr_attendance`,
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
	UPDATE `attendence_type` SET `for_schedule` = '1' WHERE `attendence_type`.`id` = 1;
	UPDATE `attendence_type` SET `for_schedule` = '1' WHERE `attendence_type`.`id` = 3;
	UPDATE `attendence_type` SET `for_schedule` = '1' WHERE `attendence_type`.`id` = 6;
  
  ALTER TABLE department
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
    ALTER TABLE books
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
    ALTER TABLE categories
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
      ALTER TABLE certificates
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP; 
  
       ALTER TABLE chat_connections
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
   ALTER TABLE chat_messages
  MODIFY COLUMN  `created_at` datetime DEFAULT NULL,
  add COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
    ALTER TABLE `book_issues`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `captcha`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
  ALTER TABLE chat_users
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
    ALTER TABLE classes
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
      ALTER TABLE class_sections
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
    ALTER TABLE `class_section_times`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
    ALTER TABLE `complaint`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
    ALTER TABLE `complaint_type`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP; 
  
    ALTER TABLE `contents`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
      ALTER TABLE `content_for`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
      ALTER TABLE `content_types`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
  CREATE TABLE `cumulative_fine` (
   `id` int primary key AUTO_INCREMENT,
  `overdue_day` int NOT NULL,
  `fine_amount` float(10,2) NOT NULL,
  `fee_groups_feetype_id` int NOT NULL,
  `fee_session_group_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3; 
  
      ALTER TABLE `currencies`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
        ALTER TABLE `custom_fields`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
        ALTER TABLE `custom_field_values`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
    
        ALTER TABLE `daily_assignment`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
        ALTER TABLE `disable_reason`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP; 
  
         ALTER TABLE `dispatch_receive`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
        ALTER TABLE `email_attachments`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
     ALTER TABLE `email_config`
	ADD COLUMN   `smtp_email` varchar(255) DEFAULT NULL after `smtp_port`,
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

      ALTER TABLE `enquiry`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
        ALTER TABLE `events`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
        ALTER TABLE `exams`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
      ALTER TABLE `exam_groups`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
   ALTER TABLE `exam_group_class_batch_exams`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `exam_group_class_batch_exam_students`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `exam_group_class_batch_exam_subjects`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `exam_group_exam_connections`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `exam_group_exam_results`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `exam_group_students`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `exam_schedules`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `expenses`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `expense_head`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `feemasters`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `fees_discounts`
    ADD COLUMN  `student_session_id` int(11) DEFAULT NULL after session_id,
   ADD COLUMN  `nature` varchar(255) NOT NULL after student_session_id,
  ADD COLUMN `discount_limit` int DEFAULT NULL after amount,
  ADD COLUMN `expire_date` date DEFAULT NULL after discount_limit,
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `fees_reminder`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `fee_groups`
 ADD COLUMN  `nature` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL after description,
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `fee_groups_feetype`
 ADD COLUMN  `fine_per_day` int NOT NULL DEFAULT '0' after fine_amount,
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;


  ALTER TABLE `fee_receipt_no`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `feetype`
  ADD COLUMN `session_id` int DEFAULT NULL after description,
  ADD COLUMN `student_session_id` int DEFAULT NULL after session_id,
  ADD COLUMN `nature` varchar(255) NOT NULL after student_session_id,
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `fee_session_groups`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `filetypes`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `follow_up`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `front_cms_media_gallery`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `front_cms_menus`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `front_cms_menu_items`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `front_cms_pages`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
   ALTER TABLE `front_cms_page_contents`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `front_cms_programs`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `front_cms_program_photos`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `front_cms_settings`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `gateway_ins`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `gateway_ins_response`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `general_calls`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `grades`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  CREATE TABLE `holiday_type` (
   `id` int primary key AUTO_INCREMENT,
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `is_default` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `holiday_type` (`id`, `type`, `is_default`) VALUES
(1, 'Holiday', 1),
(2, 'Vacation', 1),
(3, 'Activity', 1);
  
 ALTER TABLE `homework`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `homework_evaluation`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `hostel`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `hostel_rooms`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `id_card`
   ADD COLUMN `enable_student_rollno` tinyint(1) NOT NULL COMMENT '0=disable,1=enable' after enable_student_barcode,
   ADD COLUMN `enable_student_house_name` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=disable,1=enable' after enable_student_rollno,
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `income`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `income_head`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `item`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `item_category`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

 ALTER TABLE `item_issue`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `item_stock`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

 ALTER TABLE `item_store`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `item_supplier`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `languages`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `lesson`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `libarary_members`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `logs`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;
  
 ALTER TABLE `mark_divisions`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `messages`
 ADD COLUMN   `send_to` varchar(255) DEFAULT NULL after user_list,
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `notification_roles`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
   
   ALTER TABLE `notification_setting`
 ADD COLUMN `notification_order` int DEFAULT NULL after variables,
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

INSERT INTO `notification_setting` (`id`, `type`, `is_mail`, `is_sms`, `is_notification`, `display_notification`, `display_sms`, `is_student_recipient`, `is_guardian_recipient`, `is_staff_recipient`, `display_student_recipient`, `display_guardian_recipient`, `display_staff_recipient`, `subject`, `template_id`, `template`, `variables`, `notification_order`, `created_at`) VALUES
(null, 'homework_evaluation', '1', '0', 1, 1, 1, 1, 1, 0, 1, 1, NULL, 'Homework Evaluation', '', 'Homework Evaluation\r\nHomework Assign Date:  {{homework_date}}  \r\nLast Submit Date: {{submit_date}}\r\nStudent Name: {{student_name}} .\r\nAdmission No {{admission_no}}\r\n{{class}}\r\nsection: {{section}}\r\nsubject : {{subject}} \r\nMarks: {{marks}}/{{max_marks}}\r\nDate:{{evaluation_date}}\r\nThank you', '{{homework_date}} {{submit_date}} {{class}} {{section}} {{subject}} {{student_name}} {{admission_no}} {{max_marks}} {{marks}} {{evaluation_date}}', 120, '2025-01-15 08:00:34'),
(null, 'student_present_attendence', '1', '0', 0, 1, 1, 1, 1, 0, 1, 1, NULL, 'Present Attendence', '', 'Present Notice :{{student_name}} {{admission_no}} was present on date {{date}} in in_time {{in_time}} period\r\nsubject-{{subject_name}} <br> \r\nsubject_code - {{subject_code}} <br> \r\nsubject_type-{{subject_type}} <br>\r\nperiod_time_from-  {{period_time_from}}  <br>\r\nperiod_time_to-  {{period_time_to}}  <br>\r\nfrom Your School Name or more detail contact System Admin  <br>\r\nmobile no - {{mobileno}} <br>\r\nemail -  {{email}}<br>\r\nfather name -  {{father_name}} <br>\r\nfather phone - {{father_phone}}<br>\r\nfather occupation -  {{father_occupation}}<br>\r\nmother name -  {{mother_name}} <br>\r\nmother phone - {{mother_phone}}<br>\r\nguardian name -  {{guardian_name}}<br>\r\nguardian phone -  {{guardian_phone}} <br>\r\nguardian occupation - {{guardian_occupation}}<br>\r\nguardian email - {{guardian_email}}<br>', '{{student_name}} {{mobileno}} {{email}} {{father_name}} {{father_phone}} {{father_occupation}} {{mother_name}} {{mother_phone}} {{guardian_name}} {{guardian_phone}} {{guardian_occupation}} {{guardian_email}} {{date}} {{in_time}}  ({{admission_no}}) {{period_time_from}} {{period_time_to}} {{subject_name}} {{subject_code}} {{subject_type}}', 15, '2025-01-13 05:55:46'),
(null, 'staff_present_attendence', '1', '0', 0, 1, 1, 0, 0, 1, NULL, NULL, 1, 'staff Present Attendence', '', 'Present Notice: Staff Name {{staff_name}} ({{employee_id}}) is Present on Date : {{date}} at Time : {{in_time}}\r\n<br>\r\nstaff contact no:{{contact_no}}\r\n<br>\r\nstaff mail id : {{email}}', '{{date}} {{in_time}} {{staff_name}} {{employee_id}} {{contact_no}} {{email}}\n', 190, '2025-02-07 11:43:28'),
(null, 'staff_absent_attendence', '1', '0', 0, 1, 1, 0, 0, 1, NULL, NULL, 1, 'staff Absent Attendence', '', 'Absent Notice: Staff Name {{staff_name}} ({{employee_id}}) is Absent on Date : {{date}} \r\n<br>\r\nstaff contact no:{{contact_no}}\r\n<br>\r\nstaff mail id : {{email}}', '{{date}} {{staff_name}} {{employee_id}} {{contact_no}} {{email}}\n', 200, '2025-02-07 11:43:28');

UPDATE `notification_setting` SET `type` = 'student_absent_attendence' WHERE `notification_setting`.`id` = 4;
  
 ALTER TABLE `offline_fees_payments`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `onlineexam`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `onlineexam_attempts`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `onlineexam_questions`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `onlineexam_students`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `onlineexam_student_results`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `online_admissions`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `online_admission_custom_field_value`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `online_admission_fields`
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `online_admission_payment`
  ADD COLUMN `processing_charge_type` varchar(255) DEFAULT NULL after date,
  ADD COLUMN `processing_charge_value` float(10,2) DEFAULT NULL after processing_charge_type,
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `payment_settings`
  ADD COLUMN `charge_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL after paytm_industrytype,
  ADD COLUMN `charge_value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL after charge_type, 
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `payslip_allowance`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
	
	INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`) VALUES
(274, 30, 'Annual Calendar', 'annual_calendar', 1, 1, 1, 1, '2020-05-28 22:20:11'),
(275, 30, 'Holiday Type', 'holiday_type', 1, 1, 1, 1, '2024-10-14 12:31:14'),
(276, 14, 'Online Admission Report', 'online_admission_report', 1, 0, 0, 0, '2020-08-22 12:42:27'),
(277, 31, 'Download CV', 'download_cv', 1, 0, 0, 0, '2024-12-10 11:06:30'),
(278, 31, 'Build CV', 'build_cv', 1, 1, 0, 1, '2024-12-13 07:05:10'),
(279, 31, 'Setting', 'download_cv_setting', 1, 0, 0, 0, '2024-12-10 11:06:30'),
(280, 22, 'Student Head Count Widget', 'student_head_count_widget', 1, 0, 0, 0, '2018-07-03 07:13:35'),
(281, 22, 'Staff Approved Leave Widegts', 'staff_approved_leave_widegts', 1, 0, 0, 0, '2018-07-03 07:13:35'),
(282, 22, 'Student Approved Leave Widegts', 'student_approved_leave_widegts', 1, 0, 0, 0, '2018-07-03 07:13:35');

  UPDATE `permission_category` SET `name` = 'Setup Front Office' WHERE `permission_category`.`id` = 85;

  UPDATE `permission_category` SET `name` = 'Converted Leads Widegts' WHERE `permission_category`.`id` = 191;

 ALTER TABLE `permission_category`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
  INSERT INTO `permission_group` (`id`, `name`, `short_code`, `is_active`, `system`, `created_at`) VALUES
(30, 'Annual Calendar', 'annual_calendar', 1, 0, '2024-10-22 10:45:56'),
(31, 'Student CV', 'student_cv', 1, 0, '2024-12-13 11:54:57');

 ALTER TABLE `permission_group`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  
  
 ALTER TABLE `permission_student`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `pickup_point`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
 
 INSERT INTO `print_headerfooter` (`id`, `print_type`, `header_image`, `footer_content`, `created_by`, `entry_date`, `created_at`) VALUES
(5, 'general_purpose', 'header_image.jpg', '<h1>\r\n\r\n</h1><p>footer text example ....</p>', 1, '2025-02-05 07:26:06', '2022-09-08 17:28:34');

 ALTER TABLE `print_headerfooter`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `questions`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `read_notification`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
 ALTER TABLE `reference`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

CREATE TABLE `resume_additional_fields_settings` (
   `id` int primary key AUTO_INCREMENT,
  `name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `status` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `resume_additional_fields_settings` (`id`, `name`, `status`, `created_at`) VALUES
(1, 'work_experience', 1, '2024-12-06 06:17:04'),
(2, 'education_qalification', 1, '2024-12-06 06:17:04'),
(3, 'technical_skills', 1, '2024-12-06 06:17:04'),
(4, 'reference', 1, '2024-12-06 06:17:04'),
(5, 'other_details', 1, '2024-12-06 06:17:04');

-- --------------------------------------------------------

--
-- Table structure for table `resume_settings_fields`
--

CREATE TABLE `resume_settings_fields` (
    `id` int primary key AUTO_INCREMENT,
  `name` varchar(250) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `resume_settings_fields` (`id`, `name`, `status`, `created_at`, `updated_at`) VALUES
(1, 'middlename', 1, '2025-02-14 06:40:33', '2025-02-14 06:40:33'),
(2, 'lastname', 1, '2025-02-14 06:40:34', '2025-02-14 06:40:34'),
(3, 'gender', 1, '2025-02-14 06:40:35', '2025-02-14 06:40:35'),
(4, 'dob', 1, '2025-02-14 06:40:36', '2025-02-14 06:40:36'),
(5, 'category', 1, '2025-02-14 06:40:37', '2025-02-14 06:40:37'),
(6, 'religion', 1, '2025-02-14 06:40:38', '2025-02-14 06:40:38'),
(7, 'cast', 1, '2025-02-14 06:40:40', '2025-02-14 06:40:40'),
(8, 'mobile_no', 1, '2025-02-14 06:40:41', '2025-02-14 06:40:41'),
(9, 'student_email', 1, '2025-02-14 06:40:41', '2025-02-14 06:40:41'),
(10, 'student_photo', 1, '2025-02-14 06:40:42', '2025-02-14 06:40:42'),
(11, 'is_blood_group', 1, '2025-02-14 06:40:43', '2025-02-14 06:40:43'),
(12, 'height', 1, '2025-02-14 06:40:44', '2025-02-14 06:40:44'),
(13, 'weight', 1, '2025-02-14 06:40:46', '2025-02-14 06:40:46'),
(14, 'father_name', 1, '2025-02-14 06:40:47', '2025-02-14 06:40:47'),
(15, 'father_phone', 1, '2025-02-14 06:40:48', '2025-02-14 06:40:48'),
(16, 'father_occupation', 1, '2025-02-14 06:40:49', '2025-02-14 06:40:49'),
(17, 'father_pic', 1, '2025-02-14 06:40:49', '2025-02-14 06:40:49'),
(18, 'mother_name', 1, '2025-02-14 06:40:50', '2025-02-14 06:40:50'),
(19, 'mother_phone', 1, '2025-02-14 06:40:51', '2025-02-14 06:40:51'),
(20, 'mother_occupation', 1, '2025-02-14 06:40:52', '2025-02-14 06:40:52'),
(21, 'mother_pic', 1, '2025-02-14 06:40:52', '2025-02-14 06:40:52'),
(22, 'if_guardian_is', 1, '2025-02-14 06:40:53', '2025-02-14 06:42:17'),
(23, 'guardian_name', 1, '2025-02-14 06:41:31', '2025-02-14 06:42:17'),
(24, 'guardian_relation', 1, '2025-02-14 06:41:31', '2025-02-14 06:42:17'),
(25, 'guardian_email', 1, '2025-02-14 06:41:32', '2025-02-14 06:42:17'),
(26, 'guardian_photo', 1, '2025-02-14 06:41:33', '2025-02-14 06:42:17'),
(27, 'guardian_phone', 1, '2025-02-14 06:41:34', '2025-02-14 06:42:17'),
(28, 'guardian_occupation', 1, '2025-02-14 06:41:34', '2025-02-14 06:42:17'),
(29, 'guardian_address', 1, '2025-02-14 06:41:35', '2025-02-14 06:42:17'),
(30, 'current_address', 1, '2025-02-14 06:41:36', '2025-02-14 06:41:36'),
(31, 'permanent_address', 1, '2025-02-14 06:41:37', '2025-02-14 06:41:37'),
(32, 'national_identification_no', 1, '2025-02-14 06:41:37', '2025-02-14 06:41:37'),
(33, 'local_identification_no', 1, '2025-02-14 06:41:38', '2025-02-14 06:41:38'),
(34, 'personal_details', 1, '2025-02-14 06:41:39', '2025-02-14 06:41:39'),
(35, 'parent_guardian_detail', 1, '2025-02-14 06:41:41', '2025-02-14 06:41:41');

   ALTER TABLE `roles`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

   ALTER TABLE `roles_permissions`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

   ALTER TABLE `room_types`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

   ALTER TABLE `route_pickup_point`
   ADD COLUMN `session_id` int DEFAULT NULL after id,
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
  UPDATE `route_pickup_point` SET `session_id` = '20' WHERE `route_pickup_point`.`session_id` IS NULL;  

   ALTER TABLE `school_houses`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

   ALTER TABLE `sch_settings`
  ADD COLUMN `student_resume_download` int NOT NULL DEFAULT '1' after scan_code_type,
  ADD COLUMN `download_admit_card` int NOT NULL DEFAULT '0',
  ADD COLUMN `fees_discount` int NOT NULL,
  ADD COLUMN `front_side_whatsapp` int NOT NULL DEFAULT '0',
  ADD COLUMN `front_side_whatsapp_mobile` varchar(50) DEFAULT NULL,
  ADD COLUMN `front_side_whatsapp_from` time DEFAULT NULL,
  ADD COLUMN `front_side_whatsapp_to` time DEFAULT NULL,
  ADD COLUMN `admin_panel_whatsapp` int NOT NULL DEFAULT '0',
  ADD COLUMN `admin_panel_whatsapp_mobile` varchar(50) DEFAULT NULL,
  ADD COLUMN `admin_panel_whatsapp_from` time DEFAULT NULL,
  ADD COLUMN `admin_panel_whatsapp_to` time DEFAULT NULL,
  ADD COLUMN `student_panel_whatsapp` int NOT NULL DEFAULT '0',
  ADD COLUMN `student_panel_whatsapp_mobile` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  ADD COLUMN `student_panel_whatsapp_from` time DEFAULT NULL,
  ADD COLUMN `student_panel_whatsapp_to` time DEFAULT NULL,
  ADD COLUMN `saas_key` text,
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `sections`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `send_notification`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `sessions`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `share_contents`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;  

  ALTER TABLE `staff_leave_details`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `share_content_for`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `share_upload_contents`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `sidebar_menus`
  add COLUMN   `product_name` varchar(50) NOT NULL after id,
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
  INSERT INTO `sidebar_menus` (`id`, `product_name`, `permission_group_id`, `icon`, `menu`, `activate_menu`, `lang_key`, `system_level`, `level`, `sidebar_display`, `access_permissions`, `is_active`, `created_at`) VALUES
(36, '', 30, 'fa fa-calendar', 'Annual Calendar', 'holiday', 'annual_calendar', 240, 16, 1, '(\'annual_calendar\', \'can_view\')\r\n', 1, '2025-01-18 09:15:03'),
(37, '', 31, 'fa fa-ioxhost ftlayer', 'Student CV', 'student_cv', 'student_cv', 1, 23, 1, '(\'download_cv\', \'can_view\') || (\'build_cv\', \'can_view\') || (\'resume_setting\', \'can_view\') || (\'student_resume_details\', \'can_view\')', 1, '2025-01-18 09:15:07');

UPDATE `sidebar_sub_menus` SET `activate_methods` = 'index,logo,miscellaneous,backendtheme,mobileapp,studentguardianpanel,fees,idautogeneration,attendancetype,maintenance,whatsappsettings' WHERE `sidebar_sub_menus`.`id` = 146;

INSERT INTO `sidebar_sub_menus` (`id`, `sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `addon_permission`, `is_active`, `created_at`) VALUES
(215, 36, 'annual_calendar', NULL, 'annual_calendar', 'admin/holiday/index', 1, '(\'annual_calendar\', \'can_view\')', NULL, 'holiday', 'index', '', 1, '2024-10-14 12:07:58'),
(216, 36, 'holiday_type', NULL, 'holiday_type', 'admin/holiday/holidaytype', 1, '(\'holiday_type\', \'can_view\')', NULL, 'holiday', 'holidaytype,editholidaytype', '', 1, '2024-10-14 12:06:02'),
(217, 37, 'download_cv', NULL, 'download_cv', 'admin/resume/download', 2, '(\'download_cv\', \'can_view\')', NULL, 'resume', 'download', NULL, 1, '2025-01-09 08:05:11'),
(218, 37, 'build_cv', NULL, 'build_cv', 'admin/resume/index', 1, '(\'build_cv\', \'can_view\')', NULL, 'resume', 'index,resume_setting,student_resume_details', NULL, 1, '2024-12-06 11:42:02'),
(219, 27, 'addons', NULL, 'addons', 'admin/addons', 13, '(\'superadmin\', \'can_view\')', NULL, 'addons', 'index', '', 1, '2024-12-21 11:43:48');

UPDATE `sidebar_sub_menus` SET `access_permissions` = '(\'student_transport_fees\', \'can_view\')' WHERE `sidebar_sub_menus`.`id` = 112;

UPDATE `sidebar_sub_menus` SET `access_permissions` = '(\'route_pickup_point\', \'can_view\')' WHERE `sidebar_sub_menus`.`id` = 111;

UPDATE `sidebar_sub_menus` SET `access_permissions` = '(\'pickup_point\', \'can_view\')' WHERE `sidebar_sub_menus`.`id` = 107;

UPDATE `sidebar_sub_menus` SET `access_permissions` = '(\'transport_fees_master\', \'can_view\')' WHERE `sidebar_sub_menus`.`id` = 106;

  ALTER TABLE `sidebar_sub_menus`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `sms_config`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

    ALTER TABLE `sms_template`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

    ALTER TABLE `staff`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

    ALTER TABLE `staff_attendance`
    ADD COLUMN `in_time` time DEFAULT NULL after is_active,
  ADD COLUMN `out_time` time DEFAULT NULL  after in_time,
  MODIFY COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  MODIFY COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE `staff_attendance_type`
  ADD COLUMN   `for_schedule` int NOT NULL DEFAULT '0' after long_name_style,
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
INSERT INTO `staff_attendance_type` (`id`, `type`, `key_value`, `is_active`, `for_qr_attendance`, `long_lang_name`, `long_name_style`, `for_schedule`, `created_at`, `updated_at`) VALUES
(6, 'Half Day Second Shift', '<b class=\"text text-warning\">SH</b>', 'yes', 1, 'half_day_second_shift', 'label label-info', 1, '2024-09-24 12:28:42', '2024-09-24 12:28:42');

UPDATE `staff_attendance_type` SET `for_schedule` = '1' WHERE `staff_attendance_type`.`id` = 1;
UPDATE `staff_attendance_type` SET `for_schedule` = '1' WHERE `staff_attendance_type`.`id` = 2;
UPDATE `staff_attendance_type` SET `for_schedule` = '1' WHERE `staff_attendance_type`.`id` = 4;  

  ALTER TABLE `staff_designation`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `staff_id_card`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `staff_leave_request`
  ADD COLUMN  `approve_date` date DEFAULT NULL after admin_remark,
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `staff_payroll`
  add COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `staff_payslip`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `staff_rating`
  Modify COLUMN `entrydt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `staff_roles`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `staff_timeline`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `students`
  ADD COLUMN  `created_by` int DEFAULT NULL after parent_app_key,
  ADD COLUMN `about` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci after dis_note,
  ADD COLUMN `designation` varchar(255) DEFAULT NULL  after about,
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `student_applyleave`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  add COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `student_attendences`
   add COLUMN   `in_time` time DEFAULT NULL after user_agent,
   add COLUMN  `out_time` time DEFAULT NULL after in_time,
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  CREATE TABLE `student_dashboard_settings` (
  `id` int primary key AUTO_INCREMENT,
  `name` varchar(250) DEFAULT NULL,
  `short_code` varchar(255) NOT NULL,
  `is_student` int DEFAULT NULL,
  `is_parent` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `student_dashboard_settings` (`id`, `name`, `short_code`, `is_student`, `is_parent`, `created_at`) VALUES
(1, 'welcome_student', '', 1, 1, '2024-10-15 12:14:22'),
(2, 'notice_board', 'communicate', 1, 1, '2024-10-15 12:14:25'),
(3, 'subject_progress', 'lesson_plan', 1, 1, '2024-10-15 12:14:27'),
(4, 'upcomming_class', 'academics', 1, 1, '2024-10-15 12:14:55'),
(5, 'homework', 'homework', 1, 1, '2024-10-15 12:14:56'),
(6, 'teacher_list', 'human_resource', 1, 1, '2024-10-15 12:14:57'),
(7, 'visitor_list', 'front_office', 1, 1, '2024-10-15 12:14:58'),
(8, 'library', 'library', 1, 1, '2024-10-15 12:14:59');

  ALTER TABLE `student_doc`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `student_edit_fields`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Add COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `student_fees`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `student_fees_deposite`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `student_fees_discounts`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `student_fees_master`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `student_fees_processing`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
CREATE TABLE `student_refrence` (
  `id` int primary key AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `relation` varchar(255) NOT NULL,
  `age` varchar(255) NOT NULL,
  `profession` varchar(255) NOT NULL,
  `contact` varchar(255) NOT NULL,
  `student_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

  ALTER TABLE `student_session`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `student_subject_attendances`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
  
CREATE TABLE `student_skills_detail` (
  `id` int primary key AUTO_INCREMENT,
  `skill_category` varchar(255) NOT NULL,
  `skill_detail` varchar(255) NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

  ALTER TABLE `student_timeline`
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `student_transport_fees`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `subjects`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `subject_groups`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `subject_group_class_sections`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `subject_group_subjects`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `subject_syllabus`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `subject_timetable`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `submit_assignment`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `template_admitcards`
  ADD COLUMN  `is_active` int DEFAULT '0' after is_section,
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `template_marksheets`
  Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `topic`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Add COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `transport_feemaster`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Add COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `transport_route`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `upload_contents`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `users`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `users_authentication`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   Modify COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `vehicles`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `vehicle_routes`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `video_tutorial`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `video_tutorial_class_sections`
   ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `visitors_book`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

  ALTER TABLE `visitors_purpose`
   Modify COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE `addon_versions`
    ADD KEY `addon_id` (`addon_id`);

ALTER TABLE `annual_calendar`
    ADD KEY `session_id` (`session_id`);

ALTER TABLE `student_applied_discounts`
  ADD KEY `student_fees_deposite_id` (`student_fees_deposite_id`),
  ADD KEY `student_fees_discount_id` (`student_fees_discount_id`);

  ALTER TABLE `addon_versions`
  ADD CONSTRAINT `addon_versions_ibfk_1` FOREIGN KEY (`addon_id`) REFERENCES `addons` (`id`) ON DELETE CASCADE;

ALTER TABLE `annual_calendar`
  ADD CONSTRAINT `annual_calendar_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`);

  ALTER TABLE `student_applied_discounts`
  ADD CONSTRAINT `student_applied_discounts_ibfk_1` FOREIGN KEY (`student_fees_deposite_id`) REFERENCES `student_fees_deposite` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_applied_discounts_ibfk_2` FOREIGN KEY (`student_fees_discount_id`) REFERENCES `student_fees_discounts` (`id`) ON DELETE CASCADE;
  
  SET FOREIGN_KEY_CHECKS=1;