<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Student Portal Attendance Controller
 *
 * TVET Academic Model Migration:
 * - Uses academic_enrolment_model for student class enrolments
 * - Uses academic_attendance_model for attendance records
 * - Students can be enrolled in multiple classes - shows attendance per class
 * - Replaces legacy class-section approach with enrolment-based access
 */
class Attendence extends Student_Controller
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Display attendance for a specific date across all enrolled classes
     * TVET: Gets attendance for all classes student is enrolled in on selected date
     *
     * Called via AJAX from attendenceSubject.php view
     */
    public function getdaysubattendence()
    {
        $date = $this->input->post('date');
        $date = date('Y-m-d', $this->customlib->datetostrtotime($this->input->post('date')));

        // TVET: Get student ID from session
        $student_id = $this->customlib->getStudentSessionUserID();
        $session_id = $this->setting_model->getCurrentSession();

        // TVET: Get attendance for this date across all enrolled classes
        $attendance_records = $this->academic_attendance_model->getStudentAttendanceByDate($student_id, $date);

        // TVET: Get list of enrolled classes to show even if no attendance marked
        $enrolled_classes = $this->academic_enrolment_model->getStudentClasses($student_id, $session_id);

        $result['attendence'] = $attendance_records;
        $result['enrolled_classes'] = $enrolled_classes;
        $result['selected_date'] = $date;

        $result_page = $this->load->view('user/attendence/_getdaysubattendence', $result, true);
        echo json_encode(array('status' => 1, 'result_page' => $result_page));
    }

    /**
     * Main attendance page
     * TVET: Loads student's enrolled classes and allows viewing attendance per class
     */
    public function index()
    {
        $this->session->set_userdata('top_menu', 'Attendence');
        $this->session->set_userdata('sub_menu', 'book/index');
        $data['title'] = 'Attendence List';

        // TVET: Get student ID and session
        $student_id = $this->customlib->getStudentSessionUserID();
        $session_id = $this->setting_model->getCurrentSession();

        // TVET: Get all classes the student is enrolled in
        $data['enrolled_classes'] = $this->academic_enrolment_model->getStudentClasses($student_id, $session_id);

        // Get selected class from query string (for filtering calendar view)
        $data['selected_class_id'] = $this->input->get('class_id');

        $setting_result = $this->setting_model->get();
        $setting_result = ($setting_result[0]);

        $session = $this->session->userdata('student');
        $data['language_shortcode'] = $this->language_model->get($session['language']['lang_id']);

        $this->load->view('layout/student/header');

        // TVET: For subject-based attendance (attendence_type = 1), show per-class attendance
        // For regular attendance (attendence_type = 0), show calendar with all classes
        if ($setting_result['attendence_type']) {
            $this->load->view('user/attendence/attendenceSubject', $data);
        } else {
            $this->load->view('user/attendence/attendenceIndex', $data);
        }

        $this->load->view('layout/student/footer');
    }

    /**
     * Get attendance records for calendar display
     * TVET: Returns attendance across all enrolled classes or filtered by class_id
     *
     * Called via AJAX from attendenceIndex.php fullcalendar
     */
    public function getAttendence()
    {
        $date['start'] = $this->input->get('start');
        $date['end'] = $this->input->get('end');
        $class_id = $this->input->get('class_id'); // Optional filter

        // TVET: Get student ID from session
        $student_id = $this->customlib->getStudentSessionUserID();

        $eventdata = array();

        // TVET: Get attendance for date range using academic_attendance_model
        $student_attendence_result = $this->academic_attendance_model->getStudentAttendanceRange(
            $student_id,
            $date['start'],
            $date['end'],
            $class_id
        );

        if (!empty($student_attendence_result)) {
            foreach ($student_attendence_result as $key => $student_attendence) {
                $status = $student_attendence->status;
                $attendance_date = $student_attendence->date;

                // TVET: Include class info in title for multi-class display
                $class_info = $student_attendence->subject_code . ' ' . $student_attendence->level_code;

                // Map TVET status values to calendar events
                // TVET statuses: Present, Absent, Late, Excused
                if ($status == 'Present') {
                    $eventdata[] = array(
                        'title' => $this->lang->line('present') . ' - ' . $class_info,
                        'start' => $attendance_date,
                        'end' => $attendance_date,
                        'description' => $student_attendence->notes,
                        'id' => $student_attendence->id,
                        'backgroundColor' => '#27ab00',
                        'borderColor' => '#27ab00',
                        'event_type' => 'Present',
                        'class_code' => $student_attendence->class_code
                    );
                } else if ($status == 'Absent') {
                    $eventdata[] = array(
                        'title' => $this->lang->line('absent') . ' - ' . $class_info,
                        'start' => $attendance_date,
                        'end' => $attendance_date,
                        'description' => $student_attendence->notes,
                        'id' => $student_attendence->id,
                        'backgroundColor' => '#fa2601',
                        'borderColor' => '#fa2601',
                        'event_type' => 'Absent',
                        'class_code' => $student_attendence->class_code
                    );
                } else if ($status == 'Late') {
                    $eventdata[] = array(
                        'title' => $this->lang->line('late') . ' - ' . $class_info,
                        'start' => $attendance_date,
                        'end' => $attendance_date,
                        'description' => $student_attendence->notes,
                        'id' => $student_attendence->id,
                        'backgroundColor' => '#ffeb00',
                        'borderColor' => '#ffeb00',
                        'event_type' => 'Late',
                        'class_code' => $student_attendence->class_code
                    );
                } else if ($status == 'Excused') {
                    // TVET: Excused status (similar to Late with excuse)
                    $eventdata[] = array(
                        'title' => $this->lang->line('excused') ?: 'Excused' . ' - ' . $class_info,
                        'start' => $attendance_date,
                        'end' => $attendance_date,
                        'description' => $student_attendence->notes,
                        'id' => $student_attendence->id,
                        'backgroundColor' => '#17a2b8',
                        'borderColor' => '#17a2b8',
                        'event_type' => 'Excused',
                        'class_code' => $student_attendence->class_code
                    );
                }
            }
        }

        echo json_encode($eventdata);
    }

    /**
     * Get attendance summary for all enrolled classes
     * TVET: Returns summary statistics per class
     *
     * New AJAX endpoint for dashboard/summary display
     */
    public function getSummary()
    {
        $student_id = $this->customlib->getStudentSessionUserID();
        $session_id = $this->setting_model->getCurrentSession();

        // TVET: Get all enrolled classes
        $enrolled_classes = $this->academic_enrolment_model->getStudentClasses($student_id, $session_id);

        $summary_data = array();

        foreach ($enrolled_classes as $class) {
            // Get attendance summary for each enrolment
            $summary = $this->academic_attendance_model->getStudentSummary($class->enrolment_id);

            $summary_data[] = array(
                'class_id' => $class->class_id,
                'class_code' => $class->class_code,
                'subject_name' => $class->subject_name,
                'subject_code' => $class->subject_code,
                'level_code' => $class->level_code,
                'total' => $summary->total,
                'present' => $summary->present,
                'absent' => $summary->absent,
                'late' => $summary->late,
                'excused' => $summary->excused,
                'percentage' => $summary->percentage
            );
        }

        echo json_encode(array('status' => 1, 'data' => $summary_data));
    }

    /**
     * Get calendar events (unchanged - for event display)
     */
    public function getevents()
    {
        $userdata = $this->customlib->getUserData();
        $result = $this->calendar_model->getEvents();
        $eventdata = array();

        if (!empty($result)) {
            foreach ($result as $key => $value) {
                $event_type = $value["event_type"];

                if ($event_type == 'private') {
                    $event_for = $userdata["id"];
                } else if ($event_type == 'sameforall') {
                    $event_for = $userdata["role_id"];
                } else if ($event_type == 'public') {
                    $event_for = "0";
                } else if ($event_type == 'task') {
                    $event_for = $userdata["id"];
                }

                if ($event_type == 'task') {
                    if (($event_for == $value["event_for"]) && ($value["role_id"] == $userdata["role_id"])) {
                        $eventdata[] = array(
                            'title' => $value["event_title"],
                            'start' => $value["start_date"],
                            'end' => $value["end_date"],
                            'description' => $value["event_description"],
                            'id' => $value["id"],
                            'backgroundColor' => $value["event_color"],
                            'borderColor' => $value["event_color"],
                            'event_type' => $value["event_type"],
                        );
                    }
                } else {
                    if ($event_for == $value["event_for"]) {
                        $eventdata[] = array(
                            'title' => $value["event_title"],
                            'start' => $value["start_date"],
                            'end' => $value["end_date"],
                            'description' => $value["event_description"],
                            'id' => $value["id"],
                            'backgroundColor' => $value["event_color"],
                            'borderColor' => $value["event_color"],
                            'event_type' => $value["event_type"],
                        );
                    } elseif ($event_type == 'protected') {
                        // Handle protected events if needed
                    }
                }
            }

            echo json_encode($eventdata);
        }
    }
}
