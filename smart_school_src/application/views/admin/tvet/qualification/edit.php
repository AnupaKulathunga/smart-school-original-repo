<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> Qualification Management</h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-6">
                <!-- Horizontal Form -->
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Edit Qualification</h3>
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

                            <div class="form-group">
                                <label>Programme</label><small class="req"> *</small>
                                <select id="programme_id" name="programme_id" class="form-control">
                                    <option value="">Select Programme</option>
                                    <?php if (!empty($programmes)) {
                                        foreach ($programmes as $programme) { ?>
                                            <option value="<?php echo $programme['id']; ?>" <?php echo (set_value('programme_id', $qualification['programme_id']) == $programme['id']) ? 'selected' : ''; ?>><?php echo $programme['code'] . ' - ' . $programme['name']; ?></option>
                                        <?php }
                                    } ?>
                                </select>
                                <span class="text-danger"><?php echo form_error('programme_id'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Code</label><small class="req"> *</small>
                                <input id="code" name="code" placeholder="" type="text" class="form-control" value="<?php echo set_value('code', $qualification['code']); ?>" />
                                <span class="text-danger"><?php echo form_error('code'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Name</label><small class="req"> *</small>
                                <input id="name" name="name" placeholder="" type="text" class="form-control" value="<?php echo set_value('name', $qualification['name']); ?>" />
                                <span class="text-danger"><?php echo form_error('name'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Description</label>
                                <textarea class="form-control" id="description" name="description" placeholder="" rows="4"><?php echo set_value('description', $qualification['description']); ?></textarea>
                                <span class="text-danger"><?php echo form_error('description'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>
                                    <input type="checkbox" name="active" value="1" <?php echo (set_value('active', $qualification['active']) == '1') ? 'checked' : ''; ?> /> Active
                                </label>
                            </div>

                        </div><!-- /.box-body -->
                        <div class="box-footer">
                            <a href="<?php echo base_url('admin/tvet/qualification'); ?>" class="btn btn-default">Cancel</a>
                            <button type="submit" class="btn btn-info pull-right">Save Qualification</button>
                        </div>
                    </form>
                </div>
            </div><!--/.col -->
        </div>
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->
