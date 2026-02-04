<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * TVET Student Attendance Controller
 * REFACTORED: Removed section_id, uses CLASS-only architecture
 * Uses enrolment_id instead of student_session_id
 */
class Stuattendence extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();

        $this->config->load("mailsms");
        $this->load->library('mailsmsconf');
        $this->config_attendance = $this->config->item('attendence');
        $this->load->model(array("classteacher_model",'class_section_time_model','studentAttendaceSetting_model'));
        $this->sch_setting_detail = $this->setting_model->getSetting();
    }

    /**
     * Main attendance marking interface
     * TVET: Uses class_id only (no section_id)
     */
    public function index()
    {
        if (!$this->rbac->hasPrivilege('student_attendance', 'can_view')) {
            access_denied();
        }

        $this->session->set_userdata('top_menu', 'Attendance');
        $this->session->set_userdata('sub_menu', 'stuattendence/index');

        $data['sch_setting'] = $this->sch_setting_detail;
        $data['class_id'] = "";
        $data['date'] = "";
        $is_first_time_attendance = true;

        // Get TVET classes for current session
        $session_id = $this->setting_model->getCurrentSession();
        $classlist = $this->classmodel_model->getClassesBySession($session_id);
        $data['classlist'] = $classlist;

        // TVET: Only class_id and date required (NO section_id)
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('date', $this->lang->line('date'), 'trim|required|xss_clean');

        if ($this->form_validation->run() == false) {
            $this->load->view('layout/header', $data);
            $this->load->view('admin/stuattendence/attendenceList', $data);
            $this->load->view('layout/footer', $data);
        } else {
            $class_id = $this->input->post('class_id');
            $date = $this->input->post('date');
            $data['class_id'] = $class_id;
            $data['date'] = $date;

            // Get class info (includes subject, level, cohort)
            $class_info = $this->classmodel_model->getClassById($class_id);
            $data['class_info'] = $class_info;

            // Get attendance settings for this class
            $student_class_setting = $this->studentAttendaceSetting_model->getClassWiseAttendanceSettingByClass($class_id);
            $data['student_class_setting'] = $student_class_setting;

            // Get attendance types
            $attendencetypes = $this->attendencetype_model->get();
            $data['attendencetypeslist'] = $attendencetypes;

            // Get students enrolled in this class with their attendance
            $date_formatted = date('Y-m-d', $this->customlib->datetostrtotime($date));
            $resultlist = $this->stuattendence_model->getAttendanceByClass($class_id, $date_formatted);
            $data['resultlist'] = $resultlist;

            // Check if this is first time attendance
            if (!empty($resultlist)) {
                foreach ($resultlist as $key => $value) {
                    if (!IsNullOrEmptyString($value['attendence_type_id'])) {
                        $is_first_time_attendance = false;
                    }
                }
            }

            // SAVE ATTENDANCE
            if ($this->input->post('search') == "saveattendence") {
                // TVET: Use enrolment array (not student_session)
                $enrolment_array = $this->input->post('enrolment');
                $attendance_array = [];
                $absent_student_list = [];
                $present_student_list = [];

                foreach ($enrolment_array as $enrolment_id => $value) {
                    $checkForUpdate = $this->input->post('attendendence_id' . $enrolment_id);
                    $attendencetype = $this->input->post('attendencetype' . $enrolment_id);

                    // Handle time for absent/holiday
                    if ($attendencetype == 4 || $attendencetype == 5) { // 4=absent, 5=holiday
                        $in_time = null;
                        $out_time = null;
                    } else {
                        $in_time = date('H:i:s', strtotime($this->input->post("in_time_" . $enrolment_id)));
                        $out_time = date('H:i:s', strtotime($this->input->post("out_time_" . $enrolment_id)));
                    }

                    $absent_config = $this->config_attendance['absent'];

                    // Track absent students for notifications
                    if ($attendencetype == $absent_config) {
                        $absent_student_list[] = $enrolment_id;
                    } else if (
                        ($attendencetype == $this->config_attendance["present"]
                        || $attendencetype == $this->config_attendance["late"]
                        || $attendencetype == $this->config_attendance["half_day"]
                        || $attendencetype == $this->config_attendance["half_day_second_shift"])
                        && $this->input->post('is_first_time_attendance')
                    ) {
                        $present_student_list['enrolments'][$enrolment_id] = $enrolment_id;
                        $present_student_list['in_time'][$enrolment_id] = $this->input->post("in_time_" . $enrolment_id);
                    }

                    // TVET: Use enrolment_id (not student_session_id)
                    $attendance_array[] = array(
                        'enrolment_id' => $enrolment_id,
                        'attendence_type_id' => $attendencetype,
                        'remark' => $this->input->post("remark" . $enrolment_id),
                        'in_time' => $in_time,
                        'out_time' => $out_time,
                        'date' => $date_formatted,
                    );
                }

                // Save attendance
                $this->stuattendence_model->addorUpdate($attendance_array);

                // Send notifications
                if (!empty($absent_student_list)) {
                    $this->mailsmsconf->mailsms('student_absent_attendence', $absent_student_list, $date);
                }

                if (!empty($present_student_list)) {
                    $this->mailsmsconf->mailsms('student_present_attendence', $present_student_list, $date);
                }

                $this->session->set_flashdata('msg', '<div class="alert alert-success text-left">' . $this->lang->line('success_message') . '</div>');
                redirect('admin/stuattendence/index', 'refresh');
            }

            $data['is_first_time_attendance'] = $is_first_time_attendance;
            $data['resultlist'] = $resultlist;

            $this->load->view('layout/header', $data);
            $this->load->view('admin/stuattendence/attendenceList', $data);
            $this->load->view('layout/footer', $data);
        }
    }

    /**
     * Attendance report view/edit
     * TVET: Uses class_id only (no section_id)
     */
    public function attendencereport()
    {
        if (!$this->rbac->hasPrivilege('attendance_by_date', 'can_view')) {
            access_denied();
        }

        $this->session->set_userdata('top_menu', 'Attendance');
        $this->session->set_userdata('sub_menu', 'stuattendence/attendenceReport');

        $data['title'] = 'Attendance Report';
        $data['title_list'] = 'Attendance Report List';
        $data['class_id'] = "";
        $data['date'] = "";

        // Get TVET classes for current session
        $session = $this->session_model->get_current_session();
        $userdata = $this->customlib->getUserData();
        $role_id = $userdata["role_id"];

        // If teacher, get only their classes
        if (isset($role_id) && ($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            $classlist = $this->classmodel_model->getClassesByLecturer($userdata["id"], $session['id']);
        } else {
            $classlist = $this->classmodel_model->getClassesBySession($session['id']);
        }

        $data['classlist'] = $classlist;

        // TVET: Only class_id and date required (NO section_id)
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('date', $this->lang->line('date'), 'trim|required|xss_clean');

        if ($this->form_validation->run() == false) {
            $this->load->view('layout/header', $data);
            $this->load->view('admin/stuattendence/attendencereport', $data);
            $this->load->view('layout/footer', $data);
        } else {
            $class_id = $this->input->post('class_id');
            $date = $this->input->post('date');
            $data['class_id'] = $class_id;
            $data['date'] = $date;
            $search = $this->input->post('search');

            // Get class info
            $class_info = $this->classmodel_model->getClassById($class_id);
            $data['class_info'] = $class_info;

            // SAVE ATTENDANCE (if requested)
            if ($search == "saveattendence") {
                $enrolment_array = $this->input->post('enrolment');

                foreach ($enrolment_array as $enrolment_id => $value) {
                    $checkForUpdate = $this->input->post('attendendence_id' . $enrolment_id);

                    if ($checkForUpdate != 0) {
                        // Update existing
                        $arr = array(
                            'id' => $checkForUpdate,
                            'enrolment_id' => $enrolment_id,
                            'attendence_type_id' => $this->input->post('attendencetype' . $enrolment_id),
                            'date' => date('Y-m-d', $this->customlib->datetostrtotime($date)),
                        );
                        $this->stuattendence_model->add($arr);
                    } else {
                        // Insert new
                        $arr = array(
                            'enrolment_id' => $enrolment_id,
                            'attendence_type_id' => $this->input->post('attendencetype' . $enrolment_id),
                            'date' => date('Y-m-d', $this->customlib->datetostrtotime($date)),
                        );
                        $this->stuattendence_model->add($arr);
                    }
                }
            }

            // Get attendance types
            $attendencetypes = $this->attendencetype_model->get();
            $data['attendencetypeslist'] = $attendencetypes;

            // Get attendance data
            $date_formatted = date('Y-m-d', $this->customlib->datetostrtotime($date));
            $resultlist = $this->stuattendence_model->getAttendanceByClass($class_id, $date_formatted);

            $data['resultlist'] = $resultlist;
            $data['sch_setting'] = $this->sch_setting_detail;

            $this->load->view('layout/header', $data);
            $this->load->view('admin/stuattendence/attendencereport', $data);
            $this->load->view('layout/footer', $data);
        }
    }

    /**
     * Get monthly attendance for a student
     * No changes needed - works with enrolment_id
     */
    public function monthAttendance($st_month, $no_of_months, $student_id)
    {
        $record = array();
        $r = array();
        $month = date('m', strtotime($st_month));
        $year = date('Y', strtotime($st_month));

        foreach ($this->config_attendance as $att_key => $att_value) {
            $s = $this->stuattendence_model->count_attendance_obj($month, $year, $student_id, $att_value);
            $attendance_key = $att_key;
            $r[$attendance_key] = $s;
        }

        $record[$student_id] = $r;
        return $record;
    }

    /**
     * Save class time settings
     * TVET: Updated to use class_id instead of class_section_id
     */
    public function saveclasstime()
    {
        $this->form_validation->set_rules('row[]', $this->lang->line('class'), 'trim|required|xss_clean');
        $class_ids = $this->input->post('class_id');
        $time_valid = true;

        if (!empty($class_ids) && isset($class_ids)) {
            foreach ($class_ids as $class_id_key => $class_id_value) {
                if ($class_id_value == "") {
                    $this->form_validation->set_rules('time', $this->lang->line('time'), 'trim|required|xss_clean');
                    $time_valid = false;
                    break;
                }
            }
        }

        if ($this->form_validation->run() == false) {
            $msg = array(
                'row' => form_error('row')
            );
            if (!$time_valid) {
                $msg['time'] = form_error('time');
            }

            $array = array('status' => 0, 'error' => $msg, 'message' => '');
        } else {
            $insert_data = array();
            $update_data = array();

            $prev_records = $this->input->post('prev_record_id');

            if (!empty($class_ids) && isset($class_ids)) {
                foreach ($class_ids as $class_id_key => $class_id_value) {
                    if ($prev_records[$class_id_key] > 0) {
                        $update_data[] = array(
                            'id' => $prev_records[$class_id_key],
                            'class_id' => $class_id_key,
                            'time' => $this->customlib->timeFormat($class_id_value, true),
                        );
                    } else {
                        $insert_data[] = array(
                            'class_id' => $class_id_key,
                            'time' => $this->customlib->timeFormat($class_id_value, true),
                        );
                    }
                }
            }

            $this->class_section_time_model->add($insert_data, $update_data);

            $array = array('status' => 1, 'message' => $this->lang->line('success_message'));
        }

        echo json_encode($array);
    }

    /**
     * Save student attendance settings
     * TVET: Updated to use class_id instead of class_section_id
     */
    public function savestudentsetting()
    {
        $this->form_validation->set_rules('row[]', $this->lang->line('row'), 'trim|required|xss_clean');
        $row = $this->input->post('row');
        $time_valid = true;

        if (!empty($row) && isset($row)) {
            foreach ($row as $row_key => $row_value) {
                $attendance_type = $this->input->post('attendance_type_id_' . $row_value);
                $class_id = $this->input->post('class_id_' . $row_value);
                $entry_time_from = $this->input->post('entry_time_from_' . $row_value);
                $entry_time_to = $this->input->post('entry_time_to_' . $row_value);
                $total_institute_hour = $this->input->post('total_institute_hour_' . $row_value);

                if ($class_id == "" || $entry_time_from == "" || $entry_time_to == "" || $total_institute_hour == "" || $attendance_type == "") {
                    $this->form_validation->set_rules(
                        'fields',
                        'fields',
                        'trim|required|xss_clean',
                        array('required' => $this->lang->line('fields_values_required'))
                    );
                    $time_valid = false;
                    break;
                }
            }
        }

        if ($this->form_validation->run() == false) {
            $msg = array(
                'row' => form_error('row'),
                'fields' => form_error('fields')
            );

            $array = array('status' => 0, 'error' => $msg, 'message' => '');
        } else {
            $insert_array = array();
            $class_array = array();

            foreach ($row as $row_key => $row_value) {
                $class_id = $this->input->post('class_id_' . $row_value);
                $class_array[] = $class_id;

                $attendance_type = $this->input->post('attendance_type_id_' . $row_value);
                $entry_time_from = $this->input->post('entry_time_from_' . $row_value);
                $entry_time_to = $this->input->post('entry_time_to_' . $row_value);
                $total_institute_hour = $this->input->post('total_institute_hour_' . $row_value);

                $insert_array[] = array(
                    'attendence_type_id' => $attendance_type,
                    'class_id' => $class_id,
                    'entry_time_from' => $entry_time_from,
                    'entry_time_to' => $entry_time_to,
                    'total_institute_hour' => $total_institute_hour
                );
            }

            $this->studentAttendaceSetting_model->add($insert_array, $class_array);
            $array = array('status' => 1, 'message' => $this->lang->line('update_message'));
        }

        echo json_encode($array);
    }
}
