<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Lessonplan_model extends MY_model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();

        $this->current_session_name = $this->setting_model->getCurrentSessionName();
        $this->start_month          = $this->setting_model->getStartMonth();
    }

    // TVET: Copy lessons between classes - updated to use academic_class_id
    public function add_copy_lesson($data_to_be_insert)
    {


        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================

        foreach ($data_to_be_insert as $lesson_key => $lesson_value) {

          $lesson_array=[];
          $lesson_array['subject_group_subject_id']=$lesson_value['subject_group_subject_id'];
          $lesson_array['name']=$lesson_value['name'];
          // TVET: Changed from subject_group_class_sections_id to academic_class_id
          $lesson_array['academic_class_id']=$lesson_value['academic_class_id'];
          $lesson_array['session_id']=$lesson_value['session_id'];

            $this->db->insert('lesson', $lesson_array);
            $insert_id = $this->db->insert_id();
            foreach ($lesson_value['topics'] as $topic_key => $topic_value) {
                $data_to_be_insert[$lesson_key]['topics'][$topic_key]['lesson_id']=$insert_id;
            }
            $this->db->insert_batch('topic',$data_to_be_insert[$lesson_key]['topics']);
        }

        //======================Code End==============================

        $this->db->trans_complete(); # Completing transaction
        /* Optional */

        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            return $insert_id;
        }
    }

    // TVET: Add or update lesson - column names updated to academic_class_id
    public function add_lesson($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id']) && $data['id'] != '') {
            $this->db->where('id', $data['id']);
            $query     = $this->db->update('lesson', $data);
            $insert_id = $data['id'];
            $message   = UPDATE_RECORD_CONSTANT . " On lesson id " . $insert_id;
            $action    = "Update";
            $record_id = $insert_id;
        } else {
            $this->db->insert('lesson', $data);
            $insert_id = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On lesson id " . $insert_id;
            $action    = "Insert";
            $record_id = $insert_id;
        }

        $this->log($message, $record_id, $action);

        //======================Code End==============================

        $this->db->trans_complete(); # Completing transaction
        /* Optional */

        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            return $insert_id;
        }
    }

    // TVET: Get lessons by subject and class - updated to use academic_class_id
    public function getlessonBysubjectid($sub_id, $academic_class_id)
    {
        return $this->db->select('*')->from('lesson')->where('subject_group_subject_id', $sub_id)->where('academic_class_id', $academic_class_id)->get()->result_array();
    }

    public function getlessonBylessonid($lesson_id)
    {
        return $this->db->select('*')->from('lesson')->where('id', $lesson_id)->get()->result_array();
    }

    // TVET: Get lessons for editing - updated to use academic_class_id
    public function getlessonBysubjectidedit($sub_id, $academic_class_id)
    {
        return $this->db->select('*')->from('lesson')->where('subject_group_subject_id', $sub_id)->where('academic_class_id', $academic_class_id)->get()->result_array();
    }

    public function get_subjectNameBySubjectGroupSubjectId($subject_group_subject_id)
    {
        return $this->db->select('*')->from('subject_group_subjects')->join("subjects", "subjects.id = subject_group_subjects.subject_id")->where('subject_group_subjects.id', $subject_group_subject_id)->get()->row_array();
    }

    public function getSyllabusById($id)
    {
        return $this->db->select('*')->from('subject_syllabus')->where('id', $id)->get()->row();
    }

    //=======================topic==========================

    public function add_topic($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id']) && $data['id'] != '') {
            $this->db->where('id', $data['id']);
            $this->db->update('topic', $data);

            $message   = UPDATE_RECORD_CONSTANT . " On topic id " . $data['id'];
            $insert_id = $data['id'];
            $action    = "Update";
            $record_id = $data['id'];
        } else {
            $this->db->insert('topic', $data);
            $insert_id = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On topic id " . $insert_id;
            $action    = "Insert";
            $record_id = $insert_id;
        }

        $this->log($message, $record_id, $action);
        //======================Code End==============================

        $this->db->trans_complete(); # Completing transaction
        /* Optional */

        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            return $insert_id;
        }
    }

    public function gettopicBylessonid($lessonid, $session)
    {
        return $this->db->select('*')->from('topic')->where('lesson_id', $lessonid)->where('session_id', $session)->get()->result_array();
    }

    // TVET: Get topic by ID with TVET academic structure joins
    public function gettopicByID($id)
    {
        $this->db->select('topic.*,
                          subject_groups.name as sgname,
                          subjects.name as subname,
                          subject_groups.id as subjectgroupsid,
                          subjects.id as subjectid,
                          lesson.name as lessonname,
                          lesson.academic_class_id,
                          lesson.subject_group_subject_id,
                          ac.id as class_id,
                          ac.class_code,
                          ac.cohort_name,
                          CONCAT(asubj.code, "-", alvl.code) as subject_code_full,
                          asubj.name as class_subject_name,
                          alvl.name as level_name', FALSE);

        $this->db->from('topic');
        $this->db->join("lesson", "lesson.id = topic.lesson_id");
        $this->db->join("subject_group_subjects", "subject_group_subjects.id = lesson.subject_group_subject_id");
        $this->db->join("subject_groups", "subject_groups.id = subject_group_subjects.subject_group_id");
        $this->db->join("subjects", "subjects.id = subject_group_subjects.subject_id");

        // TVET: Join academic_class instead of subject_group_class_sections
        $this->db->join("academic_class ac", "ac.id = lesson.academic_class_id", 'inner');
        $this->db->join("academic_subject_level asl", "asl.id = ac.subject_level_id", 'left');
        $this->db->join("academic_subject asubj", "asubj.id = asl.subject_id", 'left');
        $this->db->join("academic_level alvl", "alvl.id = asl.level_id", 'left');

        $this->db->where('topic.id', $id);
        $query = $this->db->get();
        return $query->row();
    }

    // TVET: Get topics with TVET academic structure joins
    public function gettopic($session, $id = null)
    {
        $this->db->select('topic.*,
                          subject_groups.name as sgname,
                          subjects.name as subname,
                          subject_groups.id as subjectgroupsid,
                          subjects.id as subjectid,
                          lesson.name as lessonname,
                          lesson.academic_class_id,
                          lesson.subject_group_subject_id,
                          ac.id as class_id,
                          ac.class_code,
                          ac.cohort_name,
                          CONCAT(asubj.code, "-", alvl.code) as subject_code_full,
                          asubj.name as class_subject_name,
                          alvl.name as level_name', FALSE);

        $this->db->from('topic');

        if ($id != null) {
            $this->db->where('topic.lesson_id', $id);
        }
        $this->db->where('topic.session_id', $session);
        $this->db->join("lesson", "lesson.id = topic.lesson_id");
        $this->db->join("subject_group_subjects", "subject_group_subjects.id = lesson.subject_group_subject_id");
        $this->db->join("subject_groups", "subject_groups.id = subject_group_subjects.subject_group_id");
        $this->db->join("subjects", "subjects.id = subject_group_subjects.subject_id");

        // TVET: Join academic_class instead of subject_group_class_sections
        $this->db->join("academic_class ac", "ac.id = lesson.academic_class_id", 'inner');
        $this->db->join("academic_subject_level asl", "asl.id = ac.subject_level_id", 'left');
        $this->db->join("academic_subject asubj", "asubj.id = asl.subject_id", 'left');
        $this->db->join("academic_level alvl", "alvl.id = asl.level_id", 'left');

        $this->db->group_by("lesson.subject_group_subject_id");
        $this->db->group_by("topic.lesson_id");

        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
        }
    }

    public function deletetopic($id, $session)
    {
        $this->db->where("id", $id)->where("session_id", $session)->delete('topic');
    }

    public function deletetopicbulk($id, $session)
    {
        $this->db->where("lesson_id", $id)->where("session_id", $session)->delete('topic');
    }

    public function changeTopicStatus($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->where('id', $data['id']);
        $query = $this->db->update('topic', $data);

        $message   = UPDATE_RECORD_CONSTANT . " On  topic id " . $data['id'];
        $action    = "Update";
        $record_id = $data['id'];
        $this->log($message, $record_id, $action);
        //======================Code End==============================

        $this->db->trans_complete(); # Completing transaction
        /* Optional */

        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            return true;
        }
    }

    //==========================syllabus============================
    public function add_syllabus($data)
    {
        if (isset($data['id']) && $data['id'] > 0) {
            $this->db->where('id', $data['id']);
            $this->db->update('subject_syllabus', $data);
            $insert_id = $data['id'];
            $message   = UPDATE_RECORD_CONSTANT . " On Subject Syllabus id " . $insert_id;
            $action    = "Update";
            $record_id = $insert_id;
            return $record_id;
        } else {
            $this->db->insert('subject_syllabus', $data);
            $insert_id = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On Subject Syllabus id " . $insert_id;
            $action    = "Insert";
            $record_id = $insert_id;
            return $this->db->insert_id();
        }
    }

    public function update_syllabus($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->where('id', $data['id']);
        $query = $this->db->update('subject_syllabus', $data);
        $message   = UPDATE_RECORD_CONSTANT . " On  Subject Syllabus id " . $data['id'];
        $action    = "Update";
        $record_id = $data['id'];
        $this->log($message, $record_id, $action);
        //======================Code End==============================
        $this->db->trans_complete(); # Completing transaction
        /* Optional */
        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            return true;
        }
    }

    // TVET: Get lessons with TVET academic structure joins
    // $id parameter is now academic_class_id
    public function get($session, $id = null, $subject_group_subject_id = null)
    {
        $this->db->select('lesson.*,
                          subject_groups.name as sgname,
                          subjects.name as subname,
                          subjects.code as subjects_code,
                          subject_groups.id as subjectgroupsid,
                          subjects.id as subjectid,
                          ac.id as class_id,
                          ac.class_code,
                          ac.cohort_name,
                          CONCAT(asubj.code, "-", alvl.code) as subject_code_full,
                          asubj.name as class_subject_name,
                          alvl.name as level_name', FALSE);

        $this->db->from('lesson');

        // TVET: Filter by academic_class_id instead of subject_group_class_sections_id
        if ($id != null) {
            $this->db->where('lesson.academic_class_id', $id);
        }
        if ($subject_group_subject_id != null) {
            $this->db->where('subject_group_subjects.id', $subject_group_subject_id);
        }

        $this->db->where('lesson.session_id', $session);
        $this->db->join("subject_group_subjects", "subject_group_subjects.id = lesson.subject_group_subject_id");
        $this->db->join("subject_groups", "subject_groups.id = subject_group_subjects.subject_group_id");
        $this->db->join("subjects", "subjects.id = subject_group_subjects.subject_id");

        // TVET: Join academic_class instead of subject_group_class_sections
        $this->db->join("academic_class ac", "ac.id = lesson.academic_class_id", 'inner');
        $this->db->join("academic_subject_level asl", "asl.id = ac.subject_level_id", 'left');
        $this->db->join("academic_subject asubj", "asubj.id = asl.subject_id", 'left');
        $this->db->join("academic_level alvl", "alvl.id = asl.level_id", 'left');

        $this->db->group_by("lesson.subject_group_subject_id");
        $this->db->group_by("lesson.academic_class_id");

        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
        }
    }

    // TVET: Original method with section_id (kept for backward compatibility during transition)
    public function getsubject_group_class_sectionsId($class_id, $section_id, $subject_group_id,$session_id=NULL)
    {
        $session_id=IsNullOrEmptyString($session_id) ? $this->current_session :$session_id;
        $sql   = "SELECT subject_groups.name, subject_group_class_sections.* from subject_group_class_sections INNER JOIN class_sections on class_sections.id=subject_group_class_sections.class_section_id INNER JOIN subject_groups on subject_groups.id=subject_group_class_sections.subject_group_id WHERE class_sections.class_id=" . $this->db->escape($class_id) . " and class_sections.section_id=" . $this->db->escape($section_id) . " and subject_groups.id=" . $this->db->escape($subject_group_id) . "and subject_groups.session_id=" . $this->db->escape($session_id) . " ORDER by subject_groups.id DESC";
        $query = $this->db->query($sql);
        return $query->row_array();
    }

    // TVET: New method without section_id - CLASS already includes cohort
    public function getsubject_group_classId($class_id, $subject_group_id, $session_id=NULL)
    {
        $session_id = IsNullOrEmptyString($session_id) ? $this->current_session : $session_id;

        // Use class table instead of class_sections
        $sql = "SELECT subject_groups.name, subject_group_class_sections.*
                FROM subject_group_class_sections
                INNER JOIN class_sections ON class_sections.id = subject_group_class_sections.class_section_id
                INNER JOIN subject_groups ON subject_groups.id = subject_group_class_sections.subject_group_id
                WHERE class_sections.class_id = " . $this->db->escape($class_id) . "
                AND subject_groups.id = " . $this->db->escape($subject_group_id) . "
                AND subject_groups.session_id = " . $this->db->escape($session_id) . "
                ORDER BY subject_groups.id DESC";

        $query = $this->db->query($sql);
        return $query->row_array();
    }

    // TVET: Get lesson by subject and class - updated to use academic_class_id
    public function getlesson($subject_group_subjectid, $academic_class_id, $session)
    {
        return $this->db->select('*')->from('lesson')->where('lesson.subject_group_subject_id', $subject_group_subjectid)->where("session_id", $session)->where('academic_class_id', $academic_class_id)->get()->result_array();
    }

    public function deletelesson($id, $session)
    {
        $this->db->where("id", $id)->where("session_id", $session)->delete('lesson');
    }

    // TVET: Delete lessons in bulk - updated to use academic_class_id
    public function deletelessonbulk($id, $session, $subject_group_subject_id)
    {
        $this->db->where("academic_class_id", $id)->where("subject_group_subject_id", $subject_group_subject_id)->where("session_id", $session)->delete('lesson');
    }

    // TVET: Get subject status - updated to use academic_class_id
    public function get_subjectstatus($id, $academic_class_id)
    {
        $sql = "SELECT COUNT(CASE WHEN topic.status = 0 then 1 ELSE NULL END) as 'incomplete', COUNT(CASE WHEN topic.status = 1 then 1 ELSE NULL END) as 'complete',count('*') as total FROM `lesson` inner join topic on lesson.id=topic.lesson_id WHERE lesson.academic_class_id=" . $this->db->escape($academic_class_id) . "and lesson.subject_group_subject_id=" . $this->db->escape($id);
        $query = $this->db->query($sql);
        return $query->result();
    }

    public function get_subject_syllabus($subject_group_subject_id, $subject_id, $time_from, $time_to, $new_date, $staddID, $session)
    {
        $this->db->select('subject_syllabus.*,topic.name as tname')
            ->join("topic", "topic.id = subject_syllabus.topic_id")
            ->from('subject_syllabus')
            ->where("subject_syllabus.subject_group_subject_id", $subject_group_subject_id)
            ->where("subject_syllabus.subject_id", $subject_id)
            ->where("subject_syllabus.time_from", $time_from)
            ->where("subject_syllabus.time_to", $time_to)
            ->where("subject_syllabus.date", $new_date)
            ->where("subject_syllabus.created_by", $staddID)
            ->where("subject_syllabus.session_id", $session);
        $query = $this->db->get();
        return $query->result_array();
    }

    // TVET: Check if staff is class teacher - updated for TVET academic structure
    // Uses academic_class primary lecturer and additional lecturers instead of subject_timetable
    public function ifclassteacher($class_id, $staff_id, $subject_group_id, $subject_group_subject_id)
    {
        // TVET: Check if staff is the primary lecturer for this academic class
        $class_lecturer = $this->db->select('*', FALSE)
            ->from('academic_class')
            ->where('id', $class_id)
            ->where('primary_lecturer_id', $staff_id)
            ->get()->num_rows();

        if ($class_lecturer > 0) {
            return 1;
        }

        // TVET: Check if staff is assigned as additional lecturer for this academic class
        $additional_lecturer = $this->db->select('*', FALSE)
            ->from('academic_class_lecturer')
            ->where('class_id', $class_id)
            ->where('staff_id', $staff_id)
            ->get()->num_rows();

        if ($additional_lecturer > 0) {
            return 1;
        }

        // Legacy check: Check subject_timetable (for backward compatibility during transition)
        // Note: This will be removed in later phases once fully migrated to TVET
        $subject_teacher = $this->db->select('st.*', FALSE)
            ->from('subject_timetable st')
            ->where('st.staff_id', $staff_id)
            ->where('st.subject_group_id', $subject_group_id)
            ->where('st.subject_group_subject_id', $subject_group_subject_id)
            ->get()->num_rows();

        if ($subject_teacher > 0) {
            return 1;
        }

        return 0;
    }

    // TVET: Get topic list with DataTables - updated to use TVET academic structure
    public function gettopiclist($session)
    {
        $class_section_array = $this->customlib->get_myClassSection();
        $this->datatables
            ->select('topic.*,
                     subject_groups.name as sgname,
                     subjects.name as subname,
                     subjects.code as subjects_code,
                     subject_groups.id as subjectgroupsid,
                     subjects.id as subjectid,
                     lesson.name as lessonname,
                     lesson.academic_class_id,
                     lesson.subject_group_subject_id,
                     ac.id as class_id,
                     ac.class_code,
                     ac.cohort_name,
                     CONCAT(asubj.code, "-", alvl.code) as subject_code_full,
                     asubj.name as class_subject_name,
                     alvl.name as level_name', FALSE)
            ->searchable('ac.class_code,subjects.name,subject_groups.name,lesson.name,topic.name')
            ->orderable('ac.class_code,subjects.name,subject_groups.name,lesson.name,topic.name')
            ->join("lesson", "lesson.id = topic.lesson_id")
            ->join("subject_group_subjects", "subject_group_subjects.id = lesson.subject_group_subject_id")
            ->join("subject_groups", "subject_groups.id = subject_group_subjects.subject_group_id")
            ->join("subjects", "subjects.id = subject_group_subjects.subject_id")
            // TVET: Join academic_class instead of subject_group_class_sections
            ->join("academic_class ac", "ac.id = lesson.academic_class_id", 'inner')
            ->join("academic_subject_level asl", "asl.id = ac.subject_level_id", 'left')
            ->join("academic_subject asubj", "asubj.id = asl.subject_id", 'left')
            ->join("academic_level alvl", "alvl.id = asl.level_id", 'left')
            ->where('topic.session_id', $session);

        // TVET: Filter by academic classes accessible to this user
        if (!empty($class_section_array)) {
            $this->datatables->group_start();
            foreach ($class_section_array as $class_sectionkey => $class_sectionvalue) {
                // TVET: Filter by academic_class_id directly
                // In TVET, get_myClassSection should return academic class IDs
                foreach ($class_sectionvalue as $class_sectionvaluekey => $class_sectionvaluevalue) {
                    $query_string = "( ac.id=" . intval($class_sectionvaluevalue) . " )";
                    $this->datatables->or_where($query_string);
                }
            }
            $this->datatables->group_end();
        }

        $this->datatables->group_by("lesson.subject_group_subject_id");
        $this->datatables->group_by("topic.lesson_id");
        $this->datatables->from('topic');
        return $this->datatables->generate('json');

    }

    // TVET: Get lesson list with DataTables - updated to use TVET academic structure
    public function getlessonlist($session, $id = null)
    {
        $class_section_array = $this->customlib->get_myClassSection();
        $this->datatables
            ->select('lesson.*,
                     subject_groups.name as sgname,
                     subjects.name as subname,
                     subjects.code as subjects_code,
                     subject_groups.id as subjectgroupsid,
                     subjects.id as subjectid,
                     ac.id as class_id,
                     ac.class_code,
                     ac.cohort_name,
                     CONCAT(asubj.code, "-", alvl.code) as subject_code_full,
                     asubj.name as class_subject_name,
                     alvl.name as level_name', FALSE)
            ->searchable('ac.class_code,subject_groups.name,subjects.name,lesson.name')
            ->orderable('ac.class_code,subject_groups.name,subjects.name,lesson.name')
            ->join("subject_group_subjects", "subject_group_subjects.id = lesson.subject_group_subject_id")
            ->join("subject_groups", "subject_groups.id = subject_group_subjects.subject_group_id")
            ->join("subjects", "subjects.id = subject_group_subjects.subject_id")
            // TVET: Join academic_class instead of subject_group_class_sections
            ->join("academic_class ac", "ac.id = lesson.academic_class_id", 'inner')
            ->join("academic_subject_level asl", "asl.id = ac.subject_level_id", 'left')
            ->join("academic_subject asubj", "asubj.id = asl.subject_id", 'left')
            ->join("academic_level alvl", "alvl.id = asl.level_id", 'left')
            ->where('lesson.session_id', $session);

        // TVET: Filter by academic classes accessible to this user
        if (!empty($class_section_array)) {
            $this->datatables->group_start();
            foreach ($class_section_array as $class_sectionkey => $class_sectionvalue) {
                // TVET: Filter by academic_class_id directly
                // In TVET, get_myClassSection should return academic class IDs
                foreach ($class_sectionvalue as $class_sectionvaluekey => $class_sectionvaluevalue) {
                    $query_string = "( ac.id=" . intval($class_sectionvaluevalue) . " )";
                    $this->datatables->or_where($query_string);
                }
            }
            $this->datatables->group_end();
        }

        $this->datatables->group_by("lesson.subject_group_subject_id");
        $this->datatables->group_by("lesson.academic_class_id");
        $this->datatables->from('lesson');
        return $this->datatables->generate('json');
    }
}
