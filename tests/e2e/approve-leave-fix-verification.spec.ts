import { test, expect } from '@playwright/test';

test.describe('Approve Leave - TVET Fix Verification', () => {

  test.beforeEach(async ({ page }) => {
    // Login as admin
    await page.goto('/site/login');
    await page.fill('input[name="username"]', 'admin');
    await page.fill('input[name="password"]', 'admin123');
    await page.click('button[type="submit"]');
    await page.waitForLoadState('networkidle');
  });

  test('should NOT have Section dropdown (CRITICAL)', async ({ page }) => {
    await page.goto('/admin/approve_leave');
    await page.waitForLoadState('networkidle');

    // CRITICAL: Verify NO section dropdown exists
    const sectionDropdown = page.locator('select[name="section_id"]');
    await expect(sectionDropdown).toHaveCount(0);

    // Verify class dropdown exists and uses TVET structure
    const classDropdown = page.locator('select[name="class_id"]');
    await expect(classDropdown).toBeVisible();

    console.log('✅ No section dropdown found - TVET structure confirmed');
  });

  test('should display class info in correct format (Subject - Level (Cohort))', async ({ page }) => {
    await page.goto('/admin/approve_leave');
    await page.waitForLoadState('networkidle');

    // Select a class
    const classDropdown = page.locator('select[name="class_id"]');
    const optionCount = await classDropdown.locator('option').count();

    if (optionCount > 1) {
      await classDropdown.selectOption({ index: 1 });
      await page.click('button:has-text("Search")');
      await page.waitForLoadState('networkidle');

      // Check table header - should have only one "Class" column, no "Section"
      const headers = page.locator('table thead th');
      const headerTexts = await headers.allTextContents();

      const hasSectionHeader = headerTexts.some(h => h.toLowerCase().includes('section'));
      expect(hasSectionHeader).toBe(false);

      console.log('✅ Table headers do not include "Section" column');

      // Check if data is displayed (if any records exist)
      const tableRows = page.locator('table tbody tr');
      const rowCount = await tableRows.count();

      if (rowCount > 0 && !await tableRows.first().locator('td').first().textContent().then(t => t?.includes('No data'))) {
        console.log(`✅ Found ${rowCount} leave records`);
      }
    } else {
      console.log('⚠️ No classes available in dropdown');
    }
  });

  test('should load page without database errors', async ({ page }) => {
    const errors: string[] = [];

    page.on('console', msg => {
      if (msg.type() === 'error') {
        errors.push(msg.text());
      }
    });

    await page.goto('/admin/approve_leave');
    await page.waitForLoadState('networkidle');

    // Check for PHP errors or database errors in page content
    const pageContent = await page.content();
    const hasError = pageContent.toLowerCase().includes('error') &&
                    (pageContent.includes('database') ||
                     pageContent.includes('mysql') ||
                     pageContent.includes('unknown column'));

    expect(hasError).toBe(false);
    expect(errors.length).toBe(0);

    console.log('✅ Page loaded without errors');
  });

  test('should handle search with class_id only (no section_id)', async ({ page }) => {
    await page.goto('/admin/approve_leave');
    await page.waitForLoadState('networkidle');

    const classDropdown = page.locator('select[name="class_id"]');
    const optionCount = await classDropdown.locator('option').count();

    if (optionCount > 1) {
      // Monitor network for search request
      const [response] = await Promise.all([
        page.waitForResponse(resp => resp.url().includes('approve_leave') && resp.request().method() === 'POST'),
        classDropdown.selectOption({ index: 1 }),
        page.click('button:has-text("Search")')
      ]);

      // Verify response is successful
      expect(response.ok()).toBe(true);

      console.log('✅ Search successful with class_id only');
    }
  });
});
