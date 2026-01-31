<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-clipboard-check"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Subject &rarr; Level &rarr; Cohort &rarr; Date</h3>
                <div class="box-tools pull-right">
                    <a href="<?php echo base_url('admin/academic/attendance'); ?>" class="btn btn-default btn-sm">
                        <i class="fa fa-arrow-left"></i> Back
                    </a>
                </div>
            </div>
            <div class="box-body">
                <!-- Class Selection -->
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Subject</label>
                            <select class="form-control select2" id="filter_subject" onchange="loadLevels()">
                                <option value="">-- Select Subject --</option>
                                <?php foreach ($subjects as $s): ?>
                                <option value="<?php echo $s->id; ?>"
                                    <?php echo (isset($class) && $class->subject_id == $s->id) ? 'selected' : ''; ?>>
                                    <?php echo htmlspecialchars($s->name); ?> (<?php echo $s->code; ?>)
                                </option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Level</label>
                            <select class="form-control select2" id="filter_level" onchange="loadClasses()" disabled>
                                <option value="">-- Select Subject First --</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Cohort (Class)</label>
                            <select class="form-control select2" id="filter_class" onchange="loadStudents()" disabled>
                                <option value="">-- Select Level First --</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label>Date</label>
                            <input type="date" class="form-control" id="attendance_date"
                                   value="<?php echo isset($attendance_date) ? $attendance_date : date('Y-m-d'); ?>"
                                   onchange="loadStudents()">
                        </div>
                    </div>
                </div>

                <!-- Class Info -->
                <div id="class_info" class="alert alert-info" style="display:<?php echo isset($class) ? 'block' : 'none'; ?>;">
                    <strong>Class:</strong> <span id="info_class_code"><?php echo isset($class) ? htmlspecialchars($class->class_code) : ''; ?></span> |
                    <strong>Lecturer:</strong> <span id="info_lecturer"><?php echo isset($class) ? htmlspecialchars($class->lecturer_name . ' ' . $class->lecturer_surname) : ''; ?></span> |
                    <strong>Venue:</strong> <span id="info_venue"><?php echo isset($class) ? htmlspecialchars($class->venue) : ''; ?></span>
                </div>

                <!-- Attendance Form -->
                <?php if (!empty($students)): ?>
                <form method="post" action="">
                    <input type="hidden" name="class_id" value="<?php echo $class->id; ?>">
                    <input type="hidden" name="attendance_date" value="<?php echo $attendance_date; ?>">

                    <div class="row" style="margin-bottom: 10px;">
                        <div class="col-md-12">
                            <button type="button" class="btn btn-success btn-sm" onclick="markAll('Present')">
                                <i class="fa fa-check"></i> All Present
                            </button>
                            <button type="button" class="btn btn-danger btn-sm" onclick="markAll('Absent')">
                                <i class="fa fa-times"></i> All Absent
                            </button>
                        </div>
                    </div>

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
                                    <th width="15%">Notes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php $i = 1; foreach ($students as $student): ?>
                                <?php
                                $enrolment_id = $student->enrolment_id;
                                $current_status = isset($existing_attendance[$enrolment_id]) ? $existing_attendance[$enrolment_id]['status'] : 'Present';
                                $current_notes = isset($existing_attendance[$enrolment_id]) ? $existing_attendance[$enrolment_id]['notes'] : '';
                                ?>
                                <tr>
                                    <td><?php echo $i++; ?></td>
                                    <td><?php echo htmlspecialchars($student->admission_no); ?></td>
                                    <td><?php echo htmlspecialchars($student->firstname . ' ' . $student->lastname); ?></td>
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
                                    <td>
                                        <input type="text" name="notes[<?php echo $enrolment_id; ?>]"
                                               class="form-control input-sm" placeholder="Notes..."
                                               value="<?php echo htmlspecialchars($current_notes); ?>">
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
                <?php elseif (isset($class)): ?>
                <div class="alert alert-warning">
                    <i class="fa fa-info-circle"></i> No students enrolled in this class.
                </div>
                <?php else: ?>
                <div class="alert alert-info" id="select_prompt">
                    <i class="fa fa-info-circle"></i> Please select Subject, Level, and Cohort to mark attendance.
                </div>

                <!-- Student list placeholder for AJAX -->
                <div id="student_list_container" style="display:none;">
                    <form method="post" action="" id="attendance_form">
                        <input type="hidden" name="class_id" id="form_class_id">
                        <input type="hidden" name="attendance_date" id="form_attendance_date">

                        <div class="row" style="margin-bottom: 10px;">
                            <div class="col-md-12">
                                <button type="button" class="btn btn-success btn-sm" onclick="markAll('Present')">
                                    <i class="fa fa-check"></i> All Present
                                </button>
                                <button type="button" class="btn btn-danger btn-sm" onclick="markAll('Absent')">
                                    <i class="fa fa-times"></i> All Absent
                                </button>
                            </div>
                        </div>

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
                                        <th width="15%">Notes</th>
                                    </tr>
                                </thead>
                                <tbody id="student_tbody">
                                </tbody>
                            </table>
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">
                                <i class="fa fa-save"></i> Save Attendance
                            </button>
                        </div>
                    </form>
                </div>
                <?php endif; ?>
            </div>
        </div>
    </section>
