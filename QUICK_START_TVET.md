# TVET College System - Quick Start Guide

## 🚀 Fresh Installation (Single Command)

```bash
# Clean deployment (destroys all existing data)
docker-compose down -v && docker-compose up -d

# Wait for initialization (~2 minutes)
# Then access: http://localhost:8080/admin
```

**Login Credentials:**
- Email: `admin@school.com`
- Password: `admin123`

---

## 📦 What Gets Installed

### Database
- **66 Tables Total**
  - 52 Core System Tables (users, roles, settings, communication, etc.)
  - 14 TVET Academic Tables (programmes, subjects, classes, enrolments, assessments)

### Seed Data
- ✅ 6 Roles (Admin, Lecturer, Accountant, Librarian, Receptionist, Super Admin)
- ✅ 12 TVET Permission Categories
- ✅ Default Admin User (admin@school.com)
- ✅ Active Session 2026-27
- ✅ South African Settings (ZAR currency, Johannesburg timezone)
- ✅ 2 Languages (English active, Afrikaans inactive)

---

## 🔍 Verification Commands

```bash
# Check if containers are running
docker-compose ps

# Count tables (should be 66)
docker-compose exec db mysql -usmartschool -psmartschool123 \
  -e "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'smart_school';"

# List TVET academic tables (should be 14)
docker-compose exec db mysql -usmartschool -psmartschool123 \
  -e "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'smart_school' AND TABLE_NAME LIKE 'academic_%';"

# Verify admin user exists
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school \
  -e "SELECT id, employee_id, name, surname, email FROM staff WHERE id=1;"

# Verify active session
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school \
  -e "SELECT id, session, is_active FROM sessions WHERE is_active='yes';"

# Verify TVET permissions
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school \
  -e "SELECT COUNT(*) as tvet_permissions FROM permission_category WHERE short_code LIKE 'academic_%';"
```

---

## 📊 Database Access

### phpMyAdmin (Web Interface)
- URL: http://localhost:8081
- Server: db
- Username: smartschool
- Password: smartschool123

### MySQL CLI
```bash
# Connect to database
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school

# View all tables
SHOW TABLES;

# View TVET tables
SHOW TABLES LIKE 'academic_%';

# View roles
SELECT * FROM roles;

# View admin user
SELECT id, employee_id, name, surname, email, is_active FROM staff WHERE id=1;
```

---

## 🏗️ TVET Academic Structure

### Core Concept
```
CLASS = Subject + Level + Cohort + Year + Lecturer
```

### Example Class
```
Class Code: MATH-N4-A-2026
├── Subject: Mathematics (MATH)
├── Level: N4
├── Cohort: A
├── Year: 2026
└── Lecturer: Assigned via primary_lecturer_id
```

### Academic Hierarchy
```
academic_programme (NATED, NCV)
  └── academic_subject (Mathematics, Engineering Science)
      └── academic_level (N1, N2, N3, N4, N5, N6)
          └── academic_subject_level (MATH-N4, ENG-N5, etc.)
              └── academic_class (MATH-N4-A-2026, MATH-N4-B-2026)
                  ├── academic_class_enrolment (students in this class)
                  ├── academic_attendance (daily attendance)
                  ├── academic_assessment (tests, ICASS, POE, exams)
                  ├── academic_timetable (class schedule)
                  └── academic_class_lecturer (additional lecturers)
```

### Key Tables

| Table | Purpose | Key Fields |
|-------|---------|------------|
| `academic_programme` | Top-level (NATED, NCV) | code, name, qualification_type |
| `academic_subject` | Subjects in programmes | code, name, credits, notional_hours |
| `academic_level` | Levels (N1-N6, NCV L2-L4) | code, name, nqf_level |
| `academic_subject_level` | Subject-Level mapping | subject_id, level_id, syllabus_code |
| **`academic_class`** | **THE CENTRAL UNIT** | class_code, cohort_name, session_id, primary_lecturer_id |
| `academic_class_enrolment` | Student enrollments | student_id, class_id, status, final_mark |
| `academic_attendance` | Daily attendance | enrolment_id, date, status |
| `academic_assessment` | Assessments | class_id, type, total_marks, moderation_status |
| `academic_assessment_marks` | Student marks | assessment_id, enrolment_id, marks_obtained |

---

## 🔑 TVET Permissions

All permissions follow the pattern: `academic_*`

1. `academic_dashboard` - View academic dashboard
2. `academic_programmes` - Manage programmes (NATED, NCV)
3. `academic_subjects` - Manage subjects
4. `academic_levels` - Manage levels (N1-N6)
5. `academic_classes` - Manage classes (create, edit, roster)
6. `academic_enrolment` - Enrol students in classes
7. `academic_attendance` - Mark and view attendance
8. `academic_assessments` - Create assessments, enter marks
9. `academic_moderation` - Moderate assessments
10. `academic_icass` - Manage ICASS components
11. `academic_poe` - Manage Portfolio of Evidence
12. `academic_reports` - View academic reports

