<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <!-- Statistics Boxes -->
        <div class="row">
            <div class="col-lg-2 col-xs-6">
                <div class="small-box bg-aqua">
                    <div class="inner">
                        <h3><?php echo $stats['programmes']; ?></h3>
                        <p>Programmes</p>
                    </div>
                    <div class="icon"><i class="fa fa-university"></i></div>
                    <a href="<?php echo base_url('admin/academic/programmes'); ?>" class="small-box-footer">
                        View <i class="fa fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>
            <div class="col-lg-2 col-xs-6">
                <div class="small-box bg-green">
                    <div class="inner">
                        <h3><?php echo $stats['subjects']; ?></h3>
                        <p>Subjects</p>
                    </div>
                    <div class="icon"><i class="fa fa-book"></i></div>
                    <a href="<?php echo base_url('admin/academic/subjects'); ?>" class="small-box-footer">
                        View <i class="fa fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>
            <div class="col-lg-2 col-xs-6">
                <div class="small-box bg-yellow">
                    <div class="inner">
                        <h3><?php echo $stats['levels']; ?></h3>
                        <p>Levels</p>
                    </div>
                    <div class="icon"><i class="fa fa-layer-group"></i></div>
                    <a href="<?php echo base_url('admin/academic/levels'); ?>" class="small-box-footer">
                        View <i class="fa fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>
            <div class="col-lg-2 col-xs-6">
                <div class="small-box bg-purple">
                    <div class="inner">
                        <h3><?php echo $stats['classes']; ?></h3>
                        <p>Classes</p>
                    </div>
                    <div class="icon"><i class="fa fa-users"></i></div>
                    <a href="<?php echo base_url('admin/academic/classes'); ?>" class="small-box-footer">
                        View <i class="fa fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>
            <div class="col-lg-2 col-xs-6">
                <div class="small-box bg-red">
                    <div class="inner">
                        <h3><?php echo $stats['enrolled']; ?></h3>
                        <p>Enrolled Students</p>
                    </div>
                    <div class="icon"><i class="fa fa-user-graduate"></i></div>
                    <a href="<?php echo base_url('admin/academic/enrolment'); ?>" class="small-box-footer">
                        View <i class="fa fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>
            <div class="col-lg-2 col-xs-6">
                <div class="small-box bg-maroon">
                    <div class="inner">
                        <h3><?php echo $stats['assessments']; ?></h3>
                        <p>Assessments</p>
                    </div>
                    <div class="icon"><i class="fa fa-file-alt"></i></div>
                    <a href="<?php echo base_url('admin/academic/assessments'); ?>" class="small-box-footer">
                        View <i class="fa fa-arrow-circle-right"></i>
                    </a>
                </div>
            </div>
        </div>

        <!-- Quick Links -->
        <div class="row">
            <div class="col-md-6">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-bolt"></i> Quick Actions</h3>
                    </div>
                    <div class="box-body">
                        <div class="row">
                            <div class="col-xs-6 col-md-4 text-center">
                                <a href="<?php echo base_url('admin/academic/class_add'); ?>" class="btn btn-primary btn-lg btn-block" style="margin-bottom: 10px;">
                                    <i class="fa fa-plus-circle"></i><br>Add Class
                                </a>
                            </div>
                            <div class="col-xs-6 col-md-4 text-center">
                                <a href="<?php echo base_url('admin/academic/enrol_student'); ?>" class="btn btn-success btn-lg btn-block" style="margin-bottom: 10px;">
                                    <i class="fa fa-user-plus"></i><br>Enrol Student
                                </a>
                            </div>
                            <div class="col-xs-6 col-md-4 text-center">
                                <a href="<?php echo base_url('admin/academic/attendance'); ?>" class="btn btn-info btn-lg btn-block" style="margin-bottom: 10px;">
                                    <i class="fa fa-clipboard-check"></i><br>Mark Attendance
                                </a>
                            </div>
                            <div class="col-xs-6 col-md-4 text-center">
                                <a href="<?php echo base_url('admin/academic/assessment_add'); ?>" class="btn btn-warning btn-lg btn-block" style="margin-bottom: 10px;">
                                    <i class="fa fa-file-alt"></i><br>Create Assessment
                                </a>
                            </div>
                            <div class="col-xs-6 col-md-4 text-center">
                                <a href="<?php echo base_url('admin/academic/subject_add'); ?>" class="btn btn-default btn-lg btn-block" style="margin-bottom: 10px;">
                                    <i class="fa fa-book"></i><br>Add Subject
                                </a>
                            </div>
                            <div class="col-xs-6 col-md-4 text-center">
                                <a href="<?php echo base_url('admin/academic/reports'); ?>" class="btn btn-danger btn-lg btn-block" style="margin-bottom: 10px;">
                                    <i class="fa fa-chart-bar"></i><br>Reports
                                </a>
                            </div>
                            <div class="col-xs-6 col-md-4 text-center">
                                <a href="<?php echo base_url('admin/academic/import'); ?>" class="btn btn-default btn-lg btn-block" style="margin-bottom: 10px; background-color: #605ca8; color: #fff;">
                                    <i class="fa fa-upload"></i><br>Bulk Import
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-info-circle"></i> Subject-Centric Model</h3>
                    </div>
                    <div class="box-body">
                        <div class="callout callout-info">
                            <h4>CLASS = Subject + Level + Cohort + Year</h4>
                            <p>In this TVET model, a <strong>Class</strong> is the central academic unit. Students enrol in classes, not directly in subjects.</p>
                            <p><strong>Example:</strong> <code>MATH-N4-A-2026</code></p>
                            <ul>
                                <li><strong>Subject:</strong> Mathematics</li>
                                <li><strong>Level:</strong> N4 (NQF Level 5)</li>
                                <li><strong>Cohort:</strong> A (Group of ~50 students)</li>
                                <li><strong>Year:</strong> 2026</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Classes -->
        <div class="row">
            <div class="col-md-12">
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-users"></i> Recent Classes</h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo base_url('admin/academic/classes'); ?>" class="btn btn-default btn-sm">
                                View All <i class="fa fa-arrow-right"></i>
                            </a>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th>Class Code</th>
                                        <th>Subject</th>
                                        <th>Level</th>
                                        <th>Cohort</th>
                                        <th>Lecturer</th>
                                        <th>Students</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (!empty($recent_classes)): ?>
                                    <?php $count = 0; foreach ($recent_classes as $class): ?>
                                    <?php if ($count++ >= 10) break; ?>
                                    <tr>
                                        <td><strong><?php echo htmlspecialchars($class->class_code); ?></strong></td>
                                        <td><?php echo htmlspecialchars($class->subject_name); ?></td>
                                        <td><span class="label label-info"><?php echo htmlspecialchars($class->level_code); ?></span></td>
                                        <td><?php echo htmlspecialchars($class->cohort_name); ?></td>
                                        <td><?php echo $class->lecturer_name ? htmlspecialchars($class->lecturer_name . ' ' . $class->lecturer_surname) : '-'; ?></td>
                                        <td class="text-center">
                                            <span class="badge bg-blue"><?php echo $class->student_count; ?></span> / <?php echo $class->max_students; ?>
                                        </td>
                                        <td>
                                            <?php
                                            $status_colors = ['Scheduled' => 'default', 'Active' => 'success', 'Completed' => 'info', 'Cancelled' => 'danger'];
                                            $color = isset($status_colors[$class->status]) ? $status_colors[$class->status] : 'default';
                                            ?>
                                            <span class="label label-<?php echo $color; ?>"><?php echo $class->status; ?></span>
                                        </td>
                                        <td>
                                            <a href="<?php echo base_url('admin/academic/class_roster/' . $class->id); ?>" class="btn btn-primary btn-xs" title="View Roster">
                                                <i class="fa fa-users"></i>
                                            </a>
                                            <a href="<?php echo base_url('admin/academic/mark_attendance/' . $class->id); ?>" class="btn btn-success btn-xs" title="Mark Attendance">
                                                <i class="fa fa-clipboard-check"></i>
                                            </a>
                                        </td>
                                    </tr>
                                    <?php endforeach; ?>
                                    <?php else: ?>
                                    <tr>
                                        <td colspan="8" class="text-center">No classes found. <a href="<?php echo base_url('admin/academic/class_add'); ?>">Create one now</a></td>
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
