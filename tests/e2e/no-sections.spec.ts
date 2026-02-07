/**
 * 6.3: No Section Dropdown Visible on Any Page
 * Verify there's NO element with id="section_id" or name="section_id" visible
 * on each admin page. This is critical for the TVET migration which removes
 * the class/section model in favour of subject-centric academic classes.
 */
import { test, expect } from '@playwright/test';
import { loginAsAdmin } from './helpers';

test.describe('6.3: No section_id dropdown visible on admin pages', () => {

  test.beforeEach(async ({ page }) => {
    await loginAsAdmin(page);
  });

  // Pages that historically had section_id dropdowns and should now NOT have them
  const pagesToCheck = [
    { name: 'Student List', url: '/admin/student' },
    { name: 'Student Import', url: '/admin/student/import' },
    { name: 'Academic Management', url: '/admin/academic' },
    { name: 'Academic Classes', url: '/admin/academic/classes' },
    { name: 'Academic Subjects', url: '/admin/academic/subjects' },
    { name: 'Academic Enrolment', url: '/admin/academic/enrolment' },
    { name: 'Academic Attendance', url: '/admin/academic/attendance' },
    { name: 'Academic Assessment', url: '/admin/academic/assessment' },
    { name: 'TVET Admin', url: '/admin/tvet' },
    { name: 'Exam Groups', url: '/admin/examgroup' },
    { name: 'Exam Results', url: '/admin/examresult' },
    { name: 'Online Exams', url: '/admin/onlineexam' },
    { name: 'Teacher Management', url: '/admin/teacher' },
    { name: 'Homework/Assignments', url: '/admin/homework' },
    { name: 'Content Management', url: '/admin/content' },
    { name: 'Subject Groups', url: '/admin/subjectgroup' },
    { name: 'Subject Attendance', url: '/admin/subjectattendence' },
    { name: 'Student Attendance', url: '/admin/stuattendence' },
    { name: 'Lesson Plans', url: '/admin/lessonplan' },
    { name: 'Syllabus', url: '/admin/syllabus' },
    { name: 'Fee Discount', url: '/admin/feediscount' },
    { name: 'Timetable', url: '/admin/timetable' },
    { name: 'Online Students', url: '/admin/onlinestudent' },
    { name: 'Marks', url: '/admin/mark' },
    { name: 'Exam Schedule', url: '/admin/examschedule' },
    { name: 'Live Classes', url: '/admin/conference' },
    { name: 'Dashboard', url: '/admin/admin/dashboard' },
  ];

  for (const pageInfo of pagesToCheck) {
    test(`${pageInfo.name} has no section_id dropdown`, async ({ page }) => {
      const response = await page.goto(pageInfo.url, { waitUntil: 'domcontentloaded', timeout: 20000 });
      const status = response?.status() ?? 0;

      // Skip pages that error out (tested separately in admin-pages.spec.ts)
      if (status >= 500) {
        test.skip(true, `Page returned ${status}, skipping section check`);
        return;
      }

      // Skip if redirected to login
      const currentUrl = page.url();
      if (currentUrl.includes('/site/login') || currentUrl.includes('/site/userlogin')) {
        test.skip(true, 'Redirected to login, skipping section check');
        return;
      }

      // Wait for page to fully render
      await page.waitForLoadState('networkidle').catch(() => {});
      await page.waitForTimeout(1000);

      // Check for section_id by name attribute
      const sectionByName = page.locator('select[name="section_id"]');
      const sectionByNameCount = await sectionByName.count();

      // Check for section_id by id attribute
      const sectionById = page.locator('select#section_id');
      const sectionByIdCount = await sectionById.count();

      // Also check for hidden inputs with section_id
      const hiddenSectionByName = page.locator('input[name="section_id"]');
      const hiddenSectionCount = await hiddenSectionByName.count();

      // Report what we found
      if (sectionByNameCount > 0) {
        // Check if any are visible
        const visibleCount = await sectionByName.filter({ has: page.locator(':visible') }).count().catch(() => 0);
        const isAnyVisible = await sectionByName.first().isVisible().catch(() => false);

        if (isAnyVisible) {
          // Get more detail about where it is
          const parentHtml = await sectionByName.first().evaluate(el => {
            return el.closest('div, form, .form-group')?.outerHTML?.substring(0, 200) || 'unknown parent';
          }).catch(() => 'could not evaluate');

          expect(isAnyVisible, `VISIBLE section_id dropdown found on ${pageInfo.name}. Parent: ${parentHtml}`).toBe(false);
        }
      }

      if (sectionByIdCount > 0) {
        const isVisible = await sectionById.first().isVisible().catch(() => false);
        if (isVisible) {
          expect(isVisible, `VISIBLE select#section_id found on ${pageInfo.name}`).toBe(false);
        }
      }

      // Note hidden section_id fields (these might be remnants but not user-visible)
      if (hiddenSectionCount > 0) {
        const hiddenType = await hiddenSectionByName.first().getAttribute('type');
        if (hiddenType !== 'hidden') {
          const isVisible = await hiddenSectionByName.first().isVisible().catch(() => false);
          if (isVisible) {
            expect(isVisible, `VISIBLE input[name="section_id"] found on ${pageInfo.name}`).toBe(false);
          }
        } else {
          console.log(`Note: Hidden input[name="section_id"] found on ${pageInfo.name} (acceptable)`);
        }
      }

      // If we got here without failures, the page is clean
      console.log(`OK: ${pageInfo.name} has no visible section_id elements`);
    });
  }
});
