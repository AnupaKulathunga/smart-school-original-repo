-- ============================================================================
-- TVET College Management System - Complete Database
-- Single consolidated file for fresh TVET-only deployments
-- Generated: 2026-02-07
-- Total Tables: 193 (52 core + 14 TVET academic + 7 TVET admin + 120 legacy stub)
-- ============================================================================
--
-- This file provides a complete, deployable database for TVET colleges in
-- South Africa. It includes:
--   - 52 core system tables (users, RBAC, settings, communication, content)
--   - 14 TVET academic tables (programmes, subjects, levels, classes, etc.)
--   - 7 TVET admin tables (tvet_programme, tvet_qualification, etc.)
--   - 120 legacy stub tables (for model/controller compatibility)
--   - Essential seed data loaded from 002_seed_data.sql
--   - Default admin user (email: admin@school.com, password: admin123)
--   - Active 2026-27 academic session
--
-- To deploy:
--   docker-compose down -v && docker-compose up -d
--
-- The database will be automatically initialized on first run.
-- ============================================================================

SET SQL_MODE = "";
SET FOREIGN_KEY_CHECKS = 0;

-- MySQL dump 10.13  Distrib 8.0.44, for Linux (aarch64)
--
-- Host: localhost    Database: smart_school
-- ------------------------------------------------------
-- Server version	8.0.44

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addon_versions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `addon_versions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `addon_id` int DEFAULT NULL,
  `version` varchar(50) DEFAULT NULL,
  `version_order` varchar(50) DEFAULT NULL,
  `folder_path` varchar(500) DEFAULT NULL,
  `sort_description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `addon_id` (`addon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `addons`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `addons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  `product_id` varchar(100) DEFAULT NULL,
  `directory` varchar(200) DEFAULT NULL,
  `config_name` varchar(200) DEFAULT NULL,
  `current_version` varchar(50) DEFAULT NULL,
  `product_order` int DEFAULT '0',
  `installation_by` int DEFAULT NULL,
  `uninstall_version` varchar(50) DEFAULT NULL,
  `unistall_by` int DEFAULT NULL,
  `addon_ver` varchar(50) DEFAULT NULL,
  `addon_prod` varchar(100) DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alumni_events`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `alumni_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `event_for` varchar(50) DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section` text,
  `from_date` datetime DEFAULT NULL,
  `to_date` datetime DEFAULT NULL,
  `note` text,
  `event_notification_message` text,
  `photo` varchar(200) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alumni_students`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `alumni_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `current_email` varchar(100) DEFAULT NULL,
  `current_phone` varchar(20) DEFAULT NULL,
  `occupation` varchar(200) DEFAULT NULL,
  `address` text,
  `photo` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_assessment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_assessment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `assessment_type` enum('Test','ICASS','Practical','Assignment','Project','POE','Exam') NOT NULL,
  `icass_component` enum('Task 1','Task 2','Task 3','Task 4','Task 5','Task 6','Task 7','Final') DEFAULT NULL,
  `total_marks` decimal(6,2) NOT NULL DEFAULT '100.00',
  `weight_percentage` decimal(5,2) DEFAULT NULL COMMENT 'Weight in final mark',
  `due_date` datetime DEFAULT NULL,
  `instructions` text,
  `attachments` text,
  `moderation_status` enum('Draft','Pending Moderation','Approved','Rejected') DEFAULT 'Draft',
  `moderator_id` int DEFAULT NULL,
  `moderation_date` datetime DEFAULT NULL,
  `moderation_comments` text,
  `is_published` tinyint(1) DEFAULT '0',
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_type` (`assessment_type`),
  KEY `idx_status` (`moderation_status`),
  KEY `fk_academic_assess_moderator` (`moderator_id`),
  KEY `fk_academic_assess_creator` (`created_by`),
  CONSTRAINT `fk_academic_assess_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_academic_assess_creator` FOREIGN KEY (`created_by`) REFERENCES `staff` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_academic_assess_moderator` FOREIGN KEY (`moderator_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_assessment_marks`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_assessment_marks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assessment_id` int NOT NULL,
  `enrolment_id` int NOT NULL,
  `marks_obtained` decimal(6,2) DEFAULT NULL,
  `percentage` decimal(5,2) DEFAULT NULL,
  `grade` varchar(10) DEFAULT NULL,
  `feedback` text,
  `submission_date` datetime DEFAULT NULL,
  `submission_file` varchar(255) DEFAULT NULL,
  `marked_by` int DEFAULT NULL,
  `marked_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_assess_enrol` (`assessment_id`,`enrolment_id`),
  KEY `idx_assessment` (`assessment_id`),
  KEY `idx_enrolment` (`enrolment_id`),
  CONSTRAINT `fk_academic_marks_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `academic_assessment` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_academic_marks_enrolment` FOREIGN KEY (`enrolment_id`) REFERENCES `academic_class_enrolment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_attendance`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `enrolment_id` int NOT NULL,
  `date` date NOT NULL,
  `status` enum('Present','Absent','Late','Excused') NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `marked_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_attendance` (`enrolment_id`,`date`),
  KEY `idx_class` (`class_id`),
  KEY `idx_enrolment` (`enrolment_id`),
  KEY `idx_date` (`date`),
  CONSTRAINT `fk_academic_att_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_academic_att_enrol` FOREIGN KEY (`enrolment_id`) REFERENCES `academic_class_enrolment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_class`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_class` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_code` varchar(50) NOT NULL COMMENT 'e.g., MATH-N4-A-2026',
  `subject_level_id` int NOT NULL,
  `cohort_name` varchar(50) NOT NULL COMMENT 'e.g., A, B, C, D or Group 1',
  `academic_year` int NOT NULL,
  `session_id` int NOT NULL,
  `intake_period` varchar(20) DEFAULT NULL COMMENT 'Jan, Jul, etc.',
  `delivery_mode` enum('Full-time','Part-time','Evening','Weekend','Distance') DEFAULT 'Full-time',
  `primary_lecturer_id` int DEFAULT NULL,
  `venue` varchar(100) DEFAULT NULL COMMENT 'Room/Lab assignment',
  `max_students` int DEFAULT '50',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('Scheduled','Active','Completed','Cancelled') DEFAULT 'Scheduled',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_code_session` (`class_code`,`session_id`),
  KEY `idx_subject_level` (`subject_level_id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_lecturer` (`primary_lecturer_id`),
  CONSTRAINT `fk_academic_class_lecturer` FOREIGN KEY (`primary_lecturer_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_academic_class_session` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_academic_class_subject_level` FOREIGN KEY (`subject_level_id`) REFERENCES `academic_subject_level` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_class_enrolment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_class_enrolment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `class_id` int NOT NULL,
  `student_session_id` int DEFAULT NULL,
  `enrolment_date` date NOT NULL,
  `status` enum('Active','Completed','Dropped','Suspended','Transferred') DEFAULT 'Active',
  `completion_date` date DEFAULT NULL,
  `final_mark` decimal(5,2) DEFAULT NULL,
  `final_result` enum('Pass','Fail','Incomplete','Pending') DEFAULT 'Pending',
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_class` (`student_id`,`class_id`),
  KEY `idx_student` (`student_id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_academic_enrol_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_academic_enrol_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_class_lecturer`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_class_lecturer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `staff_id` int NOT NULL,
  `role` enum('Primary','Assistant','Tutor','Assessor','Moderator') DEFAULT 'Assistant',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_lecturer` (`class_id`,`staff_id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_staff` (`staff_id`),
  CONSTRAINT `fk_academic_cl_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_academic_cl_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_icass_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_icass_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `component` enum('Task 1','Task 2','Task 3','Task 4','Task 5','Task 6','Task 7','Final') NOT NULL,
  `component_type` enum('Test','Assignment','Project','Practical','Exam','Other') NOT NULL,
  `weight_percentage` decimal(5,2) NOT NULL,
  `pass_percentage` decimal(5,2) DEFAULT '40.00',
  `description` varchar(255) DEFAULT NULL,
  `is_compulsory` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_icass_config` (`class_id`,`component`),
  KEY `idx_class` (`class_id`),
  CONSTRAINT `fk_academic_icass_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_level`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'e.g., N1, N2, NCV2',
  `name` varchar(100) NOT NULL COMMENT 'e.g., NATED Level 1',
  `level_type` enum('NATED','NCV','Other') DEFAULT 'NATED',
  `nqf_level` int DEFAULT NULL COMMENT 'NQF Level 2-6',
  `sequence_order` int DEFAULT '1',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_level_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_moderation_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_moderation_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assessment_id` int NOT NULL,
  `moderator_id` int NOT NULL,
  `action` enum('Submitted','Approved','Rejected','Comment','Revised') NOT NULL,
  `comments` text,
  `previous_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_assessment` (`assessment_id`),
  KEY `idx_moderator` (`moderator_id`),
  CONSTRAINT `fk_academic_mod_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `academic_assessment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_poe_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_poe_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `enrolment_id` int NOT NULL,
  `item_name` varchar(200) NOT NULL,
  `item_type` enum('Assignment','Project','Practical','Test','Reflection','Other') NOT NULL,
  `description` text,
  `file_path` varchar(500) DEFAULT NULL,
  `submitted_date` date NOT NULL,
  `status` enum('Pending','Submitted','Accepted','Rejected') DEFAULT 'Pending',
  `assessor_id` int DEFAULT NULL,
  `assessor_comments` text,
  `assessed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_enrolment` (`enrolment_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_academic_poe_enrolment` FOREIGN KEY (`enrolment_id`) REFERENCES `academic_class_enrolment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_programme`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_programme` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text,
  `qualification_type` enum('NATED','NCV','Occupational','Other') DEFAULT 'NATED',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_programme_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_subject`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_subject` (
  `id` int NOT NULL AUTO_INCREMENT,
  `programme_id` int NOT NULL,
  `code` varchar(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text,
  `credits` int DEFAULT '0',
  `notional_hours` int DEFAULT '0' COMMENT 'Total learning hours',
  `is_core` tinyint(1) DEFAULT '1' COMMENT '1=Core, 0=Elective',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_subject_code_programme` (`code`,`programme_id`),
  KEY `idx_programme` (`programme_id`),
  CONSTRAINT `fk_academic_subject_programme` FOREIGN KEY (`programme_id`) REFERENCES `academic_programme` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_subject_level`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_subject_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int NOT NULL,
  `level_id` int NOT NULL,
  `syllabus_code` varchar(50) DEFAULT NULL COMMENT 'DHET syllabus reference',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_subject_level` (`subject_id`,`level_id`),
  KEY `idx_subject` (`subject_id`),
  KEY `idx_level` (`level_id`),
  CONSTRAINT `fk_academic_sl_level` FOREIGN KEY (`level_id`) REFERENCES `academic_level` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_academic_sl_subject` FOREIGN KEY (`subject_id`) REFERENCES `academic_subject` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `academic_timetable`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `academic_timetable` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `venue` varchar(100) DEFAULT NULL,
  `lecturer_id` int DEFAULT NULL COMMENT 'Override lecturer for this slot',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_day` (`day_of_week`),
  CONSTRAINT `fk_academic_tt_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `attendence_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `attendence_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT NULL,
  `key_value` varchar(50) NOT NULL,
  `long_lang_name` varchar(250) DEFAULT NULL,
  `long_name_style` varchar(250) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `for_qr_attendance` int NOT NULL DEFAULT '1',
  `for_schedule` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `batch`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `batch` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `book_issues`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `book_issues` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int DEFAULT NULL,
  `member_id` int DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `due_return_date` date DEFAULT NULL,
  `duereturn_date` date DEFAULT NULL,
  `is_returned` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `books`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_title` varchar(255) DEFAULT NULL,
  `book_no` varchar(100) DEFAULT NULL,
  `qty` int DEFAULT '0',
  `postdate` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `captcha`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `captcha` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `status` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categories`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(100) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `certificates`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `certificates` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `status` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `class_batch_subjects`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `class_batch_subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_batch_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `class_batches`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `class_batches` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `batch_name` varchar(100) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `session_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `class_lecturer`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `class_lecturer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `class_sections`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `class_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `class_teacher`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `class_teacher` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `classes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `classes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class` varchar(60) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `classmodel`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `classmodel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_code` varchar(100) DEFAULT NULL,
  `class_name` varchar(200) DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `complaint`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `complaint` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `complaint_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `complaint_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `complaint_type` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dispatch_receive`
--

CREATE TABLE IF NOT EXISTS `dispatch_receive` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reference_no` varchar(50) NOT NULL,
  `to_title` varchar(100) NOT NULL,
  `type` varchar(10) NOT NULL,
  `address` varchar(500) NOT NULL,
  `note` varchar(500) NOT NULL,
  `from_title` varchar(200) NOT NULL,
  `date` date DEFAULT NULL,
  `image` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `conference_cohorts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `conference_cohorts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conference_id` int DEFAULT NULL,
  `cohort_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conference_sections`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `conference_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conference_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conference_staff`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `conference_staff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conference_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conferences`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `conferences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `description` text,
  `date` date DEFAULT NULL,
  `start_time` varchar(20) DEFAULT NULL,
  `end_time` varchar(20) DEFAULT NULL,
  `conference_type` varchar(50) DEFAULT NULL,
  `api_type` varchar(50) DEFAULT NULL,
  `join_url` text,
  `meeting_id` varchar(200) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `host_video` int DEFAULT '0',
  `participant_video` int DEFAULT '0',
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `status` varchar(50) DEFAULT 'scheduled',
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conferences_history`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `conferences_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conference_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `join_time` timestamp NULL DEFAULT NULL,
  `leave_time` timestamp NULL DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_for`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `content_for` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` varchar(50) DEFAULT NULL,
  `content_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_types`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `content_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  `is_active` int DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `content_views`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `content_views` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `view_count` int DEFAULT '0',
  `last_viewed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `contents` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currencies`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `currencies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `short_name` varchar(100) DEFAULT NULL,
  `symbol` varchar(10) DEFAULT NULL,
  `base_price` varchar(10) NOT NULL DEFAULT '1',
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custom_field_values`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `custom_field_values` (
  `id` int NOT NULL AUTO_INCREMENT,
  `belong_table_id` int DEFAULT NULL,
  `custom_field_id` int DEFAULT NULL,
  `field_value` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `custom_fields`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `custom_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `daily_assignment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `daily_assignment` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `department`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `department` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department_name` varchar(200) NOT NULL,
  `is_active` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `disability_types`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `disability_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `disable_reason`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `disable_reason` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reason` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `email_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_template`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `email_template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `created_at` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enquiry`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `enquiry` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `class` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `no_of_child` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enquiry_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `enquiry_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `enquiry_type` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `enrolment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `enrolment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_session_status` (`session_id`,`status`),
  KEY `idx_student` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `events`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_title` varchar(255) DEFAULT NULL,
  `event_description` text,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `event_type` varchar(100) DEFAULT NULL,
  `event_color` varchar(100) DEFAULT NULL,
  `event_for` varchar(100) DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exam_group_class_batch_exam_students`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `exam_group_class_batch_exam_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_class_batch_exam_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `roll_no` varchar(50) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exam_group_class_batch_exam_subjects`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `exam_group_class_batch_exam_subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_class_batch_exam_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `max_marks` decimal(10,2) DEFAULT NULL,
  `min_marks` decimal(10,2) DEFAULT NULL,
  `credit_hours` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exam_group_class_batch_exams`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `exam_group_class_batch_exams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_id` int DEFAULT NULL,
  `exam_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `exam` varchar(200) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_active` int DEFAULT 1,
  `is_publish` int DEFAULT 0,
  `date_from` date DEFAULT NULL,
  `date_to` date DEFAULT NULL,
  `passing_percentage` decimal(5,2) DEFAULT 0,
  `use_exam_roll_no` int DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exam_group_exam_connections`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `exam_group_exam_connections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_id` int DEFAULT NULL,
  `exam_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exam_group_students`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `exam_group_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exam_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `exam_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `exam_type` varchar(100) DEFAULT NULL,
  `description` text,
  `session_id` int DEFAULT NULL,
  `is_publish` int DEFAULT '0',
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exam_moderation_comments`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `exam_moderation_comments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assessment_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `comment` text,
  `action` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exam_results`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `exam_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_schedule_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `attendence` varchar(10) DEFAULT NULL,
  `get_marks` varchar(50) DEFAULT NULL,
  `note` text,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exam_schedules`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `exam_schedules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_class_batch_exams_id` int DEFAULT NULL,
  `teacher_subject_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `date_from` date DEFAULT NULL,
  `date_to` date DEFAULT NULL,
  `time_from` varchar(20) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `room_no` varchar(50) DEFAULT NULL,
  `full_marks` varchar(50) DEFAULT NULL,
  `passing_marks` varchar(50) DEFAULT NULL,
  `credit_hours` varchar(50) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exams`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `exams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `note` text,
  `is_active` varchar(10) DEFAULT 'no',
  `is_publish` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expense_head`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `expense_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exp_category` varchar(100) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'yes',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `expenses`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `expenses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exp_head_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT '0.00',
  `date` date DEFAULT NULL,
  `invoice_no` varchar(100) DEFAULT NULL,
  `documents` varchar(500) DEFAULT NULL,
  `note` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fee_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `fee_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` text,
  `is_system` tinyint(1) DEFAULT '0',
  `nature` varchar(50) DEFAULT 'normal',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fee_groups_feetype`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `fee_groups_feetype` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fee_groups_id` int DEFAULT NULL,
  `feetype_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT '0.00',
  `due_date` date DEFAULT NULL,
  `fine_type` varchar(50) DEFAULT NULL,
  `fine_percentage` decimal(5,2) DEFAULT '0.00',
  `fine_amount` decimal(15,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fees_reminder`
--

CREATE TABLE IF NOT EXISTS `fees_reminder` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reminder_type` varchar(10) DEFAULT NULL,
  `day` int DEFAULT NULL,
  `is_active` int DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT IGNORE INTO `fees_reminder` (`id`, `reminder_type`, `day`, `is_active`) VALUES
(1, 'before', 2, 0),
(2, 'before', 5, 0),
(3, 'after', 2, 0),
(4, 'after', 5, 0);

--
-- Table structure for table `fee_session_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `fee_session_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fee_groups_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feecategory`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `feecategory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(100) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feemasters`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `feemasters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `feetype_id` int DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT '0.00',
  `fine_type` varchar(50) DEFAULT NULL,
  `fine_percentage` decimal(5,2) DEFAULT '0.00',
  `fine_amount` decimal(15,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fees_discounts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `fees_discounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `percentage` float(10,2) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT '0.00',
  `discount_limit` int DEFAULT NULL,
  `expire_date` date DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feetype`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `feetype` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(100) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `is_system` tinyint(1) DEFAULT '0',
  `nature` varchar(50) DEFAULT 'custom',
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `filetypes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `filetypes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_extension` text,
  `file_mime` text,
  `file_size` int NOT NULL,
  `image_extension` text,
  `image_mime` text,
  `image_size` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `front_cms_media_gallery`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `front_cms_media_gallery` (
  `id` int NOT NULL AUTO_INCREMENT,
  `image` varchar(300) DEFAULT NULL,
  `thumb_path` varchar(300) DEFAULT NULL,
  `dir_path` varchar(300) DEFAULT NULL,
  `img_name` varchar(300) DEFAULT NULL,
  `thumb_name` varchar(300) DEFAULT NULL,
  `file_type` varchar(100) NOT NULL,
  `file_size` varchar(100) NOT NULL,
  `vid_url` text NOT NULL,
  `vid_title` varchar(250) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `front_cms_menu_items`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `front_cms_menu_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `menu_id` int NOT NULL,
  `menu` varchar(100) DEFAULT NULL,
  `page_id` int NOT NULL,
  `parent_id` int NOT NULL,
  `ext_url` text,
  `open_new_tab` int DEFAULT '0',
  `ext_url_link` text,
  `slug` varchar(200) DEFAULT NULL,
  `weight` int DEFAULT NULL,
  `publish` int NOT NULL DEFAULT '0',
  `description` text,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `front_cms_menus`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `front_cms_menus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `menu` varchar(100) DEFAULT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `description` text,
  `open_new_tab` int NOT NULL DEFAULT '0',
  `ext_url` text NOT NULL,
  `ext_url_link` text NOT NULL,
  `publish` int NOT NULL DEFAULT '0',
  `content_type` varchar(10) NOT NULL DEFAULT 'manual',
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `front_cms_page_contents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `front_cms_page_contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page_id` int DEFAULT NULL,
  `content_type` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `front_cms_pages`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `front_cms_pages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page_type` varchar(10) NOT NULL DEFAULT 'manual',
  `is_homepage` int DEFAULT '0',
  `title` varchar(250) DEFAULT NULL,
  `url` varchar(250) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `meta_title` text,
  `meta_description` text,
  `meta_keyword` text,
  `feature_image` varchar(200) NOT NULL,
  `description` longtext,
  `publish_date` date DEFAULT NULL,
  `publish` int DEFAULT '0',
  `sidebar` int DEFAULT '0',
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `front_cms_program_photos`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `front_cms_program_photos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `media_gallery_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `front_cms_programs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `front_cms_programs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT NULL,
  `slug` varchar(255) DEFAULT NULL,
  `url` text,
  `title` varchar(200) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `event_start` date DEFAULT NULL,
  `event_end` date DEFAULT NULL,
  `event_venue` text,
  `description` text,
  `is_active` varchar(10) DEFAULT 'no',
  `meta_title` text NOT NULL,
  `meta_description` text NOT NULL,
  `meta_keyword` text NOT NULL,
  `feature_image` text NOT NULL,
  `publish_date` date DEFAULT NULL,
  `publish` varchar(10) DEFAULT '0',
  `sidebar` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `front_cms_settings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `front_cms_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `general_calls`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `general_calls` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `contact` varchar(100) DEFAULT NULL,
  `purpose` varchar(100) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `description` text,
  `follow_up_date` date DEFAULT NULL,
  `call_duration` varchar(100) DEFAULT NULL,
  `note` text,
  `call_type` varchar(50) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `grades`
--

CREATE TABLE IF NOT EXISTS `grades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_type` varchar(250) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `point` float(10,1) DEFAULT NULL,
  `mark_from` float(10,2) DEFAULT NULL,
  `mark_upto` float(10,2) DEFAULT NULL,
  `description` text,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `holiday_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `holiday_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `is_default` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `homework`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `homework` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `section_id` int NOT NULL,
  `academic_class_id` int DEFAULT NULL,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `homework_evaluation`
--

CREATE TABLE IF NOT EXISTS `homework_evaluation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `homework_id` int NOT NULL,
  `student_id` int NOT NULL,
  `student_session_id` int DEFAULT NULL,
  `enrolment_id` int DEFAULT NULL,
  `marks` float(10,2) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `homework_id` (`homework_id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `hostel`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `hostel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hostel_name` varchar(100) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `address` text,
  `intake` int DEFAULT '0',
  `description` text,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hostel_rooms`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `hostel_rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hostel_id` int DEFAULT NULL,
  `room_type_id` int DEFAULT NULL,
  `room_no` varchar(50) DEFAULT NULL,
  `no_of_bed` int DEFAULT '0',
  `cost_per_bed` decimal(15,2) DEFAULT '0.00',
  `description` text,
  `title` varchar(200) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `income`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `income` (
  `id` int NOT NULL AUTO_INCREMENT,
  `inc_head_id` int DEFAULT NULL,
  `income_head_id` int DEFAULT NULL,
  `invoice_no` varchar(50) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT '0.00',
  `date` date DEFAULT NULL,
  `documents` varchar(500) DEFAULT NULL,
  `note` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `income_head`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `income_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `income_category` varchar(100) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'yes',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_category_id` int DEFAULT NULL,
  `item_supplier_id` int DEFAULT NULL,
  `item_store_id` int DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `item_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_category` varchar(255) NOT NULL,
  `is_active` varchar(255) NOT NULL DEFAULT 'yes',
  `description` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_issue`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `item_issue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `issue_type` varchar(50) DEFAULT NULL,
  `issue_to` int DEFAULT NULL,
  `issue_by` int DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `item_id` int DEFAULT NULL,
  `item_category_id` int DEFAULT NULL,
  `quantity` decimal(10,2) DEFAULT '0.00',
  `note` text,
  `status` int DEFAULT '0',
  `is_returned` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_stock`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `item_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` int DEFAULT NULL,
  `item_supplier_id` int DEFAULT NULL,
  `item_store_id` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `supplier_id` int DEFAULT NULL,
  `quantity` decimal(10,2) DEFAULT '0.00',
  `purchase_price` decimal(15,2) DEFAULT '0.00',
  `date` date DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_store`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `item_store` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_store_name` varchar(200) DEFAULT NULL,
  `item_store` varchar(200) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item_supplier`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `item_supplier` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_supplier` varchar(200) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text,
  `contact_person_name` varchar(100) DEFAULT NULL,
  `contact_person_phone` varchar(20) DEFAULT NULL,
  `contact_person_email` varchar(100) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `languages`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `languages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `language` varchar(50) DEFAULT NULL,
  `short_code` varchar(255) NOT NULL,
  `country_code` varchar(255) NOT NULL,
  `is_rtl` int NOT NULL,
  `is_deleted` varchar(10) NOT NULL DEFAULT 'yes',
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `leave_types`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `leave_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(200) NOT NULL,
  `is_active` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lesson`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `lesson` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `subject_group_subject_id` int NOT NULL,
  `subject_group_class_sections_id` int NOT NULL,
  `academic_class_id` int DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `libarary_members`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `libarary_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `member_id` int DEFAULT NULL,
  `member_type` varchar(50) DEFAULT NULL,
  `library_card_no` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message` text,
  `record_id` text,
  `user_id` int DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `ip_address` varchar(50) DEFAULT NULL,
  `platform` varchar(50) DEFAULT NULL,
  `agent` varchar(50) DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mark_divisions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `mark_divisions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `percentage_from` decimal(5,2) DEFAULT '0.00',
  `percentage_to` decimal(5,2) DEFAULT '0.00',
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `messages`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `migrations`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `migrations` (
  `version` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification_roles`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `notification_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `send_notification_id` int DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notification_setting`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `notification_setting` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `offline_fees_payments`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `offline_fees_payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` varchar(50) DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `student_fees_master_id` int DEFAULT NULL,
  `fee_groups_feetype_id` int DEFAULT NULL,
  `student_transport_fee_id` int DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `bank_from` varchar(200) DEFAULT NULL,
  `bank_account_transferred` varchar(200) DEFAULT NULL,
  `reference` varchar(200) DEFAULT NULL,
  `amount` float(10,2) DEFAULT NULL,
  `submit_date` datetime DEFAULT NULL,
  `approve_date` datetime DEFAULT NULL,
  `attachment` text,
  `reply` text,
  `approved_by` int DEFAULT NULL,
  `is_active` varchar(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `online_admissions`
--

CREATE TABLE IF NOT EXISTS `online_admissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admission_no` varchar(100) DEFAULT NULL,
  `roll_no` varchar(100) DEFAULT NULL,
  `reference_no` varchar(50) NOT NULL DEFAULT '',
  `admission_date` date DEFAULT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `middlename` varchar(255) NOT NULL DEFAULT '',
  `lastname` varchar(100) DEFAULT NULL,
  `rte` varchar(20) NOT NULL DEFAULT 'No',
  `image` varchar(255) DEFAULT NULL,
  `mobileno` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(100) DEFAULT NULL,
  `religion` varchar(100) DEFAULT NULL,
  `cast` varchar(50) NOT NULL DEFAULT '',
  `dob` date DEFAULT NULL,
  `gender` varchar(100) DEFAULT NULL,
  `current_address` text,
  `permanent_address` text,
  `category_id` int DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `route_id` int NOT NULL DEFAULT 0,
  `school_house_id` int DEFAULT NULL,
  `blood_group` varchar(200) NOT NULL DEFAULT '',
  `vehroute_id` int NOT NULL DEFAULT 0,
  `hostel_room_id` int DEFAULT NULL,
  `adhar_no` varchar(100) DEFAULT NULL,
  `samagra_id` varchar(100) DEFAULT NULL,
  `bank_account_no` varchar(100) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `ifsc_code` varchar(100) DEFAULT NULL,
  `guardian_is` varchar(100) NOT NULL DEFAULT '',
  `father_name` varchar(100) DEFAULT NULL,
  `father_phone` varchar(100) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `mother_name` varchar(100) DEFAULT NULL,
  `mother_phone` varchar(100) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `guardian_name` varchar(100) DEFAULT NULL,
  `guardian_relation` varchar(100) DEFAULT NULL,
  `guardian_phone` varchar(100) DEFAULT NULL,
  `guardian_occupation` varchar(150) NOT NULL DEFAULT '',
  `guardian_address` text,
  `guardian_email` varchar(100) NOT NULL DEFAULT '',
  `father_pic` varchar(255) NOT NULL DEFAULT '',
  `mother_pic` varchar(255) NOT NULL DEFAULT '',
  `guardian_pic` varchar(255) NOT NULL DEFAULT '',
  `is_enroll` int DEFAULT 0,
  `previous_school` text,
  `height` varchar(100) NOT NULL DEFAULT '',
  `weight` varchar(100) NOT NULL DEFAULT '',
  `note` text NOT NULL,
  `form_status` int NOT NULL DEFAULT 0,
  `paid_status` int NOT NULL DEFAULT 0,
  `measurement_date` date DEFAULT NULL,
  `app_key` text,
  `document` text,
  `submit_date` date DEFAULT NULL,
  `disable_at` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `online_admission_custom_field_value`
--

CREATE TABLE IF NOT EXISTS `online_admission_custom_field_value` (
  `id` int NOT NULL AUTO_INCREMENT,
  `belong_table_id` int DEFAULT NULL,
  `custom_field_id` int DEFAULT NULL,
  `field_value` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `online_admission_fields`
--

CREATE TABLE IF NOT EXISTS `online_admission_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT IGNORE INTO `online_admission_fields` (`id`, `name`, `status`) VALUES
(1,'middlename',0),(2,'lastname',1),(3,'category',0),(4,'religion',0),
(5,'cast',0),(6,'mobile_no',1),(7,'admission_date',0),(8,'student_photo',0),
(9,'is_student_house',0),(10,'is_blood_group',0),(11,'student_height',0),
(12,'student_weight',0),(13,'father_name',0),(14,'father_phone',0),
(15,'father_occupation',0),(16,'father_pic',0),(17,'mother_name',0),
(18,'mother_phone',0),(19,'mother_occupation',0),(20,'mother_pic',0),
(21,'guardian_name',1),(22,'guardian_phone',1),(23,'if_guardian_is',1),
(24,'guardian_relation',1),(25,'guardian_email',1),(26,'guardian_occupation',1),
(27,'guardian_address',1),(28,'bank_account_no',0),(29,'bank_name',0),
(30,'ifsc_code',0),(31,'national_identification_no',0),(32,'local_identification_no',0),
(33,'rte',0),(34,'previous_school_details',0),(35,'guardian_photo',1),
(36,'student_note',0),(37,'measurement_date',0),(38,'student_email',1),
(39,'current_address',0),(40,'permanent_address',0),(41,'upload_documents',1);

--
-- Table structure for table `online_admission_payment`
--

CREATE TABLE IF NOT EXISTS `online_admission_payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `online_admission_id` int NOT NULL,
  `paid_amount` float(10,2) NOT NULL,
  `payment_mode` varchar(50) NOT NULL DEFAULT '',
  `payment_type` varchar(100) NOT NULL DEFAULT '',
  `transaction_id` varchar(100) NOT NULL DEFAULT '',
  `note` varchar(100) NOT NULL DEFAULT '',
  `date` datetime NOT NULL,
  `processing_charge_type` varchar(255) DEFAULT NULL,
  `processing_charge_value` float(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `payment_settings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `payment_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `payment_type` varchar(50) DEFAULT NULL,
  `api_username` varchar(255) DEFAULT NULL,
  `api_password` varchar(255) DEFAULT NULL,
  `api_signature` varchar(255) DEFAULT NULL,
  `api_secret_key` varchar(255) DEFAULT NULL,
  `api_publishable_key` varchar(255) DEFAULT NULL,
  `api_email` varchar(255) DEFAULT NULL,
  `salt` varchar(255) DEFAULT NULL,
  `paypal_demo` varchar(20) DEFAULT NULL,
  `paytm_website` varchar(100) DEFAULT NULL,
  `paytm_industrytype` varchar(100) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `charge_type` varchar(50) DEFAULT NULL,
  `charge_value` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `payment_type` (`payment_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `onlineexam`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `onlineexam` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam` varchar(200) DEFAULT NULL,
  `attempt` int DEFAULT '1',
  `exam_from` datetime DEFAULT NULL,
  `exam_to` datetime DEFAULT NULL,
  `duration` varchar(20) DEFAULT NULL,
  `passing_percentage` decimal(5,2) DEFAULT '0.00',
  `description` text,
  `is_active` varchar(10) DEFAULT 'no',
  `is_publish` int DEFAULT '0',
  `is_marks_display` int DEFAULT '0',
  `is_neg_marking` int DEFAULT '0',
  `is_random_question` int DEFAULT '0',
  `publish_result` int DEFAULT '0',
  `moderation_status` varchar(30) DEFAULT 'pending_moderation',
  `session_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `onlineexam_questions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `onlineexam_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `onlineexam_id` int DEFAULT NULL,
  `question_id` int DEFAULT NULL,
  `question` text,
  `opt_a` text,
  `opt_b` text,
  `opt_c` text,
  `opt_d` text,
  `opt_e` text,
  `correct` varchar(10) DEFAULT NULL,
  `question_type` varchar(50) DEFAULT 'single',
  `marks` decimal(5,2) DEFAULT '1.00',
  `negative_marks` decimal(5,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `onlineexam_student_results`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `onlineexam_student_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `onlineexam_student_id` int DEFAULT NULL,
  `onlineexam_question_id` int DEFAULT NULL,
  `select_option` varchar(500) DEFAULT NULL,
  `is_correct` int DEFAULT NULL,
  `marks` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `onlineexam_students`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `onlineexam_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `onlineexam_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `onlineexam_attempts`
--

CREATE TABLE IF NOT EXISTS `onlineexam_attempts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `onlineexam_student_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `onlineexam_student_id` (`onlineexam_student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `permission_category`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `permission_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `perm_group_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `short_code` varchar(100) DEFAULT NULL,
  `enable_view` int DEFAULT '0',
  `enable_add` int DEFAULT '0',
  `enable_edit` int DEFAULT '0',
  `enable_delete` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=283 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `permission_group`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `permission_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `short_code` varchar(100) NOT NULL,
  `is_active` int DEFAULT '0',
  `system` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `permission_student`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `permission_student` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `short_code` varchar(100) NOT NULL,
  `system` int NOT NULL,
  `student` int NOT NULL,
  `parent` int NOT NULL,
  `group_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `print_headerfooter`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `print_headerfooter` (
  `id` int NOT NULL AUTO_INCREMENT,
  `print_type` varchar(100) DEFAULT NULL,
  `header_image` varchar(255) DEFAULT NULL,
  `footer_content` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `programme`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `programme` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `qualification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `qualification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `question_answers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `question_answers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int DEFAULT NULL,
  `answer` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `question_options`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `question_options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int DEFAULT NULL,
  `option_text` text,
  `is_correct` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `questions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `question_type` varchar(50) DEFAULT 'single',
  `level` varchar(50) DEFAULT 'medium',
  `question` text,
  `opt_a` text,
  `opt_b` text,
  `opt_c` text,
  `opt_d` text,
  `opt_e` text,
  `correct` varchar(10) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `read_notification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `read_notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `notification_id` int DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reference`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `reference` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reference` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `slug` varchar(150) DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `is_system` int NOT NULL DEFAULT '0',
  `is_superadmin` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles_permissions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `roles_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int DEFAULT NULL,
  `perm_cat_id` int DEFAULT NULL,
  `can_view` int DEFAULT NULL,
  `can_add` int DEFAULT NULL,
  `can_edit` int DEFAULT NULL,
  `can_delete` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1486 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `room_types`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `room_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_type` varchar(100) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pickup_point`
--

CREATE TABLE IF NOT EXISTS `pickup_point` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `latitude` varchar(100) DEFAULT NULL,
  `longitude` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `route_pickup_point`
--

CREATE TABLE IF NOT EXISTS `route_pickup_point` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `transport_route_id` int NOT NULL,
  `pickup_point_id` int NOT NULL,
  `fees` float(10,2) DEFAULT '0.00',
  `destination_distance` float(10,1) DEFAULT '0.0',
  `pickup_time` time DEFAULT NULL,
  `order_number` float NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `routes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `routes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `route_title` varchar(100) DEFAULT NULL,
  `note` text,
  `is_active` varchar(10) DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sch_settings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `sch_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `school_houses`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `school_houses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `house_name` varchar(100) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sections`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `section` varchar(60) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `send_notification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `send_notification` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session` varchar(60) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `share_contents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `share_contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  `send_to` varchar(50) DEFAULT NULL,
  `share_date` date DEFAULT NULL,
  `valid_upto` date DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `share_content_for`
--

CREATE TABLE IF NOT EXISTS `share_content_for` (
  `id` int NOT NULL AUTO_INCREMENT,
  `share_content_id` int DEFAULT NULL,
  `group_id` varchar(50) DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `user_parent_id` int DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `cohort_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `share_content_id` (`share_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `share_upload_contents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `share_upload_contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `upload_content_id` int DEFAULT NULL,
  `share_content_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `upload_content_id` (`upload_content_id`),
  KEY `share_content_id` (`share_content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sidebar_menus`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `sidebar_menus` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sidebar_sub_menus`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `sidebar_sub_menus` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=222 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sms_config`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `sms_config` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sms_template`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `sms_template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `source`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `source` (
  `id` int NOT NULL AUTO_INCREMENT,
  `source` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_id` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_attendance`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff_attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `staff_attendance_type_id` int DEFAULT '1',
  `remark` text,
  `is_active` int DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_attendance_type`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff_attendance_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(200) NOT NULL,
  `key_value` varchar(200) NOT NULL,
  `is_active` varchar(50) NOT NULL,
  `for_qr_attendance` int NOT NULL DEFAULT '1',
  `long_lang_name` varchar(250) DEFAULT NULL,
  `long_name_style` varchar(250) DEFAULT NULL,
  `for_schedule` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_attendence_schedules`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff_attendence_schedules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `day` varchar(20) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_designation`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff_designation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `designation` varchar(200) NOT NULL,
  `is_active` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_documents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff_documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `document_title` varchar(200) DEFAULT NULL,
  `document_file` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `id_card`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `id_card` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `school_name` varchar(200) DEFAULT NULL,
  `school_address` text,
  `header_color` varchar(50) DEFAULT NULL,
  `enable_admission_no` tinyint(1) DEFAULT '0',
  `enable_student_name` tinyint(1) DEFAULT '0',
  `enable_class` tinyint(1) DEFAULT '0',
  `enable_fathers_name` tinyint(1) DEFAULT '0',
  `enable_mothers_name` tinyint(1) DEFAULT '0',
  `enable_address` tinyint(1) DEFAULT '0',
  `enable_phone` tinyint(1) DEFAULT '0',
  `enable_dob` tinyint(1) DEFAULT '0',
  `enable_blood_group` tinyint(1) DEFAULT '0',
  `enable_vertical_card` tinyint(1) DEFAULT '0',
  `enable_student_barcode` tinyint(1) DEFAULT '0',
  `enable_student_rollno` tinyint(1) DEFAULT '0',
  `enable_student_house_name` tinyint(1) DEFAULT '0',
  `background` varchar(200) DEFAULT NULL,
  `logo` varchar(200) DEFAULT NULL,
  `sign_image` varchar(200) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_id_card`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff_id_card` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `background_image` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `sign_image` varchar(255) DEFAULT NULL,
  `header_color` varchar(50) DEFAULT '#333333',
  `enable_horizontal` varchar(10) DEFAULT 'no',
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_leave_details`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff_leave_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `leave_type_id` int DEFAULT NULL,
  `allotted_leave` decimal(5,1) DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_leave_request`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff_leave_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `leave_type_id` int DEFAULT NULL,
  `leave_from` date DEFAULT NULL,
  `leave_to` date DEFAULT NULL,
  `leave_days` decimal(5,1) DEFAULT NULL,
  `apply_date` date DEFAULT NULL,
  `approve_date` date DEFAULT NULL,
  `status` int DEFAULT '0',
  `admin_remark` text,
  `employee_remark` text,
  `document_file` varchar(255) DEFAULT NULL,
  `request_type` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_payroll`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff_payroll` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `basic_salary` decimal(15,2) DEFAULT NULL,
  `total_allowance` decimal(15,2) DEFAULT NULL,
  `total_deduction` decimal(15,2) DEFAULT NULL,
  `net_salary` decimal(15,2) DEFAULT NULL,
  `month` varchar(20) DEFAULT NULL,
  `year` varchar(10) DEFAULT NULL,
  `payment_mode` varchar(100) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_roles`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `staff_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `staff_rating`
--

CREATE TABLE IF NOT EXISTS `staff_rating` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `rate` int DEFAULT NULL,
  `comment` text,
  `status` varchar(20) DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `student_applied_discounts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_applied_discounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fees_discount_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_applyleave`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_applyleave` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_session_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `from_date` date DEFAULT NULL,
  `to_date` date DEFAULT NULL,
  `apply_date` date DEFAULT NULL,
  `approve_date` date DEFAULT NULL,
  `status` int DEFAULT '0',
  `approve_by` int DEFAULT NULL,
  `request_type` int DEFAULT '1',
  `reason` text,
  `docs` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_attendence_schedules`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_attendence_schedules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_section_id` int NOT NULL DEFAULT 0 COMMENT 'Maps to academic_class.id in TVET',
  `attendence_type_id` int NOT NULL DEFAULT 0,
  `entry_time_from` time DEFAULT NULL,
  `entry_time_to` time DEFAULT NULL,
  `total_institute_hour` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `class_section_id` (`class_section_id`),
  KEY `attendence_type_id` (`attendence_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_attendences`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_attendences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_session_id` int DEFAULT NULL,
  `enrolment_id` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `attendence_type_id` int DEFAULT NULL,
  `remark` text,
  `is_active` varchar(10) DEFAULT 'no',
  PRIMARY KEY (`id`),
  KEY `idx_enrolment_id` (`enrolment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_subject_attendances`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_subject_attendances` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_session_id` int DEFAULT NULL,
  `subject_timetable_id` int DEFAULT NULL,
  `attendence_type_id` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `subject_timetable_id` (`subject_timetable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_dashboard_settings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_dashboard_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `short_code` varchar(100) DEFAULT NULL,
  `status` int DEFAULT '1',
  `is_student` tinyint(1) DEFAULT 1,
  `is_parent` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_doc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_doc` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `doc` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_edit_fields`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_edit_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `status` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_fee_master`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_fee_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `fee_groups_feetype_id` int DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT '0.00',
  `amount_detail` text,
  `date` date DEFAULT NULL,
  `is_system` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_fees`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_fees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `feemaster_id` int DEFAULT NULL,
  `fee_amount` decimal(15,2) DEFAULT '0.00',
  `amount` decimal(15,2) DEFAULT '0.00',
  `amount_discount` decimal(15,2) DEFAULT '0.00',
  `amount_fine` decimal(15,2) DEFAULT '0.00',
  `date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_fees_deposite`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_fees_deposite` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_fees_master_id` int DEFAULT NULL,
  `fee_groups_feetype_id` int DEFAULT NULL,
  `student_transport_fee_id` int DEFAULT NULL,
  `amount_detail` text,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_fees_discounts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_fees_discounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_session_id` int DEFAULT NULL,
  `fees_discount_id` int DEFAULT NULL,
  `status` varchar(20) DEFAULT 'assigned',
  `payment_id` varchar(50) DEFAULT NULL,
  `student_fees_master_id` int DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `discount_type` varchar(50) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_fees_master`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_fees_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_session_id` int DEFAULT NULL,
  `fee_session_group_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_programme`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_programme` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `programme_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_session`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_session` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `transport_fees` decimal(15,2) DEFAULT '0.00',
  `fees_discount` decimal(5,2) DEFAULT '0.00',
  `is_active` varchar(10) DEFAULT 'no',
  `last_programme_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_student` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_transport_fees`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `student_transport_fees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `transport_feemaster_id` int DEFAULT NULL,
  `route_pickup_point_id` int DEFAULT NULL,
  `fees` decimal(15,2) DEFAULT '0.00',
  `amount_detail` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `students`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `students` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `is_disabled` tinyint(1) DEFAULT 0,
  `disability_type_id` int DEFAULT NULL,
  `disability_details` text DEFAULT NULL,
  `disable_at` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subject_group_class_sections`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `subject_group_class_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_group_id` int DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subject_group_subjects`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `subject_group_subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_group_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subject_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `subject_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subject_syllabus`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `subject_syllabus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_group_subject_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `description` text,
  `doc` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subject_timetable`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `subject_timetable` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_group_id` int DEFAULT NULL,
  `subject_group_subject_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `day` varchar(20) DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `time_from` varchar(20) DEFAULT NULL,
  `time_to` varchar(20) DEFAULT NULL,
  `start_time` varchar(20) DEFAULT NULL,
  `room_no` varchar(50) DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `subjects`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `submit_assignment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `submit_assignment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `homework_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `message` text,
  `docs` varchar(200) DEFAULT NULL,
  `status` int DEFAULT '0',
  `evaluation_by` int DEFAULT NULL,
  `evaluated_on` date DEFAULT NULL,
  `marks` varchar(50) DEFAULT NULL,
  `note` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `teacher_subjects`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `teacher_subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_section_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `teacher_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `teachers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `teachers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `template_admitcards`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `template_admitcards` (
  `id` int NOT NULL AUTO_INCREMENT,
  `template` varchar(100) DEFAULT NULL,
  `heading` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `left_logo` varchar(255) DEFAULT NULL,
  `right_logo` varchar(255) DEFAULT NULL,
  `exam_name` varchar(255) DEFAULT NULL,
  `school_name` varchar(255) DEFAULT NULL,
  `sign` varchar(255) DEFAULT NULL,
  `background_img` varchar(255) DEFAULT NULL,
  `is_name` int DEFAULT '1',
  `is_father_name` int DEFAULT '1',
  `is_mother_name` int DEFAULT '1',
  `is_dob` int DEFAULT '1',
  `is_admission_no` int DEFAULT '1',
  `is_roll_no` int DEFAULT '1',
  `is_address` int DEFAULT '1',
  `is_gender` int DEFAULT '1',
  `is_photo` int DEFAULT '1',
  `is_class` int DEFAULT '1',
  `content` text,
  `enable_horizontal` varchar(10) DEFAULT 'no',
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `template_marksheets`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `template_marksheets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `template` varchar(100) DEFAULT NULL,
  `template_name` varchar(200) DEFAULT NULL,
  `enable_horizontal` varchar(10) DEFAULT 'no',
  `left_logo` varchar(255) DEFAULT NULL,
  `right_logo` varchar(255) DEFAULT NULL,
  `background_image` varchar(255) DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `topic`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `topic` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lesson_id` int DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `status` int DEFAULT '0',
  `complete_date` date DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transport_feemaster`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `transport_feemaster` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `month` varchar(20) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT '0.00',
  `due_date` date DEFAULT NULL,
  `fine_amount` decimal(15,2) DEFAULT '0.00',
  `fine_type` varchar(50) DEFAULT NULL,
  `fine_percentage` decimal(5,2) DEFAULT '0.00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transport_route`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `transport_route` (
  `id` int NOT NULL AUTO_INCREMENT,
  `route_title` varchar(200) NOT NULL,
  `no_of_vehicle` int DEFAULT NULL,
  `fare` decimal(10,2) DEFAULT '0.00',
  `note` text,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tvet_cohort`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tvet_cohort` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `level_id` int unsigned NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `intake_year` year NOT NULL,
  `delivery_mode` enum('Full-time','Part-time','Evening','Weekend','Distance') NOT NULL DEFAULT 'Full-time',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `max_students` int NOT NULL DEFAULT '40',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cohort_level` (`level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tvet_lecturer_allocation`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tvet_lecturer_allocation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `cohort_id` int unsigned NOT NULL,
  `module_id` int unsigned NOT NULL,
  `session_id` int NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_alloc_staff` (`staff_id`),
  KEY `idx_alloc_cohort` (`cohort_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tvet_level`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tvet_level` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `qualification_id` int unsigned NOT NULL DEFAULT '0',
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `level_type` enum('NATED','NCV','Other') NOT NULL DEFAULT 'NATED',
  `sequence` tinyint NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_level_code` (`code`),
  KEY `idx_level_qualification` (`qualification_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tvet_level_module`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tvet_level_module` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `level_id` int unsigned NOT NULL,
  `subject_id` int DEFAULT NULL,
  `code` varchar(50) NOT NULL,
  `module_code` varchar(50) DEFAULT NULL,
  `module_name` varchar(200) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `credits` int NOT NULL DEFAULT '0',
  `semester` enum('1','2','Year') DEFAULT 'Year',
  `notional_hours` int NOT NULL DEFAULT '0',
  `is_core` tinyint(1) NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_module_level` (`level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tvet_programme`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tvet_programme` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `qualification_id` int unsigned NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text,
  `nqf_level` tinyint NOT NULL DEFAULT '1',
  `duration_years` decimal(3,1) NOT NULL DEFAULT '3.0',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_prog_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tvet_qualification`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tvet_qualification` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `programme_id` int unsigned NOT NULL DEFAULT '0',
  `code` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `qualification_type` enum('NATED','NCV','Occupational','Short Course','Other') NOT NULL DEFAULT 'NATED',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_qual_code` (`code`),
  KEY `idx_qualification_programme` (`programme_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tvet_student_enrolment`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `tvet_student_enrolment` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `level_id` int unsigned DEFAULT NULL,
  `programme_id` int unsigned NOT NULL,
  `cohort_id` int unsigned NOT NULL,
  `enrolment_date` date DEFAULT NULL,
  `enrol_date` date NOT NULL,
  `status` enum('Active','Completed','Dropped','Deferred','Transferred') NOT NULL DEFAULT 'Active',
  `completion_date` date DEFAULT NULL,
  `student_number` varchar(50) DEFAULT NULL,
  `notes` text,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_enrol_student` (`student_id`),
  KEY `idx_enrol_programme` (`programme_id`),
  KEY `idx_enrol_cohort` (`cohort_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `upload_contents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `upload_contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content_type_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `real_name` varchar(255) DEFAULT NULL,
  `img_name` varchar(255) DEFAULT NULL,
  `vid_url` text,
  `vid_title` varchar(255) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `file_type` varchar(100) DEFAULT NULL,
  `file_size` varchar(50) DEFAULT NULL,
  `thumb_name` varchar(255) DEFAULT NULL,
  `thumb_path` varchar(255) DEFAULT NULL,
  `dir_path` varchar(255) DEFAULT NULL,
  `upload_by` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `content_type_id` (`content_type_id`),
  KEY `upload_by` (`upload_by`),
  KEY `subject_id` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `userlog`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `userlog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` varchar(100) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `ipaddress` varchar(100) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `login_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `childs` text NOT NULL,
  `role` varchar(30) NOT NULL,
  `lang_id` int NOT NULL,
  `currency_id` int DEFAULT '0',
  `verification_code` varchar(200) NOT NULL,
  `is_active` varchar(255) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vehicles`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vehicle_no` varchar(50) DEFAULT NULL,
  `vehicle_model` varchar(100) DEFAULT NULL,
  `driver_name` varchar(100) DEFAULT NULL,
  `driver_licence` varchar(50) DEFAULT NULL,
  `driver_contact` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vehicle_routes`
--

CREATE TABLE IF NOT EXISTS `vehicle_routes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `route_id` int DEFAULT NULL,
  `vehicle_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `video_tutorial`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `video_tutorial` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `description` text,
  `url` text,
  `section_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `video_tutorial_class_sections`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `video_tutorial_class_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `video_tutorial_id` int DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `visitors_book`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `visitors_book` (
  `id` int NOT NULL AUTO_INCREMENT,
  `source` varchar(100) DEFAULT NULL,
  `purpose` varchar(200) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  `id_proof` varchar(100) DEFAULT NULL,
  `no_of_people` int DEFAULT '1',
  `date` date DEFAULT NULL,
  `in_time` varchar(20) DEFAULT NULL,
  `out_time` varchar(20) DEFAULT NULL,
  `note` text,
  `image` varchar(200) DEFAULT NULL,
  `meeting_with` varchar(100) DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `visitors_purpose`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `visitors_purpose` (
  `id` int NOT NULL AUTO_INCREMENT,
  `visitors_purpose` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zoom_settings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `zoom_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `api_key` varchar(255) DEFAULT NULL,
  `api_secret` varchar(255) DEFAULT NULL,
  `api_url` varchar(255) DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'smart_school'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-07  6:33:41

--
-- Table structure for table `level` (simpler level table used by subject_level)
--

CREATE TABLE IF NOT EXISTS `level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `level_type` enum('NATED','NCV','Other') DEFAULT 'NATED',
  `nqf_level` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Table structure for table `subject_level` (maps subjects to levels)
--

CREATE TABLE IF NOT EXISTS `subject_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int NOT NULL,
  `level_id` int NOT NULL,
  `syllabus_code` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `subject_id` (`subject_id`),
  KEY `level_id` (`level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- View `class` (alias for academic_class used by Enrolment/Subjectlevel models)
--

CREATE OR REPLACE VIEW `class` AS SELECT * FROM `academic_class`;

-- ============================================================================
-- SEED DATA (Essential data for system operation)
-- ============================================================================

INSERT INTO `roles` (`id`, `name`, `slug`, `is_active`, `is_system`, `is_superadmin`, `created_at`, `updated_at`) VALUES (1,'Admin',NULL,1,1,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(2,'Lecturer',NULL,1,1,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(3,'Accountant',NULL,1,1,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(4,'Librarian',NULL,1,1,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(6,'Receptionist',NULL,1,1,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(7,'Super Admin',NULL,1,1,1,'2026-02-07 06:22:32','2026-02-07 06:22:32');
INSERT INTO `staff` (`id`, `employee_id`, `lang_id`, `currency_id`, `department`, `designation`, `qualification`, `work_exp`, `name`, `surname`, `father_name`, `mother_name`, `contact_no`, `emergency_contact_no`, `email`, `dob`, `marital_status`, `date_of_joining`, `date_of_leaving`, `local_address`, `permanent_address`, `note`, `image`, `password`, `gender`, `account_title`, `bank_account_no`, `bank_name`, `ifsc_code`, `bank_branch`, `payscale`, `basic_salary`, `epf_no`, `contract_type`, `shift`, `location`, `facebook`, `twitter`, `linkedin`, `instagram`, `resume`, `joining_letter`, `resignation_letter`, `other_document_name`, `other_document_file`, `user_id`, `is_active`, `verification_code`, `disable_at`, `created_at`, `updated_at`) VALUES (1,'ADMIN001',1,1,NULL,NULL,'','','System','Administrator','','','+27 11 123 4567','+27 11 123 4567','admin@school.com','1990-01-01','Single','2026-01-01',NULL,'Johannesburg, South Africa','Johannesburg, South Africa','Default System Administrator','','$2y$10$XUfjAqLH43Vha2TexExUoeZwamen4VnjMkFEh.W0PcUERLHhe8zr.','Male','','','','','','',NULL,'','','','','','','','','','','','','',1,1,'',NULL,'2026-02-07 06:22:32','2026-02-07 06:27:36');
INSERT INTO `users` (`id`, `user_id`, `username`, `password`, `childs`, `role`, `lang_id`, `currency_id`, `verification_code`, `is_active`, `created_at`, `updated_at`) VALUES (1,1,'admin@school.com','$2y$10$XUfjAqLH43Vha2TexExUoeZwamen4VnjMkFEh.W0PcUERLHhe8zr.','','Admin',1,1,'','yes','2026-02-07 06:22:32','2026-02-07 06:22:32');
INSERT INTO `staff_roles` (`id`, `role_id`, `staff_id`, `is_active`, `created_at`, `updated_at`) VALUES (1,7,1,1,'2026-02-07 06:22:32','2026-02-07 06:22:32');
INSERT INTO `sessions` (`id`, `session`, `is_active`, `created_at`, `updated_at`) VALUES (1,'2024-25','no','2026-02-07 06:22:32','2026-02-07 06:22:32'),(2,'2025-26','no','2026-02-07 06:22:32','2026-02-07 06:22:32'),(3,'2026-27','yes','2026-02-07 06:22:32','2026-02-07 06:22:32'),(4,'2027-28','no','2026-02-07 06:22:32','2026-02-07 06:22:32'),(5,'2028-29','no','2026-02-07 06:22:32','2026-02-07 06:22:32'),(6,'2029-30','no','2026-02-07 06:22:32','2026-02-07 06:22:32');
INSERT INTO `student_dashboard_settings` (`name`, `short_code`, `status`, `is_student`, `is_parent`) VALUES ('homework','homework',1,1,1),('attendance','attendance',1,1,1),('live_classes','live_classes',1,1,1),('exam_schedule','exam_schedule',1,1,1),('fees','fees',1,1,1),('library','library',1,1,1),('transport','transport',1,1,1),('hostel','hostel',1,1,1),('documents','documents',1,1,1),('attendance_chart','attendance_chart',1,1,1),('calendar','calendar',1,1,1),('notice_board','notice_board',1,1,1);
INSERT INTO `languages` (`id`, `language`, `short_code`, `country_code`, `is_rtl`, `is_deleted`, `is_active`, `created_at`, `updated_at`) VALUES (1,'English','en','us',0,'no','yes','2026-02-07 06:22:32','2026-02-07 06:22:32'),(2,'Afrikaans','af','za',0,'no','no','2026-02-07 06:22:32','2026-02-07 06:22:32');
INSERT INTO `currencies` (`id`, `name`, `short_name`, `symbol`, `base_price`, `is_active`, `created_at`, `updated_at`) VALUES (1,'South African Rand','ZAR','R','1',1,'2026-02-07 06:22:32','2026-02-07 06:22:32');
INSERT INTO `filetypes` (`id`, `file_extension`, `file_mime`, `file_size`, `image_extension`, `image_mime`, `image_size`, `created_at`, `updated_at`) VALUES (1,'pdf, zip, jpg, jpeg, png, txt, 7z, gif, csv, docx, mp3, mp4, accdb, odt, ods, ppt, pptx, xlsx, wmv, jfif, apk, ppt, bmp, jpe, mdb, rar, xls, svg','application/pdf, image/zip, image/jpg, image/png, image/jpeg, text/plain, application/x-zip-compressed, application/zip, image/gif, text/csv, application/vnd.openxmlformats-officedocument.wordprocessingml.document, audio/mpeg, application/msaccess, application/vnd.oasis.opendocument.text, application/vnd.oasis.opendocument.spreadsheet, application/vnd.ms-powerpoint, application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, video/x-ms-wmv, video/mp4, image/jpeg, application/vnd.android.package-archive, application/x-msdownload, application/vnd.ms-powerpoint, image/bmp, image/jpeg, application/msaccess, application/vnd.ms-excel, image/svg+xml',100048576,'jfif, png, jpe, jpeg, jpg, bmp, gif, svg','image/jpeg, image/png, image/jpeg, image/jpeg, image/bmp, image/gif, image/x-ms-bmp, image/svg+xml',10048576,'2026-02-07 06:22:32','2026-02-07 06:22:32');
INSERT INTO `sch_settings` (`id`, `base_url`, `folder_path`, `name`, `biometric`, `biometric_device`, `email`, `phone`, `address`, `lang_id`, `languages`, `dise_code`, `date_format`, `time_format`, `currency`, `currency_symbol`, `is_rtl`, `is_duplicate_fees_invoice`, `collect_back_date_fees`, `single_page_print`, `timezone`, `session_id`, `cron_secret_key`, `currency_place`, `currency_format`, `class_teacher`, `start_month`, `attendence_type`, `low_attendance_limit`, `image`, `admin_logo`, `admin_small_logo`, `admin_login_page_background`, `user_login_page_background`, `theme`, `fee_due_days`, `adm_auto_insert`, `adm_prefix`, `adm_start_from`, `adm_no_digit`, `adm_update_status`, `staffid_auto_insert`, `staffid_prefix`, `staffid_start_from`, `staffid_no_digit`, `staffid_update_status`, `is_active`, `online_admission`, `online_admission_payment`, `online_admission_amount`, `online_admission_instruction`, `online_admission_conditions`, `online_admission_application_form`, `exam_result`, `is_blood_group`, `is_student_house`, `roll_no`, `category`, `religion`, `cast`, `mobile_no`, `student_email`, `admission_date`, `lastname`, `middlename`, `student_photo`, `student_height`, `student_weight`, `measurement_date`, `father_name`, `father_phone`, `father_occupation`, `father_pic`, `mother_name`, `mother_phone`, `mother_occupation`, `mother_pic`, `guardian_name`, `guardian_relation`, `guardian_phone`, `guardian_email`, `guardian_pic`, `guardian_occupation`, `guardian_address`, `current_address`, `permanent_address`, `route_list`, `hostel_id`, `bank_account_no`, `ifsc_code`, `bank_name`, `national_identification_no`, `local_identification_no`, `rte`, `previous_school_details`, `student_note`, `upload_documents`, `student_barcode`, `staff_designation`, `staff_department`, `staff_last_name`, `staff_father_name`, `staff_mother_name`, `staff_date_of_joining`, `staff_phone`, `staff_emergency_contact`, `staff_marital_status`, `staff_photo`, `staff_current_address`, `staff_permanent_address`, `staff_qualification`, `staff_work_experience`, `staff_note`, `staff_epf_no`, `staff_basic_salary`, `staff_contract_type`, `staff_work_shift`, `staff_work_location`, `staff_leaves`, `staff_account_details`, `staff_social_media`, `staff_upload_documents`, `staff_barcode`, `staff_notification_email`, `mobile_api_url`, `app_primary_color_code`, `app_secondary_color_code`, `admin_mobile_api_url`, `admin_app_primary_color_code`, `admin_app_secondary_color_code`, `app_logo`, `student_profile_edit`, `start_week`, `my_question`, `superadmin_restriction`, `student_timeline`, `calendar_event_reminder`, `event_reminder`, `student_login`, `parent_login`, `student_panel_login`, `parent_panel_login`, `is_student_feature_lock`, `maintenance_mode`, `lock_grace_period`, `is_offline_fee_payment`, `offline_bank_payment_instruction`, `scan_code_type`, `student_resume_download`, `download_admit_card`, `fees_discount`, `front_side_whatsapp`, `front_side_whatsapp_mobile`, `front_side_whatsapp_from`, `front_side_whatsapp_to`, `admin_panel_whatsapp`, `admin_panel_whatsapp_mobile`, `admin_panel_whatsapp_from`, `admin_panel_whatsapp_to`, `student_panel_whatsapp`, `student_panel_whatsapp_mobile`, `student_panel_whatsapp_from`, `student_panel_whatsapp_to`, `saas_key`, `created_at`, `updated_at`) VALUES (1,NULL,NULL,'TVET College',0,NULL,'admin@tvetcollege.ac.za','+27 11 123 4567','Johannesburg, Gauteng, South Africa',1,'[\"1\"]',NULL,'d/m/Y','h:i A','1','R','disabled','0',0,0,'Africa/Johannesburg',3,'','before_number',NULL,'','1',0,0.00,'1.png','1.png','1.png','1663064530-1070210809632059d2b8b0b!1662796232-1721792380631c41c80d038!login_bg3.jpg','1663065284-93117584263205cc49769c!1662964519-2099955753631ed327d0ffa!login_bg5.jpg','default.jpg',0,1,'TVET2026/','00001',6,0,1,'STAFF2026/','00001',6,0,'yes',0,'',0,'','',NULL,0,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,'','',NULL,NULL,'','','',NULL,0,'',0,'','',NULL,'',NULL,NULL,1,1,0,0,0,0,'','barcode',1,0,0,0,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2026-02-07 06:22:32','2026-02-07 06:22:32');
INSERT INTO `attendence_type` (`id`, `type`, `key_value`, `long_lang_name`, `long_name_style`, `is_active`, `for_qr_attendance`, `for_schedule`, `created_at`, `updated_at`) VALUES (1,'Present','P',NULL,NULL,'yes',1,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(2,'Absent','A',NULL,NULL,'yes',1,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(3,'Late','L',NULL,NULL,'yes',1,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(4,'Excused','E',NULL,NULL,'yes',1,0,'2026-02-07 06:22:32','2026-02-07 06:22:32');
INSERT INTO `staff_attendance_type` (`id`, `type`, `key_value`, `is_active`, `for_qr_attendance`, `long_lang_name`, `long_name_style`, `for_schedule`, `created_at`, `updated_at`) VALUES (1,'Present','P','yes',1,NULL,NULL,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(2,'Absent','A','yes',1,NULL,NULL,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(3,'Late','L','yes',1,NULL,NULL,0,'2026-02-07 06:22:32','2026-02-07 06:22:32'),(4,'On Leave','LV','yes',1,NULL,NULL,0,'2026-02-07 06:22:32','2026-02-07 06:22:32');
INSERT INTO `migrations` (`version`) VALUES (23);
INSERT INTO `front_cms_settings` (`id`, `theme`, `is_active_rtl`, `is_active_front_cms`, `is_active_sidebar`, `logo`, `contact_us_email`, `complain_form_email`, `sidebar_options`, `whatsapp_url`, `fb_url`, `twitter_url`, `youtube_url`, `google_plus`, `instagram_url`, `pinterest_url`, `linkedin_url`, `google_analytics`, `footer_text`, `cookie_consent`, `fav_icon`, `created_at`, `updated_at`) VALUES (1,'default',0,1,0,NULL,NULL,NULL,'[]','','','','','','','','',NULL,NULL,'',NULL,'2026-02-07 06:22:29','2026-02-07 06:22:29');
INSERT INTO `front_cms_menus` (`id`, `menu`, `slug`, `description`, `open_new_tab`, `ext_url`, `ext_url_link`, `publish`, `content_type`, `is_active`, `created_at`, `updated_at`) VALUES (1,'Main Menu','main-menu','Main menu',0,'','',0,'default','no','2026-02-07 06:22:29','2026-02-07 06:22:29'),(2,'Bottom Menu','bottom-menu','Bottom Menu',0,'','',0,'default','no','2026-02-07 06:22:29','2026-02-07 06:22:29');
INSERT INTO `front_cms_menu_items` (`id`, `menu_id`, `menu`, `page_id`, `parent_id`, `ext_url`, `open_new_tab`, `ext_url_link`, `slug`, `weight`, `publish`, `description`, `is_active`, `created_at`, `updated_at`) VALUES (1,1,'Home',1,0,NULL,0,NULL,'home',1,0,NULL,'no','2026-02-07 06:22:29','2026-02-07 06:22:29'),(2,1,'Contact Us',4,0,NULL,0,NULL,'contact-us',4,0,NULL,'no','2026-02-07 06:22:29','2026-02-07 06:22:29'),(3,1,'Complain',2,0,NULL,0,NULL,'complain',3,0,NULL,'no','2026-02-07 06:22:29','2026-02-07 06:22:29'),(4,1,'Online Admission',0,0,NULL,0,NULL,'admission',2,0,NULL,'no','2026-02-07 06:22:29','2026-02-07 06:22:29');
INSERT INTO `front_cms_pages` (`id`, `page_type`, `is_homepage`, `title`, `url`, `type`, `slug`, `meta_title`, `meta_description`, `meta_keyword`, `feature_image`, `description`, `publish_date`, `publish`, `sidebar`, `is_active`, `created_at`, `updated_at`) VALUES (1,'default',1,'Home','page/home','page','home',NULL,NULL,NULL,'','<p>Welcome to TVET College</p>',NULL,1,0,'no','2026-02-07 06:22:29','2026-02-07 06:22:29'),(2,'default',0,'Complain','page/complain','page','complain',NULL,NULL,NULL,'','<p>[form-builder:complain]</p>',NULL,1,0,'no','2026-02-07 06:22:29','2026-02-07 06:22:29'),(3,'default',0,'404 page','page/404-page','page','404-page',NULL,NULL,NULL,'','<p>404 page not found</p>',NULL,0,0,'no','2026-02-07 06:22:29','2026-02-07 06:22:29'),(4,'default',0,'Contact us','page/contact-us','page','contact-us',NULL,NULL,NULL,'','<p>Contact Us</p>',NULL,1,0,'no','2026-02-07 06:22:29','2026-02-07 06:22:29');
INSERT INTO `permission_group` (`id`, `name`, `short_code`, `is_active`, `system`, `created_at`, `updated_at`) VALUES (1,'Student Information','student_information',1,1,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(2,'Fees Collection','fees_collection',1,0,'2020-06-11 00:51:35','2026-02-06 11:10:54'),(3,'Income','income',1,0,'2020-06-01 01:57:39','2026-02-06 11:10:54'),(4,'Expense','expense',1,0,'2019-03-15 09:06:22','2026-02-06 11:10:54'),(5,'Student Attendance','student_attendance',1,0,'2018-07-02 07:48:08','2026-02-06 11:10:54'),(6,'Examination','examination',1,0,'2018-07-11 02:49:08','2026-02-06 11:10:54'),(7,'Academics','academics',1,1,'2018-07-02 07:25:43','2026-02-06 11:10:54'),(8,'Download Center','download_center',1,0,'2018-07-02 07:49:29','2026-02-06 11:10:54'),(9,'Library','library',1,0,'2018-06-28 11:13:14','2026-02-06 11:10:54'),(10,'Inventory','inventory',1,0,'2018-06-27 00:48:58','2026-02-06 11:10:54'),(11,'Transport','transport',1,0,'2018-06-27 07:51:26','2026-02-06 11:10:54'),(12,'Hostel','hostel',1,0,'2018-07-02 07:49:32','2026-02-06 11:10:54'),(13,'Communicate','communicate',1,0,'2018-07-02 07:50:00','2026-02-06 11:10:54'),(14,'Reports','reports',1,1,'2018-06-27 03:40:22','2026-02-06 11:10:54'),(15,'System Settings','system_settings',1,1,'2018-06-27 03:40:28','2026-02-06 11:10:54'),(16,'Front CMS','front_cms',1,0,'2018-07-10 05:16:54','2026-02-06 11:10:54'),(17,'Front Office','front_office',1,0,'2018-06-27 03:45:30','2026-02-06 11:10:54'),(18,'Human Resource','human_resource',1,1,'2018-06-27 03:41:02','2026-02-06 11:10:54'),(19,'Homework','homework',1,0,'2018-06-27 00:49:38','2026-02-06 11:10:54'),(20,'Certificate','certificate',1,0,'2018-06-27 07:51:29','2026-02-06 11:10:54'),(21,'Calendar To Do List','calendar_to_do_list',1,0,'2019-03-15 09:06:25','2026-02-06 11:10:54'),(22,'Dashboard and Widgets','dashboard_and_widgets',1,1,'2018-06-27 03:41:17','2026-02-06 11:10:54'),(23,'Online Examination','online_examination',1,0,'2020-06-01 02:25:36','2026-02-06 11:10:54'),(25,'Chat','chat',1,0,'2019-11-23 23:54:04','2026-02-06 11:10:54'),(26,'Multi Class','multi_class',1,0,'2019-11-27 12:14:14','2026-02-06 11:10:54'),(27,'Online Admission','online_admission',1,0,'2019-11-27 02:42:13','2026-02-06 11:10:54'),(28,'Alumni','alumni',1,0,'2020-05-29 00:26:38','2026-02-06 11:10:54'),(29,'Lesson Plan','lesson_plan',1,0,'2020-06-07 05:38:30','2026-02-06 11:10:54'),(30,'Annual Calendar','annual_calendar',1,0,'2024-10-22 10:45:56','2026-02-06 11:10:54'),(31,'Student CV','student_cv',1,0,'2024-12-13 11:54:57','2026-02-06 11:10:54');
INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`, `updated_at`) VALUES (1,1,'Student','student',1,0,0,0,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(2,1,'Import Student','import_student',1,1,1,1,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(3,1,'Student Categories','student_categories',1,1,1,1,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(4,1,'Student Houses','student_houses',1,1,1,1,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(5,2,'Collect Fees','collect_fees',1,1,1,1,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(6,2,'Fees Carry Forward','fees_carry_forward',1,1,1,1,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(7,2,'Fees Master','fees_master',1,1,1,0,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(8,2,'Fees Group','fees_group',1,1,1,1,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(9,3,'Income','income',1,1,1,0,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(10,3,'Income Head','income_head',1,1,1,1,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(11,3,'Search Income','search_income',1,1,1,1,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(12,4,'Expense','expense',1,0,0,0,'2026-02-06 03:49:14','2026-02-06 11:10:54'),(13,4,'Expense Head','expense_head',1,1,1,1,'2018-06-22 10:23:47','2026-02-06 11:10:54'),(14,4,'Search Expense','search_expense',1,0,0,0,'2018-06-22 10:24:13','2026-02-06 11:10:54'),(15,5,'Student / Period Attendance','student_attendance',1,1,1,0,'2019-11-29 01:19:05','2026-02-06 11:10:54'),(20,6,'Marks Grade','marks_grade',1,1,1,1,'2018-06-22 10:25:25','2026-02-06 11:10:54'),(21,7,'Class Timetable','class_timetable',1,0,1,0,'2019-11-24 03:05:17','2026-02-06 11:10:54'),(23,7,'Subject','subject',1,1,1,1,'2018-06-22 10:32:17','2026-02-06 11:10:54'),(24,7,'Class','class',1,1,1,1,'2018-06-22 10:32:35','2026-02-06 11:10:54'),(25,7,'Section','section',1,1,1,1,'2018-06-22 10:31:10','2026-02-06 11:10:54'),(26,7,'Promote Student','promote_student',1,0,0,0,'2018-06-22 10:32:47','2026-02-06 11:10:54'),(27,8,'Upload Content','upload_content',1,1,0,1,'2018-06-22 10:33:19','2026-02-06 11:10:54'),(28,9,'Books List','books',1,1,1,1,'2019-11-24 00:37:12','2026-02-06 11:10:54'),(29,9,'Issue Return','issue_return',1,0,0,0,'2019-11-24 00:37:18','2026-02-06 11:10:54'),(30,9,'Add Staff Member','add_staff_member',1,0,0,0,'2018-07-02 11:37:00','2026-02-06 11:10:54'),(31,10,'Issue Item','issue_item',1,1,1,1,'2019-11-29 06:39:27','2026-02-06 11:10:54'),(32,10,'Add Item Stock','item_stock',1,1,1,1,'2019-11-24 00:39:17','2026-02-06 11:10:54'),(33,10,'Add Item','item',1,1,1,1,'2019-11-24 00:39:39','2026-02-06 11:10:54'),(34,10,'Item Store','store',1,1,1,1,'2019-11-24 00:40:41','2026-02-06 11:10:54'),(35,10,'Item Supplier','supplier',1,1,1,1,'2019-11-24 00:40:49','2026-02-06 11:10:54'),(37,11,'Routes','routes',1,1,1,1,'2018-06-22 10:39:17','2026-02-06 11:10:54'),(38,11,'Vehicle','vehicle',1,1,1,1,'2018-06-22 10:39:36','2026-02-06 11:10:54'),(39,11,'Assign Vehicle','assign_vehicle',1,1,1,1,'2018-06-27 04:39:20','2026-02-06 11:10:54'),(40,12,'Hostel','hostel',1,1,1,1,'2018-06-22 10:40:49','2026-02-06 11:10:54'),(41,12,'Room Type','room_type',1,1,1,1,'2018-06-22 10:40:27','2026-02-06 11:10:54'),(42,12,'Hostel Rooms','hostel_rooms',1,1,1,1,'2018-06-25 06:23:03','2026-02-06 11:10:54'),(43,13,'Notice Board','notice_board',1,1,1,1,'2018-06-22 10:41:17','2026-02-06 11:10:54'),(44,13,'Email','email',1,0,0,0,'2019-11-26 05:20:37','2026-02-06 11:10:54'),(46,13,'Email / SMS Log','email_sms_log',1,0,0,0,'2018-06-22 10:41:23','2026-02-06 11:10:54'),(53,15,'Languages','languages',0,1,0,1,'2021-01-23 07:09:32','2026-02-06 11:10:54'),(54,15,'General Setting','general_setting',1,0,1,0,'2018-07-05 09:08:35','2026-02-06 11:10:54'),(55,15,'Session Setting','session_setting',1,1,1,1,'2018-06-22 10:44:15','2026-02-06 11:10:54'),(56,15,'Notification Setting','notification_setting',1,0,1,0,'2018-07-05 09:08:41','2026-02-06 11:10:54'),(57,15,'SMS Setting','sms_setting',1,0,1,0,'2018-07-05 09:08:47','2026-02-06 11:10:54'),(58,15,'Email Setting','email_setting',1,0,1,0,'2018-07-05 09:08:51','2026-02-06 11:10:54'),(59,15,'Front CMS Setting','front_cms_setting',1,0,1,0,'2018-07-05 09:08:55','2026-02-06 11:10:54'),(60,15,'Payment Methods','payment_methods',1,0,1,0,'2018-07-05 09:08:59','2026-02-06 11:10:54'),(61,16,'Menus','menus',1,1,0,1,'2018-07-09 03:50:06','2026-02-06 11:10:54'),(62,16,'Media Manager','media_manager',1,1,0,1,'2018-07-09 03:50:26','2026-02-06 11:10:54'),(63,16,'Banner Images','banner_images',1,1,0,1,'2018-06-22 10:46:02','2026-02-06 11:10:54'),(64,16,'Pages','pages',1,1,1,1,'2018-06-22 10:46:21','2026-02-06 11:10:54'),(65,16,'Gallery','gallery',1,1,1,1,'2018-06-22 10:47:02','2026-02-06 11:10:54'),(66,16,'Event','event',1,1,1,1,'2018-06-22 10:47:20','2026-02-06 11:10:54'),(67,16,'News','notice',1,1,1,1,'2018-07-03 08:39:34','2026-02-06 11:10:54'),(68,2,'Fees Group Assign','fees_group_assign',1,0,0,0,'2018-06-22 10:20:42','2026-02-06 11:10:54'),(69,2,'Fees Type','fees_type',1,1,1,1,'2018-06-22 10:19:34','2026-02-06 11:10:54'),(70,2,'Fees Discount','fees_discount',1,1,1,1,'2018-06-22 10:20:10','2026-02-06 11:10:54'),(71,2,'Fees Discount Assign','fees_discount_assign',1,0,0,0,'2018-06-22 10:20:17','2026-02-06 11:10:54'),(73,2,'Search Fees Payment','search_fees_payment',1,0,0,0,'2018-06-22 10:20:27','2026-02-06 11:10:54'),(74,2,'Search Due Fees','search_due_fees',1,0,0,0,'2018-06-22 10:20:35','2026-02-06 11:10:54'),(77,7,'Assign Class Teacher','assign_class_teacher',1,1,1,1,'2018-06-22 10:30:52','2026-02-06 11:10:54'),(78,17,'Admission Enquiry','admission_enquiry',1,1,1,1,'2018-06-22 10:51:24','2026-02-06 11:10:54'),(79,17,'Follow Up Admission Enquiry','follow_up_admission_enquiry',1,1,0,1,'2018-06-22 10:51:39','2026-02-06 11:10:54'),(80,17,'Visitor Book','visitor_book',1,1,1,1,'2018-06-22 10:48:58','2026-02-06 11:10:54'),(81,17,'Phone Call Log','phone_call_log',1,1,1,1,'2018-06-22 10:50:57','2026-02-06 11:10:54'),(82,17,'Postal Dispatch','postal_dispatch',1,1,1,1,'2018-06-22 10:50:21','2026-02-06 11:10:54'),(83,17,'Postal Receive','postal_receive',1,1,1,1,'2018-06-22 10:50:04','2026-02-06 11:10:54'),(84,17,'Complain','complaint',1,1,1,1,'2018-07-03 08:40:55','2026-02-06 11:10:54'),(85,17,'Setup Front Office','setup_font_office',1,1,1,1,'2025-02-13 09:03:14','2026-02-06 11:10:54'),(86,18,'Staff','staff',1,1,1,1,'2018-06-22 10:53:31','2026-02-06 11:10:54'),(87,18,'Disable Staff','disable_staff',1,0,0,0,'2018-06-22 10:53:12','2026-02-06 11:10:54'),(88,18,'Staff Attendance','staff_attendance',1,1,1,0,'2018-06-22 10:53:10','2026-02-06 11:10:54'),(90,18,'Staff Payroll','staff_payroll',1,1,0,1,'2018-06-22 10:52:51','2026-02-06 11:10:54'),(93,19,'Homework','homework',1,1,1,1,'2018-06-22 10:53:50','2026-02-06 11:10:54'),(94,19,'Homework Evaluation','homework_evaluation',1,1,0,0,'2018-06-27 03:07:21','2026-02-06 11:10:54'),(96,20,'Student Certificate','student_certificate',1,1,1,1,'2018-07-06 10:41:07','2026-02-06 11:10:54'),(97,20,'Generate Certificate','generate_certificate',1,0,0,0,'2018-07-06 10:37:16','2026-02-06 11:10:54'),(98,20,'Student ID Card','student_id_card',1,1,1,1,'2018-07-06 10:41:28','2026-02-06 11:10:54'),(99,20,'Generate ID Card','generate_id_card',1,0,0,0,'2018-07-06 10:41:49','2026-02-06 11:10:54'),(102,21,'Calendar To Do List','calendar_to_do_list',1,1,1,1,'2018-06-22 10:54:41','2026-02-06 11:10:54'),(104,10,'Item Category','item_category',1,1,1,1,'2018-06-22 10:34:33','2026-02-06 11:10:54'),(106,22,'Quick Session Change','quick_session_change',1,0,0,0,'2018-06-22 10:54:45','2026-02-06 11:10:54'),(107,1,'Disable Student','disable_student',1,0,0,0,'2018-06-25 06:21:34','2026-02-06 11:10:54'),(108,18,' Approve Leave Request','approve_leave_request',1,0,1,1,'2020-10-05 08:56:27','2026-02-06 11:10:54'),(109,18,'Apply Leave','apply_leave',1,1,0,0,'2019-11-28 23:47:46','2026-02-06 11:10:54'),(110,18,'Leave Types ','leave_types',1,1,1,1,'2018-07-02 10:17:56','2026-02-06 11:10:54'),(111,18,'Department','department',1,1,1,1,'2018-06-26 03:57:07','2026-02-06 11:10:54'),(112,18,'Designation','designation',1,1,1,1,'2018-06-26 03:57:07','2026-02-06 11:10:54'),(113,22,'Fees Collection And Expense Monthly Chart','fees_collection_and_expense_monthly_chart',1,0,0,0,'2018-07-03 07:08:15','2026-02-06 11:10:54'),(114,22,'Fees Collection And Expense Yearly Chart','fees_collection_and_expense_yearly_chart',1,0,0,0,'2018-07-03 07:08:15','2026-02-06 11:10:54'),(115,22,'Monthly Fees Collection Widget','Monthly fees_collection_widget',1,0,0,0,'2018-07-03 07:13:35','2026-02-06 11:10:54'),(116,22,'Monthly Expense Widget','monthly_expense_widget',1,0,0,0,'2018-07-03 07:13:35','2026-02-06 11:10:54'),(117,22,'Student Count Widget','student_count_widget',1,0,0,0,'2018-07-03 07:13:35','2026-02-06 11:10:54'),(118,22,'Staff Role Count Widget','staff_role_count_widget',1,0,0,0,'2018-07-03 07:13:35','2026-02-06 11:10:54'),(122,5,'Attendance By Date','attendance_by_date',1,0,0,0,'2018-07-03 08:42:29','2026-02-06 11:10:54'),(123,9,'Add Student','add_student',1,0,0,0,'2018-07-03 08:42:29','2026-02-06 11:10:54'),(126,15,'User Status','user_status',1,0,0,0,'2018-07-03 08:42:29','2026-02-06 11:10:54'),(127,18,'Can See Other Users Profile','can_see_other_users_profile',1,0,0,0,'2018-07-03 08:42:29','2026-02-06 11:10:54'),(128,1,'Student Timeline','student_timeline',1,1,1,1,'2022-12-28 09:52:24','2026-02-06 11:10:54'),(129,18,'Staff Timeline','staff_timeline',1,1,1,1,'2022-12-28 09:52:24','2026-02-06 11:10:54'),(130,15,'Backup','backup',1,1,0,1,'2018-07-09 04:17:17','2026-02-06 11:10:54'),(131,15,'Restore','restore',1,0,0,0,'2018-07-09 04:17:17','2026-02-06 11:10:54'),(134,1,'Disable Reason','disable_reason',1,1,1,1,'2019-11-27 06:39:21','2026-02-06 11:10:54'),(135,2,'Fees Reminder','fees_reminder',1,0,1,0,'2019-10-25 00:39:49','2026-02-06 11:10:54'),(136,5,'Approve Leave','approve_leave',1,1,1,1,'2022-12-28 09:52:24','2026-02-06 11:10:54'),(137,6,'Exam Group','exam_group',1,1,1,1,'2019-10-25 01:02:34','2026-02-06 11:10:54'),(141,6,'Design Admit Card','design_admit_card',1,1,1,1,'2019-10-25 01:06:59','2026-02-06 11:10:54'),(142,6,'Print Admit Card','print_admit_card',1,0,0,0,'2019-11-23 23:57:51','2026-02-06 11:10:54'),(143,6,'Design Marksheet','design_marksheet',1,1,1,1,'2019-10-25 01:10:25','2026-02-06 11:10:54'),(144,6,'Print Marksheet','print_marksheet',1,0,0,0,'2019-10-25 01:11:02','2026-02-06 11:10:54'),(145,7,'Teachers Timetable','teachers_time_table',1,0,0,0,'2019-11-30 02:52:21','2026-02-06 11:10:54'),(146,14,'Student Report','student_report',1,0,0,0,'2019-10-25 01:27:00','2026-02-06 11:10:54'),(147,14,'Guardian Report','guardian_report',1,0,0,0,'2019-10-25 01:30:27','2026-02-06 11:10:54'),(148,14,'Student History','student_history',1,0,0,0,'2019-10-25 01:39:07','2026-02-06 11:10:54'),(149,14,'Student Login Credential Report','student_login_credential_report',1,0,0,0,'2019-10-25 01:39:07','2026-02-06 11:10:54'),(150,14,'Class Subject Report','class_subject_report',1,0,0,0,'2019-10-25 01:39:07','2026-02-06 11:10:54'),(151,14,'Admission Report','admission_report',1,0,0,0,'2019-10-25 01:39:07','2026-02-06 11:10:54'),(152,14,'Sibling Report','sibling_report',1,0,0,0,'2019-10-25 01:39:07','2026-02-06 11:10:54'),(153,14,'Homework Evaluation Report','homehork_evaluation_report',1,0,0,0,'2019-11-24 01:04:24','2026-02-06 11:10:54'),(154,14,'Student Profile','student_profile',1,0,0,0,'2019-10-25 01:39:07','2026-02-06 11:10:54'),(155,14,'Fees Statement','fees_statement',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(156,14,'Balance Fees Report','balance_fees_report',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(157,14,'Fees Collection Report','fees_collection_report',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(158,14,'Online Fees Collection Report','online_fees_collection_report',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(159,14,'Income Report','income_report',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(160,14,'Expense Report','expense_report',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(161,14,'PayRoll Report','payroll_report',1,0,0,0,'2019-10-31 00:23:22','2026-02-06 11:10:54'),(162,14,'Income Group Report','income_group_report',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(163,14,'Expense Group Report','expense_group_report',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(164,14,'Attendance Report','attendance_report',1,0,0,0,'2019-10-25 02:08:06','2026-02-06 11:10:54'),(165,14,'Staff Attendance Report','staff_attendance_report',1,0,0,0,'2019-10-25 02:08:06','2026-02-06 11:10:54'),(174,14,'Transport Report','transport_report',1,0,0,0,'2019-10-25 02:13:56','2026-02-06 11:10:54'),(175,14,'Hostel Report','hostel_report',1,0,0,0,'2019-11-27 06:51:53','2026-02-06 11:10:54'),(176,14,'Audit Trail Report','audit_trail_report',1,0,0,0,'2019-10-25 02:16:39','2026-02-06 11:10:54'),(177,14,'User Log','user_log',1,0,0,0,'2019-10-25 02:19:27','2026-02-06 11:10:54'),(178,14,'Book Issue Report','book_issue_report',1,0,0,0,'2019-10-25 02:29:04','2026-02-06 11:10:54'),(179,14,'Book Due Report','book_due_report',1,0,0,0,'2019-10-25 02:29:04','2026-02-06 11:10:54'),(180,14,'Book Inventory Report','book_inventory_report',1,0,0,0,'2019-10-25 02:29:04','2026-02-06 11:10:54'),(181,14,'Stock Report','stock_report',1,0,0,0,'2019-10-25 02:31:28','2026-02-06 11:10:54'),(182,14,'Add Item Report','add_item_report',1,0,0,0,'2019-10-25 02:31:28','2026-02-06 11:10:54'),(183,14,'Issue Item Report','issue_item_report',1,0,0,0,'2019-11-29 03:48:06','2026-02-06 11:10:54'),(185,23,'Online Examination','online_examination',1,1,1,1,'2019-11-23 23:54:50','2026-02-06 11:10:54'),(186,23,'Question Bank','question_bank',1,1,1,1,'2019-11-23 23:55:18','2026-02-06 11:10:54'),(187,6,'Exam Result','exam_result',1,0,0,0,'2019-11-23 23:58:50','2026-02-06 11:10:54'),(188,7,'Subject Group','subject_group',1,1,1,1,'2019-11-24 00:34:32','2026-02-06 11:10:54'),(189,18,'Teachers Rating','teachers_rating',1,0,1,1,'2019-11-24 03:12:54','2026-02-06 11:10:54'),(190,22,'Fees Awaiting Payment Widegts','fees_awaiting_payment_widegts',1,0,0,0,'2019-11-24 00:52:51','2026-02-06 11:10:54'),(191,22,'Converted Leads Widegts','conveted_leads_widegts',1,0,0,0,'2025-02-13 09:03:14','2026-02-06 11:10:54'),(192,22,'Fees Overview Widegts','fees_overview_widegts',1,0,0,0,'2019-11-24 00:57:41','2026-02-06 11:10:54'),(193,22,'Enquiry Overview Widegts','enquiry_overview_widegts',1,0,0,0,'2019-12-02 05:06:09','2026-02-06 11:10:54'),(194,22,'Library Overview Widegts','book_overview_widegts',1,0,0,0,'2019-12-01 01:13:04','2026-02-06 11:10:54'),(195,22,'Student Today Attendance Widegts','today_attendance_widegts',1,0,0,0,'2019-12-03 04:57:45','2026-02-06 11:10:54'),(196,6,'Marks Import','marks_import',1,0,0,0,'2019-11-24 01:02:11','2026-02-06 11:10:54'),(197,14,'Student Attendance Type Report','student_attendance_type_report',1,0,0,0,'2019-11-24 01:06:32','2026-02-06 11:10:54'),(198,14,'Exam Marks Report','exam_marks_report',1,0,0,0,'2019-11-24 01:11:15','2026-02-06 11:10:54'),(200,14,'Online Exam Wise Report','online_exam_wise_report',1,0,0,0,'2019-11-24 01:18:14','2026-02-06 11:10:54'),(201,14,'Online Exams Report','online_exams_report',1,0,0,0,'2019-11-29 02:48:05','2026-02-06 11:10:54'),(202,14,'Online Exams Attempt Report','online_exams_attempt_report',1,0,0,0,'2019-11-29 02:46:24','2026-02-06 11:10:54'),(203,14,'Online Exams Rank Report','online_exams_rank_report',1,0,0,0,'2019-11-24 01:22:25','2026-02-06 11:10:54'),(204,14,'Staff Report','staff_report',1,0,0,0,'2019-11-24 01:25:27','2026-02-06 11:10:54'),(205,6,'Exam','exam',1,1,1,1,'2019-11-24 04:55:48','2026-02-06 11:10:54'),(207,6,'Exam Publish','exam_publish',1,0,0,0,'2019-11-24 05:15:04','2026-02-06 11:10:54'),(208,6,'Link Exam','link_exam',1,0,1,0,'2019-11-24 05:15:04','2026-02-06 11:10:54'),(210,6,'Assign / View student','exam_assign_view_student',1,0,1,0,'2019-11-24 05:15:04','2026-02-06 11:10:54'),(211,6,'Exam Subject','exam_subject',1,0,1,0,'2019-11-24 05:15:04','2026-02-06 11:10:54'),(212,6,'Exam Marks','exam_marks',1,0,1,0,'2019-11-24 05:15:04','2026-02-06 11:10:54'),(213,15,'Language Switcher','language_switcher',1,0,0,0,'2019-11-24 05:17:11','2026-02-06 11:10:54'),(214,23,'Add Questions in Exam ','add_questions_in_exam',1,0,1,0,'2019-11-28 01:38:57','2026-02-06 11:10:54'),(215,15,'Custom Fields','custom_fields',1,0,0,0,'2019-11-29 04:08:35','2026-02-06 11:10:54'),(216,15,'System Fields','system_fields',1,0,0,0,'2019-11-25 00:15:01','2026-02-06 11:10:54'),(217,13,'SMS','sms',1,0,0,0,'2018-06-22 10:40:54','2026-02-06 11:10:54'),(219,14,'Student / Period Attendance Report','student_period_attendance_report',1,0,0,0,'2019-11-29 02:19:31','2026-02-06 11:10:54'),(220,14,'Biometric Attendance Log','biometric_attendance_log',1,0,0,0,'2019-11-27 05:59:16','2026-02-06 11:10:54'),(221,14,'Book Issue Return Report','book_issue_return_report',1,0,0,0,'2019-11-27 06:30:23','2026-02-06 11:10:54'),(222,23,'Assign / View Student','online_assign_view_student',1,0,1,0,'2019-11-28 04:20:22','2026-02-06 11:10:54'),(223,14,'Rank Report','rank_report',1,0,0,0,'2019-11-29 02:30:21','2026-02-06 11:10:54'),(224,25,'Chat','chat',1,0,0,0,'2019-11-29 04:10:28','2026-02-06 11:10:54'),(226,22,'Income Donut Graph','income_donut_graph',1,0,0,0,'2019-11-29 05:00:33','2026-02-06 11:10:54'),(227,22,'Expense Donut Graph','expense_donut_graph',1,0,0,0,'2019-11-29 05:01:10','2026-02-06 11:10:54'),(228,9,'Import Book','import_book',1,0,0,0,'2019-11-29 06:21:01','2026-02-06 11:10:54'),(229,22,'Staff Present Today Widegts','staff_present_today_widegts',1,0,0,0,'2019-11-29 06:48:00','2026-02-06 11:10:54'),(230,22,'Student Present Today Widegts','student_present_today_widegts',1,0,0,0,'2019-11-29 06:47:42','2026-02-06 11:10:54'),(231,26,'Multi Class Student','multi_class_student',1,1,1,1,'2020-10-05 08:56:27','2026-02-06 11:10:54'),(232,27,'Online Admission','online_admission',1,0,1,1,'2019-12-02 06:11:10','2026-02-06 11:10:54'),(233,15,'Print Header Footer','print_header_footer',1,0,0,0,'2020-02-12 02:02:02','2026-02-06 11:10:54'),(234,28,'Manage Alumni','manage_alumni',1,1,1,1,'2020-06-02 03:15:46','2026-02-06 11:10:54'),(235,28,'Events','events',1,1,1,1,'2020-05-28 21:48:52','2026-02-06 11:10:54'),(236,29,'Manage Lesson Plan','manage_lesson_plan',1,1,1,0,'2020-05-28 22:17:37','2026-02-06 11:10:54'),(237,29,'Manage Syllabus Status','manage_syllabus_status',1,0,1,0,'2020-05-28 22:20:11','2026-02-06 11:10:54'),(238,29,'Lesson','lesson',1,1,1,1,'2020-05-28 22:20:11','2026-02-06 11:10:54'),(239,29,'Topic','topic',1,1,1,1,'2020-05-28 22:20:11','2026-02-06 11:10:54'),(240,14,'Syllabus Status Report','syllabus_status_report',1,0,0,0,'2020-05-28 23:17:54','2026-02-06 11:10:54'),(241,14,'Teacher Syllabus Status Report','teacher_syllabus_status_report',1,0,0,0,'2020-05-28 23:17:54','2026-02-06 11:10:54'),(242,14,'Alumni Report','alumni_report',1,0,0,0,'2020-06-07 23:59:54','2026-02-06 11:10:54'),(243,15,'Student Profile Update','student_profile_update',1,0,0,0,'2020-08-21 05:36:33','2026-02-06 11:10:54'),(244,14,'Student Gender Ratio Report','student_gender_ratio_report',1,0,0,0,'2020-08-22 12:37:51','2026-02-06 11:10:54'),(245,14,'Student Teacher Ratio Report','student_teacher_ratio_report',1,0,0,0,'2020-08-22 12:42:27','2026-02-06 11:10:54'),(246,14,'Daily Attendance Report','daily_attendance_report',1,0,0,0,'2020-08-22 12:43:16','2026-02-06 11:10:54'),(247,23,'Import Question','import_question',1,0,0,0,'2019-11-23 18:25:18','2026-02-06 11:10:54'),(248,20,'Staff ID Card','staff_id_card',1,1,1,1,'2018-07-06 10:41:28','2026-02-06 11:10:54'),(249,20,'Generate Staff ID Card','generate_staff_id_card',1,0,0,0,'2018-07-06 10:41:49','2026-02-06 11:10:54'),(250,19,'Daily Assignment','daily_assignment',1,0,0,0,'2022-03-02 07:28:23','2026-02-06 11:10:54'),(251,6,'Marks Division','marks_division',1,1,1,1,'2022-07-01 15:24:16','2026-02-06 11:10:54'),(252,13,'Schedule Email SMS Log','schedule_email_sms_log',1,0,1,0,'2022-07-09 11:25:16','2026-02-06 11:10:54'),(253,13,'Login Credentials Send','login_credentials_send',1,0,0,0,'2022-07-01 15:46:10','2026-02-06 11:10:54'),(254,13,'Email Template','email_template',1,1,1,1,'2022-07-01 15:46:10','2026-02-06 11:10:54'),(255,13,'SMS Template','sms_template',1,1,1,1,'2022-07-01 15:46:10','2026-02-06 11:10:54'),(256,14,'Balance Fees Report With Remark','balance_fees_report_with_remark',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(257,14,'Balance Fees Statement','balance_fees_statement',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(258,14,'Daily Collection Report','daily_collection_report',1,0,0,0,'2019-10-25 01:55:52','2026-02-06 11:10:54'),(259,11,'Fees Master','transport_fees_master',1,0,1,0,'2022-07-05 09:29:19','2026-02-06 11:10:54'),(260,11,'Pickup Point','pickup_point',1,1,1,1,'2022-07-04 09:50:08','2026-02-06 11:10:54'),(261,11,'Route Pickup Point','route_pickup_point',1,1,1,1,'2022-07-04 09:50:08','2026-02-06 11:10:54'),(262,11,'Student Transport Fees','student_transport_fees',1,1,1,0,'2022-07-05 10:15:55','2026-02-06 11:10:54'),(263,29,'Comments','lesson_plan_comments',1,1,0,1,'2020-05-28 22:20:11','2026-02-06 11:10:54'),(264,15,'Sidebar Menu','sidebar_menu',1,0,0,0,'2022-07-11 12:01:17','2026-02-06 11:10:54'),(265,15,'Currency','currency',1,0,0,0,'2020-08-21 05:36:33','2026-02-06 11:10:54'),(266,6,'Exam Schedule','exam_schedule',1,0,0,0,'2019-11-23 23:58:50','2026-02-06 11:10:54'),(267,6,'Generate Rank','generate_rank',1,0,0,0,'2019-11-24 05:15:04','2026-02-06 11:10:54'),(268,8,'Content Type','content_type',1,1,1,1,'2022-07-08 05:18:54','2026-02-06 11:10:54'),(269,8,'Content Share List','content_share_list',1,0,0,1,'2022-07-08 05:18:58','2026-02-06 11:10:54'),(270,8,'Video Tutorial','video_tutorial',1,1,1,1,'2022-07-08 05:19:01','2026-02-06 11:10:54'),(271,15,'Currency Switcher','currency_switcher',1,0,0,0,'2019-11-24 05:17:11','2026-02-06 11:10:54'),(272,2,'Offline Bank Payments','offline_bank_payments',1,0,0,0,'2018-06-27 00:18:15','2026-02-06 11:10:54'),(273,29,'Copy Old Lessons','copy_old_lesson',1,0,0,0,'2020-05-28 22:20:11','2026-02-06 11:10:54'),(274,30,'Annual Calendar','annual_calendar',1,1,1,1,'2020-05-28 22:20:11','2026-02-06 11:10:54'),(275,30,'Holiday Type','holiday_type',1,1,1,1,'2024-10-14 12:31:14','2026-02-06 11:10:54'),(276,14,'Online Admission Report','online_admission_report',1,0,0,0,'2020-08-22 12:42:27','2026-02-06 11:10:54'),(277,31,'Download CV','download_cv',1,0,0,0,'2024-12-10 11:06:30','2026-02-06 11:10:54'),(278,31,'Build CV','build_cv',1,1,0,1,'2024-12-13 07:05:10','2026-02-06 11:10:54'),(279,31,'Setting','download_cv_setting',1,0,0,0,'2024-12-10 11:06:30','2026-02-06 11:10:54'),(280,22,'Student Head Count Widget','student_head_count_widget',1,0,0,0,'2018-07-03 07:13:35','2026-02-06 11:10:54'),(281,22,'Staff Approved Leave Widegts','staff_approved_leave_widegts',1,0,0,0,'2018-07-03 07:13:35','2026-02-06 11:10:54'),(282,22,'Student Approved Leave Widegts','student_approved_leave_widegts',1,0,0,0,'2018-07-03 07:13:35','2026-02-06 11:10:54');
INSERT INTO `roles_permissions` (`id`, `role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`, `updated_at`) VALUES (11,1,78,1,1,1,1,'2018-07-03 00:49:43','2026-02-06 11:10:54'),(23,1,12,1,1,1,1,'2018-07-06 09:45:38','2026-02-06 11:10:54'),(24,1,13,1,1,1,1,'2018-07-06 09:48:28','2026-02-06 11:10:54'),(26,1,15,1,1,1,0,'2019-11-27 23:47:28','2026-02-06 11:10:54'),(31,1,21,1,0,1,0,'2019-11-26 04:51:15','2026-02-06 11:10:54'),(34,1,24,1,1,1,1,'2019-11-28 06:35:20','2026-02-06 11:10:54'),(43,1,32,1,1,1,1,'2018-07-06 10:22:05','2026-02-06 11:10:54'),(44,1,33,1,1,1,1,'2018-07-06 10:22:29','2026-02-06 11:10:54'),(45,1,34,1,1,1,1,'2018-07-06 10:23:59','2026-02-06 11:10:54'),(46,1,35,1,1,1,1,'2018-07-06 10:24:34','2026-02-06 11:10:54'),(47,1,104,1,1,1,1,'2018-07-06 10:23:08','2026-02-06 11:10:54'),(48,1,37,1,1,1,1,'2018-07-06 10:25:30','2026-02-06 11:10:54'),(49,1,38,1,1,1,1,'2018-07-09 05:15:27','2026-02-06 11:10:54'),(61,1,55,1,1,1,1,'2018-07-02 09:24:16','2026-02-06 11:10:54'),(67,1,61,1,1,0,1,'2018-07-09 05:59:19','2026-02-06 11:10:54'),(68,1,62,1,1,0,1,'2018-07-09 05:59:19','2026-02-06 11:10:54'),(69,1,63,1,1,0,1,'2018-07-09 03:51:38','2026-02-06 11:10:54'),(70,1,64,1,1,1,1,'2018-07-09 03:02:19','2026-02-06 11:10:54'),(71,1,65,1,1,1,1,'2018-07-09 03:11:21','2026-02-06 11:10:54'),(72,1,66,1,1,1,1,'2018-07-09 03:13:09','2026-02-06 11:10:54'),(73,1,67,1,1,1,1,'2018-07-09 03:14:47','2026-02-06 11:10:54'),(74,1,79,1,1,0,1,'2019-11-30 01:32:51','2026-02-06 11:10:54'),(75,1,80,1,1,1,1,'2018-07-06 09:41:23','2026-02-06 11:10:54'),(76,1,81,1,1,1,1,'2018-07-06 09:41:23','2026-02-06 11:10:54'),(78,1,83,1,1,1,1,'2018-07-06 09:41:23','2026-02-06 11:10:54'),(79,1,84,1,1,1,1,'2018-07-06 09:41:23','2026-02-06 11:10:54'),(80,1,85,1,1,1,1,'2018-07-12 00:16:00','2026-02-06 11:10:54'),(94,1,82,1,1,1,1,'2018-07-06 09:41:23','2026-02-06 11:10:54'),(120,1,39,1,1,1,1,'2018-07-06 10:26:28','2026-02-06 11:10:54'),(156,1,9,1,1,1,1,'2019-11-27 23:45:46','2026-02-06 11:10:54'),(157,1,10,1,1,1,1,'2019-11-27 23:45:46','2026-02-06 11:10:54'),(159,1,40,1,1,1,1,'2019-11-30 00:49:39','2026-02-06 11:10:54'),(160,1,41,1,1,1,1,'2019-12-02 05:43:41','2026-02-06 11:10:54'),(161,1,42,1,1,1,1,'2019-11-30 00:49:39','2026-02-06 11:10:54'),(169,1,27,1,1,0,1,'2019-11-29 06:15:37','2026-02-06 11:10:54'),(178,1,54,1,0,1,0,'2018-07-05 09:09:22','2026-02-06 11:10:54'),(179,1,56,1,0,1,0,'2019-11-30 00:49:54','2026-02-06 11:10:54'),(180,1,57,1,0,1,0,'2019-11-30 01:32:51','2026-02-06 11:10:54'),(181,1,58,1,0,1,0,'2019-11-30 01:32:51','2026-02-06 11:10:54'),(182,1,59,1,0,1,0,'2019-11-30 01:32:51','2026-02-06 11:10:54'),(183,1,60,1,0,1,0,'2019-11-30 00:59:57','2026-02-06 11:10:54'),(201,1,14,1,0,0,0,'2018-07-02 11:22:03','2026-02-06 11:10:54'),(204,1,26,1,0,0,0,'2018-07-02 11:32:05','2026-02-06 11:10:54'),(206,1,29,1,0,0,0,'2018-07-02 11:43:54','2026-02-06 11:10:54'),(207,1,30,1,0,0,0,'2018-07-02 11:43:54','2026-02-06 11:10:54'),(208,1,31,1,1,1,1,'2019-11-30 01:32:51','2026-02-06 11:10:54'),(222,1,1,1,1,1,1,'2019-11-27 22:55:06','2026-02-06 11:10:54'),(307,1,126,1,0,0,0,'2018-07-03 09:26:13','2026-02-06 11:10:54'),(315,1,123,1,0,0,0,'2018-07-03 10:27:03','2026-02-06 11:10:54'),(369,1,102,1,1,1,1,'2019-12-02 05:02:15','2026-02-06 11:10:54'),(435,1,96,1,1,1,1,'2018-07-09 01:03:54','2026-02-06 11:10:54'),(461,1,97,1,0,0,0,'2018-07-09 01:00:16','2026-02-06 11:10:54'),(464,1,86,1,1,1,1,'2019-11-28 06:39:19','2026-02-06 11:10:54'),(474,1,130,1,1,0,1,'2018-07-09 10:56:36','2026-02-06 11:10:54'),(476,1,131,1,0,0,0,'2018-07-09 04:53:32','2026-02-06 11:10:54'),(557,6,82,1,1,1,1,'2019-12-01 01:48:28','2026-02-06 11:10:54'),(558,6,83,1,1,1,1,'2019-12-01 01:49:08','2026-02-06 11:10:54'),(559,6,84,1,1,1,1,'2019-12-01 01:49:59','2026-02-06 11:10:54'),(575,6,44,1,0,0,0,'2018-07-10 07:35:33','2026-02-06 11:10:54'),(576,6,46,1,0,0,0,'2018-07-10 07:35:33','2026-02-06 11:10:54'),(578,6,102,1,1,1,1,'2019-12-01 01:52:27','2026-02-06 11:10:54'),(625,1,28,1,1,1,1,'2019-11-29 06:19:18','2026-02-06 11:10:54'),(634,4,102,1,1,1,1,'2019-12-01 01:03:00','2026-02-06 11:10:54'),(669,1,145,1,0,0,0,'2019-11-26 04:51:15','2026-02-06 11:10:54'),(677,1,153,1,0,0,0,'2019-11-01 02:28:24','2026-02-06 11:10:54'),(720,1,216,1,0,0,0,'2019-11-26 05:24:12','2026-02-06 11:10:54'),(728,1,185,1,1,1,1,'2019-11-28 02:50:33','2026-02-06 11:10:54'),(729,1,186,1,1,1,1,'2019-11-28 02:49:07','2026-02-06 11:10:54'),(730,1,214,1,0,1,0,'2019-11-28 01:47:53','2026-02-06 11:10:54'),(732,1,198,1,0,0,0,'2019-11-26 05:24:30','2026-02-06 11:10:54'),(734,1,200,1,0,0,0,'2019-11-26 05:24:30','2026-02-06 11:10:54'),(735,1,201,1,0,0,0,'2019-11-26 05:24:30','2026-02-06 11:10:54'),(736,1,202,1,0,0,0,'2019-11-26 05:24:30','2026-02-06 11:10:54'),(737,1,203,1,0,0,0,'2019-11-26 05:24:30','2026-02-06 11:10:54'),(747,1,2,1,0,0,0,'2019-11-27 22:56:08','2026-02-06 11:10:54'),(748,1,3,1,1,1,1,'2019-11-27 22:56:32','2026-02-06 11:10:54'),(749,1,4,1,1,1,1,'2019-11-27 22:56:48','2026-02-06 11:10:54'),(751,1,128,0,1,0,1,'2019-11-27 22:57:01','2026-02-06 11:10:54'),(754,1,134,1,1,1,1,'2019-11-27 23:18:21','2026-02-06 11:10:54'),(755,1,5,1,1,0,1,'2019-11-27 23:35:07','2026-02-06 11:10:54'),(756,1,6,1,0,0,0,'2019-11-27 23:35:25','2026-02-06 11:10:54'),(757,1,7,1,1,1,1,'2019-11-27 23:36:35','2026-02-06 11:10:54'),(758,1,8,1,1,1,1,'2019-11-27 23:37:27','2026-02-06 11:10:54'),(760,1,68,1,0,0,0,'2019-11-27 23:38:06','2026-02-06 11:10:54'),(761,1,69,1,1,1,1,'2019-11-27 23:39:06','2026-02-06 11:10:54'),(762,1,70,1,1,1,1,'2019-11-27 23:39:41','2026-02-06 11:10:54'),(763,1,71,1,0,0,0,'2019-11-27 23:39:59','2026-02-06 11:10:54'),(765,1,73,1,0,0,0,'2019-11-27 23:43:15','2026-02-06 11:10:54'),(766,1,74,1,0,0,0,'2019-11-27 23:43:55','2026-02-06 11:10:54'),(768,1,11,1,0,0,0,'2019-11-27 23:45:46','2026-02-06 11:10:54'),(769,1,122,1,0,0,0,'2019-11-27 23:52:43','2026-02-06 11:10:54'),(771,1,136,1,0,0,0,'2019-11-27 23:55:36','2026-02-06 11:10:54'),(772,1,20,1,1,1,1,'2019-11-28 04:06:44','2026-02-06 11:10:54'),(773,1,137,1,1,1,1,'2019-11-28 00:46:14','2026-02-06 11:10:54'),(774,1,141,1,1,1,1,'2019-11-28 00:59:42','2026-02-06 11:10:54'),(775,1,142,1,0,0,0,'2019-11-27 23:56:12','2026-02-06 11:10:54'),(776,1,143,1,1,1,1,'2019-11-28 00:59:42','2026-02-06 11:10:54'),(777,1,144,1,0,0,0,'2019-11-27 23:56:12','2026-02-06 11:10:54'),(778,1,187,1,0,0,0,'2019-11-27 23:56:12','2026-02-06 11:10:54'),(779,1,196,1,0,0,0,'2019-11-27 23:56:12','2026-02-06 11:10:54'),(781,1,207,1,0,0,0,'2019-11-27 23:56:12','2026-02-06 11:10:54'),(782,1,208,1,0,1,0,'2019-11-28 00:10:22','2026-02-06 11:10:54'),(783,1,210,1,0,1,0,'2019-11-28 00:34:40','2026-02-06 11:10:54'),(784,1,211,1,0,1,0,'2019-11-28 00:38:23','2026-02-06 11:10:54'),(785,1,212,1,0,1,0,'2019-11-28 00:42:15','2026-02-06 11:10:54'),(786,1,205,1,1,1,1,'2019-11-28 00:42:15','2026-02-06 11:10:54'),(787,1,222,1,0,1,0,'2019-11-28 01:36:36','2026-02-06 11:10:54'),(788,1,77,1,1,1,1,'2019-11-28 06:22:10','2026-02-06 11:10:54'),(789,1,188,1,1,1,1,'2019-11-28 06:26:16','2026-02-06 11:10:54'),(790,1,23,1,1,1,1,'2019-11-28 06:34:20','2026-02-06 11:10:54'),(791,1,25,1,1,1,1,'2019-11-28 06:36:20','2026-02-06 11:10:54'),(792,1,127,1,0,0,0,'2019-11-28 06:41:25','2026-02-06 11:10:54'),(794,1,88,1,1,1,0,'2019-11-28 06:43:04','2026-02-06 11:10:54'),(795,1,90,1,1,0,1,'2019-11-28 06:46:22','2026-02-06 11:10:54'),(796,1,108,1,0,1,1,'2021-01-23 07:09:32','2026-02-06 11:10:54'),(797,1,109,1,1,0,0,'2019-11-28 23:38:11','2026-02-06 11:10:54'),(798,1,110,1,1,1,1,'2019-11-28 23:49:29','2026-02-06 11:10:54'),(799,1,111,1,1,1,1,'2019-11-28 23:49:57','2026-02-06 11:10:54'),(800,1,112,1,1,1,1,'2019-11-28 23:49:57','2026-02-06 11:10:54'),(801,1,129,0,1,0,1,'2019-11-28 23:49:57','2026-02-06 11:10:54'),(802,1,189,1,0,1,1,'2019-11-28 23:59:22','2026-02-06 11:10:54'),(810,2,1,1,1,1,1,'2019-11-30 02:54:16','2026-02-06 11:10:54'),(817,1,93,1,1,1,1,'2019-11-29 00:56:14','2026-02-06 11:10:54'),(825,1,87,1,0,0,0,'2019-11-29 00:56:14','2026-02-06 11:10:54'),(829,1,94,1,1,0,0,'2019-11-29 00:57:57','2026-02-06 11:10:54'),(836,1,146,1,0,0,0,'2019-11-29 01:13:28','2026-02-06 11:10:54'),(837,1,147,1,0,0,0,'2019-11-29 01:13:28','2026-02-06 11:10:54'),(838,1,148,1,0,0,0,'2019-11-29 01:13:28','2026-02-06 11:10:54'),(839,1,149,1,0,0,0,'2019-11-29 01:13:28','2026-02-06 11:10:54'),(840,1,150,1,0,0,0,'2019-11-29 01:13:28','2026-02-06 11:10:54'),(841,1,151,1,0,0,0,'2019-11-29 01:13:28','2026-02-06 11:10:54'),(842,1,152,1,0,0,0,'2019-11-29 01:13:28','2026-02-06 11:10:54'),(843,1,154,1,0,0,0,'2019-11-29 01:13:28','2026-02-06 11:10:54'),(862,1,155,1,0,0,0,'2019-11-29 02:07:30','2026-02-06 11:10:54'),(863,1,156,1,0,0,0,'2019-11-29 02:07:52','2026-02-06 11:10:54'),(864,1,157,1,0,0,0,'2019-11-29 02:08:05','2026-02-06 11:10:54'),(874,1,158,1,0,0,0,'2019-11-29 02:14:03','2026-02-06 11:10:54'),(875,1,159,1,0,0,0,'2019-11-29 02:14:31','2026-02-06 11:10:54'),(876,1,160,1,0,0,0,'2019-11-29 02:14:44','2026-02-06 11:10:54'),(878,1,162,1,0,0,0,'2019-11-29 02:15:58','2026-02-06 11:10:54'),(879,1,163,1,0,0,0,'2019-11-29 02:16:19','2026-02-06 11:10:54'),(882,1,164,1,0,0,0,'2019-11-29 02:25:17','2026-02-06 11:10:54'),(884,1,165,1,0,0,0,'2019-11-29 02:25:30','2026-02-06 11:10:54'),(886,1,197,1,0,0,0,'2019-11-29 02:25:48','2026-02-06 11:10:54'),(887,1,219,1,0,0,0,'2019-11-29 02:26:05','2026-02-06 11:10:54'),(889,1,220,1,0,0,0,'2019-11-29 02:26:22','2026-02-06 11:10:54'),(932,1,204,1,0,0,0,'2019-11-29 03:43:27','2026-02-06 11:10:54'),(933,1,221,1,0,0,0,'2019-11-29 03:45:04','2026-02-06 11:10:54'),(934,1,178,1,0,0,0,'2019-11-29 03:45:16','2026-02-06 11:10:54'),(935,1,179,1,0,0,0,'2019-11-29 03:45:33','2026-02-06 11:10:54'),(936,1,161,1,0,0,0,'2019-11-29 03:45:48','2026-02-06 11:10:54'),(937,1,180,1,0,0,0,'2019-11-29 03:45:48','2026-02-06 11:10:54'),(938,1,181,1,0,0,0,'2019-11-29 03:49:33','2026-02-06 11:10:54'),(939,1,182,1,0,0,0,'2019-11-29 03:49:45','2026-02-06 11:10:54'),(940,1,183,1,0,0,0,'2019-11-29 03:49:56','2026-02-06 11:10:54'),(941,1,174,1,0,0,0,'2019-11-29 03:50:53','2026-02-06 11:10:54'),(943,1,176,1,0,0,0,'2019-11-29 03:52:10','2026-02-06 11:10:54'),(944,1,177,1,0,0,0,'2019-11-29 03:52:22','2026-02-06 11:10:54'),(945,1,53,0,1,0,1,'2021-01-23 07:09:32','2026-02-06 11:10:54'),(946,1,215,1,0,0,0,'2019-11-29 04:01:37','2026-02-06 11:10:54'),(947,1,213,1,0,0,0,'2019-11-29 04:07:45','2026-02-06 11:10:54'),(974,1,224,1,0,0,0,'2019-11-29 04:32:52','2026-02-06 11:10:54'),(1026,1,135,1,0,1,0,'2019-11-29 06:02:12','2026-02-06 11:10:54'),(1031,1,228,1,0,0,0,'2019-11-29 06:21:16','2026-02-06 11:10:54'),(1083,1,175,1,0,0,0,'2019-11-30 00:37:24','2026-02-06 11:10:54'),(1086,1,43,1,1,1,1,'2019-11-30 00:49:39','2026-02-06 11:10:54'),(1087,1,44,1,0,0,0,'2019-11-30 00:49:39','2026-02-06 11:10:54'),(1088,1,46,1,0,0,0,'2019-11-30 00:49:39','2026-02-06 11:10:54'),(1089,1,217,1,0,0,0,'2019-11-30 00:49:39','2026-02-06 11:10:54'),(1090,1,98,1,1,1,1,'2019-11-30 01:32:51','2026-02-06 11:10:54'),(1091,1,99,1,0,0,0,'2019-11-30 01:30:18','2026-02-06 11:10:54'),(1092,1,223,1,0,0,0,'2019-11-30 01:32:51','2026-02-06 11:10:54'),(1103,2,205,1,1,1,1,'2019-11-30 01:56:04','2026-02-06 11:10:54'),(1105,2,23,1,0,0,0,'2019-11-30 01:56:04','2026-02-06 11:10:54'),(1106,2,24,1,0,0,0,'2019-11-30 01:56:04','2026-02-06 11:10:54'),(1107,2,25,1,0,0,0,'2019-11-30 01:56:04','2026-02-06 11:10:54'),(1108,2,77,1,0,0,0,'2019-11-30 01:56:04','2026-02-06 11:10:54'),(1119,2,117,1,0,0,0,'2019-11-30 01:56:04','2026-02-06 11:10:54'),(1123,3,8,1,1,1,1,'2019-11-30 06:46:18','2026-02-06 11:10:54'),(1125,3,69,1,1,1,1,'2019-11-30 07:00:49','2026-02-06 11:10:54'),(1126,3,70,1,1,1,1,'2019-11-30 07:04:46','2026-02-06 11:10:54'),(1130,3,9,1,1,1,1,'2019-11-30 07:14:54','2026-02-06 11:10:54'),(1131,3,10,1,1,1,1,'2019-11-30 07:16:02','2026-02-06 11:10:54'),(1134,3,35,1,1,1,1,'2019-11-30 07:25:04','2026-02-06 11:10:54'),(1135,3,104,1,1,1,1,'2019-11-30 07:25:53','2026-02-06 11:10:54'),(1140,3,41,1,1,1,1,'2019-11-30 07:37:13','2026-02-06 11:10:54'),(1141,3,42,1,1,1,1,'2019-11-30 07:37:46','2026-02-06 11:10:54'),(1142,3,43,1,1,1,1,'2019-11-30 07:42:06','2026-02-06 11:10:54'),(1151,3,87,1,0,0,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1152,3,88,1,1,1,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1153,3,90,1,1,0,1,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1154,3,108,1,0,1,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1155,3,109,1,1,0,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1156,3,110,1,1,1,1,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1157,3,111,1,1,1,1,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1158,3,112,1,1,1,1,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1159,3,127,1,0,0,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1160,3,129,0,1,0,1,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1161,3,102,1,1,1,1,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1162,3,106,1,0,0,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1163,3,113,1,0,0,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1164,3,114,1,0,0,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1165,3,115,1,0,0,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1166,3,116,1,0,0,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1167,3,117,1,0,0,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1168,3,118,1,0,0,0,'2019-11-30 02:23:13','2026-02-06 11:10:54'),(1171,2,142,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1172,2,144,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1179,2,212,1,0,1,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1183,2,148,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1184,2,149,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1185,2,150,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1186,2,151,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1187,2,152,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1188,2,153,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1189,2,154,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1190,2,197,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1191,2,198,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1193,2,200,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1194,2,201,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1195,2,202,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1196,2,203,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1197,2,219,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1198,2,223,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1199,2,213,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1201,2,230,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1204,2,214,1,0,1,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1206,2,224,1,0,0,0,'2019-11-30 02:36:17','2026-02-06 11:10:54'),(1208,2,2,1,0,0,0,'2019-11-30 02:55:45','2026-02-06 11:10:54'),(1210,2,143,1,1,1,1,'2019-11-30 02:57:28','2026-02-06 11:10:54'),(1211,2,145,1,0,0,0,'2019-11-30 02:57:28','2026-02-06 11:10:54'),(1214,2,3,1,1,1,1,'2019-11-30 03:03:18','2026-02-06 11:10:54'),(1216,2,4,1,1,1,1,'2019-11-30 03:32:56','2026-02-06 11:10:54'),(1218,2,128,0,1,0,1,'2019-11-30 03:37:44','2026-02-06 11:10:54'),(1220,3,135,1,0,1,0,'2019-11-30 07:08:56','2026-02-06 11:10:54'),(1231,3,190,1,0,0,0,'2019-11-30 03:44:02','2026-02-06 11:10:54'),(1232,3,192,1,0,0,0,'2019-11-30 03:44:02','2026-02-06 11:10:54'),(1233,3,226,1,0,0,0,'2019-11-30 03:44:02','2026-02-06 11:10:54'),(1234,3,227,1,0,0,0,'2019-11-30 03:44:02','2026-02-06 11:10:54'),(1235,3,224,1,0,0,0,'2019-11-30 03:44:02','2026-02-06 11:10:54'),(1236,2,15,1,1,1,0,'2019-11-30 03:54:25','2026-02-06 11:10:54'),(1239,2,122,1,0,0,0,'2019-11-30 03:57:48','2026-02-06 11:10:54'),(1240,2,136,1,0,0,0,'2019-11-30 03:57:48','2026-02-06 11:10:54'),(1242,6,217,1,0,0,0,'2019-11-30 04:00:13','2026-02-06 11:10:54'),(1243,6,224,1,0,0,0,'2019-11-30 04:00:13','2026-02-06 11:10:54'),(1245,2,20,1,1,1,1,'2019-11-30 04:01:28','2026-02-06 11:10:54'),(1246,2,137,1,1,1,1,'2019-11-30 04:02:40','2026-02-06 11:10:54'),(1248,2,141,1,1,1,1,'2019-11-30 04:04:04','2026-02-06 11:10:54'),(1250,2,187,1,0,0,0,'2019-11-30 04:11:19','2026-02-06 11:10:54'),(1252,2,207,1,0,0,0,'2019-11-30 04:21:21','2026-02-06 11:10:54'),(1253,2,208,1,0,1,0,'2019-11-30 04:22:00','2026-02-06 11:10:54'),(1255,2,210,1,0,1,0,'2019-11-30 04:22:58','2026-02-06 11:10:54'),(1256,2,211,1,0,1,0,'2019-11-30 04:24:03','2026-02-06 11:10:54'),(1257,2,21,1,0,0,0,'2019-11-30 04:32:59','2026-02-06 11:10:54'),(1259,2,188,1,0,0,0,'2019-11-30 04:34:35','2026-02-06 11:10:54'),(1260,2,27,1,0,0,0,'2019-11-30 04:36:13','2026-02-06 11:10:54'),(1262,2,43,1,1,1,1,'2019-11-30 04:39:42','2026-02-06 11:10:54'),(1263,2,44,1,0,0,0,'2019-11-30 04:41:43','2026-02-06 11:10:54'),(1264,2,46,1,0,0,0,'2019-11-30 04:41:43','2026-02-06 11:10:54'),(1265,2,217,1,0,0,0,'2019-11-30 04:41:43','2026-02-06 11:10:54'),(1266,2,146,1,0,0,0,'2019-11-30 04:46:35','2026-02-06 11:10:54'),(1267,2,147,1,0,0,0,'2019-11-30 04:47:37','2026-02-06 11:10:54'),(1269,2,164,1,0,0,0,'2019-11-30 04:51:04','2026-02-06 11:10:54'),(1271,2,109,1,1,0,0,'2019-11-30 05:03:37','2026-02-06 11:10:54'),(1272,2,93,1,1,1,1,'2019-11-30 05:07:25','2026-02-06 11:10:54'),(1273,2,94,1,1,0,0,'2019-11-30 05:07:42','2026-02-06 11:10:54'),(1275,2,102,1,1,1,1,'2019-11-30 05:11:22','2026-02-06 11:10:54'),(1277,2,196,1,0,0,0,'2019-11-30 05:15:01','2026-02-06 11:10:54'),(1278,2,195,1,0,0,0,'2019-11-30 05:19:08','2026-02-06 11:10:54'),(1279,2,185,1,1,1,1,'2019-11-30 05:21:44','2026-02-06 11:10:54'),(1280,2,186,1,1,1,1,'2019-11-30 05:22:43','2026-02-06 11:10:54'),(1281,2,222,1,0,1,0,'2019-11-30 05:24:30','2026-02-06 11:10:54'),(1283,3,5,1,1,0,1,'2019-11-30 06:43:04','2026-02-06 11:10:54'),(1284,3,6,1,0,0,0,'2019-11-30 06:43:29','2026-02-06 11:10:54'),(1285,3,7,1,1,1,1,'2019-11-30 06:44:39','2026-02-06 11:10:54'),(1286,3,68,1,0,0,0,'2019-11-30 06:46:58','2026-02-06 11:10:54'),(1287,3,71,1,0,0,0,'2019-11-30 07:05:41','2026-02-06 11:10:54'),(1288,3,73,1,0,0,0,'2019-11-30 07:05:59','2026-02-06 11:10:54'),(1289,3,74,1,0,0,0,'2019-11-30 07:06:08','2026-02-06 11:10:54'),(1290,3,11,1,0,0,0,'2019-11-30 07:16:37','2026-02-06 11:10:54'),(1291,3,12,1,1,1,1,'2019-11-30 07:19:29','2026-02-06 11:10:54'),(1292,3,13,1,1,1,1,'2019-11-30 07:22:27','2026-02-06 11:10:54'),(1294,3,14,1,0,0,0,'2019-11-30 07:22:55','2026-02-06 11:10:54'),(1295,3,31,1,1,1,1,'2019-12-02 06:30:37','2026-02-06 11:10:54'),(1297,3,37,1,1,1,1,'2019-11-30 07:28:09','2026-02-06 11:10:54'),(1298,3,38,1,1,1,1,'2019-11-30 07:29:02','2026-02-06 11:10:54'),(1299,3,39,1,1,1,1,'2019-11-30 07:30:07','2026-02-06 11:10:54'),(1300,3,40,1,1,1,1,'2019-11-30 07:32:43','2026-02-06 11:10:54'),(1301,3,44,1,0,0,0,'2019-11-30 07:44:09','2026-02-06 11:10:54'),(1302,3,46,1,0,0,0,'2019-11-30 07:44:09','2026-02-06 11:10:54'),(1303,3,217,1,0,0,0,'2019-11-30 07:44:09','2026-02-06 11:10:54'),(1304,3,155,1,0,0,0,'2019-11-30 07:44:32','2026-02-06 11:10:54'),(1305,3,156,1,0,0,0,'2019-11-30 07:45:18','2026-02-06 11:10:54'),(1306,3,157,1,0,0,0,'2019-11-30 07:45:42','2026-02-06 11:10:54'),(1307,3,158,1,0,0,0,'2019-11-30 07:46:07','2026-02-06 11:10:54'),(1308,3,159,1,0,0,0,'2019-11-30 07:46:21','2026-02-06 11:10:54'),(1309,3,160,1,0,0,0,'2019-11-30 07:46:33','2026-02-06 11:10:54'),(1313,3,161,1,0,0,0,'2019-11-30 07:48:26','2026-02-06 11:10:54'),(1314,3,162,1,0,0,0,'2019-11-30 07:48:48','2026-02-06 11:10:54'),(1315,3,163,1,0,0,0,'2019-11-30 07:48:48','2026-02-06 11:10:54'),(1316,3,164,1,0,0,0,'2019-11-30 07:49:47','2026-02-06 11:10:54'),(1317,3,165,1,0,0,0,'2019-11-30 07:49:47','2026-02-06 11:10:54'),(1318,3,174,1,0,0,0,'2019-11-30 07:49:47','2026-02-06 11:10:54'),(1319,3,175,1,0,0,0,'2019-11-30 07:49:59','2026-02-06 11:10:54'),(1320,3,181,1,0,0,0,'2019-11-30 07:50:08','2026-02-06 11:10:54'),(1321,3,86,1,1,1,1,'2019-11-30 07:54:08','2026-02-06 11:10:54'),(1322,4,28,1,1,1,1,'2019-12-01 00:52:39','2026-02-06 11:10:54'),(1324,4,29,1,0,0,0,'2019-12-01 00:53:46','2026-02-06 11:10:54'),(1325,4,30,1,0,0,0,'2019-12-01 00:53:59','2026-02-06 11:10:54'),(1326,4,123,1,0,0,0,'2019-12-01 00:54:26','2026-02-06 11:10:54'),(1327,4,228,1,0,0,0,'2019-12-01 00:54:39','2026-02-06 11:10:54'),(1328,4,43,1,1,1,1,'2019-12-01 00:58:05','2026-02-06 11:10:54'),(1332,4,44,1,0,0,0,'2019-12-01 00:59:16','2026-02-06 11:10:54'),(1333,4,46,1,0,0,0,'2019-12-01 00:59:16','2026-02-06 11:10:54'),(1334,4,217,1,0,0,0,'2019-12-01 00:59:16','2026-02-06 11:10:54'),(1335,4,178,1,0,0,0,'2019-12-01 00:59:59','2026-02-06 11:10:54'),(1336,4,179,1,0,0,0,'2019-12-01 01:00:11','2026-02-06 11:10:54'),(1337,4,180,1,0,0,0,'2019-12-01 01:00:29','2026-02-06 11:10:54'),(1338,4,221,1,0,0,0,'2019-12-01 01:00:46','2026-02-06 11:10:54'),(1339,4,86,1,0,0,0,'2019-12-01 01:01:02','2026-02-06 11:10:54'),(1341,4,106,1,0,0,0,'2019-12-01 01:05:21','2026-02-06 11:10:54'),(1342,1,107,1,0,0,0,'2019-12-01 01:06:44','2026-02-06 11:10:54'),(1343,4,117,1,0,0,0,'2019-12-01 01:10:20','2026-02-06 11:10:54'),(1344,4,194,1,0,0,0,'2019-12-01 01:11:35','2026-02-06 11:10:54'),(1348,4,230,1,0,0,0,'2019-12-01 01:19:15','2026-02-06 11:10:54'),(1350,6,1,1,0,0,0,'2019-12-01 01:35:32','2026-02-06 11:10:54'),(1351,6,21,1,0,0,0,'2019-12-01 01:36:29','2026-02-06 11:10:54'),(1352,6,23,1,0,0,0,'2019-12-01 01:36:45','2026-02-06 11:10:54'),(1353,6,24,1,0,0,0,'2019-12-01 01:37:05','2026-02-06 11:10:54'),(1354,6,25,1,0,0,0,'2019-12-01 01:37:34','2026-02-06 11:10:54'),(1355,6,77,1,0,0,0,'2019-12-01 01:38:08','2026-02-06 11:10:54'),(1356,6,188,1,0,0,0,'2019-12-01 01:38:45','2026-02-06 11:10:54'),(1357,6,43,1,1,1,1,'2019-12-01 01:40:44','2026-02-06 11:10:54'),(1358,6,78,1,1,1,1,'2019-12-01 01:43:04','2026-02-06 11:10:54'),(1360,6,79,1,1,0,1,'2019-12-01 01:44:39','2026-02-06 11:10:54'),(1361,6,80,1,1,1,1,'2019-12-01 01:45:08','2026-02-06 11:10:54'),(1362,6,81,1,1,1,1,'2019-12-01 01:47:50','2026-02-06 11:10:54'),(1363,6,85,1,1,1,1,'2019-12-01 01:50:43','2026-02-06 11:10:54'),(1364,6,86,1,0,0,0,'2019-12-01 01:51:10','2026-02-06 11:10:54'),(1365,6,106,1,0,0,0,'2019-12-01 01:52:55','2026-02-06 11:10:54'),(1366,6,117,1,0,0,0,'2019-12-01 01:53:08','2026-02-06 11:10:54'),(1394,1,106,1,0,0,0,'2019-12-02 05:20:33','2026-02-06 11:10:54'),(1395,1,113,1,0,0,0,'2019-12-02 05:20:59','2026-02-06 11:10:54'),(1396,1,114,1,0,0,0,'2019-12-02 05:21:34','2026-02-06 11:10:54'),(1397,1,115,1,0,0,0,'2019-12-02 05:21:34','2026-02-06 11:10:54'),(1398,1,116,1,0,0,0,'2019-12-02 05:21:54','2026-02-06 11:10:54'),(1399,1,117,1,0,0,0,'2019-12-02 05:22:04','2026-02-06 11:10:54'),(1400,1,118,1,0,0,0,'2019-12-02 05:22:20','2026-02-06 11:10:54'),(1402,1,191,1,0,0,0,'2019-12-02 05:23:34','2026-02-06 11:10:54'),(1403,1,192,1,0,0,0,'2019-12-02 05:23:47','2026-02-06 11:10:54'),(1404,1,193,1,0,0,0,'2019-12-02 05:23:58','2026-02-06 11:10:54'),(1405,1,194,1,0,0,0,'2019-12-02 05:24:11','2026-02-06 11:10:54'),(1406,1,195,1,0,0,0,'2019-12-02 05:24:20','2026-02-06 11:10:54'),(1408,1,227,1,0,0,0,'2019-12-02 05:25:47','2026-02-06 11:10:54'),(1410,1,226,1,0,0,0,'2019-12-02 05:31:41','2026-02-06 11:10:54'),(1411,1,229,1,0,0,0,'2019-12-02 05:32:57','2026-02-06 11:10:54'),(1412,1,230,1,0,0,0,'2019-12-02 05:32:57','2026-02-06 11:10:54'),(1413,1,190,1,0,0,0,'2019-12-02 05:43:41','2026-02-06 11:10:54'),(1414,2,174,1,0,0,0,'2019-12-02 05:54:37','2026-02-06 11:10:54'),(1415,2,175,1,0,0,0,'2019-12-02 05:54:37','2026-02-06 11:10:54'),(1418,2,232,1,0,1,1,'2019-12-02 06:11:27','2026-02-06 11:10:54'),(1419,2,231,1,0,0,0,'2019-12-02 06:12:28','2026-02-06 11:10:54'),(1420,1,231,1,1,1,1,'2021-01-23 07:09:32','2026-02-06 11:10:54'),(1421,1,232,1,0,1,1,'2019-12-02 06:19:32','2026-02-06 11:10:54'),(1422,3,32,1,1,1,1,'2019-12-02 06:30:37','2026-02-06 11:10:54'),(1423,3,33,1,1,1,1,'2019-12-02 06:30:37','2026-02-06 11:10:54'),(1424,3,34,1,1,1,1,'2019-12-02 06:30:37','2026-02-06 11:10:54'),(1425,3,182,1,0,0,0,'2019-12-02 06:30:37','2026-02-06 11:10:54'),(1426,3,183,1,0,0,0,'2019-12-02 06:30:37','2026-02-06 11:10:54'),(1427,3,189,1,0,1,1,'2019-12-02 06:30:37','2026-02-06 11:10:54'),(1428,3,229,1,0,0,0,'2019-12-02 06:30:37','2026-02-06 11:10:54'),(1429,3,230,1,0,0,0,'2019-12-02 06:30:37','2026-02-06 11:10:54'),(1430,4,213,1,0,0,0,'2019-12-02 06:32:14','2026-02-06 11:10:54'),(1432,4,224,1,0,0,0,'2019-12-02 06:32:14','2026-02-06 11:10:54'),(1433,4,195,1,0,0,0,'2019-12-03 04:57:53','2026-02-06 11:10:54'),(1434,4,229,1,0,0,0,'2019-12-03 04:58:19','2026-02-06 11:10:54'),(1436,6,213,1,0,0,0,'2019-12-03 05:10:11','2026-02-06 11:10:54'),(1437,6,191,1,0,0,0,'2019-12-03 05:10:11','2026-02-06 11:10:54'),(1438,6,193,1,0,0,0,'2019-12-03 05:10:11','2026-02-06 11:10:54'),(1439,6,230,1,0,0,0,'2019-12-03 05:10:11','2026-02-06 11:10:54'),(1440,2,106,1,0,0,0,'2020-01-25 04:21:36','2026-02-06 11:10:54'),(1441,2,107,1,0,0,0,'2020-02-12 02:10:13','2026-02-06 11:10:54'),(1442,2,134,1,1,1,1,'2020-02-12 02:12:36','2026-02-06 11:10:54'),(1443,1,233,1,0,0,0,'2020-02-12 02:21:57','2026-02-06 11:10:54'),(1444,2,86,1,0,0,0,'2020-02-12 02:22:33','2026-02-06 11:10:54'),(1445,3,233,1,0,0,0,'2020-02-12 03:51:17','2026-02-06 11:10:54'),(1446,1,234,1,1,1,1,'2020-06-01 21:51:09','2026-02-06 11:10:54'),(1447,1,235,1,1,1,1,'2020-05-29 23:17:01','2026-02-06 11:10:54'),(1448,1,236,1,1,1,0,'2020-05-29 23:17:52','2026-02-06 11:10:54'),(1449,1,237,1,0,1,0,'2020-05-29 23:18:18','2026-02-06 11:10:54'),(1450,1,238,1,1,1,1,'2020-05-29 23:19:52','2026-02-06 11:10:54'),(1451,1,239,1,1,1,1,'2020-05-29 23:22:10','2026-02-06 11:10:54'),(1452,2,236,1,1,1,0,'2020-05-29 23:40:33','2026-02-06 11:10:54'),(1453,2,237,1,0,1,0,'2020-05-29 23:40:33','2026-02-06 11:10:54'),(1454,2,238,1,1,1,1,'2020-05-29 23:40:33','2026-02-06 11:10:54'),(1455,2,239,1,1,1,1,'2020-05-29 23:40:33','2026-02-06 11:10:54'),(1456,2,240,1,0,0,0,'2020-05-28 20:51:18','2026-02-06 11:10:54'),(1457,2,241,1,0,0,0,'2020-05-28 20:51:18','2026-02-06 11:10:54'),(1458,1,240,1,0,0,0,'2020-06-07 18:30:42','2026-02-06 11:10:54'),(1459,1,241,1,0,0,0,'2020-06-07 18:30:42','2026-02-06 11:10:54'),(1460,1,242,1,0,0,0,'2020-06-07 18:30:42','2026-02-06 11:10:54'),(1461,2,242,1,0,0,0,'2020-06-11 22:45:24','2026-02-06 11:10:54'),(1462,3,242,1,0,0,0,'2020-06-14 22:46:54','2026-02-06 11:10:54'),(1463,6,242,1,0,0,0,'2020-06-14 22:48:14','2026-02-06 11:10:54'),(1464,1,243,1,0,0,0,'2020-09-12 06:05:45','2026-02-06 11:10:54'),(1465,1,109,1,1,0,0,'2020-09-21 06:33:50','2026-02-06 11:10:54'),(1466,1,108,1,0,1,1,'2023-11-04 12:52:08','2026-02-06 11:10:54'),(1467,1,244,1,0,0,0,'2020-09-21 06:59:54','2026-02-06 11:10:54'),(1468,1,245,1,0,0,0,'2020-09-21 06:59:54','2026-02-06 11:10:54'),(1469,1,246,1,0,0,0,'2020-09-21 06:59:54','2026-02-06 11:10:54'),(1470,1,247,1,0,0,0,'2021-01-07 06:12:14','2026-02-06 11:10:54'),(1472,2,247,1,0,0,0,'2021-01-21 12:46:40','2026-02-06 11:10:54'),(1473,1,248,1,1,1,1,'2021-05-19 12:52:49','2026-02-06 11:10:54'),(1474,1,249,1,0,0,0,'2021-05-19 12:52:49','2026-02-06 11:10:54'),(1475,2,248,1,1,1,1,'2021-05-28 13:11:52','2026-02-06 11:10:54'),(1476,3,248,1,1,1,1,'2021-05-28 09:36:16','2026-02-06 11:10:54'),(1477,3,249,1,0,0,0,'2021-05-28 09:36:16','2026-02-06 11:10:54'),(1478,6,248,1,0,0,0,'2021-05-28 09:56:14','2026-02-06 11:10:54'),(1479,6,249,1,0,0,0,'2021-05-28 09:56:14','2026-02-06 11:10:54'),(1480,2,249,1,0,0,0,'2021-05-28 13:11:52','2026-02-06 11:10:54'),(1481,1,269,1,0,0,1,'2023-11-04 12:52:08','2026-02-06 11:10:54'),(1482,2,269,1,0,0,1,'2023-11-04 12:52:28','2026-02-06 11:10:54'),(1483,3,269,1,0,0,1,'2023-11-04 12:53:22','2026-02-06 11:10:54'),(1484,4,269,1,0,0,1,'2023-11-04 12:53:34','2026-02-06 11:10:54'),(1485,6,269,1,0,0,1,'2023-11-04 12:53:52','2026-02-06 11:10:54');
INSERT INTO `sidebar_menus` (`id`, `product_name`, `permission_group_id`, `icon`, `menu`, `activate_menu`, `lang_key`, `system_level`, `level`, `sidebar_display`, `access_permissions`, `is_active`, `created_at`, `updated_at`) VALUES (1,'',17,'fa fa-ioxhost ftlayer','Front Office','front_office','front_office',10,1,1,'(\'admission_enquiry\', \'can_view\') || (\'visitor_book\', \'can_view\') ||       (\'phon_call_log\', \'can_view\') ||  (\'postal_dispatch\', \'can_view\') ||       (\'postal_receive\', \'can_view\') || (\'complaint\', \'can_view\') ||(\'setup_font_office\', \'can_view\')',1,'2023-01-10 12:49:51','2026-02-06 10:53:26'),(2,'',1,'fa fa-user-plus ftlayer','Student Information','student_information','student_information',20,2,1,'(\'student\', \'can_view\') || (\'student\', \'can_add\') || (\'student_history\', \'can_view\') || (\'student_categories\', \'can_view\') || (\'student_houses\', \'can_view\') || (\'disable_student\', \'can_view\') || (\'disable_reason\', \'can_view\') || (\'online_admission\', \'can_view\') || (\'multiclass_student\', \'can_view\') || (\'disable_reason\', \'can_view\')',1,'2023-01-10 12:49:51','2026-02-06 10:53:26'),(3,'',2,'fa fa-money ftlayer','Fees Collection','fees_collection','fees_collection',30,3,1,'(\'collect_fees\', \'can_view\') || (\'search_fees_payment\', \'can_view\') || (\'search_due_fees\', \'can_view\') || (\'fees_statement\', \'can_view\') || (\'fees_carry_forward\', \'can_view\') || (\'fees_master\', \'can_view\') || (\'fees_group\', \'can_view\') || (\'fees_type\', \'can_view\') || (\'fees_discount\', \'can_view\') || (\'accountants\', \'can_view\')',1,'2023-01-10 12:49:51','2026-02-06 10:53:26'),(4,'',3,'fa fa-usd ftlayer','Income','income','income',40,10,1,'(\'income\', \'can_view\') || (\'search_income\', \'can_view\') || (\'income_head\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(7,'',4,'fa fa-credit-card ftlayer','Expense','expense','expenses',50,11,1,'(\'expense\', \'can_view\') || (\'search_expense\', \'can_view\') || (\'expense_head\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(10,'',5,'fa fa-calendar-check-o ftlayer','Attendance','attendance','attendance',60,13,1,'(\'student_attendance\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(11,'',6,'fa fa-map-o ftlayer','Examinations','examinations','examinations',70,12,1,'(\'exam_group\', \'can_view\') || (\'exam_result\', \'can_view\') || (\'design_admit_card\', \'can_view\') || (\'print_admit_card\', \'can_view\') || (\'design_marksheet\', \'can_view\') || (\'print_marksheet\', \'can_view\') || (\'marks_grade\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(12,'',23,'fa fa-rss ftlayer','Online Examinations','online_examinations','online_examinations',80,14,1,'(\'online_examination\', \'can_view\') ||  (\'question_bank\', \'can_view\'',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(13,'',29,'fa fa-list-alt ftlayer','Lesson Plan','lesson_plan','lesson_plan',90,16,1,'(\'manage_lesson_plan\', \'can_view\') || (\'manage_syllabus_status\', \'can_view\') || (\'lesson\', \'can_view\') ||  (\'topic\', \'can_view\')||  (\'copy_old_lesson\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(14,'',7,'fa fa-mortar-board ftlayer','Academics','academics','academics',100,15,1,'(\'class_timetable\', \'can_view\') || (\'teachers_timetable\', \'can_view\') || (\'assign_class_teacher\', \'can_view\') || (\'promote_student\', \'can_view\') || (\'subject_group\', \'can_view\') || (\'section\', \'can_view\') || (\'subject\', \'can_view\') || (\'class\', \'can_view\') || (\'section\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(15,'',18,'fa fa-sitemap ftlayer','Human Resource','human_resource','human_resource',110,17,1,'(\'staff\', \'can_view\') || (\'approve_leave_request\', \'can_view\') || (\'apply_leave\', \'can_view\') || (\'leave_types\', \'can_view\') || (\'teachers_rating\', \'can_view\') || (\'department\', \'can_view\') || (\'designation\', \'can_view\') || (\'disable_staff\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(16,'',13,'fa fa-bullhorn ftlayer','Communicate','communicate','communicate',120,18,1,'(\'notice_board\', \'can_view\') || (\'email\', \'can_view\') || (\'sms\', \'can_view\') || (\'email_sms_log\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(17,'',8,'fa fa-download ftlayer','Download Center','download_center','download_center',130,19,1,'(\'upload_content\', \'can_view\') || (\'video_tutorial\', \'can_view\') || (\'content_type\', \'can_view\') || (\'content_share_list\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(18,'',19,'fa fa-flask ftlayer','Assignments','homework','homework',140,20,1,'(\'homework\', \'can_view\') || (\'homework\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-07 04:01:34'),(19,'',9,'fa fa-book ftlayer','Library','library','library',150,21,1,'(\'books\', \'can_view\') || (\'issue_return\', \'can_view\') || (\'add_staff_member\', \'can_view\') || (\'add_student\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(20,'',10,'fa fa-object-group ftlayer','Inventory','inventory','inventory',160,22,1,'(\'issue_item\', \'can_view\') || (\'item_stock\', \'can_view\') || (\'item\', \'can_view\') || (\'item_category\', \'can_view\') || (\'item_category\', \'can_view\') || (\'store\', \'can_view\') || (\'supplier\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(21,'',11,'fa fa-bus ftlayer','Transport','transport','transport',170,23,1,'(\'routes\', \'can_view\') || (\'vehicle\', \'can_view\') || (\'assign_vehicle\', \'can_view\') || (\'transport_fees_master\', \'can_view\') || (\'pickup_point\', \'can_view\') || (\'route_pickup_point\', \'can_view\') || (\'student_transport_fees\', \'can_view\')      ',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(22,'',12,'fa fa-building-o ftlayer','Hostel','hostel','hostel',180,24,1,'(\'hostel_rooms\', \'can_view\') || (\'room_type\', \'can_view\') || (\'hostel\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(23,'',20,'fa fa-newspaper-o ftlayer','Certificate','certificate','certificate',190,25,1,'(\'student_certificate\', \'can_view\') || (\'generate_certificate\', \'can_view\') || (\'student_id_card\', \'can_view\') || (\'generate_id_card\', \'can_view\') || (\'staff_id_card\', \'can_view\') || (\'generate_staff_id_card\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(24,'',16,'fa fa-empire ftlayer','Front CMS','front_cms','front_cms',200,26,1,'(\'event\', \'can_view\') || (\'gallery\', \'can_view\') || (\'notice\', \'can_view\') || (\'media_manager\', \'can_view\') || (\'pages\', \'can_view\') || (\'menus\', \'can_view\') || (\'banner_images\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(25,'',28,'fa fa-universal-access ftlayer','Alumni','alumni','alumni',210,27,1,'(\'manage_alumni\', \'can_view\') || (\'events\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(26,'',14,'fa fa-line-chart ftlayer','Reports','reports','reports',220,28,1,'(\'student_report\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26'),(27,'',15,'fa fa-gears ftlayer','System Settings','system_settings','system_setting',230,29,1,'(\'general_setting\', \'can_view\') || (\'superadmin\', \'can_view\')',1,'2023-01-10 12:49:37','2026-02-06 10:53:26');
INSERT INTO `sidebar_sub_menus` (`id`, `sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`, `level`, `access_permissions`, `permission_group_id`, `activate_controller`, `activate_methods`, `addon_permission`, `is_active`, `created_at`, `updated_at`) VALUES (1,1,'admission_enquiry',NULL,'admission_enquiry','admin/enquiry',1,'(\'admission_enquiry\', \'can_view\')',NULL,'enquiry','index',NULL,1,'2022-07-11 12:04:46','2026-02-06 11:10:54'),(2,1,'visitor_book',NULL,'visitor_book','admin/visitors',2,'(\'visitor_book\', \'can_view\')',NULL,'visitors','index',NULL,1,'2022-07-11 12:04:46','2026-02-06 11:10:54'),(3,1,'phone_call_log',NULL,'phone_call_log','admin/generalcall',3,'(\'phone_call_log\', \'can_view\')',NULL,'generalcall','index,edit',NULL,1,'2022-05-10 11:40:07','2026-02-06 11:10:54'),(4,1,'postal_dispatch',NULL,'postal_dispatch','admin/dispatch',4,'(\'postal_dispatch\', \'can_view\')',NULL,'dispatch','index,editdispatch',NULL,1,'2022-05-10 11:40:09','2026-02-06 11:10:54'),(5,1,'postal_receive',NULL,'postal_receive','admin/receive',5,'(\'postal_receive\', \'can_view\')',NULL,'receive','index,editreceive',NULL,1,'2022-05-10 11:40:09','2026-02-06 11:10:54'),(6,1,'complain',NULL,'complain','admin/complaint',6,'(\'complaint\', \'can_view\')',NULL,'complaint','index,edit',NULL,1,'2022-05-10 11:40:00','2026-02-06 11:10:54'),(7,1,'setup_front_office',NULL,'setup_front_office','admin/visitorspurpose',7,'(\'setup_font_office\', \'can_view\')',NULL,'visitorspurpose','index,edit',NULL,1,'2022-04-18 15:43:15','2026-02-06 11:10:54'),(9,2,'student_admission',NULL,'student_admission','student/create',2,'(\'student\', \'can_add\')',NULL,'student','create,import',NULL,1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(10,2,'online_admission',NULL,'online_admission','admin/onlinestudent',3,'(\'online_admission\', \'can_view\')',27,'onlinestudent','index,edit',NULL,1,'2022-05-10 11:40:30','2026-02-06 11:10:54'),(11,2,'disable_student',NULL,'disabled_students','student/disablestudentslist',4,'(\'disable_student\', \'can_view\')',NULL,'student','disablestudentslist','',1,'2022-07-23 06:49:00','2026-02-06 11:10:54'),(12,3,'collect_fees',NULL,'collect_fees','studentfee',1,'(\'collect_fees\', \'can_view\')',NULL,'studentfee','index,addfee',NULL,1,'2022-07-23 06:53:34','2026-02-06 11:10:54'),(13,3,'search_fees_payment',NULL,'search_fees_payment','studentfee/searchpayment',3,'(\'search_fees_payment\', \'can_view\')',NULL,'studentfee','searchpayment',NULL,1,'2022-08-08 06:03:40','2026-02-06 11:10:54'),(14,3,'search_due_fees',NULL,'search_due_fees','studentfee/feesearch',4,'(\'search_due_fees\', \'can_view\')',NULL,'studentfee','feesearch',NULL,1,'2022-08-08 06:03:38','2026-02-06 11:10:54'),(15,3,'fees_master',NULL,'fees_master','admin/feemaster',5,'(\'fees_master\', \'can_view\')',NULL,'feemaster','index,assign,edit',NULL,1,'2022-09-24 07:35:55','2026-02-06 11:10:54'),(16,3,'fees_group',NULL,'fees_group','admin/feegroup',6,'(\'fees_group\', \'can_view\')',NULL,'feegroup','index,edit',NULL,1,'2022-08-08 06:03:32','2026-02-06 11:10:54'),(17,4,'add_income',NULL,'add_income','admin/income',1,'(\'income\', \'can_view\')',NULL,'income','index,edit',NULL,1,'2022-07-23 07:03:40','2026-02-06 11:10:54'),(18,4,'search_income',NULL,'search_income','admin/income/incomesearch',2,'(\'search_income\', \'can_view\')',NULL,'income','incomesearch',NULL,1,'2022-07-23 07:10:13','2026-02-06 11:10:54'),(19,4,'income_head',NULL,'income_head','admin/incomehead',3,'(\'income_head\', \'can_view\')',NULL,'incomehead','index,edit',NULL,1,'2022-07-23 07:11:11','2026-02-06 11:10:54'),(20,2,'student_details',NULL,'student_details','student/search',1,'(\'student\', \'can_view\')',NULL,'student','search,view,edit',NULL,1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(21,2,'multi_class_student',NULL,'multi_class_student','student/multiclass',5,'(\'multi_class_student\', \'can_view\')',26,'student','multiclass',NULL,1,'2022-07-23 06:48:37','2026-02-06 11:10:54'),(22,2,'bulk_delete',NULL,'bulk_delete','student/bulkdelete',6,'(\'student\', \'can_delete\')',NULL,'student','bulkdelete',NULL,1,'2022-07-23 06:48:11','2026-02-06 11:10:54'),(23,2,'student_categories',NULL,'student_categories','category',7,'(\'student_categories\', \'can_view\')',NULL,'category','index,edit',NULL,1,'2022-07-23 06:47:24','2026-02-06 11:10:54'),(24,2,'student_house',NULL,'student_house','admin/schoolhouse',8,'(\'student_houses\', \'can_view\')',NULL,'schoolhouse','index,edit',NULL,1,'2022-07-23 06:49:59','2026-02-06 11:10:54'),(25,2,'disable_reason',NULL,'disable_reason','admin/disable_reason',9,'(\'disable_reason\', \'can_view\')',NULL,'disable_reason','index,edit',NULL,1,'2022-07-23 06:50:41','2026-02-06 11:10:54'),(29,7,'add_expense',NULL,'add_expense','admin/expense',1,'(\'expense\', \'can_view\')',NULL,'expense','index,edit','',1,'2022-07-23 07:12:25','2026-02-06 11:10:54'),(32,3,'fees_type',NULL,'fees_type','admin/feetype',7,'(\'fees_type\', \'can_view\')',NULL,'feetype','index,edit','',1,'2022-08-08 06:03:29','2026-02-06 11:10:54'),(33,10,'attendance_by_date','attendance_by_date','attendance_by_date','admin/stuattendence/attendencereport',3,'(\'attendance_by_date\', \'can_view\')',NULL,'stuattendence','attendencereport','',1,'2022-10-20 05:50:25','2026-02-06 11:10:54'),(34,10,'student_attendance','student_attendance','student_attendance','admin/stuattendence',1,'(\'student_attendance\', \'can_view\')',NULL,'stuattendence','index','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(35,10,'approve_leave','approve_leave','approve_leave','admin/approve_leave',2,'(\'approve_leave\', \'can_view\')',NULL,'approve_leave','index','',1,'2022-10-14 16:16:44','2026-02-06 11:10:54'),(36,11,'exam_group',NULL,'exam_group','admin/examgroup',1,'(\'exam_group\', \'can_view\')',NULL,'examgroup','index,addexam,edit','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(37,11,'exam_schedule',NULL,'exam_schedule','admin/exam_schedule',2,'(\'student_attendance\', \'can_view\')',NULL,'exam_schedule','index','',1,'2022-05-16 07:01:34','2026-02-06 11:10:54'),(38,11,'exam_result',NULL,'exam_result','admin/examresult',3,'(\'exam_result\', \'can_view\')',NULL,'examresult','index','',1,'2022-05-16 07:01:34','2026-02-06 11:10:54'),(39,11,'design_admit_card',NULL,'design_admit_card','admin/admitcard',4,'(\'design_admit_card\', \'can_view\')',NULL,'admitcard','index,edit','',1,'2022-07-23 07:28:02','2026-02-06 11:10:54'),(40,11,'print_admit_card',NULL,'print_admit_card','admin/examresult/admitcard',5,'(\'print_admit_card\', \'can_view\')',NULL,'examresult','admitcard','',1,'2022-05-16 07:01:34','2026-02-06 11:10:54'),(41,11,'design_marksheet',NULL,'design_marksheet','admin/marksheet',6,'(\'design_marksheet\', \'can_view\')',NULL,'marksheet','index,edit','',1,'2022-07-23 07:35:35','2026-02-06 11:10:54'),(42,11,'print_marksheet',NULL,'print_marksheet','admin/examresult/marksheet',7,'(\'print_marksheet\', \'can_view\')',NULL,'examresult','marksheet','',1,'2022-05-16 07:01:38','2026-02-06 11:10:54'),(43,11,'marks_grade',NULL,'marks_grade','admin/grade',8,'(\'marks_grade\', \'can_view\')',NULL,'grade','index,edit','',1,'2022-07-23 07:37:15','2026-02-06 11:10:54'),(44,11,'marks_division',NULL,'marks_division','admin/marksdivision',9,'(\'marks_division\', \'can_view\')',NULL,'marksdivision','index,edit','',1,'2022-08-25 06:04:26','2026-02-06 11:10:54'),(45,12,'online_exam',NULL,'online_exam','admin/onlineexam',1,'(\'online_examination\', \'can_view\')',NULL,'onlineexam','index,evalution,assign','',1,'2022-08-30 13:03:45','2026-02-06 11:10:54'),(46,12,'question_bank',NULL,'question_bank','admin/question',1,'(\'question_bank\', \'can_view\')',NULL,'question','index,read','',1,'2022-08-30 11:03:13','2026-02-06 11:10:54'),(47,13,'manage_lesson_plan',NULL,'manage_lesson_plan','admin/syllabus',2,'(\'manage_lesson_plan\', \'can_view\')',NULL,'syllabus','index','',1,'2022-09-03 16:59:31','2026-02-06 11:10:54'),(48,13,'manage_syllabus_status',NULL,'manage_syllabus_status','admin/syllabus/status',3,'(\'manage_syllabus_status\', \'can_view\')',NULL,'syllabus','status','',1,'2022-09-03 16:59:35','2026-02-06 11:10:54'),(49,13,'lesson',NULL,'lesson','admin/lessonplan/lesson',4,'(\'lesson\', \'can_view\')',NULL,'lessonplan','lesson,editlesson','',1,'2022-09-15 11:30:55','2026-02-06 11:10:54'),(50,13,'topic',NULL,'topic','admin/lessonplan/topic',5,'(\'topic\', \'can_view\')',NULL,'lessonplan','topic,edittopic','',1,'2022-09-15 11:30:24','2026-02-06 11:10:54'),(51,14,'class_timetable',NULL,'class_timetable','admin/timetable/classreport',1,'(\'class_timetable\', \'can_view\')',NULL,'timetable','classreport,create','',1,'2022-07-23 09:01:22','2026-02-06 11:10:54'),(52,14,'teachers_timetable',NULL,'teachers_timetable','admin/timetable/mytimetable',2,'(\'teachers_time_table\', \'can_view\')',NULL,'timetable','mytimetable','',1,'2022-07-20 12:22:59','2026-02-06 11:10:54'),(53,14,'assign_class_teacher',NULL,'assign_class_teacher','admin/teacher/assign_class_teacher',3,'(\'assign_class_teacher\', \'can_view\')',NULL,'teacher','assign_class_teacher,update_class_teacher','',1,'2022-07-23 09:00:19','2026-02-06 11:10:54'),(54,14,'promote_students',NULL,'promote_students','admin/stdtransfer',4,'(\'promote_student\', \'can_view\')',NULL,'stdtransfer','index','',1,'2022-07-20 12:22:54','2026-02-06 11:10:54'),(55,14,'subject_group',NULL,'subject_group','admin/subjectgroup',5,'(\'subject_group\', \'can_view\')',NULL,'subjectgroup','index,edit','',1,'2022-07-23 08:59:42','2026-02-06 11:10:54'),(56,14,'subjects',NULL,'subjects','admin/subject',6,'(\'subject\', \'can_view\')',NULL,'subject','index,edit','',1,'2022-07-23 08:59:20','2026-02-06 11:10:54'),(57,14,'class',NULL,'class','classes',7,'(\'class\', \'can_view\')',NULL,'classes','index,edit','',1,'2022-07-23 08:58:49','2026-02-06 11:10:54'),(58,14,'sections',NULL,'sections','sections',8,'(\'section\', \'can_view\')',NULL,'sections','index,edit','',0,'2022-07-23 08:58:21','2026-02-07 04:00:44'),(59,15,'staff_directory',NULL,'staff_directory','admin/staff',1,'(\'staff\', \'can_view\')',NULL,'staff','index,edit,profile,create','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(60,15,'staff_attendance',NULL,'staff_attendance','admin/staffattendance',1,'(\'staff_attendance\', \'can_view\')',NULL,'staffattendance','index','',1,'2022-09-07 12:04:15','2026-02-06 11:10:54'),(61,15,'payroll',NULL,'payroll','admin/payroll',1,'(\'staff_payroll\', \'can_view\')',NULL,'payroll','index,edit,create','',1,'2022-08-16 11:58:44','2026-02-06 11:10:54'),(62,15,'approve_leave_request',NULL,'approve_leave_request','admin/leaverequest/leaverequest',1,'(\'approve_leave_request\', \'can_view\')',NULL,'leaverequest','leaverequest','',1,'2022-05-16 09:04:33','2026-02-06 11:10:54'),(74,15,'apply_leave',NULL,'apply_leave','admin/staff/leaverequest',1,'(\'apply_leave\', \'can_view\')',NULL,'staff','leaverequest','',1,'2022-05-16 09:11:41','2026-02-06 11:10:54'),(75,15,'leave_type',NULL,'leave_type','admin/leavetypes',1,'(\'leave_types\', \'can_view\')',NULL,'leavetypes','index,leaveedit,createleavetype','',1,'2022-10-18 11:19:22','2026-02-06 11:10:54'),(76,15,'teachers_rating',NULL,'teachers_rating','admin/staff/rating',1,'(\'teachers_rating\', \'can_view\')',NULL,'staff','rating','',1,'2022-05-16 09:15:31','2026-02-06 11:10:54'),(77,15,'department',NULL,'department','admin/department/department',2,'(\'department\', \'can_view\')',NULL,'department','department,departmentedit','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(78,15,'designation',NULL,'designation','admin/designation/designation',3,'(\'designation\', \'can_view\')',NULL,'designation','designation,designationedit','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(79,15,'disabled_staff',NULL,'disabled_staff','admin/staff/disablestafflist',1,'(\'disable_staff\', \'can_view\')',NULL,'staff','disablestafflist','',1,'2022-09-13 07:46:56','2026-02-06 11:10:54'),(80,16,'notice_board',NULL,'notice_board','admin/notification',1,'(\'notice_board\', \'can_view\')',NULL,'notification','index,edit,add','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(81,16,'send_email',NULL,'send_email','admin/mailsms/compose',2,'(\'email\', \'can_view\')',NULL,'mailsms','compose','',1,'2022-09-02 16:52:46','2026-02-06 11:10:54'),(82,16,'send_sms',NULL,'send_sms','admin/mailsms/compose_sms',3,'(\'sms\', \'can_view\')',NULL,'mailsms','compose_sms','',1,'2022-09-02 16:52:46','2026-02-06 11:10:54'),(83,16,'email_sms_log',NULL,'email_sms_log','admin/mailsms/index',4,'(\'email_sms_log\', \'can_view\')',NULL,'mailsms','index','',1,'2022-09-02 16:52:50','2026-02-06 11:10:54'),(84,16,'schedule_email_sms_log',NULL,'schedule_email_sms_log','admin/mailsms/schedule',5,'(\'schedule_email_sms_log\', \'can_view\')',NULL,'mailsms','schedule,edit_schedule','',1,'2022-09-13 07:07:38','2026-02-06 11:10:54'),(85,16,'login_credentials_send',NULL,'login_credentials_send','student/bulkmail',6,'(\'login_credentials_send\', \'can_view\')',NULL,'student','bulkmail','',1,'2022-09-02 16:52:46','2026-02-06 11:10:54'),(86,16,'email_template',NULL,'email_template','admin/mailsms/email_template',7,'(\'email_template\', \'can_view\')',NULL,'mailsms','email_template','',1,'2022-09-02 16:52:46','2026-02-06 11:10:54'),(87,16,'sms_template',NULL,'sms_template','admin/mailsms/sms_template',8,'(\'sms_template\', \'can_view\')',NULL,'mailsms','sms_template','',1,'2022-09-02 16:52:46','2026-02-06 11:10:54'),(88,17,'content_type',NULL,'content_type','admin/contenttype',3,'(\'content_type\', \'can_view\')',NULL,'contenttype','index,edit','',1,'2022-07-23 09:24:45','2026-02-06 11:10:54'),(89,17,'content_share_list',NULL,'content_share_list','admin/content/list',2,'(\'content_share_list\', \'can_view\')',NULL,'content','list','',1,'2022-07-22 10:07:17','2026-02-06 11:10:54'),(90,17,'upload_content',NULL,'upload_content','admin/content/upload',1,'(\'upload_content\', \'can_view\')',NULL,'content','upload','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(91,17,'video_tutorial',NULL,'video_tutorial','admin/video_tutorial',4,'(\'video_tutorial\', \'can_view\')',NULL,'video_tutorial','index','',1,'2022-07-22 10:07:17','2026-02-06 11:10:54'),(92,18,'add_assignment',NULL,'add_homework','homework',1,'(\'homework\', \'can_view\')',NULL,'homework','index','',1,'2022-06-25 09:50:01','2026-02-07 04:01:34'),(93,18,'daily_assignment',NULL,'daily_assignment','homework/dailyassignment',2,'(\'daily_assignment\', \'can_view\')',NULL,'homework','dailyassignment','',1,'2022-07-23 09:27:23','2026-02-06 11:10:54'),(94,19,'book_list',NULL,'book_list','admin/book/getall',1,'(\'books\', \'can_view\')',NULL,'book','getall,index,edit,import,issue_returnreport','',1,'2022-09-07 11:45:50','2026-02-06 11:10:54'),(95,19,'issue_return',NULL,'issue_return','admin/member',1,'(\'issue_return\', \'can_view\')',NULL,'member','index,issue','',1,'2022-07-23 09:32:48','2026-02-06 11:10:54'),(96,19,'add_student',NULL,'add_student','admin/member/student',1,'(\'add_student\', \'can_view\')',NULL,'member','student','',1,'2022-05-16 11:22:54','2026-02-06 11:10:54'),(97,19,'add_staff_member',NULL,'add_staff_member','admin/member/teacher',1,'(\'add_staff_member\', \'can_view\')',NULL,'member','teacher','',1,'2022-05-16 11:31:43','2026-02-06 11:10:54'),(98,7,'search_expense',NULL,'search_expense','admin/expense/expensesearch',1,'(\'search_expense\', \'can_view\')',NULL,'expense','expensesearch','',1,'2022-05-16 11:36:09','2026-02-06 11:10:54'),(99,7,'expense_head',NULL,'expense_head','admin/expensehead',1,'(\'expense_head\', \'can_view\')',NULL,'expensehead','index,edit','',1,'2022-07-23 07:16:17','2026-02-06 11:10:54'),(100,20,'issue_item',NULL,'issue_item','admin/issueitem',1,'(\'issue_item\', \'can_view\')',NULL,'issueitem','index,create','',1,'2022-07-23 09:35:03','2026-02-06 11:10:54'),(101,20,'add_item_stock',NULL,'add_item_stock','admin/itemstock',1,'(\'item_stock\', \'can_view\')',NULL,'itemstock','index,edit','',1,'2022-07-23 09:36:17','2026-02-06 11:10:54'),(102,20,'add_item',NULL,'add_item','admin/item',1,'(\'item\', \'can_view\')',NULL,'item','index,edit','',1,'2022-07-23 09:36:56','2026-02-06 11:10:54'),(103,20,'item_category',NULL,'item_category','admin/itemcategory',1,'(\'item_category\', \'can_view\')',NULL,'itemcategory','index,edit','',1,'2022-07-23 09:37:12','2026-02-06 11:10:54'),(104,20,'item_store',NULL,'item_store','admin/itemstore',1,'(\'store\', \'can_view\')',NULL,'itemstore','index,edit,create','',1,'2022-09-16 11:49:03','2026-02-06 11:10:54'),(105,20,'item_supplier',NULL,'item_supplier','admin/itemsupplier',1,'(\'supplier\', \'can_view\')',NULL,'itemsupplier','index,edit,create','',1,'2022-07-23 09:38:22','2026-02-06 11:10:54'),(106,21,'fees_master',NULL,'fees_master','admin/transport/feemaster',1,'(\'transport_fees_master\', \'can_view\')',NULL,'transport','feemaster','',1,'2023-03-31 05:33:14','2026-02-06 11:10:54'),(107,21,'pickup_point',NULL,'pickup_point','admin/pickuppoint',1,'(\'pickup_point\', \'can_view\')',NULL,'pickuppoint','index','',1,'2023-03-31 05:24:24','2026-02-06 11:10:54'),(108,21,'routes',NULL,'routes','admin/route',1,'(\'routes\', \'can_view\')',NULL,'route','index,edit','',1,'2022-09-17 06:21:23','2026-02-06 11:10:54'),(109,21,'vehicles',NULL,'vehicles','admin/vehicle',1,'(\'vehicle\', \'can_view\')',NULL,'vehicle','index','',1,'2022-05-16 12:29:35','2026-02-06 11:10:54'),(110,21,'assign_vehicle',NULL,'assign_vehicle','admin/vehroute',1,'(\'assign_vehicle\',\'can_view\')',NULL,'vehroute','index,edit','',1,'2022-10-19 07:06:08','2026-02-06 11:10:54'),(111,21,'route_pickup_point',NULL,'route_pickup_point','admin/pickuppoint/assign',1,'(\'route_pickup_point\', \'can_view\')',NULL,'pickuppoint','assign','',1,'2023-03-31 05:25:08','2026-02-06 11:10:54'),(112,21,'student_transport_fees',NULL,'student_transport_fees','admin/pickuppoint/student_fees',1,'(\'student_transport_fees\', \'can_view\')',NULL,'pickuppoint','student_fees','',1,'2023-03-31 05:25:43','2026-02-06 11:10:54'),(113,22,'hostel_rooms',NULL,'hostel_rooms','admin/hostelroom',1,'(\'hostel_rooms\', \'can_view\')',NULL,'hostelroom','index,edit','',1,'2022-07-23 10:27:48','2026-02-06 11:10:54'),(114,22,'room_type',NULL,'room_type','admin/roomtype',2,'(\'room_type\', \'can_view\')',NULL,'roomtype','index,edit','',1,'2022-07-23 10:32:14','2026-02-06 11:10:54'),(115,22,'hostel',NULL,'hostel','admin/hostel',3,'(\'hostel\', \'can_view\')',NULL,'hostel','index,edit','',1,'2022-07-23 10:32:39','2026-02-06 11:10:54'),(116,23,'student_certificate',NULL,'student_certificate','admin/certificate',1,'(\'student_certificate\', \'can_view\')',NULL,'certificate','index,edit','',1,'2022-07-23 10:44:30','2026-02-06 11:10:54'),(117,23,'generate_certificate',NULL,'generate_certificate','admin/generatecertificate',1,'(\'generate_certificate\', \'can_view\')',NULL,'generatecertificate','index,search','',1,'2022-07-23 10:46:16','2026-02-06 11:10:54'),(118,23,'student_id_card',NULL,'student_id_card','admin/studentidcard',1,'(\'student_id_card\', \'can_view\')',NULL,'studentidcard','index,edit','',1,'2022-07-23 10:47:01','2026-02-06 11:10:54'),(119,23,'generate_id_card',NULL,'generate_id_card','admin/generateidcard/search',1,'(\'generate_id_card\', \'can_view\')',NULL,'generateidcard','search','',1,'2022-05-18 05:35:13','2026-02-06 11:10:54'),(120,23,'staff_id_card',NULL,'staff_id_card','admin/staffidcard',1,'(\'staff_id_card\', \'can_view\')',NULL,'staffidcard','index,edit','',1,'2022-07-23 10:48:13','2026-02-06 11:10:54'),(121,23,'generate_staff_id_card',NULL,'generate_staff_id_card','admin/generatestaffidcard',1,'(\'generate_staff_id_card\', \'can_view\')',NULL,'generatestaffidcard','index,search','',1,'2022-07-23 10:49:06','2026-02-06 11:10:54'),(122,24,'event',NULL,'event','admin/front/events',1,'(\'event\', \'can_view\')',NULL,'events','index,edit,create','',1,'2022-07-23 10:51:51','2026-02-06 11:10:54'),(123,24,'gallery',NULL,'gallery','admin/front/gallery',1,'(\'gallery\', \'can_view\')',NULL,'gallery','index,edit,create','',1,'2022-07-23 10:52:22','2026-02-06 11:10:54'),(124,24,'news',NULL,'news','admin/front/notice',1,'(\'notice\', \'can_view\')',NULL,'notice','index,edit,create','',1,'2022-07-23 10:54:23','2026-02-06 11:10:54'),(125,24,'media_manager',NULL,'media_manager','admin/front/media',1,'(\'media_manager\', \'can_view\')',NULL,'media','index','',1,'2022-05-18 06:03:32','2026-02-06 11:10:54'),(126,24,'pages',NULL,'pages','admin/front/page',1,'(\'pages\', \'can_view\')',NULL,'page','index,edit,create','',1,'2022-07-23 10:55:28','2026-02-06 11:10:54'),(127,24,'menus',NULL,'menus','admin/front/menus',1,'(\'menus\', \'can_view\')',NULL,'menus','index,additem','',1,'2022-07-23 10:56:31','2026-02-06 11:10:54'),(128,24,'banner_images',NULL,'banner_images','admin/front/banner',1,'(\'banner_images\', \'can_view\')',NULL,'banner','index','',1,'2022-05-18 06:10:53','2026-02-06 11:10:54'),(129,25,'manage_alumini',NULL,'manage_alumini','admin/alumni/alumnilist',1,'(\'manage_alumni\', \'can_view\')',NULL,'alumni','alumnilist','',1,'2022-07-23 10:58:36','2026-02-06 11:10:54'),(130,25,'events',NULL,'events','admin/alumni/events',1,'(\'events\', \'can_view\')',NULL,'alumni','events','',1,'2022-07-23 10:59:09','2026-02-06 11:10:54'),(131,26,'student_information',NULL,'student_information','report/studentinformation',1,'(\'student_report\', \'can_view\') || (\'guardian_report\', \'can_view\') || (\'student_history\', \'can_view\') || (\'student_login_credential_report\', \'can_view\') || (\'class_subject_report\', \'can_view\') || (\'admission_report\', \'can_view\') || (\'sibling_report\', \'can_view\') || (\'homehork_evaluation_report\', \'can_view\') || (\'student_profile\', \'can_view\') || (\'student_gender_ratio_report\', \'can_view\') || (\'student_teacher_ratio_report\', \'can_view\')',NULL,'report','studentinformation,studentreport,online_admission_report,student_teacher_ratio,boys_girls_ratio,student_profile,sibling_report,admission_report,class_subject,classsectionreport,guardianreport,admissionreport,logindetailreport,parentlogindetailreport','',1,'2022-09-26 05:26:53','2026-02-06 11:10:54'),(132,26,'finance',NULL,'finance','financereports/finance',2,'(\'fees_statement\', \'can_view\') || (\'balance_fees_report\', \'can_view\') || (\'fees_collection_report\', \'can_view\') || (\'online_fees_collection_report\', \'can_view\') || (\'income_report\', \'can_view\') || (\'expense_report\', \'can_view\') || (\'payroll_report\', \'can_view\') || (\'income_group_report\', \'can_view\') || (\'expense_group_report\', \'can_view\') || (\'online_admission\', \'can_view\')',NULL,'financereports','finance,reportduefees,reportdailycollection,reportbyname,studentacademicreport,collection_report,onlinefees_report,duefeesremark,income,expense,payroll,incomegroup,expensegroup,onlineadmission','',1,'2022-09-24 12:20:32','2026-02-06 11:10:54'),(133,26,'attendance',NULL,'attendance','attendencereports/attendance',3,'(\'attendance_report\', \'can_view\') || (\'student_attendance_type_report\', \'can_view\') || (\'daily_attendance_report\', \'can_view\') || (\'staff_attendance_report\', \'can_view\')',NULL,'attendencereports','attendance,classattendencereport,attendancereport,daily_attendance_report,staffattendancereport,biometric_attlog,reportbymonthstudent,reportbymonth','',1,'2022-09-26 11:36:08','2026-02-06 11:10:54'),(134,26,'examinations',NULL,'examinations','admin/examresult/examinations',4,'(\'rank_report\', \'can_view\')',NULL,'examresult','rankreport,examinations','',1,'2022-09-20 08:34:13','2026-02-06 11:10:54'),(135,26,'lesson_plan',NULL,'lesson_plan','report/lesson_plan',6,'(\'syllabus_status_report\', \'can_view\') || (\'teacher_syllabus_status_report\', \'can_view\')',NULL,'report','lesson_plan,teachersyllabusstatus','',1,'2022-07-25 11:39:17','2026-02-06 11:10:54'),(136,26,'human_resource',NULL,'human_resource','report/human_resource',7,'(\'staff_report\', \'can_view\') || (\'payroll_report\', \'can_view\')',NULL,'report','human_resource,staff_report,payrollreport','',1,'2022-07-25 11:38:20','2026-02-06 11:10:54'),(137,26,'library',NULL,'library','report/library',9,'(\'book_issue_report\', \'can_view\') || (\'book_due_report\', \'can_view\') || (\'book_issue_return_report\', \'can_view\') || (\'book_inventory_report\', \'can_view\')',NULL,'report','library,studentbookissuereport,bookduereport,bookinventory','',1,'2022-09-07 11:53:15','2026-02-06 11:10:54'),(138,26,'inventory',NULL,'inventory','report/inventory',10,'(\'stock_report\', \'can_view\') || (\'add_item_report\', \'can_view\') || (\'issue_item_report\', \'can_view\')',NULL,'report','inventory,inventorystock,additem,issueinventory','',1,'2022-07-25 11:30:57','2026-02-06 11:10:54'),(139,26,'hostel',NULL,'hostel','admin/hostelroom/studenthosteldetails',12,'(\'hostel_report\', \'can_view\')',NULL,'hostelroom','studenthosteldetails','',1,'2022-07-20 12:30:07','2026-02-06 11:10:54'),(140,26,'alumni',NULL,'alumni','report/alumnireport',13,'(\'alumni_report\', \'can_view\')',NULL,'report','alumnireport','',1,'2022-07-20 12:30:07','2026-02-06 11:10:54'),(141,26,'user_log',NULL,'user_log','admin/userlog',14,'(\'user_log\', \'can_view\')',NULL,'userlog','index','',1,'2022-07-20 12:30:07','2026-02-06 11:10:54'),(142,26,'audit_trail_report',NULL,'audit_trail_report','admin/audit',15,'(\'audit_trail_report\', \'can_view\')',NULL,'audit','index','',1,'2022-07-20 12:30:07','2026-02-06 11:10:54'),(143,26,'online_examinations',NULL,'online_examinations','admin/onlineexam/report',5,'(\'online_exam_wise_report\', \'can_view\') || (\'online_exams_report\', \'can_view\') || (\'online_exams_attempt_report\', \'can_view\') || (\'online_exams_rank_report\', \'can_view\')',NULL,'onlineexam','report,onlineexams','',1,'2022-07-25 11:48:23','2026-02-06 11:10:54'),(144,26,'assignment_report',NULL,'homework','homework/homeworkordailyassignmentreport',8,'(\'homework\', \'can_view\') || (\'daily_assignment\', \'can_view\')',NULL,'homework','homeworkordailyassignmentreport,homeworkreport,evaluation_report,dailyassignmentreport','',1,'2022-09-21 09:28:47','2026-02-07 04:01:34'),(145,26,'transport',NULL,'transport','admin/route/studenttransportdetails',11,'(\'transport_report\', \'can_view\')',NULL,'route','studenttransportdetails','',1,'2022-07-20 12:30:07','2026-02-06 11:10:54'),(146,27,'general_setting',NULL,'general_setting','schsettings',1,'(\'general_setting\', \'can_view\')',NULL,'schsettings','index,logo,miscellaneous,backendtheme,mobileapp,studentguardianpanel,fees,idautogeneration,attendancetype,maintenance,whatsappsettings','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(147,27,'session_setting',NULL,'session_setting','sessions',2,'(\'session_setting\', \'can_view\')',NULL,'sessions','index,edit','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(148,27,'notification_setting',NULL,'notification_setting','admin/notification/setting',3,'(\'notification_setting\', \'can_view\')',NULL,'notification','setting','',1,'2022-07-08 08:12:28','2026-02-06 11:10:54'),(149,27,'sms_setting',NULL,'sms_setting','smsconfig',4,'(\'sms_setting\', \'can_view\')',NULL,'smsconfig','index','',1,'2022-07-08 08:12:28','2026-02-06 11:10:54'),(150,27,'email_setting',NULL,'email_setting','emailconfig',5,'(\'email_setting\', \'can_view\')',NULL,'emailconfig','index','',1,'2022-07-08 08:12:28','2026-02-06 11:10:54'),(151,27,'payment_methods',NULL,'payment_methods','admin/paymentsettings',6,'(\'payment_methods\', \'can_view\')',NULL,'paymentsettings','index','',1,'2022-07-08 08:12:28','2026-02-06 11:10:54'),(152,27,'print_headerfooter',NULL,'print_headerfooter','admin/print_headerfooter',7,'(\'print_header_footer\', \'can_view\')',NULL,'print_headerfooter','index','',1,'2022-07-08 08:12:28','2026-02-06 11:10:54'),(153,27,'front_cms_setting',NULL,'front_cms_setting','admin/frontcms',8,'(\'front_cms_setting\', \'can_view\')',NULL,'frontcms','index','',1,'2022-07-08 08:12:28','2026-02-06 11:10:54'),(154,27,'roles_permissions',NULL,'roles_permissions','admin/roles',3,'(\'superadmin\', \'can_view\')',NULL,'roles','index,permission','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(155,27,'backup_restore',NULL,'backup_restore','admin/admin/backup',4,'(\'backup\', \'can_view\')',NULL,'admin','backup','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(156,27,'users',NULL,'users','admin/users',13,'(\'user_status\', \'can_view\')',NULL,'users','index','',1,'2022-07-20 12:34:09','2026-02-06 11:10:54'),(157,27,'languages',NULL,'languages','admin/language',5,'(\'languages\', \'can_view\')',NULL,'language','index,create','',1,'2026-02-06 10:53:26','2026-02-06 10:53:26'),(158,27,'modules',NULL,'modules','admin/module',14,'(\'superadmin\', \'can_view\')',NULL,'module','index','',1,'2022-07-20 12:34:06','2026-02-06 11:10:54'),(159,27,'custom_fields',NULL,'custom_fields','admin/customfield',15,'(\'custom_fields\', \'can_view\')',NULL,'customfield','index,edit','',1,'2022-07-23 12:02:14','2026-02-06 11:10:54'),(160,27,'captcha_setting',NULL,'captcha_setting','admin/captcha',16,'(\'superadmin\', \'can_view\')',NULL,'captcha','index','',1,'2022-07-20 12:34:06','2026-02-06 11:10:54'),(161,27,'system_fields',NULL,'system_fields','admin/systemfield',17,'(\'system_fields\', \'can_view\')',NULL,'systemfield','index','',1,'2022-07-22 06:07:38','2026-02-06 11:10:54'),(162,27,'student_profile_update',NULL,'student_profile_update','student/profilesetting',18,'(\'student_profile_update\', \'can_view\')',NULL,'student','profilesetting','',1,'2022-07-20 12:34:06','2026-02-06 11:10:54'),(163,27,'online_admission',NULL,'online_admission','admin/onlineadmission/admissionsetting',19,'(\'online_admission\', \'can_view\')',NULL,'onlineadmission','admissionsetting','',1,'2022-07-20 12:34:06','2026-02-06 11:10:54'),(164,27,'file_types',NULL,'file_types','admin/admin/filetype',20,'(\'superadmin\', \'can_view\')',NULL,'admin','filetype','',1,'2022-07-20 12:34:30','2026-02-06 11:10:54'),(165,27,'system_update',NULL,'system_update','admin/updater',22,'(\'superadmin\', \'can_view\')',NULL,'updater','index','',1,'2022-10-13 11:49:51','2026-02-06 11:10:54'),(166,27,'sidebar_menu',NULL,'sidebar_menu','admin/sidemenu',21,'(\'sidebar_menu\', \'can_view\')',NULL,'sidemenu','index','',1,'2022-10-13 11:49:51','2026-02-06 11:10:54'),(181,3,'fees_discount',NULL,'fees_discount','admin/feediscount',8,'(\'fees_discount\', \'can_view\')',NULL,'feediscount','index,edit,assign','',1,'2022-08-08 06:03:27','2026-02-06 11:10:54'),(182,3,'fees_carry_forward',NULL,'fees_carry_forward','admin/feesforward',9,'(\'fees_carry_forward\', \'can_view\')',NULL,'feesforward','index','',1,'2022-08-08 06:03:24','2026-02-06 11:10:54'),(183,3,'fees_reminder',NULL,'fees_reminder','admin/feereminder/setting',10,'(\'fees_reminder\', \'can_view\')',NULL,'feereminder','setting','',1,'2022-08-08 06:03:21','2026-02-06 11:10:54'),(184,27,'currency',NULL,'currency','admin/currency',12,'(\'currency\', \'can_view\')',NULL,'currency','index','',1,'2022-07-20 12:34:09','2026-02-06 11:10:54'),(190,3,'offline_bank_payments',NULL,'offline_bank_payments','admin/offlinepayment',2,'(\'offline_bank_payments\', \'can_view\')',NULL,'offlinepayment','index','',1,'2022-08-08 06:05:29','2026-02-06 11:10:54'),(191,13,'Copy Old Lessons',NULL,'copy_old_lesson','admin/lessonplan/copylesson',1,'(\'copy_old_lesson\', \'can_view\')',NULL,'lessonplan','copylesson',NULL,1,'2022-09-09 10:20:37','2026-02-06 11:10:54'),(192,10,'Period Attendance','period_attendance','period_attendance','admin/subjectattendence/index',4,'(\'student_attendance\',\'can_view\')',NULL,'subjectattendence','index',NULL,0,'2022-10-20 05:50:25','2026-02-06 11:10:54'),(193,10,'Period Attendance By Date','period_attendance_by_date','period_attendance_by_date','admin/subjectattendence/reportbydate',5,'(\'attendance_by_date\', \'can_view\')',NULL,'subjectattendence','reportbydate',NULL,0,'2022-10-20 05:50:25','2026-02-06 11:10:54'),(215,36,'annual_calendar',NULL,'annual_calendar','admin/holiday/index',1,'(\'annual_calendar\', \'can_view\')',NULL,'holiday','index','',1,'2024-10-14 12:07:58','2026-02-06 11:10:54'),(216,36,'holiday_type',NULL,'holiday_type','admin/holiday/holidaytype',1,'(\'holiday_type\', \'can_view\')',NULL,'holiday','holidaytype,editholidaytype','',1,'2024-10-14 12:06:02','2026-02-06 11:10:54'),(217,37,'download_cv',NULL,'download_cv','admin/resume/download',2,'(\'download_cv\', \'can_view\')',NULL,'resume','download',NULL,1,'2025-01-09 08:05:11','2026-02-06 11:10:54'),(218,37,'build_cv',NULL,'build_cv','admin/resume/index',1,'(\'build_cv\', \'can_view\')',NULL,'resume','index,resume_setting,student_resume_details',NULL,1,'2024-12-06 11:42:02','2026-02-06 11:10:54'),(219,27,'addons',NULL,'addons','admin/addons',13,'(\'superadmin\', \'can_view\')',NULL,'addons','index','',1,'2024-12-21 11:43:48','2026-02-06 11:10:54'),(220,2,'disability_types',NULL,'disability_types','disabilitytype',25,'(\"disability_types\", \"can_view\")',NULL,'disabilitytype','index,create,edit',NULL,1,'2026-02-06 15:23:54','2026-02-07 04:00:52'),(221,2,'students_with_disabilities',NULL,'students_with_disabilities','disabilitytype/students',10,'(\"students_with_disabilities\", \"can_view\")',NULL,'disabilitytype','students',NULL,1,'2026-02-06 15:23:54','2026-02-06 15:27:01');
INSERT INTO `print_headerfooter` (`id`, `print_type`, `header_image`, `footer_content`) VALUES (1,'student_receipt',NULL,NULL),(2,'staff_payslip',NULL,NULL),(3,'online_admission_receipt',NULL,NULL),(4,'online_exam',NULL,NULL),(5,'general_purpose',NULL,NULL);

SET FOREIGN_KEY_CHECKS = 1;

-- End of TVET College Management System Database
