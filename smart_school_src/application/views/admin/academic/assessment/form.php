<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-file-alt"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>
        <?php echo validation_errors('<div class="alert alert-danger">', '</div>'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><?php echo isset($assessment) ? 'Edit Assessment' : 'Create New Assessment'; ?></h3>
            </div>
            <form method="post" action="">
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Class <span class="text-red">*</span></label>
                                <select name="class_id" class="form-control select2" required <?php echo isset($assessment) ? 'disabled' : ''; ?>>
                                    <option value="">-- Select Class --</option>
                                    <?php foreach ($classes as $c): ?>
                                    <option value="<?php echo $c->id; ?>"
                                        <?php echo (isset($assessment) && $assessment->class_id == $c->id) ? 'selected' : ''; ?>
                                        <?php echo ($this->input->get('class_id') == $c->id) ? 'selected' : ''; ?>>
                                        <?php echo htmlspecialchars($c->class_code . ' - ' . $c->subject_name . ' ' . $c->level_code); ?>
                                    </option>
                                    <?php endforeach; ?>
                                </select>
                                <?php if (isset($assessment)): ?>
                                <input type="hidden" name="class_id" value="<?php echo $assessment->class_id; ?>">
                                <?php endif; ?>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Assessment Type <span class="text-red">*</span></label>
                                <select name="assessment_type" class="form-control" required>
                                    <option value="">-- Select Type --</option>
                                    <option value="Test" <?php echo (isset($assessment) && $assessment->assessment_type == 'Test') ? 'selected' : ''; ?>>Test</option>
                                    <option value="ICASS" <?php echo (isset($assessment) && $assessment->assessment_type == 'ICASS') ? 'selected' : ''; ?>>ICASS</option>
                                    <option value="Practical" <?php echo (isset($assessment) && $assessment->assessment_type == 'Practical') ? 'selected' : ''; ?>>Practical</option>
                                    <option value="Assignment" <?php echo (isset($assessment) && $assessment->assessment_type == 'Assignment') ? 'selected' : ''; ?>>Assignment</option>
                                    <option value="Project" <?php echo (isset($assessment) && $assessment->assessment_type == 'Project') ? 'selected' : ''; ?>>Project</option>
                                    <option value="POE" <?php echo (isset($assessment) && $assessment->assessment_type == 'POE') ? 'selected' : ''; ?>>POE</option>
                                    <option value="Exam" <?php echo (isset($assessment) && $assessment->assessment_type == 'Exam') ? 'selected' : ''; ?>>Exam</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Title <span class="text-red">*</span></label>
                                <input type="text" name="title" class="form-control" required
                                       value="<?php echo isset($assessment) ? $assessment->title : set_value('title'); ?>"
                                       placeholder="e.g., Mathematics Test 1, ICASS Task 2">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>ICASS Component</label>
                                <select name="icass_component" class="form-control">
                                    <option value="">-- Not Applicable --</option>
                                    <option value="Task 1" <?php echo (isset($assessment) && $assessment->icass_component == 'Task 1') ? 'selected' : ''; ?>>Task 1</option>
                                    <option value="Task 2" <?php echo (isset($assessment) && $assessment->icass_component == 'Task 2') ? 'selected' : ''; ?>>Task 2</option>
                                    <option value="Task 3" <?php echo (isset($assessment) && $assessment->icass_component == 'Task 3') ? 'selected' : ''; ?>>Task 3</option>
                                    <option value="Task 4" <?php echo (isset($assessment) && $assessment->icass_component == 'Task 4') ? 'selected' : ''; ?>>Task 4</option>
                                    <option value="Task 5" <?php echo (isset($assessment) && $assessment->icass_component == 'Task 5') ? 'selected' : ''; ?>>Task 5</option>
                                    <option value="Task 6" <?php echo (isset($assessment) && $assessment->icass_component == 'Task 6') ? 'selected' : ''; ?>>Task 6</option>
                                    <option value="Task 7" <?php echo (isset($assessment) && $assessment->icass_component == 'Task 7') ? 'selected' : ''; ?>>Task 7</option>
                                    <option value="Final" <?php echo (isset($assessment) && $assessment->icass_component == 'Final') ? 'selected' : ''; ?>>Final</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Total Marks <span class="text-red">*</span></label>
                                <input type="number" name="total_marks" class="form-control" required
                                       value="<?php echo isset($assessment) ? $assessment->total_marks : 100; ?>"
                                       min="1" step="0.5">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>Weight Percentage</label>
                                <div class="input-group">
                                    <input type="number" name="weight_percentage" class="form-control"
                                           value="<?php echo isset($assessment) ? $assessment->weight_percentage : ''; ?>"
                                           min="0" max="100" step="0.5">
                                    <span class="input-group-addon">%</span>
                                </div>
                                <small class="text-muted">Weight towards final mark</small>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Due Date</label>
                                <input type="date" name="due_date" class="form-control"
                                       value="<?php echo isset($assessment) && $assessment->due_date ? date('Y-m-d', strtotime($assessment->due_date)) : ''; ?>">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Due Time</label>
                                <input type="time" name="due_time" class="form-control"
                                       value="<?php echo isset($assessment) && $assessment->due_date ? date('H:i', strtotime($assessment->due_date)) : '23:59'; ?>">
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Instructions</label>
                                <textarea name="instructions" class="form-control" rows="4"><?php echo isset($assessment) ? $assessment->instructions : ''; ?></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <a href="<?php echo base_url('admin/academic/assessments'); ?>" class="btn btn-default">Cancel</a>
                    <button type="submit" class="btn btn-primary pull-right">
                        <i class="fa fa-save"></i> Save Assessment
                    </button>
                </div>
            </form>
        </div>
    </section>
</div>
