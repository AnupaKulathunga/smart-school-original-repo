<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Academic Controller
 * Subject-Centric TVET College Management
 * CLASS = Subject + Level + Cohort + Year + Lecturer
 */
class Academic extends Admin_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model(array(
            'academic_programme_model',
            'academic_subject_model',
            'academic_level_model',
            'academic_subject_level_model',
            'academic_class_model',
            'academic_enrolment_model',
            'academic_attendance_model',
            'academic_assessment_model',
            'academic_marks_model'
        ));
    }

    // =========================================================================
    // DASHBOARD
    // =========================================================================

    public function index()
    {
        if (!$this->rbac->hasPrivilege('academic_dashboard', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('academic_management') ?: 'Academic Management';

        // Statistics
        $data['stats'] = array(
            'programmes' => $this->db->where('is_active', 1)->count_all_results('academic_programme'),
            'subjects' => $this->db->where('is_active', 1)->count_all_results('academic_subject'),
            'levels' => $this->db->where('is_active', 1)->count_all_results('academic_level'),
            'classes' => $this->db->where('is_active', 1)->count_all_results('academic_class'),
            'enrolled' => $this->db->where('status', 'Active')->count_all_results('academic_class_enrolment'),
            'assessments' => $this->db->count_all_results('academic_assessment')
        );

        // Recent classes
        $data['recent_classes'] = $this->academic_class_model->getAll(array('is_active' => 1));

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/dashboard', $data);
        $this->load->view('layout/footer');
    }

    // =========================================================================
    // PROGRAMMES
    // =========================================================================

    public function programmes()
    {
        if (!$this->rbac->hasPrivilege('academic_programmes', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('programmes') ?: 'Programmes';
        $data['programmes'] = $this->academic_programme_model->getAll(false);

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/programme/index', $data);
        $this->load->view('layout/footer');
    }

    public function programme_add()
    {
        if (!$this->rbac->hasPrivilege('academic_programmes', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('code', 'Code', 'required|trim|max_length[20]');
        $this->form_validation->set_rules('name', 'Name', 'required|trim|max_length[200]');

        if ($this->form_validation->run() == true) {
            $data = array(
                'code' => $this->input->post('code'),
                'name' => $this->input->post('name'),
                'description' => $this->input->post('description'),
                'qualification_type' => $this->input->post('qualification_type'),
                'is_active' => $this->input->post('is_active') ? 1 : 0
            );

            if ($this->academic_programme_model->codeExists($data['code'])) {
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">Programme code already exists</div>');
            } else {
                $this->academic_programme_model->add($data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Programme added successfully</div>');
            }
            redirect('admin/academic/programmes');
        }

        $data['title'] = 'Add Programme';
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/programme/form', $data);
        $this->load->view('layout/footer');
    }

    public function programme_edit($id)
    {
        if (!$this->rbac->hasPrivilege('academic_programmes', 'can_edit')) {
            access_denied();
        }

        $data['programme'] = $this->academic_programme_model->get($id);
        if (!$data['programme']) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Programme not found</div>');
            redirect('admin/academic/programmes');
        }

        $this->form_validation->set_rules('code', 'Code', 'required|trim|max_length[20]');
        $this->form_validation->set_rules('name', 'Name', 'required|trim|max_length[200]');

        if ($this->form_validation->run() == true) {
            $update_data = array(
                'code' => $this->input->post('code'),
                'name' => $this->input->post('name'),
                'description' => $this->input->post('description'),
                'qualification_type' => $this->input->post('qualification_type'),
                'is_active' => $this->input->post('is_active') ? 1 : 0
            );

            if ($this->academic_programme_model->codeExists($update_data['code'], $id)) {
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">Programme code already exists</div>');
            } else {
                $this->academic_programme_model->update($id, $update_data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Programme updated successfully</div>');
            }
            redirect('admin/academic/programmes');
        }

        $data['title'] = 'Edit Programme';
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/programme/form', $data);
        $this->load->view('layout/footer');
    }

    public function programme_delete($id)
    {
        if (!$this->rbac->hasPrivilege('academic_programmes', 'can_delete')) {
            access_denied();
        }

        $this->academic_programme_model->delete($id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Programme deleted successfully</div>');
        redirect('admin/academic/programmes');
    }

    // =========================================================================
    // SUBJECTS
    // =========================================================================

    public function subjects()
    {
        if (!$this->rbac->hasPrivilege('academic_subjects', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('subjects') ?: 'Subjects';
        $data['subjects'] = $this->academic_subject_model->getAll(false);
        $data['programmes'] = $this->academic_programme_model->getAll();

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/subject/index', $data);
        $this->load->view('layout/footer');
    }

    public function subject_add()
    {
        if (!$this->rbac->hasPrivilege('academic_subjects', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('programme_id', 'Programme', 'required');
        $this->form_validation->set_rules('code', 'Code', 'required|trim|max_length[20]');
        $this->form_validation->set_rules('name', 'Name', 'required|trim|max_length[200]');

        if ($this->form_validation->run() == true) {
            $data = array(
                'programme_id' => $this->input->post('programme_id'),
                'code' => $this->input->post('code'),
                'name' => $this->input->post('name'),
                'description' => $this->input->post('description'),
                'credits' => $this->input->post('credits') ?: 0,
                'notional_hours' => $this->input->post('notional_hours') ?: 0,
                'is_core' => $this->input->post('is_core') ? 1 : 0,
                'is_active' => $this->input->post('is_active') ? 1 : 0
            );

            if ($this->academic_subject_model->codeExists($data['code'], $data['programme_id'])) {
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">Subject code already exists in this programme</div>');
            } else {
                $this->academic_subject_model->add($data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Subject added successfully</div>');
            }
            redirect('admin/academic/subjects');
        }

        $data['title'] = 'Add Subject';
        $data['programmes'] = $this->academic_programme_model->getAll();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/subject/form', $data);
        $this->load->view('layout/footer');
    }

    public function subject_edit($id)
    {
        if (!$this->rbac->hasPrivilege('academic_subjects', 'can_edit')) {
            access_denied();
        }

        $data['subject'] = $this->academic_subject_model->get($id);
        if (!$data['subject']) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Subject not found</div>');
            redirect('admin/academic/subjects');
        }

        $this->form_validation->set_rules('programme_id', 'Programme', 'required');
        $this->form_validation->set_rules('code', 'Code', 'required|trim|max_length[20]');
        $this->form_validation->set_rules('name', 'Name', 'required|trim|max_length[200]');

        if ($this->form_validation->run() == true) {
            $update_data = array(
                'programme_id' => $this->input->post('programme_id'),
                'code' => $this->input->post('code'),
                'name' => $this->input->post('name'),
                'description' => $this->input->post('description'),
                'credits' => $this->input->post('credits') ?: 0,
                'notional_hours' => $this->input->post('notional_hours') ?: 0,
                'is_core' => $this->input->post('is_core') ? 1 : 0,
                'is_active' => $this->input->post('is_active') ? 1 : 0
            );

            if ($this->academic_subject_model->codeExists($update_data['code'], $update_data['programme_id'], $id)) {
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">Subject code already exists in this programme</div>');
            } else {
                $this->academic_subject_model->update($id, $update_data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Subject updated successfully</div>');
            }
            redirect('admin/academic/subjects');
        }

        $data['title'] = 'Edit Subject';
        $data['programmes'] = $this->academic_programme_model->getAll();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/subject/form', $data);
        $this->load->view('layout/footer');
    }

    public function subject_delete($id)
    {
        if (!$this->rbac->hasPrivilege('academic_subjects', 'can_delete')) {
            access_denied();
        }

        $this->academic_subject_model->delete($id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Subject deleted successfully</div>');
        redirect('admin/academic/subjects');
    }

    // =========================================================================
    // LEVELS
    // =========================================================================

    public function levels()
    {
        if (!$this->rbac->hasPrivilege('academic_levels', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('levels') ?: 'Levels';
        $data['levels'] = $this->academic_level_model->getAll(false);

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/level/index', $data);
        $this->load->view('layout/footer');
    }

    public function level_add()
    {
        if (!$this->rbac->hasPrivilege('academic_levels', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('code', 'Code', 'required|trim|max_length[20]');
        $this->form_validation->set_rules('name', 'Name', 'required|trim|max_length[100]');

        if ($this->form_validation->run() == true) {
            $data = array(
                'code' => $this->input->post('code'),
                'name' => $this->input->post('name'),
                'level_type' => $this->input->post('level_type'),
                'nqf_level' => $this->input->post('nqf_level') ?: null,
                'sequence' => $this->input->post('sequence') ?: 1,
                'is_active' => $this->input->post('is_active') ? 1 : 0
            );

            if ($this->academic_level_model->codeExists($data['code'])) {
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">Level code already exists</div>');
            } else {
                $this->academic_level_model->add($data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Level added successfully</div>');
            }
            redirect('admin/academic/levels');
        }

        $data['title'] = 'Add Level';
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/level/form', $data);
        $this->load->view('layout/footer');
    }

    public function level_edit($id)
    {
        if (!$this->rbac->hasPrivilege('academic_levels', 'can_edit')) {
            access_denied();
        }

        $data['level'] = $this->academic_level_model->get($id);
        if (!$data['level']) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Level not found</div>');
            redirect('admin/academic/levels');
        }

        $this->form_validation->set_rules('code', 'Code', 'required|trim|max_length[20]');
        $this->form_validation->set_rules('name', 'Name', 'required|trim|max_length[100]');

        if ($this->form_validation->run() == true) {
            $update_data = array(
                'code' => $this->input->post('code'),
                'name' => $this->input->post('name'),
                'level_type' => $this->input->post('level_type'),
                'nqf_level' => $this->input->post('nqf_level') ?: null,
                'sequence' => $this->input->post('sequence') ?: 1,
                'is_active' => $this->input->post('is_active') ? 1 : 0
            );

            if ($this->academic_level_model->codeExists($update_data['code'], $id)) {
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">Level code already exists</div>');
            } else {
                $this->academic_level_model->update($id, $update_data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Level updated successfully</div>');
            }
            redirect('admin/academic/levels');
        }

        $data['title'] = 'Edit Level';
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/level/form', $data);
        $this->load->view('layout/footer');
    }

    public function level_delete($id)
    {
        if (!$this->rbac->hasPrivilege('academic_levels', 'can_delete')) {
            access_denied();
        }

        $this->academic_level_model->delete($id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Level deleted successfully</div>');
        redirect('admin/academic/levels');
    }

    // =========================================================================
    // SUBJECT-LEVEL MAPPING
    // =========================================================================

    public function subject_levels()
    {
        if (!$this->rbac->hasPrivilege('academic_subjects', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('subject_level_mapping') ?: 'Subject-Level Mapping';
        $data['mappings'] = $this->academic_subject_level_model->getAll(false);
        $data['subjects'] = $this->academic_subject_model->getAll();
        $data['levels'] = $this->academic_level_model->getAll();

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/subject_level/index', $data);
        $this->load->view('layout/footer');
    }

    public function subject_level_add()
    {
        if (!$this->rbac->hasPrivilege('academic_subjects', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('subject_id', 'Subject', 'required');
        $this->form_validation->set_rules('level_id', 'Level', 'required');

        if ($this->form_validation->run() == true) {
            $data = array(
                'subject_id' => $this->input->post('subject_id'),
                'level_id' => $this->input->post('level_id'),
                'syllabus_code' => $this->input->post('syllabus_code'),
                'is_active' => 1
            );

            if ($this->academic_subject_level_model->exists($data['subject_id'], $data['level_id'])) {
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">This subject-level mapping already exists</div>');
            } else {
                $this->academic_subject_level_model->add($data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Subject-Level mapping added successfully</div>');
            }
            redirect('admin/academic/subject_levels');
        }

        $data['title'] = 'Add Subject-Level Mapping';
        $data['subjects'] = $this->academic_subject_model->getAll();
        $data['levels'] = $this->academic_level_model->getAll();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/subject_level/form', $data);
        $this->load->view('layout/footer');
    }

    public function subject_level_delete($id)
    {
        if (!$this->rbac->hasPrivilege('academic_subjects', 'can_delete')) {
            access_denied();
        }

        $this->academic_subject_level_model->delete($id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Subject-Level mapping deleted successfully</div>');
        redirect('admin/academic/subject_levels');
    }

    // =========================================================================
    // CLASSES (THE CENTRAL UNIT)
    // =========================================================================

    public function classes()
    {
        if (!$this->rbac->hasPrivilege('academic_classes', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('classes') ?: 'Classes';

        $filters = array();
        if ($this->input->get('programme_id')) {
            $filters['programme_id'] = $this->input->get('programme_id');
        }
        if ($this->input->get('subject_id')) {
            $filters['subject_id'] = $this->input->get('subject_id');
        }
        if ($this->input->get('level_id')) {
            $filters['level_id'] = $this->input->get('level_id');
        }

        $data['classes'] = $this->academic_class_model->getAll($filters);
        $data['programmes'] = $this->academic_programme_model->getAll();
        $data['levels'] = $this->academic_level_model->getAll();

        // For filters
        $data['selected_programme_id'] = $this->input->get('programme_id') ?: '';
        $data['selected_subject_id'] = $this->input->get('subject_id') ?: '';
        $data['selected_level_id'] = $this->input->get('level_id') ?: '';

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/class/index', $data);
        $this->load->view('layout/footer');
    }

    public function class_add()
    {
        if (!$this->rbac->hasPrivilege('academic_classes', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('subject_level_id', 'Subject-Level', 'required');
        $this->form_validation->set_rules('cohort_name', 'Cohort', 'required|trim');
        $this->form_validation->set_rules('academic_year', 'Academic Year', 'required|integer');
        $this->form_validation->set_rules('session_id', 'Session', 'required');

        if ($this->form_validation->run() == true) {
            $subject_level_id = $this->input->post('subject_level_id');
            $cohort_name = $this->input->post('cohort_name');
            $academic_year = $this->input->post('academic_year');
            $session_id = $this->input->post('session_id');

            // Generate class code
            $class_code = $this->academic_class_model->generateClassCode($subject_level_id, $cohort_name, $academic_year);

            if ($this->academic_class_model->codeExists($class_code, $session_id)) {
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">A class with this code already exists in this session</div>');
            } else {
                $data = array(
                    'class_code' => $class_code,
                    'subject_level_id' => $subject_level_id,
                    'cohort_name' => $cohort_name,
                    'academic_year' => $academic_year,
                    'session_id' => $session_id,
                    'intake_period' => $this->input->post('intake_period'),
                    'delivery_mode' => $this->input->post('delivery_mode') ?: 'Full-time',
                    'primary_lecturer_id' => $this->input->post('primary_lecturer_id') ?: null,
                    'venue' => $this->input->post('venue'),
                    'max_students' => $this->input->post('max_students') ?: 50,
                    'start_date' => $this->input->post('start_date') ?: null,
                    'end_date' => $this->input->post('end_date') ?: null,
                    'status' => 'Scheduled',
                    'is_active' => 1
                );

                $this->academic_class_model->add($data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Class created successfully: ' . $class_code . '</div>');
            }
            redirect('admin/academic/classes');
        }

        $data['title'] = 'Add Class';
        $data['programmes'] = $this->academic_programme_model->getAll();
        $data['sessions'] = $this->session_model->get();
        $data['lecturers'] = $this->staff_model->getTeachers();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/class/form', $data);
        $this->load->view('layout/footer');
    }

    public function class_edit($id)
    {
        if (!$this->rbac->hasPrivilege('academic_classes', 'can_edit')) {
            access_denied();
        }

        $data['class'] = $this->academic_class_model->get($id);
        if (!$data['class']) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Class not found</div>');
            redirect('admin/academic/classes');
        }

        $this->form_validation->set_rules('cohort_name', 'Cohort', 'required|trim');
        $this->form_validation->set_rules('academic_year', 'Academic Year', 'required|integer');

        if ($this->form_validation->run() == true) {
            $update_data = array(
                'cohort_name' => $this->input->post('cohort_name'),
                'academic_year' => $this->input->post('academic_year'),
                'intake_period' => $this->input->post('intake_period'),
                'delivery_mode' => $this->input->post('delivery_mode'),
                'primary_lecturer_id' => $this->input->post('primary_lecturer_id') ?: null,
                'venue' => $this->input->post('venue'),
                'max_students' => $this->input->post('max_students') ?: 50,
                'start_date' => $this->input->post('start_date') ?: null,
                'end_date' => $this->input->post('end_date') ?: null,
                'status' => $this->input->post('status'),
                'is_active' => $this->input->post('is_active') ? 1 : 0
            );

            // Regenerate class code if cohort or year changed
            if ($update_data['cohort_name'] != $data['class']->cohort_name ||
                $update_data['academic_year'] != $data['class']->academic_year) {
                $update_data['class_code'] = $this->academic_class_model->generateClassCode(
                    $data['class']->subject_level_id,
                    $update_data['cohort_name'],
                    $update_data['academic_year']
                );
            }

            $this->academic_class_model->update($id, $update_data);
            $this->session->set_flashdata('msg', '<div class="alert alert-success">Class updated successfully</div>');
            redirect('admin/academic/classes');
        }

        $data['title'] = 'Edit Class';
        $data['programmes'] = $this->academic_programme_model->getAll();
        $data['sessions'] = $this->session_model->get();
        $data['lecturers'] = $this->staff_model->getTeachers();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/class/form', $data);
        $this->load->view('layout/footer');
    }

    public function class_roster($id)
    {
        if (!$this->rbac->hasPrivilege('academic_classes', 'can_view')) {
            access_denied();
        }

        $data['class'] = $this->academic_class_model->get($id);
        if (!$data['class']) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Class not found</div>');
            redirect('admin/academic/classes');
        }

        $data['title'] = 'Class Roster - ' . $data['class']->class_code;
        $data['students'] = $this->academic_enrolment_model->getClassRoster($id);
        $data['stats'] = $this->academic_class_model->getStats($id);

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/class/roster', $data);
        $this->load->view('layout/footer');
    }

    public function class_delete($id)
    {
        if (!$this->rbac->hasPrivilege('academic_classes', 'can_delete')) {
            access_denied();
        }

        $this->academic_class_model->delete($id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Class deleted successfully</div>');
        redirect('admin/academic/classes');
    }

    // =========================================================================
    // STUDENT ENROLMENT
    // =========================================================================

    public function enrolment()
    {
        if (!$this->rbac->hasPrivilege('academic_enrolment', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('student_enrolment') ?: 'Student Enrolment';

        $class_id = $this->input->get('class_id');
        $data['selected_class_id'] = $class_id;

        if ($class_id) {
            $data['class'] = $this->academic_class_model->get($class_id);
            $data['enrolments'] = $this->academic_enrolment_model->getClassRoster($class_id, null);
        } else {
            $data['enrolments'] = array();
        }

        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1));

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/enrolment/index', $data);
        $this->load->view('layout/footer');
    }

    public function enrol_student()
    {
        if (!$this->rbac->hasPrivilege('academic_enrolment', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('class_id', 'Class', 'required');
        $this->form_validation->set_rules('student_id', 'Student', 'required');

        if ($this->form_validation->run() == true) {
            $class_id = $this->input->post('class_id');
            $student_id = $this->input->post('student_id');

            if ($this->academic_enrolment_model->isEnrolled($student_id, $class_id)) {
                $this->session->set_flashdata('msg', '<div class="alert alert-danger">Student is already enrolled in this class</div>');
            } else {
                // Check class capacity
                $class = $this->academic_class_model->get($class_id);
                $enrolled_count = $this->academic_enrolment_model->getActiveCount($class_id);

                if ($enrolled_count >= $class->max_students) {
                    $this->session->set_flashdata('msg', '<div class="alert alert-danger">Class is at full capacity</div>');
                } else {
                    $this->academic_enrolment_model->enrol(array(
                        'student_id' => $student_id,
                        'class_id' => $class_id,
                        'enrolment_date' => date('Y-m-d')
                    ));
                    $this->session->set_flashdata('msg', '<div class="alert alert-success">Student enrolled successfully</div>');
                }
            }
            redirect('admin/academic/enrolment?class_id=' . $class_id);
        }

        $data['title'] = 'Enrol Student';
        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1));
        $data['students'] = $this->student_model->searchByAjax(array('is_active' => 'yes'));
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/enrolment/form', $data);
        $this->load->view('layout/footer');
    }

    public function remove_enrolment($id)
    {
        if (!$this->rbac->hasPrivilege('academic_enrolment', 'can_delete')) {
            access_denied();
        }

        $enrolment = $this->academic_enrolment_model->get($id);
        $class_id = $enrolment ? $enrolment->class_id : null;

        $this->academic_enrolment_model->remove($id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Enrolment removed successfully</div>');

        if ($class_id) {
            redirect('admin/academic/enrolment?class_id=' . $class_id);
        } else {
            redirect('admin/academic/enrolment');
        }
    }

    // =========================================================================
    // ATTENDANCE
    // =========================================================================

    public function attendance()
    {
        if (!$this->rbac->hasPrivilege('academic_attendance', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('attendance') ?: 'Attendance';
        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1, 'status' => 'Active'));
        $data['subjects'] = $this->academic_subject_model->getAll();
        $data['levels'] = $this->academic_level_model->getAll();

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/attendance/index', $data);
        $this->load->view('layout/footer');
    }

    public function mark_attendance($class_id = null)
    {
        if (!$this->rbac->hasPrivilege('academic_attendance', 'can_add')) {
            access_denied();
        }

        $data['class'] = null;
        $data['students'] = array();
        $data['existing_attendance'] = array();

        if ($class_id) {
            $data['class'] = $this->academic_class_model->get($class_id);
            if ($data['class']) {
                $data['students'] = $this->academic_enrolment_model->getClassRoster($class_id, 'Active');
                $attendance_date = $this->input->get('date') ?: date('Y-m-d');
                $data['attendance_date'] = $attendance_date;
                $data['existing_attendance'] = $this->academic_attendance_model->getExistingAttendance($class_id, $attendance_date);
            }
        }

        // Handle form submission
        if ($this->input->post('attendance')) {
            $class_id = $this->input->post('class_id');
            $date = $this->input->post('attendance_date');
            $attendance_data = $this->input->post('attendance');
            $notes_data = $this->input->post('notes') ?: array();

            foreach ($attendance_data as $enrolment_id => $status) {
                $this->academic_attendance_model->mark(array(
                    'class_id' => $class_id,
                    'enrolment_id' => $enrolment_id,
                    'date' => $date,
                    'status' => $status,
                    'notes' => isset($notes_data[$enrolment_id]) ? $notes_data[$enrolment_id] : null,
                    'marked_by' => $this->session->userdata('id')
                ));
            }

            $this->session->set_flashdata('msg', '<div class="alert alert-success">Attendance saved successfully</div>');
            redirect('admin/academic/mark_attendance/' . $class_id . '?date=' . $date);
        }

        $data['title'] = $this->lang->line('mark_attendance') ?: 'Mark Attendance';
        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1, 'status' => 'Active'));
        $data['subjects'] = $this->academic_subject_model->getAll();
        $data['levels'] = $this->academic_level_model->getAll();

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/attendance/mark', $data);
        $this->load->view('layout/footer');
    }

    // =========================================================================
    // ASSESSMENTS
    // =========================================================================

    public function assessments()
    {
        if (!$this->rbac->hasPrivilege('academic_assessments', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('assessments') ?: 'Assessments';

        $filters = array();
        if ($this->input->get('class_id')) {
            $filters['class_id'] = $this->input->get('class_id');
        }

        $data['assessments'] = $this->academic_assessment_model->getAll($filters);
        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1));
        $data['selected_class_id'] = $this->input->get('class_id') ?: '';

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/assessment/index', $data);
        $this->load->view('layout/footer');
    }

    public function assessment_add()
    {
        if (!$this->rbac->hasPrivilege('academic_assessments', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('class_id', 'Class', 'required');
        $this->form_validation->set_rules('title', 'Title', 'required|trim');
        $this->form_validation->set_rules('assessment_type', 'Assessment Type', 'required');
        $this->form_validation->set_rules('total_marks', 'Total Marks', 'required|numeric');

        if ($this->form_validation->run() == true) {
            $data = array(
                'class_id' => $this->input->post('class_id'),
                'title' => $this->input->post('title'),
                'assessment_type' => $this->input->post('assessment_type'),
                'icass_component' => $this->input->post('icass_component'),
                'total_marks' => $this->input->post('total_marks'),
                'weight_percentage' => $this->input->post('weight_percentage'),
                'due_date' => $this->input->post('due_date') ? $this->input->post('due_date') . ' ' . ($this->input->post('due_time') ?: '23:59:00') : null,
                'instructions' => $this->input->post('instructions'),
                'created_by' => $this->session->userdata('id')
            );

            $this->academic_assessment_model->add($data);
            $this->session->set_flashdata('msg', '<div class="alert alert-success">Assessment created successfully</div>');
            redirect('admin/academic/assessments?class_id=' . $data['class_id']);
        }

        $data['title'] = 'Add Assessment';
        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1));
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/assessment/form', $data);
        $this->load->view('layout/footer');
    }

    public function assessment_edit($id)
    {
        if (!$this->rbac->hasPrivilege('academic_assessments', 'can_edit')) {
            access_denied();
        }

        $data['assessment'] = $this->academic_assessment_model->get($id);
        if (!$data['assessment']) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Assessment not found</div>');
            redirect('admin/academic/assessments');
        }

        $this->form_validation->set_rules('title', 'Title', 'required|trim');
        $this->form_validation->set_rules('assessment_type', 'Assessment Type', 'required');
        $this->form_validation->set_rules('total_marks', 'Total Marks', 'required|numeric');

        if ($this->form_validation->run() == true) {
            $update_data = array(
                'title' => $this->input->post('title'),
                'assessment_type' => $this->input->post('assessment_type'),
                'icass_component' => $this->input->post('icass_component'),
                'total_marks' => $this->input->post('total_marks'),
                'weight_percentage' => $this->input->post('weight_percentage'),
                'due_date' => $this->input->post('due_date') ? $this->input->post('due_date') . ' ' . ($this->input->post('due_time') ?: '23:59:00') : null,
                'instructions' => $this->input->post('instructions')
            );

            $this->academic_assessment_model->update($id, $update_data);
            $this->session->set_flashdata('msg', '<div class="alert alert-success">Assessment updated successfully</div>');
            redirect('admin/academic/assessments?class_id=' . $data['assessment']->class_id);
        }

        $data['title'] = 'Edit Assessment';
        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1));
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/assessment/form', $data);
        $this->load->view('layout/footer');
    }

    public function marks_entry($assessment_id)
    {
        if (!$this->rbac->hasPrivilege('academic_assessments', 'can_edit')) {
            access_denied();
        }

        $data['assessment'] = $this->academic_assessment_model->get($assessment_id);
        if (!$data['assessment']) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Assessment not found</div>');
            redirect('admin/academic/assessments');
        }

        // Handle form submission
        if ($this->input->post('marks')) {
            $marks_data = $this->input->post('marks');
            $feedback_data = $this->input->post('feedback') ?: array();

            $formatted_data = array();
            foreach ($marks_data as $enrolment_id => $marks) {
                $formatted_data[$enrolment_id] = array(
                    'marks' => $marks !== '' ? $marks : null,
                    'feedback' => isset($feedback_data[$enrolment_id]) ? $feedback_data[$enrolment_id] : null
                );
            }

            $this->academic_marks_model->bulkSave($assessment_id, $formatted_data, $this->session->userdata('id'));
            $this->session->set_flashdata('msg', '<div class="alert alert-success">Marks saved successfully</div>');
            redirect('admin/academic/marks_entry/' . $assessment_id);
        }

        $data['title'] = 'Marks Entry - ' . $data['assessment']->title;
        $data['students'] = $this->academic_enrolment_model->getClassRoster($data['assessment']->class_id, 'Active');
        $data['existing_marks'] = $this->academic_marks_model->getExistingMarks($assessment_id);
        $data['stats'] = $this->academic_marks_model->getAssessmentStats($assessment_id);

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/assessment/marks', $data);
        $this->load->view('layout/footer');
    }

    public function assessment_delete($id)
    {
        if (!$this->rbac->hasPrivilege('academic_assessments', 'can_delete')) {
            access_denied();
        }

        $assessment = $this->academic_assessment_model->get($id);
        $class_id = $assessment ? $assessment->class_id : null;

        $this->academic_assessment_model->delete($id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Assessment deleted successfully</div>');

        if ($class_id) {
            redirect('admin/academic/assessments?class_id=' . $class_id);
        } else {
            redirect('admin/academic/assessments');
        }
    }

    // =========================================================================
    // REPORTS
    // =========================================================================

    public function reports()
    {
        if (!$this->rbac->hasPrivilege('academic_reports', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('reports') ?: 'Reports';
        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1));

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/reports/index', $data);
        $this->load->view('layout/footer');
    }

    // =========================================================================
    // MODERATION
    // =========================================================================

    public function moderation()
    {
        if (!$this->rbac->hasPrivilege('academic_moderation', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('moderation') ?: 'Moderation';
        $data['pending'] = $this->academic_assessment_model->getPendingModeration();

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/moderation/index', $data);
        $this->load->view('layout/footer');
    }

    // =========================================================================
    // ICASS
    // =========================================================================

    public function icass()
    {
        if (!$this->rbac->hasPrivilege('academic_icass', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('icass') ?: 'ICASS';
        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1));

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/icass/index', $data);
        $this->load->view('layout/footer');
    }

    // =========================================================================
    // POE
    // =========================================================================

    public function poe()
    {
        if (!$this->rbac->hasPrivilege('academic_poe', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('poe') ?: 'POE';
        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1));

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/poe/index', $data);
        $this->load->view('layout/footer');
    }

    // =========================================================================
    // TIMETABLE
    // =========================================================================

    public function timetable()
    {
        if (!$this->rbac->hasPrivilege('academic_classes', 'can_view')) {
            access_denied();
        }

        $data['title'] = $this->lang->line('timetable') ?: 'Timetable';
        $data['classes'] = $this->academic_class_model->getAll(array('is_active' => 1));

        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/timetable/index', $data);
        $this->load->view('layout/footer');
    }

    // =========================================================================
    // AJAX ENDPOINTS
    // =========================================================================

    public function ajax_get_subjects($programme_id)
    {
        $subjects = $this->academic_subject_model->getByProgramme($programme_id);
        echo json_encode($subjects);
    }

    public function ajax_get_levels($subject_id)
    {
        $levels = $this->academic_subject_level_model->getLevelsBySubject($subject_id);
        echo json_encode($levels);
    }

    public function ajax_get_subject_levels($programme_id)
    {
        $this->db->select('sl.id, sl.syllabus_code, s.code as subject_code, s.name as subject_name,
                          l.code as level_code, l.name as level_name');
        $this->db->from('academic_subject_level sl');
        $this->db->join('academic_subject s', 's.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->where('s.programme_id', $programme_id);
        $this->db->where('sl.is_active', 1);
        $this->db->order_by('s.name', 'ASC');
        $this->db->order_by('l.sequence', 'ASC');

        $result = $this->db->get()->result();
        echo json_encode($result);
    }

    public function ajax_get_classes($subject_id = null, $level_id = null)
    {
        $subject_id = $subject_id ?: $this->input->get('subject_id');
        $level_id = $level_id ?: $this->input->get('level_id');

        if ($subject_id && $level_id) {
            $classes = $this->academic_class_model->getBySubjectLevel($subject_id, $level_id);
        } else {
            $classes = array();
        }

        echo json_encode($classes);
    }

    public function ajax_get_class_students($class_id)
    {
        $class = $this->academic_class_model->get($class_id);
        $students = $this->academic_enrolment_model->getClassRoster($class_id, 'Active');

        $response = array(
            'class_code' => $class ? $class->class_code : '',
            'lecturer' => $class ? trim($class->lecturer_name . ' ' . $class->lecturer_surname) : '',
            'venue' => $class ? $class->venue : '',
            'students' => array()
        );

        foreach ($students as $s) {
            $response['students'][] = array(
                'enrolment_id' => $s->enrolment_id,
                'student_id' => $s->student_id,
                'student_no' => $s->admission_no,
                'name' => $s->firstname . ' ' . $s->lastname
            );
        }

        echo json_encode($response);
    }

    // =========================================================================
    // BULK IMPORT
    // =========================================================================

    /**
     * Import management page
     */
    public function import()
    {
        if (!$this->rbac->hasPrivilege('academic_programmes', 'can_add')) {
            access_denied();
        }

        $data['title'] = 'TVET Bulk Import';
        $this->load->view('layout/header', $data);
        $this->load->view('admin/academic/import/index', $data);
        $this->load->view('layout/footer');
    }

    /**
     * Import Programmes from CSV
     */
    public function import_programmes()
    {
        if (!$this->rbac->hasPrivilege('academic_programmes', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('file', 'File', 'callback_handle_csv_upload');

        if ($this->form_validation->run() == false) {
            $data['title'] = 'Import Programmes';
            $data['import_type'] = 'programmes';
            $data['sample_file'] = 'tvet_programmes_sample.csv';
            $data['fields'] = array('code', 'name', 'description', 'qualification_type', 'is_active');
            $this->load->view('layout/header', $data);
            $this->load->view('admin/academic/import/form', $data);
            $this->load->view('layout/footer');
        } else {
            $file = $_FILES['file']['tmp_name'];
            $this->load->library('CSVReader');
            $result = $this->csvreader->parse_file($file);

            $imported = 0;
            $skipped = 0;
            $errors = array();

            if (!empty($result)) {
                foreach ($result as $row) {
                    // Check if programme code already exists
                    if ($this->academic_programme_model->codeExists($row['code'])) {
                        $skipped++;
                        $errors[] = "Programme '{$row['code']}' already exists - skipped";
                        continue;
                    }

                    $data = array(
                        'code' => trim($row['code']),
                        'name' => trim($row['name']),
                        'description' => isset($row['description']) ? trim($row['description']) : null,
                        'qualification_type' => isset($row['qualification_type']) ? trim($row['qualification_type']) : null,
                        'is_active' => isset($row['is_active']) ? (int)$row['is_active'] : 1
                    );

                    $this->academic_programme_model->add($data);
                    $imported++;
                }
            }

            $message = "Import complete: $imported programmes imported, $skipped skipped.";
            if (!empty($errors)) {
                $message .= ' Errors: ' . implode('; ', array_slice($errors, 0, 5));
            }

            $this->session->set_flashdata('msg', '<div class="alert alert-success">' . $message . '</div>');
            redirect('admin/academic/import');
        }
    }

    /**
     * Import Subjects from CSV
     */
    public function import_subjects()
    {
        if (!$this->rbac->hasPrivilege('academic_subjects', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('file', 'File', 'callback_handle_csv_upload');

        if ($this->form_validation->run() == false) {
            $data['title'] = 'Import Subjects';
            $data['import_type'] = 'subjects';
            $data['sample_file'] = 'tvet_subjects_sample.csv';
            $data['fields'] = array('programme_code', 'code', 'name', 'description', 'credits', 'notional_hours', 'is_core', 'is_active');
            $this->load->view('layout/header', $data);
            $this->load->view('admin/academic/import/form', $data);
            $this->load->view('layout/footer');
        } else {
            $file = $_FILES['file']['tmp_name'];
            $this->load->library('CSVReader');
            $result = $this->csvreader->parse_file($file);

            $imported = 0;
            $skipped = 0;
            $errors = array();

            if (!empty($result)) {
                foreach ($result as $row) {
                    // Find programme by code
                    $programme = $this->db->where('code', $row['programme_code'])->get('academic_programme')->row();
                    if (!$programme) {
                        $skipped++;
                        $errors[] = "Programme '{$row['programme_code']}' not found for subject '{$row['code']}'";
                        continue;
                    }

                    // Check if subject code already exists in programme
                    if ($this->academic_subject_model->codeExists($row['code'], $programme->id)) {
                        $skipped++;
                        $errors[] = "Subject '{$row['code']}' already exists in programme '{$row['programme_code']}'";
                        continue;
                    }

                    $data = array(
                        'programme_id' => $programme->id,
                        'code' => trim($row['code']),
                        'name' => trim($row['name']),
                        'description' => isset($row['description']) ? trim($row['description']) : null,
                        'credits' => isset($row['credits']) ? (int)$row['credits'] : 0,
                        'notional_hours' => isset($row['notional_hours']) ? (int)$row['notional_hours'] : 0,
                        'is_core' => isset($row['is_core']) ? (int)$row['is_core'] : 0,
                        'is_active' => isset($row['is_active']) ? (int)$row['is_active'] : 1
                    );

                    $this->academic_subject_model->add($data);
                    $imported++;
                }
            }

            $message = "Import complete: $imported subjects imported, $skipped skipped.";
            if (!empty($errors)) {
                $message .= ' Errors: ' . implode('; ', array_slice($errors, 0, 5));
            }

            $this->session->set_flashdata('msg', '<div class="alert alert-success">' . $message . '</div>');
            redirect('admin/academic/import');
        }
    }

    /**
     * Import Levels from CSV
     */
    public function import_levels()
    {
        if (!$this->rbac->hasPrivilege('academic_levels', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('file', 'File', 'callback_handle_csv_upload');

        if ($this->form_validation->run() == false) {
            $data['title'] = 'Import Levels';
            $data['import_type'] = 'levels';
            $data['sample_file'] = 'tvet_levels_sample.csv';
            $data['fields'] = array('code', 'name', 'level_type', 'nqf_level', 'programme_code', 'sequence', 'is_active');
            $this->load->view('layout/header', $data);
            $this->load->view('admin/academic/import/form', $data);
            $this->load->view('layout/footer');
        } else {
            $file = $_FILES['file']['tmp_name'];
            $this->load->library('CSVReader');
            $result = $this->csvreader->parse_file($file);

            $imported = 0;
            $skipped = 0;
            $errors = array();

            if (!empty($result)) {
                foreach ($result as $row) {
                    // Check if level code already exists
                    if ($this->academic_level_model->codeExists($row['code'])) {
                        $skipped++;
                        $errors[] = "Level '{$row['code']}' already exists";
                        continue;
                    }

                    // Find programme by code if specified
                    $programme_id = null;
                    if (!empty($row['programme_code'])) {
                        $programme = $this->db->where('code', $row['programme_code'])->get('academic_programme')->row();
                        if ($programme) {
                            $programme_id = $programme->id;
                        }
                    }

                    $data = array(
                        'code' => trim($row['code']),
                        'name' => trim($row['name']),
                        'level_type' => isset($row['level_type']) ? trim($row['level_type']) : null,
                        'nqf_level' => isset($row['nqf_level']) ? (int)$row['nqf_level'] : null,
                        'programme_id' => $programme_id,
                        'sequence' => isset($row['sequence']) ? (int)$row['sequence'] : 1,
                        'is_active' => isset($row['is_active']) ? (int)$row['is_active'] : 1
                    );

                    $this->academic_level_model->add($data);
                    $imported++;
                }
            }

            $message = "Import complete: $imported levels imported, $skipped skipped.";
            if (!empty($errors)) {
                $message .= ' Errors: ' . implode('; ', array_slice($errors, 0, 5));
            }

            $this->session->set_flashdata('msg', '<div class="alert alert-success">' . $message . '</div>');
            redirect('admin/academic/import');
        }
    }

    /**
     * Import Subject-Level mappings from CSV
     */
    public function import_subject_levels()
    {
        if (!$this->rbac->hasPrivilege('academic_subjects', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('file', 'File', 'callback_handle_csv_upload');

        if ($this->form_validation->run() == false) {
            $data['title'] = 'Import Subject-Level Mappings';
            $data['import_type'] = 'subject_levels';
            $data['sample_file'] = 'tvet_subject_levels_sample.csv';
            $data['fields'] = array('subject_code', 'level_code', 'syllabus_code', 'is_active');
            $this->load->view('layout/header', $data);
            $this->load->view('admin/academic/import/form', $data);
            $this->load->view('layout/footer');
        } else {
            $file = $_FILES['file']['tmp_name'];
            $this->load->library('CSVReader');
            $result = $this->csvreader->parse_file($file);

            $imported = 0;
            $skipped = 0;
            $errors = array();

            if (!empty($result)) {
                foreach ($result as $row) {
                    // Find subject by code
                    $subject = $this->db->where('code', $row['subject_code'])->get('academic_subject')->row();
                    if (!$subject) {
                        $skipped++;
                        $errors[] = "Subject '{$row['subject_code']}' not found";
                        continue;
                    }

                    // Find level by code
                    $level = $this->db->where('code', $row['level_code'])->get('academic_level')->row();
                    if (!$level) {
                        $skipped++;
                        $errors[] = "Level '{$row['level_code']}' not found";
                        continue;
                    }

                    // Check if mapping already exists
                    if ($this->academic_subject_level_model->exists($subject->id, $level->id)) {
                        $skipped++;
                        $errors[] = "Mapping '{$row['subject_code']}-{$row['level_code']}' already exists";
                        continue;
                    }

                    $data = array(
                        'subject_id' => $subject->id,
                        'level_id' => $level->id,
                        'syllabus_code' => isset($row['syllabus_code']) ? trim($row['syllabus_code']) : null,
                        'is_active' => isset($row['is_active']) ? (int)$row['is_active'] : 1
                    );

                    $this->academic_subject_level_model->add($data);
                    $imported++;
                }
            }

            $message = "Import complete: $imported subject-level mappings imported, $skipped skipped.";
            if (!empty($errors)) {
                $message .= ' Errors: ' . implode('; ', array_slice($errors, 0, 5));
            }

            $this->session->set_flashdata('msg', '<div class="alert alert-success">' . $message . '</div>');
            redirect('admin/academic/import');
        }
    }

    /**
     * Import Classes from CSV
     */
    public function import_classes()
    {
        if (!$this->rbac->hasPrivilege('academic_classes', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('file', 'File', 'callback_handle_csv_upload');
        $this->form_validation->set_rules('session_id', 'Session', 'required');

        if ($this->form_validation->run() == false) {
            $data['title'] = 'Import Classes';
            $data['import_type'] = 'classes';
            $data['sample_file'] = 'tvet_classes_sample.csv';
            $data['fields'] = array('subject_code', 'level_code', 'cohort_name', 'academic_year', 'intake_period', 'delivery_mode', 'venue', 'max_students', 'start_date', 'end_date', 'lecturer_employee_id');
            $data['sessions'] = $this->session_model->get();
            $this->load->view('layout/header', $data);
            $this->load->view('admin/academic/import/form', $data);
            $this->load->view('layout/footer');
        } else {
            $session_id = $this->input->post('session_id');

            $file = $_FILES['file']['tmp_name'];
            $this->load->library('CSVReader');
            $result = $this->csvreader->parse_file($file);

            $imported = 0;
            $skipped = 0;
            $errors = array();

            if (!empty($result)) {
                foreach ($result as $row) {
                    // Find subject by code
                    $subject = $this->db->where('code', $row['subject_code'])->get('academic_subject')->row();
                    if (!$subject) {
                        $skipped++;
                        $errors[] = "Subject '{$row['subject_code']}' not found";
                        continue;
                    }

                    // Find level by code
                    $level = $this->db->where('code', $row['level_code'])->get('academic_level')->row();
                    if (!$level) {
                        $skipped++;
                        $errors[] = "Level '{$row['level_code']}' not found";
                        continue;
                    }

                    // Find subject-level mapping
                    $subject_level = $this->db->where('subject_id', $subject->id)
                        ->where('level_id', $level->id)
                        ->get('academic_subject_level')->row();
                    if (!$subject_level) {
                        $skipped++;
                        $errors[] = "Subject-Level mapping not found for '{$row['subject_code']}-{$row['level_code']}'";
                        continue;
                    }

                    // Generate class code
                    $class_code = $this->academic_class_model->generateClassCode(
                        $subject_level->id,
                        $row['cohort_name'],
                        $row['academic_year']
                    );

                    // Check if class code already exists
                    if ($this->academic_class_model->codeExists($class_code, $session_id)) {
                        $skipped++;
                        $errors[] = "Class '$class_code' already exists";
                        continue;
                    }

                    // Find lecturer by employee_id if specified
                    $lecturer_id = null;
                    if (!empty($row['lecturer_employee_id'])) {
                        $lecturer = $this->db->where('employee_id', $row['lecturer_employee_id'])->get('staff')->row();
                        if ($lecturer) {
                            $lecturer_id = $lecturer->id;
                        }
                    }

                    $data = array(
                        'class_code' => $class_code,
                        'subject_level_id' => $subject_level->id,
                        'cohort_name' => trim($row['cohort_name']),
                        'academic_year' => (int)$row['academic_year'],
                        'session_id' => $session_id,
                        'intake_period' => isset($row['intake_period']) ? trim($row['intake_period']) : null,
                        'delivery_mode' => isset($row['delivery_mode']) ? trim($row['delivery_mode']) : 'Full-time',
                        'primary_lecturer_id' => $lecturer_id,
                        'venue' => isset($row['venue']) ? trim($row['venue']) : null,
                        'max_students' => isset($row['max_students']) ? (int)$row['max_students'] : 50,
                        'start_date' => isset($row['start_date']) && $row['start_date'] ? $row['start_date'] : null,
                        'end_date' => isset($row['end_date']) && $row['end_date'] ? $row['end_date'] : null,
                        'status' => 'Scheduled',
                        'is_active' => 1
                    );

                    $this->academic_class_model->add($data);
                    $imported++;
                }
            }

            $message = "Import complete: $imported classes imported, $skipped skipped.";
            if (!empty($errors)) {
                $message .= ' Errors: ' . implode('; ', array_slice($errors, 0, 5));
            }

            $this->session->set_flashdata('msg', '<div class="alert alert-success">' . $message . '</div>');
            redirect('admin/academic/import');
        }
    }

    /**
     * Import Student Enrolments from CSV
     */
    public function import_enrolments()
    {
        if (!$this->rbac->hasPrivilege('academic_enrolment', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('file', 'File', 'callback_handle_csv_upload');

        if ($this->form_validation->run() == false) {
            $data['title'] = 'Import Student Enrolments';
            $data['import_type'] = 'enrolments';
            $data['sample_file'] = 'tvet_enrolments_sample.csv';
            $data['fields'] = array('admission_no', 'class_code', 'enrolment_date', 'status', 'notes');
            $this->load->view('layout/header', $data);
            $this->load->view('admin/academic/import/form', $data);
            $this->load->view('layout/footer');
        } else {
            $file = $_FILES['file']['tmp_name'];
            $this->load->library('CSVReader');
            $result = $this->csvreader->parse_file($file);

            $imported = 0;
            $skipped = 0;
            $errors = array();

            if (!empty($result)) {
                foreach ($result as $row) {
                    // Find student by admission_no
                    $student = $this->db->where('admission_no', $row['admission_no'])->get('students')->row();
                    if (!$student) {
                        $skipped++;
                        $errors[] = "Student '{$row['admission_no']}' not found";
                        continue;
                    }

                    // Find class by class_code
                    $class = $this->db->where('class_code', $row['class_code'])->get('academic_class')->row();
                    if (!$class) {
                        $skipped++;
                        $errors[] = "Class '{$row['class_code']}' not found";
                        continue;
                    }

                    // Check if already enrolled
                    if ($this->academic_enrolment_model->isEnrolled($student->id, $class->id)) {
                        $skipped++;
                        $errors[] = "Student '{$row['admission_no']}' already enrolled in '{$row['class_code']}'";
                        continue;
                    }

                    // Check class capacity
                    $enrolled_count = $this->academic_enrolment_model->getActiveCount($class->id);
                    if ($enrolled_count >= $class->max_students) {
                        $skipped++;
                        $errors[] = "Class '{$row['class_code']}' is at full capacity";
                        continue;
                    }

                    $data = array(
                        'student_id' => $student->id,
                        'class_id' => $class->id,
                        'enrolment_date' => isset($row['enrolment_date']) && $row['enrolment_date'] ? $row['enrolment_date'] : date('Y-m-d'),
                        'status' => isset($row['status']) && $row['status'] ? $row['status'] : 'Enrolled',
                        'notes' => isset($row['notes']) ? trim($row['notes']) : null
                    );

                    $this->academic_enrolment_model->enrol($data);
                    $imported++;
                }
            }

            $message = "Import complete: $imported enrolments imported, $skipped skipped.";
            if (!empty($errors)) {
                $message .= ' Errors: ' . implode('; ', array_slice($errors, 0, 5));
            }

            $this->session->set_flashdata('msg', '<div class="alert alert-success">' . $message . '</div>');
            redirect('admin/academic/import');
        }
    }

    /**
     * Import Programme-Based Enrolments from CSV
     * This enrolls students in ALL classes for their programme + level + cohort
     * Much faster than individual class enrolments
     */
    public function import_programme_enrolments()
    {
        if (!$this->rbac->hasPrivilege('academic_enrolment', 'can_add')) {
            access_denied();
        }

        $this->form_validation->set_rules('file', 'File', 'callback_handle_csv_upload');
        $this->form_validation->set_rules('session_id', 'Session', 'required');

        if ($this->form_validation->run() == false) {
            $data['title'] = 'Import Programme-Based Enrolments';
            $data['import_type'] = 'programme_enrolments';
            $data['sample_file'] = 'tvet_programme_enrolment_sample.csv';
            $data['fields'] = array('admission_no', 'programme_code', 'level_code', 'cohort', 'enrolment_date', 'notes');
            $data['sessions'] = $this->session_model->get();
            $data['programmes'] = $this->academic_programme_model->getAll();
            $data['levels'] = $this->academic_level_model->getAll();
            $this->load->view('layout/header', $data);
            $this->load->view('admin/academic/import/form', $data);
            $this->load->view('layout/footer');
        } else {
            $session_id = $this->input->post('session_id');

            $file = $_FILES['file']['tmp_name'];
            $this->load->library('CSVReader');
            $result = $this->csvreader->parse_file($file);

            $students_enrolled = 0;
            $classes_enrolled = 0;
            $skipped = 0;
            $errors = array();

            if (!empty($result)) {
                foreach ($result as $row) {
                    // Find student by admission_no
                    $student = $this->db->where('admission_no', $row['admission_no'])->get('students')->row();
                    if (!$student) {
                        $skipped++;
                        $errors[] = "Student '{$row['admission_no']}' not found";
                        continue;
                    }

                    // Find programme by code
                    $programme = $this->db->where('code', $row['programme_code'])->get('academic_programme')->row();
                    if (!$programme) {
                        $skipped++;
                        $errors[] = "Programme '{$row['programme_code']}' not found";
                        continue;
                    }

                    // Find level by code
                    $level = $this->db->where('code', $row['level_code'])->get('academic_level')->row();
                    if (!$level) {
                        $skipped++;
                        $errors[] = "Level '{$row['level_code']}' not found";
                        continue;
                    }

                    $cohort = isset($row['cohort']) ? trim($row['cohort']) : 'A';
                    $enrolment_date = isset($row['enrolment_date']) && $row['enrolment_date'] ? $row['enrolment_date'] : date('Y-m-d');
                    $notes = isset($row['notes']) ? trim($row['notes']) : null;

                    // Find ALL classes for this programme + level + cohort
                    $classes = $this->academic_class_model->getByProgrammeLevelCohort(
                        $programme->id,
                        $level->id,
                        $cohort,
                        $session_id
                    );

                    if (empty($classes)) {
                        $skipped++;
                        $errors[] = "No classes found for {$row['programme_code']}/{$row['level_code']}/Cohort {$cohort}";
                        continue;
                    }

                    $student_enrolled_in = 0;
                    foreach ($classes as $class) {
                        // Skip if already enrolled
                        if ($this->academic_enrolment_model->isEnrolled($student->id, $class->id)) {
                            continue;
                        }

                        // Check class capacity
                        $enrolled_count = $this->academic_enrolment_model->getActiveCount($class->id);
                        if ($enrolled_count >= $class->max_students) {
                            $errors[] = "Class '{$class->class_code}' full - skipped for {$row['admission_no']}";
                            continue;
                        }

                        // Enrol student in this class
                        $this->academic_enrolment_model->enrol(array(
                            'student_id' => $student->id,
                            'class_id' => $class->id,
                            'enrolment_date' => $enrolment_date,
                            'status' => 'Enrolled',
                            'notes' => $notes
                        ));

                        $student_enrolled_in++;
                        $classes_enrolled++;
                    }

                    if ($student_enrolled_in > 0) {
                        $students_enrolled++;
                    }
                }
            }

            $message = "Programme Enrolment complete: $students_enrolled students enrolled in $classes_enrolled class slots. $skipped rows skipped.";
            if (!empty($errors)) {
                $message .= '<br>Notes: ' . implode('; ', array_slice($errors, 0, 10));
            }

            $this->session->set_flashdata('msg', '<div class="alert alert-success">' . $message . '</div>');
            redirect('admin/academic/import');
        }
    }

    /**
     * CSV upload validation callback
     */
    public function handle_csv_upload()
    {
        if (isset($_FILES["file"]) && !empty($_FILES['file']['name'])) {
            $allowedExts = array('csv');
            $mimes = array(
                'text/csv', 'text/plain', 'application/csv',
                'text/comma-separated-values', 'application/excel',
                'application/vnd.ms-excel', 'application/vnd.msexcel',
                'text/anytext', 'application/octet-stream', 'application/txt'
            );

            $extension = strtolower(pathinfo($_FILES["file"]["name"], PATHINFO_EXTENSION));

            if ($_FILES["file"]["error"] > 0) {
                $this->form_validation->set_message('handle_csv_upload', 'Error opening the file');
                return false;
            }
            if (!in_array($extension, $allowedExts)) {
                $this->form_validation->set_message('handle_csv_upload', 'Only CSV files are allowed');
                return false;
            }
            return true;
        } else {
            $this->form_validation->set_message('handle_csv_upload', 'Please select a file');
            return false;
        }
    }

    /**
     * Download sample CSV file
     */
    public function download_sample($type)
    {
        $this->load->helper('download');

        $files = array(
            'programmes' => 'tvet_programmes_sample.csv',
            'subjects' => 'tvet_subjects_sample.csv',
            'levels' => 'tvet_levels_sample.csv',
            'subject_levels' => 'tvet_subject_levels_sample.csv',
            'classes' => 'tvet_classes_sample.csv',
            'enrolments' => 'tvet_enrolments_sample.csv',
            'programme_enrolments' => 'tvet_programme_enrolment_sample.csv'
        );

        if (isset($files[$type])) {
            $filepath = "./backend/import/" . $files[$type];
            if (file_exists($filepath)) {
                $data = file_get_contents($filepath);
                force_download($files[$type], $data);
            }
        }

        redirect('admin/academic/import');
    }

    // =========================================================================
    // API ENDPOINTS FOR BULK IMPORT
    // =========================================================================

    /**
     * API: Import programmes via JSON
     */
    public function api_import_programmes()
    {
        header('Content-Type: application/json');

        // Check API authentication (simple token-based for now)
        $token = $this->input->get_request_header('X-API-Token', TRUE);
        if (!$this->validate_api_token($token)) {
            echo json_encode(array('status' => 'error', 'message' => 'Unauthorized'));
            return;
        }

        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        if (!$data || !isset($data['programmes'])) {
            echo json_encode(array('status' => 'error', 'message' => 'Invalid JSON data'));
            return;
        }

        $imported = 0;
        $errors = array();

        foreach ($data['programmes'] as $row) {
            if (empty($row['code']) || empty($row['name'])) {
                $errors[] = "Missing required fields (code, name)";
                continue;
            }

            if ($this->academic_programme_model->codeExists($row['code'])) {
                $errors[] = "Programme '{$row['code']}' already exists";
                continue;
            }

            $insert_data = array(
                'code' => trim($row['code']),
                'name' => trim($row['name']),
                'description' => isset($row['description']) ? trim($row['description']) : null,
                'qualification_type' => isset($row['qualification_type']) ? trim($row['qualification_type']) : null,
                'is_active' => isset($row['is_active']) ? (int)$row['is_active'] : 1
            );

            $this->academic_programme_model->add($insert_data);
            $imported++;
        }

        echo json_encode(array(
            'status' => 'success',
            'imported' => $imported,
            'errors' => $errors
        ));
    }

    /**
     * API: Import subjects via JSON
     */
    public function api_import_subjects()
    {
        header('Content-Type: application/json');

        $token = $this->input->get_request_header('X-API-Token', TRUE);
        if (!$this->validate_api_token($token)) {
            echo json_encode(array('status' => 'error', 'message' => 'Unauthorized'));
            return;
        }

        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        if (!$data || !isset($data['subjects'])) {
            echo json_encode(array('status' => 'error', 'message' => 'Invalid JSON data'));
            return;
        }

        $imported = 0;
        $errors = array();

        foreach ($data['subjects'] as $row) {
            if (empty($row['programme_code']) || empty($row['code']) || empty($row['name'])) {
                $errors[] = "Missing required fields";
                continue;
            }

            $programme = $this->db->where('code', $row['programme_code'])->get('academic_programme')->row();
            if (!$programme) {
                $errors[] = "Programme '{$row['programme_code']}' not found";
                continue;
            }

            if ($this->academic_subject_model->codeExists($row['code'], $programme->id)) {
                $errors[] = "Subject '{$row['code']}' already exists in programme";
                continue;
            }

            $insert_data = array(
                'programme_id' => $programme->id,
                'code' => trim($row['code']),
                'name' => trim($row['name']),
                'description' => isset($row['description']) ? trim($row['description']) : null,
                'credits' => isset($row['credits']) ? (int)$row['credits'] : 0,
                'notional_hours' => isset($row['notional_hours']) ? (int)$row['notional_hours'] : 0,
                'is_core' => isset($row['is_core']) ? (int)$row['is_core'] : 0,
                'is_active' => isset($row['is_active']) ? (int)$row['is_active'] : 1
            );

            $this->academic_subject_model->add($insert_data);
            $imported++;
        }

        echo json_encode(array(
            'status' => 'success',
            'imported' => $imported,
            'errors' => $errors
        ));
    }

    /**
     * API: Import student enrolments via JSON
     */
    public function api_import_enrolments()
    {
        header('Content-Type: application/json');

        $token = $this->input->get_request_header('X-API-Token', TRUE);
        if (!$this->validate_api_token($token)) {
            echo json_encode(array('status' => 'error', 'message' => 'Unauthorized'));
            return;
        }

        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        if (!$data || !isset($data['enrolments'])) {
            echo json_encode(array('status' => 'error', 'message' => 'Invalid JSON data'));
            return;
        }

        $imported = 0;
        $errors = array();

        foreach ($data['enrolments'] as $row) {
            if (empty($row['admission_no']) || empty($row['class_code'])) {
                $errors[] = "Missing required fields (admission_no, class_code)";
                continue;
            }

            $student = $this->db->where('admission_no', $row['admission_no'])->get('students')->row();
            if (!$student) {
                $errors[] = "Student '{$row['admission_no']}' not found";
                continue;
            }

            $class = $this->db->where('class_code', $row['class_code'])->get('academic_class')->row();
            if (!$class) {
                $errors[] = "Class '{$row['class_code']}' not found";
                continue;
            }

            if ($this->academic_enrolment_model->isEnrolled($student->id, $class->id)) {
                $errors[] = "Student already enrolled in class";
                continue;
            }

            $insert_data = array(
                'student_id' => $student->id,
                'class_id' => $class->id,
                'enrolment_date' => isset($row['enrolment_date']) ? $row['enrolment_date'] : date('Y-m-d'),
                'status' => isset($row['status']) ? $row['status'] : 'Enrolled',
                'notes' => isset($row['notes']) ? trim($row['notes']) : null
            );

            $this->academic_enrolment_model->enrol($insert_data);
            $imported++;
        }

        echo json_encode(array(
            'status' => 'success',
            'imported' => $imported,
            'errors' => $errors
        ));
    }

    /**
     * Validate API token
     */
    private function validate_api_token($token)
    {
        if (empty($token)) {
            return false;
        }

        // Check against stored API tokens in settings
        $api_token = $this->setting_model->getByType('api_token');
        if ($api_token && $api_token->value === $token) {
            return true;
        }

        // Fallback: check if token matches a staff member's API token
        $staff = $this->db->where('api_token', $token)->where('is_active', 1)->get('staff')->row();
        return $staff ? true : false;
    }
}
