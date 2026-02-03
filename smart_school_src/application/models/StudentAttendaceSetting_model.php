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

    public function getClassWiseAttendanceSetting($class_id=null)
    {
        $condition="";

        if($class_id!=null){
            $condition=" and class_sections.class_id=$class_id";
        }

        $sql = "SELECT class_sections.*,classes.class,sections.section,student_attendence_schedules.class_section_id,student_attendence_schedules.attendence_type_id,student_attendence_schedules.id as `student_attendence_schedule_id`,entry_time_from,entry_time_to,student_attendence_schedules.total_institute_hour  FROM `class_sections` INNER JOIN classes on classes.id=class_sections.class_id INNER JOIN sections on sections.id=class_sections.section_id LEFT JOIN student_attendence_schedules on student_attendence_schedules.class_section_id=class_sections.id where 0=0 
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


    public function getClassWiseAttendanceSettingByClassAndSection($class_id, $section_id)
    {
        $sql = "SELECT student_attendence_schedules.*,classes.id as class_id,classes.class,sections.id as section_id,sections.section FROM `student_attendence_schedules` INNER JOIN class_sections on class_sections.id=student_attendence_schedules.class_section_id INNER JOIN classes on classes.id=class_sections.class_id INNER JOIN sections on sections.id=class_sections.section_id WHERE classes.id=" . $this->db->escape($class_id) . " and sections.id=" . $this->db->escape($section_id);

        $query = $this->db->query($sql);
        return $query->result();
    }


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



    public function getAttendanceTypeByClassAndSectionTime2($class_section_id, $time)
    {
        $sql = "SELECT * FROM `student_attendence_schedules` WHERE class_section_id=" . $this->db->escape($class_section_id) . " and " . $this->db->escape($time) . " BETWEEN entry_time_from and entry_time_to";

        $qusery = $this->db->query($sql);
        $return_result = $qusery->row();
   
        if ($qusery->num_rows() == 0) {
       echo $sql;
       echo "sdfsdfsdf";
            return false;
        } else {
            $return_result = $qusery->row();
            return $return_result;
        }
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
