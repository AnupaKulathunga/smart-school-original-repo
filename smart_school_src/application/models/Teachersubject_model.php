<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Teachersubject_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
    }

    public function get($id = null)
    {
        $this->db->select()->from('teacher_subjects');
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

    public function teachersjubject($id = null)
    {
        $this->db->select()->from('teacher_subjects');
        if ($id != null) {
            $this->db->where('teacher_id', $id);
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

    public function remove($id)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->where('id', $id);
        $this->db->delete('teacher_subjects');
        $message   = DELETE_RECORD_CONSTANT . " On teacher subjects id " . $id;
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

    public function deleteBatch($ids, $class_id)
    {
        $this->db->where('class_id', $class_id);
        $this->db->where('session_id', $this->current_session);
        $this->db->where_not_in('id', $ids);
        $this->db->delete('teacher_subjects');
    }

    public function add($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('teacher_subjects', $data);
            $message   = UPDATE_RECORD_CONSTANT . " On  teacher subjects id " . $data["id"];
            $action    = "Update";
            $record_id = $data["id"];
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
            $this->db->insert('teacher_subjects', $data);
            $id        = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On teacher subjects id " . $id;
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

    public function getDetailByclassAndSection($class_id)
    {
        $this->db->select()->from('teacher_subjects');
        $this->db->where('class_id', $class_id);
        $this->db->where('teacher_subjects.session_id', $this->current_session);
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getDetailbyClsandSection($class_id, $section_id = null, $exam_id = null)
    {
        $query = $this->db->query("SELECT teacher_subjects.*,
                    exam_schedules.date_of_exam, exam_schedules.start_to, exam_schedules.end_from,
                    exam_schedules.room_no, exam_schedules.full_marks, exam_schedules.passing_marks,
                    subjects.name, 'theory' as type
                FROM teacher_subjects
                LEFT JOIN exam_schedules ON exam_schedules.teacher_subject_id = teacher_subjects.id
                    AND exam_schedules.exam_id = " . $this->db->escape($exam_id) . "
                INNER JOIN academic_subject subjects ON teacher_subjects.subject_id = subjects.id
                WHERE teacher_subjects.class_id = " . $this->db->escape($class_id));
        return $query->result_array();
    }

    public function getSubjectByClsandSection($class_id, $section_id = null, $classteacher = 'yes')
    {
        $userdata = $this->customlib->getUserData();
        $role_id  = $userdata["role_id"];
        if (isset($role_id) && ($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            $cquery = $this->db->select("ac.*", FALSE)
                ->from("class_teacher")
                ->join("academic_class ac", "class_teacher.class_id = ac.id")
                ->where("class_teacher.staff_id", $userdata["id"])
                ->where("ac.id", $class_id)
                ->get();
            if ($cquery->num_rows() > 0) {

                $classteacher = 'no';
            } else {
                $classteacher = 'yes';
            }

            if ($classteacher == 'yes') {
                $where = " AND teacher_subjects.teacher_id = " . $userdata["id"];
            } else {
                $where = " ";
            }
        } else {
            $where = " ";
        }

        $sql = "SELECT teacher_subjects.*, staff.name as `teacher_name`, staff.surname,
                       subjects.name, 'theory' as type, subjects.code
                FROM teacher_subjects
                INNER JOIN academic_subject subjects ON teacher_subjects.subject_id = subjects.id
                INNER JOIN academic_class ac ON teacher_subjects.class_id = ac.id
                INNER JOIN staff ON staff.id = teacher_subjects.teacher_id
                WHERE teacher_subjects.class_id = " . $this->db->escape($class_id) . "
                  AND teacher_subjects.session_id = " . $this->db->escape($this->current_session) . " " . $where;
        $query = $this->db->query($sql);
        return $query->result_array();
    }

    public function getTeacherClassSubjects($teacher_id)
    {
        $this->db->select('teacher_subjects.*, subjects.name, ac.class_code as class', FALSE);
        $this->db->from('teacher_subjects');
        $this->db->join('academic_subject subjects', 'subjects.id = teacher_subjects.subject_id');
        $this->db->join('academic_class ac', 'ac.id = teacher_subjects.class_id');
        $this->db->where('teacher_subjects.teacher_id', $teacher_id);
        $this->db->where('teacher_subjects.session_id', $this->current_session);
        $query = $this->db->get();
        return $query->result();
    }

    // ============================================================================
    // TVET METHODS - Use academic_class table (no sections)
    // ============================================================================

    /**
     * Get teacher subject details by class (TVET)
     * Replaces getDetailbyClsandSection() for TVET architecture
     *
     * Each class_id represents ONE cohort for ONE subject-level combination
     * So assigning exam to class_id automatically assigns to specific cohort
     *
     * @param int $class_id The TVET academic_class.id
     * @param int $exam_id The exam ID
     * @return array Teacher subjects with exam schedule details
     */
    public function getDetailbyClass($class_id, $exam_id)
    {
        $this->db->select("teacher_subjects.*,
                          exam_schedules.date_of_exam, exam_schedules.start_to,
                          exam_schedules.end_from, exam_schedules.room_no,
                          exam_schedules.full_marks, exam_schedules.passing_marks,
                          subjects.name, 'theory' as type, subjects.code,
                          ac.class_code, ac.cohort_name,
                          al.name as level_name", FALSE)
            ->from('teacher_subjects')
            ->join('exam_schedules', 'exam_schedules.teacher_subject_id = teacher_subjects.id
                   AND exam_schedules.exam_id = ' . $this->db->escape($exam_id), 'left')
            ->join('academic_subject subjects', 'teacher_subjects.subject_id = subjects.id')
            ->join('academic_class ac', 'teacher_subjects.class_id = ac.id')
            ->join('academic_subject_level asl', 'ac.subject_level_id = asl.id', 'left')
            ->join('academic_level al', 'asl.level_id = al.id', 'left')
            ->where('ac.id', $class_id)
            ->where('teacher_subjects.session_id', $this->current_session);

        return $this->db->get()->result_array();
    }

    /**
     * Get all subjects for a specific class (TVET)
     * Replaces getSubjectByClsandSection() for timetable display
     *
     * @param int $class_id The TVET academic_class.id
     * @param string $classteacher Optional filter for class teacher
     * @return array Teacher subjects with details
     */
    public function getSubjectByClass($class_id, $classteacher = 'yes')
    {
        $userdata = $this->customlib->getUserData();
        $role_id  = $userdata["role_id"];
        $where = " ";

        if (isset($role_id) && ($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            // Check if this teacher is assigned to this class (primary lecturer)
            $is_class_lecturer = $this->db->select('ac.id')
                ->from('academic_class ac')
                ->where('ac.id', $class_id)
                ->where('ac.primary_lecturer_id', $userdata["id"])
                ->get()->num_rows();

            // Also check additional lecturers
            if ($is_class_lecturer == 0) {
                $is_class_lecturer = $this->db->select('acl.id')
                    ->from('academic_class_lecturer acl')
                    ->where('acl.class_id', $class_id)
                    ->where('acl.lecturer_id', $userdata["id"])
                    ->where('acl.is_active', 1)
                    ->get()->num_rows();
            }

            if ($is_class_lecturer == 0 && $classteacher == 'yes') {
                $where = " AND teacher_subjects.teacher_id = " . $userdata["id"];
            }
        }

        $sql = "SELECT teacher_subjects.*, staff.name as teacher_name, staff.surname,
                subjects.name, 'theory' as type, subjects.code,
                ac.class_code, ac.cohort_name
                FROM teacher_subjects
                INNER JOIN academic_subject subjects ON teacher_subjects.subject_id = subjects.id
                INNER JOIN academic_class ac ON teacher_subjects.class_id = ac.id
                INNER JOIN staff ON staff.id = teacher_subjects.teacher_id
                WHERE ac.id = " . $this->db->escape($class_id) . "
                AND teacher_subjects.session_id = " . $this->db->escape($this->current_session) . " " . $where;

        $query = $this->db->query($sql);
        if ($query === false) {
            return array();
        }
        return $query->result_array();
    }

    /**
     * Get teacher class subjects (TVET)
     * Replaces getTeacherClassSubjects() - uses academic_class
     *
     * @param int $teacher_id Staff ID
     * @return array Subject assignments for teacher
     */
    public function getTeacherClassSubjectsTVET($teacher_id)
    {
        $this->db->select('teacher_subjects.*, subjects.name, subjects.code,
                          ac.class_code, ac.cohort_name,
                          asub.name as subject_name, al.code as level_code', FALSE)
            ->from('teacher_subjects')
            ->join('academic_subject subjects', 'subjects.id = teacher_subjects.subject_id')
            ->join('academic_class ac', 'ac.id = teacher_subjects.class_id')
            ->join('academic_subject_level asl', 'asl.id = ac.subject_level_id')
            ->join('academic_subject asub', 'asub.id = asl.subject_id')
            ->join('academic_level al', 'al.id = asl.level_id')
            ->where('teacher_subjects.teacher_id', $teacher_id)
            ->where('teacher_subjects.session_id', $this->current_session);
        return $this->db->get()->result();
    }

    /**
     * Get detail by class (TVET)
     * Replaces getDetailByclassAndSection() - uses academic_class
     *
     * @param int $class_id academic_class.id
     * @return array Teacher subject details
     */
    public function getDetailByClassTVET($class_id)
    {
        $this->db->select()
            ->from('teacher_subjects')
            ->where('class_id', $class_id)
            ->where('teacher_subjects.session_id', $this->current_session);
        return $this->db->get()->result_array();
    }

}
