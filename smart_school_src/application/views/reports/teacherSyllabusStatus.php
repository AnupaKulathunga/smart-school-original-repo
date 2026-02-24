<?php
$language = $this->customlib->getLanguage();
$language_name = $language["short_code"];
?>
<div class="content-wrapper">
    <section class="content">
        <?php $this->load->view('reports/_lesson_plan'); ?>
        <div class="box removeboxmius">
            <div class="box-header ptbnull">
                <h3 class="box-title"><i class="fa fa-search"></i> <?php echo $this->lang->line('select_criteria'); ?></h3>
            </div>
            <form class="assign_teacher_form" action="<?php echo base_url(); ?>report/teachersyllabusstatus/" method="post" enctype="multipart/form-data">
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-12">
                            <?php if ($this->session->flashdata('msg')) { ?>
                                <?php 
                                    echo $this->session->flashdata('msg');
                                    $this->session->unset_userdata('msg');
                                ?>
                            <?php } ?>
                            <?php echo $this->customlib->getCSRF(); ?>
                        </div>
                        <div class="col-md-6 col-lg-6 col-sm-12">
                            <?php
                            // TVET: Use class_selector component
                            $this->load->view('admin/_partials/class_selector', [
                                'selected_class_id' => isset($class_id) ? $class_id : '',
                                'classlist' => $classlist,
                                'required' => true,
                                'id' => 'searchclassid'
                            ]);
                            ?>
                            <span class="class_id_error text-danger"></span>
                        </div>
                    </div>
                    <button type="submit" id="search_filter" name="search" value="search_filter" class="btn btn-primary btn-sm checkbox-toggle pull-right"><i class="fa fa-search"></i> <?php echo $this->lang->line('search'); ?></button>
            </form>
        </div>

        <?php if (!empty($subjects_data) && $subject_name != '') {
            ?>
             
            <div class="box-body" id="transfee">                
                <div class="box-header ptbnull">
                    <h3 class="box-title titlefix"><i class="fa fa-money"></i>  <?php
                                echo $this->lang->line('subject_lesson_plan_report_for') . ": " . $subject_name;
                                if ($subject_name != '') {
                                    echo " " . $this->lang->line('complete') . " " . $subject_complete . "%";
                                }
                                ?></h3>
                </div>                        
                <div class="download_label">
                            <?php
                                echo $this->lang->line('subject_lesson_plan_report_for') . ": " . $subject_name;
                                if ($subject_name != '') {
                                    echo " " . $this->lang->line('complete') . " " . $subject_complete . "%";
                                }
                                ?>
                </div>
                <table class="table table-bordered syllbus" id="headerTable">                    
                    <tbody>
                        <?php
                        foreach ($subjects_data as $key => $value) {
                            ?>
                            <tr>
                                <td>
                                    <table class="table table-striped table-bordered table-hover example" >
                                        <thead>
                                            <tr>  
                                                <th class="text-left"><?php echo $this->lang->line('teacher'); ?></th>    
                                                <th class="text-left"><?php echo $this->lang->line('lesson_name'); ?></th>     
                                                <th class="text-left"><?php echo $this->lang->line('topic_name'); ?></th> 
                                                <th class="text-left"><?php echo $this->lang->line('sub_topic'); ?></th>
                                                <th class="text-left"><?php echo $this->lang->line('date'); ?></th>
                                                <th><?php echo $this->lang->line('time_from'); ?></th>
                                                <th class="text-left"><?php echo $this->lang->line('time_to'); ?></th>                
                                            </tr> 
                                        </thead>
                                        <tbody>
                                            <?php
                                            foreach ($value['teachers_summary'] as $teachers_summarykey => $teachers_summaryvalue) {
                                                foreach ($teachers_summaryvalue['summary_report'] as $summary_report_key => $summary_report_value) {
                                                    ?>
                                                    <tr>  
                                                        <td class="text-left"><?php echo $teachers_summaryvalue['name']; ?></td>   
                                                        <td class="text-left"><?php echo $summary_report_value['lesson_name'] ?></td>
                                                        <td class="text-left"><?php echo $summary_report_value['topic_name'] ?></td>
                                                        <td class="text-left"><?php echo $summary_report_value['sub_topic'] ?></td>                  
                                                        <td class="text-left"><?php echo date($this->customlib->getSchoolDateFormat(), strtotime($summary_report_value['date'])); ?></td>
                                                        <td class="text-left"><?php echo $summary_report_value['time_from']; ?></td>
                                                        <td class="text-left"><?php echo $summary_report_value['time_to']; ?></td>
                                                    </tr>
                                                    <?php }
                                                }
                                                ?>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
            <?php } ?> 
                    </tbody>
                </table>
            </div>
    <?php
} else {
    ?>
            <div class="tab-pane active table-responsive box-body" >
                <div class="download_label"> <?php echo $this->lang->line('subject_lesson_plan_report'); ?></div>
                <table class="table table-striped table-bordered table-hover example" cellspacing="0" width="100%">
                    <thead>
                        <tr>
                            <th><?php echo $this->lang->line('teacher'); ?></th>    
                            <th><?php echo $this->lang->line('lesson_name'); ?></th>       
                            <th><?php echo $this->lang->line('topic_name'); ?></th> 
                            <th><?php echo $this->lang->line('sub_topic'); ?></th>             
                            <th><?php echo $this->lang->line('date'); ?></th>
                            <th><?php echo $this->lang->line('time_from'); ?></th>
                            <th><?php echo $this->lang->line('time_to'); ?></th>
                            <th class="pull-right noExport"><?php echo $this->lang->line('action'); ?></th>    
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
<?php }
?>
    </section>
