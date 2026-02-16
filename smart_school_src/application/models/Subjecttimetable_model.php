<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Subjecttimetable_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
    }

    public function add($delete_array, $insert_array, $update_array)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        if (!empty($delete_array)) {
            $this->db->where_in('id', $delete_array);
            $this->db->delete('subject_timetable');
        }

        if (isset($update_array) && !empty($update_array)) {
            $this->db->update_batch('subject_timetable', $update_array, 'id');
        }

        if (isset($insert_array) && !empty($insert_array)) {
            $this->db->insert_batch('subject_timetable', $insert_array);
            $count = count($insert_array);
            $id    = $this->db->insert_id();
            $loop  = $id - $count;
            for ($x = $id; $x > $loop; $x--) {
                $message   = INSERT_RECORD_CONSTANT . " On  subject timetable id " . $x;
                $action    = "Insert";
                $record_id = $x;
                $this->log($message, $record_id, $action);
            }
        }

        $this->db->trans_complete(); # Completing transaction

        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            $this->db->trans_commit();
            return true;
        }
    }

    public function get($id)
    {
        $this->db->select("subject_timetable.*,subject_group_subjects.subject_id,subjects.name,subjects.code,'theory' as type", FALSE);
        $this->db->from('subject_timetable');
        $this->db->join('subject_group_subjects', 'subject_timetable.subject_group_subject_id = subject_group_subjects.id');
        $this->db->join('staff', 'staff.id = subject_timetable.staff_id');
        $this->db->join('academic_subject subjects', 'subjects.id = subject_group_subjects.subject_id');
        $this->db->where('subject_timetable.id', $id);
        $query = $this->db->get();
        return $query->row();
    }

    public function getBySubjectGroupDayClassSection($subject_group_id, $day, $class_id, $section_id = null)
    {
        $this->db->select('subject_timetable.*');
        $this->db->from('subject_timetable');
        $this->db->join('subject_group_subjects', 'subject_timetable.subject_group_subject_id = subject_group_subjects.id');
        $this->db->join('staff', 'staff.id = subject_timetable.staff_id');
        $this->db->where('subject_timetable.class_id', $class_id);
        $this->db->where('subject_timetable.day', $day);
        $this->db->where('subject_timetable.subject_group_id', $subject_group_id);
        $this->db->where('staff.is_active', 1);
        $this->db->order_by('subject_timetable.start_time', 'asc');
        $query = $this->db->get();
        return $query->result();
    }

    public function getSubjectByClassandSectionDay($class_id, $section_id, $day)
    {
        $subject_condition = "";
        $userdata          = $this->customlib->getUserData();

        $role_id = $userdata["role_id"];
        if (isset($role_id) && ($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            if ($userdata["class_teacher"] == 'yes') {

                $my_classes = $this->teacher_model->my_classes($userdata['id']);

                if (!empty($my_classes)) {
                    if (in_array($class_id, $my_classes)) {
                        $subject_condition = "";
                    } else {
                        $my_subjects = $this->teacher_model->get_subjectby_classid($class_id, null, $userdata['id']);
                        $subject_condition = " and subject_group_subjects.id in(" . $my_subjects['subject'] . ")";
                    }
                } else {
                    $my_subjects = $this->teacher_model->get_subjectby_classid($class_id, null, $userdata['id']);
                    $subject_condition = " and subject_group_subjects.id in(" . $my_subjects['subject'] . ")";
                }
            }
        }
        $subject_condition = $subject_condition . " and staff.is_active=1 order by subject_timetable.start_time asc";

        $sql = "SELECT `subject_group_subjects`.`subject_id`,subjects.name as `subject_name`,subjects.code,'theory' as type,staff.name,staff.surname,staff.employee_id,`subject_timetable`.* FROM `subject_timetable` JOIN `subject_group_subjects` ON `subject_timetable`.`subject_group_subject_id` = `subject_group_subjects`.`id`inner JOIN academic_subject subjects on subject_group_subjects.subject_id = subjects.id INNER JOIN staff on staff.id=subject_timetable.staff_id   WHERE `subject_timetable`.`class_id` = " . $class_id . " AND `subject_timetable`.`day` = " . $this->db->escape($day) . " AND `subject_timetable`.`session_id` = " . $this->current_session . "" . $subject_condition;

        $query = $this->db->query($sql);

        return $query->result();
    }

    public function getparentSubjectByClassandSectionDay($class_id, $section_id, $day)
    {
        $sql   = "SELECT `subject_group_subjects`.`subject_id`,subjects.name as `subject_name`,subjects.code,'theory' as type,staff.name,staff.surname,staff.employee_id,staff.image,staff.gender,`subject_timetable`.* FROM `subject_timetable` JOIN `subject_group_subjects` ON `subject_timetable`.`subject_group_subject_id` = `subject_group_subjects`.`id` INNER JOIN academic_subject subjects on subject_group_subjects.subject_id = subjects.id INNER JOIN staff on staff.id=subject_timetable.staff_id WHERE `subject_timetable`.`class_id` = " . $this->db->escape($class_id) . " AND `subject_timetable`.`day` = " . $this->db->escape($day) . " AND `subject_timetable`.`session_id` = " . $this->current_session . " and staff.is_active=1 order by subject_timetable.start_time asc";
        $query = $this->db->query($sql);

        return $query->result();
    }

    public function getTeacherByClassandSection($class_id, $section_id = null)
    {
        $condition  = " and staff.is_active='1'";
        if ($class_id != '') {
            // Support comma-separated class IDs for programme-based dashboard
            $class_ids = is_array($class_id) ? $class_id : explode(',', $class_id);
            $class_ids = array_map('intval', $class_ids);
            $class_ids_str = implode(',', $class_ids);
            $condition .= " and `subject_timetable`.`class_id` IN (" . $class_ids_str . ")";
        }

        $sql = "SELECT 'subject' type, NULL as class_teacher,`subject_group_subjects`.`subject_id` as subject_id,subjects.name as `subject_name`,subjects.code as code,'theory' as type,staff.name,staff.surname,staff.email,staff.contact_no,staff.employee_id,`subject_timetable`.staff_id as staff_id,staff.image,staff.gender,`subject_timetable`.time_from as time_from,`subject_timetable`.day as day,`subject_timetable`.room_no as room_no,`subject_timetable`.time_to as time_to ,`subject_timetable`.start_time as start_time, '' as section_name, ac.class_code as class_name FROM `subject_timetable` JOIN `subject_group_subjects` ON `subject_timetable`.`subject_group_subject_id` = `subject_group_subjects`.`id` left JOIN academic_subject subjects on subject_group_subjects.subject_id = subjects.id INNER JOIN staff on staff.id=subject_timetable.staff_id LEFT JOIN academic_class ac on ac.id=subject_timetable.class_id WHERE 1=1 " . $condition . " AND `subject_timetable`.`session_id` = '" . $this->current_session . "'";

        $query = $this->db->query($sql);

        return $query->result();
    }

    public function getSubjectByClassandSection($class_id, $section_id = null)
    {
        $condition = '';
        if ($class_id != '') {
            $condition .= " and `subject_timetable`.`class_id` = " . $this->db->escape($class_id) . "";
        }

        $sql = "SELECT NULL as class_teacher,`subject_group_subjects`.`subject_id`,subjects.name as `subject_name`,subjects.code,'theory' as type,staff.name,staff.surname,staff.employee_id,`subject_timetable`.*, '' as section_name, ac.class_code as class_name FROM `subject_timetable` JOIN `subject_group_subjects` ON `subject_timetable`.`subject_group_subject_id` = `subject_group_subjects`.`id` INNER JOIN academic_subject subjects on subject_group_subjects.subject_id = subjects.id INNER JOIN staff on staff.id=subject_timetable.staff_id LEFT JOIN academic_class ac on ac.id=subject_timetable.class_id WHERE 1=1 " . $condition . " AND `subject_timetable`.`session_id` = " . $this->current_session . " AND `staff`.`is_active` =1 ";

        $query = $this->db->query($sql);
        return $query->result();
    }

    public function getSyllabussubject($staff_id, $day_value, $class_section_array)
    {
        if (!empty($class_section_array)) {
            // TVET: class_section_array keys are class_ids - filter by class_id only
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->db->where_in('subject_timetable.class_id', $class_ids);
            }
        }

        $result = $this->db->select('ac.class_code as `class`, `subject_group_subjects`.`subject_id`,`sub`.`name` as `subject_name`,`sub`.`code` as `subject_code`,`subject_timetable`.*', FALSE)->from('subject_timetable')->join('academic_class ac', 'ac.id=subject_timetable.class_id', 'left')->join('subject_group_subjects', '`subject_group_subjects`.`id`=`subject_timetable`.`subject_group_subject_id`')->join('academic_subject as sub', '`sub`.`id`=`subject_group_subjects`.`subject_id`')->where('subject_timetable.session_id', $this->current_session)->where('subject_group_subjects.session_id', $this->current_session)->where('subject_timetable.day', $day_value)->where('subject_timetable.staff_id', $staff_id)->get()->result();

        return $result;

    }

    public function getByStaffandDay($staff_id, $day_value)
    {
        $sql   = "SELECT ac.class_code as `class`, `subject_group_subjects`.`subject_id`,`sub`.`name` as `subject_name`,`sub`.`code` as `subject_code`,`subject_timetable`.* FROM `subject_timetable` LEFT JOIN `academic_class` ac on ac.id = `subject_timetable`.`class_id` INNER JOIN `subject_group_subjects` on `subject_group_subjects`.`id`=`subject_timetable`.`subject_group_subject_id` INNER JOIN `academic_subject` as `sub` on `sub`.`id`=`subject_group_subjects`.`subject_id`  WHERE subject_timetable.staff_id=" . $this->db->escape($staff_id) . " and subject_timetable.session_id =" . $this->current_session . " and subject_timetable.day=" . $this->db->escape($day_value) . " order by subject_timetable.start_time";
        $query = $this->db->query($sql);
        if ($query->num_rows() > 0) {
            return $query->result();
        } else {
            return false;
        }
    }

    public function getByStaffClassTeachersubjects($staff_id)
    {
        $sql = "select GROUP_CONCAT(subject_timetable.subject_group_subject_id) as subject_group_subject_id from subject_timetable WHERE subject_timetable.staff_id=" . $this->db->escape($staff_id) . " and subject_timetable.session_id =" . $this->current_session;

        $query = $this->db->query($sql);
        if ($query->num_rows() > 0) {
            return $query->result();
        } else {
            return false;
        }
    }

    public function getByTeacherSubjects($staff_id)
    {
        $sql   = "SELECT GROUP_CONCAT(subject_timetable.subject_group_subject_id) as subject_group_subject_id FROM `subject_timetable`   WHERE subject_timetable.staff_id=" . $this->db->escape($staff_id) . " and subject_timetable.session_id =" . $this->current_session;
        $query = $this->db->query($sql);
        if ($query->num_rows() > 0) {
            return $query->result();
        } else {
            return false;
        }
    }

    public function canAddExamMarks($staff_id, $class_id, $section_id = null, $subject_id = null)
    {
        // TVET: Check if staff is primary lecturer for this academic_class
        $primary_lecturer = $this->db->select('id')->from('academic_class')->where('id', $class_id)->where('primary_lecturer_id', $staff_id)->where('session_id', $this->current_session)->get()->num_rows();
        if ($primary_lecturer > 0) {
            return 1;
        }

        // TVET: Check if staff is additional lecturer
        $additional_lecturer = $this->db->select('id')->from('academic_class_lecturer')->where('class_id', $class_id)->where('lecturer_id', $staff_id)->where('is_active', 1)->get()->num_rows();
        if ($additional_lecturer > 0) {
            return 1;
        }

        // Check subject_timetable entries
        $this->db->select('*')->from('subject_timetable')->join('subject_group_subjects', 'subject_timetable.subject_group_subject_id=subject_group_subjects.id')->where('subject_timetable.class_id', $class_id)->where('subject_timetable.staff_id', $staff_id);
        if ($subject_id !== null) {
            $this->db->where('subject_group_subjects.subject_id', $subject_id);
        }
        $subject_teacher = $this->db->get()->num_rows();

        if ($subject_teacher > 0) {
            return 1;
        } else {
            return 0;
        }
    }
    
    public function getByTeacherSubjectandDay($staff_id, $day_value) {

        $sql = "SELECT GROUP_CONCAT(subject_timetable.id order by subject_timetable.start_time) as timetable_id FROM `subject_timetable`   WHERE subject_timetable.staff_id=" . $this->db->escape($staff_id) . " and subject_timetable.session_id =" . $this->current_session . " and subject_timetable.day=" . $this->db->escape($day_value)." order by subject_timetable.start_time";
        $query = $this->db->query($sql);
        if ($query->num_rows() > 0) {
            return $query->result();
        } else {
            return false;
        }
    }
    
    // TVET: New method for TVET CLASS-based syllabus (no section_id)
    public function getTVETSyllabusSubject($staff_id, $day_value, $class_ids = array())
    {
        $this->db->select('ac.class_code, ac.cohort_name, asub.name as subject_name, asub.code as subject_code, subject_timetable.*, asl.id as subject_level_id');
        $this->db->from('subject_timetable');

        // TVET: Join to academic_class directly via class_id
        $this->db->join('academic_class ac', 'ac.id = subject_timetable.class_id', 'left');
        $this->db->join('academic_subject_level asl', 'asl.id = ac.subject_level_id', 'left');
        $this->db->join('academic_subject asub', 'asub.id = asl.subject_id', 'left');

        $this->db->where('subject_timetable.session_id', $this->current_session);
        $this->db->where('subject_timetable.day', $day_value);
        $this->db->where('subject_timetable.staff_id', $staff_id);

        // TVET: Filter by class_ids if provided
        if (!empty($class_ids)) {
            $this->db->where_in('ac.id', $class_ids);
        }

        $this->db->group_by('subject_timetable.id');
        $this->db->order_by('subject_timetable.start_time', 'asc');

        $result = $this->db->get()->result();

        // If no TVET classes found, fall back to legacy subject_group_subjects lookup
        if (empty($result)) {
            // Fallback: Query using existing subject_group_subjects structure
            $this->db->select('subject_group_subjects.subject_id, sub.name as subject_name, sub.code as subject_code, subject_timetable.*');
            $this->db->from('subject_timetable');
            $this->db->join('subject_group_subjects', 'subject_group_subjects.id = subject_timetable.subject_group_subject_id', 'left');
            $this->db->join('academic_subject as sub', 'sub.id = subject_group_subjects.subject_id', 'left');
            $this->db->where('subject_timetable.session_id', $this->current_session);
            $this->db->where('subject_timetable.day', $day_value);
            $this->db->where('subject_timetable.staff_id', $staff_id);
            $this->db->order_by('subject_timetable.start_time', 'asc');

            $result = $this->db->get()->result();
        }

        return $result;
    }

    public function getByStaffClassTeacherandDay($staff_id, $day_value) {

        $sql = "select GROUP_CONCAT(subject_timetable.id) as timetable_id from subject_timetable WHERE subject_timetable.staff_id=" . $this->db->escape($staff_id) . " and subject_timetable.session_id =" . $this->current_session." and subject_timetable.day=" . $this->db->escape($day_value) . " order by subject_timetable.start_time";
        $query = $this->db->query($sql);
        if ($query->num_rows() > 0) {
            return $query->result();
        } else {
            return false;
        }
    }

    // ============================================================================
    // TVET METHODS - Use class table (no sections)
    // ============================================================================

    /**
     * Get timetable entries by subject group, day, and class (TVET)
     * Replaces getBySubjectGroupDayClassSection() for TVET architecture
     *
     * @param int $subject_group_id The subject group ID
     * @param string $day The day name
     * @param int $class_id The TVET class ID
     * @return array Timetable entries for this subject group, day, and class
     */
    public function getBySubjectGroupDayClass($subject_group_id, $day, $class_id)
    {
        $this->db->select('subject_timetable.*')
            ->from('subject_timetable')
            ->join('subject_group_subjects', 'subject_timetable.subject_group_subject_id = subject_group_subjects.id')
            ->join('staff', 'staff.id = subject_timetable.staff_id')
            ->where('subject_timetable.class_id', $class_id)
            ->where('subject_timetable.day', $day)
            ->where('subject_timetable.subject_group_id', $subject_group_id)
            ->where('staff.is_active', 1)
            ->order_by('subject_timetable.start_time', 'asc');

        return $this->db->get()->result();
    }

    /**
     * Get timetable for a specific class and day (TVET)
     * Replaces getSubjectByClassandSectionDay() for TVET architecture
     *
     * @param int $class_id The TVET class ID
     * @param string $day The day name
     * @return array Timetable entries with subject and staff details
     */
    public function getSubjectByClassDay($class_id, $day)
    {
        $subject_condition = "";
        $userdata          = $this->customlib->getUserData();

        $role_id = $userdata["role_id"];
        if (isset($role_id) && ($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            if ($userdata["class_teacher"] == 'yes') {
                $my_classes = $this->teacher_model->my_classes($userdata['id']);

                if (!empty($my_classes)) {
                    if (in_array($class_id, $my_classes)) {
                        $subject_condition = "";
                    } else {
                        // TVET: Get subjects for this specific class
                        $my_subjects = $this->teacher_model->get_subjectby_class($class_id, $userdata['id']);
                        if (!empty($my_subjects) && isset($my_subjects['subject'])) {
                            $subject_condition = " and subject_group_subjects.id in(" . $my_subjects['subject'] . ")";
                        }
                    }
                } else {
                    $my_subjects = $this->teacher_model->get_subjectby_class($class_id, $userdata['id']);
                    if (!empty($my_subjects) && isset($my_subjects['subject'])) {
                        $subject_condition = " and subject_group_subjects.id in(" . $my_subjects['subject'] . ")";
                    }
                }
            }
        }
        $subject_condition = $subject_condition . " and staff.is_active=1 order by subject_timetable.start_time asc";

        $sql = "SELECT `subject_group_subjects`.`subject_id`, subjects.name as `subject_name`, subjects.code, 'theory' as type,
                staff.name, staff.surname, staff.employee_id, `subject_timetable`.*,
                ac.class_code, ac.cohort_name
                FROM `subject_timetable`
                JOIN `subject_group_subjects` ON `subject_timetable`.`subject_group_subject_id` = `subject_group_subjects`.`id`
                INNER JOIN academic_subject subjects ON subject_group_subjects.subject_id = subjects.id
                INNER JOIN staff ON staff.id = subject_timetable.staff_id
                LEFT JOIN academic_class ac ON ac.id = subject_timetable.class_id
                WHERE `subject_timetable`.`class_id` = " . $this->db->escape($class_id) . "
                AND `subject_timetable`.`day` = " . $this->db->escape($day) . "
                AND `subject_timetable`.`session_id` = " . $this->current_session . "" . $subject_condition;

        $query = $this->db->query($sql);
        return $query->result();
    }

    /**
     * Get all subjects for a class (TVET)
     * Replaces getSubjectByClassandSection() - no section_id parameter
     *
     * @param int $class_id academic_class.id
     * @return array List of subjects with timetable info
     */
    public function getSubjectByClass($class_id)
    {
        $sql = "SELECT DISTINCT subject_group_subjects.subject_id, subjects.name as subject_name,
                       subjects.code, 'theory' as type, subject_group_subjects.id as subject_group_subject_id
                FROM subject_timetable
                JOIN subject_group_subjects ON subject_timetable.subject_group_subject_id = subject_group_subjects.id
                INNER JOIN academic_subject subjects ON subject_group_subjects.subject_id = subjects.id
                WHERE subject_timetable.class_id = " . $this->db->escape($class_id) . "
                  AND subject_timetable.session_id = " . $this->current_session . "
                ORDER BY subjects.name";

        $query = $this->db->query($sql);
        return $query->result();
    }

    /**
     * Get parent/student timetable by class and day (TVET)
     * Replaces getparentSubjectByClassandSectionDay() - no section_id parameter
     *
     * @param int $class_id academic_class.id
     * @param string $day Day name
     * @return array Timetable entries
     */
    public function getTimetableByClassDay($class_id, $day)
    {
        // Support comma-separated class IDs for programme-based dashboard
        $class_ids = is_array($class_id) ? $class_id : explode(',', $class_id);
        $class_ids = array_map('intval', $class_ids);
        $class_ids_str = implode(',', $class_ids);

        $sql = "SELECT subject_group_subjects.subject_id, subjects.name as subject_name, subjects.code,
                       'theory' as type, staff.name as staff_name, staff.surname, subject_timetable.*
                FROM subject_timetable
                JOIN subject_group_subjects ON subject_timetable.subject_group_subject_id = subject_group_subjects.id
                INNER JOIN academic_subject subjects ON subject_group_subjects.subject_id = subjects.id
                INNER JOIN staff ON staff.id = subject_timetable.staff_id
                WHERE subject_timetable.class_id IN (" . $class_ids_str . ")
                  AND subject_timetable.day = " . $this->db->escape($day) . "
                  AND subject_timetable.session_id = " . $this->current_session . "
                  AND staff.is_active = 1
                ORDER BY subject_timetable.start_time ASC";

        $query = $this->db->query($sql);
        return $query->result();
    }

    /**
     * Get TVET academic timetable (uses academic_timetable table)
     * For classes using the pure TVET academic_timetable structure
     *
     * @param int $class_id academic_class.id
     * @param string $day Day of week (optional)
     * @return array Timetable entries from academic_timetable
     */
    public function getAcademicTimetable($class_id, $day = null)
    {
        $this->db->select('at.*, staff.name as staff_name, staff.surname,
                          ac.class_code, ac.cohort_name,
                          asub.name as subject_name, asub.code as subject_code,
                          al.code as level_code', FALSE)
            ->from('academic_timetable at')
            ->join('academic_class ac', 'ac.id = at.class_id')
            ->join('academic_subject_level asl', 'asl.id = ac.subject_level_id')
            ->join('academic_subject asub', 'asub.id = asl.subject_id')
            ->join('academic_level al', 'al.id = asl.level_id')
            ->join('staff', 'staff.id = at.staff_id', 'left')
            ->where('at.class_id', $class_id);

        if ($day !== null) {
            $this->db->where('at.day_of_week', $day);
        }

        $this->db->order_by('at.day_of_week, at.start_time');
        return $this->db->get()->result();
    }

    /**
     * Check if staff can add exam marks for class (TVET)
     * Replaces canAddExamMarks() - no section_id parameter
     *
     * @param int $staff_id Staff ID
     * @param int $class_id academic_class.id
     * @param int $subject_id Subject ID (optional)
     * @return int 1 if authorized, 0 otherwise
     */
    public function canAddExamMarksForClass($staff_id, $class_id, $subject_id = null)
    {
        // Check if staff is primary lecturer for this class
        $this->db->where('id', $class_id);
        $this->db->where('primary_lecturer_id', $staff_id);
        $this->db->where('session_id', $this->current_session);
        $primary = $this->db->get('academic_class');

        if ($primary->num_rows() > 0) {
            return 1;
        }

        // Check if staff is additional lecturer
        $this->db->from('academic_class_lecturer acl')
            ->join('academic_class ac', 'ac.id = acl.class_id')
            ->where('acl.class_id', $class_id)
            ->where('acl.lecturer_id', $staff_id)
            ->where('acl.is_active', 1)
            ->where('ac.session_id', $this->current_session);

        if ($this->db->count_all_results() > 0) {
            return 1;
        }

        // Check if staff has timetable entries for this class
        $this->db->where('class_id', $class_id);
        $this->db->where('staff_id', $staff_id);
        $this->db->where('session_id', $this->current_session);
        $timetable = $this->db->get('subject_timetable');

        if ($timetable->num_rows() > 0) {
            return 1;
        }

        return 0;
    }

}
