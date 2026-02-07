<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Examstudent_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
    }

    public function searchExamStudents($class_id, $section_id, $exam_id)
    {
        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname, students.middlename, students.lastname,students.image,    students.mobileno, students.email ,students.state ,   students.city , students.pincode ,     students.religion,     students.dob ,students.current_address,    students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code , students.guardian_name , students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender,IFNULL(exam_group_class_batch_exam_students.id, 0) as onlineexam_student_id,IFNULL(exam_group_class_batch_exam_students.student_session_id, 0) as onlineexam_student_session_id', FALSE)->from('students');
        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->join('exam_group_class_batch_exam_students', 'exam_group_class_batch_exam_students.student_session_id = e.id and exam_group_class_batch_exam_students.exam_group_class_batch_exam_id=' . $exam_id, 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('e.class_id', $class_id);
        $this->db->where('e.status', 'Active');
        $this->db->where('students.is_active', 'yes');
        $this->db->order_by('students.admission_no');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function add_exam_result($data)
    {
        $this->db->where('exam_schedule_id', $data['exam_schedule_id']);
        $this->db->where('student_id', $data['student_id']);
        $q      = $this->db->get('exam_results');
        $result = $q->row();
        if ($q->num_rows() > 0) {
            $this->db->where('id', $result->id);
            $this->db->update('exam_results', $data);
            if ($result->get_marks != $data['get_marks']) {
                return $result->id;
            }
        } else {
            $this->db->insert('exam_results', $data);
            $insert_id = $this->db->insert_id();
            return $insert_id;
        }
        return false;
    }

    public function add_student($insert_array, $exam_group_class_batch_exam_id, $all_students)
    {
        $delete_array   = array();
        $inserted_array = array();
        $this->db->trans_begin();
        if (!empty($insert_array)) {
            foreach ($insert_array as $insert_key => $insert_value) {
                $this->insert($insert_value);
                $inserted_array[] = $insert_value['student_session_id'];
            }
        }

        $delete_array = array_diff($all_students, $inserted_array);

        if (!empty($delete_array)) {
            $this->db->where('exam_group_class_batch_exam_id', $exam_group_class_batch_exam_id);
            $this->db->where_in('student_session_id', $delete_array);
            $this->db->delete('exam_group_class_batch_exam_students');
        }

        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            $this->db->trans_commit();
            return true;
        }
    }

    public function checkStudentExists($check_alreay_inserted_students, $exam_group_class_batch_exam_id)
    {
        $this->db->where('exam_group_class_batch_exam_id', $exam_group_class_batch_exam_id);
        $this->db->where_in('student_id', $check_alreay_inserted_students);
        $q      = $this->db->get('exam_group_class_batch_exam_students');
        $result = $q->result();
        return $result;
    }

    public function insert($insert_value)
    {
        $this->db->where('exam_group_class_batch_exam_id', $insert_value['exam_group_class_batch_exam_id']);
        $this->db->where('student_session_id', $insert_value['student_session_id']);
        $q = $this->db->get('exam_group_class_batch_exam_students');
        if ($q->num_rows() == 0) {
            $this->db->insert('exam_group_class_batch_exam_students', $insert_value);
        }
        return true;
    }

    public function getBatchStudentDetail($exam_group_class_batch_exam_student_id)
    {
        $sql = "SELECT exam_group_class_batch_exam_students.*,sessions.session, exam_group_class_batch_exams.exam,exam_group_class_batch_exams.session_id, students.admission_no , students.id as `student_id`, students.roll_no,students.admission_date,students.firstname,students.middlename, students.lastname,students.image, students.mobileno, students.email ,students.state , students.city , students.pincode , students.religion,students.dob ,students.current_address, students.permanent_address,students.category_id, IFNULL(categories.category, '') as `category`, students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code , students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active,`students`.`father_name`,`students`.`gender` FROM `exam_group_class_batch_exam_students` INNER join students on students.id=exam_group_class_batch_exam_students.student_id INNER JOIN exam_group_class_batch_exams on  exam_group_class_batch_exams.id=exam_group_class_batch_exam_students.exam_group_class_batch_exam_id LEFT JOIN `categories` ON `students`.`category_id` = `categories`.`id` INNER JOIN sessions on sessions.id=exam_group_class_batch_exams.session_id WHERE exam_group_class_batch_exam_students.id=" . $this->db->escape($exam_group_class_batch_exam_student_id);
        $query = $this->db->query($sql);
        return $query->row();
    }

    public function getStudentByExamAndStudentID($student_id, $exam_group_class_batch_exam_id)
    {
        $this->db->select()->from('exam_group_class_batch_exam_students');
        $this->db->where('student_id', $student_id);
        $this->db->where('exam_group_class_batch_exam_id', $exam_group_class_batch_exam_id);
        $query = $this->db->get();
        if ($query->num_rows() > 0) {
            return $query->row();
        }
        return false;
    }

    public function getStudentsAdmitCardByExamAndStudentID($students_array, $exam_group_class_batch_exam_id)
    {
        $sql     = "SELECT *  FROM `exam_group_class_batch_exam_students` where exam_group_class_batch_exam_id=" . $exam_group_class_batch_exam_id . " and (roll_no IS NULL OR 0)";
        $query   = $this->db->query($sql);
        $results = $query->result();
        if (!empty($results)) {
            $maxid = $this->db->query('SELECT MAX(roll_no) AS `maxid` FROM `exam_group_class_batch_exam_students` where exam_group_class_batch_exam_id=' . $exam_group_class_batch_exam_id)->row()->maxid;

            $student_update = array();
            if ($maxid == 0) {
                $update_roll_no = 100001;
            } else {
                $update_roll_no = $maxid + 1;
            }
            $update_student = array();
            foreach ($results as $res_key => $res_value) {
                $update_student[] = array('id' => $res_value->id, 'roll_no' => $update_roll_no);
                $update_roll_no++;
            }
            $this->db->update_batch('exam_group_class_batch_exam_students', $update_student, 'id');
        }

        $student_details = array();
        if (!empty($students_array)) {
            foreach ($students_array as $student_key => $student_value) {
                $student_details[] = $this->getStudentDetailsByExamAndStudentID($student_value, $exam_group_class_batch_exam_id);
            }
        }

        return $student_details;
    }

    public function getStudentDetailsByExamAndStudentID($student_id, $exam_group_class_batch_exam_id)
    {
        $sql = "SELECT exam_group_class_batch_exam_students.*,students.admission_no , students.id as `student_id`,students.admission_date,students.roll_no as `profile_roll_no`, students.firstname,students.middlename, students.lastname,students.image, students.mobileno, students.email ,students.state , students.city , students.pincode , students.religion,students.dob ,students.current_address, students.permanent_address,students.category_id, IFNULL(categories.category, '') as `category`, students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code , students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active,`students`.`father_name`,`students`.`mother_name`,`students`.`gender`,ac.class_code as class FROM `exam_group_class_batch_exam_students` INNER JOIN academic_class_enrolment e ON e.id=exam_group_class_batch_exam_students.student_session_id INNER JOIN students ON students.id=e.student_id LEFT JOIN `categories` ON `students`.`category_id` = `categories`.`id` INNER JOIN academic_class ac ON ac.id=e.class_id WHERE `exam_group_class_batch_exam_students`.`student_id` = " . $this->db->escape($student_id) . " AND `exam_group_class_batch_exam_students`.`exam_group_class_batch_exam_id` = " . $this->db->escape($exam_group_class_batch_exam_id);
        $query = $this->db->query($sql);
        return $query->row();
    }

    public function getStudentdetailByExam($student_id, $exam_group_class_batch_exam_id)
    {
        $sql = "SELECT exam_group_class_batch_exam_students.*,students.admission_no , students.roll_no,students.id as `student_id`,students.admission_date,students.firstname,students.middlename, students.lastname,students.image, students.mobileno, students.email ,students.state , students.city , students.pincode , students.religion,students.dob ,students.current_address, students.permanent_address,students.category_id, IFNULL(categories.category, '') as `category`, students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code , students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active,`students`.`father_name`,`students`.`mother_name`,`students`.`gender`,e.class_id,ac.class_code as class FROM `exam_group_class_batch_exam_students` INNER JOIN academic_class_enrolment e ON e.id=exam_group_class_batch_exam_students.student_session_id INNER JOIN students ON students.id=e.student_id LEFT JOIN `categories` ON `students`.`category_id` = `categories`.`id` INNER JOIN academic_class ac ON ac.id=e.class_id WHERE `exam_group_class_batch_exam_students`.`student_id` = " . $this->db->escape($student_id) . " AND `exam_group_class_batch_exam_students`.`exam_group_class_batch_exam_id` = " . $this->db->escape($exam_group_class_batch_exam_id);
        $query = $this->db->query($sql);
        return $query->row_array();
    }

    public function getExamStudentByID($exam_group_class_batch_exam_id)
    {
        $sql = "SELECT exam_group_class_batch_exam_students.*,students.admission_no , students.roll_no as `student_roll_no`,students.id as `student_id`,students.admission_date,students.firstname,students.middlename, students.lastname,students.image, students.mobileno, students.email ,students.state , students.city , students.pincode , students.religion,students.dob ,students.current_address, students.permanent_address,students.category_id, IFNULL(categories.category, '') as `category`, students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code , students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active,`students`.`father_name`,`students`.`mother_name`,`students`.`gender`,e.class_id,ac.class_code as class FROM `exam_group_class_batch_exam_students` INNER JOIN academic_class_enrolment e ON e.id=exam_group_class_batch_exam_students.student_session_id INNER JOIN students ON students.id=e.student_id LEFT JOIN `categories` ON `students`.`category_id` = `categories`.`id` INNER JOIN academic_class ac ON ac.id=e.class_id WHERE `exam_group_class_batch_exam_students`.`id` = " . $this->db->escape($exam_group_class_batch_exam_id);
        $query = $this->db->query($sql);
        return $query->row_array();
    }

    public function getstudentexam($admission_no)
    {
        $this->db->select('exam_group_class_batch_exams.exam,exam_group_class_batch_exams.passing_percentage,exam_group_class_batch_exams.id,exam_group_class_batch_exam_students.student_session_id,students.firstname,students.middlename, students.lastname,students.roll_no,students.admission_no,ac.class_code as class_name', FALSE)->from('exam_group_class_batch_exam_students')->join('exam_group_class_batch_exams', 'exam_group_class_batch_exams.id=exam_group_class_batch_exam_students.exam_group_class_batch_exam_id', "inner")->join('students', 'students.id=exam_group_class_batch_exam_students.student_id', "inner")->join('academic_class_enrolment e', 'e.id=exam_group_class_batch_exam_students.student_session_id', "inner")->join('academic_class ac', 'ac.id=e.class_id', "inner")->where('students.admission_no', $admission_no)->where('exam_group_class_batch_exams.session_id', $this->current_session);
        $query  = $this->db->get();
        $result = $query->result_array();
        return $result;
    }
    
    public function getstudentsessionidbyadmissionno($admission_no)
    {
        $this->db->select('e.id')->from('academic_class_enrolment e')->join('academic_class ac', 'ac.id = e.class_id', "inner")->join('students', 'students.id = e.student_id', "inner")->where('students.admission_no', $admission_no)->where('ac.session_id', $this->current_session)->where('e.status', 'Active');
        $query  = $this->db->get();
        $result = $query->row_array();
        return $result['id'];
    }

}
