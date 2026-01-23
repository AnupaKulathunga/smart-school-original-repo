<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Tvet_programme_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();
    }

    public function getAll($active_only = true)
    {
        if ($active_only) {
            $this->db->where('active', 1);
        }
        $this->db->order_by('name', 'ASC');
        return $this->db->get('tvet_programme')->result_array();
    }

    public function get($id)
    {
        return $this->db->get_where('tvet_programme', ['id' => $id])->row_array();
    }

    public function add($data)
    {
        $this->db->insert('tvet_programme', [
            'code'        => $data['code'],
            'name'        => $data['name'],
            'description' => isset($data['description']) ? $data['description'] : null,
            'active'      => isset($data['active']) ? $data['active'] : 1
        ]);
        return $this->db->insert_id();
    }

    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('tvet_programme', [
            'code'        => $data['code'],
            'name'        => $data['name'],
            'description' => isset($data['description']) ? $data['description'] : null,
            'active'      => isset($data['active']) ? $data['active'] : 1
        ]);
    }

    public function delete($id)
    {
        $this->db->where('id', $id);
        return $this->db->delete('tvet_programme');
    }

    public function hasQualifications($id)
    {
        return $this->db->where('programme_id', $id)->count_all_results('tvet_qualification') > 0;
    }
}
