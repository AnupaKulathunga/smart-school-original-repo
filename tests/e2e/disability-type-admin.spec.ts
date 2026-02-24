/**
 * Disability Types — Admin panel: create + list display
 */
import { test, expect, Page } from '@playwright/test';

const BASE_URL = 'https://northlinkcollegelms.smartgov.co.za';
const ADMIN_EMAIL = 'Blackrawone@gmail.com';
const ADMIN_PASSWORD = 'ZEUm^9FUpduK^y5WRxM4';

async function adminLogin(page: Page) {
  await page.goto(`${BASE_URL}/site/login`, { waitUntil: 'domcontentloaded' });
  await page.fill('input[name="username"]', ADMIN_EMAIL);
  await page.fill('input[name="password"]', ADMIN_PASSWORD);
  await page.click('button[type="submit"], input[type="submit"]');
  await page.waitForURL(/\/(admin|dashboard)/, { timeout: 15000 });
}

test.describe('Disability Types — Admin Panel', () => {

  test('Disability type list shows existing records', async ({ page }) => {
    await adminLogin(page);
    const response = await page.goto(`${BASE_URL}/disabilitytype`, { waitUntil: 'domcontentloaded' });
    expect(response?.status()).toBeLessThan(500);

    // Should show at least 1 record (Visual Impairment we just created)
    const rows = page.locator('table.example tbody tr');
    const count = await rows.count();
    expect(count).toBeGreaterThanOrEqual(1);

    // First row should contain the disability type name
    const firstRow = await rows.first().textContent();
    expect(firstRow).toContain('Visual Impairment');
  });

});
