<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-folder-open"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Portfolio of Evidence</h3>
            </div>
            <div class="box-body">
                <div class="callout callout-info">
                    <h4>Portfolio of Evidence (POE)</h4>
                    <p>A POE is a collection of evidence that demonstrates a student's competence. It includes:</p>
                    <ul>
                        <li>Assignments and projects</li>
                        <li>Practical work evidence</li>
                        <li>Test scripts and feedback</li>
                        <li>Reflections and learning journals</li>
                        <li>Workplace evidence (where applicable)</li>
                    </ul>
                </div>

                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-4">
                        <label>Select Class</label>
                        <select class="form-control select2" id="poe_class">
                            <option value="">-- Select Class --</option>
                            <?php foreach ($classes as $c): ?>
                            <option value="<?php echo $c->id; ?>">
                                <?php echo htmlspecialchars($c->class_code . ' - ' . $c->subject_name); ?>
                            </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>

                <div id="poe_items" style="display:none;">
                    <!-- POE items table would go here -->
                </div>
            </div>
        </div>
    </section>
</div>
