<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-clipboard-check"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Select Class for Attendance</h3>
            </div>
            <div class="box-body">
                <div class="callout callout-info">
                    <h4>How to Mark Attendance</h4>
                    <p>Select a class below, or use the <strong>Subject &rarr; Level &rarr; Cohort</strong> cascade on the Mark Attendance page.</p>
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
                                <th>Lecturer</th>
                                <th>Students</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($classes)): ?>
                            <?php $i = 1; foreach ($classes as $c): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><strong><?php echo htmlspecialchars($c->class_code); ?></strong></td>
                                <td><?php echo htmlspecialchars($c->subject_name); ?></td>
                                <td><span class="label label-info"><?php echo $c->level_code; ?></span></td>
                                <td><span class="badge bg-purple"><?php echo $c->cohort_name; ?></span></td>
                                <td><?php echo $c->lecturer_name ? htmlspecialchars($c->lecturer_name . ' ' . $c->lecturer_surname) : '-'; ?></td>
                                <td class="text-center">
                                    <span class="badge bg-green"><?php echo $c->student_count; ?></span>
                                </td>
                                <td class="text-center">
                                    <a href="<?php echo base_url('admin/academic/mark_attendance/' . $c->id); ?>"
                                       class="btn btn-primary btn-sm">
                                        <i class="fa fa-clipboard-check"></i> Mark Attendance
                                    </a>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php else: ?>
                            <tr>
                                <td colspan="8" class="text-center">No active classes found</td>
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
                "pageLength": 25
            });
        }
    } catch(e) { console.log(e); }
});
</script>
