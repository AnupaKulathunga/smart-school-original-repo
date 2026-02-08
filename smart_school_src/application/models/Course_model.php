<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Course_model extends MY_Model {

    public function __construct() {
        parent::__construct();
        $this->role = '';
        if(!empty($this->session->userdata('student'))){
            $this->role = $this->session->userdata('student')['role'];
        }
    }
 
    /*
    This is used to add or edit course
    */
	function add($data) {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data['id']) && $data['id'] != '') {
            $this->db->where('id', $data['id']);
            $this->db->update('online_courses', $data);
            $message = UPDATE_RECORD_CONSTANT . " On online c1ourses id " . $data['id'];
            $action = "Update";
            $record_id = $data['id'];
            $this->log($message, $record_id, $action);
            //======================Code End==============================
            $this->db->trans_complete(); # Completing transaction
            if ($this->db->trans_status() === false) {
                # Something went wrong.
                $this->db->trans_rollback();
                return false;
            } else {
                return $record_id;
            }
        } else {
            $this->db->insert('online_courses', $data);
            $insert_id = $this->db->insert_id();
            $message = INSERT_RECORD_CONSTANT . " On online courses id " . $insert_id;
            $action = "Insert";
            $record_id = $insert_id;
            $this->log($message, $record_id, $action);
            //======================Code End==============================
            $this->db->trans_complete(); # Completing transaction
            if ($this->db->trans_status() === false) {
                # Something went wrong.
                $this->db->trans_rollback();
                return false;
            } else {
               
            }
            return $insert_id;
        }
    }

    /*
    This is used to getting all teacher list
    */
    public function allteacher() {
        $this->db->select('staff.id,staff.name,staff.surname,staff.employee_id');
        $this->db->from('staff');
        $this->db->join('staff_roles','staff_roles.staff_id=staff.id');
        $this->db->where('staff_roles.role_id','2');
        $this->db->where('staff.is_active','1');
        $query = $this->db->get();
        return $query->result_array();
    }

    /*
    This is used to getting all course list
    */
    public function courselist($userid, $roleid, $limit = '', $start = '', $search = '') {
        if ($limit != "" && ( $start != "" || ($start >= 0))) {
            $this->db->limit($limit, $start);
        }

        if ($search != '') {
            $this->db->like('online_courses.title', $search);
            $this->db->or_like('online_courses.description', $search);
        }

        $this->db->select('online_courses.*,CONCAT(academic_subject.name, " - ", academic_level.code) as class,staff.name,staff.surname,staff.image,staff.gender,staff.employee_id,course_category.category_name', FALSE)->from('online_courses');
        $this->db->join('staff', 'staff.id = online_courses.teacher_id');
        $this->db->join('online_course_academic_class', 'online_course_academic_class.course_id = online_courses.id');
        $this->db->join('academic_class', 'academic_class.id = online_course_academic_class.academic_class_id');
        $this->db->join('academic_subject_level', 'academic_subject_level.id = academic_class.subject_level_id');
        $this->db->join('academic_subject', 'academic_subject.id = academic_subject_level.subject_id');
        $this->db->join('academic_level', 'academic_level.id = academic_subject_level.level_id');
        $this->db->join('course_category', 'course_category.id = online_courses.category_id','left');

        $this->db->group_by('online_course_academic_class.course_id');
        // For teacher
        if($roleid == "2"){
            $this->db->group_start();
            $this->db->where('online_courses.teacher_id',$userid);
            $this->db->or_where('online_courses.created_by',$userid);
            $this->db->group_end();
        }
        $this->db->order_by('online_courses.id', 'desc');
        $query = $this->db->get();
        return  $query->result_array();
    }
    
    /*
    This is used to getting all course list through datatable
    */
    public function getcourselist($userid, $roleid) {

        $condition="" ;
        $where_condition_status=FALSE;

       if($roleid == "2"){
             $this->datatables->where('teacher_id',$userid,true);
             $this->datatables->or_where('created_by',$userid,true);
              $where_condition_status=TRUE;
       }

        $query="select online_courses.*,CONCAT(academic_subject.name, ' - ', academic_level.code) as class,staff.name,staff.surname from online_courses join staff on staff.id = online_courses.teacher_id join online_course_academic_class on online_course_academic_class.course_id = online_courses.id join academic_class on academic_class.id = online_course_academic_class.academic_class_id join academic_subject_level on academic_subject_level.id = academic_class.subject_level_id join academic_subject on academic_subject.id = academic_subject_level.subject_id join academic_level on academic_level.id = academic_subject_level.level_id" ;

        $this->datatables->query($query)
        ->searchable('online_courses.title,academic_subject.name,academic_level.code')
        ->orderable('online_courses.title,academic_subject.name,null,null,null,null,null,null,null,null,updated_date')
        ->query_where_enable($where_condition_status)
        ->group_by('online_course_academic_class.course_id',true)
        ->sort('online_courses.id', 'desc');

        return $this->datatables->generate('json');
    }

    /*
    This is used to getting single course
    */
    public function singlecourselist($courseid) {
        $this->db->select('online_courses.*,online_course_academic_class.id as class_sections_id,CONCAT(academic_subject.name, " - ", academic_level.code) as class,staff.name as staff_name,staff.surname as staff_surname,staff.employee_id as assign_employee_id,s.name,s.surname,s.employee_id,staff.image,staff.gender,online_course_academic_class.academic_class_id as class_sections,staff_roles.role_id', FALSE)->from('online_courses');
        $this->db->where('online_courses.id',$courseid);
        $this->db->join('staff', 'staff.id = online_courses.teacher_id');
        $this->db->join('staff as s', 's.id = online_courses.created_by');
        $this->db->join('staff_roles','staff_roles.staff_id=s.id');
        $this->db->join('online_course_academic_class', 'online_course_academic_class.course_id = online_courses.id');
        $this->db->join('academic_class', 'academic_class.id = online_course_academic_class.academic_class_id');
        $this->db->join('academic_subject_level', 'academic_subject_level.id = academic_class.subject_level_id');
        $this->db->join('academic_subject', 'academic_subject.id = academic_subject_level.subject_id');
        $this->db->join('academic_level', 'academic_level.id = academic_subject_level.level_id');
        $this->db->group_by('online_course_academic_class.course_id');
        $this->db->order_by('online_courses.title', 'asc');
        $query = $this->db->get();
        return $query->row_array();
    }

    /*
    This is used to getting lesson by section id
    */
    public function lessonbysection($id) {
        $this->db->select('*');
        $this->db->from('online_course_lesson');
        $this->db->where('online_section_id',$id);
        $query = $this->db->get();
        return $query->result_array();
    }

    /*
    This is used to add and edit multipal section in course
    */
	public function addsections($data)
    {
        $this->db->trans_start();
        $this->db->trans_strict(false);
        if (isset($data['id'])) {
            $this->db->where('id', $data['id']);
            $this->db->update('online_course_academic_class', $data);
            $message   = UPDATE_RECORD_CONSTANT . " On online_course_academic_class id " . $data['id'];
            $action    = "Update";
            $record_id = $id = $data['id'];
            $this->log($message, $record_id, $action);
        } else {
            $this->db->insert('online_course_academic_class', $data);
            $id        = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On online_course_academic_class id " . $id;
            $action    = "Insert";
            $record_id = $id;
            $this->log($message, $record_id, $action);
        }
        $this->db->trans_complete();
        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
            return false;
        } else {
            return $id;
        }
    }

    /*
    This is used to get total count of section by course id
    */
    public function sectioncount($courseid) {
        $this->db->select('count(course_id) as section_count', FALSE)->from('online_course_academic_class');
        $this->db->where('course_id',$courseid);
        $query = $this->db->get();
        return $query->row_array();
    }

    /*
    This is used to check if an academic class is linked to a course
    */
    public function coursesectionlist($id,$courseid) {
        $this->db->select('*')->from('online_course_academic_class');
        $this->db->where('academic_class_id',$id);
        $this->db->where('course_id',$courseid);
        $query = $this->db->get();
        return $query->row_array();
    }

    /*
    This is used to get academic class ids by course id
    */
    public function sectionbycourse($courseid) {
        $this->db->select('academic_class_id')->from('online_course_academic_class');
        $this->db->where('course_id',$courseid);
        $query = $this->db->get();
        $result =  $query->result_array();
        $results = array();
        foreach ($result as $result_value) {
           $results[] = $result_value['academic_class_id'];
        }
        return $results;
    }

    /*
    This is used to remove an academic class from a course
    */
    public function remove($id,$courseID) {
        $this->db->where('academic_class_id',$id);
        $this->db->where('course_id',$courseID);
        $this->db->delete('online_course_academic_class');
    }

    /*
    This is used to get academic class id by course
    */
    public function getclassid($courseid) {
        $this->db->select('online_course_academic_class.academic_class_id as class_id')->from('online_course_academic_class');
        $this->db->where('online_course_academic_class.course_id',$courseid);
        $query = $this->db->get();
        return $query->row_array();
    }

    /*
    This is used to get selected academic classes by course id
    */
    public function selectedsection($courseid) {
        $this->db->select('online_course_academic_class.academic_class_id')->from('online_course_academic_class');
        $this->db->where('online_course_academic_class.course_id',$courseid);
        $query = $this->db->get();
        return $query->result_array();
    }

    /*
    This is used to get academic class display names by course id
    */
    public function multipalsection($courseid) {
        $this->db->select('CONCAT(academic_subject.name, " - ", academic_level.code) as section, CONCAT(academic_subject.name, " - ", academic_level.code) as class, online_course_academic_class.academic_class_id as class_section_id, online_course_academic_class.academic_class_id as academic_class_id', FALSE)->from('online_course_academic_class');
        $this->db->join('academic_class', 'academic_class.id = online_course_academic_class.academic_class_id');
        $this->db->join('academic_subject_level', 'academic_subject_level.id = academic_class.subject_level_id');
        $this->db->join('academic_subject', 'academic_subject.id = academic_subject_level.subject_id');
        $this->db->join('academic_level', 'academic_level.id = academic_subject_level.level_id');
        $this->db->where('online_course_academic_class.course_id',$courseid);
        $query = $this->db->get();
        return $query->result_array();
    }
	
	/*
    This is used to getting course id based on section id
    */
    public function coursebysection($section_id) {
        $this->db->select('online_courses.id');
		$this->db->join('online_courses', 'online_courses.id = online_course_section.online_course_id');
        $this->db->from('online_course_section');
        $this->db->where('online_course_section.id',$section_id);
        $query = $this->db->get();
        return $query->row_array();
    }
	
	/*
    This is used to get student list based on class section id
    */
	public function getStudentByAcademicClassID($academic_class_ids)
    {
        $this->current_session = $this->setting_model->getCurrentSession();
        $this->db->select('academic_class.id AS class_id, CONCAT(academic_subject.name, " - ", academic_level.code) as class, students.id, students.admission_no, students.roll_no, students.admission_date, students.firstname, students.lastname, students.mobileno, students.guardian_phone, students.guardian_email, students.email, students.previous_school, students.guardian_is, students.parent_id, students.permanent_address, students.is_active, students.created_at, students.updated_at, users.username, students.app_key, students.parent_app_key', FALSE)->from('students');
        $this->db->join('student_session', 'student_session.student_id = students.id');
        $this->db->join('academic_class_enrolment', 'academic_class_enrolment.student_session_id = student_session.id');
        $this->db->join('academic_class', 'academic_class.id = academic_class_enrolment.class_id');
        $this->db->join('academic_subject_level', 'academic_subject_level.id = academic_class.subject_level_id');
        $this->db->join('academic_subject', 'academic_subject.id = academic_subject_level.subject_id');
        $this->db->join('academic_level', 'academic_level.id = academic_subject_level.level_id');
        $this->db->join('users', 'users.user_id = students.id', 'left');
        $this->db->where_in('academic_class.id', $academic_class_ids);
        $this->db->where('student_session.session_id', $this->current_session);
        $this->db->where('users.role', 'student');
        $this->db->where('students.is_active', 'yes');
        $this->db->order_by('students.id', 'desc');
        $query = $this->db->get();
        return $query->result_array();
    }

    // Backward-compatible alias
    public function getStudentByClassSectionID($class_section_id) {
        return $this->getStudentByAcademicClassID($class_section_id);
    }

    /*
     This function is used to delete course and their section, lesson, quiz question, quiz 
     */
    public function delete($id)
    {
        $query  = $this->db->where("online_course_id", $id)->get('online_course_section');
        $result = $query->result_array();
        foreach ($result as $key => $value) {
            $section_id = $value["id"];
            $this->db->where("course_section_id", $section_id)->delete("course_lesson_quiz_order");            
            $this->db->where("course_section_id", $section_id)->delete("online_course_lesson");
            $this->db->where("course_section_id", $section_id)->delete("course_progress");
            $this->db->where("course_section_id", $section_id)->delete("online_course_exam");
            $this->db->where("course_section_id", $section_id)->delete("online_course_assignment");
			
            $quiz_query  = $this->db->where("course_section_id", $section_id)->get('online_course_quiz');
            $quiz_result = $quiz_query->result_array();
            foreach ($quiz_result as $key => $quiz_result_value) {
                $quiz_id = $quiz_result_value['id'];
                $this->db->where("course_quiz_id", $quiz_id)->delete("student_quiz_status");
                $this->db->where("course_quiz_id", $quiz_id)->delete("course_quiz_answer");
                $this->db->where("course_quiz_id", $quiz_id)->delete("course_quiz_question");
            }
            $this->db->where("course_section_id", $section_id)->delete("online_course_quiz");
        }
        $this->db->where("online_course_id", $id)->delete('online_course_section');
        $this->db->where("course_id", $id)->delete('online_course_academic_class');
        $this->db->where("course_id", $id)->delete('course_rating');
        $this->db->where("id", $id)->delete('online_courses'); 
    }

    /*This function is used to get section name by course id */
    public function getsectionnamebycourse($course_id)
    {
        $this->db->select('CONCAT(academic_subject.name, " - ", academic_level.code) as section', FALSE)->from('online_courses');
        $this->db->join('online_course_academic_class', 'online_courses.id = online_course_academic_class.course_id');
        $this->db->join('academic_class', 'academic_class.id = online_course_academic_class.academic_class_id');
        $this->db->join('academic_subject_level', 'academic_subject_level.id = academic_class.subject_level_id');
        $this->db->join('academic_subject', 'academic_subject.id = academic_subject_level.subject_id');
        $this->db->join('academic_level', 'academic_level.id = academic_subject_level.level_id');
        $this->db->where('online_courses.id', $course_id);
        $query = $this->db->get();
        return $query->result_array();
    }

    /*This function is used to update section order*/
    public function updatesectionorder($data) {
        $this->db->update_batch('online_course_section', $data, 'id');
    }

    /*This function is used to update lesson, quiz order */
    public function updatelessonquizorder($data) {
        $this->db->update_batch('course_lesson_quiz_order', $data, 'id');
    }	
	
	public function coursesellcount($course_id) {
        $this->db->select('online_course_payment.id,');
        $this->db->from('online_course_payment');
        $this->db->where('online_course_payment.online_courses_id',$course_id);
        $query = $this->db->get();
        return $query->result_array();
    }

    /*This function is used to add and update s3 bucket settings */
    public function addAwsS3Settings($data)
    {
        $this->db->trans_begin();
        $q = $this->db->get('aws_s3_settings');
        if ($q->num_rows() > 0) {
            $results = $q->row();
            $this->db->where('id', $results->id);
            $this->db->update('aws_s3_settings', $data);
        } else {
            $this->db->insert('aws_s3_settings', $data);
        }
        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
        } else {
            $this->db->trans_commit();
        }
    }
    
    /* This function is used to get s3 bucket settings */
    public function getAwsS3Settings()
    {
        $this->db->select('*');
        $this->db->from('aws_s3_settings');
        $this->db->order_by('aws_s3_settings.id');
        $query = $this->db->get();
        return $query->row();
    }

    /* This is used to get all course rating */
    public function rating(){

        $this->datatables
            ->select('course_rating.*,online_courses.title,CONCAT(academic_subject.name, " - ", academic_level.code) as class')
            ->searchable('online_courses.title,academic_subject.name,academic_level.code,course_rating.rating')
            ->orderable('online_courses.title,academic_subject.name,academic_level.code,course_rating.rating')
            ->join('online_courses','online_courses.id=course_rating.course_id')
            ->join('online_course_academic_class','online_course_academic_class.course_id=online_courses.id','left')
            ->join('academic_class','academic_class.id=online_course_academic_class.academic_class_id','left')
            ->join('academic_subject_level','academic_subject_level.id=academic_class.subject_level_id','left')
            ->join('academic_subject','academic_subject.id=academic_subject_level.subject_id','left')
            ->join('academic_level','academic_level.id=academic_subject_level.level_id','left')
            ->sort('course_rating.id', 'desc');

            $this->datatables->group_by('course_rating.course_id');
            $this->datatables->from('course_rating');
            return $this->datatables->generate('json');
    }

    /*  This function is used to delete rating  */
    public function deleterating($id)
    {
        $this->db->where("id", $id)->delete('course_rating'); 
    }

    /*This is used to getting all course list */
    public function studentcourselist($limit = '', $start = '', $search = '') {

        if ($limit != "" && ( $start != "" || ($start >= 0))) {
            $this->db->limit($limit, $start);
        }
        if ($search != '') {
            $this->db->like('online_courses.title', $search);
            $this->db->or_like('online_courses.description', $search);
        }
        $role = $this->role;
        if($role=='guest' || $role==''){
            $this->db->where('online_courses.front_side_visibility','yes');
        }

        $this->db->select('online_courses.*,CONCAT(academic_subject.name, " - ", academic_level.code) as class,staff.name,staff.surname,staff.image,staff.gender,course_category.category_name', FALSE)->from('online_courses');
        $this->db->join('staff', 'staff.id = online_courses.teacher_id');
        $this->db->join('online_course_academic_class', 'online_course_academic_class.course_id = online_courses.id');
        $this->db->join('academic_class', 'academic_class.id = online_course_academic_class.academic_class_id');
        $this->db->join('academic_subject_level', 'academic_subject_level.id = academic_class.subject_level_id');
        $this->db->join('academic_subject', 'academic_subject.id = academic_subject_level.subject_id');
        $this->db->join('academic_level', 'academic_level.id = academic_subject_level.level_id');
        $this->db->join('course_category', 'course_category.id = online_courses.category_id','left');
        $this->db->where('online_courses.status',1);
        $this->db->group_by('online_course_academic_class.course_id');
        $this->db->order_by('online_courses.id', 'desc');
        $query = $this->db->get();
        return  $query->result_array();
    }   

    public function otherRelatedCourses($id, $created_by, $userid)
    {
        $query = $this->db->select('online_courses.*') 
            ->where('online_courses.status', 1)
            ->where('online_courses.created_by', $created_by)
            ->where('online_courses.front_side_visibility', 'yes')            
            ->where(array('online_courses.id != ' => $id))
            ->get("online_courses");
        $result = $query->result_array();
        foreach ($result as $key => $value) {
             $ratingValue                  = $this->ratingValue($value);
             $hours_count                  = $this->counthours($value["id"]);
             $result[$key]["hours_count"]  = $hours_count;
             $courseSale                   = $this->getCourseSale($value["id"]);
             $result[$key]["course_sale"]  = $courseSale; 
             $result[$key]['rating']       = $ratingValue;
             $lesson_count                 = $this->countlesson($value["id"]);
             $result[$key]["lesson_count"] = $lesson_count;             
             $result[$key]["paidstatus"] = $this->courseofflinepayment_model->paidstatus($id, $userid);             
        }
        return $result;
    }

    public function countlesson($id)
    {
        $this->db->join("online_course_section", "online_course_section.online_course_id = online_courses.id")
            ->join("online_course_lesson", "online_course_lesson.course_section_id = online_course_section.id")
            ->where("online_courses.id", $id);
        $query = $this->db->get('online_courses');
        return $query->num_rows();
    }

    public function counthours($id)
    {
        $this->db->select('online_course_lesson.duration,online_course_lesson.lesson_type,')
            ->join("online_course_section", "online_course_section.online_course_id = online_courses.id")
            ->join("online_course_lesson", "online_course_lesson.course_section_id = online_course_section.id")
            ->where("online_course_lesson.lesson_type", 'video')
            ->where("online_courses.id", $id);
        $query     = $this->db->get('online_courses');
        $result    = $query->result_array();
        $totaltime = 0;
        $hours     = 0;
        $min       = 0;
        $sec       = 0;
        $total       = 0;
        $hh = 0;
        $mm = 0;
        $ss = 0;
        foreach ($result as $rs) {
            if ($rs['lesson_type'] == 'video') {
                $str_arr = explode(":", $rs['duration']);
                $hh      = $str_arr[0] * 3600;
                if(!empty($str_arr[1])){
                $mm      = $str_arr[1] * 60;
                }
                if(!empty($str_arr[2])){
                $ss      = $str_arr[2];
                }
                $total   = $hh + $mm + $ss;
            }
            $totaltime += $total;
        }
        $hours = intval($totaltime / 3600);
        $min1  = $totaltime - ($hours * 3600);
        $min   = intval($min1 / 60);
        $sec   = $totaltime - (($min * 60) + ($hours * 3600));
        if($hours < 10){$hours = "0".$hours;}
        if($min < 10){$min = "0".$min;}
        if($sec < 10){$sec = "0".$sec;}
        
        return $hours . ':' . $min . ':' . $sec;
    }
    
    public function ratingValue($value)
    {
        $courseRating = $this->getCourseRating($value["id"]);       
        $avg          = 0; 
        if (!empty($courseRating)) {
            $sumrating   = array_sum(array_column($courseRating, 'rating'));
            $totalrating = sizeof($courseRating);
            $avg         = $sumrating / $totalrating; 
            $resultRating = $this->customlib->calculateRating($avg);
        } else {
            $resultRating = 0;
        }
        return $resultRating;
        # code...
    }

    public function getCourseRating($id)
    {
        $role           = $this->role;
        if($role=='guest' || $role==''){
              $this->db->where('online_courses.front_side_visibility','yes');
        } 
        $query = $this->db->select('course_rating.*')
            ->join('online_courses', 'online_courses.id = course_rating.course_id') 
            ->where(array('online_courses.status' => 1, 'online_courses.id' => $id))
            ->get('course_rating');
        return $query->result_array();
    }

    public function countRating($number, $id)
    {   
        $query = $this->db->select('course_rating.*')
             ->join('online_courses', 'online_courses.id = course_rating.course_id') 
            ->where(array('online_courses.status' => 1, 'online_courses.id' => $id, 'course_rating.rating' => $number))
            ->get('course_rating');
        return $query->num_rows();
    }

    public function getCourseSale($courseid)
    {
        $query    = $this->db->query("SELECT count(online_courses.id) as total from online_courses JOIN online_course_payment on (online_courses.id = online_course_payment.online_courses_id) WHERE  online_course_payment.online_courses_id = " . $courseid . " ");
        $result   = $query->row_array();
        $earnings = $result['total'];
        return $earnings;
    }

    public function getFilterRating()
    {
        $role           = $this->role;
        $condition = "" ;
        if($role=='guest' || $role==''){
            $condition = " and online_courses.front_side_visibility='yes' " ;
        }
        $query      = $this->db->query("SELECT  DISTINCT(`online_courses`.`id`) as `id`, `online_courses`.`free_course` FROM `online_courses` where `online_courses`.`status` = 1 ".$condition." ");
        $result     = $query->result_array();
        $data       = array();
        $one_star   = 0;
        $two_star   = 0;
        $three_star = 0;
        $four_star  = 0;
        $five_star  = 0;
        foreach ($result as $key => $value) { 
            $ratingValue   = $this->ratingValue($value); 
            $courseRating  = $ratingValue;
            if ($courseRating == 1) {
                $one_star++;
            } elseif (($courseRating == 2)) {
                $two_star++;
            } elseif (($courseRating == 3)) {
                $three_star++;
            } elseif (($courseRating == 4)) {
                $four_star++;
            } elseif (($courseRating == 5)) {
                $five_star++;
            }
        }
        $data[1] = $one_star;
        $data[2] = $two_star;
        $data[3] = $three_star;
        $data[4] = $four_star;
        $data[5] = $five_star;
        return $data;
    }

    public function filterRecords($arr)
    {        
        if ((!empty($arr['searchfield'])) && $arr['searchfield'] != 'courses.id') {
            
            if (($arr['searchfield'] != 'rating') && ($arr['searchfield'] != 'sales')) {
                
                if($arr['searchfield'] == 'online_courses.free_course' && $arr['searchvalue'] =='free'){  
                               
                    $this->db->where("online_courses.free_course",1);
                }elseif( $arr['searchfield'] == 'online_courses.free_course' && $arr['searchvalue'] =='paid'){
                  
                    $this->db->where("online_courses.free_course",0);                    
                }else{
                    $this->db->where($arr['searchfield'], $arr['searchvalue']);
                }
                
            }elseif($arr['searchfield'] == 'sales') {
                $this->db->where("online_courses.free_course",0);          
            }elseif($arr['searchfield'] == 'category') {
                $this->db->where($arr['searchfield'], $arr['searchvalue']); 
            }
        }
 
        $role           = $this->role;
        if($role =='guest' or $role ==''){
            $this->db->where("online_courses.front_side_visibility",'yes');
        }
        $data  = array();
        $query = $this->db->select('online_courses.*,course_category.category_name')
            ->join('course_category', 'course_category.id = online_courses.category_id','left')
            ->where("online_courses.status",1)            
            ->get("online_courses");            
        $result = $query->result_array();
        if (!empty($result)) {
            foreach ($result as $key => $value) {
                $discount = 0;
                if (!empty($value['discount'])) {
                    $discount = $value['price'] - (($value['price'] * $value['discount']) / 100);
                }
                if (($value["free_course"] == 'yes') && (empty($value["price"]))) {
                    $pricevalue = 0;
                } elseif (($value["free_course"] == 'yes') && (!empty($value["price"]))) {
                    $pricevalue = 0;
                } elseif (!empty($value["price"]) && (!empty($value["discount"]))) {
                    $pricevalue = $discount;
                } else {
                    $pricevalue = $value['price'];
                }
                $result[$key]['present_price'] = $pricevalue;
              
                $courseSale                    = $this->getCourseSale($value["id"]);
                $result[$key]["sale"]          = $courseSale;
                $result[$key]["rating"]        = $this->ratingValue($value);
                if ((!empty($arr)) && ($arr['searchfield'] == 'rating')) {
                    
                    if ($arr['searchvalue'] == $result[$key]["rating"]) {
                        $data[] = $result[$key];
                    } else if ($arr['searchvalue'] == 0) {
                        $data[] = $result[$key];
                    }                   
                } else if ((!empty($arr)) && ($arr['searchfield'] == 'sales')) {
                    if ($arr['searchvalue'] == 'low') {
                        if (($result[$key]["sale"] > 0) && ($result[$key]["sale"] < 100)) {
                        
                            $data[] = $result[$key];
                        }
                    } else if ($arr['searchvalue'] == 'medium') {
                        if (($result[$key]["sale"] > 99) && ($result[$key]["sale"] < 500)) {
                       
                            $data[] = $result[$key];
                        }
                    } else if ($arr['searchvalue'] == 'high') {
                        if (($result[$key]["sale"] > 499)) {
                        
                            $data[] = $result[$key];
                        }
                    } else if ($arr['searchvalue'] == '0') {
                        if (($result[$key]["sale"] == 0)) {
                            $data[] = $result[$key];
                        }
                    }  
                } else {
                    $data[] = $result[$key];
                }
            }
            if ((!empty($arr)) && ($arr['searchfield'] == 'sales') && ($arr['searchvalue'] == 'top')) {
                if (count(array_column($data, 'sale')) == count($data)) {
                    array_multisort(array_column($data, 'sale'), SORT_DESC, $data);
                }
            }
        }
        $data = array_map("unserialize", array_unique(array_map("serialize", $data)));
        return $data;
    }

    public function getFilterSale()
    {
        $role           = $this->role;
        $condition ="";
        if($role=='guest' or $role==''){
            $condition = " and online_courses.front_side_visibility='yes' " ;
        }

        $query       = $this->db->query("SELECT  DISTINCT(`online_courses`.`id`) as `id`, `online_courses`.`free_course` FROM `online_courses`  where `online_courses`.`status` = 1 and online_courses.free_course = 0 ".$condition." ");
        $result      = $query->result_array();
        $data        = array();
        $no_sale     = 0;
        $low_sale    = 0;
        $medium_sale = 0;
        $high_sale   = 0;
        $top_sale    = 0;
        foreach ($result as $key => $value) {
            $courseSale            = $this->getCourseSale($value["id"]);
            $result[$key]["count"] = $courseSale;
            if ($courseSale == 0) {
                $no_sale++;
            } elseif (($courseSale > 0) && ($courseSale < 100)) {                     
                $low_sale++;
            } elseif (($courseSale > 99) && ($courseSale < 500)) {           
                $medium_sale++;
            } elseif (($courseSale > 499)) {            
                $high_sale++;
            }
        }
        $data['no_sale']     = $no_sale;
        $data['low_sale']    = $low_sale;
        $data['medium_sale'] = $medium_sale;
        $data['high_sale']   = $high_sale;
        return $data;
    }

    public function getFilterPrice()
    {
        $condition="" ;
        $role           = $this->role;
        if($role=='guest' or $role==''){
            $condition = " and online_courses.front_side_visibility='yes' " ;
        }

        $query  = $this->db->query("SELECT  DISTINCT(`online_courses`.`id`) as `id`, `online_courses`.`free_course` FROM `online_courses`  where `online_courses`.`status` = 1 ".$condition." ");
        $result = $query->result_array();
        $x      = 0;
        $y      = 0;
        foreach ($result as $key => $value) {
            if ($value['free_course'] == 1) {
                $x++;
            } else {
                $y++;
            }
        }
        $result[0]["countfree"] = $x;
        $result[0]["countpaid"] = $y;
        return $result[0];
    }

    public function filterRecordsByPrice($startrange, $endrange)
    {
        $role           = $this->role;
        if($role=='guest' || $role=='' ){
            $this->db->where("online_courses.front_side_visibility",'yes');
        }

        $query = $this->db->select('online_courses.*,course_category.category_name')  
            ->join('course_category', 'course_category.id = online_courses.category_id','left')
            ->where("online_courses.price between  " . $this->db->escape($startrange) . " and " . $this->db->escape($endrange))            
            ->where("online_courses.status", 1)
            ->where("online_courses.free_course", 0)            
            ->get("online_courses");
        $result = $query->result_array();
        if (!empty($result)) {
            foreach ($result as $key => $value) {
                $discount = 0;
                if (!empty($value['discount'])) {
                    $discount = $value['price'] - (($value['price'] * $value['discount']) / 100);
                }
                if (($value["free_course"] == 'yes') && (empty($value["price"]))) {
                    $pricevalue = 0;
                } elseif (($value["free_course"] == 'yes') && (!empty($value["price"]))) {
                    $pricevalue = 0;
                } elseif (!empty($value["price"]) && (!empty($value["discount"]))) {
                    $pricevalue = $discount;
                } else {
                    $pricevalue = $value['price'];
                }
                $result[$key]['present_price'] = $pricevalue;
                $lesson_count                  = $this->course_model->countlesson($value["id"]);
                $result[$key]["lesson_count"]  = $lesson_count;
                $hours_count                   = $this->course_model->counthours($value["id"]);
                $result[$key]["hours_count"]   = $hours_count;
                $courseSale                    = $this->getCourseSale($value["id"]);
                $result[$key]["course_sale"]   = $courseSale;
                $courseRatingv                 = $this->getCourseRating($value["id"]);
                if (!empty($courseRatingv)) {
                    foreach ($courseRatingv as $nkey => $rvalue) {
                        $result[$key]["rating"] = $courseRatingv[$nkey]['rating'];
                    }
                } else {
                    $result[$key]["rating"] = 0;
                }
                $result[$key]["ratingValue"] = $this->ratingValue($value);
            }
        }
        return $result;
    }

    public function getsection($id)
    {
        $this->db->select('online_course_section.*')
            ->join('online_courses', 'online_courses.id = online_course_section.online_course_id')
            ->where("online_courses.id", $id);
        $query  = $this->db->get('online_course_section');
        $result = $query->result_array();
        foreach ($result as $key => $value) {
            $lesson = $this->db->select('count(*) as lesson_count')
                ->where('course_section_id', $value['id'])
                ->get('online_course_lesson');
            $lesson_count                 = $lesson->row_array()['lesson_count'];
            $result[$key]['lesson_count'] = $lesson_count;
        }
        return $result;
    }

    public function getsectionlesson($id)
    {
        $this->db->select('online_course_lesson.*,online_course_section.section_title')
            ->join('online_course_section', 'online_course_section.id = online_course_lesson.course_section_id')
            ->join('online_courses', 'online_courses.id = online_course_section.online_course_id')
            ->where("online_courses.id", $id);
        $query = $this->db->get('online_course_lesson');
        return $query->result_array();
    }

    public function getLesson($lesson_id)
    {
        $query = $this->db->select("online_course_lesson.*,online_course_section.online_course_id")
            ->join("online_course_section", "online_course_section.id = online_course_lesson.course_section_id")
            ->where("online_course_lesson.id", $lesson_id)
            ->get("online_course_lesson");
        return $query->row_array();
    }

    public function getIdBySlug($slug)
    {
        $query  = $this->db->select("online_courses.id")->where("slug", $slug)->get("online_courses");
        $result = $query->row_array();
        return $result["id"];
    }

    public function searchcourse($search_text)
    {
        $role           = $this->role;
        if($role=='guest' || $role=='' ){
            $this->db->where("online_courses.front_side_visibility",'yes');
        }

        $query = $this->db->select('online_courses.*,course_category.category_name')
            ->join('course_category','course_category.id = online_courses.category_id','left')              
            ->like("online_courses.title", $search_text)
            ->where("online_courses.status", 1) 
            ->order_by("online_courses.id",'desc')            
            ->get("online_courses");
            
        $result = $query->result_array();       
        return $result;
    }
    
    public function getguestlist() 
    {       
        $this->datatables
            ->select('guest.*')            
            ->searchable('guest.guest_name,guest.guest_unique_id,guest.email,guest.mobileno,guest.dob,guest.gender,guest.address')
              ->orderable('guest.guest_image,guest.guest_name,guest.guest_unique_id,guest.email,guest.mobileno,guest.dob,guest.gender,guest.address')            
            ->from('guest');
        return $this->datatables->generate('json');        
    } 
    
    /*
     This function is used to get s3 bucket settings
    */
    public function getOnlineCourseSettings()
    {
        $this->db->select('*');
        $this->db->from('online_course_settings');
        $this->db->order_by('online_course_settings.id');
        $query = $this->db->get();
        return $query->row();
    }
    
    /*
     This function is used to add and update Guest user prefix and id settings
    */
    public function addCourseSettings($data)
    {
        $this->db->trans_begin();
        $q = $this->db->get('online_course_settings');
        if ($q->num_rows() > 0) {
            $results = $q->row();
            $this->db->where('id', $results->id);
            $this->db->update('online_course_settings', $data);
        } else {
            $this->db->insert('online_course_settings', $data);
        }
        if ($this->db->trans_status() === false) {
            $this->db->trans_rollback();
        } else {
            $this->db->trans_commit();
        }
    }
    
    public function check_guest_exists($guest_unique_id)
    {
        $this->db->where(array('guest_unique_id' => $guest_unique_id));
        $query = $this->db->get('guest');
        if ($query->num_rows() > 0) {
            return true;
        } else {
            return false;
        }
    }

    public function add_course_assignment($data)
    {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
        if (isset($data["id"]) && $data["id"] > 0) {
            $this->db->where("id", $data["id"])->update("online_course_assignment", $data);
            $message   = UPDATE_RECORD_CONSTANT . " On online_course_assignment id " . $data['id'];
            $action    = "Update";
            $record_id = $insert_id = $data['id'];
            $this->log($message, $record_id, $action);
        } else {
            $this->db->insert("online_course_assignment", $data);
            $insert_id = $this->db->insert_id();
            $message   = INSERT_RECORD_CONSTANT . " On online_course_assignment id " . $insert_id;
            $action    = "Insert";
            $record_id = $insert_id;
            $this->log($message, $record_id, $action);
        }
        //======================Code End==============================
        $this->db->trans_complete(); # Completing transaction
        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            return $insert_id;
        } 
    }

  public function save_online_course_setting($data) {
        $this->db->trans_start(); # Starting Transaction
        $this->db->trans_strict(false); # See Note 01. If you wish can remove as well
        //=======================Code Start===========================
         $q = $this->db->get('online_course_settings');
        if ($q->num_rows() > 0) {
            $results = $q->row();
            $this->db->where('id', $results->id);
            $this->db->update('online_course_settings', $data);
            $message = UPDATE_RECORD_CONSTANT . " On online_course_settings id " . $results->id;
            $action = "Update";
            $record_id = $insert_id = $results->id;
            $this->log($message, $record_id, $action);
        } else {
            $this->db->insert('online_course_settings', $data);
            $insert_id = $this->db->insert_id();
            $message = INSERT_RECORD_CONSTANT . " On online_course_settings id " . $insert_id;
            $action = "Insert";
            $record_id = $insert_id;
            $this->log($message, $record_id, $action);             
        }
        //======================Code End==============================
        $this->db->trans_complete(); # Completing transaction
        if ($this->db->trans_status() === false) {
            # Something went wrong.
            $this->db->trans_rollback();
            return false;
        } else {
            return $insert_id;
        }
    }
  
}