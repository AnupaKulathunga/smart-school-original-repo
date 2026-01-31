<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-graduation-cap"></i> <?php echo $title; ?>
        </h1>
    </section>
    <section class="content">
        <?php if ($this->session->flashdata('msg')) { ?>
            <?php echo $this->session->flashdata('msg'); ?>
        <?php } ?>

        <?php if ($class): ?>
        <!-- Class Info -->
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><?php echo htmlspecialchars($class['class_code']); ?></h3>
                <div class="box-tools pull-right">
                    <a href="<?php echo base_url('user/tvetportal/my_classes'); ?>" class="btn btn-default btn-sm">
                        <i class="fa fa-arrow-left"></i> Back
                    </a>
                </div>
            </div>
            <div class="box-body">
                <div class="row">
                    <div class="col-md-6">
                        <table class="table table-bordered">
                            <tr>
                                <th width="40%">Subject</th>
                                <td><?php echo htmlspecialchars($class['subject_name']); ?></td>
                            </tr>
                            <tr>
                                <th>Level</th>
                                <td>
                                    <span class="label label-info"><?php echo htmlspecialchars($class['level_code']); ?></span>
                                    <?php echo htmlspecialchars($class['level_name']); ?>
                                </td>
                            </tr>
                            <tr>
                                <th>Cohort</th>
                                <td><?php echo htmlspecialchars($class['cohort_name']); ?></td>
                            </tr>
                            <tr>
                                <th>Academic Year</th>
                                <td><?php echo $class['academic_year']; ?></td>
                            </tr>
                        </table>
                    </div>
                    <div class="col-md-6">
                        <table class="table table-bordered">
                            <tr>
                                <th width="40%">Lecturer</th>
                                <td>
                                    <?php if (isset($class['lecturer_name']) && $class['lecturer_name']) { ?>
                                        <?php echo htmlspecialchars($class['lecturer_name'] . ' ' . $class['lecturer_surname']); ?>
                                    <?php } else { ?>
                                        <span class="text-muted">Not assigned</span>
                                    <?php } ?>
                                </td>
                            </tr>
                            <tr>
                                <th>Venue</th>
                                <td><?php echo isset($class['venue']) && $class['venue'] ? htmlspecialchars($class['venue']) : '-'; ?></td>
                            </tr>
                            <tr>
                                <th>Delivery Mode</th>
                                <td><?php echo isset($class['delivery_mode']) ? $class['delivery_mode'] : 'Contact'; ?></td>
                            </tr>
                            <tr>
                                <th>Status</th>
                                <td>
                                    <?php
                                    $status = isset($class['status']) ? $class['status'] : 'Active';
                                    $status_colors = array('Active' => 'success', 'Completed' => 'info', 'Scheduled' => 'default', 'Cancelled' => 'danger');
                                    $color = isset($status_colors[$status]) ? $status_colors[$status] : 'default';
                                    ?>
                                    <span class="label label-<?php echo $color; ?>"><?php echo $status; ?></span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Attendance Summary -->
        <?php if (isset($attendance_summary) && $attendance_summary) { ?>
        <div class="box box-info">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-check-square-o"></i> My Attendance Summary</h3>
            </div>
            <div class="box-body">
                <div class="row">
                    <div class="col-xs-3 text-center">
                        <h2 class="text-green"><?php echo $attendance_summary->present; ?></h2>
                        <p>Present</p>
                    </div>
                    <div class="col-xs-3 text-center">
                        <h2 class="text-red"><?php echo $attendance_summary->absent; ?></h2>
                        <p>Absent</p>
                    </div>
                    <div class="col-xs-3 text-center">
                        <h2 class="text-yellow"><?php echo $attendance_summary->late; ?></h2>
                        <p>Late</p>
                    </div>
                    <div class="col-xs-3 text-center">
                        <h2 class="text-aqua"><?php echo $attendance_summary->percentage; ?>%</h2>
                        <p>Attendance Rate</p>
                    </div>
                </div>
            </div>
        </div>
        <?php } ?>

        <!-- Assessments -->
        <div class="box box-success">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-file-text"></i> Assessments</h3>
            </div>
            <div class="box-body">
                <?php if (!empty($assessments)) { ?>
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Assessment</th>
                                <th>Type</th>
                                <th>Total Marks</th>
                                <th>Weight</th>
                                <th>Due Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($assessments as $assessment) { ?>
                            <tr>
                                <td><?php echo htmlspecialchars($assessment['title']); ?></td>
                                <td><span class="label label-default"><?php echo $assessment['assessment_type']; ?></span></td>
                                <td><?php echo $assessment['total_marks']; ?></td>
                                <td><?php echo isset($assessment['weight_percentage']) && $assessment['weight_percentage'] ? $assessment['weight_percentage'] . '%' : '-'; ?></td>
                                <td>
                                    <?php if (isset($assessment['due_date']) && $assessment['due_date']) { ?>
                                        <?php echo date('d M Y', strtotime($assessment['due_date'])); ?>
                                    <?php } else { ?>
                                        -
                                    <?php } ?>
                                </td>
                            </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
                <?php } else { ?>
                <p class="text-muted">No assessments published yet for this class.</p>
                <?php } ?>
            </div>
        </div>
        <?php else: ?>
        <div class="alert alert-danger">
            Class not found.
        </div>
        <?php endif; ?>
    </section>
</div>
