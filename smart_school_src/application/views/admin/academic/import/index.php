<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-upload"></i> <?php echo $title; ?>
        </h1>
    </section>
    <section class="content">
        <?php if ($this->session->flashdata('msg')) { ?>
        <div><?php echo $this->session->flashdata('msg'); ?></div>
        <?php } ?>

        <div class="row">
            <div class="col-md-12">
                <div class="callout callout-info">
                    <h4><i class="fa fa-info-circle"></i> Bulk Import Instructions</h4>
                    <p>Use the options below to bulk import TVET data from CSV files. Each import type has a sample file you can download.</p>
                    <p><strong>Important:</strong> Import in the following order for best results:</p>
                    <ol>
                        <li>Programmes (must be imported first)</li>
                        <li>Levels (can reference programmes)</li>
                        <li>Subjects (requires programmes)</li>
                        <li>Subject-Level Mappings (requires subjects and levels)</li>
                        <li>Classes (requires subject-level mappings)</li>
                        <li>Student Enrolments (requires classes and students)</li>
                    </ol>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Programmes Import -->
            <div class="col-md-4">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-sitemap"></i> Programmes</h3>
                    </div>
                    <div class="box-body">
                        <p>Import TVET programmes (NATED, NCV, Skills, etc.)</p>
                        <p><strong>Required fields:</strong> code, name</p>
                        <p><strong>Optional:</strong> description, qualification_type, is_active</p>
                    </div>
                    <div class="box-footer">
                        <a href="<?php echo site_url('admin/academic/download_sample/programmes'); ?>" class="btn btn-default btn-sm">
                            <i class="fa fa-download"></i> Download Sample
                        </a>
                        <a href="<?php echo site_url('admin/academic/import_programmes'); ?>" class="btn btn-primary btn-sm pull-right">
                            <i class="fa fa-upload"></i> Import
                        </a>
                    </div>
                </div>
            </div>

            <!-- Levels Import -->
            <div class="col-md-4">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-signal"></i> Levels</h3>
                    </div>
                    <div class="box-body">
                        <p>Import qualification levels (N1-N6, NCV L2-L4, etc.)</p>
                        <p><strong>Required fields:</strong> code, name</p>
                        <p><strong>Optional:</strong> level_type, nqf_level, programme_code, sequence</p>
                    </div>
                    <div class="box-footer">
                        <a href="<?php echo site_url('admin/academic/download_sample/levels'); ?>" class="btn btn-default btn-sm">
                            <i class="fa fa-download"></i> Download Sample
                        </a>
                        <a href="<?php echo site_url('admin/academic/import_levels'); ?>" class="btn btn-info btn-sm pull-right">
                            <i class="fa fa-upload"></i> Import
                        </a>
                    </div>
                </div>
            </div>

            <!-- Subjects Import -->
            <div class="col-md-4">
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-book"></i> Subjects</h3>
                    </div>
                    <div class="box-body">
                        <p>Import subjects under programmes</p>
                        <p><strong>Required fields:</strong> programme_code, code, name</p>
                        <p><strong>Optional:</strong> description, credits, notional_hours, is_core</p>
                    </div>
                    <div class="box-footer">
                        <a href="<?php echo site_url('admin/academic/download_sample/subjects'); ?>" class="btn btn-default btn-sm">
                            <i class="fa fa-download"></i> Download Sample
                        </a>
                        <a href="<?php echo site_url('admin/academic/import_subjects'); ?>" class="btn btn-success btn-sm pull-right">
                            <i class="fa fa-upload"></i> Import
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Subject-Level Mappings Import -->
            <div class="col-md-4">
                <div class="box box-warning">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-link"></i> Subject-Level Mappings</h3>
                    </div>
                    <div class="box-body">
                        <p>Map subjects to qualification levels</p>
                        <p><strong>Required fields:</strong> subject_code, level_code</p>
                        <p><strong>Optional:</strong> syllabus_code, is_active</p>
                    </div>
                    <div class="box-footer">
                        <a href="<?php echo site_url('admin/academic/download_sample/subject_levels'); ?>" class="btn btn-default btn-sm">
                            <i class="fa fa-download"></i> Download Sample
                        </a>
                        <a href="<?php echo site_url('admin/academic/import_subject_levels'); ?>" class="btn btn-warning btn-sm pull-right">
                            <i class="fa fa-upload"></i> Import
                        </a>
                    </div>
                </div>
            </div>

            <!-- Classes Import -->
            <div class="col-md-4">
                <div class="box box-danger">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-users"></i> Classes</h3>
                    </div>
                    <div class="box-body">
                        <p>Import class cohorts (Subject + Level + Cohort)</p>
                        <p><strong>Required fields:</strong> subject_code, level_code, cohort_name, academic_year</p>
                        <p><strong>Optional:</strong> venue, max_students, lecturer_employee_id</p>
                    </div>
                    <div class="box-footer">
                        <a href="<?php echo site_url('admin/academic/download_sample/classes'); ?>" class="btn btn-default btn-sm">
                            <i class="fa fa-download"></i> Download Sample
                        </a>
                        <a href="<?php echo site_url('admin/academic/import_classes'); ?>" class="btn btn-danger btn-sm pull-right">
                            <i class="fa fa-upload"></i> Import
                        </a>
                    </div>
                </div>
            </div>

            <!-- Student Enrolments Import (per class) -->
            <div class="col-md-4">
                <div class="box box-default">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-user-plus"></i> Class Enrolments</h3>
                    </div>
                    <div class="box-body">
                        <p>Enrol students in individual classes</p>
                        <p><strong>Required fields:</strong> admission_no, class_code</p>
                        <p><strong>Optional:</strong> enrolment_date, status, notes</p>
                    </div>
                    <div class="box-footer">
                        <a href="<?php echo site_url('admin/academic/download_sample/enrolments'); ?>" class="btn btn-default btn-sm">
                            <i class="fa fa-download"></i> Download Sample
                        </a>
                        <a href="<?php echo site_url('admin/academic/import_enrolments'); ?>" class="btn btn-default btn-sm pull-right">
                            <i class="fa fa-upload"></i> Import
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Programme-Based Enrolment (Recommended) -->
        <div class="row">
            <div class="col-md-12">
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-users"></i> Programme-Based Student Enrolment (Recommended)</h3>
                        <span class="label label-success pull-right">FAST ENROLMENT</span>
                    </div>
                    <div class="box-body">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="callout callout-success">
                                    <h4><i class="fa fa-bolt"></i> Bulk Enrol Students in ALL Programme Classes at Once!</h4>
                                    <p>This is the recommended way to enrol students. Simply specify:</p>
                                    <ul>
                                        <li><strong>Student admission number</strong></li>
                                        <li><strong>Programme</strong> (e.g., NATED)</li>
                                        <li><strong>Level</strong> (e.g., N4)</li>
                                        <li><strong>Cohort</strong> (e.g., A)</li>
                                    </ul>
                                    <p>The system will automatically enrol the student in <strong>ALL</strong> classes for that programme/level/cohort combination.</p>
                                    <p class="text-muted">Example: A student enrolled in NATED/N4/Cohort A will be automatically enrolled in Mathematics N4-A, Engineering Science N4-A, etc.</p>
                                </div>
                                <p><strong>Required fields:</strong> admission_no, programme_code, level_code, cohort</p>
                                <p><strong>Optional:</strong> enrolment_date, notes</p>
                            </div>
                            <div class="col-md-4 text-center">
                                <div style="padding: 20px;">
                                    <a href="<?php echo site_url('admin/academic/download_sample/programme_enrolments'); ?>" class="btn btn-default btn-lg btn-block" style="margin-bottom: 15px;">
                                        <i class="fa fa-download"></i> Download Sample CSV
                                    </a>
                                    <a href="<?php echo site_url('admin/academic/import_programme_enrolments'); ?>" class="btn btn-success btn-lg btn-block">
                                        <i class="fa fa-upload"></i> Import Programme Enrolments
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- API Information -->
        <div class="row">
            <div class="col-md-12">
                <div class="box box-solid">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-code"></i> API Bulk Import</h3>
                        <div class="box-tools pull-right">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
                        </div>
                    </div>
                    <div class="box-body">
                        <p>You can also import data programmatically using the API endpoints:</p>
                        <table class="table table-bordered table-striped">
                            <thead>
                                <tr>
                                    <th>Endpoint</th>
                                    <th>Method</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><code><?php echo site_url('admin/academic/api_import_programmes'); ?></code></td>
                                    <td><span class="label label-success">POST</span></td>
                                    <td>Import programmes via JSON</td>
                                </tr>
                                <tr>
                                    <td><code><?php echo site_url('admin/academic/api_import_subjects'); ?></code></td>
                                    <td><span class="label label-success">POST</span></td>
                                    <td>Import subjects via JSON</td>
                                </tr>
                                <tr>
                                    <td><code><?php echo site_url('admin/academic/api_import_enrolments'); ?></code></td>
                                    <td><span class="label label-success">POST</span></td>
                                    <td>Import student enrolments via JSON</td>
                                </tr>
                            </tbody>
                        </table>
                        <p class="text-muted"><i class="fa fa-info-circle"></i> All API endpoints require the <code>X-API-Token</code> header for authentication.</p>
                        <h4>Example Request (Programmes):</h4>
                        <pre>{
    "programmes": [
        {"code": "NATED", "name": "National Accredited Technical Education Diploma", "qualification_type": "NATED"},
        {"code": "NCV", "name": "National Certificate Vocational", "qualification_type": "NCV"}
    ]
}</pre>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
