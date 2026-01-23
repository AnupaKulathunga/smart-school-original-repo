<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1><i class="fa fa-graduation-cap"></i> Lecturer Allocation</h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <!-- Existing Allocations Table -->
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix">Lecturer Allocations</h3>
                    </div><!-- /.box-header -->
                    <div class="box-body">
                        <div class="mailbox-messages">
                            <?php if ($this->session->flashdata('msg')) { ?>
                                <?php echo $this->session->flashdata('msg'); ?>
                            <?php } ?>

                            <div class="table-responsive overflow-visible">
                                <table class="table table-striped table-bordered table-hover example" data-export-title="Lecturer Allocations">
                                    <thead>
                                        <tr>
                                            <th>Lecturer</th>
                                            <th>Cohort</th>
                                            <th>Module</th>
                                            <th>Year</th>
                                            <th>Semester</th>
                                            <th>Primary</th>
                                            <th class="text-right noExport">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if (!empty($allocations)) {
                                            foreach ($allocations as $allocation) { ?>
                                                <tr>
                                                    <td><?php echo $allocation['staff_name'] . ' ' . $allocation['staff_surname']; ?></td>
                                                    <td><?php echo $allocation['cohort_name']; ?></td>
                                                    <td><?php echo $allocation['module_name']; ?></td>
                                                    <td><?php echo $allocation['academic_year']; ?></td>
                                                    <td><?php echo $allocation['semester']; ?></td>
                                                    <td>
                                                        <?php if ($allocation['is_primary']) { ?>
                                                            <span class="label label-success">Yes</span>
                                                        <?php } else { ?>
                                                            <span class="label label-default">No</span>
                                                        <?php } ?>
                                                    </td>
                                                    <td class="text-right">
                                                        <a href="<?php echo base_url('admin/tvet/lecturer_delete/' . $allocation['id']); ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="Delete" onclick="return confirm('Are you sure you want to delete this allocation?');">
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

        <!-- Allocate Lecturer Form -->
        <div class="row">
            <div class="col-md-8">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Allocate Lecturer</h3>
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
                                <label>Lecturer</label><small class="req"> *</small>
                                <select name="staff_id" class="form-control" required>
                                    <option value="">-- Select Lecturer --</option>
                                    <?php if (!empty($staff)) {
                                        foreach ($staff as $member) { ?>
                                            <option value="<?php echo $member['id']; ?>" <?php echo (set_value('staff_id') == $member['id']) ? 'selected' : ''; ?>><?php echo $member['name'] . ' ' . $member['surname']; ?></option>
                                        <?php }
                                    } ?>
                                </select>
                                <span class="text-danger"><?php echo form_error('staff_id'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Cohort</label><small class="req"> *</small>
                                <select name="cohort_id" id="cohort_id" class="form-control" required>
                                    <option value="">-- Select Cohort --</option>
                                    <?php if (!empty($cohorts)) {
                                        foreach ($cohorts as $cohort) { ?>
                                            <option value="<?php echo $cohort['id']; ?>" data-level-id="<?php echo $cohort['level_id']; ?>" <?php echo (set_value('cohort_id') == $cohort['id']) ? 'selected' : ''; ?>><?php echo $cohort['name']; ?></option>
                                        <?php }
                                    } ?>
                                </select>
                                <span class="text-danger"><?php echo form_error('cohort_id'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Module</label><small class="req"> *</small>
                                <select name="level_module_id" id="level_module_id" class="form-control" required>
                                    <option value="">-- Select Cohort First --</option>
                                </select>
                                <span class="text-danger"><?php echo form_error('level_module_id'); ?></span>
                            </div>

                            <div class="form-group">
                                <label>Academic Year</label><small class="req"> *</small>
                                <input id="academic_year" name="academic_year" type="number" class="form-control" min="2000" max="2099" value="<?php echo set_value('academic_year', date('Y')); ?>" required />
                                <span class="text-danger"><?php echo form_error('academic_year'); ?></span>
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
                                    <input type="checkbox" name="is_primary" value="1" <?php echo (set_value('is_primary', '1') == '1') ? 'checked' : ''; ?> /> Primary Lecturer
                                </label>
                            </div>

                        </div><!-- /.box-body -->
                        <div class="box-footer">
                            <button type="submit" class="btn btn-info pull-right">Allocate Lecturer</button>
                        </div>
                    </form>
                </div>
            </div><!--/.col -->
        </div>
    </section><!-- /.content -->
</div><!-- /.content-wrapper -->

<script type="text/javascript">
var base_url = '<?php echo base_url(); ?>';
$(document).ready(function() {
    $('#cohort_id').on('change', function() {
        var selectedOption = $(this).find('option:selected');
        var levelId = selectedOption.data('level-id');
        var moduleSelect = $('#level_module_id');

        // Reset module dropdown
        moduleSelect.html('<option value="">-- Loading Modules... --</option>');

        if (levelId) {
            $.ajax({
                url: base_url + 'admin/tvet/ajax_get_modules/' + levelId,
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    moduleSelect.html('<option value="">-- Select Module --</option>');
                    if (data && data.length > 0) {
                        $.each(data, function(index, module) {
                            moduleSelect.append('<option value="' + module.id + '">' + module.module_code + ' - ' + module.module_name + '</option>');
                        });
                    } else {
                        moduleSelect.html('<option value="">-- No Modules Found --</option>');
                    }
                },
                error: function() {
                    moduleSelect.html('<option value="">-- Error Loading Modules --</option>');
                }
            });
        } else {
            moduleSelect.html('<option value="">-- Select Cohort First --</option>');
        }
    });
});
</script>
