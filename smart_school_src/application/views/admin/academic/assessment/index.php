<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-file-alt"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Assessment List</h3>
                <div class="box-tools pull-right">
                    <?php if ($this->rbac->hasPrivilege('academic_assessments', 'can_add')): ?>
                    <a href="<?php echo base_url('admin/academic/assessment_add'); ?>" class="btn btn-primary btn-sm">
                        <i class="fa fa-plus"></i> Add Assessment
                    </a>
                    <?php endif; ?>
                </div>
            </div>
            <div class="box-body">
                <!-- Filter -->
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-4">
                        <label>Filter by Class</label>
                        <select class="form-control select2" id="filter_class" onchange="filterAssessments()">
                            <option value="">-- All Classes --</option>
                            <?php foreach ($classes as $c): ?>
                            <option value="<?php echo $c->id; ?>" <?php echo ($selected_class_id == $c->id) ? 'selected' : ''; ?>>
                                <?php echo htmlspecialchars($c->class_code . ' - ' . $c->subject_name); ?>
                            </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover" id="assessmentTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Title</th>
                                <th>Class</th>
                                <th>Type</th>
                                <th>Total Marks</th>
                                <th>Weight %</th>
                                <th>Due Date</th>
                                <th>Status</th>
                                <th>Marked</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($assessments)): ?>
                            <?php $i = 1; foreach ($assessments as $a): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><strong><?php echo htmlspecialchars($a->title); ?></strong></td>
                                <td>
                                    <?php echo htmlspecialchars($a->class_code); ?>
                                    <br><small class="text-muted"><?php echo htmlspecialchars($a->subject_name); ?></small>
                                </td>
                                <td><span class="label label-default"><?php echo $a->assessment_type; ?></span></td>
                                <td class="text-center"><?php echo $a->total_marks; ?></td>
                                <td class="text-center"><?php echo $a->weight_percentage ? $a->weight_percentage . '%' : '-'; ?></td>
                                <td><?php echo $a->due_date ? date('d M Y', strtotime($a->due_date)) : '-'; ?></td>
                                <td>
                                    <?php
                                    $status_colors = ['Draft' => 'default', 'Pending Moderation' => 'warning', 'Approved' => 'success', 'Rejected' => 'danger'];
                                    $color = isset($status_colors[$a->moderation_status]) ? $status_colors[$a->moderation_status] : 'default';
                                    ?>
                                    <span class="label label-<?php echo $color; ?>"><?php echo $a->moderation_status; ?></span>
                                    <?php if ($a->is_published): ?>
                                    <span class="label label-info">Published</span>
                                    <?php endif; ?>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-blue"><?php echo $a->marks_count; ?></span>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group">
                                        <a href="<?php echo base_url('admin/academic/marks_entry/' . $a->id); ?>"
                                           class="btn btn-success btn-xs" title="Enter Marks">
                                            <i class="fa fa-pencil"></i>
                                        </a>
                                        <?php if ($this->rbac->hasPrivilege('academic_assessments', 'can_edit')): ?>
                                        <a href="<?php echo base_url('admin/academic/assessment_edit/' . $a->id); ?>"
                                           class="btn btn-primary btn-xs" title="Edit">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                        <?php endif; ?>
                                        <?php if ($this->rbac->hasPrivilege('academic_assessments', 'can_delete')): ?>
                                        <a href="<?php echo base_url('admin/academic/assessment_delete/' . $a->id); ?>"
                                           class="btn btn-danger btn-xs" title="Delete"
                                           onclick="return confirm('Are you sure you want to delete this assessment?');">
                                            <i class="fa fa-trash"></i>
                                        </a>
                                        <?php endif; ?>
                                    </div>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php else: ?>
                            <tr>
                                <td colspan="10" class="text-center">No assessments found</td>
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
        if ($('#assessmentTable').length) {
            $('#assessmentTable').DataTable({
                "ordering": true,
                "pageLength": 25,
                "order": [[6, 'desc']]
            });
        }
    } catch(e) { console.log(e); }
});

function filterAssessments() {
    var classId = $('#filter_class').val();
    if (classId) {
        window.location.href = '<?php echo base_url('admin/academic/assessments'); ?>?class_id=' + classId;
    } else {
        window.location.href = '<?php echo base_url('admin/academic/assessments'); ?>';
    }
}
</script>
