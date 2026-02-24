/**
 * Student Details — Admin panel view/edit tests
 */
import { test, expect, Page } from '@playwright/test';

const BASE_URL = 'https://northlinkcollegelms.smartgov.co.za';
const ADMIN_EMAIL = 'Blackrawone@gmail.com';
const ADMIN_PASSWORD = 'ZEUm^9FUpduK^y5WRxM4';

const PHP_ERROR_PATTERNS = [
  /Fatal error/i, /Parse error/i, /Warning:.*on line/i, /Notice:.*on line/i,
  /A PHP Error was encountered/i, /An uncaught Exception was encountered/i,
  /A Database Error Occurred/i,
];

async function checkForPhpErrors(page: Page): Promise<string[]> {
  const bodyText = await page.locator('body').textContent().catch(() => '');
  const errors: string[] = [];
  for (const pattern of PHP_ERROR_PATTERNS) {
    if (pattern.test(bodyText || '')) {
      errors.push(`PHP error: matched "${pattern.source}"`);
    }
  }
  return errors;
}

async function adminLogin(page: Page) {
  await page.goto(`${BASE_URL}/site/login`, { waitUntil: 'domcontentloaded' });
  await page.fill('input[name="username"]', ADMIN_EMAIL);
  await page.fill('input[name="password"]', ADMIN_PASSWORD);
  await page.click('button[type="submit"], input[type="submit"]');
  await page.waitForURL(/\/(admin|dashboard)/, { timeout: 15000 });
}

test.describe('Student Details — Admin Panel', () => {

  test('Student view page loads without errors', async ({ page }) => {
    await adminLogin(page);
    const response = await page.goto(`${BASE_URL}/student/view/2`, { waitUntil: 'domcontentloaded' });
    expect(response?.status()).toBeLessThan(500);
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

  test('Student edit page loads without errors', async ({ page }) => {
    await adminLogin(page);
    const response = await page.goto(`${BASE_URL}/student/edit/2`, { waitUntil: 'domcontentloaded' });
    expect(response?.status()).toBeLessThan(500);
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

});
