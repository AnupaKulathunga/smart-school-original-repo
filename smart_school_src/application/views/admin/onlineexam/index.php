<script src="<?php echo base_url(); ?>backend/plugins/ckeditor/ckeditor.js"></script>
<script src="<?php echo base_url(); ?>backend/js/ckeditor_config.js"></script>
<script src="<?php echo base_url(); ?>backend/plugins/ckeditor/adapters/jquery.js"></script>
<?php
$language      = $this->customlib->getLanguage();
$language_name = $language["short_code"];
?>
<style>
     @media print {
               .noprint {
                  visibility: hidden;
               }
            }
</style>

<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="nav-tabs-custom theme-shadow">
                    <div class="box-header ptbnull">
                            <h3 class="box-title titlefix pt5">  <?php echo $this->lang->line('online_exam_list'); ?></h3>
                            <?php if ($this->rbac->hasPrivilege('online_examination', 'can_add')) {
    ?>
                            <button class="btn btn-primary btn-sm pull-right question-btn" data-recordid="0"><i class="fa fa-plus"></i> <?php echo $this->lang->line('add_exam'); ?></button>
                        <?php
}
?>
                    </div>
                    <ul class="nav nav-tabs">
                        <li class="active"><a href="#tab_1" data-toggle="tab"><?php echo $this->lang->line('upcoming_exams'); ?></a></li>
                        <li><a href="#tab_3" class="closed-exam" data-toggle="tab"><?php echo $this->lang->line('closed_exams'); ?></a></li>
                    </ul>
                    <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">
                    <div class="box-body p0">
                        <div class="mailbox-messages">
                            <div class="table-responsive">
                                 <table class="table table-striped table-bordered table-hover exam-list" data-export-title="<?php echo $this->lang->line('online_exam_list'); ?>">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('exam'); ?></th>
                                        <th><?php echo $this->lang->line('quiz'); ?></th>
                                        <th width="150"><?php echo $this->lang->line('questions'); ?></th>
                                        <th><?php echo $this->lang->line('attempt'); ?></th>
                                        <th><?php echo $this->lang->line('exam_from'); ?></th>
                                        <th><?php echo $this->lang->line('exam_to') ?></th>
                                        <th><?php echo $this->lang->line('duration') ?></th>
                                        <th><?php echo $this->lang->line('exam_published'); ?></th>
                                        <th><?php echo $this->lang->line('result_published'); ?></th>
                                        <th><?php echo $this->lang->line('description'); ?></th>
                                        <th class="white-space-nowrap pull-right noExport"><?php echo $this->lang->line('action'); ?></th>
                                    </tr>
                                </thead>
                               <tbody>
                               </tbody>
                            </table>
                         </div>
                        </div>
                    </div>
                        </div>

                          <div class="tab-pane" id="tab_3">
                            <form action="<?php echo site_url('admin/onlineexam/ajax_delete') ?>" method="POST" id="deletebulk">
                             <div class="box-body p0">
                        <div class="mailbox-messages">
                               <div class="checkbox" >
                                     <label><input type="checkbox" name="checkAll"> <b><?php echo $this->lang->line('select_all'); ?></b> </label>

                                    <?php if ($this->rbac->hasPrivilege('online_examination', 'can_delete')) {?>
                                    <button type="submit" class="btn btn-primary btn-sm pull-right mb10" id="load" data-loading-text="<i class='fa fa-spinner fa-spin '></i>  <?php echo $this->lang->line('please_wait'); ?>"> <?php echo $this->lang->line('delete') ?></button>
                                    <?php }?>
                                </div>
                            <div class="table-responsive full-width">
                                 <table class="table table-striped table-bordered table-hover closed-exam-list" data-export-title="<?php echo $this->lang->line('online_exam_list'); ?>">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th><?php echo $this->lang->line('exam'); ?></th>
                                        <th><?php echo $this->lang->line('quiz'); ?></th>
                                        <th width="150"><?php echo $this->lang->line('questions'); ?></th>
                                        <th><?php echo $this->lang->line('attempt'); ?></th>
                                        <th><?php echo $this->lang->line('exam_from'); ?></th>
                                        <th><?php echo $this->lang->line('exam_to') ?></th>
                                        <th><?php echo $this->lang->line('duration') ?></th>
                                        <th><?php echo $this->lang->line('exam_published'); ?></th>
                                        <th><?php echo $this->lang->line('result_published'); ?></th>
                                        <th><?php echo $this->lang->line('description'); ?></th>
                                        <th class="pull-right noExport white-space-nowrap"><?php echo $this->lang->line('action'); ?></th>
                                    </tr>
                                </thead>
                               <tbody>
                               </tbody>
                            </table>
                         </div>
                        </div>
                    </div>
                </form>
                         </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </section>
</div>

<?php

