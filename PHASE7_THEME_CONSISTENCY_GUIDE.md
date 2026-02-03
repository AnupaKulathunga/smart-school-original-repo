# Phase 7: Theme & UI Consistency Guide

## Overview

As we refactor controllers and views from legacy to TVET architecture, it's critical to maintain consistent theme, styling, and user experience across all pages.

**Purpose:** Ensure TVET-specific UI elements (programme selectors, class displays, enrolment badges) follow consistent design patterns.

---

## 🎨 Theme Standards

### Current Theme Framework
- **CSS Framework:** Bootstrap 3.x
- **Theme Location:** `backend/bootstrap/css/`
- **Custom CSS:** `backend/dist/css/`
- **Admin Theme:** `views/layout/header.php` and `footer.php`

### Color Palette (Maintain consistency)
```css
/* Primary Colors */
--primary-color: #424242;      /* Dark gray */
--secondary-color: #00c0ef;    /* Light blue */
--success-color: #00a65a;      /* Green */
--warning-color: #f39c12;      /* Orange */
--danger-color: #dd4b39;       /* Red */
--info-color: #00c0ef;         /* Blue */

/* TVET-Specific Colors (NEW) */
--core-enrolment: #00a65a;     /* Green for Core classes */
--elective-enrolment: #3c8dbc; /* Blue for Elective classes */
--programme-badge: #605ca8;    /* Purple for Programme */
--qualification-badge: #39cccc; /* Teal for Qualification */
--level-badge: #00a65a;        /* Green for Level */
```

---

## 📋 UI Components Standards

### 1. Programme/Qualification/Level Selector

**Standard Pattern (Use Everywhere):**
```html
<!-- Programme Selector -->
<div class="form-group">
    <label for="programme_id">
        <?php echo $this->lang->line('programme'); ?>
        <span class="req">*</span>
    </label>
    <select name="programme_id" id="programme_id" class="form-control" required>
        <option value=""><?php echo $this->lang->line('select_programme'); ?></option>
        <?php foreach ($programmes as $prog): ?>
            <option value="<?php echo $prog->id; ?>"
                data-type="<?php echo $prog->programme_type; ?>">
                <?php echo $prog->name; ?>
            </option>
        <?php endforeach; ?>
    </select>
</div>

<!-- Qualification Selector (Ajax loaded) -->
<div class="form-group">
    <label for="qualification_id">
        <?php echo $this->lang->line('qualification'); ?>
        <span class="req">*</span>
    </label>
    <select name="qualification_id" id="qualification_id" class="form-control" required>
        <option value=""><?php echo $this->lang->line('select_qualification'); ?></option>
    </select>
</div>

<!-- Level Selector -->
<div class="form-group">
    <label for="level_id">
        <?php echo $this->lang->line('level'); ?>
        <span class="req">*</span>
    </label>
    <select name="level_id" id="level_id" class="form-control" required>
        <option value=""><?php echo $this->lang->line('select_level'); ?></option>
        <?php foreach ($levels as $level): ?>
            <option value="<?php echo $level->id; ?>"
                data-type="<?php echo $level->level_type; ?>"
                data-nqf="<?php echo $level->nqf_level; ?>">
                <?php echo $level->name; ?>
            </option>
        <?php endforeach; ?>
    </select>
</div>
```

**CSS Styling:**
```css
/* Standard form group spacing */
.form-group {
    margin-bottom: 15px;
}

/* Required field indicator */
.req {
    color: #dd4b39;
    font-weight: bold;
}

/* Select dropdowns */
.form-control {
    border-radius: 4px;
    border: 1px solid #d2d6de;
    font-size: 14px;
}

/* Cascading dropdown loading state */
.form-control:disabled {
    background-color: #f4f4f4;
    cursor: not-allowed;
}
```

---

### 2. Class Display Format

**Standard Pattern (Consistent Everywhere):**

