<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Tvet_level_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();
    }

    public function getAll($active_only = true)
    {
        $this->db->select('tvet_level.*, tvet_qualification.name as qualification_name, tvet_qualification.code as qualification_code, tvet_programme.name as programme_name, tvet_programme.code as programme_code');
        $this->db->from('tvet_level');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        if ($active_only) {
            $this->db->where('tvet_level.active', 1);
        }
        $this->db->order_by('tvet_programme.name, tvet_qualification.name, tvet_level.sequence', 'ASC');
        return $this->db->get()->result_array();
    }

    public function get($id)
    {
        $this->db->select('tvet_level.*, tvet_qualification.name as qualification_name, tvet_qualification.programme_id, tvet_programme.name as programme_name');
        $this->db->from('tvet_level');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        $this->db->where('tvet_level.id', $id);
        return $this->db->get()->row_array();
    }

    public function getByQualification($qualification_id)
    {
        $this->db->where('qualification_id', $qualification_id);
        $this->db->where('active', 1);
        $this->db->order_by('sequence', 'ASC');
        return $this->db->get('tvet_level')->result_array();
    }

    public function getLevelWithDetails($id)
    {
        $this->db->select('tvet_level.*, tvet_qualification.name as qualification_name, tvet_qualification.code as qualification_code, tvet_programme.name as programme_name, tvet_programme.code as programme_code');
        $this->db->from('tvet_level');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        $this->db->where('tvet_level.id', $id);
        return $this->db->get()->row_array();
    }

    public function add($data)
    {
        $this->db->insert('tvet_level', [
            'qualification_id' => $data['qualification_id'],
            'code'             => $data['code'],
            'name'             => $data['name'],
            'sequence'         => isset($data['sequence']) ? $data['sequence'] : 0,
            'active'           => isset($data['active']) ? $data['active'] : 1
        ]);
        return $this->db->insert_id();
    }

    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('tvet_level', [
            'qualification_id' => $data['qualification_id'],
            'code'             => $data['code'],
            'name'             => $data['name'],
            'sequence'         => isset($data['sequence']) ? $data['sequence'] : 0,
            'active'           => isset($data['active']) ? $data['active'] : 1
        ]);
    }

    public function delete($id)
    {
        $this->db->where('id', $id);
        return $this->db->delete('tvet_level');
    }

    public function hasCohorts($id)
    {
        return $this->db->where('level_id', $id)->count_all_results('tvet_cohort') > 0;
    }
}
