<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-pencil"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="row">
            <!-- Assessment Info -->
            <div class="col-md-4">
                <div class="box box-info">
                    <div class="box-header with-border">
                        <h3 class="box-title">Assessment Details</h3>
                    </div>
                    <div class="box-body">
                        <dl class="dl-horizontal">
                            <dt>Title:</dt>
                            <dd><?php echo htmlspecialchars($assessment->title); ?></dd>
                            <dt>Class:</dt>
                            <dd><?php echo htmlspecialchars($assessment->class_code); ?></dd>
                            <dt>Subject:</dt>
                            <dd><?php echo htmlspecialchars($assessment->subject_name); ?></dd>
                            <dt>Level:</dt>
                            <dd><?php echo htmlspecialchars($assessment->level_code); ?></dd>
                            <dt>Type:</dt>
                            <dd><span class="label label-default"><?php echo $assessment->assessment_type; ?></span></dd>
                            <dt>Total Marks:</dt>
                            <dd><strong><?php echo $assessment->total_marks; ?></strong></dd>
                            <dt>Weight:</dt>
                            <dd><?php echo $assessment->weight_percentage ? $assessment->weight_percentage . '%' : '-'; ?></dd>
                            <dt>Due Date:</dt>
                            <dd><?php echo $assessment->due_date ? date('d M Y H:i', strtotime($assessment->due_date)) : '-'; ?></dd>
                        </dl>
                    </div>
                </div>

                <!-- Statistics -->
                <?php if ($stats && $stats->total_marked > 0): ?>
                <div class="box box-success">
                    <div class="box-header with-border">
                        <h3 class="box-title">Statistics</h3>
                    </div>
                    <div class="box-body">
                        <dl class="dl-horizontal">
                            <dt>Marked:</dt>
                            <dd><?php echo $stats->total_marked; ?> students</dd>
                            <dt>Average:</dt>
                            <dd><?php echo round($stats->avg_marks, 1); ?> (<?php echo round($stats->avg_percentage, 1); ?>%)</dd>
                            <dt>Highest:</dt>
                            <dd><?php echo $stats->max_marks; ?></dd>
                            <dt>Lowest:</dt>
                            <dd><?php echo $stats->min_marks; ?></dd>
                            <dt>Passed:</dt>
                            <dd><span class="label label-success"><?php echo $stats->passed; ?></span></dd>
                            <dt>Failed:</dt>
                            <dd><span class="label label-danger"><?php echo $stats->failed; ?></span></dd>
                        </dl>
                    </div>
                </div>
                <?php endif; ?>
            </div>

            <!-- Marks Entry -->
            <div class="col-md-8">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Enter Marks</h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo base_url('admin/academic/assessments?class_id=' . $assessment->class_id); ?>" class="btn btn-default btn-sm">
                                <i class="fa fa-arrow-left"></i> Back
                            </a>
                        </div>
                    </div>
                    <form method="post" action="">
                        <div class="box-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered">
                                    <thead>
                                        <tr>
                                            <th width="5%">#</th>
                                            <th width="15%">Student No</th>
                                            <th width="25%">Student Name</th>
                                            <th width="15%">Marks (/ <?php echo $assessment->total_marks; ?>)</th>
                                            <th width="10%">Grade</th>
                                            <th width="30%">Feedback</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if (!empty($students)): ?>
                                        <?php $i = 1; foreach ($students as $s): ?>
                                        <?php
                                        $enrolment_id = $s->enrolment_id;
                                        $existing = isset($existing_marks[$enrolment_id]) ? $existing_marks[$enrolment_id] : null;
                                        $current_marks = $existing ? $existing['marks_obtained'] : '';
                                        $current_grade = $existing ? $existing['grade'] : '';
                                        $current_feedback = $existing ? $existing['feedback'] : '';
                                        ?>
                                        <tr>
                                            <td><?php echo $i++; ?></td>
                                            <td><?php echo htmlspecialchars($s->admission_no); ?></td>
                                            <td><?php echo htmlspecialchars($s->firstname . ' ' . $s->lastname); ?></td>
                                            <td>
                                                <input type="number" name="marks[<?php echo $enrolment_id; ?>]"
                                                       class="form-control input-sm marks-input"
                                                       value="<?php echo $current_marks; ?>"
                                                       min="0" max="<?php echo $assessment->total_marks; ?>"
                                                       step="0.5"
                                                       data-enrolment="<?php echo $enrolment_id; ?>"
                                                       onchange="calculateGrade(this)">
                                            </td>
                                            <td>
                                                <span id="grade_<?php echo $enrolment_id; ?>" class="label label-default">
                                                    <?php echo $current_grade ?: '-'; ?>
                                                </span>
                                            </td>
                                            <td>
                                                <input type="text" name="feedback[<?php echo $enrolment_id; ?>]"
                                                       class="form-control input-sm"
                                                       value="<?php echo htmlspecialchars($current_feedback); ?>"
                                                       placeholder="Optional feedback">
                                            </td>
                                        </tr>
                                        <?php endforeach; ?>
                                        <?php else: ?>
                                        <tr>
                                            <td colspan="6" class="text-center">No students enrolled in this class</td>
                                        </tr>
                                        <?php endif; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="box-footer">
                            <button type="submit" class="btn btn-primary">
                                <i class="fa fa-save"></i> Save Marks
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</div>

<script>
var totalMarks = <?php echo $assessment->total_marks; ?>;

function calculateGrade(input) {
    var marks = parseFloat(input.value);
    var enrolmentId = $(input).data('enrolment');
    var gradeSpan = $('#grade_' + enrolmentId);

    if (isNaN(marks) || marks === '') {
        gradeSpan.text('-').attr('class', 'label label-default');
        return;
    }

    var percentage = (marks / totalMarks) * 100;
    var grade, labelClass;

    if (percentage >= 80) { grade = 'A'; labelClass = 'label-success'; }
    else if (percentage >= 70) { grade = 'B'; labelClass = 'label-info'; }
    else if (percentage >= 60) { grade = 'C'; labelClass = 'label-primary'; }
    else if (percentage >= 50) { grade = 'D'; labelClass = 'label-warning'; }
    else if (percentage >= 40) { grade = 'E'; labelClass = 'label-warning'; }
    else { grade = 'F'; labelClass = 'label-danger'; }

    gradeSpan.text(grade + ' (' + percentage.toFixed(1) + '%)').attr('class', 'label ' + labelClass);
}

// Initialize grades on page load
$(document).ready(function() {
    $('.marks-input').each(function() {
        if ($(this).val() !== '') {
            calculateGrade(this);
        }
    });
});
</script>
