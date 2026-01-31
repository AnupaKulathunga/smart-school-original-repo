<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-user-plus"></i> Enrol Student</h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>
        <?php echo validation_errors('<div class="alert alert-danger">', '</div>'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Enrol Student in Class</h3>
            </div>
            <form method="post" action="">
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Select Class <span class="text-red">*</span></label>
                                <select name="class_id" class="form-control select2" required>
                                    <option value="">-- Select Class --</option>
                                    <?php foreach ($classes as $c): ?>
                                    <option value="<?php echo $c->id; ?>"
                                        <?php echo ($this->input->get('class_id') == $c->id) ? 'selected' : ''; ?>>
                                        <?php echo htmlspecialchars($c->class_code . ' - ' . $c->subject_name . ' ' . $c->level_code . ' (' . $c->cohort_name . ')'); ?>
                                    </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Select Student <span class="text-red">*</span></label>
                                <select name="student_id" class="form-control select2" required>
                                    <option value="">-- Select Student --</option>
                                    <?php if (!empty($students)): ?>
                                    <?php foreach ($students as $s): ?>
                                    <option value="<?php echo $s['id']; ?>">
                                        <?php echo htmlspecialchars($s['admission_no'] . ' - ' . $s['firstname'] . ' ' . $s['lastname']); ?>
                                    </option>
                                    <?php endforeach; ?>
                                    <?php endif; ?>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <a href="<?php echo base_url('admin/academic/enrolment'); ?>" class="btn btn-default">Cancel</a>
                    <button type="submit" class="btn btn-primary pull-right">
                        <i class="fa fa-save"></i> Enrol Student
                    </button>
                </div>
            </form>
        </div>
    </section>
</div>
