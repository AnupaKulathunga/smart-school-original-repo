<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-windows"></i> <?php echo $this->lang->line('live_meeting'); ?>
        </h1>
    </section>

    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-windows"></i> Teams <?php echo $this->lang->line('live_meeting'); ?></h3>
                        <div class="box-tools pull-right">
                            <?php if ($this->rbac->hasPrivilege('live_meeting', 'can_add')) { ?>
                                <button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#modal-teams-meeting"><i class="fa fa-plus"></i> <?php echo $this->lang->line('add'); ?></button>
                            <?php } ?>
                        </div>
                    </div>

                    <div class="box-body">
                        <?php if ($this->session->flashdata('msg')) { ?>
                            <?php echo $this->session->flashdata('msg'); $this->session->unset_userdata('msg'); ?>
                        <?php } ?>

                        <div class="table-responsive">
                            <div class="download_label">Teams <?php echo $this->lang->line('live_meeting'); ?></div>
                            <table class="table table-hover table-striped table-bordered example">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('meeting') . ' ' . $this->lang->line('title'); ?></th>
                                        <th><?php echo $this->lang->line('description'); ?></th>
                                        <th><?php echo $this->lang->line('date_time'); ?></th>
                                        <th><?php echo $this->lang->line('duration'); ?> (Min)</th>
                                        <th><?php echo $this->lang->line('created_by'); ?></th>
                                        <th><?php echo $this->lang->line('status'); ?></th>
                                        <th class="text-right"><?php echo $this->lang->line('action'); ?></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    if (!empty($conferences)) {
                                        foreach ($conferences as $conference) {
                                            $return_response = json_decode($conference->return_response);
                                    ?>
                                            <tr>
                                                <td><?php echo $conference->title; ?></td>
                                                <td><?php echo $conference->description; ?></td>
                                                <td><?php echo $this->customlib->dateyyyymmddToDateTimeformat($conference->date); ?></td>
                                                <td><?php echo $conference->duration; ?></td>
                                                <td>
                                                    <?php
                                                    if ($conference->created_id == $logged_staff_id) {
                                                        echo $this->lang->line('self');
                                                    } else {
                                                        $name = ($conference->create_by_surname == "") ? $conference->create_by_name : $conference->create_by_name . " " . $conference->create_by_surname;
                                                        echo $name . " (" . $conference->create_by_role_name . " : " . $conference->create_by_employee_id . ")";
                                                    }
                                                    ?>
                                                </td>
                                                <td>
                                                    <?php
                                                    if ($conference->created_id == $logged_staff_id) {
                                                    ?>
                                                        <form class="chgstatus_form" method="POST" action="<?php echo site_url('admin/conference/chgstatus') ?>">
                                                            <input type="hidden" name="conference_id" value="<?php echo $conference->id; ?>">
                                                            <select class="form-control chgstatus_dropdown" name="chg_status">
                                                                <option value="0" <?php if ($conference->status == 0) echo "selected"; ?>><?php echo $this->lang->line('awaited'); ?></option>
                                                                <option value="1" <?php if ($conference->status == 1) echo "selected"; ?>><?php echo $this->lang->line('cancelled'); ?></option>
                                                                <option value="2" <?php if ($conference->status == 2) echo "selected"; ?>><?php echo $this->lang->line('finished'); ?></option>
                                                            </select>
                                                        </form>
                                                    <?php
                                                    } else {
                                                        if ($conference->status == 0) {
                                                            echo '<span class="label label-warning">' . $this->lang->line('awaited') . '</span>';
                                                        } elseif ($conference->status == 1) {
                                                            echo '<span class="label label-default">' . $this->lang->line('cancelled') . '</span>';
                                                        } else {
                                                            echo '<span class="label label-success">' . $this->lang->line('finished') . '</span>';
                                                        }
                                                    }
                                                    ?>
                                                </td>
                                                <td class="text-right">
                                                    <?php
                                                    if ($conference->status == 0 && !empty($return_response->joinUrl)) {
                                                    ?>
                                                        <a href="<?php echo $return_response->joinUrl; ?>" target="_blank" class="btn btn-xs btn-success" data-toggle="tooltip" title="<?php echo $this->lang->line('join'); ?>">
                                                            <i class="fa fa-video-camera"></i> <?php echo ($conference->created_id == $logged_staff_id) ? $this->lang->line('start') : $this->lang->line('join'); ?>
                                                        </a>
                                                    <?php
                                                    }
                                                    if ($conference->created_id == $logged_staff_id) {
                                                        if ($this->rbac->hasPrivilege('live_meeting', 'can_delete')) {
                                                    ?>
                                                            <a href="<?php echo site_url('admin/conference/deleteTeams/' . $conference->id); ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="<?php echo $this->lang->line('delete'); ?>" onclick="return confirm('<?php echo $this->lang->line('delete_confirm') ?>');">
                                                                <i class="fa fa-remove"></i>
                                                            </a>
                                                    <?php
                                                        }
                                                    }
                                                    ?>
                                                </td>
                                            </tr>
                                    <?php
                                        }
                                    }
                                    ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- Add Teams Meeting Modal -->
