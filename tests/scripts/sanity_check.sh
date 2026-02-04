#!/bin/bash
#
# TVET Migration Sanity Check Script
# Verifies critical pages and database integrity after refactoring
#

set -e

echo "============================================"
echo "TVET Migration Sanity Check"
echo "============================================"
echo ""

BASE_URL="${BASE_URL:-http://localhost:8080}"
FAILED=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check HTTP status
check_page() {
    local url=$1
    local name=$2

    echo -n "Checking $name... "

    status=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "000")

    if [ "$status" = "200" ] || [ "$status" = "302" ]; then
        echo -e "${GREEN}OK${NC} (HTTP $status)"
    else
        echo -e "${RED}FAIL${NC} (HTTP $status)"
        FAILED=$((FAILED + 1))
    fi
}

echo "1. Checking Critical Pages..."
echo "----------------------------------------"

check_page "$BASE_URL/admin" "Admin Login"
check_page "$BASE_URL/admin/admin/dashboard" "Admin Dashboard"
check_page "$BASE_URL/admin/stuattendence" "Attendance Page"
check_page "$BASE_URL/admin/examschedule" "Exam Schedule"
check_page "$BASE_URL/admin/timetable/classreport" "Timetable"
check_page "$BASE_URL/admin/onlineexam" "Online Exam"
check_page "$BASE_URL/admin/lessonplan" "Lesson Plan"
check_page "$BASE_URL/admin/subjectattendence" "Subject Attendance"
check_page "$BASE_URL/admin/generatecertificate" "Certificate Generation"

echo ""
echo "2. Checking Database Integrity..."
echo "----------------------------------------"

# Check if Docker is running
if ! docker ps &> /dev/null; then
    echo -e "${YELLOW}WARNING:${NC} Docker not running. Skipping database checks."
else
    # Check TVET tables exist
    echo -n "Checking TVET tables... "

    tables=$(docker-compose exec -T db mysql -usmartschool -psmartschool123 smart_school -e "
        SHOW TABLES LIKE 'class';
    " 2>/dev/null | grep -c "class" || echo "0")

    if [ "$tables" -gt "0" ]; then
        echo -e "${GREEN}OK${NC}"
    else
        echo -e "${RED}FAIL${NC} - TVET tables not found"
        FAILED=$((FAILED + 1))
    fi

    # Check for active classes
    echo -n "Checking active classes... "

    class_count=$(docker-compose exec -T db mysql -usmartschool -psmartschool123 smart_school -e "
        SELECT COUNT(*) as count FROM class WHERE is_active = 1;
    " 2>/dev/null | tail -1 || echo "0")

    if [ "$class_count" -gt "0" ]; then
        echo -e "${GREEN}OK${NC} ($class_count classes)"
    else
        echo -e "${YELLOW}WARNING:${NC} No active classes found"
    fi

    # Check enrolments
    echo -n "Checking student enrolments... "

    enrolment_count=$(docker-compose exec -T db mysql -usmartschool -psmartschool123 smart_school -e "
        SELECT COUNT(*) as count FROM enrolment WHERE status = 'Active';
    " 2>/dev/null | tail -1 || echo "0")

    if [ "$enrolment_count" -gt "0" ]; then
        echo -e "${GREEN}OK${NC} ($enrolment_count enrolments)"
    else
        echo -e "${YELLOW}WARNING:${NC} No active enrolments found"
    fi
fi

echo ""
echo "3. Checking Legacy Table Status..."
echo "----------------------------------------"

if docker ps &> /dev/null; then
    # Check if legacy tables still exist (should exist until Phase 6)
    echo -n "Checking legacy tables... "

    legacy_tables=$(docker-compose exec -T db mysql -usmartschool -psmartschool123 smart_school -e "
        SHOW TABLES LIKE 'student_session';
    " 2>/dev/null | grep -c "student_session" || echo "0")

    if [ "$legacy_tables" -gt "0" ]; then
        echo -e "${YELLOW}PRESENT${NC} (Normal until Phase 6 cleanup)"
    else
        echo -e "${GREEN}REMOVED${NC}"
    fi
fi

echo ""
echo "============================================"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All sanity checks passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ $FAILED check(s) failed${NC}"
    exit 1
fi
