<div class="content-wrapper">
    <section class="content-header">
        <h1>
            <i class="fa fa-download"></i> <?php //echo $this->lang->line('download_center'); ?></h1>
    </section>
    <!-- Main content -->
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header ptbnull">
                        <h3 class="box-title titlefix"><?php echo $this->lang->line("content_list"); ?></h3>
                        <div class="box-tools pull-right">
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="row pb10">
                            <div class="col-lg-3 col-md-4 col-sm-6 col-xs-12">
                                <select id="content_type_filter" class="form-control input-sm">
                                    <option value=""><?php echo $this->lang->line('all'); ?> <?php echo $this->lang->line('content_type'); ?></option>
                                    <?php if(isset($content_types) && !empty($content_types)) foreach ($content_types as $ct) { ?>
                                        <option value="<?php echo $ct->id; ?>"><?php echo $ct->name; ?></option>
                                    <?php } ?>
                                </select>
                            </div>
                            <div class="col-lg-3 col-md-4 col-sm-6 col-xs-12">
                                <select id="subject_filter" class="form-control input-sm">
                                    <option value=""><?php echo $this->lang->line('all'); ?> <?php echo $this->lang->line('subjects'); ?></option>
                                    <?php if(isset($subjects) && !empty($subjects)) foreach ($subjects as $subject) { ?>
                                        <option value="<?php echo $subject['id']; ?>"><?php echo $subject['name']; ?> (<?php echo $subject['code']; ?>)</option>
                                    <?php } ?>
                                </select>
                            </div>
                        </div>
                        <div class="table-responsive mailbox-messages overflow-visible-lg">
                            <div class="download_label"><?php echo $this->lang->line("content_list"); ?></div>
                                          <div class="table-responsive mailbox-messages overflow-visible">
                                 <table class="table table-striped table-bordered table-hover content-list" data-export-title="<?php echo $this->lang->line('content_list'); ?>">
                                <thead>
                                    <tr>
                                        <th><?php echo $this->lang->line('title'); ?></th>
                                        <th><?php echo $this->lang->line('content_type'); ?></th>
                                        <th><?php echo $this->lang->line('subject'); ?></th>
                                        <th><?php echo $this->lang->line('share_date'); ?></th>
                                        <th><?php echo $this->lang->line('valid_upto'); ?></th>
                                        <th><?php echo $this->lang->line('shared_by'); ?></th>
                                        <th class="pull-right noExport"><?php echo $this->lang->line('action'); ?></th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table><!-- /.table -->
                        </div><!-- /.mail-box-messages -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
            </div>
        </div>
    </section>
</div>

<script>
    ( function ( $ ) {
    'use strict';
    $(document).ready(function () {
        var subject_id = '';
        var content_type_id = '';
        var contentTable = null;

        function loadContentList() {
            // Destroy existing DataTable if it exists
            if ($.fn.DataTable.isDataTable('.content-list')) {
                $('.content-list').DataTable().destroy();
            }

            // Initialize DataTable with function-based data for dynamic params
            contentTable = $('.content-list').DataTable({
                dom: '<"top"f><Bl>r<t>ip',
                lengthMenu: [[100, -1], [100, "All"]],
                buttons: [
                    {
                        extend: 'copy',
                        text: '<i class="fa fa-files-o"></i>',
                        titleAttr: 'Copy',
                        className: "btn-copy",
                        title: $('.content-list').data("exportTitle"),
                        exportOptions: {
                            columns: ["thead th:not(.noExport)"]
                        }
                    },
                    {
                        extend: 'excel',
                        text: '<i class="fa fa-file-excel-o"></i>',
                        titleAttr: 'Excel',
                        className: "btn-excel",
                        title: $('.content-list').data("exportTitle"),
                        exportOptions: {
                            columns: ["thead th:not(.noExport)"]
                        }
                    },
                    {
                        extend: 'csv',
                        text: '<i class="fa fa-file-text-o"></i>',
                        titleAttr: 'CSV',
                        className: "btn-csv",
                        title: $('.content-list').data("exportTitle"),
                        exportOptions: {
                            columns: ["thead th:not(.noExport)"]
                        }
                    },
                    {
                        extend: 'pdf',
                        text: '<i class="fa fa-file-pdf-o"></i>',
                        titleAttr: 'PDF',
                        className: "btn-pdf",
                        title: $('.content-list').data("exportTitle"),
                        exportOptions: {
                            columns: ["thead th:not(.noExport)"]
                        }
                    },
                    {
                        extend: 'print',
                        text: '<i class="fa fa-print"></i>',
                        titleAttr: 'Print',
                        className: "btn-print",
                        title: $('.content-list').data("exportTitle"),
                        exportOptions: {
                            columns: ["thead th:not(.noExport)"]
                        }
                    }
                ],
                "language": {
                    processing: '<i class="fa fa-spinner fa-spin fa-1x fa-fw"></i><span class="sr-only">Loading...</span> ',
                    sLengthMenu: "_MENU_"
                },
                "pageLength": 100,
                "searching": true,
                "aaSorting": [],
                "aoColumnDefs": [
                    { "bSortable": true, "aTargets": [1,2,3,4,5], 'sClass': 'dt-body-left', "sWidth": "12%" },
                    { "bSortable": false, "aTargets": [-1], 'sClass': 'dt-body-right' }
                ],
                "processing": true,
                "serverSide": true,
                "ajax": {
                    "url": baseurl + 'user/content/getsharelist',
                    "type": "POST",
                    "data": function(d) {
                        // Add custom filter parameters
                        d.subject_id = subject_id;
                        d.content_type_id = content_type_id;
                    }
                }
            });
        }

        // Initial load
        loadContentList();

        // Content type filter change
        $(document).on('change', '#content_type_filter', function() {
            content_type_id = $(this).val();
            if (contentTable) {
                contentTable.ajax.reload();
            }
        });

        // Subject filter change
        $(document).on('change', '#subject_filter', function() {
            subject_id = $(this).val();
            if (contentTable) {
                contentTable.ajax.reload();
            }
        });
    });
} ( jQuery ) )

</script>
