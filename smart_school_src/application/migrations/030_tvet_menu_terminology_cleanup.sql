-- Migration 030: TVET Menu & Terminology Cleanup
-- Tier 5 of TVET conversion
--
-- 1. Hide "Sections" menu item (no longer needed in TVET model)
-- 2. Move "Disability Types" from Communicate to Student Information
-- 3. Rename "Homework" parent menu label to "Assignments" in DB

-- 5.1: Hide Sections submenu (id=58 under Academics)
-- In TVET model, sections are eliminated; academic_class_id replaces class_id+section_id
UPDATE sidebar_sub_menus SET is_active = 0 WHERE id = 58 AND menu = 'sections';

-- 5.3: Move Disability Types management from Communicate (sidebar_menu_id=16) to Student Information (sidebar_menu_id=2)
-- This groups it logically with "Students with Disabilities" (id=221)
UPDATE sidebar_sub_menus SET sidebar_menu_id = 2 WHERE id = 220 AND menu = 'disability_types';

-- 5.4: Update the parent menu label for Homework to "Assignments"
-- (The lang_key 'homework' already maps to "Assignments" in English, but the DB menu name should match)
UPDATE sidebar_menus SET menu = 'Assignments' WHERE id = 18 AND menu = 'Homework';

-- Update sub-menu labels for homework items to use assignment terminology
UPDATE sidebar_sub_menus SET menu = 'add_assignment' WHERE id = 92 AND menu = 'add_homework';
UPDATE sidebar_sub_menus SET menu = 'daily_assignment' WHERE id = 93 AND menu = 'daily_assignment';

-- Update Reports > homework sub-menu entry label
UPDATE sidebar_sub_menus SET menu = 'assignment_report' WHERE id = 144 AND menu = 'homework';
