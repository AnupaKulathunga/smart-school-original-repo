# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Smart School is a comprehensive School Management System built with CodeIgniter 3 (PHP framework). Version 7.1.0.

**Framework**: CodeIgniter 3 (PHP)
**Database**: MySQL 8 (mysqli driver)
**Architecture**: MVC (Model-View-Controller)

## Development Commands

### Docker Development (Recommended)

```bash
# Start all services (web, db, phpmyadmin)
docker-compose up -d

# View logs
docker-compose logs -f web

# Stop services
docker-compose down

# Reset database (destroys all data)
docker-compose down -v && docker-compose up -d

# Execute PHP in container
docker-compose exec web php -v

# Access MySQL CLI
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school
```

**Access URLs:**
- Application: http://localhost:8080
- Admin panel: http://localhost:8080/admin
- phpMyAdmin: http://localhost:8081

**Default Admin Credentials:** admin / admin123

### Database Migrations

SQL migration files are in `smart_school_src/application/migrations/`. They are auto-loaded by Docker on first run via `docker-entrypoint-initdb.d/`. For manual application:

```bash
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school < smart_school_src/application/migrations/XXX_migration_name.sql
```

## Directory Structure

```
smart_school_src/
├── application/
│   ├── controllers/admin/   # Admin controllers (extend Admin_Controller)
│   ├── controllers/user/    # Student/parent portal (extend Student_Controller)
│   ├── models/              # Database models (auto-loaded in MY_Controller)
│   ├── views/admin/         # Admin panel views
│   ├── views/user/          # Student portal views
│   ├── core/MY_Controller.php  # Base controllers (MY_Controller, Admin_Controller, Student_Controller)
│   ├── libraries/           # Custom libraries (Auth, Rbac, Smsgateway, etc.)
│   ├── language/            # Multi-language support (80+ languages)
│   ├── migrations/          # SQL migration files
│   └── config/              # Configuration files
├── backend/                 # Frontend assets (CSS, JS, plugins)
└── uploads/                 # User uploaded files
```

## System Architecture

### Controller Hierarchy

Defined in `application/core/MY_Controller.php`:

- **MY_Controller** (extends CI_Controller): Base controller, auto-loads 150+ models and libraries, handles multi-language support
- **Admin_Controller** (extends MY_Controller): Admin panel controllers, handles auth via `$this->auth->is_logged_in()`, loads RBAC library
- **Student_Controller** (extends MY_Controller): Student/parent portal, includes maintenance mode check

All models are auto-loaded in MY_Controller, so use them directly: `$this->student_model->get()`

### Key Libraries

- **Auth**: Authentication and authorization
- **Rbac**: Role-based access control - use `$this->rbac->check_operation_access()` to verify permissions
- **Customlib**: Utility functions
- **Smsgateway**: SMS provider integrations
- **QDMailer**: Email handling

### Multi-Language

Language files: `application/language/[lang_code]/app_files/[module]_lang.php`

Usage: `$this->lang->line('key_name')`

## Configuration

- **Database**: `application/config/database.php` - Docker uses `smart_school` database
- **Environment**: `index.php` line 57 - set `ENVIRONMENT = 'development'` for debugging
- **Base URL**: `application/config/config.php`
- **Logs**: `application/logs/`

**Important**: MySQL SQL_MODE must not contain ONLY_FULL_GROUP_BY (handled in docker-compose.yml)

## Adding New Features

1. **Controller**: `application/controllers/admin/[Name].php` extending `Admin_Controller`
2. **Model**: `application/models/[Name]_model.php` - add to auto-load array in `MY_Controller` if used globally
3. **Views**: `application/views/admin/[module]/` - uses `layout/header.php` and `layout/footer.php`
4. **Permissions**: Use `$this->rbac->check_operation_access()` in controllers

## Development Best Practices

### Thorough Change Implementation

When fixing or modifying something, **always check ALL related places** where the same issue might exist:

1. **View Consistency**: If changing how data is displayed (e.g., list view), check detail/view pages, modals, print views, and export functions
2. **Role-Based Views**: Changes often need to be applied differently for admin vs user (student/parent) views:
   - Admin views: `application/views/admin/`
   - User views: `application/views/user/`
   - Consider what information is appropriate for each role
3. **Related Controllers**: If modifying a controller method, check related methods (list, view, edit, delete, ajax endpoints)
4. **Models**: If changing data structure, check all model methods that use that data

### Information Disclosure

- **Never expose internal IDs to end users**: Employee IDs, database IDs, and internal references should not be shown to students/parents
- **Admin vs Student data visibility**: Admin views can show more detail (employee IDs, internal codes), student views should only show what's necessary (names, dates, content)
- **Sensitive data patterns to watch**:
  - Employee IDs (e.g., `employee_id`)
  - Internal user IDs
  - System configuration values
  - Debug information

---

## TVET Architecture Rules

