<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-flask"></i>
    </section>
    <!-- Main content -->
    <section class="content">      
        <div class="box removeboxmius">
            <div class="box-header ptbnull"></div>
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-search"></i> <?php echo $this->lang->line('select_criteria'); ?></h3>
            </div>          
            
            <form  class="search_daily_assignment_form" action="<?php echo base_url(); ?>homework/assignmentvalidation" method="post" enctype="multipart/form-data">             
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-12">
                            <?php if ($this->session->flashdata('msg')) {?>
                                <?php
                                    echo $this->session->flashdata('msg');
                                    $this->session->unset_userdata('msg');
                                ?>
                            <?php }?>
                            <?php echo $this->customlib->getCSRF(); ?>
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <?php
                            // TVET: Use class_selector component (subject derived from class)
                            $this->load->view('admin/_partials/class_selector', [
                                'selected_class_id' => $class_id,
                                'classlist' => $classlist,
                                'required' => true,
                                'id' => 'searchclassid',
                                'name' => 'class_id'
                            ]);
                            ?>
                            <span class="text-danger" id="error_class_id"></span>
                        </div>
                        <div class="col-md-2 col-lg-2 col-sm-4">
                            <div class="form-group">
                                <label><?php echo $this->lang->line('date'); ?></label><small class="req"> *</small>
                                <input type="text" name="date" class="form-control date">
                                <span class="text-danger" id="error_date"></span>
                            </div>
                        </div>
                    </div>
                    <button type="submit" id="search_filter" name="search" value="search_filter" class="btn btn-primary btn-sm checkbox-toggle pull-right"><i class="fa fa-search"></i> <?php echo $this->lang->line('search'); ?></button>
                </div>
            </form>
            <div class="col-md-12" id="errorinfo">
            </div>
            <div class="" id="box_display">
                <div class="box-header ptbnull"></div>
                <div class="box-header with-border">
                    <h3 class="box-title"><i class="fa fa-users"> </i> <?php echo $this->lang->line('daily_assignment_list'); ?></h3>
                </div>
                <div class="box-body table-responsive">                    
                    <table class="table table-striped table-bordered table-hover dailyassignmentlist" data-export-title="<?php echo $this->lang->line('daily_assignment_list') . "<br>";
$this->customlib->get_postmessage();
?>">
                        <thead>
                            <tr>
                                <th><?php echo $this->lang->line('student_name') ?></th>
                                <th><?php echo $this->lang->line('class'); ?> </th>
                                <th><?php echo $this->lang->line('subject'); ?></th>
                                <th><?php echo $this->lang->line('title'); ?></th>
                                <th><?php echo $this->lang->line('submission_date'); ?></th>
                                <th><?php echo $this->lang->line('evaluation_date') ?></th>
                                <th><?php echo $this->lang->line('evaluated_by'); ?></th>
                                <th class="noExport"><?php echo $this->lang->line('action'); ?></th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
        </div><!--./box box-primary-->
        <div class="modal fade" id="assignmentevaluation" tabindex="-1" role="dialog" aria-labelledby="evaluation">
        <div class="modal-dialog modal-lg" role="document">
         <form id="evaluation_data" method="post">
        <div class="modal-content modal-media-content">
            <div class="modal-header modal-media-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="box-title" ><?php  echo $this->lang->line('daily_assignment_evaluation'); ?> </h4>
            </div>
            <div class="modal-body ptt10 pb0" id="">
               <div class="form-group">
                    <label><?php  echo $this->lang->line('remark'); ?></label>
                    <textarea name="remark" id="remark" rows="5" class="form-control"></textarea>
               </div> 
               <div class="form-group">
                    <label><?php  echo $this->lang->line('evaluation_date'); ?></label><small class="req"> *</small>
                    <input type="text" name="evaluation_date" id="evaluation_date" class="form-control date"></textarea>
                    <input type="hidden" name="assigment_id" id="assigment_id">
               </div> 
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-info pull-right" id="submit" data-loading-text="<i class='fa fa-spinner fa-spin '></i> <?php echo $this->lang->line('please_wait'); ?>"><?php echo $this->lang->line('save') ?></button>
            </div>
        </div>
    </form>
    </div>
