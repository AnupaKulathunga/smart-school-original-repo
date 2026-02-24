<div class="content-wrapper"> 
    <section class="content-header">
        <h1><i class="fa fa-mortar-board"></i> <small></small></h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">           
            <div class="col-md-4">       
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><?php echo $this->lang->line('edit_lesson'); ?></h3>
                    </div>  
                    <form   id="lesson_form" name="lesson_form" method="post" accept-charset="utf-8">
                        <div class="box-body">
                            <?php if ($this->session->flashdata('msg')) { ?>
                                <?php echo $this->session->flashdata('msg'); $this->session->unset_userdata('msg'); ?>
                            <?php } ?> 
                            <?php echo $this->customlib->getCSRF(); ?>
                            <div class="form-group">
                                <?php
                                // TVET: Use class_selector component (subject derived from class, read-only in edit)
                                $this->load->view('admin/_partials/class_selector', [
                                    'selected_class_id' => $class_id,
                                    'classlist' => $classlist,
                                    'id' => 'searchclassid',
                                    'required' => true
                                ]);
                                ?>
                                <input type="hidden" id="lesson_subjectid" name="lesson_subjectid" value="<?php echo $lesson_subject_group_subjectid; ?>" >
                            </div><br><br>
                            <div class="form-group">
                                <?php if ($this->rbac->hasPrivilege('lesson', 'can_add')) {
                                    ?>
                                    <lebel class="btn btn-xs btn-info pull-right" onclick="add_lesson()"><?php echo $this->lang->line('add_more'); ?></lebel>
                                <?php } ?>
                            </div>
                            <?php foreach ($editlessonname as $editlessonname_value) { ?>
                                <div class="form-group" id="<?php echo $editlessonname_value['id']; ?>"><label><?php echo $this->lang->line('lesson_name'); ?></label><small class="req"> *</small><input class="lessinput" type="text" name="lessons_<?php echo $editlessonname_value['id']; ?>" value="<?php echo $editlessonname_value['name']; ?>"  />  <?php if ($this->rbac->hasPrivilege('lesson', 'can_delete')) {
                                    ?><span  onclick="remove_lesson('<?php echo $editlessonname_value['id']; ?>')" class="section_id_error text-danger">&nbsp;<i class="fa fa-remove"></i></span><?php } ?></div>
                                <?php } ?>
                            <div id="lesson_result"></div>
                            <div id="lesson_delete"></div>
                        </div>
                        <div class="box-footer">
                            <button type="submit" class="btn btn-info pull-right"><?php echo $this->lang->line('save'); ?></button>
                        </div>
                    </form>
                </div>
            </div>
            <div class="col-md-8">              
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><?php echo $this->lang->line('lesson_list'); ?></h3>
                        <div class="box-tools pull-right">
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="mailbox-controls">
                            <div class="pull-right">
                            </div>
                        </div>
                        <div class="table-responsive mailbox-messages overflow-visible-lg" id="transfee">
                              <table class="table table-striped table-bordered table-hover topic-list " id="headerTable" data-export-title="<?php echo $this->lang->line('lesson_list'); ?>" id="headerTable" >
                                <thead>
                                    <tr class="hide" id="visible">
                                        <td colspan="6"><center><b><?php echo $this->lang->line("lesson_list"); ?></b></center></td>
                                    </tr>
                                <tr>
                                    <th><?php echo $this->lang->line('class'); ?></th>
                                    <th><?php echo $this->lang->line('subject'); ?></th>
                                    <th><?php echo $this->lang->line('lesson'); ?></th>
                                    <th class="mailbox-date text-right noExport "><?php echo $this->lang->line('action'); ?></th>
                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="box-footer">
                        <div class="mailbox-controls">  
                            <div class="pull-right">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">          
            <div class="col-md-12">
            </div>
        </div> 
    </section>
</div>

<script>
    function deletelessonbulk(subject_group_class_sections_id, subject_group_subject_id) {
        if (confirm('<?PHP echo $this->lang->line('delete_confirm') ?>')) {
            $.ajax({
                url: base_url + 'admin/lessonplan/deletelessonbulk/' + subject_group_class_sections_id + '/' + subject_group_subject_id,
                success: function (res) {
                    successMsg(res.message);
                    window.location.replace("<?php echo base_url("admin/lessonplan/lesson") ?>");
                }

            })
        }
    }
</script>

<script>
    $(document).ready(function (e) {
        // TVET: Class is read-only in edit mode
        $('#searchclassid').css('pointer-events', 'none');
    });

    // TVET: Subject group/subject JS removed — subject auto-derived from class

    function add_lesson() {
        var id = makeid(8);
        $('#lesson_result').append('<div class="form-group" id="' + id + '"><label><?php echo $this->lang->line("lesson_name"); ?></label><small class="req"> *</small><br><input type="text" name="lessons[]" class="lessinput" /> <span  onclick="remove_lesson(' + id + ')" class="section_id_error text-danger">&nbsp;<i class="fa fa-remove"></i></span></div>');
    }

    function remove_lesson(id) {
        $('#' + id).html("");
        $('#lesson_delete').append('<input type="hidden" name="lesson_delete[]" value="' + id + '">');
    }

    function makeid(length) {
        var result = '';
        var characters = '0123456789';
        var charactersLength = characters.length;
        for (var i = 0; i < length; i++) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
        }
        return result;
    }

    $("#lesson_form").on('submit', (function (e) {
        e.preventDefault();
        var $this = $(this).find("button[type=submit]:focus");
        var inps = document.getElementsByName('lessons[]');
        for (var i = 0; i < inps.length; i++) {
            var inp = inps[i];
            if (inp.value == '') {
                
            } else {

            }
        }

        $.ajax({
            url: "<?php echo site_url("admin/lessonplan/updatelesson") ?>",
            type: "POST",
            data: new FormData(this),
            dataType: 'json',
            contentType: false,
            cache: false,
            processData: false,
            beforeSend: function () {
                $this.button('loading');
            },
            success: function (res)
            {
                if (res.status == "fail") {
                    var message = "";
                    $.each(res.error, function (index, value) {
                        message += value;
                    });
                    errorMsg(message);
                } else {
                    successMsg(res.message);
                    window.location.replace("<?php echo base_url("admin/lessonplan/lesson") ?>");
                }
            },
            error: function (xhr) { // if error occured
                alert("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");
                $this.button('reset');
            },
            complete: function () {
                $this.button('reset');
            }
        });
    }));
</script>
 
<script>
    ( function ( $ ) {
    'use strict';
    $(document).ready(function () {
        initDatatable('topic-list','admin/lessonplan/getlessonlist',[],[],100);
    });
} ( jQuery ) )
</script>