<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Student_accommodation_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * This funtion takes id as a parameter and will fetch the record.
     * If id is not provided, then it will fetch all the records form the table.
     * @param int $id
     * @return mixed
     */
    public function get($id = null)
    {
        $this->db->select()->from('student_accommodations');
        if ($id != null) {
            $this->db->where('student_accommodations.id', $id);
        } else {
            $this->db->order_by('student_accommodations.id');
        }
        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
        }
    }

    /**
     * Get all accommodations with student info joined
     * @return mixed
     */
    public function getAllWithStudentInfo()
    {
        $this->db->select('student_accommodations.*, students.firstname, students.lastname, students.admission_no, classes.class, sections.section');
        $this->db->from('student_accommodations');
        $this->db->join('student_session', 'student_session.id = student_accommodations.student_session_id', 'left');
        $this->db->join('students', 'students.id = student_session.student_id', 'left');
        $this->db->join('classes', 'classes.id = student_session.class_id', 'left');
        $this->db->join('sections', 'sections.id = student_session.section_id', 'left');
        $this->db->order_by('student_accommodations.id', 'desc');
        $query = $this->db->get();
        return $query->result_array();
    }

    /**
     * This function returns active accommodations for a student session
     * @param int $student_session_id
     * @return mixed
     */
    public function getByStudentSession($student_session_id)
    {
        $this->db->select()->from('student_accommodations');
        $this->db->where('student_session_id', $student_session_id);
        $this->db->where('is_active', 1);
        $this->db->order_by('id');
        $query = $this->db->get();
        return $query->result_array();
    }

    /**
     * This function returns extra_time_percent for an active accommodation
     * @param int $student_session_id
     * @return int
     */
    public function getActiveExtraTime($student_session_id)
    {
        $this->db->select('extra_time_percent');
        $this->db->from('student_accommodations');
        $this->db->where('student_session_id', $student_session_id);
        $this->db->where('is_active', 1);
        $this->db->limit(1);
        $query = $this->db->get();
        $row = $query->row_array();
        if ($row) {
            return $row['extra_time_percent'];
        }
        return 0;
    }

    /**
     * This function will take the post data passed from the controller
     * If id is present, then it will do an update
     * else an insert. One function doing both add and edit.
     * @param $data
     */
    public function add($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('student_accommodations', $data);
            $message   = UPDATE_RECORD_CONSTANT . " On student_accommodations id " . $data['id'];
            $action    = "Update";
            $record_id = $data['id'];
            $this->log($message, $record_id, $action);
            //======================Code End==============================

            $this->db->trans_complete(); # Completing transaction
            /* Optional */

            if ($this->db->trans_status() === false) {
                # Something went wrong.
                $this->db->trans_rollback();
                return false;
            } else {
                //return $return_value;
            }
        } else {
            $this->db->insert('student_accommodations', $data);
            $insert_id = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On student_accommodations id " . $insert_id;
            $action    = "Insert";
            $record_id = $insert_id;
            $this->log($message, $record_id, $action);
            //======================Code End==============================

            $this->db->trans_complete(); # Completing transaction
            /* Optional */

            if ($this->db->trans_status() === false) {
                # Something went wrong.
                $this->db->trans_rollback();
                return false;
            } else {
                //return $return_value;
            }
            return $insert_id;
        }
    }

    /**
     * This function will delete the record based on the id
     * @param $id
     */
    public function remove($id)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->where('id', $id);
        $this->db->delete('student_accommodations');
        $message   = DELETE_RECORD_CONSTANT . " On student_accommodations id " . $id;
        $action    = "Delete";
        $record_id = $id;
        $this->log($message, $record_id, $action);
        //======================Code End==============================
        $this->db->trans_complete(); # Completing transaction
        /* Optional */
        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            //return $return_value;
        }
    }

}
