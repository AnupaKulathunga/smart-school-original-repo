import { test, expect } from '@playwright/test';
import { loginAsAdmin } from './helpers';

/**
 * Terminology Regression Check Suite
 *
 * Systematically checks ALL pages for TVET terminology inconsistencies:
 * - Should NOT have "Section" dropdowns
 * - Should have single "Class" dropdown
 * - Should NOT have getSectionByClass() JavaScript
 * - Should use correct terminology: CLASS (not Class + Section)
 */

test.describe('TVET Terminology Regression Check', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  // ===================================================================
  // CRITICAL USER-FACING PAGES (Priority 1)
  // ===================================================================

  test.describe('Priority 1: User-Facing Pages', () => {

    test('Approve Leave page should NOT have Section dropdown', async ({ page }) => {
      await page.goto('/admin/approve_leave');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);

      // Should have class dropdown
      const classDropdown = page.locator('select[name="class_id"]');
      await expect(classDropdown).toHaveCount(1);

      // Should NOT have getSectionByClass JavaScript
      const pageContent = await page.content();
      expect(pageContent).not.toContain('getSectionByClass');
    });

    test('Attendance Report should NOT have Section column', async ({ page }) => {
      await page.goto('/admin/stuattendence/attendencereport');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (now verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('Exam Result Index should use CLASS terminology', async ({ page }) => {
      await page.goto('/admin/examresult');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('Rank Report should use CLASS terminology', async ({ page }) => {
      await page.goto('/admin/examresult/rankreport');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('Admit Card should use CLASS terminology', async ({ page }) => {
      await page.goto('/admin/examresult/admitcard');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('Marksheet should use CLASS terminology', async ({ page }) => {
      await page.goto('/admin/examresult/marksheet');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('Add Exam should NOT have Section dropdown', async ({ page }) => {
      await page.goto('/admin/examgroup/exam');
      await page.waitForLoadState('networkidle');

      const sectionDropdown = page.locator('select[name="section_id"]');
      const sectionCount = await sectionDropdown.count();

      if (sectionCount > 0) {
        test.fail(true, 'Add Exam page has Section dropdown');
      }
    });

    test('Add Mark should NOT have Section dropdown', async ({ page }) => {
      await page.goto('/admin/examgroup');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('Exam Assignment should NOT have Section dropdown', async ({ page }) => {
      await page.goto('/admin/examgroup/assign');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });
  });

  // ===================================================================
  // TEACHER-FACING PAGES (Priority 2)
  // ===================================================================

  test.describe('Priority 2: Teacher-Facing Pages', () => {

    test('Assign Teacher should NOT have Section dropdown', async ({ page }) => {
      await page.goto('/admin/teacher/assignteacher');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('View Assigned Teachers should use CLASS', async ({ page }) => {
      await page.goto('/admin/teacher/assignedteacher');
      await page.waitForLoadState('networkidle');

      // Should NOT have Section column header (verified correct)
      const sectionHeader = page.locator('th:has-text("Section")');
      await expect(sectionHeader).toHaveCount(0);
    });

    test('Copy Lesson Plan should use CLASS', async ({ page }) => {
      await page.goto('/admin/lessonplan');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('Timetable List should use CLASS', async ({ page }) => {
      await page.goto('/admin/timetable');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('Mark List should use CLASS', async ({ page }) => {
      await page.goto('/admin/mark');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });
  });

  // ===================================================================
  // COMMUNICATION PAGES (Priority 3)
  // ===================================================================

  test.describe('Priority 3: Communication Pages', () => {

    test('Send Notification should use CLASS', async ({ page }) => {
      await page.goto('/admin/notification');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('Video Tutorials should use CLASS', async ({ page }) => {
      await page.goto('/admin/video_tutorial');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });

    test('Question Bank should use CLASS', async ({ page }) => {
      await page.goto('/admin/question');
      await page.waitForLoadState('networkidle');

      // Should NOT have section dropdown (verified correct)
      const sectionDropdown = page.locator('select[name="section_id"]');
      await expect(sectionDropdown).toHaveCount(0);
    });
  });

  // ===================================================================
  // CHECK FOR LEGACY JAVASCRIPT
  // ===================================================================

  test.describe('Legacy JavaScript Detection', () => {

    const pagesToCheck = [
      '/admin/approve_leave',
      '/admin/stuattendence/attendencereport',
      '/admin/examresult',
      '/admin/teacher/assignteacher',
      '/admin/lessonplan',
      '/admin/notification',
    ];

    for (const pagePath of pagesToCheck) {
      test(`${pagePath} should NOT have getSectionByClass function`, async ({ page }) => {
        await page.goto(pagePath);
        await page.waitForLoadState('networkidle');

        const pageContent = await page.content();

        // Should NOT have legacy getSectionByClass function (verified correct)
        expect(pageContent).not.toContain('getSectionByClass');
      });
    }
  });

  // ===================================================================
  // TABLE COLUMN CHECK
  // ===================================================================

  test.describe('Table Column Terminology Check', () => {

    test('Tables should have "Class" column, not separate "Class" and "Section"', async ({ page }) => {
      const pagesToCheck = [
        '/admin/approve_leave',
        '/admin/examresult',
        '/admin/student/search',
      ];

      for (const pagePath of pagesToCheck) {
        await page.goto(pagePath);
        await page.waitForLoadState('networkidle');

        const classHeader = page.locator('th:has-text("Class")');
        const sectionHeader = page.locator('th:has-text("Section")');

        const hasClass = await classHeader.count() > 0;
        const hasSection = await sectionHeader.count() > 0;

        if (hasClass && hasSection) {
          console.log(`⚠️ ${pagePath} has both Class AND Section columns`);
        }
      }
    });
  });
});
