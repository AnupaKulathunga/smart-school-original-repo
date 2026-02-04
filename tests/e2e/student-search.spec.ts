import { test, expect } from '@playwright/test';
import { loginAsAdmin, waitForLoading } from './helpers';

test.describe('Student Search', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  test('should load student search page with TVET class selector', async ({ page }) => {
    await page.goto('/student/search');
    await waitForLoading(page);
    
    // Verify page loads
    await expect(page.locator('h1')).toContainText('Student Information');
    
    // Verify TVET class selector exists (no section dropdown)
    await expect(page.locator('select[name="class_id"]')).toBeVisible();
    await expect(page.locator('select[name="section_id"]')).toHaveCount(0);
    
    // Verify class dropdown shows TVET format: "Subject - Level (Cohort)"
    const firstOption = await page.locator('select[name="class_id"] option').nth(1).textContent();
    if (firstOption && firstOption !== 'Select') {
      expect(firstOption).toMatch(/.*-.*\(.*\)/); // Format: Subject - Level (Cohort)
    }
  });

  test('should search students by class without 500 error', async ({ page }) => {
    await page.goto('/student/search');
    await waitForLoading(page);
    
    const classOptions = await page.locator('select[name="class_id"] option').count();
    if (classOptions > 1) {
      // Select first class
      await page.selectOption('select[name="class_id"]', { index: 1 });
      await page.click('button[name="search"]');
      
      // Verify no error
      const pageContent = await page.content();
      expect(pageContent).not.toContain('HTTP ERROR 500');
      expect(pageContent).not.toContain('Fatal error');
    }
  });

  test('should search students by keyword', async ({ page }) => {
    await page.goto('/student/search');
    await waitForLoading(page);
    
    // Search by student name
    await page.fill('input[name="search_text"]', 'student');
    await page.click('button[name="search"][value="search_full"]');
    
    // Verify page loads without error
    await page.waitForTimeout(1000);
    const pageContent = await page.content();
    expect(pageContent).not.toContain('HTTP ERROR 500');
  });
});
