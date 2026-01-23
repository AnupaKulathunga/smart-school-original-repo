<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> Module Mapping - Select Level</h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <!-- left column -->
            <div class="col-md-12">
                <!-- general form elements -->
                <div class="box box-primary">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix">Levels</h3>
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="mailbox-messages">
                            <?php if ($this->session->flashdata('msg')) { ?>
                                <?php echo $this->session->flashdata('msg'); ?>
                            <?php } ?>

                            <div class="table-responsive overflow-visible">
                                <table class="table table-striped table-bordered table-hover example" data-export-title="Levels">
                                    <thead>
                                        <tr>
                                            <th>Code</th>
                                            <th>Name</th>
                                            <th>Qualification</th>
                                            <th class="text-right noExport">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if (!empty($levels)) {
                                            foreach ($levels as $level) { ?>
                                                <tr>
                                                    <td><?php echo $level['code']; ?></td>
                                                    <td><?php echo $level['name']; ?></td>
                                                    <td><?php echo $level['qualification_name']; ?></td>
                                                    <td class="text-right">
                                                        <a href="<?php echo base_url('admin/tvet/module_mapping/' . $level['id']); ?>" class="btn btn-primary btn-xs" data-toggle="tooltip" title="Manage Modules">
                                                            <i class="fa fa-cogs"></i> Manage Modules
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
