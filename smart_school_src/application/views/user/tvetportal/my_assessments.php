<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-file-text"></i> <?php echo $title; ?>
        </h1>
    </section>
    <section class="content">
        <?php if (!empty($assessments)) { ?>
        <!-- Categorize assessments -->
        <?php
        $upcoming = array_filter($assessments, function($a) {
            return isset($a['due_date']) && $a['due_date'] && strtotime($a['due_date']) >= strtotime(date('Y-m-d')) && !$a['student_marks'];
        });
        $completed = array_filter($assessments, function($a) {
            return !empty($a['student_marks']);
        });
        $past = array_filter($assessments, function($a) {
            return isset($a['due_date']) && $a['due_date'] && strtotime($a['due_date']) < strtotime(date('Y-m-d')) && !$a['student_marks'];
        });
        ?>

        <?php if (!empty($upcoming)) { ?>
        <div class="box box-warning">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-clock-o"></i> Upcoming Assessments</h3>
            </div>
            <div class="box-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Assessment</th>
                                <th>Class</th>
                                <th>Type</th>
                                <th>Total Marks</th>
                                <th>Due Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($upcoming as $assessment) { ?>
                            <tr>
                                <td><strong><?php echo htmlspecialchars($assessment['title']); ?></strong></td>
                                <td>
                                    <?php echo htmlspecialchars($assessment['class_code']); ?>
                                    <br><small class="text-muted"><?php echo htmlspecialchars($assessment['subject_name']); ?></small>
                                </td>
                                <td><span class="label label-default"><?php echo $assessment['assessment_type']; ?></span></td>
                                <td><?php echo $assessment['total_marks']; ?></td>
                                <td>
                                    <?php
                                    $days_until = floor((strtotime($assessment['due_date']) - time()) / 86400);
                                    $label_class = $days_until <= 3 ? 'label-danger' : ($days_until <= 7 ? 'label-warning' : 'label-info');
                                    ?>
                                    <span class="label <?php echo $label_class; ?>">
                                        <?php echo date('d M Y', strtotime($assessment['due_date'])); ?>
                                    </span>
                                    <?php if ($days_until <= 7 && $days_until >= 0) { ?>
                                    <br><small><?php echo $days_until; ?> days left</small>
                                    <?php } ?>
                                </td>
                            </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <?php } ?>

        <!-- Completed Assessments -->
        <?php if (!empty($completed)) { ?>
        <div class="box box-success">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-check-circle"></i> Completed Assessments</h3>
            </div>
            <div class="box-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Assessment</th>
                                <th>Class</th>
                                <th>Type</th>
                                <th class="text-center">Marks</th>
                                <th class="text-center">Percentage</th>
                                <th class="text-center">Grade</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($completed as $assessment) {
                                $marks = $assessment['student_marks'];
                            ?>
                            <tr class="<?php echo (isset($marks['percentage']) && $marks['percentage'] < 40) ? 'danger' : ''; ?>">
                                <td><?php echo htmlspecialchars($assessment['title']); ?></td>
                                <td>
                                    <?php echo htmlspecialchars($assessment['class_code']); ?>
                                    <br><small class="text-muted"><?php echo htmlspecialchars($assessment['subject_name']); ?></small>
                                </td>
                                <td><span class="label label-default"><?php echo $assessment['assessment_type']; ?></span></td>
                                <td class="text-center">
                                    <?php echo isset($marks['marks_obtained']) ? $marks['marks_obtained'] : '-'; ?> / <?php echo $assessment['total_marks']; ?>
                                </td>
                                <td class="text-center">
                                    <?php if (isset($marks['percentage'])) { ?>
                                    <span class="<?php echo ($marks['percentage'] < 40) ? 'text-danger' : 'text-success'; ?>">
                                        <?php echo number_format($marks['percentage'], 1); ?>%
                                    </span>
                                    <?php } else { echo '-'; } ?>
                                </td>
                                <td class="text-center">
                                    <?php if (isset($marks['grade'])) { ?>
                                    <span class="label label-<?php echo ($marks['grade'] == 'F') ? 'danger' : 'success'; ?>">
                                        <?php echo $marks['grade']; ?>
                                    </span>
                                    <?php } else { echo '-'; } ?>
                                </td>
                            </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <?php } ?>

        <!-- Overdue/Missed Assessments -->
        <?php if (!empty($past)) { ?>
        <div class="box box-danger">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-exclamation-triangle"></i> Overdue Assessments</h3>
            </div>
            <div class="box-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Assessment</th>
                                <th>Class</th>
                                <th>Type</th>
                                <th>Due Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($past as $assessment) { ?>
                            <tr>
                                <td><?php echo htmlspecialchars($assessment['title']); ?></td>
                                <td>
                                    <?php echo htmlspecialchars($assessment['class_code']); ?>
                                    <br><small class="text-muted"><?php echo htmlspecialchars($assessment['subject_name']); ?></small>
                                </td>
                                <td><span class="label label-default"><?php echo $assessment['assessment_type']; ?></span></td>
                                <td>
                                    <span class="text-danger">
                                        <?php echo date('d M Y', strtotime($assessment['due_date'])); ?>
                                        (Overdue)
                                    </span>
                                </td>
                            </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <?php } ?>

        <?php } else { ?>
        <div class="box box-default">
            <div class="box-body">
                <div class="alert alert-info">
                    <i class="fa fa-info-circle"></i> No assessments found. You may not be enrolled in any TVET classes yet.
                </div>
            </div>
        </div>
        <?php } ?>
    </section>
</div>
