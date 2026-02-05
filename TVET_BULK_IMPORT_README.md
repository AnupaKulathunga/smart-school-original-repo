# TVET Bulk Student Import System

## Overview

The TVET Bulk Import system enables comprehensive enrollment of students from Excel data. It supports:
- ✅ Student creation/updating
- ✅ Programme linking
- ✅ Class enrollment
- ✅ Multiple subjects per student
- ✅ Full enrollment data (status, dates, notes)

## System Components

### 1. Python Excel Converter (`tvet_excel_to_csv.py`)
Converts Excel enrollment data to CSV format compatible with the import system.

**Location:** `/Users/anupa/ADNK Group of Companies/Direct Clients/Graham/Smart-School-Git-Repo/tvet_excel_to_csv.py`

**Requirements:**
```bash
pip install pandas openpyxl
```

**Usage:**

**Analysis Mode** (recommended first step):
```bash
python tvet_excel_to_csv.py \
    --input "Goodwood Online registered students 2026 T1_S1 (1).xlsx" \
    --analyze-only
```

**Full Conversion:**
```bash
python tvet_excel_to_csv.py \
    --input "Goodwood Online registered students 2026 T1_S1 (1).xlsx" \
    --output-dir ./output \
    --cohort "A" \
    --year 2026 \
    --verbose
```

**Options:**
- `--input`: Excel file path (required)
- `--output-dir`: Output directory (default: ./output)
- `--cohort`: Default cohort name (default: A)
- `--year`: Academic year (default: current year)
- `--skip-orphaned`: Skip rows with no student data (default: true)
- `--analyze-only`: Generate analysis report without CSV conversion
- `--verbose`: Show detailed progress

### 2. Import Controller (`Student::importEnrolments()`)
PHP controller method that processes CSV files and creates enrollments.

**Location:** `smart_school_src/application/controllers/Student.php`

**Access:** http://localhost:8080/student/importEnrolments

**Methods:**
- `importEnrolments()` - Main import function with form
- `exportformatEnrolments()` - Download sample CSV
- `processEnrolmentCSV()` - Process uploaded CSV
- `processEnrolmentRow()` - Handle individual enrollment row

### 3. Model Methods

**Classmodel_model::getClassBySubjectLevel()**
- Finds class by subject code + level code + cohort + year
- Location: `smart_school_src/application/models/Classmodel_model.php`

**Programme_model::getProgrammeByName()**
- Finds programme by name (exact or partial match)
- Location: `smart_school_src/application/models/Programme_model.php`

### 4. View & Sample Files

**Import View:** `smart_school_src/application/views/student/import_enrolments.php`
**Sample CSV:** `smart_school_src/backend/import/tvet_enrolments_sample.csv`

## CSV Format (17 Columns)

### Column Specifications

| Column | Type | Required | Description | Example |
|--------|------|----------|-------------|---------|
| **Student Fields** |
| admission_no | VARCHAR(50) | YES | Student admission/registration number | 202401 |
| firstname | VARCHAR(100) | YES | Student first name(s) | John |
| lastname | VARCHAR(100) | YES | Student surname/family name | Doe |
| id_number | VARCHAR(13) | NO | SA ID number (13 digits) | 9512151234567 |
| dob | DATE | NO | Date of birth (YYYY-MM-DD) | 1995-12-15 |
| gender | VARCHAR(10) | NO | Male/Female | Male |
| mobileno | VARCHAR(20) | NO | Student mobile phone number | 0821234567 |
| email | VARCHAR(100) | NO | Student email address | john@example.com |
| **Class/Subject Fields** |
| subject_code | VARCHAR(20) | YES | Subject code | MATH |
| level_code | VARCHAR(10) | YES | Level code | N4 |
| cohort_name | VARCHAR(50) | NO | Cohort/class group | A |
| academic_year | INT | YES | Academic year | 2026 |
| **Programme Fields** |
| qualification_name | VARCHAR(255) | NO | Programme/qualification full name | National Certificate: Engineering |
| campus_name | VARCHAR(100) | NO | Campus location name | Goodwood Campus |
| **Enrollment Fields** |
| enrolment_date | DATE | NO | Date of enrollment (YYYY-MM-DD) | 2026-01-15 |
| status | VARCHAR(20) | NO | Enrollment status | Active |
| notes | TEXT | NO | Additional notes/comments | |

