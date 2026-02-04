/**
 * Test Helper Functions
 * Common utilities for E2E tests
 */

import { Page, expect } from '@playwright/test';

/**
 * Login as admin user
 */
export async function loginAsAdmin(page: Page) {
  // Go directly to admin login page
  await page.goto('/site/login', { waitUntil: 'networkidle' });

  // Wait for form and ensure it's interactive
  await page.waitForSelector('input[name="username"]', { state: 'visible' });
  await page.waitForSelector('input[name="password"]', { state: 'visible' });
  await page.waitForSelector('button[type="submit"]', { state: 'visible' });

  // Clear fields first (in case of autocomplete)
  await page.locator('input[name="username"]').clear();
  await page.locator('input[name="password"]').clear();

  // Fill username slowly and verify
  const username = process.env.ADMIN_USERNAME || 'admin@admin.com';
  await page.locator('input[name="username"]').fill(username);
  await page.waitForTimeout(500);

  // Fill password slowly and verify
  const password = process.env.ADMIN_PASSWORD || 'admin123';
  await page.locator('input[name="password"]').fill(password);
  await page.waitForTimeout(500);

  // Verify fields are filled
  const usernameValue = await page.locator('input[name="username"]').inputValue();
  const passwordValue = await page.locator('input[name="password"]').inputValue();

  console.log(`Username filled: ${usernameValue === username}`);
  console.log(`Password filled: ${passwordValue === password}`);

  // Click submit button and wait for navigation
  await Promise.all([
    page.waitForNavigation({ timeout: 30000, waitUntil: 'networkidle' }),
    page.locator('button[type="submit"]').click()
  ]);

  // Allow time for redirects
  await page.waitForTimeout(2000);

  // Check login success
  const currentUrl = page.url();
  console.log('After login URL:', currentUrl);

  if (currentUrl.includes('/admin/') && !currentUrl.includes('/site/login')) {
    console.log('✓ Login successful');
    return;
  }

  // Login failed
  const errors = await page.locator('.alert-danger, .text-danger').allTextContents().catch(() => []);
  throw new Error(`Login failed.\nURL: ${currentUrl}\nErrors: ${errors.join(', ')}`);
}

/**
 * Verify no section dropdown exists on the page
 * Critical check for TVET refactoring
 */
export async function verifySectionDropdownRemoved(page: Page) {
  const sectionDropdown = page.locator('select[name="section_id"]');
  await expect(sectionDropdown).toHaveCount(0);
}

/**
 * Verify class selector component exists and works
 */
export async function verifyClassSelector(page: Page) {
  const classDropdown = page.locator('select[name="class_id"]');
  await expect(classDropdown).toBeVisible();

  // Check if it has options
  const optionCount = await classDropdown.locator('option').count();
  expect(optionCount).toBeGreaterThan(1); // At least "Select" + one class
}

/**
 * Select first available class from class selector
 */
export async function selectFirstClass(page: Page): Promise<string> {
  const classDropdown = page.locator('select[name="class_id"]');

  // Get the first non-empty option
  const firstOption = classDropdown.locator('option').nth(1);
  const classValue = await firstOption.getAttribute('value') || '';
  const classText = await firstOption.textContent() || '';

  await classDropdown.selectOption(classValue);

  return classText;
}

/**
 * Wait for loading to complete
 */
export async function waitForLoading(page: Page) {
  // Wait for common loading indicators
  await page.waitForLoadState('networkidle');

  // Wait for any spinners to disappear
  const spinner = page.locator('.spinner, .loading, .dropdownloading');
  if (await spinner.count() > 0) {
    await spinner.waitFor({ state: 'hidden', timeout: 5000 }).catch(() => {});
  }
}

/**
 * Check for success message
 */
export async function verifySuccessMessage(page: Page, message?: string) {
  const successAlert = page.locator('.alert-success, .successMsg');
  await expect(successAlert).toBeVisible({ timeout: 5000 });

  if (message) {
    await expect(successAlert).toContainText(message);
  }
}

/**
 * Check for error message
 */
export async function verifyErrorMessage(page: Page, message?: string) {
  const errorAlert = page.locator('.alert-danger, .errorMsg, .text-danger');
  await expect(errorAlert).toBeVisible({ timeout: 5000 });

  if (message) {
    await expect(errorAlert).toContainText(message);
  }
}
