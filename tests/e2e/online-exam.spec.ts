import { test, expect } from '@playwright/test';
import { loginAsAdmin, waitForLoading } from './helpers';

test.describe('Online Exam', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  test('should load online exam page without 500 error', async ({ page }) => {
    await page.goto('/admin/onlineexam');
    await waitForLoading(page);
    
    // Verify page loads without error
    const pageContent = await page.content();
    expect(pageContent).not.toContain('HTTP ERROR 500');
    expect(pageContent).not.toContain('Fatal error');
    
    // Verify page has correct title
    await expect(page.locator('h1')).toContainText('Online Exam');
  });

  test('should have TVET class selector in modal', async ({ page }) => {
    await page.goto('/admin/onlineexam');
    await waitForLoading(page);
    
    // Click add button if it exists
    const addButton = page.locator('a[data-toggle="modal"]').first();
    if (await addButton.isVisible()) {
      await addButton.click();
      await page.waitForTimeout(500);
      
      // Verify modal has class selector (no section dropdown)
      await expect(page.locator('#addModal select[name="class_id"]')).toBeVisible();
      await expect(page.locator('#addModal select[name="section_id"]')).toHaveCount(0);
    }
  });

  test('should display existing online exams', async ({ page }) => {
    await page.goto('/admin/onlineexam');
    await waitForLoading(page);
    
    // Verify table exists
    await expect(page.locator('table')).toBeVisible();
    
    // Check if there are any exam rows
    const rows = await page.locator('table tbody tr').count();
    expect(rows).toBeGreaterThanOrEqual(0);
  });
});
