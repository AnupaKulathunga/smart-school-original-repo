<link rel="stylesheet" href="<?php echo base_url(); ?>backend/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">
<script src="<?php echo base_url(); ?>backend/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.all.min.js"></script>
<!-- Content Wrapper. Contains page content -->

<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-info">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix"> <?php echo $this->lang->line('homework'); ?></h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo base_url(); ?>user/homework/dailyassignment" class="btn btn-sm btn-primary" data-method_call="add" autocomplete="off">  <?php echo $this->lang->line('daily_assignment'); ?></a>
                        </div>
                    </div>

                    <div class="box-body pb0">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label><?php echo $this->lang->line('subject'); ?></label>
                                    <select id="subject_filter" class="form-control input-sm">
                                        <option value=""><?php echo $this->lang->line('all'); ?></option>
                                        <?php if (!empty($subjectlist)) { foreach ($subjectlist as $sub) { ?>
                                            <option value="<?php echo $sub['name']; ?>"><?php echo $sub['name']; ?><?php if($sub['code']){ echo ' ('.$sub['code'].')'; } ?></option>
                                        <?php } } ?>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                        <div class="nav-tabs-custom mb0">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tab_1" data-toggle="tab"><?php echo $this->lang->line('upcoming_homework'); ?></a></li>
                            <li><a href="#tab_2" class="closed-exam" data-toggle="tab"><?php echo $this->lang->line('closed_homework'); ?></a></li>
                        </ul>
                    </div>
                    <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">
                    <div class="box-body table-responsive">
                        <div > <div class="download_label"><?php echo $this->lang->line('homework_list'); ?></div>
                            <table class="table table-hover table-striped table-bordered example">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('class') ?></th>
                                        <th><?php echo $this->lang->line('subject') ?></th>
                                        <th><?php echo $this->lang->line('homework_date'); ?></th>
                                        <th><?php echo $this->lang->line('submission_date'); ?></th>
                                        <th><?php echo $this->lang->line('evaluation_date'); ?></th>
                                        <th><?php echo $this->lang->line('max_marks'); ?></th>
                                        <th><?php echo $this->lang->line('marks_obtained'); ?></th>
                                        <th><?php echo $this->lang->line('note'); ?></th>
                                        <th><?php echo $this->lang->line('status'); ?></th>
                                        <th class="text-right noExport"><?php echo $this->lang->line('action') ?></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
$upload_docsButton = 0;

foreach ($homeworklist as $key => $homework) {

    if (date('Y-m-d') <= date('Y-m-d', strtotime($homework['submit_date']))) {
        $upload_docsButton = 1;
    }
    ?>
                                        <tr>
                                            <td><?php echo $homework["class"] ?></td>
                                            <td><?php echo $homework['subject_name']; ?> <?php if($homework['subject_code']){ echo '('.$homework['subject_code'].')'; } ?> </td>
                                            <td><?php echo $this->customlib->dateformat($homework['homework_date']); ?></td>
                                            <td><?php echo $this->customlib->dateformat($homework['submit_date']); ?></td>
                                            <td><?php
$evl_date = "";
    if (!IsNullOrEmptyString($homework['evaluation_date'])) {
        echo $this->customlib->dateformat($homework['evaluation_date']);
    }
    ?></td>
                                                <td><?php echo $homework["marks"]; ?></td>
                                                <td><?php echo $homework["evaluation_marks"]; ?></td>
                                                <td><?php echo $homework["note"]; ?></td>
                                            <td>
                                                <?php

    if ($homework["status"] == 'submitted') {
        $status_class    = "class= 'label label-warning'";
        $status_homework = $this->lang->line('submitted');
    } else {
        $status_class    = "class= 'label label-danger'";
        $status_homework = $this->lang->line("pending");
    }

    $h_status = 0;
    if ($homework["homework_evaluation_id"] != 0) {
        $h_status        = 1;
        $status_class    = "class= 'label label-success'";
        $status_homework = $this->lang->line("evaluated");
    }

    ?>
                                                <label <?php echo $status_class; ?>><?php echo $status_homework; ?></label>

                                            </td>
                                            <td class="mailbox-date pull-right">
<span data-toggle="tooltip" title="<?php echo $this->lang->line('view_edit'); ?>"><a class="btn btn-default btn-xs" onclick="evaluation(<?php echo $homework['id']; ?>,<?php echo $h_status; ?>);" title="" data-target="#evaluation" data-toggle="modal"  data-original-title="Evaluation">
                                                    <i class="fa fa-reorder"></i></a></span>
                                            </td>
                                        </tr>
                                    <?php }?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="tab-pane " id="tab_2">
                   <div class="box-body table-responsive">
                        <div > <div class="download_label"><?php echo $this->lang->line('homework_list'); ?></div>
                            <table class="table table-hover table-striped table-bordered example">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('class') ?></th>
                                        <th><?php echo $this->lang->line('subject') ?></th>
                                        <th><?php echo $this->lang->line('homework_date'); ?></th>
                                        <th><?php echo $this->lang->line('submission_date'); ?></th>
                                        <th><?php echo $this->lang->line('evaluation_date'); ?></th>
                                        <th><?php echo $this->lang->line('max_marks'); ?></th>
                                        <th><?php echo $this->lang->line('marks_obtained'); ?></th>
                                        <th><?php echo $this->lang->line('note'); ?></th>
                                        <th><?php echo $this->lang->line('status'); ?></th>
                                        <th class="text-right noExport"><?php echo $this->lang->line('action') ?></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