#### A. Class Code Display
```html
<!-- In tables/lists -->
<td class="class-code">
    <strong><?php echo $class->class_code; ?></strong>
    <br>
    <small class="text-muted">
        <?php echo $class->subject_name; ?> - <?php echo $class->level_name; ?>
    </small>
</td>
```

#### B. Class Details Card
```html
<div class="class-details-box">
    <div class="row">
        <div class="col-md-3">
            <label>Class Code:</label>
            <p class="class-code"><?php echo $class->class_code; ?></p>
        </div>
        <div class="col-md-3">
            <label>Subject:</label>
            <p><?php echo $class->subject_name; ?></p>
        </div>
        <div class="col-md-3">
            <label>Level:</label>
            <p>
                <span class="badge bg-green">
                    <?php echo $class->level_name; ?>
                </span>
            </p>
        </div>
        <div class="col-md-3">
            <label>Cohort:</label>
            <p><?php echo $class->cohort_name; ?></p>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <label>Lecturer:</label>
            <p><?php echo $class->lecturer_name ? $class->lecturer_name : 'TBA'; ?></p>
        </div>
        <div class="col-md-6">
            <label>Students:</label>
            <p><?php echo $class->student_count; ?> / <?php echo $class->max_students; ?></p>
        </div>
    </div>
</div>
```

**CSS:**
```css
.class-details-box {
    background: #f9f9f9;
    border: 1px solid #e0e0e0;
    border-radius: 4px;
    padding: 15px;
    margin-bottom: 15px;
}

.class-details-box label {
    font-weight: 600;
    color: #666;
    margin-bottom: 5px;
    display: block;
}

.class-code {
    font-family: 'Courier New', monospace;
    font-size: 13px;
    font-weight: bold;
    color: #333;
}
```

---

### 3. Enrolment Type Badges

**Standard Pattern:**
```html
<!-- Core Enrolment -->
<span class="badge badge-enrolment-core">
    <?php echo $this->lang->line('core'); ?>
</span>

<!-- Elective Enrolment -->
<span class="badge badge-enrolment-elective">
    <?php echo $this->lang->line('elective'); ?>
</span>

<!-- Dynamic based on enrolment_type -->
<span class="badge badge-enrolment-<?php echo strtolower($enrolment->enrolment_type); ?>">
    <?php echo $enrolment->enrolment_type; ?>
</span>
```

**CSS:**
```css
/* Base badge styling */
.badge {
    display: inline-block;
    padding: 3px 8px;
    font-size: 11px;
    font-weight: bold;
    text-transform: uppercase;
    border-radius: 3px;
}

/* Core enrolment badge - Green */
.badge-enrolment-core {
    background-color: #00a65a;
    color: #fff;
}

/* Elective enrolment badge - Blue */
.badge-enrolment-elective {
    background-color: #3c8dbc;
    color: #fff;
}

/* Programme badge - Purple */
.badge-programme {
    background-color: #605ca8;
    color: #fff;
}

/* Qualification badge - Teal */
.badge-qualification {
    background-color: #39cccc;
    color: #fff;
}

/* Level badge - Green */
.badge-level {
    background-color: #00a65a;
    color: #fff;
}

/* Status badges */
.badge-status-active {
    background-color: #00a65a;
    color: #fff;
}

.badge-status-completed {
    background-color: #3c8dbc;
    color: #fff;
}

.badge-status-dropped {
    background-color: #dd4b39;
    color: #fff;
}
```

---

### 4. Student Enrolment Table

