<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            <i class="fa fa-mortar-board"></i> <?php //echo $this->lang->line('academics'); ?> <small><?php //echo $this->lang->line('student_fees1'); ?></small></h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-search"></i> <?php echo $this->lang->line('select_criteria'); ?></h3>
                        <?php if($this->rbac->hasPrivilege('class_timetable', 'can_edit'))  { ?>
                        <div class="box-tools pull-right">
                            <a href="<?php echo site_url('admin/timetable/create') ?>" type="button"  class="btn btn-sm btn-primary" autocomplete="off"><i class="fa fa-plus"></i> <?php echo $this->lang->line('add'); ?></a>
                        </div>
                        <?php } ?>
                    </div>
                    <form action="<?php echo site_url('admin/timetable/classreport') ?>" method="post" accept-charset="utf-8">
                        <div class="box-body">

                            <?php echo $this->customlib->getCSRF(); ?>
                            <div class="row">
                                <div class="col-md-12">
                                    <?php
                                    $this->load->view('admin/_partials/class_selector', [
                                        'selected_class_id' => set_value('class_id'),
                                        'classlist' => $classlist
                                    ]);
                                    ?>
                                </div>
                            </div>
                        </div>
                        <div class="box-footer">
                            <button type="submit" class="btn btn-primary pull-right btn-sm" name="search"><?php echo $this->lang->line('search'); ?></button>
                        </div>
                    </form>

                    <?php
                    if (isset($timetable)) {
                        ?>
                        <style>
                            .tt-card { background: #fff; border-left: 4px solid #3c8dbc; border-radius: 6px; box-shadow: 0 1px 4px rgba(0,0,0,.1); padding: 10px 12px; margin-bottom: 8px; }
                            .tt-card .tt-subject { font-weight: 600; font-size: 13px; color: #333; margin-bottom: 4px; }
                            .tt-card .tt-detail { font-size: 11.5px; color: #666; line-height: 1.7; }
                            .tt-card .tt-detail i { width: 14px; text-align: center; color: #3c8dbc; margin-right: 3px; }
                            .tt-empty { background: #f9f9f9; border-radius: 6px; padding: 18px 10px; text-align: center; }
                            .tt-empty span { color: #aaa; font-size: 12px; }
                            .tt-table th { background: #f5f7fa; font-size: 13px; text-transform: uppercase; letter-spacing: .5px; padding: 10px 8px !important; }
                            .tt-table td { vertical-align: top !important; padding: 8px !important; background: #fafbfc; }
                        </style>
                        <div class="box-header ptbnull"></div>
                        <div class="box-body">
                            <?php
                            if (!empty($timetable)) {
                                ?>
   <button type="submit" title="<?php echo $this->lang->line('print'); ?>" class="btn btn-primary btn-xs pull-right  print_timetable"  data-class_id="<?php echo set_value('class_id');?>" id="load" data-loading-text="<i class='fa fa-spinner fa-spin'></i> <?php echo $this->lang->line('please_wait'); ?>"><i class="fa fa-print"></i></button>
                                <div class="table-responsive">
                                    <table class="table tt-table">
                                        <thead>
                                            <tr>
                                                <?php
                                                foreach ($timetable as $tm_key => $tm_value) {
                                                    ?>
                                                    <th><?php echo $this->lang->line(strtolower($tm_key)); ?></th>
                                                    <?php
                                                }
                                                ?>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <?php
                                                foreach ($timetable as $tm_key => $tm_value) {
                                                    ?>
                                                    <td width="14%">
                                                        <?php
                                                        if (!$timetable[$tm_key]) {
                                                            ?>
                                                            <div class="tt-empty"><span><?php echo $this->lang->line('not_scheduled'); ?></span></div>
                                                            <?php
                                                        } else {
                                                            foreach ($timetable[$tm_key] as $tm_k => $tm_kue) {
                                                                ?>
                                                                <div class="tt-card">
                                                                    <div class="tt-subject"><?php
                                                                        echo $tm_kue->subject_name;
                                                                        if ($tm_kue->code != '') {
                                                                            echo " (" . $tm_kue->code . ")";
                                                                        }
                                                                    ?></div>
                                                                    <div class="tt-detail">
                                                                        <i class="fa fa-clock-o"></i> <?php echo $tm_kue->time_from; ?> - <?php echo $tm_kue->time_to; ?><br>
                                                                        <i class="fa fa-user"></i> <?php echo $tm_kue->name . " " . $tm_kue->surname . " (" . $tm_kue->employee_id . ")"; ?><br>
                                                                        <i class="fa fa-building"></i> <?php echo $this->lang->line('room_no'); ?>: <?php echo $tm_kue->room_no; ?>
                                                                    </div>
                                                                </div>
                                                                <?php
                                                            }
                                                        }
                                                        ?>
                                                    </td>
                                                    <?php
                                                }
                                                ?>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <?php
                            }
                            ?>

                        </div>
                    </div>
                </div>
                <?php
            }
            ?>


    </section>
</div>


<script type="text/javascript">
    $(document).on('focus', '.time', function () {
        var $this = $(this);
        $this.datetimepicker({
            format: 'LT'
        });
    });
    // TVET: No section dropdown - class_id is self-contained
    // Removed section and subject_group population JavaScript
    var tot_count = 0;
    $(document).ready(function () {
        $('#myTabs a:first').tab('show'); // Select first tab
    });

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {

        var target = $(e.target).attr("href"); // activated tab
        var target_id = $(e.target).attr("id"); // activated tab
        var ajax_data = $(e.target).data(); // activated tab
        $(target).html("");
        getGroupdata(target, target_id, ajax_data);
    })

    function getGroupdata(target, target_id, ajax_data) {
        // TVET: Removed section_id from AJAX call
        $.ajax({
            type: 'POST',
            url: base_url + "admin/timetable/getBydategroupclasssection",
            data: {'day': ajax_data.day, 'class_id': ajax_data.c, 'subject_group_id': ajax_data.group},
            dataType: 'json',
            beforeSend: function () {
                $(target).addClass('show');
            },
            success: function (data) {
                $(target).html(data.html);

                $('.staff', target).select2({
                    dropdownAutoWidth: true,
                    width: '100%'
                });
                $('.subject', target).select2({
                    dropdownAutoWidth: true,
                    width: '100%'
                });
                tot_count = data.total_count + 1;
            },
            error: function (xhr) { // if error occured

            },
            complete: function () {
                $(target).removeClass('show');
            }
        });
    }


    $(document).ready(function () {
        var counter = 0;

        $(document).on("click", ".addrow", function () {

            var newRow = $("<tr>");
            var cols = "";
            cols += '<td><input type="hidden" name="total_row[]" value="' + tot_count + '"><input type="hidden" name="prev_id_' + tot_count + '" value="0"><select class="form-control subject" id="subject_id_' + tot_count + '" name="subject_' + tot_count + '">' + $("#subject_dropdown").text() + '</select></td>';
            cols += '<td><select class="form-control staff" id="staff_id_' + tot_count + '" name="staff_' + tot_count + '">' + $("#staff_dropdown").text() + '</select></td>';

            cols += '<td><div class="input-group"><input type="text" name="time_from_' + tot_count + '" class="form-control time_from time" id="time_from_' + tot_count + '"  aria-invalid="false"><div class="input-group-addon"><span class="glyphicon glyphicon-dashboard"></span></div></div></td>';

            cols += '<td><div class="input-group"><input type="text" name="time_to_' + tot_count + '" class="form-control time_to time" id="time_to_' + tot_count + '"  aria-invalid="false"><div class="input-group-addon"><span class="glyphicon glyphicon-dashboard"></span></div></div></td>';

            cols += '<td><input type="text" class="form-control room_no" name="room_no_' + tot_count + '" id="room_no_' + tot_count + '"/></td>';
            cols += '<td><button type="button" class="ibtnDel btn btn-danger btn-sm btn-danger"><i class="fa fa-trash"></i></button></td>';
            newRow.append(cols);

            $("table.order-list").append(newRow);

            $('.staff', newRow).select2({
                dropdownAutoWidth: true,
                width: '100%'
            });

            $('.subject', newRow).select2({
                dropdownAutoWidth: true,
                width: '100%'
            });
            tot_count++;
        });

        $(document).on("click", ".ibtnDel", function (event) {
            $(this).closest("tr").remove();
            counter -= 1
        });

        $(document).on('click', '.submit_subject_group', function () {
            var form_id = $(this).closest("form").attr('id');
            var target = $('.nav-tabs .active a').attr("href"); // activated tab
            var target_id = $('.nav-tabs .active a').attr("id"); // activated tab
            var ajax_data = $('.nav-tabs .active a').data(); // activated tab

        });

    });

    
</script>


<script type="text/template" id="staff_dropdown">
    <option value=""><?php echo $this->lang->line('select') ?></option>
    <?php
    foreach ($staff as $staff_key => $staff_value) {
        ?>
        <option value="<?php echo $staff_value['id']; ?>"><?php echo $staff_value['name'] . " " . $staff_value['surname'] . " (" . $staff_value['employee_id'] . ")"; ?></option>
        <?php
    }
    ?>
</script>

<script type="text/template" id="subject_dropdown">
    <option value=""><?php echo $this->lang->line('select') ?></option>
    <?php
    foreach ($subject as $subject_key => $subject_value) {
        ?>
        <option value="<?php echo $subject_value->id; ?>" ><?php echo $subject_value->name . " (" . $subject_value->code . ")"; ?></option>
        <?php
    }
    ?>
    

</script>

<script>
        // TVET: Removed section_id from print timetable
        $(document).on('click', '.print_timetable', function (e) {
        e.preventDefault(); // avoid to execute the actual submit of the form.
        var $this = $(this);
        var class_id = $this.data('class_id');
        $.ajax(
                {
                    url: base_url+'admin/timetable/printclasstimetable',
                    type: "POST",
                    data: {'class_id': class_id},
                    dataType: 'Json',
                    beforeSend: function () {
                $this.button('loading');
            },
                    success: function (data, textStatus, jqXHR)
                    {

                         Popup(data.page);
                        $this.button('reset');
                    },
                    error: function (jqXHR, textStatus, errorThrown)
                    {
                        $this.button('reset');
                    }, complete: function () {
                        $this.button('reset');
                    }
                });
    });
    function Popup(data, winload = false)
    {
        var frameDoc=window.open('', 'Print-Window');
        frameDoc.document.open();
        //Create a new HTML document.
        frameDoc.document.write('<html>');
        frameDoc.document.write('<head>');
        frameDoc.document.write('<title></title>');
        frameDoc.document.write('<link rel="stylesheet" href="' + base_url + 'backend/bootstrap/css/bootstrap.min.css">');
        frameDoc.document.write('<link rel="stylesheet" href="' + base_url + 'backend/dist/css/font-awesome.min.css">');
        frameDoc.document.write('<link rel="stylesheet" href="' + base_url + 'backend/dist/css/ionicons.min.css">');
        frameDoc.document.write('<link rel="stylesheet" href="' + base_url + 'backend/dist/css/AdminLTE.min.css">');
        frameDoc.document.write('<link rel="stylesheet" href="' + base_url + 'backend/dist/css/skins/_all-skins.min.css">');
        frameDoc.document.write('<link rel="stylesheet" href="' + base_url + 'backend/plugins/iCheck/flat/blue.css">');
        frameDoc.document.write('<link rel="stylesheet" href="' + base_url + 'backend/plugins/morris/morris.css">');
        frameDoc.document.write('<link rel="stylesheet" href="' + base_url + 'backend/plugins/jvectormap/jquery-jvectormap-1.2.2.css">');
        frameDoc.document.write('<link rel="stylesheet" href="' + base_url + 'backend/plugins/datepicker/datepicker3.css">');
        frameDoc.document.write('<link rel="stylesheet" href="' + base_url + 'backend/plugins/daterangepicker/daterangepicker-bs3.css">');
        frameDoc.document.write('</head>');
        frameDoc.document.write('<body onload="window.print()">');
        frameDoc.document.write(data);
        frameDoc.document.write('</body>');
        frameDoc.document.write('</html>');
        frameDoc.document.close();
        setTimeout(function () {
            frameDoc.close();      
            if (winload) {
                window.location.reload(true);
            }
        }, 5000);

        return true;
    }
</script>