<?php
/**
 * TVET Student Admission - Code Snippet
 * This shows ONLY the changed sections of Student::create()
 * For full context, see STUDENT_CONTROLLER_TVET_REFACTORING.md
 */

// ============================================================================
// SECTION 1: Load TVET data for form dropdowns
// INSERT AFTER line 428 ($data['classlist'] = $class;)
// ============================================================================

// TVET: Get programmes, qualifications, levels for dropdowns
$session = $this->setting_model->getCurrentSession();
$data['programmes'] = $this->programme_model->get();
$data['qualifications'] = $this->qualification_model->get(); // Will be filtered by JS
$data['levels'] = $this->level_model->get();

// Get available classes for current session (will be filtered by JS)
$data['available_classes'] = $this->classmodel_model->getClassesBySession($session['id']);

// ============================================================================
// SECTION 2: Update form validation
// REPLACE lines 478-479
// ============================================================================

// OLD (REMOVE):
// $this->form_validation->set_rules('class_id', $this->lang->line('class'), 'trim|required|xss_clean');
// $this->form_validation->set_rules('section_id', $this->lang->line('section'), 'trim|required|xss_clean');

// NEW (ADD):
$this->form_validation->set_rules('programme_id', $this->lang->line('programme'), 'trim|required|xss_clean');
$this->form_validation->set_rules('qualification_id', $this->lang->line('qualification'), 'trim|required|xss_clean');
$this->form_validation->set_rules('level_id', $this->lang->line('level'), 'trim|required|xss_clean');
$this->form_validation->set_rules('class_ids[]', $this->lang->line('classes'), 'trim|required|xss_clean');

// ============================================================================
// SECTION 3: Replace student_session creation with TVET enrollment
// REPLACE lines 560-795 (the enrollment section)
// ============================================================================

// OLD CODE TO REMOVE (lines 560-777):
// $class_id = $this->input->post('class_id');
// $section_id = $this->input->post('section_id');
// ...
// $student_session_id = $this->student_model->add_student_session($data_new);

// NEW CODE (TVET):
// Get TVET data from POST
$programme_id = $this->input->post('programme_id');
$qualification_id = $this->input->post('qualification_id');
$level_id = $this->input->post('level_id');
$class_ids = $this->input->post('class_ids'); // Array of class IDs
$enrolment_types = $this->input->post('enrolment_types'); // Array of Core/Elective

$fees_discount = $this->input->post('fees_discount');
$route_pickup_point_id = $this->input->post('route_pickup_point_id');
$vehroute_id = $this->input->post('vehroute_id');
$hostel_room_id = $this->input->post('hostel_room_id');

if (empty($vehroute_id)) $vehroute_id = null;
if (empty($route_pickup_point_id)) $route_pickup_point_id = null;
if (empty($hostel_room_id)) $hostel_room_id = 0;

// Step 1: Create student_programme record (main programme registration)
$programme_data = array(
    'student_id' => $insert_id,
    'programme_id' => $programme_id,
    'qualification_id' => $qualification_id,
    'current_level_id' => $level_id,
    'session_id' => $session,
    'registration_date' => date('Y-m-d'),
    'status' => 'Active',
    'student_number' => $data_insert['admission_no'], // Use admission number
    'is_active' => 1
);

$student_programme_id = $this->studentprogramme_model->add($programme_data);

if (!$student_programme_id) {
    $this->session->set_flashdata('error', 'Failed to create student programme');
    redirect('student/create');
}

// Step 2: Create enrolment records for each selected class
$enrolment_ids = array();
$enrolment_errors = array();

foreach ($class_ids as $index => $class_id) {
    // Determine enrolment type (default to Core if not specified)
    $enrolment_type = isset($enrolment_types[$index]) ? $enrolment_types[$index] : 'Core';

    $enrolment_data = array(
        'student_id' => $insert_id,
        'class_id' => $class_id,
        'session_id' => $session,
        'enrolment_date' => date('Y-m-d'),
        'enrolment_type' => $enrolment_type,
        'status' => 'Active',
        'hostel_room_id' => $hostel_room_id,
        'vehroute_id' => $vehroute_id,
        'route_pickup_point_id' => $route_pickup_point_id,
        'transport_fees' => null, // Will be calculated later
        'fees_discount' => $fees_discount,
        'is_active' => 1
    );

    // Use enrolment_model's enrollStudent method (has validation)
    $result = $this->enrolment_model->enrollStudent($enrolment_data);

    if ($result['success']) {
        $enrolment_ids[] = $result['enrolment_id'];
    } else {
        $enrolment_errors[] = $result['message'];
    }
}

// Step 3: Assign fees to each enrolment
if ($fee_session_group_id && !empty($enrolment_ids)) {
    foreach ($enrolment_ids as $enrolment_id) {
        $this->studentfeemaster_model->assign_bulk_fees($fee_session_group_id, $enrolment_id, array());
    }
}

// Step 4: Assign fee discounts to each enrolment
$discount_id = $this->input->post('discount_id[]');
if (!empty($discount_id) && !empty($enrolment_ids)) {
    foreach ($enrolment_ids as $enrolment_id) {
        foreach ($discount_id as $discount_value) {
            $insert_array = array(
                'enrolment_id' => $enrolment_id, // Changed from student_session_id
                'fees_discount_id' => $discount_value,
            );
            $this->feediscount_model->allotdiscount($insert_array);
        }
    }
}

// Step 5: Assign transport fees (if any)
$transport_feemaster_id = $this->input->post('transport_feemaster_id');
if (!empty($transport_feemaster_id) && !empty($enrolment_ids)) {
    // Transport fees are typically assigned to the FIRST enrolment
    // (or you could assign to all enrolments - depends on business logic)
    $primary_enrolment_id = $enrolment_ids[0];

    $trns_data_insert = array();
    foreach ($transport_feemaster_id as $transport_value) {
        $trns_data = array(
            'enrolment_id' => $primary_enrolment_id, // Changed from student_session_id
            'transport_feemaster_id' => $transport_value,
        );
        $trns_data_insert[] = $trns_data;
    }

    if (!empty($trns_data_insert)) {
        $this->studenttransportfee_model->add($trns_data_insert);
    }
}

// Success message with enrollment summary
$success_msg = 'Student added successfully. Enrolled in ' . count($enrolment_ids) . ' class(es).';
if (!empty($enrolment_errors)) {
    $success_msg .= ' Warnings: ' . implode(', ', $enrolment_errors);
}

$this->session->set_flashdata('msg', '<div class="alert alert-success">' . $success_msg . '</div>');

// ============================================================================
// SECTION 4: Update student transport fee and admission date assignment
// These still reference student_session_id and need updating
// ============================================================================

// Find and replace ALL occurrences of:
// 'student_session_id' => $student_session_id
// with:
// 'enrolment_id' => $primary_enrolment_id  // or appropriate enrolment_id

// Example locations to update:
// - Line ~798-810: transport fee assignment
// - Line ~815-825: admission date assignments
// - Line ~830-840: student documents

// ============================================================================
// END OF CRITICAL CHANGES
// ============================================================================