### Status Values
- `Active` - Student actively enrolled
- `Dropped` - Student cancelled/withdrew
- `Completed` - Student completed the subject
- `Suspended` - Temporarily suspended
- `Transferred` - Transferred to another institution
- `Withdrawn` - Permanently withdrawn

### Multiple Subjects
Students can appear multiple times (one row per subject):
```csv
202401,John,Doe,...,MATH,N4,A,2026,...
202401,John,Doe,...,ENG,N4,A,2026,...
```

## Prerequisites (CRITICAL)

Before importing, ensure these exist in the system:

### 1. ❌ Subjects
**Table:** `subjects`
**Required:** Subject code must match CSV `subject_code`
**Create:** Admin → TVET → Subjects

### 2. ❌ Levels
**Table:** `level`
**Required:** Level code must match CSV `level_code`
**Create:** Admin → TVET → Levels

### 3. ❌ Subject-Level Combinations
**Table:** `subject_level`
**Required:** Each subject+level combination from CSV
**Create:** Admin → TVET → Subject Levels

### 4. ❌ Classes
**Table:** `class`
**Required:** For each subject+level+cohort+year combination
**Create:** Admin → TVET → Classes

### 5. ❌ Programmes (Optional)
**Table:** `programme`
**Required:** Only if `qualification_name` is provided in CSV
**Create:** Admin → TVET → Programmes

### 6. ✅ Active Session
**Table:** `sessions`
**Required:** One active session must exist

### What Import Creates Automatically
- ✅ **Students** - Created if `admission_no` doesn't exist
- ✅ **Student-Programme Links** - Created if programme found
- ✅ **Enrollments** - Created for each CSV row

### What Import Does NOT Create
- ❌ Subjects
- ❌ Levels
- ❌ Subject-Level combinations
- ❌ Classes
- ❌ Programmes

## Complete Workflow

### Step 1: Analyze Excel File
```bash
cd "/Users/anupa/ADNK Group of Companies/Direct Clients/Graham/Smart-School-Git-Repo"

python tvet_excel_to_csv.py \
    --input "Goodwood Online registered students 2026 T1_S1 (1).xlsx" \
    --analyze-only
```

**Output:** Analysis report showing:
- Unique subjects needed
- Unique levels needed
- Unique subject-level combinations
- Unique qualifications
- Total students and enrollments

### Step 2: Create Master Data

Based on analysis, create in Smart School:

1. **Subjects** (Admin → TVET → Subjects)
   - Example: MATH, ENG, BUSM, CIVIL

2. **Levels** (Admin → TVET → Levels)
   - Example: N1, N2, N3, N4, N5, N6

3. **Subject-Level Combinations** (Admin → TVET → Subject Levels)
   - Example: MATH-N4, ENG-N4, BUSM-N3

4. **Programmes** (Admin → TVET → Programmes)
   - Example: "National Certificate: Engineering"

5. **Classes** (Admin → TVET → Classes)
   - For each subject+level+cohort+year
   - Example: MATH-N4-A-2026

### Step 3: Convert Excel to CSV
```bash
python tvet_excel_to_csv.py \
    --input "Goodwood Online registered students 2026 T1_S1 (1).xlsx" \
    --output-dir ./output \
    --cohort "A" \
    --year 2026 \
    --verbose
```

**Output Files:**
- `output/tvet_enrolments_TIMESTAMP.csv` - Valid enrollments
- `output/errors_TIMESTAMP.log` - Skipped/invalid rows
- `output/summary_TIMESTAMP.txt` - Conversion statistics

### Step 4: Review CSV
- Open generated CSV in spreadsheet software
- Verify student data (names, ID numbers, contacts)
- Verify class data (subject codes, level codes, cohorts)
- Check for any errors or missing data

