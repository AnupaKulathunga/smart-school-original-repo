<div class="content-wrapper">
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-search"></i> <?php echo $this->lang->line('select_criteria'); ?></h3>
                    </div>
                    <div class="box-body">
                        <form role="form" action="<?php echo site_url('admin/onlineexam/assign/' . $id) ?>" method="post" class="row">
                            <?php echo $this->customlib->getCSRF(); ?>
                            <input type="hidden" name="onlineexam_id" value="<?php echo $onlineexam->id; ?>">
                                <div class="col-md-12">
                                    <?php
                                    $this->load->view('admin/_partials/class_selector', [
                                        'selected_class_id' => set_value('class_id'),
                                        'classlist' => $classlist
                                    ]);
                                    ?>
                                </div>
                            <div class="form-group">
                                <div class="col-md-12">
                                    <button type="submit" name="search" value="search_filter" class="btn btn-primary pull-right btn-sm checkbox-toggle"><i class="fa fa-search"></i> <?php echo $this->lang->line('search'); ?></button>
                                </div>
                            </div>
                        </form>
                    </div>
                <form method="post" action="<?php echo site_url('admin/onlineexam/addstudent') ?>" id="assign_form">

                    <?php
if (isset($resultlist)) {
    ?>
                      <div class="box-header ptbnull"></div>
                        <div class="">
                            <div class="box-header with-border">
                                <h3 class="box-title"><i class="fa fa-users"></i> <?php echo $this->lang->line('assign_online_exam'); ?></h3>
                                <div class="box-tools pull-right">
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="row">
                                        <div class="col-md-4">
                                            <div class="table-responsive">
                                                <h4>
                                                    <input type="hidden" name="onlineexam_id" value="<?php echo $onlineexam->id; ?>">
                                                    <input type="hidden" name="post_class_id" value="<?php echo $class_id; ?>">
                                                    <a href="#" data-toggle="popover" class="detail_popover"><?php echo $onlineexam->exam; ?></a>
                                                </h4>

                                            </div>
                                        </div>
                                        <div class="col-md-8">
                                            <div class=" table-responsive">
                                                <table class="table table-striped">
                                                    <tbody>
                                                        <tr>
                                                            <th><input style="vertical-align: text-top;" type="checkbox" id="select_all"/> <?php echo $this->lang->line('all'); ?></th>
                                                            <th><?php echo $this->lang->line('admission_no'); ?></th>
                                                            <th><?php echo $this->lang->line('student_name'); ?></th>
                                                            <th><?php echo $this->lang->line('class'); ?></th>
                                                            <?php if ($sch_setting->father_name) {?>
                                                            <th><?php echo $this->lang->line('father_name'); ?></th><?php }if ($sch_setting->category) {?>
                                                            <th><?php echo $this->lang->line('category'); ?></th>
                                                        <?php }?>
                                                            <th class="pull-right"><?php echo $this->lang->line('gender'); ?></th>
                                                        </tr>
                                                        <?php
if (empty($resultlist)) {
        ?>
                                                            <tr>
                                                                <td colspan="7" class="text-danger text-center"><?php echo $this->lang->line('no_record_found'); ?></td>
                                                            </tr>
                                                            <?php
} else {
        $count = 1;
        foreach ($resultlist as $student) {
            ?>
                                                                <tr>
                                                                    <td>
                                                                        <?php
if ($student['onlineexam_student_session_id'] != 0) {
                $sel = "checked='checked'";
            } else {
                $sel = "";
            }
            ?>
                                                                        <input type="hidden" name="all_students[]" value="<?php echo $student['onlineexam_student_session_id']; ?>">
                                                                        <input class="checkbox" type="checkbox" name="students_id[]"  value="<?php echo $student['student_session_id']; ?>" <?php echo $sel; ?>/>
                                                                    </td>
                                                                    <td><?php echo $student['admission_no']; ?></td>

                                                                    <td><?php echo $this->customlib->getFullName($student['firstname'], $student['middlename'], $student['lastname'], $sch_setting->middlename, $sch_setting->lastname); ?></td>
                                                                    <td><?php echo $student['class'] . " (" . $student['section'] . ")"; ?></td><?php if ($sch_setting->father_name) {?>
                                                                    <td><?php echo $student['father_name']; ?></td>
                                                                <?php }if ($sch_setting->category) {?>
                                                                    <td><?php echo $student['category']; ?></td>
                                                                <?php }?>
                                                                    <td class="pull-right"><?php echo $this->lang->line(strtolower($student['gender'])); ?></td>
                                                                </tr>
                                                                <?php
}
        $count++;
    }
    ?>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <?php if ($this->rbac->hasPrivilege('online_assign_view_student', 'can_edit')) {?>
                                            <button type="submit" class="allot-fees btn btn-primary btn-sm pull-right" id="load" data-loading-text="<i class='fa fa-spinner fa-spin '></i> <?php echo $this->lang->line('please_wait'); ?>"><?php echo $this->lang->line('save'); ?>
                                            </button>
                                        <?php }?>
                                            <br/>
                                            <br/>
                                        </div>
                                </div>
                            </div>
                        </div>
                        <?php
}
?>
                </form>
            </div>
        </div>
    </section>
