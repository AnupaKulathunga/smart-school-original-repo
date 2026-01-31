<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-users"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>
        <?php echo validation_errors('<div class="alert alert-danger">', '</div>'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><?php echo isset($class) ? 'Edit Class' : 'Create New Class'; ?></h3>
                <div class="box-tools pull-right">
                    <a href="<?php echo base_url('admin/academic/classes'); ?>" class="btn btn-default btn-sm">
                        <i class="fa fa-arrow-left"></i> Back to List
                    </a>
                </div>
            </div>
            <form method="post" action="">
                <div class="box-body">
                    <?php if (!isset($class)): ?>
                    <!-- Subject-Level Selection (only for new class) -->
                    <div class="callout callout-info">
                        <h4>Step 1: Select Subject at Level</h4>
                        <p>First select the programme, then the subject, and finally the level at which this class will be offered.</p>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Programme <span class="text-red">*</span></label>
                                <select class="form-control select2" id="programme_id" onchange="loadSubjectLevels()">
                                    <option value="">-- Select Programme --</option>
                                    <?php foreach ($programmes as $p): ?>
                                    <option value="<?php echo $p->id; ?>"><?php echo htmlspecialchars($p->name); ?></option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="form-group">
                                <label>Subject at Level <span class="text-red">*</span></label>
                                <select class="form-control select2" name="subject_level_id" id="subject_level_id" required>
                                    <option value="">-- Select Programme First --</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <?php else: ?>
                    <!-- Display locked Subject-Level for editing -->
                    <div class="callout callout-warning">
                        <h4>Subject & Level (Locked)</h4>
                        <p>
                            <strong>Subject:</strong> <?php echo htmlspecialchars($class->subject_name); ?> (<?php echo $class->subject_code; ?>)<br>
                            <strong>Level:</strong> <?php echo htmlspecialchars($class->level_code . ' - ' . $class->level_name); ?><br>
                            <strong>Programme:</strong> <?php echo htmlspecialchars($class->programme_name); ?>
                        </p>
                    </div>
                    <?php endif; ?>

                    <hr>

                    <div class="callout callout-info">
                        <h4>Step 2: Class Details</h4>
                        <p>Define the cohort, academic year, and other class settings.</p>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Cohort Name <span class="text-red">*</span></label>
                                <input type="text" name="cohort_name" class="form-control" required
                                       value="<?php echo isset($class) ? $class->cohort_name : set_value('cohort_name'); ?>"
                                       placeholder="e.g., A, B, C, Group 1">
                                <small class="text-muted">Used to group ~50 students taking the same class</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Academic Year <span class="text-red">*</span></label>
                                <input type="number" name="academic_year" class="form-control" required
                                       value="<?php echo isset($class) ? $class->academic_year : date('Y'); ?>"
                                       min="2020" max="2050">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Session <span class="text-red">*</span></label>
                                <select name="session_id" class="form-control select2" required>
                                    <option value="">-- Select Session --</option>
                                    <?php foreach ($sessions as $s): ?>
                                    <option value="<?php echo $s['id']; ?>"
                                        <?php echo (isset($class) && $class->session_id == $s['id']) ? 'selected' : ''; ?>>
                                        <?php echo htmlspecialchars($s['session']); ?>
                                    </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Intake Period</label>
                                <select name="intake_period" class="form-control">
                                    <option value="">-- Select --</option>
                                    <option value="January" <?php echo (isset($class) && $class->intake_period == 'January') ? 'selected' : ''; ?>>January</option>
                                    <option value="February" <?php echo (isset($class) && $class->intake_period == 'February') ? 'selected' : ''; ?>>February</option>
                                    <option value="July" <?php echo (isset($class) && $class->intake_period == 'July') ? 'selected' : ''; ?>>July</option>
                                    <option value="September" <?php echo (isset($class) && $class->intake_period == 'September') ? 'selected' : ''; ?>>September</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Delivery Mode</label>
                                <select name="delivery_mode" class="form-control">
                                    <option value="Full-time" <?php echo (isset($class) && $class->delivery_mode == 'Full-time') ? 'selected' : ''; ?>>Full-time</option>
                                    <option value="Part-time" <?php echo (isset($class) && $class->delivery_mode == 'Part-time') ? 'selected' : ''; ?>>Part-time</option>
                                    <option value="Evening" <?php echo (isset($class) && $class->delivery_mode == 'Evening') ? 'selected' : ''; ?>>Evening</option>
                                    <option value="Weekend" <?php echo (isset($class) && $class->delivery_mode == 'Weekend') ? 'selected' : ''; ?>>Weekend</option>
                                    <option value="Distance" <?php echo (isset($class) && $class->delivery_mode == 'Distance') ? 'selected' : ''; ?>>Distance</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Max Students</label>
                                <input type="number" name="max_students" class="form-control"
                                       value="<?php echo isset($class) ? $class->max_students : 50; ?>"
                                       min="1" max="200">
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Primary Lecturer</label>
                                <select name="primary_lecturer_id" class="form-control select2">
                                    <option value="">-- Select Lecturer --</option>
                                    <?php foreach ($lecturers as $l): ?>
                                    <option value="<?php echo $l['id']; ?>"
                                        <?php echo (isset($class) && $class->primary_lecturer_id == $l['id']) ? 'selected' : ''; ?>>
                                        <?php echo htmlspecialchars($l['name'] . ' ' . $l['surname']); ?>
                                    </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Venue / Room</label>
                                <input type="text" name="venue" class="form-control"
                                       value="<?php echo isset($class) ? $class->venue : ''; ?>"
                                       placeholder="e.g., LAB-101, Room A12">
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Start Date</label>
                                <input type="date" name="start_date" class="form-control"
                                       value="<?php echo isset($class) && $class->start_date ? $class->start_date : ''; ?>">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>End Date</label>
                                <input type="date" name="end_date" class="form-control"
                                       value="<?php echo isset($class) && $class->end_date ? $class->end_date : ''; ?>">
                            </div>
                        </div>
                        <?php if (isset($class)): ?>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Status</label>
                                <select name="status" class="form-control">
                                    <option value="Scheduled" <?php echo ($class->status == 'Scheduled') ? 'selected' : ''; ?>>Scheduled</option>
                                    <option value="Active" <?php echo ($class->status == 'Active') ? 'selected' : ''; ?>>Active</option>
                                    <option value="Completed" <?php echo ($class->status == 'Completed') ? 'selected' : ''; ?>>Completed</option>
                                    <option value="Cancelled" <?php echo ($class->status == 'Cancelled') ? 'selected' : ''; ?>>Cancelled</option>
                                </select>
                            </div>
                        </div>
                        <?php endif; ?>
                    </div>

                    <?php if (isset($class)): ?>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>
                                    <input type="checkbox" name="is_active" value="1" <?php echo $class->is_active ? 'checked' : ''; ?>>
                                    Active
                                </label>
                            </div>
                        </div>
                    </div>
                    <?php endif; ?>

                    <?php if (!isset($class)): ?>
                    <div class="callout callout-success" id="class_code_preview" style="display:none;">
                        <h4>Generated Class Code</h4>
                        <p><strong id="preview_code"></strong></p>
                        <small class="text-muted">Format: SUBJECT_CODE-LEVEL_CODE-COHORT-YEAR</small>
                    </div>
                    <?php else: ?>
                    <div class="callout callout-success">
                        <h4>Current Class Code</h4>
                        <p><strong><?php echo htmlspecialchars($class->class_code); ?></strong></p>
                    </div>
                    <?php endif; ?>
                </div>
                <div class="box-footer">
                    <a href="<?php echo base_url('admin/academic/classes'); ?>" class="btn btn-default">Cancel</a>
                    <button type="submit" class="btn btn-primary pull-right">
                        <i class="fa fa-save"></i> <?php echo isset($class) ? 'Update Class' : 'Create Class'; ?>
                    </button>
                </div>
            </form>
        </div>
    </section>
</div>

<script>
function loadSubjectLevels() {
    var programmeId = $('#programme_id').val();
    if (!programmeId) {
        $('#subject_level_id').html('<option value="">-- Select Programme First --</option>');
        return;
    }

    $.ajax({
        url: '<?php echo base_url('admin/academic/ajax_get_subject_levels/'); ?>' + programmeId,
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            var html = '<option value="">-- Select Subject at Level --</option>';
            $.each(data, function(i, item) {
                html += '<option value="' + item.id + '" data-subject="' + item.subject_code + '" data-level="' + item.level_code + '">';
                html += item.subject_name + ' (' + item.subject_code + ') - ' + item.level_code;
                html += '</option>';
            });
            $('#subject_level_id').html(html);
        }
    });
}

// Preview class code
$('#subject_level_id, input[name="cohort_name"], input[name="academic_year"]').on('change keyup', function() {
    var subjectLevel = $('#subject_level_id option:selected');
    var subjectCode = subjectLevel.data('subject');
    var levelCode = subjectLevel.data('level');
    var cohort = $('input[name="cohort_name"]').val();
    var year = $('input[name="academic_year"]').val();

    if (subjectCode && levelCode && cohort && year) {
        var code = subjectCode.toUpperCase() + '-' + levelCode.toUpperCase() + '-' + cohort.toUpperCase() + '-' + year;
        $('#preview_code').text(code);
        $('#class_code_preview').show();
    } else {
        $('#class_code_preview').hide();
    }
});
</script>
