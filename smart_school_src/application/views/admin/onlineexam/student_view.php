<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-eye"></i> <?php echo $this->lang->line('student_view'); ?> - <?php echo $exam->exam; ?></h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo site_url('admin/onlineexam'); ?>" class="btn btn-default btn-sm">
                                <i class="fa fa-arrow-left"></i> <?php echo $this->lang->line('back'); ?>
                            </a>
                        </div>
                    </div>
                    <div class="box-body p0">
                        <!-- Student Exam Interface Preview -->
                        <div class="student-exam-preview">
                            <!-- Exam Modal Header (simulated) -->
                            <div class="exam-header-preview">
                                <div class="exam-logo">
                                    <img src="<?php echo $this->customlib->getBaseUrl(); ?>uploads/school_content/admin_logo/<?php echo $admin_logo; ?>" alt="<?php echo $this->customlib->getAppName(); ?>" style="max-height: 50px;" />
                                </div>
                                <div class="exam-title-section">
                                    <h3><?php echo $exam->exam; ?></h3>
                                </div>
                                <div class="exam-timer-section">
                                    <div class="timer-display">
                                        <i class="fa fa-clock-o"></i>
                                        <span class="timer-value"><?php echo $exam->duration; ?></span>
                                    </div>
                                    <button type="button" class="btn btn-info btn-sm" disabled>
                                        <?php echo $this->lang->line('submit'); ?>
                                    </button>
                                </div>
                            </div>

                            <!-- Preview Mode Banner -->
                            <div class="alert alert-warning text-center mb0" style="border-radius: 0; margin: 0;">
                                <i class="fa fa-info-circle"></i>
                                <strong><?php echo $this->lang->line('preview_mode'); ?></strong> -
                                <?php echo $this->lang->line('this_is_exactly_how_students_will_see_this_exam'); ?>
                            </div>

                            <!-- Exam Content Area -->
                            <div class="exam-content-area">
                                <?php if (empty($questions)) { ?>
                                    <div class="alert alert-info m15">
                                        <?php echo $this->lang->line('no_question_found_please_contact_to_administrator'); ?>
                                    </div>
                                <?php } else { ?>
                                    <div class="row">
                                        <!-- Questions Section -->
                                        <div class="col-md-9 col-sm-9">
                                            <div class="question-list-preview">
                                                <?php
                                                $counter = 1;
                                                foreach ($questions as $question_value) {
                                                    $display_style = ($counter == 1) ? 'block' : 'none';
                                                ?>
                                                <fieldset id="preview_question_<?php echo $counter; ?>" class="question-fieldset" style="display: <?php echo $display_style; ?>;">
                                                    <div class="row">
                                                        <div class="col-md-4 col-sm-12">
                                                            <h3 class="mt0"><?php echo $this->lang->line('question'); ?>: <?php echo $counter; ?></h3>
                                                        </div>
                                                        <div class="col-md-8 col-sm-12">
                                                            <div class="text-right">
                                                                <?php if ($exam->is_marks_display && $exam->is_neg_marking) { ?>
                                                                    <span class="ques_marks text text-danger">
                                                                        (<?php echo $this->lang->line('marks'); ?>: <?php echo $question_value->marks; ?>,
                                                                        <?php echo $this->lang->line('negative_marks'); ?>: <?php echo $question_value->neg_marks; ?>)
                                                                    </span>
                                                                <?php } elseif ($exam->is_marks_display) { ?>
                                                                    <span class="ques_marks text text-danger">
                                                                        (<?php echo $this->lang->line('marks'); ?>: <?php echo $question_value->marks; ?>)
                                                                    </span>
                                                                <?php } elseif ($exam->is_neg_marking) { ?>
                                                                    <span class="ques_marks text text-danger">
                                                                        (<?php echo $this->lang->line('negative_marks'); ?>: <?php echo $question_value->neg_marks; ?>)
                                                                    </span>
                                                                <?php } ?>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="question-content-preview">
                                                        <div class="question-text">
                                                            <?php echo $question_value->question; ?>
                                                        </div>
                                                        <div class="answer-options">
                                                            <?php
                                                            if ($question_value->question_type == "singlechoice" || $question_value->question_type == "") {
                                                                $question_display = true;
                                                                foreach ($questionOpt as $question_opt_key => $question_opt_value) {
                                                                    if ($question_value->{$question_opt_key} == "") {
                                                                        $question_display = false;
                                                                    }
                                                                    if ($question_display) {
                                                            ?>
                                                                <label class="option-label">
                                                                    <input type="radio" name="preview_radio<?php echo $counter; ?>" disabled>
                                                                    <?php echo $question_value->{$question_opt_key}; ?>
                                                                </label>
                                                            <?php
                                                                    }
                                                                }
                                                            } elseif ($question_value->question_type == "true_false") {
                                                            ?>
                                                                <label class="option-label">
                                                                    <input type="radio" name="preview_radio<?php echo $counter; ?>" disabled>
                                                                    <?php echo $this->lang->line('true'); ?>
                                                                </label>
                                                                <label class="option-label">
                                                                    <input type="radio" name="preview_radio<?php echo $counter; ?>" disabled>
                                                                    <?php echo $this->lang->line('false'); ?>
                                                                </label>
                                                            <?php
                                                            } elseif ($question_value->question_type == "multichoice") {
                                                                $question_display = true;
                                                                foreach ($questionOpt as $question_opt_key => $question_opt_value) {
                                                                    if ($question_value->{$question_opt_key} == "") {
                                                                        $question_display = false;
                                                                    }
                                                                    if ($question_display) {
                                                            ?>
                                                                <div class="checkbox">
                                                                    <label class="option-label">
                                                                        <input type="checkbox" disabled>
                                                                        <?php echo $question_value->{$question_opt_key}; ?>
                                                                    </label>
                                                                </div>
                                                            <?php
                                                                    }
                                                                }
                                                            } elseif ($question_value->question_type == "descriptive") {
                                                            ?>
                                                                <div class="form-group">
                                                                    <label><?php echo $this->lang->line('attachment'); ?></label>
                                                                    <input type="file" class="form-control" disabled>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label><?php echo $this->lang->line('answer'); ?>:</label>
                                                                    <textarea class="form-control" rows="5" disabled placeholder="<?php echo $this->lang->line('student_will_type_answer_here'); ?>"></textarea>
                                                                </div>
                                                            <?php } ?>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                                <?php
                                                    $counter++;
                                                }
                                                ?>
                                            </div>
                                        </div>

                                        <!-- Question Map Sidebar -->
                                        <div class="col-md-3 col-sm-3">
                                            <div class="question-map-preview">
                                                <h4 class="mt0"><?php echo $this->lang->line('question_map'); ?></h4>
                                                <?php
                                                $question_counter = 1;
                                                foreach ($questions as $question_value) {
                                                ?>
                                                    <button type="button"
                                                            class="btn btn-default question-nav-btn <?php echo ($question_counter == 1) ? 'active' : ''; ?>"
                                                            data-question="<?php echo $question_counter; ?>">
                                                        <?php echo $question_counter; ?>
                                                    </button>
                                                <?php
                                                    $question_counter++;
                                                }
                                                ?>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Navigation Footer -->
                                    <div class="exam-footer-preview">
                                        <button type="button" class="btn btn-default prev-question-btn" style="display: none;">
                                            <i class="fa fa-arrow-left"></i> <?php echo $this->lang->line('previous'); ?>
                                        </button>
                                        <button type="button" class="btn btn-default next-question-btn">
                                            <?php echo $this->lang->line('next'); ?> <i class="fa fa-arrow-right"></i>
                                        </button>
                                    </div>
                                <?php } ?>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<style>