</div>

<!-- Confirmation Modal -->
<div class="modal fade" id="confirm-assign" tabindex="-1" role="dialog" aria-labelledby="confirmAssignLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="confirmAssignLabel"><?php echo $this->lang->line('confirmation'); ?></h4>
            </div>
            <div class="modal-body">
                <p><?php echo $this->lang->line('are_you_sure'); ?></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><?php echo $this->lang->line('cancel'); ?></button>
                <button type="button" class="btn btn-primary btn-confirm-assign" data-loading-text="<i class='fa fa-spinner fa-spin'></i> <?php echo $this->lang->line('please_wait'); ?>"><?php echo $this->lang->line('save'); ?></button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    var date_format = '<?php echo $result = strtr($this->customlib->getSchoolDateFormat(), ['d' => 'dd', 'm' => 'mm', 'Y' => 'yyyy']) ?>';

    // TVET: No section dropdown - class_id is self-contained

//select all checkboxes
    $("#select_all").change(function () {  //"select all" change
        $(".checkbox").prop('checked', $(this).prop("checked")); //change all ".checkbox" checked status
    });

    $('.checkbox').change(function () {
        //uncheck "select all", if one of the listed checkbox item is unchecked
        if (false == $(this).prop("checked")) { //if this item is unchecked
            $("#select_all").prop('checked', false); //change "select all" checked status to false
        }

        if ($('.checkbox:checked').length == $('.checkbox').length) {
            $("#select_all").prop('checked', true);
        }
    });

    // Show confirmation modal on form submit
    $("#assign_form").submit(function (e) {
        e.preventDefault();
        $('#confirm-assign').modal('show');
    });

    // Handle confirm button click in modal
    $(document).on('click', '.btn-confirm-assign', function () {
        var $this = $(this);
        var $saveBtn = $('.allot-fees');
        $.ajax({
            type: "POST",
            dataType: 'Json',
            url: $("#assign_form").attr('action'),
            data: $("#assign_form").serialize(),
            beforeSend: function () {
                $this.button('loading');
                $saveBtn.button('loading');
            },
            success: function (data) {
                if (data.status == "fail") {
                    var message = "";
                    $.each(data.error, function (index, value) {
                        message += value;
                    });
                    $('#confirm-assign').modal('hide');
                    errorMsg(message);
                } else {
                    $('#confirm-assign').modal('hide');
                    // Store success message in localStorage to show after redirect
                    localStorage.setItem('flash_success_msg', data.message);
                    window.location.href = "<?php echo site_url('admin/onlineexam'); ?>";
                }
                $this.button('reset');
                $saveBtn.button('reset');
            },
            complete: function () {
                $this.button('reset');
                $saveBtn.button('reset');
            }
        });
    });
</script>