<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Academic Subject Level Model
 * Manages which subjects are offered at which levels
 */
class Academic_subject_level_model extends CI_Model
{
    private $table = 'academic_subject_level';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get all subject-level mappings with details
     */
    public function getAll($active_only = true)
    {
        $this->db->select('sl.*, s.code as subject_code, s.name as subject_name, s.programme_id,
                          l.code as level_code, l.name as level_name, l.nqf_level,
                          p.name as programme_name');
        $this->db->from($this->table . ' sl');
        $this->db->join('academic_subject s', 's.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->join('academic_programme p', 'p.id = s.programme_id');

        if ($active_only) {
            $this->db->where('sl.is_active', 1);
        }

        return $this->db->order_by('p.name', 'ASC')
            ->order_by('s.name', 'ASC')
            ->order_by('l.sequence_order', 'ASC')
            ->get()->result();
    }

    /**
     * Get subject-level by ID with details
     */
    public function get($id)
    {
        return $this->db->select('sl.*, s.code as subject_code, s.name as subject_name, s.programme_id,
                                  l.code as level_code, l.name as level_name, l.nqf_level,
                                  p.name as programme_name')
            ->from($this->table . ' sl')
            ->join('academic_subject s', 's.id = sl.subject_id')
            ->join('academic_level l', 'l.id = sl.level_id')
            ->join('academic_programme p', 'p.id = s.programme_id')
            ->where('sl.id', $id)
            ->get()->row();
    }

    /**
     * Get by subject and level
     */
    public function getBySubjectLevel($subject_id, $level_id)
    {
        return $this->db->where('subject_id', $subject_id)
            ->where('level_id', $level_id)
            ->get($this->table)->row();
    }

    /**
     * Get levels by subject
     */
    public function getLevelsBySubject($subject_id)
    {
        return $this->db->select('sl.*, l.code as level_code, l.name as level_name, l.nqf_level')
            ->from($this->table . ' sl')
            ->join('academic_level l', 'l.id = sl.level_id')
            ->where('sl.subject_id', $subject_id)
            ->where('sl.is_active', 1)
            ->order_by('l.sequence_order', 'ASC')
            ->get()->result();
    }

    /**
     * Get subjects by level
     */
    public function getSubjectsByLevel($level_id)
    {
        return $this->db->select('sl.*, s.code as subject_code, s.name as subject_name,
                                  p.name as programme_name')
            ->from($this->table . ' sl')
            ->join('academic_subject s', 's.id = sl.subject_id')
            ->join('academic_programme p', 'p.id = s.programme_id')
            ->where('sl.level_id', $level_id)
            ->where('sl.is_active', 1)
            ->order_by('s.name', 'ASC')
            ->get()->result();
    }

    /**
     * Add subject-level mapping
     */
    public function add($data)
    {
        $insert_data = array(
            'subject_id' => $data['subject_id'],
            'level_id' => $data['level_id'],
            'subject_code_full' => isset($data['subject_code_full']) ? $data['subject_code_full'] : null,
            'is_active' => isset($data['is_active']) ? $data['is_active'] : 1
        );

        $this->db->insert($this->table, $insert_data);
        return $this->db->insert_id();
    }

    /**
     * Update subject-level mapping
     */
    public function update($id, $data)
    {
        $update_data = array();

        if (isset($data['subject_code_full'])) $update_data['subject_code_full'] = $data['subject_code_full'];
        if (isset($data['is_active'])) $update_data['is_active'] = $data['is_active'];

        return $this->db->where('id', $id)->update($this->table, $update_data);
    }

    /**
     * Delete mapping
     */
    public function delete($id)
    {
        return $this->db->where('id', $id)->delete($this->table);
    }

    /**
     * Check if mapping exists
     */
    public function exists($subject_id, $level_id, $exclude_id = null)
    {
        $this->db->where('subject_id', $subject_id);
        $this->db->where('level_id', $level_id);
        if ($exclude_id) {
            $this->db->where('id !=', $exclude_id);
        }
        return $this->db->count_all_results($this->table) > 0;
    }

    /**
     * Get dropdown for class creation (grouped by subject)
     */
    public function getDropdownGrouped()
    {
        $result = array();
        $mappings = $this->getAll();

        foreach ($mappings as $m) {
            $group = $m->programme_name . ' - ' . $m->subject_name;
            if (!isset($result[$group])) {
                $result[$group] = array();
            }
            $result[$group][$m->id] = $m->level_code . ' - ' . $m->level_name;
        }

        return $result;
    }
}
