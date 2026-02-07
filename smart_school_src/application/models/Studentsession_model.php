<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Studentsession_model - TVET Converted
 *
 * Legacy model that previously used student_session + classes + sections tables.
 * Now converted to use academic_class_enrolment + academic_class tables for TVET mode.
 *
 * Table mapping:
 *   student_session  -> academic_class_enrolment
 *   classes + sections -> academic_class
 *   class_id + section_id -> class_id (references academic_class.id)
 *   session_id -> kept in student_session (academic_class_enrolment has no session_id)
 *
 * Note: academic_class_enrolment has student_id and class_id columns.
 * For display, class_code or cohort_name from academic_class is used as the "class" alias.
 */
class Studentsession_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
    }

    /**
     * Search students by academic class
     * Legacy: searched by class_id + section_id in student_session
     * TVET: searches by class_id in academic_class_enrolment
     *
     * @param int $class_id  academic_class.id
     * @param int $section_id  DEPRECATED - ignored in TVET mode
     */
    public function searchStudents($class_id = null, $section_id = null, $key = null)
    {
        $this->db->select('e.id, e.student_id, c.class_code, c.cohort_name as class,
            students.firstname, students.middlename, students.lastname, students.admission_no, students.roll_no, students.dob, students.guardian_name', FALSE);
        $this->db->from('academic_class_enrolment e');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('students', 'students.id = e.student_id');
        $this->db->where('e.class_id', $class_id);
        $this->db->where('e.status', 'Active');
        $this->db->order_by('e.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    /**
     * Search student by enrolment ID (was student_session_id)
     * Legacy: searched by student_session.id
     * TVET: searches by academic_class_enrolment.id
     *
     * @param int $student_session_id  Now treated as enrolment_id
     */
    public function searchStudentsBySession($student_session_id = null)
    {
        $this->db->select('students.admission_no, students.roll_no, c.session_id, e.class_id,
            e.id, e.student_id, c.class_code, c.cohort_name as class,
            students.firstname, students.middlename, students.lastname, students.admission_no, students.mobileno, students.dob,
            students.guardian_name, students.father_name, students.guardian_phone, students.guardian_email, students.email,
            students.app_key, students.parent_app_key', FALSE);
        $this->db->from('academic_class_enrolment e');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('students', 'students.id = e.student_id');
        $this->db->where('e.id', $student_session_id);
        $this->db->order_by('e.id');
        $query = $this->db->get();
        return $query->row_array();
    }

    /**
     * Get student's current class/enrolment
     * Legacy: joined student_session + classes + sections
     * TVET: joins academic_class_enrolment + academic_class
     *
     * @param int $id  student_id
     */
    public function getStudentClass($id)
    {
        $this->db->select('students.admission_no, students.roll_no, c.session_id, e.class_id,
            e.id, e.student_id, c.class_code, c.cohort_name as class,
            students.firstname, students.middlename, students.lastname, students.admission_no, students.roll_no, students.dob, students.guardian_name', FALSE);
        $this->db->from('academic_class_enrolment e');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('students', 'students.id = e.student_id');
        $this->db->where('e.student_id', $id);
        $this->db->where('c.session_id', $this->current_session);
        $this->db->where('e.status', 'Active');
        $this->db->order_by('e.id');
        $query = $this->db->get();
        return $query->row_array();
    }

    /**
     * Update enrolment by ID
     * Legacy: updated student_session
     * TVET: updates academic_class_enrolment
     */
    public function updateById($update_array)
    {
        $this->db->where('id', $update_array['id']);
        $this->db->update('academic_class_enrolment', $update_array);
    }

    /**
     * Update promote record
     * Legacy: matched on session_id + student_id + class_id + section_id
     * TVET: matches on student_id + class_id in academic_class_enrolment
     *
     * @param array $update_array  Must contain student_id and class_id (academic_class.id)
     */
    public function updatePromote($update_array)
    {
        $this->db->where('student_id', $update_array['student_id']);
        if (isset($update_array['class_id'])) {
            $this->db->where('class_id', $update_array['class_id']);
        }
        // section_id ignored in TVET mode
        $this->db->update('academic_class_enrolment', $update_array);
    }

    /**
     * Get enrolment by ID
     * Legacy: queried student_session
     * TVET: queries academic_class_enrolment
     */
    public function getSessionById($id)
    {
        $this->db->select()->from('academic_class_enrolment');
        $this->db->where('id', $id);
        $this->db->order_by('id');
        $query = $this->db->get();
        return $query->row();
    }

    /**
     * Get total student count for current session
     * Legacy: counted from student_session
     * TVET: counts from academic_class_enrolment joined with academic_class for session
     */
    public function getTotalStudentBySession()
    {
        $query = "SELECT count(*) as `total_student` FROM `academic_class_enrolment` e INNER JOIN students ON students.id = e.student_id INNER JOIN academic_class c ON c.id = e.class_id WHERE c.session_id = " . $this->db->escape($this->current_session) . " AND students.is_active = 'yes' AND e.status = 'Active'";
        $query = $this->db->query($query);
        return $query->row();
    }

    /**
     * Get total head count (unique students) for current session
     * Legacy: counted from student_session grouped by student_id
     * TVET: counts from academic_class_enrolment grouped by student_id
     */
    public function getTotalHeadCountBySession()
    {
        $query = "SELECT count(*) as `total_student` FROM `academic_class_enrolment` e INNER JOIN students ON students.id = e.student_id INNER JOIN academic_class c ON c.id = e.class_id WHERE c.session_id = " . $this->db->escape($this->current_session) . " AND students.is_active = 'yes' AND e.status = 'Active' GROUP BY e.student_id";
        $query = $this->db->query($query);
        return $query->result();
    }

    /**
     * Add/update enrolment records for a student
     * Legacy: inserted into student_session with class_id + section_id
     * TVET: inserts into academic_class_enrolment with student_id + class_id
     *
     * @param array $insert_array  Array of enrolment records
     * @param int $student_id  The student ID
     */
    public function add($insert_array, $student_id)
    {
        $not_delarray = array();
        $this->db->trans_start();
        $this->db->trans_strict(false);
        if (!empty($insert_array)) {
            foreach ($insert_array as $insert_array_key => $insert_array_value) {
                $this->db->where('student_id', $insert_array_value['student_id']);
                $this->db->where('class_id', $insert_array_value['class_id']);
                $q = $this->db->get('academic_class_enrolment');
                if ($q->num_rows() > 0) {
                    $result         = $q->row();
                    $not_delarray[] = $result->id;
                } else {
                    // Build enrolment data for TVET table structure
                    $enrolment_data = array(
                        'student_id' => $insert_array_value['student_id'],
                        'class_id'   => $insert_array_value['class_id'],
                        'enrolment_date' => date('Y-m-d'),
                        'status'     => 'Active',
                    );
                    $this->db->insert('academic_class_enrolment', $enrolment_data);
                    $not_delarray[] = $this->db->insert_id();
                }
            }
        }
        if (!empty($not_delarray)) {
            // Only delete enrolments in the current session for this student
            $this->db->select('e.id');
            $this->db->from('academic_class_enrolment e');
            $this->db->join('academic_class c', 'c.id = e.class_id');
            $this->db->where('c.session_id', $this->current_session);
            $this->db->where('e.student_id', $student_id);
            $this->db->where_not_in('e.id', $not_delarray);
            $to_delete = $this->db->get()->result_array();
            if (!empty($to_delete)) {
                $del_ids = array_column($to_delete, 'id');
                $this->db->where_in('id', $del_ids);
                $this->db->delete('academic_class_enrolment');
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
     * Search students by class and return their enrolment records
     * Legacy: used searchByClassSectionWithSession + student_session
     * TVET: delegates to student_model and queries academic_class_enrolment
     *
     * @param int $class_id  academic_class.id
     * @param int $section_id  DEPRECATED - ignored in TVET mode
     */
    public function searchMultiStudentByClassSection($class_id = null, $section_id = null)
    {
        $students = $this->student_model->searchByClassSectionWithSession($class_id, $section_id);

        if (!empty($students)) {
            foreach ($students as $student_key => $student_value) {

                $this->db->select('e.*, c.session_id', FALSE);
                $this->db->from('academic_class_enrolment e');
                $this->db->join('academic_class c', 'c.id = e.class_id');
                $this->db->where('e.student_id', $student_value['id']);
                $this->db->where('c.session_id', $this->current_session);
                $this->db->where('e.status', 'Active');
                $this->db->order_by('e.id');
                $query                                      = $this->db->get();
                $students[$student_key]['student_sessions'] = $query->result();
            }
        }
        return $students;
    }

    /**
     * Get all class enrolments for a student in the current session
     * Legacy: joined student_session + classes + sections
     * TVET: joins academic_class_enrolment + academic_class
     *
     * @param int $student_id
     */
    public function searchMultiClsSectionByStudent($student_id)
    {
        $this->db->select('e.*, c.class_code, c.cohort_name as class, e.id as student_session_id', FALSE);
        $this->db->from('academic_class_enrolment e');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->where('e.student_id', $student_id);
        $this->db->where('c.session_id', $this->current_session);
        $this->db->where('e.status', 'Active');
        $this->db->order_by('e.id');
        $query = $this->db->get();
        return $query->result();
    }

    /**
     * Get class enrolments for a student from their most recent session
     * Legacy: used student_session + classes + sections
     * TVET: uses academic_class_enrolment + academic_class
     *
     * @param int $student_id
     */
    public function getMultiClsSectionByStudentOldSession($student_id)
    {
        $this->db->select_max('c.session_id', 'max_session_id');
        $this->db->from('academic_class_enrolment e');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->where('e.student_id', $student_id);
        $where_clause = $this->db->get_compiled_select();

        $this->db->select('e.*, c.class_code, c.cohort_name as class, e.id as student_session_id', FALSE);
        $this->db->from('academic_class_enrolment e');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->where('e.student_id', $student_id);
        $this->db->where("`c`.`session_id` = ($where_clause)", NULL, FALSE);
        $this->db->order_by('e.id');
        $query = $this->db->get();
        return $query->result();
    }

    /**
     * Get active class/enrolment for a student in a session
     * Legacy: joined student_session + classes + sections
     * TVET: joins academic_class_enrolment + academic_class
     *
     * @param int $student_id
     * @param int $enable_session  Session ID override (null = current session)
     */
    public function searchActiveClassSectionStudent($student_id, $enable_session = null)
    {
        $this->db->select('e.*, c.class_code, c.cohort_name as class', FALSE);
        $this->db->from('academic_class_enrolment e');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->where('e.student_id', $student_id);
        if ($enable_session == null) {
            $this->db->where('c.session_id', $this->current_session);
        } else {
            $this->db->where('c.session_id', $enable_session);
        }
        $this->db->where('e.status', 'Active');
        $this->db->order_by('e.id');
        $query = $this->db->get();
        return $query->row();
    }

    /**
     * Search student by keyword (name or admission_no)
     * Legacy: joined student_session + classes + sections
     * TVET: joins academic_class_enrolment + academic_class
     *
     * @param string $keyword  Search keyword
     * @param int $session_id  Session ID to filter by
     */
    public function searchStudentByKeyword($keyword, $session_id)
    {
        $this->db->select('e.id as student_session_id, students.firstname, students.lastname, students.admission_no, c.class_code, c.cohort_name as class', FALSE);
        $this->db->from('academic_class_enrolment e');
        $this->db->join('students', 'students.id = e.student_id');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->where('c.session_id', $session_id);
        $this->db->where('e.status', 'Active');
        $this->db->group_start();
        $this->db->like('students.firstname', $keyword);
        $this->db->or_like('students.lastname', $keyword);
        $this->db->or_like('students.admission_no', $keyword);
        $this->db->group_end();
        $this->db->limit(10);
        $query = $this->db->get();
        return $query->result_array();
    }

}
