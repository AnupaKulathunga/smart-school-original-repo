<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Academic Class Model
 * THE CENTRAL ACADEMIC UNIT
 * CLASS = Subject + Level + Cohort + Year + Lecturer
 */
class Academic_class_model extends CI_Model
{
    private $table = 'academic_class';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get all classes with full details
     */
    public function getAll($filters = array())
    {
        $this->db->select('c.*,
                          CONCAT(s.code, "-", l.code) as subject_code_full,
                          s.code as subject_code, s.name as subject_name, s.programme_id,
                          l.code as level_code, l.name as level_name, l.nqf_level,
                          p.name as programme_name,
                          st.name as lecturer_name, st.surname as lecturer_surname,
                          sess.session as session_name,
                          (SELECT COUNT(*) FROM academic_class_enrolment WHERE class_id = c.id AND status = "Active") as student_count', FALSE);
        $this->db->from($this->table . ' c');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject s', 's.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->join('academic_programme p', 'p.id = s.programme_id');
        $this->db->join('staff st', 'st.id = c.primary_lecturer_id', 'left');
        $this->db->join('sessions sess', 'sess.id = c.session_id', 'left');

        // Apply filters
        if (!empty($filters['programme_id'])) {
            $this->db->where('s.programme_id', $filters['programme_id']);
        }
        if (!empty($filters['subject_id'])) {
            $this->db->where('s.id', $filters['subject_id']);
        }
        if (!empty($filters['level_id'])) {
            $this->db->where('l.id', $filters['level_id']);
        }
        if (!empty($filters['session_id'])) {
            $this->db->where('c.session_id', $filters['session_id']);
        }
        if (!empty($filters['lecturer_id'])) {
            $this->db->where('c.primary_lecturer_id', $filters['lecturer_id']);
        }
        if (!empty($filters['status'])) {
            $this->db->where('c.status', $filters['status']);
        }
        if (isset($filters['is_active'])) {
            $this->db->where('c.is_active', $filters['is_active']);
        }

        return $this->db->order_by('c.class_code', 'ASC')->get()->result();
    }

    /**
     * Get class by ID with full details
     */
    public function get($id)
    {
        return $this->db->select('c.*,
                                  CONCAT(s.code, "-", l.code) as subject_code_full,
                                  s.id as subject_id, s.code as subject_code, s.name as subject_name, s.programme_id,
                                  l.id as level_id, l.code as level_code, l.name as level_name, l.nqf_level,
                                  p.name as programme_name,
                                  st.name as lecturer_name, st.surname as lecturer_surname,
                                  sess.session as session_name', FALSE)
            ->from($this->table . ' c')
            ->join('academic_subject_level sl', 'sl.id = c.subject_level_id')
            ->join('academic_subject s', 's.id = sl.subject_id')
            ->join('academic_level l', 'l.id = sl.level_id')
            ->join('academic_programme p', 'p.id = s.programme_id')
            ->join('staff st', 'st.id = c.primary_lecturer_id', 'left')
            ->join('sessions sess', 'sess.id = c.session_id', 'left')
            ->where('c.id', $id)
            ->get()->row();
    }

    /**
     * Get class by code and session
     */
    public function getByCode($class_code, $session_id)
    {
        return $this->db->where('class_code', $class_code)
            ->where('session_id', $session_id)
            ->get($this->table)->row();
    }

    /**
     * Get classes by lecturer (for lecturer portal)
     */
    public function getByLecturer($lecturer_id, $session_id = null)
    {
        $this->db->select('c.*,
                          s.code as subject_code, s.name as subject_name,
                          l.code as level_code, l.name as level_name,
                          (SELECT COUNT(*) FROM academic_class_enrolment WHERE class_id = c.id AND status = "Active") as student_count');
        $this->db->from($this->table . ' c');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject s', 's.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');

        // Include classes where lecturer is primary or additional
        $this->db->group_start();
        $this->db->where('c.primary_lecturer_id', $lecturer_id);
        $this->db->or_where_in('c.id', '(SELECT class_id FROM academic_class_lecturer WHERE staff_id = ' . (int)$lecturer_id . ' AND is_active = 1)', false);
        $this->db->group_end();

        if ($session_id) {
            $this->db->where('c.session_id', $session_id);
        }

        $this->db->where('c.is_active', 1);

        return $this->db->order_by('c.class_code', 'ASC')->get()->result();
    }

    /**
     * Get classes by subject and level
     */
    public function getBySubjectLevel($subject_id, $level_id, $session_id = null)
    {
        $this->db->select('c.*,
                          (SELECT COUNT(*) FROM academic_class_enrolment WHERE class_id = c.id AND status = "Active") as student_count');
        $this->db->from($this->table . ' c');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->where('sl.subject_id', $subject_id);
        $this->db->where('sl.level_id', $level_id);

        if ($session_id) {
            $this->db->where('c.session_id', $session_id);
        }

        $this->db->where('c.is_active', 1);

        return $this->db->order_by('c.cohort_name', 'ASC')->get()->result();
    }

    /**
     * Add new class
     */
    public function add($data)
    {
        $insert_data = array(
            'class_code' => $data['class_code'],
            'subject_level_id' => $data['subject_level_id'],
            'cohort_name' => $data['cohort_name'],
            'academic_year' => $data['academic_year'],
            'session_id' => $data['session_id'],
            'intake_period' => isset($data['intake_period']) ? $data['intake_period'] : null,
            'delivery_mode' => isset($data['delivery_mode']) ? $data['delivery_mode'] : 'Full-time',
            'primary_lecturer_id' => isset($data['primary_lecturer_id']) ? $data['primary_lecturer_id'] : null,
            'venue' => isset($data['venue']) ? $data['venue'] : null,
            'max_students' => isset($data['max_students']) ? $data['max_students'] : 50,
            'start_date' => isset($data['start_date']) ? $data['start_date'] : null,
            'end_date' => isset($data['end_date']) ? $data['end_date'] : null,
            'status' => isset($data['status']) ? $data['status'] : 'Scheduled',
            'is_active' => isset($data['is_active']) ? $data['is_active'] : 1
        );

        $this->db->insert($this->table, $insert_data);
        return $this->db->insert_id();
    }

    /**
     * Update class
     */
    public function update($id, $data)
    {
        $update_data = array();

        if (isset($data['class_code'])) $update_data['class_code'] = $data['class_code'];
        if (isset($data['subject_level_id'])) $update_data['subject_level_id'] = $data['subject_level_id'];
        if (isset($data['cohort_name'])) $update_data['cohort_name'] = $data['cohort_name'];
        if (isset($data['academic_year'])) $update_data['academic_year'] = $data['academic_year'];
        if (isset($data['session_id'])) $update_data['session_id'] = $data['session_id'];
        if (isset($data['intake_period'])) $update_data['intake_period'] = $data['intake_period'];
        if (isset($data['delivery_mode'])) $update_data['delivery_mode'] = $data['delivery_mode'];
        if (isset($data['primary_lecturer_id'])) $update_data['primary_lecturer_id'] = $data['primary_lecturer_id'];
        if (isset($data['venue'])) $update_data['venue'] = $data['venue'];
        if (isset($data['max_students'])) $update_data['max_students'] = $data['max_students'];
        if (isset($data['start_date'])) $update_data['start_date'] = $data['start_date'];
        if (isset($data['end_date'])) $update_data['end_date'] = $data['end_date'];
        if (isset($data['status'])) $update_data['status'] = $data['status'];
        if (isset($data['is_active'])) $update_data['is_active'] = $data['is_active'];

        return $this->db->where('id', $id)->update($this->table, $update_data);
    }

    /**
     * Delete class
     */
    public function delete($id)
    {
        return $this->db->where('id', $id)->delete($this->table);
    }

    /**
     * Check if class code exists in session
     */
    public function codeExists($class_code, $session_id, $exclude_id = null)
    {
        $this->db->where('class_code', $class_code);
        $this->db->where('session_id', $session_id);
        if ($exclude_id) {
            $this->db->where('id !=', $exclude_id);
        }
        return $this->db->count_all_results($this->table) > 0;
    }

    /**
     * Generate class code
     * Format: SUBJECT_CODE-LEVEL_CODE-COHORT-YEAR
     * Example: MATH-N4-A-2026
     */
    public function generateClassCode($subject_level_id, $cohort_name, $year)
    {
        $sl = $this->db->select('s.code as subject_code, l.code as level_code')
            ->from('academic_subject_level sl')
            ->join('academic_subject s', 's.id = sl.subject_id')
            ->join('academic_level l', 'l.id = sl.level_id')
            ->where('sl.id', $subject_level_id)
            ->get()->row();

        if ($sl) {
            return strtoupper($sl->subject_code . '-' . $sl->level_code . '-' . $cohort_name . '-' . $year);
        }
        return null;
    }

    /**
     * Get class roster (enrolled students)
     */
    public function getRoster($class_id)
    {
        return $this->db->select('e.*, s.id as student_id, s.admission_no, s.firstname, s.lastname,
                                  s.mobileno, s.email, s.image')
            ->from('academic_class_enrolment e')
            ->join('students s', 's.id = e.student_id')
            ->where('e.class_id', $class_id)
            ->order_by('s.lastname', 'ASC')
            ->order_by('s.firstname', 'ASC')
            ->get()->result();
    }

    /**
     * Get class statistics
     */
    public function getStats($class_id)
    {
        $stats = new stdClass();

        // Enrolled count
        $stats->enrolled = $this->db->where('class_id', $class_id)
            ->where('status', 'Active')
            ->count_all_results('academic_class_enrolment');

        // Assessment count
        $stats->assessments = $this->db->where('class_id', $class_id)
            ->count_all_results('academic_assessment');

        // Average attendance
        $att = $this->db->select('
            (SUM(CASE WHEN status = "Present" THEN 1 ELSE 0 END) / COUNT(*)) * 100 as avg_attendance')
            ->from('academic_attendance')
            ->where('class_id', $class_id)
            ->get()->row();
        $stats->avg_attendance = $att ? round($att->avg_attendance, 1) : 0;

        return $stats;
    }

    /**
     * Get classes for dropdown
     */
    public function getDropdown($session_id = null)
    {
        $result = array('' => '-- Select Class --');
        $classes = $this->getAll($session_id ? array('session_id' => $session_id, 'is_active' => 1) : array('is_active' => 1));

        foreach ($classes as $c) {
            $result[$c->id] = $c->class_code . ' - ' . $c->subject_name . ' ' . $c->level_code . ' (' . $c->cohort_name . ')';
        }

        return $result;
    }

    /**
     * Get all classes for a programme + level + cohort combination
     * Used for bulk programme-based enrolment
     *
     * @param int $programme_id Programme ID (or code to lookup)
     * @param int $level_id Level ID (or code to lookup)
     * @param string $cohort_name Cohort name (A, B, etc.)
     * @param int $session_id Session ID
     * @return array Array of class objects
     */
    public function getByProgrammeLevelCohort($programme_id, $level_id, $cohort_name, $session_id)
    {
        return $this->db->select('c.*, s.code as subject_code, s.name as subject_name, l.code as level_code')
            ->from($this->table . ' c')
            ->join('academic_subject_level sl', 'sl.id = c.subject_level_id')
            ->join('academic_subject s', 's.id = sl.subject_id')
            ->join('academic_level l', 'l.id = sl.level_id')
            ->where('s.programme_id', $programme_id)
            ->where('l.id', $level_id)
            ->where('c.cohort_name', $cohort_name)
            ->where('c.session_id', $session_id)
            ->where('c.is_active', 1)
            ->get()->result();
    }

    /**
     * Get all classes for a programme + level (any cohort)
     * Used to find available cohorts for a programme-level combination
     */
    public function getByProgrammeLevel($programme_id, $level_id, $session_id = null)
    {
        $this->db->select('c.*, s.code as subject_code, s.name as subject_name, l.code as level_code,
                          (SELECT COUNT(*) FROM academic_class_enrolment WHERE class_id = c.id AND status = "Enrolled") as enrolled_count');
        $this->db->from($this->table . ' c');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject s', 's.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->where('s.programme_id', $programme_id);
        $this->db->where('l.id', $level_id);
        $this->db->where('c.is_active', 1);

        if ($session_id) {
            $this->db->where('c.session_id', $session_id);
        }

        return $this->db->order_by('c.cohort_name', 'ASC')
            ->order_by('s.name', 'ASC')
            ->get()->result();
    }

    /**
     * Get distinct cohorts available for a programme + level
     */
    public function getAvailableCohorts($programme_id, $level_id, $session_id)
    {
        return $this->db->select('DISTINCT(c.cohort_name) as cohort_name', FALSE)
            ->from($this->table . ' c')
            ->join('academic_subject_level sl', 'sl.id = c.subject_level_id')
            ->join('academic_subject s', 's.id = sl.subject_id')
            ->join('academic_level l', 'l.id = sl.level_id')
            ->where('s.programme_id', $programme_id)
            ->where('l.id', $level_id)
            ->where('c.session_id', $session_id)
            ->where('c.is_active', 1)
            ->order_by('c.cohort_name', 'ASC')
            ->get()->result();
    }
}
