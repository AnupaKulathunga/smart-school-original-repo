<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Teacher_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
        $this->current_date    = $this->setting_model->getDateYmd();
    }

    public function get($id = null)
    {
        $this->db->select()->from('teachers');
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

    public function getTeacher($id = null)
    {
        $this->db->select('teachers.*,users.id as `user_tbl_id`,users.username,users.password as `user_tbl_password`,users.is_active as `user_tbl_active`');
        $this->db->from('teachers');
        $this->db->join('users', 'users.user_id = teachers.id', 'left');
        $this->db->where('users.role', 'teacher');
        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
        }
    }

    public function getTeacherByEmail($email = null)
    {
        $this->db->select('teachers.*,users.id as `user_tbl_id`,users.username,users.password as `user_tbl_password`,users.is_active as `user_tbl_active`');
        $this->db->from('teachers');
        $this->db->join('users', 'users.user_id = teachers.id', 'left');
        $this->db->where('users.role', 'teacher');
        $this->db->where('teachers.email', $email);
        $query = $this->db->get();
        if ($email != null) {
            return $query->row();
        } else {
            return false;
        }
    }

    public function getLibraryTeacher()
    {
        if ($this->session->has_userdata('admin')) {
            $getStaffRole = $this->customlib->getStaffRole();
            $staffrole    = json_decode($getStaffRole);
            $superadmin_visible = $this->customlib->superadmin_visible();
            if ($superadmin_visible == 'disabled' && $staffrole->id != 7) {
                $this->db->where("roles.id !=", 7);
            }
        }

        $this->db->select('staff.*, IFNULL(libarary_members.id,0) as `libarary_member_id`, IFNULL(libarary_members.library_card_no,0) as `library_card_no`', FALSE)->from('staff');
        $this->db->join('libarary_members', 'libarary_members.member_id = staff.id and libarary_members.member_type = "teacher"', 'left');
        $this->db->join("staff_roles", "staff_roles.staff_id = staff.id", "left");
        $this->db->join("roles", "staff_roles.role_id = roles.id", "left");
        $this->db->where('staff.is_active', 1);
        $this->db->order_by('staff.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function remove($id)
    {
        $this->db->where('id', $id);
        $this->db->delete('teachers');
    }

    public function add($data)
    {
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('teachers', $data);
        } else {
            $this->db->insert('teachers', $data);
            return $this->db->insert_id();
        }
    }

    public function getTotalTeacher()
    {
        $sql   = "SELECT count(*) as `total_teacher` FROM `teachers`";
        $query = $this->db->query($sql);
        return $query->row();
    }

    public function searchNameLike($searchterm)
    {
        $this->db->select('teachers.*')->from('teachers');
        $this->db->group_start();
        $this->db->like('teachers.name', $searchterm);
        $this->db->group_end();
        $this->db->order_by('teachers.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function rating($data)
    {
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('staff_rating', $data);
        } else {
            $this->db->insert('staff_rating', $data);
            return $this->db->insert_id();
        }
    }

    public function my_classes($staff_id)
    {
        // TVET: Get classes from academic_class where staff is primary or additional lecturer
        $class_id = array();

        // Primary lecturer
        $query = $this->db->query("SELECT ac.id as class_id FROM academic_class ac WHERE ac.primary_lecturer_id=" . $this->db->escape($staff_id) . " AND ac.session_id=" . $this->db->escape($this->current_session));
        $data = $query->result_array();
        foreach ($data as $key => $value) {
            $class_id[] = $value['class_id'];
        }

        // Additional lecturer
        $query2 = $this->db->query("SELECT acl.class_id FROM academic_class_lecturer acl INNER JOIN academic_class ac ON ac.id = acl.class_id WHERE acl.lecturer_id=" . $this->db->escape($staff_id) . " AND acl.is_active=1 AND ac.session_id=" . $this->db->escape($this->current_session));
        $data2 = $query2->result_array();
        foreach ($data2 as $key => $value) {
            if (!in_array($value['class_id'], $class_id)) {
                $class_id[] = $value['class_id'];
            }
        }

        return $class_id;
    }

    public function get_classbysubject_group_id($subject_group_id)
    {
        $query        = $this->db->query("select st.class_id from subject_timetable st where st.subject_group_id='" . $subject_group_id . "' and session_id='" . $this->current_session . "' group by st.class_id");
        return $query = $query->result_array();
    }

    public function get_subjectby_staffid($staff_id)
    {
        $query        = $this->db->query("select GROUP_CONCAT(st.subject_group_subject_id) as subject from subject_timetable st where st.staff_id='" . $staff_id . "' and session_id='" . $this->current_session . "' group by staff_id ");
        return $query = $query->row_array();
    }

    public function get_examsubjects($staff_id)
    {
        $subject_id = array();

        // TVET: Get subjects from classes where staff is primary lecturer
        $primary_classes = $this->db->query("SELECT sgs.subject_id FROM subject_timetable st INNER JOIN subject_group_subjects sgs ON st.subject_group_subject_id=sgs.id INNER JOIN academic_class ac ON st.class_id = ac.id WHERE ac.primary_lecturer_id=" . $this->db->escape($staff_id) . " AND ac.session_id=" . $this->db->escape($this->current_session));
        foreach ($primary_classes->result_array() as $row) {
            $subject_id[$row['subject_id']] = $row['subject_id'];
        }

        // Get subjects from subject_timetable where staff teaches
        $query = $this->db->query("select sgs.subject_id from subject_timetable st inner join subject_group_subjects sgs on st.subject_group_subject_id=sgs.id where st.staff_id='" . $staff_id . "' and st.session_id='" . $this->current_session . "' ");
        $querydata = $query->result_array();
        foreach ($querydata as $key => $value) {
            $subject_id[$value['subject_id']] = $value['subject_id'];
        }

        return $subject_id;
    }

    public function get_subjectby_classid($class_id, $section_id, $staff_id)
    {
        $query = $this->db->query("select GROUP_CONCAT(st.subject_group_subject_id) as subject from subject_timetable st where st.staff_id='" . $staff_id . "' and class_id='" . $class_id . "' and st.session_id='" . $this->current_session . "'  group by staff_id ");
        return $query = $query->row_array();
    }

    public function get_teacherrestricted_mode($staff_id)
    {
        // TVET: Get class IDs from subject_timetable and academic_class (lecturer assignments)
        $class_ids = $this->my_classes($staff_id);

        // Also get from subject_timetable
        $query = $this->db->query("select CONCAT_WS(',',GROUP_CONCAT(st.class_id)) as c from subject_timetable st where st.staff_id='" . $staff_id . "' and session_id='" . $this->current_session . "' group by st.staff_id");
        $query = $query->result_array();
        if (!empty($query) && !empty($query[0]['c'])) {
            $timetable_ids = explode(',', $query[0]['c']);
            foreach ($timetable_ids as $tid) {
                if ($tid != '' && !in_array($tid, $class_ids)) {
                    $class_ids[] = $tid;
                }
            }
        }

        if (!empty($class_ids)) {
            // TVET: Return academic_class records instead of classes
            $classlist = $this->db->query("SELECT ac.id, ac.class_code as `class`, ac.cohort_name, ac.session_id FROM academic_class ac WHERE ac.id IN(" . implode(',', $class_ids) . ")");
            $data = $classlist->result_array();
        } else {
            $data = array();
        }

        return $data;
    }

    public function get_daywiseattendanceclass($staff_id)
    {
        // TVET: Get classes where staff is primary lecturer
        $class_ids = $this->my_classes($staff_id);

        if (!empty($class_ids)) {
            $classlist = $this->db->query("SELECT ac.id, ac.class_code as `class`, ac.cohort_name, ac.session_id FROM academic_class ac WHERE ac.id IN(" . implode(',', $class_ids) . ") AND ac.session_id=" . $this->db->escape($this->current_session));
            $data = $classlist->result_array();
        } else {
            $data = array();
        }

        return $data;
    }

    public function get_teacherrestricted_modesections($staff_id, $classid)
    {
        // TVET: No sections concept. Return the class itself as a single-element array
        // to maintain backward compatibility with callers expecting a sections array
        $class_ids = $this->my_classes($staff_id);

        if (in_array($classid, $class_ids)) {
            // Staff teaches this class - return a stub "section" entry
            $data = array(
                array('id' => $classid, 'section_id' => 0, 'section' => '')
            );
        } else {
            $data = array();
        }

        return $data;
    }

    public function get_teacherrestricted_modeallsections($staff_id)
    {
        // TVET: No sections concept. Return empty stub array for backward compatibility
        // Callers that used section filtering should use class-based filtering instead
        return array(
            array('section_id' => 0, 'section' => '')
        );
    }

    // ============================================================================
    // TVET METHODS - Use academic_class and academic_class_lecturer tables
    // In TVET model: class = subject + level + cohort + year + lecturer
    // ============================================================================

    /**
     * Get classes for a staff member (TVET)
     * Returns all academic_class IDs where staff is primary or additional lecturer
     *
     * @param int $staff_id Staff ID
     * @return array Array of class IDs
     */
    public function myClassesTVET($staff_id)
    {
        $class_ids = array();

        // Classes where staff is primary lecturer
        $primary = $this->db->select('ac.id')
            ->from('academic_class ac')
            ->where('ac.primary_lecturer_id', $staff_id)
            ->where('ac.session_id', $this->current_session)
            ->get()->result_array();

        foreach ($primary as $row) {
            $class_ids[] = $row['id'];
        }

        // Classes where staff is additional lecturer
        $additional = $this->db->select('acl.class_id')
            ->from('academic_class_lecturer acl')
            ->join('academic_class ac', 'ac.id = acl.class_id')
            ->where('acl.lecturer_id', $staff_id)
            ->where('acl.is_active', 1)
            ->where('ac.session_id', $this->current_session)
            ->get()->result_array();

        foreach ($additional as $row) {
            if (!in_array($row['class_id'], $class_ids)) {
                $class_ids[] = $row['class_id'];
            }
        }

        return $class_ids;
    }

    /**
     * Get subjects by class ID and staff (TVET)
     * Replaces get_subjectby_classid() - no section_id needed
     *
     * @param int $class_id academic_class.id
     * @param int $staff_id Staff ID
     * @return array Subject group subject IDs
     */
    public function getSubjectByClassStaff($class_id, $staff_id)
    {
        $query = $this->db->query("SELECT GROUP_CONCAT(st.subject_group_subject_id) as subject
            FROM subject_timetable st
            WHERE st.staff_id = " . $this->db->escape($staff_id) . "
            AND st.class_id = " . $this->db->escape($class_id) . "
            AND st.session_id = " . $this->db->escape($this->current_session) . "
            GROUP BY staff_id");
        return $query->row_array();
    }

    /**
     * Get exam subjects for staff (TVET)
     * Replaces get_examsubjects() - uses academic_class structure
     *
     * @param int $staff_id Staff ID
     * @return array Array of subject IDs
     */
    public function getExamSubjectsTVET($staff_id)
    {
        $subject_id = array();

        // Get subjects from classes where staff is primary lecturer
        $primary_classes = $this->db->query("
            SELECT sgs.subject_id
            FROM subject_timetable st
            INNER JOIN subject_group_subjects sgs ON st.subject_group_subject_id = sgs.id
            INNER JOIN academic_class ac ON st.class_id = ac.id
            WHERE ac.primary_lecturer_id = " . $this->db->escape($staff_id) . "
            AND ac.session_id = " . $this->db->escape($this->current_session) . "
        ");
        foreach ($primary_classes->result_array() as $row) {
            $subject_id[$row['subject_id']] = $row['subject_id'];
        }

        // Get subjects from subject_timetable where staff teaches
        $timetable_subjects = $this->db->query("
            SELECT sgs.subject_id
            FROM subject_timetable st
            INNER JOIN subject_group_subjects sgs ON st.subject_group_subject_id = sgs.id
            WHERE st.staff_id = " . $this->db->escape($staff_id) . "
            AND st.session_id = " . $this->db->escape($this->current_session) . "
        ");
        foreach ($timetable_subjects->result_array() as $row) {
            $subject_id[$row['subject_id']] = $row['subject_id'];
        }

        return $subject_id;
    }

    /**
     * Get restricted mode classes for staff (TVET)
     * Replaces get_teacherrestricted_mode() - returns academic_class records
     *
     * @param int $staff_id Staff ID
     * @return array Array of class records
     */
    public function getRestrictedClassesTVET($staff_id)
    {
        $class_ids = $this->myClassesTVET($staff_id);

        if (!empty($class_ids)) {
            $this->db->select('ac.*, asub.name as subject_name, al.code as level_code', FALSE)
                ->from('academic_class ac')
                ->join('academic_subject_level asl', 'asl.id = ac.subject_level_id')
                ->join('academic_subject asub', 'asub.id = asl.subject_id')
                ->join('academic_level al', 'al.id = asl.level_id')
                ->where_in('ac.id', $class_ids)
                ->where('ac.session_id', $this->current_session);
            return $this->db->get()->result_array();
        }

        return array();
    }

    /**
     * Get classes for daywise attendance (TVET)
     * Replaces get_daywiseattendanceclass() - uses academic_class
     *
     * @param int $staff_id Staff ID
     * @return array Array of class records
     */
    public function getDaywiseAttendanceClassTVET($staff_id)
    {
        // Get classes where staff is primary lecturer
        $this->db->select('ac.*, asub.name as subject_name, al.code as level_code', FALSE)
            ->from('academic_class ac')
            ->join('academic_subject_level asl', 'asl.id = ac.subject_level_id')
            ->join('academic_subject asub', 'asub.id = asl.subject_id')
            ->join('academic_level al', 'al.id = asl.level_id')
            ->where('ac.primary_lecturer_id', $staff_id)
            ->where('ac.session_id', $this->current_session);
        return $this->db->get()->result_array();
    }

    /**
     * Get class details by lecturer (TVET)
     * Returns full class info including subject and level details
     *
     * @param int $staff_id Staff ID
     * @return array Array of class details
     */
    public function getClassDetailsByLecturer($staff_id)
    {
        // Classes where staff is primary lecturer
        $primary = $this->db->select('ac.*, asub.name as subject_name, asub.code as subject_code,
                                      al.code as level_code, al.name as level_name,
                                      "Primary" as lecturer_role', FALSE)
            ->from('academic_class ac')
            ->join('academic_subject_level asl', 'asl.id = ac.subject_level_id')
            ->join('academic_subject asub', 'asub.id = asl.subject_id')
            ->join('academic_level al', 'al.id = asl.level_id')
            ->where('ac.primary_lecturer_id', $staff_id)
            ->where('ac.session_id', $this->current_session)
            ->get()->result_array();

        // Classes where staff is additional lecturer
        $additional = $this->db->select('ac.*, asub.name as subject_name, asub.code as subject_code,
                                         al.code as level_code, al.name as level_name,
                                         acl.role as lecturer_role', FALSE)
            ->from('academic_class_lecturer acl')
            ->join('academic_class ac', 'ac.id = acl.class_id')
            ->join('academic_subject_level asl', 'asl.id = ac.subject_level_id')
            ->join('academic_subject asub', 'asub.id = asl.subject_id')
            ->join('academic_level al', 'al.id = asl.level_id')
            ->where('acl.lecturer_id', $staff_id)
            ->where('acl.is_active', 1)
            ->where('ac.session_id', $this->current_session)
            ->get()->result_array();

        return array_merge($primary, $additional);
    }

}
