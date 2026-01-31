<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-check-double"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Assessments Pending Moderation</h3>
            </div>
            <div class="box-body">
                <div class="callout callout-info">
                    <h4>Moderation Workflow</h4>
                    <p>Assessments are submitted for pre-moderation before being published to students. After marking, they can be submitted for post-moderation.</p>
                </div>

                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover" id="moderationTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Assessment</th>
                                <th>Class</th>
                                <th>Type</th>
                                <th>Created By</th>
                                <th>Status</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (!empty($pending)): ?>
                            <?php $i = 1; foreach ($pending as $a): ?>
                            <tr>
                                <td><?php echo $i++; ?></td>
                                <td><strong><?php echo htmlspecialchars($a->title); ?></strong></td>
                                <td><?php echo htmlspecialchars($a->class_code); ?></td>
                                <td><span class="label label-default"><?php echo $a->assessment_type; ?></span></td>
                                <td><?php echo htmlspecialchars($a->creator_name . ' ' . $a->creator_surname); ?></td>
                                <td><span class="label label-warning"><?php echo $a->moderation_status; ?></span></td>
                                <td class="text-center">
                                    <button class="btn btn-success btn-xs" title="Approve">
                                        <i class="fa fa-check"></i> Approve
                                    </button>
                                    <button class="btn btn-danger btn-xs" title="Reject">
                                        <i class="fa fa-times"></i> Reject
                                    </button>
                                </td>
                            </tr>
                            <?php endforeach; ?>
                            <?php else: ?>
                            <tr>
                                <td colspan="7" class="text-center">No assessments pending moderation</td>
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
        if ($('#moderationTable').length) {
            $('#moderationTable').DataTable({
                "ordering": true,
                "pageLength": 25
            });
        }
    } catch(e) { console.log(e); }
});
</script>