<div class="modal fade" id="modal-teams-meeting" data-backdrop="static">
    <div class="modal-dialog modal-lg">
        <form id="form-add-teams-meeting" action="<?php echo site_url('admin/conference/addTeamsMeeting'); ?>" method="POST">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><i class="fa fa-windows"></i> <?php echo $this->lang->line('add') . ' ' . $this->lang->line('live_meeting'); ?></h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-8 col-md-8 col-sm-12">
                            <div class="row">
                                <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                    <label><?php echo $this->lang->line('meeting') . ' ' . $this->lang->line('title'); ?> <small class="req"> *</small></label>
                                    <input type="text" class="form-control" name="title" placeholder="e.g. Department Meeting">
                                </div>
                                <div class="clearfix"></div>
                                <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                    <label><?php echo $this->lang->line('date_time'); ?> <small class="req"> *</small></label>
                                    <div class="input-group" id="teams_meeting_date">
                                        <input type="text" class="form-control" name="date" readonly="readonly" />
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </div>
                                <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                    <label><?php echo $this->lang->line('duration'); ?> (<?php echo $this->lang->line('minutes'); ?>) <small class="req"> *</small></label>
                                    <input type="number" class="form-control" name="duration" min="5" max="480" value="30">
                                </div>
                                <div class="clearfix"></div>
                                <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                    <label><?php echo $this->lang->line('description'); ?></label>
                                    <textarea class="form-control" name="description" rows="3" placeholder="Meeting agenda"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-4 col-sm-12">
                            <label class="label15"><?php echo $this->lang->line('staff') . ' ' . $this->lang->line('list'); ?> <small class="req"> *</small></label>
                            <div class="staffmain">
                                <ul class="liststaff">
                                    <?php
                                    if (is_array($staffList)) {
                                        foreach ($staffList as $staff_value) {
                                            if ($staff_value['id'] == $logged_staff_id) continue;
                                    ?>
                                            <li class="list-group-item">
                                                <div class="checkbox">
                                                    <label for="staff_<?php echo $staff_value['id']; ?>">
                                                        <input type="checkbox" id="staff_<?php echo $staff_value['id']; ?>" value="<?php echo $staff_value['id']; ?>" name="staff[]">
                                                        <?php
                                                        $name = ($staff_value["surname"] == "") ? $staff_value["name"] : $staff_value["name"] . " " . $staff_value["surname"];
                                                        echo $name . " (" . $staff_value['employee_id'] . ")";
                                                        ?>
                                                    </label>
                                                </div>
                                            </li>
                                    <?php
                                        }
                                    }
                                    ?>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary" id="teams_meeting_submit" data-loading-text="<i class='fa fa-spinner fa-spin'></i> <?php echo $this->lang->line('saving'); ?>"><?php echo $this->lang->line('save'); ?></button>
                </div>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
(function($) {
    "use strict";
    var datetime_format = '<?php echo strtr($this->customlib->getSchoolDateFormat(), ['d' => 'DD', 'm' => 'MM', 'M' => 'MMM', 'Y' => 'YYYY']); ?>';

    $('#teams_meeting_date').datetimepicker({
        format: datetime_format + " HH:mm",
        showTodayButton: true,
        ignoreReadonly: true,
        locale: moment.locale('en', { week: { dow: start_week } })
    });

    $(document).on('change', '.chgstatus_dropdown', function() {
        $(this).parent('form.chgstatus_form').submit();
    });

    $("form.chgstatus_form").submit(function(e) {
        e.preventDefault();
        var form = $(this);
        $.ajax({
            type: "POST",
            url: form.attr('action'),
            data: form.serialize(),
            dataType: "JSON",
            success: function(data) {
                if (data.status == 0) {
                    var message = "";
                    $.each(data.error, function(index, value) { message += value; });
                    errorMsg(message);
                } else {
                    successMsg(data.message);
                    window.location.reload(true);
                }
            }
        });
    });

    $("form#form-add-teams-meeting").submit(function(event) {
        event.preventDefault();
        var $form = $(this), url = $form.attr('action');
        var $button = $form.find("button[type=submit]");
        $.ajax({
            type: "POST",
            url: url,
            data: $form.serialize(),
            dataType: "JSON",
            beforeSend: function() { $button.button('loading'); },
            success: function(data) {
                if (data.status == 0) {
                    var message = "";
                    $.each(data.error, function(index, value) { message += value; });
                    errorMsg(message);
                } else {
                    $('#modal-teams-meeting').modal('hide');
                    successMsg(data.message);
                    window.location.reload(true);
                }
                $button.button('reset');
            },
            error: function() { $button.button('reset'); },
            complete: function() { $button.button('reset'); }
        });
    });

    $('#modal-teams-meeting').on('hidden.bs.modal', function() {
        $(this).find("input,textarea,select").not("input[type=checkbox]").val('').end();
        $(this).find("input[type=checkbox]").prop('checked', false);
    });
})(jQuery);
</script>
