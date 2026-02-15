<?php $currency_symbol = $this->customlib->getSchoolCurrencyFormat();?>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <?php
if ($this->rbac->hasPrivilege('subject_group', 'can_add')) {
    ?>
                <div class="col-md-4">
                    <!-- Horizontal Form -->
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><?php echo $this->lang->line('add_subject_group'); ?></h3>
                        </div><!-- /.box-header -->
                        <form id="form1" action="<?php echo site_url('admin/subjectgroup') ?>"  id="employeeform" name="employeeform" method="post" accept-charset="utf-8">
                            <div class="box-body">
                                <?php if ($this->session->flashdata('msg')) {
        ?>
                                    <?php echo $this->session->flashdata('msg');
        $this->session->unset_userdata('msg'); ?>
                                <?php }?>
                                <?php
if (isset($error_message)) {
        echo "<div class='alert alert-danger'>" . $error_message . "</div>";
    }
    ?>
                                <?php echo $this->customlib->getCSRF(); ?>
 
                                <div class="form-group">
                                    <label for="exampleInputEmail1"><?php echo $this->lang->line('name'); ?></label> <small class="req">*</small>
                                    <input autofocus="" id="name" name="name" placeholder="" type="text" class="form-control"  value="<?php echo set_value('name'); ?>" />
                                    <span class="text-danger"><?php echo form_error('name'); ?></span>
                                </div>
                                <?php
                                $this->load->view('admin/_partials/class_selector', [
                                    'selected_class_id' => set_value('class_id'),
                                    'classlist' => $classlist
                                ]);
                                ?>
                                <div class="form-group">
                                    <label for="exampleInputEmail1"><?php echo $this->lang->line('subject') ?></label><small class="req"> *</small>

                                    <?php
foreach ($subjectlist as $subject) {
        ?>
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" name="subject[]" value="<?php echo $subject['id'] ?>" <?php echo set_checkbox('subject[]', $subject['id']); ?> ><?php echo $subject['name'] ?>
                                            </label>
                                        </div>
                                        <?php
}
    ?>
                                    <span class="text-danger"><?php echo form_error('subject[]'); ?></span>
                                </div>
                                <div class="form-group">
                                    <label for="exampleInputEmail1"><?php echo $this->lang->line('description'); ?></label>
                                    <textarea class="form-control" id="description" name="description" placeholder="" rows="3" placeholder="Enter ..."><?php echo set_value('description'); ?></textarea>
                                    <span class="text-danger"></span>
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
if ($this->rbac->hasPrivilege('subject_group', 'can_add')) {
    echo "8";
} else {
    echo "12";
}
?>">
                <!-- general form elements -->
                <div class="box box-primary" id="subject_list">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix"><?php echo $this->lang->line('subject_group_list'); ?></h3>
                        <div class="box-tools pull-right">
                        </div><!-- /.box-tools -->
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="table-responsive mailbox-messages"> 
                            <div class="download_label"><?php echo $this->lang->line('subject_group_list'); ?></div>

                            <a class="btn btn-default btn-xs pull-right" title="<?php echo $this->lang->line('print'); ?>" id="print" onclick="printDiv()" ><i class="fa fa-print"></i></a> 
                            <a class="btn btn-default btn-xs pull-right" title="<?php echo $this->lang->line('export'); ?>"  id="btnExport" onclick="fnExcelReport();"> <i class="fa fa-file-excel-o"></i> </a>
                            
                            <table class="table table-striped  table-hover " id="headerTable">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('name'); ?></th>
                                        <th class="text-left"><?php echo $this->lang->line('class'); ?></th>
                                        <th><?php echo $this->lang->line('subject'); ?></th>
                                        <th class="text-right no_print"><?php echo $this->lang->line('action'); ?></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
foreach ($subjectgroupList as $subjectgroup) {
    ?>
                                        <tr>
                                            <td class="mailbox-name">
                                                <a href="#" data-toggle="popover" class="detail_popover"><?php echo $subjectgroup->name; ?></a>
                                                <div class="fee_detail_popover" style="display: none">
                                                    <?php
if ($subjectgroup->description == "") {
        ?>
                                                        <p class="text text-danger"><?php echo $this->lang->line('no_description'); ?></p>
                                                        <?php
} else {
        ?>
                                                        <p class="text text-info"><?php echo $subjectgroup->description; ?></p>
                                                        <?php
}
    ?>
                                                </div>
                                            </td>
                                            <td  class="text-left">
                                                <ol>

                                                    <?php foreach ($subjectgroup->sections as $group_section_key => $group_section_value) {?>
                                                         <?php echo "<li>" . $group_section_value->class . "</li>"; ?>
                                                        <?php
}
    ?>
                                                </ol>
                                            </td>
                                            <td>
                                                <table width="100%">
                                                    <?php
foreach ($subjectgroup->group_subject as $group_subject_key => $group_subject_value) {
        ?>
                                                        <tr><td>
                                                                <?php echo "<div>" . $group_subject_value->name . "</div>"; ?>
                                                            </td></tr>

                                                        <?php
}
    ?>
                                                </table>
                                            </td>
                                            <td class="mailbox-date pull-right no_print">
                                                <?php
if ($this->rbac->hasPrivilege('subject_group', 'can_edit')) {
        ?>
                                                    <a href="<?php echo base_url(); ?>admin/subjectgroup/edit/<?php echo $subjectgroup->id; ?>" class="btn btn-default btn-xs no_print displayinline" data-toggle="tooltip" title="<?php echo $this->lang->line('edit'); ?>">
                                                        <i class="fa fa-pencil"></i>
                                                    </a>
                                                <?php }?>
                                                <?php
if ($this->rbac->hasPrivilege('subject_group', 'can_delete')) {
        ?>
                                                    <a  href="<?php echo base_url(); ?>admin/subjectgroup/delete/<?php echo $subjectgroup->id; ?>"class="btn btn-default btn-xs no_print displayinline" data-toggle="tooltip" title="<?php echo $this->lang->line('delete'); ?>" onclick="return confirm('<?php echo $this->lang->line('delete_confirm') ?>');">
                                                        <i  class="fa fa-remove"></i>
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
            <!-- right column -->
        </div>
        <div class="row">
            <!-- left column -->
            <!-- right column -->
            <div class="col-md-12">
            </div><!--/.col (right) -->
        </div>   <!-- /.row -->
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

<script>
    $(document).ready(function () {
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
    
    $(".no_print").css("display", "block");
    document.getElementById("print").style.display = "block";
    document.getElementById("btnExport").style.display = "block";

    function printDiv() {
        $(".no_print").css("display", "none");
        document.getElementById("print").style.display = "none";
        document.getElementById("btnExport").style.display = "none";
        var divElements = document.getElementById('subject_list').innerHTML;
        var oldPage = document.body.innerHTML;
        document.body.innerHTML =
                "<html><head><title></title></head><body>" +
                divElements + "</body>";
        window.print();
        document.body.innerHTML = oldPage;
        location.reload(true);
    }

  

</script>