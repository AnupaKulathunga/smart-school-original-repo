<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class StudentAttendaceSetting_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * TVET: Uses class + subject_level + subjects + level instead of class_sections + classes + sections.
     * class.id is used as the class_section_id equivalent for schedule lookups.
     */
    public function getClassWiseAttendanceSetting($class_id = null)
    {
        $condition = "";

        if ($class_id != null) {
            $condition = " AND class.id = " . $this->db->escape($class_id);
        }

        $sql = "SELECT class.id, class.id as class_section_id, class.class_code,
                subjects.name as subject_name, level.name as level_name,
                CONCAT(subjects.name, ' - ', level.name) as `class`,
                '' as `section`,
                student_attendence_schedules.class_section_id as sched_class_section_id,
                student_attendence_schedules.attendence_type_id,
                student_attendence_schedules.id as `student_attendence_schedule_id`,
                student_attendence_schedules.entry_time_from,
                student_attendence_schedules.entry_time_to,
                student_attendence_schedules.total_institute_hour
            FROM `class`
            INNER JOIN subject_level ON class.subject_level_id = subject_level.id
            INNER JOIN subjects ON subject_level.subject_id = subjects.id
            INNER JOIN level ON subject_level.level_id = level.id
            LEFT JOIN student_attendence_schedules ON student_attendence_schedules.class_section_id = class.id
            WHERE class.is_active = 1
            $condition";

        $query = $this->db->query($sql);
        return $query->result();
    }

    public function add($insert_array = [], $class_section_array = []){

        if (!empty($class_section_array)) {
            $this->db->where_in('class_section_id', array_unique($class_section_array));
            $this->db->delete('student_attendence_schedules');
        }
        if (!empty($insert_array)) {
            $this->db->insert_batch('student_attendence_schedules', $insert_array);
        }
    }


    /**
     * TVET: Uses class + subject_level instead of class_sections + classes + sections.
     * section_id kept for signature compatibility but ignored.
     * class.id is used as the class_section_id equivalent.
     */
    public function getClassWiseAttendanceSettingByClassAndSection($class_id, $section_id = null)
    {
        $sql = "SELECT student_attendence_schedules.*,
                class.id as class_id,
                CONCAT(subjects.name, ' - ', level.name) as `class`,
                subjects.name as subject_name, level.name as level_name,
                '' as section_id, '' as section
            FROM `student_attendence_schedules`
            INNER JOIN class ON class.id = student_attendence_schedules.class_section_id
            INNER JOIN subject_level ON class.subject_level_id = subject_level.id
            INNER JOIN subjects ON subject_level.subject_id = subjects.id
            INNER JOIN level ON subject_level.level_id = level.id
            WHERE class.id = " . $this->db->escape($class_id);

        $query = $this->db->query($sql);
        return $query->result();
    }


    /**
     * TVET: class_section_id now maps to class.id. The student_attendence_schedules table
     * stores class.id in the class_section_id column for TVET classes.
     */
    public function getAttendanceTypeByClassAndSectionTime($class_section_id, $time)
    {
        $sql = "SELECT * FROM `student_attendence_schedules` WHERE class_section_id=" . $this->db->escape($class_section_id) . " and " . $this->db->escape($time) . " BETWEEN entry_time_from and entry_time_to";

        $qusery = $this->db->query($sql);
        $return_result = $qusery->row();

        if ($qusery->num_rows() == 0) {
            return false;
        } else {
            $return_result = $qusery->row();
            return $return_result;
        }
    }

    /**
     * TVET: class_section_id now maps to class.id. Debug version.
     */
    public function getAttendanceTypeByClassAndSectionTime2($class_section_id, $time)
    {
        $sql = "SELECT * FROM `student_attendence_schedules` WHERE class_section_id=" . $this->db->escape($class_section_id) . " and " . $this->db->escape($time) . " BETWEEN entry_time_from and entry_time_to";

        $qusery = $this->db->query($sql);
        $return_result = $qusery->row();

        if ($qusery->num_rows() == 0) {
            return false;
        } else {
            $return_result = $qusery->row();
            return $return_result;
        }
    }

    /**
     * Get attendance settings per academic class (TVET)
     * Replaces getClassWiseAttendanceSetting() - no sections, uses academic_class
     *
     * @param int|null $class_id Optional academic_class.id to filter
     * @return array Attendance settings keyed by class
     */
    public function getClassWiseAttendanceSettingTVET($class_id = null)
    {
        $this->db->select('ac.id as class_id,
            CONCAT(asub.name, " - ", al.name,
                   IF(ac.cohort_name IS NOT NULL AND ac.cohort_name != "",
                      CONCAT(" (", ac.cohort_name, ")"),
                      "")
            ) as class,
            ac.class_code, ac.cohort_name,
            asub.name as subject_name, al.name as level_name,
            sas.id as student_attendence_schedule_id,
            sas.attendence_type_id, sas.entry_time_from, sas.entry_time_to,
            sas.total_institute_hour, sas.class_section_id', FALSE)
            ->from('academic_class ac')
            ->join('academic_subject_level asl', 'ac.subject_level_id = asl.id')
            ->join('academic_subject asub', 'asl.subject_id = asub.id')
            ->join('academic_level al', 'asl.level_id = al.id')
            ->join('student_attendence_schedules sas', 'sas.class_section_id = ac.id', 'left')
            ->where('ac.is_active', 1)
            ->where('ac.session_id', $this->setting_model->getCurrentSession());

        if ($class_id != null) {
            $this->db->where('ac.id', $class_id);
        }

        $this->db->order_by('asub.name, al.name, ac.cohort_name');

        $query = $this->db->get();
        return $query->result();
    }

    // ========================================================================
    // TVET METHODS - Uses class_id only (no class_section_id)
    // ========================================================================

    /**
     * Get attendance settings by class ID (TVET)
     * Replaces getClassWiseAttendanceSettingByClassAndSection
     *
     * @param int $class_id Class ID
     * @return array Attendance settings
     */
    public function getClassWiseAttendanceSettingByClass($class_id)
    {
        $this->db->select('student_attendence_schedules.*,
            class.id as class_id, class.class_code,
            subjects.name as subject_name, level.name as level_name')
            ->from('student_attendence_schedules')
            ->join('class', 'class.id = student_attendence_schedules.class_id')
            ->join('subject_level', 'class.subject_level_id = subject_level.id')
            ->join('subjects', 'subject_level.subject_id = subjects.id')
            ->join('level', 'subject_level.level_id = level.id')
            ->where('class.id', $class_id);

        $query = $this->db->get();
        return $query->result();
    }

    /**
     * Get attendance type by class ID and time (TVET)
     *
     * @param int $class_id Class ID
     * @param string $time Time to check
     * @return object|false Attendance setting or false
     */
    public function getAttendanceTypeByClassTime($class_id, $time)
    {
        $this->db->select('*')
            ->from('student_attendence_schedules')
            ->where('class_id', $class_id)
            ->where("'{$time}' BETWEEN entry_time_from AND entry_time_to");

        $query = $this->db->get();

        if ($query->num_rows() == 0) {
            return false;
        } else {
            return $query->row();
        }
    }
}
