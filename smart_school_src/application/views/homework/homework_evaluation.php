<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-flask"></i> <?php //echo $this->lang->line('homework'); ?>
    </section>
    <!-- Main content -->
    <section class="content">
        <?php $this->load->view('homework/_homeworkordailyassignmentreport'); ?> 
        <div class="box removeboxmius">
            <div class="box-header ptbnull"></div>
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-search"></i> <?php echo $this->lang->line('select_criteria'); ?></h3>
            </div>
            <form  class="assign_teacher_form" action="<?php echo base_url(); ?>homework/evaluation_report" method="post" enctype="multipart/form-data">
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
                            <span class="class_id_error text-danger"><?php echo form_error('class_id'); ?></span>
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
                    <h3 class="box-title"><i class="fa fa-users"> </i> <?php echo $this->lang->line('homework_evaluation_report'); ?></h3>
                </div>
                <div class="box-body table-responsive">
                    <div class="download_label"> <?php echo $this->lang->line('homework_evaluation_report') . "<br>";
$this->customlib->get_postmessage();
?></div>
                    <table class="table table-striped table-bordered table-hover example" cellspacing="0" width="100%">
                        <thead>
                            <tr>
                                <th><?php echo $this->lang->line('subject') ?></th>
                                <th><?php echo $this->lang->line('homework_date'); ?> </th>
                                <th><?php echo $this->lang->line('submission_date'); ?></th>
                                <th><?php echo $this->lang->line('complete_incomplete'); ?></th>
                                <th><?php echo $this->lang->line('complete'); ?>%</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
if (!empty($resultlist)) {

    foreach ($resultlist as $key => $homework) {
        ?>
                                    <tr>
                                        <td><?php echo $homework["subject_name"]; ?> <?php if($homework["subject_code"]){ echo '('.$homework["subject_code"].')'; } ?></td>
                                        <td><?php echo date($this->customlib->getSchoolDateFormat(), $this->customlib->dateyyyymmddTodateformat($homework['homework_date'])); ?></td>
                                        <td><?php echo date($this->customlib->getSchoolDateFormat(), $this->customlib->dateyyyymmddTodateformat($homework['submit_date'])); ?></td>
                                        <td><?php
if (!empty($report[$homework['id']])) {
            echo $report[$homework['id']]['completed'] . "/" . ($report[$homework['id']]["total"] - $report[$homework['id']]["completed"]);
        }
        ?></td>
                                        <td><?php
if (!empty($report[$homework['id']])) {
            echo $report[$homework['id']]["percentage"];
        }
        ?></td>
                                    </tr>
        <?php
}
}
?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div><!--./box box-primary-->
    </section>
</div>

<div class="modal fade" id="report" tabindex="-1" role="dialog" aria-labelledby="evaluation">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content modal-media-content">
            <div class="modal-header modal-media-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="box-title"><?php echo $this->lang->line('homework_evaluation'); ?></h4>
            </div>
            <div class="modal-body pt0 pb0" id="evaluation_details">
            </div>
        </div>
    </div>
</div>

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
<!-- TVET: Subject group/subject JS removed — subject auto-derived from class -->