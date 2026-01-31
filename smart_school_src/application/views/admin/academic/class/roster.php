<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-users"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="row">
            <!-- Class Info -->
            <div class="col-md-4">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">Class Details</h3>
                    </div>
                    <div class="box-body">
                        <dl class="dl-horizontal">
                            <dt>Class Code:</dt>
                            <dd><strong><?php echo htmlspecialchars($class->class_code); ?></strong></dd>
                            <dt>Subject:</dt>
                            <dd><?php echo htmlspecialchars($class->subject_name); ?> (<?php echo $class->subject_code; ?>)</dd>
                            <dt>Level:</dt>
                            <dd><span class="label label-info"><?php echo $class->level_code; ?></span> <?php echo $class->level_name; ?></dd>
                            <dt>Programme:</dt>
                            <dd><?php echo htmlspecialchars($class->programme_name); ?></dd>
                            <dt>Cohort:</dt>
                            <dd><span class="badge bg-purple"><?php echo htmlspecialchars($class->cohort_name); ?></span></dd>
                            <dt>Year:</dt>
                            <dd><?php echo $class->academic_year; ?></dd>
                            <dt>Lecturer:</dt>
                            <dd><?php echo $class->lecturer_name ? htmlspecialchars($class->lecturer_name . ' ' . $class->lecturer_surname) : '<span class="text-muted">Not Assigned</span>'; ?></dd>
                            <dt>Venue:</dt>
                            <dd><?php echo $class->venue ?: '-'; ?></dd>
                            <dt>Capacity:</dt>
                            <dd><?php echo $stats->enrolled; ?> / <?php echo $class->max_students; ?></dd>
                            <dt>Status:</dt>
                            <dd>
                                <?php
                                $status_colors = ['Scheduled' => 'default', 'Active' => 'success', 'Completed' => 'info', 'Cancelled' => 'danger'];
                                $color = isset($status_colors[$class->status]) ? $status_colors[$class->status] : 'default';
                                ?>
                                <span class="label label-<?php echo $color; ?>"><?php echo $class->status; ?></span>
                            </dd>
                        </dl>
                    </div>
                    <div class="box-footer">
                        <a href="<?php echo base_url('admin/academic/mark_attendance/' . $class->id); ?>" class="btn btn-success btn-sm">
                            <i class="fa fa-clipboard-check"></i> Mark Attendance
                        </a>
                        <a href="<?php echo base_url('admin/academic/assessments?class_id=' . $class->id); ?>" class="btn btn-warning btn-sm">
                            <i class="fa fa-file-alt"></i> Assessments
                        </a>
                    </div>
                </div>

                <!-- Stats -->
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Statistics</h3>
                    </div>
                    <div class="box-body">
                        <dl class="dl-horizontal">
                            <dt>Enrolled:</dt>
                            <dd><strong><?php echo $stats->enrolled; ?></strong> students</dd>
                            <dt>Assessments:</dt>
                            <dd><?php echo $stats->assessments; ?></dd>
                            <dt>Avg Attendance:</dt>
                            <dd>
                                <?php if ($stats->avg_attendance > 0): ?>
                                <span class="label label-<?php echo $stats->avg_attendance >= 80 ? 'success' : ($stats->avg_attendance >= 60 ? 'warning' : 'danger'); ?>">
                                    <?php echo $stats->avg_attendance; ?>%
                                </span>
                                <?php else: ?>
                                -
                                <?php endif; ?>
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>

            <!-- Student Roster -->
            <div class="col-md-8">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Enrolled Students (<?php echo count($students); ?>)</h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo base_url('admin/academic/enrol_student?class_id=' . $class->id); ?>" class="btn btn-primary btn-sm">
                                <i class="fa fa-user-plus"></i> Enrol Student
                            </a>
                            <a href="<?php echo base_url('admin/academic/classes'); ?>" class="btn btn-default btn-sm">
                                <i class="fa fa-arrow-left"></i> Back
                            </a>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover" id="rosterTable">
                                <thead>
                                    <tr>
                                        <th width="5%">#</th>
                                        <th width="10%">Photo</th>
                                        <th width="15%">Student No</th>
                                        <th width="25%">Name</th>
                                        <th width="15%">Enrolled</th>
                                        <th width="10%">Status</th>
                                        <th width="10%">Final</th>
                                        <th width="10%" class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (!empty($students)): ?>
                                    <?php $i = 1; foreach ($students as $s): ?>
                                    <tr>
                                        <td><?php echo $i++; ?></td>
                                        <td>
                                            <?php if ($s->image): ?>
                                            <img src="<?php echo base_url('uploads/student_images/' . $s->image); ?>"
                                                 class="img-circle" style="width:40px;height:40px;" alt="">
                                            <?php else: ?>
                                            <img src="<?php echo base_url('backend/images/user.png'); ?>"
                                                 class="img-circle" style="width:40px;height:40px;" alt="">
                                            <?php endif; ?>
                                        </td>
                                        <td><?php echo htmlspecialchars($s->admission_no); ?></td>
                                        <td>
                                            <strong><?php echo htmlspecialchars($s->firstname . ' ' . $s->lastname); ?></strong>
                                            <?php if ($s->email): ?>
                                            <br><small class="text-muted"><?php echo $s->email; ?></small>
                                            <?php endif; ?>
                                        </td>
                                        <td><?php echo date('d M Y', strtotime($s->enrolment_date)); ?></td>
                                        <td>
                                            <?php
                                            $status_colors = ['Active' => 'success', 'Completed' => 'info', 'Dropped' => 'danger', 'Suspended' => 'warning', 'Transferred' => 'default'];
                                            $color = isset($status_colors[$s->status]) ? $status_colors[$s->status] : 'default';
                                            ?>
                                            <span class="label label-<?php echo $color; ?>"><?php echo $s->status; ?></span>
                                        </td>
                                        <td>
                                            <?php if ($s->final_mark !== null): ?>
                                            <strong><?php echo $s->final_mark; ?>%</strong>
                                            <?php if ($s->final_result): ?>
                                            <br><span class="label label-<?php echo $s->final_result == 'Pass' ? 'success' : 'danger'; ?>">
                                                <?php echo $s->final_result; ?>
                                            </span>
                                            <?php endif; ?>
                                            <?php else: ?>
                                            -
                                            <?php endif; ?>
                                        </td>
                                        <td class="text-center">
                                            <?php if ($this->rbac->hasPrivilege('academic_enrolment', 'can_delete')): ?>
                                            <a href="<?php echo base_url('admin/academic/remove_enrolment/' . $s->enrolment_id); ?>"
                                               class="btn btn-danger btn-xs" title="Remove"
                                               onclick="return confirm('Remove this student from the class?');">
                                                <i class="fa fa-times"></i>
                                            </a>
                                            <?php endif; ?>
                                        </td>
                                    </tr>
                                    <?php endforeach; ?>
                                    <?php else: ?>
                                    <tr>
                                        <td colspan="8" class="text-center">
                                            No students enrolled.
                                            <a href="<?php echo base_url('admin/academic/enrol_student?class_id=' . $class->id); ?>">Enrol students now</a>
                                        </td>
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
    try {
        if ($('#rosterTable').length) {
            $('#rosterTable').DataTable({
                "ordering": true,
                "pageLength": 50
            });
        }
    } catch(e) { console.log(e); }
});
</script>
