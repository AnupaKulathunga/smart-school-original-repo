<?php
$currency_symbol = $this->customlib->getSchoolCurrencyFormat();
?>
<div class="content-wrapper">
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <!-- left column -->
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-search"></i> <?php echo $this->lang->line('select_criteria'); ?></h3>
                    </div>
                    <form action="<?php echo site_url('student/multiclass') ?>"  method="post" accept-charset="utf-8">
                        <div class="box-body">
                            <?php echo $this->customlib->getCSRF(); ?>
                            <div class="row">
                                <div class="col-lg-12 col-md-12">
                                    <?php
                                    $this->load->view('admin/_partials/class_selector', [
                                        'selected_class_id' => set_value('class_id'),
                                        'classlist' => $classlist,
                                        'required' => true
                                    ]);
                                    ?>
                                    <span class="text-danger"><?php echo form_error('class_id'); ?></span>
                                </div>
                                <div class="col-sm-12">
                                    <button type="submit" class="btn btn-primary btn-sm pull-right"><i class="fa fa-search"></i> <?php echo $this->lang->line('search'); ?></button>
                                </div>
                            </div>
                        </div>
                    </form>

              
                    <div class="ptt10">
                    
                      
                    
                      <div class="bordertop">
                      <?php  
if (!empty($students)) {
    ?>
                      
                        <div class="box-header with-border">
                            <h3 class="box-title"><i class="fa fa-search"></i> <?php echo $this->lang->line('select_criteria'); ?></h3>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <?php
foreach ($students as $student_key => $student_value) {
        ?>
                                    <form action="<?php echo site_url('student/savemulticlass'); ?>" method="POST" class="update">
                                        <div class="col-md-6">
                                            <div class="panel panel-info">
                                                <div class="panel-body panelheight">

                                                    <?php
echo $this->customlib->getFullName($student_value['firstname'], $student_value['middlename'], $student_value['lastname'], $sch_setting->middlename, $sch_setting->lastname) . " (" . $student_value['admission_no'] . ")";
        ?>
                                                    <input type="hidden" value="<?php echo $student_value['id'] ?>" name="student_id">
                                                    <input type="hidden" value="<?php echo count($student_value['student_sessions']) + 1; ?>" name="nxt_row" class="nxt_row">
                                                    <div class="row">
                                                        <div class="text-center">

                                                            <div class="col-xs-12 col-xs-offset-0 col-sm-3 col-sm-offset-9">
                                                                 <?php if ($this->rbac->hasPrivilege('multi_class_student', 'can_add')) {?>
                                                                <button type="button" class="btn btn-default btn-sm pull-right addrow addrow-mb2010">
                                                                    <i class="fa fa-plus"></i>
                                                                </button>
                                                            <?php }?>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="append_row pluscolmn">

                                                        <?php
if (!empty($student_value['student_sessions'])) {
            $count = 1;
            foreach ($student_value['student_sessions'] as $student_session_key => $student_session_value) {
                ?>
                                                                <div class="row">
                                                                    <input type="hidden" name="row_count[]" value="<?php echo $count; ?>">
                                                                    <div class="col-sm-10 col-lg-10 col-md-8">
                                                                        <div class="form-group">
                                                                            <label for="email"><?php echo $this->lang->line('class'); ?></label>
                                                                            <select name="class_id_<?php echo $count; ?>" class="form-control class_id" >
                                                                                <option value=""><?php echo $this->lang->line('select'); ?></option>
                                                                                <?php
foreach ($classlist as $class) {
                    ?>
                                                                                    <option value="<?php echo $class['id'] ?>" <?php echo set_select('class_id_' . $count, $class['id'], ($class['id'] == $student_session_value->class_id) ? true : false); ?>><?php echo $class['class'] ?></option>
                                                                                    <?php
}
                ?>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-sm-2 col-lg-2 col-md-4">
                                                                        <div class="form-group"><label for="email" style="opacity: 0;"><?php echo $this->lang->line('action') ?></label>
                                                                              <?php if ($this->rbac->hasPrivilege('multi_class_student', 'can_delete')) {?>
                                                                            <button class="btn btn-sm btn-danger rmv_row" type="button"><?php echo $this->lang->line('remove') ?></button>
                                                                        <?php }?>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <?php
$count++;
            }
        }
        ?>

                                                    </div>
                                                </div>
                                                <div class="panel-footer panel-fo">
                                                    <div class="row text-center">

                                                        <div class="col-xs-12 col-xs-offset-0 col-sm-3 col-sm-offset-9">
                                                            <?php if ($this->rbac->hasPrivilege('multi_class_student', 'can_edit')) {?>
                                                            <button type="submit" class="btn btn-default btn-sm pull-right" data-loading-text="<i class='fa fa-spinner fa-spin '></i> <?php echo $this->lang->line('update'); ?>">
                                                                <?php echo $this->lang->line('update'); ?>
                                                            </button>
                                                        <?php }?>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                    <?php
}
    ?>
                            </div>
                        </div>
                        
                        <?php
} else { ?>
        <div class="row"> 
            <div class="col-md-12"> 
                <div class="col-md-12">
                    <div class="alert alert-danger"><?php echo $this->lang->line('no_record_found'); ?></div>
                </div>
            </div>
        </div>
     
     <?php
}
?>
                    </div>
                     
                    
                    
                  </div>
                  </div>
                   
            </div>
        </div>
        <!-- /.row -->
    </section>
    <!-- /.content -->
    <div class="clearfix"></div>
