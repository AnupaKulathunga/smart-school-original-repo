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
-- Table structure for table `academic_assessment`
--

DROP TABLE IF EXISTS `academic_assessment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_assessment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `icass_config_id` int DEFAULT NULL COMMENT 'Link to ICASS component if applicable',
  `name` varchar(100) NOT NULL,
  `assessment_type` enum('Test','Assignment','Project','Practical','Presentation','Quiz','Exam','Other') NOT NULL,
  `description` text,
  `total_marks` decimal(6,2) NOT NULL DEFAULT '100.00',
  `weight_percentage` decimal(5,2) DEFAULT NULL COMMENT 'Override weight if different from ICASS config',
  `due_date` datetime DEFAULT NULL,
  `available_from` datetime DEFAULT NULL,
  `available_until` datetime DEFAULT NULL,
  `duration_minutes` smallint unsigned DEFAULT NULL COMMENT 'For timed assessments',
  `attempts_allowed` tinyint unsigned DEFAULT '1',
  `is_online` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Online assessment via system',
  `requires_moderation` tinyint(1) NOT NULL DEFAULT '0',
  `moderation_status` enum('Not Required','Pending','In Progress','Completed') DEFAULT 'Not Required',
  `instructions` text,
  `resources` text COMMENT 'JSON array of attached resources',
  `status` enum('Draft','Published','Active','Closed','Archived') NOT NULL DEFAULT 'Draft',
  `created_by` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_assessment_class` (`class_id`),
  KEY `idx_assessment_icass` (`icass_config_id`),
  KEY `idx_assessment_type` (`assessment_type`),
  KEY `idx_assessment_status` (`status`),
  CONSTRAINT `fk_assessment_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_assessment_icass` FOREIGN KEY (`icass_config_id`) REFERENCES `academic_icass_config` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_assessment`
--

LOCK TABLES `academic_assessment` WRITE;
/*!40000 ALTER TABLE `academic_assessment` DISABLE KEYS */;
INSERT INTO `academic_assessment` VALUES (1,5,NULL,'IT Practical 1','Practical','Computer basics practical assessment',100.00,30.00,'2025-02-05 00:00:00',NULL,NULL,NULL,1,0,0,'Not Required',NULL,NULL,'Published',NULL,'2026-01-31 11:39:21',NULL),(2,5,NULL,'IT Theory Test 1','Test','Theory assessment on hardware',100.00,20.00,'2025-02-10 00:00:00',NULL,NULL,NULL,1,0,0,'Not Required',NULL,NULL,'Published',NULL,'2026-01-31 11:39:21',NULL),(3,6,NULL,'Programming Project 1','Project','First programming assignment',100.00,40.00,'2025-02-15 00:00:00',NULL,NULL,NULL,1,0,0,'Not Required',NULL,NULL,'Published',NULL,'2026-01-31 11:39:21',NULL),(4,7,NULL,'Mathematics Test 1','Test','Algebra basics test',100.00,25.00,'2025-02-01 00:00:00',NULL,NULL,NULL,1,0,0,'Not Required',NULL,NULL,'Published',NULL,'2026-01-31 11:39:21',NULL),(5,7,NULL,'Mathematics Assignment 1','Assignment','Homework on equations',50.00,15.00,'2025-01-28 00:00:00',NULL,NULL,NULL,1,0,0,'Not Required',NULL,NULL,'Published',NULL,'2026-01-31 11:39:21',NULL);
/*!40000 ALTER TABLE `academic_assessment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_assessment_marks`
--

DROP TABLE IF EXISTS `academic_assessment_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_assessment_marks` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assessment_id` int NOT NULL,
  `enrolment_id` int NOT NULL,
  `marks_obtained` decimal(6,2) DEFAULT NULL,
  `percentage` decimal(5,2) DEFAULT NULL,
  `grade` varchar(5) DEFAULT NULL,
  `is_absent` tinyint(1) DEFAULT '0',
  `is_exempted` tinyint(1) DEFAULT '0',
  `remarks` text,
  `moderator_comment` text,
  `moderated_by` int DEFAULT NULL,
  `moderated_at` datetime DEFAULT NULL,
  `entered_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_assessment_enrolment` (`assessment_id`,`enrolment_id`),
  KEY `idx_assessment` (`assessment_id`),
  KEY `idx_enrolment` (`enrolment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_assessment_marks`
--

LOCK TABLES `academic_assessment_marks` WRITE;
/*!40000 ALTER TABLE `academic_assessment_marks` DISABLE KEYS */;
INSERT INTO `academic_assessment_marks` VALUES (1,1,1,85.00,85.00,'A',0,0,'Excellent practical skills',NULL,NULL,NULL,NULL,'2026-01-31 11:39:38','2026-01-31 11:39:38'),(2,2,1,68.00,68.00,'C',0,0,'Good understanding',NULL,NULL,NULL,NULL,'2026-01-31 11:39:38','2026-01-31 11:39:38'),(3,3,2,78.00,78.00,'B',0,0,'Nice implementation',NULL,NULL,NULL,NULL,'2026-01-31 11:39:38','2026-01-31 11:39:38'),(4,4,3,72.00,72.00,'B',0,0,'Good work!',NULL,NULL,NULL,NULL,'2026-01-31 11:39:38','2026-01-31 11:39:38'),(5,5,3,45.00,90.00,'A',0,0,'Excellent assignment',NULL,NULL,NULL,NULL,'2026-01-31 11:39:38','2026-01-31 11:39:38'),(6,4,5,55.00,55.00,'D',0,0,'Needs improvement',NULL,NULL,NULL,NULL,'2026-01-31 11:39:38','2026-01-31 11:39:38'),(7,1,4,62.00,62.00,'C',0,0,'Good effort',NULL,NULL,NULL,NULL,'2026-01-31 11:39:38','2026-01-31 11:39:38');
/*!40000 ALTER TABLE `academic_assessment_marks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_attendance`
--

DROP TABLE IF EXISTS `academic_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `enrolment_id` int NOT NULL,
  `attendance_date` date NOT NULL,
  `period` tinyint unsigned DEFAULT NULL COMMENT 'Period number if multiple per day',
  `status` enum('Present','Absent','Late','Excused') NOT NULL DEFAULT 'Present',
  `late_minutes` smallint unsigned DEFAULT NULL,
  `excuse_reason` varchar(255) DEFAULT NULL,
  `marked_by` int DEFAULT NULL COMMENT 'Staff ID who marked',
  `marked_at` datetime DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_attendance_record` (`class_id`,`enrolment_id`,`attendance_date`,`period`),
  KEY `idx_attendance_class` (`class_id`),
  KEY `idx_attendance_enrolment` (`enrolment_id`),
  KEY `idx_attendance_date` (`attendance_date`),
  KEY `idx_attendance_status` (`status`),
  CONSTRAINT `fk_attendance_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_attendance_enrolment` FOREIGN KEY (`enrolment_id`) REFERENCES `academic_class_enrolment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_attendance`
--

LOCK TABLES `academic_attendance` WRITE;
/*!40000 ALTER TABLE `academic_attendance` DISABLE KEYS */;
INSERT INTO `academic_attendance` VALUES (1,5,1,'2025-01-20',NULL,'Present',NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:39:21',NULL),(2,5,1,'2025-01-21',NULL,'Present',NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:39:21',NULL),(3,5,1,'2025-01-22',NULL,'Late',NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:39:21',NULL),(4,5,1,'2025-01-23',NULL,'Present',NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:39:21',NULL),(5,5,1,'2025-01-24',NULL,'Absent',NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:39:21',NULL),(6,7,3,'2025-01-20',NULL,'Present',NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:39:21',NULL),(7,7,3,'2025-01-21',NULL,'Present',NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:39:21',NULL),(8,7,3,'2025-01-22',NULL,'Present',NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:39:21',NULL),(9,5,4,'2025-01-20',NULL,'Present',NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:39:21',NULL),(10,5,4,'2025-01-21',NULL,'Excused',NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:39:21',NULL);
/*!40000 ALTER TABLE `academic_attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_class`
--

DROP TABLE IF EXISTS `academic_class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_class` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_code` varchar(50) NOT NULL COMMENT 'Auto-generated: SUBJ-LEVEL-COHORT-YEAR',
  `subject_level_id` int NOT NULL COMMENT 'Which subject at which level',
  `target_qualification_level_id` int DEFAULT NULL COMMENT 'Who class is FOR (e.g., N6 students in N4 class)',
  `cohort_name` varchar(20) NOT NULL COMMENT 'Cohort identifier (A, B, C or custom)',
  `cohort_type` enum('Regular','Elective','Repeat','Bridging') NOT NULL DEFAULT 'Regular',
  `academic_year` int NOT NULL,
  `session_id` int NOT NULL COMMENT 'Links to existing sessions table',
  `primary_lecturer_id` int DEFAULT NULL COMMENT 'Staff ID of primary lecturer',
  `venue` varchar(100) DEFAULT NULL COMMENT 'Default classroom/venue',
  `max_students` smallint unsigned DEFAULT '50',
  `current_enrolment` smallint unsigned DEFAULT '0',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('Scheduled','Active','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled',
  `notes` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_code` (`class_code`),
  KEY `idx_class_subject_level` (`subject_level_id`),
  KEY `idx_class_target_qual` (`target_qualification_level_id`),
  KEY `idx_class_session` (`session_id`),
  KEY `idx_class_lecturer` (`primary_lecturer_id`),
  KEY `idx_class_year` (`academic_year`),
  KEY `idx_class_status` (`status`),
  CONSTRAINT `fk_class_lecturer` FOREIGN KEY (`primary_lecturer_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_class_session` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_class_subject_level` FOREIGN KEY (`subject_level_id`) REFERENCES `academic_subject_level` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_class_target_qual` FOREIGN KEY (`target_qualification_level_id`) REFERENCES `academic_level` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_class`
--

LOCK TABLES `academic_class` WRITE;
/*!40000 ALTER TABLE `academic_class` DISABLE KEYS */;
INSERT INTO `academic_class` VALUES (5,'ITC-L2-2025-A',1,NULL,'Cohort A','Regular',2025,27,NULL,'Computer Lab 1',30,0,NULL,NULL,'Active',NULL,1,'2026-01-31 11:36:02',NULL),(6,'PROG-L2-2025-A',2,NULL,'Cohort A','Regular',2025,27,NULL,'Computer Lab 2',30,0,NULL,NULL,'Active',NULL,1,'2026-01-31 11:36:02',NULL),(7,'MATH-N1-2025-A',3,NULL,'Cohort A','Regular',2025,27,NULL,'Room 101',35,0,NULL,NULL,'Active',NULL,1,'2026-01-31 11:36:02',NULL),(8,'ENG-N1-2025-A',4,NULL,'Cohort A','Regular',2025,27,NULL,'Lab 201',35,0,NULL,NULL,'Active',NULL,1,'2026-01-31 11:36:02',NULL);
/*!40000 ALTER TABLE `academic_class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_class_enrolment`
--

DROP TABLE IF EXISTS `academic_class_enrolment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_class_enrolment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `student_session_id` int NOT NULL COMMENT 'Links to student_session table',
  `enrolment_date` date NOT NULL,
  `enrolment_type` enum('Regular','Elective','Repeat','Cross-registered') NOT NULL DEFAULT 'Regular',
  `status` enum('Enrolled','Withdrawn','Completed','Failed','Deferred') NOT NULL DEFAULT 'Enrolled',
  `withdrawal_date` date DEFAULT NULL,
  `withdrawal_reason` varchar(255) DEFAULT NULL,
  `final_mark` decimal(5,2) DEFAULT NULL COMMENT 'Final calculated mark',
  `final_grade` varchar(10) DEFAULT NULL COMMENT 'Final grade symbol',
  `notes` text,
  `created_by` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_student` (`class_id`,`student_session_id`),
  KEY `idx_enrolment_class` (`class_id`),
  KEY `idx_enrolment_student` (`student_session_id`),
  KEY `idx_enrolment_status` (`status`),
  CONSTRAINT `fk_enrolment_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_enrolment_student` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_class_enrolment`
--

LOCK TABLES `academic_class_enrolment` WRITE;
/*!40000 ALTER TABLE `academic_class_enrolment` DISABLE KEYS */;
INSERT INTO `academic_class_enrolment` VALUES (1,5,1,'2025-01-15','Regular','Enrolled',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:38:38',NULL),(2,6,1,'2025-01-15','Regular','Enrolled',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:38:38',NULL),(3,7,1,'2025-01-15','Regular','Enrolled',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:38:38',NULL),(4,5,2,'2025-01-15','Regular','Enrolled',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:38:38',NULL),(5,7,2,'2025-01-15','Regular','Enrolled',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-31 11:38:38',NULL);
/*!40000 ALTER TABLE `academic_class_enrolment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_class_lecturer`
--

DROP TABLE IF EXISTS `academic_class_lecturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_class_lecturer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `staff_id` int NOT NULL,
  `role` enum('Primary','Assistant','Guest','Substitute') NOT NULL DEFAULT 'Primary',
  `assigned_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_lecturer` (`class_id`,`staff_id`),
  KEY `idx_cl_class` (`class_id`),
  KEY `idx_cl_staff` (`staff_id`),
  CONSTRAINT `fk_cl_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cl_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_class_lecturer`
--

LOCK TABLES `academic_class_lecturer` WRITE;
/*!40000 ALTER TABLE `academic_class_lecturer` DISABLE KEYS */;
/*!40000 ALTER TABLE `academic_class_lecturer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_icass_config`
--

DROP TABLE IF EXISTS `academic_icass_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_icass_config` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_level_id` int NOT NULL,
  `component_name` varchar(50) NOT NULL COMMENT 'e.g., Test 1, Assignment 1, Practical',
  `component_type` enum('Test','Assignment','Project','Practical','Presentation','Portfolio','Other') NOT NULL,
  `weight_percentage` decimal(5,2) NOT NULL COMMENT 'Weight in ICASS calculation',
  `sequence_order` tinyint unsigned NOT NULL DEFAULT '1',
  `is_compulsory` tinyint(1) NOT NULL DEFAULT '1',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_icass_subject_level` (`subject_level_id`),
  CONSTRAINT `fk_icass_subject_level` FOREIGN KEY (`subject_level_id`) REFERENCES `academic_subject_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_icass_config`
--

LOCK TABLES `academic_icass_config` WRITE;
/*!40000 ALTER TABLE `academic_icass_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `academic_icass_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_level`
--

DROP TABLE IF EXISTS `academic_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `programme_id` int NOT NULL,
  `name` varchar(50) NOT NULL COMMENT 'Level name (e.g., N4, N5, N6, NCV Level 2)',
  `code` varchar(20) NOT NULL COMMENT 'Short code (e.g., N4, L2)',
  `nqf_level` tinyint unsigned DEFAULT NULL COMMENT 'NQF level mapping',
  `sequence_order` tinyint unsigned NOT NULL DEFAULT '1' COMMENT 'Order within programme',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_level_programme_code` (`programme_id`,`code`),
  KEY `idx_level_programme` (`programme_id`),
  CONSTRAINT `fk_level_programme` FOREIGN KEY (`programme_id`) REFERENCES `academic_programme` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_level`
--

LOCK TABLES `academic_level` WRITE;
/*!40000 ALTER TABLE `academic_level` DISABLE KEYS */;
INSERT INTO `academic_level` VALUES (5,1,'NCV Level 2','L2',2,1,1,'2026-01-31 11:35:34',NULL),(6,1,'NCV Level 3','L3',3,2,1,'2026-01-31 11:35:34',NULL),(7,2,'NATED Level 1','N1',2,1,1,'2026-01-31 11:35:34',NULL),(8,2,'NATED Level 2','N2',3,2,1,'2026-01-31 11:35:34',NULL);
/*!40000 ALTER TABLE `academic_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_moderation_log`
--

DROP TABLE IF EXISTS `academic_moderation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_moderation_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assessment_id` int NOT NULL,
  `moderator_id` int NOT NULL,
  `action` enum('Submitted','Approved','Rejected','Revised') NOT NULL,
  `comments` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_assessment` (`assessment_id`),
  KEY `idx_moderator` (`moderator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_moderation_log`
--

LOCK TABLES `academic_moderation_log` WRITE;
/*!40000 ALTER TABLE `academic_moderation_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `academic_moderation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_poe_item`
--

DROP TABLE IF EXISTS `academic_poe_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_poe_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `enrolment_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `item_type` enum('Assignment','Project','Practical','Test','Other') NOT NULL,
  `description` text,
  `file_path` varchar(500) DEFAULT NULL,
  `submitted_date` date NOT NULL,
  `verification_status` enum('Pending','Verified','Rejected') DEFAULT 'Pending',
  `verified_by` int DEFAULT NULL,
  `verification_date` date DEFAULT NULL,
  `verification_comment` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_enrolment` (`enrolment_id`),
  KEY `idx_status` (`verification_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_poe_item`
--

LOCK TABLES `academic_poe_item` WRITE;
/*!40000 ALTER TABLE `academic_poe_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `academic_poe_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_programme`
--

DROP TABLE IF EXISTS `academic_programme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_programme` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT 'Programme name (e.g., NATED, NCV)',
  `code` varchar(20) NOT NULL COMMENT 'Short code (e.g., NATED, NCV)',
  `description` text,
  `duration_years` tinyint unsigned DEFAULT '3' COMMENT 'Standard programme duration',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_programme_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_programme`
--

LOCK TABLES `academic_programme` WRITE;
/*!40000 ALTER TABLE `academic_programme` DISABLE KEYS */;
INSERT INTO `academic_programme` VALUES (1,'NCV: Information Technology','NCV-IT','National Certificate Vocational in IT',3,1,'2026-01-31 11:31:46',NULL),(2,'Report 191: Business Engineering','NATED-BE','N1-N6 Engineering studies',3,1,'2026-01-31 11:31:46',NULL);
/*!40000 ALTER TABLE `academic_programme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_qualification_subject`
--

DROP TABLE IF EXISTS `academic_qualification_subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_qualification_subject` (
  `id` int NOT NULL AUTO_INCREMENT,
  `programme_id` int NOT NULL,
  `qualification_level_id` int NOT NULL,
  `subject_level_id` int NOT NULL,
  `is_compulsory` tinyint(1) DEFAULT '1',
  `elective_group` varchar(50) DEFAULT NULL,
  `min_electives_from_group` tinyint DEFAULT NULL,
  `credit_value` tinyint unsigned DEFAULT '0',
  `prerequisite_subject_level_id` int DEFAULT NULL,
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_qual_subject` (`qualification_level_id`,`subject_level_id`),
  KEY `idx_programme` (`programme_id`),
  KEY `idx_qual_level` (`qualification_level_id`),
  KEY `idx_subject_level` (`subject_level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_qualification_subject`
--

LOCK TABLES `academic_qualification_subject` WRITE;
/*!40000 ALTER TABLE `academic_qualification_subject` DISABLE KEYS */;
/*!40000 ALTER TABLE `academic_qualification_subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_subject`
--

DROP TABLE IF EXISTS `academic_subject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_subject` (
  `id` int NOT NULL AUTO_INCREMENT,
  `programme_id` int NOT NULL,
  `name` varchar(100) NOT NULL COMMENT 'Subject name (e.g., Mathematics, Business Studies)',
  `code` varchar(20) NOT NULL COMMENT 'Subject code (e.g., MATH, BUS)',
  `description` text,
  `field_of_study` varchar(100) DEFAULT NULL COMMENT 'Field classification',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_subject_programme_code` (`programme_id`,`code`),
  KEY `idx_subject_programme` (`programme_id`),
  CONSTRAINT `fk_subject_programme` FOREIGN KEY (`programme_id`) REFERENCES `academic_programme` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_subject`
--

LOCK TABLES `academic_subject` WRITE;
/*!40000 ALTER TABLE `academic_subject` DISABLE KEYS */;
INSERT INTO `academic_subject` VALUES (1,1,'Introduction to IT','ITC-L2','Introduction to Information Technology',NULL,1,'2026-01-31 11:35:34',NULL),(2,1,'Programming L2','PROG-L2','Introduction to Programming',NULL,1,'2026-01-31 11:35:34',NULL),(3,2,'Mathematics N1','MATH-N1','Fundamental mathematics for technical studies',NULL,1,'2026-01-31 11:35:34',NULL),(4,2,'Engineering Science N1','ENG-N1','Introduction to engineering principles',NULL,1,'2026-01-31 11:35:34',NULL);
/*!40000 ALTER TABLE `academic_subject` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_subject_level`
--

DROP TABLE IF EXISTS `academic_subject_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_subject_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int NOT NULL,
  `level_id` int NOT NULL,
  `subject_code_full` varchar(30) DEFAULT NULL COMMENT 'Full code (e.g., MATH-N4)',
  `saqa_id` varchar(20) DEFAULT NULL COMMENT 'SAQA registration number',
  `credits` tinyint unsigned DEFAULT '0' COMMENT 'Credit value',
  `notional_hours` smallint unsigned DEFAULT '0' COMMENT 'Notional learning hours',
  `contact_hours_per_week` tinyint unsigned DEFAULT '4' COMMENT 'Weekly contact hours',
  `pass_mark` tinyint unsigned DEFAULT '40' COMMENT 'Pass mark percentage',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_subject_level` (`subject_id`,`level_id`),
  KEY `idx_subject_level_subject` (`subject_id`),
  KEY `idx_subject_level_level` (`level_id`),
  CONSTRAINT `fk_sl_level` FOREIGN KEY (`level_id`) REFERENCES `academic_level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sl_subject` FOREIGN KEY (`subject_id`) REFERENCES `academic_subject` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_subject_level`
--

LOCK TABLES `academic_subject_level` WRITE;
/*!40000 ALTER TABLE `academic_subject_level` DISABLE KEYS */;
INSERT INTO `academic_subject_level` VALUES (1,1,5,'ITC-L2-2025',NULL,20,200,4,40,1,'2026-01-31 11:35:45',NULL),(2,2,5,'PROG-L2-2025',NULL,30,300,4,40,1,'2026-01-31 11:35:45',NULL),(3,3,7,'MATH-N1-2025',NULL,20,200,4,40,1,'2026-01-31 11:35:45',NULL),(4,4,7,'ENG-N1-2025',NULL,20,200,4,40,1,'2026-01-31 11:35:45',NULL);
/*!40000 ALTER TABLE `academic_subject_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `academic_timetable`
--

DROP TABLE IF EXISTS `academic_timetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `academic_timetable` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `venue` varchar(100) DEFAULT NULL,
  `lecturer_id` int DEFAULT NULL COMMENT 'Override lecturer for this slot',
  `is_recurring` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Weekly recurring',
  `effective_from` date DEFAULT NULL,
  `effective_until` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_timetable_class` (`class_id`),
  KEY `idx_timetable_day` (`day_of_week`),
  KEY `fk_timetable_lecturer` (`lecturer_id`),
  CONSTRAINT `fk_timetable_class` FOREIGN KEY (`class_id`) REFERENCES `academic_class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_timetable_lecturer` FOREIGN KEY (`lecturer_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `academic_timetable`
--

LOCK TABLES `academic_timetable` WRITE;
/*!40000 ALTER TABLE `academic_timetable` DISABLE KEYS */;
/*!40000 ALTER TABLE `academic_timetable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addon_versions`
--

DROP TABLE IF EXISTS `addon_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addon_versions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `addon_id` int DEFAULT NULL,
  `version` varchar(10) DEFAULT NULL,
  `version_order` int DEFAULT NULL,
  `folder_path` text,
  `sort_description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `addon_id` (`addon_id`),
  CONSTRAINT `addon_versions_ibfk_1` FOREIGN KEY (`addon_id`) REFERENCES `addons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addon_versions`
--

LOCK TABLES `addon_versions` WRITE;
/*!40000 ALTER TABLE `addon_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `addon_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `addons`
--

DROP TABLE IF EXISTS `addons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addons` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addons`
--

LOCK TABLES `addons` WRITE;
/*!40000 ALTER TABLE `addons` DISABLE KEYS */;
INSERT INTO `addons` VALUES (1,47443722,'uploads/addon_images/sscbse_images.jpg','Smart School CBSE Examination','cbse-config','sscbse','cbse_examination','CBSE Examination addon adds CBSE Examination module in Smart School. Using this module teacher/staff can create and print marksheets with advance features.',0.00,NULL,'https://go.smart-school.in/cbse-exam',NULL,NULL,NULL,NULL,NULL,'2024-09-03 16:04:58',0,4,'2024-09-03 16:04:58','2025-03-03 05:32:37'),(2,44278049,'uploads/addon_images/sstfa_images.jpg','Smart School Two Factor Authentication','google-authenticate-config','sstfa','two_factor_authentication','Two Factor Authentication addon adds Two Factor Authentication module in Smart School. Using this module you can enhance login security of your Smart School users.',0.00,NULL,'https://go.smart-school.in/2fa',NULL,NULL,NULL,NULL,NULL,'2025-01-29 11:16:14',0,5,'2024-09-07 10:45:18','2025-03-03 05:32:28'),(3,44277916,'uploads/addon_images/ssmb_images.jpg','Smart School Multi Branch','multibranch-config','ssmb','multi_branch','Multi Branch addon adds Multi Branch module in Smart School. Using this module Superadmin user can add other any number of schools/branches.',0.00,NULL,'https://go.smart-school.in/multi-branch',NULL,NULL,NULL,NULL,NULL,'2025-01-29 11:16:15',0,6,'2024-09-07 10:45:18','2025-03-03 05:32:20'),(4,44247532,'uploads/addon_images/ssbr_images.jpg','Smart School Behaviour Records','behaviour-report-config','ssbr','behavior_records','Behaviour Records addon adds Behaviour Records module in Smart School. Using this module teacher/staff can create different incidents with positive/negative marks and then assign these incidents on students.',0.00,NULL,'https://go.smart-school.in/behaviour-records',NULL,NULL,NULL,NULL,NULL,'2025-01-29 11:16:19',0,7,'2024-09-07 10:45:42','2025-03-03 05:32:11'),(5,33101540,'uploads/addon_images/ssoclc_images.jpg','Smart School Online Course','onlinecourse-config','ssoclc','online_course','Online Course addon adds Online Course module in Smart School. Using this module teacher/staff can create free or paid online course with their study material based on video, audio or in document content format.',0.00,NULL,'https://go.smart-school.in/online-course',NULL,NULL,NULL,NULL,NULL,'2025-01-29 11:16:19',0,8,'2024-09-07 10:45:42','2025-03-03 05:32:02'),(6,27492043,'uploads/addon_images/sszlc_images.jpg','Smart School Zoom Live Classes','zoom-config','sszlc','zoom_live_class','Zoom Live Class addon adds Zoom Live Class module in Smart School. Using this module teacher/staff can create live online classes using Zoom.us service. Further students can join these classes.',0.00,NULL,'https://go.smart-school.in/zoom',NULL,NULL,NULL,NULL,NULL,'2025-01-29 11:16:17',0,10,'2024-09-07 10:46:10','2025-03-03 05:31:49'),(7,28941973,'uploads/addon_images/ssglc_images.jpg','Smart School Gmeet Live Class','gmeet-config','ssglc','gmeet_live_class','Gmeet Live Class addon adds Gmeet Live Class module in Smart School. Using this module teacher/staff can create live online classes using http://meet.google.com service. Further students can join these classes.',0.00,NULL,'https://go.smart-school.in/gmeet',NULL,NULL,NULL,NULL,NULL,'2025-01-29 11:16:24',0,9,'2024-09-07 10:46:10','2025-03-03 05:31:33'),(8,50336584,'uploads/addon_images/ssqra_images.jpg','Smart School QR Code Attendance','qrattendance-config','ssqra','qr_code_attendance','QR Code Attendance addon adds automated Student/Staff attendance using QR/Barcode module in Smart School. Using this module Student/Staff can submit their attendance by just scanning their ID Card.',0.00,NULL,'https://go.smart-school.in/qr-attendance',NULL,NULL,NULL,NULL,NULL,'2025-01-28 22:28:58',0,3,'2025-01-13 13:10:06','2025-03-03 05:32:47'),(9,57220011,'uploads/addon_images/ssqfc_images.jpg','Smart School Quick Fees Create','quickfees-config','ssqfc','quick_fees_create','Quick Fees Create addon adds one click fees create feature in Smart School Fees Collection module. Using this you can create and assign fees on students in just few seconds and all Fees Category, Fees Groups, Fees Masters will be create automatically in your Smart School.',0.00,NULL,'https://go.smart-school.in/quick-fees',NULL,NULL,NULL,NULL,NULL,'2025-01-28 22:28:58',0,2,'2025-01-13 13:10:06','2025-03-03 05:33:00'),(10,57219905,'uploads/addon_images/sstpa_images.jpg','Smart School Thermal Print','thermalprint-config','sstpa','thermal_print','Thermal Print addon adds Thermal Printer compatible small size fees receipt print capability in Smart School. Using this module you can utilize modern cost effective fees receipt printing in Smart School.',0.00,NULL,'https://go.smart-school.in/thermal-print',NULL,NULL,NULL,NULL,NULL,'2025-01-30 10:28:42',0,1,'2025-01-13 13:10:06','2025-03-03 05:33:06');
/*!40000 ALTER TABLE `addons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alumni_events`
--

DROP TABLE IF EXISTS `alumni_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumni_events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` text NOT NULL,
  `event_for` varchar(100) NOT NULL,
  `session_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section` varchar(255) NOT NULL,
  `from_date` datetime NOT NULL,
  `to_date` datetime NOT NULL,
  `note` text NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `is_active` int NOT NULL,
  `event_notification_message` text NOT NULL,
  `show_onwebsite` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `alumni_events_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `alumni_events_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumni_events`
--

LOCK TABLES `alumni_events` WRITE;
/*!40000 ALTER TABLE `alumni_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `alumni_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alumni_students`
--

DROP TABLE IF EXISTS `alumni_students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alumni_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `current_email` varchar(255) NOT NULL,
  `current_phone` varchar(255) NOT NULL,
  `occupation` text NOT NULL,
  `address` text NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `alumni_students_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alumni_students`
--

LOCK TABLES `alumni_students` WRITE;
/*!40000 ALTER TABLE `alumni_students` DISABLE KEYS */;
/*!40000 ALTER TABLE `alumni_students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `annual_calendar`
--

DROP TABLE IF EXISTS `annual_calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annual_calendar` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `annual_calendar_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annual_calendar`
--

LOCK TABLES `annual_calendar` WRITE;
/*!40000 ALTER TABLE `annual_calendar` DISABLE KEYS */;
/*!40000 ALTER TABLE `annual_calendar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendence_type`
--

DROP TABLE IF EXISTS `attendence_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendence_type` (
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendence_type`
--

LOCK TABLES `attendence_type` WRITE;
/*!40000 ALTER TABLE `attendence_type` DISABLE KEYS */;
INSERT INTO `attendence_type` VALUES (1,'Present','<b class=\"text text-success\">P</b>','present','label label-success','yes',1,1,'2023-12-13 07:53:10','0000-00-00 00:00:00'),(2,'Late With Excuse','<b class=\"text text-warning\">E</b>','late_with_excuse','label label-warning text-dark','no',0,0,'2023-12-13 07:51:03','0000-00-00 00:00:00'),(3,'Late','<b class=\"text text-warning\">L</b>','late','label label-warning text-dark','yes',1,1,'2023-12-13 07:51:09','0000-00-00 00:00:00'),(4,'Absent','<b class=\"text text-danger\">A</b>','absent','label label-danger','yes',0,0,'2023-12-15 06:18:05','0000-00-00 00:00:00'),(5,'Holiday','H','holiday','label label-info','yes',0,0,'2023-12-14 12:57:13','0000-00-00 00:00:00'),(6,'Half Day','<b class=\"text text-warning\">F</b>','half_day','label label-warning text-dark','yes',1,1,'2023-12-15 06:18:37','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `attendence_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_issues`
--

DROP TABLE IF EXISTS `book_issues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_issues` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `member_id` int DEFAULT NULL,
  `duereturn_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `is_returned` int DEFAULT '0',
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `book_id` (`book_id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `book_issues_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `book_issues_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `libarary_members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_issues`
--

LOCK TABLES `book_issues` WRITE;
/*!40000 ALTER TABLE `book_issues` DISABLE KEYS */;
/*!40000 ALTER TABLE `book_issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_title` varchar(100) NOT NULL,
  `book_no` varchar(50) NOT NULL,
  `isbn_no` varchar(100) NOT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `rack_no` varchar(100) NOT NULL,
  `publish` varchar(100) DEFAULT NULL,
  `author` varchar(100) DEFAULT NULL,
  `qty` int DEFAULT NULL,
  `perunitcost` float(10,2) DEFAULT NULL,
  `postdate` date DEFAULT NULL,
  `description` text,
  `available` varchar(10) DEFAULT 'yes',
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `captcha`
--

DROP TABLE IF EXISTS `captcha`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `captcha` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `status` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `captcha`
--

LOCK TABLES `captcha` WRITE;
/*!40000 ALTER TABLE `captcha` DISABLE KEYS */;
INSERT INTO `captcha` VALUES (1,'userlogin',0,'2021-01-19 08:10:29','2026-01-29 12:14:52'),(2,'login',0,'2021-01-19 08:10:31','2026-01-29 12:14:52'),(3,'admission',0,'2021-01-19 04:48:11','2026-01-29 12:14:52'),(4,'complain',0,'2021-01-19 04:48:13','2026-01-29 12:14:52'),(5,'contact_us',0,'2021-01-19 04:48:15','2026-01-29 12:14:52');
/*!40000 ALTER TABLE `captcha` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` varchar(100) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certificates`
--

DROP TABLE IF EXISTS `certificates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `certificates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `certificate_name` varchar(100) NOT NULL,
  `certificate_text` text NOT NULL,
  `left_header` varchar(100) NOT NULL,
  `center_header` varchar(100) NOT NULL,
  `right_header` varchar(100) NOT NULL,
  `left_footer` varchar(100) NOT NULL,
  `right_footer` varchar(100) NOT NULL,
  `center_footer` varchar(100) NOT NULL,
  `background_image` varchar(100) DEFAULT NULL,
  `created_for` tinyint(1) NOT NULL COMMENT '1 = staff, 2 = students',
  `status` tinyint(1) NOT NULL,
  `header_height` int NOT NULL,
  `content_height` int NOT NULL,
  `footer_height` int NOT NULL,
  `content_width` int NOT NULL,
  `enable_student_image` tinyint(1) NOT NULL COMMENT '0=no,1=yes',
  `enable_image_height` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificates`
--

LOCK TABLES `certificates` WRITE;
/*!40000 ALTER TABLE `certificates` DISABLE KEYS */;
INSERT INTO `certificates` VALUES (1,'Sample Transfer Certificate','This is certify that <b>[name]</b> has born on [dob]  <br> and have following details [present_address] [guardian] [created_at] [admission_no] [roll_no] [class] [section] [gender] [admission_date] [category] [cast] [father_name] [mother_name] [religion] [email] [phone] .<br>We wish best of luck for future endeavors.','Reff. No.....1111111.........','To Whomever It May Concern','Date: _10__/_10__/__2019__','.................................<br>admin','.................................<br>principal','.................................<br>admin','sampletc121.png',2,1,360,400,480,810,1,230,'2019-12-21 15:14:34','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `certificates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_connections`
--

DROP TABLE IF EXISTS `chat_connections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_connections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `chat_user_one` int NOT NULL,
  `chat_user_two` int NOT NULL,
  `ip` varchar(30) DEFAULT NULL,
  `time` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `chat_user_one` (`chat_user_one`),
  KEY `chat_user_two` (`chat_user_two`),
  CONSTRAINT `chat_connections_ibfk_1` FOREIGN KEY (`chat_user_one`) REFERENCES `chat_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_connections_ibfk_2` FOREIGN KEY (`chat_user_two`) REFERENCES `chat_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_connections`
--

LOCK TABLES `chat_connections` WRITE;
/*!40000 ALTER TABLE `chat_connections` DISABLE KEYS */;
/*!40000 ALTER TABLE `chat_connections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message` text,
  `chat_user_id` int NOT NULL,
  `ip` varchar(30) NOT NULL,
  `time` int NOT NULL,
  `is_first` int DEFAULT '0',
  `is_read` int NOT NULL DEFAULT '0',
  `chat_connection_id` int NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `chat_user_id` (`chat_user_id`),
  KEY `chat_connection_id` (`chat_connection_id`),
  CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`chat_user_id`) REFERENCES `chat_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_messages_ibfk_2` FOREIGN KEY (`chat_connection_id`) REFERENCES `chat_connections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_messages`
--

LOCK TABLES `chat_messages` WRITE;
/*!40000 ALTER TABLE `chat_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_users`
--

DROP TABLE IF EXISTS `chat_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_type` varchar(20) DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `create_staff_id` int DEFAULT NULL,
  `create_student_id` int DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `student_id` (`student_id`),
  KEY `create_staff_id` (`create_staff_id`),
  KEY `create_student_id` (`create_student_id`),
  CONSTRAINT `chat_users_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_users_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_users_ibfk_3` FOREIGN KEY (`create_staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chat_users_ibfk_4` FOREIGN KEY (`create_student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_users`
--

LOCK TABLES `chat_users` WRITE;
/*!40000 ALTER TABLE `chat_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `chat_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_code` varchar(50) NOT NULL COMMENT 'e.g., MATH-N4-A-2026',
  `subject_level_id` int NOT NULL,
  `cohort_name` varchar(50) NOT NULL COMMENT 'e.g., A, B, C, Group 1, Evening',
  `academic_year` int NOT NULL,
  `session_id` int NOT NULL,
  `intake_period` varchar(20) DEFAULT NULL COMMENT 'Jan, Jul, etc.',
  `delivery_mode` enum('Full-time','Part-time','Evening','Weekend','Distance') NOT NULL DEFAULT 'Full-time',
  `primary_lecturer_id` int DEFAULT NULL,
  `venue` varchar(100) DEFAULT NULL COMMENT 'Room/Lab assignment',
  `max_students` int NOT NULL DEFAULT '50',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('Scheduled','Active','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_code_session` (`class_code`,`session_id`),
  KEY `idx_subject_level` (`subject_level_id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_lecturer` (`primary_lecturer_id`),
  KEY `idx_academic_year` (`academic_year`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_unified_class_lecturer` FOREIGN KEY (`primary_lecturer_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_class_session` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_class_subject_level` FOREIGN KEY (`subject_level_id`) REFERENCES `subject_level` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
INSERT INTO `class` VALUES (1,'BMN4-LEG3-Group A-2026',48,'Group A',2026,27,NULL,'Full-time',2,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:44:56'),(2,'FMN4-LEG3-Group A-2026',47,'Group A',2026,27,NULL,'Full-time',2,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:44:56'),(3,'MCN4-LEG3-Group A-2026',46,'Group A',2026,27,NULL,'Full-time',2,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:44:56'),(4,'EBMN4-LEG3-Group A-2026',45,'Group A',2026,27,NULL,'Full-time',2,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:44:56'),(5,'BMN4-LEG2-Group A-2026',44,'Group A',2026,27,NULL,'Full-time',2,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:44:56'),(6,'FMN4-LEG2-Group A-2026',43,'Group A',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(7,'MCN4-LEG2-Group A-2026',42,'Group A',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(8,'EBMN4-LEG2-Group A-2026',41,'Group A',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(9,'BMN4-LEG1-Group A-2026',40,'Group A',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(10,'FMN4-LEG1-Group A-2026',39,'Group A',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(11,'MCN4-LEG1-Group A-2026',38,'Group A',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(12,'EBMN4-LEG1-Group A-2026',37,'Group A',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(13,'BMN4-LEG3-Group B-2026',48,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(14,'FMN4-LEG3-Group B-2026',47,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(15,'MCN4-LEG3-Group B-2026',46,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(16,'EBMN4-LEG3-Group B-2026',45,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(17,'BMN4-LEG2-Group B-2026',44,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(18,'FMN4-LEG2-Group B-2026',43,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(19,'MCN4-LEG2-Group B-2026',42,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(20,'EBMN4-LEG2-Group B-2026',41,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(21,'BMN4-LEG1-Group B-2026',40,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(22,'FMN4-LEG1-Group B-2026',39,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(23,'MCN4-LEG1-Group B-2026',38,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(24,'EBMN4-LEG1-Group B-2026',37,'Group B',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(25,'BMN4-LEG3-Evening-2026',48,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(26,'FMN4-LEG3-Evening-2026',47,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(27,'MCN4-LEG3-Evening-2026',46,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(28,'EBMN4-LEG3-Evening-2026',45,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(29,'BMN4-LEG2-Evening-2026',44,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(30,'FMN4-LEG2-Evening-2026',43,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(31,'MCN4-LEG2-Evening-2026',42,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(32,'EBMN4-LEG2-Evening-2026',41,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(33,'BMN4-LEG1-Evening-2026',40,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(34,'FMN4-LEG1-Evening-2026',39,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(35,'MCN4-LEG1-Evening-2026',38,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(36,'EBMN4-LEG1-Evening-2026',37,'Evening',2026,27,NULL,'Full-time',NULL,NULL,50,NULL,NULL,'Active',1,'2026-02-03 16:14:53','2026-02-03 16:14:53');
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class_lecturer`
--

DROP TABLE IF EXISTS `class_lecturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_lecturer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL,
  `staff_id` int NOT NULL,
  `role` enum('Primary','Assistant','Tutor','Assessor','Moderator') NOT NULL DEFAULT 'Assistant',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_class_lecturer` (`class_id`,`staff_id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_staff` (`staff_id`),
  KEY `idx_role` (`role`),
  CONSTRAINT `fk_unified_cl_class` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_cl_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_lecturer`
--

LOCK TABLES `class_lecturer` WRITE;
/*!40000 ALTER TABLE `class_lecturer` DISABLE KEYS */;
/*!40000 ALTER TABLE `class_lecturer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class_section_times`
--

DROP TABLE IF EXISTS `class_section_times`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_section_times` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_section_id` int DEFAULT NULL,
  `time` time DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `class_section_id` (`class_section_id`),
  CONSTRAINT `class_section_times_ibfk_1` FOREIGN KEY (`class_section_id`) REFERENCES `class_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_section_times`
--

LOCK TABLES `class_section_times` WRITE;
/*!40000 ALTER TABLE `class_section_times` DISABLE KEYS */;
/*!40000 ALTER TABLE `class_section_times` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class_sections`
--

DROP TABLE IF EXISTS `class_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`),
  CONSTRAINT `class_sections_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `class_sections_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_sections`
--

LOCK TABLES `class_sections` WRITE;
/*!40000 ALTER TABLE `class_sections` DISABLE KEYS */;
INSERT INTO `class_sections` VALUES (1,1,1,'no','2026-01-29 12:15:00','2026-01-29 12:15:00'),(2,1,2,'no','2026-01-29 12:15:00','2026-01-29 12:15:00'),(3,2,1,'no','2026-01-29 12:15:00','2026-01-29 12:15:00'),(4,3,1,'no','2026-01-29 12:15:00','2026-01-29 12:15:00');
/*!40000 ALTER TABLE `class_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class_teacher`
--

DROP TABLE IF EXISTS `class_teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class_teacher` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `class_id` int NOT NULL,
  `section_id` int NOT NULL,
  `staff_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`),
  KEY `session_id` (`session_id`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `class_teacher_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `class_teacher_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `class_teacher_ibfk_3` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `class_teacher_ibfk_4` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_teacher`
--

LOCK TABLES `class_teacher` WRITE;
/*!40000 ALTER TABLE `class_teacher` DISABLE KEYS */;
/*!40000 ALTER TABLE `class_teacher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classes`
--

DROP TABLE IF EXISTS `classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `classes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class` varchar(60) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classes`
--

LOCK TABLES `classes` WRITE;
/*!40000 ALTER TABLE `classes` DISABLE KEYS */;
INSERT INTO `classes` VALUES (1,'N4 Business Management','yes','2026-01-29 12:15:00','2026-01-29 12:15:00'),(2,'N5 Business Management','yes','2026-01-29 12:15:00','2026-01-29 12:15:00'),(3,'NCV Engineering L2','yes','2026-01-29 12:15:00','2026-01-29 12:15:00');
/*!40000 ALTER TABLE `classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `complaint`
--

DROP TABLE IF EXISTS `complaint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complaint` (
  `id` int NOT NULL AUTO_INCREMENT,
  `complaint_type` varchar(255) NOT NULL,
  `source` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contact` varchar(15) NOT NULL,
  `email` varchar(200) NOT NULL,
  `date` date NOT NULL,
  `description` text NOT NULL,
  `action_taken` varchar(200) NOT NULL,
  `assigned` varchar(50) NOT NULL,
  `note` text NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complaint`
--

LOCK TABLES `complaint` WRITE;
/*!40000 ALTER TABLE `complaint` DISABLE KEYS */;
/*!40000 ALTER TABLE `complaint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `complaint_type`
--

DROP TABLE IF EXISTS `complaint_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complaint_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `complaint_type` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complaint_type`
--

LOCK TABLES `complaint_type` WRITE;
/*!40000 ALTER TABLE `complaint_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `complaint_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conference_cohorts`
--

DROP TABLE IF EXISTS `conference_cohorts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conference_cohorts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `conference_id` int NOT NULL,
  `cohort_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_conference_id` (`conference_id`),
  KEY `idx_cohort_id` (`cohort_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conference_cohorts`
--

LOCK TABLES `conference_cohorts` WRITE;
/*!40000 ALTER TABLE `conference_cohorts` DISABLE KEYS */;
/*!40000 ALTER TABLE `conference_cohorts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conference_sections`
--

DROP TABLE IF EXISTS `conference_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conference_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conference_id` int DEFAULT NULL,
  `cls_section_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conference_sections`
--

LOCK TABLES `conference_sections` WRITE;
/*!40000 ALTER TABLE `conference_sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `conference_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conference_staff`
--

DROP TABLE IF EXISTS `conference_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conference_staff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conference_id` int NOT NULL,
  `staff_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conference_staff`
--

LOCK TABLES `conference_staff` WRITE;
/*!40000 ALTER TABLE `conference_staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `conference_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conferences`
--

DROP TABLE IF EXISTS `conferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conferences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `purpose` varchar(20) NOT NULL DEFAULT 'class',
  `staff_id` int DEFAULT NULL,
  `created_id` int NOT NULL,
  `title` text,
  `date` datetime DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `session_id` int NOT NULL,
  `host_video` int NOT NULL DEFAULT '1',
  `client_video` int NOT NULL DEFAULT '1',
  `description` text,
  `timezone` varchar(100) DEFAULT NULL,
  `return_response` text,
  `api_type` varchar(30) NOT NULL,
  `status` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `platform` varchar(20) NOT NULL DEFAULT 'zoom',
  `tvet_module_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conferences`
--

LOCK TABLES `conferences` WRITE;
/*!40000 ALTER TABLE `conferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `conferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conferences_history`
--

DROP TABLE IF EXISTS `conferences_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conferences_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conference_id` int NOT NULL,
  `staff_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `total_hit` int NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conferences_history`
--

LOCK TABLES `conferences_history` WRITE;
/*!40000 ALTER TABLE `conferences_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `conferences_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_for`
--

DROP TABLE IF EXISTS `content_for`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_for` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role` varchar(50) DEFAULT NULL,
  `content_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `content_id` (`content_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `content_for_ibfk_1` FOREIGN KEY (`content_id`) REFERENCES `contents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `content_for_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_for`
--

LOCK TABLES `content_for` WRITE;
/*!40000 ALTER TABLE `content_for` DISABLE KEYS */;
/*!40000 ALTER TABLE `content_for` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_types`
--

DROP TABLE IF EXISTS `content_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `description` text,
  `is_active` int DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_types`
--

LOCK TABLES `content_types` WRITE;
/*!40000 ALTER TABLE `content_types` DISABLE KEYS */;
INSERT INTO `content_types` VALUES (1,'Study Material',NULL,0,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(2,'Past Paper',NULL,0,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(3,'Assignment',NULL,0,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(4,'Syllabus',NULL,0,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(5,'Other',NULL,0,'2026-01-29 12:15:00','2026-01-29 12:15:00');
/*!40000 ALTER TABLE `content_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `content_views`
--

DROP TABLE IF EXISTS `content_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `content_views` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `upload_content_id` int NOT NULL,
  `share_content_id` int DEFAULT NULL,
  `student_session_id` int NOT NULL,
  `viewed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_content_student` (`upload_content_id`,`student_session_id`),
  KEY `idx_student_session` (`student_session_id`),
  KEY `idx_upload_content` (`upload_content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `content_views`
--

LOCK TABLES `content_views` WRITE;
/*!40000 ALTER TABLE `content_views` DISABLE KEYS */;
INSERT INTO `content_views` VALUES (1,1,NULL,1,'2026-01-29 12:34:48'),(2,2,NULL,1,'2026-01-29 12:47:34'),(3,3,NULL,1,'2026-02-01 07:22:58');
/*!40000 ALTER TABLE `content_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contents`
--

DROP TABLE IF EXISTS `contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contents` (
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
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `class_id` (`class_id`),
  KEY `cls_sec_id` (`cls_sec_id`),
  CONSTRAINT `contents_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `contents_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `contents_ibfk_3` FOREIGN KEY (`cls_sec_id`) REFERENCES `class_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contents`
--

LOCK TABLES `contents` WRITE;
/*!40000 ALTER TABLE `contents` DISABLE KEYS */;
/*!40000 ALTER TABLE `contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cumulative_fine`
--

DROP TABLE IF EXISTS `cumulative_fine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cumulative_fine` (
  `id` int NOT NULL AUTO_INCREMENT,
  `overdue_day` int NOT NULL,
  `fine_amount` float(10,2) NOT NULL,
  `fee_groups_feetype_id` int NOT NULL,
  `fee_session_group_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cumulative_fine`
--

LOCK TABLES `cumulative_fine` WRITE;
/*!40000 ALTER TABLE `cumulative_fine` DISABLE KEYS */;
/*!40000 ALTER TABLE `cumulative_fine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currencies`
--

DROP TABLE IF EXISTS `currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currencies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `short_name` varchar(100) DEFAULT NULL,
  `symbol` varchar(10) DEFAULT NULL,
  `base_price` varchar(10) NOT NULL DEFAULT '1',
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currencies`
--

LOCK TABLES `currencies` WRITE;
/*!40000 ALTER TABLE `currencies` DISABLE KEYS */;
INSERT INTO `currencies` VALUES (1,'AED','AED','AEDf','1',0,'2022-12-30 06:19:15','2026-01-29 12:14:52'),(2,'AFN','AFN','؋','1',0,'2022-12-30 06:19:19','2026-01-29 12:14:52'),(3,'ALL','ALL','ALL','1',0,'2022-12-30 06:19:22','2026-01-29 12:14:52'),(4,'AMD','AMD','AMD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(5,'ANG','ANG','ANG','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(6,'AOA','AOA','AOA','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(7,'ARS','ARS','ARS','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(8,'AUD','AUD','AUD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(9,'AWG','AWG','AWG','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(10,'AZN','AZN','AZN','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(11,'BAM','BAM','BAM','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(12,'BAM','BAM','BAM','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(13,'BDT','BDT','BDT','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(14,'BGN','BGN','BGN','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(15,'BHD','BHD','BHD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(16,'BIF','BIF','BIF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(17,'BMD','BMD','BMD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(18,'BND','BND','BND','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(19,'BOB','BOB','BOB','1',0,'2022-12-30 06:19:29','2026-01-29 12:14:52'),(20,'BOV','BOV','BOV','1',0,'2022-12-30 06:19:38','2026-01-29 12:14:52'),(21,'BRL','BRL','BRL','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(22,'BSD','BSD','BSD','1',0,'2022-12-30 06:19:40','2026-01-29 12:14:52'),(23,'BTN','BTN','BTN','1',0,'2022-12-30 06:19:42','2026-01-29 12:14:52'),(24,'BWP','BWP','BWP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(25,'BYN','BYN','BYN','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(26,'BYR','BYR','BYR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(27,'BZD','BZD','BZD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(28,'CAD','CAD','CAD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(29,'CDF','CDF','CDF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(30,'CHE','CHE','CHE','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(31,'CHF','CHF','CHF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(32,'CHW','CHW','CHW','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(33,'CLF','CLF','CLF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(34,'CLP','CLP','CLP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(35,'CNY','CNY','CNY','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(36,'COP','COP','COP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(37,'COU','COU','COU','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(38,'CRC','CRC','CRC','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(39,'CUC','CUC','CUC','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(40,'CUP','CUP','CUP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(41,'CVE','CVE','CVE','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(42,'CZK','CZK','CZK','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(43,'DJF','DJF','DJF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(44,'DKK','DKK','DKK','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(45,'DOP','DOP','DOP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(46,'DZD','DZD','DZD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(47,'EGP','EGP','EGP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(48,'ERN','ERN','ERN','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(49,'ETB','ETB','ETB','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(50,'EUR','EUR','€','1',0,'2022-12-30 06:20:25','2026-01-29 12:14:52'),(51,'FJD','FJD','FJD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(52,'FKP','FKP','FKP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(53,'GBP','GBP','£','1',0,'2022-12-30 06:20:29','2026-01-29 12:14:52'),(54,'GEL','GEL','GEL','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(55,'GHS','GHS','GHS','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(56,'GIP','GIP','GIP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(57,'GMD','GMD','GMD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(58,'GNF','GNF','GNF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(59,'GTQ','GTQ','GTQ','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(60,'GYD','GYD','GYD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(61,'HKD','HKD','HKD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(62,'HNL','HNL','HNL','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(63,'HRK','HRK','HRK','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(64,'HTG','HTG','HTG','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(65,'HUF','HUF','HUF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(66,'IDR','IDR','IDR','1',0,'2022-12-30 06:20:34','2026-01-29 12:14:52'),(67,'ILS','ILS','ILS','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(68,'INR','INR','₹','1',0,'2022-12-30 06:20:37','2026-01-29 12:14:52'),(69,'IQD','IQD','IQD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(70,'IRR','IRR','IRR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(71,'ISK','ISK','ISK','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(72,'JMD','JMD','JMD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(73,'JOD','JOD','JOD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(74,'JPY','JPY','JPY','1',0,'2022-12-30 06:19:56','2026-01-29 12:14:52'),(75,'KES','KES','KES','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(76,'KGS','KGS','KGS','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(77,'KHR','KHR','KHR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(78,'KMF','KMF','KMF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(79,'KPW','KPW','KPW','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(80,'KRW','KRW','KRW','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(81,'KWD','KWD','KWD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(82,'KYD','KYD','KYD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(83,'KZT','KZT','KZT','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(84,'LAK','LAK','LAK','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(85,'LBP','LBP','LBP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(86,'LKR','LKR','LKR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(87,'LRD','LRD','LRD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(88,'LSL','LSL','LSL','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(89,'LYD','LYD','LYD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(90,'MAD','MAD','MAD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(91,'MDL','MDL','MDL','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(92,'MGA','MGA','MGA','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(93,'MKD','MKD','MKD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(94,'MMK','MMK','MMK','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(95,'MNT','MNT','MNT','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(96,'MOP','MOP','MOP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(97,'MRO','MRO','MRO','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(98,'MUR','MUR','MUR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(99,'MVR','MVR','MVR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(100,'MWK','MWK','MWK','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(101,'MXN','MXN','MXN','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(102,'MXV','MXV','MXV','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(103,'MYR','MYR','MYR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(104,'MZN','MZN','MZN','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(105,'NAD','NAD','NAD','1',0,'2022-07-30 09:32:37','2026-01-29 12:14:52'),(106,'NGN','NGN','NGN','1',0,'2022-12-30 06:20:42','2026-01-29 12:14:52'),(107,'NIO','NIO','NIO','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(108,'NOK','NOK','NOK','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(109,'NPR','NPR','NPR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(110,'NZD','NZD','NZD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(111,'OMR','OMR','OMR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(112,'PAB','PAB','PAB','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(113,'PEN','PEN','PEN','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(114,'PGK','PGK','PGK','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(115,'PHP','PHP','PHP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(116,'PKR','PKR','PKR','1',0,'2022-12-30 06:20:19','2026-01-29 12:14:52'),(117,'PLN','PLN','PLN','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(118,'PYG','PYG','PYG','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(119,'QAR','QAR','QAR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(120,'RON','RON','RON','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(121,'RSD','RSD','RSD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(122,'RUB','RUB','RUB','1',0,'2022-12-30 06:20:16','2026-01-29 12:14:52'),(123,'RWF','RWF','RWF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(124,'SAR','SAR','SAR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(125,'SBD','SBD','SBD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(126,'SCR','SCR','SCR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(127,'SDG','SDG','SDG','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(128,'SEK','SEK','SEK','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(129,'SGD','SGD','SGD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(130,'SHP','SHP','SHP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(131,'SLL','SLL','SLL','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(132,'SOS','SOS','SOS','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(133,'SRD','SRD','SRD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(134,'SSP','SSP','SSP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(135,'STD','STD','STD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(136,'SVC','SVC','SVC','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(137,'SYP','SYP','SYP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(138,'SZL','SZL','SZL','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(139,'THB','THB','THB','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(140,'TJS','TJS','TJS','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(141,'TMT','TMT','TMT','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(142,'TND','TND','TND','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(143,'TOP','TOP','TOP','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(144,'TRY','TRY','TRY','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(145,'TTD','TTD','TTD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(146,'TWD','TWD','TWD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(147,'TZS','TZS','TZS','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(148,'UAH','UAH','UAH','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(149,'UGX','UGX','UGX','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(150,'USD','USD','$','1',1,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(151,'USN','USN','USN','1',0,'2022-12-30 06:20:03','2026-01-29 12:14:52'),(152,'UYI','UYI','UYI','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(153,'UYU','UYU','UYU','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(154,'UZS','UZS','UZS','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(155,'VEF','VEF','VEF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(156,'VND','VND','VND','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(157,'VUV','VUV','VUV','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(158,'WST','WST','WST','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(159,'XAF','XAF','XAF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(160,'XAG','XAG','XAG','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(161,'XAU','XAU','XAU','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(162,'XBA','XBA','XBA','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(163,'XBB','XBB','XBB','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(164,'XBC','XBC','XBC','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(165,'XBD','XBD','XBD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(166,'XCD','XCD','XCD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(167,'XDR','XDR','XDR','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(168,'XOF','XOF','XOF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(169,'XPD','XPD','XPD','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(170,'XPF','XPF','XPF','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(171,'XPT','XPT','XPT','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(172,'XSU','XSU','XSU','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(173,'XTS','XTS','XTS','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(174,'XUA','XUA','XUA','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(175,'XXX','XXX','XXX','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(176,'YER','YER','YER','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52'),(177,'ZAR','ZAR','ZAR','1',0,'2022-12-30 06:20:07','2026-01-29 12:14:52'),(178,'ZMW','ZMW','ZMW','1',0,'2022-07-30 07:34:00','2026-01-29 12:14:52'),(179,'ZWL','ZWL','ZWL','1',0,'2022-07-22 10:55:15','2026-01-29 12:14:52');
/*!40000 ALTER TABLE `currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_field_values`
--

DROP TABLE IF EXISTS `custom_field_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_field_values` (
  `id` int NOT NULL AUTO_INCREMENT,
  `belong_table_id` int DEFAULT NULL,
  `custom_field_id` int DEFAULT NULL,
  `field_value` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `custom_field_id` (`custom_field_id`),
  KEY `idx_belong_table_id` (`belong_table_id`),
  KEY `idx_field_value` (`field_value`),
  CONSTRAINT `custom_field_values_ibfk_1` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_field_values`
--

LOCK TABLES `custom_field_values` WRITE;
/*!40000 ALTER TABLE `custom_field_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_field_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_fields`
--

DROP TABLE IF EXISTS `custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_fields` (
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
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_belong_to` (`belong_to`),
  KEY `idx_type` (`type`),
  KEY `idx_visible_on_table` (`visible_on_table`),
  KEY `idx_weight` (`weight`),
  FULLTEXT KEY `idx_field_values` (`field_values`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_fields`
--

LOCK TABLES `custom_fields` WRITE;
/*!40000 ALTER TABLE `custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `daily_assignment`
--

DROP TABLE IF EXISTS `daily_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_assignment` (
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
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `evaluated_by` (`evaluated_by`),
  KEY `subject_group_subject_id` (`subject_group_subject_id`),
  CONSTRAINT `daily_assignment_ibfk_1` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE,
  CONSTRAINT `daily_assignment_ibfk_2` FOREIGN KEY (`evaluated_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `daily_assignment_ibfk_3` FOREIGN KEY (`subject_group_subject_id`) REFERENCES `subject_group_subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_assignment`
--

LOCK TABLES `daily_assignment` WRITE;
/*!40000 ALTER TABLE `daily_assignment` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `id` int NOT NULL AUTO_INCREMENT,
  `department_name` varchar(200) NOT NULL,
  `is_active` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disability_types`
--

DROP TABLE IF EXISTS `disability_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disability_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `default_extra_time_percent` int NOT NULL DEFAULT '25',
  `is_active` enum('yes','no') DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disability_types`
--

LOCK TABLES `disability_types` WRITE;
/*!40000 ALTER TABLE `disability_types` DISABLE KEYS */;
INSERT INTO `disability_types` VALUES (1,'Visual Impairment','Includes blindness, low vision, color blindness',50,'yes','2026-01-29 14:45:11','2026-01-29 14:45:11'),(2,'Hearing Impairment','Includes deafness, hard of hearing',25,'yes','2026-01-29 14:45:11','2026-01-29 14:45:11'),(3,'Physical Disability','Mobility impairments, motor disabilities',25,'yes','2026-01-29 14:45:11','2026-01-29 14:45:11'),(4,'Learning Disability','Dyslexia, dyscalculia, dysgraphia',50,'yes','2026-01-29 14:45:11','2026-01-29 14:45:11'),(5,'Cognitive Disability','Intellectual disabilities, memory impairments',50,'yes','2026-01-29 14:45:11','2026-01-29 14:45:11'),(6,'Speech Impairment','Speech and language disorders',25,'yes','2026-01-29 14:45:11','2026-01-29 14:45:11'),(7,'Other','Other disabilities not listed above',25,'yes','2026-01-29 14:45:11','2026-01-29 14:45:11');
/*!40000 ALTER TABLE `disability_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disable_reason`
--

DROP TABLE IF EXISTS `disable_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disable_reason` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reason` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disable_reason`
--

LOCK TABLES `disable_reason` WRITE;
/*!40000 ALTER TABLE `disable_reason` DISABLE KEYS */;
/*!40000 ALTER TABLE `disable_reason` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dispatch_receive`
--

DROP TABLE IF EXISTS `dispatch_receive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispatch_receive` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispatch_receive`
--

LOCK TABLES `dispatch_receive` WRITE;
/*!40000 ALTER TABLE `dispatch_receive` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispatch_receive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_attachments`
--

DROP TABLE IF EXISTS `email_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_attachments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `message_id` int NOT NULL,
  `directory` varchar(255) NOT NULL,
  `attachment` varchar(255) NOT NULL,
  `attachment_name` varchar(200) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `message_id` (`message_id`),
  CONSTRAINT `email_attachments_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_attachments`
--

LOCK TABLES `email_attachments` WRITE;
/*!40000 ALTER TABLE `email_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_config`
--

DROP TABLE IF EXISTS `email_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_config` (
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_config`
--

LOCK TABLES `email_config` WRITE;
/*!40000 ALTER TABLE `email_config` DISABLE KEYS */;
INSERT INTO `email_config` VALUES (1,'sendmail',NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL,'yes','2020-02-28 13:46:03','2026-01-29 12:14:52');
/*!40000 ALTER TABLE `email_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_template`
--

DROP TABLE IF EXISTS `email_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `created_at` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_template`
--

LOCK TABLES `email_template` WRITE;
/*!40000 ALTER TABLE `email_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_template_attachment`
--

DROP TABLE IF EXISTS `email_template_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_template_attachment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email_template_id` int NOT NULL,
  `attachment` varchar(100) NOT NULL,
  `attachment_name` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_template_attachment`
--

LOCK TABLES `email_template_attachment` WRITE;
/*!40000 ALTER TABLE `email_template_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `email_template_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enquiry`
--

DROP TABLE IF EXISTS `enquiry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enquiry` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `contact` varchar(20) NOT NULL,
  `address` text NOT NULL,
  `reference` varchar(20) NOT NULL,
  `date` date NOT NULL,
  `description` varchar(500) NOT NULL,
  `follow_up_date` date NOT NULL,
  `note` text NOT NULL,
  `source` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `assigned` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `no_of_child` varchar(11) DEFAULT NULL,
  `status` varchar(100) NOT NULL,
  `created_by` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `assigned` (`assigned`),
  KEY `enquiry_ibfk_4` (`class_id`),
  CONSTRAINT `enquiry_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `enquiry_ibfk_3` FOREIGN KEY (`assigned`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `enquiry_ibfk_4` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enquiry`
--

LOCK TABLES `enquiry` WRITE;
/*!40000 ALTER TABLE `enquiry` DISABLE KEYS */;
/*!40000 ALTER TABLE `enquiry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enquiry_type`
--

DROP TABLE IF EXISTS `enquiry_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enquiry_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `enquiry_type` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enquiry_type`
--

LOCK TABLES `enquiry_type` WRITE;
/*!40000 ALTER TABLE `enquiry_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `enquiry_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrolment`
--

DROP TABLE IF EXISTS `enrolment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrolment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `class_id` int NOT NULL,
  `session_id` int NOT NULL,
  `enrolment_date` date NOT NULL,
  `enrolment_type` enum('Core','Elective') NOT NULL DEFAULT 'Core' COMMENT 'Core=main programme, Elective=from other programme',
  `status` enum('Active','Completed','Dropped','Suspended','Transferred','Withdrawn') NOT NULL DEFAULT 'Active',
  `completion_date` date DEFAULT NULL,
  `final_mark` decimal(5,2) DEFAULT NULL,
  `final_result` enum('Pass','Fail','Incomplete','Pending') DEFAULT 'Pending',
  `student_number` varchar(50) DEFAULT NULL COMMENT 'Optional student ref',
  `notes` text,
  `hostel_room_id` int DEFAULT NULL,
  `vehroute_id` int DEFAULT NULL,
  `route_pickup_point_id` int DEFAULT NULL,
  `transport_fees` decimal(10,2) DEFAULT NULL,
  `fees_discount` decimal(5,2) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_class` (`student_id`,`class_id`),
  KEY `idx_student` (`student_id`),
  KEY `idx_class` (`class_id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_status` (`status`),
  KEY `idx_enrolment_type` (`enrolment_type`),
  KEY `idx_hostel` (`hostel_room_id`),
  KEY `idx_route` (`vehroute_id`),
  CONSTRAINT `fk_unified_enrol_class` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_enrol_hostel` FOREIGN KEY (`hostel_room_id`) REFERENCES `hostel_rooms` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_enrol_route` FOREIGN KEY (`vehroute_id`) REFERENCES `transport_route` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_enrol_session` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_enrol_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrolment`
--

LOCK TABLES `enrolment` WRITE;
/*!40000 ALTER TABLE `enrolment` DISABLE KEYS */;
INSERT INTO `enrolment` VALUES (1,1,12,27,'2026-02-03','Core','Active',NULL,NULL,'Pending',NULL,NULL,NULL,NULL,NULL,0.00,0.00,1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(2,1,11,27,'2026-02-03','Core','Active',NULL,NULL,'Pending',NULL,NULL,NULL,NULL,NULL,0.00,0.00,1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(3,1,10,27,'2026-02-03','Core','Active',NULL,NULL,'Pending',NULL,NULL,NULL,NULL,NULL,0.00,0.00,1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(4,1,9,27,'2026-02-03','Core','Active',NULL,NULL,'Pending',NULL,NULL,NULL,NULL,NULL,0.00,0.00,1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(5,2,12,27,'2026-02-03','Core','Active',NULL,NULL,'Pending',NULL,NULL,NULL,NULL,NULL,0.00,0.00,1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(6,2,11,27,'2026-02-03','Core','Active',NULL,NULL,'Pending',NULL,NULL,NULL,NULL,NULL,0.00,0.00,1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(7,2,10,27,'2026-02-03','Core','Active',NULL,NULL,'Pending',NULL,NULL,NULL,NULL,NULL,0.00,0.00,1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(8,2,9,27,'2026-02-03','Core','Active',NULL,NULL,'Pending',NULL,NULL,NULL,NULL,NULL,0.00,0.00,1,'2026-02-03 16:14:53','2026-02-03 16:14:53');
/*!40000 ALTER TABLE `enrolment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event_title` varchar(200) NOT NULL,
  `event_description` text NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `event_type` varchar(100) NOT NULL,
  `event_color` varchar(200) NOT NULL,
  `event_for` varchar(100) NOT NULL,
  `role_id` int DEFAULT NULL,
  `is_active` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_group_class_batch_exam_students`
--

DROP TABLE IF EXISTS `exam_group_class_batch_exam_students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_group_class_batch_exam_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_class_batch_exam_id` int NOT NULL,
  `student_id` int NOT NULL,
  `student_session_id` int NOT NULL,
  `roll_no` int DEFAULT NULL,
  `teacher_remark` text,
  `rank` int NOT NULL DEFAULT '0',
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `exam_group_class_batch_exam_id` (`exam_group_class_batch_exam_id`),
  KEY `student_id` (`student_id`),
  KEY `student_session_id` (`student_session_id`),
  CONSTRAINT `exam_group_class_batch_exam_students_ibfk_1` FOREIGN KEY (`exam_group_class_batch_exam_id`) REFERENCES `exam_group_class_batch_exams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_group_class_batch_exam_students_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_group_class_batch_exam_students_ibfk_3` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_group_class_batch_exam_students`
--

LOCK TABLES `exam_group_class_batch_exam_students` WRITE;
/*!40000 ALTER TABLE `exam_group_class_batch_exam_students` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_group_class_batch_exam_students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_group_class_batch_exam_subjects`
--

DROP TABLE IF EXISTS `exam_group_class_batch_exam_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_group_class_batch_exam_subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_class_batch_exams_id` int DEFAULT NULL,
  `subject_id` int NOT NULL,
  `date_from` date NOT NULL,
  `time_from` time NOT NULL,
  `duration` varchar(50) NOT NULL,
  `room_no` varchar(100) DEFAULT NULL,
  `max_marks` float(10,2) DEFAULT NULL,
  `min_marks` float(10,2) DEFAULT NULL,
  `credit_hours` float(10,2) DEFAULT '0.00',
  `date_to` datetime DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `exam_group_class_batch_exams_id` (`exam_group_class_batch_exams_id`),
  KEY `subject_id` (`subject_id`),
  CONSTRAINT `exam_group_class_batch_exam_subjects_ibfk_1` FOREIGN KEY (`exam_group_class_batch_exams_id`) REFERENCES `exam_group_class_batch_exams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_group_class_batch_exam_subjects_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_group_class_batch_exam_subjects`
--

LOCK TABLES `exam_group_class_batch_exam_subjects` WRITE;
/*!40000 ALTER TABLE `exam_group_class_batch_exam_subjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_group_class_batch_exam_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_group_class_batch_exams`
--

DROP TABLE IF EXISTS `exam_group_class_batch_exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_group_class_batch_exams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam` varchar(250) DEFAULT NULL,
  `passing_percentage` float(10,2) DEFAULT NULL,
  `session_id` int NOT NULL,
  `date_from` date DEFAULT NULL,
  `date_to` date DEFAULT NULL,
  `exam_group_id` int DEFAULT NULL,
  `use_exam_roll_no` int NOT NULL DEFAULT '1',
  `is_publish` int DEFAULT '0',
  `is_rank_generated` int NOT NULL DEFAULT '0',
  `description` text,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `exam_group_id` (`exam_group_id`),
  KEY `exam_group_class_batch_exams_ibfk_2` (`session_id`),
  CONSTRAINT `exam_group_class_batch_exams_ibfk_1` FOREIGN KEY (`exam_group_id`) REFERENCES `exam_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_group_class_batch_exams_ibfk_2` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_group_class_batch_exams`
--

LOCK TABLES `exam_group_class_batch_exams` WRITE;
/*!40000 ALTER TABLE `exam_group_class_batch_exams` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_group_class_batch_exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_group_exam_connections`
--

DROP TABLE IF EXISTS `exam_group_exam_connections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_group_exam_connections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_id` int DEFAULT NULL,
  `exam_group_class_batch_exams_id` int DEFAULT NULL,
  `exam_weightage` float(10,2) DEFAULT '0.00',
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `exam_group_id` (`exam_group_id`),
  KEY `exam_group_class_batch_exams_id` (`exam_group_class_batch_exams_id`),
  CONSTRAINT `exam_group_exam_connections_ibfk_1` FOREIGN KEY (`exam_group_id`) REFERENCES `exam_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_group_exam_connections_ibfk_2` FOREIGN KEY (`exam_group_class_batch_exams_id`) REFERENCES `exam_group_class_batch_exams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_group_exam_connections`
--

LOCK TABLES `exam_group_exam_connections` WRITE;
/*!40000 ALTER TABLE `exam_group_exam_connections` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_group_exam_connections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_group_exam_results`
--

DROP TABLE IF EXISTS `exam_group_exam_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_group_exam_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_class_batch_exam_student_id` int NOT NULL,
  `exam_group_class_batch_exam_subject_id` int DEFAULT NULL,
  `exam_group_student_id` int DEFAULT NULL,
  `attendence` varchar(10) DEFAULT NULL,
  `get_marks` float(10,2) DEFAULT '0.00',
  `note` text,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `exam_group_class_batch_exam_subject_id` (`exam_group_class_batch_exam_subject_id`),
  KEY `exam_group_student_id` (`exam_group_student_id`),
  KEY `exam_group_class_batch_exam_student_id` (`exam_group_class_batch_exam_student_id`),
  CONSTRAINT `exam_group_exam_results_ibfk_1` FOREIGN KEY (`exam_group_class_batch_exam_subject_id`) REFERENCES `exam_group_class_batch_exam_subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_group_exam_results_ibfk_2` FOREIGN KEY (`exam_group_student_id`) REFERENCES `exam_group_students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_group_exam_results_ibfk_3` FOREIGN KEY (`exam_group_class_batch_exam_student_id`) REFERENCES `exam_group_class_batch_exam_students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_group_exam_results`
--

LOCK TABLES `exam_group_exam_results` WRITE;
/*!40000 ALTER TABLE `exam_group_exam_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_group_exam_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_group_students`
--

DROP TABLE IF EXISTS `exam_group_students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_group_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exam_group_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `exam_group_id` (`exam_group_id`),
  KEY `student_id` (`student_id`),
  KEY `student_session_id` (`student_session_id`),
  CONSTRAINT `exam_group_students_ibfk_1` FOREIGN KEY (`exam_group_id`) REFERENCES `exam_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_group_students_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_group_students_ibfk_3` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_group_students`
--

LOCK TABLES `exam_group_students` WRITE;
/*!40000 ALTER TABLE `exam_group_students` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_group_students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_groups`
--

DROP TABLE IF EXISTS `exam_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) DEFAULT NULL,
  `exam_type` varchar(250) DEFAULT NULL,
  `description` text,
  `is_active` int DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_groups`
--

LOCK TABLES `exam_groups` WRITE;
/*!40000 ALTER TABLE `exam_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_moderation_comments`
--

DROP TABLE IF EXISTS `exam_moderation_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_moderation_comments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `exam_id` int NOT NULL,
  `moderator_staff_id` int NOT NULL,
  `question_id` int DEFAULT NULL,
  `comment` text NOT NULL,
  `action` enum('approve','reject','comment') NOT NULL DEFAULT 'comment',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_exam_id` (`exam_id`),
  KEY `idx_moderator` (`moderator_staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_moderation_comments`
--

LOCK TABLES `exam_moderation_comments` WRITE;
/*!40000 ALTER TABLE `exam_moderation_comments` DISABLE KEYS */;
INSERT INTO `exam_moderation_comments` VALUES (1,9004,3,NULL,'The exam needs more clarity in the instructions. Please revise the description.','reject','2026-01-27 17:08:01'),(2,9004,3,9001,'This question is too easy. Consider a more challenging question.','comment','2026-01-27 17:08:01'),(3,9004,3,9004,'Good descriptive question! Increase the word limit.','comment','2026-01-27 17:08:01'),(4,9003,3,NULL,'Excellent exam structure! Questions are well-balanced. Approved for publication.','approve','2026-01-28 17:08:01'),(5,9005,3,NULL,'no questions','reject','2026-01-29 17:30:21'),(6,9006,3,24,'this is not good','comment','2026-01-29 18:03:02'),(7,9007,3,NULL,'No questions please add','reject','2026-02-01 07:30:57');
/*!40000 ALTER TABLE `exam_moderation_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exam_schedules`
--

DROP TABLE IF EXISTS `exam_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exam_schedules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `exam_id` int DEFAULT NULL,
  `teacher_subject_id` int DEFAULT NULL,
  `date_of_exam` date DEFAULT NULL,
  `start_to` varchar(50) DEFAULT NULL,
  `end_from` varchar(50) DEFAULT NULL,
  `room_no` varchar(50) DEFAULT NULL,
  `full_marks` int DEFAULT NULL,
  `passing_marks` int DEFAULT NULL,
  `note` text,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `teacher_subject_id` (`teacher_subject_id`),
  KEY `session_id` (`session_id`),
  KEY `exam_id` (`exam_id`),
  CONSTRAINT `exam_schedules_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `exam_schedules_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exam_schedules`
--

LOCK TABLES `exam_schedules` WRITE;
/*!40000 ALTER TABLE `exam_schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `exam_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exams`
--

DROP TABLE IF EXISTS `exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exams` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `sesion_id` int NOT NULL,
  `note` text,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `sesion_id` (`sesion_id`),
  CONSTRAINT `exams_ibfk_1` FOREIGN KEY (`sesion_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exams`
--

LOCK TABLES `exams` WRITE;
/*!40000 ALTER TABLE `exams` DISABLE KEYS */;
/*!40000 ALTER TABLE `exams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expense_head`
--

DROP TABLE IF EXISTS `expense_head`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exp_category` varchar(50) DEFAULT NULL,
  `description` text,
  `is_active` varchar(255) DEFAULT 'yes',
  `is_deleted` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense_head`
--

LOCK TABLES `expense_head` WRITE;
/*!40000 ALTER TABLE `expense_head` DISABLE KEYS */;
/*!40000 ALTER TABLE `expense_head` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exp_head_id` int DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `invoice_no` varchar(200) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `amount` float(10,2) DEFAULT NULL,
  `documents` varchar(255) DEFAULT NULL,
  `note` text,
  `is_active` varchar(255) DEFAULT 'yes',
  `is_deleted` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `exp_head_id` (`exp_head_id`),
  CONSTRAINT `expenses_ibfk_1` FOREIGN KEY (`exp_head_id`) REFERENCES `expense_head` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_groups`
--

DROP TABLE IF EXISTS `fee_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `is_system` int NOT NULL DEFAULT '0',
  `description` text,
  `nature` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_groups`
--

LOCK TABLES `fee_groups` WRITE;
/*!40000 ALTER TABLE `fee_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `fee_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_groups_feetype`
--

DROP TABLE IF EXISTS `fee_groups_feetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_groups_feetype` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fee_session_group_id` int DEFAULT NULL,
  `fee_groups_id` int DEFAULT NULL,
  `feetype_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `fine_type` varchar(50) NOT NULL DEFAULT 'none',
  `due_date` date DEFAULT NULL,
  `fine_percentage` float(10,2) NOT NULL DEFAULT '0.00',
  `fine_amount` float(10,2) NOT NULL DEFAULT '0.00',
  `fine_per_day` int NOT NULL DEFAULT '0',
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fee_session_group_id` (`fee_session_group_id`),
  KEY `fee_groups_id` (`fee_groups_id`),
  KEY `feetype_id` (`feetype_id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `fee_groups_feetype_ibfk_1` FOREIGN KEY (`fee_session_group_id`) REFERENCES `fee_session_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fee_groups_feetype_ibfk_2` FOREIGN KEY (`fee_groups_id`) REFERENCES `fee_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fee_groups_feetype_ibfk_3` FOREIGN KEY (`feetype_id`) REFERENCES `feetype` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fee_groups_feetype_ibfk_4` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_groups_feetype`
--

LOCK TABLES `fee_groups_feetype` WRITE;
/*!40000 ALTER TABLE `fee_groups_feetype` DISABLE KEYS */;
/*!40000 ALTER TABLE `fee_groups_feetype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_receipt_no`
--

DROP TABLE IF EXISTS `fee_receipt_no`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_receipt_no` (
  `id` int NOT NULL AUTO_INCREMENT,
  `payment` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_receipt_no`
--

LOCK TABLES `fee_receipt_no` WRITE;
/*!40000 ALTER TABLE `fee_receipt_no` DISABLE KEYS */;
/*!40000 ALTER TABLE `fee_receipt_no` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_session_groups`
--

DROP TABLE IF EXISTS `fee_session_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_session_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fee_groups_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fee_groups_id` (`fee_groups_id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `fee_session_groups_ibfk_1` FOREIGN KEY (`fee_groups_id`) REFERENCES `fee_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fee_session_groups_ibfk_2` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_session_groups`
--

LOCK TABLES `fee_session_groups` WRITE;
/*!40000 ALTER TABLE `fee_session_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `fee_session_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feemasters`
--

DROP TABLE IF EXISTS `feemasters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feemasters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `feetype_id` int NOT NULL,
  `class_id` int DEFAULT NULL,
  `amount` float(10,2) DEFAULT NULL,
  `description` text,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  KEY `feetype_id` (`feetype_id`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `feemasters_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `feemasters_ibfk_2` FOREIGN KEY (`feetype_id`) REFERENCES `feetype` (`id`) ON DELETE CASCADE,
  CONSTRAINT `feemasters_ibfk_3` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feemasters`
--

LOCK TABLES `feemasters` WRITE;
/*!40000 ALTER TABLE `feemasters` DISABLE KEYS */;
/*!40000 ALTER TABLE `feemasters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fees_discounts`
--

DROP TABLE IF EXISTS `fees_discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fees_discounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `code` varchar(100) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `percentage` float(10,2) DEFAULT NULL,
  `amount` float(10,2) DEFAULT NULL,
  `discount_limit` int DEFAULT NULL,
  `expire_date` date DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `fees_discounts_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fees_discounts`
--

LOCK TABLES `fees_discounts` WRITE;
/*!40000 ALTER TABLE `fees_discounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `fees_discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fees_reminder`
--

DROP TABLE IF EXISTS `fees_reminder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fees_reminder` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reminder_type` varchar(10) DEFAULT NULL,
  `day` int DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fees_reminder`
--

LOCK TABLES `fees_reminder` WRITE;
/*!40000 ALTER TABLE `fees_reminder` DISABLE KEYS */;
INSERT INTO `fees_reminder` VALUES (1,'before',2,0,'2020-02-28 13:38:32',NULL),(2,'before',5,0,'2020-02-28 13:38:36',NULL),(3,'after',2,0,'2020-02-28 13:38:40',NULL),(4,'after',5,0,'2020-02-28 13:38:44',NULL);
/*!40000 ALTER TABLE `fees_reminder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feetype`
--

DROP TABLE IF EXISTS `feetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feetype` (
  `id` int NOT NULL AUTO_INCREMENT,
  `is_system` int NOT NULL DEFAULT '0',
  `feecategory_id` int DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `code` varchar(100) NOT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `description` text,
  `session_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `nature` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feetype`
--

LOCK TABLES `feetype` WRITE;
/*!40000 ALTER TABLE `feetype` DISABLE KEYS */;
/*!40000 ALTER TABLE `feetype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filetypes`
--

DROP TABLE IF EXISTS `filetypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `filetypes` (
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
-- Dumping data for table `filetypes`
--

LOCK TABLES `filetypes` WRITE;
/*!40000 ALTER TABLE `filetypes` DISABLE KEYS */;
INSERT INTO `filetypes` VALUES (1,'pdf, zip, jpg, jpeg, png, txt, 7z, gif, csv, docx, mp3, mp4, accdb, odt, ods, ppt, pptx, xlsx, wmv, jfif, apk, ppt, bmp, jpe, mdb, rar, xls, svg, scorm','application/pdf, image/zip, image/jpg, image/png, image/jpeg, text/plain, application/x-zip-compressed, application/zip, image/gif, text/csv, application/vnd.openxmlformats-officedocument.wordprocessingml.document, audio/mpeg, application/msaccess, application/vnd.oasis.opendocument.text, application/vnd.oasis.opendocument.spreadsheet, application/vnd.ms-powerpoint, application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, video/x-ms-wmv, video/mp4, image/jpeg, application/vnd.android.package-archive, application/x-msdownload, application/vnd.ms-powerpoint, image/bmp, image/jpeg, application/msaccess, application/vnd.ms-excel, image/svg+xml, application/x-zip, multipart/x-zip, application/s-compressed, application/octet-stream, application/x-rar-compressed, application/x-7z-compressed, application/gzip',100048576,'jfif, png, jpe, jpeg, jpg, bmp, gif, svg','image/jpeg, image/png, image/jpeg, image/jpeg, image/bmp, image/gif, image/x-ms-bmp, image/svg+xml',10048576,'2021-01-30 13:03:03','2026-01-29 16:24:46');
/*!40000 ALTER TABLE `filetypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follow_up`
--

DROP TABLE IF EXISTS `follow_up`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follow_up` (
  `id` int NOT NULL AUTO_INCREMENT,
  `enquiry_id` int NOT NULL,
  `date` date NOT NULL,
  `next_date` date NOT NULL,
  `response` text NOT NULL,
  `note` text NOT NULL,
  `followup_by` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `enquiry_id` (`enquiry_id`),
  KEY `followup_by` (`followup_by`),
  CONSTRAINT `follow_up_ibfk_1` FOREIGN KEY (`enquiry_id`) REFERENCES `enquiry` (`id`) ON DELETE CASCADE,
  CONSTRAINT `follow_up_ibfk_2` FOREIGN KEY (`followup_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follow_up`
--

LOCK TABLES `follow_up` WRITE;
/*!40000 ALTER TABLE `follow_up` DISABLE KEYS */;
/*!40000 ALTER TABLE `follow_up` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `front_cms_media_gallery`
--

DROP TABLE IF EXISTS `front_cms_media_gallery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `front_cms_media_gallery` (
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
-- Dumping data for table `front_cms_media_gallery`
--

LOCK TABLES `front_cms_media_gallery` WRITE;
/*!40000 ALTER TABLE `front_cms_media_gallery` DISABLE KEYS */;
/*!40000 ALTER TABLE `front_cms_media_gallery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `front_cms_menu_items`
--

DROP TABLE IF EXISTS `front_cms_menu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `front_cms_menu_items` (
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
  PRIMARY KEY (`id`),
  KEY `menu_id` (`menu_id`),
  CONSTRAINT `front_cms_menu_items_ibfk_1` FOREIGN KEY (`menu_id`) REFERENCES `front_cms_menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `front_cms_menu_items`
--

LOCK TABLES `front_cms_menu_items` WRITE;
/*!40000 ALTER TABLE `front_cms_menu_items` DISABLE KEYS */;
INSERT INTO `front_cms_menu_items` VALUES (1,1,'Home',1,0,NULL,NULL,NULL,'home',1,0,NULL,'no','2019-12-02 22:11:50','2026-01-29 12:14:53'),(2,1,'Contact Us',76,0,NULL,NULL,NULL,'contact-us',4,0,NULL,'no','2019-12-02 22:11:52','2026-01-29 12:14:53'),(3,1,'Complain',2,0,NULL,NULL,NULL,'complain',3,0,NULL,'no','2019-12-02 22:11:52','2026-01-29 12:14:53'),(4,1,'Online Admission',0,0,'1',NULL,'http://yourschoolurl.com/online_admission','admssion',2,0,NULL,'no','2019-12-21 15:33:00','2026-01-29 12:14:53');
/*!40000 ALTER TABLE `front_cms_menu_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `front_cms_menus`
--

DROP TABLE IF EXISTS `front_cms_menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `front_cms_menus` (
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
-- Dumping data for table `front_cms_menus`
--

LOCK TABLES `front_cms_menus` WRITE;
/*!40000 ALTER TABLE `front_cms_menus` DISABLE KEYS */;
INSERT INTO `front_cms_menus` VALUES (1,'Main Menu','main-menu','Main menu',0,'','',0,'default','no','2018-04-20 14:54:49','2026-01-29 12:14:53'),(2,'Bottom Menu','bottom-menu','Bottom Menu',0,'','',0,'default','no','2018-04-20 14:54:55','2026-01-29 12:14:53');
/*!40000 ALTER TABLE `front_cms_menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `front_cms_page_contents`
--

DROP TABLE IF EXISTS `front_cms_page_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `front_cms_page_contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `page_id` int DEFAULT NULL,
  `content_type` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `page_id` (`page_id`),
  CONSTRAINT `front_cms_page_contents_ibfk_1` FOREIGN KEY (`page_id`) REFERENCES `front_cms_pages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `front_cms_page_contents`
--

LOCK TABLES `front_cms_page_contents` WRITE;
/*!40000 ALTER TABLE `front_cms_page_contents` DISABLE KEYS */;
/*!40000 ALTER TABLE `front_cms_page_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `front_cms_pages`
--

DROP TABLE IF EXISTS `front_cms_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `front_cms_pages` (
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
-- Dumping data for table `front_cms_pages`
--

LOCK TABLES `front_cms_pages` WRITE;
/*!40000 ALTER TABLE `front_cms_pages` DISABLE KEYS */;
INSERT INTO `front_cms_pages` VALUES (1,'default',1,'Home','page/home','page','home','','','','','<p>home page</p>','0000-00-00',1,NULL,'no','2019-12-02 15:23:47','2026-01-29 12:14:53'),(2,'default',0,'Complain','page/complain','page','complain','Complain form','                                                                                                                                                                                    complain form                                                                                                                                                                                                                                ','complain form','','<p>[form-builder:complain]</p>','0000-00-00',1,NULL,'no','2019-11-13 10:16:36','2026-01-29 12:14:53'),(3,'default',0,'404 page','page/404-page','page','404-page','','                                ','','','<html>\r\n<head>\r\n <title></title>\r\n</head>\r\n<body>\r\n<p>404 page found</p>\r\n</body>\r\n</html>','0000-00-00',0,NULL,'no','2018-05-18 14:46:04','2026-01-29 12:14:53'),(4,'default',0,'Contact us','page/contact-us','page','contact-us','','','','','<section class=\"contact\">\r\n<div class=\"container\">\r\n<div class=\"row\">\r\n<h2 class=\"col-md-12 col-sm-12\">Send In Your Query</h2>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<div class=\"col-md-12 col-sm-12\">[form-builder:contact_us]<!--./row--></div>\r\n<!--./col-md-12--></div>\r\n<!--./row--></div>\r\n<!--./container--></section>\r\n\r\n<div class=\"col-md-4 col-sm-4\">\r\n<div class=\"contact-item\"><img src=\"http://192.168.1.81/repos/smartschool/uploads/gallery/media/pin.svg\" />\r\n<h3>Our Location</h3>\r\n\r\n<p>350 Fifth Avenue, 34th floor New York NY 10118-3299 USA</p>\r\n</div>\r\n<!--./contact-item--></div>\r\n<!--./col-md-4-->\r\n\r\n<div class=\"col-md-4 col-sm-4\">\r\n<div class=\"contact-item\"><img src=\"http://192.168.1.81/repos/smartschool/uploads/gallery/media/phone.svg\" />\r\n<h3>CALL US</h3>\r\n\r\n<p>E-mail : info@abcschool.com</p>\r\n\r\n<p>Mobile : +91-9009987654</p>\r\n</div>\r\n<!--./contact-item--></div>\r\n<!--./col-md-4-->\r\n\r\n<div class=\"col-md-4 col-sm-4\">\r\n<div class=\"contact-item\"><img src=\"http://192.168.1.81/repos/smartschool/uploads/gallery/media/clock.svg\" />\r\n<h3>Working Hours</h3>\r\n\r\n<p>Mon-Fri : 9 am to 5 pm</p>\r\n\r\n<p>Sat : 9 am to 3 pm</p>\r\n</div>\r\n<!--./contact-item--></div>\r\n<!--./col-md-4-->\r\n\r\n<div class=\"col-md-12 col-sm-12\">\r\n<div class=\"mapWrapper fullwidth\"><iframe frameborder=\"0\" height=\"500\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"no\" src=\"http://maps.google.com/maps?f=q&source=s_q&hl=EN&q=time+square&aq=&sll=40.716558,-73.931122&sspn=0.40438,1.056747&ie=UTF8&rq=1&ev=p&split=1&radius=33.22&hq=time+square&hnear=&ll=37.061753,-95.677185&spn=0.438347,0.769043&z=9&output=embed\" width=\"100%\"></iframe></div>\r\n</div>','0000-00-00',0,NULL,'no','2019-05-04 15:46:41','2026-01-29 12:14:53');
/*!40000 ALTER TABLE `front_cms_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `front_cms_program_photos`
--

DROP TABLE IF EXISTS `front_cms_program_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `front_cms_program_photos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `media_gallery_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `program_id` (`program_id`),
  CONSTRAINT `front_cms_program_photos_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `front_cms_programs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `front_cms_program_photos`
--

LOCK TABLES `front_cms_program_photos` WRITE;
/*!40000 ALTER TABLE `front_cms_program_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `front_cms_program_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `front_cms_programs`
--

DROP TABLE IF EXISTS `front_cms_programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `front_cms_programs` (
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
-- Dumping data for table `front_cms_programs`
--

LOCK TABLES `front_cms_programs` WRITE;
/*!40000 ALTER TABLE `front_cms_programs` DISABLE KEYS */;
/*!40000 ALTER TABLE `front_cms_programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `front_cms_settings`
--

DROP TABLE IF EXISTS `front_cms_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `front_cms_settings` (
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
-- Dumping data for table `front_cms_settings`
--

LOCK TABLES `front_cms_settings` WRITE;
/*!40000 ALTER TABLE `front_cms_settings` DISABLE KEYS */;
INSERT INTO `front_cms_settings` VALUES (1,'material_pink',NULL,NULL,NULL,'./uploads/school_content/logo/1672900975-128524590063b6716fc26ed!front_logo-608ff44a5f8f07.35255544.png','','','[]','','','','','','','','','','','','./uploads/school_content/logo/1672900975-63781378463b6716fc2886!front_fav_icon-608ff44a5fdb33.94953981.png','2023-01-05 06:42:55','2026-01-29 12:14:53');
/*!40000 ALTER TABLE `front_cms_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gateway_ins`
--

DROP TABLE IF EXISTS `gateway_ins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gateway_ins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `online_admission_id` int DEFAULT NULL,
  `gateway_name` varchar(50) NOT NULL,
  `module_type` varchar(255) NOT NULL,
  `unique_id` varchar(255) NOT NULL,
  `parameter_details` mediumtext NOT NULL,
  `payment_status` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `online_admission_id` (`online_admission_id`),
  CONSTRAINT `gateway_ins_ibfk_1` FOREIGN KEY (`online_admission_id`) REFERENCES `online_admissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gateway_ins`
--

LOCK TABLES `gateway_ins` WRITE;
/*!40000 ALTER TABLE `gateway_ins` DISABLE KEYS */;
/*!40000 ALTER TABLE `gateway_ins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gateway_ins_response`
--

DROP TABLE IF EXISTS `gateway_ins_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gateway_ins_response` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gateway_ins_id` int DEFAULT NULL,
  `posted_data` text,
  `response` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `gateway_ins_id` (`gateway_ins_id`),
  CONSTRAINT `gateway_ins_response_ibfk_1` FOREIGN KEY (`gateway_ins_id`) REFERENCES `gateway_ins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gateway_ins_response`
--

LOCK TABLES `gateway_ins_response` WRITE;
/*!40000 ALTER TABLE `gateway_ins_response` DISABLE KEYS */;
/*!40000 ALTER TABLE `gateway_ins_response` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `general_calls`
--

DROP TABLE IF EXISTS `general_calls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `general_calls` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `contact` varchar(12) NOT NULL,
  `date` date NOT NULL,
  `description` varchar(500) NOT NULL,
  `follow_up_date` date NOT NULL,
  `call_duration` varchar(50) NOT NULL,
  `note` text NOT NULL,
  `call_type` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `general_calls`
--

LOCK TABLES `general_calls` WRITE;
/*!40000 ALTER TABLE `general_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `general_calls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `grades`
--

DROP TABLE IF EXISTS `grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `grades` (
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `grades`
--

LOCK TABLES `grades` WRITE;
/*!40000 ALTER TABLE `grades` DISABLE KEYS */;
/*!40000 ALTER TABLE `grades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `holiday_type`
--

DROP TABLE IF EXISTS `holiday_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `holiday_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `is_default` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `holiday_type`
--

LOCK TABLES `holiday_type` WRITE;
/*!40000 ALTER TABLE `holiday_type` DISABLE KEYS */;
INSERT INTO `holiday_type` VALUES (1,'Holiday',1),(2,'Vacation',1),(3,'Activity',1);
/*!40000 ALTER TABLE `holiday_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `homework`
--

DROP TABLE IF EXISTS `homework`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homework` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `subject_group_subject_id` (`subject_group_subject_id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`),
  KEY `session_id` (`session_id`),
  KEY `staff_id` (`staff_id`),
  KEY `subject_id` (`subject_id`),
  KEY `evaluated_by` (`evaluated_by`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `homework_ibfk_1` FOREIGN KEY (`subject_group_subject_id`) REFERENCES `subject_group_subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `homework_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `homework_ibfk_3` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `homework_ibfk_4` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `homework_ibfk_5` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `homework_ibfk_6` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `homework_ibfk_7` FOREIGN KEY (`evaluated_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `homework_ibfk_8` FOREIGN KEY (`created_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homework`
--

LOCK TABLES `homework` WRITE;
/*!40000 ALTER TABLE `homework` DISABLE KEYS */;
/*!40000 ALTER TABLE `homework` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `homework_evaluation`
--

DROP TABLE IF EXISTS `homework_evaluation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homework_evaluation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `homework_id` int NOT NULL,
  `student_id` int NOT NULL,
  `student_session_id` int DEFAULT NULL,
  `marks` float(10,2) DEFAULT NULL,
  `note` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `status` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `homework_id` (`homework_id`),
  KEY `student_id` (`student_id`),
  KEY `student_session_id` (`student_session_id`),
  CONSTRAINT `homework_evaluation_ibfk_1` FOREIGN KEY (`homework_id`) REFERENCES `homework` (`id`) ON DELETE CASCADE,
  CONSTRAINT `homework_evaluation_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `homework_evaluation_ibfk_3` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homework_evaluation`
--

LOCK TABLES `homework_evaluation` WRITE;
/*!40000 ALTER TABLE `homework_evaluation` DISABLE KEYS */;
/*!40000 ALTER TABLE `homework_evaluation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hostel`
--

DROP TABLE IF EXISTS `hostel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hostel` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hostel_name` varchar(100) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `address` text,
  `intake` int DEFAULT NULL,
  `description` text,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostel`
--

LOCK TABLES `hostel` WRITE;
/*!40000 ALTER TABLE `hostel` DISABLE KEYS */;
/*!40000 ALTER TABLE `hostel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hostel_rooms`
--

DROP TABLE IF EXISTS `hostel_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hostel_rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hostel_id` int DEFAULT NULL,
  `room_type_id` int DEFAULT NULL,
  `room_no` varchar(200) DEFAULT NULL,
  `no_of_bed` int DEFAULT NULL,
  `cost_per_bed` float(10,2) DEFAULT '0.00',
  `title` varchar(200) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `hostel_id` (`hostel_id`),
  KEY `room_type_id` (`room_type_id`),
  CONSTRAINT `hostel_rooms_ibfk_1` FOREIGN KEY (`hostel_id`) REFERENCES `hostel` (`id`) ON DELETE CASCADE,
  CONSTRAINT `hostel_rooms_ibfk_2` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hostel_rooms`
--

LOCK TABLES `hostel_rooms` WRITE;
/*!40000 ALTER TABLE `hostel_rooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `hostel_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `id_card`
--

DROP TABLE IF EXISTS `id_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `id_card` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `school_name` varchar(100) NOT NULL,
  `school_address` varchar(500) NOT NULL,
  `background` varchar(100) NOT NULL,
  `logo` varchar(100) NOT NULL,
  `sign_image` varchar(100) NOT NULL,
  `enable_vertical_card` int NOT NULL DEFAULT '0',
  `header_color` varchar(100) NOT NULL,
  `enable_admission_no` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_student_name` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_class` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_fathers_name` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_mothers_name` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_address` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_phone` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_dob` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_blood_group` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_student_barcode` tinyint NOT NULL DEFAULT '1' COMMENT '0=disable,1=enable',
  `enable_student_rollno` tinyint(1) NOT NULL COMMENT '0=disable,1=enable	',
  `enable_student_house_name` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0=disable,1=enable	',
  `status` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `id_card`
--

LOCK TABLES `id_card` WRITE;
/*!40000 ALTER TABLE `id_card` DISABLE KEYS */;
INSERT INTO `id_card` VALUES (1,'Sample Student Identity Card Horizontal','Mount Carmel School','110 Kings Street, CA  Phone: 456542 Email: mount@gmail.com','samplebackground12.png','samplelogo12.png','samplesign12.png',0,'#595959',1,1,1,1,0,1,1,1,1,1,0,0,1,'2026-01-29 12:14:53','2026-01-29 12:14:53'),(2,'Sample Student Identity Card Vertical','Mount Carmel School','110 Kings Street, CA  Phone: 456542 Email: mount@gmail.com','samplebackground12.png','samplelogo12.png','samplesign12.png',1,'#595959',1,1,1,1,0,1,1,1,1,1,0,0,1,'2026-01-29 12:14:53','2026-01-29 12:14:53');
/*!40000 ALTER TABLE `id_card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `income`
--

DROP TABLE IF EXISTS `income`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `income` (
  `id` int NOT NULL AUTO_INCREMENT,
  `income_head_id` int DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `invoice_no` varchar(200) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `amount` float(10,2) DEFAULT '0.00',
  `note` text,
  `is_active` varchar(255) DEFAULT 'yes',
  `documents` varchar(255) DEFAULT NULL,
  `is_deleted` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `income_head_id` (`income_head_id`),
  CONSTRAINT `income_ibfk_1` FOREIGN KEY (`income_head_id`) REFERENCES `income_head` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `income`
--

LOCK TABLES `income` WRITE;
/*!40000 ALTER TABLE `income` DISABLE KEYS */;
/*!40000 ALTER TABLE `income` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `income_head`
--

DROP TABLE IF EXISTS `income_head`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `income_head` (
  `id` int NOT NULL AUTO_INCREMENT,
  `income_category` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_active` varchar(255) NOT NULL DEFAULT 'yes',
  `is_deleted` varchar(255) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `income_head`
--

LOCK TABLES `income_head` WRITE;
/*!40000 ALTER TABLE `income_head` DISABLE KEYS */;
/*!40000 ALTER TABLE `income_head` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_category_id` int DEFAULT NULL,
  `item_store_id` int DEFAULT NULL,
  `item_supplier_id` int DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `unit` varchar(100) NOT NULL,
  `item_photo` varchar(225) DEFAULT NULL,
  `description` text NOT NULL,
  `quantity` int NOT NULL,
  `date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `item_category_id` (`item_category_id`),
  KEY `item_store_id` (`item_store_id`),
  KEY `item_supplier_id` (`item_supplier_id`),
  CONSTRAINT `item_ibfk_1` FOREIGN KEY (`item_category_id`) REFERENCES `item_category` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_ibfk_2` FOREIGN KEY (`item_store_id`) REFERENCES `item_store` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_ibfk_3` FOREIGN KEY (`item_supplier_id`) REFERENCES `item_supplier` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_category`
--

DROP TABLE IF EXISTS `item_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_category` (
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
-- Dumping data for table `item_category`
--

LOCK TABLES `item_category` WRITE;
/*!40000 ALTER TABLE `item_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_issue`
--

DROP TABLE IF EXISTS `item_issue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_issue` (
  `id` int NOT NULL AUTO_INCREMENT,
  `issue_type` varchar(15) DEFAULT NULL,
  `issue_to` int NOT NULL,
  `issue_by` int DEFAULT NULL,
  `issue_date` date DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `item_category_id` int DEFAULT NULL,
  `item_id` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `note` text NOT NULL,
  `is_returned` int NOT NULL DEFAULT '1',
  `is_active` varchar(10) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `item_category_id` (`item_category_id`),
  KEY `issue_to` (`issue_to`),
  KEY `issue_by` (`issue_by`),
  CONSTRAINT `item_issue_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_issue_ibfk_2` FOREIGN KEY (`item_category_id`) REFERENCES `item_category` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_issue_ibfk_3` FOREIGN KEY (`issue_to`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_issue_ibfk_4` FOREIGN KEY (`issue_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_issue`
--

LOCK TABLES `item_issue` WRITE;
/*!40000 ALTER TABLE `item_issue` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_issue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_stock`
--

DROP TABLE IF EXISTS `item_stock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_stock` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_id` int DEFAULT NULL,
  `supplier_id` int DEFAULT NULL,
  `store_id` int DEFAULT NULL,
  `symbol` varchar(10) NOT NULL DEFAULT '+',
  `quantity` int DEFAULT NULL,
  `purchase_price` float(10,2) NOT NULL,
  `date` date NOT NULL,
  `attachment` varchar(250) DEFAULT NULL,
  `description` text NOT NULL,
  `is_active` varchar(10) DEFAULT 'yes',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `store_id` (`store_id`),
  CONSTRAINT `item_stock_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_stock_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `item_supplier` (`id`) ON DELETE CASCADE,
  CONSTRAINT `item_stock_ibfk_3` FOREIGN KEY (`store_id`) REFERENCES `item_store` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_stock`
--

LOCK TABLES `item_stock` WRITE;
/*!40000 ALTER TABLE `item_stock` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_stock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_store`
--

DROP TABLE IF EXISTS `item_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_store` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_store` varchar(255) NOT NULL,
  `code` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_store`
--

LOCK TABLES `item_store` WRITE;
/*!40000 ALTER TABLE `item_store` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item_supplier`
--

DROP TABLE IF EXISTS `item_supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item_supplier` (
  `id` int NOT NULL AUTO_INCREMENT,
  `item_supplier` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `contact_person_name` varchar(255) NOT NULL,
  `contact_person_phone` varchar(255) NOT NULL,
  `contact_person_email` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item_supplier`
--

LOCK TABLES `item_supplier` WRITE;
/*!40000 ALTER TABLE `item_supplier` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `languages` (
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
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `languages`
--

LOCK TABLES `languages` WRITE;
/*!40000 ALTER TABLE `languages` DISABLE KEYS */;
INSERT INTO `languages` VALUES (1,'Azerbaijan','az','az',0,'no','no','2019-11-20 11:23:12','0000-00-00 00:00:00'),(2,'Albanian','sq','al',0,'no','no','2019-11-20 11:42:42','0000-00-00 00:00:00'),(3,'Amharic','am','am',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(4,'English','en','us',0,'no','no','2019-11-20 11:38:50','0000-00-00 00:00:00'),(5,'Arabic','ar','sa',0,'no','no','2019-11-20 11:47:28','0000-00-00 00:00:00'),(7,'Afrikaans','af','af',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(8,'Basque','eu','es',0,'no','no','2019-11-20 11:54:10','0000-00-00 00:00:00'),(11,'Bengali','bn','in',0,'no','no','2019-11-20 11:41:53','0000-00-00 00:00:00'),(13,'Bosnian','bs','bs',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(14,'Welsh','cy','cy',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(15,'Hungarian','hu','hu',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(16,'Vietnamese','vi','vi',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(17,'Haitian','ht','ht',0,'no','no','2021-01-23 07:09:32','0000-00-00 00:00:00'),(18,'Galician','gl','gl',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(19,'Dutch','nl','nl',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(21,'Greek','el','gr',0,'no','no','2019-11-20 12:12:08','0000-00-00 00:00:00'),(22,'Georgian','ka','ge',0,'no','no','2019-11-20 12:11:40','0000-00-00 00:00:00'),(23,'Gujarati','gu','in',0,'no','no','2019-11-20 11:39:16','0000-00-00 00:00:00'),(24,'Danish','da','dk',0,'no','no','2019-11-20 12:03:25','0000-00-00 00:00:00'),(25,'Hebrew','he','il',0,'no','no','2019-11-20 12:13:50','0000-00-00 00:00:00'),(26,'Yiddish','yi','il',0,'no','no','2019-11-20 12:25:33','0000-00-00 00:00:00'),(27,'Indonesian','id','id',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(28,'Irish','ga','ga',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(29,'Italian','it','it',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(30,'Icelandic','is','is',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(31,'Spanish','es','es',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(33,'Kannada','kn','kn',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(34,'Catalan','ca','ca',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(36,'Chinese','zh','cn',0,'no','no','2019-11-20 12:01:48','0000-00-00 00:00:00'),(37,'Korean','ko','kr',0,'no','no','2019-11-20 12:19:09','0000-00-00 00:00:00'),(38,'Xhosa','xh','ls',0,'no','no','2019-11-20 12:24:39','0000-00-00 00:00:00'),(39,'Latin','la','it',0,'no','no','2021-01-23 07:09:32','0000-00-00 00:00:00'),(40,'Latvian','lv','lv',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(41,'Lithuanian','lt','lt',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(43,'Malagasy','mg','mg',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(44,'Malay','ms','ms',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(45,'Malayalam','ml','ml',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(46,'Maltese','mt','mt',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(47,'Macedonian','mk','mk',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(48,'Maori','mi','nz',0,'no','no','2019-11-20 12:20:27','0000-00-00 00:00:00'),(49,'Marathi','mr','in',0,'no','no','2019-11-20 11:39:51','0000-00-00 00:00:00'),(51,'Mongolian','mn','mn',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(52,'German','de','de',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(53,'Nepali','ne','ne',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(54,'Norwegian','no','no',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(55,'Punjabi','pa','in',0,'no','no','2019-11-20 11:40:16','0000-00-00 00:00:00'),(57,'Persian','fa','ir',0,'no','no','2019-11-20 12:21:17','0000-00-00 00:00:00'),(59,'Portuguese','pt','pt',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(60,'Romanian','ro','ro',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(61,'Russian','ru','ru',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(62,'Cebuano','ceb','ph',0,'no','no','2019-11-20 11:59:12','0000-00-00 00:00:00'),(64,'Sinhala','si','lk ',0,'no','no','2021-01-23 07:09:32','0000-00-00 00:00:00'),(65,'Slovakian','sk','sk',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(66,'Slovenian','sl','sl',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(67,'Swahili','sw','ke',0,'no','no','2019-11-20 12:21:57','0000-00-00 00:00:00'),(68,'Sundanese','su','sd',0,'no','no','2019-12-03 11:06:57','0000-00-00 00:00:00'),(70,'Thai','th','th',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(71,'Tagalog','tl','tl',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(72,'Tamil','ta','in',0,'no','no','2019-11-20 11:40:53','0000-00-00 00:00:00'),(74,'Telugu','te','in',0,'no','no','2019-11-20 11:41:15','0000-00-00 00:00:00'),(75,'Turkish','tr','tr',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(77,'Uzbek','uz','uz',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(79,'Urdu','ur','pk',0,'no','no','2019-11-20 12:23:57','0000-00-00 00:00:00'),(80,'Finnish','fi','fi',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(81,'French','fr','fr',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(82,'Hindi','hi','in',0,'no','no','2019-11-20 11:36:34','0000-00-00 00:00:00'),(84,'Czech','cs','cz',0,'no','no','2019-11-20 12:02:36','0000-00-00 00:00:00'),(85,'Swedish','sv','sv',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(86,'Scottish','gd','gd',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(87,'Estonian','et','et',0,'no','no','2019-11-20 11:24:23','0000-00-00 00:00:00'),(88,'Esperanto','eo','br',0,'no','no','2019-11-21 04:49:18','0000-00-00 00:00:00'),(89,'Javanese','jv','id',0,'no','no','2019-11-20 12:18:29','0000-00-00 00:00:00'),(90,'Japanese','ja','jp',0,'no','no','2019-11-20 12:14:39','0000-00-00 00:00:00'),(91,'Polish','pl','pl',0,'no','no','2020-06-15 03:25:27','0000-00-00 00:00:00'),(92,'Kurdish','ku','iq',0,'no','no','2020-12-21 00:15:31','0000-00-00 00:00:00'),(93,'Lao','lo','la',0,'no','no','2020-12-21 00:15:36','0000-00-00 00:00:00'),(94,'Croatia','hr','hr',0,'no','no','2022-06-07 11:48:21','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leave_types`
--

DROP TABLE IF EXISTS `leave_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(200) NOT NULL,
  `is_active` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_types`
--

LOCK TABLES `leave_types` WRITE;
/*!40000 ALTER TABLE `leave_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `leave_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lesson`
--

DROP TABLE IF EXISTS `lesson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lesson` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `subject_group_subject_id` int NOT NULL,
  `subject_group_class_sections_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  KEY `subject_group_subject_id` (`subject_group_subject_id`),
  KEY `subject_group_class_sections_id` (`subject_group_class_sections_id`),
  CONSTRAINT `lesson_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `lesson_ibfk_2` FOREIGN KEY (`subject_group_subject_id`) REFERENCES `subject_group_subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `lesson_ibfk_3` FOREIGN KEY (`subject_group_class_sections_id`) REFERENCES `subject_group_class_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lesson`
--

LOCK TABLES `lesson` WRITE;
/*!40000 ALTER TABLE `lesson` DISABLE KEYS */;
/*!40000 ALTER TABLE `lesson` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lesson_plan_forum`
--

DROP TABLE IF EXISTS `lesson_plan_forum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lesson_plan_forum` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_syllabus_id` int NOT NULL,
  `type` varchar(20) NOT NULL COMMENT 'staff,student',
  `staff_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `message` text NOT NULL,
  `created_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subject_syllabus_id` (`subject_syllabus_id`),
  KEY `student_id` (`student_id`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `lesson_plan_forum_ibfk_1` FOREIGN KEY (`subject_syllabus_id`) REFERENCES `subject_syllabus` (`id`) ON DELETE CASCADE,
  CONSTRAINT `lesson_plan_forum_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `lesson_plan_forum_ibfk_3` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lesson_plan_forum`
--

LOCK TABLES `lesson_plan_forum` WRITE;
/*!40000 ALTER TABLE `lesson_plan_forum` DISABLE KEYS */;
/*!40000 ALTER TABLE `lesson_plan_forum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `level`
--

DROP TABLE IF EXISTS `level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'e.g., N1, N2, N3, N4, N5, N6, NCV2, NCV3, NCV4',
  `name` varchar(100) NOT NULL COMMENT 'e.g., N4 (NQF Level 5)',
  `level_type` enum('NATED','NCV','Other') NOT NULL DEFAULT 'NATED',
  `nqf_level` int DEFAULT NULL COMMENT 'NQF Level 2-6',
  `sequence` int NOT NULL DEFAULT '1' COMMENT 'For ordering',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_level_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `level`
--

LOCK TABLES `level` WRITE;
/*!40000 ALTER TABLE `level` DISABLE KEYS */;
INSERT INTO `level` VALUES (1,'N1','N1 (NQF Level 2)','NATED',2,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(2,'N2','N2 (NQF Level 3)','NATED',3,2,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(3,'N3','N3 (NQF Level 4)','NATED',4,3,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(4,'N4','N4 (NQF Level 5)','NATED',5,4,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(5,'N5','N5 (NQF Level 5)','NATED',5,5,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(6,'N6','N6 (NQF Level 6)','NATED',6,6,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(7,'NCV2','NCV Level 2','NCV',2,7,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(8,'NCV3','NCV Level 3','NCV',3,8,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(9,'NCV4','NCV Level 4','NCV',4,9,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(10,'LEG1','N4 Business Management','Other',NULL,1,1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(11,'LEG2','N5 Business Management','Other',NULL,2,1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(12,'LEG3','NCV Engineering L2','Other',NULL,3,1,'2026-02-03 16:14:53','2026-02-03 16:14:53');
/*!40000 ALTER TABLE `level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `libarary_members`
--

DROP TABLE IF EXISTS `libarary_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `libarary_members` (
  `id` int NOT NULL AUTO_INCREMENT,
  `library_card_no` varchar(50) DEFAULT NULL,
  `member_type` varchar(50) DEFAULT NULL,
  `member_id` int DEFAULT NULL,
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `libarary_members`
--

LOCK TABLES `libarary_members` WRITE;
/*!40000 ALTER TABLE `libarary_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `libarary_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (1,'New Record inserted On  upload_contents id 1','1',1,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 12:17:02',NULL),(2,'New Record inserted On  online exam id 2','2',1,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 12:41:26',NULL),(3,'New Record inserted On  upload_contents id 2','2',1,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 12:46:57',NULL),(4,'Record updated On  online exam id 2','2',1,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 14:46:49',NULL),(5,'Record updated On  online exam id 2','2',1,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 14:46:57',NULL),(6,'Record updated On  online exam id 2','2',1,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 14:46:57',NULL),(7,'Record updated On  online exam id 2','2',1,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 14:56:53',NULL),(8,'Record updated On students id 1','1',1,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 15:54:15',NULL),(9,'Record updated On  student session id 1','1',1,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 15:54:15',NULL),(10,'New Record inserted On  online exam id 9005','9005',4,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 17:10:41',NULL),(11,'Record updated On onlineexam id 9005','9005',4,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 17:17:40',NULL),(12,'New Record inserted On exam_moderation_comments id 5','5',3,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 17:30:21',NULL),(13,'Record updated On onlineexam id 9005','9005',3,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 17:30:21',NULL),(14,'New Record inserted On  onlineexam questions id 19','19',4,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 17:32:39',NULL),(15,'New Record inserted On  onlineexam questions id 20','20',4,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 17:32:42',NULL),(16,'New Record inserted On  onlineexam questions id 21','21',4,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 17:32:43',NULL),(17,'Record updated On onlineexam id 9005','9005',4,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 17:33:20',NULL),(18,'Record updated On onlineexam id 9005','9005',3,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 17:41:41',NULL),(19,'Record updated On  online exam id 9005','9005',4,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:00:39',NULL),(20,'Record updated On  online exam id 9005','9005',4,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:00:45',NULL),(21,'Record updated On  online exam id 9005','9005',4,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:00:45',NULL),(22,'New Record inserted On  online exam id 9006','9006',4,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:01:52',NULL),(23,'New Record inserted On  onlineexam questions id 22','22',4,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:02:03',NULL),(24,'New Record inserted On  onlineexam questions id 23','23',4,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:02:04',NULL),(25,'New Record inserted On  onlineexam questions id 24','24',4,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:02:05',NULL),(26,'New Record inserted On  onlineexam questions id 25','25',4,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:02:08',NULL),(27,'Record updated On onlineexam id 9006','9006',4,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:02:20',NULL),(28,'New Record inserted On exam_moderation_comments id 6','6',3,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:03:02',NULL),(29,'Record updated On onlineexam id 9006','9006',3,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:03:11',NULL),(30,'Record updated On  online exam id 9006','9006',4,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:03:46',NULL),(31,'Record updated On  online exam id 9006','9006',4,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-01-29 18:03:46',NULL),(32,'New Record inserted On  upload_contents id 3','3',1,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-02-01 07:20:20',NULL),(33,'New Record inserted On  online exam id 9007','9007',1,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-02-01 07:24:20',NULL),(34,'Record updated On onlineexam id 9007','9007',1,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-02-01 07:26:19',NULL),(35,'New Record inserted On exam_moderation_comments id 7','7',3,'Insert','192.168.65.1','Mac OS X','Chrome 144.0.0.0','2026-02-01 07:30:57',NULL),(36,'Record updated On onlineexam id 9007','9007',3,'Update','192.168.65.1','Mac OS X','Chrome 144.0.0.0','2026-02-01 07:30:57',NULL),(37,'New Record inserted On  onlineexam questions id 26','26',1,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-02-01 07:31:42',NULL),(38,'New Record inserted On  onlineexam questions id 27','27',1,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-02-01 07:31:43',NULL),(39,'New Record inserted On  onlineexam questions id 28','28',1,'Insert','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-02-01 07:31:44',NULL),(40,'Record updated On onlineexam id 9007','9007',1,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-02-01 07:31:56',NULL),(41,'Record updated On onlineexam id 9007','9007',3,'Update','192.168.65.1','Mac OS X','Chrome 144.0.0.0','2026-02-01 07:34:06',NULL),(42,'Record updated On  online exam id 9007','9007',1,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-02-01 07:34:44',NULL),(43,'Record updated On  online exam id 9007','9007',1,'Update','192.168.65.1','Mac OS X','Chrome 143.0.0.0','2026-02-01 07:34:44',NULL);
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mark_divisions`
--

DROP TABLE IF EXISTS `mark_divisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mark_divisions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `percentage_from` float(10,2) DEFAULT NULL,
  `percentage_to` float(10,2) DEFAULT NULL,
  `is_active` int DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mark_divisions`
--

LOCK TABLES `mark_divisions` WRITE;
/*!40000 ALTER TABLE `mark_divisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `mark_divisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
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
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migration_log`
--

DROP TABLE IF EXISTS `migration_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migration_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) DEFAULT NULL,
  `old_id` int DEFAULT NULL,
  `new_id` int DEFAULT NULL,
  `migration_type` varchar(50) DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_old_id` (`old_id`),
  KEY `idx_migration_type` (`migration_type`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migration_log`
--

LOCK TABLES `migration_log` WRITE;
/*!40000 ALTER TABLE `migration_log` DISABLE KEYS */;
INSERT INTO `migration_log` VALUES (1,'classes',1,10,'class_to_level','{\"class_name\": \"N4 Business Management\"}','2026-02-03 16:15:31'),(2,'classes',2,11,'class_to_level','{\"class_name\": \"N5 Business Management\"}','2026-02-03 16:15:31'),(3,'classes',3,12,'class_to_level','{\"class_name\": \"NCV Engineering L2\"}','2026-02-03 16:15:31'),(4,'class_sections',1,33,'class_section_to_class','{\"class_code\": \"BMN4-LEG1-Evening-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Evening\", \"subject_name\": \"Business Management N4\"}','2026-02-03 16:15:31'),(5,'class_sections',2,29,'class_section_to_class','{\"class_code\": \"BMN4-LEG2-Evening-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Evening\", \"subject_name\": \"Business Management N4\"}','2026-02-03 16:15:31'),(6,'class_sections',3,25,'class_section_to_class','{\"class_code\": \"BMN4-LEG3-Evening-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Evening\", \"subject_name\": \"Business Management N4\"}','2026-02-03 16:15:31'),(7,'class_sections',1,21,'class_section_to_class','{\"class_code\": \"BMN4-LEG1-Group B-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Group B\", \"subject_name\": \"Business Management N4\"}','2026-02-03 16:15:31'),(8,'class_sections',2,17,'class_section_to_class','{\"class_code\": \"BMN4-LEG2-Group B-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Group B\", \"subject_name\": \"Business Management N4\"}','2026-02-03 16:15:31'),(9,'class_sections',3,13,'class_section_to_class','{\"class_code\": \"BMN4-LEG3-Group B-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Group B\", \"subject_name\": \"Business Management N4\"}','2026-02-03 16:15:31'),(10,'class_sections',1,9,'class_section_to_class','{\"class_code\": \"BMN4-LEG1-Group A-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Group A\", \"subject_name\": \"Business Management N4\"}','2026-02-03 16:15:31'),(11,'class_sections',2,5,'class_section_to_class','{\"class_code\": \"BMN4-LEG2-Group A-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Group A\", \"subject_name\": \"Business Management N4\"}','2026-02-03 16:15:31'),(12,'class_sections',3,1,'class_section_to_class','{\"class_code\": \"BMN4-LEG3-Group A-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Group A\", \"subject_name\": \"Business Management N4\"}','2026-02-03 16:15:31'),(13,'class_sections',1,34,'class_section_to_class','{\"class_code\": \"FMN4-LEG1-Evening-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Evening\", \"subject_name\": \"Financial Management N4\"}','2026-02-03 16:15:31'),(14,'class_sections',2,30,'class_section_to_class','{\"class_code\": \"FMN4-LEG2-Evening-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Evening\", \"subject_name\": \"Financial Management N4\"}','2026-02-03 16:15:31'),(15,'class_sections',3,26,'class_section_to_class','{\"class_code\": \"FMN4-LEG3-Evening-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Evening\", \"subject_name\": \"Financial Management N4\"}','2026-02-03 16:15:31'),(16,'class_sections',1,22,'class_section_to_class','{\"class_code\": \"FMN4-LEG1-Group B-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Group B\", \"subject_name\": \"Financial Management N4\"}','2026-02-03 16:15:31'),(17,'class_sections',2,18,'class_section_to_class','{\"class_code\": \"FMN4-LEG2-Group B-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Group B\", \"subject_name\": \"Financial Management N4\"}','2026-02-03 16:15:31'),(18,'class_sections',3,14,'class_section_to_class','{\"class_code\": \"FMN4-LEG3-Group B-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Group B\", \"subject_name\": \"Financial Management N4\"}','2026-02-03 16:15:31'),(19,'class_sections',1,10,'class_section_to_class','{\"class_code\": \"FMN4-LEG1-Group A-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Group A\", \"subject_name\": \"Financial Management N4\"}','2026-02-03 16:15:31'),(20,'class_sections',2,6,'class_section_to_class','{\"class_code\": \"FMN4-LEG2-Group A-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Group A\", \"subject_name\": \"Financial Management N4\"}','2026-02-03 16:15:31'),(21,'class_sections',3,2,'class_section_to_class','{\"class_code\": \"FMN4-LEG3-Group A-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Group A\", \"subject_name\": \"Financial Management N4\"}','2026-02-03 16:15:31'),(22,'class_sections',1,35,'class_section_to_class','{\"class_code\": \"MCN4-LEG1-Evening-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Evening\", \"subject_name\": \"Marketing & Communication N4\"}','2026-02-03 16:15:31'),(23,'class_sections',2,31,'class_section_to_class','{\"class_code\": \"MCN4-LEG2-Evening-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Evening\", \"subject_name\": \"Marketing & Communication N4\"}','2026-02-03 16:15:31'),(24,'class_sections',3,27,'class_section_to_class','{\"class_code\": \"MCN4-LEG3-Evening-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Evening\", \"subject_name\": \"Marketing & Communication N4\"}','2026-02-03 16:15:31'),(25,'class_sections',1,23,'class_section_to_class','{\"class_code\": \"MCN4-LEG1-Group B-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Group B\", \"subject_name\": \"Marketing & Communication N4\"}','2026-02-03 16:15:31'),(26,'class_sections',2,19,'class_section_to_class','{\"class_code\": \"MCN4-LEG2-Group B-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Group B\", \"subject_name\": \"Marketing & Communication N4\"}','2026-02-03 16:15:31'),(27,'class_sections',3,15,'class_section_to_class','{\"class_code\": \"MCN4-LEG3-Group B-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Group B\", \"subject_name\": \"Marketing & Communication N4\"}','2026-02-03 16:15:31'),(28,'class_sections',1,11,'class_section_to_class','{\"class_code\": \"MCN4-LEG1-Group A-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Group A\", \"subject_name\": \"Marketing & Communication N4\"}','2026-02-03 16:15:31'),(29,'class_sections',2,7,'class_section_to_class','{\"class_code\": \"MCN4-LEG2-Group A-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Group A\", \"subject_name\": \"Marketing & Communication N4\"}','2026-02-03 16:15:31'),(30,'class_sections',3,3,'class_section_to_class','{\"class_code\": \"MCN4-LEG3-Group A-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Group A\", \"subject_name\": \"Marketing & Communication N4\"}','2026-02-03 16:15:31'),(31,'class_sections',1,36,'class_section_to_class','{\"class_code\": \"EBMN4-LEG1-Evening-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Evening\", \"subject_name\": \"Entrepreneurship N4\"}','2026-02-03 16:15:31'),(32,'class_sections',2,32,'class_section_to_class','{\"class_code\": \"EBMN4-LEG2-Evening-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Evening\", \"subject_name\": \"Entrepreneurship N4\"}','2026-02-03 16:15:31'),(33,'class_sections',3,28,'class_section_to_class','{\"class_code\": \"EBMN4-LEG3-Evening-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Evening\", \"subject_name\": \"Entrepreneurship N4\"}','2026-02-03 16:15:31'),(34,'class_sections',1,24,'class_section_to_class','{\"class_code\": \"EBMN4-LEG1-Group B-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Group B\", \"subject_name\": \"Entrepreneurship N4\"}','2026-02-03 16:15:31'),(35,'class_sections',2,20,'class_section_to_class','{\"class_code\": \"EBMN4-LEG2-Group B-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Group B\", \"subject_name\": \"Entrepreneurship N4\"}','2026-02-03 16:15:31'),(36,'class_sections',3,16,'class_section_to_class','{\"class_code\": \"EBMN4-LEG3-Group B-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Group B\", \"subject_name\": \"Entrepreneurship N4\"}','2026-02-03 16:15:31'),(37,'class_sections',1,12,'class_section_to_class','{\"class_code\": \"EBMN4-LEG1-Group A-2026\", \"class_name\": \"N4 Business Management\", \"section_name\": \"Group A\", \"subject_name\": \"Entrepreneurship N4\"}','2026-02-03 16:15:31'),(38,'class_sections',2,8,'class_section_to_class','{\"class_code\": \"EBMN4-LEG2-Group A-2026\", \"class_name\": \"N5 Business Management\", \"section_name\": \"Group A\", \"subject_name\": \"Entrepreneurship N4\"}','2026-02-03 16:15:31'),(39,'class_sections',3,4,'class_section_to_class','{\"class_code\": \"EBMN4-LEG3-Group A-2026\", \"class_name\": \"NCV Engineering L2\", \"section_name\": \"Group A\", \"subject_name\": \"Entrepreneurship N4\"}','2026-02-03 16:15:31'),(67,'student_session',1,1,'student_session_to_programme','{\"student_id\": 1}','2026-02-03 16:15:31'),(68,'student_session',2,2,'student_session_to_programme','{\"student_id\": 2}','2026-02-03 16:15:31'),(70,'student_session',1,4,'student_session_to_enrolment','{\"class_id\": 9, \"student_id\": 1, \"enrolment_type\": \"Core\"}','2026-02-03 16:15:31'),(71,'student_session',1,3,'student_session_to_enrolment','{\"class_id\": 10, \"student_id\": 1, \"enrolment_type\": \"Core\"}','2026-02-03 16:15:31'),(72,'student_session',1,2,'student_session_to_enrolment','{\"class_id\": 11, \"student_id\": 1, \"enrolment_type\": \"Core\"}','2026-02-03 16:15:31'),(73,'student_session',1,1,'student_session_to_enrolment','{\"class_id\": 12, \"student_id\": 1, \"enrolment_type\": \"Core\"}','2026-02-03 16:15:31'),(74,'student_session',2,8,'student_session_to_enrolment','{\"class_id\": 9, \"student_id\": 2, \"enrolment_type\": \"Core\"}','2026-02-03 16:15:31'),(75,'student_session',2,7,'student_session_to_enrolment','{\"class_id\": 10, \"student_id\": 2, \"enrolment_type\": \"Core\"}','2026-02-03 16:15:31'),(76,'student_session',2,6,'student_session_to_enrolment','{\"class_id\": 11, \"student_id\": 2, \"enrolment_type\": \"Core\"}','2026-02-03 16:15:31'),(77,'student_session',2,5,'student_session_to_enrolment','{\"class_id\": 12, \"student_id\": 2, \"enrolment_type\": \"Core\"}','2026-02-03 16:15:31');
/*!40000 ALTER TABLE `migration_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `version` bigint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_roles`
--

DROP TABLE IF EXISTS `notification_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `send_notification_id` int DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `send_notification_id` (`send_notification_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `notification_roles_ibfk_1` FOREIGN KEY (`send_notification_id`) REFERENCES `send_notification` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notification_roles_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_roles`
--

LOCK TABLES `notification_roles` WRITE;
/*!40000 ALTER TABLE `notification_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_setting`
--

DROP TABLE IF EXISTS `notification_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_setting` (
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
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_setting`
--

LOCK TABLES `notification_setting` WRITE;
/*!40000 ALTER TABLE `notification_setting` DISABLE KEYS */;
INSERT INTO `notification_setting` VALUES (1,'student_admission','1','0',0,0,1,1,1,0,1,1,NULL,'Student Admission','','Dear {{student_name}} your admission is confirm in Class: {{class}} Section:  {{section}} for Session: {{current_session_name}} for more \r\ndetail\r\n contact\r\n System\r\n Admin\r\n {{class}} {{section}} {{admission_no}} {{roll_no}} {{admission_date}} {{mobileno}} {{email}} {{dob}} {{guardian_name}} {{guardian_relation}} {{guardian_phone}} {{father_name}} {{father_phone}} {{blood_group}} {{mother_name}} {{gender}} {{guardian_email}}','{{student_name}} {{class}}  {{section}}  {{admission_no}}  {{roll_no}}  {{admission_date}}   {{mobileno}}  {{email}}  {{dob}}  {{guardian_name}}  {{guardian_relation}}  {{guardian_phone}}  {{father_name}}  {{father_phone}}  {{blood_group}}  {{mother_name}}  {{gender}} {{guardian_email}} {{current_session_name}} ',NULL,'2022-12-28 09:52:24','2025-02-13 10:21:49'),(2,'exam_result','1','0',0,1,1,1,1,0,1,1,NULL,'Exam Result','','Dear {{student_name}} - {{exam_roll_no}}, your {{exam}} result has been published.','{{student_name}} {{exam_roll_no}} {{exam}}',NULL,'2022-12-28 09:52:24','2025-02-26 06:31:30'),(3,'fee_submission','1','0',0,1,1,1,1,0,1,1,NULL,'Fee Submission','','Dear parents, we have received Fees Amount {{fee_amount}} for  {{student_name}}  by Your School Name \r\n{{class}} {{section}} {{fine_type}} {{fine_percentage}} {{fine_amount}} {{fee_group_name}} {{type}} {{code}} {{email}} {{contact_no}} {{invoice_id}} {{sub_invoice_id}} {{due_date}} {{amount}} {{fee_amount}}','{{student_name}} {{class}} {{section}} {{fine_type}} {{fine_percentage}} {{fine_amount}} {{fee_group_name}} {{type}} {{code}} {{email}} {{contact_no}} {{invoice_id}} {{sub_invoice_id}} {{due_date}} {{amount}} {{fee_amount}}',NULL,'2022-12-28 09:52:24','2025-02-13 10:21:49'),(4,'student_absent_attendence','1','0',0,1,1,1,1,0,1,1,NULL,'Absent Attendence','','Absent Notice :{{student_name}}  was absent on date {{date}} in period {{subject_name}} {{subject_code}} {{subject_type}} from Your School Name','{{student_name}} {{mobileno}} {{email}} {{father_name}} {{father_phone}} {{father_occupation}} {{mother_name}} {{mother_phone}} {{guardian_name}} {{guardian_phone}} {{guardian_occupation}} {{guardian_email}} {{date}} {{current_session_name}} {{time_from}} {{time_to}} {{subject_name}} {{subject_code}} {{subject_type}}  ',NULL,'2022-12-28 09:52:24','2025-02-13 10:38:04'),(6,'homework','1','0',0,1,1,1,1,0,1,1,NULL,'Homework','','New Homework has been created for \r\n{{student_name}} at\r\n\r\n\r\n\r\n{{homework_date}} for the class {{class}} {{section}} {{subject}}. kindly submit your\r\n\r\n\r\n homework before {{submit_date}} .Thank you','{{homework_date}} {{submit_date}} {{class}} {{section}} {{subject}} {{student_name}} {{admission_no}} ',NULL,'2022-12-28 09:52:24','2025-02-26 06:31:30'),(7,'fees_reminder','1','0',0,1,1,1,1,0,1,1,NULL,'Fees Reminder','','Dear parents, please pay fee amount Rs.{{due_amount}} of {{fee_type}} before {{due_date}} for {{student_name}}  from smart school (ignore if you already paid)','{{fee_type}}{{fee_code}}{{due_date}}{{student_name}}{{school_name}}{{fee_amount}}{{due_amount}}{{deposit_amount}} ',NULL,'2022-12-28 09:52:24','2025-02-13 10:21:49'),(8,'forgot_password','1','0',0,0,0,1,1,1,1,1,1,'Forgot Password','','Dear  {{name}} , \r\n    Recently a request was submitted to reset password for your account. If you didn\'t make the request, just ignore this email. Otherwise you can reset your password using this link <a href=\'{{resetPassLink}}\'>Click here to reset your password</a>,\r\nif you\'re having trouble clicking the password reset button, copy and paste the URL below into your web browser. your username {{username}}\r\n{{resetPassLink}}\r\n Regards,\r\n {{school_name}}','{{school_name}}{{name}}{{username}}{{resetPassLink}} ',NULL,'2022-12-28 09:52:24','2025-02-13 10:08:56'),(9,'online_examination_publish_exam','1','0',0,1,1,1,1,0,1,1,NULL,'Online Examination Publish Exam','','A new exam {{exam_title}} has been created for  duration: {{time_duration}} min, which will be available from:  {{exam_from}} to  {{exam_to}}.','{{exam_title}} {{exam_from}} {{exam_to}} {{time_duration}} {{attempt}} {{passing_percentage}}',NULL,'2022-12-28 09:52:24','2025-02-26 06:31:30'),(10,'online_examination_publish_result','1','0',0,1,1,1,1,0,1,1,NULL,'Online Examination Publish Result','','Exam {{exam_title}} result has been declared which was conducted between  {{exam_from}} to   {{exam_to}}, for more details, please check your student portal.','{{exam_title}} {{exam_from}} {{exam_to}} {{time_duration}} {{attempt}} {{passing_percentage}}',NULL,'2022-12-28 09:52:24','2025-02-26 06:31:30'),(11,'online_admission_form_submission','1','0',0,1,1,1,1,0,1,1,NULL,'Online Admission Form Submission','','Dear {{firstname}}  {{lastname}} your online admission form is Submitted successfully  on date {{date}}. Your Reference number is {{reference_no}}. Please remember your reference number for further process.',' {{firstname}} {{lastname}} {{date}} {{reference_no}}',NULL,'2022-12-28 09:52:24','2025-02-13 10:21:49'),(12,'online_admission_fees_submission','1','0',0,1,1,1,1,0,1,1,NULL,'Online Admission Fees Submission','','Dear {{firstname}}  {{lastname}} your online admission form is Submitted successfully and the payment of {{paid_amount}} has recieved successfully on date {{date}}. Your Reference number is {{reference_no}}. Please remember your reference number for further process.',' {{firstname}} {{lastname}} {{date}} {{paid_amount}} {{reference_no}}',NULL,'2022-12-28 09:52:24','2025-02-26 06:30:59'),(13,'student_login_credential','1','0',0,0,1,1,1,0,1,1,NULL,'Student Login Credential','','Hello {{display_name}} your login details for Url: {{url}} Username: {{username}}  Password: {{password}} admission No: {{admission_no}}','{{url}} {{display_name}} {{username}} {{password}} {{admission_no}}',NULL,'2022-08-06 05:34:41','2025-02-26 06:30:11'),(14,'staff_login_credential','1','0',0,0,1,0,0,1,NULL,NULL,1,'Staff Login Credential','','Hello {{first_name}} {{last_name}} your login details for Url: {{url}} Username: {{username}}  Password: {{password}} Employee ID: {{employee_id}}','{{url}} {{first_name}} {{last_name}} {{username}} {{password}} {{employee_id}}',NULL,'2021-12-23 11:59:13','2025-02-26 06:30:14'),(15,'fee_processing','1','0',0,1,1,1,1,0,1,1,NULL,'Fee processing','','Dear parents, we have received Fees Amount {{fee_amount}} for  {{student_name}}  by Your School Name \r\n{{class}} {{section}} {{email}} {{contact_no}}\r\n\r\n{{student_name}} {{class}} {{section}} {{email}} {{contact_no}} transaction_id :{{transaction_id}} {{fee_amount}}','{{student_name}} {{class}} {{section}} {{email}} {{contact_no}} {{transaction_id}} {{fee_amount}}',NULL,'2021-12-22 10:15:42','2025-02-26 06:30:42'),(16,'online_admission_fees_processing','1','0',0,1,1,1,1,0,1,1,NULL,'Online Admission Fees Processing','','Dear {{firstname}}  {{lastname}} your online admission form is Submitted successfully and the payment of {{paid_amount}} has processing on date {{date}}. Your Reference number is {{reference_no}} and your transaction id {{transaction_id}}. Please remember your reference number for further process.',' {{firstname}} {{lastname}} {{date}} {{paid_amount}} {{reference_no}} {{transaction_id}}',NULL,'2022-08-06 11:09:47','2025-02-26 06:30:40'),(17,'student_apply_leave','1','0',0,0,1,0,1,1,NULL,1,1,'Student Apply Leave ( {{student_name}} - {{admission_no}} )','','My Name is {{student_name}} Class {{class}} section {{section}}. I have to apply leave on {{apply_date}}and from {{from_date}} to {{to_date}}. {{message}} please provide.','{{message}} {{apply_date}} {{from_date}} {{to_date}} {{student_name}} {{class}} {{section}}',NULL,'2022-03-12 11:58:37','2025-02-26 06:30:24'),(18,'email_pdf_exam_marksheet','1','0',0,0,0,1,1,0,1,1,NULL,'Email PDF Exam Marksheet ( {{student_name}} - {{admission_no}} )','','Dear {{student_name}} ({{admission_no}}) {{class}} Section {{section}}. We have mailed you the marksheet of Exam {{exam}} Roll no.{{roll_no}}','{{student_name}} {{class}}  {{section}}  {{admission_no}}  {{roll_no}} {{exam}} {{admit_card_roll_no}} ',NULL,'2022-03-12 12:24:42','2025-02-13 10:08:56'),(19,'homework_evaluation','1','0',0,1,1,1,1,0,1,1,NULL,'Homework Evaluation','','Homework Evaluation\r\nHomework Assign Date:  {{homework_date}}  \r\nLast Submit Date: {{submit_date}}\r\nStudent Name: {{student_name}} .\r\nAdmission No {{admission_no}}\r\n{{class}}\r\nsection: {{section}}\r\nsubject : {{subject}} \r\nMarks: {{marks}}/{{max_marks}}\r\nDate:{{evaluation_date}}\r\nThank you','{{homework_date}} {{submit_date}} {{class}} {{section}} {{subject}} {{student_name}} {{admission_no}} {{max_marks}} {{marks}} {{evaluation_date}}',120,'2025-01-15 08:00:34','2025-02-26 06:30:36'),(20,'student_present_attendence','1','0',0,1,1,1,1,0,1,1,NULL,'Present Attendence','','Present Notice :{{student_name}} {{admission_no}} was present on date {{date}} in in_time {{in_time}} period subject-{{subject_name}}, subject_code - {{subject_code}}, subject_type-{{subject_type}}, period_time_from-  {{period_time_from}}, period_time_to-  {{period_time_to}}, mobile no - {{mobileno}}, email -  {{email}}, father name -  {{father_name}}, father phone - {{father_phone}}, father occupation -  {{father_occupation}}, mother name -  {{mother_name}}, mother phone - {{mother_phone}}, guardian name -  {{guardian_name}}, guardian phone -  {{guardian_phone}}, guardian occupation - {{guardian_occupation}}, guardian email - {{guardian_email}}','{{student_name}} {{mobileno}} {{email}} {{father_name}} {{father_phone}} {{father_occupation}} {{mother_name}} {{mother_phone}} {{guardian_name}} {{guardian_phone}} {{guardian_occupation}} {{guardian_email}} {{date}} {{in_time}}  ({{admission_no}}) {{period_time_from}} {{period_time_to}} {{subject_name}} {{subject_code}} {{subject_type}}',15,'2025-01-13 05:55:46','2025-02-26 06:33:37'),(21,'staff_present_attendence','1','0',0,1,1,0,0,1,NULL,NULL,1,'staff Present Attendence','','Present Notice: Staff Name {{staff_name}} ({{employee_id}}) is Present on Date : {{date}} at Time : {{in_time}}\r\n<br>\r\nstaff contact no:{{contact_no}}\r\n<br>\r\nstaff mail id : {{email}}','{{date}} {{in_time}} {{staff_name}} {{employee_id}} {{contact_no}} {{email}}\n',190,'2025-02-07 11:43:28','2025-02-13 10:40:00'),(22,'staff_absent_attendence','1','0',0,1,1,0,0,1,NULL,NULL,1,'staff Absent Attendence','','Absent Notice: Staff Name {{staff_name}} ({{employee_id}}) is Absent on Date : {{date}} \r\n<br>\r\nstaff contact no:{{contact_no}}\r\n<br>\r\nstaff mail id : {{email}}','{{date}} {{staff_name}} {{employee_id}} {{contact_no}} {{email}}\n',200,'2025-02-07 11:43:28','2025-02-13 10:40:00');
/*!40000 ALTER TABLE `notification_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offline_fees_payments`
--

DROP TABLE IF EXISTS `offline_fees_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offline_fees_payments` (
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
  PRIMARY KEY (`id`),
  KEY `student_fees_master_id` (`student_fees_master_id`),
  KEY `fee_groups_feetype_id` (`fee_groups_feetype_id`),
  KEY `student_transport_fee_id` (`student_transport_fee_id`),
  KEY `offline_fees_payments_ibfk_4` (`approved_by`),
  KEY `student_session_id` (`student_session_id`),
  CONSTRAINT `offline_fees_payments_ibfk_1` FOREIGN KEY (`student_fees_master_id`) REFERENCES `student_fees_master` (`id`) ON DELETE CASCADE,
  CONSTRAINT `offline_fees_payments_ibfk_2` FOREIGN KEY (`fee_groups_feetype_id`) REFERENCES `fee_groups_feetype` (`id`) ON DELETE CASCADE,
  CONSTRAINT `offline_fees_payments_ibfk_3` FOREIGN KEY (`student_transport_fee_id`) REFERENCES `student_transport_fees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `offline_fees_payments_ibfk_4` FOREIGN KEY (`approved_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `offline_fees_payments_ibfk_5` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offline_fees_payments`
--

LOCK TABLES `offline_fees_payments` WRITE;
/*!40000 ALTER TABLE `offline_fees_payments` DISABLE KEYS */;
/*!40000 ALTER TABLE `offline_fees_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `online_admission_custom_field_value`
--

DROP TABLE IF EXISTS `online_admission_custom_field_value`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `online_admission_custom_field_value` (
  `id` int NOT NULL AUTO_INCREMENT,
  `belong_table_id` int DEFAULT NULL,
  `custom_field_id` int DEFAULT NULL,
  `field_value` longtext NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `custom_field_id` (`custom_field_id`),
  KEY `idx_belong_table_id` (`belong_table_id`),
  KEY `idx_field_value` (`field_value`(200)),
  CONSTRAINT `online_admission_custom_field_value_ibfk_1` FOREIGN KEY (`custom_field_id`) REFERENCES `custom_fields` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `online_admission_custom_field_value`
--

LOCK TABLES `online_admission_custom_field_value` WRITE;
/*!40000 ALTER TABLE `online_admission_custom_field_value` DISABLE KEYS */;
/*!40000 ALTER TABLE `online_admission_custom_field_value` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `online_admission_fields`
--

DROP TABLE IF EXISTS `online_admission_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `online_admission_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `online_admission_fields`
--

LOCK TABLES `online_admission_fields` WRITE;
/*!40000 ALTER TABLE `online_admission_fields` DISABLE KEYS */;
INSERT INTO `online_admission_fields` VALUES (1,'middlename',0,'2021-05-28 10:29:23','2026-01-29 12:14:53'),(2,'lastname',1,'2021-06-02 04:49:19','2026-01-29 12:14:53'),(3,'category',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(4,'religion',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(5,'cast',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(6,'mobile_no',1,'2021-06-02 04:50:24','2026-01-29 12:14:53'),(7,'admission_date',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(8,'student_photo',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(9,'is_student_house',0,'2021-05-29 13:22:53','2026-01-29 12:14:53'),(10,'is_blood_group',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(11,'student_height',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(12,'student_weight',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(13,'father_name',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(14,'father_phone',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(15,'father_occupation',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(16,'father_pic',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(17,'mother_name',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(18,'mother_phone',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(19,'mother_occupation',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(20,'mother_pic',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(21,'guardian_name',1,'2021-06-02 04:50:54','2026-01-29 12:14:53'),(22,'guardian_phone',1,'2021-06-02 04:50:54','2026-01-29 12:14:53'),(23,'if_guardian_is',1,'2021-06-02 04:50:54','2026-01-29 12:14:53'),(24,'guardian_relation',1,'2021-06-02 04:50:54','2026-01-29 12:14:53'),(25,'guardian_email',1,'2021-06-02 04:51:35','2026-01-29 12:14:53'),(26,'guardian_occupation',1,'2021-06-02 04:51:26','2026-01-29 12:14:53'),(27,'guardian_address',1,'2021-06-02 04:51:31','2026-01-29 12:14:53'),(28,'bank_account_no',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(29,'bank_name',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(30,'ifsc_code',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(31,'national_identification_no',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(32,'local_identification_no',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(33,'rte',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(34,'previous_school_details',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(35,'guardian_photo',1,'2021-06-02 04:51:29','2026-01-29 12:14:53'),(36,'student_note',0,'2021-06-02 04:55:08','2026-01-29 12:14:53'),(37,'measurement_date',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(38,'student_email',1,'2021-06-02 04:49:38','2026-01-29 12:14:53'),(39,'current_address',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(40,'permanent_address',0,'2021-06-02 04:48:35','2026-01-29 12:14:53'),(41,'upload_documents',1,'2022-09-20 08:00:32','2026-01-29 12:14:53');
/*!40000 ALTER TABLE `online_admission_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `online_admission_payment`
--

DROP TABLE IF EXISTS `online_admission_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `online_admission_payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `online_admission_id` int NOT NULL,
  `paid_amount` float(10,2) NOT NULL,
  `payment_mode` varchar(50) NOT NULL,
  `payment_type` varchar(100) NOT NULL,
  `transaction_id` varchar(100) NOT NULL,
  `note` varchar(100) NOT NULL,
  `date` datetime NOT NULL,
  `processing_charge_type` varchar(255) DEFAULT NULL,
  `processing_charge_value` float(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `online_admission_id` (`online_admission_id`),
  CONSTRAINT `online_admission_payment_ibfk_1` FOREIGN KEY (`online_admission_id`) REFERENCES `online_admissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `online_admission_payment`
--

LOCK TABLES `online_admission_payment` WRITE;
/*!40000 ALTER TABLE `online_admission_payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `online_admission_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `online_admissions`
--

DROP TABLE IF EXISTS `online_admissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `online_admissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admission_no` varchar(100) DEFAULT NULL,
  `roll_no` varchar(100) DEFAULT NULL,
  `reference_no` varchar(50) NOT NULL,
  `admission_date` date DEFAULT NULL,
  `firstname` varchar(100) DEFAULT NULL,
  `middlename` varchar(255) NOT NULL,
  `lastname` varchar(100) DEFAULT NULL,
  `rte` varchar(20) NOT NULL DEFAULT 'No',
  `image` varchar(255) DEFAULT NULL,
  `mobileno` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `pincode` varchar(100) DEFAULT NULL,
  `religion` varchar(100) DEFAULT NULL,
  `cast` varchar(50) NOT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(100) DEFAULT NULL,
  `current_address` text,
  `permanent_address` text,
  `category_id` int DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `route_id` int NOT NULL,
  `school_house_id` int DEFAULT NULL,
  `blood_group` varchar(200) NOT NULL,
  `vehroute_id` int NOT NULL,
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
  `guardian_email` varchar(100) NOT NULL,
  `father_pic` varchar(255) NOT NULL,
  `mother_pic` varchar(255) NOT NULL,
  `guardian_pic` varchar(255) NOT NULL,
  `is_enroll` int DEFAULT '0',
  `previous_school` text,
  `height` varchar(100) NOT NULL,
  `weight` varchar(100) NOT NULL,
  `note` text NOT NULL,
  `form_status` int NOT NULL,
  `paid_status` int NOT NULL,
  `measurement_date` date DEFAULT NULL,
  `app_key` text,
  `document` text,
  `submit_date` date DEFAULT NULL,
  `disable_at` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `class_section_id` (`class_section_id`),
  KEY `category_id` (`category_id`),
  KEY `hostel_room_id` (`hostel_room_id`),
  KEY `school_house_id` (`school_house_id`),
  KEY `idx_reference_no` (`reference_no`),
  KEY `idx_mobileno` (`mobileno`),
  CONSTRAINT `online_admissions_ibfk_1` FOREIGN KEY (`class_section_id`) REFERENCES `class_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `online_admissions_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `online_admissions_ibfk_3` FOREIGN KEY (`hostel_room_id`) REFERENCES `hostel_rooms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `online_admissions_ibfk_4` FOREIGN KEY (`school_house_id`) REFERENCES `school_houses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `online_admissions`
--

LOCK TABLES `online_admissions` WRITE;
/*!40000 ALTER TABLE `online_admissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `online_admissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onlineexam`
--

DROP TABLE IF EXISTS `onlineexam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `onlineexam` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `exam` text,
  `attempt` int NOT NULL,
  `exam_from` datetime DEFAULT NULL,
  `exam_to` datetime DEFAULT NULL,
  `is_quiz` int NOT NULL DEFAULT '0',
  `auto_publish_date` datetime DEFAULT NULL,
  `time_from` time DEFAULT NULL,
  `time_to` time DEFAULT NULL,
  `duration` time NOT NULL,
  `passing_percentage` float NOT NULL DEFAULT '0',
  `description` text,
  `publish_result` int NOT NULL DEFAULT '0',
  `answer_word_count` int NOT NULL DEFAULT '-1',
  `is_active` varchar(1) DEFAULT '0',
  `is_marks_display` int NOT NULL DEFAULT '0',
  `is_neg_marking` int NOT NULL DEFAULT '0',
  `is_random_question` int NOT NULL DEFAULT '0',
  `accommodate_disabled` enum('yes','no') DEFAULT 'no',
  `disabled_extra_time_percent` int DEFAULT '25',
  `is_rank_generated` int NOT NULL DEFAULT '0',
  `publish_exam_notification` int NOT NULL,
  `publish_result_notification` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `moderation_status` enum('draft','pending_moderation','approved','rejected') NOT NULL DEFAULT 'draft',
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `onlineexam_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9008 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onlineexam`
--

LOCK TABLES `onlineexam` WRITE;
/*!40000 ALTER TABLE `onlineexam` DISABLE KEYS */;
INSERT INTO `onlineexam` VALUES (1,27,'BMN4 Mid-Year Test',1,NULL,NULL,0,NULL,NULL,NULL,'01:00:00',50,'Business Management N4 mid-year examination',0,-1,'n',0,0,0,'no',25,0,0,0,'2026-01-29 12:15:00','2026-01-29 12:15:00','draft'),(2,27,'test1',1,'2026-01-29 18:10:00','2026-01-30 18:10:00',0,'2026-01-30 18:11:00',NULL,NULL,'01:00:00',100,'good luck',0,100,'1',0,0,0,'yes',25,0,1,0,'2026-01-29 12:41:26','2026-01-29 14:56:53','draft'),(9001,27,'Mathematics Mid-Term Test (DRAFT)',2,'2026-02-05 17:07:34','2026-02-12 17:07:34',0,NULL,NULL,NULL,'01:00:00',40,'This is a draft exam waiting to be submitted for moderation.',0,-1,'0',1,0,0,'no',25,0,0,0,'2026-01-29 17:07:34','2026-01-29 17:07:34','draft'),(9002,27,'Science Quiz (PENDING MODERATION)',1,'2026-02-03 17:07:34','2026-02-10 17:07:34',1,NULL,NULL,NULL,'00:45:00',50,'This exam is pending moderation review.',0,-1,'0',1,1,1,'no',25,0,0,0,'2026-01-29 17:07:34','2026-01-29 17:07:34','pending_moderation'),(9003,27,'English Literature Final (APPROVED)',3,'2026-02-01 17:07:34','2026-02-08 17:07:34',0,NULL,NULL,NULL,'02:00:00',35,'This exam has been approved by the moderator.',0,500,'0',1,0,1,'yes',25,0,0,0,'2026-01-29 17:07:34','2026-01-29 17:07:34','approved'),(9004,27,'History Assessment (REJECTED)',2,'2026-02-06 17:07:34','2026-02-13 17:07:34',0,NULL,NULL,NULL,'01:30:00',45,'This exam was rejected. Teacher needs to review feedback.',0,-1,'0',1,0,0,'no',25,0,0,0,'2026-01-29 17:07:34','2026-01-29 17:07:34','rejected'),(9005,20,'test',1,'2026-01-29 22:40:00','2026-01-30 22:40:00',0,'2026-01-31 22:40:00',NULL,NULL,'01:00:00',100,'test',0,-1,'1',0,0,0,'no',25,0,1,0,'2026-01-29 17:10:41','2026-01-29 18:00:45','approved'),(9006,20,'Test2',1,'2026-01-29 22:40:00','2026-01-31 22:40:00',0,'2026-02-01 22:40:00',NULL,NULL,'01:00:00',100,'good luck',0,-1,'1',0,0,0,'yes',50,0,1,0,'2026-01-29 18:01:52','2026-01-29 18:03:46','approved'),(9007,20,'Exam 01',1,'2026-02-01 12:53:00','2026-02-12 12:53:00',0,'2026-02-01 12:54:00',NULL,NULL,'01:00:00',100,'Test',0,-1,'1',0,0,0,'no',25,0,1,0,'2026-02-01 07:24:20','2026-02-01 07:34:44','approved');
/*!40000 ALTER TABLE `onlineexam` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onlineexam_attempts`
--

DROP TABLE IF EXISTS `onlineexam_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `onlineexam_attempts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `onlineexam_student_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `onlineexam_student_id` (`onlineexam_student_id`),
  CONSTRAINT `onlineexam_attempts_ibfk_1` FOREIGN KEY (`onlineexam_student_id`) REFERENCES `onlineexam_students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onlineexam_attempts`
--

LOCK TABLES `onlineexam_attempts` WRITE;
/*!40000 ALTER TABLE `onlineexam_attempts` DISABLE KEYS */;
/*!40000 ALTER TABLE `onlineexam_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onlineexam_questions`
--

DROP TABLE IF EXISTS `onlineexam_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `onlineexam_questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int DEFAULT NULL,
  `onlineexam_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `marks` float(10,2) NOT NULL DEFAULT '0.00',
  `neg_marks` float(10,2) DEFAULT '0.00',
  `is_active` varchar(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `onlineexam_id` (`onlineexam_id`),
  KEY `question_id` (`question_id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `onlineexam_questions_ibfk_1` FOREIGN KEY (`onlineexam_id`) REFERENCES `onlineexam` (`id`) ON DELETE CASCADE,
  CONSTRAINT `onlineexam_questions_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `onlineexam_questions_ibfk_3` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onlineexam_questions`
--

LOCK TABLES `onlineexam_questions` WRITE;
/*!40000 ALTER TABLE `onlineexam_questions` DISABLE KEYS */;
INSERT INTO `onlineexam_questions` VALUES (1,1,2,27,10.00,0.00,'1','2026-01-29 13:12:39','2026-01-29 13:12:39'),(2,2,2,27,10.00,0.00,'1','2026-01-29 13:12:39','2026-01-29 13:12:39'),(3,3,2,27,10.00,0.00,'1','2026-01-29 13:12:39','2026-01-29 13:12:39'),(4,4,2,27,15.00,0.00,'1','2026-01-29 13:12:39','2026-01-29 13:12:39'),(5,5,2,27,10.00,0.00,'1','2026-01-29 13:12:39','2026-01-29 13:12:39'),(6,6,2,27,15.00,0.00,'1','2026-01-29 13:12:39','2026-01-29 13:12:39'),(7,7,2,27,5.00,0.00,'1','2026-01-29 13:12:39','2026-01-29 13:12:39'),(8,8,2,27,5.00,0.00,'1','2026-01-29 13:12:39','2026-01-29 13:12:39'),(9,9,2,27,5.00,0.00,'1','2026-01-29 13:12:39','2026-01-29 13:12:39'),(10,10,2,27,15.00,0.00,'1','2026-01-29 13:12:39','2026-01-29 13:12:39'),(11,9001,9001,NULL,5.00,0.00,'0','2026-01-29 17:08:01','2026-01-29 17:08:01'),(12,9002,9001,NULL,5.00,0.00,'0','2026-01-29 17:08:01','2026-01-29 17:08:01'),(13,9001,9002,NULL,10.00,2.00,'0','2026-01-29 17:08:01','2026-01-29 17:08:01'),(14,9003,9002,NULL,10.00,2.00,'0','2026-01-29 17:08:01','2026-01-29 17:08:01'),(15,9002,9003,NULL,10.00,0.00,'0','2026-01-29 17:08:01','2026-01-29 17:08:01'),(16,9004,9003,NULL,20.00,0.00,'0','2026-01-29 17:08:01','2026-01-29 17:08:01'),(17,9001,9004,NULL,5.00,0.00,'0','2026-01-29 17:08:01','2026-01-29 17:08:01'),(18,9004,9004,NULL,15.00,0.00,'0','2026-01-29 17:08:01','2026-01-29 17:08:01'),(19,1,9005,NULL,1.00,0.25,'0','2026-01-29 17:32:39','2026-01-29 17:32:39'),(20,2,9005,NULL,1.00,0.25,'0','2026-01-29 17:32:42','2026-01-29 17:32:42'),(21,3,9005,NULL,1.00,0.25,'0','2026-01-29 17:32:43','2026-01-29 17:32:43'),(22,4,9006,NULL,1.00,0.25,'0','2026-01-29 18:02:03','2026-01-29 18:02:03'),(23,3,9006,NULL,1.00,0.25,'0','2026-01-29 18:02:04','2026-01-29 18:02:04'),(24,2,9006,NULL,1.00,0.25,'0','2026-01-29 18:02:05','2026-01-29 18:02:05'),(25,5,9006,NULL,1.00,0.25,'0','2026-01-29 18:02:08','2026-01-29 18:02:08'),(26,1,9007,NULL,1.00,0.25,'0','2026-02-01 07:31:42','2026-02-01 07:31:42'),(27,2,9007,NULL,1.00,0.25,'0','2026-02-01 07:31:43','2026-02-01 07:31:43'),(28,3,9007,NULL,1.00,0.25,'0','2026-02-01 07:31:44','2026-02-01 07:31:44');
/*!40000 ALTER TABLE `onlineexam_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onlineexam_student_results`
--

DROP TABLE IF EXISTS `onlineexam_student_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `onlineexam_student_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `onlineexam_student_id` int NOT NULL,
  `onlineexam_question_id` int NOT NULL,
  `select_option` longtext,
  `marks` float(10,2) NOT NULL DEFAULT '0.00',
  `remark` text,
  `attachment_name` text,
  `attachment_upload_name` varchar(250) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `onlineexam_student_id` (`onlineexam_student_id`),
  KEY `onlineexam_question_id` (`onlineexam_question_id`),
  CONSTRAINT `onlineexam_student_results_ibfk_1` FOREIGN KEY (`onlineexam_student_id`) REFERENCES `onlineexam_students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `onlineexam_student_results_ibfk_2` FOREIGN KEY (`onlineexam_question_id`) REFERENCES `onlineexam_questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onlineexam_student_results`
--

LOCK TABLES `onlineexam_student_results` WRITE;
/*!40000 ALTER TABLE `onlineexam_student_results` DISABLE KEYS */;
/*!40000 ALTER TABLE `onlineexam_student_results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `onlineexam_students`
--

DROP TABLE IF EXISTS `onlineexam_students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `onlineexam_students` (
  `id` int NOT NULL AUTO_INCREMENT,
  `onlineexam_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `is_attempted` int NOT NULL DEFAULT '0',
  `rank` int DEFAULT '0',
  `quiz_attempted` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `onlineexam_id` (`onlineexam_id`),
  KEY `student_session_id` (`student_session_id`),
  CONSTRAINT `onlineexam_students_ibfk_1` FOREIGN KEY (`onlineexam_id`) REFERENCES `onlineexam` (`id`) ON DELETE CASCADE,
  CONSTRAINT `onlineexam_students_ibfk_2` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `onlineexam_students`
--

LOCK TABLES `onlineexam_students` WRITE;
/*!40000 ALTER TABLE `onlineexam_students` DISABLE KEYS */;
INSERT INTO `onlineexam_students` VALUES (3,2,2,0,0,0,'2026-01-29 12:51:50','2026-01-29 12:51:50'),(4,2,1,0,0,0,'2026-01-29 14:48:11','2026-01-29 14:48:11');
/*!40000 ALTER TABLE `onlineexam_students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_settings`
--

DROP TABLE IF EXISTS `payment_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `payment_type` varchar(200) NOT NULL,
  `api_username` varchar(200) DEFAULT NULL,
  `api_secret_key` varchar(200) NOT NULL,
  `salt` varchar(200) NOT NULL,
  `api_publishable_key` varchar(200) NOT NULL,
  `api_password` varchar(200) DEFAULT NULL,
  `api_signature` varchar(200) DEFAULT NULL,
  `api_email` varchar(200) DEFAULT NULL,
  `paypal_demo` varchar(100) NOT NULL,
  `account_no` varchar(200) NOT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `gateway_mode` int NOT NULL COMMENT '0 Testing, 1 live',
  `paytm_website` varchar(255) NOT NULL,
  `paytm_industrytype` varchar(255) NOT NULL,
  `charge_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `charge_value` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_settings`
--

LOCK TABLES `payment_settings` WRITE;
/*!40000 ALTER TABLE `payment_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payslip_allowance`
--

DROP TABLE IF EXISTS `payslip_allowance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payslip_allowance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `payslip_id` int NOT NULL,
  `allowance_type` varchar(200) NOT NULL,
  `amount` float NOT NULL,
  `staff_id` int NOT NULL,
  `cal_type` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `payslip_id` (`payslip_id`),
  CONSTRAINT `payslip_allowance_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `payslip_allowance_ibfk_2` FOREIGN KEY (`payslip_id`) REFERENCES `staff_payslip` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payslip_allowance`
--

LOCK TABLES `payslip_allowance` WRITE;
/*!40000 ALTER TABLE `payslip_allowance` DISABLE KEYS */;
/*!40000 ALTER TABLE `payslip_allowance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_category`
--

DROP TABLE IF EXISTS `permission_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_category` (
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
  PRIMARY KEY (`id`),
  KEY `idx_short_code` (`short_code`),
  KEY `perm_group_id` (`perm_group_id`),
  CONSTRAINT `permission_category_ibfk_1` FOREIGN KEY (`perm_group_id`) REFERENCES `permission_group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5058 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_category`
--

LOCK TABLES `permission_category` WRITE;
/*!40000 ALTER TABLE `permission_category` DISABLE KEYS */;
INSERT INTO `permission_category` VALUES (1,1,'Student','student',1,1,1,1,'2019-10-24 05:42:03','2026-01-29 12:14:53'),(2,1,'Import Student','import_student',1,0,0,0,'2018-06-22 10:17:19','2026-01-29 12:14:53'),(3,1,'Student Categories','student_categories',1,1,1,1,'2018-06-22 10:17:36','2026-01-29 12:14:53'),(4,1,'Student Houses','student_houses',1,1,1,1,'2018-06-22 10:17:53','2026-01-29 12:14:53'),(5,2,'Collect Fees','collect_fees',1,1,0,1,'2018-06-22 10:21:03','2026-01-29 12:14:53'),(6,2,'Fees Carry Forward','fees_carry_forward',1,0,0,0,'2018-06-27 00:18:15','2026-01-29 12:14:53'),(7,2,'Fees Master','fees_master',1,1,1,1,'2018-06-27 00:18:57','2026-01-29 12:14:53'),(8,2,'Fees Group','fees_group',1,1,1,1,'2018-06-22 10:21:46','2026-01-29 12:14:53'),(9,3,'Income','income',1,1,1,1,'2018-06-22 10:23:21','2026-01-29 12:14:53'),(10,3,'Income Head','income_head',1,1,1,1,'2018-06-22 10:22:44','2026-01-29 12:14:53'),(11,3,'Search Income','search_income',1,0,0,0,'2018-06-22 10:23:00','2026-01-29 12:14:53'),(12,4,'Expense','expense',1,1,1,1,'2018-06-22 10:24:06','2026-01-29 12:14:53'),(13,4,'Expense Head','expense_head',1,1,1,1,'2018-06-22 10:23:47','2026-01-29 12:14:53'),(14,4,'Search Expense','search_expense',1,0,0,0,'2018-06-22 10:24:13','2026-01-29 12:14:53'),(15,5,'Student / Period Attendance','student_attendance',1,1,1,0,'2019-11-29 01:19:05','2026-01-29 12:14:53'),(20,6,'Marks Grade','marks_grade',1,1,1,1,'2018-06-22 10:25:25','2026-01-29 12:14:53'),(21,7,'Class Timetable','class_timetable',1,0,1,0,'2019-11-24 03:05:17','2026-01-29 12:14:53'),(23,7,'Subject','subject',1,1,1,1,'2018-06-22 10:32:17','2026-01-29 12:14:53'),(24,7,'Class','class',1,1,1,1,'2018-06-22 10:32:35','2026-01-29 12:14:53'),(25,7,'Section','section',1,1,1,1,'2018-06-22 10:31:10','2026-01-29 12:14:53'),(26,7,'Promote Student','promote_student',1,0,0,0,'2018-06-22 10:32:47','2026-01-29 12:14:53'),(27,8,'Upload Content','upload_content',1,1,0,1,'2018-06-22 10:33:19','2026-01-29 12:14:53'),(28,9,'Books List','books',1,1,1,1,'2019-11-24 00:37:12','2026-01-29 12:14:53'),(29,9,'Issue Return','issue_return',1,0,0,0,'2019-11-24 00:37:18','2026-01-29 12:14:53'),(30,9,'Add Staff Member','add_staff_member',1,0,0,0,'2018-07-02 11:37:00','2026-01-29 12:14:53'),(31,10,'Issue Item','issue_item',1,1,1,1,'2019-11-29 06:39:27','2026-01-29 12:14:53'),(32,10,'Add Item Stock','item_stock',1,1,1,1,'2019-11-24 00:39:17','2026-01-29 12:14:53'),(33,10,'Add Item','item',1,1,1,1,'2019-11-24 00:39:39','2026-01-29 12:14:53'),(34,10,'Item Store','store',1,1,1,1,'2019-11-24 00:40:41','2026-01-29 12:14:53'),(35,10,'Item Supplier','supplier',1,1,1,1,'2019-11-24 00:40:49','2026-01-29 12:14:53'),(37,11,'Routes','routes',1,1,1,1,'2018-06-22 10:39:17','2026-01-29 12:14:53'),(38,11,'Vehicle','vehicle',1,1,1,1,'2018-06-22 10:39:36','2026-01-29 12:14:53'),(39,11,'Assign Vehicle','assign_vehicle',1,1,1,1,'2018-06-27 04:39:20','2026-01-29 12:14:53'),(40,12,'Hostel','hostel',1,1,1,1,'2018-06-22 10:40:49','2026-01-29 12:14:53'),(41,12,'Room Type','room_type',1,1,1,1,'2018-06-22 10:40:27','2026-01-29 12:14:53'),(42,12,'Hostel Rooms','hostel_rooms',1,1,1,1,'2018-06-25 06:23:03','2026-01-29 12:14:53'),(43,13,'Notice Board','notice_board',1,1,1,1,'2018-06-22 10:41:17','2026-01-29 12:14:53'),(44,13,'Email','email',1,0,0,0,'2019-11-26 05:20:37','2026-01-29 12:14:53'),(46,13,'Email / SMS Log','email_sms_log',1,0,0,0,'2018-06-22 10:41:23','2026-01-29 12:14:53'),(53,15,'Languages','languages',0,1,0,1,'2021-01-23 07:09:32','2026-01-29 12:14:53'),(54,15,'General Setting','general_setting',1,0,1,0,'2018-07-05 09:08:35','2026-01-29 12:14:53'),(55,15,'Session Setting','session_setting',1,1,1,1,'2018-06-22 10:44:15','2026-01-29 12:14:53'),(56,15,'Notification Setting','notification_setting',1,0,1,0,'2018-07-05 09:08:41','2026-01-29 12:14:53'),(57,15,'SMS Setting','sms_setting',1,0,1,0,'2018-07-05 09:08:47','2026-01-29 12:14:53'),(58,15,'Email Setting','email_setting',1,0,1,0,'2018-07-05 09:08:51','2026-01-29 12:14:53'),(59,15,'Front CMS Setting','front_cms_setting',1,0,1,0,'2018-07-05 09:08:55','2026-01-29 12:14:53'),(60,15,'Payment Methods','payment_methods',1,0,1,0,'2018-07-05 09:08:59','2026-01-29 12:14:53'),(61,16,'Menus','menus',1,1,0,1,'2018-07-09 03:50:06','2026-01-29 12:14:53'),(62,16,'Media Manager','media_manager',1,1,0,1,'2018-07-09 03:50:26','2026-01-29 12:14:53'),(63,16,'Banner Images','banner_images',1,1,0,1,'2018-06-22 10:46:02','2026-01-29 12:14:53'),(64,16,'Pages','pages',1,1,1,1,'2018-06-22 10:46:21','2026-01-29 12:14:53'),(65,16,'Gallery','gallery',1,1,1,1,'2018-06-22 10:47:02','2026-01-29 12:14:53'),(66,16,'Event','event',1,1,1,1,'2018-06-22 10:47:20','2026-01-29 12:14:53'),(67,16,'News','notice',1,1,1,1,'2018-07-03 08:39:34','2026-01-29 12:14:53'),(68,2,'Fees Group Assign','fees_group_assign',1,0,0,0,'2018-06-22 10:20:42','2026-01-29 12:14:53'),(69,2,'Fees Type','fees_type',1,1,1,1,'2018-06-22 10:19:34','2026-01-29 12:14:53'),(70,2,'Fees Discount','fees_discount',1,1,1,1,'2018-06-22 10:20:10','2026-01-29 12:14:53'),(71,2,'Fees Discount Assign','fees_discount_assign',1,0,0,0,'2018-06-22 10:20:17','2026-01-29 12:14:53'),(73,2,'Search Fees Payment','search_fees_payment',1,0,0,0,'2018-06-22 10:20:27','2026-01-29 12:14:53'),(74,2,'Search Due Fees','search_due_fees',1,0,0,0,'2018-06-22 10:20:35','2026-01-29 12:14:53'),(77,7,'Assign Class Teacher','assign_class_teacher',1,1,1,1,'2018-06-22 10:30:52','2026-01-29 12:14:53'),(78,17,'Admission Enquiry','admission_enquiry',1,1,1,1,'2018-06-22 10:51:24','2026-01-29 12:14:53'),(79,17,'Follow Up Admission Enquiry','follow_up_admission_enquiry',1,1,0,1,'2018-06-22 10:51:39','2026-01-29 12:14:53'),(80,17,'Visitor Book','visitor_book',1,1,1,1,'2018-06-22 10:48:58','2026-01-29 12:14:53'),(81,17,'Phone Call Log','phone_call_log',1,1,1,1,'2018-06-22 10:50:57','2026-01-29 12:14:53'),(82,17,'Postal Dispatch','postal_dispatch',1,1,1,1,'2018-06-22 10:50:21','2026-01-29 12:14:53'),(83,17,'Postal Receive','postal_receive',1,1,1,1,'2018-06-22 10:50:04','2026-01-29 12:14:53'),(84,17,'Complain','complaint',1,1,1,1,'2018-07-03 08:40:55','2026-01-29 12:14:53'),(85,17,'Setup Front Office','setup_font_office',1,1,1,1,'2025-02-13 09:03:14','2026-01-29 12:14:53'),(86,18,'Staff','staff',1,1,1,1,'2018-06-22 10:53:31','2026-01-29 12:14:53'),(87,18,'Disable Staff','disable_staff',1,0,0,0,'2018-06-22 10:53:12','2026-01-29 12:14:53'),(88,18,'Staff Attendance','staff_attendance',1,1,1,0,'2018-06-22 10:53:10','2026-01-29 12:14:53'),(90,18,'Staff Payroll','staff_payroll',1,1,0,1,'2018-06-22 10:52:51','2026-01-29 12:14:53'),(93,19,'Homework','homework',1,1,1,1,'2018-06-22 10:53:50','2026-01-29 12:14:53'),(94,19,'Homework Evaluation','homework_evaluation',1,1,0,0,'2018-06-27 03:07:21','2026-01-29 12:14:53'),(96,20,'Student Certificate','student_certificate',1,1,1,1,'2018-07-06 10:41:07','2026-01-29 12:14:53'),(97,20,'Generate Certificate','generate_certificate',1,0,0,0,'2018-07-06 10:37:16','2026-01-29 12:14:53'),(98,20,'Student ID Card','student_id_card',1,1,1,1,'2018-07-06 10:41:28','2026-01-29 12:14:53'),(99,20,'Generate ID Card','generate_id_card',1,0,0,0,'2018-07-06 10:41:49','2026-01-29 12:14:53'),(102,21,'Calendar To Do List','calendar_to_do_list',1,1,1,1,'2018-06-22 10:54:41','2026-01-29 12:14:53'),(104,10,'Item Category','item_category',1,1,1,1,'2018-06-22 10:34:33','2026-01-29 12:14:53'),(106,22,'Quick Session Change','quick_session_change',1,0,0,0,'2018-06-22 10:54:45','2026-01-29 12:14:53'),(107,1,'Disable Student','disable_student',1,0,0,0,'2018-06-25 06:21:34','2026-01-29 12:14:53'),(108,18,' Approve Leave Request','approve_leave_request',1,0,1,1,'2020-10-05 08:56:27','2026-01-29 12:14:53'),(109,18,'Apply Leave','apply_leave',1,1,0,0,'2019-11-28 23:47:46','2026-01-29 12:14:53'),(110,18,'Leave Types ','leave_types',1,1,1,1,'2018-07-02 10:17:56','2026-01-29 12:14:53'),(111,18,'Department','department',1,1,1,1,'2018-06-26 03:57:07','2026-01-29 12:14:53'),(112,18,'Designation','designation',1,1,1,1,'2018-06-26 03:57:07','2026-01-29 12:14:53'),(113,22,'Fees Collection And Expense Monthly Chart','fees_collection_and_expense_monthly_chart',1,0,0,0,'2018-07-03 07:08:15','2026-01-29 12:14:53'),(114,22,'Fees Collection And Expense Yearly Chart','fees_collection_and_expense_yearly_chart',1,0,0,0,'2018-07-03 07:08:15','2026-01-29 12:14:53'),(115,22,'Monthly Fees Collection Widget','Monthly fees_collection_widget',1,0,0,0,'2018-07-03 07:13:35','2026-01-29 12:14:53'),(116,22,'Monthly Expense Widget','monthly_expense_widget',1,0,0,0,'2018-07-03 07:13:35','2026-01-29 12:14:53'),(117,22,'Student Count Widget','student_count_widget',1,0,0,0,'2018-07-03 07:13:35','2026-01-29 12:14:53'),(118,22,'Staff Role Count Widget','staff_role_count_widget',1,0,0,0,'2018-07-03 07:13:35','2026-01-29 12:14:53'),(122,5,'Attendance By Date','attendance_by_date',1,0,0,0,'2018-07-03 08:42:29','2026-01-29 12:14:53'),(123,9,'Add Student','add_student',1,0,0,0,'2018-07-03 08:42:29','2026-01-29 12:14:53'),(126,15,'User Status','user_status',1,0,0,0,'2018-07-03 08:42:29','2026-01-29 12:14:53'),(127,18,'Can See Other Users Profile','can_see_other_users_profile',1,0,0,0,'2018-07-03 08:42:29','2026-01-29 12:14:53'),(128,1,'Student Timeline','student_timeline',1,1,1,1,'2022-12-28 09:52:24','2026-01-29 12:14:53'),(129,18,'Staff Timeline','staff_timeline',1,1,1,1,'2022-12-28 09:52:24','2026-01-29 12:14:53'),(130,15,'Backup','backup',1,1,0,1,'2018-07-09 04:17:17','2026-01-29 12:14:53'),(131,15,'Restore','restore',1,0,0,0,'2018-07-09 04:17:17','2026-01-29 12:14:53'),(134,1,'Disable Reason','disable_reason',1,1,1,1,'2019-11-27 06:39:21','2026-01-29 12:14:53'),(135,2,'Fees Reminder','fees_reminder',1,0,1,0,'2019-10-25 00:39:49','2026-01-29 12:14:53'),(136,5,'Approve Leave','approve_leave',1,1,1,1,'2022-12-28 09:52:24','2026-01-29 12:14:53'),(137,6,'Exam Group','exam_group',1,1,1,1,'2019-10-25 01:02:34','2026-01-29 12:14:53'),(141,6,'Design Admit Card','design_admit_card',1,1,1,1,'2019-10-25 01:06:59','2026-01-29 12:14:53'),(142,6,'Print Admit Card','print_admit_card',1,0,0,0,'2019-11-23 23:57:51','2026-01-29 12:14:53'),(143,6,'Design Marksheet','design_marksheet',1,1,1,1,'2019-10-25 01:10:25','2026-01-29 12:14:53'),(144,6,'Print Marksheet','print_marksheet',1,0,0,0,'2019-10-25 01:11:02','2026-01-29 12:14:53'),(145,7,'Teachers Timetable','teachers_time_table',1,0,0,0,'2019-11-30 02:52:21','2026-01-29 12:14:53'),(146,14,'Student Report','student_report',1,0,0,0,'2019-10-25 01:27:00','2026-01-29 12:14:53'),(147,14,'Guardian Report','guardian_report',1,0,0,0,'2019-10-25 01:30:27','2026-01-29 12:14:53'),(148,14,'Student History','student_history',1,0,0,0,'2019-10-25 01:39:07','2026-01-29 12:14:53'),(149,14,'Student Login Credential Report','student_login_credential_report',1,0,0,0,'2019-10-25 01:39:07','2026-01-29 12:14:53'),(150,14,'Class Subject Report','class_subject_report',1,0,0,0,'2019-10-25 01:39:07','2026-01-29 12:14:53'),(151,14,'Admission Report','admission_report',1,0,0,0,'2019-10-25 01:39:07','2026-01-29 12:14:53'),(152,14,'Sibling Report','sibling_report',1,0,0,0,'2019-10-25 01:39:07','2026-01-29 12:14:53'),(153,14,'Homework Evaluation Report','homehork_evaluation_report',1,0,0,0,'2019-11-24 01:04:24','2026-01-29 12:14:53'),(154,14,'Student Profile','student_profile',1,0,0,0,'2019-10-25 01:39:07','2026-01-29 12:14:53'),(155,14,'Fees Statement','fees_statement',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(156,14,'Balance Fees Report','balance_fees_report',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(157,14,'Fees Collection Report','fees_collection_report',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(158,14,'Online Fees Collection Report','online_fees_collection_report',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(159,14,'Income Report','income_report',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(160,14,'Expense Report','expense_report',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(161,14,'PayRoll Report','payroll_report',1,0,0,0,'2019-10-31 00:23:22','2026-01-29 12:14:53'),(162,14,'Income Group Report','income_group_report',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(163,14,'Expense Group Report','expense_group_report',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(164,14,'Attendance Report','attendance_report',1,0,0,0,'2019-10-25 02:08:06','2026-01-29 12:14:53'),(165,14,'Staff Attendance Report','staff_attendance_report',1,0,0,0,'2019-10-25 02:08:06','2026-01-29 12:14:53'),(174,14,'Transport Report','transport_report',1,0,0,0,'2019-10-25 02:13:56','2026-01-29 12:14:53'),(175,14,'Hostel Report','hostel_report',1,0,0,0,'2019-11-27 06:51:53','2026-01-29 12:14:53'),(176,14,'Audit Trail Report','audit_trail_report',1,0,0,0,'2019-10-25 02:16:39','2026-01-29 12:14:53'),(177,14,'User Log','user_log',1,0,0,0,'2019-10-25 02:19:27','2026-01-29 12:14:53'),(178,14,'Book Issue Report','book_issue_report',1,0,0,0,'2019-10-25 02:29:04','2026-01-29 12:14:53'),(179,14,'Book Due Report','book_due_report',1,0,0,0,'2019-10-25 02:29:04','2026-01-29 12:14:53'),(180,14,'Book Inventory Report','book_inventory_report',1,0,0,0,'2019-10-25 02:29:04','2026-01-29 12:14:53'),(181,14,'Stock Report','stock_report',1,0,0,0,'2019-10-25 02:31:28','2026-01-29 12:14:53'),(182,14,'Add Item Report','add_item_report',1,0,0,0,'2019-10-25 02:31:28','2026-01-29 12:14:53'),(183,14,'Issue Item Report','issue_item_report',1,0,0,0,'2019-11-29 03:48:06','2026-01-29 12:14:53'),(185,23,'Online Examination','online_examination',1,1,1,1,'2019-11-23 23:54:50','2026-01-29 12:14:53'),(186,23,'Question Bank','question_bank',1,1,1,1,'2019-11-23 23:55:18','2026-01-29 12:14:53'),(187,6,'Exam Result','exam_result',1,0,0,0,'2019-11-23 23:58:50','2026-01-29 12:14:53'),(188,7,'Subject Group','subject_group',1,1,1,1,'2019-11-24 00:34:32','2026-01-29 12:14:53'),(189,18,'Teachers Rating','teachers_rating',1,0,1,1,'2019-11-24 03:12:54','2026-01-29 12:14:53'),(190,22,'Fees Awaiting Payment Widegts','fees_awaiting_payment_widegts',1,0,0,0,'2019-11-24 00:52:51','2026-01-29 12:14:53'),(191,22,'Converted Leads Widegts','conveted_leads_widegts',1,0,0,0,'2025-02-13 09:03:14','2026-01-29 12:14:53'),(192,22,'Fees Overview Widegts','fees_overview_widegts',1,0,0,0,'2019-11-24 00:57:41','2026-01-29 12:14:53'),(193,22,'Enquiry Overview Widegts','enquiry_overview_widegts',1,0,0,0,'2019-12-02 05:06:09','2026-01-29 12:14:53'),(194,22,'Library Overview Widegts','book_overview_widegts',1,0,0,0,'2019-12-01 01:13:04','2026-01-29 12:14:53'),(195,22,'Student Today Attendance Widegts','today_attendance_widegts',1,0,0,0,'2019-12-03 04:57:45','2026-01-29 12:14:53'),(196,6,'Marks Import','marks_import',1,0,0,0,'2019-11-24 01:02:11','2026-01-29 12:14:53'),(197,14,'Student Attendance Type Report','student_attendance_type_report',1,0,0,0,'2019-11-24 01:06:32','2026-01-29 12:14:53'),(198,14,'Exam Marks Report','exam_marks_report',1,0,0,0,'2019-11-24 01:11:15','2026-01-29 12:14:53'),(200,14,'Online Exam Wise Report','online_exam_wise_report',1,0,0,0,'2019-11-24 01:18:14','2026-01-29 12:14:53'),(201,14,'Online Exams Report','online_exams_report',1,0,0,0,'2019-11-29 02:48:05','2026-01-29 12:14:53'),(202,14,'Online Exams Attempt Report','online_exams_attempt_report',1,0,0,0,'2019-11-29 02:46:24','2026-01-29 12:14:53'),(203,14,'Online Exams Rank Report','online_exams_rank_report',1,0,0,0,'2019-11-24 01:22:25','2026-01-29 12:14:53'),(204,14,'Staff Report','staff_report',1,0,0,0,'2019-11-24 01:25:27','2026-01-29 12:14:53'),(205,6,'Exam','exam',1,1,1,1,'2019-11-24 04:55:48','2026-01-29 12:14:53'),(207,6,'Exam Publish','exam_publish',1,0,0,0,'2019-11-24 05:15:04','2026-01-29 12:14:53'),(208,6,'Link Exam','link_exam',1,0,1,0,'2019-11-24 05:15:04','2026-01-29 12:14:53'),(210,6,'Assign / View student','exam_assign_view_student',1,0,1,0,'2019-11-24 05:15:04','2026-01-29 12:14:53'),(211,6,'Exam Subject','exam_subject',1,0,1,0,'2019-11-24 05:15:04','2026-01-29 12:14:53'),(212,6,'Exam Marks','exam_marks',1,0,1,0,'2019-11-24 05:15:04','2026-01-29 12:14:53'),(213,15,'Language Switcher','language_switcher',1,0,0,0,'2019-11-24 05:17:11','2026-01-29 12:14:53'),(214,23,'Add Questions in Exam ','add_questions_in_exam',1,0,1,0,'2019-11-28 01:38:57','2026-01-29 12:14:53'),(215,15,'Custom Fields','custom_fields',1,0,0,0,'2019-11-29 04:08:35','2026-01-29 12:14:53'),(216,15,'System Fields','system_fields',1,0,0,0,'2019-11-25 00:15:01','2026-01-29 12:14:53'),(217,13,'SMS','sms',1,0,0,0,'2018-06-22 10:40:54','2026-01-29 12:14:53'),(219,14,'Student / Period Attendance Report','student_period_attendance_report',1,0,0,0,'2019-11-29 02:19:31','2026-01-29 12:14:53'),(220,14,'Biometric Attendance Log','biometric_attendance_log',1,0,0,0,'2019-11-27 05:59:16','2026-01-29 12:14:53'),(221,14,'Book Issue Return Report','book_issue_return_report',1,0,0,0,'2019-11-27 06:30:23','2026-01-29 12:14:53'),(222,23,'Assign / View Student','online_assign_view_student',1,0,1,0,'2019-11-28 04:20:22','2026-01-29 12:14:53'),(223,14,'Rank Report','rank_report',1,0,0,0,'2019-11-29 02:30:21','2026-01-29 12:14:53'),(224,25,'Chat','chat',1,0,0,0,'2019-11-29 04:10:28','2026-01-29 12:14:53'),(226,22,'Income Donut Graph','income_donut_graph',1,0,0,0,'2019-11-29 05:00:33','2026-01-29 12:14:53'),(227,22,'Expense Donut Graph','expense_donut_graph',1,0,0,0,'2019-11-29 05:01:10','2026-01-29 12:14:53'),(228,9,'Import Book','import_book',1,0,0,0,'2019-11-29 06:21:01','2026-01-29 12:14:53'),(229,22,'Staff Present Today Widegts','staff_present_today_widegts',1,0,0,0,'2019-11-29 06:48:00','2026-01-29 12:14:53'),(230,22,'Student Present Today Widegts','student_present_today_widegts',1,0,0,0,'2019-11-29 06:47:42','2026-01-29 12:14:53'),(231,26,'Multi Class Student','multi_class_student',1,1,1,1,'2020-10-05 08:56:27','2026-01-29 12:14:53'),(232,27,'Online Admission','online_admission',1,0,1,1,'2019-12-02 06:11:10','2026-01-29 12:14:53'),(233,15,'Print Header Footer','print_header_footer',1,0,0,0,'2020-02-12 02:02:02','2026-01-29 12:14:53'),(234,28,'Manage Alumni','manage_alumni',1,1,1,1,'2020-06-02 03:15:46','2026-01-29 12:14:53'),(235,28,'Events','events',1,1,1,1,'2020-05-28 21:48:52','2026-01-29 12:14:53'),(236,29,'Manage Lesson Plan','manage_lesson_plan',1,1,1,0,'2020-05-28 22:17:37','2026-01-29 12:14:53'),(237,29,'Manage Syllabus Status','manage_syllabus_status',1,0,1,0,'2020-05-28 22:20:11','2026-01-29 12:14:53'),(238,29,'Lesson','lesson',1,1,1,1,'2020-05-28 22:20:11','2026-01-29 12:14:53'),(239,29,'Topic','topic',1,1,1,1,'2020-05-28 22:20:11','2026-01-29 12:14:53'),(240,14,'Syllabus Status Report','syllabus_status_report',1,0,0,0,'2020-05-28 23:17:54','2026-01-29 12:14:53'),(241,14,'Teacher Syllabus Status Report','teacher_syllabus_status_report',1,0,0,0,'2020-05-28 23:17:54','2026-01-29 12:14:53'),(242,14,'Alumni Report','alumni_report',1,0,0,0,'2020-06-07 23:59:54','2026-01-29 12:14:53'),(243,15,'Student Profile Update','student_profile_update',1,0,0,0,'2020-08-21 05:36:33','2026-01-29 12:14:53'),(244,14,'Student Gender Ratio Report','student_gender_ratio_report',1,0,0,0,'2020-08-22 12:37:51','2026-01-29 12:14:53'),(245,14,'Student Teacher Ratio Report','student_teacher_ratio_report',1,0,0,0,'2020-08-22 12:42:27','2026-01-29 12:14:53'),(246,14,'Daily Attendance Report','daily_attendance_report',1,0,0,0,'2020-08-22 12:43:16','2026-01-29 12:14:53'),(247,23,'Import Question','import_question',1,0,0,0,'2019-11-23 18:25:18','2026-01-29 12:14:53'),(248,20,'Staff ID Card','staff_id_card',1,1,1,1,'2018-07-06 10:41:28','2026-01-29 12:14:53'),(249,20,'Generate Staff ID Card','generate_staff_id_card',1,0,0,0,'2018-07-06 10:41:49','2026-01-29 12:14:53'),(250,19,'Daily Assignment','daily_assignment',1,0,0,0,'2022-03-02 07:28:23','2026-01-29 12:14:53'),(251,6,'Marks Division','marks_division',1,1,1,1,'2022-07-01 15:24:16','2026-01-29 12:14:53'),(252,13,'Schedule Email SMS Log','schedule_email_sms_log',1,0,1,0,'2022-07-09 11:25:16','2026-01-29 12:14:53'),(253,13,'Login Credentials Send','login_credentials_send',1,0,0,0,'2022-07-01 15:46:10','2026-01-29 12:14:53'),(254,13,'Email Template','email_template',1,1,1,1,'2022-07-01 15:46:10','2026-01-29 12:14:53'),(255,13,'SMS Template','sms_template',1,1,1,1,'2022-07-01 15:46:10','2026-01-29 12:14:53'),(256,14,'Balance Fees Report With Remark','balance_fees_report_with_remark',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(257,14,'Balance Fees Statement','balance_fees_statement',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(258,14,'Daily Collection Report','daily_collection_report',1,0,0,0,'2019-10-25 01:55:52','2026-01-29 12:14:53'),(259,11,'Fees Master','transport_fees_master',1,0,1,0,'2022-07-05 09:29:19','2026-01-29 12:14:53'),(260,11,'Pickup Point','pickup_point',1,1,1,1,'2022-07-04 09:50:08','2026-01-29 12:14:53'),(261,11,'Route Pickup Point','route_pickup_point',1,1,1,1,'2022-07-04 09:50:08','2026-01-29 12:14:53'),(262,11,'Student Transport Fees','student_transport_fees',1,1,1,0,'2022-07-05 10:15:55','2026-01-29 12:14:53'),(263,29,'Comments','lesson_plan_comments',1,1,0,1,'2020-05-28 22:20:11','2026-01-29 12:14:53'),(264,15,'Sidebar Menu','sidebar_menu',1,0,0,0,'2022-07-11 12:01:17','2026-01-29 12:14:53'),(265,15,'Currency','currency',1,0,0,0,'2020-08-21 05:36:33','2026-01-29 12:14:53'),(266,6,'Exam Schedule','exam_schedule',1,0,0,0,'2019-11-23 23:58:50','2026-01-29 12:14:53'),(267,6,'Generate Rank','generate_rank',1,0,0,0,'2019-11-24 05:15:04','2026-01-29 12:14:53'),(268,8,'Content Type','content_type',1,1,1,1,'2022-07-08 05:18:54','2026-01-29 12:14:53'),(269,8,'Content Share List','content_share_list',1,0,0,1,'2022-07-08 05:18:58','2026-01-29 12:14:53'),(270,8,'Video Tutorial','video_tutorial',1,1,1,1,'2022-07-08 05:19:01','2026-01-29 12:14:53'),(271,15,'Currency Switcher','currency_switcher',1,0,0,0,'2019-11-24 05:17:11','2026-01-29 12:14:53'),(272,2,'Offline Bank Payments','offline_bank_payments',1,0,0,0,'2018-06-27 00:18:15','2026-01-29 12:14:53'),(273,29,'Copy Old Lessons','copy_old_lesson',1,0,0,0,'2020-05-28 22:20:11','2026-01-29 12:14:53'),(274,30,'Annual Calendar','annual_calendar',1,1,1,1,'2020-05-28 22:20:11','2026-01-29 12:14:53'),(275,30,'Holiday Type','holiday_type',1,1,1,1,'2024-10-14 12:31:14','2026-01-29 12:14:53'),(276,14,'Online Admission Report','online_admission_report',1,0,0,0,'2020-08-22 12:42:27','2026-01-29 12:14:53'),(277,31,'Download CV','download_cv',1,0,0,0,'2024-12-10 11:06:30','2026-01-29 12:14:53'),(278,31,'Build CV','build_cv',1,1,0,1,'2024-12-13 07:05:10','2026-01-29 12:14:53'),(279,31,'Setting','download_cv_setting',1,0,0,0,'2024-12-10 11:06:30','2026-01-29 12:14:53'),(280,22,'Student Head Count Widget','student_head_count_widget',1,0,0,0,'2018-07-03 07:13:35','2026-01-29 12:14:53'),(281,22,'Staff Approved Leave Widegts','staff_approved_leave_widegts',1,0,0,0,'2018-07-03 07:13:35','2026-01-29 12:14:53'),(282,22,'Student Approved Leave Widegts','student_approved_leave_widegts',1,0,0,0,'2018-07-03 07:13:35','2026-01-29 12:14:53'),(283,32,'TVET Programme','tvet_programme',1,1,1,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(284,32,'TVET Qualification','tvet_qualification',1,1,1,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(285,32,'TVET Level','tvet_level',1,1,1,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(286,32,'TVET Cohort','tvet_cohort',1,1,1,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(287,32,'TVET Module Mapping','tvet_module_mapping',1,1,0,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(288,32,'TVET Lecturer Allocation','tvet_lecturer_allocation',1,1,0,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(289,32,'TVET Reports','tvet_reports',1,0,0,0,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(5011,501,'Setting','setting',1,0,1,0,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(5012,501,'Live Classes','live_classes',1,1,0,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(5013,501,'Live Meeting','live_meeting',1,1,0,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(5020,1,'Disability Types','disability_types',1,1,1,1,'2026-01-29 14:45:11','2026-01-29 14:45:11'),(5021,1,'Disabled Students Report','disabled_students_report',1,0,0,0,'2026-01-29 14:45:11','2026-01-29 14:45:11'),(5030,1,'Exam Moderation','exam_moderation',1,0,1,0,'2026-01-29 17:03:35','2026-01-29 17:03:35'),(5031,1,'TVET Attendance','tvet_attendance',1,1,1,0,'2026-01-30 15:14:48','2026-01-30 15:14:48'),(5032,1,'TVET Assessments','tvet_assessment',1,1,1,1,'2026-01-30 15:14:48','2026-01-30 15:14:48'),(5033,1,'ICASS Configuration','tvet_icass_config',1,1,1,1,'2026-01-30 15:16:07','2026-01-30 15:16:07'),(5034,1,'Qualification Requirements','tvet_qualification_requirements',1,1,1,1,'2026-01-30 15:16:07','2026-01-30 15:16:07'),(5035,1,'POE Management','tvet_poe',1,1,1,1,'2026-01-30 15:16:07','2026-01-30 15:16:07'),(5036,1,'Academic Dashboard','academic_dashboard',1,0,0,0,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5037,1,'Academic Programmes','academic_programmes',1,1,1,1,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5038,1,'Academic Subjects','academic_subjects',1,1,1,1,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5039,1,'Academic Levels','academic_levels',1,1,1,1,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5040,1,'Academic Subject Levels','academic_subject_levels',1,1,1,1,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5041,1,'Academic Classes','academic_classes',1,1,1,1,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5042,1,'Academic Enrolment','academic_enrolment',1,1,1,1,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5043,1,'Academic Attendance','academic_attendance',1,1,1,0,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5044,1,'Academic Assessments','academic_assessments',1,1,1,1,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5045,1,'Academic Marks','academic_marks',1,1,1,0,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5046,1,'Academic Reports','academic_reports',1,0,0,0,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5047,1,'Academic Timetable','academic_timetable',1,1,1,1,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5048,1,'Academic POE','academic_poe',1,1,1,1,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5049,1,'Academic ICASS','academic_icass',1,1,1,0,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5050,1,'Academic Moderation','academic_moderation',1,1,1,0,'2026-01-30 15:47:50','2026-01-30 15:47:50'),(5051,15,'Programmes','programmes',1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(5052,15,'Qualifications','qualifications',1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(5053,15,'Levels','levels',1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(5054,15,'Subject Levels','subject_levels',1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(5055,15,'Classes','classes',1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(5056,15,'Student Programme','student_programme',1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(5057,15,'Enrolment','enrolment',1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56');
/*!40000 ALTER TABLE `permission_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_group`
--

DROP TABLE IF EXISTS `permission_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `short_code` varchar(100) NOT NULL,
  `is_active` int DEFAULT '0',
  `system` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=502 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_group`
--

LOCK TABLES `permission_group` WRITE;
/*!40000 ALTER TABLE `permission_group` DISABLE KEYS */;
INSERT INTO `permission_group` VALUES (1,'Student Information','student_information',1,1,'2019-03-15 09:30:22','2026-01-29 12:14:53'),(2,'Fees Collection','fees_collection',1,0,'2020-06-11 00:51:35','2026-01-29 12:14:53'),(3,'Income','income',1,0,'2020-06-01 01:57:39','2026-01-29 12:14:53'),(4,'Expense','expense',1,0,'2019-03-15 09:06:22','2026-01-29 12:14:53'),(5,'Student Attendance','student_attendance',1,0,'2018-07-02 07:48:08','2026-01-29 12:14:53'),(6,'Examination','examination',1,0,'2018-07-11 02:49:08','2026-01-29 12:14:53'),(7,'Academics','academics',1,1,'2018-07-02 07:25:43','2026-01-29 12:14:53'),(8,'Download Center','download_center',1,0,'2018-07-02 07:49:29','2026-01-29 12:14:53'),(9,'Library','library',1,0,'2018-06-28 11:13:14','2026-01-29 12:14:53'),(10,'Inventory','inventory',1,0,'2018-06-27 00:48:58','2026-01-29 12:14:53'),(11,'Transport','transport',1,0,'2018-06-27 07:51:26','2026-01-29 12:14:53'),(12,'Hostel','hostel',1,0,'2018-07-02 07:49:32','2026-01-29 12:14:53'),(13,'Communicate','communicate',1,0,'2018-07-02 07:50:00','2026-01-29 12:14:53'),(14,'Reports','reports',1,1,'2018-06-27 03:40:22','2026-01-29 12:14:53'),(15,'System Settings','system_settings',1,1,'2018-06-27 03:40:28','2026-01-29 12:14:53'),(16,'Front CMS','front_cms',1,0,'2018-07-10 05:16:54','2026-01-29 12:14:53'),(17,'Front Office','front_office',1,0,'2018-06-27 03:45:30','2026-01-29 12:14:53'),(18,'Human Resource','human_resource',1,1,'2018-06-27 03:41:02','2026-01-29 12:14:53'),(19,'Homework','homework',1,0,'2018-06-27 00:49:38','2026-01-29 12:14:53'),(20,'Certificate','certificate',1,0,'2018-06-27 07:51:29','2026-01-29 12:14:53'),(21,'Calendar To Do List','calendar_to_do_list',1,0,'2019-03-15 09:06:25','2026-01-29 12:14:53'),(22,'Dashboard and Widgets','dashboard_and_widgets',1,1,'2018-06-27 03:41:17','2026-01-29 12:14:53'),(23,'Online Examination','online_examination',1,0,'2020-06-01 02:25:36','2026-01-29 12:14:53'),(25,'Chat','chat',1,0,'2019-11-23 23:54:04','2026-01-29 12:14:53'),(26,'Multi Class','multi_class',1,0,'2019-11-27 12:14:14','2026-01-29 12:14:53'),(27,'Online Admission','online_admission',1,0,'2019-11-27 02:42:13','2026-01-29 12:14:53'),(28,'Alumni','alumni',1,0,'2020-05-29 00:26:38','2026-01-29 12:14:53'),(29,'Lesson Plan','lesson_plan',1,0,'2020-06-07 05:38:30','2026-01-29 12:14:53'),(30,'Annual Calendar','annual_calendar',1,0,'2024-10-22 10:45:56','2026-01-29 12:14:53'),(31,'Student CV','student_cv',1,0,'2024-12-13 11:54:57','2026-01-29 12:14:53'),(32,'TVET Management','tvet_management',1,0,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(501,'Teams Live Classes','teams_live_classes',1,0,'2026-01-29 12:15:00','2026-01-29 12:15:00');
/*!40000 ALTER TABLE `permission_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission_student`
--

DROP TABLE IF EXISTS `permission_student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission_student` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `short_code` varchar(100) NOT NULL,
  `system` int NOT NULL,
  `student` int NOT NULL,
  `parent` int NOT NULL,
  `group_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `permission_student_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `permission_group` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission_student`
--

LOCK TABLES `permission_student` WRITE;
/*!40000 ALTER TABLE `permission_student` DISABLE KEYS */;
INSERT INTO `permission_student` VALUES (1,'Fees','fees',0,1,1,2,'2020-06-11 00:51:35','2026-01-29 12:14:53'),(2,'Class Timetable','class_timetable',1,1,1,7,'2020-05-30 19:57:50','2026-01-29 12:14:53'),(3,'Homework','homework',0,1,1,19,'2020-06-01 02:49:14','2026-01-29 12:14:53'),(4,'Download Center','download_center',0,1,1,8,'2020-06-01 02:52:49','2026-01-29 12:14:53'),(5,'Attendance','attendance',0,1,1,5,'2020-06-01 02:57:18','2026-01-29 12:14:53'),(7,'Examinations','examinations',0,1,1,6,'2020-06-01 02:59:50','2026-01-29 12:14:53'),(8,'Notice Board','notice_board',0,1,1,13,'2020-06-01 03:00:35','2026-01-29 12:14:53'),(11,'Library','library',0,1,1,9,'2020-06-01 03:02:37','2026-01-29 12:14:53'),(12,'Transport Routes','transport_routes',0,1,1,11,'2020-06-01 03:51:30','2026-01-29 12:14:53'),(13,'Hostel Rooms','hostel_rooms',0,1,1,12,'2020-06-01 03:52:27','2026-01-29 12:14:53'),(14,'Calendar To Do List','calendar_to_do_list',0,1,1,21,'2020-06-01 03:53:18','2026-01-29 12:14:53'),(15,'Online Examination','online_examination',0,1,1,23,'2020-06-11 05:20:01','2026-01-29 12:14:53'),(16,'Teachers Rating','teachers_rating',0,1,1,NULL,'2022-12-28 09:52:28','2026-01-29 12:14:53'),(17,'Chat','chat',0,1,1,25,'2020-06-01 04:53:06','2026-01-29 12:14:53'),(18,'Multi Class','multi_class',1,1,1,26,'2020-05-30 19:56:52','2026-01-29 12:14:53'),(19,'Lesson Plan','lesson_plan',0,1,1,29,'2020-06-07 05:38:30','2026-01-29 12:14:53'),(20,'Syllabus Status','syllabus_status',0,1,1,29,'2020-06-07 05:38:30','2026-01-29 12:14:53'),(23,'Apply Leave','apply_leave',0,1,1,NULL,'2022-12-28 09:52:28','2026-01-29 12:14:53'),(24,'Visitor Book','visitor_book',0,1,1,NULL,'2022-10-10 11:45:18','2026-01-29 12:14:53'),(25,'Student Timeline','student_timeline',0,1,1,NULL,'2022-10-11 04:50:29','2026-01-29 12:14:53');
/*!40000 ALTER TABLE `permission_student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pickup_point`
--

DROP TABLE IF EXISTS `pickup_point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pickup_point` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `latitude` varchar(100) DEFAULT NULL,
  `longitude` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pickup_point`
--

LOCK TABLES `pickup_point` WRITE;
/*!40000 ALTER TABLE `pickup_point` DISABLE KEYS */;
/*!40000 ALTER TABLE `pickup_point` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `print_headerfooter`
--

DROP TABLE IF EXISTS `print_headerfooter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `print_headerfooter` (
  `id` int NOT NULL AUTO_INCREMENT,
  `print_type` varchar(255) NOT NULL,
  `header_image` varchar(255) NOT NULL,
  `footer_content` text NOT NULL,
  `created_by` int NOT NULL,
  `entry_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `print_headerfooter`
--

LOCK TABLES `print_headerfooter` WRITE;
/*!40000 ALTER TABLE `print_headerfooter` DISABLE KEYS */;
INSERT INTO `print_headerfooter` VALUES (1,'staff_payslip','header_image.jpg','This payslip is computer generated hence no signature is required.',1,'2020-02-28 15:41:08','2022-12-28 09:52:24','2026-01-29 12:14:53'),(2,'student_receipt','header_image.jpg','This receipt is computer generated hence no signature is required.',1,'2020-02-28 15:40:58','2022-12-28 09:52:24','2026-01-29 12:14:53'),(3,'online_admission_receipt','header_image.jpg','This receipt is for online admission  computer ffffffff generated hence no signature is required.',1,'2021-05-27 12:50:24','2022-12-28 09:52:24','2026-01-29 12:14:53'),(4,'online_exam','1655913577-198504634062b33c698fde1!online-exam.jpg','This receipt is for online exam computer  generated hence no signature is required.',1,'2022-08-30 12:58:46','2022-09-08 17:28:34','2026-01-29 12:14:53'),(5,'general_purpose','header_image.jpg','<h1>\r\n\r\n</h1><p>footer text here ....</p>',1,'2025-02-05 07:26:06','2022-09-08 17:28:34','2026-01-29 12:14:53');
/*!40000 ALTER TABLE `print_headerfooter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programme`
--

DROP TABLE IF EXISTS `programme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programme` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL COMMENT 'e.g., NATED, NCV',
  `name` varchar(200) NOT NULL,
  `description` text,
  `programme_type` enum('NATED','NCV','Occupational','Other') NOT NULL DEFAULT 'NATED',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_programme_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programme`
--

LOCK TABLES `programme` WRITE;
/*!40000 ALTER TABLE `programme` DISABLE KEYS */;
INSERT INTO `programme` VALUES (1,'NATED','National Accredited Technical Education Diploma','N1-N6 qualifications offered at TVET colleges','NATED',1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(2,'NCV','National Certificate Vocational','NCV Level 2-4 vocational qualifications','NCV',1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(3,'OCC','Occupational Programmes','Skills programmes and learnerships','Occupational',1,'2026-02-03 16:12:56','2026-02-03 16:12:56');
/*!40000 ALTER TABLE `programme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qualification`
--

DROP TABLE IF EXISTS `qualification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qualification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `programme_id` int NOT NULL,
  `code` varchar(50) NOT NULL COMMENT 'e.g., BM, ES, IT',
  `name` varchar(200) NOT NULL COMMENT 'e.g., Business Management',
  `description` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_qualification_code_programme` (`code`,`programme_id`),
  KEY `idx_programme` (`programme_id`),
  CONSTRAINT `fk_unified_unified_qualification_programme` FOREIGN KEY (`programme_id`) REFERENCES `programme` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qualification`
--

LOCK TABLES `qualification` WRITE;
/*!40000 ALTER TABLE `qualification` DISABLE KEYS */;
INSERT INTO `qualification` VALUES (1,1,'BM','Business Management','Business Management qualification stream',1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(2,1,'ES','Engineering Studies','Engineering Studies qualification stream',1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(3,1,'HR','Human Resource Management','Human Resource Management qualification stream',1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(4,1,'PA','Public Administration','Public Administration qualification stream',1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(5,1,'MA','Marketing','Marketing qualification stream',1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(6,1,'FM','Financial Management','Financial Management qualification stream',1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(7,2,'IT','Information Technology','Information Technology and Computer Science',1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(8,2,'OMS','Office Administration','Office Management and Secretarial',1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(9,2,'HOSP','Hospitality','Hospitality and Tourism',1,'2026-02-03 16:12:56','2026-02-03 16:12:56');
/*!40000 ALTER TABLE `qualification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `question_type` varchar(100) NOT NULL,
  `level` varchar(10) NOT NULL,
  `class_id` int NOT NULL,
  `section_id` int DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `question` text,
  `opt_a` text,
  `opt_b` text,
  `opt_c` text,
  `opt_d` text,
  `opt_e` text,
  `correct` text,
  `descriptive_word_limit` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `subject_id` (`subject_id`),
  KEY `staff_id` (`staff_id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`),
  KEY `class_section_id` (`class_section_id`),
  CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `questions_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `questions_ibfk_3` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `questions_ibfk_4` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `questions_ibfk_5` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `questions_ibfk_6` FOREIGN KEY (`class_section_id`) REFERENCES `class_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9005 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,1,1,'singlechoice','low',1,1,NULL,'What is the primary function of management?','Planning and organizing resources','Selling products to customers','Manufacturing goods','Accounting for finances','','opt_a',0,'2026-01-29 13:12:39','2026-01-29 13:12:39'),(2,1,1,'singlechoice','medium',1,1,NULL,'Which of the following is NOT a management function?','Planning','Organizing','Coding','Controlling','','opt_c',0,'2026-01-29 13:12:39','2026-01-29 13:12:39'),(3,1,1,'singlechoice','medium',1,1,NULL,'A SWOT analysis examines:','Sales, Workers, Output, Training','Strengths, Weaknesses, Opportunities, Threats','Staff, Wages, Operations, Technology','Systems, Workflows, Objectives, Tasks','','opt_b',0,'2026-01-29 13:12:39','2026-01-29 13:12:39'),(4,1,1,'singlechoice','high',1,1,NULL,'What type of organizational structure has employees reporting to multiple managers?','Functional structure','Divisional structure','Matrix structure','Flat structure','','opt_c',0,'2026-01-29 13:12:39','2026-01-29 13:12:39'),(5,1,1,'singlechoice','low',1,1,NULL,'Leadership is best defined as:','Forcing employees to work harder','Influencing others to achieve organizational goals','Monitoring employee attendance','Calculating company profits','','opt_b',0,'2026-01-29 13:12:39','2026-01-29 13:12:39'),(6,1,1,'multichoice','medium',1,1,NULL,'Select ALL that are considered external factors in a PESTLE analysis:','Political factors','Employee motivation','Economic conditions','Technological changes','Internal policies','opt_a,opt_c,opt_d',0,'2026-01-29 13:12:39','2026-01-29 13:12:39'),(7,1,1,'true_false','low',1,1,NULL,'Delegation means assigning tasks to subordinates while retaining overall responsibility.','True','False','','','','opt_a',0,'2026-01-29 13:12:39','2026-01-29 13:12:39'),(8,1,1,'true_false','low',1,1,NULL,'Managers at all levels require the same balance of technical and conceptual skills.','True','False','','','','opt_b',0,'2026-01-29 13:12:39','2026-01-29 13:12:39'),(9,1,1,'true_false','medium',1,1,NULL,'A mission statement describes what the organization wants to become in the future.','True','False','','','','opt_b',0,'2026-01-29 13:12:39','2026-01-29 13:12:39'),(10,1,1,'singlechoice','medium',1,1,NULL,'Which management theorist is associated with \"Scientific Management\"?','Henri Fayol','Frederick Taylor','Max Weber','Elton Mayo','','opt_b',0,'2026-01-29 13:12:39','2026-01-29 13:12:39'),(9001,4,1,'singlechoice','low',1,1,NULL,'What is 2 + 2?','3','4','5','6',NULL,'opt_b',0,'2026-01-29 17:08:01','2026-01-29 17:08:01'),(9002,4,1,'singlechoice','low',1,1,NULL,'What is the capital of France?','London','Berlin','Paris','Madrid',NULL,'opt_c',0,'2026-01-29 17:08:01','2026-01-29 17:08:01'),(9003,4,1,'true_false','low',1,1,NULL,'Is water H2O?',NULL,NULL,NULL,NULL,NULL,'true',0,'2026-01-29 17:08:01','2026-01-29 17:08:01'),(9004,4,1,'descriptive','medium',1,1,NULL,'Explain the causes of World War I.',NULL,NULL,NULL,NULL,NULL,NULL,500,'2026-01-29 17:08:01','2026-01-29 17:08:01');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `read_notification`
--

DROP TABLE IF EXISTS `read_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `read_notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `notification_id` int DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `notification_id` (`notification_id`),
  KEY `staff_id` (`staff_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `read_notification_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `send_notification` (`id`) ON DELETE CASCADE,
  CONSTRAINT `read_notification_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `read_notification_ibfk_3` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `read_notification`
--

LOCK TABLES `read_notification` WRITE;
/*!40000 ALTER TABLE `read_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `read_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reference`
--

DROP TABLE IF EXISTS `reference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reference` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reference` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reference`
--

LOCK TABLES `reference` WRITE;
/*!40000 ALTER TABLE `reference` DISABLE KEYS */;
/*!40000 ALTER TABLE `reference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resume_additional_fields_settings`
--

DROP TABLE IF EXISTS `resume_additional_fields_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resume_additional_fields_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `status` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resume_additional_fields_settings`
--

LOCK TABLES `resume_additional_fields_settings` WRITE;
/*!40000 ALTER TABLE `resume_additional_fields_settings` DISABLE KEYS */;
INSERT INTO `resume_additional_fields_settings` VALUES (1,'work_experience',1,'2024-12-06 06:17:04','2026-01-29 12:14:53'),(2,'education_qalification',1,'2024-12-06 06:17:04','2026-01-29 12:14:53'),(3,'technical_skills',1,'2024-12-06 06:17:04','2026-01-29 12:14:53'),(4,'reference',1,'2024-12-06 06:17:04','2026-01-29 12:14:53'),(5,'other_details',1,'2024-12-06 06:17:04','2026-01-29 12:14:53');
/*!40000 ALTER TABLE `resume_additional_fields_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resume_settings_fields`
--

DROP TABLE IF EXISTS `resume_settings_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resume_settings_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resume_settings_fields`
--

LOCK TABLES `resume_settings_fields` WRITE;
/*!40000 ALTER TABLE `resume_settings_fields` DISABLE KEYS */;
INSERT INTO `resume_settings_fields` VALUES (1,'middlename',1,'2025-02-14 06:40:33','2025-02-14 06:40:33'),(2,'lastname',1,'2025-02-14 06:40:34','2025-02-14 06:40:34'),(3,'gender',1,'2025-02-14 06:40:35','2025-02-14 06:40:35'),(4,'dob',1,'2025-02-14 06:40:36','2025-02-14 06:40:36'),(5,'category',1,'2025-02-14 06:40:37','2025-02-14 06:40:37'),(6,'religion',1,'2025-02-14 06:40:38','2025-02-14 06:40:38'),(7,'cast',1,'2025-02-14 06:40:40','2025-02-14 06:40:40'),(8,'mobile_no',1,'2025-02-14 06:40:41','2025-02-14 06:40:41'),(9,'student_email',1,'2025-02-14 06:40:41','2025-02-14 06:40:41'),(10,'student_photo',1,'2025-02-14 06:40:42','2025-02-14 06:40:42'),(11,'is_blood_group',1,'2025-02-14 06:40:43','2025-02-14 06:40:43'),(12,'height',1,'2025-02-14 06:40:44','2025-02-14 06:40:44'),(13,'weight',1,'2025-02-14 06:40:46','2025-02-14 06:40:46'),(14,'father_name',1,'2025-02-14 06:40:47','2025-02-14 06:40:47'),(15,'father_phone',1,'2025-02-14 06:40:48','2025-02-14 06:40:48'),(16,'father_occupation',1,'2025-02-14 06:40:49','2025-02-14 06:40:49'),(17,'father_pic',1,'2025-02-14 06:40:49','2025-02-14 06:40:49'),(18,'mother_name',1,'2025-02-14 06:40:50','2025-02-14 06:40:50'),(19,'mother_phone',1,'2025-02-14 06:40:51','2025-02-14 06:40:51'),(20,'mother_occupation',1,'2025-02-14 06:40:52','2025-02-14 06:40:52'),(21,'mother_pic',1,'2025-02-14 06:40:52','2025-02-14 06:40:52'),(22,'if_guardian_is',1,'2025-02-14 06:40:53','2025-02-14 06:42:17'),(23,'guardian_name',1,'2025-02-14 06:41:31','2025-02-14 06:42:17'),(24,'guardian_relation',1,'2025-02-14 06:41:31','2025-02-14 06:42:17'),(25,'guardian_email',1,'2025-02-14 06:41:32','2025-02-14 06:42:17'),(26,'guardian_photo',1,'2025-02-14 06:41:33','2025-02-14 06:42:17'),(27,'guardian_phone',1,'2025-02-14 06:41:34','2025-02-14 06:42:17'),(28,'guardian_occupation',1,'2025-02-14 06:41:34','2025-02-14 06:42:17'),(29,'guardian_address',1,'2025-02-14 06:41:35','2025-02-14 06:42:17'),(30,'current_address',1,'2025-02-14 06:41:36','2025-02-14 06:41:36'),(31,'permanent_address',1,'2025-02-14 06:41:37','2025-02-14 06:41:37'),(32,'national_identification_no',1,'2025-02-14 06:41:37','2025-02-14 06:41:37'),(33,'local_identification_no',1,'2025-02-14 06:41:38','2025-02-14 06:41:38'),(34,'personal_details',1,'2025-02-14 06:41:39','2025-02-14 06:41:39'),(35,'parent_guardian_detail',1,'2025-02-14 06:41:41','2025-02-14 06:41:41');
/*!40000 ALTER TABLE `resume_settings_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `slug` varchar(150) DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `is_system` int NOT NULL DEFAULT '0',
  `is_superadmin` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Admin',NULL,0,1,0,'2018-06-30 15:39:11','0000-00-00 00:00:00'),(2,'Teacher',NULL,0,1,0,'2018-06-30 15:39:14','0000-00-00 00:00:00'),(3,'Accountant',NULL,0,1,0,'2018-06-30 15:39:17','0000-00-00 00:00:00'),(4,'Librarian',NULL,0,1,0,'2018-06-30 15:39:21','0000-00-00 00:00:00'),(6,'Receptionist',NULL,0,1,0,'2018-07-02 05:39:03','0000-00-00 00:00:00'),(7,'Super Admin',NULL,0,1,1,'2018-07-11 14:11:29','0000-00-00 00:00:00'),(10,'Exam Moderator',NULL,0,0,0,'2026-01-29 17:03:35','2026-01-29 17:03:35');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_permissions`
--

DROP TABLE IF EXISTS `roles_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int DEFAULT NULL,
  `perm_cat_id` int DEFAULT NULL,
  `can_view` int DEFAULT NULL,
  `can_add` int DEFAULT NULL,
  `can_edit` int DEFAULT NULL,
  `can_delete` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `perm_cat_id` (`perm_cat_id`),
  CONSTRAINT `roles_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `roles_permissions_ibfk_2` FOREIGN KEY (`perm_cat_id`) REFERENCES `permission_category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1547 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_permissions`
--

LOCK TABLES `roles_permissions` WRITE;
/*!40000 ALTER TABLE `roles_permissions` DISABLE KEYS */;
INSERT INTO `roles_permissions` VALUES (11,1,78,1,1,1,1,'2018-07-03 00:49:43','2026-01-29 12:14:53'),(23,1,12,1,1,1,1,'2018-07-06 09:45:38','2026-01-29 12:14:53'),(24,1,13,1,1,1,1,'2018-07-06 09:48:28','2026-01-29 12:14:53'),(26,1,15,1,1,1,0,'2019-11-27 23:47:28','2026-01-29 12:14:53'),(31,1,21,1,0,1,0,'2019-11-26 04:51:15','2026-01-29 12:14:53'),(34,1,24,1,1,1,1,'2019-11-28 06:35:20','2026-01-29 12:14:53'),(43,1,32,1,1,1,1,'2018-07-06 10:22:05','2026-01-29 12:14:53'),(44,1,33,1,1,1,1,'2018-07-06 10:22:29','2026-01-29 12:14:53'),(45,1,34,1,1,1,1,'2018-07-06 10:23:59','2026-01-29 12:14:53'),(46,1,35,1,1,1,1,'2018-07-06 10:24:34','2026-01-29 12:14:53'),(47,1,104,1,1,1,1,'2018-07-06 10:23:08','2026-01-29 12:14:53'),(48,1,37,1,1,1,1,'2018-07-06 10:25:30','2026-01-29 12:14:53'),(49,1,38,1,1,1,1,'2018-07-09 05:15:27','2026-01-29 12:14:53'),(61,1,55,1,1,1,1,'2018-07-02 09:24:16','2026-01-29 12:14:53'),(67,1,61,1,1,0,1,'2018-07-09 05:59:19','2026-01-29 12:14:53'),(68,1,62,1,1,0,1,'2018-07-09 05:59:19','2026-01-29 12:14:53'),(69,1,63,1,1,0,1,'2018-07-09 03:51:38','2026-01-29 12:14:53'),(70,1,64,1,1,1,1,'2018-07-09 03:02:19','2026-01-29 12:14:53'),(71,1,65,1,1,1,1,'2018-07-09 03:11:21','2026-01-29 12:14:53'),(72,1,66,1,1,1,1,'2018-07-09 03:13:09','2026-01-29 12:14:53'),(73,1,67,1,1,1,1,'2018-07-09 03:14:47','2026-01-29 12:14:53'),(74,1,79,1,1,0,1,'2019-11-30 01:32:51','2026-01-29 12:14:53'),(75,1,80,1,1,1,1,'2018-07-06 09:41:23','2026-01-29 12:14:53'),(76,1,81,1,1,1,1,'2018-07-06 09:41:23','2026-01-29 12:14:53'),(78,1,83,1,1,1,1,'2018-07-06 09:41:23','2026-01-29 12:14:53'),(79,1,84,1,1,1,1,'2018-07-06 09:41:23','2026-01-29 12:14:53'),(80,1,85,1,1,1,1,'2018-07-12 00:16:00','2026-01-29 12:14:53'),(94,1,82,1,1,1,1,'2018-07-06 09:41:23','2026-01-29 12:14:53'),(120,1,39,1,1,1,1,'2018-07-06 10:26:28','2026-01-29 12:14:53'),(156,1,9,1,1,1,1,'2019-11-27 23:45:46','2026-01-29 12:14:53'),(157,1,10,1,1,1,1,'2019-11-27 23:45:46','2026-01-29 12:14:53'),(159,1,40,1,1,1,1,'2019-11-30 00:49:39','2026-01-29 12:14:53'),(160,1,41,1,1,1,1,'2019-12-02 05:43:41','2026-01-29 12:14:53'),(161,1,42,1,1,1,1,'2019-11-30 00:49:39','2026-01-29 12:14:53'),(169,1,27,1,1,0,1,'2019-11-29 06:15:37','2026-01-29 12:14:53'),(178,1,54,1,0,1,0,'2018-07-05 09:09:22','2026-01-29 12:14:53'),(179,1,56,1,0,1,0,'2019-11-30 00:49:54','2026-01-29 12:14:53'),(180,1,57,1,0,1,0,'2019-11-30 01:32:51','2026-01-29 12:14:53'),(181,1,58,1,0,1,0,'2019-11-30 01:32:51','2026-01-29 12:14:53'),(182,1,59,1,0,1,0,'2019-11-30 01:32:51','2026-01-29 12:14:53'),(183,1,60,1,0,1,0,'2019-11-30 00:59:57','2026-01-29 12:14:53'),(201,1,14,1,0,0,0,'2018-07-02 11:22:03','2026-01-29 12:14:53'),(204,1,26,1,0,0,0,'2018-07-02 11:32:05','2026-01-29 12:14:53'),(206,1,29,1,0,0,0,'2018-07-02 11:43:54','2026-01-29 12:14:53'),(207,1,30,1,0,0,0,'2018-07-02 11:43:54','2026-01-29 12:14:53'),(208,1,31,1,1,1,1,'2019-11-30 01:32:51','2026-01-29 12:14:53'),(222,1,1,1,1,1,1,'2019-11-27 22:55:06','2026-01-29 12:14:53'),(307,1,126,1,0,0,0,'2018-07-03 09:26:13','2026-01-29 12:14:53'),(315,1,123,1,0,0,0,'2018-07-03 10:27:03','2026-01-29 12:14:53'),(369,1,102,1,1,1,1,'2019-12-02 05:02:15','2026-01-29 12:14:53'),(435,1,96,1,1,1,1,'2018-07-09 01:03:54','2026-01-29 12:14:53'),(461,1,97,1,0,0,0,'2018-07-09 01:00:16','2026-01-29 12:14:53'),(464,1,86,1,1,1,1,'2019-11-28 06:39:19','2026-01-29 12:14:53'),(474,1,130,1,1,0,1,'2018-07-09 10:56:36','2026-01-29 12:14:53'),(476,1,131,1,0,0,0,'2018-07-09 04:53:32','2026-01-29 12:14:53'),(557,6,82,1,1,1,1,'2019-12-01 01:48:28','2026-01-29 12:14:53'),(558,6,83,1,1,1,1,'2019-12-01 01:49:08','2026-01-29 12:14:53'),(559,6,84,1,1,1,1,'2019-12-01 01:49:59','2026-01-29 12:14:53'),(575,6,44,1,0,0,0,'2018-07-10 07:35:33','2026-01-29 12:14:53'),(576,6,46,1,0,0,0,'2018-07-10 07:35:33','2026-01-29 12:14:53'),(578,6,102,1,1,1,1,'2019-12-01 01:52:27','2026-01-29 12:14:53'),(625,1,28,1,1,1,1,'2019-11-29 06:19:18','2026-01-29 12:14:53'),(634,4,102,1,1,1,1,'2019-12-01 01:03:00','2026-01-29 12:14:53'),(669,1,145,1,0,0,0,'2019-11-26 04:51:15','2026-01-29 12:14:53'),(677,1,153,1,0,0,0,'2019-11-01 02:28:24','2026-01-29 12:14:53'),(720,1,216,1,0,0,0,'2019-11-26 05:24:12','2026-01-29 12:14:53'),(728,1,185,1,1,1,1,'2019-11-28 02:50:33','2026-01-29 12:14:53'),(729,1,186,1,1,1,1,'2019-11-28 02:49:07','2026-01-29 12:14:53'),(730,1,214,1,0,1,0,'2019-11-28 01:47:53','2026-01-29 12:14:53'),(732,1,198,1,0,0,0,'2019-11-26 05:24:30','2026-01-29 12:14:53'),(734,1,200,1,0,0,0,'2019-11-26 05:24:30','2026-01-29 12:14:53'),(735,1,201,1,0,0,0,'2019-11-26 05:24:30','2026-01-29 12:14:53'),(736,1,202,1,0,0,0,'2019-11-26 05:24:30','2026-01-29 12:14:53'),(737,1,203,1,0,0,0,'2019-11-26 05:24:30','2026-01-29 12:14:53'),(747,1,2,1,0,0,0,'2019-11-27 22:56:08','2026-01-29 12:14:53'),(748,1,3,1,1,1,1,'2019-11-27 22:56:32','2026-01-29 12:14:53'),(749,1,4,1,1,1,1,'2019-11-27 22:56:48','2026-01-29 12:14:53'),(751,1,128,0,1,0,1,'2019-11-27 22:57:01','2026-01-29 12:14:53'),(754,1,134,1,1,1,1,'2019-11-27 23:18:21','2026-01-29 12:14:53'),(755,1,5,1,1,0,1,'2019-11-27 23:35:07','2026-01-29 12:14:53'),(756,1,6,1,0,0,0,'2019-11-27 23:35:25','2026-01-29 12:14:53'),(757,1,7,1,1,1,1,'2019-11-27 23:36:35','2026-01-29 12:14:53'),(758,1,8,1,1,1,1,'2019-11-27 23:37:27','2026-01-29 12:14:53'),(760,1,68,1,0,0,0,'2019-11-27 23:38:06','2026-01-29 12:14:53'),(761,1,69,1,1,1,1,'2019-11-27 23:39:06','2026-01-29 12:14:53'),(762,1,70,1,1,1,1,'2019-11-27 23:39:41','2026-01-29 12:14:53'),(763,1,71,1,0,0,0,'2019-11-27 23:39:59','2026-01-29 12:14:53'),(765,1,73,1,0,0,0,'2019-11-27 23:43:15','2026-01-29 12:14:53'),(766,1,74,1,0,0,0,'2019-11-27 23:43:55','2026-01-29 12:14:53'),(768,1,11,1,0,0,0,'2019-11-27 23:45:46','2026-01-29 12:14:53'),(769,1,122,1,0,0,0,'2019-11-27 23:52:43','2026-01-29 12:14:53'),(771,1,136,1,0,0,0,'2019-11-27 23:55:36','2026-01-29 12:14:53'),(772,1,20,1,1,1,1,'2019-11-28 04:06:44','2026-01-29 12:14:53'),(773,1,137,1,1,1,1,'2019-11-28 00:46:14','2026-01-29 12:14:53'),(774,1,141,1,1,1,1,'2019-11-28 00:59:42','2026-01-29 12:14:53'),(775,1,142,1,0,0,0,'2019-11-27 23:56:12','2026-01-29 12:14:53'),(776,1,143,1,1,1,1,'2019-11-28 00:59:42','2026-01-29 12:14:53'),(777,1,144,1,0,0,0,'2019-11-27 23:56:12','2026-01-29 12:14:53'),(778,1,187,1,0,0,0,'2019-11-27 23:56:12','2026-01-29 12:14:53'),(779,1,196,1,0,0,0,'2019-11-27 23:56:12','2026-01-29 12:14:53'),(781,1,207,1,0,0,0,'2019-11-27 23:56:12','2026-01-29 12:14:53'),(782,1,208,1,0,1,0,'2019-11-28 00:10:22','2026-01-29 12:14:53'),(783,1,210,1,0,1,0,'2019-11-28 00:34:40','2026-01-29 12:14:53'),(784,1,211,1,0,1,0,'2019-11-28 00:38:23','2026-01-29 12:14:53'),(785,1,212,1,0,1,0,'2019-11-28 00:42:15','2026-01-29 12:14:53'),(786,1,205,1,1,1,1,'2019-11-28 00:42:15','2026-01-29 12:14:53'),(787,1,222,1,0,1,0,'2019-11-28 01:36:36','2026-01-29 12:14:53'),(788,1,77,1,1,1,1,'2019-11-28 06:22:10','2026-01-29 12:14:53'),(789,1,188,1,1,1,1,'2019-11-28 06:26:16','2026-01-29 12:14:53'),(790,1,23,1,1,1,1,'2019-11-28 06:34:20','2026-01-29 12:14:53'),(791,1,25,1,1,1,1,'2019-11-28 06:36:20','2026-01-29 12:14:53'),(792,1,127,1,0,0,0,'2019-11-28 06:41:25','2026-01-29 12:14:53'),(794,1,88,1,1,1,0,'2019-11-28 06:43:04','2026-01-29 12:14:53'),(795,1,90,1,1,0,1,'2019-11-28 06:46:22','2026-01-29 12:14:53'),(796,1,108,1,0,1,1,'2021-01-23 07:09:32','2026-01-29 12:14:53'),(797,1,109,1,1,0,0,'2019-11-28 23:38:11','2026-01-29 12:14:53'),(798,1,110,1,1,1,1,'2019-11-28 23:49:29','2026-01-29 12:14:53'),(799,1,111,1,1,1,1,'2019-11-28 23:49:57','2026-01-29 12:14:53'),(800,1,112,1,1,1,1,'2019-11-28 23:49:57','2026-01-29 12:14:53'),(801,1,129,0,1,0,1,'2019-11-28 23:49:57','2026-01-29 12:14:53'),(802,1,189,1,0,1,1,'2019-11-28 23:59:22','2026-01-29 12:14:53'),(810,2,1,1,1,1,1,'2019-11-30 02:54:16','2026-01-29 12:14:53'),(817,1,93,1,1,1,1,'2019-11-29 00:56:14','2026-01-29 12:14:53'),(825,1,87,1,0,0,0,'2019-11-29 00:56:14','2026-01-29 12:14:53'),(829,1,94,1,1,0,0,'2019-11-29 00:57:57','2026-01-29 12:14:53'),(836,1,146,1,0,0,0,'2019-11-29 01:13:28','2026-01-29 12:14:53'),(837,1,147,1,0,0,0,'2019-11-29 01:13:28','2026-01-29 12:14:53'),(838,1,148,1,0,0,0,'2019-11-29 01:13:28','2026-01-29 12:14:53'),(839,1,149,1,0,0,0,'2019-11-29 01:13:28','2026-01-29 12:14:53'),(840,1,150,1,0,0,0,'2019-11-29 01:13:28','2026-01-29 12:14:53'),(841,1,151,1,0,0,0,'2019-11-29 01:13:28','2026-01-29 12:14:53'),(842,1,152,1,0,0,0,'2019-11-29 01:13:28','2026-01-29 12:14:53'),(843,1,154,1,0,0,0,'2019-11-29 01:13:28','2026-01-29 12:14:53'),(862,1,155,1,0,0,0,'2019-11-29 02:07:30','2026-01-29 12:14:53'),(863,1,156,1,0,0,0,'2019-11-29 02:07:52','2026-01-29 12:14:53'),(864,1,157,1,0,0,0,'2019-11-29 02:08:05','2026-01-29 12:14:53'),(874,1,158,1,0,0,0,'2019-11-29 02:14:03','2026-01-29 12:14:53'),(875,1,159,1,0,0,0,'2019-11-29 02:14:31','2026-01-29 12:14:53'),(876,1,160,1,0,0,0,'2019-11-29 02:14:44','2026-01-29 12:14:53'),(878,1,162,1,0,0,0,'2019-11-29 02:15:58','2026-01-29 12:14:53'),(879,1,163,1,0,0,0,'2019-11-29 02:16:19','2026-01-29 12:14:53'),(882,1,164,1,0,0,0,'2019-11-29 02:25:17','2026-01-29 12:14:53'),(884,1,165,1,0,0,0,'2019-11-29 02:25:30','2026-01-29 12:14:53'),(886,1,197,1,0,0,0,'2019-11-29 02:25:48','2026-01-29 12:14:53'),(887,1,219,1,0,0,0,'2019-11-29 02:26:05','2026-01-29 12:14:53'),(889,1,220,1,0,0,0,'2019-11-29 02:26:22','2026-01-29 12:14:53'),(932,1,204,1,0,0,0,'2019-11-29 03:43:27','2026-01-29 12:14:53'),(933,1,221,1,0,0,0,'2019-11-29 03:45:04','2026-01-29 12:14:53'),(934,1,178,1,0,0,0,'2019-11-29 03:45:16','2026-01-29 12:14:53'),(935,1,179,1,0,0,0,'2019-11-29 03:45:33','2026-01-29 12:14:53'),(936,1,161,1,0,0,0,'2019-11-29 03:45:48','2026-01-29 12:14:53'),(937,1,180,1,0,0,0,'2019-11-29 03:45:48','2026-01-29 12:14:53'),(938,1,181,1,0,0,0,'2019-11-29 03:49:33','2026-01-29 12:14:53'),(939,1,182,1,0,0,0,'2019-11-29 03:49:45','2026-01-29 12:14:53'),(940,1,183,1,0,0,0,'2019-11-29 03:49:56','2026-01-29 12:14:53'),(941,1,174,1,0,0,0,'2019-11-29 03:50:53','2026-01-29 12:14:53'),(943,1,176,1,0,0,0,'2019-11-29 03:52:10','2026-01-29 12:14:53'),(944,1,177,1,0,0,0,'2019-11-29 03:52:22','2026-01-29 12:14:53'),(945,1,53,0,1,0,1,'2021-01-23 07:09:32','2026-01-29 12:14:53'),(946,1,215,1,0,0,0,'2019-11-29 04:01:37','2026-01-29 12:14:53'),(947,1,213,1,0,0,0,'2019-11-29 04:07:45','2026-01-29 12:14:53'),(974,1,224,1,0,0,0,'2019-11-29 04:32:52','2026-01-29 12:14:53'),(1026,1,135,1,0,1,0,'2019-11-29 06:02:12','2026-01-29 12:14:53'),(1031,1,228,1,0,0,0,'2019-11-29 06:21:16','2026-01-29 12:14:53'),(1083,1,175,1,0,0,0,'2019-11-30 00:37:24','2026-01-29 12:14:53'),(1086,1,43,1,1,1,1,'2019-11-30 00:49:39','2026-01-29 12:14:53'),(1087,1,44,1,0,0,0,'2019-11-30 00:49:39','2026-01-29 12:14:53'),(1088,1,46,1,0,0,0,'2019-11-30 00:49:39','2026-01-29 12:14:53'),(1089,1,217,1,0,0,0,'2019-11-30 00:49:39','2026-01-29 12:14:53'),(1090,1,98,1,1,1,1,'2019-11-30 01:32:51','2026-01-29 12:14:53'),(1091,1,99,1,0,0,0,'2019-11-30 01:30:18','2026-01-29 12:14:53'),(1092,1,223,1,0,0,0,'2019-11-30 01:32:51','2026-01-29 12:14:53'),(1103,2,205,1,1,1,1,'2019-11-30 01:56:04','2026-01-29 12:14:53'),(1105,2,23,1,0,0,0,'2019-11-30 01:56:04','2026-01-29 12:14:53'),(1106,2,24,1,0,0,0,'2019-11-30 01:56:04','2026-01-29 12:14:53'),(1107,2,25,1,0,0,0,'2019-11-30 01:56:04','2026-01-29 12:14:53'),(1108,2,77,1,0,0,0,'2019-11-30 01:56:04','2026-01-29 12:14:53'),(1119,2,117,1,0,0,0,'2019-11-30 01:56:04','2026-01-29 12:14:53'),(1123,3,8,1,1,1,1,'2019-11-30 06:46:18','2026-01-29 12:14:53'),(1125,3,69,1,1,1,1,'2019-11-30 07:00:49','2026-01-29 12:14:53'),(1126,3,70,1,1,1,1,'2019-11-30 07:04:46','2026-01-29 12:14:53'),(1130,3,9,1,1,1,1,'2019-11-30 07:14:54','2026-01-29 12:14:53'),(1131,3,10,1,1,1,1,'2019-11-30 07:16:02','2026-01-29 12:14:53'),(1134,3,35,1,1,1,1,'2019-11-30 07:25:04','2026-01-29 12:14:53'),(1135,3,104,1,1,1,1,'2019-11-30 07:25:53','2026-01-29 12:14:53'),(1140,3,41,1,1,1,1,'2019-11-30 07:37:13','2026-01-29 12:14:53'),(1141,3,42,1,1,1,1,'2019-11-30 07:37:46','2026-01-29 12:14:53'),(1142,3,43,1,1,1,1,'2019-11-30 07:42:06','2026-01-29 12:14:53'),(1151,3,87,1,0,0,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1152,3,88,1,1,1,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1153,3,90,1,1,0,1,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1154,3,108,1,0,1,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1155,3,109,1,1,0,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1156,3,110,1,1,1,1,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1157,3,111,1,1,1,1,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1158,3,112,1,1,1,1,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1159,3,127,1,0,0,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1160,3,129,0,1,0,1,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1161,3,102,1,1,1,1,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1162,3,106,1,0,0,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1163,3,113,1,0,0,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1164,3,114,1,0,0,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1165,3,115,1,0,0,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1166,3,116,1,0,0,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1167,3,117,1,0,0,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1168,3,118,1,0,0,0,'2019-11-30 02:23:13','2026-01-29 12:14:53'),(1171,2,142,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1172,2,144,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1179,2,212,1,0,1,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1183,2,148,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1184,2,149,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1185,2,150,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1186,2,151,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1187,2,152,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1188,2,153,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1189,2,154,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1190,2,197,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1191,2,198,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1193,2,200,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1194,2,201,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1195,2,202,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1196,2,203,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1197,2,219,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1198,2,223,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1199,2,213,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1201,2,230,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1204,2,214,1,0,1,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1206,2,224,1,0,0,0,'2019-11-30 02:36:17','2026-01-29 12:14:53'),(1208,2,2,1,0,0,0,'2019-11-30 02:55:45','2026-01-29 12:14:53'),(1210,2,143,1,1,1,1,'2019-11-30 02:57:28','2026-01-29 12:14:53'),(1211,2,145,1,0,0,0,'2019-11-30 02:57:28','2026-01-29 12:14:53'),(1214,2,3,1,1,1,1,'2019-11-30 03:03:18','2026-01-29 12:14:53'),(1216,2,4,1,1,1,1,'2019-11-30 03:32:56','2026-01-29 12:14:53'),(1218,2,128,0,1,0,1,'2019-11-30 03:37:44','2026-01-29 12:14:53'),(1220,3,135,1,0,1,0,'2019-11-30 07:08:56','2026-01-29 12:14:53'),(1231,3,190,1,0,0,0,'2019-11-30 03:44:02','2026-01-29 12:14:53'),(1232,3,192,1,0,0,0,'2019-11-30 03:44:02','2026-01-29 12:14:53'),(1233,3,226,1,0,0,0,'2019-11-30 03:44:02','2026-01-29 12:14:53'),(1234,3,227,1,0,0,0,'2019-11-30 03:44:02','2026-01-29 12:14:53'),(1235,3,224,1,0,0,0,'2019-11-30 03:44:02','2026-01-29 12:14:53'),(1236,2,15,1,1,1,0,'2019-11-30 03:54:25','2026-01-29 12:14:53'),(1239,2,122,1,0,0,0,'2019-11-30 03:57:48','2026-01-29 12:14:53'),(1240,2,136,1,0,0,0,'2019-11-30 03:57:48','2026-01-29 12:14:53'),(1242,6,217,1,0,0,0,'2019-11-30 04:00:13','2026-01-29 12:14:53'),(1243,6,224,1,0,0,0,'2019-11-30 04:00:13','2026-01-29 12:14:53'),(1245,2,20,1,1,1,1,'2019-11-30 04:01:28','2026-01-29 12:14:53'),(1246,2,137,1,1,1,1,'2019-11-30 04:02:40','2026-01-29 12:14:53'),(1248,2,141,1,1,1,1,'2019-11-30 04:04:04','2026-01-29 12:14:53'),(1250,2,187,1,0,0,0,'2019-11-30 04:11:19','2026-01-29 12:14:53'),(1252,2,207,1,0,0,0,'2019-11-30 04:21:21','2026-01-29 12:14:53'),(1253,2,208,1,0,1,0,'2019-11-30 04:22:00','2026-01-29 12:14:53'),(1255,2,210,1,0,1,0,'2019-11-30 04:22:58','2026-01-29 12:14:53'),(1256,2,211,1,0,1,0,'2019-11-30 04:24:03','2026-01-29 12:14:53'),(1257,2,21,1,0,0,0,'2019-11-30 04:32:59','2026-01-29 12:14:53'),(1259,2,188,1,0,0,0,'2019-11-30 04:34:35','2026-01-29 12:14:53'),(1260,2,27,1,0,0,0,'2019-11-30 04:36:13','2026-01-29 12:14:53'),(1262,2,43,1,1,1,1,'2019-11-30 04:39:42','2026-01-29 12:14:53'),(1263,2,44,1,0,0,0,'2019-11-30 04:41:43','2026-01-29 12:14:53'),(1264,2,46,1,0,0,0,'2019-11-30 04:41:43','2026-01-29 12:14:53'),(1265,2,217,1,0,0,0,'2019-11-30 04:41:43','2026-01-29 12:14:53'),(1266,2,146,1,0,0,0,'2019-11-30 04:46:35','2026-01-29 12:14:53'),(1267,2,147,1,0,0,0,'2019-11-30 04:47:37','2026-01-29 12:14:53'),(1269,2,164,1,0,0,0,'2019-11-30 04:51:04','2026-01-29 12:14:53'),(1271,2,109,1,1,0,0,'2019-11-30 05:03:37','2026-01-29 12:14:53'),(1272,2,93,1,1,1,1,'2019-11-30 05:07:25','2026-01-29 12:14:53'),(1273,2,94,1,1,0,0,'2019-11-30 05:07:42','2026-01-29 12:14:53'),(1275,2,102,1,1,1,1,'2019-11-30 05:11:22','2026-01-29 12:14:53'),(1277,2,196,1,0,0,0,'2019-11-30 05:15:01','2026-01-29 12:14:53'),(1278,2,195,1,0,0,0,'2019-11-30 05:19:08','2026-01-29 12:14:53'),(1279,2,185,1,1,1,1,'2019-11-30 05:21:44','2026-01-29 12:14:53'),(1280,2,186,1,1,1,1,'2019-11-30 05:22:43','2026-01-29 12:14:53'),(1281,2,222,1,0,1,0,'2019-11-30 05:24:30','2026-01-29 12:14:53'),(1283,3,5,1,1,0,1,'2019-11-30 06:43:04','2026-01-29 12:14:53'),(1284,3,6,1,0,0,0,'2019-11-30 06:43:29','2026-01-29 12:14:53'),(1285,3,7,1,1,1,1,'2019-11-30 06:44:39','2026-01-29 12:14:53'),(1286,3,68,1,0,0,0,'2019-11-30 06:46:58','2026-01-29 12:14:53'),(1287,3,71,1,0,0,0,'2019-11-30 07:05:41','2026-01-29 12:14:53'),(1288,3,73,1,0,0,0,'2019-11-30 07:05:59','2026-01-29 12:14:53'),(1289,3,74,1,0,0,0,'2019-11-30 07:06:08','2026-01-29 12:14:53'),(1290,3,11,1,0,0,0,'2019-11-30 07:16:37','2026-01-29 12:14:53'),(1291,3,12,1,1,1,1,'2019-11-30 07:19:29','2026-01-29 12:14:53'),(1292,3,13,1,1,1,1,'2019-11-30 07:22:27','2026-01-29 12:14:53'),(1294,3,14,1,0,0,0,'2019-11-30 07:22:55','2026-01-29 12:14:53'),(1295,3,31,1,1,1,1,'2019-12-02 06:30:37','2026-01-29 12:14:53'),(1297,3,37,1,1,1,1,'2019-11-30 07:28:09','2026-01-29 12:14:53'),(1298,3,38,1,1,1,1,'2019-11-30 07:29:02','2026-01-29 12:14:53'),(1299,3,39,1,1,1,1,'2019-11-30 07:30:07','2026-01-29 12:14:53'),(1300,3,40,1,1,1,1,'2019-11-30 07:32:43','2026-01-29 12:14:53'),(1301,3,44,1,0,0,0,'2019-11-30 07:44:09','2026-01-29 12:14:53'),(1302,3,46,1,0,0,0,'2019-11-30 07:44:09','2026-01-29 12:14:53'),(1303,3,217,1,0,0,0,'2019-11-30 07:44:09','2026-01-29 12:14:53'),(1304,3,155,1,0,0,0,'2019-11-30 07:44:32','2026-01-29 12:14:53'),(1305,3,156,1,0,0,0,'2019-11-30 07:45:18','2026-01-29 12:14:53'),(1306,3,157,1,0,0,0,'2019-11-30 07:45:42','2026-01-29 12:14:53'),(1307,3,158,1,0,0,0,'2019-11-30 07:46:07','2026-01-29 12:14:53'),(1308,3,159,1,0,0,0,'2019-11-30 07:46:21','2026-01-29 12:14:53'),(1309,3,160,1,0,0,0,'2019-11-30 07:46:33','2026-01-29 12:14:53'),(1313,3,161,1,0,0,0,'2019-11-30 07:48:26','2026-01-29 12:14:53'),(1314,3,162,1,0,0,0,'2019-11-30 07:48:48','2026-01-29 12:14:53'),(1315,3,163,1,0,0,0,'2019-11-30 07:48:48','2026-01-29 12:14:53'),(1316,3,164,1,0,0,0,'2019-11-30 07:49:47','2026-01-29 12:14:53'),(1317,3,165,1,0,0,0,'2019-11-30 07:49:47','2026-01-29 12:14:53'),(1318,3,174,1,0,0,0,'2019-11-30 07:49:47','2026-01-29 12:14:53'),(1319,3,175,1,0,0,0,'2019-11-30 07:49:59','2026-01-29 12:14:53'),(1320,3,181,1,0,0,0,'2019-11-30 07:50:08','2026-01-29 12:14:53'),(1321,3,86,1,1,1,1,'2019-11-30 07:54:08','2026-01-29 12:14:53'),(1322,4,28,1,1,1,1,'2019-12-01 00:52:39','2026-01-29 12:14:53'),(1324,4,29,1,0,0,0,'2019-12-01 00:53:46','2026-01-29 12:14:53'),(1325,4,30,1,0,0,0,'2019-12-01 00:53:59','2026-01-29 12:14:53'),(1326,4,123,1,0,0,0,'2019-12-01 00:54:26','2026-01-29 12:14:53'),(1327,4,228,1,0,0,0,'2019-12-01 00:54:39','2026-01-29 12:14:53'),(1328,4,43,1,1,1,1,'2019-12-01 00:58:05','2026-01-29 12:14:53'),(1332,4,44,1,0,0,0,'2019-12-01 00:59:16','2026-01-29 12:14:53'),(1333,4,46,1,0,0,0,'2019-12-01 00:59:16','2026-01-29 12:14:53'),(1334,4,217,1,0,0,0,'2019-12-01 00:59:16','2026-01-29 12:14:53'),(1335,4,178,1,0,0,0,'2019-12-01 00:59:59','2026-01-29 12:14:53'),(1336,4,179,1,0,0,0,'2019-12-01 01:00:11','2026-01-29 12:14:53'),(1337,4,180,1,0,0,0,'2019-12-01 01:00:29','2026-01-29 12:14:53'),(1338,4,221,1,0,0,0,'2019-12-01 01:00:46','2026-01-29 12:14:53'),(1339,4,86,1,0,0,0,'2019-12-01 01:01:02','2026-01-29 12:14:53'),(1341,4,106,1,0,0,0,'2019-12-01 01:05:21','2026-01-29 12:14:53'),(1342,1,107,1,0,0,0,'2019-12-01 01:06:44','2026-01-29 12:14:53'),(1343,4,117,1,0,0,0,'2019-12-01 01:10:20','2026-01-29 12:14:53'),(1344,4,194,1,0,0,0,'2019-12-01 01:11:35','2026-01-29 12:14:53'),(1348,4,230,1,0,0,0,'2019-12-01 01:19:15','2026-01-29 12:14:53'),(1350,6,1,1,0,0,0,'2019-12-01 01:35:32','2026-01-29 12:14:53'),(1351,6,21,1,0,0,0,'2019-12-01 01:36:29','2026-01-29 12:14:53'),(1352,6,23,1,0,0,0,'2019-12-01 01:36:45','2026-01-29 12:14:53'),(1353,6,24,1,0,0,0,'2019-12-01 01:37:05','2026-01-29 12:14:53'),(1354,6,25,1,0,0,0,'2019-12-01 01:37:34','2026-01-29 12:14:53'),(1355,6,77,1,0,0,0,'2019-12-01 01:38:08','2026-01-29 12:14:53'),(1356,6,188,1,0,0,0,'2019-12-01 01:38:45','2026-01-29 12:14:53'),(1357,6,43,1,1,1,1,'2019-12-01 01:40:44','2026-01-29 12:14:53'),(1358,6,78,1,1,1,1,'2019-12-01 01:43:04','2026-01-29 12:14:53'),(1360,6,79,1,1,0,1,'2019-12-01 01:44:39','2026-01-29 12:14:53'),(1361,6,80,1,1,1,1,'2019-12-01 01:45:08','2026-01-29 12:14:53'),(1362,6,81,1,1,1,1,'2019-12-01 01:47:50','2026-01-29 12:14:53'),(1363,6,85,1,1,1,1,'2019-12-01 01:50:43','2026-01-29 12:14:53'),(1364,6,86,1,0,0,0,'2019-12-01 01:51:10','2026-01-29 12:14:53'),(1365,6,106,1,0,0,0,'2019-12-01 01:52:55','2026-01-29 12:14:53'),(1366,6,117,1,0,0,0,'2019-12-01 01:53:08','2026-01-29 12:14:53'),(1394,1,106,1,0,0,0,'2019-12-02 05:20:33','2026-01-29 12:14:53'),(1395,1,113,1,0,0,0,'2019-12-02 05:20:59','2026-01-29 12:14:53'),(1396,1,114,1,0,0,0,'2019-12-02 05:21:34','2026-01-29 12:14:53'),(1397,1,115,1,0,0,0,'2019-12-02 05:21:34','2026-01-29 12:14:53'),(1398,1,116,1,0,0,0,'2019-12-02 05:21:54','2026-01-29 12:14:53'),(1399,1,117,1,0,0,0,'2019-12-02 05:22:04','2026-01-29 12:14:53'),(1400,1,118,1,0,0,0,'2019-12-02 05:22:20','2026-01-29 12:14:53'),(1402,1,191,1,0,0,0,'2019-12-02 05:23:34','2026-01-29 12:14:53'),(1403,1,192,1,0,0,0,'2019-12-02 05:23:47','2026-01-29 12:14:53'),(1404,1,193,1,0,0,0,'2019-12-02 05:23:58','2026-01-29 12:14:53'),(1405,1,194,1,0,0,0,'2019-12-02 05:24:11','2026-01-29 12:14:53'),(1406,1,195,1,0,0,0,'2019-12-02 05:24:20','2026-01-29 12:14:53'),(1408,1,227,1,0,0,0,'2019-12-02 05:25:47','2026-01-29 12:14:53'),(1410,1,226,1,0,0,0,'2019-12-02 05:31:41','2026-01-29 12:14:53'),(1411,1,229,1,0,0,0,'2019-12-02 05:32:57','2026-01-29 12:14:53'),(1412,1,230,1,0,0,0,'2019-12-02 05:32:57','2026-01-29 12:14:53'),(1413,1,190,1,0,0,0,'2019-12-02 05:43:41','2026-01-29 12:14:53'),(1414,2,174,1,0,0,0,'2019-12-02 05:54:37','2026-01-29 12:14:53'),(1415,2,175,1,0,0,0,'2019-12-02 05:54:37','2026-01-29 12:14:53'),(1418,2,232,1,0,1,1,'2019-12-02 06:11:27','2026-01-29 12:14:53'),(1419,2,231,1,0,0,0,'2019-12-02 06:12:28','2026-01-29 12:14:53'),(1420,1,231,1,1,1,1,'2021-01-23 07:09:32','2026-01-29 12:14:53'),(1421,1,232,1,0,1,1,'2019-12-02 06:19:32','2026-01-29 12:14:53'),(1422,3,32,1,1,1,1,'2019-12-02 06:30:37','2026-01-29 12:14:53'),(1423,3,33,1,1,1,1,'2019-12-02 06:30:37','2026-01-29 12:14:53'),(1424,3,34,1,1,1,1,'2019-12-02 06:30:37','2026-01-29 12:14:53'),(1425,3,182,1,0,0,0,'2019-12-02 06:30:37','2026-01-29 12:14:53'),(1426,3,183,1,0,0,0,'2019-12-02 06:30:37','2026-01-29 12:14:53'),(1427,3,189,1,0,1,1,'2019-12-02 06:30:37','2026-01-29 12:14:53'),(1428,3,229,1,0,0,0,'2019-12-02 06:30:37','2026-01-29 12:14:53'),(1429,3,230,1,0,0,0,'2019-12-02 06:30:37','2026-01-29 12:14:53'),(1430,4,213,1,0,0,0,'2019-12-02 06:32:14','2026-01-29 12:14:53'),(1432,4,224,1,0,0,0,'2019-12-02 06:32:14','2026-01-29 12:14:53'),(1433,4,195,1,0,0,0,'2019-12-03 04:57:53','2026-01-29 12:14:53'),(1434,4,229,1,0,0,0,'2019-12-03 04:58:19','2026-01-29 12:14:53'),(1436,6,213,1,0,0,0,'2019-12-03 05:10:11','2026-01-29 12:14:53'),(1437,6,191,1,0,0,0,'2019-12-03 05:10:11','2026-01-29 12:14:53'),(1438,6,193,1,0,0,0,'2019-12-03 05:10:11','2026-01-29 12:14:53'),(1439,6,230,1,0,0,0,'2019-12-03 05:10:11','2026-01-29 12:14:53'),(1440,2,106,1,0,0,0,'2020-01-25 04:21:36','2026-01-29 12:14:53'),(1441,2,107,1,0,0,0,'2020-02-12 02:10:13','2026-01-29 12:14:53'),(1442,2,134,1,1,1,1,'2020-02-12 02:12:36','2026-01-29 12:14:53'),(1443,1,233,1,0,0,0,'2020-02-12 02:21:57','2026-01-29 12:14:53'),(1444,2,86,1,0,0,0,'2020-02-12 02:22:33','2026-01-29 12:14:53'),(1445,3,233,1,0,0,0,'2020-02-12 03:51:17','2026-01-29 12:14:53'),(1446,1,234,1,1,1,1,'2020-06-01 21:51:09','2026-01-29 12:14:53'),(1447,1,235,1,1,1,1,'2020-05-29 23:17:01','2026-01-29 12:14:53'),(1448,1,236,1,1,1,0,'2020-05-29 23:17:52','2026-01-29 12:14:53'),(1449,1,237,1,0,1,0,'2020-05-29 23:18:18','2026-01-29 12:14:53'),(1450,1,238,1,1,1,1,'2020-05-29 23:19:52','2026-01-29 12:14:53'),(1451,1,239,1,1,1,1,'2020-05-29 23:22:10','2026-01-29 12:14:53'),(1452,2,236,1,1,1,0,'2020-05-29 23:40:33','2026-01-29 12:14:53'),(1453,2,237,1,0,1,0,'2020-05-29 23:40:33','2026-01-29 12:14:53'),(1454,2,238,1,1,1,1,'2020-05-29 23:40:33','2026-01-29 12:14:53'),(1455,2,239,1,1,1,1,'2020-05-29 23:40:33','2026-01-29 12:14:53'),(1456,2,240,1,0,0,0,'2020-05-28 20:51:18','2026-01-29 12:14:53'),(1457,2,241,1,0,0,0,'2020-05-28 20:51:18','2026-01-29 12:14:53'),(1458,1,240,1,0,0,0,'2020-06-07 18:30:42','2026-01-29 12:14:53'),(1459,1,241,1,0,0,0,'2020-06-07 18:30:42','2026-01-29 12:14:53'),(1460,1,242,1,0,0,0,'2020-06-07 18:30:42','2026-01-29 12:14:53'),(1461,2,242,1,0,0,0,'2020-06-11 22:45:24','2026-01-29 12:14:53'),(1462,3,242,1,0,0,0,'2020-06-14 22:46:54','2026-01-29 12:14:53'),(1463,6,242,1,0,0,0,'2020-06-14 22:48:14','2026-01-29 12:14:53'),(1464,1,243,1,0,0,0,'2020-09-12 06:05:45','2026-01-29 12:14:53'),(1465,1,109,1,1,0,0,'2020-09-21 06:33:50','2026-01-29 12:14:53'),(1466,1,108,1,0,1,1,'2023-11-04 12:52:08','2026-01-29 12:14:53'),(1467,1,244,1,0,0,0,'2020-09-21 06:59:54','2026-01-29 12:14:53'),(1468,1,245,1,0,0,0,'2020-09-21 06:59:54','2026-01-29 12:14:53'),(1469,1,246,1,0,0,0,'2020-09-21 06:59:54','2026-01-29 12:14:53'),(1470,1,247,1,0,0,0,'2021-01-07 06:12:14','2026-01-29 12:14:53'),(1472,2,247,1,0,0,0,'2021-01-21 12:46:40','2026-01-29 12:14:53'),(1473,1,248,1,1,1,1,'2021-05-19 12:52:49','2026-01-29 12:14:53'),(1474,1,249,1,0,0,0,'2021-05-19 12:52:49','2026-01-29 12:14:53'),(1475,2,248,1,1,1,1,'2021-05-28 13:11:52','2026-01-29 12:14:53'),(1476,3,248,1,1,1,1,'2021-05-28 09:36:16','2026-01-29 12:14:53'),(1477,3,249,1,0,0,0,'2021-05-28 09:36:16','2026-01-29 12:14:53'),(1478,6,248,1,0,0,0,'2021-05-28 09:56:14','2026-01-29 12:14:53'),(1479,6,249,1,0,0,0,'2021-05-28 09:56:14','2026-01-29 12:14:53'),(1480,2,249,1,0,0,0,'2021-05-28 13:11:52','2026-01-29 12:14:53'),(1481,1,269,1,0,0,1,'2023-11-04 12:52:08','2026-01-29 12:14:53'),(1482,2,269,1,0,0,1,'2023-11-04 12:52:28','2026-01-29 12:14:53'),(1483,3,269,1,0,0,1,'2023-11-04 12:53:22','2026-01-29 12:14:53'),(1484,4,269,1,0,0,1,'2023-11-04 12:53:34','2026-01-29 12:14:53'),(1485,6,269,1,0,0,1,'2023-11-04 12:53:52','2026-01-29 12:14:53'),(1486,7,5011,1,0,1,0,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(1487,7,5012,1,1,0,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(1488,7,5013,1,1,0,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(1489,1,5011,1,0,1,0,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(1490,1,5012,1,1,0,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(1491,1,5013,1,1,0,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(1492,2,5011,1,0,1,0,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(1493,2,5012,1,1,0,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(1494,2,5013,1,1,0,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(1495,1,5020,1,1,1,1,'2026-01-29 14:45:11','2026-01-29 14:45:11'),(1496,2,5020,1,1,1,0,'2026-01-29 14:45:11','2026-01-29 14:45:11'),(1497,1,5021,1,0,0,0,'2026-01-29 14:45:11','2026-01-29 14:45:11'),(1498,2,5021,1,0,0,0,'2026-01-29 14:45:11','2026-01-29 14:45:11'),(1499,7,5030,1,0,1,0,'2026-01-29 17:03:35','2026-01-29 17:03:35'),(1500,1,5030,1,0,1,0,'2026-01-29 17:03:35','2026-01-29 17:03:35'),(1501,10,5030,1,0,1,0,'2026-01-29 17:03:35','2026-01-29 17:03:35'),(1502,10,185,1,0,0,0,'2026-01-29 17:03:35','2026-01-29 17:03:35'),(1503,1,5044,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1504,1,5043,1,1,1,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1505,1,5041,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1506,1,5036,1,0,0,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1507,1,5042,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1508,1,5049,1,1,1,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1509,1,5039,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1510,1,5045,1,1,1,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1511,1,5050,1,1,1,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1512,1,5048,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1513,1,5037,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1514,1,5046,1,0,0,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1515,1,5038,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1516,1,5040,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1517,1,5047,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1518,7,5044,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1519,7,5043,1,1,1,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1520,7,5041,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1521,7,5036,1,0,0,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1522,7,5042,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1523,7,5049,1,1,1,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1524,7,5039,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1525,7,5045,1,1,1,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1526,7,5050,1,1,1,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1527,7,5048,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1528,7,5037,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1529,7,5046,1,0,0,0,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1530,7,5038,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1531,7,5040,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1532,7,5047,1,1,1,1,'2026-01-30 15:48:11','2026-01-30 15:48:11'),(1533,1,5055,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1534,1,5057,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1535,1,5053,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1536,1,5051,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1537,1,5052,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1538,1,5056,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1539,1,5054,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1540,7,5055,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1541,7,5057,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1542,7,5053,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1543,7,5051,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1544,7,5052,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1545,7,5056,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56'),(1546,7,5054,1,1,1,1,'2026-02-03 16:12:56','2026-02-03 16:12:56');
/*!40000 ALTER TABLE `roles_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_types`
--

DROP TABLE IF EXISTS `room_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_type` varchar(200) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_types`
--

LOCK TABLES `room_types` WRITE;
/*!40000 ALTER TABLE `room_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `room_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route_pickup_point`
--

DROP TABLE IF EXISTS `route_pickup_point`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `route_pickup_point` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `transport_route_id` int NOT NULL,
  `pickup_point_id` int NOT NULL,
  `fees` float(10,2) DEFAULT '0.00',
  `destination_distance` float(10,1) DEFAULT '0.0',
  `pickup_time` time DEFAULT NULL,
  `order_number` float NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `transport_route_id` (`transport_route_id`),
  KEY `pickup_point_id` (`pickup_point_id`),
  CONSTRAINT `route_pickup_point_ibfk_1` FOREIGN KEY (`transport_route_id`) REFERENCES `transport_route` (`id`) ON DELETE CASCADE,
  CONSTRAINT `route_pickup_point_ibfk_2` FOREIGN KEY (`pickup_point_id`) REFERENCES `pickup_point` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route_pickup_point`
--

LOCK TABLES `route_pickup_point` WRITE;
/*!40000 ALTER TABLE `route_pickup_point` DISABLE KEYS */;
/*!40000 ALTER TABLE `route_pickup_point` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sch_settings`
--

DROP TABLE IF EXISTS `sch_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
  `institution_type` enum('SCHOOL','TVET') NOT NULL DEFAULT 'SCHOOL',
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
  PRIMARY KEY (`id`),
  KEY `lang_id` (`lang_id`),
  KEY `session_id` (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sch_settings`
--

LOCK TABLES `sch_settings` WRITE;
/*!40000 ALTER TABLE `sch_settings` DISABLE KEYS */;
INSERT INTO `sch_settings` VALUES (1,'','','Your School Name',0,'','yourschoolemail@domain.com','Your School Phone','Your School Address',4,'[\"4\"]','Your School Code','m/d/Y','12-hour','150','$','disabled','0',0,0,'UTC',27,'SCHOOL','','after_number','####.##','no','4',0,0.00,'1.png','1.png','1.png','1663064530-1070210809632059d2b8b0b!1662796232-1721792380631c41c80d038!login_bg3.jpg','1663065284-93117584263205cc49769c!1662964519-2099955753631ed327d0ffa!login_bg5.jpg','default.jpg',60,0,'','',0,1,0,'','',0,1,'no',0,'',0,'','<p>&nbsp;Please enter your institution online admission terms & conditions here.</p>',NULL,0,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,'','','#424242','#eeeeee','','','','1.png',0,'Monday',0,'enabled','disabled',0,'disabled','null','null',1,1,0,0,0,0,'','qrcode',1,0,0,0,NULL,NULL,NULL,0,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'2022-12-30 06:44:20','2026-02-04 02:52:32');
/*!40000 ALTER TABLE `sch_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school_houses`
--

DROP TABLE IF EXISTS `school_houses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `school_houses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `house_name` varchar(200) NOT NULL,
  `description` varchar(400) NOT NULL,
  `is_active` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school_houses`
--

LOCK TABLES `school_houses` WRITE;
/*!40000 ALTER TABLE `school_houses` DISABLE KEYS */;
/*!40000 ALTER TABLE `school_houses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `section` varchar(60) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
INSERT INTO `sections` VALUES (1,'Group A','yes','2026-01-29 12:15:00','2026-01-29 12:15:00'),(2,'Group B','yes','2026-01-29 12:15:00','2026-01-29 12:15:00'),(3,'Evening','yes','2026-01-29 12:15:00','2026-01-29 12:15:00');
/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `send_notification`
--

DROP TABLE IF EXISTS `send_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `send_notification` (
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
  PRIMARY KEY (`id`),
  KEY `created_id` (`created_id`),
  CONSTRAINT `send_notification_ibfk_1` FOREIGN KEY (`created_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `send_notification`
--

LOCK TABLES `send_notification` WRITE;
/*!40000 ALTER TABLE `send_notification` DISABLE KEYS */;
/*!40000 ALTER TABLE `send_notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session` varchar(60) DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES (7,'2016-17','no','2017-04-20 06:42:19','0000-00-00 00:00:00'),(11,'2017-18','no','2017-04-20 06:41:37','0000-00-00 00:00:00'),(13,'2018-19','no','2016-08-24 19:26:44','0000-00-00 00:00:00'),(14,'2019-20','no','2016-08-24 19:26:55','0000-00-00 00:00:00'),(15,'2020-21','no','2016-10-01 05:28:08','0000-00-00 00:00:00'),(16,'2021-22','no','2016-10-01 05:28:20','0000-00-00 00:00:00'),(18,'2022-23','no','2016-10-01 05:29:02','0000-00-00 00:00:00'),(19,'2023-24','no','2016-10-01 05:29:10','0000-00-00 00:00:00'),(20,'2024-25','no','2016-10-01 05:29:18','0000-00-00 00:00:00'),(21,'2025-26','no','2016-10-01 05:30:10','0000-00-00 00:00:00'),(22,'2026-27','no','2016-10-01 05:30:18','0000-00-00 00:00:00'),(23,'2027-28','no','2016-10-01 05:30:24','0000-00-00 00:00:00'),(24,'2028-29','no','2016-10-01 05:30:30','0000-00-00 00:00:00'),(25,'2029-30','no','2016-10-01 05:30:37','0000-00-00 00:00:00'),(26,'2024-25','no','2026-01-29 12:15:00','2026-01-29 12:15:00'),(27,'2025-26','yes','2026-01-29 12:15:00','2026-01-29 12:15:00');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `share_content_for`
--

DROP TABLE IF EXISTS `share_content_for`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_content_for` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` varchar(20) DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `user_parent_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `cohort_id` int DEFAULT NULL,
  `share_content_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `upload_content_id` (`share_content_id`),
  KEY `student_id` (`student_id`),
  KEY `staff_id` (`staff_id`),
  KEY `class_section_id` (`class_section_id`),
  KEY `user_parent_id` (`user_parent_id`),
  KEY `idx_cohort_id` (`cohort_id`),
  CONSTRAINT `share_content_for_ibfk_1` FOREIGN KEY (`share_content_id`) REFERENCES `share_contents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `share_content_for_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`),
  CONSTRAINT `share_content_for_ibfk_3` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`),
  CONSTRAINT `share_content_for_ibfk_4` FOREIGN KEY (`class_section_id`) REFERENCES `class_sections` (`id`),
  CONSTRAINT `share_content_for_ibfk_5` FOREIGN KEY (`user_parent_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `share_content_for`
--

LOCK TABLES `share_content_for` WRITE;
/*!40000 ALTER TABLE `share_content_for` DISABLE KEYS */;
INSERT INTO `share_content_for` VALUES (1,NULL,NULL,NULL,NULL,1,NULL,1,'2026-01-29 12:18:31','2026-01-29 12:18:31'),(2,NULL,NULL,NULL,NULL,1,NULL,2,'2026-01-29 12:47:22','2026-01-29 12:47:22'),(3,NULL,NULL,NULL,NULL,1,NULL,3,'2026-02-01 07:22:43','2026-02-01 07:22:43');
/*!40000 ALTER TABLE `share_content_for` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `share_contents`
--

DROP TABLE IF EXISTS `share_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `send_to` varchar(50) DEFAULT NULL,
  `title` text,
  `share_date` date DEFAULT NULL,
  `valid_upto` date DEFAULT NULL,
  `description` text,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `share_contents_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `share_contents`
--

LOCK TABLES `share_contents` WRITE;
/*!40000 ALTER TABLE `share_contents` DISABLE KEYS */;
INSERT INTO `share_contents` VALUES (1,'class','Logistic','2026-01-29','2026-01-31','',1,'2026-01-29 12:18:31','2026-01-29 12:18:31'),(2,'class','zip test','2026-01-29','2026-01-31','',1,'2026-01-29 12:47:22','2026-01-29 12:47:22'),(3,'class','Video Tutorial','2026-02-01',NULL,'',1,'2026-02-01 07:22:43','2026-02-01 07:22:43');
/*!40000 ALTER TABLE `share_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `share_upload_contents`
--

DROP TABLE IF EXISTS `share_upload_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_upload_contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `upload_content_id` int DEFAULT NULL,
  `share_content_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `upload_content_id` (`upload_content_id`),
  KEY `share_content_id` (`share_content_id`),
  CONSTRAINT `share_upload_contents_ibfk_1` FOREIGN KEY (`upload_content_id`) REFERENCES `upload_contents` (`id`) ON DELETE CASCADE,
  CONSTRAINT `share_upload_contents_ibfk_2` FOREIGN KEY (`share_content_id`) REFERENCES `share_contents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `share_upload_contents`
--

LOCK TABLES `share_upload_contents` WRITE;
/*!40000 ALTER TABLE `share_upload_contents` DISABLE KEYS */;
INSERT INTO `share_upload_contents` VALUES (1,1,1,'2026-01-29 12:18:31','2026-01-29 12:18:31'),(2,2,2,'2026-01-29 12:47:22','2026-01-29 12:47:22'),(3,3,3,'2026-02-01 07:22:43','2026-02-01 07:22:43');
/*!40000 ALTER TABLE `share_upload_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sidebar_menus`
--

DROP TABLE IF EXISTS `sidebar_menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sidebar_menus` (
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
  PRIMARY KEY (`id`),
  KEY `permission_group_id` (`permission_group_id`),
  CONSTRAINT `sidebar_menus_ibfk_1` FOREIGN KEY (`permission_group_id`) REFERENCES `permission_group` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sidebar_menus`
--

LOCK TABLES `sidebar_menus` WRITE;
/*!40000 ALTER TABLE `sidebar_menus` DISABLE KEYS */;
INSERT INTO `sidebar_menus` VALUES (1,'',17,'fa fa-ioxhost ftlayer','Front Office','front_office','front_office',10,1,1,'(\'admission_enquiry\', \'can_view\') || (\'visitor_book\', \'can_view\') ||       (\'phon_call_log\', \'can_view\') ||  (\'postal_dispatch\', \'can_view\') ||       (\'postal_receive\', \'can_view\') || (\'complaint\', \'can_view\') ||(\'setup_font_office\', \'can_view\')',1,'2023-01-10 12:49:51','2026-01-29 12:14:53'),(2,'',1,'fa fa-user-plus ftlayer','Student Information','student_information','student_information',20,2,1,'(\'student\', \'can_view\') || (\'student\', \'can_add\') || (\'student_history\', \'can_view\') || (\'student_categories\', \'can_view\') || (\'student_houses\', \'can_view\') || (\'disable_student\', \'can_view\') || (\'disable_reason\', \'can_view\') || (\'online_admission\', \'can_view\') || (\'multiclass_student\', \'can_view\') || (\'disable_reason\', \'can_view\')',1,'2023-01-10 12:49:51','2026-01-29 12:14:53'),(3,'',2,'fa fa-money ftlayer','Fees Collection','fees_collection','fees_collection',30,3,1,'(\'collect_fees\', \'can_view\') || (\'search_fees_payment\', \'can_view\') || (\'search_due_fees\', \'can_view\') || (\'fees_statement\', \'can_view\') || (\'fees_carry_forward\', \'can_view\') || (\'fees_master\', \'can_view\') || (\'fees_group\', \'can_view\') || (\'fees_type\', \'can_view\') || (\'fees_discount\', \'can_view\') || (\'accountants\', \'can_view\')',1,'2023-01-10 12:49:51','2026-01-29 12:14:53'),(4,'',3,'fa fa-usd ftlayer','Income','income','income',40,10,1,'(\'income\', \'can_view\') || (\'search_income\', \'can_view\') || (\'income_head\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(7,'',4,'fa fa-credit-card ftlayer','Expense','expense','expenses',50,11,1,'(\'expense\', \'can_view\') || (\'search_expense\', \'can_view\') || (\'expense_head\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(10,'',5,'fa fa-calendar-check-o ftlayer','Attendance','attendance','attendance',60,13,1,'(\'student_attendance\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(11,'',6,'fa fa-map-o ftlayer','Examinations','examinations','examinations',70,12,1,'(\'exam_group\', \'can_view\') || (\'exam_result\', \'can_view\') || (\'design_admit_card\', \'can_view\') || (\'print_admit_card\', \'can_view\') || (\'design_marksheet\', \'can_view\') || (\'print_marksheet\', \'can_view\') || (\'marks_grade\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(12,'',23,'fa fa-rss ftlayer','Online Examinations','online_examinations','online_examinations',80,14,1,'(\'online_examination\', \'can_view\') ||  (\'question_bank\', \'can_view\'',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(13,'',29,'fa fa-list-alt ftlayer','Lesson Plan','lesson_plan','lesson_plan',90,16,1,'(\'manage_lesson_plan\', \'can_view\') || (\'manage_syllabus_status\', \'can_view\') || (\'lesson\', \'can_view\') ||  (\'topic\', \'can_view\')||  (\'copy_old_lesson\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(14,'',7,'fa fa-mortar-board ftlayer','Academics','academics','academics',100,15,1,'(\'class_timetable\', \'can_view\') || (\'teachers_timetable\', \'can_view\') || (\'assign_class_teacher\', \'can_view\') || (\'promote_student\', \'can_view\') || (\'subject_group\', \'can_view\') || (\'section\', \'can_view\') || (\'subject\', \'can_view\') || (\'class\', \'can_view\') || (\'section\', \'can_view\')',0,'2023-01-10 12:49:37','2026-01-30 15:14:48'),(15,'',18,'fa fa-sitemap ftlayer','Human Resource','human_resource','human_resource',110,17,1,'(\'staff\', \'can_view\') || (\'approve_leave_request\', \'can_view\') || (\'apply_leave\', \'can_view\') || (\'leave_types\', \'can_view\') || (\'teachers_rating\', \'can_view\') || (\'department\', \'can_view\') || (\'designation\', \'can_view\') || (\'disable_staff\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(16,'',13,'fa fa-bullhorn ftlayer','Communicate','communicate','communicate',120,18,1,'(\'notice_board\', \'can_view\') || (\'email\', \'can_view\') || (\'sms\', \'can_view\') || (\'email_sms_log\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(17,'',8,'fa fa-download ftlayer','Download Center','download_center','download_center',130,19,1,'(\'upload_content\', \'can_view\') || (\'video_tutorial\', \'can_view\') || (\'content_type\', \'can_view\') || (\'content_share_list\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(18,'',19,'fa fa-flask ftlayer','Homework','homework','homework',140,20,1,'(\'homework\', \'can_view\') || (\'homework\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(19,'',9,'fa fa-book ftlayer','Library','library','library',150,21,1,'(\'books\', \'can_view\') || (\'issue_return\', \'can_view\') || (\'add_staff_member\', \'can_view\') || (\'add_student\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(20,'',10,'fa fa-object-group ftlayer','Inventory','inventory','inventory',160,22,1,'(\'issue_item\', \'can_view\') || (\'item_stock\', \'can_view\') || (\'item\', \'can_view\') || (\'item_category\', \'can_view\') || (\'item_category\', \'can_view\') || (\'store\', \'can_view\') || (\'supplier\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(21,'',11,'fa fa-bus ftlayer','Transport','transport','transport',170,23,1,'(\'routes\', \'can_view\') || (\'vehicle\', \'can_view\') || (\'assign_vehicle\', \'can_view\') || (\'transport_fees_master\', \'can_view\') || (\'pickup_point\', \'can_view\') || (\'route_pickup_point\', \'can_view\') || (\'student_transport_fees\', \'can_view\')      ',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(22,'',12,'fa fa-building-o ftlayer','Hostel','hostel','hostel',180,24,1,'(\'hostel_rooms\', \'can_view\') || (\'room_type\', \'can_view\') || (\'hostel\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(23,'',20,'fa fa-newspaper-o ftlayer','Certificate','certificate','certificate',190,25,1,'(\'student_certificate\', \'can_view\') || (\'generate_certificate\', \'can_view\') || (\'student_id_card\', \'can_view\') || (\'generate_id_card\', \'can_view\') || (\'staff_id_card\', \'can_view\') || (\'generate_staff_id_card\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(24,'',16,'fa fa-empire ftlayer','Front CMS','front_cms','front_cms',200,26,1,'(\'event\', \'can_view\') || (\'gallery\', \'can_view\') || (\'notice\', \'can_view\') || (\'media_manager\', \'can_view\') || (\'pages\', \'can_view\') || (\'menus\', \'can_view\') || (\'banner_images\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(25,'',28,'fa fa-universal-access ftlayer','Alumni','alumni','alumni',210,27,1,'(\'manage_alumni\', \'can_view\') || (\'events\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(26,'',14,'fa fa-line-chart ftlayer','Reports','reports','reports',220,28,1,'(\'student_report\', \'can_view\') || (\'guardian_report\', \'can_view\') || (\'student_history\', \'can_view\') || (\'student_login_credential_report\', \'can_view\') || (\'class_subject_report\', \'can_view\') || (\'admission_report\', \'can_view\') || (\'sibling_report\', \'can_view\') || (\'evaluation_report\', \'can_view\') || (\'student_profile\', \'can_view\') || (\'fees_statement\', \'can_view\') || (\'balance_fees_report\', \'can_view\') || (\'fees_collection_report\', \'can_view\') || (\'online_fees_collection_report\', \'can_view\') || (\'income_report\', \'can_view\') || (\'expense_report\', \'can_view\') || (\'payroll_report\', \'can_view\') || (\'income_group_report\', \'can_view\') || (\'expense_group_report\', \'can_view\') || (\'attendance_report\', \'can_view\') || (\'staff_attendance_report\', \'can_view\') || (\'exam_marks_report\', \'can_view\') ||        (\'online_exam_wise_report\', \'can_view\') || (\'online_exams_report\', \'can_view\') || (\'online_exams_attempt_report\', \'can_view\') || (\'online_exams_rank_report\', \'can_view\') || (\'payroll_report\', \'can_view\') || (\'transport_report\', \'can_view\') || (\'hostel_report\', \'can_view\') || (\'audit_trail_report\', \'can_view\') || (\'user_log\', \'can_view\') || (\'book_issue_report\', \'can_view\') || (\'book_due_report\', \'can_view\') || (\'book_inventory_report\', \'can_view\') || (\'stock_report\', \'can_view\') ||      (\'add_item_report\', \'can_view\') || (\'issue_inventory_report\', \'can_view\') || (\'syllabus_status_report\', \'can_view\') ||    (\'teacher_syllabus_status_report\', \'can_view\') || (\'daily_collection_report\', \'can_view\') || (\'balance_fees_statement\', \'can_view\') || (\'balance_fees_report_with_remark\', \'can_view\')',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(27,'',15,'fa fa-gears ftlayer','System Settings','system_settings','system_setting',230,29,1,'(\'general_setting\', \'can_view\') || (\'session_setting\', \'can_view\') || (\'notification_setting\', \'can_view\') || (\'sms_setting\', \'can_view\') || (\'email_setting\', \'can_view\') || (\'payment_methods\', \'can_view\') || (\'languages\', \'can_view\') || (\'user_status\', \'can_view\') || (\'backup_restore\', \'can_view\') || (\'print_header_footer\', \'can_view\') || (\'backup\', \'can_view\') || (\'front_cms_setting\', \'can_view\') || (\'custom_fields\', \'can_view\') || (\'system_fields\', \'can_view\') || (\'student_profile_update\', \'can_view\') || (\'currency\', \'can_view\') || (\'language_switcher\', \'can_view\') || (\'sidebar_menu\', \'can_view\') || (\'online_admission\', \'can_view\')\r\n',1,'2023-01-10 12:49:37','2026-01-29 12:14:53'),(31,'',501,'fa fa-windows ftlayer','Teams Live Classes','teams_live_classes','teams_live_classes',1,7,1,'(\'setting\', \'can_view\') || (\'live_classes\', \'can_view\') || (\'live_meeting\', \'can_view\')',1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(36,'',30,'fa fa-calendar','Annual Calendar','holiday','annual_calendar',240,16,1,'(\'annual_calendar\', \'can_view\')\r\n',1,'2025-01-18 09:15:03','2026-01-29 12:14:53'),(37,'',31,'fa fa-ioxhost ftlayer','Student CV','student_cv','student_cv',1,23,1,'(\'download_cv\', \'can_view\') || (\'build_cv\', \'can_view\') || (\'resume_setting\', \'can_view\') || (\'student_resume_details\', \'can_view\')',1,'2025-01-18 09:15:07','2026-01-29 12:14:53'),(38,'',32,'fa fa-graduation-cap ftlayer','Academic Management','academic_management','academic_management',105,12,1,'(\'tvet_programme\', \'can_view\') || (\'tvet_qualification\', \'can_view\') || (\'tvet_level\', \'can_view\') || (\'tvet_cohort\', \'can_view\') || (\'tvet_module_mapping\', \'can_view\') || (\'tvet_lecturer_allocation\', \'can_view\')',1,'2026-01-29 12:15:00','2026-01-30 15:14:48');
/*!40000 ALTER TABLE `sidebar_menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sidebar_sub_menus`
--

DROP TABLE IF EXISTS `sidebar_sub_menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sidebar_sub_menus` (
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
  PRIMARY KEY (`id`),
  KEY `sidebar_menu_id` (`sidebar_menu_id`),
  KEY `permission_group_id` (`permission_group_id`),
  CONSTRAINT `sidebar_sub_menus_ibfk_1` FOREIGN KEY (`sidebar_menu_id`) REFERENCES `sidebar_menus` (`id`) ON DELETE CASCADE,
  CONSTRAINT `sidebar_sub_menus_ibfk_2` FOREIGN KEY (`permission_group_id`) REFERENCES `permission_group` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sidebar_sub_menus`
--

LOCK TABLES `sidebar_sub_menus` WRITE;
/*!40000 ALTER TABLE `sidebar_sub_menus` DISABLE KEYS */;
INSERT INTO `sidebar_sub_menus` VALUES (1,1,'admission_enquiry',NULL,'admission_enquiry','admin/enquiry',1,'(\'admission_enquiry\', \'can_view\')',NULL,'enquiry','index',NULL,1,'2022-07-11 12:04:46','2026-01-29 12:14:53'),(2,1,'visitor_book',NULL,'visitor_book','admin/visitors',2,'(\'visitor_book\', \'can_view\')',NULL,'visitors','index',NULL,1,'2022-07-11 12:04:46','2026-01-29 12:14:53'),(3,1,'phone_call_log',NULL,'phone_call_log','admin/generalcall',3,'(\'phone_call_log\', \'can_view\')',NULL,'generalcall','index,edit',NULL,1,'2022-05-10 11:40:07','2026-01-29 12:14:53'),(4,1,'postal_dispatch',NULL,'postal_dispatch','admin/dispatch',4,'(\'postal_dispatch\', \'can_view\')',NULL,'dispatch','index,editdispatch',NULL,1,'2022-05-10 11:40:09','2026-01-29 12:14:53'),(5,1,'postal_receive',NULL,'postal_receive','admin/receive',5,'(\'postal_receive\', \'can_view\')',NULL,'receive','index,editreceive',NULL,1,'2022-05-10 11:40:09','2026-01-29 12:14:53'),(6,1,'complain',NULL,'complain','admin/complaint',6,'(\'complaint\', \'can_view\')',NULL,'complaint','index,edit',NULL,1,'2022-05-10 11:40:00','2026-01-29 12:14:53'),(7,1,'setup_front_office',NULL,'setup_front_office','admin/visitorspurpose',7,'(\'setup_font_office\', \'can_view\')',NULL,'visitorspurpose','index,edit',NULL,1,'2022-04-18 15:43:15','2026-01-29 12:14:53'),(9,2,'student_admission',NULL,'student_admission','student/create',2,'(\'student\', \'can_add\')',NULL,'student','create,import',NULL,1,'2022-08-30 07:51:02','2026-01-29 12:14:53'),(10,2,'online_admission',NULL,'online_admission','admin/onlinestudent',3,'(\'online_admission\', \'can_view\')',27,'onlinestudent','index,edit',NULL,1,'2022-05-10 11:40:30','2026-01-29 12:14:53'),(11,2,'disable_student',NULL,'disabled_students','student/disablestudentslist',4,'(\'disable_student\', \'can_view\')',NULL,'student','disablestudentslist','',1,'2022-07-23 06:49:00','2026-01-29 12:14:53'),(12,3,'collect_fees',NULL,'collect_fees','studentfee',1,'(\'collect_fees\', \'can_view\')',NULL,'studentfee','index,addfee',NULL,1,'2022-07-23 06:53:34','2026-01-29 12:14:53'),(13,3,'search_fees_payment',NULL,'search_fees_payment','studentfee/searchpayment',3,'(\'search_fees_payment\', \'can_view\')',NULL,'studentfee','searchpayment',NULL,1,'2022-08-08 06:03:40','2026-01-29 12:14:53'),(14,3,'search_due_fees',NULL,'search_due_fees','studentfee/feesearch',4,'(\'search_due_fees\', \'can_view\')',NULL,'studentfee','feesearch',NULL,1,'2022-08-08 06:03:38','2026-01-29 12:14:53'),(15,3,'fees_master',NULL,'fees_master','admin/feemaster',5,'(\'fees_master\', \'can_view\')',NULL,'feemaster','index,assign,edit',NULL,1,'2022-09-24 07:35:55','2026-01-29 12:14:53'),(16,3,'fees_group',NULL,'fees_group','admin/feegroup',6,'(\'fees_group\', \'can_view\')',NULL,'feegroup','index,edit',NULL,1,'2022-08-08 06:03:32','2026-01-29 12:14:53'),(17,4,'add_income',NULL,'add_income','admin/income',1,'(\'income\', \'can_view\')',NULL,'income','index,edit',NULL,1,'2022-07-23 07:03:40','2026-01-29 12:14:53'),(18,4,'search_income',NULL,'search_income','admin/income/incomesearch',2,'(\'search_income\', \'can_view\')',NULL,'income','incomesearch',NULL,1,'2022-07-23 07:10:13','2026-01-29 12:14:53'),(19,4,'income_head',NULL,'income_head','admin/incomehead',3,'(\'income_head\', \'can_view\')',NULL,'incomehead','index,edit',NULL,1,'2022-07-23 07:11:11','2026-01-29 12:14:53'),(20,2,'student_details',NULL,'student_details','student/search',1,'(\'student\', \'can_view\')',NULL,'student','search,view,edit',NULL,1,'2022-08-30 07:51:05','2026-01-29 12:14:53'),(21,2,'multi_class_student',NULL,'multi_class_student','student/multiclass',5,'(\'multi_class_student\', \'can_view\')',26,'student','multiclass',NULL,1,'2022-07-23 06:48:37','2026-01-29 12:14:53'),(22,2,'bulk_delete',NULL,'bulk_delete','student/bulkdelete',6,'(\'student\', \'can_delete\')',NULL,'student','bulkdelete',NULL,1,'2022-07-23 06:48:11','2026-01-29 12:14:53'),(23,2,'student_categories',NULL,'student_categories','category',7,'(\'student_categories\', \'can_view\')',NULL,'category','index,edit',NULL,1,'2022-07-23 06:47:24','2026-01-29 12:14:53'),(24,2,'student_house',NULL,'student_house','admin/schoolhouse',8,'(\'student_houses\', \'can_view\')',NULL,'schoolhouse','index,edit',NULL,1,'2022-07-23 06:49:59','2026-01-29 12:14:53'),(25,2,'disable_reason',NULL,'disable_reason','admin/disable_reason',9,'(\'disable_reason\', \'can_view\')',NULL,'disable_reason','index,edit',NULL,1,'2022-07-23 06:50:41','2026-01-29 12:14:53'),(29,7,'add_expense',NULL,'add_expense','admin/expense',1,'(\'expense\', \'can_view\')',NULL,'expense','index,edit','',1,'2022-07-23 07:12:25','2026-01-29 12:14:53'),(32,3,'fees_type',NULL,'fees_type','admin/feetype',7,'(\'fees_type\', \'can_view\')',NULL,'feetype','index,edit','',1,'2022-08-08 06:03:29','2026-01-29 12:14:53'),(33,10,'attendance_by_date','attendance_by_date','attendance_by_date','admin/stuattendence/attendencereport',3,'(\'attendance_by_date\', \'can_view\')',NULL,'stuattendence','attendencereport','',1,'2022-10-20 05:50:25','2026-01-29 12:14:53'),(34,10,'student_attendance','student_attendance','student_attendance','admin/stuattendence',1,'(\'student_attendance\', \'can_view\')',NULL,'stuattendence','index','',1,'2022-10-20 05:50:25','2026-01-29 12:14:53'),(35,10,'approve_leave','approve_leave','approve_leave','admin/approve_leave',2,'(\'approve_leave\', \'can_view\')',NULL,'approve_leave','index','',1,'2022-10-14 16:16:44','2026-01-29 12:14:53'),(36,11,'exam_group',NULL,'exam_group','admin/examgroup',1,'(\'exam_group\', \'can_view\')',NULL,'examgroup','index,addexam,edit','',1,'2022-07-23 07:23:01','2026-01-29 12:14:53'),(37,11,'exam_schedule',NULL,'exam_schedule','admin/exam_schedule',2,'(\'student_attendance\', \'can_view\')',NULL,'exam_schedule','index','',1,'2022-05-16 07:01:34','2026-01-29 12:14:53'),(38,11,'exam_result',NULL,'exam_result','admin/examresult',3,'(\'exam_result\', \'can_view\')',NULL,'examresult','index','',1,'2022-05-16 07:01:34','2026-01-29 12:14:53'),(39,11,'design_admit_card',NULL,'design_admit_card','admin/admitcard',4,'(\'design_admit_card\', \'can_view\')',NULL,'admitcard','index,edit','',1,'2022-07-23 07:28:02','2026-01-29 12:14:53'),(40,11,'print_admit_card',NULL,'print_admit_card','admin/examresult/admitcard',5,'(\'print_admit_card\', \'can_view\')',NULL,'examresult','admitcard','',1,'2022-05-16 07:01:34','2026-01-29 12:14:53'),(41,11,'design_marksheet',NULL,'design_marksheet','admin/marksheet',6,'(\'design_marksheet\', \'can_view\')',NULL,'marksheet','index,edit','',1,'2022-07-23 07:35:35','2026-01-29 12:14:53'),(42,11,'print_marksheet',NULL,'print_marksheet','admin/examresult/marksheet',7,'(\'print_marksheet\', \'can_view\')',NULL,'examresult','marksheet','',1,'2022-05-16 07:01:38','2026-01-29 12:14:53'),(43,11,'marks_grade',NULL,'marks_grade','admin/grade',8,'(\'marks_grade\', \'can_view\')',NULL,'grade','index,edit','',1,'2022-07-23 07:37:15','2026-01-29 12:14:53'),(44,11,'marks_division',NULL,'marks_division','admin/marksdivision',9,'(\'marks_division\', \'can_view\')',NULL,'marksdivision','index,edit','',1,'2022-08-25 06:04:26','2026-01-29 12:14:53'),(45,12,'online_exam',NULL,'online_exam','admin/onlineexam',1,'(\'online_examination\', \'can_view\')',NULL,'onlineexam','index,evalution,assign','',1,'2022-08-30 13:03:45','2026-01-29 12:14:53'),(46,12,'question_bank',NULL,'question_bank','admin/question',1,'(\'question_bank\', \'can_view\')',NULL,'question','index,read','',1,'2022-08-30 11:03:13','2026-01-29 12:14:53'),(47,13,'manage_lesson_plan',NULL,'manage_lesson_plan','admin/syllabus',2,'(\'manage_lesson_plan\', \'can_view\')',NULL,'syllabus','index','',1,'2022-09-03 16:59:31','2026-01-29 12:14:53'),(48,13,'manage_syllabus_status',NULL,'manage_syllabus_status','admin/syllabus/status',3,'(\'manage_syllabus_status\', \'can_view\')',NULL,'syllabus','status','',1,'2022-09-03 16:59:35','2026-01-29 12:14:53'),(49,13,'lesson',NULL,'lesson','admin/lessonplan/lesson',4,'(\'lesson\', \'can_view\')',NULL,'lessonplan','lesson,editlesson','',1,'2022-09-15 11:30:55','2026-01-29 12:14:53'),(50,13,'topic',NULL,'topic','admin/lessonplan/topic',5,'(\'topic\', \'can_view\')',NULL,'lessonplan','topic,edittopic','',1,'2022-09-15 11:30:24','2026-01-29 12:14:53'),(51,14,'class_timetable',NULL,'class_timetable','admin/timetable/classreport',1,'(\'class_timetable\', \'can_view\')',NULL,'timetable','classreport,create','',1,'2022-07-23 09:01:22','2026-01-29 12:14:53'),(52,14,'teachers_timetable',NULL,'teachers_timetable','admin/timetable/mytimetable',2,'(\'teachers_time_table\', \'can_view\')',NULL,'timetable','mytimetable','',1,'2022-07-20 12:22:59','2026-01-29 12:14:53'),(53,14,'assign_class_teacher',NULL,'assign_class_teacher','admin/teacher/assign_class_teacher',3,'(\'assign_class_teacher\', \'can_view\')',NULL,'teacher','assign_class_teacher,update_class_teacher','',1,'2022-07-23 09:00:19','2026-01-29 12:14:53'),(54,14,'promote_students',NULL,'promote_students','admin/stdtransfer',4,'(\'promote_student\', \'can_view\')',NULL,'stdtransfer','index','',1,'2022-07-20 12:22:54','2026-01-29 12:14:53'),(55,14,'subject_group',NULL,'subject_group','admin/subjectgroup',5,'(\'subject_group\', \'can_view\')',NULL,'subjectgroup','index,edit','',1,'2022-07-23 08:59:42','2026-01-29 12:14:53'),(56,14,'subjects',NULL,'subjects','admin/subject',6,'(\'subject\', \'can_view\')',NULL,'subject','index,edit','',1,'2022-07-23 08:59:20','2026-01-29 12:14:53'),(57,14,'class',NULL,'class','classes',7,'(\'class\', \'can_view\')',NULL,'classes','index,edit','',1,'2022-07-23 08:58:49','2026-01-29 12:14:53'),(58,14,'sections',NULL,'sections','sections',8,'(\'section\', \'can_view\')',NULL,'sections','index,edit','',1,'2022-07-23 08:58:21','2026-01-29 12:14:53'),(59,15,'staff_directory',NULL,'staff_directory','admin/staff',1,'(\'staff\', \'can_view\')',NULL,'staff','index,edit,profile,create','',1,'2022-10-12 09:13:24','2026-01-29 12:14:53'),(60,15,'staff_attendance',NULL,'staff_attendance','admin/staffattendance',1,'(\'staff_attendance\', \'can_view\')',NULL,'staffattendance','index','',1,'2022-09-07 12:04:15','2026-01-29 12:14:53'),(61,15,'payroll',NULL,'payroll','admin/payroll',1,'(\'staff_payroll\', \'can_view\')',NULL,'payroll','index,edit,create','',1,'2022-08-16 11:58:44','2026-01-29 12:14:53'),(62,15,'approve_leave_request',NULL,'approve_leave_request','admin/leaverequest/leaverequest',1,'(\'approve_leave_request\', \'can_view\')',NULL,'leaverequest','leaverequest','',1,'2022-05-16 09:04:33','2026-01-29 12:14:53'),(74,15,'apply_leave',NULL,'apply_leave','admin/staff/leaverequest',1,'(\'apply_leave\', \'can_view\')',NULL,'staff','leaverequest','',1,'2022-05-16 09:11:41','2026-01-29 12:14:53'),(75,15,'leave_type',NULL,'leave_type','admin/leavetypes',1,'(\'leave_types\', \'can_view\')',NULL,'leavetypes','index,leaveedit,createleavetype','',1,'2022-10-18 11:19:22','2026-01-29 12:14:53'),(76,15,'teachers_rating',NULL,'teachers_rating','admin/staff/rating',1,'(\'teachers_rating\', \'can_view\')',NULL,'staff','rating','',1,'2022-05-16 09:15:31','2026-01-29 12:14:53'),(77,15,'department',NULL,'department','admin/department/department',1,'(\'department\', \'can_view\')',NULL,'department','department,departmentedit','',1,'2022-07-23 09:14:20','2026-01-29 12:14:53'),(78,15,'designation',NULL,'designation','admin/designation/designation',1,'(\'designation\', \'can_view\')',NULL,'designation','designation,designationedit','',1,'2022-07-23 09:15:04','2026-01-29 12:14:53'),(79,15,'disabled_staff',NULL,'disabled_staff','admin/staff/disablestafflist',1,'(\'disable_staff\', \'can_view\')',NULL,'staff','disablestafflist','',1,'2022-09-13 07:46:56','2026-01-29 12:14:53'),(80,16,'notice_board',NULL,'notice_board','admin/notification',1,'(\'notice_board\', \'can_view\')',NULL,'notification','index,edit,add','',1,'2022-07-23 09:17:24','2026-01-29 12:14:53'),(81,16,'send_email',NULL,'send_email','admin/mailsms/compose',2,'(\'email\', \'can_view\')',NULL,'mailsms','compose','',1,'2022-09-02 16:52:46','2026-01-29 12:14:53'),(82,16,'send_sms',NULL,'send_sms','admin/mailsms/compose_sms',3,'(\'sms\', \'can_view\')',NULL,'mailsms','compose_sms','',1,'2022-09-02 16:52:46','2026-01-29 12:14:53'),(83,16,'email_sms_log',NULL,'email_sms_log','admin/mailsms/index',4,'(\'email_sms_log\', \'can_view\')',NULL,'mailsms','index','',1,'2022-09-02 16:52:50','2026-01-29 12:14:53'),(84,16,'schedule_email_sms_log',NULL,'schedule_email_sms_log','admin/mailsms/schedule',5,'(\'schedule_email_sms_log\', \'can_view\')',NULL,'mailsms','schedule,edit_schedule','',1,'2022-09-13 07:07:38','2026-01-29 12:14:53'),(85,16,'login_credentials_send',NULL,'login_credentials_send','student/bulkmail',6,'(\'login_credentials_send\', \'can_view\')',NULL,'student','bulkmail','',1,'2022-09-02 16:52:46','2026-01-29 12:14:53'),(86,16,'email_template',NULL,'email_template','admin/mailsms/email_template',7,'(\'email_template\', \'can_view\')',NULL,'mailsms','email_template','',1,'2022-09-02 16:52:46','2026-01-29 12:14:53'),(87,16,'sms_template',NULL,'sms_template','admin/mailsms/sms_template',8,'(\'sms_template\', \'can_view\')',NULL,'mailsms','sms_template','',1,'2022-09-02 16:52:46','2026-01-29 12:14:53'),(88,17,'content_type',NULL,'content_type','admin/contenttype',3,'(\'content_type\', \'can_view\')',NULL,'contenttype','index,edit','',1,'2022-07-23 09:24:45','2026-01-29 12:14:53'),(89,17,'content_share_list',NULL,'content_share_list','admin/content/list',2,'(\'content_share_list\', \'can_view\')',NULL,'content','list','',1,'2022-07-22 10:07:17','2026-01-29 12:14:53'),(90,17,'upload_content',NULL,'upload_content','admin/content/upload',1,'(\'upload_content\', \'can_view\')',NULL,'content','upload','',1,'2022-07-22 10:07:17','2026-01-29 12:14:53'),(91,17,'video_tutorial',NULL,'video_tutorial','admin/video_tutorial',4,'(\'video_tutorial\', \'can_view\')',NULL,'video_tutorial','index','',1,'2022-07-22 10:07:17','2026-01-29 12:14:53'),(92,18,'add_homework',NULL,'add_homework','homework',1,'(\'homework\', \'can_view\')',NULL,'homework','index','',1,'2022-06-25 09:50:01','2026-01-29 12:14:53'),(93,18,'daily_assignment',NULL,'daily_assignment','homework/dailyassignment',2,'(\'daily_assignment\', \'can_view\')',NULL,'homework','dailyassignment','',1,'2022-07-23 09:27:23','2026-01-29 12:14:53'),(94,19,'book_list',NULL,'book_list','admin/book/getall',1,'(\'books\', \'can_view\')',NULL,'book','getall,index,edit,import,issue_returnreport','',1,'2022-09-07 11:45:50','2026-01-29 12:14:53'),(95,19,'issue_return',NULL,'issue_return','admin/member',1,'(\'issue_return\', \'can_view\')',NULL,'member','index,issue','',1,'2022-07-23 09:32:48','2026-01-29 12:14:53'),(96,19,'add_student',NULL,'add_student','admin/member/student',1,'(\'add_student\', \'can_view\')',NULL,'member','student','',1,'2022-05-16 11:22:54','2026-01-29 12:14:53'),(97,19,'add_staff_member',NULL,'add_staff_member','admin/member/teacher',1,'(\'add_staff_member\', \'can_view\')',NULL,'member','teacher','',1,'2022-05-16 11:31:43','2026-01-29 12:14:53'),(98,7,'search_expense',NULL,'search_expense','admin/expense/expensesearch',1,'(\'search_expense\', \'can_view\')',NULL,'expense','expensesearch','',1,'2022-05-16 11:36:09','2026-01-29 12:14:53'),(99,7,'expense_head',NULL,'expense_head','admin/expensehead',1,'(\'expense_head\', \'can_view\')',NULL,'expensehead','index,edit','',1,'2022-07-23 07:16:17','2026-01-29 12:14:53'),(100,20,'issue_item',NULL,'issue_item','admin/issueitem',1,'(\'issue_item\', \'can_view\')',NULL,'issueitem','index,create','',1,'2022-07-23 09:35:03','2026-01-29 12:14:53'),(101,20,'add_item_stock',NULL,'add_item_stock','admin/itemstock',1,'(\'item_stock\', \'can_view\')',NULL,'itemstock','index,edit','',1,'2022-07-23 09:36:17','2026-01-29 12:14:53'),(102,20,'add_item',NULL,'add_item','admin/item',1,'(\'item\', \'can_view\')',NULL,'item','index,edit','',1,'2022-07-23 09:36:56','2026-01-29 12:14:53'),(103,20,'item_category',NULL,'item_category','admin/itemcategory',1,'(\'item_category\', \'can_view\')',NULL,'itemcategory','index,edit','',1,'2022-07-23 09:37:12','2026-01-29 12:14:53'),(104,20,'item_store',NULL,'item_store','admin/itemstore',1,'(\'store\', \'can_view\')',NULL,'itemstore','index,edit,create','',1,'2022-09-16 11:49:03','2026-01-29 12:14:53'),(105,20,'item_supplier',NULL,'item_supplier','admin/itemsupplier',1,'(\'supplier\', \'can_view\')',NULL,'itemsupplier','index,edit,create','',1,'2022-07-23 09:38:22','2026-01-29 12:14:53'),(106,21,'fees_master',NULL,'fees_master','admin/transport/feemaster',1,'(\'transport_fees_master\', \'can_view\')',NULL,'transport','feemaster','',1,'2023-03-31 05:33:14','2026-01-29 12:14:53'),(107,21,'pickup_point',NULL,'pickup_point','admin/pickuppoint',1,'(\'pickup_point\', \'can_view\')',NULL,'pickuppoint','index','',1,'2023-03-31 05:24:24','2026-01-29 12:14:53'),(108,21,'routes',NULL,'routes','admin/route',1,'(\'routes\', \'can_view\')',NULL,'route','index,edit','',1,'2022-09-17 06:21:23','2026-01-29 12:14:53'),(109,21,'vehicles',NULL,'vehicles','admin/vehicle',1,'(\'vehicle\', \'can_view\')',NULL,'vehicle','index','',1,'2022-05-16 12:29:35','2026-01-29 12:14:53'),(110,21,'assign_vehicle',NULL,'assign_vehicle','admin/vehroute',1,'(\'assign_vehicle\',\'can_view\')',NULL,'vehroute','index,edit','',1,'2022-10-19 07:06:08','2026-01-29 12:14:53'),(111,21,'route_pickup_point',NULL,'route_pickup_point','admin/pickuppoint/assign',1,'(\'route_pickup_point\', \'can_view\')',NULL,'pickuppoint','assign','',1,'2023-03-31 05:25:08','2026-01-29 12:14:53'),(112,21,'student_transport_fees',NULL,'student_transport_fees','admin/pickuppoint/student_fees',1,'(\'student_transport_fees\', \'can_view\')',NULL,'pickuppoint','student_fees','',1,'2023-03-31 05:25:43','2026-01-29 12:14:53'),(113,22,'hostel_rooms',NULL,'hostel_rooms','admin/hostelroom',1,'(\'hostel_rooms\', \'can_view\')',NULL,'hostelroom','index,edit','',1,'2022-07-23 10:27:48','2026-01-29 12:14:53'),(114,22,'room_type',NULL,'room_type','admin/roomtype',2,'(\'room_type\', \'can_view\')',NULL,'roomtype','index,edit','',1,'2022-07-23 10:32:14','2026-01-29 12:14:53'),(115,22,'hostel',NULL,'hostel','admin/hostel',3,'(\'hostel\', \'can_view\')',NULL,'hostel','index,edit','',1,'2022-07-23 10:32:39','2026-01-29 12:14:53'),(116,23,'student_certificate',NULL,'student_certificate','admin/certificate',1,'(\'student_certificate\', \'can_view\')',NULL,'certificate','index,edit','',1,'2022-07-23 10:44:30','2026-01-29 12:14:53'),(117,23,'generate_certificate',NULL,'generate_certificate','admin/generatecertificate',1,'(\'generate_certificate\', \'can_view\')',NULL,'generatecertificate','index,search','',1,'2022-07-23 10:46:16','2026-01-29 12:14:53'),(118,23,'student_id_card',NULL,'student_id_card','admin/studentidcard',1,'(\'student_id_card\', \'can_view\')',NULL,'studentidcard','index,edit','',1,'2022-07-23 10:47:01','2026-01-29 12:14:53'),(119,23,'generate_id_card',NULL,'generate_id_card','admin/generateidcard/search',1,'(\'generate_id_card\', \'can_view\')',NULL,'generateidcard','search','',1,'2022-05-18 05:35:13','2026-01-29 12:14:53'),(120,23,'staff_id_card',NULL,'staff_id_card','admin/staffidcard',1,'(\'staff_id_card\', \'can_view\')',NULL,'staffidcard','index,edit','',1,'2022-07-23 10:48:13','2026-01-29 12:14:53'),(121,23,'generate_staff_id_card',NULL,'generate_staff_id_card','admin/generatestaffidcard',1,'(\'generate_staff_id_card\', \'can_view\')',NULL,'generatestaffidcard','index,search','',1,'2022-07-23 10:49:06','2026-01-29 12:14:53'),(122,24,'event',NULL,'event','admin/front/events',1,'(\'event\', \'can_view\')',NULL,'events','index,edit,create','',1,'2022-07-23 10:51:51','2026-01-29 12:14:53'),(123,24,'gallery',NULL,'gallery','admin/front/gallery',1,'(\'gallery\', \'can_view\')',NULL,'gallery','index,edit,create','',1,'2022-07-23 10:52:22','2026-01-29 12:14:53'),(124,24,'news',NULL,'news','admin/front/notice',1,'(\'notice\', \'can_view\')',NULL,'notice','index,edit,create','',1,'2022-07-23 10:54:23','2026-01-29 12:14:53'),(125,24,'media_manager',NULL,'media_manager','admin/front/media',1,'(\'media_manager\', \'can_view\')',NULL,'media','index','',1,'2022-05-18 06:03:32','2026-01-29 12:14:53'),(126,24,'pages',NULL,'pages','admin/front/page',1,'(\'pages\', \'can_view\')',NULL,'page','index,edit,create','',1,'2022-07-23 10:55:28','2026-01-29 12:14:53'),(127,24,'menus',NULL,'menus','admin/front/menus',1,'(\'menus\', \'can_view\')',NULL,'menus','index,additem','',1,'2022-07-23 10:56:31','2026-01-29 12:14:53'),(128,24,'banner_images',NULL,'banner_images','admin/front/banner',1,'(\'banner_images\', \'can_view\')',NULL,'banner','index','',1,'2022-05-18 06:10:53','2026-01-29 12:14:53'),(129,25,'manage_alumini',NULL,'manage_alumini','admin/alumni/alumnilist',1,'(\'manage_alumni\', \'can_view\')',NULL,'alumni','alumnilist','',1,'2022-07-23 10:58:36','2026-01-29 12:14:53'),(130,25,'events',NULL,'events','admin/alumni/events',1,'(\'events\', \'can_view\')',NULL,'alumni','events','',1,'2022-07-23 10:59:09','2026-01-29 12:14:53'),(131,26,'student_information',NULL,'student_information','report/studentinformation',1,'(\'student_report\', \'can_view\') || (\'guardian_report\', \'can_view\') || (\'student_history\', \'can_view\') || (\'student_login_credential_report\', \'can_view\') || (\'class_subject_report\', \'can_view\') || (\'admission_report\', \'can_view\') || (\'sibling_report\', \'can_view\') || (\'homehork_evaluation_report\', \'can_view\') || (\'student_profile\', \'can_view\') || (\'student_gender_ratio_report\', \'can_view\') || (\'student_teacher_ratio_report\', \'can_view\')',NULL,'report','studentinformation,studentreport,online_admission_report,student_teacher_ratio,boys_girls_ratio,student_profile,sibling_report,admission_report,class_subject,classsectionreport,guardianreport,admissionreport,logindetailreport,parentlogindetailreport','',1,'2022-09-26 05:26:53','2026-01-29 12:14:53'),(132,26,'finance',NULL,'finance','financereports/finance',2,'(\'fees_statement\', \'can_view\') || (\'balance_fees_report\', \'can_view\') || (\'fees_collection_report\', \'can_view\') || (\'online_fees_collection_report\', \'can_view\') || (\'income_report\', \'can_view\') || (\'expense_report\', \'can_view\') || (\'payroll_report\', \'can_view\') || (\'income_group_report\', \'can_view\') || (\'expense_group_report\', \'can_view\') || (\'online_admission\', \'can_view\')',NULL,'financereports','finance,reportduefees,reportdailycollection,reportbyname,studentacademicreport,collection_report,onlinefees_report,duefeesremark,income,expense,payroll,incomegroup,expensegroup,onlineadmission','',1,'2022-09-24 12:20:32','2026-01-29 12:14:53'),(133,26,'attendance',NULL,'attendance','attendencereports/attendance',3,'(\'attendance_report\', \'can_view\') || (\'student_attendance_type_report\', \'can_view\') || (\'daily_attendance_report\', \'can_view\') || (\'staff_attendance_report\', \'can_view\')',NULL,'attendencereports','attendance,classattendencereport,attendancereport,daily_attendance_report,staffattendancereport,biometric_attlog,reportbymonthstudent,reportbymonth','',1,'2022-09-26 11:36:08','2026-01-29 12:14:53'),(134,26,'examinations',NULL,'examinations','admin/examresult/examinations',4,'(\'rank_report\', \'can_view\')',NULL,'examresult','rankreport,examinations','',1,'2022-09-20 08:34:13','2026-01-29 12:14:53'),(135,26,'lesson_plan',NULL,'lesson_plan','report/lesson_plan',6,'(\'syllabus_status_report\', \'can_view\') || (\'teacher_syllabus_status_report\', \'can_view\')',NULL,'report','lesson_plan,teachersyllabusstatus','',1,'2022-07-25 11:39:17','2026-01-29 12:14:53'),(136,26,'human_resource',NULL,'human_resource','report/human_resource',7,'(\'staff_report\', \'can_view\') || (\'payroll_report\', \'can_view\')',NULL,'report','human_resource,staff_report,payrollreport','',1,'2022-07-25 11:38:20','2026-01-29 12:14:53'),(137,26,'library',NULL,'library','report/library',9,'(\'book_issue_report\', \'can_view\') || (\'book_due_report\', \'can_view\') || (\'book_issue_return_report\', \'can_view\') || (\'book_inventory_report\', \'can_view\')',NULL,'report','library,studentbookissuereport,bookduereport,bookinventory','',1,'2022-09-07 11:53:15','2026-01-29 12:14:53'),(138,26,'inventory',NULL,'inventory','report/inventory',10,'(\'stock_report\', \'can_view\') || (\'add_item_report\', \'can_view\') || (\'issue_item_report\', \'can_view\')',NULL,'report','inventory,inventorystock,additem,issueinventory','',1,'2022-07-25 11:30:57','2026-01-29 12:14:53'),(139,26,'hostel',NULL,'hostel','admin/hostelroom/studenthosteldetails',12,'(\'hostel_report\', \'can_view\')',NULL,'hostelroom','studenthosteldetails','',1,'2022-07-20 12:30:07','2026-01-29 12:14:53'),(140,26,'alumni',NULL,'alumni','report/alumnireport',13,'(\'alumni_report\', \'can_view\')',NULL,'report','alumnireport','',1,'2022-07-20 12:30:07','2026-01-29 12:14:53'),(141,26,'user_log',NULL,'user_log','admin/userlog',14,'(\'user_log\', \'can_view\')',NULL,'userlog','index','',1,'2022-07-20 12:30:07','2026-01-29 12:14:53'),(142,26,'audit_trail_report',NULL,'audit_trail_report','admin/audit',15,'(\'audit_trail_report\', \'can_view\')',NULL,'audit','index','',1,'2022-07-20 12:30:07','2026-01-29 12:14:53'),(143,26,'online_examinations',NULL,'online_examinations','admin/onlineexam/report',5,'(\'online_exam_wise_report\', \'can_view\') || (\'online_exams_report\', \'can_view\') || (\'online_exams_attempt_report\', \'can_view\') || (\'online_exams_rank_report\', \'can_view\')',NULL,'onlineexam','report,onlineexams','',1,'2022-07-25 11:48:23','2026-01-29 12:14:53'),(144,26,'homework',NULL,'homework','homework/homeworkordailyassignmentreport',8,'(\'homework\', \'can_view\') || (\'daily_assignment\', \'can_view\')',NULL,'homework','homeworkordailyassignmentreport,homeworkreport,evaluation_report,dailyassignmentreport','',1,'2022-09-21 09:28:47','2026-01-29 12:14:53'),(145,26,'transport',NULL,'transport','admin/route/studenttransportdetails',11,'(\'transport_report\', \'can_view\')',NULL,'route','studenttransportdetails','',1,'2022-07-20 12:30:07','2026-01-29 12:14:53'),(146,27,'general_setting',NULL,'general_setting','schsettings',1,'(\'general_setting\', \'can_view\')',NULL,'schsettings','index,logo,miscellaneous,backendtheme,mobileapp,studentguardianpanel,fees,idautogeneration,attendancetype,maintenance,whatsappsettings','',1,'2025-02-13 09:03:12','2026-01-29 12:14:53'),(147,27,'session_setting',NULL,'session_setting','sessions',2,'(\'session_setting\', \'can_view\')',NULL,'sessions','index,edit','',1,'2022-07-23 11:57:16','2026-01-29 12:14:53'),(148,27,'notification_setting',NULL,'notification_setting','admin/notification/setting',3,'(\'notification_setting\', \'can_view\')',NULL,'notification','setting','',1,'2022-07-08 08:12:28','2026-01-29 12:14:53'),(149,27,'sms_setting',NULL,'sms_setting','smsconfig',4,'(\'sms_setting\', \'can_view\')',NULL,'smsconfig','index','',1,'2022-07-08 08:12:28','2026-01-29 12:14:53'),(150,27,'email_setting',NULL,'email_setting','emailconfig',5,'(\'email_setting\', \'can_view\')',NULL,'emailconfig','index','',1,'2022-07-08 08:12:28','2026-01-29 12:14:53'),(151,27,'payment_methods',NULL,'payment_methods','admin/paymentsettings',6,'(\'payment_methods\', \'can_view\')',NULL,'paymentsettings','index','',1,'2022-07-08 08:12:28','2026-01-29 12:14:53'),(152,27,'print_headerfooter',NULL,'print_headerfooter','admin/print_headerfooter',7,'(\'print_header_footer\', \'can_view\')',NULL,'print_headerfooter','index','',1,'2022-07-08 08:12:28','2026-01-29 12:14:53'),(153,27,'front_cms_setting',NULL,'front_cms_setting','admin/frontcms',8,'(\'front_cms_setting\', \'can_view\')',NULL,'frontcms','index','',1,'2022-07-08 08:12:28','2026-01-29 12:14:53'),(154,27,'roles_permissions',NULL,'roles_permissions','admin/roles',9,'(\'superadmin\', \'can_view\')',NULL,'roles','index,permission','',1,'2022-09-09 11:03:34','2026-01-29 12:14:53'),(155,27,'backup_restore',NULL,'backup_restore','admin/admin/backup',10,'(\'backup\', \'can_view\')',NULL,'admin','backup','',1,'2022-07-08 08:12:28','2026-01-29 12:14:53'),(156,27,'users',NULL,'users','admin/users',13,'(\'user_status\', \'can_view\')',NULL,'users','index','',1,'2022-07-20 12:34:09','2026-01-29 12:14:53'),(157,27,'languages',NULL,'languages','admin/language',11,'(\'languages\', \'can_view\')',NULL,'language','index,create','',1,'2022-09-10 09:14:52','2026-01-29 12:14:53'),(158,27,'modules',NULL,'modules','admin/module',14,'(\'superadmin\', \'can_view\')',NULL,'module','index','',1,'2022-07-20 12:34:06','2026-01-29 12:14:53'),(159,27,'custom_fields',NULL,'custom_fields','admin/customfield',15,'(\'custom_fields\', \'can_view\')',NULL,'customfield','index,edit','',1,'2022-07-23 12:02:14','2026-01-29 12:14:53'),(160,27,'captcha_setting',NULL,'captcha_setting','admin/captcha',16,'(\'superadmin\', \'can_view\')',NULL,'captcha','index','',1,'2022-07-20 12:34:06','2026-01-29 12:14:53'),(161,27,'system_fields',NULL,'system_fields','admin/systemfield',17,'(\'system_fields\', \'can_view\')',NULL,'systemfield','index','',1,'2022-07-22 06:07:38','2026-01-29 12:14:53'),(162,27,'student_profile_update',NULL,'student_profile_update','student/profilesetting',18,'(\'student_profile_update\', \'can_view\')',NULL,'student','profilesetting','',1,'2022-07-20 12:34:06','2026-01-29 12:14:53'),(163,27,'online_admission',NULL,'online_admission','admin/onlineadmission/admissionsetting',19,'(\'online_admission\', \'can_view\')',NULL,'onlineadmission','admissionsetting','',1,'2022-07-20 12:34:06','2026-01-29 12:14:53'),(164,27,'file_types',NULL,'file_types','admin/admin/filetype',20,'(\'superadmin\', \'can_view\')',NULL,'admin','filetype','',1,'2022-07-20 12:34:30','2026-01-29 12:14:53'),(165,27,'system_update',NULL,'system_update','admin/updater',22,'(\'superadmin\', \'can_view\')',NULL,'updater','index','',1,'2022-10-13 11:49:51','2026-01-29 12:14:53'),(166,27,'sidebar_menu',NULL,'sidebar_menu','admin/sidemenu',21,'(\'sidebar_menu\', \'can_view\')',NULL,'sidemenu','index','',1,'2022-10-13 11:49:51','2026-01-29 12:14:53'),(180,31,'live_class',NULL,'live_class','admin/conference/teams_classes',1,'(\'live_classes\', \'can_view\')',NULL,'conference','teams_classes','',1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(181,3,'fees_discount',NULL,'fees_discount','admin/feediscount',8,'(\'fees_discount\', \'can_view\')',NULL,'feediscount','index,edit,assign','',1,'2022-08-08 06:03:27','2026-01-29 12:14:53'),(182,3,'fees_carry_forward',NULL,'fees_carry_forward','admin/feesforward',9,'(\'fees_carry_forward\', \'can_view\')',NULL,'feesforward','index','',1,'2022-08-08 06:03:24','2026-01-29 12:14:53'),(183,3,'fees_reminder',NULL,'fees_reminder','admin/feereminder/setting',10,'(\'fees_reminder\', \'can_view\')',NULL,'feereminder','setting','',1,'2022-08-08 06:03:21','2026-01-29 12:14:53'),(184,27,'currency',NULL,'currency','admin/currency',12,'(\'currency\', \'can_view\')',NULL,'currency','index','',1,'2022-07-20 12:34:09','2026-01-29 12:14:53'),(190,3,'offline_bank_payments',NULL,'offline_bank_payments','admin/offlinepayment',2,'(\'offline_bank_payments\', \'can_view\')',NULL,'offlinepayment','index','',1,'2022-08-08 06:05:29','2026-01-29 12:14:53'),(191,13,'Copy Old Lessons',NULL,'copy_old_lesson','admin/lessonplan/copylesson',1,'(\'copy_old_lesson\', \'can_view\')',NULL,'lessonplan','copylesson',NULL,1,'2022-09-09 10:20:37','2026-01-29 12:14:53'),(192,10,'Period Attendance','period_attendance','period_attendance','admin/subjectattendence/index',4,'(\'student_attendance\',\'can_view\')',NULL,'subjectattendence','index',NULL,0,'2022-10-20 05:50:25','2026-01-29 12:14:53'),(193,10,'Period Attendance By Date','period_attendance_by_date','period_attendance_by_date','admin/subjectattendence/reportbydate',5,'(\'attendance_by_date\', \'can_view\')',NULL,'subjectattendence','reportbydate',NULL,0,'2022-10-20 05:50:25','2026-01-29 12:14:53'),(215,36,'annual_calendar',NULL,'annual_calendar','admin/holiday/index',1,'(\'annual_calendar\', \'can_view\')',NULL,'holiday','index','',1,'2024-10-14 12:07:58','2026-01-29 12:14:53'),(216,36,'holiday_type',NULL,'holiday_type','admin/holiday/holidaytype',1,'(\'holiday_type\', \'can_view\')',NULL,'holiday','holidaytype,editholidaytype','',1,'2024-10-14 12:06:02','2026-01-29 12:14:53'),(217,37,'download_cv',NULL,'download_cv','admin/resume/download',2,'(\'download_cv\', \'can_view\')',NULL,'resume','download',NULL,1,'2025-01-09 08:05:11','2026-01-29 12:14:53'),(218,37,'build_cv',NULL,'build_cv','admin/resume/index',1,'(\'build_cv\', \'can_view\')',NULL,'resume','index,resume_setting,student_resume_details',NULL,1,'2024-12-06 11:42:02','2026-01-29 12:14:53'),(219,27,'addons',NULL,'addons','admin/addons',13,'(\'superadmin\', \'can_view\')',NULL,'addons','index','',1,'2024-12-21 11:43:48','2026-01-29 12:14:53'),(220,38,'Dashboard',NULL,'dashboard','admin/academic',1,'(\'academic_dashboard\', \'can_view\')',NULL,'academic','index','',1,'2026-01-29 12:15:00','2026-01-30 16:08:38'),(221,38,'Programmes',NULL,'programmes','admin/academic/programmes',2,'(\'academic_programmes\', \'can_view\')',NULL,'academic','programmes,programme_add,programme_edit','',1,'2026-01-29 12:15:00','2026-01-30 16:08:38'),(222,38,'Subjects',NULL,'subjects','admin/academic/subjects',3,'(\'academic_subjects\', \'can_view\')',NULL,'academic','subjects,subject_add,subject_edit','',1,'2026-01-29 12:15:00','2026-01-30 16:08:38'),(223,38,'Levels',NULL,'levels','admin/academic/levels',4,'(\'academic_levels\', \'can_view\')',NULL,'academic','levels,level_add,level_edit','',1,'2026-01-29 12:15:00','2026-01-30 16:08:38'),(224,38,'Subject-Level Mapping',NULL,'subject_levels','admin/academic/subject_levels',5,'(\'academic_subject_levels\', \'can_view\')',NULL,'academic','subject_levels,subject_level_add','',1,'2026-01-29 12:15:00','2026-01-30 16:08:38'),(225,38,'Classes',NULL,'classes','admin/academic/classes',6,'(\'academic_classes\', \'can_view\')',NULL,'academic','classes,class_add,class_edit,class_roster','',1,'2026-01-29 12:15:00','2026-01-30 16:08:38'),(226,38,'Student Enrolment',NULL,'student_enrolment','admin/academic/enrolment',7,'(\'academic_enrolment\', \'can_view\')',NULL,'academic','enrolment,enrol_student','',1,'2026-01-29 12:15:00','2026-01-30 16:08:38'),(228,31,'live_meeting',NULL,'live_meeting','admin/conference/teams_meeting',2,'(\'live_meeting\', \'can_view\')',NULL,'conference','teams_meeting','',1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(229,31,'setting',NULL,'setting','admin/conference/teams_settings',3,'(\'setting\', \'can_view\')',NULL,'conference','teams_settings','',1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(230,2,'disability_types',NULL,'disability_types','disabilitytype',8,'(\'disability_types\', \'can_view\')',NULL,'disabilitytype','index,edit','',1,'2026-01-29 16:00:05','2026-01-29 16:00:05'),(231,2,'students_with_disabilities',NULL,'students_with_disabilities','disabilitytype/students',9,'(\'disabled_students_report\', \'can_view\')',NULL,'disabilitytype','students','',1,'2026-01-29 16:06:34','2026-01-29 16:10:54'),(232,12,'exam_moderation',NULL,'exam_moderation','admin/onlineexam/moderation',15,'(\'exam_moderation\', \'can_view\')',NULL,'onlineexam','moderation,moderation_review','',1,'2026-01-29 17:08:46','2026-01-29 17:08:46'),(233,38,'Attendance',NULL,'attendance','admin/academic/attendance',8,'(\'academic_attendance\', \'can_view\')',NULL,'academic','attendance,mark_attendance',NULL,1,'2026-01-30 15:14:48','2026-01-30 16:08:38'),(234,38,'Assessments',NULL,'assessments','admin/academic/assessments',9,'(\'academic_assessments\', \'can_view\')',NULL,'academic','assessments,assessment_add,assessment_edit,marks_entry',NULL,1,'2026-01-30 15:14:48','2026-01-30 16:08:38'),(235,38,'Reports',NULL,'reports','admin/academic/reports',10,'(\'academic_reports\', \'can_view\')',NULL,'academic','reports',NULL,1,'2026-01-30 15:14:48','2026-01-30 16:08:38'),(236,38,'ICASS',NULL,'icass','admin/academic/icass',11,'(\'academic_icass\', \'can_view\')',NULL,'academic','icass',NULL,1,'2026-01-30 15:16:07','2026-01-30 16:08:38'),(237,38,'Timetable','academic_timetable','timetable','admin/academic/timetable',12,'(\'academic_timetable\', \'can_view\')',NULL,'academic','timetable',NULL,1,'2026-01-30 15:46:20','2026-01-30 16:22:28'),(238,38,'POE','academic_poe','poe','admin/academic/poe',13,'(\'academic_poe\', \'can_view\')',NULL,'academic','poe',NULL,1,'2026-01-30 15:46:20','2026-01-30 16:22:28'),(239,38,'Moderation','academic_moderation','moderation','admin/academic/moderation',14,'(\'academic_moderation\', \'can_view\')',NULL,'academic','moderation',NULL,1,'2026-01-30 15:46:20','2026-01-30 16:22:28');
/*!40000 ALTER TABLE `sidebar_sub_menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sms_config`
--

DROP TABLE IF EXISTS `sms_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sms_config` (
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
-- Dumping data for table `sms_config`
--

LOCK TABLES `sms_config` WRITE;
/*!40000 ALTER TABLE `sms_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `sms_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sms_template`
--

DROP TABLE IF EXISTS `sms_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sms_template` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sms_template`
--

LOCK TABLES `sms_template` WRITE;
/*!40000 ALTER TABLE `sms_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `sms_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `source`
--

DROP TABLE IF EXISTS `source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `source` (
  `id` int NOT NULL AUTO_INCREMENT,
  `source` varchar(100) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `source`
--

LOCK TABLES `source` WRITE;
/*!40000 ALTER TABLE `source` DISABLE KEYS */;
/*!40000 ALTER TABLE `source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
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
  UNIQUE KEY `employee_id` (`employee_id`),
  KEY `designation` (`designation`),
  KEY `department` (`department`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`designation`) REFERENCES `staff_designation` (`id`) ON DELETE CASCADE,
  CONSTRAINT `staff_ibfk_2` FOREIGN KEY (`department`) REFERENCES `department` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'9000',0,0,NULL,NULL,'','','Super','Admin','','','','','admin@admin.com','2020-01-01','',NULL,NULL,'','','','','$2y$10$4Y2yxX8OAhhl4gQlyrebNOjIge1JBfYtasKutRGkF4FPIBqLR6rZS','Male','','','','','','',NULL,'','','','','','','','','','','','','',0,1,'',NULL,'2026-01-29 12:15:00','2026-02-04 02:34:45'),(2,'8001',0,0,NULL,NULL,'','','John','Lecturer','','','','','teacher@school.com','1985-03-15','',NULL,NULL,'','','','','$2y$12$OmGFfKmPbWcJ44WmDlISzeeDJSBem2pFpndZF4y295at6D2dDj7py','Male','','','','','','',NULL,'','','','','','','','','','','','','',0,1,'',NULL,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(3,'MOD001',4,0,NULL,NULL,'Masters','5 years','Michael','Moderator','John','Jane','1234567890','0987654321','moderator@test.com','1985-01-15','Married',NULL,NULL,'Test Address','Test Perm Address','','','$2y$10$rx02ozs/gClOZYffUN/PCe9DtVv8Yvv59pmAtDpX5uJDRPMyreyRC','Male','','','','','','',NULL,'','','','','','','','','','','','','',0,1,'',NULL,'2026-01-29 17:06:34','2026-02-01 07:29:12'),(4,'TCH001',4,0,NULL,NULL,'Bachelors','3 years','Sarah','Teacher','Bob','Alice','1234567891','0987654322','teacher@test.com','1990-05-20','Single',NULL,NULL,'Teacher Address','Teacher Perm Address','','','$2y$12$z4BvbvbLkTaz0jeSlADHBeObx61iaTBOlsww6ZhUcdEiELLVlG0oG','Female','','','','','','',NULL,'','','','','','','','','','','','','',0,1,'',NULL,'2026-01-29 17:06:41','2026-01-29 17:53:21');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_attendance`
--

DROP TABLE IF EXISTS `staff_attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_attendance` (
  `id` int NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `staff_id` int NOT NULL,
  `staff_attendance_type_id` int NOT NULL,
  `biometric_attendence` int DEFAULT '0',
  `qrcode_attendance` int NOT NULL DEFAULT '0',
  `biometric_device_data` text,
  `user_agent` varchar(250) DEFAULT NULL,
  `remark` varchar(200) NOT NULL,
  `is_active` int NOT NULL,
  `in_time` time DEFAULT NULL,
  `out_time` time DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_staff_attendance_staff` (`staff_id`),
  KEY `FK_staff_attendance_staff_attendance_type` (`staff_attendance_type_id`),
  CONSTRAINT `FK_staff_attendance_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_staff_attendance_staff_attendance_type` FOREIGN KEY (`staff_attendance_type_id`) REFERENCES `staff_attendance_type` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_attendance`
--

LOCK TABLES `staff_attendance` WRITE;
/*!40000 ALTER TABLE `staff_attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_attendance_type`
--

DROP TABLE IF EXISTS `staff_attendance_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_attendance_type` (
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_attendance_type`
--

LOCK TABLES `staff_attendance_type` WRITE;
/*!40000 ALTER TABLE `staff_attendance_type` DISABLE KEYS */;
INSERT INTO `staff_attendance_type` VALUES (1,'Present','<b class=\"text text-success\">P</b>','yes',1,'present','label label-success',1,'2023-12-13 10:15:57','2023-11-10 00:00:00'),(2,'Late','<b class=\"text text-warning\">L</b>','yes',1,'late','label label-warning',1,'2023-12-13 10:16:01','2023-11-10 00:00:00'),(3,'Absent','<b class=\"text text-danger\">A</b>','yes',0,'absent','label label-danger',0,'2023-12-13 10:16:06','2023-11-10 00:00:00'),(4,'Half Day','<b class=\"text text-warning\">F</b>','yes',1,'half_day','label label-info',1,'2023-12-14 12:57:07','2023-11-10 00:00:00'),(5,'Holiday','H','yes',0,'holiday','label label-warning text-dark',0,'2023-12-13 10:16:17','2023-11-10 00:00:00'),(6,'Half Day Second Shift','<b class=\"text text-warning\">SH</b>','yes',1,'half_day_second_shift','label label-info',1,'2024-09-24 12:28:42','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `staff_attendance_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_attendence_schedules`
--

DROP TABLE IF EXISTS `staff_attendence_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_attendence_schedules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_attendence_type_id` int DEFAULT NULL,
  `role_id` int DEFAULT NULL,
  `entry_time_from` time DEFAULT NULL,
  `entry_time_to` time DEFAULT NULL,
  `total_institute_hour` time DEFAULT '00:00:00',
  `is_active` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_attendence_schedules`
--

LOCK TABLES `staff_attendence_schedules` WRITE;
/*!40000 ALTER TABLE `staff_attendence_schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_attendence_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_designation`
--

DROP TABLE IF EXISTS `staff_designation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_designation` (
  `id` int NOT NULL AUTO_INCREMENT,
  `designation` varchar(200) NOT NULL,
  `is_active` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_designation`
--

LOCK TABLES `staff_designation` WRITE;
/*!40000 ALTER TABLE `staff_designation` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_designation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_id_card`
--

DROP TABLE IF EXISTS `staff_id_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_id_card` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `school_name` varchar(255) NOT NULL,
  `school_address` varchar(255) NOT NULL,
  `background` varchar(100) NOT NULL,
  `logo` varchar(100) NOT NULL,
  `sign_image` varchar(100) NOT NULL,
  `header_color` varchar(100) NOT NULL,
  `enable_vertical_card` int NOT NULL DEFAULT '0',
  `enable_staff_role` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_staff_id` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_staff_department` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_designation` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_name` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_fathers_name` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_mothers_name` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_date_of_joining` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_permanent_address` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_staff_dob` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_staff_phone` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `enable_staff_barcode` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  `status` tinyint(1) NOT NULL COMMENT '0=disable,1=enable',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_id_card`
--

LOCK TABLES `staff_id_card` WRITE;
/*!40000 ALTER TABLE `staff_id_card` DISABLE KEYS */;
INSERT INTO `staff_id_card` VALUES (1,'Sample Staff ID Card Horizontal','Mount Carmel School','110 Kings Street, CA','background1.png','logo1.png','sign1.png','#9b1818',0,0,1,0,0,1,1,1,1,1,1,1,0,1),(2,'Sample Staff ID Card Vertical','Mount Carmel School','110 Kings Street, CA','background1.png','logo1.png','sign1.png','#9b1818',1,0,1,0,0,1,1,1,1,1,1,1,0,1);
/*!40000 ALTER TABLE `staff_id_card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_leave_details`
--

DROP TABLE IF EXISTS `staff_leave_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_leave_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `leave_type_id` int NOT NULL,
  `alloted_leave` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_staff_leave_details_staff` (`staff_id`),
  KEY `FK_staff_leave_details_leave_types` (`leave_type_id`),
  CONSTRAINT `FK_staff_leave_details_leave_types` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_staff_leave_details_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_leave_details`
--

LOCK TABLES `staff_leave_details` WRITE;
/*!40000 ALTER TABLE `staff_leave_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_leave_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_leave_request`
--

DROP TABLE IF EXISTS `staff_leave_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_leave_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `leave_type_id` int NOT NULL,
  `leave_from` date NOT NULL,
  `leave_to` date NOT NULL,
  `leave_days` int NOT NULL,
  `employee_remark` varchar(200) NOT NULL,
  `admin_remark` varchar(200) NOT NULL,
  `approve_date` date DEFAULT NULL,
  `status` varchar(50) NOT NULL,
  `applied_by` int DEFAULT NULL,
  `document_file` varchar(200) NOT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_staff_leave_request_staff` (`staff_id`),
  KEY `FK_staff_leave_request_leave_types` (`leave_type_id`),
  KEY `applied_by` (`applied_by`),
  CONSTRAINT `FK_staff_leave_request_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `staff_leave_request_ibfk_1` FOREIGN KEY (`applied_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `staff_leave_request_ibfk_2` FOREIGN KEY (`leave_type_id`) REFERENCES `leave_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_leave_request`
--

LOCK TABLES `staff_leave_request` WRITE;
/*!40000 ALTER TABLE `staff_leave_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_leave_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_payroll`
--

DROP TABLE IF EXISTS `staff_payroll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_payroll` (
  `id` int NOT NULL AUTO_INCREMENT,
  `basic_salary` int NOT NULL,
  `pay_scale` varchar(200) NOT NULL,
  `grade` varchar(50) NOT NULL,
  `is_active` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_payroll`
--

LOCK TABLES `staff_payroll` WRITE;
/*!40000 ALTER TABLE `staff_payroll` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_payroll` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_payslip`
--

DROP TABLE IF EXISTS `staff_payslip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_payslip` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `basic` float(10,2) NOT NULL,
  `total_allowance` float(10,2) NOT NULL,
  `total_deduction` float(10,2) NOT NULL,
  `leave_deduction` int NOT NULL,
  `tax` varchar(200) NOT NULL,
  `net_salary` float(10,2) NOT NULL,
  `status` varchar(100) NOT NULL,
  `month` varchar(200) NOT NULL,
  `year` varchar(200) NOT NULL,
  `payment_mode` varchar(200) NOT NULL,
  `payment_date` date NOT NULL,
  `remark` varchar(200) NOT NULL,
  `generated_by` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_staff_payslip_staff` (`staff_id`),
  CONSTRAINT `FK_staff_payslip_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_payslip`
--

LOCK TABLES `staff_payslip` WRITE;
/*!40000 ALTER TABLE `staff_payslip` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_payslip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_rating`
--

DROP TABLE IF EXISTS `staff_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_rating` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `comment` text NOT NULL,
  `rate` int NOT NULL,
  `user_id` int NOT NULL,
  `role` varchar(255) NOT NULL,
  `status` int NOT NULL COMMENT '0 decline, 1 Approve',
  `entrydt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_staff_rating_staff` (`staff_id`),
  CONSTRAINT `FK_staff_rating_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_rating`
--

LOCK TABLES `staff_rating` WRITE;
/*!40000 ALTER TABLE `staff_rating` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_roles`
--

DROP TABLE IF EXISTS `staff_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `FK_staff_roles_roles` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_staff_roles_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_roles`
--

LOCK TABLES `staff_roles` WRITE;
/*!40000 ALTER TABLE `staff_roles` DISABLE KEYS */;
INSERT INTO `staff_roles` VALUES (1,7,1,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(2,2,2,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(3,10,3,1,'2026-01-29 17:07:09','2026-01-29 17:07:09'),(4,2,4,1,'2026-01-29 17:07:09','2026-01-29 17:07:09');
/*!40000 ALTER TABLE `staff_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_timeline`
--

DROP TABLE IF EXISTS `staff_timeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_timeline` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `timeline_date` date NOT NULL,
  `description` varchar(300) NOT NULL,
  `document` varchar(200) NOT NULL,
  `status` varchar(200) NOT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_staff_timeline_staff` (`staff_id`),
  CONSTRAINT `FK_staff_timeline_staff` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_timeline`
--

LOCK TABLES `staff_timeline` WRITE;
/*!40000 ALTER TABLE `staff_timeline` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff_timeline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_accommodations`
--

DROP TABLE IF EXISTS `student_accommodations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_accommodations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `student_session_id` int NOT NULL,
  `accommodation_type` varchar(100) NOT NULL DEFAULT 'extra_time',
  `extra_time_percent` int NOT NULL DEFAULT '25',
  `notes` text,
  `approved_by_staff_id` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_student_session` (`student_session_id`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_accommodations`
--

LOCK TABLES `student_accommodations` WRITE;
/*!40000 ALTER TABLE `student_accommodations` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_accommodations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_applied_discounts`
--

DROP TABLE IF EXISTS `student_applied_discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_applied_discounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_fees_deposite_id` int DEFAULT NULL,
  `student_fees_discount_id` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `invoice_id` int DEFAULT NULL,
  `sub_invoice_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_fees_deposite_id` (`student_fees_deposite_id`),
  KEY `student_fees_discount_id` (`student_fees_discount_id`),
  CONSTRAINT `student_applied_discounts_ibfk_1` FOREIGN KEY (`student_fees_deposite_id`) REFERENCES `student_fees_deposite` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_applied_discounts_ibfk_2` FOREIGN KEY (`student_fees_discount_id`) REFERENCES `student_fees_discounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_applied_discounts`
--

LOCK TABLES `student_applied_discounts` WRITE;
/*!40000 ALTER TABLE `student_applied_discounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_applied_discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_applyleave`
--

DROP TABLE IF EXISTS `student_applyleave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_applyleave` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_session_id` int NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `apply_date` date NOT NULL,
  `status` int NOT NULL,
  `docs` varchar(200) DEFAULT NULL,
  `reason` text NOT NULL,
  `approve_by` int DEFAULT NULL,
  `approve_date` date DEFAULT NULL,
  `request_type` int NOT NULL COMMENT '0 student,1 staff',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `approve_by` (`approve_by`),
  CONSTRAINT `student_applyleave_ibfk_1` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_applyleave_ibfk_2` FOREIGN KEY (`approve_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_applyleave`
--

LOCK TABLES `student_applyleave` WRITE;
/*!40000 ALTER TABLE `student_applyleave` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_applyleave` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_attendence_schedules`
--

DROP TABLE IF EXISTS `student_attendence_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_attendence_schedules` (
  `id` int NOT NULL AUTO_INCREMENT,
  `attendence_type_id` int DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `entry_time_from` time DEFAULT NULL,
  `entry_time_to` time DEFAULT NULL,
  `total_institute_hour` time DEFAULT NULL,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_attendence_schedules`
--

LOCK TABLES `student_attendence_schedules` WRITE;
/*!40000 ALTER TABLE `student_attendence_schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_attendence_schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_attendences`
--

DROP TABLE IF EXISTS `student_attendences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_attendences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `enrolment_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `biometric_attendence` int NOT NULL DEFAULT '0',
  `qrcode_attendance` int NOT NULL DEFAULT '0',
  `date` date DEFAULT NULL,
  `attendence_type_id` int DEFAULT NULL,
  `remark` varchar(200) NOT NULL,
  `biometric_device_data` text,
  `user_agent` varchar(250) DEFAULT NULL,
  `in_time` time DEFAULT NULL,
  `out_time` time DEFAULT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `attendence_type_id` (`attendence_type_id`),
  KEY `idx_enrolment` (`enrolment_id`),
  CONSTRAINT `student_attendences_ibfk_1` FOREIGN KEY (`attendence_type_id`) REFERENCES `attendence_type` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_attendences_ibfk_2` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_attendences`
--

LOCK TABLES `student_attendences` WRITE;
/*!40000 ALTER TABLE `student_attendences` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_attendences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_dashboard_settings`
--

DROP TABLE IF EXISTS `student_dashboard_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_dashboard_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) DEFAULT NULL,
  `short_code` varchar(255) NOT NULL,
  `is_student` int DEFAULT NULL,
  `is_parent` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_dashboard_settings`
--

LOCK TABLES `student_dashboard_settings` WRITE;
/*!40000 ALTER TABLE `student_dashboard_settings` DISABLE KEYS */;
INSERT INTO `student_dashboard_settings` VALUES (1,'welcome_student','',1,1,'2024-10-15 12:14:22','2026-01-29 12:14:53'),(2,'notice_board','communicate',1,1,'2024-10-15 12:14:25','2026-01-29 12:14:53'),(3,'subject_progress','lesson_plan',1,1,'2024-10-15 12:14:27','2026-01-29 12:14:53'),(4,'upcomming_class','academics',1,1,'2024-10-15 12:14:55','2026-01-29 12:14:53'),(5,'homework','homework',1,1,'2024-10-15 12:14:56','2026-01-29 12:14:53'),(6,'teacher_list','human_resource',1,1,'2024-10-15 12:14:57','2026-01-29 12:14:53'),(7,'visitor_list','front_office',1,1,'2024-10-15 12:14:58','2026-01-29 12:14:53'),(8,'library','library',1,1,'2024-10-15 12:14:59','2026-01-29 12:14:53');
/*!40000 ALTER TABLE `student_dashboard_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_doc`
--

DROP TABLE IF EXISTS `student_doc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_doc` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `doc` varchar(200) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_student_id` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_doc`
--

LOCK TABLES `student_doc` WRITE;
/*!40000 ALTER TABLE `student_doc` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_doc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_edit_fields`
--

DROP TABLE IF EXISTS `student_edit_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_edit_fields` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) DEFAULT NULL,
  `status` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_edit_fields`
--

LOCK TABLES `student_edit_fields` WRITE;
/*!40000 ALTER TABLE `student_edit_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_edit_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_educational_details`
--

DROP TABLE IF EXISTS `student_educational_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_educational_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course` varchar(255) NOT NULL,
  `university` varchar(255) NOT NULL,
  `education_year` varchar(255) NOT NULL,
  `education_detail` varchar(255) NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_educational_details`
--

LOCK TABLES `student_educational_details` WRITE;
/*!40000 ALTER TABLE `student_educational_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_educational_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_fees`
--

DROP TABLE IF EXISTS `student_fees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_fees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_session_id` int DEFAULT NULL,
  `feemaster_id` int DEFAULT NULL,
  `amount` float(10,2) DEFAULT NULL,
  `amount_discount` float(10,2) NOT NULL,
  `amount_fine` float(10,2) NOT NULL DEFAULT '0.00',
  `description` text,
  `date` date DEFAULT NULL,
  `payment_mode` varchar(50) NOT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `feemaster_id` (`feemaster_id`),
  KEY `student_session_id` (`student_session_id`),
  CONSTRAINT `student_fees_ibfk_1` FOREIGN KEY (`feemaster_id`) REFERENCES `feemasters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_fees_ibfk_2` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_fees`
--

LOCK TABLES `student_fees` WRITE;
/*!40000 ALTER TABLE `student_fees` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_fees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_fees_deposite`
--

DROP TABLE IF EXISTS `student_fees_deposite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_fees_deposite` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_fees_master_id` int DEFAULT NULL,
  `fee_groups_feetype_id` int DEFAULT NULL,
  `student_transport_fee_id` int DEFAULT NULL,
  `amount_detail` text,
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_fees_master_id` (`student_fees_master_id`),
  KEY `fee_groups_feetype_id` (`fee_groups_feetype_id`),
  KEY `student_transport_fee_id` (`student_transport_fee_id`),
  CONSTRAINT `student_fees_deposite_ibfk_1` FOREIGN KEY (`student_transport_fee_id`) REFERENCES `student_transport_fees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_fees_deposite_ibfk_2` FOREIGN KEY (`student_fees_master_id`) REFERENCES `student_fees_master` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_fees_deposite_ibfk_3` FOREIGN KEY (`fee_groups_feetype_id`) REFERENCES `fee_groups_feetype` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_fees_deposite`
--

LOCK TABLES `student_fees_deposite` WRITE;
/*!40000 ALTER TABLE `student_fees_deposite` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_fees_deposite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_fees_discounts`
--

DROP TABLE IF EXISTS `student_fees_discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_fees_discounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_session_id` int DEFAULT NULL,
  `fees_discount_id` int DEFAULT NULL,
  `status` varchar(20) DEFAULT 'assigned',
  `payment_id` varchar(50) DEFAULT NULL,
  `description` text,
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `fees_discount_id` (`fees_discount_id`),
  CONSTRAINT `student_fees_discounts_ibfk_1` FOREIGN KEY (`fees_discount_id`) REFERENCES `fees_discounts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_fees_discounts_ibfk_2` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_fees_discounts`
--

LOCK TABLES `student_fees_discounts` WRITE;
/*!40000 ALTER TABLE `student_fees_discounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_fees_discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_fees_master`
--

DROP TABLE IF EXISTS `student_fees_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_fees_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `is_system` int NOT NULL DEFAULT '0',
  `student_session_id` int DEFAULT NULL,
  `fee_session_group_id` int DEFAULT NULL,
  `amount` float(10,2) DEFAULT '0.00',
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `fee_session_group_id` (`fee_session_group_id`),
  CONSTRAINT `student_fees_master_ibfk_1` FOREIGN KEY (`fee_session_group_id`) REFERENCES `fee_session_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_fees_master_ibfk_2` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_fees_master`
--

LOCK TABLES `student_fees_master` WRITE;
/*!40000 ALTER TABLE `student_fees_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_fees_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_fees_processing`
--

DROP TABLE IF EXISTS `student_fees_processing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_fees_processing` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gateway_ins_id` int NOT NULL,
  `fee_category` varchar(255) NOT NULL,
  `student_fees_master_id` int DEFAULT NULL,
  `fee_groups_feetype_id` int DEFAULT NULL,
  `student_transport_fee_id` int DEFAULT NULL,
  `amount_detail` text,
  `is_active` varchar(10) NOT NULL DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_fees_master_id` (`student_fees_master_id`),
  KEY `fee_groups_feetype_id` (`fee_groups_feetype_id`),
  KEY `student_transport_fee_id` (`student_transport_fee_id`),
  KEY `gateway_ins_id` (`gateway_ins_id`),
  CONSTRAINT `student_fees_processing_ibfk_1` FOREIGN KEY (`student_fees_master_id`) REFERENCES `student_fees_master` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_fees_processing_ibfk_2` FOREIGN KEY (`student_transport_fee_id`) REFERENCES `student_transport_fees` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_fees_processing_ibfk_3` FOREIGN KEY (`fee_groups_feetype_id`) REFERENCES `fee_groups_feetype` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_fees_processing_ibfk_4` FOREIGN KEY (`gateway_ins_id`) REFERENCES `gateway_ins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_fees_processing`
--

LOCK TABLES `student_fees_processing` WRITE;
/*!40000 ALTER TABLE `student_fees_processing` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_fees_processing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_programme`
--

DROP TABLE IF EXISTS `student_programme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_programme` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `programme_id` int NOT NULL COMMENT 'Main programme',
  `qualification_id` int DEFAULT NULL COMMENT 'e.g., Business Management',
  `current_level_id` int DEFAULT NULL COMMENT 'e.g., N4',
  `session_id` int NOT NULL,
  `registration_date` date NOT NULL,
  `status` enum('Active','Completed','Suspended','Transferred','Withdrawn') NOT NULL DEFAULT 'Active',
  `completion_date` date DEFAULT NULL,
  `student_number` varchar(50) DEFAULT NULL COMMENT 'Official student number',
  `notes` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_student_programme_session` (`student_id`,`programme_id`,`session_id`),
  KEY `idx_student` (`student_id`),
  KEY `idx_programme` (`programme_id`),
  KEY `idx_qualification` (`qualification_id`),
  KEY `idx_level` (`current_level_id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_unified_sp_level` FOREIGN KEY (`current_level_id`) REFERENCES `level` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_sp_programme` FOREIGN KEY (`programme_id`) REFERENCES `programme` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_sp_qualification` FOREIGN KEY (`qualification_id`) REFERENCES `qualification` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_sp_session` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_sp_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_programme`
--

LOCK TABLES `student_programme` WRITE;
/*!40000 ALTER TABLE `student_programme` DISABLE KEYS */;
INSERT INTO `student_programme` VALUES (1,1,1,NULL,10,27,'2026-02-03','Active',NULL,NULL,NULL,1,'2026-02-03 16:14:53','2026-02-03 16:14:53'),(2,2,1,NULL,10,27,'2026-02-03','Active',NULL,NULL,NULL,1,'2026-02-03 16:14:53','2026-02-03 16:14:53');
/*!40000 ALTER TABLE `student_programme` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_refrence`
--

DROP TABLE IF EXISTS `student_refrence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_refrence` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `relation` varchar(255) NOT NULL,
  `age` varchar(255) NOT NULL,
  `profession` varchar(255) NOT NULL,
  `contact` varchar(255) NOT NULL,
  `student_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_refrence`
--

LOCK TABLES `student_refrence` WRITE;
/*!40000 ALTER TABLE `student_refrence` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_refrence` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_session`
--

DROP TABLE IF EXISTS `student_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_session` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `student_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `hostel_room_id` int DEFAULT NULL,
  `vehroute_id` int DEFAULT NULL,
  `route_pickup_point_id` int DEFAULT NULL,
  `transport_fees` float(10,2) NOT NULL DEFAULT '0.00',
  `fees_discount` float(10,2) NOT NULL DEFAULT '0.00',
  `is_leave` int NOT NULL DEFAULT '0',
  `is_active` varchar(255) DEFAULT 'no',
  `is_alumni` int NOT NULL,
  `default_login` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  KEY `student_id` (`student_id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`),
  KEY `student_session_ibfk_5` (`vehroute_id`),
  KEY `hostel_room_id` (`hostel_room_id`),
  KEY `student_session_ibfk_6` (`route_pickup_point_id`),
  CONSTRAINT `student_session_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_session_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_session_ibfk_3` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_session_ibfk_4` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_session_ibfk_5` FOREIGN KEY (`vehroute_id`) REFERENCES `vehicle_routes` (`id`) ON DELETE SET NULL,
  CONSTRAINT `student_session_ibfk_6` FOREIGN KEY (`route_pickup_point_id`) REFERENCES `route_pickup_point` (`id`) ON DELETE SET NULL,
  CONSTRAINT `student_session_ibfk_7` FOREIGN KEY (`hostel_room_id`) REFERENCES `hostel_rooms` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_session`
--

LOCK TABLES `student_session` WRITE;
/*!40000 ALTER TABLE `student_session` DISABLE KEYS */;
INSERT INTO `student_session` VALUES (1,27,1,1,1,NULL,NULL,NULL,0.00,0.00,0,'no',0,1,'2026-01-29 12:15:00','2026-01-29 12:19:19'),(2,27,2,1,1,NULL,NULL,NULL,0.00,0.00,0,'no',0,1,'2026-01-29 12:15:00','2026-01-29 14:49:35');
/*!40000 ALTER TABLE `student_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_skills_detail`
--

DROP TABLE IF EXISTS `student_skills_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_skills_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `skill_category` varchar(255) NOT NULL,
  `skill_detail` varchar(255) NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_skills_detail`
--

LOCK TABLES `student_skills_detail` WRITE;
/*!40000 ALTER TABLE `student_skills_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_skills_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_subject_attendances`
--

DROP TABLE IF EXISTS `student_subject_attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_subject_attendances` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_session_id` int DEFAULT NULL,
  `subject_timetable_id` int DEFAULT NULL,
  `attendence_type_id` int DEFAULT NULL,
  `date` date DEFAULT NULL,
  `remark` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `attendence_type_id` (`attendence_type_id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `subject_timetable_id` (`subject_timetable_id`),
  CONSTRAINT `student_subject_attendances_ibfk_1` FOREIGN KEY (`attendence_type_id`) REFERENCES `attendence_type` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_subject_attendances_ibfk_2` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_subject_attendances_ibfk_3` FOREIGN KEY (`subject_timetable_id`) REFERENCES `subject_timetable` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_subject_attendances`
--

LOCK TABLES `student_subject_attendances` WRITE;
/*!40000 ALTER TABLE `student_subject_attendances` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_subject_attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_timeline`
--

DROP TABLE IF EXISTS `student_timeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_timeline` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `title` varchar(200) NOT NULL,
  `timeline_date` date NOT NULL,
  `description` text NOT NULL,
  `document` varchar(200) DEFAULT NULL,
  `status` varchar(200) NOT NULL,
  `created_student_id` int NOT NULL,
  `date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `student_timeline_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_timeline`
--

LOCK TABLES `student_timeline` WRITE;
/*!40000 ALTER TABLE `student_timeline` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_timeline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_transport_fees`
--

DROP TABLE IF EXISTS `student_transport_fees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_transport_fees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `transport_feemaster_id` int NOT NULL,
  `student_session_id` int NOT NULL,
  `route_pickup_point_id` int NOT NULL,
  `generated_by` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_session_id` (`student_session_id`),
  KEY `route_pickup_point_id` (`route_pickup_point_id`),
  KEY `transport_feemaster_id` (`transport_feemaster_id`),
  CONSTRAINT `student_transport_fees_ibfk_1` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_transport_fees_ibfk_2` FOREIGN KEY (`route_pickup_point_id`) REFERENCES `route_pickup_point` (`id`) ON DELETE CASCADE,
  CONSTRAINT `student_transport_fees_ibfk_3` FOREIGN KEY (`transport_feemaster_id`) REFERENCES `transport_feemaster` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_transport_fees`
--

LOCK TABLES `student_transport_fees` WRITE;
/*!40000 ALTER TABLE `student_transport_fees` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_transport_fees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_work_experience`
--

DROP TABLE IF EXISTS `student_work_experience`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_work_experience` (
  `id` int NOT NULL AUTO_INCREMENT,
  `institute` text NOT NULL,
  `designation` text NOT NULL,
  `year` varchar(255) NOT NULL,
  `location` text NOT NULL,
  `detail` text NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_work_experience`
--

LOCK TABLES `student_work_experience` WRITE;
/*!40000 ALTER TABLE `student_work_experience` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_work_experience` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
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
  `is_disabled` enum('yes','no') DEFAULT 'no',
  `disability_type_id` int DEFAULT NULL,
  `disability_details` text,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_admission_no` (`admission_no`),
  KEY `idx_roll_no` (`roll_no`),
  KEY `idx_mobileno` (`mobileno`),
  KEY `idx_email` (`email`),
  KEY `idx_firstname` (`firstname`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,0,'2026001','',NULL,'Test',NULL,'Student',NULL,NULL,'0821234567','student@school.com',NULL,NULL,NULL,'','','2000-05-20','Male','','','',0,'',0,'','','','','','father','','','','','','','Parent Name','','0829876543','','','','','','','yes','no',NULL,NULL,'','','',NULL,0,'','',NULL,NULL,NULL,NULL,1,NULL,'2026-01-29 12:15:00','2026-01-29 15:54:15'),(2,0,'2026002',NULL,NULL,'Jane',NULL,'Disability',NULL,NULL,'0821234568','student2@school.com',NULL,NULL,NULL,NULL,NULL,'2001-08-10','Female',NULL,NULL,NULL,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,'mother',NULL,NULL,NULL,NULL,NULL,NULL,'Parent Two',NULL,'0829876544','',NULL,NULL,'','','','yes','yes',1,'Visual impairment - requires extra time',NULL,'','',NULL,0,NULL,'',NULL,NULL,NULL,NULL,NULL,NULL,'2026-01-29 12:15:00','2026-01-29 14:47:48');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject_group_class_sections`
--

DROP TABLE IF EXISTS `subject_group_class_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_group_class_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_group_id` int DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `description` text,
  `is_active` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `class_section_id` (`class_section_id`),
  KEY `subject_group_id` (`subject_group_id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `subject_group_class_sections_ibfk_1` FOREIGN KEY (`class_section_id`) REFERENCES `class_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_group_class_sections_ibfk_2` FOREIGN KEY (`subject_group_id`) REFERENCES `subject_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_group_class_sections_ibfk_3` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject_group_class_sections`
--

LOCK TABLES `subject_group_class_sections` WRITE;
/*!40000 ALTER TABLE `subject_group_class_sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `subject_group_class_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject_group_subjects`
--

DROP TABLE IF EXISTS `subject_group_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_group_subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_group_id` int DEFAULT NULL,
  `session_id` int DEFAULT NULL,
  `subject_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `subject_group_id` (`subject_group_id`),
  KEY `session_id` (`session_id`),
  KEY `subject_id` (`subject_id`),
  CONSTRAINT `subject_group_subjects_ibfk_1` FOREIGN KEY (`subject_group_id`) REFERENCES `subject_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_group_subjects_ibfk_2` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_group_subjects_ibfk_3` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject_group_subjects`
--

LOCK TABLES `subject_group_subjects` WRITE;
/*!40000 ALTER TABLE `subject_group_subjects` DISABLE KEYS */;
INSERT INTO `subject_group_subjects` VALUES (1,1,NULL,1,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(2,1,NULL,2,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(3,1,NULL,3,'2026-01-29 12:15:00','2026-01-29 12:15:00'),(4,1,NULL,4,'2026-01-29 12:15:00','2026-01-29 12:15:00');
/*!40000 ALTER TABLE `subject_group_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject_groups`
--

DROP TABLE IF EXISTS `subject_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(250) DEFAULT NULL,
  `description` text,
  `session_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `subject_groups_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject_groups`
--

LOCK TABLES `subject_groups` WRITE;
/*!40000 ALTER TABLE `subject_groups` DISABLE KEYS */;
INSERT INTO `subject_groups` VALUES (1,'N4 Core Modules','N4 Business Management Core',27,'2026-01-29 12:15:00','2026-01-29 12:15:00');
/*!40000 ALTER TABLE `subject_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject_level`
--

DROP TABLE IF EXISTS `subject_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `subject_id` int NOT NULL,
  `level_id` int NOT NULL,
  `syllabus_code` varchar(50) DEFAULT NULL COMMENT 'DHET syllabus reference',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_subject_level` (`subject_id`,`level_id`),
  KEY `idx_subject` (`subject_id`),
  KEY `idx_level` (`level_id`),
  CONSTRAINT `fk_unified_unified_sl_level` FOREIGN KEY (`level_id`) REFERENCES `level` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_unified_unified_sl_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject_level`
--

LOCK TABLES `subject_level` WRITE;
/*!40000 ALTER TABLE `subject_level` DISABLE KEYS */;
INSERT INTO `subject_level` VALUES (1,4,1,NULL,1,'2026-02-03 16:14:53'),(2,3,1,NULL,1,'2026-02-03 16:14:53'),(3,2,1,NULL,1,'2026-02-03 16:14:53'),(4,1,1,NULL,1,'2026-02-03 16:14:53'),(5,4,2,NULL,1,'2026-02-03 16:14:53'),(6,3,2,NULL,1,'2026-02-03 16:14:53'),(7,2,2,NULL,1,'2026-02-03 16:14:53'),(8,1,2,NULL,1,'2026-02-03 16:14:53'),(9,4,3,NULL,1,'2026-02-03 16:14:53'),(10,3,3,NULL,1,'2026-02-03 16:14:53'),(11,2,3,NULL,1,'2026-02-03 16:14:53'),(12,1,3,NULL,1,'2026-02-03 16:14:53'),(13,4,4,NULL,1,'2026-02-03 16:14:53'),(14,3,4,NULL,1,'2026-02-03 16:14:53'),(15,2,4,NULL,1,'2026-02-03 16:14:53'),(16,1,4,NULL,1,'2026-02-03 16:14:53'),(17,4,5,NULL,1,'2026-02-03 16:14:53'),(18,3,5,NULL,1,'2026-02-03 16:14:53'),(19,2,5,NULL,1,'2026-02-03 16:14:53'),(20,1,5,NULL,1,'2026-02-03 16:14:53'),(21,4,6,NULL,1,'2026-02-03 16:14:53'),(22,3,6,NULL,1,'2026-02-03 16:14:53'),(23,2,6,NULL,1,'2026-02-03 16:14:53'),(24,1,6,NULL,1,'2026-02-03 16:14:53'),(25,4,7,NULL,1,'2026-02-03 16:14:53'),(26,3,7,NULL,1,'2026-02-03 16:14:53'),(27,2,7,NULL,1,'2026-02-03 16:14:53'),(28,1,7,NULL,1,'2026-02-03 16:14:53'),(29,4,8,NULL,1,'2026-02-03 16:14:53'),(30,3,8,NULL,1,'2026-02-03 16:14:53'),(31,2,8,NULL,1,'2026-02-03 16:14:53'),(32,1,8,NULL,1,'2026-02-03 16:14:53'),(33,4,9,NULL,1,'2026-02-03 16:14:53'),(34,3,9,NULL,1,'2026-02-03 16:14:53'),(35,2,9,NULL,1,'2026-02-03 16:14:53'),(36,1,9,NULL,1,'2026-02-03 16:14:53'),(37,4,10,NULL,1,'2026-02-03 16:14:53'),(38,3,10,NULL,1,'2026-02-03 16:14:53'),(39,2,10,NULL,1,'2026-02-03 16:14:53'),(40,1,10,NULL,1,'2026-02-03 16:14:53'),(41,4,11,NULL,1,'2026-02-03 16:14:53'),(42,3,11,NULL,1,'2026-02-03 16:14:53'),(43,2,11,NULL,1,'2026-02-03 16:14:53'),(44,1,11,NULL,1,'2026-02-03 16:14:53'),(45,4,12,NULL,1,'2026-02-03 16:14:53'),(46,3,12,NULL,1,'2026-02-03 16:14:53'),(47,2,12,NULL,1,'2026-02-03 16:14:53'),(48,1,12,NULL,1,'2026-02-03 16:14:53');
/*!40000 ALTER TABLE `subject_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject_syllabus`
--

DROP TABLE IF EXISTS `subject_syllabus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_syllabus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `topic_id` int NOT NULL,
  `session_id` int NOT NULL,
  `created_by` int NOT NULL,
  `created_for` int NOT NULL,
  `date` date NOT NULL,
  `time_from` varchar(255) NOT NULL,
  `time_to` varchar(255) NOT NULL,
  `presentation` text NOT NULL,
  `attachment` text NOT NULL,
  `lacture_youtube_url` varchar(255) NOT NULL,
  `lacture_video` varchar(255) NOT NULL,
  `sub_topic` text NOT NULL,
  `teaching_method` text NOT NULL,
  `general_objectives` text NOT NULL,
  `previous_knowledge` text NOT NULL,
  `comprehensive_questions` text NOT NULL,
  `status` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `topic_id` (`topic_id`),
  KEY `session_id` (`session_id`),
  KEY `created_by` (`created_by`),
  KEY `created_for` (`created_for`),
  CONSTRAINT `subject_syllabus_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `topic` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_syllabus_ibfk_2` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_syllabus_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_syllabus_ibfk_4` FOREIGN KEY (`created_for`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject_syllabus`
--

LOCK TABLES `subject_syllabus` WRITE;
/*!40000 ALTER TABLE `subject_syllabus` DISABLE KEYS */;
/*!40000 ALTER TABLE `subject_syllabus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subject_timetable`
--

DROP TABLE IF EXISTS `subject_timetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subject_timetable` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL,
  `section_id` int DEFAULT NULL,
  `subject_group_id` int DEFAULT NULL,
  `subject_group_subject_id` int DEFAULT NULL,
  `staff_id` int DEFAULT NULL,
  `day` varchar(20) DEFAULT NULL,
  `time_from` varchar(20) DEFAULT NULL,
  `time_to` varchar(20) DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `room_no` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `class_id` (`class_id`),
  KEY `section_id` (`section_id`),
  KEY `subject_group_id` (`subject_group_id`),
  KEY `subject_group_subject_id` (`subject_group_subject_id`),
  KEY `staff_id` (`staff_id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `subject_timetable_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_timetable_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_timetable_ibfk_3` FOREIGN KEY (`subject_group_id`) REFERENCES `subject_groups` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_timetable_ibfk_4` FOREIGN KEY (`subject_group_subject_id`) REFERENCES `subject_group_subjects` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_timetable_ibfk_5` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `subject_timetable_ibfk_6` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subject_timetable`
--

LOCK TABLES `subject_timetable` WRITE;
/*!40000 ALTER TABLE `subject_timetable` DISABLE KEYS */;
/*!40000 ALTER TABLE `subject_timetable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subjects`
--

DROP TABLE IF EXISTS `subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `programme_id` int DEFAULT NULL,
  `qualification_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `code` varchar(100) NOT NULL,
  `credits` int NOT NULL DEFAULT '0',
  `notional_hours` int NOT NULL DEFAULT '0',
  `is_core` tinyint(1) NOT NULL DEFAULT '1',
  `type` varchar(100) NOT NULL,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`),
  KEY `idx_code` (`code`),
  KEY `idx_subject_programme` (`programme_id`),
  KEY `idx_subject_qualification` (`qualification_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subjects`
--

LOCK TABLES `subjects` WRITE;
/*!40000 ALTER TABLE `subjects` DISABLE KEYS */;
INSERT INTO `subjects` VALUES (1,1,NULL,'Business Management N4','BMN4',0,0,1,'theory','yes','2026-01-29 12:15:00','2026-02-03 16:14:53'),(2,1,NULL,'Financial Management N4','FMN4',0,0,1,'theory','yes','2026-01-29 12:15:00','2026-02-03 16:14:53'),(3,1,NULL,'Marketing & Communication N4','MCN4',0,0,1,'theory','yes','2026-01-29 12:15:00','2026-02-03 16:14:53'),(4,1,NULL,'Entrepreneurship N4','EBMN4',0,0,1,'theory','yes','2026-01-29 12:15:00','2026-02-03 16:14:53');
/*!40000 ALTER TABLE `subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submit_assignment`
--

DROP TABLE IF EXISTS `submit_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submit_assignment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `homework_id` int NOT NULL,
  `student_id` int NOT NULL,
  `message` text NOT NULL,
  `docs` varchar(225) NOT NULL,
  `file_name` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `homework_id` (`homework_id`),
  CONSTRAINT `submit_assignment_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  CONSTRAINT `submit_assignment_ibfk_2` FOREIGN KEY (`homework_id`) REFERENCES `homework` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submit_assignment`
--

LOCK TABLES `submit_assignment` WRITE;
/*!40000 ALTER TABLE `submit_assignment` DISABLE KEYS */;
/*!40000 ALTER TABLE `submit_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teacher_subjects`
--

DROP TABLE IF EXISTS `teacher_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teacher_subjects` (
  `id` int NOT NULL AUTO_INCREMENT,
  `class_id` int NOT NULL COMMENT 'TVET class ID (replaces class_section_id)',
  `subject_id` int NOT NULL COMMENT 'Subject ID from subjects table',
  `teacher_id` int NOT NULL COMMENT 'Staff ID (lecturer)',
  `session_id` int NOT NULL COMMENT 'Academic session',
  `role` enum('Primary','Assistant','Tutor','Assessor','Moderator') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Primary',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_class_subject` (`class_id`,`subject_id`),
  KEY `idx_teacher` (`teacher_id`),
  KEY `idx_session` (`session_id`),
  KEY `idx_active` (`is_active`),
  KEY `fk_teacher_subjects_subject` (`subject_id`),
  CONSTRAINT `fk_teacher_subjects_class` FOREIGN KEY (`class_id`) REFERENCES `class` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_teacher_subjects_session` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_teacher_subjects_staff` FOREIGN KEY (`teacher_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_teacher_subjects_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher_subjects`
--

LOCK TABLES `teacher_subjects` WRITE;
/*!40000 ALTER TABLE `teacher_subjects` DISABLE KEYS */;
INSERT INTO `teacher_subjects` VALUES (1,1,1,2,27,'Primary',1,'2026-02-03 16:44:56','2026-02-03 16:44:56'),(2,2,2,2,27,'Primary',1,'2026-02-03 16:44:56','2026-02-03 16:44:56'),(3,3,3,2,27,'Primary',1,'2026-02-03 16:44:56','2026-02-03 16:44:56'),(4,4,4,2,27,'Primary',1,'2026-02-03 16:44:56','2026-02-03 16:44:56'),(5,5,1,2,27,'Primary',1,'2026-02-03 16:44:56','2026-02-03 16:44:56');
/*!40000 ALTER TABLE `teacher_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `template_admitcards`
--

DROP TABLE IF EXISTS `template_admitcards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `template_admitcards` (
  `id` int NOT NULL AUTO_INCREMENT,
  `template` varchar(250) DEFAULT NULL,
  `heading` text,
  `title` text,
  `left_logo` varchar(200) DEFAULT NULL,
  `right_logo` varchar(200) DEFAULT NULL,
  `exam_name` varchar(200) DEFAULT NULL,
  `school_name` varchar(200) DEFAULT NULL,
  `exam_center` varchar(200) DEFAULT NULL,
  `sign` varchar(200) DEFAULT NULL,
  `background_img` varchar(200) DEFAULT NULL,
  `is_name` int NOT NULL DEFAULT '1',
  `is_father_name` int NOT NULL DEFAULT '1',
  `is_mother_name` int NOT NULL DEFAULT '1',
  `is_dob` int NOT NULL DEFAULT '1',
  `is_admission_no` int NOT NULL DEFAULT '1',
  `is_roll_no` int NOT NULL DEFAULT '1',
  `is_address` int NOT NULL DEFAULT '1',
  `is_gender` int NOT NULL DEFAULT '1',
  `is_photo` int NOT NULL,
  `is_class` int NOT NULL DEFAULT '0',
  `is_section` int NOT NULL DEFAULT '0',
  `is_active` int DEFAULT '0',
  `content_footer` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `template_admitcards`
--

LOCK TABLES `template_admitcards` WRITE;
/*!40000 ALTER TABLE `template_admitcards` DISABLE KEYS */;
INSERT INTO `template_admitcards` VALUES (1,'Sample Admit Card','','','','','Test','Mount Carmel School','test dmit card2','','',0,0,0,0,0,0,0,0,0,0,0,0,NULL,'2020-02-28 14:26:15','2020-02-28 14:26:15');
/*!40000 ALTER TABLE `template_admitcards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `template_marksheets`
--

DROP TABLE IF EXISTS `template_marksheets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `template_marksheets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `header_image` varchar(200) DEFAULT NULL,
  `template` varchar(200) DEFAULT NULL,
  `heading` text,
  `title` text,
  `left_logo` varchar(200) DEFAULT NULL,
  `right_logo` varchar(200) DEFAULT NULL,
  `exam_name` varchar(200) DEFAULT NULL,
  `school_name` varchar(200) DEFAULT NULL,
  `exam_center` varchar(200) DEFAULT NULL,
  `left_sign` varchar(200) DEFAULT NULL,
  `middle_sign` varchar(200) DEFAULT NULL,
  `right_sign` varchar(200) DEFAULT NULL,
  `exam_session` int DEFAULT '1',
  `is_name` int DEFAULT '1',
  `is_father_name` int DEFAULT '1',
  `is_mother_name` int DEFAULT '1',
  `is_dob` int DEFAULT '1',
  `is_admission_no` int DEFAULT '1',
  `is_roll_no` int DEFAULT '1',
  `is_photo` int DEFAULT '1',
  `is_division` int NOT NULL DEFAULT '1',
  `is_rank` int NOT NULL DEFAULT '0',
  `is_customfield` int NOT NULL,
  `background_img` varchar(200) DEFAULT NULL,
  `date` varchar(20) DEFAULT NULL,
  `is_class` int NOT NULL DEFAULT '0',
  `is_teacher_remark` int NOT NULL DEFAULT '1',
  `is_section` int NOT NULL DEFAULT '0',
  `content` text,
  `content_footer` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `template_marksheets`
--

LOCK TABLES `template_marksheets` WRITE;
/*!40000 ALTER TABLE `template_marksheets` DISABLE KEYS */;
INSERT INTO `template_marksheets` VALUES (1,NULL,'Sample Marksheet','BOARD OF SECONDARY EDUCATION, MADHYA PRADESH, BHOPAL','BOARD OF SECONDARY EDUCATION, MADHYA PRADESH, BHOPAL','','','HIGHER SECONDARY SCHOOL CERTIFICATE EXAMINATION','Mount Carmel School','GOVT GIRLS H S SCHOOL','','','',1,1,1,1,1,1,1,1,1,0,1,'',NULL,0,1,0,NULL,NULL,'2020-02-28 14:26:06','2020-02-28 14:26:06');
/*!40000 ALTER TABLE `template_marksheets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `topic` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `lesson_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` int NOT NULL,
  `complete_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  KEY `lesson_id` (`lesson_id`),
  CONSTRAINT `topic_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `topic_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transport_feemaster`
--

DROP TABLE IF EXISTS `transport_feemaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transport_feemaster` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` int NOT NULL,
  `month` varchar(50) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `fine_amount` float(10,2) DEFAULT '0.00',
  `fine_type` varchar(50) DEFAULT NULL,
  `fine_percentage` float(10,2) DEFAULT '0.00',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `session_id` (`session_id`),
  CONSTRAINT `transport_feemaster_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transport_feemaster`
--

LOCK TABLES `transport_feemaster` WRITE;
/*!40000 ALTER TABLE `transport_feemaster` DISABLE KEYS */;
/*!40000 ALTER TABLE `transport_feemaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transport_route`
--

DROP TABLE IF EXISTS `transport_route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transport_route` (
  `id` int NOT NULL AUTO_INCREMENT,
  `route_title` varchar(100) DEFAULT NULL,
  `no_of_vehicle` int DEFAULT NULL,
  `note` text,
  `is_active` varchar(255) DEFAULT 'no',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transport_route`
--

LOCK TABLES `transport_route` WRITE;
/*!40000 ALTER TABLE `transport_route` DISABLE KEYS */;
/*!40000 ALTER TABLE `transport_route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvet_assessment_schedule`
--

DROP TABLE IF EXISTS `tvet_assessment_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvet_assessment_schedule` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `assessment_id` int unsigned NOT NULL,
  `scheduled_date` date NOT NULL,
  `start_time` time NOT NULL,
  `duration_minutes` int NOT NULL,
  `venue` varchar(200) DEFAULT NULL,
  `invigilator_id` int DEFAULT NULL COMMENT 'FK to staff table',
  `instructions` text,
  `status` enum('Scheduled','In Progress','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_schedule_assessment` (`assessment_id`),
  CONSTRAINT `fk_schedule_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `tvet_assessment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvet_assessment_schedule`
--

LOCK TABLES `tvet_assessment_schedule` WRITE;
/*!40000 ALTER TABLE `tvet_assessment_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `tvet_assessment_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvet_cohort`
--

DROP TABLE IF EXISTS `tvet_cohort`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvet_cohort` (
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
  KEY `idx_cohort_level` (`level_id`),
  CONSTRAINT `fk_cohort_level` FOREIGN KEY (`level_id`) REFERENCES `tvet_level` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvet_cohort`
--

LOCK TABLES `tvet_cohort` WRITE;
/*!40000 ALTER TABLE `tvet_cohort` DISABLE KEYS */;
INSERT INTO `tvet_cohort` VALUES (1,1,'BM-N4-A-2026','Business Management N4 Group A',2026,'Full-time','2026-02-01','2026-11-30',40,1,'2026-01-29 12:15:00'),(2,1,'BM-N4-B-2026','Business Management N4 Group B',2026,'Evening','2026-02-01','2026-11-30',35,1,'2026-01-29 12:15:00');
/*!40000 ALTER TABLE `tvet_cohort` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvet_icass_config`
--

DROP TABLE IF EXISTS `tvet_icass_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvet_icass_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `level_module_id` int unsigned NOT NULL COMMENT 'Which module this config applies to',
  `component_name` varchar(100) NOT NULL COMMENT 'e.g., Tests, Assignments, Practical',
  `component_type` enum('Test','Assignment','Project','Practical','Exam','POE','Other') NOT NULL,
  `weight_percentage` decimal(5,2) NOT NULL DEFAULT '0.00' COMMENT 'Weight in ICASS calculation',
  `min_assessments` tinyint DEFAULT '1' COMMENT 'Minimum number of this type required',
  `pass_percentage` decimal(5,2) DEFAULT '40.00' COMMENT 'Minimum pass percentage',
  `is_compulsory` tinyint(1) DEFAULT '1',
  `sequence_order` tinyint DEFAULT '1',
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_level_module` (`level_module_id`),
  CONSTRAINT `fk_icass_level_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvet_icass_config`
--

LOCK TABLES `tvet_icass_config` WRITE;
/*!40000 ALTER TABLE `tvet_icass_config` DISABLE KEYS */;
/*!40000 ALTER TABLE `tvet_icass_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvet_lecturer_allocation`
--

DROP TABLE IF EXISTS `tvet_lecturer_allocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvet_lecturer_allocation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `staff_id` int NOT NULL COMMENT 'FK to staff table',
  `cohort_id` int unsigned NOT NULL,
  `level_module_id` int unsigned NOT NULL,
  `academic_year` year NOT NULL,
  `semester` enum('1','2','Year') NOT NULL DEFAULT 'Year',
  `is_primary` tinyint(1) NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_allocation_staff` (`staff_id`),
  KEY `idx_allocation_cohort` (`cohort_id`),
  KEY `idx_allocation_module` (`level_module_id`),
  CONSTRAINT `fk_allocation_cohort` FOREIGN KEY (`cohort_id`) REFERENCES `tvet_cohort` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_allocation_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvet_lecturer_allocation`
--

LOCK TABLES `tvet_lecturer_allocation` WRITE;
/*!40000 ALTER TABLE `tvet_lecturer_allocation` DISABLE KEYS */;
/*!40000 ALTER TABLE `tvet_lecturer_allocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvet_level`
--

DROP TABLE IF EXISTS `tvet_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvet_level` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `qualification_id` int unsigned NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `sequence` int NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_level_qualification` (`qualification_id`),
  CONSTRAINT `fk_level_qualification` FOREIGN KEY (`qualification_id`) REFERENCES `tvet_qualification` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvet_level`
--

LOCK TABLES `tvet_level` WRITE;
/*!40000 ALTER TABLE `tvet_level` DISABLE KEYS */;
INSERT INTO `tvet_level` VALUES (1,1,'N4','N4',1,1,'2026-01-29 12:15:00'),(2,1,'N5','N5',2,1,'2026-01-29 12:15:00'),(3,1,'N6','N6',3,1,'2026-01-29 12:15:00');
/*!40000 ALTER TABLE `tvet_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvet_level_module`
--

DROP TABLE IF EXISTS `tvet_level_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvet_level_module` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `level_id` int unsigned NOT NULL,
  `subject_id` int NOT NULL COMMENT 'FK to subjects table',
  `module_code` varchar(50) NOT NULL,
  `module_name` varchar(200) NOT NULL,
  `credits` int NOT NULL DEFAULT '0',
  `semester` enum('1','2','Year') NOT NULL DEFAULT 'Year',
  `is_core` tinyint(1) NOT NULL DEFAULT '1',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_level_subject` (`level_id`,`subject_id`),
  KEY `idx_module_level` (`level_id`),
  KEY `idx_module_subject` (`subject_id`),
  CONSTRAINT `fk_module_level` FOREIGN KEY (`level_id`) REFERENCES `tvet_level` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvet_level_module`
--

LOCK TABLES `tvet_level_module` WRITE;
/*!40000 ALTER TABLE `tvet_level_module` DISABLE KEYS */;
/*!40000 ALTER TABLE `tvet_level_module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvet_moderation_log`
--

DROP TABLE IF EXISTS `tvet_moderation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvet_moderation_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `assessment_id` int unsigned NOT NULL,
  `moderator_id` int NOT NULL COMMENT 'Staff ID of moderator',
  `action` enum('Submitted','Under Review','Approved','Rejected','Revised') NOT NULL,
  `comments` text,
  `previous_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_assessment` (`assessment_id`),
  KEY `idx_moderator` (`moderator_id`),
  CONSTRAINT `fk_moderation_assessment` FOREIGN KEY (`assessment_id`) REFERENCES `tvet_assessment` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvet_moderation_log`
--

LOCK TABLES `tvet_moderation_log` WRITE;
/*!40000 ALTER TABLE `tvet_moderation_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `tvet_moderation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvet_poe_item`
--

DROP TABLE IF EXISTS `tvet_poe_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvet_poe_item` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `student_enrolment_id` int unsigned NOT NULL,
  `level_module_id` int unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `item_type` enum('Assignment','Project','Practical','Test','Reflection','Other') NOT NULL,
  `description` text,
  `file_path` varchar(500) DEFAULT NULL,
  `submitted_date` date NOT NULL,
  `verification_status` enum('Pending','Verified','Rejected') DEFAULT 'Pending',
  `verified_by` int DEFAULT NULL,
  `verification_date` date DEFAULT NULL,
  `verification_comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_enrolment` (`student_enrolment_id`),
  KEY `idx_module` (`level_module_id`),
  KEY `idx_status` (`verification_status`),
  CONSTRAINT `fk_poe_enrolment` FOREIGN KEY (`student_enrolment_id`) REFERENCES `tvet_student_enrolment` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_poe_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvet_poe_item`
--

LOCK TABLES `tvet_poe_item` WRITE;
/*!40000 ALTER TABLE `tvet_poe_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `tvet_poe_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvet_qualification_requirement`
--

DROP TABLE IF EXISTS `tvet_qualification_requirement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvet_qualification_requirement` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `qualification_id` int unsigned NOT NULL,
  `level_module_id` int unsigned NOT NULL COMMENT 'Which module is required',
  `is_compulsory` tinyint(1) DEFAULT '1' COMMENT '1 = Core/Compulsory, 0 = Elective',
  `elective_group` varchar(50) DEFAULT NULL COMMENT 'Group name for elective modules',
  `min_electives_from_group` tinyint DEFAULT NULL COMMENT 'How many electives needed from this group',
  `credit_value` tinyint unsigned DEFAULT '0',
  `prerequisite_module_id` int unsigned DEFAULT NULL COMMENT 'Must pass this module first',
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_qual_module` (`qualification_id`,`level_module_id`),
  KEY `idx_qualification` (`qualification_id`),
  KEY `idx_module` (`level_module_id`),
  CONSTRAINT `fk_qualreq_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_qualreq_qualification` FOREIGN KEY (`qualification_id`) REFERENCES `tvet_qualification` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvet_qualification_requirement`
--

LOCK TABLES `tvet_qualification_requirement` WRITE;
/*!40000 ALTER TABLE `tvet_qualification_requirement` DISABLE KEYS */;
/*!40000 ALTER TABLE `tvet_qualification_requirement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tvet_timetable`
--

DROP TABLE IF EXISTS `tvet_timetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tvet_timetable` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `cohort_id` int unsigned NOT NULL,
  `level_module_id` int unsigned NOT NULL,
  `staff_id` int NOT NULL COMMENT 'Lecturer',
  `day_of_week` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `venue` varchar(200) DEFAULT NULL,
  `academic_year` year NOT NULL,
  `semester` enum('1','2','Year') NOT NULL DEFAULT 'Year',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_timetable_cohort` (`cohort_id`),
  KEY `idx_timetable_module` (`level_module_id`),
  KEY `idx_timetable_staff` (`staff_id`),
  CONSTRAINT `fk_timetable_cohort` FOREIGN KEY (`cohort_id`) REFERENCES `tvet_cohort` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_timetable_module` FOREIGN KEY (`level_module_id`) REFERENCES `tvet_level_module` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tvet_timetable`
--

LOCK TABLES `tvet_timetable` WRITE;
/*!40000 ALTER TABLE `tvet_timetable` DISABLE KEYS */;
/*!40000 ALTER TABLE `tvet_timetable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `upload_contents`
--

DROP TABLE IF EXISTS `upload_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `upload_contents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content_type_id` int NOT NULL,
  `subject_id` int DEFAULT NULL,
  `image` varchar(300) DEFAULT NULL,
  `thumb_path` varchar(300) DEFAULT NULL,
  `dir_path` varchar(300) DEFAULT NULL,
  `real_name` text NOT NULL,
  `img_name` varchar(300) DEFAULT NULL,
  `thumb_name` varchar(300) DEFAULT NULL,
  `file_type` varchar(100) NOT NULL,
  `mime_type` text NOT NULL,
  `file_size` varchar(100) NOT NULL,
  `vid_url` text NOT NULL,
  `vid_title` varchar(250) NOT NULL,
  `upload_by` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `upload_by` (`upload_by`),
  KEY `upload_contents_ibfk_2` (`content_type_id`),
  KEY `idx_file_type` (`file_type`),
  KEY `idx_subject_id` (`subject_id`),
  CONSTRAINT `upload_contents_ibfk_1` FOREIGN KEY (`upload_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `upload_contents_ibfk_2` FOREIGN KEY (`content_type_id`) REFERENCES `content_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `upload_contents`
--

LOCK TABLES `upload_contents` WRITE;
/*!40000 ALTER TABLE `upload_contents` DISABLE KEYS */;
INSERT INTO `upload_contents` VALUES (1,3,3,NULL,'uploads/school_content/material/media/thumb/','uploads/school_content/material/media/','01 Overview and logistics.pdf','1769689022-2091519869697b4fbe4367b!01 Overview and logistics.pdf','','pdf','application/pdf','113832','','',1,'2026-01-29 12:17:02','2026-01-29 12:17:02'),(2,2,3,NULL,'uploads/school_content/material/media/thumb/','uploads/school_content/material/media/','logs.zip','1769690817-638216248697b56c188a45!logs.zip','','zip','application/zip','5928','','',1,'2026-01-29 12:46:57','2026-01-29 12:46:57'),(3,1,1,NULL,'uploads/school_content/material/media/thumb/','uploads/school_content/material/media/','Anupa-testimonial.mp4','1769930420-614135399697efeb45ea4a!Anupa-testimonial.mp4','','mp4','video/mp4','12259217','','',1,'2026-02-01 07:20:20','2026-02-01 07:20:20');
/*!40000 ALTER TABLE `upload_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userlog`
--

DROP TABLE IF EXISTS `userlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userlog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user` varchar(100) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  `class_section_id` int DEFAULT NULL,
  `ipaddress` varchar(100) DEFAULT NULL,
  `user_agent` varchar(500) DEFAULT NULL,
  `login_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `class_section_id` (`class_section_id`),
  CONSTRAINT `userlog_ibfk_1` FOREIGN KEY (`class_section_id`) REFERENCES `class_sections` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userlog`
--

LOCK TABLES `userlog` WRITE;
/*!40000 ALTER TABLE `userlog` DISABLE KEYS */;
INSERT INTO `userlog` VALUES (1,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 12:16:12'),(2,'std1','student',1,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 12:19:15'),(3,'std1','student',1,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 12:25:35'),(4,'std2','student',1,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 14:49:33'),(5,'std1','student',1,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 14:50:13'),(6,'std2','student',1,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 14:56:12'),(7,'teacher@test.com','Teacher',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 17:09:35'),(8,'teacher@test.com','Teacher',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 17:16:48'),(9,'moderator@test.com','Exam Moderator',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 17:27:47'),(10,'teacher@test.com','Teacher',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 17:30:42'),(11,'moderator@test.com','Exam Moderator',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 17:33:39'),(12,'teacher@test.com','Teacher',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 17:42:10'),(13,'teacher@test.com','Teacher',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 17:54:17'),(14,'moderator@test.com','Exam Moderator',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 18:02:39'),(15,'teacher@test.com','Teacher',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-29 18:03:27'),(16,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-30 15:05:56'),(17,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-01-31 14:03:36'),(18,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-02-01 07:18:04'),(19,'std1','student',1,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-02-01 07:21:42'),(20,'moderator@test.com','Exam Moderator',NULL,'192.168.65.1','Chrome 144.0.0.0, Mac OS X','2026-02-01 07:29:54'),(21,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-02-03 04:14:51'),(22,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 143.0.0.0, Mac OS X','2026-02-03 15:03:24'),(23,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:35:32'),(24,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:03'),(25,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:04'),(26,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:05'),(27,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:06'),(28,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:06'),(29,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:06'),(30,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:11'),(31,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:14'),(32,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:16'),(33,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:19'),(34,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:22'),(35,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:24'),(36,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:37:25'),(37,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:47:50'),(38,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:47:51'),(39,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:47:52'),(40,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:47:53'),(41,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:47:53'),(42,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:47:53'),(43,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:48:01'),(44,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:48:02'),(45,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:48:02'),(46,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:48:03'),(47,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:48:09'),(48,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:48:09'),(49,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:48:12'),(50,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:52:43'),(51,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:52:46'),(52,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:52:46'),(53,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:52:48'),(54,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:52:48'),(55,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:52:48'),(56,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:52:54'),(57,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:52:57'),(58,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:52:57'),(59,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:02'),(60,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:02'),(61,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:04'),(62,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:06'),(63,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:23'),(64,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:23'),(65,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:26'),(66,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:27'),(67,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:28'),(68,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:29'),(69,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:32'),(70,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:36'),(71,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:36'),(72,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:39'),(73,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:42'),(74,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:43'),(75,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:53:43'),(76,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:12'),(77,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:14'),(78,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:15'),(79,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:16'),(80,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:16'),(81,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:16'),(82,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:21'),(83,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:22'),(84,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:23'),(85,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:29'),(86,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:30'),(87,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:31'),(88,'admin@admin.com','Super Admin',NULL,'192.168.65.1','Chrome 145.0.7632.6, Windows 10','2026-02-04 02:54:34');
/*!40000 ALTER TABLE `userlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'std1','Student@123','','student',0,0,'','yes','2026-01-29 12:15:00','2026-01-29 12:15:00'),(2,2,'std2','Student@123','','student',0,0,'','yes','2026-01-29 12:15:00','2026-01-29 12:15:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_authentication`
--

DROP TABLE IF EXISTS `users_authentication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users_authentication` (
  `id` int NOT NULL AUTO_INCREMENT,
  `users_id` int NOT NULL,
  `token` varchar(255) NOT NULL,
  `staff_id` int DEFAULT NULL,
  `expired_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_authentication`
--

LOCK TABLES `users_authentication` WRITE;
/*!40000 ALTER TABLE `users_authentication` DISABLE KEYS */;
/*!40000 ALTER TABLE `users_authentication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicle_routes`
--

DROP TABLE IF EXISTS `vehicle_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle_routes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `route_id` int DEFAULT NULL,
  `vehicle_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `route_id` (`route_id`),
  KEY `vehicle_id` (`vehicle_id`),
  CONSTRAINT `vehicle_routes_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `transport_route` (`id`) ON DELETE CASCADE,
  CONSTRAINT `vehicle_routes_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle_routes`
--

LOCK TABLES `vehicle_routes` WRITE;
/*!40000 ALTER TABLE `vehicle_routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicle_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `vehicle_no` varchar(20) DEFAULT NULL,
  `vehicle_model` varchar(100) NOT NULL DEFAULT 'None',
  `vehicle_photo` varchar(255) DEFAULT NULL,
  `manufacture_year` varchar(4) DEFAULT NULL,
  `registration_number` varchar(50) NOT NULL,
  `chasis_number` varchar(100) NOT NULL,
  `max_seating_capacity` varchar(255) NOT NULL,
  `driver_name` varchar(50) DEFAULT NULL,
  `driver_licence` varchar(50) NOT NULL DEFAULT 'None',
  `driver_contact` varchar(20) DEFAULT NULL,
  `note` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_vehicle_no` (`vehicle_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video_tutorial`
--

DROP TABLE IF EXISTS `video_tutorial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `video_tutorial` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `vid_title` text,
  `description` text NOT NULL,
  `thumb_path` varchar(500) DEFAULT NULL,
  `dir_path` varchar(500) DEFAULT NULL,
  `img_name` varchar(300) NOT NULL,
  `thumb_name` varchar(300) NOT NULL,
  `video_link` varchar(100) NOT NULL,
  `created_by` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  KEY `idx_title` (`title`),
  CONSTRAINT `video_tutorial_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video_tutorial`
--

LOCK TABLES `video_tutorial` WRITE;
/*!40000 ALTER TABLE `video_tutorial` DISABLE KEYS */;
/*!40000 ALTER TABLE `video_tutorial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video_tutorial_class_sections`
--

DROP TABLE IF EXISTS `video_tutorial_class_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `video_tutorial_class_sections` (
  `id` int NOT NULL AUTO_INCREMENT,
  `video_tutorial_id` int NOT NULL,
  `class_section_id` int NOT NULL,
  `created_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `class_section_id` (`class_section_id`),
  KEY `video_tutorial_id` (`video_tutorial_id`),
  CONSTRAINT `video_tutorial_class_sections_ibfk_1` FOREIGN KEY (`class_section_id`) REFERENCES `class_sections` (`id`) ON DELETE CASCADE,
  CONSTRAINT `video_tutorial_class_sections_ibfk_2` FOREIGN KEY (`video_tutorial_id`) REFERENCES `video_tutorial` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video_tutorial_class_sections`
--

LOCK TABLES `video_tutorial_class_sections` WRITE;
/*!40000 ALTER TABLE `video_tutorial_class_sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `video_tutorial_class_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitors_book`
--

DROP TABLE IF EXISTS `visitors_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitors_book` (
  `id` int NOT NULL AUTO_INCREMENT,
  `staff_id` int DEFAULT NULL,
  `student_session_id` int DEFAULT NULL,
  `source` varchar(100) DEFAULT NULL,
  `purpose` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `contact` varchar(12) NOT NULL,
  `id_proof` varchar(50) NOT NULL,
  `no_of_people` int NOT NULL,
  `date` date NOT NULL,
  `in_time` varchar(20) NOT NULL,
  `out_time` varchar(20) NOT NULL,
  `note` text NOT NULL,
  `image` varchar(100) DEFAULT NULL,
  `meeting_with` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `staff_id` (`staff_id`),
  KEY `student_session_id` (`student_session_id`),
  CONSTRAINT `visitors_book_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  CONSTRAINT `visitors_book_ibfk_2` FOREIGN KEY (`student_session_id`) REFERENCES `student_session` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitors_book`
--

LOCK TABLES `visitors_book` WRITE;
/*!40000 ALTER TABLE `visitors_book` DISABLE KEYS */;
/*!40000 ALTER TABLE `visitors_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visitors_purpose`
--

DROP TABLE IF EXISTS `visitors_purpose`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visitors_purpose` (
  `id` int NOT NULL AUTO_INCREMENT,
  `visitors_purpose` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitors_purpose`
--

LOCK TABLES `visitors_purpose` WRITE;
/*!40000 ALTER TABLE `visitors_purpose` DISABLE KEYS */;
/*!40000 ALTER TABLE `visitors_purpose` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zoom_settings`
--

DROP TABLE IF EXISTS `zoom_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zoom_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `zoom_api_key` varchar(200) DEFAULT NULL,
  `zoom_api_secret` varchar(200) DEFAULT NULL,
  `use_teacher_api` int DEFAULT '0',
  `use_zoom_app` int DEFAULT '1',
  `use_zoom_app_user` int DEFAULT '1',
  `parent_live_class` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `teams_tenant_id` varchar(255) DEFAULT NULL,
  `teams_client_id` varchar(255) DEFAULT NULL,
  `teams_client_secret` varchar(255) DEFAULT NULL,
  `teams_organizer_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zoom_settings`
--

LOCK TABLES `zoom_settings` WRITE;
/*!40000 ALTER TABLE `zoom_settings` DISABLE KEYS */;
INSERT INTO `zoom_settings` VALUES (1,NULL,NULL,0,1,1,0,'2026-01-29 12:15:00',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `zoom_settings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-04  2:58:57
