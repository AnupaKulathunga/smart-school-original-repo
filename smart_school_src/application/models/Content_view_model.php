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
     * for the given content_id and student_session_id combination.
     * @param int $content_id - share_content_id or upload_content_id
     * @param int $student_session_id
     * @return bool
     */
    public function trackView($content_id, $student_session_id)
    {
        if (empty($content_id) || empty($student_session_id)) {
            return false;
        }

        $existing = $this->isViewed($content_id, $student_session_id);
        if ($existing) {
            // Update view count and last viewed timestamp
            $this->db->where('content_id', $content_id);
            $this->db->where('student_id', $student_session_id);
            $this->db->set('view_count', 'view_count + 1', FALSE);
            $this->db->set('last_viewed_at', date('Y-m-d H:i:s'));
            $this->db->update('content_views');
            return true;
        }

        $data = array(
            'content_id'     => $content_id,
            'student_id'     => $student_session_id,
            'view_count'     => 1,
            'last_viewed_at' => date('Y-m-d H:i:s'),
        );

        $this->db->insert('content_views', $data);
        return ($this->db->affected_rows() > 0);
    }

    /**
     * Get an array of content_ids that a student has viewed.
     * @param int $student_session_id
     * @return array
     */
    public function getViewedContentIds($student_session_id)
    {
        if (empty($student_session_id)) {
            return array();
        }

        $this->db->select('content_id')->from('content_views');
        $this->db->where('student_id', $student_session_id);
        $query = $this->db->get();
        if ($query === false) {
            return array();
        }
        $result = $query->result_array();

        $ids = array();
        if (!empty($result)) {
            foreach ($result as $row) {
                $ids[] = $row['content_id'];
            }
        }
        return $ids;
    }

    /**
     * Check if a student has viewed a specific content item.
     * @param int $content_id
     * @param int $student_session_id
     * @return bool
     */
    public function isViewed($content_id, $student_session_id)
    {
        if (empty($content_id) || empty($student_session_id)) {
            return false;
        }

        $this->db->select('id')->from('content_views');
        $this->db->where('content_id', $content_id);
        $this->db->where('student_id', $student_session_id);
        $query = $this->db->get();
        if ($query === false) {
            return false;
        }
        if ($query->num_rows() > 0) {
            return true;
        }
        return false;
    }

}
