<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> Level Management</h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-6">
                <!-- Horizontal Form -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Edit Level</h3>
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

                            <?php $level_programme_id = isset($level['programme_id']) ? $level['programme_id'] : ''; ?>

                            <div class="form-group">
                                <label>Programme</label><small class="req"> *</small>
                                <select id="programme_id" name="programme_id" class="form-control">
                                    <option value="">Select Programme</option>
                                    <?php if (!empty($programmes)) {
                                        foreach ($programmes as $programme) { ?>
                                            <option value="<?php echo $programme['id']; ?>" <?php echo (set_value('programme_id', $level_programme_id) == $programme['id']) ? 'selected' : ''; ?>><?php echo $programme['name']; ?> (<?php echo $programme['code']; ?>)</option>
                                        <?php }
                                    } ?>
                                </select>
                                <span class="text-danger"><?php echo form_error('programme_id'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Qualification</label><small class="req"> *</small>
                                <select id="qualification_id" name="qualification_id" class="form-control">
                                    <option value="">Select Qualification</option>
                                    <?php if (!empty($qualifications)) {
                                        foreach ($qualifications as $qualification) { ?>
                                            <option value="<?php echo $qualification['id']; ?>" <?php echo (set_value('qualification_id', $level['qualification_id']) == $qualification['id']) ? 'selected' : ''; ?>><?php echo $qualification['name']; ?> (<?php echo $qualification['code']; ?>)</option>
                                        <?php }
                                    } ?>
                                </select>
                                <span class="text-danger"><?php echo form_error('qualification_id'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Code</label><small class="req"> *</small>
                                <input id="code" name="code" placeholder="e.g., N1, N2, L2" type="text" class="form-control" value="<?php echo set_value('code', $level['code']); ?>" />
                                <span class="text-danger"><?php echo form_error('code'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Name</label><small class="req"> *</small>
                                <input id="name" name="name" placeholder="" type="text" class="form-control" value="<?php echo set_value('name', $level['name']); ?>" />
                                <span class="text-danger"><?php echo form_error('name'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Sequence</label>
                                <input id="sequence" name="sequence" type="number" class="form-control" value="<?php echo set_value('sequence', $level['sequence']); ?>" min="1" />
                                <span class="text-danger"><?php echo form_error('sequence'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>
                                    <input type="checkbox" name="active" value="1" <?php echo (set_value('active', $level['active']) == '1') ? 'checked' : ''; ?> /> Active
                                </label>
                            </div>

                        </div><!-- /.box-body -->
                        <div class="box-footer">
                            <a href="<?php echo base_url('admin/tvet/level'); ?>" class="btn btn-default">Cancel</a>
                            <button type="submit" class="btn btn-info pull-right">Save Level</button>
                        </div>
                    </form>
                </div>
            </div><!--/.col -->
        </div>
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

<script>
var base_url = '<?php echo base_url(); ?>';
$('#programme_id').on('change', function() {
    var programme_id = $(this).val();
    if (programme_id) {
        $.ajax({
            url: base_url + 'admin/tvet/ajax_get_qualifications/' + programme_id,
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                var html = '<option value="">Select Qualification</option>';
                $.each(data, function(i, item) {
                    html += '<option value="' + item.id + '">' + item.name + ' (' + item.code + ')</option>';
                });
                $('#qualification_id').html(html);
            }
        });
    }
});
</script>
