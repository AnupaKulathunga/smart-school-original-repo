<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-file-text"></i> <?php echo $title; ?>
        </h1>
    </section>
    <section class="content">
        <?php if ($assessment): ?>
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><?php echo htmlspecialchars($assessment['title']); ?></h3>
                <div class="box-tools pull-right">
                    <a href="<?php echo base_url('user/tvetportal/my_assessments'); ?>" class="btn btn-default btn-sm">
                        <i class="fa fa-arrow-left"></i> Back
                    </a>
                </div>
            </div>
            <div class="box-body">
                <div class="row">
                    <div class="col-md-8">
                        <table class="table table-bordered">
                            <tr>
                                <th width="30%">Class</th>
                                <td><?php echo htmlspecialchars($assessment['class_code']); ?></td>
                            </tr>
                            <tr>
                                <th>Subject</th>
                                <td>
                                    <?php echo htmlspecialchars($assessment['subject_name']); ?>
                                    <span class="label label-info"><?php echo $assessment['level_code']; ?></span>
                                </td>
                            </tr>
                            <tr>
                                <th>Type</th>
                                <td><span class="label label-default"><?php echo $assessment['assessment_type']; ?></span></td>
                            </tr>
                            <tr>
                                <th>Total Marks</th>
                                <td><?php echo $assessment['total_marks']; ?></td>
                            </tr>
                            <?php if (isset($assessment['weight_percentage']) && $assessment['weight_percentage']) { ?>
                            <tr>
                                <th>Weight</th>
                                <td><?php echo $assessment['weight_percentage']; ?>%</td>
                            </tr>
                            <?php } ?>
                            <?php if (isset($assessment['due_date']) && $assessment['due_date']) { ?>
                            <tr>
                                <th>Due Date</th>
                                <td><?php echo date('d M Y', strtotime($assessment['due_date'])); ?></td>
                            </tr>
                            <?php } ?>
                        </table>

                        <?php if (isset($assessment['instructions']) && $assessment['instructions']) { ?>
                        <div class="callout callout-warning">
                            <h4>Instructions</h4>
                            <p><?php echo nl2br(htmlspecialchars($assessment['instructions'])); ?></p>
                        </div>
                        <?php } ?>

                        <?php if (isset($assessment['description']) && $assessment['description']) { ?>
                        <div class="callout callout-info">
                            <h4>Description</h4>
                            <p><?php echo nl2br(htmlspecialchars($assessment['description'])); ?></p>
                        </div>
                        <?php } ?>
                    </div>
                    <div class="col-md-4">
                        <div class="box box-solid box-info">
                            <div class="box-header with-border">
                                <h3 class="box-title">Assessment Status</h3>
                            </div>
                            <div class="box-body text-center">
                                <p>This assessment is available for your class.</p>
                                <p class="text-muted">
                                    <i class="fa fa-info-circle"></i>
                                    Please complete this assessment as instructed by your lecturer.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php else: ?>
        <div class="alert alert-danger">
            <i class="fa fa-exclamation-triangle"></i> Assessment not found or you don't have access to it.
        </div>
        <?php endif; ?>
    </section>
</div>
