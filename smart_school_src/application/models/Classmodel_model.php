<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

/**
 * Classmodel Model (TVET CLASS - the central unit)
 * Named "Classmodel" to avoid conflict with legacy Class_model during transition
 * CLASS = Subject + Level + Cohort + Year + Lecturer
 *
 * This is the heart of the TVET-centric architecture.
 * After legacy cleanup, this can be renamed to Class_model.
 */
class Classmodel_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get class by ID with full details
     * @param int $class_id Class ID
     * @return object Class object with subject, level, lecturer details
     */
    public function getClassById($class_id)
    {
        // FIXED: Explicit column selection to avoid id column conflict
        $this->db->select('class.id as id,
            class.class_code, class.subject_level_id, class.cohort_name,
            class.academic_year, class.session_id, class.delivery_mode,
            class.primary_lecturer_id, class.status, class.is_active,
            class.max_students, class.min_students, class.start_date, class.end_date,
            subject_level.subject_id, subject_level.level_id,
            subjects.name as subject_name, subjects.code as subject_code, subjects.credits, subjects.notional_hours,
            level.name as level_name, level.code as level_code, level.level_type, level.nqf_level,
            staff.name as lecturer_name, staff.id as lecturer_id, staff.employee_id,
            sessions.session as session_name');
        $this->db->from('class');
        $this->db->join('subject_level', 'class.subject_level_id = subject_level.id');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->join('staff', 'class.primary_lecturer_id = staff.id', 'left');
        $this->db->join('sessions', 'class.session_id = sessions.id');
        $this->db->where('class.id', $class_id);
        return $this->db->get()->row();
    }

    /**
     * Get classes by session with optional filters
     * @param int $session_id Session ID
     * @param array $filters Optional filters (programme_id, level_id, subject_id, lecturer_id, status)
     * @return array Array of class objects
     */
    public function getClassesBySession($session_id, $filters = array())
    {
        // FIXED: Explicit column selection to avoid id column conflict between class and subject_level tables
        $this->db->select('class.id as id,
            class.class_code, class.subject_level_id, class.cohort_name,
            class.academic_year, class.session_id, class.delivery_mode,
            class.primary_lecturer_id, class.status, class.is_active,
            class.max_students, class.min_students, class.start_date, class.end_date,
            subject_level.subject_id, subject_level.level_id,
            subjects.name as subject_name, subjects.code as subject_code, subjects.programme_id,
            level.name as level_name, level.code as level_code, level.level_type, level.sequence,
            staff.name as lecturer_name, staff.id as lecturer_id,
            sessions.session as session_name,
            (SELECT COUNT(*) FROM enrolment WHERE enrolment.class_id = class.id AND enrolment.status = "Active") as student_count');
        $this->db->from('class');
        $this->db->join('subject_level', 'class.subject_level_id = subject_level.id');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->join('staff', 'class.primary_lecturer_id = staff.id', 'left');
        $this->db->join('sessions', 'class.session_id = sessions.id');
        $this->db->where('class.session_id', $session_id);
        $this->db->where('class.is_active', 1);

        // Apply filters
        if (!empty($filters['programme_id'])) {
            $this->db->where('subjects.programme_id', $filters['programme_id']);
        }

        if (!empty($filters['level_id'])) {
            $this->db->where('level.id', $filters['level_id']);
        }

        if (!empty($filters['subject_id'])) {
            $this->db->where('subjects.id', $filters['subject_id']);
        }

        if (!empty($filters['lecturer_id'])) {
            $this->db->where('class.primary_lecturer_id', $filters['lecturer_id']);
        }

        if (!empty($filters['status'])) {
            $this->db->where('class.status', $filters['status']);
        }

        if (!empty($filters['cohort_name'])) {
            $this->db->where('class.cohort_name', $filters['cohort_name']);
        }

        $this->db->order_by('subjects.name', 'ASC');
        $this->db->order_by('level.sequence', 'ASC');
        $this->db->order_by('class.cohort_name', 'ASC');

        return $this->db->get()->result();
    }

    /**
     * Get students enrolled in a class
     * @param int $class_id Class ID
     * @return array Array of student objects with enrolment details
     */
    public function getClassStudents($class_id)
    {
        $this->db->select('students.*,
            enrolment.*,
            enrolment.id as enrolment_id,
            enrolment.enrolment_type,
            enrolment.enrolment_date,
            enrolment.status as enrolment_status,
            student_programme.programme_id,
            programme.name as programme_name');
        $this->db->from('enrolment');
        $this->db->join('students', 'enrolment.student_id = students.id');
        $this->db->join('student_programme', 'student_programme.student_id = students.id AND student_programme.session_id = enrolment.session_id', 'left');
        $this->db->join('programme', 'student_programme.programme_id = programme.id', 'left');
        $this->db->where('enrolment.class_id', $class_id);
        $this->db->where('enrolment.status', 'Active');
        $this->db->where('students.is_active', 'yes');
        $this->db->order_by('students.firstname', 'ASC');
        $this->db->order_by('students.lastname', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Get classes by lecturer ID
     * @param int $lecturer_id Staff ID
     * @param int $session_id Session ID (optional)
     * @return array Array of classes
     */
    public function getClassesByLecturer($lecturer_id, $session_id = null)
    {
        // FIXED: Explicit column selection
        $this->db->select('class.id as id,
            class.class_code, class.subject_level_id, class.cohort_name,
            class.academic_year, class.session_id, class.delivery_mode,
            class.primary_lecturer_id, class.status, class.is_active,
            subjects.name as subject_name, subjects.code as subject_code,
            level.name as level_name, level.code as level_code,
            (SELECT COUNT(*) FROM enrolment WHERE enrolment.class_id = class.id AND enrolment.status = "Active") as student_count');
        $this->db->from('class');
        $this->db->join('subject_level', 'class.subject_level_id = subject_level.id');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->where('class.primary_lecturer_id', $lecturer_id);
        $this->db->where('class.is_active', 1);

        if ($session_id) {
            $this->db->where('class.session_id', $session_id);
        }

        $this->db->order_by('subjects.name', 'ASC');
        $this->db->order_by('level.sequence', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Get classes by level ID
     * @param int $level_id Level ID
     * @param int $session_id Session ID
     * @return array Array of classes
     */
    public function getClassesByLevel($level_id, $session_id)
    {
        $this->db->select('class.*,
            subjects.name as subject_name, subjects.code as subject_code,
            level.name as level_name,
            staff.name as lecturer_name');
        $this->db->from('class');
        $this->db->join('subject_level', 'class.subject_level_id = subject_level.id');
        $this->db->join('subjects', 'subject_level.subject_id = subjects.id');
        $this->db->join('level', 'subject_level.level_id = level.id');
        $this->db->join('staff', 'class.primary_lecturer_id = staff.id', 'left');
        $this->db->where('level.id', $level_id);
        $this->db->where('class.session_id', $session_id);
        $this->db->where('class.is_active', 1);
        $this->db->order_by('subjects.name', 'ASC');
        $this->db->order_by('class.cohort_name', 'ASC');
        return $this->db->get()->result();
    }

    /**
     * Add new class
     * @param array $data Class data
     * @return int Insert ID or false
     */
    public function add($data)
    {
        if ($this->db->insert('class', $data)) {
            return $this->db->insert_id();
        }
        return false;
    }

    /**
     * Update class
     * @param int $class_id Class ID
     * @param array $data Class data
     * @return bool Success status
     */
    public function update($class_id, $data)
    {
        $this->db->where('id', $class_id);
        return $this->db->update('class', $data);
    }

    /**
     * Delete class (soft delete)
     * @param int $class_id Class ID
     * @return bool Success status
     */
    public function remove($class_id)
    {
        $data = array('is_active' => 0);
        $this->db->where('id', $class_id);
        return $this->db->update('class', $data);
    }

    /**
     * Get class code suggestions based on subject-level-cohort-year
     * @param int $subject_level_id Subject-level ID
     * @param string $cohort_name Cohort name
     * @param int $academic_year Academic year
     * @return string Suggested class code
     */
    public function generateClassCode($subject_level_id, $cohort_name, $academic_year)
    {
        $sl = $this->db->select('subjects.code as subject_code, level.code as level_code')
            ->from('subject_level')
            ->join('subjects', 'subject_level.subject_id = subjects.id')
            ->join('level', 'subject_level.level_id = level.id')
            ->where('subject_level.id', $subject_level_id)
            ->get()->row();

        if (!$sl) {
            return 'CLASS-' . $academic_year;
        }

        return $sl->subject_code . '-' . $sl->level_code . '-' . $cohort_name . '-' . $academic_year;
    }

    /**
     * Check if class code exists
     * @param string $class_code Class code
     * @param int $session_id Session ID
     * @param int $exclude_id Exclude this class ID (for updates)
     * @return bool True if exists
     */
    public function classCodeExists($class_code, $session_id, $exclude_id = null)
    {
        $this->db->where('class_code', $class_code);
        $this->db->where('session_id', $session_id);

        if ($exclude_id) {
            $this->db->where('id !=', $exclude_id);
        }

        $count = $this->db->count_all_results('class');
        return $count > 0;
    }

    /**
     * Get class statistics
     * @param int $session_id Session ID
     * @return object Statistics object
     */
    public function getClassStatistics($session_id)
    {
        $stats = new stdClass();

        // Total classes
        $stats->total_classes = $this->db->where('session_id', $session_id)
            ->where('is_active', 1)
            ->count_all_results('class');

        // Classes by status
        $this->db->select('status, COUNT(*) as count');
        $this->db->from('class');
        $this->db->where('session_id', $session_id);
        $this->db->where('is_active', 1);
        $this->db->group_by('status');
        $status_counts = $this->db->get()->result();
        $stats->by_status = $status_counts;

        // Total enrolments
        $stats->total_enrolments = $this->db->select('COUNT(*) as count')
            ->from('enrolment')
            ->join('class', 'enrolment.class_id = class.id')
            ->where('class.session_id', $session_id)
            ->where('enrolment.status', 'Active')
            ->get()->row()->count;

        return $stats;
    }
}
