<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-university"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Programme List (NATED, NCV, etc.)</h3>
                <div class="box-tools pull-right">
                    <?php if ($this->rbac->hasPrivilege('academic_programmes', 'can_add')): ?>
                    <a href="<?php echo base_url('admin/academic/programme_add'); ?>" class="btn btn-primary btn-sm">
                        <i class="fa fa-plus"></i> Add Programme
                    </a>
                    <?php endif; ?>
                </div>
            </div>
            <div class="box-body">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover" id="programmeTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Code</th>
                                <th>Name</th>
                                <th>Duration</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($programmes)): ?>
                            <?php $i = 1; foreach ($programmes as $p): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><strong><?php echo htmlspecialchars($p->code); ?></strong></td>
                                <td><?php echo htmlspecialchars($p->name); ?></td>
                                <td><span class="label label-info"><?php echo $p->duration_years; ?> Years</span></td>
                                <td><?php echo htmlspecialchars(substr($p->description ?: '-', 0, 100)); ?></td>
                                <td>
                                    <?php if ($p->is_active): ?>
                                    <span class="label label-success">Active</span>
                                    <?php else: ?>
                                    <span class="label label-default">Inactive</span>
                                    <?php endif; ?>
                                </td>
                                <td class="text-center">
                                    <?php if ($this->rbac->hasPrivilege('academic_programmes', 'can_edit')): ?>
                                    <a href="<?php echo base_url('admin/academic/programme_edit/' . $p->id); ?>"
                                       class="btn btn-primary btn-xs" title="Edit">
                                        <i class="fa fa-edit"></i>
                                    </a>
                                    <?php endif; ?>
                                    <?php if ($this->rbac->hasPrivilege('academic_programmes', 'can_delete')): ?>
                                    <a href="<?php echo base_url('admin/academic/programme_delete/' . $p->id); ?>"
                                       class="btn btn-danger btn-xs" title="Delete"
                                       onclick="return confirm('Are you sure you want to delete this programme?');">
                                        <i class="fa fa-trash"></i>
                                    </a>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php else: ?>
                            <tr>
                                <td colspan="7" class="text-center">No programmes found</td>
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
        if ($('#programmeTable').length) {
            $('#programmeTable').DataTable({
                "ordering": true,
                "pageLength": 25
            });
        }
    } catch(e) { console.log(e); }
});
</script>
