<?php
$currency_symbol = $this->customlib->getSchoolCurrencyFormat();
?>
<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-users"></i> <?php echo $title; ?>
        </h1>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-info" style="padding:5px;">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-upload"></i> Import TVET Enrollments</h3>
                        <div class="pull-right box-tools">
                            <a href="<?php echo site_url('student/exportformatEnrolments') ?>">
                                <button class="btn btn-primary btn-sm">
                                    <i class="fa fa-download"></i> Download Sample CSV
                                </button>
                            </a>
                        </div>
                    </div>

                    <div class="box-body">
                        <?php if ($this->session->flashdata('success_message')) { ?>
                            <div class="alert alert-success alert-dismissible">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <h4><i class="icon fa fa-check"></i> Success!</h4>
                                <?php echo $this->session->flashdata('success_message'); ?>
                            </div>
                        <?php } ?>

                        <?php if ($this->session->flashdata('error_message')) { ?>
                            <div class="alert alert-danger alert-dismissible">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <h4><i class="icon fa fa-ban"></i> Error!</h4>
                                <?php echo $this->session->flashdata('error_message'); ?>
                            </div>
                        <?php } ?>

                        <div class="instructions">
                            <h4><i class="fa fa-info-circle"></i> Import Instructions</h4>
                            <ol>
                                <li><strong>Download Sample CSV:</strong> Click the "Download Sample CSV" button above to get the template file with 17 columns</li>
                                <li><strong>CSV Format:</strong> Each row represents one enrollment (student + class combination)
                                    <ul>
                                        <li>Students can appear multiple times (one row per subject/class)</li>
                                        <li>17 columns: admission_no, firstname, lastname, id_number, dob, gender, mobileno, email, subject_code, level_code, cohort_name, academic_year, qualification_name, campus_name, enrolment_date, status, notes</li>
                                    </ul>
                                </li>
                                <li><strong>Required Fields:</strong>
                                    <ul>
                                        <li><span class="text-red">*</span> admission_no - Student admission/registration number</li>
                                        <li><span class="text-red">*</span> firstname - Student first name(s)</li>
                                        <li><span class="text-red">*</span> lastname - Student surname/family name</li>
                                        <li><span class="text-red">*</span> subject_code - Subject code (e.g., MATH, ENG, BUSM)</li>
                                        <li><span class="text-red">*</span> level_code - Level code (e.g., N4, N3C)</li>
                                        <li><span class="text-red">*</span> academic_year - Year (e.g., 2026)</li>
                                    </ul>
                                </li>
                                <li><strong>Optional Fields:</strong>
                                    <ul>
                                        <li>Student: id_number, dob, gender, mobileno, email</li>
                                        <li>Class: cohort_name (default: A)</li>
                                        <li>Programme: qualification_name, campus_name</li>
                                        <li>Enrollment: enrolment_date (default: today), status (default: Active), notes</li>
                                    </ul>
                                </li>
                                <li><strong>Status Values:</strong> Active, Completed, Dropped, Suspended, Transferred, Withdrawn</li>
                                <li><strong>Automatic Creation:</strong>
                                    <ul>
                                        <li>✅ Students will be created if they don't exist</li>
                                        <li>✅ Existing students will be updated with missing contact info (phone, email)</li>
                                        <li>✅ Students will be linked to programmes if qualification_name is provided</li>
                                    </ul>
                                </li>
                                <li><strong>Prerequisites (Must Exist Before Import):</strong>
                                    <div class="alert alert-warning" style="margin-top: 10px;">
                                        <strong><i class="fa fa-exclamation-triangle"></i> Important:</strong> These must be created in the system before import:
                                        <ul>
                                            <li>❌ Subjects (Admin → TVET → Subjects)</li>
                                            <li>❌ Levels (Admin → TVET → Levels)</li>
                                            <li>❌ Subject-Level combinations (Admin → TVET → Subject Levels)</li>
                                            <li>❌ Classes (Admin → TVET → Classes) - for each subject+level+cohort+year</li>
                                            <li>❌ Programmes (Admin → TVET → Programmes) - optional, only if qualification_name is used</li>
                                        </ul>
                                    </div>
                                </li>
                                <li><strong>Upload CSV:</strong> Use the form below to select and upload your prepared CSV file</li>
                                <li><strong>Review Results:</strong> After upload, you'll see a summary of:
                                    <ul>
                                        <li>Students created/updated</li>
                                        <li>Enrollments created</li>
                                        <li>Programmes linked</li>
                                        <li>Any errors encountered</li>
                                    </ul>
                                </li>
                            </ol>
                        </div>

                        <hr/>

                        <h4><i class="fa fa-file-excel-o"></i> Sample CSV Format (17 Columns)</h4>
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-sm">
                                <thead class="bg-light-blue">
                                    <tr>
                                        <th>admission_no<span class="text-red">*</span></th>
                                        <th>firstname<span class="text-red">*</span></th>
                                        <th>lastname<span class="text-red">*</span></th>
                                        <th>id_number</th>
                                        <th>dob</th>
                                        <th>gender</th>
                                        <th>mobileno</th>
                                        <th>email</th>
                                        <th>subject_code<span class="text-red">*</span></th>
                                        <th>level_code<span class="text-red">*</span></th>
                                        <th>cohort_name</th>
                                        <th>academic_year<span class="text-red">*</span></th>
                                        <th>qualification_name</th>
                                        <th>campus_name</th>
                                        <th>enrolment_date</th>
                                        <th>status</th>
                                        <th>notes</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>202401</td>
                                        <td>John</td>
                                        <td>Doe</td>
                                        <td>9512151234567</td>
                                        <td>1995-12-15</td>
                                        <td>Male</td>
                                        <td>0821234567</td>
                                        <td>john@example.com</td>
                                        <td>MATH</td>
                                        <td>N4</td>
                                        <td>A</td>
                                        <td>2026</td>
                                        <td>National Certificate: Engineering</td>
                                        <td>Goodwood Campus</td>
                                        <td>2026-01-15</td>
                                        <td>Active</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td>202401</td>
                                        <td>John</td>
                                        <td>Doe</td>
                                        <td>9512151234567</td>
                                        <td>1995-12-15</td>
                                        <td>Male</td>
                                        <td>0821234567</td>
                                        <td>john@example.com</td>
                                        <td>ENG</td>
                                        <td>N4</td>
                                        <td>A</td>
                                        <td>2026</td>
                                        <td>National Certificate: Engineering</td>
                                        <td>Goodwood Campus</td>
                                        <td>2026-01-15</td>
                                        <td>Active</td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td colspan="17" class="text-center text-muted">
                                            <em>Note: Student 202401 (John Doe) enrolled in 2 subjects, so appears in 2 rows</em>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Upload Form -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-upload"></i> Upload CSV File</h3>
                    </div>
                    <form role="form" id="import_form" method="post" enctype="multipart/form-data" action="<?php echo site_url('student/importEnrolments') ?>">
                        <div class="box-body">
                            <div class="form-group">
                                <label for="file">Select CSV File <span class="text-red">*</span></label>
                                <input type="file" name="file" id="file" class="form-control" accept=".csv" required>
                                <span class="text-danger"><?php echo form_error('file'); ?></span>
                                <p class="help-block">
                                    <i class="fa fa-info-circle"></i> Only CSV files are accepted. Maximum file size: 5MB
                                </p>
                            </div>
                        </div>
                        <div class="box-footer">
                            <button type="submit" class="btn btn-primary pull-right">
                                <i class="fa fa-upload"></i> Import Enrollments
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</div>

<style>
.instructions {
    background-color: #f9f9f9;
    padding: 15px;
    border-radius: 5px;
    margin-bottom: 20px;
}
.instructions ol {
    padding-left: 20px;
}
.instructions li {
    margin-bottom: 10px;
}
.instructions ul {
    margin-top: 5px;
    margin-bottom: 5px;
}
.table-sm th,
.table-sm td {
    padding: 5px;
    font-size: 11px;
}
</style>
