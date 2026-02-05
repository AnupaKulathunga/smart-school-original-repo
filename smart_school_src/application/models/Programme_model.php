<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Programme Model
 * Handles NATED, NCV, Occupational programmes
 */
class Programme_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get programme by ID or all programmes
     * @param int $id Programme ID (optional)
     * @return object|array Single programme or array of programmes
     */
    public function get($id = null)
    {
        if ($id) {
            $query = $this->db->where('id', $id)->get('programme');
            return $query->row();
        }

        $query = $this->db->where('is_active', 1)
            ->order_by('programme_type', 'ASC')
            ->order_by('name', 'ASC')
            ->get('programme');
        return $query->result();
    }

    /**
     * Get programme by code
     * @param string $code Programme code (e.g., 'NATED', 'NCV')
     * @return object Programme object
     */
    public function getByCode($code)
    {
        $query = $this->db->where('code', $code)
            ->where('is_active', 1)
            ->get('programme');
        return $query->row();
    }

    /**
     * Get programmes by type
     * @param string $type Programme type (NATED, NCV, Occupational, Other)
     * @return array Array of programmes
     */
    public function getByType($type)
    {
        $query = $this->db->where('programme_type', $type)
            ->where('is_active', 1)
            ->order_by('name', 'ASC')
            ->get('programme');
        return $query->result();
    }

    /**
     * Add new programme
     * @param array $data Programme data
     * @return int Insert ID
     */
    public function add($data)
    {
        if ($this->db->insert('programme', $data)) {
            return $this->db->insert_id();
        }
        return false;
    }

    /**
     * Update programme
     * @param int $id Programme ID
     * @param array $data Programme data
     * @return bool Success status
     */
    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('programme', $data);
    }

    /**
     * Delete programme (soft delete)
     * @param int $id Programme ID
     * @return bool Success status
     */
    public function remove($id)
    {
        $data = array('is_active' => 0);
        $this->db->where('id', $id);
        return $this->db->update('programme', $data);
    }

    /**
     * Get programmes with qualification count
     * @return array Programmes with counts
     */
    public function getProgrammesWithCounts()
    {
        $this->db->select('programme.*, COUNT(qualification.id) as qualification_count', FALSE);
        $this->db->from('programme');
        $this->db->join('qualification', 'qualification.programme_id = programme.id', 'left');
        $this->db->where('programme.is_active', 1);
        $this->db->group_by('programme.id');
        $this->db->order_by('programme.name', 'ASC');
        $query = $this->db->get();
        return $query->result();
    }
}
