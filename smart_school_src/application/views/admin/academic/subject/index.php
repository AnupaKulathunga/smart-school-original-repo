<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-book"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Subject List (Mathematics, Engineering Science, etc.)</h3>
                <div class="box-tools pull-right">
                    <?php if ($this->rbac->hasPrivilege('academic_subjects', 'can_add')): ?>
                    <a href="<?php echo base_url('admin/academic/subject_add'); ?>" class="btn btn-primary btn-sm">
                        <i class="fa fa-plus"></i> Add Subject
                    </a>
                    <?php endif; ?>
                </div>
            </div>
            <div class="box-body">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover" id="subjectTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Code</th>
                                <th>Name</th>
                                <th>Programme</th>
                                <th>Credits</th>
                                <th>Type</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($subjects)): ?>
                            <?php $i = 1; foreach ($subjects as $s): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><strong><?php echo htmlspecialchars($s->code); ?></strong></td>
                                <td><?php echo htmlspecialchars($s->name); ?></td>
                                <td><span class="label label-info"><?php echo htmlspecialchars($s->programme_name); ?></span></td>
                                <td><?php echo $s->credits; ?></td>
                                <td>
                                    <?php if ($s->is_core): ?>
                                    <span class="label label-primary">Core</span>
                                    <?php else: ?>
                                    <span class="label label-default">Elective</span>
                                    <?php endif; ?>
                                </td>
                                <td>
                                    <?php if ($s->is_active): ?>
                                    <span class="label label-success">Active</span>
                                    <?php else: ?>
                                    <span class="label label-default">Inactive</span>
                                    <?php endif; ?>
                                </td>
                                <td class="text-center">
                                    <?php if ($this->rbac->hasPrivilege('academic_subjects', 'can_edit')): ?>
                                    <a href="<?php echo base_url('admin/academic/subject_edit/' . $s->id); ?>"
                                       class="btn btn-primary btn-xs" title="Edit">
                                        <i class="fa fa-edit"></i>
                                    </a>
                                    <?php endif; ?>
                                    <?php if ($this->rbac->hasPrivilege('academic_subjects', 'can_delete')): ?>
                                    <a href="<?php echo base_url('admin/academic/subject_delete/' . $s->id); ?>"
                                       class="btn btn-danger btn-xs" title="Delete"
                                       onclick="return confirm('Are you sure you want to delete this subject?');">
                                        <i class="fa fa-trash"></i>
                                    </a>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php else: ?>
                            <tr>
                                <td colspan="8" class="text-center">No subjects found</td>
                            </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</div>

<script>
$(document).ready(function() {
    try {
        if ($('#subjectTable').length) {
            $('#subjectTable').DataTable({
                "ordering": true,
                "pageLength": 25
            });
        }
    } catch(e) { console.log(e); }
});
</script>
