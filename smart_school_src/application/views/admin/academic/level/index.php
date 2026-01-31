<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-layer-group"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Level List (N1-N6, NCV L2-L4)</h3>
                <div class="box-tools pull-right">
                    <?php if ($this->rbac->hasPrivilege('academic_levels', 'can_add')): ?>
                    <a href="<?php echo base_url('admin/academic/level_add'); ?>" class="btn btn-primary btn-sm">
                        <i class="fa fa-plus"></i> Add Level
                    </a>
                    <?php endif; ?>
                </div>
            </div>
            <div class="box-body">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover" id="levelTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Code</th>
                                <th>Name</th>
                                <th>NQF Level</th>
                                <th>Order</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($levels)): ?>
                            <?php $i = 1; foreach ($levels as $l): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><strong><?php echo htmlspecialchars($l->code); ?></strong></td>
                                <td><?php echo htmlspecialchars($l->name); ?></td>
                                <td><?php echo $l->nqf_level ? 'NQF ' . $l->nqf_level : '-'; ?></td>
                                <td><?php echo $l->sequence_order; ?></td>
                                <td>
                                    <?php if ($l->is_active): ?>
                                    <span class="label label-success">Active</span>
                                    <?php else: ?>
                                    <span class="label label-default">Inactive</span>
                                    <?php endif; ?>
                                </td>
                                <td class="text-center">
                                    <?php if ($this->rbac->hasPrivilege('academic_levels', 'can_edit')): ?>
                                    <a href="<?php echo base_url('admin/academic/level_edit/' . $l->id); ?>"
                                       class="btn btn-primary btn-xs" title="Edit">
                                        <i class="fa fa-edit"></i>
                                    </a>
                                    <?php endif; ?>
                                    <?php if ($this->rbac->hasPrivilege('academic_levels', 'can_delete')): ?>
                                    <a href="<?php echo base_url('admin/academic/level_delete/' . $l->id); ?>"
                                       class="btn btn-danger btn-xs" title="Delete"
                                       onclick="return confirm('Are you sure you want to delete this level?');">
                                        <i class="fa fa-trash"></i>
                                    </a>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php else: ?>
                            <tr>
                                <td colspan="8" class="text-center">No levels found</td>
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
        if ($('#levelTable').length) {
            $('#levelTable').DataTable({
                "ordering": true,
                "pageLength": 25,
                "order": [[4, 'asc']]
            });
        }
    } catch(e) { console.log(e); }
});
</script>
