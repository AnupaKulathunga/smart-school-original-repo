/**
 * Student Dashboard Fix Verification
 * Tests that the student dashboard loads without PHP errors and key widgets render.
 */
import { test, expect, Page } from '@playwright/test';

const BASE_URL = 'https://northlinkcollegelms.smartgov.co.za';
const STUDENT_USERNAME = '210002840';
const STUDENT_PASSWORD = 'student123';

const PHP_ERROR_PATTERNS = [
  /Fatal error/i,
  /Parse error/i,
  /Warning:.*on line/i,
  /Notice:.*on line/i,
  /A PHP Error was encountered/i,
  /An uncaught Exception was encountered/i,
  /A Database Error Occurred/i,
  /Call to a member function.*on bool/i,
  /Call to a member function.*on null/i,
  /Undefined offset/i,
  /Undefined variable/i,
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

async function studentLogin(page: Page) {
  await page.goto(`${BASE_URL}/site/userlogin`, { waitUntil: 'domcontentloaded' });
  await page.fill('input[name="username"]', STUDENT_USERNAME);
  await page.fill('input[name="password"]', STUDENT_PASSWORD);
  await page.click('button[type="submit"], input[type="submit"]');
  await page.waitForURL(/\/(user|site)\//, { timeout: 15000 });
}

async function ensureStudentHasClass(page: Page) {
  if (page.url().includes('/user/user/choose')) {
    const radioBtn = page.locator('input[name="clschg"]').first();
    await radioBtn.check();
    await page.click('input[type="submit"]');
    await page.waitForURL(/\/user\//, { timeout: 15000 });
  }
}

test.describe('Student Dashboard', () => {

  test('Dashboard loads without PHP errors', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);
    await page.goto(`${BASE_URL}/user/user/dashboard`, { waitUntil: 'domcontentloaded' });
    if (page.url().includes('/user/user/choose')) {
      await ensureStudentHasClass(page);
      await page.goto(`${BASE_URL}/user/user/dashboard`, { waitUntil: 'domcontentloaded' });
    }
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

  test('Dashboard contains key widgets', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);
    await page.goto(`${BASE_URL}/user/user/dashboard`, { waitUntil: 'domcontentloaded' });
    if (page.url().includes('/user/user/choose')) {
      await ensureStudentHasClass(page);
      await page.goto(`${BASE_URL}/user/user/dashboard`, { waitUntil: 'domcontentloaded' });
    }
    // Dashboard should have some recognizable content
    const bodyText = await page.locator('body').textContent();
    // Check for at least one common dashboard element
    const hasContent = bodyText?.includes('Notice Board') ||
                       bodyText?.includes('Attendance') ||
                       bodyText?.includes('Assignment') ||
                       bodyText?.includes('Timetable') ||
                       bodyText?.includes('Dashboard');
    expect(hasContent).toBeTruthy();
  });

  test('Dashboard page size is reasonable (not error page)', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);
    const response = await page.goto(`${BASE_URL}/user/user/dashboard`, { waitUntil: 'domcontentloaded' });
    if (page.url().includes('/user/user/choose')) {
      await ensureStudentHasClass(page);
      const resp2 = await page.goto(`${BASE_URL}/user/user/dashboard`, { waitUntil: 'domcontentloaded' });
      expect(resp2?.status()).toBe(200);
    } else {
      expect(response?.status()).toBe(200);
    }
    // A real dashboard should be >10KB (error pages are typically <5KB)
    const content = await page.content();
    expect(content.length).toBeGreaterThan(10000);
  });
});
