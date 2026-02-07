<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Conference_model - TVET Converted
 *
 * Legacy model that previously used classes + sections + class_sections + conference_sections tables.
 * Now converted to use academic_class + conference_classes tables for TVET mode.
 *
 * Table mapping:
 *   conference_sections (cls_section_id) -> conference_classes (class_id = academic_class.id)
 *   class_sections + classes + sections  -> academic_class
 *   conferences.class_id + section_id    -> conferences.class_id (now stores academic_class.id)
 */
class Conference_model extends MY_Model {

    protected $table = "conferences";

    public function __construct() {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
    }

    /**
     * Add a conference with associated academic classes
     * Legacy: inserted into conference_sections with cls_section_id
     * TVET: inserts into conference_classes with class_id (academic_class.id)
     *
     * @param array $data  Conference data
     * @param array $classes  Array of academic_class IDs
     */
    public function add($data, $classes)
    {
        $this->db->trans_start();
        $this->db->trans_strict(false);
        $data['session_id'] = $this->current_session;
        $this->db->insert($this->table, $data);
        $inserted_id = $this->db->insert_id();
        if (!empty($classes)) {
            $insert_classes = array();
            foreach ($classes as $class_value) {
                $insert_classes[] = array('conference_id' => $inserted_id, 'class_id' => $class_value);
            }
            $this->db->insert_batch('conference_classes', $insert_classes);
        }
        $message = INSERT_RECORD_CONSTANT . " On " . $this->table . " id " . $inserted_id;
        $action = "Insert";
        $record_id = $inserted_id;
        $this->log($message, $record_id, $action);

        $this->db->trans_complete();
        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            return true;
        }
    }

    public function addmeeting($data, $staff) {
        $this->db->trans_start();
        $this->db->trans_strict(false);
        $this->db->insert('conferences', $data);
        $insert_id = $this->db->insert_id();
        if (!empty($staff)) {
            $staff_list = array();
            foreach ($staff as $staff_key => $staff_value) {
                $staff_list[] = array('conference_id' => $insert_id, 'staff_id' => $staff_value);
            }
            $this->db->insert_batch('conference_staff', $staff_list);
        }

        $message = INSERT_RECORD_CONSTANT . " On conferences id " . $insert_id;
        $action = "Insert";
        $record_id = $insert_id;
        $this->log($message, $record_id, $action);

        $this->db->trans_complete();
        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            return true;
        }
    }

    /**
     * Get conference(s) by ID or all
     * Legacy: joined classes + sections
     * TVET: joins academic_class
     */
    public function get($id = null) {
        $this->db->select('conferences.*, for_create.name as `create_for_name`, for_create.surname as `create_for_surname`, for_create.employee_id as for_create_empid, create_by.name as `create_by_name`, create_by.surname as `create_by_surname`, create_by.employee_id as create_by_empid, c.class_code, c.cohort_name as class', FALSE);
        $this->db->from('conferences');
        $this->db->join('staff as for_create', 'for_create.id = conferences.staff_id', 'left');
        $this->db->join('staff as create_by', 'create_by.id = conferences.created_id');
        $this->db->join('academic_class c', 'c.id = conferences.class_id', 'left');
        if ($id != null) {
            $this->db->where('conferences.id', $id);
        } else {
            $this->db->order_by('conferences.id');
        }
        $query = $this->db->get();
        if ($id != null) {
            return $query->row();
        } else {
            return $query->result();
        }
    }

    /**
     * Get conferences by staff
     * No class/section JOINs needed here (only staff-related)
     */
    public function getByStaff($staff_id = null) {
        $this->db->select('conferences.*, for_create.name as `create_for_name`, for_create.surname as `create_for_surname`, create_by.name as `create_by_name`, create_by.surname as `create_by_surname`, for_create.employee_id as `for_create_employee_id`, for_create_role.name as `for_create_role_name`, create_by_role.name as `create_by_role_name`, create_by.employee_id as `create_by_employee_id`, staff_create_by_roles.role_id', FALSE);
        $this->db->from('conferences');
        $this->db->join('staff as for_create', 'for_create.id = conferences.staff_id');
        $this->db->join('staff as create_by', 'create_by.id = conferences.created_id');
        $this->db->join('staff_roles', 'staff_roles.staff_id = for_create.id');
        $this->db->join('roles as `for_create_role`', 'for_create_role.id = staff_roles.role_id');
        $this->db->join('staff_roles as staff_create_by_roles', 'staff_create_by_roles.staff_id = create_by.id');
        $this->db->join('roles as `create_by_role`', 'create_by_role.id = staff_create_by_roles.role_id');
        $this->db->where('conferences.session_id', $this->current_session);
        if ($staff_id != "") {
            $this->db->where('conferences.staff_id', $staff_id);
        }

        $this->db->order_by('DATE(`conferences`.`date`)', 'DESC');
        $this->db->order_by('conferences.date', 'DESC');
        $query = $this->db->get();
        if ($query->num_rows() > 0) {
            $result = $query->result();
            foreach ($result as $result_key => $result_value) {
                $result_value->{'classes'} = $this->getClassesByConferenceID($result_value->id);
            }
            return $result;
        }
        return $query->result();
    }

    /**
     * Get academic classes associated with a conference
     * Legacy: joined conference_sections + class_sections + classes + sections
     * TVET: joins conference_classes + academic_class
     *
     * @param int $conference_id
     * @return array
     */
    public function getClassesByConferenceID($conference_id)
    {
        $this->db->select('cc.*, c.class_code, c.cohort_name as class', FALSE);
        $this->db->from('conference_classes cc');
        $this->db->join('academic_class c', 'c.id = cc.class_id');
        $this->db->where('cc.conference_id', $conference_id);
        $this->db->order_by('cc.id');
        $query = $this->db->get();
        return $query->result();
    }

    /**
     * Legacy alias - redirects to getClassesByConferenceID
     * Kept for backward compatibility with any remaining callers
     */
    public function getClassSectionByConferenceID($conference_id)
    {
        return $this->getClassesByConferenceID($conference_id);
    }

    public function getStaffMeeting($staff_id = null, $type = 'meeting') {

        if ($staff_id != "") {
            $sql = "SELECT `conferences`.*, `for_create`.`surname` as `create_for_surname`, `create_by`.`name` as `create_by_name`, `create_by`.`surname` as `create_by_surname` , `create_by_role`.`name` as `create_by_role_name`,`create_by`.`employee_id` as `create_by_employee_id`,`staff_roles`.`role_id` FROM `conferences` LEFT JOIN `staff` as `for_create` ON `for_create`.`id` = `conferences`.`staff_id` JOIN `staff` as `create_by` ON `create_by`.`id` = `conferences`.`created_id`  JOIN `staff_roles` ON `staff_roles`.`staff_id` = `create_by`.`id` JOIN `roles` as `create_by_role` ON `create_by_role`.`id` = `staff_roles`.`role_id` WHERE `conferences`.`id` in (SELECT `conferences`.`id` FROM `conferences` WHERE `conferences`.`purpose`='" . $type . "' and created_id= " . $staff_id . " UNION SELECT `conferences`.`id` FROM `conference_staff` INNER JOIN conferences on conferences.id=conference_staff.conference_id  WHERE conference_staff.staff_id=" . $staff_id . " order by id desc) ORDER BY DATE(`conferences`.`date`) DESC, `conferences`.`date` DESC";
            $query = $this->db->query($sql);
            return $query->result();
        } else {
            $this->db->select('conferences.*, for_create.surname as `create_for_surname`, create_by.name as `create_by_name`, create_by.surname as `create_by_surname`, create_by_role.name as `create_by_role_name`, create_by.employee_id as `create_by_employee_id`, staff_roles.role_id', FALSE);
            $this->db->from('conferences');
            $this->db->join('staff as for_create', 'for_create.id = conferences.staff_id', 'left');
            $this->db->join('staff as create_by', 'create_by.id = conferences.created_id');

            $this->db->join('staff_roles', 'staff_roles.staff_id = create_by.id');
            $this->db->join('roles as `create_by_role`', 'create_by_role.id = staff_roles.role_id');
            $this->db->where('conferences.purpose', $type);
            $this->db->order_by('DATE(`conferences`.`date`)', 'DESC');
            $this->db->order_by('conferences.date', 'DESC');
            $query = $this->db->get();
            return $query->result();
        }
    }

    public function remove($id) {
        $this->db->trans_start();
        $this->db->trans_strict(false);
        $this->db->where('id', $id);
        $this->db->delete('conferences');
        $message = DELETE_RECORD_CONSTANT . " On conferences id " . $id;
        $action = "Delete";
        $record_id = $id;
        $this->log($message, $record_id, $action);
        $this->db->trans_complete();
        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            return true;
        }
    }

    /**
     * Get conferences by academic class
     * Legacy: joined conference_sections + class_sections + classes + sections, filtered by class_id + section_id
     * TVET: joins conference_classes + academic_class, filtered by academic_class.id
     *
     * @param int $class_id  academic_class.id
     * @param int $section_id  DEPRECATED - ignored in TVET mode
     */
    public function getByClassSection($class_id, $section_id = null) {
        $this->db->select('conferences.*, c.class_code, c.cohort_name as class, for_create.name as `create_for_name`, for_create.surname as `create_for_surname`, for_create.employee_id as `for_create_employee_id`, for_create_role.name as `for_create_role_name`, staff_roles.role_id', FALSE);
        $this->db->from('conference_classes cc');
        $this->db->join('conferences', 'conferences.id = cc.conference_id');
        $this->db->join('academic_class c', 'c.id = cc.class_id');
        $this->db->join('staff as for_create', 'for_create.id = conferences.staff_id');
        $this->db->join('staff_roles', 'staff_roles.staff_id = for_create.id');
        $this->db->join('roles as `for_create_role`', 'for_create_role.id = staff_roles.role_id');
        $this->db->where('cc.class_id', $class_id);
        $this->db->where('conferences.session_id', $this->current_session);
        $this->db->order_by('DATE(`conferences`.`date`)', 'DESC');
        $this->db->order_by('conferences.date', 'DESC');
        $query = $this->db->get();
        return $query->result();
    }

    public function update($id, $data) {
        $this->db->trans_start();
        $this->db->trans_strict(false);
        $this->db->where('id', $id);
        $query = $this->db->update("conferences", $data);

        $message = UPDATE_RECORD_CONSTANT . " On conferences id " . $id;
        $action = "Update";
        $record_id = $id;
        $this->log($message, $record_id, $action);

        $this->db->trans_complete();
        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            return true;
        }
    }

    public function getAllStaffByArray($staff = array()) {

        $this->db->select("staff.*, staff_designation.designation, department.department_name as department, roles.id as role_id, roles.name as role", FALSE);
        $this->db->from('staff');
        $this->db->join('staff_designation', "staff_designation.id = staff.designation", "left");
        $this->db->join('staff_roles', "staff_roles.staff_id = staff.id", "left");
        $this->db->join('roles', "roles.id = staff_roles.role_id", "left");
        $this->db->join('department', "department.id = staff.department", "left");
        $this->db->where_in('staff.id', $staff);
        $this->db->order_by('staff.id');
        $query = $this->db->get();
        return $query->result();
    }

    /**
     * Get students by academic class ID(s)
     * Legacy: joined student_session + classes + sections + class_sections
     * TVET: joins academic_class_enrolment + academic_class
     *
     * @param mixed $class_id  Single academic_class.id or array of academic_class.ids
     */
    public function getStudentByClassSectionID($class_id)
    {
        $this->db->select('e.id as `student_session_id`, e.final_mark as fees_discount, c.id AS `class_id`, c.class_code, c.cohort_name as class, students.id, students.admission_no, students.roll_no, students.admission_date, students.firstname, students.lastname, students.image, students.mobileno, students.email, students.state, students.city, students.pincode, students.note, students.religion, students.cast, school_houses.house_name, students.dob, students.current_address, students.previous_school, students.guardian_is, students.parent_id, students.permanent_address, students.category_id, students.adhar_no, students.samagra_id, students.bank_account_no, students.bank_name, students.ifsc_code, students.guardian_name, students.father_pic, students.height, students.weight, students.measurement_date, students.mother_pic, students.guardian_pic, students.guardian_relation, students.guardian_phone, students.guardian_address, students.is_active, students.created_at, students.updated_at, students.father_name, students.father_phone, students.blood_group, students.school_house_id, students.father_occupation, students.mother_name, students.mother_phone, students.mother_occupation, students.guardian_occupation, students.gender, students.guardian_is, students.rte, students.guardian_email, users.username, users.password, students.dis_reason, students.dis_note, students.app_key, students.parent_app_key', FALSE);
        $this->db->from('students');
        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('school_houses', 'school_houses.id = students.school_house_id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        if (is_array($class_id)) {
            $this->db->where_in('e.class_id', $class_id);
        } else {
            $this->db->where('e.class_id', $class_id);
        }
        $this->db->where('c.session_id', $this->current_session);
        $this->db->where('e.status', 'Active');
        $this->db->where('users.role', 'student');
        $this->db->where('students.is_active', 'yes');
        $this->db->order_by('students.id', 'desc');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getStaffbyConferenceId($id) {
        $list = $this->db->select('conference_staff.staff_id')->from('conference_staff')->where('conference_staff.conference_id', $id)->get()->result_array();
        $staffarray = array();
        foreach ($list as $key => $value) {
            $staffarray[] = $value['staff_id'];
        }
        return $staffarray;
    }

    // ==========================================
    // TVET / Teams Integration Methods
    // ==========================================

    public function addWithCohorts($data, $cohorts)
    {
        $this->db->trans_start();
        $this->db->trans_strict(false);
        $data['session_id'] = $this->current_session;
        $this->db->insert($this->table, $data);
        $inserted_id = $this->db->insert_id();
        if (!empty($cohorts)) {
            $insert_cohorts = array();
            foreach ($cohorts as $cohort_id) {
                $insert_cohorts[] = array('conference_id' => $inserted_id, 'cohort_id' => $cohort_id);
            }
            $this->db->insert_batch('conference_cohorts', $insert_cohorts);
        }
        $message = INSERT_RECORD_CONSTANT . " On " . $this->table . " id " . $inserted_id;
        $action = "Insert";
        $record_id = $inserted_id;
        $this->log($message, $record_id, $action);

        $this->db->trans_complete();
        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            return $inserted_id;
        }
    }

    public function getTeamsClasses($staff_id = null)
    {
        $this->db->select('conferences.*, create_by.name as create_by_name, create_by.surname as create_by_surname, create_by.employee_id as create_by_employee_id, create_by_role.name as create_by_role_name, staff_roles.role_id', FALSE);
        $this->db->from('conferences');
        $this->db->join('staff as create_by', 'create_by.id = conferences.created_id');
        $this->db->join('staff_roles', 'staff_roles.staff_id = create_by.id');
        $this->db->join('roles as create_by_role', 'create_by_role.id = staff_roles.role_id');
        $this->db->where('conferences.platform', 'teams');
        $this->db->where('conferences.session_id', $this->current_session);
        if (!empty($staff_id)) {
            $this->db->where('conferences.created_id', $staff_id);
        }
        $this->db->order_by('conferences.date', 'DESC');
        $query = $this->db->get();
        if ($query->num_rows() > 0) {
            $result = $query->result();
            foreach ($result as $row) {
                $row->cohorts = $this->getCohortsByConferenceID($row->id);
            }
            return $result;
        }
        return array();
    }

    public function getCohortsByConferenceID($conference_id)
    {
        $this->db->select('conference_cohorts.*, tvet_cohort.name as cohort_name, tvet_cohort.code as cohort_code, tvet_level.name as level_name, tvet_qualification.name as qualification_name', FALSE);
        $this->db->from('conference_cohorts');
        $this->db->join('tvet_cohort', 'tvet_cohort.id = conference_cohorts.cohort_id');
        $this->db->join('tvet_level', 'tvet_level.id = tvet_cohort.level_id');
        $this->db->join('tvet_qualification', 'tvet_qualification.id = tvet_level.qualification_id');
        $this->db->where('conference_cohorts.conference_id', $conference_id);
        return $this->db->get()->result();
    }

    public function getTeamsMeetings($staff_id = null)
    {
        $this->db->select('conferences.*, create_by.name as create_by_name, create_by.surname as create_by_surname, create_by.employee_id as create_by_employee_id, create_by_role.name as create_by_role_name, staff_roles.role_id', FALSE);
        $this->db->from('conferences');
        $this->db->join('staff as create_by', 'create_by.id = conferences.created_id');
        $this->db->join('staff_roles', 'staff_roles.staff_id = create_by.id');
        $this->db->join('roles as create_by_role', 'create_by_role.id = staff_roles.role_id');
        $this->db->where('conferences.platform', 'teams');
        $this->db->where('conferences.purpose', 'meeting');
        if (!empty($staff_id)) {
            $this->db->group_start();
            $this->db->where('conferences.created_id', $staff_id);
            $this->db->or_where('conferences.id IN (SELECT conference_id FROM conference_staff WHERE staff_id = ' . intval($staff_id) . ')', null, false);
            $this->db->group_end();
        }
        $this->db->order_by('conferences.date', 'DESC');
        return $this->db->get()->result();
    }

}
