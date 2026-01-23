<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Tvet_qualification_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();
    }

    public function getAll($active_only = true)
    {
        $this->db->select('tvet_qualification.*, tvet_programme.name as programme_name, tvet_programme.code as programme_code');
        $this->db->from('tvet_qualification');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        if ($active_only) {
            $this->db->where('tvet_qualification.active', 1);
        }
        $this->db->order_by('tvet_programme.name, tvet_qualification.name', 'ASC');
        return $this->db->get()->result_array();
    }

    public function get($id)
    {
        $this->db->select('tvet_qualification.*, tvet_programme.name as programme_name');
        $this->db->from('tvet_qualification');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        $this->db->where('tvet_qualification.id', $id);
        return $this->db->get()->row_array();
    }

    public function getByProgramme($programme_id)
    {
        $this->db->where('programme_id', $programme_id);
        $this->db->where('active', 1);
        $this->db->order_by('name', 'ASC');
        return $this->db->get('tvet_qualification')->result_array();
    }

    public function add($data)
    {
        $this->db->insert('tvet_qualification', [
            'programme_id' => $data['programme_id'],
            'code'         => $data['code'],
            'name'         => $data['name'],
            'description'  => isset($data['description']) ? $data['description'] : null,
            'active'       => isset($data['active']) ? $data['active'] : 1
        ]);
        return $this->db->insert_id();
    }

    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('tvet_qualification', [
            'programme_id' => $data['programme_id'],
            'code'         => $data['code'],
            'name'         => $data['name'],
            'description'  => isset($data['description']) ? $data['description'] : null,
            'active'       => isset($data['active']) ? $data['active'] : 1
        ]);
    }

    public function delete($id)
    {
        $this->db->where('id', $id);
        return $this->db->delete('tvet_qualification');
    }

    public function hasLevels($id)
    {
        return $this->db->where('qualification_id', $id)->count_all_results('tvet_level') > 0;
    }
}
