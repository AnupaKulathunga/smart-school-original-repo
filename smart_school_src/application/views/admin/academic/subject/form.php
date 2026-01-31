<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-book"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>
        <?php echo validation_errors('<div class="alert alert-danger">', '</div>'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><?php echo isset($subject) ? 'Edit Subject' : 'Add New Subject'; ?></h3>
            </div>
            <form method="post" action="">
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Programme <span class="text-red">*</span></label>
                                <select name="programme_id" class="form-control select2" required>
                                    <option value="">-- Select Programme --</option>
                                    <?php foreach ($programmes as $p): ?>
                                    <option value="<?php echo $p->id; ?>"
                                        <?php echo (isset($subject) && $subject->programme_id == $p->id) ? 'selected' : ''; ?>>
                                        <?php echo htmlspecialchars($p->name); ?>
                                    </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Code <span class="text-red">*</span></label>
                                <input type="text" name="code" class="form-control" required
                                       value="<?php echo isset($subject) ? $subject->code : set_value('code'); ?>"
                                       placeholder="e.g., MATH, ENG, ACC">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Name <span class="text-red">*</span></label>
                                <input type="text" name="name" class="form-control" required
                                       value="<?php echo isset($subject) ? $subject->name : set_value('name'); ?>"
                                       placeholder="e.g., Mathematics, Engineering Science">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Credits</label>
                                <input type="number" name="credits" class="form-control"
                                       value="<?php echo isset($subject) ? $subject->credits : 0; ?>"
                                       min="0" max="100">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Notional Hours</label>
                                <input type="number" name="notional_hours" class="form-control"
                                       value="<?php echo isset($subject) ? $subject->notional_hours : 0; ?>"
                                       min="0">
                                <small class="text-muted">Total learning hours</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Subject Type</label>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="is_core" value="1"
                                            <?php echo (!isset($subject) || $subject->is_core) ? 'checked' : ''; ?>>
                                        Core Subject
                                    </label>
                                </div>
                                <small class="text-muted">Uncheck for elective subjects</small>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Description</label>
                                <textarea name="description" class="form-control" rows="3"><?php echo isset($subject) ? $subject->description : set_value('description'); ?></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>
                                    <input type="checkbox" name="is_active" value="1"
                                        <?php echo (!isset($subject) || $subject->is_active) ? 'checked' : ''; ?>>
                                    Active
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <a href="<?php echo base_url('admin/academic/subjects'); ?>" class="btn btn-default">Cancel</a>
                    <button type="submit" class="btn btn-primary pull-right">
                        <i class="fa fa-save"></i> Save
                    </button>
                </div>
            </form>
        </div>
    </section>
</div>
