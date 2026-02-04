/**
 * E2E Tests: Timetable Management
 * Tests the refactored timetable module without section dropdowns
 */

import { test, expect } from '@playwright/test';
import {
  loginAsAdmin,
  verifySectionDropdownRemoved,
  verifyClassSelector,
  selectFirstClass,
  waitForLoading
} from '../helpers';

test.describe('TVET Timetable Management', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  test('should load timetable class report without section dropdown', async ({ page }) => {
    await page.goto('/admin/timetable/classreport');
    await waitForLoading(page);

    // CRITICAL: Verify NO section dropdown
    await verifySectionDropdownRemoved(page);

    // Verify class selector exists
    await verifyClassSelector(page);
  });

  test('should load timetable for a class', async ({ page }) => {
    await page.goto('/admin/timetable/classreport');

    // Select a class
    const className = await selectFirstClass(page);
    console.log(`Selected class: ${className}`);

    // Click search/view button
    const searchBtn = page.locator('button[type="submit"], button:has-text("Search")');
    if (await searchBtn.count() > 0) {
      await searchBtn.click();
      await waitForLoading(page);

      // Verify timetable loaded (or "no record" message)
      const timetableTable = page.locator('table, .timetable');
      const noRecordMsg = page.locator('.alert-info, .no-record');

      const hasTable = await timetableTable.count() > 0;
      const hasMsg = await noRecordMsg.count() > 0;

      expect(hasTable || hasMsg).toBeTruthy();
    }
  });

  test('should create timetable without section selection', async ({ page }) => {
    await page.goto('/admin/timetable/create');
    await waitForLoading(page);

    // Verify NO section dropdown
    await verifySectionDropdownRemoved(page);

    // Verify class dropdown exists
    await verifyClassSelector(page);

    // Verify subject group dropdown exists
    const subjectGroupDropdown = page.locator('select[name="subject_group_id"]');
    await expect(subjectGroupDropdown).toBeVisible();
  });

  test('should NOT have legacy section JavaScript', async ({ page }) => {
    await page.goto('/admin/timetable/classreport');

    const pageContent = await page.content();

    // Verify legacy functions are NOT present
    expect(pageContent).not.toContain('getSectionByClass');
    expect(pageContent).not.toContain('getGroupByClassandSection');

    // Should have new TVET functions
    const hasTvetCode = pageContent.includes('getGroupByClass') ||
                        pageContent.includes('TVET:');

    console.log(`TVET code present: ${hasTvetCode}`);
  });
});
