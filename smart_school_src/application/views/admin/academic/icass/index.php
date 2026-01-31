<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-tasks"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">ICASS Management</h3>
            </div>
            <div class="box-body">
                <div class="callout callout-info">
                    <h4>Internal Continuous Assessment (ICASS)</h4>
                    <p>ICASS is the continuous assessment component of TVET qualifications. It typically consists of multiple tasks throughout the year, each with a specific weight towards the final mark.</p>
                    <p><strong>Standard ICASS Components:</strong></p>
                    <ul>
                        <li>Task 1 - 10%</li>
                        <li>Task 2 - 15%</li>
                        <li>Task 3 - 15%</li>
                        <li>Task 4 - 15%</li>
                        <li>Task 5 - 15%</li>
                        <li>Task 6 - 15%</li>
                        <li>Task 7 - 15%</li>
                    </ul>
                </div>

                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-4">
                        <label>Select Class</label>
                        <select class="form-control select2" id="icass_class">
                            <option value="">-- Select Class --</option>
                            <?php foreach ($classes as $c): ?>
                            <option value="<?php echo $c->id; ?>">
                                <?php echo htmlspecialchars($c->class_code . ' - ' . $c->subject_name); ?>
                            </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>

                <div id="icass_config" style="display:none;">
                    <h4>ICASS Configuration</h4>
                    <p class="text-muted">Configure ICASS component weights for the selected class.</p>
                    <!-- ICASS config form would go here -->
                </div>
            </div>
        </div>
    </section>
</div>
