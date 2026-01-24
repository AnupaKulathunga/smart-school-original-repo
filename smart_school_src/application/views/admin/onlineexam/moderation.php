<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-gavel"></i> <?php echo $this->lang->line('exam_moderation'); ?></h3>
                    </div>
                    <div class="box-body">
                        <?php if (empty($pending_exams)) { ?>
                            <div class="alert alert-info"><?php echo $this->lang->line('no_record_found'); ?></div>
                        <?php } else { ?>
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('exam'); ?></th>
                                        <th><?php echo $this->lang->line('description'); ?></th>
                                        <th><?php echo $this->lang->line('duration'); ?></th>
                                        <th><?php echo $this->lang->line('exam_from'); ?></th>
                                        <th><?php echo $this->lang->line('exam_to'); ?></th>
                                        <th class="text-right"><?php echo $this->lang->line('action'); ?></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php foreach ($pending_exams as $exam) { ?>
                                    <tr>
                                        <td><?php echo $exam->exam; ?></td>
                                        <td><?php echo $exam->description; ?></td>
                                        <td><?php echo $exam->duration; ?></td>
                                        <td><?php echo $this->customlib->dateyyyymmddToDateTimeformat($exam->exam_from, false); ?></td>
                                        <td><?php echo $this->customlib->dateyyyymmddToDateTimeformat($exam->exam_to, false); ?></td>
                                        <td class="text-right">
                                            <a href="<?php echo site_url('admin/onlineexam/moderation_review/' . $exam->id); ?>" class="btn btn-primary btn-xs" data-toggle="tooltip" title="<?php echo $this->lang->line('review'); ?>">
                                                <i class="fa fa-search"></i> <?php echo $this->lang->line('review'); ?>
                                            </a>
                                        </td>
                                    </tr>
                                    <?php } ?>
                                </tbody>
                            </table>
                        </div>
                        <?php } ?>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
