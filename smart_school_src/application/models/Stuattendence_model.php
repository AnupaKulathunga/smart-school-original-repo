<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Stuattendence_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
        $this->current_date = $this->setting_model->getDateYmd();
    }

    /**
     * Add or update attendance
     * Uses enrolment_id from academic_class_enrolment
     */
    public function addorUpdate($attendances)
    {
        $this->db->trans_start();
        $this->db->trans_strict(false);

        if(!empty($attendances)){
            foreach ($attendances as $attendance_key => $attendance_value) {
                if (!isset($attendance_value['enrolment_id'])) {
                    continue;
                }
                $this->db->where('enrolment_id', $attendance_value['enrolment_id']);

                $this->db->where('date', $attendance_value['date']);
                $query = $this->db->get('student_attendences');

                if ($query->num_rows() > 0) {
                    $this->db->where('id', $query->row()->id);
                    $this->db->update('student_attendences', $attendance_value);
                } else {
                    $this->db->insert('student_attendences', $attendance_value);
                }
            }
        }

        $this->db->trans_complete();

        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            $this->db->trans_commit();
            return true;
        }
    }

    public function batch_insert($data)
    {
        $this->db->insert_batch('student_attendences', $data);
    }

    public function get($id = null)
    {
        $this->db->select()->from('student_attendences');
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
     * Online attendance (biometric/QR) - TVET version
     * Uses enrolment_id
     */
    public function onlineattendence($data, $class_id)
    {
        $status = false;
        if (!isset($data['enrolment_id'])) {
            return false;
        }
        $this->db->where('enrolment_id', $data['enrolment_id']);
        $this->db->where('date', $data['date']);
        $q = $this->db->get('student_attendences');
        $time = date('H:i:s');

        if ($q->num_rows() == 0) {
            $attendance_range = $this->studentAttendaceSetting_model->getAttendanceTypeByClassAndSectionTime($class_id, $time);
            if ($attendance_range) {
                $data['attendence_type_id'] = $attendance_range->attendence_type_id;
                $this->db->insert('student_attendences', $data);
                $status = 1;

                $enrol_id = $data['enrolment_id'];
                $present_student_list['student_sessions_id'][$enrol_id] = $enrol_id;
                $this->mailsmsconf->mailsms('student_present_attendence', $present_student_list, $data['date']);
            } else {
                $status = 2;
            }
        } else {
            $return_result = $q->row();
            $status = 0;
        }
        return $status;
    }

    /**
     * Student schedule hours lookup by class_id
     */
    public function student_schedule_hours($class_id, $in_time)
    {
        $sql = "SELECT * FROM `student_attendence_schedules` WHERE class_section_id = " . $this->db->escape($class_id);

        $current_time = date('H:i:s');
        $query = $this->db->query($sql);
        if ($query->num_rows() > 0) {

            $return_attedance_type = false;
            $time_entry_seconds = strtotime("1970-01-01 $in_time UTC");
            $time_current_seconds = strtotime("1970-01-01 $current_time UTC");
            $total_spend_time = $time_current_seconds - $time_entry_seconds;

            $result = $query->result();
            $find_array = array();

            foreach ($result as $result_key => $result_value) {
                $entry_time_from_seconds = strtotime("1970-01-01 $result_value->entry_time_from UTC");
                $entry_time_to_seconds = strtotime("1970-01-01 $result_value->entry_time_to UTC");

                if ($entry_time_from_seconds <= $time_entry_seconds && $entry_time_to_seconds >= $time_entry_seconds) {
                    $find_array[] = array(
                        'attendence_type_id' => $result_value->attendence_type_id,
                        'time_schedule_seconds' => strtotime("1970-01-01 $result_value->total_institute_hour UTC")
                    );
                }
            }

            if (count($find_array) > 1) {
                if ($total_spend_time < $find_array[0]['time_schedule_seconds'] && $total_spend_time > $find_array[1]['time_schedule_seconds']) {
                    $return_attedance_type = $find_array[1]['attendence_type_id'];
                }
            }

            return $return_attedance_type;
        } else {
            return false;
        }
    }

    public function add($insert_array, $update_array)
    {
        $this->db->trans_start();
        $this->db->trans_strict(false);
        if (!empty($insert_array)) {
            $this->db->insert_batch('student_attendences', $insert_array);
        }
        if (!empty($update_array)) {
            $this->db->update_batch('student_attendences', $update_array, 'id');
        }
        $this->db->trans_complete();

        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            $this->db->trans_commit();
            return true;
        }
    }

    /**
     * Search attendance by class. section_id kept for signature compatibility but ignored.
     */
    public function searchAttendenceClassSection($class_id, $section_id, $date)
    {
        $sql = "SELECT student_sessions.attendence_id,
                students.firstname, students.middlename, students.lastname,
                student_sessions.date, student_sessions.remark,
                students.roll_no, students.admission_no, students.id as std_id,
                student_sessions.attendence_type_id, student_sessions.id as student_session_id,
                attendence_type.type as `att_type`, attendence_type.key_value as `key`,
                attendence_type.long_lang_name, attendence_type.long_name_style
            FROM students, (
                SELECT ace.id, ace.student_id,
                    IFNULL(student_attendences.date, 'xxx') as date,
                    student_attendences.remark,
                    IFNULL(student_attendences.id, 0) as attendence_id,
                    student_attendences.attendence_type_id
                FROM `academic_class_enrolment` ace
                INNER JOIN `academic_class` ac ON ace.class_id = ac.id
                LEFT JOIN student_attendences ON student_attendences.enrolment_id = ace.id
                    AND student_attendences.date = " . $this->db->escape($date) . "
                WHERE ac.session_id = " . $this->db->escape($this->current_session) . "
                    AND ace.class_id = " . $this->db->escape($class_id) . "
                    AND ace.status = 'Active'
            ) as student_sessions
            LEFT JOIN attendence_type ON attendence_type.id = student_sessions.attendence_type_id
            WHERE student_sessions.student_id = students.id
                AND students.is_active = 'yes'
            ORDER BY students.admission_no ASC";
        $query = $this->db->query($sql);
        return $query->result_array();
    }

    /**
     * Search attendance by class with mode filter. section_id kept for signature compatibility but ignored.
     */
    public function searchAttendenceClassSectionWithMode($class_id, $section_id, $date, $mode)
    {
        // Mode filtering not applicable without biometric columns; return standard results
        return $this->searchAttendenceClassSection($class_id, $section_id, $date);
    }

    /**
     * Search attendance report by class. section_id kept for signature compatibility but ignored.
     */
    public function searchAttendenceReport($class_id, $section_id, $date)
    {
        $sql = "SELECT student_sessions.attendence_id, students.firstname, students.middlename,
                student_sessions.date, student_sessions.remark,
                students.roll_no, students.admission_no, students.lastname,
                student_sessions.attendence_type_id, student_sessions.id as student_session_id,
                attendence_type.type as `att_type`, attendence_type.key_value as `key`
            FROM students, (
                SELECT ace.id, ace.student_id,
                    IFNULL(student_attendences.date, 'xxx') as date,
                    student_attendences.remark,
                    IFNULL(student_attendences.id, 0) as attendence_id,
                    student_attendences.attendence_type_id
                FROM `academic_class_enrolment` ace
                INNER JOIN `academic_class` ac ON ace.class_id = ac.id
                LEFT JOIN student_attendences ON student_attendences.enrolment_id = ace.id
                    AND student_attendences.date = " . $this->db->escape($date) . "
                WHERE ac.session_id = " . $this->db->escape($this->current_session) . "
                    AND ace.class_id = " . $this->db->escape($class_id) . "
                    AND ace.status = 'Active'
            ) as student_sessions
            LEFT JOIN attendence_type ON attendence_type.id = student_sessions.attendence_type_id
            WHERE student_sessions.student_id = students.id
                AND students.is_active = 'yes'";
        $query = $this->db->query($sql);
        return $query->result_array();
    }

    /**
     * Search attendance prepare by class. section_id kept for signature compatibility but ignored.
     */
    public function searchAttendenceClassSectionPrepare($class_id, $section_id, $date)
    {
        $query = $this->db->query("SELECT student_sessions.attendence_id, student_sessions.remark,
                students.id as std_id, students.firstname, students.middlename,
                students.admission_no, student_sessions.date, students.roll_no, students.lastname,
                student_sessions.attendence_type_id, student_sessions.id as student_session_id
            FROM students, (
                SELECT ace.id, ace.student_id,
                    IFNULL(student_attendences.date, 'xxx') as date,
                    student_attendences.remark,
                    IFNULL(student_attendences.id, 0) as attendence_id,
                    student_attendences.attendence_type_id
                FROM `academic_class_enrolment` ace
                INNER JOIN `academic_class` ac ON ace.class_id = ac.id
                RIGHT JOIN student_attendences ON student_attendences.enrolment_id = ace.id
                    AND student_attendences.date = " . $this->db->escape($date) . "
                WHERE ac.session_id = " . $this->db->escape($this->current_session) . "
                    AND ace.class_id = " . $this->db->escape($class_id) . "
                    AND ace.status = 'Active'
            ) as student_sessions
            WHERE student_sessions.student_id = students.id");
        return $query->result_array();
    }

    /**
     * Count attendance by month for enrolment_id
     */
    public function count_attendance_obj($month, $year, $student_id, $attendance_type = 1)
    {
        $query = $this->db->select('count(*) as attendence', FALSE)
            ->where(array(
                'student_attendences.enrolment_id' => $student_id,
                'month(date)' => $month,
                'year(date)' => $year,
                'student_attendences.attendence_type_id' => $attendance_type
            ))
            ->get("student_attendences");
        return $query->row()->attendence;
    }

    public function attendanceYearCount()
    {
        $query = $this->db->select("distinct year(date) as year")->get("student_attendences");
        return $query->result_array();
    }

    /**
     * Today's attendance summary across all active enrolments
     */
    public function getTodayDayAttendance($total_student)
    {
        $query = $this->db->query("SELECT
            CONCAT(ROUND((SUM(CASE WHEN `attendence_type_id`=1 THEN 1 ELSE 0 END)*100/" . $total_student . "),2),'%') as present,
            CONCAT(ROUND((SUM(CASE WHEN `attendence_type_id`=3 THEN 1 ELSE 0 END)*100/" . $total_student . "),2),'%') as late,
            CONCAT(ROUND((SUM(CASE WHEN `attendence_type_id`=4 THEN 1 ELSE 0 END)*100/" . $total_student . "),2),'%') as absent,
            CONCAT(ROUND((SUM(CASE WHEN `attendence_type_id`=6 THEN 1 ELSE 0 END)*100/" . $total_student . "),2),'%') as half_day,
            SUM(CASE WHEN `attendence_type_id`=1 THEN 1 ELSE 0 END) as total_present,
            SUM(CASE WHEN `attendence_type_id`=3 THEN 1 ELSE 0 END) as total_late,
            SUM(CASE WHEN `attendence_type_id`=4 THEN 1 ELSE 0 END) as total_absent,
            SUM(CASE WHEN `attendence_type_id`=6 THEN 1 ELSE 0 END) as total_half_day
            FROM `student_attendences`
            INNER JOIN `academic_class_enrolment` ace ON student_attendences.enrolment_id = ace.id
            INNER JOIN `academic_class` ac ON ace.class_id = ac.id
            WHERE DATE_FORMAT(date,'%Y-%m-%d') = '" . date('Y-m-d') . "'
                AND ac.session_id = '" . $this->current_session . "'
                AND ace.status = 'Active'");
        return $query->row_array();
    }

    /**
     * Get student attendances with class info for reports
     */
    public function student_attendences($condition, $date_condition)
    {
        $query = $this->db->query("SELECT
                ac.id AS class_id, students.id,
                ac.class_code as `class`,
                asubj.name as subject_name, al.name as level_name,
                students.id, students.admission_no, students.roll_no,
                students.admission_date, students.firstname, students.middlename,
                students.lastname, students.image, students.mobileno,
                students.email, students.state, students.city,
                students.pincode, students.religion, students.dob,
                students.current_address, students.adhar_no, students.samagra_id,
                students.bank_account_no, students.bank_name, students.ifsc_code,
                students.father_name, students.guardian_name, students.guardian_relation,
                students.guardian_phone, students.guardian_address, students.is_active,
                students.created_at, students.updated_at, students.gender,
                students.rte, ac.session_id, `date`,
                COUNT(student_attendences.id) as total_type
            FROM `student_attendences`
            INNER JOIN `academic_class_enrolment` ace ON ace.id = student_attendences.enrolment_id
            INNER JOIN `students` ON ace.student_id = students.id
            JOIN `academic_class` ac ON ace.class_id = ac.id
            JOIN `academic_subject_level` asl ON ac.subject_level_id = asl.id
            JOIN `academic_subject` asubj ON asl.subject_id = asubj.id
            JOIN `academic_level` al ON asl.level_id = al.id
            LEFT JOIN `categories` ON students.category_id = categories.id
            WHERE ac.session_id = '" . $this->current_session . "'
                AND ace.status = 'Active'
                AND students.is_active = 'yes' " . $condition . "
            GROUP BY students.id
            ORDER BY students.id");
        return $query->result_array();
    }

    public function checkholidatbydate($date)
    {
        $where['attendence_type_id'] = '5';
        $where['date'] = date('Y-m-d', strtotime($date));
        $query = $this->db->select('count(*) as day ')->where($where)->get('student_attendences')->row_array();
        return $query['day'];
    }

    /**
     * Biometric attendance log
     */
    public function biometric_attlog($limit = null, $offset = NULL)
    {
        return $this->db->select('student_attendences.*, CONCAT_WS(students.firstname," ",students.lastname) as name, students.firstname, students.middlename, students.lastname, students.roll_no', FALSE)
            ->from('student_attendences')
            ->join('academic_class_enrolment ace', 'ace.id = student_attendences.enrolment_id', 'left')
            ->join('students', 'ace.student_id = students.id', 'left')
            ->limit($limit, $offset)
            ->get()->result_array();
    }

    public function biometric_attlogcount()
    {
        $count = $this->db->select('count(*) as total', FALSE)->from('student_attendences')->get()->row_array();
        return $count['total'];
    }

    /**
     * Get attendance summary by date grouped by class
     */
    public function get_attendancebydate($date)
    {
        $sql = 'SELECT ac.class_code as class_name, ac.id as class_id,
                asubj.name as subject_name, al.name as level_name,
                SUM(CASE WHEN `attendence_type_id` = 1 THEN 1 ELSE 0 END) AS "present",
                SUM(CASE WHEN `attendence_type_id` = 2 THEN 1 ELSE 0 END) AS "excuse",
                SUM(CASE WHEN `attendence_type_id` = 4 THEN 1 ELSE 0 END) AS "absent",
                SUM(CASE WHEN `attendence_type_id` = 3 THEN 1 ELSE 0 END) AS "late",
                SUM(CASE WHEN `attendence_type_id` = 6 THEN 1 ELSE 0 END) AS "half_day"
            FROM `student_attendences`
            JOIN `academic_class_enrolment` ace ON student_attendences.enrolment_id = ace.id
            INNER JOIN `academic_class` ac ON ace.class_id = ac.id
            INNER JOIN `academic_subject_level` asl ON ac.subject_level_id = asl.id
            INNER JOIN `academic_subject` asubj ON asl.subject_id = asubj.id
            INNER JOIN `academic_level` al ON asl.level_id = al.id
            WHERE 1
                AND ac.session_id = ' . $this->current_session . '
                AND ace.status = \'Active\' ' . $date . '
            GROUP BY ac.id';

        $query = $this->db->query($sql);
        $result = $query->result();
        foreach ($result as $key => $sectionList_value) {
            $classid = $sectionList_value->class_id;

            $result[$key]->male_present   = count($this->getmalefemalecount($classid, null, $date, "Male", "in(1,2,3,6)"));
            $result[$key]->female_present = count($this->getmalefemalecount($classid, null, $date, "Female", "in(1,2,3,6)"));
            $result[$key]->male_absent    = count($this->getmalefemalecount($classid, null, $date, "Male", "in(4)"));
            $result[$key]->female_absent  = count($this->getmalefemalecount($classid, null, $date, "Female", "in(4)"));
        }
        return $result;
    }

    /**
     * Get male/female attendance counts by class. section_id kept for signature compatibility.
     */
    public function getmalefemalecount($class_id, $section_id, $date, $gender, $type)
    {
        $sql = "SELECT student_sessions.attendence_id,
                students.firstname, students.middlename, students.lastname,
                student_sessions.date, student_sessions.remark,
                students.roll_no, students.admission_no, students.id as std_id,
                student_sessions.attendence_type_id, student_sessions.id as student_session_id,
                attendence_type.type as `att_type`, attendence_type.key_value as `key`,
                attendence_type.long_lang_name, attendence_type.long_name_style
            FROM students, (
                SELECT ace.id, ace.student_id,
                    IFNULL(student_attendences.date, 'xxx') as date,
                    student_attendences.remark,
                    IFNULL(student_attendences.id, 0) as attendence_id,
                    student_attendences.attendence_type_id
                FROM `academic_class_enrolment` ace
                INNER JOIN `academic_class` ac ON ace.class_id = ac.id
                LEFT JOIN student_attendences ON student_attendences.enrolment_id = ace.id
                    " . $date . " AND student_attendences.attendence_type_id " . $type . "
                WHERE student_attendences.attendence_type_id != ''
                    AND ac.session_id = " . $this->db->escape($this->current_session) . "
                    AND ace.class_id = " . $this->db->escape($class_id) . "
                    AND ace.status = 'Active'
            ) as student_sessions
            LEFT JOIN attendence_type ON attendence_type.id = student_sessions.attendence_type_id
            WHERE student_sessions.student_id = students.id
                AND students.is_active = 'yes'
                AND students.gender = '$gender'
            GROUP BY students.id
            ORDER BY students.admission_no ASC";
        $query = $this->db->query($sql);
        return $query->result_array();
    }

    /**
     * Get student attendance for a specific date and enrolment_id
     */
    public function studentattendance($date, $enrolment_id)
    {
        $sql = "SELECT student_attendences.*, ace.student_id,
                attendence_type.type as `att_type`, attendence_type.key_value as `key`
            FROM student_attendences
            JOIN academic_class_enrolment ace ON ace.id = student_attendences.enrolment_id
            LEFT JOIN attendence_type ON attendence_type.id = student_attendences.attendence_type_id
            WHERE student_attendences.enrolment_id = " . $this->db->escape($enrolment_id) . "
                AND student_attendences.date = " . $this->db->escape($date);

        $query = $this->db->query($sql);
        if ($query->num_rows() > 0) {
            return $query->row_array();
        }
        return false;
    }

    /**
     * Count student attendance by year and enrolment_id
     */
    public function studentattendancecount($year, $enrolment_id, $att_type)
    {
        $query = $this->db->select('count(*) as attendence', FALSE)
            ->where('student_attendences.enrolment_id', $enrolment_id)
            ->where('year(date)', $year)
            ->where('student_attendences.attendence_type_id', $att_type)
            ->get("student_attendences");
        return $query->row()->attendence;
    }

    /**
     * Get student attendance between dates for an enrolment_id
     */
    public function student_attendence_bw_date($date_from, $date_to, $enrolment_id)
    {
        $query = $this->db->select('student_attendences.*, attendence_type.type as `att_type`, attendence_type.key_value as `key`')
            ->join('academic_class_enrolment ace', 'ace.id = student_attendences.enrolment_id')
            ->join('attendence_type', 'attendence_type.id = student_attendences.attendence_type_id')
            ->where('student_attendences.enrolment_id', $enrolment_id)
            ->where("date BETWEEN '{$date_from}' AND '{$date_to}'")
            ->get("student_attendences");

        return $query->result();
    }

    // ========================================================================
    // TVET METHODS - Uses enrolment_id from academic_class_enrolment
    // ========================================================================

    /**
     * Get attendance for all students in a class on a specific date
     */
    public function getAttendanceByClass($class_id, $date)
    {
        $query = $this->db->select('students.*, students.id as student_id,
            ace.id as enrolment_id, ace.status as enrolment_status,
            student_attendences.*, student_attendences.id as attendance_id,
            attendence_type.type as attendence_type, attendence_type.key_value,
            ac.class_code, ac.cohort_name,
            asubj.name as subject_name, al.name as level_name', FALSE)
            ->from('academic_class_enrolment ace')
            ->join('students', 'ace.student_id = students.id')
            ->join('academic_class ac', 'ace.class_id = ac.id')
            ->join('academic_subject_level asl', 'ac.subject_level_id = asl.id')
            ->join('academic_subject asubj', 'asl.subject_id = asubj.id')
            ->join('academic_level al', 'asl.level_id = al.id')
            ->join('student_attendences', 'student_attendences.enrolment_id = ace.id
                AND student_attendences.date = "' . $this->db->escape_str($date) . '"', 'left')
            ->join('attendence_type', 'student_attendences.attendence_type_id = attendence_type.id', 'left')
            ->where('ac.id', $class_id)
            ->where('ace.status', 'Active')
            ->where('students.is_active', 'yes')
            ->order_by('students.firstname, students.lastname')
            ->get();

        return $query->result_array();
    }

    /**
     * Add or update attendance (TVET version)
     * Uses enrolment_id from academic_class_enrolment
     */
    public function addorUpdateTVET($attendances)
    {
        $this->db->trans_start();
        $this->db->trans_strict(false);

        if (!empty($attendances)) {
            foreach ($attendances as $attendance_key => $attendance_value) {
                if (!isset($attendance_value['enrolment_id'])) {
                    continue;
                }
                $this->db->where('enrolment_id', $attendance_value['enrolment_id']);

                $this->db->where('date', $attendance_value['date']);
                $query = $this->db->get('student_attendences');

                if ($query->num_rows() > 0) {
                    $this->db->where('id', $query->row()->id);
                    $this->db->update('student_attendences', $attendance_value);
                } else {
                    $this->db->insert('student_attendences', $attendance_value);
                }
            }
        }

        $this->db->trans_complete();

        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            $this->db->trans_commit();
            return true;
        }
    }

    /**
     * Get student attendance by enrolment ID
     */
    public function getAttendanceByEnrolment($enrolment_id, $date_from = null, $date_to = null)
    {
        $this->db->select('student_attendences.*, attendence_type.type as att_type, attendence_type.key_value as key')
            ->from('student_attendences')
            ->join('attendence_type', 'attendence_type.id = student_attendences.attendence_type_id')
            ->where('student_attendences.enrolment_id', $enrolment_id);

        if ($date_from && $date_to) {
            $this->db->where("date BETWEEN '{$date_from}' AND '{$date_to}'");
        }

        $query = $this->db->get();
        return $query->result();
    }

    /**
     * Search attendance by class only with mode filter
     */
    public function searchAttendenceClassWithMode($class_id, $date, $mode = null)
    {
        $sql = "SELECT
                    students.firstname, students.middlename, students.lastname,
                    students.roll_no, students.admission_no, students.id as std_id,
                    ace.id as enrolment_id,
                    IFNULL(student_attendences.id, 0) as attendence_id,
                    IFNULL(student_attendences.date, 'xxx') as date,
                    student_attendences.remark,
                    student_attendences.attendence_type_id,
                    attendence_type.type as att_type,
                    attendence_type.key_value as `key`,
                    attendence_type.long_lang_name,
                    attendence_type.long_name_style
                FROM students
                INNER JOIN `academic_class_enrolment` ace ON ace.student_id = students.id
                    AND ace.class_id = " . $this->db->escape($class_id) . "
                    AND ace.status = 'Active'
                INNER JOIN `academic_class` ac ON ace.class_id = ac.id
                    AND ac.session_id = " . $this->db->escape($this->current_session) . "
                LEFT JOIN student_attendences ON student_attendences.enrolment_id = ace.id
                    AND student_attendences.date = " . $this->db->escape($date) . "
                LEFT JOIN attendence_type ON attendence_type.id = student_attendences.attendence_type_id
                WHERE students.is_active = 'yes'
                ORDER BY students.admission_no ASC";

        $query = $this->db->query($sql);
        return $query->result_array();
    }

    /**
     * Search attendance report by class only
     */
    public function searchAttendenceReportByClass($class_id, $date)
    {
        $sql = "SELECT
                    students.firstname, students.middlename, students.lastname,
                    students.roll_no, students.admission_no,
                    ace.id as enrolment_id,
                    IFNULL(student_attendences.id, 0) as attendence_id,
                    IFNULL(student_attendences.date, 'xxx') as date,
                    student_attendences.remark,
                    student_attendences.attendence_type_id,
                    attendence_type.type as att_type,
                    attendence_type.key_value as `key`
                FROM students
                INNER JOIN `academic_class_enrolment` ace ON ace.student_id = students.id
                    AND ace.class_id = " . $this->db->escape($class_id) . "
                    AND ace.status = 'Active'
                INNER JOIN `academic_class` ac ON ace.class_id = ac.id
                    AND ac.session_id = " . $this->db->escape($this->current_session) . "
                LEFT JOIN student_attendences ON student_attendences.enrolment_id = ace.id
                    AND student_attendences.date = " . $this->db->escape($date) . "
                LEFT JOIN attendence_type ON attendence_type.id = student_attendences.attendence_type_id
                WHERE students.is_active = 'yes'
                ORDER BY students.admission_no ASC";

        $query = $this->db->query($sql);
        return $query->result_array();
    }

    /**
     * Count attendance by month for a specific enrolment
     */
    public function count_attendance_by_enrolment($month, $year, $enrolment_id, $attendance_type = 1)
    {
        $query = $this->db->select('count(*) as attendence', FALSE)
            ->where(array(
                'enrolment_id' => $enrolment_id,
                'month(date)' => $month,
                'year(date)' => $year,
                'attendence_type_id' => $attendance_type
            ))
            ->get("student_attendences");
        return $query->row()->attendence;
    }
}
