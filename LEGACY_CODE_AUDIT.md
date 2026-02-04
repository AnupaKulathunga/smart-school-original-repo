# Legacy Code Audit - Remaining TVET Migration Work

**Date:** 2026-02-04
**Status:** 🟡 IN PROGRESS

---

## Summary

After completing Approve Leave, Attendance, Exam Schedule, Exam Result, Admitcard, and Question Bank migrations, significant legacy code remains:

```
⚠️  91 controllers using legacy class_model->get()
⚠️  35 views with section_id dropdowns  
⚠️  43 form validations with section_id
```

**Completion:** ~32% (16 of ~50 major pages fixed)

---

## Files Still Requiring Section Dropdown Removal

### Priority 1: User-Facing Pages (8 files)

1. ✅ `/admin/approve_leave` - FIXED
2. ✅ `/admin/stuattendence/attendenceList.php` - FIXED
3. ✅ `/admin/examgroup/addexam.php` - FIXED
4. ✅ `/admin/examgroup/addmark.php` - FIXED
5. ✅ `/admin/examgroup/assign.php` - FIXED
6. ✅ `/admin/examgroup/exam.php` - FIXED
7. ✅ `/admin/mark/markList.php` - FIXED
8. ⚠️  `/admin/subjectgroup/assign.php` - No controller method (may be dead code)

### Priority 2: Academic Management (7 files)

9. ❌ `/admin/batchsubject/batchsubjectList.php` - Batch subject list (architectural mismatch, TBD)
10. ❌ `/admin/batchsubject/batchsubjectEdit.php` - Batch subject edit (architectural mismatch, TBD)
11. ✅ `/admin/lessonplan/copylesson.php` - COMPLETED (controller + view)
12. ✅ `/admin/question/question.php` - COMPLETED (controller + view)
13. ✅ `/admin/question/_addform.php` - COMPLETED
14. ✅ `/admin/question/_editform.php` - COMPLETED
15. 🔶 `/admin/syllabus/index.php` - BLOCKED: Requires Timetable model TVET refactoring (subjecttimetable_model->getSyllabussubject uses class_sections)

### Priority 3: Administrative Pages (5 files)

16. ✅ `/admin/resume/index.php` - COMPLETED (controller + view)
17. ✅ `/admin/resume/download.php` - COMPLETED (controller + view)
18. ✅ `/admin/member/studentSearch.php` - COMPLETED (controller + view)
19. ✅ `/admin/feesforward/index.php` - COMPLETED (controller + view)
20. ✅ `/admin/pickuppoint/student_fees.php` - COMPLETED (controller + view)

### Priority 4: Auxiliary Pages (3 files)

21. ❌ `/admin/route/studentroutedetails.php` - Student route details
22. ❌ `/admin/staffattendance/staffattendancelist.php` - Staff attendance (may not need TVET changes)

---

## Controller Methods Needing Updates

### Pattern to Find:
```php
$class = $this->class_model->get();  // OLD
$classlist = $this->classmodel_model->getClassesBySession($session_id);  // NEW
```

### Pattern to Replace:
```php
// Remove section_id validation
$this->form_validation->set_rules('section_id', ...);  // DELETE THIS

// Remove section_id from method calls
->searchMethod($class_id, $section_id);  // OLD
->searchMethod($class_id, null);  // NEW or just $class_id
```

---

## View Updates Required

### Pattern 1: Replace Class + Section Dropdowns

**OLD:**
```html
<div class="col-md-6">
    <select name="class_id">...</select>
</div>
<div class="col-md-6">
    <select name="section_id">...</select>
</div>
```

**NEW:**
```html
<div class="col-md-6">
    <?php
    $this->load->view('admin/_partials/class_selector', [
        'selected_class_id' => set_value('class_id'),
        'classlist' => $classlist
    ]);
    ?>
</div>
```

### Pattern 2: Remove Legacy JavaScript

**DELETE:**
```javascript
function getSectionByClass(class_id, section_id) {
    // ... AJAX call to load sections
}

$(document).on('change', '#class_id', function() {
    var class_id = $(this).val();
    getSectionByClass(class_id, 0);
});
```

---

## Model Updates Needed

### searchExamStudents Pattern

**File:** `Examgroupstudent_model.php`

**OLD:**
```php
public function searchExamStudents($exam_group_id, $exam_id, $class_id, $section_id, $session_id)
{
    ->where('class_sections.class_id', $class_id)
    ->where('class_sections.section_id', $section_id)
}
```

**NEW:**
```php
public function searchExamStudents($exam_group_id, $exam_id, $class_id, $section_id = null, $session_id)
{
    ->where('class.id', $class_id)  // Use TVET class table
    // Remove section_id where clause
}
```

---

## Testing Checklist for Each Page

Before marking a page as complete:

