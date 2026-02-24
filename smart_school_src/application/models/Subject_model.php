<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Subject_model extends MY_Model {

    public function __construct() {
        parent::__construct();
    }

        public function get($id = null) {
        if ($id != null) {
            $this->db->select('id, name, code')->from('academic_subject');
            $this->db->where('id', $id);
            $this->db->order_by('id');
            $query = $this->db->get();
            return $query->row_array();
        } else {
            $this->db->select('id, name, code')->from('academic_subject');
            $this->db->order_by('name');
            $query = $this->db->get();
            return $query->result_array();
        }
    }

    public function remove($id) {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->where('id', $id);
        $this->db->delete('academic_subject');
        $message = DELETE_RECORD_CONSTANT . " On academic_subject id " . $id;
        $action = "Delete";
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

    public function add($data) {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('academic_subject', $data);
            $message = UPDATE_RECORD_CONSTANT . " On academic_subject id " . $data['id'];
            $action = "Update";
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
            $this->db->insert('academic_subject', $data);
            $id = $this->db->insert_id();
            $message = INSERT_RECORD_CONSTANT . " On academic_subject id " . $id;
            $action = "Insert";
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
            return $id;
        }
    }

    function check_data_exists($data) {
        $this->db->where('name', $data['name']);
        $query = $this->db->get('academic_subject');
        if ($query->num_rows() > 0) {
            return TRUE;
        } else {
            return FALSE;
        }
    }

    function check_code_exists($data) {
        $this->db->where('code', $data['code']);
        $query = $this->db->get('academic_subject');
        if ($query->num_rows() > 0) {
            return TRUE;
        } else {
            return FALSE;
        }
    }

}
