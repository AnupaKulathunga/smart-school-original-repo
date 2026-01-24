<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Tvet_lecturer_allocation_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();
    }

    public function getAll()
    {
        $this->db->select('tvet_lecturer_allocation.*, staff.name as staff_name, staff.surname as staff_surname, tvet_cohort.name as cohort_name, tvet_level_module.module_name, tvet_level_module.module_code');
        $this->db->from('tvet_lecturer_allocation');
        $this->db->join('staff', 'staff.id = tvet_lecturer_allocation.staff_id', 'left');
        $this->db->join('tvet_cohort', 'tvet_cohort.id = tvet_lecturer_allocation.cohort_id');
        $this->db->join('tvet_level_module', 'tvet_level_module.id = tvet_lecturer_allocation.level_module_id');
        $this->db->order_by('staff.surname, staff.name, tvet_cohort.name, tvet_level_module.module_name', 'ASC');
        return $this->db->get()->result_array();
    }

    public function get($id)
    {
        $this->db->select('tvet_lecturer_allocation.*, staff.name as staff_name, staff.surname as staff_surname, tvet_cohort.name as cohort_name, tvet_level_module.module_name, tvet_level_module.module_code');
        $this->db->from('tvet_lecturer_allocation');
        $this->db->join('staff', 'staff.id = tvet_lecturer_allocation.staff_id', 'left');
        $this->db->join('tvet_cohort', 'tvet_cohort.id = tvet_lecturer_allocation.cohort_id');
        $this->db->join('tvet_level_module', 'tvet_level_module.id = tvet_lecturer_allocation.level_module_id');
        $this->db->where('tvet_lecturer_allocation.id', $id);
        return $this->db->get()->row_array();
    }

    public function getByCohort($cohort_id)
    {
        $this->db->select('tvet_lecturer_allocation.*, staff.name as staff_name, staff.surname as staff_surname, tvet_level_module.module_name, tvet_level_module.module_code');
        $this->db->from('tvet_lecturer_allocation');
        $this->db->join('staff', 'staff.id = tvet_lecturer_allocation.staff_id', 'left');
        $this->db->join('tvet_level_module', 'tvet_level_module.id = tvet_lecturer_allocation.level_module_id');
        $this->db->where('tvet_lecturer_allocation.cohort_id', $cohort_id);
        $this->db->where('tvet_lecturer_allocation.active', 1);
        $this->db->order_by('tvet_level_module.module_name', 'ASC');
        return $this->db->get()->result_array();
    }

    public function getByStaff($staff_id)
    {
        $this->db->select('tvet_lecturer_allocation.*, tvet_cohort.name as cohort_name, tvet_cohort.code as cohort_code, tvet_level_module.module_name, tvet_level_module.module_code');
        $this->db->from('tvet_lecturer_allocation');
        $this->db->join('tvet_cohort', 'tvet_cohort.id = tvet_lecturer_allocation.cohort_id');
        $this->db->join('tvet_level_module', 'tvet_level_module.id = tvet_lecturer_allocation.level_module_id');
        $this->db->where('tvet_lecturer_allocation.staff_id', $staff_id);
        $this->db->where('tvet_lecturer_allocation.active', 1);
        $this->db->order_by('tvet_lecturer_allocation.academic_year', 'DESC');
        $this->db->order_by('tvet_cohort.name', 'ASC');
        $this->db->order_by('tvet_level_module.module_name', 'ASC');
        return $this->db->get()->result_array();
    }

    public function add($data)
    {
        $this->db->insert('tvet_lecturer_allocation', [
            'staff_id'        => $data['staff_id'],
            'cohort_id'       => $data['cohort_id'],
            'level_module_id' => $data['level_module_id'],
            'academic_year'   => $data['academic_year'],
            'semester'        => isset($data['semester']) ? $data['semester'] : 'Year',
            'is_primary'      => isset($data['is_primary']) ? $data['is_primary'] : 1,
            'active'          => isset($data['active']) ? $data['active'] : 1
        ]);
        return $this->db->insert_id();
    }

    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('tvet_lecturer_allocation', [
            'staff_id'        => $data['staff_id'],
            'cohort_id'       => $data['cohort_id'],
            'level_module_id' => $data['level_module_id'],
            'academic_year'   => $data['academic_year'],
            'semester'        => isset($data['semester']) ? $data['semester'] : 'Year',
            'is_primary'      => isset($data['is_primary']) ? $data['is_primary'] : 1,
            'active'          => isset($data['active']) ? $data['active'] : 1
        ]);
    }

    public function delete($id)
    {
        $this->db->where('id', $id);
        return $this->db->delete('tvet_lecturer_allocation');
    }
}