- [ ] Controller uses `classmodel_model->getClassesBySession()`
- [ ] No `section_id` in form validation rules
- [ ] View uses `class_selector` component
- [ ] No section dropdown in HTML
- [ ] No `getSectionByClass()` JavaScript function
- [ ] Div tags balanced (check with grep)
- [ ] AdminLTE box containers present
- [ ] Page loads without errors
- [ ] Form submission works
- [ ] Data displays correctly

---

## Systematic Fix Approach

### Step 1: Controller Fix
```php
// In index() or relevant method:

// OLD:
$class = $this->class_model->get();
$data['classlist'] = $class;
$this->form_validation->set_rules('section_id', ...);
$section_id = $this->input->post('section_id');

// NEW:
$session_id = $this->setting_model->getCurrentSession();
$classlist = $this->classmodel_model->getClassesBySession($session_id);
$data['classlist'] = $classlist;
// Remove section_id validation
// Remove section_id post retrieval
```

### Step 2: View Fix
```php
// Replace dual dropdowns with class_selector:
<?php
$this->load->view('admin/_partials/class_selector', [
    'selected_class_id' => set_value('class_id'),
    'classlist' => $classlist
]);
?>
```

### Step 3: JavaScript Fix
```javascript
// Remove entire getSectionByClass function
// Remove class_id change handler that loads sections
// Keep only essential page-specific JavaScript
```

### Step 4: Model Fix (if needed)
```php
// Update methods to accept section_id = null
// Use TVET tables (class, enrolment) instead of legacy (class_sections, student_session)
```

---

## Progress Tracking

| Category | Total | Fixed | Remaining | Progress |
|----------|-------|-------|-----------|----------|
| User-Facing Pages | 8 | 7 | 1 | 88% |
| Academic Mgmt | 7 | 4 | 3 | 57% |
| Administrative | 5 | 5 | 0 | 100% |
| Auxiliary | 3 | 0 | 3 | 0% |
| **TOTAL VIEWS** | **23** | **16** | **7** | **70%** |
| Controllers | ~50 | ~18 | ~32 | 36% |
| Models | ~10 | ~3 | ~7 | 30% |

---

## Completed Pages

1. ✅ Approve Leave - Controller, View, Model
2. ✅ Attendance - Controller, View, enrolment tracking
3. ✅ Exam Result Index - Controller, View
4. ✅ Exam Schedule - Controller, View
5. ✅ Rank Report - View (JavaScript)
6. ✅ Admitcard - Controller, View
7. ✅ Marksheet - View (JavaScript)
8. ✅ Question Bank Main Page - Controller (7 methods), View
9. ✅ Examgroup Exam Page - Controller, View
10. ✅ Examgroup Add Mark - Controller, View
11. ✅ Examgroup Assign - Controller, View
12. ✅ Examgroup Add Exam - View (complex with multiple modals)
13. ✅ Mark List - View (controller already updated)
14. ✅ Question Add Form - View (_addform.php)
15. ✅ Question Edit Form - View (_editform.php)
16. ✅ Lessonplan Copy - View, JavaScript handlers
17. ✅ Resume Index - Controller, View
18. ✅ Resume Download - Controller, View
19. ✅ Member Student Search - Controller, View
20. ✅ Fees Forward - Controller, View
21. ✅ Pickup Point Student Fees - Controller, View

---

## Next Steps

### Recommended Order:

1. **Exam Group Pages** (Priority 1)
   - addexam.php
   - addmark.php
   - assign.php
   - exam.php
   
2. **Mark & Subject Group** (Priority 1)
   - markList.php
   - subjectgroup/assign.php

3. **Batch Subject** (Priority 2)
   - batchsubjectList.php
   - batchsubjectEdit.php

4. **Question Bank** (Priority 2)
   - Complete controller updates
   - Fix _addform.php and _editform.php

5. **Administrative Pages** (Priority 3)
   - Resume pages
   - Member search
   - Fees forward
   - Pickup point

---

## Automation Opportunity

Consider creating a script to:
1. Find all files with `name="section_id"`
2. Check corresponding controllers for `section_id` validation
3. Generate a report of exact line numbers to change
4. Create a batch replacement script for common patterns

---

## Estimated Effort

- **Remaining Views:** 20 files × 30 min = 10 hours
- **Remaining Controllers:** 43 methods × 15 min = 11 hours
- **Remaining Models:** 7 models × 30 min = 3.5 hours
- **Testing:** 20 pages × 15 min = 5 hours

**Total Estimated:** ~30 hours of focused work

---

## Risk Assessment

**High Risk Areas:**
- Exam group pages (affect assessment workflow)
- Mark entry (affects grading system)
- Batch subject (affects curriculum structure)

**Low Risk Areas:**
- Resume download
- Member search
- Transport/hostel pages

**Recommendation:** Fix high-risk pages first with comprehensive testing.

---

## Documentation Needed

After all fixes complete:
- TVET_MIGRATION_COMPLETE.md - Final summary
- DEVELOPER_GUIDE_TVET.md - How to work with new structure
- Update CLAUDE.md with TVET patterns
