import { test, expect } from '@playwright/test';

const BASE = 'https://northlinkcollegelms.smartgov.co.za';

// Helper: login as admin
async function loginAdmin(page) {
  await page.goto(`${BASE}/site/login`);
  await page.fill('input[name="username"]', 'Blackrawone@gmail.com');
  await page.fill('input[name="password"]', 'ZEUm^9FUpduK^y5WRxM4');
  await page.click('button[type="submit"]');
  await page.waitForLoadState('networkidle');
}

// Helper: login as student and choose class
async function loginStudent(page) {
  await page.goto(`${BASE}/site/userlogin`);
  await page.fill('input[name="username"]', '210002840');
  await page.fill('input[name="password"]', 'student123');
  await page.click('button[type="submit"]');
  await page.waitForLoadState('networkidle');
  // Choose class if redirected
  if (page.url().includes('choose')) {
    const radios = page.locator('input[name="clschg"]');
    if (await radios.count() > 0) {
      await radios.first().check();
      await page.click('button[type="submit"], input[type="submit"]');
      await page.waitForLoadState('networkidle');
    }
  }
}

test.describe('Download Center / Content Fix (Issues #3+#5)', () => {

  test.describe('Student Content Pages', () => {

    test('Download Center list page loads (200, no errors)', async ({ page }) => {
      await loginStudent(page);
      const response = await page.goto(`${BASE}/user/content/list`);
      expect(response?.status()).toBe(200);
      // Should contain DataTable or content list structure
      const body = await page.content();
      expect(body).not.toContain('An Error Was Encountered');
      expect(body).not.toContain('error_page');
    });

    test('Share list AJAX returns valid JSON with data', async ({ request }) => {
      // Login as student
      const loginResp = await request.post(`${BASE}/site/userlogin`, {
        form: { username: '210002840', password: 'student123' }
      });
      // Choose class
      await request.post(`${BASE}/user/user/choose`, {
        form: { clschg: '1' }
      });
      // Test AJAX
      const resp = await request.post(`${BASE}/user/content/getsharelist`, {
        form: { draw: '1', start: '0', length: '10' }
      });
      expect(resp.status()).toBe(200);
      const json = await resp.json();
      expect(json).toHaveProperty('draw');
      expect(json).toHaveProperty('recordsTotal');
      expect(json).toHaveProperty('data');
      expect(json.recordsTotal).toBeGreaterThanOrEqual(1);
    });

    test('Content view page loads without server error', async ({ page }) => {
      await loginStudent(page);
      const response = await page.goto(`${BASE}/user/content/view/1`);
      expect(response?.status()).toBe(200);
      const body = await page.content();
      expect(body).not.toContain('An Error Was Encountered');
      // Page should load with content structure (may show expired message if content has passed valid_upto date)
      expect(body).toContain('Content');
    });

    test('Assignment/studymaterial/syllabus/other redirect to list', async ({ page }) => {
      await loginStudent(page);
      for (const subpage of ['assignment', 'studymaterial', 'syllabus', 'other']) {
        await page.goto(`${BASE}/user/content/${subpage}`);
        // Should redirect to list page (200 response after redirect)
        expect(page.url()).toContain('content/list');
      }
    });
  });

  test.describe('Admin Content Pages', () => {

    test('Admin content list page loads', async ({ page }) => {
      await loginAdmin(page);
      const response = await page.goto(`${BASE}/admin/content/list`);
      expect(response?.status()).toBe(200);
      const body = await page.content();
      expect(body).not.toContain('An Error Was Encountered');
    });

    test('Admin upload content page loads', async ({ page }) => {
      await loginAdmin(page);
      const response = await page.goto(`${BASE}/admin/content/upload`);
      expect(response?.status()).toBe(200);
      const body = await page.content();
      expect(body).not.toContain('An Error Was Encountered');
    });

    test('Admin share list AJAX returns all records', async ({ request }) => {
      const loginResp = await request.post(`${BASE}/site/login`, {
        form: { username: 'Blackrawone@gmail.com', password: 'ZEUm^9FUpduK^y5WRxM4' }
      });
      const resp = await request.post(`${BASE}/admin/content/getsharelist`, {
        form: { draw: '1', start: '0', length: '10' }
      });
      expect(resp.status()).toBe(200);
      const json = await resp.json();
      expect(json).toHaveProperty('recordsTotal');
      expect(json.recordsTotal).toBeGreaterThanOrEqual(4);
    });

    test('Admin shared content detail loads correctly', async ({ request }) => {
      const loginResp = await request.post(`${BASE}/site/login`, {
        form: { username: 'Blackrawone@gmail.com', password: 'ZEUm^9FUpduK^y5WRxM4' }
      });
      const resp = await request.post(`${BASE}/admin/content/getsharedcontents`, {
        form: { share_content_id: '1' }
      });
      expect(resp.status()).toBe(200);
      const json = await resp.json();
      expect(json.status).toBe('1');
      expect(json).toHaveProperty('page');
      expect(json.page.length).toBeGreaterThan(0);
    });
  });
});
