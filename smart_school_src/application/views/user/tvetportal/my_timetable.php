<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-calendar"></i> <?php echo $title; ?>
        </h1>
    </section>
    <section class="content">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">My Class Schedule</h3>
            </div>
            <div class="box-body">
                <?php if (!empty($enrolments)) { ?>
                <div class="callout callout-info">
                    <h4><i class="fa fa-info"></i> Enrolled Classes</h4>
                    <p>Below are your enrolled TVET classes. For detailed timetable information, please contact your campus administration.</p>
                </div>

                <h4>My Enrolled Classes</h4>
                <div class="table-responsive">
                    <table class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <th>Class Code</th>
                                <th>Subject</th>
                                <th>Level</th>
                                <th>Cohort</th>
                                <th>Venue</th>
                                <th>Lecturer</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($enrolments as $enrolment) { ?>
                            <tr>
                                <td><strong><?php echo htmlspecialchars($enrolment['class_code']); ?></strong></td>
                                <td><?php echo htmlspecialchars($enrolment['subject_name']); ?></td>
                                <td><span class="label label-info"><?php echo $enrolment['level_code']; ?></span></td>
                                <td><?php echo htmlspecialchars($enrolment['cohort_name']); ?></td>
                                <td><?php echo isset($enrolment['venue']) && $enrolment['venue'] ? htmlspecialchars($enrolment['venue']) : '-'; ?></td>
                                <td>
                                    <?php echo isset($enrolment['lecturer_name']) && $enrolment['lecturer_name'] ? htmlspecialchars($enrolment['lecturer_name'] . ' ' . $enrolment['lecturer_surname']) : '<em class="text-muted">Not assigned</em>'; ?>
                                </td>
                            </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
                <?php } else { ?>
                <div class="alert alert-info">
                    <i class="fa fa-info-circle"></i> You are not enrolled in any TVET classes yet.
                </div>
                <?php } ?>
            </div>
        </div>
    </section>
</div>
