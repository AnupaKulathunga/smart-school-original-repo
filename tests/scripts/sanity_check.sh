#!/bin/bash
echo "=== TVET Migration Sanity Check ==="
echo ""

# Check Docker is running
echo "1. Docker Services..."
docker-compose ps | grep "Up" || echo "FAIL: Docker services not running"

# Database integrity
echo ""
echo "2. Database Integrity..."
docker-compose exec -T db mysql -usmartschool -psmartschool123 smart_school <<SQL
SELECT
  (SELECT COUNT(DISTINCT student_id) FROM enrolment
   WHERE session_id = (SELECT id FROM sessions WHERE is_active = 'yes')) as enrolled_students,
  (SELECT COUNT(*) FROM class WHERE is_active = 1) as active_classes,
  (SELECT COUNT(*) FROM stuattendence WHERE enrolment_id IS NOT NULL) as attendance_records;
SQL

# Critical pages HTTP status
echo ""
echo "3. Critical Pages HTTP Status..."
pages=(
  "/admin/admin/dashboard"
  "/student/disablestudentslist"
  "/student/search"
  "/admin/stuattendence"
  "/admin/onlineexam"
  "/admin/approve_leave"
)

for page in "${pages[@]}"; do
  status=$(curl -s -o /dev/null -w "%{http_code}" -u "admin:admin123" "http://localhost:8080$page")
  if [ "$status" -eq 200 ] || [ "$status" -eq 302 ]; then
    echo "✓ $page - $status"
  else
    echo "✗ FAIL: $page - $status"
  fi
done

# Check for legacy tables (should not exist after cleanup)
echo ""
echo "4. Legacy Tables Check..."
docker-compose exec -T db mysql -usmartschool -psmartschool123 smart_school <<SQL
SHOW TABLES LIKE 'student_session';
SHOW TABLES LIKE 'class_sections';
SHOW TABLES LIKE 'sections';
SQL

echo ""
echo "=== Sanity Check Complete ==="
