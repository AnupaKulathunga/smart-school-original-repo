<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-folder-open"></i> <?php echo $title; ?>
        </h1>
    </section>
    <section class="content">
        <div class="callout callout-info">
            <h4><i class="fa fa-info"></i> Portfolio of Evidence (POE)</h4>
            <p>Your Portfolio of Evidence contains all documents, assessments, and evidence required for your qualification. Each class has its own POE requirements.</p>
        </div>

        <?php if (!empty($poe_items)) { ?>
        <?php foreach ($poe_items as $class_code => $class_poe) { ?>
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">
                    <?php echo htmlspecialchars($class_poe['class_info']['subject_name']); ?>
                    <span class="label label-info"><?php echo $class_poe['class_info']['level_code']; ?></span>
                </h3>
            </div>
            <div class="box-body">
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Type</th>
                                <th>Submitted Date</th>
                                <th class="text-center">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($class_poe['items'] as $item) { ?>
                            <tr>
                                <td>
                                    <?php echo htmlspecialchars($item['title']); ?>
                                    <?php if (isset($item['file_path']) && $item['file_path']) { ?>
                                    <a href="<?php echo base_url('uploads/poe/' . $item['file_path']); ?>" target="_blank" class="btn btn-xs btn-default">
                                        <i class="fa fa-download"></i>
                                    </a>
                                    <?php } ?>
                                </td>
                                <td><span class="label label-default"><?php echo isset($item['item_type']) ? $item['item_type'] : 'Document'; ?></span></td>
                                <td><?php echo isset($item['submitted_date']) ? date('d M Y', strtotime($item['submitted_date'])) : '-'; ?></td>
                                <td class="text-center">
                                    <?php
                                    $status = isset($item['verification_status']) ? $item['verification_status'] : 'Pending';
                                    $status_colors = array('Pending' => 'warning', 'Verified' => 'success', 'Rejected' => 'danger');
                                    $color = isset($status_colors[$status]) ? $status_colors[$status] : 'default';
                                    ?>
                                    <span class="label label-<?php echo $color; ?>"><?php echo $status; ?></span>
                                </td>
                            </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <?php } ?>
        <?php } else { ?>
        <div class="box box-default">
            <div class="box-body">
                <?php if (!empty($enrolments)) { ?>
                <div class="alert alert-info">
                    <i class="fa fa-info-circle"></i> No POE items have been submitted yet for your classes.
                </div>
                <h4>Your Enrolled Classes:</h4>
                <ul>
                    <?php foreach ($enrolments as $enrolment) { ?>
                    <li>
                        <strong><?php echo htmlspecialchars($enrolment['subject_name']); ?></strong>
                        (<span class="label label-info"><?php echo $enrolment['level_code']; ?></span>)
                        - <?php echo htmlspecialchars($enrolment['class_code']); ?>
                    </li>
                    <?php } ?>
                </ul>
                <?php } else { ?>
                <div class="alert alert-info">
                    <i class="fa fa-info-circle"></i> You are not enrolled in any TVET classes yet.
                </div>
                <?php } ?>
            </div>
        </div>
        <?php } ?>
    </section>
</div>
