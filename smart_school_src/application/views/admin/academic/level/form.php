<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-layer-group"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>
        <?php echo validation_errors('<div class="alert alert-danger">', '</div>'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><?php echo isset($level) ? 'Edit Level' : 'Add New Level'; ?></h3>
            </div>
            <form method="post" action="">
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Code <span class="text-red">*</span></label>
                                <input type="text" name="code" class="form-control" required
                                       value="<?php echo isset($level) ? $level->code : set_value('code'); ?>"
                                       placeholder="e.g., N1, N2, NCV2">
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="form-group">
                                <label>Name <span class="text-red">*</span></label>
                                <input type="text" name="name" class="form-control" required
                                       value="<?php echo isset($level) ? $level->name : set_value('name'); ?>"
                                       placeholder="e.g., NATED Level 1">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Level Type</label>
                                <select name="level_type" class="form-control">
                                    <option value="NATED" <?php echo (isset($level) && $level->level_type == 'NATED') ? 'selected' : ''; ?>>NATED</option>
                                    <option value="NCV" <?php echo (isset($level) && $level->level_type == 'NCV') ? 'selected' : ''; ?>>NCV</option>
                                    <option value="Other" <?php echo (isset($level) && $level->level_type == 'Other') ? 'selected' : ''; ?>>Other</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>NQF Level</label>
                                <select name="nqf_level" class="form-control">
                                    <option value="">-- Select --</option>
                                    <?php for ($i = 1; $i <= 10; $i++): ?>
                                    <option value="<?php echo $i; ?>" <?php echo (isset($level) && $level->nqf_level == $i) ? 'selected' : ''; ?>>
                                        NQF <?php echo $i; ?>
                                    </option>
                                    <?php endfor; ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Sequence Order</label>
                                <input type="number" name="sequence_order" class="form-control"
                                       value="<?php echo isset($level) ? $level->sequence_order : 1; ?>"
                                       min="1">
                                <small class="text-muted">For ordering levels</small>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>
                                    <input type="checkbox" name="is_active" value="1"
                                        <?php echo (!isset($level) || $level->is_active) ? 'checked' : ''; ?>>
                                    Active
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <a href="<?php echo base_url('admin/academic/levels'); ?>" class="btn btn-default">Cancel</a>
                    <button type="submit" class="btn btn-primary pull-right">
                        <i class="fa fa-save"></i> Save
                    </button>
                </div>
            </form>
        </div>
    </section>
</div>
