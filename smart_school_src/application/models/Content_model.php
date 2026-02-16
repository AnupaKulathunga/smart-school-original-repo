<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Content_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
    }

    /**
     * This funtion takes id as a parameter and will fetch the record.
     * If id is not provided, then it will fetch all the records form the table.
     * @param int $id
     * @return mixed
     *
     * TVET Migration: Updated to use academic_class instead of class_sections
     */
    public function get($id = null)
    {
        // TVET: Join to academic_class and related tables instead of class_sections
        $this->db->select('contents.*,
            ac.class_code as class_name,
            CONCAT(subj.name, " - ", lvl.name, " - ", ac.cohort_name) as class_display_name,
            subj.name as subject_name,
            lvl.name as level_name,
            (SELECT GROUP_CONCAT(role) FROM content_for WHERE content_id=contents.id) as role', FALSE)
            ->from('contents');
        $this->db->join('academic_class ac', 'contents.class_id = ac.id', 'left');
        $this->db->join('academic_subject_level sl', 'sl.id = ac.subject_level_id', 'left');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id', 'left');
        $this->db->join('academic_level lvl', 'lvl.id = sl.level_id', 'left');

        if ($id != null) {
            $this->db->where('contents.id', $id);
        }
        $this->db->order_by('contents.id', "desc");
        $this->db->limit(10);
        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
        }
    }

    /**
     * Get content by role and user ID
     *
     * TVET Migration: Updated to use academic_class instead of class_sections
     */
    public function getContentByRole($id = null, $role = null)
    {
        $inner_sql = "";

        if ($role == "student") {
            $inner_sql = " WHERE (role='student' and created_by='" . $id . "' ) or (created_by=0 and role='" . $role . "')";
        } elseif ($role == "Teacher") {
            $inner_sql = " WHERE (role='Teacher' and created_by='" . $id . "' ) or (created_by=0 and role='" . $role . "')";
        }

        // TVET: Updated to join academic_class and related tables
        $query = "SELECT contents.*,
            (SELECT GROUP_CONCAT(role) FROM content_for WHERE content_id=contents.id) as role,
            ac.id as academic_class_id,
            ac.class_code as class_name,
            CONCAT(subj.name, ' - ', lvl.name, ' - ', ac.cohort_name) as class_display_name,
            subj.name as subject_name,
            lvl.name as level_name
            FROM `content_for`
            INNER JOIN contents on contents.id=content_for.content_id
            LEFT JOIN academic_class ac on ac.id=contents.class_id
            LEFT JOIN academic_subject_level sl on sl.id=ac.subject_level_id
            LEFT JOIN academic_subject subj on subj.id=sl.subject_id
            LEFT JOIN academic_level lvl on lvl.id=sl.level_id" . $inner_sql . "
            GROUP by contents.id";

        $query = $this->db->query($query);
        return $query->result_array();
    }

    /**
     * Get list of content by category
     *
     * TVET Migration: Updated to use academic_class instead of class_sections
     */
    public function getListByCategory($category)
    {
        // TVET: Updated to join academic_class and related tables
        $this->db->select('contents.*,
            ac.class_code as class_name,
            CONCAT(subj.name, " - ", lvl.name, " - ", ac.cohort_name) as class_display_name,
            subj.name as subject_name,
            lvl.name as level_name', FALSE)
            ->from('contents');
        $this->db->join('academic_class ac', 'contents.class_id = ac.id', 'left');
        $this->db->join('academic_subject_level sl', 'sl.id = ac.subject_level_id', 'left');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id', 'left');
        $this->db->join('academic_level lvl', 'lvl.id = sl.level_id', 'left');
        $this->db->where('contents.type', $category);
        $this->db->order_by('contents.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    /**
     * Get list of content by category for user (student)
     *
     * TVET Migration: Changed from class_id+section_id to academic_class_id
     * Now uses student enrolment to determine accessible content
     * @param int $student_id - Student ID
     * @param string $category - Content category/type
     */
    public function getListByCategoryforUser($student_id, $category = '')
    {
        if (empty($student_id)) {
            $student_id = "0";
        }

        // TVET: Updated to use academic_class_enrolment for class-based access
        $query = "SELECT contents.*,
            ac.id as academic_class_id,
            ac.class_code as class_name,
            CONCAT(subj.name, ' - ', lvl.name, ' - ', ac.cohort_name) as class_display_name,
            subj.name as subject_name,
            lvl.name as level_name
            FROM `content_for`
            INNER JOIN contents on content_for.content_id=contents.id
            LEFT JOIN academic_class ac on ac.id=contents.class_id
            LEFT JOIN academic_subject_level sl on sl.id=ac.subject_level_id
            LEFT JOIN academic_subject subj on subj.id=sl.subject_id
            LEFT JOIN academic_level lvl on lvl.id=sl.level_id
            WHERE role='student'
            AND contents.type='" . $this->db->escape_str($category) . "'
            AND (
                contents.is_public='yes'
                OR contents.class_id IN (
                    SELECT ace.class_id
                    FROM academic_class_enrolment ace
                    JOIN student_session ss ON ss.id = ace.student_session_id
                    WHERE ss.student_id=" . intval($student_id) . "
                    AND ss.session_id=" . intval($this->current_session) . "
                )
            )";
        $query = $this->db->query($query);
        if ($query === false) {
            return array();
        }
        return $query->result_array();
    }

    /**
     * Get all content list for user (student) - all categories
     *
     * TVET Migration: Changed from class_id+section_id to academic_class_id
     * Now uses student enrolment to determine accessible content
     * @param int $student_id - Student ID
     */
    public function getListByforUser($student_id)
    {
        if (empty($student_id)) {
            $student_id = "0";
        }

        // TVET: Updated to use academic_class_enrolment for class-based access
        $query = "SELECT contents.*,
            ac.id as academic_class_id,
            ac.class_code as class_name,
            CONCAT(subj.name, ' - ', lvl.name, ' - ', ac.cohort_name) as class_display_name,
            subj.name as subject_name,
            lvl.name as level_name
            FROM `content_for`
            INNER JOIN contents on content_for.content_id=contents.id
            LEFT JOIN academic_class ac on ac.id=contents.class_id
            LEFT JOIN academic_subject_level sl on sl.id=ac.subject_level_id
            LEFT JOIN academic_subject subj on subj.id=sl.subject_id
            LEFT JOIN academic_level lvl on lvl.id=sl.level_id
            WHERE role='student'
            AND (
                contents.is_public='yes'
                OR contents.class_id IN (
                    SELECT ace.class_id
                    FROM academic_class_enrolment ace
                    JOIN student_session ss ON ss.id = ace.student_session_id
                    WHERE ss.student_id=" . intval($student_id) . "
                    AND ss.session_id=" . intval($this->current_session) . "
                )
            )";
        $query = $this->db->query($query);
        if ($query === false) {
            return array();
        }
        return $query->result_array();
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
        $this->db->delete('contents');
        $message   = DELETE_RECORD_CONSTANT . " On contents id " . $id;
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

    public function search_by_content_type($text)
    {
        $this->db->select()->from('contents');
        $this->db->or_like('contents.content_type', $text);
        $query = $this->db->get();
        return $query->result_array();
    }

    /**
     * This function will take the post data passed from the controller
     * If id is present, then it will do an update
     * else an insert. One function doing both add and edit.
     * @param $data
     *
     * TVET Migration: Data should now contain academic_class_id instead of cls_sec_id
     */
    public function add($data, $content_role = array())
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('contents', $data);
            $message   = UPDATE_RECORD_CONSTANT . " On  contents id " . $data['id'];
            $action    = "Update";
            $record_id = $insert_id = $data['id'];
            $this->log($message, $record_id, $action);
        } else {
            $this->db->insert('contents', $data);
            $insert_id = $this->db->insert_id();
            if (isset($content_role) && !empty($content_role)) {
                $total_rec = count($content_role);
                for ($i = 0; $i < $total_rec; $i++) {
                    $content_role[$i]['content_id'] = $insert_id;
                }
                $this->db->insert_batch('content_for', $content_role);
            }
            $message   = INSERT_RECORD_CONSTANT . " On contents id " . $insert_id;
            $action    = "Insert";
            $record_id = $insert_id;
            $this->log($message, $record_id, $action);
        }
        //======================Code End==============================

        $this->db->trans_complete(); # Completing transaction
        /* Optional */

        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            return $insert_id;
        }

    }

}
