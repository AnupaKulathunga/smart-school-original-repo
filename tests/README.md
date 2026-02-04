# Smart School TVET E2E Tests

Comprehensive end-to-end tests for the TVET transformation project.

## Overview

This test suite verifies that all refactored views work correctly with the new TVET architecture (CLASS = Subject + Level + Cohort) and without legacy section dropdowns.

## Directory Structure

```
tests/
├── e2e/
│   ├── admin/          # Admin panel E2E tests
│   │   ├── attendance.spec.ts
│   │   ├── exam.spec.ts
│   │   └── timetable.spec.ts
│   └── helpers.ts      # Common test utilities
├── fixtures/           # Test data and fixtures
├── scripts/
│   └── sanity_check.sh # Quick sanity check script
├── package.json
├── playwright.config.ts
└── README.md
```

## Prerequisites

1. **Docker must be running** with Smart School containers up
2. **Node.js 18+** installed
3. **Application accessible** at http://localhost:8080

## Installation

```bash
cd tests
npm install
npx playwright install  # Install browser binaries
```

## Running Tests

### Quick Sanity Check (No Installation Required)

```bash
# From project root
bash tests/scripts/sanity_check.sh
```

This checks:
- Critical pages are accessible
- Database integrity (TVET tables exist)
- No broken links on main pages

### Full E2E Test Suite

```bash
cd tests

# Run all tests (headless)
npm test

# Run with visible browser
npm run test:headed

# Run in debug mode
npm run test:debug

# Run with UI mode (interactive)
npm run test:ui

# Run specific test file
npx playwright test e2e/admin/attendance.spec.ts

# View last test report
npm run test:report
```

## Environment Variables

Create a `.env` file in the `tests` directory:

```env
BASE_URL=http://localhost:8080
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin123
```

## What Tests Verify

### ✅ TVET Architecture Compliance

1. **No Section Dropdowns** - Verifies section_id dropdowns are removed
2. **Class Selector Present** - Confirms class_selector component is used
3. **Enrolment-Based Tracking** - Checks for enrolment_id instead of student_session_id
4. **JavaScript Cleanup** - Verifies legacy getSectionByClass() functions are removed

### ✅ Critical Workflows

- **Attendance**: Class selection → Student list load → Attendance marking
- **Exams**: Exam schedule creation, mark entry, online exam assignment
- **Timetable**: Class-based timetable viewing and creation
- **Certificates**: Student certificate and ID card generation

### ✅ Data Display

- Enrolment types (Core/Elective) displayed correctly
- CLASS format: "Subject - Level (Cohort)"
- Student lists load properly without section filtering

## Test Coverage

| Module | Tests | Status |
|--------|-------|--------|
| Attendance | 6 tests | ✅ |
| Exams | 5 tests | ✅ |
| Timetable | 4 tests | 📝 |
| Certificates | 3 tests | 📝 |

## Continuous Integration

Tests are designed to run in CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
- name: Run E2E Tests
  run: |
    docker-compose up -d
    cd tests
    npm ci
    npx playwright install --with-deps
    npm test
```

## Debugging Failed Tests

1. **View Screenshots**: Check `tests/results/playwright-report/` for failure screenshots
2. **View Traces**: Open trace files with `npx playwright show-trace trace.zip`
3. **Run in Debug Mode**: `npm run test:debug` to step through tests
4. **Check Logs**: Review Docker logs with `docker-compose logs web`

## Common Issues

### Tests Fail with "Navigation Timeout"

**Solution**: Ensure Docker containers are running:
```bash
docker-compose up -d
docker-compose ps  # Check status
```

### Login Fails

**Solution**: Verify admin credentials in `.env` file or use defaults (admin/admin123)

### Database Tests Fail

**Solution**: Run database migrations:
```bash
docker-compose exec db mysql -usmartschool -psmartschool123 smart_school < smart_school_src/application/migrations/011_tvet_unified_core_structure.sql
```

## Adding New Tests

1. Create a new `.spec.ts` file in `e2e/admin/`
2. Import helpers from `../helpers`
3. Follow the existing test pattern
4. Run locally to verify
5. Commit with descriptive message

Example:
```typescript
import { test, expect } from '@playwright/test';
import { loginAsAdmin, verifySectionDropdownRemoved } from '../helpers';

test.describe('My New Module', () => {
  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  test('should work without sections', async ({ page }) => {
    await page.goto('/admin/mymodule');
    await verifySectionDropdownRemoved(page);
  });
});
```

## Success Criteria

All tests should pass before:
- ✅ Completing Phase 5 (Testing)
- ✅ Starting Phase 6 (Legacy Cleanup)
- ✅ Production deployment

## Resources

- [Playwright Documentation](https://playwright.dev/)
- [Smart School TVET Plan](/TVET_TRANSFORMATION_PLAN.md)
- [Phase 4 Refactoring Guide](/PHASE4_VIEW_REFACTORING_GUIDE.md)
