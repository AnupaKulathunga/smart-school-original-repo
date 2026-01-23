<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> Module Mapping - <?php echo $level['name']; ?></h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <a href="<?php echo base_url('admin/tvet/module_mapping'); ?>" class="btn btn-default btn-sm" style="margin-bottom: 15px;">
                    <i class="fa fa-arrow-left"></i> Back to Levels
                </a>
            </div>
        </div>

        <!-- Existing Modules Table -->
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix">Mapped Modules</h3>
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="mailbox-messages">
                            <?php if ($this->session->flashdata('msg')) { ?>
                                <?php echo $this->session->flashdata('msg'); ?>
                            <?php } ?>

                            <div class="table-responsive overflow-visible">
                                <table class="table table-striped table-bordered table-hover example" data-export-title="Modules">
                                    <thead>
                                        <tr>
                                            <th>Module Code</th>
                                            <th>Module Name</th>
                                            <th>Subject</th>
                                            <th>Credits</th>
                                            <th>Semester</th>
                                            <th>Core/Elective</th>
                                            <th class="text-right noExport">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if (!empty($modules)) {
                                            foreach ($modules as $module) { ?>
                                                <tr>
                                                    <td><?php echo $module['module_code']; ?></td>
                                                    <td><?php echo $module['module_name']; ?></td>
                                                    <td><?php echo $module['subject_name']; ?></td>
                                                    <td><?php echo $module['credits']; ?></td>
                                                    <td><?php echo $module['semester']; ?></td>
                                                    <td>
                                                        <?php if ($module['is_core']) { ?>
                                                            <span class="label label-primary">Core</span>
                                                        <?php } else { ?>
                                                            <span class="label label-info">Elective</span>
                                                        <?php } ?>
                                                    </td>
                                                    <td class="text-right">
                                                        <a href="<?php echo base_url('admin/tvet/module_delete/' . $module['id'] . '/' . $level['id']); ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="Delete" onclick="return confirm('Are you sure you want to delete this module mapping?');">
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
            </div>
        </div>

        <!-- Add Module Form -->
        <div class="row">
            <div class="col-md-8">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Add Module</h3>
                    </div><!-- /.box-header -->
                    <form id="form1" action="" method="post" accept-charset="utf-8">
                        <div class="box-body">
                            <?php if (validation_errors()) { ?>
                                <div class="alert alert-danger">
                                    <?php echo validation_errors(); ?>
                                </div>
                            <?php } ?>

                            <?php echo $this->customlib->getCSRF(); ?>

                            <div class="form-group">
                                <label>Subject</label><small class="req"> *</small>
                                <select name="subject_id" class="form-control" required>
                                    <option value="">-- Select Subject --</option>
                                    <?php if (!empty($subjects)) {
                                        foreach ($subjects as $subject) { ?>
                                            <option value="<?php echo $subject['id']; ?>" <?php echo (set_value('subject_id') == $subject['id']) ? 'selected' : ''; ?>><?php echo $subject['name']; ?></option>
                                        <?php }
                                    } ?>
                                </select>
                                <span class="text-danger"><?php echo form_error('subject_id'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Module Code</label><small class="req"> *</small>
                                <input id="module_code" name="module_code" placeholder="e.g., MOD101" type="text" class="form-control" value="<?php echo set_value('module_code'); ?>" />
                                <span class="text-danger"><?php echo form_error('module_code'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Module Name</label><small class="req"> *</small>
                                <input id="module_name" name="module_name" placeholder="" type="text" class="form-control" value="<?php echo set_value('module_name'); ?>" />
                                <span class="text-danger"><?php echo form_error('module_name'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Credits</label><small class="req"> *</small>
                                <input id="credits" name="credits" placeholder="" type="number" class="form-control" min="1" value="<?php echo set_value('credits'); ?>" />
                                <span class="text-danger"><?php echo form_error('credits'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Semester</label><small class="req"> *</small>
                                <select name="semester" class="form-control" required>
                                    <option value="">-- Select Semester --</option>
                                    <option value="1" <?php echo (set_value('semester') == '1') ? 'selected' : ''; ?>>1</option>
                                    <option value="2" <?php echo (set_value('semester') == '2') ? 'selected' : ''; ?>>2</option>
                                    <option value="Year" <?php echo (set_value('semester') == 'Year') ? 'selected' : ''; ?>>Year</option>
                                </select>
                                <span class="text-danger"><?php echo form_error('semester'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>
                                    <input type="checkbox" name="is_core" value="1" <?php echo (set_value('is_core', '1') == '1') ? 'checked' : ''; ?> /> Core Module
                                </label>
                            </div>

                        </div><!-- /.box-body -->
                        <div class="box-footer">
                            <button type="submit" class="btn btn-info pull-right">Map Module</button>
                        </div>
                    </form>
                </div>
            </div><!--/.col -->
        </div>
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->
