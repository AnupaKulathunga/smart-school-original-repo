<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-wheelchair"></i> <?php echo $this->lang->line('student_information'); ?> <small><?php echo $this->lang->line('disability_types'); ?></small></h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <?php
            if ($this->rbac->hasPrivilege('disability_types', 'can_add') || $this->rbac->hasPrivilege('disability_types', 'can_edit')) {
                ?>
                <div class="col-md-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><?php echo $this->lang->line('edit_disability_type'); ?></h3>
                        </div>
                        <form action="<?php echo site_url("disabilitytype/edit/" . $id) ?>"  id="employeeform" name="employeeform" method="post" accept-charset="utf-8">
                            <div class="box-body">
                                <?php echo $this->customlib->getCSRF(); ?>
                                <div class="form-group">
                                    <label for="name"><?php echo $this->lang->line('disability_type'); ?></label><small class="req"> *</small>
                                    <input autofocus="" id="name" name="name" placeholder="" type="text" class="form-control"  value="<?php echo set_value('name', $type['name']); ?>" />
                                    <span class="text-danger"><?php echo form_error('name'); ?></span>
                                </div>
                                <div class="form-group">
                                    <label for="description"><?php echo $this->lang->line('description'); ?></label>
                                    <textarea id="description" name="description" class="form-control" rows="2"><?php echo set_value('description', $type['description']); ?></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="default_extra_time_percent"><?php echo $this->lang->line('default_extra_time'); ?> (%)</label><small class="req"> *</small>
                                    <input id="default_extra_time_percent" name="default_extra_time_percent" type="number" class="form-control" value="<?php echo set_value('default_extra_time_percent', $type['default_extra_time_percent']); ?>" min="0" max="200" />
                                    <small class="text-muted"><?php echo $this->lang->line('extra_time_help'); ?></small>
                                    <span class="text-danger"><?php echo form_error('default_extra_time_percent'); ?></span>
                                </div>
                            </div>
                            <div class="box-footer">
                                <button type="submit" class="btn btn-info pull-right"><?php echo $this->lang->line('save'); ?></button>
                            </div>
                        </form>
                    </div>
                </div>
            <?php } ?>
            <div class="col-md-<?php
            if ($this->rbac->hasPrivilege('disability_types', 'can_add') || $this->rbac->hasPrivilege('disability_types', 'can_edit')) {
                echo "8";
            } else {
                echo "12";
            }
            ?>">
                <div class="box box-primary">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix"><?php echo $this->lang->line('disability_type_list'); ?></h3>
                    </div>
                    <div class="box-body">
                        <div class="download_label"><?php echo $this->lang->line('disability_type_list'); ?></div>
                        <div class="mailbox-messages table-responsive overflow-visible">
                            <table class="table table-striped table-bordered table-hover example">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('disability_type'); ?></th>
                                        <th><?php echo $this->lang->line('description'); ?></th>
                                        <th><?php echo $this->lang->line('default_extra_time'); ?> (%)</th>
                                        <th class="text-right noExport"><?php echo $this->lang->line('action'); ?></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php
                                    foreach ($typelist as $t) {
                                        ?>
                                        <tr>
                                            <td class="mailbox-name"><?php echo $t['name'] ?></td>
                                            <td class="mailbox-name"><?php echo $t['description'] ?></td>
                                            <td class="mailbox-name"><?php echo $t['default_extra_time_percent'] ?>%</td>
                                            <td align="right" class="mailbox-date">
                                                <?php
                                                if ($this->rbac->hasPrivilege('disability_types', 'can_edit')) {
                                                    ?>
                                                    <a href="<?php echo base_url(); ?>disabilitytype/edit/<?php echo $t['id'] ?>" class="btn btn-default btn-xs"  data-toggle="tooltip" title="<?php echo $this->lang->line('edit'); ?>">
                                                        <i class="fa fa-pencil"></i>
                                                    </a>
                                                <?php } ?>
                                                <?php
                                                if ($this->rbac->hasPrivilege('disability_types', 'can_delete')) {
                                                    ?>
                                                    <a href="<?php echo base_url(); ?>disabilitytype/delete/<?php echo $t['id'] ?>"class="btn btn-default btn-xs"  data-toggle="tooltip" title="<?php echo $this->lang->line('delete'); ?>" onclick="return confirm('<?php echo $this->lang->line('delete_confirm') ?>');">
                                                        <i class="fa fa-remove"></i>
                                                    </a>
                                                <?php } ?>
                                            </td>
                                        </tr>
                                        <?php
                                    }
                                    ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
