<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class apply_leave_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
        $this->current_date    = $this->setting_model->getDateYmd();
    }

    /**
     * TVET: Uses academic_class_enrolment (e) + academic_class (ac) instead of student_session + classes + sections.
     * student_applyleave.student_session_id now stores e.id (enrolment ID) for backward compatibility.
     * section_array param kept for signature compatibility but ignored.
     */
    public function get($id = null, $carray = null, $section_array = null)
    {
        $userdata = $this->customlib->getUserData();

        // If fetching by ID only (for detail view)
        if ($id != null && $carray == null && $section_array == null) {
            $this->db->select('student_applyleave.*,
                student_applyleave.status as apply_leave_status,
                students.firstname, students.middlename, students.lastname,
                students.id as stud_id, students.admission_no,
                staff.employee_id as staff_id, staff.name as staff_name, staff.surname,
                e.id as student_session_id,
                ac.id as class_id, ac.class_code, ac.cohort_name,
                subjects.name as subject_name, subjects.code as subject_code,
                level.name as level_name, level.code as level_code', FALSE)
                ->from('student_applyleave')
                ->join('academic_class_enrolment e', 'e.id = student_applyleave.student_session_id')
                ->join('students', 'students.id = e.student_id', 'inner')
                ->join('staff', 'staff.id = student_applyleave.approve_by', 'left')
                ->join('academic_class ac', 'ac.id = e.class_id', 'left')
                ->join('academic_subject_level', 'ac.subject_level_id = academic_subject_level.id', 'left')
                ->join('academic_subject as subjects', 'academic_subject_level.subject_id = subjects.id', 'left')
                ->join('academic_level as level', 'academic_subject_level.level_id = level.id', 'left');

            $this->db->where('student_applyleave.id', $id);
            $this->db->where('students.is_active', 'yes');
            $query = $this->db->get();
            return $query->row_array();
        }

        // TVET: Use academic_class_enrolment (e) + academic_class (ac) instead of student_session + classes + sections
        $class_section_array = $this->customlib->get_myClassSection();
        $this->db->select('student_applyleave.*,
            student_applyleave.status as `apply_leave_status`,
            students.firstname, students.middlename, students.lastname,
            staff.employee_id as staff_id, staff.name as staff_name,
            students.id as stud_id, students.admission_no as admission_no,
            staff.surname,
            e.id as student_session_id,
            ac.id as class_id, ac.class_code,
            CONCAT(subjects.name, " - ", level.name) as `class`,
            subjects.name as subject_name, level.name as level_name', FALSE)
            ->from('student_applyleave')
            ->join('academic_class_enrolment e', 'e.id = student_applyleave.student_session_id')
            ->join('students', 'students.id = e.student_id', 'inner')
            ->join('staff', 'staff.id = student_applyleave.approve_by', 'left')
            ->join('staff_roles', 'staff_roles.staff_id = staff.id', 'left')
            ->join('academic_class ac', 'ac.id = e.class_id')
            ->join('academic_subject_level', 'ac.subject_level_id = academic_subject_level.id')
            ->join('academic_subject as subjects', 'academic_subject_level.subject_id = subjects.id')
            ->join('academic_level as level', 'academic_subject_level.level_id = level.id');
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');

        if (!empty($class_section_array)) {
            $this->db->group_start();
            foreach ($class_section_array as $class_sectionkey => $class_sectionvalue) {
                $this->db->or_where('e.class_id', $class_sectionkey);
            }
            $this->db->group_end();
        }

        if ($this->session->has_userdata('admin')) {
            $getStaffRole = $this->customlib->getStaffRole();
            $staffrole = json_decode($getStaffRole);
            $superadmin_visible = $this->customlib->superadmin_visible();
            if ($superadmin_visible == 'disabled' && $staffrole->id != 7) {
                $this->db->group_start();
                $this->db->where("staff_roles.role_id !=", 7);
                $this->db->or_where('staff_roles.role_id is NULL', NULL, FALSE);
                $this->db->group_end();
            }
        }

        if ($carray != null) {
            $this->db->where_in('ac.id', $carray);
        }

        // section_array ignored in TVET mode

        if ($id != null) {
            $this->db->where('student_applyleave.id', $id);
        } else {
            $this->db->order_by('student_applyleave.id', 'desc');
        }

        $this->db->where('ac.session_id', $this->current_session);

        $query = $this->db->get();
        if ($id != null) {
            $result = $query->row_array();
        } else {
            $result = $query->result_array();
        }

        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $result = array();
        }

        return $result;
    }

    /**
     * TVET: Get leave applications by class using academic_class_enrolment (e) + academic_class (ac).
     * student_applyleave.student_session_id stores e.id (enrolment ID) for backward compatibility.
     */
    public function getByClass($class_id = null)
    {
        $userdata = $this->customlib->getUserData();

        $this->db->select('student_applyleave.*,
            student_applyleave.status as apply_leave_status,
            students.firstname, students.middlename, students.lastname,
            students.id as stud_id, students.admission_no,
            staff.employee_id as staff_id, staff.name as staff_name, staff.surname,
            e.id as student_session_id,
            ac.id as class_id, ac.class_code, ac.cohort_name,
            subjects.name as subject_name, subjects.code as subject_code,
            level.name as level_name, level.code as level_code', FALSE)
            ->from('student_applyleave')
            ->join('academic_class_enrolment e', 'e.id = student_applyleave.student_session_id')
            ->join('students', 'students.id = e.student_id', 'inner')
            ->join('staff', 'staff.id = student_applyleave.approve_by', 'left')
            ->join('staff_roles', 'staff_roles.staff_id = staff.id', 'left')
            ->join('academic_class ac', 'ac.id = e.class_id')
            ->join('academic_subject_level', 'ac.subject_level_id = academic_subject_level.id')
            ->join('academic_subject as subjects', 'academic_subject_level.subject_id = subjects.id')
            ->join('academic_level as level', 'academic_subject_level.level_id = level.id');

        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        $this->db->where('ac.session_id', $this->current_session);

        if ($class_id != null) {
            $this->db->where('ac.id', $class_id);
        }

        // Handle superadmin visibility
        if ($this->session->has_userdata('admin')) {
            $getStaffRole = $this->customlib->getStaffRole();
            $staffrole = json_decode($getStaffRole);
            $superadmin_visible = $this->customlib->superadmin_visible();
            if ($superadmin_visible == 'disabled' && $staffrole->id != 7) {
                $this->db->group_start();
                $this->db->where("staff_roles.role_id !=", 7);
                $this->db->or_where('staff_roles.role_id is NULL', NULL, FALSE);
                $this->db->group_end();
            }
        }

        $this->db->order_by('student_applyleave.id', 'desc');
        $query = $this->db->get();
        return $query->result_array();
    }

    /**
     * TVET: Uses academic_class_enrolment (e) + academic_class (ac) instead of student_session + classes + sections.
     * $student_session_id now refers to e.id (enrolment ID).
     */
    public function get_student($student_session_id = null)
    {
        $this->db->select('student_applyleave.*, students.firstname, students.middlename, students.lastname,
            staff.name as staff_name, staff.surname,
            e.id as student_session_id,
            ac.id as class_id, ac.class_code,
            CONCAT(subjects.name, " - ", level.name) as `class`,
            subjects.name as subject_name, level.name as level_name', FALSE)
            ->from('student_applyleave')
            ->join('academic_class_enrolment e', 'e.id = student_applyleave.student_session_id')
            ->join('students', 'students.id = e.student_id', 'inner')
            ->join('staff', 'staff.id = student_applyleave.approve_by', 'left')
            ->join('academic_class ac', 'ac.id = e.class_id')
            ->join('academic_subject_level', 'ac.subject_level_id = academic_subject_level.id')
            ->join('academic_subject as subjects', 'academic_subject_level.subject_id = subjects.id')
            ->join('academic_level as level', 'academic_subject_level.level_id = level.id');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('e.id', $student_session_id);
        $this->db->where('students.is_active', 'yes');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function add($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('student_applyleave', $data);
            $message   = UPDATE_RECORD_CONSTANT . " On  student apply leave id " . $data['id'];
            $action    = "Update";
            $record_id = $data['id'];
            $this->log($message, $record_id, $action);
            //======================Code End==============================

            $this->db->trans_complete(); # Completing transaction
            /* Optional */

            if ($this->db->trans_status() === false) {
                # Something went wrong.
                $this->db->trans_rollback();
                return false;
            } else {
                //return $return_value;
            }
        } else {
            $this->db->insert('student_applyleave', $data);
            $id        = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On student apply leave id " . $id;
            $action    = "Insert";
            $record_id = $id;
            $this->log($message, $record_id, $action);
            //======================Code End==============================

            $this->db->trans_complete(); # Completing transaction
            /* Optional */

            if ($this->db->trans_status() === false) {
                # Something went wrong.
                $this->db->trans_rollback();
                return false;
            } else {
                //return $return_value;
            }
            return $id;
        }
    }

    /**
     * TVET: Uses academic_class_enrolment instead of student_session.
     * section_id kept for signature compatibility but ignored.
     * Returns e.id (enrolment ID, used where student_session_id was previously used).
     */
    public function get_studentsessionId($class_id, $section_id, $student_id)
    {
        $where['class_id']   = $class_id;
        $where['student_id'] = $student_id;
        $where['status']     = 'Active';

        return $this->db->select('id')->from('academic_class_enrolment')->where($where)->get()->row_array();
    }

    public function remove_leave($id)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->where('id', $id);
        $this->db->delete('student_applyleave');
        $message   = DELETE_RECORD_CONSTANT . " On student apply leave id " . $id;
        $action    = "Delete";
        $record_id = $id;
        $this->log($message, $record_id, $action);
        //======================Code End==============================
        $this->db->trans_complete(); # Completing transaction
        /* Optional */
        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            //return $return_value;
        }
    }

    // TVET: Updated to work with class_id only (no section_id)
    public function canApproveLeave($staff_id, $class_id)
    {
        // Check if staff is lecturer for this class (TVET structure)
        $class_lecturer = $this->db->select('*')
            ->from('class_lecturer')
            ->where('class_id', $class_id)
            ->where('staff_id', $staff_id)
            ->where('is_active', 1)
            ->get()->num_rows();

        if ($class_lecturer > 0) {
            return 1;
        }

        // Also check if staff is primary lecturer for the class
        $primary_lecturer = $this->db->select('*')
            ->from('academic_class')
            ->where('id', $class_id)
            ->where('primary_lecturer_id', $staff_id)
            ->where('is_active', 1)
            ->get()->num_rows();

        if ($primary_lecturer > 0) {
            return 1;
        }

        return 0;
    }

    /**
     * TVET: Uses class_lecturer table instead of class_teacher. section_id ignored.
     * Also checks primary_lecturer_id on the academic_class table.
     */
    public function getclassteacherbyclasssection($class_id, $section_id = null)
    {
        // Get lecturers from class_lecturer table
        $this->db->select('staff.email, staff.contact_no');
        $this->db->from('class_lecturer');
        $this->db->join('staff', 'staff.id = class_lecturer.staff_id');
        $this->db->where('class_lecturer.class_id', $class_id);
        $this->db->where('class_lecturer.is_active', 1);
        $this->db->where('staff.is_active', 1);
        $result = $this->db->get();
        $lecturers = $result->result_array();

        // Also get primary lecturer from academic_class table
        $this->db->select('staff.email, staff.contact_no');
        $this->db->from('academic_class');
        $this->db->join('staff', 'staff.id = academic_class.primary_lecturer_id');
        $this->db->where('academic_class.id', $class_id);
        $this->db->where('staff.is_active', 1);
        $primary = $this->db->get()->result_array();

        return array_merge($lecturers, $primary);
    }

    /**
     * TVET: Uses academic_class_enrolment (e) + academic_class (ac) instead of student_session + classes + sections.
     * section_array param kept for signature compatibility but ignored.
     */
    public function getstudentleave($id = null, $carray = null, $section_array = null)
    {
        $this->db->select('student_applyleave.*, students.firstname, students.middlename, students.lastname,
            staff.employee_id as staff_id, staff.name as staff_name,
            students.id as stud_id, students.admission_no as admission_no,
            staff.surname,
            e.id as student_session_id,
            ac.id as class_id, ac.class_code,
            CONCAT(subjects.name, " - ", level.name) as `class`,
            subjects.name as subject_name, level.name as level_name', FALSE)
            ->from('student_applyleave')
            ->join('academic_class_enrolment e', 'e.id = student_applyleave.student_session_id')
            ->join('students', 'students.id = e.student_id', 'inner')
            ->join('staff', 'staff.id = student_applyleave.approve_by', 'left')
            ->join('staff_roles', 'staff_roles.staff_id = staff.id', 'left')
            ->join('academic_class ac', 'ac.id = e.class_id')
            ->join('academic_subject_level', 'ac.subject_level_id = academic_subject_level.id')
            ->join('academic_subject as subjects', 'academic_subject_level.subject_id = subjects.id')
            ->join('academic_level as level', 'academic_subject_level.level_id = level.id');
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');

        if ($carray != null) {
            $this->db->where_in('ac.id', $carray);
        }

        // section_array ignored in TVET mode

        if ($id != null) {
            $this->db->where('student_applyleave.id', $id);
        } else {
            $this->db->order_by('student_applyleave.id', 'desc');
        }

        $this->db->where('ac.session_id', $this->current_session);

        $query = $this->db->get();
        if ($id != null) {
            $result = $query->row_array();
        } else {
            $result = $query->result_array();
        }

        return $result;
    }

    /**
     * TVET: Uses academic_class_enrolment (e) + academic_class (ac) instead of student_session.
     */
    public function getStudentMonthlyLeave($start_date, $end_date)
    {
        $this->db->select('student_applyleave.*, students.firstname, students.middlename, students.lastname')
            ->from('student_applyleave')
            ->join('academic_class_enrolment e', 'e.id = student_applyleave.student_session_id')
            ->join('academic_class ac', 'ac.id = e.class_id')
            ->join('students', 'students.id = e.student_id', 'inner');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('student_applyleave.from_date >= ', $start_date);
        $this->db->where('student_applyleave.from_date <=', $end_date);
        $query = $this->db->get();
        return $query->result_array();
    }

    /**
     * TVET: Uses academic_class_enrolment (e) + academic_class (ac) instead of student_session.
     */
    public function getStudentApproveMonthlyLeave($start_date, $end_date)
    {
        $this->db->select('student_applyleave.*, students.firstname, students.middlename, students.lastname')
            ->from('student_applyleave')
            ->join('academic_class_enrolment e', 'e.id = student_applyleave.student_session_id')
            ->join('academic_class ac', 'ac.id = e.class_id')
            ->join('students', 'students.id = e.student_id', 'inner');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('student_applyleave.approve_date >= ', $start_date);
        $this->db->where('student_applyleave.approve_date <=', $end_date);
        $this->db->where('student_applyleave.status', 1);
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getStaffMonthlyLeave($start_date, $end_date)
    {
        $this->db->select('staff_leave_request.*,staff.name,staff.surname')
        ->from('staff_leave_request')
        ->join('staff', 'staff.id=staff_leave_request.staff_id', 'inner');
        $this->db->where('staff.is_active', '1');
        $this->db->where('staff_leave_request.leave_from >= ', $start_date);
        $this->db->where('staff_leave_request.leave_to <=', $end_date);
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getStaffApproveMonthlyLeave($start_date, $end_date)
    {
        $this->db->select('staff_leave_request.*,staff.name,staff.surname')
        ->from('staff_leave_request')
        ->join('staff', 'staff.id=staff_leave_request.staff_id', 'inner');
        $this->db->where('staff.is_active', '1');
        $this->db->where('staff_leave_request.approve_date >= ', $start_date);
        $this->db->where('staff_leave_request.approve_date <=', $end_date);
        $this->db->where('staff_leave_request.status','approved');
        $query = $this->db->get();
        return $query->result_array();
    }

}
