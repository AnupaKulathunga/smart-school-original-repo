<?php

class Classteacher_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
    }

    public function getClassTeacher($id = null)
    {

        if (!empty($id)) {
            $query = $this->db->select('staff.*, class_teacher.id as ctid, class_teacher.class_id, ac.class_code as class', FALSE)
                ->join("staff", "class_teacher.staff_id = staff.id")
                ->join("academic_classes ac", "class_teacher.class_id = ac.id")
                ->where("class_teacher.id", $id)
                ->get("class_teacher");
            return $query->row_array();
        } else {
            $query = $this->db->select('staff.*, class_teacher.id as ctid, ac.class_code as class', FALSE)
                ->join("staff", "class_teacher.staff_id = staff.id")
                ->join("academic_classes ac", "class_teacher.class_id = ac.id")
                ->get("class_teacher");
            return $query->row_array();
        }
    }

    public function addClassTeacher($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data["id"])) {
            $this->db->where("id", $data["id"])->update("class_teacher", $data);
            $message   = UPDATE_RECORD_CONSTANT . " On  class teacher id " . $data["id"];
            $action    = "Update";
            $record_id = $data["id"];
            $this->log($message, $record_id, $action);
        } else {
            $this->db->insert("class_teacher", $data);
            $id        = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On class teacher id " . $id;
            $action    = "Insert";
            $record_id = $id;
            $this->log($message, $record_id, $action);
        }
        //======================Code End==============================

        $this->db->trans_complete(); # Completing transaction
        /* Optional */

        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            //return $return_value;
        }
    }

    public function teacherByClassSection($class_id, $section_id = null)
    {
        $query = $this->db->select('staff.*, class_teacher.id as ctid, class_teacher.class_id, ac.class_code as class', FALSE)
            ->join("staff", "class_teacher.staff_id = staff.id")
            ->join("academic_classes ac", "class_teacher.class_id = ac.id")
            ->where("class_teacher.class_id", $class_id)
            ->where("staff.is_active", 1)
            ->where("class_teacher.session_id", $this->current_session)
            ->get("class_teacher");
        return $query->result_array();
    }

    public function updateTeacher($previd, $class_id, $section_id = null)
    {
        $data = array('class_id' => $class_id);
        $this->db->set('class_id', 'class_id', false);
        $this->db->where_in('id', $previd);
        $this->db->update('class_teacher', $data);
    }

    public function getclassbyuser($id)
    {
        $query = $this->db->select("ac.*", FALSE)
            ->from("class_teacher")
            ->join("academic_classes ac", "class_teacher.class_id = ac.id")
            ->where("class_teacher.staff_id", $id)
            ->get();
        return $query->result_array();
    }

    public function classbysubjectteacher($id, $classes)
    {
        $query = $this->db->query("select * from subject_timetable st where st.staff_id='" . $id . "' ");
        $subject_teacher = $query->result_array();
    }

    public function delete($class_id, $section_id = null, $array = null)
    {
        $this->db->where('class_id', $class_id);
        if (!empty($array)) {
            $this->db->where_in('staff_id', $array);
        }
        $this->db->delete('class_teacher');
    }

    public function getsubjectbyteacher($id)
    {
        $query = $this->db->select("ac.*, teacher_subjects.subject_id", FALSE)
            ->from("teacher_subjects")
            ->join("academic_classes ac", "teacher_subjects.class_id = ac.id")
            ->where("teacher_subjects.teacher_id", $id)
            ->where("teacher_subjects.session_id", $this->current_session)
            ->get();

        return $query->result_array();
    }

    // ============================================================================
    // TVET METHODS - Use academic_class.primary_lecturer_id
    // In TVET, "class teacher" = "primary lecturer" for an academic class
    // ============================================================================

    /**
     * Get class lecturer by class (TVET)
     * Replaces getClassTeacher() - returns primary lecturer for academic class
     *
     * @param int $class_id academic_class.id (optional, returns all if null)
     * @return mixed Single row or array of lecturers
     */
    public function getClassLecturer($class_id = null)
    {
        $this->db->select('staff.*, ac.id as class_id, ac.class_code, ac.cohort_name,
                          asub.name as subject_name, al.code as level_code', FALSE)
            ->from('academic_class ac')
            ->join('staff', 'ac.primary_lecturer_id = staff.id', 'left')
            ->join('academic_subject_level asl', 'asl.id = ac.subject_level_id')
            ->join('academic_subject asub', 'asub.id = asl.subject_id')
            ->join('academic_level al', 'al.id = asl.level_id')
            ->where('ac.session_id', $this->current_session);

        if (!empty($class_id)) {
            $this->db->where('ac.id', $class_id);
            $query = $this->db->get();
            return $query->row_array();
        } else {
            $query = $this->db->get();
            return $query->result_array();
        }
    }

    /**
     * Get lecturers by class (TVET)
     * Replaces teacherByClassSection() - returns all lecturers for a class
     * Includes primary lecturer and additional lecturers from academic_class_lecturer
     *
     * @param int $class_id academic_class.id
     * @return array List of lecturers assigned to this class
     */
    public function lecturersByClass($class_id)
    {
        // Get primary lecturer
        $primary = $this->db->select('staff.*, ac.id as class_id, ac.class_code, ac.cohort_name,
                                      "primary" as lecturer_role', FALSE)
            ->from('academic_class ac')
            ->join('staff', 'ac.primary_lecturer_id = staff.id')
            ->where('ac.id', $class_id)
            ->where('ac.session_id', $this->current_session)
            ->where('staff.is_active', 1)
            ->get()->result_array();

        // Get additional lecturers
        $additional = $this->db->select('staff.*, acl.class_id, ac.class_code, ac.cohort_name,
                                         acl.role as lecturer_role', FALSE)
            ->from('academic_class_lecturer acl')
            ->join('staff', 'acl.lecturer_id = staff.id')
            ->join('academic_class ac', 'ac.id = acl.class_id')
            ->where('acl.class_id', $class_id)
            ->where('acl.is_active', 1)
            ->where('staff.is_active', 1)
            ->get()->result_array();

        return array_merge($primary, $additional);
    }

    /**
     * Assign primary lecturer to class (TVET)
     * Replaces addClassTeacher() - updates academic_class.primary_lecturer_id
     *
     * @param int $class_id academic_class.id
     * @param int $staff_id Staff ID of lecturer
     * @return bool Success status
     */
    public function assignPrimaryLecturer($class_id, $staff_id)
    {
        $this->db->where('id', $class_id);
        $result = $this->db->update('academic_class', array('primary_lecturer_id' => $staff_id));

        if ($result) {
            $message = UPDATE_RECORD_CONSTANT . " On academic_class primary_lecturer_id for class " . $class_id;
            $this->log($message, $class_id, "Update");
        }
        return $result;
    }

    /**
     * Add additional lecturer to class (TVET)
     * Adds to academic_class_lecturer table
     *
     * @param int $class_id academic_class.id
     * @param int $staff_id Staff ID of lecturer
     * @param string $role Role (e.g., 'Assessor', 'Moderator', 'Assistant')
     * @return bool Success status
     */
    public function addClassLecturer($class_id, $staff_id, $role = 'Lecturer')
    {
        // Check if already exists
        $existing = $this->db->where('class_id', $class_id)
            ->where('lecturer_id', $staff_id)
            ->get('academic_class_lecturer');

        if ($existing->num_rows() > 0) {
            // Update existing
            $this->db->where('class_id', $class_id);
            $this->db->where('lecturer_id', $staff_id);
            return $this->db->update('academic_class_lecturer', array(
                'role' => $role,
                'is_active' => 1
            ));
        } else {
            // Insert new
            return $this->db->insert('academic_class_lecturer', array(
                'class_id' => $class_id,
                'lecturer_id' => $staff_id,
                'role' => $role,
                'is_active' => 1
            ));
        }
    }

    /**
     * Remove lecturer from class (TVET)
     * Replaces delete() - removes from academic_class_lecturer
     *
     * @param int $class_id academic_class.id
     * @param array $staff_ids Array of staff IDs to remove (optional)
     * @return bool Success status
     */
    public function removeClassLecturer($class_id, $staff_ids = array())
    {
        $this->db->where('class_id', $class_id);
        if (!empty($staff_ids)) {
            $this->db->where_in('lecturer_id', $staff_ids);
        }
        return $this->db->delete('academic_class_lecturer');
    }

    /**
     * Get classes by lecturer (TVET)
     * Returns all classes where staff is primary or additional lecturer
     *
     * @param int $staff_id Staff ID
     * @return array List of classes
     */
    public function getClassesByLecturer($staff_id)
    {
        // Classes where staff is primary lecturer
        $primary = $this->db->select('ac.*, asub.name as subject_name, al.code as level_code,
                                      "primary" as lecturer_role', FALSE)
            ->from('academic_class ac')
            ->join('academic_subject_level asl', 'asl.id = ac.subject_level_id')
            ->join('academic_subject asub', 'asub.id = asl.subject_id')
            ->join('academic_level al', 'al.id = asl.level_id')
            ->where('ac.primary_lecturer_id', $staff_id)
            ->where('ac.session_id', $this->current_session)
            ->get()->result_array();

        // Classes where staff is additional lecturer
        $additional = $this->db->select('ac.*, asub.name as subject_name, al.code as level_code,
                                         acl.role as lecturer_role', FALSE)
            ->from('academic_class_lecturer acl')
            ->join('academic_class ac', 'ac.id = acl.class_id')
            ->join('academic_subject_level asl', 'asl.id = ac.subject_level_id')
            ->join('academic_subject asub', 'asub.id = asl.subject_id')
            ->join('academic_level al', 'al.id = asl.level_id')
            ->where('acl.lecturer_id', $staff_id)
            ->where('acl.is_active', 1)
            ->where('ac.session_id', $this->current_session)
            ->get()->result_array();

        return array_merge($primary, $additional);
    }

}