$upload_docsButton = 0;

foreach ($closedhomeworklist as $key => $closedhomework) {

    if (date('Y-m-d') <= date('Y-m-d', strtotime($closedhomework['submit_date']))) {
        $upload_docsButton = 1;
    }
    ?>
                                        <tr>
                                            <td><?php echo $closedhomework["class"] ?></td>
                                            <td><?php echo $closedhomework['subject_name']; ?> <?php if($closedhomework['subject_code']){ echo '('.$closedhomework['subject_code'].')'; } ?></td>
                                            <td><?php echo $this->customlib->dateformat($closedhomework['homework_date']); ?></td>
                                            <td><?php echo $this->customlib->dateformat($closedhomework['submit_date']); ?></td>
                                            <td><?php
$evl_date = "";
    if (!IsNullOrEmptyString($closedhomework['evaluation_date'])) {
        echo $this->customlib->dateformat($closedhomework['evaluation_date']);
    }
    ?></td>
                                                <td><?php echo $closedhomework["marks"]; ?></td>
                                                <td><?php echo $closedhomework["evaluation_marks"]; ?></td>
                                                <td><?php echo $closedhomework["note"]; ?></td>
                                            <td>
                                                <?php

    if ($closedhomework["status"] == 'submitted') {
        $status_class    = "class= 'label label-warning'";
        $status_homework = $this->lang->line('submitted');
    } else {
        $status_class    = "class= 'label label-danger'";
        $status_homework = $this->lang->line("pending");
    }

    $h_status = 0;
    if ($closedhomework["homework_evaluation_id"] != 0) {
        $h_status        = 1;
        $status_class    = "class= 'label label-success'";
        $status_homework = $this->lang->line("evaluated");
    }

    ?>
                                                <label <?php echo $status_class; ?>><?php echo $status_homework; ?></label>
                                            </td>
                                            <td class="mailbox-date pull-right ss">

<span data-toggle="tooltip" title="<?php echo $this->lang->line('view_edit'); ?>"><a class="btn btn-default btn-xs" onclick="evaluation(<?php echo $closedhomework['id']; ?>,<?php echo $h_status; ?>);" title="" data-target="#evaluation" data-toggle="modal"  data-original-title="Evaluation">
                                                    <i class="fa fa-reorder" ></i></a></span>
                                            </td>
                                        </tr>
                                    <?php } ?>

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
                </div>
            </div>
        </div>
    </section>
</div>

<div class="modal fade" id="evaluation" tabindex="-1" role="dialog" aria-labelledby="evaluation" style="padding-left: 0 !important">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content modal-media-content">
            <div class="modal-header modal-media-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="box-title"><?php echo $this->lang->line('homework_details'); ?></h4>
            </div>
            <div class="modal-body pt0 pb0" id="evaluation_details">
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var date_format = '<?php echo $result = strtr($this->customlib->getSchoolDateFormat(), ['d' => 'dd', 'm' => 'mm', 'Y' => 'yyyy']) ?>';
        $('#homework_date,#submit_date,#homeworkdate,#submitdate').datepicker({
            format: date_format,
            autoclose: true
        });

        $("#btnreset").click(function () {
            $("#form1")[0].reset();
        });
    });
</script>

<script>
    $(function () {
        $("#compose-textarea,#desc-textarea").wysihtml5();
    });
</script>

<script type="text/javascript">
    function getRecord(id) {

        $.ajax({
            url: "<?php echo site_url("homework/getRecord/") ?>" + id,
            type: "POST",
            dataType: 'json',

            success: function (res)
            {
                // TVET: section_id no longer needed
                $("#homeworkdate").val(new Date(res.homework_date).toString("MM/dd/yyyy"));
                $("#submitdate").val(new Date(res.submit_date).toString("MM/dd/yyyy"));
                $("#desc-textarea").text(res.description);
                $('iframe').contents().find('.wysihtml5-editor').html(res.description);
                $('select[id="classid"] option[value="' + res.class_id + '"]').attr("selected", "selected");
                $("#homeworkid").val(res.id);
                $("#document").val(res.document);
            }
        });
    }


    // TVET: Removed getSubjectByClassandSection - section no longer used

    function evaluation(id, status) {

        $('#evaluation_details').html("");
        $.ajax({
            url: baseurl+'user/homework/homework_detail/' + id + '/' + status,
            success: function (data) {
                $('#evaluation_details').html(data);
            },
            error: function () {
                alert("<?php echo $this->lang->line('fail'); ?>");
            }
        });
    }

    function addhomework() {
        $('iframe').contents().find('.wysihtml5-editor').html("");
    }

    $('#subject_filter').on('change', function() {
        var selectedSubject = $(this).val();
        $('.tab-content table tbody tr').each(function() {
            if (selectedSubject === '') {
                $(this).show();
            } else {
                var subjectCell = $(this).find('td:eq(2)').text().trim();
                if (subjectCell.indexOf(selectedSubject) !== -1) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            }
        });
    });
    
    $(document).ready(function (e) {

        $('#evaluation').modal({
            backdrop: 'static',
            keyboard: false,
            show:false
        });
 
    });

</script>