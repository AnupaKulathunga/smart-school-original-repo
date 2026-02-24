/**
 * Online Course Lesson — Full UI test for add lesson
 */
import { test, expect, Page } from '@playwright/test';

const BASE_URL = 'https://northlinkcollegelms.smartgov.co.za';
const ADMIN_EMAIL = 'Blackrawone@gmail.com';
const ADMIN_PASSWORD = 'ZEUm^9FUpduK^y5WRxM4';

async function adminLogin(page: Page) {
  await page.goto(`${BASE_URL}/site/login`, { waitUntil: 'domcontentloaded' });
  await page.fill('input[name="username"]', ADMIN_EMAIL);
  await page.fill('input[name="password"]', ADMIN_PASSWORD);
  await page.click('button[type="submit"], input[type="submit"]');
  await page.waitForURL(/\/(admin|dashboard)/, { timeout: 15000 });
}

test('Add lesson via UI - save button works', async ({ page }) => {
  test.setTimeout(60000);

  await adminLogin(page);
  await page.goto(`${BASE_URL}/onlinecourse/course`, { waitUntil: 'domcontentloaded' });
  await page.waitForTimeout(2000);

  // Click Manage Course for Test Course
  await page.locator('a:has-text("Manage Course")').last().click();
  await page.waitForTimeout(3000);

  // Click add lesson button
  await page.locator('.add_lesson_id').first().click();
  await page.waitForTimeout(1000);

  // Fill form
  await page.fill('#add_lesson_form input[name="title"]', 'Lesson1');
  await page.selectOption('#add_lesson_form select[name="lesson_type"]', 'video');
  await page.waitForTimeout(500);
  await page.fill('input[name="lesson_url"]', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
  await page.fill('input[name="lesson_duration"]', '01:00:00');

  // Verify handler is now bound
  const hasHandler = await page.evaluate(() => {
    const btn = document.getElementById('save_lesson');
    if (!btn) return false;
    const events = (jQuery as any)._data(btn, 'events');
    return events && events.click && events.click.length > 0;
  });
  console.log('Click handler bound:', hasHandler);
  expect(hasHandler).toBe(true);

  // Click Save and wait for AJAX
  const responsePromise = page.waitForResponse(
    resp => resp.url().includes('addlesson'),
    { timeout: 15000 }
  );

  await page.click('#save_lesson');
  const resp = await responsePromise;

  console.log('AJAX response status:', resp.status());
  const body = await resp.text();
  console.log('AJAX response body:', body);

  expect(resp.status()).toBeLessThan(500);

  const parsed = JSON.parse(body);
  expect(parsed.status).toBe('success');
});
