-- ============================================================
-- Migration 005: Complete Exam Moderation Workflow
-- Smart School v7.1.0
-- Adds permission category, role permissions, and sidebar menu for exam moderation
-- Compatible with MySQL 5.5+
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 1. Permission category for exam_moderation
-- Uses ID 5030 (in 5000+ range for custom features)
-- ============================================================
INSERT INTO `permission_category` (`id`, `perm_group_id`, `name`, `short_code`, `enable_view`, `enable_add`, `enable_edit`, `enable_delete`, `created_at`)
SELECT 5030, 1, 'Exam Moderation', 'exam_moderation', 1, 0, 1, 0, NOW()
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `permission_category` WHERE `short_code` = 'exam_moderation');

-- ============================================================
-- 2. Grant exam_moderation permission to Super Admin (role_id = 7)
-- ============================================================
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 7, 5030, 1, 0, 1, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 7 AND `perm_cat_id` = 5030);

-- ============================================================
-- 3. Grant exam_moderation permission to Admin (role_id = 1)
-- ============================================================
INSERT INTO `roles_permissions` (`role_id`, `perm_cat_id`, `can_view`, `can_add`, `can_edit`, `can_delete`, `created_at`)
SELECT 1, 5030, 1, 0, 1, 0, NOW() FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `roles_permissions` WHERE `role_id` = 1 AND `perm_cat_id` = 5030);

-- ============================================================
-- 4. Sidebar sub-menu entry under Online Examinations
-- Find the sidebar_menu_id for Online Examinations and add moderation submenu
-- ============================================================

-- First, create a procedure to safely insert the sidebar menu
DELIMITER //
DROP PROCEDURE IF EXISTS add_exam_moderation_sidebar//
CREATE PROCEDURE add_exam_moderation_sidebar()
BEGIN
    DECLARE v_sidebar_menu_id INT;

    -- Find the sidebar_menu_id for Online Examinations
    SELECT sidebar_menu_id INTO v_sidebar_menu_id
    FROM `sidebar_sub_menus`
    WHERE activate_controller = 'onlineexam'
    AND menu = 'online_examination'
    LIMIT 1;

    -- If found and menu doesn't exist, insert
    IF v_sidebar_menu_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM `sidebar_sub_menus` WHERE `url` = 'admin/onlineexam/moderation') THEN
            INSERT INTO `sidebar_sub_menus` (
                `sidebar_menu_id`, `menu`, `key`, `lang_key`, `url`,
                `level`, `access_permissions`, `permission_group_id`,
                `activate_controller`, `activate_methods`, `addon_permission`,
                `is_active`, `created_at`
            ) VALUES (
                v_sidebar_menu_id, 'exam_moderation', NULL, 'exam_moderation', 'admin/onlineexam/moderation',
                15, '(''exam_moderation'', ''can_view'')', NULL,
                'onlineexam', 'moderation,moderation_review', '',
                1, NOW()
            );
        END IF;
    END IF;
END//
DELIMITER ;

CALL add_exam_moderation_sidebar();
DROP PROCEDURE IF EXISTS add_exam_moderation_sidebar;

SET FOREIGN_KEY_CHECKS = 1;
