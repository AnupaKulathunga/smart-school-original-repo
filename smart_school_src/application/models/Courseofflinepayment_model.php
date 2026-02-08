<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Courseofflinepayment_model extends MY_Model {

    public function __construct() {
        parent::__construct();
        $this->role = '';
        $this->current_session = null;
    }

    private function _getRole() {
        if (empty($this->role) && !empty($this->session->userdata('student'))) {
            $this->role = $this->session->userdata('student')['role'];
        }
        return $this->role;
    }

    private function _getSession() {
        if ($this->current_session === null && isset($this->setting_model)) {
            $this->current_session = $this->setting_model->getCurrentSession();
        }
        return $this->current_session;
    }

    /*
    This is used to get all class list by session
    */
    public function classlist($sessionid) {
        return $this->classmodel_model->getClassesBySession($sessionid);
    }

    /*
    This is used to get student list by academic class
    */
    public function studentlist($academic_class_id) {
        $this->db->select('students.id,students.firstname,students.lastname,students.admission_no');
        $this->db->from('student_session');
        $this->db->join('academic_class_enrolment', 'academic_class_enrolment.student_session_id = student_session.id');
        $this->db->join('students','students.id=student_session.student_id');
        $this->db->where('students.is_active', 'yes');
        $this->db->where('academic_class_enrolment.class_id', $academic_class_id);
        $this->db->where('student_session.session_id', $this->_getSession());
        $query = $this->db->get();
        return $query->result_array();
    }

    /*
    This is used to get course list by academic class
    */
    public function courselist($academic_class_id) {
        $this->datatables
                ->select('online_courses.*')->from('online_course_academic_class')
                ->join('online_courses','online_courses.id=online_course_academic_class.course_id', 'inner')
                ->searchable('title,course_provider,price')
                ->orderable('title,course_provider,"","","","",price,"","" ')
                ->where(array('online_course_academic_class.academic_class_id'=> $academic_class_id, 'online_courses.free_course' =>'0', 'online_courses.status' =>'1'));
        return $this->datatables->generate('json');
    }

    /*
    This is used to get course list for print the course payment detail
    */
    public function courseprint($courseid,$studentid)
    {
        $role = $this->_getRole();
        if($role=='guest'){
            $this->db->select('online_courses.title,online_course_payment.paid_amount,online_course_payment.payment_type,online_course_payment.transaction_id,online_course_payment.date,online_course_payment.payment_mode,online_course_payment.note,online_course_payment.date,CONCAT(academic_subject.name, " - ", academic_level.code) as class,guest.guest_name as firstname,guest.guest_unique_id as admission_no,online_course_payment.id as receipt_number', FALSE);
            $this->db->from('online_course_payment');
            $this->db->join('online_courses', 'online_courses.id = online_course_payment.online_courses_id');
            $this->db->join('online_course_academic_class', 'online_course_academic_class.course_id = online_course_payment.online_courses_id', 'left');
            $this->db->join('academic_class', 'academic_class.id = online_course_academic_class.academic_class_id', 'left');
            $this->db->join('academic_subject_level', 'academic_subject_level.id = academic_class.subject_level_id', 'left');
            $this->db->join('academic_subject', 'academic_subject.id = academic_subject_level.subject_id', 'left');
            $this->db->join('academic_level', 'academic_level.id = academic_subject_level.level_id', 'left');
            $this->db->join('guest', 'guest.id = online_course_payment.guest_id');
            $this->db->where('online_course_payment.online_courses_id',$courseid);
            $this->db->where('online_course_payment.guest_id',$studentid);
            $query = $this->db->get();
            return $query->row_array();
        }else{
            $this->db->select('online_courses.title,online_course_payment.paid_amount,online_course_payment.payment_type,online_course_payment.transaction_id,online_course_payment.date,online_course_payment.payment_mode,online_course_payment.date,online_course_payment.note,CONCAT(academic_subject.name, " - ", academic_level.code) as class,students.firstname,students.lastname,students.father_name,students.admission_no,online_course_payment.id as receipt_number', FALSE);
            $this->db->from('online_course_payment');
            $this->db->join('online_courses', 'online_courses.id = online_course_payment.online_courses_id');
            $this->db->join('online_course_academic_class', 'online_course_academic_class.course_id = online_course_payment.online_courses_id', 'left');
            $this->db->join('academic_class', 'academic_class.id = online_course_academic_class.academic_class_id', 'left');
            $this->db->join('academic_subject_level', 'academic_subject_level.id = academic_class.subject_level_id', 'left');
            $this->db->join('academic_subject', 'academic_subject.id = academic_subject_level.subject_id', 'left');
            $this->db->join('academic_level', 'academic_level.id = academic_subject_level.level_id', 'left');
            $this->db->join('students', 'students.id = online_course_payment.student_id');
            $this->db->where('online_course_payment.online_courses_id',$courseid);
            $this->db->where('online_course_payment.student_id',$studentid);
            $query = $this->db->get();
            return $query->row_array();
        }
    }

    /*
    This is used to check payment status is paid or not
    */
    public function paymentstatus($courseid,$studentid) {
        $this->db->select('*');
        $this->db->from('online_course_payment');
        $this->db->where('online_course_payment.online_courses_id',$courseid);
        $this->db->where('online_course_payment.student_id',$studentid);
        $query = $this->db->get();
        if($query->num_rows() > 0){
            return false;
        }else{
            return true;
        }
    }

    /*
    This is used to check paid status of payment
    */
    public function paidstatus($courseid,$studentid) {

        if($this->_getRole() =='guest'){
            $this->db->where('online_course_payment.guest_id',$studentid);
        }else{
            $this->db->where('online_course_payment.student_id',$studentid);
        }
        $this->db->select('*');
        $this->db->from('online_course_payment');
        $this->db->where('online_course_payment.online_courses_id',$courseid);
        $query = $this->db->get();
        if($query->num_rows() > 0){
            return 1;
        }else{
            return 0;
        }
    }

    /*
    This is used to revert course (delete)
    */
    public function delete($courseid,$studentid) {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->where('online_courses_id', $courseid);
        $this->db->where('student_id', $studentid);
        $this->db->delete('online_course_payment');
        $this->db->where('course_id', $courseid);
        $this->db->where('student_id', $studentid);
        $this->db->delete('course_progress');
        $message   = DELETE_RECORD_CONSTANT . " On online courses payment and course progress table where course id " . $courseid. " and student id " .$studentid;
        $action    = "Delete";
        $record_id = $courseid.' '.$studentid;
        $this->log($message, $record_id, $action);
        $this->db->trans_complete();
        if ($this->db->trans_status() === false) {
            return false;
        } else {
            return true;
        }
    }
    
    /*
    This is used to check paid status of payment
    */
    public function getpaidstatus($courseid,$studentid) 
    {        
        $this->db->select('*');
        $this->db->from('online_course_payment');
        $this->db->where('online_course_payment.online_courses_id',$courseid);
        $this->db->where('online_course_payment.student_id',$studentid);
        $query = $this->db->get();       
        return $query->row_array(); 
    }

}