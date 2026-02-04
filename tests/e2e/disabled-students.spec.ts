import { test, expect } from '@playwright/test';
import { loginAsAdmin, waitForLoading } from './helpers';

test.describe('Disabled Students List', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  test('should load disabled students page without 500 error', async ({ page }) => {
    await page.goto('/student/disablestudentslist');
    await waitForLoading(page);
    
    // Verify page loads without error
    const pageContent = await page.content();
    expect(pageContent).not.toContain('HTTP ERROR 500');
    expect(pageContent).not.toContain('Fatal error');
    
    // Verify page has correct title
    await expect(page.locator('h1')).toContainText('Student Information');
    
    // Verify TVET class selector exists (single dropdown, no section)
    await expect(page.locator('select[name="class_id"]')).toBeVisible();
    await expect(page.locator('select[name="section_id"]')).toHaveCount(0);
  });

  test('should display disabled students after search', async ({ page }) => {
    await page.goto('/student/disablestudentslist');
    await waitForLoading(page);
    
    // Select first class if available
    const classOptions = await page.locator('select[name="class_id"] option').count();
    if (classOptions > 1) {
      await page.selectOption('select[name="class_id"]', { index: 1 });
      await page.click('button[name="search"][value="search_filter"]');
      
      // Verify results section appears
      await page.waitForTimeout(1000);
      const hasResults = await page.locator('.tab-content').isVisible();
      expect(hasResults).toBeTruthy();
    }
  });

  test('should search by student name', async ({ page }) => {
    await page.goto('/student/disablestudentslist');
    await waitForLoading(page);
    
    // Search by keyword - use visible search field
    const searchField = page.locator('input[name="search_text"]').last();
    await searchField.waitFor({ state: 'visible' });
    await searchField.fill('test');
    await page.click('button[name="search"][value="search_full"]');
    
    // Verify page doesn't crash
    await page.waitForTimeout(1000);
    const pageContent = await page.content();
    expect(pageContent).not.toContain('HTTP ERROR 500');
  });
});
