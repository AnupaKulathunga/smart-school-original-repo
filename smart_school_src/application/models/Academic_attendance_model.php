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
}