function findOption($questionOpt, $find)
{
    foreach ($questionOpt as $quet_opt_key => $quet_opt_value) {
        if ($quet_opt_key == $find) {
            return $quet_opt_value;
        }
    }
    return false;
}
?>
<!-- Modal -->
<div id="myModal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-lg">
        <!-- Modal content-->
        <div class="modal-content" >
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title"><?php echo $this->lang->line('exam') ?></h4>
            </div>
            <form action="<?php echo site_url('admin/onlineexam/add'); ?>" method="POST" id="formsubject">
                <div class="modal-body">
                    <input type="hidden" name="recordid" value="0">
                <div class="row">
                    <div class="col-sm-12">
                    <div class="form-group">
                  <label class="checkbox-inline"><input type="checkbox" class="is_quiz" value="1" name="is_quiz"><?php echo $this->lang->line('quiz'); ?></label>
                  <span class="help-block"><?php echo $this->lang->line('check_on_quiz_message'); ?></span>
                 </div>
                     </div>
                    </div>
                    <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group">
                            <label for="exam"><?php echo $this->lang->line('exam_title'); ?></label><small class="req"> *</small>
                            <input type="text" class="form-control" id="exam" name="exam">
                            <span class="text text-danger exam_error"></span>
                        </div>
                     </div>
                    </div>
                    <div class="row">
                <div class="col-sm-4">
                    <div class="form-group">
                        <label for="exam_from"><?php echo $this->lang->line('exam_from'); ?></label><small class="req"> *</small>
                            <div class="input-group">
                            <input class="form-control datetime_twelve_hour" name="exam_from" type="text" id="exam_from" >
                            <span class="input-group-addon" id="basic-addon2">
                                <i class="fa fa-calendar">
                                </i>
                            </span>
                        </div>
                        <span class="text text-danger exam_from_error"></span>
                    </div>
                </div>
                <div class="col-sm-4">
                    <div class="form-group">
                        <label for="exam_to"><?php echo $this->lang->line('exam_to'); ?></label><small class="req"> *</small>
                     <div class="input-group">
                            <input class="form-control datetime_twelve_hour" name="exam_to" type="text" id="exam_to" >
                            <span class="input-group-addon" id="basic-addon2">
                                <i class="fa fa-calendar">
                                </i>
                            </span>
                        </div>
                    </div>
                </div>
                    <div class="col-sm-4">
                    <div class="form-group">
                        <label for="exam_to"> <?php echo $this->lang->line('auto_result_publish_date') ?></label>
                          <div class="input-group">
                            <input class="form-control datetime_twelve_hour" name="auto_publish_date" type="text" id="auto_publish_date" name="auto_publish_date">
                            <span class="input-group-addon" id="basic-addon2">
                                <i class="fa fa-calendar">
                                </i>
                            </span>
                        </div>
                    </div>
                </div>
                    </div>
                    <div class="row">
                <div class="col-sm-3">
                    <div class="form-group">
                        <label for="duration"><?php echo $this->lang->line('time_duration'); ?></label><small class="req"> *</small>
                        <input type="text" class="form-control timepicker" id="duration" name="duration">
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-group">
                        <label for="attempt"><?php echo $this->lang->line('attempt'); ?></label><small class="req"> *</small>
                        <input type="number" min="1" class="form-control" id="attempt" name="attempt" value="1">
                        <span class="text text-danger attempt_error"></span>
                    </div>
                </div>
                <div class="col-sm-3">
                      <div class="form-group">
                        <label for="attempt"><?php echo $this->lang->line('passing_percentage'); ?></label><small class="req"> *</small>
                        <input type="number" min="1" max="100" class="form-control" id="passing_percentage" name="passing_percentage">
                        <span class="text text-danger passing_percentage_error"></span>
                    </div>
                </div>
                    <div class="col-sm-3">
                      <div class="form-group">
                        <label for="attempt"><?php echo $this->lang->line('answer_word_limit'); ?></label><small class="req"> *</small>
                        <input type="number" min="-1" class="form-control" id="word_limit" value="-1" name="word_limit">
                        <span class="text text-danger"><?php echo $this->lang->line('set_minus_one_for_no_limit'); ?></span>
                    </div>
                </div>
                    </div>
                <div class="row">
                   <div class="form-group col-sm-12">
                                     <label class="checkbox-inline">
<input type="checkbox" class="is_active" name="is_active" value="1">
                                            <?php echo $this->lang->line('publish_exam'); ?>
                                        </label>

                                     <label class="checkbox-inline">
<input type="checkbox" class="publish_result" name="publish_result" value="1">
                                           <?php echo $this->lang->line('publish_result'); ?>
                                        </label>

                                     <label class="checkbox-inline">
<input type="checkbox" class="is_neg_marking" name="is_neg_marking" value="1">
                                           <?php echo $this->lang->line('negative_marking') ?>
                                        </label>

                                      <label class="checkbox-inline">
<input type="checkbox" class="is_marks_display" name="is_marks_display" value="1">
                                          <?php echo $this->lang->line('display_marks_in_exam'); ?>
                                        </label>

                                      <label class="checkbox-inline">