**Standard Pattern:**
```html
<table class="table table-striped table-bordered table-hover">
    <thead>
        <tr>
            <th>Admission No</th>
            <th>Student Name</th>
            <th>Class</th>
            <th>Enrolment Type</th>
            <th>Enrolment Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($enrolments as $enrol): ?>
        <tr>
            <td><?php echo $enrol->admission_no; ?></td>
            <td>
                <strong><?php echo $enrol->firstname . ' ' . $enrol->lastname; ?></strong>
                <br>
                <small class="text-muted"><?php echo $enrol->programme_name; ?></small>
            </td>
            <td>
                <span class="class-code"><?php echo $enrol->class_code; ?></span>
                <br>
                <small><?php echo $enrol->subject_name; ?></small>
            </td>
            <td>
                <span class="badge badge-enrolment-<?php echo strtolower($enrol->enrolment_type); ?>">
                    <?php echo $enrol->enrolment_type; ?>
                </span>
            </td>
            <td><?php echo date('d M Y', strtotime($enrol->enrolment_date)); ?></td>
            <td>
                <span class="badge badge-status-<?php echo strtolower($enrol->status); ?>">
                    <?php echo $enrol->status; ?>
                </span>
            </td>
            <td>
                <button class="btn btn-sm btn-primary" onclick="viewEnrolment(<?php echo $enrol->id; ?>)">
                    <i class="fa fa-eye"></i>
                </button>
                <button class="btn btn-sm btn-warning" onclick="editEnrolment(<?php echo $enrol->id; ?>)">
                    <i class="fa fa-edit"></i>
                </button>
            </td>
        </tr>
        <?php endforeach; ?>
    </tbody>
</table>
```

**CSS:**
```css
/* Table styling */
.table-striped > tbody > tr:nth-of-type(odd) {
    background-color: #f9f9f9;
}

.table-hover > tbody > tr:hover {
    background-color: #f5f5f5;
}

/* Small buttons in tables */
.btn-sm {
    padding: 3px 8px;
    font-size: 12px;
}

/* Action buttons spacing */
.btn + .btn {
    margin-left: 3px;
}
```

---

### 5. Multi-Class Selection Interface

**Standard Pattern:**
```html
<div class="box box-primary">
    <div class="box-header with-border">
        <h3 class="box-title">Select Classes to Enroll</h3>
        <div class="box-tools pull-right">
            <span class="badge bg-blue" id="selected-count">0 selected</span>
        </div>
    </div>
    <div class="box-body">
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th width="50">
                            <input type="checkbox" id="select-all-classes">
                        </th>
                        <th>Class Code</th>
                        <th>Subject</th>
                        <th>Level</th>
                        <th>Cohort</th>
                        <th>Lecturer</th>
                        <th>Students</th>
                        <th>Enrolment Type</th>
                    </tr>
                </thead>
                <tbody id="available-classes">
                    <!-- Ajax loaded rows -->
                </tbody>
            </table>
        </div>
    </div>
    <div class="box-footer">
        <button type="submit" class="btn btn-primary btn-lg pull-right">
            <i class="fa fa-check"></i> Enroll in Selected Classes
        </button>
    </div>
</div>
```

**JavaScript:**
```javascript
// Update selected count when checkboxes change
$(document).on('change', '.class-checkbox', function() {
    var count = $('.class-checkbox:checked').length;
    $('#selected-count').text(count + ' selected');

    // Enable/disable enrolment type dropdown
    var $row = $(this).closest('tr');
    var $enrolmentType = $row.find('.enrolment-type');
    $enrolmentType.prop('disabled', !this.checked);
});

// Select all functionality
$('#select-all-classes').change(function() {
    $('.class-checkbox').prop('checked', this.checked).trigger('change');
});
```

---

## 🚨 Common Theme Violations to Avoid

### ❌ DON'T DO THIS:

#### 1. Inconsistent Badge Colors
```html
<!-- BAD: Random colors -->
<span style="background: red;">Core</span>
<span style="background: blue;">Elective</span>
```

#### 2. Inline Styles
```html
<!-- BAD: Inline styling -->
<div style="padding: 10px; border: 1px solid red;">
    Class info
</div>
```

#### 3. Inconsistent Class Display
```html
<!-- BAD: Different format in each view -->
<p>Math - N4 - Group A</p>
<p>MATH-N4-A-2026</p>
<p>Mathematics (N4)</p>
```

#### 4. Mixed Button Styles
```html
<!-- BAD: Inconsistent buttons -->
<button class="btn btn-success">Save</button>
<button class="btn-primary">Cancel</button>
<a href="#" style="background: blue;">Submit</a>
```

