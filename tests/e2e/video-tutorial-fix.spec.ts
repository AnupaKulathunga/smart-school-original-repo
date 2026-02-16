/**
 * Video Tutorial Fix Verification
 * Tests that video tutorial pages load for admin and student roles,
 * and AJAX endpoints return valid JSON.
 */
import { test, expect, Page } from '@playwright/test';

const BASE_URL = 'https://northlinkcollegelms.smartgov.co.za';
const ADMIN_USERNAME = 'Blackrawone@gmail.com';
const ADMIN_PASSWORD = 'ZEUm^9FUpduK^y5WRxM4';
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
  await page.fill('input[name="username"]', ADMIN_USERNAME);
  await page.fill('input[name="password"]', ADMIN_PASSWORD);
  await page.click('button[type="submit"], input[type="submit"]');
  await page.waitForURL('**/admin/**', { timeout: 15000 });
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

// =============================
// ADMIN TESTS
// =============================
test.describe('Admin Video Tutorial', () => {

  test('Video tutorial list page loads without errors', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/video_tutorial`, { waitUntil: 'domcontentloaded' });
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
    // Should have the video tutorial list title
    const title = await page.locator('body').textContent();
    expect(title).toContain('Video Tutorial');
  });

  test('Admin getPage AJAX returns valid JSON', async ({ page }) => {
    await adminLogin(page);
    const response = await page.request.get(`${BASE_URL}/admin/video_tutorial/getPage/1`);
    expect(response.status()).toBe(200);
    const body = await response.text();
    expect(body).not.toContain('A PHP Error was encountered');
    expect(body).not.toContain('A Database Error Occurred');
    const parsed = JSON.parse(body);
    expect(parsed).toHaveProperty('result_status');
    expect(parsed).toHaveProperty('result');
  });

  test('Admin search validation AJAX works', async ({ page }) => {
    await adminLogin(page);
    const response = await page.request.post(`${BASE_URL}/admin/video_tutorial/searchvalidation`, {
      form: { search_class_id: '1', search_type: 'search_filter' },
    });
    expect(response.status()).toBe(200);
    const body = await response.text();
    expect(body).not.toContain('A PHP Error was encountered');
    const parsed = JSON.parse(body);
    expect(parsed.status).toBe(1);
  });
});

// =============================
// STUDENT TESTS
// =============================
test.describe('Student Video Tutorial', () => {

  test('Student video tutorial page loads without errors', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);
    await page.goto(`${BASE_URL}/user/video_tutorial`, { waitUntil: 'domcontentloaded' });
    if (page.url().includes('/user/user/choose')) {
      await ensureStudentHasClass(page);
      await page.goto(`${BASE_URL}/user/video_tutorial`, { waitUntil: 'domcontentloaded' });
    }
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

  test('Student getPage AJAX returns valid JSON', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);
    const response = await page.request.get(`${BASE_URL}/user/video_tutorial/getPage/1?class_id=1`);
    expect(response.status()).toBe(200);
    const body = await response.text();
    expect(body).not.toContain('A PHP Error was encountered');
    expect(body).not.toContain('A Database Error Occurred');
    const parsed = JSON.parse(body);
    expect(parsed).toHaveProperty('result_status');
    expect(parsed).toHaveProperty('result');
    // result_status 0 = no records (expected since table is empty), still valid
    expect([0, 1]).toContain(parsed.result_status);
  });
});
