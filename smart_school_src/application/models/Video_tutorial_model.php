<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Video_tutorial_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
    }

    // TVET: Replaced class_sections/classes/sections joins with academic_class
    // video_tutorial_class_sections.class_section_id now stores academic_class.id
    public function get($id = null)
    {
        $this->db->select('video_tutorial.*, academic_class.id as class_id, academic_class.class_code, academic_class.cohort_name, academic_subject.name as subject_name, academic_level.name as level_name', FALSE)
            ->join('video_tutorial_class_sections', 'video_tutorial_class_sections.video_tutorial_id=video_tutorial.id')
            ->join('academic_class', 'academic_class.id=video_tutorial_class_sections.class_section_id')
            ->join('academic_subject_level', 'academic_subject_level.id=academic_class.subject_level_id', 'left')
            ->join('academic_subject', 'academic_subject.id=academic_subject_level.subject_id', 'left')
            ->join('academic_level', 'academic_level.id=academic_subject_level.level_id', 'left')
            ->from('video_tutorial');

        if ($id != null) {
            $this->db->where('video_tutorial.id', $id);
        } else {
            $this->db->order_by('video_tutorial.id');
        }
        $query = $this->db->get();
        if ($id != null) {
            return $query->row();
        } else {
            return $query->result_array();
        }
    }

    public function remove($id)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->where("video_tutorial_id", $id);
        $this->db->delete('video_tutorial_class_sections');
        $this->db->where('id', $id);
        $this->db->delete('video_tutorial');
        $message   = DELETE_RECORD_CONSTANT . " On video tutorial id " . $id;
        $action    = "Delete";
        $record_id = $id;
        $this->log($message, $record_id, $action);
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

    public function add($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('video_tutorial', $data);
            $message   = UPDATE_RECORD_CONSTANT . " On  video tutorial id " . $data['id'];
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
                //return $return_value;
            }
        } else {
            $this->db->insert('video_tutorial', $data);
            $insert_id = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On video tutorial id " . $insert_id;
            $action    = "Insert";
            $record_id = $insert_id;
            $this->log($message, $record_id, $action);
            //======================Code End==============================
            $this->db->trans_complete(); # Completing transaction
            /* Optional */

            if ($this->db->trans_status() === false) {
                # Something went wrong.
                $this->db->trans_rollback();
                return false;
            } else {

            }
            return $insert_id;
        }
    }

    // TVET: Replaced class_sections joins with academic_class
    // $class_section_id now represents academic_class.id
    public function count_all($keyword = null, $class_id = null, $class_section_id = null)
    {
        $this->db->join('video_tutorial_class_sections', 'video_tutorial_class_sections.video_tutorial_id=video_tutorial.id');
        $this->db->join('academic_class', 'academic_class.id=video_tutorial_class_sections.class_section_id');
        $this->db->like('video_tutorial.title', $keyword);
        $this->db->like('video_tutorial_class_sections.class_section_id', $class_section_id);
        if ($class_id != null) {
            $this->db->like('academic_class.id', $class_id);
        }
        $this->db->group_by('video_tutorial_class_sections.video_tutorial_id');
        $query = $this->db->get("video_tutorial");
        return $query->num_rows();
    }

    // TVET: Replaced class_sections/classes/sections joins with academic_class
    // section_id filtering removed (no sections in TVET)
    public function fetch_details($limit, $start, $keyword = null, $class_id = null, $class_section_id = null)
    {
        $userdata        = $this->customlib->getUserData();
        $staff_id        = $userdata['id'];

        $output = '';
        $this->db->select("video_tutorial.*, academic_class.id as class_id, academic_class.class_code, academic_class.cohort_name, academic_subject.name as subject_name, academic_level.name as level_name, staff.name as staff_name, staff.surname as staff_surname, staff.employee_id as staff_employee_id", FALSE);
        $this->db->join('staff', 'staff.id=video_tutorial.created_by', 'left');
        $this->db->join('video_tutorial_class_sections', 'video_tutorial_class_sections.video_tutorial_id=video_tutorial.id');
        $this->db->join('academic_class', 'academic_class.id=video_tutorial_class_sections.class_section_id');
        $this->db->join('academic_subject_level', 'academic_subject_level.id=academic_class.subject_level_id', 'left');
        $this->db->join('academic_subject', 'academic_subject.id=academic_subject_level.subject_id', 'left');
        $this->db->join('academic_level', 'academic_level.id=academic_subject_level.level_id', 'left');

        // TVET: For class teacher restriction, filter by lecturer's assigned classes
        if(!empty($class_id)){
            if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
                $this->db->where_in("academic_class.id", $class_id);
            } else {
                $this->db->where_in("academic_class.id", $class_id);
            }
        } else {
            // TVET: If class teacher with no class selected, filter by their assigned classes
            if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
                $my_classes = $this->classmodel_model->getClassesByStaff($staff_id);
                if (!empty($my_classes)) {
                    $class_ids = array_column($my_classes, 'id');
                    $this->db->where_in('academic_class.id', $class_ids);
                }
            }
        }

        $this->db->like('video_tutorial.title', $keyword);

        if ($class_section_id != null) {
            $this->db->like('video_tutorial_class_sections.class_section_id', $class_section_id);
        }
        if ($class_id != null) {
            $this->db->like('academic_class.id', $class_id);
        }
        $this->db->from("video_tutorial");
        $this->db->order_by("id", "DESC");
        $this->db->group_by('video_tutorial_class_sections.video_tutorial_id');
        $this->db->limit($limit, $start);
        $query = $this->db->get();
        return $query->result();
    }

    // TVET: Replaced class_sections/classes/sections joins with academic_class
    // $section_id param kept for compatibility but not used
    public function getvideotutorial($limit, $start, $class_id, $section_id = null)
    {
        $this->db->select('video_tutorial.*, academic_class.id as class_id, academic_class.class_code, academic_class.cohort_name, academic_subject.name as subject_name, academic_level.name as level_name, staff.name as staff_name, staff.surname as staff_surname, staff.employee_id as staff_employee_id, staff_roles.role_id', FALSE)
            ->join('staff', 'staff.id=video_tutorial.created_by', 'left')
            ->join('staff_roles', 'staff.id=staff_roles.staff_id')
            ->join('video_tutorial_class_sections', 'video_tutorial_class_sections.video_tutorial_id=video_tutorial.id')
            ->join('academic_class', 'academic_class.id=video_tutorial_class_sections.class_section_id')
            ->join('academic_subject_level', 'academic_subject_level.id=academic_class.subject_level_id', 'left')
            ->join('academic_subject', 'academic_subject.id=academic_subject_level.subject_id', 'left')
            ->join('academic_level', 'academic_level.id=academic_subject_level.level_id', 'left')
            ->from('video_tutorial');
        // TVET: class_id now = academic_class.id, no section filtering
        $this->db->where('academic_class.id', $class_id);
        if ($limit != '' && $start != '') {
            $this->db->limit($limit, $start);
        }
        $this->db->order_by('video_tutorial.id', 'DESC');
        $this->db->group_by('video_tutorial_class_sections.video_tutorial_id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function addsections($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('video_tutorial_class_sections', $data);
            $message   = UPDATE_RECORD_CONSTANT . " On Video Tutorial class sections id " . $data['id'];
            $action    = "Update";
            $record_id = $id = $data['id'];
            $this->log($message, $record_id, $action);
        } else {
            $this->db->insert('video_tutorial_class_sections', $data);
            $id        = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On Video Tutorial class sections id " . $id;
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
            return $id;
        }
    }

    // TVET: Replaced class_sections/sections joins with academic_class
    // Returns academic_class info instead of section info
    public function selectedsection($video_tutorial_id)
    {
        $this->db->select('video_tutorial_class_sections.class_section_id, academic_class.class_code, academic_class.cohort_name', FALSE)->from('video_tutorial_class_sections');
        $this->db->join('academic_class', 'academic_class.id = video_tutorial_class_sections.class_section_id');
        $this->db->where('video_tutorial_class_sections.video_tutorial_id', $video_tutorial_id);
        $query = $this->db->get();
        return $query->result_array();
    }

    // TVET: Replaced class_sections join with academic_class
    // Returns academic_class.id as class_id
    public function getclassid($video_tutorial_id)
    {
        $this->db->select('academic_class.id as class_id', FALSE)->from('video_tutorial_class_sections');
        $this->db->join('academic_class', 'academic_class.id = video_tutorial_class_sections.class_section_id');
        $this->db->where('video_tutorial_class_sections.video_tutorial_id', $video_tutorial_id);
        $this->db->group_by('academic_class.id');
        $query = $this->db->get();
        return $query->row_array();
    }

    public function delete($id, $class_section_id)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        $this->db->where("video_tutorial_id", $id);
        $this->db->where("class_section_id", $class_section_id);
        $this->db->delete('video_tutorial_class_sections');
        $message   = DELETE_RECORD_CONSTANT . " On video tutorial class sections id " . $id;
        $action    = "Delete";
        $record_id = $id;
        $this->log($message, $record_id, $action);
        //======================Code End==============================
        $this->db->trans_complete(); # Completing transaction
        /* Optional */
        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {

        }
    }

}
