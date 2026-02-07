<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Examschedule_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
    }

    public function getDetailbyClsandSection($class_id, $section_id = null, $exam_id = null)
    {
        $query = $this->db->query("SELECT exam_schedules.*, subjects.name, subjects.id as subject_id, subjects.type
                FROM exam_schedules
                INNER JOIN teacher_subjects ON exam_schedules.teacher_subject_id = teacher_subjects.id
                INNER JOIN exams ON exam_schedules.exam_id = exams.id
                INNER JOIN subjects ON teacher_subjects.subject_id = subjects.id
                WHERE teacher_subjects.class_id = " . $this->db->escape($class_id) . "
                  AND exam_id = " . $this->db->escape($exam_id) . "
                  AND exam_schedules.session_id = " . $this->db->escape($this->current_session));
        return $query->result_array();
    }

    public function getTeacherSubjects($class_id, $section_id = null, $id = null)
    {
        $query = $this->db->select("teacher_subjects.subject_id")
            ->where(array("teacher_subjects.class_id" => $class_id, "teacher_subjects.teacher_id" => $id))
            ->get("teacher_subjects");

        return $query->result_array();
    }

    public function getExamByClassandSection($class_id, $section_id = null)
    {
        $sql = "SELECT exams.*, ac.id as class_id, ac.class_code as class_name
                FROM exams
                INNER JOIN (
                    SELECT exam_schedules.exam_id
                    FROM exam_schedules
                    INNER JOIN teacher_subjects ON teacher_subjects.id = exam_schedules.teacher_subject_id
                    INNER JOIN academic_classes ac ON ac.id = teacher_subjects.class_id
                    WHERE teacher_subjects.class_id = " . $this->db->escape($class_id) . "
                      AND teacher_subjects.session_id = " . $this->db->escape($this->current_session) . "
                    GROUP BY exam_schedules.exam_id
                ) as exam_schedules ON exams.id = exam_schedules.exam_id
                INNER JOIN teacher_subjects ts2 ON ts2.class_id = " . $this->db->escape($class_id) . "
                  AND ts2.session_id = " . $this->db->escape($this->current_session) . "
                INNER JOIN academic_classes ac ON ac.id = ts2.class_id
                GROUP BY exams.id";
        $query = $this->db->query($sql);
        return $query->result_array();
    }

    public function getresultByStudentandExam($exam_id, $student_id)
    {
        $query = $this->db->query("SELECT exam_schedules.id as `exam_schedule_id`,exam_schedules.full_marks,exam_schedules.exam_id as `exam_id`,
            exam_schedules.passing_marks,exam_results.attendence,exam_results.get_marks,exam_results.note, subjects.name,subjects.code,subjects.type  FROM `exam_schedules` INNER JOIN teacher_subjects ON teacher_subjects.id=exam_schedules.teacher_subject_id  INNER JOIN exam_results ON exam_results.exam_schedule_id=exam_schedules.id INNER JOIN subjects ON teacher_subjects.subject_id=subjects.id  WHERE exam_schedules.exam_id=" . $this->db->escape($exam_id) . " and teacher_subjects.session_id=" . $this->db->escape($this->current_session) . " and exam_results.student_id=" . $this->db->escape($student_id) . " and teacher_subjects.session_id=" . $this->db->escape($this->current_session));
        return $query->result_array();
    }

    public function getclassandsectionbyexam($exam_id)
    {
        $query = $this->db->query("SELECT exam_schedules.exam_id,
                       ac.id as `class_id`,
                       ac.class_code as `class`
                FROM exam_schedules
                INNER JOIN teacher_subjects ON exam_schedules.teacher_subject_id = teacher_subjects.id
                INNER JOIN academic_classes ac ON ac.id = teacher_subjects.class_id
                WHERE exam_schedules.exam_id = " . $this->db->escape($exam_id) . "
                  AND exam_schedules.session_id = " . $this->db->escape($this->current_session) . "
                GROUP BY exam_schedules.exam_id");
        return $query->result_array();
    }

    // ============================================================================
    // TVET METHODS - Use academic_class table (no sections)
    // ============================================================================

    /**
     * Get exam schedule details by class only (TVET)
     * Replaces getDetailbyClsandSection() for TVET architecture
     *
     * @param int $class_id The academic_class.id
     * @param int $exam_id The exam ID
     * @return array Exam schedule details with subjects
     */
    public function getDetailbyClass($class_id, $exam_id)
    {
        // TVET: For TVET, we use academic_assessment table instead of exam_schedules
        // This method provides backward compatibility for legacy exam system
        $this->db->select('exam_schedules.*, subjects.name, subjects.id as subject_id, subjects.type,
                          ac.class_code, ac.cohort_name, al.name as level_name', FALSE)
            ->from('exam_schedules')
            ->join('teacher_subjects', 'exam_schedules.teacher_subject_id = teacher_subjects.id')
            ->join('exams', 'exam_schedules.exam_id = exams.id')
            ->join('subjects', 'teacher_subjects.subject_id = subjects.id')
            ->join('academic_class ac', 'teacher_subjects.class_id = ac.id', 'left')
            ->join('academic_subject_level asl', 'ac.subject_level_id = asl.id', 'left')
            ->join('academic_level al', 'asl.level_id = al.id', 'left')
            ->where('teacher_subjects.class_id', $class_id)
            ->where('exam_schedules.exam_id', $exam_id)
            ->where('exam_schedules.session_id', $this->current_session);

        return $this->db->get()->result_array();
    }

    /**
     * Get all exams for a specific class (TVET)
     * Replaces getExamByClassandSection() for TVET architecture
     *
     * @param int $class_id The academic_class.id
     * @return array List of exams scheduled for this class
     */
    public function getExamByClass($class_id)
    {
        $this->db->select('exams.*, ac.id as class_id, ac.class_code, ac.cohort_name,
                          al.name as level_name, COUNT(exam_schedules.id) as subject_count', FALSE)
            ->from('exams')
            ->join('exam_schedules', 'exams.id = exam_schedules.exam_id')
            ->join('teacher_subjects', 'exam_schedules.teacher_subject_id = teacher_subjects.id')
            ->join('academic_class ac', 'teacher_subjects.class_id = ac.id')
            ->join('academic_subject_level asl', 'ac.subject_level_id = asl.id', 'left')
            ->join('academic_level al', 'asl.level_id = al.id', 'left')
            ->where('ac.id', $class_id)
            ->where('teacher_subjects.session_id', $this->current_session)
            ->group_by('exams.id')
            ->order_by('exams.name');

        return $this->db->get()->result_array();
    }

    /**
     * Get teacher's subjects for a specific class (TVET)
     * Replaces getTeacherSubjects($class_id, $section_id, $teacher_id)
     *
     * @param int $class_id The academic_class.id
     * @param int $teacher_id The staff/teacher ID
     * @return array List of subjects taught by this teacher in this class
     */
    public function getTeacherSubjectsByClass($class_id, $teacher_id)
    {
        $this->db->select('teacher_subjects.subject_id, subjects.name as subject_name, subjects.code')
            ->from('teacher_subjects')
            ->join('subjects', 'teacher_subjects.subject_id = subjects.id')
            ->where('teacher_subjects.class_id', $class_id)
            ->where('teacher_subjects.teacher_id', $teacher_id)
            ->where('teacher_subjects.session_id', $this->current_session)
            ->where('teacher_subjects.is_active', 1);

        return $this->db->get()->result_array();
    }

    /**
     * Get exam result by student and exam (TVET)
     * Uses academic_class_enrolment instead of student_session
     *
     * @param int $exam_id The exam ID
     * @param int $student_id The student ID
     * @return array Exam result details
     */
    public function getResultByStudentAndExamTVET($exam_id, $student_id)
    {
        $this->db->select('exam_schedules.id as exam_schedule_id, exam_schedules.full_marks,
                          exam_schedules.exam_id, exam_schedules.passing_marks,
                          exam_results.attendence, exam_results.get_marks, exam_results.note,
                          subjects.name, subjects.code, subjects.type', FALSE)
            ->from('exam_schedules')
            ->join('teacher_subjects', 'teacher_subjects.id = exam_schedules.teacher_subject_id')
            ->join('exam_results', 'exam_results.exam_schedule_id = exam_schedules.id')
            ->join('subjects', 'teacher_subjects.subject_id = subjects.id')
            ->where('exam_schedules.exam_id', $exam_id)
            ->where('exam_schedules.session_id', $this->current_session)
            ->where('exam_results.student_id', $student_id);

        return $this->db->get()->result_array();
    }

    /**
     * Get class info by exam (TVET)
     * Returns academic class details instead of class+section
     *
     * @param int $exam_id The exam ID
     * @return array Class information
     */
    public function getClassByExamTVET($exam_id)
    {
        $this->db->select('exam_schedules.exam_id, ac.id as class_id, ac.class_code, ac.cohort_name,
                          asub.name as subject_name, al.code as level_code, al.name as level_name', FALSE)
            ->from('exam_schedules')
            ->join('teacher_subjects', 'exam_schedules.teacher_subject_id = teacher_subjects.id')
            ->join('academic_class ac', 'teacher_subjects.class_id = ac.id')
            ->join('academic_subject_level asl', 'ac.subject_level_id = asl.id')
            ->join('academic_subject asub', 'asl.subject_id = asub.id')
            ->join('academic_level al', 'asl.level_id = al.id')
            ->where('exam_schedules.exam_id', $exam_id)
            ->where('exam_schedules.session_id', $this->current_session)
            ->group_by('exam_schedules.exam_id');

        return $this->db->get()->result_array();
    }

}
