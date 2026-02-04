# Smart School TVET Migration - Automated Tests

This directory contains automated E2E tests for verifying the TVET migration is working correctly.

## Prerequisites

- Docker and Docker Compose running
- Node.js 18+ installed
- Smart School application running on http://localhost:8080

## Setup

```bash
cd tests
npm install
npx playwright install chromium
```

## Running Tests

### Run all tests
```bash
npm test
```

### Run tests in headed mode (see browser)
```bash
npm run test:headed
```

### Run tests in UI mode (interactive debugging)
```bash
npm run test:ui
```

### Run specific test file
```bash
npx playwright test e2e/disabled-students.spec.ts
```

### Run tests in debug mode
```bash
npm run test:debug
```

### View test report
```bash
npm run test:report
```

## Sanity Check

Quick health check without full test suite:

```bash
./scripts/sanity_check.sh
```

This checks:
- Docker services are running
- Database integrity (students, classes, attendance)
- Critical pages return 200/302 status
- Legacy tables don't exist

## Test Coverage

### E2E Tests

1. **disabled-students.spec.ts**
   - Verifies disabled students list page loads without 500 error
   - Checks TVET class selector exists (no section dropdown)
   - Tests search by class and by keyword

2. **student-search.spec.ts**
   - Verifies student search page has TVET class selector
   - Checks class dropdown shows "Subject - Level (Cohort)" format
   - Tests search functionality

3. **attendance.spec.ts**
   - Verifies attendance page has TVET class selector
   - Tests marking attendance without errors
   - Checks enrolment types (Core/Elective) display

4. **online-exam.spec.ts**
   - Verifies online exam page loads without 500 error
   - Checks modal has TVET class selector
   - Tests exam list display

5. **approve-leave.spec.ts**
   - Verifies approve leave page has TVET class selector
   - Checks class options show in TVET format
   - Tests leave request search

## Test Results

Test results are saved in:
- `results/html-report/` - HTML report (view with `npm run test:report`)
- `results/test-results.json` - JSON results for CI/CD
- Screenshots and videos (on failure only)

## Common Issues

### Tests fail with "Connection refused"
Make sure Docker services are running:
```bash
docker-compose up -d
```

### Tests fail with "Timeout"
Increase timeout in `playwright.config.ts` or wait for application to fully start.

### Database state issues
Reset database:
```bash
docker-compose down -v && docker-compose up -d
```

## CI/CD Integration

Set `CI=true` environment variable to enable:
- Retries on failure
- JSON reporter only
- Stricter test validation

```bash
CI=true npm test
```
