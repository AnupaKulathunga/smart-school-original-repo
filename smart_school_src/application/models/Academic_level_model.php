<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Academic Level Model
 * Manages qualification levels (N1-N6, NCV L2-L4)
 */
class Academic_level_model extends CI_Model
{
    private $table = 'academic_level';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get all levels
     */
    public function getAll($active_only = true)
    {
        if ($active_only) {
            $this->db->where('is_active', 1);
        }
        return $this->db->order_by('sequence_order', 'ASC')->get($this->table)->result();
    }

    /**
     * Get level by ID
     */
    public function get($id)
    {
        return $this->db->where('id', $id)->get($this->table)->row();
    }

    /**
     * Get level by code
     */
    public function getByCode($code)
    {
        return $this->db->where('code', $code)->get($this->table)->row();
    }

    /**
     * Get levels by programme
     */
    public function getByProgramme($programme_id, $active_only = true)
    {
        $this->db->where('programme_id', $programme_id);
        if ($active_only) {
            $this->db->where('is_active', 1);
        }
        return $this->db->order_by('sequence_order', 'ASC')->get($this->table)->result();
    }

    /**
     * Get levels available for a subject
     */
    public function getBySubject($subject_id)
    {
        return $this->db->select('l.*, sl.id as subject_level_id, sl.subject_code_full')
            ->from($this->table . ' l')
            ->join('academic_subject_level sl', 'sl.level_id = l.id')
            ->where('sl.subject_id', $subject_id)
            ->where('sl.is_active', 1)
            ->where('l.is_active', 1)
            ->order_by('l.sequence_order', 'ASC')
            ->get()->result();
    }

    /**
     * Add new level
     */
    public function add($data)
    {
        $insert_data = array(
            'programme_id' => isset($data['programme_id']) ? $data['programme_id'] : null,
            'code' => $data['code'],
            'name' => $data['name'],
            'level_type' => isset($data['level_type']) ? $data['level_type'] : null,
            'nqf_level' => isset($data['nqf_level']) ? $data['nqf_level'] : null,
            'sequence_order' => isset($data['sequence']) ? $data['sequence'] : (isset($data['sequence_order']) ? $data['sequence_order'] : 1),
            'is_active' => isset($data['is_active']) ? $data['is_active'] : 1
        );

        $this->db->insert($this->table, $insert_data);
        return $this->db->insert_id();
    }

    /**
     * Update level
     */
    public function update($id, $data)
    {
        $update_data = array();

        if (isset($data['programme_id'])) $update_data['programme_id'] = $data['programme_id'];
        if (isset($data['code'])) $update_data['code'] = $data['code'];
        if (isset($data['name'])) $update_data['name'] = $data['name'];
        if (isset($data['nqf_level'])) $update_data['nqf_level'] = $data['nqf_level'];
        if (isset($data['sequence_order'])) $update_data['sequence_order'] = $data['sequence_order'];
        if (isset($data['is_active'])) $update_data['is_active'] = $data['is_active'];

        return $this->db->where('id', $id)->update($this->table, $update_data);
    }

    /**
     * Delete level
     */
    public function delete($id)
    {
        return $this->db->where('id', $id)->delete($this->table);
    }

    /**
     * Check if code exists (excluding given ID)
     */
    public function codeExists($code, $exclude_id = null)
    {
        $this->db->where('code', $code);
        if ($exclude_id) {
            $this->db->where('id !=', $exclude_id);
        }
        return $this->db->count_all_results($this->table) > 0;
    }

    /**
     * Get levels for dropdown
     */
    public function getDropdown($programme_id = null)
    {
        $result = array('' => '-- Select Level --');

        if ($programme_id) {
            $levels = $this->getByProgramme($programme_id);
        } else {
            $levels = $this->getAll();
        }

        foreach ($levels as $l) {
            $nqf = $l->nqf_level ? ' (NQF ' . $l->nqf_level . ')' : '';
            $result[$l->id] = $l->code . ' - ' . $l->name . $nqf;
        }
        return $result;
    }
}