</div>

<script>
var selectedSubjectId = null;
var selectedLevelId = null;

function loadLevels() {
    var subjectId = $('#filter_subject').val();
    selectedSubjectId = subjectId;

    if (!subjectId) {
        $('#filter_level').html('<option value="">-- Select Subject First --</option>').prop('disabled', true);
        $('#filter_class').html('<option value="">-- Select Level First --</option>').prop('disabled', true);
        return;
    }

    $.ajax({
        url: '<?php echo base_url('admin/academic/ajax_get_levels/'); ?>' + subjectId,
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            var html = '<option value="">-- Select Level --</option>';
            $.each(data, function(i, item) {
                html += '<option value="' + item.level_id + '">' + item.level_code + ' - ' + item.level_name + '</option>';
            });
            $('#filter_level').html(html).prop('disabled', false);
            $('#filter_class').html('<option value="">-- Select Level First --</option>').prop('disabled', true);
        }
    });
}

function loadClasses() {
    var levelId = $('#filter_level').val();
    selectedLevelId = levelId;

    if (!selectedSubjectId || !levelId) {
        $('#filter_class').html('<option value="">-- Select Level First --</option>').prop('disabled', true);
        return;
    }

    $.ajax({
        url: '<?php echo base_url('admin/academic/ajax_get_classes/'); ?>' + selectedSubjectId + '/' + levelId,
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            var html = '<option value="">-- Select Cohort --</option>';
            $.each(data, function(i, item) {
                html += '<option value="' + item.id + '">' + item.cohort_name + ' (' + item.class_code + ')</option>';
            });
            $('#filter_class').html(html).prop('disabled', false);
        }
    });
}

function loadStudents() {
    var classId = $('#filter_class').val();
    var date = $('#attendance_date').val();

    if (!classId || !date) {
        $('#student_list_container').hide();
        $('#select_prompt').show();
        return;
    }

    $.ajax({
        url: '<?php echo base_url('admin/academic/ajax_get_class_students/'); ?>' + classId,
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            if (data.students.length == 0) {
                $('#student_list_container').hide();
                $('#select_prompt').html('<i class="fa fa-warning"></i> No students enrolled in this class.').show();
                return;
            }

            // Update class info
            $('#info_class_code').text(data.class_code);
            $('#info_lecturer').text(data.lecturer || 'Not Assigned');
            $('#info_venue').text(data.venue || '-');
            $('#class_info').show();

            // Update form
            $('#form_class_id').val(classId);
            $('#form_attendance_date').val(date);
            $('#attendance_form').attr('action', '<?php echo base_url('admin/academic/mark_attendance/'); ?>' + classId + '?date=' + date);

            // Build student rows
            var html = '';
            $.each(data.students, function(i, s) {
                html += '<tr>';
                html += '<td>' + (i + 1) + '</td>';
                html += '<td>' + s.student_no + '</td>';
                html += '<td>' + s.name + '</td>';
                html += '<td class="text-center"><input type="radio" name="attendance[' + s.enrolment_id + ']" value="Present" checked></td>';
                html += '<td class="text-center"><input type="radio" name="attendance[' + s.enrolment_id + ']" value="Absent"></td>';
                html += '<td class="text-center"><input type="radio" name="attendance[' + s.enrolment_id + ']" value="Late"></td>';
                html += '<td class="text-center"><input type="radio" name="attendance[' + s.enrolment_id + ']" value="Excused"></td>';
                html += '<td><input type="text" name="notes[' + s.enrolment_id + ']" class="form-control input-sm" placeholder="Notes..."></td>';
                html += '</tr>';
            });

            $('#student_tbody').html(html);
            $('#select_prompt').hide();
            $('#student_list_container').show();
        }
    });
}

function markAll(status) {
    $('input[type="radio"][value="' + status + '"]').prop('checked', true);
}

// Initialize if class is pre-selected
<?php if (isset($class)): ?>
$(document).ready(function() {
    // Pre-select dropdowns based on existing class
});
<?php endif; ?>
</script>
