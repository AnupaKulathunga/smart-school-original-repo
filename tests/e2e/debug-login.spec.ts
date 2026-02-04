import { test } from '@playwright/test';

test('debug login', async ({ page }) => {
  console.log('1. Navigating to /admin');
  await page.goto('http://localhost:8080/admin');

  console.log('2. Current URL:', page.url());
  await page.screenshot({ path: 'test-results/debug-01-initial.png' });

  console.log('3. Waiting for username field');
  await page.waitForSelector('input[name="username"]', { timeout: 10000 });

  console.log('4. Filling username');
  await page.fill('input[name="username"]', 'admin');

  console.log('5. Filling password');
  await page.fill('input[name="password"]', 'admin123');

  await page.screenshot({ path: 'test-results/debug-02-filled.png' });

  console.log('6. Clicking submit');
  await page.click('button[type="submit"]');

  console.log('7. Waiting 5 seconds...');
  await page.waitForTimeout(5000);

  console.log('8. Current URL after login:', page.url());
  await page.screenshot({ path: 'test-results/debug-03-after-login.png' });

  console.log('9. Page title:', await page.title());

  // Check for error messages
  const errorMsg = await page.locator('.alert-danger, .error').textContent().catch(() => 'no error');
  console.log('10. Error message:', errorMsg);
});
