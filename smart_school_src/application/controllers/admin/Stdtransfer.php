<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Stdtransfer extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->load->model("classteacher_model");
        $this->sch_setting_detail = $this->setting_model->getSetting();
    }

    public function index()
    {
        if (!$this->rbac->hasPrivilege('promote_student', 'can_view')) {
            access_denied();
        }
        $this->session->set_userdata('top_menu', 'Academics');
        $this->session->set_userdata('sub_menu', 'stdtransfer/index');
        $data['title']           = 'Student Transfer';

        // TVET: Use classmodel_model->getClassesBySession() instead of class_model->get()
        $current_session = $this->setting_model->getCurrentSession();
        $class = $this->classmodel_model->getClassesBySession($current_session);
        $data['classlist']       = $class;
        $userdata                = $this->customlib->getUserData();
        $data['sch_setting']     = $this->sch_setting_detail;
        $session_result          = $this->session_model->get();
        $data['sessionlist']     = $session_result;

        // TVET: No section_id validation, class_id includes cohort
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('class_promote_id', $this->lang->line('class'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('session_id', $this->lang->line('promote_in_session'), 'trim|required|xss_clean');

        if ($this->form_validation->run() == true) {
            $class                         = $this->input->post('class_id');
            $session                       = $this->input->post('session_id');
            $class_promote                 = $this->input->post('class_promote_id');
            $data['class_post']            = $class;
            $data['class_promoted_post']   = $class_promote;
            $data['session_promoted_post'] = $session;

            // TVET: searchNonPromotedStudents without section parameters
            $resultlist = $this->student_model->searchNonPromotedStudents($class, $session, $class_promote);

            $data['resultlist'] = $resultlist;
        }

        $this->load->view('layout/header', $data);
        $this->load->view('admin/stdtransfer/stdtransfer', $data);
        $this->load->view('layout/footer', $data);
    }

    public function promote()
    {
        // TVET: No section_promote_id validation, class_id includes cohort
        $this->form_validation->set_rules('session_id', $this->lang->line('session'), 'required|trim|xss_clean');
        $this->form_validation->set_rules('class_promote_id', $this->lang->line('class'), 'required|trim|xss_clean');
        $this->form_validation->set_rules('student_list[]', $this->lang->line('student'), 'required|trim|xss_clean');

        if ($this->form_validation->run() == false) {
            $errors = array(
                'session_id'       => form_error('session_id'),
                'class_promote_id' => form_error('class_promote_id'),
                'student_list'     => form_error('student_list[]'),
            );
            echo json_encode(array('status' => 'fail', 'msg' => $errors));
        } else {
            $student_list    = $this->input->post('student_list');
            $current_session = $this->setting_model->getCurrentSession();
            $class_post      = $this->input->post('class_post');

            if (!empty($student_list) && isset($student_list)) {

                foreach ($student_list as $key => $value) {
                    $student_id     = $value;
                    $result         = $this->input->post('result_' . $value);
                    $session_status = $this->input->post('next_working_' . $value);

                    if ($result == "pass" && $session_status == "countinue") {
                        // TVET: Student passed, enroll in promoted class
                        $promoted_class   = $this->input->post('class_promote_id');
                        $promoted_session = $this->input->post('session_id');

                        // Create enrolment in new class
                        $enrolment_data = array(
                            'student_id'       => $student_id,
                            'class_id'         => $promoted_class,
                            'session_id'       => $promoted_session,
                            'enrolment_date'   => date('Y-m-d'),
                            'enrolment_type'   => 'Core',
                            'status'           => 'Active',
                            'transport_fees'   => 0,
                            'fees_discount'    => 0,
                            'is_active'        => 1,
                        );
                        $this->enrolment_model->add($enrolment_data);

                    } elseif ($result == "fail" && $session_status == "countinue") {
                        // TVET: Student failed, re-enroll in same class
                        $promoted_session = $this->input->post('session_id');

                        // Create enrolment in same class for new session
                        $enrolment_data = array(
                            'student_id'       => $student_id,
                            'class_id'         => $class_post,
                            'session_id'       => $promoted_session,
                            'enrolment_date'   => date('Y-m-d'),
                            'enrolment_type'   => 'Core',
                            'status'           => 'Active',
                            'transport_fees'   => 0,
                            'fees_discount'    => 0,
                            'is_active'        => 1,
                        );
                        $this->enrolment_model->add($enrolment_data);

                    } elseif ($session_status == "leave") {
                        // TVET: Student leaving, update enrolment status to Inactive
                        $this->enrolment_model->updateStatusByStudent($student_id, $current_session, 'Inactive');

                        // Mark student as alumni
                        $alumni_data = array(
                            'student_id' => $student_id,
                            'is_alumni'  => 1,
                        );
                        $this->student_model->alumni_student_status($alumni_data);
                    }
                }
            }
            echo json_encode(array('status' => 'success', 'msg' => ""));
        }
    }

}
