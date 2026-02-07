-- Migration 028: Comprehensive Fixes Round 2
-- Fixes:
-- 1. subject_timetable.session_id column
-- 2. online_admissions missing columns
-- 3. Add class_teacher table for TVET
-- 4. Ensure questions table compatibility

-- =====================================================
-- 1. Fix subject_timetable - add session_id column
-- =====================================================
ALTER TABLE subject_timetable
ADD COLUMN IF NOT EXISTS session_id int(11) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS class_id int(11) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS start_time time DEFAULT NULL,
ADD COLUMN IF NOT EXISTS end_time time DEFAULT NULL;

-- =====================================================
-- 2. Fix online_admissions - add missing columns
-- =====================================================
ALTER TABLE online_admissions
ADD COLUMN IF NOT EXISTS admission_no varchar(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS roll_no varchar(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS document text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS is_enroll int(11) DEFAULT 0,
ADD COLUMN IF NOT EXISTS height varchar(20) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS weight varchar(20) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS measurement_date date DEFAULT NULL,
ADD COLUMN IF NOT EXISTS paid_status int(11) DEFAULT 0,
ADD COLUMN IF NOT EXISTS submit_date datetime DEFAULT NULL,
ADD COLUMN IF NOT EXISTS updated_at timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP;

-- =====================================================
-- 3. Create class_teacher table for TVET
-- =====================================================
CREATE TABLE IF NOT EXISTS class_teacher (
    id int(11) NOT NULL AUTO_INCREMENT,
    class_id int(11) NOT NULL,
    section_id int(11) DEFAULT NULL,
    staff_id int(11) NOT NULL,
    session_id int(11) DEFAULT NULL,
    is_active int(11) DEFAULT 1,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_class_id (class_id),
    KEY idx_staff_id (staff_id),
    KEY idx_session_id (session_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- =====================================================
-- 4. Fix questions table
-- =====================================================
ALTER TABLE questions
ADD COLUMN IF NOT EXISTS class_id int(11) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS section_id int(11) DEFAULT NULL;

-- =====================================================
-- 5. Fix offline_fees_payments table
-- =====================================================
ALTER TABLE offline_fees_payments
ADD COLUMN IF NOT EXISTS student_session_id int(11) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS student_fees_master_id int(11) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS fee_groups_feetype_id int(11) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS student_transport_fee_id int(11) DEFAULT NULL;

-- =====================================================
-- 6. Ensure student_session table exists for backward compatibility
-- =====================================================
CREATE TABLE IF NOT EXISTS student_session (
    id int(11) NOT NULL AUTO_INCREMENT,
    session_id int(11) DEFAULT NULL,
    student_id int(11) NOT NULL,
    class_id int(11) DEFAULT NULL,
    section_id int(11) DEFAULT NULL,
    medium_id int(11) DEFAULT NULL,
    is_active int(11) DEFAULT 1,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_student_id (student_id),
    KEY idx_session_id (session_id),
    KEY idx_class_id (class_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Record migration
INSERT INTO migrations (migration, batch) VALUES ('028_comprehensive_fixes_round2', 28)
ON DUPLICATE KEY UPDATE migration = migration;

-- =====================================================
-- Additional fixes discovered during testing
-- =====================================================

-- Fix staff_rating table
ALTER TABLE staff_rating
ADD COLUMN IF NOT EXISTS rate decimal(3,1) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS status int(11) DEFAULT 0,
ADD COLUMN IF NOT EXISTS user_id int(11) DEFAULT NULL;

-- Fix subject_timetable for legacy compatibility
ALTER TABLE subject_timetable
ADD COLUMN IF NOT EXISTS session_id int(11) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS class_id int(11) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS section_id int(11) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS start_time time DEFAULT NULL,
ADD COLUMN IF NOT EXISTS end_time time DEFAULT NULL,
ADD COLUMN IF NOT EXISTS subject_group_subject_id int(11) DEFAULT NULL;

-- Fix online_admissions for all required columns
ALTER TABLE online_admissions
ADD COLUMN IF NOT EXISTS admission_no varchar(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS roll_no varchar(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS document text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS is_enroll int(11) DEFAULT 0,
ADD COLUMN IF NOT EXISTS height varchar(20) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS weight varchar(20) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS measurement_date date DEFAULT NULL,
ADD COLUMN IF NOT EXISTS paid_status int(11) DEFAULT 0,
ADD COLUMN IF NOT EXISTS submit_date datetime DEFAULT NULL,
ADD COLUMN IF NOT EXISTS updated_at timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS guardian_is varchar(50) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS father_pic varchar(255) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS mother_pic varchar(255) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS guardian_pic varchar(255) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS father_phone varchar(20) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS mother_phone varchar(20) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS cast varchar(50) DEFAULT NULL;

-- Create staff_leave_details table
CREATE TABLE IF NOT EXISTS staff_leave_details (
    id int(11) NOT NULL AUTO_INCREMENT,
    staff_id int(11) NOT NULL,
    leave_type_id int(11) DEFAULT NULL,
    leave_from date DEFAULT NULL,
    leave_to date DEFAULT NULL,
    leave_days decimal(5,1) DEFAULT 0,
    employee_remark text,
    admin_remark text,
    status int(11) DEFAULT 0,
    document varchar(255) DEFAULT NULL,
    applied_by varchar(50) DEFAULT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create share_contents table
CREATE TABLE IF NOT EXISTS share_contents (
    id int(11) NOT NULL AUTO_INCREMENT,
    content_id int(11) DEFAULT NULL,
    share_to varchar(100) DEFAULT NULL,
    share_date date DEFAULT NULL,
    shared_by int(11) DEFAULT NULL,
    description text,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create share_upload_contents table
CREATE TABLE IF NOT EXISTS share_upload_contents (
    id int(11) NOT NULL AUTO_INCREMENT,
    upload_content_id int(11) DEFAULT NULL,
    share_to varchar(100) DEFAULT NULL,
    share_date date DEFAULT NULL,
    description text,
    send_notification int(1) DEFAULT 0,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create topic table
CREATE TABLE IF NOT EXISTS topic (
    id int(11) NOT NULL AUTO_INCREMENT,
    subject_id int(11) DEFAULT NULL,
    class_id int(11) DEFAULT NULL,
    section_id int(11) DEFAULT NULL,
    lesson_id int(11) DEFAULT NULL,
    name varchar(200) NOT NULL,
    status int(11) DEFAULT 1,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create subject_group_subjects table
CREATE TABLE IF NOT EXISTS subject_group_subjects (
    id int(11) NOT NULL AUTO_INCREMENT,
    subject_group_id int(11) DEFAULT NULL,
    subject_id int(11) DEFAULT NULL,
    session_id int(11) DEFAULT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create subject_group_class_sections table
CREATE TABLE IF NOT EXISTS subject_group_class_sections (
    id int(11) NOT NULL AUTO_INCREMENT,
    subject_group_id int(11) DEFAULT NULL,
    class_id int(11) DEFAULT NULL,
    section_id int(11) DEFAULT NULL,
    session_id int(11) DEFAULT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create subject_syllabus table
CREATE TABLE IF NOT EXISTS subject_syllabus (
    id int(11) NOT NULL AUTO_INCREMENT,
    subject_group_subject_id int(11) DEFAULT NULL,
    subject_group_class_sections_id int(11) DEFAULT NULL,
    class_id int(11) DEFAULT NULL,
    section_id int(11) DEFAULT NULL,
    subject_id int(11) DEFAULT NULL,
    session_id int(11) DEFAULT NULL,
    status int(11) DEFAULT 0,
    completion_date date DEFAULT NULL,
    total_lectures int(11) DEFAULT 0,
    completed_lectures int(11) DEFAULT 0,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create class_teacher table for TVET
CREATE TABLE IF NOT EXISTS class_teacher (
    id int(11) NOT NULL AUTO_INCREMENT,
    class_id int(11) NOT NULL,
    section_id int(11) DEFAULT NULL,
    staff_id int(11) NOT NULL,
    session_id int(11) DEFAULT NULL,
    is_active int(11) DEFAULT 1,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

