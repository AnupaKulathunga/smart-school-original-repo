-- Migration 033: Hide Subject Group and Subjects sidebar menu items
-- TVET: Subject groups and subjects are auto-derived from class, no need for manual management

UPDATE sidebar_sub_menus SET is_active = 0 WHERE lang_key = 'subject_group';
UPDATE sidebar_sub_menus SET is_active = 0 WHERE lang_key = 'subjects';
