import { test, expect } from '@playwright/test';
import { loginAsAdmin, waitForLoading } from './helpers';

test.describe('Approve Leave', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  test('should load approve leave page with TVET class selector', async ({ page }) => {
    await page.goto('/admin/approve_leave');
    await waitForLoading(page);
    
    // Verify page loads
    await expect(page.locator('h1')).toContainText('Approve Leave');
    
    // Verify TVET class selector exists
    await expect(page.locator('select[name="class_id"]')).toBeVisible();
    
    // Verify class dropdown has options
    const options = await page.locator('select[name="class_id"] option').count();
    expect(options).toBeGreaterThan(0); // At least "Select" option
  });

  test('should display class options in TVET format', async ({ page }) => {
    await page.goto('/admin/approve_leave');
    await waitForLoading(page);
    
    const classOptions = await page.locator('select[name="class_id"] option').count();
    if (classOptions > 1) {
      // Get second option (first is "Select")
      const optionText = await page.locator('select[name="class_id"] option').nth(1).textContent();
      
      // Verify TVET format: "Subject - Level (Cohort)"
      if (optionText && optionText !== 'Select') {
        expect(optionText).toMatch(/.*-.*\(.*\)/);
      }
    }
  });

  test('should search leave requests without error', async ({ page }) => {
    await page.goto('/admin/approve_leave');
    await waitForLoading(page);
    
    const classOptions = await page.locator('select[name="class_id"] option').count();
    if (classOptions > 1) {
      // Select class
      await page.selectOption('select[name="class_id"]', { index: 1 });
      await page.click('button[name="search"]');
      
      // Verify no error
      await page.waitForTimeout(1000);
      const pageContent = await page.content();
      expect(pageContent).not.toContain('HTTP ERROR 500');
      expect(pageContent).not.toContain('Fatal error');
    }
  });
});
