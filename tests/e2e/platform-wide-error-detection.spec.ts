import { test, expect } from '@playwright/test';
import { loginAsAdmin } from './helpers';

/**
 * Platform-Wide Error Detection Test Suite
 *
 * Systematically tests all admin pages that use class/section selectors
 * to detect database errors related to legacy table structures.
 *
 * This test suite was created to detect errors like:
 * - "Unknown column 'student_attendance_schedules.class_id' in 'on clause'"
 * - Error Number: 1054
 * - Any database schema mismatch issues
 */

test.describe('Platform-Wide Database Error Detection', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  // ===================================================================
  // ATTENDANCE MODULE (Priority 1)
  // ===================================================================

  test.describe('Attendance Module', () => {

    test('Student Attendance page should load without errors', async ({ page }) => {
      await page.goto('/admin/stuattendence');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
      expect(bodyText).not.toContain('Error Number: 1054');

      // Verify page loaded correctly
      expect(await page.locator('select[name="class_id"]').count()).toBeGreaterThan(0);
    });

    test('Approve Leave page should load without errors', async ({ page }) => {
      await page.goto('/admin/stuattendence/approveleave');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Attendance By Date page should load without errors', async ({ page }) => {
      await page.goto('/admin/stuattendence/reportbydate');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Subject Attendance page should load without errors', async ({ page }) => {
      await page.goto('/admin/subjectattendence');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });
  });

  // ===================================================================
  // HOMEWORK MODULE (Priority 1)
  // ===================================================================

  test.describe('Homework Module', () => {

    test('Homework List page should load without errors', async ({ page }) => {
      await page.goto('/admin/homework');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
      expect(bodyText).not.toContain('section_id');
    });

    test('Add Homework page should load without errors', async ({ page }) => {
      await page.goto('/admin/homework/add');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Homework Evaluation page should load without errors', async ({ page }) => {
      await page.goto('/admin/homework/evaluation');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });
  });

  // ===================================================================
  // EXAMINATION MODULE (Priority 1)
  // ===================================================================

  test.describe('Examination Module', () => {

    test('Exam Schedule page should load without errors', async ({ page }) => {
      await page.goto('/admin/examschedule');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Exam Groups page should load without errors', async ({ page }) => {
      await page.goto('/admin/examgroup');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Marks Entry page should load without errors', async ({ page }) => {
      await page.goto('/admin/mark');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Online Exam page should load without errors', async ({ page }) => {
      await page.goto('/admin/onlineexam');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Online Exam Assign page should load without errors', async ({ page }) => {
      await page.goto('/admin/onlineexam/assign');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });
  });

  // ===================================================================
  // FEE MODULE (Priority 2)
  // ===================================================================

  test.describe('Fee Module', () => {

    test('Fee Master page should load without errors', async ({ page }) => {
      await page.goto('/admin/feemaster');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Fee Collection page should load without errors', async ({ page }) => {
      await page.goto('/admin/studentfee');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Fee Discount page should load without errors', async ({ page }) => {
      await page.goto('/admin/feediscount');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Transport Fee page should load without errors', async ({ page }) => {
      await page.goto('/admin/route');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });
  });

  // ===================================================================
  // CONTENT MODULE (Priority 1)
  // ===================================================================

  test.describe('Content Module', () => {

    test('Upload Content page should load without errors', async ({ page }) => {
      await page.goto('/admin/content');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Content List page should load without errors', async ({ page }) => {
      await page.goto('/admin/content/assignment');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });
  });

  // ===================================================================
  // ACADEMIC MANAGEMENT MODULE (Priority 3)
  // ===================================================================

  test.describe('Academic Management Module', () => {

    test('Lesson Plan page should load without errors', async ({ page }) => {
      await page.goto('/admin/lessonplan');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Timetable page should load without errors', async ({ page }) => {
      await page.goto('/admin/timetable');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Conference page should load without errors', async ({ page }) => {
      await page.goto('/admin/conference');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Certificate Generation page should load without errors', async ({ page }) => {
      await page.goto('/admin/certificate');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });
  });

  // ===================================================================
  // STUDENT MODULE
  // ===================================================================

  test.describe('Student Module', () => {

    test('Student List page should load without errors', async ({ page }) => {
      await page.goto('/admin/student/search');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Student Admission page should load without errors', async ({ page }) => {
      await page.goto('/admin/student/create');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Student Transfer page should load without errors', async ({ page }) => {
      await page.goto('/admin/stdtransfer');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });
  });

  // ===================================================================
  // REPORTS MODULE
  // ===================================================================

  test.describe('Reports Module', () => {

    test('Student Report page should load without errors', async ({ page }) => {
      await page.goto('/admin/report');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Attendance Report page should load without errors', async ({ page }) => {
      await page.goto('/admin/stuattendence/attendencereport');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });

    test('Fee Collection Report page should load without errors', async ({ page }) => {
      await page.goto('/admin/studentfee/reportbyname');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });
  });

  // ===================================================================
  // INTEGRATION TESTS - Test with actual data
  // ===================================================================

  test.describe('Integration Tests with Data Selection', () => {

    test('Should be able to select class and load students without error', async ({ page }) => {
      await page.goto('/admin/stuattendence');
      await page.waitForLoadState('networkidle');

      // Select first class
      const classDropdown = page.locator('select[name="class_id"]');
      await classDropdown.selectOption({ index: 1 });

      // Fill date using JavaScript (datepicker is readonly)
      await page.locator('input[name="date"]').evaluate((el) => {
        el.value = '02/04/2026';
        el.dispatchEvent(new Event('change', { bubbles: true }));
      });

      // Click search
      await page.locator('button:has-text("Search")').click();
      await page.waitForLoadState('networkidle');

      // Check for errors
      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
      expect(bodyText).not.toContain('Error Number: 1054');
    });

    test('Should be able to view exam schedule without error', async ({ page }) => {
      await page.goto('/admin/examschedule');
      await page.waitForLoadState('networkidle');

      // Try to create exam schedule
      const hasCreateButton = await page.locator('a:has-text("Add Exam")').count();
      if (hasCreateButton > 0) {
        await page.locator('a:has-text("Add Exam")').first().click();
        await page.waitForLoadState('networkidle');

        const bodyText = await page.textContent('body');
        expect(bodyText).not.toContain('A Database Error Occurred');
        expect(bodyText).not.toContain('Unknown column');
      }
    });

    test('Should be able to view timetable without error', async ({ page }) => {
      await page.goto('/admin/timetable/create');
      await page.waitForLoadState('networkidle');

      const bodyText = await page.textContent('body');
      expect(bodyText).not.toContain('A Database Error Occurred');
      expect(bodyText).not.toContain('Unknown column');
    });
  });
});
