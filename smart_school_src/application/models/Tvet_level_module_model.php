<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Tvet_level_module_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();
    }

    public function getAll()
    {
        $this->db->select('tvet_level_module.*, tvet_level.name as level_name, tvet_level.code as level_code, tvet_qualification.name as qualification_name, tvet_programme.name as programme_name, subjects.name as subject_name');
        $this->db->from('tvet_level_module');
        $this->db->join('tvet_level', 'tvet_level.id = tvet_level_module.level_id');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        $this->db->join('subjects', 'subjects.id = tvet_level_module.subject_id', 'left');
        $this->db->order_by('tvet_programme.name, tvet_qualification.name, tvet_level.sequence, tvet_level_module.semester, tvet_level_module.module_name', 'ASC');
        return $this->db->get()->result_array();
    }

    public function get($id)
    {
        $this->db->select('tvet_level_module.*, tvet_level.name as level_name, tvet_qualification.name as qualification_name, tvet_programme.name as programme_name, subjects.name as subject_name');
        $this->db->from('tvet_level_module');
        $this->db->join('tvet_level', 'tvet_level.id = tvet_level_module.level_id');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        $this->db->join('subjects', 'subjects.id = tvet_level_module.subject_id', 'left');
        $this->db->where('tvet_level_module.id', $id);
        return $this->db->get()->row_array();
    }

    public function getByLevel($level_id)
    {
        $this->db->select('tvet_level_module.*, subjects.name as subject_name');
        $this->db->from('tvet_level_module');
        $this->db->join('subjects', 'subjects.id = tvet_level_module.subject_id', 'left');
        $this->db->where('tvet_level_module.level_id', $level_id);
        $this->db->where('tvet_level_module.active', 1);
        $this->db->order_by('tvet_level_module.semester, tvet_level_module.module_name', 'ASC');
        return $this->db->get()->result_array();
    }

    public function getByLevelWithSubject($level_id)
    {
        $this->db->select('tvet_level_module.*, subjects.id as subject_id, subjects.name as subject_name, subjects.code as subject_code, subjects.type as subject_type');
        $this->db->from('tvet_level_module');
        $this->db->join('subjects', 'subjects.id = tvet_level_module.subject_id', 'left');
        $this->db->where('tvet_level_module.level_id', $level_id);
        $this->db->where('tvet_level_module.active', 1);
        $this->db->order_by('tvet_level_module.semester, tvet_level_module.module_name', 'ASC');
        return $this->db->get()->result_array();
    }

    public function add($data)
    {
        $this->db->insert('tvet_level_module', [
            'level_id'    => $data['level_id'],
            'subject_id'  => $data['subject_id'],
            'module_code' => $data['module_code'],
            'module_name' => $data['module_name'],
            'credits'     => isset($data['credits']) ? $data['credits'] : 0,
            'semester'    => isset($data['semester']) ? $data['semester'] : 'Year',
            'is_core'     => isset($data['is_core']) ? $data['is_core'] : 1,
            'active'      => isset($data['active']) ? $data['active'] : 1
        ]);
        return $this->db->insert_id();
    }

    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('tvet_level_module', [
            'level_id'    => $data['level_id'],
            'subject_id'  => $data['subject_id'],
            'module_code' => $data['module_code'],
            'module_name' => $data['module_name'],
            'credits'     => isset($data['credits']) ? $data['credits'] : 0,
            'semester'    => isset($data['semester']) ? $data['semester'] : 'Year',
            'is_core'     => isset($data['is_core']) ? $data['is_core'] : 1,
            'active'      => isset($data['active']) ? $data['active'] : 1
        ]);
    }

    public function delete($id)
    {
        $this->db->where('id', $id);
        return $this->db->delete('tvet_level_module');
    }
}
