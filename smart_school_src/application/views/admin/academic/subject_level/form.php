<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-link"></i> Add Subject-Level Mapping</h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>
        <?php echo validation_errors('<div class="alert alert-danger">', '</div>'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Map Subject to Level</h3>
            </div>
            <form method="post" action="">
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Subject <span class="text-red">*</span></label>
                                <select name="subject_id" class="form-control select2" required>
                                    <option value="">-- Select Subject --</option>
                                    <?php foreach ($subjects as $s): ?>
                                    <option value="<?php echo $s->id; ?>">
                                        <?php echo htmlspecialchars($s->name); ?> (<?php echo $s->code; ?>) - <?php echo $s->programme_name; ?>
                                    </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Level <span class="text-red">*</span></label>
                                <select name="level_id" class="form-control select2" required>
                                    <option value="">-- Select Level --</option>
                                    <?php foreach ($levels as $l): ?>
                                    <option value="<?php echo $l->id; ?>">
                                        <?php echo htmlspecialchars($l->code . ' - ' . $l->name); ?>
                                        <?php echo $l->nqf_level ? '(NQF ' . $l->nqf_level . ')' : ''; ?>
                                    </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Subject Code (Full)</label>
                                <input type="text" name="subject_code_full" class="form-control"
                                       placeholder="e.g., MATH-N4 (optional)">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <a href="<?php echo base_url('admin/academic/subject_levels'); ?>" class="btn btn-default">Cancel</a>
                    <button type="submit" class="btn btn-primary pull-right">
                        <i class="fa fa-save"></i> Save Mapping
                    </button>
                </div>
            </form>
        </div>
    </section>
</div>
