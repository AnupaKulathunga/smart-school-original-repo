<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-comments-o"></i> <?php echo $this->lang->line('moderator_feedback'); ?> - <?php echo $exam->exam; ?></h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo site_url('admin/onlineexam'); ?>" class="btn btn-default btn-sm"><i class="fa fa-arrow-left"></i> <?php echo $this->lang->line('back'); ?></a>
                        </div>
                    </div>
                    <div class="box-body">
                        <!-- Exam Status Banner -->
                        <?php if ($exam->moderation_status == 'rejected') { ?>
                            <div class="alert alert-danger">
                                <i class="fa fa-times-circle"></i>
                                <strong><?php echo $this->lang->line('rejected'); ?>:</strong> <?php echo $this->lang->line('exam_must_be_approved'); ?>
                            </div>
                        <?php } elseif ($exam->moderation_status == 'pending_moderation') { ?>
                            <div class="alert alert-warning">
                                <i class="fa fa-clock-o"></i>
                                <strong><?php echo $this->lang->line('pending_moderation'); ?>:</strong> <?php echo $this->lang->line('moderation_required'); ?>
                            </div>
                        <?php } elseif ($exam->moderation_status == 'approved') { ?>
                            <div class="alert alert-success">
                                <i class="fa fa-check-circle"></i>
                                <strong><?php echo $this->lang->line('approved'); ?></strong>
                            </div>
                        <?php } ?>

                        <!-- Exam Details -->
                        <div class="row" style="margin-bottom: 15px;">
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

                        <hr>

                        <!-- Moderator Comments -->
                        <div class="box box-info">
                            <div class="box-header with-border">
                                <h4 class="box-title"><i class="fa fa-comments"></i> <?php echo $this->lang->line('moderation_history'); ?></h4>
                            </div>
                            <div class="box-body">
                                <?php if (empty($comments)) { ?>
                                    <p class="text-muted"><?php echo $this->lang->line('no_feedback_yet'); ?></p>
                                <?php } else { ?>
                                    <?php foreach ($comments as $c) { ?>
                                        <div class="callout callout-<?php echo ($c->action == 'approve') ? 'success' : (($c->action == 'reject') ? 'danger' : 'info'); ?>">
                                            <p>
                                                <strong><?php echo $c->moderator_name . ' ' . $c->moderator_surname; ?></strong>
                                                <span class="label label-<?php echo ($c->action == 'approve') ? 'success' : (($c->action == 'reject') ? 'danger' : 'info'); ?>">
                                                    <?php echo ucfirst($c->action); ?>
                                                </span>
                                                <?php if (!empty($c->question_id)) { ?>
                                                    <span class="label label-default"><?php echo $this->lang->line('question'); ?> #<?php echo $c->question_id; ?></span>
                                                <?php } ?>
                                                <small class="pull-right text-muted"><?php echo $c->created_at; ?></small>
                                            </p>
                                            <p><?php echo $c->comment; ?></p>
                                        </div>
                                    <?php } ?>
                                <?php } ?>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons in Box Footer -->
                    <?php if ($exam->moderation_status == 'rejected') { ?>
                    <div class="box-footer text-right">
                        <a href="javascript:void(0);" class="btn btn-default question-btn-edit" data-recordid="<?php echo $exam->id; ?>">
                            <i class="fa fa-pencil"></i> <?php echo $this->lang->line('edit_and_resubmit'); ?>
                        </a>
                        <button type="button" class="btn btn-primary resubmit-btn" data-exam-id="<?php echo $exam->id; ?>">
                            <i class="fa fa-paper-plane"></i> <?php echo $this->lang->line('resubmit_for_moderation'); ?>
                        </button>
                    </div>
                    <?php } ?>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- Confirmation Modal -->
<div class="modal fade" id="confirmResubmitModal" tabindex="-1" role="dialog" aria-labelledby="confirmResubmitLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="confirmResubmitLabel"><i class="fa fa-question-circle"></i> <?php echo $this->lang->line('confirm'); ?></h4>
            </div>
            <div class="modal-body">
                <p><?php echo $this->lang->line('are_you_sure'); ?></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal"><?php echo $this->lang->line('cancel'); ?></button>
                <button type="button" class="btn btn-primary" id="confirmResubmitBtn">
                    <i class="fa fa-paper-plane"></i> <?php echo $this->lang->line('resubmit_for_moderation'); ?>
                </button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
    var base_url = '<?php echo base_url(); ?>';
    var pendingExamId = null;

    // Show confirmation modal for resubmit
    $('.resubmit-btn').on('click', function() {
        pendingExamId = $(this).data('exam-id');
        $('#confirmResubmitModal').modal('show');
    });

    // Confirm resubmit from modal
    $('#confirmResubmitBtn').on('click', function() {
        var $btn = $(this);
        var originalHtml = $btn.html();

        $btn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> <?php echo $this->lang->line('please_wait'); ?>');

        $.ajax({
            url: base_url + 'admin/onlineexam/submit_for_moderation',
            type: 'POST',
            dataType: 'json',
            data: { exam_id: pendingExamId },
            success: function(data) {
                $('#confirmResubmitModal').modal('hide');
                if (data.status == 'success') {
                    successMsg(data.message);
                    setTimeout(function() {
                        window.location.href = base_url + 'admin/onlineexam';
                    }, 1500);
                } else {
                    errorMsg(data.message || '<?php echo $this->lang->line('error_occurred_please_try_again'); ?>');
                    $btn.prop('disabled', false).html(originalHtml);
                }
            },
            error: function() {
                $('#confirmResubmitModal').modal('hide');
                errorMsg('<?php echo $this->lang->line('error_occurred_please_try_again'); ?>');
                $btn.prop('disabled', false).html(originalHtml);
            }
        });
    });

    // Reset modal on close
    $('#confirmResubmitModal').on('hidden.bs.modal', function() {
        $('#confirmResubmitBtn').prop('disabled', false);
        pendingExamId = null;
    });

    // Edit exam button - redirect to main page and trigger edit modal
    $('.question-btn-edit').on('click', function() {
        var recordid = $(this).data('recordid');
        window.location.href = base_url + 'admin/onlineexam?edit=' + recordid;
    });
});
</script>
