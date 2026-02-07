<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-calendar-check-o"></i> <?php // echo $this->lang->line('attendance'); ?>
        </h1>
    </section>
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix"> <?php echo $this->lang->line('attendance'); ?></h3>
                        <div class="box-tools pull-right">
                        </div>
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
                                        <?php echo count($enrolled_classes); ?> <?php echo $this->lang->line('classes') ?: 'class(es)'; ?>
                                        <br>
                                        <small>
                                            <?php
                                            $class_names = array();
                                            foreach ($enrolled_classes as $class) {
                                                $class_names[] = $class->subject_name . ' (' . $class->subject_code . ' ' . $class->level_code . ')';
                                            }
                                            echo implode(', ', $class_names);
                                            ?>
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <?php
                        }
                        ?>

                        <div class="row">
                            <div class="col-lg-3 col-md-3 col-sm-4">
                                <div class="form-group">
                                    <label for="exampleInputEmail1"><?php echo $this->lang->line('date'); ?></label> <small class="req"> *</small>
                                    <input id="dob" name="dob" placeholder="" type="text" class="form-control date" value="<?php echo date($this->customlib->getSchoolDateFormat(), $this->customlib->dateyyyymmddTodateformat(date('Y-m-d'))); ?>" />
                                </div>
                            </div>
                        </div>

                        <!-- TVET: Attendance Legend -->
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <span class="label label-success"><?php echo $this->lang->line('present') ?: 'Present'; ?></span>
                                <span class="label label-danger"><?php echo $this->lang->line('absent') ?: 'Absent'; ?></span>
                                <span class="label label-warning"><?php echo $this->lang->line('late') ?: 'Late'; ?></span>
                                <span class="label label-info"><?php echo $this->lang->line('excused') ?: 'Excused'; ?></span>
                                <span class="label label-default"><?php echo $this->lang->line('not_marked') ?: 'Not Marked'; ?></span>
                            </div>
                        </div>

                        <div class="attendance_result">
                            <!-- TVET: Results loaded via AJAX -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var date_format = '<?php echo $result = strtr($this->customlib->getSchoolDateFormat(), ['d' => 'dd', 'm' => 'mm', 'Y' => 'yyyy']) ?>';

        // Load attendance for today on page load
        attendance.result($('#dob').val());

        $('.date').datepicker({
            format: date_format,
            autoclose: true,
            weekStart: start_week,
        }).on('changeDate', dateChanged);

        function dateChanged(ev) {
            var date = $('#dob').val();
            if (date != "") {
                attendance.result(date);
            } else {
                errorMsg("<?php echo $this->lang->line('date_field_is_required'); ?>");
                $('.attendance_result').html("");
            }
        }
    });

    attendance = {
        result: function (date_var) {
            $.ajax({
                url: baseurl + "user/attendence/getdaysubattendence",
                type: "POST",
                data: {'date': date_var},
                dataType: 'json',

                beforeSend: function () {
                    $('.attendance_result').html('<div class="text-center"><i class="fa fa-spinner fa-spin fa-2x"></i></div>');
                },
                success: function (res) {
                    if (res.status == 1) {
                        $('.attendance_result').html(res.result_page);
                    } else {
                        $('.attendance_result').html('<div class="alert alert-danger"><?php echo $this->lang->line('error_occurred_please_try_again'); ?></div>');
                    }
                },
                error: function (xhr) {
                    alert("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");
                },
                complete: function () {
                }
            });
        }
    }
</script>
