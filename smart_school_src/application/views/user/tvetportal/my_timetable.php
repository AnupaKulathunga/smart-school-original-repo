<style>
    .tt-card { background: #fff; border-left: 4px solid #3c8dbc; border-radius: 6px; box-shadow: 0 1px 4px rgba(0,0,0,.1); padding: 10px 12px; margin-bottom: 8px; }
    .tt-card .tt-subject { font-weight: 600; font-size: 13px; color: #333; margin-bottom: 4px; }
    .tt-card .tt-detail { font-size: 11.5px; color: #666; line-height: 1.7; }
    .tt-card .tt-detail i { width: 14px; text-align: center; color: #3c8dbc; margin-right: 3px; }
    .tt-empty { background: #f9f9f9; border-radius: 6px; padding: 18px 10px; text-align: center; }
    .tt-empty span { color: #aaa; font-size: 12px; }
    .tt-table th { background: #f5f7fa; font-size: 13px; text-transform: uppercase; letter-spacing: .5px; padding: 10px 8px !important; }
    .tt-table td { vertical-align: top !important; padding: 8px !important; background: #fafbfc; }
    .tt-filter { margin-bottom: 15px; }
    .tt-filter select { max-width: 350px; }
</style>

<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-calendar"></i> <?php echo $title; ?>
        </h1>
    </section>
    <section class="content">

        <?php if (!empty($enrolments)) { ?>
        <!-- Filter by Class -->
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-filter"></i> Filter by Class</h3>
            </div>
            <div class="box-body">
                <div class="tt-filter">
                    <select id="tt_class_filter" class="form-control" onchange="filterTimetable()">
                        <option value="">All Enrolled Classes</option>
                        <?php foreach ($enrolments as $enrolment) { ?>
                            <option value="<?php echo $enrolment['class_id']; ?>" <?php echo ($filter_class_id == $enrolment['class_id']) ? 'selected' : ''; ?>>
                                <?php echo htmlspecialchars($enrolment['subject_name'] . ' - ' . $enrolment['level_code'] . ' (' . $enrolment['cohort_name'] . ')'); ?>
                            </option>
                        <?php } ?>
                    </select>
                </div>
            </div>
        </div>

        <!-- Weekly Timetable -->
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-calendar"></i> Weekly Schedule</h3>
            </div>
            <div class="box-body">
                <?php if (!empty($timetable)) {
                    $has_any = false;
                    foreach ($timetable as $entries) { if ($entries) { $has_any = true; break; } }
                    if ($has_any) { ?>
                    <div class="table-responsive">
                        <table class="table tt-table">
                            <thead>
                                <tr>
                                    <?php foreach ($timetable as $tm_key => $tm_value) { ?>
                                        <th><?php echo $this->lang->line(strtolower($tm_key)); ?></th>
                                    <?php } ?>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <?php foreach ($timetable as $tm_key => $tm_value) { ?>
                                        <td width="14%">
                                            <?php if (!$timetable[$tm_key]) { ?>
                                                <div class="tt-empty"><span><?php echo $this->lang->line('not_scheduled'); ?></span></div>
                                            <?php } else {
                                                foreach ($timetable[$tm_key] as $tm_kue) { ?>
                                                    <div class="tt-card">
                                                        <div class="tt-subject"><?php
                                                            echo $tm_kue->subject_name;
                                                            if ($tm_kue->code != '') {
                                                                echo " (" . $tm_kue->code . ")";
                                                            }
                                                        ?></div>
                                                        <div class="tt-detail">
                                                            <i class="fa fa-clock-o"></i> <?php echo $tm_kue->time_from; ?> - <?php echo $tm_kue->time_to; ?><br>
                                                            <i class="fa fa-user"></i> <?php echo $tm_kue->staff_name . " " . $tm_kue->surname; ?><br>
                                                            <i class="fa fa-building"></i> <?php echo $this->lang->line('room_no'); ?>: <?php echo $tm_kue->room_no; ?>
                                                        </div>
                                                    </div>
                                            <?php }
                                            } ?>
                                        </td>
                                    <?php } ?>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <?php } else { ?>
                        <div class="alert alert-warning">
                            <i class="fa fa-info-circle"></i> No timetable entries found for your enrolled classes. Please contact your campus administration.
                        </div>
                    <?php } ?>
                <?php } else { ?>
                    <div class="alert alert-warning">
                        <i class="fa fa-info-circle"></i> No timetable data available.
                    </div>
                <?php } ?>
            </div>
        </div>

        <!-- Enrolled Classes Summary -->
        <div class="box box-default collapsed-box">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-list"></i> My Enrolled Classes</h3>
                <div class="box-tools pull-right">
                    <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i></button>
                </div>
            </div>
            <div class="box-body" style="display: none;">
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
                                <td><?php echo isset($enrolment['lecturer_name']) && $enrolment['lecturer_name'] ? htmlspecialchars($enrolment['lecturer_name'] . ' ' . $enrolment['lecturer_surname']) : '<em class="text-muted">Not assigned</em>'; ?></td>
                            </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <?php } else { ?>
        <div class="box box-primary">
            <div class="box-body">
                <div class="alert alert-info">
                    <i class="fa fa-info-circle"></i> You are not enrolled in any TVET classes yet.
                </div>
            </div>
        </div>
        <?php } ?>
    </section>
</div>

<script>
function filterTimetable() {
    var classId = document.getElementById('tt_class_filter').value;
    var url = '<?php echo site_url("user/tvetportal/my_timetable"); ?>';
    if (classId) {
        url += '?class_id=' + classId;
    }
    window.location.href = url;
}
</script>
