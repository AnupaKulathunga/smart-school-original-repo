<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Disabilitytype extends Admin_Controller
{
    public $sch_setting_detail = array();

    public function __construct()
    {
        parent::__construct();
        $this->load->library('media_storage');
        $this->sch_setting_detail = $this->setting_model->getSetting();
    }

    public function index()
    {
        if (!$this->rbac->hasPrivilege('disability_types', 'can_view')) {
            access_denied();
        }
        $this->session->set_userdata('top_menu', 'Student Information');
        $this->session->set_userdata('sub_menu', 'disabilitytype/index');
        $data['title']        = $this->lang->line('disability_type_list');
        $data['typelist']     = $this->disability_type_model->get();
        $this->load->view('layout/header', $data);
        $this->load->view('disabilitytype/disabilitytypeList', $data);
        $this->load->view('layout/footer', $data);
    }

    public function delete($id)
    {
        if (!$this->rbac->hasPrivilege('disability_types', 'can_delete')) {
            access_denied();
        }
        // Check if in use
        $this->db->where('disability_type_id', $id);
        $count = $this->db->count_all_results('students');
        if ($count > 0) {
            $this->session->set_flashdata('msgdelete', '<div class="alert alert-danger text-left">' . $this->lang->line('cannot_delete_type_in_use') . '</div>');
        } else {
            $this->disability_type_model->remove($id);
            $this->session->set_flashdata('msgdelete', '<div class="alert alert-success text-left">' . $this->lang->line('delete_message') . '</div>');
        }
        redirect('disabilitytype/index');
    }

    public function create()
    {
        if (!$this->rbac->hasPrivilege('disability_types', 'can_add')) {
            access_denied();
        }
        $data['title']    = $this->lang->line('add_disability_type');
        $data['typelist'] = $this->disability_type_model->get();
        $this->form_validation->set_rules('name', $this->lang->line('disability_type'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('default_extra_time_percent', $this->lang->line('default_extra_time'), 'trim|required|numeric');
        if ($this->form_validation->run() == false) {
            $this->load->view('layout/header', $data);
            $this->load->view('disabilitytype/disabilitytypeList', $data);
            $this->load->view('layout/footer', $data);
        } else {
            $data = array(
                'name' => $this->input->post('name'),
                'description' => $this->input->post('description'),
                'default_extra_time_percent' => $this->input->post('default_extra_time_percent'),
            );
            $this->disability_type_model->add($data);
            $this->session->set_flashdata('msg', '<div class="alert alert-success text-left">' . $this->lang->line('success_message') . '</div>');
            redirect('disabilitytype/index');
        }
    }

    public function edit($id)
    {
        if (!$this->rbac->hasPrivilege('disability_types', 'can_edit')) {
            access_denied();
        }
        $data['title']    = $this->lang->line('edit_disability_type');
        $data['id']       = $id;
        $type             = $this->disability_type_model->get($id);
        $data['type']     = $type;
        $data['typelist'] = $this->disability_type_model->get();
        $this->form_validation->set_rules('name', $this->lang->line('disability_type'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('default_extra_time_percent', $this->lang->line('default_extra_time'), 'trim|required|numeric');
        if ($this->form_validation->run() == false) {
            $this->load->view('layout/header', $data);
            $this->load->view('disabilitytype/disabilitytypeEdit', $data);
            $this->load->view('layout/footer', $data);
        } else {
            $data = array(
                'id' => $id,
                'name' => $this->input->post('name'),
                'description' => $this->input->post('description'),
                'default_extra_time_percent' => $this->input->post('default_extra_time_percent'),
            );
            $this->disability_type_model->add($data);
            $this->session->set_flashdata('msg', '<div class="alert alert-success text-left">' . $this->lang->line('update_message') . '</div>');
            redirect('disabilitytype/index');
        }
    }

    /**
     * Display list of students with disabilities
     * Following the same pattern as Student::disablestudentslist()
     */
    public function students()
    {
        if (!$this->rbac->hasPrivilege('disabled_students_report', 'can_view')) {
            access_denied();
        }
        $this->session->set_userdata('top_menu', 'Student Information');
        $this->session->set_userdata('sub_menu', 'disabilitytype/students');

        $data['title']       = $this->lang->line('disabled_students_report');
        // TVET: Use classmodel_model->getClassesBySession()
        $session_id          = $this->setting_model->getCurrentSession();
        $data['classlist']   = $this->classmodel_model->getClassesBySession($session_id);
        $data['typelist']    = $this->disability_type_model->get();
        $data['sch_setting'] = $this->sch_setting_detail;
        $data['resultlist']  = array();

        $button = $this->input->post('search');
        if ($this->input->server('REQUEST_METHOD') == "POST") {
            $class              = $this->input->post('class_id');
            $section            = $this->input->post('section_id');
            $disability_type_id = $this->input->post('disability_type_id');
            $search             = $this->input->post('search');
            $search_text        = $this->input->post('search_text');

            if (isset($search)) {
                if ($search == 'search_filter') {
                    $data['searchby']            = "filter";
                    $data['class_id']            = $class;
                    $data['section_id']          = $section;
                    $data['disability_type_id']  = $disability_type_id;
                    $resultlist                  = $this->student_model->getDisabledStudentsByClassSection($class, $section, $disability_type_id);
                    $data['resultlist']          = $resultlist;
                } else if ($search == 'search_full') {
                    $data['searchby']    = "text";
                    $data['search_text'] = trim($search_text);
                    $resultlist          = $this->student_model->getDisabledStudentsFullText($search_text);
                    $data['resultlist']  = $resultlist;
                }
            }
        }

        $this->load->view('layout/header', $data);
        $this->load->view('disabilitytype/disabledStudents', $data);
        $this->load->view('layout/footer', $data);
    }

}
