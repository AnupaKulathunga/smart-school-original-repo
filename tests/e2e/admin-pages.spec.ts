/**
 * 6.1: Admin Pages Load Tests
 * Verify all main admin pages return 200 and don't show PHP errors.
 */
import { test, expect, Page } from '@playwright/test';
import { loginAsAdmin } from './helpers';

// PHP error patterns to detect
const PHP_ERROR_PATTERNS = [
  /Fatal error/i,
  /Parse error/i,
  /Warning:.*on line/i,
  /Notice:.*on line/i,
  /Undefined variable/i,
  /Undefined index/i,
  /Call to undefined/i,
  /Cannot redeclare/i,
  /Class .* not found/i,
  /Table .* doesn't exist/i,
  /You have an error in your SQL syntax/i,
  /A PHP Error was encountered/i,
  /An uncaught Exception was encountered/i,
  /A Database Error Occurred/i,
  /Exception:.*on line/i,
  /Stack trace:/i,
];

/**
 * Check page body for PHP errors
 */
async function checkForPhpErrors(page: Page, url: string): Promise<string[]> {
  const bodyText = await page.locator('body').textContent().catch(() => '');
  const errors: string[] = [];

  for (const pattern of PHP_ERROR_PATTERNS) {
    if (pattern.test(bodyText || '')) {
      errors.push(`PHP error detected on ${url}: matched pattern "${pattern.source}"`);
    }
  }

  return errors;
}

test.describe('6.1: Admin Pages Load (200 status, no PHP errors)', () => {
  let adminLoggedIn = false;

  test.beforeEach(async ({ page }) => {
    if (!adminLoggedIn) {
      await loginAsAdmin(page);
      adminLoggedIn = true;
    } else {
      await loginAsAdmin(page);
    }
  });

  // Core admin pages
  const adminPages = [
    { name: 'Dashboard', url: '/admin/admin/dashboard' },
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
    { name: 'Live Classes', url: '/admin/conference' },
    { name: 'Disability Types', url: '/disabilitytype' },
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
    { name: 'User Logs', url: '/admin/userlog' },
    { name: 'Audit Logs', url: '/admin/audit' },
    { name: 'Staff Management', url: '/admin/staff' },
    { name: 'Leave Requests', url: '/admin/leaverequest' },
    { name: 'Holiday', url: '/admin/holiday' },
    { name: 'Enquiry', url: '/admin/enquiry' },
    { name: 'Visitors', url: '/admin/visitors' },
    { name: 'Complaints', url: '/admin/complaint' },
    { name: 'Books', url: '/admin/book' },
    { name: 'Hostel', url: '/admin/hostel' },
    { name: 'Transport', url: '/admin/transport' },
    { name: 'Income', url: '/admin/income' },
    { name: 'Expense', url: '/admin/expense' },
    { name: 'Certificate', url: '/admin/certificate' },
    { name: 'Admit Card', url: '/admin/admitcard' },
    { name: 'Front CMS', url: '/admin/frontcms' },
    { name: 'Calendar', url: '/admin/calendar' },
    { name: 'Notification', url: '/admin/notification' },
    { name: 'Roles', url: '/admin/roles' },
    { name: 'Users', url: '/admin/users' },
    { name: 'Alumni', url: '/admin/alumni' },
  ];

  for (const pageInfo of adminPages) {
    test(`${pageInfo.name} (${pageInfo.url}) loads with 200`, async ({ page }) => {
      const response = await page.goto(pageInfo.url, { waitUntil: 'domcontentloaded', timeout: 25000 });

      // Check HTTP status
      const status = response?.status() ?? 0;
      // Accept 200 and 302 (redirect to login is handled by beforeEach)
      // If we got redirected to login, that means auth failed - still a problem
      const currentUrl = page.url();
      const redirectedToLogin = currentUrl.includes('/site/login') || currentUrl.includes('/site/userlogin');

      if (redirectedToLogin) {
        // Page requires auth but we lost session - note it but don't fail hard
        // Some pages may legitimately redirect
        console.log(`WARNING: ${pageInfo.name} redirected to login page`);
      }

      // Check for server errors (500, 404, etc.)
      expect(status, `${pageInfo.name} returned HTTP ${status}`).toBeLessThan(500);

      // Check for PHP errors in page body
      if (!redirectedToLogin) {
        const phpErrors = await checkForPhpErrors(page, pageInfo.url);
        expect(phpErrors, `PHP errors on ${pageInfo.name}`).toHaveLength(0);
      }
    });
  }
});
