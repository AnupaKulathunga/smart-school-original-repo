<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Academic Subject Model
 * Manages subjects under programmes (Mathematics, Engineering Science, etc.)
 */
class Academic_subject_model extends CI_Model
{
    private $table = 'academic_subject';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get all subjects with programme info
     */
    public function getAll($active_only = true)
    {
        $this->db->select('s.*, p.name as programme_name, p.code as programme_code');
        $this->db->from($this->table . ' s');
        $this->db->join('academic_programme p', 'p.id = s.programme_id', 'left');

        if ($active_only) {
            $this->db->where('s.is_active', 1);
        }

        return $this->db->order_by('s.name', 'ASC')->get()->result();
    }

    /**
     * Get subject by ID with programme info
     */
    public function get($id)
    {
        return $this->db->select('s.*, p.name as programme_name, p.code as programme_code')
            ->from($this->table . ' s')
            ->join('academic_programme p', 'p.id = s.programme_id', 'left')
            ->where('s.id', $id)
            ->get()->row();
    }

    /**
     * Get subjects by programme
     */
    public function getByProgramme($programme_id, $active_only = true)
    {
        $this->db->where('programme_id', $programme_id);
        if ($active_only) {
            $this->db->where('is_active', 1);
        }
        return $this->db->order_by('name', 'ASC')->get($this->table)->result();
    }

    /**
     * Add new subject
     */
    public function add($data)
    {
        $insert_data = array(
            'programme_id' => $data['programme_id'],
            'code' => $data['code'],
            'name' => $data['name'],
            'description' => isset($data['description']) ? $data['description'] : null,
            'credits' => isset($data['credits']) ? $data['credits'] : 0,
            'notional_hours' => isset($data['notional_hours']) ? $data['notional_hours'] : 0,
            'is_core' => isset($data['is_core']) ? $data['is_core'] : 1,
            'is_active' => isset($data['is_active']) ? $data['is_active'] : 1
        );

        $this->db->insert($this->table, $insert_data);
        return $this->db->insert_id();
    }

    /**
     * Update subject
     */
    public function update($id, $data)
    {
        $update_data = array();

        if (isset($data['programme_id'])) $update_data['programme_id'] = $data['programme_id'];
        if (isset($data['code'])) $update_data['code'] = $data['code'];
        if (isset($data['name'])) $update_data['name'] = $data['name'];
        if (isset($data['description'])) $update_data['description'] = $data['description'];
        if (isset($data['credits'])) $update_data['credits'] = $data['credits'];
        if (isset($data['notional_hours'])) $update_data['notional_hours'] = $data['notional_hours'];
        if (isset($data['is_core'])) $update_data['is_core'] = $data['is_core'];
        if (isset($data['is_active'])) $update_data['is_active'] = $data['is_active'];

        return $this->db->where('id', $id)->update($this->table, $update_data);
    }

    /**
     * Delete subject
     */
    public function delete($id)
    {
        return $this->db->where('id', $id)->delete($this->table);
    }

    /**
     * Check if code exists within programme (excluding given ID)
     */
    public function codeExists($code, $programme_id, $exclude_id = null)
    {
        $this->db->where('code', $code);
        $this->db->where('programme_id', $programme_id);
        if ($exclude_id) {
            $this->db->where('id !=', $exclude_id);
        }
        return $this->db->count_all_results($this->table) > 0;
    }

    /**
     * Get subjects for dropdown by programme
     */
    public function getDropdownByProgramme($programme_id)
    {
        $result = array();
        $subjects = $this->getByProgramme($programme_id);
        foreach ($subjects as $s) {
            $result[$s->id] = $s->name . ' (' . $s->code . ')';
        }
        return $result;
    }

    /**
     * Get subjects with level mappings
     */
    public function getWithLevels($subject_id)
    {
        return $this->db->select('sl.*, l.code as level_code, l.name as level_name, l.nqf_level')
            ->from('academic_subject_level sl')
            ->join('academic_level l', 'l.id = sl.level_id')
            ->where('sl.subject_id', $subject_id)
            ->where('sl.is_active', 1)
            ->order_by('l.sequence_order', 'ASC')
            ->get()->result();
    }
}
