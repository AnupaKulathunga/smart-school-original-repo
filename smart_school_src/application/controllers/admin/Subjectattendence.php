<?php

/**
 * Subject Attendance Controller
 *
 * TVET Migration: This controller has been migrated to use the TVET academic model.
 * - Uses class_id only (no section_id)
 * - Uses classmodel_model for class listings
 * - Uses enrolment_model for student roster
 * - Preserves subject-based attendance tracking via subject_timetable
 */

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Subjectattendence extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->config->load("mailsms");
        $this->load->library('mailsmsconf');
        $this->config_attendance = $this->config->item('attendence');
        // TVET: classteacher_model not needed - TVET handles class-lecturer relationships differently
    }

    /**
     * Report attendance by date
     * TVET: Uses class_id only, no section_id
     */
    public function reportbydate()
    {
        $this->session->set_userdata('top_menu', 'Attendance');
        $this->session->set_userdata('sub_menu', 'subjectattendence/reportbydate');
        $data                = array();
        // TVET: Use classmodel_model to get classes for current session
        $session_id          = $this->setting_model->getCurrentSession();
        $class               = $this->classmodel_model->getClassesBySession($session_id);
        $data['classlist']   = $class;
        $data['sch_setting'] = $this->setting_model->getSetting();
        // TVET: class_id validation - references TVET class table
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');
        // TVET: section_id validation removed
        $this->form_validation->set_rules('date', $this->lang->line('date'), 'trim|required|xss_clean');

        if ($this->form_validation->run() == true) {
            $class_id                    = $this->input->post('class_id');
            // TVET: section_id removed
            $date                        = $this->input->post('date');
            $day                         = date('l', $this->customlib->datetostrtotime($date));
            // TVET: Pass null for section_id to use class-only query
            $resultlist                  = $this->studentsubjectattendence_model->searchByStudentsAttendanceByDate($class_id, null, $day, date('Y-m-d', $this->customlib->datetostrtotime($date)), '');
            $attendencetypes             = $this->attendencetype_model->get();
            $data['attendencetypeslist'] = $attendencetypes;
            $data['resultlist']          = $resultlist;
        }
        $this->load->view('layout/header', $data);
        $this->load->view('admin/subjectattendence/reportbydate', $data);
        $this->load->view('layout/footer', $data);
    }

    /**
     * Main attendance entry page
     * TVET: Uses class_id only, no section_id
     */
    public function index()
    {
        $this->session->set_userdata('top_menu', 'Attendance');
        $this->session->set_userdata('sub_menu', 'subjectattendence/index');
        $data['title']      = 'Add Fees Type';
        $data['title_list'] = 'Fees Type List';
        // TVET: Use classmodel_model to get classes for current session
        $session_id         = $this->setting_model->getCurrentSession();
        $class              = $this->classmodel_model->getClassesBySession($session_id);
        $data['classlist']  = $class;
        $userdata           = $this->customlib->getUserData();
        $carray             = array();

        if (!empty($data["classlist"])) {
            foreach ($data["classlist"] as $ckey => $cvalue) {
                // TVET: Handle array format from classmodel_model
                $carray[] = is_array($cvalue) ? $cvalue['id'] : $cvalue->id;
            }
        }
        $data['class_id']    = "";
        // TVET: section_id removed
        $data['date']        = "";
        $is_first_time_attendance      = true;
        $data['sch_setting'] = $this->setting_model->getSetting();
        // TVET: class_id validation - references TVET class table
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');
        // TVET: section_id validation removed
        $this->form_validation->set_rules('date', $this->lang->line('date'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('subject_timetable_id', $this->lang->line('subject'), 'trim|required|xss_clean');
        if ($this->form_validation->run() == false) {
            $this->load->view('layout/header', $data);
            $this->load->view('admin/subjectattendence/attendenceList', $data);
            $this->load->view('layout/footer', $data);
        } else {
            $class_id             = $this->input->post('class_id');
            // TVET: section_id removed
            $date                 = $this->input->post('date');
            $subject_timetable_id = $this->input->post('subject_timetable_id');

            $data['class_id']             = $class_id;
            // TVET: section_id removed
            $data['subject_timetable_id'] = $subject_timetable_id;
            $data['date']                 = $date;
            $search                       = $this->input->post('search');
            $holiday                      = $this->input->post('holiday');
            if ($search == "saveattendence") {
                $session_ary         = $this->input->post('student_session');

                $attendance_array = [];
                $absent_student_list = [];

                foreach ($session_ary as $key => $value) {

                    $attendence_type_id = $this->input->post('attendencetype' . $value);

                    $absent_config = $this->config_attendance['absent'];
                    if ($attendence_type_id == $absent_config) {
                        $absent_student_list[] = $value;
                    } else if (
                        ($attendence_type_id == $this->config_attendance["present"]
                            || $attendence_type_id == $this->config_attendance["late"]
                            || $attendence_type_id == $this->config_attendance["half_day"]
                            || $attendence_type_id == $this->config_attendance["half_day_second_shift"]) && $this->input->post('is_first_time_attendance')
                    ) {
                        $present_student_list['student_sessions_id'][$value] = ($value);
                        $present_student_list['in_time'][$value] = $this->input->post("in_time_" . $value);
                    }

                    $attendance_array[] = array(
                        'student_session_id'   => $value,
                        'attendence_type_id'   => $attendence_type_id,
                        'remark'               => $this->input->post("remark" . $value),
                        'subject_timetable_id' => $subject_timetable_id,
                        'date'                 => date('Y-m-d', $this->customlib->datetostrtotime($date)),
                    );
                }
                $this->studentsubjectattendence_model->addorUpdate($attendance_array);

                if (!empty($absent_student_list)) {
                    $timetable = $this->subjecttimetable_model->get($subject_timetable_id);
                    $this->mailsmsconf->mailsms('student_absent_attendence', $absent_student_list, $date, $timetable);
                }
                if (!empty($present_student_list)) {
                    $timetable = $this->subjecttimetable_model->get($subject_timetable_id);
                    $this->mailsmsconf->mailsms('student_present_attendence', $present_student_list, $date, $timetable);
                }

                $this->session->set_flashdata('msg', '<div class="alert alert-success text-left">' . $this->lang->line('success_message') . '</div>');
                redirect('admin/subjectattendence/index');
            }
            $attendencetypes             = $this->attendencetype_model->get();
            $data['attendencetypeslist'] = $attendencetypes;

            // TVET: Pass null for section_id to use class-only query
            $resultlist = $this->studentsubjectattendence_model->searchAttendenceClassSection($class_id, null, $subject_timetable_id, date('Y-m-d', $this->customlib->datetostrtotime($date)));

            // Check if this is the first time attendance is being marked
            if (!empty($resultlist)) {
                foreach ($resultlist as $key => $value) {
                    if (!IsNullOrEmptyString($value['attendence_type_id'])) {
                        $is_first_time_attendance = false;
                    }
                }
            }
            $data['is_first_time_attendance'] = $is_first_time_attendance;

            $data['resultlist'] = $resultlist;
            $this->load->view('layout/header', $data);
            $this->load->view('admin/subjectattendence/attendenceList', $data);
            $this->load->view('layout/footer', $data);
        }
    }

    /**
     * AJAX endpoint: Get subjects for a class by date
     * TVET: Returns timetable entries for a class on a specific day (no section_id)
     */
    public function getSubjectByClassDate()
    {
        $class_id = $this->input->post('class_id');
        $date_str = $this->input->post('date');

        if (empty($class_id) || empty($date_str)) {
            echo json_encode(array());
            return;
        }

        // Convert date to day name
        $date = date('Y-m-d', $this->customlib->datetostrtotime($date_str));
        $day  = date('l', strtotime($date));

        // TVET: Use getSubjectByClassDay - no section_id needed
        $data = $this->subjecttimetable_model->getSubjectByClassDay($class_id, $day);
        echo json_encode($data);
    }
}
