<?php
$import_titles = array(
    'programmes' => 'Programmes',
    'subjects' => 'Subjects',
    'levels' => 'Levels',
    'subject_levels' => 'Subject-Level Mappings',
    'classes' => 'Classes',
    'enrolments' => 'Student Enrolments',
    'programme_enrolments' => 'Programme-Based Enrolments'
);

$import_instructions = array(
    'programmes' => array(
        'Your CSV file should contain programme data with columns: code, name, description, qualification_type, is_active',
        'The "code" and "name" fields are required. Other fields are optional.',
        'Qualification types can be: NATED, NCV, Skills, or any custom type.'
    ),
    'subjects' => array(
        'Your CSV file should contain subject data with columns: programme_code, code, name, description, credits, notional_hours, is_core, is_active',
        'The "programme_code", "code", and "name" fields are required.',
        'The programme_code must match an existing programme code in the system.'
    ),
    'levels' => array(
        'Your CSV file should contain level data with columns: code, name, level_type, nqf_level, programme_code, sequence, is_active',
        'The "code" and "name" fields are required.',
        'Level types can be: NATED, NCV, or any custom type. NQF levels should be numeric (1-10).'
    ),
    'subject_levels' => array(
        'Your CSV file should contain subject-level mapping data with columns: subject_code, level_code, syllabus_code, is_active',
        'The "subject_code" and "level_code" fields are required.',
        'Both subject_code and level_code must match existing records in the system.'
    ),
    'classes' => array(
        'Your CSV file should contain class data with columns: subject_code, level_code, cohort_name, academic_year, intake_period, delivery_mode, venue, max_students, start_date, end_date, lecturer_employee_id',
        'The "subject_code", "level_code", "cohort_name", and "academic_year" fields are required.',
        'The class code will be automatically generated from Subject-Level-Cohort-Year.'
    ),
    'enrolments' => array(
        'Your CSV file should contain enrolment data with columns: admission_no, class_code, enrolment_date, status, notes',
        'The "admission_no" and "class_code" fields are required.',
        'Status values can be: Enrolled, Withdrawn, Completed, or Suspended.'
    ),
    'programme_enrolments' => array(
        'This is the RECOMMENDED way to enrol students - it automatically enrols them in ALL classes for their programme/level/cohort.',
        'Required fields: admission_no, programme_code, level_code, cohort',
        'The system will find all classes matching the programme + level + cohort and enrol the student in each one.',
        'Example: Student in NATED/N4/Cohort A will be enrolled in Math N4-A, Engineering Science N4-A, etc.'
    )
);

$required_fields = array(
    'programmes' => array('code', 'name'),
    'subjects' => array('programme_code', 'code', 'name'),
    'levels' => array('code', 'name'),
    'subject_levels' => array('subject_code', 'level_code'),
    'classes' => array('subject_code', 'level_code', 'cohort_name', 'academic_year'),
    'enrolments' => array('admission_no', 'class_code'),
    'programme_enrolments' => array('admission_no', 'programme_code', 'level_code', 'cohort')
);

