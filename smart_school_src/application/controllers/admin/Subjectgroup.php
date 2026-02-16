<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Subjectgroup extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();
    }

    public function index()
    {
        if (!$this->rbac->hasPrivilege('subject_group', 'can_view')) {
            access_denied();
        }

        $this->session->set_userdata('top_menu', 'Academics');
        $this->session->set_userdata('sub_menu', 'subjectgroup/index');
        $data['title']         = 'Add Subject Group';
        $data['title_list']    = 'Subject Group List';
        // TVET: Use classmodel_model to get classes for current session
        $session_id            = $this->setting_model->getCurrentSession();
        $class                 = $this->classmodel_model->getClassesBySession($session_id);
        $data['classlist']     = $class;

        $this->form_validation->set_rules(
            'name', $this->lang->line('name'), array(
                'required',
                array('class_exists', array($this->subjectgroup_model, 'class_exists')),
            )
        );

        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');

        $this->form_validation->set_rules('subject[]', $this->lang->line('subject'), 'trim|required|xss_clean');

        if ($this->form_validation->run() == false) {

        } else {
            $session     = $this->setting_model->getCurrentSession();
            $class_array = array(
                'name'        => $this->input->post('name'),
                'session_id'  => $session,
                'description' => $this->input->post('description'),
            );
            $subject  = $this->input->post('subject');
            // TVET: Use class_id directly — no sections in TVET
            $sections = array($this->input->post('class_id'));

            $this->subjectgroup_model->add($class_array, $subject, $sections);
            $this->session->set_flashdata('msg', '<div class="alert alert-success text-left">' . $this->lang->line('success_message') . '</div>');
            redirect('admin/subjectgroup');
        }
        $subject_list             = $this->subject_model->get();
        $data['subjectlist']      = $subject_list;
        $subjectgroupList         = $this->subjectgroup_model->getByID();
        $data['subjectgroupList'] = $subjectgroupList;
        $this->load->view('layout/header', $data);
        $this->load->view('admin/subjectgroup/subjectgroupList', $data);
        $this->load->view('layout/footer', $data);
    }

    public function delete($id)
    {
        if (!$this->rbac->hasPrivilege('subject_group', 'can_delete')) {
            access_denied();
        }
        $data['title'] = 'Fees Master List';
        $this->subjectgroup_model->remove($id);
        redirect('admin/subjectgroup');
    }

    public function edit($id)
    {
        if (!$this->rbac->hasPrivilege('subject_group', 'can_edit')) {
            access_denied();
        }

        $this->session->set_userdata('top_menu', 'Academics');
        $this->session->set_userdata('sub_menu', 'subjectgroup/index');
        $old_sections      = array();
        $old_subjects      = array();
        $data['title']     = 'Edit Subject Group';
        $data['id']        = $id;
        // TVET: Use classmodel_model to get classes for current session
        $session_id        = $this->setting_model->getCurrentSession();
        $class             = $this->classmodel_model->getClassesBySession($session_id);
        $data['classlist'] = $class;

        $subject_list             = $this->subject_model->get();
        $data['subjectlist']      = $subject_list;
        $subjectgroupList         = $this->subjectgroup_model->getByID();
        $data['class_id']         = 0;
        $data['subjectgroupList'] = $subjectgroupList;
        $subjectgroup             = $this->subjectgroup_model->getByID($id);

        if (!empty($subjectgroup[0]->sections)) {
            // TVET: class_id = academic_class.id, class_section_id also = academic_class.id
            $data['class_id'] = $subjectgroup[0]->sections[0]->class_id;
            foreach ($subjectgroup[0]->sections as $key => $value) {
                $old_sections[] = ($value->class_section_id);
            }
        }
        if (!empty($subjectgroup[0]->group_subject)) {

            foreach ($subjectgroup[0]->group_subject as $key => $value) {

                $old_subjects[] = $value->subject_id;
            }
        }

        $data['subjectgroup'] = $subjectgroup;
        $this->form_validation->set_rules(
            'name', $this->lang->line('name'), array(
                'required',
                array('class_exists', array($this->subjectgroup_model, 'class_exists')),
            )
        );

        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');

        $this->form_validation->set_rules('subject[]', $this->lang->line('subject'), 'trim|required|xss_clean');

        if ($this->form_validation->run() == false) {
            $this->load->view('layout/header', $data);
            $this->load->view('admin/subjectgroup/subjectgroupEdit', $data);
            $this->load->view('layout/footer', $data);
        } else {

            $class_array = array(
                'id'          => $this->input->post('id'),
                'name'        => $this->input->post('name'),
                'description' => $this->input->post('description'),
            );
            $subject         = $this->input->post('subject');
            // TVET: Use class_id directly — no sections in TVET
            $sections        = array($this->input->post('class_id'));
            $delete_sections = array_diff($old_sections, $sections);
            $add_sections    = array_diff($sections, $old_sections);
            $delete_subjects = array_diff($old_subjects, $subject);
            $add_subjects    = array_diff($subject, $old_subjects);
            $this->subjectgroup_model->edit($class_array, $delete_sections, $add_sections, $delete_subjects, $add_subjects);
            redirect('admin/subjectgroup');
        }
    }

    public function addsubjectgroup()
    {
        $this->form_validation->set_rules('subject_group_id', $this->lang->line('fee_group'), 'required|trim|xss_clean');

        if ($this->form_validation->run() == false) {
            $data = array(
                'subject_group_id' => form_error('subject_group_id'),
            );
            $array = array('status' => 'fail', 'error' => $data);
            echo json_encode($array);
        } else {
            $student_session_id     = $this->input->post('student_session_id');
            $subject_group_id       = $this->input->post('subject_group_id');
            $student_sesssion_array = isset($student_session_id) ? $student_session_id : array();
            $student_ids            = $this->input->post('student_ids');
            $delete_student         = array_diff($student_ids, $student_sesssion_array);

            $preserve_record = array();
            if (!empty($student_sesssion_array)) {
                foreach ($student_sesssion_array as $key => $value) {

                    $insert_array = array(
                        'student_session_id' => $value,
                        'subject_group_id'   => $subject_group_id,
                    );
                    $inserted_id       = $this->studentsubjectgroup_model->add($insert_array);
                    $preserve_record[] = $inserted_id;
                }
            }

            if (!empty($delete_student)) {
                $this->studentsubjectgroup_model->delete($subject_group_id, $delete_student);
            }

            $array = array('status' => 'success', 'error' => '', 'message' => $this->lang->line('success_message'));
            echo json_encode($array);
        }
    }

    public function getGroupByClassandSection()
    {
        $class_id   = $this->input->post('class_id');
        // TVET: section_id ignored in TVET mode
        $session_id = $this->input->post('session_id');
        if(!isset($session_id)){
            $session_id=NULL;
        }
        // TVET: Use getGroupByClass() - no section_id parameter
        $data       = $this->subjectgroup_model->getGroupByClass($class_id, $session_id);

        // TVET: Auto-create subject group if none exists for this class
        if (empty($data) && !empty($class_id)) {
            $this->_autoCreateSubjectGroupForClass($class_id);
            $data = $this->subjectgroup_model->getGroupByClass($class_id, $session_id);
        }

        echo json_encode($data);
    }

    // TVET: Alias for views that call getGroupByClass directly (timetable, lesson plan)
    // Auto-creates a subject group for TVET classes that don't have one yet
    public function getGroupByClass()
    {
        $class_id   = $this->input->post('class_id');
        $session_id = $this->input->post('session_id');
        if(!isset($session_id)){
            $session_id=NULL;
        }
        $data = $this->subjectgroup_model->getGroupByClass($class_id, $session_id);

        // TVET: Auto-create subject group if none exists for this class
        if (empty($data) && !empty($class_id)) {
            $this->_autoCreateSubjectGroupForClass($class_id);
            // Re-query after creation
            $data = $this->subjectgroup_model->getGroupByClass($class_id, $session_id);
        }

        echo json_encode($data);
    }

    /**
     * TVET: Auto-create a subject group for an academic class
     * In TVET, each class = one subject, so we create a group with that single subject
     */
    private function _autoCreateSubjectGroupForClass($class_id)
    {
        // Get class details including subject info
        $class_info = $this->classmodel_model->getClassById($class_id);
        if (empty($class_info)) {
            return;
        }

        // Get the subject_id from academic_class -> academic_subject_level -> academic_subject
        $subject_level = $this->db->select('asl.subject_id, asub.name as subject_name, al.code as level_code')
            ->from('academic_class ac')
            ->join('academic_subject_level asl', 'asl.id = ac.subject_level_id')
            ->join('academic_subject asub', 'asub.id = asl.subject_id')
            ->join('academic_level al', 'al.id = asl.level_id')
            ->where('ac.id', $class_id)
            ->get()->row();

        if (empty($subject_level)) {
            return;
        }

        $session_id = $this->setting_model->getCurrentSession();

        // Create the subject group
        $group_name = $subject_level->subject_name . ' - ' . $subject_level->level_code;
        $group_data = array(
            'name'        => $group_name,
            'session_id'  => $session_id,
            'description' => 'Auto-created for TVET class',
        );
        $subjects = array($subject_level->subject_id);
        $sections = array($class_id);

        $this->subjectgroup_model->add($group_data, $subjects, $sections);
    }

    public function getSubjectByClassandSectionDate()
    {
        $date       = date('Y-m-d', $this->customlib->datetostrtotime($this->input->post('date')));
        $day        = date('l', strtotime($date));
        $class_id   = $this->input->post('class_id');
        // TVET: section_id ignored in TVET mode
        // TVET: Use getSubjectByClassDay() - no section_id parameter
        $data       = $this->subjecttimetable_model->getSubjectByClassDay($class_id, $day);
        echo json_encode($data);
    }

    public function getAllSubjectByClassandSection()
    {
        $class_id   = $this->input->post('class_id');
        // TVET: section_id ignored in TVET mode
        // TVET: Use getAllSubjectByClass() - no section_id parameter
        $data       = $this->subjectgroup_model->getAllSubjectByClass($class_id);
        echo json_encode($data);
    }

    public function getSubjectByClassandSection()
    {
        $class_id   = $this->input->post('class_id');
        // TVET: section_id ignored in TVET mode
        // TVET: Use getSubjectByClass() - no section_id parameter
        $data       = $this->subjecttimetable_model->getSubjectByClass($class_id);
        echo json_encode($data);
    }

    public function getGroupsubjects()
    {
        $subject_group_id = $this->input->post('subject_group_id');
         $session_id = $this->input->post('session_id');
        if(!isset($session_id)){
            $session_id=NULL;
        }
        $data             = $this->subjectgroup_model->getGroupsubjects($subject_group_id,$session_id);      
        echo json_encode($data);
    }

}
