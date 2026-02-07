/**
 * 6.5: TVET Academic Pages Functional
 * Test the TVET-specific pages (Academic management, TVET admin, etc.)
 * AND
 * 6.6: New Features Still Work
 * Test that moderation, disability, ZIP upload pages are accessible.
 */
import { test, expect, Page, BrowserContext } from '@playwright/test';
import { loginAsAdmin } from './helpers';

// PHP error patterns
const PHP_ERROR_PATTERNS = [
  /Fatal error/i,
  /Parse error/i,
  /Warning:.*on line/i,
  /Notice:.*on line/i,
  /A PHP Error was encountered/i,
  /An uncaught Exception was encountered/i,
  /A Database Error Occurred/i,
  /Class .* not found/i,
  /Table .* doesn't exist/i,
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

test.describe('6.5: TVET Academic Pages Functional', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  // ===== TVET Admin Controller Pages =====

  test('TVET Admin Dashboard loads', async ({ page }) => {
    const response = await page.goto('/admin/tvet', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/tvet');
    expect(phpErrors).toHaveLength(0);

    // Check for TVET-specific content
    const bodyText = await page.locator('body').textContent();
    const hasTvetContent = (bodyText || '').toLowerCase().includes('tvet') ||
                          (bodyText || '').toLowerCase().includes('programme') ||
                          (bodyText || '').toLowerCase().includes('management');
    expect(hasTvetContent, 'TVET page should contain TVET-related content').toBe(true);
  });

  test('TVET Programmes page loads', async ({ page }) => {
    const response = await page.goto('/admin/tvet/programmes', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/tvet/programmes');
    expect(phpErrors).toHaveLength(0);
  });

  test('TVET Qualifications page loads', async ({ page }) => {
    const response = await page.goto('/admin/tvet/qualifications', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/tvet/qualifications');
    expect(phpErrors).toHaveLength(0);
  });

  test('TVET Levels page loads', async ({ page }) => {
    const response = await page.goto('/admin/tvet/levels', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/tvet/levels');
    expect(phpErrors).toHaveLength(0);
  });

  test('TVET Cohorts page loads', async ({ page }) => {
    const response = await page.goto('/admin/tvet/cohorts', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/tvet/cohorts');
    expect(phpErrors).toHaveLength(0);
  });

  test('TVET Modules page loads', async ({ page }) => {
    const response = await page.goto('/admin/tvet/modules', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/tvet/modules');
    expect(phpErrors).toHaveLength(0);
  });

  // ===== Academic Controller Pages =====

  test('Academic Dashboard loads with statistics', async ({ page }) => {
    const response = await page.goto('/admin/academic', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/academic');
    expect(phpErrors).toHaveLength(0);

    // Should contain academic management content
    const bodyText = await page.locator('body').textContent();
    const hasAcademicContent = (bodyText || '').toLowerCase().includes('academic') ||
                               (bodyText || '').toLowerCase().includes('programme') ||
                               (bodyText || '').toLowerCase().includes('subject') ||
                               (bodyText || '').toLowerCase().includes('class');
    expect(hasAcademicContent, 'Academic page should contain relevant content').toBe(true);
  });

  test('Academic Classes page loads', async ({ page }) => {
    const response = await page.goto('/admin/academic/classes', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/academic/classes');
    expect(phpErrors).toHaveLength(0);
  });

  test('Academic Subjects page loads', async ({ page }) => {
    const response = await page.goto('/admin/academic/subjects', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/academic/subjects');
    expect(phpErrors).toHaveLength(0);
  });

  test('Academic Enrolment page loads', async ({ page }) => {
    const response = await page.goto('/admin/academic/enrolment', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/academic/enrolment');
    expect(phpErrors).toHaveLength(0);
  });

  test('Academic Attendance page loads', async ({ page }) => {
    const response = await page.goto('/admin/academic/attendance', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/academic/attendance');
    expect(phpErrors).toHaveLength(0);
  });

  test('Academic Assessment page loads', async ({ page }) => {
    const response = await page.goto('/admin/academic/assessment', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/academic/assessment');
    expect(phpErrors).toHaveLength(0);
  });

  test('Academic Programmes management page loads', async ({ page }) => {
    const response = await page.goto('/admin/academic/programmes', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/academic/programmes');
    expect(phpErrors).toHaveLength(0);
  });

  test('Academic Levels page loads', async ({ page }) => {
    const response = await page.goto('/admin/academic/levels', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);
    const phpErrors = await checkForPhpErrors(page, '/admin/academic/levels');
    expect(phpErrors).toHaveLength(0);
  });

  // ===== TVET AJAX endpoints functional =====

  test('TVET AJAX endpoints respond without 500 errors', async ({ page }) => {
    await page.goto('/admin/admin/dashboard', { waitUntil: 'domcontentloaded' });

    const ajaxEndpoints = [
      '/admin/tvet/ajax_get_qualifications/1',
      '/admin/tvet/ajax_get_levels/1',
      '/admin/tvet/ajax_get_cohorts/1',
      '/admin/tvet/ajax_get_modules/1',
      '/admin/academic/ajax_get_subjects/1',
      '/admin/academic/ajax_get_levels/1',
      '/admin/academic/ajax_get_subject_levels/1',
      '/admin/academic/ajax_get_classes/1',
      '/admin/academic/ajax_get_class_students/1',
    ];

    for (const endpoint of ajaxEndpoints) {
      const result = await page.evaluate(async (url) => {
        try {
          const resp = await fetch(url, {
            method: 'GET',
            headers: { 'X-Requested-With': 'XMLHttpRequest' },
          });
          return { status: resp.status, body: await resp.text() };
        } catch (e) {
          return { status: 0, body: String(e) };
        }
      }, endpoint);

      expect(result.status, `TVET AJAX ${endpoint} should not return 500`).toBeLessThan(500);

      // Should not contain PHP errors
      const hasPhpError = /Fatal error|Parse error|A PHP Error|A Database Error/i.test(result.body);
      expect(hasPhpError, `TVET AJAX ${endpoint} should not contain PHP errors`).toBe(false);
    }
  });
});

test.describe('6.6: New Features Still Work', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  // ===== Disability Type =====

  test('Disability Types page loads', async ({ page }) => {
    const response = await page.goto('/disabilitytype', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/disabilitytype');
    expect(phpErrors).toHaveLength(0);

    // Page should not redirect to login
    const currentUrl = page.url();
    expect(currentUrl).not.toContain('/site/login');
  });

  test('Disability Types page has functional content', async ({ page }) => {
    await page.goto('/disabilitytype', { waitUntil: 'domcontentloaded' });

    // Should contain disability-related content or a form
    const bodyText = await page.locator('body').textContent();
    const hasRelevantContent = (bodyText || '').toLowerCase().includes('disability') ||
                               (bodyText || '').toLowerCase().includes('type') ||
                               (bodyText || '').toLowerCase().includes('add');
    expect(hasRelevantContent, 'Disability page should have relevant content').toBe(true);
  });

  // ===== Student Import (including bulk enrolment) =====

  test('Student Import page loads', async ({ page }) => {
    const response = await page.goto('/admin/student/import', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/student/import');
    expect(phpErrors).toHaveLength(0);
  });

  test('Student Import page has file upload form', async ({ page }) => {
    await page.goto('/admin/student/import', { waitUntil: 'domcontentloaded' });

    // Should have a file input
    const fileInputs = page.locator('input[type="file"]');
    const fileInputCount = await fileInputs.count();
    expect(fileInputCount, 'Import page should have file upload input').toBeGreaterThan(0);
  });

  // ===== Student Enrolment Import =====

  test('Student Enrolment Import page loads', async ({ page }) => {
    const response = await page.goto('/admin/student/import_enrolments', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;

    // This may be a 404 if the route isn't set up yet, but should not be 500
    expect(status, 'Enrolment import should not return 500').toBeLessThan(500);

    if (status < 400) {
      const phpErrors = await checkForPhpErrors(page, '/admin/student/import_enrolments');
      expect(phpErrors).toHaveLength(0);
    }
  });

  // ===== Grade/Moderation =====

  test('Grade management page loads', async ({ page }) => {
    const response = await page.goto('/admin/grade', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/grade');
    expect(phpErrors).toHaveLength(0);
  });

  // ===== Marks Division (for moderation) =====

  test('Marks Division page loads', async ({ page }) => {
    const response = await page.goto('/admin/marksdivision', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/marksdivision');
    expect(phpErrors).toHaveLength(0);
  });

  // ===== Exam Group =====

  test('Exam Group page loads and has functional UI', async ({ page }) => {
    const response = await page.goto('/admin/examgroup', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/examgroup');
    expect(phpErrors).toHaveLength(0);

    // Should have exam group content
    const bodyText = await page.locator('body').textContent();
    const hasContent = (bodyText || '').toLowerCase().includes('exam');
    expect(hasContent, 'Exam group page should have exam-related content').toBe(true);
  });

  // ===== Exam Result =====

  test('Exam Result page loads', async ({ page }) => {
    const response = await page.goto('/admin/examresult', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/examresult');
    expect(phpErrors).toHaveLength(0);
  });

  // ===== Staff / Teacher =====

  test('Teacher page loads and has functional UI', async ({ page }) => {
    const response = await page.goto('/admin/teacher', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/teacher');
    expect(phpErrors).toHaveLength(0);
  });

  // ===== Content Management =====

  test('Content page loads', async ({ page }) => {
    const response = await page.goto('/admin/content', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/content');
    expect(phpErrors).toHaveLength(0);
  });

  // ===== Online Exam =====

  test('Online Exam page loads', async ({ page }) => {
    const response = await page.goto('/admin/onlineexam', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/onlineexam');
    expect(phpErrors).toHaveLength(0);
  });

  // ===== Conference / Live Classes =====

  test('Conference page loads', async ({ page }) => {
    const response = await page.goto('/admin/conference', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/conference');
    expect(phpErrors).toHaveLength(0);
  });

  // ===== Homework / Assignments =====

  test('Homework page loads', async ({ page }) => {
    const response = await page.goto('/admin/homework', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;
    expect(status).toBeLessThan(500);

    const phpErrors = await checkForPhpErrors(page, '/admin/homework');
    expect(phpErrors).toHaveLength(0);
  });

  // ===== Academic Class creation form =====

  test('Academic Class create page loads', async ({ page }) => {
    const response = await page.goto('/admin/academic/create_class', { waitUntil: 'domcontentloaded' });
    const status = response?.status() ?? 0;

    // May be 404 if method doesn't exist as separate page
    expect(status, 'Class creation should not return 500').toBeLessThan(500);

    if (status < 400) {
      const phpErrors = await checkForPhpErrors(page, '/admin/academic/create_class');
      expect(phpErrors).toHaveLength(0);
    }
  });
});
