<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-users"></i> Cohort Roster: <?php echo $cohort['name']; ?></h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <?php if ($this->session->flashdata('msg')) { ?>
                    <?php echo $this->session->flashdata('msg'); ?>
                <?php } ?>
            </div>
        </div>

        <!-- Cohort Details -->
        <div class="row">
            <div class="col-md-12">
                <div class="box box-default">
                    <div class="box-body">
                        <div class="row">
                            <div class="col-md-3">
                                <strong>Code:</strong> <?php echo $cohort['code']; ?>
                            </div>
                            <div class="col-md-3">
                                <strong>Level:</strong> <?php echo $cohort['level_name']; ?>
                            </div>
                            <div class="col-md-3">
                                <strong>Mode:</strong> <?php echo $cohort['delivery_mode']; ?>
                            </div>
                            <div class="col-md-3">
                                <strong>Intake:</strong> <?php echo $cohort['intake_year']; ?> |
                                <strong>Dates:</strong> <?php echo $cohort['start_date']; ?>
                                <?php if (!empty($cohort['end_date'])) { ?>
                                    - <?php echo $cohort['end_date']; ?>
                                <?php } ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- LEFT: Enrolled Students -->
            <div class="col-md-8">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Enrolled Students (<?php echo count($students); ?> / <?php echo $cohort['max_students']; ?>)</h3>
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>Student No</th>
                                        <th>Admission No</th>
                                        <th>Name</th>
                                        <th>Status</th>
                                        <th class="text-right noExport">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (!empty($students)) {
                                        foreach ($students as $student) { ?>
                                            <tr>
                                                <td><?php echo $student['student_number']; ?></td>
                                                <td><?php echo $student['admission_no']; ?></td>
                                                <td><?php echo $student['firstname'] . ' ' . $student['lastname']; ?></td>
                                                <td>
                                                    <form action="<?php echo base_url('admin/tvet/cohort_change_status'); ?>" method="post" class="form-inline" style="display:inline;">
                                                        <?php echo $this->customlib->getCSRF(); ?>
                                                        <input type="hidden" name="enrolment_id" value="<?php echo $student['enrolment_id']; ?>" />
                                                        <input type="hidden" name="cohort_id" value="<?php echo $cohort['id']; ?>" />
                                                        <select name="status" class="form-control input-sm" onchange="this.form.submit()">
                                                            <option value="Active" <?php echo ($student['status'] == 'Active') ? 'selected' : ''; ?>>Active</option>
                                                            <option value="Completed" <?php echo ($student['status'] == 'Completed') ? 'selected' : ''; ?>>Completed</option>
                                                            <option value="Dropped" <?php echo ($student['status'] == 'Dropped') ? 'selected' : ''; ?>>Dropped</option>
                                                            <option value="Suspended" <?php echo ($student['status'] == 'Suspended') ? 'selected' : ''; ?>>Suspended</option>
                                                            <option value="Transferred" <?php echo ($student['status'] == 'Transferred') ? 'selected' : ''; ?>>Transferred</option>
                                                        </select>
                                                    </form>
                                                </td>
                                                <td class="text-right">
                                                    <a href="<?php echo base_url('admin/tvet/cohort_remove_student/' . $student['enrolment_id'] . '/' . $cohort['id']); ?>" class="btn btn-danger btn-xs" data-toggle="tooltip" title="Remove Student" onclick="return confirm('Are you sure you want to remove this student from the cohort?');">
                                                        <i class="fa fa-remove"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        <?php }
                                    } else { ?>
                                        <tr>
                                            <td colspan="5" class="text-center">No students enrolled in this cohort.</td>
                                        </tr>
                                    <?php } ?>
                                </tbody>
                            </table>
                        </div>
                    </div><!-- /.box-body -->
                </div>
            </div>

            <!-- RIGHT: Add Student -->
            <div class="col-md-4">
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Add Student</h3>
                    </div><!-- /.box-header -->
                    <form action="<?php echo base_url('admin/tvet/cohort_add_student/' . $cohort['id']); ?>" method="post">
                        <div class="box-body">
                            <?php echo $this->customlib->getCSRF(); ?>

                            <?php if (validation_errors()) { ?>
                                <div class="alert alert-danger">
                                    <?php echo validation_errors(); ?>
                                </div>
                            <?php } ?>

                            <div class="form-group">
                                <label>Student</label><small class="req"> *</small>
                                <select name="student_id" class="form-control select2" style="width: 100%;" required>
                                    <option value="">Select Student</option>
                                    <?php if (!empty($available_students)) {
                                        foreach ($available_students as $avail_student) { ?>
                                            <option value="<?php echo $avail_student['id']; ?>"><?php echo $avail_student['firstname'] . ' ' . $avail_student['lastname'] . ' (' . $avail_student['admission_no'] . ')'; ?></option>
                                        <?php }
                                    } ?>
                                </select>
                                <span class="text-danger"><?php echo form_error('student_id'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Student Number</label><small class="req"> *</small>
                                <input name="student_number" type="text" class="form-control" placeholder="e.g., S2024001" value="<?php echo set_value('student_number'); ?>" required />
                                <span class="text-danger"><?php echo form_error('student_number'); ?></span>
                            </div>

                        </div><!-- /.box-body -->
                        <div class="box-footer">
                            <button type="submit" class="btn btn-success btn-block">Add to Cohort</button>
                        </div>
                    </form>
                </div>

                <div class="text-center">
                    <a href="<?php echo base_url('admin/tvet/cohort'); ?>" class="btn btn-default"><i class="fa fa-arrow-left"></i> Back to Cohorts</a>
                </div>
            </div>
        </div>
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

<script>
$(document).ready(function() {
    $('.select2').select2();
});
</script>
