-- Migration: Add TVET Bulk Import Submenu
-- This migration adds a Bulk Import menu item under Academic Management

-- First, find the Academic Management sidebar menu ID
SET @academic_menu_id = (SELECT id FROM sidebar_menus WHERE short_code = 'academic_management' OR lang_key = 'academic_management' LIMIT 1);

-- If Academic Management menu exists, add the Bulk Import submenu
-- Note: Run this only if you have the Academic Management menu already created

-- Insert Bulk Import submenu if menu exists
INSERT INTO sidebar_sub_menus (
    sidebar_menu_id,
    name,
    lang_key,
    icon,
    url,
    access_permissions,
    short_code,
    activate_controller,
    activate_methods,
    sort_order,
    is_active,
    addon_permission
)
SELECT
    @academic_menu_id,
    'Bulk Import',
    'bulk_import',
    'fa fa-upload',
    'admin/academic/import',
    'academic_programmes,can_add',
    'tvet_bulk_import',
    'academic',
    'import,import_programmes,import_subjects,import_levels,import_subject_levels,import_classes,import_enrolments',
    100,
    1,
    ''
WHERE @academic_menu_id IS NOT NULL
AND NOT EXISTS (
    SELECT 1 FROM sidebar_sub_menus
    WHERE sidebar_menu_id = @academic_menu_id
    AND short_code = 'tvet_bulk_import'
);

-- Add language key for bulk import
INSERT INTO language (lang_key, is_rtl, created_at) VALUES ('bulk_import', 0, NOW())
ON DUPLICATE KEY UPDATE lang_key = 'bulk_import';
