-- ============================================================
-- Add Test Questions to "test1" Exam
-- Run this in phpMyAdmin (http://localhost:8081)
-- ============================================================

-- First, get the session_id for the current session
SET @session_id = (SELECT id FROM sessions WHERE is_active='yes' LIMIT 1);

-- Get the exam ID for "test1" exam (or the latest exam)
SET @exam_id = (SELECT id FROM onlineexam WHERE exam = 'test1' LIMIT 1);

-- If no exam named test1, use the latest one
SET @exam_id = COALESCE(@exam_id, (SELECT id FROM onlineexam ORDER BY id DESC LIMIT 1));

-- ============================================================
-- Insert Sample Questions into Question Bank
-- ============================================================

-- MCQ Question 1
INSERT INTO `questions` (`staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`)
VALUES (1, 1, 'singlechoice', 'low', 1, 1,
    'What is the primary function of management?',
    'Planning and organizing resources',
    'Selling products to customers',
    'Manufacturing goods',
    'Accounting for finances',
    '',
    'opt_a', 0);
SET @q1 = LAST_INSERT_ID();

-- MCQ Question 2
INSERT INTO `questions` (`staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`)
VALUES (1, 1, 'singlechoice', 'medium', 1, 1,
    'Which of the following is NOT a management function?',
    'Planning',
    'Organizing',
    'Coding',
    'Controlling',
    '',
    'opt_c', 0);
SET @q2 = LAST_INSERT_ID();

-- MCQ Question 3
INSERT INTO `questions` (`staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`)
VALUES (1, 1, 'singlechoice', 'medium', 1, 1,
    'A SWOT analysis examines:',
    'Sales, Workers, Output, Training',
    'Strengths, Weaknesses, Opportunities, Threats',
    'Staff, Wages, Operations, Technology',
    'Systems, Workflows, Objectives, Tasks',
    '',
    'opt_b', 0);
SET @q3 = LAST_INSERT_ID();

-- MCQ Question 4
INSERT INTO `questions` (`staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`)
VALUES (1, 1, 'singlechoice', 'high', 1, 1,
    'What type of organizational structure has employees reporting to multiple managers?',
    'Functional structure',
    'Divisional structure',
    'Matrix structure',
    'Flat structure',
    '',
    'opt_c', 0);
SET @q4 = LAST_INSERT_ID();

-- MCQ Question 5
INSERT INTO `questions` (`staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`)
VALUES (1, 1, 'singlechoice', 'low', 1, 1,
    'Leadership is best defined as:',
    'Forcing employees to work harder',
    'Influencing others to achieve organizational goals',
    'Monitoring employee attendance',
    'Calculating company profits',
    '',
    'opt_b', 0);
SET @q5 = LAST_INSERT_ID();

-- Multiple Choice Question 6
INSERT INTO `questions` (`staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`)
VALUES (1, 1, 'multichoice', 'medium', 1, 1,
    'Select ALL that are considered external factors in a PESTLE analysis:',
    'Political factors',
    'Employee motivation',
    'Economic conditions',
    'Technological changes',
    'Internal policies',
    'opt_a,opt_c,opt_d', 0);
SET @q6 = LAST_INSERT_ID();

-- True/False Question 7
INSERT INTO `questions` (`staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`)
VALUES (1, 1, 'true_false', 'low', 1, 1,
    'Delegation means assigning tasks to subordinates while retaining overall responsibility.',
    'True',
    'False',
    '',
    '',
    '',
    'opt_a', 0);
SET @q7 = LAST_INSERT_ID();

-- True/False Question 8
INSERT INTO `questions` (`staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`)
VALUES (1, 1, 'true_false', 'low', 1, 1,
    'Managers at all levels require the same balance of technical and conceptual skills.',
    'True',
    'False',
    '',
    '',
    '',
    'opt_b', 0);
SET @q8 = LAST_INSERT_ID();

-- True/False Question 9
INSERT INTO `questions` (`staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`)
VALUES (1, 1, 'true_false', 'medium', 1, 1,
    'A mission statement describes what the organization wants to become in the future.',
    'True',
    'False',
    '',
    '',
    '',
    'opt_b', 0);
SET @q9 = LAST_INSERT_ID();

-- MCQ Question 10
INSERT INTO `questions` (`staff_id`, `subject_id`, `question_type`, `level`, `class_id`, `section_id`,
    `question`, `opt_a`, `opt_b`, `opt_c`, `opt_d`, `opt_e`, `correct`, `descriptive_word_limit`)
VALUES (1, 1, 'singlechoice', 'medium', 1, 1,
    'Which management theorist is associated with "Scientific Management"?',
    'Henri Fayol',
    'Frederick Taylor',
    'Max Weber',
    'Elton Mayo',
    '',
    'opt_b', 0);
SET @q10 = LAST_INSERT_ID();

-- ============================================================
-- Link Questions to the Exam
-- ============================================================

INSERT INTO `onlineexam_questions` (`question_id`, `onlineexam_id`, `session_id`, `marks`, `neg_marks`, `is_active`)
VALUES
    (@q1, @exam_id, @session_id, 10.00, 0.00, '1'),
    (@q2, @exam_id, @session_id, 10.00, 0.00, '1'),
    (@q3, @exam_id, @session_id, 10.00, 0.00, '1'),
    (@q4, @exam_id, @session_id, 15.00, 0.00, '1'),
    (@q5, @exam_id, @session_id, 10.00, 0.00, '1'),
    (@q6, @exam_id, @session_id, 15.00, 0.00, '1'),
    (@q7, @exam_id, @session_id, 5.00, 0.00, '1'),
    (@q8, @exam_id, @session_id, 5.00, 0.00, '1'),
    (@q9, @exam_id, @session_id, 5.00, 0.00, '1'),
    (@q10, @exam_id, @session_id, 15.00, 0.00, '1');

-- ============================================================
-- Verify: Show what was added
-- ============================================================
SELECT CONCAT('Added 10 questions to exam ID: ', @exam_id) AS Result;
SELECT COUNT(*) AS total_questions FROM onlineexam_questions WHERE onlineexam_id = @exam_id;
