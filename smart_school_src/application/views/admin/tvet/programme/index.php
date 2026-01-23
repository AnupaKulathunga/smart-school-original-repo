<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> Programme Management</h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <!-- left column -->
            <div class="col-md-12">
                <!-- general form elements -->
                <div class="box box-primary">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix">Programme List</h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo base_url('admin/tvet/programme_add'); ?>" class="btn btn-sm btn-primary"><i class="fa fa-plus"></i> Add Programme</a>
                        </div><!-- /.box-tools -->
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="mailbox-messages">
                            <?php if ($this->session->flashdata('msg')) { ?>
                                <?php echo $this->session->flashdata('msg'); ?>
                            <?php } ?>

                            <div class="table-responsive overflow-visible">
                                <table class="table table-striped table-bordered table-hover example" data-export-title="Programme List">
                                    <thead>
                                        <tr>
                                            <th>Code</th>
                                            <th>Name</th>
                                            <th>Description</th>
                                            <th>Status</th>
                                            <th class="text-right noExport">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if (!empty($programmes)) {
                                            foreach ($programmes as $programme) { ?>
                                                <tr>
                                                    <td><?php echo $programme['code']; ?></td>
                                                    <td><?php echo $programme['name']; ?></td>
                                                    <td><?php echo $programme['description']; ?></td>
                                                    <td>
                                                        <?php if ($programme['active']) { ?>
                                                            <span class="label label-success">Active</span>
                                                        <?php } else { ?>
                                                            <span class="label label-danger">Inactive</span>
                                                        <?php } ?>
                                                    </td>
                                                    <td class="text-right">
                                                        <a href="<?php echo base_url('admin/tvet/programme_edit/' . $programme['id']); ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="Edit">
                                                            <i class="fa fa-pencil"></i>
                                                        </a>
                                                        <a href="<?php echo base_url('admin/tvet/programme_delete/' . $programme['id']); ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="Delete" onclick="return confirm('Are you sure you want to delete this programme?');">
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
