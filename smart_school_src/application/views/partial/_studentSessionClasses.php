<?php
$current_class = ($this->session->userdata('current_class'));

// Programme-based switcher for students
if (!empty($programmes)) {
    foreach ($programmes as $prog) {
        $is_selected = (isset($current_class['programme_id']) && $current_class['programme_id'] == $prog->programme_id);
?>
<div class="row">
    <div class="col-md-12">
        <div class="well well-sm">
            <div class="row">
                <div class="col-xs-12 col-md-12 section-box">
                    <div class="row rating-desc">
                        <div class="col-md-12">
                            <label class="checkbox-inline">
                                <input type="checkbox" value="prog_<?php echo $prog->programme_id; ?>" class="clschg" name="clschg" <?php echo $is_selected ? 'checked' : ''; ?>>
                                <strong><?php echo htmlspecialchars($prog->programme_name); ?></strong>
                                <span style="color:#888; font-size:12px;"> &mdash; <?php echo $prog->class_count; ?> <?php echo ($prog->class_count == 1) ? 'subject' : 'subjects'; ?></span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<?php
    }
} elseif (!empty($studentclasses)) {
    // Legacy class-based switcher (for parents or fallback)
    foreach ($studentclasses as $student_key => $student_value) {
        if ($role == "parent") {
            $name = $this->customlib->getFullName($student_value->firstname,$student_value->middlename,$student_value->lastname,$sch_setting->middlename,$sch_setting->lastname);
        }
?>
<div class="row">
    <div class="col-md-12">
        <div class="well well-sm">
            <div class="row">
                <div class="col-xs-12 col-md-12 section-box">
                    <div class="row rating-desc">
                        <div class="col-md-12">
                            <label class="checkbox-inline">
                                <input type="checkbox" value="<?php echo $student_value->student_session_id; ?>" class="clschg" name="clschg" <?php echo ($student_value->class_id == $current_class['class_id'] && $student_value->student_session_id == $current_class['student_session_id']) ? 'checked' : ''; ?>><?php
$class_label = isset($student_value->subject_name)
    ? $student_value->subject_name . ' - ' . $student_value->level_code . ' (Cohort ' . $student_value->cohort_name . ')'
    : (isset($student_value->class) ? $student_value->class : $student_value->class_code);
echo ($role == 'parent') ? $name . " " . $class_label : $class_label;
?>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<?php
    }
} else {
?>
<div class="alert alert-info">
    <?php echo $this->lang->line('no_more_classes_found_in_your_current_session'); ?>
</div>
<?php
}
?>