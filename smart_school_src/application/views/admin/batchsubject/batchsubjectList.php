<?php $currency_symbol = $this->customlib->getSchoolCurrencyFormat();?>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">

    <section class="content-header">
        <h1><i class="fa fa-credit-card"></i> Batch Subject--r</h1>
    </section>

    <!-- Main content -->
    <section class="content">
        <div class="row">
            <?php
if ($this->rbac->hasPrivilege('expense', 'can_add')) {
    ?>
                <div class="col-md-4">
                    <!-- Horizontal Form -->
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">Add Batch Subject--r</h3>
                        </div><!-- /.box-header -->
                        <form id="form1" action="<?php echo site_url('admin/batchsubject') ?>"  id="batchform" name="batchform" method="post" accept-charset="utf-8" enctype="multipart/form-data">
                            <div class="box-body">
                                <?php if ($this->session->flashdata('msg')) {?>
                                    <?php 
                                        echo $this->session->flashdata('msg');
                                        $this->session->unset_userdata('msg');
                                    ?>
                                <?php }?>
                                <?php
if (isset($error_message)) {
        echo "<div class='alert alert-danger'>" . $error_message . "</div>";
    }
    ?>
                                <?php echo $this->customlib->getCSRF(); ?>
                                <?php
                                // TVET: Use class_selector component
                                $this->load->view('admin/_partials/class_selector', [
                                    'selected_class_id' => set_value('class_id'),
                                    'classlist' => $classlist
                                ]);
                                ?>
                                <div class="form-group">
                                    <label for="exampleInputEmail1">Batch --r</label><small class="req"> *</small>
                                    <select  id="batch_id" name="batch_id" class="form-control" >
                                        <option value=""><?php echo $this->lang->line('select'); ?></option>
                                    </select>
                                    <span class="text-danger"><?php echo form_error('batch_id'); ?></span>
                                </div>
                                <div class="form-group">
                                    <label for="exampleInputEmail1"><?php echo $this->lang->line('subject'); ?></label><small class="req"> *</small>
                                    <select  id="subject_id" name="subject_id" class="form-control" >
                                        <option value=""><?php echo $this->lang->line('select'); ?></option>
                                        <?php
foreach ($subjectlist as $subject) {
        ?>
                                            <option value="<?php echo $subject['id'] ?>"<?php
if (set_value('subject_id') == $subject['id']) {
            echo "selected=selected";
        }
        ?>><?php echo $subject['name'] ?></option>
                                                    <?php
}
    ?>
                                    </select>
                                    <span class="text-danger"><?php echo form_error('subject_id'); ?></span>
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" value="1" name="is_exam"> No Exam --r
                                    </label>
                                </div>
                            </div><!-- /.box-body -->
                            <div class="box-footer">
                                <button type="submit" class="btn btn-info pull-right"><?php echo $this->lang->line('save'); ?></button>
                            </div>
                        </form>
                    </div>
                </div><!--/.col (right) -->
                <!-- left column -->
            <?php }?>
            <div class="col-md-<?php
if ($this->rbac->hasPrivilege('expense', 'can_add')) {
    echo "8";
} else {
    echo "12";
}
?>">
                <!-- general form elements -->
                <div class="box box-primary">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix">Batch Subject List --r</h3>
                        <div class="box-tools pull-right">
                        </div><!-- /.box-tools -->
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="table-responsive mailbox-messages">
                            <div class="download_label"><?php echo $this->lang->line('expense_list'); ?></div>
                            <table class="table table-hover table-striped table-bordered example">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('class'); ?></th>
                                        <th>Batch</th>
                                        <th><?php echo $this->lang->line('subject'); ?></th>
                                        <th class="text-right"><?php echo $this->lang->line('action'); ?></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
