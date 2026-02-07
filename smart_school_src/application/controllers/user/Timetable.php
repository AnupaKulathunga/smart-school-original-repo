<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Timetable extends Student_Controller {

    public function __construct() {
        parent::__construct();
    }

    public function index() {
        $this->session->set_userdata('top_menu', 'Time_table');
        // TVET: Use getStudentCurrentEnrolment() instead of getStudentCurrentClsSection()
        $student_enrolment = $this->customlib->getStudentCurrentEnrolment();
        $class_id = $student_enrolment->class_id;

        $student_id = $this->customlib->getStudentSessionUserID();
        $student = $this->student_model->get($student_id);
        $days = $this->customlib->getDaysname();
        $days_record = array();

        foreach ($days as $day_key => $day_value) {
            // TVET: Use getTimetableByClassDay() - no section_id parameter
            $days_record[$day_key] = $this->subjecttimetable_model->getTimetableByClassDay($class_id, $day_key);
        }
        $data['timetable'] = $days_record;

        $this->load->view('layout/student/header', $data);
        $this->load->view('user/timetable/timetableList', $data);
        $this->load->view('layout/student/footer', $data);
    }

    public function printclasstimetable()
    {
        // TVET: Use getStudentCurrentEnrolment() instead of getStudentCurrentClsSection()
        $student_enrolment = $this->customlib->getStudentCurrentEnrolment();
        $class_id = $student_enrolment->class_id;

        $days = $this->customlib->getDaysname();
        // TVET: Get class details from academic_class_model
        $class_section = $this->classmodel_model->getClassById($class_id);
        $data['class_section'] = $class_section;
        $days_record = array();

        foreach ($days as $day_key => $day_value) {
            // TVET: Use getTimetableByClassDay() - no section_id parameter
            $days_record[$day_key] = $this->subjecttimetable_model->getTimetableByClassDay($class_id, $day_key);
        }
        $data['timetable'] = $days_record;
        $timetable_page = $this->load->view('admin/timetable/_printclasstimetable', $data, true);
        $json_array = array('status' => '1', 'error' => '', 'page' => $timetable_page);
        $this->output
            ->set_content_type('application/json')
            ->set_output(json_encode($json_array));
    }


}
