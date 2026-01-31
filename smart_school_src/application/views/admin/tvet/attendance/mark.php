<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-check-square-o"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            Cohort: <?php echo htmlspecialchars($cohort['name']); ?>
                            <small class="text-muted">
                                (<?php echo htmlspecialchars($cohort['programme_name'] ?? ''); ?> - <?php echo htmlspecialchars($cohort['level_name'] ?? ''); ?>)
                            </small>
                        </h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo base_url('admin/tvet/attendance'); ?>" class="btn btn-default btn-sm">
                                <i class="fa fa-arrow-left"></i> Back
                            </a>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Select Module</label>
                                    <select class="form-control select2" id="module_select" onchange="changeModule()">
                                        <option value="">-- Select Module --</option>
                                        <?php foreach ($modules as $module): ?>
                                        <option value="<?php echo $module['id']; ?>" <?php echo ($selected_module_id == $module['id']) ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars($module['module_name']); ?>
                                        </option>
                                        <?php endforeach; ?>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Date</label>
                                    <input type="date" class="form-control" id="attendance_date"
                                           value="<?php echo $attendance_date; ?>" onchange="changeDate()">
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>&nbsp;</label>
                                    <div>
                                        <button type="button" class="btn btn-success btn-sm" onclick="markAll('Present')">
                                            <i class="fa fa-check"></i> All Present
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" onclick="markAll('Absent')">
                                            <i class="fa fa-times"></i> All Absent
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <?php if ($selected_module_id && !empty($students)): ?>
                        <form method="post" action="">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered">
                                    <thead>
                                        <tr>
                                            <th width="5%">#</th>
                                            <th width="15%">Student No</th>
                                            <th width="25%">Student Name</th>
                                            <th width="10%" class="text-center bg-success">Present</th>
                                            <th width="10%" class="text-center bg-danger">Absent</th>
                                            <th width="10%" class="text-center bg-warning">Late</th>
                                            <th width="10%" class="text-center bg-info">Excused</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php $i = 1; foreach ($students as $student): ?>
                                        <?php
                                        $enrolment_id = $student['enrolment_id'];
                                        $current_status = isset($existing_attendance[$enrolment_id]) ? $existing_attendance[$enrolment_id] : 'Present';
                                        ?>
                                        <tr>
                                            <td><?php echo $i++; ?></td>
                                            <td><?php echo htmlspecialchars($student['admission_no']); ?></td>
                                            <td><?php echo htmlspecialchars($student['firstname'] . ' ' . $student['lastname']); ?></td>
                                            <td class="text-center">
                                                <input type="radio" name="attendance[<?php echo $enrolment_id; ?>]"
                                                       value="Present" <?php echo ($current_status == 'Present') ? 'checked' : ''; ?>>
                                            </td>
                                            <td class="text-center">
                                                <input type="radio" name="attendance[<?php echo $enrolment_id; ?>]"
                                                       value="Absent" <?php echo ($current_status == 'Absent') ? 'checked' : ''; ?>>
                                            </td>
                                            <td class="text-center">
                                                <input type="radio" name="attendance[<?php echo $enrolment_id; ?>]"
                                                       value="Late" <?php echo ($current_status == 'Late') ? 'checked' : ''; ?>>
                                            </td>
                                            <td class="text-center">
                                                <input type="radio" name="attendance[<?php echo $enrolment_id; ?>]"
                                                       value="Excused" <?php echo ($current_status == 'Excused') ? 'checked' : ''; ?>>
                                            </td>
                                        </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fa fa-save"></i> Save Attendance
                                </button>
                            </div>
                        </form>
                        <?php elseif ($selected_module_id): ?>
                        <div class="alert alert-info">
                            <i class="fa fa-info-circle"></i> No students enrolled in this cohort.
                        </div>
                        <?php else: ?>
                        <div class="alert alert-info">
                            <i class="fa fa-info-circle"></i> Please select a module to mark attendance.
                        </div>
                        <?php endif; ?>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<script>
function changeModule() {
    var moduleId = $('#module_select').val();
    var date = $('#attendance_date').val();
    if (moduleId) {
        window.location.href = '<?php echo base_url('admin/tvet/mark_attendance/' . $cohort['id']); ?>/' + moduleId + '?date=' + date;
    }
}

function changeDate() {
    var moduleId = $('#module_select').val();
    var date = $('#attendance_date').val();
    if (moduleId) {
        window.location.href = '<?php echo base_url('admin/tvet/mark_attendance/' . $cohort['id']); ?>/' + moduleId + '?date=' + date;
    }
}

function markAll(status) {
    $('input[type="radio"][value="' + status + '"]').prop('checked', true);
}
</script>