This codebase has been fully converted from a traditional school class+section model to a **TVET (Technical and Vocational Education and Training) subject-centric model**. Every change must follow these rules.

### Core Concept

**An academic class = Subject + Level + Cohort + Year** (e.g., "Mathematics - N4 - Cohort A - 2026")

There are NO sections. A single `academic_class_id` replaces the old `class_id + section_id` pair everywhere.

### Database Tables

#### TVET Tables (use these)
| Table | Purpose |
|-------|---------|
| `academic_class` | The central unit — one row per subject+level+cohort+year |
| `academic_class_enrolment` | Links students to classes (replaces `student_session` for class assignment) |
| `academic_subject` | Subjects (e.g., Mathematics, Engineering Science) |
| `academic_level` | Levels (e.g., N1–N6) — has `sequence_order` column |
| `academic_subject_level` | Links subjects to levels |
| `academic_programme` | TVET programmes |
| `academic_attendance` | Attendance per class |
| `academic_assessment` | ICASS/POE assessments |
| `sessions` | Academic years (unchanged) |
| `student_session` | Still exists — links student to session, NOT to a class |

#### Legacy Tables (still exist but deprecated)
| Table | Status |
|-------|--------|
| `classes` | Still exists but represents legacy classes — do NOT use for new features |
| `sections` | Deprecated — do NOT query this table |
| `class_sections` | Deprecated |

#### Two Separate Level Tables (critical distinction)
| Table | Has `sequence_order`? | Use for |
|-------|----------------------|---------|
| `academic_level` | YES | TVET levels (N1–N6), used by `Classmodel_model` |
| `level` | NO (use `code` for ordering) | Simple level lookups, used by `Level_model`, `Subjectlevel_model` |

Never add `sequence` or `sequence_order` to a query without checking which table the model actually JOINs.

### Model Rules

#### Primary Models (use these)

| When you need... | Use this model | Key method |
|-----------------|---------------|------------|
| List of classes for a session | `classmodel_model` | `getClassesBySession($session_id)` |
| Class details by ID | `classmodel_model` | `getClassById($class_id)` |
| Students in a class | `academic_enrolment_model` | `getAll(['class_id' => $id])` |
| Student's enrolments | `academic_enrolment_model` | `getAll(['student_id' => $id])` |
| Attendance records | `academic_attendance_model` | Various |
| Assessments/marks | `academic_assessment_model` | Various |

#### Deprecated Models (do NOT use for new features)
- `class_model` — replaced by `classmodel_model`
- `section_model` — stubbed out, returns empty arrays
- `studentsession_model` — still works but use `academic_enrolment_model` for class-related queries

#### 23 TVET Models (already built — do NOT recreate)
```
Academic_class_model       Academic_enrolment_model    Academic_attendance_model
Academic_assessment_model  Academic_marks_model        Academic_level_model
Academic_programme_model   Academic_subject_model      Academic_subject_level_model
Classmodel_model          Enrolment_model             Tvet_cohort_model
Tvet_programme_model      Tvet_qualification_model    Tvet_level_model
Tvet_level_module_model   Tvet_lecturer_allocation_model  Tvet_student_enrolment_model
Conference_model          Conferencehistory_model     Exam_moderation_model
Disability_type_model     Content_view_model
```

All models are auto-loaded in `MY_Controller` — use directly as `$this->model_name`.

### Controller Rules

#### Getting a class list (every controller that needs a class dropdown)
```php
// CORRECT — TVET pattern
$session_id = $this->setting[0]->session_id;
$data['classlist'] = $this->classmodel_model->getClassesBySession($session_id);

// WRONG — legacy pattern, do NOT use
$data['classlist'] = $this->class_model->get();
```

#### Getting students for a class
```php
// CORRECT — TVET pattern
$students = $this->academic_enrolment_model->getAll(['class_id' => $class_id]);

// WRONG — legacy pattern
$students = $this->studentsession_model->getByClassAndSection($class_id, $section_id);
```

#### AJAX endpoints receiving class selection
```php
// CORRECT — single class_id parameter
$class_id = $this->input->post('class_id');  // This IS the academic_class_id

// WRONG — two parameters
$class_id = $this->input->post('class_id');
$section_id = $this->input->post('section_id');
```

### View Rules

#### Class Dropdown — Always Use the Partial
```php
<!-- CORRECT — TVET single dropdown -->
<?php $this->load->view('admin/_partials/class_selector', [
    'selected_class_id' => $class_id,       // Optional: pre-select a class
    'name'              => 'class_id',       // Optional: defaults to 'class_id'
    'id'                => 'class_id',       // Optional: defaults to 'class_id'
    'required'          => true,             // Optional: defaults to true
    'label'             => 'Class',          // Optional: defaults to lang line
    'onchange'          => 'loadData()',     // Optional: JS callback
]); ?>

<!-- WRONG — dual dropdowns -->
<select name="class_id" onchange="getSectionByClass(this.value)">...</select>
<select name="section_id" id="section_id">...</select>
```

