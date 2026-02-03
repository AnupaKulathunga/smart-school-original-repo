<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Enrolment Model - REPLACES student_session
 * Links students to classes with enrolment_type (Core/Elective)
 * Critical model for TVET architecture
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
        $this->db->select('enrolment.*,
            students.*, students.id as student_id,
            class.class_code, class.cohort_name, class.academic_year,
            subjects.name as subject_name, subjects.code as subject_code,
            level.name as level_name, level.code as level_code,
            staff.name as lecturer_name,
            sessions.session as session_name');
        $this->db->from('enrolment');
        $this->db->join('students', 'enrolment.student_id = students.id');
        $this->db->join('class', 'enrolment.class_id = class.id');
        $this->db->join('subject_level', 'class.subject_level_id = subject_level.id');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->join('staff', 'class.primary_lecturer_id = staff.id', 'left');
        $this->db->join('sessions', 'enrolment.session_id = sessions.id');
        $this->db->where('enrolment.id', $enrolment_id);
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
        $this->db->select('enrolment.*, enrolment.id as enrolment_id,
            class.class_code, class.cohort_name, class.academic_year, class.status as class_status,
            subjects.name as subject_name, subjects.code as subject_code, subjects.credits,
            level.name as level_name, level.code as level_code, level.level_type,
            staff.name as lecturer_name, staff.id as lecturer_id,
            sessions.session as session_name');
        $this->db->from('enrolment');
        $this->db->join('class', 'enrolment.class_id = class.id');
        $this->db->join('subject_level', 'class.subject_level_id = subject_level.id');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->join('staff', 'class.primary_lecturer_id = staff.id', 'left');
        $this->db->join('sessions', 'enrolment.session_id = sessions.id');
        $this->db->where('enrolment.student_id', $student_id);
        $this->db->where('enrolment.status', 'Active');

        if ($session_id) {
            $this->db->where('enrolment.session_id', $session_id);
        } else {
            $this->db->where('sessions.is_active', 'yes');
        }

        $this->db->order_by('subjects.name', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Get students enrolled in a class
     * @param int $class_id Class ID
     * @return array Array of students with enrolment details
     */
    public function getClassEnrolments($class_id)
    {
        $this->db->select('enrolment.*, enrolment.id as enrolment_id,
            students.*, students.id as student_id,
            student_programme.programme_id,
            programme.name as programme_name');
        $this->db->from('enrolment');
        $this->db->join('students', 'enrolment.student_id = students.id');
        $this->db->join('student_programme', 'student_programme.student_id = students.id AND student_programme.session_id = enrolment.session_id', 'left');
        $this->db->join('programme', 'student_programme.programme_id = programme.id', 'left');
        $this->db->where('enrolment.class_id', $class_id);
        $this->db->where('enrolment.status', 'Active');
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
            ->get('enrolment')->row();

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
            ->get('class')->row();

        if ($class) {
            $current_count = $this->db->where('class_id', $data['class_id'])
                ->where('status', 'Active')
                ->count_all_results('enrolment');

            if ($current_count >= $class->max_students) {
                return array(
                    'success' => false,
                    'message' => 'Class is full (max ' . $class->max_students . ' students)'
                );
            }
        }

        // Insert enrolment
        if ($this->db->insert('enrolment', $data)) {
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
     * @param int $session_id Session ID
     * @param string $enrolment_type 'Core' or 'Elective'
     * @return array Result array with success count and errors
     */
    public function enrollStudentBulk($student_id, $class_ids, $session_id, $enrolment_type = 'Core')
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
                'session_id' => $session_id,
                'enrolment_date' => date('Y-m-d'),
                'enrolment_type' => $enrolment_type,
                'status' => 'Active',
                'is_active' => 1
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
        return $this->db->update('enrolment', $data);
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
        return $this->db->update('enrolment', $data);
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
        $data = array('is_active' => 0);
        $this->db->where('id', $enrolment_id);
        return $this->db->update('enrolment', $data);
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
        $stats->total = $this->db->where('session_id', $session_id)
            ->where('status', 'Active')
            ->count_all_results('enrolment');

        // By enrolment type
        $this->db->select('enrolment_type, COUNT(*) as count');
        $this->db->from('enrolment');
        $this->db->where('session_id', $session_id);
        $this->db->where('status', 'Active');
        $this->db->group_by('enrolment_type');
        $stats->by_type = $this->db->get()->result();

        // By status
        $this->db->select('status, COUNT(*) as count');
        $this->db->from('enrolment');
        $this->db->where('session_id', $session_id);
        $this->db->group_by('status');
        $stats->by_status = $this->db->get()->result();

        // Unique students enrolled
        $stats->unique_students = $this->db->select('DISTINCT student_id')
            ->from('enrolment')
            ->where('session_id', $session_id)
            ->where('status', 'Active')
            ->count_all_results();

        return $stats;
    }

    /**
     * Get enrolments by filters
     * @param int $session_id Session ID
     * @param array $filters (class_id, level_id, subject_id, enrolment_type, status)
     * @return array Array of enrolments
     */
    public function getByFilters($session_id, $filters = array())
    {
        $this->db->select('enrolment.*, enrolment.id as enrolment_id,
            students.admission_no, students.firstname, students.lastname,
            class.class_code,
            subjects.name as subject_name,
            level.name as level_name');
        $this->db->from('enrolment');
        $this->db->join('students', 'enrolment.student_id = students.id');
        $this->db->join('class', 'enrolment.class_id = class.id');
        $this->db->join('subject_level', 'class.subject_level_id = subject_level.id');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->where('enrolment.session_id', $session_id);

        // Apply filters
        if (!empty($filters['class_id'])) {
            $this->db->where('enrolment.class_id', $filters['class_id']);
        }

        if (!empty($filters['level_id'])) {
            $this->db->where('level.id', $filters['level_id']);
        }

        if (!empty($filters['subject_id'])) {
            $this->db->where('subjects.id', $filters['subject_id']);
        }

        if (!empty($filters['enrolment_type'])) {
            $this->db->where('enrolment.enrolment_type', $filters['enrolment_type']);
        }

        if (!empty($filters['status'])) {
            $this->db->where('enrolment.status', $filters['status']);
        }

        $this->db->order_by('students.firstname', 'ASC');
        $this->db->order_by('students.lastname', 'ASC');

        return $this->db->get()->result();
    }
}
