# Phase 5: Testing Infrastructure - Complete Guide

## Overview

Phase 5 establishes comprehensive testing infrastructure to verify the TVET transformation works correctly before legacy cleanup (Phase 6).

---

## Test Infrastructure Components

### 1. **Playwright E2E Tests** ✅

**Location:** `/tests/e2e/`

**Coverage:**
- ✅ Attendance module (6 tests)
- ✅ Exam management (5 tests)
- ✅ Timetable (4 tests)
- 📝 Certificate generation (planned)
- 📝 Lesson planning (planned)

**Key Tests:**
```typescript
// Verify NO section dropdown exists
await verifySectionDropdownRemoved(page);

// Verify class selector present
await verifyClassSelector(page);

// Verify legacy JavaScript removed
expect(pageContent).not.toContain('getSectionByClass');
```

### 2. **Sanity Check Script** ✅

**Location:** `/tests/scripts/sanity_check.sh`

**Checks:**
- ✅ Critical pages accessible (9 pages)
- ✅ Database integrity (TVET tables exist)
- ✅ Active classes and enrolments
- ✅ Legacy table status

**Usage:**
```bash
cd tests
bash scripts/sanity_check.sh
```

### 3. **Test Helpers** ✅

**Location:** `/tests/e2e/helpers.ts`

**Utilities:**
- `loginAsAdmin()` - Admin authentication
- `verifySectionDropdownRemoved()` - Critical TVET check
- `verifyClassSelector()` - Component verification
- `selectFirstClass()` - Class selection helper
- `waitForLoading()` - Loading state handling

---

## Running Tests

### Quick Start

```bash
# 1. Ensure Docker is running
docker-compose up -d

# 2. Install dependencies (first time only)
cd tests
npm install
npx playwright install

# 3. Run sanity check (fast, no installation needed)
bash scripts/sanity_check.sh

# 4. Run full E2E test suite
npm test
```

### Test Commands

```bash
# Run all tests (headless)
npm test

# Run with visible browser (good for debugging)
npm run test:headed

# Run in debug mode (step through tests)
npm run test:debug

# Run with UI mode (interactive)
npm run test:ui

# Run specific test
npx playwright test e2e/admin/attendance.spec.ts

# View HTML report
npm run test:report
```

---

## Test Scenarios

### Critical TVET Verification Tests

#### 1. **No Section Dropdowns** 🔴 CRITICAL
```typescript
test('should not have section dropdown', async ({ page }) => {
  await page.goto('/admin/stuattendence');
  const sectionDropdown = page.locator('select[name="section_id"]');
  await expect(sectionDropdown).toHaveCount(0);
});
```

#### 2. **Class Selector Present** 🔴 CRITICAL
```typescript
test('should have class selector', async ({ page }) => {
  await page.goto('/admin/stuattendence');
  const classDropdown = page.locator('select[name="class_id"]');
  await expect(classDropdown).toBeVisible();
});
```

#### 3. **Legacy JavaScript Removed** 🟡 IMPORTANT
```typescript
test('should not have getSectionByClass', async ({ page }) => {
  await page.goto('/admin/stuattendence');
  const content = await page.content();
  expect(content).not.toContain('getSectionByClass');
});
```

#### 4. **Enrolment Type Display** 🟡 IMPORTANT
```typescript
test('should show enrolment type (Core/Elective)', async ({ page }) => {
  // ... load students ...
  const badge = page.locator('.label, .badge');
  await expect(badge).toBeVisible();
});
```

---

## Test Results Interpretation

### Success Output

```bash
✓ tests/e2e/admin/attendance.spec.ts:15:3 › should load without section dropdown
✓ tests/e2e/admin/attendance.spec.ts:28:3 › should load students
✓ tests/e2e/admin/exam.spec.ts:12:3 › should load exam page

15 passed (45s)
```

### Failure Output

```bash
✗ tests/e2e/admin/attendance.spec.ts:15:3 › should load without section dropdown

Error: expect(locator).toHaveCount(0)

Expected: 0
Received: 1

  21 |   await page.goto('/admin/stuattendence');
  22 |   const sectionDropdown = page.locator('select[name="section_id"]');
> 23 |   await expect(sectionDropdown).toHaveCount(0);
     |         ^
```

**Action:** Section dropdown still exists - view not fully refactored

