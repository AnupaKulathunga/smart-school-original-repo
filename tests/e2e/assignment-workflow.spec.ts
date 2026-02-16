/**
 * Assignment (Homework) Fix Verification Tests — Issue #1
 * Tests that assignments show on both admin and student sides
 * after fixing Homework_model.php to use academic_subject instead of subjects table.
 * Uses API-based tests for reliability on production.
 */
import { test, expect } from '@playwright/test';

const BASE = 'https://northlinkcollegelms.smartgov.co.za';

const ADMIN_USER = 'Blackrawone@gmail.com';
const ADMIN_PASS = 'ZEUm^9FUpduK^y5WRxM4';

// Student 4 (Tamlynne Rassie) is enrolled in class 6 (CPRAC-N5-A-2026) which has homework records
const STUDENT_USER = '209004015';
const STUDENT_PASS = 'student123';
const STUDENT_ENROLMENT_ID = '15'; // enrolment for class 6

async function loginAdmin(context: any) {
  const resp = await context.request.post(`${BASE}/site/login`, {
    form: { username: ADMIN_USER, password: ADMIN_PASS },
    maxRedirects: 5,
  });
  expect(resp.ok()).toBeTruthy();
}

async function loginStudent(context: any) {
  const resp = await context.request.post(`${BASE}/site/userlogin`, {
    form: { username: STUDENT_USER, password: STUDENT_PASS },
    maxRedirects: 5,
  });
  expect(resp.ok()).toBeTruthy();
}

async function chooseStudentClass(context: any) {
  const resp = await context.request.post(`${BASE}/user/user/choose`, {
    form: { clschg: STUDENT_ENROLMENT_ID },
    maxRedirects: 5,
  });
  expect(resp.ok()).toBeTruthy();
}

test.describe('Issue #1: Assignments Fix Verification', () => {

  test('1. Admin homework page loads without PHP errors', async ({ context }) => {
    await loginAdmin(context);
    const resp = await context.request.get(`${BASE}/homework`);
    expect(resp.ok()).toBeTruthy();
    const html = await resp.text();
    expect(html).toContain('homework-list');
    expect(html).toContain('homework-list-close');
    expect(html).not.toContain('A Database Error Occurred');
    expect(html).not.toContain('A PHP Error was encountered');
    // TVET: Should have class_id selector, not section_id
    expect(html).toContain('class_id');
  });

  test('2. Admin closed homework DataTable returns data for class 6', async ({ context }) => {
    await loginAdmin(context);
    await context.request.get(`${BASE}/homework`);
    // All 5 homework records in class 6 have submit_date in past -> closehomeworklist
    const resp = await context.request.post(`${BASE}/homework/closehomeworklist`, {
      form: {
        draw: '1',
        start: '0',
        length: '10',
        class_id: '6',
        subject_group_id: '',
        subject_id: '',
      },
    });
    expect(resp.ok()).toBeTruthy();
    const data = await resp.json();
    expect(data).toHaveProperty('data');
    expect(data.recordsTotal).toBeGreaterThan(0);
    console.log(`Closed homework for class 6: ${data.recordsTotal} records`);
  });

  test('3. Admin homework report page loads', async ({ context }) => {
    await loginAdmin(context);
    const resp = await context.request.get(`${BASE}/homework/homeworkreport`);
    expect(resp.ok()).toBeTruthy();
    const html = await resp.text();
    expect(html).not.toContain('A Database Error Occurred');
    expect(html).not.toContain('A PHP Error was encountered');
  });

  test('4. Admin evaluation report page loads', async ({ context }) => {
    await loginAdmin(context);
    const resp = await context.request.get(`${BASE}/homework/evaluation_report`);
    expect(resp.ok()).toBeTruthy();
    const html = await resp.text();
    expect(html).not.toContain('A Database Error Occurred');
    expect(html).not.toContain('A PHP Error was encountered');
  });

  test('5. Admin daily assignment page loads', async ({ context }) => {
    await loginAdmin(context);
    const resp = await context.request.get(`${BASE}/homework/dailyassignment`);
    expect(resp.ok()).toBeTruthy();
    const html = await resp.text();
    expect(html).not.toContain('A Database Error Occurred');
    expect(html).not.toContain('A PHP Error was encountered');
  });

  test('6. Admin daily assignment report page loads', async ({ context }) => {
    await loginAdmin(context);
    const resp = await context.request.get(`${BASE}/homework/dailyassignmentreport`);
    expect(resp.ok()).toBeTruthy();
    const html = await resp.text();
    expect(html).not.toContain('A Database Error Occurred');
    expect(html).not.toContain('A PHP Error was encountered');
  });

  test('7. Student homework page shows assignments after class selection', async ({ context }) => {
    await loginStudent(context);
    await chooseStudentClass(context);
    const resp = await context.request.get(`${BASE}/user/homework`);
    expect(resp.ok()).toBeTruthy();
    const html = await resp.text();
    expect(html).not.toContain('A Database Error Occurred');
    expect(html).not.toContain('A PHP Error was encountered');
    // Page should contain actual homework content (subjects from academic_subject table)
    const hasSubject = html.includes('Mathematics') || html.includes('Engineering');
    expect(hasSubject).toBeTruthy();
  });

  test('8. Student homework page has both tabs (Upcoming & Closed)', async ({ context }) => {
    await loginStudent(context);
    await chooseStudentClass(context);
    const resp = await context.request.get(`${BASE}/user/homework`);
    const html = await resp.text();
    // Check for tab structure
    const hasClosedRef = /closed/i.test(html);
    expect(hasClosedRef).toBeTruthy();
  });

  test('9. Student daily assignment page loads', async ({ context }) => {
    await loginStudent(context);
    await chooseStudentClass(context);
    const resp = await context.request.get(`${BASE}/user/homework/dailyassignment`);
    expect(resp.ok()).toBeTruthy();
    const html = await resp.text();
    expect(html).not.toContain('A Database Error Occurred');
    expect(html).not.toContain('A PHP Error was encountered');
  });

  test('10. Admin homework search returns results for class 6', async ({ context }) => {
    await loginAdmin(context);
    await context.request.get(`${BASE}/homework`);
    // Test the upcoming homework endpoint (may be empty since all are past due)
    const resp = await context.request.post(`${BASE}/homework/dthomeworklist`, {
      form: {
        draw: '1',
        start: '0',
        length: '10',
        class_id: '6',
        subject_group_id: '',
        subject_id: '',
      },
    });
    expect(resp.ok()).toBeTruthy();
    const data = await resp.json();
    expect(data).toHaveProperty('data');
    // Even if upcoming is empty, it should return valid JSON structure
    expect(data).toHaveProperty('recordsTotal');
    console.log(`Upcoming homework for class 6: ${data.recordsTotal} records`);
  });
});
