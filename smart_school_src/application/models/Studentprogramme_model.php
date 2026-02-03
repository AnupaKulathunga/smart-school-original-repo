<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Student Programme Model
 * Tracks student's MAIN programme registration
 * Students have ONE main programme but can take electives from others
 */
class Studentprogramme_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get student programme by ID
     * @param int $id Student programme ID
     * @return object Student programme object
     */
    public function get($id)
    {
        $this->db->select('student_programme.*,
            students.firstname, students.lastname, students.admission_no,
            programme.name as programme_name, programme.code as programme_code,
            qualification.name as qualification_name, qualification.code as qualification_code,
            level.name as level_name, level.code as level_code,
            sessions.session as session_name');
        $this->db->from('student_programme');
        $this->db->join('students', 'student_programme.student_id = students.id');
        $this->db->join('programme', 'student_programme.programme_id = programme.id');
        $this->db->join('qualification', 'student_programme.qualification_id = qualification.id', 'left');
        $this->db->join('level', 'student_programme.current_level_id = level.id', 'left');
        $this->db->join('sessions', 'student_programme.session_id = sessions.id');
        $this->db->where('student_programme.id', $id);
        return $this->db->get()->row();
    }

    /**
     * Get student's programme for a session
     * @param int $student_id Student ID
     * @param int $session_id Session ID (optional, defaults to active session)
     * @return object Student programme object
     */
    public function getStudentProgramme($student_id, $session_id = null)
    {
        $this->db->select('student_programme.*,
            programme.name as programme_name, programme.code as programme_code, programme.programme_type,
            qualification.name as qualification_name, qualification.code as qualification_code,
            level.name as level_name, level.code as level_code, level.level_type,
            sessions.session as session_name');
        $this->db->from('student_programme');
        $this->db->join('programme', 'student_programme.programme_id = programme.id');
        $this->db->join('qualification', 'student_programme.qualification_id = qualification.id', 'left');
        $this->db->join('level', 'student_programme.current_level_id = level.id', 'left');
        $this->db->join('sessions', 'student_programme.session_id = sessions.id');
        $this->db->where('student_programme.student_id', $student_id);
        $this->db->where('student_programme.is_active', 1);

        if ($session_id) {
            $this->db->where('student_programme.session_id', $session_id);
        } else {
            $this->db->where('sessions.is_active', 'yes');
        }

        return $this->db->get()->row();
    }

    /**
     * Get all student programmes by session
     * @param int $session_id Session ID
     * @param array $filters Optional filters (programme_id, qualification_id, level_id, status)
     * @return array Array of student programmes
     */
    public function getBySession($session_id, $filters = array())
    {
        $this->db->select('student_programme.*,
            students.firstname, students.lastname, students.admission_no,
            programme.name as programme_name,
            qualification.name as qualification_name,
            level.name as level_name');
        $this->db->from('student_programme');
        $this->db->join('students', 'student_programme.student_id = students.id');
        $this->db->join('programme', 'student_programme.programme_id = programme.id');
        $this->db->join('qualification', 'student_programme.qualification_id = qualification.id', 'left');
        $this->db->join('level', 'student_programme.current_level_id = level.id', 'left');
        $this->db->where('student_programme.session_id', $session_id);
        $this->db->where('student_programme.is_active', 1);
        $this->db->where('students.is_active', 'yes');

        // Apply filters
        if (!empty($filters['programme_id'])) {
            $this->db->where('student_programme.programme_id', $filters['programme_id']);
        }

        if (!empty($filters['qualification_id'])) {
            $this->db->where('student_programme.qualification_id', $filters['qualification_id']);
        }

        if (!empty($filters['level_id'])) {
            $this->db->where('student_programme.current_level_id', $filters['level_id']);
        }

        if (!empty($filters['status'])) {
            $this->db->where('student_programme.status', $filters['status']);
        }

        $this->db->order_by('students.firstname', 'ASC');
        $this->db->order_by('students.lastname', 'ASC');

        return $this->db->get()->result();
    }

    /**
     * Add new student programme
     * @param array $data Student programme data
     * @return int Insert ID or false
     */
    public function add($data)
    {
        // Check if student already has programme for this session
        $existing = $this->db->where('student_id', $data['student_id'])
            ->where('session_id', $data['session_id'])
            ->get('student_programme')->row();

        if ($existing) {
            return false; // Already exists
        }

        if ($this->db->insert('student_programme', $data)) {
            return $this->db->insert_id();
        }
        return false;
    }

    /**
     * Update student programme
     * @param int $id Student programme ID
     * @param array $data Student programme data
     * @return bool Success status
     */
    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('student_programme', $data);
    }

    /**
     * Update student's current level
     * @param int $student_id Student ID
     * @param int $session_id Session ID
     * @param int $level_id New level ID
     * @return bool Success status
     */
    public function updateLevel($student_id, $session_id, $level_id)
    {
        $data = array('current_level_id' => $level_id);
        $this->db->where('student_id', $student_id);
        $this->db->where('session_id', $session_id);
        return $this->db->update('student_programme', $data);
    }

    /**
     * Update student programme status
     * @param int $id Student programme ID
     * @param string $status New status
     * @return bool Success status
     */
    public function updateStatus($id, $status)
    {
        $data = array('status' => $status);

        if ($status == 'Completed') {
            $data['completion_date'] = date('Y-m-d');
        }

        $this->db->where('id', $id);
        return $this->db->update('student_programme', $data);
    }

    /**
     * Delete student programme (soft delete)
     * @param int $id Student programme ID
     * @return bool Success status
     */
    public function remove($id)
    {
        $data = array('is_active' => 0);
        $this->db->where('id', $id);
        return $this->db->update('student_programme', $data);
    }

    /**
     * Get programme statistics
     * @param int $session_id Session ID
     * @return array Array of programme statistics
     */
    public function getProgrammeStatistics($session_id)
    {
        $this->db->select('programme.name as programme_name,
            student_programme.status,
            COUNT(*) as student_count');
        $this->db->from('student_programme');
        $this->db->join('programme', 'student_programme.programme_id = programme.id');
        $this->db->where('student_programme.session_id', $session_id);
        $this->db->where('student_programme.is_active', 1);
        $this->db->group_by('programme.id, student_programme.status');
        $this->db->order_by('programme.name', 'ASC');
        return $this->db->get()->result();
    }
}
