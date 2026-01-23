<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> Qualification Management</h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <!-- left column -->
            <div class="col-md-12">
                <!-- general form elements -->
                <div class="box box-primary">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix">Qualification List</h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo base_url('admin/tvet/qualification_add'); ?>" class="btn btn-sm btn-primary"><i class="fa fa-plus"></i> Add Qualification</a>
                        </div><!-- /.box-tools -->
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="mailbox-messages">
                            <?php if ($this->session->flashdata('msg')) { ?>
                                <?php echo $this->session->flashdata('msg'); ?>
                            <?php } ?>

                            <div class="table-responsive overflow-visible">
                                <table class="table table-striped table-bordered table-hover example" data-export-title="Qualification List">
                                    <thead>
                                        <tr>
                                            <th>Code</th>
                                            <th>Name</th>
                                            <th>Programme</th>
                                            <th>Status</th>
                                            <th class="text-right noExport">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if (!empty($qualifications)) {
                                            foreach ($qualifications as $q) { ?>
                                                <tr>
                                                    <td><?php echo $q['code']; ?></td>
                                                    <td><?php echo $q['name']; ?></td>
                                                    <td><?php echo $q['programme_name']; ?></td>
                                                    <td>
                                                        <?php if ($q['active']) { ?>
                                                            <span class="label label-success">Active</span>
                                                        <?php } else { ?>
                                                            <span class="label label-danger">Inactive</span>
                                                        <?php } ?>
                                                    </td>
                                                    <td class="text-right">
                                                        <a href="<?php echo base_url('admin/tvet/qualification_edit/' . $q['id']); ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="Edit">
                                                            <i class="fa fa-pencil"></i>
                                                        </a>
                                                        <a href="<?php echo base_url('admin/tvet/qualification_delete/' . $q['id']); ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="Delete" onclick="return confirm('Are you sure you want to delete this qualification?');">
                                                            <i class="fa fa-remove"></i>
                                                        </a>
                                                    </td>
                                                </tr>
                                            <?php }
                                        } ?>
                                    </tbody>
                                </table><!-- /.table -->
                            </div>
                        </div><!-- /.mail-box-messages -->
                    </div><!-- /.box-body -->
                </div>
            </div><!--/.col (left) -->
        </div>
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->