#### 5. No Responsive Design
```html
<!-- BAD: Fixed widths -->
<div style="width: 800px;">
    Table content
</div>
```

### ✅ DO THIS INSTEAD:

#### 1. Use Standard Badge Classes
```html
<!-- GOOD: Consistent classes -->
<span class="badge badge-enrolment-core">Core</span>
<span class="badge badge-enrolment-elective">Elective</span>
```

#### 2. Use CSS Classes
```html
<!-- GOOD: CSS classes -->
<div class="class-details-box">
    Class info
</div>
```

#### 3. Consistent Display Format
```html
<!-- GOOD: Standard format everywhere -->
<span class="class-code">MATH-N4-A-2026</span>
<br>
<small><?php echo $class->subject_name; ?> - <?php echo $class->level_name; ?></small>
```

#### 4. Standard Button Classes
```html
<!-- GOOD: Bootstrap classes -->
<button type="submit" class="btn btn-primary">Save</button>
<button type="button" class="btn btn-default">Cancel</button>
```

#### 5. Responsive Tables
```html
<!-- GOOD: Responsive wrapper -->
<div class="table-responsive">
    <table class="table table-bordered">
        ...
    </table>
</div>
```

---

## 📝 View File Standards

### Standard View Structure
```php
<?php
// Header
$this->load->view('layout/header', $data);
?>

<!-- Content Header -->
<div class="content-header">
    <h1>
        <?php echo $title; ?>
        <small><?php echo $subtitle; ?></small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="<?php echo base_url(); ?>admin/dashboard"><i class="fa fa-dashboard"></i> Dashboard</a></li>
        <li class="active"><?php echo $title; ?></li>
    </ol>
</div>

<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title"><?php echo $box_title; ?></h3>
                </div>

                <!-- Flash messages -->
                <?php if ($this->session->flashdata('msg')): ?>
                    <?php echo $this->session->flashdata('msg'); ?>
                <?php endif; ?>

                <form method="post" action="<?php echo site_url('admin/controller/method'); ?>">
                    <div class="box-body">
                        <!-- Form content -->
                    </div>
                    <div class="box-footer">
                        <button type="submit" class="btn btn-primary pull-right">
                            <i class="fa fa-check"></i> <?php echo $this->lang->line('save'); ?>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>

<?php
// Footer
$this->load->view('layout/footer', $data);
?>
```

---

## 🔍 Theme Consistency Checklist

Before marking any controller/view as complete, verify:

### Layout & Structure
- [ ] Uses standard header/footer views
- [ ] Has proper breadcrumb navigation
- [ ] Uses Bootstrap grid system (col-md-*, col-sm-*)
- [ ] Content wrapped in proper `<section class="content">` tags
- [ ] Box components use standard classes (box, box-primary, etc.)

### Forms
- [ ] Form groups use `.form-group` class
- [ ] Labels have proper `<label>` tags with `for` attribute
- [ ] Required fields marked with `<span class="req">*</span>`
- [ ] Input fields use `.form-control` class
- [ ] Buttons use Bootstrap button classes
- [ ] Form validation messages styled consistently

### TVET Components
- [ ] Programme/Qualification/Level selectors follow standard pattern
- [ ] Class codes use `.class-code` class and monospace font
- [ ] Enrolment type badges use standard colors (Green=Core, Blue=Elective)
- [ ] Status badges use standard colors
- [ ] Class details boxes use `.class-details-box` class

### Tables
- [ ] Tables use `.table` base class
- [ ] Striped tables use `.table-striped`
- [ ] Bordered tables use `.table-bordered`
- [ ] Hover effect uses `.table-hover`
- [ ] Responsive tables wrapped in `.table-responsive`
- [ ] Action buttons sized consistently (`.btn-sm`)