<input type="checkbox" class="is_random_question" name="is_random_question" value="1">
                                         <?php echo $this->lang->line('random_question_order'); ?>
                                        </label>

                </div>

                </div>

                <!-- Disability Accommodation Section -->
                <div class="row">
                    <div class="col-sm-6">
                        <div class="form-group">
                            <label class="checkbox-inline">
                                <input type="checkbox" class="accommodate_disabled" name="accommodate_disabled" value="1">
                                <strong><?php echo $this->lang->line('accommodate_disabled'); ?></strong>
                            </label>
                        </div>
                    </div>
                    <div class="col-sm-6 accommodate-settings" style="display: none;">
                        <div class="form-group">
                            <label><?php echo $this->lang->line('extra_time_for_disabled'); ?> (%)</label>
                            <input type="number" name="disabled_extra_time_percent" class="form-control input-sm" value="25" min="0" max="200" style="width: 100px; display: inline-block;">
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group" >
                            <label for="description"><?php echo $this->lang->line('description'); ?><small class="req"> *</small></label>
                            <textarea class="form-control" id="description" name="description"></textarea>
                            <span class="text text-danger description_error"></span>
                        </div>
                    </div>
                </div>
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary" id="load" data-loading-text="<i class='fa fa-spinner fa-spin '></i> <?php echo $this->lang->line('saving') ?>"><?php echo $this->lang->line('save') ?></button>
                </div>
            </form>
           </div>
    </div>
</div>

<div id="myQuestionModal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-xl">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <a  data-backdrop="static" data-keyboard="false" class="close" data-dismiss="modal">&times;</a>
                <h4 class="modal-title"><?php echo $this->lang->line('select_questions'); ?></h4>
            </div>
            <div class="modal-body">
                <input type="hidden" name="modal_exam_id" value="0" id="modal_exam_id">
                <input type="hidden" name="modal_is_quiz" value="0" id="modal_is_quiz">
                <form action="" method="POST" accept-charset="utf-8" id="form_search">
                <div class="row">
                       <div class="col-md-6 col-sm-6">
                        <div class="form-group">
                            <label><?php echo $this->lang->line('seach_by_keyword'); ?></label>
                            <input type="text" class="form-control" name="keyword" id="keyword" >
                        </div>
                     </div>
                     <div class="col-md-3 col-sm-6">
                        <div class="form-group">
                            <label><?php echo $this->lang->line('question_type'); ?></label>
                           <select class="form-control" name="question_type" id="question_type">
                      <option value=""><?php echo $this->lang->line('select'); ?></option>
                            <?php
foreach ($question_type as $question_type_key => $question_type_value) {
    ?>
    <option value="<?php echo $question_type_key; ?>"><?php echo $question_type_value; ?></option>
                                <?php
}
?>
                        </select>
                        </div>
                     </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="form-group">
                            <label><?php echo $this->lang->line('question_level'); ?></label>
                            <select class="form-control" name="question_level" id="question_level">
                       <option value=""><?php echo $this->lang->line('select'); ?></option>
                            <?php
foreach ($question_level as $question_level_key => $question_level_value) {
    ?>
    <option value="<?php echo $question_level_key; ?>"><?php echo $question_level_value; ?></option>
                                <?php
}
?>
                        </select>
                        </div>
                     </div>
                     <div class="col-md-3 col-sm-6">
                        <div class="form-group">
                            <label><?php echo $this->lang->line('subject') ?></label>
                            <select class="form-control" name="search_box" id="search_box" style="display: inline-block;">
                                <option value=""><?php echo $this->lang->line('select') ?></option>
                                        <?php
foreach ($subjectlist as $subject_key => $subject_value) {
    ?>
                                    <option value="<?php echo $subject_value['id']; ?>"><?php echo $subject_value['name']; ?> <?php if($subject_value['code']){ echo '('.$subject_value['code'].')'; } ?></option>
                                    <?php
}
?>

                            </select>
                        </div>
                     </div>
                      <div class="col-md-4 col-sm-6">
                        <div class="form-group">
                            <label><?php echo $this->lang->line('class') ?></label>
                            <select class="form-control" name="class_id" id="class_id">
                            <option value=""><?php echo $this->lang->line('select'); ?></option>
                            <?php
foreach ($classList as $class_key => $class_value) {
    ?>
    <option value="<?php echo $class_value['id']; ?>"><?php echo $class_value['class']; ?></option>
                                <?php
}
?>
                        </select>
                        </div>
                     </div>
                    <div class="col-md-2 col-sm-6">
                        <label style="display: block; visibility:hidden;"><?php echo $this->lang->line('search'); ?></label>
                        <button type="button" class="btn btn-info btn-sm post_search_submit"><?php echo $this->lang->line('search'); ?></button>
                    </div>
                 
                </div><!-- ./row -->
                <div class="search_box_result quescroll">
                </div>
                <div class="row">
                <div class="col-sm-12 col-md-5">
                <div class="pt20 font-weight-bold"><?php echo $this->lang->line('showing'); ?> <span class="row_from"></span> <?php echo $this->lang->line('to'); ?> <span class="row_to"></span> <?php echo $this->lang->line('of'); ?> <span class="row_count"></span> <?php echo $this->lang->line('search'); ?></div>
                </div>
                <div class="col-sm-12 col-md-7 search_box_pagination">

                </div>
                </div>
                </form>
            </div>
        </div>
    </div>
</div>

<div id="myQuestionListModal" class="modal fade">
    <div class="modal-dialog modal-xl">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title"></h4>
            </div>
            <div class="modal-body">
               <div class="question_list_result quescroll">
               </div>
           </div><!-- ./row -->
        </div>
        </div>
    </div>

