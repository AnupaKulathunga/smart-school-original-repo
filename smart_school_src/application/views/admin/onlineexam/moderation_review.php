<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-gavel"></i> <?php echo $this->lang->line('exam_moderation'); ?> - <?php echo $exam->exam; ?></h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo site_url('admin/onlineexam/moderation'); ?>" class="btn btn-default btn-sm"><i class="fa fa-arrow-left"></i> <?php echo $this->lang->line('back'); ?></a>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="row mb-3">
                            <div class="col-md-3">
                                <strong><?php echo $this->lang->line('exam'); ?>:</strong> <?php echo $exam->exam; ?>
                            </div>
                            <div class="col-md-3">
                                <strong><?php echo $this->lang->line('duration'); ?>:</strong> <?php echo $exam->duration; ?>
                            </div>
                            <div class="col-md-3">
                                <strong><?php echo $this->lang->line('attempt'); ?>:</strong> <?php echo $exam->attempt; ?>
                            </div>
                            <div class="col-md-3">
                                <strong><?php echo $this->lang->line('questions'); ?>:</strong> <?php echo count($questions); ?>
                            </div>
                        </div>

                        <?php if (!empty($exam->description)) { ?>
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <strong><?php echo $this->lang->line('description'); ?>:</strong>
                                <p><?php echo $exam->description; ?></p>
                            </div>
                        </div>
                        <?php } ?>

                        <hr>

                        <!-- Previous Comments -->
                        <?php if (!empty($comments)) { ?>
                        <div class="box box-info">
                            <div class="box-header">
                                <h4 class="box-title"><?php echo $this->lang->line('comments'); ?></h4>
                            </div>
                            <div class="box-body">
                                <?php foreach ($comments as $c) { ?>
                                <div class="callout callout-<?php echo ($c['action'] == 'approve') ? 'success' : (($c['action'] == 'reject') ? 'danger' : 'info'); ?>">
                                    <p><strong><?php echo $c['moderator_name'] . ' ' . $c['moderator_surname']; ?></strong>
                                    <span class="label label-<?php echo ($c['action'] == 'approve') ? 'success' : (($c['action'] == 'reject') ? 'danger' : 'info'); ?>"><?php echo ucfirst($c['action']); ?></span>
                                    <small class="pull-right"><?php echo $c['created_at']; ?></small></p>
                                    <p><?php echo $c['comment']; ?></p>
                                </div>
                                <?php } ?>
                            </div>
                        </div>
                        <?php } ?>

                        <!-- Questions -->
                        <?php if (empty($questions)) { ?>
                            <div class="alert alert-warning"><?php echo $this->lang->line('no_record_found'); ?></div>
                        <?php } else {
                            $counter = 1;
                            foreach ($questions as $question_value) { ?>
                                <div class="panel panel-default" id="question_panel_<?php echo $counter; ?>">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <strong><?php echo $this->lang->line('question'); ?> <?php echo $counter; ?></strong>
                                                <span class="label label-info"><?php echo ucfirst($question_value->question_type); ?></span>
                                                <?php if ($exam->is_marks_display) { ?>
                                                    <span class="text-danger">(<?php echo $this->lang->line('marks'); ?>: <?php echo $question_value->marks; ?>)</span>
                                                <?php } ?>
                                            </div>
                                            <div class="col-md-6 text-right">
                                                <button class="btn btn-xs btn-info add-comment-btn" data-question-id="<?php echo $question_value->id; ?>" data-toggle="tooltip" title="<?php echo $this->lang->line('add'); ?> <?php echo $this->lang->line('comment'); ?>">
                                                    <i class="fa fa-comment"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="mb-2"><?php echo $question_value->question; ?></div>
                                        <?php
                                        $question_display = true;
                                        if ($question_value->question_type == "singlechoice" || $question_value->question_type == "") {
                                            foreach ($questionOpt as $question_opt_key => $question_opt_value) {
                                                if ($question_value->{$question_opt_key} == "") { $question_display = false; }
                                                if ($question_display) { ?>
                                                    <div class="radio">
                                                        <label><input type="radio" disabled> <?php echo $question_value->{$question_opt_key}; ?>
                                                            <?php if ($question_value->correct == $question_opt_key) { ?><i class="fa fa-check text-success"></i><?php } ?>
                                                        </label>
                                                    </div>
                                                <?php }
                                            }
                                        } elseif ($question_value->question_type == "true_false") { ?>
                                            <div class="radio"><label><input type="radio" disabled> <?php echo $this->lang->line('true'); ?> <?php if ($question_value->correct == 'true') { ?><i class="fa fa-check text-success"></i><?php } ?></label></div>
                                            <div class="radio"><label><input type="radio" disabled> <?php echo $this->lang->line('false'); ?> <?php if ($question_value->correct == 'false') { ?><i class="fa fa-check text-success"></i><?php } ?></label></div>
                                        <?php } elseif ($question_value->question_type == "multichoice") {
                                            $correct_answers = json_decode($question_value->correct);
                                            foreach ($questionOpt as $question_opt_key => $question_opt_value) {
                                                if ($question_value->{$question_opt_key} == "") { $question_display = false; }
                                                if ($question_display) { ?>
                                                    <div class="checkbox"><label><input type="checkbox" disabled> <?php echo $question_value->{$question_opt_key}; ?>
                                                        <?php if (is_array($correct_answers) && in_array($question_opt_key, $correct_answers)) { ?><i class="fa fa-check text-success"></i><?php } ?>
                                                    </label></div>
                                                <?php }
                                            }
                                        } elseif ($question_value->question_type == "descriptive") { ?>
                                            <textarea class="form-control" rows="2" disabled placeholder="<?php echo $this->lang->line('descriptive'); ?>"></textarea>
                                        <?php } ?>

                                        <!-- Per-question comment form (hidden by default) -->
                                        <div class="question-comment-form mt-2" id="comment_form_<?php echo $question_value->id; ?>" style="display:none;">
                                            <div class="input-group">
                                                <input type="text" class="form-control question-comment-input" placeholder="<?php echo $this->lang->line('add'); ?> <?php echo $this->lang->line('comment'); ?>..." data-question-id="<?php echo $question_value->id; ?>">
                                                <span class="input-group-btn">
                                                    <button class="btn btn-info submit-question-comment" data-question-id="<?php echo $question_value->id; ?>"><?php echo $this->lang->line('save'); ?></button>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        <?php
                                $counter++;
                            }
                        } ?>

                        <!-- Overall Moderation Action -->
                        <hr>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label><?php echo $this->lang->line('comment'); ?></label>
                                    <textarea id="moderation_comment" class="form-control" rows="3" placeholder="<?php echo $this->lang->line('add'); ?> <?php echo $this->lang->line('comment'); ?>..."></textarea>
                                </div>
                                <div class="text-right">
                                    <button class="btn btn-danger btn-sm moderation-action-btn" data-action="reject"><i class="fa fa-times"></i> <?php echo $this->lang->line('reject'); ?></button>
                                    <button class="btn btn-success btn-sm moderation-action-btn" data-action="approve"><i class="fa fa-check"></i> <?php echo $this->lang->line('approve'); ?></button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<script type="text/javascript">
