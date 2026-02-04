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
                $selected = ($selected_class_id && $class->id == $selected_class_id) ? 'selected' : '';

                // Display format: "Subject - Level (Cohort)"
                // Example: "Mathematics N4 - N4 (Morning Intake)"
                $display_text = $class->subject_name . ' - ' . $class->level_name . ' (' . $class->cohort_name . ')';
                ?>
                <option value="<?php echo $class->id; ?>" <?php echo $selected; ?>>
                    <?php echo $display_text; ?>
                </option>
            <?php endforeach; ?>
        <?php endif; ?>
    </select>
    <span class="text-danger"><?php echo form_error($name); ?></span>
</div>
