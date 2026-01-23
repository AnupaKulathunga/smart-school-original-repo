<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> TVET Dashboard</h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <!-- Info boxes -->
        <div class="row">
            <div class="col-md-3 col-sm-6 col-xs-12">
                <div class="small-box bg-aqua">
                    <div class="inner">
                        <h3><?php echo $programmes_count; ?></h3>
                        <p>Programmes</p>
                    </div>
                    <div class="icon"><i class="fa fa-sitemap"></i></div>
                    <a href="<?php echo base_url('admin/tvet/programme'); ?>" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 col-xs-12">
                <div class="small-box bg-green">
                    <div class="inner">
                        <h3><?php echo $qualifications_count; ?></h3>
                        <p>Qualifications</p>
                    </div>
                    <div class="icon"><i class="fa fa-certificate"></i></div>
                    <a href="<?php echo base_url('admin/tvet/qualification'); ?>" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 col-xs-12">
                <div class="small-box bg-yellow">
                    <div class="inner">
                        <h3><?php echo $levels_count; ?></h3>
                        <p>Levels</p>
                    </div>
                    <div class="icon"><i class="fa fa-list-ol"></i></div>
                    <a href="<?php echo base_url('admin/tvet/level'); ?>" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
                </div>
            </div>
            <div class="col-md-3 col-sm-6 col-xs-12">
                <div class="small-box bg-red">
                    <div class="inner">
                        <h3><?php echo $cohorts_count; ?></h3>
                        <p>Cohorts</p>
                    </div>
                    <div class="icon"><i class="fa fa-users"></i></div>
                    <a href="<?php echo base_url('admin/tvet/cohort'); ?>" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
                </div>
            </div>
        </div>

        <!-- Quick Links -->
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-link"></i> Quick Links</h3>
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <a href="<?php echo base_url('admin/tvet/programme'); ?>" class="btn btn-primary" style="margin: 5px;">
                            <i class="fa fa-sitemap"></i> Programmes
                        </a>
                        <a href="<?php echo base_url('admin/tvet/qualification'); ?>" class="btn btn-success" style="margin: 5px;">
                            <i class="fa fa-certificate"></i> Qualifications
                        </a>
                        <a href="<?php echo base_url('admin/tvet/level'); ?>" class="btn btn-warning" style="margin: 5px;">
                            <i class="fa fa-list-ol"></i> Levels
                        </a>
                        <a href="<?php echo base_url('admin/tvet/cohort'); ?>" class="btn btn-danger" style="margin: 5px;">
                            <i class="fa fa-users"></i> Cohorts
                        </a>
                        <a href="<?php echo base_url('admin/tvet/module_mapping'); ?>" class="btn btn-info" style="margin: 5px;">
                            <i class="fa fa-cogs"></i> Module Mapping
                        </a>
                        <a href="<?php echo base_url('admin/tvet/lecturer_allocation'); ?>" class="btn btn-default" style="margin: 5px;">
                            <i class="fa fa-user-plus"></i> Lecturer Allocation
                        </a>
                    </div><!-- /.box-body -->
                </div>
            </div>
        </div>
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->
