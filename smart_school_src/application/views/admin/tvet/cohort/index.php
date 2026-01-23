<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> Cohort Management</h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <!-- left column -->
            <div class="col-md-12">
                <!-- general form elements -->
                <div class="box box-primary">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix">Cohort List</h3>
                        <div class="box-tools pull-right">
                            <a href="<?php echo base_url('admin/tvet/cohort_add'); ?>" class="btn btn-sm btn-primary"><i class="fa fa-plus"></i> Add Cohort</a>
                        </div><!-- /.box-tools -->
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="mailbox-messages">
                            <?php if ($this->session->flashdata('msg')) { ?>
                                <?php echo $this->session->flashdata('msg'); ?>
                            <?php } ?>

                            <div class="table-responsive overflow-visible">
                                <table class="table table-striped table-bordered table-hover example" data-export-title="Cohort List">
                                    <thead>
                                        <tr>
                                            <th>Code</th>
                                            <th>Name</th>
                                            <th>Level</th>
                                            <th>Programme</th>
                                            <th>Intake Year</th>
                                            <th>Mode</th>
                                            <th>Dates</th>
                                            <th>Students</th>
                                            <th>Status</th>
                                            <th class="text-right noExport">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if (!empty($cohorts)) {
                                            foreach ($cohorts as $cohort) { ?>
                                                <tr>
                                                    <td><?php echo $cohort['code']; ?></td>
                                                    <td><?php echo $cohort['name']; ?></td>
                                                    <td><?php echo $cohort['level_name']; ?></td>
                                                    <td><?php echo $cohort['programme_name']; ?></td>
                                                    <td><?php echo $cohort['intake_year']; ?></td>
                                                    <td><?php echo $cohort['delivery_mode']; ?></td>
                                                    <td>
                                                        <?php echo $cohort['start_date']; ?>
                                                        <?php if (!empty($cohort['end_date'])) { ?>
                                                            - <?php echo $cohort['end_date']; ?>
                                                        <?php } ?>
                                                    </td>
                                                    <td>
                                                        <?php if (isset($cohort['student_count'])) { ?>
                                                            <a href="<?php echo base_url('admin/tvet/cohort_roster/' . $cohort['id']); ?>" data-toggle="tooltip" title="View Roster">
                                                                <?php echo $cohort['student_count']; ?> / <?php echo $cohort['max_students']; ?>
                                                            </a>
                                                        <?php } else { ?>
                                                            <a href="<?php echo base_url('admin/tvet/cohort_roster/' . $cohort['id']); ?>" data-toggle="tooltip" title="View Roster">
                                                                0 / <?php echo $cohort['max_students']; ?>
                                                            </a>
                                                        <?php } ?>
                                                    </td>
                                                    <td>
                                                        <?php if ($cohort['active']) { ?>
                                                            <span class="label label-success">Active</span>
                                                        <?php } else { ?>
                                                            <span class="label label-danger">Inactive</span>
                                                        <?php } ?>
                                                    </td>
                                                    <td class="text-right">
                                                        <a href="<?php echo base_url('admin/tvet/cohort_edit/' . $cohort['id']); ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="Edit">
                                                            <i class="fa fa-pencil"></i>
                                                        </a>
                                                        <a href="<?php echo base_url('admin/tvet/cohort_roster/' . $cohort['id']); ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="Roster">
                                                            <i class="fa fa-users"></i>
                                                        </a>
                                                        <a href="<?php echo base_url('admin/tvet/cohort_delete/' . $cohort['id']); ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="Delete" onclick="return confirm('Are you sure you want to delete this cohort?');">
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