### Step 5: Import to Smart School
1. Navigate to http://localhost:8080/student/importEnrolments
2. Click "Download Sample CSV" to review format
3. Upload generated CSV file
4. Review import results:
   - Students created
   - Students updated
   - Enrollments created
   - Programmes linked
   - Errors (if any)

### Step 6: Verify Import
```sql
-- Check students created
SELECT COUNT(*) FROM students WHERE admission_no LIKE '2024%';

-- Check enrollments
SELECT COUNT(*) FROM enrolment WHERE session_id = <current_session>;

-- Check programme links
SELECT COUNT(*) FROM student_programme WHERE session_id = <current_session>;

-- View enrollment details
SELECT s.admission_no, s.firstname, s.lastname,
       sub.name as subject, l.name as level,
       c.cohort_name, e.status
FROM enrolment e
JOIN students s ON e.student_id = s.id
JOIN class c ON e.class_id = c.id
JOIN subject_level sl ON c.subject_level_id = sl.id
JOIN subjects sub ON sl.subject_id = sub.id
JOIN level l ON sl.level_id = l.id
WHERE e.session_id = <current_session>
ORDER BY s.admission_no, sub.name;
```

## Excel Source Data Format

The Python script is designed to work with Excel files in this format:

### Expected Columns
- `STUDENT_NUMBER` - Student registration number
- `FIRST_NAMES` - Student first name(s)
- `SURNAME` - Student surname
- `ID_NUMBER` - South African ID number (13 digits)
- `SUBJECT_CODE` - Compressed format: MATHN2S (subject + level + semester)
- `SUBJECT_NAME` - Subject full name
- `QUALIFICATION_NAME` - Programme name
- `CAMPUS_NAME` - Campus location
- `CANCEL_DATE` - Cancellation date (if dropped)
- `StudentCellphoneNumber` - Mobile phone
- `StudentEmailAddress` - Email address

### SUBJECT_CODE Parsing

The script parses compressed subject codes in **MATHN2S** format:

**Pattern:** `^([A-Z]+)(N[1-6]C?)([A-Z]?)$`

**Examples:**
- `MATHN2S` → subject=`MATH`, level=`N2`, semester=`S`
- `ENGN4` → subject=`ENG`, level=`N4`
- `BUSMN3C` → subject=`BUSM`, level=`N3C`
- `CIVILN5S` → subject=`CIVIL`, level=`N5`, semester=`S`

**Extraction:**
1. Letters before 'N' → subject_code
2. 'N' + digit + optional 'C' → level_code
3. Remaining letters → semester (optional, not used in class lookup)

### SA ID Number Processing

**Format:** YYMMDD GSSS CAZ (13 digits)

**DOB Extraction:**
- First 6 digits = YYMMDD
- Century: <22 → 2000s, >=22 → 1900s
- Example: 9512151234567 → 1995-12-15

**Gender Extraction:**
- Position 7-10 (GSSS): Gender Sequence
- 0000-4999 = Female
- 5000-9999 = Male
- Example: 9512151234567 (GSSS=1234) → Female

### Orphaned Rows

Rows with no student data (empty STUDENT_NUMBER) are skipped and logged:
- **Action:** Skip and log
- **Reason:** No student data to import
- **Example:** Goodwood file had 895 orphaned rows (out of 1,973 total)

## Error Handling

### Import Errors

**Common Errors:**
1. **Class not found** - Subject, level, cohort, or year doesn't exist
   - **Solution:** Create missing class in system

2. **Student already enrolled** - Duplicate enrollment in same class
   - **Solution:** Check if intentional, may need to manually resolve

