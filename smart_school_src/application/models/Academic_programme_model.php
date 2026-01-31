<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Academic Programme Model
 * Manages programmes (NATED, NCV, Occupational)
 */
class Academic_programme_model extends CI_Model
{
    private $table = 'academic_programme';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get all active programmes
     */
    public function getAll($active_only = true)
    {
        if ($active_only) {
            $this->db->where('is_active', 1);
        }
        return $this->db->order_by('name', 'ASC')->get($this->table)->result();
    }

    /**
     * Get programme by ID
     */
    public function get($id)
    {
        return $this->db->where('id', $id)->get($this->table)->row();
    }

    /**
     * Get programme by code
     */
    public function getByCode($code)
    {
        return $this->db->where('code', $code)->get($this->table)->row();
    }

    /**
     * Add new programme
     */
    public function add($data)
    {
        $insert_data = array(
            'code' => $data['code'],
            'name' => $data['name'],
            'description' => isset($data['description']) ? $data['description'] : null,
            'qualification_type' => isset($data['qualification_type']) ? $data['qualification_type'] : null,
            'duration_years' => isset($data['duration_years']) ? $data['duration_years'] : 3,
            'is_active' => isset($data['is_active']) ? $data['is_active'] : 1
        );

        $this->db->insert($this->table, $insert_data);
        return $this->db->insert_id();
    }

    /**
     * Update programme
     */
    public function update($id, $data)
    {
        $update_data = array();

        if (isset($data['code'])) $update_data['code'] = $data['code'];
        if (isset($data['name'])) $update_data['name'] = $data['name'];
        if (isset($data['description'])) $update_data['description'] = $data['description'];
        if (isset($data['qualification_type'])) $update_data['qualification_type'] = $data['qualification_type'];
        if (isset($data['duration_years'])) $update_data['duration_years'] = $data['duration_years'];
        if (isset($data['is_active'])) $update_data['is_active'] = $data['is_active'];

        return $this->db->where('id', $id)->update($this->table, $update_data);
    }

    /**
     * Delete programme
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
     * Get programmes for dropdown
     */
    public function getDropdown()
    {
        $result = array('' => '-- Select Programme --');
        $programmes = $this->getAll();
        foreach ($programmes as $p) {
            $result[$p->id] = $p->name . ' (' . $p->code . ')';
        }
        return $result;
    }

    /**
     * Get programme statistics
     */
    public function getStats($programme_id)
    {
        $stats = new stdClass();

        // Count subjects
        $stats->subjects = $this->db->where('programme_id', $programme_id)
            ->where('is_active', 1)
            ->count_all_results('academic_subject');

        // Count classes
        $stats->classes = $this->db->select('COUNT(DISTINCT c.id) as count')
            ->from('academic_class c')
            ->join('academic_subject_level sl', 'sl.id = c.subject_level_id')
            ->join('academic_subject s', 's.id = sl.subject_id')
            ->where('s.programme_id', $programme_id)
            ->where('c.is_active', 1)
            ->get()->row()->count;

        // Count enrolled students
        $stats->students = $this->db->select('COUNT(DISTINCT e.student_id) as count')
            ->from('academic_class_enrolment e')
            ->join('academic_class c', 'c.id = e.class_id')
            ->join('academic_subject_level sl', 'sl.id = c.subject_level_id')
            ->join('academic_subject s', 's.id = sl.subject_id')
            ->where('s.programme_id', $programme_id)
            ->where('e.status', 'Active')
            ->get()->row()->count;

        return $stats;
    }
}
