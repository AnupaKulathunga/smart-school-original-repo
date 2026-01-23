<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Tvet_student_enrolment_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();
    }

    public function getAll()
    {
        $this->db->select('tvet_student_enrolment.*, students.firstname, students.lastname, students.admission_no, tvet_level.name as level_name, tvet_level.code as level_code, tvet_qualification.name as qualification_name, tvet_programme.name as programme_name, tvet_cohort.name as cohort_name');
        $this->db->from('tvet_student_enrolment');
        $this->db->join('students', 'students.id = tvet_student_enrolment.student_id', 'left');
        $this->db->join('tvet_level', 'tvet_level.id = tvet_student_enrolment.level_id');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        $this->db->join('tvet_cohort', 'tvet_cohort.id = tvet_student_enrolment.cohort_id', 'left');
        $this->db->order_by('tvet_student_enrolment.enrolment_date', 'DESC');
        return $this->db->get()->result_array();
    }

    public function get($id)
    {
        $this->db->select('tvet_student_enrolment.*, students.firstname, students.lastname, students.admission_no, tvet_level.name as level_name, tvet_qualification.name as qualification_name, tvet_programme.name as programme_name, tvet_cohort.name as cohort_name');
        $this->db->from('tvet_student_enrolment');
        $this->db->join('students', 'students.id = tvet_student_enrolment.student_id', 'left');
        $this->db->join('tvet_level', 'tvet_level.id = tvet_student_enrolment.level_id');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        $this->db->join('tvet_cohort', 'tvet_cohort.id = tvet_student_enrolment.cohort_id', 'left');
        $this->db->where('tvet_student_enrolment.id', $id);
        return $this->db->get()->row_array();
    }

    public function getByStudent($student_id)
    {
        $this->db->select('tvet_student_enrolment.*, tvet_programme.name as programme_name, tvet_qualification.name as qualification_name, tvet_level.name as level_name, tvet_cohort.name as cohort_name');
        $this->db->from('tvet_student_enrolment');
        $this->db->join('tvet_level', 'tvet_level.id = tvet_student_enrolment.level_id');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->join('tvet_programme', 'tvet_programme.id = tvet_qualification.programme_id');
        $this->db->join('tvet_cohort', 'tvet_cohort.id = tvet_student_enrolment.cohort_id', 'left');
        $this->db->where('tvet_student_enrolment.student_id', $student_id);
        $this->db->order_by('tvet_student_enrolment.enrolment_date', 'DESC');
        return $this->db->get()->result_array();
    }

    public function getCohortRoster($cohort_id)
    {
        $this->db->select('tvet_student_enrolment.id as enrolment_id, tvet_student_enrolment.student_id, tvet_student_enrolment.student_number, tvet_student_enrolment.enrolment_date, tvet_student_enrolment.status, students.firstname, students.lastname, students.admission_no');
        $this->db->from('tvet_student_enrolment');
        $this->db->join('students', 'students.id = tvet_student_enrolment.student_id', 'left');
        $this->db->where('tvet_student_enrolment.cohort_id', $cohort_id);
        $this->db->order_by('students.lastname, students.firstname', 'ASC');
        return $this->db->get()->result_array();
    }

    public function add($data)
    {
        $this->db->insert('tvet_student_enrolment', [
            'student_id'      => $data['student_id'],
            'level_id'        => $data['level_id'],
            'cohort_id'       => isset($data['cohort_id']) ? $data['cohort_id'] : null,
            'enrolment_date'  => $data['enrolment_date'],
            'status'          => isset($data['status']) ? $data['status'] : 'Active',
            'completion_date' => isset($data['completion_date']) ? $data['completion_date'] : null,
            'student_number'  => isset($data['student_number']) ? $data['student_number'] : null,
            'notes'           => isset($data['notes']) ? $data['notes'] : null
        ]);
        return $this->db->insert_id();
    }

    public function update($id, $data)
    {
        $this->db->where('id', $id);
        return $this->db->update('tvet_student_enrolment', $data);
    }

    public function delete($id)
    {
        $this->db->where('id', $id);
        return $this->db->delete('tvet_student_enrolment');
    }

    public function getActiveCount($cohort_id)
    {
        $this->db->where('cohort_id', $cohort_id);
        $this->db->where('status', 'Active');
        return $this->db->count_all_results('tvet_student_enrolment');
    }
}
