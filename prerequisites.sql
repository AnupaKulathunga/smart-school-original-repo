-- TVET Import Prerequisites
-- Generated from CSV analysis

-- 1. CREATE SUBJECTS (with duplicate handling)
INSERT IGNORE INTO subjects (code, name, credits, notional_hours, is_active, created_at) VALUES
('BDR', 'BDR', 4, 120, 1, NOW()),
('BSCO', 'BSCO', 4, 120, 1, NOW()),
('BSS', 'BSS', 4, 120, 1, NOW()),
('BUAD', 'BUAD', 4, 120, 1, NOW()),
('CELE', 'CELE', 4, 120, 1, NOW()),
('CFINS', 'CFINS', 4, 120, 1, NOW()),
('CMACC', 'CMACC', 4, 120, 1, NOW()),
('COM', 'COM', 4, 120, 1, NOW()),
('CPRAC', 'CPRAC', 4, 120, 1, NOW()),
('DTT', 'DTT', 4, 120, 1, NOW()),
('EBMAN', 'EBMAN', 4, 120, 1, NOW()),
('ENGD', 'ENGD', 4, 120, 1, NOW()),
('ENGS', 'ENGS', 4, 120, 1, NOW()),
('ENGSC', 'ENGSC', 4, 120, 1, NOW()),
('ETNIC', 'ETNIC', 4, 120, 1, NOW()),
('ETT', 'ETT', 4, 120, 1, NOW()),
('FACC', 'FACC', 4, 120, 1, NOW()),
('FMEC', 'FMEC', 4, 120, 1, NOW()),
('FMT', 'FMT', 4, 120, 1, NOW()),
('INACC', 'INACC', 4, 120, 1, NOW()),
('INDEL', 'INDEL', 4, 120, 1, NOW()),
('INDIN', 'INDIN', 4, 120, 1, NOW()),
('INDL', 'INDL', 4, 120, 1, NOW()),
('INFPR', 'INFPR', 4, 120, 1, NOW()),
('ININS', 'ININS', 4, 120, 1, NOW()),
('ITAX', 'ITAX', 4, 120, 1, NOW()),
('ITT', 'ITT', 4, 120, 1, NOW()),
('LREL', 'LREL', 4, 120, 1, NOW()),
('LSYS', 'LSYS', 4, 120, 1, NOW()),
('MACOM', 'MACOM', 4, 120, 1, NOW()),
('MADM', 'MADM', 4, 120, 1, NOW()),
('MATH', 'MATH', 4, 120, 1, NOW()),
('MCOM', 'MCOM', 4, 120, 1, NOW()),
('MD', 'MD', 4, 120, 1, NOW()),
('MKMAN', 'MKMAN', 4, 120, 1, NOW()),
('MKRE', 'MKRE', 4, 120, 1, NOW()),
('MTNIC', 'MTNIC', 4, 120, 1, NOW()),
('OPRAC', 'OPRAC', 4, 120, 1, NOW()),
('PADM', 'PADM', 4, 120, 1, NOW()),
('PFI', 'PFI', 4, 120, 1, NOW()),
('PLAW', 'PLAW', 4, 120, 1, NOW()),
('PM', 'PM', 4, 120, 1, NOW()),
('PMAN', 'PMAN', 4, 120, 1, NOW()),
('PREL', 'PREL', 4, 120, 1, NOW()),
('PTRA', 'PTRA', 4, 120, 1, NOW()),
('QUAS', 'QUAS', 4, 120, 1, NOW()),
('SMAN', 'SMAN', 4, 120, 1, NOW()),
('SOM', 'SOM', 4, 120, 1, NOW()),
('SUMAN', 'SUMAN', 4, 120, 1, NOW()),
('TOP', 'TOP', 4, 120, 1, NOW());

-- 2. CREATE SUBJECT-LEVEL COMBINATIONS
-- First, get subject and level IDs

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MATH' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'DTT' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'LSYS' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ENGD' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ENGS' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'INDL' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ETT' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'FMT' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ITT' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'BDR' AND l.code = 'N2'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ENGS' AND l.code = 'N3'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MATH' AND l.code = 'N3'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ENGD' AND l.code = 'N3'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'QUAS' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'BUAD' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'BSCO' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'SUMAN' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'BSS' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MATH' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'INACC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MCOM' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'EBMAN' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'CPRAC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'INDEL' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ETNIC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'LSYS' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ININS' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'CFINS' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'FACC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PMAN' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'OPRAC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'INFPR' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MKMAN' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ENGSC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MD' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MTNIC' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PADM' AND l.code = 'N4'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'SUMAN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'BSCO' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'BUAD' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'QUAS' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'CMACC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'EBMAN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'SMAN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'CPRAC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PREL' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MATH' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'INDEL' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ETNIC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'LSYS' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'CELE' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'INDIN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'FACC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'CFINS' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PTRA' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PMAN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'LREL' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'INFPR' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'OPRAC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'COM' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MKMAN' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MTNIC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'SOM' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PM' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'FMEC' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PADM' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PFI' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MADM' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'TOP' AND l.code = 'N5'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'BUAD' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'QUAS' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'BSS' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'BSCO' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'LREL' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'EBMAN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'SMAN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'CMACC' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PREL' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'LSYS' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MATH' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ETNIC' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'INDEL' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'SUMAN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'INDIN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'CELE' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'ITAX' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'FACC' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'CFINS' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PMAN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PTRA' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'INFPR' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'OPRAC' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MKRE' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MKMAN' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MACOM' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'SOM' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PM' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MTNIC' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PLAW' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PADM' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'MADM' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = 'PFI' AND l.code = 'N6'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);

