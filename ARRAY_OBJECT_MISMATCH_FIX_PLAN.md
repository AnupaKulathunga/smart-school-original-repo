# Array/Object Mismatch - Comprehensive Fix Plan

**Date:** 2026-02-04
**Issue:** Controllers return TVET class objects from `getClassesBySession()`, but views use array syntax `$class['id']`
**Result:** Empty dropdowns or PHP fatal errors (HTTP 500)

---

## Root Cause

After migrating to TVET structure:
- **Controllers** call: `$this->classmodel_model->getClassesBySession($session_id)`
- **Returns:** Array of objects with properties: `$class->id`, `$class->subject_name`, etc.
- **Views** expect: Array of arrays with keys: `$class['id']`, `$class['class']`, etc.
- **Mismatch:** Cannot access object properties with array notation

---

## Files Requiring Fixes

### Phase 1: High Priority - User-Facing Pages (21 files)

1. ✅ **approve_leave/index.php** - FIXED
2. ✅ **stuattendence/attendencereport.php** - FIXED
3. ❌ **question/question.php** - Array syntax found
4. ❌ **examgroup/examresult.php** - Array syntax found
5. ❌ **examresult/marksheet.php** - Array syntax found
6. ❌ **examresult/rankreport.php** - Array syntax found
7. ❌ **exam_schedule/examList.php** - Array syntax found
8. ❌ **teacher/assignTeacher.php** - Array syntax found
9. ❌ **teacher/viewassignTeacher.php** - Array syntax found
10. ❌ **timetable/timetableList.php** - Array syntax found
11. ❌ **subjectgroup/assign.php** - Array syntax found
12. ❌ **subjectgroup/subjectgroupEdit.php** - Array syntax found
13. ❌ **subjectgroup/subjectgroupList.php** - Array syntax found
14. ❌ **video_tutorial/index.php** - Array syntax found
15. ❌ **mailsms/compose.php** - Array syntax found
16. ❌ **mailsms/compose_sms.php** - Array syntax found
17. ❌ **mailsms/schedule/email/edit_email_class.php** - Array syntax found
18. ❌ **mailsms/schedule/sms/edit_sms_class.php** - Array syntax found
19. ❌ **hostelroom/studenthosteldetails.php** - Array syntax found
20. ❌ **alumni/alumnilist.php** - Array syntax found
21. ❌ **alumni/events.php** - Array syntax found

### Phase 2: Check Controllers Using Old class_model

Controllers still using `$this->class_model->get()` instead of `getClassesBySession()`:

```bash
grep -rn "class_model->get()" smart_school_src/application/controllers/admin/ | wc -l
# Found: Multiple instances
```

**Example:** `Onlineexam.php` line 313 in `evalution()` method

---

## Fix Pattern

### Pattern 1: Simple Dropdown (Use class_selector component)

**BEFORE:**
```php
<select name="class_id" id="class_id" class="form-control">
    <option value="">Select</option>
    <?php foreach ($classlist as $class) { ?>
        <option value="<?php echo $class['id']; ?>">
            <?php echo $class['class']; ?>
        </option>
    <?php } ?>
</select>
```

**AFTER:**
```php
<?php
$this->load->view('admin/_partials/class_selector', [
    'selected_class_id' => set_value('class_id'),
    'classlist' => $classlist
]);
?>
```

### Pattern 2: Custom Iteration (Use object syntax)

**BEFORE:**
```php
<?php foreach ($classlist as $class) { ?>
    <option value="<?php echo $class['id']; ?>">
        <?php echo $class['class']; ?>
    </option>
<?php } ?>
```

**AFTER:**
```php
<?php foreach ($classlist as $class) { ?>
    <option value="<?php echo $class->id; ?>">
        <?php echo $class->subject_name . ' - ' . $class->level_name . ' (' . $class->cohort_name . ')'; ?>
    </option>
<?php } ?>
```

### Pattern 3: Controller Fix

**BEFORE:**
```php
$class = $this->class_model->get();
$data['classlist'] = $class;
```

**AFTER:**
```php
$session_id = $this->setting_model->getCurrentSession();
$classlist = $this->classmodel_model->getClassesBySession($session_id);
$data['classlist'] = $classlist;
```

---

## Automated Detection Script

```bash
#!/bin/bash
# Find all views with array syntax for class data

echo "=== Files with \$class['id'] or \$class['class'] ==="
find smart_school_src/application/views/admin -name "*.php" \
  -exec grep -l "\$class\['id'\]\|\$class\['class'\]" {} \;

echo ""
echo "=== Controllers still using class_model->get() ==="
grep -rn "class_model->get()" smart_school_src/application/controllers/admin/ \
  | grep -v "TVET:" | grep -v "getClassBy"
```

---

## Testing Checklist (Per Page)

Before marking complete:

- [ ] Controller uses `classmodel_model->getClassesBySession()`
- [ ] View uses `class_selector` component OR object syntax
- [ ] No `$class['id']` or `$class['class']` array access
- [ ] Page loads without 500 error
- [ ] Class dropdown shows options in format: "Subject - Level (Cohort)"
- [ ] Form submission works
- [ ] Data displays correctly

---

## Next Steps

1. **Prioritize user-facing pages** (question bank, exams, timetable)
2. **Fix controllers first** - Update `class_model->get()` to `getClassesBySession()`
3. **Fix views second** - Replace array syntax with object syntax or class_selector
4. **Test each page** - Load page, check dropdown, submit form
5. **Commit per page** - Individual commits for tracking

---

## Estimated Effort

- **21 views to fix** × 15 min = 5.25 hours
- **~10 controllers to fix** × 10 min = 1.7 hours
- **Testing** × 10 min = 3.5 hours
- **Total:** ~10-12 hours

---

## Currently Completed

1. ✅ Classmodel_model.php - Fixed SQL column conflict (class.id vs subject_level.id)
2. ✅ approve_leave/index.php - Modal + view + JavaScript
3. ✅ Stuattendence.php - Fixed wrong model call (session_model → setting_model)
4. ✅ stuattendence/attendencereport.php - View + JavaScript

**Status:** 2/21 views fixed (10% complete)
