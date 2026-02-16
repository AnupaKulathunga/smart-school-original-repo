/**
 * Timetable Fix Verification — All Roles
 * Tests timetable pages and AJAX endpoints for admin, teacher, and student roles.
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
  // Student may land on choose page or dashboard
  await page.waitForURL(/\/(user|site)\//, { timeout: 15000 });
}

async function ensureStudentHasClass(page: Page) {
  // If we're on the choose page, select a class
  if (page.url().includes('/user/user/choose')) {
    const radioBtn = page.locator('input[name="clschg"]').first();
    await radioBtn.check();
    await page.click('input[type="submit"]');
    await page.waitForURL(/\/user\//, { timeout: 15000 });
  }
}

// =============================
// ADMIN ROLE TESTS
// =============================
test.describe('Admin Timetable', () => {

  test('Timetable list page loads without errors', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/timetable`, { waitUntil: 'domcontentloaded' });
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
    // Should have a class dropdown
    await expect(page.locator('select[name="class_id"], select#class_id')).toBeVisible({ timeout: 10000 });
  });

  test('Timetable view with class selection works', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/timetable`, { waitUntil: 'domcontentloaded' });
    // Select a class and submit the form
    const classSelect = page.locator('select[name="class_id"], select#class_id');
    await classSelect.selectOption({ index: 1 }); // Pick first class
    await page.click('button[type="submit"], input[type="submit"]');
    await page.waitForLoadState('domcontentloaded');
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

  test('Timetable create page loads without errors', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/timetable/create`, { waitUntil: 'domcontentloaded' });
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
    await expect(page.locator('select[name="class_id"], select#class_id')).toBeVisible({ timeout: 10000 });
  });

  test('My Timetable (teacher view) loads without errors', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/timetable/mytimetable`, { waitUntil: 'domcontentloaded' });
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

  test('Class Report page loads without errors', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/timetable/classreport`, { waitUntil: 'domcontentloaded' });
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

  test('getGroupByClass AJAX returns valid JSON', async ({ page }) => {
    await adminLogin(page);
    const response = await page.request.post(`${BASE_URL}/admin/subjectgroup/getGroupByClass`, {
      form: { class_id: '1' },
    });
    expect(response.status()).toBe(200);
    const body = await response.text();
    expect(body).not.toContain('A PHP Error was encountered');
    expect(body).not.toContain('A Database Error Occurred');
    const parsed = JSON.parse(body);
    expect(typeof parsed).not.toBe('string');
  });

  test('getBydategroupclasssection AJAX returns valid JSON', async ({ page }) => {
    await adminLogin(page);
    const response = await page.request.post(`${BASE_URL}/admin/timetable/getBydategroupclasssection`, {
      form: { day: 'Monday', class_id: '1', subject_group_id: '1' },
    });
    expect(response.status()).toBe(200);
    const body = await response.text();
    expect(body).not.toContain('A PHP Error was encountered');
    const parsed = JSON.parse(body);
    expect(parsed).toHaveProperty('staff');
  });

  test('getteachertimetable AJAX returns valid JSON', async ({ page }) => {
    await adminLogin(page);
    const response = await page.request.post(`${BASE_URL}/admin/timetable/getteachertimetable`, {
      form: { teacher: '1' },
    });
    expect(response.status()).toBe(200);
    const body = await response.text();
    expect(body).not.toContain('A PHP Error was encountered');
    const parsed = JSON.parse(body);
    expect(parsed).toHaveProperty('status');
  });

  test('printclasstimetable AJAX returns valid JSON', async ({ page }) => {
    await adminLogin(page);
    const response = await page.request.post(`${BASE_URL}/admin/timetable/printclasstimetable`, {
      form: { class_id: '1' },
    });
    expect(response.status()).toBe(200);
    const body = await response.text();
    expect(body).not.toContain('A PHP Error was encountered');
    const parsed = JSON.parse(body);
    expect(parsed.status).toBe('1');
    expect(parsed).toHaveProperty('page');
  });

  test('printteachertimetable AJAX returns valid JSON', async ({ page }) => {
    await adminLogin(page);
    const response = await page.request.post(`${BASE_URL}/admin/timetable/printteachertimetable`, {
      form: { staff_id: '1' },
    });
    expect(response.status()).toBe(200);
    const body = await response.text();
    expect(body).not.toContain('A PHP Error was encountered');
    const parsed = JSON.parse(body);
    expect(parsed.status).toBe('1');
    expect(parsed).toHaveProperty('page');
  });
});

// =============================
// STUDENT ROLE TESTS
// =============================
test.describe('Student Timetable', () => {

  test('Student timetable page loads without errors', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);
    await page.goto(`${BASE_URL}/user/timetable`, { waitUntil: 'domcontentloaded' });
    // May redirect to choose if no class set
    if (page.url().includes('/user/user/choose')) {
      await ensureStudentHasClass(page);
      await page.goto(`${BASE_URL}/user/timetable`, { waitUntil: 'domcontentloaded' });
    }
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

  test('TVET Portal timetable page loads without errors', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);
    await page.goto(`${BASE_URL}/user/tvetportal/my_timetable`, { waitUntil: 'domcontentloaded' });
    if (page.url().includes('/user/user/choose')) {
      await ensureStudentHasClass(page);
      await page.goto(`${BASE_URL}/user/tvetportal/my_timetable`, { waitUntil: 'domcontentloaded' });
    }
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

  test('Student print timetable AJAX works', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);
    const response = await page.request.post(`${BASE_URL}/user/timetable/printclasstimetable`);
    expect(response.status()).toBe(200);
    const body = await response.text();
    expect(body).not.toContain('A PHP Error was encountered');
    const parsed = JSON.parse(body);
    expect(parsed.status).toBe('1');
    expect(parsed).toHaveProperty('page');
  });
});

// =============================
// SUBJECT GROUP (supporting timetable)
// =============================
test.describe('Subject Group for Timetable', () => {

  test('Subject Group list page loads without errors', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/subjectgroup`, { waitUntil: 'domcontentloaded' });
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });
});
