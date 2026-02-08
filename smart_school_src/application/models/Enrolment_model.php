<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Enrolment Model - REPLACES student_session
 * Links students to classes with enrolment_type (Core/Elective)
 * Critical model for TVET architecture
 *
 * Table: academic_class_enrolment
 * Session comes from academic_class.session_id (not enrolment table)
 */
class Enrolment_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get enrolment by ID with full details
     * @param int $enrolment_id Enrolment ID
     * @return object Enrolment object
     */
    public function getEnrolmentById($enrolment_id)
    {
        $this->db->select('ace.*, ace.id as enrolment_id,
            students.*, students.id as student_id,
            ac.class_code, ac.cohort_name, ac.academic_year, ac.session_id,
            asub.name as subject_name, asub.code as subject_code,
            alv.name as level_name, alv.code as level_code,
            staff.name as lecturer_name,
            sessions.session as session_name', FALSE);
        $this->db->from('academic_class_enrolment ace');
        $this->db->join('students', 'ace.student_id = students.id');
        $this->db->join('academic_class ac', 'ace.class_id = ac.id');
        $this->db->join('academic_subject_level asl', 'ac.subject_level_id = asl.id');
        $this->db->join('academic_subject asub', 'asl.subject_id = asub.id');
        $this->db->join('academic_level alv', 'asl.level_id = alv.id');
        $this->db->join('staff', 'ac.primary_lecturer_id = staff.id', 'left');
        $this->db->join('sessions', 'ac.session_id = sessions.id');
        $this->db->where('ace.id', $enrolment_id);
        return $this->db->get()->row();
    }

    /**
     * Get student's enrolments for a session
     * @param int $student_id Student ID
     * @param int $session_id Session ID (optional, defaults to active session)
     * @return array Array of enrolment objects
     */
    public function getStudentEnrolments($student_id, $session_id = null)
    {
        $this->db->select('ace.*, ace.id as enrolment_id, ace.id as student_session_id,
            ac.class_code, ac.cohort_name, ac.academic_year, ac.status as class_status,
            ac.session_id, ac.id as class_id,
            asub.name as subject_name, asub.code as subject_code, asub.credits,
            alv.name as level_name, alv.code as level_code, alv.level_type,
            staff.name as lecturer_name, staff.id as lecturer_id,
            sessions.session as session_name, sessions.id as session_id', FALSE);
        $this->db->from('academic_class_enrolment ace');
        $this->db->join('academic_class ac', 'ace.class_id = ac.id');
        $this->db->join('academic_subject_level asl', 'ac.subject_level_id = asl.id');
        $this->db->join('academic_subject asub', 'asl.subject_id = asub.id');
        $this->db->join('academic_level alv', 'asl.level_id = alv.id');
        $this->db->join('staff', 'ac.primary_lecturer_id = staff.id', 'left');
        $this->db->join('sessions', 'ac.session_id = sessions.id');
        $this->db->where('ace.student_id', $student_id);
        $this->db->where('ace.status', 'Active');

        if ($session_id) {
            $this->db->where('ac.session_id', $session_id);
        } else {
            $this->db->where('sessions.is_active', 'yes');
        }

        $this->db->order_by('asub.name', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Get students enrolled in a class
     * @param int $class_id Class ID
     * @return array Array of students with enrolment details
     */
    public function getClassEnrolments($class_id)
    {
        $this->db->select('ace.*, ace.id as enrolment_id,
            students.*, students.id as student_id', FALSE);
        $this->db->from('academic_class_enrolment ace');
        $this->db->join('students', 'ace.student_id = students.id');
        $this->db->where('ace.class_id', $class_id);
        $this->db->where('ace.status', 'Active');
        $this->db->where('students.is_active', 'yes');
        $this->db->order_by('students.firstname', 'ASC');
        $this->db->order_by('students.lastname', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Enroll student in a class
     * @param array $data Enrolment data
     * @return array Result with success status and enrolment_id or error message
     */
    public function enrollStudent($data)
    {
        // Check if already enrolled
        $existing = $this->db->where('student_id', $data['student_id'])
            ->where('class_id', $data['class_id'])
            ->get('academic_class_enrolment')->row();

        if ($existing) {
            return array(
                'success' => false,
                'message' => 'Student already enrolled in this class',
                'enrolment_id' => $existing->id
            );
        }

        // Check class capacity
        $class = $this->db->select('max_students')
            ->where('id', $data['class_id'])
            ->get('academic_class')->row();

        if ($class) {
            $current_count = $this->db->where('class_id', $data['class_id'])
                ->where('status', 'Active')
                ->count_all_results('academic_class_enrolment');

            if ($current_count >= $class->max_students) {
                return array(
                    'success' => false,
                    'message' => 'Class is full (max ' . $class->max_students . ' students)'
                );
            }
        }

        // Insert enrolment
        if ($this->db->insert('academic_class_enrolment', $data)) {
            return array(
                'success' => true,
                'enrolment_id' => $this->db->insert_id(),
                'message' => 'Student enrolled successfully'
            );
        }

        return array(
            'success' => false,
            'message' => 'Failed to enroll student'
        );
    }

    /**
     * Enroll student in multiple classes (bulk enrollment)
     * @param int $student_id Student ID
     * @param array $class_ids Array of class IDs
     * @param int $student_session_id Student session ID
     * @param string $enrolment_type 'Core' or 'Elective'
     * @return array Result array with success count and errors
     */
    public function enrollStudentBulk($student_id, $class_ids, $student_session_id, $enrolment_type = 'Core')
    {
        $results = array(
            'success_count' => 0,
            'error_count' => 0,
            'errors' => array()
        );

        foreach ($class_ids as $class_id) {
            $data = array(
                'student_id' => $student_id,
                'class_id' => $class_id,
                'student_session_id' => $student_session_id,
                'enrolment_date' => date('Y-m-d'),
                'status' => 'Active'
            );

            $result = $this->enrollStudent($data);

            if ($result['success']) {
                $results['success_count']++;
            } else {
                $results['error_count']++;
                $results['errors'][] = 'Class ID ' . $class_id . ': ' . $result['message'];
            }
        }

        return $results;
    }

    /**
     * Update enrolment
     * @param int $enrolment_id Enrolment ID
     * @param array $data Enrolment data
     * @return bool Success status
     */
    public function update($enrolment_id, $data)
    {
        $this->db->where('id', $enrolment_id);
        return $this->db->update('academic_class_enrolment', $data);
    }

    /**
     * Update enrolment status
     * @param int $enrolment_id Enrolment ID
     * @param string $status New status
     * @return bool Success status
     */
    public function updateStatus($enrolment_id, $status)
    {
        $data = array('status' => $status);

        if ($status == 'Completed') {
            $data['completion_date'] = date('Y-m-d');
        }

        $this->db->where('id', $enrolment_id);
        return $this->db->update('academic_class_enrolment', $data);
    }

    /**
     * Drop class (withdraw student from class)
     * @param int $enrolment_id Enrolment ID
     * @return bool Success status
     */
    public function dropClass($enrolment_id)
    {
        return $this->updateStatus($enrolment_id, 'Dropped');
    }

    /**
     * Delete enrolment (soft delete)
     * @param int $enrolment_id Enrolment ID
     * @return bool Success status
     */
    public function remove($enrolment_id)
    {
        $data = array('status' => 'Dropped');
        $this->db->where('id', $enrolment_id);
        return $this->db->update('academic_class_enrolment', $data);
    }

    /**
     * Get enrolment statistics by session
     * @param int $session_id Session ID
     * @return object Statistics object
     */
    public function getEnrolmentStatistics($session_id)
    {
        $stats = new stdClass();

        // Total enrolments
        $this->db->from('academic_class_enrolment ace');
        $this->db->join('academic_class ac', 'ace.class_id = ac.id');
        $this->db->where('ac.session_id', $session_id);
        $this->db->where('ace.status', 'Active');
        $stats->total = $this->db->count_all_results();

        // By status
        $this->db->select('ace.status, COUNT(*) as count', FALSE);
        $this->db->from('academic_class_enrolment ace');
        $this->db->join('academic_class ac', 'ace.class_id = ac.id');
        $this->db->where('ac.session_id', $session_id);
        $this->db->group_by('ace.status');
        $stats->by_status = $this->db->get()->result();

        // Unique students enrolled
        $this->db->select('COUNT(DISTINCT ace.student_id) as cnt', FALSE);
        $this->db->from('academic_class_enrolment ace');
        $this->db->join('academic_class ac', 'ace.class_id = ac.id');
        $this->db->where('ac.session_id', $session_id);
        $this->db->where('ace.status', 'Active');
        $row = $this->db->get()->row();
        $stats->unique_students = $row ? $row->cnt : 0;

        return $stats;
    }

    /**
     * Get enrolments by filters
     * @param int $session_id Session ID
     * @param array $filters (class_id, level_id, subject_id, status)
     * @return array Array of enrolments
     */
    public function getByFilters($session_id, $filters = array())
    {
        $this->db->select('ace.*, ace.id as enrolment_id,
            students.admission_no, students.firstname, students.lastname,
            ac.class_code,
            asub.name as subject_name,
            alv.name as level_name', FALSE);
        $this->db->from('academic_class_enrolment ace');
        $this->db->join('students', 'ace.student_id = students.id');
        $this->db->join('academic_class ac', 'ace.class_id = ac.id');
        $this->db->join('academic_subject_level asl', 'ac.subject_level_id = asl.id');
        $this->db->join('academic_subject asub', 'asl.subject_id = asub.id');
        $this->db->join('academic_level alv', 'asl.level_id = alv.id');
        $this->db->where('ac.session_id', $session_id);

        // Apply filters
        if (!empty($filters['class_id'])) {
            $this->db->where('ace.class_id', $filters['class_id']);
        }

        if (!empty($filters['level_id'])) {
            $this->db->where('alv.id', $filters['level_id']);
        }

        if (!empty($filters['subject_id'])) {
            $this->db->where('asub.id', $filters['subject_id']);
        }

        if (!empty($filters['status'])) {
            $this->db->where('ace.status', $filters['status']);
        }

        $this->db->order_by('students.firstname', 'ASC');
        $this->db->order_by('students.lastname', 'ASC');

        return $this->db->get()->result();
    }
}
