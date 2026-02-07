# Database Extraction Report

**Date**: 2026-02-06
**Source**: `smart_school_src/application/controllers/install/database.sql`
**Output**: `database_source/001_core_tables.sql`

## Extraction Summary

### Tables Extracted: 52 Core Tables

The extraction successfully identified and extracted 52 core system tables from the original Smart School database (which contained 130+ tables including legacy school management tables).

### Breakdown by Category

| Category | Count | Tables |
|----------|-------|--------|
| User Management | 4 | staff, students, users, userlog |
| RBAC | 5 | roles, roles_permissions, permission_category, permission_group, permission_student |
| Settings | 8 | sch_settings, languages, filetypes, currencies, sessions, sidebar_menus, sidebar_sub_menus, front_cms_settings |
| Communication | 8 | send_notification, messages, email_config, sms_config, notification_setting, read_notification, email_template, sms_template |
| Infrastructure | 4 | migrations, captcha, logs, notification_roles |
| Content | 6 | contents, content_for, content_types, homework, lesson, daily_assignment |
| Supporting | 17 | department, leave_types, source, reference, disable_reason, categories, custom_fields, custom_field_values, staff_designation, staff_roles, staff_attendance_type, attendence_type, complaint_type, enquiry_type, holiday_type, visitors_purpose, item_category |
| **Total** | **52** | |

## Changes from Original Request

**Original Request**: 45 tables
**Actual Extraction**: 52 tables (+7 tables)

### Additional Tables Included (7 extra)

These 7 additional tables were included because they are essential dependencies:

1. **permission_group** - Required for RBAC module grouping
2. **permission_student** - Required for student-specific permissions
3. **sidebar_sub_menus** - Required for navigation submenu system
4. **front_cms_settings** - Required for frontend CMS configuration
5. **read_notification** - Required for notification read status tracking
6. **email_template** - Required for templated email system
7. **sms_template** - Required for templated SMS system

### Tables Not Found

1. **user_roles** - Does not exist in source database (functionality covered by `staff_roles` and `roles` tables)

## Modifications Made

### Foreign Key Cleanup

- Removed foreign key constraints that reference non-core tables
- Examples of removed references:
  - `class_sections` (legacy)
  - `student_session` (legacy)
  - `video_tutorial` (legacy)
  - `video_tutorial_class_sections` (legacy)
  - `visitors_book` (legacy)

### Structure Preservation

- All table structures preserved exactly as in source
- Column definitions unchanged
- Primary keys and indexes intact
- Auto-increment settings preserved
- Default values maintained
- Character sets and collations preserved (utf8mb3)

## File Statistics

- **Source File**: 8,643 lines, 360.7KB
- **Output File**: 5,762 lines, ~180KB
- **Reduction**: 33.3% of original size
- **Tables Retained**: 40% (52 of 130+ tables)

## Validation Checks

✅ 52 CREATE TABLE statements
✅ 52 ENGINE=InnoDB declarations
✅ All tables have primary keys
✅ No syntax errors detected
✅ SET FOREIGN_KEY_CHECKS properly handled
✅ SQL_MODE configuration included

## Next Steps

1. Combine with `009_academic_subject_centric_model.sql` (14 TVET tables)
2. Expected total: 59-66 tables for TVET-only deployment
3. Test fresh installation in clean database
4. Verify all foreign key relationships
5. Populate with seed data

## Notes

- This extraction is phase 1 of the TVET-only database consolidation
- The TVET academic model (14 tables) will establish proper foreign keys to these core tables
- All legacy school-specific tables (classes, sections, exams, fees, hostel, transport, library, etc.) have been excluded
- Content tables (contents, homework, lesson, daily_assignment) retain their structure but will be linked to TVET academic model via migration 009

## Excluded Table Categories

The following legacy table categories were excluded:
- Legacy class/section management (classes, sections, class_sections, class_teacher)
- Legacy student sessions (student_session, student_attendences)
- Legacy exam system (exams, exam_groups, exam_schedules, exam_results)
- Legacy subject groups (subject_groups, subject_group_subjects, teacher_subjects)
- Financial modules (fees*, income*, expenses*)
- Facility modules (hostel*, transport*, library*, vehicles*)
- Alumni management (alumni_students, alumni_events)
- Online admissions (online_admissions, online_admission_*)
- Online exams (onlineexam, onlineexam_*)
- Certificate generation (certificates, template_*)
- And 60+ other legacy tables

Total legacy tables excluded: 80+
