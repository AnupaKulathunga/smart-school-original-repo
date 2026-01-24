<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Tvet_cohort_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();
    }

    public function getAll($active_only = true)
    {
        $this->db->select('tvet_cohort.*, tvet_level.name as level_name, tvet_level.code as level_code, tvet_qualification.name as qualification_name, tvet_qualification.code as qualification_code, tvet_programme.name as programme_name, tvet_programme.code as programme_code');
        $this->db->from('tvet_cohort');
        $this->db->join('tvet_level', 'tvet_level.id = tvet_cohort.level_id');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        if ($active_only) {
            $this->db->where('tvet_cohort.active', 1);
        }
        $this->db->order_by('tvet_programme.name', 'ASC');
        $this->db->order_by('tvet_qualification.name', 'ASC');
        $this->db->order_by('tvet_level.sequence', 'ASC');
        $this->db->order_by('tvet_cohort.intake_year', 'DESC');
        $this->db->order_by('tvet_cohort.name', 'ASC');
        return $this->db->get()->result_array();
    }

    public function get($id)
    {
        return $this->db->get_where('tvet_cohort', ['id' => $id])->row_array();
    }

    public function getByLevel($level_id)
    {
        $this->db->where('level_id', $level_id);
        $this->db->where('active', 1);
        $this->db->order_by('intake_year', 'DESC');
        $this->db->order_by('name', 'ASC');
        return $this->db->get('tvet_cohort')->result_array();
    }

    public function getWithDetails($id)
    {
        $this->db->select('tvet_cohort.*, tvet_level.name as level_name, tvet_level.code as level_code, tvet_level.qualification_id, tvet_qualification.name as qualification_name, tvet_qualification.code as qualification_code, tvet_qualification.programme_id, tvet_programme.name as programme_name, tvet_programme.code as programme_code');
        $this->db->from('tvet_cohort');
        $this->db->join('tvet_level', 'tvet_level.id = tvet_cohort.level_id');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        $this->db->where('tvet_cohort.id', $id);
        return $this->db->get()->row_array();
    }

    public function getStudentCount($cohort_id)
    {
        return $this->db->where('cohort_id', $cohort_id)->count_all_results('tvet_student_enrolment');
    }

    public function add($data)
    {
        $this->db->insert('tvet_cohort', [
            'level_id'      => $data['level_id'],
            'code'          => $data['code'],
            'name'          => $data['name'],
            'intake_year'   => isset($data['intake_year']) ? $data['intake_year'] : null,
            'delivery_mode' => isset($data['delivery_mode']) ? $data['delivery_mode'] : null,
            'start_date'    => isset($data['start_date']) ? $data['start_date'] : null,
            'end_date'      => isset($data['end_date']) ? $data['end_date'] : null,
            'max_students'  => isset($data['max_students']) ? $data['max_students'] : null,
            'active'        => isset($data['active']) ? $data['active'] : 1
        ]);
        return $this->db->insert_id();
    }

    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('tvet_cohort', [
            'level_id'      => $data['level_id'],
            'code'          => $data['code'],
            'name'          => $data['name'],
            'intake_year'   => isset($data['intake_year']) ? $data['intake_year'] : null,
            'delivery_mode' => isset($data['delivery_mode']) ? $data['delivery_mode'] : null,
            'start_date'    => isset($data['start_date']) ? $data['start_date'] : null,
            'end_date'      => isset($data['end_date']) ? $data['end_date'] : null,
            'max_students'  => isset($data['max_students']) ? $data['max_students'] : null,
            'active'        => isset($data['active']) ? $data['active'] : 1
        ]);
    }

    public function delete($id)
    {
        $this->db->where('id', $id);
        return $this->db->delete('tvet_cohort');
    }

    public function hasStudents($id)
    {
        return $this->db->where('cohort_id', $id)->count_all_results('tvet_student_enrolment') > 0;
    }
}
