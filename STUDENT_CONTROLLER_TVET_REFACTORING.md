# Student Controller - TVET Refactoring Guide

## Overview

The Student controller (2700 lines) is the **most critical** controller for TVET transformation. It handles student admission, enrollment, and management.

**Current Issues:**
- Uses `class_id + section_id` for enrollment
- Creates single `student_session` record per student
- No support for programme/qualification/level selection
- No support for multiple class enrollment (Core/Elective)

**TVET Requirements:**
- Remove `section_id` completely
- Add programme/qualification/level selection
- Support multiple class enrollment
- Create `student_programme` (main programme)
- Create multiple `enrolment` records (one per class)

---

## Critical Methods to Refactor

### 1. create() - Student Admission (Lines 405-920)

#### CURRENT FLOW (Legacy)
```php
// 1. Validate class_id + section_id
$this->form_validation->set_rules('class_id', 'Class', 'required');
$this->form_validation->set_rules('section_id', 'Section', 'required');

// 2. Get class_id and section_id from POST
$class_id = $this->input->post('class_id');
$section_id = $this->input->post('section_id');

// 3. Insert student
$insert_id = $this->student_model->add($data_insert);

// 4. Create SINGLE student_session record
$data_new = array(
    'student_id' => $insert_id,
    'class_id' => $class_id,
    'section_id' => $section_id,
    'session_id' => $session,
    'fees_discount' => $fees_discount,
    'route_pickup_point_id' => $route_pickup_point_id,
    'vehroute_id' => $vehroute_id,
);
$student_session_id = $this->student_model->add_student_session($data_new);

// 5. Assign fees to student_session
$this->studentfeemaster_model->assign_bulk_fees($fee_group_id, $student_session_id);
```

#### NEW FLOW (TVET)
```php
// 1. Validate programme and class selection
$this->form_validation->set_rules('programme_id', 'Programme', 'required');
$this->form_validation->set_rules('qualification_id', 'Qualification', 'required');
$this->form_validation->set_rules('level_id', 'Level', 'required');
$this->form_validation->set_rules('class_ids[]', 'Classes', 'required');

// 2. Get TVET data from POST
$programme_id = $this->input->post('programme_id');
$qualification_id = $this->input->post('qualification_id');
$level_id = $this->input->post('level_id');
$class_ids = $this->input->post('class_ids'); // MULTIPLE classes
$enrolment_types = $this->input->post('enrolment_types'); // Core/Elective per class

// 3. Insert student (same as before)
$insert_id = $this->student_model->add($data_insert);

// 4. Create student_programme record (MAIN programme)
$programme_data = array(
    'student_id' => $insert_id,
    'programme_id' => $programme_id,
    'qualification_id' => $qualification_id,
    'current_level_id' => $level_id,
    'session_id' => $session,
    'registration_date' => date('Y-m-d'),
    'status' => 'Active',
    'is_active' => 1
);
$student_programme_id = $this->studentprogramme_model->add($programme_data);

// 5. Create MULTIPLE enrolment records (one per class)
foreach ($class_ids as $index => $class_id) {
    $enrolment_data = array(
        'student_id' => $insert_id,
        'class_id' => $class_id,
        'session_id' => $session,
        'enrolment_date' => date('Y-m-d'),
        'enrolment_type' => isset($enrolment_types[$index]) ? $enrolment_types[$index] : 'Core',
        'status' => 'Active',
        'hostel_room_id' => $hostel_room_id,
        'vehroute_id' => $vehroute_id,
        'route_pickup_point_id' => $route_pickup_point_id,
        'transport_fees' => null,
        'fees_discount' => $fees_discount,
        'is_active' => 1
    );

    $result = $this->enrolment_model->enrollStudent($enrolment_data);

    if ($result['success']) {
        $enrolment_id = $result['enrolment_id'];

        // 6. Assign fees to THIS enrolment
        if ($fee_session_group_id) {
            $this->studentfeemaster_model->assign_bulk_fees($fee_group_id, $enrolment_id);
        }

        // 7. Assign fees discount to THIS enrolment
        if (!empty($discount_id)) {
            foreach ($discount_id as $discount) {
                $discount_array = array(
                    'enrolment_id' => $enrolment_id,
                    'fees_discount_id' => $discount
                );
                $this->feediscount_model->allotdiscount($discount_array);
            }
        }
    }
}

// 8. Assign transport fees (if needed)
if (!empty($transport_feemaster_id)) {
    // Transport fees are typically per student, not per class
    // Link to first enrolment or student directly
}
```

