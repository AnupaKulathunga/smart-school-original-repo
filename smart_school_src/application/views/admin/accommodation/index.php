<div class="content-wrapper">
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title"><i class="fa fa-wheelchair"></i> <?php echo $this->lang->line('student_accommodation'); ?></h3>
                        <?php if ($this->rbac->hasPrivilege('student_accommodation', 'can_add')) { ?>
                        <button class="btn btn-primary btn-sm pull-right" data-toggle="modal" data-target="#addAccommodationModal"><i class="fa fa-plus"></i> <?php echo $this->lang->line('add'); ?></button>
                        <?php } ?>
                    </div>
                    <div class="box-body">
                        <?php if ($this->session->flashdata('msg')) { echo $this->session->flashdata('msg'); } ?>
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover example">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('student_name'); ?></th>
                                        <th><?php echo $this->lang->line('class'); ?></th>
                                        <th><?php echo $this->lang->line('type'); ?></th>
                                        <th><?php echo $this->lang->line('extra_time'); ?> (%)</th>
                                        <th><?php echo $this->lang->line('note'); ?></th>
                                        <th><?php echo $this->lang->line('status'); ?></th>
                                        <th class="text-right noExport"><?php echo $this->lang->line('action'); ?></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <?php if (!empty($accommodations)) { foreach ($accommodations as $acc) { ?>
                                    <tr>
                                        <td><?php echo $acc['firstname'] . ' ' . $acc['lastname']; ?></td>
                                        <td><?php echo isset($acc['class']) ? $acc['class'] . ' (' . $acc['section'] . ')' : ''; ?></td>
                                        <td><?php echo ucfirst(str_replace('_', ' ', $acc['accommodation_type'])); ?></td>
                                        <td><?php echo $acc['extra_time_percent']; ?>%</td>
                                        <td><?php echo $acc['notes']; ?></td>
                                        <td>
                                            <?php if ($acc['is_active']) { ?>
                                                <span class="label label-success"><?php echo $this->lang->line('active'); ?></span>
                                            <?php } else { ?>
                                                <span class="label label-default"><?php echo $this->lang->line('inactive'); ?></span>
                                            <?php } ?>
                                        </td>
                                        <td class="text-right">
                                            <?php if ($this->rbac->hasPrivilege('student_accommodation', 'can_delete')) { ?>
                                            <a href="<?php echo site_url('admin/accommodation/delete/' . $acc['id']); ?>" class="btn btn-danger btn-xs" onclick="return confirm('<?php echo $this->lang->line('delete_confirm'); ?>')" data-toggle="tooltip" title="<?php echo $this->lang->line('delete'); ?>"><i class="fa fa-trash-o"></i></a>
                                            <?php } ?>
                                        </td>
                                    </tr>
                                    <?php } } ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- Add Accommodation Modal -->
<div class="modal fade" id="addAccommodationModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title"><?php echo $this->lang->line('add'); ?> <?php echo $this->lang->line('student_accommodation'); ?></h4>
            </div>
            <form id="accommodation_form">
                <div class="modal-body">
                    <div class="form-group">
                        <label><?php echo $this->lang->line('student'); ?></label> <small class="req">*</small>
                        <input type="text" id="student_search" class="form-control" placeholder="<?php echo $this->lang->line('search_by_keyword'); ?>">
                        <input type="hidden" name="student_session_id" id="student_session_id">
                        <div id="student_search_results" class="list-group" style="position:absolute;z-index:1000;max-height:200px;overflow-y:auto;display:none;"></div>
                        <span class="text-danger" id="err_student_session_id"></span>
                    </div>
                    <div class="form-group">
                        <label><?php echo $this->lang->line('type'); ?></label> <small class="req">*</small>
                        <select name="accommodation_type" class="form-control">
                            <option value="extra_time"><?php echo $this->lang->line('extra_time'); ?></option>
                        </select>
                        <span class="text-danger" id="err_accommodation_type"></span>
                    </div>
                    <div class="form-group">
                        <label><?php echo $this->lang->line('extra_time'); ?> (%)</label> <small class="req">*</small>
                        <select name="extra_time_percent" class="form-control">
                            <option value="25">25%</option>
                            <option value="50">50%</option>
                            <option value="100">100%</option>
                        </select>
                        <span class="text-danger" id="err_extra_time_percent"></span>
                    </div>
                    <div class="form-group">
                        <label><?php echo $this->lang->line('note'); ?></label>
                        <textarea name="notes" class="form-control" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal"><?php echo $this->lang->line('close'); ?></button>
                    <button type="submit" class="btn btn-primary" id="save_accommodation"><?php echo $this->lang->line('save'); ?></button>
                </div>
            </form>
        </div>
    </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
    var base_url = '<?php echo base_url(); ?>';
    var searchTimer;

    // Student search autocomplete
    $('#student_search').on('keyup', function() {
        clearTimeout(searchTimer);
        var keyword = $(this).val();
        if (keyword.length < 2) {
            $('#student_search_results').hide();
            return;
        }
        searchTimer = setTimeout(function() {
            $.ajax({
                url: base_url + 'admin/accommodation/search_student',
                type: 'POST',
                dataType: 'json',
                data: { keyword: keyword },
                success: function(data) {
                    var html = '';
                    if (data && data.length > 0) {
                        $.each(data, function(i, item) {
                            html += '<a href="#" class="list-group-item student-result" data-id="' + item.student_session_id + '">' + item.firstname + ' ' + item.lastname + ' (' + item.admission_no + ') - ' + item.class + ' ' + item.section + '</a>';
                        });
                        $('#student_search_results').html(html).show();
                    } else {
                        $('#student_search_results').hide();
                    }
                }
            });
        }, 300);
    });

    $(document).on('click', '.student-result', function(e) {
        e.preventDefault();
        $('#student_session_id').val($(this).data('id'));
        $('#student_search').val($(this).text());
        $('#student_search_results').hide();
    });

    // Submit accommodation form
    $('#accommodation_form').on('submit', function(e) {
        e.preventDefault();
        $.ajax({
            url: base_url + 'admin/accommodation/add',
            type: 'POST',
            dataType: 'json',
            data: $(this).serialize(),
            success: function(data) {
                if (data.status == 'fail') {
                    if (data.error.student_session_id) $('#err_student_session_id').text(data.error.student_session_id);
                    if (data.error.accommodation_type) $('#err_accommodation_type').text(data.error.accommodation_type);
                    if (data.error.extra_time_percent) $('#err_extra_time_percent').text(data.error.extra_time_percent);
                } else {
                    successMsg(data.message);
                    setTimeout(function() { window.location.reload(); }, 1500);
                }
            }
        });
    });
});
</script>
