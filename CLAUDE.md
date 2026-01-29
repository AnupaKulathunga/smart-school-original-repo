# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Smart School is a comprehensive School Management System built with CodeIgniter 3 (PHP framework). Version 7.1.0.

**Framework**: CodeIgniter 3 (PHP)
**Database**: MySQL (mysqli driver)
**Architecture**: MVC (Model-View-Controller)

## Directory Structure

```
smart_school_src/
├── application/          # CodeIgniter application code
│   ├── controllers/     # Controllers organized by role
│   │   ├── admin/      # Admin panel controllers (111 files)
│   │   ├── user/       # Student/user controllers
│   │   ├── onlineadmission/
│   │   ├── gateway_ins/
│   │   └── install/
│   ├── models/         # Database models (152 files)
│   ├── views/          # View templates
│   │   ├── admin/      # Admin panel views
│   │   ├── user/
│   │   ├── layout/
│   │   └── print/
│   ├── libraries/      # Custom libraries (60+ files)
│   ├── helpers/        # Helper functions
│   ├── core/           # Extended CI core classes
│   │   ├── MY_Controller.php
│   │   └── MY_Model.php
│   ├── config/         # Configuration files
│   ├── language/       # Multi-language support (80+ languages)
│   └── third_party/    # Third-party integrations
│       ├── omnipay/    # Payment gateway
│       ├── PHPMailer/
│       ├── midtrans/
│       ├── billplz/
│       └── pesapal/
├── system/             # CodeIgniter framework core
├── backend/            # Frontend assets (CSS, JS, plugins)
│   ├── js/
│   ├── plugins/
│   ├── dist/
│   ├── images/
│   └── themes/
├── uploads/            # File upload directories
│   ├── student_images/
│   ├── staff_images/
│   ├── student_documents/
│   ├── staff_documents/
│   ├── gallery/
│   └── [40+ other upload directories]
├── backup/             # Database backups
├── temp/               # Temporary files
└── index.php           # Application entry point

documentation/          # HTML documentation
smart_school_update_7.0.1_to_7.1.0/  # Update files
```

## System Architecture

### Controller Hierarchy

The application uses a custom controller hierarchy defined in `application/core/MY_Controller.php`:

1. **MY_Controller** (extends CI_Controller)
   - Base controller for all controllers
   - Auto-loads 150+ models, multiple libraries
   - Handles multi-language support based on user session
   - Sets timezone and loads session-specific language files

2. **Admin_Controller** (extends MY_Controller)
   - Used by all admin panel controllers
   - Handles authentication via `$this->auth->is_logged_in()`
   - Performs license validation via `check_license()`
   - Loads RBAC (Role-Based Access Control) library
   - Loads custom configs: app-config, ci-blog, custom_filed-config

### Role-Based Structure