$sample_data = array(
    'programmes' => array('NATED', 'National Accredited Technical Education Diploma', 'Report 191 programmes', 'NATED', '1'),
    'subjects' => array('NATED', 'MATH', 'Mathematics', 'Mathematical principles', '20', '200', '1', '1'),
    'levels' => array('N4', 'N4 Level', 'NATED', '5', 'NATED', '4', '1'),
    'subject_levels' => array('MATH', 'N4', 'MATH-N4-2026', '1'),
    'classes' => array('MATH', 'N4', 'A', '2026', 'January', 'Full-time', 'Room 101', '35', '2026-01-15', '2026-06-30', 'EMP001'),
    'enrolments' => array('STU001', 'MATH-N4-A-2026', '2026-01-15', 'Enrolled', 'First semester'),
    'programme_enrolments' => array('STU001', 'NATED', 'N4', 'A', '2026-01-15', 'N4 Engineering student')
);
?>
<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-upload"></i> Import <?php echo isset($import_titles[$import_type]) ? $import_titles[$import_type] : ucfirst($import_type); ?>
        </h1>
        <ol class="breadcrumb">
            <li><a href="<?php echo site_url('admin/academic'); ?>"><i class="fa fa-graduation-cap"></i> Academic</a></li>
            <li><a href="<?php echo site_url('admin/academic/import'); ?>">Bulk Import</a></li>
            <li class="active">Import <?php echo isset($import_titles[$import_type]) ? $import_titles[$import_type] : ucfirst($import_type); ?></li>
        </ol>
    </section>
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">Import <?php echo isset($import_titles[$import_type]) ? $import_titles[$import_type] : ucfirst($import_type); ?></h3>
                        <div class="pull-right box-tools">
                            <a href="<?php echo site_url('admin/academic/download_sample/' . $import_type); ?>">
                                <button class="btn btn-primary btn-sm"><i class="fa fa-download"></i> Download Sample Import File</button>
                            </a>
                        </div>
                    </div>
                    <div class="box-body">
                        <?php if ($this->session->flashdata('msg')) { ?>
                        <div><?php echo $this->session->flashdata('msg'); ?></div>
                        <?php } ?>

                        <div class="callout callout-info">
                            <h4>Instructions</h4>
                            <?php if (isset($import_instructions[$import_type])) { ?>
                                <?php foreach ($import_instructions[$import_type] as $i => $instruction) { ?>
                                    <?php echo ($i + 1) . '. ' . $instruction; ?><br/>
                                <?php } ?>
                            <?php } ?>
                        </div>
                    </div>

                    <!-- Sample Data Table -->
                    <div class="box-body table-responsive">
                        <h4>Expected CSV Format:</h4>
                        <table class="table table-striped table-bordered table-hover" id="sampledata">
                            <thead>
                                <tr>
                                    <?php foreach ($fields as $field) {
                                        $is_required = isset($required_fields[$import_type]) && in_array($field, $required_fields[$import_type]);
                                    ?>
                                        <th>
                                            <?php echo ucwords(str_replace('_', ' ', $field)); ?>
                                            <?php if ($is_required) { ?><span class="text-red">*</span><?php } ?>
                                        </th>
                                    <?php } ?>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <?php
                                    $sample = isset($sample_data[$import_type]) ? $sample_data[$import_type] : array();
                                    foreach ($fields as $i => $field) {
                                    ?>
                                        <td><?php echo isset($sample[$i]) ? $sample[$i] : 'Sample'; ?></td>
                                    <?php } ?>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <hr/>

                    <!-- Import Form -->
                    <form action="<?php echo site_url('admin/academic/import_' . $import_type); ?>" method="post" enctype="multipart/form-data">
                        <div class="box-body">
                            <?php echo $this->customlib->getCSRF(); ?>

                            <div class="row">
                                <?php if (($import_type == 'classes' || $import_type == 'programme_enrolments') && isset($sessions)) { ?>
                                <!-- Session selector for classes/programme enrolment import -->
                                <div class="col-md-4">
                                    <div class="form-group">
                                        <label>Session <small class="req">*</small></label>
                                        <select name="session_id" class="form-control" required>
                                            <option value="">Select Session</option>
                                            <?php foreach ($sessions as $session) { ?>
                                                <option value="<?php echo $session['id']; ?>" <?php echo ($session['is_active'] == 'yes') ? 'selected' : ''; ?>>
                                                    <?php echo $session['session']; ?>
                                                </option>
                                            <?php } ?>
                                        </select>
                                        <span class="text-danger"><?php echo form_error('session_id'); ?></span>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                <?php } else { ?>
                                <div class="col-md-6">
                                <?php } ?>
                                    <div class="form-group">
                                        <label>Select CSV File <small class="req">*</small></label>
                                        <input type="file" name="file" id="file" class="form-control" accept=".csv" required />
                                        <span class="text-danger"><?php echo form_error('file'); ?></span>
                                        <p class="help-block">Only CSV files are allowed. Maximum file size: 2MB</p>
                                    </div>
                                </div>
                                <div class="col-md-4 pt20">
                                    <button type="submit" class="btn btn-info">
                                        <i class="fa fa-upload"></i> Import <?php echo isset($import_titles[$import_type]) ? $import_titles[$import_type] : ucfirst($import_type); ?>
                                    </button>
                                    <a href="<?php echo site_url('admin/academic/import'); ?>" class="btn btn-default">
                                        <i class="fa fa-arrow-left"></i> Back
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</div>