</div>

<div class="modal fade syllbus" id="assignsyllabus" tabindex="-1" role="dialog" aria-labelledby="evaluation" style="padding-left: 0 !important">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content modal-media-content">
            <div class="modal-header modal-media-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="box-title" ><?php echo $this->lang->line('lesson_plan'); ?> </h4>
            </div>
            <div class="modal-body pt0 pb0">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12">
                        <div class="row">                               
                            <div id="syllabus_result" class=""></div> 
                        </div><!--./row-->
                    </div><!--./col-md-12-->
                </div><!--./row-->
            </div>
        </div>
    </div>
</div>

<div class="modal fade syllbus" id="lacture_youtube_modal"  role="dialog" aria-labelledby="evaluation" style="background: rgba(0, 0, 0, 0.98);" >
    <div class="modal-dialog modal-lg" role="document" style="width:100%;height:100%">
        <div class="modal-content modal-media-content">
            <div class="modal-header modal-media-header">
                <button type="button" onclick="videoUrlBlank()" class="close" data-dismiss="modal">&times;</button>
                <h4 class="box-title" ><?php echo $this->lang->line('youtube_link') ?></h4>
            </div>
            <div class="modal-body pt0 pb0">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12">
                        <div class="row"  style="width:100%;height:660px">
                            <div id="video_url" ></div>
                        </div><!--./row-->
                    </div><!--./col-md-12-->
                </div><!--./row-->
            </div>
        </div>
    </div>
</div>

<script>
    $(document).on('submit','.assign_teacher_form', function(){
        document.getElementById('search_filter').disabled = true;
    });
    
    function subject_syllabusdelete(syllabus_id) {
        if (confirm('<?PHP echo $this->lang->line('delete_confirm') ?>')) {
            $.ajax({
                type: "POST",
                url: base_url + "admin/syllabus/delete_subject_syllabus",
                data: {'id': syllabus_id},
                success: function (data) {
                    successMsg('<?php echo $this->lang->line("delete_message"); ?>');
                    window.location.reload(true);
                },
            });
        }
    }
    
    function videoUrlBlank() {
        $('#video_url').html('');
    }
</script>

<script>
    function run_video(lacture_youtube_url) {
        $('#lacture_youtube_modal').modal('show');
        var str = lacture_youtube_url;
        var res = str.split("=");
        $('#video_url').html('<iframe width="100%" height="650px" src="//www.youtube.com/embed/' + res[1] + '?rel=0&version=3&modestbranding=1&autoplay=1&controls=1&showinfo=1&loop=1mode=opaque&amp;rel=0&amp;autohide=1&amp;showinfo=0&amp;wmode=transparent" frameborder="0" allowfullscreen></iframe>');
    }
</script> 

<script>
    function get_subject_syllabus(id, staff_id) {
        $('#assignsyllabus').modal('show');
        $('#syllabus_result').html('');
        $.ajax({
            type: "POST",
            url: base_url + "admin/syllabus/get_subject_syllabus",
            data: {'id': id, 'staff_id': staff_id},
            success: function (data) {
                $('#syllabus_result').html(data);
            },
        });
    }

    $(document).ready(function () {
        $(document).on('click', '.chk', function () {           
            var checked = $(this).is(':checked');
            var rowid = $(this).data('rowid');
            var role = $(this).data('role');
            if (checked) {
                if (!confirm("<?php echo $this->lang->line('are_you_sure_you_active_account'); ?>")) {
                    $(this).removeAttr('checked');
                } else {
                    var status = "yes";
                }
            } else if (!confirm("<?php echo $this->lang->line('are_you_sure_you_deactive_account'); ?>")) {
                $(this).prop("checked", true);
            } else {
                var status = "no";
            }
        });
    });
</script>

<!-- TVET: Subject group/subject JS removed — subject auto-derived from class --> 