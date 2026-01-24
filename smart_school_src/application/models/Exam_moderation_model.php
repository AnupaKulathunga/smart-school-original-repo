<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Exam_moderation_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * This function fetches all moderation comments for a given exam,
     * joined with the staff table to include the moderator name.
     * @param int $exam_id
     * @return mixed
     */
    public function getCommentsByExam($exam_id)
    {
        $this->db->select('exam_moderation_comments.*, staff.name as moderator_name, staff.surname as moderator_surname');
        $this->db->from('exam_moderation_comments');
        $this->db->join('staff', 'staff.id = exam_moderation_comments.moderator_staff_id');
        $this->db->where('exam_moderation_comments.exam_id', $exam_id);
        $this->db->order_by('exam_moderation_comments.created_at', 'desc');
        $query = $this->db->get();
        return $query->result();
    }

    /**
     * This function inserts a new moderation comment record.
     * @param array $data
     * @return mixed
     */
    public function addComment($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->insert('exam_moderation_comments', $data);
        $id        = $this->db->insert_id();
        $message   = INSERT_RECORD_CONSTANT . " On exam_moderation_comments id " . $id;
        $action    = "Insert";
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
            return $id;
        }
    }

    /**
     * This function updates the moderation_status column in the onlineexam table.
     * @param int $exam_id
     * @param string $status
     * @return bool
     */
    public function updateExamStatus($exam_id, $status)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->where('id', $exam_id);
        $this->db->update('onlineexam', array('moderation_status' => $status));
        $message   = UPDATE_RECORD_CONSTANT . " On onlineexam id " . $exam_id;
        $action    = "Update";
        $record_id = $exam_id;
        $this->log($message, $record_id, $action);
        //======================Code End==============================
        $this->db->trans_complete(); # Completing transaction
        /* Optional */
        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            return true;
        }
    }

    /**
     * This function returns exams with a specific moderation status.
     * @param string $status
     * @return mixed
     */
    public function getExamsByStatus($status)
    {
        $this->db->select('onlineexam.*');
        $this->db->from('onlineexam');
        $this->db->where('onlineexam.moderation_status', $status);
        $this->db->order_by('onlineexam.id', 'desc');
        $query = $this->db->get();
        return $query->result();
    }

    /**
     * This function returns exams with status 'pending_moderation'.
     * @return mixed
     */
    public function getPendingExams()
    {
        return $this->getExamsByStatus('pending_moderation');
    }

}