</div>
    </section>
</div>

<div class="modal fade" id="report" tabindex="-1" role="dialog" aria-labelledby="evaluation">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content modal-media-content">
            <div class="modal-header modal-media-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="box-title" id="modal_head"></h4>
            </div>
            <div class="modal-body pt0 pb0" >
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="assignmentdetails" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content modal-media-content">
            <div class="modal-header modal-media-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="box-title"><?php echo $this->lang->line('assignment_detail'); ?>  </h4>
            </div>
            <div class="modal-body pt0 pb0 pr0 pl-sm-0">
                <div class="scroll-area-inside">
                    <div id="assigndata"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function assignmentevaluation(id)
    {
        $("#assigment_id").val(id);
        $.ajax({
                type: 'POST',
                url: base_url + 'homework/getdailyassignmentdetails',
                data: {'id': id},
                dataType: 'JSON',
               
                success: function (data) {
                   $("#remark").val(data.remark);
                   $("#evaluation_date").val(data.evaluation_date);                  
                },
              
        });
    }

    function assignmentdetails(id)
    {
        $.ajax({
            type: 'POST',
            url: base_url + 'homework/assignmentdetails',
            data: {'assigment_id': id},
            dataType: 'JSON',
            success: function (response) {
               $('#assigndata').html(response.page);
            }  
        });
    }
</script>

<script>
    $(document).ready(function () {
        $("#evaluation_data").on('submit', (function (e) {
            e.preventDefault();
            var $this = $(this).find("button[type=submit]:focus");

            $.ajax({
                url: "<?php echo site_url("homework/submitassignmentremark") ?>",
                type: "POST",
                data: new FormData(this),
                dataType: 'JSON',
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
                         $('.dailyassignmentlist').DataTable().ajax.reload( null, false);
                        $('#assignmentevaluation').modal('hide');
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
    });
</script>

<script type="text/javascript">
    $(document).ready(function () {
        var date_format = '<?php echo $result = strtr($this->customlib->getSchoolDateFormat(), ['d' => 'dd', 'm' => 'mm', 'Y' => 'yyyy']) ?>';
        $('#homework_date,#submit_date,#homeworkdate,#submitdate').datepicker({
            format: date_format,
            autoclose: true,
            language: '<?php echo $language_name ?>'
        });
    });
</script>
 
<script type="text/javascript">
    var date_format = '<?php echo $result = strtr($this->customlib->getSchoolDateFormat(), ['d' => 'dd', 'm' => 'MM', 'Y' => 'yyyy']) ?>';

    // TVET: No subject group/subject initialization needed
</script>

<script type="text/javascript">

    var save_method; //for save method string
    var update_id; //for save method string

    // TVET: Subject group/subject JS removed — subject auto-derived from class

    $(document).on('submit','.search_daily_assignment_form',function(e){
    e.preventDefault(); // avoid to execute the actual submit of the form.
    var $this = $(this).find("button[type=submit]:focus");  
    var form = $(this);
    var url = form.attr('action');
    var form_data = form.serializeArray();
    $.ajax({
           url: url,
           type: "POST",
           dataType:'JSON',
           data: form_data, // serializes the form's elements.
              beforeSend: function () {
                $('[id^=error]').html("");
                $this.button('loading');            
               },
              success: function(response) { // your success handler
                
                if(!response.status){
                    $.each(response.error, function(key, value) {
                    $('#error_' + key).html(value);
                    });
                }else{
                 
                   initDatatable('dailyassignmentlist','homework/searchdailyassignment',response.params,[],100,

                    [{ "bSortable": false, "aTargets": [ -1,] ,'sClass': 'dt-body-right'},{ "bSortable": false, "aTargets": [ -2 ] }],                    

                    );
                }
              },
             error: function() { // your error handler
                 $this.button('reset');
             },
             complete: function() {
             $this.button('reset');
             }
         });
});
</script>