<div class="modal fade" id="mydeleteModal">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
        <form action="<?php echo site_url('admin/onlineexam/deleteExamQuestions') ?>" id="delete_question" method="POST">
           <input type="hidden" value="0" id="question_id" name="question_id"/>
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel"><?php echo $this->lang->line('delete_question'); ?></h4>
      </div>
      <div class="modal-body">
        <?php echo $this->lang->line('delete_confirm'); ?>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal"><?php echo $this->lang->line('close') ?></button>
         <button type="submit" class="btn btn-primary pull-right" data-loading-text="<i class='fa fa-spinner fa-spin '></i><?php echo $this->lang->line('please_wait'); ?>" value=""><?php echo $this->lang->line('delete'); ?></button>
     </div>
        </form>
    </div>
    </div>
  </div>

<!-- Modal -->
 <div id="myGenerateRankModal" class="modal fade" role="dialog">
  <div class="modal-dialog modal-lg">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body modalminheight">

      </div>
    </div>
  </div>
</div>

<!-- Submit for Moderation Confirmation Modal -->
<div class="modal fade" id="submitModerationModal" tabindex="-1" role="dialog" aria-labelledby="submitModerationLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="submitModerationLabel"><i class="fa fa-question-circle"></i> <?php echo $this->lang->line('confirm'); ?></h4>
            </div>
            <div class="modal-body">
                <p><?php echo $this->lang->line('are_you_sure'); ?></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><?php echo $this->lang->line('cancel'); ?></button>
                <button type="button" class="btn btn-primary" id="confirmSubmitModerationBtn">
                    <i class="fa fa-paper-plane"></i> <?php echo $this->lang->line('submit_for_moderation'); ?>
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {

        CKEDITOR.env.isCompatible = true;

          $('[id="description"]').ckeditor({
                     toolbar: 'Admin_Exam',
                     allowedContent : true,

                     enterMode : CKEDITOR.ENTER_BR,
                     shiftEnterMode: CKEDITOR.ENTER_P,
                     customConfig: baseurl+'/backend/js/ckeditor_config.js',
                });

        $('.detail_popover').popover({
            placement: 'right',
            trigger: 'hover',
            container: 'body',
            html: true,
            content: function () {
                return $(this).closest('td').find('.fee_detail_popover').html();
            }
        });
    });
</script>

