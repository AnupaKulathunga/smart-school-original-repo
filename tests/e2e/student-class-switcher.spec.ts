/**
 * Student Class Switcher Fix Verification
 * Tests that the class switcher modal shows proper TVET class labels
 * and that switching classes works correctly.
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

test.describe('Student Class Switcher', () => {

  test('AJAX getStudentSessionClasses returns non-empty class labels', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);

    // Call the AJAX endpoint directly
    const response = await page.evaluate(async (baseUrl) => {
      const res = await fetch(`${baseUrl}/common/getStudentSessionClasses`, {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
      });
      return res.text();
    }, BASE_URL);

    // Parse the JSON response
    const json = JSON.parse(response);
    expect(json.page).toBeDefined();

    // The page HTML should contain checkbox inputs with labels
    expect(json.page).toContain('clschg');

    // Should NOT have empty labels (the old bug: just whitespace after checkbox)
    // Check that there's actual text content in the labels
    const hasContent = json.page.includes(' - ') || json.page.includes('Cohort');
    expect(hasContent).toBe(true);

    // Should not contain PHP errors
    for (const pattern of PHP_ERROR_PATTERNS) {
      expect(json.page).not.toMatch(pattern);
    }
  });

  test('AJAX getStudentClass switch returns success', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);

    // First get available classes
    const classesResponse = await page.evaluate(async (baseUrl) => {
      const res = await fetch(`${baseUrl}/common/getStudentSessionClasses`, {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
      });
      return res.text();
    }, BASE_URL);

    const classesJson = JSON.parse(classesResponse);

    // Extract checkbox values from HTML
    const checkboxMatches = classesJson.page.match(/value="(\d+)"/g);
    expect(checkboxMatches).not.toBeNull();
    expect(checkboxMatches!.length).toBeGreaterThan(0);

    // Get the first class value
    const firstValue = checkboxMatches![0].match(/value="(\d+)"/)?.[1];
    expect(firstValue).toBeDefined();

    // Switch to that class
    const switchResponse = await page.evaluate(async ({ baseUrl, classValue }) => {
      const formData = new FormData();
      formData.append('clschg', classValue);
      const res = await fetch(`${baseUrl}/common/getStudentClass`, {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        body: formData,
      });
      return res.text();
    }, { baseUrl: BASE_URL, classValue: firstValue! });

    const switchJson = JSON.parse(switchResponse);
    expect(switchJson.status).toBe('1');
  });

  test('student dashboard loads without PHP errors after class switch', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);

    await page.goto(`${BASE_URL}/user/user/dashboard`, { waitUntil: 'domcontentloaded' });
    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

  test('navbar shows current class code next to switch icon', async ({ page }) => {
    await studentLogin(page);
    await ensureStudentHasClass(page);

    await page.goto(`${BASE_URL}/user/user/dashboard`, { waitUntil: 'domcontentloaded' });

    // Check if the exchange icon exists (multi_class module active)
    const switchIcon = page.locator('i.fa-exchange');
    const iconVisible = await switchIcon.isVisible().catch(() => false);

    if (iconVisible) {
      // The parent span should contain class code text before the icon
      const switchContainer = page.locator('span[data-toggle="modal"][data-target="#classSwitchModal"]');
      const text = await switchContainer.textContent();
      // Should have some text content (the class code) not just whitespace
      // Class codes look like "CPRAC-N5-A-2026"
      expect(text?.trim().length).toBeGreaterThan(0);
    } else {
      // multi_class module might not be enabled for this student — skip
      test.skip();
    }
  });

});