---

## Sanity Check Output

### Expected Output (Success)

```bash
============================================
TVET Migration Sanity Check
============================================

1. Checking Critical Pages...
----------------------------------------
Checking Admin Login... OK (HTTP 200)
Checking Admin Dashboard... OK (HTTP 302)
Checking Attendance Page... OK (HTTP 200)
Checking Exam Schedule... OK (HTTP 200)
Checking Timetable... OK (HTTP 200)

2. Checking Database Integrity...
----------------------------------------
Checking TVET tables... OK
Checking active classes... OK (15 classes)
Checking student enrolments... OK (234 enrolments)

3. Checking Legacy Table Status...
----------------------------------------
Checking legacy tables... PRESENT (Normal until Phase 6 cleanup)

============================================
✓ All sanity checks passed!
```

---

## Test Coverage Matrix

| Module | E2E Tests | Sanity Check | Manual Test | Status |
|--------|-----------|--------------|-------------|--------|
| Attendance | ✅ 6 tests | ✅ URL check | 📝 Pending | ✅ |
| Exams | ✅ 5 tests | ✅ URL check | 📝 Pending | ✅ |
| Timetable | ✅ 4 tests | ✅ URL check | 📝 Pending | ✅ |
| Online Exam | ✅ 2 tests | ✅ URL check | 📝 Pending | ✅ |
| Lesson Plan | 📝 Planned | ✅ URL check | 📝 Pending | 🟡 |
| Certificates | 📝 Planned | ✅ URL check | 📝 Pending | 🟡 |
| Subject Attendance | 📝 Planned | ✅ URL check | 📝 Pending | 🟡 |

---

## Debugging Failed Tests

### 1. View Screenshots

```bash
# Screenshots saved automatically on failure
ls tests/results/playwright-report/
```

### 2. View Trace Files

```bash
# Open trace viewer
npx playwright show-trace tests/results/trace.zip
```

### 3. Run in Debug Mode

```bash
# Step through test line by line
npm run test:debug
```

### 4. Check Application Logs

```bash
# View PHP/Apache logs
docker-compose logs -f web

# View MySQL logs
docker-compose logs -f db
```

---

## Common Issues & Solutions

### Issue 1: Tests Timeout

**Symptom:** `Navigation timeout of 30000ms exceeded`

**Solution:**
```bash
# Check Docker is running
docker-compose ps

# Restart containers
docker-compose down && docker-compose up -d

# Verify app is accessible
curl http://localhost:8080
```

### Issue 2: Login Fails

**Symptom:** `expect(page).toHaveURL(...) failed`

**Solution:**
```bash
# Verify credentials in .env
cat tests/.env

# Use default credentials
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin123
```

### Issue 3: Section Dropdown Still Exists

**Symptom:** `expect(locator).toHaveCount(0) - Expected: 0, Received: 1`

**Solution:**
- View was not refactored in Phase 4
- Check if view file has `_legacy_backup.php` version
- Re-run refactoring for that view
- Verify class_selector component is used

### Issue 4: Database Tests Fail

**Symptom:** `TVET tables not found`

**Solution:**
```bash
# Run migrations
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school < smart_school_src/application/migrations/011_tvet_unified_core_structure.sql
```

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: E2E Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Start Docker containers
        run: docker-compose up -d

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        working-directory: tests
        run: |
          npm ci
          npx playwright install --with-deps

      - name: Run tests
        working-directory: tests
        run: npm test

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: tests/results/playwright-report/
```

---

## Success Criteria

Phase 5 is complete when:

- ✅ All E2E tests pass (15+ tests)
- ✅ Sanity check passes (9 pages, database checks)
- ✅ Zero section dropdowns detected in critical views
- ✅ All legacy JavaScript functions removed
- ✅ Class selector component verified on all tested pages
- ✅ Test documentation complete
- ✅ CI/CD pipeline configured (optional)

---

## Next Steps

After Phase 5 completion:

1. **Review Test Results** - Ensure 100% pass rate
2. **Fix Any Failures** - Address broken views/functionality
3. **Document Issues** - Log any bugs found
4. **Proceed to Phase 6** - Legacy cleanup (only if all tests pass!)

---

**Last Updated:** 2026-02-04
**Phase Status:** In Progress
**Test Coverage:** 15 tests (Critical paths covered)