.student-exam-preview {
    background: #f5f5f5;
    min-height: 500px;
}

.exam-header-preview {
    background: linear-gradient(135deg, #3c8dbc 0%, #367fa9 100%);
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: #fff;
}

.exam-header-preview h3 {
    margin: 0;
    color: #fff;
}

.exam-logo img {
    max-height: 50px;
    background: #fff;
    padding: 5px;
    border-radius: 4px;
}

.timer-display {
    background: rgba(255,255,255,0.2);
    padding: 8px 15px;
    border-radius: 4px;
    display: inline-block;
    margin-right: 10px;
    font-size: 18px;
    font-weight: bold;
}

.timer-display .fa {
    margin-right: 8px;
}

.exam-content-area {
    padding: 20px;
}

.question-fieldset {
    background: #fff;
    padding: 20px;
    border-radius: 4px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    margin-bottom: 15px;
}

.question-content-preview {
    margin-top: 15px;
    padding: 15px;
    background: #fafafa;
    border-radius: 4px;
}

.question-text {
    font-size: 16px;
    margin-bottom: 20px;
    line-height: 1.6;
}

.answer-options {
    margin-top: 15px;
}

.option-label {
    display: block;
    padding: 10px 15px;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 4px;
    margin-bottom: 10px;
    cursor: not-allowed;
}

.option-label:hover {
    background: #f9f9f9;
}

.option-label input {
    margin-right: 10px;
}

.question-map-preview {
    background: #fff;
    padding: 15px;
    border-radius: 4px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    max-height: 400px;
    overflow-y: auto;
}

.question-map-preview h4 {
    border-bottom: 1px solid #eee;
    padding-bottom: 10px;
    margin-bottom: 15px;
}

.question-nav-btn {
    width: 40px;
    height: 40px;
    margin: 3px;
    padding: 0;
    font-weight: bold;
}

.question-nav-btn.active {
    background: #3c8dbc;
    color: #fff;
    border-color: #3c8dbc;
}

.exam-footer-preview {
    background: #fff;
    padding: 15px 20px;
    border-top: 1px solid #ddd;
    text-align: center;
}

.exam-footer-preview .btn {
    min-width: 120px;
    margin: 0 5px;
}

.m15 {
    margin: 15px;
}

.mb0 {
    margin-bottom: 0;
}

.p0 {
    padding: 0;
}
</style>

<script>
$(document).ready(function() {
    var currentQuestion = 1;
    var totalQuestions = <?php echo count($questions); ?>;

    function showQuestion(num) {
        $('.question-fieldset').hide();
        $('#preview_question_' + num).show();

        // Update navigation buttons
        $('.question-nav-btn').removeClass('active');
        $('.question-nav-btn[data-question="' + num + '"]').addClass('active');

        // Update prev/next buttons
        if (num <= 1) {
            $('.prev-question-btn').hide();
        } else {
            $('.prev-question-btn').show();
        }

        if (num >= totalQuestions) {
            $('.next-question-btn').hide();
        } else {
            $('.next-question-btn').show();
        }

        currentQuestion = num;
    }

    // Question map navigation
    $(document).on('click', '.question-nav-btn', function() {
        var questionNum = $(this).data('question');
        showQuestion(questionNum);
    });

    // Previous button
    $(document).on('click', '.prev-question-btn', function() {
        if (currentQuestion > 1) {
            showQuestion(currentQuestion - 1);
        }
    });

    // Next button
    $(document).on('click', '.next-question-btn', function() {
        if (currentQuestion < totalQuestions) {
            showQuestion(currentQuestion + 1);
        }
    });

    // Initialize
    showQuestion(1);
});
</script>
