# TVET Implementation Plan for Smart School LMS (Northlink College)

## Overview
This plan describes the phased implementation of TVET (Technical and Vocational Education Training) features for the Smart School LMS, transforming it from a high school model (Class/Section) to a TVET college model (Programme/Qualification/Level/Cohort).

---

## Phase 1: TVET Core Data Model & Admin CRUD

### 1. Database Changes
- Add 9 new TVET tables:
  - tvet_programme
  - tvet_qualification
  - tvet_level
  - tvet_cohort
  - tvet_level_module
  - tvet_student_enrolment
  - tvet_lecturer_allocation
  - tvet_assessment
  - tvet_assessment_schedule
- Add `institution_type` column to `sch_settings` (ENUM: SCHOOL, TVET)

### 2. Models
- Create models for:
  - Programme
  - Qualification
  - Level
  - Cohort
  - Level Module
  - Lecturer Allocation

### 3. Admin Controller
- Create `Tvet.php` admin controller with CRUD for all TVET entities
- AJAX endpoints for cascade dropdowns (Programme → Qualification → Level → Cohort)

### 4. Views
- Create 19 admin views for:
  - Dashboard
  - CRUD for all TVET entities

### 5. Language
- Add `tvet_lang.php` with all TVET language keys
- Add sidebar keys to `system_lang.php`

### 6. Menu & Permissions
- Add TVET menu to sidebar (database-driven)
- Add permission group, categories, and assign to Super Admin/Admin

---

## Phase 2: TVET Student & Lecturer Management

### 1. Student Enrolment
- CRUD for TVET student enrolment (link students to cohorts)
- Bulk import/export for enrolments

### 2. Lecturer Allocation
- CRUD for lecturer allocation to cohort/module
- Bulk import/export for allocations

### 3. Assessment Management
- CRUD for TVET assessments and schedules
- Bulk import/export for assessments

### 4. Reporting
- Basic reports for:
  - Enrolments by cohort/qualification
  - Lecturer allocations
  - Assessment schedules

---

## Phase 3: TVET Portal & Integration (Future)
- Student/lecturer self-service portal for TVET
- Integration with DHET/NSFAS APIs
- Advanced reporting and analytics
- TVET-specific attendance, marks, and progression logic

---

## Notes
- All TVET features are implemented as an extension layer (existing Smart School tables remain intact)
- Menu and permissions are fully dynamic and database-driven
- All code follows CodeIgniter 3 conventions and uses MY_Model base class

---

## Author
- Northlink College / Graham / Anupa
- Date: 2026-01-23
