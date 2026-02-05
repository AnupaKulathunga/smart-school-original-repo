#!/usr/bin/env python3
"""
Create prerequisites for TVET import from CSV
Generates SQL to create subjects, subject-levels, and classes
"""

import pandas as pd
import sys

def generate_prerequisites_sql(csv_file, session_id=27):
    """Generate SQL to create all prerequisites"""

    # Read CSV
    df = pd.read_csv(csv_file)

    # Get unique subjects, levels, and combinations
    subjects = df['subject_code'].dropna().unique()
    levels = df['level_code'].dropna().unique()

    # Get subject-level combinations
    subject_levels = df[['subject_code', 'level_code']].drop_duplicates()
    subject_levels = subject_levels.dropna()

    # Get classes (subject+level+cohort+year)
    classes = df[['subject_code', 'level_code', 'cohort_name', 'academic_year']].drop_duplicates()
    classes = classes.dropna()

    sql = []
    sql.append("-- TVET Import Prerequisites")
    sql.append("-- Generated from CSV analysis")
    sql.append("")

    # Create subjects
    sql.append("-- 1. CREATE SUBJECTS (with duplicate handling)")
    sql.append("INSERT IGNORE INTO subjects (code, name, credits, notional_hours, is_active, created_at) VALUES")
    subject_values = []
    for subj in sorted(subjects):
        subject_values.append(f"('{subj}', '{subj}', 4, 120, 1, NOW())")
    sql.append(",\n".join(subject_values) + ";")
    sql.append("")

    # Create subject-level combinations
    sql.append("-- 2. CREATE SUBJECT-LEVEL COMBINATIONS")
    sql.append("-- First, get subject and level IDs")
    for idx, row in subject_levels.iterrows():
        subj = row['subject_code']
        lvl = row['level_code']
        sql.append(f"""
INSERT INTO subject_level (subject_id, level_id, is_active, created_at)
SELECT s.id, l.id, 1, NOW()
FROM subjects s, level l
WHERE s.code = '{subj}' AND l.code = '{lvl}'
AND NOT EXISTS (
    SELECT 1 FROM subject_level sl2
    WHERE sl2.subject_id = s.id AND sl2.level_id = l.id
);""")

    sql.append("")

    # Create classes
    sql.append("-- 3. CREATE CLASSES")
    for idx, row in classes.iterrows():
        subj = row['subject_code']
        lvl = row['level_code']
        cohort = row['cohort_name']
        year = int(row['academic_year'])
        class_code = f"{subj}-{lvl}-{cohort}-{year}"

        sql.append(f"""
INSERT INTO class (class_code, subject_level_id, cohort_name, academic_year, session_id, delivery_mode, status, is_active, max_students, start_date, end_date, created_at)
SELECT '{class_code}', sl.id, '{cohort}', {year}, {session_id}, 'Full-Time', 'Active', 1, 100, '{year}-01-01', '{year}-12-31', NOW()
FROM subject_level sl
JOIN subjects s ON sl.subject_id = s.id
JOIN level l ON sl.level_id = l.id
WHERE s.code = '{subj}' AND l.code = '{lvl}'
AND sl.is_active = 1
AND NOT EXISTS (
    SELECT 1 FROM class c2
    WHERE c2.class_code = '{class_code}'
    AND c2.session_id = {session_id}
)
LIMIT 1;""")

    sql.append("")
    sql.append("-- VERIFICATION")
    sql.append("SELECT 'Subjects created:' as result, COUNT(*) as count FROM subjects WHERE is_active=1;")
    sql.append("SELECT 'Subject-levels created:' as result, COUNT(*) as count FROM subject_level WHERE is_active=1;")
    sql.append("SELECT 'Classes created:' as result, COUNT(*) as count FROM class WHERE academic_year=2026 AND is_active=1;")

    return "\n".join(sql)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python create_prerequisites.py <csv_file>")
        sys.exit(1)

    csv_file = sys.argv[1]
    sql = generate_prerequisites_sql(csv_file)

    # Write to file
    output_file = 'prerequisites.sql'
    with open(output_file, 'w') as f:
        f.write(sql)

    print(f"SQL generated: {output_file}")
    print("\nTo execute:")
    print(f"docker-compose exec db mysql -usmartschool -psmartschool123 smart_school < {output_file}")
