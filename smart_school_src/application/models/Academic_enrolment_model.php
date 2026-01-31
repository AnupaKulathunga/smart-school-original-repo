<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Academic Enrolment Model
 * Manages student enrolment in classes
 * Uses student_session_id to link to students via student_session table
 */
class Academic_enrolment_model extends CI_Model
{
    private $table = 'academic_class_enrolment';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get all enrolments with details
     */
    public function getAll($filters = array())
    {
        $this->db->select('e.*,
                          s.admission_no, s.firstname, s.lastname, s.email, s.mobileno, s.image,
                          ss.id as student_session_id, ss.student_id,
                          c.class_code, c.cohort_name,
                          subj.name as subject_name, subj.code as subject_code,
                          l.code as level_code, l.name as level_name');
        $this->db->from($this->table . ' e');
        $this->db->join('student_session ss', 'ss.id = e.student_session_id');
        $this->db->join('students s', 's.id = ss.student_id');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');

        if (!empty($filters['class_id'])) {
            $this->db->where('e.class_id', $filters['class_id']);
        }
        if (!empty($filters['student_session_id'])) {
            $this->db->where('e.student_session_id', $filters['student_session_id']);
        }
        if (!empty($filters['student_id'])) {
            $this->db->where('ss.student_id', $filters['student_id']);
        }
        if (!empty($filters['status'])) {
            $this->db->where('e.status', $filters['status']);
        }

        return $this->db->order_by('s.lastname', 'ASC')
            ->order_by('s.firstname', 'ASC')
            ->get()->result();
    }

    /**
     * Get enrolment by ID
     */
    public function get($id)
    {
        return $this->db->select('e.*,
                                  s.admission_no, s.firstname, s.lastname, s.email, s.mobileno, s.image,
                                  ss.student_id,
                                  c.class_code, c.cohort_name,
                                  subj.name as subject_name,
                                  l.code as level_code')
            ->from($this->table . ' e')
            ->join('student_session ss', 'ss.id = e.student_session_id')
            ->join('students s', 's.id = ss.student_id')
            ->join('academic_class c', 'c.id = e.class_id')
            ->join('academic_subject_level sl', 'sl.id = c.subject_level_id')
            ->join('academic_subject subj', 'subj.id = sl.subject_id')
            ->join('academic_level l', 'l.id = sl.level_id')
            ->where('e.id', $id)
            ->get()->row();
    }

    /**
     * Get class roster (students enrolled in a class)
     */
    public function getClassRoster($class_id, $status = 'Enrolled')
    {
        $this->db->select('e.id as enrolment_id, e.enrolment_date, e.status, e.final_mark, e.final_grade,
                          ss.student_id,
                          s.id as student_id, s.admission_no, s.firstname, s.lastname, s.email, s.mobileno, s.image');
        $this->db->from($this->table . ' e');
        $this->db->join('student_session ss', 'ss.id = e.student_session_id');
        $this->db->join('students s', 's.id = ss.student_id');
        $this->db->where('e.class_id', $class_id);

        if ($status) {
            $this->db->where('e.status', $status);
        }

        return $this->db->order_by('s.lastname', 'ASC')
            ->order_by('s.firstname', 'ASC')
            ->get()->result();
    }

    /**
     * Get student's enrolled classes (by student_id - finds student_session_id automatically)
     */
    public function getStudentClasses($student_id, $session_id = null)
    {
        $this->db->select('e.*, e.id as enrolment_id, c.class_code, c.cohort_name, c.venue, c.session_id,
                          subj.name as subject_name, subj.code as subject_code,
                          l.code as level_code, l.name as level_name,
                          st.name as lecturer_name, st.surname as lecturer_surname');
        $this->db->from($this->table . ' e');
        $this->db->join('student_session ss', 'ss.id = e.student_session_id');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->join('staff st', 'st.id = c.primary_lecturer_id', 'left');
        $this->db->where('ss.student_id', $student_id);

        if ($session_id) {
            $this->db->where('c.session_id', $session_id);
        }

        return $this->db->order_by('subj.name', 'ASC')->get()->result();
    }

    /**
     * Enrol student in class
     */
    public function enrol($data)
    {
        // Get or find student_session_id
        $student_session_id = isset($data['student_session_id']) ? $data['student_session_id'] : null;

        if (!$student_session_id && isset($data['student_id'])) {
            // Find student_session_id from student_id
            $ss = $this->db->where('student_id', $data['student_id'])
                ->order_by('id', 'DESC')
                ->limit(1)
                ->get('student_session')->row();
            $student_session_id = $ss ? $ss->id : null;
        }

        $insert_data = array(
            'student_session_id' => $student_session_id,
            'class_id' => $data['class_id'],
            'enrolment_date' => isset($data['enrolment_date']) ? $data['enrolment_date'] : date('Y-m-d'),
            'status' => isset($data['status']) ? $data['status'] : 'Enrolled',
            'notes' => isset($data['notes']) ? $data['notes'] : null
        );

        $this->db->insert($this->table, $insert_data);
        return $this->db->insert_id();
    }

    /**
     * Bulk enrol students in class
     */
    public function bulkEnrol($class_id, $student_ids, $enrolment_date = null)
    {
        $date = $enrolment_date ? $enrolment_date : date('Y-m-d');
        $success = 0;
        $failed = 0;

        foreach ($student_ids as $student_id) {
            // Check if already enrolled
            if (!$this->isEnrolled($student_id, $class_id)) {
                $this->enrol(array(
                    'student_id' => $student_id,
                    'class_id' => $class_id,
                    'enrolment_date' => $date
                ));
                $success++;
            } else {
                $failed++;
            }
        }

        return array('success' => $success, 'failed' => $failed);
    }

    /**
     * Update enrolment
     */
    public function update($id, $data)
    {
        $update_data = array();

        if (isset($data['status'])) $update_data['status'] = $data['status'];
        if (isset($data['withdrawal_date'])) $update_data['withdrawal_date'] = $data['withdrawal_date'];
        if (isset($data['final_mark'])) $update_data['final_mark'] = $data['final_mark'];
        if (isset($data['final_grade'])) $update_data['final_grade'] = $data['final_grade'];
        if (isset($data['notes'])) $update_data['notes'] = $data['notes'];

        return $this->db->where('id', $id)->update($this->table, $update_data);
    }

    /**
     * Remove enrolment
     */
    public function remove($id)
    {
        return $this->db->where('id', $id)->delete($this->table);
    }

    /**
     * Check if student is enrolled in class (by student_id)
     */
    public function isEnrolled($student_id, $class_id)
    {
        return $this->db->from($this->table . ' e')
            ->join('student_session ss', 'ss.id = e.student_session_id')
            ->where('ss.student_id', $student_id)
            ->where('e.class_id', $class_id)
            ->count_all_results() > 0;
    }

    /**
     * Get enrolment by student and class (by student_id)
     */
    public function getByStudentClass($student_id, $class_id)
    {
        return $this->db->select('e.*')
            ->from($this->table . ' e')
            ->join('student_session ss', 'ss.id = e.student_session_id')
            ->where('ss.student_id', $student_id)
            ->where('e.class_id', $class_id)
            ->get()->row();
    }

    /**
     * Get active enrolment count for class
     */
    public function getActiveCount($class_id)
    {
        return $this->db->where('class_id', $class_id)
            ->where('status', 'Enrolled')
            ->count_all_results($this->table);
    }

    /**
     * Withdraw student from class
     */
    public function withdraw($student_id, $class_id, $reason = null)
    {
        return $this->db->from($this->table . ' e')
            ->join('student_session ss', 'ss.id = e.student_session_id')
            ->where('ss.student_id', $student_id)
            ->where('e.class_id', $class_id)
            ->update($this->table, array(
                'status' => 'Withdrawn',
                'withdrawal_date' => date('Y-m-d'),
                'withdrawal_reason' => $reason
            ));
    }

    /**
     * Complete student's enrolment
     */
    public function complete($id, $final_mark = null, $final_grade = null)
    {
        $data = array(
            'status' => 'Completed'
        );

        if ($final_mark !== null) {
            $data['final_mark'] = $final_mark;
        }
        if ($final_grade !== null) {
            $data['final_grade'] = $final_grade;
        }

        return $this->db->where('id', $id)->update($this->table, $data);
    }
}