<script type="text/javascript">
$(document).on('submit','#delete_question',function(e) {
    e.preventDefault();
    var form = $(this);
    var question_id=form.find("input[id='question_id']").val();
    var url = form.attr('action');
    var $this = form.find("button[type=submit]:focus");
    $this.button('loading');
    $.ajax({
    url: url,
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
      $('.question_row_'+question_id).remove();
      $this.button('reset');
      if (res.status == 1) {
      $('#mydeleteModal').modal('hide');
        successMsg(res.message);
      }
    },
    error: function (xhr) { // if error occured
    errorMsg("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");
    $this.button('reset');
    },
    complete: function () {
    $this.button('reset');
    }

    });
    });

        $('#mydeleteModal').on('shown.bs.modal', function (e) {
          var question_id = $(e.relatedTarget).data('onlineexamQuestionId');
          $("#mydeleteModal input[id='question_id']").val(question_id);

        })

    $(document).ready(function () {
        $('#myModal,#mydeleteModal,#myGenerateRankModal').modal({
            backdrop: 'static',
            keyboard: false,
            show: false
        })
        $('#myQuestionModal').modal({
            backdrop: 'static',
            keyboard: false,
            show: false
        })

        var date_format_js = '<?php echo $result = strtr($this->customlib->getSchoolDateFormat(), ['d' => 'dd', 'm' => 'MM', 'Y' => 'yyyy']) ?>';

        $(function () {
             var dateNow = new Date();
            $('.timepicker').datetimepicker({
                format: 'HH:mm:ss',

             defaultDate:moment(dateNow).hours(0).minutes(0).seconds(0).milliseconds(0)
            });
        });

        $('#myModal').on('hidden.bs.modal', function () {
            $('.is_quiz').attr('checked', false);

            $(this).find(":input, select, textarea")
                    .not('input:checkbox,input:radio')
                    .val('')
                    .end()
                    .removeAttr('checked')
                    .removeAttr('selected')
                    .end();

            // Reset publish checkbox state and remove moderation notice
            $('input[name=is_active]').prop('disabled', false);
            $('.publish-moderation-notice').remove();
        });

        $('#myGenerateRankModal').on('hidden.bs.modal', function () {
            $(".modal-body", this).html();
            $(".modal-title", this).html();
        });

        $(document).on('click', '.question-btn', function () {
            var recordid = $(this).data('recordid');
            $('input[name=recordid]').val(recordid);

            // New exams (recordid=0) - restore HTML default values and set moderation restrictions
            if (recordid == 0) {
                // Restore HTML default values (these were cleared by modal reset)
                $('#word_limit').val($('#word_limit').attr('value') || '-1');
                $('input[name=disabled_extra_time_percent]').val($('input[name=disabled_extra_time_percent]').attr('value') || '25');
                $('input[name=accommodate_disabled]').prop('checked', false);
                $('.accommodate-settings').hide();

                // New exams cannot be published - must go through moderation first
                $('input[name=is_active]').prop('disabled', true);
                $('input[name=is_active]').prop('checked', false);
                $('.publish-moderation-notice').remove();
                $('input[name=is_active]').closest('label').after('<span class="publish-moderation-notice text-danger" style="margin-left:5px;" data-toggle="tooltip" title="<?php echo $this->lang->line('exam_must_be_approved'); ?>"><i class="fa fa-lock"></i> <?php echo $this->lang->line('moderation_required'); ?></span>');
            }

            $('#myModal').modal('show');
        });

        $('#myQuestionModal').on('show.bs.modal', function (e) {

            //get data-id attribute of the clicked element
            var exam_id = $(e.relatedTarget).data('recordid');
            var is_quiz = $(e.relatedTarget).data('is_quiz');
            if(is_quiz == 1){
                  $("select#question_type option[value*='descriptive']").prop('disabled',true);
            }else{
                  $("select#question_type option[value*='descriptive']").prop('disabled',false);

            }
            $('#modal_exam_id').val(exam_id);
            $('#modal_is_quiz').val(is_quiz);

            //populate the textbox
            getQuestionByExam(1, exam_id,is_quiz);

        });

 $(document).on('click', '.generate_rank', function () {
     var $this = $(this);
     examid=$this.data('recordid');
     examtitle=$this.data('examTitle');
      $('#myGenerateRankModal').modal('show');

      var this_obj=$('#myGenerateRankModal');
      $('.modal-title',this_obj).html('<?php echo $this->lang->line('generate_exam_rank'); ?>  ('+examtitle+')');

   getRankRecord(examid,examtitle);
 });

        $('#myQuestionModal').on('hidden.bs.modal', function (e) {
                $(this).find("input,textarea,select").val('');
                $('.search_box_result').html("");
                $('.search_box_pagination').html("");
                  table.ajax.reload( null, false );
        });

 $(document).on('click', '.download_exam', function () {
            var $this=$(this);
            var recordid = $(this).data('recordid');
            $.ajax({
                type: 'POST',
                url: baseurl + "admin/onlineexam/download_exam",
                data: {'recordid': recordid},
                dataType: 'JSON',
                beforeSend: function () {
                    $this.button('loading');
                },
                success: function (data) {

            Popup(data.page);
                    $this.button('reset');
                },
                error: function (xhr) { // if error occured
                    errorMsg("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");
                    $this.button('reset');
                },
                complete: function () {
                    $this.button('reset');
                }
            });
        });

        $(document).on('click', '.question-btn-edit', function () {
            var $this = $(this);
            var recordid = $this.data('recordid');
            $('input[name=recordid]').val(recordid);
            $.ajax({
                type: 'POST',
                url: baseurl + "admin/onlineexam/getOnlineExamByID",
                data: {'recordid': recordid},
                dataType: 'JSON',
                beforeSend: function () {
                    $this.button('loading');
                },
                success: function (data) {

                    if (data.status) {
                        var date_exam_from = new Date(data.result.exam_from);
                        var newDate_exam_from = date_exam_from.toString(date_format_js);
                        var date_exam_to = new Date(data.result.exam_to);

                        if(data.result.auto_publish_date != null && data.result.auto_publish_date != "" && data.result.auto_publish_date != "0000-00-00"){
                          var date_auto_publish_date = new Date(data.result.auto_publish_date);

                         $('#auto_publish_date').data("DateTimePicker").date(date_auto_publish_date);
                        }else{
                            var newDate_auto_publish_date="";
                        }
                        $('#word_limit').val(data.result.answer_word_count);
                        $('#duration').val(data.result.duration);
                        $('#passing_percentage').val(data.result.passing_percentage);
                        $('#exam_to').data("DateTimePicker").date(date_exam_to);
                        $('#exam_from').data("DateTimePicker").date(date_exam_from);
                        $('#exam').val(data.result.exam);
                        $('#attempt').val(data.result.attempt);

                        // Set CKEditor content with fallback for timing issues
                        var descriptionContent = data.result.description || '';
                        try {
                            if (CKEDITOR.instances['description'] && CKEDITOR.instances['description'].status == 'ready') {
                                CKEDITOR.instances['description'].setData(descriptionContent);
                            } else {
                                // Fallback: set after a short delay
                                setTimeout(function() {
                                    if (CKEDITOR.instances['description']) {
                                        CKEDITOR.instances['description'].setData(descriptionContent);
                                    }
                                }, 300);
                            }
                        } catch(e) {
                            // Final fallback: set textarea value directly
                            $('textarea[name=description]').val(descriptionContent);
                        }

                        var is_quiz=(data.result.is_quiz == 0)?false:true;

                        $('input[name=is_quiz]').prop('checked',is_quiz);

                        if(is_quiz){
                            $("input.publish_result").attr("disabled", true);

                            document.getElementById('auto_publish_date').disabled = true;
                        }

                        var chk_status=(data.result.is_active == 0)?false:true;

                        $('input[name=is_active]').prop('checked',chk_status);

                        var chk_is_marks_display=(data.result.is_marks_display == 0)?false:true;

                        $('input[name=is_marks_display]').prop('checked',chk_is_marks_display);

                           var chk_is_neg_marking=(data.result.is_neg_marking == 0)?false:true;

                        $('input[name=is_neg_marking]').prop('checked',chk_is_neg_marking);

                          var chk_result_status=(data.result.publish_result == 0)?false:true;

                        $('input[name=publish_result]').prop('checked',chk_result_status);

                        var chk_is_random_question=(data.result.is_random_question == 0)?false:true;
                        $('input[name=is_random_question]').prop('checked',chk_is_random_question);

                        // Disability accommodation settings
                        var chk_accommodate_disabled = (data.result.accommodate_disabled == 'yes') ? true : false;
                        $('input[name=accommodate_disabled]').prop('checked', chk_accommodate_disabled);
                        if (chk_accommodate_disabled) {
                            $('.accommodate-settings').show();
                        }
                        $('input[name=disabled_extra_time_percent]').val(data.result.disabled_extra_time_percent || 25);

                        // Moderation status - disable publish checkbox if not approved
                        var moderation_status = data.result.moderation_status || 'draft';
                        if (moderation_status !== 'approved') {
                            $('input[name=is_active]').prop('disabled', true);
                            $('.publish-moderation-notice').remove();
                            $('input[name=is_active]').closest('label').after('<span class="publish-moderation-notice text-danger" style="margin-left:5px;" data-toggle="tooltip" title="<?php echo $this->lang->line('exam_must_be_approved'); ?>"><i class="fa fa-lock"></i> <?php echo $this->lang->line('moderation_required'); ?></span>');
                        } else {
                            $('input[name=is_active]').prop('disabled', false);
                            $('.publish-moderation-notice').remove();
                        }

                        $('#myModal').modal('show');
                    }
                    $this.button('reset');
                },
                error: function (xhr) { // if error occured
                    errorMsg("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");
                    $this.button('reset');
                },
                complete: function () {
                    $this.button('reset');
                }
            });
        });
    });

    $(document).on('submit',"form#saverank",function(e){

        e.preventDefault(); // avoid to execute the actual submit of the form.
        var form = $(this);
        var url = form.attr('action');
        var submit_button = form.find(':submit');
        var post_params = form.serialize();

        $.ajax({
            type: "POST",
            url: url,
            data: form.serialize(), // serializes the form's elements.
            dataType: "JSON", // serializes the form's elements.
            beforeSend: function () {

                submit_button.button('loading');
            },
            success: function (data)
            {
                successMsg(data.message);
                var rank_modal_obj=$('#myGenerateRankModal');
                var examtitle=$('.modal-title',rank_modal_obj).html();
                var examid=$('#generate_exam_id',rank_modal_obj).val();
                getRankRecord(examid,examtitle);
            },
            error: function (xhr) { // if error occured
                submit_button.button('reset');
                errorMsg("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");

            },
            complete: function () {
                submit_button.button('reset');
            }
        });
    });

    $("form#formsubject").submit(function (e) {
        e.preventDefault(); // avoid to execute the actual submit of the form.
        var form = $(this);
        var url = form.attr('action');
        var submit_button = form.find(':submit');
        var post_params = form.serialize();
        for (instance in CKEDITOR.instances) {
            CKEDITOR.instances[instance].updateElement();
        }

        $.ajax({
            type: "POST",
            url: url,
            data: form.serialize(), // serializes the form's elements.
            dataType: "JSON", // serializes the form's elements.
            beforeSend: function () {
                $("[class$='_error']").html("");
                submit_button.button('loading');
            },
            success: function (data)
            {
                if (!data.status) {
                   var message = "";
            $.each(data.error, function (index, value) {
            message += value;
            });
            errorMsg(message);
            } else {
            successMsg(data.message);
            $('#myModal').modal('hide');
            table.ajax.reload( null, false );

                }
            },
            error: function (xhr) { // if error occured
                submit_button.button('reset');
                errorMsg("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");

            },
            complete: function () {
                submit_button.button('reset');
            }
        });
    });

    function getQuestionByExam(page, exam_id,is_quiz) {
        var search = $("#search_box").val();
        var keyword = $('#form_search #keyword').val();
        var question_type = $('#form_search #question_type').val();
        var question_level = $('#form_search #question_level').val();
        var class_id = $('#form_search #class_id').val();
        $.ajax({
            type: "POST",
            url: base_url + 'admin/onlineexam/searchQuestionByExamID',
            data: {'page': page, 'exam_id': exam_id, 'search': search,'keyword':keyword,'question_type':question_type,'question_level': question_level,'class_id':class_id,'is_quiz':is_quiz}, // serializes the form's elements.
            dataType: "JSON", // serializes the form's elements.
            beforeSend: function () {
            },
            success: function (data)
            {
                $('.search_box_result').html(data.content);
                $('.search_box_pagination').html(data.navigation);
                $('.row_from').html(data.show_from);
                $('.row_to').html(data.show_to);
                $('.row_count').html(data.total_display);
                if(data.show_to==0){
                    $('.search_box_result').html('<div class="alert alert-danger"><?php echo $this->lang->line("no_record_found"); ?></div>');
                }
            },
            error: function (xhr) { // if error occured
               errorMsg("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");

            },
            complete: function () {

            }
        });
    }

    /* Pagination Clicks   */
    $(document).on('click', '.search_box_pagination li.activee', function (e) {
        var _exam_id = $('#modal_exam_id').val();
        var _is_quiz = $('#modal_is_quiz').val();
        var page = $(this).attr('p');
        getQuestionByExam(page, _exam_id,_is_quiz);
    });

    $(document).on('click', '.post_search_submit', function (e) {
        var _exam_id = $('#modal_exam_id').val();
          var __is_quiz = $('#modal_is_quiz').val();
        getQuestionByExam(1, _exam_id,__is_quiz);
    });

    $(document).on('change', '.question_chk', function () {
        var _exam_id = $('#modal_exam_id').val();
        var ques_mark =$(this).closest('div.section-box').find("input[name='question_marks']").val();
        var ques_neg_mark =$(this).closest('div.section-box').find("input[name='question_neg_marks']").val();
        updateCheckbox($(this).val(), _exam_id,ques_mark,ques_neg_mark);
    });

    function updateCheckbox(question_id, exam_id,ques_mark,ques_neg_mark) {
        $.ajax({
            type: 'POST',
            url: base_url + 'admin/onlineexam/questionAdd',
            dataType: 'JSON',
            data: {'question_id': question_id, 'onlineexam_id': exam_id,'ques_mark':ques_mark,'ques_neg_mark':ques_neg_mark},
            beforeSend: function () {

            },
            success: function (data) {
                if (data.status) {
                    successMsg(data.message);
                }
            },
            error: function (xhr) { // if error occured
                errorMsg("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");

            },
            complete: function () {

            },
        });
    }

    $('#myQuestionListModal').on('hidden.bs.modal', function () {
         table.ajax.reload( null, false );
        });

    // TVET: No section dropdown - class_id is self-contained

           $(document).on('click', '.exam_ques_list', function () {
            var $this=$(this);
            var recordid = $(this).data('recordid');
            $('input[name=recordid]').val(recordid);
            $.ajax({
                type: 'POST',
                url: baseurl + "admin/onlineexam/getExamQuestions",
                data: {'recordid': recordid},
                dataType: 'JSON',
                beforeSend: function () {
                    $this.button('loading');
                },
                success: function (data) {

                $('#myQuestionListModal').modal('show');
                $('#myQuestionListModal .modal-title').html(data.exam.exam);
                $('#myQuestionListModal .question_list_result').html(data.result);
                    $this.button('reset');
                },
                error: function (xhr) { // if error occured
                    errorMsg("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");
                    $this.button('reset');
                },
                complete: function () {
                    $this.button('reset');
                }
            });
        });

        $(document).on('click', '.subject_pills li', function () {
            var $this=$(this);
            $this.addClass('active').siblings().removeClass('active');
            var subject_pill_selected=($this.find('a').data('subjectId'));
            if(subject_pill_selected != 0){

            $("div[class*='subject_div_']").css("display","none");
            $('.subject_div_'+subject_pill_selected).css("display","block");
            }else{
               $("div[class*='subject_div_']").css("display","block");
            }
        });

    function getRankRecord(examid,examtitle){
      var this_obj=$('#myGenerateRankModal');
        $.ajax({
            type: "POST",
            url: base_url+"/admin/onlineexam/rankgenerate",
            data: {"examid":examid}, // serializes the form's elements.
            dataType: "JSON", // serializes the form's elements.
            beforeSend: function () {
              this_obj.addClass('modal_loading');
            },
            success: function (data)
            {
                $('.modal-body',this_obj).html(data.page);
                this_obj.removeClass('modal_loading');
            },
            error: function (xhr) { // if error occured
                this_obj.removeClass('modal_loading');
                errorMsg("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");

            },
            complete: function () {
                  this_obj.removeClass('modal_loading');
            }
        });
}