The system supports multiple user roles with separate controller directories:
- **Admin**: Full system access (admin/* controllers)
- **Student/User**: Student portal (user/* controllers)
- **Parent**: Parent portal (referenced in routes)
- **Teacher**: Teacher portal (referenced in routes)
- **Accountant**: Finance management (referenced in routes)
- **Librarian**: Library management (referenced in routes)

Each role has an unauthorized route defined in `config/routes.php`.

### Key Models

Major model categories:
- **Student Management**: `student_model`, `studentsession_model`, `studentfee_model`, `studentsubjectgroup_model`
- **Staff Management**: `staff_model`, `teacher_model`, `classteacher_model`, `staffroles_model`
- **Academic**: `class_model`, `section_model`, `subject_model`, `exam_model`, `examschedule_model`
- **Finance**: `studentfeemaster_model`, `feegroup_model`, `income_model`, `expense_model`
- **Library**: `book_model`, `bookissue_model`, `librarymanagement_model`
- **Communication**: `notification_model`, `messages_model`, `chat_model`
- **Settings**: `setting_model`, `session_model`, `paymentsetting_model`

### Key Libraries

Custom libraries in `application/libraries/`:
- **Auth**: Authentication and authorization
- **Customlib**: Custom utility functions
- **Role/Rbac**: Role-based access control
- **Smsgateway**: SMS integrations (Twilio, Clickatell, etc.)
- **QDMailer**: Email handling
- **Stripe_payment/Twocheckout_payment**: Payment processing
- **Module_lib**: Module management
- **Pushnotification**: Push notifications
- **Enc_lib**: Encryption utilities

### Multi-Language Support

The application supports 80+ languages:
- Language files stored in `application/language/[lang_code]/`
- Each language has `app_files/` subdirectory with module-specific translations
- Language selection is session-based and stored in user preferences
- Language loading handled automatically in MY_Controller constructor

### Authentication Flow

1. User accesses protected route
2. Admin_Controller checks if user is logged in via `$this->auth->is_logged_in()`
3. License is validated via `check_license()` method
4. RBAC permissions are loaded
5. If unauthorized, user is redirected to role-specific unauthorized route

## Configuration

### Database Configuration
File: `application/config/database.php`
- Default database: 'ssnodb'
- Driver: mysqli
- Charset: utf8

### Environment
File: `index.php` (line 57)
- Default: `ENVIRONMENT = 'production'`
- Change to 'development' for debugging

### Base URL
File: `application/config/config.php`
- Set `$config['base_url']` appropriately
- Index page is removed via mod_rewrite

### URL Rewriting
File: `.htaccess`
- Uses mod_rewrite to remove index.php from URLs
- All requests routed through index.php

## Key Routes

Defined in `application/config/routes.php`:

```php
$route['default_controller'] = 'welcome/index';
$route['user/resetpassword/([a-z]+)/(:any)'] = 'site/resetpassword/$1/$2';
$route['admin/resetpassword/(:any)'] = 'site/admin_resetpassword/$1';
$route['online_admission'] = 'welcome/admission';
$route['cron/(:any)'] = 'cron/index/$1';
```

Unauthorized routes per role:
- `/admin/unauthorized`
- `/parent/unauthorized`
- `/student/unauthorized`
- `/teacher/unauthorized`
- `/accountant/unauthorized`
- `/librarian/unauthorized`

## Common Development Tasks

### Running the Application

1. **Web Server Setup**:
   - Ensure PHP 8.1+ is installed
   - Apache with mod_rewrite enabled
   - MySQL 5.5+ (MySQL 8 supported)

2. **Database Setup**:
   - Database schema: `application/controllers/install/database.sql`
   - Configure: `application/config/database.php`
   - Ensure SQL_MODE does not contain ONLY_FULL_GROUP_BY

3. **File Permissions**:
   - `uploads/` directory must be writable
   - `backup/` directory must be writable
   - `temp/` directory must be writable
   - `backend/captcha_images/` must be writable

4. **Access the Application**:
   - Frontend: `http://yourdomain.com/`
   - Admin panel: `http://yourdomain.com/admin`
   - Install wizard: `http://yourdomain.com/install`

### Debugging

1. **Enable Debug Mode**:
   - Edit `index.php`: Set `ENVIRONMENT` to `'development'` (line 57)
   - Edit `application/config/database.php`: Set `'db_debug' => TRUE`

2. **View Logs**:
   - CodeIgniter logs: `application/logs/`

3. **Common Issues**:
   - 404 errors: Check mod_rewrite is enabled
   - Database errors: Check SQL_MODE configuration
   - Upload issues: Check directory permissions
   - Session issues: Check session configuration in `config/config.php`

### Working with Models

Models are auto-loaded in MY_Controller constructor, so they're available in all controllers:

```php
// Models are already loaded, use them directly:
$students = $this->student_model->get();
$settings = $this->setting_model->getSetting();
```

### Adding New Features

1. **Create Controller**:
   - Admin features: `application/controllers/admin/[Name].php`
   - Extend `Admin_Controller` for admin features
   - Extend `MY_Controller` for public features

2. **Create Model**:
   - File: `application/models/[Name]_model.php`
   - Extend `CI_Model`
   - Add to auto-load in MY_Controller if used globally

3. **Create Views**:
   - Admin views: `application/views/admin/[module]/`
   - Use layout system: `layout/header.php` and `layout/footer.php`

4. **Add Routes** (if needed):
   - Edit `application/config/routes.php`

5. **Permissions**:
   - Add RBAC permissions if admin feature
   - Use `$this->rbac->check_operation_access()` in controllers

### Multi-Language

When adding new strings:

1. Add to English: `application/language/english/app_files/[module]_lang.php`
2. Use in code: `$this->lang->line('key_name')`
3. Translate to other languages as needed

### Payment Gateway Integration

Payment gateways are integrated via:
- Omnipay library (`application/third_party/omnipay/`)
- Custom gateway libraries (`application/libraries/*_lib.php`)
- Gateway settings managed in admin panel

Supported gateways include: PayPal, Stripe, Midtrans, Billplz, Pesapal

### SMS Integration

SMS providers configured in:
- Admin panel: SMS configuration
- Libraries: `application/libraries/` (Twilio.php, Clickatell.php, etc.)

### Cron Jobs

Cron controller: `application/controllers/Cron.php`
- Route: `/cron/[action]`
- Used for automated tasks (notifications, reminders, etc.)

## System Requirements

From documentation:
- PHP 8.1 or higher
- MySQL 5.5 or higher (MySQL 8 supported)
- MySQL SQL_MODE must not contain ONLY_FULL_GROUP_BY
- Apache mod_rewrite
- MBString Extension
- MySQLi Extension
- Fileinfo Extension

## Version Control Notes

- Current version: 7.1.0
- Update path: `smart_school_update_7.0.1_to_7.1.0/`
- Updates are applied in steps (step-1, step-2)

## Security Considerations

- License validation is performed on every admin request (MY_Controller)
- XSS filtering is applied via form validation
- CSRF protection available in CodeIgniter config
- File upload validation via `upload` library
- Password encryption via custom Enc_lib library
- Role-based access control (RBAC) for all admin features

## Development Best Practices

### Thorough Change Implementation

When fixing or modifying something, **always check ALL related places** where the same issue might exist:

1. **View Consistency**: If changing how data is displayed (e.g., list view), check detail/view pages, modals, print views, and export functions
2. **Role-Based Views**: Changes often need to be applied differently for admin vs user (student/parent) views:
   - Admin views: `application/views/admin/`
   - User views: `application/views/user/`
   - Consider what information is appropriate for each role
3. **Related Controllers**: If modifying a controller method, check related methods (list, view, edit, delete, ajax endpoints)
4. **Models**: If changing data structure, check all model methods that use that data

### Information Disclosure

- **Never expose internal IDs to end users**: Employee IDs, database IDs, and internal references should not be shown to students/parents
- **Admin vs Student data visibility**: Admin views can show more detail (employee IDs, internal codes), student views should only show what's necessary (names, dates, content)
- **Sensitive data patterns to watch**:
  - Employee IDs (e.g., `employee_id`)
  - Internal user IDs
  - System configuration values
  - Debug information
