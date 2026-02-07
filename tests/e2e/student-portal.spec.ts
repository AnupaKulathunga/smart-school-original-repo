/**
 * 6.4: Student Portal Pages Load
 * Test the student/parent portal pages load correctly.
 * Note: Student portal requires student login, so we first test
 * that the login page itself loads, and then test pages that are
 * accessible or verify proper redirect behaviour.
 */
import { test, expect, Page } from '@playwright/test';

// PHP error patterns
const PHP_ERROR_PATTERNS = [
  /Fatal error/i,
  /Parse error/i,
  /Warning:.*on line/i,
  /Notice:.*on line/i,
  /A PHP Error was encountered/i,
  /An uncaught Exception was encountered/i,
  /A Database Error Occurred/i,
];

async function checkForPhpErrors(page: Page, url: string): Promise<string[]> {
  const bodyText = await page.locator('body').textContent().catch(() => '');
  const errors: string[] = [];
  for (const pattern of PHP_ERROR_PATTERNS) {
    if (pattern.test(bodyText || '')) {
      errors.push(`PHP error on ${url}: matched "${pattern.source}"`);
    }
  }
  return errors;
}

test.describe('6.4: Student Portal Pages Load', () => {

  test('Student/User login page loads', async ({ page }) => {
    const response = await page.goto('/site/userlogin', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    // Should see a login form
    const loginForm = page.locator('form');
    const formCount = await loginForm.count();
    expect(formCount).toBeGreaterThan(0);

    const phpErrors = await checkForPhpErrors(page, '/site/userlogin');
    expect(phpErrors).toHaveLength(0);
  });

  test('Main site/home page loads', async ({ page }) => {
    const response = await page.goto('/', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/');
    expect(phpErrors).toHaveLength(0);
  });

  test('Admin login page loads', async ({ page }) => {
    const response = await page.goto('/site/login', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    // Should have username and password fields
    await expect(page.locator('input[name="username"]')).toBeVisible();
    await expect(page.locator('input[name="password"]')).toBeVisible();

    const phpErrors = await checkForPhpErrors(page, '/site/login');
    expect(phpErrors).toHaveLength(0);
  });

  // Student portal pages - these require student auth, so they should redirect to login
  // but should NOT produce PHP errors or 500 errors
  const studentPortalPages = [
    { name: 'Student Dashboard', url: '/user/user/dashboard' },
    { name: 'Student Homework', url: '/user/homework' },
    { name: 'Student Attendance', url: '/user/attendence' },
    { name: 'Student Exam Schedule', url: '/user/examschedule' },
    { name: 'Student Marks', url: '/user/mark' },
    { name: 'Student Online Exam', url: '/user/onlineexam' },
    { name: 'Student Timetable', url: '/user/timetable' },
    { name: 'Student Syllabus', url: '/user/syllabus' },
    { name: 'Student Content', url: '/user/content' },
    { name: 'Student Timeline', url: '/user/timeline' },
    { name: 'Student Calendar', url: '/user/calendar' },
    { name: 'Student Books', url: '/user/book' },
    { name: 'Student Conference', url: '/user/conference' },
    { name: 'Student Leave', url: '/user/apply_leave' },
    { name: 'Student Notifications', url: '/user/notification' },
    { name: 'TVET Portal', url: '/user/tvetportal' },
  ];

  for (const pageInfo of studentPortalPages) {
    test(`${pageInfo.name} (${pageInfo.url}) does not produce PHP errors`, async ({ page }) => {
      const response = await page.goto(pageInfo.url, { waitUntil: 'domcontentloaded', timeout: 20000 });
      const status = response?.status() ?? 0;

      // We expect either a proper page or a redirect to login
      // We should NOT get 500 errors
      expect(status, `${pageInfo.name} returned HTTP ${status}`).toBeLessThan(500);

      // Check for PHP errors on whatever page we ended up on
      const phpErrors = await checkForPhpErrors(page, pageInfo.url);
      expect(phpErrors, `PHP errors on ${pageInfo.name}`).toHaveLength(0);

      // Log where we ended up
      const currentUrl = page.url();
      if (currentUrl.includes('/site/userlogin') || currentUrl.includes('/site/login')) {
        console.log(`${pageInfo.name}: Correctly redirected to login (auth required)`);
      } else {
        console.log(`${pageInfo.name}: Loaded at ${currentUrl}`);
      }
    });
  }
});
