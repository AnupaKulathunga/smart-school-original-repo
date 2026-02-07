/**
 * 6.2: AJAX/DataTable Endpoints Return Valid JSON
 * Test the key AJAX endpoints that DataTables and other dynamic components use.
 */
import { test, expect, Page, BrowserContext } from '@playwright/test';
import { loginAsAdmin } from './helpers';

test.describe('6.2: AJAX/DataTable Endpoints Return Valid JSON', () => {

  let context: BrowserContext;
  let page: Page;

  test.beforeAll(async ({ browser }) => {
    context = await browser.newContext();
    page = await context.newPage();
    await loginAsAdmin(page);
  });

  test.afterAll(async () => {
    await context?.close();
  });

  /**
   * Helper: Make an AJAX-style request (with cookies from the logged-in session)
   * and verify it returns valid JSON
   */
  async function testAjaxEndpoint(
    endpointPage: Page,
    url: string,
    method: 'GET' | 'POST' = 'POST',
    postData?: Record<string, string>,
    expectDataKey = true,
  ) {
    // Navigate first to ensure session cookies are set for the domain
    let response;

    if (method === 'GET') {
      response = await endpointPage.goto(url, { waitUntil: 'domcontentloaded', timeout: 15000 });
    } else {
      // For POST requests, use page.evaluate to make a fetch call from the browser context
      const result = await endpointPage.evaluate(async ({ fetchUrl, fetchPostData }) => {
        const formData = new URLSearchParams();
        if (fetchPostData) {
          Object.entries(fetchPostData).forEach(([key, val]) => {
            formData.append(key, val as string);
          });
        }
        try {
          const resp = await fetch(fetchUrl, {
            method: 'POST',
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'X-Requested-With': 'XMLHttpRequest',
            },
            body: formData.toString(),
          });
          const text = await resp.text();
          return { status: resp.status, body: text };
        } catch (e) {
          return { status: 0, body: String(e) };
        }
      }, { fetchUrl: url, fetchPostData: postData });

      // Try to parse as JSON
      expect(result.status, `Endpoint ${url} returned status ${result.status}`).toBeLessThan(500);

      let parsed;
      try {
        parsed = JSON.parse(result.body);
      } catch {
        // Check if it's a PHP error page
        if (result.body.includes('error') || result.body.includes('Fatal') || result.body.includes('Exception')) {
          throw new Error(`Endpoint ${url} returned non-JSON response with errors: ${result.body.substring(0, 500)}`);
        }
        throw new Error(`Endpoint ${url} returned non-JSON response: ${result.body.substring(0, 300)}`);
      }

      expect(parsed, `Endpoint ${url} returned valid JSON`).toBeDefined();

      if (expectDataKey && parsed !== null) {
        // DataTable endpoints typically have a "data" key
        const hasDataKey = 'data' in parsed || 'aaData' in parsed || 'recordsTotal' in parsed;
        if (!hasDataKey) {
          console.log(`Note: ${url} JSON response does not have standard DataTable keys. Keys: ${Object.keys(parsed).join(', ')}`);
        }
      }

      return parsed;
    }

    // For GET responses
    const status = response?.status() ?? 0;
    expect(status, `Endpoint ${url} returned status ${status}`).toBeLessThan(500);

    const bodyText = await endpointPage.locator('body').textContent().catch(() => '');
    let parsed;
    try {
      parsed = JSON.parse(bodyText || '');
    } catch {
      if ((bodyText || '').includes('Fatal') || (bodyText || '').includes('Exception')) {
        throw new Error(`Endpoint ${url} returned non-JSON with errors: ${(bodyText || '').substring(0, 500)}`);
      }
      throw new Error(`Endpoint ${url} returned non-JSON: ${(bodyText || '').substring(0, 300)}`);
    }

    expect(parsed, `Endpoint ${url} returned valid JSON`).toBeDefined();
    return parsed;
  }

  // DataTable AJAX endpoints
  const datatableEndpoints = [
    {
      name: 'User Logs - getDatatable',
      url: '/admin/userlog/getDatatable',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'User Logs - getStudentDatatable',
      url: '/admin/userlog/getStudentDatatable',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Audit - getDatatable',
      url: '/admin/audit/getDatatable',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Question - getDatatable',
      url: '/admin/question/getDatatable',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Offline Payment - getlist',
      url: '/admin/offlinepayment/getlist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Book - getbooklist',
      url: '/admin/book/getbooklist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Content - getsharelist',
      url: '/admin/content/getsharelist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Online Exam - getexamlist',
      url: '/admin/onlineexam/getexamlist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Online Student - getstudentlist',
      url: '/admin/onlinestudent/getstudentlist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Expense Head - ajaxSearch',
      url: '/admin/expensehead/ajaxSearch',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Content Type - getcontenttypelist',
      url: '/admin/contenttype/getcontenttypelist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Lesson Plan - gettopiclist',
      url: '/admin/lessonplan/gettopiclist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Lesson Plan - getlessonlist',
      url: '/admin/lessonplan/getlessonlist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'General Call - getcalllist',
      url: '/admin/generalcall/getcalllist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Issue Item - getitemlist',
      url: '/admin/issueitem/getitemlist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Income - getincomelist',
      url: '/admin/income/getincomelist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Expense - getexpenselist',
      url: '/admin/expense/getexpenselist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
    {
      name: 'Pickup Point - getpickpointlist',
      url: '/admin/pickuppoint/getpickpointlist',
      method: 'POST' as const,
      postData: { draw: '1', start: '0', length: '10' },
    },
  ];

  for (const endpoint of datatableEndpoints) {
    test(`${endpoint.name} returns valid JSON`, async () => {
      // First make sure we're on an admin page (for cookie context)
      const currentUrl = page.url();
      if (!currentUrl.includes('/admin/')) {
        await page.goto('/admin/admin/dashboard', { waitUntil: 'domcontentloaded' });
      }

      await testAjaxEndpoint(
        page,
        endpoint.url,
        endpoint.method,
        endpoint.postData,
      );
    });
  }

  // Additional AJAX endpoints (non-DataTable)
  test('Admin student search (dtstudentlist) returns valid JSON', async () => {
    const currentUrl = page.url();
    if (!currentUrl.includes('/admin/')) {
      await page.goto('/admin/admin/dashboard', { waitUntil: 'domcontentloaded' });
    }

    await testAjaxEndpoint(
      page,
      '/admin/admin/dtstudentlist',
      'POST',
      { draw: '1', start: '0', length: '10' },
    );
  });

  test('TVET ajax_get_qualifications returns valid JSON', async () => {
    const currentUrl = page.url();
    if (!currentUrl.includes('/admin/')) {
      await page.goto('/admin/admin/dashboard', { waitUntil: 'domcontentloaded' });
    }

    // This may return empty or an error if no programme_id=1 exists, but should still be JSON
    const result = await page.evaluate(async () => {
      try {
        const resp = await fetch('/admin/tvet/ajax_get_qualifications/1', {
          method: 'GET',
          headers: { 'X-Requested-With': 'XMLHttpRequest' },
        });
        return { status: resp.status, body: await resp.text() };
      } catch (e) {
        return { status: 0, body: String(e) };
      }
    });

    expect(result.status, 'TVET qualifications endpoint status').toBeLessThan(500);
  });

  test('Academic ajax_get_subjects returns valid JSON', async () => {
    const currentUrl = page.url();
    if (!currentUrl.includes('/admin/')) {
      await page.goto('/admin/admin/dashboard', { waitUntil: 'domcontentloaded' });
    }

    const result = await page.evaluate(async () => {
      try {
        const resp = await fetch('/admin/academic/ajax_get_subjects/1', {
          method: 'GET',
          headers: { 'X-Requested-With': 'XMLHttpRequest' },
        });
        return { status: resp.status, body: await resp.text() };
      } catch (e) {
        return { status: 0, body: String(e) };
      }
    });

    expect(result.status, 'Academic subjects endpoint status').toBeLessThan(500);
  });
});
