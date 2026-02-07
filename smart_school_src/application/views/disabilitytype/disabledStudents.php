<?php
$currency_symbol = $this->customlib->getSchoolCurrencyFormat();
?>
<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-wheelchair"></i> <?php echo $this->lang->line('student_information'); ?> <small><?php echo $this->lang->line('students_with_disabilities'); ?></small></h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-search"></i> <?php echo $this->lang->line('select_criteria'); ?></h3>
                    </div>
                    <div class="box-body">
                        <?php if ($this->session->flashdata('msg')) { ?>
                            <div class="alert alert-success"><?php echo $this->session->flashdata('msg');
                            $this->session->unset_userdata('msg'); ?></div>
                        <?php } ?>
                        <div class="row">
                            <div class="col-md-8">
                                <div class="row">
                                    <form role="form" action="<?php echo site_url('disabilitytype/students') ?>" method="post" class="">
                                        <?php echo $this->customlib->getCSRF(); ?>
                                        <div class="col-sm-6">
                                            <?php
                                            $this->load->view('admin/_partials/class_selector', [
                                                'selected_class_id' => isset($class_id) ? $class_id : '',
                                                'classlist' => $classlist
                                            ]);
                                            ?>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label><?php echo $this->lang->line('disability_type'); ?></label>
                                                <select id="disability_type_id" name="disability_type_id" class="form-control">
                                                    <option value=""><?php echo $this->lang->line('select'); ?></option>
                                                    <?php
                                                    foreach ($typelist as $type) { ?>
                                                        <option value="<?php echo $type['id'] ?>" <?php if (isset($disability_type_id) && $disability_type_id == $type['id']) { echo "selected=selected"; } ?>><?php echo $type['name'] ?></option>
                                                    <?php } ?>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-2">
                                            <div class="form-group">
                                                <label>&nbsp;</label>
                                                <button type="submit" name="search" value="search_filter" class="btn btn-primary btn-block checkbox-toggle"><i class="fa fa-search"></i> <?php echo $this->lang->line('search'); ?></button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="row">
                                    <form role="form" action="<?php echo site_url('disabilitytype/students') ?>" method="post" class="">
                                        <?php echo $this->customlib->getCSRF(); ?>
                                        <div class="col-sm-8">
                                            <div class="form-group">
                                                <label><?php echo $this->lang->line('search_by_keyword'); ?></label>
                                                <input type="text" name="search_text" class="form-control" placeholder="<?php echo $this->lang->line('search_by_student_name'); ?>" value="<?php echo isset($search_text) ? $search_text : ''; ?>">
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label>&nbsp;</label>
                                                <button type="submit" name="search" value="search_full" class="btn btn-primary btn-block checkbox-toggle"><i class="fa fa-search"></i></button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="box-header ptbnull"></div>
                    <?php if (isset($resultlist)) { ?>
                        <div class="nav-tabs-custom border0">
                            <ul class="nav nav-tabs">
                                <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="true"><i class="fa fa-list"></i> <?php echo $this->lang->line('list_view'); ?></a></li>
                                <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false"><i class="fa fa-newspaper-o"></i> <?php echo $this->lang->line('details_view'); ?></a></li>
                            </ul>
                            <div class="tab-content">
                                <div class="download_label"><?php echo $this->lang->line('students_with_disabilities_list'); ?></div>
                                <div class="tab-pane active table-responsive no-padding overflow-visible-lg" id="tab_1">
                                    <table class="table table-striped table-bordered table-hover example" cellspacing="0" width="100%">
                                        <thead>
                                            <tr>
                                                <th><?php echo $this->lang->line('admission_no'); ?></th>
                                                <th><?php echo $this->lang->line('student_name'); ?></th>
                                                <th><?php echo $this->lang->line('class'); ?></th>
                                                <?php if (isset($sch_setting) && !empty($sch_setting->father_name)) { ?>
                                                    <th><?php echo $this->lang->line('father_name'); ?></th>
                                                <?php } ?>
                                                <th><?php echo $this->lang->line('disability_type'); ?></th>
                                                <th><?php echo $this->lang->line('default_extra_time'); ?></th>
                                                <th><?php echo $this->lang->line('gender'); ?></th>
                                                <?php if (isset($sch_setting) && !empty($sch_setting->mobile_no)) { ?>
                                                    <th><?php echo $this->lang->line('mobile_number'); ?></th>
                                                <?php } ?>
                                                <th class="pull-right noExport"><?php echo $this->lang->line('action'); ?></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php
                                            if (!empty($resultlist)) {
                                                $show_middlename = isset($sch_setting) ? $sch_setting->middlename : 1;
                                                $show_lastname = isset($sch_setting) ? $sch_setting->lastname : 1;
                                                foreach ($resultlist as $student) { ?>
                                                    <tr>
                                                        <td><?php echo $student['admission_no']; ?></td>
                                                        <td>
                                                            <a href="<?php echo base_url(); ?>student/view/<?php echo $student['id']; ?>">
                                                                <?php echo $this->customlib->getFullName($student['firstname'], $student['middlename'], $student['lastname'], $show_middlename, $show_lastname); ?>
                                                            </a>
                                                        </td>
                                                        <td><?php echo $student['class']; ?></td>
                                                        <?php if (isset($sch_setting) && !empty($sch_setting->father_name)) { ?>
                                                            <td><?php echo $student['father_name']; ?></td>
                                                        <?php } ?>
                                                        <td>
                                                            <span data-toggle="popover" class="detail_popover label label-info" data-original-title="" title="">
                                                                <?php echo !empty($student['disability_type_name']) ? $student['disability_type_name'] : '-'; ?>
                                                            </span>
                                                            <div class="fee_detail_popover" style="display: none"><?php echo !empty($student['disability_details']) ? $student['disability_details'] : $this->lang->line('no_details'); ?></div>
                                                        </td>
                                                        <td><?php echo !empty($student['default_extra_time_percent']) ? $student['default_extra_time_percent'] . '%' : '25%'; ?></td>
                                                        <td><?php echo $this->lang->line(strtolower($student['gender'])); ?></td>
                                                        <?php if (isset($sch_setting) && !empty($sch_setting->mobile_no)) { ?>
                                                            <td><?php echo $student['mobileno']; ?></td>
                                                        <?php } ?>
                                                        <td class="pull-right">
                                                            <a href="<?php echo base_url(); ?>student/view/<?php echo $student['id'] ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="<?php echo $this->lang->line('view'); ?>">
                                                                <i class="fa fa-reorder"></i>
                                                            </a>
                                                            <?php if ($this->rbac->hasPrivilege('student', 'can_edit')) { ?>
                                                                <a href="<?php echo base_url(); ?>student/edit/<?php echo $student['id'] ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="<?php echo $this->lang->line('edit'); ?>">
                                                                    <i class="fa fa-pencil"></i>
                                                                </a>
                                                            <?php } ?>
                                                        </td>
                                                    </tr>
                                                <?php }
                                            } ?>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="tab-pane" id="tab_2">
                                    <?php if (empty($resultlist)) { ?>
                                        <div class="alert alert-info"><?php echo $this->lang->line('no_record_found'); ?></div>
                                    <?php } else {
                                        $show_middlename = isset($sch_setting) ? $sch_setting->middlename : 1;
                                        $show_lastname = isset($sch_setting) ? $sch_setting->lastname : 1;
                                        foreach ($resultlist as $student) {
                                            if (empty($student["image"])) {
                                                $image = "uploads/student_images/no_image.png";
                                            } else {
                                                $image = $student['image'];
                                            }
                                            ?>
                                            <div class="carousel-row">
                                                <div class="slide-row">
                                                    <div id="carousel-2" class="carousel slide slide-carousel" data-ride="carousel">
                                                        <div class="carousel-inner">
                                                            <div class="item active">
                                                                <a href="<?php echo base_url(); ?>student/view/<?php echo $student['id'] ?>">
                                                                    <img class="img-responsive img-thumbnail width150" alt="<?php echo $student["firstname"] . " " . $student["lastname"] ?>" src="<?php echo $this->media_storage->getImageURL($image); ?>" alt="Image">
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="slide-content">
                                                        <h4><a href="<?php echo base_url(); ?>student/view/<?php echo $student['id'] ?>"><?php echo $this->customlib->getFullName($student['firstname'], $student['middlename'], $student['lastname'], $show_middlename, $show_lastname); ?></a></h4>
                                                        <div class="row">
                                                            <div class="col-xs-6 col-md-6">
                                                                <address>
                                                                    <strong><b><?php echo $this->lang->line('class'); ?>: </b><?php echo $student['class']; ?></strong><br>
                                                                    <b><?php echo $this->lang->line('admission_no'); ?>: </b><?php echo $student['admission_no'] ?><br/>
                                                                    <b><?php echo $this->lang->line('date_of_birth'); ?>: </b>
                                                                    <?php
                                                                    if ((!empty($student['dob'])) && ($student['dob'] != null)) {
                                                                        echo date($this->customlib->getSchoolDateFormat(), $this->customlib->dateyyyymmddTodateformat($student['dob']));
                                                                    }
                                                                    ?><br>
                                                                    <b><?php echo $this->lang->line('gender'); ?>:&nbsp;</b><?php echo $this->lang->line(strtolower($student['gender'])) ?><br>
                                                                </address>
                                                            </div>
                                                            <div class="col-xs-6 col-md-6">
                                                                <b><?php echo $this->lang->line('disability_type'); ?>:&nbsp;</b>
                                                                <span class="label label-info"><?php echo !empty($student['disability_type_name']) ? $student['disability_type_name'] : '-'; ?></span><br>
                                                                <b><?php echo $this->lang->line('default_extra_time'); ?>:&nbsp;</b><?php echo !empty($student['default_extra_time_percent']) ? $student['default_extra_time_percent'] . '%' : '25%'; ?><br>
                                                                <?php if (isset($sch_setting) && !empty($sch_setting->guardian_name)) { ?>
                                                                    <b><?php echo $this->lang->line('guardian_name'); ?>:&nbsp;</b><?php echo $student['guardian_name'] ?><br>
                                                                <?php }
                                                                if (isset($sch_setting) && !empty($sch_setting->guardian_phone)) { ?>
                                                                    <b><?php echo $this->lang->line('guardian_phone'); ?>: </b> <abbr title="Phone"><i class="fa fa-phone-square"></i>&nbsp;</abbr> <?php echo $student['guardian_phone'] ?><br>
                                                                <?php } ?>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="slide-footer">
                                                        <span class="pull-right buttons">
                                                            <a href="<?php echo base_url(); ?>student/view/<?php echo $student['id'] ?>" class="btn btn-default btn-xs" data-toggle="tooltip" title="<?php echo $this->lang->line('view'); ?>">
                                                                <i class="fa fa-reorder"></i>
                                                            </a>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        <?php }
                                    } ?>
                                </div>
                            </div>
                        </div>
                    <?php } ?>
                </div>
            </div>
        </div>
    </section>
</div>
<script type="text/javascript">
    // TVET: Section selector removed - using single class selector
    $(document).ready(function () {
        $('.detail_popover').popover({
            placement: 'right',
            title: '<?php echo $this->lang->line('disability_details'); ?>',
            trigger: 'hover',
            container: 'body',
            html: true,
            content: function () {
                return $(this).closest('td').find('.fee_detail_popover').html();
            }
        });
    });
</script>