3. **Programme not found** - Qualification name doesn't match any programme
   - **Action:** Continues (doesn't fail), but student not linked to programme

4. **Invalid CSV format** - Wrong number of columns
   - **Solution:** Check CSV has exactly 17 columns

### Python Script Errors

**Common Errors:**
1. **Invalid SUBJECT_CODE format** - Doesn't match MATHN2S pattern
   - **Solution:** Check source data, may need manual correction

2. **Invalid ID number** - Not 13 digits
   - **Action:** Warns but continues, DOB/gender won't be extracted

3. **Invalid phone/email format** - Doesn't match expected pattern
   - **Action:** Warns but continues

## Performance

### Expected Processing Times

**Python Script:**
- 2,000 rows: ~5-10 seconds
- 10,000 rows: ~30-60 seconds

**PHP Import:**
- 100 enrollments: ~10-20 seconds
- 1,000 enrollments: ~2-3 minutes
- 10,000 enrollments: ~20-30 minutes

**Note:** Performance depends on:
- Server resources
- Number of database lookups
- Network latency (Docker container)

## Troubleshooting

### Python Script Issues

**Problem:** `ModuleNotFoundError: No module named 'pandas'`
**Solution:**
```bash
pip install pandas openpyxl
```

**Problem:** `FileNotFoundError: [Errno 2] No such file or directory`
**Solution:** Check Excel file path, use absolute path if needed

**Problem:** `ValueError: Excel file format cannot be determined`
**Solution:** Ensure file is valid .xlsx format

### Import Issues

**Problem:** "Class not found: MATH-N4-A-2026"
**Solution:** Create class with exact subject code, level code, cohort, and year

**Problem:** "Failed to create student"
**Solution:** Check database permissions, student model configuration

**Problem:** "Invalid CSV format (expected 17 columns)"
**Solution:** Ensure CSV has exactly 17 columns, check for missing commas

### Docker Issues

**Problem:** Cannot access import page
**Solution:**
```bash
docker-compose logs -f web
docker-compose restart web
```

**Problem:** File upload fails
**Solution:** Check PHP upload limits in `php.ini`:
```ini
upload_max_filesize = 10M
post_max_size = 10M
```

## Security Considerations

### CSV File Validation
- ✅ File type checked (.csv only)
- ✅ RBAC permission required (`import_student` privilege)
- ✅ UTF-8 encoding for international characters
- ✅ SQL injection protected (parameterized queries)

### Data Privacy
- ⚠️ ID numbers are sensitive - ensure secure upload/storage
- ⚠️ Email addresses require consent for use
- ⚠️ Phone numbers should be opt-in for SMS/calls

### Access Control
- Only users with `import_student` privilege can access
- Audit trail: Flash messages show import statistics
- Partial import: Errors logged but don't stop entire import

## Maintenance

### Backup Before Import
```bash
# Docker database backup
docker-compose exec db mysqldump -usmartschool -psmartschool123 smart_school > backup_YYYYMMDD.sql

# Restore if needed
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school < backup_YYYYMMDD.sql
```

### Cleanup Old Imports
```sql
-- Remove test enrollments
DELETE FROM enrolment WHERE enrolment_date = '2026-01-15' AND notes LIKE '%test%';

-- Remove orphaned student-programme links
DELETE sp FROM student_programme sp
LEFT JOIN students s ON sp.student_id = s.id
WHERE s.id IS NULL;
```

### Update Sample CSV
When CSV format changes, update:
1. `tvet_enrolments_sample.csv` - Sample file
2. `import_enrolments.php` - View instructions
3. This README

## Support

### Logs

**Python Script Logs:**
- `output/errors_TIMESTAMP.log` - Conversion errors
- `output/summary_TIMESTAMP.txt` - Statistics

**PHP Import Logs:**
- Flash messages (success/error)
- Application logs: `smart_school_src/application/logs/`

### Contact

For issues or questions:
- Check this README first
- Review logs for error details
- Check database for data integrity
- Consult TVET_BULK_IMPORT_PLAN.md for implementation details

## Version History

**v1.0.0** (2026-02-05)
- Initial implementation
- 17-column CSV format
- Python Excel converter with SUBJECT_CODE parsing
- SA ID number extraction (DOB, gender)
- Comprehensive enrollment import
- Student creation/updating
- Programme linking
- Multiple subjects per student

## License

This is part of the Smart School Management System (v7.1.0)
