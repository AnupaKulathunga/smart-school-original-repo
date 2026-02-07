<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Examgroupstudent_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
    }

    // ============================================================================
    // TVET Model — academic_class_enrolment (alias e) + academic_class (alias ac)
    // No student_session table, no section_id, no classes/sections tables
    // e.status = 'Active' replaces ss.is_active = 'yes'
    // e.id aliased as student_session_id for backward compatibility
    // ============================================================================

    /**
     * Search exam students by exam ID only (no class/section filter)
     *
     * @param int $exam_id Exam ID
     * @return array List of students in the exam
     */
    public function searchExamStudentsByExam($exam_id)
    {
        $sql = "SELECT exam_group_class_batch_exam_students.id as `exam_group_class_batch_exam_student_id`,
                       exam_group_class_batch_exam_students.rank,
                       exam_group_class_batch_exam_students.roll_no as `exam_roll_no`,
                       exam_group_class_batch_exam_students.teacher_remark,
                       students.admission_no, students.id as `student_id`, students.roll_no,
                       students.admission_date, students.firstname, students.middlename, students.lastname,
                       students.image, students.mobileno, students.email, students.state, students.city,
                       students.pincode, students.religion, students.dob, students.current_address,
                       students.permanent_address, students.category_id,
                       IFNULL(categories.category, '') as `category`,
                       students.adhar_no, students.samagra_id, students.bank_account_no, students.bank_name,
                       students.ifsc_code, students.guardian_name, students.guardian_relation,
                       students.guardian_phone, students.guardian_email,
                       ac.class_code as `class`,
                       students.guardian_address, students.is_active, students.father_name, students.gender,
                       students.app_key, students.parent_app_key,
                       exam_group_class_batch_exam_students.rank
                FROM exam_group_class_batch_exam_students
                INNER JOIN academic_class_enrolment e ON e.id = exam_group_class_batch_exam_students.student_session_id
                INNER JOIN students ON students.id = e.student_id
                INNER JOIN academic_class ac ON ac.id = e.class_id
                LEFT JOIN categories ON students.category_id = categories.id
                WHERE exam_group_class_batch_exam_id = " . $this->db->escape($exam_id) . "
                  AND e.status = 'Active'
                ORDER BY exam_group_class_batch_exam_students.rank ASC";
        $query = $this->db->query($sql);
        return $query->result();
    }

    /**
     * Search exam students by class (TVET)
     *
     * @param int $exam_group_id Exam group ID
     * @param int $exam_id Exam ID
     * @param int $class_id academic_class.id
     * @param int $session_id Session ID
     * @return array List of students in the exam
     */
    public function searchExamStudentsByClass($exam_group_id, $exam_id, $class_id, $session_id)
    {
        $sql = "SELECT exam_group_class_batch_exam_students.id as exam_group_class_batch_exam_student_id,
                       exam_group_class_batch_exam_students.rank,
                       exam_group_class_batch_exam_students.roll_no as exam_roll_no,
                       students.admission_no, students.id as student_id, students.roll_no,
                       students.admission_date, students.firstname, students.middlename, students.lastname,
                       students.image, students.mobileno, students.email, students.state, students.city,
                       students.pincode, students.religion, students.dob, students.current_address,
                       students.permanent_address, students.category_id,
                       IFNULL(categories.category, '') as category,
                       students.adhar_no, students.samagra_id, students.bank_account_no, students.bank_name,
                       students.ifsc_code, students.guardian_name, students.guardian_relation,
                       students.guardian_phone, students.guardian_address, students.is_active,
                       students.father_name, students.gender,
                       ac.class_code, ac.cohort_name
                FROM exam_group_class_batch_exam_students
                INNER JOIN academic_class_enrolment e ON e.id = exam_group_class_batch_exam_students.student_session_id
                INNER JOIN students ON students.id = e.student_id
                INNER JOIN academic_class ac ON ac.id = e.class_id
                LEFT JOIN categories ON students.category_id = categories.id
                WHERE exam_group_class_batch_exam_id = " . $this->db->escape($exam_id) . "
                  AND e.status = 'Active'
                  AND e.class_id = " . $this->db->escape($class_id) . "
                  AND ac.session_id = " . $this->db->escape($session_id) . "
                ORDER BY students.firstname ASC";

        $query = $this->db->query($sql);
        return $query->result();
    }

    /**
     * Search exam group students by class (TVET)
     *
     * @param int $exam_group_id Exam group ID
     * @param int $class_id academic_class.id
     * @param int $session_id Session ID
     * @return array List of students with exam group assignment status
     */
    public function searchExamGroupStudentsByClass($exam_group_id, $class_id, $session_id)
    {
        $sql = "SELECT IFNULL(exam_group_students.id, 0) as exam_group_student_id,
                       students.admission_no, students.id as student_id, students.roll_no,
                       students.admission_date, students.firstname, students.middlename, students.lastname,
                       students.image, students.mobileno, students.email, students.state, students.city,
                       students.pincode, students.religion, students.dob, students.current_address,
                       students.permanent_address, students.category_id,
                       IFNULL(categories.category, '') as category,
                       students.adhar_no, students.samagra_id, students.bank_account_no, students.bank_name,
                       students.ifsc_code, students.guardian_name, students.guardian_relation,
                       students.guardian_phone, students.guardian_address, students.is_active,
                       students.father_name, students.gender,
                       e.id as enrolment_id, e.class_id, e.status as enrolment_status,
                       ac.class_code, ac.cohort_name
                FROM academic_class_enrolment e
                INNER JOIN students ON students.id = e.student_id
                INNER JOIN academic_class ac ON ac.id = e.class_id
                LEFT JOIN categories ON students.category_id = categories.id
                LEFT JOIN exam_group_students ON exam_group_students.exam_group_id = " . $this->db->escape($exam_group_id) . "
                  AND exam_group_students.student_id = students.id
                WHERE e.class_id = " . $this->db->escape($class_id) . "
                  AND ac.session_id = " . $this->db->escape($session_id) . "
                  AND e.status = 'Active'
                ORDER BY students.id ASC";

        $query = $this->db->query($sql);
        return $query->result_array();
    }

    /**
     * Add/remove students from exam group
     */
    public function add($data_insert, $data_delete, $exam_group_id)
    {
        $this->db->trans_begin();
        if (!empty($data_insert)) {
            foreach ($data_insert as $student_key => $student_value) {
                $this->db->where('exam_group_id', $student_value['exam_group_id']);
                $this->db->where('student_id', $student_value['student_id']);
                $q = $this->db->get('exam_group_students');
                if ($q->num_rows() == 0) {
                    $this->db->insert('exam_group_students', $data_insert[$student_key]);
                }
            }
        }
        if (!empty($data_delete)) {
            $this->db->where('exam_group_id', $exam_group_id);
            $this->db->where_in('student_id', $data_delete);
            $this->db->delete('exam_group_students');
        }

        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            $this->db->trans_commit();
            return true;
        }
    }

    /**
     * Get exam group subject result by class (TVET)
     *
     * @param int $exam_subject_id Exam subject ID
     * @param int $class_id academic_class.id
     * @param int $session_id Session ID
     * @return array Student results for the exam subject
     */
    public function examGroupSubjectResultByClass($exam_subject_id, $class_id, $session_id)
    {
        $sql = "SELECT IFNULL(exam_group_exam_results.id, 0) as exam_group_exam_result_id,
                       IFNULL(exam_group_exam_results.attendence, '') as exam_group_exam_result_attendance,
                       IFNULL(exam_group_exam_results.get_marks, '') as exam_group_exam_result_get_marks,
                       IFNULL(exam_group_exam_results.note, '') as exam_group_exam_result_note,
                       exam_group_class_batch_exam_students.id as exam_group_class_batch_exam_students_id,
                       exam_group_class_batch_exam_students.roll_no as exam_roll_no,
                       exam_group_class_batch_exam_subjects.*,
                       subjects.name, subjects.code, subjects.type,
                       students.admission_no, students.roll_no, students.id as student_id,
                       students.admission_date, students.firstname, students.middlename, students.lastname,
                       students.image, students.mobileno, students.email, students.state, students.city,
                       students.pincode, students.religion, students.dob, students.current_address,
                       students.permanent_address, students.category_id,
                       IFNULL(categories.category, '') as category,
                       students.adhar_no, students.samagra_id, students.bank_account_no, students.bank_name,
                       students.ifsc_code, students.guardian_name, students.guardian_relation,
                       students.guardian_phone, students.guardian_address, students.is_active,
                       students.father_name, students.gender,
                       exam_group_class_batch_exams.use_exam_roll_no
                FROM exam_group_class_batch_exam_subjects
                INNER JOIN exam_group_class_batch_exams ON exam_group_class_batch_exams.id = exam_group_class_batch_exam_subjects.exam_group_class_batch_exams_id
                INNER JOIN subjects ON subjects.id = exam_group_class_batch_exam_subjects.subject_id
                INNER JOIN exam_group_class_batch_exam_students ON exam_group_class_batch_exam_students.exam_group_class_batch_exam_id = exam_group_class_batch_exam_subjects.exam_group_class_batch_exams_id
                INNER JOIN academic_class_enrolment e ON e.id = exam_group_class_batch_exam_students.student_session_id
                INNER JOIN academic_class ac ON ac.id = e.class_id
                LEFT JOIN exam_group_exam_results ON exam_group_exam_results.exam_group_class_batch_exam_subject_id = exam_group_class_batch_exam_subjects.id
                  AND exam_group_exam_results.exam_group_class_batch_exam_student_id = exam_group_class_batch_exam_students.id
                INNER JOIN students ON students.id = e.student_id
                LEFT JOIN categories ON students.category_id = categories.id
                WHERE e.status = 'Active'
                  AND exam_group_class_batch_exam_subjects.id = " . $this->db->escape($exam_subject_id) . "
                  AND e.class_id = " . $this->db->escape($class_id) . "
                  AND ac.session_id = " . $this->db->escape($session_id) . "
                ORDER BY CAST(students.admission_no AS UNSIGNED) ASC";

        $query = $this->db->query($sql);
        return $query->result_array();
    }

    /**
     * Add/update exam results
     */
    public function add_result($insert_array)
    {
        $this->db->trans_start();
        $this->db->trans_strict(false);
        if (!empty($insert_array)) {
            foreach ($insert_array as $student_key => $student_value) {
                $student_value['exam_group_class_batch_exam_subject_id'];
                $student_value['exam_group_class_batch_exam_student_id'];
                $this->db->where('exam_group_class_batch_exam_subject_id', $student_value['exam_group_class_batch_exam_subject_id']);
                $this->db->where('exam_group_class_batch_exam_student_id', $student_value['exam_group_class_batch_exam_student_id']);
                $q = $this->db->get('exam_group_exam_results');
                if ($q->num_rows() > 0) {
                    $update_result = $q->row();
                    $this->db->where('id', $update_result->id);
                    $this->db->update('exam_group_exam_results', $student_value);
                } else {
                    $this->db->insert('exam_group_exam_results', $student_value);
                }
            }
        }

        $this->db->trans_complete();

        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            $this->db->trans_commit();
            return true;
        }
    }

    /**
     * Search students by class and session (TVET)
     *
     * @param int $class_id academic_class.id
     * @param int $session_id Session ID
     * @return array List of students in the class
     */
    public function searchStudentByClassSession($class_id, $session_id)
    {
        $sql = "SELECT students.admission_no, students.id as student_id, students.roll_no,
                       students.admission_date, students.firstname, students.middlename, students.lastname,
                       students.image, students.mobileno, students.email, students.state, students.city,
                       students.pincode, students.religion, students.dob, students.current_address,
                       students.permanent_address, students.category_id,
                       IFNULL(categories.category, '') as category,
                       students.adhar_no, students.samagra_id, students.bank_account_no, students.bank_name,
                       students.ifsc_code, students.guardian_name, students.guardian_relation,
                       students.guardian_phone, students.guardian_address, students.is_active,
                       students.father_name, students.gender,
                       e.id as enrolment_id
                FROM students
                LEFT JOIN categories ON students.category_id = categories.id
                INNER JOIN academic_class_enrolment e ON students.id = e.student_id
                INNER JOIN academic_class ac ON ac.id = e.class_id
                WHERE e.class_id = " . $this->db->escape($class_id) . "
                  AND ac.session_id = " . $this->db->escape($session_id) . "
                  AND e.status = 'Active'
                ORDER BY students.id ASC";

        $query = $this->db->query($sql);
        return $query->result_array();
    }

    /**
     * Search student exams by enrolment ID (TVET)
     * The student_session_id column in exam_group_class_batch_exam_students
     * now references academic_class_enrolment.id
     *
     * @param int $enrolment_id academic_class_enrolment.id (passed as student_session_id for backward compat)
     * @param bool $is_active Filter by active exams
     * @param bool $is_publish Filter by published exams
     * @return array List of student's exams with results
     */
    public function searchStudentExamsByEnrolment($enrolment_id, $is_active = false, $is_publish = false)
    {
        $inner_sql = "";
        if ($is_active) {
            $inner_sql = "AND exam_group_class_batch_exams.is_active = 1 ";
        }
        if ($is_publish) {
            $inner_sql .= "AND exam_group_class_batch_exams.is_publish = 1 ";
        }

        $sql = "SELECT exam_group_class_batch_exam_students.*,
                       exam_group_class_batch_exams.exam_group_id, exam_group_class_batch_exams.exam,
                       exam_group_class_batch_exams.date_from, exam_group_class_batch_exams.date_to,
                       exam_group_class_batch_exams.description, exam_groups.name, exam_groups.exam_type,
                       exam_group_class_batch_exams.passing_percentage
                FROM exam_group_class_batch_exam_students
                INNER JOIN exam_group_class_batch_exams ON exam_group_class_batch_exams.id = exam_group_class_batch_exam_students.exam_group_class_batch_exam_id
                INNER JOIN exam_groups ON exam_groups.id = exam_group_class_batch_exams.exam_group_id
                WHERE student_session_id = " . $this->db->escape($enrolment_id) . " " . $inner_sql . "
                ORDER BY id ASC";

        $query = $this->db->query($sql);
        $student_exam = $query->result();

        if (!empty($student_exam)) {
            foreach ($student_exam as $student_exam_key => $student_exam_value) {
                $student_exam_value->exam_result = $this->examresult_model->getStudentExamResults(
                    $student_exam_value->exam_group_class_batch_exam_id,
                    $student_exam_value->exam_group_id,
                    $student_exam_value->id,
                    $student_exam_value->student_id
                );
            }
        }
        return $student_exam;
    }

    /**
     * Legacy wrapper: searchStudentExams -> searchStudentExamsByEnrolment
     * Kept for backward compatibility with controllers passing student_session_id
     * (which now holds academic_class_enrolment.id)
     *
     * @deprecated Use searchStudentExamsByEnrolment() instead
     */
    public function searchStudentExams($student_session_id, $is_active = false, $is_publish = false)
    {
        return $this->searchStudentExamsByEnrolment($student_session_id, $is_active, $is_publish);
    }

    /**
     * Get student exams by enrolment (TVET)
     *
     * @param int $enrolment_id academic_class_enrolment.id
     * @return array List of active exams for the student
     */
    public function studentExamsByEnrolment($enrolment_id)
    {
        $sql = "SELECT exam_group_class_batch_exam_students.*,
                       exam_group_class_batch_exams.id as exam_group_class_batch_exam_id,
                       exam_group_class_batch_exams.exam, exam_group_class_batch_exams.description,
                       exam_group_class_batch_exams.exam_group_id
                FROM exam_group_class_batch_exam_students
                INNER JOIN exam_group_class_batch_exams ON exam_group_class_batch_exam_students.exam_group_class_batch_exam_id = exam_group_class_batch_exams.id
                WHERE student_session_id = " . $this->db->escape($enrolment_id) . "
                  AND exam_group_class_batch_exams.is_active = 1";

        $query = $this->db->query($sql);
        return $query->result();
    }

    /**
     * Legacy wrapper: studentExams -> studentExamsByEnrolment
     *
     * @deprecated Use studentExamsByEnrolment() instead
     */
    public function studentExams($student_session_id)
    {
        return $this->studentExamsByEnrolment($student_session_id);
    }

    /**
     * Batch update exam students
     */
    public function updateExamStudent($data)
    {
        $this->db->update_batch('exam_group_class_batch_exam_students', $data, 'id');
    }

    /**
     * Get exam result by enrolment (TVET)
     *
     * @param int $enrolment_id academic_class_enrolment.id
     * @param int $exam_id Exam ID
     * @param bool $is_active Filter by active exams
     * @param bool $is_publish Filter by published exams
     * @return array Exam results with details
     */
    public function getExamResultByEnrolment($enrolment_id, $exam_id, $is_active = false, $is_publish = false)
    {
        $inner_sql = "";
        if ($is_active) {
            $inner_sql = "AND exam_group_class_batch_exams.is_active = 1 ";
        }
        if ($is_publish) {
            $inner_sql .= "AND exam_group_class_batch_exams.is_publish = 1 ";
        }

        $sql = "SELECT exam_group_class_batch_exam_students.*,
                       exam_group_class_batch_exams.exam_group_id, exam_group_class_batch_exams.exam,
                       exam_group_class_batch_exams.passing_percentage,
                       exam_group_class_batch_exams.date_from, exam_group_class_batch_exams.date_to,
                       exam_group_class_batch_exams.description, exam_groups.name, exam_groups.exam_type
                FROM exam_group_class_batch_exam_students
                INNER JOIN exam_group_class_batch_exams ON exam_group_class_batch_exams.id = exam_group_class_batch_exam_students.exam_group_class_batch_exam_id
                INNER JOIN exam_groups ON exam_groups.id = exam_group_class_batch_exams.exam_group_id
                WHERE exam_group_class_batch_exam_students.exam_group_class_batch_exam_id = " . $this->db->escape($exam_id) . "
                  AND student_session_id = " . $this->db->escape($enrolment_id) . " " . $inner_sql . "
                ORDER BY id ASC";

        $query = $this->db->query($sql);
        $student_exam = $query->result();

        if (!empty($student_exam)) {
            foreach ($student_exam as $student_exam_key => $student_exam_value) {
                $student_exam_value->exam_result = $this->examresult_model->getStudentExamResults(
                    $student_exam_value->exam_group_class_batch_exam_id,
                    $student_exam_value->exam_group_id,
                    $student_exam_value->id,
                    $student_exam_value->student_id
                );
            }
        }
        return $student_exam;
    }

    /**
     * Legacy wrapper: getexamresult -> getExamResultByEnrolment
     *
     * @deprecated Use getExamResultByEnrolment() instead
     */
    public function getexamresult($student_session_id, $exam_id, $is_active = false, $is_publish = false)
    {
        return $this->getExamResultByEnrolment($student_session_id, $exam_id, $is_active, $is_publish);
    }

}