-- 3. CREATE CLASSES

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MATH-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MATH' AND l.code = 'N2'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MATH-N2-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'DTT-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'DTT' AND l.code = 'N2'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'DTT-N2-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LSYS-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LSYS' AND l.code = 'N2'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'LSYS-N2-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ENGD-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ENGD' AND l.code = 'N2'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ENGD-N2-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ENGS-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ENGS' AND l.code = 'N2'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ENGS-N2-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDL-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDL' AND l.code = 'N2'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'INDL-N2-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ETT-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ETT' AND l.code = 'N2'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ETT-N2-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'FMT-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'FMT' AND l.code = 'N2'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'FMT-N2-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ITT-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ITT' AND l.code = 'N2'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ITT-N2-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BDR-N2-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BDR' AND l.code = 'N2'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'BDR-N2-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ENGS-N3-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ENGS' AND l.code = 'N3'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ENGS-N3-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MATH-N3-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MATH' AND l.code = 'N3'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MATH-N3-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ENGD-N3-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ENGD' AND l.code = 'N3'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ENGD-N3-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'QUAS-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'QUAS' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'QUAS-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BUAD-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BUAD' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'BUAD-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BSCO-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BSCO' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'BSCO-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SUMAN-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SUMAN' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'SUMAN-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BSS-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BSS' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'BSS-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MATH-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MATH' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MATH-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INACC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INACC' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'INACC-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MCOM-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MCOM' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MCOM-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'EBMAN-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'EBMAN' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'EBMAN-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CPRAC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CPRAC' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'CPRAC-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDEL-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDEL' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'INDEL-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ETNIC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ETNIC' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ETNIC-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LSYS-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LSYS' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'LSYS-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ININS-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ININS' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ININS-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CFINS-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CFINS' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'CFINS-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'FACC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'FACC' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'FACC-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PMAN-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PMAN' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PMAN-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'OPRAC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'OPRAC' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'OPRAC-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INFPR-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INFPR' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'INFPR-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MKMAN-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MKMAN' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MKMAN-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ENGSC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ENGSC' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ENGSC-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MD-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MD' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MD-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MTNIC-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MTNIC' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MTNIC-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PADM-N4-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PADM' AND l.code = 'N4'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PADM-N4-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SUMAN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SUMAN' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'SUMAN-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BSCO-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BSCO' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'BSCO-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BUAD-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BUAD' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'BUAD-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'QUAS-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'QUAS' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'QUAS-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CMACC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CMACC' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'CMACC-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'EBMAN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'EBMAN' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'EBMAN-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SMAN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SMAN' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'SMAN-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CPRAC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CPRAC' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'CPRAC-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PREL-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PREL' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PREL-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MATH-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MATH' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MATH-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDEL-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDEL' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'INDEL-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ETNIC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ETNIC' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ETNIC-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LSYS-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LSYS' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'LSYS-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CELE-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CELE' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'CELE-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDIN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDIN' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'INDIN-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'FACC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'FACC' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'FACC-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CFINS-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CFINS' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'CFINS-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PTRA-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PTRA' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PTRA-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PMAN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PMAN' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PMAN-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LREL-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LREL' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'LREL-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INFPR-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INFPR' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'INFPR-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'OPRAC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'OPRAC' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'OPRAC-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'COM-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'COM' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'COM-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MKMAN-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MKMAN' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MKMAN-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MTNIC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MTNIC' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MTNIC-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SOM-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SOM' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'SOM-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PM-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PM' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PM-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'FMEC-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'FMEC' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'FMEC-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PADM-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PADM' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PADM-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PFI-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PFI' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PFI-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MADM-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MADM' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MADM-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'TOP-N5-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'TOP' AND l.code = 'N5'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'TOP-N5-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BUAD-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BUAD' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'BUAD-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'QUAS-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'QUAS' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'QUAS-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BSS-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BSS' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'BSS-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'BSCO-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'BSCO' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'BSCO-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LREL-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LREL' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'LREL-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'EBMAN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'EBMAN' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'EBMAN-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SMAN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SMAN' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'SMAN-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CMACC-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CMACC' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'CMACC-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PREL-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PREL' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PREL-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'LSYS-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'LSYS' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'LSYS-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MATH-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MATH' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MATH-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ETNIC-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ETNIC' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ETNIC-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDEL-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDEL' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'INDEL-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SUMAN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SUMAN' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'SUMAN-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INDIN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INDIN' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'INDIN-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CELE-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CELE' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'CELE-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'ITAX-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'ITAX' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'ITAX-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'FACC-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'FACC' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'FACC-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'CFINS-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'CFINS' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'CFINS-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PMAN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PMAN' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PMAN-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PTRA-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PTRA' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PTRA-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'INFPR-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'INFPR' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'INFPR-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'OPRAC-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'OPRAC' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'OPRAC-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MKRE-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MKRE' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MKRE-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MKMAN-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MKMAN' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MKMAN-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MACOM-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MACOM' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MACOM-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'SOM-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'SOM' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'SOM-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PM-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PM' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PM-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MTNIC-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MTNIC' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MTNIC-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PLAW-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PLAW' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PLAW-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PADM-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PADM' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PADM-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'MADM-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'MADM' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'MADM-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT 'PFI-N6-A-2026', sl.id, 'A', 2026, 27, 'Full-Time', 'Active', 1, 100, '2026-01-01', '2026-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = 'PFI' AND l.code = 'N6'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = 'PFI-N6-A-2026'
    AND c2.session_id = 27
)
LIMIT 1;

-- VERIFICATION
SELECT 'Subjects created:' as result, COUNT(*) as count FROM subjects WHERE is_active=1;
SELECT 'Subject-levels created:' as result, COUNT(*) as count FROM subject_level WHERE is_active=1;
SELECT 'Classes created:' as result, COUNT(*) as count FROM class WHERE academic_year=2026 AND is_active=1;