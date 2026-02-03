<?php
/**
 * New AJAX Methods for Student Controller (TVET)
 * ADD these methods to the Student controller
 */

/**
 * Get qualifications by programme (AJAX)
 * Called when programme dropdown changes
 */
public function getQualificationsByProgramme()
{
    $programme_id = $this->input->post('programme_id');

    if (!$programme_id) {
        echo '<option value="">Select Qualification</option>';
        return;
    }

    $qualifications = $this->qualification_model->getByProgramme($programme_id);

    $html = '<option value="">Select Qualification</option>';
    foreach ($qualifications as $qual) {
        $html .= '<option value="' . $qual->id . '">' . $qual->name . '</option>';
    }

    echo $html;
}

/**
 * Get available classes by programme and level (AJAX)
 * Returns HTML table rows for class selection
 */
public function getClassesByProgrammeLevel()
{
    $programme_id = $this->input->post('programme_id');
    $level_id = $this->input->post('level_id');
    $session_id = $this->input->post('session_id');

    if (!$programme_id || !$level_id || !$session_id) {
        echo '<tr><td colspan="7">Please select programme and level</td></tr>';
        return;
    }

    $filters = array(
        'programme_id' => $programme_id,
        'level_id' => $level_id,
        'status' => 'Active'
    );

    $classes = $this->classmodel_model->getClassesBySession($session_id, $filters);

    if (empty($classes)) {
        echo '<tr><td colspan="7">No classes available for selected programme and level</td></tr>';
        return;
    }

    $html = '';
    foreach ($classes as $class) {
        $html .= '<tr>';
        $html .= '<td><input type="checkbox" name="class_ids[]" value="' . $class->id . '" class="class-checkbox"></td>';
        $html .= '<td>' . htmlspecialchars($class->class_code) . '</td>';
        $html .= '<td>' . htmlspecialchars($class->subject_name) . '</td>';
        $html .= '<td>' . htmlspecialchars($class->level_name) . '</td>';
        $html .= '<td>' . htmlspecialchars($class->cohort_name) . '</td>';
        $html .= '<td>' . ($class->lecturer_name ? htmlspecialchars($class->lecturer_name) : 'TBA') . '</td>';
        $html .= '<td>';
        $html .= '<select name="enrolment_types[]" class="form-control enrolment-type" disabled>';
        $html .= '<option value="Core" selected>Core</option>';
        $html .= '<option value="Elective">Elective</option>';
        $html .= '</select>';
        $html .= '</td>';
        $html .= '</tr>';
    }

    echo $html;
}

/**
 * Get student's current enrolments (for edit page)
 * Returns JSON with current programme and classes
 */
public function getStudentEnrolments()
{
    $student_id = $this->input->post('student_id');
    $session_id = $this->input->post('session_id');

    if (!$student_id || !$session_id) {
        echo json_encode(array('success' => false, 'message' => 'Missing parameters'));
        return;
    }

    // Get student programme
    $student_programme = $this->studentprogramme_model->getStudentProgramme($student_id, $session_id);

    // Get student enrolments
    $enrolments = $this->enrolment_model->getStudentEnrolments($student_id, $session_id);

    $response = array(
        'success' => true,
        'programme' => $student_programme,
        'enrolments' => $enrolments
    );

    echo json_encode($response);
}

/**
 * Add enrolment to existing student (AJAX)
 * Used in edit student page
 */
public function addEnrolment()
{
    if (!$this->rbac->hasPrivilege('student', 'can_edit')) {
        echo json_encode(array('success' => false, 'message' => 'Access denied'));
        return;
    }

    $student_id = $this->input->post('student_id');
    $class_id = $this->input->post('class_id');
    $enrolment_type = $this->input->post('enrolment_type');
    $session_id = $this->input->post('session_id');

    if (!$student_id || !$class_id || !$session_id) {
        echo json_encode(array('success' => false, 'message' => 'Missing parameters'));
        return;
    }

    $enrolment_data = array(
        'student_id' => $student_id,
        'class_id' => $class_id,
        'session_id' => $session_id,
        'enrolment_date' => date('Y-m-d'),
        'enrolment_type' => $enrolment_type ? $enrolment_type : 'Core',
        'status' => 'Active',
        'is_active' => 1
    );

    $result = $this->enrolment_model->enrollStudent($enrolment_data);
    echo json_encode($result);
}

