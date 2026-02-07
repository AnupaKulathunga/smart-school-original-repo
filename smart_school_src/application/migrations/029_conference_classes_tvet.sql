-- Migration 029: Create conference_classes table for TVET model
-- Replaces legacy conference_sections table (which linked to class_sections)
-- conference_classes links conferences directly to academic_class

CREATE TABLE IF NOT EXISTS `conference_classes` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `conference_id` INT(11) DEFAULT NULL,
    `class_id` INT(11) DEFAULT NULL COMMENT 'References academic_class.id',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_conference_classes_conference_id` (`conference_id`),
    KEY `idx_conference_classes_class_id` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Migrate data from conference_sections to conference_classes if both legacy tables exist
-- This maps cls_section_id (class_sections.id) -> class_id (via class_sections.class_id)
-- Only runs if conference_sections exists and conference_classes is empty
-- Wrapped in procedure to handle case where conference_sections doesn't exist on fresh installs

DELIMITER //
DROP PROCEDURE IF EXISTS migrate_conference_sections_to_classes//
CREATE PROCEDURE migrate_conference_sections_to_classes()
BEGIN
    DECLARE tbl_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO tbl_exists
    FROM information_schema.tables
    WHERE table_schema = DATABASE()
      AND table_name = 'conference_sections';

    IF tbl_exists > 0 THEN
        INSERT INTO `conference_classes` (`conference_id`, `class_id`, `created_at`)
        SELECT cs.`conference_id`, cls.`class_id`, cs.`created_at`
        FROM `conference_sections` cs
        INNER JOIN `class_sections` cls ON cls.`id` = cs.`cls_section_id`
        WHERE NOT EXISTS (SELECT 1 FROM `conference_classes` LIMIT 1);
    END IF;
END//
DELIMITER ;

CALL migrate_conference_sections_to_classes();
DROP PROCEDURE IF EXISTS migrate_conference_sections_to_classes;
