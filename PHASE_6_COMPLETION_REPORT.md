# Phase 6 Completion Report: Fees & Admissions

## Summary
Phase 6 of the TVET migration is complete. Fee discount and online admission functionality has been migrated from the legacy class+section+student_session model to the TVET class-centric model using enrolment-based access.

## Key Transformation
```
FROM: student_session_id (with class_id + section_id)
TO:   enrolment_id (class_id only, where class = subject + level + cohort + year)
```

## Files Modified

### Models (2 files)

#### 1. Feediscount_model.php
Added 5 TVET methods:
- `searchAssignFeeByClassTVET($class_id, $fees_discount_id, $category, $gender, $rte)` - Search students for fee discount assignment using academic_class_enrolment
- `allotDiscountTVET($data)` - Allot discount using enrolment_id instead of student_session_id
- `deleteDiscountByEnrolmentTVET($fees_discount_id, $enrolment_ids)` - Delete discounts by enrolment IDs
- `getStudentFeesDiscountTVET($enrolment_id)` - Get discounts by enrolment_id
- `getDiscountNotAppliedTVET($enrolment_id)` - Get unapplied discounts by enrolment

#### 2. Onlinestudent_model.php
Added 5 TVET methods:
- `getTVET($id, $class_ids)` - Get online admission with academic_class details
- `getstudentlistTVET($class_ids, $id)` - Datatable query using academic_class
- `updateTVET($data, $fee_session_group_id, $transport_feemaster_id, $discount_id, $action)` - Creates academic_class_enrolment instead of student_session
- `getClassByIdTVET($class_id)` - Get class details from academic_class
- `getOnlineAdmissionFeeCollectionReportTVET($start_date, $end_date)` - Report using academic_class

### Controllers (2 files)

#### 1. admin/Feediscount.php
Updated method calls:
- Line 158-167: `assign()` - Removed section_id handling
- Line 165: `searchAssignFeeByClassSection()` → `searchAssignFeeByClassTVET()`
- Lines 191-209: `studentdiscount()` - Changed to use enrolment_id
  - Changed `student_session_id` → `enrolment_id`
  - Changed `allotdiscount()` → `allotDiscountTVET()`
  - Changed `deletedisstd()` → `deleteDiscountByEnrolmentTVET()`

#### 2. admin/Onlinestudent.php
Updated method calls:
- Line 245: `update()` → `updateTVET()`
- Line 465: `getstudentlist()` → `getstudentlistTVET()`
- Line 533: Changed display from `class(section)` → `class_code(cohort_name)`

### Views (1 file)

#### admin/feediscount/assign.php
- Line 154: Changed hidden input from `student_session_id` → `enrolment_id`
- Line 164: Changed checkbox name from `student_session_id[]` → `enrolment_id[]`
- Line 168: Changed display from `class(section)` → `class_code(cohort_name)`

## Table Mapping

| Legacy Table | TVET Replacement |
|--------------|------------------|
| `student_session` | `academic_class_enrolment` (alias: `enrolment`) |
| `student_fees_discounts.student_session_id` | `student_fees_discounts.enrolment_id` |
| `online_admissions.class_section_id` | `online_admissions.class_id` |
| `classes + sections` | `academic_class` (alias: `class`) |

## Method Mapping

| Legacy Method | TVET Method |
|--------------|-------------|
| `searchAssignFeeByClassSection($class_id, $section_id, ...)` | `searchAssignFeeByClassTVET($class_id, ...)` |
| `allotdiscount($data)` | `allotDiscountTVET($data)` |
| `deletedisstd($id, $array)` | `deleteDiscountByEnrolmentTVET($id, $array)` |
| `get($id, $carray)` | `getTVET($id, $class_ids)` |
| `getstudentlist($carray, $id)` | `getstudentlistTVET($class_ids, $id)` |
| `update($data, ...)` | `updateTVET($data, ...)` |

## TVET Model Concept for Fees & Admissions

In TVET:
- **Fee Discount Assignment** = Via `enrolment_id` (not student_session_id)
- **Online Admission** = Uses `class_id` directly (not class_section_id)
- **Student Enrollment** = Creates `academic_class_enrolment` record on admission
- **Class Context** = From `academic_class` with subject_level_id
- **Multiple Enrolments** = Students can be enrolled in multiple classes/subjects

## Testing Checklist

- [ ] Create fee discount
- [ ] Assign fee discount to students by class
- [ ] Verify discount appears in student fee collection
- [ ] Online admission form submission
- [ ] Admin review and enroll online admission
- [ ] Verify student gets enrolled in academic_class_enrolment
- [ ] View online admission list with class display

## Notes

1. All TVET methods use `FALSE` parameter with `$this->db->select()` when including SQL functions
2. Legacy methods are preserved for backward compatibility but not used in TVET mode
3. The `student_fees_discounts` table needs `enrolment_id` column (added in migration 009)
4. The `online_admissions` table needs `class_id` column (for TVET mode)
5. Views already use the TVET-compatible `class_selector` partial which works with academic_class

## Pending Items for Future Phases

1. **Feesforward.php** - Fee carry forward uses `getPreviousSessionStudent()` which relies on legacy student_session structure. This is complex and may need to wait until the full fees migration.
2. **Studentfee_model.php** - Core fee model needs TVET methods if fees are to be tied to enrolments directly.
3. **Transport fees** - The `updateTVET()` method calls `studenttransportfee_model->addTVET()` which may need to be created.

## Next Phase

**Phase 7: Reports & Front CMS (20 files)**
- Controllers: Report.php, Welcome.php, Site.php, front/*
- Models: Report models
- Views: Various report views

---
*Generated: 2026-02-06*
