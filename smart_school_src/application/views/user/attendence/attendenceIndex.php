<script src="<?php echo base_url() ?>backend/fullcalendar/dist/fullcalendar.min.js"></script>
<script src="<?php echo base_url() ?>backend/fullcalendar/dist/locale-all.js"></script>

<?php if ($language_shortcode['short_code'] != 'en') { ?>
    <script src="<?php echo base_url() ?>backend/fullcalendar/dist/locale/<?php echo $language_shortcode['short_code']; ?>.js"></script>
<?php } ?>

<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"> <?php echo $this->lang->line('attendance'); ?></h3>

                        <?php
                        // TVET: Show class filter dropdown if student is enrolled in multiple classes
                        if (!empty($enrolled_classes) && count($enrolled_classes) > 1) {
                            ?>
                            <div class="box-tools pull-right">
                                <div class="form-inline">
                                    <label for="class_filter"><?php echo $this->lang->line('filter_by_class') ?: 'Filter by Class'; ?>:</label>
                                    <select id="class_filter" class="form-control input-sm" style="width: auto; display: inline-block; margin-left: 5px;">
                                        <option value=""><?php echo $this->lang->line('all_classes') ?: 'All Classes'; ?></option>
                                        <?php foreach ($enrolled_classes as $class) { ?>
                                            <option value="<?php echo $class->class_id; ?>" <?php echo ($selected_class_id == $class->class_id) ? 'selected' : ''; ?>>
                                                <?php echo htmlspecialchars($class->subject_code . ' ' . $class->level_code . ' - ' . $class->class_code); ?>
                                            </option>
                                        <?php } ?>
                                    </select>
                                </div>
                            </div>
                            <?php
                        }
                        ?>
                    </div>
                    <div class="box-body">
                        <?php
                        // TVET: Show enrolled classes summary
                        if (!empty($enrolled_classes)) {
                            ?>
                            <div class="row mb-3">
                                <div class="col-md-12">
                                    <div class="alert alert-info">
                                        <strong><?php echo $this->lang->line('enrolled_classes') ?: 'Enrolled Classes'; ?>:</strong>
                                        <?php
                                        $class_names = array();
                                        foreach ($enrolled_classes as $class) {
                                            $class_names[] = $class->subject_name . ' (' . $class->level_code . ')';
                                        }
                                        echo implode(', ', $class_names);
                                        ?>
                                    </div>
                                </div>
                            </div>
                            <?php
                        } else {
                            ?>
                            <div class="alert alert-warning">
                                <?php echo $this->lang->line('no_enrolled_classes') ?: 'You are not enrolled in any classes for the current session.'; ?>
                            </div>
                            <?php
                        }
                        ?>

                        <!-- TVET: Attendance Legend -->
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <span class="label label-success"><?php echo $this->lang->line('present') ?: 'Present'; ?></span>
                                <span class="label label-danger"><?php echo $this->lang->line('absent') ?: 'Absent'; ?></span>
                                <span class="label label-warning"><?php echo $this->lang->line('late') ?: 'Late'; ?></span>
                                <span class="label label-info"><?php echo $this->lang->line('excused') ?: 'Excused'; ?></span>
                            </div>
                        </div>

                        <div id="calendar_attendance"></div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<script type="application/javascript">
    $calendar_attendance = $('#calendar_attendance');
    var base_url = '<?php echo base_url() ?>';
    var selected_class_id = '<?php echo $selected_class_id ?: ''; ?>';
    today = new Date();

    y = today.getFullYear();
    m = today.getMonth();
    d = today.getDate();

    var viewtitle = 'month';

    // TVET: Build events URL with optional class filter
    function getEventsUrl() {
        var url = base_url + 'user/attendence/getAttendence';
        if (selected_class_id) {
            url += '?class_id=' + selected_class_id;
        }
        return url;
    }

    function initCalendar() {
        $calendar_attendance.fullCalendar('destroy');

        $calendar_attendance.fullCalendar({
            viewRender: function (view, element) {
            },

            header: {
                center: 'title',
                right: '',
                left: 'prev,next'
            },
            firstDay: start_week,
            defaultDate: today,
            defaultView: viewtitle,
            selectable: true,
            selectHelper: true,
            views: {
                month: {
                    titleFormat: 'MMMM YYYY'
                }
            },
            timezone: 'UTC',
            draggable: false,
            lang: '<?php echo $language_shortcode['short_code']; ?>',
            editable: false,
            eventLimit: 4, // TVET: Allow "more" link when multiple classes on same day

            events: {
                url: getEventsUrl()
            },

            eventRender: function (event, element) {
                // TVET: Show class code in tooltip
                var tooltipText = event.title;
                if (event.description) {
                    tooltipText += ' - ' + event.description;
                }
                element.attr('title', tooltipText);
                element.attr('data-toggle', 'tooltip');

                if ((!event.url) && (event.event_type != 'task')) {
                    element.click(function () {
                        // Could show attendance details modal here
                    });
                }
            },
            dayClick: function (date, jsEvent, view) {
                console.log('Clicked on day: ' + date.format());
                return false;
            }
        });
    }

    // Initialize calendar
    initCalendar();

    // TVET: Handle class filter change
    $('#class_filter').on('change', function() {
        selected_class_id = $(this).val();
        initCalendar();
    });
</script>
