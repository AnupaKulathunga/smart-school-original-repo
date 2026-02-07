<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Feediscount_model extends MY_Model
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
     */
    public function get($id = null, $order = "desc")
    {
        $this->db->select()->from('fees_discounts');
        if ($id != null) {
            $this->db->where('id', $id);
        } else {
            $this->db->order_by('id ' . $order);
        }
        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
        }
    }

    public function getbyasc($id = null)
    {
        $this->db->select()->from('fees_discounts');
        if ($id != null) {
            $this->db->where('id', $id);
        } else {
            $this->db->order_by('id');
        }
        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
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
        $this->db->delete('fees_discounts');
        $message   = DELETE_RECORD_CONSTANT . " On  fees discounts id " . $id;
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
            $this->db->update('fees_discounts', $data);
            $message   = UPDATE_RECORD_CONSTANT . " On  fees discounts id " . $data['id'];
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
            $data['session_id'] = $this->current_session;
            $this->db->insert('fees_discounts', $data);
            $id        = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On  fees discounts id " . $id;
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
                //return $return_value;
            }
            return $id;
        }
    }

    public function updateStudentDiscount($data)
    {
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('student_fees_discounts', $data);
        }
    }

    public function allotdiscount($data)
    {
        $this->db->where('student_session_id', $data['student_session_id']);
        $this->db->where('fees_discount_id', $data['fees_discount_id']);
        $q = $this->db->get('student_fees_discounts');
        if ($q->num_rows() > 0) {
            return $q->row()->id;
        } else {
            $this->db->insert('student_fees_discounts', $data);
            return $this->db->insert_id();
        }
    }

    public function searchAssignFeeByClassSection($class_id = null, $section_id = null, $fees_discount_id = null, $category = null, $gender = null, $rte = null)
    {
        $sql = "SELECT IFNULL(`student_fees_discounts`.`id`, '0') as `student_fees_discount_id`,"
        . " `e`.`class_id` AS `class_id`, `e`.`id` as `student_session_id`,"
        . " `students`.`id`, `ac`.`class_code` as `class`,"
        . " `students`.`id`, `students`.`admission_no`,"
        . " `students`.`roll_no`, `students`.`admission_date`, `students`.`firstname`,"
        . " `students`.`lastname`,`students`.`middlename`, `students`.`image`, `students`.`mobileno`,"
        . " `students`.`email`, `students`.`state`, `students`.`city`, `students`.`pincode`,"
        . " `students`.`religion`, `students`.`dob`, `students`.`current_address`,"
        . " `students`.`permanent_address`, IFNULL(students.category_id, 0) as `category_id`,"
        . " IFNULL(categories.category, '') as `category`, `students`.`adhar_no`,"
        . " `students`.`samagra_id`, `students`.`bank_account_no`, `students`.`bank_name`,"
        . " `students`.`ifsc_code`, `students`.`guardian_name`, `students`.`guardian_relation`,"
        . " `students`.`guardian_phone`, `students`.`guardian_address`, `students`.`is_active`,"
        . " `students`.`created_at`, `students`.`updated_at`, `students`.`father_name`,"
        . " `students`.`rte`, `students`.`gender` FROM `students`"
        . " JOIN `academic_class_enrolment` `e` ON `e`.`student_id` = `students`.`id`"
        . " JOIN `academic_class` `ac` ON `ac`.`id` = `e`.`class_id`"
        . " LEFT JOIN `categories` ON `students`.`category_id` = `categories`.`id`"
        . " LEFT JOIN student_fees_discounts on student_fees_discounts.student_session_id=e.id"
        . " AND student_fees_discounts.fees_discount_id=" . $this->db->escape($fees_discount_id)
        . " WHERE `ac`.`session_id` = " . $this->current_session
        . " AND `e`.`status` = 'Active'";

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
        $sql .= " AND students.is_active='yes'";
        $sql .= " ORDER BY `students`.`id`";

        $query = $this->db->query($sql);
        return $query->result_array();
    }

    public function deletedisstd($fees_discount_id, $array)
    {
        $this->db->where('fees_discount_id', $fees_discount_id);
        $this->db->where_in('student_session_id', $array);
        $this->db->delete('student_fees_discounts');
    }

    public function delete_assigned_discount($student_id){
        $this->db->where_in('student_session_id', $student_id);
        $this->db->delete('student_fees_discounts');
    }

    public function getStudentFeesDiscount($student_session_id = null)
    {
        $this->db->select('student_fees_discounts.id ,student_fees_discounts.student_session_id,student_fees_discounts.status,student_fees_discounts.payment_id,student_fees_discounts.description as `student_fees_discount_description`, student_fees_discounts.fees_discount_id, fees_discounts.name,fees_discounts.code,fees_discounts.amount,fees_discounts.description,fees_discounts.session_id,fees_discounts.type,fees_discounts.percentage')->from('student_fees_discounts');
        $this->db->join('fees_discounts', 'fees_discounts.id = student_fees_discounts.fees_discount_id');
        $this->db->where('student_fees_discounts.student_session_id', $student_session_id);
        $this->db->order_by('student_fees_discounts.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getDiscountNotApplied($student_session_id = null)
    {
        $query = "SELECT * FROM (SELECT student_fees_discounts.*, fees_discounts.name, fees_discounts.code, fees_discounts.type, fees_discounts.percentage, fees_discounts.amount, fees_discounts.discount_limit, IFNULL(applied_fees.total_assigned, 0) AS total_assigned, fees_discounts.discount_limit - IFNULL(applied_fees.total_assigned, 0) AS remaining_discount_limit, fees_discounts.expire_date FROM `student_fees_discounts` INNER JOIN fees_discounts ON fees_discounts.id = student_fees_discounts.fees_discount_id LEFT JOIN (SELECT COUNT(*) AS total_assigned, student_fees_discount_id FROM `student_applied_discounts` GROUP BY student_fees_discount_id) AS applied_fees ON applied_fees.student_fees_discount_id = student_fees_discounts.id WHERE student_fees_discounts.student_session_id = $student_session_id and (fees_discounts.expire_date >=CURDATE() or fees_discounts.expire_date is NULL) ) AS subquery WHERE remaining_discount_limit > 0;";

        $query = $this->db->query($query);
        return $query->result();
    }

    // =====================================================
    // TVET Methods - Use enrolment_id instead of student_session_id
    // =====================================================

    /**
     * TVET: Search students for fee discount assignment by class
     * Replaces searchAssignFeeByClassSection() - no section_id needed
     */
    public function searchAssignFeeByClassTVET($class_id = null, $fees_discount_id = null, $category = null, $gender = null, $rte = null)
    {
        $this->db->select('IFNULL(student_fees_discounts.id, 0) as student_fees_discount_id,
            class.id AS class_id,
            enrolment.id as enrolment_id,
            students.id,
            class.class_code,
            class.cohort_name,
            subject.name as subject_name,
            level.code as level_code,
            students.admission_no,
            students.roll_no,
            students.admission_date,
            students.firstname,
            students.lastname,
            students.middlename,
            students.image,
            students.mobileno,
            students.email,
            students.state,
            students.city,
            students.pincode,
            students.religion,
            students.dob,
            students.current_address,
            students.permanent_address,
            IFNULL(students.category_id, 0) as category_id,
            IFNULL(categories.category, "") as category,
            students.adhar_no,
            students.samagra_id,
            students.bank_account_no,
            students.bank_name,
            students.ifsc_code,
            students.guardian_name,
            students.guardian_relation,
            students.guardian_phone,
            students.guardian_address,
            students.is_active,
            students.created_at,
            students.updated_at,
            students.father_name,
            students.rte,
            students.gender', FALSE)
            ->from('academic_class_enrolment enrolment')
            ->join('students', 'students.id = enrolment.student_id')
            ->join('academic_class class', 'class.id = enrolment.class_id')
            ->join('academic_subject_level subject_level', 'subject_level.id = class.subject_level_id')
            ->join('academic_subject subject', 'subject.id = subject_level.subject_id')
            ->join('academic_level level', 'level.id = subject_level.level_id')
            ->join('categories', 'students.category_id = categories.id', 'left')
            ->join('student_fees_discounts', 'student_fees_discounts.enrolment_id = enrolment.id AND student_fees_discounts.fees_discount_id = ' . $this->db->escape($fees_discount_id), 'left')
            ->where('enrolment.session_id', $this->current_session)
            ->where('students.is_active', 'yes');

        if ($class_id != null) {
            $this->db->where('enrolment.class_id', $class_id);
        }
        if ($category != null) {
            $this->db->where('students.category_id', $category);
        }
        if ($gender != null) {
            $this->db->where('students.gender', $gender);
        }
        if ($rte != null) {
            $this->db->where('students.rte', $rte);
        }

        $this->db->order_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    /**
     * TVET: Allot discount using enrolment_id
     */
    public function allotDiscountTVET($data)
    {
        $this->db->where('enrolment_id', $data['enrolment_id']);
        $this->db->where('fees_discount_id', $data['fees_discount_id']);
        $q = $this->db->get('student_fees_discounts');
        if ($q->num_rows() > 0) {
            return $q->row()->id;
        } else {
            $this->db->insert('student_fees_discounts', $data);
            return $this->db->insert_id();
        }
    }

    /**
     * TVET: Delete discount by enrolment IDs
     */
    public function deleteDiscountByEnrolmentTVET($fees_discount_id, $enrolment_ids)
    {
        $this->db->where('fees_discount_id', $fees_discount_id);
        $this->db->where_in('enrolment_id', $enrolment_ids);
        $this->db->delete('student_fees_discounts');
    }

    /**
     * TVET: Get student fees discount by enrolment
     */
    public function getStudentFeesDiscountTVET($enrolment_id = null)
    {
        $this->db->select('student_fees_discounts.id,
            student_fees_discounts.enrolment_id,
            student_fees_discounts.status,
            student_fees_discounts.payment_id,
            student_fees_discounts.description as student_fees_discount_description,
            student_fees_discounts.fees_discount_id,
            fees_discounts.name,
            fees_discounts.code,
            fees_discounts.amount,
            fees_discounts.description,
            fees_discounts.session_id,
            fees_discounts.type,
            fees_discounts.percentage', FALSE)
            ->from('student_fees_discounts')
            ->join('fees_discounts', 'fees_discounts.id = student_fees_discounts.fees_discount_id')
            ->where('student_fees_discounts.enrolment_id', $enrolment_id)
            ->order_by('student_fees_discounts.id');

        $query = $this->db->get();
        return $query->result_array();
    }

    /**
     * TVET: Get discount not applied by enrolment
     */
    public function getDiscountNotAppliedTVET($enrolment_id = null)
    {
        $query = "SELECT * FROM (
            SELECT student_fees_discounts.*,
                fees_discounts.name,
                fees_discounts.code,
                fees_discounts.type,
                fees_discounts.percentage,
                fees_discounts.amount,
                fees_discounts.discount_limit,
                IFNULL(applied_fees.total_assigned, 0) AS total_assigned,
                fees_discounts.discount_limit - IFNULL(applied_fees.total_assigned, 0) AS remaining_discount_limit,
                fees_discounts.expire_date
            FROM student_fees_discounts
            INNER JOIN fees_discounts ON fees_discounts.id = student_fees_discounts.fees_discount_id
            LEFT JOIN (
                SELECT COUNT(*) AS total_assigned, student_fees_discount_id
                FROM student_applied_discounts
                GROUP BY student_fees_discount_id
            ) AS applied_fees ON applied_fees.student_fees_discount_id = student_fees_discounts.id
            WHERE student_fees_discounts.enrolment_id = " . $this->db->escape($enrolment_id) . "
                AND (fees_discounts.expire_date >= CURDATE() OR fees_discounts.expire_date IS NULL)
        ) AS subquery
        WHERE remaining_discount_limit > 0";

        $query = $this->db->query($query);
        return $query->result();
    }

}
