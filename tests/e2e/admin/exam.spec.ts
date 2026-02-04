/**
 * E2E Tests: Exam Management
 * Tests the refactored exam module without section dropdowns
 */

import { test, expect } from '@playwright/test';
import {
  loginAsAdmin,
  verifySectionDropdownRemoved,
  verifyClassSelector,
  selectFirstClass,
  waitForLoading
} from '../helpers';

test.describe('TVET Exam Management', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  test('should load exam schedule page without section dropdown', async ({ page }) => {
    await page.goto('/admin/examschedule');
    await waitForLoading(page);

    // CRITICAL: Verify NO section dropdown
    await verifySectionDropdownRemoved(page);

    // Verify class selector exists
    await verifyClassSelector(page);
  });

  test('should load mark entry page without section dropdown', async ({ page }) => {
    await page.goto('/admin/mark');
    await waitForLoading(page);

    // Verify NO section dropdown
    await verifySectionDropdownRemoved(page);

    // Verify exam dropdown exists
    const examDropdown = page.locator('select[name="exam_id"]');
    await expect(examDropdown).toBeVisible();
  });

  test('should load online exam page without section dropdown', async ({ page }) => {
    await page.goto('/admin/onlineexam');
    await waitForLoading(page);

    // Verify page loaded
    await expect(page.locator('.box-title')).toContainText('online', { ignoreCase: true });

    // Check page source for legacy section code
    const pageContent = await page.content();
    expect(pageContent).not.toContain('getSectionByClass');
  });

  test('should assign online exam without section selection', async ({ page }) => {
    await page.goto('/admin/onlineexam');
    await waitForLoading(page);

    // Look for any "assign" link or button
    const assignBtn = page.locator('a[href*="assign"], button:has-text("Assign")').first();

    if (await assignBtn.count() > 0) {
      await assignBtn.click();
      await waitForLoading(page);

      // On assign page, verify NO section dropdown
      await verifySectionDropdownRemoved(page);
    }
  });
});
