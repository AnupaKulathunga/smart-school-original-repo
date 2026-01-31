<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Tvetportal extends Student_Controller
{
    protected $student_id;
    protected $current_session;

    public function __construct()
    {
        parent::__construct();
        $this->load->model('academic_programme_model');
        $this->load->model('academic_subject_model');
        $this->load->model('academic_level_model');
        $this->load->model('academic_subject_level_model');
        $this->load->model('academic_class_model');
        $this->load->model('academic_enrolment_model');
        $this->load->model('academic_attendance_model');
        $this->load->model('academic_assessment_model');
        $this->load->model('academic_marks_model');

        $this->current_session = $this->setting_model->getCurrentSession();

        // Get student ID from session
        $student_data = $this->session->userdata('student');
        $this->student_id = isset($student_data['student_id']) ? $student_data['student_id'] : null;
    }

    /**
     * Student's enrolled classes
     */
    public function my_classes()
    {
        $this->session->set_userdata('top_menu', 'TVET Portal');
        $this->session->set_userdata('sub_menu', 'tvetportal/my_classes');

        $data['title'] = $this->lang->line('my_classes') ?: 'My Classes';

        // Get student's enrolled classes
        if ($this->student_id) {
            $classes = $this->academic_enrolment_model->getStudentClasses(
                $this->student_id,
                $this->current_session
            );
            // Convert objects to arrays for view
            $data['enrolments'] = array();
            foreach ($classes as $class) {
                $data['enrolments'][] = (array) $class;
            }
        } else {
            $data['enrolments'] = array();
        }

        $this->load->view('layout/student/header', $data);
        $this->load->view('user/tvetportal/my_classes', $data);
        $this->load->view('layout/student/footer', $data);
    }

    /**
     * View class details
     */
    public function class_detail($class_id)
    {
        $this->session->set_userdata('top_menu', 'TVET Portal');
        $this->session->set_userdata('sub_menu', 'tvetportal/my_classes');

        $data['title'] = $this->lang->line('class_details') ?: 'Class Details';

        // Verify student is enrolled in this class
        if (!$this->isEnrolledInClass($class_id)) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">' . ($this->lang->line('access_denied') ?: 'Access Denied') . '</div>');
            redirect('user/tvetportal/my_classes');
        }

        $data['class'] = $this->academic_class_model->getById($class_id);

        // Get student's enrolment info
        $enrolment = $this->academic_enrolment_model->getByStudentClass($this->student_id, $class_id);
        $data['enrolment'] = $enrolment ? (array) $enrolment : null;

        // Get assessments for this class (published ones only)
        $assessments = $this->academic_assessment_model->getByClass($class_id);
        $data['assessments'] = array();
        foreach ($assessments as $a) {
            if ($a['is_published']) {
                $data['assessments'][] = $a;
            }
        }

        // Get attendance summary
        if ($data['enrolment']) {
            $data['attendance_summary'] = $this->academic_attendance_model->getStudentAttendanceSummary(
                $data['enrolment']['id']
            );
        } else {
            $data['attendance_summary'] = null;
        }

        $this->load->view('layout/student/header', $data);
        $this->load->view('user/tvetportal/class_detail', $data);
        $this->load->view('layout/student/footer', $data);
    }

    /**
     * Student's timetable
     */
    public function my_timetable()
    {
        $this->session->set_userdata('top_menu', 'TVET Portal');
        $this->session->set_userdata('sub_menu', 'tvetportal/my_timetable');

        $data['title'] = $this->lang->line('my_timetable') ?: 'My Timetable';

        // Get student's enrolled classes with timetable
        if ($this->student_id) {
            $classes = $this->academic_enrolment_model->getStudentClasses(
                $this->student_id,
                $this->current_session
            );
            $data['enrolments'] = array();
            foreach ($classes as $class) {
                $data['enrolments'][] = (array) $class;
            }
        } else {
            $data['enrolments'] = array();
        }

        $this->load->view('layout/student/header', $data);
        $this->load->view('user/tvetportal/my_timetable', $data);
        $this->load->view('layout/student/footer', $data);
    }

    /**
     * Student's attendance
     */
    public function my_attendance()
    {
        $this->session->set_userdata('top_menu', 'TVET Portal');
        $this->session->set_userdata('sub_menu', 'tvetportal/my_attendance');

        $data['title'] = $this->lang->line('my_attendance') ?: 'My Attendance';

        // Get all enrolled classes with attendance summary
        $data['attendance_by_class'] = array();

        if ($this->student_id) {
            $classes = $this->academic_enrolment_model->getStudentClasses(
                $this->student_id,
                $this->current_session
            );

            foreach ($classes as $enrolment) {
                $summary = $this->academic_attendance_model->getStudentAttendanceSummary($enrolment->id);
                $data['attendance_by_class'][] = array(
                    'class_code' => $enrolment->class_code,
                    'subject_name' => $enrolment->subject_name,
                    'level_code' => $enrolment->level_code,
                    'level_name' => $enrolment->level_name,
                    'summary' => $summary
                );
            }
        }

        $this->load->view('layout/student/header', $data);
        $this->load->view('user/tvetportal/my_attendance', $data);
        $this->load->view('layout/student/footer', $data);
    }

    /**
     * Student's assessments
     */
    public function my_assessments()
    {
        $this->session->set_userdata('top_menu', 'TVET Portal');
        $this->session->set_userdata('sub_menu', 'tvetportal/my_assessments');

        $data['title'] = $this->lang->line('my_assessments') ?: 'My Assessments';

        $data['assessments'] = array();

        if ($this->student_id) {
            // Get all upcoming and past assessments for enrolled classes
            $classes = $this->academic_enrolment_model->getStudentClasses(
                $this->student_id,
                $this->current_session
            );

            foreach ($classes as $enrolment) {
                $assessments = $this->academic_assessment_model->getByClass($enrolment->class_id);
                foreach ($assessments as $assessment) {
                    // Only show published assessments to students
                    if ($assessment['is_published']) {
                        // Get student's marks for this assessment
                        $marks = $this->academic_marks_model->getStudentMark(
                            $assessment['id'],
                            $enrolment->id
                        );

                        $assessment['student_marks'] = $marks ? (array) $marks : null;
                        $assessment['enrolment_id'] = $enrolment->id;
                        $assessment['class_code'] = $enrolment->class_code;
                        $assessment['subject_name'] = $enrolment->subject_name;
                        $data['assessments'][] = $assessment;
                    }
                }
            }

            // Sort by due date
            usort($data['assessments'], function($a, $b) {
                return strtotime($a['due_date'] ?? '2099-12-31') - strtotime($b['due_date'] ?? '2099-12-31');
            });
        }

        $this->load->view('layout/student/header', $data);
        $this->load->view('user/tvetportal/my_assessments', $data);
        $this->load->view('layout/student/footer', $data);
    }

    /**
     * Take online assessment
     */
    public function take_assessment($assessment_id)
    {
        $this->session->set_userdata('top_menu', 'TVET Portal');
        $this->session->set_userdata('sub_menu', 'tvetportal/my_assessments');

        $data['title'] = $this->lang->line('take_assessment') ?: 'Take Assessment';

        $assessment = $this->academic_assessment_model->getById($assessment_id);

        if (!$assessment) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">' . ($this->lang->line('assessment_not_found') ?: 'Assessment not found') . '</div>');
            redirect('user/tvetportal/my_assessments');
        }

        // Verify student is enrolled in the class
        if (!$this->isEnrolledInClass($assessment['class_id'])) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">' . ($this->lang->line('access_denied') ?: 'Access Denied') . '</div>');
            redirect('user/tvetportal/my_assessments');
        }

        // Check if assessment is published
        if (!$assessment['is_published']) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">' . ($this->lang->line('assessment_not_available') ?: 'Assessment not available') . '</div>');
            redirect('user/tvetportal/my_assessments');
        }

        $data['assessment'] = $assessment;

        // Get student's enrolment for this class
        $enrolment = $this->academic_enrolment_model->getByStudentClass($this->student_id, $assessment['class_id']);
        $data['enrolment'] = $enrolment ? (array) $enrolment : null;

        $this->load->view('layout/student/header', $data);
        $this->load->view('user/tvetportal/take_assessment', $data);
        $this->load->view('layout/student/footer', $data);
    }

    /**
     * Student's results/marks
     */
    public function my_results()
    {
        $this->session->set_userdata('top_menu', 'TVET Portal');
        $this->session->set_userdata('sub_menu', 'tvetportal/my_results');

        $data['title'] = $this->lang->line('my_results') ?: 'My Results';

        $data['results_by_class'] = array();

        if ($this->student_id) {
            $classes = $this->academic_enrolment_model->getStudentClasses(
                $this->student_id,
                $this->current_session
            );

            foreach ($classes as $enrolment) {
                // Get all marks for this enrolment
                $marks = $this->academic_marks_model->getByEnrolment($enrolment->id);

                // Calculate ICASS average
                $icass = $this->academic_marks_model->calculateICASSMark($enrolment->id);

                $data['results_by_class'][] = array(
                    'class_code' => $enrolment->class_code,
                    'subject_name' => $enrolment->subject_name,
                    'level_code' => $enrolment->level_code,
                    'level_name' => $enrolment->level_name,
                    'marks' => $marks,
                    'icass_average' => $icass,
                    'final_mark' => $enrolment->final_mark,
                    'final_result' => $enrolment->final_result,
                );
            }
        }

        $this->load->view('layout/student/header', $data);
        $this->load->view('user/tvetportal/my_results', $data);
        $this->load->view('layout/student/footer', $data);
    }

    /**
     * Student's POE (Portfolio of Evidence)
     */
    public function my_poe()
    {
        $this->session->set_userdata('top_menu', 'TVET Portal');
        $this->session->set_userdata('sub_menu', 'tvetportal/my_poe');

        $data['title'] = $this->lang->line('my_poe') ?: 'My Portfolio of Evidence';

        $data['poe_items'] = array();
        $data['enrolments'] = array();

        // POE functionality
        if ($this->student_id) {
            $classes = $this->academic_enrolment_model->getStudentClasses(
                $this->student_id,
                $this->current_session
            );

            foreach ($classes as $enrolment) {
                $data['enrolments'][] = (array) $enrolment;

                // Check if POE table exists and get items
                if ($this->db->table_exists('academic_poe_item')) {
                    $this->db->select('academic_poe_item.*');
                    $this->db->where('enrolment_id', $enrolment->id);
                    $this->db->order_by('submitted_date', 'DESC');
                    $items = $this->db->get('academic_poe_item')->result_array();

                    if (!empty($items)) {
                        $data['poe_items'][$enrolment->class_code] = array(
                            'class_info' => (array) $enrolment,
                            'items' => $items
                        );
                    }
                }
            }
        }

        $this->load->view('layout/student/header', $data);
        $this->load->view('user/tvetportal/my_poe', $data);
        $this->load->view('layout/student/footer', $data);
    }

    /**
     * Check if current student is enrolled in a class
     */
    private function isEnrolledInClass($class_id)
    {
        if (!$this->student_id) {
            return false;
        }

        return $this->academic_enrolment_model->isEnrolled($this->student_id, $class_id);
    }
}
