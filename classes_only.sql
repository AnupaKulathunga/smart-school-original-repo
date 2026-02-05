-- 3. CREATE CLASSES

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MATH-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MATH' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'DTT-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'DTT' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LSYS-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LSYS' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ENGD-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ENGD' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ENGS-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ENGS' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDL-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDL' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ETT-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ETT' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'FMT-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'FMT' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ITT-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ITT' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BDR-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BDR' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ENGS-N3-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ENGS' AND l.code = 'N3'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MATH-N3-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MATH' AND l.code = 'N3'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ENGD-N3-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ENGD' AND l.code = 'N3'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'QUAS-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'QUAS' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BUAD-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BUAD' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BSCO-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BSCO' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SUMAN-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SUMAN' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BSS-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BSS' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MATH-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MATH' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INACC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INACC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MCOM-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MCOM' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'EBMAN-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'EBMAN' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CPRAC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CPRAC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDEL-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDEL' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ETNIC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ETNIC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LSYS-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LSYS' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ININS-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ININS' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CFINS-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CFINS' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'FACC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'FACC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PMAN-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PMAN' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'OPRAC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'OPRAC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INFPR-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INFPR' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MKMAN-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MKMAN' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ENGSC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ENGSC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MD-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MD' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MTNIC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MTNIC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PADM-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PADM' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SUMAN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SUMAN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BSCO-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BSCO' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BUAD-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BUAD' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'QUAS-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'QUAS' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CMACC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CMACC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'EBMAN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'EBMAN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SMAN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SMAN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CPRAC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CPRAC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PREL-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PREL' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MATH-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MATH' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDEL-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDEL' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ETNIC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ETNIC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LSYS-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LSYS' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CELE-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CELE' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDIN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDIN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'FACC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'FACC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CFINS-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CFINS' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PTRA-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PTRA' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PMAN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PMAN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LREL-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LREL' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INFPR-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INFPR' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'OPRAC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'OPRAC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'COM-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'COM' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MKMAN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MKMAN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MTNIC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MTNIC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SOM-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SOM' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PM-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PM' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'FMEC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'FMEC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PADM-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PADM' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PFI-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PFI' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MADM-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MADM' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'TOP-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'TOP' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BUAD-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BUAD' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'QUAS-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'QUAS' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BSS-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BSS' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BSCO-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BSCO' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LREL-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LREL' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'EBMAN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'EBMAN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SMAN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SMAN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CMACC-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CMACC' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PREL-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PREL' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LSYS-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LSYS' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MATH-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MATH' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ETNIC-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ETNIC' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDEL-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDEL' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SUMAN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SUMAN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDIN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDIN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CELE-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CELE' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ITAX-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ITAX' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'FACC-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'FACC' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CFINS-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CFINS' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PMAN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PMAN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PTRA-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PTRA' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INFPR-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INFPR' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'OPRAC-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'OPRAC' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MKRE-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MKRE' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MKMAN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MKMAN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MACOM-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MACOM' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SOM-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SOM' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PM-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PM' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MTNIC-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MTNIC' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PLAW-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PLAW' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PADM-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PADM' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MADM-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MADM' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PFI-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PFI' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.subject_level_id = sl.id
    AND c2.cohort_name = 'A'
    AND c2.academic_year = 2026
    AND c2.session_id = 27
);

-- VERIFICATION
SELECT 'Subjects created:' as result, COUNT(*) as count FROM subjects WHERE is_active=1;
SELECT 'Subject-levels created:' as result, COUNT(*) as count FROM subject_level WHERE is_active=1;
SELECT 'Classes created:' as result, COUNT(*) as count FROM class WHERE academic_year=2026 AND is_active=1;