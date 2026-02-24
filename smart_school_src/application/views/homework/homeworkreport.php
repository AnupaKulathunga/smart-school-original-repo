<div class="content-wrapper">     
    <!-- Main content -->
    <section class="content">
        <?php $this->load->view('homework/_homeworkordailyassignmentreport'); ?>        
            <div class="box removeboxmius">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-search"></i> <?php echo $this->lang->line('select_criteria'); ?></h3>
                    </div> 
                    
                    <form action="<?php echo site_url('homework/homeworkreport') ?>" method="post">
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
                        <div class="col-md-4">
                            <?php
                            // TVET: Use class_selector component (subject derived from class)
                            $this->load->view('admin/_partials/class_selector', [
                                'selected_class_id' => $class_id,
                                'name' => 'class_id',
                                'id' => 'searchclassid',
                                'required' => false
                            ]);
                            ?>
                        </div>
                    </div>
                    <button type="submit" id="search_filter" name="search" value="search_filter" class="btn btn-primary btn-sm checkbox-toggle pull-right"><i class="fa fa-search"></i> <?php echo $this->lang->line('search'); ?></button>
                </div>
                    </form>
                    <div class="">
                        <div class="box-header ptbnull"></div>
                        <div class="box-header ptbnull">
                            <h3 class="box-title titlefix"><i class="fa fa-money"></i>
                                <?php echo $this->lang->line('homework_report') ?></h3>
                        </div>
                        <div class="box-body table-responsive overflow-visible">
                            <div class="download_label"><?php echo $this->lang->line('homework_report') ;
                                        ?></div>
                            <table class="table table-striped table-bordered table-hover example">
                                <thead>
                                            <tr>
                                                <th><?php echo $this->lang->line('class') ?></th>
                                                <th><?php echo $this->lang->line('subject') ?></th>
                                                <th><?php echo $this->lang->line('homework_date'); ?></th>
                                                <th><?php echo $this->lang->line('submission_date'); ?></th>
                                                <th><?php echo $this->lang->line('student_count'); ?></th>
                                                <th><?php echo $this->lang->line('homework_submitted'); ?></th>
                                                <th class="text-start-lg"><?php echo $this->lang->line('pending_student'); ?></th>
                                                 
                                            </tr>
                                        </thead>
                                <tbody>
                                     <?php
                                    if (empty($resultlist)) {
                                        ?>

                                        <?php
                                    } else {
                                        $count = 1;
                                        foreach ($resultlist as $student) {                                           
                                            ?>
                                            <tr>
                                                <td><?php echo $student['class_code']; ?></td>
                                                <td><?php echo $student['subject_name']; ?><?php if($student['subject_code']){ echo ' ('.$student['subject_code'].')'; }?></td>
                                                <td><?php echo date($this->customlib->getSchoolDateFormat(), $this->customlib->dateyyyymmddTodateformat($student['homework_date'])); ?></td>  
                                                <td><?php echo date($this->customlib->getSchoolDateFormat(), $this->customlib->dateyyyymmddTodateformat($student['submit_date']));
                                                ?></td>                                                
                                                <td>
                                                    <a class="studentlist cursor-pointer" id="load" data-toggle="tooltip"  data-clss-id="<?php echo $student['class_id']; ?>" data-homework-id="<?php echo $student['id']; ?>" data-type="student_count" ><?php echo $student['student_count']; ?></a>    
                                                </td>                                                
                                                <td> 
                                                    <a  class="studentlist cursor-pointer" id="load" data-toggle="tooltip"  data-clss-id="<?php echo $student['class_id']; ?>" data-homework-id="<?php echo $student['id']; ?>" data-type="homework_submitted" ><?php echo $student['assignments']; ?></a>
                                                </td>                                                
                                                <td>
                                                    <a class="studentlist cursor-pointer text-left displayblock" id="load" data-toggle="tooltip" data-clss-id="<?php echo $student['class_id']; ?>" data-homework-id="<?php echo $student['id']; ?>" data-type="pending_student" ><?php echo $student['student_count']-$student['assignments']; ?></a>                                         
                                                </td>                                                   
                                            </tr>
                                            <?php
                                            $count++;
                                        }
                                    }
                                    ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div><!--./box box-primary-->
            </div><!--./col-md-12--> 
        </section>
</div>  

<div id="studentModal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-xl">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title"><?php echo $this->lang->line('student_list'); ?></h4>
            </div>
            <div class="modal-body scroll-area">
            </div>
        </div>
    </div>
</div>
 
<script type="text/javascript">

$(document).ready(function(){
  $('#studentModal').modal({backdrop:'static', keyboard:false, show: false});
});

      $(document).on('click', '.studentlist', function () {
        var $this = $(this);
        var date=$this.data('date');    
     
        $.ajax({
            type: 'POST',
            url: baseurl + "homework/getStudentByClassSection",
            data: {'class_id':$this.data('clssId'), 'homework_id':$this.data('homeworkId'), 'type':$this.data('type')},
            dataType: 'JSON',
            beforeSend: function () {
                $this.button('loading');
            },
            success: function (data) {
                $('#studentModal .modal-body').html(data.page);
                $('#studentModal').modal('show');
                $this.button('reset');
            },
            error: function (xhr) { // if error occured
                alert("<?php echo $this->lang->line('error_occurred_please_try_again'); ?>");
                $this.button('reset');
            },
            complete: function () {
                $this.button('reset');
            }
        });
    });
</script>

<!-- TVET: Subject group/subject JS removed — subject auto-derived from class -->