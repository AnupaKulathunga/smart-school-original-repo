<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Academic Marks Model
 * Manages student marks for assessments
 */
class Academic_marks_model extends CI_Model
{
    private $table = 'academic_assessment_marks';

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Get marks for an assessment
     */
    public function getByAssessment($assessment_id)
    {
        return $this->db->select('m.*,
                                  e.student_id,
                                  s.admission_no, s.firstname, s.lastname')
            ->from($this->table . ' m')
            ->join('academic_class_enrolment e', 'e.id = m.enrolment_id')
            ->join('students s', 's.id = e.student_id')
            ->where('m.assessment_id', $assessment_id)
            ->order_by('s.lastname', 'ASC')
            ->order_by('s.firstname', 'ASC')
            ->get()->result();
    }

    /**
     * Get marks by enrolment (all assessments for a student in a class)
     */
    public function getByEnrolment($enrolment_id)
    {
        return $this->db->select('m.*, a.title, a.assessment_type, a.total_marks, a.weight_percentage, a.due_date')
            ->from($this->table . ' m')
            ->join('academic_assessment a', 'a.id = m.assessment_id')
            ->where('m.enrolment_id', $enrolment_id)
            ->order_by('a.due_date', 'ASC')
            ->get()->result();
    }

    /**
     * Get marks for student by assessment
     */
    public function getStudentMark($assessment_id, $enrolment_id)
    {
        return $this->db->where('assessment_id', $assessment_id)
            ->where('enrolment_id', $enrolment_id)
            ->get($this->table)->row();
    }

    /**
     * Get existing marks as associative array (enrolment_id => marks)
     */
    public function getExistingMarks($assessment_id)
    {
        $result = array();
        $marks = $this->db->where('assessment_id', $assessment_id)
            ->get($this->table)->result();

        foreach ($marks as $m) {
            $result[$m->enrolment_id] = array(
                'marks_obtained' => $m->marks_obtained,
                'grade' => $m->grade,
                'feedback' => $m->feedback
            );
        }

        return $result;
    }

    /**
     * Save mark for a student
     */
    public function save($data)
    {
        // Check if record exists
        $existing = $this->getStudentMark($data['assessment_id'], $data['enrolment_id']);

        $record_data = array(
            'assessment_id' => $data['assessment_id'],
            'enrolment_id' => $data['enrolment_id'],
            'marks_obtained' => isset($data['marks_obtained']) ? $data['marks_obtained'] : null,
            'percentage' => isset($data['percentage']) ? $data['percentage'] : null,
            'grade' => isset($data['grade']) ? $data['grade'] : null,
            'feedback' => isset($data['feedback']) ? $data['feedback'] : null,
            'marked_by' => isset($data['marked_by']) ? $data['marked_by'] : null,
            'marked_at' => date('Y-m-d H:i:s')
        );

        if ($existing) {
            return $this->db->where('id', $existing->id)->update($this->table, $record_data);
        } else {
            return $this->db->insert($this->table, $record_data);
        }
    }

    /**
     * Bulk save marks for an assessment
     */
    public function bulkSave($assessment_id, $marks_data, $marked_by = null)
    {
        // Get assessment total marks for percentage calculation
        $assessment = $this->db->select('total_marks')
            ->where('id', $assessment_id)
            ->get('academic_assessment')->row();

        $total_marks = $assessment ? $assessment->total_marks : 100;

        foreach ($marks_data as $enrolment_id => $mark_info) {
            $marks_obtained = isset($mark_info['marks']) ? $mark_info['marks'] : null;
            $percentage = null;
            $grade = null;

            if ($marks_obtained !== null && $marks_obtained !== '') {
                $percentage = ($marks_obtained / $total_marks) * 100;
                $grade = $this->calculateGrade($percentage);
            }

            $this->save(array(
                'assessment_id' => $assessment_id,
                'enrolment_id' => $enrolment_id,
                'marks_obtained' => $marks_obtained,
                'percentage' => $percentage,
                'grade' => $grade,
                'feedback' => isset($mark_info['feedback']) ? $mark_info['feedback'] : null,
                'marked_by' => $marked_by
            ));
        }

        return true;
    }

    /**
     * Calculate grade based on percentage
     * South African TVET grading scale
     */
    public function calculateGrade($percentage)
    {
        if ($percentage >= 80) return 'A';
        if ($percentage >= 70) return 'B';
        if ($percentage >= 60) return 'C';
        if ($percentage >= 50) return 'D';
        if ($percentage >= 40) return 'E';
        return 'F';
    }

    /**
     * Get assessment statistics
     */
    public function getAssessmentStats($assessment_id)
    {
        $stats = $this->db->select('
            COUNT(*) as total_marked,
            AVG(marks_obtained) as avg_marks,
            MIN(marks_obtained) as min_marks,
            MAX(marks_obtained) as max_marks,
            AVG(percentage) as avg_percentage,
            SUM(CASE WHEN percentage >= 40 THEN 1 ELSE 0 END) as passed,
            SUM(CASE WHEN percentage < 40 THEN 1 ELSE 0 END) as failed')
            ->where('assessment_id', $assessment_id)
            ->where('marks_obtained IS NOT NULL')
            ->get($this->table)->row();

        return $stats;
    }

    /**
     * Calculate ICASS mark for an enrolment
     */
    public function calculateICASSMark($enrolment_id)
    {
        // Get all ICASS assessments with marks
        $marks = $this->db->select('m.marks_obtained, m.percentage, a.weight_percentage, a.total_marks')
            ->from($this->table . ' m')
            ->join('academic_assessment a', 'a.id = m.assessment_id')
            ->where('m.enrolment_id', $enrolment_id)
            ->where('a.assessment_type', 'ICASS')
            ->where('m.marks_obtained IS NOT NULL')
            ->get()->result();

        $weighted_total = 0;
        $weight_sum = 0;

        foreach ($marks as $m) {
            if ($m->weight_percentage > 0) {
                $weighted_total += ($m->percentage * $m->weight_percentage / 100);
                $weight_sum += $m->weight_percentage;
            }
        }

        // Normalize to 100 if weights don't add up to 100
        if ($weight_sum > 0 && $weight_sum != 100) {
            $weighted_total = ($weighted_total / $weight_sum) * 100;
        }

        return round($weighted_total, 2);
    }

    /**
     * Get student results summary for a class
     */
    public function getClassResults($class_id)
    {
        return $this->db->select('e.id as enrolment_id, e.student_id, e.final_mark,
                                  s.admission_no, s.firstname, s.lastname,
                                  AVG(m.percentage) as avg_percentage,
                                  COUNT(m.id) as assessments_completed')
            ->from('academic_class_enrolment e')
            ->join('students s', 's.id = e.student_id')
            ->join($this->table . ' m', 'm.enrolment_id = e.id', 'left')
            ->where('e.class_id', $class_id)
            ->group_by('e.id')
            ->order_by('s.lastname', 'ASC')
            ->get()->result();
    }

    /**
     * Delete marks for an assessment
     */
    public function deleteByAssessment($assessment_id)
    {
        return $this->db->where('assessment_id', $assessment_id)->delete($this->table);
    }
}
