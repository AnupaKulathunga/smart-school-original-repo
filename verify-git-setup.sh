#!/bin/bash
# Smart School - Git Setup Verification Script
# Run this after 'git add .' and before 'git commit'

echo "============================================"
echo "Smart School - Git Setup Verification"
echo "============================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: database.php should NOT be tracked
echo "Test 1: Checking database.php is NOT tracked..."
if git ls-files | grep -q "smart_school_src/application/config/database.php$"; then
    echo -e "${RED}❌ FAIL: database.php is tracked (should be excluded)${NC}"
    exit 1
else
    echo -e "${GREEN}✅ PASS: database.php is not tracked${NC}"
fi

# Test 2: database.php.example SHOULD be tracked
echo "Test 2: Checking database.php.example IS tracked..."
if git ls-files | grep -q "database.php.example"; then
    echo -e "${GREEN}✅ PASS: database.php.example is tracked${NC}"
else
    echo -e "${RED}❌ FAIL: database.php.example is NOT tracked${NC}"
    exit 1
fi

# Test 3: Core images should be tracked (~32 files)
echo "Test 3: Checking core/default images are tracked..."
IMAGE_COUNT=$(git ls-files | grep -E "uploads.*\.(jpg|png)" | wc -l | tr -d ' ')
if [ "$IMAGE_COUNT" -ge 25 ] && [ "$IMAGE_COUNT" -le 40 ]; then
    echo -e "${GREEN}✅ PASS: $IMAGE_COUNT core images tracked (expected ~32)${NC}"
else
    echo -e "${YELLOW}⚠️  WARNING: $IMAGE_COUNT images tracked (expected ~32)${NC}"
fi

# Test 4: User uploads should NOT be tracked
echo "Test 4: Checking user uploads are NOT tracked..."
USER_UPLOADS=$(git ls-files | grep -E "uploads/(homework|student_documents|staff_documents|offline_payments)" | wc -l | tr -d ' ')
if [ "$USER_UPLOADS" -eq 0 ]; then
    echo -e "${GREEN}✅ PASS: User uploads not tracked${NC}"
else
    echo -e "${RED}❌ FAIL: $USER_UPLOADS user upload files are tracked${NC}"
    exit 1
fi

# Test 5: .DS_Store should NOT be tracked
echo "Test 5: Checking .DS_Store files are NOT tracked..."
if git ls-files | grep -q "\.DS_Store"; then
    echo -e "${RED}❌ FAIL: .DS_Store files are tracked${NC}"
    exit 1
else
    echo -e "${GREEN}✅ PASS: No .DS_Store files tracked${NC}"
fi

# Test 6: Log files should NOT be tracked
echo "Test 6: Checking log files are NOT tracked..."
LOG_FILES=$(git ls-files | grep "\.log$" | wc -l | tr -d ' ')
if [ "$LOG_FILES" -eq 0 ]; then
    echo -e "${GREEN}✅ PASS: No log files tracked${NC}"
else
    echo -e "${RED}❌ FAIL: $LOG_FILES log files are tracked${NC}"
    exit 1
fi

# Test 7: Database schema SHOULD be tracked
echo "Test 7: Checking database.sql IS tracked..."
if git ls-files | grep -q "database.sql"; then
    echo -e "${GREEN}✅ PASS: database.sql is tracked${NC}"
else
    echo -e "${RED}❌ FAIL: database.sql is NOT tracked${NC}"
    exit 1
fi

# Test 8: Installer SHOULD be tracked
echo "Test 8: Checking installer is tracked..."
if git ls-files | grep -q "install/Start.php"; then
    echo -e "${GREEN}✅ PASS: Installer is tracked${NC}"
else
    echo -e "${RED}❌ FAIL: Installer is NOT tracked${NC}"
    exit 1
fi

# Summary
echo ""
echo "============================================"
echo -e "${GREEN}✅ All tests passed!${NC}"
echo "============================================"
echo ""
echo "Summary:"
echo "  - Core images tracked: $IMAGE_COUNT"
echo "  - User uploads tracked: $USER_UPLOADS"
echo "  - Log files tracked: $LOG_FILES"
echo ""
echo "Repository is ready for initial commit!"
echo ""
echo "Next steps:"
echo "  git commit -m \"Initial commit: Smart School v7.1.0\""
echo "  git remote add origin <your-repo-url>"
echo "  git push -u origin main"
echo ""
