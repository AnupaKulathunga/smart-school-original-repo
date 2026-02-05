<?php
/**
 * TVET Class Selector Component
 *
 * Reusable dropdown for selecting a CLASS (Subject + Level + Cohort)
 * Replaces the old Class + Section two-dropdown pattern
 *
 * Usage:
 *   $this->load->view('admin/_partials/class_selector', [
 *       'selected_class_id' => $class_id,  // Optional
 *       'name' => 'class_id',               // Optional, defaults to 'class_id'
 *       'id' => 'class_id',                 // Optional, defaults to 'class_id'
 *       'required' => true,                 // Optional, defaults to true
 *       'label' => 'Class',                 // Optional, defaults to lang line
 *       'onchange' => 'loadStudents()',     // Optional JS function
 *   ]);
 */

$name = isset($name) ? $name : 'class_id';
$id = isset($id) ? $id : 'class_id';
$required = isset($required) ? $required : true;
$label = isset($label) ? $label : $this->lang->line('class');
$onchange = isset($onchange) ? 'onchange="'.$onchange.'"' : '';
$selected_class_id = isset($selected_class_id) ? $selected_class_id : '';
?>

<div class="form-group">
    <label for="<?php echo $id; ?>">
        <?php echo $label; ?>
        <?php if ($required): ?>
            <span class="req">*</span>
        <?php endif; ?>
    </label>
    <select name="<?php echo $name; ?>"
            id="<?php echo $id; ?>"
            class="form-control"
            <?php echo $required ? 'required' : ''; ?>
            <?php echo $onchange; ?>>
        <option value=""><?php echo $this->lang->line('select'); ?></option>
        <?php if (!empty($classlist)): ?>
            <?php foreach ($classlist as $class): ?>
                <?php
                // Handle both array and object format for backward compatibility
                $class_id = is_array($class) ? $class['id'] : $class->id;
                $selected = ($selected_class_id && $class_id == $selected_class_id) ? 'selected' : '';

                // Use the pre-formatted "class" field if available (array format)
                // Otherwise build display text from individual fields (object format)
                if (is_array($class) && isset($class['class'])) {
                    $display_text = $class['class'];
                } else {
                    $subject_name = is_array($class) ? $class['subject_name'] : $class->subject_name;
                    $level_name = is_array($class) ? $class['level_name'] : $class->level_name;
                    $cohort_name = is_array($class) ? $class['cohort_name'] : $class->cohort_name;
                    $display_text = $subject_name . ' - ' . $level_name . ' (' . $cohort_name . ')';
                }
                ?>
                <option value="<?php echo $class_id; ?>" <?php echo $selected; ?>>
                    <?php echo $display_text; ?>
                </option>
            <?php endforeach; ?>
        <?php endif; ?>
    </select>
    <span class="text-danger"><?php echo form_error($name); ?></span>
</div>
