import { test, expect, Page } from '@playwright/test';

const BASE_URL = 'https://northlinkcollegelms.smartgov.co.za';

async function studentLogin(page: Page) {
  await page.goto(`${BASE_URL}/site/userlogin`, { waitUntil: 'domcontentloaded' });
  await page.fill('input[name="username"]', '210002840');
  await page.fill('input[name="password"]', 'student123');
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

test('TVET My Assessments page loads', async ({ page }) => {
  await studentLogin(page);
  await ensureDashboard(page);

  const response = await page.goto(`${BASE_URL}/user/tvetportal/my_assessments`, { waitUntil: 'domcontentloaded' });
  console.log('Status:', response?.status());
  console.log('URL:', page.url());
  const body = await page.locator('body').textContent().catch(() => '');
  console.log('Body snippet:', body?.substring(0, 500));
  expect(response?.status()).toBeLessThan(500);
});
