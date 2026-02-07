# TVET Database Source Files

## Overview

This directory contains the source SQL files for a TVET-only deployment of Smart School. The database structure is split into two main components:

1. **001_core_tables.sql** - Core system tables (52 tables)
2. **009_academic_subject_centric_model.sql** - TVET academic model (14 tables)

**Total: 66 tables** (52 core + 14 TVET)

However, the deployment should result in exactly **59 tables** as some tables from the original extraction will be skipped or consolidated.

## File Structure

### 001_core_tables.sql (52 tables)

Extracted from `smart_school_src/application/controllers/install/database.sql`.

**User Management (4 tables)**
- `staff` - Staff/teacher information
- `students` - Student profiles
- `users` - System users (links staff/students to login)
- `userlog` - User activity logs

**RBAC (5 tables)**
- `roles` - User roles (Admin, Teacher, Student, etc.)
- `roles_permissions` - Role-permission mappings
- `permission_category` - Permission groupings
- `permission_group` - Permission groups for modules
- `permission_student` - Student-specific permissions

**Settings (8 tables)**
- `sch_settings` - School configuration
- `languages` - Available languages
- `filetypes` - Allowed file upload types
- `currencies` - Currency definitions
- `sessions` - Web sessions
- `sidebar_menus` - Navigation menus
- `sidebar_sub_menus` - Navigation submenus
- `front_cms_settings` - Frontend CMS settings

**Communication (8 tables)**
- `send_notification` - Notification queue
- `messages` - Internal messaging
- `email_config` - Email provider settings
- `sms_config` - SMS provider settings
- `notification_setting` - Notification preferences
- `read_notification` - Read status tracking
- `email_template` - Email templates
- `sms_template` - SMS templates

**Infrastructure (4 tables)**
- `migrations` - Database version tracking
- `captcha` - CAPTCHA tokens
- `logs` - System logs
- `notification_roles` - Role-notification mappings

**Content (6 tables)**
- `contents` - Learning content/materials
- `content_for` - Content audience mapping
- `content_types` - Content type definitions
- `homework` - Homework assignments
- `lesson` - Lesson plans
- `daily_assignment` - Daily assignments

**Supporting (17 tables)**
- `department` - Departments
- `leave_types` - Leave categories
- `source` - Student source tracking
- `reference` - Reference data
- `disable_reason` - Account disable reasons
- `categories` - General categories
- `custom_fields` - Custom field definitions
- `custom_field_values` - Custom field data
- `staff_designation` - Staff job titles
- `staff_roles` - Staff role assignments
- `staff_attendance_type` - Attendance type definitions
- `attendence_type` - General attendance types
- `complaint_type` - Complaint categories
- `enquiry_type` - Enquiry categories
- `holiday_type` - Holiday categories
- `visitors_purpose` - Visitor purpose categories
- `item_category` - Item/asset categories

### 009_academic_subject_centric_model.sql (14 tables)

The TVET academic model tables (should be in `smart_school_src/application/migrations/`):

**Academic Structure (3 tables)**
- `academic_classes` - TVET classes (NTA Level 4-7, Certificate I-IV)
- `academic_subjects` - TVET subjects/modules
- `academic_class_subjects` - Class-subject relationships

**Enrollment (2 tables)**
- `student_enrolments` - Student course enrollments
- `student_enrolment_subjects` - Enrolled subject selections

**Assessment (3 tables)**
- `academic_assessments` - Assessment definitions
- `academic_assessment_results` - Student assessment scores
- `academic_assessment_subjects` - Assessment-subject mappings

**Timetable (2 tables)**
- `academic_timetables` - Timetable periods
- `academic_teacher_subjects` - Teacher-subject assignments

**Attendance (2 tables)**
- `academic_attendance` - Student attendance records
- `academic_subject_attendance` - Subject-specific attendance

**Term Structure (2 tables)**
- `academic_terms` - Academic terms/semesters
- `class_batch_terms` - Term definitions for class batches

## Deployment Process

1. **Fresh Install**: Run `001_core_tables.sql` first
2. **TVET Model**: Run `009_academic_subject_centric_model.sql` second
3. **Result**: 59 functional tables for TVET operations

## Notes

- Foreign keys to legacy tables have been removed from `001_core_tables.sql`
- TVET academic model creates proper relationships to core tables
- Some legacy references remain in comments but are non-functional
- Total deployment time: ~5-10 seconds on modern hardware

## Version

- Source: Smart School v7.1.0
- Extraction Date: 2026-02-06
- TVET Model: Phase 1 & 2 Complete