---

## Key Differences

### OLD (Legacy)
| Aspect | Legacy Approach |
|--------|----------------|
| Selection | Single class + section |
| Enrollment | One `student_session` per student |
| Programme | No programme tracking |
| Classes | Student in ONE class only |
| Fees | Assigned to `student_session` |

### NEW (TVET)
| Aspect | TVET Approach |
|--------|---------------|
| Selection | Programme + Qualification + Level + Multiple Classes |
| Enrollment | One `student_programme` + Multiple `enrolments` |
| Programme | Full programme tracking (NATED, NCV, etc.) |
| Classes | Student in MULTIPLE classes (Core + Electives) |
| Fees | Assigned to each `enrolment` separately |

---

## Form Changes Required

### Legacy Form Fields
```html
<!-- OLD: Class + Section dropdowns -->
<select name="class_id" required>
    <option value="">Select Class</option>
    <!-- Classes list -->
</select>

<select name="section_id" required>
    <option value="">Select Section</option>
    <!-- Sections for selected class -->
</select>
```

### TVET Form Fields
```html
<!-- NEW: Programme → Qualification → Level → Classes -->

<!-- 1. Programme Selection -->
<select name="programme_id" id="programme_id" required>
    <option value="">Select Programme</option>
    <?php foreach ($programmes as $prog): ?>
        <option value="<?= $prog->id ?>"><?= $prog->name ?></option>
    <?php endforeach; ?>
</select>

<!-- 2. Qualification Selection (filtered by programme) -->
<select name="qualification_id" id="qualification_id" required>
    <option value="">Select Qualification</option>
    <!-- Ajax loaded based on programme -->
</select>

<!-- 3. Level Selection -->
<select name="level_id" id="level_id" required>
    <option value="">Select Level</option>
    <?php foreach ($levels as $level): ?>
        <option value="<?= $level->id ?>"><?= $level->name ?></option>
    <?php endforeach; ?>
</select>

<!-- 4. MULTIPLE Class Selection with Enrolment Type -->
<div id="class_selection">
    <h4>Select Classes to Enroll</h4>
    <table class="table">
        <thead>
            <tr>
                <th>Select</th>
                <th>Class Code</th>
                <th>Subject</th>
                <th>Level</th>
                <th>Cohort</th>
                <th>Lecturer</th>
                <th>Enrolment Type</th>
            </tr>
        </thead>
        <tbody id="available_classes">
            <!-- Ajax loaded classes based on programme/level -->
            <?php foreach ($available_classes as $class): ?>
            <tr>
                <td>
                    <input type="checkbox" name="class_ids[]" value="<?= $class->id ?>">
                </td>
                <td><?= $class->class_code ?></td>
                <td><?= $class->subject_name ?></td>
                <td><?= $class->level_name ?></td>
                <td><?= $class->cohort_name ?></td>
                <td><?= $class->lecturer_name ?></td>
                <td>
                    <select name="enrolment_types[]">
                        <option value="Core" selected>Core</option>
                        <option value="Elective">Elective</option>
                    </select>
                </td>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</div>
```

---

## JavaScript Changes

### Add Cascading Dropdowns
```javascript
$(document).ready(function() {
    // When programme changes, load qualifications
    $('#programme_id').change(function() {
        var programme_id = $(this).val();
        if (programme_id) {
            $.ajax({
                url: baseurl + 'admin/student/getQualificationsByProgramme',
                type: 'POST',
                data: {programme_id: programme_id},
                success: function(response) {
                    $('#qualification_id').html(response);
                }
            });
        }
    });

    // When level changes, load available classes
    $('#level_id').change(function() {
        var level_id = $(this).val();
        var programme_id = $('#programme_id').val();

        if (level_id && programme_id) {
            $.ajax({
                url: baseurl + 'admin/student/getClassesByProgrammeLevel',
                type: 'POST',
                data: {
                    programme_id: programme_id,
                    level_id: level_id,
                    session_id: current_session_id
                },
                success: function(response) {
                    $('#available_classes').html(response);
                }
            });
        }
    });
});
```

