<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Syllabus extends Student_Controller
{

    public function __construct()
    {
        parent::__construct();
        $this->load->library('media_storage');
        $this->sch_setting_detail = $this->setting_model->getSetting();
        $this->start_weekday      = strtolower($this->sch_setting_detail->start_week);
    }

    public function index()
    {
        $this->session->set_userdata('top_menu', 'syllabus');
        $monday                  = strtotime("last " . $this->start_weekday);
        $monday                  = date('w', $monday) == date('w') ? $monday + 7 * 86400 : $monday;
        $sunday                  = strtotime(date("Y-m-d", $monday) . " +6 days");
        $this_week_start         = date("Y-m-d", $monday);
        $this_week_end           = date("Y-m-d", $sunday);
        $data['this_week_start'] = date($this->customlib->getSchoolDateFormat(), $this->customlib->dateyyyymmddTodateformat($this_week_start));
        $data['this_week_end']   = date($this->customlib->getSchoolDateFormat(), $this->customlib->dateyyyymmddTodateformat($this_week_end));
        $this->load->view('layout/student/header', $data);
        $this->load->view('user/syllabus/syllabus', $data);
        $this->load->view('layout/student/footer', $data);
    }

    public function get_weekdates()
    {
        $this->session->set_userdata('top_menu', 'Time_table');
        $this_week_start         = $this->customlib->dateFormatToYYYYMMDD($_POST['date']);
        $prev_week_start         = date("Y-m-d", strtotime('last ' . $this->start_weekday, strtotime($this_week_start)));
        $next_week_start         = date("Y-m-d", strtotime('next ' . $this->start_weekday, strtotime($this_week_start)));
        $this_week_end           = date("Y-m-d", strtotime($this_week_start . " +6 day"));
        $data['this_week_start'] = $this->customlib->dateformat($this_week_start);
        $data['this_week_end']   = $this->customlib->dateformat($this_week_end);
        $data['prev_week_start'] = $this->customlib->dateformat($prev_week_start);
        $data['next_week_start'] = $this->customlib->dateformat($next_week_start);

        // TVET: Get student's enrolled classes instead of class-section
        $student_id              = $this->customlib->getStudentSessionUserID();
        $student                 = $this->student_model->get($student_id);
        $session_id              = $this->setting_model->getCurrentSession();

        // TVET: Get all classes student is enrolled in
        $student_classes         = $this->academic_enrolment_model->getStudentClasses($student_id, $session_id);
        $class_ids               = array();
        foreach ($student_classes as $class) {
            $class_ids[] = $class->class_id;
        }

        $data['student_data']    = $student_classes;
        $days                    = $this->customlib->getDaysname();
        $days_record             = array();

        foreach ($days as $day_key => $day_value) {
            $days_record[$day_key] = $day_value;
        }
        $data['timetable'] = $days_record;
        $this->load->view('user/syllabus/_get_weekdates', $data);
    }

    public function get_subject_syllabus()
    {
        $data['subject_syllabus_id'] = $_POST['subject_syllabus_id'];
        $data['result']              = $this->syllabus_model->get_subject_syllabus_student($data);         
        $this->load->view('user/syllabus/_get_subject_syllabus', $data);
    }

    public function check_subject_syllabus($subject_group_subject_id, $date, $time_from, $time_to, $subject_group_class_section_id)
    {
        $data['subject_group_subject_id']       = $subject_group_subject_id;
        $data['date']                           = $date;
        $data['time_from']                      = $time_from;
        $data['time_to']                        = $time_to;
        $data['subject_group_class_section_id'] = $subject_group_class_section_id;
        $data['result']                         = $this->syllabus_model->get_subject_syllabus_student($data);
        $this->load->view('user/syllabus/_get_subject_syllabus', $data);
    }
    
    public function download($id)
    {      
        $result=$this->lessonplan_model->getSyllabusById($id); 
        $attachment_img_name = $this->media_storage->filedownload($result->attachment,"./uploads/syllabus_attachment/");
    }
    
    public function lacture_video_download($id)
    {      
        $result=$this->lessonplan_model->getSyllabusById($id); 
        $attachment_img_name = $this->media_storage->filedownload($result->lacture_video,"./uploads/syllabus_attachment/lacture_video/");
    }

    public function status()
    {
        $this->session->set_userdata('top_menu', 'syllabus/status');

        // TVET: Get student's enrolled classes from enrolments
        $student_id  = $this->customlib->getStudentSessionUserID();
        $student     = $this->student_model->get($student_id);
        $session_id  = $this->setting_model->getCurrentSession();

        // TVET: Get all classes student is enrolled in
        $student_classes = $this->academic_enrolment_model->getStudentClasses($student_id, $session_id);

        $data['subjects_data'] = array();

        // TVET: Process each enrolled class (each class represents a subject)
        foreach ($student_classes as $class) {
            // For TVET, each academic_class is a subject-level combination
            // We'll need to get syllabus data based on the class

            // Note: This functionality may need model updates to fully support TVET
            // For now, maintaining structure but using class_id instead of class-section

            $show_status     = 0;
            $teacher_summary = array();
            $lesson_result   = array();
            $complete        = 0;
            $incomplete      = 0;

            // Build a unique identifier for this class/subject
            $subject_key = $class->class_id . '_' . $class->subject_code;

            // Display label with subject and level
            $lebel = $class->subject_code ? ' (' . $class->subject_code . ')' : '';

            $data['subjects_data'][$subject_key] = array(
                'lebel'      => $class->subject_name . ' ' . $class->level_code . $lebel,
                'complete'   => 0,
                'incomplete' => 0,
                'id'         => $subject_key,
                'total'      => 0,
                'name'       => $class->subject_name,
                'graph_id'   => $subject_key . time(),
                'lesson_summary' => array()
            );
        }

        $data['status'] = array('1' => $this->lang->line('complete'), '0' => $this->lang->line('incomplete'));
        $this->load->view('layout/student/header', $data);
        $this->load->view('user/syllabus/status', $data);
        $this->load->view('layout/student/footer', $data);
    }

    public function addmessage()
    {
        $student_id = $this->customlib->getStudentSessionUserID();
        $this->form_validation->set_rules('message', $this->lang->line('comment'), 'trim|required|xss_clean');
        if ($this->form_validation->run() == false) {
            $msg = array(
                'message' => form_error('message'),
            );
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } else {
            $data = array(
                'subject_syllabus_id' => $this->input->post("subject_syllabus_id"),
                'type'                => 'student',
                'student_id'          => $student_id,                 
                'message'             => $this->input->post("message"),
                'created_date'        => date('Y-m-d H:i:s'),
            );

            $this->syllabus_model->addmessage($data);
            $msg   = $this->lang->line('success_message');
            $array = array('status' => 'success', 'error' => '', 'message' => $msg);
        }

        echo json_encode($array);
    }

    public function getmessage()
    {
        $subject_syllabus_id      = $this->input->post("subject_syllabus_id");
        $data['messagelist']      = $this->syllabus_model->getstudentmessage($subject_syllabus_id);
        $data['sch_setting']      = $this->sch_setting_detail;
        $data['login_student_id'] = $this->customlib->getStudentSessionUserID();
        $page                     = $this->load->view('user/syllabus/_get_message', $data, true);
        $array                    = array('status' => 'success', 'error' => '', 'page' => $page, 'message' => $this->lang->line('success_message'));
        echo json_encode($array);
    }

    public function deletemessage()
    {
        $fourm_id = $_POST['fourm_id'];
        $this->syllabus_model->deletemessage($fourm_id);

    }

}
