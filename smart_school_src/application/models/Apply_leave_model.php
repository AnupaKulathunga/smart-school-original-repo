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

    // TVET: Updated to support both legacy (with carray/section_array) and new structure (with just id)
    public function get($id = null, $carray = null, $section_array = null)
    {
        $userdata = $this->customlib->getUserData();

        // If fetching by ID only (for detail view), use TVET structure
        if ($id != null && $carray == null && $section_array == null) {
            $this->db->select('student_applyleave.*,
                student_applyleave.status as apply_leave_status,
                students.firstname, students.middlename, students.lastname,
                students.id as stud_id, students.admission_no,
                staff.employee_id as staff_id, staff.name as staff_name, staff.surname,
                class.id as class_id, class.class_code, class.cohort_name,
                subjects.name as subject_name, subjects.code as subject_code,
                level.name as level_name, level.code as level_code')
                ->from('student_applyleave')
                ->join('student_session', 'student_session.id = student_applyleave.student_session_id')
                ->join('students', 'students.id = student_session.student_id', 'inner')
                ->join('staff', 'staff.id = student_applyleave.approve_by', 'left')
                ->join('enrolment', 'enrolment.student_id = students.id AND enrolment.session_id = student_session.session_id', 'left')
                ->join('class', 'enrolment.class_id = class.id', 'left')
                ->join('subject_level', 'class.subject_level_id = subject_level.id', 'left')
                ->join('subjects', 'subject_level.subject_id = subjects.id', 'left')
                ->join('level', 'subject_level.level_id = level.id', 'left');

            $this->db->where('student_applyleave.id', $id);
            $this->db->where('students.is_active', 'yes');
            $query = $this->db->get();
            return $query->row_array();
        }

        // Legacy structure for backward compatibility
        $class_section_array = $this->customlib->get_myClassSection();
        $this->db->select('student_applyleave.*,student_applyleave.status as `apply_leave_status`,students.firstname,students.middlename,students.lastname,staff.employee_id as staff_id,staff.name as staff_name,students.id as stud_id,students.admission_no as admission_no,staff.surname,classes.id as class_id,sections.id as section_id,classes.class,sections.section')->from('student_applyleave')
            ->join('student_session', 'student_session.id = student_applyleave.student_session_id')
            ->join('students', 'students.id=student_session.student_id', 'inner')
            ->join('staff', 'staff.id=student_applyleave.approve_by', 'left')
            ->join('staff_roles', 'staff_roles.staff_id=staff.id', 'left')
            ->join('classes', 'student_session.class_id = classes.id')
            ->join('sections', 'sections.id = student_session.section_id');
        $this->db->where('students.is_active', 'yes');

        if (!empty($class_section_array)) {
            $this->db->group_start();
            foreach ($class_section_array as $class_sectionkey => $class_sectionvalue) {
                $query_string = "";
                foreach ($class_sectionvalue as $class_sectionvaluekey => $class_sectionvaluevalue) {
                    $query_string = "( student_session.class_id=".$class_sectionkey." and student_session.section_id=".$class_sectionvaluevalue." )";
                    $this->db->or_where($query_string);
                }
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
            $this->db->where_in('classes.id', $carray);
        }

        if ($section_array != null) {
            $this->db->where_in('sections.id', $section_array);
        }

        if ($id != null) {
            $this->db->where('student_applyleave.id', $id);
        } else {
            $this->db->order_by('student_applyleave.id', 'desc');
        }

        $this->db->where('student_session.session_id', $this->current_session);

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

    // TVET: Get leave applications by class (using enrolment)
    public function getByClass($class_id = null)
    {
        $userdata = $this->customlib->getUserData();

        $this->db->select('student_applyleave.*,
            student_applyleave.status as apply_leave_status,
            students.firstname, students.middlename, students.lastname,
            students.id as stud_id, students.admission_no,
            staff.employee_id as staff_id, staff.name as staff_name, staff.surname,
            class.id as class_id, class.class_code, class.cohort_name,
            subjects.name as subject_name, subjects.code as subject_code,
            level.name as level_name, level.code as level_code')
            ->from('student_applyleave')
            ->join('student_session', 'student_session.id = student_applyleave.student_session_id')
            ->join('students', 'students.id = student_session.student_id', 'inner')
            ->join('enrolment', 'enrolment.student_id = students.id AND enrolment.session_id = '.$this->current_session, 'inner')
            ->join('staff', 'staff.id = student_applyleave.approve_by', 'left')
            ->join('staff_roles', 'staff_roles.staff_id = staff.id', 'left')
            ->join('class', 'enrolment.class_id = class.id')
            ->join('subject_level', 'class.subject_level_id = subject_level.id')
            ->join('subjects', 'subject_level.subject_id = subjects.id')
            ->join('level', 'subject_level.level_id = level.id');

        $this->db->where('students.is_active', 'yes');
        $this->db->where('enrolment.status', 'Active');

        if ($class_id != null) {
            $this->db->where('class.id', $class_id);
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

    public function get_student($student_session_id = null)
    {
        $this->db->select('student_applyleave.*,students.firstname,students.middlename,students.lastname,staff.name as staff_name,staff.surname,classes.id as class_id,sections.id as section_id,classes.class,sections.section')->from('student_applyleave')->join('student_session', 'student_session.id = student_applyleave.student_session_id')->join('students', 'students.id=student_session.student_id', 'inner')->join('staff', 'staff.id=student_applyleave.approve_by', 'left')->join('classes', 'student_session.class_id = classes.id')->join('sections', 'sections.id = student_session.section_id');
        $this->db->where('student_session.session_id', $this->current_session);
        $this->db->where('student_session.id', $student_session_id);
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

    public function get_studentsessionId($class_id, $section_id, $student_id)
    {
        $where['class_id']   = $class_id;
        $where['section_id'] = $section_id;
        $where['student_id'] = $student_id;

        return $this->db->select('id')->from('student_session')->where($where)->get()->row_array();
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
            ->from('class')
            ->where('id', $class_id)
            ->where('primary_lecturer_id', $staff_id)
            ->where('is_active', 1)
            ->get()->num_rows();

        if ($primary_lecturer > 0) {
            return 1;
        }

        return 0;
    }

    public function getclassteacherbyclasssection($class_id, $section_id)
    {
        $this->db->select('staff.email,staff.contact_no');
        $this->db->from('class_teacher');
        $this->db->join('staff', 'staff.id=class_teacher.staff_id');
        $this->db->where('class_teacher.class_id', $class_id);
        $this->db->where('class_teacher.section_id', $section_id);
        $this->db->where('staff.is_active', 1);
        $result = $this->db->get();
        return $result->result_array();
    }
    
    public function getstudentleave($id = null, $carray = null, $section_array = null)
    {        
        $this->db->select('student_applyleave.*,students.firstname,students.middlename,students.lastname,staff.employee_id as staff_id,staff.name as staff_name,students.id as stud_id,students.admission_no as admission_no,staff.surname,classes.id as class_id,sections.id as section_id,classes.class,sections.section')->from('student_applyleave')
            ->join('student_session', 'student_session.id = student_applyleave.student_session_id')
            ->join('students', 'students.id=student_session.student_id', 'inner')
            ->join('staff', 'staff.id=student_applyleave.approve_by', 'left')
            ->join('staff_roles', 'staff_roles.staff_id=staff.id', 'left')
            ->join('classes', 'student_session.class_id = classes.id')
            ->join('sections', 'sections.id = student_session.section_id');
        $this->db->where('students.is_active', 'yes');          
        
        if ($carray != null) {
            $this->db->where_in('classes.id', $carray);
        }

        if ($section_array != null) {
            $this->db->where_in('sections.id', $section_array);
        }

        if ($id != null) {
            $this->db->where('student_applyleave.id', $id);
        } else {
            $this->db->order_by('student_applyleave.id', 'desc');
        }

        $this->db->where('student_session.session_id', $this->current_session);

        $query = $this->db->get();
        if ($id != null) {
            $result= $query->row_array();
        } else {
            $result =$query->result_array();
        }
         
        return $result;
    }
	
	public function getStudentMonthlyLeave($start_date, $end_date)
    {       
        $this->db->select('student_applyleave.*,students.firstname,students.middlename,students.lastname')
		->from('student_applyleave')
		->join('student_session', 'student_session.id = student_applyleave.student_session_id')
		->join('students', 'students.id=student_session.student_id', 'inner');
        $this->db->where('student_session.session_id', $this->current_session);         
        $this->db->where('students.is_active', 'yes');
        $this->db->where('student_applyleave.from_date >= ', $start_date);
        $this->db->where('student_applyleave.from_date <=', $end_date);		
        $query = $this->db->get();
        return $query->result_array();
    }
	
	public function getStudentApproveMonthlyLeave($start_date, $end_date)
    {       
        $this->db->select('student_applyleave.*,students.firstname,students.middlename,students.lastname')
		->from('student_applyleave')
		->join('student_session', 'student_session.id = student_applyleave.student_session_id')
		->join('students', 'students.id=student_session.student_id', 'inner');
        $this->db->where('student_session.session_id', $this->current_session);         
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
