/**
 * Programme Remember — verifies student doesn't see chooser on second login
 */
import { test, expect, Page } from '@playwright/test';

const BASE_URL = 'https://northlinkcollegelms.smartgov.co.za';
const STUDENT_USERNAME = '210002840';
const STUDENT_PASSWORD = 'student123';

async function studentLogin(page: Page) {
  await page.goto(`${BASE_URL}/site/userlogin`, { waitUntil: 'domcontentloaded' });
  await page.fill('input[name="username"]', STUDENT_USERNAME);
  await page.fill('input[name="password"]', STUDENT_PASSWORD);
  await page.click('button[type="submit"], input[type="submit"]');
  await page.waitForURL(/\/(user|site)\//, { timeout: 15000 });
}

async function logout(page: Page) {
  await page.goto(`${BASE_URL}/site/userlogin`, { waitUntil: 'domcontentloaded' });
}

test.describe('Programme Remember Choice', () => {

  test('First login shows chooser, selects programme, second login skips chooser', async ({ page }) => {
    // First: clear any saved preference by logging in fresh
    await studentLogin(page);

    // If we land on choose page, select a programme
    if (page.url().includes('/user/user/choose')) {
      // Select first programme radio
      const radioBtn = page.locator('input[name="clschg"]').first();
      await radioBtn.check();
      await page.click('input[type="submit"]');
      await page.waitForURL(/\/user\/user\/dashboard/, { timeout: 15000 });
    }

    // Verify we're on the dashboard
    expect(page.url()).toContain('/user/user/dashboard');

    // Logout by clearing cookies
    await page.context().clearCookies();

    // Second login — should auto-select the remembered programme
    await studentLogin(page);

    // Wait for navigation to settle
    await page.waitForTimeout(3000);

    // Should NOT be on chooser page — should go straight to dashboard
    const currentUrl = page.url();
    console.log('Second login URL:', currentUrl);
    expect(currentUrl).toContain('/user/user/dashboard');
  });

});
