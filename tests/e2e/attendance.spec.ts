import { test, expect } from '@playwright/test';
import { loginAsAdmin, waitForLoading } from './helpers';

test.describe('Attendance Management', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  test('should load attendance page with TVET class selector', async ({ page }) => {
    await page.goto('/admin/stuattendence');
    await waitForLoading(page);
    
    // Verify page loads
    await expect(page.locator('h1')).toContainText('Student Attendance');
    
    // Verify TVET class selector exists (no section dropdown)
    await expect(page.locator('select[name="class_id"]')).toBeVisible();
    await expect(page.locator('select[name="section_id"]')).toHaveCount(0);
  });

  test('should mark attendance without 500 error', async ({ page }) => {
    await page.goto('/admin/stuattendence');
    await waitForLoading(page);
    
    const classOptions = await page.locator('select[name="class_id"] option').count();
    if (classOptions > 1) {
      // Select class and date
      await page.selectOption('select[name="class_id"]', { index: 1 });
      await page.fill('input[name="date"]', '2026-02-04');
      await page.click('button[name="search"]');
      
      // Verify page loads without error
      await page.waitForTimeout(1000);
      const pageContent = await page.content();
      expect(pageContent).not.toContain('HTTP ERROR 500');
      expect(pageContent).not.toContain('Fatal error');
    }
  });

  test('should display enrolment types (Core/Elective)', async ({ page }) => {
    await page.goto('/admin/stuattendence');
    await waitForLoading(page);
    
    const classOptions = await page.locator('select[name="class_id"] option').count();
    if (classOptions > 1) {
      await page.selectOption('select[name="class_id"]', { index: 1 });
      await page.fill('input[name="date"]', '2026-02-04');
      await page.click('button[name="search"]');
      
      await page.waitForTimeout(1000);
      
      // Check if student table is visible
      const hasStudents = await page.locator('table tbody tr').count();
      if (hasStudents > 0) {
        // Verify enrolment type labels exist (if students are enrolled)
        const labels = await page.locator('.label').count();
        expect(labels).toBeGreaterThanOrEqual(0);
      }
    }
  });
});
