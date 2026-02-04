import { defineConfig, devices } from '@playwright/test';

/**
 * Playwright configuration for Smart School TVET E2E tests
 * Tests the refactored views to ensure TVET architecture works correctly
 */
export default defineConfig({
  testDir: './e2e',

  // Maximum time one test can run
  timeout: 30 * 1000,

  // Test execution settings
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,

  // Reporter settings
  reporter: [
    ['html', { outputFolder: 'results/playwright-report' }],
    ['json', { outputFile: 'results/playwright.json' }],
    ['list']
  ],

  // Shared settings for all projects
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:8080',

    // Capture screenshots only on failure
    screenshot: 'only-on-failure',

    // Capture video on first retry
    video: 'retain-on-failure',

    // Collect trace on first retry
    trace: 'on-first-retry',

    // Default timeout for actions
    actionTimeout: 10 * 1000,
  },

  // Configure projects for different test types
  projects: [
    {
      name: 'admin-critical',
      testMatch: /e2e\/admin\/.*\.spec\.ts/,
      use: { ...devices['Desktop Chrome'] },
    },
  ],

  // Run local dev server before tests (optional)
  webServer: process.env.CI ? undefined : {
    command: 'docker-compose up -d',
    url: 'http://localhost:8080',
    timeout: 60 * 1000,
    reuseExistingServer: true,
  },
});