</script>

<script type="text/javascript">
    $(".is_quiz").change(function() {
        if(this.checked) {
            $("input.publish_result").attr("disabled", true);
            $("input#auto_publish_date").val("").attr("disabled", true);
        }else{
            $("input.publish_result").removeAttr("disabled");
            $("input#auto_publish_date").removeAttr("disabled");
        }
    });

    // Toggle accommodation settings visibility
    $(".accommodate_disabled").change(function() {
        if(this.checked) {
            $(".accommodate-settings").show();
        } else {
            $(".accommodate-settings").hide();
        }
    });
</script>

<script>
       $(document).ready(function () {
         initDatatable('exam-list','admin/onlineexam/getexamlist',[],[],100); // for upcoming exam datatable will be loaded by default

        $("a[href='#tab_3']").on('shown.bs.tab', function (e) {
            initDatatable('closed-exam-list','admin/onlineexam/getclosedexamlist',[],[],100); // for closed exam
        });

        // Submit for Moderation button handler - show modal
        var pendingModerationExamId = null;
        var $pendingModerationBtn = null;

        $(document).on('click', '.submit-moderation-btn', function(e) {
            e.preventDefault();
            pendingModerationExamId = $(this).data('exam-id');
            $pendingModerationBtn = $(this);
            $('#submitModerationModal').modal('show');
        });

        // Confirm submit for moderation from modal
        $(document).on('click', '#confirmSubmitModerationBtn', function() {
            var $modalBtn = $(this);
            $modalBtn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> <?php echo $this->lang->line('please_wait'); ?>');

            $.ajax({
                url: baseurl + 'admin/onlineexam/submit_for_moderation',
                type: 'POST',
                dataType: 'json',
                data: { exam_id: pendingModerationExamId },
                success: function(data) {
                    $('#submitModerationModal').modal('hide');
                    if (data.status == 'success') {
                        successMsg(data.message);
                        table.ajax.reload(null, false);
                    } else {
                        errorMsg(data.message || '<?php echo $this->lang->line('error_occurred_please_try_again'); ?>');
                    }
                    $modalBtn.prop('disabled', false).html('<i class="fa fa-paper-plane"></i> <?php echo $this->lang->line('submit_for_moderation'); ?>');
                },
                error: function() {
                    $('#submitModerationModal').modal('hide');
                    errorMsg('<?php echo $this->lang->line('error_occurred_please_try_again'); ?>');
                    $modalBtn.prop('disabled', false).html('<i class="fa fa-paper-plane"></i> <?php echo $this->lang->line('submit_for_moderation'); ?>');
                }
            });
        });

        // Reset modal on close
        $('#submitModerationModal').on('hidden.bs.modal', function() {
            $('#confirmSubmitModerationBtn').prop('disabled', false).html('<i class="fa fa-paper-plane"></i> <?php echo $this->lang->line('submit_for_moderation'); ?>');
            pendingModerationExamId = null;
            $pendingModerationBtn = null;
        });
    });
