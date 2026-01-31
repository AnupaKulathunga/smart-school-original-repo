<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-check-square-o"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Select Cohort for Attendance</h3>
            </div>
            <div class="box-body">
                <div class="row">
                    <div class="col-md-12">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover" id="cohortTable">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Cohort Code</th>
                                        <th>Cohort Name</th>
                                        <th>Programme</th>
                                        <th>Level</th>
                                        <th>Students</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (!empty($cohorts)): ?>
                                    <?php $i = 1; foreach ($cohorts as $cohort): ?>
                                    <tr>
                                        <td><?php echo $i++; ?></td>
                                        <td><strong><?php echo htmlspecialchars($cohort['code']); ?></strong></td>
                                        <td><?php echo htmlspecialchars($cohort['name']); ?></td>
                                        <td><?php echo htmlspecialchars($cohort['programme_name'] ?? '-'); ?></td>
                                        <td><span class="label label-info"><?php echo htmlspecialchars($cohort['level_name'] ?? '-'); ?></span></td>
                                        <td class="text-center">
                                            <span class="badge bg-green"><?php echo $cohort['student_count'] ?? 0; ?></span>
                                        </td>
                                        <td class="text-center">
                                            <a href="<?php echo base_url('admin/tvet/mark_attendance/' . $cohort['id']); ?>"
                                               class="btn btn-primary btn-sm">
                                                <i class="fa fa-check"></i> Mark Attendance
                                            </a>
                                        </td>
                                    </tr>
                                    <?php endforeach; ?>
                                    <?php else: ?>
                                    <tr>
                                        <td colspan="7" class="text-center">No cohorts found</td>
                                    </tr>
                                    <?php endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<script>
$(document).ready(function() {
    $('#cohortTable').DataTable({
        "ordering": true,
        "pageLength": 25
    });
});
</script>
