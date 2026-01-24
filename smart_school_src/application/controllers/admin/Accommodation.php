<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Accommodation extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->load->model('student_accommodation_model');
        $this->load->model('student_model');
        $this->load->model('studentsession_model');
    }

    public function index()
    {
        if (!$this->rbac->hasPrivilege('student_accommodation', 'can_view')) {
            access_denied();
        }
        $this->session->set_userdata('top_menu', 'Students');
        $this->session->set_userdata('sub_menu', 'admin/accommodation');

        $data = array();
        $data['accommodations'] = $this->student_accommodation_model->getAllWithStudentInfo();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/accommodation/index', $data);
        $this->load->view('layout/footer', $data);
    }

    public function add()
    {
        if (!$this->rbac->hasPrivilege('student_accommodation', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('student_session_id', $this->lang->line('student'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('accommodation_type', $this->lang->line('type'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('extra_time_percent', $this->lang->line('extra_time'), 'trim|required|numeric|xss_clean');

        if ($this->form_validation->run() == false) {
            $msg = array(
                'student_session_id' => form_error('student_session_id'),
                'accommodation_type' => form_error('accommodation_type'),
                'extra_time_percent' => form_error('extra_time_percent'),
            );
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } else {
            $userdata = $this->customlib->getUserData();
            $data = array(
                'student_session_id' => $this->input->post('student_session_id'),
                'accommodation_type' => $this->input->post('accommodation_type'),
                'extra_time_percent' => $this->input->post('extra_time_percent'),
                'notes' => $this->input->post('notes'),
                'approved_by_staff_id' => $userdata['id'],
                'is_active' => 1,
            );
            $this->student_accommodation_model->add($data);
            $array = array('status' => 'success', 'error' => '', 'message' => $this->lang->line('success_message'));
        }
        echo json_encode($array);
    }

    public function edit()
    {
        if (!$this->rbac->hasPrivilege('student_accommodation', 'can_edit')) {
            access_denied();
        }

        $this->form_validation->set_rules('id', 'ID', 'trim|required|xss_clean');
        $this->form_validation->set_rules('accommodation_type', $this->lang->line('type'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('extra_time_percent', $this->lang->line('extra_time'), 'trim|required|numeric|xss_clean');

        if ($this->form_validation->run() == false) {
            $msg = array(
                'accommodation_type' => form_error('accommodation_type'),
                'extra_time_percent' => form_error('extra_time_percent'),
            );
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } else {
            $data = array(
                'id' => $this->input->post('id'),
                'accommodation_type' => $this->input->post('accommodation_type'),
                'extra_time_percent' => $this->input->post('extra_time_percent'),
                'notes' => $this->input->post('notes'),
                'is_active' => $this->input->post('is_active') ? 1 : 0,
            );
            $this->student_accommodation_model->add($data);
            $array = array('status' => 'success', 'error' => '', 'message' => $this->lang->line('success_message'));
        }
        echo json_encode($array);
    }

    public function delete($id)
    {
        if (!$this->rbac->hasPrivilege('student_accommodation', 'can_delete')) {
            access_denied();
        }
        $this->student_accommodation_model->remove($id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">' . $this->lang->line('delete_message') . '</div>');
        redirect('admin/accommodation');
    }

    public function search_student()
    {
        $keyword = $this->input->post('keyword');
        $session_id = $this->setting_model->getCurrentSessionId();
        $results = $this->studentsession_model->searchStudentByKeyword($keyword, $session_id);
        echo json_encode($results);
    }
}