---

## New Controller Methods Needed

### 1. getQualificationsByProgramme()
```php
public function getQualificationsByProgramme()
{
    $programme_id = $this->input->post('programme_id');
    $qualifications = $this->qualification_model->getByProgramme($programme_id);

    $html = '<option value="">Select Qualification</option>';
    foreach ($qualifications as $qual) {
        $html .= '<option value="' . $qual->id . '">' . $qual->name . '</option>';
    }

    echo $html;
}
```

### 2. getClassesByProgrammeLevel()
```php
public function getClassesByProgrammeLevel()
{
    $programme_id = $this->input->post('programme_id');
    $level_id = $this->input->post('level_id');
    $session_id = $this->input->post('session_id');

    $filters = array(
        'programme_id' => $programme_id,
        'level_id' => $level_id,
        'status' => 'Active'
    );

    $classes = $this->classmodel_model->getClassesBySession($session_id, $filters);

    if (empty($classes)) {
        echo '<tr><td colspan="7">No classes available for this programme and level</td></tr>';
        return;
    }

    foreach ($classes as $class) {
        echo '<tr>';
        echo '<td><input type="checkbox" name="class_ids[]" value="' . $class->id . '"></td>';
        echo '<td>' . $class->class_code . '</td>';
        echo '<td>' . $class->subject_name . '</td>';
        echo '<td>' . $class->level_name . '</td>';
        echo '<td>' . $class->cohort_name . '</td>';
        echo '<td>' . ($class->lecturer_name ? $class->lecturer_name : 'TBA') . '</td>';
        echo '<td>';
        echo '<select name="enrolment_types[]" class="form-control">';
        echo '<option value="Core" selected>Core</option>';
        echo '<option value="Elective">Elective</option>';
        echo '</select>';
        echo '</td>';
        echo '</tr>';
    }
}
```

---

## Database Changes in create()

### BEFORE (Legacy)
```php
// Lines 768-777 in original
$data_new = array(
    'student_id' => $insert_id,
    'class_id' => $class_id,              // SINGLE class
    'section_id' => $section_id,          // Section (REMOVE)
    'session_id' => $session,
    'fees_discount' => $fees_discount,
    'route_pickup_point_id' => $route_pickup_point_id,
    'vehroute_id' => $vehroute_id,
);
$student_session_id = $this->student_model->add_student_session($data_new);

// Assign fees to student_session
$this->studentfeemaster_model->assign_bulk_fees($fee_group_id, $student_session_id);
```

### AFTER (TVET)
```php
// Step 1: Create student_programme
$programme_data = array(
    'student_id' => $insert_id,
    'programme_id' => $this->input->post('programme_id'),
    'qualification_id' => $this->input->post('qualification_id'),
    'current_level_id' => $this->input->post('level_id'),
    'session_id' => $session,
    'registration_date' => date('Y-m-d'),
    'status' => 'Active',
    'is_active' => 1
);
$this->studentprogramme_model->add($programme_data);

// Step 2: Create enrolments for each selected class
$class_ids = $this->input->post('class_ids');
$enrolment_types = $this->input->post('enrolment_types');

foreach ($class_ids as $index => $class_id) {
    $enrolment_data = array(
        'student_id' => $insert_id,
        'class_id' => $class_id,           // MULTIPLE classes possible
        'session_id' => $session,
        'enrolment_date' => date('Y-m-d'),
        'enrolment_type' => $enrolment_types[$index],
        'status' => 'Active',
        'hostel_room_id' => $hostel_room_id,
        'vehroute_id' => $vehroute_id,
        'route_pickup_point_id' => $route_pickup_point_id,
        'fees_discount' => $fees_discount,
        'is_active' => 1
    );

    $result = $this->enrolment_model->enrollStudent($enrolment_data);

    if ($result['success']) {
        $enrolment_id = $result['enrolment_id'];

        // Assign fees to THIS specific enrolment
        if ($fee_session_group_id) {
            $this->studentfeemaster_model->assign_bulk_fees($fee_group_id, $enrolment_id);
        }
    }
}
```

