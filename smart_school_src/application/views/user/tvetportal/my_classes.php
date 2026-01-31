<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-graduation-cap"></i> <?php echo $title; ?>
        </h1>
    </section>
    <section class="content">
        <?php if ($this->session->flashdata('msg')) { ?>
            <?php echo $this->session->flashdata('msg'); ?>
        <?php } ?>

        <?php if (!empty($enrolments)) { ?>
        <div class="row">
            <?php foreach ($enrolments as $enrolment) { ?>
            <div class="col-md-4 col-sm-6">
                <div class="box box-widget widget-user-2">
                    <div class="widget-user-header bg-aqua">
                        <h3 class="widget-user-username"><?php echo htmlspecialchars($enrolment['subject_name']); ?></h3>
                        <h5 class="widget-user-desc">
                            <span class="label label-default"><?php echo htmlspecialchars($enrolment['level_code']); ?></span>
                            <?php echo htmlspecialchars($enrolment['class_code']); ?>
                        </h5>
                    </div>
                    <div class="box-body">
                        <p>
                            <strong>Cohort:</strong>
                            <?php echo htmlspecialchars($enrolment['cohort_name']); ?>
                        </p>
                        <p>
                            <strong>Lecturer:</strong>
                            <?php echo isset($enrolment['lecturer_name']) && $enrolment['lecturer_name'] ? htmlspecialchars($enrolment['lecturer_name'] . ' ' . $enrolment['lecturer_surname']) : '<em class="text-muted">Not assigned</em>'; ?>
                        </p>
                        <p>
                            <strong>Venue:</strong>
                            <?php echo isset($enrolment['venue']) && $enrolment['venue'] ? htmlspecialchars($enrolment['venue']) : '-'; ?>
                        </p>
                        <p>
                            <strong>Status:</strong>
                            <?php
                            $status_colors = array('Active' => 'success', 'Dropped' => 'danger', 'Completed' => 'info', 'Suspended' => 'warning');
                            $status = isset($enrolment['status']) ? $enrolment['status'] : 'Active';
                            $color = isset($status_colors[$status]) ? $status_colors[$status] : 'default';
                            ?>
                            <span class="label label-<?php echo $color; ?>"><?php echo $status; ?></span>
                        </p>
                    </div>
                    <div class="box-footer">
                        <a href="<?php echo base_url('user/tvetportal/class_detail/' . $enrolment['class_id']); ?>" class="btn btn-primary btn-sm">
                            <i class="fa fa-eye"></i> View Details
                        </a>
                    </div>
                </div>
            </div>
            <?php } ?>
        </div>
        <?php } else { ?>
        <div class="box box-default">
            <div class="box-body">
                <div class="alert alert-info">
                    <i class="fa fa-info-circle"></i> You are not enrolled in any TVET classes yet.
                </div>
            </div>
        </div>
        <?php } ?>
    </section>
</div>