$(document).ready(function() {
    var exam_id = '<?php echo $exam->id; ?>';
    var base_url = '<?php echo base_url(); ?>';

    // Toggle per-question comment form
    $('.add-comment-btn').on('click', function() {
        var qid = $(this).data('question-id');
        $('#comment_form_' + qid).toggle();
    });

    // Submit per-question comment
    $('.submit-question-comment').on('click', function() {
        var qid = $(this).data('question-id');
        var comment = $('#comment_form_' + qid + ' .question-comment-input').val();
        if (comment.trim() === '') return;

        $.ajax({
            url: base_url + 'admin/onlineexam/moderation_comment',
            type: 'POST',
            dataType: 'json',
            data: { exam_id: exam_id, question_id: qid, comment: comment },
            success: function(data) {
                if (data.status == 'success') {
                    successMsg(data.message);
                    $('#comment_form_' + qid + ' .question-comment-input').val('');
                    $('#comment_form_' + qid).hide();
                }
            }
        });
    });

    // Overall approve/reject action
    $('.moderation-action-btn').on('click', function() {
        var action = $(this).data('action');
        var comment = $('#moderation_comment').val();
        var confirmMsg = '<?php echo $this->lang->line('are_you_sure'); ?>';

        if (confirm(confirmMsg)) {
            $.ajax({
                url: base_url + 'admin/onlineexam/moderation_action',
                type: 'POST',
                dataType: 'json',
                data: { exam_id: exam_id, action: action, comment: comment },
                success: function(data) {
                    if (data.status == 'success') {
                        successMsg(data.message);
                        setTimeout(function() {
                            window.location.href = base_url + 'admin/onlineexam/moderation';
                        }, 1500);
                    }
                }
            });
        }
    });
});
</script>
