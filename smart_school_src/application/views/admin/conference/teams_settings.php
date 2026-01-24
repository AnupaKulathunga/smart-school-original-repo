<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-windows"></i> <small class="pull-right">
                <a type="button" class="btn btn-primary btn-sm"><?php echo $this->lang->line('setting') ?></a>
            </small>
        </h1>
    </section>
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-windows"></i> Microsoft Teams <?php echo $this->lang->line('setting') ?></h3>
                    </div>
                    <form id="teams_form" action="<?php echo site_url('admin/conference/teams_settings'); ?>" name="teamsform" class="form-horizontal form-label-left" method="post" accept-charset="utf-8">
                        <div class="box-body">
                            <?php
                              if ($this->session->flashdata('msg')) {
                                ?>
                                <?php echo $this->session->flashdata('msg'); $this->session->unset_userdata('msg'); ?>
                            <?php
                             }
                            ?>
                            <div class="row">
<div class="col-lg-7 col-md-7 col-sm-6">

                            <?php echo $this->customlib->getCSRF(); ?>
                            <div class="form-group">
                                <label class="control-label col-md-4 col-sm-4 col-xs-12">
                                    Tenant ID<small class="req"> *</small>
                                </label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <input name="teams_tenant_id" placeholder="Azure AD Tenant ID" type="text" class="form-control col-md-7 col-xs-12" value="<?php echo isset($teams_settings->teams_tenant_id) ? $teams_settings->teams_tenant_id : ''; ?>" />
                                    <span class="text-danger"><?php echo form_error('teams_tenant_id'); ?></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-4 col-sm-4 col-xs-12">
                                    Client ID<small class="req"> *</small>
                                </label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <input name="teams_client_id" placeholder="Application (Client) ID" type="text" class="form-control col-md-7 col-xs-12" value="<?php echo isset($teams_settings->teams_client_id) ? $teams_settings->teams_client_id : ''; ?>" />
                                    <span class="text-danger"><?php echo form_error('teams_client_id'); ?></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-4 col-sm-4 col-xs-12">
                                    Client Secret<small class="req"> *</small>
                                </label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <input name="teams_client_secret" placeholder="Client Secret Value" type="password" class="form-control col-md-7 col-xs-12" value="<?php echo isset($teams_settings->teams_client_secret) ? $teams_settings->teams_client_secret : ''; ?>" />
                                    <span class="text-danger"><?php echo form_error('teams_client_secret'); ?></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-md-4 col-sm-4 col-xs-12">
                                    Organizer User ID<small class="req"> *</small>
                                </label>
                                <div class="col-md-8 col-sm-8 col-xs-12">
                                    <input name="teams_organizer_id" placeholder="Microsoft 365 User Object ID" type="text" class="form-control col-md-7 col-xs-12" value="<?php echo isset($teams_settings->teams_organizer_id) ? $teams_settings->teams_organizer_id : ''; ?>" />
                                    <small class="text-muted">The Object ID of the user who will host the meetings</small>
                                    <span class="text-danger"><?php echo form_error('teams_organizer_id'); ?></span>
                                </div>
                            </div>

</div>
<div class="col-lg-5 col-md-5 col-sm-6">
    <div class="ps-lg-3 pt-sm-3">
        <div class="mb10"><i class="fa fa-windows" style="font-size:64px;color:#6264A7;"></i> <span style="font-size:24px;font-weight:bold;color:#6264A7;vertical-align:middle;margin-left:10px;">Microsoft Teams</span></div>
        <p><?php echo $this->lang->line('teams_setup_info'); ?></p>
        <p class="pb0 mb0"><strong>Required Azure AD Permissions:</strong></p>
        <ul style="padding-left:20px;margin-top:5px;">
            <li>OnlineMeetings.ReadWrite.All</li>
            <li>User.Read.All</li>
        </ul>
        <p style="margin-top:10px;">To register an Azure AD application: <a class="display-inline" href="https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/ApplicationsListBlade" target="_blank"><?php echo $this->lang->line('click_here'); ?></a></p>
    </div>
</div>
                            </div>
                        </div>
                        <div class="box-footer">
                            <div class="col-md-6 col-sm-6 col-xs-6 col-md-offset-3">
                                <?php
                                if ($this->rbac->hasPrivilege('setting', 'can_edit')) {
                                    ?>
                                    <button type="submit" class="btn btn-info pull-left"><?php echo $this->lang->line('save'); ?></button>
                                    <?php
                                }
                                ?>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</div>