### JavaScript
- [ ] Uses existing jQuery (don't include duplicate libraries)
- [ ] No inline JavaScript in views (use separate JS files or footer scripts)
- [ ] AJAX calls use standard baseurl variable
- [ ] Loading states indicated with spinners or disabled buttons
- [ ] Error handling displays user-friendly messages

### Accessibility
- [ ] Form labels properly associated with inputs
- [ ] ARIA labels used where needed
- [ ] Keyboard navigation works
- [ ] Color contrast meets WCAG standards
- [ ] Error messages are clear and helpful

### Mobile Responsiveness
- [ ] Forms stack properly on mobile
- [ ] Tables scroll horizontally on small screens
- [ ] Buttons are touch-friendly size
- [ ] No horizontal scrolling on mobile viewports
- [ ] Text is readable without zooming

---

## 🛠️ Fixing Theme Violations

### Step 1: Identify Violations
Run through each updated view file and check against the checklist above.

### Step 2: Categorize Issues
- **Critical:** Broken layouts, inaccessible forms
- **High:** Inconsistent branding, poor UX
- **Medium:** Minor styling differences
- **Low:** Cosmetic improvements

### Step 3: Create Fix Tasks
Document each violation:
```
File: views/admin/student/create.php
Line: 245
Issue: Using inline style instead of CSS class
Severity: Medium
Fix: Replace style="..." with class="class-details-box"
```

### Step 4: Implement Fixes
Create a dedicated branch for theme fixes:
```bash
git checkout -b tvet/phase7-theme-consistency
```

### Step 5: Test Thoroughly
- Test on different browsers (Chrome, Firefox, Safari, Edge)
- Test on different screen sizes (desktop, tablet, mobile)
- Test with different data (empty states, full tables, long text)

---

## 📦 Reusable Component Library

### Create Shared Partial Views

**Location:** `views/admin/_partials/tvet/`

#### 1. Programme Selector
**File:** `views/admin/_partials/tvet/programme_selector.php`
```php
<div class="form-group">
    <label for="programme_id">
        <?php echo $this->lang->line('programme'); ?>
        <span class="req">*</span>
    </label>
    <select name="programme_id" id="programme_id" class="form-control" required>
        <option value=""><?php echo $this->lang->line('select_programme'); ?></option>
        <?php foreach ($programmes as $prog): ?>
            <option value="<?php echo $prog->id; ?>"><?php echo $prog->name; ?></option>
        <?php endforeach; ?>
    </select>
</div>
```

**Usage:**
```php
$data['programmes'] = $this->programme_model->get();
$this->load->view('admin/_partials/tvet/programme_selector', $data);
```

#### 2. Class Details Card
**File:** `views/admin/_partials/tvet/class_details_card.php`

#### 3. Enrolment Badge
**File:** `views/admin/_partials/tvet/enrolment_badge.php`

---

## 🎯 Success Criteria for Phase 7

Phase 7 is complete when:

- [ ] All TVET views follow standard patterns
- [ ] No inline styles in view files
- [ ] Consistent badge colors across all pages
- [ ] Responsive design works on mobile/tablet/desktop
- [ ] Reusable component library created
- [ ] Theme consistency checklist passes for all views
- [ ] Cross-browser testing complete
- [ ] Accessibility audit passed
- [ ] User acceptance testing complete
- [ ] Documentation updated with theme guidelines

---

## 📅 When to Execute Phase 7

**Timing:** After Phase 4 (View Layer) is substantially complete

**Approach:**
1. Complete Phase 4 (update views functionally)
2. Then do Phase 7 audit (fix theme consistency)
3. This prevents fixing the same view twice

**Estimated Effort:** 2-3 weeks
- Week 1: Audit all updated views
- Week 2: Implement fixes
- Week 3: Testing and refinement

---

## 🔗 Related Files

- **Theme CSS:** `backend/bootstrap/css/bootstrap.min.css`
- **Custom CSS:** `backend/dist/css/style.css`
- **Layout Header:** `views/layout/header.php`
- **Layout Footer:** `views/layout/footer.php`
- **AdminLTE Theme:** `backend/adminlte/` (if used)

---

**Last Updated:** 2026-02-03
**Next Review:** After Phase 4 completion
