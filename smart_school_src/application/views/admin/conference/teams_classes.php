<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-windows"></i> <?php echo $this->lang->line('live_class'); ?>
        </h1>
    </section>

    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-windows"></i> Teams <?php echo $this->lang->line('live_class'); ?></h3>
                        <div class="box-tools pull-right">
                            <?php if ($this->rbac->hasPrivilege('live_classes', 'can_add')) { ?>
                                <button type="button" class="btn btn-info btn-sm" data-toggle="modal" data-target="#modal-teams-class"><i class="fa fa-plus"></i> <?php echo $this->lang->line('add'); ?></button>
                            <?php } ?>
                        </div>
                    </div>

                    <div class="box-body">
                        <?php if ($this->session->flashdata('msg')) { ?>
                            <?php echo $this->session->flashdata('msg'); $this->session->unset_userdata('msg'); ?>
                        <?php } ?>

                        <div class="table-responsive">
                            <div class="download_label">Teams <?php echo $this->lang->line('live_class'); ?></div>
                            <table class="table table-hover table-striped table-bordered example">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('class') . ' ' . $this->lang->line('title'); ?></th>
                                        <th><?php echo $this->lang->line('description'); ?></th>
                                        <th><?php echo $this->lang->line('date_time'); ?></th>
                                        <th><?php echo $this->lang->line('duration'); ?> (Min)</th>
                                        <th>Cohort</th>
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
                                                    if (!empty($conference->cohorts)) {
                                                        foreach ($conference->cohorts as $cohort) {
                                                            echo '<span class="label label-primary" style="margin:2px;display:inline-block;"><i class="fa fa-users"></i> ' . $cohort->cohort_name . '</span> ';
                                                        }
                                                    }
                                                    ?>
                                                </td>
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
                                                        if ($this->rbac->hasPrivilege('live_classes', 'can_delete')) {
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

<!-- Add Teams Live Class Modal -->
<div class="modal fade" id="modal-teams-class" data-backdrop="static">
    <div class="modal-dialog modal-lg">
        <form id="form-add-teams-class" action="<?php echo site_url('admin/conference/addTeamsClass'); ?>" method="POST">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title"><i class="fa fa-windows"></i> <?php echo $this->lang->line('add'); ?> Teams <?php echo $this->lang->line('live_class'); ?></h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-lg-8 col-md-8 col-sm-12">
                            <div class="row">
                                <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                    <label><?php echo $this->lang->line('class') . ' ' . $this->lang->line('title'); ?> <small class="req"> *</small></label>
                                    <input type="text" class="form-control" name="title" placeholder="e.g. Business Management N4 - Introduction">
                                    <span class="text text-danger" id="title_error"></span>
                                </div>
                                <div class="clearfix"></div>
                                <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                    <label><?php echo $this->lang->line('date_time'); ?> <small class="req"> *</small></label>
                                    <div class="input-group" id="teams_class_date">
                                        <input type="text" class="form-control" name="date" readonly="readonly" />
                                        <span class="input-group-addon">
                                            <span class="glyphicon glyphicon-calendar"></span>
                                        </span>
                                    </div>
                                </div>
                                <div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6">
                                    <label><?php echo $this->lang->line('duration'); ?> (<?php echo $this->lang->line('minutes'); ?>) <small class="req"> *</small></label>
                                    <input type="number" class="form-control" name="duration" min="5" max="480" value="60">
                                </div>
                                <div class="clearfix"></div>
                                <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12">
                                    <label><?php echo $this->lang->line('description'); ?></label>
                                    <textarea class="form-control" name="description" rows="3" placeholder="Meeting agenda or notes"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-4 col-sm-12">
                            <label class="label15">Cohort <small class="req"> *</small></label>
                            <div class="staffmain" style="max-height:300px;overflow-y:auto;">
                                <ul class="liststaff" style="list-style:none;padding:0;">
                                    <?php
                                    $current_programme = '';
                                    if (!empty($cohorts)) {
                                        foreach ($cohorts as $cohort) {
                                            if ($current_programme != $cohort['programme_name']) {
                                                if ($current_programme != '') {
                                                    echo '</div>';
                                                }
                                                $current_programme = $cohort['programme_name'];
                                                echo '<div class="cohort-programme-group" style="margin-bottom:8px;">';
                                                echo '<strong style="display:block;padding:4px 0;color:#6264A7;border-bottom:1px solid #eee;">' . $cohort['programme_name'] . '</strong>';
                                            }
                                    ?>
                                            <li class="list-group-item" style="padding:4px 8px;">
                                                <div class="checkbox" style="margin:0;">
                                                    <label for="cohort_<?php echo $cohort['id']; ?>" style="font-size:12px;">
                                                        <input type="checkbox" id="cohort_<?php echo $cohort['id']; ?>" value="<?php echo $cohort['id']; ?>" name="cohort_id[]">
                                                        <?php echo $cohort['name']; ?>
                                                        <small class="text-muted">(<?php echo $cohort['level_name']; ?>)</small>
                                                    </label>
                                                </div>
                                            </li>
                                    <?php
                                        }
                                        if ($current_programme != '') {
                                            echo '</div>';
                                        }
                                    }
                                    ?>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary" id="teams_class_submit" data-loading-text="<i class='fa fa-spinner fa-spin'></i> <?php echo $this->lang->line('saving'); ?>"><?php echo $this->lang->line('save'); ?></button>
                </div>
            </div>
        </form>
    </div>
</div>

<script type="text/javascript">
(function($) {
    "use strict";
    var datetime_format = '<?php echo strtr($this->customlib->getSchoolDateFormat(), ['d' => 'DD', 'm' => 'MM', 'M' => 'MMM', 'Y' => 'YYYY']); ?>';

    $('#teams_class_date').datetimepicker({
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

    $("form#form-add-teams-class").submit(function(event) {
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
                    $('#modal-teams-class').modal('hide');
                    successMsg(data.message);
                    window.location.reload(true);
                }
                $button.button('reset');
            },
            error: function() { $button.button('reset'); },
            complete: function() { $button.button('reset'); }
        });
    });

    $('#modal-teams-class').on('hidden.bs.modal', function() {
        $(this).find("input,textarea,select").not("input[type=checkbox]").val('').end();
        $(this).find("input[type=checkbox]").prop('checked', false);
    });
})(jQuery);
</script>
