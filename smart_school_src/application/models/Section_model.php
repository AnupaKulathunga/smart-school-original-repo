<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

/**
 * Section_model - DEPRECATED in TVET mode
 *
 * In the TVET academic model, sections do not exist. Classes are replaced by
 * academic_classes which combine what was previously class + section into a single entity.
 *
 * This model is kept as a stub so that any legacy controller calls (e.g., Sections controller,
 * Classes controller, Customlib) do not cause fatal errors. All methods return safe empty
 * values or no-op results.
 *
 * Legacy tables no longer used: sections, class_sections
 * Replacement: academic_classes table (managed via Academic_class_model)
 */
class Section_model extends MY_Model {

    public function __construct() {
        parent::__construct();
    }

    /**
     * Get section(s) - STUB
     * Legacy: queried sections table
     * TVET: returns empty (no sections exist)
     *
     * @param int $id  Optional section ID
     * @return mixed  Empty array or null
     */
    public function get($id = null) {
        if ($id != null) {
            // Single section lookup - return null (not found)
            return null;
        }
        // List all sections - return empty array
        return array();
    }

    /**
     * Remove section - STUB (no-op)
     * Legacy: deleted from sections table
     * TVET: no-op, sections don't exist
     *
     * @param int $id
     * @return bool
     */
    public function remove($id) {
        // No-op in TVET mode - nothing to delete
        return true;
    }

    /**
     * Get sections for a class (all sections) - STUB
     * Legacy: joined class_sections + sections
     * TVET: returns empty array (no sections)
     *
     * @param int $classid
     * @return array  Empty array
     */
    public function getClassBySectionAll($classid) {
        return array();
    }

    /**
     * Get sections for a class (respecting teacher restrictions) - STUB
     * Legacy: joined class_sections + sections, with teacher role check
     * TVET: returns empty array (no sections)
     *
     * @param int $classid
     * @return array  Empty array
     */
    public function getClassBySection($classid) {
        return array();
    }

    /**
     * Get sections assigned to class teacher - STUB
     * Legacy: joined class_teacher + sections + class_sections
     * TVET: returns empty array (no sections)
     *
     * @param int $classid
     * @return array  Empty array
     */
    public function getClassTeacherSection($classid) {
        return array();
    }

    /**
     * Get sections assigned to subject teacher - STUB
     * Legacy: joined teacher_subjects + class_sections + sections
     * TVET: returns empty array (no sections)
     *
     * @param int $classid
     * @param int $id  Teacher ID
     * @return array  Empty array
     */
    public function getSubjectTeacherSection($classid, $id) {
        return array();
    }

    /**
     * Get class and section name by IDs - STUB
     * Legacy: joined class_sections + sections + classes
     * TVET: returns empty array
     *
     * @param int $classid
     * @param int $sectionid  DEPRECATED
     * @return array  Empty array
     */
    public function getClassNameBySection($classid, $sectionid = null) {
        return array();
    }

    /**
     * Get class and section name row by IDs - STUB
     * Legacy: joined class_sections + sections + classes, returned single row
     * TVET: returns null
     *
     * @param int $classid
     * @param int $sectionid  DEPRECATED
     * @return null
     */
    public function getClassAndSectionNameByClassIDSectionID($classid, $sectionid = null) {
        return null;
    }

    /**
     * Add/update section - STUB (no-op)
     * Legacy: inserted into or updated sections table
     * TVET: no-op, sections don't exist
     *
     * @param array $data
     * @return bool
     */
    public function add($data) {
        // No-op in TVET mode - sections are not used
        return true;
    }

}
