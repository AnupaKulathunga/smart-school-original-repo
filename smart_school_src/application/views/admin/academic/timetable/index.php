<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-calendar-alt"></i> <?php echo $title; ?></h1>
    </section>
    <section class="content">
        <?php echo $this->session->flashdata('msg'); ?>

        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title">Class Timetable</h3>
            </div>
            <div class="box-body">
                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-md-4">
                        <label>Select Class</label>
                        <select class="form-control select2" id="timetable_class">
                            <option value="">-- Select Class --</option>
                            <?php foreach ($classes as $c): ?>
                            <option value="<?php echo $c->id; ?>">
                                <?php echo htmlspecialchars($c->class_code . ' - ' . $c->subject_name . ' ' . $c->level_code); ?>
                            </option>
                            <?php endforeach; ?>
                        </select>
                    </div>
                </div>

                <div id="timetable_view" style="display:none;">
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Time</th>
                                    <th>Monday</th>
                                    <th>Tuesday</th>
                                    <th>Wednesday</th>
                                    <th>Thursday</th>
                                    <th>Friday</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>08:00 - 09:00</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>09:00 - 10:00</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>10:00 - 11:00</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>11:00 - 12:00</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>12:00 - 13:00</td>
                                    <td colspan="5" class="text-center bg-warning">Lunch Break</td>
                                </tr>
                                <tr>
                                    <td>13:00 - 14:00</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>14:00 - 15:00</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>15:00 - 16:00</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<script>
$('#timetable_class').change(function() {
    if ($(this).val()) {
        $('#timetable_view').show();
    } else {
        $('#timetable_view').hide();
    }
});
</script>