foreach ($batchlist as $batch) {
    ?>
                                        <tr>
                                            <td class="mailbox-name">
                                                <!-- TVET: Display CLASS info (class may be legacy or TVET depending on data) -->
                                                <a href="#" data-toggle="popover" class="detail_popover">
                                                    <?php echo isset($batch->class) ? $batch->class : ''; ?>
                                                    <?php echo isset($batch->section) && $batch->section ? ' (' . $batch->section . ')' : ''; ?>
                                                </a>
                                            </td>
                                            <td class="mailbox-name"><?php echo $batch->name; ?></td>
                                            <td class="mailbox-name">
                                                <ul class="liststyle1">
                                                    <?php
foreach ($batch->batch_subjects as $batchsubject_key => $batchsubject_value) {
        ?>
                                                        <li> <i class="fa fa-file"></i>
                                                            <?php echo $batchsubject_value->subject_name; ?> &nbsp;&nbsp;
                                                            <?php if ($this->rbac->hasPrivilege('fees_master', 'can_edit')) {?>
                                                                <a href="<?php echo base_url(); ?>admin/batchsubject/edit/<?php echo $batchsubject_value->id ?>"   data-toggle="tooltip" title="<?php echo $this->lang->line('edit'); ?>">
                                                                    <i class="fa fa-pencil"></i>
                                                                </a>&nbsp;
                                                                <?php
}
        if ($this->rbac->hasPrivilege('fees_master', 'can_delete')) {
            ?>
                                                                <a href="<?php echo base_url(); ?>admin/batchsubject/delete/<?php echo $batchsubject_value->id ?>" data-toggle="tooltip" title="<?php echo $this->lang->line('delete'); ?>" onclick="return confirm('<?php echo $this->lang->line('delete_confirm') ?>');">
                                                                    <i class="fa fa-remove"></i>
                                                                </a>
                                                            <?php }?>

                                                        </li>
                                                        <?php
}
    ?>
                                                </ul>
                                            </td>
                                            <td class="mailbox-date pull-right">
                                                <?php if ($this->rbac->hasPrivilege('fees_master', 'can_delete')) {?>
                                                    <a href="<?php echo base_url(); ?>admin/batchsubject/deletegrp/<?php echo $batch->id ?>" class="btn btn-default btn-xs"  data-toggle="tooltip" title="<?php echo $this->lang->line('delete'); ?>" onclick="return confirm('<?php echo $this->lang->line('delete_confirm') ?>');">
                                                        <i class="fa fa-remove"></i>
                                                    </a>
                                                <?php }?>

                                            </td>
                                        </tr>
                                        <?php
}
?>
                                </tbody>
                            </table><!-- /.table -->
                        </div><!-- /.mail-box-messages -->
                    </div><!-- /.box-body -->
                </div>
            </div><!--/.col (left) -->
        </div>
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

<script type="text/javascript">
    $(document).ready(function () {

        var class_id = '<?php echo set_value('class_id', 0) ?>';
        var batch_id = '<?php echo set_value('batch_id', 0) ?>';

        // TVET: Load batches directly from class_id (no section step)
        getBatchStudents(class_id, batch_id);

        // TVET: When class changes, load batches directly
        $(document).on('change', '#class_id', function (e) {
            var class_id = $(this).val();
            getBatchStudents(class_id, 0);
        });

        // TVET: Updated to use class_id directly instead of section_id
        function getBatchStudents(class_id, batch_id) {

            if (class_id != "") {
                $('#batch_id').html("");
                var base_url = '<?php echo base_url() ?>';
                var div_data = '<option value=""><?php echo $this->lang->line('select'); ?></option>';

                $.ajax({
                    type: "POST",
                    url: base_url + "admin/batch/getByClassSection",
                    data: {'section_id': class_id}, // TVET: Param name kept for compatibility
                    dataType: "JSON",
                    beforeSend: function () {
                        $('#batch_id').addClass('dropdownloading');
                    },
                    success: function (data) {
                        $.each(data, function (i, obj)
                        {
                            var sel = "";
                            if (batch_id == obj.batch_id) {
                                sel = "selected";
                            }
                            div_data += "<option value=" + obj.batch_id + " " + sel + ">" + obj.name + "</option>";
                        });
                        $('#batch_id').append(div_data);
                    },
                    complete: function () {
                        $('#batch_id').removeClass('dropdownloading');
                    }
                });
            }
        }
    });
</script>