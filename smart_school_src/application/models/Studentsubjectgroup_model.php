<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Studentsubjectgroup_model extends CI_Model {

    public function __construct() {
        parent::__construct();
        $this->load->config('ci-blog');

        $this->current_session = $this->setting_model->getCurrentSession();
    }

    public function searchAssignGroupByClassSection($class_id = null, $section_id = null, $subject_group_id = null, $category = null, $gender = null, $rte = null) {
        $sql = "SELECT IFNULL(`student_subject_groups`.`id`, '0') as `student_subject_group_id`,"
                . " `e`.`class_id` AS `class_id`,"
                . " `e`.`id` as `student_session_id`, `students`.`id`, "
                . "`ac`.`class_code` as `class`, "
                . "`students`.`id`, `students`.`admission_no`, `students`.`roll_no`,"
                . " `students`.`admission_date`, `students`.`firstname`, `students`.`middlename`,`students`.`lastname`,"
                . " `students`.`image`, `students`.`mobileno`, `students`.`email`, `students`.`state`,"
                . " `students`.`city`, `students`.`pincode`, `students`.`religion`, `students`.`dob`, "
                . "`students`.`current_address`, `students`.`permanent_address`,"
                . " IFNULL(students.category_id, 0) as `category_id`,"
                . " IFNULL(categories.category, '') as `category`,"
                . " `students`.`adhar_no`, `students`.`samagra_id`,"
                . " `students`.`bank_account_no`, `students`.`bank_name`, `students`.`ifsc_code`,"
                . " `students`.`guardian_name`, `students`.`guardian_relation`, `students`.`guardian_phone`,"
                . " `students`.`guardian_address`, `students`.`is_active`, `students`.`created_at`,"
                . " `students`.`updated_at`, `students`.`father_name`, `students`.`rte`,"
                . " `students`.`gender` FROM `students`"
                . " JOIN `academic_class_enrolment` `e` ON `e`.`student_id` = `students`.`id`"
                . " JOIN `academic_class` `ac` ON `ac`.`id` = `e`.`class_id`"
                . " LEFT JOIN `categories` ON `students`.`category_id` = `categories`.`id`"
                . " LEFT JOIN student_subject_groups on"
                . " student_subject_groups.student_session_id=e.id"
                . " AND student_subject_groups.subject_group_id=" . $this->db->escape($subject_group_id)
                . " WHERE `ac`.`session_id` = " . $this->current_session
                . " AND `e`.`status` = 'Active'"
                . " AND `students`.`is_active` = 'yes'";

        if ($class_id != null) {
            $sql .= " AND `e`.`class_id` = " . $this->db->escape($class_id);
        }
        if ($category != null) {
            $sql .= " AND `students`.`category_id` =" . $this->db->escape($category);
        }
        if ($gender != null) {
            $sql .= " AND `students`.`gender` =" . $this->db->escape($gender);
        }
        if ($rte != null) {
            $sql .= " AND `students`.`rte` =" . $this->db->escape($rte);
        }
        $sql .= " ORDER BY `students`.`id`";

        $query = $this->db->query($sql);
        return $query->result_array();
    }

    public function add($data) {

        $this->db->where('student_session_id', $data['student_session_id']);
        $this->db->where('subject_group_id', $data['subject_group_id']);
        $q = $this->db->get('student_subject_groups');

        if ($q->num_rows() > 0) {
            return $q->row()->id;
        } else {
            $this->db->insert('student_subject_groups', $data);
            return $this->db->insert_id();
        }
    }

    public function delete($fee_session_groups, $array) {

        $this->db->where('subject_group_id', $fee_session_groups);
        $this->db->where_in('student_session_id', $array);
        $this->db->delete('student_subject_groups');
    }

}
