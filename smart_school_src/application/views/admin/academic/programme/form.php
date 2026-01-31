<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-university"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>
        <?php echo validation_errors('<div class="alert alert-danger">', '</div>'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><?php echo isset($programme) ? 'Edit Programme' : 'Add New Programme'; ?></h3>
            </div>
            <form method="post" action="">
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Code <span class="text-red">*</span></label>
                                <input type="text" name="code" class="form-control" required
                                       value="<?php echo isset($programme) ? $programme->code : set_value('code'); ?>"
                                       placeholder="e.g., NATED, NCV">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Duration (Years)</label>
                                <input type="number" name="duration_years" class="form-control" min="1" max="10"
                                       value="<?php echo isset($programme) ? $programme->duration_years : 3; ?>">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Name <span class="text-red">*</span></label>
                                <input type="text" name="name" class="form-control" required
                                       value="<?php echo isset($programme) ? $programme->name : set_value('name'); ?>"
                                       placeholder="e.g., National Accredited Technical Education Diploma">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Description</label>
                                <textarea name="description" class="form-control" rows="3"><?php echo isset($programme) ? $programme->description : set_value('description'); ?></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>
                                    <input type="checkbox" name="is_active" value="1"
                                        <?php echo (!isset($programme) || $programme->is_active) ? 'checked' : ''; ?>>
                                    Active
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <a href="<?php echo base_url('admin/academic/programmes'); ?>" class="btn btn-default">Cancel</a>
                    <button type="submit" class="btn btn-primary pull-right">
                        <i class="fa fa-save"></i> Save
                    </button>
                </div>
            </form>
        </div>
    </section>
</div>
