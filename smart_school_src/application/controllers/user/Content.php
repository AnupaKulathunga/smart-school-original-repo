<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Content extends Student_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->load->library('media_storage');
        $this->load->library('enc_lib');
        $this->load->model(array('contenttype_model', 'uploadcontent_model', 'sharecontent_model', 'content_view_model', 'tvet_student_enrolment_model'));
    }

    function list() {

        $this->session->set_userdata('top_menu', 'Downloads');
        $this->session->set_userdata('sub_menu', 'content/index');
        $data = array();
        $data['role'] = $this->customlib->getUserRole();

        // Load content types for filter dropdown
        $data['content_types'] = $this->contenttype_model->get();

        // Load all subjects for the filter dropdown (simple query for student view)
        $this->db->select('id, name, code');
        $this->db->from('subjects');
        $this->db->where('is_active', 'yes');
        $this->db->order_by('name', 'ASC');
        $data['subjects'] = $this->db->get()->result_array();
        $this->load->view('layout/student/header', $data);
        $this->load->view('user/content/list', $data);
        $this->load->view('layout/student/footer');

    }

    public function getsharelist()
    {
        // TVET: Get student ID for enrolment-based content access
        $role                  = $this->customlib->getUserRole();
        $subject_id            = $this->input->post('subject_id');
        $content_type_id       = $this->input->post('content_type_id');

        // Get student's TVET cohort IDs if enrolled
        $cohort_ids = array();
        if (isset($this->tvet_student_enrolment_model)) {
            $student_id = $this->customlib->getStudentSessionUserID();
            $cohort_ids = $this->tvet_student_enrolment_model->getStudentCohortIds($student_id);
        }

        // TVET: Get current class info — class_id is academic_class.id
        $student_current_class = $this->customlib->getStudentCurrentClsSection();
        $academic_class_id = isset($student_current_class->class_id) ? $student_current_class->class_id : 0;

        if ($role == "student") {
            $m = $this->sharecontent_model->getStudentsharelist(
                $this->customlib->getStudentSessionUserID(),
                $academic_class_id,
                null,
                $cohort_ids,
                $subject_id,
                $content_type_id
            );
        } elseif ($role == "parent") {
            $m = $this->sharecontent_model->getParentsharelist(
                $this->customlib->getUsersID(),
                $academic_class_id,
                null,
                $cohort_ids,
                $subject_id,
                $content_type_id
            );
        }

        $superadmin_visible =    $this->Setting_model->get();
        $superadmin_restriction =   $superadmin_visible[0]['superadmin_restriction'];

        $m = json_decode($m);

        $viewed_ids = $this->content_view_model->getViewedContentIds($student_current_class->student_session_id);

        $dt_data = array();
        if (!empty($m->data)) {
            foreach ($m->data as $key => $value) {
                $viewbtn   = '';
                $title     = $value->title;
                if (!in_array($value->id, $viewed_ids)) {
                    $title .= ' <span class="label label-info">' . $this->lang->line('new') . '</span>';
                }
                $row       = array();
                $row[]     = $title;

                // Content type column
                $content_type_display = '';
                if (isset($value->content_type_name) && !empty($value->content_type_name)) {
                    $content_type_display = $value->content_type_name;
                }
                $row[]     = $content_type_display;

                // Subject column
                $subject_display = '';
                if (isset($value->subject_name) && !empty($value->subject_name)) {
                    $subject_display = $value->subject_name;
                    if (isset($value->subject_code) && !empty($value->subject_code)) {
                        $subject_display .= ' (' . $value->subject_code . ')';
                    }
                }
                $row[]     = $subject_display;

                $viewbtn   = "<a href='" . site_url('user/content/view/') . $value->id . "'   class='btn btn-default btn-xs'  data-toggle='tooltip' title='" . $this->lang->line('view') . "'><i class='fa fa-eye'></i></a>";
                $row[]     = $this->customlib->dateformat($value->share_date);
                $row[]     = $this->customlib->dateformat($value->valid_upto);

                if($superadmin_restriction == 'disabled' && $value->role_id == 7){
                        $row[]     =  '';
                }else{
                        // Only show name for students - don't expose employee IDs
                        $row[]     = $value->name .' '. $value->surname;
                }

                $row[]     = $viewbtn;
                $dt_data[] = $row;
            }
        }

        $json_data = array(
            "draw"            => intval($m->draw),
            "recordsTotal"    => intval($m->recordsTotal),
            "recordsFiltered" => intval($m->recordsFiltered),
            "data"            => $dt_data,
        );
        echo json_encode($json_data);
    }

    public function view($id)
    {
        $data['title']      = 'Upload Content';
        $data['title_list'] = 'Upload Content List';
        $data['role'] = $this->customlib->getUserRole();
        $data['content']    = $this->sharecontent_model->getShareContentWithDocuments($id);
        $superadmin_visible =    $this->Setting_model->get();
        $data['superadmin_restriction'] =   $superadmin_visible[0]['superadmin_restriction'];

        $data['branch_url']=$this->customlib->getBaseUrl();

        $student_current_class = $this->customlib->getStudentCurrentClsSection();
        $this->content_view_model->trackView($id, $student_current_class->student_session_id);

        $this->load->view('layout/student/header', $data);
        $this->load->view('user/content/view', $data);
        $this->load->view('layout/student/footer');
    }

 public function download_content($id)
    {
        $this->load->helper('file');
        $student_current_class = $this->customlib->getStudentCurrentClsSection();
        $this->content_view_model->trackView($id, $student_current_class->student_session_id);
        $content = $this->uploadcontent_model->get($id);
        $this->media_storage->filedownload($content->img_name, $content->dir_path);
    }

    public function track_view()
    {
        $content_id = $this->input->post('content_id');
        if ($content_id) {
            $student_current_class = $this->customlib->getStudentCurrentClsSection();
            $this->content_view_model->trackView($content_id, $student_current_class->student_session_id);
            echo json_encode(array('status' => 'success'));
        } else {
            echo json_encode(array('status' => 'fail'));
        }
    }
    public function index()
    {
        $data['title']      = 'Upload Content';
        $data['title_list'] = 'Upload Content List';
        $data['role'] = $this->customlib->getUserRole();
        $list               = $this->content_model->get();
        $data['list']       = $list;
        $ght                = $this->customlib->getcontenttype();
        $data['ght']        = $ght;
        // TVET: Use classmodel_model to get classes for current session
        $session_id         = $this->setting_model->getCurrentSession();
        $class              = $this->classmodel_model->getClassesBySession($session_id);
        $data['classlist']  = $class;
        $this->load->view('layout/student/header', $data);
        $this->load->view('user/content/createcontent', $data);
        $this->load->view('layout/student/footer');
    }

    public function download($file)
    {
        $this->media_storage->filedownload($this->uri->segment(7), "./uploads/school_content/material");

    }

    public function assignment()
    {
        redirect('user/content/list');
    }

    public function studymaterial()
    {
        redirect('user/content/list');
    }

    public function syllabus()
    {
        redirect('user/content/list');
    }

    public function other()
    {
        redirect('user/content/list');
    }

}
