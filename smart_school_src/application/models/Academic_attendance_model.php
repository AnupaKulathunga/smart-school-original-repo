<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Academic Attendance Model
 * Manages daily attendance per class
 */
class Academic_attendance_model extends CI_Model
{
    private $table = 'academic_attendance';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get attendance records for a class on a specific date
     */
    public function getByClassDate($class_id, $date)
    {
        return $this->db->select('a.*, e.student_id,
                                  s.admission_no, s.firstname, s.lastname')
            ->from($this->table . ' a')
            ->join('academic_class_enrolment e', 'e.id = a.enrolment_id')
            ->join('students s', 's.id = e.student_id')
            ->where('a.class_id', $class_id)
            ->where('a.date', $date)
            ->order_by('s.lastname', 'ASC')
            ->order_by('s.firstname', 'ASC')
            ->get()->result();
    }

    /**
     * Get existing attendance as associative array (enrolment_id => status)
     */
    public function getExistingAttendance($class_id, $date)
    {
        $result = array();
        $records = $this->db->select('enrolment_id, status, notes')
            ->where('class_id', $class_id)
            ->where('attendance_date', $date)
            ->get($this->table)->result();

        foreach ($records as $r) {
            $result[$r->enrolment_id] = array(
                'status' => $r->status,
                'notes' => $r->notes
            );
        }

        return $result;
    }

    /**
     * Mark attendance for a student
     */
    public function mark($data)
    {
        // Check if record exists
        $existing = $this->db->where('enrolment_id', $data['enrolment_id'])
            ->where('attendance_date', $data['attendance_date'])
            ->get($this->table)->row();

        $record_data = array(
            'class_id' => $data['class_id'],
            'enrolment_id' => $data['enrolment_id'],
            'attendance_date' => $data['attendance_date'],
            'status' => $data['status'],
            'notes' => isset($data['notes']) ? $data['notes'] : null,
            'marked_by' => isset($data['marked_by']) ? $data['marked_by'] : null
        );

        if ($existing) {
            // Update existing record
            return $this->db->where('id', $existing->id)->update($this->table, $record_data);
        } else {
            // Insert new record
            return $this->db->insert($this->table, $record_data);
        }
    }

    /**
     * Bulk mark attendance for a class
     */
    public function bulkMark($class_id, $date, $attendance_data, $marked_by = null)
    {
        foreach ($attendance_data as $enrolment_id => $status) {
            $this->mark(array(
                'class_id' => $class_id,
                'enrolment_id' => $enrolment_id,
                'attendance_date' => $date,
                'status' => $status,
                'marked_by' => $marked_by
            ));
        }
        return true;
    }

    /**
     * Get student's attendance for a class
     */
    public function getStudentAttendance($enrolment_id)
    {
        return $this->db->where('enrolment_id', $enrolment_id)
            ->order_by('attendance_date', 'DESC')
            ->get($this->table)->result();
    }

    /**
     * Get student's attendance summary for a class
     */
    public function getStudentSummary($enrolment_id)
    {
        $summary = new stdClass();

        $stats = $this->db->select('
            COUNT(*) as total,
            SUM(CASE WHEN status = "Present" THEN 1 ELSE 0 END) as present,
            SUM(CASE WHEN status = "Absent" THEN 1 ELSE 0 END) as absent,
            SUM(CASE WHEN status = "Late" THEN 1 ELSE 0 END) as late,
            SUM(CASE WHEN status = "Excused" THEN 1 ELSE 0 END) as excused')
            ->where('enrolment_id', $enrolment_id)
            ->get($this->table)->row();

        $summary->total = $stats->total ?: 0;
        $summary->present = $stats->present ?: 0;
        $summary->absent = $stats->absent ?: 0;
        $summary->late = $stats->late ?: 0;
        $summary->excused = $stats->excused ?: 0;
        $summary->percentage = $summary->total > 0
            ? round((($summary->present + $summary->late) / $summary->total) * 100, 1)
            : 0;

        return $summary;
    }

    /**
     * Get class attendance summary for a date range
     */
    public function getClassSummary($class_id, $start_date = null, $end_date = null)
    {
        $this->db->select('
            COUNT(DISTINCT date) as total_days,
            COUNT(*) as total_records,
            SUM(CASE WHEN status = "Present" THEN 1 ELSE 0 END) as present,
            SUM(CASE WHEN status = "Absent" THEN 1 ELSE 0 END) as absent,
            SUM(CASE WHEN status = "Late" THEN 1 ELSE 0 END) as late,
            SUM(CASE WHEN status = "Excused" THEN 1 ELSE 0 END) as excused');
        $this->db->where('class_id', $class_id);

        if ($start_date) {
            $this->db->where('date >=', $start_date);
        }
        if ($end_date) {
            $this->db->where('date <=', $end_date);
        }

        $stats = $this->db->get($this->table)->row();

        $summary = new stdClass();
        $summary->total_days = $stats->total_days ?: 0;
        $summary->total_records = $stats->total_records ?: 0;
        $summary->present = $stats->present ?: 0;
        $summary->absent = $stats->absent ?: 0;
        $summary->late = $stats->late ?: 0;
        $summary->excused = $stats->excused ?: 0;
        $summary->attendance_rate = $summary->total_records > 0
            ? round((($summary->present + $summary->late) / $summary->total_records) * 100, 1)
            : 0;

        return $summary;
    }

    /**
     * Get attendance report by class and date
     */
    public function getReport($class_id, $start_date, $end_date)
    {
        return $this->db->select('a.date, a.status, a.notes,
                                  e.student_id, s.admission_no, s.firstname, s.lastname')
            ->from($this->table . ' a')
            ->join('academic_class_enrolment e', 'e.id = a.enrolment_id')
            ->join('students s', 's.id = e.student_id')
            ->where('a.class_id', $class_id)
            ->where('a.date >=', $start_date)
            ->where('a.date <=', $end_date)
            ->order_by('a.date', 'ASC')
            ->order_by('s.lastname', 'ASC')
            ->get()->result();
    }

    /**
     * Get dates with attendance marked for a class
     */
    public function getMarkedDates($class_id)
    {
        return $this->db->select('DISTINCT(date) as date', FALSE)
            ->where('class_id', $class_id)
            ->order_by('attendance_date', 'DESC')
            ->get($this->table)->result();
    }

    /**
     * Delete attendance for class and date
     */
    public function deleteByClassDate($class_id, $date)
    {
        return $this->db->where('class_id', $class_id)
            ->where('attendance_date', $date)
            ->delete($this->table);
    }

    /**
     * Alias for getStudentSummary - for student portal compatibility
     */
    public function getStudentAttendanceSummary($enrolment_id)
    {
        return $this->getStudentSummary($enrolment_id);
    }

    /**
     * Get student attendance for date range across all enrolments (for student portal calendar)
     * Returns attendance records with class info for calendar display
     *
     * @param int $student_id Student ID
     * @param string $start_date Start date (Y-m-d)
     * @param string $end_date End date (Y-m-d)
     * @param int|null $class_id Optional class_id to filter to specific class
     * @return array Attendance records
     */
    public function getStudentAttendanceRange($student_id, $start_date, $end_date, $class_id = null)
    {
        $this->db->select('a.*, a.attendance_date as date, c.class_code, c.cohort_name,
                          subj.name as subject_name, subj.code as subject_code,
                          l.code as level_code', FALSE);
        $this->db->from($this->table . ' a');
        $this->db->join('academic_class_enrolment e', 'e.id = a.enrolment_id');
        $this->db->join('student_session ss', 'ss.id = e.student_session_id');
        $this->db->join('academic_class c', 'c.id = a.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->where('ss.student_id', $student_id);
        $this->db->where('a.attendance_date >=', $start_date);
        $this->db->where('a.attendance_date <=', $end_date);

        if ($class_id) {
            $this->db->where('a.class_id', $class_id);
        }

        return $this->db->order_by('a.attendance_date', 'ASC')
            ->get()->result();
    }

    /**
     * Get student attendance for a specific date across all enrolled classes
     * Used for subject-based attendance view in student portal
     *
     * @param int $student_id Student ID
     * @param string $date Date (Y-m-d)
     * @return array Attendance records for all classes on that date
     */
    public function getStudentAttendanceByDate($student_id, $date)
    {
        $this->db->select('a.*, c.class_code, c.cohort_name, c.venue,
                          subj.name as subject_name, subj.code as subject_code,
                          l.code as level_code, l.name as level_name,
                          st.name as lecturer_name, st.surname as lecturer_surname', FALSE);
        $this->db->from($this->table . ' a');
        $this->db->join('academic_class_enrolment e', 'e.id = a.enrolment_id');
        $this->db->join('student_session ss', 'ss.id = e.student_session_id');
        $this->db->join('academic_class c', 'c.id = a.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->join('staff st', 'st.id = c.primary_lecturer_id', 'left');
        $this->db->where('ss.student_id', $student_id);
        $this->db->where('a.attendance_date', $date);

        return $this->db->order_by('subj.name', 'ASC')
            ->get()->result();
    }
}