/**
 * Drop (withdraw) an enrolment (AJAX)
 * Used in edit student page
 */
public function dropEnrolment()
{
    if (!$this->rbac->hasPrivilege('student', 'can_edit')) {
        echo json_encode(array('success' => false, 'message' => 'Access denied'));
        return;
    }

    $enrolment_id = $this->input->post('enrolment_id');

    if (!$enrolment_id) {
        echo json_encode(array('success' => false, 'message' => 'Missing enrolment ID'));
        return;
    }

    $success = $this->enrolment_model->dropClass($enrolment_id);

    if ($success) {
        echo json_encode(array('success' => true, 'message' => 'Class dropped successfully'));
    } else {
        echo json_encode(array('success' => false, 'message' => 'Failed to drop class'));
    }
}

/**
 * Update enrolment type (Core/Elective) (AJAX)
 */
public function updateEnrolmentType()
{
    if (!$this->rbac->hasPrivilege('student', 'can_edit')) {
        echo json_encode(array('success' => false, 'message' => 'Access denied'));
        return;
    }

    $enrolment_id = $this->input->post('enrolment_id');
    $enrolment_type = $this->input->post('enrolment_type');

    if (!$enrolment_id || !$enrolment_type) {
        echo json_encode(array('success' => false, 'message' => 'Missing parameters'));
        return;
    }

    $data = array('enrolment_type' => $enrolment_type);
    $success = $this->enrolment_model->update($enrolment_id, $data);

    if ($success) {
        echo json_encode(array('success' => true, 'message' => 'Enrolment type updated'));
    } else {
        echo json_encode(array('success' => false, 'message' => 'Failed to update'));
    }
}

/**
 * Get classes by level (simpler version)
 * Used for quick class selection
 */
public function getClassesByLevel()
{
    $level_id = $this->input->post('level_id');
    $session_id = $this->input->post('session_id');

    if (!$level_id || !$session_id) {
        echo '<option value="">Select Level First</option>';
        return;
    }

    $classes = $this->classmodel_model->getClassesByLevel($level_id, $session_id);

    $html = '<option value="">Select Class</option>';
    foreach ($classes as $class) {
        $html .= '<option value="' . $class->id . '">';
        $html .= $class->class_code . ' - ' . $class->subject_name;
        $html .= ' (' . $class->cohort_name . ')';
        $html .= '</option>';
    }

    echo $html;
}

/**
 * UPDATED: getByClassAndSection() → getByClass()
 * Get students enrolled in a class (NO section)
 */
public function getByClass()
{
    $class_id = $this->input->post('class_id');

    if (!$class_id) {
        echo json_encode(array());
        return;
    }

    // Get students via enrolment table
    $students = $this->classmodel_model->getClassStudents($class_id);

    // Format for JSON response
    $result = array();
    foreach ($students as $student) {
        $result[] = array(
            'student_id' => $student->student_id,
            'enrolment_id' => $student->enrolment_id,
            'admission_no' => $student->admission_no,
            'firstname' => $student->firstname,
            'lastname' => $student->lastname,
            'fullname' => $student->firstname . ' ' . $student->lastname,
            'mobileno' => $student->mobileno,
            'email' => $student->email,
            'enrolment_type' => $student->enrolment_type,
            'enrolment_date' => $student->enrolment_date,
            'programme_name' => $student->programme_name
        );
    }

    echo json_encode($result);
}

/**
 * Get student count by class
 * Used for dashboard and reports
 */
public function getClassStudentCount()
{
    $class_id = $this->input->post('class_id');

    if (!$class_id) {
        echo json_encode(array('count' => 0));
        return;
    }

    $students = $this->classmodel_model->getClassStudents($class_id);
    echo json_encode(array('count' => count($students)));
}