</script>

<!-- Bulk Delete Confirmation Modal -->
<div class="modal fade" id="bulkDeleteModal" tabindex="-1" role="dialog" aria-labelledby="bulkDeleteLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="bulkDeleteLabel"><i class="fa fa-exclamation-triangle text-danger"></i> <?php echo $this->lang->line('confirm'); ?></h4>
            </div>
            <div class="modal-body">
                <p><?php echo $this->lang->line('are_you_sure_you_want_to_delete'); ?></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><?php echo $this->lang->line('cancel'); ?></button>
                <button type="button" class="btn btn-danger" id="confirmBulkDeleteBtn">
                    <i class="fa fa-trash"></i> <?php echo $this->lang->line('delete'); ?>
                </button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    var bulkDeleteForm = null;

    $("#deletebulk").submit(function (e) {
        e.preventDefault();
        var checkCount = $("input[name='exam[]']:checked").length;

        if (checkCount == 0) {
            warningMsg("<?php echo $this->lang->line('atleast_one_student_should_be_select'); ?>");
        } else {
            bulkDeleteForm = $(this);
            $('#bulkDeleteModal').modal('show');
        }
    });

    // Confirm bulk delete from modal
    $('#confirmBulkDeleteBtn').on('click', function() {
        var $btn = $(this);
        var form = bulkDeleteForm;
        var url = form.attr('action');
        var submit_button = form.find(':submit');

        $btn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> <?php echo $this->lang->line('please_wait'); ?>');

        $.ajax({
            type: "POST",
            url: url,
            data: form.serialize(),
            dataType: "JSON",
            success: function (data) {
                $('#bulkDeleteModal').modal('hide');
                var message = "";
                if (!data.status) {
                    $.each(data.error, function (index, value) {
                        message += value;
                    });
                    errorMsg(message);
                } else {
                    successMsg(data.message);
                    location.reload();
                }
            },
            error: function (xhr) {
                $('#bulkDeleteModal').modal('hide');
                errorMsg("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");
            },
            complete: function () {
                submit_button.button('reset');
                $btn.prop('disabled', false).html('<i class="fa fa-trash"></i> <?php echo $this->lang->line('delete'); ?>');
            }
        });
    });

    // Reset modal on close
    $('#bulkDeleteModal').on('hidden.bs.modal', function() {
        $('#confirmBulkDeleteBtn').prop('disabled', false).html('<i class="fa fa-trash"></i> <?php echo $this->lang->line('delete'); ?>');
        bulkDeleteForm = null;
    });

   $("input[name='checkAll']").click(function () {
       $("input[name='exam[]']").not(this).prop('checked', this.checked);
   });

    function Popup(data)
    {
        var frame1 = $('<iframe />');
        frame1[0].name = "frame1";
        frame1.css({"position": "absolute", "top": "-1000000px"});
        $("body").append(frame1);
        var frameDoc = frame1[0].contentWindow ? frame1[0].contentWindow : frame1[0].contentDocument.document ? frame1[0].contentDocument.document : frame1[0].contentDocument;
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
        frameDoc.document.write('<body>');
        frameDoc.document.write(data);
        frameDoc.document.write('</body>');
        frameDoc.document.write('</html>');
        frameDoc.document.close();
        setTimeout(function () {
            window.frames["frame1"].focus();
            window.frames["frame1"].print();
            frame1.remove();
        }, 500);

        return true;
    }
</script>