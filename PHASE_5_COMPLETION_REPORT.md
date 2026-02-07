# Phase 5 Completion Report: Online Exams & Resources

## Summary
Phase 5 of the TVET migration is complete. All online exam functionality has been migrated from the legacy class+section model to the TVET class-centric model using enrolment-based access.

## Key Transformation
```
FROM: student_session_id (with class_id + section_id)
TO:   enrolment_id (class_id only, where class = subject + level + cohort + year)
```

## Files Modified

### Models (3 files)

#### 1. Onlineexam_model.php
Added 9 TVET methods:
- `getstudentbyenrolmentid($enrolment_id)` - Get student details by enrolment ID
- `searchOnlineExamStudentsTVET($class_id, $onlineexam_id)` - Search students for exam assignment
- `getStudentExamByEnrolment($enrolment_id)` - Get exams for a student by enrolment
- `examStudentsByEnrolment($enrolment_id, $onlineexam_id)` - Validate student for exam
- `getStudentExamListTVET($enrolment_id)` - Get active exam list for student portal
- `getStudentClosedExamListTVET($enrolment_id)` - Get closed exam list for student portal
- `getStudentExamCountTVET($enrolment_id)` - Count exams for student
- `getClosedExamCountTVET($enrolment_id)` - Count closed exams for student
- `examByEnrolment($enrolment_id)` - Get exam details by enrolment

#### 2. Onlineexamresult_model.php
Added 2 TVET methods:
- `getDescriptionRecordTVET($per_page, $start, $where, $exam_id)` - Get descriptive question results using enrolment
- `getStudentByExamTVET($exam_id, $class_id)` - Get students by exam with class_code/cohort_name

#### 3. Student_model.php
Added 1 TVET method:
- `getByEnrolment($enrolment_id)` - Get student details by enrolment (replaces getByStudentSession)

### Controllers (2 files)

#### 1. admin/Onlineexam.php
Updated method calls:
- Line 328: `searchOnlineExamStudents()` → `searchOnlineExamStudentsTVET()`
- Line 372: `getDescriptionRecord()` → `getDescriptionRecordTVET()`
- Line 493: `searchOnlineExamStudents()` → `searchOnlineExamStudentsTVET()`
- Line 519: `searchOnlineExamStudents()` → `searchOnlineExamStudentsTVET()`
- Line 1189: `examstudentsID()` → `examStudentsByEnrolment()`
- Line 1278: `getStudentByExam()` → `getStudentByExamTVET()`

Uses `classmodel_model->getClassesBySession()` for class lists (already migrated).

#### 2. user/Onlineexam.php
Updated all methods:
- `index()` - Uses `getStudentCurrentEnrolment()` instead of `getStudentCurrentClsSection()`
- `view()` - Uses `examStudentsByEnrolment()`, `getByEnrolment()`
- `print()` - Uses `getByEnrolment()`, `examStudentsByEnrolment()`
- `getExamForm()` - Uses `examStudentsByEnrolment()`
- `getexamlist()` - Uses `getStudentExamListTVET()`
- `getclosedexamlist()` - Uses `getStudentClosedExamListTVET()`

### Views (6 files)

#### Admin Views:
1. **assign.php**
   - Changed `onlineexam_student_session_id` → `onlineexam_enrolment_id`
   - Changed `student_session_id` → `enrolment_id`
   - Changed `class + section` → `class_code + cohort_name`

2. **report.php**
   - Changed JavaScript `student_session_id` → `enrolment_id` (2 places)

3. **_getDescQues.php**
   - Changed `class + section` → `class_code + cohort_name`

#### User Views:
4. **view.php**
   - Changed `class + section` → `class_code + cohort_name`

5. **_print.php**
   - Changed `class + section` → `class_code + cohort_name`

## Table Mapping

| Legacy Table | TVET Replacement |
|--------------|------------------|
| `student_session` | `academic_class_enrolment` (alias: `enrolment`) |
| `onlineexam_students.student_session_id` | `onlineexam_students.enrolment_id` |
| `classes + sections` | `academic_class` (alias: `class`) |

## Method Mapping

| Legacy Method | TVET Method |
|--------------|-------------|
| `getByStudentSession($student_session_id)` | `getByEnrolment($enrolment_id)` |
| `searchOnlineExamStudents($class_id, $section_id, $exam_id)` | `searchOnlineExamStudentsTVET($class_id, $exam_id)` |
| `examstudentsID($student_session_id, $exam_id)` | `examStudentsByEnrolment($enrolment_id, $exam_id)` |
| `getstudentexamlist($student_session_id)` | `getStudentExamListTVET($enrolment_id)` |
| `getstudentclosedexamlist($student_session_id)` | `getStudentClosedExamListTVET($enrolment_id)` |
| `getDescriptionRecord()` | `getDescriptionRecordTVET()` |
| `getStudentByExam()` | `getStudentByExamTVET()` |

## TVET Model Concept for Online Exams

In TVET:
- **Exam Assignment** = Via `onlineexam_students.enrolment_id` (not student_session_id)
- **Class Context** = From `academic_class` with subject_level_id
- **Student Lookup** = Via `academic_class_enrolment` joined to `students`
- **Multiple Enrolments** = Students can be enrolled in multiple classes/subjects

## Testing Checklist

- [ ] Create online exam
- [ ] Assign students to exam by class
- [ ] Student takes exam (portal)
- [ ] View exam results (admin)
- [ ] View exam results (student)
- [ ] Print exam results
- [ ] Descriptive question evaluation
- [ ] Exam reports by class

## Notes

1. All TVET methods use `FALSE` parameter with `$this->db->select()` when including SQL functions
2. Legacy methods are preserved for backward compatibility but not used in TVET mode
3. The `onlineexam_students` table needs `enrolment_id` column (added in migration 009)
4. Student portal uses `customlib->getStudentCurrentEnrolment()` to get current enrolment

## Next Phase

**Phase 6: Fees & Admissions (9 files)**
- Controllers: Feesforward.php, Feediscount.php, Onlinestudent.php
- Models: Studentfee_model.php, Onlinestudent_model.php

---
*Generated: 2026-02-06*
