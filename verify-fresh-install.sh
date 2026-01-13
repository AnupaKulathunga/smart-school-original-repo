#!/bin/bash
# Verification script for fresh Smart School installation
# Run this after cloning the repository to verify pre-install state

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Smart School - Fresh Install Verification"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PASS=0
FAIL=0

# Check 1: config.php in pre-install state
echo -n "✓ Checking config.php (installed = false)... "
if grep -q "installed.*=.*false" smart_school_src/application/config/config.php 2>/dev/null; then
    echo "✅ PASS"
    ((PASS++))
else
    echo "❌ FAIL"
    ((FAIL++))
fi

# Check 2: autoload.php in pre-install state
echo -n "✓ Checking autoload.php (minimal libraries)... "
if grep -q "database.*session.*form_validation" smart_school_src/application/config/autoload.php 2>/dev/null; then
    echo "✅ PASS"
    ((PASS++))
else
    echo "❌ FAIL"
    ((FAIL++))
fi

# Check 3: database.php should NOT exist
echo -n "✓ Checking database.php (should not exist)... "
if [ ! -f "smart_school_src/application/config/database.php" ]; then
    echo "✅ PASS"
    ((PASS++))
else
    echo "❌ FAIL (exists - should be created by installer)"
    ((FAIL++))
fi

# Check 4: database.php.example should exist
echo -n "✓ Checking database.php.example (template)... "
if [ -f "smart_school_src/application/config/database.php.example" ]; then
    echo "✅ PASS"
    ((PASS++))
else
    echo "❌ FAIL"
    ((FAIL++))
fi

# Check 5: Installer should exist
echo -n "✓ Checking installer directory... "
if [ -f "smart_school_src/application/controllers/install/Start.php" ]; then
    echo "✅ PASS"
    ((PASS++))
else
    echo "❌ FAIL"
    ((FAIL++))
fi

# Check 6: Database schema should exist
echo -n "✓ Checking database.sql... "
if [ -f "smart_school_src/application/controllers/install/database.sql" ]; then
    echo "✅ PASS"
    ((PASS++))
else
    echo "❌ FAIL"
    ((FAIL++))
fi

# Check 7: Core images should exist
echo -n "✓ Checking core/default images... "
DEFAULT_IMAGES=$(find smart_school_src/uploads -name "default*.jpg" -o -name "no_image.png" | wc -l | tr -d ' ')
if [ "$DEFAULT_IMAGES" -gt "10" ]; then
    echo "✅ PASS ($DEFAULT_IMAGES images found)"
    ((PASS++))
else
    echo "❌ FAIL (only $DEFAULT_IMAGES images)"
    ((FAIL++))
fi

# Check 8: Required directories should exist
echo -n "✓ Checking required directories... "
DIRS_OK=true
for dir in uploads backup temp "application/logs"; do
    if [ ! -d "smart_school_src/$dir" ]; then
        DIRS_OK=false
    fi
done
if [ "$DIRS_OK" = true ]; then
    echo "✅ PASS"
    ((PASS++))
else
    echo "❌ FAIL"
    ((FAIL++))
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Results: $PASS passed, $FAIL failed"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $FAIL -eq 0 ]; then
    echo "✅ SUCCESS! Repository is in correct pre-install state."
    echo ""
    echo "Next steps:"
    echo "1. Set file permissions (see README.md)"
    echo "2. Navigate to: http://localhost/smart_school_src/install"
    echo "3. Follow the installer steps"
    echo ""
else
    echo "⚠️  WARNING: Some checks failed!"
    echo "Please verify the repository was cloned correctly."
    echo ""
fi

exit $FAIL
