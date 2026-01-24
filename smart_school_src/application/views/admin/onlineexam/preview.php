<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-eye"></i> <?php echo $this->lang->line('preview'); ?> - <?php echo $exam->exam; ?></h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo site_url('admin/onlineexam'); ?>" class="btn btn-default btn-sm"><i class="fa fa-arrow-left"></i> <?php echo $this->lang->line('back'); ?></a>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="alert alert-info">
                            <i class="fa fa-info-circle"></i> <strong><?php echo $this->lang->line('preview'); ?></strong> - <?php echo $this->lang->line('this_is_preview_mode'); ?>
                        </div>

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

                        <?php if (empty($questions)) { ?>
                            <div class="alert alert-warning"><?php echo $this->lang->line('no_record_found'); ?></div>
                        <?php } else {
                            $counter = 1;
                            foreach ($questions as $question_key => $question_value) { ?>
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <strong><?php echo $this->lang->line('question'); ?> <?php echo $counter; ?></strong>
                                                <span class="label label-info"><?php echo ucfirst($question_value->question_type); ?></span>
                                            </div>
                                            <div class="col-md-6 text-right">
                                                <?php if ($exam->is_marks_display) { ?>
                                                    <span class="text-danger">(<?php echo $this->lang->line('marks'); ?>: <?php echo $question_value->marks; ?>
                                                    <?php if ($exam->is_neg_marking) { ?>, <?php echo $this->lang->line('negative_marks'); ?>: <?php echo $question_value->neg_marks; ?><?php } ?>)</span>
                                                <?php } ?>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="mb-2"><?php echo $question_value->question; ?></div>

                                        <?php
                                        $question_display = true;
                                        if ($question_value->question_type == "singlechoice" || $question_value->question_type == "") {
                                            foreach ($questionOpt as $question_opt_key => $question_opt_value) {
                                                if ($question_value->{$question_opt_key} == "") {
                                                    $question_display = false;
                                                }
                                                if ($question_display) { ?>
                                                    <div class="radio">
                                                        <label>
                                                            <input type="radio" disabled name="preview_<?php echo $counter; ?>"> <?php echo $question_value->{$question_opt_key}; ?>
                                                            <?php if ($question_value->correct == $question_opt_key) { ?>
                                                                <i class="fa fa-check text-success" title="<?php echo $this->lang->line('correct_answer'); ?>"></i>
                                                            <?php } ?>
                                                        </label>
                                                    </div>
                                                <?php }
                                            }
                                        } elseif ($question_value->question_type == "true_false") { ?>
                                            <div class="radio">
                                                <label><input type="radio" disabled> <?php echo $this->lang->line('true'); ?>
                                                    <?php if ($question_value->correct == 'true') { ?><i class="fa fa-check text-success"></i><?php } ?>
                                                </label>
                                            </div>
                                            <div class="radio">
                                                <label><input type="radio" disabled> <?php echo $this->lang->line('false'); ?>
                                                    <?php if ($question_value->correct == 'false') { ?><i class="fa fa-check text-success"></i><?php } ?>
                                                </label>
                                            </div>
                                        <?php } elseif ($question_value->question_type == "multichoice") {
                                            $correct_answers = json_decode($question_value->correct);
                                            foreach ($questionOpt as $question_opt_key => $question_opt_value) {
                                                if ($question_value->{$question_opt_key} == "") {
                                                    $question_display = false;
                                                }
                                                if ($question_display) { ?>
                                                    <div class="checkbox">
                                                        <label>
                                                            <input type="checkbox" disabled> <?php echo $question_value->{$question_opt_key}; ?>
                                                            <?php if (is_array($correct_answers) && in_array($question_opt_key, $correct_answers)) { ?>
                                                                <i class="fa fa-check text-success"></i>
                                                            <?php } ?>
                                                        </label>
                                                    </div>
                                                <?php }
                                            }
                                        } elseif ($question_value->question_type == "descriptive") { ?>
                                            <div class="form-group">
                                                <textarea class="form-control" rows="3" disabled placeholder="<?php echo $this->lang->line('student_answer_area'); ?>"></textarea>
                                            </div>
                                        <?php } ?>
                                    </div>
                                </div>
                        <?php
                                $counter++;
                            }
                        } ?>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
