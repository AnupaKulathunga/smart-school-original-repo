<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Tvet extends Admin_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model([
            'tvet_programme_model',
            'tvet_qualification_model',
            'tvet_level_model',
            'tvet_cohort_model',
            'tvet_level_module_model',
            'tvet_student_enrolment_model',
            'tvet_lecturer_allocation_model'
        ]);
    }

    public function index()
    {
        $data['title'] = 'TVET Management';
        $data['programmes_count'] = count($this->tvet_programme_model->getAll());
        $data['qualifications_count'] = count($this->tvet_qualification_model->getAll());
        $data['levels_count'] = count($this->tvet_level_model->getAll());
        $data['cohorts_count'] = count($this->tvet_cohort_model->getAll());
        $this->load->view('layout/header');
        $this->load->view('admin/tvet/dashboard', $data);
        $this->load->view('layout/footer');
    }

    // ========================================
    // PROGRAMME MANAGEMENT
    // ========================================

    public function programme()
    {
        $data['title'] = 'Programme Management';
        $data['programmes'] = $this->tvet_programme_model->getAll(false);
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/programme/index', $data);
        $this->load->view('layout/footer');
    }

    public function programme_add()
    {
        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $this->form_validation->set_rules('code', 'Programme Code', 'required|trim|is_unique[tvet_programme.code]');
            $this->form_validation->set_rules('name', 'Programme Name', 'required|trim');

            if ($this->form_validation->run()) {
                $data = [
                    'code'        => $this->input->post('code'),
                    'name'        => $this->input->post('name'),
                    'description' => $this->input->post('description'),
                    'active'      => $this->input->post('active') ? 1 : 0
                ];
                $this->tvet_programme_model->add($data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Programme added successfully</div>');
                redirect('admin/tvet/programme');
            }
        }
        $data['title'] = 'Add Programme';
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/programme/add', $data);
        $this->load->view('layout/footer');
    }

    public function programme_edit($id)
    {
        $data['programme'] = $this->tvet_programme_model->get($id);
        if (!$data['programme']) {
            show_404();
        }

        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $this->form_validation->set_rules('code', 'Programme Code', 'required|trim');
            $this->form_validation->set_rules('name', 'Programme Name', 'required|trim');

            if ($this->form_validation->run()) {
                $update = [
                    'code'        => $this->input->post('code'),
                    'name'        => $this->input->post('name'),
                    'description' => $this->input->post('description'),
                    'active'      => $this->input->post('active') ? 1 : 0
                ];
                $this->tvet_programme_model->update($id, $update);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Programme updated successfully</div>');
                redirect('admin/tvet/programme');
            }
        }
        $data['title'] = 'Edit Programme';
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/programme/edit', $data);
        $this->load->view('layout/footer');
    }

    public function programme_delete($id)
    {
        if ($this->tvet_programme_model->hasQualifications($id)) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Cannot delete programme with existing qualifications</div>');
        } else {
            $this->tvet_programme_model->delete($id);
            $this->session->set_flashdata('msg', '<div class="alert alert-success">Programme deleted successfully</div>');
        }
        redirect('admin/tvet/programme');
    }

    // ========================================
    // QUALIFICATION MANAGEMENT
    // ========================================

    public function qualification()
    {
        $data['title'] = 'Qualification Management';
        $data['qualifications'] = $this->tvet_qualification_model->getAll(false);
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/qualification/index', $data);
        $this->load->view('layout/footer');
    }

    public function qualification_add()
    {
        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $this->form_validation->set_rules('programme_id', 'Programme', 'required|integer');
            $this->form_validation->set_rules('code', 'Qualification Code', 'required|trim');
            $this->form_validation->set_rules('name', 'Qualification Name', 'required|trim');

            if ($this->form_validation->run()) {
                $data = [
                    'programme_id' => $this->input->post('programme_id'),
                    'code'         => $this->input->post('code'),
                    'name'         => $this->input->post('name'),
                    'description'  => $this->input->post('description'),
                    'active'       => $this->input->post('active') ? 1 : 0
                ];
                $this->tvet_qualification_model->add($data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Qualification added successfully</div>');
                redirect('admin/tvet/qualification');
            }
        }
        $data['title'] = 'Add Qualification';
        $data['programmes'] = $this->tvet_programme_model->getAll();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/qualification/add', $data);
        $this->load->view('layout/footer');
    }

    public function qualification_edit($id)
    {
        $data['qualification'] = $this->tvet_qualification_model->get($id);
        if (!$data['qualification']) {
            show_404();
        }

        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $this->form_validation->set_rules('programme_id', 'Programme', 'required|integer');
            $this->form_validation->set_rules('code', 'Qualification Code', 'required|trim');
            $this->form_validation->set_rules('name', 'Qualification Name', 'required|trim');

            if ($this->form_validation->run()) {
                $update = [
                    'programme_id' => $this->input->post('programme_id'),
                    'code'         => $this->input->post('code'),
                    'name'         => $this->input->post('name'),
                    'description'  => $this->input->post('description'),
                    'active'       => $this->input->post('active') ? 1 : 0
                ];
                $this->tvet_qualification_model->update($id, $update);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Qualification updated successfully</div>');
                redirect('admin/tvet/qualification');
            }
        }
        $data['title'] = 'Edit Qualification';
        $data['programmes'] = $this->tvet_programme_model->getAll();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/qualification/edit', $data);
        $this->load->view('layout/footer');
    }

    public function qualification_delete($id)
    {
        if ($this->tvet_qualification_model->hasLevels($id)) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Cannot delete qualification with existing levels</div>');
        } else {
            $this->tvet_qualification_model->delete($id);
            $this->session->set_flashdata('msg', '<div class="alert alert-success">Qualification deleted successfully</div>');
        }
        redirect('admin/tvet/qualification');
    }

    // ========================================
    // LEVEL MANAGEMENT
    // ========================================

    public function level()
    {
        $data['title'] = 'Level Management';
        $data['levels'] = $this->tvet_level_model->getAll(false);
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/level/index', $data);
        $this->load->view('layout/footer');
    }

    public function level_add()
    {
        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $this->form_validation->set_rules('qualification_id', 'Qualification', 'required|integer');
            $this->form_validation->set_rules('code', 'Level Code', 'required|trim');
            $this->form_validation->set_rules('name', 'Level Name', 'required|trim');

            if ($this->form_validation->run()) {
                $data = [
                    'qualification_id' => $this->input->post('qualification_id'),
                    'code'             => $this->input->post('code'),
                    'name'             => $this->input->post('name'),
                    'sequence'         => $this->input->post('sequence') ? $this->input->post('sequence') : 1,
                    'active'           => $this->input->post('active') ? 1 : 0
                ];
                $this->tvet_level_model->add($data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Level added successfully</div>');
                redirect('admin/tvet/level');
            }
        }
        $data['title'] = 'Add Level';
        $data['programmes'] = $this->tvet_programme_model->getAll();
        $data['qualifications'] = $this->tvet_qualification_model->getAll();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/level/add', $data);
        $this->load->view('layout/footer');
    }

    public function level_edit($id)
    {
        $data['level'] = $this->tvet_level_model->get($id);
        if (!$data['level']) {
            show_404();
        }

        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $this->form_validation->set_rules('qualification_id', 'Qualification', 'required|integer');
            $this->form_validation->set_rules('code', 'Level Code', 'required|trim');
            $this->form_validation->set_rules('name', 'Level Name', 'required|trim');

            if ($this->form_validation->run()) {
                $update = [
                    'qualification_id' => $this->input->post('qualification_id'),
                    'code'             => $this->input->post('code'),
                    'name'             => $this->input->post('name'),
                    'sequence'         => $this->input->post('sequence') ? $this->input->post('sequence') : 1,
                    'active'           => $this->input->post('active') ? 1 : 0
                ];
                $this->tvet_level_model->update($id, $update);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Level updated successfully</div>');
                redirect('admin/tvet/level');
            }
        }
        $data['title'] = 'Edit Level';
        $data['programmes'] = $this->tvet_programme_model->getAll();
        $data['qualifications'] = $this->tvet_qualification_model->getAll();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/level/edit', $data);
        $this->load->view('layout/footer');
    }

    public function level_delete($id)
    {
        if ($this->tvet_level_model->hasCohorts($id)) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Cannot delete level with existing cohorts or modules</div>');
        } else {
            $this->tvet_level_model->delete($id);
            $this->session->set_flashdata('msg', '<div class="alert alert-success">Level deleted successfully</div>');
        }
        redirect('admin/tvet/level');
    }

    // ========================================
    // COHORT MANAGEMENT
    // ========================================

    public function cohort()
    {
        $data['title'] = 'Cohort Management';
        $data['cohorts'] = $this->tvet_cohort_model->getAll(false);
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/cohort/index', $data);
        $this->load->view('layout/footer');
    }

    public function cohort_add()
    {
        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $this->form_validation->set_rules('level_id', 'Level', 'required|integer');
            $this->form_validation->set_rules('code', 'Cohort Code', 'required|trim');
            $this->form_validation->set_rules('name', 'Cohort Name', 'required|trim');
            $this->form_validation->set_rules('intake_year', 'Intake Year', 'required|integer');
            $this->form_validation->set_rules('start_date', 'Start Date', 'required');

            if ($this->form_validation->run()) {
                $data = [
                    'level_id'      => $this->input->post('level_id'),
                    'code'          => $this->input->post('code'),
                    'name'          => $this->input->post('name'),
                    'intake_year'   => $this->input->post('intake_year'),
                    'delivery_mode' => $this->input->post('delivery_mode'),
                    'start_date'    => $this->input->post('start_date'),
                    'end_date'      => $this->input->post('end_date') ? $this->input->post('end_date') : null,
                    'max_students'  => $this->input->post('max_students') ? $this->input->post('max_students') : 40,
                    'active'        => $this->input->post('active') ? 1 : 0
                ];
                $this->tvet_cohort_model->add($data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Cohort added successfully</div>');
                redirect('admin/tvet/cohort');
            }
        }
        $data['title'] = 'Add Cohort';
        $data['programmes'] = $this->tvet_programme_model->getAll();
        $data['levels'] = $this->tvet_level_model->getAll();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/cohort/add', $data);
        $this->load->view('layout/footer');
    }

    public function cohort_edit($id)
    {
        $data['cohort'] = $this->tvet_cohort_model->getWithDetails($id);
        if (!$data['cohort']) {
            show_404();
        }

        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $this->form_validation->set_rules('level_id', 'Level', 'required|integer');
            $this->form_validation->set_rules('code', 'Cohort Code', 'required|trim');
            $this->form_validation->set_rules('name', 'Cohort Name', 'required|trim');

            if ($this->form_validation->run()) {
                $update = [
                    'level_id'      => $this->input->post('level_id'),
                    'code'          => $this->input->post('code'),
                    'name'          => $this->input->post('name'),
                    'intake_year'   => $this->input->post('intake_year'),
                    'delivery_mode' => $this->input->post('delivery_mode'),
                    'start_date'    => $this->input->post('start_date'),
                    'end_date'      => $this->input->post('end_date') ? $this->input->post('end_date') : null,
                    'max_students'  => $this->input->post('max_students') ? $this->input->post('max_students') : 40,
                    'active'        => $this->input->post('active') ? 1 : 0
                ];
                $this->tvet_cohort_model->update($id, $update);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Cohort updated successfully</div>');
                redirect('admin/tvet/cohort');
            }
        }
        $data['title'] = 'Edit Cohort';
        $data['programmes'] = $this->tvet_programme_model->getAll();
        $data['qualifications'] = $this->tvet_qualification_model->getByProgramme($data['cohort']['programme_id']);
        $data['levels'] = $this->tvet_level_model->getByQualification($data['cohort']['qualification_id']);
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/cohort/edit', $data);
        $this->load->view('layout/footer');
    }

    public function cohort_delete($id)
    {
        $count = $this->tvet_student_enrolment_model->getActiveCount($id);
        if ($count > 0) {
            $this->session->set_flashdata('msg', '<div class="alert alert-danger">Cannot delete cohort with enrolled students</div>');
        } else {
            $this->tvet_cohort_model->delete($id);
            $this->session->set_flashdata('msg', '<div class="alert alert-success">Cohort deleted successfully</div>');
        }
        redirect('admin/tvet/cohort');
    }

    public function cohort_roster($id)
    {
        $data['cohort'] = $this->tvet_cohort_model->getWithDetails($id);
        if (!$data['cohort']) {
            show_404();
        }
        $data['title'] = 'Cohort Roster - ' . $data['cohort']['name'];
        $data['students'] = $this->tvet_student_enrolment_model->getCohortRoster($id);
        $data['available_students'] = $this->getAvailableStudents($id);
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/cohort/roster', $data);
        $this->load->view('layout/footer');
    }

    public function cohort_add_student($cohort_id)
    {
        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $cohort = $this->tvet_cohort_model->get($cohort_id);
            $data = [
                'student_id'     => $this->input->post('student_id'),
                'level_id'       => $cohort['level_id'],
                'cohort_id'      => $cohort_id,
                'enrolment_date' => date('Y-m-d'),
                'status'         => 'Active',
                'student_number' => $this->input->post('student_number')
            ];
            $this->tvet_student_enrolment_model->add($data);
            $this->session->set_flashdata('msg', '<div class="alert alert-success">Student added to cohort</div>');
        }
        redirect('admin/tvet/cohort_roster/' . $cohort_id);
    }

    public function cohort_remove_student($enrolment_id, $cohort_id)
    {
        $this->tvet_student_enrolment_model->delete($enrolment_id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Student removed from cohort</div>');
        redirect('admin/tvet/cohort_roster/' . $cohort_id);
    }

    public function cohort_change_status()
    {
        $enrolment_id = $this->input->post('enrolment_id');
        $cohort_id = $this->input->post('cohort_id');
        $status = $this->input->post('status');
        $completion_date = ($status == 'Completed') ? date('Y-m-d') : null;

        $this->tvet_student_enrolment_model->update($enrolment_id, [
            'status'          => $status,
            'completion_date' => $completion_date
        ]);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Student status updated</div>');
        redirect('admin/tvet/cohort_roster/' . $cohort_id);
    }

    // ========================================
    // MODULE MAPPING
    // ========================================

    public function module_mapping($level_id = null)
    {
        if (!$level_id) {
            $data['title'] = 'Module Mapping';
            $data['levels'] = $this->tvet_level_model->getAll();
            $this->load->view('layout/header', $data);
            $this->load->view('admin/tvet/module/select_level', $data);
            $this->load->view('layout/footer');
            return;
        }

        $data['level'] = $this->tvet_level_model->getLevelWithDetails($level_id);
        if (!$data['level']) {
            show_404();
        }

        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $module_code = $this->input->post('module_code');
            $module_name = $this->input->post('module_name');
            $subject_id = $this->input->post('subject_id');
            $credits = $this->input->post('credits');
            $semester = $this->input->post('semester');
            $is_core = $this->input->post('is_core');

            $insert = [
                'level_id'    => $level_id,
                'subject_id'  => $subject_id,
                'module_code' => $module_code,
                'module_name' => $module_name,
                'credits'     => $credits ? $credits : 0,
                'semester'    => $semester ? $semester : 'Year',
                'is_core'     => $is_core ? 1 : 0,
                'active'      => 1
            ];
            $this->tvet_level_module_model->add($insert);
            $this->session->set_flashdata('msg', '<div class="alert alert-success">Module mapped successfully</div>');
            redirect('admin/tvet/module_mapping/' . $level_id);
        }

        $data['title'] = 'Module Mapping - ' . $data['level']['name'];
        $data['modules'] = $this->tvet_level_module_model->getByLevel($level_id);
        $data['subjects'] = $this->subject_model->get();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/module/mapping', $data);
        $this->load->view('layout/footer');
    }

    public function module_delete($id, $level_id)
    {
        $this->tvet_level_module_model->delete($id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Module mapping removed</div>');
        redirect('admin/tvet/module_mapping/' . $level_id);
    }

    // ========================================
    // LECTURER ALLOCATION
    // ========================================

    public function lecturer_allocation()
    {
        if ($this->input->server('REQUEST_METHOD') === 'POST') {
            $this->form_validation->set_rules('staff_id', 'Lecturer', 'required|integer');
            $this->form_validation->set_rules('cohort_id', 'Cohort', 'required|integer');
            $this->form_validation->set_rules('level_module_id', 'Module', 'required|integer');

            if ($this->form_validation->run()) {
                $data = [
                    'staff_id'        => $this->input->post('staff_id'),
                    'cohort_id'       => $this->input->post('cohort_id'),
                    'level_module_id' => $this->input->post('level_module_id'),
                    'academic_year'   => $this->input->post('academic_year') ? $this->input->post('academic_year') : date('Y'),
                    'semester'        => $this->input->post('semester') ? $this->input->post('semester') : 'Year',
                    'is_primary'      => $this->input->post('is_primary') ? 1 : 0,
                    'active'          => 1
                ];
                $this->tvet_lecturer_allocation_model->add($data);
                $this->session->set_flashdata('msg', '<div class="alert alert-success">Lecturer allocated successfully</div>');
                redirect('admin/tvet/lecturer_allocation');
            }
        }

        $data['title'] = 'Lecturer Allocation';
        $data['allocations'] = $this->tvet_lecturer_allocation_model->getAll();
        $data['cohorts'] = $this->tvet_cohort_model->getAll();
        $data['staff'] = $this->staff_model->get();
        $this->load->view('layout/header', $data);
        $this->load->view('admin/tvet/lecturer/allocation', $data);
        $this->load->view('layout/footer');
    }

    public function lecturer_delete($id)
    {
        $this->tvet_lecturer_allocation_model->delete($id);
        $this->session->set_flashdata('msg', '<div class="alert alert-success">Allocation removed</div>');
        redirect('admin/tvet/lecturer_allocation');
    }

    // ========================================
    // AJAX ENDPOINTS
    // ========================================

    public function ajax_get_qualifications($programme_id)
    {
        header('Content-Type: application/json');
        echo json_encode($this->tvet_qualification_model->getByProgramme($programme_id));
    }

    public function ajax_get_levels($qualification_id)
    {
        header('Content-Type: application/json');
        echo json_encode($this->tvet_level_model->getByQualification($qualification_id));
    }

    public function ajax_get_cohorts($level_id)
    {
        header('Content-Type: application/json');
        echo json_encode($this->tvet_cohort_model->getByLevel($level_id));
    }

    public function ajax_get_modules($level_id)
    {
        header('Content-Type: application/json');
        echo json_encode($this->tvet_level_module_model->getByLevel($level_id));
    }

    // ========================================
    // HELPERS
    // ========================================

    private function getAvailableStudents($cohort_id)
    {
        $this->db->select('student_id');
        $this->db->from('tvet_student_enrolment');
        $this->db->where('cohort_id', $cohort_id);
        $subquery = $this->db->get_compiled_select();

        $this->db->select('students.id, students.admission_no, students.firstname, students.lastname');
        $this->db->from('students');
        $this->db->where('students.is_active', 'yes');
        $this->db->where("students.id NOT IN ($subquery)", null, false);
        $this->db->order_by('students.firstname', 'ASC');
        return $this->db->get()->result_array();
    }
}
