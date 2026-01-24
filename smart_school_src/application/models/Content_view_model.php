<?php

if (!defined('BASEPATH')) {
    exit('No direct script access allowed');
}

class Content_view_model extends MY_Model
{

    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Track when a student views/downloads content.
     * Inserts a record into content_views if one doesn't already exist
     * for the given upload_content_id and student_session_id combination.
     * @param int $upload_content_id
     * @param int $student_session_id
     * @return bool
     */
    public function trackView($upload_content_id, $student_session_id)
    {
        $existing = $this->isViewed($upload_content_id, $student_session_id);
        if ($existing) {
            return true;
        }

        $data = array(
            'upload_content_id'  => $upload_content_id,
            'student_session_id' => $student_session_id,
            'viewed_at'          => date('Y-m-d H:i:s'),
        );

        $this->db->insert('content_views', $data);
        return ($this->db->affected_rows() > 0);
    }

    /**
     * Get an array of upload_content_ids that a student has viewed.
     * @param int $student_session_id
     * @return array
     */
    public function getViewedContentIds($student_session_id)
    {
        $this->db->select('upload_content_id')->from('content_views');
        $this->db->where('student_session_id', $student_session_id);
        $query = $this->db->get();
        $result = $query->result_array();

        $ids = array();
        if (!empty($result)) {
            foreach ($result as $row) {
                $ids[] = $row['upload_content_id'];
            }
        }
        return $ids;
    }

    /**
     * Check if a student has viewed a specific content item.
     * @param int $upload_content_id
     * @param int $student_session_id
     * @return bool
     */
    public function isViewed($upload_content_id, $student_session_id)
    {
        $this->db->select('id')->from('content_views');
        $this->db->where('upload_content_id', $upload_content_id);
        $this->db->where('student_session_id', $student_session_id);
        $query = $this->db->get();
        if ($query->num_rows() > 0) {
            return true;
        }
        return false;
    }

}