---

## 🚫 What's NOT Included (Legacy Tables Removed)

The following legacy school tables are **EXCLUDED** from TVET-only installation:

- ❌ `classes`, `sections`, `class_sections` (replaced by `academic_class`)
- ❌ `student_session` (replaced by `academic_class_enrolment`)
- ❌ `class_teacher`, `teacher_subjects` (replaced by `academic_class.primary_lecturer_id`)
- ❌ `subject_groups`, `subject_group_*` (replaced by `academic_subject_level`)
- ❌ `exam_schedules`, `exam_groups`, `exam_results` (replaced by `academic_assessment`)
- ❌ All fee-related tables (fees, income, expenses)
- ❌ All hostel, transport, library tables
- ❌ All alumni tables

**Total Removed**: 132 legacy tables

---

## 🛠️ Troubleshooting

### Database Container Not Running

```bash
# Check logs
docker-compose logs db

# Common issue: Port conflict
# Solution: Change port in docker-compose.yml (3307:3306)

# Restart containers
docker-compose restart
```

### Cannot Login

```bash
# Verify admin user exists
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school \
  -e "SELECT * FROM users WHERE username='admin';"

# Reset admin password (if needed)
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school \
  -e "UPDATE users SET password='admin123' WHERE id=1;"
```

### Foreign Key Errors During Installation

```bash
# This should NOT happen with the fixed database file
# If it does, check logs:
docker-compose logs db | grep ERROR

# Solution: Ensure you're using the latest database file
# docker/init/001_tvet_complete_database.sql
```

---

## 📝 Configuration Files

### Main Files

| File | Purpose | Changes Made |
|------|---------|--------------|
| `docker-compose.yml` | Docker services | ✅ Updated to use single SQL file |
| `docker/init/001_tvet_complete_database.sql` | Database schema & seed data | ✅ New consolidated file |
| `TVET_IMPLEMENTATION_STATUS.md` | Implementation tracking | ✅ Created |
| `QUICK_START_TVET.md` | This guide | ✅ Created |

### Source Files (for reference)

| File | Purpose | Status |
|------|---------|--------|
| `database_source/001_core_tables.sql` | Core tables only | ✅ Extracted |
| `database_source/README.md` | Database documentation | ✅ Created |
| `smart_school_src/application/migrations/009_*.sql` | TVET migration | ✅ Used |

---

## 🎯 Next Steps (After Fresh Install)

### 1. Configure System Settings
- Log in to admin panel
- Go to System Settings
- Update school name, logo, contact details

### 2. Create Academic Structure
```
1. Create Programmes (Admin → Academic Management → Programmes)
   Example: "NATED Engineering Studies"

2. Create Subjects (Admin → Academic Management → Subjects)
   Examples: Mathematics, Engineering Science, etc.

3. Create Levels (Admin → Academic Management → Levels)
   Examples: N1, N2, N3, N4, N5, N6

4. Map Subject-Levels (Admin → Academic Management → Subject-Level Mapping)
   Examples: MATH-N4, ENG-N5, etc.

5. Create Classes (Admin → Academic Management → Classes)
   Examples: MATH-N4-A-2026, MATH-N4-B-2026
```

### 3. Add Staff/Lecturers
- Go to Human Resource → Staff
- Add lecturers and assign roles

### 4. Add Students
- Go to Student Management → Add Student
- Or use Bulk Import for multiple students

### 5. Enrol Students
- Go to Academic Management → Student Enrolment
- Select class and enrol students

### 6. Start Using TVET Features
- ✅ Mark Attendance (per class)
- ✅ Create Assessments (ICASS, POE, Tests)
- ✅ Enter Marks
- ✅ Generate Reports

---

## 📞 Support

For issues or questions:
1. Check `TVET_IMPLEMENTATION_STATUS.md` for detailed status
2. Review Docker logs: `docker-compose logs`
3. Check database directly via phpMyAdmin or MySQL CLI

---

## ⚠️ Important Notes

1. **Fresh Install Only**: This database file is for NEW installations. Do NOT use on existing systems with data.
2. **Data Loss Warning**: `docker-compose down -v` DESTROYS ALL DATA including the database volume.
3. **Admin Password**: Change the default admin password (`admin123`) after first login.
4. **Active Session**: Set to 2026-27 by default. Update if needed.
5. **Legacy System**: This is NOT compatible with the old class+section model. It's TVET-only.

---

**Last Updated**: February 6, 2026
**TVET Installation File Version**: 1.0
**Total Tables**: 66 (52 core + 14 TVET academic)
