# QA Testing Handover Guide

## Quick Start

### Prerequisites
- Docker Desktop installed and running
- Git access to this repository
- Web browser (Chrome/Firefox recommended)

### Setup Steps

```bash
# 1. Clone and checkout the branch
git clone <repo-url>
cd Smart-School-Git-Repo
git checkout feature/tvet-phase-1-2

# 2. Start the Docker environment
docker compose up -d --build

# 3. Wait for containers to initialize (first run takes ~2 minutes)
docker compose logs -f app
# Wait until you see: "Apache is running"
```

### Access URLs

| Service | URL | Notes |
|---------|-----|-------|
| Smart School (Admin) | http://localhost:8080/site/login | Staff login page |
| Smart School (Student) | http://localhost:8080/site/userlogin | Student/Parent login page |
| phpMyAdmin | http://localhost:8081 | DB: smart_school / User: smartschool / Pass: smartschool123 |

---

## Login Credentials

### Admin Panel (Staff Login)

| Role | Email | Password | Access URL |
|------|-------|----------|------------|
| Super Admin | admin@admin.com | Admin@123 | http://localhost:8080/site/login |
| Teacher | teacher@school.com | Teacher@123 | http://localhost:8080/site/login |

### Student Portal

| Role | Username | Password | Access URL |
|------|----------|----------|------------|
| Student 1 (Test Student) | std1 | Student@123 | http://localhost:8080/site/userlogin |
| Student 2 (Accommodation) | std2 | Student@123 | http://localhost:8080/site/userlogin |

> **Note**: After student login, you may be asked to "Choose Class" - select "N4 Business Management (Group A)".

---

## Test Scope

Refer to **QA_Test_Cases.csv** for the full test matrix. The CSV contains 66 test cases organized into sections:

| Section | Description | Test IDs |
|---------|-------------|----------|
| A | TVET Core Module (Spec PDF - Milestone 1) | A1.1 - A8.4 |
| B | Workshop Requirements (Video Recording) | B1.1 - B9.11 |
| C | Additional Dev Fixes | C1.1 - C2.2 |
| D | Not In Current Scope (Future Phases) | D1.1 - D5.2 |

### How to Use QA_Test_Cases.csv

1. Open in Excel/Google Sheets
2. For each test case, follow the **Steps** column
3. Compare actual behavior against **Expected Result**
4. Fill in **Actual Result**, **Status (PASS/FAIL)**, and **Notes** columns
5. Section D items are marked as "NOT IMPLEMENTED" - skip these

---

## Feature Summary

### Section A: TVET Management (Admin Panel)

Navigate to: **Left Sidebar > TVET Management**

Sub-menus:
- Dashboard - Summary statistics
- Programmes - NATED, NC(V), etc.
- Qualifications - Linked to programmes
- Levels - N4, N5, N6, etc.
- Cohorts - Student groups per level
- Module Mapping - Link subjects to levels
- Lecturer Allocation - Assign staff to cohort+module

**Test data to create** (in order):
1. Programme: NATED (Code: NATED)
2. Programme: NC(V) (Code: NCV)
3. Qualification: Business Management under NATED
4. Level: N4 under Business Management
5. Cohort: Group A (2026 intake) under N4

### Section B: Workshop Requirements

| Feature | Where to Find |
|---------|---------------|
| B1: Content Category Filter | Admin > Download Center > Upload Content (dropdown above listing) |
| B2: Content View Tracking | Student portal > Download Center (look for "New" badges) |
| B3: Exam Redirect After Assign | Admin > Online Exam > [exam] > Assign students > Save |
| B4: Exam Preview | Admin > Online Exam > Preview icon on exam row |
| B5: Zip Upload | Admin > Download Center > Upload Content (select .zip file) |
| B6: Assignment Rename | Student portal > "Assignment" section (was "Homework") |
| B7: Exam Moderation | Admin > Online Exam > Submit for Moderation / Review |
| B8: Student Accommodation | Admin > Accommodation (disability extra time) |
| B9: Teams Integration | Left Sidebar > Teams Live Classes |

### Section C: Dev Fixes

| Feature | How to Test |
|---------|-------------|
| C1: Zoom API Error Handling | Set invalid Zoom credentials, try creating Live Class |
| C2: Content Sharing | Admin > Upload Content > Share to multiple sections |

---

## Resetting the Environment

If you need to start fresh:

```bash
# Stop and remove all containers + volumes
docker compose down -v

# Rebuild from scratch
docker compose up -d --build
```

This will recreate the database with all test data.

---

## Database Access

Use phpMyAdmin at http://localhost:8081 to:
- View/modify test data
- Check migration tables were created
- Verify data after CRUD operations

Key tables to check:
- `tvet_programme`, `tvet_qualification`, `tvet_level`, `tvet_cohort` - TVET hierarchy
- `tvet_lecturer_allocation` - Lecturer assignments
- `content_views` - View tracking records
- `onlineexam` (column: `moderation_status`) - Exam moderation
- `exam_moderation_comments` - Moderator comments
- `student_accommodations` - Disability accommodations
- `conferences` (column: `platform`) - Teams/Zoom entries
- `zoom_settings` (columns: `teams_*`) - Teams API credentials

---

## Known Limitations

1. **Teams API**: Requires valid Azure AD credentials to create actual meetings. Without credentials, the form should show a friendly error message (not a PHP crash).
2. **Zoom API**: Same as Teams - requires valid API keys for live meeting creation.
3. **Student Accommodation Timer**: Extra time is calculated but requires a live exam session to observe the extended timer.
4. **Section D items**: These are future milestones and are NOT implemented.

---

## Reporting Issues

When reporting a failed test case:
1. Note the **Test ID** (e.g., B4.2)
2. Screenshot the actual behavior
3. Note the browser and any console errors (F12 > Console)
4. Check Docker logs: `docker compose logs app` for PHP errors
