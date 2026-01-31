<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-bar-chart"></i> <?php echo $title; ?>
        </h1>
    </section>
    <section class="content">
        <?php if (!empty($results_by_class)) { ?>
        <?php foreach ($results_by_class as $class_result) { ?>
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <?php echo htmlspecialchars($class_result['subject_name']); ?>
                    <span class="label label-info"><?php echo $class_result['level_code']; ?></span>
                </h3>
                <div class="box-tools pull-right">
                    <?php if ($class_result['icass_average'] > 0) { ?>
                    <span class="badge bg-<?php echo ($class_result['icass_average'] >= 40) ? 'green' : 'red'; ?>">
                        ICASS: <?php echo $class_result['icass_average']; ?>%
                    </span>
                    <?php } ?>
                </div>
            </div>
            <div class="box-body">
                <?php if (!empty($class_result['marks'])) { ?>
                <div class="table-responsive">
                    <table class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <th>Assessment</th>
                                <th>Type</th>
                                <th class="text-center">Weight</th>
                                <th class="text-center">Marks</th>
                                <th class="text-center">Percentage</th>
                                <th class="text-center">Grade</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($class_result['marks'] as $mark) { ?>
                            <tr class="<?php echo (isset($mark->percentage) && $mark->percentage !== null && $mark->percentage < 40) ? 'danger' : ''; ?>">
                                <td><?php echo htmlspecialchars($mark->title); ?></td>
                                <td><span class="label label-default"><?php echo $mark->assessment_type; ?></span></td>
                                <td class="text-center">
                                    <?php echo isset($mark->weight_percentage) && $mark->weight_percentage ? $mark->weight_percentage . '%' : '-'; ?>
                                </td>
                                <td class="text-center">
                                    <?php if (isset($mark->marks_obtained) && $mark->marks_obtained !== null) { ?>
                                        <?php echo $mark->marks_obtained; ?> / <?php echo $mark->total_marks; ?>
                                    <?php } else { ?>
                                        <span class="text-muted">-</span>
                                    <?php } ?>
                                </td>
                                <td class="text-center">
                                    <?php if (isset($mark->percentage) && $mark->percentage !== null) { ?>
                                    <span class="<?php echo ($mark->percentage < 40) ? 'text-danger' : 'text-success'; ?>">
                                        <?php echo number_format($mark->percentage, 1); ?>%
                                    </span>
                                    <?php } else { ?>
                                    -
                                    <?php } ?>
                                </td>
                                <td class="text-center">
                                    <?php if (isset($mark->grade) && $mark->grade) { ?>
                                    <span class="label label-<?php echo ($mark->grade == 'F') ? 'danger' : 'success'; ?>">
                                        <?php echo $mark->grade; ?>
                                    </span>
                                    <?php } else { ?>
                                    -
                                    <?php } ?>
                                </td>
                            </tr>
                            <?php } ?>
                        </tbody>
                        <?php if (isset($class_result['final_mark']) && $class_result['final_mark'] !== null) { ?>
                        <tfoot>
                            <tr class="info">
                                <th colspan="3" class="text-right">Final Mark:</th>
                                <th class="text-center" colspan="2">
                                    <span class="<?php echo ($class_result['final_mark'] < 40) ? 'text-danger' : 'text-success'; ?>">
                                        <?php echo $class_result['final_mark']; ?>%
                                    </span>
                                </th>
                                <th class="text-center">
                                    <?php if (isset($class_result['final_result']) && $class_result['final_result']) { ?>
                                    <span class="label label-<?php echo ($class_result['final_result'] == 'Fail') ? 'danger' : 'success'; ?>">
                                        <?php echo $class_result['final_result']; ?>
                                    </span>
                                    <?php } ?>
                                </th>
                            </tr>
                        </tfoot>
                        <?php } ?>
                    </table>
                </div>
                <?php } else { ?>
                <p class="text-muted">No results available yet for this class.</p>
                <?php } ?>
            </div>
        </div>
        <?php } ?>
        <?php } else { ?>
        <div class="box box-default">
            <div class="box-body">
                <div class="alert alert-info">
                    <i class="fa fa-info-circle"></i> No results available. You may not be enrolled in any TVET classes yet, or no marks have been entered.
                </div>
            </div>
        </div>
        <?php } ?>
    </section>
</div>
