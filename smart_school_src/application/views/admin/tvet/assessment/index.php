<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-file-text"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Assessment List</h3>
                <div class="box-tools pull-right">
                    <a href="<?php echo base_url('admin/tvet/assessment_add'); ?>" class="btn btn-primary btn-sm">
                        <i class="fa fa-plus"></i> Add Assessment
                    </a>
                </div>
            </div>
            <div class="box-body">
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-4">
                        <label>Filter by Cohort</label>
                        <select class="form-control select2" id="filter_cohort" onchange="filterByCohort()">
                            <option value="">-- All Cohorts --</option>
                            <?php foreach ($cohorts as $cohort): ?>
                            <option value="<?php echo $cohort['id']; ?>" <?php echo ($selected_cohort_id == $cohort['id']) ? 'selected' : ''; ?>>
                                <?php echo htmlspecialchars($cohort['name']); ?>
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
                                <th>Type</th>
                                <th>Cohort</th>
                                <th>Module</th>
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
                            <?php $i = 1; foreach ($assessments as $assessment): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><strong><?php echo htmlspecialchars($assessment['title']); ?></strong></td>
                                <td><span class="label label-default"><?php echo $assessment['assessment_type']; ?></span></td>
                                <td><?php echo htmlspecialchars($assessment['cohort_name']); ?></td>
                                <td><?php echo htmlspecialchars($assessment['module_name']); ?></td>
                                <td class="text-center"><?php echo $assessment['total_marks']; ?></td>
                                <td class="text-center"><?php echo $assessment['weight_percentage']; ?>%</td>
                                <td><?php echo $assessment['due_date'] ? date('d M Y', strtotime($assessment['due_date'])) : '-'; ?></td>
                                <td>
                                    <?php
                                    $status = $assessment['status'] ?? 'Draft';
                                    $status_colors = ['Draft' => 'default', 'Published' => 'info', 'Active' => 'success', 'Closed' => 'warning', 'Archived' => 'danger'];
                                    $color = isset($status_colors[$status]) ? $status_colors[$status] : 'default';
                                    ?>
                                    <span class="label label-<?php echo $color; ?>"><?php echo $status; ?></span>
                                </td>
                                <td class="text-center">
                                    <span class="badge bg-blue"><?php echo $assessment['marks_count'] ?? 0; ?></span>
                                </td>
                                <td class="text-center">
                                    <div class="btn-group">
                                        <a href="<?php echo base_url('admin/tvet/marks_entry/' . $assessment['id']); ?>"
                                           class="btn btn-success btn-xs" title="Enter Marks">
                                            <i class="fa fa-pencil"></i>
                                        </a>
                                        <a href="<?php echo base_url('admin/tvet/assessment_edit/' . $assessment['id']); ?>"
                                           class="btn btn-primary btn-xs" title="Edit">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                        <a href="<?php echo base_url('admin/tvet/assessment_delete/' . $assessment['id']); ?>"
                                           class="btn btn-danger btn-xs" title="Delete"
                                           onclick="return confirm('Are you sure you want to delete this assessment?');">
                                            <i class="fa fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php else: ?>
                            <tr>
                                <td colspan="11" class="text-center">No assessments found</td>
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
    $('#assessmentTable').DataTable({
        "ordering": true,
        "pageLength": 25,
        "order": [[0, 'desc']]
    });
});

function filterByCohort() {
    var cohortId = $('#filter_cohort').val();
    if (cohortId) {
        window.location.href = '<?php echo base_url('admin/tvet/assessments'); ?>?cohort_id=' + cohortId;
    } else {
        window.location.href = '<?php echo base_url('admin/tvet/assessments'); ?>';
    }
}
</script>
