<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-link"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Subject-Level Mappings (Which subjects at which levels)</h3>
                <div class="box-tools pull-right">
                    <?php if ($this->rbac->hasPrivilege('academic_subjects', 'can_add')): ?>
                    <a href="<?php echo base_url('admin/academic/subject_level_add'); ?>" class="btn btn-primary btn-sm">
                        <i class="fa fa-plus"></i> Add Mapping
                    </a>
                    <?php endif; ?>
                </div>
            </div>
            <div class="box-body">
                <div class="callout callout-info">
                    <h4>Subject-Level Mapping</h4>
                    <p>Map subjects to the levels at which they are offered. For example, Mathematics can be offered at N1, N2, N3, N4, N5, and N6.</p>
                </div>

                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover" id="mappingTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Programme</th>
                                <th>Subject</th>
                                <th>Level</th>
                                <th>NQF</th>
                                <th>Syllabus Code</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($mappings)): ?>
                            <?php $i = 1; foreach ($mappings as $m): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><span class="label label-info"><?php echo htmlspecialchars($m->programme_name); ?></span></td>
                                <td>
                                    <strong><?php echo htmlspecialchars($m->subject_name); ?></strong>
                                    <small class="text-muted">(<?php echo $m->subject_code; ?>)</small>
                                </td>
                                <td>
                                    <span class="label label-primary"><?php echo htmlspecialchars($m->level_code); ?></span>
                                    <?php echo htmlspecialchars($m->level_name); ?>
                                </td>
                                <td><?php echo $m->nqf_level ? 'NQF ' . $m->nqf_level : '-'; ?></td>
                                <td><?php echo $m->subject_code_full ?: '-'; ?></td>
                                <td>
                                    <?php if ($m->is_active): ?>
                                    <span class="label label-success">Active</span>
                                    <?php else: ?>
                                    <span class="label label-default">Inactive</span>
                                    <?php endif; ?>
                                </td>
                                <td class="text-center">
                                    <?php if ($this->rbac->hasPrivilege('academic_subjects', 'can_delete')): ?>
                                    <a href="<?php echo base_url('admin/academic/subject_level_delete/' . $m->id); ?>"
                                       class="btn btn-danger btn-xs" title="Delete"
                                       onclick="return confirm('Are you sure you want to delete this mapping?');">
                                        <i class="fa fa-trash"></i>
                                    </a>
                                    <?php endif; ?>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php else: ?>
                            <tr>
                                <td colspan="8" class="text-center">No mappings found. <a href="<?php echo base_url('admin/academic/subject_level_add'); ?>">Create one now</a></td>
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
        if ($('#mappingTable').length) {
            $('#mappingTable').DataTable({
                "ordering": true,
                "pageLength": 25,
                "order": [[1, 'asc'], [2, 'asc'], [3, 'asc']]
            });
        }
    } catch(e) { console.log(e); }
});
</script>
