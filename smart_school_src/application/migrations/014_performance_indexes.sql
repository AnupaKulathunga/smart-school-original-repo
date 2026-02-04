-- Migration 014: Performance Indexes for TVET Tables
-- Adds indexes to improve query performance on frequently accessed columns
-- Date: 2026-02-04
-- Phase: 6 - Optimization

-- Note: Using ALTER TABLE ADD INDEX which will skip if index exists

-- Enrolment table indexes
ALTER TABLE enrolment ADD INDEX idx_enrolment_student_session (student_id, session_id);
ALTER TABLE enrolment ADD INDEX idx_enrolment_class_status (class_id, status);
ALTER TABLE enrolment ADD INDEX idx_enrolment_session_status (session_id, status);
ALTER TABLE enrolment ADD INDEX idx_enrolment_type (enrolment_type);

-- Class table indexes
ALTER TABLE class ADD INDEX idx_class_session_status (session_id, status);
ALTER TABLE class ADD INDEX idx_class_subject_level (subject_level_id);
ALTER TABLE class ADD INDEX idx_class_lecturer (primary_lecturer_id);
ALTER TABLE class ADD INDEX idx_class_active (is_active);

-- Subject Level indexes
ALTER TABLE subject_level ADD INDEX idx_subject_level_subject (subject_id);
ALTER TABLE subject_level ADD INDEX idx_subject_level_level (level_id);
ALTER TABLE subject_level ADD INDEX idx_subject_level_active (is_active);

-- Student Programme indexes
ALTER TABLE student_programme ADD INDEX idx_student_programme_student (student_id, session_id);
ALTER TABLE student_programme ADD INDEX idx_student_programme_programme (programme_id);
ALTER TABLE student_programme ADD INDEX idx_student_programme_status (status);

-- Level indexes
ALTER TABLE level ADD INDEX idx_level_sequence (sequence);
ALTER TABLE level ADD INDEX idx_level_type (level_type);

-- Programme indexes
ALTER TABLE programme ADD INDEX idx_programme_code (code);

-- Qualification indexes
ALTER TABLE qualification ADD INDEX idx_qualification_programme (programme_id);

-- Show completion message
SELECT 'Performance indexes created successfully!' as status;