The partial expects `$classlist` to be set in the controller data (from `classmodel_model->getClassesBySession()`).

#### Never Show Section Columns
- Do NOT display "Section" column headers in tables
- Do NOT show section names in student profiles, reports, or lists
- If a legacy view still has section references, remove them

### Terminology Rules (mandatory)

| Wrong | Correct |
|-------|---------|
| Class + Section | Class |
| Section | *(remove entirely)* |
| Homework | Assignment |
| Student Accommodations | Students with Disabilities |
| Batch | Class *(in TVET context)* |

Use `$this->lang->line('key')` for all labels — language keys have already been updated.

### SQL Query Rules

#### CodeIgniter Query Builder
```php
// ALWAYS pass FALSE when using SQL functions in select()
$this->db->select('COUNT(*) as total', FALSE);
$this->db->select('CONCAT(s.firstname, " ", s.lastname) as name', FALSE);

// Without FALSE, CodeIgniter tries to backtick-escape the function and it breaks
```

#### JOINing to Get Class Info
```php
// CORRECT pattern for getting class details through enrolment
$this->db->join('academic_class_enrolment ace', 'ace.student_session_id = ss.id');
$this->db->join('academic_class ac', 'ac.id = ace.class_id');
$this->db->join('academic_subject_level asl', 'asl.id = ac.subject_level_id');
$this->db->join('academic_subject subj', 'subj.id = asl.subject_id');
$this->db->join('academic_level lvl', 'lvl.id = asl.level_id');
```

#### Column Name Gotcha: `student_session_id`
Some tables still have a column literally named `student_session_id`. This column stores the ID from the `student_session` table (which links a student to a session/year). This is intentional — `student_session` still exists and is used. The TVET change was removing `class_id + section_id` from `student_session`, NOT removing `student_session` itself.

### JavaScript Rules

- **Remove** any `getSectionByClass()` function calls
- **Remove** any AJAX calls to load sections based on class selection
- Class selection triggers should directly load data using the single `class_id` value
- DataTables AJAX calls should send `class_id` only, never `section_id`

### Existing TVET Infrastructure (do NOT modify unless fixing bugs)

#### Controllers
| Controller | Purpose |
|-----------|---------|
| `admin/Academic.php` | Academic management (class, subject, level, programme, enrolment, assessment, attendance, ICASS, POE, moderation, import, reports) |
| `admin/Tvet.php` | TVET admin (programme, qualification, level, cohort, lecturer, module) |
| `admin/Conference.php` | Live classes (Zoom + Teams) |
| `user/Tvetportal.php` | Student TVET portal |
| `user/Conference.php` | Student live class |
| `Disabilitytype.php` | Disability types + report |

#### Views
| Path | Content |
|------|---------|
| `views/admin/academic/` | 16 views across 14 subfolders |
| `views/admin/tvet/` | 17 views across 11 subfolders |
| `views/admin/conference/` | 13 views |
| `views/admin/_partials/class_selector.php` | Reusable dropdown component |
| `views/user/tvetportal/` | 8 views |
| `views/user/conference/` | 3 views |
| `views/disabilitytype/` | 3 views |

### Sidebar Menus

Menu items are stored in the `sidebar_sub_menus` database table with `lang_key` references. To add/modify menus, use SQL INSERT/UPDATE on this table — do NOT hardcode menus in PHP.

Key menu changes already applied:
- "Sections" menu item: **hidden** (`is_active=0`)
- "Homework" parent menu: **renamed to "Assignments"**
- "Students with Disabilities": **moved under Student Information**

### Docker / Deployment

- Fresh installs use `docker/init/001_tvet_complete_database.sql` (193 tables) and `docker/init/002_seed_data.sql`
- `docker-compose.yml` sets `SQL_MODE` to exclude `ONLY_FULL_GROUP_BY`
- Login endpoint: POST to `site/login` (NOT `site/userlogin`)
- Admin credentials: `admin@school.com` / `admin123`
- MySQL batch `ALTER TABLE` with multiple `ADD COLUMN` can silently fail — add columns individually

### Common Pitfalls

1. **replace_all double-replacement**: If replacing "sequence" with "sequence_order", the tool will also match the "sequence" inside "sequence_order" → "sequence_order_order". Do targeted replacements instead.
2. **Two level tables**: `academic_level` (has `sequence_order`) vs `level` (has `code`, no `sequence`). Check which table your model JOINs before using column names.
3. **Content.php index()**: The `index()` method delegates to `list()` — there is no `createcontent.php` view.
4. **Test AJAX separately**: DataTables AJAX endpoints can fail independently from page loads. Always test both.
5. **Playwright tests**: Run from `tests/` subdirectory (has its own `package.json`). Config: `tests/playwright.config.ts`.
