<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Video_tutorial extends Student_Controller
{

    public function __construct()
    {
        parent::__construct();

        $this->load->library('imageResize');
    }

    public function index()
    {

        $this->session->set_userdata('top_menu', 'Downloads');
        $this->session->set_userdata('sub_menu', 'video_tutorial/index');
        // TVET: Get ALL enrolled class IDs so student sees videos from all their subjects
        $enrolled_classes = $this->customlib->getStudentEnrolledClasses();
        $class_ids = array();
        if (!empty($enrolled_classes)) {
            foreach ($enrolled_classes as $enrolment) {
                $class_ids[] = $enrolment->class_id;
            }
        }
        $data['class_ids'] = implode(',', $class_ids);
        $this->load->view('layout/student/header');
        $this->load->view('user/video_tutorial/index', $data);
        $this->load->view('layout/student/footer');
    }

    public function getPage($page)
    {
        $class_ids_str = $this->input->get('class_ids');
        $class_ids = !empty($class_ids_str) ? explode(',', $class_ids_str) : array();

        $superadmin_visible = $this->Setting_model->get();
        $superadmin_restriction = $superadmin_visible[0]['superadmin_restriction'];

        $this->load->library("pagination");
        $config             = array();
        $config["base_url"] = "#";
        $config["total_rows"]       = count($this->video_tutorial_model->getVideosByClassIds('', '', $class_ids));
        $config["per_page"]         = 30;
        $config["uri_segment"]      = 5;
        $config["use_page_numbers"] = true;
        $config["full_tag_open"]    = '<ul class="pagination">';
        $config["full_tag_close"]   = '</ul>';
        $config["first_tag_open"]   = '<li>';
        $config["first_tag_close"]  = '</li>';
        $config["last_tag_open"]    = '<li>';
        $config["last_tag_close"]   = '</li>';
        $config['next_link']        = $this->lang->line('next');
        $config['next_tag_open']    = '<li class="next page">';
        $config['next_tag_close']   = '</li>';
        $config['prev_link']        = $this->lang->line('previous');
        $config['prev_tag_open']    = '<li class="prev page">';
        $config['prev_tag_close']   = '</li>';
        $config["cur_tag_open"]     = "<li class='active'><a href='#'>";
        $config["cur_tag_close"]    = "</a></li>";
        $config["num_tag_open"]     = "<li>";
        $config["num_tag_close"]    = "</li>";
        $config["num_links"]        = 1;

        $this->pagination->initialize($config);

        if ($page == 'undefined') {
            $page = 1;
        }

        $start = ($page - 1) * $config["per_page"];

        $result      = $this->video_tutorial_model->getVideosByClassIds($config["per_page"], $start, $class_ids);
        $img_data    = array();
        $check_empty = 0;
        if (!empty($result)) {
            $check_empty = 1;
            foreach ($result as $res_key => $res_value) {
                $div        = $this->genratediv($res_value, $superadmin_restriction);
                $img_data[] = $div;
            }
        }

        $output = array(
            'pagination_link' => $this->pagination->create_links(),
            'result_status'   => $check_empty,
            'result'          => $img_data,
        );
        echo json_encode($output);
    }

    public function genratediv($result, $superadmin_restriction)
    {
        $file     = base_url() . $result['thumb_path'] . $result['thumb_name'] . img_time();
        $file_src = $result['video_link'];

        // Student view: never expose employee IDs
        if ($superadmin_restriction == 'disabled' && isset($result['role_id']) && $result['role_id'] == 7) {
            $staff_name = '';
        } else {
            $staff_name = (!empty($result['staff_name']) ? $result['staff_name'] : '') . ' ' . (!empty($result['staff_surname']) ? $result['staff_surname'] : '');
        }

        // Class label for display
        $class_label = !empty($result['subject_name']) ? $result['subject_name'] : '';
        if (!empty($result['level_name'])) {
            $class_label .= ' - ' . $result['level_name'];
        }

        $output = '';
        $output .= "<div class='col-sm-4 col-md-3 col-xs-6 img_div_modal image_div div_record_" . $result['id'] . "'>";
        $output .= "<div class='fadeoverlay'>";
        $output .= "<div class='fadeheight'>";
        $output .= "<img class='' data-fid='" . $result['id'] . "' data-content_name='" . $result['img_name'] . "' src='" . $file . "'>";
        $output .= "</div>";
        $output .= "<i class='fa fa-youtube-play videoicon'></i>";
        $output .= "<div class='overlay3'>";
        $output .= "<a href='#' class='uploadcheckbtn' data-backdrop='static' data-keyboard='false' data-record_id='" . $result['id'] . "' data-toggle='modal' data-target='#detail' data-media_type='youtube' data-role_name='" . htmlspecialchars($staff_name, ENT_QUOTES) . "' data-image='" . $file . "' data-source='" . htmlspecialchars($file_src, ENT_QUOTES) . "' data-title='" . htmlspecialchars($result['title'], ENT_QUOTES) . "' data-description='" . htmlspecialchars($result['description'], ENT_QUOTES) . "' data-class_label='" . htmlspecialchars($class_label, ENT_QUOTES) . "'><i class='fa fa-play-circle' title='" . $this->lang->line('view') . "'></i></a>";
        $output .= "<p class='processing'>" . $this->lang->line('processing') . "</p>";
        $output .= "</div>";
        $output .= "</div>";
        $output .= "<p class='fadeoverlay-para'>" . $result['title'] . "</p>";
        if (!empty($class_label)) {
            $output .= "<p class='text-muted' style='font-size:11px;margin-top:-5px;'>" . htmlspecialchars($class_label) . "</p>";
        }
        $output .= "</div>";

        return $output;
    }
}
