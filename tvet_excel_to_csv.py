#!/usr/bin/env python3
"""
TVET Excel to CSV Converter
Converts Goodwood Online Excel enrollment data to CSV format for bulk import

Usage:
    # Full conversion
    python tvet_excel_to_csv.py --input "file.xlsx" --output-dir ./output

    # Analysis only (report without conversion)
    python tvet_excel_to_csv.py --input "file.xlsx" --analyze-only

Requirements:
    pip install pandas openpyxl
"""

import pandas as pd
import argparse
import re
import logging
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass


@dataclass
class ValidationResult:
    """Result of row validation"""
    is_valid: bool
    errors: List[str]
    warnings: List[str]


class TVETExcelConverter:
    """Converts Excel enrollment data to TVET CSV format"""

    # SUBJECT_CODE pattern: MATHN2S format (subject + level + optional semester)
    SUBJECT_CODE_PATTERN = r'^([A-Z]+)(N[1-6]C?)([A-Z]?)$'

    # CSV column order (17 columns)
    CSV_COLUMNS = [
        'admission_no', 'firstname', 'lastname', 'id_number', 'dob', 'gender',
        'mobileno', 'email', 'subject_code', 'level_code', 'cohort_name',
        'academic_year', 'qualification_name', 'campus_name', 'enrolment_date',
        'status', 'notes'
    ]

    def __init__(self, input_file: str, output_dir: str = './output',
                 cohort: str = 'A', year: int = None, skip_orphaned: bool = True,
                 verbose: bool = False):
        """
        Initialize converter

        Args:
            input_file: Path to Excel file
            output_dir: Output directory for generated files
            cohort: Default cohort name (default: A)
            year: Academic year (default: current year)
            skip_orphaned: Skip rows with no student data (default: True)
            verbose: Show detailed progress (default: False)
        """
        self.input_file = input_file
        self.output_dir = Path(output_dir)
        self.cohort = cohort
        self.year = year or datetime.now().year
        self.skip_orphaned = skip_orphaned
        self.verbose = verbose

        # Create output directory
        self.output_dir.mkdir(parents=True, exist_ok=True)

        # Setup logging
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        log_file = self.output_dir / f'errors_{timestamp}.log'
        logging.basicConfig(
            level=logging.DEBUG if verbose else logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler(log_file),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger(__name__)

        # Statistics
        self.stats = {
            'total': 0,
            'valid': 0,
            'orphaned': 0,
            'invalid': 0,
            'unique_students': 0,
            'subjects': set(),
            'levels': set(),
            'qualifications': set(),
            'subject_levels': set()
        }

    def extract_dob_from_id(self, id_num: str) -> Optional[str]:
        """
        Extract date of birth from 13-digit SA ID: YYMMDD GSSS CAZ

        Args:
            id_num: 13-digit SA ID number

        Returns:
            DOB in YYYY-MM-DD format or None if invalid
        """
        if not id_num or not str(id_num).isdigit() or len(str(id_num)) != 13:
            return None

        id_str = str(id_num)
        yy, mm, dd = id_str[0:2], id_str[2:4], id_str[4:6]

        try:
            year = int(yy)
            # Century determination: <22 → 2000s, >=22 → 1900s
            century = "20" if year < 22 else "19"
            dob = f"{century}{yy}-{mm}-{dd}"

            # Basic validation
            datetime.strptime(dob, '%Y-%m-%d')
            return dob
        except ValueError:
            return None

    def extract_gender_from_id(self, id_num: str) -> Optional[str]:
        """
        Extract gender from SA ID position 7-10 (GSSS): Gender Sequence
        0000-4999 = Female
        5000-9999 = Male

        Args:
            id_num: 13-digit SA ID number

        Returns:
            'Male' or 'Female' or None if invalid
        """
        if not id_num or not str(id_num).isdigit() or len(str(id_num)) != 13:
            return None

        id_str = str(id_num)
        try:
            gender_digits = int(id_str[6:10])
            return "Male" if gender_digits >= 5000 else "Female"
        except ValueError:
            return None

    def parse_subject_code(self, subject_code: str) -> Dict:
        """
        Parse compressed SUBJECT_CODE format: MATHN2S
        Pattern: ^([A-Z]+)(N[1-6]C?)([A-Z]?)$

        Args:
            subject_code: Compressed subject code (e.g., MATHN2S, ENGN4)

        Returns:
            Dict with subject, level, semester, success, error
        """
        if not subject_code:
            return {
                'subject': None,
                'level': None,
                'semester': None,
                'success': False,
                'error': 'Empty SUBJECT_CODE'
            }

        pattern = re.compile(self.SUBJECT_CODE_PATTERN)
        match = pattern.match(str(subject_code).strip().upper())

        if not match:
            return {
                'subject': None,
                'level': None,
                'semester': None,
                'success': False,
                'error': f'Invalid SUBJECT_CODE format: {subject_code}'
            }

        return {
            'subject': match.group(1),
            'level': match.group(2),
            'semester': match.group(3) or '',
            'success': True,
            'error': None
        }

    def validate_row(self, row: Dict) -> ValidationResult:
        """
        Validate Excel row data

        Required:
        - STUDENT_NUMBER not null
        - FIRST_NAMES not null
        - SURNAME not null
        - SUBJECT_CODE exists and parseable

        Args:
            row: Dictionary with Excel row data

        Returns:
            ValidationResult with is_valid, errors, warnings
        """
        errors = []
        warnings = []

        # Check for orphaned row (no student data)
        if pd.isna(row.get('STUDENT_NUMBER')) or str(row.get('STUDENT_NUMBER')).strip() == '':
            errors.append('STUDENT_NUMBER is required (orphaned row)')

        if pd.isna(row.get('FIRST_NAMES')) or str(row.get('FIRST_NAMES')).strip() == '':
            errors.append('FIRST_NAMES is required')

        if pd.isna(row.get('SURNAME')) or str(row.get('SURNAME')).strip() == '':
            errors.append('SURNAME is required')

        if pd.isna(row.get('SUBJECT_CODE')) or str(row.get('SUBJECT_CODE')).strip() == '':
            errors.append('SUBJECT_CODE is required')
        else:
            # Parse subject code
            parsed = self.parse_subject_code(row['SUBJECT_CODE'])
            if not parsed['success']:
                errors.append(parsed['error'])

        # Optional validation
        if not pd.isna(row.get('ID_NUMBER')):
            id_num = str(row['ID_NUMBER']).strip()
            if id_num and len(id_num) != 13:
                warnings.append(f'ID_NUMBER should be 13 digits, got {len(id_num)}')

        if not pd.isna(row.get('StudentCellphoneNumber')):
            phone = str(row['StudentCellphoneNumber']).replace(' ', '').replace('-', '')
            if phone and not re.match(r'^0\d{9}$', phone):
                warnings.append('Phone should be 10 digits starting with 0')

        if not pd.isna(row.get('StudentEmailAddress')):
            email = str(row['StudentEmailAddress']).strip()
            if email and not re.match(r'^[\w\.-]+@[\w\.-]+\.\w+$', email):
                warnings.append('Invalid email format')

        return ValidationResult(
            is_valid=len(errors) == 0,
            errors=errors,
            warnings=warnings
        )

    def excel_row_to_csv_row(self, row: Dict) -> Dict:
        """
        Convert Excel row to CSV row format

        Args:
            row: Dictionary with Excel row data

        Returns:
            Dictionary with 17 CSV columns
        """
        # Parse subject code
        subject_parsed = self.parse_subject_code(row.get('SUBJECT_CODE', ''))

        # Extract from ID
        id_number = None
        if not pd.isna(row.get('ID_NUMBER')):
            id_number = str(row['ID_NUMBER']).strip()

        dob = self.extract_dob_from_id(id_number) if id_number else ''
        gender = self.extract_gender_from_id(id_number) if id_number else ''

        # Determine status
        status = 'Dropped' if not pd.isna(row.get('CANCEL_DATE')) else 'Active'

        # Clean string values
        def clean_str(val):
            if pd.isna(val):
                return ''
            return str(val).strip()

        return {
            'admission_no': clean_str(row.get('STUDENT_NUMBER')),
            'firstname': clean_str(row.get('FIRST_NAMES')),
            'lastname': clean_str(row.get('SURNAME')),
            'id_number': id_number or '',
            'dob': dob,
            'gender': gender,
            'mobileno': clean_str(row.get('StudentCellphoneNumber')),
            'email': clean_str(row.get('StudentEmailAddress')),
            'subject_code': subject_parsed.get('subject', ''),
            'level_code': subject_parsed.get('level', ''),
            'cohort_name': self.cohort,
            'academic_year': self.year,
            'qualification_name': clean_str(row.get('QUALIFICATION_NAME')),
            'campus_name': clean_str(row.get('CAMPUS_NAME')),
            'enrolment_date': datetime.now().strftime('%Y-%m-%d'),
            'status': status,
            'notes': ''
        }

    def analyze_excel(self, df: pd.DataFrame) -> str:
        """
        Analyze Excel file and generate report

        Args:
            df: DataFrame with Excel data

        Returns:
            Analysis report as string
        """
        report = []
        report.append("=" * 80)
        report.append("TVET EXCEL ANALYSIS REPORT")
        report.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append("=" * 80)
        report.append("")

        # Basic stats
        report.append(f"Total Rows: {len(df):,}")

        # Count valid vs orphaned
        valid_count = 0
        orphaned_count = 0

        for idx, row in df.iterrows():
            validation = self.validate_row(row)
            if 'orphaned row' in ' '.join(validation.errors).lower():
                orphaned_count += 1
            elif validation.is_valid:
                valid_count += 1

        report.append(f"Valid Rows: {valid_count:,}")
        report.append(f"Orphaned Rows (no student data): {orphaned_count:,}")
        report.append("")

        # Unique students
        unique_students = df['STUDENT_NUMBER'].dropna().nunique()
        report.append(f"Unique Students: {unique_students:,}")

        # Subject analysis
        subjects = set()
        levels = set()
        subject_levels = set()

        for idx, row in df.iterrows():
            if not pd.isna(row.get('SUBJECT_CODE')):
                parsed = self.parse_subject_code(row['SUBJECT_CODE'])
                if parsed['success']:
                    subjects.add(parsed['subject'])
                    levels.add(parsed['level'])
                    subject_levels.add(f"{parsed['subject']}-{parsed['level']}")

        report.append("")
        report.append(f"Unique Subjects: {len(subjects)}")
        report.append(f"  {', '.join(sorted(subjects))}")
        report.append("")
        report.append(f"Unique Levels: {len(levels)}")
        report.append(f"  {', '.join(sorted(levels))}")
        report.append("")
        report.append(f"Unique Subject-Level Combinations: {len(subject_levels)}")
        for sl in sorted(subject_levels):
            report.append(f"  - {sl}")
        report.append("")

        # Qualifications
        qualifications = df['QUALIFICATION_NAME'].dropna().unique()
        report.append(f"Unique Qualifications: {len(qualifications)}")
        for qual in sorted(qualifications):
            count = len(df[df['QUALIFICATION_NAME'] == qual])
            report.append(f"  - {qual} ({count} enrollments)")

        empty_qual = len(df[df['QUALIFICATION_NAME'].isna()])
        if empty_qual > 0:
            report.append(f"  - Empty/NULL ({empty_qual} enrollments)")
        report.append("")

        # Campus
        campuses = df['CAMPUS_NAME'].dropna().unique()
        report.append(f"Campus Distribution:")
        for campus in sorted(campuses):
            count = len(df[df['CAMPUS_NAME'] == campus])
            report.append(f"  - {campus} ({count} rows)")
        report.append("")

        # Status
        active = len(df[df['CANCEL_DATE'].isna()])
        dropped = len(df) - active
        report.append(f"Status Distribution:")
        report.append(f"  - Active (no CANCEL_DATE): {active:,} rows")
        report.append(f"  - Dropped (has CANCEL_DATE): {dropped:,} rows")
        report.append("")

        # Prerequisites
        report.append("=" * 80)
        report.append("PREREQUISITES REQUIRED BEFORE IMPORT:")
        report.append("=" * 80)
        report.append(f"✅ Create {len(subjects)} subjects in system")
        report.append(f"✅ Create {len(levels)} levels in system")
        report.append(f"✅ Create {len(subject_levels)} subject-level combinations")
        report.append(f"✅ Create {len(qualifications)} programmes")
        report.append(f"✅ Create ~{len(subject_levels)} classes (subject+level+cohort+year)")
        report.append("")

        return "\n".join(report)

    def convert(self) -> Tuple[int, int, int]:
        """
        Convert Excel file to CSV

        Returns:
            Tuple of (total, valid, orphaned) counts
        """
        self.logger.info(f"Reading Excel file: {self.input_file}")

        # Read Excel file
        try:
            df = pd.read_excel(self.input_file)
        except Exception as e:
            self.logger.error(f"Failed to read Excel file: {e}")
            raise

        self.logger.info(f"Loaded {len(df)} rows from Excel")

        # Process rows
        valid_rows = []
        orphaned_rows = []

        for idx, row in df.iterrows():
            self.stats['total'] += 1

            # Validate
            validation = self.validate_row(row)

            # Check if orphaned
            is_orphaned = 'orphaned row' in ' '.join(validation.errors).lower()

            if is_orphaned:
                self.stats['orphaned'] += 1
                self.logger.warning(f"Row {idx + 2}: Orphaned (no student data)")
                orphaned_rows.append((idx + 2, validation.errors))
                continue

            if not validation.is_valid:
                self.stats['invalid'] += 1
                self.logger.error(f"Row {idx + 2}: Invalid - {', '.join(validation.errors)}")
                continue

            if validation.warnings:
                for warning in validation.warnings:
                    self.logger.warning(f"Row {idx + 2}: {warning}")

            # Convert to CSV row
            csv_row = self.excel_row_to_csv_row(row)
            valid_rows.append(csv_row)
            self.stats['valid'] += 1

            # Track unique values
            self.stats['subjects'].add(csv_row['subject_code'])
            self.stats['levels'].add(csv_row['level_code'])
            if csv_row['qualification_name']:
                self.stats['qualifications'].add(csv_row['qualification_name'])
            self.stats['subject_levels'].add(f"{csv_row['subject_code']}-{csv_row['level_code']}")

        # Count unique students
        if valid_rows:
            unique_students = set(row['admission_no'] for row in valid_rows)
            self.stats['unique_students'] = len(unique_students)

        # Generate CSV
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        csv_file = self.output_dir / f'tvet_enrolments_{timestamp}.csv'

        if valid_rows:
            csv_df = pd.DataFrame(valid_rows, columns=self.CSV_COLUMNS)
            csv_df.to_csv(csv_file, index=False)
            self.logger.info(f"Generated CSV: {csv_file}")
        else:
            self.logger.warning("No valid rows to export")

        # Generate summary
        summary_file = self.output_dir / f'summary_{timestamp}.txt'
        summary = self._generate_summary()
        with open(summary_file, 'w') as f:
            f.write(summary)
        self.logger.info(f"Generated summary: {summary_file}")

        return self.stats['total'], self.stats['valid'], self.stats['orphaned']

    def _generate_summary(self) -> str:
        """Generate conversion summary"""
        lines = []
        lines.append("=" * 80)
        lines.append("TVET EXCEL TO CSV CONVERSION SUMMARY")
        lines.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        lines.append("=" * 80)
        lines.append("")
        lines.append(f"Input File: {self.input_file}")
        lines.append(f"Output Directory: {self.output_dir}")
        lines.append("")
        lines.append(f"Total Rows: {self.stats['total']:,}")
        lines.append(f"Valid Rows: {self.stats['valid']:,}")
        lines.append(f"Orphaned Rows: {self.stats['orphaned']:,}")
        lines.append(f"Invalid Rows: {self.stats['invalid']:,}")
        lines.append("")
        lines.append(f"Unique Students: {self.stats['unique_students']:,}")
        lines.append(f"Unique Subjects: {len(self.stats['subjects'])}")
        lines.append(f"Unique Levels: {len(self.stats['levels'])}")
        lines.append(f"Unique Subject-Levels: {len(self.stats['subject_levels'])}")
        lines.append(f"Unique Qualifications: {len(self.stats['qualifications'])}")
        lines.append("")
        lines.append("Conversion Parameters:")
        lines.append(f"  - Default Cohort: {self.cohort}")
        lines.append(f"  - Academic Year: {self.year}")
        lines.append(f"  - Skip Orphaned: {self.skip_orphaned}")
        lines.append("")
        return "\n".join(lines)


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(
        description='Convert TVET Excel enrollment data to CSV format'
    )
    parser.add_argument(
        '--input',
        required=True,
        help='Path to Excel file'
    )
    parser.add_argument(
        '--output-dir',
        default='./output',
        help='Output directory (default: ./output)'
    )
    parser.add_argument(
        '--cohort',
        default='A',
        help='Default cohort name (default: A)'
    )
    parser.add_argument(
        '--year',
        type=int,
        default=None,
        help='Academic year (default: current year)'
    )
    parser.add_argument(
        '--skip-orphaned',
        action='store_true',
        default=True,
        help='Skip rows with no student data (default: True)'
    )
    parser.add_argument(
        '--analyze-only',
        action='store_true',
        help='Generate analysis report without CSV conversion'
    )
    parser.add_argument(
        '--verbose',
        action='store_true',
        help='Show detailed progress'
    )

    args = parser.parse_args()

    # Initialize converter
    converter = TVETExcelConverter(
        input_file=args.input,
        output_dir=args.output_dir,
        cohort=args.cohort,
        year=args.year,
        skip_orphaned=args.skip_orphaned,
        verbose=args.verbose
    )

    if args.analyze_only:
        # Analysis mode
        print("Running analysis...")
        df = pd.read_excel(args.input)
        report = converter.analyze_excel(df)
        print(report)

        # Save report
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        report_file = Path(args.output_dir) / f'analysis_{timestamp}.txt'
        Path(args.output_dir).mkdir(parents=True, exist_ok=True)
        with open(report_file, 'w') as f:
            f.write(report)
        print(f"\nReport saved to: {report_file}")

    else:
        # Full conversion
        print("Converting Excel to CSV...")
        total, valid, orphaned = converter.convert()

        print("\n" + "=" * 80)
        print("CONVERSION COMPLETE")
        print("=" * 80)
        print(f"Total Rows: {total:,}")
        print(f"Valid Rows: {valid:,}")
        print(f"Orphaned Rows: {orphaned:,}")
        print(f"Unique Students: {converter.stats['unique_students']:,}")
        print(f"\nOutput files generated in: {args.output_dir}")


if __name__ == '__main__':
    main()