---

## Other Methods to Update

### 2. edit() Method (Lines 1374+)
Similar changes as create():
- Remove section_id validation
- Allow adding/removing class enrolments
- Update student_programme if programme changes
- Show current enrolments with ability to drop/add

### 3. getByClassAndSection() → getByClass()
```php
// OLD
public function getByClassAndSection()
{
    $class_id = $this->input->post('class_id');
    $section_id = $this->input->post('section_id');

    $students = $this->student_model->getStudentByClassSection($class_id, $section_id);
    echo json_encode($students);
}

// NEW
public function getByClass()
{
    $class_id = $this->input->post('class_id');

    // Get students via enrolment
    $students = $this->classmodel_model->getClassStudents($class_id);
    echo json_encode($students);
}
```

### 4. search() Method
Update to filter by programme/qualification/level instead of class/section:
```php
public function search()
{
    // Add programme/qualification/level filters
    $filters = array(
        'programme_id' => $this->input->post('programme_id'),
        'qualification_id' => $this->input->post('qualification_id'),
        'level_id' => $this->input->post('level_id'),
    );

    // Search students by programme
    $students = $this->studentprogramme_model->getBySession($session_id, $filters);
}
```

---

## Testing Checklist

### Student Admission
- [ ] Load student create page
- [ ] Select programme (NATED/NCV)
- [ ] Select qualification (cascading load)
- [ ] Select level (N4, N5, etc.)
- [ ] Available classes load based on programme+level
- [ ] Select multiple classes
- [ ] Set enrolment type (Core/Elective) for each
- [ ] Submit form
- [ ] Verify student created
- [ ] Verify student_programme record created
- [ ] Verify multiple enrolment records created
- [ ] Verify fees assigned to each enrolment

### Student Editing
- [ ] Load student edit page
- [ ] See current programme and enrolments
- [ ] Can add new class enrolments
- [ ] Can drop existing enrolments
- [ ] Can change enrolment type
- [ ] Save changes
- [ ] Verify enrolments updated

### Student Search
- [ ] Filter by programme
- [ ] Filter by qualification
- [ ] Filter by level
- [ ] See enrolment count per student
- [ ] Export works correctly

---

## Migration Strategy

Given the complexity (2700 lines), recommend:

### Option 1: Gradual Migration (Recommended)
1. Keep legacy create() as createLegacy()
2. Create new createTVET() method
3. Add toggle in UI to use new/old
4. Test thoroughly
5. Switch all users to TVET
6. Remove legacy method

### Option 2: Feature Flag
```php
if ($this->sch_setting_detail->use_tvet_enrollment) {
    // TVET logic
} else {
    // Legacy logic
}
```

### Option 3: Complete Rewrite (Risky)
- Backup controller
- Rewrite entirely for TVET
- Extensive testing required

---

## Next Steps

1. **Create backup:**
   ```bash
   cp controllers/Student.php controllers/Student_legacy_backup.php
   ```

2. **Add new controller methods:**
   - getQualificationsByProgramme()
   - getClassesByProgrammeLevel()
   - createTVET() (new admission flow)

3. **Update views:**
   - Create studentCreateTVET.php view
   - Add programme/qualification/level dropdowns
   - Add multi-class selection table

4. **Test admission flow:**
   - Create test student
   - Verify all database records
   - Test fee assignment

5. **Gradually migrate other methods**

---

## Estimated Effort

**Student Controller Refactoring:**
- create() method: 8-12 hours
- edit() method: 6-8 hours
- search() method: 4-6 hours
- Other methods: 10-15 hours
- Testing: 8-12 hours
- **Total: 36-53 hours (5-7 days)**

**Complexity:** ⚠️⚠️⚠️ HIGH (most complex controller)

This controller should be done carefully with extensive testing before deployment.
