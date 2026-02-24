/**
 * Assign Class Teacher — TVET Fix Verification
 * Tests that assigning a class teacher saves correctly and appears in the list.
 * Verifies the TVET-aligned flow: primary_lecturer_id on academic_class.
 */
import { test, expect, Page } from '@playwright/test';

const BASE_URL = 'https://northlinkcollegelms.smartgov.co.za';
const ADMIN_USERNAME = 'Blackrawone@gmail.com';
const ADMIN_PASSWORD = 'ZEUm^9FUpduK^y5WRxM4';

const PHP_ERROR_PATTERNS = [
  /Fatal error/i,
  /Parse error/i,
  /Warning:.*on line/i,
  /Notice:.*on line/i,
  /A PHP Error was encountered/i,
  /An uncaught Exception was encountered/i,
  /A Database Error Occurred/i,
  /Call to a member function.*on bool/i,
  /Call to a member function.*on null/i,
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

async function adminLogin(page: Page) {
  await page.goto(`${BASE_URL}/site/login`, { waitUntil: 'domcontentloaded' });
  await page.fill('input[name="username"]', ADMIN_USERNAME);
  await page.fill('input[name="password"]', ADMIN_PASSWORD);
  await page.click('button[type="submit"], input[type="submit"]');
  await page.waitForURL('**/admin/**', { timeout: 15000 });
}

test.describe('Assign Class Teacher — TVET', () => {

  test('page loads without PHP errors', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/teacher/assign_class_teacher`, { waitUntil: 'domcontentloaded' });

    const errors = await checkForPhpErrors(page);
    expect(errors, `PHP errors found: ${errors.join(', ')}`).toHaveLength(0);

    // Page should have the form and the list
    await expect(page.locator('h3:has-text("Assign Class Teacher")')).toBeVisible();
    await expect(page.locator('h3:has-text("Class Teacher List")')).toBeVisible();
  });

  test('class dropdown has options from TVET academic_class', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/teacher/assign_class_teacher`, { waitUntil: 'domcontentloaded' });

    const classDropdown = page.locator('select[name="class"]');
    await expect(classDropdown).toBeVisible();

    // Should have real class options (not just "Select")
    const optionCount = await classDropdown.locator('option').count();
    expect(optionCount).toBeGreaterThan(1);
  });

  test('assign teacher saves and appears in list', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/teacher/assign_class_teacher`, { waitUntil: 'domcontentloaded' });

    // Select the first class
    const classDropdown = page.locator('select[name="class"]');
    const firstOption = classDropdown.locator('option:not([value=""])').first();
    const classValue = await firstOption.getAttribute('value');
    const className = (await firstOption.textContent())?.trim();
    expect(classValue).toBeTruthy();
    await classDropdown.selectOption(classValue!);

    // Check the first teacher checkbox
    const firstTeacher = page.locator('input[name="teachers[]"]').first();
    await firstTeacher.check();

    // Submit the form and wait for navigation
    const form = page.locator('form#form1');
    const submitBtn = form.locator('button[type="submit"]');

    await Promise.all([
      page.waitForNavigation({ timeout: 20000 }),
      submitBtn.click(),
    ]);

    // Check no PHP errors after save
    const errors = await checkForPhpErrors(page);
    expect(errors, `PHP errors after save: ${errors.join(', ')}`).toHaveLength(0);

    // Navigate to the page to check the list
    await page.goto(`${BASE_URL}/admin/teacher/assign_class_teacher`, { waitUntil: 'domcontentloaded' });

    const errorsAfter = await checkForPhpErrors(page);
    expect(errorsAfter, `PHP errors on list page: ${errorsAfter.join(', ')}`).toHaveLength(0);

    // The Class Teacher List table should now have at least one row
    const tableBody = page.locator('table.example tbody');
    const rows = tableBody.locator('tr');
    const rowCount = await rows.count();
    expect(rowCount, 'Class Teacher List should have at least 1 row after saving').toBeGreaterThan(0);

    // Verify the assigned class name appears in the table
    const tableText = await tableBody.textContent();
    expect(tableText).toContain(className!.substring(0, 10)); // partial match
  });

  test('delete class teacher works', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/teacher/assign_class_teacher`, { waitUntil: 'domcontentloaded' });

    // Check if there are any rows to delete
    const rows = page.locator('table.example tbody tr');
    const rowCount = await rows.count();

    if (rowCount > 0) {
      // Click delete on the first row (accept confirm dialog)
      page.on('dialog', dialog => dialog.accept());
      const deleteBtn = rows.first().locator('a[title="Delete"], a .fa-remove').first();

      if (await deleteBtn.isVisible()) {
        await deleteBtn.click();
        await page.waitForURL('**/assign_class_teacher**', { timeout: 15000 });

        const errors = await checkForPhpErrors(page);
        expect(errors, `PHP errors after delete: ${errors.join(', ')}`).toHaveLength(0);
      }
    }
  });

  test('no Section column in table', async ({ page }) => {
    await adminLogin(page);
    await page.goto(`${BASE_URL}/admin/teacher/assign_class_teacher`, { waitUntil: 'domcontentloaded' });

    // Table headers should NOT include "Section"
    const headers = page.locator('table.example thead th');
    const headerTexts = await headers.allTextContents();
    for (const text of headerTexts) {
      expect(text.toLowerCase()).not.toContain('section');
    }
  });
});
