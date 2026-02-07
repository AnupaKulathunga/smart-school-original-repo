<style type="text/css">
    .select2-container--open {z-index: 9001;}
</style>
<div class="row">
<input type="hidden" name="id" value="<?php echo set_value('id', $videotutoriallist->id); ?>" >
<div class="col-lg-12 col-md-12 col-sm-12">
    <div class="row">
        <div class="col-sm-6">
            <?php
            // TVET: Single class selector (no section needed)
            $this->load->view('admin/_partials/class_selector', [
                'selected_class_id' => isset($classid['class_id']) ? $classid['class_id'] : '',
                'classlist' => $classlist,
                'id' => 'edit_class_id',
                'name' => 'class_id'
            ]);
            ?>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-6">
            <div class="form-group">
                <label><?php echo $this->lang->line('title'); ?></label><small class="req"> *</small>
                <input autofocus="" id="title" name="title" placeholder="" type="text" class="form-control"  value="<?php echo set_value('title',$videotutoriallist->title); ?>" />
                <span class="text-danger"><?php echo form_error('title'); ?></span>
            </div>
        </div>

        <div class="col-sm-6">
            <div class="form-group">
                <label><?php echo $this->lang->line('video_link'); ?></label><small class="req"> *</small>
                <input autofocus="" id="video_link" name="video_link" placeholder="" type="text" class="form-control"  value="<?php echo set_value('video_link',$videotutoriallist->video_link); ?>" />
                <span class="text-danger"><?php echo form_error('video_link'); ?></span>
            </div>
        </div>
    </div>
   
    <div class="row">
        <div class="col-sm-12">
          <div class="form-group">
                <label><?php echo $this->lang->line('description'); ?></label>
                <textarea class="form-control" id="description" name="description" placeholder="" rows="3"><?php echo set_value('description',$videotutoriallist->description); ?></textarea>
                <span class="text-danger"><?php echo form_error('description'); ?></span>
            </div>
        </div>
    </div>
    </div><!--./row-->
</div><!--./col-md-12-->
<script>
  $(function () {
    //Initialize Select2 Elements
    $('.select2').select2()
  })
</script>