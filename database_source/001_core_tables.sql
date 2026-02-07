-- ============================================================================
-- CORE SYSTEM TABLES FOR TVET-ONLY DEPLOYMENT
-- Extracted from original database.sql
-- Total: 52 core tables (45 originally planned + 7 essential dependencies)
-- ============================================================================
--
-- These tables provide the foundation for:
-- - User authentication and authorization (staff, students, users)
-- - RBAC permission system (roles, permissions)
-- - System configuration (settings, languages, currencies)
-- - Communication infrastructure (notifications, messages, email, SMS)
-- - Content management (contents, homework, lessons)
-- - Supporting modules (departments, categories, custom fields)
--
-- Note: Foreign keys to legacy tables have been removed. These will be
-- replaced with TVET academic model foreign keys in migration 009.
-- ============================================================================

SET SQL_MODE = "";
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- USER MANAGEMENT TABLES (4 tables)
-- ============================================================================

CREATE TABLE `staff` (
  `id` int NOT NULL,
  `employee_id` varchar(200) NOT NULL,
  `lang_id` int NOT NULL,
  `currency_id` int DEFAULT '0',
  `department` int DEFAULT NULL,
  `designation` int DEFAULT NULL,
  `qualification` varchar(200) NOT NULL,
  `work_exp` varchar(200) NOT NULL,
  `name` varchar(200) NOT NULL,
  `surname` varchar(200) NOT NULL,
  `father_name` varchar(200) NOT NULL,
  `mother_name` varchar(200) NOT NULL,
  `contact_no` varchar(200) NOT NULL,
  `emergency_contact_no` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `dob` date NOT NULL,
  `marital_status` varchar(100) NOT NULL,
  `date_of_joining` date DEFAULT NULL,
  `date_of_leaving` date DEFAULT NULL,
  `local_address` varchar(300) NOT NULL,
  `permanent_address` varchar(200) NOT NULL,
  `note` varchar(200) NOT NULL,
  `image` varchar(200) NOT NULL,
  `password` varchar(250) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `account_title` varchar(200) NOT NULL,
  `bank_account_no` varchar(200) NOT NULL,
  `bank_name` varchar(200) NOT NULL,
  `ifsc_code` varchar(200) NOT NULL,
  `bank_branch` varchar(100) NOT NULL,
  `payscale` varchar(200) NOT NULL,
  `basic_salary` int DEFAULT NULL,
  `epf_no` varchar(200) NOT NULL,
  `contract_type` varchar(100) NOT NULL,
  `shift` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL,
  `facebook` varchar(200) NOT NULL,
  `twitter` varchar(200) NOT NULL,
  `linkedin` varchar(200) NOT NULL,
  `instagram` varchar(200) NOT NULL,
  `resume` varchar(200) NOT NULL,
  `joining_letter` varchar(200) NOT NULL,
  `resignation_letter` varchar(200) NOT NULL,
  `other_document_name` varchar(200) NOT NULL,
  `other_document_file` varchar(200) NOT NULL,
  `user_id` int NOT NULL,
  `is_active` int NOT NULL,
  `verification_code` varchar(100) NOT NULL,
  `disable_at` date DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `staff_attendance`
--

CREATE TABLE `students` (
  `id` int NOT NULL,
  `parent_id` int NOT NULL,
  `admission_no` varchar(100) DEFAULT NULL,
  `roll_no` varchar(100) DEFAULT NULL,
  `admission_date` date DEFAULT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `middlename` varchar(255) DEFAULT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  `rte` varchar(20) DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `mobileno` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(100) DEFAULT NULL,
  `religion` varchar(100) DEFAULT NULL,
  `cast` varchar(50) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(100) DEFAULT NULL,
  `current_address` text,
  `permanent_address` text,
  `category_id` varchar(100) DEFAULT NULL,
  `school_house_id` int DEFAULT NULL,
  `blood_group` varchar(200) NOT NULL,
  `hostel_room_id` int DEFAULT NULL,
  `adhar_no` varchar(100) DEFAULT NULL,
  `samagra_id` varchar(100) DEFAULT NULL,
  `bank_account_no` varchar(100) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `ifsc_code` varchar(100) DEFAULT NULL,
  `guardian_is` varchar(100) NOT NULL,
  `father_name` varchar(100) DEFAULT NULL,
  `father_phone` varchar(100) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `mother_name` varchar(100) DEFAULT NULL,
  `mother_phone` varchar(100) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `guardian_name` varchar(100) DEFAULT NULL,
  `guardian_relation` varchar(100) DEFAULT NULL,
  `guardian_phone` varchar(100) DEFAULT NULL,
  `guardian_occupation` varchar(150) NOT NULL,
  `guardian_address` text,
  `guardian_email` varchar(100) DEFAULT NULL,
  `father_pic` varchar(200) NOT NULL,
  `mother_pic` varchar(200) NOT NULL,
  `guardian_pic` varchar(200) NOT NULL,
  `is_active` varchar(255) DEFAULT 'yes',
  `previous_school` text,
  `height` varchar(100) NOT NULL,
  `weight` varchar(100) NOT NULL,
  `measurement_date` date DEFAULT NULL,
  `dis_reason` int NOT NULL,
  `note` varchar(200) DEFAULT NULL,
  `dis_note` text NOT NULL,
  `about` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci,
  `designation` varchar(255) DEFAULT NULL,
  `app_key` text,
  `parent_app_key` text,
  `created_by` int DEFAULT NULL,
  `disable_at` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `student_applied_discounts`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `childs` text NOT NULL,
  `role` varchar(30) NOT NULL,
  `lang_id` int NOT NULL,
  `currency_id` int DEFAULT '0',
  `verification_code` varchar(200) NOT NULL,
  `is_active` varchar(255) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `users_authentication`
--

CREATE TABLE `userlog` (
  `id` int NOT NULL,
  `user` varchar(100) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `ipaddress` varchar(100) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `login_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

-- ============================================================================
-- RBAC TABLES (5 tables)
-- ============================================================================

CREATE TABLE `roles` (
  `id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `slug` varchar(150) DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `is_system` int NOT NULL DEFAULT '0',
  `is_superadmin` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `roles_permissions`
--

CREATE TABLE `roles_permissions` (
  `id` int NOT NULL,
  `role_id` int DEFAULT NULL,
  `perm_cat_id` int DEFAULT NULL,
  `can_view` int DEFAULT NULL,
  `can_add` int DEFAULT NULL,
  `can_edit` int DEFAULT NULL,
  `can_delete` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `room_types`
--

CREATE TABLE `permission_category` (
  `id` int NOT NULL,
  `perm_group_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `short_code` varchar(100) DEFAULT NULL,
  `enable_view` int DEFAULT '0',
  `enable_add` int DEFAULT '0',
  `enable_edit` int DEFAULT '0',
  `enable_delete` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `permission_group`
--

CREATE TABLE `permission_group` (
  `id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `short_code` varchar(100) NOT NULL,
  `is_active` int DEFAULT '0',
  `system` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `permission_student`
--

CREATE TABLE `permission_student` (
  `id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `short_code` varchar(100) NOT NULL,
  `system` int NOT NULL,
  `student` int NOT NULL,
  `parent` int NOT NULL,
  `group_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `pickup_point`
--

-- ============================================================================
-- SETTINGS TABLES (8 tables)
-- ============================================================================

CREATE TABLE `sch_settings` (
  `id` int NOT NULL,
  `base_url` varchar(500) DEFAULT NULL,
  `folder_path` text,
  `name` varchar(100) DEFAULT NULL,
  `biometric` int DEFAULT '0',
  `biometric_device` text,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `address` text,
  `lang_id` int DEFAULT NULL,
  `languages` varchar(500) NOT NULL,
  `dise_code` varchar(50) DEFAULT NULL,
  `date_format` varchar(50) NOT NULL,
  `time_format` varchar(255) NOT NULL,
  `currency` varchar(50) NOT NULL,
  `currency_symbol` varchar(50) NOT NULL,
  `is_rtl` varchar(10) DEFAULT 'disabled',
  `is_duplicate_fees_invoice` varchar(100) DEFAULT '0',
  `collect_back_date_fees` int NOT NULL,
  `single_page_print` int DEFAULT '0',
  `timezone` varchar(30) DEFAULT 'UTC',
  `session_id` int DEFAULT NULL,
  `cron_secret_key` varchar(100) NOT NULL,
  `currency_place` varchar(50) NOT NULL DEFAULT 'before_number',
  `currency_format` varchar(20) DEFAULT NULL,
  `class_teacher` varchar(100) NOT NULL,
  `start_month` varchar(40) NOT NULL,
  `attendence_type` int NOT NULL DEFAULT '0',
  `low_attendance_limit` float(10,2) NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `admin_logo` varchar(255) NOT NULL,
  `admin_small_logo` varchar(255) NOT NULL,
  `admin_login_page_background` varchar(255) NOT NULL,
  `user_login_page_background` varchar(255) NOT NULL,
  `theme` varchar(200) NOT NULL DEFAULT 'default.jpg',
  `fee_due_days` int DEFAULT '0',
  `adm_auto_insert` int NOT NULL DEFAULT '1',
  `adm_prefix` varchar(50) NOT NULL DEFAULT 'ssadm19/20',
  `adm_start_from` varchar(11) NOT NULL,
  `adm_no_digit` int NOT NULL DEFAULT '6',
  `adm_update_status` int NOT NULL DEFAULT '0',
  `staffid_auto_insert` int NOT NULL DEFAULT '1',
  `staffid_prefix` varchar(100) NOT NULL DEFAULT 'staffss/19/20',
  `staffid_start_from` varchar(50) NOT NULL,
  `staffid_no_digit` int NOT NULL DEFAULT '6',
  `staffid_update_status` int NOT NULL DEFAULT '0',
  `is_active` varchar(255) DEFAULT 'no',
  `online_admission` int DEFAULT '0',
  `online_admission_payment` varchar(50) NOT NULL,
  `online_admission_amount` float NOT NULL,
  `online_admission_instruction` text NOT NULL,
  `online_admission_conditions` text NOT NULL,
  `online_admission_application_form` varchar(255) DEFAULT NULL,
  `exam_result` int NOT NULL,
  `is_blood_group` int NOT NULL DEFAULT '1',
  `is_student_house` int NOT NULL DEFAULT '1',
  `roll_no` int NOT NULL DEFAULT '1',
  `category` int NOT NULL,
  `religion` int NOT NULL DEFAULT '1',
  `cast` int NOT NULL DEFAULT '1',
  `mobile_no` int NOT NULL DEFAULT '1',
  `student_email` int NOT NULL DEFAULT '1',
  `admission_date` int NOT NULL DEFAULT '1',
  `lastname` int NOT NULL,
  `middlename` int NOT NULL DEFAULT '1',
  `student_photo` int NOT NULL DEFAULT '1',
  `student_height` int NOT NULL DEFAULT '1',
  `student_weight` int NOT NULL DEFAULT '1',
  `measurement_date` int NOT NULL DEFAULT '1',
  `father_name` int NOT NULL DEFAULT '1',
  `father_phone` int NOT NULL DEFAULT '1',
  `father_occupation` int NOT NULL DEFAULT '1',
  `father_pic` int NOT NULL DEFAULT '1',
  `mother_name` int NOT NULL DEFAULT '1',
  `mother_phone` int NOT NULL DEFAULT '1',
  `mother_occupation` int NOT NULL DEFAULT '1',
  `mother_pic` int NOT NULL DEFAULT '1',
  `guardian_name` int NOT NULL,
  `guardian_relation` int NOT NULL DEFAULT '1',
  `guardian_phone` int NOT NULL,
  `guardian_email` int NOT NULL DEFAULT '1',
  `guardian_pic` int NOT NULL DEFAULT '1',
  `guardian_occupation` int NOT NULL,
  `guardian_address` int NOT NULL DEFAULT '1',
  `current_address` int NOT NULL DEFAULT '1',
  `permanent_address` int NOT NULL DEFAULT '1',
  `route_list` int NOT NULL DEFAULT '1',
  `hostel_id` int NOT NULL DEFAULT '1',
  `bank_account_no` int NOT NULL DEFAULT '1',
  `ifsc_code` int NOT NULL,
  `bank_name` int NOT NULL,
  `national_identification_no` int NOT NULL DEFAULT '1',
  `local_identification_no` int NOT NULL DEFAULT '1',
  `rte` int NOT NULL DEFAULT '1',
  `previous_school_details` int NOT NULL DEFAULT '1',
  `student_note` int NOT NULL DEFAULT '1',
  `upload_documents` int NOT NULL DEFAULT '1',
  `student_barcode` int NOT NULL DEFAULT '1',
  `staff_designation` int NOT NULL DEFAULT '1',
  `staff_department` int NOT NULL DEFAULT '1',
  `staff_last_name` int NOT NULL DEFAULT '1',
  `staff_father_name` int NOT NULL DEFAULT '1',
  `staff_mother_name` int NOT NULL DEFAULT '1',
  `staff_date_of_joining` int NOT NULL DEFAULT '1',
  `staff_phone` int NOT NULL DEFAULT '1',
  `staff_emergency_contact` int NOT NULL DEFAULT '1',
  `staff_marital_status` int NOT NULL DEFAULT '1',
  `staff_photo` int NOT NULL DEFAULT '1',
  `staff_current_address` int NOT NULL DEFAULT '1',
  `staff_permanent_address` int NOT NULL DEFAULT '1',
  `staff_qualification` int NOT NULL DEFAULT '1',
  `staff_work_experience` int NOT NULL DEFAULT '1',
  `staff_note` int NOT NULL DEFAULT '1',
  `staff_epf_no` int NOT NULL DEFAULT '1',
  `staff_basic_salary` int NOT NULL DEFAULT '1',
  `staff_contract_type` int NOT NULL DEFAULT '1',
  `staff_work_shift` int NOT NULL DEFAULT '1',
  `staff_work_location` int NOT NULL DEFAULT '1',
  `staff_leaves` int NOT NULL DEFAULT '1',
  `staff_account_details` int NOT NULL DEFAULT '1',
  `staff_social_media` int NOT NULL DEFAULT '1',
  `staff_upload_documents` int NOT NULL DEFAULT '1',
  `staff_barcode` int NOT NULL DEFAULT '1',
  `staff_notification_email` varchar(50) NOT NULL,
  `mobile_api_url` tinytext NOT NULL,
  `app_primary_color_code` varchar(20) DEFAULT NULL,
  `app_secondary_color_code` varchar(20) DEFAULT NULL,
  `admin_mobile_api_url` tinytext NOT NULL,
  `admin_app_primary_color_code` varchar(20) NOT NULL,
  `admin_app_secondary_color_code` varchar(20) NOT NULL,
  `app_logo` varchar(250) DEFAULT NULL,
  `student_profile_edit` int NOT NULL DEFAULT '0',
  `start_week` varchar(10) NOT NULL,
  `my_question` int NOT NULL,
  `superadmin_restriction` varchar(20) NOT NULL,
  `student_timeline` varchar(20) NOT NULL,
  `calendar_event_reminder` int DEFAULT NULL,
  `event_reminder` varchar(20) NOT NULL,
  `student_login` varchar(100) DEFAULT NULL,
  `parent_login` varchar(100) DEFAULT NULL,
  `student_panel_login` int NOT NULL DEFAULT '1',
  `parent_panel_login` int NOT NULL DEFAULT '1',
  `is_student_feature_lock` int NOT NULL DEFAULT '0',
  `maintenance_mode` int NOT NULL DEFAULT '0',
  `lock_grace_period` int NOT NULL DEFAULT '0',
  `is_offline_fee_payment` int NOT NULL DEFAULT '0',
  `offline_bank_payment_instruction` text NOT NULL,
  `scan_code_type` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL DEFAULT 'barcode',
  `student_resume_download` int NOT NULL DEFAULT '1',
  `download_admit_card` int NOT NULL DEFAULT '0',
  `fees_discount` int NOT NULL,
  `front_side_whatsapp` int NOT NULL DEFAULT '0',
  `front_side_whatsapp_mobile` varchar(50) DEFAULT NULL,
  `front_side_whatsapp_from` time DEFAULT NULL,
  `front_side_whatsapp_to` time DEFAULT NULL,
  `admin_panel_whatsapp` int NOT NULL DEFAULT '0',
  `admin_panel_whatsapp_mobile` varchar(50) DEFAULT NULL,
  `admin_panel_whatsapp_from` time DEFAULT NULL,
  `admin_panel_whatsapp_to` time DEFAULT NULL,
  `student_panel_whatsapp` int NOT NULL DEFAULT '0',
  `student_panel_whatsapp_mobile` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `student_panel_whatsapp_from` time DEFAULT NULL,
  `student_panel_whatsapp_to` time DEFAULT NULL,
  `saas_key` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `sections`
--

CREATE TABLE `languages` (
  `id` int NOT NULL,
  `language` varchar(50) DEFAULT NULL,
  `short_code` varchar(255) NOT NULL,
  `country_code` varchar(255) NOT NULL,
  `is_rtl` int NOT NULL,
  `is_deleted` varchar(10) NOT NULL DEFAULT 'yes',
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `leave_types`
--

CREATE TABLE `filetypes` (
  `id` int NOT NULL,
  `file_extension` text,
  `file_mime` text,
  `file_size` int NOT NULL,
  `image_extension` text,
  `image_mime` text,
  `image_size` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `follow_up`
--

CREATE TABLE `currencies` (
  `id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `short_name` varchar(100) DEFAULT NULL,
  `symbol` varchar(10) DEFAULT NULL,
  `base_price` varchar(10) NOT NULL DEFAULT '1',
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `custom_fields`
--

CREATE TABLE `sessions` (
  `id` int NOT NULL,
  `session` varchar(60) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `share_contents`
--

CREATE TABLE `sidebar_menus` (
  `id` int NOT NULL,
  `product_name` varchar(50) NOT NULL,
  `permission_group_id` int DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `menu` varchar(500) DEFAULT NULL,
  `activate_menu` varchar(100) DEFAULT NULL,
  `lang_key` varchar(250) NOT NULL,
  `system_level` int DEFAULT '0',
  `level` int DEFAULT NULL,
  `sidebar_display` int DEFAULT '0',
  `access_permissions` text,
  `is_active` int NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `sidebar_sub_menus`
--

CREATE TABLE `sidebar_sub_menus` (
  `id` int NOT NULL,
  `sidebar_menu_id` int DEFAULT NULL,
  `menu` varchar(500) DEFAULT NULL,
  `key` varchar(500) DEFAULT NULL,
  `lang_key` varchar(250) DEFAULT NULL,
  `url` text,
  `level` int DEFAULT NULL,
  `access_permissions` varchar(500) DEFAULT NULL,
  `permission_group_id` int DEFAULT NULL,
  `activate_controller` varchar(100) DEFAULT NULL COMMENT 'income',
  `activate_methods` varchar(500) DEFAULT NULL COMMENT 'index,edit',
  `addon_permission` varchar(100) DEFAULT NULL,
  `is_active` int DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `sms_config`
--

CREATE TABLE `front_cms_settings` (
  `id` int NOT NULL,
  `theme` varchar(50) DEFAULT NULL,
  `is_active_rtl` int DEFAULT '0',
  `is_active_front_cms` int DEFAULT '0',
  `is_active_sidebar` int DEFAULT '0',
  `logo` varchar(200) DEFAULT NULL,
  `contact_us_email` varchar(100) DEFAULT NULL,
  `complain_form_email` varchar(100) DEFAULT NULL,
  `sidebar_options` text NOT NULL,
  `whatsapp_url` varchar(255) NOT NULL,
  `fb_url` varchar(200) NOT NULL,
  `twitter_url` varchar(200) NOT NULL,
  `youtube_url` varchar(200) NOT NULL,
  `google_plus` varchar(200) NOT NULL,
  `instagram_url` varchar(200) NOT NULL,
  `pinterest_url` varchar(200) NOT NULL,
  `linkedin_url` varchar(200) NOT NULL,
  `google_analytics` text,
  `footer_text` varchar(500) DEFAULT NULL,
  `cookie_consent` varchar(255) NOT NULL,
  `fav_icon` varchar(250) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `gateway_ins`
--

-- ============================================================================
-- COMMUNICATION TABLES (8 tables)
-- ============================================================================

CREATE TABLE `send_notification` (
  `id` int NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `publish_date` date DEFAULT NULL,
  `date` date DEFAULT NULL,
  `attachment` varchar(500) DEFAULT NULL,
  `message` text,
  `visible_student` varchar(10) NOT NULL DEFAULT 'no',
  `visible_staff` varchar(10) NOT NULL DEFAULT 'no',
  `visible_parent` varchar(10) NOT NULL DEFAULT 'no',
  `created_by` varchar(60) DEFAULT NULL,
  `created_id` int DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `messages` (
  `id` int NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `template_id` varchar(100) DEFAULT NULL,
  `email_template_id` int DEFAULT NULL,
  `sms_template_id` int DEFAULT NULL,
  `send_through` varchar(20) DEFAULT NULL,
  `message` text,
  `send_mail` varchar(10) DEFAULT '0',
  `send_sms` varchar(10) DEFAULT '0',
  `is_group` varchar(10) DEFAULT '0',
  `is_individual` varchar(10) DEFAULT '0',
  `is_class` int NOT NULL DEFAULT '0',
  `is_schedule` int NOT NULL,
  `sent` int DEFAULT NULL,
  `schedule_date_time` datetime DEFAULT NULL,
  `group_list` text,
  `user_list` text,
  `send_to` varchar(255) DEFAULT NULL,
  `schedule_class` int DEFAULT NULL,
  `schedule_section` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `email_config` (
  `id` int UNSIGNED NOT NULL,
  `email_type` varchar(100) DEFAULT NULL,
  `smtp_server` varchar(100) DEFAULT NULL,
  `smtp_port` varchar(100) DEFAULT NULL,
  `smtp_email` varchar(255) DEFAULT NULL,
  `smtp_username` varchar(100) DEFAULT NULL,
  `smtp_password` varchar(100) DEFAULT NULL,
  `ssl_tls` varchar(100) DEFAULT NULL,
  `smtp_auth` varchar(10) NOT NULL,
  `api_key` varchar(255) DEFAULT NULL,
  `api_secret` varchar(255) DEFAULT NULL,
  `region` varchar(255) DEFAULT NULL,
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `email_template`
--

CREATE TABLE `sms_config` (
  `id` int NOT NULL,
  `type` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `api_id` varchar(100) NOT NULL,
  `authkey` varchar(100) NOT NULL,
  `senderid` varchar(100) NOT NULL,
  `contact` text,
  `username` varchar(150) DEFAULT NULL,
  `url` varchar(150) DEFAULT NULL,
  `password` varchar(150) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'disabled',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `sms_template`
--

CREATE TABLE `notification_setting` (
  `id` int NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `is_mail` varchar(10) DEFAULT '0',
  `is_sms` varchar(10) DEFAULT '0',
  `is_notification` int NOT NULL DEFAULT '0',
  `display_notification` int NOT NULL DEFAULT '0',
  `display_sms` int NOT NULL DEFAULT '1',
  `is_student_recipient` int DEFAULT NULL,
  `is_guardian_recipient` int DEFAULT NULL,
  `is_staff_recipient` int DEFAULT NULL,
  `display_student_recipient` int DEFAULT NULL,
  `display_guardian_recipient` int DEFAULT NULL,
  `display_staff_recipient` int DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `template_id` varchar(100) NOT NULL,
  `template` longtext NOT NULL,
  `variables` text NOT NULL,
  `notification_order` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `offline_fees_payments`
--

CREATE TABLE `read_notification` (
  `id` int NOT NULL,
  `student_id` int DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `notification_id` int DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `reference`
--

CREATE TABLE `email_template` (
  `id` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `created_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `email_template_attachment`
--

CREATE TABLE `sms_template` (
  `id` int NOT NULL,
  `title` varchar(100) NOT NULL,
  `message` text NOT NULL,
   `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `source`
--

-- ============================================================================
-- INFRASTRUCTURE TABLES (4 tables)
-- ============================================================================

CREATE TABLE `migrations` (
  `version` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `notification_roles`
--

CREATE TABLE `captcha` (
  `id` int NOT NULL,
  `name` varchar(250) NOT NULL,
  `status` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `logs` (
  `id` int NOT NULL,
  `message` text,
  `record_id` text,
  `user_id` int DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `platform` varchar(50) DEFAULT NULL,
  `agent` varchar(50) DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `mark_divisions`
--

CREATE TABLE `notification_roles` (
  `id` int NOT NULL,
  `send_notification_id` int DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `notification_setting`
--

-- ============================================================================
-- CONTENT TABLES (6 tables)
-- Structure only - will link to TVET academic model via migration 009
-- ============================================================================

CREATE TABLE `contents` (
  `id` int NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `is_public` varchar(10) DEFAULT 'No',
  `class_id` int DEFAULT NULL,
  `cls_sec_id` int DEFAULT NULL,
  `file` varchar(250) DEFAULT NULL,
  `date` date NOT NULL,
  `note` text,
  `is_active` varchar(255) DEFAULT 'no',
  `created_by` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `content_for`
--

CREATE TABLE `content_for` (
  `id` int NOT NULL,
  `role` varchar(50) DEFAULT NULL,
  `content_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `content_types`
--

CREATE TABLE `content_types` (
  `id` int NOT NULL,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  `is_active` int DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `cumulative_fine`
--

CREATE TABLE `homework` (
  `id` int NOT NULL,
  `class_id` int NOT NULL,
  `section_id` int NOT NULL,
  `session_id` int NOT NULL,
  `staff_id` int NOT NULL,
  `subject_group_subject_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `homework_date` date NOT NULL,
  `submit_date` date NOT NULL,
  `marks` float(10,2) DEFAULT NULL,
  `description` text,
  `create_date` date NOT NULL,
  `evaluation_date` date DEFAULT NULL,
  `document` varchar(200) DEFAULT NULL,
  `created_by` int NOT NULL,
  `evaluated_by` int DEFAULT NULL,
   `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `homework_evaluation`
--

CREATE TABLE `lesson` (
  `id` int NOT NULL,
  `session_id` int NOT NULL,
  `subject_group_subject_id` int NOT NULL,
  `subject_group_class_sections_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `lesson_plan_forum`
--

CREATE TABLE `daily_assignment` (
  `id` int NOT NULL,
  `student_session_id` int NOT NULL,
  `subject_group_subject_id` int NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `attachment` varchar(255) DEFAULT NULL,
  `evaluated_by` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `evaluation_date` date DEFAULT NULL,
  `remark` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `department`
--

-- ============================================================================
-- SUPPORTING TABLES (17 tables)
-- ============================================================================

CREATE TABLE `attendence_type` (
  `id` int NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `key_value` varchar(50) NOT NULL,
  `long_lang_name` varchar(250) DEFAULT NULL,
  `long_name_style` varchar(250) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `for_qr_attendance` int NOT NULL DEFAULT '1',
  `for_schedule` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `categories` (
  `id` int NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `certificates`
--

CREATE TABLE `complaint_type` (
  `id` int NOT NULL,
  `complaint_type` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `contents`
--

CREATE TABLE `custom_field_values` (
  `id` int NOT NULL,
  `belong_table_id` int DEFAULT NULL,
  `custom_field_id` int DEFAULT NULL,
  `field_value` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `daily_assignment`
--

CREATE TABLE `custom_fields` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `belong_to` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `bs_column` int DEFAULT NULL,
  `validation` int DEFAULT '0',
  `field_values` text,
  `show_table` varchar(100) DEFAULT NULL,
  `visible_on_table` int NOT NULL,
  `weight` int DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `custom_field_values`
--

CREATE TABLE `department` (
  `id` int NOT NULL,
  `department_name` varchar(200) NOT NULL,
  `is_active` varchar(100) NOT NULL,
   `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `disable_reason`
--

CREATE TABLE `disable_reason` (
  `id` int NOT NULL,
  `reason` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `dispatch_receive`
--

CREATE TABLE `enquiry_type` (
  `id` int NOT NULL,
  `enquiry_type` varchar(100) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `holiday_type` (
  `id` int NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `is_default` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `homework`
--

CREATE TABLE `item_category` (
  `id` int NOT NULL,
  `item_category` varchar(255) NOT NULL,
  `is_active` varchar(255) NOT NULL DEFAULT 'yes',
  `description` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `item_issue`
--

CREATE TABLE `leave_types` (
  `id` int NOT NULL,
  `type` varchar(200) NOT NULL,
  `is_active` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `lesson`
--

CREATE TABLE `reference` (
  `id` int NOT NULL,
  `reference` varchar(100) NOT NULL,
  `description` text NOT NULL,
`created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `resume_additional_fields_settings`
--

CREATE TABLE `source` (
  `id` int NOT NULL,
  `source` varchar(100) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff_attendance_type` (
  `id` int NOT NULL,
  `type` varchar(200) NOT NULL,
  `key_value` varchar(200) NOT NULL,
  `is_active` varchar(50) NOT NULL,
  `for_qr_attendance` int NOT NULL DEFAULT '1',
  `long_lang_name` varchar(250) DEFAULT NULL,
  `long_name_style` varchar(250) DEFAULT NULL,
  `for_schedule` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Table structure for table `staff_attendence_schedules`
--

CREATE TABLE `staff_designation` (
  `id` int NOT NULL,
  `designation` varchar(200) NOT NULL,
  `is_active` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `staff_id_card`
--

CREATE TABLE `staff_roles` (
  `id` int NOT NULL,
  `role_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `staff_timeline`
--

CREATE TABLE `visitors_purpose` (
  `id` int NOT NULL,
  `visitors_purpose` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addons`
--

--
-- Indexes for table `addon_versions`
--

--
-- Indexes for table `alumni_events`
--

--
-- Indexes for table `alumni_students`
--

--
-- Indexes for table `annual_calendar`
--

--
-- Indexes for table `attendence_type`
--

--
-- Indexes for table `books`
--

--
-- Indexes for table `book_issues`
--

--
-- Indexes for table `captcha`
--

--
-- Indexes for table `categories`
--

--
-- Indexes for table `certificates`
--

--
-- Indexes for table `chat_connections`
--

--
-- Indexes for table `chat_messages`
--

--
-- Indexes for table `chat_users`
--

--
-- Indexes for table `classes`
--

--
-- Indexes for table `class_sections`
--

--
-- Indexes for table `class_section_times`
--

--
-- Indexes for table `class_teacher`
--

--
-- Indexes for table `complaint`
--

--
-- Indexes for table `complaint_type`
--

--
-- Indexes for table `contents`
--

--
-- Indexes for table `content_for`
--

--
-- Indexes for table `content_types`
--

--
-- Indexes for table `cumulative_fine`
--

--
-- Indexes for table `currencies`
--

--
-- Indexes for table `custom_fields`
--

--
-- Indexes for table `custom_field_values`
--

--
-- Indexes for table `daily_assignment`
--

--
-- Indexes for table `department`
--

--
-- Indexes for table `disable_reason`
--

--
-- Indexes for table `dispatch_receive`
--

--
-- Indexes for table `email_attachments`
--

--
-- Indexes for table `email_config`
--

--
-- Indexes for table `email_template`
--

--
-- Indexes for table `email_template_attachment`
--

--
-- Indexes for table `enquiry`
--

--
-- Indexes for table `enquiry_type`
--

--
-- Indexes for table `events`
--

--
-- Indexes for table `exams`
--

--
-- Indexes for table `exam_groups`
--

--
-- Indexes for table `exam_group_class_batch_exams`
--

--
-- Indexes for table `exam_group_class_batch_exam_students`
--

--
-- Indexes for table `exam_group_class_batch_exam_subjects`
--

--
-- Indexes for table `exam_group_exam_connections`
--

--
-- Indexes for table `exam_group_exam_results`
--

--
-- Indexes for table `exam_group_students`
--

--
-- Indexes for table `exam_schedules`
--

--
-- Indexes for table `expenses`
--

--
-- Indexes for table `expense_head`
--

--
-- Indexes for table `feemasters`
--

--
-- Indexes for table `fees_discounts`
--

--
-- Indexes for table `fees_reminder`
--

--
-- Indexes for table `feetype`
--

--
-- Indexes for table `fee_groups`
--

--
-- Indexes for table `fee_groups_feetype`
--

--
-- Indexes for table `fee_receipt_no`
--

--
-- Indexes for table `fee_session_groups`
--

--
-- Indexes for table `filetypes`
--

--
-- Indexes for table `follow_up`
--

--
-- Indexes for table `front_cms_media_gallery`
--

--
-- Indexes for table `front_cms_menus`
--

--
-- Indexes for table `front_cms_menu_items`
--

--
-- Indexes for table `front_cms_pages`
--

--
-- Indexes for table `front_cms_page_contents`
--

--
-- Indexes for table `front_cms_programs`
--

--
-- Indexes for table `front_cms_program_photos`
--

--
-- Indexes for table `front_cms_settings`
--

--
-- Indexes for table `gateway_ins`
--

--
-- Indexes for table `gateway_ins_response`
--

--
-- Indexes for table `general_calls`
--

--
-- Indexes for table `grades`
--

--
-- Indexes for table `holiday_type`
--

--
-- Indexes for table `homework`
--

--
-- Indexes for table `homework_evaluation`
--

--
-- Indexes for table `hostel`
--

--
-- Indexes for table `hostel_rooms`
--

--
-- Indexes for table `id_card`
--

--
-- Indexes for table `income`
--

--
-- Indexes for table `income_head`
--

--
-- Indexes for table `item`
--

--
-- Indexes for table `item_category`
--

--
-- Indexes for table `item_issue`
--

--
-- Indexes for table `item_stock`
--

--
-- Indexes for table `item_store`
--

--
-- Indexes for table `item_supplier`
--

--
-- Indexes for table `languages`
--

--
-- Indexes for table `leave_types`
--

--
-- Indexes for table `lesson`
--

--
-- Indexes for table `lesson_plan_forum`
--

--
-- Indexes for table `libarary_members`
--

--
-- Indexes for table `logs`
--

--
-- Indexes for table `mark_divisions`
--

--
-- Indexes for table `messages`
--

--
-- Indexes for table `notification_roles`
--

--
-- Indexes for table `notification_setting`
--

--
-- Indexes for table `offline_fees_payments`
--

--
-- Indexes for table `onlineexam`
--

--
-- Indexes for table `onlineexam_attempts`
--

--
-- Indexes for table `onlineexam_questions`
--

--
-- Indexes for table `onlineexam_students`
--

--
-- Indexes for table `onlineexam_student_results`
--

--
-- Indexes for table `online_admissions`
--

--
-- Indexes for table `online_admission_custom_field_value`
--

--
-- Indexes for table `online_admission_fields`
--

--
-- Indexes for table `online_admission_payment`
--

--
-- Indexes for table `payment_settings`
--

--
-- Indexes for table `payslip_allowance`
--

--
-- Indexes for table `permission_category`
--

--
-- Indexes for table `permission_group`
--

--
-- Indexes for table `permission_student`
--

--
-- Indexes for table `pickup_point`
--

--
-- Indexes for table `print_headerfooter`
--

--
-- Indexes for table `questions`
--

--
-- Indexes for table `read_notification`
--

--
-- Indexes for table `reference`
--

--
-- Indexes for table `resume_additional_fields_settings`
--

--
-- Indexes for table `resume_settings_fields`
--

--
-- Indexes for table `roles`
--

--
-- Indexes for table `roles_permissions`
--

--
-- Indexes for table `room_types`
--

--
-- Indexes for table `route_pickup_point`
--

--
-- Indexes for table `school_houses`
--

--
-- Indexes for table `sch_settings`
--

--
-- Indexes for table `sections`
--

--
-- Indexes for table `send_notification`
--

--
-- Indexes for table `sessions`
--

--
-- Indexes for table `share_contents`
--

--
-- Indexes for table `share_content_for`
--

--
-- Indexes for table `share_upload_contents`
--

--
-- Indexes for table `sidebar_menus`
--

--
-- Indexes for table `sidebar_sub_menus`
--

--
-- Indexes for table `sms_config`
--

--
-- Indexes for table `sms_template`
--

--
-- Indexes for table `source`
--

--
-- Indexes for table `staff`
--

--
-- Indexes for table `staff_attendance`
--

--
-- Indexes for table `staff_attendance_type`
--

--
-- Indexes for table `staff_attendence_schedules`
--

--
-- Indexes for table `staff_designation`
--

--
-- Indexes for table `staff_id_card`
--

--
-- Indexes for table `staff_leave_details`
--

--
-- Indexes for table `staff_leave_request`
--

--
-- Indexes for table `staff_payroll`
--

--
-- Indexes for table `staff_payslip`
--

--
-- Indexes for table `staff_rating`
--

--
-- Indexes for table `staff_roles`
--

--
-- Indexes for table `staff_timeline`
--

--
-- Indexes for table `students`
--

--
-- Indexes for table `student_applied_discounts`
--

--
-- Indexes for table `student_applyleave`
--

--
-- Indexes for table `student_attendences`
--

--
-- Indexes for table `student_attendence_schedules`
--

--
-- Indexes for table `student_dashboard_settings`
--

--
-- Indexes for table `student_doc`
--

--
-- Indexes for table `student_edit_fields`
--

--
-- Indexes for table `student_educational_details`
--

--
-- Indexes for table `student_fees`
--

--
-- Indexes for table `student_fees_deposite`
--

--
-- Indexes for table `student_fees_discounts`
--

--
-- Indexes for table `student_fees_master`
--

--
-- Indexes for table `student_fees_processing`
--

--
-- Indexes for table `student_refrence`
--

--
-- Indexes for table `student_session`
--

--
-- Indexes for table `student_skills_detail`
--

--
-- Indexes for table `student_subject_attendances`
--

--
-- Indexes for table `student_timeline`
--

--
-- Indexes for table `student_transport_fees`
--

--
-- Indexes for table `student_work_experience`
--

--
-- Indexes for table `subjects`
--

--
-- Indexes for table `subject_groups`
--

--
-- Indexes for table `subject_group_class_sections`
--

--
-- Indexes for table `subject_group_subjects`
--

--
-- Indexes for table `subject_syllabus`
--

--
-- Indexes for table `subject_timetable`
--

--
-- Indexes for table `submit_assignment`
--

--
-- Indexes for table `template_admitcards`
--

--
-- Indexes for table `template_marksheets`
--

--
-- Indexes for table `topic`
--

--
-- Indexes for table `transport_feemaster`
--

--
-- Indexes for table `transport_route`
--

--
-- Indexes for table `upload_contents`
--

--
-- Indexes for table `userlog`
--

--
-- Indexes for table `users`
--

--
-- Indexes for table `users_authentication`
--

--
-- Indexes for table `vehicles`
--

--
-- Indexes for table `vehicle_routes`
--

--
-- Indexes for table `video_tutorial`
--

--
-- Indexes for table `video_tutorial_class_sections`
--

--
-- Indexes for table `visitors_book`
--

--
-- Indexes for table `visitors_purpose`
--
ALTER TABLE `visitors_purpose`

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addons`
--

--
-- AUTO_INCREMENT for table `addon_versions`
--

--
-- AUTO_INCREMENT for table `alumni_events`
--

--
-- AUTO_INCREMENT for table `alumni_students`
--

--
-- AUTO_INCREMENT for table `annual_calendar`
--

--
-- AUTO_INCREMENT for table `attendence_type`
--

--
-- AUTO_INCREMENT for table `books`
--

--
-- AUTO_INCREMENT for table `book_issues`
--

--
-- AUTO_INCREMENT for table `captcha`
--

--
-- AUTO_INCREMENT for table `categories`
--

--
-- AUTO_INCREMENT for table `certificates`
--

--
-- AUTO_INCREMENT for table `chat_connections`
--

--
-- AUTO_INCREMENT for table `chat_messages`
--

--
-- AUTO_INCREMENT for table `chat_users`
--

--
-- AUTO_INCREMENT for table `classes`
--

--
-- AUTO_INCREMENT for table `class_sections`
--

--
-- AUTO_INCREMENT for table `class_section_times`
--

--
-- AUTO_INCREMENT for table `class_teacher`
--

--
-- AUTO_INCREMENT for table `complaint`
--

--
-- AUTO_INCREMENT for table `complaint_type`
--

--
-- AUTO_INCREMENT for table `contents`
--

--
-- AUTO_INCREMENT for table `content_for`
--

--
-- AUTO_INCREMENT for table `content_types`
--

--
-- AUTO_INCREMENT for table `cumulative_fine`
--

--
-- AUTO_INCREMENT for table `currencies`
--

--
-- AUTO_INCREMENT for table `custom_fields`
--

--
-- AUTO_INCREMENT for table `custom_field_values`
--

--
-- AUTO_INCREMENT for table `daily_assignment`
--

--
-- AUTO_INCREMENT for table `department`
--

--
-- AUTO_INCREMENT for table `disable_reason`
--

--
-- AUTO_INCREMENT for table `dispatch_receive`
--

--
-- AUTO_INCREMENT for table `email_attachments`
--

--
-- AUTO_INCREMENT for table `email_config`
--

--
-- AUTO_INCREMENT for table `email_template`
--

--
-- AUTO_INCREMENT for table `email_template_attachment`
--

--
-- AUTO_INCREMENT for table `enquiry`
--

--
-- AUTO_INCREMENT for table `enquiry_type`
--

--
-- AUTO_INCREMENT for table `events`
--

--
-- AUTO_INCREMENT for table `exams`
--

--
-- AUTO_INCREMENT for table `exam_groups`
--

--
-- AUTO_INCREMENT for table `exam_group_class_batch_exams`
--

--
-- AUTO_INCREMENT for table `exam_group_class_batch_exam_students`
--

--
-- AUTO_INCREMENT for table `exam_group_class_batch_exam_subjects`
--

--
-- AUTO_INCREMENT for table `exam_group_exam_connections`
--

--
-- AUTO_INCREMENT for table `exam_group_exam_results`
--

--
-- AUTO_INCREMENT for table `exam_group_students`
--

--
-- AUTO_INCREMENT for table `exam_schedules`
--

--
-- AUTO_INCREMENT for table `expenses`
--

--
-- AUTO_INCREMENT for table `expense_head`
--

--
-- AUTO_INCREMENT for table `feemasters`
--

--
-- AUTO_INCREMENT for table `fees_discounts`
--

--
-- AUTO_INCREMENT for table `fees_reminder`
--

--
-- AUTO_INCREMENT for table `feetype`
--

--
-- AUTO_INCREMENT for table `fee_groups`
--

--
-- AUTO_INCREMENT for table `fee_groups_feetype`
--

--
-- AUTO_INCREMENT for table `fee_receipt_no`
--

--
-- AUTO_INCREMENT for table `fee_session_groups`
--

--
-- AUTO_INCREMENT for table `filetypes`
--

--
-- AUTO_INCREMENT for table `follow_up`
--

--
-- AUTO_INCREMENT for table `front_cms_media_gallery`
--

--
-- AUTO_INCREMENT for table `front_cms_menus`
--

--
-- AUTO_INCREMENT for table `front_cms_menu_items`
--

--
-- AUTO_INCREMENT for table `front_cms_pages`
--

--
-- AUTO_INCREMENT for table `front_cms_page_contents`
--

--
-- AUTO_INCREMENT for table `front_cms_programs`
--

--
-- AUTO_INCREMENT for table `front_cms_program_photos`
--

--
-- AUTO_INCREMENT for table `front_cms_settings`
--

--
-- AUTO_INCREMENT for table `gateway_ins`
--

--
-- AUTO_INCREMENT for table `gateway_ins_response`
--

--
-- AUTO_INCREMENT for table `general_calls`
--

--
-- AUTO_INCREMENT for table `grades`
--

--
-- AUTO_INCREMENT for table `holiday_type`
--

--
-- AUTO_INCREMENT for table `homework`
--

--
-- AUTO_INCREMENT for table `homework_evaluation`
--

--
-- AUTO_INCREMENT for table `hostel`
--

--
-- AUTO_INCREMENT for table `hostel_rooms`
--

--
-- AUTO_INCREMENT for table `id_card`
--

--
-- AUTO_INCREMENT for table `income`
--

--
-- AUTO_INCREMENT for table `income_head`
--

--
-- AUTO_INCREMENT for table `item`
--

--
-- AUTO_INCREMENT for table `item_category`
--

--
-- AUTO_INCREMENT for table `item_issue`
--

--
-- AUTO_INCREMENT for table `item_stock`
--

--
-- AUTO_INCREMENT for table `item_store`
--

--
-- AUTO_INCREMENT for table `item_supplier`
--

--
-- AUTO_INCREMENT for table `languages`
--

--
-- AUTO_INCREMENT for table `leave_types`
--

--
-- AUTO_INCREMENT for table `lesson`
--

--
-- AUTO_INCREMENT for table `lesson_plan_forum`
--

--
-- AUTO_INCREMENT for table `libarary_members`
--

--
-- AUTO_INCREMENT for table `logs`
--

--
-- AUTO_INCREMENT for table `mark_divisions`
--

--
-- AUTO_INCREMENT for table `messages`
--

--
-- AUTO_INCREMENT for table `notification_roles`
--

--
-- AUTO_INCREMENT for table `notification_setting`
--

--
-- AUTO_INCREMENT for table `offline_fees_payments`
--

--
-- AUTO_INCREMENT for table `onlineexam`
--

--
-- AUTO_INCREMENT for table `onlineexam_attempts`
--

--
-- AUTO_INCREMENT for table `onlineexam_questions`
--

--
-- AUTO_INCREMENT for table `onlineexam_students`
--

--
-- AUTO_INCREMENT for table `onlineexam_student_results`
--

--
-- AUTO_INCREMENT for table `online_admissions`
--

--
-- AUTO_INCREMENT for table `online_admission_custom_field_value`
--

--
-- AUTO_INCREMENT for table `online_admission_fields`
--

--
-- AUTO_INCREMENT for table `online_admission_payment`
--

--
-- AUTO_INCREMENT for table `payment_settings`
--

--
-- AUTO_INCREMENT for table `payslip_allowance`
--

--
-- AUTO_INCREMENT for table `permission_category`
--

--
-- AUTO_INCREMENT for table `permission_group`
--

--
-- AUTO_INCREMENT for table `permission_student`
--

--
-- AUTO_INCREMENT for table `pickup_point`
--

--
-- AUTO_INCREMENT for table `print_headerfooter`
--

--
-- AUTO_INCREMENT for table `questions`
--

--
-- AUTO_INCREMENT for table `read_notification`
--

--
-- AUTO_INCREMENT for table `reference`
--

--
-- AUTO_INCREMENT for table `resume_additional_fields_settings`
--

--
-- AUTO_INCREMENT for table `resume_settings_fields`
--

--
-- AUTO_INCREMENT for table `roles`
--

--
-- AUTO_INCREMENT for table `roles_permissions`
--

--
-- AUTO_INCREMENT for table `room_types`
--

--
-- AUTO_INCREMENT for table `route_pickup_point`
--

--
-- AUTO_INCREMENT for table `school_houses`
--

--
-- AUTO_INCREMENT for table `sections`
--

--
-- AUTO_INCREMENT for table `send_notification`
--

--
-- AUTO_INCREMENT for table `sessions`
--

--
-- AUTO_INCREMENT for table `share_contents`
--

--
-- AUTO_INCREMENT for table `share_content_for`
--

--
-- AUTO_INCREMENT for table `share_upload_contents`
--

--
-- AUTO_INCREMENT for table `sidebar_menus`
--

--
-- AUTO_INCREMENT for table `sidebar_sub_menus`
--

--
-- AUTO_INCREMENT for table `sms_config`
--

--
-- AUTO_INCREMENT for table `sms_template`
--

--
-- AUTO_INCREMENT for table `source`
--

--
-- AUTO_INCREMENT for table `staff`
--

--
-- AUTO_INCREMENT for table `staff_attendance`
--

--
-- AUTO_INCREMENT for table `staff_attendance_type`
--

--
-- AUTO_INCREMENT for table `staff_attendence_schedules`
--

--
-- AUTO_INCREMENT for table `staff_designation`
--

--
-- AUTO_INCREMENT for table `staff_id_card`
--

--
-- AUTO_INCREMENT for table `staff_leave_details`
--

--
-- AUTO_INCREMENT for table `staff_leave_request`
--

--
-- AUTO_INCREMENT for table `staff_payroll`
--

--
-- AUTO_INCREMENT for table `staff_payslip`
--

--
-- AUTO_INCREMENT for table `staff_rating`
--

--
-- AUTO_INCREMENT for table `staff_roles`
--

--
-- AUTO_INCREMENT for table `staff_timeline`
--

--
-- AUTO_INCREMENT for table `students`
--

--
-- AUTO_INCREMENT for table `student_applied_discounts`
--

--
-- AUTO_INCREMENT for table `student_applyleave`
--

--
-- AUTO_INCREMENT for table `student_attendences`
--

--
-- AUTO_INCREMENT for table `student_attendence_schedules`
--

--
-- AUTO_INCREMENT for table `student_dashboard_settings`
--

--
-- AUTO_INCREMENT for table `student_doc`
--

--
-- AUTO_INCREMENT for table `student_edit_fields`
--

--
-- AUTO_INCREMENT for table `student_educational_details`
--

--
-- AUTO_INCREMENT for table `student_fees`
--

--
-- AUTO_INCREMENT for table `student_fees_deposite`
--

--
-- AUTO_INCREMENT for table `student_fees_discounts`
--

--
-- AUTO_INCREMENT for table `student_fees_master`
--

--
-- AUTO_INCREMENT for table `student_fees_processing`
--

--
-- AUTO_INCREMENT for table `student_refrence`
--

--
-- AUTO_INCREMENT for table `student_session`
--

--
-- AUTO_INCREMENT for table `student_skills_detail`
--

--
-- AUTO_INCREMENT for table `student_subject_attendances`
--

--
-- AUTO_INCREMENT for table `student_timeline`
--

--
-- AUTO_INCREMENT for table `student_transport_fees`
--

--
-- AUTO_INCREMENT for table `student_work_experience`
--

--
-- AUTO_INCREMENT for table `subjects`
--

--
-- AUTO_INCREMENT for table `subject_groups`
--

--
-- AUTO_INCREMENT for table `subject_group_class_sections`
--

--
-- AUTO_INCREMENT for table `subject_group_subjects`
--

--
-- AUTO_INCREMENT for table `subject_syllabus`
--

--
-- AUTO_INCREMENT for table `subject_timetable`
--

--
-- AUTO_INCREMENT for table `submit_assignment`
--

--
-- AUTO_INCREMENT for table `template_admitcards`
--

--
-- AUTO_INCREMENT for table `template_marksheets`
--

--
-- AUTO_INCREMENT for table `topic`
--

--
-- AUTO_INCREMENT for table `transport_feemaster`
--

--
-- AUTO_INCREMENT for table `transport_route`
--

--
-- AUTO_INCREMENT for table `upload_contents`
--

--
-- AUTO_INCREMENT for table `userlog`
--

--
-- AUTO_INCREMENT for table `users`
--

--
-- AUTO_INCREMENT for table `users_authentication`
--

--
-- AUTO_INCREMENT for table `vehicles`
--

--
-- AUTO_INCREMENT for table `vehicle_routes`
--

--
-- AUTO_INCREMENT for table `video_tutorial`
--

--
-- AUTO_INCREMENT for table `video_tutorial_class_sections`
--

--
-- AUTO_INCREMENT for table `visitors_book`
--

--
-- AUTO_INCREMENT for table `visitors_purpose`
--
ALTER TABLE `visitors_purpose`

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addon_versions`
--

--
-- Constraints for table `alumni_events`
--

--
-- Constraints for table `alumni_students`
--

--
-- Constraints for table `annual_calendar`
--

--
-- Constraints for table `book_issues`
--

--
-- Constraints for table `chat_connections`
--

--
-- Constraints for table `chat_messages`
--

--
-- Constraints for table `chat_users`
--

--
-- Constraints for table `class_sections`
--

--
-- Constraints for table `class_section_times`
--

--
-- Constraints for table `class_teacher`
--

--
-- Constraints for table `contents`
--

--
-- Constraints for table `content_for`
--

--
-- Constraints for table `custom_field_values`
--

--
-- Constraints for table `daily_assignment`
--

--
-- Constraints for table `email_attachments`
--

--
-- Constraints for table `enquiry`
--

--
-- Constraints for table `events`
--

--
-- Constraints for table `exams`
--

--
-- Constraints for table `exam_group_class_batch_exams`
--

--
-- Constraints for table `exam_group_class_batch_exam_students`
--

--
-- Constraints for table `exam_group_class_batch_exam_subjects`
--

--
-- Constraints for table `exam_group_exam_connections`
--

--
-- Constraints for table `exam_group_exam_results`
--

--
-- Constraints for table `exam_group_students`
--

--
-- Constraints for table `exam_schedules`
--

--
-- Constraints for table `expenses`
--

--
-- Constraints for table `feemasters`
--

--
-- Constraints for table `fees_discounts`
--

--
-- Constraints for table `fee_groups_feetype`
--

--
-- Constraints for table `fee_session_groups`
--

--
-- Constraints for table `follow_up`
--

--
-- Constraints for table `front_cms_menu_items`
--

--
-- Constraints for table `front_cms_page_contents`
--

--
-- Constraints for table `front_cms_program_photos`
--

--
-- Constraints for table `gateway_ins`
--

--
-- Constraints for table `gateway_ins_response`
--

--
-- Constraints for table `homework`
--

--
-- Constraints for table `homework_evaluation`
--

--
-- Constraints for table `hostel_rooms`
--

--
-- Constraints for table `income`
--

--
-- Constraints for table `item`
--

--
-- Constraints for table `item_issue`
--

--
-- Constraints for table `item_stock`
--

--
-- Constraints for table `lesson`
--

--
-- Constraints for table `lesson_plan_forum`
--

--
-- Constraints for table `notification_roles`
--

--
-- Constraints for table `offline_fees_payments`
--

--
-- Constraints for table `onlineexam`
--

--
-- Constraints for table `onlineexam_attempts`
--

--
-- Constraints for table `onlineexam_questions`
--

--
-- Constraints for table `onlineexam_students`
--

--
-- Constraints for table `onlineexam_student_results`
--

--
-- Constraints for table `online_admissions`
--

--
-- Constraints for table `online_admission_custom_field_value`
--

--
-- Constraints for table `online_admission_payment`
--

--
-- Constraints for table `payslip_allowance`
--

--
-- Constraints for table `permission_category`
--

--
-- Constraints for table `permission_student`
--

--
-- Constraints for table `questions`
--

--
-- Constraints for table `read_notification`
--

--
-- Constraints for table `roles_permissions`
--

--
-- Constraints for table `route_pickup_point`
--

--
-- Constraints for table `send_notification`
--

--
-- Constraints for table `share_contents`
--

--
-- Constraints for table `share_content_for`
--

--
-- Constraints for table `share_upload_contents`
--

--
-- Constraints for table `sidebar_menus`
--

--
-- Constraints for table `sidebar_sub_menus`
--

--
-- Constraints for table `staff`
--

--
-- Constraints for table `staff_attendance`
--

--
-- Constraints for table `staff_leave_details`
--

--
-- Constraints for table `staff_leave_request`
--

--
-- Constraints for table `staff_payslip`
--

--
-- Constraints for table `staff_rating`
--

--
-- Constraints for table `staff_roles`
--

--
-- Constraints for table `staff_timeline`
--

--
-- Constraints for table `student_applied_discounts`
--

--
-- Constraints for table `student_applyleave`
--

--
-- Constraints for table `student_attendences`
--

--
-- Constraints for table `student_fees`
--

--
-- Constraints for table `student_fees_deposite`
--

--
-- Constraints for table `student_fees_discounts`
--

--
-- Constraints for table `student_fees_master`
--

--
-- Constraints for table `student_fees_processing`
--

--
-- Constraints for table `student_session`
--

--
-- Constraints for table `student_subject_attendances`
--

--
-- Constraints for table `student_timeline`
--

--
-- Constraints for table `student_transport_fees`
--

--
-- Constraints for table `subject_groups`
--

--
-- Constraints for table `subject_group_class_sections`
--

--
-- Constraints for table `subject_group_subjects`
--

--
-- Constraints for table `subject_syllabus`
--

--
-- Constraints for table `subject_timetable`
--

--
-- Constraints for table `submit_assignment`
--

--
-- Constraints for table `topic`
--

--
-- Constraints for table `transport_feemaster`
--

--
-- Constraints for table `upload_contents`
--

--
-- Constraints for table `userlog`
--

--
-- Constraints for table `vehicle_routes`
--

--
-- Constraints for table `video_tutorial`
--

--
-- Constraints for table `video_tutorial_class_sections`
--

--
-- Constraints for table `visitors_book`
--


-- ============================================================================
-- END OF CORE TABLES
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 1;

-- Next step: Apply migration 009_academic_subject_centric_model.sql to add
-- the 14 TVET academic tables and link them to these core tables.
