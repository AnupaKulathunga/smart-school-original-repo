<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-users"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Class List (Subject + Level + Cohort)</h3>
                <div class="box-tools pull-right">
                    <?php if ($this->rbac->hasPrivilege('academic_classes', 'can_add')): ?>
                    <a href="<?php echo base_url('admin/academic/class_add'); ?>" class="btn btn-primary btn-sm">
                        <i class="fa fa-plus"></i> Add Class
                    </a>
                    <?php endif; ?>
                </div>
            </div>
            <div class="box-body">
                <!-- Filters -->
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-3">
                        <label>Filter by Programme</label>
                        <select class="form-control select2" id="filter_programme" onchange="filterClasses()">
                            <option value="">-- All Programmes --</option>
                            <?php foreach ($programmes as $p): ?>
                            <option value="<?php echo $p->id; ?>" <?php echo ($selected_programme_id == $p->id) ? 'selected' : ''; ?>>
                                <?php echo htmlspecialchars($p->name); ?>
                            </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label>Filter by Level</label>
                        <select class="form-control select2" id="filter_level" onchange="filterClasses()">
                            <option value="">-- All Levels --</option>
                            <?php foreach ($levels as $l): ?>
                            <option value="<?php echo $l->id; ?>" <?php echo ($selected_level_id == $l->id) ? 'selected' : ''; ?>>
                                <?php echo htmlspecialchars($l->code . ' - ' . $l->name); ?>
                            </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover" id="classTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Class Code</th>
                                <th>Subject</th>
                                <th>Level</th>
                                <th>Cohort</th>
                                <th>Year</th>
                                <th>Lecturer</th>
                                <th>Students</th>
                                <th>Mode</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($classes)): ?>
                            <?php $i = 1; foreach ($classes as $class): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><strong><?php echo htmlspecialchars($class->class_code); ?></strong></td>
                                <td>
                                    <?php echo htmlspecialchars($class->subject_name); ?>
                                    <br><small class="text-muted"><?php echo htmlspecialchars($class->programme_name); ?></small>
                                </td>
                                <td>
                                    <span class="label label-info"><?php echo htmlspecialchars($class->level_code); ?></span>
                                    <?php if ($class->nqf_level): ?>
                                    <br><small class="text-muted">NQF <?php echo $class->nqf_level; ?></small>
                                    <?php endif; ?>
                                </td>
                                <td><span class="badge bg-purple"><?php echo htmlspecialchars($class->cohort_name); ?></span></td>
                                <td><?php echo $class->academic_year; ?></td>
                                <td><?php echo $class->lecturer_name ? htmlspecialchars($class->lecturer_name . ' ' . $class->lecturer_surname) : '<span class="text-muted">Not Assigned</span>'; ?></td>
                                <td class="text-center">
                                    <span class="badge bg-blue"><?php echo $class->student_count; ?></span> / <?php echo $class->max_students; ?>
                                </td>
                                <td><span class="label label-default"><?php echo $class->delivery_mode; ?></span></td>
                                <td>
                                    <?php
                                    $status_colors = ['Scheduled' => 'default', 'Active' => 'success', 'Completed' => 'info', 'Cancelled' => 'danger'];
                                    $color = isset($status_colors[$class->status]) ? $status_colors[$class->status] : 'default';
                                    ?>
                                    <span class="label label-<?php echo $color; ?>"><?php echo $class->status; ?></span>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group">
                                        <a href="<?php echo base_url('admin/academic/class_roster/' . $class->id); ?>"
                                           class="btn btn-info btn-xs" title="View Roster">
                                            <i class="fa fa-users"></i>
                                        </a>
                                        <a href="<?php echo base_url('admin/academic/mark_attendance/' . $class->id); ?>"
                                           class="btn btn-success btn-xs" title="Mark Attendance">
                                            <i class="fa fa-clipboard-check"></i>
                                        </a>
                                        <?php if ($this->rbac->hasPrivilege('academic_classes', 'can_edit')): ?>
                                        <a href="<?php echo base_url('admin/academic/class_edit/' . $class->id); ?>"
                                           class="btn btn-primary btn-xs" title="Edit">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                        <?php endif; ?>
                                        <?php if ($this->rbac->hasPrivilege('academic_classes', 'can_delete')): ?>
                                        <a href="<?php echo base_url('admin/academic/class_delete/' . $class->id); ?>"
                                           class="btn btn-danger btn-xs" title="Delete"
                                           onclick="return confirm('Are you sure you want to delete this class?');">
                                            <i class="fa fa-trash"></i>
                                        </a>
                                        <?php endif; ?>
                                    </div>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php else: ?>
                            <tr>
                                <td colspan="11" class="text-center">No classes found. <a href="<?php echo base_url('admin/academic/class_add'); ?>">Create one now</a></td>
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
        if ($('#classTable').length) {
            $('#classTable').DataTable({
                "ordering": true,
                "pageLength": 25,
                "order": [[1, 'asc']]
            });
        }
    } catch(e) { console.log(e); }
});

function filterClasses() {
    var programmeId = $('#filter_programme').val();
    var levelId = $('#filter_level').val();
    var url = '<?php echo base_url('admin/academic/classes'); ?>?';

    if (programmeId) url += 'programme_id=' + programmeId + '&';
    if (levelId) url += 'level_id=' + levelId + '&';

    window.location.href = url;
}
</script>
