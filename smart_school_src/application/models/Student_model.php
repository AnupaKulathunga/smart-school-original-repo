<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Student_model extends MY_Model
{
    protected $current_session;

    public function __construct()
    {
        parent::__construct();
        $this->current_session = $this->setting_model->getCurrentSession();
        $this->current_date    = $this->setting_model->getDateYmd();
    }

    public function getBirthDayStudents($date, $email = false, $contact_no = false)
    {
        $userdata            = $this->customlib->getUserData();
        $class_section_array = $this->customlib->get_myClassSection();
        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no,students.roll_no,students.admission_date,students.firstname,students.middlename,  students.lastname,students.image,students.mobileno,students.email ,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender,users.id as `user_tbl_id`,users.username,users.password as `user_tbl_password`,users.is_active as `user_tbl_active`,students.app_key,students.parent_app_key', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('users.role', 'student');
        $this->db->where('e.status', 'Active');
        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->db->where_in('e.class_id', $class_ids);
            }
        }
        if ($email) {
            $this->db->where('students.email !=', "");
        }
        if ($contact_no) {
            $this->db->where('students.mobileno !=', "");
        }

        $this->db->where("DATE_FORMAT(students.dob,'%m-%d') = DATE_FORMAT('" . $date . "','%m-%d')");
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');

        $query  = $this->db->get();
        $result = $query->result_array();
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $result = array();
        }
        return $result;
    }

    public function getStudents()
    {
        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no,students.roll_no,students.admission_date,students.firstname,students.middlename,  students.lastname,students.image,students.mobileno, students.email ,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,    students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code,students.guardian_name, students.guardian_relation,students.guardian_email,students.guardian_phone,students.guardian_address,students.is_active,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender,users.id as `user_tbl_id`,users.username,users.password as `user_tbl_password`,users.is_active as `user_tbl_active`,students.app_key,students.parent_app_key', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('users.role', 'student');
        $this->db->where('e.status', 'Active');
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getAppStudents()
    {
        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,  students.middlename,students.lastname,students.image,    students.mobileno, students.email ,students.state ,   students.city , students.pincode ,     students.religion,     students.dob ,students.current_address,    students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code , students.guardian_name , students.app_key ,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender,users.id as `user_tbl_id`,users.username,users.password as `user_tbl_password`,users.is_active as `user_tbl_active`', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('students.app_key !=', "");
        $this->db->where('users.role', 'student');
        $this->db->where('e.status', 'Active');
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');
        $query = $this->db->get();
        return $query->result();
    }

    public function getRecentRecord($id = null)
    {
        $this->db->select('e.class_id AS `class_id`,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email,students.state,students.city,students.pincode,students.religion,students.dob,students.current_address,    students.permanent_address,students.category_id,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code,students.guardian_name,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.father_phone,students.father_occupation,students.mother_name,students.mother_phone,students.mother_occupation,students.guardian_occupation,students.gender,students.guardian_is', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e','e.student_id = students.id');
        $this->db->join('academic_class ac','ac.id = e.class_id');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('e.status', 'Active');
        if ($id != null) {
            $this->db->where('students.id', $id);
        }
        $this->db->group_by('students.id');
        $this->db->order_by('students.id', 'desc');
        $this->db->limit(5);
        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
        }
    }

    public function getParentChilds($parent_id)
    {
        $sql   = "SELECT students.*, e.id as `student_session_id`, ac.session_id, students.id as student_id, e.class_id, ac.class_code as class
                  FROM students
                  INNER JOIN academic_class_enrolment e ON e.student_id = students.id
                  INNER JOIN academic_class ac ON ac.id = e.class_id
                  WHERE students.parent_id=" . $this->db->escape($parent_id) . "
                  AND ac.session_id=" . $this->current_session . "
                  AND students.is_active = 'yes'
                  AND e.status = 'Active'
                  GROUP BY students.id
                  ORDER BY e.class_id asc";
        $query = $this->db->query($sql);
        return $query->result();
    }

    public function getStudentByClassSectionID($class_id = null, $section_id = null, $id = null, $session_id = null)
    {
        if ($session_id != "") {
            $session_id = $session_id;
        } else {
            $session_id = $this->current_session;
        }

        $this->db->select('NULL as pickup_point_name,0 as route_pickup_point_id,0 as vehroute_id,0 as route_id,0 as vehicle_id,NULL as route_title,NULL as vehicle_no,hostel_rooms.room_no,NULL as driver_name,NULL as driver_contact,hostel.id as `hostel_id`,hostel.hostel_name,room_types.id as `room_type_id`,room_types.room_type,students.hostel_room_id,e.id as `student_session_id`,0 as fees_discount,e.class_id AS `class_id`,ac.class_code as class,students.id,students.admission_no,students.roll_no,students.admission_date,students.firstname, students.middlename,students.lastname,students.image,students.mobileno,students.email,students.state,students.city,students.pincode, students.note, students.religion,students.cast,school_houses.house_name,students.dob,students.current_address,students.previous_school,
            students.guardian_is,students.parent_id,
            students.permanent_address,students.category_id,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code,students.guardian_name,students.father_pic,students.height,students.weight,students.measurement_date, students.mother_pic,students.guardian_pic, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active,students.created_at ,students.updated_at,students.father_name,students.father_phone,students.blood_group,students.school_house_id,students.father_occupation,students.mother_name,students.mother_phone,students.mother_occupation,students.guardian_occupation,students.gender,students.guardian_is,students.rte,students.guardian_email,sessions.session, users.username,users.password,students.dis_reason,students.dis_note,students.app_key,students.parent_app_key', FALSE)->from('students');

        $this->db->join('sessions', 'sessions.id = ac.session_id');
        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('hostel_rooms', 'hostel_rooms.id = students.hostel_room_id', 'left');
        $this->db->join('hostel', 'hostel.id = hostel_rooms.hostel_id', 'left');
        $this->db->join('room_types', 'room_types.id = hostel_rooms.room_type_id', 'left');
        $this->db->join('school_houses', 'school_houses.id = students.school_house_id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');

        $this->db->where('e.class_id', $class_id);
        $this->db->where('ac.session_id', $session_id);
        $this->db->where('e.status', 'Active');
        $this->db->where('users.role', 'student');

        if ($id != null) {
            $this->db->where('students.id', $id);
        } else {
            $this->db->where('students.is_active', 'yes');
            $this->db->order_by('students.id', 'desc');
        }
        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
        }
    }

    public function getByStudentSession($student_session_id)
    {
        $this->db->select('0 as route_pickup_point_id,0 as transport_fees,students.app_key,hostel_rooms.room_no,hostel.id as `hostel_id`,hostel.hostel_name,room_types.id as `room_type_id`,room_types.room_type,students.hostel_room_id,e.id as `student_session_id`,0 as fees_discount,e.class_id AS `class_id`,ac.class_code as class,ac.id as `class_section_id`,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email ,students.state,students.city,students.pincode,students.note, students.religion, students.cast, school_houses.house_name,students.dob ,students.current_address,students.previous_school,students.guardian_is,students.parent_id,students.permanent_address,students.category_id,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code ,students.guardian_name ,students.father_pic ,students.height ,students.weight,students.measurement_date, students.mother_pic ,students.guardian_pic ,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.father_phone,students.blood_group,students.school_house_id,students.father_occupation,students.mother_name,students.mother_phone,students.mother_occupation,students.guardian_occupation,students.gender,students.guardian_is,students.rte,students.guardian_email, users.username,users.password,students.dis_reason,students.dis_note,students.app_key,students.parent_app_key,students.is_disabled,students.disability_type_id,students.disability_details', FALSE)->from('students');
        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id', 'left');
        $this->db->join('academic_class ac', 'ac.id = e.class_id', 'left');
        $this->db->join('hostel_rooms', 'hostel_rooms.id = students.hostel_room_id', 'left');
        $this->db->join('hostel', 'hostel.id = hostel_rooms.hostel_id', 'left');
        $this->db->join('room_types', 'room_types.id = hostel_rooms.room_type_id', 'left');
        $this->db->join('school_houses', 'school_houses.id = students.school_house_id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('users.role', 'student');
        $this->db->where('e.id', $student_session_id);
        $query = $this->db->get();
        return $query->row_array();
    }

    /**
     * Get the student_session record for current session
     * Used to retrieve saved preferences like last_programme_id
     */
    public function getStudentSessionRecord($student_id)
    {
        $this->db->select('ss.*');
        $this->db->from('student_session ss');
        $this->db->where('ss.student_id', $student_id);
        $this->db->where('ss.session_id', $this->current_session);
        $this->db->limit(1);
        return $this->db->get()->row();
    }

    /**
     * Save the student's last selected programme for auto-login
     */
    public function saveLastProgramme($student_id, $programme_id)
    {
        $this->db->where('student_id', $student_id);
        $this->db->where('session_id', $this->current_session);
        $this->db->update('student_session', array('last_programme_id' => $programme_id));
    }

    /**
     * TVET: Get student by enrolment ID
     * Replaces getByStudentSession() for TVET model
     * Uses academic_class_enrolment and academic_class tables
     */
    public function getByEnrolment($enrolment_id)
    {
        $this->db->select('enrolment.id as enrolment_id,
            enrolment.id as student_session_id,
            enrolment.class_id,
            class.class_code,
            class.id as class_section_id,
            class.cohort_name,
            class.academic_year,
            subject.name as subject_name,
            level.code as level_code,
            level.name as level_name,
            CONCAT(subject.name, " - ", level.code) as class,
            sessions.session as session,
            0 as route_pickup_point_id,
            0 as transport_fees,
            0 as fees_discount,
            students.id,
            students.admission_no,
            students.roll_no,
            students.admission_date,
            students.firstname,
            students.middlename,
            students.lastname,
            students.image,
            students.mobileno,
            students.email,
            students.state,
            students.city,
            students.pincode,
            students.note,
            students.religion,
            students.cast,
            students.dob,
            students.current_address,
            students.previous_school,
            students.guardian_is,
            students.parent_id,
            students.permanent_address,
            students.category_id,
            students.adhar_no,
            students.samagra_id,
            students.bank_account_no,
            students.bank_name,
            students.ifsc_code,
            students.guardian_name,
            students.father_pic,
            students.height,
            students.weight,
            students.measurement_date,
            students.mother_pic,
            students.guardian_pic,
            students.guardian_relation,
            students.guardian_phone,
            students.guardian_address,
            students.is_active,
            students.created_at,
            students.updated_at,
            students.father_name,
            students.father_phone,
            students.blood_group,
            students.school_house_id,
            students.father_occupation,
            students.mother_name,
            students.mother_phone,
            students.mother_occupation,
            students.guardian_occupation,
            students.gender,
            students.rte,
            students.guardian_email,
            students.dis_reason,
            students.dis_note,
            students.app_key,
            students.parent_app_key,
            students.is_disabled,
            students.disability_type_id,
            students.disability_details,
            school_houses.house_name,
            users.username,
            users.password,
            hostel_rooms.room_no,
            hostel.id as hostel_id,
            hostel.hostel_name,
            room_types.id as room_type_id,
            room_types.room_type,
            students.hostel_room_id', FALSE)
            ->from('academic_class_enrolment enrolment')
            ->join('students', 'students.id = enrolment.student_id')
            ->join('academic_class class', 'class.id = enrolment.class_id')
            ->join('academic_subject_level subject_level', 'subject_level.id = class.subject_level_id')
            ->join('academic_subject subject', 'subject.id = subject_level.subject_id')
            ->join('academic_level level', 'level.id = subject_level.level_id')
            ->join('sessions', 'sessions.id = class.session_id', 'left')
            ->join('school_houses', 'school_houses.id = students.school_house_id', 'left')
            ->join('users', 'users.user_id = students.id AND users.role = "student"', 'left')
            ->join('hostel_rooms', 'hostel_rooms.id = students.hostel_room_id', 'left')
            ->join('hostel', 'hostel.id = hostel_rooms.hostel_id', 'left')
            ->join('room_types', 'room_types.id = hostel_rooms.room_type_id', 'left')
            ->where('enrolment.id', $enrolment_id)
            ->where('class.session_id', $this->current_session);

        $query = $this->db->get();
        return $query->row_array();
    }

    public function getStudentBy_class_section_id($cls_section_id)
    {
        $i = 1;

        $custom_fields   = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);

        $this->db->select('0 as transport_fees,students.app_key,0 as vehroute_id,0 as route_id,0 as vehicle_id,NULL as route_title,NULL as vehicle_no,hostel_rooms.room_no,NULL as driver_name,NULL as driver_contact,hostel.id as `hostel_id`,hostel.hostel_name,room_types.id as `room_type_id`,room_types.room_type,students.hostel_room_id,e.id as `student_session_id`,0 as fees_discount,e.class_id AS `class_id`,ac.class_code as class,ac.id as `class_section_id`,students.id,students.admission_no,students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email ,students.state,students.city, students.pincode,students.note, students.religion, students.cast, school_houses.house_name,students.dob ,students.current_address, students.previous_school,students.guardian_is,students.parent_id,students.permanent_address,students.category_id,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code,students.guardian_name,students.father_pic ,students.height ,students.weight,students.measurement_date, students.mother_pic,students.guardian_pic,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.father_phone,students.blood_group,students.school_house_id,students.father_occupation,students.mother_name,students.mother_phone,students.mother_occupation,students.guardian_occupation,students.gender,students.guardian_is,students.rte,students.guardian_email, users.username,users.password,students.dis_reason,students.dis_note,students.app_key,students.parent_app_key,IFNULL(categories.category, "") as `category`,' . $field_variable, FALSE)->from('students');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('hostel_rooms', 'hostel_rooms.id = students.hostel_room_id', 'left');
        $this->db->join('hostel', 'hostel.id = hostel_rooms.hostel_id', 'left');
        $this->db->join('room_types', 'room_types.id = hostel_rooms.room_type_id', 'left');

        $this->db->join('school_houses', 'school_houses.id = students.school_house_id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('e.class_id', $cls_section_id);
        $this->db->where('e.status', 'Active');
        $this->db->where('users.role', 'student');
        $this->db->where('students.is_active', 'yes');
        $this->db->group_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function get($id = null)
    {
        $this->db->select('NULL as pickup_point_name,0 as route_pickup_point_id,0 as transport_fees,students.app_key,students.parent_app_key,0 as vehroute_id,0 as route_id,0 as vehicle_id,NULL as route_title,NULL as vehicle_no,hostel_rooms.room_no,NULL as driver_name,NULL as driver_contact,NULL as vehicle_model,NULL as manufacture_year,NULL as driver_licence,NULL as vehicle_photo,hostel.id as `hostel_id`,hostel.hostel_name,room_types.id as `room_type_id`,room_types.room_type ,students.hostel_room_id,e.id as `student_session_id`,0 as fees_discount,e.class_id AS `class_id`,ac.class_code as class,ac.id as `class_section_id`,students.id,students.admission_no,students.roll_no,students.admission_no,students.admission_date,students.firstname,students.middlename, students.lastname,students.image,students.mobileno, students.email ,students.state,students.city,students.pincode,students.note,students.religion,students.cast, school_houses.house_name,students.dob,students.current_address,students.previous_school,students.guardian_is,students.parent_id,  students.permanent_address,students.category_id,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code,students.guardian_name,students.father_pic ,students.height,students.weight,students.measurement_date, students.mother_pic,students.guardian_pic,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.father_phone,students.blood_group,students.school_house_id,students.father_occupation,students.mother_name,students.mother_phone,students.mother_occupation,students.guardian_occupation,students.gender,students.guardian_is,students.rte,students.guardian_email, users.username,users.password,users.id as user_id,students.dis_reason,students.dis_note,students.disable_at,students.about,students.designation,students.is_disabled,students.disability_type_id,students.disability_details,disability_types.name as disability_type_name', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id', 'left');
        $this->db->join('academic_class ac', 'ac.id = e.class_id', 'left');
        $this->db->join('hostel_rooms', 'hostel_rooms.id = students.hostel_room_id', 'left');
        $this->db->join('hostel', 'hostel.id = hostel_rooms.hostel_id', 'left');
        $this->db->join('room_types', 'room_types.id = hostel_rooms.room_type_id', 'left');


        $this->db->join('school_houses', 'school_houses.id = students.school_house_id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        $this->db->join('disability_types', 'disability_types.id = students.disability_type_id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('users.role', 'student');
        if ($id != null) {
            $this->db->where('students.id', $id);
        } else {
            $this->db->where('students.is_active', 'yes');
            $this->db->order_by('students.id', 'desc');
        }
        $this->db->group_by('students.id');
        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
        }
    }

    public function findByAdmission($admission_no = null)
    {
        $this->db->select('0 as transport_fees,0 as route_id,0 as vehicle_id,NULL as route_title,NULL as vehicle_no,hostel_rooms.room_no,NULL as driver_name,NULL as driver_contact,hostel.id as `hostel_id`,hostel.hostel_name,room_types.id as `room_type_id`,room_types.room_type ,students.hostel_room_id,e.id as `student_session_id`,0 as fees_discount,e.class_id AS `class_id`,ac.class_code as class,students.id,students.admission_no,students.roll_no,students.admission_date,students.firstname, students.middlename,students.lastname,students.image,students.mobileno,students.email,students.state,students.city,students.pincode,students.note,students.religion, students.cast,school_houses.house_name,students.dob,students.current_address,students.previous_school,
            students.guardian_is,students.parent_id,            students.permanent_address,students.category_id,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code,students.guardian_name,students.father_pic ,students.height ,students.weight,students.measurement_date, students.mother_pic,students.guardian_pic, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.father_phone,students.blood_group,students.school_house_id,students.father_occupation,students.mother_name,students.mother_phone,students.mother_occupation,students.guardian_occupation,students.gender,students.guardian_is,students.rte,students.guardian_email, users.username,users.password,students.dis_reason,students.dis_note', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id', 'left');
        $this->db->join('academic_class ac', 'ac.id = e.class_id', 'left');
        $this->db->join('hostel_rooms', 'hostel_rooms.id = students.hostel_room_id', 'left');
        $this->db->join('hostel', 'hostel.id = hostel_rooms.hostel_id', 'left');
        $this->db->join('room_types', 'room_types.id = hostel_rooms.room_type_id', 'left');


        $this->db->join('school_houses', 'school_houses.id = students.school_house_id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('users.role', 'student');
        $this->db->where('students.is_active', 'yes');
        $this->db->where('students.admission_no', $admission_no);
        $query = $this->db->get();
        if ($query->num_rows() > 0) {
            return $query->row();
        }
        return false;
    }

    public function search_alumniStudent($class_id = null, $section_id = null, $session_id = null)
    {
        $i = 1;

        $custom_fields   = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);

        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,GROUP_CONCAT(ac.class_code) as class,students.id,students.admission_no,students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno,students.email,students.state,students.city, students.pincode,students.religion,students.dob,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code , students.guardian_name,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender,' . $field_variable, FALSE)->from('students');

        $this->db->join('academic_class_enrolment e','e.student_id = students.id', 'left');
        $this->db->join('academic_class ac','ac.id = e.class_id', 'left');
        $this->db->join('categories','students.category_id = categories.id', 'left');
        $this->db->where('e.status', 'Completed');
        $this->db->where('students.is_active', "yes");
        if ($class_id != null) {
            $this->db->where('e.class_id', $class_id);
        }
        if ($session_id != null) {
            $this->db->where('ac.session_id', $session_id);
        }
        $this->db->group_by('students.id');
        $this->db->order_by('students.admission_no', 'asc');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getSearchFullView($searchterm, $start, $limit, $search, $carray)
    {
        $class_section_array = $this->customlib->get_myClassSection();
        $userdata            = $this->customlib->getUserData();
        $staff_id            = $userdata['id'];

        $i             = 1;
        $custom_fields = $this->customfield_model->get_custom_fields('students', 1);

        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

      $field_variable = (empty($field_var_array))? "": ",".implode(',', $field_var_array);

        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->db->where_in('e.class_id', $class_ids);
            }
        }

        $this->db->select('e.class_id AS `class_id`,students.id,e.id as student_session_id,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email ,students.state,students.city,students.pincode,students.religion,students.dob,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code,students.father_name , students.guardian_name,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active,students.created_at ,students.updated_at,students.gender,students.rte,ac.session_id' . $field_variable, FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->join('school_houses', 'students.school_house_id = school_houses.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        $this->db->group_start();
        $this->db->like('students.firstname', $searchterm);
        $this->db->or_like('students.middlename', $searchterm);
        $this->db->or_like('students.lastname', $searchterm);
        $this->db->or_like('school_houses.house_name', $searchterm);
        $this->db->or_like('students.guardian_name', $searchterm);
        $this->db->or_like('students.adhar_no', $searchterm);
        $this->db->or_like('students.samagra_id', $searchterm);
        $this->db->or_like('students.roll_no', $searchterm);
        $this->db->or_like('students.admission_no', $searchterm);
        $this->db->or_like('students.mobileno', $searchterm);
        $this->db->or_like('students.email', $searchterm);
        $this->db->or_like('students.religion', $searchterm);
        $this->db->or_like('students.cast', $searchterm);
        $this->db->or_like('students.gender', $searchterm);
        $this->db->or_like('students.current_address', $searchterm);
        $this->db->or_like('students.permanent_address', $searchterm);
        $this->db->or_like('students.blood_group', $searchterm);
        $this->db->or_like('students.bank_name', $searchterm);
        $this->db->or_like('students.ifsc_code', $searchterm);
        $this->db->or_like('students.father_name', $searchterm);
        $this->db->or_like('students.father_phone', $searchterm);
        $this->db->or_like('students.father_occupation', $searchterm);
        $this->db->or_like('students.mother_name', $searchterm);
        $this->db->or_like('students.mother_phone', $searchterm);
        $this->db->or_like('students.mother_occupation', $searchterm);
        $this->db->or_like('students.guardian_name', $searchterm);
        $this->db->or_like('students.guardian_relation', $searchterm);
        $this->db->or_like('students.guardian_phone', $searchterm);
        $this->db->or_like('students.guardian_occupation', $searchterm);
        $this->db->or_like('students.guardian_address', $searchterm);
        $this->db->or_like('students.guardian_email', $searchterm);
        $this->db->or_like('students.previous_school', $searchterm);
        $this->db->or_like('students.note', $searchterm);
        $this->db->group_end();

        $searchable = 'students.admission_no,students.firstname,students.middlename,students.lastname,ac.class_code,students.father_name,students.dob,students.gender,categories.category,students.mobileno' . $field_variable;
        $column     = explode(',', $searchable);

        $search_colomn        = array();

        foreach ($column as $key => $col) {
            $col         = strtolower($col);
            $col         = strstr($col, ' as ', true) ?: $col;
            $search_colomn[] = $col;
        }
       $search= $search['value'];
        if ($search != '' && $searchable != '') {
                for ($i = 0; $i < count($search_colomn); $i++) {
                    if ($i == 0) {
                        $this->db->group_start();
                        $this->db->like($search_colomn[$i], $search);
                    } else {
                        $this->db->or_like($search_colomn[$i], $search);
                    }

                    if (count($search_colomn) - 1 == $i) //last loop
                    {
                        $this->db->group_end();
                    }
                    //close bracket
                }    
        } 

        $this->db->group_by('students.id');
		if($limit != -1){
			$this->db->limit($limit, $start);
		}else{
		    $this->db->limit(null, null);
		}
        $this->db->order_by('students.id');
        $query  = $this->db->get();
        $result = $query->result_array();
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $result = array();
        }
        return $result;
    }

    public function search_alumniStudentbyAdmissionNo($searchterm, $carray)
    {
        $userdata        = $this->customlib->getUserData();
        $staff_id        = $userdata['id'];
        $i               = 1;
        $custom_fields   = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);

        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            if (!empty($carray)) {
                $this->db->where_in("e.class_id", $carray);
            } else {
                $this->db->where_in("e.class_id", "");
            }
        }
        $this->db->select('e.class_id AS `class_id`,students.id,e.id as student_session_id,GROUP_CONCAT(ac.class_code) as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email ,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code ,students.father_name,students.guardian_name,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at,students.updated_at,students.gender,students.rte,ac.session_id,' . $field_variable, FALSE)->from('students');

        $this->db->join('academic_class_enrolment e','e.student_id = students.id', 'left');
        $this->db->join('academic_class ac','ac.id = e.class_id', 'left');
        $this->db->join('categories','students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active','yes');
        $this->db->where('e.status', 'Completed');
        $this->db->group_start();
        $this->db->like('students.admission_no', $searchterm);
        $this->db->group_end();
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function guardian_credential($parent_id)
    {
        $this->db->select('id,user_id,username,password')->from('users');
        $this->db->where('id', $parent_id);
        $query = $this->db->get();
        return $query->row_array();
    }

    public function search_student()
    {
        $this->db->select('e.class_id AS `class_id`,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email ,students.state,students.city,students.pincode,students.religion,students.dob,students.current_address,students.permanent_address,students.category_id,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code,students.guardian_name,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.father_phone,students.father_occupation,students.mother_name,students.mother_phone,students.mother_occupation,students.guardian_occupation', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('e.status', 'Active');
        if ($id != null) {
            $this->db->where('students.id', $id);
        } else {
            $this->db->order_by('students.id');
        }
        $this->db->group_by('students.id');
        $query = $this->db->get();
        if ($id != null) {
            return $query->row_array();
        } else {
            return $query->result_array();
        }
    }

    public function getstudentdoc($id)
    {
        $this->db->select()->from('student_doc');
        $this->db->where('student_id', $id);
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getDatatableByClassSection($class_id = null, $section_id = null)
    {
        $this->datatables
            ->select('e.class_id as `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,  students.lastname,students.image,students.mobileno,students.email,students.state,students.city, students.pincode,students.religion,students.dob,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code ,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.app_key,students.parent_app_key,students.rte,students.gender')
            ->searchable('e.class_id,admission_no,students.firstname,students.middlename,  students.lastname,students.father_name,students.dob,students.guardian_phone')
            ->orderable('e.class_id,admission_no,students.firstname,students.father_name,students.dob,students.guardian_phone')

            ->join('academic_class_enrolment e', 'e.student_id = students.id')
            ->join('academic_class ac', 'ac.id = e.class_id')
            ->join('categories', 'students.category_id = categories.id', 'left')
            ->where('ac.session_id', $this->current_session)
            ->where('students.is_active', "yes")
            ->where('e.status', 'Active')
            ->sort('students.admission_no', 'asc');
        if ($class_id != null) {
            $this->datatables->where('e.class_id', $class_id);
        }

        $this->datatables->from('students');
        return $this->datatables->generate('json');
    }

    public function getDatatableByFullTextSearch($searchterm)
    {
        $userdata            = $this->customlib->getUserData();
        $class_section_array = $this->customlib->get_myClassSection();
        $this->datatables->select('e.class_id as `class_id`,students.id,e.id as `student_session_id`,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,  students.mobileno,students.email ,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code ,students.father_name,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.gender,students.rte,ac.session_id');

        $this->datatables->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->datatables->join('academic_class ac', 'ac.id = e.class_id');
        $this->datatables->join('categories', 'students.category_id = categories.id', 'left');
        $this->datatables->join('school_houses', 'students.school_house_id = school_houses.id', 'left');
        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->datatables->where_in('e.class_id', $class_ids);
            }
        }
        $this->datatables->group_start();
        $this->datatables->or_like_string('students.firstname,students.middlename,students.lastname,school_houses.house_name,students.guardian_name,students.adhar_no,students.samagra_id,students.roll_no,students.admission_no,students.mobileno,students.email,students.religion,students.cast,students.gender,students.current_address,students.permanent_address,students.blood_group,students.bank_name,students.ifsc_code,students.father_name,students.father_phone,students.father_occupation,students.mother_name,students.mother_phone,students.mother_occupation,students.guardian_name,students.guardian_relation,students.guardian_phone,students.guardian_occupation,students.guardian_address,students.guardian_email,students.previous_school,students.note', $searchterm);
        $this->datatables->group_end();
        $this->datatables->where('ac.session_id', $this->current_session);
        $this->datatables->where('students.is_active', 'yes');
        $this->datatables->where('e.status', 'Active');
        $this->datatables->sort('students.admission_no', 'asc');
        $this->datatables->searchable('e.class_id,admission_no,students.firstname,students.middlename,  students.lastname,students.father_name,students.dob,students.guardian_phone');
        $this->datatables->orderable('e.class_id,admission_no,students.firstname,students.father_name,students.dob,students.guardian_phone');
        $this->datatables->from('students');
        $std_data = $this->datatables->generate('json');
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $std_data       = json_decode($std_data);
            $std_data->data = array();
            return json_encode($std_data);
        } else {
            return $std_data;
        }
    }

    /**
     * Search students by class and section
     *
     * TVET MODE: When $section_id is null and $use_tvet_mode is true,
     * this method will query using the academic_class_enrolment table
     * where $class_id represents an academic_class.id
     *
     * LEGACY MODE: When $section_id is provided, uses traditional
     * student_session table with class_id and section_id
     *
     * @param int $class_id Class ID (legacy: classes.id, TVET: academic_class.id)
     * @param int $section_id Section ID (null for TVET mode)
     * @param bool $use_tvet_mode Force TVET mode when section_id is null
     * @return array Array of student records
     */
    public function searchByClassSection($class_id = null, $section_id = null, $use_tvet_mode = false)
    {
        // TVET MODE: When section_id is null and class_id is provided with TVET flag
        // Use academic_class_enrolment to get students
        if ($section_id === null && $class_id !== null && $use_tvet_mode) {
            return $this->searchByAcademicClass($class_id);
        }

        // LEGACY MODE converted to TVET: Uses academic_class_enrolment
        $userdata            = $this->customlib->getUserData();
        $i                   = 1;
        $class_section_array = $this->customlib->get_myClassSection();
        $custom_fields       = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array     = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);

        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,  students.mobileno,students.email,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code, students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_email,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.app_key,students.parent_app_key,students.rte,students.gender,NULL as vehicle_no,NULL as route_title,0 as `route_pickup_point_id`,NULL as `pickup_point`,' . $field_variable, FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');

        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', "yes");
        $this->db->where('e.status', 'Active');
        if ($class_id != null) {
            $this->db->where('e.class_id', $class_id);
        }
        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->db->where_in('e.class_id', $class_ids);
            }
        }
        $this->db->group_by('students.id');
        $this->db->order_by('students.admission_no', 'asc');

        $query = $this->db->get();

        $result = $query->result_array();
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $result = array();
        }

        return $result;
    }

    public function searchByClassSectionWithoutCurrent($class_id = null, $section_id = null, $student_id = null)
    {
        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email ,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code , students.guardian_name , students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', "yes");
        $this->db->where('e.status', 'Active');
        $this->db->where('students.id !=', $student_id);
        if ($class_id != null) {
            $this->db->where('e.class_id', $class_id);
        }
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function searchdatatableByClassSectionCategoryGenderRte($class_id = null, $section_id = null, $category = null, $gender = null, $rte = null)
    {

        if ($class_id != null) {
            $this->datatables->where('e.class_id', $class_id);
        }
        if ($category != null) {
            $this->datatables->where('students.category_id', $category);
        }
        if ($gender != null) {
            $this->datatables->where('students.gender', $gender);
        }
        if ($rte != null) {
            $this->datatables->where('students.rte', $rte);
        }

        $this->datatables->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,students.category_id, categories.category,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code,students.guardian_name , students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender')
            ->searchable('ac.class_code,students.admission_no,students.firstname,students.father_name,students.dob,students.gender,categories.category,students.mobileno,students.samagra_id,students.adhar_no,students.rte')
            ->orderable('ac.class_code,students.admission_no,students.firstname,students.father_name,students.dob,students.gender,categories.category,students.mobileno,students.samagra_id,students.adhar_no,students.rte')

            ->join('academic_class_enrolment e', 'e.student_id = students.id')
            ->join('academic_class ac', 'ac.id = e.class_id')
            ->join('categories', 'students.category_id = categories.id', 'left')
            ->where('ac.session_id', $this->current_session)
            ->where('students.is_active', 'yes')
            ->where('e.status', 'Active')
            ->sort('students.id')
            ->from('students');
        return $this->datatables->generate('json');
    }

    public function searchusersbyFullText($searchterm, $carray = null)
    {
        $class_section_array = $this->customlib->get_myClassSection();
        $userdata            = $this->customlib->getUserData();
        $staff_id            = $userdata['id'];

        $i             = 1;
        $custom_fields = $this->customfield_model->get_custom_fields('students', 1);

        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);

        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->db->where_in('e.class_id', $class_ids);
            }
        }

        $this->db->select('e.class_id AS `class_id`,students.id,e.id as student_session_id,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email ,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code ,students.father_name , students.guardian_name ,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.gender,students.rte,ac.session_id,' . $field_variable, FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->join('school_houses', 'students.school_house_id = school_houses.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        $this->db->group_start();
        $this->db->like('students.firstname', $searchterm);
        $this->db->or_like('students.middlename', $searchterm);
        $this->db->or_like('students.lastname', $searchterm);
        $this->db->or_like('school_houses.house_name', $searchterm);
        $this->db->or_like('students.guardian_name', $searchterm);
        $this->db->or_like('students.adhar_no', $searchterm);
        $this->db->or_like('students.samagra_id', $searchterm);
        $this->db->or_like('students.roll_no', $searchterm);
        $this->db->or_like('students.admission_no', $searchterm);
        $this->db->or_like('students.mobileno', $searchterm);
        $this->db->or_like('students.email', $searchterm);
        $this->db->or_like('students.religion', $searchterm);
        $this->db->or_like('students.cast', $searchterm);
        $this->db->or_like('students.gender', $searchterm);
        $this->db->or_like('students.current_address', $searchterm);
        $this->db->or_like('students.permanent_address', $searchterm);
        $this->db->or_like('students.blood_group', $searchterm);
        $this->db->or_like('students.bank_name', $searchterm);
        $this->db->or_like('students.ifsc_code', $searchterm);
        $this->db->or_like('students.father_name', $searchterm);
        $this->db->or_like('students.father_phone', $searchterm);
        $this->db->or_like('students.father_occupation', $searchterm);
        $this->db->or_like('students.mother_name', $searchterm);
        $this->db->or_like('students.mother_phone', $searchterm);
        $this->db->or_like('students.mother_occupation', $searchterm);
        $this->db->or_like('students.guardian_name', $searchterm);
        $this->db->or_like('students.guardian_relation', $searchterm);
        $this->db->or_like('students.guardian_phone', $searchterm);
        $this->db->or_like('students.guardian_occupation', $searchterm);
        $this->db->or_like('students.guardian_address', $searchterm);
        $this->db->or_like('students.guardian_email', $searchterm);
        $this->db->or_like('students.previous_school', $searchterm);
        $this->db->or_like('students.note', $searchterm);
        $this->db->group_end();
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');
        $query  = $this->db->get();
        $result = $query->result_array();
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $result = array();
        }
        return $result;
    }

    public function admission_report($searchterm, $carray = null, $condition = null)
    {
        $class_section_array = $this->customlib->get_myClassSection();
        $userdata            = $this->customlib->getUserData();

        $i               = 1;
        $custom_fields   = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);

        if ($condition != null) {
            $this->datatables->where($condition);
        }

        /*----------------------------------------*/
        $this->datatables->select('e.class_id AS `class_id`,students.id,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,   students.mobileno,students.email,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code ,students.father_name,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.gender,students.rte,ac.session_id,' . $field_variable);
        $this->datatables->searchable('admission_no,students.firstname,ac.class_code,students.father_name,students.dob,students.admission_date,students.gender,categories.category');
        $this->datatables->orderable('admission_no,students.firstname,ac.class_code,students.father_name,students.dob,students.admission_date,students.gender,categories.category');

        $this->datatables->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->datatables->join('academic_class ac', 'ac.id = e.class_id');
        $this->datatables->join('categories', 'students.category_id = categories.id', 'left');
        $this->datatables->where('ac.session_id', $this->current_session);
        $this->datatables->where('students.is_active', 'yes');
        $this->datatables->where('e.status', 'Active');
        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->datatables->where_in('e.class_id', $class_ids);
            }
        }
        $this->datatables->group_start();
        $this->datatables->or_like_string('students.firstname,students.lastname,students.guardian_name,students.adhar_no,students.samagra_id,students.roll_no,students.admission_no', $searchterm);
        $this->datatables->group_end();
        $this->datatables->sort('students.id');
        $this->datatables->from('students');
        return $this->datatables->generate('json');
    }

    public function student_ratio()
    {
        $i               = 1;
        $custom_fields   = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);

        $this->db->select(' count(DISTINCT students.id) as total_student, SUM(CASE WHEN `gender` = "Male" THEN 1 ELSE 0 END) AS "male",SUM(CASE WHEN `gender` = "Female" THEN 1 ELSE 0 END) AS "female", ac.class_code as class, ac.id as class_id', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        $this->db->group_by('ac.id');
        $this->db->order_by('ac.class_code');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function sibling_report($searchterm, $carray = null, $condition = null)
    {
        $userdata        = $this->customlib->getUserData();
        $i               = 1;
        $custom_fields   = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            if (!empty($carray)) {
                $this->db->where_in("e.class_id", $carray);
            } else {
                $this->db->where_in("e.class_id", "");
            }
        }
        $this->db->select('e.class_id AS `class_id`,students.id,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,   students.mobileno,students.email,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code ,students.father_name,students.mother_name,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.gender,students.rte,ac.session_id,students.parent_id,' . $field_variable, FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        if ($condition != null) {
            $this->db->where($condition);
        }
        $this->db->group_by('students.admission_no');
        $this->db->order_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function sibling_reportsearch($searchterm, $carray = null, $condition = null)
    {
        $userdata        = $this->customlib->getUserData();
        $i               = 1;
        $custom_fields   = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            if (!empty($carray)) {
                $this->db->where_in("e.class_id", $carray);
            } else {
                $this->db->where_in("e.class_id", "");
            }
        }
        $this->db->select('students.parent_id')->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        if ($condition != null) {
            $this->db->where($condition);
        }
        $this->db->group_by('students.parent_id');
        $this->db->group_by('students.admission_no');
        $this->db->order_by('students.father_name');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getStudentListBYStudentsessionID($array)
    {
        $array = implode(',', $array);
        $sql   = ' SELECT students.*, e.id as student_session_id FROM students INNER JOIN academic_class_enrolment e ON students.id = e.student_id WHERE e.id IN (' . $array . ')';
        $query = $this->db->query($sql);
        return $query->result();
    }

    public function remove($id)
    {
        $this->db->trans_start();

        $sql   = "SELECT * FROM `users` WHERE childs LIKE '%," . $id . ",%' OR childs LIKE '" . $id . ",%' OR childs LIKE '%," . $id . "' OR childs = " . $id;
        $query = $this->db->query($sql);

        if ($query->num_rows() > 0) {
            $result      = $query->row();
            $array_slice = explode(',', $result->childs);
            if (count($array_slice) > 1) {
                $arr    = array_diff($array_slice, array($id));
                $update = implode(",", $arr);
                $data   = array('childs' => $update);
                $this->db->where('id', $result->id);
                $this->db->update('users', $data);
            } else {
                $this->db->where('id', $result->id);
                $this->db->delete('users');
            }
        }

        $this->db->where('id', $id);
        $this->db->delete('students');

        $this->db->where('student_id', $id);
        $this->db->delete('academic_class_enrolment');

        $this->db->where('user_id', $id);
        $this->db->where('role', 'student');
        $this->db->delete('users');
        $this->db->trans_complete();

        if ($this->db->trans_status() === false) {
            return false;
        } else {
            return true;
        }
    }

    public function doc_delete($id)
    {
        $this->db->where('id', $id);
        $this->db->delete('student_doc');
    }

    public function add($data, $data_setting = array())
    {
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('students', $data);
            $message   = UPDATE_RECORD_CONSTANT . " On students id " . $data['id'];
            $action    = "Update";
            $record_id = $insert_id = $data['id'];
            $this->log($message, $record_id, $action);
        } else {
            if (!empty($data_setting)) {

                if ($data_setting['adm_auto_insert']) {
                    if ($data_setting['adm_update_status'] == 0) {
                        $data_setting['adm_update_status'] = 1;
                        $this->setting_model->add($data_setting);
                    }
                }
                $this->db->insert('students', $data);
                $insert_id = $this->db->insert_id();
                $message   = INSERT_RECORD_CONSTANT . " On students id " . $insert_id;
                $action    = "Insert";
                $record_id = $insert_id;
                $this->log($message, $record_id, $action);

                return $insert_id;
            }
        }
    }

    public function add_student_sibling($data_sibling)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('student_sibling', $data_sibling);
            $message   = UPDATE_RECORD_CONSTANT . " On  student sibling id " . $data['id'];
            $action    = "Update";
            $record_id = $insert_id = $data['id'];
            $this->log($message, $record_id, $action);
        } else {
            $this->db->insert('student_sibling', $data_sibling);
            $insert_id = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On student sibling id " . $insert_id;
            $action    = "Insert";
            $record_id = $insert_id;
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
            return $insert_id;
        }
    }

    /**
     * TVET: Enrol student into an academic class (upsert).
     * Accepts data with student_id and class_id.
     * Legacy keys (session_id, section_id, transport_fees, etc.) are ignored.
     */
    public function add_student_session($data)
    {
        $this->db->trans_start();
        $this->db->trans_strict(false);

        $enrolment_data = array(
            'student_id' => $data['student_id'],
            'class_id'   => $data['class_id'],
        );
        if (isset($data['enrolment_date'])) {
            $enrolment_data['enrolment_date'] = $data['enrolment_date'];
        }

        $this->db->where('student_id', $data['student_id']);
        $this->db->where('class_id', $data['class_id']);
        $q = $this->db->get('academic_class_enrolment');
        if ($q->num_rows() > 0) {
            $rec = $q->row_array();
            $this->db->where('id', $rec['id']);
            $this->db->update('academic_class_enrolment', $enrolment_data);
            $message   = UPDATE_RECORD_CONSTANT . " On enrolment id " . $rec['id'];
            $action    = "Update";
            $record_id = $rec['id'];
            $this->log($message, $record_id, $action);
        } else {
            $enrolment_data['status'] = 'Active';
            $this->db->insert('academic_class_enrolment', $enrolment_data);
            $id        = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On enrolment id " . $id;
            $action    = "Insert";
            $record_id = $id;
            $this->log($message, $record_id, $action);
        }

        $this->db->trans_complete();

        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            return $record_id;
        }
    }

    /**
     * TVET: Transport not used — returns empty array.
     */
    public function get_student_vehicle_months($student_session_id)
    {
        return array();
    }

    /**
     * TVET: Update enrolment for a student in the current session.
     */
    public function add_student_session_update($data)
    {
        $enrolment_data = array();
        if (isset($data['student_id'])) {
            $enrolment_data['student_id'] = $data['student_id'];
        }
        if (isset($data['class_id'])) {
            $enrolment_data['class_id'] = $data['class_id'];
        }

        if (isset($data['student_id']) && isset($data['class_id'])) {
            $this->db->where('student_id', $data['student_id']);
            $this->db->where('class_id', $data['class_id']);
            $q = $this->db->get('academic_class_enrolment');
            if ($q->num_rows() > 0) {
                $rec = $q->row_array();
                $this->db->where('id', $rec['id']);
                $this->db->update('academic_class_enrolment', $enrolment_data);
            } else {
                $enrolment_data['status'] = 'Active';
                $this->db->insert('academic_class_enrolment', $enrolment_data);
                return $this->db->insert_id();
            }
        }
    }

    /**
     * TVET: Mark student as alumni by setting enrolment status to Completed.
     */
    public function alumni_student_status($data)
    {
        $sql = "UPDATE academic_class_enrolment e
                INNER JOIN academic_class ac ON ac.id = e.class_id
                SET e.status = 'Completed'
                WHERE e.student_id = " . $this->db->escape($data['student_id']) . "
                AND ac.session_id = " . $this->db->escape($this->current_session);
        $this->db->query($sql);
    }

    public function adddoc($data)
    {
        $this->db->insert('student_doc', $data);
        return $this->db->insert_id();
    }

    public function read_siblings_students($parent_id)
    {
        $this->db->select('*')->from('students');
        $this->db->where('parent_id', $parent_id);
        $this->db->where('students.is_active', 'yes');
        $query = $this->db->get();
        return $query->result();
    }

    public function getMySiblings($parent_id, $student_id)
    {
        $this->db->select('students.*,e.class_id as `class_id`,ac.class_code as class,ac.session_id as `session_id`', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id', 'left');
        $this->db->join('academic_class ac', 'ac.id = e.class_id', 'left');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where_not_in('students.id', $student_id);
        $this->db->where('students.parent_id', $parent_id);
        $this->db->where('students.is_active', 'yes');
        $this->db->group_by('students.id');
        $query = $this->db->get();
        return $query->result();
    }

    public function getAttedenceByDateandClass($date)
    {
        $sql   = "SELECT IFNULL(sa.id, 0) as attencence FROM academic_class_enrolment e INNER JOIN academic_class ac ON ac.id = e.class_id LEFT JOIN student_attendences sa ON sa.enrolment_id = e.id AND sa.date=" . $this->db->escape($date) . " AND sa.attendence_type_id != 2 WHERE ac.session_id=" . $this->current_session;
        $query = $this->db->query($sql);
        return $query->result_array();
    }

    public function searchCurrentSessionStudents()
    {
        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,  students.lastname,students.image,    students.mobileno, students.email ,students.state ,   students.city , students.pincode ,     students.religion,     students.dob ,students.current_address,    students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code , students.guardian_name , students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('e.status', 'Active');
        $this->db->group_by('students.id');
        $this->db->order_by('students.firstname', 'asc');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function searchLibraryStudent($class_id = null, $section_id = null)
    {
        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,
           IFNULL(libarary_members.id,0) as `libarary_member_id`,
           IFNULL(libarary_members.library_card_no,0) as `library_card_no`,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno,students.email,students.state,   students.city ,students.pincode ,students.religion,students.dob,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code, students.guardian_name,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->join('libarary_members', 'libarary_members.member_id = students.id and libarary_members.member_type = "student"', 'left');

        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        if ($class_id != null) {
            $this->db->where('e.class_id', $class_id);
        }
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');

        $query = $this->db->get();
        return $query->result_array();
    }

    public function searchNameLike($searchterm)
    {
        $userdata            = $this->customlib->getUserData();
        $class_section_array = $this->customlib->get_myClassSection();
        $this->db->select('e.class_id AS `class_id`,students.id, students.parent_id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,   students.mobileno,students.email,students.state,students.city,students.pincode ,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,      students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code,students.father_name,students.guardian_name, students.guardian_relation,students.guardian_email,students.guardian_phone,students.guardian_address,students.is_active,students.created_at ,students.updated_at,students.gender,students.rte,students.app_key,students.parent_app_key,ac.session_id', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->db->where_in('e.class_id', $class_ids);
            }
        }
        $this->db->group_start();
        $this->db->like('students.firstname', $searchterm);
        $this->db->or_like('students.lastname', $searchterm);
        $this->db->or_like('students.guardian_name', $searchterm);
        $this->db->group_end();
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');
        $this->db->limit(15);
        $query  = $this->db->get();
        $result = $query->result_array();
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $result = array();
        }
        return $result;
    }

    public function searchGuardianNameLike($searchterm)
    {
        $this->db->select('e.class_id AS `class_id`,students.id,`users`.`id` as `guardian_user_id`,students.parent_id,ac.class_code as class,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,  students.mobileno,students.email,students.state , students.city , students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code ,students.father_name,students.guardian_name , students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active,students.created_at ,students.updated_at,students.gender,students.guardian_email,students.rte,ac.session_id,students.app_key,students.parent_app_key', FALSE)->from('students');
        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        $this->db->join('users', 'users.id = students.parent_id');
        $this->db->where('users.role', 'parent');
        $this->db->group_by('students.parent_id');
        $this->db->group_start();
        $this->db->like('students.guardian_name', $searchterm);
        $this->db->group_end();
        $this->db->order_by('students.id');
        $this->db->limit(15);
        $query = $this->db->get();
        return $query->result_array();
    }

    public function searchByClassSectionWithSession($class_id = null, $section_id = null, $session_id = null)
    {
        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,  students.lastname,students.image,students.mobileno,students.email,students.state,students.city , students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        if ($class_id != null) {
            $this->db->where('e.class_id', $class_id);
        }
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function searchNonPromotedStudents($class_id = null, $section_id = null, $promoted_session_id = null, $promoted_class_id = null, $promoted_section_id = null)
    {
        $sql = "SELECT promoted_students.id as `promoted_student_id`, e.class_id AS `class_id`, e.id as `student_session_id`, students.id, ac.class_code as class, students.admission_no, students.roll_no, students.admission_date, students.firstname, students.middlename, students.lastname, students.image, students.mobileno, students.email, students.state, students.city, students.pincode, students.religion, students.dob, students.current_address, students.permanent_address, IFNULL(students.category_id, 0) as `category_id`, IFNULL(categories.category, '') as `category`, students.adhar_no, students.samagra_id, students.bank_account_no, students.bank_name, students.ifsc_code, students.guardian_name, students.guardian_relation, students.guardian_phone, students.guardian_address, students.is_active, students.created_at, students.updated_at, students.father_name, students.rte, students.gender FROM students JOIN academic_class_enrolment e ON e.student_id = students.id JOIN academic_class ac ON ac.id = e.class_id LEFT JOIN categories ON students.category_id = categories.id LEFT JOIN (SELECT * FROM academic_class_enrolment WHERE class_id=" . $this->db->escape($promoted_class_id) . ") as promoted_students ON promoted_students.student_id = students.id WHERE ac.session_id = " . $this->current_session . " AND students.is_active = 'yes' AND e.class_id = " . $this->db->escape($class_id) . " AND e.status = 'Active' AND promoted_students.id IS NULL GROUP BY students.id ORDER BY students.id";

        $query = $this->db->query($sql);
        return $query->result_array();
    }

    public function getPreviousSessionStudent($previous_session_id, $class_id, $section_id)
    {
        $sql   = "SELECT e.student_id as student_id, e.id as current_student_session_id, e.class_id as current_session_class_id, prev_e.id as previous_student_session_id, students.firstname, students.middlename, students.lastname, students.admission_no, students.roll_no, students.father_name, students.admission_date FROM academic_class_enrolment e INNER JOIN academic_class ac ON ac.id = e.class_id INNER JOIN students ON students.id = e.student_id LEFT JOIN (SELECT ace.* FROM academic_class_enrolment ace INNER JOIN academic_class pac ON pac.id = ace.class_id WHERE pac.session_id=" . $this->db->escape($previous_session_id) . ") as prev_e ON e.student_id = prev_e.student_id WHERE ac.session_id=" . $this->current_session . " AND e.class_id=" . $this->db->escape($class_id) . " AND e.status='Active' AND students.is_active='yes' GROUP BY students.id ORDER BY students.firstname ASC";
        $query = $this->db->query($sql);
        return $query->result();
    }

    public function studentGuardianDetails($carray)
    {
        $userdata = $this->customlib->getUserData();
        $this->db->SELECT("students.admission_no,students.firstname,students.middlename,students.mobileno,students.father_phone,students.mother_phone,students.lastname,students.father_name,students.mother_name,students.guardian_name,students.guardian_relation,students.guardian_phone,students.id,ac.class_code as class", FALSE);
        $this->db->from("students");

        $this->db->join("academic_class_enrolment e", "e.student_id = students.id");
        $this->db->join("academic_class ac", "ac.id = e.class_id");
        $this->db->where("students.is_active", "yes");
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('e.status', 'Active');
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            if (!empty($carray)) {
                $this->db->where_in("e.class_id", $carray);
            } else {
                $this->db->where_in("e.class_id", "");
            }
        }
        $this->db->group_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function searchGuardianDetails($class_id, $section_id)
    {
        $this->db->SELECT("students.admission_no,students.firstname,students.middlename,students.lastname,students.mobileno,students.father_phone,students.mother_phone,students.father_name,students.mother_name,students.guardian_name,students.guardian_relation,students.guardian_phone,students.id,ac.class_code as class", FALSE);
        $this->db->from("students");

        $this->db->join("academic_class_enrolment e", "e.student_id = students.id");
        $this->db->join("academic_class ac", "ac.id = e.class_id");
        $this->db->where("students.is_active", "yes");
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('e.status', 'Active');
        $this->db->where('e.class_id', $class_id);
        $this->db->group_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function studentAdmissionDetails($carray = null)
    {
        $userdata = $this->customlib->getUserData();
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            if (!empty($carray)) {
                $this->db->where_in("e.class_id", $carray);
            } else {
                $this->db->where_in("e.class_id", "");
            }
        }
        $query = $this->db->SELECT("students.firstname,students.middlename,students.lastname,students.is_active, students.mobileno, students.id as sid ,students.admission_no, students.admission_date, students.guardian_name, students.guardian_relation,students.guardian_phone,ac.class_code as class,sessions.id", FALSE)->from("students")->join("academic_class_enrolment e", "e.student_id = students.id")->join("academic_class ac", "ac.id = e.class_id")->join("sessions", "ac.session_id = sessions.id")->where("e.status", "Active")->group_by("students.id")->get();
        return $query->result_array();
    }

    public function studentSessionDetails($id)
    {
        $query = $this->db->query("SELECT min(sessions.session) as start, max(sessions.session) as end, min(ac.class_code) as startclass, max(ac.class_code) as endclass FROM academic_class_enrolment e JOIN academic_class ac ON (ac.id = e.class_id) JOIN sessions ON (sessions.id = ac.session_id) WHERE e.student_id = " . $this->db->escape($id));
        return $query->row_array();
    }

    public function searchdatatablebyAdmissionDetails($class_id, $year)
    {
        if (!empty($year)) {
            $this->datatables->where('year(admission_date)', $year);
        }

        $this->datatables->select('students.firstname,students.middlename,students.lastname,students.is_active, students.mobileno, students.id as sid ,students.admission_no, students.admission_date, students.guardian_name,students.guardian_relation,students.guardian_phone,ac.class_code as class,sessions.id')
            ->searchable('students.admission_no,students.firstname,students.admission_date,students.mobileno,students.guardian_name,students.guardian_phone')

            ->join('academic_class_enrolment e','e.student_id = students.id')
            ->join('academic_class ac','ac.id = e.class_id')
            ->join('sessions', 'ac.session_id = sessions.id')
            ->where('e.class_id', $class_id)
            ->where('e.status', 'Active')
            ->group_by('students.id')
            ->orderable('students.admission_no,students.firstname,students.admission_date," "," "," ",students.mobileno,students.guardian_name,students.guardian_phone')
            ->sort('students.id')
            ->from('students');
        return $this->datatables->generate('json');
    }

    public function admissionYear()
    {
        $query = $this->db->SELECT("distinct(year(admission_date)) as year")->where_not_in('admission_date', array('0000-00-00', '1970-01-01'))->get("students");
        return $query->result_array();
    }

    public function getStudentSession($id)
    {
        $query = $this->db->query("SELECT max(ac.session_id) as student_session_id, max(sessions.session) as session FROM academic_class_enrolment e JOIN academic_class ac ON ac.id = e.class_id JOIN sessions ON sessions.id = ac.session_id WHERE e.student_id = " . $this->db->escape($id));
        return $query->row_array();
    }

    public function valid_student_roll()
    {
        $roll_no    = $this->input->post('roll_no');
        $student_id = $this->input->post('studentid');
        $class      = $this->input->post('class_id');

        if ($roll_no != "") {

            if (!isset($student_id)) {
                $student_id = 0;
            }

            if ($this->check_rollno_exists($roll_no, $student_id, $class)) {
                $this->form_validation->set_message('check_exists', 'Roll Number should be unique at Class level');
                return false;
            } else {
                return true;
            }
        }
        return true;
    }

    public function check_rollno_exists($roll_no, $student_id, $class)
    {
        if ($student_id != 0) {
            $data  = array('students.id != ' => $student_id, 'e.class_id' => $class, 'students.roll_no' => $roll_no);
            $query = $this->db->where($data)->join("academic_class_enrolment e", "students.id = e.student_id")->get('students');
            if ($query->num_rows() > 0) {
                return true;
            } else {
                return false;
            }
        } else {
            $this->db->where(array('e.class_id' => $class, 'roll_no' => $roll_no));
            $query = $this->db->join("academic_class_enrolment e", "students.id = e.student_id")->get('students');
            if ($query->num_rows() > 0) {
                return true;
            } else {
                return false;
            }
        }
    }

    public function gethouselist()
    {
        $query = $this->db->where("is_active", "yes")->get("school_houses");
        return $query->result_array();
    }

    public function disableStudent($id, $data)
    {
        $this->db->where("id", $id)->update("students", $data);
    }

    public function getdisableStudent()
    {
        $class_section_array = $this->customlib->get_myClassSection();
        $this->db->select('e.class_id AS `class_id`,students.id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,    students.mobileno,students.email,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,      students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code ,students.father_name,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.gender,students.rte,ac.session_id,dis_reason,dis_note', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'no');
        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->db->where_in('e.class_id', $class_ids);
            }
        }
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function disablestudentByClassSection($class, $section)
    {
        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,  students.mobileno,students.email,students.state,students.city,students.pincode ,students.religion,students.dob,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code , students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender,dis_reason,dis_note', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', "no");
        if ($class != null) {
            $this->db->where('e.class_id', $class);
        }
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');

        $query = $this->db->get();
        return $query->result_array();
    }

    public function disablestudentFullText($searchterm)
    {
        $userdata            = $this->customlib->getUserData();
        $class_section_array = $this->customlib->get_myClassSection();
        $this->db->select('e.class_id AS `class_id`,students.id,ac.class_code as class,students.id,students.admission_no , students.roll_no,students.admission_date,students.firstname,students.middlename, students.lastname,students.image,  students.mobileno,students.email,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,      students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code ,students.father_name,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active,students.created_at ,students.updated_at,students.gender,students.rte,ac.session_id,dis_reason,dis_note', FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->join('school_houses', 'students.school_house_id = school_houses.id', 'left');
        $this->db->where('students.is_active', 'no');
        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->db->where_in('e.class_id', $class_ids);
            }
        }
        $this->db->group_start();
        $this->db->like('students.firstname', $searchterm);
        $this->db->or_like('students.middlename', $searchterm);
        $this->db->or_like('students.lastname', $searchterm);
        $this->db->or_like('school_houses.house_name', $searchterm);
        $this->db->or_like('students.guardian_name', $searchterm);
        $this->db->or_like('students.adhar_no', $searchterm);
        $this->db->or_like('students.samagra_id', $searchterm);
        $this->db->or_like('students.roll_no', $searchterm);
        $this->db->or_like('students.admission_no', $searchterm);
        $this->db->or_like('students.mobileno', $searchterm);
        $this->db->or_like('students.email', $searchterm);
        $this->db->or_like('students.religion', $searchterm);
        $this->db->or_like('students.cast', $searchterm);
        $this->db->or_like('students.gender', $searchterm);
        $this->db->or_like('students.current_address', $searchterm);
        $this->db->or_like('students.permanent_address', $searchterm);
        $this->db->or_like('students.blood_group', $searchterm);
        $this->db->or_like('students.bank_name', $searchterm);
        $this->db->or_like('students.ifsc_code', $searchterm);
        $this->db->or_like('students.father_name', $searchterm);
        $this->db->or_like('students.father_phone', $searchterm);
        $this->db->or_like('students.father_occupation', $searchterm);
        $this->db->or_like('students.mother_name', $searchterm);
        $this->db->or_like('students.mother_phone', $searchterm);
        $this->db->or_like('students.mother_occupation', $searchterm);
        $this->db->or_like('students.guardian_name', $searchterm);
        $this->db->or_like('students.guardian_relation', $searchterm);
        $this->db->or_like('students.guardian_phone', $searchterm);
        $this->db->or_like('students.guardian_occupation', $searchterm);
        $this->db->or_like('students.guardian_address', $searchterm);
        $this->db->or_like('students.guardian_email', $searchterm);
        $this->db->or_like('students.previous_school', $searchterm);
        $this->db->or_like('students.note', $searchterm);
        $this->db->group_end();

        $this->db->group_by('students.id');
        $this->db->order_by('students.id');
        $query  = $this->db->get();
        $result = $query->result_array();
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $result = array();
        }
        return $result;
    }

    /**
     * Get students with disabilities by class and section
     * This queries students where is_disabled = 'yes'
     */
    public function getDisabledStudentsByClassSection($class = null, $section = null, $disability_type_id = null)
    {
        $this->db->select('e.class_id AS `class_id`,students.id,e.id as student_session_id,ac.class_code as class,students.admission_no, students.roll_no,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email,students.dob,students.father_name,students.guardian_name,students.guardian_phone,students.is_active,students.gender,students.is_disabled,students.disability_type_id,students.disability_details,disability_types.name as disability_type_name,disability_types.default_extra_time_percent', FALSE);
        $this->db->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('disability_types', 'disability_types.id = students.disability_type_id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('students.is_disabled', 'yes');
        $this->db->where('e.status', 'Active');
        if ($class != null) {
            $this->db->where('e.class_id', $class);
        }
        if ($disability_type_id != null) {
            $this->db->where('students.disability_type_id', $disability_type_id);
        }
        $this->db->group_by('students.id');
        $this->db->order_by('students.id', 'desc');

        $query = $this->db->get();
        return $query->result_array();
    }

    /**
     * Get students with disabilities by full text search
     */
    public function getDisabledStudentsFullText($searchterm)
    {
        $this->db->select('e.class_id AS `class_id`,students.id,e.id as student_session_id,ac.class_code as class,students.admission_no, students.roll_no,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email,students.dob,students.father_name,students.guardian_name,students.guardian_phone,students.is_active,students.gender,students.is_disabled,students.disability_type_id,students.disability_details,disability_types.name as disability_type_name,disability_types.default_extra_time_percent', FALSE);
        $this->db->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('disability_types', 'disability_types.id = students.disability_type_id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('students.is_disabled', 'yes');
        $this->db->where('e.status', 'Active');
        $this->db->group_start();
        $this->db->like('students.firstname', $searchterm);
        $this->db->or_like('students.middlename', $searchterm);
        $this->db->or_like('students.lastname', $searchterm);
        $this->db->or_like('students.admission_no', $searchterm);
        $this->db->or_like('students.mobileno', $searchterm);
        $this->db->or_like('students.father_name', $searchterm);
        $this->db->or_like('students.guardian_name', $searchterm);
        $this->db->or_like('disability_types.name', $searchterm);
        $this->db->group_end();
        $this->db->group_by('students.id');
        $this->db->order_by('students.id', 'desc');

        $query = $this->db->get();
        return $query->result_array();
    }

    public function getClassSection($id)
    {
        // TVET: Return academic class as a single-entry array for compatibility
        $query = $this->db->SELECT("ac.id, ac.class_code, ac.cohort_name", FALSE)->where("ac.id", $id)->get("academic_class ac");
        return $query->result_array();
    }

    public function getStudentClassSection($id, $sessionid)
    {
        $query = $this->db->SELECT("students.firstname,students.middlename,students.id,students.lastname,students.image, e.id as student_session_id", FALSE)->from("students")->join("academic_class_enrolment e", "e.student_id = students.id")->join("academic_class ac", "ac.id = e.class_id")->where("e.class_id", $id)->where("ac.session_id", $sessionid)->where("e.status", "Active")->where("students.is_active", "yes")->group_by("students.id")->get();

        return $query->result_array();
    }

    public function getStudentsByArray($array)
    {
        $i             = 1;
        $custom_fields = $this->customfield_model->get_custom_fields('students');

        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);

        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no,students.roll_no,students.admission_date,students.firstname, students.middlename,students.lastname,students.image,students.mobileno,students.email,students.state,students.city,students.pincode,students.religion,     students.dob ,students.current_address,students.blood_group,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.cast,students.bank_name, students.ifsc_code,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.mother_name,students.updated_at,students.father_name,students.rte,students.gender,users.id as `user_tbl_id`,users.username,users.password as `user_tbl_password`,users.is_active as `user_tbl_active`,school_houses.house_name,' . $field_variable, FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        $this->db->join('school_houses', 'school_houses.id = students.school_house_id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('users.role', 'student');
        $this->db->where('e.status', 'Active');
        $this->db->where_in('students.id', $array);
        $this->db->order_by('students.id');
        $this->db->group_by('students.id');
        $query = $this->db->get();
        return $query->result();
    }

    public function get_studentsession($student_session_id)
    {
        $query = $this->db->select('sessions.session')->from('academic_class_enrolment e')->join("academic_class ac", "ac.id = e.class_id")->join("sessions", "sessions.id = ac.session_id")->where('e.id', $student_session_id)->get();
        return $query->row_array();
    }

    public function check_adm_exists($admission_no)
    {
        $this->db->where(array('admission_no' => $admission_no));
        $query = $this->db->get('students');
        if ($query->num_rows() > 0) {
            return true;
        } else {
            return false;
        }
    }

    public function getStudentByAdmission($admission_no)
    {
        $this->db->where(array('admission_no' => $admission_no));
        $query = $this->db->get('students');
        if ($query->num_rows() > 0) {
            return $query->row_array();
        } else {
            return false;
        }
    }

    public function lastRecord()
    {
        $last_row = $this->db->select('*')->order_by('id', "desc")->limit(1)->get('students')->row();
        return $last_row;
    }

    public function currentClassSectionById($studentid, $schoolsessionId)
    {
        // TVET: Get class_id from academic_class_enrolment
        return $this->db->select('e.class_id', FALSE)->from('academic_class_enrolment e')->join('academic_class ac', 'ac.id = e.class_id')->where('ac.session_id', $schoolsessionId)->where('e.student_id', $studentid)->where('e.status', 'Active')->limit(1)->get()->row_array();
    }

    public function reportClassSection($class_id = null, $section_id = null)
    {
        $i = 1;

        $custom_fields   = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);

        $this->db->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,  students.mobileno,students.email,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code, students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.rte,students.gender,' . $field_variable, FALSE)->from('students');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', "yes");
        $this->db->where('e.class_id', $class_id);
        $this->db->where('e.status', 'Active');
        $this->db->group_by('students.id');
        $this->db->order_by('students.admission_no', 'asc');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getAllClassSection($class_id = null, $section_id = null)
    {
        // TVET: Return academic_class records
        $this->db->select('ac.id, ac.id as class_id, ac.class_code as class, ac.cohort_name, ac.session_id', FALSE);
        $this->db->from('academic_class ac');
        $this->db->where('ac.session_id', $this->current_session);
        if ($class_id != null) {
            $this->db->where('ac.id', $class_id);
        }
        return $this->db->get()->result_array();
    }

    public function student_profile($condition1, $condition2)
    {
        $this->db->select('0 as transport_fees,0 as vehroute_id,hostel_rooms.room_no,hostel.id as `hostel_id`,hostel.hostel_name,room_types.id as `room_type_id`,room_types.room_type,students.hostel_room_id,e.id as `student_session_id`,0 as fees_discount,e.class_id AS `class_id`,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno,students.email ,students.state,students.city,students.pincode,students.note, students.religion, students.cast,school_houses.house_name,students.dob,students.current_address,students.previous_school,
            students.guardian_is,students.parent_id,students.permanent_address,students.category_id,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code,students.guardian_name,students.father_pic ,students.height ,students.weight,students.measurement_date, students.mother_pic,students.guardian_pic , students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.father_name,students.father_phone,students.blood_group,students.school_house_id,students.father_occupation,students.mother_name,students.mother_phone,students.mother_occupation,students.guardian_occupation,students.gender,students.guardian_is,students.rte,students.guardian_email, users.username,users.password,students.dis_reason,students.dis_note,category', FALSE)->from('students');
        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class ac', 'ac.id = e.class_id');
        $this->db->join('hostel_rooms', 'hostel_rooms.id = students.hostel_room_id', 'left');
        $this->db->join('hostel', 'hostel.id = hostel_rooms.hostel_id', 'left');
        $this->db->join('room_types', 'room_types.id = hostel_rooms.room_type_id', 'left');
        $this->db->join('school_houses', 'school_houses.id = students.school_house_id', 'left');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        $this->db->join('categories', 'categories.id = students.category_id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('users.role', 'student');
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Active');
        if ($condition1 != '') {
            $this->db->where($condition1);
        }
        if ($condition2 != '') {
            $this->db->where($condition2);
        }

        $this->db->group_by('students.id');
        $this->db->order_by('students.id', 'desc');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function bulkdelete($students)
    {
        if (!empty($students)) {

            $this->db->trans_start();
            $student_comma_seprate = implode(', ', $students);
            //delete from students
            $this->db->where_in('id', $students);
            $this->db->delete('students');

            //delete from users
            $this->db->where_in('user_id', $students);
            $this->db->where_in('role', 'student');
            $this->db->delete('users');
            //delete from custom_field_value

            $sql = "DELETE FROM custom_field_values WHERE id IN (select * from (SELECT t2.id as `id` FROM `custom_fields` INNER JOIN custom_field_values as t2 on t2.custom_field_id=custom_fields.id WHERE custom_fields.belong_to='students' and t2.belong_table_id IN (" . implode(', ', $students) . ")) as m2)";

            $query = $this->db->query($sql);

            $sql_parent = "DELETE from users WHERE id in (SELECT id from (SELECT users.*,students.id as `student_id` FROM `users` LEFT JOIN students on users.id= students.parent_id WHERE role ='parent') as a WHERE a.student_id IS NULL)";
            $query      = $this->db->query($sql_parent);

            $this->db->trans_complete();

            if ($this->db->trans_status() === false) {
                return false;
            } else {
                return true;
            }
        }
    }

    public function valid_student_admission_no()
    {
        $admission_no = $this->input->post('admission_no');
        $student_id   = $this->input->post('studentid');

        if ($admission_no != "") {

            if (!isset($student_id)) {
                $student_id = 0;
            }

            if ($this->check_admission_no_exists($admission_no, $student_id)) {
                $this->form_validation->set_message('check_admission_no_exists', 'Admission No Exists');
                return false;
            } else {
                return true;
            }
        }
        return true;
    }

    public function check_admission_no_exists($admission_no, $student_id)
    {
        if ($student_id != 0) {
            $data  = array('students.id != ' => $student_id, 'students.admission_no' => $admission_no);
            $query = $this->db->where($data)->get('students');
            if ($query->num_rows() > 0) {
                return true;
            } else {
                return false;
            }
        } else {
            $this->db->where(array('admission_no' => $admission_no));
            $query = $this->db->get('students');

            if ($query->num_rows() > 0) {
                return true;
            } else {
                return false;
            }
        }
    }

    public function search_alumniStudentReport($class_id = null, $section_id = null, $session_id = null)
    {
        $this->db->select('e.class_id AS `class_id`,students.id,e.id as student_session_id,GROUP_CONCAT(ac.class_code) as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,  students.mobileno,students.email,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code ,students.father_name,students.guardian_name , students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.gender,students.rte,ac.session_id', FALSE)->from('alumni_students');
        $this->db->join('students', 'students.id = alumni_students.student_id');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id', 'left');
        $this->db->join('academic_class ac', 'ac.id = e.class_id', 'left');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('e.status', 'Completed');
        $this->db->where('students.is_active', "yes");
        if ($class_id != null) {
            $this->db->where('e.class_id', $class_id);
        }
        if ($session_id != null) {
            $this->db->where('ac.session_id', $session_id);
        }
        $this->db->group_by('students.id');
        $this->db->order_by('students.admission_no', 'asc');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function search_alumniStudentbyAdmissionNoReport($searchterm, $carray)
    {
        $userdata = $this->customlib->getUserData();
        $staff_id = $userdata['id'];

        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes")) {
            if (!empty($carray)) {
                $this->db->where_in("e.class_id", $carray);
            } else {
                $this->db->where_in("e.class_id", "");
            }
        }
        $this->db->select('e.class_id AS `class_id`,students.id,e.id as student_session_id,GROUP_CONCAT(ac.class_code) as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno,students.email ,students.state,students.city,students.pincode,students.religion,students.dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code ,students.father_name,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.gender,students.rte,ac.session_id', FALSE)->from('alumni_students');
        $this->db->join('students', 'students.id = alumni_students.student_id');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id', 'left');
        $this->db->join('academic_class ac', 'ac.id = e.class_id', 'left');
        $this->db->join('categories', 'students.category_id = categories.id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('students.is_active', 'yes');
        $this->db->where('e.status', 'Completed');
        $this->db->group_start();
        $this->db->like('students.admission_no', $searchterm);
        $this->db->group_end();
        $this->db->group_by('students.id');
        $this->db->order_by('students.id');
        $query = $this->db->get();
        return $query->result_array();
    }

    public function getParentList()
    {
        $sql = "SELECT students.*,users.username,users.password,users.role,users.is_active FROM `students`
        INNER JOIN users on users.id = students.parent_id
        INNER JOIN academic_class_enrolment e ON e.student_id = students.id
        INNER JOIN academic_class ac ON ac.id = e.class_id
        WHERE parent_id != 0 AND ac.session_id = $this->current_session GROUP BY parent_id";
        $query   = $this->db->query($sql);
        $parents = $query->result();

        return $parents;
    }

    public function count_classteachers($class_id, $section_id = null)
    {
        $sql = "SELECT staff.id FROM `subject_timetable` JOIN `subject_group_subjects` ON `subject_timetable`.`subject_group_subject_id` = `subject_group_subjects`.`id` INNER JOIN subjects on subject_group_subjects.subject_id = subjects.id INNER JOIN staff on staff.id=subject_timetable.staff_id WHERE staff.is_active='1' and `subject_timetable`.`class_id` = " . $this->db->escape($class_id) . " AND `subject_timetable`.`session_id` = " . $this->current_session;

        $query   = $this->db->query($sql);
        $count   = $query->result();
        $teacher = array();
        if (!empty($count)) {
            foreach ($count as $key => $value) {
                $teacher[$value->id] = $value->id;
            }
        }

        return count($teacher);
    }

    //===========
    public function check_student_email_exists($str)
    {
        $email = $this->security->xss_clean($str);
        if ($email != "") {
            $id = $this->input->post('student_id');
            if (!isset($id)) {
                $id = 0;
            }

            if ($this->check_data_exists($email, $id)) {
                $this->form_validation->set_message('check_student_email_exists', $this->lang->line('record_already_exist'));
                return false;
            } else {
                return true;
            }
        }
        return true;
    }

    public function check_data_exists($email, $id)
    {
        $this->db->where('email', $email);
        $this->db->where('id !=', $id);
        $query = $this->db->get('students');
        if ($query->num_rows() > 0) {
            return true;
        } else {
            return false;
        }
    }

    public function searchdtByClassSection($class_id = null, $section_id = null)
    {
        $userdata = $this->customlib->getUserData();        
        
		if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $class_section_array = $this->customlib->get_myClassSection();
        }
        
        $i                    = 1;
        $custom_fields        = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array      = array();
        $field_var_array_name = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->datatables->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                array_push($field_var_array_name, 'table_custom_' . $i . '.field_value');
                $i++;
            }
        }

        $field_variable = (empty($field_var_array)) ? "" : "," . implode(',', $field_var_array);
        $field_name     = (empty($field_var_array_name)) ? "" : "," . implode(',', $field_var_array_name);

        if ($class_id != null) {
            $this->datatables->where('e.class_id', $class_id);
        }

        $this->datatables->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,  students.lastname,students.image,students.mobileno,students.email ,students.state,students.city, students.pincode,students.religion,DATE(students.dob) as dob,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name,students.ifsc_code , students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active,students.created_at ,students.updated_at,students.father_name,students.app_key,students.parent_app_key,students.rte,students.gender,' . $field_variable);
        $this->datatables->searchable('students.admission_no,students.firstname,ac.class_code,students.father_name,students.dob,students.gender,categories.category,students.mobileno' . $field_variable);

        $this->datatables->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->datatables->join('academic_class ac', 'ac.id = e.class_id');
        $this->datatables->join('categories', 'students.category_id = categories.id', 'left');

        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->datatables->where_in('e.class_id', $class_ids);
            }
        }

        $this->datatables->where('ac.session_id', $this->current_session);
        $this->datatables->where('students.is_active', "yes");
        $this->datatables->where('e.status', 'Active');
        $this->datatables->orderable('students.admission_no,students.firstname,ac.class_code,students.father_name,students.dob,students.gender,categories.category,students.mobileno,' . $field_name);
        $this->datatables ->from('students');
        $this->datatables->sort('students.admission_no', 'asc');
        return $this->datatables->generate('json');
    }

    public function searchFullText($searchterm, $carray = null)
    {
        $userdata = $this->customlib->getUserData();
        $staff_id = $userdata['id'];

        $i             = 1;
        $custom_fields = $this->customfield_model->get_custom_fields('students', 1);
        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $class_section_array = $this->customlib->get_myClassSection();
        }      

        $field_var_array      = array();
        $field_var_array_name = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name. '`');
                $this->datatables->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                array_push($field_var_array_name, 'table_custom_' . $i . '.field_value');
                $i++;
            }
        }
        $field_variable = (empty($field_var_array)) ? "" : "," . implode(',', $field_var_array);
        $field_name     = (empty($field_var_array_name)) ? "" : "," . implode(',', $field_var_array_name);
      
        $this->datatables->select('e.class_id AS `class_id`,students.id,e.id as student_session_id,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,students.lastname,students.image,students.mobileno, students.email ,students.state,students.city,students.pincode,students.religion,DATE(students.dob) as dob ,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code ,students.father_name,students.guardian_name, students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at ,students.updated_at,students.gender,students.rte,ac.session_id' . $field_variable);

        $this->datatables->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->datatables->join('academic_class ac', 'ac.id = e.class_id');
        $this->datatables->join('categories', 'students.category_id = categories.id', 'left');
        $this->datatables->join('school_houses', 'students.school_house_id = school_houses.id', 'left');

        if (!empty($class_section_array)) {
            $class_ids = array_keys($class_section_array);
            if (!empty($class_ids)) {
                $this->datatables->where_in('e.class_id', $class_ids);
            }
        }

        $this->datatables->group_start();
        $this->datatables->or_like_string('students.firstname,students.middlename,students.lastname,school_houses.house_name,students.guardian_name,students.adhar_no,students.samagra_id,students.roll_no,students.admission_no,students.mobileno,students.email,students.religion,students.cast,students.gender,students.current_address,students.permanent_address,students.blood_group,students.bank_name,students.ifsc_code,students.father_name,students.father_phone,students.father_occupation,students.mother_name,students.mother_phone,students.mother_occupation,students.guardian_name,students.guardian_relation,students.guardian_phone,students.guardian_occupation,students.guardian_address,students.guardian_email,students.previous_school,students.note', $searchterm);
        $this->datatables->group_end();
        $this->datatables->where('ac.session_id', $this->current_session);
        $this->datatables->where('students.is_active', 'yes');
        $this->datatables->where('e.status', 'Active');
        $this->datatables->searchable('students.admission_no,students.firstname,students.middlename,students.lastname,students.roll_no,ac.class_code,students.father_name,students.dob,students.gender,categories.category,students.mobileno' . $field_variable);
        $this->datatables->orderable('students.admission_no,students.firstname,students.middlename,students.lastname,students.roll_no,ac.class_code,students.father_name,students.dob,students.gender,categories.category,students.mobileno' . $field_name);       
        $this->datatables->sort('students.id');
        $this->datatables->from('students');
        $std_data = $this->datatables->generate('json');

        if (($userdata["role_id"] == 2) && ($userdata["class_teacher"] == "yes") && (empty($class_section_array))) {
            $std_data       = json_decode($std_data);
            $std_data->data = array();
            return json_encode($std_data);
        } else {
            return $std_data;
        }
    }

    /* function to get record for login credential report */
    public function getdtforlogincredential($class_id = null, $section_id = null)
    {
        $i               = 1;
        $custom_fields   = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array = array();
        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->datatables->join('custom_field_values as ' . $tb_counter, 'students.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);

        $this->datatables
            ->select('e.class_id AS `class_id`,e.id as student_session_id,students.id,ac.class_code as class,students.id,students.admission_no, students.roll_no,students.admission_date,students.firstname,students.middlename,  students.lastname,students.image,students.mobileno,students.email,students.state,students.city, students.pincode,students.religion,students.dob,students.current_address,students.permanent_address,IFNULL(students.category_id, 0) as `category_id`,IFNULL(categories.category, "") as `category`,students.adhar_no,students.samagra_id,students.bank_account_no,students.bank_name, students.ifsc_code , students.guardian_name,students.guardian_relation,students.guardian_phone,students.guardian_address,students.is_active ,students.created_at,students.updated_at,students.father_name,students.app_key,students.parent_app_key,students.rte,students.gender,' . $field_variable)
            ->searchable('students.admission_no,students.firstname')
            ->orderable('students.admission_no,students.firstname," "," ", " "')

            ->join('academic_class_enrolment e', 'e.student_id = students.id')
            ->join('academic_class ac', 'ac.id = e.class_id')
            ->join('categories', 'students.category_id = categories.id', 'left')
            ->where('ac.session_id', $this->current_session)
            ->where('students.is_active', "yes")
            ->where('e.status', 'Active')
            ->from('students');

        if ($class_id != null) {
            $this->datatables->where('e.class_id', $class_id);
        }
        $this->datatables->sort('students.admission_no', 'asc');
        return $this->datatables->generate('json');

    }

    public function getUndefinedStudent()
    {
        $sql    = "SELECT students.id FROM `students` LEFT JOIN academic_class_enrolment e ON e.student_id=students.id WHERE e.id IS NULL";
        $query  = $this->db->query($sql);
        $result = $query->result();
        return $result;
    }

    public function biometric_attendance($admission_no = null)
    {
        $sql    = "SELECT staff.id,staff.employee_id,staff.name,staff.surname,staff.contact_no,staff.email,'staff' as `table_type` FROM `staff` WHERE employee_id=" . $this->db->escape($admission_no) . " UNION SELECT e.id as `student_session_id`,students.id, students.admission_no,students.firstname,students.middlename,students.lastname,'student' as `table_type` FROM `students` JOIN `academic_class_enrolment` e ON e.`student_id` = `students`.`id` JOIN `academic_class` ac ON ac.`id` = e.`class_id` LEFT JOIN `school_houses` ON `school_houses`.`id` = `students`.`school_house_id` LEFT JOIN `users` ON `users`.`user_id` = `students`.`id` WHERE ac.`session_id` = '" . $this->current_session . "' AND `users`.`role` = 'student' AND `students`.`is_active` = 'yes' AND e.`status` = 'Active' AND `students`.`admission_no` = " . $this->db->escape($admission_no) . " GROUP BY students.id";
        $query  = $this->db->query($sql);
        $result = $query->row();
        return $result;

    }
    //===========

    public function getonlineadmissionreport($class_id = null, $section_id = null, $status = null)
    {
        $this->datatables
            ->select('students.*,online_admissions.form_status,online_admissions.is_enroll,online_admissions.firstname, online_admissions.gender,online_admissions.dob,online_admissions.lastname,online_admissions.paid_status,online_admissions.reference_no,online_admissions.mobileno,ac.class_code as class,(SELECT ifnull(SUM(online_admission_payment.paid_amount),0) as amount  from online_admission_payment WHERE online_admission_payment.online_admission_id= online_admissions.id) as paid_amount', FALSE)
            ->searchable('online_admissions.admission_no,online_admissions.firstname')
            ->orderable('online_admissions.admission_no,online_admissions.firstname,online_admissions.mobileno," ",online_admissions.gender," "," "," "," "," " ," "')
            ->join('students', 'students.admission_no = online_admissions.admission_no', "left")

            ->join('academic_class_enrolment e', 'e.student_id = students.id', 'left')
            ->join('academic_class ac', 'ac.id = e.class_id', 'left')
            ->from('online_admissions');

        if ($class_id != null) {
            $this->datatables->where('e.class_id', $class_id);
        }

        if ($status != null) {
            $this->datatables->where('online_admissions.is_enroll', $status);
        }

        $this->datatables->sort('online_admissions.admission_no', 'desc');
        return $this->datatables->generate('json');
    }

    public function getstudentdetailbyid($id)
    {
        $this->db->select('students.firstname,students.middlename,students.lastname,students.admission_no,students.guardian_name,email,mobileno,guardian_phone,guardian_email');
        $this->db->from('students');
        $this->db->where('students.id', $id);
        $result = $this->db->get();
        return $result->row_array();
    }

    public function check_guardian_email_exists($str)
    {
        $email = $this->security->xss_clean($str);
        if ($email != "") {
            $id = $this->input->post('student_id');
            if (!isset($id)) {
                $id = 0;
            }

            if ($this->check_guardian_data_exists($email, $id)) {
                $this->form_validation->set_message('check_guardian_email_exists', $this->lang->line('record_already_exist'));
                return false;
            } else {
                return true;
            }
        }
        return true;
    }

    public function check_guardian_data_exists($email, $id)
    {
        $this->db->where('guardian_email', $email);
        $this->db->where('id !=', $id);
        $query = $this->db->get('students');
        if ($query->num_rows() > 0) {
            return true;
        } else {
            return false;
        }
    }

    public function check_student_mobile_no_exists($str)
    {
        $mobile = $this->security->xss_clean($str);
        if ($mobile != "") {
            $id = $this->input->post('student_id');
            if (!isset($id)) {
                $id = 0;
            }

            $isexist = $this->check_mobile_no_data_exists($mobile, $id);
            if ($isexist) {
                $this->form_validation->set_message('check_student_mobile_exists', $this->lang->line('record_already_exist'));
                return false;
            }
        }
        return true;
    }

    public function check_mobile_no_data_exists($mobile, $id)
    {
        $this->db->where('mobileno', $mobile);
        $this->db->where('id !=', $id);
        $query = $this->db->get('students');
        if ($query->num_rows() > 0) {
            return true;
        } else {
            return false;
        }
    }

    public function studentdocbyid($id)
    {
        $this->db->select()->from('student_doc');
        $this->db->where('id', $id);
        $query = $this->db->get();
        return $query->row_array();
    }
    
    public function getAdmissionNoByGuardianEmail($student_id,$guardian_email)
    {
        $this->db->select('students.firstname,students.middlename,students.lastname,students.admission_no,students.guardian_email');  
        $this->db->from('students');
        $this->db->where('students.id !=', $student_id);       
        $this->db->where('students.guardian_email', $guardian_email);       
        $query = $this->db->get();
        return $query->row_array();
    }
    
    public function getAdmissionNoByGuardianPhone($student_id,$guardian_phone)
    {
        $this->db->select('students.firstname,students.middlename,students.lastname,students.admission_no,students.guardian_phone');  
        $this->db->from('students');
        $this->db->where('students.id !=', $student_id);       
        $this->db->where('students.guardian_phone', $guardian_phone);       
        $query = $this->db->get();
        return $query->row_array();
    }

    //***student dashboard setting***//
    public function save_student_dashboard_settings($record){

        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well

        $this->db->where('name', $record['name']);
        $q = $this->db->get('student_dashboard_settings');

        if ($q->num_rows() > 0) {
            $results = $q->row();
            $this->db->where('id', $results->id);
            $this->db->update('student_dashboard_settings', $record);
            $message   = UPDATE_RECORD_CONSTANT . " On  student_dashboard_settings id " . $results->id;
            $action    = "Update";
            $record_id = $insert_id = $results->id;
            $this->log($message, $record_id, $action);
        } else {
            $this->db->insert('student_dashboard_settings', $record);
            $insert_id = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On student_dashboard_settings id " . $insert_id;
            $action    = "Insert";
            $record_id = $insert_id;
            $this->log($message, $record_id, $action);
        }

        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
        } else {
            $this->db->trans_commit();
        }
    }

    public function get_module_status(){
        $this->db->select('student_dashboard_settings.*,permission_group.is_active,permission_group.id as groupid')->from('student_dashboard_settings');
        $this->db->join('permission_student', 'permission_student.short_code = student_dashboard_settings.name','left');
        $this->db->join('permission_group', 'permission_group.id = permission_student.group_id','left');
        $query = $this->db->get();
        return $query->result();
    }

    public function get_student_dashboard_setting_status($fieldname){
        $this->db->where('name', $fieldname);
        $this->db->select('is_student');
        $this->db->from('student_dashboard_settings');
        $query  = $this->db->get();
        $result = $query->row_array();
        if(!empty($result)){
        return $result['is_student'];
        }        
    }

	public function get_parent_dashboard_setting_status($fieldname){
        $this->db->where('name', $fieldname);
        $this->db->select('is_parent');
        $this->db->from('student_dashboard_settings');
        $query  = $this->db->get();
        $result = $query->row_array();
        if(!empty($result)){
        return $result['is_parent'];
        }
    }

    // =========================================================================
    // TVET ENROLMENT METHODS
    // =========================================================================
    // These methods support the TVET academic class enrolment model where
    // students are enrolled in subject-level classes rather than traditional
    // class/section combinations.
    // =========================================================================

    /**
     * Get students enrolled in academic class
     * TVET: Replaces searchByClassSection($class_id, $section_id) for TVET mode
     *
     * @param int $class_id Academic class ID from academic_class table
     * @param string $status Enrolment status filter (default: 'Enrolled')
     * @return array Array of student records with enrolment details
     */
    public function getByAcademicClass($class_id, $status = 'Active')
    {
        $this->db->select('s.*,
                          e.id as enrolment_id,
                          e.enrolment_date,
                          e.status as enrolment_status,
                          e.final_mark,
                          e.final_grade,
                          e.id as student_session_id,
                          c.class_code,
                          c.cohort_name,
                          subj.name as subject_name,
                          subj.code as subject_code,
                          l.code as level_code,
                          l.name as level_name', FALSE);
        $this->db->from('students s');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->where('e.class_id', $class_id);
        $this->db->where('s.is_active', 'yes');

        if ($status !== null) {
            $this->db->where('e.status', $status);
        }

        $this->db->order_by('s.lastname', 'ASC');
        $this->db->order_by('s.firstname', 'ASC');

        return $this->db->get()->result();
    }

    /**
     * Get students enrolled in academic class as array
     * TVET: Same as getByAcademicClass but returns array format for compatibility
     *
     * @param int $class_id Academic class ID from academic_class table
     * @param string $status Enrolment status filter (default: 'Enrolled')
     * @return array Array of student records with enrolment details
     */
    public function getByAcademicClassArray($class_id, $status = 'Active')
    {
        $this->db->select('s.*,
                          e.id as enrolment_id,
                          e.enrolment_date,
                          e.status as enrolment_status,
                          e.final_mark,
                          e.final_grade,
                          e.id as student_session_id,
                          c.class_code,
                          c.cohort_name,
                          subj.name as subject_name,
                          subj.code as subject_code,
                          l.code as level_code,
                          l.name as level_name', FALSE);
        $this->db->from('students s');

        $this->db->join('academic_class_enrolment e', 'e.student_id = students.id');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->where('e.class_id', $class_id);
        $this->db->where('s.is_active', 'yes');

        if ($status !== null) {
            $this->db->where('e.status', $status);
        }

        $this->db->order_by('s.lastname', 'ASC');
        $this->db->order_by('s.firstname', 'ASC');

        return $this->db->get()->result_array();
    }

    /**
     * Get all academic classes a student is enrolled in
     * TVET: Returns array of academic class details for a student
     *
     * @param int $student_id Student ID
     * @param int $session_id Session ID (optional, defaults to current session)
     * @return array Array of academic class records
     */
    public function getStudentAcademicClasses($student_id, $session_id = null)
    {
        if ($session_id === null) {
            $session_id = $this->current_session;
        }

        $this->db->select('e.id as enrolment_id,
                          e.enrolment_date,
                          e.status as enrolment_status,
                          e.final_mark,
                          e.final_grade,
                          c.id as class_id,
                          c.class_code,
                          c.cohort_name,
                          c.venue,
                          c.session_id,
                          subj.id as subject_id,
                          subj.name as subject_name,
                          subj.code as subject_code,
                          l.id as level_id,
                          l.code as level_code,
                          l.name as level_name,
                          st.name as lecturer_name,
                          st.surname as lecturer_surname', FALSE);
        $this->db->from('academic_class_enrolment e');

        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->join('staff st', 'st.id = c.primary_lecturer_id', 'left');
        $this->db->where('e.student_id', $student_id);
        $this->db->where('c.session_id', $session_id);

        $this->db->order_by('subj.name', 'ASC');

        return $this->db->get()->result();
    }

    /**
     * Get all academic classes a student is enrolled in (array format)
     * TVET: Same as getStudentAcademicClasses but returns array format
     *
     * @param int $student_id Student ID
     * @param int $session_id Session ID (optional, defaults to current session)
     * @return array Array of academic class records
     */
    public function getStudentAcademicClassesArray($student_id, $session_id = null)
    {
        if ($session_id === null) {
            $session_id = $this->current_session;
        }

        $this->db->select('e.id as enrolment_id,
                          e.enrolment_date,
                          e.status as enrolment_status,
                          e.final_mark,
                          e.final_grade,
                          c.id as class_id,
                          c.class_code,
                          c.cohort_name,
                          c.venue,
                          c.session_id,
                          subj.id as subject_id,
                          subj.name as subject_name,
                          subj.code as subject_code,
                          l.id as level_id,
                          l.code as level_code,
                          l.name as level_name,
                          st.name as lecturer_name,
                          st.surname as lecturer_surname', FALSE);
        $this->db->from('academic_class_enrolment e');

        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->join('staff st', 'st.id = c.primary_lecturer_id', 'left');
        $this->db->where('e.student_id', $student_id);
        $this->db->where('c.session_id', $session_id);

        $this->db->order_by('subj.name', 'ASC');

        return $this->db->get()->result_array();
    }

    /**
     * Check if student is enrolled in academic class
     * TVET: Check enrolment status
     *
     * @param int $student_id Student ID
     * @param int $class_id Academic class ID
     * @return bool True if enrolled
     */
    public function isEnrolledInAcademicClass($student_id, $class_id)
    {
        $this->db->select('e.id');
        $this->db->from('academic_class_enrolment e');

        $this->db->where('e.student_id', $student_id);
        $this->db->where('e.class_id', $class_id);
        $this->db->where('e.status', 'Active');

        return $this->db->get()->num_rows() > 0;
    }

    /**
     * Get student count by academic class
     * TVET: Returns count of students enrolled in an academic class
     *
     * @param int $class_id Academic class ID
     * @param string $status Enrolment status filter (default: 'Enrolled')
     * @return int Count of students
     */
    public function getAcademicClassStudentCount($class_id, $status = 'Active')
    {
        $this->db->select('COUNT(DISTINCT e.student_id) as count', FALSE);
        $this->db->from('academic_class_enrolment e');

        $this->db->join('students s', 's.id = e.student_id');
        $this->db->where('e.class_id', $class_id);
        $this->db->where('s.is_active', 'yes');

        if ($status !== null) {
            $this->db->where('e.status', $status);
        }

        $result = $this->db->get()->row();
        return $result ? (int)$result->count : 0;
    }

    /**
     * Search students by academic class with full details
     * TVET: Enhanced version with custom fields support
     *
     * @param int $class_id Academic class ID
     * @param string $status Enrolment status filter (default: 'Enrolled')
     * @return array Array of student records
     */
    public function searchByAcademicClass($class_id, $status = 'Active')
    {
        $i = 1;
        $custom_fields = $this->customfield_model->get_custom_fields('students', 1);
        $field_var_array = array();

        if (!empty($custom_fields)) {
            foreach ($custom_fields as $custom_fields_key => $custom_fields_value) {
                $tb_counter = "table_custom_" . $i;
                array_push($field_var_array, '`table_custom_' . $i . '`.`field_value` as `' . $custom_fields_value->name.'`');
                $this->db->join('custom_field_values as ' . $tb_counter, 's.id = ' . $tb_counter . '.belong_table_id AND ' . $tb_counter . '.custom_field_id = ' . $custom_fields_value->id, 'left');
                $i++;
            }
        }

        $field_variable = implode(',', $field_var_array);
        $extra_fields = !empty($field_variable) ? ', ' . $field_variable : '';

        $this->db->select('s.id, s.admission_no, s.roll_no, s.admission_date, s.firstname, s.middlename, s.lastname,
                          s.image, s.mobileno, s.email, s.dob, s.gender, s.father_name, s.guardian_name,
                          s.guardian_phone, s.guardian_email, s.is_active, s.app_key, s.parent_app_key,
                          e.id as enrolment_id,
                          e.enrolment_date,
                          e.status as enrolment_status,
                          e.final_mark,
                          e.final_grade,
                          e.id as student_session_id,
                          c.id as class_id,
                          c.class_code,
                          c.cohort_name as class,
                          subj.name as subject_name,
                          subj.code as subject_code,
                          l.code as level_code,
                          l.name as level_name,
                          IFNULL(s.category_id, 0) as category_id,
                          IFNULL(cat.category, "") as category' . $extra_fields, FALSE);
        $this->db->from('students s');

        $this->db->join('academic_class_enrolment e', 'e.student_id = s.id');
        $this->db->join('academic_class c', 'c.id = e.class_id');
        $this->db->join('academic_subject_level sl', 'sl.id = c.subject_level_id');
        $this->db->join('academic_subject subj', 'subj.id = sl.subject_id');
        $this->db->join('academic_level l', 'l.id = sl.level_id');
        $this->db->join('categories cat', 's.category_id = cat.id', 'left');
        $this->db->where('e.class_id', $class_id);
        $this->db->where('s.is_active', 'yes');

        if ($status !== null) {
            $this->db->where('e.status', $status);
        }

        $this->db->order_by('s.admission_no', 'ASC');

        return $this->db->get()->result_array();
    }

    /**
     * Get students by admission numbers for TVET bulk enrolment
     * TVET: Used for import functionality
     *
     * @param array $admission_numbers Array of admission numbers
     * @return array Array of student records
     */
    public function getStudentsByAdmissionNumbers($admission_numbers)
    {
        if (empty($admission_numbers)) {
            return array();
        }

        $this->db->select('s.id, s.admission_no, s.firstname, s.lastname, s.email, s.mobileno, s.is_active,
                          e.id as student_session_id, ac.session_id, e.class_id');
        $this->db->from('students s');
        $this->db->join('academic_class_enrolment e', 'e.student_id = s.id', 'left');
        $this->db->join('academic_class ac', 'ac.id = e.class_id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where_in('s.admission_no', $admission_numbers);

        return $this->db->get()->result();
    }

    /**
     * Get student with current session info by admission number
     * TVET: Used for single student lookup
     *
     * @param string $admission_no Admission number
     * @return object|null Student record or null
     */
    public function getStudentByAdmissionWithSession($admission_no)
    {
        $this->db->select('s.id, s.admission_no, s.firstname, s.lastname, s.email, s.mobileno, s.is_active,
                          e.id as student_session_id, ac.session_id, e.class_id');
        $this->db->from('students s');
        $this->db->join('academic_class_enrolment e', 'e.student_id = s.id', 'left');
        $this->db->join('academic_class ac', 'ac.id = e.class_id', 'left');
        $this->db->where('ac.session_id', $this->current_session);
        $this->db->where('s.admission_no', $admission_no);

        return $this->db->get()->row();
    }

}
