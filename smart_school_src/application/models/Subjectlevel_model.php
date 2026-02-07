<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Subject Level Model
 * Handles which subjects are offered at which levels
 */
class Subjectlevel_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get subject-level mapping by ID
     * @param int $id Subject-level ID
     * @return object Subject-level object
     */
    public function get($id)
    {
        $this->db->select('subject_level.*, subjects.name as subject_name, subjects.code as subject_code, level.name as level_name, level.code as level_code');
        $this->db->from('subject_level');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->where('subject_level.id', $id);
        return $this->db->get()->row();
    }

    /**
     * Get all subject-level mappings
     * @return array Array of subject-level mappings
     */
    public function getAll()
    {
        $this->db->select('subject_level.*, subjects.name as subject_name, subjects.code as subject_code, level.name as level_name, level.code as level_code');
        $this->db->from('subject_level');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->where('subject_level.is_active', 1);
        $this->db->order_by('subjects.name', 'ASC');
        $this->db->order_by('level.code', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Get subject-levels by level ID
     * @param int $level_id Level ID
     * @return array Array of subjects offered at this level
     */
    public function getByLevel($level_id)
    {
        $this->db->select('subject_level.*, subjects.name as subject_name, subjects.code as subject_code, subjects.credits, subjects.notional_hours');
        $this->db->from('subject_level');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->where('subject_level.level_id', $level_id);
        $this->db->where('subject_level.is_active', 1);
        $this->db->where('subjects.is_active', 'yes');
        $this->db->order_by('subjects.name', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Get subject-levels by subject ID
     * @param int $subject_id Subject ID
     * @return array Array of levels where this subject is offered
     */
    public function getBySubject($subject_id)
    {
        $this->db->select('subject_level.*, level.name as level_name, level.code as level_code, level.level_type, level.code');
        $this->db->from('subject_level');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->where('subject_level.subject_id', $subject_id);
        $this->db->where('subject_level.is_active', 1);
        $this->db->where('level.is_active', 1);
        $this->db->order_by('level.code', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Get subject-level by subject ID and level ID
     * @param int $subject_id Subject ID
     * @param int $level_id Level ID
     * @return object Subject-level object
     */
    public function getBySubjectAndLevel($subject_id, $level_id)
    {
        $this->db->select('subject_level.*, subjects.name as subject_name, level.name as level_name');
        $this->db->from('subject_level');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->where('subject_level.subject_id', $subject_id);
        $this->db->where('subject_level.level_id', $level_id);
        return $this->db->get()->row();
    }

    /**
     * Add new subject-level mapping
     * @param array $data Subject-level data
     * @return int Insert ID
     */
    public function add($data)
    {
        if ($this->db->insert('subject_level', $data)) {
            return $this->db->insert_id();
        }
        return false;
    }

    /**
     * Update subject-level mapping
     * @param int $id Subject-level ID
     * @param array $data Subject-level data
     * @return bool Success status
     */
    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('subject_level', $data);
    }

    /**
     * Delete subject-level mapping (soft delete)
     * @param int $id Subject-level ID
     * @return bool Success status
     */
    public function remove($id)
    {
        $data = array('is_active' => 0);
        $this->db->where('id', $id);
        return $this->db->update('subject_level', $data);
    }

    /**
     * Get subject-levels with class count
     * @param int $session_id Session ID (optional)
     * @return array Subject-levels with counts
     */
    public function getWithClassCounts($session_id = null)
    {
        $this->db->select('subject_level.*, subjects.name as subject_name, subjects.code as subject_code, level.name as level_name, level.code as level_code, COUNT(class.id) as class_count', FALSE);
        $this->db->from('subject_level');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->join('class', 'class.subject_level_id = subject_level.id AND class.is_active = 1', 'left');

        if ($session_id) {
            $this->db->where('class.session_id', $session_id);
        }

        $this->db->where('subject_level.is_active', 1);
        $this->db->group_by('subject_level.id');
        $this->db->order_by('subjects.name', 'ASC');
        $this->db->order_by('level.code', 'ASC');
        return $this->db->get()->result();
    }
}