</div>

<?php

function getSectionByClasses($classes, $class_selected, $section_selected)
{
    $options = "";
    foreach ($classes as $key => $value) {
        if ($value['id'] == $class_selected) {
            if (!empty($value['sections'])) {
                foreach ($value['sections'] as $section_key => $section_value) {
                    $selected = "";
                    if ($section_value['section_id'] == $section_selected) {
                        $selected = "selected='selected'";
                    }
                    $options .= "<option value='" . $section_value['section_id'] . "' " . $selected . ">" . $section_value['section'] . "</option>";
                }
            }
        }
    }
    return $options;
}
?>

<script type="text/javascript">
    // this is the id of the form

    $(document).on('submit', '.update', function (e) {
        var submit_btn = $(this).find("button[type=submit]");
        e.preventDefault(); // avoid to execute the actual submit of the form.

        var form = $(this);
        var url = form.attr('action');

        $.ajax({
            type: "POST",
            url: url,
            data: form.serialize(), // serializes the form's elements.
            dataType: "json",
            beforeSend: function () {
                submit_btn.button('loading');
            },
            success: function (data)
            {
                if (data.status == 1) {
                    successMsg(data.message);
                } else {
                    errorMsg(data.message);
                }
                submit_btn.button('reset');
            },
            error: function (xhr) { // if error occured
                alert("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");

            },
            complete: function () {
                submit_btn.button('reset');
            }
        });
    });
</script>

<script type="text/javascript">
    $(document).on('click', '.rmv_row', function (e) {
        $(this).closest( "div.row" ).remove();
    });

    $(document).on('click', '.addrow', function () {
        var container = $(this).closest(".panel-body").find('.append_row');
        var nxt_row = $(this).closest(".panel-body").find('.nxt_row').val();
        var new_class_dropdown = $('#class_dropdown').html().replace("class_id", "class_id_" + nxt_row);
        var $newDiv = $('<div>').addClass('row').append(
                $('<input>', {type: 'hidden', name: 'row_count[]', val: parseInt(nxt_row)})).append(
                $('<div>').addClass('col-sm-10 col-lg-10 col-md-8').append($('<div>').addClass('form-group').append($('<label>').html('<?php echo $this->lang->line("class"); ?>')).append(new_class_dropdown))
                ).append(
                $('<div>').addClass('col-sm-2 col-lg-2 col-md-4').append($('<div>').addClass('form-group').append($('<label>',{ css: {'opacity': 0}}).html('Action')).append(

                    <?php
if ($this->rbac->hasPrivilege('multi_class_student', 'can_delete')) {?>

                    $('<button>').html('<?php echo $this->lang->line("remove"); ?>').addClass('btn btn-sm btn-danger rmv_row')
                    <?php }
?>
                    )));

        $(this).closest(".panel-body").find('.nxt_row').val(parseInt(nxt_row) + 1);
        $newDiv.appendTo(container);

    });
</script>
<script type="text/template" id="class_dropdown">

    <select name="class_id" class="form-control class_id">
    <option value=""><?php echo $this->lang->line('select'); ?></option>
    <?php
foreach ($classlist as $class) {
    ?>
        <option value="<?php echo $class['id'] ?>"><?php echo $class['class'] ?></option>
        <?php
}
?>
    </select>
</script>