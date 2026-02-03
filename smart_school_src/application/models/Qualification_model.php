<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Qualification Model
 * Handles qualifications under programmes (Business Management, Engineering Studies, etc.)
 */
class Qualification_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get qualification by ID or all qualifications
     * @param int $id Qualification ID (optional)
     * @return object|array Single qualification or array of qualifications
     */
    public function get($id = null)
    {
        $this->db->select('qualification.*, programme.name as programme_name, programme.code as programme_code');
        $this->db->from('qualification');
        $this->db->join('programme', 'qualification.programme_id = programme.id');

        if ($id) {
            $this->db->where('qualification.id', $id);
            return $this->db->get()->row();
        }

        $this->db->where('qualification.is_active', 1);
        $this->db->order_by('programme.name', 'ASC');
        $this->db->order_by('qualification.name', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Get qualifications by programme ID
     * @param int $programme_id Programme ID
     * @return array Array of qualifications
     */
    public function getByProgramme($programme_id)
    {
        $this->db->select('qualification.*, programme.name as programme_name');
        $this->db->from('qualification');
        $this->db->join('programme', 'qualification.programme_id = programme.id');
        $this->db->where('qualification.programme_id', $programme_id);
        $this->db->where('qualification.is_active', 1);
        $this->db->order_by('qualification.name', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Get qualification by code
     * @param string $code Qualification code
     * @param int $programme_id Programme ID (optional)
     * @return object Qualification object
     */
    public function getByCode($code, $programme_id = null)
    {
        $this->db->where('code', $code);
        $this->db->where('is_active', 1);

        if ($programme_id) {
            $this->db->where('programme_id', $programme_id);
        }

        return $this->db->get('qualification')->row();
    }

    /**
     * Add new qualification
     * @param array $data Qualification data
     * @return int Insert ID
     */
    public function add($data)
    {
        if ($this->db->insert('qualification', $data)) {
            return $this->db->insert_id();
        }
        return false;
    }

    /**
     * Update qualification
     * @param int $id Qualification ID
     * @param array $data Qualification data
     * @return bool Success status
     */
    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('qualification', $data);
    }

    /**
     * Delete qualification (soft delete)
     * @param int $id Qualification ID
     * @return bool Success status
     */
    public function remove($id)
    {
        $data = array('is_active' => 0);
        $this->db->where('id', $id);
        return $this->db->update('qualification', $data);
    }

    /**
     * Get qualifications with subject count
     * @param int $programme_id Programme ID (optional)
     * @return array Qualifications with counts
     */
    public function getQualificationsWithCounts($programme_id = null)
    {
        $this->db->select('qualification.*, programme.name as programme_name, COUNT(subjects.id) as subject_count');
        $this->db->from('qualification');
        $this->db->join('programme', 'qualification.programme_id = programme.id');
        $this->db->join('subjects', 'subjects.qualification_id = qualification.id', 'left');
        $this->db->where('qualification.is_active', 1);

        if ($programme_id) {
            $this->db->where('qualification.programme_id', $programme_id);
        }

        $this->db->group_by('qualification.id');
        $this->db->order_by('programme.name', 'ASC');
        $this->db->order_by('qualification.name', 'ASC');
        return $this->db->get()->result();
    }
}
