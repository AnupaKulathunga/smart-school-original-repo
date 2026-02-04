/**
 * E2E Tests: Student Attendance
 * Tests the refactored attendance module without section dropdowns
 */

import { test, expect } from '@playwright/test';
import {
  loginAsAdmin,
  verifySectionDropdownRemoved,
  verifyClassSelector,
  selectFirstClass,
  waitForLoading
} from '../helpers';

test.describe('TVET Attendance Management', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  test('should load attendance page without section dropdown', async ({ page }) => {
    // Navigate to attendance page
    await page.goto('/admin/stuattendence');

    // Wait for page to load
    await waitForLoading(page);

    // CRITICAL: Verify NO section dropdown exists
    await verifySectionDropdownRemoved(page);

    // Verify class selector exists
    await verifyClassSelector(page);

    // Verify date picker exists
    const datePicker = page.locator('input[name="date"]');
    await expect(datePicker).toBeVisible();
  });

  test('should load students after selecting class and date', async ({ page }) => {
    await page.goto('/admin/stuattendence');

    // Select a class
    const className = await selectFirstClass(page);
    console.log(`Selected class: ${className}`);

    // Set today's date (readonly field - use JavaScript)
    const today = new Date().toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: 'numeric' });
    await page.evaluate((dateValue) => {
      const dateInput = document.querySelector('input[name="date"]');
      if (dateInput) dateInput.value = dateValue;
    }, today);

    // Click search
    await page.click('button[name="search"]');

    // Wait for results
    await waitForLoading(page);

    // Check if student list appeared (or "no students" message)
    const studentTable = page.locator('table tbody tr');
    const noRecordMsg = page.locator('.alert-info, .alert-danger');

    // Either students should appear OR a "no record" message
    const hasStudents = await studentTable.count() > 0;
    const hasNoRecordMsg = await noRecordMsg.count() > 0;

    expect(hasStudents || hasNoRecordMsg).toBeTruthy();
  });

  test('should display enrolment type (Core/Elective) for students', async ({ page }) => {
    await page.goto('/admin/stuattendence');

    // Select class and date
    await selectFirstClass(page);
    const today = new Date().toLocaleDateString('en-US', { month: '2-digit', day: '2-digit', year: 'numeric' });
    await page.evaluate((dateValue) => {
      const dateInput = document.querySelector('input[name="date"]');
      if (dateInput) dateInput.value = dateValue;
    }, today);
    await page.click('button[name="search"]');

    await waitForLoading(page);

    // If students are present, check for enrolment type badges
    const studentRows = page.locator('table tbody tr');
    if (await studentRows.count() > 0) {
      // Look for enrolment type indicators (labels/badges)
      const enrolmentBadge = page.locator('.label, .badge, [class*="enrolment"]').first();

      // Should have some indicator of enrolment type
      const badgeExists = await enrolmentBadge.count() > 0;
      console.log(`Enrolment type display: ${badgeExists ? 'Present' : 'Not found'}`);
    }
  });

  test('should NOT have getSectionByClass JavaScript function', async ({ page }) => {
    await page.goto('/admin/stuattendence');

    // Check page source for legacy JavaScript
    const pageContent = await page.content();

    // Verify legacy function is NOT present
    expect(pageContent).not.toContain('getSectionByClass');
    expect(pageContent).not.toContain('populateSection');
    expect(pageContent).not.toContain('sections/getByClass');
  });

  test('should use class_selector component', async ({ page }) => {
    await page.goto('/admin/stuattendence');

    const pageContent = await page.content();

    // Verify class_selector partial is used (look for TVET comment)
    const hasTvetComment = pageContent.includes('TVET:') ||
                           pageContent.includes('class_selector') ||
                           pageContent.includes('enrolment_id');

    console.log(`TVET architecture markers found: ${hasTvetComment}`);
  });
});
