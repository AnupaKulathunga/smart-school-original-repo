<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> Cohort Management</h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-8">
                <!-- Horizontal Form -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Edit Cohort</h3>
                    </div><!-- /.box-header -->
                    <form id="form1" action="" method="post" accept-charset="utf-8">
                        <div class="box-body">
                            <?php if ($this->session->flashdata('msg')) { ?>
                                <?php echo $this->session->flashdata('msg'); ?>
                            <?php } ?>

                            <?php if (validation_errors()) { ?>
                                <div class="alert alert-danger">
                                    <?php echo validation_errors(); ?>
                                </div>
                            <?php } ?>

                            <?php echo $this->customlib->getCSRF(); ?>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Programme</label><small class="req"> *</small>
                                        <select id="programme_id" name="programme_id" class="form-control">
                                            <option value="">Select Programme</option>
                                            <?php if (!empty($programmes)) {
                                                foreach ($programmes as $programme) { ?>
                                                    <option value="<?php echo $programme['id']; ?>" <?php echo (set_value('programme_id', $cohort['programme_id']) == $programme['id']) ? 'selected' : ''; ?>><?php echo $programme['name']; ?></option>
                                                <?php }
                                            } ?>
                                        </select>
                                        <span class="text-danger"><?php echo form_error('programme_id'); ?></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Qualification</label><small class="req"> *</small>
                                        <select id="qualification_id" name="qualification_id" class="form-control">
                                            <option value="">Select Qualification</option>
                                            <?php if (!empty($qualifications)) {
                                                foreach ($qualifications as $qualification) { ?>
                                                    <option value="<?php echo $qualification['id']; ?>" <?php echo (set_value('qualification_id', $cohort['qualification_id']) == $qualification['id']) ? 'selected' : ''; ?>><?php echo $qualification['name']; ?></option>
                                                <?php }
                                            } ?>
                                        </select>
                                        <span class="text-danger"><?php echo form_error('qualification_id'); ?></span>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Level</label><small class="req"> *</small>
                                        <select id="level_id" name="level_id" class="form-control">
                                            <option value="">Select Level</option>
                                            <?php if (!empty($levels)) {
                                                foreach ($levels as $level) { ?>
                                                    <option value="<?php echo $level['id']; ?>" <?php echo (set_value('level_id', $cohort['level_id']) == $level['id']) ? 'selected' : ''; ?>><?php echo $level['name']; ?> (<?php echo $level['qualification_name']; ?>)</option>
                                                <?php }
                                            } ?>
                                        </select>
                                        <span class="text-danger"><?php echo form_error('level_id'); ?></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Cohort Code</label><small class="req"> *</small>
                                        <input id="code" name="code" placeholder="e.g., NCV-L2-2024-A" type="text" class="form-control" value="<?php echo set_value('code', $cohort['code']); ?>" />
                                        <span class="text-danger"><?php echo form_error('code'); ?></span>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Cohort Name</label><small class="req"> *</small>
                                        <input id="name" name="name" placeholder="" type="text" class="form-control" value="<?php echo set_value('name', $cohort['name']); ?>" />
                                        <span class="text-danger"><?php echo form_error('name'); ?></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Intake Year</label><small class="req"> *</small>
                                        <input id="intake_year" name="intake_year" type="number" class="form-control" min="2000" max="2100" value="<?php echo set_value('intake_year', $cohort['intake_year']); ?>" />
                                        <span class="text-danger"><?php echo form_error('intake_year'); ?></span>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Delivery Mode</label><small class="req"> *</small>
                                        <select id="delivery_mode" name="delivery_mode" class="form-control">
                                            <option value="">Select Mode</option>
                                            <option value="Full-time" <?php echo (set_value('delivery_mode', $cohort['delivery_mode']) == 'Full-time') ? 'selected' : ''; ?>>Full-time</option>
                                            <option value="Part-time" <?php echo (set_value('delivery_mode', $cohort['delivery_mode']) == 'Part-time') ? 'selected' : ''; ?>>Part-time</option>
                                            <option value="Evening" <?php echo (set_value('delivery_mode', $cohort['delivery_mode']) == 'Evening') ? 'selected' : ''; ?>>Evening</option>
                                            <option value="Weekend" <?php echo (set_value('delivery_mode', $cohort['delivery_mode']) == 'Weekend') ? 'selected' : ''; ?>>Weekend</option>
                                            <option value="Distance" <?php echo (set_value('delivery_mode', $cohort['delivery_mode']) == 'Distance') ? 'selected' : ''; ?>>Distance</option>
                                        </select>
                                        <span class="text-danger"><?php echo form_error('delivery_mode'); ?></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Max Students</label>
                                        <input id="max_students" name="max_students" type="number" class="form-control" min="1" value="<?php echo set_value('max_students', $cohort['max_students']); ?>" />
                                        <span class="text-danger"><?php echo form_error('max_students'); ?></span>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Start Date</label><small class="req"> *</small>
                                        <input id="start_date" name="start_date" type="date" class="form-control" value="<?php echo set_value('start_date', $cohort['start_date']); ?>" />
                                        <span class="text-danger"><?php echo form_error('start_date'); ?></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>End Date</label>
                                        <input id="end_date" name="end_date" type="date" class="form-control" value="<?php echo set_value('end_date', $cohort['end_date']); ?>" />
                                        <span class="text-danger"><?php echo form_error('end_date'); ?></span>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>
                                    <input type="checkbox" name="active" value="1" <?php echo (set_value('active', $cohort['active']) == '1') ? 'checked' : ''; ?> /> Active
                                </label>
                            </div>

                        </div><!-- /.box-body -->
                        <div class="box-footer">
                            <a href="<?php echo base_url('admin/tvet/cohort'); ?>" class="btn btn-default">Cancel</a>
                            <button type="submit" class="btn btn-info pull-right">Save Cohort</button>
                        </div>
                    </form>
                </div>
            </div><!--/.col -->
        </div>
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

<script>
var base_url = '<?php echo base_url(); ?>';
$(document).ready(function() {
    $('#programme_id').on('change', function() {
        var id = $(this).val();
        if (id) {
            $.ajax({
                url: base_url + 'admin/tvet/ajax_get_qualifications/' + id,
                dataType: 'json',
                success: function(data) {
                    var html = '<option value="">Select Qualification</option>';
                    $.each(data, function(i, item) {
                        html += '<option value="' + item.id + '">' + item.name + '</option>';
                    });
                    $('#qualification_id').html(html);
                    $('#level_id').html('<option value="">Select Level</option>');
                }
            });
        } else {
            $('#qualification_id').html('<option value="">Select Qualification</option>');
            $('#level_id').html('<option value="">Select Level</option>');
        }
    });

    $('#qualification_id').on('change', function() {
        var id = $(this).val();
        if (id) {
            $.ajax({
                url: base_url + 'admin/tvet/ajax_get_levels/' + id,
                dataType: 'json',
                success: function(data) {
                    var html = '<option value="">Select Level</option>';
                    $.each(data, function(i, item) {
                        html += '<option value="' + item.id + '">' + item.name + '</option>';
                    });
                    $('#level_id').html(html);
                }
            });
        } else {
            $('#level_id').html('<option value="">Select Level</option>');
        }
    });
});
</script>
