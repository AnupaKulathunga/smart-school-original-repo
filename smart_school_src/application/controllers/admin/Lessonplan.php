<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Lessonplan extends Admin_Controller
{

    public function __construct()
    {
        parent::__construct();

        $this->load->library('Customlib');
        $this->sch_current_session = $this->setting_model->getCurrentSession();
        $this->staff_id            = $this->customlib->getStaffID();
        $this->load->library("datatables");
    }

    public function index()
    {
        if (!($this->rbac->hasPrivilege('manage_syllabus_status', 'can_view'))) {
            access_denied();
        }
        $this->session->set_userdata('top_menu', 'lessonplan');
        $this->session->set_userdata('sub_menu', 'admin/lessonplan');
        $data                     = array();
        // TVET: Get classes from current session
        $session                  = $this->setting_model->getCurrentSession();
        $class                    = $this->classmodel_model->getClassesBySession($session);
        $data['classlist']        = $class;
        $data['class_id']         = "";
        $data['subject_name']     = "";
        $data['lessons']          = array();
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');

        if ($this->form_validation->run() == false) {
        } else {
            $data['class_id']               = $_POST['class_id'];
            // TVET: Auto-derive subject_group_subject_id from class
            $academic_class_id              = $_POST['class_id'];
            $subject_group_subject_id       = $this->subjectgroup_model->getSubjectGroupSubjectByClass($academic_class_id);
            $subject_details                = $this->lessonplan_model->get_subjectNameBySubjectGroupSubjectId($subject_group_subject_id);
            $data['subject_name']           = $subject_details ? $subject_details['name'] . " (" . $subject_details['code'] . ")" : "";
            $lessonlist                     = $this->lessonplan_model->getlessonBysubjectid($subject_group_subject_id, $academic_class_id);

            foreach ($lessonlist as $key => $value) {

                $data['lessons'][$value['id']] = $value;
                $topics                        = $this->lessonplan_model->gettopicBylessonid($value['id'], $this->sch_current_session);
                foreach ($topics as $topic_key => $topic_value) {
                    $data['lessons'][$value['id']]['topic'][] = $topic_value;
                }
            }
        }

        $data['status'] = array('1' => '<span class="label " style="background:#0e0e0e">' . $this->lang->line('complete') . '</span>', '0' => '<span class="label " style="background:#b3b3b3">' . $this->lang->line('incomplete') . '</span>');
        $this->load->view('layout/header');
        $this->load->view('admin/lessonplan/index', $data);
        $this->load->view('layout/footer');
    }

    public function copylesson()
    {
        if (!($this->rbac->hasPrivilege('copy_old_lesson', 'can_view'))) {
            access_denied();
        }

        $this->session->set_userdata('top_menu', 'lessonplan');
        $this->session->set_userdata('sub_menu', 'admin/lessonplan');
        $data                    = array();
        $data['current_session'] = $this->sch_current_session;

        $data['no_record']        = '0';
        $session_result           = $this->session_model->get();
        $data['sessionlist']      = $session_result;
        // TVET: Get classes from current session
        $session                  = $this->setting_model->getCurrentSession();
        $class                    = $this->classmodel_model->getClassesBySession($session);
        $data['classlist']        = $class;
        $data['class_id']         = "";
        $data['subject_name']     = "";
        $data['lessons']          = array();

        $this->form_validation->set_rules('old_session_id', $this->lang->line('session'), 'trim|required|xss_clean');
        $this->form_validation->set_rules('old_class_id', $this->lang->line('class'), 'trim|required|xss_clean');

        if ($this->form_validation->run() == true) {

            $old_session_id    = $this->input->post('old_session_id');
            $old_class_id      = $this->input->post('old_class_id');
            // TVET: Auto-derive subject from class
            $academic_class_id = $old_class_id;
            $old_subject_id    = $this->subjectgroup_model->getSubjectGroupSubjectByClass($old_class_id);
            $subject_details   = $this->lessonplan_model->get_subjectNameBySubjectGroupSubjectId($old_subject_id);
            if ($subject_details['code'] == '') {
                $data['subject_name'] = $subject_details['name'];
            } else {
                $data['subject_name'] = $subject_details['name'] . " (" . $subject_details['code'] . ")";
            }
            $lessonlist        = $this->lessonplan_model->getlessonBysubjectid($old_subject_id, $academic_class_id);

            $data['no_record'] = '1';
            foreach ($lessonlist as $key => $value) {
                $data['no_record']             = '2';
                $data['lessons'][$value['id']] = $value;
                $topics                        = $this->lessonplan_model->gettopicBylessonid($value['id'], $old_session_id);
                foreach ($topics as $topic_key => $topic_value) {
                    $data['lessons'][$value['id']]['topic'][] = $topic_value;
                }
            }
        }

        $data['status'] = array('1' => '<span class="label " style="background:#0e0e0e">' . $this->lang->line('completed') . '</span>', '0' => '<span class="label " style="background:#b3b3b3">' . $this->lang->line('incomplete') . '</span>');
        $this->load->view('layout/header');
        $this->load->view('admin/lessonplan/copylesson', $data);
        $this->load->view('layout/footer');
    }

    public function lesson()
    {
        if (!($this->rbac->hasPrivilege('lesson', 'can_view'))) {
            access_denied();
        }
        $this->session->set_userdata('top_menu', 'lessonplan');
        $this->session->set_userdata('sub_menu', 'admin/lessonplan/lesson');
        // TVET: Get classes from current session
        $session = $this->setting_model->getCurrentSession();
        $class = $this->classmodel_model->getClassesBySession($session);

        $data['classlist'] = $class;
        foreach ($class as $class_key => $class_value) {
            $data['class_array'][] = $class_value->id;
        }
        $carray                   = array();
        $data['class_id']         = "";
        $userdata                 = $this->customlib->getUserData();
        $role_id                  = $userdata["role_id"];
        $staff_id                 = $userdata["id"];

        $this->load->view('layout/header');
        $this->load->view('admin/lessonplan/lesson', $data);
        $this->load->view('layout/footer');
    }

    public function createlesson()
    {
        $data['title'] = 'Add Library';
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');

        $validate = 1;
        if (!empty($_POST['lessons'])) {
            foreach ($_POST['lessons'] as $lessonkey => $lessonvalue) {
                if ($lessonvalue == '') {
                    $validate = 0;
                }
            }
        } else {
            $validate = 0;
        }

        if ($this->form_validation->run() == false) {
            $msg = array(
                'class_id' => form_error('class_id'),
            );
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } elseif ($validate == 0) {
            $msg   = array('lesson' => $this->lang->line('lesson_name_field_is_required'));
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } else {
            // TVET: Auto-derive subject_group_subject_id from class
            $academic_class_id = $_POST['class_id'];
            $subject_group_subject_id = $this->subjectgroup_model->getSubjectGroupSubjectByClass($academic_class_id);
            foreach ($_POST['lessons'] as $key => $value) {
                $data = array(
                    'subject_group_subject_id' => $subject_group_subject_id,
                    'name'                     => $value,
                    'academic_class_id'        => $academic_class_id,
                    'session_id'               => $this->sch_current_session,
                );

                $this->lessonplan_model->add_lesson($data);
            }
            $array = array('status' => 'success', 'error' => '', 'message' => $this->lang->line('success_message'));
        }
        echo json_encode($array);
    }

    public function deletelesson($id)
    {
        if (!($this->rbac->hasPrivilege('lesson', 'can_delete'))) {
            access_denied();
        }
        $this->lessonplan_model->deletelesson($id, $this->sch_current_session);
        redirect('admin/lessonplan/lesson');
    }

    public function deletelessonbulk($id, $subject_group_subject_id)
    {
        if (!($this->rbac->hasPrivilege('lesson', 'can_delete'))) {
            access_denied();
        }
        $this->lessonplan_model->deletelessonbulk($id, $this->sch_current_session, $subject_group_subject_id);
        $array = array('status' => 'success', 'error' => '', 'message' => $this->lang->line('delete_message'));
        echo json_encode($array);
    }

    public function editlesson($id, $subject_group_subject_id)
    {
        if (!($this->rbac->hasPrivilege('lesson', 'can_edit'))) {
            access_denied();
        }
        $this->session->set_userdata('top_menu', 'lessonplan');
        $this->session->set_userdata('sub_menu', 'admin/lessonplan/lesson');
        // TVET: Get classes from current session
        $session           = $this->setting_model->getCurrentSession();
        $class             = $this->classmodel_model->getClassesBySession($session);
        $data['classlist'] = $class;

        foreach ($class as $class_key => $class_value) {
            $data['class_array'][] = $class_value['id'];
        }

        $carray = array();
        $result = $this->lessonplan_model->get($this->sch_current_session, '');
        if (!empty($result)) {
            foreach ($result as $key => $value) {
                // TVET: Use academic_class_id instead of subject_group_class_sections_id
                $lesson = $this->lessonplan_model->getlesson($value["subject_group_subject_id"], $value["academic_class_id"], $this->sch_current_session);
                if ($lesson != '') {
                    $lessonname[$key] = $lesson;
                }
            }
        }
        $data['result'] = $result;
        if (!empty($lessonname)) {
            $data['lessonname'] = $lessonname;
        }

        $editresult = $this->lessonplan_model->get($this->sch_current_session, $id, $subject_group_subject_id);
        // TVET: Use academic_class_id instead of subject_group_class_sections_id
        $editlesson = $this->lessonplan_model->getlesson($editresult["subject_group_subject_id"], $editresult["academic_class_id"], $this->sch_current_session);

        $data['editlessonname']                 = $editlesson;
        // TVET: Return academic_class_id as class_id
        $data['class_id']                       = $editresult['class_id'];
        $data['lesson_subject_group_subjectid'] = $editresult['subject_group_subject_id'];
        $data['academic_class_id']              = $editresult['academic_class_id'];

        $this->load->view('layout/header');
        $this->load->view('admin/lessonplan/editlesson', $data);
        $this->load->view('layout/footer');
    }

    public function saveCopyLesson()
    {
        $data['title'] = 'Add Library';
        $this->form_validation->set_rules('topic_id[]', $this->lang->line('topic'), 'required|xss_clean');
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');

        if ($this->form_validation->run() == false) {
            $msg = array(
                'topic_id'  => form_error('topic_id[]'),
                'class_id'  => form_error('class_id'),
            );
            $array = array('status' => 0, 'error' => $msg, 'message' => '');
        } else {

            $topic         = $this->input->post('topic_id');
            $class_id      = $this->input->post('class_id');

            // TVET: Auto-derive subject_group_subject_id from class
            $academic_class_id        = $class_id;
            $subject_group_subject_id = $this->subjectgroup_model->getSubjectGroupSubjectByClass($academic_class_id);
            $data_to_be_insert = [];

            foreach ($topic as $lesson_key => $lesson_value) {
                foreach ($lesson_value as $topic_key => $topic_value) {

                    $topic_data   = $this->lessonplan_model->gettopicByID($topic_value);
                    $lesson_name  = ($topic_data->lessonname);

                    if (array_key_exists($lesson_key, $data_to_be_insert)) {

                        $data_to_be_insert[$lesson_key]['topics'][] = [
                            'status'     => 0,
                            'name'       => $topic_data->name,
                            'lesson_id'  => 0,
                            'session_id' => $this->sch_current_session

                        ];
                    } else {
                        $data_to_be_insert[$lesson_key] = array(
                            'subject_group_subject_id' => $subject_group_subject_id,
                            'name'                     => $lesson_name,
                            'academic_class_id'        => $academic_class_id,
                            'session_id'               => $this->sch_current_session,
                            'topics' => [[
                                'status'     => 0,
                                'name'       => $topic_data->name,
                                'lesson_id'  => 0,
                                'session_id' => $this->sch_current_session
                            ]]
                        );
                    }
                }
            }
            
            $insert_id = $this->lessonplan_model->add_copy_lesson($data_to_be_insert);

            $array = array('status' => 1, 'error' => '', 'message' => $this->lang->line('success_message'), 'redirect_url' => site_url('admin/lessonplan/lesson'));
        }
        echo json_encode($array);
    }

    public function updatelesson()
    {
        $can_edit      = 1;
        $data['title'] = 'Add Library';
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');
        // TVET: Auto-derive subject from class
        $academic_class_id        = $_POST['class_id'];
        $subject_group_subject_id = $this->subjectgroup_model->getSubjectGroupSubjectByClass($academic_class_id);
        $all_lessons              = $this->lessonplan_model->getlessonBysubjectid($subject_group_subject_id, $academic_class_id);
        $userdata                 = $this->customlib->getUserData();

        $role_id = $userdata["role_id"];
        if (isset($role_id) && ($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            $class_section = $this->lessonplan_model->ifclassteacher($_POST['class_id'], $userdata['id']);

            $can_edit = $class_section;
        }

        $validate = 1;
        foreach ($all_lessons as $lessonkey => $lessonvalue) {
            if (!empty($_POST['lesson_delete'])) {
                if (in_array($lessonvalue['id'], $_POST['lesson_delete'])) {
                    $validate = 1;
                }
            } elseif ($_POST['lessons_' . $lessonvalue['id']] == '') {
                $validate = 0;
            }
        }

        if (isset($_POST['lessons'])) {
            foreach ($_POST['lessons'] as $lessonkey => $lessonvalue) {
                if ($lessonvalue == '') {
                    $validate = 0;
                }
            }
        }
        if (!empty($_POST['lesson_delete'])) {
            if (count($all_lessons) == count($_POST['lesson_delete'])) {
                if (empty($_POST['topic'])) {
                    $validate = 0;
                }
            }
        }

        if ($this->form_validation->run() == false) {
            $msg = array(
                'class_id'         => form_error('class_id'),
            );
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');

        } elseif ($validate == 0) {
            $msg   = array('lesson' => $this->lang->line('lesson_name_field_is_required'));
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } elseif ($can_edit == 0) {
            $msg   = array('lesson' => $this->lang->line('you_are_not_authorised_to_update_lessons'));
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } else {

            if (isset($_POST['lesson_delete'])) {
                foreach ($_POST['lesson_delete'] as $delete_key => $delete_value) {
                    $this->lessonplan_model->deletelesson($delete_value, $this->sch_current_session);
                }
            }

            // TVET: Re-fetch lessons after deletes
            $all_lessons = $this->lessonplan_model->getlessonBysubjectid($subject_group_subject_id, $academic_class_id);

            foreach ($all_lessons as $lessonkey => $lessonvalue) {
                if (isset($_POST['lessons_' . $lessonvalue['id']])) {
                    $data = array(
                        'subject_group_subject_id' => $subject_group_subject_id,
                        'name'                     => $_POST['lessons_' . $lessonvalue['id']],
                        'academic_class_id'        => $academic_class_id,
                        'session_id'               => $this->sch_current_session,
                        'id'                       => $lessonvalue['id'],
                    );

                    $this->lessonplan_model->add_lesson($data);
                }
            }

            if (isset($_POST['lessons'])) {
                foreach ($_POST['lessons'] as $key => $value) {
                    $data = array(
                        'subject_group_subject_id' => $subject_group_subject_id,
                        'name'                     => $value,
                        'academic_class_id'        => $academic_class_id,
                        'session_id'               => $this->sch_current_session,
                    );

                    $this->lessonplan_model->add_lesson($data);
                }
            }
            $array = array('status' => 'success', 'error' => '', 'message' => $this->lang->line('success_message'));
        }
        echo json_encode($array);
    }

    //==================================Topic Start===============================
    public function topic()
    {
        if (!($this->rbac->hasPrivilege('topic', 'can_view'))) {
            access_denied();
        }

        $this->session->set_userdata('top_menu', 'lessonplan');
        $this->session->set_userdata('sub_menu', 'admin/lessonplan/topic');
        // TVET: Get classes from current session
        $session           = $this->setting_model->getCurrentSession();
        $class             = $this->classmodel_model->getClassesBySession($session);
        $data['classlist'] = $class;
        foreach ($class as $class_key => $class_value) {
            $data['class_array'][] = $class_value['id'];
        }
        $carray                   = array();
        $data['class_id']         = "";
        $this->load->view('layout/header');
        $this->load->view('admin/lessonplan/topic', $data);
        $this->load->view('layout/footer');
    }

    public function getlessonBysubjectid($sub_id = 0)
    {
        // TVET: Use academic_class_id directly (class_id is the academic_class_id)
        $academic_class_id = $this->input->post('class_id');
        // TVET: Auto-derive subject from class if sub_id is 0
        if (empty($sub_id) && !empty($academic_class_id)) {
            $sub_id = $this->subjectgroup_model->getSubjectGroupSubjectByClass($academic_class_id);
        }
        $data = $this->lessonplan_model->getlessonBysubjectid($sub_id, $academic_class_id);

        echo json_encode($data);
    }

    public function getlessonBylessonid($lesson_id)
    {
        $data = $this->lessonplan_model->getlessonBylessonid($lesson_id);
        echo json_encode($data);
    }

    public function getlessonBysubjectidedit($sub_id)
    {
        // TVET: Use academic_class_id instead of subject_group_class_sections_id
        $academic_class_id = $this->input->post('academic_class_id');
        $data              = $this->lessonplan_model->getlessonBysubjectidedit($sub_id, $academic_class_id);
        echo json_encode($data);
    }

    public function createtopic()
    {
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');
        // TVET: subject auto-derived from class
        $this->form_validation->set_rules('lesson_id', $this->lang->line('lesson'), 'trim|required|xss_clean');

        $validate = 1;
        if (!empty($_POST['topic'])) {
            foreach ($_POST['topic'] as $topickey => $topicvalue) {
                if ($topicvalue == '') {
                    $validate = 0;
                }
            }
        } else {
            $validate = 0;
        }
        if ($this->form_validation->run() == false) {

            $msg = array(
                'class_id'         => form_error('class_id'),
                'lesson_id'        => form_error('lesson_id'),
            );

            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } elseif ($validate == 0) {
            $msg   = array('topic' => $this->lang->line('topic_name_field_is_required'));
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } else {

            foreach ($_POST['topic'] as $key => $value) {
                $data = array(
                    'lesson_id'  => $_POST['lesson_id'],
                    'name'       => $value,
                    'session_id' => $this->sch_current_session,
                    'complete_date' => NULL,
                );
                $this->lessonplan_model->add_topic($data);
            }
            $array = array('status' => 'success', 'error' => '', 'message' => $this->lang->line('success_message'));
        }
        echo json_encode($array);
    }

    public function deletetopicbulk($id)
    {
        if (!($this->rbac->hasPrivilege('topic', 'can_delete'))) {
            access_denied();
        }
        $this->lessonplan_model->deletetopicbulk($id, $this->sch_current_session);
        redirect('admin/lessonplan/topic');
    }

    public function edittopic($id)
    {
        if (!($this->rbac->hasPrivilege('topic', 'can_edit'))) {
            access_denied();
        }
        $this->session->set_userdata('top_menu', 'lessonplan');
        $this->session->set_userdata('sub_menu', 'admin/lessonplan/topic');
        // TVET: Get classes from current session
        $session           = $this->setting_model->getCurrentSession();
        $class             = $this->classmodel_model->getClassesBySession($session);
        $data['classlist'] = $class;
        foreach ($class as $class_key => $class_value) {
            $data['class_array'][] = $class_value['id'];
        }
        $carray = array();

        $result = $this->lessonplan_model->gettopic($this->sch_current_session, '');

        if (!empty($result)) {
            foreach ($result as $key => $value) {
                $topic             = $this->lessonplan_model->gettopicBylessonid($value["lesson_id"], $this->sch_current_session);
                $topicresult[$key] = $topic;
            }
        }

        $data['result'] = $result;
        if (!empty($topicresult)) {
            $data['topicresult'] = $topicresult;
        }

        $editresult                              = $this->lessonplan_model->gettopic($this->sch_current_session, $id);
        $edittopic                               = $this->lessonplan_model->gettopicBylessonid($editresult["lesson_id"], $this->sch_current_session);
        $data['lesson_id']                      = $editresult["lesson_id"];
        $data['topic_lesson_id']                = $id;
        $data['edittopicname']                  = $edittopic;
        // TVET: Use class_id from academic_class
        $data['class_id']                       = $editresult['class_id'];
        $data['lesson_subject_group_subjectid'] = $editresult['subject_group_subject_id'];
        $data['academic_class_id']              = $editresult['academic_class_id'];

        $this->load->view('layout/header');
        $this->load->view('admin/lessonplan/edittopic', $data);
        $this->load->view('layout/footer');
    }

    public function updatetopic()
    {
        $can_edit = 1;
        $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');
        // TVET: subject auto-derived from class
        $this->form_validation->set_rules('lesson_id', $this->lang->line('lesson'), 'trim|required|xss_clean');

        $validate = 1;
        $alltopic = $this->lessonplan_model->gettopicBylessonid($_POST['lesson_id'], $this->sch_current_session);
        $userdata = $this->customlib->getUserData();
        $role_id  = $userdata["role_id"];
        if (isset($role_id) && ($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            $class_section = $this->lessonplan_model->ifclassteacher($_POST['class_id'], $this->staff_id);

            $can_edit = $class_section;
        }

        foreach ($alltopic as $topickey => $topicvalue) {
            if (!empty($_POST['topic_delete'])) {
                if (in_array($topicvalue['id'], $_POST['topic_delete'])) {
                    $validate = 1;
                }
            } elseif ($_POST['topic_' . $topicvalue['id']] == '') {
                $validate = 0;
            }
        }

        if (!empty($_POST['topic'])) {
            foreach ($_POST['topic'] as $topickey => $topicvalue) {
                if ($topicvalue == '') {
                    $validate = 0;
                }
            }
        }

        if (!empty($_POST['topic_delete'])) {
            if (count($alltopic) == count($_POST['topic_delete'])) {
                if (empty($_POST['topic'])) {
                    $validate = 0;
                }
            }
        }

        if ($this->form_validation->run() == false) {
            $msg = array(
                'class_id'         => form_error('class_id'),
                'lesson_id'        => form_error('lesson_id'),
            );
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } elseif ($validate == 0) {
            $msg   = array('topic' => $this->lang->line('topic_name_field_is_required'));
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } elseif ($can_edit == 0) {
            $msg   = array('topic' => $this->lang->line('you_are_not_authorised_to_update_topics'));
            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } else {

            if (isset($_POST['topic_delete'])) {
                foreach ($_POST['topic_delete'] as $delete_key => $delete_value) {
                    $this->lessonplan_model->deletetopic($delete_value, $this->sch_current_session);
                }
            }

            $alltopic = $this->lessonplan_model->gettopicBylessonid($_POST['lesson_id'], $this->sch_current_session);

            foreach ($alltopic as $topickey => $topicvalue) {
                if (isset($_POST['topic_' . $topicvalue['id']])) {
                    $data = array(
                        'lesson_id'  => $_POST['lesson_id'],
                        'name'       => $_POST['topic_' . $topicvalue['id']],
                        'session_id' => $this->sch_current_session,
                        'id'         => $topicvalue['id'],
                    );

                    $this->lessonplan_model->add_topic($data);
                }
            }
            if (isset($_POST['topic'])) {
                foreach ($_POST['topic'] as $key => $value) {
                    $data = array(
                        'lesson_id'  => $_POST['lesson_id'],
                        'name'       => $value,
                        'session_id' => $this->sch_current_session,
                    );

                    $this->lessonplan_model->add_topic($data);
                }
            }
            $array = array('status' => 'success', 'error' => '', 'message' => $this->lang->line('success_message'));
        }
        echo json_encode($array);
    }

    public function changeTopicStatus()
    {
        $id     = $this->input->post('id');
        $status = $this->input->post('status');
        $data   = array('id' => $id, 'complete_date' => '0000-00-00', 'status' => $status);
        $result = $this->lessonplan_model->changeTopicStatus($data);

        if ($result) {
            $response = array('status' => 1, 'msg' => $this->lang->line('success_message'));
            echo json_encode($response);
        }
    }

    public function topic_completedate()
    {
        $this->form_validation->set_rules('date', $this->lang->line('date'), 'trim|required|xss_clean');
        if ($this->form_validation->run() == false) {

            $msg = array(
                'date' => form_error('date'),
            );

            $array = array('status' => 'fail', 'error' => $msg, 'message' => '');
        } else {

            $data = array(
                'complete_date' => date('Y-m-d', $this->customlib->datetostrtotime($this->input->post('date'))),
                'status'        => 1,
                'id'            => $_POST['id'],
            );

            $this->lessonplan_model->changeTopicStatus($data);
            $array = array('status' => 'success', 'error' => '', 'message' => $this->lang->line('success_message'));
        }
        echo json_encode($array);
    }

    //==========================================Syllabus-Assign=========================

    public function gettopicBylessonid($lessonid)
    {
        $data = $this->lessonplan_model->gettopicBylessonid($lessonid, $this->sch_current_session);
        echo json_encode($data);
    }

    public function get_topicbyid()
    {
        $this->lessonplan_model->gettopic($this->sch_current_session, '');
    }

    public function gettopiclist()
    {
        // TVET: Get classes from current session
        $session           = $this->setting_model->getCurrentSession();
        $class             = $this->classmodel_model->getClassesBySession($session);
        $data['classlist'] = $class;
        foreach ($class as $class_key => $class_value) {
            $class_array[] = $class_value['id'];
        }
        $carray                   = array();
        $data['class_id']         = "";
        $result                   = $this->lessonplan_model->gettopiclist($this->sch_current_session);
        $m                        = json_decode($result);
        $currency_symbol          = $this->customlib->getSchoolCurrencyFormat();
        $dt_data                  = array();
        if (!empty($m->data)) {
            foreach ($m->data as $key => $value) {
                $topic1    = '';
                $topic     = "";
                $lesson_id = $key;
                $topic     = $this->lessonplan_model->gettopicBylessonid($value->lesson_id, $this->sch_current_session);
                if ($this->rbac->hasPrivilege('topic', 'can_edit')) {
                    $editbtn = "<a href='" . base_url() . "admin/lessonplan/edittopic/" . $value->lesson_id . "'   class='btn btn-default btn-xs'  data-toggle='tooltip'  title='" . $this->lang->line('edit') . "'><i class='fa fa-pencil'></i></a>";
                } else {
                    $editbtn = '';
                }
                if ($this->rbac->hasPrivilege('topic', 'can_delete')) {
                    $deletebtn = "<a href='" . base_url() . "admin/lessonplan/deletetopicbulk/" . $value->lesson_id . "' onclick='return confirm(" . '"' . $this->lang->line('delete_confirm') . '"' . ");'  class='btn btn-default btn-xs'  title='" . $this->lang->line('delete') . "' data-toggle='tooltip'><i class='fa fa-trash'></i></a>";
                } else {
                    $deletebtn = '';
                }

                foreach ($topic as $rl_value) {
                    $topic = $rl_value['name'] . '<br>';
                    $topic1 .= $topic;
                }

                $code = '';
                if ($value->subjects_code) {
                    $code = ' (' . $value->subjects_code . ')';
                }

                // TVET: Check against class_id from academic_class
                if (in_array($value->class_id, $class_array)) {
                    $lesson_id = $key;
                    $row       = array();
                    // TVET: Display class_code from academic_class
                    $row[]     = $value->class_code . ' - ' . $value->cohort_name;
                    $row[]     = $value->subname . '' . $code;
                    $row[]     = $value->lessonname;
                    $row[]     = $topic1;
                    $row[]     = $editbtn . ' ' . $deletebtn;
                    $dt_data[] = $row;
                }
            }
        }

        $json_data = array(
            "draw"            => intval($m->draw),
            "recordsTotal"    => intval($m->recordsTotal),
            "recordsFiltered" => intval($m->recordsFiltered),
            "data"            => $dt_data,
        );
        echo json_encode($json_data);
    }

    public function getlessonlist()
    {
        // TVET: Use classmodel_model to get classes for current session
        $session_id = $this->setting_model->getCurrentSession();
        $class = $this->classmodel_model->getClassesBySession($session_id);
        foreach ($class as $class_key => $class_value) {
            $class_array[] = $class_value->id; // Object property access
        }
        $result  = $this->lessonplan_model->getlessonlist($this->sch_current_session, '');
        $m       = json_decode($result);
        $dt_data = array();
        if (!empty($m->data)) {
            foreach ($m->data as $key => $value) {

                $topic       = "";
                $lesson_id   = $key;
                $lesson_name = "";
                // TVET: Use academic_class_id instead of subject_group_class_sections_id
                $lesson      = $this->lessonplan_model->getlesson($value->subject_group_subject_id, $value->academic_class_id, $this->sch_current_session);

                if ($this->rbac->hasPrivilege('lesson', 'can_edit')) {
                    // TVET: Use academic_class_id instead of subject_group_class_sections_id
                    $editbtn = "<a href='" . base_url() . "admin/lessonplan/editlesson/" . $value->academic_class_id . "/" . $value->subject_group_subject_id . "'   class='btn btn-default btn-xs'  data-toggle='tooltip'  title='" . $this->lang->line('edit') . "'><i class='fa fa-pencil'></i></a>";
                } else {
                    $editbtn = '';
                }

                if ($this->rbac->hasPrivilege('lesson', 'can_delete')) {
                    // TVET: Use academic_class_id instead of subject_group_class_sections_id
                    $deletebtn = "<a onclick='deletelessonbulk(" . '"' . $value->academic_class_id . '"' . ',' . '"' . $value->subject_group_subject_id . '"' . "  )'  class='btn btn-default btn-xs'  title='" . $this->lang->line('delete') . "' data-toggle='tooltip'><i class='fa fa-remove'></i></a>";
                } else {
                    $deletebtn = '';
                }

                // TVET: Check against class_id from academic_class
                if (in_array($value->class_id, $class_array)) {

                    foreach ($lesson as $rl_value) {
                        $lesson_name .= $rl_value['name'] . '<br>';
                    };

                    $code = '';
                    if ($value->subjects_code) {
                        $code = ' (' . $value->subjects_code . ')';
                    }
                    $row       = array();
                    // TVET: Display class_code and cohort_name from academic_class
                    $row[]     = $value->class_code . ' - ' . $value->cohort_name;
                    // TVET: Display subject code and level
                    $row[]     = $value->subname . ' ' . $code;
                    $row[]     = $lesson_name;
                    $row[]     = $editbtn . ' ' . $deletebtn;
                    $dt_data[] = $row;
                }
            }
        }

        $json_data = array(
            "draw"            => intval($m->draw),
            "recordsTotal"    => intval($m->recordsTotal),
            "recordsFiltered" => intval($m->recordsFiltered),
            "data"            => $dt_data,
        );
        echo json_encode($json_data);
    }
}
