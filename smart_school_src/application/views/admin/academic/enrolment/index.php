<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-user-plus"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Student Enrolment</h3>
                <div class="box-tools pull-right">
                    <?php if ($this->rbac->hasPrivilege('academic_enrolment', 'can_add')): ?>
                    <a href="<?php echo base_url('admin/academic/enrol_student'); ?>" class="btn btn-primary btn-sm">
                        <i class="fa fa-plus"></i> Enrol Student
                    </a>
                    <?php endif; ?>
                </div>
            </div>
            <div class="box-body">
                <!-- Class Filter -->
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-4">
                        <label>Select Class</label>
                        <select class="form-control select2" id="filter_class" onchange="filterByClass()">
                            <option value="">-- Select Class --</option>
                            <?php foreach ($classes as $c): ?>
                            <option value="<?php echo $c->id; ?>" <?php echo ($selected_class_id == $c->id) ? 'selected' : ''; ?>>
                                <?php echo htmlspecialchars($c->class_code . ' - ' . $c->subject_name . ' ' . $c->level_code); ?>
                            </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>

                <?php if (!empty($selected_class_id) && isset($class)): ?>
                <div class="alert alert-info">
                    <strong>Class:</strong> <?php echo htmlspecialchars($class->class_code); ?> |
                    <strong>Subject:</strong> <?php echo htmlspecialchars($class->subject_name); ?> |
                    <strong>Level:</strong> <?php echo htmlspecialchars($class->level_code); ?> |
                    <strong>Enrolled:</strong> <?php echo count($enrolments); ?> / <?php echo $class->max_students; ?>
                </div>
                <?php endif; ?>

                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover" id="enrolmentTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Student No</th>
                                <th>Name</th>
                                <th>Class</th>
                                <th>Subject</th>
                                <th>Level</th>
                                <th>Enrolled Date</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($enrolments)): ?>
                            <?php $i = 1; foreach ($enrolments as $e): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><?php echo htmlspecialchars($e->admission_no); ?></td>
                                <td><strong><?php echo htmlspecialchars($e->firstname . ' ' . $e->lastname); ?></strong></td>
                                <td><?php echo htmlspecialchars($e->class_code); ?></td>
                                <td><?php echo htmlspecialchars($e->subject_name); ?></td>
                                <td><span class="label label-info"><?php echo $e->level_code; ?></span></td>
                                <td><?php echo date('d M Y', strtotime($e->enrolment_date)); ?></td>
                                <td>
                                    <?php
                                    $status_colors = ['Active' => 'success', 'Completed' => 'info', 'Dropped' => 'danger', 'Suspended' => 'warning', 'Transferred' => 'default'];
                                    $color = isset($status_colors[$e->status]) ? $status_colors[$e->status] : 'default';
                                    ?>
                                    <span class="label label-<?php echo $color; ?>"><?php echo $e->status; ?></span>
                                </td>
                                <td class="text-center">
                                    <?php if ($this->rbac->hasPrivilege('academic_enrolment', 'can_delete')): ?>
                                    <a href="<?php echo base_url('admin/academic/remove_enrolment/' . $e->id); ?>"
                                       class="btn btn-danger btn-xs" title="Remove"
                                       onclick="return confirm('Remove this enrolment?');">
                                        <i class="fa fa-times"></i>
                                    </a>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php else: ?>
                            <tr>
                                <td colspan="9" class="text-center">
                                    <?php if ($selected_class_id): ?>
                                    No students enrolled in this class.
                                    <?php else: ?>
                                    Please select a class to view enrolments.
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</div>

<script>
$(document).ready(function() {
    try {
        if ($('#enrolmentTable').length) {
            $('#enrolmentTable').DataTable({
                "ordering": true,
                "pageLength": 50
            });
        }
    } catch(e) { console.log(e); }
});

function filterByClass() {
    var classId = $('#filter_class').val();
    if (classId) {
        window.location.href = '<?php echo base_url('admin/academic/enrolment'); ?>?class_id=' + classId;
    } else {
        window.location.href = '<?php echo base_url('admin/academic/enrolment'); ?>';
    }
}
</script>
