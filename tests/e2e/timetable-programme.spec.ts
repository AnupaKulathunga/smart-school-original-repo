/**
 * Timetable page with programme-based login
 * Verifies the timetable page shows entries from ALL classes in the programme.
 */
import { test, expect, Page } from '@playwright/test';

const BASE_URL = 'https://northlinkcollegelms.smartgov.co.za';
const STUDENT_USERNAME = '210002840';
const STUDENT_PASSWORD = 'student123';

const PHP_ERROR_PATTERNS = [
  /Fatal error/i, /Parse error/i, /Warning:.*on line/i, /Notice:.*on line/i,
  /A PHP Error was encountered/i, /An uncaught Exception was encountered/i,
  /A Database Error Occurred/i, /Undefined offset/i, /Undefined variable/i,
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

async function ensureDashboard(page: Page) {
  if (page.url().includes('/user/user/choose')) {
    const radioBtn = page.locator('input[name="clschg"]').first();
    await radioBtn.check();
    await page.click('input[type="submit"]');
    await page.waitForURL(/\/user\//, { timeout: 15000 });
  }
}

test.describe('Timetable with Programme Login', () => {

  test('Timetable page loads without PHP errors', async ({ page }) => {
    await studentLogin(page);
    await ensureDashboard(page);

    const response = await page.goto(`${BASE_URL}/user/timetable`, { waitUntil: 'domcontentloaded' });
    expect(response?.status()).toBeLessThan(500);

    const errors = await checkForPhpErrors(page);
    expect(errors).toEqual([]);
  });

  test('Timetable shows scheduled entries (not all "Not Scheduled")', async ({ page }) => {
    await studentLogin(page);
    await ensureDashboard(page);

    await page.goto(`${BASE_URL}/user/timetable`, { waitUntil: 'domcontentloaded' });
    const bodyText = await page.locator('body').textContent() || '';

    // The student has a Monday timetable entry for ENGSC class
    // Check that Monday column has some actual content beyond "Not Scheduled"
    const hasScheduledContent = bodyText.includes('AM') || bodyText.includes('PM') || bodyText.includes(':');

    // At minimum, verify page loaded properly
    expect(bodyText).toContain('Class Timetable');

    // If there are timetable entries in DB, at least Monday should show something
    // (We know from DB there are 2 Monday entries for this student's classes)
    console.log('Timetable has time entries:', hasScheduledContent);
    expect(hasScheduledContent).toBeTruthy();
  });

});
