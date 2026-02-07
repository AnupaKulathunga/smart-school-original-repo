<?php
/**
 * TVET Academic Model: Subject attendance partial view
 * Displays attendance records for all enrolled classes on a selected date
 *
 * Variables passed from controller:
 * - $attendence: Attendance records for the date (from academic_attendance table)
 * - $enrolled_classes: All classes student is enrolled in
 * - $selected_date: The date being viewed
 */

// Build lookup of attendance by class_id for easy access
$attendance_by_class = array();
if (!empty($attendence)) {
    foreach ($attendence as $att) {
        $attendance_by_class[$att->class_id] = $att;
    }
}

if (!empty($enrolled_classes)) {
    ?>
    <table class="table table-striped">
        <thead>
            <tr>
                <th><?php echo $this->lang->line('subject'); ?></th>
                <th class="text text-center"><?php echo $this->lang->line('level'); ?></th>
                <th class="text text-center"><?php echo $this->lang->line('class'); ?></th>
                <th class="text text-center"><?php echo $this->lang->line('venue'); ?></th>
                <th class="text text-center"><?php echo $this->lang->line('attendance'); ?></th>
                <th><?php echo $this->lang->line('note'); ?></th>
            </tr>
        </thead>
        <tbody>
            <?php
            foreach ($enrolled_classes as $class) {
                // Check if we have attendance for this class
                $has_attendance = isset($attendance_by_class[$class->class_id]);
                $att_record = $has_attendance ? $attendance_by_class[$class->class_id] : null;
                ?>
                <tr>
                    <td>
                        <?php echo htmlspecialchars($class->subject_name); ?>
                        <small class="text-muted">(<?php echo htmlspecialchars($class->subject_code); ?>)</small>
                    </td>
                    <td class="text text-center">
                        <?php echo htmlspecialchars($class->level_code); ?>
                    </td>
                    <td class="text text-center">
                        <?php echo htmlspecialchars($class->class_code); ?>
                        <?php if ($class->cohort_name) { ?>
                            <br><small class="text-muted"><?php echo htmlspecialchars($class->cohort_name); ?></small>
                        <?php } ?>
                    </td>
                    <td class="text text-center">
                        <?php echo htmlspecialchars($class->venue ?: '-'); ?>
                    </td>
                    <td class="text text-center">
                        <?php
                        if (!$has_attendance) {
                            // No attendance marked for this date
                            ?>
                            <span class="label label-default"><?php echo $this->lang->line('n_a') ?: 'N/A'; ?></span>
                            <?php
                        } else {
                            // Display attendance status with appropriate color
                            $status = $att_record->status;
                            $label_class = 'label-default';

                            switch ($status) {
                                case 'Present':
                                    $label_class = 'label-success';
                                    $status_text = $this->lang->line('present') ?: 'Present';
                                    break;
                                case 'Absent':
                                    $label_class = 'label-danger';
                                    $status_text = $this->lang->line('absent') ?: 'Absent';
                                    break;
                                case 'Late':
                                    $label_class = 'label-warning';
                                    $status_text = $this->lang->line('late') ?: 'Late';
                                    break;
                                case 'Excused':
                                    $label_class = 'label-info';
                                    $status_text = $this->lang->line('excused') ?: 'Excused';
                                    break;
                                default:
                                    $status_text = $status;
                            }
                            ?>
                            <span class="label <?php echo $label_class; ?>"><?php echo $status_text; ?></span>
                            <?php
                        }
                        ?>
                    </td>
                    <td>
                        <?php echo $has_attendance && $att_record->notes ? htmlspecialchars($att_record->notes) : '-'; ?>
                    </td>
                </tr>
                <?php
            }
            ?>
        </tbody>
    </table>

    <?php
    // Show attendance summary for the date
    $total_classes = count($enrolled_classes);
    $marked_count = count($attendance_by_class);
    $present_count = 0;
    $absent_count = 0;
    $late_count = 0;
    $excused_count = 0;

    foreach ($attendance_by_class as $att) {
        switch ($att->status) {
            case 'Present':
                $present_count++;
                break;
            case 'Absent':
                $absent_count++;
                break;
            case 'Late':
                $late_count++;
                break;
            case 'Excused':
                $excused_count++;
                break;
        }
    }
    ?>

    <div class="row mt-3">
        <div class="col-md-12">
            <div class="alert alert-info">
                <strong><?php echo $this->lang->line('summary') ?: 'Summary'; ?>:</strong>
                <?php echo $this->lang->line('total_classes') ?: 'Total Classes'; ?>: <?php echo $total_classes; ?> |
                <?php echo $this->lang->line('attendance_marked') ?: 'Marked'; ?>: <?php echo $marked_count; ?> |
                <span class="text-success"><?php echo $this->lang->line('present') ?: 'Present'; ?>: <?php echo $present_count; ?></span> |
                <span class="text-danger"><?php echo $this->lang->line('absent') ?: 'Absent'; ?>: <?php echo $absent_count; ?></span> |
                <span class="text-warning"><?php echo $this->lang->line('late') ?: 'Late'; ?>: <?php echo $late_count; ?></span> |
                <span class="text-info"><?php echo $this->lang->line('excused') ?: 'Excused'; ?>: <?php echo $excused_count; ?></span>
            </div>
        </div>
    </div>

    <?php
} else {
    ?>
    <div class="alert alert-warning">
        <?php echo $this->lang->line('no_enrolled_classes') ?: 'You are not enrolled in any classes for the current session.'; ?>
    </div>
    <?php
}
?>
