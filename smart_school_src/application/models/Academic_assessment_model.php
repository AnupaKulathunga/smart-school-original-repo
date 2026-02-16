<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Academic Assessment Model
 * Manages assessments (Tests, ICASS, Exams, POE) for classes
 * Table columns: id, class_id, title, assessment_type, icass_component, total_marks,
 *   weight_percentage, due_date, instructions, attachments, moderation_status,
 *   moderator_id, moderation_date, moderation_comments, is_published, created_by,
 *   created_at, updated_at
 */
class Academic_assessment_model extends CI_Model
{
    private $table = 'academic_assessment';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get all assessments with class details
     */
    public function getAll($filters = array())
    {
        $this->db->select('a.*, c.class_code, c.cohort_name,
                          s.name as subject_name, s.code as subject_code,
                          l.code as level_code,
                          st.name as creator_name, st.surname as creator_surname,
                          (SELECT COUNT(*) FROM academic_assessment_marks WHERE assessment_id = a.id) as marks_count', FALSE);
        $this->db->from($this->table . ' a');
        $this->db->join('academic_class c', 'c.id = a.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject s', 's.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->join('staff st', 'st.id = a.created_by', 'left');

        if (!empty($filters['class_id'])) {
            $this->db->where('a.class_id', $filters['class_id']);
        }
        if (!empty($filters['assessment_type'])) {
            $this->db->where('a.assessment_type', $filters['assessment_type']);
        }
        if (!empty($filters['moderation_status'])) {
            $this->db->where('a.moderation_status', $filters['moderation_status']);
        }
        if (isset($filters['is_published']) && $filters['is_published']) {
            $this->db->where('a.is_published', 1);
        }

        return $this->db->order_by('a.due_date', 'DESC')->get()->result();
    }

    /**
     * Get assessment by ID with full details
     */
    public function get($id)
    {
        return $this->db->select('a.*, c.class_code, c.cohort_name, c.primary_lecturer_id,
                                  s.name as subject_name, s.code as subject_code,
                                  l.code as level_code, l.name as level_name,
                                  p.name as programme_name')
            ->from($this->table . ' a')
            ->join('academic_class c', 'c.id = a.class_id')
            ->join('academic_subject_level sl', 'sl.id = c.subject_level_id')
            ->join('academic_subject s', 's.id = sl.subject_id')
            ->join('academic_level l', 'l.id = sl.level_id')
            ->join('academic_programme p', 'p.id = s.programme_id')
            ->where('a.id', $id)
            ->get()->row();
    }

    /**
     * Get assessment by ID - returns array instead of object
     */
    public function getById($id)
    {
        $result = $this->get($id);
        return $result ? (array) $result : null;
    }

    /**
     * Get assessments by class - returns array of arrays
     */
    public function getByClass($class_id, $published_only = false)
    {
        $this->db->select('a.*, c.class_code, s.name as subject_name, l.code as level_code');
        $this->db->from($this->table . ' a');
        $this->db->join('academic_class c', 'c.id = a.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject s', 's.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->where('a.class_id', $class_id);

        if ($published_only) {
            $this->db->where('a.is_published', 1);
        }

        $results = $this->db->order_by('a.due_date', 'ASC')->get()->result();

        // Convert to array of arrays
        $output = array();
        foreach ($results as $r) {
            $output[] = (array) $r;
        }
        return $output;
    }

    /**
     * Get assessments pending moderation
     */
    public function getPendingModeration()
    {
        return $this->getAll(array('moderation_status' => 'Pending'));
    }

    /**
     * Add new assessment
     */
    public function add($data)
    {
        $insert_data = array(
            'class_id' => $data['class_id'],
            'title' => isset($data['title']) ? $data['title'] : (isset($data['name']) ? $data['name'] : ''),
            'assessment_type' => $data['assessment_type'],
            'total_marks' => isset($data['total_marks']) ? $data['total_marks'] : 100,
            'weight_percentage' => isset($data['weight_percentage']) ? $data['weight_percentage'] : null,
            'due_date' => isset($data['due_date']) ? $data['due_date'] : null,
            'instructions' => isset($data['instructions']) ? $data['instructions'] : null,
            'is_published' => isset($data['is_published']) ? $data['is_published'] : 0,
            'created_by' => isset($data['created_by']) ? $data['created_by'] : null
        );

        $this->db->insert($this->table, $insert_data);
        return $this->db->insert_id();
    }

    /**
     * Update assessment
     */
    public function update($id, $data)
    {
        $update_data = array();

        if (isset($data['title'])) $update_data['title'] = $data['title'];
        if (isset($data['name'])) $update_data['title'] = $data['name'];
        if (isset($data['assessment_type'])) $update_data['assessment_type'] = $data['assessment_type'];
        if (isset($data['total_marks'])) $update_data['total_marks'] = $data['total_marks'];
        if (isset($data['weight_percentage'])) $update_data['weight_percentage'] = $data['weight_percentage'];
        if (isset($data['due_date'])) $update_data['due_date'] = $data['due_date'];
        if (isset($data['instructions'])) $update_data['instructions'] = $data['instructions'];
        if (isset($data['is_published'])) $update_data['is_published'] = $data['is_published'];
        if (isset($data['moderation_status'])) $update_data['moderation_status'] = $data['moderation_status'];

        return $this->db->where('id', $id)->update($this->table, $update_data);
    }

    /**
     * Delete assessment
     */
    public function delete($id)
    {
        return $this->db->where('id', $id)->delete($this->table);
    }

    /**
     * Submit for moderation
     */
    public function submitForModeration($id)
    {
        return $this->update($id, array('moderation_status' => 'Pending'));
    }

    /**
     * Approve assessment
     */
    public function approve($id, $moderator_id = null, $comments = null)
    {
        return $this->update($id, array(
            'moderation_status' => 'Completed'
        ));
    }

    /**
     * Publish assessment
     */
    public function publish($id)
    {
        return $this->update($id, array('is_published' => 1));
    }

    /**
     * Unpublish assessment
     */
    public function unpublish($id)
    {
        return $this->update($id, array('is_published' => 0));
    }

    /**
     * Get student's assessments - for student portal
     */
    public function getStudentAssessments($student_id, $session_id = null)
    {
        $this->db->select('a.*, c.class_code, s.name as subject_name, l.code as level_code,
                          m.marks_obtained, m.percentage, m.grade, m.remarks as feedback');
        $this->db->from($this->table . ' a');
        $this->db->join('academic_class c', 'c.id = a.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject s', 's.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->join('academic_class_enrolment e', 'e.class_id = c.id');
        $this->db->join('student_session ss', 'ss.id = e.student_session_id');
        $this->db->join('academic_assessment_marks m', 'm.assessment_id = a.id AND m.enrolment_id = e.id', 'left');
        $this->db->where('ss.student_id', $student_id);
        $this->db->where('a.is_published', 1);

        if ($session_id) {
            $this->db->where('c.session_id', $session_id);
        }

        return $this->db->order_by('a.due_date', 'DESC')->get()->result();
    }

    /**
     * Get upcoming assessments for student
     */
    public function getUpcomingForStudent($student_id, $limit = 5)
    {
        $this->db->select('a.*, c.class_code, s.name as subject_name, l.code as level_code');
        $this->db->from($this->table . ' a');
        $this->db->join('academic_class c', 'c.id = a.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject s', 's.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->join('academic_class_enrolment e', 'e.class_id = c.id');
        $this->db->join('student_session ss', 'ss.id = e.student_session_id');
        $this->db->where('ss.student_id', $student_id);
        $this->db->where('e.status', 'Active');
        $this->db->where('a.is_published', 1);
        $this->db->where('a.due_date >=', date('Y-m-d'));

        return $this->db->order_by('a.due_date', 'ASC')
            ->limit($limit)
            ->get()->result();
    }
}
