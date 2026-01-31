<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-check-square-o"></i> <?php echo $title; ?>
        </h1>
    </section>
    <section class="content">
        <?php if (!empty($attendance_by_class)) { ?>
        <div class="row">
            <?php foreach ($attendance_by_class as $class_attendance) { ?>
            <div class="col-md-6">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">
                            <?php echo htmlspecialchars($class_attendance['subject_name']); ?>
                            <small class="label label-default"><?php echo $class_attendance['level_code']; ?></small>
                        </h3>
                    </div>
                    <div class="box-body">
                        <?php $summary = $class_attendance['summary']; ?>
                        <div class="row text-center">
                            <div class="col-xs-3">
                                <div class="description-block border-right">
                                    <span class="description-percentage text-green">
                                        <i class="fa fa-check"></i>
                                    </span>
                                    <h5 class="description-header"><?php echo $summary->present; ?></h5>
                                    <span class="description-text">Present</span>
                                </div>
                            </div>
                            <div class="col-xs-3">
                                <div class="description-block border-right">
                                    <span class="description-percentage text-red">
                                        <i class="fa fa-times"></i>
                                    </span>
                                    <h5 class="description-header"><?php echo $summary->absent; ?></h5>
                                    <span class="description-text">Absent</span>
                                </div>
                            </div>
                            <div class="col-xs-3">
                                <div class="description-block border-right">
                                    <span class="description-percentage text-yellow">
                                        <i class="fa fa-clock-o"></i>
                                    </span>
                                    <h5 class="description-header"><?php echo $summary->late; ?></h5>
                                    <span class="description-text">Late</span>
                                </div>
                            </div>
                            <div class="col-xs-3">
                                <div class="description-block">
                                    <span class="description-percentage text-aqua">
                                        <i class="fa fa-percent"></i>
                                    </span>
                                    <h5 class="description-header"><?php echo $summary->percentage; ?>%</h5>
                                    <span class="description-text">Rate</span>
                                </div>
                            </div>
                        </div>
                        <div class="progress-group" style="margin-top: 15px;">
                            <span class="progress-text">Attendance Rate</span>
                            <span class="progress-number"><?php echo $summary->percentage; ?>%</span>
                            <div class="progress sm">
                                <?php
                                $percentage = $summary->percentage;
                                $bar_color = 'progress-bar-green';
                                if ($percentage < 75) $bar_color = 'progress-bar-red';
                                elseif ($percentage < 85) $bar_color = 'progress-bar-yellow';
                                ?>
                                <div class="progress-bar <?php echo $bar_color; ?>" style="width: <?php echo $percentage; ?>%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <?php } ?>
        </div>
        <?php } else { ?>
        <div class="box box-default">
            <div class="box-body">
                <div class="alert alert-info">
                    <i class="fa fa-info-circle"></i> No attendance records found. You may not be enrolled in any TVET classes yet.
                </div>
            </div>
        </div>
        <?php } ?>
    </section>
</div>
