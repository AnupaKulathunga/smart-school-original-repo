-- ============================================================
-- Content Subject Classification & TVET Cohort Sharing - Database Migration
-- Smart School v7.1.0 → TVET Phase 1-2 Enhancements
-- Covers: Subject classification for content, Cohort sharing for TVET
-- Compatible with MySQL 5.5+
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- Add subject_id column to upload_contents table
-- Allows content to be classified by subject
-- ============================================================
DELIMITER //
DROP PROCEDURE IF EXISTS add_upload_contents_subject_id//
CREATE PROCEDURE add_upload_contents_subject_id()
BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'upload_contents'
        AND COLUMN_NAME = 'subject_id'
    ) THEN
        ALTER TABLE `upload_contents`
            ADD COLUMN `subject_id` INT(11) DEFAULT NULL AFTER `content_type_id`;
    END IF;
END//
DELIMITER ;
CALL add_upload_contents_subject_id();
DROP PROCEDURE IF EXISTS add_upload_contents_subject_id;

-- Add index for subject_id on upload_contents
DELIMITER //
DROP PROCEDURE IF EXISTS add_upload_contents_subject_id_index//
CREATE PROCEDURE add_upload_contents_subject_id_index()
BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'upload_contents'
        AND INDEX_NAME = 'idx_subject_id'
    ) THEN
        ALTER TABLE `upload_contents`
            ADD INDEX `idx_subject_id` (`subject_id`);
    END IF;
END//
DELIMITER ;
CALL add_upload_contents_subject_id_index();
DROP PROCEDURE IF EXISTS add_upload_contents_subject_id_index;

-- ============================================================
-- Add cohort_id column to share_content_for table
-- Allows content to be shared with TVET cohorts
-- ============================================================
DELIMITER //
DROP PROCEDURE IF EXISTS add_share_content_for_cohort_id//
CREATE PROCEDURE add_share_content_for_cohort_id()
BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'share_content_for'
        AND COLUMN_NAME = 'cohort_id'
    ) THEN
        ALTER TABLE `share_content_for`
            ADD COLUMN `cohort_id` INT(11) DEFAULT NULL AFTER `class_section_id`;
    END IF;
END//
DELIMITER ;
CALL add_share_content_for_cohort_id();
DROP PROCEDURE IF EXISTS add_share_content_for_cohort_id;

-- Add index for cohort_id on share_content_for
DELIMITER //
DROP PROCEDURE IF EXISTS add_share_content_for_cohort_id_index//
CREATE PROCEDURE add_share_content_for_cohort_id_index()
BEGIN
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'share_content_for'
        AND INDEX_NAME = 'idx_cohort_id'
    ) THEN
        ALTER TABLE `share_content_for`
            ADD INDEX `idx_cohort_id` (`cohort_id`);
    END IF;
END//
DELIMITER ;
CALL add_share_content_for_cohort_id_index();
DROP PROCEDURE IF EXISTS add_share_content_for_cohort_id_index;

SET FOREIGN_KEY_CHECKS = 1;
