<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Level Model
 * Handles TVET levels (N1-N6, NCV L2-L4, etc.)
 */
class Level_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get level by ID or all levels
     * @param int $id Level ID (optional)
     * @return object|array Single level or array of levels
     */
    public function get($id = null)
    {
        if ($id) {
            $query = $this->db->where('id', $id)->get('level');
            return $query->row();
        }

        $query = $this->db->where('is_active', 1)
            ->order_by('code', 'ASC')
            ->get('level');
        return $query->result();
    }

    /**
     * Get level by code
     * @param string $code Level code (e.g., 'N4', 'NCV3')
     * @return object Level object
     */
    public function getByCode($code)
    {
        $query = $this->db->where('code', $code)
            ->where('is_active', 1)
            ->get('level');
        return $query->row();
    }

    /**
     * Get levels by type
     * @param string $type Level type (NATED, NCV, Other)
     * @return array Array of levels
     */
    public function getByType($type)
    {
        $query = $this->db->where('level_type', $type)
            ->where('is_active', 1)
            ->order_by('code', 'ASC')
            ->get('level');
        return $query->result();
    }

    /**
     * Get NATED levels (N1-N6)
     * @return array Array of NATED levels
     */
    public function getNatedLevels()
    {
        return $this->getByType('NATED');
    }

    /**
     * Get NCV levels (L2-L4)
     * @return array Array of NCV levels
     */
    public function getNcvLevels()
    {
        return $this->getByType('NCV');
    }

    /**
     * Get levels by NQF level
     * @param int $nqf_level NQF Level (2-6)
     * @return array Array of levels
     */
    public function getByNqfLevel($nqf_level)
    {
        $query = $this->db->where('nqf_level', $nqf_level)
            ->where('is_active', 1)
            ->order_by('code', 'ASC')
            ->get('level');
        return $query->result();
    }

    /**
     * Add new level
     * @param array $data Level data
     * @return int Insert ID
     */
    public function add($data)
    {
        if ($this->db->insert('level', $data)) {
            return $this->db->insert_id();
        }
        return false;
    }

    /**
     * Update level
     * @param int $id Level ID
     * @param array $data Level data
     * @return bool Success status
     */
    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('level', $data);
    }

    /**
     * Delete level (soft delete)
     * @param int $id Level ID
     * @return bool Success status
     */
    public function remove($id)
    {
        $data = array('is_active' => 0);
        $this->db->where('id', $id);
        return $this->db->update('level', $data);
    }

    /**
     * Get levels with class count
     * @return array Levels with counts
     */
    public function getLevelsWithCounts()
    {
        $this->db->select('level.*, COUNT(DISTINCT class.id) as class_count', FALSE);
        $this->db->from('level');
        $this->db->join('subject_level', 'subject_level.level_id = level.id', 'left');
        $this->db->join('class', 'class.subject_level_id = subject_level.id', 'left');
        $this->db->where('level.is_active', 1);
        $this->db->group_by('level.id');
        $this->db->order_by('level.code', 'ASC');
        return $this->db->get()->result();
    }
}
